/*
Created by Mindtree.com on 21st July 2017
for WCE-5089 : Auto Roll Over Budget End Date on Account
Test class for TF_AutoRollBudgetEndDate_Batch & TF_AutoRollBudgetEndDate_Schedule class
*/
@isTest
private class zTEST_TF_AutoRollBudgetEndDate {
	
	static testmethod void testAutoRollBudgetEndDate(){
		//insert Account record
        Schema.DescribeSObjectResult accSchema = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> accountRecordTypeInfo = accSchema.getRecordTypeInfosByName(); 
        Id rtId = accountRecordTypeInfo.get('T&F - Accounts').getRecordTypeId();
        Account accRec = new Account();
        accRec.RecordTypeId = rtId;
        accRec.Name = 'T&F SLA Account';
        accRec.Phone = '123456789';
        accRec.Type = 'Other';
        accRec.Classification__c = 'Institution';
        accRec.Mailing_Country_List__c = 'United Kingdom';
        accRec.Locale__c = 'Europe';
        accRec.Sales_Region__c = 'Europe';
		accRec.Budget_End_Date__c = system.today();
        accRec.HE_Sales_Territory__c = 'North & Scotland';
        insert accRec;
		test.startTest();
		TF_AutoRollBudgetEndDate_Schedule scheduleRec = new TF_AutoRollBudgetEndDate_Schedule();
        String sch = '0 0 1 * * ?';
        system.schedule('AutoRollBudgetEndDate', sch, scheduleRec);
		test.stopTest();
		
	}
}