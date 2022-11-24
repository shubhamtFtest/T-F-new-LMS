@IsTest(SeeAllData=false)
public class ConvertContactToPersonAccountTest {
    @isTest
    private static void test_convertToPersonAcc(){
        Country__c countryCode = new Country__c();
        countryCode.Name = 'United States';
        countryCode.Country_2__c = 'US';
        insert countryCode;
        User testUser = new User();
        testUser.username = 'testuser123@fgg.com';
        testUser.firstName='FName';
        testUser.LastName='LName';
        testUser.Email='testuser@xyz.com';
        testUser.Alias='Test';
        testUser.TimeZoneSidKey='GMT';
        testUser.LocaleSidKey='en_US';
        testUser.EmailEncodingKey='ISO-8859-1';
        SObject profTest = [ select id from profile where Name= 'System Administrator' LIMIT 1];
        testUser.ProfileId=(ID) profTest.get('ID'); 
        testUser.LanguageLocaleKey = 'en_US';
        testUser.CommunityNickname = 'Test01';
        insert  testUser;
        
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        testAccount.BillingCity = 'Bangalore';
        testAccount.BillingState = 'Karnataka';
        testAccount.BillingPostalCode = '560100';
        testAccount.BillingCountry = 'India';
        testAccount.Website = 'www.testAcc.com';
        testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        testAccount.Ringgold_Account_ID__c = '546670';
        testAccount.OwnerId = testUser.id;
        insert testAccount;
        
        Contact newContact = new Contact();
        newContact.email = 'test.personacc@testing.com';
        newContact.Party_Id__c = '00323657';
        newContact.FirstName = 'test01';
        newContact.LastName = 'Con01';
        newContact.AccountId = testAccount.id;
        newContact.OwnerId = testUser.id;
        insert newContact;
        
        ID oldAccountID = newContact.AccountId; 
      String contactPartyID = newContact.Party_Id__c;
      String nameOfTheAccount =  newContact.FirstName + ' ' + newContact.LastName;
      Account newPersonAccount = new Account();
      newPersonAccount.name = nameOfTheAccount;
      newPersonAccount.Customer_Id__c = contactPartyID;
      newPersonAccount.OwnerId = newContact.OwnerId;
        newPersonAccount.BillingCity = 'Woodstock';
        newPersonAccount.BillingPostalCode = 'N4S 3G1';
        newPersonAccount.BillingCountry = 'United States';
        newPersonAccount.BillingStreet = 'test street 1';
      insert newPersonAccount;
       
        Test.startTest();
        ConvertContactToPersonAccount.convertAcc(newContact.id,newPersonAccount.id);
        Test.stopTest();
    }
}