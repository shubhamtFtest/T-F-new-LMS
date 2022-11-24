@isTest
public class zTEST_CASInspectionCopyDisplayController {
	
	 static testMethod void testCAS_2() {
        
		Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
        Id productRtId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products'); //CHG0038379
         
        User u = zTEST_Shared.insertUser();
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry(productRtId);
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId,u.Id);
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id, 'Completed – Adopted');

        // CASInspectionCopyDisplayController.cls   100%
        testInspectionCopyDisplayController(opp, pbe);
    }
	
 private static void testInspectionCopyDisplayController(Opportunity opp, PricebookEntry pbe) {
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id, 'Created');
        CAS_Inspection_Copy__c ic = zTEST_Shared.insertCASInspectionCopy(opp.Id, oli.Id);
        PageReference pref = Page.CAS_Inspection_Copy_Display;
        pref.getParameters().put('id',ic.id);
        Test.setCurrentPage(pref);
        CASInspectionCopyDisplayController ext = new CASInspectionCopyDisplayController(new ApexPages.StandardController(ic));
        String sTest = ext.oliName;       
    } 
}