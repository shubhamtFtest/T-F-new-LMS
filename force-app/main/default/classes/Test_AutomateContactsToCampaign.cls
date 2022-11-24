/*
Created by      :   Renil Rejith
Created Date    :   2021.11.08
Apex Class		:	AutomateContactsToCampaignForArticlePass
Custom Metadata :   Automate Contact to Campaign
Scheduler Class :   AutomateContactsToCampaignScheduler
Test Class		:   Test_AutomateContactsToCampaign
*/
@isTest
public class Test_AutomateContactsToCampaign 
{
    @isTest
    private static void automateContactsToCampaignTest()
    {
        //creating test Account
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();

        Account testAccount                 = new Account();
        testAccount.RecordTypeId            = accRecordTypeId;
        testAccount.Name                    = 'test account';
        testAccount.Mailing_Country_List__c = 'United Kingdom'; 
        insert testAccount;

        //creating test Contact
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('T&F - Contacts').getRecordTypeId();

        Contact testContact             = new Contact();
        testContact.AccountId           = testAccount.Id;
        testContact.FirstName           = 'John';
        testContact.LastName            = 'Doe';
        testContact.Email               = 'john.doe@email.com';
        testContact.Phone               = '9876543210';
        testContact.Status__c           = 'Active';
        testContact.HasOptedOutOfEmail  = false;
        testContact.RecordTypeId        = conRecordTypeId;
        insert testContact;

        //creating test Opportunity
        Id oppsRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F - Journals Opportunity').getRecordTypeId();

        Opportunity testOpportunity                 = new Opportunity();
        testOpportunity.AccountId                   = testAccount.Id;
        testOpportunity.Name                        = 'Test Opportunity';
        testOpportunity.StageName                   = 'Prospect';
        testOpportunity.CloseDate                   = date.today();
        testOpportunity.RecordTypeId                = oppsRecordTypeId;
        testOpportunity.Multi_year_deal__c          = 'No';
        testOpportunity.Opportunity_for_Renewal__c  = 'No';
        testOpportunity.Reason_No_Renewal__c        = 'NIL';
        insert testOpportunity;
        
        //creating test OCR
        OpportunityContactRole testOCR  = new OpportunityContactRole();
        testOCR.OpportunityId           = testOpportunity.Id;
        testOCR.ContactId               = testContact.Id;
        testOCR.IsPrimary               = True;
        insert testOCR;

        //creating product
        Product2 testProd   = new Product2();
        testProd.Name       = 'Article Pass Test';
        testProd.isActive   = true;
        insert testProd;
        
        //creating pricebook
        Pricebook2 customTFPricebook    = new Pricebook2();
        customTFPricebook.Name          = 'T&F Pricebook';
        customTFPricebook.isActive      = True;
        insert customTFPricebook;

        //creating standard pricebook entry
        PricebookEntry standardPBE      = new PricebookEntry();
        standardPBE.Pricebook2Id        = test.getStandardPricebookId();
        standardPBE.Product2Id          = testProd.id;
        standardPBE.UnitPrice           = 1.00; 
        standardPBE.IsActive            = True; 
        standardPBE.UseStandardPrice    = False;
        standardPBE.CurrencyIsoCode     = 'USD';
        insert standardPbe;

        //creating T&F pricebook entry
        PricebookEntry tfPBE    = new PricebookEntry();
        tfPBE.Pricebook2Id      = customTFPricebook.id;
        tfPBE.Product2Id        = testProd.id;
        tfPBE.UnitPrice         = 1.00;
        tfPBE.IsActive          = True;
        tfPBE.UseStandardPrice  = False; 
        tfPBE.CurrencyIsoCode   = 'USD';
        insert tfPBE;
        
        //creating opportunity line item record
        OpportunityLineItem oli     = new OpportunityLineItem();
        oli.Quantity                = 1;
        oli.UnitPrice               = 1000.00;
        oli.Net_Price__c            = 1000.00;
        oli.TotalPrice_GBP__c 		= 1000.00;
        oli.Invoice_Number__c       = '50012345';
        oli.Invoice_Date__c	        = System.today();
        oli.Recipient__c            = testContact.Id;
        oli.PricebookEntryId        = tfPBE.id;
        oli.OpportunityId           = testOpportunity.id;
        insert oli; 
        
        testOpportunity.StageName = 'Closed Won';
        update testOpportunity;

        Test.startTest();
            AutomateContactsToCampaignForArticlePass autoConToCamp = new AutomateContactsToCampaignForArticlePass();
            Database.executeBatch(autoConToCamp);

            AutomateContactsToCampaignScheduler autoConToCampSchdlr = new AutomateContactsToCampaignScheduler();      
            String sch = '0 1 0 1/14 * ? *'; //every 14 days starting from the 1st of every month
            system.schedule('Test OrderApiRetryBatch Schedule', sch, autoConToCampSchdlr); 
        Test.stopTest();
        
        CampaignMember cm = [SELECT Id, Status, ContactId FROM CampaignMember LIMIT 1];

        System.assertEquals(cm.ContactId, testContact.Id, 'ContactId and CampaignMembers ConatctId are Equal'); 
    }
}