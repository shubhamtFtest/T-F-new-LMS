/**************************************************************************
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2015-04-03
**####### Feedback Emails
***************************************************************************/
@isTest
private class zTest_CAS_FeedbackEmail {

    static testMethod void FeedbackAfterCreated() 
    {
        
        // Request for Feedback 35 days after created email
        String currencyIsoCode = 'EUR';
        //####Create IC Data
        //Test Create Good product
        String recordProcess = 'Feedback35';
        String isbn = recordProcess+ '456789';
        String locale = 'AMERICAS';
        String productName = recordProcess;
        System.debug(locale + ': locale Testing Sending email for CAS Inspections');
        Product2 prod = zTests_CASEmail.CreateProduct2(currencyIsoCode, productName, isbn);
        PricebookEntry pbe =[Select Id From PricebookEntry Where Product2Id=:prod.id];
        Account account = zTests_CASEmail.setupTestAccount(recordProcess + locale);
        system.debug('account'+account );
        Opportunity opp = zTests_CASEmail.setupTestOpportunity(recordProcess + locale, account.Id);
        Id contactId = zTests_CASEmail.createAccountAndContact(recordProcess+'@test.com', locale);
        OpportunityLineItem oppProduct = zTests_CASEmail.setupOppLineItemsRecepinet(opp.Id,contactId, pbe.Id);
        CAS_Inspection_Copy__c ic = zTests_CASEmail.CreateInspectionCopy(opp.Id, oppProduct.Id, isbn);
        ic.Sent_Created_Notification__c = system.now().date().addDays(-36);
        update(ic);
        
         //Test Missing Recipient
        recordProcess = 'fbContactDelete';
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
        ic.Sent_Created_Notification__c = system.now().date().addDays(-36);
        update(ic);
        Delete(new contact(id=contactId));
        
        //Test Missing OpportunityProduct
        recordProcess = 'FbOLIDelete';
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
        ic.Sent_Created_Notification__c = system.now().date().addDays(-36);
        ic.Adoption_Stage__c = null;
        update(ic);
        Delete(new OpportunityLineItem(id=oppProduct.id));
        
        
        
        zTests_CASEmail.GetRulesInspectionCopy();
        Set<Id> batchProcessIds = new Set<Id>();
        
        //Call Batch
        Test.StartTest();
        //Send feedback emails
        CAS_TextbookFeedbackEmail feedbackEmail = new CAS_TextbookFeedbackEmail(); 
        feedbackEmail.isTesting=true;
        feedbackEmail.orgId=UserInfo.getOrganizationId();
        
        feedbackEmail.templateId = '00X0Y000000sUhwUAE';// Request for Feedback 35 days after created email 
        batchProcessIds.add(Database.executeBatch(feedbackEmail));
        
        Test.StopTest();
        
        
    }
    
    static testmethod void CAS_SendFeedbackEmailTestcase()
    {
        String currencyIsoCode = 'EUR';
        //####Create IC Data
        //Test Create Good product
        String recordProcess = 'FeedbackEmailOppOwner';
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
      //  CAS_Inspection_Copy__c ic = zTests_CASEmail.CreateInspectionCopy(opp.Id, oppProduct.Id, isbn);
        
            CAS_Inspection_Copy__c ic = new CAS_Inspection_Copy__c();
            ic.Opportunity__c = opp.Id;
            ic.Opportunity_Product__c = oppProduct.Id;//'00k60000006hH5JAAU';
            ic.Book_Order__c = '1234';
            ic.Book_Title__c = 'My title';
            ic.ISBN__c = isbn;
            ic.Contact_Name__c = 'TEST.Shay.Spoonmore';
            ic.Contact_Email__c= 'Shay.Spoonmore@informaUSA.com';
            ic.IsTesting__c = true;
            ic.Number_of_Students__c = 1;
            ic.Course_Start_Date__c = system.now().date();
            ic.Recommend_title__c = 'Yes - Same Edition';
            ic.Sent_Created_Notification__c = null;
            ic.Do_Not_Send__c = false;
            ic.Sent_Email_Failure__c=false; 
            ic.Adoption_Short__c = null; 
            ic.Adoption_Stage__c = null;
            ic.Order_Type__c = 'Send';
            insert ic;
       // ic.Sent_Created_Notification__c = system.now().date().addDays(-61);
     //   ic.Adoption_Level__c = 'test';
       // ic.Sent_Type__c = 'Singapore';
            ic.Shipping_Date__c=system.now().date();
        update(ic);
        
        
        
    }
    
    static testMethod void FeedbackAfterCreatedSingapore() 
    {
        //Request for Feedback Singapore 60 days after created email
        String currencyIsoCode = 'EUR';
        //####Create IC Data
        //Test Create Good product
        String recordProcess = 'FeedbackSingapore';
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
        ic.Sent_Created_Notification__c = system.now().date().addDays(-61);
        ic.Sent_Type__c = 'Singapore';
        ic.Shipping_Date__c=system.now().date();
        ic.Adoption_Stage__c=null;
        update(ic);
        
        
        
        
        
        zTests_CASEmail.GetRulesInspectionCopy();
        Set<Id> batchProcessIds = new Set<Id>();
        
        //Call Batch
        Test.StartTest();
        //Send feedback emails
        CAS_TextbookFeedbackEmail feedbackEmail = new CAS_TextbookFeedbackEmail(); 
        feedbackEmail.isTesting=true;
        feedbackEmail.orgId=UserInfo.getOrganizationId();
        
        feedbackEmail.templateId = '00X0Y000000sUhyUAE';// Request for Feedback Singapore 60 days after created email
        batchProcessIds.add(Database.executeBatch(feedbackEmail));
        
        Test.StopTest();
        
        
    }
    
     static testMethod void FeedbackFollowUp() 
    {
        //Request for Feedback Singapore 60 days after created email
        String currencyIsoCode = 'EUR';
        //####Create IC Data
        //Test Create Good product
        String recordProcess = 'FeedbackFollowUp';
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
        ic.Sent_Created_Notification__c = system.now().date().addDays(-61);
        ic.Sent_Feedback_Notification__c =system.now().date().addDays(-15);
        ic.Adoption_Stage__c = null;
        update(ic);
        
        
        
        
        
        zTests_CASEmail.GetRulesInspectionCopy();
        Set<Id> batchProcessIds = new Set<Id>();
        
        //Call Batch
        Test.StartTest();
        //Send feedback emails
        CAS_TextbookFeedbackEmail feedbackEmail = new CAS_TextbookFeedbackEmail(); 
        feedbackEmail.isTesting=true;
        feedbackEmail.orgId=UserInfo.getOrganizationId();
        
        feedbackEmail.templateId = '00X0Y000000sUhxUAE';// Request for Feedback - FollowUp 14 days  after Feedback or feedback for Singapore
        batchProcessIds.add(Database.executeBatch(feedbackEmail));
        
        Test.StopTest();
        
        
    }
    
    
      static testMethod void FeedbackShortForm() 
    {
        //Request for Feedback Singapore 60 days after created email
        String currencyIsoCode = 'EUR';
        //####Create IC Data
        //Test Create Good product
        String recordProcess = 'Feedbackshort';
        String isbn = recordProcess+ '456789';
        String locale = 'AMERICAS';
        String productName = recordProcess;
        Product2 prod = zTests_CASEmail.CreateProduct2(currencyIsoCode, productName, isbn);
        PricebookEntry pbe =[Select Id From PricebookEntry Where Product2Id=:prod.id];
        Account account = zTests_CASEmail.setupTestAccount(recordProcess + locale);
        Opportunity opp = zTests_CASEmail.setupTestOpportunity(recordProcess + locale, account.Id);
        Id contactId = zTests_CASEmail.createAccountAndContact(recordProcess+'@test.com', locale);
        OpportunityLineItem oppProduct = zTests_CASEmail.setupOppLineItemsRecepinet(opp.Id,contactId, pbe.Id);
        CAS_Inspection_Copy__c ic = zTests_CASEmail.CreateInspectionCopy(opp.Id, oppProduct.Id, isbn);
        ic.Sent_Created_Notification__c = system.now().date().addDays(-160);
        ic.Sent_Feedback_Notification__c =system.now().date().addDays(-91);
        ic.Number_of_Students__c = 50;
        ic.Adoption_Stage__c = null;
        update(ic);
        prod.Family='Not CRC';
        update(prod);
        
        
        
        
        
        zTests_CASEmail.GetRulesInspectionCopy();
        Set<Id> batchProcessIds = new Set<Id>();
        
        //Call Batch
        Test.StartTest();
        //Send feedback emails
        CAS_TextbookFeedbackEmail feedbackEmail = new CAS_TextbookFeedbackEmail(); 
        feedbackEmail.isTesting=true;
        feedbackEmail.orgId=UserInfo.getOrganizationId();
        
        feedbackEmail.templateId = '00X0Y000000sUmNUAU';// Request for Feedback - Shortform 90 days after Feedback or Feedback for Singapore if the product family not CRC and less than 50 students
        batchProcessIds.add(Database.executeBatch(feedbackEmail));
        
        Test.StopTest();
        
        
    }
    
    
    
}