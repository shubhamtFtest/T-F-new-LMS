/**
Created by Sourabh Goyal. @2 August 2017
Usage:- Updating the Contact w.r.t Contact Source Records using Batch Process.
*/

global class TF_UpdateContactsRec_Batch implements Database.Batchable<sObject> ,Database.Stateful  {

    
    String Query;
    
    global TF_UpdateContactsRec_Batch(){
        
        Query= 'select Id ,optin_optout_source__c,optin_optout_status__c ,(select id,Current_Opt_In_Status__c,Date_First_Added_to_Source__c,Latest_Date_of_Opt_In_Update__c,Source_System_ID__c,Source_System_Name__c,System_ID__c,ContactID__c,ContactSourceID__c,ContactSourceID_OLD__c from ContactSources__r ORDER BY Latest_Date_of_Opt_In_Update__c DESC) from Contact where optin_optout_source__c=null and recordtype.name = \'T&F - Contacts\' and Id in (select ContactID__c from ContactSource__c) limit 20000';
        
    } 
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        
        return Database.getQueryLocator(Query);
    }
    
    global void execute(Database.BatchableContext BC,List<Contact> scope)
    {
        List<Contact> conListAdd = new List<Contact>();
        for(Contact con : scope)
        {
                if(con.ContactSources__r!=null && con.ContactSources__r.size()>0)
                {
                    for(ContactSource__c csSources : con.ContactSources__r)
                    {
                        if(csSources.Current_Opt_In_Status__c!=null && csSources.Source_System_Name__c!=null && csSources.Current_Opt_In_Status__c!='' && csSources.Source_System_Name__c!=''){
                            if (con.optin_optout_source__c == null) { //make sure you don't query for it in line 13
                                con.optin_optout_source__c = csSources.Source_System_Name__c;
                            }
                            if(csSources.Current_Opt_In_Status__c == 'Explicit Opt Out'){
                                con.optin_optout_status__c = 'Explicit Opt-Out';
                                con.optin_optout_source__c = csSources.Source_System_Name__c;
                                break;
                            }
                            if(csSources.Current_Opt_In_Status__c == 'Explicit Opt In'){
                                con.optin_optout_status__c = 'Explicit Opt-In';
                                con.optin_optout_source__c = csSources.Source_System_Name__c;
                                break;                                                  
                            }
                            con.optin_optout_status__c = 'Implicit Opt-In'; 
                        }
                    }
                    conListAdd.add(con);
                }
        }
        update conListAdd;
    }
    
     global void finish(Database.BatchableContext BC)
     {
     }

}