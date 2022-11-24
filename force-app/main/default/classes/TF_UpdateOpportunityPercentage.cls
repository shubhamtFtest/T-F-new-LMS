/*
* Created by Piyush - 5,Oct,2018
* Purpose: Update opportunity percentage based on their recordTypes.
* Tested by: zTEST_TF_UpdateOpportunityPercentage
*/

global class TF_UpdateOpportunityPercentage implements Database.Batchable<sObject> {

    global Database.queryLocator start(Database.BatchableContext ctx ){
        
        string Qry;
        

        Qry = 'Select Id,RecordTypeId,StageName, StageHistory__c ,Invoice_Status_Date__c,Stage_Date__c from Opportunity where Stage_Probability_Flag__c = False AND Amount_USD__c !=null AND StageName != \'Closed Lost 120 Days\' ';
        

        return Database.getQueryLocator(Qry); 
    }

    global void execute(Database.BatchableContext ctx, List<Opportunity> Scope){
        List<Opportunity> oppsList = new List<Opportunity>();
        
        for(Opportunity opps : Scope){

            /* Start ==> Opportunity Stage = Prospect and Related RecordTypes */

            if(Opps.StageName == 'Prospect' && opps.RecordTypeId != '0120Y000000Wqv3' ){
                opps.Probability = 0;
                opps.Stage_Probability_Flag__c = True;
                oppsList.add(opps);
            }
            
            /* End */

            /* Start ==> Opportunity Stage = Investigating and Related RecordTypes */

            if(Opps.StageName == 'Investigating' && (opps.RecordTypeId  == '0120Y000000Wn9U' || opps.RecordTypeId  == '0120Y000000Wn9T' )){
                opps.Probability = 75;
                opps.Stage_Probability_Flag__c = True;
                oppsList.add(opps);
            }

            if(Opps.StageName == 'Investigating' && (opps.RecordTypeId  == '0120Y000000Wn8Y' || opps.RecordTypeId  == '0120Y000000Wn9Y' || opps.RecordTypeId  == '0120Y000000Wn9Z')){
                opps.Probability = 60;
                opps.Stage_Probability_Flag__c = True;
                oppsList.add(opps);
            }

            if(Opps.StageName == 'Investigating' && opps.RecordTypeId  == '0120Y000000Wn8T'){
                opps.Probability = 50;
                opps.Stage_Probability_Flag__c = True;
                oppsList.add(opps);
            }

            if(Opps.StageName == 'Investigating' && (opps.RecordTypeId  == '0120Y000000Wn9V' || opps.RecordTypeId  == '0120Y000000Wn9W')){
                opps.Probability = 70;
                opps.Stage_Probability_Flag__c = True;
                oppsList.add(opps);
            }

            if(Opps.StageName == 'Investigating' && opps.RecordTypeId  == '0120Y000000Wn9X'){
                opps.Probability = 10;
                opps.Stage_Probability_Flag__c = True;
                oppsList.add(opps);
            }

            if(Opps.StageName == 'Investigating' && opps.RecordTypeId  == '0120Y000000Wn9S'){
                opps.Probability = 10;
                opps.Stage_Probability_Flag__c = True;
                oppsList.add(opps);
            }

            /* End */

            /* Start ==> Opportunity Stage = Evaluating and Related RecordTypes */

            if(Opps.StageName == 'Evaluating' && (opps.RecordTypeId  == '0120Y000000Wn9U' || opps.RecordTypeId  == '0120Y000000Wn9T' )){
                opps.Probability = 90;
                opps.Stage_Probability_Flag__c = True;
                oppsList.add(opps);
            }

            if(Opps.StageName == 'Evaluating' && (opps.RecordTypeId  == '0120Y000000Wn8Y' || opps.RecordTypeId  == '0120Y000000Wn9Y' || opps.RecordTypeId  == '0120Y000000Wn9Z')){
                opps.Probability = 80;
                opps.Stage_Probability_Flag__c = True;
                oppsList.add(opps);
            }

            if(Opps.StageName == 'Evaluating' && opps.RecordTypeId  == '0120Y000000Wn8T'){
                opps.Probability = 70;
                opps.Stage_Probability_Flag__c = True;
                oppsList.add(opps);
            }

            if(Opps.StageName == 'Evaluating' && (opps.RecordTypeId  == '0120Y000000Wn9V' || opps.RecordTypeId  == '0120Y000000Wn9W')){
                opps.Probability = 90;
                opps.Stage_Probability_Flag__c = True;
                oppsList.add(opps);
            }

            if(Opps.StageName == 'Evaluating' && opps.RecordTypeId  == '0120Y000000Wn9X'){
                opps.Probability = 20;
                opps.Stage_Probability_Flag__c = True;
                oppsList.add(opps);
            }

            if(Opps.StageName == 'Evaluating' && opps.RecordTypeId  == '0120Y000000Wn9S'){
                opps.Probability = 20;
                opps.Stage_Probability_Flag__c = True;
                oppsList.add(opps);
            }

            /* End */

            /* Start ==> Opportunity Stage = Negotiation and Related RecordTypes */

            if(Opps.StageName == 'Negotiation' && (opps.RecordTypeId  == '0120Y000000Wn9U' || opps.RecordTypeId  == '0120Y000000Wn9T' )){
                opps.Probability = 95;
                opps.Stage_Probability_Flag__c = True;
                oppsList.add(opps);
            }

            if(Opps.StageName == 'Negotiation' && (opps.RecordTypeId  == '0120Y000000Wn8Y' || opps.RecordTypeId  == '0120Y000000Wn9Y' || opps.RecordTypeId  == '0120Y000000Wn9Z')){
                opps.Probability = 90;
                opps.Stage_Probability_Flag__c = True;
                oppsList.add(opps);
            }

            if(Opps.StageName == 'Negotiation' && opps.RecordTypeId  == '0120Y000000Wn8T'){
                opps.Probability = 80;
                opps.Stage_Probability_Flag__c = True;
                oppsList.add(opps);
            }

            if(Opps.StageName == 'Negotiation' && (opps.RecordTypeId  == '0120Y000000Wn9V' || opps.RecordTypeId  == '0120Y000000Wn9W')){
                opps.Probability = 95;
                opps.Stage_Probability_Flag__c = True;
                oppsList.add(opps);
            }

            if(Opps.StageName == 'Negotiation' && opps.RecordTypeId  == '0120Y000000Wn9X'){
                opps.Probability = 50;
                opps.Stage_Probability_Flag__c = True;
                oppsList.add(opps);
            }

            if(Opps.StageName == 'Negotiation' && opps.RecordTypeId  == '0120Y000000Wn9S'){
                opps.Probability = 50;
                opps.Stage_Probability_Flag__c = True;
                oppsList.add(opps);
            }

            /* End */

            /* Start ==> Opportunity Stage = Acceptance and Related RecordTypes */

            if(Opps.StageName == 'Acceptance' && opps.RecordTypeId != '0120Y000000Wqv3' ){
                opps.Probability = 100;
                opps.Stage_Probability_Flag__c = True;
                oppsList.add(opps);
            }

            /* End */

            /* Start ==> Opportunity Stage = Closed Won and Related RecordTypes */

            if(Opps.StageName == 'Closed Won' && opps.RecordTypeId != '0120Y000000Wqv3' ){
                opps.Probability = 100;
                opps.Stage_Probability_Flag__c = True;
                oppsList.add(opps);
            }

            /* End */

            /* Start ==> Opportunity Stage = Closed Lost and Related RecordTypes */

            if(Opps.StageName == 'Closed Lost' && opps.RecordTypeId != '0120Y000000Wqv3' ){
                opps.Probability = 0;
                opps.Stage_Probability_Flag__c = True;
                oppsList.add(opps);
            }

            /* End */
            
        }
        
        Database.Update(oppsList);

    }

    global void finish(Database.BatchableContext BC) {

    }
}