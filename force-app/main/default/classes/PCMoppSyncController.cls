/**
Author : 
Test class : zTest_PCMoppSyncController
Description : 
**/
// TODO:  
// 

public class PCMoppSyncController {
    
    @AuraEnabled
    public Static List<wrapPricebkEntProduct> getProductDetails(string quoteId){
        SBQQ__Quote__c quoteRec = new SBQQ__Quote__c();
        quoteRec = [Select CurrencyIsoCode from SBQQ__Quote__c where Id =: quoteId];
        List<wrapPricebkEntProduct> wrapList = new List<wrapPricebkEntProduct>();
        List<PricebookEntry> priceBookEntryList = new List<PricebookEntry >([Select id,Name,UnitPrice,IsActive,CurrencyIsoCode,Pricebook2Id,Product2Id,ProductCode from PricebookEntry where Pricebook2.name ='T&F – OA BPC PriceBook' AND IsActive=True and CurrencyIsoCode =: quoteRec.CurrencyIsoCode]);
        for(PricebookEntry priceBkEnt:priceBookEntryList){
            wrapPricebkEntProduct wrapObj = new wrapPricebkEntProduct();
            wrapObj.productId = priceBkEnt.Product2Id;
            wrapObj.PricebkEntProduct = priceBkEnt;
            wrapList.add(wrapObj);
        }
        system.debug('wrapList-->'+wrapList);
        return wrapList;
    }
    
    @AuraEnabled
    public Static List<String> getCurrencyDetails(string quoteId){
        String currencyCode = 'GBP';
        List<String> dataReturnList = new List<String>();
        SBQQ__Quote__c quoteRec = new SBQQ__Quote__c();
        quoteRec = [Select CurrencyIsoCode from SBQQ__Quote__c where Id =: quoteId];
        if(quoteRec.CurrencyIsoCode != null){
            currencyCode = quoteRec.CurrencyIsoCode;
        }
        dataReturnList.add(currencyCode);
        
        String objectName = 'SBQQ__QuoteLine__c';
        String fieldName ='Licence_Type__c';
        
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            dataReturnList.add(pickListVal.getLabel());
        } 
        Return dataReturnList;
    }
    //SFAL-20 added by shubham kumar
    @AuraEnabled
    public Static List<string> getEntitlementDetails(String quoteId,String ProductType,List<string>ISBNNumbers){
        try {
            system.debug('quoteId'+quoteId+'--'+ProductType+'ISBNNumbers'+ISBNNumbers);
            //Getting the customerId from the quote Id;
            String customerId = [SELECT SBQQ__Account__r.Customer_Id__c FROM SBQQ__Quote__c WHERE Id = :quoteId].SBQQ__Account__r.Customer_Id__c;
            //String ProductType = 'BOOk';
            Map<String, String> mapHeader = new Map<String, String>();
            Map<String,  String> duplicateproductsbyisbn = new Map<String,  String>();
            Map<String,  String> productisbnByName = new Map<String,  String>();
            set<String> productsName = new set<String>();
            List<String> alreadyEntitledPRoducts = new List<String>();
            Map<String, Map<String, String>> productIdsbyIsBN = new Map<String,Map<String, String>>();
            mapHeader.put('Content-Type','application/json');
            
            String entitlementURL = [SELECT New_Platform_Api_URL__c  FROM TF_OrgSpecificProps__c ].New_Platform_Api_URL__c+'/v5/entitlements/?customerId='+customerId+'&status=ACTIVE';
            system.debug('entitlementURL'+entitlementURL);
            
            String isbns = '';
            for(String isbn : ISBNNumbers){
                isbns  = isbns+'&isbns='+isbn;
            }
            system.debug('entitlementURL'+entitlementURL);
            entitlementURL = entitlementURL +isbns+'&productType=BOOK';
            system.debug('entitlementURL'+entitlementURL);
            //string url = 'https://api-uat.taylorfrancis.com/v5/entitlements/?customerId=98422&status=ACTIVE&Offset=1&limit=2&isbns=9780203939048&isbns=9780429276781&productType=BOOK';
            httpResponse res = TF_PlatformExecuter.execute(entitlementURL,'GET','idtoken',null, mapHeader, false);
            if (res.getStatusCode() == 201 || res.getStatusCode() == 200)
            {
                System.debug('****responseBody****!' + res.getBody());
                // deserialize here
                EntitlementDataWrapper TF_EntitlementResponseObj =(EntitlementDataWrapper) System.JSON.deserialize(res.getBody(), EntitlementDataWrapper.class);
                system.debug('TF_EntitlementResponseObj.data.orderNumber-'+TF_EntitlementResponseObj.data[0].product);
                
                for(integer i=0;i < TF_EntitlementResponseObj.data.size() ; i++ ){
                    system.debug(TF_EntitlementResponseObj.data[i].product.isbn);
                    Map<String, String> productIdbyName = new Map<String, String>();
                    productIdbyName.put(TF_EntitlementResponseObj.data[i].product.id,TF_EntitlementResponseObj.data[i].product.name);
                    productisbnByName.put(TF_EntitlementResponseObj.data[i].product.isbn,TF_EntitlementResponseObj.data[i].product.name);
                    productIdsbyIsBN.put(TF_EntitlementResponseObj.data[i].product.isbn,productIdbyName);
                    //TF_EntitlementResponseObj.data[i].product.name
                }
                system.debug('productIdsbyIsBN'+productIdsbyIsBN);
                for(String isbn : productisbnByName.keyset()){
                    //productsName.add(productisbnByName.get(isbn));
                    productsName.add(productisbnByName.get(isbn));
                }
                for(String name:productsName){
                    alreadyEntitledPRoducts.add(name);
                }
                
                system.debug('alreadyEntitledPRoducts'+alreadyEntitledPRoducts.size()+'alreadyEntitledPRoducts'+alreadyEntitledPRoducts);
                
                return alreadyEntitledPRoducts;
            }
            else{
                System.debug('bad response-'+ res.getStatus());
                System.debug('bad res.getBody()-'+ res.getBody());
                return null;
            }     
            
        } catch (Exception e) {
            System.debug('error -'+e.getMessage()+'----'+e.getLineNumber());
            return null;
        } 
    }
    
    @AuraEnabled
    public Static String syncDataToQuoteLine(string quoteId,string DataToSync,string DataToDelete,string currencyCode){
        List<productToSyncWrapper> datatoUPSERT = new List<productToSyncWrapper>();
        List<string> delDataList = new List<String>();
        delDataList = (List<String>)System.JSON.deserialize(DataToDelete, List<String>.class);
        datatoUPSERT = (List<productToSyncWrapper>)System.JSON.deserialize(DataToSync, List<productToSyncWrapper>.class);
        system.debug(quoteId);
        system.debug(delDataList);
        system.debug(datatoUPSERT);
        
        List<SBQQ__QuoteLine__c> oppProductList = new List<SBQQ__QuoteLine__c>();
        for(productToSyncWrapper asdw : datatoUPSERT){
            SBQQ__QuoteLine__c oli = new SBQQ__QuoteLine__c();
            if(asdw.quoteLineRecId != null){
                oli.Id = asdw.quoteLineRecId;
                //SFAL-20 Duplicate-icon check added by shubham 
                if(asdw.isDuplicate == true){
                    Oli.Is_Duplicate__c = true;
                }else{
                    Oli.Is_Duplicate__c = false;
                }
            }
            else{
                oli.SBQQ__Quote__c = quoteId;
                oli.SBQQ__Product__c = asdw.SalesforceProductId;
                oli.SBQQ__PricebookEntryId__c = asdw.SalesforcePriceBookEntry;
                oli.PCM_ISBN__c = asdw.PCMISBN;
                oli.PCM_Author_Name__c = asdw.PCMAuthor;
                oli.PCM_Product_Name__c = asdw.PCMProductName;
                oli.PCM_DOI__c = asdw.PCMDOI;
                oli.Licence_Type__c = asdw.LicenceType;
                oli.PCM_UUID__c = asdw.PCMUUID;
                oli.PCM_Type__c = asdw.PCMType;
                //SFAL-20 Duplicate-icon check added by shubham 
                if(asdw.isDuplicate == true){
                    Oli.Is_Duplicate__c = true;
                }else{
                    Oli.Is_Duplicate__c = false;
                }
                
            }
            oli.CurrencyIsoCode = currencyCode;
            oli.SBQQ__Quantity__c = 1;
            oli.SBQQ__ListPrice__c = asdw.UnitPrice;
            oli.Line_reference__c  = asdw.PONumber;
            oppProductList.add(oli);
        }
        if(oppProductList.Size()>0){
            UPSERT oppProductList;
        }
        if(delDataList.size()>0){
            Database.delete(delDataList);
        }
        
        List<SBQQ__QuoteLine__c> quoteLinesList = new List<SBQQ__QuoteLine__c>();
        quoteLinesList = [Select Id,SBQQ__Quote__c,Licence_Type__c,PCM_UUID__c,PCM_Type__c,PCM_DOI__c,PCM_ISBN__c,PCM_Product_Name__c,PCM_Author_Name__c,SBQQ__PricebookEntryId__c,SBQQ__Quote__r.CurrencyIsoCode,Line_reference__c,CurrencyIsoCode,SBQQ__Product__c,SBQQ__Product__r.Name,SBQQ__Product__r.ISBN__c,SBQQ__Product__r.Lead_Author_Editor__c,SBQQ__Quantity__c,SBQQ__ListPrice__c from SBQQ__QuoteLine__c where SBQQ__Quote__c =: quoteId];
        List<productToSyncWrapper> qliDataToComponent = new List<productToSyncWrapper>();
        for(SBQQ__QuoteLine__c oli : quoteLinesList){
            productToSyncWrapper osdw = new productToSyncWrapper();
            osdw.quoteLineRecId = oli.Id;
            osdw.SalesforceProductId = oli.SBQQ__Product__c;
            osdw.SalesforceProductName = oli.SBQQ__Product__r.Name;
            osdw.SalesforcePriceBookEntry = oli.SBQQ__PricebookEntryId__c;
            osdw.PCMISBN = oli.PCM_ISBN__c;
            osdw.PCMProductName = oli.PCM_Product_Name__c;
            osdw.PCMAuthor = oli.PCM_Author_Name__c;
            osdw.UnitPrice = oli.SBQQ__ListPrice__c;
            osdw.PONumber = oli.Line_reference__c;
            osdw.PCMDOI = oli.PCM_DOI__c;
            osdw.LicenceType = oli.Licence_Type__c;
            osdw.PCMUUID = oli.PCM_UUID__c;
            osdw.PCMType = oli.PCM_Type__c;
            qliDataToComponent.add(osdw);
        }
        
        return (JSON.serialize(qliDataToComponent));
    }
    
    @AuraEnabled
    public static string fetchQuoteLines(string quoteId){
        List<SBQQ__QuoteLine__c> quoteLinesList = new List<SBQQ__QuoteLine__c>();
        quoteLinesList = [Select Id,SBQQ__Quote__c,Licence_Type__c,PCM_UUID__c,PCM_Type__c,PCM_DOI__c,PCM_ISBN__c,PCM_Product_Name__c,PCM_Author_Name__c,SBQQ__PricebookEntryId__c,SBQQ__Quote__r.CurrencyIsoCode,Line_reference__c,CurrencyIsoCode,SBQQ__Product__c,SBQQ__Product__r.Name,SBQQ__Product__r.ISBN__c,SBQQ__Product__r.Lead_Author_Editor__c,SBQQ__Quantity__c,SBQQ__ListPrice__c from SBQQ__QuoteLine__c where SBQQ__Quote__c =: quoteId];
        List<productToSyncWrapper> qliDataToComponent = new List<productToSyncWrapper>();
        for(SBQQ__QuoteLine__c oli : quoteLinesList){
            productToSyncWrapper osdw = new productToSyncWrapper();
            osdw.quoteLineRecId = oli.Id;
            osdw.SalesforceProductId = oli.SBQQ__Product__c;
            osdw.SalesforceProductName = oli.SBQQ__Product__r.Name;
            osdw.SalesforcePriceBookEntry = oli.SBQQ__PricebookEntryId__c;
            osdw.PCMISBN = oli.PCM_ISBN__c;
            osdw.PCMProductName = oli.PCM_Product_Name__c;
            osdw.PCMAuthor = oli.PCM_Author_Name__c;
            osdw.UnitPrice = oli.SBQQ__ListPrice__c;
            osdw.PONumber = oli.Line_reference__c;
            osdw.PCMDOI = oli.PCM_DOI__c;
            osdw.LicenceType = oli.Licence_Type__c;
            osdw.PCMUUID = oli.PCM_UUID__c;
            osdw.PCMType = oli.PCM_Type__c;
            qliDataToComponent.add(osdw);
        }
        
        return (JSON.serialize(qliDataToComponent));
    }
    
    //Shalini: changes regarding ticket SAL-4182(Frontlist Chapter)
    @AuraEnabled
    public static string fetchQuoteOrderType(String quoteId)
    {
        List<SBQQ__Quote__c> quoteRec = new List<SBQQ__Quote__c>();
        quoteRec = [Select CurrencyIsoCode,BPC_Order_Type__c from SBQQ__Quote__c where Id =: quoteId];
        system.debug('fetchQuoteOrderType--> '+quoteRec);
        if(quoteRec != null && !quoteRec.isEmpty() && String.isNotBlank(quoteRec.get(0).BPC_Order_Type__c))
        {
            return quoteRec.get(0).BPC_Order_Type__c;
        }
        return null;
    }
    //Shalini: changes end regarding ticket SAL-4182
    
    //shalini: Changes start to use pcmImplicitFilter SAL-4494
    @AuraEnabled
    public static quoteAndOppDetailsWrapper getOppAndSapDetails(String quoteId)
    {
        String countryForRestrictionCheck;
        List<Opportunity> oppList = new List<Opportunity>();
        quoteAndOppDetailsWrapper quoteAndOppDetailsWrapperObj = new quoteAndOppDetailsWrapper();
        
        oppList = [Select id, SBQQ__PrimaryQuote__c,Bill_to_BP__c,Bill_to_BP__r.Country__c,Ship_to_BP__c,Ship_to_BP__r.Country__c
                   from opportunity where SBQQ__PrimaryQuote__c =: quoteId Limit 1];
        if(oppList != null && !oppList.isEmpty())
        {
            if(String.isNotBlank(oppList.get(0).Ship_to_BP__c) && String.isNotBlank(oppList.get(0).Ship_to_BP__r.Country__c)) 
                countryForRestrictionCheck = oppList.get(0).Ship_to_BP__r.Country__c;
            else if(String.isNotBlank(oppList.get(0).Bill_to_BP__c) && String.isNotBlank(oppList.get(0).Bill_to_BP__r.Country__c)) 
                countryForRestrictionCheck = oppList.get(0).Bill_to_BP__r.Country__c;
            
            if(String.isNotBlank(countryForRestrictionCheck))
            {
                List<Country__c> countryList = new List<Country__c>();
                countryList = [Select id, Country_2__c from country__c where name =: countryForRestrictionCheck Limit 1];
                if(countryList != null && !countryList.isEmpty() && String.isNotBlank(countryList.get(0).Country_2__c))
                    quoteAndOppDetailsWrapperObj.isoCodeForRestrictionCheck = countryList.get(0).Country_2__c;
            }
        }
        
        //Find the BPC order type
        String bpcOrderType = fetchQuoteOrderType(quoteId); 
        if(String.isNotBlank(bpcOrderType))
        {
            if(bpcOrderType == 'Backlist Chapter') 
                quoteAndOppDetailsWrapperObj.bpcOrderType = 'chapter';
            else if(bpcOrderType == 'Backlist eBook' || bpcOrderType == 'Frontlist Chapter' || bpcOrderType == 'Frontlist eBook')
                quoteAndOppDetailsWrapperObj.bpcOrderType = 'book';
        }
        
        system.debug('quoteAndOppDetailsWrapperObj '+quoteAndOppDetailsWrapperObj);
        return quoteAndOppDetailsWrapperObj;
    }
    
    public class quoteAndOppDetailsWrapper{
        @AuraEnabled
        public string isoCodeForRestrictionCheck{get;set;}
        @AuraEnabled
        public String bpcOrderType{get;set;}
    }
    //shalini: Changes end to use pcmImplicitFilter SAL-4494
    
    public class wrapPricebkEntProduct{
        @AuraEnabled
        public PricebookEntry PricebkEntProduct{get;set;}
        @AuraEnabled
        public String productId{get;set;}
    }
    public class productToSyncWrapper{
        @AuraEnabled
        public string PCMUUID;
        @AuraEnabled
        public string PCMType;
        @AuraEnabled
        public string PCMISBN;
        @AuraEnabled
        public string PCMAuthor;
        @AuraEnabled
        public string PCMDOI;
        @AuraEnabled
        public string PCMProductName;
        @AuraEnabled
        public decimal UnitPrice;
        @AuraEnabled
        public string PONumber;
        @AuraEnabled
        public string SalesforceProductId;
        @AuraEnabled
        public string SalesforceProductName;
        @AuraEnabled
        public String SalesforcePriceBookEntry;
        @AuraEnabled
        public String quoteLineRecId;
        @AuraEnabled
        public String LicenceType;
        @AuraEnabled
        public List<wrapPricebkEntProduct> SFDCProdList;
        @AuraEnabled
        public List<String> SFDCLicenceData;
        //SFAL-20 added by shubham kumar
        @AuraEnabled
        public Boolean isDuplicate;
    }
}