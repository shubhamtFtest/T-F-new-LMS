/*
 * 
 * Created by: Matthew Smith on 2020.05.05
 * Test class for: OLIUpdateOppAdoptionValue_Trig @ 100% coverage
 * 
*/
@isTest
public class zTest_OLIUpdateOppAdoptionValue {
    
    @isTest
    private static void AdoptionValueTest() {
        
        RecordType recordTypeNameOpportunity = [select Name from recordtype where sObjectType = 'Opportunity' and Name = 'T&F - CAS Opportunity'];
        TriggerInterfaceHelper.runTrigger('OLIUpdateOppAdoptionValue_Trig', 'OpportunityLineItem', 99, 'bi,bu', recordTypeNameOpportunity.Id, null);
        
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
        //RecordType recordTypeNameOpportunity = [select Name from recordtype where sObjectType = 'Opportunity' and Name = 'T&F - CAS Opportunity'];
        
        Opportunity testOpportunity = new Opportunity();
        testOpportunity.AccountId = testAccount.Id;
        testOpportunity.Name = 'Test Opportunity';
        testOpportunity.StageName = 'Prospect';
        testOpportunity.CloseDate = date.today();
        testOpportunity.RecordTypeId = recordTypeNameOpportunity.Id;
        insert testOpportunity;
        
        //creating test OCR
        OpportunityContactRole testOCR = new OpportunityContactRole();
        testOCR.OpportunityId = testOpportunity.Id;
        testOCR.ContactId = testContact.Id;
        testOCR.IsPrimary = True;
        insert testOCR;
        
        //creating product
        Product2 testProd = new Product2();
        testProd.Name = 'testProd';
        testProd.isActive = true;
        insert testProd;
        
        //creating pricebook
        Pricebook2 customTFPricebook = new Pricebook2();
        customTFPricebook.Name = 'T&F Pricebook';
        customTFPricebook.isActive = True;
        insert customTFPricebook;
        
        //creating standard pricebook entry
        PricebookEntry standardPBE = new PricebookEntry();
        standardPBE.Pricebook2Id = test.getStandardPricebookId();
        standardPBE.Product2Id = testProd.id;
        standardPBE.UnitPrice = 1.00; 
        standardPBE.IsActive = True; 
        standardPBE.UseStandardPrice = False;
        standardPBE.CurrencyIsoCode = 'USD';
        insert standardPbe;

        //creating T&F pricebook entry
        PricebookEntry tfPBE = new PricebookEntry();
        tfPBE.Pricebook2Id = customTFPricebook.id;
        tfPBE.Product2Id = testProd.id;
        tfPBE.UnitPrice = 1.00;
        tfPBE.IsActive = True;
        tfPBE.UseStandardPrice = False; 
        tfPBE.CurrencyIsoCode = 'USD';
        insert tfPBE;
        
   
        //creating opportunity line item record
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.Quantity = 1;
        oli.UnitPrice= 1;
        oli.Adoption_Level__c = 'Highly Recommended';
        oli.X100_Enrolment__c = 'Inclusive Access';
        oli.Added_Value__c = 'Bundle';
        oli.Recipient__c = testContact.Id;
        oli.PricebookEntryId = tfPBE.id;
        oli.OpportunityId = testOpportunity.id;
        insert oli; 

        
        //core test opportunity line item record
        OpportunityLineItem oli2 = new OpportunityLineItem();
        oli2.Quantity = 1;
        oli2.UnitPrice = 1;
        oli2.Adoption_Level__c = 'Core Text';
        oli2.X100_Enrolment__c = 'Inclusive Access';
        oli2.Added_Value__c = 'Bundle';
        oli2.Recipient__c = testContact.Id;
        oli2.PricebookEntryId = tfPBE.id;
        oli2.OpportunityId = testOpportunity.id;
        insert oli2;

        
        //update core text opportunity line item record
        oli2.Adoption_Level__c = 'Supplementary Reading';
		update oli2;
        oli2.Added_Value__c = 'Custom';   
        update oli2;
        oli2.UnitPrice = 5;
        update oli2;
        oli2.Quantity = 4;
        update oli2;
        
        
        //core test opportunity line item record
        OpportunityLineItem oli3 = new OpportunityLineItem();
        oli3.Quantity = 1;
        oli3.UnitPrice = 1;
        oli3.Adoption_Level__c = 'Supplementary Reading';
        oli3.X100_Enrolment__c = 'Inclusive Access';
        oli3.Added_Value__c = 'Bundle';
        oli3.Recipient__c = testContact.Id;
        oli3.PricebookEntryId = tfPBE.id;
        oli3.OpportunityId = testOpportunity.id;
        insert oli3;
        
        //core test opportunity line item record
        OpportunityLineItem oli4 = new OpportunityLineItem();
        oli4.Quantity = 1;
        oli4.UnitPrice = 1;
        oli4.Adoption_Level__c = 'Core Text';
        //oli4.X100_Enrolment__c = 'Inclusive Access';
        //oli4.Added_Value__c = 'Bundle';
        oli4.Recipient__c = testContact.Id;
        oli4.PricebookEntryId = tfPBE.id;
        oli4.OpportunityId = testOpportunity.id;
        insert oli4;
 
    }
}