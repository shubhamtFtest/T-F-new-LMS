/*** Modified by Amanica for case : 00957430**
***Modified on lines 110,118,119,120,178,179,180
******/

public class TF_PrePopulateRecords{
    
    @AuraEnabled        
    public static Account fetchAccDetails(String accId){
        List<Account> accLst = new List<Account>();
        if(String.isNotBlank(accId)){
            accLst = [Select Id,BillingStreet, BillingCity, Mailing_Country_List__c, Mailing_State_List__c, Phone, BillingPostalCode from Account where Id =: accId];
            Account acc = accLst[0];
            return acc;
            
        }
        return null;
    }
  
    //DF-993
    @AuraEnabled        
    public static Campus__c fetchCampusDetails(String campId){
        List<Campus__c> campLst = new List<Campus__c>();
        if(String.isNotBlank(campId)){
            campLst = [SELECT Id,Name, Mailing_Street__c, Mailing_City__c, Mailing_Country_List__c, Mailing_State_Province_List__c, Mailing_ZIP_Postal_Code__c, Phone__c, Account__c, Campus_ID__c FROM Campus__c where Id =: campId];
            Campus__c camp = campLst[0];
            return camp;
        }
        return null;
    }
    
    //DF-995
    @AuraEnabled        
    public static Map<String, String> fetchCaseDetails(String caseId){
        ContactIdWrapper cw; 
        if(String.isNotBlank(caseId)){
            Case caseLst = new Case();
            caseLst = [SELECT Id, SuppliedName, SuppliedEmail, SuppliedPhone, AccountId FROM Case where Id =: caseId LIMIT 1];                                            
            Map<String, String> fetchMapData = new Map<String, String>();
            fetchMapData.put('Id', caseLst.Id);
            fetchMapData.put('SuppliedName', caseLst.SuppliedName);
            fetchMapData.put('SuppliedEmail', caseLst.SuppliedEmail);
            fetchMapData.put('SuppliedPhone', caseLst.SuppliedPhone);
            fetchMapData.put('AccountId', caseLst.AccountId);
            
            cw = new ContactIdWrapper();
            for (Schema.RecordTypeInfo rtInfo : Contact.SObjectType.getDescribe().getRecordTypeInfos()) {
              if (rtInfo.isDefaultRecordTypeMapping()) {
                  cw.contactRecordId = rtInfo.getRecordTypeId();
                  fetchMapData.put('recordTypeId',rtInfo.getRecordTypeId());
              }
            } 
            return fetchMapData;
        }
        return null;
    }
    
    public class ContactIdWrapper{
        public String contactRecordId;
    }   
    
   
    //Updated By Chetan DF-991 & DF-992
    
    @AuraEnabled        
    public static List<String> fetchRecordTypeValues(){   

        List<Schema.RecordTypeInfo> recordtypes = Contact.SObjectType.getDescribe().getRecordTypeInfos(); 
        Map<Id, String> recordtypemap = new Map<Id, String>();   
       // recordtypemap = new Map<Id, String>();
        for(RecordTypeInfo rt : recordtypes){
            if(rt.getName() != 'Master' && rt.isAvailable())
                recordtypemap.put(rt.getRecordTypeId(), rt.getName());
        }        
        return recordtypemap.values();
    }
    
   @AuraEnabled
    public static String getRecTypeId(String recordTypeLabel, String campId){
        CampusDetailsWrapper campDetail = new CampusDetailsWrapper();

        campDetail.recordTypeId= Schema.SObjectType.Contact.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();        
        if(String.isNotBlank(campId)){
            Campus__c campLst = new Campus__c();
            campLst = [SELECT Id,Name, Mailing_Street__c,Mailing_Country_List__c,Mailing_State_Province_List__c,Account__c FROM Campus__c where Id =:campId limit 1];
            Map<String, String> fetchMapData = new Map<String, String>();
            campDetail.campusId =campLst.Id;
            campDetail.campusName =campLst.Name;
             campDetail.campusMailingStreet=campLst.Mailing_Street__c;
            campDetail.campusMailingCountry =campLst.Mailing_Country_List__c;
            campDetail.campusMailingState =campLst.Mailing_State_Province_List__c;
            campDetail.campusAccount =campLst.Account__c;
            campDetail.recordTypeId=campDetail.recordTypeId;   
                     
            
            return JSON.serialize(campDetail);
        }       
        return null;        
    }                                                    
    
     //DF-992
      
    
    @AuraEnabled
    public static String getRecTypeIdAndDepDetails(String recordTypeLabel, String depId){
        DepartmentDetailsWrapper depDetail = new DepartmentDetailsWrapper();

        depDetail.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();        
        if(String.isNotBlank(depId)){
            Department__c depLst = new Department__c ();
            depLst = [SELECT Id,Name,Mailing_Country_List__c,Mailing_State_Province_List__c,Account__c,Campus__c,Mailing_City__c,Mailing_Street__c, Mailing_ZIP_Postal_Code__c FROM Department__c where Id =:depId limit 1];

            depDetail.depId=depLst.Id;
            depDetail.depName=depLst.Name;                   
            depDetail.depMailingCountry=depLst.Mailing_Country_List__c;
            depDetail.depMailingState=depLst.Mailing_State_Province_List__c;
            depDetail.depAccount=depLst.Account__c;
            depDetail.depCampus=depLst.Campus__c;
           depDetail.depMailingCity=depLst.Mailing_City__c;
            depDetail.depMailingStreet=depLst.Mailing_Street__c;
            depDetail.depMailingPostalCode=depLst.Mailing_ZIP_Postal_Code__c ;
 
           
            depDetail.recordTypeId=depDetail.recordTypeId ;            
            
            return JSON.serialize(depDetail);

        }       
        return null;        
    }   
    
    
    //DF-990
    @AuraEnabled        
    public static List<String> fetchOppRecordTypeValues(){
        List<Schema.RecordTypeInfo> recordtypes = Opportunity.SObjectType.getDescribe().getRecordTypeInfos();    
        Map<Id, String> recordtypemap = new Map<Id, String>();
        for(RecordTypeInfo rt : recordtypes){
            if(rt.getName() != 'Master' && rt.isAvailable())
                recordtypemap.put(rt.getRecordTypeId(), rt.getName());
        }        
        return recordtypemap.values();
    }
    
    
     @AuraEnabled
    public static String  getRecTypeIdAndOpportunityDetails(String recordTypeLabel, String depId){
        DepartmentDetailsWrapper depDetail = new DepartmentDetailsWrapper();
        depDetail.recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();        
        
      if(String.isNotBlank(depId)){
            Department__c depLst = new Department__c ();
            depLst = [SELECT Id,Name,Mailing_Country_List__c,Mailing_State_Province_List__c,Account__c,Campus__c,Department_ID__c FROM Department__c where Id =:depId limit 1];

            depDetail.depId=depLst.id;
            //depDetail.depName=depLst.name;  
            depDetail.depName=depLst.Department_ID__c;         
            depDetail.depMailingCountry=depLst.Mailing_Country_List__c;
            depDetail.depMailingState=depLst.Mailing_State_Province_List__c;
            depDetail.depAccount=depLst.Account__c;
            depDetail.depCampus=depLst.Campus__c;
           
            depDetail.recordTypeId=depDetail.recordTypeId ;            
            
            return JSON.serialize(depDetail);

        }       
        return null;        
    }   
    
    
    public class DepartmentDetailsWrapper{
    
        public String recordTypeId;
        public String depId;
        public String depName;
        public String depMailingCountry;
        public String depMailingState;
        public String depMailingCity;
        public String depMailingStreet;
        public String depMailingPostalCode;
        public String depAccount;
        public String depCampus;     

        
        public DepartmentDetailsWrapper(){}
        
    }
    
    
    public class CampusDetailsWrapper{
    
        public String recordTypeId;
        public String campusId;
        public String campusName;
        public String campusMailingCountry;
        public String campusMailingState;
        public String campusAccount;
        public String campusMailingStreet;
       
        
        public CampusDetailsWrapper(){}
        
    }


 //DF-988 & DF-989 updated by chetan/Amanica
 
 //DF-988
    @AuraEnabled
    public static String getRecTypeIdCampus(String recordTypeLabel, String campusId){
        OpportunityDetails oppDetail = new OpportunityDetails();
        oppDetail.recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();
        Campus__c campObj = new Campus__c();
        campObj = [SELECT Id, Account__c FROM Campus__c WHERE id = :campusId];
        oppDetail.accountId = campObj.Account__c;
        oppDetail.campusId = campObj.Id;
        return JSON.serialize(oppDetail);
    }
    
    @AuraEnabled
    public static String getContactRecTypeId(String recordTypeLabel, String contactId){
        OpportunityDetails oppDetail = new OpportunityDetails();
        oppDetail.recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();
        Contact conObj = new Contact();
        conObj = [SELECT Id, AccountId, Campus__c, Department_Object__c FROM Contact WHERE id = :ContactId];
        oppDetail.accountId = conObj.accountId;
        oppDetail.campusId = conObj.Campus__c;
        oppDetail.departmentId = conObj.Department_Object__c;
        oppDetail.contactId=conObj.Id;
        
        return JSON.serialize(oppDetail);
    }
    
    @AuraEnabled
    public static String getOppRecTypeIdAndDepartmentDetails(String recordTypeLabel, String contactId){
        OpportunityDetails oppDetail = new OpportunityDetails();
        oppDetail.recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();
        Contact conObj = new Contact();
        conObj = [SELECT Id, AccountId, Campus__c, Department_Object__c FROM Contact WHERE id = :ContactId];
        oppDetail.accountId = conObj.accountId;
        oppDetail.campusId = conObj.Campus__c;
        oppDetail.departmentId = conObj.Department_Object__c;
        oppDetail.contactId=conObj.Id;
        return JSON.serialize(oppDetail);
    }
    
    public class OpportunityDetails{
    
        public String recordTypeId;
        public String accountId;
        public String campusId;
        public String departmentId;
        public String contactId;
        
        public OpportunityDetails(){}
        
    }


    
}