@IsTest(SeeAllData=false)
public class TF_Batch_getPartyIdDataTest {

    @IsTest
    Public static void test_HitApiWithPartyIdSuccess(){
        
        Setting__c SettingObj = new Setting__c();
        SettingObj.Name = 'Party Id Data';
        SettingObj.Party_Id__c = '100362';
        insert SettingObj;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TokenDetailsGeneratorSuccess());
        Id batchJobId = Database.executeBatch(new TF_Batch_getPartyIdData(), 1);
        test.stopTest(); 
    }
    
    @IsTest
    Public static void test_HitApiWithPartyIdFailure(){
        
        Setting__c SettingObj = new Setting__c();
        SettingObj.Name = 'Party Id Data';
        SettingObj.Party_Id__c = '100362';
        insert SettingObj;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TokenDetailsGeneratorFailure());
        Id batchJobId = Database.executeBatch(new TF_Batch_getPartyIdData(), 1);
        test.stopTest(); 
    }
    
    @IsTest
    Public static void test_HitApiWithPartyIdDataNull(){
        
        Setting__c SettingObj = new Setting__c();
        SettingObj.Name = 'Party Id Data';
        SettingObj.Party_Id__c = '100362';
        insert SettingObj;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TokenDetailsGeneratorDataNull());
        Id batchJobId = Database.executeBatch(new TF_Batch_getPartyIdData(), 1);
        test.stopTest(); 
    }
    
    @IsTest
    Public static void test_HitApiWithPartyIdException(){
        
        Setting__c SettingObj = new Setting__c();
        SettingObj.Name = 'Party Id Data';
        SettingObj.Party_Id__c = '100362';
        insert SettingObj;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TokenDetailsGeneratorExceptionl());
        Id batchJobId = Database.executeBatch(new TF_Batch_getPartyIdData(), 1);
        test.stopTest(); 
    }
 
    public class TokenDetailsGeneratorSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            TokenDetails token = new TokenDetails();
            String partyIdRes = '{"metadata":{"message":"Organization setup found for 98511","status":"success"},"data":{"partyId":98511,"orgName":"Ohio State University_1","ipEnabled":true,"idpEnabled":false,"mfaEnabledUsers":true,"validAddress":true}}';
            res.setBody(partyIdRes);
            res.setStatusCode(200);
            return res;
        }
    }
    
    public class TokenDetailsGeneratorFailure implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            TokenDetails token = new TokenDetails();
            String partyIdRes = '{"metadata":{"message":"Organization setup found for 98511","status":"failure"},"data":{"partyId":98511,"orgName":"Ohio State University_1","ipEnabled":true,"idpEnabled":false,"mfaEnabledUsers":true,"validAddress":true}}';
            res.setBody(partyIdRes);
            return res;
        }
    }
    
    public class TokenDetailsGeneratorDataNull implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            TokenDetails token = new TokenDetails();
            String partyIdRes = '{"metadata":{"message":"Organization setup found for 98511","status":"failure"},"data":null}';
            res.setBody(partyIdRes);
            res.setStatusCode(200);
            return res;
        }
    }
    
    public class TokenDetailsGeneratorExceptionl implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            TokenDetails token = new TokenDetails();
            String partyIdRes = '{"metadata":{"message":"Organization setup found for 98511","status":"failure"},"data":}';
            res.setBody(partyIdRes);
            return res;
        }
    }
    
    class TokenDetails {
        private String details ='An invalid address field value has been entered, please correct and confirm.\'\"},\'' ;
        private String access_token ='123';
        private String token_type ='123';
        private Decimal expires_in = 123;
        private String id_token='123'; 
        private String refresh_token='123';
    } 
    
}