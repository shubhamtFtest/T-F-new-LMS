/**************************************************
* Created by Sidhant on 9/20/2019.
* Tested by: zTest_Ir_Controller @ 81%
**************************************************/
public with sharing class IR_Controller {
    
    public IR_Controller() {
    } 
    public class wrap_cl{
        @AuraEnabled public String recordId;
        @AuraEnabled public String Name;
        @AuraEnabled public String Status;
        @AuraEnabled public String OrderStatus;
        @AuraEnabled public String InvoiceNumber;
        @AuraEnabled public String PaymentTerm;
        @AuraEnabled public Date DeliveryDate;
        @AuraEnabled public String CustomerName;
        @AuraEnabled public boolean ProfileCheack;
        @AuraEnabled public String SpecialInstructions;
        @AuraEnabled public  List<Print_Order_Item__c> PrintOrderItemList;
        @AuraEnabled public String parentId;
        @AuraEnabled public String fileName;
        @AuraEnabled public String base64Data;
        @AuraEnabled public String contentType;
        @AuraEnabled public String fileId;
        @AuraEnabled public String PackingInstructions;
        @AuraEnabled public boolean isapproved;
        @AuraEnabled public boolean isdistributor;
        @AuraEnabled public boolean DocumentApproved;
        @AuraEnabled public boolean isLock;
        @AuraEnabled public String title;
        @AuraEnabled public boolean isPrinter;
        @AuraEnabled public List<contentDocument>  PrintOrderFiles;
        @AuraEnabled public String UnitPrice;
        @AuraEnabled public String TotalPrice;
        @AuraEnabled public String Quantity;
        @AuraEnabled public String searchKeyWord;
        @AuraEnabled public String AccountId;
        @AuraEnabled public String Type;
        @AuraEnabled public String ISBN;
        @AuraEnabled public String IndianISBN;
        @AuraEnabled public String ReferenceNumber;
        @AuraEnabled public String Author;
        @AuraEnabled public String UMC;
        @AuraEnabled public String Printer;
        @AuraEnabled public String Binding;
        @AuraEnabled public String Quntity;
        @AuraEnabled public String InvoiceNo;
        @AuraEnabled public boolean isOrderPlaced;
        @AuraEnabled public boolean isPoUploaded;
        @AuraEnabled public String Remarks;
        @AuraEnabled public List<Id>  SelectedList;
        @AuraEnabled public boolean isCreditReq;
        @AuraEnabled public Decimal Extent;
        @AuraEnabled public String Cover_Paper;
        @AuraEnabled public String Text_Colour;
        @AuraEnabled public String Insert_Paper;
        @AuraEnabled public Decimal MRP;
        @AuraEnabled public String Version_Type;
        @AuraEnabled public String Paper_Type_GSM;
        @AuraEnabled public String Popular_Format;
        @AuraEnabled public boolean showrelatedlist;
        
        
        
    }
    @AuraEnabled
    public static Object invoke(String action, String parameters) 
    {
        Object response = new Map<String, Object> {'message'=>'Action not found!','type'=>'error'};
            wrap_cl parameter;
        
        try{        
            parameter = (wrap_cl)JSON.deserialize(parameters, wrap_cl.class);
            
        }
        catch(Exception e){
            throw new AuraHandledException('ERROR: '+e.getMessage());
        }
        switch on action {
            
            when 'Printorder:PrintorderRecList' {
                response = PrintOrderRecList(parameter);
            }
            when 'Printorder:PrintorderRecDetail'{
                response = PrintOrderRecDetails(parameter);
            }
            when 'InsertAttach:Attachments'{
                response = saveChunk(parameter);
                
            }
            when 'Printorder:UpdatePrintOrder'{
                response = UpdatePrintOrder(parameter);
                
            }
            when 'Printorder:SendEmailToUK'{
                response = SendEmailToUK(parameter);
                
            }
            when 'Printorder:SendEmailToProd'{
                response = SendEmailToProd(parameter);
                
            }
            when 'Printorder:CheckProfileforUk'{
                response =CheckProfileforUk(parameter);
            }
            when 'Printorder:uploadDistrInvoice'{
                response =uploadDistrInvoice(parameter);
                
            }
            when 'Printorder:ProdNotifyByCsd'{
                response =CheckCsdProfileCheck(parameter);
            }
            
            
            when 'Printorder:SavePrintOrderRecord'{
                response =SavePrintOrderRecord(parameter);
                
            }
            when 'Printorder:PrintOrderItemList'{
                //    response =ShowRelatedPrintItems(parameter);
            }
            when 'OrderLineItem:OrderLineItemList'{
                response =OrderLineitem(parameter);
                
            } 
            when 'OrderLineItem:SendToProd'{
                response =SendOrderItem(parameter);
                
            }
            when 'OrderLineItem:fetchAccount'{
                response =fetchAccount(parameter);
                
            }
            when 'OrderLineItem:updateAcc'{
                response =updateOliRec(parameter);
                
            }
            when 'OrderLineItem:CreatePrintOrder'{
                response =CreatePrintOrder(parameter);
                
            }
            when 'Printorder:GeneratePO'{
                response =GeneratePO(parameter);
            }
            when 'Printorder:ExportExcel'{
                response =ExportExcel(parameter);
            }
        }
        return response;
        
    }
    private static List<wrap_cl> PrintOrderRecList(wrap_cl parameters) {
        Id profileId=userinfo.getProfileId();
        Id userId=UserInfo.getUserId();
        set<Id> contactSet=new set<Id>();
        set<Id> accountSet=new set<Id>();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        system.debug('ProfileName'+profileName);
        for(User u:[select id,name,contactid from user where id =:userId]){
            system.debug(u.name+'%%%%%%%%%%'+u.contactid);
            contactSet.add(u.contactid);
        }
        if(contactSet.size()>0){
            system.debug('#####'+contactSet);
            for(contact  cc:[select id,Accountid from contact where id in :contactSet]){
                accountSet.add(cc.Accountid);
            }
        }
        List<print_order__c> printorderlist=new list<print_order__c>();
        if(profileName=='India Reprint Printer'){
            printorderlist=[Select id,Name,Packing_Instructions__c,Customer__c,Customer__r.Name,Status__c,Invoice_Number__c,Special_Instructions__c,isPoUploaded__c,Reference_Number__c,Printer__r.name,Payment_Terms__c,Delivery_Date__c from Print_Order__c where isPoUploaded__c=true and printer__c in:accountSet];
        }else if(profileName=='India Reprint Distributor'){
            printorderlist=[Select id,Name,Packing_Instructions__c,Customer__c,Customer__r.Name,Status__c,Invoice_Number__c,Special_Instructions__c,isPoUploaded__c,Reference_Number__c,Printer__r.name,Payment_Terms__c,Delivery_Date__c from Print_Order__c where isPoUploaded__c=true and customer__c in:accountSet];
        }else if(profileName=='India Reprint Credit Control'){
            printorderlist=[Select id,Name,Packing_Instructions__c,Customer__c,Customer__r.Name,Status__c,Invoice_Number__c,Special_Instructions__c,isPoUploaded__c,Reference_Number__c,Printer__r.name,Payment_Terms__c,Delivery_Date__c from Print_Order__c where isPoUploaded__c=true ];
            
        } 
        List<wrap_cl> wraplistdata=new List<wrap_cl>();
        if(printorderlist.size()>0){
            for(Print_Order__c printobj :printorderlist){
                wrap_cl wrapobj=new wrap_cl();
                wrapobj.Name=printobj.Name;
                wrapobj.Status=printobj.Status__c;
                wrapobj.InvoiceNumber=printobj.Invoice_Number__c;
                wrapobj.ReferenceNumber=printobj.Reference_Number__c;
                if(profileName!='India Reprint Printer'){
                    wrapobj.Printer=printobj.Printer__r.name;
                }
                wrapobj.PaymentTerm=printobj.Payment_Terms__c;
                wrapobj.DeliveryDate=printobj.Delivery_Date__c;
                wrapobj.CustomerName=printobj.Customer__r.Name;
                wrapobj.SpecialInstructions=printobj.Special_Instructions__c;
                wrapobj.recordId=printobj.Id;
                if(profileName=='India Reprint Printer'){
                    wrapobj.ProfileCheack=true;
                }
                wrapobj.PackingInstructions=printobj.Packing_Instructions__c;
                
                wraplistdata.add(wrapobj);
            }
            return wraplistdata;
            
        }else{
            return wraplistdata;
        }
        
    }
    
    private static  List<wrap_cl>  PrintOrderRecDetails(wrap_cl parameters) 
    {
       
        Id recordid;
        List<Print_Order_Item__c> printorderitemlist =[select id,Print_Order__c from Print_Order_Item__c where id =:parameters.recordId];
        if(printorderitemlist.size()>0){
            recordid=printorderitemlist[0].Print_Order__c;
        }
        else{
            recordid=parameters.recordId;
            
        }
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        IR_Profile_To_File_Mapping__c mhc = IR_Profile_To_File_Mapping__c.getInstance(profileId);
        String FileType = '';
        List<String> stringList = new List<String>();
        
        FileType=mhc.FileType__c;
        if(FileType!=null){
            for(String key:FileType.split(',')){
                stringList.add(key);
            }
        }
        System.debug('parameters'+parameters.recordId); 
        List<wrap_cl> wraplistdata=new List<wrap_cl>();
        List<Print_Order_Item__c> Printiteamlist=new  List<Print_Order_Item__c> ();
        List<ContentDocumentLink> ContentDocLink=new  List<ContentDocumentLink> ();
        List<contentDocument> contentDocumentList=new  List<contentDocument> ();
        Set<Id> ContentDocId=new  Set<Id> ();
        
        ContentDocLink=[Select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId=:recordId];
        
        for(ContentDocumentLink condocObj:ContentDocLink){
            ContentDocId.add(condocObj.ContentDocumentId);
        }
        //Added For File Type Cheack
        for(contentDocument ConDocObj:[Select id,Title,ContentModifiedDate ,CreatedBy.Name,ContentSize From contentDocument where id in:ContentDocId]){
            String Title=ConDocObj.Title;
            List<string> strl = Title.split('_', 2);
            system.debug('Title'+Title);
            if(stringList.size()>0 ){
                if((stringList.contains(strl[0]) )|| ((Title=='Purchase_Order.pdf'  || 	Title=='PurchaseOrder.csv') && profileName=='India Reprint Printer')){
                    contentDocumentList.add(ConDocObj);
                }
            }else if((Title=='Purchase_Order.pdf'  || 	Title=='PurchaseOrder.csv') && profileName=='India Reprint Printer'){
                contentDocumentList.add(ConDocObj);
            }
            else if(profileName=='India Reprint Credit Control'){
                contentDocumentList.add(ConDocObj);
                
            }
            
            
        }
        
        //contentDocumentList=[Select id,Title,ContentModifiedDate ,CreatedBy.Name,ContentSize From contentDocument where id in:ContentDocId];
        Printiteamlist=[SELECT Id, Name, CurrencyIsoCode, RecordTypeId, CreatedDate, CreatedById,Product__c,  Agreed_Price_Per_Copy__c, Printed_Pages__c, Format_Height_mm__c, List_Price_INR__c, List_Price_GBP__c, ISBN__c, Print_Order__c, Title__c, Impression__c, Print_Run__c, Size_in_inches__c, Pages__c, Inserts__c, Text_Color__c, Cover_Color__c, Insert_Color__c, Paper_Text__c, Paper_Cover__c, Paper_Insert__c, Binding__c, Origination__c, Author__c, Format_Width_mm__c, UMC__c, Total_UMC__c, Paper_Type_GSM__c, Version_Type__c, MRP__c, Paper_GSM__c, Customer_Quote__c FROM Print_Order_Item__c where Print_Order__c=:recordId];
        
        if(recordId!=null){
            Print_Order__c printobj =[Select id,Name,Order__r.Id,Packing_Instructions__c,Document_Approved__c,Customer__c,Customer__r.Name,Status__c,Invoice_Number__c,Special_Instructions__c,Reference_Number__c,Distr_Approve_Packing_Details__c,Printer__r.name,Payment_Terms__c,Delivery_Date__c from Print_Order__c where  id=:recordId];
            if(profileName=='India Reprint Distributor' || profileName=='India Reprint Credit Control'){
                ContentDocLink=[Select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId=:printobj.Order__r.Id];
                for(ContentDocumentLink condocObj:ContentDocLink){
                    ContentDocId.add(condocObj.ContentDocumentId);
                }
                for(contentDocument ConDocObj:[Select id,Title,ContentModifiedDate ,CreatedBy.Name,ContentSize From contentDocument where id in:ContentDocId and Title Like :'Distributor_Invoice%' ])
                {
                    contentDocumentList.add(ConDocObj);
                }
            }
            wrap_cl wrapobj=new wrap_cl();
            wrapobj.Name=printobj.Name;
            if(Approval.isLocked(printobj.Id) || profileName=='India Reprint Credit Control'){
                wrapobj.isLock=true;
            }else{
                wrapobj.isLock=false;
            }          
            wrapobj.Status=printobj.Status__c;
            wrapobj.InvoiceNumber=printobj.Invoice_Number__c;
            wrapobj.ReferenceNumber=printobj.Reference_Number__c;
            wrapobj.Printer=printobj.Printer__r.name;
            wrapobj.PaymentTerm=printobj.Payment_Terms__c;
            wrapobj.DeliveryDate=printobj.Delivery_Date__c;
            wrapobj.recordId=printobj.Id;
            wrapobj.CustomerName=printobj.Customer__r.Name;
            wrapobj.SpecialInstructions=printobj.Special_Instructions__c;
            wrapobj.PackingInstructions=printobj.Packing_Instructions__c;
            wrapobj.PrintOrderFiles=contentDocumentList;
            wrapobj.PrintOrderItemList=Printiteamlist;
            wrapobj.isapproved=printobj.Distr_Approve_Packing_Details__c;
            if(profileName=='India Reprint Distributor'){
                if(printobj.Document_Approved__c==true ){
                    wrapobj.DocumentApproved=true;
                }else{
                    wrapobj.DocumentApproved=false;
                }
                wrapobj.isdistributor=true;
            }else{
                wrapobj.DocumentApproved=true;
                wrapobj.isdistributor=false;
                
            }
            if(profileName=='India Reprint Printer'){
                wrapobj.isPrinter=true;
            }else{
                wrapobj.isPrinter=false;
            }
            
             if(profileName=='India Reprint Credit Control'){
                wrapobj.isCreditReq=true;
            }else{
                wrapobj.isCreditReq=false;
            }
            wraplistdata.add(wrapobj);
        }
        
        return wraplistdata;
    }
    //Upload File Section
    private static Id saveChunk(wrap_cl parameters) {
        String fileName;
        List<Order> orderlist=new List<Order>([select id from order where id =:parameters.parentid]);
        if(orderlist.size()>0){
            fileName='Distributor_Invoice'+parameters.fileName;
            order oobj=new order();
            oobj.id=orderlist[0].id;
            oobj.Distributor_Invoice_No__c=parameters.InvoiceNo;
            update oobj;
            
        }else{
            fileName=parameters.fileName;
        }
        
        Id parentId=parameters.parentid;
        String base64Data=parameters.base64Data;
        String contentType=parameters.contentType;
        String fileId=parameters.fileId;
        System.debug('parentId'+parentId+'fileName'+fileName+'base64Data'+base64Data+'contentType'+contentType+'fileId'+fileId);
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert, 
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks   
        if (fileId == '') {
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }
        
        return Id.valueOf(fileId);
    }
    
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
        Set<Id> docId=new Set<Id>();
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        List<ContentVersion> cvList = new List<ContentVersion>();
        List<ContentDocumentLink> ContentversionList = new List<ContentDocumentLink>();
        
        Contentversion cv= new Contentversion(Title =fileName, PathOnClient = 'test', VersionData = EncodingUtil.base64Decode(base64Data));
        cvList.add(cv);
        insert cvList;
        for(ContentVersion cvobj:[select id, ContentDocumentId from ContentVersion WHERE Id in :cvList]){
            ContentDocumentLink cl = new ContentDocumentLink();
            cl.ContentDocumentId = cvobj.ContentDocumentId;
            cl.LinkedEntityId = parentId; //Shared with record ID
            cl.ShareType = 'V';
            cl.Visibility = 'AllUsers';
            ContentversionList.add(cl);
        }
        
        insert ContentversionList;
        for(ContentDocumentLink contdoclink:[Select id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId=:parentId]){
            docId.add(contdoclink.ContentDocumentId);
        }
        List<Contentversion> contentversionListSendEmai=new List<Contentversion>([Select id ,title,ContentDocumentId from Contentversion where title LIKE 'Delivery challan%' And title LIKE 'Distributor Invoice%' And ContentDocumentId in:docId]);
        if(contentversionListSendEmai.size()>0){
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage> ();
            
            List<EmailTemplate> emailTemplateId = [select id from EmailTemplate where DeveloperName='IR_Document_varification' limit 1];
            //send mail to Production For that parentid record to approve it
            for(User ProductionProdile :[Select id,email from user where profile.name =:'India Reprint Production']) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                // assign user
                mail.setTargetObjectId(ProductionProdile.Id); 
                //email template id
                mail.setTemplateId(emailTemplateId[0].id); 
                mail.setToAddresses(new string[] {ProductionProdile.email});
                mail.setwhatid(parentId);
                mail.setSaveAsActivity(false);
                mails.add(mail);
            }
            Messaging.sendEmail(mails);
        }
        return ContentversionList[0].id;
    }
    
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id =: fileId
        ];
        
        String existingBody = EncodingUtil.base64Encode(a.Body);
        a.Body = EncodingUtil.base64Decode(existingBody + base64Data);
        update a;
    }
    private static  List<wrap_cl>  UpdatePrintOrder(wrap_cl parameters) {
        System.debug('parameters'+parameters.recordId);
        System.debug('parameters'+parameters.DeliveryDate);
        System.debug('parameters'+parameters.Remarks);
        
        Print_Order__c printorderobj=new Print_Order__c();
        printorderobj.id=parameters.recordId;
        if(parameters.DeliveryDate!=null){
            printorderobj.Delivery_Date__c=parameters.DeliveryDate;
        }
        if(parameters.Remarks!=null){
            
            printorderobj.Remarks__c=String.valueof(parameters.Remarks);
        }
        Update printorderobj;
        
        List<wrap_cl> wraplistdata=new List<wrap_cl>();
        List<Print_Order_Item__c> Printiteamlist=new  List<Print_Order_Item__c> ();
        Printiteamlist=[Select id,Name,Agreed_Price_Per_Copy__c,ISBN__c,List_Price_GBP__c,List_Price_INR__c,Print_Order__c,Product__r.name from Print_Order_Item__c where Print_Order__c=:parameters.recordId];
        for(Print_Order__c printobj :[Select id,Name,Packing_Instructions__c,Customer__c,Customer__r.Name,Status__c,Invoice_Number__c,Special_Instructions__c,Reference_Number__c,Printer__r.name,Payment_Terms__c,Delivery_Date__c from Print_Order__c where id=:parameters.recordId]){
            wrap_cl wrapobj=new wrap_cl();
            wrapobj.Name=printobj.Name;
            wrapobj.Status=printobj.Status__c;
            wrapobj.InvoiceNumber=printobj.Invoice_Number__c;
            wrapobj.ReferenceNumber=printobj.Reference_Number__c;
            wrapobj.Printer=printobj.Printer__r.name;
            wrapobj.PaymentTerm=printobj.Payment_Terms__c;
            wrapobj.DeliveryDate=printobj.Delivery_Date__c;
            wrapobj.recordId=printobj.Id;
            wrapobj.CustomerName=printobj.Customer__r.Name;
            wrapobj.SpecialInstructions=printobj.Special_Instructions__c;
            wrapobj.PackingInstructions=printobj.Packing_Instructions__c;
            wrapobj.PrintOrderItemList=Printiteamlist;
            
            
            wraplistdata.add(wrapobj);
        }
        return wraplistdata;
    }
    private static  boolean  SendEmailToUK(wrap_cl parameters) {
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage> ();
        String Emailbody='Documents For varification!';
        Set<Id> docId=new Set<Id>(); 
        Set<Id> Attachid=new Set<Id>();
        List<ContentVersion> cvList = new List<ContentVersion>();
        List<ContentDocumentLink> ContentversionList = new List<ContentDocumentLink>();
        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
        String subject='The Email Contains PO,DC,PI as its Attachment';
        id parentId=parameters.recordId;
        
        for(ContentDocumentLink contdoclink:[Select id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId=:parentId]){
            docId.add(contdoclink.ContentDocumentId);
        }
        List<Contentversion> contentversionListSendEmai=new List<Contentversion>([Select id ,title,ContentDocumentId from Contentversion where (title LIKE 'Delivery challan%' OR title LIKE 'Printer Invoice%' OR title LIKE 'Purchaceorder.pdf%') And
                                                                                  ContentDocumentId in:docId]);
        
        for(Contentversion attachmid:contentversionListSendEmai){
            Attachid.add(attachmid.Id);
        }
        
        if(Attachid.size()>0){
            
            for (Contentversion file: [select id ,title,filetype,VersionData,ContentDocumentId  from Contentversion where id in: Attachid]) {
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                String filename=file.Title+'.'+file.filetype;
                efa.setFileName(filename);
                efa.setBody(file.VersionData);
                attachments.add(efa);
                
            }
            for(Print_Order_Email__c UkEmail :[Select id,Email__c from Print_Order_Email__c]) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                //email template id
                mail.setSubject(subject);
                mail.setToAddresses(new string[] {UkEmail.Email__c});
                mail.setwhatid(parentId);
                mail.setSaveAsActivity(false);
                mail.setFileAttachments(attachments);
                mail.setPlainTextBody(Emailbody); 
                mails.add(mail);
                
            }
            Messaging.sendEmail(mails);
            
        }
        if(profileName=='India Reprint Production'){
            return true;
        }else{
            return false;
        }
    }
    private static  boolean  SendEmailToProd(wrap_cl parameters) {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage> ();
        
        List<EmailTemplate> emailTemplateId = [select id from EmailTemplate where DeveloperName='IRP_Place_Order_Notification' limit 1];
        //send mail to Production For that parentid record to approve it
        for(User ProductionProdile :[Select id,email from user where profile.name =:'India Reprint Production']) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            // assign user
            mail.setTargetObjectId(ProductionProdile.Id); 
            //email template id
            mail.setTemplateId(emailTemplateId[0].id); 
            mail.setToAddresses(new string[] {ProductionProdile.email});
            mail.setwhatid(parameters.recordId);
            mail.setSaveAsActivity(false);
            mails.add(mail);
        }
        Messaging.sendEmail(mails);
        /*  Order ob=[select id,Order_Status__c from order where id =:parameters.recordId];
ob.Order_Status__c='Production Notified';
update ob;*/
        return null;
    }
    
    private static  String  CheckProfileforUk(wrap_cl parameters) {
        //Add Document Approved Check
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        List<Print_Order__c> printorderList=new List<Print_Order__c>([select id,Delivery_Date__c,isPoUploaded__c from Print_Order__c where  id =:parameters.recordId]);
        if(profileName=='India Reprint Production' && printorderList[0].Delivery_Date__c!=null && printorderList[0].isPoUploaded__c==false){
            return 'Approved';
        }else if(profileName=='India Reprint Production' && printorderList[0].Delivery_Date__c==null){
            return 'AddMessage';
        } 
        else
            return 'Disabled';
    }
    private static  boolean  CheckCsdProfileCheck(wrap_cl parameters) {
        Order ordobj=[select id,isWithoutInvoice__c,status,Distributor_Invoice_No__c from order where id =:parameters.recordid  limit 1];
        //Add Document Approved Check
        
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        
        if(profileName=='India Reprint Production' && (ordobj.isWithoutInvoice__c==true || ordobj.Distributor_Invoice_No__c!=null)){
            return false;
        }else{
            return true;
        } 
    }
    
    private static  Print_Order__c  SavePrintOrderRecord(wrap_cl parameters) {
        Print_Order__c poobj= new Print_Order__c();
        poobj.id=parameters.recordId;
        poobj.Distr_Approve_Packing_Details__c=parameters.isapproved;
        update poobj;
        return poobj;
    }
    private static  List<wrap_cl>  OrderLineitem(wrap_cl parameters) {
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        system.debug('ProfileName'+profileName);
        List<wrap_cl> wraplist=new List<wrap_cl>();
        map<id,id> oliidorderidmap=new map<id,id>();
        map<id,OrderItem> oliidRefNo=new map<id,OrderItem>();
        
        List<OrderItem> OrderItemList=new List<OrderItem>([Select Id,order.isWithoutInvoice__c,order.Distributor_Invoice_No__c,Order_Item_Status__c,order.Order_Status__c,Reference_Number__c,OpportunityProductId__c,Order.opportunity.Proposal_Type__c,UnitPrice,Printer__r.Name,TotalPrice,Quantity,Product2.name from OrderItem where OrderId=:parameters.recordId]);
        for(OrderItem obj:OrderItemList){
            oliidorderidmap.put(obj.OpportunityProductId__c,obj.Id);
            oliidRefNo.put(obj.OpportunityProductId__c,obj);
        }
        if(OrderItemList[0].OpportunityProductId__c!=null){
            for(OpportunityLineItem Oliobj:[select id,Extent__c,Global_ISBN__c,Cover_Paper__c,Text_Colour__c,Insert_Paper__c,Paper_Type_GSM__c,MRP__c,Version_Type__c,Popular_Format__c,Product2.name,Binding_Type__c,Type__c,UMC__c,Quantity,Indian_Isbn__c,Product2.Author__c,Distributor__r.Name,Product2.ProductCode from OpportunityLineItem where id in:oliidorderidmap.keyset()]){
                wrap_cl wrapobj=new wrap_cl();
                wrapobj.Name=Oliobj.Product2.name;
                if((oliidRefNo.get(Oliobj.Id).Order.isWithoutInvoice__c!=true && oliidRefNo.get(Oliobj.Id).Order.Distributor_Invoice_No__c==null)  && profileName=='India Reprint Production'){
                    wrapobj.showrelatedlist=true;
                }
                wrapobj.Cover_Paper=Oliobj.Cover_Paper__c;
                wrapobj.Text_Colour=Oliobj.Text_Colour__c;
                wrapobj.Insert_Paper=Oliobj.Insert_Paper__c;
                wrapobj.MRP=Oliobj.MRP__c;
                wrapobj.Version_Type=Oliobj.Version_Type__c;
                wrapobj.Paper_Type_GSM=Oliobj.Paper_Type_GSM__c;
                wrapobj.Popular_Format=Oliobj.Popular_Format__c;
                wrapobj.Type=Oliobj.Type__c;
                wrapobj.Status=oliidRefNo.get(Oliobj.Id).Order_Item_Status__c;
                wrapobj.OrderStatus=oliidRefNo.get(Oliobj.Id).Order.Order_Status__c;
                //wrapobj.UnitPrice=string.valueof(obj.UnitPrice);
                // wrapobj.TotalPrice=string.valueof(obj.TotalPrice);
                wrapobj.ReferenceNumber=oliidRefNo.get(Oliobj.Id).Reference_Number__c;
                wrapobj.Quantity=string.valueof(Integer.valueof(Oliobj.Quantity));
                if(oliidRefNo.get(Oliobj.Id).Printer__r.Name!=null){
                    wrapobj.Printer=oliidRefNo.get(Oliobj.Id).Printer__r.Name;
                }else{
                    wrapobj.Printer='';
                }
                wrapobj.ISBN=Oliobj.Global_ISBN__c;
                wrapobj.IndianISBN=Oliobj.Indian_Isbn__c;
                wrapobj.Author=Oliobj.Product2.Author__c;
                wrapobj.UMC=String.valueof(Oliobj.UMC__c);
                wrapobj.Binding=Oliobj.Binding_Type__c	;
                if(profileName=='India Reprint Production'){
                    wrapobj.ProfileCheack=true;
                }else{
                    wrapobj.ProfileCheack=false;
                    
                }
                if(oliidRefNo.get(Oliobj.Id).order.Order_Status__c=='Placed'){
                    wrapobj.isOrderPlaced=true;
                }else{
                    wrapobj.isOrderPlaced=false;
                }
                wrapobj.recordId=oliidorderidmap.get(Oliobj.Id);
                wraplist.add(wrapobj);
            }
            return wraplist;
        }else{
            for(orderitem obj:OrderItemList){
                wrap_cl wrapobj=new wrap_cl();
                wrapobj.Name=obj.Product2.name;
                if(profileName=='India Reprint Production'){
                    wrapobj.ProfileCheack=true;
                }else{
                    wrapobj.ProfileCheack=false;
                    
                }
                if(obj.order.Order_Status__c=='Placed'){
                    wrapobj.isOrderPlaced=true;
                }else{
                    wrapobj.isOrderPlaced=false;
                }
                wrapobj.recordId=obj.Id;
                wraplist.add(wrapobj);
            }
            return wraplist;
            
        }
    }
    private static  List<Account>  fetchAccount(wrap_cl parameters) {
        String searchKey = parameters.searchKeyWord + '%';
        List < Account > returnList = new List < Account > ();
        List < Account > lstOfAccount = [select id, Name from account where Area_of_Business__c!=null  And Name LIKE: searchKey];
        for (Account acc: lstOfAccount) {
            returnList.add(acc);
        }
        return returnList;
    }
    private static  Orderitem  updateOliRec(wrap_cl parameters) {
        List<orderitem> orderitemlist=new List<Orderitem>([select id,order.Order_Status__c from orderitem where id =:parameters.recordId Or id in:parameters.SelectedList]);
        for(orderitem obj:orderitemlist){
            if(obj.order.Order_Status__c=='Placed'){
            }else{
                orderitem oli= new orderitem(); 
                oli.Id=obj.id;
                oli.Printer__c=parameters.AccountId;
                update oli;
            }
        }
        return null;
    }
    private static  boolean  CreatePrintOrder(wrap_cl parameters) {
        List<Orderitem> orlist=[select id,OpportunityProductId__c,Order_Item_Status__c,order.Distributor_Invoice_No__c,order.isWithoutInvoice__c from orderitem where (order.Distributor_Invoice_No__c!=null or order.isWithoutInvoice__c=true) and  id in:parameters.SelectedList];
        List<id> olilist=new List<id>();
        Set<Id> oppidtoupdate=new Set<Id>();
        boolean isAlreadyAprroved=false;
        map<id,string> oppInvoicenomap=new map<Id,string>();

        List<Orderitem> cheackupdaterec=new list<Orderitem>();
        for(Orderitem orobj:orlist){
             oppInvoicenomap.put(orobj.OpportunityProductId__c,orobj.order.Distributor_Invoice_No__c);
              oppidtoupdate.add(orobj.OpportunityProductId__c);
            if(orobj.Order_Item_Status__c=='Print Order Created'){
                cheackupdaterec.add(orobj);
            }
            olilist.add(orobj.id);
        }
        if(orlist.size()>0 && cheackupdaterec.size()==0){
            IR_CreatePrintOrder cprobj=new IR_CreatePrintOrder();
            cprobj.CreatePrintOrder(olilist);
        }
        if(cheackupdaterec.size()>0){
            isAlreadyAprroved=true;
        }else{
            isAlreadyAprroved=false;
        }
        
        List<Opportunitylineitem> oplist=new List<Opportunitylineitem>();
            if(oppidtoupdate.size()>0){
                for(Opportunitylineitem oppli:[select id,CSD_Placed_Order__c from opportunitylineitem where id in:oppidtoupdate]){
                   oppli.CSD_Placed_Order__c='Placed';
                   // oppli.Invoice_Number__c=oppInvoicenomap.get(oppli.Id);
                    oplist.add(oppli);
                }
                if(oplist.size()>0){
                   update oplist; 
                }
            }
        return isAlreadyAprroved;
    }
    private static  id  GeneratePO(wrap_cl parameters) {
        List<Id> parentIds=new List<Id>();
        parentIds.add(parameters.recordId);
        IR_PdfGeneratorController.savePdf(parentIds);
        return null;
    }
    private static  List<Print_Order_Item__c>  ExportExcel(wrap_cl parameters) {
        List<Print_Order_Item__c>  printitemslist=new List<Print_Order_Item__c>();  
        printitemslist=[Select id,ISBN__c,Indian_Isbn__c,Title__c,List_Price_GBP__c,MRP__c,Customer_Quote__c from Print_Order_Item__c where id in:parameters.SelectedList];
        return printitemslist;
    }
    private static  String  SendOrderItem(wrap_cl parameters) {
        List<Orderitem> orlist=[select id,OpportunityProductId__c,Order_Item_Status__c,Order.Distributor_Invoice_No__c,Order.isWithoutInvoice__c,OrderId from orderitem where  id in:parameters.SelectedList];
        List<Orderitem> updateList=new List<Orderitem>();
        List<Orderitem> cheackupdaterec=new list<Orderitem>();
        map<id,string> oppInvoicenomap=new map<Id,string>();
        Set<Id> oppidtoupdate=new Set<Id>();
        String isAlreadyAprroved='';
        for(Orderitem oliobj:orlist){
            oppInvoicenomap.put(oliobj.OpportunityProductId__c,oliobj.order.Distributor_Invoice_No__c);
            oppidtoupdate.add(oliobj.OpportunityProductId__c);
            if(oliobj.Order.Distributor_Invoice_No__c==null && oliobj.Order.isWithoutInvoice__c!=true){
                isAlreadyAprroved='NoInvoice';
            }else{
                if(oliobj.Order_Item_Status__c=='Approved'){
                    isAlreadyAprroved='AreadyApproved'; 
                    cheackupdaterec.add(oliobj);
                }else{
                    oliobj.Order_Item_Status__c='Approved';
                }
            }
            
            updateList.add(oliobj);
            List<Opportunitylineitem> oplist=new List<Opportunitylineitem>();
            if(oppidtoupdate.size()>0){
                for(Opportunitylineitem oppli:[select id,CSD_Placed_Order__c from opportunitylineitem where id in:oppidtoupdate]){
                   oppli.CSD_Placed_Order__c='Approved';
                    oppli.Invoice_Number__c=oppInvoicenomap.get(oppli.Id);
                    oplist.add(oppli);
                }
                if(oplist.size()>0){
                   update oplist; 
                }
            }
        }
        if(cheackupdaterec.size()==0){
            update updateList;
        }
        List<OrderItem> AllOrderRelatedTo =[select id from orderitem where orderid = :orlist[0].OrderId];
        List<OrderItem> ApprovedOrderitem =[select id from orderitem where Order_Item_Status__c='Approved' and orderid = :orlist[0].OrderId];
        if(AllOrderRelatedTo.size()==ApprovedOrderitem.size()){
            Order orobj=new Order();
            orobj.Id=orlist[0].OrderId;
            orobj.Order_Status__c='Approved';
            update orobj;
        }
        return isAlreadyAprroved;
        
    }
    private static  boolean  uploadDistrInvoice(wrap_cl parameters) {
        boolean ProfileCheack=false;
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        if(profileName=='India Reprint Production'){
            ProfileCheack=true;
        }else{
            ProfileCheack=false;
            
        }
        return ProfileCheack;
    }
    
}