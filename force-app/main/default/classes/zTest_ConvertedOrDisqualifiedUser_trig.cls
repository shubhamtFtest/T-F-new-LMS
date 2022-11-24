/**************************************************
* Created by Tom Reed/Piyush Jain, 2018.05.23
* Test Class For Set_Converted_Or_Disqualified_User_trig
**************************************************/
@isTest
public class zTest_ConvertedOrDisqualifiedUser_trig {
    
    static testmethod void testPreviousLeadOwner(){
        
        Id rtId = MiscFunctions.getRecordtypeId('Lead', 'T&F - Leads');

        TriggerInterfaceHelper.runTrigger('Set_Converted_Or_Disqualified_User_trig', 'Lead', 99, 'au', rtId, null);
        
        Setting__c settingRecord = New Setting__c(Name='DisqualifiedLeadStages');
        Insert settingRecord;
        Setting_Item__c settingItemRecord = new Setting_Item__c(Text_1__c = 'Disqualified', Setting__c = settingRecord.Id);
        Insert settingItemRecord;
        
        //Create A Lead Queue
        Group testQueue = new Group(Name='TestQueue', Type='Queue');
        Insert testQueue; 
		User testUser =  zTest_Shared.insertUser();
        System.runAs(testUser){
            QueueSObject queueType = new QueueSObject(SobjectType='Lead', QueueId=testQueue.Id);
            insert queueType;          
        }      
        //Create A Lead In The Name Of the User Running The Test
        Lead testLead = new Lead(Company='TestCompany',LastName='TestLastName',Department__c= 'TestDepartment'
                                 ,Email='TestEmail@email.com',LeadSource='Direct',Lead_Source_Detail__c='Webinar'
                                 ,Country_List__c='United Kingdom',Sales_Region__c='United Kingdom'
                                 ,Business__c='CAS', Course_Start_Date__c=date.today(),OwnerId=testUser.id);
        Insert testLead;  
        Lead testLead2 = new Lead(Company='TestCompany',LastName='TestLastName2',Department__c= 'TestDepartment'
                                 ,Email='TestEmail2@email.com',LeadSource='Direct',Lead_Source_Detail__c='Webinar'
                                 ,Country_List__c='United Kingdom',Sales_Region__c='United Kingdom'
                                 ,Business__c='CAS', Course_Start_Date__c=date.today(),OwnerId=testQueue.id);
        Insert testLead2; 
        List<Lead> newList = new List<lead>();
        newList.add(testLead);
        newList.add(testLead2);
          testLead2.status = 'Disqualified';
        Update testLead2;
        system.debug(testLead);
        
        Database.LeadConvert dl = new Database.LeadConvert();
        
        dl.setLeadId(testLead.id);
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        dl.setConvertedStatus(convertStatus.MasterLabel);
        system.debug('convertStatus'+convertStatus);
        Database.LeadConvertResult result = Database.convertLead(dl);
        
        Test.startTest();
        Set_Converted_Or_Disqualified_User_trig Leadowner = new Set_Converted_Or_Disqualified_User_trig();
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
        User testUser2 = zTest_Shared.insertUser();

        Leadowner.run(Leadownertrig);
        system.debug('Converted? ' + testLead.Isconverted);
        // Leadowner.run();
        Test.stopTest();         
    }   
}