public class TF_AccountEnrichmentApexController {
    Static String primaryURL = 'PD';
    Static String country_code = null;
    public class RinggoldException extends Exception {}
    public class FieldData {        
        @AuraEnabled
        public String fieldName ;
        @AuraEnabled
        public String fieldAPIName ;        
        @AuraEnabled
        public String sFData ;        
        @AuraEnabled
        public boolean isEqualData ;        
        @AuraEnabled
        public String ringGoldData ;
        }
    public class DataValueRec {        
        @AuraEnabled
        public boolean isEqualData ;
        @AuraEnabled
        public String fieldAPIName ;
        }

        public class RingGoldResponse {        
        public Integer ringgold_id;
        public String name ; 
        public String body_type ; 
        public String post_code ;
        public String org_type ; 
        public Place place ;
        public ConsortiaMembers[] consortia_members  ; 
        public Url[] urls  ;
        public Classifications  classifications ;
        public Data[] data ;
        public Identifiers[]  identifiers ; 
        public Altnames[] alt_names  ; 
    } 
    public class Place { 
        public String language;
        public String city ;
        public String state ;
        public String country_code  ;
        }
    public class ConsortiaMembers { 
        public Integer memberRinggoldId   ;
        public String name   ;
        }
    public class Url {        
        @AuraEnabled
        public String url;
        @AuraEnabled
        public String type ;
        }
    public class Classifications {        
        @AuraEnabled
        public String rg_tier ;
        @AuraEnabled
        public String sfj_tier ;
        @AuraEnabled
        public Carnegie carnegie;
        }
    public class Data {        
        @AuraEnabled
        public Integer size   ;
        @AuraEnabled
        public Integer staff   ;
        }
     public class Carnegie {        
        @AuraEnabled
        public String SizeSet2015   ;
        @AuraEnabled
        public String BASIC2015   ;
        }
     public class Identifiers {        
        @AuraEnabled
        public String athens ;
        @AuraEnabled
        public String ipeds  ;
        @AuraEnabled
        public String isni ;
        @AuraEnabled
        public String nacs  ;
        @AuraEnabled
        public String nces ;
        @AuraEnabled
        public String ofr  ;
        }
     public class Altnames {        
        @AuraEnabled
        public String name  ;
        @AuraEnabled
        public String altType  ;
        @AuraEnabled
        public Place place ; 
        }
    @AuraEnabled
    public static List <FieldData> getCalloutResponseContents(String recordId, String ringgoldId) {
        List <FieldData> fieldaDataList = null;
        Account acc = [select Id, Name, Onboarding_Status__c, Ringgold_Account_ID__c from Account where id =: recordId];
        if(ringgoldId == null || ringgoldId == 'null' ){
            ringgoldId = returnRinggoldId(recordId);
            System.debug('acc.Onboarding_Status__c:'+acc.Onboarding_Status__c);
        }else{
            acc.Ringgold_Account_ID__c = ringgoldId;
            acc.Onboarding_Status__c = 'RingGold Identified';
        }
        System.debug('ringgoldId:'+ringgoldId);
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        String uri = (String) orgSpecificProps.get('RingGold_Api_Endpoint__c');
        String methodType = 'GET';
        Map<String, String> headers = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        HttpResponse res = TF_PlatformExecuter.execute(uri+ringgoldId, methodType, 'idtoken', null, headers, false);
        system.debug('response:' + res);
        if(res.getStatusCode() == 200){
            // Deserialize the JSON string into collections of primitive data types.
        	RingGoldResponse resultsList1 = (RingGoldResponse) JSON.deserialize(res.getBody(), RingGoldResponse.class);
        	system.debug('resultsList-->' + resultsList1);
        	fieldaDataList = mapResponseToFields(resultsList1,recordId);
        }
        if(acc.id != null){
            update acc;
        }
        return fieldaDataList;
    }

    public static List<FieldData> mapResponseToFields(RingGoldResponse response, String accId) { 
        List<FieldData> fieldDataList = new List<FieldData>();
        List<Country__c> BillingCountryCode = null;
        String tierValue = null;
        String country_code = response.place.country_code;
        List<Account> accountList = [SELECT Name, BillingCity,BillingPostalCode, BillingCountry, Mailing_State_List__c, Category__c, Legal_SubCategory__c, Known_As__c, NumberOfEmployees, Enrollment__c, Tier__c, JISC_Tier__c, Carnegie__c, Website FROM Account WHERE id =: accId];
        if(country_code != null){
        	BillingCountryCode = [SELECT Country_2__c,Name FROM Country__c WHERE Country_2__c =: country_code];      
  		}
        Schema.sObjectType objType = Account.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        list<Schema.PicklistEntry> values = fieldMap.get('Tier__c').getDescribe().getPickListValues();
        List<SelectOption> options = new List<SelectOption>();
        for (Schema.PicklistEntry v : values){
            String thisValue = String.valueOf(v.getLabel());
            if(response.classifications != null && response.classifications.rg_tier != null && thisValue.startsWith(String.valueOf(response.classifications.rg_tier))){
                tierValue = thisValue;
            }  
        }
        if(response != null){
            FieldData newFieldData1 = new FieldData();
            newFieldData1.fieldName = 'Name';
            newFieldData1.fieldAPIName = 'Name';
            newFieldData1.sFData = accountList[0].Name;
            newFieldData1.ringGoldData = response.Name;
            if((accountList[0].Name).equalsIgnoreCase(response.Name)){
                newFieldData1.isEqualData = true;
            }else{
                newFieldData1.isEqualData = false;
            }
            fieldDataList.add(newFieldData1);
    
            FieldData newFieldData2 = new FieldData();
            newFieldData2.fieldName = 'Mailing City';
            newFieldData2.fieldAPIName = 'BillingCity';
            newFieldData2.sFData = accountList[0].BillingCity;
            if(response.place != null){
                newFieldData2.ringGoldData = response.place.city;
            }
            else{
                newFieldData2.ringGoldData = '';
            }
            if((accountList[0].BillingCity == null && ((response.place == null) || response.place != null && response.place.city == null)) || ((accountList[0].BillingCity != null) && (response.place != null && response.place.city != null) && (accountList[0].BillingCity).equalsIgnoreCase(response.place.city))){
                newFieldData2.isEqualData = true;
            }else{
                newFieldData2.isEqualData = false;
            }
            fieldDataList.add(newFieldData2);
    
            FieldData newFieldData3 = new FieldData();
            newFieldData3.fieldName = 'Mailing Zip Code';
            newFieldData3.fieldAPIName = 'BillingPostalCode';
            newFieldData3.sFData = accountList[0].BillingPostalCode;
            newFieldData3.ringGoldData = response.post_code;
            if((accountList[0].BillingPostalCode == null && response.post_code == null) || (accountList[0].BillingPostalCode != null && response.post_code != null && (accountList[0].BillingPostalCode).equalsIgnoreCase(response.post_code))){
                newFieldData3.isEqualData = true;
            }else{
                newFieldData3.isEqualData = false;
            }
            fieldDataList.add(newFieldData3);
    
            FieldData newFieldData4 = new FieldData();
            newFieldData4.fieldName = 'Mailing State List';
            newFieldData4.fieldAPIName = 'Mailing_State_List__c';
            newFieldData4.sFData = accountList[0].Mailing_State_List__c;
            if(response.place != null){
                newFieldData4.ringGoldData = response.place.state;
            }
            else{
                newFieldData4.ringGoldData = '';
            }
            
            if((accountList[0].Mailing_State_List__c == null && (response.place == null || (response.place != null && response.place.state == null))) || accountList[0].Mailing_State_List__c != null && response.place != null && response.place.state != null && (accountList[0].Mailing_State_List__c).equalsIgnoreCase(response.place.state)){
                newFieldData4.isEqualData = true;
            }else{
                newFieldData4.isEqualData = false;
            }
            fieldDataList.add(newFieldData4);
    
            FieldData newFieldData5 = new FieldData();
            newFieldData5.fieldName = 'Mailing Country';
            newFieldData5.fieldAPIName = 'BillingCountry';
            newFieldData5.sFData = accountList[0].BillingCountry;
            if(response.place != null && BillingCountryCode != null && BillingCountryCode.size()>0){
                newFieldData5.ringGoldData = BillingCountryCode[0].name;
            }
            else{
                newFieldData5.ringGoldData = '';
            }
            
            if((accountList[0].BillingCountry == null && (response.place == null || (response.place != null && response.place.country_code == null))) || accountList[0].BillingCountry != null && response.place != null && response.place.country_code != null && BillingCountryCode != null && BillingCountryCode.size()>0 && (accountList[0].BillingCountry).equalsIgnoreCase(BillingCountryCode[0].name)){
                newFieldData5.isEqualData = true;
            }else{
                newFieldData5.isEqualData = false;
            }
            fieldDataList.add(newFieldData5);

            FieldData newFieldData6 = new FieldData();
            newFieldData6.fieldName = 'Category';
            newFieldData6.fieldAPIName = 'Category__c';
            newFieldData6.sFData = accountList[0].Category__c;
            if(response.org_type != null){
                if((response.org_type).contains('/')){
                    newFieldData6.ringGoldData = (response.org_type).substringBefore('/');
                }else{
                    newFieldData6.ringGoldData = (response.org_type);
                }
                
            }else{
                newFieldData6.ringGoldData = '';
            }
            
            if((accountList[0].Category__c == null && (response.org_type == null || (response.org_type).substringBefore('/') == null)) || (accountList[0].Category__c != null && response.org_type!= null && (response.org_type).substringBefore('/') != null && (accountList[0].Category__c).equalsIgnoreCase((response.org_type).substringBefore('/')))){
                newFieldData6.isEqualData = true;
            }else{
                newFieldData6.isEqualData = false;
            }
            fieldDataList.add(newFieldData6);
    
            FieldData newFieldData7 = new FieldData();
            newFieldData7.fieldName = 'Legal SubCategory';
            newFieldData7.fieldAPIName = 'Legal_SubCategory__c';
            newFieldData7.sFData = accountList[0].Legal_SubCategory__c;
            if(response.org_type != null){
                if((response.org_type).contains('/')){
                    newFieldData7.ringGoldData = (response.org_type).substringAfter('/');
                }else{
                    newFieldData7.ringGoldData = '';
                }
                
            }else{
                newFieldData7.ringGoldData = '';
            }
            
            if((accountList[0].Legal_SubCategory__c == null && (response.org_type == null || (response.org_type).substringAfter('/') == null)) || (accountList[0].Legal_SubCategory__c != null && response.org_type!= null && (response.org_type).substringAfter('/') != null && (accountList[0].Legal_SubCategory__c).equalsIgnoreCase((response.org_type).substringAfter('/')))){
                newFieldData7.isEqualData = true;
            }else{
                newFieldData7.isEqualData = false;
            }
            fieldDataList.add(newFieldData7);
    
            FieldData newFieldData8 = new FieldData();
            newFieldData8.fieldName = 'Known As';
            newFieldData8.fieldAPIName = 'Known_As__c';
            newFieldData8.sFData = accountList[0].Known_As__c;
            if(response.alt_names != null && (response.alt_names).size() > 0){
                newFieldData8.ringGoldData = response.alt_names[0].name;
            }
            else{
                newFieldData8.ringGoldData = '';
            }
            
            if((accountList[0].Known_As__c == null && ((response.alt_names == null || (response.alt_names).size() == 0) || ((response.alt_names).size() > 0 && response.alt_names[0].name == null)))|| (accountList[0].Known_As__c != null && response.alt_names != null && (response.alt_names).size() > 0 && response.alt_names[0].name != null && (accountList[0].Known_As__c).equalsIgnoreCase(response.alt_names[0].name))){
                newFieldData8.isEqualData = true;
            }else{
                newFieldData8.isEqualData = false;
            }
            fieldDataList.add(newFieldData8);
            FieldData newFieldData9 = new FieldData();
            newFieldData9.fieldName = 'Employees';
            newFieldData9.fieldAPIName = 'NumberOfEmployees';
            newFieldData9.sFData = String.valueOf(accountList[0].NumberOfEmployees);
            if(response.data != null && (response.data).size() > 0 ){
                newFieldData9.ringGoldData = String.valueOf(response.data[0].staff);
            }
            else{
                newFieldData9.ringGoldData = '';
            }
            
            if((accountList[0].NumberOfEmployees == null && ((response.data == null || (response.data).size() == 0) || ((response.data).size() > 0 && response.data[0].staff == null))) || (accountList[0].NumberOfEmployees != null && (response.data)!= null && (response.data).size() > 0 && response.data[0].staff != null && (String.valueOf(accountList[0].NumberOfEmployees)).equalsIgnoreCase(String.valueOf(response.data[0].staff)))){
                newFieldData9.isEqualData = true;
            }else{
                newFieldData9.isEqualData = false;
            }
            fieldDataList.add(newFieldData9);
    
            FieldData newFieldData10 = new FieldData();
            newFieldData10.fieldName = 'Enrollment';
            newFieldData10.fieldAPIName = 'Enrollment__c';
            newFieldData10.sFData = String.valueOf(accountList[0].Enrollment__c);
            if(response.data != null && (response.data).size() > 0  ){
               newFieldData10.ringGoldData = String.valueOf(response.data[0].size);
            }
            else{
                newFieldData10.ringGoldData = '';
            }
            
            if((accountList[0].Enrollment__c == null && ((response.data == null || (response.data).size() == 0) || ((response.data).size() > 0 && response.data[0].size == null))) || (accountList[0].Enrollment__c != null && (response.data)!= null && (response.data).size() > 0 && response.data[0].size != null && (String.valueOf(accountList[0].Enrollment__c)).equalsIgnoreCase(String.valueOf(response.data[0].size)))){
                newFieldData10.isEqualData = true;
            }else{
                newFieldData10.isEqualData = false;
            }
            fieldDataList.add(newFieldData10);
    
            FieldData newFieldData11 = new FieldData();
            newFieldData11.fieldName = 'Tier';
            newFieldData11.fieldAPIName = 'Tier__c';
            newFieldData11.sFData = accountList[0].Tier__c;
            if(response.classifications != null ){
               newFieldData11.ringGoldData = response.classifications.rg_tier;
            }
            else{
                newFieldData11.ringGoldData = '';
            }
            
            if((accountList[0].Tier__c == null && ((response.classifications == null) || (response.classifications != null && response.classifications.rg_tier == null)) ) || accountList[0].Tier__c != null && response.classifications != null && response.classifications.rg_tier != null && (accountList[0].Tier__c).equalsIgnoreCase(tierValue)){
                newFieldData11.isEqualData = true;
            }else{
                newFieldData11.isEqualData = false;
            }
            fieldDataList.add(newFieldData11);

            FieldData newFieldData12 = new FieldData();
            newFieldData12.fieldName = 'JISC Tier';
            newFieldData12.fieldAPIName = 'JISC_Tier__c';
            newFieldData12.sFData = accountList[0].JISC_Tier__c;
            if(response.classifications != null ){
               newFieldData12.ringGoldData = response.classifications.sfj_tier;
            }
            else{
                newFieldData12.ringGoldData = '';
            }
            if((accountList[0].JISC_Tier__c == null && ((response.classifications == null) || (response.classifications != null && response.classifications.sfj_tier == null))) || accountList[0].JISC_Tier__c != null && response.classifications!= null && response.classifications.sfj_tier != null && (accountList[0].JISC_Tier__c).equalsIgnoreCase(response.classifications.sfj_tier)){
                newFieldData12.isEqualData = true;
            }else{
                newFieldData12.isEqualData = false;
            }
            fieldDataList.add(newFieldData12);
    
            FieldData newFieldData13 = new FieldData();
            newFieldData13.fieldName = 'Carnegie';
            newFieldData13.fieldAPIName = 'Carnegie__c';
            newFieldData13.sFData = accountList[0].Carnegie__c;
            if(response.classifications != null && response.classifications.carnegie != null){
               newFieldData13.ringGoldData = response.classifications.carnegie.BASIC2015;
            }
            else{
                newFieldData13.ringGoldData = '';
            }
            
            if((accountList[0].Carnegie__c == null && ( (response.classifications == null ) || (response.classifications != null && response.classifications.carnegie == null) || (response.classifications != null && response.classifications.carnegie != null && response.classifications.carnegie.BASIC2015 == null))) || accountList[0].Carnegie__c != null && response.classifications != null && response.classifications.carnegie != null && response.classifications.carnegie.BASIC2015 != null &&(accountList[0].Carnegie__c).equalsIgnoreCase(response.classifications.carnegie.BASIC2015)){
                newFieldData13.isEqualData = true;
            }else{
                newFieldData13.isEqualData = false;
            }
            fieldDataList.add(newFieldData13);
            if(response.urls != null && (response.urls).size() > 0 && response.urls[0].type == primaryURL){
                FieldData newFieldData14 = new FieldData();
                newFieldData14.fieldName = 'Website';
                newFieldData14.fieldAPIName = 'Website';
                newFieldData14.sFData = accountList[0].Website;
                if(response.urls != null && response.urls[0] != null){
                    newFieldData14.ringGoldData = response.urls[0].url;
                }
                else{
                    newFieldData14.ringGoldData = '';
                }
                
                if((accountList[0].Website == null && response.urls[0].url == null) || (accountList[0].Website != null && response.urls[0].url != null && (accountList[0].Website).equalsIgnoreCase(response.urls[0].url))){
                    newFieldData14.isEqualData = true;
                }else{
                    newFieldData14.isEqualData = false;
                }
                fieldDataList.add(newFieldData14);
            }  
        }else{
            return null;
        }
        
        return fieldDataList;
    }
        
    
    @AuraEnabled
    public static String returnRinggoldId(String accId) {
        List<FieldData> fieldDataList = new List<FieldData>();
        String tierValue = null;
        Account account = [SELECT  Name, Ringgold_Account_ID__c  FROM Account WHERE id =: accId];
        
        return String.valueOf(account.Ringgold_Account_ID__c);
    }
   @AuraEnabled
    public static void updateAccFields(String dataValueList, String recordId, String thisObjectList){
        
        Account account = [SELECT Name, BillingCity,BillingPostalCode, BillingCountry, Mailing_State_List__c, Category__c, Legal_SubCategory__c, Known_As__c, NumberOfEmployees, Enrollment__c, Tier__c, JISC_Tier__c, Carnegie__c, Website FROM Account WHERE id =: recordId];
        List<DataValueRec> changedFieldsList = (List<DataValueRec>) JSON.deserialize(dataValueList, List<DataValueRec>.class);
        List<FieldData> objectList = (List<FieldData>) JSON.deserialize(thisObjectList, List<FieldData>.class);
        System.debug('changedFieldsList:'+changedFieldsList);
        if(changedFieldsList != null && changedFieldsList.size() > 0){
            for(DataValueRec thisDV : changedFieldsList){
                for(FieldData thisFD : objectList){
                    if(thisDV.fieldAPIName == thisFD.fieldAPIName && thisDV.isEqualData){
                        String field = String.valueOf(thisFD.fieldAPIName);
                        if((field.equalsIgnoreCase('Enrollment__c') || field.equalsIgnoreCase('NumberOfEmployees') )){
                            if(thisFD.ringGoldData!= null && (thisFD.ringGoldData).isNumeric()){
                                account.put(field,Integer.valueOf(thisFD.ringGoldData));
                            }
                        }
                        else{
                            if(field.equalsIgnoreCase('Tier__c')){
                                Schema.sObjectType objType = Account.getSObjectType();
                                Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
                                map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
                                list<Schema.PicklistEntry> values = fieldMap.get('Tier__c').getDescribe().getPickListValues();
                                List<SelectOption> options = new List<SelectOption>();
                                for (Schema.PicklistEntry v : values){
                                    String thisValue = String.valueOf(v.getLabel());
                                    if(thisValue.startsWith(thisFD.ringGoldData)){
                                        account.put(field,thisValue);
                                    }  
                                }

                            }else{
                                account.put(field,thisFD.ringGoldData);
                            }
                            
                        }
                    }
                }
            }
        account.put('Onboarding_Status__c' ,'RingGold Enrichment Done');   
        System.debug('account : '+account);
        update account;
        }
    }
        

}