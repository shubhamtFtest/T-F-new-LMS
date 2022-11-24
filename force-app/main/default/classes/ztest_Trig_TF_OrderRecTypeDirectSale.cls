@isTest
public class ztest_Trig_TF_OrderRecTypeDirectSale {
    
    @isTest
    public static void orderRecTypeDirectSale(){
        TriggerInterfaceHelper.runTrigger('Trig_TF_OrderRecTypeDirectSale', 'Order', 1, 'bi', null, null);

        Account a = new Account();
        a.Name = 'Test Account';
        insert a;

        Id recordtypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F Automated eBooks Opportunity').getRecordTypeId();
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
        o.Order_Channel__c = 'EBK AGENT SALES';
        o.Type = 'SALES';
        insert o;
    }
}