/************************************************************************** 
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2014-09-26
** NOTE: 
***************************************************************************/
@isTest
private class zTest_CASTextBookFeedbackLink {

    static testMethod void myUnitTest() 
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
				UK_Inventory_Status__c = 'Available',
				UK_Publication_Date__c = system.now().date().addDays(-1),
				US_Inventory_Status__c = 'Available',
				US_Publication_Date__c = system.now().date().addDays(-1)
			);
		insert p1;
		
		// create the pricebookentry
		PricebookEntry pbe1 = new PricebookEntry(
				CurrencyIsoCode = 'EUR',
				Pricebook2Id = Test.getStandardPricebookId(),
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
			ic.ISBN__c = '123';
			ic.Contact_Name__c = 'TEST.Shay.Spoonmore';
			ic.Contact_Email__c = 'Shay.Spoonmore@informaUSA.com';
			ic.IsTesting__c = true;
		insert ic;
		
		
		
		
				
				PageReference pref = Page.TextBook_Feedback_Link;        
				pref.getParameters().put('id',oppProduct.Id);        
				Test.setCurrentPage(pref);                
				CASTextBookFeedbackLink tbf1 = new CASTextBookFeedbackLink(new ApexPages.StandardController(oppProduct));        
				tbf1.GetTextLink = null;        
				//test a no id 
				pref.getParameters().put('id',' ');        
				Test.setCurrentPage(pref);                
				CASTextBookFeedbackLink tbf2 = new CASTextBookFeedbackLink(new ApexPages.StandardController(oppProduct));        
				tbf2.GetTextLink = oppProduct.Id;        
				System.debug('####tbf2.GetTextLink = ' + tbf2.GetTextLink);
				
				
				oppProduct.Adoption_Stage__c = 'In-Process';
				Update oppProduct;
				pref.getParameters().put('id',oppProduct.Id);        
				Test.setCurrentPage(pref);                                
				tbf1 = new CASTextBookFeedbackLink(new ApexPages.StandardController(oppProduct)); 
				
				
				Delete ic;       
				Test.setCurrentPage(pref);                
				ApexPages.currentPage().getParameters().put('id',oppProduct.id);                
				tbf2 = new CASTextBookFeedbackLink(new ApexPages.StandardController(oppProduct));      
				//system.assertEquals(tbf2.GetTextLink, 'No Textbook Feedback Record.');  
				    
	}        
				
             
	
	           
	
    
    
    
    
    
    
    
  private static String CreateAccountAndContact(String email, String Locale) {
		
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
		//oli.Book_Order__c = 100;
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