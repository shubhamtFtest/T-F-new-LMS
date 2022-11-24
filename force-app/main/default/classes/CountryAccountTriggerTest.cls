@isTest(seeAllData=false)
public class CountryAccountTriggerTest {
    @istest 
     private static void test_SAPBPCreation_Success(){
        Id thirdPartyRTID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Third Party Account Request').getRecordTypeId();
        Id tnfRTID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        
        TF_OrgSpecificProps__c  rinngoldAPI = new TF_OrgSpecificProps__c ();
        rinngoldAPI.RingGold_Fuzzy_Api_Endpoint__c  =   'https://api-uat.taylorandfrancis.com/v1/search/ringgold';
        rinngoldAPI.Search_Result_Limit__c = '10';
        insert rinngoldAPI;
         
        Country__c countryCode = new Country__c();
        countryCode.Name = 'India';
        countryCode.Country_2__c = 'IN';
        insert countryCode;
        
         Account testAccount = new Account();
         testAccount.name = 'Test Account';
         testAccount.website = 'TestAccount@xyz.com';
         testAccount.BillingCity = 'Test City';
         testAccount.BillingStreet = 'Test street';
         testAccount.Mailing_Country_List__c = 'India';
         testAccount.BillingPostalCode = '23398';
         testAccount.Mailing_State_List__c = 'XY';
         testAccount.type = 'Agent';
         testAccount.Customer_Id__c = '123';
         testAccount.RecordTypeId = thirdPartyRTID;
         insert testAccount;
         
         Contact newContact = new Contact();
        newContact.email = 'test1234@xyz.com';
        newContact.Party_Id__c = '12323657';
        newContact.FirstName = 'test';
        newContact.LastName = 'con01';
         newContact.AccountId = testAccount.id;
        insert newContact;
        
         Test.startTest();
         testAccount.RecordTypeId = tnfRTID;
         update testAccount;
         Test.stopTest();
        
       
     }
     
     @istest 
     private static void test_SAPBPCreation_matchFound(){
        Id thirdPartyRTID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Third Party Account Request').getRecordTypeId();
        Id tnfRTID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        
        TF_OrgSpecificProps__c  rinngoldAPI = new TF_OrgSpecificProps__c ();
        rinngoldAPI.RingGold_Fuzzy_Api_Endpoint__c  =   'https://api-uat.taylorandfrancis.com/v1/search/ringgold';
        rinngoldAPI.Search_Result_Limit__c = '10';
        insert rinngoldAPI;
        SAP_BP__c testSAPBP = new SAP_BP__c();
         testSAPBP.Street__c = 'Test street';
         testSAPBP.Country__c = 'India';
         testSAPBP.ZIP__c = '560100';
         testSAPBP.City__c = 'Bengaluru';
         testSAPBP.Email__c = 'test1234@xyz.com';
         testSAPBP.First_Name__c = 'Test';
         testSAPBP.Last_Name__c = 'Con1';
         testSAPBP.Address_Type__c = 'Account Mailing';
         insert testSAPBP;
        Country__c countryCode = new Country__c();
        countryCode.Name = 'India';
        countryCode.Country_2__c = 'IN';
        insert countryCode;
         Account testAccount = new Account();
         testAccount.name = 'Test Account';
         testAccount.website = 'TestAccount@xyz.com';
         testAccount.BillingCity = 'Bengaluru';
         testAccount.BillingStreet = 'Test street';
         testAccount.Mailing_Country_List__c = 'India';
         testAccount.BillingPostalCode = '560100';
         testAccount.Mailing_State_List__c = 'XY';
         testAccount.type = 'Agent';
         testAccount.Customer_Id__c = '123';
         testAccount.RecordTypeId = thirdPartyRTID;
         insert testAccount;
         
         Contact newContact = new Contact();
        newContact.email = 'test1234@xyz.com';
        newContact.Party_Id__c = '12323657';
        newContact.FirstName = 'Test';
        newContact.LastName = 'Con01';
         newContact.AccountId = testAccount.id;
        insert newContact;
        
         Test.startTest();
         testAccount.RecordTypeId = tnfRTID;
         update testAccount;
         Test.stopTest();
        
       
     }
     @istest 
     private static void test_SAPBPCreation_SourceOASuccess(){
        Id thirdPartyRTID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Third Party Account Request').getRecordTypeId();
        Id tnfRTID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        
        TF_OrgSpecificProps__c  rinngoldAPI = new TF_OrgSpecificProps__c ();
        rinngoldAPI.RingGold_Fuzzy_Api_Endpoint__c  =   'https://api-uat.taylorandfrancis.com/v1/search/ringgold';
        rinngoldAPI.Search_Result_Limit__c = '10';
        insert rinngoldAPI;
         
        Country__c countryCode = new Country__c();
        countryCode.Name = 'India';
        countryCode.Country_2__c = 'IN';
        insert countryCode;
        
         Account testAccount = new Account();
         testAccount.name = 'Test Account';
         testAccount.website = 'TestAccount@xyz.com';
         testAccount.BillingCity = 'Test City';
         testAccount.BillingStreet = 'Test street';
         testAccount.Mailing_Country_List__c = 'India';
         testAccount.BillingPostalCode = '23398';
         testAccount.Mailing_State_List__c = 'XY';
         testAccount.type = 'Agent';
         testAccount.Customer_Id__c = '123';
         testAccount.RecordTypeId = thirdPartyRTID;
         testAccount.Source_of_Account__c = 'OA';
         insert testAccount;
         
         Contact newContact = new Contact();
        newContact.email = 'test1234@xyz.com';
        newContact.Party_Id__c = '12323657';
        newContact.FirstName = 'test';
        newContact.LastName = 'con01';
         newContact.AccountId = testAccount.id;
        insert newContact;
        
         Test.startTest();
         testAccount.RecordTypeId = tnfRTID;
         update testAccount;
         Test.stopTest();
        
       
     }
     
     @istest 
     private static void test_SAPBPCreation_SourceEbookSuccess(){
        Id thirdPartyRTID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Third Party Account Request').getRecordTypeId();
        Id tnfRTID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        
        TF_OrgSpecificProps__c  rinngoldAPI = new TF_OrgSpecificProps__c ();
        rinngoldAPI.RingGold_Fuzzy_Api_Endpoint__c  =   'https://api-uat.taylorandfrancis.com/v1/search/ringgold';
        rinngoldAPI.Search_Result_Limit__c = '10';
        insert rinngoldAPI;
         
        Country__c countryCode = new Country__c();
        countryCode.Name = 'India';
        countryCode.Country_2__c = 'IN';
        insert countryCode;
        
         Account testAccount = new Account();
         testAccount.name = 'Test Account';
         testAccount.website = 'TestAccount@xyz.com';
         testAccount.BillingCity = 'Test City';
         testAccount.BillingStreet = 'Test street';
         testAccount.Mailing_Country_List__c = 'India';
         testAccount.BillingPostalCode = '23398';
         testAccount.Mailing_State_List__c = 'XY';
         testAccount.type = 'Agent';
         testAccount.Customer_Id__c = '123';
         testAccount.RecordTypeId = thirdPartyRTID;
         testAccount.Source_of_Account__c = 'ebook-intermediaries';
         insert testAccount;
         
         Contact newContact = new Contact();
        newContact.email = 'test1234@xyz.com';
        newContact.Party_Id__c = '12323657';
        newContact.FirstName = 'test';
        newContact.LastName = 'con01';
         newContact.AccountId = testAccount.id;
        insert newContact;
        
         Test.startTest();
         testAccount.RecordTypeId = tnfRTID;
         update testAccount;
         Test.stopTest();
        
       
     }
     

}