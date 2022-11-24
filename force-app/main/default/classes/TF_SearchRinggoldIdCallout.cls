public without sharing class TF_SearchRinggoldIdCallout {
    public class SearchRingGoldIdResponse {        
        public Metadata metadata ;
        public Data data ;
        public String err;
    }
    public class Metadata {        
        public String status ;
        public String message ;
        public String query ;
    }
    public class Data {        
        public Integer productCount ;
        public Organisations[] resultSet ;
        public double esMaxScore;
    }
    public class  Organisations {  
        public String country ; 
        public String[] alt_name;
        public String city ;  
        public String state ;
        public String institution_name ;     
        public Integer ringgold_id ;
        public String zip_code ; 
        public String es_doc_type;
        public Double es_score ;
    }
    public class RinggoldDataWrapper {        
        @AuraEnabled
        public Integer ringgoldId ;
        @AuraEnabled
        public String accountName ;        
        @AuraEnabled
        public String city ;  
        @AuraEnabled
        public String state ;
        @AuraEnabled
        public String zip_code  ;
        @AuraEnabled
        public String country   ;
        @AuraEnabled
        public Double match_percentage   ;
        }
    @AuraEnabled
    public static List <RinggoldDataWrapper> getUISearchRinggoldCalloutResponse(String name, String website, String city, String state, String country, String zipCode) {
        List <RinggoldDataWrapper> fDList = new List <RinggoldDataWrapper>();
        SearchRingGoldIdResponse searchRingGoldIdResponse = getSearchCalloutResponse(name, website, city, state, country, zipCode);
        if(searchRingGoldIdResponse != null){
           fDList = new List <RinggoldDataWrapper>();
            for(Organisations orgData : searchRingGoldIdResponse.data.resultSet){
                RinggoldDataWrapper newFieldData = new RinggoldDataWrapper();
                newFieldData.ringgoldId = orgData.ringgold_id;
                newFieldData.accountName = orgData.institution_name;
                newFieldData.city = orgData.city;
                newFieldData.state = orgData.state;
                newFieldData.zip_code = orgData.zip_code;
                newFieldData.country = orgData.country;
                newFieldData.match_percentage = orgData.es_score;
                fDList.add(newFieldData);
            }
            System.debug('fDList:'+fDList);
      }
        return fDList;
    }
    @AuraEnabled
    public static List <RinggoldDataWrapper> getSearchRinggoldCalloutResponse(String recordId) {
        List <RinggoldDataWrapper> fDList = null;
        Account accountData = [Select Name, website, BillingCity, BillingPostalCode, BillingCountry, Mailing_State_List__c, Known_As__c  From Account where id =:recordId];
        SearchRingGoldIdResponse searchRingGoldIdResponse = getSearchCalloutResponse(accountData.Name, accountData.website, accountData.BillingCity, accountData.Mailing_State_List__c, accountData.BillingCountry, accountData.BillingPostalCode );
        if(searchRingGoldIdResponse != null){
            fDList = new List <RinggoldDataWrapper>();
            for(Organisations orgData : searchRingGoldIdResponse.data.resultSet){
                RinggoldDataWrapper newFieldData = new RinggoldDataWrapper();
                newFieldData.ringgoldId = orgData.ringgold_id;
                newFieldData.accountName = orgData.institution_name;
                newFieldData.city = orgData.city;
                newFieldData.state = orgData.state;
                newFieldData.zip_code = orgData.zip_code;
                newFieldData.country = orgData.country;
                newFieldData.match_percentage = orgData.es_score;
                fDList.add(newFieldData);
            }
            System.debug('fDListItems:'+fDList);
            
          }
        return fDList;
        
    }
    @AuraEnabled
    public static SearchRingGoldIdResponse getSearchCalloutResponse(String institution_name, String website, String city, String state, String country, String zipCode) {
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        String uri = (String) orgSpecificProps.get('RingGold_Fuzzy_Api_Endpoint__c');
        String methodType = 'POST';
        Map<String, String> headers = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        String body = getRequestBody(institution_name, website, city, state, country, zipCode);
        HttpResponse res = TF_PlatformExecuter.execute(uri, methodType, 'idtoken', body, headers, false);
        system.debug('response:' + res.getBody());
        if(res.getStatusCode() == 200){
            // Deserialize the JSON string into collections of primitive data types.
            SearchRingGoldIdResponse searchRingGoldIdResponse = (SearchRingGoldIdResponse) JSON.deserialize(res.getBody(), SearchRingGoldIdResponse.class);
            system.debug('searchRingGoldIdResponse:' + searchRingGoldIdResponse);
            return searchRingGoldIdResponse;
        }else{
            return null;
        }
    }
    public static String getRequestBody(String institution_name, String website, String city, String state, String country, String zipCode){
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        String count = (String) orgSpecificProps.get('Search_Result_Limit__c'); 
        String body = '{"keyword":"","limit": '+count+',"offset":0,"scoreOffset":0.0,"sortCriteria":[{"type":"relevance","order":"desc","fields":["_score"]}],"advancedSearch": {"operator":"or","filters":[{"name":"institution_name","value":"'+institution_name+'","isFuzzy":"true"},{"name":"website_domain","value":"'+website+'","isRegex": "true"},{"name":"city","value":"'+ city+'"},{"name":"state","value":"'+state+'"},{"name":"zip_code", "value":"'+zipCode+'","isFuzzy": "true"  },{"name":"alt_name","value":"'+institution_name+'","isFuzzy": "true"}, {"name":"country","value":"'+country+'"}]},"outputFields":["ringgold_id","institution_name","city","state", "zip_code","alt_name", "country"]}';

        System.debug('body : '+body);
        //body = '{"keyword":"","limit": 10,"offset":0,"scoreOffset":0.0,"sortCriteria":[{"type":"relevance","order":"desc","fields":["_score"]}],"advancedSearch": {"operator":"or","filters":[
        return body;
    }
    
    @AuraEnabled
    public static String findDupAccount(String dataValueList){
        String finalMsg = null;
        List<RinggoldDataWrapper> selectedRecList = (List<RinggoldDataWrapper>) JSON.deserialize(dataValueList, List<RinggoldDataWrapper>.class);
        if(selectedRecList != null && selectedRecList.size() > 0){
            String selectedRinggoldId = String.valueOf(selectedRecList[0].ringgoldId);
            List<Account> dupAccount = [SELECT  Id, Ringgold_Account_ID__c  FROM Account WHERE Ringgold_Account_ID__c =: selectedRinggoldId];
            System.debug('dupAccount:'+dupAccount);
            if(dupAccount != null && dupAccount.size() > 0 ){
                string Url = System.URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/cmp/c__AccountDetailsComponent?c__recordId='+dupAccount[0].id;
                finalMsg = Url;
                return finalMsg;
            }else{
                return finalMsg;
            }
            
        }
        return finalMsg;
    }
    
    @AuraEnabled
    public static Account getAccountDetails(String recordId){
        Account thisAccount = null;
        if(recordId != null ){
            thisAccount = [SELECT  Id, Ringgold_Account_ID__c,Name,website, BillingCity,BillingPostalCode,BillingState, BillingCountry  FROM Account WHERE Id =: recordId];
        }
        return thisAccount;
    }
    
    @AuraEnabled
    public static void updateAccountStatus(String recordId, String dataValueList){
        List<Account> accList = new List<Account>();
        if(recordId != null ){
            Account thisAccount = new Account();
            thisAccount.id = recordId;
            thisAccount.Onboarding_Status__c = 'Rejected';
            accList.add(thisAccount);
            List<RinggoldDataWrapper> selectedRecList = (List<RinggoldDataWrapper>) JSON.deserialize(dataValueList, List<RinggoldDataWrapper>.class);
            if(selectedRecList != null && selectedRecList.size() > 0){
                String selectedRinggoldId = String.valueOf(selectedRecList[0].ringgoldId);
                Account dupAccount = [SELECT  Id, Customer_Id__c, Ringgold_Account_ID__c, Mailing_Country_List__c, Mailing_State_List__c, BillingStreet, BillingCity , BillingPostalCode FROM Account WHERE Ringgold_Account_ID__c =: selectedRinggoldId];
                System.debug('dupAccount' + dupAccount);
                String profileName = ([Select Name from Profile where Id =: userinfo.getProfileid()]).Name;
				if(profileName.contains('dove') || profileName.contains('Dove') || profileName.contains('DOVE')){
            		dupAccount.Is_Shared_With_Dove__c = true;
            	}else{
                	dupAccount.Is_Shared_With_T_F__c = true;    
            	}
                System.debug('accList : ' + accList);
                accList.add(dupAccount);
            }
            
            update accList;
        }
    }
    @AuraEnabled
    public static void updateThirdPartyAccountRejStatus(String recordId, String dataValueList){
        String newBPRecId;
        List<Account> accList = new List<Account>();
        List<Contact> accReqContactList = new List<Contact>();
        List<Contact> dupAccContactList = new List<Contact>();
        List<Contact> updateContactList = new List<Contact>();
        List<Contact> deleteContactList = new List<Contact>();
        List<Account_Approval_Notification__e> listOfAAN = new List<Account_Approval_Notification__e>();
		List<End_User_Access__c> updateIpList = new List<End_User_Access__c>();
        
        if(recordId != null ){
            List<RinggoldDataWrapper> selectedRecList = (List<RinggoldDataWrapper>) JSON.deserialize(dataValueList, List<RinggoldDataWrapper>.class);
            if(selectedRecList != null && selectedRecList.size() > 0){
                String selectedRinggoldId = String.valueOf(selectedRecList[0].ringgoldId);
                Account thisAccount = [SELECT  Id, Create_BP__c, CreatedDate, Name, CreatedBy.Name, Source_of_Account__c, Ringgold_Account_ID__c, Mailing_Country_List__c, Mailing_State_List__c, BillingStreet, BillingCity , BillingPostalCode FROM Account WHERE id =: recordId];
                thisAccount.Onboarding_Status__c = 'Rejected';
                accList.add(thisAccount);
                
                Account dupAccount = [SELECT  Id, Customer_Id__c, Ringgold_Account_ID__c, Mailing_Country_List__c, Mailing_State_List__c, BillingStreet, BillingCity , BillingPostalCode FROM Account WHERE Ringgold_Account_ID__c =: selectedRinggoldId];
                dupAccount.Source_of_Account__c = thisAccount.Source_of_Account__c;
                dupAccount.Onboarding_Status__c = 'Approved';
                String profileName = ([Select Name from Profile where Id =: userinfo.getProfileid()]).Name;
                System.debug('profileName : '+profileName);
				if(profileName.contains('dove') || profileName.contains('Dove') || profileName.contains('DOVE')){
            		dupAccount.Is_Shared_With_Dove__c = true;
            	}else{
                	dupAccount.Is_Shared_With_T_F__c = true;    
            	}
                accList.add(dupAccount);
                System.debug('accList : '+accList);
                TF_AddIPRangesCallout.getCalloutResponseContents(dupAccount.Customer_Id__c, thisAccount.id);
                //TF_AddIPRangesCallout.getCalloutResponseContents('100', thisAccount.id);
                update accList;
                List<End_User_Access__c> ipList = [Select Account__c,Description__c,Id,Status__c,Name,IP_Range__c FROM End_User_Access__c WHERE Account__c =: thisAccount.id ];
                if(ipList != null && ipList.size() > 0){
                    for(End_User_Access__c ip : ipList){
                        ip.Account__c = dupAccount.id;
                        updateIpList.add(ip);
                    }
                }
                
                Account_Request_Details__c thisARD = new Account_Request_Details__c ();
                thisARD.Account__c = dupAccount.id;
                thisARD.Requested_Date__c = thisAccount.CreatedDate;
                thisARD.Request_Account_Name__c = thisAccount.Name;
                thisARD.Source_of_Account__c = thisAccount.Source_of_Account__c;
                thisARD.Request_CreatedBy__c = thisAccount.CreatedBy.Name;
                insert thisARD;
                System.debug('=====recordId===== '+recordId);
				System.debug('======dupAccount.id======'+dupAccount.id);
                List<Contact> contactList = [SELECT  Id, Email, AccountId, FirstName,LastName,title, Account.VAT_Number__c, Account.Tax_Number_Category__c, phone,Account.Request_BP_Number__c,Account.Create_BP__c FROM Contact WHERE AccountId =:recordId OR AccountId =:dupAccount.id];
                System.debug('=====contactList===== '+contactList);
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
                System.debug('updateContactList'+updateContactList);
                System.debug('deleteContactList'+deleteContactList);
                System.debug('accReqContactList'+accReqContactList);
                if(accReqContactList != null && accReqContactList.size() > 0){
                    if(thisAccount.Create_BP__c == null || thisAccount.Create_BP__c == true){
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
        				//jsonStringBody+='"postalCode": "'+ thisAccount.BillingPostalCode +'",';
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
        				jsonStringBody+='"source": "'+ thisAccount.Source_of_Account__c +'",';
        				jsonStringBody+='"addressUseType": "Account Billing"';
        				jsonStringBody+='}';
                        System.debug('jsonStringBody'+jsonStringBody);
                        String resp = SAP_BP_Service.processRequest(jsonStringBody, '/'+dupAccount.Customer_Id__c+'/generateBP/');
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
                }
                if(thisAccount.Source_of_Account__c == 'OA'){
                	Account_Approval_Notification__e thisEvent = new Account_Approval_Notification__e ();
                    thisEvent.Account_ID__c = dupAccount.id;
                    thisEvent.Party_ID__c = dupAccount.Customer_Id__c;
                    thisEvent.Request_ID__c = thisAccount.id;
                    thisEvent.BP_Record_ID__c = newBPRecId;
                    listOfAAN.add(thisEvent);
               }
                if(thisAccount.Source_of_Account__c == 'ebook-intermediaries'){
                    
                	Account_Approval_Notification__e thisEvent = new Account_Approval_Notification__e ();
                    thisEvent.Account_ID__c = dupAccount.id;
                    thisEvent.Party_ID__c = dupAccount.Customer_Id__c;
                    thisEvent.Request_ID__c = thisAccount.id;
                    thisEvent.BP_Record_ID__c = newBPRecId;
                    listOfAAN.add(thisEvent);
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
                if(updateIpList != null && updateIpList.size()>0){
                    System.debug('updateIpList:'+updateIpList);
                    update updateIpList;
                }
                if(listOfAAN != null && listOfAAN.size() > 0){
                    List<Database.SaveResult> eventResults = EventBus.publish(listOfAAN);
                    System.debug('eventResults '+ eventResults);
                }
                
            }
        }
    }
}