/************************************************************************** 
**CHG0055654 
**Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2014-05-06
** Modified by Hailey Niemand - 2017.01.26 - CHG0031794
** 
***************************************************************************/
@isTest
private class zTest_AncillaryMaterialsProduct {

    static testMethod void myUnitTest() 
    {
        String isbnAcillaryMaterials  = '999AM333';
        String isbnParent  = '999Parent333';
        
        String profileId = '333';
        //RecordType rtOpp = [Select r.Id, r.Name, r.SobjectType, r.SystemModstamp from RecordType r  where r.SobjectType = 'opportunity' and r.Name like 'CAS%' and IsActive = true order by  r.SystemModstamp limit 1];
        RecordType rtOpp = [Select r.Id, r.Name, r.SobjectType, r.SystemModstamp from RecordType r  where r.SobjectType = 'opportunity' and r.Name like 'T&F - CAS%' and IsActive = true order by  r.SystemModstamp limit 1]; //CHG0031794
        Product2 pAcillaryMaterials  = insertProduct(isbnAcillaryMaterials);
        Product2 pParent  = insertProduct(isbnParent);
        User u = zTEST_Shared.noinsertUser();
        insert u;
        
        List<Ancillary_Materials__c> am = new List<Ancillary_Materials__c>();
        
        Ancillary_Materials__c a1 = new Ancillary_Materials__c(Acillary_Materials_ISBN__c=isbnAcillaryMaterials,Product_ISBN__c= isbnParent);
        am.add(a1);
        
        a1 = new Ancillary_Materials__c(Acillary_Materials_ISBN__c=isbnParent,Product_ISBN__c=isbnAcillaryMaterials );
        am.add(a1);
        
        insert am;
        
        
        
    }
    
    
    public static Product2 insertProduct(String isbn){
        
        //Pricebook2 pb = [Select p.Id, p.IsActive, p.IsStandard, p.Name, p.SystemModstamp from Pricebook2 p  where p.IsStandard = true limit 1];
        
        String product2RecordtypeId = [select id from RecordType where sobjecttype = 'Product2' and name like 'T&F%' and IsActive = true limit 1].Id;
        Product2 p = zTEST_Shared.noinsertProduct2(product2RecordtypeId);
        p.ISBN__c = isbn;
        p.ProductCode = isbn;
        insert p;
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id='01s0Y0000082FixQAE', Product2Id=p.id, UnitPrice=1.00, IsActive=true, UseStandardPrice=false);
        insert pbe;
        
        
        
        return p;
    }
    
}