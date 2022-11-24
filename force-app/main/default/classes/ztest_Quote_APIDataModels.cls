@isTest
public class ztest_Quote_APIDataModels {
    
    private static  testMethod void testMethodOne()
    {  
        Quote_APIDataModels.Discount objdisCount=new  Quote_APIDataModels.Discount();
        objdisCount.currencyISO='USD';
        objdisCount.discountValueAmount=1;
        objdisCount.discountType='% Discount';
        
        List<Quote_APIDataModels.Discount> listDiscount=new List<Quote_APIDataModels.Discount>();
        listDiscount.add(objdisCount);
        Test.startTest();
        Quote_APIDataModels.Deal obj=new  Quote_APIDataModels.Deal();
        obj.discount=listDiscount;
        obj.getBestPercentageDiscount();
        Test.stopTest();
    }
}