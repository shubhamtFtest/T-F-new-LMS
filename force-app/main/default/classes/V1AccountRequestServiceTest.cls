@IsTest(SeeAllData=false)
public class V1AccountRequestServiceTest {
	@isTest
    private static void test_create(){
        
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        insert testAccount;
        
        V1AccountRequestService accountRequestService = new V1AccountRequestService();
        Test.startTest();
        String contactDetails = '{"name":"Oxfordtest","ringGoldId":"121213","website":"www.oxfordtest.com","source":"OA","address":[{"addressLine1":"testaddress1","addressLine2":"testaddress2","addressLine3":"testaddress3","city":"Bangalore","state":"Karnataka","postalCode":"560100","country":"India","countryCode":"IN","addressType":"billing","taxRegistrationNumber":"SE202100306201","taxNumberCategory":"SE0"}],"ips":[{"description":"Lib Admin","iplist":"121.213.12.12:121.213.12.76","type":"standard"},{"description":"Lib Admin","iplist":"121.123.112.12:121.123.112.76","type":"standard"}],"contact":[{"firstname":"Gilbert","Lastname":"Staline","email":"gilbert.stalinetest1@gmail.com"}]}';
        ResourceV1AccountRequest.AccountRequest customerDetailref = (ResourceV1AccountRequest.AccountRequest)JSON.deserialize(contactDetails, ResourceV1AccountRequest.AccountRequest.class);
        accountRequestService.create(customerDetailref);
        Test.stopTest();
        List<Account> accountList = [SELECT id, Name FROM Account WHERE Ringgold_Account_ID__c = '121213'];
        System.assert(accountList != null);
        System.assertEquals(accountList.size(),1);
        System.assertEquals(accountList[0].Name, 'Oxfordtest');
        
        List<contact> contactList = [SELECT id, Email, FirstName, LastName, AccountId, Party_Id__c FROM Contact WHERE AccountId = :accountList[0].id];
        System.assert(contactList != null);
        System.assertEquals(contactList.size(),1);
        
        List<End_User_Access__c> ipList = [SELECT id, Account__c FROM End_User_Access__c WHERE Account__c = :accountList[0].id];
        System.assert(ipList != null);
        System.assertEquals(ipList.size(),2);
    }
    @isTest
    private static void test_create_allAddresses(){
        
        V1AccountRequestService accountRequestService = new V1AccountRequestService();
        Test.startTest();
        String contactDetails = '{"name":"Oxfordtest","ringGoldId":"121213","website":"www.oxfordtest.com","source":"OA","address":[{"addressLine1":"testaddress1","addressLine2":"testaddress2","addressLine3":"testaddress3","city":"Bangalore","state":"Karnataka","postalCode":"560100","country":"India","countryCode":"IN","addressType":"mailing","taxRegistrationNumber":"SE202100306201","taxNumberCategory":"SE0"},{"addressLine1":"testaddress1","addressLine2":"testaddress2","addressLine3":"testaddress3","city":"Bangalore","state":"Karnataka","postalCode":"560100","country":"India","countryCode":"IN","addressType":"shipping","taxRegistrationNumber":"SE202100306201","taxNumberCategory":"SE0"}],"ips":[{"description":"Lib Admin","iplist":"121.213.12.12:121.213.12.76","type":"standard"},{"description":"Lib Admin","iplist":"121.123.112.12:121.123.112.76","type":"standard"}],"contact":[{"firstname":"Gilbert","Lastname":"Staline","email":"gilbert.stalinetest1@gmail.com"},{"firstname":"Alex","Lastname":"Thomas","email":"alex.thomastest1@informa.com"}]}';
        ResourceV1AccountRequest.AccountRequest customerDetailref = (ResourceV1AccountRequest.AccountRequest)JSON.deserialize(contactDetails, ResourceV1AccountRequest.AccountRequest.class);
        accountRequestService.create(customerDetailref);
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
    private static void test_create_handleException(){
        try{ 
        V1AccountRequestService accountRequestService = new V1AccountRequestService();
        Test.startTest();
        String contactDetails = '{"name":"","ringGoldId":"","website":"www.oxfordtest.com","source":"OA","address":[{"addressLine1":"testaddress1","addressLine2":"testaddress2","addressLine3":"testaddress3","city":"Bangalore","state":"Karnataka","postalCode":"560100","country":"India","countryCode":"IN","addressType":"mailing","taxRegistrationNumber":"SE202100306201","taxNumberCategory":"SE0"},{"addressLine1":"testaddress1","addressLine2":"testaddress2","addressLine3":"testaddress3","city":"Bangalore","state":"Karnataka","postalCode":"560100","country":"India","countryCode":"IN","addressType":"shipping","taxRegistrationNumber":"SE202100306201","taxNumberCategory":"SE0"}],"ips":[{"description":"Lib Admin","iplist":"121.213.12.12:121.213.12.76","type":"standard"},{"description":"Lib Admin","iplist":"121.123.112.12:121.123.112.76","type":"standard"}],"contact":[{"firstname":"Gilbert","Lastname":"Staline","email":"gilbert.stalinetest1@gmail.com"},{"firstname":"Alex","Lastname":"Thomas","email":"alex.thomastest1@informa.com"}]}';
        ResourceV1AccountRequest.AccountRequest customerDetailref = (ResourceV1AccountRequest.AccountRequest)JSON.deserialize(contactDetails, ResourceV1AccountRequest.AccountRequest.class);
        accountRequestService.create(customerDetailref);
        Test.stopTest();
        }catch(Exception ex){
            System.debug('ex :'+ex);
               
        }
    }
    @isTest
    private static void test_create_validateRequestNameNull(){
        try{ 
        V1AccountRequestService accountRequestService = new V1AccountRequestService();
        Test.startTest();
        String contactDetails = '{"name":"","ringGoldId":"","website":"www.oxfordtest.com","source":"OA","address":[{"addressLine1":"testaddress1","addressLine2":"testaddress2","addressLine3":"testaddress3","city":"Bangalore","state":"Karnataka","postalCode":"560100","country":"India","countryCode":"IN","addressType":"mailing","taxRegistrationNumber":"SE202100306201","taxNumberCategory":"SE0"},{"addressLine1":"testaddress1","addressLine2":"testaddress2","addressLine3":"testaddress3","city":"Bangalore","state":"Karnataka","postalCode":"560100","country":"India","countryCode":"IN","addressType":"shipping","taxRegistrationNumber":"SE202100306201","taxNumberCategory":"SE0"}],"ips":[{"description":"Lib Admin","iplist":"121.213.12.12:121.213.12.76","type":"standard"},{"description":"Lib Admin","iplist":"121.123.112.12:121.123.112.76","type":"standard"}],"contact":[{"firstname":"Gilbert","Lastname":"Staline","email":"gilbert.stalinetest1@gmail.com"},{"firstname":"Alex","Lastname":"Thomas","email":"alex.thomastest1@informa.com"}]}';
        ResourceV1AccountRequest.AccountRequest customerDetailref = (ResourceV1AccountRequest.AccountRequest)JSON.deserialize(contactDetails, ResourceV1AccountRequest.AccountRequest.class);
        V1AccountRequestService.validateRequest(customerDetailref);
        Test.stopTest();
        }catch(Exception ex){
            System.debug('ex :'+ex);
               
        }
    }
    @isTest
    private static void test_create_validateRequestAddNull(){
        try{ 
        V1AccountRequestService accountRequestService = new V1AccountRequestService();
        Test.startTest();
        String contactDetailswithoutAddline1 = '{"name":"testAcc","ringGoldId":"","website":"www.oxfordtest.com","source":"OA","address":[{"addressLine1":"","addressLine2":"testaddress2","addressLine3":"testaddress3","city":"Bangalore","state":"Karnataka","postalCode":"560100","country":"India","countryCode":"IN","addressType":"billing","taxRegistrationNumber":"SE202100306201","taxNumberCategory":"SE0"},{"addressLine1":"testaddress1","addressLine2":"testaddress2","addressLine3":"testaddress3","city":"Bangalore","state":"Karnataka","postalCode":"560100","country":"India","countryCode":"IN","addressType":"shipping","taxRegistrationNumber":"SE202100306201","taxNumberCategory":"SE0"}],"ips":[{"description":"Lib Admin","iplist":"121.213.12.12:121.213.12.76","type":"standard"},{"description":"Lib Admin","iplist":"121.123.112.12:121.123.112.76","type":"standard"}],"contact":[{"firstname":"Gilbert","Lastname":"Staline","email":"gilbert.stalinetest1@gmail.com"},{"firstname":"Alex","Lastname":"Thomas","email":"alex.thomastest1@informa.com"}]}';
        ResourceV1AccountRequest.AccountRequest customerDetailref = (ResourceV1AccountRequest.AccountRequest)JSON.deserialize(contactDetailswithoutAddline1, ResourceV1AccountRequest.AccountRequest.class);
        V1AccountRequestService.validateRequest(customerDetailref);
            
         String contactDetailswithoutcity = '{"name":"testAcc","ringGoldId":"","website":"www.oxfordtest.com","source":"OA","address":[{"addressLine1":"","addressLine2":"testaddress2","addressLine3":"testaddress3","city":"","state":"Karnataka","postalCode":"560100","country":"India","countryCode":"IN","addressType":"billing","taxRegistrationNumber":"SE202100306201","taxNumberCategory":"SE0"},{"addressLine1":"testaddress1","addressLine2":"testaddress2","addressLine3":"testaddress3","city":"Bangalore","state":"Karnataka","postalCode":"560100","country":"India","countryCode":"IN","addressType":"shipping","taxRegistrationNumber":"SE202100306201","taxNumberCategory":"SE0"}],"ips":[{"description":"Lib Admin","iplist":"121.213.12.12:121.213.12.76","type":"standard"},{"description":"Lib Admin","iplist":"121.123.112.12:121.123.112.76","type":"standard"}],"contact":[{"firstname":"Gilbert","Lastname":"Staline","email":"gilbert.stalinetest1@gmail.com"},{"firstname":"Alex","Lastname":"Thomas","email":"alex.thomastest1@informa.com"}]}';
        ResourceV1AccountRequest.AccountRequest customerDetailref1 = (ResourceV1AccountRequest.AccountRequest)JSON.deserialize(contactDetailswithoutcity, ResourceV1AccountRequest.AccountRequest.class);
        V1AccountRequestService.validateRequest(customerDetailref1);
            
        String contactDetailswithoutEmail = '{"name":"testAcc","ringGoldId":"","website":"www.oxfordtest.com","source":"OA","address":[{"addressLine1":"testas","addressLine2":"testaddress2","addressLine3":"testaddress3","city":"Bangalore","state":"Karnataka","postalCode":"560100","country":"India","countryCode":"IN","addressType":"billing","taxRegistrationNumber":"SE202100306201","taxNumberCategory":"SE0"},{"addressLine1":"testaddress1","addressLine2":"testaddress2","addressLine3":"testaddress3","city":"Bangalore","state":"Karnataka","postalCode":"560100","country":"India","countryCode":"IN","addressType":"shipping","taxRegistrationNumber":"SE202100306201","taxNumberCategory":"SE0"}],"ips":[{"description":"Lib Admin","iplist":"121.213.12.12:121.213.12.76","type":"standard"},{"description":"Lib Admin","iplist":"121.123.112.12:121.123.112.76","type":"standard"}],"contact":[{"firstname":"Gilbert","Lastname":"Staline","email":""},{"firstname":"Alex","Lastname":"Thomas","email":"alex.thomastest1@informa.com"}]}';        ResourceV1AccountRequest.AccountRequest customerDetailref2 = (ResourceV1AccountRequest.AccountRequest)JSON.deserialize(contactDetailswithoutEmail, ResourceV1AccountRequest.AccountRequest.class);
        ResourceV1AccountRequest.AccountRequest customerDetailref3 = (ResourceV1AccountRequest.AccountRequest)JSON.deserialize(contactDetailswithoutEmail, ResourceV1AccountRequest.AccountRequest.class);
		V1AccountRequestService.validateRequest(customerDetailref3);
        Test.stopTest();
        }catch(Exception ex){
            System.debug('ex :'+ex);
               
        }
    }
    @isTest
    private static void test_create_validateRequestCityNull(){
        try{ 
        V1AccountRequestService accountRequestService = new V1AccountRequestService();
        Test.startTest();
        
        String contactDetailswithoutcity = '{"name":"testAcc","ringGoldId":"","website":"www.oxfordtest.com","source":"OA","address":[{"addressLine1":"","addressLine2":"testaddress2","addressLine3":"testaddress3","city":"","state":"","postalCode":"560100","country":"India","countryCode":"IN","addressType":"billing","taxRegistrationNumber":"SE202100306201","taxNumberCategory":"SE0"},{"addressLine1":"testaddress1","addressLine2":"testaddress2","addressLine3":"testaddress3","city":"Bangalore","state":"Karnataka","postalCode":"560100","country":"India","countryCode":"IN","addressType":"shipping","taxRegistrationNumber":"SE202100306201","taxNumberCategory":"SE0"}],"ips":[{"description":"Lib Admin","iplist":"121.213.12.12:121.213.12.76","type":"standard"},{"description":"Lib Admin","iplist":"121.123.112.12:121.123.112.76","type":"standard"}],"contact":[{"firstname":"Gilbert","Lastname":"Staline","email":"gilbert.stalinetest1@gmail.com"},{"firstname":"Alex","Lastname":"Thomas","email":"alex.thomastest1@informa.com"}]}';
        ResourceV1AccountRequest.AccountRequest customerDetailref1 = (ResourceV1AccountRequest.AccountRequest)JSON.deserialize(contactDetailswithoutcity, ResourceV1AccountRequest.AccountRequest.class);
        V1AccountRequestService.validateRequest(customerDetailref1);
            
        String contactDetailswithoutEmail = '{"name":"testAcc","ringGoldId":"","website":"www.oxfordtest.com","source":"OA","address":[{"addressLine1":"testas","addressLine2":"testaddress2","addressLine3":"testaddress3","city":"Bangalore","state":"Karnataka","postalCode":"560100","country":"India","countryCode":"IN","addressType":"billing","taxRegistrationNumber":"SE202100306201","taxNumberCategory":"SE0"},{"addressLine1":"testaddress1","addressLine2":"testaddress2","addressLine3":"testaddress3","city":"Bangalore","state":"Karnataka","postalCode":"560100","country":"India","countryCode":"IN","addressType":"shipping","taxRegistrationNumber":"SE202100306201","taxNumberCategory":"SE0"}],"ips":[{"description":"Lib Admin","iplist":"121.213.12.12:121.213.12.76","type":"standard"},{"description":"Lib Admin","iplist":"121.123.112.12:121.123.112.76","type":"standard"}],"contact":[{"firstname":"Gilbert","Lastname":"Staline","email":""},{"firstname":"Alex","Lastname":"Thomas","email":"alex.thomastest1@informa.com"}]}';        ResourceV1AccountRequest.AccountRequest customerDetailref2 = (ResourceV1AccountRequest.AccountRequest)JSON.deserialize(contactDetailswithoutEmail, ResourceV1AccountRequest.AccountRequest.class);
        ResourceV1AccountRequest.AccountRequest customerDetailref3 = (ResourceV1AccountRequest.AccountRequest)JSON.deserialize(contactDetailswithoutEmail, ResourceV1AccountRequest.AccountRequest.class);
		V1AccountRequestService.validateRequest(customerDetailref3);
        Test.stopTest();
        }catch(Exception ex){
            System.debug('ex :'+ex);
               
        }
    }
    
    @isTest
    private static void test_create_validateRequestEmailNull(){
        try{ 
        V1AccountRequestService accountRequestService = new V1AccountRequestService();
        Test.startTest();    
        String contactDetailswithoutEmail = '{"name":"testAcc","ringGoldId":"","website":"www.oxfordtest.com","source":"OA","address":[{"addressLine1":"testas","addressLine2":"testaddress2","addressLine3":"testaddress3","city":"Bangalore","state":"Karnataka","postalCode":"560100","country":"India","countryCode":"IN","addressType":"billing","taxRegistrationNumber":"SE202100306201","taxNumberCategory":"SE0"},{"addressLine1":"testaddress1","addressLine2":"testaddress2","addressLine3":"testaddress3","city":"Bangalore","state":"Karnataka","postalCode":"560100","country":"India","countryCode":"IN","addressType":"shipping","taxRegistrationNumber":"SE202100306201","taxNumberCategory":"SE0"}],"ips":[{"description":"Lib Admin","iplist":"121.213.12.12:121.213.12.76","type":"standard"},{"description":"Lib Admin","iplist":"121.123.112.12:121.123.112.76","type":"standard"}],"contact":[{"firstname":"Gilbert","Lastname":"Staline","email":""},{"firstname":"Alex","Lastname":"Thomas","email":"alex.thomastest1@informa.com"}]}';       
        ResourceV1AccountRequest.AccountRequest customerDetailref3 = (ResourceV1AccountRequest.AccountRequest)JSON.deserialize(contactDetailswithoutEmail, ResourceV1AccountRequest.AccountRequest.class);
		V1AccountRequestService.validateRequest(customerDetailref3);
        Test.stopTest();
        }catch(Exception ex){
            System.debug('ex :'+ex);
               
        }
    }
    @isTest
    private static void test_create_validateRequestCountryNull(){
        try{ 
        V1AccountRequestService accountRequestService = new V1AccountRequestService();
        Test.startTest();    
        String contactDetailswithoutEmail = '{"name":"testAcc","ringGoldId":"","website":"www.oxfordtest.com","source":"OA","address":[{"addressLine1":"testas","addressLine2":"testaddress2","addressLine3":"testaddress3","city":"Bangalore","state":"Karnataka","postalCode":"560100","country":"","addressType":"billing","taxRegistrationNumber":"SE202100306201","taxNumberCategory":"SE0"},{"addressLine1":"testaddress1","addressLine2":"testaddress2","addressLine3":"testaddress3","city":"Bangalore","state":"Karnataka","postalCode":"560100","country":"India","countryCode":"IN","addressType":"shipping","taxRegistrationNumber":"SE202100306201","taxNumberCategory":"SE0"}],"ips":[{"description":"Lib Admin","iplist":"121.213.12.12:121.213.12.76","type":"standard"},{"description":"Lib Admin","iplist":"121.123.112.12:121.123.112.76","type":"standard"}],"contact":[{"firstname":"Gilbert","Lastname":"Staline","email":""},{"firstname":"Alex","Lastname":"Thomas","email":"alex.thomastest1@informa.com"}]}';        ResourceV1AccountRequest.AccountRequest customerDetailref2 = (ResourceV1AccountRequest.AccountRequest)JSON.deserialize(contactDetailswithoutEmail, ResourceV1AccountRequest.AccountRequest.class);
        ResourceV1AccountRequest.AccountRequest customerDetailref3 = (ResourceV1AccountRequest.AccountRequest)JSON.deserialize(contactDetailswithoutEmail, ResourceV1AccountRequest.AccountRequest.class);
		V1AccountRequestService.validateRequest(customerDetailref3);
        Test.stopTest();
        }catch(Exception ex){
            System.debug('ex :'+ex);
               
        }
    }
}