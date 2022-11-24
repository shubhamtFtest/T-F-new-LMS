@isTest 
public class ztest_ProductDiscountService {
    @testSetup 
    private static  void createdata() 
    { 
        Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
        Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        Id salesInstitutionalRecordtype = Schema.SObjectType.Sales_Deal__c.getRecordTypeInfosByName().get('Institution Deal').getRecordTypeId();
        Id salesConsortiumRecordtype = Schema.SObjectType.Sales_Deal__c.getRecordTypeInfosByName().get('Consortium Deal').getRecordTypeId();
        Id salesdealsCountryDealObjdiscountRecordtype = Schema.SObjectType.Sales_Deal__c.getRecordTypeInfosByName().get('Country Deal').getRecordTypeId();
        Id salesdealssPromoCodeObjObjdiscountRecordtype = Schema.SObjectType.Sales_Deal__c.getRecordTypeInfosByName().get('Promocode Deal').getRecordTypeId();
        
        Account accObject = new Account(Customer_Id__c='70',Name = 'Test Account',RecordTypeId = TFAccountsRecordTypeId,Type = 'Customer',Manual_Check__c = True); 
        insert accObject;
        
        Account accObjectInstitution = new Account(Customer_Id__c='83258',Name = 'Test Account',RecordTypeId = TFAccountsRecordTypeId,Type = 'Customer',Manual_Check__c = True); 
        insert accObjectInstitution;
        
        Account accObjectInstitutionOne = new Account(Customer_Id__c='7654',Name = 'Test 7654 Account',RecordTypeId = TFAccountsRecordTypeId,Type = 'Customer',Manual_Check__c = True); 
        insert accObjectInstitutionOne;
        
        Account accWithRingGoldId = new Account(Customer_Id__c='9876',Name = 'Test Account without rinGoldId',RecordTypeId = TFAccountsRecordTypeId,Type = 'Customer',Manual_Check__c = True,Ringgold_Account_ID__c='9876'); 
        insert accWithRingGoldId;
        
        Prepay_Accounts__c pp = new Prepay_Accounts__c (name='Test PP',AccountName__c=accObject.id);
        insert pp;
        
        Product2 prodObject = new Product2(Name = 'Test Product', 
                                           RecordTypeId = TFProductsRecordTypeId,
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           ProductCode = 'XYZ',
                                           Readership_Level__c = 'Test',
                                           IsActive = true,
                                           Hub_Id__c='143f5db0-b038-48f5-a0da-50bb4f3485fa',
                                           Family = 'Journal Master Product');  
        insert prodObject;
        
        //Institution Sales Deal
        Sales_Deal__c sObj=new Sales_Deal__c();
        sObj.Deal_Name__c='Instution deal';
        sObj.End_Date__c=system.today()+1;
        sObj.Type_of_Deal__c='APC Deal';
        sObj.Discount_Display_Name__c='prepay';
        sObj.RecordTypeId=salesInstitutionalRecordtype;
        sObj.Start_Date__c=system.today();
        sObj.Product__c=prodObject.id;
        sObj.isPrepay__c=true;
        sObj.Product_Inclusion__c='BATC';
        sObj.Active__c=true;
        insert sObj;
        
        Deal_Member__c obj=new Deal_Member__c();
        obj.Account__c=accObjectInstitution.id;
        obj.Sales_Deal__c=sObj.id;
        insert obj;
        Deal_Member__c obj12=new Deal_Member__c();
        obj12.Deal_Member__c=obj.id;
        insert obj12;
        
        Deal_Discount__c dealdiscount=new Deal_Discount__c();
        dealdiscount.Discount_Type__c='% Discount';
        dealdiscount.Discount_Value_Percentage__c=5.00;
        dealdiscount.Sales_Deal__c=sObj.id;
        insert dealdiscount;
        
        Sales_Deal__c fxsde=new Sales_Deal__c();
        fxsde.Deal_Name__c='Instution deals';
        fxsde.End_Date__c=system.today()+1;
        fxsde.Type_of_Deal__c='APC Deal';
        fxsde.Discount_Display_Name__c='prepay';
        fxsde.RecordTypeId=salesInstitutionalRecordtype;
        fxsde.Start_Date__c=system.today();
        fxsde.Product_Inclusion__c='BATC';
        fxsde.Product_exclusion__c='EXCL';
        fxsde.Product_Open_Access_Category__c = 'Open';
        fxsde.isPrepay__c = false;
        fxsde.Active__c=true;
        insert fxsde;
        
        Deal_Member__c sdDm=new Deal_Member__c();
        sdDm.Account__c=accObjectInstitutionOne.id;
        sdDm.Sales_Deal__c=fxsde.id;
        insert sdDm;
        
        Deal_Discount__c dealdiscountSecond=new Deal_Discount__c();
        dealdiscountSecond.Discount_Type__c='Fixed Amount Discount';
        dealdiscountSecond.Discount_Value_Amount__c=60.00;
        dealdiscountSecond.Sales_Deal__c=fxsde.id;
        dealdiscountSecond.CurrencyIsoCode='USD';
        insert dealdiscountSecond;
        
        //Consotium Sales Deal
        Sales_Deal__c sConsortiumObj=new Sales_Deal__c();
        sConsortiumObj.Deal_Name__c='Consortium Deal';
        sConsortiumObj.Product__c=prodObject.id;
        sConsortiumObj.End_Date__c=system.today()+1;
        sConsortiumObj.Type_of_Deal__c='APC Deal';
        sConsortiumObj.isPrepay__c=true;
        sConsortiumObj.Discount_Display_Name__c='prepay';
        sConsortiumObj.RecordTypeId=salesConsortiumRecordtype;
        sConsortiumObj.Start_Date__c=system.today();
        sConsortiumObj.Product_Inclusion__c='BATC';
        sConsortiumObj.Active__c=true;
        insert sConsortiumObj;
         
        Deal_Member__c obja1=new Deal_Member__c();
        obja1.Account__c=accObjectInstitution.id;
        obja1.Sales_Deal__c=sConsortiumObj.id;
        insert obja1;
        Deal_Member__c obj1a1=new Deal_Member__c();
        obj1a1.Deal_Member__c=obja1.id;
        insert obj1a1;
        
        Deal_Discount__c dealConotiumdiscount=new Deal_Discount__c();
        dealConotiumdiscount.Discount_Type__c='% Discount';
        dealConotiumdiscount.Discount_Value_Percentage__c=15.00;
        dealConotiumdiscount.Sales_Deal__c=sConsortiumObj.id;
        insert dealConotiumdiscount;
        
        // Create Country Deal Sales Deal
        Sales_Deal__c sCountryDealObj=new Sales_Deal__c();
        sCountryDealObj.Deal_Name__c='Country Deal';
        sCountryDealObj.isPrepay__c=true;
        sCountryDealObj.End_Date__c=system.today()+1;
        sCountryDealObj.Type_of_Deal__c='APC Deal';
        sCountryDealObj.Discount_Display_Name__c='prepay';
        sCountryDealObj.RecordTypeId=salesdealsCountryDealObjdiscountRecordtype;
        sCountryDealObj.Start_Date__c=system.today();
        sCountryDealObj.Product_Inclusion__c='BATC';
        sCountryDealObj.Country_Applicable_List__c='Sanctioned Country';
        sCountryDealObj.Active__c=true;
        insert sCountryDealObj;
        
        Deal_Member__c objaa1=new Deal_Member__c();
        objaa1.Sales_Deal__c=sCountryDealObj.id;
        insert objaa1;
        
        Deal_Member__c objs=new Deal_Member__c();
        objs.Sales_Deal__c=sCountryDealObj.id;
        insert objs;
        
        Deal_Discount__c dealsCountryDealObjdiscount=new Deal_Discount__c();
        dealsCountryDealObjdiscount.Discount_Type__c='% Discount';
        dealsCountryDealObjdiscount.Discount_Value_Percentage__c=25.00;
        dealsCountryDealObjdiscount.Sales_Deal__c=sCountryDealObj.id;
        insert dealsCountryDealObjdiscount;
        
        // Create Promo Code Deal Sales Deal
        Sales_Deal__c sPromoCodeObj=new Sales_Deal__c();
        sPromoCodeObj.Deal_Name__c='Promocode Deal';
        sPromoCodeObj.Promocode__c='123';
        sPromoCodeObj.End_Date__c=system.today()+1;
        sPromoCodeObj.Type_of_Deal__c='APC Deal';
        sPromoCodeObj.Product__c=prodObject.id;
        sPromoCodeObj.isPrepay__c=true;
        sPromoCodeObj.Discount_Display_Name__c='prepay';
        sPromoCodeObj.RecordTypeId=salesdealssPromoCodeObjObjdiscountRecordtype;
        sPromoCodeObj.Start_Date__c=system.today();
        sPromoCodeObj.Product_Inclusion__c='BATC';
        sPromoCodeObj.Active__c=true;
        insert sPromoCodeObj;
        
        Deal_Discount__c dealssPromoCodeObjObjdiscount=new Deal_Discount__c();
        dealssPromoCodeObjObjdiscount.Discount_Type__c='% Discount';
        dealssPromoCodeObjObjdiscount.Discount_Value_Percentage__c=35.00;
        dealssPromoCodeObjObjdiscount.Sales_Deal__c=sPromoCodeObj.id;
        insert dealssPromoCodeObjObjdiscount;
        
        // Create Promo Code fixed amount Sales Deal
        Sales_Deal__c sPromoCodeFixedObj=new Sales_Deal__c();
        sPromoCodeFixedObj.Deal_Name__c='Promocode Deal';
        sPromoCodeFixedObj.Promocode__c='345';
        sPromoCodeFixedObj.End_Date__c=system.today()+1;
        sPromoCodeFixedObj.Type_of_Deal__c='APC Deal';
        sPromoCodeFixedObj.Product__c=prodObject.id;
        sPromoCodeFixedObj.isPrepay__c=true;
        sPromoCodeFixedObj.Discount_Display_Name__c='prepay';
        sPromoCodeFixedObj.RecordTypeId=salesdealssPromoCodeObjObjdiscountRecordtype;
        sPromoCodeFixedObj.Start_Date__c=system.today();
        sPromoCodeFixedObj.Product_Inclusion__c='BATC';
        sPromoCodeFixedObj.Active__c=true;
        insert sPromoCodeFixedObj;
        
        Deal_Discount__c promoCodeObjFixDiscount=new Deal_Discount__c();
        promoCodeObjFixDiscount.Discount_Type__c='Fixed Amount Discount';
        promoCodeObjFixDiscount.Discount_Value_Amount__c=70;
        promoCodeObjFixDiscount.Sales_Deal__c=sPromoCodeFixedObj.id;
        dealdiscountSecond.CurrencyIsoCode='USD';
        insert promoCodeObjFixDiscount;
        
        PromoCode__c promo=new PromoCode__c();
        promo.Active__c=true;
        promo.Deal_Discount__c=dealssPromoCodeObjObjdiscount.id;
        promo.Name='123';
        insert promo;
        
        Country__c  counobj=new Country__c(); 
        counobj.Name='CU';
        counobj.Enabled__c=true;
        counobj.Preferred_currency__c='USD';
        counobj.Description__c='Cuba';
        counobj.Country_3__c='CUB';
        counobj.Country_2__c='CU';
        counobj.Applicable_List__c='Sanctioned Country';
        insert counobj;
        
        Country__c  counobjOne=new Country__c(); 
        counobjOne.Name='India';
        counobjOne.Enabled__c=true;
        counobjOne.Preferred_currency__c='USD';
        counobjOne.Description__c='India';
        counobjOne.Country_2__c='IN';
        counobjOne.Applicable_List__c='Band B';
        insert counobjOne;
        
    }
    
    private static testMethod void testMethodOne()
    {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.addHeader('httpMethod', 'POST');
        req.requestUri = '/discount/*'; 
        
        Country__c counobj=[select id from Country__c limit 1];
        product2 prodObject=[select id from product2 limit 1];
        Sales_Deal__c salesdealRec=[select id from Sales_Deal__c where recordtype.name='Promocode Deal' limit 1];
        PromoCode__c promoRec=[select id from PromoCode__c limit 1];
        
        String postData = '[{"customerID":"83258","startDate":"2021-06-29","endDate":"2021-06-29","billingCountry":"Cuba","BillingCountryCode":"CU","productID":"'+prodObject.Id+'","productCode":"Open - Non Standard Price 1 - Category B","parentProduct":"143f5db0-b038-48f5-a0da-50bb4f3485fa","promoCode":"123","applycountryDiscount":true,"CountryApplicableList":"Sanctioned Country","applyPrePayDiscount":true,"quoteLineListPrice":700,"country":{"Id":"'+counobj.id+'"},"appliedSalesDeal":{"Id":"'+salesdealRec.id+'"},"promoCodeRec":{"Id":"'+promoRec.Id+'"}},{"customerID":"83258","startDate":"2021-06-29","endDate":"2021-06-29","billingCountry":"Cuba","BillingCountryCode":"CU","productID":"'+prodObject.Id+'","productCode":"Open - Non Standard Price 1 - Category B","parentProduct":"","promoCode":"123","applycountryDiscount":true,"CountryApplicableList":"Sanctioned Country","applyPrePayDiscount":true,"quoteLineListPrice":700,"country":{"Id":"'+counobj.id+'"},"appliedSalesDeal":{"Id":"'+salesdealRec.id+'"},"promoCodeRec":{"Id":"'+promoRec.Id+'"}}]';
        
        req.requestBody = Blob.valueof(postData);
        RestContext.request = req; 
        RestContext.response= res;
        
        Test.startTest();
        ProductDiscountService.doPost();
        Test.stopTest();
        
        Id salesdealssPromoCodeObjObjdiscountRecordtype = Schema.SObjectType.Sales_Deal__c.getRecordTypeInfosByName().get('Promocode Deal').getRecordTypeId();
        ProductDiscountService.Response responseBody =(ProductDiscountService.Response)JSON.deserialize(res.responseBody.toString(), ProductDiscountService.Response.class);
        system.debug('@responseBody One '+responseBody);
        system.assert(responseBody.appliedSalesDealList != null);
        system.assertEquals(responseBody.appliedSalesDealList.get(0).recordTypeId, salesdealssPromoCodeObjObjdiscountRecordtype);
        system.assert(responseBody.discountPercentList != null);
        system.assertEquals(35, responseBody.discountPercentList.get(0));
    }
   
    @isTest //To cover ringGoldId concept
    private static void testMethodSecond()
    {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
         
        req.addHeader('httpMethod', 'POST');
        req.requestUri = '/discount/*'; 
        
        product2 prodObject=[select id from product2 limit 1];
        
        String postData = '[{"customerID":null,"startDate":"2021-06-29","endDate":"2021-06-29","billingCountry":"Cuba","BillingCountryCode":"CU","productID":"'+prodObject.Id+'","productCode":"Open - Non Standard Price 1 - Category B","parentProduct":"143f5db0-b038-48f5-a0da-50bb4f3485fa","promoCode":"123","applycountryDiscount":true,"CountryApplicableList":"Sanctioned Country","applyPrePayDiscount":true,"quoteLineListPrice":700,"ringoldId":"9876"}]';
        req.requestBody = Blob.valueof(postData);
        RestContext.request = req; 
        RestContext.response= res;  
        
        Test.startTest();
        ProductDiscountService.doPost();
        Test.stopTest();
        
        Id salesdealssPromoCodeObjObjdiscountRecordtype = Schema.SObjectType.Sales_Deal__c.getRecordTypeInfosByName().get('Promocode Deal').getRecordTypeId();
        ProductDiscountService.Response responseBody =(ProductDiscountService.Response)JSON.deserialize(res.responseBody.toString(), ProductDiscountService.Response.class);
        system.debug('@responseBody Fourth '+responseBody);
        system.assert(responseBody.appliedSalesDealList != null);
        system.assertEquals(responseBody.appliedSalesDealList.get(0).recordTypeId, salesdealssPromoCodeObjObjdiscountRecordtype);
        system.assert(responseBody.discountPercentList != null);
        system.assertEquals(35, responseBody.discountPercentList.get(0));
    }
    
    @isTest //To cover fixed amount discount concept
    private static void testMethodThird()
    {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
         
        req.addHeader('httpMethod', 'POST');
        req.requestUri = '/discount/*'; 
        
        Country__c counobj=[select id from Country__c limit 1];
        Sales_Deal__c salesdealRecInstitution=[select id from Sales_Deal__c where Product_Open_Access_Category__c='Open' limit 1];
        
        String postData = '[{"customerID":"7654","startDate":"2021-06-29","endDate":"2550-06-29","billingCountry":"India","BillingCountryCode":"IN","productCode":"Open - Non Standard Price 1 - Category B","parentProduct":"143f5db0-b038-48f5-a0da-50bb4f3485fa","applyPrePayDiscount":false,"quoteLineListPrice":700}]';
        req.requestBody = Blob.valueof(postData);
        RestContext.request = req; 
        RestContext.response= res;  
        
        Test.startTest();
        ProductDiscountService.doPost();
        Test.stopTest(); 
        
        Id salesInstitutionalRecordtype = Schema.SObjectType.Sales_Deal__c.getRecordTypeInfosByName().get('Institution Deal').getRecordTypeId();
        ProductDiscountService.Response responseBody =(ProductDiscountService.Response)JSON.deserialize(res.responseBody.toString(), ProductDiscountService.Response.class);
        system.debug('@responseBody Third '+responseBody);
        system.assert(responseBody.appliedSalesDealList != null);
        system.assertEquals(responseBody.appliedSalesDealList.get(0).recordTypeId, salesInstitutionalRecordtype);
        system.assert(responseBody.discountAmountList != null);
        system.assertEquals(640, responseBody.discountAmountList.get(0));
    }
    
    private static testMethod void testMethodfourth()
    {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
         
        req.addHeader('httpMethod', 'POST');
        req.requestUri = '/discount/*'; 
        
        product2 prodObject=[select id from product2 limit 1];
        
        String postData = '[{"customerID":"83258","startDate":"2021-06-29","endDate":"2021-06-29","billingCountry":"Cuba","BillingCountryCode":"CU","productID":"'+prodObject.Id+'","productCode":"Open - Non Standard Price 1 - Category B","parentProduct":"143f5db0-b038-48f5-a0da-50bb4f3485fa","promoCode":"123","applycountryDiscount":true,"CountryApplicableList":"Sanctioned Country","applyPrePayDiscount":true,"quoteLineListPrice":700}]';
        req.requestBody = Blob.valueof(postData);
        RestContext.request = req; 
        RestContext.response= res;  
        
        Test.startTest();
        ProductDiscountService.doPost();
        Test.stopTest();
        
        Id salesdealssPromoCodeObjObjdiscountRecordtype = Schema.SObjectType.Sales_Deal__c.getRecordTypeInfosByName().get('Promocode Deal').getRecordTypeId();
        ProductDiscountService.Response responseBody =(ProductDiscountService.Response)JSON.deserialize(res.responseBody.toString(), ProductDiscountService.Response.class);
        system.debug('@responseBody Fourth '+responseBody);
        system.assert(responseBody.appliedSalesDealList != null);
        system.assertEquals(responseBody.appliedSalesDealList.get(0).recordTypeId, salesdealssPromoCodeObjObjdiscountRecordtype);
        system.assert(responseBody.discountPercentList != null);
        system.assertEquals(35, responseBody.discountPercentList.get(0));
    } 
     
    @isTest //To cover promocode fixed amount discount concept
    private static void testMethodFifth()
    {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
         
        req.addHeader('httpMethod', 'POST');
        req.requestUri = '/discount/*'; 
        
        product2 prodObject=[select id from product2 limit 1];
        Country__c counobj=[select id from Country__c WHERE Name='India' limit 1];
        Sales_Deal__c salesdealRecInstitution=[select id from Sales_Deal__c where Promocode__c='345' limit 1];
        
        String postData = '[{"customerID":null,"startDate":"2021-06-29","endDate":"2021-06-29","billingCountry":"India","BillingCountryCode":"IN","productID":"'+prodObject.Id+'","productCode":"Open - Non Standard Price 1 - Category B","parentProduct":"143f5db0-b038-48f5-a0da-50bb4f3485fa","promoCode":"345","applycountryDiscount":null,"CountryApplicableList":null,"applyPrePayDiscount":false,"quoteLineListPrice":700}]';
        req.requestBody = Blob.valueof(postData);
        RestContext.request = req; 
        RestContext.response= res;  
        
        Test.startTest();
        ProductDiscountService.doPost();
        Test.stopTest();
        
        Id salesdealssPromoCodeObjObjdiscountRecordtype = Schema.SObjectType.Sales_Deal__c.getRecordTypeInfosByName().get('Promocode Deal').getRecordTypeId();
        ProductDiscountService.Response responseBody =(ProductDiscountService.Response)JSON.deserialize(res.responseBody.toString(), ProductDiscountService.Response.class);
        system.debug('@responseBody Fifth '+responseBody);
        system.assert(responseBody.appliedSalesDealList != null);
        system.assertEquals(responseBody.appliedSalesDealList.get(0).recordTypeId, salesdealssPromoCodeObjObjdiscountRecordtype);
        system.assert(responseBody.discountAmountList != null);
        system.assertEquals(630, responseBody.discountAmountList.get(0));
    } 
    
    //Covering customScriptOnQuote Trigger test class- If partner discount is less then the SD discount then apply SD discount and remove partner discount 
    private static testMethod void testMethodSixth()
    {
        product2 parentProduct = [select id from product2 limit 1];
        Id recId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'T&F - CPQ Quote');
        Product2 prodObject = new Product2(Name = 'Test Product', 
                                           ProductCode = 'HBBO',
                                           IsActive = true,
                                           Hub_Id__c='21212-b038-48f5-a0da-50bb4f3485fa',
                                           Family = 'Journal Service Product',
                                           Is_Service_Discount__c = true);  
        insert prodObject;
        
        SBQQ__Quote__c quote = new SBQQ__Quote__c(
            SBQQ__PricebookId__c = Test.getStandardPricebookId(), 
            SBQQ__StartDate__c = system.today(),
            SBQQ__Status__c = 'Accepted', 
            SBQQ__Primary__c=true,
            SBQQ__ExpirationDate__c = date.today()+20,
            recordTypeId = recId,
        	Partner_Discount_Percent__c = 30,//50,
        	PromoCode__c = '123');
        insert quote;
        
        SBQQ__QuoteLine__c oli = new SBQQ__QuoteLine__c(
            SBQQ__Quote__c = quote.id,
            SBQQ__Product__c = prodObject.id,
            SBQQ__PricebookEntryId__c = Test.getStandardPricebookId(),
            CurrencyIsoCode = 'USD',
            SBQQ__Quantity__c = 1,
            SBQQ__ListPrice__c = 100,
        	parent_Product__c = parentProduct.id);
        insert oli;
        
        Test.startTest();
        TriggerInterfaceHelper.runTrigger('CustomScriptOnQuote', 'SBQQ__Quote__c', 1, 'au', recId, null); 
        update quote;
        Test.stopTest();
        SBQQ__Quote__c updatedQuote = [Select id, Partner_Discount_Percent__c, Sales_Deal__c 
                                       from SBQQ__Quote__c 
                                       where id=:quote.Id];
        system.assertEquals(0, updatedQuote.Partner_Discount_Percent__c);
    }
    
    //Covering customScriptOnQuote Trigger test class- Apply partner discount
    private static testMethod void testMethodSeventh()
    {
        product2 parentProduct = [select id from product2 limit 1];
        Id recId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'T&F - CPQ Quote');
        Product2 prodObject = new Product2(Name = 'Test Product', 
                                           ProductCode = 'HBBO',
                                           IsActive = true,
                                           Hub_Id__c='21212-b038-48f5-a0da-50bb4f3485fa',
                                           Family = 'Journal Service Product',
                                           Is_Service_Discount__c = true);  
        insert prodObject;
        
        SBQQ__Quote__c quote = new SBQQ__Quote__c(
            SBQQ__PricebookId__c = Test.getStandardPricebookId(), 
            SBQQ__StartDate__c = system.today(),
            SBQQ__Status__c = 'Accepted', 
            SBQQ__Primary__c=true,
            SBQQ__ExpirationDate__c = date.today()+20,
            recordTypeId = recId,
        	Partner_Discount_Percent__c = 50);
        insert quote;
        
        SBQQ__QuoteLine__c oli = new SBQQ__QuoteLine__c(
            SBQQ__Quote__c = quote.id,
            SBQQ__Product__c = prodObject.id,
            SBQQ__PricebookEntryId__c = Test.getStandardPricebookId(),
            CurrencyIsoCode = 'USD',
            SBQQ__Quantity__c = 1,
            SBQQ__ListPrice__c = 100,
        	parent_Product__c = parentProduct.id);
        insert oli;
        
        Test.startTest();
        TriggerInterfaceHelper.runTrigger('CustomScriptOnQuote', 'SBQQ__Quote__c', 1, 'au', recId, null); 
        update quote;
        Test.stopTest();
        system.assertEquals(50, quote.Partner_Discount_Percent__c);
    }
    
    //Covering customScriptOnQuote Trigger test class- Apply SD discount 
    private static testMethod void testMethodEighth()
    {
        product2 parentProduct = [select id from product2 limit 1];
        Id recId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'T&F - CPQ Quote');
        Product2 prodObject = new Product2(Name = 'Test Product', 
                                           ProductCode = 'HBBO',
                                           IsActive = true,
                                           Hub_Id__c='21212-b038-48f5-a0da-50bb4f3485fa',
                                           Family = 'Journal Service Product',
                                           Is_Service_Discount__c = true);  
        insert prodObject;
        
        SBQQ__Quote__c quote = new SBQQ__Quote__c(
            SBQQ__PricebookId__c = Test.getStandardPricebookId(), 
            SBQQ__StartDate__c = system.today(),
            SBQQ__Status__c = 'Accepted', 
            SBQQ__Primary__c=true,
            SBQQ__ExpirationDate__c = date.today()+20,
            recordTypeId = recId,
        	PromoCode__c = '123');
        insert quote;
        
        SBQQ__QuoteLine__c oli = new SBQQ__QuoteLine__c(
            SBQQ__Quote__c = quote.id,
            SBQQ__Product__c = prodObject.id,
            SBQQ__PricebookEntryId__c = Test.getStandardPricebookId(),
            CurrencyIsoCode = 'USD',
            SBQQ__Quantity__c = 1,
            SBQQ__ListPrice__c = 100,
        	parent_Product__c = parentProduct.id);
        insert oli;
        
        Test.startTest();
        TriggerInterfaceHelper.runTrigger('CustomScriptOnQuote', 'SBQQ__Quote__c', 1, 'au', recId, null); 
        update quote;
        Test.stopTest();
    }
}