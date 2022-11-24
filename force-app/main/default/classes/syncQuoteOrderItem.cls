/**
* File Name: syncQuoteOrderItem
* Description : 
* @author :  Siddahant Tyagi
* Test class: 
* Test coverage : 
* */ 
public with sharing class syncQuoteOrderItem implements TriggerInterface_SBQQ_QuoteLine.Runnable{
    
    public void run(TriggerInterface_SBQQ_QuoteLine.Trig trig){
        if ((trig.isAfter && trig.isInsert)||(trig.isAfter && trig.isUpdate)||(trig.isAfter && trig.isDelete)){
            Map<Id,Set<Id>> OppQliProductsIdsMap = new Map<Id,Set<Id>>();
            Map<Id,Set<Id>> OppOrderIdsMap = new Map<Id,Set<Id>>();
            Map<Id,Set<Id>> OppOrderLineProductsIdsMap = new Map<Id,Set<Id>>();
            Set<Id> OppIdToUpdate = new Set<Id>();
            Set<Id> QuoteIds = new Set<Id>();
            for(SBQQ__QuoteLine__c qli : trig.newList){
                if(qli.SBQQ__Product__c != null && qli.SBQQ__Quote__c != null){
                    QuoteIds.add(qli.SBQQ__Quote__c);
                }
            }
            if(QuoteIds.size()>0){
                List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>([Select id,SBQQ__Opportunity2__c,(Select SBQQ__Product__c from SBQQ__LineItems__r) from SBQQ__Quote__c Where SBQQ__Primary__c = TRUE and Id IN : QuoteIds]);
                for(SBQQ__Quote__c qte : quoteList){
                    Set<Id> prodsIds = new Set<Id>();
                    for(SBQQ__QuoteLine__c qli : qte.SBQQ__LineItems__r){
                        if(qli.SBQQ__Product__c != null){
                            prodsIds.add(qli.SBQQ__Product__c);
                        }
                    }
                    if(prodsIds.size()>0 && qte.SBQQ__Opportunity2__c != null){
                        OppQliProductsIdsMap.put(qte.SBQQ__Opportunity2__c,prodsIds); 
                    }
                }
            }
            if(OppQliProductsIdsMap.size()>0){
                List<Order> orderList = new List<Order>([select id,opportunity.Id,(select Product2.Id from OrderItems) from order where opportunity.SBQQ__Ordered__c = true and Opportunity.Id IN : OppQliProductsIdsMap.keyset()]);
                for(Order ord : orderList){
                    Set<Id> OrderIds = new Set<Id>();
                    if(OppOrderIdsMap.containsKey(ord.opportunity.Id)){
                        OrderIds = OppOrderIdsMap.get(ord.opportunity.Id);
                        OrderIds.add(ord.Id);
                    }
                    else{
                        OrderIds.add(ord.Id);  
                    }
                    OppOrderIdsMap.put(ord.opportunity.Id,OrderIds);
                    Set<Id> prodsIds = new Set<Id>();
                    for(OrderItem ordItm : ord.OrderItems){
                        if(ordItm.Product2.Id != null){
                            prodsIds.add(ordItm.Product2.Id);
                        } 
                    }
                    if(prodsIds.size()>0 && ord.opportunity.Id != null){
                        OppOrderLineProductsIdsMap.put(ord.opportunity.Id,prodsIds); 
                    }
                }
            }
            if(OppQliProductsIdsMap.size()>0 && OppOrderLineProductsIdsMap.size()>0){
                for(Id oppId : OppQliProductsIdsMap.keyset()){
                    if(OppOrderLineProductsIdsMap.containsKey(oppId)){
                        for(Id qliProdId : OppQliProductsIdsMap.get(oppId)){
                            Boolean prodFound = False;
                            for(Id oliProdId : OppOrderLineProductsIdsMap.get(oppId)){
                                if(qliProdId == oliProdId){
                                    prodFound = True;
                                }
                            }
                            if(prodFound == False || (OppQliProductsIdsMap.get(oppId).size() != OppOrderLineProductsIdsMap.get(oppId).size())){
                                OppIdToUpdate.add(oppId);
                            }
                        }
                    } 
                }
            }
            if(OppIdToUpdate.size()>0){
                List<Id> orderToDeleteIds = new List<Id>();
                List<Opportunity> oppToUpdate = new List<Opportunity>();
                for(Id oppId : OppIdToUpdate){
                    if(OppOrderIdsMap.containsKey(oppId)){
                        orderToDeleteIds.addAll(OppOrderIdsMap.get(oppId));
                    }
                    Opportunity opp = new Opportunity();
                    opp.Id = oppId;
                    opp.SBQQ__Ordered__c = False;
                    oppToUpdate.add(opp);
                    
                }
                if(orderToDeleteIds.size()>0){
                    Database.delete(orderToDeleteIds);
                }
                if(oppToUpdate.size()>0){
                    Update oppToUpdate;
                }
            }
        }
    }
}