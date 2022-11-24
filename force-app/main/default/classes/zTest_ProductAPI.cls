/***************************************************************************
* Created by: Tom Reed, 2019.01.02
* Modified by : Tom Reed, 2019.11.12
* **************************************************************************/

@isTest
public class zTest_ProductAPI {
    
    @isTest
    public static void zTest_ProductAPI(){
        
        //Batch_Record_Count__c=1 to prevent more than one batch running which is not allowed in a test class.
        ProductAPISettings__c pas = new ProductAPISettings__c(Name='Test',Batch_Record_Count__c=1,Create_Setting_Item_Error_Logs__c=true, Error_Recipient_Email_Address__c='tom.reed@tandf.co.uk');
        insert pas;
        
        //Create new pricebooks.        
        Pricebook2 tfPricebook = new Pricebook2(Name='T&F Pricebook');
        Pricebook2 standardPricebook = new Pricebook2(Name='Standard Price Book');
        standardPricebook.Id = Test.getStandardPricebookId();
        Pricebook2 eBooksPricebook = new Pricebook2(Name='T&F - eBooks Pricebook');
        List<Pricebook2> pricebook2List = new List<Pricebook2>{tfPricebook, standardPricebook, eBooksPricebook};
            upsert pricebook2List;
        
        Setting__c ProductAPINetbase = new Setting__c(Name='NetbaseClassifications');
        Setting__c ProductAPI_ErrorLogs = new Setting__c(Name='ProductAPI_ErrorLogs');
        Setting__c productAPIMappings = new Setting__c(Name='ProductAPIMappings');
        Setting__c productAPIMappings_PO_Role = new Setting__c(Name='ProductAPIMappings_PO_Role');
        Setting__c productAPIMappings_ActiveStatusCodes = new Setting__c(Name='ProductAPIMappings_ActiveStatusCodes');
        List<Setting__c> settingList = new List<Setting__c>{ProductAPI_ErrorLogs, productAPIMappings, productAPIMappings_PO_Role, productAPIMappings_ActiveStatusCodes, ProductAPINetbase};
            insert settingList;
        Setting_Item__c productAPINetbaseSI = new Setting_Item__c(Setting__c=ProductAPINetbase.Id, Checkbox_1__c=true, Text_1__c='SCPI55 - format', Text_2__c='Version_Type__c',Text_3__c='Product2'); 
        Setting_Item__c productAPIMappingsSI = new Setting_Item__c(Setting__c=productAPIMappings.Id, Checkbox_1__c=true, Text_1__c='format', Text_2__c='Version_Type__c',Text_3__c='Product2');     
        Setting_Item__c productAPIMappingsSI2 = new Setting_Item__c(Setting__c=productAPIMappings.Id, Checkbox_1__c=true, Text_1__c='isbn', Text_2__c='productcode',Text_3__c='Product2');
        Setting_Item__c productAPIMappingsSI4 = new Setting_Item__c(Setting__c=productAPIMappings.Id, Checkbox_1__c=true, Text_1__c='edition', Text_2__c='Edition_Number__c',Text_3__c='Product2');
        Setting_Item__c productAPIMappingsSI8 = new Setting_Item__c(Setting__c=productAPIMappings.Id, Checkbox_1__c=true, Text_1__c='isbn', Text_2__c='ProductCode',Text_3__c='Product2');
        Setting_Item__c productAPIMappingsSI7 = new Setting_Item__c(Setting__c=productAPIMappings.Id, Checkbox_1__c=true, Text_1__c='publicationDate', Text_2__c='Publish_Date__c',Text_3__c='Product_Geographical_Information__c');
        Setting_Item__c productAPIMappingsSI3 = new Setting_Item__c(Setting__c=productAPIMappings.Id, Checkbox_1__c=true, Text_1__c='primaryDistributionCenter', Text_2__c='Primary_Distribution_Center__c',Text_3__c='Product_Geographical_Information__c');
        Setting_Item__c productAPIMappingsSI5 = new Setting_Item__c(Setting__c=productAPIMappings.Id, Checkbox_1__c=true, Text_1__c='firstName', Text_2__c='First_Name__c',Text_3__c='Product_Originator__c');
        Setting_Item__c productAPIMappingsSI6 = new Setting_Item__c(Setting__c=productAPIMappings.Id, Checkbox_1__c=true, Text_1__c='originatorType', Text_2__c='role__c',Text_3__c='Product_Originator__c');
        Setting_Item__c productAPIMappingsSI9 = new Setting_Item__c(Setting__c=productAPIMappings.Id, Checkbox_1__c=true, Text_1__c='dac', Text_2__c='DAC_Key__c',Text_3__c='Product2'); 
        Setting_Item__c productAPIMappingsSI10 = new Setting_Item__c(Setting__c=productAPIMappings.Id, Checkbox_1__c=true, Text_1__c='versionType', Text_2__c='Version_Type__c',Text_3__c='Product2');
        Setting_Item__c productAPIMappingsSI11 = new Setting_Item__c(Setting__c=productAPIMappings.Id, Checkbox_1__c=true, Text_1__c='isSellable', Text_2__c='IsSellable__c',Text_3__c='Product2');
        Setting_Item__c productAPIMappings_PO_RoleSI = new Setting_Item__c(Setting__c=productAPIMappings_PO_Role.Id, Checkbox_1__c=true, Text_1__c='Translated', Text_2__c='Translated By');
        Setting_Item__c productAPIMappings_ActiveStatusCodesSI = new Setting_Item__c(Setting__c=productAPIMappings_ActiveStatusCodes.Id, Checkbox_1__c=true, Text_1__c='evt');
        List<Setting_Item__c> settingItemList = new List<Setting_Item__c>{productAPIMappingsSI, productAPIMappingsSI2, productAPIMappingsSI3, productAPIMappingsSI4, productAPIMappingsSI5, productAPIMappingsSI6, productAPIMappingsSI7, productAPIMappingsSI8, productAPIMappingsSI9, productAPIMappingsSI10, productAPIMappings_PO_RoleSI, productAPIMappings_ActiveStatusCodesSI,productAPINetbaseSI};
        insert settingItemList;    
        
        //Create a product.
        Id productRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
        Product2 newProduct = zTEST_Shared.noinsertProduct2(productRecordTypeId);
        newProduct.DAC_Key__c = 'C2017-0-62714-7';
        newProduct.Version_Type__c = 'hardback';
        newProduct.ProductCode='1234';
        insert newProduct;
        
        //Construct the a dummy JSON payload.
        String query = '';
        query+='{';
        query+='"publishingItemId":"aa885943-0932-4728-b964-44f03f4af9af",';
        query+='"messageDate":"2019-06-30T09:44:53Z",';
        query+='"type":"BOOK",';
        query+='"metadata":{';
        query+='"identifiers":{';
        query+='"isbn":"1234567891111",';
        query+='"webPdfIsbn":"9781351180993",';
        query+='"doi":"10.4324/9781351181006",';
        query+='"dac":"C2017-0-62714-7",';
        query+='"epub3Isbn":"9781351180986",';
        query+='"epubIsbn":null,';
        query+='"mobiIsbn":"9781351180979",';
        query+='"eanCode":"9781351181006"';
        query+='},';
        query+='"location":"https://s3-euw1-ap-pe-df-pch-product-sourcedata-p.s3-eu-west-1.amazonaws.com/source/KUP1548841493864_11910.xml",';
        query+='"title":"Tom Test 2018-01-31",';
        query+='"edition":"111",';
        query+='"subtitle":"",';
        query+='"publisherImprint":"Routledge",';
        query+='"publisherArea":"BehaviouralScience&Education",';
        query+='"publisherAreaCode":"BSCIED",';
        query+='"textType":"Professional(DRM-Free)",';
        query+='"textTypeCode":"150",';
        query+='"versionType":"e-Book",';
        query+='"versionTypeCode":"EBK",';
        query+='"bindingStyle":"eBook-General",';
        query+='"bindingStyleCode":"EBGE",';
        query+='"status":"In Production",';
        query+='"statusCode":"evt",';
        query+='"firstPublishedYear":null,';
        query+='"publicationDate":null,';
        query+='"plannedPublicationDate":"2019-02-21",';
        query+='"copyrightYear":"2019",';
        query+='"shortBlurb":"<EM>LeadershipofHigherEducationAssessment</EM>providesacomprehensivetreatmentofleadershiptheoriesandhelpspractitionersintegratethisknowledgeintotheirassessmentwork.",';
        query+='"division":"Education",';
        query+='"divisionCode":"EDUC",';
        query+='"groupOfCompany":"OBB",';
        query+='"orderNo":"KE56710",';
        query+='"podSuitable":false,';
        query+='"infoRestrict":false,';
        query+='"infoRestrictType":null,';
        query+='"subjectClassifications":[';
        query+='{';
        query+='"code":"SCED210505",';
        query+='"description":"Assessment",';
        query+='"level":"1"';
        query+='},';
        query+='{';
        query+='"code":"SCED210505",';
        query+='"description":"Assessment2",';
        query+='"level":"2"';
        query+='},';        
        query+='{';
        query+='"code":"SCED33",';
        query+='"description":"HigherEducation",';
        query+='"level":"3"';
        query+='}';
        query+='],';
        query+='"netbaseClassifications": [';
        query+='{';
        query+='"code": "SCPI55",';
        query+='"description": "International Relations",';
        query+='"level": "2"';
        query+='},';
        query+='{';
        query+='"code": "SCPI65",';
        query+='"description": "International Relations",';
        query+='"level": "2"';
        query+='}';
        query+='],';
        query+='"pricing":[';
        query+='{';
        query+='"price":"116",';
        query+='"currency":"EUR",';
        query+='"validFrom":"2018-07-06",';
        query+='"priceType":"BYOLibraryPrice",';
        query+='"priceTypeCode":"BYO"';
        query+='},';
        query+='{';
        query+='"price":"116",';
        query+='"currency":"GBP",';
        query+='"validFrom":"2018-07-06",';
        query+='"priceType":"BYOLibraryPrice",';
        query+='"priceTypeCode":"BYO"';
        query+='},';
        query+='{';
        query+='"price":"154",';
        query+='"currency":"USD",';
        query+='"validFrom":"2018-07-06",';
        query+='"priceType":"BYOLibraryPrice",';
        query+='"priceTypeCode":"BYO"';
        query+='},';
        query+='{';
        query+='"price":"116",';
        query+='"currency":"GBP",';
        query+='"validFrom":"2018-07-06",';
        query+='"priceType":"InstitutionalPrice",';
        query+='"priceTypeCode":"IS"';
        query+='},';
        query+='{';
        query+='"price":"154",';
        query+='"currency":"USD",';
        query+='"validFrom":"2018-07-06",';
        query+='"priceType":"InstitutionalPrice",';
        query+='"priceTypeCode":"IS"';
        query+='},';
        query+='{';
        query+='"price":"10",';
        query+='"currency":"GBP",';
        query+='"validFrom":"2017-09-12",';
        query+='"priceType":"RetailPrice",';
        query+='"priceTypeCode":"LP"';
        query+='},';
        query+='{';
        query+='"price":"10",';
        query+='"currency":"USD",';
        query+='"validFrom":"2017-09-12",';
        query+='"priceType":"RetailPrice",';
        query+='"priceTypeCode":"LP"';
        query+='},';
        query+='{';
        query+='"price":"66",';
        query+='"currency":"NZD",';
        query+='"validFrom":"2018-05-04",';
        query+='"priceType":"RetailPrice",';
        query+='"priceTypeCode":"LP"';
        query+='},';
        query+='{';
        query+='"price":"63.63",';
        query+='"currency":"AUD",';
        query+='"validFrom":"2018-05-30",';
        query+='"priceType":"RetailPrice",';
        query+='"priceTypeCode":"LP"';
        query+='}';
        query+='],';
        query+='"originators":[';
        query+='{';
        query+='"firstName":"MatthewB.",';
        query+='"lastName":"Fuller",';
        query+='"originatorType":"Translated",';
        query+='"originatorTypeCode":"TRTest",';
        query+='"sortOrder":"1"';
        query+='},';
        query+='{';
        query+='"firstName":"TomTomTomTomTomTomTomTomTomTomTomTomTomTomTomTomTomTomTomTomTomTomTomTomTomTomTomTomTomTomTomTom",';
        query+='"lastName":"Reed",';
        query+='"originatorType":"Translated",';
        query+='"originatorTypeCode":"TRTest",';
        query+='"sortOrder":"1"';
        query+='}';        
        query+='],';
        query+='"distributionCenters":[';
        query+='{';
        query+='"distributionCenter":"USKentucky",';
        query+='"distributionCenterCode":"USNY",';
        query+='"primaryDistributionCenter":true,';
        query+='"publicationDate":"2020-06-30T09:44:53Z",';
        query+='"plannedPublicationDate":"2019-02-21",';
        query+='"discountGroup":"O-USAHSSProfessionalReference",';
        query+='"discountGroupCode":"O",';
        query+='"status":"InProduction",';
        query+='"statusCode":"IHST"';
        query+='},';
        query+='{';
        query+='"distributionCenter":"Australia-TLD",';
        query+='"distributionCenterCode":"AUS",';
        query+='"primaryDistributionCenter":false,';
        query+='"publicationDate":null,';
        query+='"plannedPublicationDate":"2019-03-14",';
        query+='"discountGroup":"Trade/Professional",';
        query+='"discountGroupCode":"PROF",';
        query+='"status":"InProduction",';
        query+='"statusCode":"IHST"';
        query+='},';
        query+='{';
        query+='"distributionCenter":"UK",';
        query+='"distributionCenterCode":"LOC1",';
        query+='"primaryDistributionCenter":false,';
        query+='"publicationDate":null,';
        query+='"plannedPublicationDate":"2019-02-28",';
        query+='"discountGroup":"10(oldTPS12)-InformaLaw&ElectrMedia",';
        query+='"discountGroupCode":"10",';
        query+='"status":"InProduction",';
        query+='"statusCode":"IHST"';
        query+='},';
        query+='{';
        query+='"distributionCenter":"Singapore",';
        query+='"distributionCenterCode":"SING",';
        query+='"primaryDistributionCenter":false,';
        query+='"publicationDate":null,';
        query+='"plannedPublicationDate":null,';
        query+='"discountGroup":null,';
        query+='"discountGroupCode":null,';
        query+='"status":"InProduction",';
        query+='"statusCode":"IHST"';
        query+='},';
        query+='{';
        query+='"distributionCenter":"USFL",';
        query+='"distributionCenterCode":"USFL",';
        query+='"primaryDistributionCenter":false,';
        query+='"publicationDate":null,';
        query+='"plannedPublicationDate":null,';
        query+='"discountGroup":null,';
        query+='"discountGroupCode":null,';
        query+='"status":"InProduction",';
        query+='"statusCode":"IHST"';
        query+='}';
        query+='],';
        query+='"marketingRestrictions":{';
        query+='"noCanada":false,';
        query+='"noLatAm":false,';
        query+='"noUS":false,';
        query+='"noROW":false';
        query+='},';
        query+='"drm":false,';
        query+='"isSellable":true,';
        query+='"readyForMarket":true,';
        query+='"ebookRestriction":"Institutional,retailandAtypon",';
        query+='"ebookRestrictionCode":"EBRALL",';
        query+='"distributionRights": {';
        query+='"exclusionList": [';
        query+='{';
        query+='"iso2": "AR",';
        query+='"iso3": "ARG",';
        query+='"isonum": "032",';
        query+='"name": "Argentina"';
        query+='},';
        query+='{';
        query+='"iso2": "AR1",';
        query+='"iso3": "ARG1",';
        query+='"isonum": "033",';
        query+='"name": "Bolivia"';
        query+='}';        
        query+=']';
        query+='}';            
        query+='}';
        query+='}';    
        
        test.startTest();
        //Test for success on the dummy endpoint.
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json'); 
        req.requestURI = '/services/apexrest/ProductAPI/productSyncTest';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        Integer resStatus = res.statusCode;
        Blob resBody = res.responseBody;
        ProductAPI.productSyncTest();
        
        
        //Test for a success.
        RestRequest req1 = new RestRequest();
        RestResponse res1 = new RestResponse();
        req1.addHeader('Content-Type', 'application/json'); 
        req1.requestURI = '/services/apexrest/ProductAPI/productSync';
        req1.httpMethod = 'POST';
        req1.requestBody = blob.ValueOf(query);
        RestContext.request = req1;
        RestContext.response = res1;
        ProductAPI.productSync();
        //Validate that the product created successfully and the fields were mapped.
        Product2 recordResult = [SELECT Id, Name FROM Product2 WHERE ProductCode = '1234567891111'];
        system.assertEquals('Tom Test 2018-01-31', recordResult.Name);
        List<Product2> fullProductList = [SELECT Id, Name FROM Product2];
        //Validate we only have two products.
        system.assertEquals(2, fullProductList.size());
        
        for(Setting_Item__c si: [SELECT Id, Text_2__c FROM Setting_Item__c WHERE Setting__c =: ProductAPI_ErrorLogs.Id]){
            system.debug(si.Text_2__c);
        }
        
        //Validate that the correct prices were added to each pricebook.
        system.debug([SELECT CurrencyIsoCode, UnitPrice, Pricebook2.Name FROM Pricebookentry]);
        Decimal usdBYO = [SELECT UnitPrice FROM Pricebookentry 
                          WHERE product2id=:recordResult.Id AND CurrencyIsoCode = 'USD'
                          AND Pricebook2.Name='T&F - eBooks Pricebook'].UnitPrice;
        system.assertEquals(154, usdBYO);
        Decimal usdRetailPrice = [SELECT UnitPrice FROM Pricebookentry 
                                  WHERE product2id=:recordResult.Id AND CurrencyIsoCode = 'USD'
                                  AND Pricebook2.Name='T&F Pricebook'].UnitPrice;
        system.assertEquals(10, usdRetailPrice);
        Decimal standardPrice = [SELECT UnitPrice FROM Pricebookentry 
                                 WHERE product2id=:recordResult.Id AND CurrencyIsoCode = 'USD'
                                 AND Pricebook2.Name='Standard Price Book'].UnitPrice;
        system.assertEquals(10, standardPrice);        
        
        //Test again now the product has been created.
        ProductAPI.runProductSync(query);           
        fullProductList = [SELECT Id, Hardback_ISBN__c, eBook_ISBN__c, Name FROM Product2];
        //Validate we still have only 1 product.
        system.assertEquals(2, fullProductList.size());
        //Validate that the hardback and eBook ISBN fields are the same on both products because of the related dac key.
        Integer loopNum = 1;
        Boolean isMatch = false;
        String valueOne = '';
        String valueTwo = '';
        for(Product2 P: fullProductList){
            if(loopNum == 1){valueOne = p.Hardback_ISBN__c+p.eBook_ISBN__c;
                            } else {
                                valueTwo = p.Hardback_ISBN__c+p.eBook_ISBN__c;
                            }
            loopNum++;
        }
        isMatch = valueOne == valueTwo ? true : false;
        system.assertEquals(true, isMatch);
        
        //Create a record in the error log which will successfully process.
        Setting_Item__c errorLog = new Setting_Item__c();
        errorLog.Setting__c = ProductAPI_ErrorLogs.Id;
        errorLog.Text_1__c = String.ValueOf(system.now());
        errorLog.Text_2__c = 'ERROR: Test';
        errorLog.Text_3__c = '1234567891111:'+'2019-06-30T09:44:53Z';
        errorLog.Long_Text_1__c = query;  
        errorLog.Checkbox_1__c = false;
        insert errorLog;
        
        //Test for a failure.
        RestRequest req2 = new RestRequest();
        RestResponse res2 = new RestResponse();
        req2.addHeader('Content-Type', 'application/json'); 
        req2.requestURI = '/services/apexrest/ProductAPI/productSync';
        req2.httpMethod = 'POST';
        req2.requestBody = blob.ValueOf('Error String');
        RestContext.request = req2;
        RestContext.response = res2;
        ProductAPI.productSync();
        //Validate that the error got stored to be retried later.
        List<Setting_Item__c> errorLogList = [SELECT Id, Long_Text_1__c FROM Setting_Item__c WHERE Setting__c =: ProductAPI_ErrorLogs.Id];
        for(Setting_Item__c si: [SELECT Id, Text_2__c FROM Setting_Item__c WHERE Setting__c =: ProductAPI_ErrorLogs.Id]){
            system.debug(si.Text_2__c);
        }
        system.assertEquals(2, errorLogList.size());
        
        SheduleProductAPIReRunErrorsBatch s = new SheduleProductAPIReRunErrorsBatch();  
        s.execute(null) ;
        
        test.stopTest();
        //Validate that 1 of the errors was successfully processed, leaving only 1 which didn't process.
        errorLogList = [SELECT Id,Text_3__c FROM Setting_Item__c WHERE Setting__c =: ProductAPI_ErrorLogs.Id];        
        system.assertEquals(1, errorLogList.size());
        
    }
    
}