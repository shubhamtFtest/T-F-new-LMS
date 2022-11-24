@IsTest(SeeAllData=false)
public class V1IndividualCustomerServiceTest {    
    @isTest
    private static void test_doPostPersonAcc(){
        Test.startTest();
        Country__c countryCode = new Country__c();
        countryCode.Name = 'United States';
        countryCode.Country_2__c = 'US';
        insert countryCode;
        String notifyJSON= '{"partyID":"","sfdcId":"","firstName":"RadhikayTest","lastName":"Test","email":"radhikayTestBanerjee03@test003.com","phoneNumber":"6678654388","address":{"addressLine1":"21 Reeve St","addressLine2":"","addressLine3":"","city":"Woodstock","countryCode":"US","state":"ON","postalCode":"N4S 3G1","country":"United States","addressType":"billing"}}';
        IndividualCustomerService.IndividualCustomer request = (IndividualCustomerService.IndividualCustomer)JSON.deserialize(notifyJSON, IndividualCustomerService.IndividualCustomer.class);
        Map<String, Object> bodyData = new Map<String,Object>();
        bodyData.put('FirstName', request.firstName);
        bodyData.put('LastName', request.lastName);
        bodyData.put('PersonEmail', request.email);
        bodyData.put('Phone', request.phoneNumber);
        bodyData.put('BillingStreet', request.address.addressLine1);
        bodyData.put('BillingCity', request.address.city);
        bodyData.put('BillingState', request.address.state);
        bodyData.put('BillingPostalCode', request.address.postalCode);
        bodyData.put('BillingCountry', request.address.country);
        IndividualCustomerInterface serviceInterface = new V1IndividualCustomerService();
        Account personAccount = serviceInterface.create(bodyData);
        Test.stopTest();
        
        List<Account> accList = [SELECT id, FirstName, LastName FROM Account WHERE PersonEmail = 'radhikayTestBanerjee03@test003.com' limit 1];
        System.assertEquals(1,accList.size());

    }
    
    @isTest
    private static void test_convertToPersonAcc(){
        
        Contact newContact = new Contact();
        newContact.email = 'test.personacc@testing.com';
        newContact.Party_Id__c = '12323657';
        newContact.FirstName = 'test01';
        newContact.LastName = 'Con01';
        insert newContact;
       
        Test.startTest();
        IndividualCustomerInterface serviceInterface = new V1IndividualCustomerService();
        Account personAccount = serviceInterface.convert('test.personacc@testing.com','12323657');
        Test.stopTest();
    }
}