@IsTest
private class Ztest_TF_PrePopulateRecords {
    
    static testMethod void testfetchAccDetails_ReturnAcc() {
        test.startTest();
        Account oAccount = zTEST_Shared.insertAccount(UserInfo.getUserId() );
        Account acc = TF_PrePopulateRecords.fetchAccDetails(oAccount.Id);
        System.assert(acc != null);
        test.stopTest();
    }   
    
    static testMethod void testfetchAccDetails_ReturnNull() {
        test.startTest();
        String str = '';
        Account acc = TF_PrePopulateRecords.fetchAccDetails(str);
        System.assert(acc == null);
        test.stopTest();
    } 
    
    //Updated by: Amit
    static testMethod void testfetchCampusDetails_ReturnAcc() {
        test.startTest();
        Campus__c camp = new Campus__c();
        camp.Name = 'test';       
        insert camp;                
        Campus__c acmp = TF_PrePopulateRecords.fetchCampusDetails(camp.Id);
        System.assert(acmp != null);
        test.stopTest();
    } 
    
    static testMethod void testfetchCampusDetails_ReturnNull() {
        test.startTest();        
        String str = '';
        Campus__c camp = TF_PrePopulateRecords.fetchCampusDetails(str);
        System.assert(camp == null);
        test.stopTest();
    }
    static testMethod void fetchCaseDetails_ReturnAcc() {
        test.startTest();
        Case cas = new Case();
        cas.Status = 'New';       
        insert cas;
        Map<String, String> fetchMapData = new Map<String, String>();
        fetchMapData = TF_PrePopulateRecords.fetchCaseDetails(cas.Id);
        System.assert(fetchMapData != null);
        test.stopTest();
    } 
    
    static testMethod void fetchCaseDetails_ReturnNull() {
        test.startTest();        
        String str = '';
        Map<String, String> fetchMapData = new Map<String, String>();
        fetchMapData = TF_PrePopulateRecords.fetchCaseDetails(str);
        System.assert(fetchMapData == null);
        test.stopTest();
    }       

   //Changes By Chetan
    
 static testMethod void fetchRecordTypeValues_ReturnRecId() {
        test.startTest();
        List<String> recordtypes = TF_PrePopulateRecords.fetchRecordTypeValues();
        System.assert(recordtypes != null);
        test.stopTest();
    }   
    
    
    static testMethod void getRecTypeId_ReturnRecId() {
        test.startTest();
        String fetchMapData;
        Campus__c oCamp = new Campus__c();
        oCamp.Name = 'test';       
        insert oCamp;
        
        fetchMapData  = TF_PrePopulateRecords.getRecTypeId('T&F - Contacts',oCamp.id);
        System.assert(fetchMapData  != null);
        test.stopTest();
    }   
    
    static testMethod void getRecTypeId_ReturnNull() {
        test.startTest();
        String fetchMapData;        
        fetchMapData  = TF_PrePopulateRecords.getRecTypeId('T&F - Contacts',NULL);
        System.assert(fetchMapData  == null);
        test.stopTest();
    }   
  
  
    //DF-992
    
     static testMethod void getRecTypeIdAndDepDetails_ReturnRecId() {
        test.startTest();
        String fetchMapData;   
        Department__c oDept = new Department__c();
        oDept.Name = 'test';       
        insert oDept;        
        fetchMapData  = TF_PrePopulateRecords.getRecTypeIdAndDepDetails('T&F - Contacts',oDept.id);
        System.assert(fetchMapData  != null);
        test.stopTest();
    }   
 
    static testMethod void getRecTypeIdAndDepDetails_ReturnNull() {
        test.startTest();        
        String str = '';
        String fetchMapData;             
        fetchMapData = TF_PrePopulateRecords.getRecTypeIdAndDepDetails('T&F - Contacts',NULL);
        System.assert(fetchMapData == null);
        test.stopTest();
    }     
    
    //DF-990
       
    static testMethod void fetchOppRecordTypeValues_ReturnRecId() {
        test.startTest();
        List<String> recordtypes = TF_PrePopulateRecords.fetchOppRecordTypeValues();
        System.assert(recordtypes != null);
        test.stopTest();
    }  
    
    
     static testMethod void getRecTypeIdAndOpportunityDetails_ReturnRecId() {
        test.startTest();        
        String str = '';
        String fetchMapData;    
        Department__c oDept = new Department__c();
        oDept.Name = 'test';       
        insert oDept;        
        fetchMapData = TF_PrePopulateRecords.getRecTypeIdAndOpportunityDetails('T&F - CAS Opportunity',oDept.id);
        System.assert(fetchMapData != null);
        test.stopTest();
    }     
    
    
    static testMethod void getRecTypeIdAndOpportunityDetails_ReturnNull() {
       test.startTest();        
       String str = '';
       String fetchMapData;              
       fetchMapData = TF_PrePopulateRecords.getRecTypeIdAndOpportunityDetails('T&F - CAS Opportunity',NULL);
       System.assert(fetchMapData == null);
       test.stopTest();
    }     
    
    
    //DF-988 & DF-989
    //
     static testMethod void getRecTypeIdCampus_ReturnRecId() {
        test.startTest();
        String fetchMapData;  
        Campus__c oCamp = new Campus__c();
        oCamp.Name = 'test';       
        insert oCamp;   
        fetchMapData = TF_PrePopulateRecords.getRecTypeIdCampus('T&F - CAS Opportunity',oCamp.id );
        System.assert(fetchMapData != null);
        test.stopTest();
    }  
        
     static testMethod void getContactRecTypeId_ReturnRecId() {
        test.startTest();
        String fetchMapData;  
        Contact oCont = new Contact();
        oCont.LastName = 'test';       
        insert oCont;   
        fetchMapData = TF_PrePopulateRecords.getContactRecTypeId('T&F - CAS Opportunity',oCont.id );
        System.assert(fetchMapData != null);
        test.stopTest();
    }  
    
    
     static testMethod void getOppRecTypeIdAndDepartmentDetails_ReturnRecId() {
        test.startTest();
        String fetchMapData;  
        Contact oCont = new Contact();
        oCont.LastName = 'test';       
        insert oCont;   
        fetchMapData = TF_PrePopulateRecords.getOppRecTypeIdAndDepartmentDetails('T&F - CAS Opportunity',oCont.id );
        System.assert(fetchMapData != null);
        test.stopTest();
    }  
   
        
//Changes By Chetan
        
       
}