global class OnBoardingRetryBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    public String uri;
    public TF_AWSService awsService;
    public Map<String, String> headers; 

    global database.querylocator start(Database.BatchableContext BC) {
        String newStatus = 'NEW';
        String notifiedStatus = 'NOTIFIED';
        String query = 'SELECT Name, BP_Numbers__c, Party_ID__c, Request_ID__c, Request_JSON__c, Source__c, Status__c, Account_ID__c FROM Account_Request_Log__c WHERE Status__c !=: newStatus AND Status__c !=:notifiedStatus';
        System.debug('OnBoardingRetryBatch SOQL = ' + query);
        return Database.getQueryLocator(query);        

    }
    global void execute(Database.BatchableContext BC, List<sObject> scope){
   		System.debug('OnBoardingRetryBatch: Inside execute');
        System.debug('scope: '+scope);
        System.debug('scope size: '+scope.size());
        Boolean isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        if(!isSandbox){
        	uri = 'https://api.taylorandfrancis.com/v1/customers/party/';
        } else {
            uri = 'https://api-uat.taylorandfrancis.com/v1/customers/party/';
        }
        awsService = new TF_AWSService();
        headers = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        System.debug('url 1: '+uri);
        List<Account_Request_Log__c> successList = new List<Account_Request_Log__c>();
        for(sobject s : scope) {
            Account_Request_Log__c log = (Account_Request_Log__c)s;
            String getPartyURI = uri + log.Party_ID__c;
            System.debug('headers: '+getPartyURI);
            System.debug('url: '+uri);
            HttpResponse res = TF_PlatformExecuter.execute(getPartyURI, 'GET', 'idtoken', null, headers, false);
            system.debug('response:' + res);
        	system.debug('response body:' + res.getBody());
            if(res.getStatusCode() == 200){
            	AccountApprovalNotificationHandler.GetPartyIdResponse getPartyIdResponse = (AccountApprovalNotificationHandler.GetPartyIdResponse) JSON.deserialize(res.getBody(), AccountApprovalNotificationHandler.GetPartyIdResponse.class);
        		system.debug('CS REsponse :' + getPartyIdResponse);
                if(getPartyIdResponse.data.organisations != null && (getPartyIdResponse.data.organisations).size() > 0) {
                    String snsMessgae = generateJSONMessage(log.Request_ID__c, log.Account_ID__c,log.Party_ID__c,log.BP_Numbers__c);
                    System.debug('Generated SNS message : ' + snsMessgae);
                    if(snsMessgae != 'SAP BP Generation Pending') {
                        //publish message to SNS
                        HttpResponse resp = awsService.postAccountSyncNotificationToSNSNamedCred(snsMessgae);
                        System.debug('** SNS Response '+ resp);
                        System.debug('** SNS snsMessgae '+ snsMessgae);
                        
                        log.Status__c = 'NOTIFIED';   
                        
                        successList.add(log);
                    }
                }
            }
        }
        if(successList.size() > 0) {
            database.update(successList);
        }
        
    }    
    global void finish(Database.BatchableContext BC){
    	System.debug('OnBoardingRetryBatch: finish');
    }    

    private static String generateJSONMessage(Id requestID ,Id accountID, String partyID, String bpRecordIDs){
        String bps = '';
        Account finalAccount = new Account();
        String uuid = generateUUID();
        List<String> bpNumberSfdcIdList = new List<String>();
        List<SAP_BP__c> sapBPList = new List<SAP_BP__c>();
        finalAccount = [Select Id, Name, Ringgold_Account_ID__c  from Account where Id =:accountID];
        String messageBody = '{ "headers":{"id":"'+ uuid +'","source":"Salesforce","timestamp":"'+String.valueOf(Datetime.now())+'","type":"COB","version":"1.0"},"data": {"requestId" : "'+ requestID + '",';
        if(accountID == null ){
            accountID = '';
        }
        if(partyID == null ){
            partyID = '';
        }
        if(bpRecordIDs == null || bpRecordIDs == ''){
            bpRecordIDs = '';
        }else{
            System.debug('approvalEvent.bpRecordIDs'+bpRecordIDs);
            bpNumberSfdcIdList = (bpRecordIDs).split(',');
        }
        if(bpNumberSfdcIdList != null && bpNumberSfdcIdList.size()>0){
            sapBPList = [Select Id, name, First_Name__c , Last_Name__c ,Email__c  from SAP_BP__c where Id IN: bpNumberSfdcIdList];
            if(sapBPList != null && sapBPList.size() > 0){
                bps = '{';
                for(SAP_BP__c thisSAPBP : sapBPList){
                    if(thisSAPBP.Name == 'PENDING'){
                    	return 'SAP BP Generation Pending';    
                    }
                    if(thisSAPBP.First_Name__c == null){
                    	thisSAPBP.First_Name__c = '';
                    }
                    if(thisSAPBP.Last_Name__c == null){
                    	thisSAPBP.Last_Name__c = '';
                    }
                    if(thisSAPBP.Email__c == null){
                    	thisSAPBP.Email__c = '';
                    }
                    bps = bps + '"firstname" : "' + thisSAPBP.First_Name__c + '",' + '"Lastname " : "' + thisSAPBP.Last_Name__c + '",'+ '"email " : "' + thisSAPBP.Email__c + '",' + '"bp " : "' + thisSAPBP.Name + '"'+ '},';
                }
            }
        }
        System.debug('bps'+bps);
        if(bps == null || bps == ''){
            messageBody = messageBody + '"partyId" : "' + partyID + '",' + '"name" : "' + finalAccount.Name + '",' + '"ringgoldID" : "' + finalAccount.Ringgold_Account_ID__c + '",' + '"bps" : [' + bps +']}}'; 
        }else{
            messageBody = messageBody + '"partyId" : "' + partyID + '",' + '"name" : "' + finalAccount.Name + '",' + '"ringgoldID" : "' + finalAccount.Ringgold_Account_ID__c + '",' + '"bps" : [' + bps.substring(0, bps.length()-1)+']}}'; 
		}
        System.debug('SNS messageBody'+messageBody);
        return messageBody;
    }

    private static String generateUUID()
    {
        String hashString = '1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
        String hexDigest = EncodingUtil.convertToHex(hash);
        return hexDigest;
        
    }    
}