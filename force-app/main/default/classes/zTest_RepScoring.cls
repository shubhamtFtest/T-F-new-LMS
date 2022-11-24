/**************************************************
* Created by Tom Reed, 2018.05.30
* Test Class For RepScoring Class
* Test Class updated by Matthew Smith and Tom Reed on 2020.03.23 (01110668, 00990401)
**************************************************/

@isTest(SeeAllData=true)
public class zTest_RepScoring {
    
    static testmethod void runTest(){

        //Get Admin User To Run
        User repTestUser = [SELECT Id, Username, ProfileId FROM User WHERE Id =: Label.zTest_RepScoring_UserId]; //update this user to the user you would like to test with. This user is stored in Custom Labels. 
        system.debug('Correct Email: ' + repTestUser.Username);
        system.debug('Profile Id. Does it match "00e0Y000001s0Ta": ' + repTestUser.ProfileId);
        
        User testUser = zTest_Shared.noinsertUser();
        insert testUser;

        System.runAs(repTestUser){
            system.debug('Who is the user? ' + repTestUser.Id);
            //Create Setting Record
            Setting__c testSettingRecord = new Setting__c(Name= 'RepScoringProfiles');
            Insert testSettingRecord;
            system.debug('setting record insert' + testSettingRecord);
            Setting_Item__c testSettingItemRecord = new Setting_Item__c(Setting__c = testSettingRecord.id, Text_1__c = repTestUser.ProfileId);
            Insert testSettingItemRecord;
            system.debug(testSettingItemRecord);
           
            //Create Account
            Account testAccount = new Account(Name='Test Account');
            Insert testAccount;
                       
            //Get Opportunity Record Type
            Id testRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F - CAS Opportunity').getRecordTypeId();
            
            //Create A Open Opportunity
            zTEST_Shared.insertOpportunity(string.valueof(testRecordType), string.valueof(repTestUser.id), String.ValueOf(testAccount.id));
            
            //Create A Closed Opportunity
            Opportunity openOpportunity = zTEST_Shared.insertOpportunity(string.valueof(testRecordType), string.valueof(repTestUser.id), String.ValueOf(testAccount.id));  
            
            openOpportunity.stagename = 'Closed Won';
            update openOpportunity;
            
            //Create Lead & Convert
            Lead testLead = zTEST_Shared.insertLead(String.ValueOf(repTestUser.id));
            Database.LeadConvert lc = new database.LeadConvert();
            lc.setLeadId(testLead.id);
            lc.setDoNotCreateOpportunity(false);
            lc.setConvertedStatus('Converted');
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            
            //Locate the chatter group if in production
            
            list<CollaborationGroup> testChatterGroupList = new list<CollaborationGroup>(); 
            list<CollaborationGroupMember> testChatterGroupMemberList = new list<CollaborationGroupMember>();
            testChatterGroupList = [SELECT Id, Name FROM CollaborationGroup WHERE Name='T&F Salesforce Feedback Group' LIMIT 1];
            CollaborationGroup testChatterGroupId = [SELECT Id, Name FROM CollaborationGroup WHERE Name='T&F Salesforce Feedback Group' LIMIT 1];
            
            /*
            //inserting testUser into Chatter Group
            CollaborationGroupMember repTestChatterGroupMember = new CollaborationGroupMember();
            repTestChatterGroupMember.MemberId = repTestUser.Id;
            repTestChatterGroupMember.CollaborationGroupId = testChatterGroupId.Id;
            insert repTestChatterGroupMember;
            */
            
            testChatterGroupMemberList = [SELECT Id, MemberId FROM CollaborationGroupMember WHERE CollaborationGroup.Name = 'T&F Salesforce Feedback Group' LIMIT 2];
            system.debug('Chatter Group ' + testChatterGroupId);
            system.debug('Chatter Group Users' + testChatterGroupMemberList);
            if(testChatterGroupList.size() == 0)          
            {
                //Create Chatter Group & Add User if not in production.
                CollaborationGroup testChatterGroup = New CollaborationGroup(Name='T&F Salesforce Feedback Group', CollaborationType='Public');
                Insert testChatterGroup; 
                system.debug('test chatter group' + testChatterGroup);
                CollaborationGroupMember testChatterGroupMember = new CollaborationGroupMember(CollaborationGroupId=testChatterGroup.id);
                testChatterGroupMember.MemberId = repTestUser.Id;
                testChatterGroupMember.CollaborationGroupId = testChatterGroup.Id;
                insert testChatterGroupMember;
                system.debug(testChatterGroupMember);
            }
                        
            ScheduleRepScorecard repBatch2 = new ScheduleRepScorecard();   
            repBatch2.userIds = new Set<User>{repTestUser, testUser};
            repBatch2.execute(null); 
        }
    }

}