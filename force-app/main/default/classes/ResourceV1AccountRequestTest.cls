@IsTest(SeeAllData=false)
public class ResourceV1AccountRequestTest {
	@isTest
    private static void test_doPost(){
        Test.startTest();
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri ='/services/apexrest/v1/accountRequests/doPost';
        request.httpMethod = 'POST';
        String requestJSON = '{"name":"Oxfordtest","ringGoldId":"121213","website":"www.oxfordtest.com","source":"OA","address":[{"addressLine1":"testaddress1","addressLine2":"testaddress2","addressLine3":"testaddress3","city":"Bangalore","state":"Karnataka","postalCode":"560100","country":"India","countryCode":"IN","addressType":"mailing","taxRegistrationNumber":"SE202100306201","taxNumberCategory":"SE0"},{"addressLine1":"testaddress1","addressLine2":"testaddress2","addressLine3":"testaddress3","city":"Bangalore","state":"Karnataka","postalCode":"560100","country":"India","countryCode":"IN","addressType":"shipping","taxRegistrationNumber":"SE202100306201","taxNumberCategory":"SE0"}],"ips":[{"description":"Lib Admin","iplist":"121.213.12.12:121.213.12.76","type":"standard"},{"description":"Lib Admin","iplist":"121.123.112.12:121.123.112.76","type":"standard"}],"contact":[{"firstname":"Gilbert","Lastname":"Staline","email":"gilbert.stalinetest1@gmail.com"},{"firstname":"Alex","Lastname":"Thomas","email":"alex.thomastest1@informa.com"}]}';
        request.requestBody = Blob.valueof(requestJSON);
        RestContext.request = request;
        RestContext.response = res;
        ResourceV1AccountRequest.doPost();
        Test.stopTest();
        List<Account> accountList = [SELECT id, Name FROM Account WHERE Ringgold_Account_ID__c = '121213'];
        System.assert(accountList != null);
        System.assertEquals(accountList.size(),1);
        System.assertEquals(accountList[0].Name, 'Oxfordtest');
        
        List<contact> contactList = [SELECT id, Email, FirstName, LastName, AccountId, Party_Id__c FROM Contact WHERE AccountId = :accountList[0].id];
        System.assert(contactList != null);
        System.assertEquals(contactList.size(),2);
        
        List<End_User_Access__c> ipList = [SELECT id, Account__c FROM End_User_Access__c WHERE Account__c = :accountList[0].id];
        System.assert(ipList != null);
        System.assertEquals(ipList.size(),2);
    }
    
    @isTest
    private static void test_doPost_Fail(){
        Test.startTest();
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri ='/services/apexrest/v1/accountRequests/doPost';
        request.httpMethod = 'POST';
        String requestJSON = '{"name":"","ringGoldId":"121213","website":"","source":"","address":[{"addressLine1":"testaddress1","addressLine2":"testaddress2","addressLine3":"testaddress3","city":"Bangalore","state":"Karnataka","postalCode":"560100","country":"India","countryCode":"IN","addressType":"mailing","taxRegistrationNumber":"SE202100306201","taxNumberCategory":"SE0"},{"addressLine1":"testaddress1","addressLine2":"testaddress2","addressLine3":"testaddress3","city":"Bangalore","state":"Karnataka","postalCode":"560100","country":"India","countryCode":"IN","addressType":"shipping","taxRegistrationNumber":"SE202100306201","taxNumberCategory":"SE0"}],"ips":[{"description":"Lib Admin","iplist":"121.213.12.12:121.213.12.76","type":"standard"},{"description":"Lib Admin","iplist":"121.123.112.12:121.123.112.76","type":"standard"}],"contact":[{"firstname":"Gilbert","Lastname":"Staline","email":"gilbert.stalinetest1@gmail.com"},{"firstname":"Alex","Lastname":"Thomas","email":"alex.thomastest1@informa.com"}]}';
        request.requestBody = Blob.valueof(requestJSON);
        RestContext.request = request;
        RestContext.response = res;
        ResourceV1AccountRequest.doPost();
        Test.stopTest();
    }
}