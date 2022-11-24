/**************************************************
* Tests:
*   IHC_OCF_Controller.cls           93%
 * Modified by Hailey Niemand - 2017.01.26 - CHG0031794
* Modified by Mindtree - 2017-09-15 - CHG0037592
* Modified by Tom Reed - 2019-05-09
**************************************************/
@isTest
private class zTEST_IHC_OCF_Controller {
    static testMethod void test_IHC_OCF_Controller() {
        User u = zTEST_Shared.insertUser();
        //Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F One-Off Opportunity');
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - One-Off Opportunity'); //CHG0031794
        Account a = zTEST_Shared.insertAccount(u.Id);
        Opportunity opp = zTEST_Shared.noinsertOpportunity(oppRecordtypeId, u.Id, a.Id);
        opp.Tax_Code__c = 'N/A';

        //opp.Additional_Permitted_Use__c = 'test';
        //opp.Autorenewal_Clause_Removed__c = true;
        //opp.Non_Standard_Terms__c = 'test';
        //opp.Addendum__c = 'test';
        //opp.Governing_Law__c = 'test';
        insert opp;
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(opp.Id);
        oli.IHC_Sales_Type__c = 'Commercial Reprints';
        insert oli;
        OpportunityLineItem oli2 = zTEST_Shared.noinsertOpportunityLineItem(opp.Id);
        oli2.IHC_Sales_Type__c = 'Commercial ePrints';
        insert oli2;
        OpportunityLineItem oli3 = zTEST_Shared.noinsertOpportunityLineItem(opp.Id);
        oli3.IHC_Sales_Type__c = 'Commercial Permissions';
        insert oli3;
        OpportunityLineItem oli4 = zTEST_Shared.noinsertOpportunityLineItem(opp.Id);
        oli4.IHC_Sales_Type__c = 'Sponsored Focus';
        insert oli4;
        OpportunityLineItem oli5 = zTEST_Shared.noinsertOpportunityLineItem(opp.Id);
        oli5.IHC_Sales_Type__c = 'Advertising Sales';
        insert oli5;
        OpportunityLineItem oli6 = zTEST_Shared.noinsertOpportunityLineItem(opp.Id);
        oli6.IHC_Sales_Type__c = 'Commercial Supplements';
        insert oli6;
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        c.MailingCity = 'test';
        c.MailingState = 'test';
        c.MailingPostalCode = 'test';
        update c;
        OpportunityContactRole ocr = zTEST_Shared.insertOpportunityContactRole(opp.Id, c.Id, 'Billing');
        OpportunityContactRole ocr2 = zTEST_Shared.insertOpportunityContactRole(opp.Id, c.Id, 'Delivery');
        
        //insert Billing Record for T&F (CHG0037592)
        Billing__c billRec = new Billing__c();
        billrec.Issue__c = 'test Issue';
        billRec.Bill_Date__c = system.today();
        billRec.Opportunity__c = opp.Id;
        billRec.Amount__c = 100.00;
        insert billRec;
        
        PageReference pref = Page.IHC_OCF;
        pref.getParameters().put('id',opp.id);
        Test.setCurrentPage(pref);
        
        ApexPages.StandardController con = new ApexPages.StandardController(opp);
        IHC_OCF_Controller ext = new IHC_OCF_Controller(con);

        //IHC_OCF_Controller.T_F_One_Off_Settings__c tfs = ext.tfSetting;
        ext.hasOppAddress = false;
        
        ext.populateOppAddress();
        string sTest = ext.companyAddress;
        sTest = ext.companyPhone;
        sTest = ext.ocfDate;
        sTest = ext.serviceDates;
        sTest = ext.billingContact;
        sTest = ext.billingEmail;
        sTest = ext.billingBusinessName;
        sTest = ext.billingAddress;
        
        sTest = ext.deliveryContact;
        sTest = ext.deliveryEmail;
        sTest = ext.deliveryBusinessName;
        sTest = ext.deliveryAddress;
        
        sTest = ext.taxCodes;
        sTest = ext.taxWarning;
        sTest = ext.otherInfo;
        sTest = ext.accessRun;
        //sTest = ext.deliveryMethod;
        sTest = ext.specialTerms;
        sTest = ext.showIfJapan;
        sTest = ext.productDetails;
        
        ext.testProducts();
        
    }
}