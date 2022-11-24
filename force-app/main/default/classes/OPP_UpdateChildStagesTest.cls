/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 *
 * Modified by Hailey Niemand 2013.08.09 - CHG0048108 - Rename T&F Opportunity Record Types
 * Modified by Hailey Niemand - 2017.01.26 - CHG0031794
 * 
 */
@isTest
private class OPP_UpdateChildStagesTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
       Profile p = [select id from profile where name='Standard User'];
 
        //User u = new User(alias = 'test123', email='test123@noemail.com',
          //  emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            //localesidkey='en_US', profileid = p.Id, country='United States',
            //timezonesidkey='America/Los_Angeles', username='test123@noemail.com');
        User u = zTest_Shared.noinsertUser();
        insert u;
        
        Account a = new Account(
                Name = 'Test Account',
                OwnerId = u.Id
            );
        insert a;    
        
        list<Opportunity> opplist = new list<Opportunity>();
        
        Recordtype rec = [Select Name, Id From RecordType where sObjectType='Opportunity' AND
        //Name = 'T&F Journals Consortium Sales Deal Opportunity' Limit 1];
        //Name = 'T&F Journals Consortium Opportunity (Price Agreement)' Limit 1]; //CHG0048108
        Name = 'T&F - Journals Consortium Opportunity (Price Agreement)' Limit 1]; //CHG0031794
        
        Opportunity popp = new Opportunity(
                Name = 'POpp ',
                OwnerId = u.Id,
                Accountid = a.id, 
                StageName = 'Prospect',
                Type = 'New Business',
                CloseDate = System.today(),
                LeadSource = 'Cold Call',
                RecordTypeId = rec.id
        );
        insert popp;
        
            for (Integer i=0;i<3;i++) {
            Opportunity o = new Opportunity(
                Name = 'COpp ' + i,
                OwnerId = u.Id,
                Accountid = a.id, 
                StageName = 'Prospect',
                Type = 'New Business',
                CloseDate = System.today(),
                LeadSource = 'Cold Call',
                RecordTypeId = rec.id,
                Parent_Opportunty__c = popp.Id
            );
            opplist.add(o);
        }
        insert opplist;
   
        String s = OPP_UpdateChildStages.UpdateMembers(popp.id);      
    }
}