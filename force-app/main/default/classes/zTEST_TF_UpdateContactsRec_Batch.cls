/*
Created by Sourabh Goyal. @ 4 August 2017
Usage:- Test class for TF_UpdateContactsRec_Batch  & scheduler_TF_UpdateContactsRec_Batch .
*/

@isTest 
public class zTEST_TF_UpdateContactsRec_Batch  
{
    static testMethod void testMethod1() 
    {
        
        
        Contact con = new Contact();
        con.LastName = 'testTest';
        con.RecordTypeId = [select id from Recordtype where Name ='T&F - Contacts' AND sObjectType='Contact' LIMIT 1].id;
        con.ACR_Last_Interaction__c = date.today();
        insert con;
        system.assertEquals(con.optin_optout_source__c,Null);
        
        ContactSource__c cs = new ContactSource__c();
        cs.ContactID__c = con.Id;
        cs.Current_Opt_In_Status__c = 'Implicit Opt In';
        cs.Source_System_Name__c = 'CATS';
        cs.CurrencyIsoCode = 'USD';
        cs.Date_First_Added_to_Source__c = date.today();
        cs.Latest_Date_of_Opt_In_Update__c = date.today();
        insert cs;
        
        Test.startTest();
        TF_UpdateContactsRec_Batch obj1 = new TF_UpdateContactsRec_Batch();
        DataBase.executeBatch(obj1);

        scheduler_TF_UpdateContactsRec_Batch sh1 = new scheduler_TF_UpdateContactsRec_Batch();
        String sch = '0 0 23 * * ?'; system.schedule('Association Update', sch, sh1);
        
        Test.stopTest();
    }
    
    static testMethod void testMethod2() 
    {
        
        
        Contact con = new Contact();
        con.LastName = 'testTest';
        con.RecordTypeId = [select id from Recordtype where Name ='T&F - Contacts' AND sObjectType='Contact' LIMIT 1].id;
        con.ACR_Last_Interaction__c = date.today();
        insert con;
        system.assertEquals(con.optin_optout_source__c,Null);
        
        ContactSource__c cs = new ContactSource__c();
        cs.ContactID__c = con.Id;
        cs.Current_Opt_In_Status__c = 'Explicit Opt In';
        cs.Source_System_Name__c = 'CATS';
        cs.CurrencyIsoCode = 'USD';
        cs.Date_First_Added_to_Source__c = date.today();
        cs.Latest_Date_of_Opt_In_Update__c = date.today();
        insert cs;
        
        Test.startTest();
        TF_UpdateContactsRec_Batch obj1 = new TF_UpdateContactsRec_Batch();
        DataBase.executeBatch(obj1);

        scheduler_TF_UpdateContactsRec_Batch sh1 = new scheduler_TF_UpdateContactsRec_Batch();
        String sch = '0 0 23 * * ?'; system.schedule('Association Update', sch, sh1);
        
        Test.stopTest();
    }
    
    static testMethod void testMethod3() 
    {
        
        
        Contact con = new Contact();
        con.LastName = 'testTest';
        con.RecordTypeId = [select id from Recordtype where Name ='T&F - Contacts' AND sObjectType='Contact' LIMIT 1].id;
        con.ACR_Last_Interaction__c = date.today();
        insert con;
        system.assertEquals(con.optin_optout_source__c,Null);
        
        ContactSource__c cs = new ContactSource__c();
        cs.ContactID__c = con.Id;
        cs.Current_Opt_In_Status__c = 'Explicit Opt Out';
        cs.Source_System_Name__c = 'CATS';
        cs.CurrencyIsoCode = 'USD';
        cs.Date_First_Added_to_Source__c = date.today();
        cs.Latest_Date_of_Opt_In_Update__c = date.today();
        insert cs;
        
        Test.startTest();
        TF_UpdateContactsRec_Batch obj1 = new TF_UpdateContactsRec_Batch();
        DataBase.executeBatch(obj1);

        scheduler_TF_UpdateContactsRec_Batch sh1 = new scheduler_TF_UpdateContactsRec_Batch();
        String sch = '0 0 23 * * ?'; system.schedule('Association Update', sch, sh1);
        
        Test.stopTest();
    }
    
   
}