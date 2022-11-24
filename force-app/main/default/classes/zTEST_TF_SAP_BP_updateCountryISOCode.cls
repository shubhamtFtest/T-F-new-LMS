/*
 * Class: TF_SAP_BP_updateCountryISOCode
 * Created by: Piyush Jain
 * */
@isTest
public class zTEST_TF_SAP_BP_updateCountryISOCode {

    @IsTest
    Public static void test_TF_SAP_BPcreation(){
        TriggerInterfaceHelper.runTrigger('TF_SAP_BP_updateCountryISOCode', 'SAP_BP__c', 1, 'ai', null, null);
        //Test account
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
        
        //Test country object
        Country__c CountryObj = new Country__c();
        CountryObj.Country_2__c  = 'IN';
        CountryObj.Name  = 'India'; 
        insert CountryObj;    
        
        //Test sap bp record
        SAP_BP__c SAP_BP_Record = new SAP_BP__c();
        SAP_BP_Record.Name = 'Pending';
        SAP_BP_Record.Country__c = 'India';
        SAP_BP_Record.Address_Type__c = 'Account Mailing';
        insert SAP_BP_Record;
    }
}