/**************************************************
* Created by Sidhant on 9/20/2019.
* Tested by: zTest_Ir_CreateSalesOrders @ 86%
* Notes: 
* The logic below will  look for Print Order Records. and
* Opens the record detail for Print Order with RelatedList.
**************************************************/
public class IR_CreateSalesOrders {
    Public Set<Id> oppIdSet=new Set<Id>();
    Public List<OrderItem> orderitemList=new List<Orderitem>();
    public List<Object> reversed = new List<Object>();
    Public Map<String, OpportunityLineItem> MapOfOppDistributorIdOpportunityLineItem= new Map<String,OpportunityLineItem>();
    Public List<Order> SalesOrderList=new List<Order>();
    Public Map<Id, Id> MapDistyributorOrderId = new Map<Id,Id>();
    Public Map<String, Id> MapOrderId = new Map<String,Id>();
    public List<String> ListOfMapOfOppDistributorIdPriceBookMapIds=new List<String>();
    Public List<OrderItem> OrderLineIteamToInsert=new List<OrderItem>();
    List<String> orderingList = new List<String>();
    
    Map<String,OrderItem> ReferenceNoSortedmap = new Map<String,OrderItem>();
    Public Integer i;
    public void CreateOrder(List<opportunity> OppList){
        System.debug('In Update');
        for(Opportunity OppObj:OppList){
            System.debug('In Update Opportunity Instance:'+OppObj);
            oppIdSet.add(OppObj.Id);	
        } 
        if(!OppIdSet.isEmpty()){
            
            for(OpportunityLineItem OpportunityLineItemObj:[Select Opportunity.Account.Billing_ZIP__c,Opportunity.Account.Billing_City__c,Opportunity.Account.Billing_Country__c,Opportunity.Account.Billing_State__c,Opportunity.Account.Billing_Street__c, Quantity,Opportunity.Account.BillingStreet,Opportunity.Account.BillingCity,Opportunity.Account.BillingState
                                                            ,Opportunity.Account.BillingPostalCode,Opportunity.Account.BillingCountry,Opportunity.Account.ShippingStreet,
                                                            Opportunity.Total_Approved_Customer_Quote_GBP__c,Opportunity.Account.ShippingCity,Opportunity.Account.ShippingState,Opportunity.Account.ShippingPostalCode,
                                                            Opportunity.Account.ShippingCountry,Opportunity.Accountid,PricebookEntry.Pricebook2id,PricebookEntry.CurrencyIsoCode ,UnitPrice ,
                                                            Product2Id,PricebookEntryId,id,Distributor__c,Reprint_Eligibility__c,Opportunity.Pricebook2id,OpportunityId 
                                                            from OpportunityLineItem where Distributor__c!=null and Reprint_Eligibility__c!='Fail' and Is_Approved__c=true and OpportunityId  in:OppIdSet])
            {
                string str=String.valueof(OpportunityLineItemObj.OpportunityId+'#'+OpportunityLineItemObj.Distributor__c);
                MapOfOppDistributorIdOpportunityLineItem.put(str,OpportunityLineItemObj);  
            }
        }
        if(!MapOfOppDistributorIdOpportunityLineItem.isEmpty()){
            ListOfMapOfOppDistributorIdPriceBookMapIds = new List<String>(MapOfOppDistributorIdOpportunityLineItem.keyset());
            for(Integer i=0;i<ListOfMapOfOppDistributorIdPriceBookMapIds.size();i++){
                Order InsertOrder = new Order();
                InsertOrder.status='Draft';
                InsertOrder.Order_Status__c='Pending';
                InsertOrder.Total_Approved_Customer_Quote__c=MapOfOppDistributorIdOpportunityLineItem.get(ListOfMapOfOppDistributorIdPriceBookMapIds[i]).Opportunity.Total_Approved_Customer_Quote_GBP__c;
                InsertOrder.AccountId=MapOfOppDistributorIdOpportunityLineItem.get(ListOfMapOfOppDistributorIdPriceBookMapIds[i]).Opportunity.Accountid;
                InsertOrder.Pricebook2Id=MapOfOppDistributorIdOpportunityLineItem.get(ListOfMapOfOppDistributorIdPriceBookMapIds[i]).PricebookEntry.Pricebook2id;
                InsertOrder.OpportunityId=MapOfOppDistributorIdOpportunityLineItem.get(ListOfMapOfOppDistributorIdPriceBookMapIds[i]).OpportunityId;
                InsertOrder.EffectiveDate = Date.today();
                system.debug('^^^^^^^^^^^'+MapOfOppDistributorIdOpportunityLineItem.get(ListOfMapOfOppDistributorIdPriceBookMapIds[i]).Opportunity.Account.BillingCity);
                InsertOrder.BillingCity=MapOfOppDistributorIdOpportunityLineItem.get(ListOfMapOfOppDistributorIdPriceBookMapIds[i]).Opportunity.Account.Billing_City__c;
                InsertOrder.BillingCountry=MapOfOppDistributorIdOpportunityLineItem.get(ListOfMapOfOppDistributorIdPriceBookMapIds[i]).Opportunity.Account.Billing_Country__c;
                InsertOrder.BillingState=MapOfOppDistributorIdOpportunityLineItem.get(ListOfMapOfOppDistributorIdPriceBookMapIds[i]).Opportunity.Account.Billing_State__c;
                InsertOrder.BillingPostalCode=MapOfOppDistributorIdOpportunityLineItem.get(ListOfMapOfOppDistributorIdPriceBookMapIds[i]).Opportunity.Account.Billing_ZIP__c;
                InsertOrder.BillingStreet=MapOfOppDistributorIdOpportunityLineItem.get(ListOfMapOfOppDistributorIdPriceBookMapIds[i]).Opportunity.Account.Billing_Street__c;
                InsertOrder.ShippingCity=MapOfOppDistributorIdOpportunityLineItem.get(ListOfMapOfOppDistributorIdPriceBookMapIds[i]).Opportunity.Account.ShippingCity;
                InsertOrder.ShippingCountry=MapOfOppDistributorIdOpportunityLineItem.get(ListOfMapOfOppDistributorIdPriceBookMapIds[i]).Opportunity.Account.ShippingCountry;
                InsertOrder.ShippingState=MapOfOppDistributorIdOpportunityLineItem.get(ListOfMapOfOppDistributorIdPriceBookMapIds[i]).Opportunity.Account.ShippingState;
                InsertOrder.ShippingStreet=MapOfOppDistributorIdOpportunityLineItem.get(ListOfMapOfOppDistributorIdPriceBookMapIds[i]).Opportunity.Account.ShippingStreet;
                InsertOrder.ShippingPostalCode=MapOfOppDistributorIdOpportunityLineItem.get(ListOfMapOfOppDistributorIdPriceBookMapIds[i]).Opportunity.Account.ShippingPostalCode;
                InsertOrder.CurrencyIsoCode=MapOfOppDistributorIdOpportunityLineItem.get(ListOfMapOfOppDistributorIdPriceBookMapIds[i]).PricebookEntry.CurrencyIsoCode;
                MapOrderId.put(ListOfMapOfOppDistributorIdPriceBookMapIds[i],MapOfOppDistributorIdOpportunityLineItem.get(ListOfMapOfOppDistributorIdPriceBookMapIds[i]).Distributor__c);
                SalesOrderList.add(InsertOrder);
                
            }
        }
        // Inserting Oreder iteam Releated To an Order
        insert SalesOrderList;
        for(Integer j=0;j<SalesOrderList.size();j++){
            MapDistyributorOrderId.put(MapOrderId.get(ListOfMapOfOppDistributorIdPriceBookMapIds[j]),SalesOrderList[j].Id);
        }
        orderitemList=[select id,Reference_Number__c,OrderId from orderitem where(order.recordtype.Name='IR_Orders_Record_Type' or order.recordtype.Name='IR_Orders_Read_Only_Record_Type') and Reference_Number__c!=null  order by createddate desc limit 1];
        if(orderitemList.size()>0){
            String str = orderitemList[0].Reference_Number__c;
            List<String> res = str.split('-', 3);
            i=Integer.valueof(res[1]);
        }else{
            i=1;
        }     
        for(OpportunityLineItem OliObj:[Select  Quantity ,UnitPrice,Product2Id ,PricebookEntryId,Reprint_Eligibility__c,id,Distributor__c,Opportunity.Pricebook2id,OpportunityId  from OpportunityLineItem where  Distributor__c!=null and Is_Approved__c=true and  OpportunityId  in:OppIdSet]){
            i++;
            OrderItem newOi = new OrderItem(OrderId =MapDistyributorOrderId.get(OliObj.Distributor__c),
                                            //Printer__c =OliObj.Distributor__c,
                                            Quantity =OliObj.Quantity,
                                            PricebookEntryId =OliObj.PricebookEntryId,
                                            UnitPrice=OliObj.UnitPrice,
                                            product2id=oliobj.product2id,
                                            OpportunityProductId__c=OliObj.Id,
                                            Reference_Number__c='EPZ-'+String.valueOf(i)+'-'+String.valueOf(System.Today().year())
                                           );    
            ReferenceNoSortedmap.put(newOi.Reference_Number__c,newOi);
            
        }
        orderingList.addAll(ReferenceNoSortedmap.keyset());
        //Sort the List
        orderingList.sort();
        for(Integer i = orderingList.size()-1; i>=0;i--){
            OrderLineIteamToInsert.add(ReferenceNoSortedmap.get(orderingList[i]));    
        }
        // Inserting Oreder iteam Releated To an Order
        Database.SaveResult[] OrderLineIteamToInsert = Database.insert(OrderLineIteamToInsert);
    }
    
}