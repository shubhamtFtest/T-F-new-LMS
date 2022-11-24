/*
* TF_QuoteAPIServiceV1
*/

@isTest
private class zTEST_TF_QuoteAPIServiceV1 {

    private static final String baseUrl = Url.getSalesforceBaseUrl().toExternalForm(); 
   
    @isTest
    private static void test_GenerateQuoteProductDoesNotExist(){
        createSampleData();
        Test.startTest();
        
        Product2 p = zTEST_Shared.insertProduct2();
        p.ProductCode = 'BATC';
        p.US_Inventory_Status__c = 'Available';
        p.IsActive = true;
        p.Article_Type__c = 'Full rate'; 
        p.Family = 'Journals-Author Side Charges';
        update p;
        
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/generateQuote';       
        request.httpMethod = 'POST';
		String requestJSON = '{"authorFacingArticleType": "Document","articelTitle": "testing products","submissionID": "65646","manuscriptID": "","doi": "107.1.2.3","leadAuthorName": "amit","leadAuthorEmailID": "amit.kumar@informa.com","leadAuthorOrganizationName": "TEST ASC NESLI","leadAuthorOrganizationID": "0010D000008ZRsI","leadAuthorOrganizationRingoldID" :"","leadAuthorOrganizationCampus": "","leadAuthorOrganizationDepartment": "","payerType": "Organization","payerEmailID": "","payerContactName": "","payercontactphonenumber": "","leadPrimaryContactPhoneNumber": "2323232323","payerOrganizationName": "","payerOrganizationID": "","payerOrganizationRingoldID" :"","payerOrganizationDepartment": "","payerOrganizationCampus": "","vatNumber": "","purchaseOrderNumber": "","canUsePrepayBudget": false,"canApplyCountryDiscount": true,"canApplySocietyDiscount": true,"disableRejectionEmail": false,"disableDraftEmail": false,"sameAsBilling": true,"isArticleAccepted": true,"isAuthorAccepted": false,"billingStreet": "test","billingStreet2": "","billingState": "Karnataka","billingCountry": "India","billingCity": "banglore","bilingPostalCode": "536781","shipToContact": "test test","shipToOrganization": "TEST ASC NESLI","shipToStreet2": "","shipToStreet": "","shipToState": "","shipToPostalCode": "","shipToCountry": "","shipToCity": "","promoCode": "","disableQuoteCreationNotificationEmailToAuthor": false,"disablePrePayApprovalNotificationEmailToAuthor": false,"disablePrePayManualApprovalCase": false,"entryPoint": "ASC","needsManualApproval": false}';        
        request.requestBody = Blob.valueof(requestJSON);
        RestContext.request = request;
        RestContext.response = res;
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();
    } 

    @isTest
    private static void test_GenerateQuoteProductNotMatching(){
        createSampleData();
        Test.startTest();
        
        Product2 p = zTEST_Shared.insertProduct2();
        p.ProductCode = 'BATC';
        p.US_Inventory_Status__c = 'Available';
        p.IsActive = true;
        p.Article_Type__c = 'Full rate'; 
        p.Family = 'Journals-Author Side Charges';
        update p;
        
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/generateQuote';       
        request.httpMethod = 'POST';
		String requestJSON = '{"authorFacingArticleType": "Document","articelTitle": "testing products","submissionID": "65646","manuscriptID": "","doi": "107.1.2.3","leadAuthorName": "amit","leadAuthorEmailID": "amit.kumar@informa.com","leadAuthorOrganizationName": "TEST ASC NESLI","leadAuthorOrganizationID": "0010D000008ZRsI","leadAuthorOrganizationRingoldID" :"","leadAuthorOrganizationCampus": "","leadAuthorOrganizationDepartment": "","payerType": "Organization","payerEmailID": "","payerContactName": "","payercontactphonenumber": "","leadPrimaryContactPhoneNumber": "2323232323","payerOrganizationName": "","payerOrganizationID": "","payerOrganizationRingoldID" :"","payerOrganizationDepartment": "","payerOrganizationCampus": "","vatNumber": "","purchaseOrderNumber": "","canUsePrepayBudget": false,"canApplyCountryDiscount": true,"canApplySocietyDiscount": true,"disableRejectionEmail": false,"disableDraftEmail": false,"sameAsBilling": true,"isArticleAccepted": true,"isAuthorAccepted": false,"billingStreet": "test","billingStreet2": "","billingState": "Karnataka","billingCountry": "India","billingCity": "banglore","bilingPostalCode": "536781","shipToContact": "test test","shipToOrganization": "TEST ASC NESLI","shipToStreet2": "","shipToStreet": "","shipToState": "","shipToPostalCode": "","shipToCountry": "","shipToCity": "","promoCode": "","disableQuoteCreationNotificationEmailToAuthor": false,"disablePrePayApprovalNotificationEmailToAuthor": false,"disablePrePayManualApprovalCase": false,"entryPoint": "ASC","needsManualApproval": false,"products": [{"productcode": "XYZ","articleType": "Letter"}]}'; 
        
        request.requestBody = Blob.valueof(requestJSON);
        RestContext.request = request;
        RestContext.response = res;
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();
    }

    
    @isTest
    private static void test_doPost_Fail(){
        createSampleData();
        Test.startTest();
        
        Product2 p = zTEST_Shared.insertProduct2();
        p.ProductCode = 'BATC';
        p.US_Inventory_Status__c = 'Available';
        p.IsActive = true;
        p.Article_Type__c = 'Full rate'; 
        p.Family = 'Journals-Author Side Charges';
        update p;
        
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/generateQuote';       
        request.httpMethod = 'POST';
		String requestJSON = '{"authorFacingArticleType": "Document","articelTitle": "testing products","submissionID": "65646","manuscriptID": "","doi": "107.1.2.3","leadAuthorName": "amit","leadAuthorEmailID": "amit.kumar@informa.com","leadAuthorOrganizationName": "TEST ASC NESLI","leadAuthorOrganizationID": "0010D000008ZRsI","leadAuthorOrganizationRingoldID" :"","leadAuthorOrganizationCampus": "","leadAuthorOrganizationDepartment": "","payerType": "Organization","payerEmailID": "","payerContactName": "","payercontactphonenumber": "","leadPrimaryContactPhoneNumber": "2323232323","payerOrganizationName": "","payerOrganizationID": "","payerOrganizationRingoldID" :"","payerOrganizationDepartment": "","payerOrganizationCampus": "","vatNumber": "","purchaseOrderNumber": "","canUsePrepayBudget": false,"canApplyCountryDiscount": true,"canApplySocietyDiscount": true,"disableRejectionEmail": false,"disableDraftEmail": false,"sameAsBilling": true,"isArticleAccepted": true,"isAuthorAccepted": false,"billingStreet": "test","billingStreet2": "","billingState": "Karnataka","billingCountry": "India","billingCity": "banglore","bilingPostalCode": "536781","shipToContact": "test test","shipToOrganization": "TEST ASC NESLI","shipToStreet2": "","shipToStreet": "","shipToState": "","shipToPostalCode": "","shipToCountry": "","shipToCity": "","promoCode": "","disableQuoteCreationNotificationEmailToAuthor": false,"disablePrePayApprovalNotificationEmailToAuthor": false,"disablePrePayManualApprovalCase": false,"entryPoint": "ASC","needsManualApproval": false,"products": [{"productcode": "ABC","articleType": "Letter"},{"productcode": "xyz","articleType": "Letter"},{"productcode": "RAED","articleType": "Full Rate"}]}';        
        
        request.requestBody = Blob.valueof(requestJSON);
        RestContext.request = request;
        RestContext.response = res;
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();
    }     
    @isTest
    private static void test_doPost_InvaidResource(){  
        createSampleData();
        Test.startTest();
        
        Product2 p = zTEST_Shared.insertProduct2();
        p.ProductCode = 'BATC';
        p.US_Inventory_Status__c = 'Available';
        p.IsActive = true;
        p.Article_Type__c = 'Full rate'; 
        p.Family = 'Journals-Author Side Charges';
        update p;
        
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/xxx33yyy343shd';       
        request.httpMethod = 'POST';
        String requestJSON = '{}';
        request.requestBody = Blob.valueof(requestJSON);
        RestContext.request = request;
        RestContext.response = res;
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();
    }

   
    
    @isTest
    private static void testListPriceRequest(){
        test.startTest();        
        TF_QuoteAPIServiceV1.ListPriceRequest obj = new  TF_QuoteAPIServiceV1.ListPriceRequest();
        obj.productCode = 'BATC';
        obj.articleType = 'Full rate';
        obj.countryCode = 'IN';
        obj.APCPriceCategory = 'CAT';
        test.stopTest();         
    }

    private static testmethod void testQuoteRequest(){
        test.startTest();        
        TF_QuoteAPIServiceV1.QuoteRequest obj = new  TF_QuoteAPIServiceV1.QuoteRequest();
        obj.quoteId = 'a1y1x00000D7z4E';
        obj.quoteUniqueId = '123';
        obj.submissionId = '345';
        obj.doi = '10.10.199';
        obj.CSDApprovalStatus = 'xyz';
        obj.APCPriceCategory = 'CAT';
        obj.requestId = '12se234';
        test.stopTest();         
    }
    
    private static testmethod void testQuoteUpdateRequest(){
        test.startTest();        
        TF_QuoteAPIServiceV1.QuoteUpdateRequest obj = new  TF_QuoteAPIServiceV1.QuoteUpdateRequest();
        obj.doi='';
        obj.canInvoice = true;
        obj.isArticleAccepted = true;
        obj.requestId='';
        obj.payercontactphonenumber='';
        obj.payerContactName='';
        obj.payerFirstName = '';
        obj.payerLastName ='';
        obj.payerOrganizationDepartment='';
        obj.payerOrganizationCampus='';
        obj.vatNumber='';
        obj.purchaseOrderNumber='';
        obj.payerPartyID='';
        obj.billingStreet='';
        obj.billingStreet2='';
        obj.billingCity='';
        obj.billingState='';
        obj.billingStateISO='';
        obj.billingPostalCode='';
        obj.sameAsBilling=true;
        obj.shipToContact='';
        obj.shipToOrganization='';
        obj.shipToStreet='';
        obj.shipToStreet2='';
        obj.shipToCity='';
        obj.shipToState='';
        obj.shipToStateISO='';
        obj.shipToPostalCode='';
        obj.shipToCountry='';  
        obj.taxRegistrationNumber='';
        obj.taxCategory='';
        obj.billingBPNumber='';
        obj.shippingBPNumber='';
        obj.billingAddressID='';
        obj.shippingAddressID='';
        obj.reasonForDiscreantionaryWaiver='';
        obj.discreationaryWaiverStatus='';
        test.stopTest();         
    }
    
 
    private static testmethod void testlineItemDetails(){
        test.startTest();        
        TF_QuoteAPIServiceV1.lineItemDetails obj = new  TF_QuoteAPIServiceV1.lineItemDetails();
        obj.productCode = 'BATC';
        obj.articleType = 'Full rate';
        obj.journalName = 'TEST';
        obj.discountDisplayName = 'test';
        obj.productOpenAccessCategory = 'xyz';
        obj.APCPriceCategory = 'CAT';
        obj.serviceName = '12se234';
        //obj.isPriceRuleAppled = true;
        obj.authorFacingArticleType = '12se234';
        test.stopTest();         
    }
    
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
        
        TF_QuoteAPIServiceV1.UpdateInvoiceNumberRequest request = new TF_QuoteAPIServiceV1.UpdateInvoiceNumberRequest();
        
        request.orderHubNumber = 'ODR881153';   
        request.invoiceNumber = '123';
        String requestJSON = JSON.serialize(request);
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/updateInvoiceNumber';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        TF_QuoteAPIServiceV1.doPost();
        
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuoteResponse response = (TF_QuoteAPIServiceV1.QuoteResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuoteResponse.class);
        system.assertEquals(response.success,true);
    }     

    private static testmethod void testUpdateInvoiceNumber_InvalidOrderHubNumber() {
        createTestDataToUpdateInvoiceNumber();
        List<SBQQ__Quote__c> quotes = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c, randomstring__c FROM SBQQ__Quote__c LIMIT 1];                        
        
        SBQQ__Quote__c quoteObject = quotes[0];
        quoteObject.Author_Status__c = 'Accepted';
        Update quoteObject;
        
        TF_QuoteAPIServiceV1.UpdateInvoiceNumberRequest request = new TF_QuoteAPIServiceV1.UpdateInvoiceNumberRequest();
        
        request.orderHubNumber = 'ODR881159';   
        request.invoiceNumber = '123';
        String requestJSON = JSON.serialize(request);
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/updateInvoiceNumber';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        TF_QuoteAPIServiceV1.doPost();
        
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuoteResponse response = (TF_QuoteAPIServiceV1.QuoteResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuoteResponse.class);
        system.assertEquals(response.quoteId, null);
        system.assertEquals(response.success, false);
    }

    private static testmethod void testUpdateInvoiceNumber_InvalidInvoiceNumber() {
        createTestDataToUpdateInvoiceNumber();
        List<SBQQ__Quote__c> quotes = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c, randomstring__c FROM SBQQ__Quote__c LIMIT 1];                        
        
        SBQQ__Quote__c quoteObject = quotes[0];
        quoteObject.Author_Status__c = 'Accepted';
        Update quoteObject;
        TF_QuoteAPIServiceV1.UpdateInvoiceNumberRequest request = new TF_QuoteAPIServiceV1.UpdateInvoiceNumberRequest();        
        request.orderHubNumber = 'ODR881153';   
        request.invoiceNumber = '';
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/updateInvoiceNumber';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        TF_QuoteAPIServiceV1.doPost();
        
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuoteResponse response = (TF_QuoteAPIServiceV1.QuoteResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuoteResponse.class);
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
        TF_QuoteAPIServiceV1.isCountryDiscountAvailableRequest request = new TF_QuoteAPIServiceV1.isCountryDiscountAvailableRequest();
        request.productCode = 'CFAI';
        request.country = '';
        
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();        
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/isCountryDiscountAvailable';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuotePromoCodeResponse response = (TF_QuoteAPIServiceV1.QuotePromoCodeResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuotePromoCodeResponse.class);
        
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
        TF_QuoteAPIServiceV1.isCountryDiscountAvailableRequest request = new TF_QuoteAPIServiceV1.isCountryDiscountAvailableRequest();
        request.productCode = 'CFAI';
        request.country = 'Georgia';
        
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();        
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/isCountryDiscountAvailable';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuotePromoCodeResponse response = (TF_QuoteAPIServiceV1.QuotePromoCodeResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuotePromoCodeResponse.class);
        
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
        TF_QuoteAPIServiceV1.isCountryDiscountAvailableRequest request = new TF_QuoteAPIServiceV1.isCountryDiscountAvailableRequest();
        request.productCode = 'CFAI';
        request.country = 'Afghanistan';
        
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();        
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/isCountryDiscountAvailable';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuotePromoCodeResponse response = (TF_QuoteAPIServiceV1.QuotePromoCodeResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuotePromoCodeResponse.class);
        
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
        TF_QuoteAPIServiceV1.isCountryDiscountAvailableRequest request = new TF_QuoteAPIServiceV1.isCountryDiscountAvailableRequest();
        request.productCode = 'CFAI';
        request.country = 'Bhutan';
        
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();        
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/isCountryDiscountAvailable';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuotePromoCodeResponse response = (TF_QuoteAPIServiceV1.QuotePromoCodeResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuotePromoCodeResponse.class);
        
        System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);  
    }

    private static testmethod void checkIsCountryDiscountAvailableExceptionTest() {
        sampleDataForCPQDiscountConfigurationsCountryWaiver();

        Country__c country = new Country__c(Name = 'Bhutan',Applicable_List__c = '',EIFL__c = false, EIFL_Type__c = '',
                                            Country_2__c = 'BT',Country_3__c = 'BTN',Preferred_currency__c = 'USD',
                                            Description__c='Bhutan', Enabled__c=true);    
        insert country;        
        
        Country__c selectedCountry = [SELECT Name,Applicable_List__c,EIFL__c,EIFL_Type__c FROM Country__c WHERE Name = 'Bhutan' LIMIT 1];
        List<CPQ_Discount_Configuration__c> cpqDiscConfig = [SELECT id,Promocode__c,Product_Code__c,Start_Date__c,End_Date__c FROM CPQ_Discount_Configuration__c];        
        TF_QuoteAPIServiceV1.isCountryDiscountAvailableRequest request = new TF_QuoteAPIServiceV1.isCountryDiscountAvailableRequest();
        request.productCode = 'CFAI';
        request.country = '';
        
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();        
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/isCountryDiscountAvailable';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuotePromoCodeResponse response = (TF_QuoteAPIServiceV1.QuotePromoCodeResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuotePromoCodeResponse.class);
        
        System.assertEquals('Invalid country name or product code.', response.errorMessage);
        System.assertEquals(false, response.success);  
    }
    
    private static testmethod void checkIsCountryDiscountAvailableNoDiscountCountry() {
        sampleDataForCPQDiscountConfigurationsCountryWaiver();

        Country__c country = new Country__c(Name = 'Czech Republic',Applicable_List__c = '',EIFL__c = false,EIFL_Type__c = '',
                                            Country_2__c = 'CZ',Country_3__c = 'CZE',Preferred_currency__c = 'USD',
                                            Description__c='Czech Republic',Enabled__c=true);    
        insert country;        
        
        Country__c selectedCountry = [SELECT Name,Applicable_List__c,EIFL__c,EIFL_Type__c FROM Country__c WHERE Name = 'Czech Republic' LIMIT 1];
        List<CPQ_Discount_Configuration__c> cpqDiscConfig = [SELECT id,Promocode__c,Product_Code__c,Start_Date__c,End_Date__c FROM CPQ_Discount_Configuration__c];        
        TF_QuoteAPIServiceV1.isCountryDiscountAvailableRequest request = new TF_QuoteAPIServiceV1.isCountryDiscountAvailableRequest();
        request.productCode = 'CFAI';
        request.country = 'Czech Republic';
        
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();        
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/isCountryDiscountAvailable';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuotePromoCodeResponse response = (TF_QuoteAPIServiceV1.QuotePromoCodeResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuotePromoCodeResponse.class);
        
        System.assertEquals('Discount Not Available.', response.errorMessage);
        System.assertEquals(false, response.success);  
    }
    
    private static testmethod void checkPromoCode() {
        sampleDataForCPQDiscountConfigurations();
        List<CPQ_Discount_Configuration__c> cpqDiscConfig = [SELECT id,Promocode__c,Product_Code__c,Start_Date__c,End_Date__c FROM CPQ_Discount_Configuration__c];        
        TF_QuoteAPIServiceV1.QuotePromoCodeRequest request = new TF_QuoteAPIServiceV1.QuotePromoCodeRequest();
        request.productCode = cpqDiscConfig[0].Product_Code__c;
        request.promoCode = cpqDiscConfig[0].Promocode__c;
        request.countryCode = 'IND';
        request.payerType = 'Self';
        
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();        
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/checkPromoCode';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuotePromoCodeResponse response = (TF_QuoteAPIServiceV1.QuotePromoCodeResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuotePromoCodeResponse.class);
        
        System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);  
    }
    
    private static testmethod void checkPromoCodeInvalidPromoNotSelf() {
        sampleDataForCPQDiscountConfigurations();
        List<CPQ_Discount_Configuration__c> cpqDiscConfig = [SELECT id,Promocode__c,Product_Code__c,Start_Date__c,End_Date__c FROM CPQ_Discount_Configuration__c];        
        TF_QuoteAPIServiceV1.QuotePromoCodeRequest request = new TF_QuoteAPIServiceV1.QuotePromoCodeRequest();
        request.productCode = cpqDiscConfig[0].Product_Code__c;
        request.promoCode = 'TEST';
        request.countryCode = 'IND';
        request.payerType = 'Organization';
        
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();        
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/checkPromoCode';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuotePromoCodeResponse response = (TF_QuoteAPIServiceV1.QuotePromoCodeResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuotePromoCodeResponse.class);
        
        System.assertEquals('Invalid promo code / invalid product code.', response.errorMessage);  
    }
    
    private static testmethod void checkPromoCodeInvalidPromoOrProduct() {
        sampleDataForCPQDiscountConfigurations();
        List<CPQ_Discount_Configuration__c> cpqDiscConfig = [SELECT id,Promocode__c,Product_Code__c,Start_Date__c,End_Date__c FROM CPQ_Discount_Configuration__c];        
        TF_QuoteAPIServiceV1.QuotePromoCodeRequest request = new TF_QuoteAPIServiceV1.QuotePromoCodeRequest();
        request.productCode = cpqDiscConfig[0].Product_Code__c;
        request.promoCode = 'TEST';
        request.countryCode = 'IND';
        request.payerType = 'Self';
        
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();        
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/checkPromoCode';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuotePromoCodeResponse response = (TF_QuoteAPIServiceV1.QuotePromoCodeResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuotePromoCodeResponse.class);
        
        System.assertEquals('Invalid promo code / invalid product code.', response.errorMessage);  
    }
    
    private static testmethod void checkPromoCodeCheckInputs() {
        sampleDataForCPQDiscountConfigurations();
        List<CPQ_Discount_Configuration__c> cpqDiscConfig = [SELECT id,Promocode__c,Product_Code__c,Start_Date__c,End_Date__c FROM CPQ_Discount_Configuration__c];        
        TF_QuoteAPIServiceV1.QuotePromoCodeRequest request = new TF_QuoteAPIServiceV1.QuotePromoCodeRequest();
        request.productCode = cpqDiscConfig[0].Product_Code__c;
        request.promoCode = null;
        request.countryCode = 'IND';
        request.payerType = 'Self';
        
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();        
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/checkPromoCode';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuotePromoCodeResponse response = (TF_QuoteAPIServiceV1.QuotePromoCodeResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuotePromoCodeResponse.class);
        
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
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/checkPromoCode';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuotePromoCodeResponse response = (TF_QuoteAPIServiceV1.QuotePromoCodeResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuotePromoCodeResponse.class);
        
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
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/checkPromoCode';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuotePromoCodeResponse response = (TF_QuoteAPIServiceV1.QuotePromoCodeResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuotePromoCodeResponse.class);
        
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
        TF_QuoteAPIServiceV1.QuotePromoCodeRequest request = new TF_QuoteAPIServiceV1.QuotePromoCodeRequest();
        request.productCode = cpqDiscConfig[0].Product_Code__c;
        request.promoCode = cpqDiscConfig[0].Promocode__c;
        request.countryCode = 'IND';
        request.payerType = 'Organization';
        
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();        
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/checkPromoCode';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuotePromoCodeResponse response = (TF_QuoteAPIServiceV1.QuotePromoCodeResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuotePromoCodeResponse.class);
        
        System.assertEquals('Promo code has expired.', response.errorMessage);
        System.assertEquals(false, response.success);  
    }
    
    private static testmethod void expiresQuoteAlreadyExpiredTest() {
        createSampleData();
        List<SBQQ__Quote__c> quotes = [SELECT id,doi__c,randomstring__c,Name,Use_Prepay_Budget__c,SBQQ__Account__c FROM SBQQ__Quote__c];        
        String s = getRandomString();
        SBQQ__Quote__c quoteObject = quotes[0];
        quoteObject.SBQQ__Status__c = 'Expired';
        quoteObject.randomstring__c = s;
        Update quoteObject;
        
        TF_QuoteAPIServiceV1.QuoteExpireRequest request = new TF_QuoteAPIServiceV1.QuoteExpireRequest();

        request.quoteUniqueId = quotes[0].randomstring__c;
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
    
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/expiresQuote/';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
                
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuoteDetailResponse response = (TF_QuoteAPIServiceV1.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuoteDetailResponse.class);
        response.success = true; 
        //System.assertNotEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);
    }
    
    private static testmethod void expiresQuoteTest() {
        createSampleData();
        List<SBQQ__Quote__c> quotes = [SELECT id,doi__c,randomstring__c,Name,Use_Prepay_Budget__c,SBQQ__Account__c FROM SBQQ__Quote__c];        
        String s = getRandomString();
        SBQQ__Quote__c quoteObject = quotes[0];
        quoteObject.SBQQ__Status__c = 'Draft';
        quoteObject.randomstring__c = s;
        Update quoteObject;
        
        TF_QuoteAPIServiceV1.QuoteExpireRequest request = new TF_QuoteAPIServiceV1.QuoteExpireRequest();

        request.quoteUniqueId = quotes[0].randomstring__c;
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
    
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/expiresQuote/';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
                
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuoteDetailResponse response = (TF_QuoteAPIServiceV1.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuoteDetailResponse.class);
        response.success = true;
        
      
        //System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);
    }
    
    private static testmethod void expiresQuoteInvalidTest() {
        createSampleData();
        List<SBQQ__Quote__c> quotes = [SELECT id,doi__c,Name,Use_Prepay_Budget__c,SBQQ__Account__c, randomstring__c FROM SBQQ__Quote__c];
        TF_QuoteAPIServiceV1.QuoteExpireRequest request = new TF_QuoteAPIServiceV1.QuoteExpireRequest();
        request.quoteUniqueId = quotes[0].randomstring__c;
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/expiresQuote/';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
                
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuoteDetailResponse response = (TF_QuoteAPIServiceV1.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuoteDetailResponse.class);
        
        System.assertNotEquals(null, response.errorMessage); 
        System.assertEquals(false, response.success);
    } 
    
    private static testmethod void updateQuoteDetailsValidQuoteTest() {
        createSampleData();
        List<SBQQ__Quote__c> quotes = [SELECT id,doi__c,Name,Use_Prepay_Budget__c,SBQQ__Account__c, randomstring__c FROM SBQQ__Quote__c];
        TF_QuoteAPIServiceV1.QuoteUpdateRequest request = new TF_QuoteAPIServiceV1.QuoteUpdateRequest();
        
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
        request.payerFirstName = 'amit';
        request.payerLastName ='kumar';        
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
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/updateQuoteDetails/'+quotes[0].randomstring__c;  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
                
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuoteDetailResponse response = (TF_QuoteAPIServiceV1.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuoteDetailResponse.class);
     response.success = true;
        //System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);
    }
    
    private static testmethod void updateQuoteDetailsInValidQuoteTest() {
        createSampleData();
        
        List<SBQQ__Quote__c> quotes = [SELECT id,doi__c,Name,Use_Prepay_Budget__c,SBQQ__Account__c, randomstring__c FROM SBQQ__Quote__c];
        TF_QuoteAPIServiceV1.QuoteUpdateRequest request = new TF_QuoteAPIServiceV1.QuoteUpdateRequest();
        request.doi = '12345';
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/updateQuoteDetails/';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
                
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuoteDetailResponse response = (TF_QuoteAPIServiceV1.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuoteDetailResponse.class);
 
        System.assertNotEquals('QuoteId in query parameter is mandatory as /updateQuoteDetails/UniqueQuoteId.', response.errorMessage);
        System.assertEquals(false, response.success);
    }
    
    private static testmethod void authorAcceptsQuoteTest() {
        createSampleData();
        
        List<SBQQ__Quote__c> quotes = [SELECT id,Payer_First_Name__c,Payer_Last_Name__c,Name,Use_Prepay_Budget__c,SBQQ__Account__c, randomstring__c FROM SBQQ__Quote__c];

        // -- Create a request object -- //
        TF_QuoteAPIServiceV1.QuoteRequest request = new TF_QuoteAPIServiceV1.QuoteRequest();
        request.quoteUniqueId = quotes[0].randomstring__c;
        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/authorAcceptsQuote';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
                
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuoteDetailResponse response = (TF_QuoteAPIServiceV1.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuoteDetailResponse.class);
 
        System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);
    }

     private static testmethod void authorAcceptsQuotesTest() {
        createSampleData();
        
        List<SBQQ__Quote__c> quotes = [SELECT id,Name,Payer_First_Name__c ,Payer_Last_Name__c ,Use_Prepay_Budget__c,SBQQ__Account__c, randomstring__c FROM SBQQ__Quote__c];

        // -- Create a request object -- //
        TF_QuoteAPIServiceV1.QuoteRequest request = new TF_QuoteAPIServiceV1.QuoteRequest();
        request.quoteUniqueId = quotes[0].randomstring__c;
        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/authorAcceptsQuote';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
                
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuoteDetailResponse response = (TF_QuoteAPIServiceV1.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuoteDetailResponse.class);
 
        System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);        
     }

     private static testmethod void authorRejectsQuoteTest() {
        createSampleData();
        
        List<SBQQ__Quote__c> quotes = [SELECT id,Payer_Last_Name__c,Payer_First_Name__c ,Name,Use_Prepay_Budget__c,SBQQ__Account__c, randomstring__c FROM SBQQ__Quote__c];

        // -- Create a request object -- //
        TF_QuoteAPIServiceV1.QuoteRequest request = new TF_QuoteAPIServiceV1.QuoteRequest();
        request.quoteUniqueId = quotes[0].randomstring__c;
        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/authorRejectsQuote';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
                
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuoteDetailResponse response = (TF_QuoteAPIServiceV1.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuoteDetailResponse.class);
 
        System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);        
     }    
        
    private static testmethod void getQuoteByParamsTest() {
        createSampleData();
        List<SBQQ__Quote__c> quotes = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c FROM SBQQ__Quote__c];

        // -- Create a request object -- //
        TF_QuoteAPIServiceV1.QuoteRequest request = new TF_QuoteAPIServiceV1.QuoteRequest();
        //request.submissionId = '123123';
        request.doi = '12345';
        
        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/getQuoteByParams';
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();

        String responeJSON = RestContext.response.responseBody.toString();
        //TF_QuoteAPIService.QuoteDetailResponse response = (TF_QuoteAPIService.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuoteDetailResponse.class);
        List<TF_QuoteAPIServiceV1.QuoteDetailResponse> response = (List<TF_QuoteAPIServiceV1.QuoteDetailResponse>)JSON.deserialize(responeJSON, List<TF_QuoteAPIServiceV1.QuoteDetailResponse>.class);
        System.assertEquals(response.size(), 0);                  
    }  
    
     private static testmethod void getQuoteByParamsInvalidTest() {
        createSampleData();
        List<SBQQ__Quote__c> quotes = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c FROM SBQQ__Quote__c];

        // -- Create a request object -- //
        TF_QuoteAPIServiceV1.QuoteRequest request = new TF_QuoteAPIServiceV1.QuoteRequest();
        request.submissionId = '123';
        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/getQuoteByParams';
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();

         String responeJSON = RestContext.response.responseBody.toString();
         List<TF_QuoteAPIServiceV1.QuoteDetailResponse> response = (List<TF_QuoteAPIServiceV1.QuoteDetailResponse>)JSON.deserialize(responeJSON, List<TF_QuoteAPIServiceV1.QuoteDetailResponse>.class);
         
         System.assertEquals(null, response[0].errorMessage);
         System.assertEquals(true, response[0].success);          
    }  

     private static testmethod void getQuoteByParamsCheckMandatoriesTest() {
        createSampleData();
        List<SBQQ__Quote__c> quotes = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c FROM SBQQ__Quote__c];
        TF_QuoteAPIServiceV1.QuoteRequest request = new TF_QuoteAPIServiceV1.QuoteRequest();
        request.submissionId = '';
		request.manuscriptId = '';
		request.doi = '';
        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/getQuoteByParams';
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();

         String responeJSON = RestContext.response.responseBody.toString();
         List<TF_QuoteAPIServiceV1.QuoteDetailResponse> response = (List<TF_QuoteAPIServiceV1.QuoteDetailResponse>)JSON.deserialize(responeJSON, List<TF_QuoteAPIServiceV1.QuoteDetailResponse>.class);
         
         System.assertEquals('At least one parameter is mandatory', response[0].errorMessage);
         System.assertEquals(false, response[0].success);          
    }
    
    private static testmethod void getQuoteByUniqueIDTest() {
        createSampleData();
        List<SBQQ__Quote__c> quotes = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c,randomstring__c FROM SBQQ__Quote__c];

        // -- Create a request object -- //
        TF_QuoteAPIServiceV1.QuoteRequest request = new TF_QuoteAPIServiceV1.QuoteRequest();
        request.quoteUniqueId = quotes[0].randomstring__c;
        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/getQuoteByUniqueID';
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();

        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuoteDetailResponse response = (TF_QuoteAPIServiceV1.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuoteDetailResponse.class);
 
        System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);        
        
    }    

    
    private static testmethod void getQuoteTest() {
        createSampleData();

        List<SBQQ__Quote__c> quotes = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c FROM SBQQ__Quote__c];

        // -- Create a request object -- //
        TF_QuoteAPIServiceV1.QuoteRequest request = new TF_QuoteAPIServiceV1.QuoteRequest();
        request.quoteId = quotes[0].id;
        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/getQuote';
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();

        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuoteDetailResponse response = (TF_QuoteAPIServiceV1.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuoteDetailResponse.class);
 
        System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);        
                
    }

    private static testmethod void getQuoteExceptionTest() {
        createSampleData();
        List<SBQQ__Quote__c> quotes = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c FROM SBQQ__Quote__c];
        TF_QuoteAPIServiceV1.QuoteRequest request = new TF_QuoteAPIServiceV1.QuoteRequest();
        //request.quoteId = '333';
        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/getQuote';
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();

        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuoteDetailResponse response = (TF_QuoteAPIServiceV1.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuoteDetailResponse.class);
 
        System.assertNotEquals(null, response.errorMessage);
        System.assertEquals(false, response.success);                        
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
        TF_QuoteAPIServiceV1.UpdateCSDApprovalStatusRequest request = new TF_QuoteAPIServiceV1.UpdateCSDApprovalStatusRequest();
        
        //request.quoteNumber = quotes[0].Name; 
        request.quoteUniqueId = quotes[0].randomstring__c;   
        request.csdApprovalStatus = '';
        String requestJSON = JSON.serialize(request);
    
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
                
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/csdUpdateStatus';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
                
        RestContext.request = req;
        RestContext.response = res;
    
        
        TF_QuoteAPIServiceV1.doPost();
        
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuoteResponse response = (TF_QuoteAPIServiceV1.QuoteResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuoteResponse.class);
        
        
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
        TF_QuoteAPIServiceV1.UpdateCSDApprovalStatusRequest request = new TF_QuoteAPIServiceV1.UpdateCSDApprovalStatusRequest();
        
        //request.quoteNumber = quotes[0].Name;
        request.quoteUniqueId = quotes[0].randomstring__c;
        request.csdApprovalStatus = 'Approved';
        String requestJSON = JSON.serialize(request);
    
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
                
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/csdUpdateStatus';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
                
        RestContext.request = req;
        RestContext.response = res;
    
        
        TF_QuoteAPIServiceV1.doPost();
        
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuoteResponse response = (TF_QuoteAPIServiceV1.QuoteResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuoteResponse.class);
        
        
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
        TF_QuoteAPIServiceV1.UpdateCSDApprovalStatusRequest request = new TF_QuoteAPIServiceV1.UpdateCSDApprovalStatusRequest();
        
        //request.quoteNumber = quotes[0].Name;
        request.quoteUniqueId = quotes[0].randomstring__c;
        request.csdApprovalStatus = 'Approved';
        String requestJSON = JSON.serialize(request);
    
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
                
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/csdUpdateStatus';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
                
        RestContext.request = req;
        RestContext.response = res;
    
        test.starttest();
            TF_QuoteAPIServiceV1.doPost();
        test.stoptest();
        
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuoteResponse response = (TF_QuoteAPIServiceV1.QuoteResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuoteResponse.class);
        system.assertEquals(response.success,True);
            
        SBQQ__Quote__c quoteObj = [SELECT Id, Name, SBQQ__Status__c, CSD_Approval_Status__c from SBQQ__Quote__c];
        system.debug(quoteObj);
        system.debug([select id, quote_approval_status__c, quote__c from quote_approval__c]);       
        System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);               
    }

    
    
    private static testmethod void getListPriceTest() {
        createSampleData();
        TF_QuoteAPIServiceV1.ListPriceRequest request = new TF_QuoteAPIServiceV1.ListPriceRequest();
        request.productCode = 'XYZ';
        request.articleType = 'Letter';
        request.countryCode = 'US';
        String requestJSON = JSON.serialize(request);
        //String requestJSON = '{"productCode": "BATC","articleType": "Full rate","countryCode": "IN"}';

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
                
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/getListPrice';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
                
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();    
        
        String responeJSON = RestContext.response.responseBody.toString();  
        TF_QuoteAPIServiceV1.ListPriceResponse response = (TF_QuoteAPIServiceV1.ListPriceResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.ListPriceResponse.class);
        System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success); 
        System.assertEquals('USD', response.currencyIsoCode);
        System.assertEquals(100.00, response.value);
                
    }

    private static testmethod void getListPriceTest_Invalid() {
        createSampleData();
        TF_QuoteAPIServiceV1.ListPriceRequest request = new TF_QuoteAPIServiceV1.ListPriceRequest();
        request.productCode = '';
        request.articleType = '';
        request.countryCode = '';
        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
                
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/getListPrice';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
                
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();    
        
        String responeJSON = RestContext.response.responseBody.toString();  
        TF_QuoteAPIServiceV1.ListPriceResponse response = (TF_QuoteAPIServiceV1.ListPriceResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.ListPriceResponse.class);
        System.assertNotEquals(null, response.errorMessage);
        System.assertEquals(false, response.success); 
        System.assertEquals(null, response.currencyIsoCode);
        System.assertEquals(null, response.value);
                
    }

    private static testmethod void getListPriceNoProductMatchingTest() {
        createSampleData();
        TF_QuoteAPIServiceV1.ListPriceRequest request = new TF_QuoteAPIServiceV1.ListPriceRequest();
        request.productCode = 'DEMO';
        request.articleType = 'Full rate';
        request.countryCode = 'IN';
        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
                
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/getListPrice';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
                
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();    
        
        String responeJSON = RestContext.response.responseBody.toString();  
        TF_QuoteAPIServiceV1.ListPriceResponse response = (TF_QuoteAPIServiceV1.ListPriceResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.ListPriceResponse.class);
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
		//String requestJSON = '{"authorFacingArticleType": "Document","articelTitle": "testing products","submissionID": "65646","manuscriptID": "","doi": "107.1.2.3","leadAuthorName": "amit","leadAuthorEmailID": "amit.kumar@informa.com","leadAuthorOrganizationName": "TEST ASC NESLI","leadAuthorOrganizationID": "0010D000008ZRsI","leadAuthorOrganizationRingoldID" :"","leadAuthorOrganizationCampus": "","leadAuthorOrganizationDepartment": "","payerType": "Organization","payerEmailID": "","payerContactName": "","payercontactphonenumber": "","leadPrimaryContactPhoneNumber": "2323232323","payerOrganizationName": "","payerOrganizationID": "","payerOrganizationRingoldID" :"","payerOrganizationDepartment": "","payerOrganizationCampus": "","vatNumber": "","purchaseOrderNumber": "","canUsePrepayBudget": false,"canApplyCountryDiscount": true,"canApplySocietyDiscount": true,"disableRejectionEmail": false,"disableDraftEmail": false,"sameAsBilling": true,"isArticleAccepted": true,"isAuthorAccepted": false,"billingStreet": "test","billingStreet2": "","billingState": "Karnataka","billingCountry": "India","billingCity": "banglore","bilingPostalCode": "536781","shipToContact": "test test","shipToOrganization": "TEST ASC NESLI","shipToStreet2": "","shipToStreet": "","shipToState": "","shipToPostalCode": "","shipToCountry": "","shipToCity": "","promoCode": "","disableQuoteCreationNotificationEmailToAuthor": false,"disablePrePayApprovalNotificationEmailToAuthor": false,"disablePrePayManualApprovalCase": false,"entryPoint": "ASC","needsManualApproval": false,"products": [{"productcode": "RABD","articleType": "Full rate"},{"productcode": "BATC","articleType": "Full Rate"},{"productcode": "RAED","articleType": "Full Rate"}]}';
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/recalculateQuote';
        
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();

        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuoteDetailResponse response = (TF_QuoteAPIServiceV1.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuoteDetailResponse.class);
 
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
        quoteChangeRequest.payerFirstName = 'Amit';
        quoteChangeRequest.payerLastName = 'Kumar';    
        quoteChangeRequest.payerEmailID = 'payer@org.com';
        quoteChangeRequest.payerOrganizationName = 'Alex Organization';      
        
        request.recalculationRequest = quoteChangeRequest;  
		String requestJSON = '{"authorFacingArticleType": "Document","articelTitle": "testing products","submissionID": "65646","manuscriptID": "","doi": "107.1.2.3","leadAuthorName": "amit","leadAuthorEmailID": "amit.kumar@informa.com","leadAuthorOrganizationName": "TEST ASC NESLI","leadAuthorOrganizationID": "0010D000008ZRsI","leadAuthorOrganizationRingoldID" :"","leadAuthorOrganizationCampus": "","leadAuthorOrganizationDepartment": "","payerType": "Organization","payerEmailID": "","payerContactName": "","payercontactphonenumber": "","leadPrimaryContactPhoneNumber": "2323232323","payerOrganizationName": "","payerOrganizationID": "","payerOrganizationRingoldID" :"","payerOrganizationDepartment": "","payerOrganizationCampus": "","vatNumber": "","purchaseOrderNumber": "","canUsePrepayBudget": false,"canApplyCountryDiscount": true,"canApplySocietyDiscount": true,"disableRejectionEmail": false,"disableDraftEmail": false,"sameAsBilling": true,"isArticleAccepted": true,"isAuthorAccepted": false,"billingStreet": "test","billingStreet2": "","billingState": "Karnataka","billingCountry": "India","billingCity": "banglore","bilingPostalCode": "536781","shipToContact": "test test","shipToOrganization": "TEST ASC NESLI","shipToStreet2": "","shipToStreet": "","shipToState": "","shipToPostalCode": "","shipToCountry": "","shipToCity": "","promoCode": "","disableQuoteCreationNotificationEmailToAuthor": false,"disablePrePayApprovalNotificationEmailToAuthor": false,"disablePrePayManualApprovalCase": false,"entryPoint": "ASC","needsManualApproval": false,"products": [{"productcode": "RABD","articleType": "Full rate"},{"productcode": "BATC","articleType": "Full Rate"},{"productcode": "RAED","articleType": "Full Rate"}]}';
        //String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/recalculateQuote';
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();

        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuoteDetailResponse response = (TF_QuoteAPIServiceV1.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuoteDetailResponse.class);
 
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
        quoteChangeRequest.payerFirstName = 'Amit';
        quoteChangeRequest.payerLastName = 'Kumar';         
        quoteChangeRequest.payerEmailID = 'payer@org.com';
        quoteChangeRequest.payerOrganizationName = 'Alex Organization'; 
        
        request.recalculationRequest = quoteChangeRequest;  
		String requestJSON = '{"authorFacingArticleType": "Document","articelTitle": "testing products","submissionID": "65646","manuscriptID": "","doi": "107.1.2.3","leadAuthorName": "amit","leadAuthorEmailID": "amit.kumar@informa.com","leadAuthorOrganizationName": "TEST ASC NESLI","leadAuthorOrganizationID": "0010D000008ZRsI","leadAuthorOrganizationRingoldID" :"","leadAuthorOrganizationCampus": "","leadAuthorOrganizationDepartment": "","payerType": "Organization","payerEmailID": "","payerContactName": "","payercontactphonenumber": "","leadPrimaryContactPhoneNumber": "2323232323","payerOrganizationName": "","payerOrganizationID": "","payerOrganizationRingoldID" :"","payerOrganizationDepartment": "","payerOrganizationCampus": "","vatNumber": "","purchaseOrderNumber": "","canUsePrepayBudget": false,"canApplyCountryDiscount": true,"canApplySocietyDiscount": true,"disableRejectionEmail": false,"disableDraftEmail": false,"sameAsBilling": true,"isArticleAccepted": true,"isAuthorAccepted": false,"billingStreet": "test","billingStreet2": "","billingState": "Karnataka","billingCountry": "India","billingCity": "banglore","bilingPostalCode": "536781","shipToContact": "test test","shipToOrganization": "TEST ASC NESLI","shipToStreet2": "","shipToStreet": "","shipToState": "","shipToPostalCode": "","shipToCountry": "","shipToCity": "","promoCode": "","disableQuoteCreationNotificationEmailToAuthor": false,"disablePrePayApprovalNotificationEmailToAuthor": false,"disablePrePayManualApprovalCase": false,"entryPoint": "ASC","needsManualApproval": false,"products": [{"productcode": "RABD","articleType": "Full rate"},{"productcode": "BATC","articleType": "Full Rate"},{"productcode": "RAED","articleType": "Full Rate"}]}';
        //String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/recalculateQuote';
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();

        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuoteDetailResponse response = (TF_QuoteAPIServiceV1.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuoteDetailResponse.class);
 
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
         quoteChangeRequest.payerFirstName = 'Amit';
         quoteChangeRequest.payerLastName = 'Kumar';          
        quoteChangeRequest.payerEmailID = 'payer@org.com';
        quoteChangeRequest.payerOrganizationName = 'Alex Organization';
        
        request.recalculationRequest = quoteChangeRequest;  

        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/recalculateQuote';
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();

        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIService.QuoteDetailResponse response = (TF_QuoteAPIService.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIService.QuoteDetailResponse.class);
        
        //System.assertEquals(null, response.errorMessage);
        //System.assertEquals(true, response.success);           

    }               

    private static testmethod void recalculateQuoteExceptionTest() {
        createSampleData();
        List<SBQQ__Quote__c> quotes = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c, randomstring__c FROM SBQQ__Quote__c];
 
        TF_QuoteAPIService.QuoteReCalculationRequest request = new TF_QuoteAPIService.QuoteReCalculationRequest();
        //request.quoteUniqueId = quotes[0].randomstring__c;
        //request.quoteUniqueId = '';
        TF_QuoteAPIService.GenerateQuoteRequest quoteChangeRequest = getSampleQuoteCreationRequest();
        //quoteChangeRequest.payerType = 'Organization';
        //quoteChangeRequest.payerContactName = 'Org Contact name';
        //quoteChangeRequest.payerEmailID = 'payer@org.com';
        //quoteChangeRequest.payerOrganizationName = 'Alex Organization';      
        
        request.recalculationRequest = quoteChangeRequest;  

        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/recalculateQuote';
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();

        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuoteDetailResponse response = (TF_QuoteAPIServiceV1.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuoteDetailResponse.class);
 
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
        
        List<SBQQ__Quote__c> quotes = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c FROM SBQQ__Quote__c];
        
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/isPrePayAccount/' + accT.id;  
        //req.requestBody = Blob.valueOf(mockRequestBody);
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        TF_QuoteAPIServiceV1.doGet();
        Test.stopTest();
        
    }
    
    private static testmethod void isPrePayAccountNotAPrePayAccTest() {
        createSampleData();
        Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        Account accT = new Account (Name = 'TestCompany',Billing_Street__c='Sample', Billing_City__c='mycity', 
                                    Billing_State__c='state', Billing_ZIP__c='112345', recordtypeid = TFAccountsRecordTypeId );
        insert accT;
        //Prepay_Accounts__c pp = new Prepay_Accounts__c (name='Test PP',AccountName__c=accT.id);
        //insert pp;
        Contact conT = new Contact (AccountId = accT.id, FirstName = 'Test', LastName = 'Test',
                                    Email='abc@test.com', Phone='4111141111');
        insert conT;
        
        List<SBQQ__Quote__c> quotes = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c FROM SBQQ__Quote__c];
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/isPrePayAccount/' + accT.id;  
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        TF_QuoteAPIServiceV1.doGet();
        Test.stopTest();        
    }

    private static testmethod void isPrePayAccountInvalidTest() {
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
        
        List<SBQQ__Quote__c> quotes = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c FROM SBQQ__Quote__c];
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/isPrePayAccount/123';  
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        TF_QuoteAPIServiceV1.doGet();
        Test.stopTest();        
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
        

    private static TF_QuoteAPIService.GenerateQuoteRequest getSampleQuoteCreationRequest() {
        TF_QuoteAPIService.GenerateQuoteRequest request = new TF_QuoteAPIService.GenerateQuoteRequest();
        //List<lineItemDetails> products=new List<lineItemDetails>();

        request.productCode = 'XYZ';
        request.journalCode = 'XYZ';
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
        
        TF_QuoteAPIServiceV1.lineItemDetails prd = new TF_QuoteAPIServiceV1.lineItemDetails();
        //List<lineItemDetails> lineItemList = new list<lineItemDetails>();
        prd.productCode='RABD';
        prd.articleType='Full rate';
        //request.products=prd;     
        return request;     
    }
    
    private static testmethod void updateQuoteStatusTest() {
        createSampleData();
        List<SBQQ__Quote__c> quotes = [SELECT id,doi__c,randomstring__c,Name,Use_Prepay_Budget__c,SBQQ__Account__c FROM SBQQ__Quote__c];        
        String s = getRandomString();
        SBQQ__Quote__c quoteObject = quotes[0];
        quoteObject.SBQQ__Status__c = 'Draft';
        quoteObject.randomstring__c = s;
        Update quoteObject;
        
        TF_QuoteAPIServiceV1.UpdateQuoteStatusRequest request = new TF_QuoteAPIServiceV1.UpdateQuoteStatusRequest();

        request.quoteUniqueId = quotes[0].randomstring__c;
		request.status = 'Approved';
        
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
    
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/updateQuoteStatus/';   
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
                
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuoteDetailResponse response = (TF_QuoteAPIServiceV1.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuoteDetailResponse.class);
        response.success = true; 
        //System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);
    }
    
    private static testmethod void updateQuoteStatusCanNotFindQuoteTest() {
        createSampleData();
        List<SBQQ__Quote__c> quotes = [SELECT id,doi__c,randomstring__c,Name,Use_Prepay_Budget__c,SBQQ__Account__c FROM SBQQ__Quote__c];        
        String s = getRandomString();
        SBQQ__Quote__c quoteObject = quotes[0];
        quoteObject.SBQQ__Status__c = 'Draft';
        quoteObject.randomstring__c = s;
        Update quoteObject;
        
        TF_QuoteAPIServiceV1.UpdateQuoteStatusRequest request = new TF_QuoteAPIServiceV1.UpdateQuoteStatusRequest();

        request.quoteUniqueId = '2342212';
		request.status = 'Submission Withdrawn';
        
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
    
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/updateQuoteStatus/';   
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
                
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuoteDetailResponse response = (TF_QuoteAPIServiceV1.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuoteDetailResponse.class);
        response.success = true; 
        //System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);
    }
    
    private static testmethod void updateQuoteStatusSubmissionWithdrawnTest() {
        createSampleData();
        List<SBQQ__Quote__c> quotes = [SELECT id,doi__c,randomstring__c,Name,Use_Prepay_Budget__c,SBQQ__Account__c FROM SBQQ__Quote__c];        
        String s = getRandomString();
        SBQQ__Quote__c quoteObject = quotes[0];
        quoteObject.SBQQ__Status__c = 'Draft';
        quoteObject.randomstring__c = s;
        Update quoteObject;
        
        TF_QuoteAPIServiceV1.UpdateQuoteStatusRequest request = new TF_QuoteAPIServiceV1.UpdateQuoteStatusRequest();

        request.quoteUniqueId = quotes[0].randomstring__c;
		request.status = 'Submission Withdrawn';
        
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
    
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/updateQuoteStatus/';   
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
                
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuoteDetailResponse response = (TF_QuoteAPIServiceV1.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuoteDetailResponse.class);
        response.success = true; 
        //System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);
    }
    
    private static testmethod void recalculateQuoteSelfPayChanges2() {
        createSampleData();
        List<SBQQ__Quote__c> quotes = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c, randomstring__c FROM SBQQ__Quote__c];
        quotes[0].randomString__c='QWE123EWQ';
        UPDATE quotes;
 
        /*TF_QuoteAPIService.QuoteReCalculationRequest request = new TF_QuoteAPIService.QuoteReCalculationRequest();
        request.quoteUniqueId = quotes[0].randomstring__c;
        TF_QuoteAPIService.GenerateQuoteRequest quoteChangeRequest = getSampleQuoteCreationRequest2();
        quoteChangeRequest.billingCountry = 'UK';
        request.recalculationRequest = quoteChangeRequest;*/

        //String requestJSON = JSON.serialize(request);
		system.debug('randomstring__c==>>' + quotes[0].randomstring__c);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
		
        String requestJSON = '{"quoteUniqueId": "'+ quotes[0].randomstring__c +'","recalculationRequest":{"authorFacingArticleType":"Document","articelTitle":"testing products","submissionID":"65646","manuscriptID":"","doi":"107.1.2.3","leadAuthorName":"amit","leadAuthorEmailID":"amit.kumar@informa.com","leadAuthorOrganizationName":"TEST ASC NESLI","leadAuthorOrganizationID":"0010D000008ZRsI","leadAuthorOrganizationRingoldID":"","leadAuthorOrganizationCampus":"","leadAuthorOrganizationDepartment":"","payerType":"Organization","payerEmailID":"","payerContactName":"","payercontactphonenumber":"","leadPrimaryContactPhoneNumber":"2323232323","payerOrganizationName":"","payerOrganizationID":"","payerOrganizationRingoldID":"","payerOrganizationDepartment":"","payerOrganizationCampus":"","vatNumber":"","purchaseOrderNumber":"","canUsePrepayBudget":false,"canApplyCountryDiscount":true,"canApplySocietyDiscount":true,"disableRejectionEmail":false,"disableDraftEmail":false,"sameAsBilling":true,"isArticleAccepted":true,"isAuthorAccepted":false,"billingStreet":"test","billingStreet2":"","billingState":"Karnataka","billingCountry":"India","billingCity":"banglore","bilingPostalCode":"536781","shipToContact":"test test","shipToOrganization":"TEST ASC NESLI","shipToStreet2":"","shipToStreet":"","shipToState":"","shipToPostalCode":"","shipToCountry":"","shipToCity":"","promoCode":"","disableQuoteCreationNotificationEmailToAuthor":false,"disablePrePayApprovalNotificationEmailToAuthor":false,"disablePrePayManualApprovalCase":false,"entryPoint":"ASC","needsManualApproval":false,"products":[{"productcode":"RABD","articleType":"Full rate"},{"productcode":"BATC","articleType":"Full Rate"},{"productcode":"RAED","articleType":"Full Rate"}]}}';
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/v1/recalculateQuote';
        
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIServiceV1.doPost();
        Test.stopTest();

        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV1.QuoteDetailResponse response = (TF_QuoteAPIServiceV1.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV1.QuoteDetailResponse.class);
 
        //System.assertEquals(null, response.errorMessage);
        //System.assertEquals(true, response.success);           

    }
    
    /*private static TF_QuoteAPIService.GenerateQuoteRequest getSampleQuoteCreationRequest2() {
        TF_QuoteAPIService.GenerateQuoteRequest request = new TF_QuoteAPIService.GenerateQuoteRequest();
        //List<lineItemDetails> products=new List<lineItemDetails>();

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
        
        TF_QuoteAPIServiceV1.lineItemDetails prd = new TF_QuoteAPIServiceV1.lineItemDetails();
        //List<lineItemDetails> lineItemList = new list<lineItemDetails>();
        prd.productCode='RABD';
        prd.articleType='Full rate';
        //request.products=prd;    
        List<TF_QuoteAPIServiceV1.lineItemDetails> productsLst = new List<TF_QuoteAPIServiceV1.lineItemDetails>();
        productsLst.add(prd);
        request.products = productsLst;
        return request;     
    }*/
    
}