/**************************************************
* Created by Sidhant on 9/20/2019.
* Tested by: TestClassName @ 86%
* Notes: 
* The logic below will  look for Print Order Records. and
* Opens the record detail for Print Order with RelatedList.
**************************************************/
    public class IR_CreatePrintOrder {
    public map<id,List<String>> refIdmap=new map<id,List<String>>();
    public map<id,Print_Order__c> OliidPrintitem=new map<id,Print_Order__c>();
    public List<OpportunityLineItem> updateOli=new List<OpportunityLineItem>();
    public map<Id,string> olidmap=new map<Id,string>();
    public map<string,string> oppdistr=new map<string,string>();
    public List<string> ProductIdsList=new List<String>();
    public map<String,Decimal> prodIdPriceGbpmap=new map<String,Decimal>();
    Public set<Id> oliset=new set<Id>();
    public map<id,OpportunityLineItem> mapidoli=new map<id,OpportunityLineItem>();
    Public Map<String, Orderitem> MapOfOppIdOrderlineitem= new Map<String,Orderitem>();
    Public List<String> ListOfMapOfPrinterOrderIdMapIds=new  List<String>();
    Public List<Print_Order__c> PrintOrderlist=new List<Print_Order__c>();
    Public List<Print_Order_Item__c> PrintOrderItemlist=new List<Print_Order_Item__c>();
    public map<Id,Print_Order__c> PrinterPrintorderIdmap=new map<Id,Print_Order__c>();
    public List<Print_Order__c> ReferenceNoUpdateList=new List<Print_Order__c>();
    public Id IR_OrdersRecordType = Schema.SObjectType.Order.getRecordTypeInfosByName().get('IR_Orders_Read_Only_Record_Type').getRecordTypeId();
   		public id orderid;
        public void CreatePrintOrder(List<id> OrderSet) {
        
        if(OrderSet.size()>0){
            for(Orderitem orderobj	:[select id,OpportunityProductId__c,Order.Distributor_Invoice_No__c,Order.BillingAddress,Order.BillingPostalCode ,Order.BillingStreet,Order.BillingCity,Order.BillingState,Order.BillingCountry,order.Delivery_Date__c,OrderId,Order.Packaging_Instruction__c,order.Special_Instruction__c,printer__c from Orderitem where id in:OrderSet])
            {
                string str=String.valueof(orderobj.OrderId+'#'+orderobj.Printer__c);
                MapOfOppIdOrderlineitem.put(str,orderobj);  
                 olidmap.put(orderobj.OpportunityProductId__c,str);
                orderid=orderobj.OrderId;
            }
            system.debug('$$$$$'+MapOfOppIdOrderlineitem.size());
            if(!MapOfOppIdOrderlineitem.isEmpty()){
                for(OpportunityLineItem oliobj:[select id,Distributor__r.Id from OpportunityLineItem where id in :olidmap.keyset()]){
                    oppdistr.put(olidmap.get(oliobj.Id),oliobj.Distributor__r.Id);
                }
                List<String> ListOfMapOfOppDistributorIdMapIds = new List<String>(MapOfOppIdOrderlineitem.keyset());
                for(Integer i=0;i<ListOfMapOfOppDistributorIdMapIds.size();i++){
                    Print_Order__c PrintOrderObj=new Print_Order__c();
                    PrintOrderObj.Customer__c=oppdistr.get(ListOfMapOfOppDistributorIdMapIds[i]);
                    PrintOrderObj.Printer__c=MapOfOppIdOrderlineitem.get(ListOfMapOfOppDistributorIdMapIds[i]).Printer__c;
                    PrintOrderObj.CurrencyIsoCode='GBP'; 
                    PrintOrderObj.Order__c=MapOfOppIdOrderlineitem.get(ListOfMapOfOppDistributorIdMapIds[i]).orderId;
                    PrintOrderObj.Packing_Instructions__c=MapOfOppIdOrderlineitem.get(ListOfMapOfOppDistributorIdMapIds[i]).order.Packaging_Instruction__c;
                    PrintOrderObj.Special_Instructions__c=MapOfOppIdOrderlineitem.get(ListOfMapOfOppDistributorIdMapIds[i]).order.Special_Instruction__c;
                    PrintOrderObj.Status__c='Print Order Created';	
                    PrintOrderObj.Invoice_Number__c=MapOfOppIdOrderlineitem.get(ListOfMapOfOppDistributorIdMapIds[i]).Order.Distributor_Invoice_No__c;
                    String billingStreet=MapOfOppIdOrderlineitem.get(ListOfMapOfOppDistributorIdMapIds[i]).Order.BillingStreet;
                    billingStreet=(String.isBlank(billingStreet)? '' : billingStreet);
                    String billingcity=MapOfOppIdOrderlineitem.get(ListOfMapOfOppDistributorIdMapIds[i]).Order.BillingCity;
                    billingcity=(String.isBlank(BillingCity)? '' : +','+BillingCity);
                    
                    string billingstate=MapOfOppIdOrderlineitem.get(ListOfMapOfOppDistributorIdMapIds[i]).Order.BillingState;
                    billingstate=(String.isBlank(billingstate)? '' : +','+billingstate);
                    
                    string billingcountry=MapOfOppIdOrderlineitem.get(ListOfMapOfOppDistributorIdMapIds[i]).Order.BillingCountry;
                    billingcountry=(String.isBlank(billingcountry)? '' : +','+billingcountry);
                    
                    string BillingPostalCode =MapOfOppIdOrderlineitem.get(ListOfMapOfOppDistributorIdMapIds[i]).Order.BillingPostalCode ;
                    BillingPostalCode =(String.isBlank(BillingPostalCode )? '' : +','+BillingPostalCode );
                    

                    
                    String address= billingStreet+billingcity+billingstate+billingcountry+BillingPostalCode ;
                    PrintOrderObj.TO__c=address;
                    PrintOrderObj.Delivery_Date__c=MapOfOppIdOrderlineitem.get(ListOfMapOfOppDistributorIdMapIds[i]).order.Delivery_Date__c;
                    PrintOrderlist.add(PrintOrderObj);
                }
            }
            insert PrintOrderlist;
            if(PrintOrderlist.size()>0){
                List<Orderitem> orlist=[select id,Order_Item_Status__c,OrderId from orderitem where  id in:OrderSet];
                List<Orderitem> updateList=new List<Orderitem>();
                for(Orderitem oliobj:orlist){
                    oliobj.Order_Item_Status__c='Print Order Created';
                    updateList.add(oliobj);
                }
                update updateList;
                Order orbj=new Order();
                orbj.Id=orlist[0].OrderId;
                orbj.Order_Status__c='Print Order Created';
                update orbj;
               /* List<OrderItem> AllOrderRelatedTo =[select id from orderitem where orderid = :orlist[0].OrderId];
                List<OrderItem> ApprovedOrderitem =[select id from orderitem where Order_Item_Status__c='Print Order Created' and orderid = :orlist[0].OrderId];
                if(AllOrderRelatedTo.size()==ApprovedOrderitem.size()){
                    Order orobj=new Order();
                    orobj.Id=orlist[0].OrderId;
                    orobj.Order_Status__c='Placed';
                    update orobj;
                }*/
            }
            for(Print_Order__c poObj:[Select id,Printer__c,Invoice_Number__c,Customer__c from Print_Order__c where id in:PrintOrderlist]){
                PrinterPrintorderIdmap.put(poObj.Printer__c,poObj);
            }
            for(Orderitem orderobj:[select id,OpportunityProductId__c,printer__c,Reference_Number__c from orderitem where printer__c!=null and id in:OrderSet]){
                oliset.add(orderobj.OpportunityProductId__c);
            }
            //See if we can Add fields to order Line Items 
            for(OpportunityLineItem OliObj:[Select  Cover_color__c,Format_Height_mm__c,Lamination__c,Cover_Paper__c,Insert_Paper__c,Popular_Format__c,Product2.ProductCode,Format_Width_mm__c,Gratis__c,Product2.Cover_Paper__c,Product2.Cover_color__c,Product2.Insert__c,Product2.Insert_Color__c,Product2.Insert_Paper__c,Product2.Origination__c,
                                            Version_Type__c,Global_ISBN__c,Extras__c,Quantity,Required_Version_Type__c,Printed_Pages__c,Indian_Isbn__c,Extent__c,Binding_Type__c,Paper_Type_GSM__c,Paper_GSM__c ,MRP__c,Customer_Quote__c,Pages__c,Product2.Gratis__c,Text_Colour__c,Product2.Title__c,Product2.Author__c,Product2.Name,UMC__c ,UnitPrice,Product2Id ,PricebookEntryId,Reprint_Eligibility__c,id,Distributor__c,Opportunity.Pricebook2id,OpportunityId  from OpportunityLineItem where Id  in:oliset]){
                                                mapidoli.put(OliObj.id,OliObj);
                                                ProductIdsList.add(OliObj.Global_ISBN__c);
                                            }
            for(PricebookEntry pbiobj:[SELECT Name, Product2.Name,Product2id,UnitPrice, Product2.ProductCode, PriceBook2.Name from PriceBookEntry where currencyisocode='GBP' and product2.productcode in:ProductIdsList and pricebook2id='01s0Y00000832dD']){
                prodIdPriceGbpmap.put(pbiobj.Product2.productcode,pbiobj.UnitPrice);
            }
            
            for(Orderitem orderobj:[select id,OpportunityProductId__c,Product2Id,printer__c,Reference_Number__c from orderitem where printer__c!=null and id in:OrderSet order by Reference_Number__c desc]){
                Print_Order_Item__c PrintOrderItem=new Print_Order_Item__c();
                PrintOrderItem.CurrencyIsoCode='GBP';
                PrintOrderItem.Print_Order__c=PrinterPrintorderIdmap.get(orderobj.printer__c).id;
                PrintOrderItem.Name=mapidoli.get(orderobj.OpportunityProductId__c).Product2.ProductCode;
                PrintOrderItem.Title__c=mapidoli.get(orderobj.OpportunityProductId__c).Product2.Name;
                PrintOrderItem.Product__c=mapidoli.get(orderobj.OpportunityProductId__c).Product2Id;
                PrintOrderItem.UMC__c=mapidoli.get(orderobj.OpportunityProductId__c).UMC__c;
                PrintOrderItem.Binding__c=mapidoli.get(orderobj.OpportunityProductId__c).Required_Version_Type__c;
                PrintOrderItem.Lamination__c=mapidoli.get(orderobj.OpportunityProductId__c).Lamination__c;
                PrintOrderItem.Text_Color__c=mapidoli.get(orderobj.OpportunityProductId__c).Text_Colour__c;
                PrintOrderItem.Author__c=mapidoli.get(orderobj.OpportunityProductId__c).Product2.Author__c;
                PrintOrderItem.Pages__c=mapidoli.get(orderobj.OpportunityProductId__c).Extent__c; 
                PrintOrderItem.Printed_Pages__c=mapidoli.get(orderobj.OpportunityProductId__c).Extent__c;
                PrintOrderItem.Paper_Type_GSM__c=mapidoli.get(orderobj.OpportunityProductId__c).Paper_Type_GSM__c;
                PrintOrderItem.Paper_GSM__c=mapidoli.get(orderobj.OpportunityProductId__c).Paper_GSM__c;
                PrintOrderItem.Impression__c=mapidoli.get(orderobj.OpportunityProductId__c).Version_Type__c;
                PrintOrderItem.MRP__c=mapidoli.get(orderobj.OpportunityProductId__c).MRP__c	;
                PrintOrderItem.OpportunityProductId__c=mapidoli.get(orderobj.OpportunityProductId__c).Id;
                PrintOrderItem.Reference_Number__c=orderobj.Reference_Number__c;
                PrintOrderItem.Customer_Quote__c=mapidoli.get(orderobj.OpportunityProductId__c).Customer_Quote__c;
                PrintOrderItem.Indian_Isbn__c=mapidoli.get(orderobj.OpportunityProductId__c).Indian_Isbn__c;
                PrintOrderItem.Print_Run__c=mapidoli.get(orderobj.OpportunityProductId__c).Quantity;
                PrintOrderItem.Version_Type__c=mapidoli.get(orderobj.OpportunityProductId__c).Version_Type__c;
                PrintOrderItem.Cover_Color__c=mapidoli.get(orderobj.OpportunityProductId__c).Cover_color__c;
                PrintOrderItem.Format_Height_mm__c=mapidoli.get(orderobj.OpportunityProductId__c).Format_Height_mm__c;
                PrintOrderItem.Format_Width_mm__c=mapidoli.get(orderobj.OpportunityProductId__c).Format_Width_mm__c;
                PrintOrderItem.Inserts__c=String.valueof(mapidoli.get(orderobj.OpportunityProductId__c).Product2.Insert__c);
                PrintOrderItem.Insert_Color__c=mapidoli.get(orderobj.OpportunityProductId__c).Product2.Insert_Color__c;
                PrintOrderItem.Origination__c=mapidoli.get(orderobj.OpportunityProductId__c).Product2.Origination__c;
                PrintOrderitem.Total_UMC__c=Integer.valueOf(mapidoli.get(orderobj.OpportunityProductId__c).Quantity)*mapidoli.get(orderobj.OpportunityProductId__c).UMC__c;
                PrintOrderItem.List_Price_INR__c=mapidoli.get(orderobj.OpportunityProductId__c).MRP__c;
                PrintOrderItem.List_Price_GBP__c=String.valueof(prodIdPriceGbpmap.get(mapidoli.get(orderobj.OpportunityProductId__c).Global_ISBN__c));
                PrintOrderItem.Paper_Text__c=mapidoli.get(orderobj.OpportunityProductId__c).Paper_Type_GSM__c;
                PrintOrderItem.Paper_Cover__c=mapidoli.get(orderobj.OpportunityProductId__c).Cover_Paper__c;
                PrintOrderItem.Paper_Insert__c=mapidoli.get(orderobj.OpportunityProductId__c).Insert_Paper__c;
                PrintOrderItem.Size_in_inches__c=mapidoli.get(orderobj.OpportunityProductId__c).Popular_Format__c;
                PrintOrderItem.Gratis__c=mapidoli.get(orderobj.OpportunityProductId__c).Gratis__c;
		        PrintOrderItem.Orignal_Isbn__c=mapidoli.get(orderobj.OpportunityProductId__c).Global_ISBN__c; 
                PrintOrderItem.Extras__c=mapidoli.get(orderobj.OpportunityProductId__c).Extras__c; 

               
                PrintOrderItemlist.add(PrintOrderItem);
                OliidPrintitem.put(mapidoli.get(orderobj.OpportunityProductId__c).Id,PrinterPrintorderIdmap.get(orderobj.printer__c));
            }
            
            Database.SaveResult[] PrintOrderLineIteamToInsert = Database.insert(PrintOrderItemlist);
            for(OpportunityLineItem oppitem:[select id,Invoic_Number__c,Customer__c from OpportunityLineItem where id in:OliidPrintitem.keySet()]){
                oppitem.Invoic_Number__c=OliidPrintitem.get(oppitem.id).Invoice_Number__c;
                oppitem.Customer__c=OliidPrintitem.get(oppitem.id).Customer__c;
                updateOli.add(oppitem);
            }
            update updateOli;
            for(Print_Order_Item__c  printorderitem :PrintOrderItemlist){
                if(refIdmap.containsKey(printorderitem.Print_Order__c)) {
                    List<String> printorderIdList = refIdmap.get(printorderitem.Print_Order__c);
                    printorderIdList.add(printorderitem.Reference_Number__c);
                    refIdmap.put(printorderitem.Print_Order__c,printorderIdList);
                } else {
                    refIdmap.put(printorderitem.Print_Order__c, new List<String> { printorderitem.Reference_Number__c });
                }
            }
            for(Print_Order__c poobj:[Select id,Reference_Number__c from Print_Order__c where id  in:PrintOrderlist]){
                poobj.Reference_Number__c=refIdmap.get(poobj.id)[0]+'-'+refIdmap.get(poobj.id)[refIdmap.get(poobj.id).size()-1];
                ReferenceNoUpdateList.add(poobj);
            }
            update ReferenceNoUpdateList;
        }
        
    }
    
}