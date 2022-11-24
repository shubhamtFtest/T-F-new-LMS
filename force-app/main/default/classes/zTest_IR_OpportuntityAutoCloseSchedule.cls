/**************************************************
* Created by Amit Kumar, 2021.02.12
* Test Class For IR_OpportuntityAutoCloseSchedule Class
**************************************************/
@isTest
public class zTest_IR_OpportuntityAutoCloseSchedule {
    
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
                
        test.startTest();
        IR_OpportuntityAutoCloseSchedule runClass = new IR_OpportuntityAutoCloseSchedule(); 
        runClass.execute(null);
        test.stopTest();
    }
}