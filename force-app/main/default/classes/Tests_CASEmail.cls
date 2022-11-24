/************************************************************************** 
** Test Send Email
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2011-05-02
**	Coverge 88% 
***************************************************************************/
@isTest
private class Tests_CASEmail { 


	static testMethod void UnitTest_CAS_SendNotificationsSchedule() 
    {
    	// Schedule the test job
    	//Test.startTest(); 
    	//CAS_SendNotificationsSchedule m = new CAS_SendNotificationsSchedule();
    	//String sch = '20 30 8 10 2 ?';
		//System.schedule('Test_CAS_SendNotificationsSchedule',sch, m);
		//Test.stopTest();
		//moved to UnitTest_SendEmailFeedBack()
    }
    
    static testMethod void UnitTest_SendEmailFeedBack() 
    
    {	

       	Pricebook2 s = [select id from Pricebook2 where IsStandard = true ];		
					
		Product2 p1 = new Product2(
				name='Test Product 1',
				ISBN__c='1234', 
				IsActive=true,
				Description='My Product',
				RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Article').getRecordTypeId(),
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
				Pricebook2Id=s.id,
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
        //	HowManyDays = 35
       zTEST_Shared.runTriggers.add('CAS_SendNotifications');
       zTEST_Shared.runTriggers.add('CAS_SendFeedbackEmail');
       
        CAS_Inspection_Copy__c ic = new CAS_Inspection_Copy__c();
			ic.Opportunity__c = Opp.Id;
			ic.Opportunity_Product__c = oppProduct.Id;//'00k60000006hH5JAAU';
			ic.Book_Order__c = '1234';
			ic.Book_Title__c = 'My title';
			ic.CreatedDate = system.now().date().addDays(-45);
			ic.Sent_Created_Notification__c = system.now().date().addDays(-45);
			ic.Sent_Feedback_Notification__c = null;
			ic.Sent_Type__c = null;
			IC.Sent_Feedback_ShortForm__c = null;
			IC.Number_of_Students__c = 1;
			ic.ISBN__c = '123';
			ic.Contact_Name__c = 'TEST.Shay.Spoonmore';
			ic.Contact_Email__c = 'Shay.Spoonmore@informaUSA.com';
			ic.IsTesting__c = true;
           	ic.Adoption_Stage__c='I would like to return this book';
		insert ic;
		
		
		// Schedule the test job
    	Test.startTest(); 
    	CAS_SendNotificationsSchedule m = new CAS_SendNotificationsSchedule();
    	String sch = '20 30 8 10 2 ?';
		System.schedule('Test_CAS_SendNotificationsSchedule',sch, m);
		Test.stopTest();
        
    }
    
    
    
    static testMethod void UnitTest_SendEmailFeedBackShortForm() 
    
    {	
       	
       	Pricebook2 s = [select id from Pricebook2 where IsStandard = true ];		
					
		Product2 p1 = new Product2(
				name='Test Product 1',
				ISBN__c='1234', 
				IsActive=true,
				Description='My Product',
				RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Article').getRecordTypeId(),
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
				Pricebook2Id=s.id,
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
          //'	Opportunity__r.IsClosed = false and Sent_Feedback_Notification__c != null and ';
          //'	Sent_Feedback_ShortForm__c = null and Number_of_Students__c <= 50 and ';
          //'	Sent_Feedback_Notification__c = LAST_N_DAYS:100 ';
          //HowManyDays = 90;
                
       zTEST_Shared.runTriggers.add('CAS_SendNotifications');
       zTEST_Shared.runTriggers.add('CAS_SendFeedbackEmail');
        CAS_Inspection_Copy__c ic = new CAS_Inspection_Copy__c();
			ic.Opportunity__c = Opp.Id;
			ic.Opportunity_Product__c = oppProduct.Id;//'00k60000006hH5JAAU';
			ic.Book_Order__c = '1234';
			ic.Book_Title__c = 'My title';
			ic.Sent_Created_Notification__c= system.now().date().addDays(-150);
			ic.Sent_Feedback_Notification__c = system.now().date().addDays(-96);
			IC.Sent_Feedback_ShortForm__c = null;
			IC.Number_of_Students__c = 48;
			ic.ISBN__c = '123';
			ic.Contact_Name__c = 'TEST.Shay.Spoonmore';
			ic.Contact_Email__c= 'Shay.Spoonmore@informaUSA.com';
			ic.IsTesting__c = true;
		insert ic;
         
    }
    
    static testMethod void UnitTest_SendEmailFeedBackFollowUp() 
    
    {	
       	
       	Pricebook2 s = [select id from Pricebook2 where IsStandard = true ];		
					
		Product2 p1 = new Product2(
				name='Test Product 1',
				ISBN__c='1234', 
				IsActive=true,
				Description='My Product',
				RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Article').getRecordTypeId(),
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
				Pricebook2Id=s.id,
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
			ic.Opportunity_Product__c = oppProduct.Id;//'00k60000006hH5JAAU';
			ic.Book_Order__c = '1234';
			ic.Book_Title__c = 'My title';
			ic.Sent_Created_Notification__c= system.now().date().addDays(-40);
			ic.Sent_Feedback_Notification__c = system.now().date().addDays(-17);
			IC.Sent_Feedback_FollowUp__c = null;
			ic.ISBN__c = '123';
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
       	
       	Pricebook2 s = [select id from Pricebook2 where IsStandard = true ];		
					
		Product2 p1 = new Product2(
				name='Test Product 1',
				ISBN__c='1234', 
				IsActive=true,
				Description='My Product',
				RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Article').getRecordTypeId(),
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
				Pricebook2Id=s.id,
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
			ic.Opportunity_Product__c = oppProduct.Id;//'00k60000006hH5JAAU';
			ic.Book_Order__c = '1234';
			ic.Book_Title__c = 'My title';
			ic.ISBN__c = '123';
			ic.Contact_Name__c = 'TEST.Shay.Spoonmore';
			ic.Contact_Email__c= 'Shay.Spoonmore@informaUSA.com';
			ic.IsTesting__c = true;
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
			ic2.Opportunity_Product__c = oppProduct2.Id;//'00k60000006hH5JAAU';
			ic2.Book_Order__c = '1234';
			ic2.Book_Title__c = 'My title';
			ic2.ISBN__c = '123';
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
			ic2.Opportunity_Product__c = oppProduct2.Id;//'00k60000006hH5JAAU';
			ic2.Book_Order__c = '1234';
			ic2.Book_Title__c = 'My title';
			ic2.ISBN__c = '123';
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
       	
       	Pricebook2 s = [select id from Pricebook2 where IsStandard = true ];		
					
		Product2 p1 = new Product2(
				name='Test Product 1',
				ISBN__c='1234', 
				IsActive=true,
				Description='My Product',
				RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Article').getRecordTypeId(),
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
				Pricebook2Id=s.id,
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
			ic.Opportunity_Product__c = oppProduct.Id;//'00k60000006hH5JAAU';
			ic.Book_Order__c = '1234';
			ic.Book_Title__c = 'My title';
			ic.ISBN__c = '123';
			ic.Contact_Name__c = 'TEST.Shay.Spoonmore';
			ic.Contact_Email__c= 'Shay.Spoonmore@informaUSA.com';
			ic.IsTesting__c = true;
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
			ic2.Opportunity_Product__c = oppProduct2.Id;//'00k60000006hH5JAAU';
			ic2.Book_Order__c = '1234';
			ic2.Book_Title__c = 'My title';
			ic2.ISBN__c = '123';
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
        
      	//Profile p = [select id from profile where name='Informa Integration User--P/W Never Expires'];
    
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
		    ,Opportunity_Product__c = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Article').getRecordTypeId()
		    ,Sent_Feedback_Notification__c = null
		    ,Sent_Created_Notification__c = system.now().date().adddays(-100) 
		    ,Shipping_Date__c = system.now().date().adddays(-70)
		    ,Sent_Type__c = 'Singapore'
		    ,Book_Order__c = '2'
		    ,Book_Title__c = 'Test Book'
		    ,ISBN__c = '978-0-415-39330-0' 
		    ,IsTesting__c =true);
		   insert c ;   
		   
		   
		    
}
    
    
    public static void CreateTestRecord_Singapore()
    {
        
	    Pricebook2 s = [select id from Pricebook2 where IsStandard = true ];		
					
		Product2 p1 = new Product2(
				name='Test Product 1',
				ISBN__c='1234', 
				IsActive=true,
				Description='My Product',
				RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Article').getRecordTypeId(),
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
			Pricebook2Id=s.id,
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
	
	 private static Opportunity setupTestOpportunity(String oppName, ID accountId) {
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