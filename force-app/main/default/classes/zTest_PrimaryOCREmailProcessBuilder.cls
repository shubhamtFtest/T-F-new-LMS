/*
Created by: Matthew Smith - April 28th 2020
Test class for Process Builder "OCR - Update Opportunity Primary Email" 
*/

@isTest
public class zTest_PrimaryOCREmailProcessBuilder {
    
    @isTest
    private static void OCR (){
        
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
       
        //creating test opportunity
        RecordType recordTypeNameOpportunity = [select Name from recordtype where sObjectType = 'Opportunity' and Name = 'T&F - CAS Opportunity'];
        
        Opportunity testOpportunity = new Opportunity();
        testOpportunity.AccountId = testAccount.Id;
        testOpportunity.Name = 'Test Opportunity';
        testOpportunity.StageName = 'Prospect';
        testOpportunity.CloseDate = date.today();
        testOpportunity.RecordTypeId = recordTypeNameOpportunity.Id;
        insert testOpportunity;
        
        OpportunityContactRole testOCR = new OpportunityContactRole();
        testOCR.OpportunityId = testOpportunity.Id;
        testOCR.ContactId = testContact.Id;
        testOCR.IsPrimary = True;
        insert testOCR;
        
    }

}