/* Tests: Case_Support_Team_Trig at 100%
 * Tests: Case: Support Team Email & Field Update Process Builder
* 
*  Created by Tom Reed - 2018.04.26
*  Update by Tom Reed 2019.05.14
*  Update by Matt Smith 2019.09.12 (updated rows 50 - 64) - 01302520
*  Update by Matt Smith 2019.10.21 (updated rows 66 - 68) - 01353893
*  Update by Matt Smith 2020.05.04 (updated rows 69 - 71) - 01517696
*/

@isTest
public class zTest_Case_Support_Team_Trig {
    
    static testMethod void zTest_Case_Support_Team_Trig(){
        
        TriggerInterfaceHelper.runTrigger('Case_Support_Team_Trig', 'CaseComment', 1, 'ai', null, null);
        
        //Select A System Administrator Test User and Add Them To The Test Public Group
        User testUser = zTest_Shared.insertUser();
        //Create another test user who won't be part of the Public Groups.
        User testUser2 = zTest_Shared.insertUser();
        
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('T&F - CSD').getRecordTypeId();
        
        //Create test Case
        Case testCase = new Case(Subject='Test', Support_Team__c= 'Platform Support - UBX');
        Insert testCase;
        //Create a second test Case
        Case testCase2 = new Case(Subject='Test', Support_Team__c= 'Platform Support - UBX', Support_Team_Owner__c=testUser.Id, RecordTypeid=devRecordTypeId);
        Insert testCase2;        
        
        system.runas(testUser){  
            
            Group testGroup;
            try{
                testGroup = [SELECT Id FROM Group WHERE Name='Platform Support - UBX' LIMIT 1];
            } catch (exception e){
                testGroup = new Group(Name='Platform Support - UBX', Type='Regular');
                insert testGroup;
            } 
            
            GroupMember testGM = new GroupMember(Groupid=testGroup.Id, UserOrGroupId=testUser.Id);
            insert testGM;
            
            //Add A Case Comment As The Test User
            CaseComment testCaseComment = new CaseComment(CreatedById= testUser.id, ParentId= testCase.id, CommentBody = 'This is a test comment');
            Insert testCaseComment;
        }
        
        system.runAs(testUser2){
            Case testCase3 = new Case(Subject='Test', Support_Team__c= 'Platform Support - TFO', Support_Team_Owner__c=testUser.Id);
            Insert testCase3;  
            System.assertEquals('Platform Support - TFO', testCase3.Support_Team__c);
            Case testCase4 = new Case(Subject='Test', Support_Team__c= 'Platform Support - Legacy', Support_Team_Owner__c=testUser.Id);
            Insert testCase4; 
            System.assertEquals('Platform Support - Legacy', testCase4.Support_Team__c);
            Case testCase5 = new Case(Subject='Test', Support_Team__c= 'Platform Support - Open Access', Support_Team_Owner__c=testUser.Id);
            Insert testCase5; 
            System.assertEquals('Platform Support - Open Access', testCase5.Support_Team__c);
            Case testCase6 = new Case(Subject='Test', Support_Team__c= 'Platform Support - Primary Resources', Support_Team_Owner__c=testUser.Id);
            Insert testCase6;   
            System.assertEquals('Platform Support - Primary Resources', testCase6.Support_Team__c);
			Case testCase7 = new Case(Subject='Test', Support_Team__c= 'Platform Support - Other', Support_Team_Owner__c=testUser.Id);
            Insert testCase7;    
            System.assertEquals('Platform Support - Other', testCase7.Support_Team__c);
            Case testCase8 = new Case(Subject='Test', Support_Team__c= 'Platform Support - SDGO', Support_Team_Owner__c=testUser.Id);
            Insert testCase8;    
            System.assertEquals('Platform Support - SDGO', testCase8.Support_Team__c);
            Case testCase9 = new Case(Subject='Test', Support_Team__c= 'AM - eBooks Subscription Renewals', Support_Team_Owner__c=testUser.Id);
            Insert testCase9;    
            System.assertEquals('AM - eBooks Subscription Renewals', testCase9.Support_Team__c);
            
            //Add A Case Comment As The Test User
            CaseComment testCaseComment2 = new CaseComment(CreatedById= testUser2.id, ParentId= testCase.id, CommentBody = 'This is a test comment again');
            Insert testCaseComment2;   
            CaseComment testCaseComment3 = new CaseComment(CreatedById= testUser2.id, ParentId= testCase2.id, CommentBody = 'This is a test comment again');
            Insert testCaseComment3;    
        }
        
    }
}