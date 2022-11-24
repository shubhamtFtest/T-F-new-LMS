/**************************************************************************
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2015-01-22
** Testing Clases:	CAS_VitalSourceHSSFeedback
** Testing Triggers: 
***************************************************************************/
@isTest
private class zTest_CASVitalSourceEmailHSS4 {
/**
    static testMethod void UnitTest_HSS4() 
    {
        String locale = 'AMERICAS';
        String prefixTest ='HSS4';
        //CreateSetupVitalsourceData();
	    Account account = Tests_CASVitalSource.setupTestAccount('TEST_1_VitalSource' + locale +  prefixTest);
	    Opportunity opp = Tests_CASVitalSource.setupTestOpportunity('TEST_1_VitalSource' + locale + prefixTest, account.Id);
	    String contactId = Tests_CASVitalSource.createAccountAndContact('TestVitalSource@test.com' + prefixTest, locale);
	    Product2 p1= Tests_CASVitalSource.CreateProduct(prefixTest);
	    String pbe1Id = Tests_CASVitalSource.CreatePricebookEntry(prefixTest,p1 );
	    OpportunityLineItem oppProduct = Tests_CASVitalSource.setupOppLineItemsRecepinet(opp.Id,contactId, pbe1Id);
	    

	  	Set<Id> batchProcessIds = new Set<Id>();
	  	
	  	oppProduct.Adoption_Stage__c = 'Created';
	    oppProduct.VitalSource_Instructor_Email_Date__c = null;
	    oppProduct.VitalSource_Access_Period__c = 'Perpetual';
    	oppProduct.Order_Type__c = 'HSS Vitalsource e-Exam copy';
    	update oppProduct;
    	
    	//**SEND HSS EMAILS
    	
    	CAS_Inspection_Copy__c ic = Tests_CASVitalSource.setupTestInspectionCopy(oppProduct.Id,opp.Id);
		//****HSS VS 4 Request for Feedback "redeemed" - 14 days after redeemed if no feedback
		ic.Adoption_Short__c = null;
		ic.Adoption_Stage__c = null;
		ic.Sent_VS_Instructor__c = system.now().addDays(-30);
		ic.Sent_VS_Unredeemed__c = system.now().addDays(-30);
		ic.Sent_VS_Redeemed__c = system.now().addDays(-16);
		ic.Sent_VS_Redeemed_Feedback__c = null;
		update ic;
		
		Test.StartTest();
		CAS_VitalSourceHSSFeedback vsHSSFeedback = new CAS_VitalSourceHSSFeedback();
		vsHSSFeedback.isTesting = true;
    	vsHSSFeedback.queryLimit = 500;
		vsHSSFeedback.templateId='00X60000004ynajEAA'; 
		batchProcessIds.add(Database.executeBatch(vsHSSFeedback));  
		System.debug('#### HSS VS 4 Request for Feedback "redeemed":batchProcessIds.size()=' + batchProcessIds.size());
		
		Test.StopTest();
		Tests_CASVitalSource.CheckInspectionCopy('HSS VS 4 ', ic.Id);
    }
    **/
}