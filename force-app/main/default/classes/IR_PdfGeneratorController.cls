/**************************************************
* Created by Sidhant on 4/11/2019.
* Tested by: zTest_Ir_PdfGeneratorController @ 88%
* Notes: 
* The logic below will  Generate PO(Purchase Order). and
* Send Email To the Production Profile Users with Attached PO.
**************************************************/
public with sharing class IR_PdfGeneratorController {
    public List<Print_Order_Item__c> PrintOrderList{get;set;} 
    public List<Print_Order__c> printOrderrecList{get;set;}
    public string loginusername {get;set;}
    public Decimal aggreedpricepercopy{get;set;}
    public Id ids;
    public String createddate{get;set;}
    public set<Id> oliidset=new Set<Id>();
    public map<Id,OpportunityLineItem> oliidmap=new map<Id,OpportunityLineItem>();
    public IR_PdfGeneratorController(){
        loginusername=UserInfo.getName();
         ids=apexpages.currentpage().getparameters().get('id');
        PrintOrderList=[SELECT Customer_Quote__c,MRP__c,Agreed_Price_Per_Copy__c,Print_Order__r.Name,Binding__c,Cover_Color__c,OpportunityProductId__c,Print_Order__r.Printer__r.Name,
                        Id,Impression__c,Inserts__c,Insert_Color__c,Total_UMC__c,UMC__c,Paper_Type_GSM__c,
                        ISBN__c,IsDeleted,List_Price_GBP__c,List_Price_INR__c,Print_Order__r.LastModifiedDate ,
                        Name,Origination__c,Pages__c,Paper_Cover__c,Paper_Insert__c,Paper_Text__c,
                        Print_Order__c,Print_Run__c,Product__c,Size_in_inches__c,Text_Color__c,Print_Order__r.Delivery_Date__c,
                        Print_Order__r.Invoice_Number__c,Print_Order__r.Customer__c,Print_Order__r.Packing_Instructions__c,
                        Print_Order__r.Customer__r.Name,Print_Order__r.Payment_Terms__c,Print_Order__r.Reference_Number__c,Reference_Number__c,Print_Order__r.Special_Instructions__c,Author__c,
                        lamination__c,Title__c,Print_Order__r.TO__c,Gratis__c,Indian_Isbn__c,print_order__r.Customer__r.Billing_Street__c,print_order__r.Customer__r.Billing_City__c,print_order__r.Customer__r.Billing_State__c,print_order__r.Customer__r.Billing_Country__c FROM Print_Order_Item__c where Print_Order__c=:ids order by Reference_Number__c desc];
        if(!Test.isRunningTest()){

        DateTime dT =PrintOrderList[0].Print_Order__r.LastModifiedDate;    
        createddate= dT.day()+ ' th ' + dt.format('MMM') + ' ' + dt.year();
        }
        printOrderrecList=[select Customer__r.Billing_Street__c,Customer__r.Billing_City__c,Customer__r.Billing_State__c,Customer__r.Billing_Country__c, id,Printer__r.Name,TO__c,Reference_Number__c,Invoice_Number__c,Delivery_Date__c,Special_Instructions__c,Payment_Terms__c,Customer__r.Name,Packing_Instructions__c	 from Print_Order__c where id=:ids];
        aggreedpricepercopy=0;
        for(Print_Order_Item__c oliobj:PrintOrderList){
            aggreedpricepercopy=aggreedpricepercopy+oliobj.Total_UMC__c;
            oliidset.add(oliobj.OpportunityProductId__c);
        } 
        for(OpportunityLineItem oliobj:[select id,Quantity from OpportunityLineItem where id in:oliidset ]){
            oliidmap.put(oliobj.id,oliobj);
        }        
    }
    public static void  savePdf(List<Id> parentIds) {
                map<string,Print_Order_Item__c>  mapofIndianIsbn=new map<string,Print_Order_Item__c>(); 

        String subject = 'Print Orders Invoice'; 
        String bodycsv = 'This Email Contains The Info Of All ISBN(Products)'; 
        // Creating the CSV file
        String finalstr = 'T &F Invoice Number,Reference Number, TO,Author,Title,Indian ISBN,UMC,Orignal Price In Pounds,List Price(INR),PrintRun,Size in inches,Pages,Insert,Text Color,Cover Color,Cover Paper,Text Paper,Paper Insert,Binding,Lamination,Packaging instruction,Origination,Customer Name,Delivery Date,Special Instruction,Extras,Payment Terms  \n';
        String attName = 'PrintOrders_ISBN.csv'; 
        List<Print_Order_Item__c> PrintOrderItems =new List<Print_Order_Item__c>([SELECT Print_Order__r.Name,Print_Order__r.Printer__r.Name,Customer_Quote__c,OpportunityProductId__c,Gratis__c,Indian_Isbn__c,Reference_Number__c,Agreed_Price_Per_Copy__c,Binding__c,Cover_Color__c, 
                                                                                  Id,Impression__c,Inserts__c,Insert_Color__c,Print_Order__r.Printer__c,
                                                                                  MRP__c,Printed_Pages__c,Paper_Type_GSM__c,Print_Order__r.Customer__r.Name,ISBN__c,IsDeleted,List_Price_GBP__c,List_Price_INR__c,
                                                                                  Name,Origination__c,Pages__c,Paper_Cover__c,Paper_Insert__c,Paper_Text__c,Print_Order__r.isPoUploaded__c,
                                                                                  Version_Type__c,Product__r.Productcode,Print_Order__c,Print_Run__c,Product__c,Size_in_inches__c,Text_Color__c,Print_Order__r.Delivery_Date__c,
                                                                                  Print_Order__r.Invoice_Number__c,Print_Order__r.Customer__c,Print_Order__r.Packing_Instructions__c,
                                                                                  Print_Order__r.Payment_Terms__c,Print_Order__r.Reference_Number__c,Print_Order__r.Special_Instructions__c,Author__c,
                                                                                  extras__c,lamination__c,Title__c,Print_Order__r.TO__c,Total_UMC__c,UMC__c FROM Print_Order_Item__c where Print_Order__c=:parentIds[0]]);
        if(!PrintOrderItems[0].Print_Order__r.isPoUploaded__c && PrintOrderItems[0].Print_Order__r.Delivery_Date__c!=null){
            set<Id> AccountIDSet=new set<Id>();
            set<Id> contactIdSet=new set<Id>();
            set<Id> userIdset=new set<Id>();
            for (Print_Order_Item__c PrintorderRec :PrintOrderItems )
            {
                AccountIDSet.add(PrintorderRec.Print_Order__r.printer__c);
                mapofIndianIsbn.put(PrintorderRec.Indian_Isbn__c,PrintorderRec);
                string recordString = '"'+PrintorderRec.Print_Order__r.Invoice_Number__c+'","'+PrintorderRec.Reference_Number__c+'","'+PrintorderRec.Print_Order__r.Printer__r.Name+'","'+PrintorderRec.Author__c+'","'+PrintorderRec.Title__c+'","'+PrintorderRec.Indian_Isbn__c+'","'+PrintorderRec.UMC__c+'","'+PrintorderRec.List_Price_GBP__c+'","'+PrintorderRec.MRP__c+'","'+PrintorderRec.Print_Run__c+'","'+PrintorderRec.Size_in_inches__c+'","'+PrintorderRec.Pages__c+'","'+PrintorderRec.Inserts__c+'","'+PrintorderRec.Text_Color__c+'","'+PrintorderRec.Cover_Color__c+'","'+PrintorderRec.Paper_Cover__c+'","'+PrintorderRec.Paper_Text__c+'","'+PrintorderRec.Paper_Insert__c+'","'+PrintorderRec.Binding__c+'","'+PrintorderRec.Lamination__c+'","'+PrintorderRec.Print_Order__r.Packing_Instructions__c+'","'+PrintorderRec.Origination__c+'","'+PrintorderRec.Print_Order__r.Customer__r.Name+'","'+PrintorderRec.Print_Order__r.Delivery_Date__c+'","'+PrintorderRec.Print_Order__r.Special_Instructions__c+'","'+PrintorderRec.Extras__c+'","'+PrintorderRec.Print_Order__r.Payment_Terms__c+'"\n';
                finalstr = finalstr +recordString;
            }
            for(Contact cc:[select id from Contact where Accountid in:AccountIDSet]){
                contactIdSet.add(cc.id);
            }
            if(contactIdSet.size()>0){
                system.debug('#####'+contactIdSet);
            for(user u: [select id,contactid from user where  contactid in:contactIdSet]){
                userIdset.add(u.id);
            }
            }
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage> ();
            PageReference pdf;
            if(PrintOrderItems.size()>1){
                pdf = Page.IR_MultiRecPO;
            }else{
                pdf= Page.IR_PDF_PO;
            }
            // add parent id to the parameters for standardcontroller
            
            Id parentId=parentIds[0];
            pdf.getParameters().put('id',parentId);
            Attachment attach = new Attachment();
            Blob body;
            try {
                body = pdf.getContent();
            } catch (VisualforceException e) {
                body = Blob.valueOf('Some Text');
            }
            //Insert in file Object
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
            conVer.PathOnClient = 'Purchase_Order.pdf'; // The files name, extension is very important here which will help the file in preview.
            conVer.Title = 'Purchase_Order.pdf'; // Display name of the files
            conVer.VersionData =body; // converting your binary string to Blog
            insert conVer;    //Insert ContentVersion
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
            //create ContentDocumentLink  record 
            ContentDocumentLink conDocLink = New ContentDocumentLink();
            conDocLink.LinkedEntityId =parentIds[0] ; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
            conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
            conDocLink.shareType = 'V';
            conDocLink.visibility='AllUsers';
            insert conDocLink;
            //Insert Second Attachment
            ContentVersion conVercsv = new ContentVersion();
            conVercsv.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
            conVercsv.PathOnClient = 'PurchaseOrder.csv'; // The files name, extension is very important here which will help the file in preview.
            conVercsv.Title = 'PurchaseOrder.csv'; // Display name of the files
            conVercsv.VersionData =Blob.valueOf(finalstr); // converting your binary string to Blog
            insert conVercsv;    //Insert ContentVersion
            Id conDoccsv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVercsv.Id].ContentDocumentId;
            //create ContentDocumentLink  record 
            ContentDocumentLink conDocLinkscv = New ContentDocumentLink();
            conDocLinkscv.LinkedEntityId =parentId; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
            conDocLinkscv.ContentDocumentId = conDoccsv;  //ContentDocumentId Id from ContentVersion
            conDocLinkscv.shareType = 'V';
            conDocLinkscv.visibility='AllUsers';

            insert conDocLinkscv;
            // Create the email attachment    
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(attName);
            efa.setBody(Blob.valueOf(finalstr));
            // Second Attachment
            Messaging.EmailFileAttachment efa2 = new Messaging.EmailFileAttachment();
            efa2.setFileName('Purchaceorder.pdf');
            efa2.setBody(body);
            
            // Define the email
            for(User printeruseer:[Select id,email,profile.name from user where id in:userIdset]){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
                email.setSubject(subject);
                email.setToAddresses(new string[] {printeruseer.Email});
                email.setPlainTextBody(bodycsv); 
                // Attach file using setFileAttachments function
                email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa,efa2});
                // Sends the email
                mails.add(email);
            }   
            Messaging.SendEmailResult[] sentEmails;
            //Enable in Prod
            sentEmails=Messaging.sendEmail(mails);
            System.debug('#list of mails added#'+mails);
            system.debug('#Result of mail sent#'+sentEmails);
            
            //Make Record Read Only
            Id PrintOrderRecordTypeId = Schema.SObjectType.Print_Order__c.getRecordTypeInfosByName().get('Print Order With PO').getRecordTypeId();        
            Print_Order__c Printorderobj=new Print_Order__c();
            printorderobj.id=parentId;
            printorderobj.RecordTypeId=PrintOrderRecordTypeId;
            printorderobj.isPoUploaded__c=true;
            update printorderobj;
            Print_Order__c obj=[Select id,Order__c from Print_Order__c where id=:parentId];
            List<Print_Order__c> Print_Orderlist=new List<Print_Order__c> ();
            List<Print_Order__c> Print_OrderPoUploadedlist=new List<Print_Order__c> ();
            Print_Orderlist=[Select id,Order__c,isPoUploaded__c from Print_Order__c where Order__c=:obj.Order__c];
            for(Print_Order__c ponj:Print_Orderlist){
                if(ponj.isPoUploaded__c==true){
                    Print_OrderPoUploadedlist.add(ponj);
                }
            }
            Order ordobj=new order();
            ordobj.id=obj.Order__c;
            ordobj.Order_Status__c='Placed';
            if(Print_Orderlist.size()==Print_OrderPoUploadedlist.size()){
                update ordobj;
            }
        }
        List<Product2> updatedlistofProduct=new List<Product2>();
        List<PricebookEntry> pbeList = new List<PricebookEntry>();
		map<string,decimal> mapprodmrp=new map<string,decimal>();
         Pricebook2 pb=new Pricebook2();
        if(!Test.isRunningTest())
        {   
            pb = [select ID,Name from Pricebook2 where IsActive = TRUE and name ='T&F India Pricebook'];
        }
        for(product2 objprod:[select id,Last_UMC_Popular_Formats__c,Last_UMC_Version_Type__c,Last_UMC_Format_Height_mm__c,Last_UMC_Format_Width_mm__c,Last_UMC_Text_Colour__c,
                              UMC__c,Date_of_Last_UMC__c,Version_Type__c,Last_UMC_Paper_Type__c	,Last_UMC_Quantity__c,Last_UMC_Customer_Quote__c,Insert__c
                              ,Cover_color__c,Insert_Color__c,Insert_Paper__c,Cover_Paper__c,Extras__c,Printer_Name__c,Supply_Date__c,Lamination__c,IsActive,
                              ProductCode,Year_of_Print__c from product2 where productcode in :mapofIndianIsbn.keyset()]){
                                      mapprodmrp.put(objprod.Id,mapofIndianIsbn.get(objprod.productcode).Mrp__c);
                                     // pbeList.add( new PricebookEntry( Pricebook2Id = pb.Id, Product2Id=objprod.Id, UnitPrice =mapofIndianIsbn.get(objprod.productcode).Mrp__c, IsActive = objprod.IsActive, UseStandardPrice = FALSE));
                                  if(mapofIndianIsbn.get(objprod.productcode).Customer_Quote__c !=null){
                                      objprod.Last_UMC_Customer_Quote__c=mapofIndianIsbn.get(objprod.productcode).Customer_Quote__c ;
                                  }                                
                                  if(mapofIndianIsbn.get(objprod.productcode).Size_in_inches__c !=null){
                                      objprod.Last_UMC_Popular_Formats__c=mapofIndianIsbn.get(objprod.productcode).Size_in_inches__c;
                                  } 
                                  
                                  if(mapofIndianIsbn.get(objprod.productcode).Print_Run__c !=null){
                                      objprod.Last_UMC_Quantity__c=mapofIndianIsbn.get(objprod.productcode).Print_Run__c;
                                  } 	
                                  
                                  if(mapofIndianIsbn.get(objprod.productcode).UMC__c !=null){
                                      objprod.UMC__c=mapofIndianIsbn.get(objprod.productcode).UMC__c;
                                  }
                                  
                                  if(mapofIndianIsbn.get(objprod.productcode).Text_Color__c !=null){
                                      objprod.Last_UMC_Text_Colour__c=mapofIndianIsbn.get(objprod.productcode).Text_Color__c;
                                  } 
                                  
                                  if(mapofIndianIsbn.get(objprod.productcode).Paper_Text__c !=null){
                                      objprod.Last_UMC_Paper_Type__c=mapofIndianIsbn.get(objprod.productcode).Paper_Text__c;
                                  }
                                  
                                  if(mapofIndianIsbn.get(objprod.productcode).Inserts__c !=null){
                                      objprod.Insert__c=string.valueof(mapofIndianIsbn.get(objprod.productcode).Inserts__c);
                                  } 
                                  
                                  if(mapofIndianIsbn.get(objprod.productcode).Insert_Color__c !=null){
                                      objprod.Insert_Color__c=mapofIndianIsbn.get(objprod.productcode).Insert_Color__c;
                                  }
                                  
                                  if(mapofIndianIsbn.get(objprod.productcode).Paper_Insert__c !=null){
                                      objprod.Insert_Paper__c=mapofIndianIsbn.get(objprod.productcode).Paper_Insert__c;
                                  } 
                                  
                                  if(mapofIndianIsbn.get(objprod.productcode).Cover_color__c !=null){
                                      objprod.Cover_color__c=mapofIndianIsbn.get(objprod.productcode).Cover_color__c;
                                  }
                                  
                                  if(mapofIndianIsbn.get(objprod.productcode).Paper_Cover__c !=null){
                                      objprod.Cover_Paper__c=mapofIndianIsbn.get(objprod.productcode).Paper_Cover__c;
                                  }
                                  
                                  if(mapofIndianIsbn.get(objprod.productcode).Print_Order__r.Name !=null){
                                      objprod.Printer_Name__c=mapofIndianIsbn.get(objprod.productcode).Print_Order__r.Printer__r.Name;
                                  }
                                  if(mapofIndianIsbn.get(objprod.productcode).Version_Type__c !=null){
                                      objprod.Last_UMC_Version_Type__c=mapofIndianIsbn.get(objprod.productcode).Version_Type__c ;
                                  } 
                                  
                                  updatedlistofProduct.add(objprod);
                              }
        for(PricebookEntry pbentry:[SELECT id, Pricebook2Id, Product2Id, UnitPrice FROM PricebookEntry where Pricebook2Id=:pb.id and Product2Id in:mapprodmrp.keyset()]){
            pbentry.unitprice=mapprodmrp.get(pbentry.Product2Id);
            pbeList.add(pbentry);
        }
        if(updatedlistofProduct.size()>0){
            update updatedlistofProduct; 
            update pbeList;
        }
    }
    
}