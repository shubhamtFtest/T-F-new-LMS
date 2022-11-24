/**************************************************
* Created by Shay Spoonmore
* Shay.Spoonmore@informausa.com 
* Controller for the CAS Sites ICFeedback2 page.
* Last Modified 2011.04.22
* Modified by Jeff Lup - 2017.10.09 - CHG0038379
**************************************************/
@isTest
private class Tests_CASFeedback2Controller {

    static testMethod void myUnitTest() 
    {
    	zTEST_Shared.runTriggers.add('CAS_SendNotifications');
       	zTEST_Shared.runTriggers.add('CAS_SendFeedbackEmail');
    	//user u = [Select id from User where id = '005600000013ck5'];//Site User
        //user u = [Select id from User where name = 'Taylor and Francis Books Site Guest User'];
        user u = [Select id from User where name = 'Taylor and Francis Site Guest User'];
        
    	
    	//Pricebook2 s = new Pricebook2(Id = '01s300000001JicAAE');//[select id from Pricebook2 where IsStandard = true ];    
        //s.Id = '01s300000001JicAAE';
        Pricebook2 s = new Pricebook2(Id = Test.getStandardPricebookId()); //CHG0038379
        
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
        
        //Setup a reference to the page the controller is expecting with the parameters
        ic.Adoption_Short__c = 'Yes';
        ic.Adoption_Level__c = 'Highly Recommended';
        update(ic);
        
        PageReference pref = Page.ICFeedback2;
        pref.getParameters().put('id',ic.Id);
        Test.setCurrentPage(pref);
        CASFeedback2Controller con = new CASFeedback2Controller();
        con.showButton = null;
        con.showAdoptionLevel = null;
        con.showReasonLost = null;
        pref = con.save();
        
        
        ic.Adoption_Short__c = 'No';
        ic.Adoption_Level__c = null;
        ic.Reason_Lost__c = 'Chose a book from another publisher';
        update(ic);
        PageReference pref1 = Page.ICFeedback2;
        pref1.getParameters().put('id',ic.Id);
        Test.setCurrentPage(pref1);
        CASFeedback2Controller con1 = new CASFeedback2Controller();
        pref1 = con1.save();
        
        ic.Adoption_Short__c = null;
        ic.Adoption_Level__c = null;
        update(ic);
        PageReference pref2 = Page.ICFeedback2;
        pref2.getParameters().put('id',ic.Id);
        Test.setCurrentPage(pref2);
        CASFeedback2Controller con2 = new CASFeedback2Controller();
        
        pref2 = con2.save(); 
        
        
        ic.Adoption_Short__c = 'No';
        ic.Adoption_Level__c = null;
        update(ic);
        
        PageReference pref3 = Page.ICFeedback2;
        pref3.getParameters().put('id',ic.Id);
        Test.setCurrentPage(pref3);
        CASFeedback2Controller con3 = new CASFeedback2Controller();
        pref3 = con3.save();
        
       
        ic.Adoption_Short__c = 'Yes';
        ic.Adoption_Level__c = null;
      	update ic;
      	
       System.runAs(u)
        {
        PageReference pref4 = Page.ICFeedback2;
        pref4.getParameters().put('id',ic.Id);
        Test.setCurrentPage(pref4);
        CASFeedback2Controller con4 = new CASFeedback2Controller( );
        pref4 = con4.save();
    }
        
        ic.Adoption_Short__c = 'Under Review';
        ic.Adoption_Level__c = null;
        update(ic);
        PageReference pref5 = Page.ICFeedback2;
        pref5.getParameters().put('id',ic.Id);
        Test.setCurrentPage(pref5);
        CASFeedback2Controller con5 = new CASFeedback2Controller();
        pref5 = con5.save();
        
        //test redirect rep verified
        oppProduct.Rep_Verified__c = true;
        update(oppProduct);
        pref5 = Page.ICFeedback2;
        pref5.getParameters().put('id',ic.Id);
        Test.setCurrentPage(pref5);
        con5 = new CASFeedback2Controller();
        pref5 = con5.save();
        oppProduct.Rep_Verified__c = false;
        update(oppProduct);
        
        //test a no id 
        PageReference prefBlank = Page.ICFeedback2;
        prefBlank.getParameters().put('id',' ');
        Test.setCurrentPage(prefBlank );
        CASFeedback2Controller conBlank = new CASFeedback2Controller();
        //prefBlank = conBlank.save();
        
        try{
        PageReference prefX = Page.ICFeedback2;
        prefX.getParameters().put('id','X');
        Test.setCurrentPage(prefX);
        CASFeedback2Controller conX = new CASFeedback2Controller();
        prefX = conX.save(); 
        }
        catch (Exception e)
        {
        System.debug('>>>>>>' + e + '<<<<<<<');
        }
        
        //test sensding an incorrect id
        PageReference preId = Page.ICFeedback2;
        preId.getParameters().put('id','005600000013ck5');
        Test.setCurrentPage(preId);
      
        
        //PageReference displayPage = Page.ICFeedback_Return;
        
        //System.debug('####myUnitTest.tbf1.GetTextLink = ' + tbf1.GetTextLink);
    }
    
    
    static testMethod void UnitTest_MethodMaps()
    {
    	
    	
    	CASFeedback2Controller tbf1 = new CASFeedback2Controller();
        tbf1.getMappedAdoptionShort('Yes'); 
        tbf1.getMappedAdoptionShort('No'); 
        tbf1.getMappedAdoptionShort('Under Review'); 
        tbf1.getMappedAdoptionShort(' '); 
        
        tbf1.getMappedStage('Completed - Adopted'); 
        tbf1.getMappedStage('Completed - Not appropriate'); 
        tbf1.getMappedStage('Open - Under Consideration'); 
        tbf1.getMappedStage(' '); 
        
        tbf1.getMappedReasonLost('Chose a book from another publisher'); 
        tbf1.getMappedReasonLost('Chose another Taylor and Francis book'); 
        tbf1.getMappedReasonLost('Open - Under Consideration'); 
        tbf1.getMappedReasonLost(' '); 
        
        tbf1.getMappedAdoptionLevel('Required Textbook'); 
        tbf1.getMappedAdoptionLevel('Highly Recommended'); 
        tbf1.getMappedAdoptionLevel('Open - Under Consideration'); 
        tbf1.getMappedAdoptionLevel(' '); 
    	
    
    }
    
    static testMethod void UnitTest_Pages() 
    {
    	//CAS_Inspection_Copy__c[] ic = [Select c.Id, c.Name,
        //		c.Opportunity__c, c.Book_Order__c, c.Opportunity_Product__c
        //		, c.SystemModstamp  
        //		, c.Adoption_Stage__c
    	//		,c.Adoption_Level__c
    	//		, c.Adoption_Short__c, c.Contact_Rep__c, c.Additional_Comments__c
    	//		, c.IsAdoptionShort__c, c.Reason_Lost__c
    	//	from CAS_Inspection_Copy__c c
        //	where c.Book_Order__c != null and c.Opportunity_Product__c != null order by c.SystemModstamp  desc limit 10];
        
        //Pricebook2 s = new Pricebook2(Id = '01s300000001JicAAE');//[select id from Pricebook2 where IsStandard = true ];    
        //s.Id = '01s300000001JicAAE';

        Pricebook2 s = new Pricebook2(Id = Test.getStandardPricebookId()); //CHG0038379
        
        Id productRtId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products'); //CHG0038379

        Product2 p1 = new Product2(
                name='Test Product 2',
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
    	
    	
    	 CAS_Inspection_Copy__c ic = new CAS_Inspection_Copy__c();
            ic.Opportunity__c = Opp.Id;
            ic.Opportunity_Product__c = oppProduct.Id;//'00k60000006hH5JAAU';
            ic.Book_Order__c = '1234';
            ic.Book_Title__c = 'My title 55';
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
        	
       	PageReference pref = Page.ICFeedback2;
        Test.setCurrentPage(pref);
        
        ApexPages.currentPage().getParameters().put('id',ic.Id);
        CASFeedback2Controller con = new CASFeedback2Controller();
       
        con.ic.Adoption_Short__c = 'Yes';
        con.ic.Adoption_Level__c = 'Required Textbook';
        system.assertEquals(con.showAdoptionLevel, true);
        system.assertEquals(con.showButton, true);
        system.assertEquals(con.showReasonLost, false);
        con.save();
        
        ApexPages.currentPage().getParameters().put('id',ic.Id);
        con = new CASFeedback2Controller();
        con.ic.Adoption_Short__c = 'No';
        con.ic.Adoption_Level__c = null;
        system.assertEquals(con.showReasonLost, true);
        con.save();
        
        ApexPages.currentPage().getParameters().put('id',ic.Id);
        con = new CASFeedback2Controller();
        con.ic.Adoption_Short__c = null;
        con.ic.Adoption_Level__c = null;
        system.assertEquals(con.showAdoptionLevel, false);
        system.assertEquals(con.showButton, false);
        system.assertEquals(con.isValidId(), null);
        con.save();
        
        ApexPages.currentPage().getParameters().put('id',' ');
        con = new CASFeedback2Controller();
        //PageReference newRef = Page.ICHome;
        system.assertEquals(con.isValidId().getUrl(), '/apex/ichome');
  
        
        
        	
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