/**Auther: Shalini Singh
Class: PCMOppSyncControllerDS
**/
@isTest
public class PCMOppSyncControllerDSTest implements HttpCalloutMock{
    private integer statusCode; 
    private String responseJson; 
    
    public PCMOppSyncControllerDSTest(integer statusCode, String responseJson){
        this.statusCode = statusCode; 
        this.responseJson = responseJson;
    }
    
    public HTTPResponse respond(HTTPRequest req) {
        if(responseJson != 'validate test'){
            // Create a mock response
            HttpResponse resp = new HttpResponse();
            resp.setHeader('Content-Type', 'application/json');
            resp.setBody(responseJson);      
            resp.setStatusCode(statusCode);
            return resp;
        } else{
            String resptJson ;
            if(req.getEndpoint().endsWith('.json') && req.getMethod() == 'PUT'){
                resptJson = '{test}';
                HttpResponse resp = new HttpResponse();
                resp.setHeader('Content-Type', 'application/json');
                resp.setBody(resptJson);      
                resp.setStatusCode(200);
                return resp;
            } else if(req.getEndpoint().endsWith('user/auth/token')){
                resptJson = '{"access_token":"10edc9086eefa8e672eca3ad1b0040a2","token_type":"Bearer","expires_in":3600,"id_token":"eyJhbGciOiJSUzI1NiIsI"}';
                
                HttpResponse resp = new HttpResponse();
                resp.setHeader('Content-Type', 'application/json');
                resp.setBody(resptJson);       
                resp.setStatusCode(200);
                return resp;
            }else if(req.getEndpoint().contains('entitlements') && req.getMethod() == 'POST'){
                resptJson = '[{"customerId":"98422","packageId":"38149258","packageVersion":"null","productId":"0023303d-524f-49a0-93a5-00db3ccb9a39","licenseId":"118415","status":"ACTIVE"},{"customerId":"98422","packageId":"38149258","packageVersion":"null","productId":"005ba6ce-e021-4eb0-a358-00b0392029bc","licenseId":"118415","status":"ACTIVE"},{"customerId":"98422","packageId":"38149258","packageVersion":"null","productId":"0075083f-7492-47d5-818f-bf93bcde1fdf","licenseId":"118415","status":"ACTIVE"}]';
                HttpResponse resp = new HttpResponse();
                resp.setHeader('Content-Type', 'application/json');
                resp.setBody(resptJson);      
                resp.setStatusCode(200);
                return resp;
            }else if (req.getEndpoint().endsWith('type=partslist') && req.getMethod() == 'GET'){
                resptJson = '[{"location": "testlocation","type": "csv"}]';
                HttpResponse resp = new HttpResponse();
                resp.setHeader('Content-Type', 'application/json');
                resp.setBody(resptJson);      
                resp.setStatusCode(statusCode);
                return resp;
            }
            
        } 
        return null;
    }
    
    private static SBQQ__Quote__c  insertDataforTesting(){
        
        //Test Account Insert
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        EntitlementDataWrapper edws = new EntitlementDataWrapper();
        edws.customerId = '98422';
        edws.productId = '0023303d-524f-49a0-93a5-00db3ccb9a39';
        edws.licenseId = '118415';
        edws.packageVersion = null;
        edws.packageId = '38149258';
        edws.status = 'ACTIVE';
        
        TF_OrgSpecificProps__c setting = new TF_OrgSpecificProps__c();
        setting.OrderHubCalcTaxApi_URL__c = 'https://secure-uat.taylorfrancis.com/api/v4.0/tax/compute';
        setting.OrderHubApi_URL__c = 'https://api-uat.taylorandfrancis.com/v1/orders/';
        setting.UBX_Order_Platform_uri__c = 'https://api-uat.taylorfrancis.com';
        setting.New_Platform_Api_URL__c = 'https://api-uat.taylorfrancis.com';
        setting.Quote_Items_Threshold__c = '50';
        setting.EmailAddressForOrderHubAlarmNotification__c = 'test@gmail.com';
        setting.Order_Hub_Mandatory_Countries__c = 'US,CA,BR';
        setting.EmailAddressFoTaxrAlarmNotification__c='test@gmail.com';
        insert setting; 
        
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F Automated eBooks Opportunity').getRecordTypeId();
        List<PricebookEntry> priceBookEntryList = new List<PricebookEntry>();
        
        Country__c countryRecord = new Country__c(Name = 'India', Country_2__c ='IN');
        insert countryRecord;
        
        SAP_BP__c SAP_BP_Record = new SAP_BP__c();
        SAP_BP_Record.Name = 'Pending';
        SAP_BP_Record.Address_Type__c = 'Account Mailing';
        SAP_BP_Record.Country__c = 'India';
        insert SAP_BP_Record;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.StageName = 'Acceptance';
        opp.AccountId = a.id;
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Order_Status__c = 'Pending';
        opp.Account_Validate_Opp__c = true;
        opp.recordTypeId = oppRecordTypeId;
        opp.Bill_To_BP__c = SAP_BP_Record.id;
        opp.TF_eBook_License_Type__c   = 'Static';
        insert opp;
        
        Id quoteRecordtypeId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'Automated eBook Direct Sales Orders');
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(CurrencyIsoCode = 'USD', SBQQ__Opportunity2__c = opp.Id,SBQQ__BillingCity__c = 'test Billing',SBQQ__Account__c = a.Id, Payer_Account__c = a.Id, SBQQ__ExpirationDate__c = System.today() + 60, SBQQ__Status__c = 'Accepted', SBQQ__Primary__c=true,Quote_Type__c = 'Direct Sale', RecordTypeId = quoteRecordtypeId); 
        insert quoteObject;
        system.debug('quoteObject'+quoteObject);
        
        Product2 pro = new Product2();
        pro.Name = 'T&F – OA BPC PriceBook';
        pro.ISBN__c = '123456';
        pro.Hub_Id__c = '0023303d-524f-49a0-93a5-00db3ccb9a39';
        pro.ProductCode = '9781003099277';
        pro.Lead_Author_Editor__c = 'Raj';
        insert pro;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = pro.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 pricebk = new Pricebook2(Name='T&F - eBooks Pricebook', isActive=true);
        insert pricebk;
        
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = pricebk.Id, Product2Id = pro.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        list<string> isbn =  new list<string>();
        isbn.add('element');
        list<string> uuiset =  new list<string>();
        uuiset.add('element');
        PCMOppSyncControllerDS.getProductDetails('usd',isbn);
        PCMOppSyncControllerDS.getProductDetailsByType('usd',isbn,'book',uuiset);
        PCMOppSyncControllerDS.getProductDetailsByType('usd',isbn,'collection',uuiset);
        SBQQ__QuoteLine__c qli = new SBQQ__QuoteLine__c();
        qli.SBQQ__Quote__c = quoteObject.Id;
        qli.SBQQ__Product__c = pro.Id;
        qli.SBQQ__PricebookEntryId__c = customPrice.Id;
        qli.PCM_ISBN__c = '1234567';
        qli.PCM_UUID__c = '0023303d-524f-49a0-93a5-00db3ccb9a39';
        qli.PCM_Product_Name__c = 'TestProduct';
        qli.PCM_Author_Name__c = 'testAuthor';
        qli.SBQQ__ListPrice__c = 1000;
        qli.Line_reference__c = 'test';
        qli.PCM_DOI__c = 'test';
        INSERT qli;
        system.debug('qli'+qli);
        
        return quoteObject;
    }
    
    @isTest
    public static void test_MoppSync(){
        
        //Test Account Insert
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        EntitlementDataWrapper edws = new EntitlementDataWrapper();
        edws.customerId = '98422';
        edws.productId = '0023303d-524f-49a0-93a5-00db3ccb9a39';
        edws.licenseId = '118415';
        edws.packageVersion = null;
        edws.packageId = '38149258';
        edws.status = 'ACTIVE';
        
        TF_OrgSpecificProps__c setting = new TF_OrgSpecificProps__c();
        setting.OrderHubCalcTaxApi_URL__c = 'https://secure-uat.taylorfrancis.com/api/v4.0/tax/compute';
        setting.OrderHubApi_URL__c = 'https://api-uat.taylorandfrancis.com/v1/orders/';
        setting.UBX_Order_Platform_uri__c = 'https://api-uat.taylorfrancis.com';
        setting.New_Platform_Api_URL__c = 'https://api-uat.taylorfrancis.com';
        setting.Quote_Items_Threshold__c = '50';
        setting.EmailAddressForOrderHubAlarmNotification__c = 'test@gmail.com';
        setting.Order_Hub_Mandatory_Countries__c = 'US,CA,BR';
        setting.EmailAddressFoTaxrAlarmNotification__c='test@gmail.com';
        insert setting; 
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F Automated eBooks Opportunity').getRecordTypeId();
        List<PricebookEntry> priceBookEntryList = new List<PricebookEntry>();
        
        Country__c countryRecord = new Country__c(Name = 'India', Country_2__c ='IN');
        insert countryRecord;
        
        SAP_BP__c SAP_BP_Record = new SAP_BP__c();
        SAP_BP_Record.Name = 'Pending';
        SAP_BP_Record.Address_Type__c = 'Account Mailing';
        SAP_BP_Record.Country__c = 'India';
        insert SAP_BP_Record;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.StageName = 'Acceptance';
        opp.AccountId = a.id;
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Order_Status__c = 'Pending';
        opp.Account_Validate_Opp__c = true;
        opp.recordTypeId = oppRecordTypeId;
        opp.Bill_To_BP__c = SAP_BP_Record.id;
        
        opp.TF_eBook_License_Type__c = 'static';
        insert opp;
        
        Id prodRecordTypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - BespokeCollection');
        Id quoteRecordtypeId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'Automated eBook Direct Sales Orders');
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(CurrencyIsoCode = 'USD', SBQQ__Opportunity2__c = opp.Id,SBQQ__BillingCity__c = 'test Billing',SBQQ__Account__c = a.Id, Payer_Account__c = a.Id, SBQQ__ExpirationDate__c = System.today() + 60, SBQQ__Status__c = 'Accepted', SBQQ__Primary__c=true,Quote_Type__c = 'Direct Sale', RecordTypeId = quoteRecordtypeId); 
        insert quoteObject;
        system.debug('quoteObject'+quoteObject);
        
        Product2 pro = new Product2();
        pro.Name = 'T&F – OA BPC PriceBook';
        pro.ISBN__c = '123456';
        pro.Hub_Id__c = '0023303d-524f-49a0-93a5-00db3ccb9a39';
        pro.ProductCode = '9781003099277';
        pro.Lead_Author_Editor__c = 'Raj';
        pro.Applicable_Customer_Types__c = 'Individual';
        pro.Applicable_License_Types__c = 'Perpetual';
        pro.Collection_Valid_From__c = system.today();
        pro.List_Price__c = 1234; 
        insert pro;
   
        
        Product2 prod = new Product2();
        prod.Name = 'Static Buundle';
        prod.RecordTypeId  = prodRecordTypeId;
        prod.ISBN__c = '123456566';
        prod.Hub_Id__c = '0026773303d-524f-49a0-93a5-00db3ccb9a39';
        prod.ProductCode = '978106703099277';
        prod.Lead_Author_Editor__c = 'Raj';
        prod.Applicable_Customer_Types__c = 'Institution';
        prod.Applicable_License_Types__c = 'Perpetual';
        prod.Collection_Valid_From__c = system.today();
        prod.List_Price__c = 1234; 
        insert prod;
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = pro.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 pricebk = new Pricebook2(Name='T&F - eBooks Pricebook', isActive=true);
        insert pricebk;
        
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = pricebk.Id, Product2Id = pro.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        SBQQ__QuoteLine__c qli = new SBQQ__QuoteLine__c();
        qli.SBQQ__Quote__c = quoteObject.Id;
        qli.SBQQ__Product__c = prod.Id;
        qli.SBQQ__PricebookEntryId__c = customPrice.Id;
        qli.PCM_ISBN__c = '1234533467';
        qli.PCM_UUID__c = '00233323203d-524f-49a0-93a5-00db3ccb9a39';
        qli.PCM_Product_Name__c = 'TeswewtProduct';
        qli.PCM_Author_Name__c = 'testAuewewthor';
        qli.SBQQ__ListPrice__c = 1000;
        qli.Line_reference__c = 'testweewe';
        qli.PCM_DOI__c = 'twewewest';
        qli.SBQQ__Bundled__c = true;
        INSERT qli;
        system.debug('qli'+qli);
        
        
        
        List<PCMOppSyncControllerDS.wrapPricebkEntProduct> wrapList = New List<PCMOppSyncControllerDS.wrapPricebkEntProduct>();
        PCMOppSyncControllerDS.wrapPricebkEntProduct wrap1 = new PCMOppSyncControllerDS.wrapPricebkEntProduct();
        for(PricebookEntry pb : priceBookEntryList){
            wrap1.PricebkEntProduct = pb;
            wrap1.productId = pb.Pricebook2Id;
        }
        wrapList.add(wrap1);
        
        PCMOppSyncControllerDS.productToSyncWrapper bundleWrap_1 = new PCMOppSyncControllerDS.productToSyncWrapper();
        
        bundleWrap_1.PCMISBN = '123456765';
        bundleWrap_1.PCMAuthor = 'testAuthorgv';
        bundleWrap_1.PCMDOI = 'test6';
        bundleWrap_1.PCMProductName = 'TestProductgf';
        bundleWrap_1.UnitPrice = 1000;
        bundleWrap_1.PONumber = '234567';
        bundleWrap_1.PCMISBN = '0023303d-524f-49a0-93a5-00db3ccb9a39';
        bundleWrap_1.SalesforceProductId = pro.Id;
        bundleWrap_1.SalesforceProductName = pro.Name;
        bundleWrap_1.SalesforceProductISBN = pro.Name;//SalesforcePriceBookEntry
        bundleWrap_1.SalesforcePriceBookEntry = customPrice.Id;
        bundleWrap_1.quoteLineRecId = qli.Id;
        bundleWrap_1.SFDCProdList = wrapList;
        bundleWrap_1.isDuplicate = false;
        
        PCMOppSyncControllerDS.productToSyncWrapper bundleWrap_2 = new PCMOppSyncControllerDS.productToSyncWrapper();
        
        bundleWrap_2.PCMISBN = '1234182915';
        bundleWrap_2.PCMAuthor = 'testAuthorgv';
        bundleWrap_2.PCMDOI = 'test6';
        bundleWrap_2.PCMProductName = 'TestProductgf';
        bundleWrap_2.UnitPrice = 1000;
        bundleWrap_2.PONumber = '234568987';
        bundleWrap_2.PCMISBN = '0023303d-524f-49a0-93a5-0023303d';
        bundleWrap_2.SalesforceProductId = pro.Id;
        bundleWrap_2.SalesforceProductName = pro.Name;
        bundleWrap_2.SalesforceProductISBN = pro.Name;//SalesforcePriceBookEntry
        bundleWrap_2.SalesforcePriceBookEntry = customPrice.Id;
        bundleWrap_2.SFDCProdList = wrapList;
        bundleWrap_2.isDuplicate = false;
        
        list<String> listw = new  list<String>();
        listw.add(qli.Id);
        
        list<PCMOppSyncControllerDS.productToSyncWrapper> listtiw = new  list<PCMOppSyncControllerDS.productToSyncWrapper>();
        listtiw.add(bundleWrap_2);
        
        list<PCMOppSyncControllerDS.productToSyncWrapper> listtiws = new  list<PCMOppSyncControllerDS.productToSyncWrapper>();
        listtiws.add(bundleWrap_1);
        
        
        system.debug('listtiw>>>> '+listtiw);
        system.debug('listw>>>> '+listw);
        
        string jsonseldstock = JSON.serialize(listtiw);
        string jsonseldstocks = JSON.serialize(listtiws);
        string jsonseld = JSON.serialize(listw);
        
        List<String> isbnSet = new List<String>();
        isbnSet.add('0023303d-524f-49a0-93a5-00db3ccb9a39');
        isbnSet.add('005ba6ce-e021-4eb0-a358-00b0392029bc');
        isbnSet.add('0075083f-7492-47d5-818f-bf93bcde1fdf');
        
        PCMOppSyncControllerDS.splitList(isbnSet,2);
        PCMOppSyncControllerDS.getTotalAverageCount(isbnSet.size(),2);
        PCMOppSyncControllerDS.getCurrencyDetails(quoteObject.Id);
        PCMOppSyncControllerDS.getProdRecordTypeId('Product2', 'T&F - BespokeCollection');
        PCMOppSyncControllerDS.fetchQuoteLines(quoteObject.Id);
        PCMOppSyncControllerDS.createBundle(quoteObject.Id, Prod.Id, jsonseldstock, 3800, 'refer_88983');
        PCMOppSyncControllerDS.createPBE(quoteObject.Id, prod.Id, 3800, 3800);
        PCMOppSyncControllerDS.getDynamicBespokeQLI(quoteObject.Id);
        PCMOppSyncControllerDS.getOppAndSapDetails(quoteObject.Id);
        PCMOppSyncControllerDS.getProdRecordTypeId('Product2', 'T&F - BespokeCollection');
        PCMOppSyncControllerDS.getCustomSettingData(quoteObject.Id);
        PCMOppSyncControllerDS.syncDataToQuoteLine(quoteObject.Id, jsonseldstocks , jsonseld , 'USD');
    }
    
    @isTest
    public static void bespokeQLITest(){
        //Test Account Insert
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        SAP_BP__c SAP_BP_Record = new SAP_BP__c();
        SAP_BP_Record.Name = 'Pending';
        SAP_BP_Record.Address_Type__c = 'Account Mailing';
        SAP_BP_Record.Country__c = 'India';
        insert SAP_BP_Record;
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F Automated eBooks Opportunity').getRecordTypeId();
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.StageName = 'Acceptance';
        opp.AccountId = acc.id;
        opp.CloseDate = Date.today().addDays(10);
        opp.Order_Status__c = 'Pending';
        opp.Account_Validate_Opp__c = true;
        opp.recordTypeId = oppRecordTypeId;
        opp.Bill_To_BP__c = SAP_BP_Record.id;
        opp.TF_eBook_License_Type__c = 'Static';
        insert opp;
        
        Id quoteRecordtypeId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'Automated eBook Direct Sales Orders');
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(CurrencyIsoCode = 'USD', SBQQ__Opportunity2__c = opp.Id,SBQQ__BillingCity__c = 'test Billing',SBQQ__Account__c = acc.Id, Payer_Account__c = acc.Id, SBQQ__ExpirationDate__c = System.today().addDays(5), SBQQ__Status__c = 'Accepted', SBQQ__Primary__c=true,Quote_Type__c = 'Direct Sale', RecordTypeId = quoteRecordtypeId); 
        insert quoteObject;
        
        Product2 pro = new Product2();
        pro.Name = 'T&F – OA BPC Product';
        pro.ISBN__c = '123456';
        pro.Hub_Id__c = '0023303d-524f-49a0-93a5-00db3ccb9a39';
        pro.ProductCode = '9781003099277';
        pro.Lead_Author_Editor__c = 'Vikas';
        pro.Applicable_Customer_Types__c = 'Individual';
        pro.Applicable_License_Types__c = 'Perpetual';
        pro.Collection_Valid_From__c = system.today();
        pro.List_Price__c = 1234; 
        insert pro;
        
        PCMOppSyncControllerDS.createBespokeQLI(quoteObject.Id, pro.id, 100);
    }
    
    @isTest
    public static void test_getEntitlementDetails(){
        SBQQ__Quote__c quoteObject=new SBQQ__Quote__c();
        quoteObject= insertDataforTesting();   
        
        List<String> isbnSets = new List<String>();
        for(Integer i= 0;i<502;i++){
            isbnSets.add('0023303d-524f-49a0-93a5-00db3ccb9a39');
        }
        
        
        List<String> isbnSet = new List<String>();
        isbnSet.add('0023303d-524f-49a0-93a5-00db3ccb9a39');
        isbnSet.add('005ba6ce-e021-4eb0-a358-00b0392029bc');
        isbnSet.add('0075083f-7492-47d5-818f-bf93bcde1fdf');
        test.startTest();
        string jsonStr = 'validate test';
        //string jsonStr = '{"productIds":["0023303d-524f-49a0-93a5-00db3ccb9a39","005ba6ce-e021-4eb0-a358-00b0392029bc","0075083f-7492-47d5-818f-bf93bcde1fdf"]}';
        Test.setMock(HttpCalloutMock.class, new PCMOppSyncControllerDSTest(200, jsonStr));
        PCMOppSyncControllerDS.getEntitlementDetails(quoteObject.Id, 'BOOK' , isbnSet);
        
        PCMOppSyncControllerDS.getEntitlementDetails(quoteObject.Id, 'BOOK' , isbnSets);        
        test.stopTest();
    }
    
    @isTest
    public static void testUpdateBLI(){
        
        
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        EntitlementDataWrapper edws = new EntitlementDataWrapper();
        edws.customerId = '98422';
        edws.productId = '0023303d-524f-49a0-93a5-00db3ccb9a39';
        edws.licenseId = '118415';
        edws.packageVersion = null;
        edws.packageId = '38149258';
        edws.status = 'ACTIVE';
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F Automated eBooks Opportunity').getRecordTypeId();
        List<PricebookEntry> priceBookEntryList = new List<PricebookEntry>();
        
        Country__c countryRecord = new Country__c(Name = 'India', Country_2__c ='IN');
        insert countryRecord;
        
        SAP_BP__c SAP_BP_Record = new SAP_BP__c();
        SAP_BP_Record.Name = 'Pending';
        SAP_BP_Record.Address_Type__c = 'Account Mailing';
        SAP_BP_Record.Country__c = 'India';
        insert SAP_BP_Record;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.StageName = 'Acceptance';
        opp.AccountId = a.id;
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Order_Status__c = 'Pending';
        opp.Account_Validate_Opp__c = true;
        opp.recordTypeId = oppRecordTypeId;
        opp.Bill_To_BP__c = SAP_BP_Record.id;
        opp.TF_eBook_License_Type__c = 'static';
        insert opp;
        
        Id prodRecordTypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - BespokeCollection');
        Id quoteRecordtypeId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'Automated eBook Direct Sales Orders');
        
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(CurrencyIsoCode = 'USD', Quote_Sales_Type__c = 'Bespoke Collection',SBQQ__Opportunity2__c = opp.Id,SBQQ__BillingCity__c = 'test Billing',SBQQ__Account__c = a.Id, Payer_Account__c = a.Id, SBQQ__ExpirationDate__c = System.today() + 60, SBQQ__Status__c = 'Accepted', SBQQ__Primary__c=true,Quote_Type__c = 'Direct Sale', RecordTypeId = quoteRecordtypeId); 
        insert quoteObject;
        system.debug('quoteObject'+quoteObject);
        
        Product2 prod = new Product2();
        prod.Name = 'Static Buundle';
        prod.RecordTypeId  = prodRecordTypeId;
        prod.ISBN__c = '123456566';
        prod.Hub_Id__c = '0026773303d-524f-49a0-93a5-00db3ccb9a39';
        prod.ProductCode = '978106703099277';
        prod.Lead_Author_Editor__c = 'Raj';
        prod.Applicable_Customer_Types__c = 'Institution';
        prod.Applicable_License_Types__c = 'Perpetual';
        prod.Collection_Valid_From__c = system.today();
        prod.List_Price__c = 1234; 
        prod.Sales_Price__c = 1234;
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 pricebk = new Pricebook2(Name='T&F - eBooks Pricebook', isActive=true);
        insert pricebk;
        
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = pricebk.Id, Product2Id = prod.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        SBQQ__QuoteLine__c qli = new SBQQ__QuoteLine__c();
        qli.SBQQ__Quote__c = quoteObject.Id;
        qli.SBQQ__Product__c = prod.Id;
        qli.SBQQ__PricebookEntryId__c = customPrice.Id;
        qli.PCM_ISBN__c = '1234533467';
        qli.PCM_UUID__c = '00233323203d-524f-49a0-93a5-00db3ccb9a39';
        qli.PCM_Product_Name__c = 'TeswewtProduct';
        qli.PCM_Author_Name__c = 'testAuewewthor';
        qli.SBQQ__ListPrice__c = 1000;
        qli.Line_reference__c = 'testweewe';
        qli.PCM_DOI__c = 'twewewest';
        qli.SBQQ__Bundled__c = true;
        INSERT qli;
        system.debug('qli'+qli);
        
        
        
        List<PCMOppSyncControllerDS.wrapPricebkEntProduct> wrapList = New List<PCMOppSyncControllerDS.wrapPricebkEntProduct>();
        PCMOppSyncControllerDS.wrapPricebkEntProduct wrap1 = new PCMOppSyncControllerDS.wrapPricebkEntProduct();
        for(PricebookEntry pb : priceBookEntryList){
            wrap1.PricebkEntProduct = pb;
            wrap1.productId = pb.Pricebook2Id;
        }
        wrapList.add(wrap1);
        
        //making the json for bundleLineItems 
        
        PCMOppSyncControllerDS.productToSyncWrapper bundleWrap_1 = new PCMOppSyncControllerDS.productToSyncWrapper();
        
        bundleWrap_1.PCMISBN = '123456765';
        bundleWrap_1.PCMAuthor = 'testAuthorgv';
        bundleWrap_1.PCMDOI = 'test6';
        bundleWrap_1.PCMProductName = 'TestProductgf';
        bundleWrap_1.UnitPrice = 1000;
        bundleWrap_1.PONumber = '234567';
        bundleWrap_1.PCMISBN = '0023303d-524f-49a0-93a5-00db3ccb9a39';
        bundleWrap_1.SalesforceProductId = prod.Id;
        bundleWrap_1.SalesforceProductName = prod.Name;
        bundleWrap_1.SalesforceProductISBN = prod.Name;//SalesforcePriceBookEntry
        bundleWrap_1.SalesforcePriceBookEntry = customPrice.Id;
        bundleWrap_1.quoteLineRecId = qli.Id;
        bundleWrap_1.SFDCProdList = wrapList;
        bundleWrap_1.isDuplicate = false;
        
        
        list<PCMOppSyncControllerDS.productToSyncWrapper> listtiws = new  list<PCMOppSyncControllerDS.productToSyncWrapper>();
        listtiws.add(bundleWrap_1);
        
        string jsonseldstock = JSON.serialize(listtiws);
        
        test.startTest();
        //string jsonStr = 'validate test';
        string jsonStr = '{"productIds":["0023303d-524f-49a0-93a5-00db3ccb9a39","005ba6ce-e021-4eb0-a358-00b0392029bc","0075083f-7492-47d5-818f-bf93bcde1fdf"]}';
        Test.setMock(HttpCalloutMock.class, new PCMOppSyncControllerDSTest(202, jsonStr));
        PCMOppSyncControllerDS.updateExistingBundle(quoteObject.Id, jsonseldstock, '420', 'refer_88983');
        test.stopTest();
        
    }
    
    static TestMethod void salesTypeTest(){
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F Automated eBooks Opportunity').getRecordTypeId();
        List<PricebookEntry> priceBookEntryList = new List<PricebookEntry>();
        
        Country__c countryRecord = new Country__c(Name = 'India', Country_2__c ='IN');
        insert countryRecord;
        
        SAP_BP__c SAP_BP_Record = new SAP_BP__c();
        SAP_BP_Record.Name = 'Pending';
        SAP_BP_Record.Address_Type__c = 'Account Mailing';
        SAP_BP_Record.Country__c = 'India';
        insert SAP_BP_Record;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.StageName = 'Acceptance';
        opp.AccountId = a.id;
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Order_Status__c = 'Pending';
        opp.Account_Validate_Opp__c = true;
        opp.recordTypeId = oppRecordTypeId;
        opp.Bill_To_BP__c = SAP_BP_Record.id;
        opp.TF_eBook_License_Type__c = 'static';
        insert opp;
        
        Id prodRecordTypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - BespokeCollection');
        Id quoteRecordtypeId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'Automated eBook Direct Sales Orders');
        
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(CurrencyIsoCode = 'USD', Quote_Sales_Type__c = 'Single Title', SBQQ__Opportunity2__c = opp.Id,SBQQ__BillingCity__c = 'test Billing',SBQQ__Account__c = a.Id, Payer_Account__c = a.Id, SBQQ__ExpirationDate__c = System.today() + 60, SBQQ__Status__c = 'Accepted', SBQQ__Primary__c=true,Quote_Type__c = 'Direct Sale', RecordTypeId = quoteRecordtypeId); 
        insert quoteObject;
        system.debug('quoteObject =====>'+quoteObject);
        
        Product2 prod = new Product2();
        prod.Name = 'Static Buundle';
        prod.RecordTypeId  = prodRecordTypeId;
        prod.ISBN__c = '123456566';
        prod.Hub_Id__c = '0026773303d-524f-49a0-93a5-00db3ccb9a39';
        prod.ProductCode = '978106703099277';
        prod.Lead_Author_Editor__c = 'Raj';
        prod.Applicable_Customer_Types__c = 'Institution';
        prod.Applicable_License_Types__c = 'Perpetual';
        prod.Collection_Valid_From__c = system.today();
        prod.List_Price__c = 1234; 
        prod.Sales_Price__c = 1234;
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 pricebk = new Pricebook2(Name='T&F - eBooks Pricebook', isActive=true);
        insert pricebk;
        
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = pricebk.Id, Product2Id = prod.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        SBQQ__QuoteLine__c qli = new SBQQ__QuoteLine__c();
        qli.SBQQ__Quote__c = quoteObject.Id;
        qli.SBQQ__Product__c = prod.Id;
        qli.SBQQ__PricebookEntryId__c = customPrice.Id;
        qli.PCM_ISBN__c = '1234533467';
        qli.PCM_UUID__c = '00233323203d-524f-49a0-93a5-00db3ccb9a39';
        qli.PCM_Product_Name__c = 'TeswewtProduct';
        qli.PCM_Author_Name__c = 'testAuewewthor';
        qli.SBQQ__ListPrice__c = 1000;
        qli.Line_reference__c = 'testweewe';
        qli.PCM_DOI__c = 'twewewest';
        qli.SBQQ__Bundled__c = true;
        insert qli;
        system.debug('qli =====>'+qli);
        
        test.startTest();
        string jsonStr = '{"productIds":["0023303d-524f-49a0-93a5-00db3ccb9a39","005ba6ce-e021-4eb0-a358-00b0392029bc","0075083f-7492-47d5-818f-bf93bcde1fdf"]}';
        Test.setMock(HttpCalloutMock.class, new PCMOppSyncControllerDSTest(200, jsonStr));
        PCMOppSyncControllerDS.updateSalesType(quoteObject.Id);
        test.stopTest();
        //PCMOppSyncControllerDS.updateSalesType(quoteObject.Id);
    }
    
    static TestMethod void salesTypeTest2(){
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F Automated eBooks Opportunity').getRecordTypeId();
        List<PricebookEntry> priceBookEntryList = new List<PricebookEntry>();
        
        Country__c countryRecord = new Country__c(Name = 'India', Country_2__c ='IN');
        insert countryRecord;
        
        SAP_BP__c SAP_BP_Record = new SAP_BP__c();
        SAP_BP_Record.Name = 'Pending';
        SAP_BP_Record.Address_Type__c = 'Account Mailing';
        SAP_BP_Record.Country__c = 'India';
        insert SAP_BP_Record;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.StageName = 'Acceptance';
        opp.AccountId = a.id;
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Order_Status__c = 'Pending';
        opp.Account_Validate_Opp__c = true;
        opp.recordTypeId = oppRecordTypeId;
        opp.Bill_To_BP__c = SAP_BP_Record.id;
        
        opp.TF_eBook_License_Type__c = 'static';
        insert opp;
        
        Id prodRecordTypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        Id quoteRecordtypeId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'Automated eBook Direct Sales Orders');
        
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(CurrencyIsoCode = 'USD', Quote_Sales_Type__c = 'Single Title', SBQQ__Opportunity2__c = opp.Id,SBQQ__BillingCity__c = 'test Billing',SBQQ__Account__c = a.Id, Payer_Account__c = a.Id, SBQQ__ExpirationDate__c = System.today() + 60, SBQQ__Status__c = 'Accepted', SBQQ__Primary__c=true,Quote_Type__c = 'Direct Sale', RecordTypeId = quoteRecordtypeId); 
        insert quoteObject;
        system.debug('quoteObject =====>'+quoteObject);
        
        Product2 prod = new Product2();
        prod.Name = 'Static Buundle';
        prod.businessId__c = 'Bespoke';
        prod.RecordTypeId  = prodRecordTypeId;
        prod.ISBN__c = '123456566';
        prod.Hub_Id__c = '0026773303d-524f-49a0-93a5-00db3ccb9a39';
        prod.ProductCode = '978106703099277';
        prod.Lead_Author_Editor__c = 'Raj';
        prod.Applicable_Customer_Types__c = 'Institution';
        prod.Applicable_License_Types__c = 'Perpetual';
        prod.Collection_Valid_From__c = system.today();
        prod.List_Price__c = 1234; 
        prod.Sales_Price__c = 1234;
        prod.Sales_Channels__c = 'UBX_Sales';
        prod.Applicable_Channels__c = 'UBX_Delivery';
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 pricebk = new Pricebook2(Name='T&F - eBooks Pricebook', isActive=true);
        insert pricebk;
        
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = pricebk.Id, Product2Id = prod.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        SBQQ__QuoteLine__c qli = new SBQQ__QuoteLine__c();
        qli.SBQQ__Quote__c = quoteObject.Id;
        qli.SBQQ__Product__c = prod.Id;
        qli.SBQQ__PricebookEntryId__c = customPrice.Id;
        qli.PCM_ISBN__c = '1234533467';
        qli.PCM_UUID__c = '00233323203d-524f-49a0-93a5-00db3ccb9a39';
        qli.PCM_Product_Name__c = 'TeswewtProduct';
        qli.PCM_Author_Name__c = 'testAuewewthor';
        qli.SBQQ__ListPrice__c = 1000;
        qli.Line_reference__c = 'testweewe';
        qli.PCM_DOI__c = 'twewewest';
        qli.SBQQ__Bundled__c = true;
        insert qli;
        system.debug('qli =====>'+qli);
        
        test.startTest();
        string jsonStr = '{"productIds":["0023303d-524f-49a0-93a5-00db3ccb9a39","005ba6ce-e021-4eb0-a358-00b0392029bc","0075083f-7492-47d5-818f-bf93bcde1fdf"]}';
        Test.setMock(HttpCalloutMock.class, new PCMOppSyncControllerDSTest(200, jsonStr));
        PCMOppSyncControllerDS.updateSalesType(quoteObject.Id);
        test.stopTest();
        
    }
    
    static TestMethod void salesTypeTest3(){
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F Automated eBooks Opportunity').getRecordTypeId();
        List<PricebookEntry> priceBookEntryList = new List<PricebookEntry>();
        
        Country__c countryRecord = new Country__c(Name = 'India', Country_2__c ='IN');
        insert countryRecord;
        
        SAP_BP__c SAP_BP_Record = new SAP_BP__c();
        SAP_BP_Record.Name = 'Pending';
        SAP_BP_Record.Address_Type__c = 'Account Mailing';
        SAP_BP_Record.Country__c = 'India';
        insert SAP_BP_Record;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.StageName = 'Acceptance';
        opp.AccountId = a.id;
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Order_Status__c = 'Pending';
        opp.Account_Validate_Opp__c = true;
        opp.recordTypeId = oppRecordTypeId;
        opp.Bill_To_BP__c = SAP_BP_Record.id;
        
        opp.TF_eBook_License_Type__c = 'static';
        insert opp;
        
        Id prodRecordTypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');
        Id quoteRecordtypeId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'Automated eBook Direct Sales Orders');
        
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(CurrencyIsoCode = 'USD', Quote_Sales_Type__c = 'Single Title', SBQQ__Opportunity2__c = opp.Id,SBQQ__BillingCity__c = 'test Billing',SBQQ__Account__c = a.Id, Payer_Account__c = a.Id, SBQQ__ExpirationDate__c = System.today() + 60, SBQQ__Status__c = 'Accepted', SBQQ__Primary__c=true,Quote_Type__c = 'Direct Sale', RecordTypeId = quoteRecordtypeId); 
        insert quoteObject;
        system.debug('quoteObject =====>'+quoteObject);
        
        Product2 prod = new Product2();
        prod.Name = 'Static Buundle';
        prod.businessId__c = 'Bespoke';
        prod.RecordTypeId  = prodRecordTypeId;
        prod.ISBN__c = '123456566';
        prod.Hub_Id__c = '0026773303d-524f-49a0-93a5-00db3ccb9a39';
        prod.ProductCode = '978106703099277';
        prod.Lead_Author_Editor__c = 'Raj';
        prod.Applicable_Customer_Types__c = 'Institution';
        prod.Applicable_License_Types__c = 'Perpetual';
        prod.Collection_Valid_From__c = system.today();
        prod.List_Price__c = 1234; 
        prod.Sales_Price__c = 1234;
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 pricebk = new Pricebook2(Name='T&F - eBooks Pricebook', isActive=true);
        insert pricebk;
        
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = pricebk.Id, Product2Id = prod.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        SBQQ__QuoteLine__c qli = new SBQQ__QuoteLine__c();
        qli.SBQQ__Quote__c = quoteObject.Id;
        qli.SBQQ__Product__c = prod.Id;
        qli.SBQQ__PricebookEntryId__c = customPrice.Id;
        qli.PCM_ISBN__c = '1234533467';
        qli.PCM_UUID__c = '00233323203d-524f-49a0-93a5-00db3ccb9a39';
        qli.PCM_Product_Name__c = 'TeswewtProduct';
        qli.PCM_Author_Name__c = 'testAuewewthor';
        qli.SBQQ__ListPrice__c = 1000;
        qli.Line_reference__c = 'testweewe';
        qli.PCM_DOI__c = 'twewewest';
        qli.SBQQ__Bundled__c = true;
        insert qli;
        system.debug('qli =====>'+qli);
        
        test.startTest();
        string jsonStr = '{"productIds":["0023303d-524f-49a0-93a5-00db3ccb9a39","005ba6ce-e021-4eb0-a358-00b0392029bc","0075083f-7492-47d5-818f-bf93bcde1fdf"]}';
        Test.setMock(HttpCalloutMock.class, new PCMOppSyncControllerDSTest(200, jsonStr));
        PCMOppSyncControllerDS.updateSalesType(quoteObject.Id);    
        test.stopTest();
        
    }
    
    //added by shubham kumar SFAL-20
    public class EntitlementDetailsGeneratorSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String Body = '[{"customerId":"98422","packageId":"38149258","packageVersion":"null","productId":"0023303d-524f-49a0-93a5-00db3ccb9a39","licenseId":"118415","status":"ACTIVE"},{"customerId":"98422","packageId":"38149258","packageVersion":"null","productId":"005ba6ce-e021-4eb0-a358-00b0392029bc","licenseId":"118415","status":"ACTIVE"},{"customerId":"98422","packageId":"38149258","packageVersion":"null","productId":"0075083f-7492-47d5-818f-bf93bcde1fdf","licenseId":"118415","status":"ACTIVE"}]';
            res.setBody(Body);
            res.setStatusCode(200);
            return res; 
        }
    }
    
    public class EntitlementDataWrapper{
        public String productId{get;set;}
        public String packageVersion{get;set;}
        public String licenseId{get;set;}
        public String packageId{get;set;}
        public String status{get;set;}
        public String customerId{get;set;}
    }
    
}