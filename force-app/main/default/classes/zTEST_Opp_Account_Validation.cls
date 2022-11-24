@IsTest(SeeAllData=false)
public class zTEST_Opp_Account_Validation {
 
    @IsTest
    Public static void test_Opp_Account_Validation(){  
        Id recId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F Automated eBooks Opportunity');
        TriggerInterfaceHelper.runTrigger('Opp_Account_Validation', 'Opportunity', 1, 'ai', recId, null); 
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        orgSpecificProps.Account_Setup_Status_Enpoint__c = 'https://api-uat.taylorandfrancis.com/v1/customers/party/';
        insert orgSpecificProps;
          
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Customer_Id__c = '98894';
        insert testAccount;
       
        Opportunity opp = new Opportunity();  
        opp.Name = 'Test';
        opp.stageName = 'Test'; 
        opp.AccountId = testAccount.id;   
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.RecordtypeId = recId;
        insert opp;  
                
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TokenDetailsGeneratorSuccess());
        Test.stopTest();
        
    }
    
    public class TokenDetailsGeneratorSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            TokenDetails token = new TokenDetails();
            res.setStatusCode(200);
            res.setBody('{"metadata": {"message": "Organization setup found for 100","status": "success"},"data": {"partyId": 100, "orgName": " (Routledge Library Editions: Political Science Volume 28)", "ipEnabled": true,"idpEnabled": false,"mfaEnabledUsers": true, "validAddress": true }}');
            return res;
        }
    }
    class TokenDetails {
        private String details ='Token' ;
        private String access_token ='123';
        private String token_type ='123';
        private Decimal expires_in = 123;
        private String id_token='123'; 
        private String refresh_token='123';  
    }
}