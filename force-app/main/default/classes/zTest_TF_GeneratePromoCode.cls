/*
* Apex class: TF_GenerateCouponCode
*/
@isTest
public class zTest_TF_GeneratePromoCode {
    private static void createSingleUseCpqDiscConfigSampleData() {
        Id recordTypeId = Schema.SObjectType.Sales_Deal__c.getRecordTypeInfosByName().get('Promocode Deal').getRecordTypeId();
        Sales_Deal__c configObject = new Sales_Deal__c();             
        configObject.RecordTypeId = recordTypeId;
        configObject.Promocode__c = 'MAK-2018-USJFISD';
        configObject.Discount_Display_Name__c = 'Coupon code';
        configObject.Active__c = true;
        configObject.Single_Use__c = true;
        configObject.Used_Quote__c='';
        configObject.Number_of_Quotes_used_this_PromoCode__c=null;
        configObject.Start_Date__c = date.today();
        configObject.End_Date__c = date.today()+20;
        configObject.Deal_Name__c = 'Promocode- single use';
        configObject.Type_of_Deal__c = 'APC Deal';        
        insert configObject; 
    }

    static testMethod void testGetProductTitle() {
        test.startTest();
        String priceBookName = 'T&F CPQ Price Book 2017';        
        Quote_Service_Settings__c customSetting = new Quote_Service_Settings__c(Name = 'Informa Plc', Product_Family__c = 'Journals-Author Side Charges', CPQ_PriceBook__c = priceBookName);
        insert customSetting;   
        Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
        Product2 prodObject = new Product2(Name = 'Test Product', 
                                    RecordTypeId = TFProductsRecordTypeId,
                                    CPQ_Category__c = 'Technology',
                                    Article_Type__c = 'Letter',
                                    Sales_Organization__c = 'NA',
                                    Open_Access_Category__c = 'Open',
                                    ProductCode = 'XYZ',
                                    Readership_Level__c = 'Test',
                                    IsActive = true,
                                    Family = 'Journals-Author Side Charges');  
        insert prodObject;                 
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> priceBEList = new List<PricebookEntry>();        
        PricebookEntry priceBE1 = new PricebookEntry(CurrencyIsoCode = 'USD',IsActive = True, Pricebook2Id = standardPricebookId, Product2Id = prodObject.Id, UnitPrice = 100.00);                                  
        priceBEList.add(priceBE1);                              
        insert priceBEList;
        
        Pricebook2 priceBook2 = new Pricebook2(Name = priceBookName, IsActive = True);
        insert priceBook2;
        
        List<PricebookEntry> priceBEList2 = new List<PricebookEntry>();
        PricebookEntry priceBE2 = new PricebookEntry(CurrencyIsoCode = 'USD',IsActive = True, Pricebook2Id = priceBook2.Id, Product2Id = prodObject.Id, UnitPrice = 100.00);    
                                                        
        priceBEList2.add(priceBE2);                              
        insert priceBEList2;
        
        List<Product2> productLst = TF_GenerateCouponCode.getProductInfo('XYZ');
        //System.assert(productLst.size() != 0);
        test.stopTest();
    }

    static testMethod void testGetProductTitleInvalidTitle() {
        test.startTest();
        String priceBookName = 'T&F CPQ Price Book 2017';        
        Quote_Service_Settings__c customSetting = new Quote_Service_Settings__c(Name = 'Informa Plc', Product_Family__c = 'Journals-Author Side Charges', CPQ_PriceBook__c = priceBookName);
        insert customSetting;   
        Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
        Product2 prodObject = new Product2(Name = 'Test Product', 
                                    RecordTypeId = TFProductsRecordTypeId,
                                    CPQ_Category__c = 'Technology',
                                    Article_Type__c = 'Letter',
                                    Sales_Organization__c = 'NA',
                                    Open_Access_Category__c = 'Open',
                                    ProductCode = 'XYZ',
                                    Readership_Level__c = 'Test',
                                    IsActive = true,
                                    Family = 'Journals-Author Side Charges');  
        insert prodObject;                 
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> priceBEList = new List<PricebookEntry>();        
        PricebookEntry priceBE1 = new PricebookEntry(CurrencyIsoCode = 'USD',IsActive = True, Pricebook2Id = standardPricebookId, Product2Id = prodObject.Id, UnitPrice = 100.00);                                  
        priceBEList.add(priceBE1);                              
        insert priceBEList;
        
        Pricebook2 priceBook2 = new Pricebook2(Name = priceBookName, IsActive = True);
        insert priceBook2;
        
        List<PricebookEntry> priceBEList2 = new List<PricebookEntry>();
        PricebookEntry priceBE2 = new PricebookEntry(CurrencyIsoCode = 'USD',IsActive = True, Pricebook2Id = priceBook2.Id, Product2Id = prodObject.Id, UnitPrice = 100.00);    
                                                        
        priceBEList2.add(priceBE2);                              
        insert priceBEList2;
        
        List<Product2> productLst = TF_GenerateCouponCode.getProductInfo('ABC');
        System.assert(productLst.size() == 0);
        test.stopTest();
    }
    
    static testMethod void testCreateRecord() {
        String priceBookName = 'T&F CPQ Price Book 2017';        
        Quote_Service_Settings__c customSetting = new Quote_Service_Settings__c(Name = 'Informa Plc', Product_Family__c = 'Journals-Author Side Charges', CPQ_PriceBook__c = priceBookName);
        insert customSetting;   
        Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
        Product2 prodObject = new Product2(Name = 'Test Product', 
                                    RecordTypeId = TFProductsRecordTypeId,
                                    CPQ_Category__c = 'Technology',
                                    Article_Type__c = 'Letter',
                                    Sales_Organization__c = 'NA',
                                    Open_Access_Category__c = 'Open',
                                    ProductCode = 'XYZA',
                                    Readership_Level__c = 'Test',
                                    IsActive = true,
                                    Family = 'Journals-Author Side Charges');  
        insert prodObject;  

        Id recordTypeId = Schema.SObjectType.Sales_Deal__c.getRecordTypeInfosByName().get('Promocode Deal').getRecordTypeId();
        Sales_Deal__c salesDealObject = new Sales_Deal__c();             
        salesDealObject.RecordTypeId = recordTypeId;
        salesDealObject.Discount_Category__c='Ad hoc';
        salesDealObject.Promocode__c = 'MAK-2018-TEST';                
        salesDealObject.Product__c = prodObject.Id;
        //salesDealObject.Product__c = '01t0Y0000081061';
        salesDealObject.Discount_Display_Name__c = 'Coupon code';
        salesDealObject.Active__c = true;
        salesDealObject.Single_Use__c = true;
        salesDealObject.Used_Quote__c='';
        salesDealObject.Number_of_Quotes_used_this_PromoCode__c=null;
        salesDealObject.Start_Date__c = date.today();
        salesDealObject.End_Date__c = date.today()+20;
        salesDealObject.CurrencyIsoCode = 'USD'; 
        salesDealObject.Deal_Name__c = 'Promocode- single use';
        salesDealObject.Type_of_Deal__c = 'APC Deal';
        
        insert salesDealObject;  
        
        Sales_Deal__c salesDealConfig = [SELECT Id, Name, Discount_Category__c, Single_Use__c, Promocode__c, Product_Code__c, Start_Date__c, 
                                       End_Date__c, CurrencyIsoCode FROM Sales_Deal__c WHERE Id =: salesDealObject.Id];
        
        Map<String,String> resMap = new Map<String,String>();         
        String startDate = String.valueOf(salesDealConfig.Start_Date__c);
        String endDate = String.valueOf(salesDealConfig.End_Date__c);
        String isSingleUse = salesDealConfig.Single_Use__c == true ? 'Yes' : 'NO';        
        
        test.startTest();
        
        List<Sales_Deal__c> res = TF_GenerateCouponCode.doSaveRecord(
            prodObject.Id, salesDealConfig.Product_Code__c, salesDealConfig.Discount_Category__c, 
            startDate, endDate, '1', 
            '% Discount','1', salesDealConfig.CurrencyIsoCode, 
            isSingleUse, 'amit@gmail.com');
       	
		system.debug('res::'+res);
        //System.assert(res.size() != null);		
        test.stopTest();
    } 
    
    static testMethod void testCheckUserHasCustomPermissionAccess() {
        test.startTest();
        Id userId = userInfo.getUserId();
		Boolean status = TF_GenerateCouponCode.checkUserHasCustomPermissionAccess();
        test.stopTest();        
    }

    static testMethod void testGetPickListValues() {
        test.startTest();
        String ObjectApiName ='Sales_Deal__c';
        String fieldApiName ='Discount_Category__c';
		List<String> lst = new List<String>();
        lst = TF_GenerateCouponCode.getPickListValues(ObjectApiName,fieldApiName);
        test.stopTest();        
    }    
}