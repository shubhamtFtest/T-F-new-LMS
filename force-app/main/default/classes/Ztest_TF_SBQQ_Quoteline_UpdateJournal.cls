@isTest
public class Ztest_TF_SBQQ_Quoteline_UpdateJournal{
    
    public static testMethod void runTest1(){
        TriggerInterface_SBQQ_QuoteLine triggerInterface = new TriggerInterface_SBQQ_QuoteLine();
        TriggerInterface_SBQQ_QuoteLine.trig  triggerObj = new TriggerInterface_SBQQ_QuoteLine.trig();
        triggerObj.isAfter = true;
        triggerObj.isInsert = true;
        
        List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
        SBQQ__Quote__c quoteTest = new SBQQ__Quote__c();
        quoteTest.SBQQ__ExpirationDate__c = System.today();
        quoteList.add(quoteTest);
        Insert quoteList;
        
        Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
        Product2 prodObject1 = new Product2(Name = 'Test Product1', 
                                           RecordTypeId = TFProductsRecordTypeId,
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           ProductCode = 'XYZ',
                                           Readership_Level__c = 'Test',
                                           IsActive = true,
                                           Hub_Id__c='143f5db0-b038-48f5-a0da-50bb4f3485fa',
                                           Family = 'Journal Master Product');  
        insert prodObject1;
        
        List<SBQQ__QuoteLine__c> quoteLineList = new List<SBQQ__QuoteLine__c>(); 
        SBQQ__QuoteLine__c quoteLineObj = new SBQQ__QuoteLine__c();
        quoteLineObj.SBQQ__Quote__c = quoteList[0].Id;
        quoteLineObj.Parent_Product__c = prodObject1.Id;        
        quoteLineList.add(quoteLineObj);
        
        triggerObj.newList = quoteLineList;
        
        TF_SBQQ_QuoteLine_UpdateJournalAI_Trig  controller = new TF_SBQQ_QuoteLine_UpdateJournalAI_Trig ();
        controller.run(triggerObj);
    }
    
}