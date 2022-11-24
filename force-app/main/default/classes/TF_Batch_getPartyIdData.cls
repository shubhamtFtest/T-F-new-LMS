public with sharing class TF_Batch_getPartyIdData implements Database.Batchable<String>,Database.AllowsCallouts {
    
    public class PartyIdResponse {
        public Metadata metadata;
        public Data data;
    }
    
    public class Metadata {
        public String message;
        public String status;
    }
    
    public class Data {
        public String partyId;
        public String orgName;
        public String ipEnabled;
        public String idpEnabled;
        public String mfaEnabledUsers;
        public String validAddress;
    }
    
    
    public Iterable<String> start(Database.BatchableContext BC) {
        
        List<String> partyIds = new List<string>();
        List<String> ListOfSeparatedPartyIds= new List<string>();
        
        //Fetch list of partyIds from setting objects's Party_Id__c field
        List<Setting__c> partyIdList = [Select Party_Id__c from Setting__c where Name='Party Id Data'];
        if(partyIdList.size() > 0){
            ListOfSeparatedPartyIds = partyIdList[0].Party_Id__c.split(',');
        }
        
        if(!ListOfSeparatedPartyIds.isEmpty()){
            for(String partyId : ListOfSeparatedPartyIds){
                partyIds.add(partyId);
            }
        }
        
        return new List<String> (partyIds);
    }
    
    public void execute(Database.BatchableContext info, List<String> partyIds) {
        
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        String uri = (String) orgSpecificProps.get('Get_PartyId_URL__c');
        
        //String uri= 'https://api-uat.taylorandfrancis.com/v1/customers/party/';
        Map<String, String> headers = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        
        HttpResponse res = new HttpResponse();
        for(String partyId : partyIds){
            
            //Put the value of partyId in our url and hit the API
            String partyIdUri = uri+partyId+'/setup';  
            
            //Hit the API using TF_PlatformExecuter class
            Party_Id_Record__c partyIdRecord = new Party_Id_Record__c();
            try {
                res = TF_PlatformExecuter.execute( partyIdUri, 'GET', 'idtoken', null, headers, false );
                System.debug('response =====>' + res + 'body--->'+res.getBody());
                if(res.getStatusCode() == 200) {
                
                    //Deserialize JSON and create a record of "Party Id Record" object
                    PartyIdResponse partyIdRes = (PartyIdResponse)JSON.deserialize(res.getBody(), PartyIdResponse.class);
                    if (partyIdRes.data  != null) {
                        partyIdRecord.Status_Checkbox__c = true;
                        partyIdRecord.Party_Id_value__c = partyId;
                        partyIdRecord.status__c = partyIdRes.metadata.status;
                        partyIdRecord.message__c = partyIdRes.metadata.message;
                        partyIdRecord.partyId__c = partyIdRes.data.partyId;
                        partyIdRecord.orgName__c = partyIdRes.data.orgName;
                        partyIdRecord.ipEnabled__c = partyIdRes.data.ipEnabled;
                        partyIdRecord.idpEnabled__c = partyIdRes.data.idpEnabled;
                        partyIdRecord.mfaEnabledUsers__c = partyIdRes.data.mfaEnabledUsers;
                        partyIdRecord.validAddress__c = partyIdRes.data.validAddress;
                        partyIdRecord.Status_Code__c = String.valueOf(res.getStatusCode());                    
                    } 
                    else {
                       partyIdRecord.Status_Checkbox__c = false; 
                       partyIdRecord.Party_Id_value__c = partyId;
                       partyIdRecord.status__c = partyIdRes.metadata.status;
                       partyIdRecord.message__c = partyIdRes.metadata.message;                        
                       partyIdRecord.partyId__c = partyId;
                       partyIdRecord.Status_Code__c = String.valueOf(res.getStatusCode());                         
                           
                    }
                    
                 } 
                 
                 else { 
                    partyIdRecord.Status_Checkbox__c = false;
                    partyIdRecord.Party_Id_value__c = partyId;  
                    partyIdRecord.status__c = 'failure';
                    partyIdRecord.message__c = 'Data with partyId not found, error code : ' + res.getStatusCode();
                    partyIdRecord.Status_Code__c = String.valueOf(res.getStatusCode()); 
                }
                
                
            } 
            
            catch (Exception ex) {
                partyIdRecord.Status_Checkbox__c = false;
                partyIdRecord.Party_Id_value__c = partyId;  
                partyIdRecord.status__c = 'failure';
                partyIdRecord.message__c = ex.getMessage();                
            }
            insert partyIdRecord;
         }
       }
    
    public void finish(Database.BatchableContext info) {}
    
}