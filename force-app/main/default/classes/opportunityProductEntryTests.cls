@isTest(SeeAllData=true)
private class opportunityProductEntryTests {

    static testMethod void OtherDealTypeTest() {
        //OpportunityLineItem oli = [select Id, Unique__c, PricebookEntryId, PricebookEntry.Pricebook2Id, PricebookEntry.Name, PriceBookEntry.Product2Id, OpportunityId, Opportunity.AccountId from OpportunityLineItem where Unique__c != null and Opportunity.Deal_Type__c != 'Price Agreement' limit 1];      
        //OpportunityLineItem oli = [select Id, Unique__c, PricebookEntryId, PricebookEntry.Pricebook2Id, PricebookEntry.Name, PriceBookEntry.Product2Id, OpportunityId, Opportunity.AccountId from OpportunityLineItem where Opportunity.Deal_Type__c != 'Price Agreement' AND Opportunity.Owner.IsActive = TRUE limit 1];      
        //OpportunityLineItem oli = [select Id, Unique__c, PricebookEntryId, PricebookEntry.Pricebook2Id, PricebookEntry.Name, PriceBookEntry.Product2Id, OpportunityId, Opportunity.AccountId from OpportunityLineItem where Opportunity.Deal_Type__c != 'Price Agreement' AND Opportunity.Owner.IsActive = TRUE AND Opportunity.End_Date__c != null limit 1];      
        
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Opportunity'); //CHG0038379
        
        Opportunity opp = zTEST_Shared.noinsertOpportunity(oppRtId, u.Id, a.Id);
        opp.End_Date__c = system.today();
        insert opp;
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry();
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.Quantity = 1;
        oli.unitPrice = 1;
        oli.PricebookEntryId = pbe.Id;
        oli.OpportunityId = opp.Id;
        insert oli;
        
        system.debug('xxxoli: ' + oli);
        
        ////////////////////////////////////////
        //  test opportunityProductEntry
        ////////////////////////////////////////
        
        // load the page       
        PageReference pageRef = Page.opportunityProductEntry;
        pageRef.getParameters().put('Id',oli.OpportunityId);
        Test.setCurrentPageReference(pageRef);
        
        // load the extension
        oli.Opportunity = [SELECT ID, AccountId FROM Opportunity WHERE Id = :oli.OpportunityId];
        opportunityProductEntryExtension oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(oli.Opportunity));
        system.debug('xxxoPEE: ' + oPEE);
        
        // test 'getChosenCurrency' method
        /*
        if(UserInfo.isMultiCurrencyOrganization())
            System.assert(oPEE.getChosenCurrency()!='');
        else
            System.assertEquals(oPEE.getChosenCurrency(),'');
        */
        
        // we know that there is at least one line item, so we confirm
        Integer startCount = oPEE.ShoppingCart.size();
        //system.assert(startCount>0);

        //test search functionality without finding anything
        oPEE.searchString = 'Chris O is a hip cat';
        oPEE.updateAvailableList();
        //system.assert(oPEE.AvailableProducts.size()==0);
        
        //test remove from shopping cart
        //oPEE.toUnselect = oli.Unique__c;
        oPEE.toUnselect = '1';
        oPEE.removeFromShoppingCart();
        //system.assertEquals(startCount-1, oPEE.shoppingCart.size());
        
        //test save and reload extension
        oPEE.onSave();
        //system.assert(!ApexPages.hasMessages());
        
        oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(oli.Opportunity));
        //system.assertEquals(startCount-1, oPEE.shoppingCart.size());
        
        // test search again, this time we will find something
        oPEE.searchString = oli.PricebookEntry.Name;
        oPEE.updateAvailableList();
        //system.assert(oPEE.AvailableProducts.size()>0);       

        //test add to Shopping Cart function
        oPEE.toSelect = oPEE.AvailableProducts[0].Id;
        oPEE.addToShoppingCart();
        //system.assertEquals(startCount, oPEE.shoppingCart.size());
                
        // test save method - WITHOUT quanitities and amounts entered and confirm that error message is displayed
        /*
        for(OpportunityLineItem o : oPEE.ShoppingCart){
            o.quantity = null;
            o.unitprice = null;
        }
        */
        for(opportunityProductEntryExtension.Cart cart : oPEE.ShoppingCart){
            cart.oli.quantity = null;
            cart.oli.unitprice = null;
        }
        
        oPEE.onSave();
        //system.assert(ApexPages.hasMessages()); //2014.11.10
        

        // add required info and try save again
        /*
        for(OpportunityLineItem o : oPEE.ShoppingCart){
            o.quantity = 5;
            o.unitprice = 300;
        }
        */
        for(opportunityProductEntryExtension.Cart cart : oPEE.ShoppingCart){
            cart.oli.quantity = 5;
            cart.oli.unitprice = 300;
        }
        oPEE.onSave();

        //query line items to confirm that the save worked
        opportunityLineItem[] oli2 = [select Id from opportunityLineItem where OpportunityId = :oli.OpportunityId];
        //system.assertEquals(startCount, oli2.size());
        
        // test on new Opp (no pricebook selected) to make sure redirect is happening
        Opportunity newOpp = new Opportunity(Name='New Opp',stageName='Pipeline',Amount=10,closeDate=System.Today()+30,AccountId=oli.Opportunity.AccountId);
        insert(newOpp);
        oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(newOpp));
        //System.assert(oPEE.priceBookCheck()!=null);
        
        // final quick check of cancel button
        //System.assert(oPEE.onCancel()!=null);
        
        
        ////////////////////////////////////////
        //  test redirect page
        ////////////////////////////////////////
        
        // load the page
        pageRef = Page.opportunityProductRedirect;
        pageRef.getParameters().put('Id', oli2[0].Id);
        Test.setCurrentPageReference(pageRef);

        // load the extension and confirm that redirect function returns something
        opportunityProductRedirectExtension oPRE = new opportunityProductRedirectExtension(new ApexPages.StandardController(oli2[0]));
        //System.assert(oPRE.redirect()!=null);
    }
    
    static testMethod void PriceAgreementShoppingCartTest() {
        //OpportunityLineItem oli = [select Id, Unique__c, PricebookEntryId, PricebookEntry.Pricebook2Id, PricebookEntry.Name, PriceBookEntry.Product2Id, OpportunityId, Opportunity.AccountId from OpportunityLineItem where Unique__c != null and Opportunity.Deal_Type__c = 'Price Agreement' limit 1];      
        //OpportunityLineItem oli = [select Id, Unique__c, PricebookEntryId, PricebookEntry.Pricebook2Id, PricebookEntry.Name, PriceBookEntry.Product2Id, OpportunityId, Opportunity.AccountId from OpportunityLineItem where Opportunity.Deal_Type__c = 'Price Agreement' AND Opportunity.Owner.IsActive = TRUE limit 1];      
        //OpportunityLineItem oli = [select Id, Unique__c, PricebookEntryId, PricebookEntry.Pricebook2Id, PricebookEntry.Name, PriceBookEntry.Product2Id, OpportunityId, Opportunity.AccountId from OpportunityLineItem where Opportunity.Deal_Type__c = 'Price Agreement' AND Opportunity.Owner.IsActive = TRUE AND Opportunity.End_Date__c != null limit 1];      
        
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Opportunity'); //CHG0038379
        
        Opportunity opp = zTEST_Shared.noinsertOpportunity(oppRtId, u.Id, a.Id);
        opp.End_Date__c = system.today();
        opp.Deal_Type__c = 'Price Agreement';
        insert opp;
        Pricebook2 pb2 = zTest_Shared.insertPricebook2_2(); 
        
        Product2 pro2 = new Product2(Name='TFE Pick & Mix', isActive=true);
        insert pro2;
        PricebookEntry pbe =zTest_Shared.insertPricebookEntry(pb2.Id, pro2.Id); 
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.Quantity = 1;
        oli.unitPrice = 1;
        oli.PricebookEntryId = pbe.Id;
        oli.OpportunityId = opp.Id;
        insert oli;
        
        system.debug('xxxoli: ' + oli);
        
        AggregateResult[] accountCount = [SELECT count(account__c)total FROM Account_To_Opportunity__c WHERE Opportunity__c = :oli.OpportunityId];
        //system.assert(accountCount.size() > 0);
        
        integer total = integer.valueOf(accountcount[0].get('total'));
        
        ////////////////////////////////////////
        //  test opportunityProductEntry
        ////////////////////////////////////////
        
        // load the page       
        PageReference pageRef = Page.opportunityProductEntry;
        pageRef.getParameters().put('Id',oli.OpportunityId);
        Test.setCurrentPageReference(pageRef);
        
        // load the extension
        oli.Opportunity = [SELECT ID, AccountId FROM Opportunity WHERE Id = :oli.OpportunityId];
        Setting__c oSetting = new Setting__c(Name = 'TF Product Categories');
        insert oSetting;
        Setting_Item__c oSettingItem = new Setting_Item__c(Text_1__c = 'Test', Product_1__c = pro2.Id, Text_2__c = 'Test2', Text_3__c = 'Test3', Setting__c = oSetting.Id);
        insert oSettingItem;
        opportunityProductEntryExtension oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(oli.Opportunity));
        system.debug('xxxoPEE: ' + oPEE);

        // we know that there is at least one line item, so we confirm
        Integer startCount = oPEE.ShoppingCart.size();
        //system.assert(startCount>0);
        
        //test remove from shopping cart
        //oPEE.toUnselect = oli.Unique__c;
        oPEE.toUnselect = '1';
        oPEE.removeFromShoppingCart();
        //system.assertEquals(startCount-1, oPEE.shoppingCart.size());
        
        //test save and reload extension
        oPEE.onSave();
        //system.assert(!ApexPages.hasMessages());
        
        oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(oli.Opportunity));
        //system.assertEquals(startCount-1, oPEE.shoppingCart.size());
        
        // test search again, this time we will find something
        oPEE.searchString = oli.PricebookEntry.Name;
        oPEE.updateAvailableList();
        //system.assert(oPEE.AvailableProducts.size()>0);       

        //test add to Shopping Cart function
        oPEE.toSelect = oPEE.AvailableProducts[0].Id;
        string masterOptyId = oli.OpportunityId;          
        Account_To_Opportunity__c oAccounttOpp = new Account_To_Opportunity__c(Account__c = a.Id, Opportunity__c = masterOptyId);
        insert oAccounttOpp;        
        oPEE.addToShoppingCart();
        //system.assertEquals(startCount - 1 + total, oPEE.shoppingCart.size());
        //system.assertEquals(startCount - 1 + 1, oPEE.shoppingCart.size());
        oPEE.Total = 20.0;
        oPEE.hasCategoryProduct = false;
        oPEE.pageURL = 'Test';
        oPEE.priceBookCheck();
        oPEE.getChosenCurrency();
        oPEE.onCancel();
        oPEE.changePricebook();
        string sPageURL = oPEE.getPageURL();
        opportunityProductEntryExtension.Cart oCart = new opportunityProductEntryExtension.Cart();
        oCart.isToken = false;
        List<SelectOption> categories1;
        oCart.categories = categories1;
        
    }
}