/********************************************************
  //This is the test class of the class "TF_Contact_On_Lead"
  //Created By :Shefali Arora on date 28.08.2019
  //Test Class coverage :88%
  //Modified By : Shefali Arora on date 01.10.2019
  //Modified By : Shefali Arora on date 31.10.2019 (Case no :01359747)
  //Modified By : Shefali Arora on date 06.12.2019
********************************************************/
@isTest
public class zTEST_TF_Contact_On_Lead {
    //Covering positive case
    static testMethod void test_TF_Contact_On_Lead() {
  
        User u = zTEST_Shared.insertUser();
        Id leadRecordtypeId = MiscFunctions.getRecordtypeId('Lead', 'T&F - Leads');
        TriggerInterfaceHelper.runTrigger('TF_Contact_On_Lead', 'Lead', 1, 'bi', leadRecordtypeId, null);
        
        //Created a Lead record
        Lead l = new Lead();
        l.Company = 'test';
        l.LastName = 'test1';
        l.Department__c = 'test2';
        l.Status = 'Contacted';
        l.LeadSource = 'Agent';
        l.Email = 'test@gmail.com';
        l.Country_List__c = 'United States';
        l.State_List__c = 'Almeria';
        l.ISBN__c = 'test ISBN';
        insert l;
        
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        //Created a Contact record
        Contact c = new Contact();
        c.Status__c = 'Inactive - account unverified';
        c.AccountId = a.Id;
        c.LastName = 'Test';
        c.Email = 'test@gmail.com';
        c.Mailing_Country_List__c = 'United Kingdom';
        c.Business__c = 'CAS';
        c.LeadSource = 'Agent';
        insert c;
        
        //Checking if the Lead's Email Id matches the Contact's Email Id
        if(l.Email == c.Email){
            l.Status = 'Existing Contact';
		}
    }
}