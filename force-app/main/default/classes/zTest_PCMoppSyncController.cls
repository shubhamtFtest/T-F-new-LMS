/**
Author : Siddhant
Test class :  
Description :  
ref : 
**/

@isTest
public class zTest_PCMoppSyncController {
    
    @isTest
    public static void test_MoppSync(){
        
        //Test Account Insert
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        Id recordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F Automated eBooks Opportunity');
        List<PricebookEntry> priceBookEntryList = new List<PricebookEntry>();
        
        Country__c countryRecord = new Country__c(Name = 'India', Country_2__c ='IN');
        insert countryRecord;
        
        SAP_BP__c sapObject = new SAP_BP__c(Account_Id__c = a.Id,First_Name__c = 'test_first_name',Last_Name__c = 'test_last_name',Email__c = 'test@gmail.com',Name = 'PENDING',Street__c = 'Test Street',Region__c = 'Test_Region',Address_Type__c = 'Account Mailing',State__c = 'test state',Country__c = 'India',City__c = 'test city',Status__c = true);
        insert sapObject;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.StageName = 'Acceptance';
        opp.AccountId = a.id;
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Bill_to_BP__c = sapObject.id;
        opp.Order_Status__c = 'Failed';
        opp.Ship_to_BP__c = sapObject.id;
        opp.Account_Validate_Opp__c = true;
        insert opp;
        
        Id quoteRecordtypeId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'Automated eBook Direct Sales Orders');
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(BPC_Order_Type__c='Frontlist Chapter', CurrencyIsoCode = 'USD', SBQQ__Opportunity2__c = opp.Id,SBQQ__BillingCity__c = 'test Billing',SBQQ__Account__c = a.Id, Payer_Account__c = a.Id, SBQQ__ExpirationDate__c = System.today() + 60, SBQQ__Status__c = 'Accepted', SBQQ__Primary__c=true,Quote_Type__c = 'Direct Sale', RecordTypeId = quoteRecordtypeId); 
        insert quoteObject;
        
        Product2 pro = new Product2();
        pro.Name = 'T&F – OA BPC PriceBook';
        pro.ISBN__c = '123456';
        pro.Lead_Author_Editor__c = 'Raj';
        insert pro;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = pro.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 pricebk = new Pricebook2(Name='T&F – OA BPC PriceBook', isActive=true);
        insert pricebk;
        
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = pricebk.Id, Product2Id = pro.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        SBQQ__QuoteLine__c qli = new SBQQ__QuoteLine__c();
        qli.SBQQ__Quote__c = quoteObject.Id;
        qli.SBQQ__Product__c = pro.Id;
        qli.SBQQ__PricebookEntryId__c = customPrice.Id;
        qli.PCM_ISBN__c = '1234567';
        qli.PCM_Product_Name__c = 'TestProduct';
        qli.PCM_Author_Name__c = 'testAuthor';
        qli.SBQQ__ListPrice__c = 1000;
        qli.Line_reference__c = 'test';
        qli.PCM_DOI__c = 'test';
        INSERT qli;
        
        List<PCMoppSyncController.wrapPricebkEntProduct> wrapList = New List<PCMoppSyncController.wrapPricebkEntProduct>();
        PCMoppSyncController.wrapPricebkEntProduct wrap1 = new PCMoppSyncController.wrapPricebkEntProduct();
        for(PricebookEntry pb : priceBookEntryList){
            wrap1.PricebkEntProduct = pb;
            wrap1.productId = pb.Pricebook2Id;
        }
        wrapList.add(wrap1);
        
        PCMoppSyncController.productToSyncWrapper wrap2 = new PCMoppSyncController.productToSyncWrapper();
        wrap2.SFDCProdList = wrapList;
        wrap2.quoteLineRecId = qli.Id;
        wrap2.SalesforceProductId = pro.Id;
        wrap2.SalesforceProductName = pro.Name;
        wrap2.SalesforcePriceBookEntry = customPrice.Id;
        wrap2.PCMISBN = '123456765';
        wrap2.PCMProductName = 'TestProductgf';
        wrap2.PCMAuthor = 'testAuthorgv';
        wrap2.UnitPrice = 1000;
        wrap2.PONumber = '234567';
        wrap2.PCMDOI = 'test6';
        wrap2.LicenceType = 'Test';
        
        list<String> listw = new  list<String>();
        listw.add(qli.Id);
        
        list<PCMoppSyncController.productToSyncWrapper> listtiw = new  list<PCMoppSyncController.productToSyncWrapper>();
        listtiw.add(wrap2);
        
        system.debug('listtiw>>>> '+listtiw);
        system.debug('listw>>>> '+listw);
        
        string jsonseldstock = JSON.serialize(listtiw);
        string jsonseld = JSON.serialize(listw);
        
        PCMoppSyncController.getProductDetails(quoteObject.Id);
        PCMoppSyncController.getCurrencyDetails(quoteObject.Id);
        PCMoppSyncController.fetchQuoteLines(quoteObject.Id);
        PCMoppSyncController.syncDataToQuoteLine(quoteObject.Id, jsonseldstock , jsonseld , 'USD');
        PCMoppSyncController.fetchQuoteOrderType(quoteObject.Id);
        PCMOppSyncController.getOppAndSapDetails(quoteObject.Id);
    }
    
    @isTest
    public static void test_MoppSync_2(){
        
        //Test Account Insert
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        Id recordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F Automated eBooks Opportunity');
        List<PricebookEntry> priceBookEntryList = new List<PricebookEntry>();
        
        Country__c countryRecord = new Country__c(Name = 'India', Country_2__c ='IN');
        insert countryRecord; 
        
        SAP_BP__c sapObject = new SAP_BP__c(Account_Id__c = a.Id,First_Name__c = 'test_first_name',Last_Name__c = 'test_last_name',Email__c = 'test@gmail.com',Name = 'PENDING',Street__c = 'Test Street',Region__c = 'Test_Region',Address_Type__c = 'Account Mailing',State__c = 'test state',Country__c = 'India',City__c = 'test city',Status__c = true);
        insert sapObject;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.StageName = 'Acceptance';
        opp.AccountId = a.id;
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Bill_to_BP__c = sapObject.id;
        opp.Order_Status__c = 'Failed';
        //opp.Ship_to_BP__c = sapObject.id;
        opp.Account_Validate_Opp__c = true;
        insert opp;
        
        Id quoteRecordtypeId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'Automated eBook Direct Sales Orders');
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(BPC_Order_Type__c = 'Backlist Chapter', CurrencyIsoCode = 'USD', SBQQ__Opportunity2__c = opp.Id,SBQQ__BillingCity__c = 'test Billing',SBQQ__Account__c = a.Id, Payer_Account__c = a.Id, SBQQ__ExpirationDate__c = System.today() + 60, SBQQ__Status__c = 'Accepted', SBQQ__Primary__c=true,Quote_Type__c = 'Direct Sale', RecordTypeId = quoteRecordtypeId); 
        insert quoteObject;
        
        Product2 pro = new Product2();
        pro.Name = 'Test';
        insert pro;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = pro.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 pricebk = new Pricebook2(Name='T&F – OA BPC PriceBook', isActive=true);
        insert pricebk;
        
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = pricebk.Id, Product2Id = pro.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        SBQQ__QuoteLine__c qli = new SBQQ__QuoteLine__c();
        qli.SBQQ__Quote__c = quoteObject.Id;
        qli.SBQQ__Product__c = pro.Id;
        qli.SBQQ__PricebookEntryId__c = customPrice.Id;
        qli.PCM_ISBN__c = '1234567';
        qli.PCM_Product_Name__c = 'TestProduct';
        qli.PCM_Author_Name__c = 'testAuthor';
        qli.SBQQ__ListPrice__c = 1000;
        qli.SBQQ__UnitCost__c = 1234;
        qli.Licence_Type__c = 'Raj';
        qli.Line_reference__c = 'test';
        qli.PCM_DOI__c = 'test';
        INSERT qli;
        
        List<PCMoppSyncController.wrapPricebkEntProduct> wrapList = New List<PCMoppSyncController.wrapPricebkEntProduct>();
        PCMoppSyncController.wrapPricebkEntProduct wrap1 = new PCMoppSyncController.wrapPricebkEntProduct();
        for(PricebookEntry pb : priceBookEntryList){
            wrap1.PricebkEntProduct = pb;
            wrap1.productId = pb.Pricebook2Id;
        }
        wrapList.add(wrap1);
        
        PCMoppSyncController.productToSyncWrapper wrap2 = new PCMoppSyncController.productToSyncWrapper();
        wrap2.SFDCProdList = wrapList;
        wrap2.quoteLineRecId = qli.Id;
        wrap2.SalesforceProductId = qli.SBQQ__Product__c;
        wrap2.SalesforceProductName = qli.SBQQ__Product__r.Name;
        wrap2.SalesforcePriceBookEntry = qli.SBQQ__PricebookEntryId__c;
        wrap2.PCMISBN = qli.PCM_ISBN__c;
        wrap2.PCMProductName = qli.PCM_Product_Name__c;
        wrap2.PCMAuthor = qli.PCM_Author_Name__c;
        wrap2.UnitPrice = qli.SBQQ__UnitCost__c;
        wrap2.PONumber = qli.Line_reference__c;
        wrap2.PCMDOI = qli.PCM_DOI__c;
        wrap2.LicenceType = qli.Licence_Type__c;
        
        list<String> listw = new  list<String>();
        listw.add(qli.Id);
        
        list<PCMoppSyncController.productToSyncWrapper> listtiw = new  list<PCMoppSyncController.productToSyncWrapper>();
        listtiw.add(wrap2);
        
        string jsonseldstock = JSON.serialize(listtiw);
        string jsonseld = JSON.serialize(listw);
        
        PCMoppSyncController.getProductDetails(quoteObject.Id);
        PCMoppSyncController.getCurrencyDetails(quoteObject.Id);
        PCMoppSyncController.fetchQuoteLines(quoteObject.Id);
        PCMoppSyncController.syncDataToQuoteLine(quoteObject.Id, jsonseldstock , jsonseld , 'USD');
        PCMOppSyncController.getOppAndSapDetails(quoteObject.Id);
    }
}