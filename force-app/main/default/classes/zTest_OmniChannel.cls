/***************************************************************************
* Created by: Tom Reed, 2019.04.02
* Test Class for: OmniChannelRouting
*          OmniChannelRouteBackToQueue
*          OmniChannelUSPTrigClass
* **************************************************************************/

@isTest (SeeAllData = true)//Limitations with Omni Channel require see all data.
public class zTest_OmniChannel {
    
    public static testmethod void TestOmniChannel(){

        //To toggle the test class on and off.
        zTest_OmniChannel_Settings__c settingRecord = [SELECT IsEnabled__c, Test_User_Id__c, Test_Queue_Name__c
                                                     FROM zTest_OmniChannel_Settings__c LIMIT 1];
        
        if(settingRecord.IsEnabled__c == true){
            
            //Custom Metadata needs to be added so the test can be toggled on and off.
            //The only way to test the AgentWork trigger is to log into Omni Channel through the Service Console.
            
            test.startTest();
            
            Id devRecordTypeId = MiscFunctions.getRecordtypeId('Case', 'T&F - CSD');
            TriggerInterfaceHelper.runTrigger('OmniChannelRouting', 'Case', 99, 'ai,au', devRecordTypeId, null);       
            TriggerInterfaceHelper.runTrigger('OmniChannelRouteBackToQueue', 'AgentWork', 99, 'au', null, null);
            TriggerInterfaceHelper.runTrigger('OmniChannelUSPTrigClass', 'UserServicePresence', 99, 'ai', null, null);
            
            //Select the testing user.
            User testUser = [SELECT Id FROM User WHERE Id =: settingRecord.Test_User_Id__c];
            //Locate the queue to be used for testing.
            Group testQueue = [SELECT Id, Name FROM GROUP WHERE Name=:settingRecord.Test_Queue_Name__c and Type='queue'];
            
            //Create Omni configuration record.
            Omni_Channel_Rules__c omniConfig = new Omni_Channel_Rules__c(Queue__c=settingRecord.Test_Queue_Name__c, Work_Capacity__c=2);        
            insert omniConfig;
            
            //Set the test user.
            OmniChannelRouting.testUserId = testUser.Id;
            
            //Create some cases.
            Case testCase = new Case(Subject='Test Case',Last_Queue_Owner__c=settingRecord.Test_Queue_Name__c);
            insert testCase;
            Case testCase1 = new Case(Subject='Test Case 1',Last_Queue_Owner__c=settingRecord.Test_Queue_Name__c, OwnerId=testUser.Id);
            insert testCase1;
            //Reassign the Case to the queue for Omni.
            testCase.OwnerId = testQueue.Id;
            update testCase;        
            
            
            //Locate the case service channel.
            ServiceChannel sc = [SELECT Id, DeveloperName FROM ServiceChannel WHERE DeveloperName = 'Cases' LIMIT 1];
          //  ServiceChannelStatus scs = new ServiceChannelStatus(ServicePresenceStatusId =sc[0].Id);
         //   ServiceChannelStatus scs = [SELECT Id FROM ServiceChannelStatus WHERE ServicePresenceStatusId = '0N92X000000GmyGSAS' ];
            
          
            
            //Trigger the test on OmniChannelUSPTrigClass.
            insert new UserServicePresence(UserId=testUser.Id);
            
              System.runAs(testUser)
            {
                List<AgentWork> agentWorks = new List<AgentWork>();
                AgentWork agentWorkItem = new AgentWork(WorkItemId = testCase1.Id, ServiceChannelId = sc.Id, UserId = testUser.Id);
                agentWorks.add(agentWorkItem);        
                insert agentWorks; 
               // agentWorkItem.status ='declined';
                update agentWorks;
            }
            
            test.stopTest();
            
        }

    }
}