/**************************************************
* Created by Jeff Lup, 2011.10.10
* Test methods for...
*   - LeadReAssignmentController.cls	100%
**************************************************/

@isTest
private class zTEST_LeadReAssignment {

    static testMethod void testLeadReAssignment() {
    	User u = zTEST_Shared.insertUser();
    	Lead l = zTEST_Shared.noinsertLead(u.Id);
    	l.Title = 'test';
    	l.Phone = '123-456-7890';
    	l.Email = 'test@test.com';
    	insert l;
    	
    	//********** Assign Lead to another owner **********
    	
		//setup a reference to the page the controller is expecting with the parameters
        PageReference pref = Page.LeadReAssignment;
        pref.getParameters().put('leadId',l.id);
        pref.getParameters().put('ownerId',u.id);
        Test.setCurrentPage(pref);
	
        //Construct the controller class 
        LeadReAssignmentController ext = new LeadReAssignmentController();
        
        //Pass in data, call methods
        ext.lead = l;
        ext.owner = u;
        ext.init();
        
    	//Call the methods on the ext controller with null values
    	Boolean bTest;
    	bTest = ext.getDontRenderLead();
    	bTest = ext.getRenderLead_Assign();
    	bTest = ext.getRenderLead_Update();
    	String sTest = ext.getLeadUrl();

		//********** Update Lead with Status **********

		//setup a reference to the page the controller is expecting with the parameters
        PageReference pref2 = Page.LeadReAssignment;
        pref2.getParameters().put('leadId',l.id);
        pref2.getParameters().put('status','test');
        Test.setCurrentPage(pref2);
        
        //Construct the controller class 
        LeadReAssignmentController ext2 = new LeadReAssignmentController();
        
        //Pass in data, call methods
        ext2.lead = l;
        ext2.status = 'test';
        ext2.init();
    }
}