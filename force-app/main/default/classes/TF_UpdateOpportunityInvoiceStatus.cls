global class TF_UpdateOpportunityInvoiceStatus implements Database.Batchable<sObject> { 
    
    global Database.queryLocator start(Database.BatchableContext ctx ){
        
        string Qry;
        

        Qry = 'Select Id,RecordTypeId,StageName, StageHistory__c ,Invoice_Status_Date__c,Stage_Date__c from Opportunity where Stage_Probability_Flag__c = TRUE AND Amount_USD__c !=null AND StageName != \'Closed Lost 120 Days\' AND StageHistory__c!=null ';
        

        return Database.getQueryLocator(Qry); 
    }

    global void execute(Database.BatchableContext ctx, List<Opportunity> Scope){
        List<Opportunity> oppsList = new List<Opportunity>();
        
        for(Opportunity opps : Scope){

            /* Check Opportunity Stage History */

            if(Opps.StageHistory__c == 'Request Quote' && (opps.RecordTypeId  == '0120Y000000Wn9V'|| opps.RecordTypeId  == '0120Y000000Wn9W'|| opps.RecordTypeId  == '0120Y000000Wn8T')){
                opps.Invoice_Status__c = 'Request Quote';
                opps.Stage_Probability_Flag__c = True;
                oppsList.add(opps);
            }
            if(Opps.StageHistory__c == 'Quote in Progress' && (opps.RecordTypeId  == '0120Y000000Wn9V'|| opps.RecordTypeId  == '0120Y000000Wn9W'|| opps.RecordTypeId  == '0120Y000000Wn8T')){
                opps.Invoice_Status__c = 'Quote in Progress';
                opps.Stage_Probability_Flag__c = True;
                oppsList.add(opps);
            }
            if(Opps.StageHistory__c == 'Quotation' && (opps.RecordTypeId  == '0120Y000000Wn9V'|| opps.RecordTypeId  == '0120Y000000Wn9W'|| opps.RecordTypeId  == '0120Y000000Wn8T')){
                opps.Invoice_Status__c = 'Quote sent to customer';
                opps.Stage_Probability_Flag__c = True;
                oppsList.add(opps);
            }
            if(Opps.StageHistory__c == 'Request Invoice' && (opps.RecordTypeId  == '0120Y000000Wn9V'|| opps.RecordTypeId  == '0120Y000000Wn9W'|| opps.RecordTypeId  == '0120Y000000Wn8T')){
                opps.Invoice_Status__c = 'Request Invoice';
                opps.Stage_Probability_Flag__c = True;
                oppsList.add(opps);
            }
            if(Opps.StageHistory__c == 'Invoice in Progress' && (opps.RecordTypeId  == '0120Y000000Wn9V'|| opps.RecordTypeId  == '0120Y000000Wn9W'|| opps.RecordTypeId  == '0120Y000000Wn8T')){
                opps.Invoice_Status__c = 'Invoice in Progress';
                opps.Stage_Probability_Flag__c = True;
                oppsList.add(opps);
            }
            /*if(opps.Stage_Date__c != null && (opps.RecordTypeId  == '0120Y000000Wn9V'|| opps.RecordTypeId  == '0120Y000000Wn9W'|| opps.RecordTypeId  == '0120Y000000Wn8T')){
                opps.Invoice_Status_Date__c = opps.Stage_Date__c;
                opps.Stage_Probability_Flag__c = True;
                oppsList.add(opps);
            }*/

            /* End */
            
        }
        
        Database.Update(oppsList);

    }

    global void finish(Database.BatchableContext BC) {

    }

}