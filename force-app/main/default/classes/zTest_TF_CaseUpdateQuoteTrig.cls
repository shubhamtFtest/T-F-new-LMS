@isTest
public class zTest_TF_CaseUpdateQuoteTrig{

    
    public static testMethod void runTest1(){
    
        String caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('T&F - CSD APC').getRecordTypeId();
        TriggerInterfaceHelper.runTrigger('TF_CaseUpdateQuoteTrig', 'Case', 1, 'ai', caseRecordTypeId, null);
        
        test.startTest();           
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c( Article_Title__c = 'Test', PromoCode__c = 'MAK-2018-USJFISD',SBQQ__Status__c = 'Draft',
                                                        SBQQ__ExpirationDate__c = date.today()+20);
        
        insert quoteObject;
        
        Case cse = new Case(RecordTypeId = caseRecordTypeId, Description = 'Testing description ' + quoteObject.Id, Subject = 'Test', Origin = 'APC verification');  
        insert cse;
        
        System.assertEquals([SELECT Id, Case__c FROM SBQQ__Quote__c LIMIT 1].Case__c, cse.Id);
        test.stopTest();
    }
}