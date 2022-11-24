/**************************************************
* Created by: Tom Reed: 2018-11-05
* Test class for  : CSATSurveyAutomation
				  : CSATEmailMessageHelper
**************************************************/
@isTest
public class zTest_CSATSurveyAutomation {

    public static testmethod void CSATSurveyAutomation(){
        
        Setting__c testSetting = new Setting__c(name='CSATSurveyRules - RecordType Inclusion List');
        insert testSetting;
        Setting_Item__c testSI = new Setting_Item__c(Text_1__c='T&F - CSD', Setting__c=testSetting.Id);
        insert testSI;
        
        Id devRecordTypeId = MiscFunctions.getRecordtypeId('Case', 'T&F - CSD');
        TriggerInterfaceHelper.runTrigger('CSATSurveyAutomation', 'Case', 99, 'ai,au', devRecordTypeId, null);
        
        //Run the method to create setting records if they aren't already there.
        settingRecordsAndConfigCheck();
        
        String runningUserId = UserInfo.getUserId();
        Account testAccount = zTEST_Shared.insertAccount(runningUserId);
        
        Contact testContact = zTEST_Shared.noinsertContact(runningUserId, testAccount.Id);
        testContact.Email = 'thisIsATestEmail@tandf.co.uk';
        insert testContact;
        
        //Remove any exclusions against the email address for tom.reed@tandf.co.uk.
        List<Setting_Item__c> settingItemToDelete = new List<Setting_Item__c>();
        for(Setting_Item__c si: [SELECT Id, Text_1__c, Text_2__c,  Text_3__c, Text_4__c, Text_5__c
                                 FROM Setting_Item__c 
                                 WHERE Setting__r.Name = 'CSATSurveyRules'
                                 AND Text_2__c like '%tandf%']){
                                     settingItemToDelete.add(si);   
                                 }
        if(settingItemToDelete.size()>0){
            delete settingItemToDelete;  
        }
        //Remove any CSAT records already associated with the test email tom.reed@tandf.co.uk.
        List<CSAT__c> csatRecords = new List<CSAT__c>();
        try{
            csatRecords = [SELECT Id FROM CSAT__c WHERE Customer_Email_Address__c = 'tom.reed@tandf.co.uk'];
        } catch(exception e){
            system.debug(e.getMessage());
        }
        if(csatRecords.size()>0){
            delete csatRecords; 
        }
        
        Test.StartTest();
        //Create some test cases to be returned in the report when the class runs.
        List<Case> casesToInsert = new List<Case>();
        Case testCase = new Case();
        testCase.RecordTypeId = devRecordTypeId;
        testCase.SuppliedEmail = 'tom.reed@tandf.co.uk';
        testCase.Subject = 'Test for zTest_CSATSurveyAutomation';
        testCase.Ready_for_CSAT_Survey__c=False;
        casesToInsert.add(testCase);         
        
        Case testCase2 = new Case();
        testCase2.RecordTypeId = devRecordTypeId;
        testCase2.SuppliedEmail = 'jeff.lup@informa.com';
        testCase2.Subject = 'Test for zTest_CSATSurveyAutomation';
        testCase2.Ready_for_CSAT_Survey__c=False;
        casesToInsert.add(testCase2);      
        
        Case testCase3 = new Case();
        testCase3.RecordTypeId = devRecordTypeId;
        testCase3.ContactId = testContact.Id;
        testCase3.Subject = 'Test for zTest_CSATSurveyAutomation';
        testCase3.Ready_for_CSAT_Survey__c=False;
        casesToInsert.add(testCase3); 
        
        if(casesToInsert.size()>0){
            insert casesToInsert;  
        }		
        List<Case> casesToUpdate = new List<Case>();
        for(Case c: [SELECT Id, Ready_for_CSAT_Survey__c FROM Case WHERE Id in: casesToInsert]){
            c.Ready_for_CSAT_Survey__c = TRUE;
            casesToUpdate.add(c);
        }
        if(casesToUpdate.size()>0){
          update casesToUpdate; 
        }
        
        CSATSurveyAutomationScheduled sh1 = new CSATSurveyAutomationScheduled();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test CSATSurveyAutomationScheduled', sch, sh1);

        
        Test.stopTest();
    }
    
    public static testmethod void settingRecordsAndConfigCheck(){
        
        CSAT_Configuration__c testCSATConfig = new CSAT_Configuration__c();
        //If there is already a CSAT config file use that otherwise create one.
        try{
            testCSATConfig = [SELECT Id
                              , Contact_Exclusion_Range__c
                              , Closed_Date_Range__c
                              , Closed_Date_Range_Length__c
                              , Run_in_Sandboxes__c FROM CSAT_Configuration__c LIMIT 1];
        } catch(exception e){
            system.debug(e.getMessage());
        }
        
        if(testCSATConfig.Id == null){
            CSAT_Configuration__c newTestCSATConfig = new CSAT_Configuration__c();
            newTestCSATConfig.Name = 'Configuration Data';
            newTestCSATConfig.Contact_Exclusion_Range__c = 30;
            newTestCSATConfig.Run_in_Sandboxes__c = TRUE;
            newTestCSATConfig.Closed_Date_Range__c = 6;
            newTestCSATConfig.Closed_Date_Range_Length__c = 7;
            insert newTestCSATConfig;
            testCSATConfig = [SELECT Id, Contact_Exclusion_Range__c, Closed_Date_Range__c FROM CSAT_Configuration__c WHERE Id =: newTestCSATConfig.Id LIMIT 1];
        }
        
        Setting__c existingSettingRecord = new Setting__c();
        Id settingRecordId; 
        //Check if the setting record is already in the system and if not create it.
        try{
            existingSettingRecord = [SELECT Id FROM Setting__c WHERE Name = 'CSATSurveyRules' LIMIT 1];
            settingRecordId = existingSettingRecord.Id;
        } catch(exception e){
            system.debug(e.getMessage());
        }
        
        if(existingSettingRecord.Id == null){
            Setting__c testSettingRecord = new Setting__c();    
            testSettingRecord.Name = 'CSATSurveyRules';
            insert testSettingRecord;
            settingRecordId = testSettingRecord.Id;
        }
        
        //Add a setting item records to be used.
        List<Setting_Item__c> settingItemRecordsToInsert = new List<Setting_Item__c>();
        Date dateToday = system.today();
        Setting_Item__c testSettingItem = new Setting_Item__c();
        testSettingItem.Text_1__c = 'Email'; //Exclusion Type
        testSettingItem.Text_2__c = 'jeff.lup@informa.com'; //Value
        testSettingItem.Text_3__c = String.ValueOf(dateToday.adddays(-1*Integer.ValueOf(testCSATConfig.Contact_Exclusion_Range__c)-1)); //Date Added
        testSettingItem.Text_4__c = 'External Survey'; //Source
        testSettingItem.Text_5__c = 'Exact'; //Match Type
        testSettingItem.Setting__c = settingRecordId; 
        settingItemRecordsToInsert.add(testSettingItem);
        
        Setting_Item__c testSettingItem2 = new Setting_Item__c();
        testSettingItem2.Text_1__c = 'Email'; //Exclusion Type
        testSettingItem2.Text_2__c = 'jeff.lup@informa.com'; //Value
        testSettingItem2.Text_3__c = String.ValueOf(dateToday); //Date Added
        testSettingItem2.Text_4__c = 'Salesforce'; //Source
        testSettingItem2.Text_5__c = 'Contains'; //Match Type
        testSettingItem2.Setting__c = settingRecordId; 
        settingItemRecordsToInsert.add(testSettingItem2);        
        
        Setting_Item__c testSettingItem3 = new Setting_Item__c();
        testSettingItem3.Text_1__c = 'Email'; //Exclusion Type
        testSettingItem3.Text_2__c = 'jeff.lup@informa.com'; //Value
        testSettingItem3.Text_3__c = String.ValueOf(dateToday); //Date Added
        testSettingItem3.Text_4__c = 'External Survey'; //Source
        testSettingItem3.Text_5__c = 'Exact'; //Match Type
        testSettingItem3.Setting__c = settingRecordId; 
        settingItemRecordsToInsert.add(testSettingItem3);
        
        Setting_Item__c testSettingItem4 = new Setting_Item__c();
        testSettingItem4.Text_1__c = 'Query Type'; //Exclusion Type
        testSettingItem4.Text_2__c = 'This is a test'; //Value
        testSettingItem4.Text_3__c = String.ValueOf(dateToday); //Date Added
        testSettingItem4.Text_4__c = 'Tom Reed'; //Source
        testSettingItem4.Text_5__c = 'Exact'; //Match Type
        testSettingItem4.Setting__c = settingRecordId; 
        settingItemRecordsToInsert.add(testSettingItem4);        
        
        Setting_Item__c testSettingItem5 = new Setting_Item__c();
        testSettingItem5.Text_1__c = 'Query Category'; //Exclusion Type
        testSettingItem5.Text_2__c = 'This is a test'; //Value
        testSettingItem5.Text_3__c = String.ValueOf(dateToday); //Date Added
        testSettingItem5.Text_4__c = 'Tom Reed'; //Source
        testSettingItem5.Text_5__c = 'Exact'; //Match Type
        testSettingItem5.Setting__c = settingRecordId; 
        settingItemRecordsToInsert.add(testSettingItem5);        
        
        Setting_Item__c testSettingItem6 = new Setting_Item__c();
        testSettingItem6.Text_1__c = 'Queue'; //Exclusion Type
        testSettingItem6.Text_2__c = 'This is a test'; //Value
        testSettingItem6.Text_3__c = String.ValueOf(dateToday); //Date Added
        testSettingItem6.Text_4__c = 'Tom Reed'; //Source
        testSettingItem6.Text_5__c = 'Exact'; //Match Type
        testSettingItem6.Setting__c = settingRecordId; 
        settingItemRecordsToInsert.add(testSettingItem6);         
        
        if(settingItemRecordsToInsert.size()>0){
            insert settingItemRecordsToInsert;
        }
    }
    
    public static testmethod void CSATEmailMessageHelper(){
        
        //Run the method to create setting records if they aren't already there.
        settingRecordsAndConfigCheck();
        
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        
        email.subject = 'Test';
        email.fromName = 'test test';
        email.toAddresses= new String[] {'tom.reed@tandf.co.uk'};
            email.fromAddress = 'tom.reed@tandf.co.uk';
        
        CSATEmailMessageHelper catcher = new CSATEmailMessageHelper();
        Messaging.InboundEmailResult result = catcher.handleInboundEmail(email, envelope);
        System.assertEquals( result.success  ,true);    
        List<Setting_item__c> resultList = [SELECT Text_2__c FROM Setting_Item__c 
                                            WHERE Text_2__c = 'tom.reed@tandf.co.uk' 
                                            AND Setting__r.Name = 'CSATSurveyRules' 
                                            AND Text_4__c = 'External Survey'];
        System.assertEquals( resultList.size()  , 1); 
        
        //Test a second time to prove that the email doesn't get added twice.
        CSATEmailMessageHelper catcher2 = new CSATEmailMessageHelper();
        Messaging.InboundEmailResult result2 = catcher.handleInboundEmail(email, envelope);
        System.assertEquals( result2.success  ,true); 
        
        List<Setting_item__c> resultList2 = [SELECT Text_2__c FROM Setting_Item__c 
                                             WHERE Text_2__c = 'tom.reed@tandf.co.uk' 
                                             AND Setting__r.Name = 'CSATSurveyRules' 
                                             AND Text_4__c = 'External Survey'];
        System.assertEquals( resultList2.size()  , 1); 
        
        
    }
}