/*
Created by		: Syam Nukilla
Created Date	: 2020.04.21
Description		: for an incoming Contact record,  
					1.check if Status__c = 'Active' and optin_optout_status__c = 'Explicit Opt-In' or 'Implicit Opt-In' changes.
					2.if value changes then get all ACR records and check if any of the acr record 
						field values of Account_Contact_Role__c, Account_Contact_Role_Level_2_del1__c, 
						Account_Contact_Role_Level_3_del1__c matches with CMDT ACR_Name__c field values
						and Active__c is true.
                    3.If all the three conditions met then we need to update Shared_with_Pardot__c on Contact to True.
					  else update Shared_with_Pardot__c on Contact to False. 	
Test Class		: zTest_PardotSharing @ 100%
*/
public without sharing class ContactPardotACRSharing_Trig implements TriggerInterface_Contact.Runnable {
    public void run(TriggerInterface_Contact.Trig trig){
        if (trig.isAfter && trig.isUpdate){
            system.debug('inside Contact trigger');
            Set<String> acrCMDTSet = new Set<String>();//Set to hold values of ACR_Name__c field on Pardot_ACR_Sharing__mdt.  
            Set<String> countryCMDTSet = new Set<String>();
            Set<String> domainCMDTSet = new Set<String>();
            Set<String> conIdSet = new Set<String>();
            List<Contact> conList = new List<Contact>();
            Boolean isAcrExists = false;
            Boolean isConExists = false;
            Boolean isConNotExists = false;
            Boolean isConCountry = false;
            Boolean isConDomain = false;
            Boolean isOverridePrdtCon = false;
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
            
            for(Contact conNewRec:trig.newList){
                Contact conOldRec = trig.oldMap.get(conNewRec.Id); 
                if(conOldRec.Status__c != conNewRec.Status__c || conOldRec.optin_optout_status__c != conNewRec.optin_optout_status__c ||
                   conOldRec.Mailing_Country_List__c != conNewRec.optin_optout_status__c || conOldRec.Mailing_Country_List__c != conNewRec.optin_optout_status__c ||
                   conOldRec.Override_Pardot_Sharing__c != conNewRec.Override_Pardot_Sharing__c){
                       conIdSet.add(conNewRec.Id);
                }
                if(conNewRec.Override_Pardot_Sharing__c){
                    System.debug('111');
                    isOverridePrdtCon = true;                    
                }
            }
            system.debug('conIdSet-->'+conIdSet);
            List<AccountContactRole__c> acrList = new List<AccountContactRole__c>();
            for(Contact con:[SELECT Id,Shared_with_Pardot__c,Status__c,optin_optout_status__c,Mailing_Country_List__c,Email,
                                 (SELECT Id FROM Account_Contact_Roles__r 
                                  WHERE Active__c = True AND (Account_Contact_Role__c IN:acrCMDTSet 
                                                         OR Account_Contact_Role_Level_2_del1__c IN:acrCMDTSet 
                                                         OR Account_Contact_Role_Level_3_del1__c IN:acrCMDTSet) ) 
                             FROM Contact WHERE Id IN:conIdSet]){
                                 conList.add(con); 
                                 acrList = con.Account_Contact_Roles__r;
                                 if(con.Status__c == 'Active' && (con.optin_optout_status__c != 'Explicit Opt-Out') ){
                                          isConExists = true;                                                                                                                                                                                                   
                                 }else{
                                     	isConNotExists = true;                         
                                 }
                                 if(countryCMDTSet.contains(con.Mailing_Country_List__c)){
                                     isConCountry = true;                                                                          
                                 }
                                 String emailStr = con.Email.substringAfter('@');
                                 if(domainCMDTSet.contains(emailStr)){
                                     isConDomain  = true;
                                 }
            }
            
            if(acrList.size()>0){
                isAcrExists =true;
            }
            system.debug('isAcrExists-->'+isAcrExists);
            system.debug(isConExists+'Con Exists-->'+isConNotExists);
            system.debug(isConCountry+'<--Country Excludes Domain-->'+isConDomain);
            if(conList != Null){
                for(Contact conRec:conList){
                    if( (isConExists && (!isConCountry || !isConDomain) ) || isOverridePrdtCon){
                        System.debug('222');
                        if(isAcrExists || isOverridePrdtCon){
                            System.debug('333');
                            conRec.Shared_with_Pardot__c = true;
                        }
                    }
                    if( (isConNotExists || isConCountry || isConDomain) && !isOverridePrdtCon){
                        conRec.Shared_with_Pardot__c = false;
                    }
                }  
            }
            system.debug('conList-->'+conList);
            if(!conList.isEmpty()){
                update conList;
            }
            
            
        }// end of after update if cond.        
    }// end of run method
}