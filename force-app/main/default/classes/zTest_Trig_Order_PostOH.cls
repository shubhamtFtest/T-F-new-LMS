/**
Author : shashank
Test class :  zTestTF_PostOrderOnOrderHub
Description : This class is being used to create order on order HUb side. 
ref : TF_OrderHubWebServiceCallout
**/
@isTest
public class zTest_Trig_Order_PostOH { 
    @isTest
    public static void createOrder(){
        
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
        
        SAP_BP__c sapObject = new SAP_BP__c(Account_Id__c = a.Id,First_Name__c = 'test_first_name',Last_Name__c = 'test_last_name',Email__c = 'test@gmail.com',Name = 'PENDING',Street__c = 'Test Street',Region__c = 'Test_Region',Address_Type__c = 'Account Mailing',State__c = 'test state',Country__c = 'test',City__c = 'test city',Status__c = true);
        insert sapObject;
        sapbplst.add(sapObject);

        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.StageName = 'Prospect';
        opp.AccountId = a.id;
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Bill_to_BP__c = sapObject.id;
        opp.Order_Status__c = 'Failed';
        opp.Ship_to_BP__c = sapObject.id;
        opp.Account_Validate_Opp__c = true;
        insert opp;
        
        TF_OrgSpecificProps__c setting = new TF_OrgSpecificProps__c();
		setting.UBX_Order_Platform_uri__c = 'https://api-uat.taylorfrancis.com ';
        setting.OrderHubApi_URL__c = 'https://api-uat.taylorandfrancis.com/v1/orders/';
        setting.EmailAddressForOrderHubAlarmNotification__c = 'test@gmail.com';
        setting.Order_Hub_Mandatory_Countries__c = 'US,CA,BR';
        setting.EmailAddressFoTaxrAlarmNotification__c='test@gmail.com';
        insert setting; 
        
        //Create Quote
        Id quoteRecordtypeId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'Automated eBook Direct Sales Orders');
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Opportunity2__c = opp.Id,SBQQ__BillingCity__c = 'test Billing',SBQQ__Account__c = a.Id, Payer_Account__c = a.Id, SBQQ__ExpirationDate__c = System.today() + 60, SBQQ__Status__c = 'Accepted', SBQQ__Primary__c=true,Quote_Type__c = 'Direct Sale', RecordTypeId = quoteRecordtypeId,Invoice_Format__c='NORMAL');
        insert quoteObject;system.debug(quoteObject.recordTypeId);
        
        
        //create quotelinitem as bundled (SFAL-51 added by shubham kumar)
        /*SBQQ__QuoteLine__c quotelineObject = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteObject.Id,SBQQ__Bundle__c = true);
        insert quotelineObject;
        system.debug(quotelineObject.Id);*/
        
        
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
        
        PricebookEntry priceBookEntry = new PricebookEntry();
        priceBookEntry.UnitPrice = 1;
        priceBookEntry.Pricebook2Id = Test.getStandardPricebookId();
        priceBookEntry.Product2Id = pro.id;
        insert priceBookEntry;
        
        //SFAL-51 added shubham kumar 
        /*OrderItem orderProduct2 = new OrderItem();
        orderProduct2.SBQQ__QuoteLine__c = quotelineObject.Id;
        orderProduct2.OrderId = o.id;
        orderProduct2.Quantity = 1;
        orderProduct2.UnitPrice = 20;
        orderProduct2.PricebookEntryId = priceBookEntry.id;
        orderProduct2.SBQQ_NetTotal__c = 786786;
        orderProduct2.Discount_Amount__c = 786786;
        orderProduct2.SBQQ__OrderedQuantity__c = 786786;
        orderProduct2.SBQQ__TaxCode__c = 'Test';
        orderProduct2.SBQQ__TaxAmount__c = 786786;
        orderProduct2.SBQQ__OrderedQuantity__c = 786786;
        orderProduct2.SBQQ__TaxCode__c = 'Test';
        orderProduct2.SBQQ__TaxAmount__c = 786786;
        insert orderProduct2;
        update o;
        orderitemlst.add(orderProduct2);*/
        
        OrderItem orderProduct = new OrderItem();
        orderProduct.OrderId = o.id;
        orderProduct.Quantity = 1;
        orderProduct.UnitPrice = 20;
        orderProduct.PricebookEntryId = priceBookEntry.id;
        orderProduct.SBQQ_NetTotal__c = 786786;
        orderProduct.Discount_Amount__c = 786786;
        orderProduct.SBQQ__OrderedQuantity__c = 786786;
        orderProduct.SBQQ__TaxCode__c = 'Test';
        orderProduct.SBQQ__TaxAmount__c = 786786;
        orderProduct.SBQQ__OrderedQuantity__c = 786786;
        orderProduct.SBQQ__TaxCode__c = 'Test';
        orderProduct.SBQQ__TaxAmount__c = 786786;
        insert orderProduct;
        update o;
        orderitemlst.add(orderProduct);
        
        Map<String,String> testmap = new Map<String, String>();
        testmap.put('a', 'test');
        
        Trig_Order_PostOH Trig_Order_PostOHObj = new Trig_Order_PostOH();
        Trig_Order_PostOHObj.postOrderOnOrderHubMethod(orderList, orderitemlst, false, true, opp, sapbplst);
        Trig_Order_PostOHObj.initBody(o, quoteObject, orderitemlst, opp);
        Trig_Order_PostOH.sendEmail('error mssg ', 'http response', o.id );
		Trig_Order_PostOH.updateReqObjs(orderList, orderitemlst, 'error mssg ', opp, sapbplst);
        Trig_Order_PostOH.callOh('Test', 'Test Griri', testmap, o.id, false);
    }
    
    @isTest
    public static void createOrder_2(){
        
        List<Order> orderList = new List<Order>();
        List<SAP_BP__c> sapbplst = new List<SAP_BP__c>();
        List<OrderItem> orderitemlst = new List<OrderItem>();
        // create Direct_sales_order_settings__c 
        Direct_sales_order_settings__c cs = new Direct_sales_order_settings__c(Alert_Email_Addresses__c='dsd@jkh.com' ,OrderHub_post_order_domain__c = 'dummy domain',Post_orders_to_OH__c= true , Send_emails_on_failure__c = true  );
        insert cs; 
        
        TF_OrgSpecificProps__c setting = new TF_OrgSpecificProps__c();
		setting.OrderHubCalcTaxApi_URL__c = 'https://secure-uat.taylorfrancis.com/api/v4.0/tax/compute';
        setting.EmailAddressForOrderHubAlarmNotification__c = 'test@gmail.com';
        setting.OrderHubApi_URL__c = 'https://api-uat.taylorandfrancis.com/v1/orders/';
        setting.Order_Hub_Mandatory_Countries__c = 'US,CA,BR';
        setting.EmailAddressFoTaxrAlarmNotification__c='test@gmail.com';
        insert setting; 
        
        //Test Account Insert
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        Contact c = new Contact();
        c.Lastname ='Test Contact';
        insert c;
        Id recordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F Automated eBooks Opportunity');
        Id recordtypeId2 = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'T&F - OA Journal Quote');
        
        // Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        Pricebook2 pricebk = new Pricebook2(Id = Test.getStandardPricebookId());
        
        Department__c  dept = New Department__c();
        dept.Name = 'Dept_1';
        dept.Account__c = a.Id;
        Insert dept;
        
        Campus__c camp = New Campus__c();
        camp.Name = 'Camp1';
        camp.Account__c = a.Id;
        Insert camp;
        
        SAP_BP__c sapObject = new SAP_BP__c(Account_Id__c = a.Id,First_Name__c = 'test_first_name',Last_Name__c = 'test_last_name',Email__c = 'test@gmail.com',Name = 'PENDING',Street__c = 'Test Street',Region__c = 'Test_Region',Address_Type__c = 'Campus',State__c = 'test state',Country__c = 'test',City__c = 'test city',Status__c = true,
                                           Department_Id__c = dept.Id, Department__c='Campus', Campus_Id__c = camp.Id);
        insert sapObject;
        sapbplst.add(sapObject);
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.StageName = 'Prospect';
        opp.AccountId = a.id;
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Bill_to_BP__c = sapObject.id;
        opp.Order_Status__c = 'Failed';
        opp.Ship_to_BP__c = sapObject.id;
        opp.Account_Validate_Opp__c = true;
        insert opp;
        
        //Create Quote
        Id quoteRecordtypeId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'Automated eBook Direct Sales Orders');
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Opportunity2__c = opp.Id,SBQQ__BillingCity__c = 'test Billing',SBQQ__Account__c = a.Id, Payer_Account__c = a.Id, SBQQ__ExpirationDate__c = System.today() + 60, SBQQ__Status__c = 'draft', SBQQ__Primary__c=true,Quote_Type__c = 'Direct Sale', RecordTypeId = recordtypeId2,
                                                       SBQQ__Notes__c = 'This is the test class tests1 class test', DOI__c = 'Test1', Author_Status__c = 'Accepted', Article_Acceptance_Status__c = 'Accepted', CSD_Approval_Status__c = 'Approved',Invoice_Format__c='NORMAL');
        insert quoteObject;system.debug(quoteObject.recordTypeId);
                
        Country__c countryObject = new Country__c(Name = 'test');
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
        
        PricebookEntry priceBookEntry = new PricebookEntry();
        priceBookEntry.UnitPrice = 1;
        priceBookEntry.Pricebook2Id = Test.getStandardPricebookId();
        priceBookEntry.Product2Id = pro.id;
        insert priceBookEntry;
        
        OrderItem orderProduct = new OrderItem();
        orderProduct.OrderId = o.id;
        orderProduct.Quantity = 1;
        orderProduct.UnitPrice = 20;
        orderProduct.PricebookEntryId = priceBookEntry.id;
        orderProduct.SBQQ_NetTotal__c = 786786;
        orderProduct.Discount_Amount__c = 786786;
        orderProduct.SBQQ__OrderedQuantity__c = 786786;
        orderProduct.SBQQ__TaxCode__c = 'Test';
        orderProduct.SBQQ__TaxAmount__c = 786786;
        orderProduct.SBQQ__OrderedQuantity__c = 786786;
        orderProduct.SBQQ__TaxCode__c = 'Test';
        orderProduct.SBQQ__TaxAmount__c = 786786;
        
        insert orderProduct;
        update o;
        orderitemlst.add(orderProduct);
        
        Map<String,String> testmap = new Map<String, String>();
        testmap.put('a', 'test');
        
        Trig_Order_PostOH Trig_Order_PostOHObj = new Trig_Order_PostOH();
        Trig_Order_PostOHObj.postOrderOnOrderHubMethod(orderList, orderitemlst, false, true, opp, sapbplst);
        Trig_Order_PostOHObj.initBody(o, quoteObject, orderitemlst, opp);
        Trig_Order_PostOH.sendEmail('error mssg ', 'http response', o.id );
		Trig_Order_PostOH.updateReqObjs(orderList, orderitemlst, 'error mssg ', opp, sapbplst);
        Trig_Order_PostOH.callOh('Test', 'Test Griri', testmap, o.id, false);
    }
	
    @isTest
    public static void createOrder_3(){
        
        List<Order> orderList = new List<Order>();
        List<SAP_BP__c> sapbplst = new List<SAP_BP__c>();
        List<OrderItem> orderitemlst = new List<OrderItem>();
        // create Direct_sales_order_settings__c 
        Direct_sales_order_settings__c cs = new Direct_sales_order_settings__c(Alert_Email_Addresses__c='dsd@jkh.com' ,OrderHub_post_order_domain__c = 'dummy domain',Post_orders_to_OH__c= true , Send_emails_on_failure__c = true  );
        insert cs; 
        
        // create TF_OrgSpecificProps__c
        TF_OrgSpecificProps__c setting = new TF_OrgSpecificProps__c();
		setting.OrderHubCalcTaxApi_URL__c = 'https://secure-uat.taylorfrancis.com/api/v4.0/tax/compute';
        setting.OrderHubApi_URL__c = 'https://api-uat.taylorandfrancis.com/v1/orders/';
        setting.EmailAddressForOrderHubAlarmNotification__c = 'test@gmail.com';
        setting.Order_Hub_Mandatory_Countries__c = 'US,CA,BR';
        setting.EmailAddressFoTaxrAlarmNotification__c='test@gmail.com';
        insert setting; 
        
        //Test Account Insert
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        Contact c = new Contact();
        c.Lastname ='Test Contact';
        insert c;
        Id recordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F Automated eBooks Opportunity');
        Id recordtypeId2 = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'T&F - BPC Quote Type');
        
        // Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        Pricebook2 pricebk = new Pricebook2(Id = Test.getStandardPricebookId());
        
        Department__c  dept = New Department__c();
        dept.Name = 'Dept_1';
        dept.Account__c = a.Id;
        Insert dept;
        
        Campus__c camp = New Campus__c();
        camp.Name = 'Camp1';
        camp.Account__c = a.Id;
        Insert camp;
        
        SAP_BP__c sapObject = new SAP_BP__c(Account_Id__c = a.Id,First_Name__c = 'test_first_name',Last_Name__c = 'test_last_name',Email__c = 'test@gmail.com',Name = 'PENDING',Street__c = 'Test Street',Region__c = 'Test_Region',Address_Type__c = 'Department',State__c = 'test state',Country__c = 'test',City__c = 'test city',Status__c = true,
                                           Department_Id__c = dept.Id, Department__c='Campus', Campus_Id__c = camp.Id, Message__c = 'Bill to');
        insert sapObject;
        sapbplst.add(sapObject);
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.StageName = 'Prospect';
        opp.AccountId = a.id;
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Bill_to_BP__c = sapObject.id;
        opp.Order_Status__c = 'Failed';
        opp.Ship_to_BP__c = sapObject.id;
        opp.Account_Validate_Opp__c = true;
        insert opp;
        
        //Create Quote
        Id quoteRecordtypeId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'Automated eBook Direct Sales Orders');
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Opportunity2__c = opp.Id,SBQQ__BillingCity__c = 'test Billing',SBQQ__Account__c = a.Id, Payer_Account__c = a.Id, SBQQ__ExpirationDate__c = System.today() + 60, SBQQ__Status__c = 'Accepted', SBQQ__Primary__c=true,Quote_Type__c = 'Direct Sale', RecordTypeId = recordtypeId2,
                                                       SBQQ__Notes__c = 'This is the test class tests1 class test', DOI__c = 'Test1', Author_Status__c = 'Accepted', Article_Acceptance_Status__c = 'Accepted', CSD_Approval_Status__c = 'Approved',Invoice_Format__c='NORMAL');
        insert quoteObject;system.debug(quoteObject.recordTypeId);
        
        //SELECT ,SBQQ__Bundled__c,SBQQ__Bundle__c FROM SBQQ__QuoteLine__c WHERE SBQQ__Bundled__c != null
        SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(SBQQ__Bundled__c = true,SBQQ__Quote__c = quoteObject.Id);
        try {
        insert quoteLineObject;system.debug(quoteLineObject.recordTypeId);
        } catch ( Exception ex ) {
            System.debug('**************QLI Failure Test class **************' + ex.getMessage());
        }
        
        Country__c countryObject = new Country__c(Name = 'test');
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
        
        PricebookEntry priceBookEntry = new PricebookEntry();
        priceBookEntry.UnitPrice = 1;
        priceBookEntry.Pricebook2Id = Test.getStandardPricebookId();
        priceBookEntry.Product2Id = pro.id;
        insert priceBookEntry;
        
        OrderItem orderProduct = new OrderItem();
        orderProduct.OrderId = o.id;
        orderProduct.Quantity = 1;
        orderProduct.UnitPrice = 20;
        orderProduct.PricebookEntryId = priceBookEntry.id;
        orderProduct.SBQQ_NetTotal__c = 786786;
        orderProduct.Discount_Amount__c = 786786;
        orderProduct.SBQQ__OrderedQuantity__c = 786786;
        orderProduct.SBQQ__TaxCode__c = 'Test';
        orderProduct.SBQQ__TaxAmount__c = 786786;
        orderProduct.SBQQ__OrderedQuantity__c = 786786;
        orderProduct.SBQQ__TaxCode__c = 'Test';
        orderProduct.SBQQ__TaxAmount__c = 786786;
        orderProduct.PCM_DOI__c = 'TestDOI';
        insert orderProduct;
        update o;
        orderitemlst.add(orderProduct);
        
        Map<String,String> testmap = new Map<String, String>();
        testmap.put('a', 'test');
        
        Trig_Order_PostOH Trig_Order_PostOHObj = new Trig_Order_PostOH();
        Trig_Order_PostOHObj.postOrderOnOrderHubMethod(orderList, orderitemlst, false, true, opp, sapbplst);
        Trig_Order_PostOHObj.initBody(o, quoteObject, orderitemlst, opp);
        Trig_Order_PostOH.sendEmail('error mssg ', 'http response', o.id );
		Trig_Order_PostOH.updateReqObjs(orderList, orderitemlst, 'error mssg ', opp, sapbplst);
        Trig_Order_PostOH.callOh('Test', 'Test Griri', testmap, o.id, false);
    }
    
    @isTest
    public static void createOrder_4(){
        
        List<Order> orderList = new List<Order>();
        List<SAP_BP__c> sapbplst = new List<SAP_BP__c>();
        List<OrderItem> orderitemlst = new List<OrderItem>();
        // create Direct_sales_order_settings__c 
        Direct_sales_order_settings__c cs = new Direct_sales_order_settings__c(Alert_Email_Addresses__c='dsd@jkh.com' ,OrderHub_post_order_domain__c = 'dummy domain',Post_orders_to_OH__c= true , Send_emails_on_failure__c = true  );
        insert cs; 
        
        // create TF_OrgSpecificProps__c
        TF_OrgSpecificProps__c setting = new TF_OrgSpecificProps__c();
        setting.OrderHubCalcTaxApi_URL__c = 'https://secure-uat.taylorfrancis.com/api/v4.0/tax/compute';
        setting.OrderHubApi_URL__c = 'https://api-uat.taylorandfrancis.com/v1/orders/';
        setting.Order_Hub_Mandatory_Countries__c = 'US,CA,BR';
        setting.EmailAddressForOrderHubAlarmNotification__c = 'test@gmail.com';
        setting.EmailAddressFoTaxrAlarmNotification__c='test@gmail.com';
        insert setting;         
        //Test Account Insert
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        Contact c = new Contact();
        c.Lastname ='Test Contact';
        insert c;
        Id recordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F Automated eBooks Opportunity');
        Id recordtypeId2 = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'T&F - BPC Quote Type');
        
        // Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        Pricebook2 pricebk = new Pricebook2(Id = Test.getStandardPricebookId());
        
        Department__c  dept = New Department__c();
        dept.Name = 'Dept_1';
        dept.Account__c = a.Id;
        Insert dept;
        
        Campus__c camp = New Campus__c();
        camp.Name = 'Camp1';
        camp.Account__c = a.Id;
        Insert camp;
        
        SAP_BP__c sapObject = new SAP_BP__c(Account_Id__c = a.Id,First_Name__c = 'test_first_name',Last_Name__c = 'test_last_name',Email__c = 'test@gmail.com',Name = 'PENDING',Street__c = 'Test Street',Region__c = 'Test_Region',Address_Type__c = 'Department',State__c = 'test state',Country__c = 'test',City__c = 'test city',Status__c = true,
                                           Department_Id__c = dept.Id, Department__c='Campus', Campus_Id__c = camp.Id, Message__c = 'Ship to');
        insert sapObject;
        sapbplst.add(sapObject);
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.StageName = 'Prospect';
        opp.AccountId = a.id;
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Bill_to_BP__c = sapObject.id;
        opp.Order_Status__c = 'Failed';
        opp.Ship_to_BP__c = sapObject.id;
        opp.Account_Validate_Opp__c = true;
        insert opp;
        
        //Create Quote
        Id quoteRecordtypeId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'Automated eBook Direct Sales Orders');
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Opportunity2__c = opp.Id,SBQQ__BillingCity__c = 'test Billing',SBQQ__Account__c = a.Id, Payer_Account__c = a.Id, SBQQ__ExpirationDate__c = System.today() + 60, SBQQ__Status__c = 'Accepted', SBQQ__Primary__c=true,Quote_Type__c = 'Direct Sale', RecordTypeId = recordtypeId2,
                                                       SBQQ__Notes__c = 'This is the test class tests1 class test', DOI__c = 'Test1', Author_Status__c = 'Accepted', Article_Acceptance_Status__c = 'Accepted', CSD_Approval_Status__c = 'Approved',Invoice_Format__c='NORMAL');
        insert quoteObject;
		system.debug(quoteObject.recordTypeId);
        Country__c countryObject = new Country__c(Name = 'test');
        insert countryObject;
        
        Order o = new Order();
        o.OpportunityId = opp.Id;
        o.Name = 'Test Order ';
        o.Status = 'Draft';
        o.SBQQ__Quote__c = quoteObject.id;
        o.EffectiveDate = system.today();
        o.EndDate = system.today() + 4;
        o.AccountId = a.id;
        o.Message__c = 'Test';
        o.Pricebook2Id =  pricebk.Id ;
        o.Order_Channel__c = 'EBK AGENT SALES';
        o.Type = 'SALES';
        insert o;
        system.debug('line number 374');
        orderList.add(o);
            
        Product2 pro = new Product2();
        pro.Name = 'Test';
        insert pro;
        
        PricebookEntry priceBookEntry = new PricebookEntry();
        priceBookEntry.UnitPrice = 1;
        priceBookEntry.Pricebook2Id = Test.getStandardPricebookId();
        priceBookEntry.Product2Id = pro.id;
        insert priceBookEntry;
        
        OrderItem orderProduct = new OrderItem();
        orderProduct.OrderId = o.id;
        orderProduct.Quantity = 1;
        orderProduct.UnitPrice = 20;
        orderProduct.PricebookEntryId = priceBookEntry.id;
        orderProduct.SBQQ_NetTotal__c = 786786;
        orderProduct.Discount_Amount__c = 786786;
        orderProduct.SBQQ__OrderedQuantity__c = 786786;
        orderProduct.SBQQ__TaxCode__c = 'Test';
        orderProduct.SBQQ__TaxAmount__c = 786786;
        orderProduct.SBQQ__OrderedQuantity__c = 786786;
        orderProduct.SBQQ__TaxCode__c = 'Test';
        orderProduct.SBQQ__TaxAmount__c = 786786;
        orderProduct.PCM_ISBN__c = 'TestISBN';
        insert orderProduct;
        update o;
        orderitemlst.add(orderProduct);
        
        Map<String,String> testmap = new Map<String, String>();
        testmap.put('a', 'test');
        
        Trig_Order_PostOH Trig_Order_PostOHObj = new Trig_Order_PostOH();
        Trig_Order_PostOHObj.postOrderOnOrderHubMethod(orderList, orderitemlst, false, true, opp, sapbplst);
        Trig_Order_PostOHObj.initBody(o, quoteObject, orderitemlst, opp);
        Trig_Order_PostOH.sendEmail('error mssg ', 'http response', o.id );
		Trig_Order_PostOH.updateReqObjs(orderList, orderitemlst, 'error mssg ', opp, sapbplst);
        Trig_Order_PostOH.callOh('Test', 'Test Griri', testmap, o.id, false);
    }
    
    public class TokenDetailsGeneratorSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            TokenDetails token = new TokenDetails();
            String response = 'Test';
            res.setBody(response);
            res.setStatusCode(200);
            return res;
        }
    }
    class TokenDetails {
        private String details ='TokenValue' ;
        private String access_token ='123';
        private String token_type ='123';
        private Decimal expires_in = 123;
        private String id_token='123'; 
        private String refresh_token='123';
    }
    
}