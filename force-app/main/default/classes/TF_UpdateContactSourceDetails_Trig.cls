/******************************************************************************************************************
* Name : TF_UpdateContactSourceDetails_Trig
* Purpose : Mehods for updating contact fields when data is coming from orchestration layer.
* Author : Sourabh Goyal
* Date : 24/08/2017
* JIRA Ticket Numbers : WCE - 602, WCE - 614, WCE - 608, WCE - 694 
*******************************************************************************************************************/
public with sharing class TF_UpdateContactSourceDetails_Trig implements TriggerInterface_Contact.Runnable {

    public void run(TriggerInterface_Contact.Trig trig) {
    
        /* Looping all new upcoming contact data*/
        for(Contact con : trig.newMap.values())
        {   
            
            
                /* Condition when optin_optout_status__c , optin_optout_source__c, Last_Modified_Opt_Out_Status_Date__c of contact is null. Updating the contact fields for the incoming data*/              
                if(trig.oldMap.get(con.Id).optin_optout_status__c == null && trig.oldMap.get(con.Id).optin_optout_status__c !=con.optin_optout_status__c)
                {  system.debug('***in***** 1');
                    if(con.optin_optout_status__c == 'Explicit Opt-Out')
                    {
                        con.HasOptedOutOfEmail = True;
                        con.Source_of_Email_Opt_Out_Status__c = con.optin_optout_source__c;
                        con.Last_Modified_Global_Opt_Out_Status_Date__c = con.Last_Modified_Opt_Out_Status_Date__c;
                    }
                    else if(con.optin_optout_status__c == 'Explicit Opt-In')
                    {
                        con.HasOptedOutOfEmail = False;
                        con.Source_of_Email_Opt_Out_Status__c = con.optin_optout_source__c;
                        con.Last_Modified_Global_Opt_Out_Status_Date__c = con.Last_Modified_Opt_Out_Status_Date__c;
                    }
                    else
                    {
                        if(trig.oldMap.get(con.Id).HasOptedOutOfEmail == True){
                            con.HasOptedOutOfEmail = trig.oldMap.get(con.Id).HasOptedOutOfEmail;
                        }else{
                            con.HasOptedOutOfEmail = False;
                            }
                       system.debug('***in 1'); 
                    }
                    system.debug('***in 2');
                }
                
                /* Condition when optin_optout_status__c in contact is Implicit Opt-In. Updating the fields on contact for incoming data.*/  
                
                else if((trig.oldMap.get(con.Id).optin_optout_status__c == 'Implicit Opt-In') && (trig.oldMap.get(con.Id).Last_Modified_Opt_Out_Status_Date__c == null || trig.oldMap.get(con.Id).Last_Modified_Opt_Out_Status_Date__c <= con.Last_Modified_Opt_Out_Status_Date__c))
                {
                    system.debug('***in***** 2.1');
                    if(con.optin_optout_status__c == 'Explicit Opt-Out'){
                        con.HasOptedOutOfEmail = True;
                        con.Source_of_Email_Opt_Out_Status__c = con.optin_optout_source__c;
                        con.Last_Modified_Global_Opt_Out_Status_Date__c = con.Last_Modified_Opt_Out_Status_Date__c;
                    }
                    else if(con.optin_optout_status__c == 'Explicit Opt-In'){
                        con.HasOptedOutOfEmail = False;
                        con.Source_of_Email_Opt_Out_Status__c = con.optin_optout_source__c;
                        con.Last_Modified_Global_Opt_Out_Status_Date__c = con.Last_Modified_Opt_Out_Status_Date__c;
                    }
                    else{

                        if(trig.oldMap.get(con.Id).HasOptedOutOfEmail == True){
                            con.HasOptedOutOfEmail = trig.oldMap.get(con.Id).HasOptedOutOfEmail;
                        }else{
                            con.HasOptedOutOfEmail = False;
                            }
                        system.debug('***in 2');
                    }
                }
                
                /* Condition when optin_optout_status__c in contact is Explicit Opt-In or Explicit Opt-Out. Updating the fields on contact for incoming data.*/ 
                
                else if(con.optin_optout_status__c!=null && trig.oldMap.get(con.Id).optin_optout_status__c.contains('Explicit') && con.optin_optout_status__c.contains('Explicit') && (trig.oldMap.get(con.Id).Last_Modified_Opt_Out_Status_Date__c == null || trig.oldMap.get(con.Id).Last_Modified_Opt_Out_Status_Date__c <= con.Last_Modified_Opt_Out_Status_Date__c))
                {
                    system.debug('***in***** 3.1');
                    if(con.optin_optout_status__c == 'Explicit Opt-Out'){
                        con.HasOptedOutOfEmail = True;
                        con.Source_of_Email_Opt_Out_Status__c = con.optin_optout_source__c;
                        con.Last_Modified_Global_Opt_Out_Status_Date__c = con.Last_Modified_Opt_Out_Status_Date__c;
                        
                    }
                    else if(con.optin_optout_status__c == 'Explicit Opt-In'){
                        con.HasOptedOutOfEmail = False;
                        con.Source_of_Email_Opt_Out_Status__c = con.optin_optout_source__c;
                        con.Last_Modified_Global_Opt_Out_Status_Date__c = con.Last_Modified_Opt_Out_Status_Date__c;
                        
                    }
                    
                    
                }

                /* Condition when optin_optout_status__c in contact is Explicit Opt-In or Explicit Opt-Out and incoming is implict.*/
                else if(con.optin_optout_status__c!=null && trig.oldMap.get(con.Id).optin_optout_status__c.contains('Explicit') && con.optin_optout_status__c.contains('Implicit') && (trig.oldMap.get(con.Id).Last_Modified_Opt_Out_Status_Date__c == null || trig.oldMap.get(con.Id).Last_Modified_Opt_Out_Status_Date__c <= con.Last_Modified_Opt_Out_Status_Date__c))
                {
                    system.debug('***in***** 4.1');
                    con.HasOptedOutOfEmail = trig.oldMap.get(con.Id).HasOptedOutOfEmail;
                    con.Last_Modified_Opt_Out_Status_Date__c = trig.oldMap.get(con.Id).Last_Modified_Opt_Out_Status_Date__c;
                    con.optin_optout_status__c = trig.oldMap.get(con.Id).optin_optout_status__c;
                    con.optin_optout_source__c = trig.oldMap.get(con.Id).optin_optout_source__c;
                    con.Last_Modified_Global_Opt_Out_Status_Date__c = trig.oldMap.get(con.Id).Last_Modified_Opt_Out_Status_Date__c;
                }
                
                /* Condition in which old Last_Modified_Opt_Out_Status_Date__c is greater always. Updating the fields on contact at priority basis for incoming data.*/
                else
                {
                    system.debug('***in***** 5.1');
                        /* Taking Explicit on higher priority always */
                        if(con.optin_optout_status__c!=null && trig.oldMap.get(con.Id).optin_optout_status__c.contains('Implicit') && con.optin_optout_status__c.contains('Explicit') && con.Last_Modified_Opt_Out_Status_Date__c <= trig.oldMap.get(con.Id).Last_Modified_Opt_Out_Status_Date__c)
                        {
                            system.debug('***in***** 5.1.1');
                          
                            if(con.optin_optout_status__c == 'Explicit Opt-In'){
                                con.HasOptedOutOfEmail = False;
                            }
                            else{
                                con.HasOptedOutOfEmail = True;
                            }
                            con.Last_Modified_Opt_Out_Status_Date__c = con.Last_Modified_Opt_Out_Status_Date__c;
                            con.Last_Modified_Global_Opt_Out_Status_Date__c = con.Last_Modified_Opt_Out_Status_Date__c;
                            con.optin_optout_status__c = con.optin_optout_status__c;
                            con.optin_optout_source__c = con.optin_optout_source__c;
                            con.Source_of_Email_Opt_Out_Status__c = con.optin_optout_source__c;
                            
                        }
                        
                        /* Condition when optin_optout_status__c in contact is Implicit Opt-In  and incoming is Implict.*/
                        
                        else if(con.optin_optout_status__c!=null && trig.oldMap.get(con.Id).optin_optout_status__c.contains('Implicit') && con.optin_optout_status__c.contains('Implicit') && con.Last_Modified_Opt_Out_Status_Date__c <= trig.oldMap.get(con.Id).Last_Modified_Opt_Out_Status_Date__c)
                        {
                            system.debug('***in***** 5.1.2');
                            if(trig.oldMap.get(con.Id).HasOptedOutOfEmail == True){
                                con.HasOptedOutOfEmail = trig.oldMap.get(con.Id).HasOptedOutOfEmail;
                            }
                            else{
                                con.HasOptedOutOfEmail = False;
                                 }
                            con.Last_Modified_Opt_Out_Status_Date__c = trig.oldMap.get(con.Id).Last_Modified_Opt_Out_Status_Date__c;
                            con.optin_optout_status__c = trig.oldMap.get(con.Id).optin_optout_status__c;
                            con.optin_optout_source__c = trig.oldMap.get(con.Id).optin_optout_source__c;
                            system.debug('***in 4');
                        }
                        
                        /* Condition when optin_optout_status__c in contact is Explicit and incoming is Implict.*/
                        
                        else if(con.optin_optout_status__c!=null && trig.oldMap.get(con.Id).optin_optout_status__c.contains('Explicit') && con.optin_optout_status__c.contains('Implicit') && con.Last_Modified_Opt_Out_Status_Date__c <= trig.oldMap.get(con.Id).Last_Modified_Opt_Out_Status_Date__c)
                        {
                            system.debug('***in***** 5.1.3');
                            
                            con.HasOptedOutOfEmail = trig.oldMap.get(con.Id).HasOptedOutOfEmail;
                            con.Last_Modified_Opt_Out_Status_Date__c = trig.oldMap.get(con.Id).Last_Modified_Opt_Out_Status_Date__c;
                            con.optin_optout_status__c = trig.oldMap.get(con.Id).optin_optout_status__c;
                            con.optin_optout_source__c = trig.oldMap.get(con.Id).optin_optout_source__c;
                            con.Last_Modified_Global_Opt_Out_Status_Date__c = trig.oldMap.get(con.Id).Last_Modified_Opt_Out_Status_Date__c;
                            system.debug('***in 4');
                        }

                        /* Condition when optin_optout_status__c in contact is Explicit and incoming is Explict.*/
                        
                        else if(con.optin_optout_status__c!=null && trig.oldMap.get(con.Id).optin_optout_status__c.contains('Explicit') && con.optin_optout_status__c.contains('Explicit') && con.Last_Modified_Opt_Out_Status_Date__c <= trig.oldMap.get(con.Id).Last_Modified_Opt_Out_Status_Date__c)
                        {
                            system.debug('***in***** 5.1.4');
                            
                            con.HasOptedOutOfEmail = trig.oldMap.get(con.Id).HasOptedOutOfEmail;
                            con.Last_Modified_Opt_Out_Status_Date__c = trig.oldMap.get(con.Id).Last_Modified_Opt_Out_Status_Date__c;
                            con.optin_optout_status__c = trig.oldMap.get(con.Id).optin_optout_status__c;
                            con.optin_optout_source__c = trig.oldMap.get(con.Id).optin_optout_source__c;
                            con.Last_Modified_Global_Opt_Out_Status_Date__c = trig.oldMap.get(con.Id).Last_Modified_Opt_Out_Status_Date__c;
                            system.debug('***in 4');
                        }
                       
                }
        }
    }
    
}