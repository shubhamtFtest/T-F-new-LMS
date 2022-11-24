/**************************************************
* Tests:
*   ICR_InlineEditController.cls           91%
 * Modified by Hailey Niemand - 2017.01.26 - CHG0031794
**************************************************/
@isTest
private class zTEST_ICRInlineEditController {
    static testMethod void test_ICRInlineEditController() {
        User u = zTEST_Shared.insertUser();
        //Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F One-Off Opportunity');
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - One-Off Opportunity'); //CHG0031794
        Opportunity opp = zTEST_Shared.noinsertOpportunity(oppRecordtypeId, u.Id);
        opp.Tax_Code__c = 'N/A';
        insert opp;
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        Contact c2 = zTEST_Shared.insertContact(u.Id, a.Id);
        OpportunityContactRole ocr = zTEST_Shared.insertOpportunityContactRole(opp.Id, c.Id);
        
        PageReference pref = Page.ICR_InlineEdit;
        pref.getParameters().put('id',opp.id);
        Test.setCurrentPage(pref);
        
        ApexPages.StandardController con = new ApexPages.StandardController(opp);
        ICR_InlineEditController ext = new ICR_InlineEditController(con);

        ext.init();
        ext.cancel();
        ext.editAll();
        ext.addNew();
        
        Integer n = ext.selectedRowNumber;

        ext.selectedRowNumber = 1;
        ICR_InlineEditController.ICRWrapper icrw = ext.getCurrentICRw();
        icrw.icr.Primary_Contact__c = true;

        ext.selectedRowNumber = 2;
        icrw = ext.getCurrentICRw();
        icrw.icr.Primary_Contact__c = true;
        ext.unselectOtherPrimary();
        Pagereference pr = ext.contactSelected();
        
        icrw.icr.Contact__c = c.Id;
        icrw.icr.Opportunity__c = opp.Id;
        icrw.icr.Contact_Role_s__c = 'Delivery';
        icrw.icr.Primary_Contact__c = true;
        boolean bTest = icrw.isDelivery;
        ext.roleChanged();

        icrw.icr.Contact__c = c.Id;
        pr = ext.contactSelected();
        
        icrw.icr.Contact__c = c2.Id;
        pr = ext.contactSelected();
        
        ext.saveAll();
        ext.removeICR();
        ext.selectedRowNumber = 1;
        ext.removeICR();
        ext.saveAll();
        ext.selectedRowNumber = 1;
        ext.removeICR();
    }
}