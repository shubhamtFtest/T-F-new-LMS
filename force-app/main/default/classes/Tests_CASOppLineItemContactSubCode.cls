@isTest
public with sharing class Tests_CASOppLineItemContactSubCode {
    
    
    
    static testMethod void UnitTest_AddingSubjectCodesToContact() 
    
    {
       
      
       //Pricebook2 s = [select id from Pricebook2 where IsStandard = true ];    
        
        Id productRtId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products'); //CHG0038379
                    
        Product2 p1 = new Product2(
                name='Test Product 1',
                ISBN__c='1234', 
                IsActive=true,
                Description='My Product',
                RecordTypeId=productRtId,
                ProductCode='12345',
                Subject_Code__c = 'SCBL9615 - Planning History; SCSP209025 - Olympics; SCGE3040 - Urban Geography',
                UK_Inventory_Status__c = 'Available',
                UK_Publication_Date__c = system.now().date().addDays(-1),
                US_Inventory_Status__c = 'Available',
                US_Publication_Date__c = system.now().date().addDays(-1)
            );
        insert p1;
        
        // create the pricebookentry
        PricebookEntry pbe1 = new PricebookEntry(
            CurrencyIsoCode = 'EUR',
            Pricebook2Id=Test.getStandardPricebookId(),
            Product2Id=p1.id, 
            UnitPrice=0.00, 
            IsActive=true, 
            UseStandardPrice=false
            );
        insert pbe1;
        String locale = 'AMERICAS';
        Account account = setupTestAccount('TEST_1_' + locale);
        Opportunity opp = setupTestOpportunity('TEST_1' + locale, account.Id);
        Id contactId = createAccountAndContact('TestSinapore@test.com', locale);
        
        System.debug('Testing Sending email for CAS Inspections');
        OpportunityLineItem oppProduct = setupOppLineItemsRecepinet(opp.Id,contactId, pbe1.Id);

        
    }
    
        public static String createAccountAndContact(String email, String Locale) {
        
        Account a = new Account(name = 'New Account' + Locale, Locale__c = Locale);
        insert a;
        
        Contact c = new Contact(
            FirstName = 'Test Contact' + Locale ,
            LastName = 'Test Last Name'+ Locale ,
            Email = Locale + email,
            AccountId = a.Id        
        );
        insert c;
        return c.Id;    
        
    }
    
     private static Opportunity setupTestOpportunity(String oppName, ID accountId) {
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
        Opportunity opp = new Opportunity(
            name=oppName,
            Type = 'New Business',
            RecordTypeId=oppRtId,
            stagename='Verbal',
            Probability=80,
            closedate=Date.newInstance(2011, 01, 01),
            CurrencyIsoCode = 'EUR',
            accountId=accountId
        );
        insert opp;
        return opp;
    }       
    
    private static OpportunityLineItem setupOppLineItems(ID opportunityId) { 
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = opportunityId;
        oli.Quantity = 1;
        oli.Est_Training_Pop__c = 1;
        oli.Unit_Material_Cost__c = 1;
        oli.Gross_Cost__c = 1;
        oli.Preparation_Cost__c = 1;
        oli.Instructor_Fee__c = 1; 
        oli.TotalPrice = 2;
        oli.PricebookEntryId = [Select p.Id From PricebookEntry p Where CurrencyIsoCode = 'EUR' And IsActive = true limit 1].Id;
        // insert the opportunity line item
        insert oli;
        return oli;   
    }
    
    private static OpportunityLineItem setupOppLineItemsRecepinet(ID opportunityId, ID recipientId, ID pricebookId) { 
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = opportunityId;
        oli.Quantity = 1;
        oli.Est_Training_Pop__c = 1;
        oli.Unit_Material_Cost__c = 1;
        oli.Gross_Cost__c = 1;
        oli.Preparation_Cost__c = 1;
        oli.Instructor_Fee__c = 1; 
        oli.TotalPrice = 2;
        oli.PricebookEntryId = pricebookId;
        oli.Recipient__c = recipientId;
        //oli.CurrencyIsoCode = '';
        // insert the opportunity line item
        insert oli;
        return oli;   
    }
    
    
    private static Account setupTestAccount(String accountName) 
    {
        Account a = new Account(name=accountName,
            //OwnerId=userId,
            BillingStreet='1234 Main Street');  
        insert a;
        return a;
    } 
    

}