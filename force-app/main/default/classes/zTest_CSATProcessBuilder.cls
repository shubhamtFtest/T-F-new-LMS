/*
 * 
 * Test class for Process Builder - CSAT Survey Send
 * Created by: Matthew Smith 2020.04.17
 * 
*/

@isTest
public class zTest_CSATProcessBuilder {
   
    @isTest
    private static void opexCreation(){
        
        RecordType recordTypeNameAccount = [select Name from recordtype where sObjectType = 'Account' and Name = 'T&F - Accounts'];
        
        Account testAccount = new Account();
        testAccount.RecordTypeId = recordTypeNameAccount.Id;
        testAccount.Name = 'test account';
        testAccount.Mailing_Country_List__c = 'United Kingdom';
        insert testAccount;
        
        RecordType recordTypeNameContact = [select Name from recordtype where sObjectType = 'Contact' and Name = 'T&F - Contacts'];
        
        Contact testContact = new Contact();
        testContact.AccountId = testAccount.Id;
        testContact.FirstName = 'Matthew';
        testContact.LastName = 'Smith';
        testContact.Email = 'matthew.smith.gb1@tandf.co.uk';
        testContact.Phone = '012345678910';
        testContact.RecordTypeId = recordTypeNameContact.Id;
        insert testContact;
 		
        /********* OpEx Case Creation *********/
        Group queueOpEx = [select Name from group where type = 'Queue' and name = 'OpEx - Editorial Queries'];  
        RecordType recordTypeNameOpEx = [select Name from recordtype where sObjectType = 'Case' and Name = 'T&F - OpEx'];
        //Creating New Case
        Case testCaseOpEx = new Case();
        testCaseOpEx.Subject = 'Test';
        testCaseOpEx.OwnerId = queueOpEx.Id;
        testCaseOpEx.ContactId = testContact.Id;
        testCaseOpEx.RecordTypeId = recordTypeNameOpEx.Id;
		
        insert testCaseOpEx;
        System.debug('OpEx Contact Name ' + testCaseOpEx.ContactId);
        System.debug('OpEx Contact Email ' + testCaseOpEx.ContactEmail);
        System.debug('OpEx Contact Phone ' + testCaseOpEx.ContactPhone);
        // Loading case
        Case loadCaseOpEx = [SELECT OwnerId, RecordTypeId FROM Case WHERE Id = :testCaseOpEx.Id];
        
        
        System.assertEquals(queueOpEx.Id, loadCaseOpEx.OwnerId); // Check to see if the owner is OpEx - Editorial
        System.assertEquals(recordTypeNameOpEx.Id, loadCaseOpEx.RecordTypeId); // Check to see if the record type is T&F - OpEx
        
        /********* OpEx CSAT Case Creation *********/

        CSAT__c csatOpEx = new CSAT__c();
        csatOpex.Name = testCaseOpEx.Id;
        csatOpEx.Case__c = testCaseOpEx.Id;
        //csatOpEx.OwnerId = '0050Y000003YWeBQAW';
        csatOpEx.Queue__c = queueOpEx.name;
        csatOpEx.Survey_Status__c = 'Send';
        csatOpEx.Customer_Email_Address__c = testContact.Email;
        system.debug('What is the status ' + csatOpEx.Survey_Status__c);
        csatOpEx.Survey_Date__c = system.now();   
        insert csatOpEx;
                
    }
    
    @isTest
    private static void csdCreation(){
        //creating account
        RecordType recordTypeNameAccount = [select Name from recordtype where sObjectType = 'Account' and Name = 'T&F - Accounts'];
        Account testAccount = new Account();
        testAccount.RecordTypeId = recordTypeNameAccount.Id;
        testAccount.Name = 'test account';
        testAccount.Mailing_Country_List__c = 'United Kingdom';
        insert testAccount;
        
        //creating contact
        RecordType recordTypeNameContact = [select Name from recordtype where sObjectType = 'Contact' and Name = 'T&F - Contacts'];
        Contact testContact = new Contact();
        testContact.AccountId = testAccount.Id;
        testContact.FirstName = 'Matthew';
        testContact.LastName = 'Smith';
        testContact.Email = 'matthew.smith.gb1@tandf.co.uk';
        testContact.RecordTypeId = recordTypeNameContact.Id;
        insert testContact;
        
        /********* CSD Case Creation *********/
        
        Group queueCSD = [select Name from group where type = 'Queue' and name = 'CSD Tech Support'];  
        RecordType recordTypeNameCSD = [select Name from recordtype where sObjectType = 'Case' and Name = 'T&F - CSD'];
        //Creating New Case
        Case testCaseCSD = new Case();
        testCaseCSD.Subject = 'Test';
        testCaseCSD.OwnerId = queueCSD.Id;
        testCaseCSD.RecordTypeId = recordTypeNameCSD.Id;
		
        insert testCaseCSD;
        
        // Loading case
        Case loadCaseCSD = [SELECT OwnerId, RecordTypeId FROM Case WHERE Id = :testCaseCSD.Id];
        
        
        System.assertEquals(queueCSD.Id, loadCaseCSD.OwnerId); // Check to see if the owner is CSD Tech Support
        System.assertEquals(recordTypeNameCSD.Id, loadCaseCSD.RecordTypeId); // Check to see if the record type is T&F - CSD
        
        /********* CSD CSAT Case Creation *********/
        
        CSAT__c csatCSD = new CSAT__c();
        csatCSD.Name = testCaseCSD.Id;
        csatCSD.Case__c = testCaseCSD.Id;
        csatCSD.Queue__c = queueCSD.Name;
        csatCSD.Customer_Email_Address__c = testContact.Email;
        csatCSD.Survey_Status__c = 'Send';
        csatCSD.Survey_Date__c = system.now();
        insert csatCSD;
        
    }
    
    @isTest
    private static void blankCreation(){
        //creating account
        RecordType recordTypeNameAccount = [select Name from recordtype where sObjectType = 'Account' and Name = 'T&F - Accounts'];
        Account testAccount = new Account();
        testAccount.RecordTypeId = recordTypeNameAccount.Id;
        testAccount.Name = 'test account';
        testAccount.Mailing_Country_List__c = 'United Kingdom';
        insert testAccount;
        
        //creating contact
        RecordType recordTypeNameContact = [select Name from recordtype where sObjectType = 'Contact' and Name = 'T&F - Contacts'];
        Contact testContact = new Contact();
        testContact.AccountId = testAccount.Id;
        testContact.FirstName = 'Matthew';
        testContact.LastName = 'Smith';
        testContact.Email = 'matthew.smith.gb1@tandf.co.uk';
        testContact.RecordTypeId = recordTypeNameContact.Id;
        insert testContact;
        
        /********* CSD Case Creation *********/
        
        Group queueCSD = [select Name from group where type = 'Queue' and name = 'CSD Tech Support'];  
        RecordType recordTypeNameCSD = [select Name from recordtype where sObjectType = 'Case' and Name = 'T&F - CSD'];
        //Creating New Case
        Case testCaseCSD = new Case();
        testCaseCSD.Subject = 'Test';
        testCaseCSD.OwnerId = queueCSD.Id;
        testCaseCSD.RecordTypeId = recordTypeNameCSD.Id;
		
        insert testCaseCSD;
        
        // Loading case
        Case loadCaseCSD = [SELECT OwnerId, RecordTypeId FROM Case WHERE Id = :testCaseCSD.Id];
        
        
        System.assertEquals(queueCSD.Id, loadCaseCSD.OwnerId); // Check to see if the owner is CSD Tech Support
        System.assertEquals(recordTypeNameCSD.Id, loadCaseCSD.RecordTypeId); // Check to see if the record type is T&F - CSD
        
        
        /********* Blank CSAT Case Creation *********/
        
        CSAT__c csatBlank = new CSAT__c ();
        csatBlank.Name = testCaseCSD.Id;
        csatBlank.Case__c = testCaseCSD.Id;
        csatBlank.Queue__c = '';
        csatBlank.Customer_Email_Address__c = testContact.Email;
        csatBlank.Survey_Status__c = 'Send';
        csatBlank.Survey_Date__c = system.now();
        insert csatBlank;

    }

}