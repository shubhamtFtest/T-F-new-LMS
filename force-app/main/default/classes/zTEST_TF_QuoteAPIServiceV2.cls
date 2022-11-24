@isTest
private class zTEST_TF_QuoteAPIServiceV2 {

    private static final String baseUrl = Url.getSalesforceBaseUrl().toExternalForm();
    
    private static String getRandomString() {
        Blob b = Crypto.GenerateAESKey(256);
        String h = EncodingUtil.base64Encode(b);
        return h.remove(' ').remove('/').remove('+').remove('=').substring(0, 25);      
    }
	
    private static testmethod void testMethod_QuoteAPIServiceV3(){
        Account accObject = new Account(Name = 'Test Account',Type = 'Consortium',Manual_Check__c = True , Ringgold_Account_ID__c='937483'); 
        insert accObject;
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
                                           Family = 'Journal Service Product');  
        insert prodObject;  
        Id promoCodeRecTypeId = Schema.SObjectType.Sales_Deal__c.getRecordTypeInfosByName().get('Promocode Deal').getRecordTypeId();      
        Sales_Deal__c sd = new Sales_Deal__c(Deal_Name__c='test name',Start_Date__c=date.today(),End_Date__c=date.today()+50,Type_of_Deal__c='APC Deal',Promocode__c='testCode',Discount_Category__c='Ad hoc', RecordTypeId= promoCodeRecTypeId,Product__c=prodObject.id);
        insert sd;
        //List<Deal_Member__c> dmLst = new List<Deal_Member__c>();
        Deal_Member__c dm = new Deal_Member__c(Sales_Deal__c=sd.Id, Account__c=accObject.Id,Type__c='Institution');
        insert dm;    
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(
            Payer_Account__c = accObject.Id, SBQQ__ExpirationDate__c = date.today()+20, Use_Prepay_Budget__c = true,
            Article_Acceptance_Status__c = 'Accepted',Primary_Contact_s_email_id__c='test@test.com',randomstring__c = 'test',
            Order_Hub_Number__c='ODR881153');       
        insert quoteObject;
        SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteObject.Id, SBQQ__Product__c = prodObject.Id, Discount_Rules_Applied__c = 'Prepay');
        insert quoteLineObject;
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/quoteServiceV3/test';
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        
        TF_QuoteAPIServiceV3.doGet();                
        Test.stopTest();                         
    }
    
    private static testmethod void coverCpqApiDataModel(){
        CPQ_ApiDataModels.CalculatorContext calculatorPayload = new CPQ_ApiDataModels.CalculatorContext();
    }
    
    private static testmethod void createTestDataToUpdateInvoiceNumber(){
        String uniqueId = getRandomString();
        String priceBookName = 'T&F CPQ Price Book 2017';
        Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        
        Quote_Service_Settings__c customSetting = new Quote_Service_Settings__c(Name = 'Informa Plc', Product_Family__c = 'Journals-Author Side Charges', CPQ_PriceBook__c = priceBookName);
        insert customSetting;        
            
        Account accObject = new Account(Name = 'Test Account',RecordTypeId = TFAccountsRecordTypeId,Type = 'Customer',Manual_Check__c = True , Ringgold_Account_ID__c='937483'); 
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
                                    Family = 'Journal Service Product');  
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
                Article_Acceptance_Status__c = 'Accepted',Primary_Contact_s_email_id__c='test@test.com',randomstring__c = 'test',
            Order_Hub_Number__c='ODR881153');       
        insert quoteObject;

      //added by jaipal - start
         User usr = new User(FirstName = 'My', LastName = 'User',  Alias = 'myuse', Email = 'my.user@email.com',
                           Username = 'my.user@email.com', CommunityNickname = 'MyUser',
                           ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id, TimeZoneSidKey = 'Europe/Rome',
                           LocaleSidKey = 'IT', EmailEncodingKey = 'UTF-8',
                           LanguageLocaleKey = 'it', IsActive = true);
        system.debug(usr);
        insert usr;
        EmailTemplate e = new EmailTemplate (developerName = 'test',FolderId = userInfo.getUserId(),  TemplateType= 'Text', Name = 'test');
        system.runAs(usr) {          
            
            insert e;
        }
        Id promoCodeRecTypeId = Schema.SObjectType.Sales_Deal__c.getRecordTypeInfosByName().get('Promocode Deal').getRecordTypeId();      
        Sales_Deal__c sd = new Sales_Deal__c(Deal_Name__c='test name',Start_Date__c=date.today(),End_Date__c=date.today()+50,Type_of_Deal__c='APC Deal',Promocode__c='testCode',Discount_Category__c='Ad hoc', RecordTypeId= promoCodeRecTypeId,Product__c=prodObject.id);
        insert sd;
        //List<Deal_Member__c> dmLst = new List<Deal_Member__c>();
        Deal_Member__c dm = new Deal_Member__c(Sales_Deal__c=sd.Id, Account__c=accObject.Id,Type__c='Institution');
        insert dm;        
       
        
            
         
      /* EmailTemplate e = new EmailTemplate (developerName = 'test',  TemplateType= 'Text', Name = 'test');
       	insert e;*/
        
       //TF_QuoteAPIServiceV2.emailTrigger(quoteObject.id,e.name); commented by jaipal
        SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteObject.Id, SBQQ__Product__c = prodObject.Id, Discount_Rules_Applied__c = 'Prepay');
        insert quoteLineObject;
       String json=		'{'+
		' "source": "SP",'+
		' "identifiers": {'+
		' "submissionId": "201156331"'+
		' },'+
		' "customer": {'+
		' "partyId": "12121",'+
		' "name": "Ashish D",'+
		' "customerType": "INDIVIDUAL",'+
		' "typeOfPayer": "Self",'+
		' "campus": "",'+
		' "department": ""'+
		' },'+
		' "contact": {'+
		' "firstName": "Ashish",'+
		' "lastName": "D",'+
		' "email": "ashishdev094@gmail.com",'+
		' "phoneNumber": "12312342"'+
		' },'+
		' "billingAddress": {'+
		' "name": "Ashish D",'+
		' "street1": "143, 144, Hosur Main Road",'+
		' "street2": "",'+
		' "city": "Bangalore",'+
		' "state": "Karnataka",'+
		' "stateISO": "",'+
		' "countryCode": "India",'+
		' "country": "India",'+
		' "postalCode": "560095",'+
		' "bpNumber": "00023736273",'+
		' "taxRegistrationNumber": "",'+
		' "taxCategory": ""'+
		' },'+
		' "shippingAddress": {'+
		' "name": "Ashish D",'+
		' "street1": "143, 144, Hosur Main Road",'+
		' "street2": "",'+
		' "city": "Bangalore",'+
		' "state": "Karnataka",'+
		' "country": "India",'+
		' "stateISO": "",'+
		' "countryCode": "India",'+
		' "postalCode": "560095",'+
		' "bpNumber": "00023736273"'+
		' },'+
		' "discountParam": {'+
		' "promoCode": null,'+
		' "applyCountryDiscount": true,'+
		' "applyPrepayDiscount": false,'+
		' "additionalDiscountRequest": {}'+
		' },'+
		' "services":['+
		'      {'+
		'         "serviceId":"92e531c8",'+
		'         "parentProductId":"6e237022-0f4d-4ca7-9468-30fc89388ff3"'+
		'      }'+
		'   ],'+
		' "products": ['+
		' "6e237022-0f4d-4ca7-9468-30fc89388ff3"'+
		' ],'+
		' "leadAuthor": {'+
		' "name": "Ashish Dev",'+
		' "email": "ashish.kumardev@informa.com",'+
		' "phoneNumber": "9620000601"'+
		' },'+
		' "organization": {'+
		' "partyId": "1112",'+
		' "ringGoldId": "230635",'+
		' "name": "National Institute of Technology, Patna",'+
		' "campus": "test",'+
		' "department": "test"'+
		' },'+
		' "productDetails": {'+
		' "type": "Article",'+
		' "title": "Title ttest title",'+
		' "status": "accepted",'+
		' "displayType ": "Short communication"'+
		' },'+
		' "attachments": ['+
		' {'+
		' "name": "ID Card",'+
		' "description": "My colleage Photo ID Card",'+
		' "path": "/OA/idcard.pdf"'+
		' },'+
		' {'+
		' "name": "Mark Sheet",'+
		' "description": "Consolidated Mark seet",'+
		' "path": "/OA/marksheet.pdf"'+
		' }'+
		' ]'+
		'}';
        TF_QuoteAPIServiceV2.generateQuoteDetailResponse1(quoteObject.id);
        TF_QuoteAPIServiceV2.updateQuote(json,'test');
         RestRequest req = new RestRequest();
         RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/QuoteServiceV2/937483';
        req.httpMethod = 'GET';

        RestContext.request = req;
        RestContext.response= res;
		
       TF_QuoteAPIServiceV2.doGet();
        
        //added by jaipal - end
       
     	/* Deal_Member__c dm1=new Deal_Member__c(Sales_Deal__c=sd.Id,Account__c=accObject.Id,Type__c='Institution');
        
		insert dm1;  
       
         Deal_Member__c dm01 = new Deal_Member__c(Sales_Deal__c=sd.Id, Account__c=accObject.Id,Type__c='Institution',Deal_Member__c = dm.Id);
        insert dm01;
        Deal_Member__c dm02 = new Deal_Member__c(Sales_Deal__c=sd.Id, Account__c=accObject.Id,Type__c='Institution', Deal_Member__c = dm01.Id);
        insert dm02;
        
         RestRequest req1 = new RestRequest();
         RestResponse res1 = new RestResponse();
        req1.requestURI = '/services/apexrest/QuoteServiceV2/937483';
        req1.httpMethod = 'GET';

        RestContext.request = req1;
        RestContext.response= res1;

        TF_QuoteAPIServiceV2.doGet(); */
        
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

    private static void sampleDataForSalesDeal(){
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
                                    Family = 'Journal Service Product');  
        insert prodObject;  
        Id promoCodeRecTypeId = Schema.SObjectType.Sales_Deal__c.getRecordTypeInfosByName().get('Promocode Deal').getRecordTypeId();      
        Sales_Deal__c sd = new Sales_Deal__c(Deal_Name__c='test name',Start_Date__c=date.today(),End_Date__c=date.today()+50,Type_of_Deal__c='APC Deal',Promocode__c='testCode',Discount_Category__c='Ad hoc', RecordTypeId= promoCodeRecTypeId,Product__c=prodObject.id);
        insert sd;
        Deal_Discount__c dd = new Deal_Discount__c(Discount_Value_Percentage__c=20,Sales_Deal__c=sd.id);
        insert dd;
    }

    private static testmethod void checkPromoCode() {
        sampleDataForCPQDiscountConfigurations();
        sampleDataForSalesDeal();
      /*  List<CPQ_Discount_Configuration__c> cpqDiscConfig = [SELECT id,Promocode__c,Product_Code__c,Start_Date__c,End_Date__c FROM CPQ_Discount_Configuration__c];        
        salesDealObj = [SELECT Id,Discount_Category__c,Promocode__c,Start_Date__c,End_Date__c,Active__c,
                                    (SELECT Id,Discount_Value_Percentage__c FROM Deal_Discounts__r) 
                            FROM Sales_Deal__c  
                            WHERE RecordTypeId = :promoCodeRecTypeId 
                            AND (Promocode__c = :request.promoCode AND Product_Code__c = :request.productCode) limit 1];
       */
        
        List<Sales_Deal__c> sdInsert = [select id,Product_Code__c,Promocode__c from Sales_Deal__c ];
        system.debug('@sd@'+sdInsert);
        List<Deal_Discount__c> ddInsert = [select id,Discount_Value_Percentage__c from Deal_Discount__c];
        system.debug('@dd@'+ddInsert);
        TF_QuoteAPIServiceV2.QuotePromoCodeRequest request = new TF_QuoteAPIServiceV2.QuotePromoCodeRequest();
        request.productCode = sdInsert[0].Product_Code__c;
        request.promoCode = sdInsert[0].Promocode__c;
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
        TF_QuoteAPIServiceV2.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV2.QuotePromoCodeResponse response = (TF_QuoteAPIServiceV2.QuotePromoCodeResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV2.QuotePromoCodeResponse.class);
        
        System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);  
    }

    private static testmethod void checkPromoCodeIsInactivePromoCode() {
      /*  String priceBookName = 'T&F CPQ Price Book 2017';
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
        */
        sampleDataForCPQDiscountConfigurations();
        sampleDataForSalesDeal();
        List<Sales_Deal__c> sdInsert = [select id,Product_Code__c,Active__c,Promocode__c from Sales_Deal__c ];
        system.debug('@sd@'+sdInsert);
        sdInsert[0].Active__c = false;
        update sdInsert[0];
        List<Deal_Discount__c> ddInsert = [select id,Discount_Value_Percentage__c from Deal_Discount__c];
        system.debug('@dd@'+ddInsert);
        TF_QuoteAPIServiceV2.QuotePromoCodeRequest request = new TF_QuoteAPIServiceV2.QuotePromoCodeRequest();
        request.productCode = sdInsert[0].Product_Code__c;
        request.promoCode = sdInsert[0].Promocode__c;
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
        TF_QuoteAPIServiceV2.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV2.QuotePromoCodeResponse response = (TF_QuoteAPIServiceV2.QuotePromoCodeResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV2.QuotePromoCodeResponse.class);
        
        System.assertEquals('Not an active promo code.', response.errorMessage);
        System.assertEquals(false, response.success);  
    }

    private static testmethod void checkPromoCodeIsPromoCodeIsExpired() {
      /*  String priceBookName = 'T&F CPQ Price Book 2017';
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
        */
        sampleDataForCPQDiscountConfigurations();
        sampleDataForSalesDeal();
        List<Sales_Deal__c> sdInsert = [select id,Product_Code__c,Active__c,Promocode__c from Sales_Deal__c ];
        system.debug('@sd@'+sdInsert);
        sdInsert[0].Start_Date__c = date.today()-10;
        sdInsert[0].End_Date__c = date.today()-3;
        update sdInsert[0];
        List<Deal_Discount__c> ddInsert = [select id,Discount_Value_Percentage__c from Deal_Discount__c];
        TF_QuoteAPIServiceV2.QuotePromoCodeRequest request = new TF_QuoteAPIServiceV2.QuotePromoCodeRequest();
        request.productCode = sdInsert[0].Product_Code__c;
        request.promoCode = sdInsert[0].Promocode__c;
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
        TF_QuoteAPIServiceV2.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV2.QuotePromoCodeResponse response = (TF_QuoteAPIServiceV2.QuotePromoCodeResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV2.QuotePromoCodeResponse.class);
        
        System.assertEquals('Promo code has expired.', response.errorMessage);
        System.assertEquals(false, response.success);  
    }

    private static testmethod void checkPromoCode_Adhoc() {
      /*  String priceBookName = 'T&F CPQ Price Book 2017';
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
        */
        sampleDataForCPQDiscountConfigurations();
        sampleDataForSalesDeal();
        List<Sales_Deal__c> sdInsert = [select id,Discount_Category__c,Product_Code__c,Active__c,Promocode__c from Sales_Deal__c ];
        system.debug('@sd@'+sdInsert);
        sdInsert[0].Discount_Category__c ='Ad hoc';
       // sdInsert[0].End_Date__c = date.today()-3;
        update sdInsert[0];
        List<Deal_Discount__c> ddInsert = [select id,Discount_Value_Percentage__c from Deal_Discount__c];
        TF_QuoteAPIServiceV2.QuotePromoCodeRequest request = new TF_QuoteAPIServiceV2.QuotePromoCodeRequest();
        request.productCode = sdInsert[0].Product_Code__c;
        request.promoCode = sdInsert[0].Promocode__c;
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
        TF_QuoteAPIServiceV2.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV2.QuotePromoCodeResponse response = (TF_QuoteAPIServiceV2.QuotePromoCodeResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV2.QuotePromoCodeResponse.class);
        
        System.assertEquals('Not a valid promo code. Invalid payer type.', response.errorMessage);
        System.assertEquals(false, response.success);  
    }

  /*  private static testmethod void checkPromoCodeInvalidPromoOrProduct() {
        sampleDataForCPQDiscountConfigurations();
        List<CPQ_Discount_Configuration__c> cpqDiscConfig = [SELECT id,Promocode__c,Product_Code__c,Start_Date__c,End_Date__c FROM CPQ_Discount_Configuration__c];        
        TF_QuoteAPIServiceV2.QuotePromoCodeRequest request = new TF_QuoteAPIServiceV2.QuotePromoCodeRequest();
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
        TF_QuoteAPIServiceV2.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV2.QuotePromoCodeResponse response = (TF_QuoteAPIServiceV2.QuotePromoCodeResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV2.QuotePromoCodeResponse.class);
        
        System.assertEquals('Invalid promo code / invalid product code.', response.errorMessage);  
    }
    
    private static testmethod void checkPromoCodeCheckInputs() {
        sampleDataForCPQDiscountConfigurations();
        List<CPQ_Discount_Configuration__c> cpqDiscConfig = [SELECT id,Promocode__c,Product_Code__c,Start_Date__c,End_Date__c FROM CPQ_Discount_Configuration__c];        
        TF_QuoteAPIServiceV2.QuotePromoCodeRequest request = new TF_QuoteAPIServiceV2.QuotePromoCodeRequest();
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
        TF_QuoteAPIServiceV2.doPost();
        Test.stopTest();
        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV2.QuotePromoCodeResponse response = (TF_QuoteAPIServiceV2.QuotePromoCodeResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV2.QuotePromoCodeResponse.class);
        
        System.assertEquals('Invalid input request.', response.errorMessage);
        System.assertEquals(false, response.success);  
    }
    
    */

    
    
  
    
    private static testmethod void getQuoteTest() {
        createSampleData();
        EmailTemplate validEmailTemplate = new EmailTemplate();
        validEmailTemplate.isActive = true;
        validEmailTemplate.Name = 'name';
        validEmailTemplate.DeveloperName = 'unique_name_addSomethingSpecialHere';
        validEmailTemplate.TemplateType = 'text';
        validEmailTemplate.FolderId = UserInfo.getUserId();
        
        insert validEmailTemplate;    
        List<SBQQ__Quote__c> quotes = [SELECT id,randomstring__c,Name,Use_Prepay_Budget__c,SBQQ__Account__c FROM SBQQ__Quote__c];
        // -- Create a request object -- //
        TF_QuoteAPIServiceV2.QuoteRequest request = new TF_QuoteAPIServiceV2.QuoteRequest();
        request.quoteId = quotes[0].randomstring__c;//quotes[0].id;
        request.quoteUniqueId = quotes[0].randomstring__c;
        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/emailTrigger';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIServiceV2.doPost();

        Test.stopTest();

        String responeJSON = RestContext.response.responseBody.toString();
       // TF_QuoteAPIServiceV2.QuoteDetailResponse response = (TF_QuoteAPIServiceV2.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV2.QuoteDetailResponse.class);
 
       // System.assertEquals(null, response.errorMessage);
       // System.assertEquals(true, response.success);        
                
    }

    private static testmethod void generateQuoteSelfPayTest() {
        createSampleData();
        product2 prod = [Select id,Hub_Id__c,Family from Product2 ];
        prod.Hub_Id__c = '92e531c8';
        prod.Family = 'Journal Service Product';
        update prod;
        Account acc = [Select id,Ringgold_Account_ID__c from Account ];
        acc.Ringgold_Account_ID__c = '12';
        
        update acc;
        // -- Create a request object -- //
        system.debug('check123');
  TF_QuoteAPIServiceV2.GenerateQuoteRequestNew request = new TF_QuoteAPIServiceV2.GenerateQuoteRequestNew();
        TF_QuoteAPIServiceV2.identifiers identifier = new TF_QuoteAPIServiceV2.identifiers();
        TF_QuoteAPIServiceV2.customer customer = new TF_QuoteAPIServiceV2.customer();
        TF_QuoteAPIServiceV2.contact contact = new TF_QuoteAPIServiceV2.contact();
        TF_QuoteAPIServiceV2.billingAddress billingAddress = new TF_QuoteAPIServiceV2.billingAddress();
        TF_QuoteAPIServiceV2.shippingAddress shippintAddress = new TF_QuoteAPIServiceV2.shippingAddress();
        TF_QuoteAPIServiceV2.discountParam discountParam = new TF_QuoteAPIServiceV2.discountParam();
        TF_QuoteAPIServiceV2.additionalDiscountRequest additioanDiscountRequest = new TF_QuoteAPIServiceV2.additionalDiscountRequest();
        TF_QuoteAPIServiceV2.priceDiscount priceDiscount = new TF_QuoteAPIServiceV2.priceDiscount();
        List<TF_QuoteAPIServiceV2.services> services = new List<TF_QuoteAPIServiceV2.services>();
        TF_QuoteAPIServiceV2.services services1 = new TF_QuoteAPIServiceV2.services();
      //  List<TF_QuoteAPIServiceV2.GenerateQuoteRequestNew.products> products = new List<TF_QuoteAPIServiceV2.GenerateQuoteRequestNew.products>();
        TF_QuoteAPIServiceV2.leadAuthor leadAuthor = new TF_QuoteAPIServiceV2.leadAuthor();
        TF_QuoteAPIServiceV2.organization organization = new TF_QuoteAPIServiceV2.organization();
        TF_QuoteAPIServiceV2.productDetails productDetails = new TF_QuoteAPIServiceV2.productDetails();
        List<TF_QuoteAPIServiceV2.attachments> attachments = new List<TF_QuoteAPIServiceV2.attachments>();
        TF_QuoteAPIServiceV2.attachments attachments1 = new TF_QuoteAPIServiceV2.attachments();
        TF_QuoteAPIServiceV2.productDetails  po=new TF_QuoteAPIServiceV2.productDetails ();
        TF_QuoteAPIServiceV2.identifiers   identifiers=new TF_QuoteAPIServiceV2.identifiers();

        po.type ='Article';
        
        if(request != null){
            request.source ='ASC/OAD/SP';
            
          //  sObject ob = new sObject();
            
            identifier.doi = '12345';
            identifier.manuscriptID = '67890';
            identifier.submissionID = '121212';
            identifier.invoiceNumber = '475830234';
            identifier.onboardingRequestId = '12122';
            identifier.purchaseOrderNumber = '475830234';
            identifier.ecsuniqueid = '';
            request.identifiers = identifier;
            customer.partyId ='12121';
            customer.ringGoldId ='12';
            customer.name ='University Of Eastern Finland';
            customer.customerType ='ORGANIZATION';
            customer.typeOfPayer ='Organisation';
            customer.campus ='';
            customer.department ='';
            request.customer = customer;

            contact.firstName = 'Henry';
            contact.lastName = 'D Jacob';
            contact.email = 'henry.jacob@informa.com';
            contact.phoneNumber = '12312342';
            request.contact = contact; 

            billingAddress.name ='J, Sukumar';
            billingAddress.street1 = 'billing street 1';
            billingAddress.street2 = 'billing street 2';
            billingAddress.city = 'billing city';
            billingAddress.state = 'billing state';
           // billingAddress.stateISD ='';
            billingAddress.countrycode = '';
            billingAddress.country = 'USA';
            billingAddress.postalCode = 'billing 1234';
            billingAddress.bpNumber ='00023736273';
            billingAddress.taxRegistrationNumber ='';
            billingAddress.taxCategory = '';
            request.billingAddress = billingAddress;
            shippintAddress.name ='Henry D jacob';
            //shippintAddress.street1 = 'billing street 1'; 
            //shippintAddress.street2 = 'billing street 2';
            shippintAddress.city = 'billing city';
            shippintAddress.state = 'billing state';
            shippintAddress.country = 'USA';
            //shippintAddress.stateISD ='';
            shippintAddress.countrycode ='';
            shippintAddress.postalCode = 'billing 1234';
            shippintAddress.bpNumber = '';
            request.shippingAddress = shippintAddress;
            
            discountParam.promoCode ='TPMR100-2017-E39F';
            discountParam.applyCountryDiscount = false;
          //  discountParam.applayPrepayDiscount = false;
            
            priceDiscount.price =100;
            priceDiscount.currencyIsoCode ='USD';
            
            additioanDiscountRequest.percentageDiscount ='10';
            additioanDiscountRequest.reason ='Phd student';
            request.discountParam = discountParam;
            request.discountParam.applyPrepayDiscount=true;
            request.discountParam.additionalDiscountRequest = additioanDiscountRequest;
            request.billingAddress.country='USA';
            //request.discountGenerateQuoteRequestParam.additionalDiscountRequest.priceDiscounts = priceDiscount;
            po.status='Accepted';
            request.productDetails=po;
            services1.serviceId ='92e531c8';
            services1.parentProductID ='0bb41064-48f5-4a07-aebf-01d8e941feb1';
            services.add(services1);
            request.services = services;

            string products = 'bb4de8de-2581-4766-ac18-205cc5084d9b';
            request.products = new List<String>();
            request.products.add(products);

            leadAuthor.name = 'Alex';
            leadAuthor.email ='alex@abc.com';
            leadAuthor.phoneNumber ='9620000601';
            request.leadAuthor = leadAuthor;
            
            organization.partyId = '1112';
            organization.ringGoldId = '12';
            organization.name = 'Cranfield University';
            organization.campus = '';
            organization.Department = '';
            request.organization = organization;

            productDetails.type = 'Full Review with leading authoer';
            productDetails.title = 'My Rhetoric Review';
            productDetails.status = 'accepted';//accepted/rejected - changed by Jaipal
            productDetails.displayType = 'Short communication';
            request.productDetails = productDetails;

            
            attachments1.name ='ID Card';
            attachments1.description ='My colleage Photo ID Card';
            attachments1.path ='/OA/idcard.pdf';
            attachments.add(attachments1);
            request.attachments = attachments;
            
            
            
            
            
        }
       // request.isArticleAccepted = false;   
        system.debug('check913'+request);
    
        List<SBQQ__Quote__c> quotes = [SELECT id,Article_Title__c,PromoCode__c,randomstring__c,Name,Use_Prepay_Budget__c,SBQQ__Account__c FROM SBQQ__Quote__c limit 1];
       	quotes[0].PromoCode__c='TPMR100-2017-E39F';
        TF_QuoteAPIServiceV2.services serv=new TF_QuoteAPIServiceV2.services();
        serv.parentProductID=prod.id;
        request.services=new list<TF_QuoteAPIServiceV2.services>{serv};
        request.customer.typeOfPayer ='Self';
        request.discountParam=discountParam;
        request.productDetails=productDetails;
        request.identifiers=identifiers;
		system.debug('check123'+request);
        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/generateQuote';
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIServiceV2.doPost();
        Test.stopTest();

        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV2.QuoteResponse response = (TF_QuoteAPIServiceV2.QuoteResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV2.QuoteResponse.class);
 
        System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);      

    }
    

    private static testmethod void generateQuoteOrganizationPayTest() {
         createSampleData();
        // -- Create a request object -- //
        product2 prod = [Select id,Hub_Id__c,Family from Product2 ];
        prod.Hub_Id__c = '92e531c8';//Jaipal - 0bb41064-48f5-4a07-aebf-01d8e941feb1
        prod.Family = 'Journal Service Product';
        update prod;
        Account acc = [Select id,Ringgold_Account_ID__c from Account ];
        acc.Ringgold_Account_ID__c = '12';
        
        update acc;
        TF_QuoteAPIServiceV2.GenerateQuoteRequestNew request = getSampleQuoteCreationRequestNewNew();
        request.customer.typeOfPayer = 'Organization';
        
        //request.payerContactName = 'Org Contact name';
        //request.payerEmailID = 'payer@org.com';
        //request.payerOrganizationName = 'Alex Organization';
    ///request.payerOrganizationID = [SELECT ID FROM Account limit 1].Id;
        //request.leadAuthorOrganizationName = 'Lead Org';
        
        
        
        String requestJSON = JSON.serialize(request);

    RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/generateQuote';
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;


        Test.startTest();
        TF_QuoteAPIServiceV2.doPost();
        Test.stopTest();

        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV2.QuoteResponse response = (TF_QuoteAPIServiceV2.QuoteResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV2.QuoteResponse.class);
 
        System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);           
    }
        
    private static testmethod void generateQuoteThirdPartyOrganizationPayTest() {
         createSampleData();
        // -- Create a request object -- //
        product2 prod = [Select id,Hub_Id__c,Family from Product2 ];
        prod.Hub_Id__c = '92e531c8';
        prod.Family = 'Journal Service Product';
        update prod;
        Account acc = [Select id,Ringgold_Account_ID__c from Account ];
        acc.Ringgold_Account_ID__c = '12';
        
        update acc;
        TF_QuoteAPIServiceV2.GenerateQuoteRequestNew request = getSampleQuoteCreationRequestNewNew();
        request.customer.typeOfPayer = 'Third party Organization';
        
    
        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/generateQuote';
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIServiceV2.doPost();
        Test.stopTest();

        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV2.QuoteResponse response = (TF_QuoteAPIServiceV2.QuoteResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV2.QuoteResponse.class);
 
        System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);           
    } 

    private static testmethod void generateQuoteThirdPartyPayTest() {
         createSampleData();
        // -- Create a request object -- //
        product2 prod = [Select id,Hub_Id__c,Family from Product2 ];
        prod.Hub_Id__c = '92e531c8';
        prod.Family = 'Journal Service Product';
        update prod;
        Account acc = [Select id,Ringgold_Account_ID__c from Account ];
        acc.Ringgold_Account_ID__c = '12';
        
        update acc;
        TF_QuoteAPIServiceV2.GenerateQuoteRequestNew request = getSampleQuoteCreationRequestNewNew();
        request.customer.typeOfPayer = 'Third party';
        
        String requestJSON = JSON.serialize(request);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = baseUrl + '/services/apexrest/QuoteService/generateQuote';
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TF_QuoteAPIServiceV2.doPost();
        Test.stopTest();

        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV2.QuoteResponse response = (TF_QuoteAPIServiceV2.QuoteResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV2.QuoteResponse.class);
 
        System.assertEquals(null, response.errorMessage);
        System.assertEquals(true, response.success);           
    } 
    
    
        private static testmethod void recalculateQuoteSelfPayChanges() {
        createSampleData();
        List<SBQQ__Quote__c> quotes = [SELECT id,Name,promocode__c,Use_Prepay_Budget__c,SBQQ__Account__c, randomstring__c FROM SBQQ__Quote__c];
 
        TF_QuoteAPIServiceV2.QuoteReCalculationRequest request = new TF_QuoteAPIServiceV2.QuoteReCalculationRequest();
        request.quoteUniqueId = quotes[0].randomstring__c;
        TF_QuoteAPIServiceV2.GenerateQuoteRequest quoteChangeRequest = getSampleQuoteCreationRequestNew();
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
        TF_QuoteAPIServiceV2.doPost();
        Test.stopTest();

        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV2.QuoteDetailResponse response = (TF_QuoteAPIServiceV2.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV2.QuoteDetailResponse.class);
 
        //System.assertEquals(null, response.errorMessage);
        //System.assertEquals(true, response.success);           

    }


    private static testmethod void recalculateQuoteOrganizationPayChanges() {
        createSampleData();
        List<SBQQ__Quote__c> quotes = [SELECT id,PromoCode__c,Name,Use_Prepay_Budget__c,SBQQ__Account__c, randomstring__c FROM SBQQ__Quote__c];
        String json=		'{'+
		' "source": "SP",'+
		' "identifiers": {'+
		' "submissionId": "201156331"'+
		' },'+
		' "customer": {'+
		' "partyId": "12121",'+
		' "name": "Ashish D",'+
		' "customerType": "INDIVIDUAL",'+
		' "typeOfPayer": "Self",'+
		' "campus": "",'+
		' "department": ""'+
		' },'+
		' "contact": {'+
		' "firstName": "Ashish",'+
		' "lastName": "D",'+
		' "email": "ashishdev094@gmail.com",'+
		' "phoneNumber": "12312342"'+
		' },'+
		' "billingAddress": {'+
		' "name": "Ashish D",'+
		' "street1": "143, 144, Hosur Main Road",'+
		' "street2": "",'+
		' "city": "Bangalore",'+
		' "state": "Karnataka",'+
		' "stateISO": "",'+
		' "countryCode": "India",'+
		' "country": "India",'+
		' "postalCode": "560095",'+
		' "bpNumber": "00023736273",'+
		' "taxRegistrationNumber": "",'+
		' "taxCategory": ""'+
		' },'+
		' "shippingAddress": {'+
		' "name": "Ashish D",'+
		' "street1": "143, 144, Hosur Main Road",'+
		' "street2": "",'+
		' "city": "Bangalore",'+
		' "state": "Karnataka",'+
		' "country": "India",'+
		' "stateISO": "",'+
		' "countryCode": "India",'+
		' "postalCode": "560095",'+
		' "bpNumber": "00023736273"'+
		' },'+
		' "discountParam": {'+
		' "promoCode": null,'+
		' "applyCountryDiscount": true,'+
		' "applyPrepayDiscount": false,'+
		' "additionalDiscountRequest": {}'+
		' },'+
		' "services":['+
		'      {'+
		'         "serviceId":"92e531c8",'+
		'         "parentProductId":"6e237022-0f4d-4ca7-9468-30fc89388ff3"'+
		'      }'+
		'   ],'+
		' "products": ['+
		' "6e237022-0f4d-4ca7-9468-30fc89388ff3"'+
		' ],'+
		' "leadAuthor": {'+
		' "name": "Ashish Dev",'+
		' "email": "ashish.kumardev@informa.com",'+
		' "phoneNumber": "9620000601"'+
		' },'+
		' "organization": {'+
		' "partyId": "1112",'+
		' "ringGoldId": "230635",'+
		' "name": "National Institute of Technology, Patna",'+
		' "campus": "test",'+
		' "department": "test"'+
		' },'+
		' "productDetails": {'+
		' "type": "Article",'+
		' "title": "Title ttest title",'+
		' "status": "accepted",'+
		' "displayType ": "Short communication"'+
		' },'+
		' "attachments": ['+
		' {'+
		' "name": "ID Card",'+
		' "description": "My colleage Photo ID Card",'+
		' "path": "/OA/idcard.pdf"'+
		' },'+
		' {'+
		' "name": "Mark Sheet",'+
		' "description": "Consolidated Mark seet",'+
		' "path": "/OA/marksheet.pdf"'+
		' }'+
		' ]'+
		'}';
       
        String requestJSON = json;
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = baseUrl + '/services/apexrest/QuoteService/recalculateQuote';
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIServiceV2.doPost();
        Test.stopTest();
        
        String responeJSON = RestContext.response.responseBody.toString();
        
        //System.assertEquals(null, response.errorMessage);
        //System.assertEquals(true, response.success);           
        
    }
    
    private static testmethod void recalculateQuoteThirPartyOrganizationPayChanges() {
        createSampleData();
        List<SBQQ__Quote__c> quotes = [SELECT id,promocode__c,Name,Use_Prepay_Budget__c,SBQQ__Account__c, randomstring__c FROM SBQQ__Quote__c];
 
        TF_QuoteAPIServiceV2.QuoteReCalculationRequest request = new TF_QuoteAPIServiceV2.QuoteReCalculationRequest();
        request.quoteUniqueId = quotes[0].randomstring__c;
        TF_QuoteAPIServiceV2.GenerateQuoteRequest quoteChangeRequest = getSampleQuoteCreationRequestNew();

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
        TF_QuoteAPIServiceV2.doPost();
        Test.stopTest();

        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV2.QuoteDetailResponse response = (TF_QuoteAPIServiceV2.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV2.QuoteDetailResponse.class);
 
        //System.assertEquals(null, response.errorMessage);
        //System.assertEquals(true, response.success);           

    }
 
     private static testmethod void recalculateQuoteThirPartyPayChanges() {
        createSampleData();
        List<SBQQ__Quote__c> quotes = [SELECT id,Name,promocode__c,Use_Prepay_Budget__c,SBQQ__Account__c, randomstring__c FROM SBQQ__Quote__c];
 
        TF_QuoteAPIServiceV2.QuoteReCalculationRequest request = new TF_QuoteAPIServiceV2.QuoteReCalculationRequest();
        request.quoteUniqueId = quotes[0].randomstring__c;
        TF_QuoteAPIServiceV2.GenerateQuoteRequest quoteChangeRequest = getSampleQuoteCreationRequestNew();

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
        TF_QuoteAPIServiceV2.doPost();
        Test.stopTest();

        String responeJSON = RestContext.response.responseBody.toString();
        TF_QuoteAPIServiceV2.QuoteDetailResponse response = (TF_QuoteAPIServiceV2.QuoteDetailResponse)JSON.deserialize(responeJSON, TF_QuoteAPIServiceV2.QuoteDetailResponse.class);
        
        //System.assertEquals(null, response.errorMessage);
        //System.assertEquals(true, response.success);           

    }               

    
         
    private static void createSampleData() {
        System.runAs(new User(ID = UserInfo.getUserId())) {
          //  String priceBookName = 'T&F CPQ Price Book 2017';
          String priceBookName = 'OA APC PriceBook';
            Quote_Service_Settings__c customSetting = new Quote_Service_Settings__c(Name = 'Informa Plc', Product_Family__c = 'Journal Service Product', 
                                                                                    CPQ_PriceBook__c = priceBookName);//Jaipal- changed family from Journals-Author Side Charges to Journal Service Product
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
                                        Hub_Id__c='bb4de8de-2581-4766-ac18-205cc5084d9b',
                    ProductCode = 'XYZ',
                                        Readership_Level__c = 'Test',
                    IsActive = true,
                    Family = 'Journal Service Product');  
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
                    SBQQ__ExpirationDate__c = date.today()+20, randomstring__c='test',
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
        

    private static TF_QuoteAPIServiceV2.GenerateQuoteRequest getSampleQuoteCreationRequestNew () {
        TF_QuoteAPIServiceV2.GenerateQuoteRequest request = new TF_QuoteAPIServiceV2.GenerateQuoteRequest();
        
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

    private static TF_QuoteAPIServiceV2.GenerateQuoteRequestNew getSampleQuoteCreationRequestNewNew() {
        system.debug('check882');
        TF_QuoteAPIServiceV2.GenerateQuoteRequestNew request = new TF_QuoteAPIServiceV2.GenerateQuoteRequestNew();
        TF_QuoteAPIServiceV2.identifiers identifier = new TF_QuoteAPIServiceV2.identifiers();
        TF_QuoteAPIServiceV2.customer customer = new TF_QuoteAPIServiceV2.customer();
        TF_QuoteAPIServiceV2.contact contact = new TF_QuoteAPIServiceV2.contact();
        TF_QuoteAPIServiceV2.billingAddress billingAddress = new TF_QuoteAPIServiceV2.billingAddress();
        TF_QuoteAPIServiceV2.shippingAddress shippintAddress = new TF_QuoteAPIServiceV2.shippingAddress();
        TF_QuoteAPIServiceV2.discountParam discountParam = new TF_QuoteAPIServiceV2.discountParam();
        TF_QuoteAPIServiceV2.additionalDiscountRequest additioanDiscountRequest = new TF_QuoteAPIServiceV2.additionalDiscountRequest();
        TF_QuoteAPIServiceV2.priceDiscount priceDiscount = new TF_QuoteAPIServiceV2.priceDiscount();
        List<TF_QuoteAPIServiceV2.services> services = new List<TF_QuoteAPIServiceV2.services>();
        TF_QuoteAPIServiceV2.services services1 = new TF_QuoteAPIServiceV2.services();
      //  List<TF_QuoteAPIServiceV2.GenerateQuoteRequestNew.products> products = new List<TF_QuoteAPIServiceV2.GenerateQuoteRequestNew.products>();
        TF_QuoteAPIServiceV2.leadAuthor leadAuthor = new TF_QuoteAPIServiceV2.leadAuthor();
        TF_QuoteAPIServiceV2.organization organization = new TF_QuoteAPIServiceV2.organization();
        TF_QuoteAPIServiceV2.productDetails productDetails = new TF_QuoteAPIServiceV2.productDetails();
        List<TF_QuoteAPIServiceV2.attachments> attachments = new List<TF_QuoteAPIServiceV2.attachments>();
        TF_QuoteAPIServiceV2.attachments attachments1 = new TF_QuoteAPIServiceV2.attachments();
        TF_QuoteAPIServiceV2.productDetails  po=new TF_QuoteAPIServiceV2.productDetails ();
        po.type ='Article';
        
        if(request != null){
            request.source ='ASC/OAD/SP';
            
          //  sObject ob = new sObject();
            
            identifier.doi = '12345';
            identifier.manuscriptID = '67890';
            identifier.submissionID = '121212';
            identifier.invoiceNumber = '475830234';
            identifier.onboardingRequestId = '12122';
            identifier.purchaseOrderNumber = '475830234';
            identifier.ecsuniqueid = '';
            request.identifiers = identifier;
            customer.partyId ='12121';
            customer.ringGoldId ='12';
            customer.name ='University Of Eastern Finland';
            customer.customerType ='ORGANIZATION';
            customer.typeOfPayer ='Organisation';
            customer.campus ='';
            customer.department ='';
            request.customer = customer;

            contact.firstName = 'Henry';
            contact.lastName = 'D Jacob';
            contact.email = 'henry.jacob@informa.com';
            contact.phoneNumber = '12312342';
            request.contact = contact; 

            billingAddress.name ='J, Sukumar';
            billingAddress.street1 = 'billing street 1';
            billingAddress.street2 = 'billing street 2';
            billingAddress.city = 'billing city';
            billingAddress.state = 'billing state';
           // billingAddress.stateISD ='';
            billingAddress.countrycode = '';
            billingAddress.country = 'USA';
            billingAddress.postalCode = 'billing 1234';
            billingAddress.bpNumber ='00023736273';
            billingAddress.taxRegistrationNumber ='';
            billingAddress.taxCategory = '';
            request.billingAddress = billingAddress;
            shippintAddress.name ='Henry D jacob';
            //shippintAddress.street1 = 'billing street 1'; 
            //shippintAddress.street2 = 'billing street 2';
            shippintAddress.city = 'billing city';
            shippintAddress.state = 'billing state';
            shippintAddress.country = 'USA';
            //shippintAddress.stateISD ='';
            shippintAddress.countrycode ='';
            shippintAddress.postalCode = 'billing 1234';
            shippintAddress.bpNumber = '';
            request.shippingAddress = shippintAddress;
            
            discountParam.promoCode ='TPMR100-2017-E39F';
            discountParam.applyCountryDiscount = false;
          //  discountParam.applayPrepayDiscount = false;
            
            priceDiscount.price =100;
            priceDiscount.currencyIsoCode ='USD';
            
            additioanDiscountRequest.percentageDiscount ='10';
            additioanDiscountRequest.reason ='Phd student';
            request.discountParam = discountParam;
            request.discountParam.applyPrepayDiscount=true;
            request.discountParam.additionalDiscountRequest = additioanDiscountRequest;
            request.billingAddress.country='USA';
            //request.discountGenerateQuoteRequestParam.additionalDiscountRequest.priceDiscounts = priceDiscount;
            po.status='Accepted';
            request.productDetails=po;
            services1.serviceId ='92e531c8';
            services1.parentProductID ='0bb41064-48f5-4a07-aebf-01d8e941feb1';
            services.add(services1);
            request.services = services;

            string products = 'bb4de8de-2581-4766-ac18-205cc5084d9b';
            request.products = new List<String>();
            request.products.add(products);

            leadAuthor.name = 'Alex';
            leadAuthor.email ='alex@abc.com';
            leadAuthor.phoneNumber ='9620000601';
            request.leadAuthor = leadAuthor;
            
            organization.partyId = '1112';
            organization.ringGoldId = '12';
            organization.name = 'Cranfield University';
            organization.campus = '';
            organization.Department = '';
            request.organization = organization;

            productDetails.type = 'Full Review with leading authoer';
            productDetails.title = 'My Rhetoric Review';
            productDetails.status = 'accepted';//accepted/rejected - changed by Jaipal
            productDetails.displayType = 'Short communication';
            request.productDetails = productDetails;

            
            attachments1.name ='ID Card';
            attachments1.description ='My colleage Photo ID Card';
            attachments1.path ='/OA/idcard.pdf';
            attachments.add(attachments1);
            request.attachments = attachments;
            
            
            
            
            
        }
       // request.isArticleAccepted = false;   
        system.debug('check913'+request);
        return request;     
    }
    
    private static testmethod void doPostTest(){
        String baseUrl = Url.getSalesforceBaseUrl().toExternalForm();
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
                                           Family = 'Journal Service Product');  
        insert prodObject;
        Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        
        Account accObject = new Account(Name = 'Test Account',
                                        Ringgold_Account_ID__c='1234',
                                        RecordTypeId = TFAccountsRecordTypeId,
                                        Type = 'Customer'); 
        insert accObject;
        Id promoCodeRecTypeId = Schema.SObjectType.Sales_Deal__c.getRecordTypeInfosByName().get('Promocode Deal').getRecordTypeId();      
        Sales_Deal__c sd = new Sales_Deal__c(Deal_Name__c='test name',Start_Date__c=date.today(),End_Date__c=date.today()+50,Type_of_Deal__c='APC Deal',Promocode__c='testCode',Discount_Category__c='Ad hoc', RecordTypeId= promoCodeRecTypeId,Product__c=prodObject.id);
        insert sd;
        Deal_Discount__c dd = new Deal_Discount__c(Discount_Value_Percentage__c=20,Sales_Deal__c=sd.id);
        insert dd;
        Deal_Member__c dm01 = new Deal_Member__c(Sales_Deal__c=sd.Id, Account__c=accObject.Id,Type__c='Institution',Deal_Member__c=null);
        insert dm01;
        Deal_Member__c dm02 = new Deal_Member__c(Department_RinggoldId__c='1234',Sales_Deal__c=sd.Id, Account__c=accObject.Id,Type__c='Institution', Deal_Member__c = dm01.Id);
        insert dm02;
        Quote_Service_Settings__c quoteObj=new Quote_Service_Settings__c();
        quoteObj.Name='Informa Plc';
        quoteObj.Product_Family__c='Informa Plc';
        insert quoteObj;
        
        TF_QuoteAPIServiceV2.QuotePromoCodeRequest request = new TF_QuoteAPIServiceV2.QuotePromoCodeRequest();
        request.productCode = sd.Product_Code__c;
        request.promoCode = sd.Promocode__c;
        request.countryCode = 'IND';
        request.payerType = 'Self';
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();        
        req.requestURI = baseUrl + '/services/apexrest/recalculateQuote/QuoteService/checkPromoCode/1234';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIServiceV2.doPost();
        TF_QuoteAPIServiceV2.doGet();
        Test.stopTest();
    }
    
    private static testmethod void doPostSecondTest(){
        String baseUrl = Url.getSalesforceBaseUrl().toExternalForm();
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
                                           Family = 'Journal Service Product');  
        insert prodObject;
        Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        
        Account accObject = new Account(Name = 'Test Account',
                                        Ringgold_Account_ID__c='123',
                                        RecordTypeId = TFAccountsRecordTypeId,
                                        Type = 'Customer'); 
        insert accObject;
        Id promoCodeRecTypeId = Schema.SObjectType.Sales_Deal__c.getRecordTypeInfosByName().get('Promocode Deal').getRecordTypeId();      
        Sales_Deal__c sd = new Sales_Deal__c(Deal_Name__c='test name',Start_Date__c=date.today(),End_Date__c=date.today()+50,Type_of_Deal__c='APC Deal',Promocode__c='testCode',Discount_Category__c='Ad hoc', RecordTypeId= promoCodeRecTypeId,Product__c=prodObject.id);
        insert sd;
        Deal_Discount__c dd = new Deal_Discount__c(Discount_Value_Percentage__c=20,Sales_Deal__c=sd.id);
        insert dd;
        Deal_Member__c dm02 = new Deal_Member__c(Department_RinggoldId__c='123',Sales_Deal__c=sd.Id, Account__c=accObject.Id,Type__c='Institution');
        insert dm02;
        Quote_Service_Settings__c quoteObj=new Quote_Service_Settings__c();
        quoteObj.Name='Informa Plc';
        quoteObj.Product_Family__c='Informa Plc';
        insert quoteObj;
        
        TF_QuoteAPIServiceV2.QuotePromoCodeRequest request = new TF_QuoteAPIServiceV2.QuotePromoCodeRequest();
        request.productCode = sd.Product_Code__c;
        request.promoCode = sd.Promocode__c;
        request.countryCode = 'IND';
        request.payerType = 'Self';
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();        
        req.requestURI = baseUrl + '/services/apexrest/recalculateQuote/QuoteService/checkPromoCode/123';   
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIServiceV2.doPost();
        TF_QuoteAPIServiceV2.doGet();
        Test.stopTest();
    }
    
     private static testmethod void doPostThirdTest(){
        String baseUrl = Url.getSalesforceBaseUrl().toExternalForm();
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
                                           Family = 'Journal Service Product');  
        insert prodObject;
        Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        
        Account accObject = new Account(Name = 'Test Account',
                                        Ringgold_Account_ID__c='12345',
                                        RecordTypeId = TFAccountsRecordTypeId,
                                        Type = 'Customer'); 
        insert accObject;
        Id promoCodeRecTypeId = Schema.SObjectType.Sales_Deal__c.getRecordTypeInfosByName().get('Promocode Deal').getRecordTypeId();      
        Sales_Deal__c sd = new Sales_Deal__c(Deal_Name__c='test name',Start_Date__c=date.today(),End_Date__c=date.today()+50,Type_of_Deal__c='APC Deal',Promocode__c='testCode',Discount_Category__c='Ad hoc', RecordTypeId= promoCodeRecTypeId,Product__c=prodObject.id);
        insert sd;
        Deal_Discount__c dd = new Deal_Discount__c(Discount_Value_Percentage__c=20,Sales_Deal__c=sd.id);
        insert dd;
        Deal_Member__c dm02 = new Deal_Member__c(Department_RinggoldId__c='12345',Sales_Deal__c=sd.Id, Account__c=accObject.Id,Type__c='Institution');
        insert dm02;
        Quote_Service_Settings__c quoteObj=new Quote_Service_Settings__c();
        quoteObj.Name='Informa Plc';
        quoteObj.Product_Family__c='Informa Plc';
        insert quoteObj;

        TF_QuoteAPIServiceV2.QuotePromoCodeRequest request = new TF_QuoteAPIServiceV2.QuotePromoCodeRequest();
        request.productCode = sd.Product_Code__c;
        request.promoCode = sd.Promocode__c;
        request.countryCode = 'IND';
        request.payerType = 'Self';
        String requestJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();        
        req.requestURI = baseUrl + '/services/apexrest/recalculateQuote/QuoteService/checkPromoCode/12345';  
        req.requestBody = Blob.valueOf(requestJSON);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        TF_QuoteAPIServiceV2.doPost();
        TF_QuoteAPIServiceV2.doGet();
        Test.stopTest();
    }
    
    public class attachments {
        public String name;
        public  string description;
        public string path;
    }

}