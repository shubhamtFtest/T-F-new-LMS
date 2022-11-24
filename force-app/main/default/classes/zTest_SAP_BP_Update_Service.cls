@isTest
public class zTest_SAP_BP_Update_Service {
    public static RestRequest mockCallout(String requestBody, String URI){
        RestRequest req = new RestRequest(); 
        req.httpMethod = 'POST';
        req.requestURI = URI;
        req.requestBody = blob.ValueOf(requestBody);        
        return req;       
    }   
    @isTest
    public static void sapRecUpdateTest(){
        
        SAP_BP__c testSAPBP = new SAP_BP__c();
        testSAPBP.Name = '00912345';
        testSAPBP.address_line1__c = 'test address1';
        testSAPBP.City__c = 'test city';
        testSAPBP.Country__c = 'India';
        testSAPBP.ZIP__c = '560100';
        testSAPBP.Status__c = true;
        testSAPBP.Email__c = 'testemail@testing.com';
        testSAPBP.First_Name__c = 'test';
        testSAPBP.Last_Name__c = 'sapbprec';
        testSAPBP.Address_Type__c = 'Account Billing';
        insert testSAPBP;
        
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri ='/00912345/updateBP/doPut';
        request.httpMethod = 'PUT';
        String notifyJSON = '{"addressLine1":"24 Oxford St","addressLine2":"Oxford Road","addressLine3":"Oxford lane","city":"Oxford","state":"Oxfordshire","country":"United Kingdom","countryCode":"UK","postalCode":"OX111STTTT","addressType":"ORGANISATION","contactType":null,"firstName":"Radhikay","lastName":"Banerjee","title":"Ms","emailAddress":"radhikay.test04@informa.com","telephone":"6655789099","bpPartnerFunction":"SP","bpBusinessPartnerCategory":"2","taxRegistrationNumber":"GB213431455","taxNumberCategory":"GB0","source":"eCommerce","status":false,"addressUseType":"Account Billing"}';
        request.requestBody = Blob.valueof(notifyJSON);
        RestContext.request = request;
        RestContext.response = res;
        SAP_BP_Update_Service.doPut();

        
		SAP_BP__c exRecord = [SELECT Id, Name, Email__c, First_Name__c FROM SAP_BP__c WHERE Name = '00912345'];
        
        system.assertEquals('Radhikay', exRecord.First_Name__c);
         
    }
    
    @isTest
    public static void sapRecUpdateTest_SAPNOTFOUND(){
        
        SAP_BP__c testSAPBP = new SAP_BP__c();
        testSAPBP.Name = '00912341';
        testSAPBP.address_line1__c = 'test address1';
        testSAPBP.City__c = 'test city';
        testSAPBP.Country__c = 'India';
        testSAPBP.ZIP__c = '560100';
        testSAPBP.Status__c = true;
        testSAPBP.Email__c = 'testemail@testing.com';
        testSAPBP.First_Name__c = 'test';
        testSAPBP.Last_Name__c = 'sapbprec';
        testSAPBP.Address_Type__c = 'Account Billing';
        insert testSAPBP;
        
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri ='/00912345/updateBP/doPut';
        request.httpMethod = 'PUT';
        String notifyJSON = '{"addressLine1":"24 Oxford St","addressLine2":"Oxford Road","addressLine3":"Oxford lane","city":"Oxford","state":"Oxfordshire","country":"United Kingdom","countryCode":"UK","postalCode":"OX111STTTT","addressType":"ORGANISATION","contactType":null,"firstName":"Radhikay","lastName":"Banerjee","title":"Ms","emailAddress":"radhikay.test04@informa.com","telephone":"6655789099","bpPartnerFunction":"SP","bpBusinessPartnerCategory":"2","taxRegistrationNumber":"GB213431455","taxNumberCategory":"GB0","source":"eCommerce","status":false,"addressUseType":"Account Billing"}';
        request.requestBody = Blob.valueof(notifyJSON);
        RestContext.request = request;
        RestContext.response = res;
        SAP_BP_Update_Service.doPut();

        
		SAP_BP__c exRecord = [SELECT Id, Name, Email__c, First_Name__c FROM SAP_BP__c WHERE Name = '00912341'];
        
        system.assertEquals('test', exRecord.First_Name__c);
         
    }

}