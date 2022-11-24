/*
** Tested by: zTEST_CAS.cls
**
** Modified by Jeff Lup - 2015.02.27 - Moved old class into this TrigClass
*/
public without sharing class CAS_CreateOppLineItem_Trig implements TriggerInterface_OLI.Runnable {
    public void run(TriggerInterface_OLI.Trig trig) {
        if (trig.isBefore && trig.isInsert) {
            // CAS - Course Opportunities & CAS - Blind Copy / Book Review Opportunities
            //Set<ID> casRecordTypes = new Set<ID>{'01260000000DXrWAAW','01260000000DXs4AAG'};
            
            // create a set of all of the unique opportunity ids passed to the trigger
            Set<ID> opportunities = new Set<ID>();
            for (OpportunityLineItem oli : trig.newList)
                opportunities.add(oli.opportunityId);
                
            // create a set of all of the unique pricebook entry ids that were passed to the trigger
            Set<ID> pbes = new Set<ID>();
            for (OpportunityLineItem oli : trig.newList)
                pbes.add(oli.PricebookEntryId);
                
            // fetch all of the pricebook entries so we can get the isbn of the product
            Map<Id, PricebookEntry> pbeMap = new Map<Id, PricebookEntry>([Select Product2.Id, Product2.ISBN__c From PricebookEntry Where Id IN :pbes]); 
            
            // create a set of all of the new isbns for the line items being inserted
            Set<String> newIsbns = new Set<String>();
            for (ID key : pbeMap.keySet())
                newIsbns.add(pbeMap.get(key).Product2.ISBN__c);
                
            // fetch the opportunities with recordtype and number of students   
            Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>(
                [select o.Number_of_Students__c, o.RecordTypeId from Opportunity o where id IN :opportunities]);        
                
            // the list to hold all of the opportunity line items to update
            List<OpportunityLineItem> olis2Update = new List<OpportunityLineItem>();    
         
            // iterate through all of the opportunity line items on the passed opporutnities that match by isbn
            for (OpportunityLineItem oli : [Select o.Id, o.UnitPrice, o.PricebookEntry.Product2.ISBN__c From OpportunityLineItem o 
                    Where o.Opportunity.Id IN :opportunities And PricebookEntry.Product2.ISBN__c IN :newIsbns 
                    //And o.Opportunity.RecordTypeId IN :casRecordTypes
                    And o.UnitPrice > 0]) {
                    
                //System.debug('====================================> existing isbn: '+oli.PricebookEntry.Product2.ISBN__c); 
                oli.UnitPrice = 0;
                olis2Update.add(oli);
                
            }
            
            // if any opportunity line items were found, then update them
            if (olis2Update.size() > 0) 
                update olis2Update;              
            
            for (OpportunityLineItem oli : trig.newList) {
                
                // only process CAS recordtypes
                //if (casRecordTypes.contains(oppMap.get(oli.opportunityId).RecordTypeId)) {
                    
                    // update the quantity with the number of students
                    if (oppMap.get(oli.opportunityId).Number_of_Students__c == null || oppMap.get(oli.opportunityId).Number_of_Students__c == 0) {
                        oli.Quantity = 1;
                    } else {
                        oli.Quantity = oppMap.get(oli.opportunityId).Number_of_Students__c; 
                    }
                    
                //}
                
            }
            
        }
    }
}