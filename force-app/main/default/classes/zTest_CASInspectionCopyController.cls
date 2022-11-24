/**************************************************************************
** Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2013-03-06
** Modified by Jeff Lup - 2017.10.09 - CHG0038379
***************************************************************************/
@isTest
private class zTest_CASInspectionCopyController {

    static testMethod void testController() 
    {
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
        Id productRtId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products'); //CHG0038379
        
       	User u = zTEST_Shared.insertUser();
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry(productRtId);
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId,u.Id);
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id, null);//'Completed – Adopted'
        //OpportunityLineItem oli1 = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id, 'Created');
        
        CAS_Inspection_Copy__c ic = zTEST_Shared.insertCASInspectionCopy(opp.Id, oli.Id);
        ic.Contact_Rep__c ='No';
        update ic;
        
        PageReference pref = Page.ICFeedback;
        pref.getParameters().put('id',ic.id);
        Test.setCurrentPage(pref);
        CASInspectionCopyController con = new CASInspectionCopyController();
        con.NeedHelp = true;
        con.renderRequiredTextbook=null;
        con.renderRequiredText();
        pref = con.save();
       
       
		ic.Contact_Rep__c ='No';
		ic.Adoption_Stage__c ='I\'m still reviewing this book';
        ic.Decision_Date__c = date.today().addDays(20);
        ic.Adoption_Level__c = 'Additional Reading';
        Ic.Number_of_Students__c = 100;//creates  task
		update ic;
		
		pref = Page.ICFeedback;
        pref.getParameters().put('id',ic.id);
        Test.setCurrentPage(pref);
        con = new CASInspectionCopyController();
        con.NeedHelp = false;
        con.getMappedAdoptionStage('I\'m still reviewing this book');
        con.renderRequiredText();
        con.renderRequiredTextbook=true;
        pref = con.save();
        
       	ic.Contact_Rep__c = 'Yes';
		ic.Adoption_Stage__c ='I would like to return this book';
        ic.Decision_Date__c = date.today();
        ic.Adoption_Level__c = null;
        Ic.Number_of_Students__c = null;//creates  task
		update ic;
		
        pref = Page.ICFeedback;
        pref.getParameters().put('id',ic.id);
        Test.setCurrentPage(pref);
        con = new CASInspectionCopyController();
        con.getMappedAdoptionStage('I will be adopting this book for my course');
        con.renderRequiredText();
        pref = con.save();
        
        //test rep verified redirect
        oli.Rep_Verified__c = true;
        update(oli);
        pref = Page.ICFeedback;
        pref.getParameters().put('id',ic.id);
        Test.setCurrentPage(pref);
        con = new CASInspectionCopyController();
        
        con.getMappedAdoptionStage('I would like to return this book');
        con.renderRequiredText();
        pref = con.save();
        oli.Rep_Verified__c = false;
        update(oli);
	
		 //bad URL
       pref = Page.ICFeedback;
       pref.getParameters().put('id','001');
       Test.setCurrentPage(pref);
       pref = con.save();
		 
		 
       pref = Page.ICFeedback;
       pref.getParameters().put('id',ic.id);
       Test.setCurrentPage(pref);
       con = new CASInspectionCopyController();
       con.renderRequiredTextbook = false;
       con.renderRequiredTextbook = true;
       con.NeedHelp = true;
       con.NeedHelp = false;
       con.showDecisionDate = false;
       con.showDecisionDate = true;
       con.getMappedAdoptionStage('I will be adopting this book for my course');
       con.getMappedAdoptionStage('I never received this book');
       con.getMappedAdoptionStage('I\'m still reviewing this book');
       con.getMappedAdoptionStage('I will not adopt this book for my course');
       con.getMappedAdoptionStage('I would like to recommend this book as a library purchase');
       con.getMappedAdoptionStage('This book is under committee review');
       con.getMappedAdoptionStage('I would like to return this book');
       con.getMappedAdoptionStage('333');
       con.getMappedAdoptionLevel('Highly Recommended');
       con.getMappedAdoptionLevel('Required Textbook');
       con.getMappedAdoptionLevel('Additional Reading');
       con.getMappedAdoptionLevel('Additional Reading!');
       con.isValidId();
       pref = con.save();
       
       //Test ICFeedback_VerifiedFeedback
       pref = Page.ICFeedback_VerifiedFeedback;
       pref.getParameters().put('id',ic.id);
       Test.setCurrentPage(pref);
       CASFeedbackVerifiedController vf = new CASFeedbackVerifiedController();
       pref = vf.isValidId();
       
       pref = Page.ICFeedback_VerifiedFeedback;
       Test.setCurrentPage(pref);
       vf = new CASFeedbackVerifiedController();
       pref = vf.isValidId();
		
    }
}