/*
** Tested by: zTEST_CAS.cls
**
** Modified by Jeff Lup - 2015.02.27 - Moved old class into this TrigClass
*/
public without sharing class CAS_BooksInUseCreate_Trig implements TriggerInterface_OLI.Runnable {
    public void run(TriggerInterface_OLI.Trig trig) {
        if (trig.isAfter && (trig.isInsert || trig.isUpdate)) {
            Map<Integer,OpportunityLineItem> casLineItems = new Map<Integer,OpportunityLineItem>();
            Set<ID> opportunityIds = new Set<ID>();
            Set<ID> pricebookIds = new Set<ID>();
            
            for (Integer i=0;i<trig.newList.size();i++) {
                //if Adoption_Stage__c wasn't 'Completed - Adopted' before, but is now
                if ((trig.newList[i].Adoption_Stage__c == 'Completed – Adopted' || trig.newList[i].Adoption_Stage__c == 'Completed - Adopted') //large and small hyphen
                    && (trig.isInsert || (trig.oldList[i].Adoption_Stage__c != 'Completed – Adopted' && trig.oldList[i].Adoption_Stage__c != 'Completed - Adopted'))) { //large and small hyphen
                    // so that we can update the oli later when trigger executes
                    casLineItems.put(i, trig.newList[i]);
                    // add these specific ids to sets for soql queries          
                    opportunityIds.add(trig.newList[i].OpportunityId);
                    pricebookIds.add(trig.newList[i].PricebookEntryId);
                }               
            }
            
            // if there are any cas items in the maps, then process them
            if (casLineItems.size() > 0) {
                // the list of Book in Use objects to insert
                List<Book_in_Use__c> books = new List<Book_in_Use__c>();
                // get all of the opportunities for the line items
                Map<ID,Opportunity> opportunities = new Map<ID,Opportunity>([Select Year_of_Study__c, Course_Start_Date__c, Number_of_Students__c, OwnerId from Opportunity Where Id IN :opportunityIds]);
                // get all of the pricebookentries for the line items
                Map<ID,PricebookEntry> pricebookEntries = new Map<ID,PricebookEntry>([Select p.Product2Id, p.Product2.ISBN__c, p.Pricebook2Id, p.Name From PricebookEntry p Where p.Id IN :pricebookIds]);  
        
                // iterate over the list of values in the map of oli being processed -  the actual opportunity line items
                for (OpportunityLineItem oli : casLineItems.values()) {
                    // create a new Book in Use record
                    Book_in_Use__c book = new Book_in_Use__c(
                        Opportunity__c = oli.OpportunityId,
                        Product__c = pricebookEntries.get(oli.PricebookEntryId).Product2Id,
                        Adoption_Level__c = oli.Adoption_Level__c
                    );
        
                    books.add(book);
                }
                // insert the Book in Use records - just fail on an error
                insert books;
            }       
        }
    }
}