@isTest
public class TF_SBQQ_Quote_PopulateGUID_Trig_Test{
    
    private static testMethod void runTest(){
        
        TriggerInterface_SBQQ_Quote triggerInterface = new TriggerInterface_SBQQ_Quote();
        TriggerInterface_SBQQ_Quote.trig  triggerObj = new TriggerInterface_SBQQ_Quote.trig();
        triggerObj.isBefore = true;
        triggerObj.isInsert = true;
        
        List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
        SBQQ__Quote__c quoteTest = new SBQQ__Quote__c();
        quoteTest.SBQQ__ExpirationDate__c = System.today();
        quoteList.add(quoteTest);
        
        triggerObj.newList = quoteList;
        
        TF_SBQQ_Quote_PopulateGUID_Trig controller = new TF_SBQQ_Quote_PopulateGUID_Trig();
        controller.run(triggerObj);
    } 
    
}