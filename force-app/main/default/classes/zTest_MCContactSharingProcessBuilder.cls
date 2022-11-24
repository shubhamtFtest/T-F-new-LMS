/*
Created by: Matthew Smith - September 15th 2020
Test class for Process Builder "Marketing Cloud Contact Sharing" 
*/
@isTest
public class zTest_MCContactSharingProcessBuilder {
    
    @isTest
    private static void MarketingCloudSharing (){
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
        testContact.Email = 'matthew.smith.gb1@tandf.co.uk';
        testContact.Phone = '012345678910';
        testContact.RecordTypeId = recordTypeNameContact.Id;
        insert testContact;
        //contact should be shared with marketing cloud
        system.assertEquals(testContact.Shared_with_Marketing_Cloud__c = TRUE, testContact.Shared_with_Marketing_Cloud__c);
        
        testContact.Business__c = 'Dove';
        update testContact;
        //contact should not be shared with marketing cloud
        system.assertEquals(testContact.Shared_with_Marketing_Cloud__c = FALSE, testContact.Shared_with_Marketing_Cloud__c);
        
        testContact.Business__c = 'Dove; CAS';
        update testContact;
        //contact should be shared with marketing cloud
        system.assertEquals(testContact.Shared_with_Marketing_Cloud__c = TRUE, testContact.Shared_with_Marketing_Cloud__c);
        
        testContact.Business__c = 'Dove';
        testContact.Override_Marketing_Cloud_Sharing__c = TRUE;
        update testContact;
        //contact should be shared with marketing cloud
        system.assertEquals(testContact.Shared_with_Marketing_Cloud__c = TRUE, testContact.Shared_with_Marketing_Cloud__c);
        
        
    }

}