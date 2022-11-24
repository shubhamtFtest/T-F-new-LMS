@IsTest
public class zTest_accountProductDiscountAPI {
@isTest
    private static void constructorTest(){
         Account ac = new Account(name ='testAcc',Customer_Id__c='12345') ;
         insert ac;
        Product2 prod=new Product2(Name='Epicureanism',ProductCode ='9781844651696',Netbase_Classifications__c='a',CurrencyIsoCode='USD',ISBN__c='9781844651696',Business_Division__c='History',Books_Subject_Description_1__c='Acting',Sales_Organization__c='IN01',Article_Type__c  ='Report',Publication_Date__c=System.today()-5000,Version_Type__c='Hardback',Lead_Author_Editor__c='test');
        insert prod;
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 8079, IsActive = true);
        insert standardPrice;
        Id RecordTypeIdCPQDiscConfig = Schema.SObjectType.CPQ_Discount_Configuration__c.getRecordTypeInfosByName().get('T&F - UBX Self Service').getRecordTypeId();
        List<CPQ_Discount_Configuration__c> cpqDisConfigList = new List<CPQ_Discount_Configuration__c>();
        CPQ_Discount_Configuration__c cpqDisConfig = new CPQ_Discount_Configuration__c();
        cpqDisConfig.Account__c = ac.Id;
        cpqDisConfig.Product__c = prod.Id;
        cpqDisConfig.Discount_Value_Percentage__c = 20;
        cpqDisConfig.Discount_Type__c = '% Discount';
        cpqDisConfig.Discount_Display_Name__c = 'UBX Self Service';
        cpqDisConfig.recordtypeid = RecordTypeIdCPQDiscConfig;
        
        
        CPQ_Discount_Configuration__c cpqDisConfig1 = new CPQ_Discount_Configuration__c();
        cpqDisConfig1.Product__c = prod.Id;
        cpqDisConfig1.Discount_Value_Percentage__c = 20;
        cpqDisConfig1.Discount_Type__c = '% Discount';
        cpqDisConfig1.Discount_Display_Name__c = 'UBX Self Service';
        cpqDisConfig1.recordtypeid = RecordTypeIdCPQDiscConfig;
        
        
        CPQ_Discount_Configuration__c cpqDisConfig2 = new CPQ_Discount_Configuration__c();
        cpqDisConfig2.Account__c = ac.Id;
        cpqDisConfig2.Discount_Value_Percentage__c = 20;
        cpqDisConfig2.Discount_Type__c = '% Discount';
        cpqDisConfig2.Discount_Display_Name__c = 'UBX Self Service';
        cpqDisConfig2.recordtypeid = RecordTypeIdCPQDiscConfig;
        
        CPQ_Discount_Configuration__c cpqDisConfig3 = new CPQ_Discount_Configuration__c();
        cpqDisConfig3.Account__c = ac.Id;
        cpqDisConfig3.Discount_Value_Percentage__c = 20;
        cpqDisConfig3.Discount_Type__c = '% Discount';
        cpqDisConfig3.Discount_Category__c = 'Netbase';
        cpqDisConfig3.Discount_Display_Name__c = 'UBX Self Service';
        cpqDisConfig3.recordtypeid = RecordTypeIdCPQDiscConfig;
        
        cpqDisConfigList.add(cpqDisConfig);
        cpqDisConfigList.add(cpqDisConfig1);
        cpqDisConfigList.add(cpqDisConfig2);
        cpqDisConfigList.add(cpqDisConfig3);
        
        insert cpqDisConfigList;
        
        accountProductDiscountAPI.dataWrapper dataWrap = new accountProductDiscountAPI.dataWrapper();
        dataWrap.customerId = '12345';
        dataWrap.ISBNCode = new List<string>();
        dataWrap.ISBNCode.add('9781844651696');
        Test.startTest();
        accountProductDiscountAPI.doPost(dataWrap);
        Test.stopTest();
        
    } 

}