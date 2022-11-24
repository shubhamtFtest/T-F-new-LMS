//Creted by Ashish Purwar on 05-03-2018
//This class is batch class for CSATRollupSummary
////Updated by Ashish Purwar on 04-01-2019 for deletion of non responsive csat records
global class BatchCSATRollupSummary implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        string query= '';
        query= 'SELECT Id,AccountId__c,ContactId__c FROM CSAT__c Where Survey_Date__c < LAST_N_MONTHS:12 AND Survey_Status__c= \'Response Received\'';  
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<CSAT__c> scope) {        
        List<CSAT__c> CSATsToUpdate = new List<CSAT__c>();  
        List<String> AccountIdsinCsat = new List<String>();  
        List<String> ContactIdsinCsat = new List<String>(); 
        for(CSAT__c csat : scope){
            AccountIdsinCsat.add(csat.AccountId__c);  
            ContactIdsinCsat.add(csat.ContactId__c);
            CSATsToUpdate.add(csat);             	
        }
        list<Account> AccountsToReset=new list<Account>([select Id,CSAT_Percentage__c,nps_Percentage__c from account where Id in : AccountIdsinCsat]);
        list<Account> AccountsToUpdate=new list<Account>();
        list<Contact> ContactsToReset=new list<Contact>([select Id,CSAT_Percentage__c,nps_Percentage__c from Contact where Id in : ContactIdsinCsat]);
        list<Contact> ContactsToUpdate=new list<Contact>();
        for(Account a : AccountsToReset)
        {
            a.csat_percentage__c=0.00;
            a.nps_percentage__c=0.00;           
            AccountsToUpdate.add(a);
        }
        for(Contact c : ContactsToReset)
        {
            c.csat_percentage__c=0.00;
            c.nps_percentage__c=0.00;           
            ContactsToUpdate.add(c);
        }
        update AccountsToUpdate;
        update ContactsToUpdate;
        update CSATsToUpdate; 
    }
    global void finish(Database.BatchableContext BC) {
        //Added code to delete all csats which didn't get any response in last 3 months-Ashish Purwar-04-01-2019
        CSAT__c[] doomedCsats = [SELECT Id FROM csat__c WHERE Survey_Date__c < LAST_N_MONTHS:3 AND Survey_Status__c!= 'Response Received'];
        try {
                   delete doomedCsats;       
        } 
        catch (DmlException e) {
        	system.debug(e.getMessage());
        }

    }
}