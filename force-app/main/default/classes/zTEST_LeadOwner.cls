/**************************************************
* Created by Jeff Lup, 2015.03.25
* Test methods for:
*   - LeadOwnerController				97%
**************************************************/

@isTest
private class zTEST_LeadOwner {
	static testMethod void test_LeadOwnerController () {
		User u = zTEST_Shared.insertUser();
		Lead l = zTEST_Shared.insertLead(u.Id);
		
		PageReference pref = Page.LeadReAssignment;
        pref.getParameters().put('Id',l.id);
        Test.setCurrentPage(pref);
		LeadOwnerController ext = new LeadOwnerController(new ApexPages.StandardController(l));

		PageReference pref2 = Page.LeadReAssignment;
        pref2.getParameters().put('Id',l.id);
        pref2.getParameters().put('pg','2');
        Test.setCurrentPage(pref2);
		LeadOwnerController ext2 = new LeadOwnerController(new ApexPages.StandardController(l));
		
		Boolean bTest = ext2.showChangePage;
		ext2.sendNotificationEmail = true;
		bTest = ext2.sendNotificationEmail;
		ext2.comments = 'test';
		String sTest = ext.comments;
		sTest = ext.currentOwnerName;
		ext2.lead.OwnerId = u.Id;
		
		ext2.Save();
	}
}