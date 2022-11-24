/*
 * Class: TF_SapBPCreation_TaxCal_OHCallout_Trig
 * Created by: Piyush Jain
 * */
@isTest
public class ztest_TF_SapBPCreation_TaxCal_OHCallout {
    @isTest
    public static void testDirectSalesProcess(){
        Id quoteRecordtypeId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'Automated eBook Direct Sales Orders');
        
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        Id recordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F Automated eBooks Opportunity');
        
        SAP_BP__c sapObject = new SAP_BP__c(Account_Id__c = a.Id,First_Name__c = 'test_first_name',Last_Name__c = 'test_last_name',Email__c = 'test@gmail.com',Name = 'TPENDING',Street__c = 'Test Street',Region__c = 'Test_Region',Address_Type__c = 'Account Mailing',State__c = 'test state',Country__c = 'test',City__c = 'test city',Status__c = true);
        insert sapObject;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.StageName = 'Order Pending';
        opp.Order_Status__c = 'Failed';
        opp.AccountId = a.id;
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Bill_to_BP__c = sapObject.id;
        opp.Account_Validate_Opp__c = true;
        opp.Ship_to_BP__c = sapObject.id;
        insert opp;
        
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Opportunity2__c = opp.Id,SBQQ__BillingCity__c = 'test Billing',SBQQ__Account__c = a.Id, Payer_Account__c = a.Id, SBQQ__ExpirationDate__c = System.today() + 60, SBQQ__Status__c = 'Draft', SBQQ__Primary__c=true,Quote_Type__c = 'Direct Sale', RecordTypeId = quoteRecordtypeId); 
        insert quoteObject;
        TriggerInterfaceHelper.runTrigger('TF_SapBPCreation_TaxCal_OHCallout_Trig', 'SBQQ__Quote__c', 1, 'au', quoteRecordtypeId, null);
        Pricebook2 pricebk = new Pricebook2(Id = Test.getStandardPricebookId());
        
        Order o = new Order();
        o.OpportunityId = opp.Id;
        o.Name = 'Test Order ';
        o.Status = 'Draft';
        o.SBQQ__Quote__c = quoteObject.id;
        o.EffectiveDate = system.today();
        o.EndDate = system.today() + 4;
        o.AccountId = a.id;
        o.Pricebook2Id =  pricebk.Id ;
        o.Order_Channel__c = 'EBK AGENT SALES';
        o.Type = 'SALES';
        insert o;
        //Update quote to fire trigger
        quoteObject.SBQQ__Status__c = 'Accepted';
        update quoteObject;
        //Call this for code coverage of saqq quote interface
        TriggerInterface_SBQQ_Quote.codeCoverage();
    }
}