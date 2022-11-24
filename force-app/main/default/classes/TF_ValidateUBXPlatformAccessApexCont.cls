public class TF_ValidateUBXPlatformAccessApexCont {
    public class UBXPlatformAccessSetupResponse {        
        public Metadata metadata ;
        public Data data ;
    }
    public class Metadata {        
        public String message ;
        public String status ;
    }
    public class Data { 
        public Integer partyId;
        public String orgName;
        public boolean ipEnabled;
        public boolean idpEnabled;
        public boolean mfaEnabledUsers;
        public boolean validAddress;
    }
    public class UBXDataWrapper { 
        @AuraEnabled
        public boolean result ;
        @AuraEnabled
        public boolean hasIP ;
        @AuraEnabled
        public boolean hasIDP ;
        @AuraEnabled
        public boolean hasMFA ;
        @AuraEnabled
        public boolean hasValidBilling ;
         
    }
    @AuraEnabled
    public static UBXDataWrapper getCalloutResponseContents(String recordId) {
        UBXDataWrapper dataList = null;
        Account account = [SELECT Name, Customer_Id__c  FROM Account WHERE id =: recordId];
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        String uri = (String) orgSpecificProps.get('Account_Setup_Status_Enpoint__c');
        String methodType = 'GET';
        Map<String, String> headers = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        HttpResponse res = TF_PlatformExecuter.execute(uri+account.Customer_Id__c+'/setup', methodType, 'idtoken', null, headers, false);
        system.debug('response:' + res);
        system.debug('response:' + res.getBody());
        if(res.getStatusCode() == 200){
            // Deserialize the JSON string into collections of primitive data types.
        	UBXPlatformAccessSetupResponse resultList = (UBXPlatformAccessSetupResponse) JSON.deserialize(res.getBody(), UBXPlatformAccessSetupResponse.class);
        	system.debug('resultsList-->' + resultList);
            dataList = new UBXDataWrapper();
			if((resultList.data.ipEnabled || resultList.data.idpEnabled || resultList.data.mfaEnabledUsers) && resultList.data.validAddress){
				dataList.result = true;
			}else{
				dataList.result = false;
			}
            dataList.hasIP = resultList.data.ipEnabled;
        	dataList.hasIDP = resultList.data.idpEnabled;
        	dataList.hasMFA = resultList.data.mfaEnabledUsers;
            dataList.hasValidBilling = resultList.data.validAddress;
				
        }
        if(res.getStatusCode() == 204){
            dataList = null;
        }
        

            /*delete from here
        		dataList = new UBXDataWrapper();
        		dataList.result = true;
                dataList.hasIP = true;
        		dataList.hasIDP = true;
        		dataList.hasMFA = true;
                dataList.hasValidBilling = true;
	//delete till here   */    
        System.debug('In controller');
        return dataList;

    }
    
    @AuraEnabled
    public static String returnPartyId(String accId){
        Account account = [SELECT Name, Customer_Id__c  FROM Account WHERE id =: accId];
        if(account.Customer_Id__c == null){
            return null;
        }else{
            return account.Customer_Id__c;
        }

    }
}