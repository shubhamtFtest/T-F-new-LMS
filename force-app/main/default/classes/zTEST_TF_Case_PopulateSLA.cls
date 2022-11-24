/*
Test class created by Mindtree.com
Created for CHG0035954 : SLA changes (T&F Sales & Servcie)

Generic Test class for below components
Apex class : 
1. CaseHandler
2. CaseSLAExtensions
3. milestoneUtils
Apex Trigger:
1. TF_Case_PopulateSLA
 
*/
@isTest(seeAllData = true)
private class  zTEST_TF_Case_PopulateSLA {
    Static Account accRec;
    Static Entitlement entRec;
    Static Case caseRec;
    Static Case caseRec1;
    
    static void setup(){
        //insert Account record
        Schema.DescribeSObjectResult accSchema = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> accountRecordTypeInfo = accSchema.getRecordTypeInfosByName(); 
        Id rtId = accountRecordTypeInfo.get('T&F - Accounts').getRecordTypeId();
        accRec = new Account();
        accRec.RecordTypeId = rtId;
        accRec.Name = 'T&F SLA Account';
        accRec.Phone = '123456789';
        accRec.Type = 'Other';
        accRec.Classification__c = 'Institution';
        accRec.Mailing_Country_List__c = 'United Kingdom';
        accRec.Locale__c = 'Europe';
        accRec.Sales_Region__c = 'Europe';
        accRec.HE_Sales_Territory__c = 'North & Scotland';
        insert accRec;
        
        //insert Entitlement record
        List<SlaProcess> lstEntitlementProcess = [SELECT Id, Name FROM SlaProcess WHERE Name LIKE '%T&F Entitlement%' and IsActive = true LIMIT 1];
        entRec = new Entitlement();
        entRec.Name = 'T&F SLA';
        entRec.AccountId = accRec.Id;
        entRec.SlaProcessId = lstEntitlementProcess[0].Id;
        entRec.StartDate = system.today();
        entRec.EndDate = system.today().addYears(2);
        entRec.Type = 'Phone Support';
        insert entRec;
        
        Id queueId = [Select Id from Group where Type = 'Queue' AND DeveloperName = 'TaylorFrancisInternalCaseQueue'].Id;
        
        //insert case record
        Schema.DescribeSObjectResult caseSchema = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> caseRecordTypeInfo = caseSchema.getRecordTypeInfosByName(); 
        Id casertId = caseRecordTypeInfo.get('T&F - CSD').getRecordTypeId();
        caseRec = new Case();
        caseRec.RecordTypeId = casertId;
        caseRec.Status = 'New';
        caseRec.Subject = 'the following IP range(s)';
        caseRec.Query_Category__c = 'Access';
        caseRec.Query_Type__c = 'Free Access Request';
        caseRec.Product_Platform__c = 'Routledge.com';
        caseRec.OwnerId = queueId;
        insert caseRec;       
        
        caseRec1 = new Case();
        caseRec1.RecordTypeId = casertId;
        caseRec1.Status = 'New';
        caseRec1.Subject = 'the following IP range(s)';
        caseRec1.Query_Category__c = 'Access';
        caseRec1.Query_Type__c = 'Free Access Request';
        insert caseRec1;
        
        List<Id> caseIds = new List<Id>();
        caseIds.add(caseRec.Id);
        caseIds.add(caseRec1.Id);
        CaseHandler.updateTargetDateOnCase(caseIds);
    }
    static testmethod void testCaseSLAExtensions()
    {
        setup();
        /*system.debug('---CaseOwner------'+caseRec.OwnerId);
        List<CaseMilestone> caseMilestones = new List<CaseMilestone>();
        caseMilestones = [select Id, TargetDate, MilestoneTypeId, MilestoneType.Name from CaseMilestone where caseId = :caseRec.Id AND MilestoneType.Name = '	T&F Case Resolution'];
        system.debug('---milestoneRec------'+caseMilestones);*/   
        caseRec.Target_Date__c = system.today().addDays(-1);
        update caseRec;
        test.startTest();
        PageReference pageRef = Page.T_F_Case_SLA;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', String.valueOf(caseRec.Id));
        ApexPages.StandardController stdCase = new ApexPages.StandardController(caseRec);
        CaseSLAExtensions caseExt  = new CaseSLAExtensions(stdCase);
        caseExt.updateTargetDateOnCase();
        test.stopTest();
    }
    
    static testmethod void test_resetStartDateOnMilestone()
    {
        setup();
        test.startTest();
        caseRec.Status = 'Re - Opened';
        update caseRec;
        Set<Id> caseIds = new Set<Id>();
        caseIds.add(caseRec.Id);
        CaseHandler.resetStartDateOnMilestone(caseIds);
        test.stopTest();
    }
    static testmethod void test_updateTargetDateOnCase()
    {
        setup();
        test.startTest();
        caseRec.Status = 'Re - Opened';
        update caseRec;
        List<Id> caseIds = new List<Id>();
        caseIds.add(caseRec.Id);
        CaseHandler.updateTargetDateOnCase(caseIds);
        test.stopTest();
    }
    static testMethod void test_PercentageRaiser() {
        CaseHandler.PercentageRaiser();
    }
    
    static testmethod void testCaseEntitlementTrigger()
    {
        setup();
        test.startTest();
        caseRec.Status = 'Re - Opened';
        update caseRec;
        List<Id> caseIds = new List<Id>();
        caseIds.add(caseRec.Id);
        CaseHandler.updateTargetDateOnCase(caseIds);
        test.stopTest();
    }
    static testmethod void testCloseCase()
    {
        setup();
        test.startTest();
        caseRec.Status = 'Closed';
        update caseRec;
        List<Id> caseIds = new List<Id>();
        caseIds.add(caseRec.Id);
        CaseHandler.updateTargetDateOnCase(caseIds);
        test.stopTest();
    }
    
    static testmethod void testCaseOwnerChange()
    {
    		/*
    		setup();
    		List<CaseMilestone> caseMilestones = new List<CaseMilestone>();
        caseMilestones = [select Id, StartDate,TargetDate, MilestoneTypeId, MilestoneType.Name from CaseMilestone where caseId = :caseRec.Id ];
        caseMilestones[0].StartDate = system.now()+2;
        update caseMilestones[0];
        test.StartTest();
        Id queueId = [Select Id from Group where Type = 'Queue' AND DeveloperName = 'TaylorFrancisInternalCaseQueue'].Id; //CHG0038379
        caseRec.OwnerId = queueId;
        update caseRec;
        test.stopTest();
        */
    }
    
    
}