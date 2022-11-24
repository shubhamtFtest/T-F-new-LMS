public class AccountApprovalNotificationHandler implements ReprocessErrors_Interface {
    
    public class AccountApprovalEvent {        
        public String requestID;
        public String accountID;
        public String partyID;
        public String bpRecordIDs;
    }
    
    public class GetPartyIdResponse {        
        public Metadata metadata ;
        public Data data ;
    }
    public class Metadata {  
        public Integer orgsCount;
        public String status ;
        public String message ;
    }
    public class Data {  
        public String contact;
        public Organisation[] organisations ;
    }
    public class  Organisation {
        public String partyId;
        public String name;
        public String parentRingGoldId;
        public String ringGoldId;
        public String sourceOrgId;
        public String organisationType;
        public String partySfdcId ; 
        public Address[] addressList;
        public String description ;  
        public String url ;
        public String sfdcEnrollment ;     
        public Integer sfdcNumberOfEmployees ;
        public String sfdcCategory ; 
        public String sfdcClassification;
        public String sfdcType ;
    }
    public class Address{
        public String city ;  
        public String state ;
        public String country ;     
        public Integer province ;
        public String postalCode ; 
        public String addressLine1;
        public String addressLine2;
        public String addressLine3;
        public Double addressId ;    
    }
    
    // Variables to be used with the error reprocessing logic.
    public static Error_Log_Items__c errorLogItemRecord; //Error_Log_Items__c being processed.
    public static Boolean isSuccess; //Variable is used to pass back to the batch class if the processing was successful.

    //Method to handle the automated reprocessing or errors.
    public Boolean reprocessAPIErrors(Error_Log_Items__c errorLogItemRecordIn){
        errorLogItemRecord = errorLogItemRecordIn;
        //Call to the processing class, passing any paramters to be used in the processing.
        AccountApprovalNotificationHandler.processRequest(errorLogItemRecord.JSON_Body__c, errorLogItemRecord.RequestURI__c);
        //If the process ran successfully pass back true, else false.
        return isSuccess;
    } 
    
    @future(callout=true)
    public static void handleAccountApprovalNotification(String requestID, String accountID, String partyID, String bpRecordID) {
        String uri;
        AccountApprovalEvent event = new AccountApprovalEvent();
        event.accountID = accountID;
        event.requestID = requestID;
        event.partyID = partyID;
        event.bpRecordIDs = bpRecordID;
        String jsonString = JSON.serialize(event);
        Boolean isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        if(!isSandbox){
            uri = 'https://api.taylorandfrancis.com/v1/customers/party/' + event.partyID;
        }else{
            uri = 'https://api-uat.taylorandfrancis.com/v1/customers/party/' + event.partyID;
        }        
        processRequest(jsonString, uri);
    }
    
    public static void processRequest (String jsonString, String URI){
        isSuccess = false;
        Map<String, String> headers = new Map<String,String>(); 
        TF_AWSService awsService = new TF_AWSService();
        AccountApprovalEvent approvalEvent = (AccountApprovalEvent)JSON.deserialize(jsonString, AccountApprovalEvent.Class);
        HttpResponse res = TF_PlatformExecuter.execute(URI, 'GET', 'idtoken', null, headers, false);
        system.debug('response:' + res);
        system.debug('response body:' + res.getBody());
        if(res.getStatusCode() == 200){
            GetPartyIdResponse getPartyIdResponse = (GetPartyIdResponse) JSON.deserialize(res.getBody(), GetPartyIdResponse.class);
            system.debug('CS REsponse :' + getPartyIdResponse);
            if(getPartyIdResponse.data.organisations == null || (getPartyIdResponse.data.organisations).size() == 0) {
                logtheIssue(jsonString,URI,res.getStatusCode());
            } else {
               System.debug('** publishing the message to SNS '+approvalEvent.requestID);
                //create json for sns msg
                String snsMessgae = generateJSONMessage(approvalEvent);
                if(snsMessgae == 'SAP BP Generation Pending'){
                    logtheSAPBPIssue(jsonString,URI,400);
                }else{
                    isSuccess = true; 
                    //publish message to SNS
                   // HttpResponse resp = awsService.postAccountSyncNotificationToSNSNamedCred(snsMessgae);
                   HttpResponse resp = awsService.postAccountSyncNotificationToSNS(snsMessgae);
                    System.debug('** SNS Response '+ resp);
                    System.debug('** SNS snsMessgae '+ snsMessgae);
                    Account_Request_Log__c reqLog = [SELECT id, Status__c from Account_Request_Log__c WHERE Request_ID__c = :approvalEvent.requestID limit 1];
                    reqLog.Status__c = 'NOTIFIED';
                    update reqLog;
                }
               
            }
        } else {
            logtheIssue(jsonString,URI,res.getStatusCode());
        }
        //If a subsequent request has been successful remove any error logs relating to that request.
        if(errorLogItemRecord == null && isSuccess){
            ReprocessErrors_utl.removeErrorsIfresolved(
                new List<String>{approvalEvent.requestID},
                'Account Approval Notification Service Error'
            );
        }         
    }
    
    private static void logtheIssue(String jsonString, String URI, Integer statusCode) {
        AccountApprovalEvent approvalEvent = (AccountApprovalEvent)JSON.deserialize(jsonString, AccountApprovalEvent.Class);
        ReprocessErrors_utl.createErrorLogItem(
          approvalEvent.requestID, //errorLogUniqueKey
          jsonString, //jsonBody
          URI, //RequestURI
          system.now(), //errorDateTime
          'The Sync for Party ID '+ approvalEvent.partyID + ' Not yet happened. Response Status code : ' + statusCode , //errorDetails
          'Account Approval Notification Service Error', //errorType
          'api', //typeOfError
          errorLogItemRecord //existingErrorLogItemRecord
        ); 
      Account_Request_Log__c reqLog = [SELECT id, Status__c from Account_Request_Log__c WHERE Request_ID__c = :approvalEvent.requestID limit 1];
      reqLog.Status__c = 'SYNC PENDING';
      update reqLog;
    }
    
    private static void logtheSAPBPIssue(String jsonString, String URI, Integer statusCode) {
        AccountApprovalEvent approvalEvent = (AccountApprovalEvent)JSON.deserialize(jsonString, AccountApprovalEvent.Class);
        ReprocessErrors_utl.createErrorLogItem(
          approvalEvent.requestID, //errorLogUniqueKey
          jsonString, //jsonBody
          URI, //RequestURI
          system.now(), //errorDateTime
          'The SAP BP number genaration for '+ approvalEvent.partyID + ' Not yet happened. Response Status code : ' + statusCode , //errorDetails
          'Account Approval Notification Service Error', //errorType
          'api', //typeOfError
          errorLogItemRecord //existingErrorLogItemRecord
        ); 
      Account_Request_Log__c reqLog = [SELECT id, Status__c from Account_Request_Log__c WHERE Request_ID__c = :approvalEvent.requestID limit 1];
      reqLog.Status__c = 'SYNC PENDING';
      update reqLog;
    }
    
    private static String generateJSONMessage(AccountApprovalEvent approvalEvent){
        String bps = '';
        Account finalAccount = new Account();
        String uuid = generateUUID();
        List<String> bpNumberSfdcIdList = new List<String>();
        List<SAP_BP__c> sapBPList = new List<SAP_BP__c>();
        finalAccount = [Select Id, Name, Ringgold_Account_ID__c  from Account where Id =: approvalEvent.accountID];
        String messageBody = '{ "headers":{"id":"'+ uuid +'","source":"Salesforce","timestamp":"'+String.valueOf(Datetime.now())+'","type":"COB","version":"1.0"},"data": {"requestId" : "'+ approvalEvent.requestID + '",';
        if(approvalEvent.accountID == null ){
            approvalEvent.accountID = '';
        }
        if(approvalEvent.partyID == null ){
            approvalEvent.partyID = '';
        }
        if(approvalEvent.bpRecordIDs == null || approvalEvent.bpRecordIDs == ''){
            approvalEvent.bpRecordIDs = '';
        }else{
            System.debug('approvalEvent.bpRecordIDs'+approvalEvent.bpRecordIDs);
            bpNumberSfdcIdList = (approvalEvent.bpRecordIDs).split(',');
        }
        if(bpNumberSfdcIdList != null && bpNumberSfdcIdList.size()>0){
            System.debug('bpNumberSfdcIdList : '+bpNumberSfdcIdList);
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
            messageBody = messageBody + '"partyId" : "' + approvalEvent.partyID + '",' + '"name" : "' + finalAccount.Name + '",' + '"ringgoldID" : "' + finalAccount.Ringgold_Account_ID__c + '",' + '"bps" : [' + bps +']}}'; 
        }else{
            messageBody = messageBody + '"partyId" : "' + approvalEvent.partyID + '",' + '"name" : "' + finalAccount.Name + '",' + '"ringgoldID" : "' + finalAccount.Ringgold_Account_ID__c + '",' + '"bps" : [' + bps.substring(0, bps.length()-1)+']}}'; 
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