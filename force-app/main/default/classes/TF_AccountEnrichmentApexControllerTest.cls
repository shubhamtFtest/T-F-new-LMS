/**
* @author       Radhikay Banerjee       
* @date         09/09/2019
* @description  Test class for TF_AccountEnrichmentApexController.
*/

@isTest(seeAllData=false)
Public class TF_AccountEnrichmentApexControllerTest implements HttpCalloutMock{
    private integer statusCode;
    private String responseJson;
    private static String ringgoldId = '5629';
            
    private static String mockJsonResponse_Success = '{ "ringgold_id": 5629, "name": "University of Oxford", "body_type": "C","post_code": "OX2 0EW","org_type": "Academic/Ag","place":{ "language": "string", "city": "OXFORD", "state": "OX","country_code": "United Kingdom"},"consortia_members": [{ "member_ringgold_id": 0,"name": "string"} ],"urls": [{  "url": "www.ox.ac.uk","type": "PD"}],"data": [{"size": 19919,"staff": 6470}],"classifications": {"rg_tier": "A3", "sfj_tier": "2.2", "carnegie": {"SizeSet2015": "14","BASIC2010": "18", "SizeSet2005": "13", "BASIC2005": "18", "SizeSet2010": "14", "BASIC2015": "18"}},"identifiers": [{"athens": "string", "ipeds": "string","isni": "string", "nacs": "string","nces": "string", "ofr": "string"}],"alt_names": [{"name": "Oxford University","type": "string", "place": {"language": "string","city": "string","country_code": "string"}}]}';

    private static String mockJsonResponse_Error = '{ "ringgold_id": 5629, "name": "University of Oxford", "body_type": "C","post_code": "OX2 0EW","org_type": "Academic/Ag","place":{ "language": "string", "city": "OXFORD", "state": "OX","country_code": "United Kingdom"},"consortia_members": [{ "member_ringgold_id": 0,"name": "string"} ],"urls": [{  "url": "www.ox.ac.uk","type": "PD"}],"data": [{"size": 19919,"staff": 6470}],"classifications": {"rg_tier": "A3", "sfj_tier": "2.2", "carnegie": {"SizeSet2015": "14","BASIC2010": "18", "SizeSet2005": "13", "BASIC2005": "18", "SizeSet2010": "14", "BASIC2015": "18"}},"identifiers": [{"athens": "string", "ipeds": "string","isni": "string", "nacs": "string","nces": "string", "ofr": "string"}],"alt_names": [{"name": "Oxford University","type": "string", "place": {"language": "string","city": "string","country_code": "string"}}]}';

    public TF_AccountEnrichmentApexControllerTest(integer statusCode, String responseJson){
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
        testAccount.Customer_Id__c = '123';
        testAccount.Ringgold_Account_ID__c = '5629';
        insert testAccount;  
         
         Test.startTest();
         Test.setMock(HttpCalloutMock.class, new TF_AccountEnrichmentApexControllerTest(200, mockJsonResponse_Success));
         List <TF_AccountEnrichmentApexController.FieldData> responseData = TF_AccountEnrichmentApexController.getCalloutResponseContents(testAccount.id,testAccount.Ringgold_Account_ID__c);
         System.assert(responseData != null);
         Test.stopTest();
     }
     
     @istest 
     private static void test_getCalloutResponseContents_Failure(){
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Customer_Id__c = '123';
        testAccount.Ringgold_Account_ID__c = '5629';
        insert testAccount;
         
         Test.startTest();
         Test.setMock(HttpCalloutMock.class, new TF_AccountEnrichmentApexControllerTest(403, mockJsonResponse_Error));
         TF_AccountEnrichmentApexController.getCalloutResponseContents(testAccount.id, testAccount.Ringgold_Account_ID__c);
         Test.stopTest();
     }
     
     @istest 
     private static void test_updateAccFields(){
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Customer_Id__c = '123';
        testAccount.Ringgold_Account_ID__c = '5629';
        insert testAccount;
        
        String dataValueList = '[{"isEqualData": true, "fieldAPIName": "Name"},{"isEqualData": true, "fieldAPIName": "Tier__c"},{"isEqualData": true, "fieldAPIName": "Enrollment__c"}]';


        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TF_AccountEnrichmentApexControllerTest(200, mockJsonResponse_Success));
        List <TF_AccountEnrichmentApexController.FieldData> responseData = TF_AccountEnrichmentApexController.getCalloutResponseContents(testAccount.id, testAccount.Ringgold_Account_ID__c);
        TF_AccountEnrichmentApexController.updateAccFields(dataValueList, testAccount.id, JSON.serialize(responseData));
        Test.stopTest();
     }
      
}