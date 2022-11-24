@IsTest(SeeAllData=false)
public class Trig_TF_OrderRecTypeOABPCTest {
	
    @isTest
    public static void test_run(){
        
        Id recordtypeIdOpp = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - OA BPC Opportunity');
        Id recordtypeIdOrder = MiscFunctions.getRecordtypeId('order', 'TF OA BPC Order');
        
        TriggerInterfaceHelper.runTrigger('Trig_TF_OrderRecTypeOABPC', 'Order', 1, 'bi', null, null);
        
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;

        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.RecordTypeId = recordtypeIdOpp ; 
        opp.StageName = 'Order Pending';
        opp.Order_Status__c = 'Failed';
        opp.AccountId = a.id;
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        insert opp;
        
        Pricebook2 pricebk = new Pricebook2(Id = Test.getStandardPricebookId());
        Order o = new Order();
        o.OpportunityId = opp.Id;
        o.Name = 'Test Order ';
        o.Status = 'Draft';
        o.EffectiveDate = system.today();
        o.EndDate = system.today() + 4;
        o.AccountId = a.id;
        o.Pricebook2Id =  pricebk.Id ;
        o.Order_Channel__c = 'OA_EBK_CHARGES';
        o.Type = 'SALES';
        insert o;
        
    }
}