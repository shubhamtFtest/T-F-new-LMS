/***************************************************************************
Author : Vikas Varshney
Description : This class is used to get total price for bespoke collection //SFAL-228
Test class : zTest_TF_GetBespokeCountPCM
****************************************************************************/

public class TF_GetBespokeCountPCM {
    
    @future(callout=true)
    public static void getBespokeCountToUpdatePBE (String bespokeProductId, String recordTypeId, String prodCurrencyISOCode) {
        System.debug('bespokeProductId =====>' + bespokeProductId);
        System.debug('recordTypeId =====>' + recordTypeId);
        System.debug('prodCurrencyISOCode =====>' + prodCurrencyISOCode);
        List<PricebookEntry> pbeUnitPriceUpdateList = new List<PricebookEntry>();
        List<PricebookEntry> pbeStdInsertList = new List<PricebookEntry>();
        List<PricebookEntry> pbeInsertList = new List<PricebookEntry>();
        
        try {
            String stdPBId = [SELECT Id FROM Pricebook2 WHERE isStandard = true LIMIT 1].id;
            TF_PPDProcessController.processedQuery pcmResponse = new TF_PPDProcessController.processedQuery();
            System.debug('pcmResponse =====>' + JSON.serialize(pcmResponse));
            if ( Test.isRunningTest() ) {
                String pcmStr = '{"totalPriceUSD":58956.07,"totalPriceGBP":42323.2,"total":300,"ruleElementLst":null,"queryString":null,"productTypeReturned":null,"prListVal":null,"prList":null,"offset":null,"multiTypeRulesLst":[{"ruleElementLst":[{"value":"BEGIN","type":"separator","relationshipLabel":null,"relationship":null,"attributeLabel":null,"attribute":null},{"value":"BEGIN","type":"separator","relationshipLabel":null,"relationship":null,"attributeLabel":null,"attribute":null},{"value":"BEGIN","type":"separator","relationshipLabel":null,"relationship":null,"attributeLabel":null,"attribute":null},{"value":"2021","type":"criteria","relationshipLabel":"After","relationship":"GT","attributeLabel":"First Published Year","attribute":"book.firstPublishedYear"},{"value":"END","type":"separator","relationshipLabel":null,"relationship":null,"attributeLabel":null,"attribute":null},{"value":"AND","type":"logical","relationshipLabel":null,"relationship":null,"attributeLabel":null,"attribute":null},{"value":"BEGIN","type":"separator","relationshipLabel":null,"relationship":null,"attributeLabel":null,"attribute":null},{"value":"Available","type":"criteria","relationshipLabel":"Equals","relationship":"EQ","attributeLabel":"Status","attribute":"book.status"},{"value":"END","type":"separator","relationshipLabel":null,"relationship":null,"attributeLabel":null,"attribute":null},{"value":"AND","type":"logical","relationshipLabel":null,"relationship":null,"attributeLabel":null,"attribute":null},{"value":"BEGIN","type":"separator","relationshipLabel":null,"relationship":null,"attributeLabel":null,"attribute":null},{"value":"open-access","type":"criteria","relationshipLabel":"Not Equals","relationship":"NE","attributeLabel":"Open Access","attribute":"permissions.name"},{"value":"END","type":"separator","relationshipLabel":null,"relationship":null,"attributeLabel":null,"attribute":null},{"value":"AND","type":"logical","relationshipLabel":null,"relationship":null,"attributeLabel":null,"attribute":null},{"value":"BEGIN","type":"separator","relationshipLabel":null,"relationship":null,"attributeLabel":null,"attribute":null},{"value":"GB","type":"criteria","relationshipLabel":"NOT IN","relationship":"NI","attributeLabel":"Restricted Country","attribute":"rights.iso2"},{"value":"END","type":"separator","relationshipLabel":null,"relationship":null,"attributeLabel":null,"attribute":null},{"value":"AND","type":"logical","relationshipLabel":null,"relationship":null,"attributeLabel":null,"attribute":null},{"value":"BEGIN","type":"separator","relationshipLabel":null,"relationship":null,"attributeLabel":null,"attribute":null},{"value":"e-Book","type":"criteria","relationshipLabel":"IN","relationship":"IN","attributeLabel":"Format","attribute":"book.format"},{"value":"END","type":"separator","relationshipLabel":null,"relationship":null,"attributeLabel":null,"attribute":null},{"value":"AND","type":"logical","relationshipLabel":null,"relationship":null,"attributeLabel":null,"attribute":null},{"value":"BEGIN","type":"separator","relationshipLabel":null,"relationship":null,"attributeLabel":null,"attribute":null},{"value":"drm","type":"criteria","relationshipLabel":"Not Equals","relationship":"NE","attributeLabel":"Permission","attribute":"permissions.name"},{"value":"END","type":"separator","relationshipLabel":null,"relationship":null,"attributeLabel":null,"attribute":null},{"value":"END","type":"separator","relationshipLabel":null,"relationship":null,"attributeLabel":null,"attribute":null},{"value":"END","type":"separator","relationshipLabel":null,"relationship":null,"attributeLabel":null,"attribute":null}],"queryString":"{ { First Published Year After (2021) } AND { Status Equals (Available) } AND { Open Access Not Equals (open-access) } AND { Restricted Country NOT IN (GB) } AND { Format IN (e-Book) } AND { Permission Not Equals (drm) } } ","productType":"book"}],"msg":"Success","jsonString":null,"counts":[{"productType":"book","count":300},{"productType":"Total","count":300}],"columnsLst":null}';
                pcmResponse = (TF_PPDProcessController.processedQuery)System.JSON.deserialize( pcmStr, TF_PPDProcessController.processedQuery.class);
            } else {
                pcmResponse = TF_PPDprocessController.getCountsFromPCM_DynamicUI(bespokeProductId, null, 'true', 0, 10, 'USD', 'false', 'e-Book', 'Collections');
            }
            Decimal collectionPrice;
            List<Pricebook2> bespokePriceBookList = new List<Pricebook2>();
            List<PricebookEntry> pbeTFBespokeList = new List<PricebookEntry>();
            List<SBQQ__QuoteLine__c> qliUpdateList = new List<SBQQ__QuoteLine__c>();
            List<Product2> productUpdateList = new List<Product2>();
            
            bespokePriceBookList = [ SELECT Id FROM Pricebook2 WHERE Name = 'T&F Pricebook' OR Name = 'T&F - eBooks Pricebook' ];
            pbeTFBespokeList = [ SELECT id, UnitPrice, CurrencyIsoCode FROM PricebookEntry WHERE Product2Id =:bespokeProductId AND Product2.RecordTypeId =:recordTypeId AND Pricebook2Id IN:bespokePriceBookList AND CurrencyIsoCode =:prodCurrencyISOCode ];
            
            if ( pcmResponse  != NULL && ( pcmResponse.totalPriceUSD != NULL || pcmResponse.totalPriceGBP != NULL ) ) {
                if ( prodCurrencyISOCode == 'USD' ) {
                    collectionPrice = pcmResponse.totalPriceUSD;
                } else if ( prodCurrencyISOCode == 'GBP' ) {
                    collectionPrice = pcmResponse.totalPriceGBP;
                }
            }
            System.debug('collectionPrice =====>' + collectionPrice);
            
            if ( pcmResponse  != NULL && collectionPrice != NULL ) {
                if ( !pbeTFBespokeList.isEmpty() ) {
                    System.debug('Inside if class TF_GetBespokeCountPCM =====>');
                    for ( PricebookEntry pbe : pbeTFBespokeList ) {
                        /*if ( pbe.CurrencyIsoCode == 'USD' && pbe.UnitPrice != pcmResponse.totalPriceUSD ) {
                            pbeUnitPriceUpdateList.add( new PricebookEntry( id = pbe.id, UnitPrice = pcmResponse.totalPriceUSD ) );
                        } else if ( pbe.CurrencyIsoCode == 'GBP' && pbe.UnitPrice != pcmResponse.totalPriceGBP ) {
                            pbeUnitPriceUpdateList.add( new PricebookEntry( id = pbe.id, UnitPrice = pcmResponse.totalPriceGBP ) );
                        }*/
                        if ( pbe.CurrencyIsoCode == prodCurrencyISOCode && pbe.UnitPrice != collectionPrice ) {
                            System.debug('pbeUnitPrice =====>' + pbe.UnitPrice);
                            pbeUnitPriceUpdateList.add( new PricebookEntry( id = pbe.id, UnitPrice = collectionPrice ) );
                        }
                    }
                } else {
                    System.debug('Inside else class TF_GetBespokeCountPCM =====>');
                    pbeStdInsertList.add( new PricebookEntry(Pricebook2Id = stdPBId, Product2Id = bespokeProductId, UnitPrice = collectionPrice, UseStandardPrice = false, CurrencyIsoCode = 'USD', IsActive = true) );
                    
                    for (Pricebook2 pb : bespokePriceBookList) {
                        /*if ( prodCurrencyISOCode == 'USD' ) {
                            pbeInsertList.add( new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = bespokeProductId, UnitPrice = collectionPrice, UseStandardPrice = false, CurrencyIsoCode = prodCurrencyISOCode) );
                        }
                        
                        if ( prodCurrencyISOCode == 'GBP' ) {
                            
                            pbeInsertList.add( new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = bespokeProductId, UnitPrice = pcmResponse.totalPriceGBP, UseStandardPrice = false, CurrencyIsoCode = 'GBP') );
                        }*/
                        pbeInsertList.add( new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = bespokeProductId, UnitPrice = collectionPrice, UseStandardPrice = false, CurrencyIsoCode = prodCurrencyISOCode, IsActive = true) );
                    }
                }
                
                List<Product2> prodList = new List<Product2>();
                prodList = [ SELECT id, hub_Id__c FROM Product2 WHERE Id =:bespokeProductId ];
                for ( Product2 thisProduct : prodList ) {
                    productUpdateList.add( new Product2( id = thisProduct.id, Sales_Price__c = collectionPrice, List_Price__c = collectionPrice ) );
                }
                
                for ( SBQQ__QuoteLine__c qli : [ SELECT id FROM SBQQ__QuoteLine__c WHERE SBQQ__Product__c =:bespokeProductId ] ) {
                    qliUpdateList.add( new SBQQ__QuoteLine__c( id = qli.id, SBQQ__ListPrice__c = collectionPrice, Original_List_Price__c = collectionPrice, PCM_UUID__c = prodList[0].hub_Id__c ) );
                }
            }
            
            if ( !pbeUnitPriceUpdateList.isEmpty() ) {
                System.debug('pbeUnitPriceUpdateList =====>' + pbeUnitPriceUpdateList);
                update pbeUnitPriceUpdateList;
            }
            if ( !pbeStdInsertList.isEmpty() ) {
                System.debug('pbeStdInsertList =====>' + pbeStdInsertList);
                insert pbeStdInsertList;
                System.debug('pbeStdInsertList =====>' + pbeStdInsertList);
            }
            if ( !pbeInsertList.isEmpty() ) {
                System.debug('pbeInsertList =====>' + pbeInsertList);
                insert pbeInsertList;
                System.debug('pbeInsertList =====>' + pbeInsertList);
            }
            if ( !qliUpdateList.isEmpty() ) {
                System.debug('pbeInsertList Size =====>' + pbeInsertList.size());
                System.debug('pbeInsertList =====>' + pbeInsertList);
                List<PriceBookEntry> pbeList = new List<PriceBookEntry>();
                pbeList = [ SELECT id FROM PricebookEntry WHERE Product2Id =:bespokeProductId AND Pricebook2.Name = 'T&F - eBooks Pricebook' LIMIT 1 ];
                if ( !pbeList.isEmpty() ) {
                    for ( SBQQ__QuoteLine__c qli : qliUpdateList ) {
                        qli.SBQQ__PricebookEntryId__c = pbeList[0].id;
                    }
                }
                update qliUpdateList;
            }
            if ( !productUpdateList.isEmpty() ) {
                System.debug('productUpdateList Size =====>' + productUpdateList.size());
                System.debug('productUpdateList =====>' + productUpdateList);
                update productUpdateList;
            }
        } catch ( Exception ex ) {
            System.debug('Exception =====>' + ex.getMessage() + ', Line : ' + ex.getLineNumber());
        }
    }
    
    /*@description : This method updates the unit price for pricebook entry if sales price field in product2 is updated 
    SFAL-363 / 03-08-2022 / Radhikay Banerjee /  V1*/
    
    public static void updatePriceBookEntryData (String bespokeProductId, String recordTypeId, Decimal collectionPrice, String prodCurrencyISOCode) {
        try{
            List<Pricebook2> bespokePriceBookList = new List<Pricebook2>();
            List<PricebookEntry> pbeTFBespokeList = new List<PricebookEntry>();
            List<PricebookEntry> pbeUnitPriceUpdateList = new List<PricebookEntry>();
            bespokePriceBookList = [ SELECT Id FROM Pricebook2 WHERE Name = 'T&F - eBooks Pricebook' ];
            pbeTFBespokeList = [ SELECT id, UnitPrice, CurrencyIsoCode FROM PricebookEntry WHERE Product2Id =:bespokeProductId AND Product2.RecordTypeId =:recordTypeId AND Pricebook2Id IN:bespokePriceBookList AND CurrencyIsoCode =:prodCurrencyISOCode];
            for ( PricebookEntry pbe : pbeTFBespokeList ) {
                if ( pbe.UnitPrice != collectionPrice && pbe.CurrencyIsoCode == prodCurrencyISOCode) {
                    System.debug('pbeUnitPrice =====>' + pbe.UnitPrice);
                    pbeUnitPriceUpdateList.add( new PricebookEntry( id = pbe.id, UnitPrice = collectionPrice ) );
                }
            }
            if ( !pbeUnitPriceUpdateList.isEmpty() ) {
                System.debug('pbeUnitPriceUpdateList =====>' + pbeUnitPriceUpdateList);
                update pbeUnitPriceUpdateList;
            }
        }catch( Exception ex ) {
            System.debug('Exception =====>' + ex.getMessage() + ', Line : ' + ex.getLineNumber());
        }
    }
}