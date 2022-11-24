/*
 * Created by: Matthew Smith on 18.05.2020
 * Test class for PardotACRSharing_Trig @ 100% and ContactPardotACRSharing_Trig @100%
*/

@isTest
public class zTest_PardotSharing {
    
    
    @testSetup
    private static void testDataSetup(){
        
        test.startTest();
		//creating test account
        RecordType recordTypeNameAccount = [select Name from recordtype where sObjectType = 'Account' and Name = 'T&F - Accounts'];
        
        Account testAccount = new Account();
        testAccount.RecordTypeId = recordTypeNameAccount.Id;
        testAccount.Name = 'test account';
        testAccount.Mailing_Country_List__c = 'United Kingdom';
        insert testAccount;
        
        //creating test contact
        RecordType recordTypeNameContact = [select Name from recordtype where sObjectType = 'Contact' and Name = 'T&F - Contacts'];
        
        
        Contact testContact = new Contact();
        testContact.AccountId = testAccount.Id;
        testContact.FirstName = 'Matthew';
        testContact.LastName = 'Smith';
        testContact.Email = 'matthew.smith.gb1@mlg1337.co.uk';
        testContact.Phone = '012345678910';
        testContact.RecordTypeId = recordTypeNameContact.Id;
        insert testContact;
        
        Contact testContact1 = new Contact();
        testContact1.AccountId = testAccount.Id;
        testContact1.FirstName = 'Matthew';
        testContact1.LastName = 'Smith';
        testContact1.Email = 'matthew.smith@tandf.co.uk';
        testContact1.Phone = '012345678910';
        testContact1.Status__c = 'Active';
        testContact1.Mailing_Country_List__c = 'Cuba';
        testContact1.RecordTypeId = recordTypeNameContact.Id;
        insert testContact1;
        
        TriggerInterfaceHelper.runTrigger('PardotACRSharing_Trig', 'AccountContactRole__c', 99, 'ai,au', recordTypeNameContact.Id, null);
        
        //creating ACR
        AccountContactRole__c acr = new AccountContactRole__c();
        acr.AccountID__c = testAccount.Id;
        acr.ContactID__c = testContact.Id;
        acr.Account_Contact_Role__c = 'Article Purchaser';
        acr.Active__c = true;
        insert acr;
        
        AccountContactRole__c acr2 = new AccountContactRole__c();
        acr2.AccountID__c = testAccount.Id;
        acr2.ContactID__c = testContact.Id;
        acr2.Account_Contact_Role_Level_2_del1__c = 'Instructor';
        acr2.Active__c = true;
        insert acr2;
        
        AccountContactRole__c acr3 = new AccountContactRole__c();
        acr3.AccountID__c = testAccount.Id;
        acr3.ContactID__c = testContact.Id;
        acr3.Account_Contact_Role_Level_3_del1__c = 'Researcher';
        acr3.Active__c = true;
        insert acr3;
        
        AccountContactRole__c acr4 = new AccountContactRole__c();
        acr4.AccountID__c = testAccount.Id;
        acr4.ContactID__c = testContact.Id;
        acr4.Account_Contact_Role__c = 'test';
        acr4.Active__c = true;
        insert acr4;
        
        AccountContactRole__c acr5 = new AccountContactRole__c();
        acr5.AccountID__c = testAccount.Id;
        acr5.ContactID__c = testContact1.Id;
        acr5.Account_Contact_Role__c = 'Instructor';
        acr5.Active__c = true;
        insert acr5;
    
        test.stopTest();
        
    }
    
    //@isTest
    private static void pardotContactMatch(){
        
        RecordType recordTypeNameContact = [select Name from recordtype where sObjectType = 'Contact' and Name = 'T&F - Contacts'];
        TriggerInterfaceHelper.runTrigger('ContactPardotACRSharing_Trig', 'Contact', 99, 'au', recordTypeNameContact.Id, null);
        
        
        Contact testContact = [SELECT Id FROM Contact WHERE Email = 'matthew.smith.gb1@mlg1337.co.uk'];
        
        test.startTest();
        testContact.Status__c = 'Active';
        testContact.optin_optout_status__c = 'Explicit Opt-In';
        testContact.Mailing_Country_List__c = 'United Kingdom';
        update testContact;
        test.stopTest();
    }
    
   //@isTest
    private static void pardotContactNonMatch(){
        
        RecordType recordTypeNameContact = [select Name from recordtype where sObjectType = 'Contact' and Name = 'T&F - Contacts'];
        TriggerInterfaceHelper.runTrigger('ContactPardotACRSharing_Trig', 'Contact', 99, 'au', recordTypeNameContact.Id, null);
        
        Contact testContact = [SELECT Id FROM Contact WHERE Email = 'matthew.smith.gb1@mlg1337.co.uk'];
        
        test.startTest();
        testContact.Status__c = 'Inactive';
        testContact.optin_optout_status__c = 'Implicit Opt-In';
        testContact.Mailing_Country_List__c = 'Cuba';
        testContact.Email = 'matthew.smith@tandf.com';
        update testContact;
        test.stopTest();
    }
    
    @isTest
    private static void pardotContactOverride(){
        
        RecordType recordTypeNameContact = [select Name from recordtype where sObjectType = 'Contact' and Name = 'T&F - Contacts'];
        TriggerInterfaceHelper.runTrigger('ContactPardotACRSharing_Trig', 'Contact', 99, 'au', recordTypeNameContact.Id, null);
        
        Contact testContact = [SELECT Id FROM Contact WHERE Email = 'matthew.smith.gb1@mlg1337.co.uk'];
        
        test.startTest();
		testContact.Override_Pardot_Sharing__c = true;
        update testContact;
        test.stopTest();
    }

    
    @isTest
    private static void pardotACR(){
        
        RecordType recordTypeNameContact = [select Name from recordtype where sObjectType = 'Contact' and Name = 'T&F - Contacts'];
        TriggerInterfaceHelper.runTrigger('PardotACRSharing_Trig', 'AccountContactRole__c', 99, 'ai,au', recordTypeNameContact.Id, null);
        
        Contact testContact = [SELECT Id FROM Contact WHERE Email = 'matthew.smith.gb1@mlg1337.co.uk'];
        
        AccountContactRole__c testACR = [SELECT Id FROM AccountContactRole__c WHERE ContactID__r.email = 'matthew.smith.gb1@mlg1337.co.uk' AND Account_Contact_Role__c = 'Article Purchaser'];
        
        test.startTest();
        testACR.Account_Contact_Role__c = '';
        testACR.Account_Contact_Role_Level_2_del1__c = 'Media Buyer';
        testACR.Account_Contact_Role_Level_3_del1__c = '';
        update testACR;
        test.stopTest();
        
        
    }
    
    @isTest
    private static void pardotACR2(){
        
        RecordType recordTypeNameContact = [select Name from recordtype where sObjectType = 'Contact' and Name = 'T&F - Contacts'];
        TriggerInterfaceHelper.runTrigger('PardotACRSharing_Trig', 'AccountContactRole__c', 99, 'ai,au', recordTypeNameContact.Id, null);
        
        Contact testContact = [SELECT Id FROM Contact WHERE Email = 'matthew.smith.gb1@mlg1337.co.uk'];
        
        AccountContactRole__c testACR = [SELECT Id FROM AccountContactRole__c WHERE ContactID__r.email = 'matthew.smith.gb1@mlg1337.co.uk' AND Account_Contact_Role_Level_3_del1__c = 'Researcher'];
                
        test.startTest();
        testACR.Account_Contact_Role__c = 'Academic';
        testACR.Account_Contact_Role_Level_2_del1__c = '';
        testACR.Account_Contact_Role_Level_3_del1__c = '';
        update testACR;
        test.stopTest();
        
        
    }
    
    @isTest
    private static void pardotACR3(){
        
        RecordType recordTypeNameContact = [select Name from recordtype where sObjectType = 'Contact' and Name = 'T&F - Contacts'];
        TriggerInterfaceHelper.runTrigger('PardotACRSharing_Trig', 'AccountContactRole__c', 99, 'ai,au', recordTypeNameContact.Id, null);
        
        Contact testContact = [SELECT Id FROM Contact WHERE Email = 'matthew.smith.gb1@mlg1337.co.uk'];
        
        AccountContactRole__c testACR = [SELECT Id FROM AccountContactRole__c WHERE ContactID__r.email = 'matthew.smith.gb1@mlg1337.co.uk' AND Account_Contact_Role_Level_2_del1__c = 'Instructor'];
                
        test.startTest();
        testACR.Account_Contact_Role__c = '';
        testACR.Account_Contact_Role_Level_2_del1__c = '';
        testACR.Account_Contact_Role_Level_3_del1__c = 'Instructor';
        update testACR;
        test.stopTest();
        
        
    }
    
    @isTest
    private static void pardotACRNonMatch(){
        
        RecordType recordTypeNameContact = [select Name from recordtype where sObjectType = 'Contact' and Name = 'T&F - Contacts'];
        TriggerInterfaceHelper.runTrigger('PardotACRSharing_Trig', 'AccountContactRole__c', 99, 'ai,au', recordTypeNameContact.Id, null);
        
        Contact testContact = [SELECT Id FROM Contact WHERE Email = 'matthew.smith@tandf.co.uk'];
        
        AccountContactRole__c testACR = [SELECT Id FROM AccountContactRole__c WHERE ContactID__r.email = 'matthew.smith@tandf.co.uk' AND Account_Contact_Role__c = 'Instructor'];
                
        test.startTest();
        testACR.Account_Contact_Role__c = 'Academic';
        update testACR;
        test.stopTest();
        
        
    }
    
    @isTest
    private static void deletePardotACR(){
        
        RecordType recordTypeNameContact = [select Name from recordtype where sObjectType = 'Contact' and Name = 'T&F - Contacts'];
        TriggerInterfaceHelper.runTrigger('PardotACRSharing_Trig', 'AccountContactRole__c', 99, 'ad', recordTypeNameContact.Id, null);
        
		AccountContactRole__c testACR = [SELECT Id FROM AccountContactRole__c WHERE ContactID__r.email = 'matthew.smith.gb1@mlg1337.co.uk' AND Account_Contact_Role__c = 'Article Purchaser'];

		test.startTest();
		delete testACR;
		test.stopTest();        
        
    }
   
    
}