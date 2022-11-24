/**************************************************************************
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2015-05-28 CHG0065975
** PLEASE KEEP FOR A YEAR! replaced by zTest_CASVitalSourceEmail3
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2015-01-22
** Testing Clases:	CAS_VitalSourceEmailFeedback
** Testing Triggers: 
***************************************************************************/
@isTest
private class zTest_CASVitalSourceEmailHSS3 {
/**
    static testMethod void UnitTest_HSS3() 
    {	//****HSS VS 3 unredeemed codes final push - 14 days after first instructor email 
        String locale = 'AMERICAS';
        String prefixTest ='HSS3';
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
		
    	ic.Sent_VS_Instructor__c = system.now().addDays(-16);
    	ic.Sent_VS_Unredeemed__c = system.now().addDays(-9);
    	ic.Sent_VS_Redeemed__c = null;
    	ic.Sent_VS_Unredeemed_Final_Push__c = null;
    	update ic;
    	
    	Test.StartTest();
    	CAS_VitalSourceHSSFeedback vsHSSFeedback = new CAS_VitalSourceHSSFeedback();
    	vsHSSFeedback.isTesting = true;
    	vsHSSFeedback.queryLimit = 500;
    	vsHSSFeedback.templateId='00X60000004ynaZEAQ';
		batchProcessIds.add(Database.executeBatch(vsHSSFeedback));
		System.debug('#### HSS VS 3 unredeemed codes final push:batchProcessIds.size()=' + batchProcessIds.size());
		
		Test.StopTest();
		Tests_CASVitalSource.CheckInspectionCopy('HSS VS 3 ', ic.Id);
    }
 **/   
}