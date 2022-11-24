/*
* Tests: Trig_Opp_CreateContactRole.trigger     100%
*/
@isTest(seeAllData=true)
private class zTEST_Opp_CreateContactRole {

    static testMethod void test_Opp_CreateContactRole() {
        String adstr= 'ukcorplan'+'\\'+'testinguser1' ;
        Active_Directory_Details__c acd = new Active_Directory_Details__c(Name='TestAd', sys_id__c='sys123', u_office_365__c = 'TestOfc' ,USER_Name__c=adstr,CurrencyIsoCode='USD');
        insert acd;
        System.debug('acd'+acd.USER_Name__c);
        Profile p = [SELECT id, Name FROM Profile where name = 'System Administrator' ].get(0);
        User u = new User(alias='test', email='test@example.com', firstname='Testing',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', country='United States',
            timezonesidkey='America/Los_Angeles', username='test@example.com.informaplc' + system.now().second() + system.now().millisecond() + math.random(),
            Informa_Business_Unit__c='INFORMA USA INC',
            profileid=p.Id, //'00e30000000guhiAAA', //System Administrator
            Legal_Entity__c='INFORMA PLC (CH004)',
            Reporting_Unit__c='AE005',
            Admin_Options__c='Manage Licenses',
            Active_Directory_Username__c='testinguser1' ,
            Active_Directory_OU__c='ukcorplan');
            
        insert u    ;
        System.debug('UserTest'+u.Name_for_Service_Now__c);
        System.debug('UserTest1'+u.FederationIdentifier  );
        List<User> lstUs = [SELECT Id, Active_Directory_Username__c, Active_Directory_OU__c, FederationIdentifier  , Name_for_Service_Now__c FROM User WHERE ID =: u.Id];
        System.debug(lstUs);
       // User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        Id recordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - US Books Opportunity');
        //TriggerInterfaceHelper.runTrigger('Trig_Opp_CreateContactRole', 'Opportunity', 99, 'ai', recordtypeId, null);
        TriggerInterfaceHelper.runTrigger('Opp_CreateContactRole_Trig', 'Opportunity', 99, 'ai', recordtypeId, null);
        Opportunity opp = zTEST_Shared.noinsertOpportunity(recordtypeId, u.Id, a.Id);
        opp.Primary_Contact__c = c.Id;
        try {
            insert opp;
            
        } catch (Exception e) {
        }
        
        Opportunity op = zTEST_Shared.insertOpportunity(recordtypeId, u.Id, a.Id);
        OpportunityContactRole oc =  zTEST_Shared.insertOpportunityContactRole(op.Id, c.Id);
        op.stageName='Closed';
        update op; 
    }
}