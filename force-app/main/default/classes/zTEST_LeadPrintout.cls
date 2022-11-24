/******************************************************************
* Created by Jeff Lup, 2012.05.09
* Test results as of 2012.05.09...
*   LeadPrintoutController.cls          100%
*   Updated By Ashish Purwar on 10/05/2018 to accomodate changes made in lead printout controller
*******************************************************************/

@isTest
private class zTEST_LeadPrintout {
    static testMethod void testLeadPrintout() { 
        User u = zTEST_Shared.insertUser();
        Lead l1 = zTEST_Shared.insertLead(u.Id);
        Lead l2 = zTEST_Shared.insertLead(u.Id);
        //PageReference pref = Page.Lead_Printout;
        //pref.getParameters().put('ids',l.id);
        //Test.setCurrentPage(pref);
        List<lead> LeadList = new List<lead>();
        LeadList.add(l1);
        LeadList.add(l2); 
        ApexPages.StandardSetController SelectedLead=new ApexPages.StandardSetController(LeadList);
        SelectedLead.setSelected(LeadList);
        LeadPrintoutController ext = new LeadPrintoutController(SelectedLead);
    }
}