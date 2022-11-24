/**
Author : Radhikay Banerjee
Apex class :  TF_LicenseCancellationRequestAPI
**/
@isTest
public class TF_LicenseCancellationRequestAPITest {
    
    static testMethod void testPostMethod()
    {  
        Record_Creation_Request__c recordRequest = new Record_Creation_Request__c();
        recordRequest.TF_Status__c = 'RECEIVED';
        recordRequest.Request_Type__c = 'Create'; 
        recordRequest.TF_RequestID__c = '0088777';
        recordRequest.TF_CallBackUrl__c = 'Provided by OMS';
        insert recordRequest;
        RestResponse response1 = new RestResponse();
        RestContext.response = response1;
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/CancelLicenseRequestAPI/doPost';
        
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf('{"orderNumber":"00882221","requestId":"0088777","requestType":"Cancelled","requestPayload":{"originalRequestID":"200","licenseID":["02i7Y000000liJfQAI","02i7Y000009liJgQAI"]},"callBackurl":"Provided by OMS"}');
        RestContext.request = request;
       TF_LicenseCancellationRequestAPI.doPost();
    
    }

}