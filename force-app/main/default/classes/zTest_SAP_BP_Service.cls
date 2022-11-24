/***************************************************************************
* Created by: Tom Reed, 2019.12.20
* Tests: SAP_BP__utl, SAP_BP_Service
* **************************************************************************/
@isTest
public class zTest_SAP_BP_Service {
    
    @isTest
    public static void zTest_SAP_BP_Service(){
        
        String randomisedString = String.ValueOf(system.now());
        
        //Construct JSON.
        String jsonString = '';
        jsonString+='{';
        jsonString+='"houseNumber": "1234",';
        jsonString+='"addressLine1": "Test Street1",';
        jsonString+='"addressLine2": "Test Address Line 2",';
        jsonString+='"addressLine3": "Test Address Line 3",';
        jsonString+='"city": "Oxford ' + randomisedString + '",'; //To keep the BP record unique.
        jsonString+='"state":"Oxfordshire",';
        jsonString+='"country": "United Kingdom",';
        jsonString+='"countryCode": "UK",';
        jsonString+='"postalCode": "OX111ST",';
        jsonString+='"addressType": "ORGANISATION",';
        jsonString+='"contactType": "",';
        jsonString+='"firstName": "Tom",';
        jsonString+='"lastName": "Reed",';
        jsonString+='"title": "Mr",';
        jsonString+='"emailAddress": "tom.reed@tandf.co.uk",';
        jsonString+='"telephone" : "07111212121",';
        jsonString+='"bpPartnerFunction": "SP",';
        jsonString+='"bpBusinessPartnerCategory" : "2",';
        jsonString+='"taxRegistrationNumber": "",';
        jsonString+='"taxNumberCategory": "",';
        jsonString+='"source": "eCommerce",';
        jsonString+='"addressUseType": "Account Billing",';
        jsonString+='"synchronousReq": true';
        jsonString+='}';
        
        

        RestResponse response = new RestResponse();
        RestContext.response = response;
        RestContext.request = mockCallout(jsonString, 'https://taylorandfrancis--devsid.my.salesforce.com/services/apexrest//generateBP/doPost');
        
        SAP_BP_Service.doPost();
        SAP_BP_Service.Response responseBody = (SAP_BP_Service.Response)JSON.deserialize(RestContext.response.responseBody.toString() , SAP_BP_Service.Response.Class);
        //Check for a failed request due to missing PartyId.
        system.assertEquals(SAP_BP_Service.ERROR_PARTYID_NOT_RECOGNISED, responseBody.message);
        
        //Make the same request with a known PartyId.
        Account testAccount = zTest_Shared.noinsertAccount(userinfo.getUserId());
        testAccount.Customer_Id__c = '12345';
        insert testAccount;

        RestContext.request = mockCallout(jsonString, '/12345/generateBP/doPost');
        SAP_BP_Service.doPost();
        SAP_BP_Service.Response responseBodySuccess = (SAP_BP_Service.Response)JSON.deserialize(RestContext.response.responseBody.toString() , SAP_BP_Service.Response.Class);
        //Check for a successful create request.
        system.assertEquals(SAP_BP_Service.SUCCESS_BP_CREATION_SUBMITTED, responseBodySuccess.message);
           
        //Test for an existing BP which is known under an existing account.
        SAP_BP__c testBP = new SAP_BP__c(Name='123456', 
                                         Account_Id__c=testAccount.Id,
                                         City__c='Oxford',
                                         State__c='OxfordShire',
                                         Country__c='United Kingdom',
                                         Street__c='Test Street1',
                                         ZIP__c='OX111ST',
                                         Email__c='tom.reed@tandf.co.uk',
                                         First_Name__c='Tom',
                                         Last_Name__c='Reed',
                                         Category__c='ORGANISATION'                                                
                                        );
        RestContext.request = mockCallout(jsonString, '/12345/generateBP/doPost');
        SAP_BP_Service.doPost();
        responseBodySuccess = (SAP_BP_Service.Response)JSON.deserialize(RestContext.response.responseBody.toString() , SAP_BP_Service.Response.Class);
        //Check for a successful request where the BP is known.
        system.assertEquals(SAP_BP_Service.SUCCESS_BP_PRESENT, responseBodySuccess.message);   
        
        //Test for an exception to be thrown while inserting the SAP_BP__c record.
        //Construct JSON.
        jsonString = '';
        jsonString+='{';
        jsonString+='"houseNumber": "1234",';
        jsonString+='"addressLine1": "Test Street1",';
        jsonString+='"addressLine2": "Test Address Line 2",';
        jsonString+='"addressLine3": "Test Address Line 3",';
        jsonString+='"city": "Oxford ' + randomisedString + '",'; //To keep the BP record unique.
        jsonString+='"state":"Oxfordshire",';
        jsonString+='"country": "United Kingdom",';
        jsonString+='"countryCode": "UK",';
        jsonString+='"postalCode": "THIS IS WRONG",';
        jsonString+='"addressType": "THIS IS WRONG",';
        jsonString+='"contactType": "",';
        jsonString+='"firstName": "Tom",';
        jsonString+='"lastName": "Reed",';
        jsonString+='"title": "Mr",';
        jsonString+='"emailAddress": "THIS@IS.com",';
        jsonString+='"telephone" : "THIS IS WRONG",';
        jsonString+='"bpPartnerFunction": "SP",';
        jsonString+='"bpBusinessPartnerCategory" : "2",';
        jsonString+='"taxRegistrationNumber": "",';
        jsonString+='"taxNumberCategory": ""';
        jsonString+='}';
        RestContext.request = mockCallout(jsonString, '/12345/generateBP/doPost');
        SAP_BP_Service.doPost();
        responseBodySuccess = (SAP_BP_Service.Response)JSON.deserialize(RestContext.response.responseBody.toString() , SAP_BP_Service.Response.Class);
        //Check for a successful request where the BP is known.
        system.assertEquals(SAP_BP_Service.ERROR_SFDC_UNABLE_TO_SUBMIT_CREATE_BP, responseBodySuccess.message);           
    }
      
    public static RestRequest mockCallout(String requestBody, String URI){
        RestRequest req = new RestRequest(); 
        req.httpMethod = 'POST';
        req.requestURI = URI;
        req.requestBody = blob.ValueOf(requestBody);        
        return req;       
    }   
    
}