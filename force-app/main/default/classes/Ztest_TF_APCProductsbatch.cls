@isTest
public class Ztest_TF_APCProductsbatch{
    
    static testMethod void runTest1(){
        Id productRtId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products'); 
        
        Pricebook2 pb = new Pricebook2();
        pb.Name = 'TF Test';
        insert pb;
        
        Integer createHowMany = 20;
        List<Product2> products = new List<Product2>();
        for (Integer i = 0; i < createHowMany; i++) {  
            Product2 p1 = zTEST_Shared.noinsertProduct2(productRtId); //T&F - Products
            p1.ProductCode = 'TEST1234_'+i;
            p1.isActive = true;
            p1.OA_Offered__c = true;
            p1.Open_Access_Category__c = 'Open Select';
            p1.Article_Type__c = 'Full Rate';
            p1.Family = 'Journals-Author Side Charges';
            p1.Sales_Organization__c = 'IN01';
            products.add(p1);
            
            //Product NOT in the correct pricebook
            Product2 p2 = zTEST_Shared.noinsertProduct2(productRtId); //T&F - Products
            p2.ProductCode = 'TEST5678_'+i;
            p2.isActive = true;
            p2.OA_Offered__c = true;
            p2.Open_Access_Category__c = 'Open Select';
            p2.Article_Type__c = 'Full Rate';
            p2.Family = 'Journals-Author Side Charges';
            p2.Sales_Organization__c = 'IN01';
            products.add(p2);
        }
        insert products;
        List<CurrencyType> currencyTypes= [SELECT Id,IsActive,IsoCode FROM CurrencyType WHERE IsActive = true limit 20];
        //Product in the correct pricebook
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        for (Integer i = 0; i < products.size(); i++) {
            if(products[i].ProductCode.startsWith('TEST1234_')){
                for(CurrencyType ctype: currencyTypes){
                    PricebookEntry pbe1a = new PricebookEntry(CurrencyIsoCode=ctype.IsoCode,Pricebook2Id=Test.getStandardPricebookId(), Product2Id=products[i].Id, UnitPrice=1.00, IsActive=true, UseStandardPrice=false);
                    PricebookEntry pbe1b = new PricebookEntry(CurrencyIsoCode=ctype.IsoCode,Pricebook2Id=pb.Id, Product2Id=products[i].Id, UnitPrice=1.00, IsActive=true, UseStandardPrice=false);
                    pricebookEntries.add(pbe1a);
                    pricebookEntries.add(pbe1b);
                }
            }else{
                //Product NOT in the correct pricebook
                PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id=Test.getStandardPricebookId(), Product2Id=products[i].Id, UnitPrice=1.00, IsActive=true, UseStandardPrice=false); //Standard Price Book
                pricebookEntries.add(pbe2);
            }
        }
        
        insert pricebookEntries;
        Database.executeBatch(new TF_APCProductsbatch());
        
    }
    
}