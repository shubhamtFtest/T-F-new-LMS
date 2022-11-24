/*
Created by		: Syam Nukilla
Created Date	: 2020.04.17
Description		: for an incoming ACR record,  
                    1.check if any of the field values of Account_Contact_Role__c, Account_Contact_Role_Level_2_del1__c, Account_Contact_Role_Level_3_del1__c of the current ACR matches with CMDT ACR_Name__c field.
                    2.Current ACR record, Active__c is true.
                    3.Related Contact, Status__c = 'Active' and optin_optout_status__c = 'Explicit Opt-In' or 'Implicit Opt-In'.
                    4.If all the three conditions met then we need to update Shared_with_Pardot__c on Contact to True.
Test Class		: zTest_PardotSharing @ 100%
*/
public without sharing class PardotACRSharing_Trig implements TriggerInterface_ACR.Runnable {
    public void run(TriggerInterface_ACR.Trig trig) {
        if (trig.isAfter) {
            System.debug(trig.isInsert+'<<Insert==test inside trigger==Update>>'+trig.isUpdate);
            
            Set<String> acrCMDTSet = new Set<String>();//Set to hold values of ACR_Name__c field on Pardot_ACR_Sharing__mdt.  
            Set<String> countryCMDTSet = new Set<String>();
            Set<String> domainCMDTSet = new Set<String>();
            Set<String> conIDSet = new Set<String>();//Set to hold matched Contact Ids.
            List<Contact> conInsertList = new List<Contact>();// List to hold Contacts for Insert Context.
            List<Contact> conUpdateList = new List<Contact>();// List to hold Contacts for Update Context.
            Boolean isAcrExists = false; //if acr exists in Update Context.
            Boolean isAcrNotExists = false;//if acr doesn't exists in Update Context.
            Boolean isConCountry = false;
            Boolean isConDomain = false;
            Boolean isDelAcr = false;
            //fetching ACR_Name__c values from cmdt into Set string 'acrCMDTSet'.
            for(Pardot_ACR_Sharing__mdt cmdt:[SELECT Id,ACR_Name__c,Label FROM Pardot_ACR_Sharing__mdt]){
                acrCMDTSet.add(cmdt.ACR_Name__c);
            }
            
            for(Pardot_ACR_Sharing_Excluded_Country__mdt cmdt:[SELECT Id,Label FROM Pardot_ACR_Sharing_Excluded_Country__mdt]){
                countryCMDTSet.add(cmdt.Label);
            }
            
            for(Pardot_ACR_Sharing_Excluded_Domain__mdt cmdt:[SELECT Id,Label FROM Pardot_ACR_Sharing_Excluded_Domain__mdt]){
                domainCMDTSet.add(cmdt.Label);
            }   
            
            //checking the new ACR record Active__c ==True AND any of Account_Contact_Role__c,Account_Contact_Role_Level_2_del1__c,
            //Account_Contact_Role_Level_3_del1__c field values matches with acrCMDTSet.
            if(trig.isInsert || trig.isUpdate){
                for(AccountContactRole__c acrNewRec:trig.newList){
                    if(trig.isInsert){
                        if( acrNewRec.Active__c == True &&
                           (acrCMDTSet.contains(acrNewRec.Account_Contact_Role__c) ||
                            acrCMDTSet.contains(acrNewRec.Account_Contact_Role_Level_2_del1__c) ||
                            acrCMDTSet.contains(acrNewRec.Account_Contact_Role_Level_3_del1__c) ) ) {
                                conIDSet.add(acrNewRec.ContactID__c);
                            } 
                    }else if(trig.isUpdate){
                        AccountContactRole__c acrOldRec = trig.oldMap.get(acrNewRec.Id);
                        if(acrOldRec.Active__c != acrNewRec.Active__c ||
                           (acrOldRec.Account_Contact_Role__c != acrNewRec.Account_Contact_Role__c)||
                           (acrOldRec.Account_Contact_Role_Level_2_del1__c != acrNewRec.Account_Contact_Role_Level_2_del1__c)||
                           (acrOldRec.Account_Contact_Role_Level_3_del1__c != acrNewRec.Account_Contact_Role_Level_3_del1__c)
                          ){
                              conIDSet.add(acrNewRec.ContactID__c); 
                          }
                    } 
                }
            }
            
            if(trig.isDelete){
                for(AccountContactRole__c acrOld:trig.oldList){
                    conIDSet.add(acrOld.ContactID__c); 
                }    
            }
            
            System.debug('conIDSet-->'+conIDSet);
            if(conIDSet != Null ){
                List<AccountContactRole__c> acrList = new List<AccountContactRole__c>();
                for(Contact con:[SELECT Id,Shared_with_Pardot__c,Mailing_Country_List__c,Email,
                                 (SELECT Id,Active__c,Account_Contact_Role__c,Account_Contact_Role_Level_2_del1__c,
                                  Account_Contact_Role_Level_3_del1__c FROM Account_Contact_Roles__r) 
                                 FROM Contact WHERE Status__c = 'Active' 
                                 AND optin_optout_status__c NOT IN ('Explicit Opt-Out')
                                 AND Id IN:conIDSet]){
                           conInsertList.add(con);
                           conUpdateList.add(con);
                           acrList = con.Account_Contact_Roles__r;  
                           if(countryCMDTSet.contains(con.Mailing_Country_List__c)){
                               isConCountry = true;                                                                          
                           }
                           String emailStr = con.Email.substringAfter('@');
                           if(domainCMDTSet.contains(emailStr)){
                               isConDomain  = true;
                           }
                }
                for(AccountContactRole__c acrRec:acrList){
                    if(acrRec.Active__c == True && 
                      (acrCMDTSet.contains(acrRec.Account_Contact_Role__c) ||
                       acrCMDTSet.contains(acrRec.Account_Contact_Role_Level_2_del1__c) ||
                       acrCMDTSet.contains(acrRec.Account_Contact_Role_Level_3_del1__c) )){
                           isAcrExists = true;
                       }else{
                           isAcrNotExists = true;
                       }
                }
                if(acrList.size()==0){
                    isDelAcr = true;
                }
                
            }
            System.debug(isAcrExists+'>>>test<<<<'+isAcrNotExists);
            
            //Insert Context::            
            //if we got the contact records then update the contact record with Shared_with_Pardot__c = true.  
            if(conInsertList != Null && trig.isInsert && (!isConCountry || !isConDomain)){
                for(Contact con:conInsertList){      
                    con.Shared_with_Pardot__c = true;
                }
            }
            //updating the contact list.
            if(!conInsertList.isEmpty() && trig.isInsert){
                update conInsertList;                
            }
            // end of Insert Context.
            
            //Update Context::
            //if we got the contact records then update the contact record with Shared_with_Pardot__c = true else false.
            if(conUpdateList != Null && (trig.isUpdate || trig.isDelete) ){
                for(Contact con:conUpdateList){   
                    if(isAcrExists && (!isConCountry || !isConDomain)){
                        con.Shared_with_Pardot__c = true;
                    }
                    if(isAcrNotExists || isConCountry || isConDomain || isDelAcr){
                        con.Shared_with_Pardot__c = false;
                    }
                }
            }
            System.debug('conUpdateList -->'+conUpdateList);
            if(!conUpdateList.isEmpty() && (trig.isUpdate || trig.isDelete) ){
                update conUpdateList;
            }
            // end of Update Context.
            
        }// end of after event if condition
    }// end of run method
}