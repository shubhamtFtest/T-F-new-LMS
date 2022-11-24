/***************************************************************************
Author : Vikas Varshney
Apex class : TF_OrderUpdateLMS_Trigger
****************************************************************************/

@isTest
global class zTest_TF_OrderUpdateLMS_Trigger {
    
    static testMethod void orderCreateTest() {
        String automatedRTId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Automated eBook Direct Sales Order').getRecordTypeId();
        TriggerInterfaceHelper.runTrigger('TF_OrderUpdateLMS_Trigger', 'Order', 1, 'ai', automatedRTId, null);
        
        Account acc = new Account();
        acc.Customer_Id__c = '98422';
        acc.name = 'TestAcc';
        insert acc;
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F Automated eBooks Opportunity').getRecordTypeId();
        
        SAP_BP__c SAP_BP_Record = new SAP_BP__c();
        SAP_BP_Record.Name = 'Pending';
        SAP_BP_Record.Address_Type__c = 'Account Mailing';
        SAP_BP_Record.Country__c = 'India';
        insert SAP_BP_Record;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.StageName = 'Acceptance';
        opp.AccountId = acc.id;
        opp.CloseDate = Date.today().addDays(500);
        opp.Order_Status__c = 'Pending';
        opp.Account_Validate_Opp__c = true;
        opp.recordTypeId = oppRecordTypeId;
        opp.Bill_To_BP__c = SAP_BP_Record.id;
        opp.TF_eBook_License_Type__c = 'Static';
        insert opp;
        
        Id quoteRecordtypeId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'Automated eBook Direct Sales Orders');
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(CurrencyIsoCode = 'USD',
        SBQQ__Opportunity2__c = opp.Id,
        SBQQ__BillingCity__c = 'test Billing',
        SBQQ__Account__c = acc.Id,
        Payer_Account__c = acc.Id,
        SBQQ__ExpirationDate__c = System.today() + 60,
        SBQQ__Status__c = 'Accepted',
        SBQQ__Primary__c=true,
        Quote_Type__c = 'Direct Sale',
        TF_eBook_Subscription_Start_Date__c = Date.today(),
        TF_eBook_Subscription_End_Date__c = Date.today().addDays(10),
        Business_Model__c = 'Perpetual',
        RecordTypeId = quoteRecordtypeId); 
        insert quoteObject;
        
        Pricebook2 pricebk = new Pricebook2(Id = Test.getStandardPricebookId());
        
        Order o = new Order();
        o.OpportunityId = opp.Id;
        o.Name = 'Test Order ';
        o.Status = 'Draft';
        o.SBQQ__Quote__c = quoteObject.id;
        o.EffectiveDate = system.today();
        o.EndDate = system.today() + 4;
        o.AccountId = acc.id;
        o.Pricebook2Id =  pricebk.Id ;
        o.Order_Channel__c = 'EBK AGENT SALES';
        o.Type = 'SALES';
        insert o;
    }
}