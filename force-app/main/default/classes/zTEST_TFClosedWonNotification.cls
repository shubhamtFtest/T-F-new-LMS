/**
* Tests: TFClosedWonNotificationController.cls	100%
**/

@isTest
private class zTEST_TFClosedWonNotification {

    static testMethod void test_TFClosedWonNotification() {
    	User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
    	Id oppRecordtypeId = [SELECT Id FROM Recordtype WHERE Sobjecttype = 'Opportunity' LIMIT 1].Id;
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);
		PricebookEntry pbe = zTEST_Shared.insertPricebookEntry();
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
		
		TFClosedWonNotificationController con = new TFClosedWonNotificationController();
		con.OpportunityObj = opp;
		con.getOpp();

		con = new TFClosedWonNotificationController();
		con.OpportunityObj = opp;
		con.getOlis();
		con.getFirstOli();

		con = new TFClosedWonNotificationController();
		con.OpportunityObj = opp;
		con.getPrimaryContact();

		OpportunityContactRole ocr = zTEST_Shared.insertOpportunityContactRole(opp.Id, c.Id, 'Test');
		ocr.IsPrimary = true;
		update ocr;

		con = new TFClosedWonNotificationController();
		con.OpportunityObj = opp;
		con.getPrimaryContact();

		con = new TFClosedWonNotificationController();
		con.OpportunityObj = opp;
		con.getOppURL();
    }
}