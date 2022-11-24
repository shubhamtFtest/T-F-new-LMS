/**************************************************************************
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2015-04-03
**####### Sends First Email
***************************************************************************/
@isTest
private class zTest_CAS_CreatedEmailAvailable 
{

    static testMethod void myUnitTest() 
    {
        String currencyIsoCode = 'EUR';
        //####Create IC Data
        //Test Create Good product
        String recordProcess = 'GoodAvailable';
        String isbn = recordProcess+ '456789';
        String locale = 'AMERICAS';
        String productName = recordProcess;
        System.debug(locale + ': locale Testing Sending email for CAS Inspections');
        Product2 prod = zTests_CASEmail.CreateProduct2(currencyIsoCode, productName, isbn);
        PricebookEntry pbe =[Select Id From PricebookEntry Where Product2Id=:prod.id];
        Account account = zTests_CASEmail.setupTestAccount(recordProcess + locale);
        Opportunity opp = zTests_CASEmail.setupTestOpportunity(recordProcess + locale, account.Id);
        Id contactId = zTests_CASEmail.createAccountAndContact(recordProcess+'@test.com', locale);
        OpportunityLineItem oppProduct = zTests_CASEmail.setupOppLineItemsRecepinet(opp.Id,contactId, pbe.Id);
        CAS_Inspection_Copy__c ic = zTests_CASEmail.CreateInspectionCopy(opp.Id, oppProduct.Id, isbn);
        
        
        //Test Missing Contact Email
         ic = zTests_CASEmail.CreateInspectionCopy(opp.Id, oppProduct.Id, isbn);
         ic.Contact_Email__c = null;
         update ic;
         
         //Test Singapore
         ic = zTests_CASEmail.CreateInspectionCopy(opp.Id, oppProduct.Id, isbn);
         ic.Sent_Type__c = 'Singapore';
         update ic;
         
         //Test Opportunity Product Adoption Stage
         oppProduct = zTests_CASEmail.setupOppLineItemsRecepinet(opp.Id,contactId, pbe.Id);
         oppProduct.Adoption_Stage__c = 'Never Received Product';
         update oppProduct;
         ic = zTests_CASEmail.CreateInspectionCopy(opp.Id, oppProduct.Id, isbn);
         oppProduct = zTests_CASEmail.setupOppLineItemsRecepinet(opp.Id,contactId, pbe.Id);
         oppProduct.Adoption_Stage__c = 'Completed test test test';
         update oppProduct;
         ic = zTests_CASEmail.CreateInspectionCopy(opp.Id, oppProduct.Id, isbn);
         
         //Test product Inventory Status
        recordProcess = 'InventoryStatusUK';
        isbn = recordProcess+ '456789';
        locale = 'EMEA';
        productName = recordProcess;
        System.debug(locale + ': locale Testing Sending email for CAS Inspections');
        prod = zTests_CASEmail.CreateProduct2(currencyIsoCode, productName, isbn);
        prod.US_Inventory_Status__c = 'NotAvail';
        prod.UK_Inventory_Status__c = 'NotAvail';
        Update prod;
        pbe =[Select Id From PricebookEntry Where Product2Id=:prod.id];
        account = zTests_CASEmail.setupTestAccount(recordProcess + locale);
        opp = zTests_CASEmail.setupTestOpportunity(recordProcess + locale, account.Id);
        contactId = zTests_CASEmail.createAccountAndContact(recordProcess+'@test.com', locale);
        oppProduct = zTests_CASEmail.setupOppLineItemsRecepinet(opp.Id,contactId, pbe.Id);
        ic = zTests_CASEmail.CreateInspectionCopy(opp.Id, oppProduct.Id, isbn);
        recordProcess = 'InventoryStatusUS';
        isbn = recordProcess+ '456789';
        locale = 'AMERICAS';
        account = zTests_CASEmail.setupTestAccount(recordProcess + locale);
        opp = zTests_CASEmail.setupTestOpportunity(recordProcess + locale, account.Id);
        contactId = zTests_CASEmail.createAccountAndContact(recordProcess+'@test.com', locale);
        oppProduct = zTests_CASEmail.setupOppLineItemsRecepinet(opp.Id,contactId, pbe.Id);
        ic = zTests_CASEmail.CreateInspectionCopy(opp.Id, oppProduct.Id, isbn);
        
        //Test product Publication_Date
        recordProcess = 'PublicationDateUK';
        isbn = recordProcess+ '456789';
        locale = 'EMEA';
        productName = recordProcess;
        System.debug(locale + ': locale Testing Sending email for CAS Inspections');
        prod = zTests_CASEmail.CreateProduct2(currencyIsoCode, productName, isbn);
        prod.Publication_Date__c = null;
        prod.Publication_Date__c = null;
        Update prod;
        pbe =[Select Id From PricebookEntry Where Product2Id=:prod.id];
        account = zTests_CASEmail.setupTestAccount(recordProcess + locale);
        opp = zTests_CASEmail.setupTestOpportunity(recordProcess + locale, account.Id);
        contactId = zTests_CASEmail.createAccountAndContact(recordProcess+'@test.com', locale);
        oppProduct = zTests_CASEmail.setupOppLineItemsRecepinet(opp.Id,contactId, pbe.Id);
        ic = zTests_CASEmail.CreateInspectionCopy(opp.Id, oppProduct.Id, isbn);
        recordProcess = 'PublicationDateUS';
        isbn = recordProcess+ '456789';
        locale = 'AMERICAS';
        account = zTests_CASEmail.setupTestAccount(recordProcess + locale);
        opp = zTests_CASEmail.setupTestOpportunity(recordProcess + locale, account.Id);
        contactId = zTests_CASEmail.createAccountAndContact(recordProcess+'@test.com', locale);
        oppProduct = zTests_CASEmail.setupOppLineItemsRecepinet(opp.Id,contactId, pbe.Id);
        ic = zTests_CASEmail.CreateInspectionCopy(opp.Id, oppProduct.Id, isbn);
         
         
         
         //Test Account Locale
         recordProcess = 'AccountLocal';
        isbn = recordProcess+ '456789';
        locale = 'APAC';
        productName = recordProcess;
        System.debug(locale + ': locale Testing Sending email for CAS Inspections');
        prod = zTests_CASEmail.CreateProduct2(currencyIsoCode, productName, isbn);
        pbe =[Select Id From PricebookEntry Where Product2Id=:prod.id];
        account = zTests_CASEmail.setupTestAccount(recordProcess + locale);
        opp = zTests_CASEmail.setupTestOpportunity(recordProcess + locale, account.Id);
        contactId = zTests_CASEmail.createAccountAndContact(recordProcess+'@test.com', locale);
        oppProduct = zTests_CASEmail.setupOppLineItemsRecepinet(opp.Id,contactId, pbe.Id);
        ic = zTests_CASEmail.CreateInspectionCopy(opp.Id, oppProduct.Id, isbn);
        
        //Test Missing Recipient
        recordProcess = 'ContactDelete';
        isbn = recordProcess+ '456789';
        locale = 'Americas';
        productName = recordProcess;
        System.debug(locale + ': locale Testing Sending email for CAS Inspections');
        prod = zTests_CASEmail.CreateProduct2(currencyIsoCode, productName, isbn);
        pbe =[Select Id From PricebookEntry Where Product2Id=:prod.id];
        account = zTests_CASEmail.setupTestAccount(recordProcess + locale);
        opp = zTests_CASEmail.setupTestOpportunity(recordProcess + locale, account.Id);
        contactId = zTests_CASEmail.createAccountAndContact(recordProcess+'@test.com', locale);
        oppProduct = zTests_CASEmail.setupOppLineItemsRecepinet(opp.Id,contactId, pbe.Id);
        ic = zTests_CASEmail.CreateInspectionCopy(opp.Id, oppProduct.Id, isbn);
        Delete(new contact(id=contactId));
        
        //Test Missing OpportunityProduct
        recordProcess = 'OLIDelete';
        isbn = recordProcess+ '456789';
        locale = 'Americas';
        productName = recordProcess;
        System.debug(locale + ': locale Testing Sending email for CAS Inspections');
        prod = zTests_CASEmail.CreateProduct2(currencyIsoCode, productName, isbn);
        pbe =[Select Id From PricebookEntry Where Product2Id=:prod.id];
        account = zTests_CASEmail.setupTestAccount(recordProcess + locale);
        opp = zTests_CASEmail.setupTestOpportunity(recordProcess + locale, account.Id);
        contactId = zTests_CASEmail.createAccountAndContact(recordProcess+'@test.com', locale);
        oppProduct = zTests_CASEmail.setupOppLineItemsRecepinet(opp.Id,contactId, pbe.Id);
        ic = zTests_CASEmail.CreateInspectionCopy(opp.Id, oppProduct.Id, isbn);
        Delete(new OpportunityLineItem(id=oppProduct.id));
        
        
        
         
         
         
         
       
         
        zTests_CASEmail.GetRulesInspectionCopy();
        Set<Id> batchProcessIds = new Set<Id>();
        
//Call Batch
        Test.StartTest();
        CAS_TextbookFeedbackCreatedEmail createEmail = new CAS_TextbookFeedbackCreatedEmail();
        createEmail.isTesting=true;
        createEmail.orgId=UserInfo.getOrganizationId();
        createEmail.isAvailable = true;
        System.Debug('@@Avi 1 IC :'+ic);
        batchProcessIds.add(Database.executeBatch(createEmail)); 
        Test.StopTest();
        
        
        
        
    }
    
    static testMethod void NotAvailable() 
    {
        Set<Id> batchProcessIds = new Set<Id>();
        String currencyIsoCode = 'EUR';
        //####Create IC Data
        //Test Create Good product
        String recordProcess = 'GoodAvailable';
        String isbn = recordProcess+ '456789';
        String locale = 'AMERICAS';
        String productName = recordProcess;
    
    
        //Test Not available Products
        
        recordProcess = 'NotAvail';
        isbn = recordProcess+ '456789';
        locale = 'Americas';
        productName = recordProcess;
        System.debug(locale + ': locale Testing Sending email for CAS Inspections');
        Product2 prod = zTests_CASEmail.CreateProduct2(currencyIsoCode, productName, isbn);
        PricebookEntry pbe =[Select Id From PricebookEntry Where Product2Id=:prod.id];
        Account account = zTests_CASEmail.setupTestAccount(recordProcess + locale);
        Opportunity opp = zTests_CASEmail.setupTestOpportunity(recordProcess + locale, account.Id);
        Id contactId = zTests_CASEmail.createAccountAndContact(recordProcess+'@test.com', locale);
        OpportunityLineItem oppProduct = zTests_CASEmail.setupOppLineItemsRecepinet(opp.Id,contactId, pbe.Id);
        CAS_Inspection_Copy__c ic = zTests_CASEmail.CreateInspectionCopy(opp.Id, oppProduct.Id, isbn);
        ic.Sent_Not_Available_Date__c =system.now().date().addDays(-2);
        ic.Adoption_Stage__c=null;
       Update ic;
        
        
        
        
        
            Test.StartTest();
        CAS_TextbookFeedbackCreatedEmail createEmail = new CAS_TextbookFeedbackCreatedEmail();
        createEmail.isTesting=true;
        createEmail.orgId=UserInfo.getOrganizationId();
        createEmail.isAvailable = false;
        System.Debug('@@Avi 2 IC :'+ic);
        batchProcessIds.add(Database.executeBatch(createEmail)); 
        Test.StopTest();
    
    }
}