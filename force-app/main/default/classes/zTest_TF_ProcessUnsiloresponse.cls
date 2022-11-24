@isTest

global with sharing class zTest_TF_ProcessUnsiloresponse implements HttpCalloutMock{
    
    private integer statusCode;
    private String responseJson; 
     
    public zTest_TF_ProcessUnsiloresponse(integer statusCode, String responseJson){
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
        setting.New_Search_API_URL__c='https://api-uat.taylorfrancis.com/v4/products';
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
         Product2 p = new Product2(name='test', ProductCode='12345', IsActive=true, Description='test', RecordTypeId=product2RecordtypeId,
            ISBN__c = '12345678901234', Competitor_Publisher__c='test', Subject_Code__c='test',BusinessId__c='SDGO-PRODATA',Product_category__c='SDGO',Sales_Channels__c='UBX_sales',Product_Type_Author_Facing__c ='Manual curation');
          insert p;
        return p;
    }
    
    private static testmethod void testCounts(){
        test.startTest();        
        TF_ProcessUnsiloresponse.Counts counts = new  TF_ProcessUnsiloresponse.Counts();
        counts.count=10;
        counts.productType='Book';
        test.stopTest();
    }
    
    private static testmethod void testPagedResult(){
        test.startTest();        
        TF_ProcessUnsiloresponse.PagedResult pgResult = new  TF_ProcessUnsiloresponse.PagedResult();
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
        pgResult.content_icon='test';
        pgResult.datePublished='';
        pgResult.totalCount='';
        pgResult.count=0;
        pgResult.priceBYOGBP=8.5;
        pgResult.priceBYOUSD=4.5;
        pgResult.priceISGBP=3.4;
        pgResult.priceISUSD=4.5;
        pgResult.priceLPGBP=9.0;
        pgResult.priceLPUSD=8.9;
        test.stopTest();
    }
    
    private static testmethod void testPagedResultDetails(){
        test.startTest();        
        TF_ProcessUnsiloresponse.PagedResultDetails pgResultDetail = new  TF_ProcessUnsiloresponse.PagedResultDetails();
        pgResultDetail.total=50; 
        test.stopTest();         
    }
    
    private static testmethod void testAwsResponseDetails(){
        test.startTest();        
        TF_ProcessUnsiloresponse.AwsResponseDetails AwsResponseDetails = new  TF_ProcessUnsiloresponse.AwsResponseDetails();
        AwsResponseDetails.successMsg='success';
        AwsResponseDetails.errorCode='400';
        AwsResponseDetails.errorMsg='fail';
        AwsResponseDetails.s3URL='test_url';
        AwsResponseDetails.snsMessageId='12';
        test.stopTest();         
    }
    
    private static testMethod void testPagedResultCollections(){
        test.startTest();
        TF_ProcessUnsiloresponse.PagedResultCollections prCollections = new TF_ProcessUnsiloresponse.PagedResultCollections();
        prCollections.value='test';
        prCollections.label='test';
        test.stopTest();
    }
    
    private static testmethod void testgetUnsiloBundleRecordsBySearchSOSQL() {
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');       
        TF_ProcessUnsiloresponse.PagedResult contentData = new TF_ProcessUnsiloresponse.PagedResult();
        String searchText='World';
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);  
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        //inserting bundle line item for unsilo
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Title__c='World Heritage';
        lineItem.IsUnsilo__c=true;
        lineItem.Authors__c='Rosalie Callway';     
        lineItem.Product_Bundle_Parent__c=newParentProduct.id;
        insert lineItem;        
        TF_ProcessUnsiloresponse.getUnsiloBundleRecordsBySearchSOSQL(searchText,newParentProduct.id,''); 
		TF_ProcessUnsiloresponse.getUnsiloBundleRecordsBySearchSOSQL(searchText,newParentProduct.id,'selectAndDel'); 
        //TF_ProcessUnsiloresponse.getUnsiloBundleRecordsBySearchSOSQL(searchText,newParentProduct.id,'ValidationExclusion'); 
         //TF_ProcessUnsiloresponse.getUnsiloBundleRecordsBySearchSOSQL(searchText,newParentProduct.id,'searchExclusion');  
      

        test.stopTest();          
    }
    
    private static testmethod void testgetUnsiloBundleRecordsBySearchSOSQL_val() {
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');       
        TF_ProcessUnsiloresponse.PagedResult contentData = new TF_ProcessUnsiloresponse.PagedResult();
        String searchText='World';
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        //inserting bundle line item for unsilo
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Title__c='World Heritage';
        lineItem.IsUnsilo__c=true;
        lineItem.Authors__c='Rosalie Callway'; 
        lineItem.Valid__c = 'false';
        lineItem.Product_Bundle_Parent__c=newParentProduct.id;
        insert lineItem;        
        TF_ProcessUnsiloresponse.getUnsiloBundleRecordsBySearchSOSQL(searchText,newParentProduct.id,'Validation'); 
        test.stopTest();          
    }
    
    private static testmethod void testgetProductDetails() {
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);  
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        TF_ProcessUnsiloresponse.getProductDetails(newParentProduct.id);
        test.stopTest();
    }
    
    private static testmethod void testdeleteAllUnsiloDocs(){
        test.startTest();
        String msg;
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        //inserting bundle line item for unsilo
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Title__c='World Heritage';
        lineItem.IsUnsilo__c=true;
        lineItem.Authors__c='Rosalie Callway';     
        lineItem.Product_Bundle_Parent__c=newParentProduct.id;
        insert lineItem;
        msg=TF_ProcessUnsiloresponse.deleteAllSpecifiedDocs(newParentProduct.id, 'All');
        System.assert(msg != null);
        test.stopTest();
    }
    
    private static testmethod void testgetUnsiloBundleRecords(){
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        //inserting bundle line item for unsilo
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Title__c='World Heritage';
        lineItem.IsUnsilo__c=true;
        lineItem.Content_Position__c = 1 ;
        lineItem.Authors__c='Rosalie Callway';     
        lineItem.Product_Bundle_Parent__c=newParentProduct.id;
        insert lineItem;
        Bundle_Line_Item__c lineItem1 = new Bundle_Line_Item__c();
        lineItem1.Title__c='World Heritage';
        lineItem1.IsUnsilo__c=true;
        lineItem1.Content_Position__c = -1 ;
        lineItem1.Authors__c='Rosalie Callway';     
        lineItem1.Product_Bundle_Parent__c=newParentProduct.id;
        insert lineItem1;
        TF_ProcessUnsiloresponse.getUnsiloBundleRecords(newParentProduct.id,'0','0','First','true');  
        TF_ProcessUnsiloresponse.getUnsiloBundleRecords(newParentProduct.id,'0','0','Next','');        
        TF_ProcessUnsiloresponse.getUnsiloBundleRecords(newParentProduct.id,'0','0','Prev','');        
        TF_ProcessUnsiloresponse.getUnsiloBundleRecords(newParentProduct.id,'0','2','Last','');        
        
        test.stopTest();
        
    }
    
    private static testmethod void testupdateContents(){
        String strJason= '[{"Open_access":true,"id":"a3E1l0000004UAVEA2"}]';
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId); 
		Product2 newParentProduct=insertProductforTesting(productRecordtypeId);        
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Title__c='World Heritage';
        lineItem.IsUnsilo__c=true;
        lineItem.Authors__c='Rosalie Callway';     
        lineItem.Product_Bundle_Parent__c=newParentProduct.id;
        insert lineItem; 
        strJason = strJason.replace('a3E1l0000004UAVEA2',lineItem.id);
        TF_ProcessUnsiloresponse.updateContents(strJason);
        test.stopTest();
    }
    
    private static testmethod void testaddContents(){
        String strJason='[{"authors":"Richard A Meganck||Richard E Saunier","doi":"10.4324/9781849771009-14","id":"10.4324/9781849771009-14","journal":"Dictionary and Introduction to Global Environmental Governance","prodId":"9781136568060_10.4324/9781849771009-14","publication_date":"2018-02-07","publisher":"Earthscan","title":"Dictionary"}]';
        String classId='1008';      
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        TF_ProcessUnsiloresponse.addContents(newParentProduct.Id,strJason,classId,'UNSILO','Chapter');
        test.stopTest();
    }   
    
    
    private static testmethod void testUnsiloCallout_Success() {
        
        String jsonStr = '{"export":{"title":"Goal 17 partnerships","exportDate":"2018-10-09_11-47","documents":[{"publisher":"Earthscan","doi":"10.4324/9781849771009-14","id":"9781136568060_10.4324/9781849771009-14","journal":"Dictionary and Introduction to Global Environmental Governance","publicationDate":"2018-02-07","title":"Dictionary","authors":[{"lastName":"Richard A Meganck"},{"lastName":"Richard E Saunier"}],"concepts":[{"label":"Global Crop Diversity Trust","score":14.247812},{"label":"Water Footprint","score":13.513458},{"label":"Water Poverty Index","score":12.933039},{"label":"Virtual Water","score":12.890074},{"label":"Developing Country","score":12.190496},{"label":"Integrated Water Resource Management","score":11.776872},{"label":"Kyoto Protocol","score":11.539722},{"label":"Heavily Indebted Poor Countries","score":11.378412},{"label":"World Water Day","score":11.0296335},{"label":"Mekong River Commission","score":10.879795},{"label":"Kimberley Process Certification Scheme","score":10.736309},{"label":"Organization Of American States Systems","score":10.682202},{"label":"Clean Development Mechanism","score":10.679563},{"label":"Sustainable Development","score":10.649567},{"label":"International Civil Service Commission","score":10.568916},{"label":"Climate Change","score":10.505889},{"label":"World Water Council","score":10.399822},{"label":"Boiled Frog Syndrome","score":10.398923},{"label":"Vienna Convention","score":10.381069},{"label":"Official Development Assistance","score":10.352699}],"rights":[]}],"concepts":[{"label":"Technology Transfer","state":"DEFAULT","type":"MANUAL"},{"label":"Capacity Building","state":"DEFAULT","type":"MANUAL"},{"label":"Civil Society","state":"DEFAULT","type":"MANUAL"},{"label":"Debt Relief","state":"DEFAULT","type":"MANUAL"},{"label":"North South Collaboration","state":"DEFAULT","type":"MANUAL"},{"label":"Sustainable Development","state":"DEFAULT","type":"MANUAL"}]},"path":"/tandf/classes/1008/exports/309","apiResponseStatus":"SUCCESS","status":"OK","currentTimestamp":"2018-10-09T11:47:31Z"}';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_ProcessUnsiloresponse(200, jsonStr));
        String classid='1008'; 
        String exportid='309';
        TF_ProcessUnsiloresponse.callUnsilo(classid,exportid,'Chapter'); 
        TF_ProcessUnsiloresponse.callUnsilo(classid,exportid,'ScholarlyArticle'); 
        Test.stopTest();
        
    }
    
    private static testmethod void testUnsiloCalloutRetry_Success() {
        
        String jsonStr = '{"export":{"title":"Goal 17 partnerships","exportDate":"2018-10-09_11-47","documents":[{"publisher":"Earthscan","doi":"10.4324/9781849771009-14","id":"9781136568060_10.4324/9781849771009-14","journal":"Dictionary and Introduction to Global Environmental Governance","publicationDate":"2018-02-07","title":"Dictionary","authors":[{"lastName":"Richard A Meganck"},{"lastName":"Richard E Saunier"}],"concepts":[{"label":"Global Crop Diversity Trust","score":14.247812},{"label":"Water Footprint","score":13.513458},{"label":"Water Poverty Index","score":12.933039},{"label":"Virtual Water","score":12.890074},{"label":"Developing Country","score":12.190496},{"label":"Integrated Water Resource Management","score":11.776872},{"label":"Kyoto Protocol","score":11.539722},{"label":"Heavily Indebted Poor Countries","score":11.378412},{"label":"World Water Day","score":11.0296335},{"label":"Mekong River Commission","score":10.879795},{"label":"Kimberley Process Certification Scheme","score":10.736309},{"label":"Organization Of American States Systems","score":10.682202},{"label":"Clean Development Mechanism","score":10.679563},{"label":"Sustainable Development","score":10.649567},{"label":"International Civil Service Commission","score":10.568916},{"label":"Climate Change","score":10.505889},{"label":"World Water Council","score":10.399822},{"label":"Boiled Frog Syndrome","score":10.398923},{"label":"Vienna Convention","score":10.381069},{"label":"Official Development Assistance","score":10.352699}],"rights":[]}],"concepts":[{"label":"Technology Transfer","state":"DEFAULT","type":"MANUAL"},{"label":"Capacity Building","state":"DEFAULT","type":"MANUAL"},{"label":"Civil Society","state":"DEFAULT","type":"MANUAL"},{"label":"Debt Relief","state":"DEFAULT","type":"MANUAL"},{"label":"North South Collaboration","state":"DEFAULT","type":"MANUAL"},{"label":"Sustainable Development","state":"DEFAULT","type":"MANUAL"}]},"path":"/tandf/classes/1008/exports/309","apiResponseStatus":"SUCCESS","status":"OK","currentTimestamp":"2018-10-09T11:47:31Z"}';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_ProcessUnsiloresponse(200, jsonStr));
        String classid='1008'; 
        String exportid='309';
        TF_ProcessUnsiloresponse.callUnsiloWithRetry(classid,exportid,'3','Chapter');
        TF_ProcessUnsiloresponse.callUnsiloWithRetry(classid,exportid,'3','ScholarlyArticle'); 
        Test.stopTest();
    }
    
    private static testmethod void testValidateContentList_Success() {
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        product2 thisProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        String productId = thisProduct.id;
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Title__c='World Heritage';
        lineItem.IsUnsilo__c=true;
        lineItem.Authors__c='Rosalie Callway'; 
        lineItem.doi__c='1234';
        lineItem.Content_Position__c= 1 ;
        lineItem.Product_Bundle_Parent__c=productId;
        insert lineItem;        
        Bundle_Line_Item__c lineItem2 = new Bundle_Line_Item__c();
        lineItem2.Title__c='World Heritage';
        lineItem2.IsUnsilo__c=true;
        lineItem2.Authors__c='Rosalie Callway'; 
        lineItem2.doi__c='5678';
        lineItem2.Content_Position__c= 2 ;
        lineItem2.Product_Bundle_Parent__c=productId;
        insert lineItem2;        
        String jsonStr = 'validate test';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_ProcessUnsiloresponse(200, jsonStr));
        
        TF_ProcessUnsiloresponse.validateContentList(productId,'0','0','0');
        Test.stopTest();
    }
    
   private static testmethod void testgetUUIDForContentList_Success() {
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        product2 thisProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        String productId = thisProduct.id;
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Title__c='World Heritage';
        lineItem.IsUnsilo__c=true;
        lineItem.Authors__c='Rosalie Callway'; 
        lineItem.doi__c='1234';
        lineItem.Content_Position__c= 1 ;
        lineItem.Product_Bundle_Parent__c=productId;
        insert lineItem;        
        Bundle_Line_Item__c lineItem2 = new Bundle_Line_Item__c();
        lineItem2.Title__c='World Heritage';
        lineItem2.IsUnsilo__c=true;
        lineItem2.Authors__c='Rosalie Callway'; 
        lineItem2.doi__c='5678';
        lineItem2.Content_Position__c= 2 ;
        lineItem2.Product_Bundle_Parent__c=productId;
        insert lineItem2;        
        String jsonStr = 'validate test';
        Map<String,String> lineItmIdUUIDMap = new Map<String,String>();
        lineItmIdUUIDMap.put('1234',lineItem.id);
        lineItmIdUUIDMap.put('5678',lineItem2.id);
        TF_GenerateJson.ValidationJson valJson ;
        List<Bundle_Line_Item__c> bLItms = new List<Bundle_Line_Item__c>();
        bLItms.add(lineItem);
        bLItms.add(lineItem2);
        DateTime now = Datetime.now();
        String s3JsonString ;
        
        valJson = TF_GenerateJson.GenerateValidationJson(productId, now, 0, 0, 0, bLItms);
        if(!String.isBlank(valJson.jsonString)){ 
            s3JsonString = valJson.jsonString;
        }
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_ProcessUnsiloresponse(200, jsonStr));
        
        TF_ProcessUnsiloresponse.getUUIDForContentList(productId,s3JsonString,lineItmIdUUIDMap);
        String jobId = Database.executeBatch(new TF_Batch_GetUUIDsForDOIs(productId), 50);
        Test.stopTest();
    }
    
    private static testmethod void testUpdateLineitems_Success() {
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        product2 thisProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        String productId = thisProduct.id;
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Title__c='World Heritage';
        lineItem.IsUnsilo__c=true;
        lineItem.Authors__c='Rosalie Callway'; 
        lineItem.doi__c='1234';
        lineItem.Product_Bundle_Parent__c=productId;
        insert lineItem;        
        Bundle_Line_Item__c lineItem2 = new Bundle_Line_Item__c();
        lineItem2.Title__c='World Heritage';
        lineItem2.IsUnsilo__c=true;
        lineItem2.Authors__c='Rosalie Callway'; 
        lineItem2.doi__c='5678';
        lineItem2.Product_Bundle_Parent__c=productId;
        insert lineItem2;        
        String jsonStr = 'validate test';
        Map<String,String> lineItmIdUUIDMap = new Map<String,String>();
        lineItmIdUUIDMap.put(lineItem.id,'1234');
        lineItmIdUUIDMap.put(lineItem2.id,'1234');
        
        Test.startTest();
        
        TF_ProcessUnsiloresponse.updateLineitems(lineItmIdUUIDMap);
        Test.stopTest();
    }
    
    private static testmethod void testUnsiloCalloutRetry_Failure() {
        
        String jsonStr = '{"export":{"title":"Goal 17 partnerships","exportDate":"2018-10-09_11-47","documents":[{"publisher":"Earthscan","doi":"10.4324/9781849771009-14","id":"9781136568060_10.4324/9781849771009-14","journal":"Dictionary and Introduction to Global Environmental Governance","publicationDate":"2018-02-07","title":"Dictionary","authors":[{"lastName":"Richard A Meganck"},{"lastName":"Richard E Saunier"}],"concepts":[{"label":"Global Crop Diversity Trust","score":14.247812},{"label":"Water Footprint","score":13.513458},{"label":"Water Poverty Index","score":12.933039},{"label":"Virtual Water","score":12.890074},{"label":"Developing Country","score":12.190496},{"label":"Integrated Water Resource Management","score":11.776872},{"label":"Kyoto Protocol","score":11.539722},{"label":"Heavily Indebted Poor Countries","score":11.378412},{"label":"World Water Day","score":11.0296335},{"label":"Mekong River Commission","score":10.879795},{"label":"Kimberley Process Certification Scheme","score":10.736309},{"label":"Organization Of American States Systems","score":10.682202},{"label":"Clean Development Mechanism","score":10.679563},{"label":"Sustainable Development","score":10.649567},{"label":"International Civil Service Commission","score":10.568916},{"label":"Climate Change","score":10.505889},{"label":"World Water Council","score":10.399822},{"label":"Boiled Frog Syndrome","score":10.398923},{"label":"Vienna Convention","score":10.381069},{"label":"Official Development Assistance","score":10.352699}],"rights":[]}],"concepts":[{"label":"Technology Transfer","state":"DEFAULT","type":"MANUAL"},{"label":"Capacity Building","state":"DEFAULT","type":"MANUAL"},{"label":"Civil Society","state":"DEFAULT","type":"MANUAL"},{"label":"Debt Relief","state":"DEFAULT","type":"MANUAL"},{"label":"North South Collaboration","state":"DEFAULT","type":"MANUAL"},{"label":"Sustainable Development","state":"DEFAULT","type":"MANUAL"}]},"path":"/tandf/classes/1008/exports/309","apiResponseStatus":"SUCCESS","status":"OK","currentTimestamp":"2018-10-09T11:47:31Z"}';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_ProcessUnsiloresponse(404, jsonStr));
        String classid='1008'; 
        String exportid='309';
        TF_ProcessUnsiloresponse.callUnsiloWithRetry(classid,exportid,'3','Chapter'); 
        Test.stopTest();
    }  
    
    private static testmethod void testUnsiloCallout_coll_Success() {
        
        String jsonStr = '{"collections" : [{"id" : 2,"title" : "EBR Topic Article Packages","description" : "EBR topics"}, {"id" : 93,"title" : "cs_PMC-Recherche","description" : "cs_PMC-Recherche collection"}]}';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_ProcessUnsiloresponse(200, jsonStr));
        String classid='1008'; 
        String exportid='309';
        TF_ProcessUnsiloresponse.getUnsiloCollections('Chapter');
		TF_ProcessUnsiloresponse.getUnsiloCollections('ScholarlyArticle'); 

        Test.stopTest();
    }
    
    private static testmethod void testUnsiloCallout_coll_Failure() {
        
        String jsonStr = '{"collections" : [{"id" : 2,"title" : "EBR Topic Article Packages","description" : "EBR topics"}, {"id" : 93,"title" : "cs_PMC-Recherche","description" : "cs_PMC-Recherche collection"}]}';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_ProcessUnsiloresponse(400, jsonStr));
        String classid='1008'; 
        String exportid='309';
        TF_ProcessUnsiloresponse.getUnsiloCollections('Chapter');
		TF_ProcessUnsiloresponse.getUnsiloCollections('Article');         
        Test.stopTest();
    }
    
    private static testmethod void testUnsiloCallout_classes_Success() {
        
        String jsonStr = '{"classes" : [ { "id" : 110, "title" : "Dry-Eye 2017"  },{ "id" : 1099, "title" : "Thrombotic Thrombocytopenic Purpura", "exports" : [ {"id" : 359,"exportTimestamp" : "2018-10-03T14:01:36Z" },{"id" : 356,"exportTimestamp" : "2018-10-01T14:30:53Z"}]}]}';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_ProcessUnsiloresponse(200, jsonStr));
        String classid='1008'; 
        String exportid='309';
        TF_ProcessUnsiloresponse.getUnsiloClasses('123','Chapter'); 
        TF_ProcessUnsiloresponse.getUnsiloClasses('123','ScholarlyArticle'); 
        Test.stopTest();
    }
    
    private static testmethod void testUnsiloCallout_classes_Failure() {
        
        String jsonStr = '{"classes" : [ { "id" : 110, "title" : "Dry-Eye 2017"  },{ "id" : 1099, "title" : "Thrombotic Thrombocytopenic Purpura", "exports" : [ {"id" : 359,"exportTimestamp" : "2018-10-03T14:01:36Z" },{"id" : 356,"exportTimestamp" : "2018-10-01T14:30:53Z"}]}]}';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_ProcessUnsiloresponse(400, jsonStr));
        String classid='1008'; 
        String exportid='309';
        TF_ProcessUnsiloresponse.getUnsiloClasses('123','Chapter'); 
        TF_ProcessUnsiloresponse.getUnsiloClasses('123','Article'); 

        Test.stopTest();
    }
    
    private static testmethod void testUnsiloCallout_exportId_Success() {
        
        String jsonStr = '{"export" : {"id" : 390,"exportTimestamp" : "2018-10-31T15:27:50Z"}}';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_ProcessUnsiloresponse(200, jsonStr));
        String classid='1008'; 
        String exportid='309';
        TF_ProcessUnsiloresponse.getUnsiloExportId('123','Chapter'); 
        TF_ProcessUnsiloresponse.getUnsiloExportId('123','ScholarlyArticle'); 

        Test.stopTest();
    }
    
    private static testmethod void testUnsiloCallout_exportId_Failure() {
        
        String jsonStr = '{"export" : {"id" : 390,"exportTimestamp" : "2018-10-31T15:27:50Z"}}';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_ProcessUnsiloresponse(400, jsonStr));
        String classid='1008'; 
        String exportid='309';
        TF_ProcessUnsiloresponse.getUnsiloExportId('123','Chapter');
        TF_ProcessUnsiloresponse.getUnsiloExportId('123','Article'); 
        
        Test.stopTest();
    }
    
    @isTest  
    public static void test_putProductJsonToS3_success(){
        
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        String strJason='{  "@id" : "b7d9c0ca-8337-4afc-80e5-d36f7f9881e5",  "@type" : "Collections",  "@additionalType" : "UNSDG",  "name" : "test hub id",  "alternateName" : "",  "inLanguage" : "en",  "version" : "1.0.0",  "doi" : "",  "ean" : "",  "issn" : "",  "sku" : "01t1l000000pJ4qAAE",  "productID" : "01t1l000000pJ4qAAE",  "description" : "sadf",  "publisher" : "sdfsadf",  "dateCreated" : "2018-11-20T14:00:48.000Z",  "dateModified" : "2018-12-14T11:50:22.000Z",  "copyrightYear" : "2018",  "copyrightHolder" : {    "name" : ""  },  "identifier" : [ {    "code" : ""  } ],  "category" : [ ],  "keywords" : [ ],  "contributor" : [ ],  "offers" : [ ],  "hasPart" : [ {    "@id" : "10.4324/9781315619189-11961",    "@type" : "chapter",    "position" : 1  }]  }';
        product2 thisProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        String productId = thisProduct.id;
        String resBody = '<PublishResponse xmlns="http://sns.amazonaws.com/doc/2010-03-31/">\n'+
            '<PublishResult>\n'+
            '<MessageId>960cd44f-e44d-5271-b195-807944061fd2</MessageId>\n'+
            '</PublishResult>\n'+
            '<ResponseMetadata>\n'+
            '<RequestId>ccb9190b-dc72-5316-ace9-4d3d7c39beb5</RequestId>\n'+
            '</ResponseMetadata>\n'+
            '</PublishResponse>'; 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_AWSService(200, resBody));
        TF_ProcessUnsiloresponse.putCollectionJsonToS3AndNotify(productId,strJason);       
        Test.stopTest();
    }  
    
    @isTest  
    public static void test_putProductJsonToS3_failure(){
        
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        String strJason='{  "@id" : "b7d9c0ca-8337-4afc-80e5-d36f7f9881e5",  "@type" : "Collections",  "@additionalType" : "UNSDG",  "name" : "test hub id",  "alternateName" : "",  "inLanguage" : "en",  "version" : "1.0.0",  "doi" : "",  "ean" : "",  "issn" : "",  "sku" : "01t1l000000pJ4qAAE",  "productID" : "01t1l000000pJ4qAAE",  "description" : "sadf",  "publisher" : "sdfsadf",  "dateCreated" : "2018-11-20T14:00:48.000Z",  "dateModified" : "2018-12-14T11:50:22.000Z",  "copyrightYear" : "2018",  "copyrightHolder" : {    "name" : ""  },  "identifier" : [ {    "code" : ""  } ],  "category" : [ ],  "keywords" : [ ],  "contributor" : [ ],  "offers" : [ ],  "hasPart" : [ {    "@id" : "10.4324/9781315619189-11961",    "@type" : "chapter",    "position" : 1  }]  }';
        product2 thisProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        String productId = thisProduct.id;
        String resBody = '<PublishResponse xmlns="http://sns.amazonaws.com/doc/2010-03-31/">\n'+
            '<PublishResult>\n'+
            '<MessageId>960cd44f-e44d-5271-b195-807944061fd2</MessageId>\n'+
            '</PublishResult>\n'+
            '<ResponseMetadata>\n'+
            '<RequestId>ccb9190b-dc72-5316-ace9-4d3d7c39beb5</RequestId>\n'+
            '</ResponseMetadata>\n'+
            '</PublishResponse>'; 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_AWSService(400, null));
        TF_ProcessUnsiloresponse.putCollectionJsonToS3AndNotify(productId,strJason);       
        Test.stopTest();
    }
    
    @isTest
    private static void testupdateContributors(){
        String strJason= '[{"name":"test test","givenName":"test","familyName":"test","role":"Editor","position":1}]';
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
       // Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId); 
		Product2 newParentProduct=insertProductforTesting(productRecordtypeId);        
        String msg = TF_ProcessUnsiloresponse.updateContributors(newParentProduct.id, strJason);
        System.assert(msg == 'success');
        test.stopTest();
    }
    
    @isTest
    private static void testgetContributors(){
        String strJason= '[{"name":"test test","givenName":"test","familyName":"test","role":"Editor","position":1}]';
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        newParentProduct.Contributors__c = strJason;
        update newParentProduct;
        String returnedJsonStr =  TF_ProcessUnsiloresponse.getContributors(newParentProduct.id);
        System.assert(returnedJsonStr == strJason);
        test.stopTest();
    }
    
    @isTest
    private static void testupdateKeywords(){
        String strJason= '[{"name":"harish","description":"HARISH","position":1}]';
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId); 
		Product2 newParentProduct=insertProductforTesting(productRecordtypeId);        
        String msg = TF_ProcessUnsiloresponse.updateKeywords(newParentProduct.id, strJason);
        System.assert(msg == 'success');
        test.stopTest();
    }
    
    @isTest
    private static void testgetKeywords(){
        String strJason= '[{"name":"harish","description":"HARISH","position":1}]';
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        newParentProduct.Keywords__c = strJason;
        update newParentProduct;
        String returnedJsonStr =  TF_ProcessUnsiloresponse.getKeywords(newParentProduct.id);
        System.assert(returnedJsonStr == strJason);
        test.stopTest();
    }
    
    @isTest
    private static void testAddContentsViaFileUpload(){
        String contentData= 'Type	DOI	Book Name / Journal Name	Chapter Name / Article Name	Authors'+'\n'+'Chapter	Test 1	Test 23	Test 46	Test 71';
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        Blob contentsListJSONBlob = Blob.valueOf(contentData);
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData = contentsListJSONBlob;
        cv.Title = newParentProduct.id;
        cv.PathOnClient = newParentProduct.id;
        cv.Description = newParentProduct.id;
        cv.ReasonForChange = newParentProduct.id;
        
        insert cv;
        
        String contentDocId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = contentDocId ;
        cdl.LinkedEntityId = newParentProduct.id;
        cdl.ShareType = 'V';
        insert cdl;
        TF_ProcessUnsiloresponse.addContentsViaFileUpload(newParentProduct.id, contentDocId);
        test.stopTest();
    }
    
    @isTest
    private static void testAddContentsViaFileUpload_Nodata(){
        String contentData= 'Type	DOI	Book Name / Journal Name	Chapter Name / Article Name	Authors';
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        Blob contentsListJSONBlob = Blob.valueOf(contentData);
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData = contentsListJSONBlob;
        cv.Title = newParentProduct.id;
        cv.PathOnClient = newParentProduct.id;
        cv.Description = newParentProduct.id;
        cv.ReasonForChange = newParentProduct.id;
        
        insert cv;
        
        String contentDocId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = contentDocId ;
        cdl.LinkedEntityId = newParentProduct.id;
        cdl.ShareType = 'V';
        insert cdl;
        TF_ProcessUnsiloresponse.addContentsViaFileUpload(newParentProduct.id, contentDocId);
        test.stopTest();
    }
    
    @isTest
    private static void testAddContentsViaFileUpload_HeaderIssue(){
        String contentData= 'Typo	DOI	Book Name / Journal Name	Chapter Name / Article Name	Authors'+'\n'+'testType	Test 1	Test 23	Test 46	Test 71';
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
       // Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        Blob contentsListJSONBlob = Blob.valueOf(contentData);
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData = contentsListJSONBlob;
        cv.Title = newParentProduct.id;
        cv.PathOnClient = newParentProduct.id;
        cv.Description = newParentProduct.id;
        cv.ReasonForChange = newParentProduct.id;
        
        insert cv;
        
        String contentDocId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = contentDocId ;
        cdl.LinkedEntityId = newParentProduct.id;
        cdl.ShareType = 'V';
        insert cdl;
        TF_ProcessUnsiloresponse.addContentsViaFileUpload(newParentProduct.id, contentDocId);
        test.stopTest();
    }
    
    @isTest
    private static void testAddContentsViaFileUpload_FormatIssue(){
        String contentData= 'Type	DOI	Book Name / Journal Name	Chapter Name / Article Name	Authors'+'\n'+'testType	Test 1	Test 23	Test 46	Test 71	test';
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        Blob contentsListJSONBlob = Blob.valueOf(contentData);
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData = contentsListJSONBlob;
        cv.Title = newParentProduct.id;
        cv.PathOnClient = newParentProduct.id;
        cv.Description = newParentProduct.id;
        cv.ReasonForChange = newParentProduct.id;
        
        insert cv;
        
        String contentDocId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = contentDocId ;
        cdl.LinkedEntityId = newParentProduct.id;
        cdl.ShareType = 'V';
        insert cdl;
        TF_ProcessUnsiloresponse.addContentsViaFileUpload(newParentProduct.id, contentDocId);
        test.stopTest();
    }
    
    @isTest
    private static void testAddContentsViaFileUpload_insertIssue(){
        String contentData= 'Type	DOI	Book Name / Journal Name	Chapter Name / Article Name	Authors'+'\n'+'testType	Test 1234323343234323532344433242422332sdfdsfdsfsdfsdfsdsdf	Test 23	Test 46	Test 71';
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
       // Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        Blob contentsListJSONBlob = Blob.valueOf(contentData);
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData = contentsListJSONBlob;
        cv.Title = newParentProduct.id;
        cv.PathOnClient = newParentProduct.id;
        cv.Description = newParentProduct.id;
        cv.ReasonForChange = newParentProduct.id;
        
        insert cv;
        
        String contentDocId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = contentDocId ;
        cdl.LinkedEntityId = newParentProduct.id;
        cdl.ShareType = 'V';
        insert cdl;
        TF_ProcessUnsiloresponse.addContentsViaFileUpload(newParentProduct.id, contentDocId);
        test.stopTest();
    }
    
    
    
    @isTest
    private static void testAddContentsViaFileUpload_emptyFile(){
        String contentData= ' ';
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        Blob contentsListJSONBlob = Blob.valueOf(contentData);
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData = contentsListJSONBlob;
        cv.Title = newParentProduct.id;
        cv.PathOnClient = newParentProduct.id;
        cv.Description = newParentProduct.id;
        cv.ReasonForChange = newParentProduct.id;
        
        insert cv;
        
        String contentDocId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = contentDocId ;
        cdl.LinkedEntityId = newParentProduct.id;
        cdl.ShareType = 'V';
        insert cdl;
        TF_ProcessUnsiloresponse.addContentsViaFileUpload(newParentProduct.id, contentDocId);
        test.stopTest();
    }
    
    @isTest
    private static void testAddContentsViaFileUpload_NoFile(){
        
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        TF_ProcessUnsiloresponse.addContentsViaFileUpload(newParentProduct.id, null);
        test.stopTest();
    }
    
    @isTest
    private static void testAddContentsViaFileUpload_1KPlus(){
        String contentData= 'Type	DOI	Book Name / Journal Name	Chapter Name / Article Name	Authors'+'\n'+'testType	Test 1	Test 23	Test 46	Test 71';
        
        for(integer i = 0; i<1100 ; i++){
            contentData = contentData + '\n'+'testType'+i+'	Test 1	Test 23	Test 46	Test 71';
        }
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        Blob contentsListJSONBlob = Blob.valueOf(contentData);
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData = contentsListJSONBlob;
        cv.Title = newParentProduct.id;
        cv.PathOnClient = newParentProduct.id;
        cv.Description = newParentProduct.id;
        cv.ReasonForChange = newParentProduct.id;
        
        insert cv;
        
        String contentDocId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = contentDocId ;
        cdl.LinkedEntityId = newParentProduct.id;
        cdl.ShareType = 'V';
        insert cdl;
        TF_ProcessUnsiloresponse.addContentsViaFileUpload(newParentProduct.id, contentDocId);
        test.stopTest();
    }
    
    @isTest
    private static void testAddContentsViaFileUpload_10KPlus(){
        String contentData= 'Type	DOI	Book Name / Journal Name	Chapter Name / Article Name	Authors'+'\n'+'testType	Test 1	Test 23	Test 46	Test 71';
        
        for(integer i = 0; i<11000 ; i++){
            contentData = contentData + '\n'+'testType'+i+'	Test 1	Test 23	Test 46	Test 71';
        }
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        Blob contentsListJSONBlob = Blob.valueOf(contentData);
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData = contentsListJSONBlob;
        cv.Title = newParentProduct.id;
        cv.PathOnClient = newParentProduct.id;
        cv.Description = newParentProduct.id;
        cv.ReasonForChange = newParentProduct.id;
        
        insert cv;
        
        String contentDocId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = contentDocId ;
        cdl.LinkedEntityId = newParentProduct.id;
        cdl.ShareType = 'V';
        insert cdl;
        TF_ProcessUnsiloresponse.addContentsViaFileUpload(newParentProduct.id, contentDocId);
        test.stopTest();
    }
    
    @isTest
    private static void testCallContentCurator(){
        test.startTest();
        string jsonStr = 'validate test';
        Test.setMock(HttpCalloutMock.class, new zTest_TF_ProcessUnsiloresponse(200, jsonStr));
        TF_ProcessUnsiloresponse.PagedResultDetails prDetail = new TF_ProcessUnsiloresponse.PagedResultDetails();
        prDetail=TF_ProcessUnsiloresponse.callContentCurator();
        System.assert(prDetail != null);
        test.stopTest();
    }
    
    private static testmethod void testdeleteSelectedDocs(){
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');       
        //Product2 newParentProduct = zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        //inserting bundle line item for unsilo
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Title__c='World Heritage';
        lineItem.IsUnsilo__c=true;
        lineItem.Authors__c='Rosalie Callway';     
        lineItem.Product_Bundle_Parent__c=newParentProduct.id;
        insert lineItem;        
        TF_ProcessUnsiloresponse.deleteSelectedDocs(newParentProduct.id,'["'+ lineItem.id +'"]'); 
        test.stopTest();          
    }
    
    private static testmethod void testdeleteUploadedFiles(){
        test.startTest();
        String contentsListJSON='{TestFile}';
        String ContentDocId;
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');       
        //Product2 newParentProduct = zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        Blob contentsListJSONBlob = Blob.valueOf(contentsListJSON);
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData = contentsListJSONBlob;
        cv.Title = newParentProduct.Id;
        cv.PathOnClient = newParentProduct.Id;
        cv.Description = 'Desc'; 
        cv.ReasonForChange = 'Desc';
        
        insert cv;
        
        contentDocId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = contentDocId ;
        cdl.LinkedEntityId = newParentProduct.Id;
        cdl.ShareType = 'V';
        insert cdl;
        TF_ProcessUnsiloresponse.deleteUploadedFiles(newParentProduct.Id);
        test.stopTest();          
    }
    private static testMethod void getBundleItmsCount() {
         test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');      
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Product_Bundle_Parent__c = newParentProduct.id;
        insert lineItem; 
        Integer count= TF_ProcessUnsiloresponse.getBundleItmsCount(newParentProduct.id);   
        test.stopTest(); 
     
 }
    
     private static testMethod void testdeleteBundleLineItemsOnProductDelete() {
          test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');      
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
         Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Product_Bundle_Parent__c = newParentProduct.id;
        insert lineItem; 
         
         
        Bundle_Line_Item__c lineItems = new Bundle_Line_Item__c();
        lineItems.Product_Bundle_Parent__c = newParentProduct.id;
        insert lineItems; 
         
         TF_ProcessUnsiloresponse.deleteBundleLineItemsOnProductDelete(newParentProduct.id);
         test.stopTest(); 
     }
    
    private static testmethod void testmoveSelectedDocs(){
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');       
        //Product2 newParentProduct = zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        //inserting bundle line item for unsilo
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Title__c='World Heritage';
        lineItem.IsUnsilo__c=true;
        lineItem.Authors__c='Rosalie Callway'; 
        lineItem.Content_Position__c=1;
        lineItem.Product_Bundle_Parent__c=newParentProduct.id;
        insert lineItem;        
        TF_ProcessUnsiloresponse.moveSelectedDocs(newParentProduct.id,'["'+ lineItem.id +'"]'); 
        test.stopTest();          
    }
    
     @isTest
    private static void testgetPartsFromPCM(){

        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');       
        //Product2 newParentProduct = zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        newParentProduct.IsActive=true;
        update newParentProduct;
        test.startTest();
        string jsonStr = 'validate test';
        Test.setMock(HttpCalloutMock.class, new zTest_TF_ProcessUnsiloresponse(200, jsonStr));
        TF_ProcessUnsiloresponse.PagedResultDetails prDetail = new TF_ProcessUnsiloresponse.PagedResultDetails();
        prDetail=TF_ProcessUnsiloresponse.getPartsFromPCM(newParentProduct.id,'0');
        System.assert(prDetail != null);
        test.stopTest();
    }
    
    
      @isTest
    private static void testgetPartsFromPCMNewDataModel(){
        test.startTest();
        string jsonStr = 'validate test';
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');       
        //Product2 newParentProduct = zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        newParentProduct.IsActive=true;
        update newParentProduct;
        Test.setMock(HttpCalloutMock.class, new zTest_TF_ProcessUnsiloresponse(200, jsonStr));
        TF_ProcessUnsiloresponse.PagedResultDetails prDetail = new TF_ProcessUnsiloresponse.PagedResultDetails();
        prDetail=TF_ProcessUnsiloresponse.getPartsFromPCMNewDataModel(newParentProduct.id,'0','book');
        System.assert(prDetail != null);
        test.stopTest();
    }
    @isTest
    private static void testgetProductFromPCMById(){
        test.startTest();
        string jsonStr = 'validate test';
        Test.setMock(HttpCalloutMock.class, new zTest_TF_ProcessUnsiloresponse(200, jsonStr));
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');       
        //Product2 newParentProduct = zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        newParentProduct.IsActive=true;
        update newParentProduct;
        TF_ProcessUnsiloresponse.PagedResultDetails prDetail = new TF_ProcessUnsiloresponse.PagedResultDetails();
        prDetail=TF_ProcessUnsiloresponse.getProductFromPCMById(newParentProduct.id,'book');
        System.assert(prDetail != null);
        test.stopTest();
    }
    
    @isTest
    private static void testgetProductsFromPCMById(){
        test.startTest();
        string jsonStr = 'validate test';
        Test.setMock(HttpCalloutMock.class, new zTest_TF_ProcessUnsiloresponse(200, jsonStr));
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');       
        //Product2 newParentProduct = zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        newParentProduct.IsActive=true;
        update newParentProduct;
        TF_ProcessUnsiloresponse.PagedResultDetails prDetail = new TF_ProcessUnsiloresponse.PagedResultDetails();
        prDetail=TF_ProcessUnsiloresponse.getProductsFromPCMById(newParentProduct.id,'book');
        System.assert(prDetail != null);
        test.stopTest();
    }
    
    private static testmethod void getPriceBookEntry_return()
    {
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);  
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        
        
        
        List<Pricebookentry> result =TF_ProcessUnsiloresponse.getPriceBookEntry(newParentProduct.id); 
        System.assert(result!= null);
        test.stopTest();
        
    }
    private static testMethod void getClonedProduct(){
        test.startTest();
        list< Bundle_Line_Item__c> listofLineItems=new List<Bundle_Line_Item__c>();
        TF_ProcessUnsiloresponse ppdCtrl = new TF_ProcessUnsiloresponse();
        TF_ProcessUnsiloresponse.ProductCloneResult result = new TF_ProcessUnsiloresponse.ProductCloneResult();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        
        TF_PPDProcessController.uploadFile(newParentProduct.id,'test.jpg','dsddssddeerrww','JPG');
        system.debug('======newParentProduct====id :'+newParentProduct.id);
        Decimal unitpriceinGBP=33.00;
        Decimal unitpriceinUSD=44.00;        
        TF_ProcessUnsiloresponse.addPriceBookEntry(newParentProduct.id, unitpriceinGBP,unitpriceinUSD,1.0,1.0);  
        
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Product_Bundle_Parent__c = newParentProduct.id;
        lineItem.Content_Position__c = 1;
        insert lineItem; 
        Bundle_Line_Item__c lineItems = new Bundle_Line_Item__c();
        lineItems.Product_Bundle_Parent__c = newParentProduct.id;
        lineItems.Content_Position__c = 2;
        insert lineItems; 
        
        result = TF_ProcessUnsiloresponse.getClonedProduct(newParentProduct.id);
       // TF_ProcessUnsiloresponse.cloneBundleItems(newParentProduct.id, result.productId, '0', '0', string.valueOf(result.totalRecords));
        
        System.assert(result.totalRecords > 0);      
        
        test.stopTest();
        
    }
    private static testMethod void testsendMailForClonedRequest(){
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        TF_ProcessUnsiloresponse.sendMailForClonedRequest(newParentProduct.Id);
        //TF_ProcessUnsiloresponse.collectionStatus(string.valueOf(newParentProduct));
        test.stopTest();
    }
    
    private static testMethod void  testcopyBundleLineItemsFromPartsAPI(){
        //test.startTest();
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        //newParentProduct.Product_Type_Author_Facing__c='Manual Curation';
        //update newParentProduct;
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Product_Bundle_Parent__c = newParentProduct.id;
        lineItem.Content_Position__c = 1;
        insert lineItem; 
        Bundle_Line_Item__c lineItems = new Bundle_Line_Item__c();
        lineItems.Product_Bundle_Parent__c = newParentProduct.id;
        lineItems.Content_Position__c = 2;
        insert lineItems;
        
       // Product2 newClonedProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newClonedProduct=insertProductforTesting(productRecordtypeId);
         Bundle_Line_Item__c CllineItem = new Bundle_Line_Item__c();
        CllineItem.Product_Bundle_Parent__c = newClonedProduct.id;
        CllineItem.Content_Position__c = 1;
        insert CllineItem; 
        Bundle_Line_Item__c cllineItems = new Bundle_Line_Item__c();
        cllineItems.Product_Bundle_Parent__c = newClonedProduct.id;
        cllineItems.Content_Position__c = 2;
        insert cllineItems; 
        test.startTest();
        string jsonStr = 'validate test';
        Test.setMock(HttpCalloutMock.class, new zTest_TF_ProcessUnsiloresponse(200, jsonStr));
        TF_ProcessUnsiloresponse.copyBundleLineItemsFromPartsAPI(newParentProduct.Id,newClonedProduct.Id);
        test.stopTest();
        
        
    }
    
     private static testMethod void testcallParts(){
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Product_Bundle_Parent__c = newParentProduct.id;
        lineItem.Content_Position__c = 1;
        insert lineItem; 
        Bundle_Line_Item__c lineItems = new Bundle_Line_Item__c();
        lineItems.Product_Bundle_Parent__c = newParentProduct.id;
        lineItems.Content_Position__c = 2;
        insert lineItems;
        
       // Product2 newClonedProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newClonedProduct=insertProductforTesting(productRecordtypeId);
         Bundle_Line_Item__c CllineItem = new Bundle_Line_Item__c();
        CllineItem.Product_Bundle_Parent__c = newClonedProduct.id;
        CllineItem.Content_Position__c = 1;
        insert CllineItem; 
        Bundle_Line_Item__c cllineItems = new Bundle_Line_Item__c();
        cllineItems.Product_Bundle_Parent__c = newClonedProduct.id;
        cllineItems.Content_Position__c = 2;
        insert cllineItems; 
          string jsonStr = 'validate test';
        Test.setMock(HttpCalloutMock.class, new zTest_TF_ProcessUnsiloresponse(200, jsonStr));
        TF_ProcessUnsiloresponse.callParts(newParentProduct.Id,newClonedProduct.Id,4,false,0,4);
        
        test.stopTest();
    }
    
    private static testMethod void testgetTotalAverageCount(){
         test.startTest();
        Integer count=0;
         count=TF_ProcessUnsiloresponse.getTotalAverageCount(500,10);
        System.assert(count != 0);     
        test.stopTest();
    }
    
     
    private static testMethod void testdivideNumberIntoNParts(){
         test.startTest();
        list<Integer> count;
         count=TF_ProcessUnsiloresponse.divideNumberIntoNParts(6000,5000);
        System.assert(count !=null);     
        test.stopTest();
    } 
    
     private static testmethod void testsearchBundleLineItems() {
        
        String jsonStr = '{"export":{"title":"Goal 17 partnerships","exportDate":"2018-10-09_11-47","documents":[{"publisher":"Earthscan","doi":"10.4324/9781849771009-14","id":"9781136568060_10.4324/9781849771009-14","journal":"Dictionary and Introduction to Global Environmental Governance","publicationDate":"2018-02-07","title":"Dictionary","authors":[{"lastName":"Richard A Meganck"},{"lastName":"Richard E Saunier"}],"concepts":[{"label":"Global Crop Diversity Trust","score":14.247812},{"label":"Water Footprint","score":13.513458},{"label":"Water Poverty Index","score":12.933039},{"label":"Virtual Water","score":12.890074},{"label":"Developing Country","score":12.190496},{"label":"Integrated Water Resource Management","score":11.776872},{"label":"Kyoto Protocol","score":11.539722},{"label":"Heavily Indebted Poor Countries","score":11.378412},{"label":"World Water Day","score":11.0296335},{"label":"Mekong River Commission","score":10.879795},{"label":"Kimberley Process Certification Scheme","score":10.736309},{"label":"Organization Of American States Systems","score":10.682202},{"label":"Clean Development Mechanism","score":10.679563},{"label":"Sustainable Development","score":10.649567},{"label":"International Civil Service Commission","score":10.568916},{"label":"Climate Change","score":10.505889},{"label":"World Water Council","score":10.399822},{"label":"Boiled Frog Syndrome","score":10.398923},{"label":"Vienna Convention","score":10.381069},{"label":"Official Development Assistance","score":10.352699}],"rights":[]}],"concepts":[{"label":"Technology Transfer","state":"DEFAULT","type":"MANUAL"},{"label":"Capacity Building","state":"DEFAULT","type":"MANUAL"},{"label":"Civil Society","state":"DEFAULT","type":"MANUAL"},{"label":"Debt Relief","state":"DEFAULT","type":"MANUAL"},{"label":"North South Collaboration","state":"DEFAULT","type":"MANUAL"},{"label":"Sustainable Development","state":"DEFAULT","type":"MANUAL"}]},"path":"/tandf/classes/1008/exports/309","apiResponseStatus":"SUCCESS","status":"OK","currentTimestamp":"2018-10-09T11:47:31Z"}';
        Test.startTest();
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        newParentProduct.IsActive=true;
        update newParentProduct;
       
        Test.setMock(HttpCalloutMock.class, new zTest_TF_ProcessUnsiloresponse(200, jsonStr));
        Test.setMock(HttpCalloutMock.class, new zTest_TF_ProcessUnsiloresponse(404, jsonStr));
        Test.setMock(HttpCalloutMock.class, new zTest_TF_ProcessUnsiloresponse(500, jsonStr));
        TF_ProcessUnsiloresponse.PagedResultDetails prDetail = new TF_ProcessUnsiloresponse.PagedResultDetails();
        prDetail=TF_ProcessUnsiloresponse.searchBundleLineItems(newParentProduct.id,'queryTerm','10');
        System.assert(prDetail != null);
        test.stopTest();
    }
   
   
	@isTest
    private static void testCollectionStatus(){
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');       
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        string jsonStr = 'validate test';
        Test.setMock(HttpCalloutMock.class, new zTest_TF_ProcessUnsiloresponse(200, jsonStr));
        TF_ProcessUnsiloresponse.collectionStatus(newParentProduct.Id);
        Product2 newParentProduct1=insertProductforTesting(productRecordtypeId);
        newParentProduct1.Is_collection_free__c=true;
        update newParentProduct1;
        Test.setMock(HttpCalloutMock.class, new zTest_TF_ProcessUnsiloresponse(200, jsonStr));
        test.stopTest();
    }
    
    
}