@isTest
public class zTest_Case_AutoResponseRules_trig {
    
    static testmethod void test_Case_AutoResponseRules_trig(){
        
        String caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('T&F - CSD eBooks').getRecordTypeId();
        TriggerInterfaceHelper.runTrigger('Case_AutoResponseRules_trig', 'Case', 1, 'ai', caseRecordTypeId, null);
        
        User testUser = zTEST_Shared.noinsertUser();
        testUser.FirstName = 'Help Center - Student/Researcher';
        testUser.LastName = 'Site Guest User';
        insert testUser;
        
        System.runAs(testUser) {
            test.startTest();           
            //Create New Case
            Case cse = new Case(RecordTypeId = caseRecordTypeId, SuppliedEmail = 'tom.reed@tandf.co.uk', Subject = 'Test', Origin = 'UBX Community Help Portal');  
            insert cse;
            test.stopTest();
        }
        
    }
    
}