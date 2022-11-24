/**************************************************
* Tests:
*   IHC_OpportunityProductsController.cls     82%
* Modified by Hailey Niemand - 2017.01.26 - CHG0031794
**************************************************/
@isTest
private class zTEST_IHC_OpportunityProductsController {
    static testmethod void test_IHC_OpportunityProductsController() {
        User u = zTEST_Shared.insertUser();
        //Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F One-Off Opportunity');
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - One-Off Opportunity'); //CHG0031794
        Account a = zTEST_Shared.insertAccount(u.Id);
        Opportunity opp = zTEST_Shared.noinsertOpportunity(oppRecordtypeId, u.Id, a.Id);
        opp.Tax_Code__c = 'N/A';
        opp.LeadSource = 'Direct';
        opp.Lead_Source_Detail__c = 'Webinar';
        insert opp;

        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(opp.Id);
        oli.IHC_Sales_Type__c = 'Sponsored Focus';
        insert oli;
        OpportunityLineItem oli2 = zTEST_Shared.noinsertOpportunityLineItem(opp.Id);
        oli2.IHC_Sales_Type__c = 'Advertising Sales';
        oli2.Size__c = '1/2 Page';
        oli2.Split_Billing__c = true;
        insert oli2;
        OpportunityLineItem oli3 = zTEST_Shared.noinsertOpportunityLineItem(opp.Id);
        oli3.IHC_Sales_Type__c = 'Commercial Reprints';
        insert oli3;

        opp = [SELECT Id, CloseDate, Pricebook2Id, CurrencyIsoCode FROM Opportunity WHERE Id = :opp.Id];
        
        PageReference pref = Page.IHC_OpportunityProducts;
        pref.getParameters().put('id',opp.id);
        Test.setCurrentPage(pref);
        
        ApexPages.StandardController con = new ApexPages.StandardController(opp);
        IHC_OpportunityProductsController ext = new IHC_OpportunityProductsController(con);
        
        ext.isProductFamilyRequired = true;
        ext.addEditProducts();
        Boolean bTest = ext.denyClose;
        ext.cancel();
        ext.save();
        ext.updateAvailableList();
        
        ext.selectedPbeId = [SELECT PricebookEntryId FROM OpportunityLineItem WHERE Id = :oli.Id].PricebookEntryId;
        ext.addToSelectedProducts();
        
        ext.selectedTempOliId = 1;
        ext.removeFromSelectedProducts();
        
        ext.testhelper();
    }
}