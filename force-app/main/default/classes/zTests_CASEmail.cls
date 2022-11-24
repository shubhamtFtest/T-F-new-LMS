/**
 ** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2014-10-03
 */
@isTest
public class zTests_CASEmail {

    static testMethod void UnitTest_CAS_SendNotificationsSchedule() 
    {
        // Schedule the test job
        Test.startTest(); 
        CAS_SendNotificationsSchedule m = new CAS_SendNotificationsSchedule();
        String sch = '20 30 8 10 2 ?';
        System.schedule('Test_CAS_SendNotificationsSchedule',sch, m);
        Test.stopTest();
    } 



    static testMethod void UnitTest_CAS_SendFeedbackSchedule() 
    {
        // Schedule the test job
        Test.startTest(); 
        CAS_SendFeedbackSchedule m = new CAS_SendFeedbackSchedule();
        String sch = '20 30 8 10 2 ?';
        System.schedule('Test_CAS_SendFeedbackSchedule',sch, m);
        Test.stopTest();
    } 

    static testMethod void UnitTest_SendEmailFeedBack() 
    {   

        //Pricebook2 s = new Pricebook2(Id = '01s300000001JicAAE');//[select id from Pricebook2 where IsStandard = true ];    
        //s.Id = '01s300000001JicAAE';
        
        Id productRtId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products'); //CHG0038379
        
        Product2 p1 = new Product2(
                name='Test Product 1', 
                ISBN__c='1234', 
                IsActive=true,
                Description='My Product',
                RecordTypeId=productRtId,
                ProductCode='12345',
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
        OpportunityLineItem oppProduct = setupOppLineItemsRecepinet(opp.Id,contactId, pbe1.Id);
        
        //Criteria
        // Select Contact_Email__c, Contact_Name__c, CreatedDate, Id,Sent_Created_Notification__c, Sent_Feedback_Notification__c  from CAS_Inspection_Copy__c ';
        // where Contact_Email__c != null AND Sent_Created_Notification__c != null AND Sent_Feedback_Notification__c = null AND Sent_Type__c = null ';
        //  HowManyDays = 35
       zTEST_Shared.runTriggers.add('CAS_SendNotifications');
       zTEST_Shared.runTriggers.add('CAS_SendFeedbackEmail');
       
        CAS_Inspection_Copy__c ic = new CAS_Inspection_Copy__c();
            ic.Opportunity__c = Opp.Id;
            ic.Opportunity_Product__c = oppProduct.Id;
            ic.Book_Order__c = '1234';
            ic.Book_Title__c = 'My title';
            ic.CreatedDate = system.now().date().addDays(-45);
            ic.Sent_Created_Notification__c = system.now().date().addDays(-45);
            ic.Sent_Feedback_Notification__c = null;
            ic.Sent_Type__c = null;
            IC.Sent_Feedback_ShortForm__c = null;
            IC.Number_of_Students__c = 1;
            ic.Course_Start_Date__c = system.now().date();
            ic.Recommend_title__c = 'Yes - Same Edition';
            ic.ISBN__c = '123';
            ic.Adoption_Level__c = 'Test';
            ic.Contact_Name__c = 'TEST.Shay.Spoonmore';
            ic.Contact_Email__c = 'Shay.Spoonmore@informaUSA.com';
            ic.IsTesting__c = true;
            ic.Adoption_Stage__c = 'I have adopted the book on my course AND recommended a copy for our library';
            ic.Order_Type__c = 'Send';
            ic.Adoption_Level__c='Required Textbook';
            insert ic;
            ic.QuestionAboutT_FProduct__c='Textbook';
            update ic;
 
    }

  
    static testMethod void UnitTest_SendEmailFeedBackShortForm() 
    
    {   
        
        //Pricebook2 s = [select id from Pricebook2 where IsStandard = true ];
        //Pricebook2 s = new Pricebook2(Id = '01s300000001JicAAE');       
        
        Id productRtId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products'); //CHG0038379
            
        Product2 p1 = new Product2(
                name='Test Product 1',
                ISBN__c='1234', 
                IsActive=true,
                Description='My Product',
                RecordTypeId=productRtId,
                ProductCode='12345',
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
        OpportunityLineItem oppProduct = setupOppLineItemsRecepinet(opp.Id,contactId, pbe1.Id);
        
        //Criteria
          //'Select Contact_Email__c, Contact_Name__c, CreatedDate, Id,Sent_Created_Notification__c, Sent_Feedback_Notification__c  from CAS_Inspection_Copy__c ';
          //' where Adoption_Short__c = null and Adoption_Stage__c = null and ';
          //'   Opportunity__r.IsClosed = false and Sent_Feedback_Notification__c != null and ';
          //'   Sent_Feedback_ShortForm__c = null and Number_of_Students__c <= 50 and ';
          //'   Sent_Feedback_Notification__c = LAST_N_DAYS:100 ';
          //HowManyDays = 90;
                
       zTEST_Shared.runTriggers.add('CAS_SendNotifications');
       zTEST_Shared.runTriggers.add('CAS_SendFeedbackEmail');
        CAS_Inspection_Copy__c ic = new CAS_Inspection_Copy__c();
            ic.Opportunity__c = Opp.Id;
            ic.Opportunity_Product__c = oppProduct.Id;
            ic.Book_Order__c = '1234';
            ic.Book_Title__c = 'My title';
            ic.Sent_Created_Notification__c= system.now().date().addDays(-150);
            ic.Sent_Feedback_Notification__c = system.now().date().addDays(-96);
            IC.Sent_Feedback_ShortForm__c = null;
            IC.Number_of_Students__c = 48;
            ic.Course_Start_Date__c = system.now().date();
            ic.Recommend_title__c = 'Yes - Same Edition';
            ic.ISBN__c = '123';
            ic.Adoption_Level__c = 'Test';
            ic.Contact_Name__c = 'TEST.Shay.Spoonmore';
            ic.Contact_Email__c= 'Shay.Spoonmore@informaUSA.com';
            ic.IsTesting__c = true;
        insert ic;
         
    }

    
    static testMethod void UnitTest_SendEmailFeedBackFollowUp() 
    
    {   
        
        //Pricebook2 s = [select id from Pricebook2 where IsStandard = true ];      
        //Pricebook2 s = new Pricebook2(Id = '01s300000001JicAAE');
        
        Id productRtId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products'); //CHG0038379
        
        Product2 p1 = new Product2(
                name='Test Product 1',
                ISBN__c='1234', 
                IsActive=true,
                Description='My Product',
                RecordTypeId=productRtId,
                ProductCode='12345',
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
        OpportunityLineItem oppProduct = setupOppLineItemsRecepinet(opp.Id,contactId, pbe1.Id);
        
        //Criteria
        //'Select Contact_Email__c, Contact_Name__c, CreatedDate, Id,Sent_Created_Notification__c, Sent_Feedback_Notification__c  from CAS_Inspection_Copy__c'; 
          //' where Adoption_Short__c = null and Adoption_Stage__c = null and'; 
          //' Opportunity__r.IsClosed = false and Sent_Feedback_Notification__c != null and'; 
          //' Sent_Feedback_FollowUp__c = null and Sent_Feedback_Notification__c = LAST_N_DAYS:20 ';
          //HowManyDays = 14; 
       zTEST_Shared.runTriggers.add('CAS_SendNotifications');
       zTEST_Shared.runTriggers.add('CAS_SendFeedbackEmail');
        CAS_Inspection_Copy__c ic = new CAS_Inspection_Copy__c();
            ic.Opportunity__c = Opp.Id;
            ic.Opportunity_Product__c = oppProduct.Id;
            ic.Book_Order__c = '1234';
            ic.Book_Title__c = 'My title';
            ic.Sent_Created_Notification__c= system.now().date().addDays(-40);
            ic.Sent_Feedback_Notification__c = system.now().date().addDays(-17);
            IC.Sent_Feedback_FollowUp__c = null;
            ic.Number_of_Students__c = 1;
            ic.Course_Start_Date__c = system.now().date();
            ic.Recommend_title__c = 'Yes - Same Edition';
            ic.ISBN__c = '123';
            ic.Adoption_Level__c = 'Test';
            ic.Contact_Name__c = 'TEST.Shay.Spoonmore';
            ic.Contact_Email__c= 'Shay.Spoonmore@informaUSA.com';
            ic.IsTesting__c = true;
        insert ic;
        
        
    }

   
    static testMethod void UnitTest_SendEmailInProcess_Available() 
    
    {   
        CASEmail.SendErrorEmail('Shay.Spoonmore@informaUSA.com','(UnitTest)Error - Sending Inspection Copy Emails','test');
        CASEmail.Testing = true;
        CASEmail.hasRunBeforeTrigger = false;
        
        //Pricebook2 s = [select id from Pricebook2 where IsStandard = true ];      
        //Pricebook2 s = new Pricebook2(Id = '01s300000001JicAAE');   
        
		Id productRtId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products'); //CHG0038379
        
        Product2 p1 = new Product2(
                name='Test Product 1',
                ISBN__c='1234', 
                IsActive=true,
                Description='My Product',
                RecordTypeId=productRtId,
                ProductCode='12345',
                UK_Inventory_Status__c = 'Available',
                UK_Publication_Date__c = system.now().date().addDays(-2),
                US_Inventory_Status__c = 'Available',
                US_Publication_Date__c = system.now().date().addDays(-2)
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
        System.debug(locale + ': locale Testing Sending email for CAS Inspections');
        
        Account account = setupTestAccount('TEST_1_' + locale);
        Opportunity opp = setupTestOpportunity('TEST_1' + locale, account.Id);
        Id contactId = createAccountAndContact('TestSinapore@test.com', locale);
        OpportunityLineItem oppProduct = setupOppLineItemsRecepinet(opp.Id,contactId, pbe1.Id);
       
       
         //Select Contact_Email__c, Contact_Name__c, CreatedDate, Id, Opportunity_Product__c, Sent_Created_Notification__c, Sent_Feedback_Notification__c, Sent_Not_Available_Date__c,Sent_Type__c'; 
        // from CAS_Inspection_Copy__c where Contact_Email__c != null AND Sent_Created_Notification__c = null '; 
       
       zTEST_Shared.runTriggers.add('CAS_SendNotifications');
       zTEST_Shared.runTriggers.add('CAS_SendFeedbackEmail');
        CAS_Inspection_Copy__c ic = new CAS_Inspection_Copy__c();
            ic.Opportunity__c = Opp.Id;
            ic.Opportunity_Product__c = oppProduct.Id;
            ic.Book_Order__c = '1234';
            ic.Book_Title__c = 'My title';
            ic.ISBN__c = '123';
            ic.Number_of_Students__c = 1;
            ic.Course_Start_Date__c = system.now().date();
            ic.Recommend_title__c = 'Yes - Same Edition';
            ic.Contact_Name__c = 'TEST.Shay.Spoonmore';
            ic.Contact_Email__c= 'Shay.Spoonmore@informaUSA.com';
            ic.IsTesting__c = true;
            ic.Adoption_Level__c = 'Test';
            ic.Sent_Created_Notification__c = null;
        insert ic;
        Contact c = [Select AccountId from Contact where id = :contactId];
        Account a = [Select locale__c from Account where id = :c.AccountId];
        System.debug('cic.Account.locale__c' + a.locale__c); 
        system.assertEquals(a.locale__c, locale);
        
        
        locale = 'EMEA';
        System.debug(locale + ': locale Testing Sending email for CAS Inspections');
        Account account2 = setupTestAccount('TEST_1_' + locale);
        Opportunity opp2 = setupTestOpportunity('TEST_1' + locale, account2.Id);
        Id contactId2 = createAccountAndContact('TestSinapore@test.com', locale);
        OpportunityLineItem oppProduct2 = setupOppLineItemsRecepinet(opp2.Id,contactId2, pbe1.Id);
       
        CAS_Inspection_Copy__c ic2 = new CAS_Inspection_Copy__c();
            ic2.Opportunity__c = Opp2.Id;
            ic2.Opportunity_Product__c = oppProduct2.Id;
            ic2.Book_Order__c = '1234';
            ic2.Book_Title__c = 'My title';
            ic2.ISBN__c = '123';
            ic2.Number_of_Students__c = 1;
            ic2.Course_Start_Date__c = system.now().date();
            ic2.Recommend_title__c = 'Yes - Same Edition';
            ic2.Contact_Name__c = 'TEST.Shay.Spoonmore';
            ic2.Contact_Email__c= 'Shay.Spoonmore@informaUSA.com';
            ic2.IsTesting__c =true;
            ic2.Sent_Created_Notification__c = null;
        insert ic2;
        
        OpportunityLineItem oliTest = [Select oli.Recipient__r.Account.Locale__c from OpportunityLineItem  oli where id = :ic2.Opportunity_Product__c];
        a = oliTest.Recipient__r.Account;
        System.debug('cic.Account.locale__c' + a.locale__c); 
        system.assertEquals(a.locale__c, locale);
        
        //Send created
        CAS_Inspection_Copy__c   cCreated = new CAS_Inspection_Copy__c(
            Contact_Email__c = 'Shay.Spoonmore@informaUSA.com' 
            ,Contact_Name__c = 'Shay Spoonmore ' + system.now()
            ,Opportunity__c = Opp2.Id
            ,Opportunity_Product__c = oppProduct2.Id
            ,Sent_Feedback_Notification__c = null
            ,Sent_Created_Notification__c = null 
            ,Sent_Not_Available_Date__c = null
            ,Shipping_Date__c = null
            ,Sent_Type__c = 'Singapore'
            ,Book_Order__c = '2'
            ,Book_Title__c = 'Test Book'
            ,ISBN__c = '978-0-415-39330-0' 
            ,IsTesting__c =true);
     insert cCreated ;  
        
        // test no locale
        locale = 'NoLocale';
        System.debug(locale + ': locale Testing Sending email for CAS Inspections');
        account2 = setupTestAccount('TEST_1_' + locale);
        opp2 = setupTestOpportunity('TEST_1' + locale, account2.Id);
        contactId2 = createAccountAndContact('TestSinapore@test.com', locale);
        oppProduct2 = setupOppLineItemsRecepinet(opp2.Id,contactId2, pbe1.Id);
       
        ic2 = new CAS_Inspection_Copy__c();
            ic2.Opportunity__c = Opp2.Id;
            ic2.Opportunity_Product__c = oppProduct2.Id;
            ic2.Book_Order__c = '1234';
            ic2.Book_Title__c = 'My title';
            ic2.ISBN__c = '123';
            ic2.Number_of_Students__c = 1;
            ic2.Course_Start_Date__c = system.now().date();
            ic2.Recommend_title__c = 'Yes - Same Edition';
            ic2.Contact_Name__c = 'TEST.Shay.Spoonmore';
            ic2.Contact_Email__c= 'Shay.Spoonmore@informaUSA.com';
            ic2.IsTesting__c =true;
            ic2.Sent_Created_Notification__c = null;
        insert ic2;
        
        oliTest = [Select oli.Recipient__r.Account.Locale__c from OpportunityLineItem  oli where id = :ic2.Opportunity_Product__c];
        a = oliTest.Recipient__r.Account;
        System.debug('cic.Account.locale__c' + a.locale__c); 
        system.assertEquals(a.locale__c, locale);
    }

  
    static testMethod void UnitTest_SendEmailInProcess_NotAvailable() 
    
    {   
        
        //Pricebook2 s = [select id from Pricebook2 where IsStandard = true ];
        //Pricebook2 s = new Pricebook2(Id = '01s300000001JicAAE');       
        
        Id productRtId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products'); //CHG0038379
        
        Product2 p1 = new Product2(
                name='Test Product 1',
                ISBN__c='1234', 
                IsActive=true,
                Description='My Product',
                RecordTypeId=productRtId,
                ProductCode='12345',
                UK_Inventory_Status__c = 'Available',
                UK_Publication_Date__c = system.now().date().addDays(4),
                US_Inventory_Status__c = 'Available',
                US_Publication_Date__c = system.now().date().addDays(4)
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
        System.debug(locale + ': locale Testing Sending email for CAS Inspections');
        
        Account account = setupTestAccount('TEST_1_' + locale);
        Opportunity opp = setupTestOpportunity('TEST_1' + locale, account.Id);
        Id contactId = createAccountAndContact('TestSinapore@test.com', locale);
        OpportunityLineItem oppProduct = setupOppLineItemsRecepinet(opp.Id,contactId, pbe1.Id);
       
       
         //Select Contact_Email__c, Contact_Name__c, CreatedDate, Id, Opportunity_Product__c, Sent_Created_Notification__c, Sent_Feedback_Notification__c, Sent_Not_Available_Date__c,Sent_Type__c'; 
        // from CAS_Inspection_Copy__c where Contact_Email__c != null AND Sent_Created_Notification__c = null '; 
       
       zTEST_Shared.runTriggers.add('CAS_SendNotifications');
       zTEST_Shared.runTriggers.add('CAS_SendFeedbackEmail');
        CAS_Inspection_Copy__c ic = new CAS_Inspection_Copy__c();
            ic.Opportunity__c = Opp.Id;
            ic.Opportunity_Product__c = oppProduct.Id;
            ic.Book_Order__c = '1234';
            ic.Book_Title__c = 'My title';
            ic.ISBN__c = '123';
            ic.Contact_Name__c = 'TEST.Shay.Spoonmore';
            ic.Contact_Email__c= 'Shay.Spoonmore@informaUSA.com';
            ic.Number_of_Students__c = 1;
            ic.Course_Start_Date__c = system.now().date();
            ic.Recommend_title__c = 'Yes - Same Edition';
            ic.IsTesting__c = true;
            ic.Adoption_Level__c = 'Test';
            ic.Sent_Created_Notification__c = null;
            ic.Sent_Not_Available_Date__c = system.now().date().addDays(-5);
        insert ic;
        Contact c = [Select AccountId from Contact where id = :contactId];
        Account a = [Select locale__c from Account where id = :c.AccountId];
        System.debug('cic.Account.locale__c' + a.locale__c); 
        system.assertEquals(a.locale__c, locale);
        
        
        locale = 'EMEA';
        System.debug(locale + ': locale Testing Sending email for CAS Inspections');
        Account account2 = setupTestAccount('TEST_1_' + locale);
        Opportunity opp2 = setupTestOpportunity('TEST_1' + locale, account2.Id);
        Id contactId2 = createAccountAndContact('TestSinapore@test.com', locale);
        OpportunityLineItem oppProduct2 = setupOppLineItemsRecepinet(opp2.Id,contactId2, pbe1.Id);
       
        CAS_Inspection_Copy__c ic2 = new CAS_Inspection_Copy__c();
            ic2.Opportunity__c = Opp2.Id;
            ic2.Opportunity_Product__c = oppProduct2.Id;
            ic2.Book_Order__c = '1234';
            ic2.Book_Title__c = 'My title';
            ic2.ISBN__c = '123';
            ic2.Number_of_Students__c = 1;
            ic2.Course_Start_Date__c = system.now().date();
            ic2.Recommend_title__c = 'Yes - Same Edition';
            ic2.Contact_Name__c = 'TEST.Shay.Spoonmore';
            ic2.Contact_Email__c= 'Shay.Spoonmore@informaUSA.com';
            ic2.IsTesting__c =true;
            ic2.Sent_Created_Notification__c = null;
            ic2.Sent_Not_Available_Date__c = system.now().date().addDays(-5);
        insert ic2;
        
        c = [Select AccountId from Contact where id = :contactId2];
        a = [Select locale__c from Account where id = :c.AccountId];
        System.debug('cic.Account.locale__c' + a.locale__c); 
        system.assertEquals(a.locale__c, locale);
        
    }

   
    static testMethod void UnitTest_SendCASEmail_Singapore() 
    {
        CASEmail.Testing = false;
        System.debug('Singapore:Testing Sending email for CAS Inspections');
        
        //Profile p = [select id from profile where name='Informa Integration User--P/W Never Expires']; //profile name changed, but this is not even used
    
        Account account = setupTestAccount('TEST_Singapore1');
        Opportunity opp = setupTestOpportunity('TEST_Singapore1', account.Id);
        
        //Criteria
        //'Select Contact_Email__c, Contact_Name__c, CreatedDate, Id,Sent_Created_Notification__c, Sent_Feedback_Notification__c, Shipping_Date__c  from CAS_Inspection_Copy__c'; 
        //' where Contact_Email__c != null AND Sent_Created_Notification__c != null AND ';
        //' Sent_Feedback_Notification__c = null AND Sent_Type__c = \'Singapore\' and '; 
        //' Shipping_Date__c != null ';  
        
        zTEST_Shared.runTriggers.add('CAS_SendNotifications');
       zTEST_Shared.runTriggers.add('CAS_SendFeedbackEmail');     
        CAS_Inspection_Copy__c c = new CAS_Inspection_Copy__c(
            Contact_Email__c = 'Shay.Spoonmore@informaUSA.com' 
            ,Contact_Name__c = 'Shay Spoonmore ' + system.now()
            ,Opportunity__c = Opp.Id
            ,Opportunity_Product__c = '00k60000007A0U9AAK' //apparently the id isn't important
            ,Sent_Feedback_Notification__c = null
            ,Sent_Created_Notification__c = system.now().date().adddays(-100) 
            ,Shipping_Date__c = system.now().date().adddays(-70)
            ,Sent_Type__c = 'Singapore'
            ,Book_Order__c = '2'
            ,Book_Title__c = 'Test Book'
            ,ISBN__c = '978-0-415-39330-0'
            ,Number_of_Students__c = 1
            ,Adoption_Level__c = 'Test'
            ,Course_Start_Date__c = system.now().date()
            ,Recommend_title__c = 'Yes - Same Edition'
            ,IsTesting__c =true);
           insert c ;   
            
}

   
    public static void CreateTestRecord_Singapore()
    {
        
        //Pricebook2 s = [select id from Pricebook2 where IsStandard = true ];      
        //Pricebook2 s = new Pricebook2(Id = '01s300000001JicAAE');   
        
        Id productRtId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products'); //CHG003837
        
        Product2 p1 = new Product2(
                name='Test Product 1',
                ISBN__c='1234', 
                IsActive=true,
                Description='My Product',
                RecordTypeId=productRtId,
                ProductCode='12345',
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
    
        Account account = setupTestAccount('TEST_Singapore1');
        Opportunity opp = setupTestOpportunity('TEST_Singapore1', account.Id);
        Id contactId = createAccountAndContact('TestSinapore@test.com', '');
        OpportunityLineItem oppProduct = setupOppLineItemsRecepinet(opp.Id,contactId, pbe1.Id);
        
        zTEST_Shared.runTriggers.add('CAS_SendNotifications');
       zTEST_Shared.runTriggers.add('CAS_SendFeedbackEmail');
        CAS_Inspection_Copy__c c = new CAS_Inspection_Copy__c(
        Contact_Email__c = 'Shay.Spoonmore@informaUSA.com' 
        ,Contact_Name__c = 'Shay Spoonmore ' + system.now()
        ,Opportunity__c = opp.Id
        ,Opportunity_Product__c = oppProduct.Id
        //c.CreatedDate, 
        ,Shipping_Date__c = system.now().date().adddays(-70)
        ,Sent_Type__c = 'Singapore'
        ,Book_Order__c = '2'
        ,Book_Title__c = 'Test Book'
        ,Adoption_Level__c = 'Test'
        ,ISBN__c = '978-0-415-39330-0'    
        ,IsTesting__c = true);
        
        insert c;
    
    
        
    }
 
    
    public static String CreateAccountAndContact(String email, String Locale) {
        
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
    
     public static Opportunity setupTestOpportunity(String oppName, ID accountId) {
        Opportunity opp = new Opportunity(
            name=oppName,
            Type = 'New Business',
            stagename='Verbal',
            Probability=80,
            closedate=Date.newInstance(2011, 01, 01),
            CurrencyIsoCode = 'EUR',
            accountId=accountId
        );
        insert opp;
        return opp;
    }       
    
    public static OpportunityLineItem setupOppLineItems(ID opportunityId) { 
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
    
    public static OpportunityLineItem setupOppLineItemsRecepinet(ID opportunityId, ID recipientId, ID pricebookId) { 
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
    
    
    public static Account setupTestAccount(String accountName) 
    {
        Account a = new Account(name=accountName,
            //OwnerId=userId,
            BillingStreet='1234 Main Street');  
        insert a;
        system.debug('a'+a);
        return a;
    } 
    
    public static Product2 CreateProduct2(String currencyIsoCode, String productName, String isbn)
    {
        
        //Pricebook2 s = [select id from Pricebook2 where IsStandard = true ];      
        //Pricebook2 s = new Pricebook2(Id = '01s300000001JicAAE');   
        
        Id productRtId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products'); //CHG003837
        
        Product2 p1 = new Product2(
                name=productName,
                ISBN__c=isbn, 
                IsActive=true,
                Description=productName,
                RecordTypeId=productRtId,
                ProductCode=isbn,
                UK_Inventory_Status__c = 'Available',
                UK_Publication_Date__c = system.now().date().addDays(-1),
                US_Inventory_Status__c = 'Available',
                US_Publication_Date__c = system.now().date().addDays(-1)
            );
        insert p1;
        
        // create the pricebookentry
        PricebookEntry pbe1 = new PricebookEntry(
            CurrencyIsoCode = CurrencyIsoCode, //'EUR'
            Pricebook2Id=Test.getStandardPricebookId(),
            Product2Id=p1.id, 
            UnitPrice=1.00, 
            IsActive=true, 
            UseStandardPrice=false
            );
        insert pbe1;
        
        return p1;
    }
    
    public static CAS_Inspection_Copy__c CreateInspectionCopy(String oppId, String oppProdId, String isbn)
    {
        
            CAS_Inspection_Copy__c ic = new CAS_Inspection_Copy__c();
            ic.Opportunity__c = oppId;
            ic.Opportunity_Product__c = oppProdId;
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
            ic.Adoption_Stage__c = 'I have adopted the book on my course AND recommended a copy for our library';
            ic.Order_Type__c = 'Send';
            ic.Adoption_Level__c='Required Textbook';
            insert ic;
            ic.QuestionAboutT_FProduct__c='Textbook';
            update ic;
                    
        
        return ic;
    }
    
    public static void GetRulesInspectionCopy()
    {
        
        List<CAS_Inspection_Copy__c> ics= [SELECT Adoption_Short__c,Adoption_Stage__c,Contact_Email__c,Order_Type__c, Do_Not_Send_Date__c,Do_Not_Send_Reason__c,Do_Not_Send__c,Id,CreatedDate,LastModifiedDate,Name,Opportunity_Product__c,Product__c,Sent_Created_Notification__c,Sent_Email_Failure__c,Sent_Email_Date__c,Sent_Feedback_FollowUp__c,Sent_Feedback_Notification__c,Sent_Feedback_ShortForm__c,Sent_Not_Available_Date__c,Sent_Type__c,Shipping_Date__c,SystemModstamp FROM CAS_Inspection_Copy__c ORDER BY LastModifiedDate DESC NULLS FIRST LIMIT 50];
        System.debug('##### ics.size(): ' + ics.size());
        
        if (ics.size() > 0)
        {
            
            Set<String> oppProductIds = new Set<String>();
            Map<ID, OpportunityLineItem> oppProductICopy = new Map<ID, OpportunityLineItem>();
        
            for(CAS_Inspection_Copy__c ic : ics)//get oppProduct ids to get data
            {
               oppProductIds.add(ic.Opportunity_Product__c);
            }
        
            If (oppProductIds.size()>0)//Map products
            {
                oppProductICopy = new Map<ID, OpportunityLineItem>([Select o.Id, o.PricebookEntryId, o.PricebookEntry.Product2Id,o.Adoption_Stage__c,
                                                            o.PricebookEntry.Product2.UK_Inventory_Status__c, o.PricebookEntry.Product2.UK_Publication_Date__c, o.PricebookEntry.Product2.US_Inventory_Status__c, o.PricebookEntry.Product2.US_Publication_Date__c,  o.Recipient__c, o.Recipient__r.Account.Locale__c, o.Recipient__r.AccountId from OpportunityLineItem o 
                                                            where  o.Id IN:oppProductIds]);//((o.PricebookEntry.Product2.US_Inventory_Status__c = 'Available' And o.PricebookEntry.Product2.US_Publication_Date__c != null) or (o.PricebookEntry.Product2.UK_Inventory_Status__c = 'Available' And o.PricebookEntry.Product2.UK_Publication_Date__c != null)) and o.Recipient__r.Account.Locale__c != null and
                    
                        System.debug('##### oppProductICopy.size(): ' + oppProductICopy.size());    
            } 
         
        
            for(CAS_Inspection_Copy__c ic : ics)
        {
            OpportunityLineItem oppProdLine = oppProductICopy.get(ic.Opportunity_Product__c);
            
            
            if(oppProdLine  == Null)
            {
                System.debug('##### OpportunityLineItem does not exist!');
            }
            else if(oppProdLine.Recipient__r  == Null ||  oppProdLine.Recipient__r.Account == Null)
            {
                System.debug('##### Recipient or Account doesn\'t exist!');
            }
            else
            {
            Product2 oppProd = oppProdLine.PricebookEntry.Product2;
            Account  oppProdAccount =  oppProdLine.Recipient__r.Account;
            System.debug('##### oppProdLine.Id: ' + oppProdLine.Id );
            
            
            
            System.debug('##### InspectionCopy.Id : ' +ic.Id );
            System.debug('##### oppProdLine.Id: ' + oppProdLine.Id );
            System.debug('##### oppProdAccount.Locale__c: ' + oppProdAccount.Locale__c );
            System.debug('##### oppProd.US_Publication_Date__c: ' + oppProd.US_Publication_Date__c );
            System.debug('##### oppProd.US_Inventory_Status__c: ' + oppProd.US_Inventory_Status__c );
            System.debug('##### oppProd.UK_Publication_Date__c: ' + oppProd.UK_Publication_Date__c );
            System.debug('##### oppProd.UK_Inventory_Status__c: ' + oppProd.UK_Inventory_Status__c );
            System.debug('##### oppProdLine.Adoption_Stage__c: ' + oppProdLine.Adoption_Stage__c );
            System.debug('##### System.now().date: ' + System.now().date());
            
        
            if(ic.Contact_Email__c == Null)
            {
                System.debug('##### Email doesn\'t exist!' );
            }
            else if (oppProdLine.Adoption_Stage__c.contains('Completed') || oppProdLine.Adoption_Stage__c == 'Never Received Product')//!= 'In-Process'
            {
                    System.debug('##### Opportunity Product Adoption Stage is in "' + oppProdLine.Adoption_Stage__c +'"!' );
            }
            else if (ic.Sent_Type__c == 'Singapore')//Always send created notification to Singapore, this is setup in the IC trigger on OLI if fulfillment house isnt null
            {
                System.debug('##### Singapore' );
                
            }
            else if (oppProdAccount.Locale__c != 'AMERICAS' && oppProdAccount.Locale__c != 'EMEA' )
            {
                System.debug('##### Recipient Account Local is not in AMERICAS or EMEA!' );
             }
            else if(oppProdAccount.Locale__c == 'AMERICAS' && (oppProd.US_Inventory_Status__c != 'Available' || (oppProd.US_Publication_Date__c > System.now().date() || oppProd.US_Publication_Date__c == null)))
            {//product not available
                System.debug('##### US product not available!' );
            }
            else if(oppProdAccount.Locale__c == 'EMEA' && (oppProd.UK_Inventory_Status__c != 'Available' || (oppProd.UK_Publication_Date__c > System.now().date() || oppProd.UK_Publication_Date__c == null)))
            {//product not available
                System.debug('##### UK product not available!' );
            }
            else if (oppProdAccount.Locale__c == 'AMERICAS' && oppProd.US_Inventory_Status__c == 'Available' && oppProd.US_Publication_Date__c <= System.now().date())
            {                  
                System.debug('##### Send Americas' );
                
            }
            else if (oppProdAccount.Locale__c == 'EMEA' && oppProd.UK_Inventory_Status__c == 'Available' && oppProd.UK_Publication_Date__c <= System.now().date())
            {
                System.debug('##### Send EMEA' );
                
            }
            else // Now process records
            {
                System.debug('##### Research why record isnt processing ' + ic.Id); 
                
    
            }
            
            
            
            }
        
        }
            
            
            
        }
                    
        
        
    }
    
    
    
    
}