/**
Author : shashank
 
**/
@isTest
public class zTest_LockRecDS {
    @TestSetup
    static void makeData(){

        List<Order> orderList = new List<Order>();
        List<SAP_BP__c> sapbplst = new List<SAP_BP__c>();
        List<OrderItem> orderitemlst = new List<OrderItem>();
         // create Direct_sales_order_settings__c 
         Direct_sales_order_settings__c cs = new Direct_sales_order_settings__c(Alert_Email_Addresses__c='dsd@jkh.com' ,OrderHub_post_order_domain__c = 'dummy domain',Post_orders_to_OH__c= true , Send_emails_on_failure__c = true  );
         insert cs; 
         
         //Test Account Insert
         Account a = new Account();
         a.Name = 'Test Account';
        
         insert a;
         Id recordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F Automated eBooks Opportunity');
         
         // Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
         Pricebook2 pricebk = new Pricebook2(Id = Test.getStandardPricebookId());
         
         SAP_BP__c sapObject = new SAP_BP__c(Account_Id__c = a.Id,First_Name__c = 'test_first_name',Last_Name__c = 'test_last_name',Email__c = 'test@gmail.com',Name = 'TPENDING',Street__c = 'Test Street',Region__c = 'Test_Region',Address_Type__c = 'Account Mailing',State__c = 'test state',Country__c = 'test',City__c = 'test city',Status__c = true);
         insert sapObject;
         sapbplst.add(sapObject);
         
         Opportunity opp = new Opportunity();
         opp.Name = 'Test';
         opp.StageName = 'Acceptance';
         opp.AccountId = a.id;
         opp.CloseDate = Date.newInstance(2019, 12, 9);
         opp.Bill_to_BP__c = sapObject.id;
         opp.Order_Status__c = 'Failed';
         opp.Ship_to_BP__c = sapObject.id;
         opp.Account_Validate_Opp__c = true;
         opp.recordtypeId = recordtypeId;
         insert opp;
         
         //Create Quote
         Id quoteRecordtypeId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'Automated eBook Direct Sales Orders');
         SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Opportunity2__c = opp.Id,SBQQ__BillingCity__c = 'test Billing',SBQQ__Account__c = a.Id, Payer_Account__c = a.Id, SBQQ__ExpirationDate__c = System.today() + 60, SBQQ__Status__c = 'Accepted', SBQQ__Primary__c=true,Quote_Type__c = 'Direct Sale', RecordTypeId = quoteRecordtypeId); 
         insert quoteObject;system.debug(quoteObject.recordTypeId);

        //  SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteObject.Id,Discount_Rules_Applied__c = 'Prepay');
        //         insert quoteLineObject;  
                

                 
         Country__c countryObject = new Country__c(Country_2__c = 'ab',Name = 'test');
         insert countryObject;
         
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
         orderList.add(o);
             
         Product2 pro = new Product2();
         pro.Name = 'Test';
         insert pro;
         
    }

   @isTest
   public static void testLockRec(){
    Id recId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F Automated eBooks Opportunity');
    TriggerInterfaceHelper.runTrigger('Trig_lockOpp', 'Opportunity', 1, 'au', recId, null);
    Opportunity op = [SELECT id,StageName FROM opportunity LIMIT 1];
    op.StageName = 'closed Won';
    update op;
    system.debug('op'+op);
    LockRecorddirectSalesCntrl.showMessg( [SELECT id FROM opportunity LIMIT 1 ].Id, 'opportunity' );
    }
    @isTest
    public static void testLockRecSAPBp(){
        TriggerInterfaceHelper.runTrigger('LockSapBpRec', 'SAP_BP__c', 1, 'au', null, null);
        SAP_BP__c obj  = [SELECT id, name FROM SAP_BP__c LIMIT 1];
        obj.name = 'pending';
        update obj;
        system.debug('op'+obj);
        }

        @isTest
        public static void quoteList(){
            //TF_FetchQuoteLineItems.fetchQuoteLineItems([SELECT Id from SBQQ__Quote__c].Id);
        }

}