@isTest
private class Tests_CASEmailIssue {
	/**
	static testMethod void UnitTest_CASEmailIssue() 
    {	
    	
    	Pricebook2 s = [select id from Pricebook2 where IsStandard = true ];		
					
		Product2 p1 = new Product2(
				name='Test Product 1',
				ISBN__c='1234', 
				IsActive=true,
				Description='My Product',
				RecordTypeId='01260000000DTeK',
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
        
	    Account account = setupTestAccount('TEST_Issue_' + locale);
	    Opportunity opp = setupTestOpportunity('TEST_Issue' + locale, account.Id);
	    Id contactId = createAccountAndContact('TestCASIssue@test.com', locale);
	    OpportunityLineItem oppProduct = setupOppLineItemsRecepinet(opp.Id,contactId, pbe1.Id);
	    
        	
       
        CAS_Inspection_Copy__c ic = new CAS_Inspection_Copy__c();
			ic.Opportunity__c = Opp.Id;
			ic.Opportunity_Product__c = oppProduct.Id;//'00k60000006hH5JAAU';
			ic.Book_Order__c = '1234';
			ic.Book_Title__c = 'My title';
			//ic.CreatedDate = system.now().date().addYears(10);
			ic.Sent_Created_Notification__c = system.now().date().addYears(10);
			ic.Sent_Feedback_Notification__c = system.now().date().addYears(10);
			ic.Sent_Feedback_FollowUp__c = system.now().date().addYears(10);
			ic.Sent_Feedback_ShortForm__c = system.now().date().addYears(10);
			ic.Sent_Type__c = null;
			IC.Sent_Feedback_ShortForm__c = null;
			IC.Number_of_Students__c = 1;
			ic.ISBN__c = '123';
			ic.Contact_Name__c = 'TEST.Shay.Spoonmore';
			ic.Contact_Email__c = 'Shay.Spoonmore@informaUSA.com';
			ic.System_Id__c = 'issue';
			ic.IsTesting__c = true;
		insert ic;
        
    	
    	Test.StartTest();
    	
    	CASEmailIssue.SendBacklog(true);//test method
    	
    	//test calling the batch not in testing mode
    	CASEmailIssue send = new CASEmailIssue();
    	send.query = 'Select Contact_Email__c, Contact_Name__c, CreatedDate, Id, Opportunity_Product__c, Sent_Created_Notification__c, Sent_Feedback_Notification__c, Sent_Not_Available_Date__c,System_Id__c, SystemModstamp from CAS_Inspection_Copy__c c where System_Id__c =\'issue\' Order by CreatedDate DESC ';
   		send.orgId =[select Id from Organization].Id;
   		send.templateId = '00X60000000sksNEAQ';
		send.isTesting=false;
		send.recordLimit = '1';
		ID batchprocessid = Database.executeBatch(send);
		Test.StopTest();
		
		System.AssertEquals(database.countquery('SELECT count() from CAS_Inspection_Copy__c where System_Id__c =\'issue\' '), 1);

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
	**/
}