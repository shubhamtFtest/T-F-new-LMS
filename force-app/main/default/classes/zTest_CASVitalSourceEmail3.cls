/**************************************************************************
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2015-05-29 CHG0065975
** Testing Clases:	CAS_VitalSourceEmailFeedback, CAS_VitalSourceEmailFeedbackSchedule
***************************************************************************/
@isTest
private class zTest_CASVitalSourceEmail3 {

    static testMethod void UnitTest_Email3() 
    {	//****Eamil VS 3 unredeemed codes final push - 14 days after first instructor email 
        String locale = 'AMERICAS';
        String prefixTest ='Email3';
        CAS_VitalSource.TestCreateSettingsEmailTemplates();
	    Account account = Tests_CASVitalSource.setupTestAccount('TEST_1_VitalSource' + locale +  prefixTest);
	    Opportunity opp = Tests_CASVitalSource.setupTestOpportunity('TEST_1_VitalSource' + locale + prefixTest, account.Id);
	    String contactId = Tests_CASVitalSource.createAccountAndContact('TestVitalSource@test.com' + prefixTest, locale);
	    Product2 p1= Tests_CASVitalSource.CreateProduct(prefixTest);
	    String pbe1Id = Tests_CASVitalSource.CreatePricebookEntry(prefixTest,p1 );
	    OpportunityLineItem oppProduct = Tests_CASVitalSource.setupOppLineItemsRecepinet(opp.Id,contactId, pbe1Id);
		

	  	Set<Id> batchProcessIds = new Set<Id>();
	  	
	  	oppProduct.Adoption_Stage__c = 'Created';
	    oppProduct.VitalSource_Instructor_Email_Date__c = null;
	    oppProduct.VitalSource_Access_Period__c = 'Perpetual Access';
    	oppProduct.Order_Type__c = 'HSS Vitalsource e-Exam copy';
    	update oppProduct;
    	
    	//**SEND HSS EMAILS
    	
    	CAS_Inspection_Copy__c ic = Tests_CASVitalSource.setupTestInspectionCopy(oppProduct.Id,opp.Id);
		
    	ic.Sent_VS_Instructor__c = system.now().addDays(-16);
    	ic.Sent_VS_Unredeemed__c = system.now().addDays(-9);
    	ic.Sent_VS_Redeemed__c = null;
    	ic.Sent_VS_Unredeemed_Final_Push__c = null;
    	ic.Order_Type__c = 'HSS Vitalsource e-Exam copy';
    	update ic; 
    	
    	Test.StartTest();
    	CAS_VitalSourceEmailFeedback vsFeedback = new CAS_VitalSourceEmailFeedback();
    	vsFeedback.isTesting = true;
    	vsFeedback.queryLimit = 500;
    	vsFeedback.emailProcess ='Email3';
		batchProcessIds.add(Database.executeBatch(vsFeedback));
		System.debug('#### Email VS 3 unredeemed codes final push:batchProcessIds.size()=' + batchProcessIds.size());
		
		Test.StopTest();
		Tests_CASVitalSource.CheckInspectionCopy('Email VS 3 ', ic.Id);
    }
}