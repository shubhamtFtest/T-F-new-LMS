/**************************************************************************
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2015-05-29 CHG0065975
** Testing Clases:	CAS_VitalSourceEmailFeedback, CAS_VitalSourceEmailFeedbackSchedule
***************************************************************************/
@isTest
private class zTest_CASVitalSourceEmail4 
{
	static testMethod void UnitTest_Email4() 
    {
        String locale = 'AMERICAS';
        String prefixTest ='Email4';
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
    	oppProduct.Order_Type__c = 'CRC Vitalsource e-Exam copy';
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
		ic.Order_Type__c = 'CRC Vitalsource e-Exam copy';
		update ic;
		
		Test.StartTest();
		CAS_VitalSourceEmailFeedback vsFeedback = new CAS_VitalSourceEmailFeedback();
		vsFeedback.isTesting = true;
    	vsFeedback.queryLimit = 500;
		vsFeedback.emailProcess ='Email4'; 
		batchProcessIds.add(Database.executeBatch(vsFeedback));  
		System.debug('####VS 4 Request for Feedback "redeemed":batchProcessIds.size()=' + batchProcessIds.size());
		
		Test.StopTest();
		Tests_CASVitalSource.CheckInspectionCopy('Email VS 4 ', ic.Id);
    }
}