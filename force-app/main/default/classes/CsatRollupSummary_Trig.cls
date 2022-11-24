/*
** Tested by: zTEST_CsatRollupSummary
** Story no. DF-299 on Digital Foundation project
Modified by Renil Rejith - [MES-247] - replace the “Yes” with 5 OR 6 OR 7 and “No” with 1 OR 2 OR 3 OR 4.						   
*/
public with sharing class CsatRollupSummary_Trig implements TriggerInterface_CSAT.Runnable {
    public void run(TriggerInterface_CSAT.Trig trig) {       
                
        if (trig.isAfter && (trig.isInsert || trig.isUpdate)) {          
            list<string> accountIdsInTrigger = new list<string>();
            list<string> contactIdsInTrigger = new list<string>();
            for(CSAT__c obj: Trig.newList){
                if(obj.Survey_Status__c=='Response Received'){
                    if (obj.AccountId__c != null)
                        accountIdsInTrigger.add(obj.AccountId__c);   
                    if (obj.contactId__c != null)  
                        contactIdsInTrigger.add(obj.ContactId__c);
                    }
            }            
            /* Functionality for Accounts*/
            map<Id, List<CSAT__c >> accountToCsatMap = new map<Id, List<CSAT__c >>();
            for(CSAT__c obj: [SELECT Id, Customer_Satisfaction_CSAT__c, Promoter__c, Detractor__c, AccountId__c
                              FROM CSAT__c 
                              WHERE AccountId__c IN :accountIdsInTrigger
                              //AND Survey_Status__c='Response Received'
                              AND (Survey_Date__c = LAST_N_MONTHS:12 OR Survey_Date__c = THIS_MONTH)]){                
                              //AND (Survey_Date__c = LAST_N_DAYS:365)]){    
                                  Id accountId = Id.valueOf(obj.AccountId__c);
                                  List<CSAT__c> csatList = new List<CSAT__c>();
                                  if (accountToCsatMap.containsKey(accountId))
                                      csatList = accountToCsatMap.get(accountId);
                                  csatList.add(obj);                
                                  accountToCsatMap.put(accountId, csatList);                    
                              }
            
            List<Account> accounts = [SELECT Id FROM Account WHERE Id IN :accountToCsatMap.keyset()];
            List<Account> accountsToUpdate = new List<Account>();
            for(Account a:accounts){
                List<CSAT__c> csatsForA = accountToCsatMap.get(a.Id);
                Decimal Total_CSAT_CountForAccount=csatsForA.size();
                Decimal CSAT_CountForAccount= 0;
                Decimal Promoters_CountForAccount= 0;
                Decimal Detractors_CountForAccount= 0;
                for(integer i=0;i<=Total_CSAT_CountForAccount-1;i++)
                {
                    //[MES-247] -  by Renil Rejith 
                    if(csatsForA.get(i).Customer_Satisfaction_CSAT__c == '5' || csatsForA.get(i).Customer_Satisfaction_CSAT__c == '6' || csatsForA.get(i).Customer_Satisfaction_CSAT__c == '7')
                    {
                        CSAT_CountForAccount++;
                    }
                    if(csatsForA.get(i).promoter__c==1){
                        Promoters_CountForAccount++;
                    }
                    if(csatsForA.get(i).detractor__c==1){
                        Detractors_CountForAccount++;
                    }
                }
                Decimal CSATForAccount=(CSAT_CountForAccount /Total_CSAT_CountForAccount).setScale(2); 
                a.CSAT_Percentage__c=CSATForAccount; 
                Decimal NPS_ForAccount=0.00;
                try{
                    NPS_ForAccount=((Promoters_CountForAccount /Total_CSAT_CountForAccount)-(Detractors_CountForAccount /Total_CSAT_CountForAccount)).setScale(2);
                }
                catch(exception e)
                {
                    System.debug(e.getMessage()+'-'+a.Id);
                }
                a.NPS_percentage__c=NPS_ForAccount;                
                accountsToUpdate.add(a);
                
            }
            if(accountsToUpdate.size() > 0)
                update accountsToUpdate;                
            
            
            /* Functionality for Contacts*/
            map<Id,list<CSAT__c>> ContactToCsatMap = new map<Id,list<CSAT__c>>();
            for(CSAT__c obj: [SELECT id, Customer_Satisfaction_CSAT__c, Promoter__c, Detractor__c, ContactId__c
                              FROM CSAT__c
                              WHERE ContactId__c IN :contactIdsInTrigger
                              //AND Survey_Status__c='Response Received'
                              AND (Survey_Date__c = LAST_N_MONTHS:12 OR Survey_Date__c = THIS_MONTH)])
            {
                Id contactId = Id.valueOf(obj.ContactId__c);
                List<CSAT__c> csatList = new List<CSAT__c>();
                if (ContactToCsatMap.containsKey(contactId))
                    csatList = ContactToCsatMap.get(contactId);
                csatList.add(obj);
                ContactToCsatMap.put(contactId, csatList);
            } 
            
            List<Contact> Contacts=[SELECT Id FROM Contact WHERE Id IN :ContactToCsatMap.keyset()];
            List<Contact> ContactsToUpdate=new List<Contact>();
            for(Contact c:Contacts){
                List<CSAT__c> CsatsForc=ContactToCsatMap.get(c.Id);
                Decimal Total_CSAT_CountForContact=CsatsForc.size();
                Decimal CSAT_CountForContact= 0;
                Decimal Promoters_CountForContact= 0;
                Decimal Detractors_CountForContact= 0;
                for(integer i=0;i<=Total_CSAT_CountForContact-1;i++)
                {
                    //[MES-247] -  by Renil Rejith 
                    if(CsatsForc.get(i).Customer_Satisfaction_CSAT__c == '5' || CsatsForc.get(i).Customer_Satisfaction_CSAT__c == '6' || CsatsForc.get(i).Customer_Satisfaction_CSAT__c == '7')
                    {
                        CSAT_CountForContact++;
                    }
                    if(CsatsForc.get(i).promoter__c==1){
                        Promoters_CountForContact++;
                    }
                    if(CsatsForc.get(i).detractor__c==1){
                        Detractors_CountForContact++;
                    }
                }
                Decimal CSATForContact=(CSAT_CountForContact /Total_CSAT_CountForContact).setScale(2); 
                c.CSAT_Percentage__c=CSATForContact;
                Decimal NPS_ForContact=0.00;
                try{
                    NPS_ForContact=((Promoters_CountForContact /Total_CSAT_CountForContact )-(Detractors_CountForContact /Total_CSAT_CountForContact )).setScale(2);
                }
                catch(exception e)
                {
                    System.debug(e.getMessage()+'-'+ c.id);
                }                
                c.NPS_percentage__c=NPS_ForContact;
                ContactsToUpdate.add(c);
            }
            if(ContactsToUpdate.size() > 0)
            {
                update ContactsToUpdate;
            }
        }       
    }
}