public with sharing class TF_OrderChannelAssignment implements TriggerInterface_Order.Runnable{
   
    public void run(TriggerInterface_Order.Trig trig){
        if (trig.isBefore && trig.isInsert){
            Set<Id> oppIds = new Set<Id>();
            Map<Id,String> oppOrderChannelMap = new Map<Id,String>();
            for(Order odr : trig.newList){
                if(odr.OpportunityId != null){
                    oppIds.add(odr.OpportunityId); 
                }
            }
            if(oppIds.size()>0){
                List<Opportunity> oppList = new List<Opportunity>();
                oppList = [select id,(select id,Quote_Type__c from SBQQ__Quotes2__r where SBQQ__Primary__c = true) from Opportunity where Id IN : oppIds];
                for(opportunity opp : oppList){
                    if(opp.SBQQ__Quotes2__r.size()>0){
                        if(opp.SBQQ__Quotes2__r[0].Quote_Type__c == 'Direct Sale'){
                            oppOrderChannelMap.put(opp.Id, 'EBK DIRECT SALES');
                        }
                        if(opp.SBQQ__Quotes2__r[0].Quote_Type__c == 'Agent eBook orders'){
                            oppOrderChannelMap.put(opp.Id, 'EBK AGENT SALES');
                        }
                    }
                }
                for(Order odr : trig.newList){
                    if(odr.OpportunityId != null){
                        if(oppOrderChannelMap.containsKey(odr.OpportunityId)){
                           odr.Order_Channel__c = oppOrderChannelMap.get(odr.OpportunityId);
                        }
                    }
                }
            }
        }
    }
}