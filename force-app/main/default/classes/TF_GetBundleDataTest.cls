@isTest
public class TF_GetBundleDataTest implements HttpCalloutMock{
    
    private integer statusCode;
    private String responseJson;
    public TF_GetBundleDataTest(integer statusCode, String responseJson){
        this.statusCode = statusCode; 
        this.responseJson = responseJson;
    }
    
    public HTTPResponse respond(HTTPRequest req) {
        if(responseJson != 'validate test'){
            // Create a mock response
            HttpResponse resp = new HttpResponse();
            resp.setHeader('Content-Type', 'application/json');
            resp.setBody(responseJson);      
            resp.setStatusCode(statusCode);
            return resp;
        } else{
            String resptJson ;
            if(req.getEndpoint().endsWith('.json') && req.getMethod() == 'PUT'){
                resptJson = '{test}';
                HttpResponse resp = new HttpResponse();
                resp.setHeader('Content-Type', 'application/json');
                resp.setBody(resptJson);      
                resp.setStatusCode(200);
                return resp;
            } else if(req.getEndpoint().endsWith('user/auth/token')){
                resptJson = '{"access_token":"10edc9086eefa8e672eca3ad1b0040a2","token_type":"Bearer","expires_in":3600,"id_token":"eyJhbGciOiJSUzI1NiIsI"}';
                
                HttpResponse resp = new HttpResponse();
                resp.setHeader('Content-Type', 'application/json');
                resp.setBody(resptJson);      
                resp.setStatusCode(200);
                return resp;
                
            }else if(req.getEndpoint().endsWith('products/validation') && req.getBody().contains('"validation" : false')){
                resptJson = '{"s3Location":"https://s3-eu-west-1.amazonaws.com/s3-euw1-ap-pe-df-product-store-products-d/Integrations/Identifier-Identifier-Map/Responses/2019/01/24/14/49/07/2019-01-24-14-49-07-014.json"}';
                HttpResponse resp = new HttpResponse();
                resp.setHeader('Content-Type', 'application/json');
                resp.setBody(resptJson);      
                resp.setStatusCode(200);
                return resp;
            }  else if(req.getEndpoint().endsWith('products/validation')){
                resptJson = '{"s3Response":"https://s3-eu-west-1.amazonaws.com/s3-euw1-ap-pe-df-product-store-products-d/Integrations/validations/Responses/2019/01/23/14/25/43/2019-01-23-14-25-43-648.json"}';
                HttpResponse resp = new HttpResponse();
                resp.setHeader('Content-Type', 'application/json');
                resp.setBody(resptJson);      
                resp.setStatusCode(200); 
                return resp;
            } else if(req.getEndpoint().endsWith('.json') && req.getMethod() == 'GET'){
                resptJson = '{"topic": "product-info-response","source": "product-store","application": "products","timestamp": "2018-04-17T13:01:00.180Z","responses": [{"keyType": "doi","targets": [{"value": "1234","uuid": "dc3b350b-0823-4e15-953f-a4dbaac2b149","result": "Success","error": ""},{"value": "5678","uuid": "","result": "Failure","error": "UUID Not Found"}]}]}';
                
                HttpResponse resp = new HttpResponse();
                resp.setHeader('Content-Type', 'application/json');
                resp.setBody(resptJson);      
                resp.setStatusCode(statusCode);
                return resp;
            }else if(req.getEndpoint().endsWith('v4/products/?type=creativework') && req.getMethod() == 'GET'){
                resptJson = '[{"x_id":"f3e4880e-69da-402c-a06c-5988cb8a6637","offers":[],"category":[{"name":"Webinar & Podcasts"}],"keywords":[{"name":" POVERTY","description":" Poverty","position":1},{"name":" HUNGER","description":" Hunger","position":2}],"contributor":[{"name":"arindam","givenName":"arindam","familyName":"arindam","role":"author,cms_user,content_aprover","position":1}],"rights":[],"restrictions":[],"id":"f3e4880e-69da-402c-a06c-5988cb8a6637","type":"CreativeWork","additionalType":"CuratedContent","title":"uat check","isPartOf":"UNSDG","format":"image/png","edition":"1","inLanguage":"ENGL","version":"1.0","isAlignedTo":"UNSDGO","doi":"2","chapterDOI":"m","description":"Enter short description of the asset","datePublished":"2018-11-23","dateModified":"2018-08-06T06:33:42Z","CopyrightYear":"2018","copyrightHolder":{"name":"Taylor & Francis Group"},"publisher":"Taylor & Francis Group","associatedMedia":{"asset":"https://s3-euw1-ap-pe-df-content-store-assets-u.s3.eu-west-1.amazonaws.com/curatedcontent//taylor_francis_group.png"},"abstract_Z":"Enter short description of the asset","x_v":0,"_createdDate":1547409385170}]';
                HttpResponse resp = new HttpResponse();
                resp.setHeader('Content-Type', 'application/json');
                resp.setBody(resptJson);      
                resp.setStatusCode(200);
                return resp;
            }
            else if(req.getEndpoint().endsWith('parts?offset=0&limit=2&expanded=true') && req.getMethod() == 'GET'){
                resptJson = '{"id":"be963847-98ad-4001-948f-76e1a3adf0f5","partsCount":98,"parts":[{"@id":"00c99870-7819-4a90-b78e-ecaf86f6106c","@type":"Chapter","curationSource":"Manual","doi":"10.4324/9781351022187-5","image":{"cover":"https://images.tandf.co.uk/common/jackets/agentjpg/978113849/9781138496316.jpg"},"isAccessibleForFree":false,"isPartOf":[{"title":"Ukrainian Erotomaniac Fictions: First Postindependence Wave","doi":"10.4324/9781351022187","@id":"9c43274c-92ee-4347-94a0-1c98e5f76986","@type":"Book","format":"e-Book","edition":"1","editionId":"664493","isbn":"9781351022187","contributors":[{"roles":["author"],"givenName":"Maryna","familyName":"Romanets","email":null,"bio":"Maryna Romanets is a Professor in the Department of English at the University of Northern British Columbia, Canada. She is the author of Anamorphosic Texts and Reconfigured Visions: Improvised Traditions in Contemporary Ukrainian and Irish Literature and coeditor of Beauty, Violence, Representation.","orcid":null,"affiliation":[],"collab":null,"fullName":"Maryna Romanets","position":1}]}],"openAccess":false,"pageEnd":"97","pageStart":"79","position":1,"publicationDate":"2019-04-25","publisherImprint":"Routledge","subtitle":null,"title":"The Monstrosity of Desire and the Delights of Carnal Hell: Shevchuk’s Neo-Baroque Angst","contributors":[{"roles":["author"],"givenName":"Maryna","familyName":"Romanets","email":null,"bio":null,"orcid":null,"affiliation":[],"collab":null,"fullName":"Maryna Romanets","position":1}]}]}';
                HttpResponse resp = new HttpResponse();
                resp.setHeader('Content-Type', 'application/json');
                resp.setBody(resptJson);      
                resp.setStatusCode(200);
                return resp;
            }
            else if(req.getEndpoint().contains('parts?offset=0&limit=10') && req.getMethod() == 'GET'){
                resptJson = '{"id":"be963847-98ad-4001-948f-76e1a3adf0f5","partsCount":98,"parts":[{"@id":"00c99870-7819-4a90-b78e-ecaf86f6106c","@type":"Chapter","curationSource":"Manual","doi":"10.4324/9781351022187-5","image":{"cover":"https://images.tandf.co.uk/common/jackets/agentjpg/978113849/9781138496316.jpg"},"isAccessibleForFree":false,"isPartOf":[{"title":"Ukrainian Erotomaniac Fictions: First Postindependence Wave","doi":"10.4324/9781351022187","@id":"9c43274c-92ee-4347-94a0-1c98e5f76986","@type":"Book","format":"e-Book","edition":"1","editionId":"664493","isbn":"9781351022187","contributors":[{"roles":["author"],"givenName":"Maryna","familyName":"Romanets","email":null,"bio":"Maryna Romanets is a Professor in the Department of English at the University of Northern British Columbia, Canada. She is the author of Anamorphosic Texts and Reconfigured Visions: Improvised Traditions in Contemporary Ukrainian and Irish Literature and coeditor of Beauty, Violence, Representation.","orcid":null,"affiliation":[],"collab":null,"fullName":"Maryna Romanets","position":1}]}],"openAccess":false,"pageEnd":"97","pageStart":"79","position":1,"publicationDate":"2019-04-25","publisherImprint":"Routledge","subtitle":null,"title":"The Monstrosity of Desire and the Delights of Carnal Hell: Shevchuk’s Neo-Baroque Angst","contributors":[{"roles":["author"],"givenName":"Maryna","familyName":"Romanets","email":null,"bio":null,"orcid":null,"affiliation":[],"collab":null,"fullName":"Maryna Romanets","position":1}]}]}';
                HttpResponse resp = new HttpResponse();
                resp.setHeader('Content-Type', 'application/json');
                resp.setBody(resptJson);      
                resp.setStatusCode(200);
                return resp;
            }
            else if(req.getEndpoint().contains('parts?') && req.getMethod() == 'GET'){
                resptJson = '[{"_id": "0016bcce-dfcf-4ba5-b60c-2661b64c7a7b","type": "book","title": "Intellectual Capital in the Digital Economy","position": 1,"level": 0,"version": null,"isFree": false,"identifiers": {"doi": "10.4324/9780429285882"},"contributors": [{"roles": ["editor"],"fullName": "Patricia Ordóñez de Pablos"},{"roles": ["editor"],"fullName": "Leif Edvinsson"}],"book": {"subtitle": null,"publisherImprint": "Routledge","publicationDate": "2020-03-09T00:00:00.000Z","format": "e-Book"} },{"_id": "01fe3bd4-c924-404a-94d2-1930061796d8","type": "book","title": "Ask, Explore, Write!","position": 2,"level": 0,"version": null,"isFree": false,"identifiers": {"doi": "10.4324/9780429275265"},"contributors": [{"roles": ["author"],"fullName": "Troy Hicks"},{"roles": ["author"],"fullName": "Jeremy Hyler"},{"roles": ["author"],"fullName": "Wiline Pangle"}],"book": {"subtitle": "An Inquiry-Driven Approach to Science and Literacy Learning","publisherImprint": "Routledge","publicationDate": "2020-02-12T00:00:00.000Z","format": "e-Book”}}]';
                
                HttpResponse resp = new HttpResponse();
                resp.setHeader('Content-Type', 'application/json');
                resp.setBody(resptJson);      
                resp.setStatusCode(200);
                return resp;
            }
            else if(req.getEndpoint().endsWith('?apiVersion=4.0.1&responseGroup=large') && req.getMethod() == 'GET'){
                resptJson = '{"product": {"_id": "149713ed-af73-421c-b5d4-f417002465e5","identifiers": { "doi": "","sku": "01t9E000009uyPTQAY","collectionId": null},"collection": {"counts": [{"type": "book","count": 6,"formatsCount": []}],"ruleUpdateStartDate": "2020-11-26T16:02:05.525Z","ruleUpdateEndDate": "2020-11-26T16:02:05.525Z","status": "available","subtitle": "","description": "DESC","publisherImprint": "", "publicationDate": null,"copyright": null,"edition": null,"doiRegistrationStatus": false,"firstPublishedYear": 2020,"firstPublishedYearNumber": null,"plannedPublicationDate": "2020-11-26T15:59:15.000Z","inLanguage": null,"abstracts": [{"type": "text ", "position": null,"value": "DESC","caption": null,"location": null,"transcript": null}],"citation": null}, "prices": [ {"price": 44,"currency": "GBP","validFrom": "2020-11-26T16:01:30.000Z","validTo": null,"priceType": "BYO Library Price","priceTypeCode": "BYO"},{"price": 33,"currency": "USD","validFrom": "2020-11-26T16:01:30.000Z","validTo": null,"priceType": "BYO Library Price","priceTypeCode": "BYO"} ], "type": "collection","version": "1.0","title": "testStaticCollectionDev","categories": [{ "code": "","name": "collection-type","type": "SDGO" },{"code": null,"name": "collection-update-type","type": "static"} ],"classifications": [{"level": null,"priority": null,"group": "","code": "","name": "","type": "Subject"}], "keywords": [{"type": "catchword","name": "Key1","position": 1,"weightage": null}],"contributors": [{"roles": ["Author"],"givenName": "Test First","familyName": "Last","fullName": "Test First Last","email": null,"bio": null,"orcid": null,"collab": null,"affiliations": null,"position": 1 } ],"isPartOf": [], "permissions": [{ "name": "info-restrict","code": "IN","text": "Restrict Information about Product", "type": "access","description": null,"validTo": null,"validFrom": null } ],"rights": [],"audience": [],"associatedMedia": []},"availability": []}';
                
                HttpResponse resp = new HttpResponse();
                resp.setHeader('Content-Type', 'application/json');
                resp.setBody(resptJson);      
                resp.setStatusCode(200);
                return resp;
            }else if(req.getEndpoint().endsWith('products') && req.getBody().contains('new-id')){
                resptJson = '{"newId":"b977b443-b49a-4f71-b8db-be43f041fb23"}';
                HttpResponse resp = new HttpResponse();
                resp.setHeader('Content-Type', 'application/json');
                resp.setBody(resptJson);      
                resp.setStatusCode(200); 
                return resp;
            } 
        } 
        return null;
    }
    
    @testSetup
    public static void createTestData(){
        
        TF_OrgSpecificProps__c setting = new TF_OrgSpecificProps__c();
        setting.Unsilo_Host_Url__c = 'https://services.unsilo.com/api/classify/tandf/classes/';
        setting.Unsilo_UserName__c = 'testuser';
        setting.Unsilo_Password__c = 'testpass';
        setting.AWS_Region_Name__c = 'us-west-2';
        setting.AWS_S3_Host_Url__c = 'https://s3-euw1-ap-pe-df-product-store-products-d.s3.eu-west-1.amazonaws.com';
        setting.AWS_Secret_Access_key__c = 'hY+Hd6mxpYsqASJDQDG2at53nyKgJZ6OBWn98gic';
        setting.AWS_Access_Key_Id__c = 'AKIAIGGCPKCJXTHQEPUQ ';
        setting.AWS_SNS_Host_Url__c = 'https://sns.eu-west-1.amazonaws.com';
        setting.AWS_SNS_TopicArn__c = 'arn:aws:sns:eu-west-1:012177264511:sns-euw1-ap-pe-df-product-store-products-d';
        setting.Name = 'sample1';
        insert setting; 
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        
        Product2 newParentProduct = new Product2();
        newParentProduct.name='testAwsService';
        newParentProduct.IsActive=true;
        newParentProduct.Description='test';
        newParentProduct.RecordTypeId=productRecordtypeId;
        newParentProduct.Category__c='[{"name":"test test","givenName":"test","familyName":"test","role":"Editor","position":1}]';
        newParentProduct.keywords__c='[{"name":"harish","description":"HARISH","position":1}]';
        newParentProduct.copyrightyear__c='2018';
        newParentProduct.Lead_Author_Editor__c='test';
        newParentProduct.Product_Type_Author_Facing__c='Manual Curation';
        newParentProduct.alternateName__c='alternate';
        newParentProduct.inLanguage__c='en';
        newParentProduct.version__c='1.0';
        newParentProduct.doi__c='122/33';
        newParentProduct.ean__c='333';
        newParentProduct.issn__c='12345';
        newParentProduct.Publisher__c='Pub';
        newParentProduct.businessid__c='SDG-TEST';
        newParentProduct.Sales_Channels__c='UBX_sales';
        
        insert newParentProduct;
    }
    
    private static Product2 insertProductforTesting(String product2RecordtypeId){
        Product2 p = new Product2(name='test', ProductCode='12345', IsActive=true, Description='test', RecordTypeId=product2RecordtypeId,List_Price__c = 855,Sales_Price__c = 855,
                                  ISBN__c = '12345678901234', Competitor_Publisher__c='test', Subject_Code__c='test',BusinessId__c='SDGO-PRODATA',Product_category__c='SDGO',Sales_Channels__c='UBX_sales');
        insert p;
        return p;
    }
    
    private static testmethod void testPagedResult(){
        test.startTest();        
        TF_GetBundleData.PagedResult pgResult = new  TF_GetBundleData.PagedResult();
        pgResult.doi='10.4324/9781315571782-17';
        pgResult.publisher='Routledge';
        pgResult.prodId='10.4324/9781315571782-17';
        pgResult.journal='Chinese Investment in Africa';
        pgResult.publication_date='2018-02-08';
        pgResult.title='Dictionary';
        pgResult.authors='Carl Death';
        pgResult.concepts='';
        pgResult.id='2';
        pgResult.Open_access=true;
        pgResult.content_Position = 1;
        pgResult.content_icon='test';
        pgResult.datePublished='';
        pgResult.totalCount='';
        pgResult.validationResult = 'test';
        pgResult.count=0;
        pgResult.priceBYOGBP=8.5;
        pgResult.priceBYOUSD=4.5;
        pgResult.priceISGBP=3.4;
        pgResult.priceISUSD=3.4;
        pgResult.priceLPGBP=9.0;
        pgResult.priceLPUSD=9.0;
        pgResult.uuid = 'test';
        pgResult.keywords='test';
        pgResult.mediaType='test';
        pgResult.source='test';
        pgResult.isIncluded='test';
        pgResult.isIncludedIcon='test';
        pgResult.type='test';
        
        test.stopTest();
    }
    
    private static testmethod void testInitialFieldValues(){
        test.startTest();        
        TF_GetBundleData.InitialFieldValues pgResult = new  TF_GetBundleData.InitialFieldValues();
        pgResult.productState='Active';
        pgResult.productType='Collection';
        pgResult.dynamicRule='test';
        pgResult.AllowUserToUpdate='true';
        pgResult.isProductActive='true';
        pgResult.isUserAdmin='true';
        pgResult.createdByName='Carl Death';
        pgResult.lastModifiedByName='Carl Death';
        pgResult.recordTypeName='test';
        pgResult.createdById='testid';  
        pgResult.lastModifiedById='test';
        pgResult.salesforceURL='testurl';
        pgResult.createdDate='2018-02-08';
        pgResult.lastModifiedDate='2018-02-08';
        test.stopTest();
    }
    
    private static testmethod void testPagedResultDetails(){
        test.startTest();        
        TF_GetBundleData.PagedResultDetails pgResultDetail = new  TF_GetBundleData.PagedResultDetails();
        pgResultDetail.total=50;
        pgResultDetail.prevPstn=1;
        pgResultDetail.nextPstn=3;
        pgResultDetail.currPstn=2;
        pgResultDetail.productTypeReturned='test';
        test.stopTest();         
    }
    
    
    @isTest
    private static void testgetProductsFromPCMById(){
        
        string jsonStr = 'validate test';
        Test.setMock(HttpCalloutMock.class, new TF_GetBundleDataTest(200, jsonStr));
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');       
        //Product2 newParentProduct = zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        newParentProduct.IsActive=true;
        update newParentProduct;
        test.startTest();
        TF_GetBundleData.PagedResultDetails thisResult = new TF_GetBundleData.PagedResultDetails();
        thisResult = TF_GetBundleData.getProductsFromPCMById(newParentProduct.id,'book');
        System.assert(thisResult != null);
        test.stopTest();
    }
    
    @isTest
    private static void testgetPartsFromPCMNewDataModel(){
        
        string jsonStr = 'validate test';
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');       
        //Product2 newParentProduct = zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        newParentProduct.IsActive=true;
        update newParentProduct;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TF_GetBundleDataTest(200, jsonStr));
        TF_GetBundleData.PagedResultDetails thisResult = new TF_GetBundleData.PagedResultDetails();
        thisResult = TF_GetBundleData.getPartsFromPCMNewDataModel(newParentProduct.id,'0','book');
        System.assert(thisResult != null);
        test.stopTest();
    }
    @isTest
    private static void test_getBundleRuleInformation(){
        test.startTest();
        
        string jsonStr = 'validate test';
        
        Test.setMock(HttpCalloutMock.class, new TF_GetBundleDataTest(200, jsonStr));
        
        TF_GetBundleData.InitialFieldValues result ;
        TF_GetBundleData.InitialFieldValues resultapp ;
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');        
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        
        newParentProduct.Approval_Status__c='Draft';
        update newParentProduct;
        result=TF_GetBundleData.getBundleRuleInformation(newParentProduct.id);
        System.assert(result!= null); 
        
        //Product2 newParentProductapp=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newParentProductapp=insertProductforTesting(productRecordtypeId);
        newParentProductapp.Approval_Status__c='Approved';
        newParentProductapp.Dynamic_Collection_Criteria__c='testrule';
        update newParentProductapp;
        resultapp=TF_GetBundleData.getBundleRuleInformation(newParentProductapp.id);
        System.assert(resultapp!= null); 
        
        //Product2 newParentProduct2=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct2=insertProductforTesting(productRecordtypeId);
        
        newParentProduct2.Approval_Status__c='Approved';
        newParentProduct2.APIStatus__c='GetUUID Incomplete';
        update newParentProduct2;
        resultapp=TF_GetBundleData.getBundleRuleInformation(newParentProduct2.id);
        System.assert(resultapp!= null);
        
        test.stopTest();
    }
    //added by shubham kumar 
    //@ description : to test the delete method for specific bundle line items.
    private static testmethod void getAllSpecificBundleItems(){
        test.startTest();
        //String msg;
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - BespokeCollection');
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        //inserting bundle line item for unsilo
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Title__c='World Heritage';
        lineItem.IsUnsilo__c=true;
        lineItem.Authors__c='Rosalie Callway';     
        lineItem.Product_Bundle_Parent__c=newParentProduct.id;
        insert lineItem;
        TF_GetBundleData.getBundleLineItemsByProductId(newParentProduct.Id);
        test.stopTest();
    }
    
    //added by shubham kumar 
    //@ description : to test the delete method for specific bundle line items.
    private static testmethod void testdeleteSpecificBundleItems(){
        test.startTest();
        String msg;
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - BespokeCollection');
        //Test Account Insert
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        //Sap BP creation
        SAP_BP__c SAP_BP_Record = new SAP_BP__c();
        SAP_BP_Record.Name = 'Pending';
        SAP_BP_Record.Address_Type__c = 'Account Mailing';
        SAP_BP_Record.Country__c = 'India';
        insert SAP_BP_Record;
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F Automated eBooks Opportunity').getRecordTypeId();
        
        
        //Opp
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.StageName = 'Acceptance';
        opp.AccountId = a.id;
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Order_Status__c = 'Pending';
        opp.Account_Validate_Opp__c = true;
        opp.recordTypeId = oppRecordTypeId;
        opp.Bill_To_BP__c = SAP_BP_Record.id;
        opp.TF_eBook_License_Type__c='Static';
        insert opp;
        
        
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        
        //Pricebook2 
        Pricebook2 pricebk = new Pricebook2(Name='T&F - eBooks Pricebook', isActive=true);
        insert pricebk;      
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = newParentProduct.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        //PriceBook Entry
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = pricebk.Id, Product2Id = newParentProduct.Id,UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        //Quote 
        Id quoteRecordtypeId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'Automated eBook Direct Sales Orders');
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(CurrencyIsoCode = 'USD', SBQQ__Opportunity2__c = opp.Id,SBQQ__BillingCity__c = 'test Billing',SBQQ__Account__c = a.Id, Payer_Account__c = a.Id, SBQQ__ExpirationDate__c = System.today() + 60, SBQQ__Status__c = 'Accepted', SBQQ__Primary__c=true,Quote_Type__c = 'Direct Sale', RecordTypeId = quoteRecordtypeId); 
        insert quoteObject;
        
        
        SBQQ__QuoteLine__c qli = new SBQQ__QuoteLine__c();
        qli.SBQQ__Quote__c = quoteObject.Id;
        qli.SBQQ__Product__c = newParentProduct.Id;
        qli.SBQQ__PricebookEntryId__c = customPrice.Id;
        qli.PCM_ISBN__c = '1234567';
        qli.PCM_UUID__c = '0023303d-524f-49a0-93a5-00db3ccb9a39';
        qli.PCM_Product_Name__c = 'TestProduct';
        qli.PCM_Author_Name__c = 'testAuthor';
        qli.SBQQ__ListPrice__c = 1000;
        qli.Line_reference__c = 'test';
        qli.SBQQ__Bundled__c = true;
        qli.PCM_DOI__c = 'test';
        INSERT qli;
        system.debug('qli'+qli);
        
        //inserting bundle line item for unsilo
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Title__c='World Heritage';
        lineItem.IsUnsilo__c=true;
        lineItem.Authors__c='Rosalie Callway';     
        lineItem.Product_Bundle_Parent__c=newParentProduct.id;
        lineItem.PriceUSD__c = 50;
        insert lineItem;
        List<Bundle_Line_Item__c> bundleList = new List<Bundle_Line_Item__c>();
        bundleList.add(lineItem);
        
        
        
        msg=TF_GetBundleData.deleteSpecifiedBundles(bundleList);
        msg=TF_GetBundleData.deleteAllSpecifiedBundles(newParentProduct.Id);
        System.assert(msg != null);
        test.stopTest();
    }
    //added by shubham kumar 
    //@ description : to test the delete method for specific bundle line items.
    private static testmethod void testdeleteallSpecificBundleItems(){
        test.startTest();
        String msg;
        
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - BespokeCollection');
        //Test Account Insert
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        //Sap BP creation
        SAP_BP__c SAP_BP_Record = new SAP_BP__c();
        SAP_BP_Record.Name = 'Pending';
        SAP_BP_Record.Address_Type__c = 'Account Mailing';
        SAP_BP_Record.Country__c = 'India';
        insert SAP_BP_Record;
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F Automated eBooks Opportunity').getRecordTypeId();
        
        
        //Opp
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.StageName = 'Acceptance';
        opp.AccountId = a.id;
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Order_Status__c = 'Pending';
        opp.Account_Validate_Opp__c = true;
        opp.recordTypeId = oppRecordTypeId;
        opp.Bill_To_BP__c = SAP_BP_Record.id;
        opp.TF_eBook_License_Type__c='Static';
        insert opp;
        
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        //Pricebook2 
        Pricebook2 pricebk = new Pricebook2(Name='T&F - eBooks Pricebook', isActive=true);
        insert pricebk;      
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = newParentProduct.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        //PriceBook Entry
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = pricebk.Id, Product2Id = newParentProduct.Id,UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        //Quote 
        Id quoteRecordtypeId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'Automated eBook Direct Sales Orders');
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(CurrencyIsoCode = 'USD', SBQQ__Opportunity2__c = opp.Id,SBQQ__BillingCity__c = 'test Billing',SBQQ__Account__c = a.Id, Payer_Account__c = a.Id, SBQQ__ExpirationDate__c = System.today() + 60, SBQQ__Status__c = 'Accepted', SBQQ__Primary__c=true,Quote_Type__c = 'Direct Sale', RecordTypeId = quoteRecordtypeId); 
        insert quoteObject;
        
        
        SBQQ__QuoteLine__c qli = new SBQQ__QuoteLine__c();
        qli.SBQQ__Quote__c = quoteObject.Id;
        qli.SBQQ__Product__c = newParentProduct.Id;
        qli.SBQQ__PricebookEntryId__c = customPrice.Id;
        qli.PCM_ISBN__c = '1234567';
        qli.PCM_UUID__c = '0023303d-524f-49a0-93a5-00db3ccb9a39';
        qli.PCM_Product_Name__c = 'TestProduct';
        qli.PCM_Author_Name__c = 'testAuthor';
        qli.SBQQ__ListPrice__c = 1000;
        qli.Line_reference__c = 'test';
        qli.SBQQ__Bundled__c = true;
        qli.PCM_DOI__c = 'test';
        INSERT qli;
        system.debug('qli'+qli);
        
        //inserting bundle line item for unsilo
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Title__c='World Heritage';
        lineItem.IsUnsilo__c=true;
        lineItem.PriceUSD__c= 182;
        lineItem.Authors__c='Rosalie Callway';     
        lineItem.Product_Bundle_Parent__c=newParentProduct.id;
        insert lineItem;
        
        
        List<Bundle_Line_Item__c> bundleList = new List<Bundle_Line_Item__c>();
        bundleList.add(lineItem);
        
        
        msg=TF_GetBundleData.deleteAllSpecifiedBundles(newParentProduct.Id);
        System.assert(msg != null);
        test.stopTest();
    }
}