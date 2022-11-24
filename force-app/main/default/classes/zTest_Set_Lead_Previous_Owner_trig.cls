/**************************************************
* Created by Tom Reed/Piyush Jain, 2018.05.23
* Test Class For Set_Lead_Previous_Owner_trig
* Commented the test class as it is no longer needed By: Shefali Arora ( Case No : 01077663 ) on date 2019.10.04
**************************************************/
@isTest
public class zTest_Set_Lead_Previous_Owner_trig {
    static testMethod void test(){
        TriggerInterfaceHelper.runTrigger('Set_Lead_Previous_Owner_trig', 'Lead', 50, 'au', null, null);
        //Create A Lead In The Name Of the User Running The Test
        Lead testLead = new Lead(Company='TestCompany',LastName='TestLastName',Department__c= 'TestDepartment'
                                 ,Email='TestEmail@email.com',LeadSource='Direct',Lead_Source_Detail__c='Webinar'
                                 ,Country_List__c='United Kingdom',Sales_Region__c='United Kingdom'
                                 ,Business__c='CAS', Course_Start_Date__c=date.today(),OwnerId='0050Y000002quIT');
        Insert testLead;
        
        Set_Lead_Previous_Owner_trig Leadowner = new Set_Lead_Previous_Owner_trig();
        TriggerInterface_Lead.Trig Leadownertrig = new TriggerInterface_Lead.Trig();
        Leadowner.run(Leadownertrig);
        
        Set_Lead_Previous_Owner_trig.runTest();
        }
        

    /*static testmethod void testPreviousLeadOwner(){
        
        TriggerInterfaceHelper.runTrigger('Set_Lead_Previous_Owner_trig', 'Lead', 1, 'au', null, null);
        
        //Create A Lead Queue
        Group testQueue = new Group(Name='TestQueue', Type='Queue');
        Insert testQueue; 
        
        System.runAs(zTest_Shared.insertUser()){
            QueueSObject queueType = new QueueSObject(SobjectType='Lead', QueueId=testQueue.Id);
            insert queueType;          
        }      
        //Create A Lead In The Name Of the User Running The Test
        Lead testLead = new Lead(Company='TestCompany',LastName='TestLastName',Department__c= 'TestDepartment'
                                 ,Email='TestEmail@email.com',LeadSource='Direct',Lead_Source_Detail__c='Webinar'
                                 ,Country_List__c='United Kingdom',Sales_Region__c='United Kingdom'
                                 ,Business__c='CAS', Course_Start_Date__c=date.today(),OwnerId='0050Y000002quIT');
        Insert testLead;   
        List<Lead> newList = new List<lead>();
        newList.add(testLead);
        system.debug(testLead);
        
        Test.startTest();
        /*Set_Lead_Previous_Owner_trig Leadowner = new Set_Lead_Previous_Owner_trig();
        TriggerInterface_Lead.Trig Leadownertrig = new TriggerInterface_Lead.Trig();
        
        Leadownertrig.isAfter = true;
        Leadownertrig.isBefore = true;
        Leadownertrig.isDelete= true;
        Leadownertrig.isInsert= true;
        Leadownertrig.isUnDelete= true;
        
        Leadownertrig.isUpdate = true;
        Map<Id,Map<String,String>> mapRtIdsToParams = Leadownertrig.mapRtIdsToParams;
        Leadownertrig.oldList =newList;
        Map<Id,Lead> oldMap = Leadownertrig.oldMap;
        Map<Id,Lead> newMap = Leadownertrig.newMap;
        testLead.Comments__c ='test';
        Update testLead; 
        Leadowner.run(Leadownertrig);
        // Leadowner.run();
        Test.stopTest();         
    }*/
}