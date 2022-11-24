/*
* CAB Ticket #: CHG0037688
* Changes: lines 72 - 90, related to  CHG0037688
*/

@isTest
private class zTEST_TF_QuoteAPIService {

    private static final String baseUrl = Url.getSalesforceBaseUrl().toExternalForm();
    
    private static String getRandomString() {
        Blob b = Crypto.GenerateAESKey(256);
        String h = EncodingUtil.base64Encode(b);
        return h.remove(' ').remove('/').remove('+').remove('=').substring(0, 25);      
    }

    private static void createTestDataToUpdateInvoiceNumber(){
        String uniqueId = getRandomString();
        String priceBookName = 'T&F CPQ Price Book 2017';
        Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        
        Quote_Service_Settings__c customSetting = new Quote_Service_Settings__c(Name = 'Informa Plc', Product_Family__c = 'Journals-Author Side Charges', CPQ_PriceBook__c = priceBookName);
        insert customSetting;        
            
        Account accObject = new Account(Name = 'Test Account',RecordTypeId = TFAccountsRecordTypeId,Type = 'Customer',Manual_Check__c = True); 
        insert accObject;
        
        Prepay_Accounts__c pp = new Prepay_Accounts__c (name='Test PP',AccountName__c=accObject.id);
        insert pp;
            
        Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
        Product2 prodObject = new Product2(Name = 'Test Product', 
                                    RecordTypeId = TFProductsRecordTypeId,
                                    CPQ_Category__c = 'Technology',
                                    Article_Type__c = 'Letter',
                                    Sales_Organization__c = 'NA',
                                    Open_Access_Category__c = 'Open',
                                    ProductCode = 'XYZ',
                                    Readership_Level__c = 'Test',
                                    IsActive = true,
                                    Family = 'Journals-Author Side Charges');  
        insert prodObject;                 

        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> priceBEList = new List<PricebookEntry>();
        PricebookEntry priceBE1 = new PricebookEntry(CurrencyIsoCode = 'USD',IsActive = True, Pricebook2Id = standardPricebookId, Product2Id = prodObject.Id,UnitPrice = 100.00);                                  
        priceBEList.add(priceBE1);                              
        insert priceBEList;
        
        Pricebook2 priceBook2 = new Pricebook2(Name = priceBookName, IsActive = True);
        insert priceBook2;
        
        List<PricebookEntry> priceBEList2 = new List<PricebookEntry>();
        PricebookEntry priceBE2 = new PricebookEntry(CurrencyIsoCode = 'USD',IsActive = True, Pricebook2Id = priceBook2.Id, Product2Id = prodObject.Id,UnitPrice = 100.00);                                                           
        priceBEList2.add(priceBE2);                              
        insert priceBEList2;
                                                
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(
                Payer_Account__c = accObject.Id, SBQQ__ExpirationDate__c = date.today()+20, Use_Prepay_Budget__c = true,
                Article_Acceptance_Status__c = 'Accepted',Primary_Contact_s_email_id__c='test@test.com',randomstring__c = uniqueId,
            Order_Hub_Number__c='ODR881153');       
        insert quoteObject;
        
        SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteObject.Id, SBQQ__Product__c = prodObject.Id, Discount_Rules_Applied__c = 'Prepay');
        insert quoteLineObject;                  
      }

    private static testmethod void testUpdateInvoiceNumber() {
        createTestDataToUpdateInvoiceNumber();
        List<SBQQ__Quote__c> quotes = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c, randomstring__c FROM SBQQ__Quote__c LIMIT 1];                        
        
        SBQQ__Quote__c quoteObject = quotes[0];
        quoteObject.Author_Status__c = 'Accepted';
        Update quoteObject;
        
        TF_QuoteAPIService.UpdateInvoiceNumberRequest request = new TF_QuoteAPIService.UpdateInvoiceNumberRequest();
        
        request.orderHubNumber = 'ODR881153';   
        request.invoiceNumber = '123';
        String requestJSON = JSON.serialize(request);
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/updateInvoiceNumber';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        TF_QuoteAPIService.doPost();
        
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuoteResponse response = (TF_QuoteAPIService.QuoteResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuoteResponse.class);
        system.assertEquals(response.success,true);
    }     

    private static testmethod void testUpdateInvoiceNumber_InvalidOrderHubNumber() {
        createTestDataToUpdateInvoiceNumber();
        List<SBQQ__Quote__c> quotes = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c, randomstring__c FROM SBQQ__Quote__c LIMIT 1];                        
        
        SBQQ__Quote__c quoteObject = quotes[0];
        quoteObject.Author_Status__c = 'Accepted';
        Update quoteObject;
        
        TF_QuoteAPIService.UpdateInvoiceNumberRequest request = new TF_QuoteAPIService.UpdateInvoiceNumberRequest();
        
        request.orderHubNumber = 'ODR881159';   
        request.invoiceNumber = '123';
        String requestJSON = JSON.serialize(request);
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/updateInvoiceNumber';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        TF_QuoteAPIService.doPost();
        
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuoteResponse response = (TF_QuoteAPIService.QuoteResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuoteResponse.class);
        system.assertEquals(response.success,false);
    }

    private static testmethod void testUpdateInvoiceNumber_InvalidInvoiceNumber() {
        createTestDataToUpdateInvoiceNumber();
        List<SBQQ__Quote__c> quotes = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c, randomstring__c FROM SBQQ__Quote__c LIMIT 1];                        
        
        SBQQ__Quote__c quoteObject = quotes[0];
        quoteObject.Author_Status__c = 'Accepted';
        Update quoteObject;
        TF_QuoteAPIService.UpdateInvoiceNumberRequest request = new TF_QuoteAPIService.UpdateInvoiceNumberRequest();        
        request.orderHubNumber = 'ODR881153';   
        request.invoiceNumber = '';
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/updateInvoiceNumber';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        TF_QuoteAPIService.doPost();
        
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuoteResponse response = (TF_QuoteAPIService.QuoteResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuoteResponse.class);
        system.assertEquals(response.success,false);
    }
    
    private static void createCountrySampleData() {
        System.runAs(new User(ID = UserInfo.getUserId())) {
            String priceBookName = 'T&F CPQ Price Book 2017';
            Quote_Service_Settings__c customSetting = new Quote_Service_Settings__c(Name = 'Informa Plc', Product_Family__c = 'Journals-Author Side Charges', CPQ_PriceBook__c = priceBookName);
            insert customSetting;
            
            Country__c country = new Country__c(Name = 'Georgia',Applicable_List__c = 'Band B',EIFL__c = true,EIFL_Type__c = 'Type 1',
                                                Country_2__c = 'GE',Country_3__c = 'GEO',Preferred_currency__c = 'USD',
                                                Description__c='Georgia',Enabled__c=true);    
            insert country;
        }    
    }
    
    private static void sampleDataForCPQDiscountConfigurationsCountryWaiver(){
        System.runAs(new User(ID = UserInfo.getUserId())) {
            String priceBookName = 'T&F CPQ Price Book 2017';
            Quote_Service_Settings__c customSetting = new Quote_Service_Settings__c(Name = 'Informa Plc', Product_Family__c = 'Journals-Author Side Charges', CPQ_PriceBook__c = priceBookName);
            insert customSetting; 
            
            Id promoCodeRecTypeId = Schema.SObjectType.CPQ_Discount_Configuration__c.getRecordTypeInfosByName().get('T&F - Country Waiver').getRecordTypeId();      
            
            List<CPQ_Discount_Configuration__c> records = new List<CPQ_Discount_Configuration__c>();
            records.add(new CPQ_Discount_Configuration__c(RecordTypeId = promoCodeRecTypeId,
                                                                                                      Discount_Type__c = '% Discount',
                                                                                                      Discount_Value_Percentage__c = 100,
                                                                                                      Product_Code__c = 'CFAI',
                                                                                                      Start_Date__c = date.today(),
                                                                                                      End_Date__c = date.today()+20,
                                                                                                      Discount_Display_Name__c = 'Taylor & Francis Waiver Program',
                                                                                                      Country_Applicable_List__c = 'Band A',
                                                                                                      EIFL__c = false,
                                                                                                      EIFL_Type__c = '',
                                                                                                      Product_Open_Access_Category__c = 'Open',
                                                                                                      Active__c = True));
            records.add(new CPQ_Discount_Configuration__c(RecordTypeId = promoCodeRecTypeId,
                                                                                                      Discount_Type__c = '% Discount',
                                                                                                      Discount_Value_Percentage__c = 50,
                                                                                                      Product_Code__c = 'CFAI',
                                                                                                      Start_Date__c = date.today(),
                                                                                                      End_Date__c = date.today()+20,
                                                                                                      Discount_Display_Name__c = 'Taylor & Francis Waiver Program',
                                                                                                      Country_Applicable_List__c = 'Band B',
                                                                                                      EIFL__c = false,
                                                                                                      EIFL_Type__c = '',
                                                                                                      Product_Open_Access_Category__c = 'Open',
                                                                                                      Active__c = True));
            records.add(new CPQ_Discount_Configuration__c(RecordTypeId = promoCodeRecTypeId,
                                                                                                      Discount_Type__c = '% Discount',
                                                                                                      Discount_Value_Percentage__c = 50,
                                                                                                      Product_Code__c = 'CFAI',
                                                                                                      Start_Date__c = date.today(),
                                                                                                      End_Date__c = date.today()+20,
                                                                                                      Discount_Display_Name__c = 'Taylor & Francis Waiver Program',
                                                                                                      Country_Applicable_List__c = '',
                                                                                                      EIFL__c = true,
                                                                                                      EIFL_Type__c = 'Type 1',
                                                                                                      Product_Open_Access_Category__c = 'Open',
                                                                                                      Active__c = True));
            records.add(new CPQ_Discount_Configuration__c(RecordTypeId = promoCodeRecTypeId,
                                                                                                      Discount_Type__c = '% Discount',
                                                                                                      Discount_Value_Percentage__c = 100,
                                                                                                      Product_Code__c = 'CFAI',
                                                                                                      Start_Date__c = date.today(),
                                                                                                      End_Date__c = date.today()+20,
                                                                                                      Discount_Display_Name__c = 'Taylor & Francis Waiver Program',
                                                                                                      Country_Applicable_List__c = '',
                                                                                                      EIFL__c = true,
                                                                                                      EIFL_Type__c = 'Type 2',
                                                                                                      Product_Open_Access_Category__c = 'Open',
                                                                                                      Active__c = True));
            insert records;            
        }
    }
    
    private static void sampleDataForCPQDiscountConfigurations(){
        System.runAs(new User(ID = UserInfo.getUserId())) {
            String priceBookName = 'T&F CPQ Price Book 2017';
            Quote_Service_Settings__c customSetting = new Quote_Service_Settings__c(Name = 'Informa Plc', Product_Family__c = 'Journals-Author Side Charges', CPQ_PriceBook__c = priceBookName);
            insert customSetting; 
            
            Id promoCodeRecTypeId = Schema.SObjectType.CPQ_Discount_Configuration__c.getRecordTypeInfosByName().get('T&F - PromoCode').getRecordTypeId();       
            CPQ_Discount_Configuration__c CPQDiscountConfigObject = new CPQ_Discount_Configuration__c(RecordTypeId = promoCodeRecTypeId,
                                                                                                      Discount_Type__c = '% Discount',
                                                                                                      Discount_Value_Percentage__c = 50,
                                                                                                      Promocode__c = 'MAK-2018-USJFISD',
                                                                                                      Product_Code__c = 'GACR',
                                                                                                      Start_Date__c = date.today(),
                                                                                                      End_Date__c = date.today()+20,
                                                                                                      Discount_Category__c = 'Ad hoc',
                                                                                                      Discount_Display_Name__c = 'Coupon code',
                                                                                                      Single_Use__c = True,
                                                                                                      Active__c = True); 
            insert CPQDiscountConfigObject;
        }
    }

    private static testmethod void checkIsCountryDiscountAvailableInput() {
        sampleDataForCPQDiscountConfigurationsCountryWaiver();
        List<CPQ_Discount_Configuration__c> cpqDiscConfig = [SELECT id,Promocode__c,Product_Code__c,Start_Date__c,End_Date__c FROM CPQ_Discount_Configuration__c];        
        TF_QuoteAPIService.isCountryDiscountAvailableRequest request = new TF_QuoteAPIService.isCountryDiscountAvailableRequest();
        request.productCode = 'CFAI';
        request.country = '';
        
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();        
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/isCountryDiscountAvailable';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIService.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuotePromoCodeResponse response = (TF_QuoteAPIService.QuotePromoCodeResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuotePromoCodeResponse.class);
        
        System.assertEquals('Invalid country name or product code.', response.errorMessage);
        System.assertEquals(false, response.success);  
    }
 
    private static testmethod void checkIsCountryDiscountAvailable() {
        //createCountrySampleData();
        sampleDataForCPQDiscountConfigurationsCountryWaiver();

        Country__c country = new Country__c(Name = 'Georgia',Applicable_List__c = 'Band B',EIFL__c = true,EIFL_Type__c = 'Type 1',
                                            Country_2__c = 'GE',Country_3__c = 'GEO',Preferred_currency__c = 'USD',
                                            Description__c='Georgia',Enabled__c=true);    
        insert country;        
        
        Country__c selectedCountry = [SELECT Name,Applicable_List__c,EIFL__c,EIFL_Type__c FROM Country__c WHERE Name = 'Georgia' LIMIT 1];
        List<CPQ_Discount_Configuration__c> cpqDiscConfig = [SELECT id,Promocode__c,Product_Code__c,Start_Date__c,End_Date__c FROM CPQ_Discount_Configuration__c];        
        TF_QuoteAPIService.isCountryDiscountAvailableRequest request = new TF_QuoteAPIService.isCountryDiscountAvailableRequest();
        request.productCode = 'CFAI';
        request.country = 'Georgia';
        
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();        
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/isCountryDiscountAvailable';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIService.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuotePromoCodeResponse response = (TF_QuoteAPIService.QuotePromoCodeResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuotePromoCodeResponse.class);
        
        System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);  
    }
 
    private static testmethod void checkIsCountryDiscountAvailableBandA() {
        sampleDataForCPQDiscountConfigurationsCountryWaiver();

        Country__c country = new Country__c(Name = 'Afghanistan',Applicable_List__c = 'Band A',EIFL__c = false,EIFL_Type__c = '',
                                            Country_2__c = 'AF',Country_3__c = 'AFG',Preferred_currency__c = 'USD',
                                            Description__c='Afghanistan',Enabled__c=true);    
        insert country;        
        
        Country__c selectedCountry = [SELECT Name,Applicable_List__c,EIFL__c,EIFL_Type__c FROM Country__c WHERE Name = 'Afghanistan' LIMIT 1];
        List<CPQ_Discount_Configuration__c> cpqDiscConfig = [SELECT id,Promocode__c,Product_Code__c,Start_Date__c,End_Date__c FROM CPQ_Discount_Configuration__c];        
        TF_QuoteAPIService.isCountryDiscountAvailableRequest request = new TF_QuoteAPIService.isCountryDiscountAvailableRequest();
        request.productCode = 'CFAI';
        request.country = 'Afghanistan';
        
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();        
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/isCountryDiscountAvailable';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIService.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuotePromoCodeResponse response = (TF_QuoteAPIService.QuotePromoCodeResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuotePromoCodeResponse.class);
        
        System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);  
    }
 
    private static testmethod void checkIsCountryDiscountAvailableBandB() {
        sampleDataForCPQDiscountConfigurationsCountryWaiver();

        Country__c country = new Country__c(Name = 'Bhutan',Applicable_List__c = 'Band B',EIFL__c = false,EIFL_Type__c = '',
                                            Country_2__c = 'BT',Country_3__c = 'BTN',Preferred_currency__c = 'USD',
                                            Description__c='Bhutan',Enabled__c=true);    
        insert country;        
        
        Country__c selectedCountry = [SELECT Name,Applicable_List__c,EIFL__c,EIFL_Type__c FROM Country__c WHERE Name = 'Bhutan' LIMIT 1];
        List<CPQ_Discount_Configuration__c> cpqDiscConfig = [SELECT id,Promocode__c,Product_Code__c,Start_Date__c,End_Date__c FROM CPQ_Discount_Configuration__c];        
        TF_QuoteAPIService.isCountryDiscountAvailableRequest request = new TF_QuoteAPIService.isCountryDiscountAvailableRequest();
        request.productCode = 'CFAI';
        request.country = 'Bhutan';
        
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();        
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/isCountryDiscountAvailable';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIService.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuotePromoCodeResponse response = (TF_QuoteAPIService.QuotePromoCodeResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuotePromoCodeResponse.class);
        
        System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);  
    }

    private static testmethod void checkIsCountryDiscountAvailableNoDiscountCountry() {
        sampleDataForCPQDiscountConfigurationsCountryWaiver();

        Country__c country = new Country__c(Name = 'Czech Republic',Applicable_List__c = '',EIFL__c = false,EIFL_Type__c = '',
                                            Country_2__c = 'CZ',Country_3__c = 'CZE',Preferred_currency__c = 'USD',
                                            Description__c='Czech Republic',Enabled__c=true);    
        insert country;        
        
        Country__c selectedCountry = [SELECT Name,Applicable_List__c,EIFL__c,EIFL_Type__c FROM Country__c WHERE Name = 'Czech Republic' LIMIT 1];
        List<CPQ_Discount_Configuration__c> cpqDiscConfig = [SELECT id,Promocode__c,Product_Code__c,Start_Date__c,End_Date__c FROM CPQ_Discount_Configuration__c];        
        TF_QuoteAPIService.isCountryDiscountAvailableRequest request = new TF_QuoteAPIService.isCountryDiscountAvailableRequest();
        request.productCode = 'CFAI';
        request.country = 'Czech Republic';
        
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();        
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/isCountryDiscountAvailable';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIService.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuotePromoCodeResponse response = (TF_QuoteAPIService.QuotePromoCodeResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuotePromoCodeResponse.class);
        
        System.assertEquals('Discount Not Available.', response.errorMessage);
        System.assertEquals(false, response.success);  
    }
    
    private static testmethod void checkPromoCode() {
        sampleDataForCPQDiscountConfigurations();
        List<CPQ_Discount_Configuration__c> cpqDiscConfig = [SELECT id,Promocode__c,Product_Code__c,Start_Date__c,End_Date__c FROM CPQ_Discount_Configuration__c];        
        TF_QuoteAPIService.QuotePromoCodeRequest request = new TF_QuoteAPIService.QuotePromoCodeRequest();
        request.productCode = cpqDiscConfig[0].Product_Code__c;
        request.promoCode = cpqDiscConfig[0].Promocode__c;
        request.countryCode = 'IND';
        request.payerType = 'Self';
        
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();        
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/checkPromoCode';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIService.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuotePromoCodeResponse response = (TF_QuoteAPIService.QuotePromoCodeResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuotePromoCodeResponse.class);
        
        System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);  
    }

    private static testmethod void checkPromoCodeInvalidPromoOrProduct() {
        sampleDataForCPQDiscountConfigurations();
        List<CPQ_Discount_Configuration__c> cpqDiscConfig = [SELECT id,Promocode__c,Product_Code__c,Start_Date__c,End_Date__c FROM CPQ_Discount_Configuration__c];        
        TF_QuoteAPIService.QuotePromoCodeRequest request = new TF_QuoteAPIService.QuotePromoCodeRequest();
        request.productCode = cpqDiscConfig[0].Product_Code__c;
        request.promoCode = 'TEST';
        request.countryCode = 'IND';
        request.payerType = 'Self';
        
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();        
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/checkPromoCode';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIService.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuotePromoCodeResponse response = (TF_QuoteAPIService.QuotePromoCodeResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuotePromoCodeResponse.class);
        
        System.assertEquals('Invalid promo code / invalid product code.', response.errorMessage);  
    }
    
    private static testmethod void checkPromoCodeCheckInputs() {
        sampleDataForCPQDiscountConfigurations();
        List<CPQ_Discount_Configuration__c> cpqDiscConfig = [SELECT id,Promocode__c,Product_Code__c,Start_Date__c,End_Date__c FROM CPQ_Discount_Configuration__c];        
        TF_QuoteAPIService.QuotePromoCodeRequest request = new TF_QuoteAPIService.QuotePromoCodeRequest();
        request.productCode = cpqDiscConfig[0].Product_Code__c;
        request.promoCode = null;
        request.countryCode = 'IND';
        request.payerType = 'Self';
        
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();        
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/checkPromoCode';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIService.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuotePromoCodeResponse response = (TF_QuoteAPIService.QuotePromoCodeResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuotePromoCodeResponse.class);
        
        System.assertEquals('Invalid input request.', response.errorMessage);
        System.assertEquals(false, response.success);  
    }
    
    private static testmethod void checkPromoCodeIsInactivePromoCode() {
        String priceBookName = 'T&F CPQ Price Book 2017';
        Quote_Service_Settings__c customSetting = new Quote_Service_Settings__c(Name = 'Informa Plc', Product_Family__c = 'Journals-Author Side Charges', CPQ_PriceBook__c = priceBookName);
        insert customSetting; 
        
        Id promoCodeRecTypeId = Schema.SObjectType.CPQ_Discount_Configuration__c.getRecordTypeInfosByName().get('T&F - PromoCode').getRecordTypeId();       
        CPQ_Discount_Configuration__c CPQDiscountConfigObject = new CPQ_Discount_Configuration__c(RecordTypeId = promoCodeRecTypeId,
                                                                                                  Discount_Type__c = '% Discount',
                                                                                                  Discount_Value_Percentage__c = 50,
                                                                                                  Promocode__c = 'MAK-2018-USJFISD',
                                                                                                  Product_Code__c = 'GACR',
                                                                                                  Start_Date__c = date.today(),
                                                                                                  End_Date__c = date.today()+20,
                                                                                                  Discount_Category__c = 'Ad hoc',
                                                                                                  Discount_Display_Name__c = 'Coupon code',
                                                                                                  Single_Use__c = True,
                                                                                                  Active__c = false); 
        insert CPQDiscountConfigObject;
        List<CPQ_Discount_Configuration__c> cpqDiscConfig = [SELECT id,Promocode__c,Product_Code__c,Start_Date__c,End_Date__c FROM CPQ_Discount_Configuration__c];        
        TF_QuoteAPIService.QuotePromoCodeRequest request = new TF_QuoteAPIService.QuotePromoCodeRequest();
        request.productCode = cpqDiscConfig[0].Product_Code__c;
        request.promoCode = cpqDiscConfig[0].Promocode__c;
        request.countryCode = 'IND';
        request.payerType = 'Self';
        
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();        
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/checkPromoCode';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIService.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuotePromoCodeResponse response = (TF_QuoteAPIService.QuotePromoCodeResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuotePromoCodeResponse.class);
        
        System.assertEquals('Not an active promo code.', response.errorMessage);
        System.assertEquals(false, response.success);  
    }

    private static testmethod void checkPromoCodeIsPromoCodeIsExpired() {
        String priceBookName = 'T&F CPQ Price Book 2017';
        Quote_Service_Settings__c customSetting = new Quote_Service_Settings__c(Name = 'Informa Plc', Product_Family__c = 'Journals-Author Side Charges', CPQ_PriceBook__c = priceBookName);
        insert customSetting; 
        
        Id promoCodeRecTypeId = Schema.SObjectType.CPQ_Discount_Configuration__c.getRecordTypeInfosByName().get('T&F - PromoCode').getRecordTypeId();       
        CPQ_Discount_Configuration__c CPQDiscountConfigObject = new CPQ_Discount_Configuration__c(RecordTypeId = promoCodeRecTypeId,
                                                                                                  Discount_Type__c = '% Discount',
                                                                                                  Discount_Value_Percentage__c = 50,
                                                                                                  Promocode__c = 'MAK-2018-USJFISD',
                                                                                                  Product_Code__c = 'GACR',
                                                                                                  Start_Date__c = date.today()+1,
                                                                                                  End_Date__c = date.today()+20,
                                                                                                  Discount_Category__c = 'Ad hoc',
                                                                                                  Discount_Display_Name__c = 'Coupon code',
                                                                                                  Single_Use__c = True,
                                                                                                  Active__c = true); 
        insert CPQDiscountConfigObject;
        List<CPQ_Discount_Configuration__c> cpqDiscConfig = [SELECT id,Promocode__c,Product_Code__c,Start_Date__c,End_Date__c FROM CPQ_Discount_Configuration__c];        
        TF_QuoteAPIService.QuotePromoCodeRequest request = new TF_QuoteAPIService.QuotePromoCodeRequest();
        request.productCode = cpqDiscConfig[0].Product_Code__c;
        request.promoCode = cpqDiscConfig[0].Promocode__c;
        request.countryCode = 'IND';
        request.payerType = 'Self';
        
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();        
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/checkPromoCode';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIService.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuotePromoCodeResponse response = (TF_QuoteAPIService.QuotePromoCodeResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuotePromoCodeResponse.class);
        
        System.assertEquals('Promo code has expired.', response.errorMessage);
        System.assertEquals(false, response.success);  
    }

    private static testmethod void checkPromoCode_Adhoc() {
        String priceBookName = 'T&F CPQ Price Book 2017';
        Quote_Service_Settings__c customSetting = new Quote_Service_Settings__c(Name = 'Informa Plc', Product_Family__c = 'Journals-Author Side Charges', CPQ_PriceBook__c = priceBookName);
        insert customSetting; 
        
        Id promoCodeRecTypeId = Schema.SObjectType.CPQ_Discount_Configuration__c.getRecordTypeInfosByName().get('T&F - PromoCode').getRecordTypeId();       
        CPQ_Discount_Configuration__c CPQDiscountConfigObject = new CPQ_Discount_Configuration__c(RecordTypeId = promoCodeRecTypeId,
                                                                                                  Discount_Type__c = '% Discount',
                                                                                                  Discount_Value_Percentage__c = 50,
                                                                                                  Promocode__c = 'MAK-2018-USJFISD',
                                                                                                  Product_Code__c = 'GACR',
                                                                                                  Start_Date__c = date.today()+1,
                                                                                                  End_Date__c = date.today()+20,
                                                                                                  Discount_Category__c = 'Ad hoc',
                                                                                                  Discount_Display_Name__c = 'Coupon code',
                                                                                                  Single_Use__c = True,
                                                                                                  Active__c = true); 
        insert CPQDiscountConfigObject;
        List<CPQ_Discount_Configuration__c> cpqDiscConfig = [SELECT id,Promocode__c,Product_Code__c,Start_Date__c,End_Date__c FROM CPQ_Discount_Configuration__c];        
        TF_QuoteAPIService.QuotePromoCodeRequest request = new TF_QuoteAPIService.QuotePromoCodeRequest();
        request.productCode = cpqDiscConfig[0].Product_Code__c;
        request.promoCode = cpqDiscConfig[0].Promocode__c;
        request.countryCode = 'IND';
        request.payerType = 'Organization';
        
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();        
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/checkPromoCode';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIService.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuotePromoCodeResponse response = (TF_QuoteAPIService.QuotePromoCodeResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuotePromoCodeResponse.class);
        
        System.assertEquals('Promo code has expired.', response.errorMessage);
        System.assertEquals(false, response.success);  
    }
    
    private static testmethod void expiresQuoteTest() {
        createSampleData();
        List<SBQQ__Quote__c> quotes = [SELECT id,doi__c,randomstring__c,Name,Use_Prepay_Budget__c,SBQQ__Account__c FROM SBQQ__Quote__c];        
        String s = getRandomString();
        SBQQ__Quote__c quoteObject = quotes[0];
        quoteObject.SBQQ__Status__c = 'Draft';
        quoteObject.randomstring__c = s;
        Update quoteObject;
        
        TF_QuoteAPIService.QuoteExpireRequest request = new TF_QuoteAPIService.QuoteExpireRequest();

        request.quoteUniqueId = quotes[0].randomstring__c;
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
    
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/expiresQuote/';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
                
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIService.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuoteDetailResponse response = (TF_QuoteAPIService.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuoteDetailResponse.class);
        response.success = true; 
        //System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);
    }
    
    private static testmethod void expiresQuoteInvalidTest() {
        createSampleData();
        List<SBQQ__Quote__c> quotes = [SELECT id,doi__c,Name,Use_Prepay_Budget__c,SBQQ__Account__c, randomstring__c FROM SBQQ__Quote__c];
        TF_QuoteAPIService.QuoteExpireRequest request = new TF_QuoteAPIService.QuoteExpireRequest();
        request.quoteUniqueId = quotes[0].randomstring__c;
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/expiresQuote/';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
                
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIService.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuoteDetailResponse response = (TF_QuoteAPIService.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuoteDetailResponse.class);
        
        System.assertNotEquals(null, response.errorMessage); 
        System.assertEquals(false, response.success);
    } 
    
    private static testmethod void updateQuoteDetailsValidQuoteTest() {
        createSampleData();
        List<SBQQ__Quote__c> quotes = [SELECT id,doi__c,Name,Use_Prepay_Budget__c,SBQQ__Account__c, randomstring__c FROM SBQQ__Quote__c];
        TF_QuoteAPIService.QuoteUpdateRequest request = new TF_QuoteAPIService.QuoteUpdateRequest();
        
        String s = getRandomString();
        SBQQ__Quote__c quoteObject = quotes[0];
        quoteObject.randomstring__c = s;
        Update quoteObject;
        
        request.doi = '12345';
        request.canInvoice = true;
        request.billingStreet = 'Billing Street';
        request.billingStreet2 = 'Billing Street2';
        request.billingCity = 'Billing City';
        request.billingState = 'Billing State';
        request.billingPostalCode = '12345';
        request.sameAsBilling = true; 
        request.shipToContact = '12345';
        request.shipToOrganization = 'Org';
        request.shipToStreet2 = 'Ship To Street2';
        request.shipToStreet = 'Ship To Street';
        request.shipToState = 'Ship To State';
        request.shipToPostalCode = '12345';
        request.shipToCountry = 'India';
        request.shipToCity = 'Ship To City';
        request.vatNumber = '12345';
        request.purchaseOrderNumber = '12345';
        request.payercontactphonenumber = '12345';
        request.payerContactName = 'Contact Name';
        request.payerOrganizationDepartment = 'ABC';
        request.payerOrganizationCampus = 'Camp';
        request.taxRegistrationNumber = '12345';
        request.taxCategory = 'HU0';
        request.billingBPNumber  = '123';
        request.shippingBPNumber  ='536';
        request.billingAddressID  = '456';
        request.shippingAddressID  = '789';
        
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/updateQuoteDetails/'+quotes[0].randomstring__c;  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
                
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIService.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuoteDetailResponse response = (TF_QuoteAPIService.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuoteDetailResponse.class);
     response.success = true;
        //System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);
    }
    
    private static testmethod void updateQuoteDetailsInValidQuoteTest() {
        createSampleData();
        
        List<SBQQ__Quote__c> quotes = [SELECT id,doi__c,Name,Use_Prepay_Budget__c,SBQQ__Account__c, randomstring__c FROM SBQQ__Quote__c];
        TF_QuoteAPIService.QuoteUpdateRequest request = new TF_QuoteAPIService.QuoteUpdateRequest();
        request.doi = '12345';
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/updateQuoteDetails/';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
                
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIService.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuoteDetailResponse response = (TF_QuoteAPIService.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuoteDetailResponse.class);
 
        System.assertNotEquals('QuoteId in query parameter is mandatory as /updateQuoteDetails/UniqueQuoteId.', response.errorMessage);
        System.assertEquals(false, response.success);
    }
    
    private static testmethod void authorAcceptsQuoteTest() {
        createSampleData();
        
        List<SBQQ__Quote__c> quotes = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c, randomstring__c FROM SBQQ__Quote__c];

        // -- Create a request object -- //
        TF_QuoteAPIService.QuoteRequest request = new TF_QuoteAPIService.QuoteRequest();
        request.quoteUniqueId = quotes[0].randomstring__c;
        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/authorAcceptsQuote';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
                
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIService.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuoteDetailResponse response = (TF_QuoteAPIService.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuoteDetailResponse.class);
 
        System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);
    }

     private static testmethod void authorRejectsQuoteTest() {
        createSampleData();
        
        List<SBQQ__Quote__c> quotes = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c, randomstring__c FROM SBQQ__Quote__c];

        // -- Create a request object -- //
        TF_QuoteAPIService.QuoteRequest request = new TF_QuoteAPIService.QuoteRequest();
        request.quoteUniqueId = quotes[0].randomstring__c;
        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/authorAcceptsQuote';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
                
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIService.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuoteDetailResponse response = (TF_QuoteAPIService.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuoteDetailResponse.class);
 
        System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);        
     }

        
    private static testmethod void getQuoteByParamsTest() {
        createSampleData();
        List<SBQQ__Quote__c> quotes = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c FROM SBQQ__Quote__c];

        // -- Create a request object -- //
        TF_QuoteAPIService.QuoteRequest request = new TF_QuoteAPIService.QuoteRequest();
        //request.submissionId = '123123';
        request.doi = '12345';
        
        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/getQuoteByParams';
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIService.doPost();
        Test.stopTest();

        String responeJSON = RestContext.response.responseBody.toString();
        //TF_QuoteAPIService.QuoteDetailResponse response = (TF_QuoteAPIService.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuoteDetailResponse.class);
        List<TF_QuoteAPIService.QuoteDetailResponse> response = (List<TF_QuoteAPIService.QuoteDetailResponse>)JSON.deserialize(responeJSON, List<TF_QuoteAPIService.QuoteDetailResponse>.class);
        System.assertEquals(response.size(), 0);                  
    }  
    
     private static testmethod void getQuoteByParamsInvalidTest() {
        createSampleData();
        List<SBQQ__Quote__c> quotes = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c FROM SBQQ__Quote__c];

        // -- Create a request object -- //
        TF_QuoteAPIService.QuoteRequest request = new TF_QuoteAPIService.QuoteRequest();
        request.submissionId = '';
        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/getQuoteByParams';
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIService.doPost();
        Test.stopTest();

        String responeJSON = RestContext.response.responseBody.toString();
        //TF_QuoteAPIService.QuoteDetailResponse response = (TF_QuoteAPIService.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuoteDetailResponse.class);
        List<TF_QuoteAPIService.QuoteDetailResponse> response = (List<TF_QuoteAPIService.QuoteDetailResponse>)JSON.deserialize(responeJSON, List<TF_QuoteAPIService.QuoteDetailResponse>.class);
        System.assertEquals('At least one parameter is mandatory', response[0].errorMessage);
        System.assertEquals(false, response[0].success);          
    }    

    private static testmethod void getQuoteByUniqueIDTest() {
        createSampleData();
        List<SBQQ__Quote__c> quotes = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c,randomstring__c FROM SBQQ__Quote__c];

        // -- Create a request object -- //
        TF_QuoteAPIService.QuoteRequest request = new TF_QuoteAPIService.QuoteRequest();
        request.quoteUniqueId = quotes[0].randomstring__c;
        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/getQuoteByUniqueID';
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIService.doPost();
        Test.stopTest();

        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuoteDetailResponse response = (TF_QuoteAPIService.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuoteDetailResponse.class);
 
        System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);        
        
    }    

    private static testmethod void getQuoteTest() {
        createSampleData();

        List<SBQQ__Quote__c> quotes = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c FROM SBQQ__Quote__c];

        // -- Create a request object -- //
        TF_QuoteAPIService.QuoteRequest request = new TF_QuoteAPIService.QuoteRequest();
        request.quoteId = quotes[0].id;
        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/getQuote';
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIService.doPost();
        Test.stopTest();

        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuoteDetailResponse response = (TF_QuoteAPIService.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuoteDetailResponse.class);
 
        System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);        
                
    }

    private static testmethod void generateQuoteSelfPayTest() {
        createSampleData();

        // -- Create a request object -- //
        TF_QuoteAPIService.GenerateQuoteRequest request = getSampleQuoteCreationRequest();

        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/generateQuote';
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIService.doPost();
        Test.stopTest();

        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuoteResponse response = (TF_QuoteAPIService.QuoteResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuoteResponse.class);
 
        System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);      

    }
    private static void createTestDataUpdateCSDApproval(){
        String uniqueId = getRandomString();
        String priceBookName = 'T&F CPQ Price Book 2017';

            Quote_Service_Settings__c customSetting = new Quote_Service_Settings__c(Name = 'Informa Plc', Product_Family__c = 'Journals-Author Side Charges', CPQ_PriceBook__c = priceBookName);
            insert customSetting;
        Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            
        Account accObject = new Account(Name = 'Test Account',
                                        RecordTypeId = TFAccountsRecordTypeId,
                                        Type = 'Customer',
                                        Manual_Check__c = True); 
        insert accObject;
        Prepay_Accounts__c pp = new Prepay_Accounts__c (name='Test PP',AccountName__c=accObject.id);
            insert pp;
            
        Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
        Product2 prodObject = new Product2(Name = 'Test Product', 
                                    RecordTypeId = TFProductsRecordTypeId,
                                    CPQ_Category__c = 'Technology',
                                    Article_Type__c = 'Letter',
                                    Sales_Organization__c = 'NA',
                                    Open_Access_Category__c = 'Open',
                                    ProductCode = 'XYZ',
                                    Readership_Level__c = 'Test',
                                    IsActive = true,
                                    Family = 'Journals-Author Side Charges');  
        insert prodObject;                 

        String standardPricebookId = Test.getStandardPricebookId();

        List<PricebookEntry> priceBEList = new List<PricebookEntry>();
        
        PricebookEntry priceBE1 = new PricebookEntry(CurrencyIsoCode = 'USD',IsActive = True, Pricebook2Id = standardPricebookId, Product2Id = prodObject.Id,
                                                                                                                UnitPrice = 100.00);                                  
        priceBEList.add(priceBE1);                              
        insert priceBEList;
        
        Pricebook2 priceBook2 = new Pricebook2(Name = priceBookName, IsActive = True);
                    insert priceBook2;
        
        List<PricebookEntry> priceBEList2 = new List<PricebookEntry>();
                    PricebookEntry priceBE2 = new PricebookEntry(CurrencyIsoCode = 'USD',IsActive = True, Pricebook2Id = priceBook2.Id, Product2Id = prodObject.Id,
                                                                                                                UnitPrice = 100.00);    
                                                        
        priceBEList2.add(priceBE2);                              
        insert priceBEList2;
                                                
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(
                Payer_Account__c = accObject.Id, 
                SBQQ__ExpirationDate__c = date.today()+20, 
                Use_Prepay_Budget__c = true,
                Article_Acceptance_Status__c = 'Accepted',
                                    Primary_Contact_s_email_id__c='test@test.com',randomstring__c = uniqueId);       
        insert quoteObject;
        
        SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(
                    SBQQ__Quote__c = quoteObject.Id, 
                    SBQQ__Product__c = prodObject.Id, 
                    Discount_Rules_Applied__c = 'Prepay');
                        insert quoteLineObject;  
                        
      }
      
       private static testmethod void UpdateCSDApprovalStatusRequestTestInvalid() {
        
        createTestDataUpdateCSDApproval();
        
        List<SBQQ__Quote__c> quotes = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c, randomstring__c FROM SBQQ__Quote__c LIMIT 1];                        
        
        
        SBQQ__Quote__c quoteObject = quotes[0];
        quoteObject.Author_Status__c = 'Accepted';
        Update quoteObject;
        
        //request without csdapprovalstatus
        TF_QuoteAPIService.UpdateCSDApprovalStatusRequest request = new TF_QuoteAPIService.UpdateCSDApprovalStatusRequest();
        
        //request.quoteNumber = quotes[0].Name; 
        request.quoteUniqueId = quotes[0].randomstring__c;   
        request.csdApprovalStatus = '';
        String requestJSON = JSON.serialize(request);
    
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
                
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/csdUpdateStatus';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
                
        RestContext.request = req;
        RestContext.response = res;
    
        
        TF_QuoteAPIService.doPost();
        
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuoteResponse response = (TF_QuoteAPIService.QuoteResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuoteResponse.class);
        
        
        SBQQ__Quote__c quoteObj = [SELECT Id, Name, SBQQ__Status__c, CSD_Approval_Status__c from SBQQ__Quote__c];
        system.debug(quoteObj);
        system.debug([select id, quote_approval_status__c, quote__c from quote_approval__c]);
        
        system.assertEquals(response.success,False);
        system.assertEquals(response.errorMessage,'Invalid quote number or quote status');
    }
    
    private static testmethod void UpdateCSDApprovalStatusRequestTestNotPrepay() {
        
        createTestDataUpdateCSDApproval();
        
        List<SBQQ__Quote__c> quotes = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c, randomstring__c FROM SBQQ__Quote__c LIMIT 1];                        
        
        
        SBQQ__Quote__c quoteObject = quotes[0];
        
        //request without csdapprovalstatus
        TF_QuoteAPIService.UpdateCSDApprovalStatusRequest request = new TF_QuoteAPIService.UpdateCSDApprovalStatusRequest();
        
        //request.quoteNumber = quotes[0].Name;
        request.quoteUniqueId = quotes[0].randomstring__c;
        request.csdApprovalStatus = 'Approved';
        String requestJSON = JSON.serialize(request);
    
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
                
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/csdUpdateStatus';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
                
        RestContext.request = req;
        RestContext.response = res;
    
        
        TF_QuoteAPIService.doPost();
        
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuoteResponse response = (TF_QuoteAPIService.QuoteResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuoteResponse.class);
        
        
        SBQQ__Quote__c quoteObj = [SELECT Id, Name, SBQQ__Status__c, CSD_Approval_Status__c from SBQQ__Quote__c];
        system.debug(quoteObj);
        system.debug([select id, quote_approval_status__c, quote__c from quote_approval__c]);
        
        system.assertEquals(response.success,False);
        system.assertEquals(response.errorMessage,'Author should accept the quote');
    }


      private static testmethod void UpdateCSDApprovalStatusRequestTestSuccess() {
        
        createTestDataUpdateCSDApproval();
        
        List<SBQQ__Quote__c> quotes = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c, randomstring__c FROM SBQQ__Quote__c LIMIT 1];                        
        
        
        SBQQ__Quote__c quoteObject = quotes[0];
        quoteObject.Author_Status__c = 'Accepted';
        Update quoteObject;
        
        //request without csdapprovalstatus
        TF_QuoteAPIService.UpdateCSDApprovalStatusRequest request = new TF_QuoteAPIService.UpdateCSDApprovalStatusRequest();
        
        //request.quoteNumber = quotes[0].Name;
        request.quoteUniqueId = quotes[0].randomstring__c;
        request.csdApprovalStatus = 'Approved';
        String requestJSON = JSON.serialize(request);
    
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
                
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/csdUpdateStatus';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
                
        RestContext.request = req;
        RestContext.response = res;
    
        test.starttest();
            TF_QuoteAPIService.doPost();
        test.stoptest();
        
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuoteResponse response = (TF_QuoteAPIService.QuoteResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuoteResponse.class);
        system.assertEquals(response.success,True);
            
        SBQQ__Quote__c quoteObj = [SELECT Id, Name, SBQQ__Status__c, CSD_Approval_Status__c from SBQQ__Quote__c];
        system.debug(quoteObj);
        system.debug([select id, quote_approval_status__c, quote__c from quote_approval__c]);
        
        
        System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);        
        
     
        
    }

    private static testmethod void generateQuoteOrganizationPayTest() {
         createSampleData();
        // -- Create a request object -- //
        TF_QuoteAPIService.GenerateQuoteRequest request = getSampleQuoteCreationRequest();
        request.payerType = 'Organization';
        //request.payerContactName = 'Org Contact name';
        //request.payerEmailID = 'payer@org.com';
        //request.payerOrganizationName = 'Alex Organization';
    ///request.payerOrganizationID = [SELECT ID FROM Account limit 1].Id;
        //request.leadAuthorOrganizationName = 'Lead Org';
        
        request.payerType = 'Third party';
        request.payerContactName = 'Org Contact name';
        request.payerEmailID = 'payer@org.com';
        request.payerOrganizationName = 'Alex Organization';
        request.leadAuthorOrganizationName = 'Lead Org';
        
        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/generateQuote';
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIService.doPost();
        Test.stopTest();

        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuoteResponse response = (TF_QuoteAPIService.QuoteResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuoteResponse.class);
 
        System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);           
    }
        
    private static testmethod void generateQuoteThirdPartyOrganizationPayTest() {
         createSampleData();
        // -- Create a request object -- //
        TF_QuoteAPIService.GenerateQuoteRequest request = getSampleQuoteCreationRequest();
        request.payerType = 'Third party';
        request.payerContactName = 'Org Contact name';
        request.payerEmailID = 'payer@org.com';
        request.payerOrganizationName = 'Alex Organization';
        request.leadAuthorOrganizationName = 'Lead Org';
    
        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/generateQuote';
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIService.doPost();
        Test.stopTest();

        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuoteResponse response = (TF_QuoteAPIService.QuoteResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuoteResponse.class);
 
        System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);           
    } 

    private static testmethod void generateQuoteThirdPartyPayTest() {
         createSampleData();
        // -- Create a request object -- //
        TF_QuoteAPIService.GenerateQuoteRequest request = getSampleQuoteCreationRequest();
        request.payerType = 'Third party';
        request.payerContactName = 'Org Contact name';
        request.payerEmailID = 'payer@org.com';
        request.payerOrganizationName = 'Alex Organization';

        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/generateQuote';
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIService.doPost();
        Test.stopTest();

        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuoteResponse response = (TF_QuoteAPIService.QuoteResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuoteResponse.class);
 
        System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);           
    } 
    
    
    private static testmethod void getListPriceTest() {
        createSampleData();
        TF_QuoteAPIService.ListPriceRequest request = new TF_QuoteAPIService.ListPriceRequest();
        request.productCode = 'XYZ';
        request.articleType = 'Letter';
        request.countryCode = 'US';
        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
                
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/getListPrice';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
                
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIService.doPost();
        Test.stopTest();    
        
        String responeJSON = RestContext.response.responseBody.toString();  
        TF_QuoteAPIService.ListPriceResponse response = (TF_QuoteAPIService.ListPriceResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.ListPriceResponse.class);
        System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success); 
        System.assertEquals('USD', response.currencyIsoCode);
        System.assertEquals(100.00, response.value);
                
    }

    private static testmethod void getListPriceTest_Invalid() {
        createSampleData();
        TF_QuoteAPIService.ListPriceRequest request = new TF_QuoteAPIService.ListPriceRequest();
        request.productCode = 'ABC';
        request.articleType = 'Letter';
        request.countryCode = 'US';
        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
                
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/getListPrice';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
                
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIService.doPost();
        Test.stopTest();    
        
        String responeJSON = RestContext.response.responseBody.toString();  
        TF_QuoteAPIService.ListPriceResponse response = (TF_QuoteAPIService.ListPriceResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.ListPriceResponse.class);
        System.assertNotEquals(null, response.errorMessage);
        System.assertEquals(false, response.success); 
        System.assertEquals(null, response.currencyIsoCode);
        System.assertEquals(null, response.value);
                
    }
    
    private static testmethod void recalculateQuoteSelfPayChanges() {
        createSampleData();
        List<SBQQ__Quote__c> quotes = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c, randomstring__c FROM SBQQ__Quote__c];
 
        TF_QuoteAPIService.QuoteReCalculationRequest request = new TF_QuoteAPIService.QuoteReCalculationRequest();
        request.quoteUniqueId = quotes[0].randomstring__c;
        TF_QuoteAPIService.GenerateQuoteRequest quoteChangeRequest = getSampleQuoteCreationRequest();
        quoteChangeRequest.billingCountry = 'UK';
        request.recalculationRequest = quoteChangeRequest;

        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/recalculateQuote';
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIService.doPost();
        Test.stopTest();

        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuoteDetailResponse response = (TF_QuoteAPIService.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuoteDetailResponse.class);
 
        //System.assertEquals(null, response.errorMessage);
        //System.assertEquals(true, response.success);           

    }


    private static testmethod void recalculateQuoteOrganizationPayChanges() {
        createSampleData();
        List<SBQQ__Quote__c> quotes = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c, randomstring__c FROM SBQQ__Quote__c];
 
        TF_QuoteAPIService.QuoteReCalculationRequest request = new TF_QuoteAPIService.QuoteReCalculationRequest();
        request.quoteUniqueId = quotes[0].randomstring__c;
        TF_QuoteAPIService.GenerateQuoteRequest quoteChangeRequest = getSampleQuoteCreationRequest();
        quoteChangeRequest.payerType = 'Organization';
        quoteChangeRequest.payerContactName = 'Org Contact name';
        quoteChangeRequest.payerEmailID = 'payer@org.com';
        quoteChangeRequest.payerOrganizationName = 'Alex Organization';      
        
        request.recalculationRequest = quoteChangeRequest;  

        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/recalculateQuote';
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIService.doPost();
        Test.stopTest();

        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuoteDetailResponse response = (TF_QuoteAPIService.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuoteDetailResponse.class);
 
        //System.assertEquals(null, response.errorMessage);
        //System.assertEquals(true, response.success);           

    }

    private static testmethod void recalculateQuoteThirPartyOrganizationPayChanges() {
        createSampleData();
        List<SBQQ__Quote__c> quotes = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c, randomstring__c FROM SBQQ__Quote__c];
 
        TF_QuoteAPIService.QuoteReCalculationRequest request = new TF_QuoteAPIService.QuoteReCalculationRequest();
        request.quoteUniqueId = quotes[0].randomstring__c;
        TF_QuoteAPIService.GenerateQuoteRequest quoteChangeRequest = getSampleQuoteCreationRequest();

        quoteChangeRequest.payerType = 'Third party Organization';
        quoteChangeRequest.payerContactName = 'Org Contact name';
        quoteChangeRequest.payerEmailID = 'payer@org.com';
        quoteChangeRequest.payerOrganizationName = 'Alex Organization'; 
        
        request.recalculationRequest = quoteChangeRequest;  

        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/recalculateQuote';
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIService.doPost();
        Test.stopTest();

        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuoteDetailResponse response = (TF_QuoteAPIService.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuoteDetailResponse.class);
 
        //System.assertEquals(null, response.errorMessage);
        //System.assertEquals(true, response.success);           

    }
 
     private static testmethod void recalculateQuoteThirPartyPayChanges() {
        createSampleData();
        List<SBQQ__Quote__c> quotes = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c, randomstring__c FROM SBQQ__Quote__c];
 
        TF_QuoteAPIService.QuoteReCalculationRequest request = new TF_QuoteAPIService.QuoteReCalculationRequest();
        request.quoteUniqueId = quotes[0].randomstring__c;
        TF_QuoteAPIService.GenerateQuoteRequest quoteChangeRequest = getSampleQuoteCreationRequest();

        quoteChangeRequest.payerType = 'Third party';
        quoteChangeRequest.payerContactName = 'Org Contact name';
        quoteChangeRequest.payerEmailID = 'payer@org.com';
        quoteChangeRequest.payerOrganizationName = 'Alex Organization';
        
        request.recalculationRequest = quoteChangeRequest;  

        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/recalculateQuote';
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIService.doPost();
        Test.stopTest();

        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuoteDetailResponse response = (TF_QuoteAPIService.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuoteDetailResponse.class);
        
        //System.assertEquals(null, response.errorMessage);
        //System.assertEquals(true, response.success);           

    }               

    private static testmethod void isPrePayAccountTest() {
        createSampleData();
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            Account accT = new Account (Name = 'TestCompany',Billing_Street__c='Sample', Billing_City__c='mycity', 
                                        Billing_State__c='state', Billing_ZIP__c='112345', recordtypeid = TFAccountsRecordTypeId );
            insert accT;
            Prepay_Accounts__c pp = new Prepay_Accounts__c (name='Test PP',AccountName__c=accT.id);
            insert pp;
            Contact conT = new Contact (AccountId = accT.id, FirstName = 'Test', LastName = 'Test',
                                        Email='abc@test.com', Phone='4111141111');
            insert conT;
            //opportunity o = new opportunity(Accountid=accT.id,StageName='Closed Won',CloseDate=system.today(),
            //                                Name ='samplename',Probability=100);
            //insert o;
            
        List<SBQQ__Quote__c> quotes = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c FROM SBQQ__Quote__c];
        
        //String mockRequestBody = '{"quoteId" : "'+quotes[0].Id+'"}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
                
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/isPrePayAccount/' + accT.id;  
        //req.requestBody = Blob.valueOf(mockRequestBody);
        req.httpMethod = 'GET';
                
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        TF_QuoteAPIService.doGet();
        Test.stopTest();

    }
    
    private static testmethod void searchRinggoldIdTest() {
        createSampleData();
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            Affiliation_Types__c affTypes = new Affiliation_Types__c(Name ='NESLI');
        	insert affTypes;
        	
        	Account accT = new Account (Name = 'TestCompany',Billing_Street__c='Sample', Billing_City__c='mycity', 
                                        Billing_State__c='state',Ringgold_Account_ID__c='3057', Billing_ZIP__c='112345', recordtypeid = TFAccountsRecordTypeId );
            insert accT;
        	Account_Affiliation__c accAffliation = new Account_Affiliation__c(Affiliation_Type__c =affTypes.Id,CurrencyIsoCode ='GBP - British Pound',Account__c=accT.Id);
            Prepay_Accounts__c pp = new Prepay_Accounts__c (name='Test PP',AccountName__c=accT.id);
            insert pp;
            Contact conT = new Contact (AccountId = accT.id, FirstName = 'Test', LastName = 'Test',
                                        Email='abc@test.com', Phone='4111141111');
            insert conT;
            //opportunity o = new opportunity(Accountid=accT.id,StageName='Closed Won',CloseDate=system.today(),
            //                                Name ='samplename',Probability=100);
            //insert o;
            Id promoCodeRecTypeId = Schema.SObjectType.CPQ_Discount_Configuration__c.getRecordTypeInfosByName().get('T&F - PromoCode').getRecordTypeId();       
            CPQ_Discount_Configuration__c CPQDiscountConfigObject = new CPQ_Discount_Configuration__c(RecordTypeId = promoCodeRecTypeId,
                                                                                                  Discount_Type__c = '% Discount',
                                                                                                  Discount_Value_Percentage__c = 50,
                                                                                                  Promocode__c = 'MAK-2018-USJFISD',
                                                                                                  Product_Code__c = 'GACR',
                                                                                                  Start_Date__c = date.today()+1,
                                                                                                  End_Date__c = date.today()+20,
                                                                                                  Discount_Category__c = 'Ad hoc',
                                                                                                  Discount_Display_Name__c = 'Coupon code',
                                                                                                  Single_Use__c = True,
                                                                                                  Ringgold_IDs__c='3057',
                                                                                                  Account__c=accT.Id,
                                                                                                  Active__c = true); 
        insert CPQDiscountConfigObject;
        
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
                
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/3057' ;  
        //req.requestBody = Blob.valueOf(mockRequestBody);
        req.httpMethod = 'GET';
                
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        TF_QuoteAPIService.doGet();
        Test.stopTest();
        
     //   String responeJSON =RestContext.response.responseBody.toString();
       // TF_QuoteAPIService.QuoteAccountResponse response = (TF_QuoteAPIService.QuoteAccountResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuoteAccountResponse.class);
      //  system.assertEquals(response.success,true);
        

    }
         
    private static void createSampleData() {
        System.runAs(new User(ID = UserInfo.getUserId())) {
            String priceBookName = 'T&F CPQ Price Book 2017';
            Quote_Service_Settings__c customSetting = new Quote_Service_Settings__c(Name = 'Informa Plc', Product_Family__c = 'Journals-Author Side Charges', CPQ_PriceBook__c = priceBookName);
            insert customSetting;
            
            Country__c country = new Country__c(Country_2__c = 'US',
                Name = 'USA',
                Preferred_currency__c = 'USD');    
            insert country;
            
            
                        
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            
            Account accObject = new Account(Name = 'Test Account',
                                                                        RecordTypeId = TFAccountsRecordTypeId,
                                                                        Type = 'Customer'); 
            insert accObject;
                
            Contact conObject = new Contact(
                AccountId = accObject.Id,
                FirstName = 'test',
                LastName = 'test');      
            insert conObject;
            
            Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
            Product2 prodObject = new Product2(Name = 'Test Product', 
                                        RecordTypeId = TFProductsRecordTypeId,
                                        CPQ_Category__c = 'Technology',
                                        Article_Type__c = 'Letter',
                                        Sales_Organization__c = 'NA',
                                        Open_Access_Category__c = 'Open',
                    ProductCode = 'XYZ',
                                        Readership_Level__c = 'Test',
                    IsActive = true,
                    Family = 'Journals-Author Side Charges');  
            insert prodObject;                 

                        String standardPricebookId = Test.getStandardPricebookId();
            
                        List<PricebookEntry> priceBEList = new List<PricebookEntry>();
            
            PricebookEntry priceBE1 = new PricebookEntry(CurrencyIsoCode = 'USD',IsActive = True, Pricebook2Id = standardPricebookId, Product2Id = prodObject.Id,
                                                                                                                    UnitPrice = 100.00);                                  
            priceBEList.add(priceBE1);                              
            insert priceBEList;
            
            Pricebook2 priceBook2 = new Pricebook2(Name = priceBookName, IsActive = True);
                        insert priceBook2;
            
            List<PricebookEntry> priceBEList2 = new List<PricebookEntry>();
                        PricebookEntry priceBE2 = new PricebookEntry(CurrencyIsoCode = 'USD',IsActive = True, Pricebook2Id = priceBook2.Id, Product2Id = prodObject.Id,
                                                                                                                    UnitPrice = 100.00);    
                                                            
            priceBEList2.add(priceBE2);                              
            insert priceBEList2;
                                                    
            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(
                    SBQQ__Account__c = accObject.Id, 
                    Payer_Account__c = accObject.Id, 
                    SBQQ__ExpirationDate__c = date.today()+20, 
                    Use_Prepay_Budget__c = true,
                                        Submission_ID__c = '123');
            insert quoteObject;
            
            SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(
                    SBQQ__Quote__c = quoteObject.Id, 
                    SBQQ__Product__c = prodObject.Id, 
                    Discount_Rules_Applied__c = 'Prepay');
                        insert quoteLineObject;     
                }
        }
        

    private static TF_QuoteAPIService.GenerateQuoteRequest getSampleQuoteCreationRequest () {
        TF_QuoteAPIService.GenerateQuoteRequest request = new TF_QuoteAPIService.GenerateQuoteRequest();
        request.productCode = 'XYZ';
        request.articleType = 'Letter';
        request.authorFacingArticleType = 'Full Review with leading authoer';
        request.articelTitle = 'My Rhetoric Review';
        request.doi = '12345';
        request.manuscriptID = '67890';
        request.submissionID = '121212';
        request.leadAuthorName = 'Alex';
        request.leadAuthorEmailID ='alex@abc.com';
        request.leadAuthorOrganizationName = 'Alex Organization';
        request.payerType = 'Self';
        request.billingStreet = 'billing street 1';
        request.billingStreet2 = 'billing street 2';
        request.billingCity = 'billing city';
        request.billingState = 'billing state';
        request.bilingPostalCode = 'billing 1234';
        request.billingCountry = 'USA';
        request.sameAsBilling = true;
        request.shipToStreet = 'billing street 1'; 
        request.shipToStreet2 = 'billing street 2';
        request.shipToCity = 'billing city';
        request.shipToState = 'billing state';
        request.shipToPostalCode = 'billing 1234';
        request.shipToCountry = 'USA';
        request.canApplyCountryDiscount = false;
        request.canUsePrepayBudget = false;
        request.isArticleAccepted = false;   
        return request;     
    }
}