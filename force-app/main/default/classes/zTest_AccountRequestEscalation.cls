/**************************************************
* Created by Tom Reed, 2018.07.09
* Test Class For AccountRequestEscalation Class
**************************************************/
@isTest
public class zTest_AccountRequestEscalation {
    
    public static testmethod void runzTest_AccountRequestEscalation(){
        Id requestRT = MiscFunctions.getRecordtypeId('Account', 'Account Request');
        //Create test Account
        User testUser = zTest_Shared.insertUser();
        Account testAccount = new Account(RecordtypeId = requestRT
                                          , Name = 'Test Account'
                                          , Industry = 'other'
                                          , Account_Status__c = 'Submit for Approval'
                                          , Phone = '12345678910'
                                          , Type = 'Institution'
                                          , Classification__c = 'Institution'
                                          , Website = 'test'
                                          , Shipping_Country_List__c = 'United Kingdom'
                                          , BillingStreet = 'Oxford Street'
                                          , BillingCity = 'Oxford'
                                          , BillingPostalCode = 'OX1 TEST'
                                          , Mailing_Country_List__c = 'United Kingdom'
                                          , Mailing_State_List__c = 'Oxfordshire'
                                          , Shipping_State_List__c = 'Oxfordshire'
                                          , Billing_City__c = 'Oxford'
                                          , Locale__c = 'EMEA'
                                          , Sales_Region__c = 'United Kingdom'
                                         );
        
        insert testAccount;
        
        // Create an approval request for the account
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setObjectId(testAccount.id);
        
        // Submit the record to specific process and skip the criteria evaluation
        req1.setProcessDefinitionNameOrId('Account_Approval_Process');    
        req1.setSkipEntryCriteria(true);
        
        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1);
        
        Setting__c accountApprovalEscalatationRecipientsSetting = new Setting__c(Name = 'Account Approval Process');
        insert accountApprovalEscalatationRecipientsSetting;
        Setting_Item__c accountApprovalEscalatationRecipientsSettingItem = new Setting_Item__c(Text_1__c = '4', Text_2__c = 'jeff.lup@informa.com', Setting__c = accountApprovalEscalatationRecipientsSetting.id);
        insert accountApprovalEscalatationRecipientsSettingItem;
        
        test.startTest();
        AccountRequestEscalation runClass = new AccountRequestEscalation(); 
        runClass.execute(null);
        test.stopTest();
    }
}