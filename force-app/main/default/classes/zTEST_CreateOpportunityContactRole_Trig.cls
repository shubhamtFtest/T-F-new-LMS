/*********************************************************
 * Modified by Hailey Niemand - 2017.01.26 - CHG0031794
*********************************************************/

@isTest
private class zTEST_CreateOpportunityContactRole_Trig {
    static testMethod void test_Lead_CreateOpportunityContactRole_Trig() {
        //Id recordtypeId = MiscFunctions.getRecordtypeId('Lead', 'CAS - Leads');
        Id recordtypeId = MiscFunctions.getRecordtypeId('Lead', 'T&F - Leads'); //CHG0031794
        TriggerInterfaceHelper.runTrigger('Lead_CreateOpportunityContactRole_Trig', 'Lead', 99, 'au', recordtypeId, null);
        String adstr= 'ukcorplan'+'\\'+'testinguser1' ;
        Active_Directory_Details__c acd = new Active_Directory_Details__c(Name='TestAd', sys_id__c='sys123', u_office_365__c = 'TestOfc' ,USER_Name__c=adstr,CurrencyIsoCode='USD');
        insert acd;
        System.debug('acd'+acd.USER_Name__c);
        User u = new User(alias='test', email='test@example.com', firstname='Testing',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', country='United States',
            timezonesidkey='America/Los_Angeles', username='test@example.com.informaplc' + system.now().second() + system.now().millisecond() + math.random(),
            Informa_Business_Unit__c='INFORMA USA INC',
            //profileid='00e30000000guhiAAA', //System Administrator
            profileid='00e0Y000001s0Ta', //System Administrator
            Legal_Entity__c='INFORMA PLC (CH004)',
            Reporting_Unit__c='AE005',
            Admin_Options__c='Manage Licenses',
            Active_Directory_Username__c='testinguser1' ,
            Active_Directory_OU__c='ukcorplan');
            
        insert u    ;
        Lead l = zTEST_Shared.insertLead(u.Id, recordtypeId);
        l.Course_Name__c = 'test';
        update l; 
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(l.id);
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        try{
            Database.LeadConvertResult lcr = Database.convertLead(lc);
        }
        catch(exception e){}     
    }
}