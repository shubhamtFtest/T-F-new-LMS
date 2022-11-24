/**************************************************************
* Created by Shay Spoonmore (shay.spoonmore@informausa.com)
* Last Modified by Jeff Lup (jeff.lup@informausa.com) - 2010.06.17
* Last Modified by shay.spoonmore@informausa.com - 2011.04.25
* Last Modified by Jeff Lup - Greenfield project
* Last Modified by Hailey Niemand - CHG0053289 - 2013.09.25
* Last Modified by Hailey Niemand - CHG0053969 - 2014.02.07
* Last Modified by Hailey Niemand - Use trigger record type object to enable trigger and manage which version to run - 2014.02.19
**************************************************************/

trigger CountryAccountTrigger on Account (before insert, before update) {
    /* Hailey Niemand - 2014.02.19
    Set<ID> casRecordTypes = new Set<ID>{
        '01260000000DXrpAAG' //CAS - Bookstores Accounts
        ,'01260000000DXrfAAG' //CAS - Campus Accounts
        ,'01260000000DXrkAAG' //CAS - Department Accounts
        ,'01260000000DXraAAG' //CAS - Institution Accounts
        ,'01260000000DKDyAAO' //Omega - Customer / Prospect Accounts (Shay Spoonmore - 2009.01.05)
        ,'01260000000DKE3AAO' //Omega - Partner / Sister Accounts (Shay Spoonmore - 2009.05.05)
        ,'01260000000DJBrAAO' //Huthwaite - Customer Accounts (Case 9651 - Jeff Lup - 2009.08.06)
        //,'01260000000DJM6AAO' //Huthwaite - Partner/BU Accounts (don't use for this recordtype per Brad)
        //,'01230000000DHVLAA4' //ESI - Customer Accounts (Case 14672 - Jeff Lup 2010.03.11) (disabled per Case 20867 - Jeff Lup 2010.04.29)
        ,'01230000000DHxyAAG' //ESI - Target Accounts (Case 14672 - Jeff Lup 2010.03.11)
        ,'01260000000DVat' //IBI Academic - Accounts (Case 15432 - Shay Spoonmore 2010.04.27)
        ,'01260000000DVay' //IBI Commercial - Accounts (Case 15432 - Shay Spoonmore 2010.04.27)
        ,'01260000000Dcsb' //IBI Agra Spex - Account (Case 15432 - Shay Spoonmore 2010.04.28)
        ,'01260000000DKB9' //Forum - Customer/Prospect Account (Case 25551 - Jeff Lup - 2010.06.17)
        ,'01260000000DKBE' //Forum - Partner/Informa BU Account (Case 25551 - Jeff Lup - 2010.06.17)
        ,'01260000000DKBJ' //Forum - Vendor/Other Account (Case 25551 - Jeff Lup - 2010.06.17)
        ,'01260000000DJ5UAAW' //AchieveGlobal - Customer/Prospect Account (CASE 38135 Shay Spoonmore 2011.04.25)
        ,'01260000000J1daAAC' //AchieveGlobal Account BC (WRQ0024665 Shay Spoonmore 2012.04.26)
        ,'01260000000J1dfAAC' //AchieveGlobal Location Account (WRQ0024665 Shay Spoonmore 2012.04.26)
        ,'01260000000DJDnAAO' //IIR UK Exhibitions - Accounts (CHG0053289 Hailey Niemand 2013.09.25)
        };  
        
    Set<Id> otherRtIds = MiscFunctions.getRecordtypeIds('Account', 'Greenfield Accounts');
    
    Set<ID> itmRecordTypes = new Set<ID>{ //CHG0053969 
        '01260000000DYv6AAG' //ITM - Accounts
        ,'01260000000J14mAAC' //Ovum Accounts
    };

    // no bulk processing; will only run from the UI since a manual "copy" process
        if (Trigger.new.size() == 1) {
            
        for (Account a : Trigger.new) {
            
            if (casRecordTypes.contains(a.RecordTypeId) || otherRtIds.contains(a.RecordTypeId)) {
                CopyCountryFromPickList.AccountCountry(Trigger.new);
            
            //CHG0053969 ITM Accounts and Ovum Accounts
            } else if (itmRecordTypes.contains(a.RecordTypeId)) {
                 //MAILING Address
                if ((trigger.isInsert || a.Mailing_Country_List__c != trigger.old[0].Mailing_Country_List__c) && a.Mailing_Country_List__c != null) {
                    a.BillingCountry = a.Mailing_Country_List__c;
                }
                if ((trigger.isInsert || a.Mailing_State_List__c != trigger.old[0].Mailing_State_List__c) && a.Mailing_State_List__c != null) {
                    a.BillingState = a.Mailing_State_List__c;
                }
            }
        }
    }       
}
*/

Map<Id,Map<String,String>> mapRtsToRun = MiscFunctions.triggerEnabledRecordtypesWithParams('CountryAccountTrigger');
system.debug('hailey 1: ' + mapRtsToRun );
    if (mapRtsToRun.containsKey(trigger.new[0].recordtypeid)) {
        system.debug('hailey 2');
        // no bulk processing; will only run from the UI since a manual "copy" process
        if (Trigger.new.size() == 1) {
            
            for (Account a : Trigger.new) {
            
            string business = mapRtsToRun.get(a.recordtypeid).get('Business');
                
                if (business == null || business == 'Other') {
                      CopyCountryFromPickList.AccountCountry(Trigger.new);
                
                } else if (business == 'ITM') {
                     //MAILING Address
                    if ((trigger.isInsert || a.Mailing_Country_List__c != trigger.old[0].Mailing_Country_List__c) && a.Mailing_Country_List__c != null) {
                        a.BillingCountry = a.Mailing_Country_List__c;
                    }
                    if ((trigger.isInsert || a.Mailing_State_List__c != trigger.old[0].Mailing_State_List__c) && a.Mailing_State_List__c != null) {
                        a.BillingState = a.Mailing_State_List__c;
                    }
                }
            }
        }       
    }
    
    if(trigger.isUpdate){
        Id thirdPartyRTID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Third Party Account Request').getRecordTypeId();
        Id tnfRTID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        Map<Id, Account> trigOldMap = Trigger.oldMap;
        List<ID> approvedAccountIDList = new List<ID>();
        List<Account_Request_Details__c> newARDList = new List<Account_Request_Details__c>();
        List<Platform_Role__c> exPlatformRoleList = new List<Platform_Role__c>();
        List<Account_Request_Log__c> listARL = new List<Account_Request_Log__c>();
        List<Account> triggerAccountList = [SELECT Id, CreatedDate, Name, Source_of_Account__c, CreatedBy.Name, RecordTypeId, Onboarding_Status__c, Account_Status__c  FROM Account WHERE Id IN :trigger.newMap.keySet()];
        for(Account updatedAcc : triggerAccountList){
            Account oldAccountRecord = trigOldMap.get(updatedAcc.id);
            if(updatedAcc.RecordTypeId == tnfRTID && oldAccountRecord.RecordTypeId == thirdPartyRTID){
                approvedAccountIDList.add(updatedAcc.id);
                Account_Request_Details__c thisARD = new Account_Request_Details__c ();
                thisARD.Account__c = updatedAcc.id;
                thisARD.Requested_Date__c = updatedAcc.CreatedDate;
                thisARD.Request_Account_Name__c = updatedAcc.Name;
                thisARD.Source_of_Account__c = updatedAcc.Source_of_Account__c;
                thisARD.Request_CreatedBy__c = updatedAcc.CreatedBy.Name;
                newARDList.add(thisARD);
            }
            
        }
        if(approvedAccountIDList != null && approvedAccountIDList.size() > 0 && RecursiveTriggerHandler.isFirstTime){
            RecursiveTriggerHandler.isFirstTime = false;
            String newBPRecId;
            List<Contact> updateContactList = [Select Id, FirstName, title, Phone, LastName, AccountId, Email, Account.BillingStreet, Account.VAT_Number__c, Account.Tax_Number_Category__c, Account.BillingCity, Account.Mailing_State_List__c,Account.Mailing_Country_List__c,Account.BillingPostalCode, Account.Source_of_Account__c, Account.Customer_Id__c,Account.Request_BP_Number__c,Account.Create_BP__c from Contact where AccountId IN: approvedAccountIDList];
            System.debug('updateContactList'+updateContactList);
            if(updateContactList != null && updateContactList.size() > 0 ){
                
				List<Platform_Role__c> platformRoleList = new List<Platform_Role__c>();
                exPlatformRoleList = [Select Id, Roles__c ,Platform__c , Contact__c , Account__c  from Platform_Role__c where Account__c IN: approvedAccountIDList];
                if(updateContactList[0].Account.Create_BP__c == null || updateContactList[0].Account.Create_BP__c == true){
                String country = updateContactList[0].Account.Mailing_Country_List__c;
                Country__c countryCode = [SELECT Country_2__c, Name FROM Country__c where Name =:country];
                
                for(Contact thisContact : updateContactList){
                    String jsonStringBody = '';
                    jsonStringBody+='{';
                    jsonStringBody+='"houseNumber": "",';
                    jsonStringBody+='"addressLine1": "'+ thisContact.Account.BillingStreet +'",';
                    jsonStringBody+='"addressLine2": "",';
                    jsonStringBody+='"addressLine3": "",';
                    jsonStringBody+='"city": "' + thisContact.Account.BillingCity + '",'; 
                    jsonStringBody+='"state":"'+ thisContact.Account.Mailing_State_List__c +'",';
                    jsonStringBody+='"country": "'+ thisContact.Account.Mailing_Country_List__c +'",';
                    jsonStringBody+='"countryCode": "'+countryCode+'",';
                    if(thisContact.Account.BillingPostalCode == null || thisContact.Account.BillingPostalCode == '' || thisContact.Account.BillingPostalCode == 'Not Available' ) {
                    		jsonStringBody+='"postalCode": "",';  
                    	}else {
                        	jsonStringBody+='"postalCode": "'+ thisContact.Account.BillingPostalCode +'",';
                    	}
                    jsonStringBody+='"addressType": "ORGANISATION",';
                    jsonStringBody+='"contactType": "",';
                    jsonStringBody+='"firstName": "'+ thisContact.FirstName +'",';
                    jsonStringBody+='"lastName": "'+ thisContact.LastName +'",';
                    jsonStringBody+='"title": "'+ thisContact.title+'",';
                    jsonStringBody+='"emailAddress": "'+thisContact.Email+'",';
                    jsonStringBody+='"telephone" : "'+ thisContact.Phone +'",';
                    jsonStringBody+='"bpPartnerFunction": "SP",';
                    jsonStringBody+='"bpBusinessPartnerCategory" : "2",';
                    if(thisContact.Account.VAT_Number__c != null) {
                    	jsonStringBody+='"taxRegistrationNumber": "'+ thisContact.Account.VAT_Number__c +'",';  
                    } else {
                        jsonStringBody+='"taxRegistrationNumber": "",'; 
                    }
                    if(thisContact.Account.Tax_Number_Category__c != null){
                        jsonStringBody+='"taxNumberCategory": "'+ thisContact.Account.Tax_Number_Category__c +'",';
                    }else{
                        jsonStringBody+='"taxNumberCategory": "",';
                    }
                    if(thisContact.Account.Request_BP_Number__c  != null || thisContact.Account.Request_BP_Number__c != ''){
                        jsonStringBody+='"bpNumber": "'+thisContact.Account.Request_BP_Number__c +'",';
                    }
                    jsonStringBody+='"source": "'+ thisContact.Account.Source_of_Account__c +'",';
                    jsonStringBody+='"addressUseType": "Account Billing"';
                    jsonStringBody+='}';
                    if(exPlatformRoleList != null && exPlatformRoleList.size() > 0){
                        for(Platform_Role__c thisPR : exPlatformRoleList){
                            if(!(thisPR.Account__c == thisContact.AccountId && thisPR.Contact__c == thisContact.id)){
                                Platform_Role__c thisPlatformRole = new Platform_Role__c();
                                thisPlatformRole.Account__c = thisContact.AccountId;
                                thisPlatformRole.Contact__c = thisContact.id;
                                thisPlatformRole.Roles__c = 'librarian_admin';
                                platformRoleList.add(thisPlatformRole);
                                System.debug('platformRoleList 1:'+platformRoleList);
                            }    
                        }    
                    }else{
                        Platform_Role__c thisPlatformRole = new Platform_Role__c();
                        thisPlatformRole.Account__c = thisContact.AccountId;
                        thisPlatformRole.Contact__c = thisContact.id;
                        thisPlatformRole.Roles__c = 'librarian_admin';
                        platformRoleList.add(thisPlatformRole);  
                        System.debug('platformRoleList 2:'+platformRoleList);
                    }
                    
                    String resp = SAP_BP_Service.processRequest(jsonStringBody, '/'+thisContact.Account.Customer_Id__c+'/generateBP/');
                    System.debug('resp'+resp);	
                    SAP_BP_Service_Response sapBPResponse = (SAP_BP_Service_Response) JSON.deserialize(resp, SAP_BP_Service_Response.class); 
                    if(sapBPResponse != null && sapBPResponse.status == 'Success' && sapBPResponse.objectData != null && sapBPResponse.objectData.salesforceRecordId != null){
                    	if(newBPRecId == null)
                        	newBPRecId = sapBPResponse.objectData.salesforceRecordId;
                        else
                            newBPRecId = newBPRecId + ',' + sapBPResponse.objectData.salesforceRecordId;
                    }           
                }
            }
                if(platformRoleList != null && platformRoleList.size() > 0){
                    System.debug('platformRoleList : '+platformRoleList);
                    System.debug('platformRoleList size:'+platformRoleList.size());
                    Database.SaveResult[] resultList = Database.insert(platformRoleList, false);
                }
            }
            if(newARDList != null && newARDList.size() > 0){
                System.debug('newARDList : '+newARDList);
                System.debug('newARDList size:'+newARDList.size());
                Database.SaveResult[] resultList = Database.insert(newARDList, false);
            }
            List<Account_Approval_Notification__e> listOfAAN = new List<Account_Approval_Notification__e>();

        	for(Account updatedAcc : trigger.new){
            	Account oldAccountRecord = trigOldMap.get(updatedAcc.id);
            	if(updatedAcc.RecordTypeId == tnfRTID && oldAccountRecord.RecordTypeId == thirdPartyRTID){
                	updatedAcc.VAT_Number__c = '';
                	updatedAcc.Tax_Number_Category__c = '';
                	if(updatedAcc.Source_of_Account__c == 'OA' || updatedAcc.Source_of_Account__c == 'ebook-intermediaries'){
                    	Account_Approval_Notification__e thisEvent = new Account_Approval_Notification__e ();
                    	thisEvent.Account_ID__c = updatedAcc.id;
                    	thisEvent.Party_ID__c = updatedAcc.Customer_Id__c;
                    	thisEvent.Request_ID__c = updatedAcc.id;
                        thisEvent.BP_Record_ID__c = newBPRecId;
                        System.debug('CountryAccountTrigger Event : '+thisEvent);
                    	listOfAAN.add(thisEvent);
                	}
            	}
                                
        	}
            if(listARL != null && listARL.size() > 0){
            	Database.SaveResult[] resultList = Database.update(listARL, false);
            }
        	List<Database.SaveResult> eventResults = EventBus.publish(listOfAAN);
            System.debug('eventResults '+ eventResults);
    	}/*
        if(trigger.isAfter){
            for(Account updatedAcc : trigger.new){
                Account oldAccountRecord = trigOldMap.get(updatedAcc.id);
                System.debug('Source_of_Account__c' + updatedAcc.Source_of_Account__c);
                System.debug('RecordTypeId' + updatedAcc.RecordTypeId);
                System.debug('old Onboarding_Status__c' + oldAccountRecord.Onboarding_Status__c);
                System.debug('new Onboarding_Status__c' + updatedAcc.Onboarding_Status__c);
                System.debug('new Account_Status__c' + updatedAcc.Account_Status__c);
                System.debug('old Account_Status__c' + oldAccountRecord.Account_Status__c);

            if(updatedAcc.Source_of_Account__c == 'OA' && updatedAcc.RecordTypeId == thirdPartyRTID && oldAccountRecord.Onboarding_Status__c =='IP Validation Done'&& updatedAcc.Onboarding_Status__c =='Rejected' && oldAccountRecord.Account_Status__c == 'Submit for Approval' && updatedAcc.Account_Status__c == 'Rejected' ){
                	String emailBody;
                    Account_Request_Log__c thisARL = [Select Request_ID__c,Request_JSON__c from Account_Request_Log__c where Request_ID__c =: updatedAcc.id];
                    emailBody = thisARL.Request_JSON__c;
                    //String emailAddress = 'APC@tandf.co.uk';
                    String emailAddress = 'radhikay.banerjee@informa.com';
                     System.debug('Email address: ' +emailAddress);
                     Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                     message.toAddresses = new String[] { emailAddress};
                     message.subject = 'OA Customer Onboarding Request DENIED';
                     message.plainTextBody = 'A request for onboarding an OA customer has been denied. This is because not enough information was provided to fulfil the request. Please contact the customer directly to request additional information. Submitted details: ' + emailBody;
                     Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                     Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                    System.debug('results'+results);
                     if (results[0].success){
                     	System.debug('The email was sent successfully.');
                        thisARL.Status__c = 'REJECTED BY CRM';
                        listARL.add(thisARL);
                     } else{
                        System.debug('The email failed to send: ' + results[0].errors[0].message);
                     }   
                }
            }
        }*/
    }
}