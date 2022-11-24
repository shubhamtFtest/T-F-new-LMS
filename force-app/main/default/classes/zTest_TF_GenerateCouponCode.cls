/*
* Apex class: TF_GenerateCouponCode
*/
@isTest
public class zTest_TF_GenerateCouponCode {
    private static void createSingleUseCpqDiscConfigSampleData() {
        Id recordTypeId = Schema.SObjectType.CPQ_Discount_Configuration__c.getRecordTypeInfosByName().get('T&F - PromoCode').getRecordTypeId();
        CPQ_Discount_Configuration__c configObject = new CPQ_Discount_Configuration__c();             
        configObject.RecordTypeId = recordTypeId;
        configObject.Discount_Type__c = '% Discount';
        configObject.Discount_Value_Percentage__c = 50.0;
        configObject.Promocode__c = 'MAK-2018-USJFISD';
        configObject.Product_Code__c = 'GACR';
        configObject.Discount_Display_Name__c = 'Coupon code';
        configObject.Active__c = true;
        configObject.Single_Use__c = true;
        configObject.Used_Quote__c='';
        configObject.Number_of_Quotes_used_this_PromoCode__c=null;
        configObject.Start_Date__c = date.today();
        configObject.End_Date__c = date.today()+20;
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
        
        String ret = TF_GenerateCouponCode.getProductTitle('XYZ');
        System.assert(ret != null);
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
        
        String ret = TF_GenerateCouponCode.getProductTitle('ABC');
        System.assert(ret == null);
        test.stopTest();
    }
    
    static testMethod void testCreateRecord() {
        test.startTest();
        Id recordTypeId = Schema.SObjectType.CPQ_Discount_Configuration__c.getRecordTypeInfosByName().get('T&F - PromoCode').getRecordTypeId();
        CPQ_Discount_Configuration__c configObject = new CPQ_Discount_Configuration__c();             
        configObject.RecordTypeId = recordTypeId;
        configObject.Discount_Category__c='Ad hoc';
        configObject.Discount_Type__c = '% Discount';
        configObject.Discount_Value_Percentage__c = 50.0;
        configObject.Promocode__c = 'MAK-2018-TEST';
        configObject.Product_Code__c = 'GACR';
        configObject.Discount_Display_Name__c = 'Coupon code';
        configObject.Active__c = true;
        configObject.Single_Use__c = true;
        configObject.Used_Quote__c='';
        configObject.Number_of_Quotes_used_this_PromoCode__c=null;
        configObject.Start_Date__c = date.today();
        configObject.End_Date__c = date.today()+20;
        configObject.CurrencyIsoCode = 'USD'; 
        insert configObject;  
        
        CPQ_Discount_Configuration__c cpqDiscConfig = [SELECT id,Name,Discount_Value_Percentage__c,Discount_Category__c,Single_Use__c,Promocode__c,Product_Code__c,Discount_Type__c,Start_Date__c,End_Date__c,CurrencyIsoCode FROM CPQ_Discount_Configuration__c WHERE Id =: configObject.Id];        
        Map<String,String> resMap = new Map<String,String>();         
        String startDate = String.valueOf(cpqDiscConfig.Start_Date__c);
        String endDate = String.valueOf(cpqDiscConfig.End_Date__c);
        String DiscountValue = String.valueOf(cpqDiscConfig.Discount_Value_Percentage__c);
        String isSingleUse = cpqDiscConfig.Single_Use__c == true ? 'Yes' : 'NO';
        List<CPQ_Discount_Configuration__c> res = TF_GenerateCouponCode.doSaveRecord(cpqDiscConfig.Product_Code__c,
                                           cpqDiscConfig.Discount_Category__c, 
                                           startDate, 
                                           endDate, 
                                           '1', 
                                           cpqDiscConfig.Discount_Type__c, 
                                           DiscountValue, 
                                           cpqDiscConfig.CurrencyIsoCode, 
                                           isSingleUse, 
                                           'amit@gmail.com');
        System.assert(res != null);
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
        String ObjectApiName ='CPQ_Discount_Configuration__c';
        String fieldApiName ='Discount_Category__c';
		List<String> lst = new List<String>();
        lst = TF_GenerateCouponCode.getPickListValues(ObjectApiName,fieldApiName);
        test.stopTest();        
    }    
}