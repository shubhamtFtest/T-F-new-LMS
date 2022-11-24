/******************************************************
* Test method for:
*   - ProductInterest_UpdateProduct.trigger  100%
******************************************************/
@isTest
public class zTEST_ProductInterest_UpdateProduct {
	
    static testMethod void test_ProductInterest_UpdateProductBatch() {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.noinsertAccount(u.Id);
        a.Ringgold_Account_ID__c = '1234xyxz';//Added 20161215
        insert a;
        
        Id productRtId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products'); //CHG0038379
        //Id pbId = [select id, name from pricebook2 where name = 'T&F One-Off Price Book'].Id; //CHG0038379
        
        Pricebook2 pb = new Pricebook2();
        pb.Name = 'TF Test';
        insert pb;
        
        integer createHowMany=100;
        
        List<Contact> contacts = new List<Contact>();
        List<Product2> products = new List<Product2>();
        for (Integer i = 0; i < createHowMany; i++) 
        {	Contact c = zTEST_Shared.noinsertContact(u.Id, a.Id);
         	c.LastName= 'TEST1234_'+i;
         	contacts.add(c);
            Product2 p1 = zTEST_Shared.noinsertProduct2(productRtId); //T&F - Products
        	p1.ProductCode = 'TEST1234_'+i;
            products.add(p1);
            
            //Product NOT in the correct pricebook
        	Product2 p2 = zTEST_Shared.noinsertProduct2(productRtId); //T&F - Products
        	p2.ProductCode = 'TEST5678_'+i;
            products.add(p2);
        }
        insert contacts;
        insert products;
       	List<CurrencyType> currencyTypes= [SELECT Id,IsActive,IsoCode FROM CurrencyType WHERE IsActive = true limit 20];
        //Product in the correct pricebook
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        for (Integer i = 0; i < products.size(); i++) 
        {
            if(products[i].ProductCode.startsWith('TEST1234_'))
            {
                for(CurrencyType ctype: currencyTypes)
                {
        			PricebookEntry pbe1a = new PricebookEntry(CurrencyIsoCode=ctype.IsoCode,Pricebook2Id=Test.getStandardPricebookId(), Product2Id=products[i].Id, UnitPrice=1.00, IsActive=true, UseStandardPrice=false);
        			PricebookEntry pbe1b = new PricebookEntry(CurrencyIsoCode=ctype.IsoCode,Pricebook2Id=pb.Id, Product2Id=products[i].Id, UnitPrice=1.00, IsActive=true, UseStandardPrice=false);
            		pricebookEntries.add(pbe1a);
            		pricebookEntries.add(pbe1b);
                }
        	}else
            {
            //Product NOT in the correct pricebook
            PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id=Test.getStandardPricebookId(), Product2Id=products[i].Id, UnitPrice=1.00, IsActive=true, UseStandardPrice=false); //Standard Price Book
            pricebookEntries.add(pbe2);
            }
        }
        
        insert pricebookEntries;
        
        List<ProductInterest__c> pis = new List<ProductInterest__c>();
        for (Integer i = 0; i < createHowMany; i++) 
        {
            ProductInterest__c pi1 = new ProductInterest__c();
        	pi1.ContactID__c = contacts[i].Id;
        	pi1.Product_Interest_Role__c = 'test_'+i;
        	pi1.DOI__c = 'test_'+i;
        	pi1.Product_Code__c = 'TEST1234_'+i;
        
        	ProductInterest__c pi2 = new ProductInterest__c();
        	pi2.ContactID__c = contacts[i].Id;
        	pi2.Product_Interest_Role__c = 'test_'+i;
        	pi2.DOI__c = 'test_'+i;
        	pi2.Product_Code__c = 'TEST5678_'+i;
        
        	pis.add(pi1);
        	pis.add(pi2);
        }
        insert pis;
        update pis;
    }
}