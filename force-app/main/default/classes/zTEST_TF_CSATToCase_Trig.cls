/*
Created by Mindtree.com on 22nd August 2017
Created for for WCE-4817 : Integrating SurveyGizmo results into Salesforce
Test class
*/

@isTest
private class zTEST_TF_CSATToCase_Trig {
	
	static testmethod void testCsatToCase(){
		
		Schema.DescribeSObjectResult caseSchema = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> caseRecordTypeInfo = caseSchema.getRecordTypeInfosByName(); 
        Id rtId = caseRecordTypeInfo.get('T&F - CSD').getRecordTypeId();
		Case caseRec = new Case();
		caseRec.RecordTypeId = rtId;
		caseRec.Subject = 'testCase';
		insert caseRec;
		test.startTest();
		TriggerInterfaceHelper.runTrigger('TFCSATToCase_Trig', 'CSAT__c', 1, 'bi,ai,bu', null, null);
		//TriggerInterface_CSAT.Trig trig = new TriggerInterface_CSAT.Trig(); 
		Case tmpcase = new Case();
		tmpcase = [Select Id,CaseNumber from Case where Id =: caseRec.Id];
		CSAT__c csat1 = new CSAT__c(Name = tmpcase.CaseNumber);
		insert csat1;
		CSAT__c csat2 = new CSAT__c(Name = '012345');
		insert csat2;
		csat1.Followup_Email__c = 'test@test.com';
		update csat1;
		
		test.stopTest();
		
	}
	
	
}