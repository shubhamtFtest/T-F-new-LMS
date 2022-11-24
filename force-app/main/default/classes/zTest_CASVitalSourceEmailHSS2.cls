/*************************************************************************
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2015-05-28 CHG0065975
** PLEASE KEEP FOR A YEAR! replaced by zTest_CASVitalSourceEmail2
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2015-01-22
** Testing Clases:	CAS_VitalSourceHSSFeedback, CAS_VitalSourceHSSFeedbackSchedule
** Testing Triggers: 
***************************************************************************/
@isTest
private class zTest_CASVitalSourceEmailHSS2 {

/**
    static testMethod void UnitTest_VitalSourceHSSFeedback() 
    {
        CAS_VitalSourceHSSFeedback.SendErrorEmail('TEST.TEST@informaUSA.com','(UnitTest)Error - HSS Inspection Copy Emails','test');
        
    	//Test.StartTest();
    	//Covers HSS schedule job
        CAS_VitalSourceHSSFeedbackSchedule m = new CAS_VitalSourceHSSFeedbackSchedule();
        String sch = '20 30 8 10 2 ?';
        System.schedule('TEST_CAS_VitalSourceHSSFeedbackSchedule',sch, m);
        //Test.StopTest();
    }
    
      static testMethod void UnitTest_HSS2() 
    {
	    String locale = 'AMERICAS';
        String prefixTest ='HSS2';
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
    	ic.Sent_VS_Bookshelf_Code__c = 'test-VSBookCode-test';
    	ic.Sent_VS_Instructor__c = system.now().addDays(-9);
    	ic.Sent_VS_Redeemed__c = null;
    	ic.Sent_VS_Unredeemed__c = null;
    	update ic;
    	
    	Test.StartTest();
    	CAS_VitalSourceHSSFeedback vsHSSFeedback = new CAS_VitalSourceHSSFeedback();
    	vsHSSFeedback.isTesting = true;
    	vsHSSFeedback.queryLimit = 10;
    	
    	//****HSS VS 2 Unredeemed codes - 7 days after first instructor email
    	
    	vsHSSFeedback.templateId='00X60000004ynaPEAQ'; //       
		batchProcessIds.add(Database.executeBatch(vsHSSFeedback));
		System.debug('#### HSS VS 2 Unredeemed codes:batchProcessIds.size()=' + batchProcessIds.size());
		
		Test.StopTest();
		Tests_CASVitalSource.CheckInspectionCopy('HSS VS 2 ', ic.Id);
	  	
    	
    }
    
    **/
}