//Tested by zTEST_CAS_Lead_ProductLookup.cls        100%
//
//Created by Jeff Lup - 2015.11.24 - moved existing Trigger into this Class

public with sharing class CAS_Lead_ProductLookup_Trig implements TriggerInterface_Lead.Runnable {
    public void run(TriggerInterface_Lead.Trig trig) {
        if (trig.isBefore && (trig.isInsert || trig.isUpdate)) {
            List<string> isbns = new List<string>();
            for (Integer i = 0; i < trig.triggerSize; i++) {
                if (trig.newList[i].ISBN__c != null && trig.newList[i].ISBN__c != ''){
                  //  if (trig.isInsert || trig.newList[i].ISBN__c != trig.oldList[i].ISBN__c)
                    {
                        String isbn = trig.newList[i].ISBN__c.replaceAll(' ','').replaceAll('-','');
                        isbns.add(isbn);
                    }
                }
            }    
            if (isbns.size() > 0){
                Map<string, string> mapIsbnToProduct = new Map<string, string>();
                Map<string, decimal> mapIsbnToEdition = new Map<string, decimal>(); //CHG0067110
                List<Product2> products = [SELECT Id, ProductCode, Edition_Number__c //CHG0067110
                                           FROM Product2
                                           WHERE IsActive = true 


                                               AND RecordTypeId = '0120Y000000WnAaQAK' //T&F - Products
                                               AND ProductCode IN :isbns];
                                               
                for (Product2 p : products){
                    mapIsbnToProduct.put(p.ProductCode, p.Id);
                    mapIsbnToEdition.put(p.ProductCode, p.Edition_Number__c);
                }
                
                //CHG0067110
                Map<string, decimal> mapIsbnToGbp = new Map<string, decimal>();
                Map<string, decimal> mapIsbnToUsd = new Map<string, decimal>();
                List<PricebookEntry> pbes = [SELECT Id, ProductCode, Product2Id, CurrencyIsoCode, UnitPrice 
                                             FROM PriceBookEntry 
                                             WHERE IsActive = true 


                                               AND Pricebook2Id = '01s0Y00000832dDQAQ' //T&F Pricebook
                                               AND CurrencyIsoCode IN ('GBP','USD')
                                               AND Product2Id IN :products];
                                               
                for (PricebookEntry pbe : pbes){
                    if (pbe.CurrencyIsoCode == 'GBP') 
                        mapIsbnToGbp.put(pbe.ProductCode, pbe.UnitPrice);
                    else if (pbe.CurrencyIsoCode == 'USD')
                        mapIsbnToUsd.put(pbe.ProductCode, pbe.UnitPrice );
                }
                                               
                for (Integer i = 0; i < trig.triggerSize; i++) {
               if (trig.newList[i].ISBN__c != null && trig.newList[i].ISBN__c != '')
              {
                    String isbn = trig.newList[i].ISBN__c.replaceAll(' ','').replaceAll('-','');
                    trig.newList[i].Product_Name__c = mapIsbnToProduct.get(isbn);
                    //CHG0067110
                    trig.newList[i].Edition_Number__c = mapIsbnToEdition.get(isbn);
                    trig.newList[i].Price_GBP__c = mapIsbnToGbp.get(isbn);
                    trig.newList[i].Price_USD__c = mapIsbnToUsd.get(isbn);
                   }
                }
            }
        }
    }
}