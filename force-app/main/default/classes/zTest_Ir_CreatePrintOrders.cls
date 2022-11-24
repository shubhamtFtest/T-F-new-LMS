@isTest
public class zTest_Ir_CreatePrintOrders {
    @isTest static void CreatePrintOrder()
    {
        User u = zTEST_Shared.insertUser();
        Account acc=zTEST_Shared.insertAccount(u.id);
        Id pricebookId = Test.getStandardPricebookId();
        Product2 p = zTEST_Shared.noinsertProduct2();
        insert p;
        Pricebook2 pb = new pricebook2(name='test');
        insert pb;
        PricebookEntry pbeStandard = new PricebookEntry(Pricebook2Id=pricebookId, Product2Id=p.id, UnitPrice=1, IsActive=true);
        insert pbeStandard;
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pb.Id, Product2Id=p.id, UnitPrice=1, IsActive=true);
        insert pbe;
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint'); 
        List<Opportunity> opplist=new List<Opportunity>();
        Opportunity opp = zTEST_Shared.noinsertOpportunity(oppRecordtypeId, u.Id);
        opp.StageName = 'Closed Won';
        opp.AccountId=acc.id;
        opp.Pricebook2Id=pb.id;
        opplist.add(opp);
        insert opplist;
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(opp.Id);
        oli.UnitPrice = 100;
        oli.Quantity = 1;
        oli.TotalPrice = null;
        oli.Product2Id=p.id;
        oli.Distributor__c= acc.Id;
        oli.Is_Approved__c=true;
        oli.PricebookEntryId=pbe.id;
        oli.TotalPrice_GBP__c = 100;
        insert oli;
        order orderObj=new order();
        orderObj.OpportunityId=opplist[0].id;
        orderObj.EffectiveDate = Date.today();
        orderObj.Status='Draft';
        orderObj.isWithoutInvoice__c=true;
        orderObj.Pricebook2Id=pb.id;
        orderObj.AccountId=acc.id;
        insert orderObj;
        
        OrderItem newOi = new OrderItem(OrderId =orderObj.Id,
                                        Printer__c =acc.id,
                                        Quantity =1,
                                        PricebookEntryId =oli.PricebookEntryId,
                                        UnitPrice=oli.UnitPrice,
                                        product2id=oli.product2id,
                                        OpportunityProductId__c=oli.Id
                                       );   
        insert newoi;       
        
        Test.startTest();
        try {
            List<id> listids=new List<Id>();
            listids.add(newOi.id);
            IR_CreatePrintOrder cprobj=new IR_CreatePrintOrder();
            cprobj.CreatePrintOrder(listids);  
            orderObj.status='Placed';
            update orderObj;
        } catch (exception e) { 
        }
        Test.stopTest(); 
    }
}