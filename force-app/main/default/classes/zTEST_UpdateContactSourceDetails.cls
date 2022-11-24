/******************************************************************************************************************
* Name : zTEST_UpdateContactSourceDetails
* Purpose : Test class for TF_UpdateContactSourceDetails_Trig.
* Author : Sourabh Goyal
* Date : 09/09/2017
*******************************************************************************************************************/
@isTest
private class zTEST_UpdateContactSourceDetails {
  static testMethod void test_TF_UpdateContactSourceDetails_Trig() {
    Id contactRecordtypeId = MiscFunctions.getRecordtypeId('Contact', 'T&F - Contacts');
    Contact con = new Contact();
    con.optin_optout_status__c = '';
    con.optin_optout_source__c = '';
    //con.Last_Modified_Opt_Out_Status_Date__c = date.valueOf('');
    con.LastName = 'test';
    con.RecordTypeId = contactRecordtypeId;
    insert con;
    
    
    
    Test.StartTest();
        TriggerInterfaceHelper.runTrigger('TF_UpdateContactSourceDetails_Trig', 'Contact', 1, 'bu', contactRecordtypeId, null);
        con.optin_optout_status__c = 'Implicit Opt-In';
        con.optin_optout_source__c = 'TFO';
        con.Last_Modified_Opt_Out_Status_Date__c = date.today();
        update con;
        con.optin_optout_status__c = 'Explicit Opt-In';
        con.optin_optout_source__c = 'TFO';
        con.Last_Modified_Opt_Out_Status_Date__c = date.today();
        update con;
        
    Test.StopTest();
  }
  
  static testMethod void test_TF_UpdateContactSourceDetails_Trig1() {
    Id contactRecordtypeId = MiscFunctions.getRecordtypeId('Contact', 'T&F - Contacts');
    Contact con = new Contact();
    con.optin_optout_status__c = '';
    con.optin_optout_source__c = '';
    //con.Last_Modified_Opt_Out_Status_Date__c = date.valueOf('');
    con.LastName = 'test';
    con.RecordTypeId = contactRecordtypeId;
    insert con;
    
    
    
    Test.StartTest();
        TriggerInterfaceHelper.runTrigger('TF_UpdateContactSourceDetails_Trig', 'Contact', 1, 'bu', contactRecordtypeId, null);
        con.optin_optout_status__c = 'Explicit Opt-In';
        con.optin_optout_source__c = 'TFO';
        con.Last_Modified_Opt_Out_Status_Date__c = date.today();
        update con;
        
    Test.StopTest();
  }
  
  static testMethod void test_TF_UpdateContactSourceDetails_Trig3() {
    Id contactRecordtypeId = MiscFunctions.getRecordtypeId('Contact', 'T&F - Contacts');
    Contact con = new Contact();
    con.optin_optout_status__c = '';
    con.optin_optout_source__c = '';
    //con.Last_Modified_Opt_Out_Status_Date__c = date.valueOf('');
    con.LastName = 'test';
    con.RecordTypeId = contactRecordtypeId;
    insert con;
    
    
    
    Test.StartTest();
        TriggerInterfaceHelper.runTrigger('TF_UpdateContactSourceDetails_Trig', 'Contact', 1, 'bu', contactRecordtypeId, null);
        con.optin_optout_status__c = 'Explicit Opt-Out';
        con.optin_optout_source__c = 'TFO';
        con.Last_Modified_Opt_Out_Status_Date__c = date.today();
        update con;
        
    Test.StopTest();
  }
  
  static testMethod void test_TF_UpdateContactSourceDetails_Trig4() {
    Id contactRecordtypeId = MiscFunctions.getRecordtypeId('Contact', 'T&F - Contacts');
    Contact con = new Contact();
    con.optin_optout_status__c = 'Implicit Opt-In';
    con.optin_optout_source__c = 'TFO';
    con.Last_Modified_Opt_Out_Status_Date__c = Date.Today()-1;
    con.LastName = 'test';
    con.RecordTypeId = contactRecordtypeId;
    insert con;
    
    
    
    Test.StartTest();
        TriggerInterfaceHelper.runTrigger('TF_UpdateContactSourceDetails_Trig', 'Contact', 1, 'bu', contactRecordtypeId, null);
        con.optin_optout_status__c = 'Implicit Opt-In';
        con.optin_optout_source__c = 'CATS';
        con.Last_Modified_Opt_Out_Status_Date__c = date.today();
        update con;
        
    Test.StopTest();
  }
  static testMethod void test_TF_UpdateContactSourceDetails_Trig5() {
    Id contactRecordtypeId = MiscFunctions.getRecordtypeId('Contact', 'T&F - Contacts');
    Contact con = new Contact();
    con.optin_optout_status__c = 'Implicit Opt-In';
    con.optin_optout_source__c = 'TFO';
    con.Last_Modified_Opt_Out_Status_Date__c = Date.Today()-1;
    con.LastName = 'test';
    con.RecordTypeId = contactRecordtypeId;
    insert con;
    
    
    
    Test.StartTest();
        TriggerInterfaceHelper.runTrigger('TF_UpdateContactSourceDetails_Trig', 'Contact', 1, 'bu', contactRecordtypeId, null);
        con.optin_optout_status__c = 'Explicit Opt-In';
        con.optin_optout_source__c = 'CATS';
        con.Last_Modified_Opt_Out_Status_Date__c = date.today();
        update con;
        
    Test.StopTest();
  }
  static testMethod void test_TF_UpdateContactSourceDetails_Trig6() {
    Id contactRecordtypeId = MiscFunctions.getRecordtypeId('Contact', 'T&F - Contacts');
    Contact con = new Contact();
    con.optin_optout_status__c = 'Implicit Opt-In';
    con.optin_optout_source__c = 'TFO';
    con.Last_Modified_Opt_Out_Status_Date__c = Date.Today()-1;
    con.LastName = 'test';
    con.RecordTypeId = contactRecordtypeId;
    insert con;
    
    
    
    Test.StartTest();
        TriggerInterfaceHelper.runTrigger('TF_UpdateContactSourceDetails_Trig', 'Contact', 1, 'bu', contactRecordtypeId, null);
        con.optin_optout_status__c = 'Explicit Opt-Out';
        con.optin_optout_source__c = 'CATS';
        con.Last_Modified_Opt_Out_Status_Date__c = date.today();
        update con;
        
    Test.StopTest();
  }
  static testMethod void test_TF_UpdateContactSourceDetails_Trig7() {
    Id contactRecordtypeId = MiscFunctions.getRecordtypeId('Contact', 'T&F - Contacts');
    Contact con = new Contact();
    con.optin_optout_status__c = 'Explicit Opt-In';
    con.optin_optout_source__c = 'TFO';
    con.Last_Modified_Opt_Out_Status_Date__c = Date.Today()-1;
    con.LastName = 'test';
    con.RecordTypeId = contactRecordtypeId;
    insert con;
    
    
    
    Test.StartTest();
        TriggerInterfaceHelper.runTrigger('TF_UpdateContactSourceDetails_Trig', 'Contact', 1, 'bu', contactRecordtypeId, null);
        con.optin_optout_status__c = 'Explicit Opt-Out';
        con.optin_optout_source__c = 'CATS';
        con.Last_Modified_Opt_Out_Status_Date__c = date.today();
        con.HasOptedOutOfEmail = True;
        con.Source_of_Email_Opt_Out_Status__c = con.optin_optout_source__c;
        con.Last_Modified_Global_Opt_Out_Status_Date__c = con.Last_Modified_Opt_Out_Status_Date__c;
        update con;
        
    Test.StopTest();
  }
  static testMethod void test_TF_UpdateContactSourceDetails_Trig8() {
    Id contactRecordtypeId = MiscFunctions.getRecordtypeId('Contact', 'T&F - Contacts');
    Contact con = new Contact();
    con.optin_optout_status__c = 'Explicit Opt-In';
    con.optin_optout_source__c = 'TFO';
    con.Last_Modified_Opt_Out_Status_Date__c = Date.Today()-1;
    con.LastName = 'test';
    con.RecordTypeId = contactRecordtypeId;
    insert con;
    
    
    
    Test.StartTest();
        TriggerInterfaceHelper.runTrigger('TF_UpdateContactSourceDetails_Trig', 'Contact', 1, 'bu', contactRecordtypeId, null);
        con.optin_optout_status__c = 'Explicit Opt-In';
        con.optin_optout_source__c = 'CATS';
        con.Last_Modified_Opt_Out_Status_Date__c = date.today();
        con.HasOptedOutOfEmail = False;
        con.Source_of_Email_Opt_Out_Status__c = con.optin_optout_source__c;
        con.Last_Modified_Global_Opt_Out_Status_Date__c = con.Last_Modified_Opt_Out_Status_Date__c;
        update con;
        
    Test.StopTest();
  }
  static testMethod void test_TF_UpdateContactSourceDetails_Trig9() {
    Id contactRecordtypeId = MiscFunctions.getRecordtypeId('Contact', 'T&F - Contacts');
    Contact con = new Contact();
    con.optin_optout_status__c = 'Implicit Opt-In';
    con.optin_optout_source__c = 'TFO';
    con.Last_Modified_Opt_Out_Status_Date__c = Date.Today()-1;
    con.LastName = 'test';
    con.RecordTypeId = contactRecordtypeId;
    insert con;
    
    
    
    Test.StartTest();
        TriggerInterfaceHelper.runTrigger('TF_UpdateContactSourceDetails_Trig', 'Contact', 1, 'bu', contactRecordtypeId, null);
        con.optin_optout_status__c = 'Implicit Opt-In';
        con.optin_optout_source__c = 'CATS';
        con.Last_Modified_Opt_Out_Status_Date__c = date.today()-2;
        
        update con;
        
    Test.StopTest();
  }
  static testMethod void test_TF_UpdateContactSourceDetails_Trig10() {
    Id contactRecordtypeId = MiscFunctions.getRecordtypeId('Contact', 'T&F - Contacts');
    Contact con = new Contact();
    con.optin_optout_status__c = 'Implicit Opt-In';
    con.optin_optout_source__c = 'TFO';
    con.Last_Modified_Opt_Out_Status_Date__c = Date.Today()-1;
    con.LastName = 'test';
    con.RecordTypeId = contactRecordtypeId;
    insert con;
    
    
    
    Test.StartTest();
        TriggerInterfaceHelper.runTrigger('TF_UpdateContactSourceDetails_Trig', 'Contact', 1, 'bu', contactRecordtypeId, null);
        con.optin_optout_status__c = 'Explicit Opt-In';
        con.optin_optout_source__c = 'CATS';
        con.Last_Modified_Opt_Out_Status_Date__c = date.today()-2;
        
        update con;
        
    Test.StopTest();
  }
  
  static testMethod void test_TF_UpdateContactSourceDetails_Trig11() {
    Id contactRecordtypeId = MiscFunctions.getRecordtypeId('Contact', 'T&F - Contacts');
    Contact con = new Contact();
    con.optin_optout_status__c = 'Explicit Opt-In';
    con.optin_optout_source__c = 'TFO';
    con.Last_Modified_Opt_Out_Status_Date__c = Date.Today()-1;
    con.LastName = 'test';
    con.RecordTypeId = contactRecordtypeId;
    insert con;
    
    
    
    Test.StartTest();
        TriggerInterfaceHelper.runTrigger('TF_UpdateContactSourceDetails_Trig', 'Contact', 1, 'bu', contactRecordtypeId, null);
        con.optin_optout_status__c = 'Implicit Opt-In';
        con.optin_optout_source__c = 'CATS';
        con.Last_Modified_Opt_Out_Status_Date__c = date.today()-2;
        
        update con;
        
    Test.StopTest();
  }
  
  static testMethod void test_TF_UpdateContactSourceDetails_Trig12() {
    Id contactRecordtypeId = MiscFunctions.getRecordtypeId('Contact', 'T&F - Contacts');
    Contact con = new Contact();
    con.optin_optout_status__c = 'Explicit Opt-In';
    con.optin_optout_source__c = 'TFO';
    con.Last_Modified_Opt_Out_Status_Date__c = Date.Today()-1;
    con.LastName = 'test';
    con.RecordTypeId = contactRecordtypeId;
    insert con;
    
    
    
    Test.StartTest();
        TriggerInterfaceHelper.runTrigger('TF_UpdateContactSourceDetails_Trig', 'Contact', 1, 'bu', contactRecordtypeId, null);
        con.optin_optout_status__c = 'Implicit Opt-In';
        con.optin_optout_source__c = 'CATS';
        con.Last_Modified_Opt_Out_Status_Date__c = date.today()+2;
        
        update con;
        
    Test.StopTest();
  
}
}