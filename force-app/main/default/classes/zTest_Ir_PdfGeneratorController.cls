@isTest
private class zTest_Ir_PdfGeneratorController {
    static testMethod void test_Trig_Opp_TF_StageValidation() {
        User u = zTEST_Shared.insertUser();
        Account acc=zTEST_Shared.insertAccount(u.id);
        contact cc=zTEST_Shared.noinsertContact(u.id,acc.id);

        
        Id pricebookId = Test.getStandardPricebookId();
        Product2 p = zTEST_Shared.noinsertProduct2('0120Y000000WnAa');
        p.ProductCode='9781138225602';
        
        insert p;
        Pricebook2 pb = new pricebook2(name='T&F India Pricebook');
        insert pb;
        PricebookEntry pbeStandard = new PricebookEntry(Pricebook2Id=pricebookId, Product2Id=p.id, UnitPrice=1, IsActive=true);
        insert pbeStandard;
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pb.Id, Product2Id=p.id, UnitPrice=1, IsActive=true);
        insert pbe;
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint'); 
        List<Opportunity> opplist=new List<Opportunity>();
        Opportunity opp = zTEST_Shared.noinsertOpportunity(oppRecordtypeId, u.Id);
        opp.StageName = 'Prospect';
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

        List<Id> prlobj=new List<Id>();
        Print_Order__c pobj=new Print_Order__c();
        pobj.Delivery_Date__c=System.Today();
        pobj.order__c=orderObj.id;
        insert pobj;
        Print_Order_Item__c printorderobj=new Print_Order_Item__c();
        printorderobj.Print_Order__c=pobj.id;
        printorderobj.Product__c=p.id;
        printorderobj.Indian_Isbn__c='9781138225602';
        printorderobj.Print_Run__c=123;
        printorderobj.Printed_Pages__c=12;
        printorderobj.UMC__c=1;
        printorderobj.Customer_Quote__c=12;
        insert printorderobj;
        prlobj.add(pobj.id);
        IR_PdfGeneratorController op=new IR_PdfGeneratorController();
        op.ids=printorderobj.Print_Order__c;
        IR_PdfGeneratorController.savePdf(prlobj);
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'India Reprint Production' LIMIT 1];
        User usr = new User(LastName = 'LIVESTON',
                            FirstName='JASON',
                            Alias = 'jliv',
                            Email = 'jason.liveston@asdf.com',
                            Username = 'jadfsdfson.liveston@asdf.com',
                            ProfileId = profileId.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LocaleSidKey = 'en_US'
                           );
        
        Test.startTest();
        System.runas(usr) 
        {
            pobj.Delivery_Date__c=Date.newInstance(2020, 12, 9);
            update pobj;
        }
        
        Test.stopTest();
    }
}