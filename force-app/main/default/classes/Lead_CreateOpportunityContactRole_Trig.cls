/*
Modified by: Matthew Smith - 31.03.2020 - 01484071 - Replacing US/CIS Opp Record Type with 'T&F Global Corporate / Special Sales Opportunity' 
*/
public with sharing class Lead_CreateOpportunityContactRole_Trig implements TriggerInterface_Lead.Runnable {
    public void run(TriggerInterface_Lead.Trig trig) 
    {
        System.Debug('Lead: '+trig.newList);
        Map<Id,Id> opportunityIds = new Map<Id,Id>();
        List<Id> contactIds = new List<Id>();
        List<Informa_Contact_Role__c> iocr = new List<Informa_Contact_Role__c> ();
        for(Lead lead: trig.newList)
        {
            if(lead.IsConverted){
                opportunityIds.put(lead.Id,lead.ConvertedOpportunityId);
            }      
        }
        if(opportunityIds !=null && opportunityIds.size()>0){
            Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>([Select Id,RecordTypeId from Opportunity where id=:opportunityIds.values()]);
            for(Id leadId : opportunityIds.keySet()){
                Lead lead = trig.newMap.get(leadId);
                if( oppMap.get(lead.ConvertedOpportunityId).RecordTypeId =='0122X000000KDOZQA4') //T&F - Global Corporate / Special Sales Opportunity
                {
                    String RecordtypeId = trig.mapRtIdsToParams.get(lead.Recordtypeid).get('ICR_RT');
                    iocr.add(new Informa_Contact_Role__c(Opportunity__c =lead.ConvertedOpportunityId,Contact__c =lead.ConvertedContactId,Primary_Contact__c = true,Contact_Role_s__c = 'Billing;Delivery',RecordtypeId=RecordtypeId));
                }
                if(iocr !=null && iocr.size() >0)
                    insert iocr;
            }
        }
    }
   
    
}