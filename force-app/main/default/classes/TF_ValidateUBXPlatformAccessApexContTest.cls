@isTest(seeAllData=false)
public class TF_ValidateUBXPlatformAccessApexContTest implements HttpCalloutMock{
    private integer statusCode;
    private String responseJson;
            
    private static String mockJsonResponse_Success = '{"metadata": {"message": "Organization setup found for 100","status": "success"},"data": {"partyId": 100, "orgName": " (Routledge Library Editions: Political Science Volume 28)", "ipEnabled": true,"idpEnabled": false,"mfaEnabledUsers": true, "validAddress": true }}';

    private static String mockJsonResponse_Error = '{ "ringgold_id": 5629, "name": "University of Oxford", "body_type": "C","post_code": "OX2 0EW","org_type": "Academic/Ag","place":{ "language": "string", "city": "OXFORD", "state": "OX","country_code": "United Kingdom"},"consortia_members": [{ "member_ringgold_id": 0,"name": "string"} ],"urls": [{  "url": "www.ox.ac.uk","type": "PD"}],"data": [{"size": 19919,"staff": 6470}],"classifications": {"rg_tier": "A3", "sfj_tier": "2.2", "carnegie": {"SizeSet2015": "14","BASIC2010": "18", "SizeSet2005": "13", "BASIC2005": "18", "SizeSet2010": "14", "BASIC2015": "18"}},"identifiers": [{"athens": "string", "ipeds": "string","isni": "string", "nacs": "string","nces": "string", "ofr": "string"}],"alt_names": [{"name": "Oxford University","type": "string", "place": {"language": "string","city": "string","country_code": "string"}}]}';

    public TF_ValidateUBXPlatformAccessApexContTest(integer statusCode, String responseJson){
        this.statusCode = statusCode;
        this.responseJson = responseJson;
    }
    
     public HTTPResponse respond(HTTPRequest req) {
       // Create a mock response
        HttpResponse resp = new HttpResponse();
        resp.setHeader('Content-Type', 'application/json');
        resp.setBody(responseJson);      
        resp.setStatusCode(statusCode);
        return resp;
    }
      
     @istest 
     private static void test_getCalloutResponseContents_Success(){
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Customer_Id__c = '98894';
        insert testAccount;  
         
         Test.startTest();
         Test.setMock(HttpCalloutMock.class, new TF_ValidateUBXPlatformAccessApexContTest(200, mockJsonResponse_Success));
         TF_ValidateUBXPlatformAccessApexCont.UBXDataWrapper responseData = TF_ValidateUBXPlatformAccessApexCont.getCalloutResponseContents(testAccount.id);
         System.assert(responseData != null);
         System.assertEquals(true, responseData.result);
         Test.stopTest();
     }
     
     @istest 
     private static void test_getCalloutResponseContents_Failure(){
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Customer_Id__c = '98894';
        insert testAccount;
         
         Test.startTest();
         Test.setMock(HttpCalloutMock.class, new TF_ValidateUBXPlatformAccessApexContTest(403, mockJsonResponse_Error));
         TF_ValidateUBXPlatformAccessApexCont.getCalloutResponseContents(testAccount.id);
         Test.stopTest();
     }
     
     @istest 
     private static void test_returnPartyId(){
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Customer_Id__c = '98894';
        insert testAccount;
         
         Test.startTest();
         String partyId = TF_ValidateUBXPlatformAccessApexCont.returnPartyId(testAccount.id);
         Test.stopTest();
         System.assertEquals('98894', partyId);
     }
}