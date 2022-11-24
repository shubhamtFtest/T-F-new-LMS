/** Auther: Shalini Singh
Test Class: PCMOppSyncControllerDSTest
**/
public class PCMOppSyncControllerDS {
    
    @AuraEnabled
    public static String getProdRecordTypeId(String objectName,String recordTypeName){ //SFAL-148
        String returnRecordTypeName='';
        if(String.isNotBlank(objectName)&&String.isNotBlank(recordTypeName)){
            Id productRecordtypeId = MiscFunctions.getRecordtypeId(objectName,recordTypeName); 
            returnRecordTypeName=String.valueof(productRecordtypeId);
        } 
        return returnRecordTypeName;
    }
    //SFAL-147 / 12-04-2022 / Shubham Kumar / Initial Version
    //@description : This method is used for getting values from custom setting.
    @AuraEnabled
    public static customSettingWrapper getCustomSettingData(String quoteId) { 
        system.debug('quoteId'+quoteId);
        String bespokeBusinessId = '';
        String salesType = '';
        
        if(quoteId != null ){
            try{
                salesType =  [ SELECT id, Quote_Sales_Type__c FROM SBQQ__Quote__c WHERE id =:quoteId LIMIT 1].Quote_Sales_Type__c;    
            }
            catch(exception e){
                salesType = '';
            }
            //system.debug('salesType'+salesType); 
        }
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        bespokeBusinessId  = orgSpecificProps.Bespoke_businessId__c;
        Integer thresholdVal = Integer.ValueOf(orgSpecificProps.get('Quote_Items_Threshold__c'));
        String ProductRecordType = getProdRecordTypeId('Product2','T&F - BespokeCollection');
        customSettingWrapper csw = new customSettingWrapper();
        csw.threshHold = thresholdVal;
        csw.recordTypeId = ProductRecordType;
        csw.bespokeBusinessId = bespokeBusinessId;
        csw.salesType = salesType;
        return csw;
    }
    
    /*@AuraEnabled
public static String getBespokeBusinessId() { 
String bespokeBusinessId = '';
TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
bespokeBusinessId  = orgSpecificProps.Bespoke_businessId__c;
return bespokeBusinessId;
}*/
    
    @AuraEnabled
    public Static List<wrapPricebkEntProduct> getProductDetails(String quoteCurrencyCode, List<String> isbnSet){
        system.debug('quoteCurrencyCode '+quoteCurrencyCode);
        system.debug('isbnSet '+isbnSet);
        List<wrapPricebkEntProduct> wrapList = new List<wrapPricebkEntProduct>();
        List<PricebookEntry> priceBookEntryList = new List<PricebookEntry >([Select id,Name,UnitPrice,IsActive,CurrencyIsoCode,Pricebook2Id,Product2Id,ProductCode,Product2.doi__c,Product2.ISBN__c from PricebookEntry where Pricebook2.name ='T&F - eBooks Pricebook' AND IsActive=True AND CurrencyIsoCode =: quoteCurrencyCode AND Product2.ISBN__c In:isbnSet]);
        for(PricebookEntry priceBkEnt:priceBookEntryList){
            wrapPricebkEntProduct wrapObj = new wrapPricebkEntProduct();
            wrapObj.productId = priceBkEnt.Product2Id;
            wrapObj.OriginalListPrice1 = priceBkEnt.UnitPrice;
            wrapObj.PricebkEntProduct = priceBkEnt;
            wrapList.add(wrapObj);
        }
        return wrapList;
    }
    
    @AuraEnabled
    public Static List<wrapPricebkEntProduct> getProductDetailsByType(String quoteCurrencyCode, List<String> isbnSet,String productType,List<String> uuidsSet){
        system.debug('quoteCurrencyCode '+quoteCurrencyCode);
        system.debug('isbnSet '+isbnSet);
        system.debug('uuidsSet '+uuidsSet);
        List<wrapPricebkEntProduct> wrapList = new List<wrapPricebkEntProduct>();
        if(productType=='book'){
            List<PricebookEntry> priceBookEntryList = new List<PricebookEntry >([Select id,Name,UnitPrice,IsActive,CurrencyIsoCode,Pricebook2Id,Product2Id,ProductCode,Product2.doi__c,Product2.ISBN__c from PricebookEntry where Pricebook2.name ='T&F - eBooks Pricebook' AND IsActive=True AND CurrencyIsoCode =: quoteCurrencyCode AND Product2.ISBN__c In:isbnSet]);
            for(PricebookEntry priceBkEnt:priceBookEntryList){
                wrapPricebkEntProduct wrapObj = new wrapPricebkEntProduct();
                wrapObj.productId = priceBkEnt.Product2Id;
                wrapObj.OriginalListPrice1 = priceBkEnt.UnitPrice;
                wrapObj.PricebkEntProduct = priceBkEnt;
                wrapList.add(wrapObj);
            }
        }else if(productType=='collection'){
            List<Product2>prdIdsList=new List<product2>([Select id,Name from product2 where Product2.hub_id__c In:uuidsSet]);
            system.debug('prdIdsList%%'+prdIdsList);
            List<String>strIds=new List<String>();
            if(prdIdsList!=null){
                for(Product2 prdval:prdIdsList){
                    strIds.add(prdval.Id);
                    system.debug('strIds##'+strIds);
                }
            }
            List<PricebookEntry> priceBookEntryList = new List<PricebookEntry >([Select id,Name,UnitPrice,IsActive,CurrencyIsoCode,Pricebook2Id,Product2Id,ProductCode,Product2.doi__c,Product2.ISBN__c from PricebookEntry where Pricebook2.name ='T&F - eBooks Pricebook' AND IsActive=True AND CurrencyIsoCode =: quoteCurrencyCode AND Product2.Id In:strIds]);
            for(PricebookEntry priceBkEnt:priceBookEntryList){
                wrapPricebkEntProduct wrapObj = new wrapPricebkEntProduct();
                wrapObj.productId = priceBkEnt.Product2Id;
                wrapObj.OriginalListPrice1 = priceBkEnt.UnitPrice;
                wrapObj.PricebkEntProduct = priceBkEnt;
                wrapList.add(wrapObj);
            }
        }
        system.debug('wrapList%%%'+wrapList);
        return wrapList;
    }
    
    @AuraEnabled
    public Static String getCurrencyDetails(string quoteId){
        String currencyCode = 'USD';
        SBQQ__Quote__c quoteRec = new SBQQ__Quote__c();
        quoteRec = [Select CurrencyIsoCode from SBQQ__Quote__c where Id =: quoteId];
        
        if(quoteRec != null && quoteRec.CurrencyIsoCode != null){
            currencyCode = quoteRec.CurrencyIsoCode;
        }
        return currencyCode;
    }
    
    //SFAL-147 / 12-04-2022 / Shubham Kumar / Initial Version
    //@description : This method is used for getting response from Entitlements API.
    @AuraEnabled
    public Static List<string> getEntitlementDetails(String quoteId,String ProductType,List<string> PCMUUIDS){
        try {
            //Bespoke_businessId__c 
            system.debug('PCMUUIDS size'+PCMUUIDS.Size()+'Total PCMUUIDS======>'+PCMUUIDS);
            //Getting the customerId from the quote Id;
            String customerId = [SELECT SBQQ__Account__r.Customer_Id__c FROM SBQQ__Quote__c WHERE Id = :quoteId].SBQQ__Account__r.Customer_Id__c;
            List<Product2> ProductListfromPCMUUIDS = [Select id,Hub_Id__c,ProductCode,Name from Product2 where Hub_Id__c IN:PCMUUIDS];
            
            Map<String, String> mapHeader = new Map<String, String>();
            Map<String,  String> productsNameByIsbn = new Map<String,  String>();
            Map<String,  String> productisbnByName = new Map<String,  String>();
            List<String> alreadyEntitledPRoducts = new List<String>();
            Map<String, Map<String, String>> productIdsbyIsBN = new Map<String,Map<String, String>>();
            httpResponse res = new httpResponse();
            Integer maxUUIDs = 500;
            //Integer numOftimes = getTotalAverageCount(PCMUUIDS.size(),maxUUIDs);            
            List<EntitlementDataWrapper> TotalResponseFromEMS = new List<EntitlementDataWrapper>();
            
            mapHeader.put('Content-Type','application/json');
            
            for(Product2 prd:ProductListfromPCMUUIDS){
                productsNameByIsbn.put(prd.Hub_Id__c,prd.ProductCode);
            }
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            String entitlementURL = orgSpecificProps.New_Platform_Api_URL__c+'/v5/entitlements/'+customerId;
            system.debug('entitlementURL'+entitlementURL);
            
            if(PCMUUIDS.size() <= 500){
                ProductUUIDs prdtuuid = new ProductUUIDs();
                prdtuuid.productIds = PCMUUIDS;
                String body = JSON.serialize(prdtuuid);
                system.debug('Here is the Body========>'+body);
                res = TF_PlatformExecuter.execute(entitlementURL,'POST','idtoken',body, mapHeader, false); 
                if (res.getStatusCode() == 201 || res.getStatusCode() == 200){
                    System.debug('****responseBody****!'+res.getBody());
                    List<EntitlementDataWrapper> TF_EntitlementResponseObj =(List<EntitlementDataWrapper>) System.JSON.deserialize(res.getBody(), List<EntitlementDataWrapper>.class);
                    System.debug('****responseBody****!'+TF_EntitlementResponseObj);
                    TotalResponseFromEMS.addAll(TF_EntitlementResponseObj);
                }else{
                    System.debug('bad response-'+ res.getStatus());
                    System.debug('bad res.getBody()-'+ res.getBody());
                }
                
            }else{
                system.debug('PCMUUIDS.size========>>>>>>>>'+PCMUUIDS.size());
                List<List<String>> FinalSplittedLists = splitList(PCMUUIDS,maxUUIDs);
                List<List<String>> allSplittedLists = splitList(PCMUUIDS,maxUUIDs);
                
                if(allSplittedLists.size() < 100){
                    FinalSplittedLists = allSplittedLists;
                }else{
                    for(Integer i=0 ; i < 100 ; i++){
                        FinalSplittedLists.add(allSplittedLists[i]);
                    }
                }
                
                system.debug('allSplittedLists'+FinalSplittedLists);
                for(List<String> dynList : FinalSplittedLists)
                {
                    ProductUUIDs prdtuuid = new ProductUUIDs();
                    prdtuuid.productIds = dynList;
                    String body = JSON.serialize(prdtuuid);
                    system.debug('Here is the Body========>'+body);
                    res = TF_PlatformExecuter.execute(entitlementURL,'POST','idtoken',body, mapHeader, false); 
                    if (res.getStatusCode() == 201 || res.getStatusCode() == 200){
                        System.debug('****responseBody****!@ 99');
                        
                        List<EntitlementDataWrapper> TF_EntitlementResponseObj =(List<EntitlementDataWrapper>) System.JSON.deserialize(res.getBody(), List<EntitlementDataWrapper>.class);
                        TotalResponseFromEMS.addAll(TF_EntitlementResponseObj);
                        System.debug('****responseBody****!'+TF_EntitlementResponseObj);     
                    } else{
                        System.debug('bad response-'+ res.getStatus());
                        System.debug('bad res.getBody()-'+ res.getBody());
                        //return null;
                    }    
                }  
            }
            if (TotalResponseFromEMS.size() > 0)
            {  
                system.debug('TotalResponseFromEMS=======>'+TotalResponseFromEMS);
                //deserialize here
                
                for(EntitlementDataWrapper wrap : TotalResponseFromEMS){
                    system.debug('Wrap'+wrap.productId);
                    if(productsNameByIsbn.containsKey(wrap.productId)){
                        productisbnByName.put(wrap.productId,productsNameByIsbn.get(wrap.productId));
                    }
                }
                
                system.debug('productIdsbyIsBN'+productisbnByName);
                
                for(String name:productisbnByName.keyset()){
                    if(productsNameByIsbn.containsKey (name)){
                        alreadyEntitledPRoducts.add(productsNameByIsbn.get(name));
                    }
                }
                
                system.debug('alreadyEntitledPRoducts'+alreadyEntitledPRoducts.size()+'alreadyEntitledPRoducts'+alreadyEntitledPRoducts);
                return alreadyEntitledPRoducts;
            }
            else{
                System.debug('Some Error Occured'+ res.getStatus());
                return null;
            }     
            
        } catch (Exception e) {
            System.debug('error -'+e.getMessage()+'----'+e.getLineNumber());
            return null;
        } 
    }
    
    //SFAL-147 / 12-04-2022 / Shubham Kumar / Initial Version
    //@description : This method is used for getting how many time the Loop has to run to get Entitlement response.
    public static Integer getTotalAverageCount(Integer totalRecords, Integer num){
        
        try{
            Integer count = 0;
            Integer modVal = math.mod(totalRecords, num);
            if(modVal > 0){
                count = (totalRecords - modVal)/num +1;
            }else{
                count = totalRecords/num ;
            }
            return count;
        }
        catch(Exception ex){
            system.debug(ex.getMessage());
            return 0;
        }
    }
    
    //SFAL-147 / 12-04-2022 / Shubham Kumar / Initial Version
    //@description : This method is used for getting a list broken into different List.
    public static List<List<String>> splitList(List<String> strList, Integer maxUUIDs) {
        
        List<List<String>> spilttedLists = new List<List<String>>();
        
        integer count = getTotalAverageCount(strList.size(),maxUUIDs);
        system.debug('count'+count);
        for(Integer i = 0 ; i < count ; i++){
            List<string> dynamicUUIDS = new List<string>();
            for(Integer j=(i*maxUUIDs);(j<(i*maxUUIDs)+maxUUIDs) && j<strList.size() ; j++){
                dynamicUUIDS.add(strList.get(j));
            }
            spilttedLists.add(dynamicUUIDS);
        }
        system.debug('Size of List'+spilttedLists.size());
        return spilttedLists;
    }
    
    //SFAL-147 / 27-04-2022 / Shubham Kumar / Initial Version
    //@description : This method is used for Creating Bundle and QLI.
    @AuraEnabled
    public static void createBundle(string quoteId,String bundleProdId,string lineItems,Decimal totalsalePrice,String referenceNum){
        system.debug('bundleProdId------->'+bundleProdId+'lineItems'+lineItems);
        try{ 
            String PricebookId = '';
            
            List<SBQQ__QuoteLine__c> quoteLinesList = [Select id , name ,SBQQ__Quote__r.SBQQ__PriceBook__c from SBQQ__QuoteLine__c where SBQQ__Quote__c =:quoteId AND SBQQ__Bundled__c = false];
            //getting the priceBookID of the Quote
            PricebookId = [Select id , name ,SBQQ__PriceBook__c from SBQQ__Quote__c where id =:quoteId].SBQQ__PriceBook__c;
            system.debug('PricebookId'+PricebookId);
            //Testing
            string hubId = '';
            
            List<productToSyncWrapper> datatoUPSERT = new List<productToSyncWrapper>();
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            if(bundleProdId != null ){
                Product2 bundleProd = [select Id,Name,List_Price__c,Sales_Price__c from product2 where id = :bundleProdId ];
                
                list< Bundle_Line_Item__c> listofLineItems = new list< Bundle_Line_Item__c>();  
                List<productToSyncWrapper> bundleLineItems = new List<productToSyncWrapper>();
                
                datatoUPSERT = (List<productToSyncWrapper>)System.JSON.deserialize(lineItems, List<productToSyncWrapper>.class);
                system.debug('datatoUPSERT'+datatoUPSERT);
                for (productToSyncWrapper strProduct : datatoUPSERT) {
                    integer position = 1;
                    String productDoi = strProduct.PCMDOI +'||'+ bundleProd.Id;
                    
                    Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
                    lineItem.Product_Bundle_Parent__c = bundleProd.Id;
                    lineitem.Title__c  = strProduct.PCMProductName;
                    lineitem.Authors__c = strProduct.PCMAuthor;
                    lineitem.doi__c = strProduct.PCMDOI;
                    lineItem.Product_Doi__c =  productDoi;
                    lineItem.Product__c = bundleProd.Id;
                    lineItem.Source__c = 'PCM';
                    lineItem.PriceUSD__c = strProduct.UnitPrice;
                    lineItem.Type__c = strProduct.type;
                    lineItem.Product_Isbn__c = strProduct.PCMISBN;
                    lineItem.Valid__c = strProduct.PCMUUID != null && strProduct.PCMUUID != '' ? 'true' : 'false';
                    system.debug('strProduct.PCMUUID'+strProduct.PCMUUID);
                    lineitem.uuid__c = strProduct.PCMUUID;
                    hubId  = strProduct.PCMUUID;
                    lineItem.mediaType__c = strProduct.format;
                    lineItem.lineItemStatus__c   = 'IsInsert';
                    lineItem.Publisher__c   = strProduct.publisher;
                    lineItem.Open_access__c = strProduct.openAccess != null && strProduct.openAccess != 'No' ? false : true;
                    if(strProduct.publicationDate != null && strProduct.publicationDate != ''){
                        lineItem.Publication_Date__c = date.valueOf(strProduct.publicationDate) ;
                    }
                    
                    lineItem.Content_Position__c  = position++;
                    listofLineItems.add(lineItem);
                    position++;
                    
                }
                system.debug('listofLineItems'+listofLineItems);
                database.insert(listofLineItems);
                
                
                if(quoteId != null && bundleProd.id != null){
                    createPBE(quoteId, bundleProd.id, bundleProd.List_Price__c, totalsalePrice);    
                }
                
                PriceBookEntry pbe = new PriceBookEntry();
                if(test.isRunningTest()){
                    pbe = [SELECT id FROM PricebookEntry WHERE Pricebook2Id = '01s0Y00000832cjQAA'  LIMIT 1 ];
                }else{
                    pbe = [SELECT id FROM PricebookEntry WHERE Product2Id = :bundleProd.id  and pricebook2.Id =:PricebookId  LIMIT 1 ];
                }             
                
                system.debug('pbe-Id'+pbe.Id+'quoteId'+quoteId+'bundleProd'+bundleProd.Id+'bundleProd.List_Price__c'+bundleProd.List_Price__c+'totalsalePrice'+totalsalePrice);
                
                SBQQ__QuoteLine__c oli = new SBQQ__QuoteLine__c();
                oli.SBQQ__Quote__c = quoteId;
                oli.SBQQ__Product__c = bundleProd.Id;
                oli.PCM_Product_Name__c = bundleProd.Name;
                oli.SBQQ__Quantity__c = 1;
                oli.SBQQ__Bundled__c = true;
                oli.SBQQ__PricebookEntryId__c = pbe.Id;
                Oli.CurrencyIsoCode = '';
                oli.PCM_UUID__c = hubId;
                oli.SBQQ__ListPrice__c = totalsalePrice.setScale(2);
                oli.SBQQ__CustomerPrice__c =  totalsalePrice.setScale(2);
                oli.SBQQ__RegularPrice__c = totalsalePrice.setScale(2);
                oli.SBQQ__SpecialPrice__c  = totalsalePrice.setScale(2);    
                oli.PCM_ISBN__c       = '9781315695815 ';    
                
                oli.Original_List_Price__c = bundleProd.List_Price__c;
                oli.Line_reference__c  = referenceNum;
                oli.SBQQ__NetPrice__c = totalsalePrice.setScale(2);
                oli.Original_List_Price__c = bundleProd.List_Price__c;
                system.debug('oli'+oli);
                database.insert(oli);
                
                if(quoteLinesList.size() > 0 ){
                    database.delete(quoteLinesList);
                }
                system.debug('quoteId'+quoteId+'bundleProd'+bundleProd.Id+'bundleProd.List_Price__c'+bundleProd.List_Price__c+'totalsalePrice'+totalsalePrice);
                
            }
            updateSalesType(quoteId); //SFAL-494 / 10-08-2022 / Vikas Varshney
        }
        catch(exception e){
            system.debug('Error Message'+e.getMessage()+'@ line'+e.getLineNumber());
        }
    }
    //SFAL-379 / 27-07-2022 / Shubham Kumar / Initial Version
    //@description : This method is used for Updating Bundle , BLI's , QLI & PBE's when someone is adding more products to the existing bundle.
    @AuraEnabled
    public static void updateExistingBundle(string quoteId,string lineItems,String newBundleLIPrice,String bundleProdId){
        system.debug('quoteId------->'+quoteId+'lineItems'+lineItems+'newBundleLIPrice'+newBundleLIPrice);
        try{
            SBQQ__QuoteLine__c quoteLine = new  SBQQ__QuoteLine__c();
            if(quoteId != null){
                quoteLine = [Select id , name , SBQQ__Product__c  from SBQQ__QuoteLine__c where SBQQ__Quote__c =:quoteId AND SBQQ__Bundled__c = True][0];
                system.debug('quoteLine'+quoteLine);
            }
            system.debug('quoteLine.SBQQ__Product__c'+quoteLine.SBQQ__Product__c);
            if(quoteLine.SBQQ__Product__c != null){
                bundleProdId = quoteLine.SBQQ__Product__c;
            }
            
            List<productToSyncWrapper> datatoUPSERT = new List<productToSyncWrapper>();
            
            if(String.isNotBlank(bundleProdId)){
                Product2 bundleProd = [select Id,Name,List_Price__c,Sales_Price__c from product2 where id = :bundleProdId];
                list<Bundle_Line_Item__c> listofLineItems = new list< Bundle_Line_Item__c>();  
                List<productToSyncWrapper> bundleLineItems = new List<productToSyncWrapper>();
                datatoUPSERT = (List<productToSyncWrapper>)System.JSON.deserialize(lineItems, List<productToSyncWrapper>.class);
                
                if(datatoUPSERT.size() > 0){
                    for (productToSyncWrapper strProduct : datatoUPSERT) {
                        integer position = 1;
                        String productDoi = strProduct.PCMDOI +'||'+ bundleProd.Id;
                        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
                        lineItem.Product_Bundle_Parent__c = bundleProd.Id;
                        lineitem.Title__c  = strProduct.PCMProductName;
                        lineitem.Authors__c = strProduct.PCMAuthor;
                        lineitem.doi__c = strProduct.PCMDOI;
                        lineItem.Product_Doi__c =  productDoi;
                        lineItem.Product__c = bundleProd.Id;
                        lineItem.PriceUSD__c = strProduct.UnitPrice;
                        lineItem.Source__c = 'PCM';
                        lineItem.Type__c = strProduct.type;
                        lineItem.Valid__c = strProduct.PCMUUID != null && strProduct.PCMUUID != '' ? 'true' : 'false';
                        lineitem.uuid__c = strProduct.PCMUUID;
                        lineItem.mediaType__c = strProduct.format;
                        lineItem.lineItemStatus__c   = 'IsInsert';
                        lineItem.Publisher__c   = strProduct.publisher;
                        lineItem.Open_access__c = strProduct.openAccess != null && strProduct.openAccess != 'No' ? false : true;
                        if (string.isNotBlank(strProduct.publicationDate)){
                            lineItem.Publication_Date__c = date.valueOf(strProduct.publicationDate) ;
                        }
                        lineItem.Content_Position__c  = position++;//openAccess 
                        listofLineItems.add(lineItem);
                        position++;
                        
                    }
                }
                
                if(listofLineItems.size() > 0){
                    database.insert(listofLineItems);
                }
                
                //Updating the Product Details
                Integer UpdatedCountOFBLIs = [select count() from Bundle_Line_Item__c where Product_Bundle_Parent__c =:bundleProdId];
                //bundleProd.Name = UpdatedCountOFBLIs + 'Items';
                bundleProd.Sales_Price__c = bundleProd.Sales_Price__c + decimal.valueOf(newBundleLIPrice);
                bundleprod.List_Price__c = bundleProd.List_Price__c + decimal.valueOf(newBundleLIPrice);
                database.update(bundleProd);
                
                //Updating the QLI details
                quoteLine.SBQQ__ListPrice__c = bundleProd.List_Price__c;
                quoteLine.Original_List_Price__c = bundleProd.Sales_Price__c;
                try{
                    database.update(quoteLine);    
                }catch(exception e){
                    system.debug('Exception @'+e.getLineNumber() +'message'+e.getMessage());
                }
                
                
                //Updating the Related PBE's
                List <PricebookEntry> pbeList = [select UnitPrice,CurrencyIsoCode from Pricebookentry where product2id=:bundleProdId];
                for(PricebookEntry pb : pbeList){
                    pb.UnitPrice = bundleProd.List_Price__c;
                }
                database.update(pbeList);
            }
        }
        catch(exception e){
            system.debug('Error Message'+e.getMessage()+'@ line'+e.getLineNumber());
        }
    }
    
    //SFAL-147 / 27-04-2022 / Shubham Kumar / Initial Version
    //@description : This method is used for creating price Book Entries.
    @AuraEnabled
    public static String createPBE(String quoteRecId, String bundleProdId, Decimal unitPrice, Decimal totalsalePrice) {
        try{
            SBQQ__Quote__c quoteRec = new SBQQ__Quote__c();
            quoteRec = [Select CurrencyIsoCode from SBQQ__Quote__c where Id =: quoteRecId];
            PriceBookEntry pbeTobeReturned = new PriceBookEntry();
            
            List<Pricebook2> TandfpriceBookId;
            Id tfPricebookId; 
            
            List<Pricebook2> priceBookId;
            Id standardPriceBookId;        
            
            List<Pricebook2> TandfEbookpriceBookId;
            Id tfEbookPricebookId;
            
            if(test.isRunningTest()){
                standardPriceBookId=Test.getStandardPricebookId();
                tfPricebookId='01s0Y00000832dDQAQ';
                tfEbookPricebookId='01s0Y00000832cjQAA';          
            }else{
                priceBookId=[select Id from Pricebook2 where isStandard=true LIMIT 1];
                standardPriceBookId= priceBookId[0].id;
                
                TandfpriceBookId =[select Id from Pricebook2 where name='T&F Pricebook' LIMIT 1];
                tfPricebookId = TandfpriceBookId[0].id;
                
                TandfEbookpriceBookId =[select Id from Pricebook2 where name='T&F - eBooks Pricebook' LIMIT 1];
                tfEbookPricebookId = TandfEbookpriceBookId[0].id;            
            }
            
            PricebookEntry pbeInGBP;
            PricebookEntry pbeInUSD;
            if(quoteRec.CurrencyIsoCode != null && quoteRec.CurrencyIsoCode != ''){
                insertPricebookEntry(bundleProdId,quoteRec.CurrencyIsoCode,standardPriceBookId, unitPrice); 
                insertPricebookEntry(bundleProdId,quoteRec.CurrencyIsoCode,tfPricebookId, unitPrice);
                insertPricebookEntry(bundleProdId,quoteRec.CurrencyIsoCode,tfEbookPricebookId, totalsalePrice);
            }
            return 'Success';
        }
        catch(exception e){
            system.debug('Error Message'+e.getMessage());
            return null;
        }
    }
    //SFAL-147 / 27-04-2022 / Shubham Kumar / Initial Version
    //@description : This method is used for inserting Price book entry dynamically.
    private static PricebookEntry insertPricebookEntry(String parentProductID,String currencyIsoCode, Id standardPriceBookId, Decimal unitPrice){
        List<Product2> ProductName=[select name from Product2 where id=:parentProductID];
        String prdName=ProductName[0].name;
        system.debug(prdName);        
        PriceBookEntry pbe = new PricebookEntry(Pricebook2Id=standardPriceBookId,Product2Id=parentProductID, UnitPrice=unitPrice, UseStandardPrice=false,CurrencyIsoCode=currencyIsoCode, IsActive= true);
        insert pbe; 
        system.debug('pbe-Id'+pbe.Id); 
        return pbe;
    }
    
    //SFAL-148 / 27-04-2022 / Vikas Varshney / Initial Version
    //@description : This method is used for creating QLI
    //SFAL-148
    @AuraEnabled
    public static String createBespokeQLI(String quoteId, String bespokeProductId, Decimal totalsalePrice) {
        List<Product2> productList = new List<Product2>();
        System.debug('bespokeProductId===='+bespokeProductId);
        productList = [SELECT id, name, List_Price__c, hub_Id__c FROM Product2 WHERE id = :bespokeProductId LIMIT 1];
        System.debug('productList===='+productList);
        if (!productList.isEmpty() ) {
            SBQQ__QuoteLine__c bespokeQLI = new SBQQ__QuoteLine__c();
            bespokeQLI.SBQQ__Quote__c = quoteId;
            bespokeQLI.SBQQ__Product__c = productList[0].id;
            bespokeQLI.PCM_Product_Name__c = productList[0].Name;
            bespokeQLI.SBQQ__Quantity__c = 1;
            bespokeQLI.SBQQ__Bundled__c = true;
            bespokeQLI.PCM_UUID__c = productList[0].hub_Id__c;
            // bespokeQLI.SBQQ__ListPrice__c = totalsalePrice;
            // bespokeQLI.Original_List_Price__c = productList[0].List_Price__c;
            bespokeQLI.SBQQ__ListPrice__c = productList[0].List_Price__c;
            bespokeQLI.Original_List_Price__c = productList[0].List_Price__c;
            bespokeQLI.SBQQ__NetPrice__c = productList[0].List_Price__c;
            //bespokeQLI.Line_reference__c  = referenceNum;
            insert bespokeQLI;
            System.debug('bespokeQLI =====>' + bespokeQLI);
            
            return 'Success';
        } else {
            return 'Error';
        }
        
    }
    
    //SFAL-228 / 17-06-2022 / Vikas Varshney / Initial Version
    //@description : This method is used for getting bespoke collection exist on quote or not
    @AuraEnabled
    public static SBQQ__QuoteLine__c getDynamicBespokeQLI ( String quoteId ) {
        List<SBQQ__QuoteLine__c> bespokeQLIList = new List<SBQQ__QuoteLine__c>();
        
        //Checking quote line items for bespoke collection
        for ( SBQQ__QuoteLine__c qli : [ SELECT id, SBQQ__Product__c, SBQQ__Product__r.RecordType.Name, SBQQ__Product__r.Product_Type_Author_Facing__c, SBQQ__Product__r.Dynamic_Collection_Criteria__c FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c =:quoteId AND SBQQ__Product__r.RecordType.Name = 'T&F - BespokeCollection' ORDER By CreatedDate DESC LIMIT 1] ) { //AND SBQQ__Product__r.Product_Type_Author_Facing__c = 'Rule based'
            bespokeQLIList.add(qli);
            System.debug('***** Inside Bespoke QLI *****');
            return bespokeQLIList[0];
        }
        
        //SFAL-281, Checking quote line items for single titles
        if ( bespokeQLIList.isEmpty() ) {
            for ( SBQQ__QuoteLine__c qli : [ SELECT id, SBQQ__Product__c, SBQQ__Product__r.RecordType.Name, SBQQ__Product__r.Product_Type_Author_Facing__c FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c =:quoteId ORDER By CreatedDate DESC LIMIT 1] ) { //AND SBQQ__Product__r.Product_Type_Author_Facing__c = 'Rule based'
                bespokeQLIList.add(qli);
                System.debug('***** Inside Single Title QLI *****');
                return bespokeQLIList[0];
            }
        }
        
        return new SBQQ__QuoteLine__c();
    }
    
    //SFAL-494 / 10-08-2022 / Vikas Varshney / Initial Version
    //@description : This method is used to sync three Sales type(Single Title/Bespoke Collection/Collection) on quote and order
    @AuraEnabled
    public static void updateSalesType ( String quoteId ) {
        try {
            system.debug('quoteId575575' + quoteId);
            if ( String.isNotBlank(quoteId) ) {
                List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
                quoteList = [ SELECT id, SBQQ__Opportunity2__c, Quote_Sales_Type__c FROM SBQQ__Quote__c WHERE id =:quoteId ];
                system.debug('quoteList579' + quoteList);
                List<SBQQ__Quote__c> quoteUpdateList = new List<SBQQ__Quote__c>();
                //List<Order> orderUpdateList = new List<Order>();
                List<SBQQ__QuoteLine__c> qliList = new List<SBQQ__QuoteLine__c>();
                qliList = [ SELECT id, SBQQ__Product__c, SBQQ__Product__r.RecordType.Name FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c =:quoteId ];
                system.debug('qliListqliList584' + qliList);
                Integer qliThresholdVal = getCustomSettingData(quoteId).threshHold;
                System.debug('qliThresholdVal =====>' + qliThresholdVal);
                system.debug('qliList[0].SBQQ__Product__c' + qliList[0].SBQQ__Product__c);
                system.debug('qliList[0].SBQQ__Product__r.RecordType.Name.equalsIgnoreCase(T&F - BespokeCollection)' + qliList[0].SBQQ__Product__r.RecordType.Name);
                if ( !qliList.isEmpty() && qliList[0].SBQQ__Product__c != Null && qliList[0].SBQQ__Product__r.RecordType.Name.equalsIgnoreCase('T&F - BespokeCollection') ) {
                    SBQQ__Quote__c quoteUpdate = new SBQQ__Quote__c();
                    quoteUpdate.id = quoteId;
                    quoteUpdate.Quote_Sales_Type__c = 'Bespoke Collection';
                    quoteUpdateList.add(quoteUpdate);
                } else if ( !qliList.isEmpty() && qliList[0].SBQQ__Product__c != Null && qliList[0].SBQQ__Product__r.RecordType.Name.equalsIgnoreCase('T&F - Collection') ) { //&& qliList.size() > qliThresholdVal
                    SBQQ__Quote__c quoteUpdate = new SBQQ__Quote__c();
                    quoteUpdate.id = quoteId;
                    quoteUpdate.Quote_Sales_Type__c = 'Collection';
                    quoteUpdateList.add(quoteUpdate);
                }/* else if ( !qliList.isEmpty() && qliList[0].SBQQ__Product__c != Null && qliList[0].SBQQ__Product__r.RecordType.Name.equalsIgnoreCase('T&F - Collection') && qliList.size() < qliThresholdVal ) {
SBQQ__Quote__c quoteUpdate = new SBQQ__Quote__c();
quoteUpdate.id = quoteId;
quoteUpdate.Quote_Sales_Type__c = 'Single Title';
quoteUpdateList.add(quoteUpdate);
}*/ else if ( !qliList.isEmpty() && qliList[0].SBQQ__Product__c != Null && !qliList[0].SBQQ__Product__r.RecordType.Name.equalsIgnoreCase('T&F - Collection') && !qliList[0].SBQQ__Product__r.RecordType.Name.equalsIgnoreCase('T&F - BespokeCollection') ) {
    SBQQ__Quote__c quoteUpdate = new SBQQ__Quote__c();
    quoteUpdate.id = quoteId;
    quoteUpdate.Quote_Sales_Type__c = 'Single Title';
    quoteUpdateList.add(quoteUpdate);
} else if ( qliList.isEmpty() ) {
    SBQQ__Quote__c quoteUpdate = new SBQQ__Quote__c();
    quoteUpdate.id = quoteId;
    quoteUpdate.Quote_Sales_Type__c = Null;
    quoteUpdateList.add(quoteUpdate);
}
                system.debug('quoteList[0].Quote_Sales_Type__c' + quoteUpdateList);               
                //Checking old value of sales type on quote and it should not have same value in case of update
                if ( quoteList[0].Quote_Sales_Type__c != Null && quoteList[0].Quote_Sales_Type__c.equalsIgnoreCase(quoteUpdateList[0].Quote_Sales_Type__c) ) {
                    quoteUpdateList.clear();
                }
                
                /*if ( !quoteList.isEmpty() && quoteList[0].SBQQ__Opportunity2__c != Null && !quoteUpdateList.isEmpty() ) {
List<Order> orderList = new List<Order>();
orderList = [ SELECT id, Order_Sales_Type__c FROM Order WHERE OpportunityId =:quoteList[0].SBQQ__Opportunity2__c ORDER BY LastModifiedDate Desc LIMIT 1 ];

if ( !orderList.isEmpty() ) {
orderUpdateList.add( new Order( id = orderList[0].id, Order_Sales_Type__c = quoteUpdateList[0].Quote_Sales_Type__c ) );
}
}

if ( !orderUpdateList.isEmpty() ) {
update orderUpdateList;
System.debug('orderUpdateList =====>' + orderUpdateList);
}*/
                
                if ( !quoteUpdateList.isEmpty() ) {
                    update quoteUpdateList;
                    System.debug('quoteUpdateList =====>' + quoteUpdateList);
                }
            }
        } catch ( Exception ex ) {
            System.debug('***** Line *****' + ex.getLineNumber());
            System.debug('Exception =====>' + ex.getMessage());
        }
    }
    
    @AuraEnabled
    public Static String syncDataToQuoteLine(string quoteId,string DataToSync,string DataToDelete,string currencyCode){
        system.debug('DataToSyncDataToSync' + DataToSync);
        List<productToSyncWrapper> datatoUPSERT = new List<productToSyncWrapper>();
        List<string> delDataList = new List<String>();
        delDataList = (List<String>)System.JSON.deserialize(DataToDelete, List<String>.class);
        datatoUPSERT = (List<productToSyncWrapper>)System.JSON.deserialize(DataToSync, List<productToSyncWrapper>.class);
        system.debug('quoteId'+quoteId);
        system.debug('delDataList'+delDataList);
        system.debug('datatoUPSERT'+datatoUPSERT);
        
        List<SBQQ__QuoteLine__c> oppProductList = new List<SBQQ__QuoteLine__c>();
        for(productToSyncWrapper asdw : datatoUPSERT){
            SBQQ__QuoteLine__c oli = new SBQQ__QuoteLine__c();
            if(asdw.quoteLineRecId != null){
                oli.Id = asdw.quoteLineRecId;
                system.debug('asdw.isDuplicate'+asdw.isDuplicate);
                //SFAL-20 Duplicate-icon check added by shubham 
                if(asdw.isDuplicate == true){
                    Oli.Is_Duplicate__c = true;
                }else{
                    Oli.Is_Duplicate__c = false;
                }
            }
            else{
                oli.SBQQ__Quote__c = quoteId;
                if(asdw.type !='collection' ){
                    oli.SBQQ__Product__c = asdw.SalesforceProductId; 
                }else{
                    oli.SBQQ__Product__c = asdw.sku;
                }
                oli.SBQQ__PricebookEntryId__c = asdw.SalesforcePriceBookEntry;
                oli.PCM_ISBN__c = asdw.PCMISBN;
                oli.PCM_UUID__c = asdw.PCMUUID;
                oli.PCM_Author_Name__c = asdw.PCMAuthor;
                oli.PCM_Product_Name__c = asdw.PCMProductName;
                oli.PCM_DOI__c = asdw.PCMDOI;
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
            oli.Original_List_Price__c = asdw.OriginalListPrice;
            oli.Line_reference__c  = asdw.PONumber;
            
            //oli.SBQQ__Bundled__c = true;
            //oli.TF_IsBundleActive__c = true;
            oppProductList.add(oli);
        }
        system.debug('oppProductList'+oppProductList.size());
        system.debug('oppProductList'+oppProductList);
        if(oppProductList.Size()>0){
            system.debug('oppProductList '+oppProductList);
            UPSERT oppProductList;
        }
        //Added by shubham kumar 
        //@Description : this will delete the product2 (Bespoke collection) and Bundle Line Items along with QLI
        if(delDataList.size()>0){
            system.debug('delDataList'+delDataList);
            Database.delete(delDataList);
        }
        system.debug('quoteId'+quoteId);
        List<SBQQ__QuoteLine__c> quoteLinesList = new List<SBQQ__QuoteLine__c>();
        quoteLinesList = [Select Id,Original_List_Price__c,PCM_UUID__c,SBQQ__Quote__c,SBQQ__Product__r.RecordType.Name, Licence_Type__c,PCM_DOI__c,PCM_ISBN__c,PCM_Product_Name__c,PCM_Author_Name__c,SBQQ__PricebookEntryId__c,SBQQ__Quote__r.CurrencyIsoCode,Line_reference__c,CurrencyIsoCode,SBQQ__Product__c,SBQQ__Product__r.Name,SBQQ__Product__r.ISBN__c,SBQQ__Product__r.Lead_Author_Editor__c,SBQQ__Quantity__c,SBQQ__ListPrice__c from SBQQ__QuoteLine__c where SBQQ__Quote__c =: quoteId];
        List<productToSyncWrapper> qliDataToComponent = new List<productToSyncWrapper>();
        system.debug('quoteLinesList'+quoteLinesList);
        system.debug('quoteLinesList'+quoteLinesList.size());
        for(SBQQ__QuoteLine__c oli : quoteLinesList){
            productToSyncWrapper osdw = new productToSyncWrapper();
            osdw.quoteLineRecId = oli.Id;
            osdw.SalesforceProductId = oli.SBQQ__Product__c;
            osdw.SalesforceProductName = oli.SBQQ__Product__r.Name;
            osdw.SalesforcePriceBookEntry = oli.SBQQ__PricebookEntryId__c;
            osdw.PCMISBN = oli.PCM_ISBN__c;
            osdw.PCMUUID = oli.PCM_UUID__c;
            osdw.PCMProductName = oli.PCM_Product_Name__c;
            osdw.PCMAuthor = oli.PCM_Author_Name__c;
            System.debug('record type name ========='+ oli.SBQQ__Product__c);
            if(!(oli.SBQQ__Product__r.RecordType.Name.equalsIgnoreCase('T&F - BespokeCollection'))){
                System.debug('=====inside if===');
                osdw.UnitPrice = oli.SBQQ__ListPrice__c;
                osdw.OriginalListPrice = oli.Original_List_Price__c;
            }
            osdw.PONumber = oli.Line_reference__c;
            osdw.PCMDOI = oli.PCM_DOI__c;
            qliDataToComponent.add(osdw);
        }
        
        updateSalesType(quoteId); //SFAL-494 / 10-08-2022 / Vikas Varshney
        
        return (JSON.serialize(qliDataToComponent));
    }
    
    @AuraEnabled
    public static string fetchQuoteLines(string quoteId){
        List<SBQQ__QuoteLine__c> quoteLinesList = new List<SBQQ__QuoteLine__c>();
        quoteLinesList = [Select Id,SBQQ__Bundled__c ,SBQQ__Product__r.Sales_Price__c,SBQQ__Product__r.List_Price__c,SBQQ__Product__r.Product_Type_Author_Facing__c,TF_IsBundleActive__c , Original_List_Price__c,SBQQ__Quote__c,PCM_DOI__c,PCM_UUID__c,PCM_ISBN__c,PCM_Product_Name__c,PCM_Author_Name__c,SBQQ__PricebookEntryId__c,SBQQ__Quote__r.CurrencyIsoCode,Line_reference__c,CurrencyIsoCode,SBQQ__Product__c,SBQQ__Product__r.Name,SBQQ__Product__r.ISBN__c,SBQQ__Product__r.Lead_Author_Editor__c,SBQQ__Quantity__c,SBQQ__ListPrice__c from SBQQ__QuoteLine__c where SBQQ__Quote__c =: quoteId];
        List<productToSyncWrapper> qliDataToComponent = new List<productToSyncWrapper>();
        for(SBQQ__QuoteLine__c oli : quoteLinesList){
            productToSyncWrapper osdw = new productToSyncWrapper();
            osdw.quoteLineRecId = oli.Id; 
            osdw.PCMUUID = oli.PCM_UUID__c;
            osdw.SalesforceProductId = oli.SBQQ__Product__c;
            osdw.SalesforceProductName = oli.SBQQ__Product__r.Name;
            osdw.SalesforceProductISBN = oli.SBQQ__Product__r.ISBN__c;
            //String msg = isLeapYear ? 'It is a leap year.' : 'It is not a leap year.';
            osdw.isBespokeQLI = oli.SBQQ__Product__r.Product_Type_Author_Facing__c == 'Rule based' ? false : true;
            osdw.SalesforcePriceBookEntry = oli.SBQQ__PricebookEntryId__c;
            osdw.PCMISBN = oli.PCM_ISBN__c;
            if(oli.SBQQ__Bundled__c == true){
                osdw.PCMProductName = oli.SBQQ__Product__r.Name;
                osdw.OriginalListPrice = oli.SBQQ__Product__r.List_Price__c ;
                osdw.UnitPrice = oli.SBQQ__Product__r.Sales_Price__c ;
                list<Bundle_Line_Item__c> BundleLineItems = [Select id,name,Title__c ,Authors__c,doi__c,Source__c,Type__c,Valid__c,uuid__c,mediaType__c ,lineItemStatus__c ,Publisher__c ,Open_access__c,Publication_Date__c  from Bundle_Line_Item__c where Product_Bundle_Parent__c  = :oli.SBQQ__Product__c];
                osdw.BundleLineItems = BundleLineItems;
            }else{
                osdw.PCMProductName = oli.PCM_Product_Name__c;
                osdw.OriginalListPrice = oli.Original_List_Price__c;
                osdw.UnitPrice = oli.SBQQ__ListPrice__c;
            }
            osdw.PCMAuthor = oli.PCM_Author_Name__c;
            osdw.PONumber = oli.Line_reference__c;
            osdw.PCMDOI = oli.PCM_DOI__c;
            osdw.Bundled = oli.SBQQ__Bundled__c;
            osdw.isBundleActive = oli.TF_IsBundleActive__c;
            system.debug('osdw '+osdw);
            qliDataToComponent.add(osdw);
        }
        system.debug('fetchQuoteLines '+qliDataToComponent);
        return (JSON.serialize(qliDataToComponent));
    }
    
    //shalini: Changes start to use pcmImplicitFilter SAL-4494
    @AuraEnabled
    public static string getOppAndSapDetails(String quoteId)
    {
        String countryForRestrictionCheck;
        String isoCodeForRestrictionCheck;
        List<Opportunity> oppList = new List<Opportunity>();
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
                    isoCodeForRestrictionCheck = countryList.get(0).Country_2__c;
            }
        }
        system.debug('isoCodeForRestrictionCheck '+isoCodeForRestrictionCheck);
        return isoCodeForRestrictionCheck;
    }
    //shalini: Changes end to use pcmImplicitFilter SAL-4494
    public class wrapPricebkEntProduct{
        @AuraEnabled
        public PricebookEntry PricebkEntProduct{get;set;}
        @AuraEnabled
        public String productId{get;set;}
        //SFAL-52 added by radhikay banerjee
        @AuraEnabled
        public decimal OriginalListPrice1{get;set;}
    }
    
    public class productToSyncWrapper{
        //SFAL-66 added by shubham kumar
        @AuraEnabled
        public string PCMUUID;
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
        public string SalesforceProductISBN;
        @AuraEnabled
        public String SalesforcePriceBookEntry;
        @AuraEnabled
        public String quoteLineRecId;
        @AuraEnabled
        public List<wrapPricebkEntProduct> SFDCProdList;
        @AuraEnabled
        public List<String> SFDCLicenceData;
        //SFAL-20 added by shubham kumar
        @AuraEnabled
        public Boolean isBespokeQLI;
        @AuraEnabled
        public Boolean isDuplicate;
        @AuraEnabled
        public string type;
        @AuraEnabled
        public string format;
        @AuraEnabled
        public string status;
        @AuraEnabled
        public string publicationDate;
        @AuraEnabled
        public string openAccess;
        @AuraEnabled
        public string publisher;
        //SFAL-52 added by radhikay banerjee
        @AuraEnabled
        public decimal OriginalListPrice;
        @AuraEnabled
        public Boolean Bundled;
        @AuraEnabled
        public Boolean isBundleActive;
        @AuraEnabled
        public list< Bundle_Line_Item__c> BundleLineItems;
        // added by rohit dua
        @AuraEnabled
        public string sku;
        public string priceBYOGBP;
        public string priceBYOUSD;
    }
    
    public class EntitlementDataWrapper{
        public String productId{get;set;}
        public String packageVersion{get;set;}
        public String licenseId{get;set;}
        public String packageId{get;set;}
        public String status{get;set;}
        public String customerId{get;set;}
    }
    
    public class customSettingWrapper{
        @AuraEnabled
        public Integer threshHold;
        @AuraEnabled
        public String recordTypeId;
        @AuraEnabled
        public String bespokeBusinessId;
        @AuraEnabled
        public String salesType;
    }
    
    public class ProductUUIDs {
        public List<String> productIds;
    }
    
}