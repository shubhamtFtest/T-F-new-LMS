@isTest
private class zTest_Ir_Controller {
    static testMethod void Ir_Controller () {
        IR_Controller.wrap_cl reqParam = new IR_Controller.wrap_cl();
        IR_Controller cont = new IR_Controller(); 
        User u = zTEST_Shared.insertUser();
        Account acc=zTEST_Shared.insertAccount(u.id);
        Id pricebookId = Test.getStandardPricebookId();
        Product2 p = zTEST_Shared.noinsertProduct2('0120Y000000WnAa');
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
        oli.UMC__c=1;
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
        
        Print_Order__c  printorderobj=new Print_Order__c();
        printorderobj.Status__c='Print Order Created';
        printorderobj.Invoice_Number__c='1234';
        printorderobj.Reference_Number__c='1234';
        printorderobj.Payment_Terms__c='69days';
        printorderobj.Delivery_Date__c=system.today();
        printorderobj.Special_Instructions__c='test';
        printorderobj.Packing_Instructions__c='test';
        printorderobj.Customer__c=acc.id;
        printorderobj.Printer__c=acc.id;
        printorderobj.isPoUploaded__c=true;
        printorderobj.order__c=orderObj.id;
        
        insert printorderobj;
        
        Print_Order_Item__c printoli=new Print_Order_Item__c();
        printoli.Print_Order__c=printorderobj.id;
        printoli.Total_UMC__c=1;
        insert printoli;
        reqParam.recordId =printorderobj.id;
        reqParam.ProfileCheack=true;
        reqParam.Name=printorderobj.Name;
        reqParam.Status=printorderobj.Status__c;
        reqParam.InvoiceNumber=printorderobj.Invoice_Number__c;
        reqParam.ReferenceNumber=printorderobj.Reference_Number__c;
        reqParam.PaymentTerm=printorderobj.Payment_Terms__c;
        reqParam.DeliveryDate=printorderobj.Delivery_Date__c;
        reqParam.CustomerName=printorderobj.Customer__r.Id;
        reqParam.SpecialInstructions=printorderobj.Special_Instructions__c;
        reqParam.PackingInstructions=printorderobj.Packing_Instructions__c;
        reqParam.Printer=printorderobj.Printer__r.Id;
        reqParam.isapproved=true;
        reqParam.base64Data=EncodingUtil.base64Encode(Blob.valueOf('testing'));
        Attachment attach = new Attachment();
        Blob body;
        body = Blob.valueOf('Some Text');
        attach.Body = body;
        attach.Name = 'Purchase_Order.pdf';
        attach.IsPrivate = false;
        attach.ParentId = printorderobj.id; 
        insert attach;
        reqParam.fileid=attach.id;
        
        
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
        conVer.PathOnClient = 'Purchase_Order.pdf'; // The files name, extension is very important here which will help the file in preview.
        conVer.Title = 'Purchase_Order.pdf'; // Display name of the files
        conVer.VersionData = body; // converting your binary string to Blog
        insert conVer;    //Insert ContentVersion
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        //create ContentDocumentLink  record 
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId =printorderobj.Id ; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
        conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
        conDocLink.shareType = 'V';
        insert conDocLink;
        
        //Calling Methods Of the IR_Controller 
        IR_Controller.invoke('Printorder:GeneratePO',JSON.serialize(reqParam));
        IR_Controller.invoke('Printorder:PrintorderRecList',JSON.serialize(reqParam));
        IR_Controller.invoke('Printorder:PrintorderRecDetail',JSON.serialize(reqParam));
        IR_Controller.invoke('Printorder:UpdatePrintOrder',JSON.serialize(reqParam));
        IR_Controller.invoke('Printorder:SendEmailToUK',JSON.serialize(reqParam));
        IR_Controller.invoke('Printorder:CheckProfileforUk',JSON.serialize(reqParam));
        IR_Controller.invoke('Printorder:SavePrintOrderRecord',JSON.serialize(reqParam));
        IR_Controller.invoke('Printorder:PrintOrderItemList',JSON.serialize(reqParam));
        IR_Controller.invoke('OrderLineItem:fetchAccount',JSON.serialize(reqParam));
       	List<Id> idset=new List<Id>();
        reqParam.recordId=newOi.id;
        reqParam.AccountId=acc.id;
        idset.add(newOi.id);
        reqParam.SelectedList=idset;
        IR_Controller.invoke('OrderLineItem:updateAcc',JSON.serialize(reqParam));
        IR_Controller.invoke('OrderLineItem:CreatePrintOrder',JSON.serialize(reqParam));

        
        IR_Controller.invoke('InsertAttach:Attachments',JSON.serialize(reqParam));
        reqParam.recordId=orderObj.id;
        IR_Controller.invoke('Printorder:ProdNotifyByCsd',JSON.serialize(reqParam)); 
        IR_Controller.invoke('Printorder:SendEmailToProd',JSON.serialize(reqParam));
        IR_Controller.invoke('OrderLineItem:OrderLineItemList',JSON.serialize(reqParam));
        IR_Controller.invoke('OrderLineItem:SendToProd',JSON.serialize(reqParam));
        
        IR_Controller.invoke('Printorder:uploadDistrInvoice',JSON.serialize(reqParam));


        reqParam.parentId=printorderobj.id;
       //IR_Controller.invoke('Printorder:GeneratePO',JSON.serialize(reqParam));

        List<id> idlist=new list<Id>();
        idlist.add(printorderobj.id);
        reqParam.SelectedList=idlist;


        reqParam.filename='Purchase_Order.pdf';
        reqParam.base64Data=EncodingUtil.base64Encode(Blob.valueOf('testing'));
        reqParam.contentType='pdf';
        reqParam.fileid='';
        
        IR_Controller.invoke('InsertAttach:Attachments',JSON.serialize(reqParam));
        List<id> idslist=new List<Id>();
        idslist.add(printoli.id);
        reqParam.SelectedList=idslist;
        IR_Controller.invoke('Printorder:ExportExcel',JSON.serialize(reqParam));

        
        
        
        
    }
}