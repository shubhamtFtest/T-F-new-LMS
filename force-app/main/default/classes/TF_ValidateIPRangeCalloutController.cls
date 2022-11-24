public without sharing class TF_ValidateIPRangeCalloutController {
    public class IPValidateResponse {        
        public Metadata metadata ;
        public Data data ;
    }
    public class Metadata{
        public String status;
        public Message message;
    }
    public class Message{
        public String message;
    }
    public class Data{
        public Boolean isIpRangeExists;
        public String partyId;
    }
    public class DataWrapper { 
        @AuraEnabled
        public String sfid ;
        @AuraEnabled
        public String name ;
        @AuraEnabled
        public String description ;
        @AuraEnabled
        public String ipRange ;
        @AuraEnabled
        public String status ;
        @AuraEnabled
        public String errorMsg ;
        @AuraEnabled
        public String errorMsgURL ;
        @AuraEnabled
        public boolean allowReject ;
    }
    
    
    @AuraEnabled
    public static List<DataWrapper> getCalloutResponseContents(String recordId) {
        
        List<DataWrapper> dataWrapperList = new List<DataWrapper>();
        List<String> partyIdList = new List<String>();
        Boolean updateAccRecord = true;
        Id tnFRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        List<End_User_Access__c> accountIPList = [SELECT Name, Description__c, Account__c,Id,IP_Range__c FROM End_User_Access__c WHERE Account__c =: recordId];
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        String uri = (String) orgSpecificProps.get('IP_Validate_URL__c');
        String methodType = 'GET';
        Map<String, String> headers = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        try{
            System.debug('accountIPList:'+accountIPList);
            if(accountIPList != null && accountIPList.size() > 0){
                for(End_User_Access__c thisIP : accountIPList){
                    if(thisIP.IP_Range__c != null){
                        String ipStart = (thisIP.IP_Range__c).substringBefore(':');
                        String ipEnd =  (thisIP.IP_Range__c).substringAfter(':');
                        if(ipEnd == null || ipEnd == ''){
                            ipEnd = ipStart;
                        }
                        System.debug('ipStart:'+ipStart);
                        System.debug('ipEnd:'+ipEnd);
                        HttpResponse response = new HttpResponse();
                        if ( String.isNotBlank(uri) ) {
                            response = TF_PlatformExecuter.execute(uri+'ipStart='+ipStart+'&'+'ipEnd='+ipEnd, methodType, 'idtoken', null, headers, false);
                            //response =' {"metadata": {"status": "success","message": {}},"data": {"isIpRangeExists": true,"partyId": "100504"}}';
    
                        }
                        System.debug('uri:'+uri);
                        System.debug('response =====>' + response + 'body--->'+response.getBody());            
                        if ( response != null && response.getStatusCode() == 200 ) {
                            IPValidateResponse ipValidateResponse = (IPValidateResponse) JSON.deserialize(response.getBody(), IPValidateResponse.class);
                          //IPValidateResponse ipValidateResponse = (IPValidateResponse) JSON.deserialize(response, IPValidateResponse.class);
        
                        System.debug('response : '+ipValidateResponse);
                            System.debug('response data :'+ipValidateResponse.data);
                            if(ipValidateResponse.data != null){
                                DataWrapper data = new DataWrapper();
                                data.sfid = thisIP.id;
                                data.name = thisIP.Name;
                                data.description = thisIP.Description__c;
                                data.ipRange = thisIP.IP_Range__c;
                                if(!ipValidateResponse.data.isIpRangeExists){
                                    data.status = 'Success';
                                    data.errorMsg = null;
                                    data.errorMsgURL = null;
                                    data.allowReject = false;
                                }else{
                                    data.status = 'Failed';
                                    data.errorMsg = ipValidateResponse.data.partyId;
                                    data.allowReject = true;
                                    partyIdList.add(data.errorMsg);
                                }
                                dataWrapperList.add(data);
                            }
        
                        }
                        if ( response != null && response.getStatusCode() == 500 ) {
                            updateAccRecord = false;
                        }
                    }
                }
            }else{
                updateAccRecord = true;
            }
            if(partyIdList != null && partyIdList.size() > 0){
                Map<Id, Account> dupAccountMap = new Map<Id, Account>([Select Id, Name, Customer_Id__c from Account where Customer_Id__c  IN : partyIdList ]);
                if(dataWrapperList != null && dataWrapperList.size() > 0){
                    for(DataWrapper thisData : dataWrapperList){
                        if(thisData.status == 'Failed'){
                            updateAccRecord = false;
                            if(dupAccountMap != null && dupAccountMap.size() > 0){
                            	for(Account dupAcc : dupAccountMap.Values()){
                                    if(dupAcc.Customer_Id__c == thisData.errorMsg){
                                    	thisData.errorMsgURL = System.URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/cmp/c__AccountDetailsComponent?c__recordId='+dupAcc.id;
                                    	System.debug('Dup Account URL : '+thisData.errorMsgURL);
                                    }
                            	}   
                            }
                        }
                    }
                }
        	}
            if(updateAccRecord){
            	Account thisAcc = [Select id, CreatedDate, RecordTypeId, CreatedBy.Name, Source_of_Account__c, Name, Account_Status__c, Onboarding_Status__c, Ringgold_Account_ID__c from Account where id =: recordId];
                if(thisAcc != null){
                    if(String.isEmpty(thisAcc.Ringgold_Account_ID__c)){
                    	thisAcc.Onboarding_Status__c = 'IP Validation Done';
                    	update thisAcc;
                    	System.debug('Account Fields Updated'); 
                    }else{
                        String profileName = ([Select Name from Profile where Id =: userinfo.getProfileid()]).Name;
						if(profileName.contains('dove') || profileName.contains('Dove') || profileName.contains('DOVE')){
                           thisAcc.Is_Shared_With_Dove__c = true;
                        }else{
                           thisAcc.Is_Shared_With_T_F__c = true;    
                        }
                        thisAcc.Onboarding_Status__c = 'Approved';
                        thisAcc.Account_Status__c = 'Approved';
                        thisAcc.RecordTypeId = tnFRecordTypeId;
                    	update thisAcc;
                        System.debug('Account Fields and Record type Updated');
                        
                    } 
                }
           }
        }catch ( Exception ex ) {
            dataWrapperList = null;
            System.debug('*********** Exception :' + ex.getMessage());
        }
       
        System.debug('DataWrapperList: '+dataWrapperList);
        return dataWrapperList;
    }
    
    @AuraEnabled
    public static void updateThirdPartyAccountRejStatus(String recordId, String partyIdExAcc, String ipList){
        System.debug('ipList'+ipList);
        List<Account> accList = new List<Account>();
        List<Contact> accReqContactList = new List<Contact>();
        List<Contact> dupAccContactList = new List<Contact>();
        List<Contact> updateContactList = new List<Contact>();
        List<Contact> deleteContactList = new List<Contact>();
        List<End_User_Access__c> deleteIPList = new List<End_User_Access__c>();
        List<End_User_Access__c> updateIPList = new List<End_User_Access__c>();
        if(recordId != null ){
           // partyIdExAcc = partyIdExAcc.substring(1, partyIdExAcc.length()-1);
            System.debug('partyIdExAcc : '+partyIdExAcc);
            Account thisAccount = [SELECT  Id, Name, CreatedDate, CreatedBy.Name, Ringgold_Account_ID__c, Mailing_Country_List__c, Mailing_State_List__c, BillingStreet, BillingCity , BillingPostalCode, Source_of_Account__c FROM Account WHERE id =: recordId];
            thisAccount.Onboarding_Status__c = 'Rejected';
            accList.add(thisAccount);
            
            Account dupAccount = [SELECT  Id, Ringgold_Account_ID__c, Mailing_Country_List__c, Mailing_State_List__c, BillingStreet, BillingCity , BillingPostalCode, Customer_Id__c, Source_of_Account__c FROM Account WHERE Customer_Id__c =: partyIdExAcc];
            dupAccount.Source_of_Account__c = thisAccount.Source_of_Account__c;
            dupAccount.Onboarding_Status__c = 'Approved';
            String profileName = ([Select Name from Profile where Id =: userinfo.getProfileid()]).Name;
			if(profileName.contains('dove') || profileName.contains('Dove') || profileName.contains('DOVE')){
            	dupAccount.Is_Shared_With_Dove__c = true;
            }else{
                dupAccount.Is_Shared_With_T_F__c = true;    
            }
            accList.add(dupAccount);
            TF_AddIPRangesCallout.getCalloutResponseContents(dupAccount.Customer_Id__c, thisAccount.id);
            update accList;
            
            List<DataWrapper> ipRangeList = (List<DataWrapper>) JSON.deserialize(ipList, List<DataWrapper>.class);
            for(DataWrapper data : ipRangeList){
                if(data.status == 'Success'){
                    End_User_Access__c endUserAccess = new End_User_Access__c();
                    endUserAccess.id = data.sfid;
                    endUserAccess.Account__c = dupAccount.id;
                    updateIPList.add(endUserAccess);
                }
                if(data.status == 'Failed'){
                    End_User_Access__c dEndUserAccess = new End_User_Access__c();
                    dEndUserAccess.id = data.sfid;
                    deleteIPList.add(dEndUserAccess);
                }
            }
            //Create new Account Request Detail record for the rejected account.   
            Account_Request_Details__c thisARD = new Account_Request_Details__c ();
            thisARD.Account__c = dupAccount.id;
            thisARD.Requested_Date__c = thisAccount.CreatedDate;
            thisARD.Request_Account_Name__c = thisAccount.Name;
            thisARD.Source_of_Account__c = thisAccount.Source_of_Account__c;
            thisARD.Request_CreatedBy__c = thisAccount.CreatedBy.Name;
            insert thisARD;
            
            List<Contact> contactList = [SELECT  Id, Email, AccountId, FirstName,LastName,title, phone FROM Contact WHERE AccountId =:recordId OR AccountId =:dupAccount.id];
                for(Contact thisContact : contactList){
                    if(thisContact.AccountId == recordId){
                        accReqContactList.add(thisContact);
                    }else{
                        dupAccContactList.add(thisContact);
                    }
                }
                for(Contact thisContact : accReqContactList){
                    Boolean addConToUpdate = true;
                    for(Contact dupAccContact : dupAccContactList){
                        if(thisContact.Email == dupAccContact.Email){
                            addConToUpdate = false;
                        }
                    }
                    if(!addConToUpdate){
                        deleteContactList.add(thisContact);
                    }else{
                        thisContact.AccountId = dupAccount.id;
                        updateContactList.add(thisContact);
                    }
                }
            	if(accReqContactList != null && accReqContactList.size() > 0){
                    Country__c countryCode = [SELECT Country_2__c, Name FROM Country__c where Name =:thisAccount.Mailing_Country_List__c];
                    for(Contact thisContact : accReqContactList){
                        String jsonStringBody = '';
                        jsonStringBody+='{';
                        jsonStringBody+='"houseNumber": "",';
                        jsonStringBody+='"addressLine1": "'+ thisAccount.BillingStreet +'",';
                        jsonStringBody+='"addressLine2": "",';
                        jsonStringBody+='"addressLine3": "",';
                        jsonStringBody+='"city": "' + thisAccount.BillingCity + '",'; 
                        jsonStringBody+='"state":"'+ thisAccount.Mailing_State_List__c +'",';
                        jsonStringBody+='"country": "'+ thisAccount.Mailing_Country_List__c +'",';
                        jsonStringBody+='"countryCode": "'+countryCode+'",';
                        if(thisAccount.BillingPostalCode == null || thisAccount.BillingPostalCode == '' || thisAccount.BillingPostalCode == 'Not Available' ) {
                    		jsonStringBody+='"postalCode": "",';  
                    	}else {
                        	jsonStringBody+='"postalCode": "'+ thisAccount.BillingPostalCode +'",';
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
                        jsonStringBody+='"taxRegistrationNumber": "",';
                        jsonStringBody+='"taxNumberCategory": "",';
                        jsonStringBody+='"source": "'+ thisAccount.Source_of_Account__c +'",';
                        jsonStringBody+='"addressUseType": "Account Billing"';
                        jsonStringBody+='}';
                        String resp = SAP_BP_Service.processRequest(jsonStringBody, '/'+dupAccount.Customer_Id__c+'/generateBP/');
                        
                    }
                }
                if(updateContactList != null && updateContactList.size()>0){
                    System.debug('updatedContacts:'+updateContactList);
                    update updateContactList;
                    List<Platform_Role__c> platformRoleList = new List<Platform_Role__c>();
                    for(Contact thisContact : updateContactList){
                        Platform_Role__c thisPlatformRole = new Platform_Role__c();
                        thisPlatformRole.Account__c = thisContact.AccountId;
                        thisPlatformRole.Contact__c = thisContact.id;
                        thisPlatformRole.Roles__c = 'librarian_admin';
                        platformRoleList.add(thisPlatformRole);    
                    }
                    if(platformRoleList != null && platformRoleList.size() > 0){
                        System.debug('platformRoleList : '+platformRoleList);
                        System.debug('platformRoleList size:'+platformRoleList.size());
                        Database.SaveResult[] resultList = Database.insert(platformRoleList, false);
                    }
                }
            if(deleteContactList != null && deleteContactList.size()>0){
                System.debug('deletedContacts:'+deleteContactList);
                delete deleteContactList;
            }
            if(deleteIPList != null && deleteIPList.size() > 0){
            	    delete deleteIPList;
            }
            if(updateIPList != null && updateIPList.size() > 0){
                System.debug('updated IP Ranges:'+updateIPList);
                update updateIPList;
            }
        }
    }

}