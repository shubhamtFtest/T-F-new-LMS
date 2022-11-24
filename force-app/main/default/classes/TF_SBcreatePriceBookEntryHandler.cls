Public class TF_SBcreatePriceBookEntryHandler {
    Public static Map<String,Decimal>   orgCurrencyToOtherCurrencyMap ;  
    Public static Map<String,Decimal> otherCurrencyToOrgCurrencyMap ;
    Public static Id stdPriceBookId ;
    private static Map<Id, set<string>> standardnotavailableMap = new Map<Id, set<string>>();
    private static Map<Id, set<string>> customnotavailableMap = new Map<Id, set<string>>();
    Private static String cpqPricebookName = 'T&F CPQ Price Book 2017';
    // Get the corporate currency ISO code
    private static string corporateIsocode = [SELECT ISOCode, ConversionRate FROM CurrencyType WHERE IsActive=TRUE and IsCorporate=TRUE limit 1].ISOCode;
    
    /****************************************************************************
    Create price book entries for standard price book if any currency is missed.
    ***********************************************************************************/
    
    Public static void createPriceBookEntries (Set<Id> productId, set<string> pbeCurrencySet) {
        Set<Id> productIdSet = new Set<Id>();
        List<Pricebookentry> stdpbelstToInsert = new List<pricebookentry>();
        
        // Get the conversion rate 
        convertFromOrgCurrency(pbeCurrencySet);
        
        // Get the standard price book Id
        StandardPriceBookId();
        
        // Get the products and price book entries for standard price book
        Map<Id,Product2> productlst = new Map<Id,Product2>([select id, (select id,currencyisocode,unitprice from pricebookentries where currencyisocode in :pbecurrencyset and pricebook2Id = :stdPriceBookId )
                                                            from product2 where id in :productId]);
        /*for(Product2 prod: productlst.values()) {
            set<string> notavailablecurrency = new set<string>();
            if(prod.pricebookentries.size() < pbeCurrencySet.size() && prod.pricebookentries.size()>0) {
                productIdSet.add(prod.id);
                for(String currencycode : pbeCurrencySet) {
                    
                    // Add the currencies and then remove the available price book entry currency so that we will get the currencies which
                    //are not available in the price book entry for the product
                    
                    notAvailablecurrency.add(currencycode);
                    for(Pricebookentry pbe : prod.pricebookentries) { 
                        notAvailablecurrency.remove(pbe.currencyisocode);
                    }
                }
                if(!notavailablecurrency.isEmpty()) {
                standardnotavailableMap.put(prod.id,notavailablecurrency);
                }
            }
        }*/
        for(Product2 prod: productlst.values()) {
            if(prod.pricebookentries.size() < pbeCurrencySet.size() && prod.pricebookentries.size()>0) {
	            set<string> notavailablecurrency = new set<string>();
                productIdSet.add(prod.id);
                notavailablecurrency.addAll(pbeCurrencySet);
                for(Pricebookentry pbe : prod.pricebookentries) { 
                    notAvailablecurrency.remove(pbe.currencyisocode);
                }
                if(!notavailablecurrency.isEmpty()) {
                	standardnotavailableMap.put(prod.id,notavailablecurrency);
                }
            }
        }
        // If there are any products where price book entries are not available for currencies
        if(!productIdSet.isEmpty()) {
            for(Product2 prod : productlst.values()) {
                if(prod.pricebookentries.size()>0) {
                    PricebookEntry existingpbe = new PricebookEntry();
                    // check if the price has given for USD, then take the usd price and convert
                    // If USD price is not there then take any other currency which is not created using the utility class.
                    for(Pricebookentry pb : prod.pricebookentries) {
                     existingpbe = prod.pricebookentries[0];
                        if(pb.CurrencyIsoCode == corporateIsocode) {
                            existingpbe = pb;
                            break;
                        }
                    }
                    if(!standardnotavailableMap.isEmpty()) {
                        
                        set<string> notAvailableCurrencySet = new set<string>();
                        if(standardnotavailableMap.containskey(prod.id)) {
                         notAvailableCurrencySet =standardnotavailableMap.get(prod.id);
                        }
                            
                        for(String createCurrencyCode : notAvailableCurrencySet) {
                            PriceBookEntry pbe = new PriceBookEntry();
                            pbe.Product2Id = prod.id;
                            pbe.Pricebook2Id = stdPriceBookId;
                            pbe.IsActive = true;
                            pbe.CurrencyIsoCode = createCurrencyCode;
                            pbe.Utility_Created__c = true;
                            
                            // If the available price book entry is corporatecurrency then directly multiply with conversion rate
                            if (existingpbe.currencyisocode == corporateIsocode) {
                                pbe.UnitPrice = (existingpbe.unitprice * orgCurrencyToOtherCurrencyMap.get(createCurrencyCode)).round();
                            }
                            // else if the available price book entry is not corporatecurrency then convert the currency to org currency and then
                            // multiply with conversion rate
                            else {
                                pbe.Unitprice = (existingpbe.UnitPrice * otherCurrencyToOrgCurrencyMap.get(existingpbe.currencyisocode) * orgCurrencyToOtherCurrencyMap.get(createCurrencyCode)).round();
                            }
                            
                            stdpbelstToInsert.add(pbe);
                        }
                    }            
                }
                
            }
        }
        if(!stdpbelstToInsert.isEmpty()) {
            insert stdpbelstToInsert;
        }
        
        createcustompbe(productId, pbeCurrencySet);  //Method which creates price book entries for cpq price book
    }
    
    /****************************************************************************
    Create price book entries for custom cpq price book if any currency is missed.
    ***********************************************************************************/
    public static void createcustompbe (Set<Id> productId, set<string> pbeCurrencySet) {
        Set<Id> productIdSet = new Set<Id>();
        List<Pricebookentry> cuspbelstToInsert = new List<pricebookentry>();
        Map<Id,Product2> productlst = new Map<Id,Product2>([select id, (select id,pricebook2id,currencyisocode,unitprice from pricebookentries where currencyisocode in :pbecurrencyset and pricebook2.Name = :cpqPricebookName )
                                                            from product2 where id in :productId]);
        /*for(Product2 prod: productlst.values()) {
            set<string> notavailablecurrency = new set<string>();
            if(prod.pricebookentries.size() < pbeCurrencySet.size() && prod.pricebookentries.size()>0) {
                productIdSet.add(prod.id);
                for(String currencycode : pbeCurrencySet) {
                    notavailablecurrency.add(currencycode);
                    for(Pricebookentry pbe : prod.pricebookentries) { 
                        notavailablecurrency.remove(pbe.currencyisocode);
                    }
                }
                if(!notavailablecurrency.isEmpty()) {
                customnotavailableMap.put(prod.id,notavailablecurrency);
            }
            }
        }*/
        for(Product2 prod: productlst.values()) {
            set<string> notavailablecurrency = new set<string>();
            if(prod.pricebookentries.size() < pbeCurrencySet.size() && prod.pricebookentries.size()>0) {
                productIdSet.add(prod.id);
                notavailablecurrency.addAll(pbeCurrencySet);
                for(Pricebookentry pbe : prod.pricebookentries) { 
                    notavailablecurrency.remove(pbe.currencyisocode);
                }
                if(!notavailablecurrency.isEmpty()) {
                	customnotavailableMap.put(prod.id,notavailablecurrency);
            	}
            }
        }
        
        if(!productIdSet.isEmpty()) {
            for(Product2 prod : productlst.values()) {
                if(prod.pricebookentries.size()>0) {
                    PricebookEntry existingpbe = new PricebookEntry();
                    for(Pricebookentry pb : prod.pricebookentries) {
                     existingpbe = prod.pricebookentries[0];
                        if(pb.CurrencyIsoCode == corporateIsocode) {
                            existingpbe = pb;
                            break;
                        }
                    }
                    if(!customnotavailableMap.isEmpty() && customnotavailableMap.containskey(prod.id)) {
                        set<string> notAvailableCurrencySet = customnotavailableMap.get(prod.id);
                        for(String createCurrencyCode : notAvailableCurrencySet) {
                            PriceBookEntry pbe = new PriceBookEntry();
                            pbe.Product2Id = prod.id;
                            pbe.Pricebook2Id = existingPbe.Pricebook2Id;
                            pbe.IsActive = true;
                            pbe.CurrencyIsoCode = createCurrencyCode;
                            pbe.Utility_Created__c = true;
                            if (existingPbe.CurrencyIsoCode == corporateIsocode) {
                                pbe.UnitPrice = (existingPbe.unitprice * orgCurrencyToOtherCurrencyMap.get(createCurrencyCode)).round();
                            }
                            else {
                                pbe.Unitprice = (existingPbe.unitprice * otherCurrencyToOrgCurrencyMap.get(existingPbe.CurrencyIsoCode) * orgCurrencyToOtherCurrencyMap.get(createCurrencyCode)).round();
                            }
                            
                            cuspbelstToInsert.add(pbe);
                        }
                    }
                }    
            }
        }
        if(!cuspbelstToInsert.isEmpty()) {
            insert cuspbelstToInsert;
        }
    }
     /****************************************************************************
    Update prices if the conversion rate is changed
    ***********************************************************************************/
    Public static void updateprices(Set<Id> productId, set<string> pbeCurrencySet) {
        // Get the conversion rate 
        convertFromOrgCurrency(pbeCurrencySet);
        
        // Get the standard price book Id
        StandardPriceBookId();
        set<id> productidset = new set<id>();
        List<pricebookentry> pbelstToUpdate = new list<pricebookentry>();
        // Get the products where the price book entries are created using conversion rates
        Map<Id,Product2> stdproductlst = new Map<Id,Product2>([select id, (select id,currencyisocode,unitprice from pricebookentries where currencyisocode in :pbecurrencyset and pricebook2Id = :stdPriceBookId and utility_created__c = true )
                                                               from product2 where id in :productId]);
        for(product2 p : stdproductlst.values()) {
            if(p.pricebookentries.size()>0) {
                productidset.add(p.id);
            }
        }
        // Get the pricebookentries where the price is given by customer
        Map<Id,Product2> stdproductlst1 = new Map<Id,Product2>([select id, (select id,currencyisocode,unitprice from pricebookentries where currencyisocode in :pbecurrencyset and pricebook2Id = :stdPriceBookId and utility_created__c = false)
                                                                from product2 where id in :productIdset]);
        for(product2 p : stdproductlst.values()) {
            if(productidset.contains(p.id)) {
                if(stdproductlst1.get(p.id)!=null)  // checking whether list contains atleast one element(Jeff review comment fix)
                {
                if(stdproductlst1.get(p.id).pricebookentries.size()>0) {
                    PricebookEntry existingpbe = new PricebookEntry();
                    for(Pricebookentry pb : stdproductlst1.get(p.id).pricebookentries) {
                     existingpbe = pb;
                        if(pb.CurrencyIsoCode == corporateIsocode) {
                            existingpbe = pb;
                            break;
                        }
                    }
                    for(Pricebookentry pbe : p.pricebookentries) {
                        decimal d;
                        if (existingpbe.CurrencyIsoCode == corporateIsocode) {
                            
                            d  = (existingpbe.unitprice * orgCurrencyToOtherCurrencyMap.get(pbe.currencyisocode)).round();
                        }
                        else {
                            d = (existingpbe.unitprice * otherCurrencyToOrgCurrencyMap.get(existingpbe.CurrencyIsoCode) * orgCurrencyToOtherCurrencyMap.get(pbe.currencyisocode)).round();
                        }
                        if(d != pbe.UnitPrice) {
                            pbe.unitprice = d;
                            pbelstToUpdate.add(pbe);
                        }
                    }
                }
            }
            }
        }
        set<id> productidset1 = new set<id>();
        
        Map<Id,Product2> custproductlst = new Map<Id,Product2>([select id, (select id,currencyisocode,unitprice from pricebookentries where currencyisocode in :pbecurrencyset and pricebook2.Name = :cpqPricebookName and utility_created__c = true )
                                                                from product2 where id in :productId]);
        for(product2 p : custproductlst.values()) {
            if(p.pricebookentries.size()>0) {
                productidset1.add(p.id);
            }
        }
        Map<Id,Product2> custproductlst1 = new Map<Id,Product2>([select id, (select id,currencyisocode,unitprice from pricebookentries where currencyisocode in :pbecurrencyset and pricebook2.Name = :cpqPricebookName and utility_created__c = false)
                                                                 from product2 where id in :productIdset1]);
        for(product2 p : custproductlst.values()) {
            if(productidset1.contains(p.id)) {
                if(custproductlst1.get(p.id)!=null) // checking whether list contains atleast one element(Jeff review comment fix)
                {
                if(custproductlst1.get(p.id).pricebookentries.size()>0) {
                    PricebookEntry existingpbe = new PricebookEntry();
                    for(Pricebookentry pb : custproductlst1.get(p.id).pricebookentries) {
                     existingpbe = pb;
                        if(pb.CurrencyIsoCode == corporateIsocode) {
                            existingpbe = pb;
                            break;
                        }
                    }
                    for(Pricebookentry pbe : p.pricebookentries) {
                        decimal d;
                        if (existingpbe.CurrencyIsoCode == corporateIsocode) {
                            
                            d  = (existingpbe.unitprice * orgCurrencyToOtherCurrencyMap.get(pbe.currencyisocode)).round();
                            
                            
                        }
                        else {
                            d = (existingpbe.unitprice * otherCurrencyToOrgCurrencyMap.get(existingpbe.CurrencyIsoCode) * orgCurrencyToOtherCurrencyMap.get(pbe.currencyisocode)).round();
                        }
                        if(d != pbe.UnitPrice) {
                            pbe.unitprice = d;
                            pbelstToUpdate.add(pbe);
                        }
                    }
                }
            }
            }
        }
        if(!pbelstToUpdate.isEmpty()) {
            update pbelstToUpdate;
        }
    }
    
    /****************************************************************************
    Get the conversion rates for the currencies
    ***********************************************************************************/
    public static void convertFromOrgCurrency(set<string> pbeCurrencySet) {    
        orgCurrencyToOtherCurrencyMap = new Map<String,Decimal>();
        otherCurrencyToOrgCurrencyMap = new Map<String,Decimal>();
        Map<Id,currencyType> currencyMap = new Map<Id,currencyType> ([select id, isoCode, conversionrate from CurrencyType
                                                                      WHERE isocode in :pbeCurrencySet]);
        for (CurrencyType currtyp: currencyMap.values() ) {
            
            orgCurrencyToOtherCurrencyMap.put(currtyp.isocode, currtyp.conversionrate);
            //Convert to Org Currency
            otherCurrencyToOrgCurrencyMap.put(currtyp.isocode, (1/currtyp.conversionrate));
        }
        
    }
    
    /****************************************************************************
    Get the standard price book Id
    ***********************************************************************************/
    private static void StandardPriceBookId () {
        if(Test.isRunningTest()) {
            stdPriceBookId = Test.getStandardPricebookId();
        }
        else if (stdPriceBookId == null) 
            stdPriceBookId    = [select id, name from Pricebook2 where isStandard = true limit 1].id;
        
    }
}