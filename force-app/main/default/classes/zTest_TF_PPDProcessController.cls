@isTest
global with sharing class zTest_TF_PPDProcessController implements HttpCalloutMock

{     
    private integer statusCode; 
    private String responseJson; 
    
    public zTest_TF_PPDProcessController(integer statusCode, String responseJson){
        this.statusCode = statusCode;  
        this.responseJson = responseJson;
    }
    
    
    public static testmethod void testPagedResult(){  
        test.startTest();          
        TF_PPDProcessController.PagedResult pgResult = new  TF_PPDProcessController.PagedResult();
        pgResult.ISBN= '9781315367897 '; 
        pgResult.title='IoT Automation: Arrowhead Framework';
        pgResult.Name ='IoT Automation: Arrowhead Framework';
        pgResult.author='Jerker Delsing';  
        //pgResult.pubDate='2017-02-17';
        pgResult.planPubDate='2017-02-24'; 
        //pgResult.currAvailability='Available ';
        pgResult.id ='01t0Y0000072IQWQA2';
        pgResult.edition=1; 
        //pgResult.listPrice=10;
        //pgResult.currencyTypeData ='USD';
        pgResult.format='e-book';
        pgResult.type='book';
        pgResult.priceBYOGBP=33;
        pgResult.priceBYOUSD=22;
        pgResult.priceISGBP=44;
        pgResult.priceISUSD=90;
        pgResult.priceLPGBP=87;
        pgResult.priceLPUSD=66;
        pgResult.firstPublishedYear='2013';
        pgResult.copyRightYear='2011';
        pgResult.textType='test';
        pgResult.dacKey='gh44';
        pgResult.sku='uio';
        pgResult.editor='test';
        pgResult.openAccess='true';
        pgResult.drm='yes';
        pgResult.publisherArea='T&F';
        pgResult.status='Available';
        pgResult.categoryType='test';
        pgResult.classificationGroup='testclasgroup';
        pgResult.productCategory='creative';
        pgResult.SubType='chap';
        test.stopTest(); 
    }
     public static testmethod void testQueryObject(){  
        test.startTest(); 
        TF_PPDProcessController.QueryObject pgResult = new  TF_PPDProcessController.QueryObject();  
        pgResult.logicalOppStartPosLeft=1;
        pgResult.logicalOppEndPosLeft=2;
        pgResult.logicalOppStartPosRight=3;
        pgResult.logicalOppEndPosRight=4;
        
        test.stopTest(); 
     }
     public static testmethod void testprocessedQuery(){  
        test.startTest(); 
        TF_PPDProcessController.processedQuery pgResult = new  TF_PPDProcessController.processedQuery();  
        pgResult.jsonString='testjson';
        pgResult.queryString='teststring';
        pgResult.productTypeReturned='book';
        pgResult.nextPageCursor='nextcur';
        pgResult.prevPageCursor='precur';
        pgResult.lastPageCursor='lastcur';
        
        test.stopTest(); 
     }
    
    
     public static testmethod void testImageUploadNames(){  
        test.startTest();          
        TF_PPDProcessController.ImageUploadNames imgUpload = new  TF_PPDProcessController.ImageUploadNames();
        imgUpload.banner= 'test_bannerimage '; 
        imgUpload.cover='test_coverimage';
        }
    
    public static testmethod void testImplicitFilter(){  
        test.startTest();          
        TF_PPDProcessController.ImplicitFilter impl = new  TF_PPDProcessController.ImplicitFilter();
        impl.prdType =   'test';
        impl.dotNotation ='test';
        impl.qryLabel   ='test';
        impl.operatior ='AND';
        impl.value ='test';
        impl.useImpVal =true;
         }
    
    
    private static Product2 insertProductforTesting(String product2RecordtypeId){
         Product2 p = new Product2(name='test', ProductCode='12345', IsActive=true, Description='test', RecordTypeId=product2RecordtypeId,
            ISBN__c = '12345678901234', Competitor_Publisher__c='test', Subject_Code__c='test',BusinessId__c='SDGO-PRODATA',Product_category__c='SDGO',Sales_Channels__c='UBX_Sales', Product_Type_Author_Facing__c='Manual Curation',IsBusinessIdValidated__c=true);
          insert p;
        return p;
    }
    
    private static Product2 insertDynamicProductforTesting(String product2RecordtypeId){
         Product2 p = new Product2(name='test', ProductCode='12345', IsActive=true, Description='test', RecordTypeId=product2RecordtypeId,
            ISBN__c = '12345678901234', Competitor_Publisher__c='test', Subject_Code__c='test',BusinessId__c='SDGO-DYN',Product_category__c='SDGO',Sales_Channels__c='UBX_Sales', Product_Type_Author_Facing__c='Rule based',IsBusinessIdValidated__c=true,originalProductId__c='01t9E000006vGgUQAU',APIStatus__c='Submit To PCM Success',Dynamic_Collection_Criteria__c='{"filterObject":{"ISBN":"","title":"","author":"","doi":"","netbase":["WB010 - ENVIROnetBASE"],"subjectList":[],"mediumData":"e-Book","publishData":"","minPrice":"","maxPrice":"","sortBy":"desc","sortOrderFieldName":"UnitPrice","drmData":"Both","currencyTypeData":"USD","firstPubYearDataFrom":"","firstPubYearDataTo":"","textType":"","publisherImprint":"","publcFromDate":null,"publcToDate":null},"ruleElementLst":[{"type":"separator","value":"BEGIN"},{"attribute":"classifications[type:netbase].entries.code","relationship":"IN","type":"criteria","value":"WB010"},{"type":"logical","value":"AND"},{"attribute":"format","relationship":"EQ","type":"criteria","value":"e-Book"},{"type":"separator","value":"END"}],"queryString":"netbase IN WB010 AND format EQ e-Book "}');
          insert p;
        return p;
    }
    
    private static testmethod void testPagedResultDetails(){
        test.startTest();        
        TF_PPDProcessController.PagedResultDetails pgResultDetail = new  TF_PPDProcessController.PagedResultDetails();
        pgResultDetail.total=50; 
        pgResultDetail.msg='success';
        test.stopTest();         
    }
    private static testmethod void testResultCoulmn(){
        test.startTest();        
        TF_PPDProcessController.ResultCoulmn ResultCol = new  TF_PPDProcessController.ResultCoulmn();
        ResultCol.label='test'; 
        ResultCol.fieldName='success';
        ResultCol.type='book';
        test.stopTest();         
    }
    
    private static testmethod void testResulttypeAttributes(){ 
        TF_PPDProcessController.ResulttypeAttributes ResultType = new  TF_PPDProcessController.ResulttypeAttributes();
        ResultType.currencyCode='USD';
        
    }
    
    private static testmethod void testResultcellAttributes(){ 
        TF_PPDProcessController.ResultcellAttributes ResultCell = new  TF_PPDProcessController.ResultcellAttributes();
        ResultCell.alignment='center';        
    }
    
    private static testmethod void testResultCoulmnsForType(){ 
        TF_PPDProcessController.ResultCoulmnsForType ResultCollType = new  TF_PPDProcessController.ResultCoulmnsForType();
        ResultCollType.type='center';        
    }
    private static testmethod void testResultCoulmnWithDefault(){ 
        TF_PPDProcessController.ResultCoulmnWithDefault ResultCollDef = new  TF_PPDProcessController.ResultCoulmnWithDefault();
        ResultCollDef.showVal='true';        
    }
    
    private static testmethod void testCounts(){ 
        TF_PPDProcessController.Counts  cnt = new  TF_PPDProcessController.Counts();
        cnt.count=10;
        cnt.productType ='book';
    }
    
    
    
    /* public  class zTest_TF_PPDProcessControllerHttpResponseGenerator implements HttpCalloutMock {
public HTTPResponse respond(HTTPRequest req) {
HttpResponse res = new HttpResponse();
res.setHeader('Content-Type', 'application/json');
TokenDetails token = new TokenDetails();
res.setBody(JSON.serialize(token));
res.setStatusCode(200);
return res;
}
}*/
    
    class TokenDetails {
        private String access_token ='123';
        private String token_type ='123';
        private Decimal expires_in = 123;
        private String id_token='123'; 
        private String refresh_token='123';
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
            }else if(req.getEndpoint().endsWith('products/search') && req.getMethod() == 'POST'){
                resptJson = '{"metadata":{"counts":[{"type":"book","count":1},{"count":1,"type":"Total"}],"limit":100,"offset":0,"prices":null,"type":"book","nextPageCursor":"7f0977af-6f5f-467d-8e1d-50e00741f16b","lastPageCursor":"last-page-cursor"},"data":[{"product":{"_id":"7f0977af-6f5f-467d-8e1d-50e00741f16b"},"availability":[{"name":"UBX","status":["SELLABLE","CAN_HOST","PUBLISHED"],"errors":[]}]}]}';
                //resptjson='{"data":[{"availability":[],"product":{"_id":"0049dce2-96ec-4a26-8189-7eb2039d0c9f","discountGroups":[{"code":"10","description":"10 (old TPS 12) - Informa Law & Electr Media"}],"classifications":[{"code":"SCAS05","level":2,"name":"Asian Studies","type":"subject"},{"code":"SCAS0530","level":3,"name":"South Asian Studies","type":"subject"},{"code":"SCAS053030","level":4,"name":"South Asian Politics","type":"subject"},{"code":"SCLA0114","level":3,"name":"Discourse Analysis","type":"subject"},{"code":"SCPI1015","level":3,"name":"South Asian Politics","type":"subject"},{"code":"SCPI7505","level":3,"name":"Political Communication","type":"subject"},{"code":"SCAS","level":1,"name":"Area Studies","type":"subject"},{"code":"SCLA01","level":2,"name":"Language & Linguistics","type":"subject"},{"code":"SCLA","level":1,"name":"Language & Literature","type":"subject"},{"code":"SCPI10","level":2,"name":"Asian Politics","type":"subject"},{"code":"SCPI","level":1,"name":"Politics & International Relations","type":"subject"},{"code":"SCPI75","level":2,"name":"Politics & the Media","type":"subject"},{"code":"POL003000","level":2,"name":"POLITICAL SCIENCE / Civics & Citizenship","type":"bisac"},{"code":"POL023000","level":2,"name":"POLITICAL SCIENCE / Economic Conditions","type":"bisac"},{"code":"POL046000","level":2,"name":"POLITICAL SCIENCE / Commentary & Opinion","type":"bisac"},{"code":"POL064000","level":2,"name":"POLITICAL SCIENCE / Corruption & Misconduct","type":"bisac"},{"code":"SOC053000","level":2,"name":"SOCIAL SCIENCE / Regional Studies","type":"bisac"}],"permissions":[{"code":"OA","name":"open-access","description":null,"text":null,"validFrom":null,"type":"access","validTo":null},{"code":"CTMRFM","name":"rfm","description":null,"text":"Ready For Market","validFrom":null,"type":"sales","validTo":null},{"code":"EBRALL","name":"EBRALL","description":null,"text":"Institutional, retail and Atypon","validFrom":null,"type":"access","validTo":null}],"identifiers":{"dacKey":"C2019-0-08285-8","orderNumber":"347517","isbn":"9780429217777","titleId":"420183","editionId":"803146","sku":null,"doi":"10.4324/9781003010241"},"book":{"copyright":{"year":2020},"publisherArea":"Social Science","format":"e-Book","edition":1,"textType":"Monograph (DRM-Free)","firstPublishedYear":"2020","publicationDate":null,"plannedPublicationDate":"2020-05-22T00:00:00.000Z","publisherImprint":"Routledge India","status":"In Production"},"impressionLocations":[{"distributionCenter":{"code":"LOC1","stockStatus":[],"location":"UK","status":"In Production","statusCode":"IHST"}},{"distributionCenter":{"code":"USNY","stockStatus":[],"location":"US Kentucky","status":"In Production","statusCode":"IHST"}},{"distributionCenter":{"code":"AUS","stockStatus":[],"location":"Australia - TLD","status":"In Production","statusCode":"IHST"}}],"categories":[{"code":"0I","name":"Asian Studies ROI UK","type":"flexcat"},{"code":null,"name":"monograph","type":"book-type"}],"contributors":[{"roles":["author"],"fullName":"Suman Gupta"}],"title":"Digital India and The Poor","type":"book","prices":[{"priceTypeCode":"BYO","price":0,"priceType":"BYO Library Price","currency":"EUR","validFrom":"2020-01-17T00:00:00.000Z"},{"priceTypeCode":"BYO","price":0,"priceType":"BYO Library Price","currency":"GBP","validFrom":"2020-01-17T00:00:00.000Z"},{"priceTypeCode":"BYO","price":0,"priceType":"BYO Library Price","currency":"USD","validFrom":"2020-01-17T00:00:00.000Z"},{"priceTypeCode":"IS","price":0,"priceType":"Institutional Price","currency":"GBP","validFrom":"2020-01-17T00:00:00.000Z"},{"priceTypeCode":"IS","price":0,"priceType":"Institutional Price","currency":"USD","validFrom":"2020-01-17T00:00:00.000Z"},{"priceTypeCode":"LP","price":0,"priceType":"Retail Price","currency":"GBP","validFrom":"2020-01-17T00:00:00.000Z"},{"priceTypeCode":"LP","price":0,"priceType":"Retail Price","currency":"USD","validFrom":"2020-01-17T00:00:00.000Z"},{"priceTypeCode":"LP","price":0,"priceType":"Retail Price","currency":"AUD","validFrom":"2020-02-05T00:00:00.000Z"},{"priceTypeCode":"LP","price":0,"priceType":"Retail Price","currency":"NZD","validFrom":"2020-02-05T00:00:00.000Z"}]}}],"metadata":{"counts":[{"count":1,"type":"book"},{"count":1,"type":"Total"}],"isFirstPageReached":true,"isLastPageReached":true,"lastPageCursor":"last-page-cursor","limit":500,"nextPageCursor":null,"offset":0,"prevPageCursor":null,"prices":[{"currency":"GBP","price":0,"priceType":"BYO Library Price","priceTypeCode":"BYO","productsCount":1},{"currency":"USD","price":0,"priceType":"BYO Library Price","priceTypeCode":"BYO","productsCount":1}],"source":"Elasticsearch","type":"book"}}';
                //resptJson = '{"metadata":{"application":"PCM","@id":"1a5186f6-a44b-4d8c-bc36-21222b5159f1","query":{"offset":0,"limit":30,"type":"Book"},"prices":[{"price":2315.95,"priceType":"BYO Library Price","productsCount":9,"currency":"USD","priceTypeCode":"BYO"},{"price":1268.87,"priceType":"Retail Price","productsCount":18,"currency":"GBP","priceTypeCode":"LP"}],"counts":[{"type":"Total","count":8},{"type":"Book","count":100},{"type":"Article","count":200}]},"data":[{"_id":"1a5186f6-a44b-4d8c-bc36-21222b515978","type":"Chapter","title":"The Book of the Civilised Man1","subtitle":"An English Translation of the Urbanus Magnus of Daniel of Beccles","format":"e-Book","doi":"10.1080/10427710050025349","openAccess":false,"publisherImprint":"Routledge","copyright":{"holder":"Fiona Whelan, Olivia Spenser and Francesca Petrizzo","year":"2019","statement":"© 2019 Fiona Whelan, Olivia Spenser and Francesca Petrizzo"},"contributors":[{"roles":["author"],"givenName":"Fiona","familyName":"Whelan","email":null,"bio":"Fiona Whelan completed her DPhil in Medieval History at the University of Oxford in 2015, and has previously studied at Trinity College Dublin and University College London. She has published widely on medieval codes of behaviour, in particular on Urbanus magnus by Daniel of Beccles. Her research interests include the cultivation of norms of behaviour, food and diet in the medieval period, household administration, and the manuscript culture of early courtesy literature.","orcid":null,"affiliation":[],"collab":null,"fullName":"Fiona Whelan1","position":1},{"roles":["author"],"givenName":"Olivia","familyName":"Spenser","email":null,"bio":"Olivia Spenser earned her MA in Medieval History from the University of Leeds at twenty-one, and holds a BA in Classical Studies from the University of Washington. Since falling in love with Latin in high school, she has pursued that linguistic passion into the study of Medieval as well as Classical Latin texts, and also into Classical Greek poetry. She lives in Seattle and spends time each week speaking Latin with her husband, and to her cat.","orcid":null,"affiliation":[],"collab":null,"fullName":"Olivia Spenser","position":2},{"roles":["author"],"givenName":"Francesca","familyName":"Petrizzo","email":null,"bio":"Francesca Petrizzo completed her PhD in Medieval Studies at the Institute for Medieval Studies, University of Leeds in 2018. She has previously studied at UCL and the University of Oxford. Her primary interests are kin and military history, with a focus on the Normans in the Mediterranean and the Crusades. Her interest in primary sources in their original language has brought her to this project, and she has been publishing on both family history and the use of literary sources in historical enquiry.","orcid":null,"affiliation":[],"collab":null,"fullName":"Francesca Petrizzo","position":3}],"classifications":[{"type":"subject","entries":[{"code":"SCHU01","priority":null,"description":"History","level":"2"},{"code":"SCHU0129","priority":null,"description":"Medieval History 400-1500","level":"3"},{"code":"SCHU0173","priority":null,"description":"Social & Cultural History","level":"3"},{"code":"SCHU","priority":null,"description":"Humanities","level":"1"}]}],"prices":[{"price":"127","currency":"GBP","validFrom":"2018-04-25","priceType":"BYO Library Price","priceTypeCode":"BYO"},{"price":"154","currency":"USD","validFrom":"2018-04-25","priceType":"BYO Library Price","priceTypeCode":"BYO"},{"price":"127","currency":"GBP","validFrom":"2018-04-25","priceType":"Institutional Price","priceTypeCode":"IS"},{"price":"154","currency":"USD","validFrom":"2018-04-25","priceType":"Institutional Price","priceTypeCode":"IS"},{"price":"39.99","currency":"GBP","validFrom":"2018-02-06","priceType":"Retail Price","priceTypeCode":"LP"},{"price":"54.95","currency":"USD","validFrom":"2018-02-06","priceType":"Retail Price","priceTypeCode":"LP"}],"position":1}]}';
               
                HttpResponse resp = new HttpResponse();
                resp.setHeader('Content-Type', 'application/json');
                resp.setBody(resptJson);      
                resp.setStatusCode(200);
                return resp;
            }else if(req.getEndpoint().endsWith('search') && req.getMethod() == 'POST'){
                //resptJson = '{"metadata":{"counts":[{"type":"book","count":1},{"count":1,"type":"Total"}],"limit":100,"offset":0,"prices":null,"type":"book","nextPageCursor":"7f0977af-6f5f-467d-8e1d-50e00741f16b","lastPageCursor":"last-page-cursor"},"data":[{"product":{"_id":"7f0977af-6f5f-467d-8e1d-50e00741f16b"},"availability":[{"name":"UBX","status":["SELLABLE","CAN_HOST","PUBLISHED"],"errors":[]}]}]}';
                resptjson='{"data":[{"availability":[],"product":{"_id":"0049dce2-96ec-4a26-8189-7eb2039d0c9f","discountGroups":[{"code":"10","description":"10 (old TPS 12) - Informa Law & Electr Media"}],"classifications":[{"code":"SCAS05","level":2,"name":"Asian Studies","type":"subject"},{"code":"SCAS0530","level":3,"name":"South Asian Studies","type":"subject"},{"code":"SCAS053030","level":4,"name":"South Asian Politics","type":"subject"},{"code":"SCLA0114","level":3,"name":"Discourse Analysis","type":"subject"},{"code":"SCPI1015","level":3,"name":"South Asian Politics","type":"subject"},{"code":"SCPI7505","level":3,"name":"Political Communication","type":"subject"},{"code":"SCAS","level":1,"name":"Area Studies","type":"subject"},{"code":"SCLA01","level":2,"name":"Language & Linguistics","type":"subject"},{"code":"SCLA","level":1,"name":"Language & Literature","type":"subject"},{"code":"SCPI10","level":2,"name":"Asian Politics","type":"subject"},{"code":"SCPI","level":1,"name":"Politics & International Relations","type":"subject"},{"code":"SCPI75","level":2,"name":"Politics & the Media","type":"subject"},{"code":"POL003000","level":2,"name":"POLITICAL SCIENCE / Civics & Citizenship","type":"bisac"},{"code":"POL023000","level":2,"name":"POLITICAL SCIENCE / Economic Conditions","type":"bisac"},{"code":"POL046000","level":2,"name":"POLITICAL SCIENCE / Commentary & Opinion","type":"bisac"},{"code":"POL064000","level":2,"name":"POLITICAL SCIENCE / Corruption & Misconduct","type":"bisac"},{"code":"SOC053000","level":2,"name":"SOCIAL SCIENCE / Regional Studies","type":"bisac"}],"permissions":[{"code":"OA","name":"open-access","description":null,"text":null,"validFrom":null,"type":"access","validTo":null},{"code":"CTMRFM","name":"rfm","description":null,"text":"Ready For Market","validFrom":null,"type":"sales","validTo":null},{"code":"EBRALL","name":"EBRALL","description":null,"text":"Institutional, retail and Atypon","validFrom":null,"type":"access","validTo":null}],"identifiers":{"dacKey":"C2019-0-08285-8","orderNumber":"347517","isbn":"9780429217777","titleId":"420183","editionId":"803146","sku":null,"doi":"10.4324/9781003010241"},"book":{"copyright":{"year":2020},"publisherArea":"Social Science","format":"e-Book","edition":1,"textType":"Monograph (DRM-Free)","firstPublishedYear":"2020","publicationDate":null,"plannedPublicationDate":"2020-05-22T00:00:00.000Z","publisherImprint":"Routledge India","status":"In Production"},"impressionLocations":[{"distributionCenter":{"code":"LOC1","stockStatus":[],"location":"UK","status":"In Production","statusCode":"IHST"}},{"distributionCenter":{"code":"USNY","stockStatus":[],"location":"US Kentucky","status":"In Production","statusCode":"IHST"}},{"distributionCenter":{"code":"AUS","stockStatus":[],"location":"Australia - TLD","status":"In Production","statusCode":"IHST"}}],"categories":[{"code":"0I","name":"Asian Studies ROI UK","type":"flexcat"},{"code":null,"name":"monograph","type":"book-type"}],"contributors":[{"roles":["author"],"fullName":"Suman Gupta"}],"title":"Digital India and The Poor","type":"book","prices":[{"priceTypeCode":"BYO","price":0,"priceType":"BYO Library Price","currency":"EUR","validFrom":"2020-01-17T00:00:00.000Z"},{"priceTypeCode":"BYO","price":0,"priceType":"BYO Library Price","currency":"GBP","validFrom":"2020-01-17T00:00:00.000Z"},{"priceTypeCode":"BYO","price":0,"priceType":"BYO Library Price","currency":"USD","validFrom":"2020-01-17T00:00:00.000Z"},{"priceTypeCode":"IS","price":0,"priceType":"Institutional Price","currency":"GBP","validFrom":"2020-01-17T00:00:00.000Z"},{"priceTypeCode":"IS","price":0,"priceType":"Institutional Price","currency":"USD","validFrom":"2020-01-17T00:00:00.000Z"},{"priceTypeCode":"LP","price":0,"priceType":"Retail Price","currency":"GBP","validFrom":"2020-01-17T00:00:00.000Z"},{"priceTypeCode":"LP","price":0,"priceType":"Retail Price","currency":"USD","validFrom":"2020-01-17T00:00:00.000Z"},{"priceTypeCode":"LP","price":0,"priceType":"Retail Price","currency":"AUD","validFrom":"2020-02-05T00:00:00.000Z"},{"priceTypeCode":"LP","price":0,"priceType":"Retail Price","currency":"NZD","validFrom":"2020-02-05T00:00:00.000Z"}]}}],"metadata":{"counts":[{"count":1,"type":"book"},{"count":1,"type":"Total"}],"isFirstPageReached":true,"isLastPageReached":true,"lastPageCursor":"last-page-cursor","limit":500,"nextPageCursor":null,"offset":0,"prevPageCursor":null,"prices":[{"currency":"GBP","price":0,"priceType":"BYO Library Price","priceTypeCode":"BYO","productsCount":1},{"currency":"USD","price":0,"priceType":"BYO Library Price","priceTypeCode":"BYO","productsCount":1}],"source":"Elasticsearch","type":"book"}}';
                //resptJson = '{"metadata":{"application":"PCM","@id":"1a5186f6-a44b-4d8c-bc36-21222b5159f1","query":{"offset":0,"limit":30,"type":"Book"},"prices":[{"price":2315.95,"priceType":"BYO Library Price","productsCount":9,"currency":"USD","priceTypeCode":"BYO"},{"price":1268.87,"priceType":"Retail Price","productsCount":18,"currency":"GBP","priceTypeCode":"LP"}],"counts":[{"type":"Total","count":8},{"type":"Book","count":100},{"type":"Article","count":200}]},"data":[{"_id":"1a5186f6-a44b-4d8c-bc36-21222b515978","type":"Chapter","title":"The Book of the Civilised Man1","subtitle":"An English Translation of the Urbanus Magnus of Daniel of Beccles","format":"e-Book","doi":"10.1080/10427710050025349","openAccess":false,"publisherImprint":"Routledge","copyright":{"holder":"Fiona Whelan, Olivia Spenser and Francesca Petrizzo","year":"2019","statement":"© 2019 Fiona Whelan, Olivia Spenser and Francesca Petrizzo"},"contributors":[{"roles":["author"],"givenName":"Fiona","familyName":"Whelan","email":null,"bio":"Fiona Whelan completed her DPhil in Medieval History at the University of Oxford in 2015, and has previously studied at Trinity College Dublin and University College London. She has published widely on medieval codes of behaviour, in particular on Urbanus magnus by Daniel of Beccles. Her research interests include the cultivation of norms of behaviour, food and diet in the medieval period, household administration, and the manuscript culture of early courtesy literature.","orcid":null,"affiliation":[],"collab":null,"fullName":"Fiona Whelan1","position":1},{"roles":["author"],"givenName":"Olivia","familyName":"Spenser","email":null,"bio":"Olivia Spenser earned her MA in Medieval History from the University of Leeds at twenty-one, and holds a BA in Classical Studies from the University of Washington. Since falling in love with Latin in high school, she has pursued that linguistic passion into the study of Medieval as well as Classical Latin texts, and also into Classical Greek poetry. She lives in Seattle and spends time each week speaking Latin with her husband, and to her cat.","orcid":null,"affiliation":[],"collab":null,"fullName":"Olivia Spenser","position":2},{"roles":["author"],"givenName":"Francesca","familyName":"Petrizzo","email":null,"bio":"Francesca Petrizzo completed her PhD in Medieval Studies at the Institute for Medieval Studies, University of Leeds in 2018. She has previously studied at UCL and the University of Oxford. Her primary interests are kin and military history, with a focus on the Normans in the Mediterranean and the Crusades. Her interest in primary sources in their original language has brought her to this project, and she has been publishing on both family history and the use of literary sources in historical enquiry.","orcid":null,"affiliation":[],"collab":null,"fullName":"Francesca Petrizzo","position":3}],"classifications":[{"type":"subject","entries":[{"code":"SCHU01","priority":null,"description":"History","level":"2"},{"code":"SCHU0129","priority":null,"description":"Medieval History 400-1500","level":"3"},{"code":"SCHU0173","priority":null,"description":"Social & Cultural History","level":"3"},{"code":"SCHU","priority":null,"description":"Humanities","level":"1"}]}],"prices":[{"price":"127","currency":"GBP","validFrom":"2018-04-25","priceType":"BYO Library Price","priceTypeCode":"BYO"},{"price":"154","currency":"USD","validFrom":"2018-04-25","priceType":"BYO Library Price","priceTypeCode":"BYO"},{"price":"127","currency":"GBP","validFrom":"2018-04-25","priceType":"Institutional Price","priceTypeCode":"IS"},{"price":"154","currency":"USD","validFrom":"2018-04-25","priceType":"Institutional Price","priceTypeCode":"IS"},{"price":"39.99","currency":"GBP","validFrom":"2018-02-06","priceType":"Retail Price","priceTypeCode":"LP"},{"price":"54.95","currency":"USD","validFrom":"2018-02-06","priceType":"Retail Price","priceTypeCode":"LP"}],"position":1}]}';
               
                HttpResponse resp = new HttpResponse();
                resp.setHeader('Content-Type', 'application/json');
                resp.setBody(resptJson);      
                resp.setStatusCode(200);
                return resp;
            }
            else if(req.getEndpoint().endsWith('products') && req.getMethod() == 'POST'){
                resptJson = '{"metadata":{"application":"PCM","@id":"1a5186f6-a44b-4d8c-bc36-21222b5159f1","query":{"offset":0,"limit":30,"type":"Book"},"prices":[{"price":2315.95,"priceType":"BYO Library Price","productsCount":9,"currency":"USD","priceTypeCode":"BYO"},{"price":1268.87,"priceType":"Retail Price","productsCount":18,"currency":"GBP","priceTypeCode":"LP"}],"counts":[{"type":"Total","count":8},{"type":"Book","count":100},{"type":"Article","count":200}]},"data":[{"_id":"1a5186f6-a44b-4d8c-bc36-21222b515978","type":"Chapter","title":"The Book of the Civilised Man1","subtitle":"An English Translation of the Urbanus Magnus of Daniel of Beccles","format":"e-Book","doi":"10.1080/10427710050025349","openAccess":false,"publisherImprint":"Routledge","copyright":{"holder":"Fiona Whelan, Olivia Spenser and Francesca Petrizzo","year":"2019","statement":"© 2019 Fiona Whelan, Olivia Spenser and Francesca Petrizzo"},"contributors":[{"roles":["author"],"givenName":"Fiona","familyName":"Whelan","email":null,"bio":"Fiona Whelan completed her DPhil in Medieval History at the University of Oxford in 2015, and has previously studied at Trinity College Dublin and University College London. She has published widely on medieval codes of behaviour, in particular on Urbanus magnus by Daniel of Beccles. Her research interests include the cultivation of norms of behaviour, food and diet in the medieval period, household administration, and the manuscript culture of early courtesy literature.","orcid":null,"affiliation":[],"collab":null,"fullName":"Fiona Whelan1","position":1},{"roles":["author"],"givenName":"Olivia","familyName":"Spenser","email":null,"bio":"Olivia Spenser earned her MA in Medieval History from the University of Leeds at twenty-one, and holds a BA in Classical Studies from the University of Washington. Since falling in love with Latin in high school, she has pursued that linguistic passion into the study of Medieval as well as Classical Latin texts, and also into Classical Greek poetry. She lives in Seattle and spends time each week speaking Latin with her husband, and to her cat.","orcid":null,"affiliation":[],"collab":null,"fullName":"Olivia Spenser","position":2},{"roles":["author"],"givenName":"Francesca","familyName":"Petrizzo","email":null,"bio":"Francesca Petrizzo completed her PhD in Medieval Studies at the Institute for Medieval Studies, University of Leeds in 2018. She has previously studied at UCL and the University of Oxford. Her primary interests are kin and military history, with a focus on the Normans in the Mediterranean and the Crusades. Her interest in primary sources in their original language has brought her to this project, and she has been publishing on both family history and the use of literary sources in historical enquiry.","orcid":null,"affiliation":[],"collab":null,"fullName":"Francesca Petrizzo","position":3}],"classifications":[{"type":"subject","entries":[{"code":"SCHU01","priority":null,"description":"History","level":"2"},{"code":"SCHU0129","priority":null,"description":"Medieval History 400-1500","level":"3"},{"code":"SCHU0173","priority":null,"description":"Social & Cultural History","level":"3"},{"code":"SCHU","priority":null,"description":"Humanities","level":"1"}]}],"prices":[{"price":"127","currency":"GBP","validFrom":"2018-04-25","priceType":"BYO Library Price","priceTypeCode":"BYO"},{"price":"154","currency":"USD","validFrom":"2018-04-25","priceType":"BYO Library Price","priceTypeCode":"BYO"},{"price":"127","currency":"GBP","validFrom":"2018-04-25","priceType":"Institutional Price","priceTypeCode":"IS"},{"price":"154","currency":"USD","validFrom":"2018-04-25","priceType":"Institutional Price","priceTypeCode":"IS"},{"price":"39.99","currency":"GBP","validFrom":"2018-02-06","priceType":"Retail Price","priceTypeCode":"LP"},{"price":"54.95","currency":"USD","validFrom":"2018-02-06","priceType":"Retail Price","priceTypeCode":"LP"}],"position":1}]}';
                 //resptJson = '{"metadata":{"counts":[{"type":"book","count":1},{"count":1,"type":"Total"}],"limit":100,"offset":0,"prices":null,"type":"book","nextPageCursor":"7f0977af-6f5f-467d-8e1d-50e00741f16b","lastPageCursor":"last-page-cursor"},"data":[{"product":{"_id":"7f0977af-6f5f-467d-8e1d-50e00741f16b"},"availability":[{"name":"UBX","status":["SELLABLE","CAN_HOST","PUBLISHED"],"errors":[]}]}]}';
              
                HttpResponse resp = new HttpResponse();
                resp.setHeader('Content-Type', 'application/json');
                resp.setBody(resptJson);      
                resp.setStatusCode(200);
                return resp;
            }else if(req.getEndpoint().endsWith('products/save') && req.getMethod() == 'POST'){
                responseJson ='{"_id":"ea8524ae-495d-4a95-bc27-c32eca30c185","status":"success","messages":[{"code":202,"description":"Product data uploaded successfully, it will be processed and acknowledged soon."}]}';
                HttpResponse resp = new HttpResponse();
                resp.setHeader('Content-Type', 'application/json');
                resp.setBody(responseJson);      
                resp.setStatusCode(200);
                return resp;
            }else if (req.getEndpoint().endsWith('type=exportcsv') && req.getMethod() == 'GET'){
                resptJson = '[{"location": "testlocation","type": "csv"}]';
                HttpResponse resp = new HttpResponse();
                resp.setHeader('Content-Type', 'application/json');
                resp.setBody(resptJson);      
                resp.setStatusCode(statusCode);
                return resp;
             }else if (req.getEndpoint().endsWith('type=partslist') && req.getMethod() == 'GET'){
                resptJson = '[{"location": "testlocation","type": "csv"}]';
                HttpResponse resp = new HttpResponse();
                resp.setHeader('Content-Type', 'application/json');
                resp.setBody(resptJson);      
                resp.setStatusCode(statusCode);
                return resp;
            }
            else if (req.getEndpoint().endsWith('salessheets&apiVersion=4.0.1') && req.getMethod() == 'GET'){
                resptJson = '{"location":"https://s3-euw1-ap-pe-df-pch-content-store-u.s3.eu-west-1.amazonaws.com/salessheets/reports/daily/salessheets.zip?AWSAccessKeyId=ASIAQFVOSJ577JNUMHXJ&Expires=1645335095&Signature=%2BXY7emN1dVqiZsnlYOXBfluBfnI%3D&response-content-disposition=attachment%3B%20filename%3D%22salessheets.zip%22&x-amz-security-token=IQoJb3JpZ2luX2VjEM7%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMSJHMEUCIGEwBwzIYXhj8dz5eBCS6IrpozUGMI6YkckcY666WXb%2BAiEA4Jut38OaFYE2I3djYYJ95HfzbYIrGmz6SK9rmRQ6Apkq%2BgMIJxADGgwwMTIxNzcyNjQ1MTEiDJgRezM5r8GwArwN%2FSrXA3yJhC8o4bayebcJxyvSQG7aPp4BDyQhyX7V7092lWKPjuC1aaItbIUnuTJRtkMPXbUva3QX%2FTaxuMMYiYtD256aRFyq4SkGLUFTLa6rhuLcu7xyTvkS0wjuOhcsKgYjh6k5XSq28X6yIcZ9UKPVHUV%2F7kl4HABc5nRmudP6Nfp3ovAmwOsmD%2FtDLSyc%2F20us%2B93Yl9CDpM1HsPIMX7%2Fe%2BtQImuc9qDOYOmrkQdyMRpl8KfyKeaN3f73OoDQn%2FsopmV8nj1XJRhB0fenqwkem5%2FwuMDE%2FZIq9f%2FXh7d8cLd2mCs1s0%2FZlxcD%2FrgDNrI2qdrC5tYRme3Icsn96aKh4D%2BVKTN2Ncqw21nnB8u4pfGCkVeKz6YPZms8nyfJLk0u9CHb1YipElm4lsmLTcLDjL2tdRbrjrZBqCskMIJgRTFLaBGuMn5ZUWZ28SCnyNaBYUItYmYQro64Ej%2BntVlanVChDp8LAk4bB0qxCjsS6KPhWYopd9JttlgHNUINh1w%2BR3g%2F5xUiOJpznc%2F1suNLK01YIYEeLMZmweE%2BaLBm5jp8vbQmPcGBgZKjOh9b%2BsCV49iS6uU7TI9L6SmoJxZXEk1KDn3Q1JKZ5YfvO%2FOHPibKBsspQ9A9ZjCepMeQBjqlASJg10IQfQB3%2BJ9WBmJS46%2FHRb5sUe7ssvJfXrcNvL3ZrVr%2FyzblyaDuHs5tnuid6Z0AUMaykSfZnWiqByToD7TEOsEd%2BlinlhXu4%2BGyRXC%2B%2Ba%2Bue9Ws3KHapkTOP05H5JPu1cU9b5VU9BPjIcJoHhw2QUmza7F2cv6mEy3s8ePD0qRohli265NCaLgtSbeK4UJnTkut6KpG7sh%2F9Gijx4GhYddm7g%3D%3D"}';
                HttpResponse resp = new HttpResponse();
                resp.setHeader('Content-Type', 'application/json');
                resp.setBody(resptJson);      
                resp.setStatusCode(statusCode);
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
        setting.Search_API_URL__c='https://api-uat.taylorfrancis.com/v4/products/search';
        setting.Parts_Api_Url__c='https://api-dev.taylorfrancis.com/v4/products/';
        setting.Dynamic_Package_API_URL__c='https://api-dev.taylorfrancis.com/v4/products/save';
        setting.downloadPartsAPI_url__c  ='https://api-dev.taylorfrancis.com/v4/products/content/';
        setting.New_Search_API_URL__c  = 'https://api-dev.taylorfrancis.com/v4/products/search';
        
        insert setting; 
        
        List<QueryApiMapping__c> mapppingLst = new List<QueryApiMapping__c>{new QueryApiMapping__c(Query_Field_Label__c='maxPrice',Name='maxPrice',PCM_Query_Path__c='prices.price',Active__c=true), new QueryApiMapping__c(Query_Field_Label__c='minPrice',Name='minPrice',PCM_Query_Path__c='prices.price',Active__c=true) };
            insert mapppingLst ;
        
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
        newParentProduct.Product_Type_Author_Facing__c='Rule Based';
        newParentProduct.alternateName__c='alternate';
        newParentProduct.inLanguage__c='en';
        newParentProduct.version__c='1.0';
        newParentProduct.doi__c='122/33';
        newParentProduct.ean__c='333';
        newParentProduct.issn__c='12345';
        newParentProduct.Publisher__c='Pub';
        newParentProduct.Dynamic_Collection_Criteria__c = '{"filterObject":{"ISBN":"","title":"","author":"","doi":"","netbase":[],"subjectList":[],"mediumData":"e-Book","publishData":"","minPrice":"10","maxPrice":"20","sortBy":"desc","sortOrderFieldName":"UnitPrice","drmData":"Both","currencyTypeData":"USD","firstPublishedYearData":"2018","publcFromDate":null,"publcToDate":null},"ruleElementLst":[{"type":"separator","value":"BEGIN"},{"attribute":"format","relationship":"IN","type":"criteria","value":"e-Book"},{"type":"logical","value":"AND"},{"attribute":"firstPublishedYear","relationship":"EQ","type":"criteria","value":"2018"},{"type":"logical","value":"AND"},{"type":"separator","value":"BEGIN"},{"attribute":"prices.price","relationship":"GE","type":"criteria","value":"10"},{"type":"logical","value":"AND"},{"attribute":"prices.price","relationship":"LE","type":"criteria","value":"20"},{"type":"logical","value":"AND"},{"attribute":"prices.currency","relationship":"EQ","type":"criteria","value":"USD"},{"type":"separator","value":"END"},{"type":"separator","value":"END"}],"queryString":"format EQ e-Book AND firstPublishedYear EQ 2018 AND minPrice GE 10 AND maxPrice LE 20 AND currency EQ USD "}';
        newParentProduct.businessId__c='SDGO-TESTDATA';
        newParentProduct.Sales_Channels__c='UBX_sales';
        
        insert newParentProduct;
        
        Setting__c settingCust = new Setting__c();
        settingCust.Name = 'DynamicSearchUIValues';        
        insert settingCust;
        
        Setting_Item__c settingItm = new Setting_Item__c();
        settingItm.Setting__c = settingCust.id ;
        settingItm.Checkbox_4__c = true;
        settingItm.Checkbox_1__c = true ;
        settingItm.Checkbox_2__c = true ;
        settingItm.Checkbox_3__c = true ;
        settingItm.Checkbox_4__c = true ;
        settingItm.Text_1__c = 'Book' ;
        settingItm.Text_2__c = 'format' ;
        settingItm.Text_3__c = 'format' ;
        settingItm.Text_4__c = 'format' ;
        settingItm.Text_5__c = 'text' ;
        settingItm.Text_6__c = 'format' ;
        settingItm.Text_7__c = 'Self' ;
        settingItm.Long_Text_1__c = 'IN,NOT IN';
        
        insert settingItm ;
        
        
        // test data for search availability
        
        Setting__c setting_cust = new Setting__c();
        setting_cust.name = 'SearchAvailability';
        
        insert setting_cust ; 
        
        Setting_Item__c setting_Itm = new Setting_Item__c();
        setting_Itm.Setting__c = setting_cust.id ;
        setting_Itm.Checkbox_1__c = true ;
        setting_Itm.Text_1__c = 'Collections';
        setting_Itm.Text_2__c = 'UBX_Delivery';
        setting_Itm.Text_3__c = 'CAN_HOST,INCLUDE_IN_DYNAMIC_PACKAGE';
        setting_Itm.Text_4__c = 'ALL'; 
        setting_Itm.Text_5__c = 'UBX';
        
        Setting_Item__c setting_Itm2 = new Setting_Item__c();
        setting_Itm2.Setting__c = setting_cust.id ;
        setting_Itm2.Checkbox_1__c = true ;
        setting_Itm2.Text_1__c = 'Collections';
        setting_Itm2.Text_2__c = 'UBX_Sales';
        setting_Itm2.Text_3__c = 'CAN_HOST,INCLUDE_IN_DYNAMIC_PACKAGE';
        setting_Itm2.Text_4__c = 'ALL'; 
        setting_Itm2.Text_5__c = 'UBX';
        
        
        Setting_Item__c setting_Itm3 = new Setting_Item__c();
        setting_Itm3.Setting__c = setting_cust.id ;
        setting_Itm3.Checkbox_1__c = true ;
        setting_Itm3.Text_1__c = 'OPC';
        setting_Itm3.Text_2__c = 'UBX_Sales';
        setting_Itm3.Text_3__c = 'CAN_HOST,INCLUDE_IN_DYNAMIC_PACKAGE';
        setting_Itm3.Text_4__c = 'ALL'; 
        setting_Itm3.Text_5__c = 'UBX';
        
        List<Setting_Item__c> settingItmLst = new List<Setting_Item__c>();
        settingItmLst.add(setting_Itm);
        settingItmLst.add(setting_Itm2);
        settingItmLst.add(setting_Itm3);
        
        insert settingItmLst ;
    }
    
    //Positive Test for getProducts
    private static testMethod void getProducts_Return() {
        test.startTest();
        //String queryObj='[{"type":"attribute","name":"title","value":["india"],"operatior":"EQ","position":1,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"logical","name":"","value":[],"operatior":"","position":2,"logicalOpp":"AND","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"attribute","name":"mediumData","value":["e-Book"],"operatior":"EQ","position":3,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"logical","name":"","value":[],"operatior":"","position":4,"logicalOpp":"AND","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"attribute","name":"publishData","value":["Include"],"operatior":"EQ","position":5,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"logical","name":"","value":[],"operatior":"","position":6,"logicalOpp":"AND","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"attribute","name":"sortOrderFieldName","value":["UnitPrice"],"operatior":"EQ","position":7,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"logical","name":"","value":[],"operatior":"","position":8,"logicalOpp":"AND","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"attribute","name":"drmData","value":["Both"],"operatior":"EQ","position":9,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"logical","name":"","value":[],"operatior":"","position":10,"logicalOpp":"AND","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"attribute","name":"currencyTypeData","value":["USD"],"operatior":"EQ","position":11,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"logical","name":"","value":[],"operatior":"","position":12,"logicalOpp":"AND","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"attribute","name":"firstPublishedYearData","value":["2019"],"operatior":"EQ","position":13,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"logical","name":"","value":[],"operatior":"","position":14,"logicalOpp":"AND","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"attribute","name":"sortBy","value":["desc"],"operatior":"EQ","position":15,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"attribute","name":"title","value":["india"],"operatior":"EQ","position":1,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"logical","name":"","value":[],"operatior":"","position":2,"logicalOpp":"AND","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"attribute","name":"netbase","value":["WB004 - ENGnetBASE"],"operatior":"IN","position":3,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"logical","name":"","value":[],"operatior":"","position":4,"logicalOpp":"AND","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"attribute","name":"mediumData","value":["e-Book"],"operatior":"EQ","position":5,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"logical","name":"","value":[],"operatior":"","position":6,"logicalOpp":"AND","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"attribute","name":"publishData","value":["Include"],"operatior":"EQ","position":7,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"logical","name":"","value":[],"operatior":"","position":8,"logicalOpp":"AND","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"attribute","name":"sortOrderFieldName","value":["UnitPrice"],"operatior":"EQ","position":9,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"logical","name":"","value":[],"operatior":"","position":10,"logicalOpp":"AND","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"attribute","name":"drmData","value":["Both"],"operatior":"EQ","position":11,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"logical","name":"","value":[],"operatior":"","position":12,"logicalOpp":"AND","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"attribute","name":"currencyTypeData","value":["USD"],"operatior":"EQ","position":13,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"logical","name":"","value":[],"operatior":"","position":14,"logicalOpp":"AND","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"attribute","name":"firstPublishedYearData","value":["2019"],"operatior":"EQ","position":15,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"logical","name":"","value":[],"operatior":"","position":16,"logicalOpp":"AND","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"attribute","name":"sortBy","value":["desc"],"operatior":"EQ","position":17,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"attribute","name":"title","value":["india"],"operatior":"EQ","position":1,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"logical","name":"","value":[],"operatior":"","position":2,"logicalOpp":"AND","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"attribute","name":"mediumData","value":["e-Book"],"operatior":"EQ","position":3,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"logical","name":"","value":[],"operatior":"","position":4,"logicalOpp":"AND","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"attribute","name":"publishData","value":["Include"],"operatior":"EQ","position":5,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"logical","name":"","value":[],"operatior":"","position":6,"logicalOpp":"AND","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"attribute","name":"sortOrderFieldName","value":["UnitPrice"],"operatior":"EQ","position":7,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"logical","name":"","value":[],"operatior":"","position":8,"logicalOpp":"AND","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"attribute","name":"drmData","value":["Both"],"operatior":"EQ","position":9,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"logical","name":"","value":[],"operatior":"","position":10,"logicalOpp":"AND","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"attribute","name":"currencyTypeData","value":["USD"],"operatior":"EQ","position":11,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"logical","name":"","value":[],"operatior":"","position":12,"logicalOpp":"AND","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"attribute","name":"firstPublishedYearData","value":["2019"],"operatior":"EQ","position":13,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"logical","name":"","value":[],"operatior":"","position":14,"logicalOpp":"AND","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"attribute","name":"sortBy","value":["desc"],"operatior":"EQ","position":15,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0}]';
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');
        system.debug(productRecordtypeId);
        Id standardPriceBookId=Test.getStandardPricebookId();
        
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        newParentProduct.ProductCode = '9781315367897';
        newParentProduct.IsActive = true;
        newParentProduct.System_ID__c = 'GT_TF';
        newParentProduct.Version_Type__c = 'e-Book';
        newParentProduct.ISBN__c = '9781315367897';
        
        newParentProduct.Sales_Channels__c='UBX_sales';
        newParentProduct.Dynamic_Collection_Criteria__c = '{"filterObject":{"ISBN":"","title":"","author":"","doi":"","netbase":[],"subjectList":[],"mediumData":"e-Book","publishData":"","minPrice":"10","maxPrice":"20","sortBy":"desc","sortOrderFieldName":"UnitPrice","drmData":"Both","currencyTypeData":"USD","firstPublishedYearData":"2018","publcFromDate":null,"publcToDate":null},"ruleElementLst":[{"type":"separator","value":"BEGIN"},{"attribute":"format","relationship":"IN","type":"criteria","value":"e-Book"},{"type":"logical","value":"AND"},{"attribute":"firstPublishedYear","relationship":"EQ","type":"criteria","value":"2018"},{"type":"logical","value":"AND"},{"type":"separator","value":"BEGIN"},{"attribute":"prices.price","relationship":"GE","type":"criteria","value":"10"},{"type":"logical","value":"AND"},{"attribute":"prices.price","relationship":"LE","type":"criteria","value":"20"},{"type":"logical","value":"AND"},{"attribute":"prices.currency","relationship":"EQ","type":"criteria","value":"USD"},{"type":"separator","value":"END"},{"type":"separator","value":"END"}],"queryString":"format EQ e-Book AND firstPublishedYear EQ 2018 AND minPrice GE 10 AND maxPrice LE 20 AND currency EQ USD "}';

        
        update newParentProduct;
        /*
Select Id,Pricebook2.name,CurrencyIsoCode,UnitPrice,Product2.ID,Product2.ISBN__c,Product2.Product_Id_Link__c,Product2.eBook_ISBN__c,Product2.Paperback_ISBN__c,
Product2.Hardback_ISBN__c,Product2.Edition_Number__c,Product2.Name,Product2.Lead_Author_Editor__c,
Product2.US_Publication_Date__c,Product2.US_Planned_Publication_Date__c,Product2.Version_Type__c,Product2.US_Inventory_Status__c,Product2.POD__c  
From PricebookEntry  where 
Pricebook2.IsActive = true and Product2.IsActive = true and IsActive = true and CurrencyIsoCode='USD' and Product2.System_ID__c='GT_TF' and Pricebook2.name='Standard Price Book' and Product2.ProductCode='9781315367897' and Product2.Version_Type__c = 'e-Book' order by UnitPrice desc LIMIT 2001
* */
        
        PriceBookEntry pbeStdUSD = new PricebookEntry(Pricebook2Id=Test.getStandardPricebookId(),Product2Id=newParentProduct.id, UnitPrice=4.00, IsActive=true,CurrencyIsoCode='USD');
        upsert pbeStdUSD;  
        system.debug('pbeStdUSD'+pbeStdUSD);
        
        TF_PPDProcessController.PagedResultDetails prd=new TF_PPDProcessController.PagedResultDetails();
        String filter='{"ISBN":"123","title":"sdfsdf","author":"asdf","doi":"123456","netbase":["WB010 - ENVIROnetBASE"],"subjectList":["Test Level 2"],"mediumData":"e-Book","publishData":"Include","minPrice":"10","maxPrice":"10","sortBy":"desc","sortOrderFieldName":"UnitPrice","drmData":"Both","currencyTypeData":"USD","firstPublishedYearData":"2019","publcFromDate":"2019-05-08","publcToDate":"2019-05-22"}';
        prd=TF_PPDProcessController.getProducts(filter);  
        filter='{"ISBN":"9781315367897","title":"","author":"","doi":"","netbase":[],"subjectList":[],"mediumData":"e-Book","publishData":"Include","minPrice":"","maxPrice":"","sortBy":"desc","sortOrderFieldName":"UnitPrice","drmData":"Both","currencyTypeData":"USD","firstPublishedYearData":"","publcFromDate":null,"publcToDate":null}';
        prd=TF_PPDProcessController.getProducts(filter);   
        filter='{"ISBN":"9781315367897","title":"","author":"","doi":"","netbase":[],"subjectList":[],"mediumData":"e-Book","publishData":"Include","minPrice":"","maxPrice":"10","sortBy":"desc","sortOrderFieldName":"UnitPrice","drmData":"Both","currencyTypeData":"USD","firstPublishedYearData":"","publcFromDate":null,"publcToDate":null}';
        prd=TF_PPDProcessController.getProducts(filter); 
        filter='{"ISBN":"9781315367897","title":"","author":"","doi":"","netbase":[],"subjectList":[],"mediumData":"e-Book","publishData":"Include","minPrice":"10","maxPrice":"","sortBy":"desc","sortOrderFieldName":"UnitPrice","drmData":"Both","currencyTypeData":"USD","firstPublishedYearData":"","publcFromDate":null,"publcToDate":null}';
        prd=TF_PPDProcessController.getProducts(filter); 
        filter='{"ISBN":"","title":"","":"","doi":"","netbase":[],"subjectList":[],"mediumData":"e-Book","publishData":"","minPrice":"","maxPrice":"","sortBy":"desc","sortOrderFieldName":"UnitPrice","drmData":"","currencyTypeData":"USD","firstPublishedYearData":"","publcFromDate":null,"publcToDate":null}';
        prd=TF_PPDProcessController.getProducts(filter); 
        filter='{"ISBN":"","title":"","":"","doi":"","netbase":[],"subjectList":[],"mediumData":"Collection","publishData":"","minPrice":"","maxPrice":"","sortBy":"desc","sortOrderFieldName":"UnitPrice","drmData":"","currencyTypeData":"USD","firstPublishedYearData":"","publcFromDate":null,"publcToDate":null}';
        prd=TF_PPDProcessController.getProducts(filter); 
        filter='{"ISBN":"","title":"","":"","doi":"","netbase":[],"subjectList":[],"mediumData":"Collection","publishData":"","minPrice":"","maxPrice":"","sortBy":"desc","sortOrderFieldName":"CurrencyIsoCode","drmData":"True","currencyTypeData":"USD","firstPublishedYearData":"","publcFromDate":null,"publcToDate":null}';
        prd=TF_PPDProcessController.getProducts(filter); 
        test.stopTest();  
    } 
    
    
    //Positive Test for addProductsToCollection
    private static testMethod void addProductsToCollection_ReturnValue(){
        test.startTest();
        String result='';
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        system.debug(productRecordtypeId);
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
       // Product2 newChildProduct=zTEST_Shared.insertProduct2(productRecordtypeId); 
       Product2 newChildProduct=insertProductforTesting(productRecordtypeId);       
        result =TF_PPDProcessController.addProductsToCollection(newParentProduct.id, newChildProduct.id);  
        System.assert(result!= null);
        test.stopTest();
    }
    //Negative Test for addProductsToCollection
    private static testMethod void addProductsToCollection_ReturnNULL(){
        test.startTest();
        String result='';
        String testParent='01t1l0000001EYDAA2';
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        system.debug(productRecordtypeId);
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        //Product2 newChildProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newChildProduct=insertProductforTesting(productRecordtypeId);

        try
        {
            result =TF_PPDProcessController.addProductsToCollection(testParent, newChildProduct.id);  
        }
        Catch(exception e)
        {
            System.Debug(e.getMessage());
            System.assert(e.getMessage().contains('failed')== true);
        }        
        
        test.stopTest();
    }                                                             
    //Postive Test for addMultipleProductsToCollection
    private static testMethod void addMultipleProductsToCollection_ReturnValues(){
        test.startTest();
        String result='';
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        system.debug(productRecordtypeId);
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        //Product2 newChildProduct1=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newChildProduct1=insertProductforTesting(productRecordtypeId);

        //Product2 newChildProduct2=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newChildProduct2=insertProductforTesting(productRecordtypeId);

        //Product2 newChildProduct3=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newChildProduct3=insertProductforTesting(productRecordtypeId);

        
        List<String> listProdIds=new List<String>();
        listProdIds.add(newChildProduct1.id);
        listProdIds.add(newChildProduct2.id);
        listProdIds.add(newChildProduct3.id);
        system.debug(listProdIds); 
        
        result =TF_PPDProcessController.addMultipleProductsToCollection(newParentProduct.id,listProdIds);  
        System.assert(result!= '');
        
        Id productsRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - eBooks Products');
        //Product2 newParentProducts=zTEST_Shared.insertProduct2(productsRecordtypeId);
         Product2 newParentProducts=insertProductforTesting(productRecordtypeId);
        //Product2 newChildProducts1=zTEST_Shared.insertProduct2(productsRecordtypeId);
         Product2 newChildProducts1=insertProductforTesting(productRecordtypeId);
        //Product2 newChildProducts2=zTEST_Shared.insertProduct2(productsRecordtypeId); 
         Product2 newChildProducts2=insertProductforTesting(productRecordtypeId);
        
        List<String> listProdsIds=new List<String>();
        listProdsIds.add(newChildProducts1.id);
        listProdsIds.add(newChildProducts2.id);
        result =TF_PPDProcessController.addMultipleProductsToCollection(newParentProducts.id,listProdsIds);  
        System.assert(result!= '');
        test.stopTest();
    }
    
    //Postive Test for addMultipleProductsToCollection wth extra parameter
    private static testMethod void addMultipleProductsToCollection_ReturnExtra(){
        test.startTest();
        String result='';
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        system.debug(productRecordtypeId);
       // Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        //Product2 newChildProduct1=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newChildProduct1=insertProductforTesting(productRecordtypeId);

        //Product2 newChildProduct2=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newChildProduct2=insertProductforTesting(productRecordtypeId);

        //Product2 newChildProduct3=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newChildProduct3=insertProductforTesting(productRecordtypeId);

        
        List<String> listProdIds=new List<String>();
        listProdIds.add(newChildProduct1.id);
        listProdIds.add(newChildProduct2.id);
        listProdIds.add(newChildProduct3.id);
        system.debug(listProdIds); 
        
        result =TF_PPDProcessController.addMultipleProductsToCollection(newParentProduct.id,listProdIds,'Include');  
        System.assert(result!= '');
        test.stopTest();
    }
    
    //Negative Test for addMultipleProductsToCollection
    private static testMethod void addMultipleProductsToCollection_ReturnNULL(){
        test.startTest();
        String result='';
        String testParent='01t1l0000001EYDAA2';
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        system.debug(productRecordtypeId);
        //Product2 newChildProduct1=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newChildProduct1=insertProductforTesting(productRecordtypeId);

        //Product2 newChildProduct2=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newChildProduct2=insertProductforTesting(productRecordtypeId);

        //Product2 newChildProduct3=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newChildProduct3=insertProductforTesting(productRecordtypeId);

        
        List<String> listProdIds=new List<String>();
        listProdIds.add(newChildProduct1.id);
        listProdIds.add(newChildProduct2.id);
        listProdIds.add(newChildProduct3.id);
        system.debug(listProdIds); 
        try
        {
            result =TF_PPDProcessController.addMultipleProductsToCollection(testParent,listProdIds);   
        }
        
        Catch(exception e)
        {
            System.Debug(e.getMessage());
            System.assert(e.getMessage().contains('failed')== true);
        }
        
        test.stopTest();
    }
    
    //Postive Test for deleteProducts
    private static testMethod void deleteProducts_ReturnTrue(){
        test.startTest();
        list< Bundle_Line_Item__c> listofLineItems=new List<Bundle_Line_Item__c>();
        String result='';
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        system.debug(productRecordtypeId);
       // Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

       // Product2 newChildProduct1=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newChildProduct1=insertProductforTesting(productRecordtypeId);

       // Product2 newChildProduct2=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newChildProduct2=insertProductforTesting(productRecordtypeId);

       // Product2 newChildProduct3=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newChildProduct3=insertProductforTesting(productRecordtypeId);

        
        List<String> listProdIds=new List<String>();
        listProdIds.add(newChildProduct1.id);
        listProdIds.add(newChildProduct2.id);
        listProdIds.add(newChildProduct3.id);
        result=TF_PPDProcessController.deleteProducts(newParentProduct.id,listProdIds);
        System.assert(result!= '');       
        test.stopTest();
    }
    //Negative Test for deleteProducts
    private static testMethod void deleteProducts_ReturnFalse(){
        test.startTest();
        String result='';
        String testParent='01t1l0000001EYDAA2';
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        system.debug(productRecordtypeId);
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        //Product2 newChildProduct1=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newChildProduct1=insertProductforTesting(productRecordtypeId);

        //Product2 newChildProduct2=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newChildProduct2=insertProductforTesting(productRecordtypeId);

        //Product2 newChildProduct3=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newChildProduct3=insertProductforTesting(productRecordtypeId);

        
        List<String> listProdIds=new List<String>();
        listProdIds.add(newChildProduct1.id);
        listProdIds.add(newChildProduct2.id);
        listProdIds.add(newChildProduct3.id);
        try
        { result=TF_PPDProcessController.deleteProducts(testParent,listProdIds);}
        Catch(exception e)
        {
            System.Debug(e.getMessage());
        }       
        System.assert(result!= '');       
        test.stopTest();
    }
    //Positive test for getBundleTitles
    private static testmethod void getBundleTitles(){
        test.startTest();
        Boolean expectedExceptionThrown=false;
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        system.debug(productRecordtypeId);
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);  
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        try
        {TF_PPDProcessController.getBundleTitles(newParentProduct.id);  
        }
        Catch(exception e)
        {System.Debug(e.getMessage());
         expectedExceptionThrown = true;
         System.AssertEquals(expectedExceptionThrown, true); 
        }
        test.stopTest();
    }
    
    //Negative test for getBundleTitles
    private static testmethod void getBundleTitles_ReturnNULL(){
        test.startTest();
        String testParent='01t1l0000001EYDAA2';  
        Boolean expectedExceptionThrown =false;
        try
        {TF_PPDProcessController.getBundleTitles(testParent);  
        }
        Catch(exception e)
        {System.Debug(e.getMessage());
         expectedExceptionThrown = true;
         System.AssertEquals(expectedExceptionThrown, true);
        }
        test.stopTest();
    }
    
    private static testmethod void getDynamicBundleTitles_Return() {
        test.startTest();
        TF_PPDProcessController.PagedResult pr=new TF_PPDProcessController.PagedResult();
        String filter='{"productName":"india","leadAuthor":"","publisher":"","versionTypes":["e-Book","Hardback"]}';
        //pr=TF_PPDProcessController.getDynamicBundleTitles(filter);  
        test.stopTest();      
    }


    private static testmethod void testcallNewModelQueryAPI(){
        test.startTest();
        
        test.stopTest();
    }    
    private static testmethod void addListOfPrductsViaFile_Return(){
        test.startTest();
        String result='';
        TF_PPDProcessController.FileUploadDetails fld=new TF_PPDProcessController.FileUploadDetails();
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        system.debug(productRecordtypeId);
        //Product2 newParentProduct1=zTEST_Shared.insertProduct2(productRecordtypeId);    
        Product2 newParentProduct1=insertProductforTesting(productRecordtypeId);
        fld=TF_PPDProcessController.addListOfPrductsViaFile(newParentProduct1.id,'OTc4LTAtMDgwLTQ3NzYyNg0KOTc4LTAtMjAzLTAyNDExOQ0K','ISBN','Manual Curation','Include');
        System.assert(fld.totalRecs>0);     
        fld.totalRecs=0;
        //Product2 newParentProduct2=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newParentProduct2=insertProductforTesting(productRecordtypeId);
        fld=TF_PPDProcessController.addListOfPrductsViaFile(newParentProduct2.id,'MDF0MFkwMDAwMDcySTJoUUFFDQowMXQwWTAwMDAwNzJJMmlRQUUNCg%3D%3D','SFDCId','Manual Curation','Include');
        System.assert(fld.totalRecs>0);
        fld.totalRecs=0;
        //Product2 newParentProduct3=zTEST_Shared.insertProduct2(productRecordtypeId); 
        
        Product2 newParentProduct3 = new Product2(name='SFDC', ProductCode='1979', IsActive=true, Description='test', RecordTypeId=productRecordtypeId,
                                                  ISBN__c = '1979', Competitor_Publisher__c='test', Subject_Code__c='test',version_type__c='e-Book',doi__c='1.089777/123',businessId__c='SDGO-PRODATA',Product_category__c='SDGO',Sales_channels__c='UBX_sales');
        insert newParentProduct3;
        string before = newParentProduct3.Id; 
        Blob beforeblob = Blob.valueOf(before);
        string paramvalue = EncodingUtil.base64Encode(beforeblob);
        
        fld=TF_PPDProcessController.addListOfPrductsViaFile(newParentProduct3.id,paramvalue,'SFDCId','Manual Curation','Include');
        before=newParentProduct3.Id +','+ '01t9E0000060t39QAA';        
        beforeblob=Blob.valueOf(before);
        paramvalue= EncodingUtil.base64Encode(beforeblob);
        fld=TF_PPDProcessController.addListOfPrductsViaFile(newParentProduct3.id,paramvalue,'SFDCId','Manual Curation','Include');
        
        fld=TF_PPDProcessController.addListOfPrductsViaFile(newParentProduct3.id,'MTk3OSwxOTgw','ISBN','Manual Curation','Include');  
        fld=TF_PPDProcessController.addListOfPrductsViaFile(newParentProduct3.id,'MTk3OSwxOTgw','ISBN','Manual Curation','Exclude');
        String encode='OTc4MDIwMzUwNzA1Ng0KOTc4MTMxNTQ0NDIwOA0KOTc4MDIwMzg0OTUxNA0KOTc4MDIwMzg0Nzc4Nw0KOTc4MDIwMzUzOTE0OQ0KOTc4MTMxNTE2NDc5Mw0KOTc4MTMxNTE2NTM4Nw0KOTc4MDIwMzQyMDA1OA0KOTc4MDIwMzY0MTk4OQ0KOTc4MDIwMzQ5ODk2NQ0KOTc4MDIwMzIwNjA0MQ0KOTc4MDIwMzY0NjkyMg0KOTc4MTQxMDYxMDY1Mg0KOTc4MTMxNTYzMzkxNg0KOTc4MTMxNTgyOTQ0OQ0KOTc4MTMxNTAzMzAxMw0KOTc4MDIwMzEwNTAwOQ0KOTc4MTMxNTY4Njc5MA0KOTc4MDIwMzg2NzAzNw0KOTc4MDIwMzgwMjkxNQ0KOTc4MTg0OTc3MzE0MA0KOTc4MTMxNTg2NjcyNw0KOTc4MTMxNTY4MzYwNw0KOTc4MTMxNTExMjAzOQ0KOTc4MTMxNTU4NjU5NQ0KOTc4MTMxNTI1MDg2MQ0KOTc4MTMxNTYzNTk3Mg0KOTc4MTMxNTU4MjU3Mw0KOTc4MDIwMzE2Mzg0OQ0KOTc4MDIwMzQzMjU4Nw0KOTc4MDIwMzUwNTc1NQ0KOTc4MDIwMzk4OTkzNw0KOTc4MDIwMzg4OTc1Ng0KOTc4MTMxNTYxNTM2Mw0KOTc4MTMxNTQ2NDM3NA0KOTc4MTMxNTA3MTg2Mg0KOTc4MTMxNTg4Mzk4NA0KOTc4MTMxNTAzNDE1Nw0KOTc4MTMxNTAwNDk4Mw0KOTc4MDIwMzY0MDM2NA0KOTc4MDIwMzcxNDczNw0KOTc4MTMxNTYxMzM2OQ0KOTc4MTMxNTU4OTk4NQ0KOTc4MTQxMDYwOTIwNQ0KOTc4MDIwMzkyODM3MA0KOTc4MDIwMzIwMTYxOQ0KOTc4MDIwMzE0OTk2Ng0KOTc4MDIwMzEyNTg2MQ0KOTc4MTMxNTYwNjU0NQ0KOTc4MTMxNTE1ODY0OA0KOTc4MTMxNTY1ODM2MA0KOTc4MTMxNTc0NTgyNA0KOTc4MTMxNTgxMzU3OA0KOTc4MTMxNTc0ODQyOQ0KOTc4MTMxNTE5OTY4OQ0KOTc4MTMxNTA2MTg2Mw0KOTc4MTMxNTY0OTI5MA0KOTc4MTMxNTYzMTU5Mg0KOTc4MTMxNTgxMTM3Ng0KOTc4MDIwMzA3NDc4Nw0KOTc4MDIwMzgyNTM2NQ0KOTc4MDIwMzg1MzkxNw0KOTc4MTMxNTg3ODYyMQ0KOTc4MTQxMDYwNTcyNg0KOTc4MTMxNTg4MzI1MA0KOTc4MDIwMzM1OTIxMQ0KOTc4MDIwMzYzNDExMA0KOTc4MDIwMzA4NzA4NA0KOTc4MDIwMzEzNDI2OQ0KOTc4MDIwMzEyOTIxMA0KOTc4MDIwMzk2MDYxNQ0KOTc4MDIwMzEwMDgzNw0KOTc4MTMxNTAxMDYwMQ0KOTc4MDIwMzc5ODkxMQ0KOTc4MTMxNTUwODMzNw0KOTc4MTMxNTc1MjUyNQ0KOTc4MTMxNTgzMzA5NQ0KOTc4MDIwMzc5NzYzMQ0KOTc4MTMxNTY2ODg5NQ0KOTc4MTMxNTg0NzEyMg0KOTc4MTMxNTYzNDcwOA0KOTc4MTMxNTg4NDk3NA0KOTc4MTMxNTU4NjA2OQ0KOTc4MTMxNTcwNzMxMA0KOTc4MTMxNTU5OTgyMw0KOTc4MTMxNTU0OTExOA0KOTc4MTMxNTMxMzEzOQ0KOTc4MTMxNTYzNTA0MA0KOTc4MDIwMzEyMTU5Nw0KOTc4MDIwMzA4MzM0NQ0KOTc4MDIwMzAwNDY3OA0KOTc4MDIwMzE0ODI1OQ0KOTc4MTg0MzkyNjI5MA0KOTc4MDIwMzgzODM4OQ0KOTc4MTg0OTc3MDk5Ng0KOTc4MDIwMzEyNDc3Mg0KOTc4MDIwMzc3ODA0Mw0KOTc4MDA4MDU2MTA1OQ0KOTc4MTMxNTY5NjE2NA0KOTc4MTMxNTY4MDczNg0KOTc4MTMxNTY1NjgxNg0KOTc4MTMxNTY0MzQ0MQ0KOTc4MTMxNTg4MTk0Mg0KOTc4MTMxNTA3MDgyNw0KOTc4MTMxNTA2NDUyOQ0KOTc4MTMxNTc3ODk4Mw0KOTc4MTMxNTYzMjU5OQ0KOTc4MDIwMzkzMDMxMQ0KOTc4MTQxMDYwMzI4OQ0KOTc4MTMxNTc5NzkwOA0KOTc4MTMxNTgxNTAwOA0KOTc4MTMxNTgxNTExNA0KOTc4MDIwMzMzNzA1OQ0KOTc4MDIwMzM1OTI1OQ0KOTc4MDIwMzQ4Njk1NQ0KOTc4MDIwMzY0MTUzOA0KOTc4MDIwMzYyNTAyNg0KOTc4MDIwMzk0NjM1MA0KOTc4MDIwMzk5Njc1MQ0KOTc4MDIwMzg5NDkzNA0KOTc4MDIwMzM5MTI5Nw0KOTc4MDIwMzA5ODUzMA0KOTc4MTMxNTc3NzM2OA0KOTc4MTMxNTg0NjkzNA0KOTc4MDIwMzQyNDMxNQ0KOTc4MDIwMzgwNzIyNA0KOTc4MDIwMzgzMzc1OQ0KOTc4MDIwMzEwMzAyOQ0KOTc4MDIwMzEwNjI0Mg0KOTc4MDIwMzcxODE5Mw0KOTc4MDA4MDQ4OTgyNw0KOTc4MTMxNTU4MjIzOA0KOTc4MDIwMzg0NTE5Ng0KOTc4MTMxNTYyMzc0MA0KOTc4MTMxNTc5MTk1MQ0KOTc4MTMxNTg0MDQxMw0KOTc4MTMxNTc3MTQ5Ng0KOTc4MTMxNTgyMDYyMA0KOTc4MTMxNTA2NzQzOA0KOTc4MTQxMDYwNTYxMA0KOTc4MDIwMzA2MjkwNg0KOTc4MTMxNTYyNjM5MA0KOTc4MTMxNTYyNjM3Ng0KOTc4MDIwMzkyOTg3Mg0KOTc4MTQyMDA0ODcwNA0KOTc4MTMxNTE1ODE2Nw0KOTc4MTMxNTg2ODMyNQ0KOTc4MTMxNTg4MTE3MQ0KOTc4MDIwMzc2NTI4OQ0KOTc4MTMxNTAxMzg2Mg0KOTc4MDIwMzcwNjA2MA0KOTc4MTg0MzkyNjg3MA0KOTc4MTMxNTY4Nzc1OQ0KOTc4MDIwMzg2MjE4Ng0KOTc4MDIwMzg0NDA2OQ0KOTc4MTMxNTY2MjQ3Mw0KOTc4MDIwMzA5NDMzNA0KOTc4MDIwMzAwMzEzOA0KOTc4MTMxNTgyNDgyNg0KOTc4MTMxNTg3ODU5MQ0KOTc4MTMxNTM3NTA5MA0KOTc4MTMxNTgzODc3OQ0KOTc4MTQxMDYwOTkwOA0KOTc4MTQxMDYwMTExNw0KOTc4MDIwMzk5NjM0OA0KOTc4MDIwMzY0NjIwNQ0KOTc4MTMxNTc2MDY3NA0KOTc4MDIwMzQyNzgxMQ0KOTc4MDIwMzM2MTQ4MQ0KOTc4MDIwMzE2OTMwOA0KOTc4MTMxNTAyODk2NQ0KOTc4MTMxNTg1ODAzNg0KOTc4MDIwMzUyOTMwMA0KOTc4MDIwMzc2Nzg3MA0KOTc4MTMxNTc5NjM5MA0KOTc4MTMxNTg4MTI1Ng0KOTc4MDIwMzcxNTkwMQ0KOTc4MDIwMzAyOTMzNg0KOTc4MTMxNTc4MDg5NA0KOTc4MTMxNTg0NTIwMw0KOTc4MTMxNTgwNjA4Mg0KOTc4MTg0MzkyOTY4MA0KOTc4MTg0MzkyNzE0Mw0KOTc4MDIwMzgwODQxMg0KOTc4MDIwMzEwMzcxNQ0KOTc4MDIwMzg2MzY1Nw0KOTc4MDIwMzg0Mzg0MA0KOTc4MTMxNTE3MzU3Mw0KOTc4MTMxNTU2NDAzNg0KOTc4MTMxNTYzMzE2OQ0KOTc4MTMxNTYzMzg3OQ0KOTc4MTMxNTcxMzY1Ng0KOTc4MTMxNTY4Njg0NA0KOTc4MTMxNTYyNTA0MQ0KOTc4MTMxNTYwNTM0MA0KOTc4MTMxNTgzNDY3Mg0KOTc4MTMxNTgyNzM1Mw0KOTc4MTMxNTgwMzUwMA0KOTc4MTMxNTg3Mjk0MA0KOTc4MDIwMzA4MTIxMQ0KOTc4MDIwMzcyMzQ0OQ0KOTc4MTMxNTc3Njk3Mg0KOTc4MTMxNTc3NTQ0OQ0KOTc4MTg0MzkyNDI1OA0KOTc4MDIwMzY5ODM0MQ0KOTc4MDIwMzYyNjYyNw0KOTc4MTMxNTcyMDIwMw0KOTc4MTMxNTU5Mzk0NA0KOTc4MTMxNTgzMzQ5MQ0KOTc4MTMxNTgwNDI0OA0KOTc4MTMxNTA0Mzc3Nw0KOTc4MTMxNTA3Mzc1MA0KOTc4MTMxNTA0NTQ4MQ0KOTc4MTMxNTA2NDQwNg0KOTc4MTMxNTY3MzkzNg0KOTc4MTQ4MjI2ODEzMw0KOTc4MTMxNTA0MDE3Mg0KOTc4MDIwMzg4MzAxMw0KOTc4MDIwMzUwODY0MA0KOTc4MDIwMzQwMzU1Ng0KOTc4MTMxNTYyMzQzNg0KOTc4MTMxNTEwNzA0Mg0KOTc4MDIwMzA4MzU4MQ0KOTc4MDIwMzA1MzQ3OA0KOTc4MDIwMzAxNDM2Mw0KOTc4MTMxNTgwMTQ0NQ0KOTc4MTMxNTc5MTY1NA0KOTc4MTMxNTcyNTQ2OA0KOTc4MTMxNTI2NjIwNg0KOTc4MTMxNTY5NzU3NA0KOTc4MDIwMzc2MjYwOA0KOTc4MTMxNTA2MjU3MA0KOTc4MDIwMzEyMjI0Mg0KOTc4MTQxMDYwMDE3Mg0KOTc4MDIwMzQ5ODU2OQ0KOTc4MDIwMzE5NzI3MQ0KOTc4MDIwMzEzMDE3OQ0KOTc4MDIwMzg5MTc1OQ0KOTc4MDIwMzk3NTU4OQ0KOTc4MTMxNTg4MzYyNQ0KOTc4MDIwMzQ4OTI0Ng0KOTc4MTMxNTg3NjQ4MQ0KOTc4MTMxNTI0ODkwNQ0KOTc4MTMxNTYzMDI1MA0KOTc4MTMxNTU2MTA3Mw0KOTc4MTMxNTAzNjc2Mg0KOTc4MTMxNTgxODIwNw0KOTc4MTMxNTgxNjQ3MA0KOTc4MDIwMzM0MTA0OQ0KOTc4MTMxNTgwMTIxNg0KOTc4MTMxNTYxODE0Mg0KOTc4MTg0OTc3NTYxOA0KOTc4MDIwMzEyMjQyNg0KOTc4MDIwMzA0ODUwNA0KOTc4MTMxNTAxMzk3OA0KOTc4MDIwMzgyOTI3MQ0KOTc4MDIwMzE1NDE1MQ0KOTc4MDA4MDQ2NDU5Ng0KOTc4MTMxNTcwMTAzNQ0KOTc4MTMxNTU5NDI3OQ0KOTc4MDIwMzgyOTEyNw0KOTc4MDIwMzA4MjE3MQ0KOTc4MTMxNTU3OTA0Nw0KOTc4MTMxNTIzMDc4OA0KOTc4MTMxNTcyNTYzNQ0KOTc4MDIwMzkzNDA2Nw0KOTc4MDIwMzkzNTUyMQ0KOTc4MDIwMzUwMDAyNg0KOTc4MDIwMzc3MjM2Mg0KOTc4MTQ4MjIxMDcyOQ0KOTc4MTg0OTc3NzA3MA0KOTc4MTg0MzE0MDQxMg0KOTc4MTQxMDYwOTEyMA0KOTc4MDIwMzkwNTI0MQ0KOTc4MDIwMzQzMzkzNQ0KOTc4MDIwMzQwNzQzMQ0KOTc4MDIwMzk5NjY1Mg0KOTc4MDIwMzQyNjMwMg0KOTc4MTMxNTU2NjEyMg0KOTc4MTMxNTcwODg1MA0KOTc4MTMxNTc0NTk2MQ0KOTc4MTMxNTc2NTcwOQ0KOTc4MTMxNTE5MTQ1NA0KOTc4MTMxNTU4NjAwNw0KOTc4MTMxNTY4NTI5OA0KOTc4MTMxNTc1MTU1OQ0KOTc4MTMxNTE5MzA1Mg0KOTc4MTMxNTgwNzU3Nw0KOTc4MTMxNTAwNzE3NQ0KOTc4MTMxNTAxODQyMw0KOTc4MTMxNTg1ODEwNA0KOTc4MTMxNTc5NTY0NQ0KOTc4MDIwMzEyMDY3NQ0KOTc4MDIwMzA1ODAwOA0KOTc4MDIwMzg0NTc0NQ0KOTc4MDIwMzgxNDcwMw0KOTc4MTg0MzkyNDU2Mg0KOTc4MTg0MzkyNDU0OA0KOTc4MTMxNTcyNDM1NQ0KOTc4MDIwMzQyNzc1MA0KOTc4MDIwMzY5NTUxNw0KOTc4MTMxNTgwMTE0OA0KOTc4MDIwMzEzMDY5OA0KOTc4MDIwMzgwMjE1MQ0KOTc4MDIwMzA1MDEwMQ0KOTc4MDIwMzgzMzk3MQ0KOTc4MTg0MzkyNjQ3NA0KOTc4MDIwMzg0MjE2NA0KOTc4MDIwMzg3Njg2Mg0KOTc4MTMxNTM5MDQ2OA0KOTc4MTMxNTY5NzUzNg0KOTc4MTMxNTcyMTIxNw0KOTc4MTMxNTczMTg1OA0KOTc4MTMxNTgzMjQ4Nw0KOTc4MTMxNTY3NzE4Nw0KOTc4MTMxNTYzNTk5Ng0KOTc4MTMxNTY3Mjc2Mg0KOTc4MDIwMzk5MTIxMw0KOTc4MDIwMzcxNTk4Nw0KOTc4MDIwMzc1OTU5Mg0KOTc4MDIwMzcwMDQ5NQ0KOTc4MTMxNTM4MTU2NQ0KOTc4MTMxNTc0NjM0MA0KOTc4MTMxNTc0MzQzMQ0KOTc4MTMxNTc2NzkzMg0KOTc4MTMxNTg4MzQyNw0KOTc4MTMxNTU3NDE4OQ0KOTc4MTQxMDYxMjAyMQ0KOTc4MDIwMzc3MzI5MQ0KOTc4MTMxNTgxNDQwNw0KOTc4MDIwMzkzNDAzNg0KOTc4MDIwMzg5NTE2MA0KOTc4MTMxNTAzNTY4MA0KOTc4MDIwMzk4NTAyMQ0KOTc4MTkzNjMzMTE5Mg0KOTc4MTMxNTY0NTY2Nw0KOTc4MDIwMzUzNTQ4Ng0KOTc4MDIwMzM1MDA1OA0KOTc4MDIwMzA0MDEwMg0KOTc4MTMxNTY0ODQ1Mw0KOTc4MTMxNTY0Nzk5OQ0KOTc4MTMxNTYwNzkwMA0KOTc4MTMxNTY5NzUyOQ0KOTc4MDIwMzc5MjM5MQ0KOTc4MTMxNTczMTU2OA0KOTc4MTMxNTQ3MjMzMQ0KOTc4MTMxNTU3MTI3MA0KOTc4MTMxNTU5OTg3OA0KOTc4MTMxNTU5Mjc1Ng0KOTc4MTMxNTU4MjA0Nw0KOTc4MDIwMzUxOTg1MQ0KOTc4MDIwMzM1Nzg0Mg0KOTc4MDIwMzExNDEzMQ0KOTc4MDIwMzA5NjYwNA0KOTc4MDIwMzA3MDg2NA0KOTc4MDIwMzg0NzM4MQ0KOTc4MDIwMzA5NTE5NQ0KOTc4MTMxNTU1MjI3OQ0KOTc4MTMxNTYwMDMyMQ0KOTc4MTMxNTcyNjA4Mw0KOTc4MTMxNTY3MjY1Ng0KOTc4MTMxNTI3MDk1MQ0KOTc4MTMxNTY4MzU0Ng0KOTc4MTMxNTY3MzQ3OQ0KOTc4MTg0MzE0NDUyNg0KOTc4MDIwMzk0NjIxMw0KOTc4MDIwMzQwMzYzMQ0KOTc4MDIwMzQ5NDA2Ng0KOTc4MDIwMzQ2NDY2Mw0KOTc4MDIwMzAxMjI3Nw0KOTc4MTMxNTgxMDY3Ng0KOTc4MTMxNTAzNTI1Mw0KOTc4MTMxNTU3ODQ3Nw0KOTc4MTMxNTY1OTY3MQ0KOTc4MTMxNTg3NzQyNg0KOTc4MDIwMzM0MTM3Nw0KOTc4MTMxNTg1Mjk3Mw0KOTc4MTMxNTc5ODYzOQ0KOTc4MTMxNTAxODk1OQ0KOTc4MDIwMzAwNTk0MQ0KOTc4MDIwMzc2NTkxMw0KOTc4MTMxNTYyODcxNA0KOTc4MDIwMzcyNTM2OA0KOTc4MDIwMzcyNDI0OA0KOTc4MTMxNTY3MzM4Nw0KOTc4MTg0MzkyNDY4NQ0KOTc4MDIwMzgzMDIyMg0KOTc4MTMxNTcxMTQ2MQ0KOTc4MTMxNTQ2MjI1Nw0KOTc4MTMxNTMxMTk3NQ0KOTc4MTMxNTM3MDI2Mg0KOTc4MTMxNTczNzYwNw0KOTc4MTQ4MjI5NDk2NQ0KOTc4MDIwMzIyMDUxMQ0KOTc4MDIwMzg4NDU2MA0KOTc4MDIwMzk3OTU1Ng0KOTc4MDIwMzM4ODMxMA0KOTc4MDA4MDU0NDM1OQ0KOTc4MDIwMzgwOTQ3MQ0KOTc4MTg0OTc3MDIxNw0KOTc4MTg0OTc3MzA0MQ0KOTc4MDIwMzg1MDQ3Mw0KOTc4MTMxNTM3NDIzOQ0KOTc4MTMxNTc0NzQ3Nw0KOTc4MTMxNTgxMDU0Ng0KOTc4MTMxNTgzMDI0Nw0KOTc4MTMxNTY4MTAxNg0KOTc4MDIwMzA4NTI0MA0KOTc4MTQxMDYwODc5Ng0KOTc4MDIwMzM4MzE3OQ0KOTc4MDIwMzQyNzgzNQ0KOTc4MDIwMzQxMTA3MA0KOTc4MDIwMzQ4NjI1Mg0KOTc4MDIwMzAwNDIwMw0KOTc4MTMxNTAyNzE0Mg0KOTc4MDIwMzM4ODU1Ng0KOTc4MDIwMzAzNzI4Nw0KOTc4MDIwMzAzOTIwNQ0KOTc4MTMxNTU0MjY0NQ0KOTc4MDIwMzE0NTQ3MA0KOTc4MDIwMzQyMzA5Nw0KOTc4MDIwMzQ0OTIxOQ0KOTc4MDIwMzAwMzYyNg0KOTc4MDIwMzg4Mjc0MA0KOTc4MDIwMzk4OTk4Mg0KOTc4MDIwMzkyOTAwMQ0KOTc4MDIwMzAxNjE2OQ0KOTc4MTMxNTgxNzU1Mg0KOTc4MTMxNTgyOTE5Nw0KOTc4MDIwMzc3Njk2NA0KOTc4MDA4MDQ3ODQ0OQ0KOTc4MDIwMzE1NTEzNA0KOTc4MTMxNTc3MzM2MA0KOTc4MTMxNTc3MjYwOA0KOTc4MTMxNTcxMDMwMw0KOTc4MDIwMzg3Njk4NQ0KOTc4MTMxNTgyODkxNg0KOTc4MTMxNTYwMDIxNQ0KOTc4MTMxNTcwMTMyNQ0KOTc4MTMxNTcwNjkyNA0KOTc4MTMxNTI1NTc5OA0KOTc4MTMxNTIzNjQyMQ0KOTc4MDIwMzczMTMyMQ0KOTc4MDIwMzQ3MDA2MA0KOTc4MTMxNTU3ODM3OA0KOTc4MTQxMDYwODg0MA0KOTc4MTMxNTAxMTczOA0KOTc4MTMxNTAxMTkzNg0KOTc4MTMxNTAxMjYwNQ0KOTc4MTMxNTAyODk3Mg0KOTc4MTMxNTc3MDA5Mw0KOTc4MTMxNTE3OTUzNw0KOTc4MTMxNTE2NTAzNQ0KOTc4MTMxNTE2MjE0MA0KOTc4MTQxMDYwMjYxOQ0KOTc4MTQxMDYwMjU0MQ0KOTc4MDIwMzQyNjU4Ng0KOTc4MDIwMzY0MTgxMQ0KOTc4MDIwMzA0MjYzMg0KOTc4MDIwMzM5MDYwMw0KOTc4MDIwMzUwNjczOA0KOTc4MDIwMzAzNjY3OQ0KOTc4MDIwMzAzNjgxNQ0KOTc4MDIwMzM1ODM5OQ0KOTc4MTMxNTgyNDk4Nw0KOTc4MDIwMzgxNDEyMw0KOTc4MTMxNTg3NDk5OQ0KOTc4MTMxNTY2MTQxNA0KOTc4MDIwMzEwOTM1OQ0KOTc4MTMxNTAyOTE5MQ0KOTc4MDIwMzg2ODk1OQ0KOTc4MDQxNTg4OTQ1Mg0KOTc4MDIwMzgxODU4OQ0KOTc4MDIwMzgwNDU4Mg0KOTc4MTMxNTYxMDUzNQ0KOTc4MTMxNTYwNzI0NQ0KOTc4MTMxNTg0MDE1NA0KOTc4MDA4MDUxNzQ5MA0KOTc4MDIwMzExNzU5MA0KOTc4MDIwMzAyMjIyMQ0KOTc4MDA4MDU3Mzk2MA0KOTc4MTMxNTY2MTk0MA0KOTc4MDIwMzg3Mzg0Nw0KOTc4MDIwMzg4ODA3MA0KOTc4MDIwMzg3MjgxOQ0KOTc4MDIwMzg3NDQ5Mw0KOTc4MTMxNTgzODkyMg0KOTc4MTMxNTU5NTg3MA0KOTc4MTMxNTU2ODI2Mw0KOTc4MTMxNTQ3MzQxMw0KOTc4MTMxNTU2NjgxOA0KOTc4MTMxNTY4OTM0MA0KOTc4MTMxNTc2NTQ3MQ0KOTc4MTMxNTgzOTMzMg0KOTc4MTMxNTg0MTAxNA0KOTc4MTMxNTc2OTMzMg0KOTc4MTMxNTg3NTk5Ng0KOTc4MDIwMzQyNDc3Mw0KOTc4MDIwMzQyNzMzMA0KOTc4MDIwMzIwMzY4Mg0KOTc4MDIwMzAyOTI3NQ0KOTc4MDIwMzAyOTYxOQ0KOTc4MDIwMzQ4MTU2MQ0KOTc4MDIwMzEyOTkwNg0KOTc4MDIwMzUwODk1NA==';
            fld=TF_PPDProcessController.addListOfPrductsViaFile(newParentProduct3.id,'MTk3OQ==','ISBN','Rule Based','Exclude');
        fld=TF_PPDProcessController.addListOfPrductsViaFile(newParentProduct3.id,encode,'ISBN','Rule Based','Exclude');
        String encodeLarge='MDF0MFkwMDAwMDcySTNkUUFFDQowMXQwWTAwMDAwNzJJUTNRQU0NCjAxdDBZMDAwMDA3MklyNVFBRQ0KMDF0MFkwMDAwMDcySXI2UUFFDQowMXQwWTAwMDAwNzJJd0RRQVUNCjAxdDBZMDAwMDA3Mko3c1FBRQ0KMDF0MFkwMDAwMDcySjd0UUFFDQowMXQwWTAwMDAwNzJKRVNRQTINCjAxdDBZMDAwMDA3MkpFVVFBMg0KMDF0MFkwMDAwMDcySkVWUUEyDQowMXQwWTAwMDAwNzJKRVhRQTINCjAxdDBZMDAwMDA3MkpFYlFBTQ0KMDF0MFkwMDAwMDcySkVwUUFNDQowMXQwWTAwMDAwNzJKRXdRQU0NCjAxdDBZMDAwMDA3MkpGMlFBTQ0KMDF0MFkwMDAwMDcySkY2UUFNDQowMXQwWTAwMDAwNzJKRkFRQTINCjAxdDBZMDAwMDA3MkpGSlFBMg0KMDF0MFkwMDAwMDcySkZRUUEyDQowMXQwWTAwMDAwNzJKRlZRQTINCjAxdDBZMDAwMDA3MkpGV1FBMg0KMDF0MFkwMDAwMDcySkZkUUFNDQowMXQwWTAwMDAwNzJKRm9RQU0NCjAxdDBZMDAwMDA3MkpGcVFBTQ0KMDF0MFkwMDAwMDcySkZyUUFNDQowMXQwWTAwMDAwNzJKRnNRQU0NCjAxdDBZMDAwMDA3MkpGd1FBTQ0KMDF0MFkwMDAwMDcySkdBUUEyDQowMXQwWTAwMDAwNzJKR2NRQU0NCjAxdDBZMDAwMDA3MkpHZVFBTQ0KMDF0MFkwMDAwMDcySkdoUUFNDQowMXQwWTAwMDAwNzJKR21RQU0NCjAxdDBZMDAwMDA3MkpHd1FBTQ0KMDF0MFkwMDAwMDcySkhOUUEyDQowMXQwWTAwMDAwNzJKSFRRQTINCjAxdDBZMDAwMDA3MkpIWVFBMg0KMDF0MFkwMDAwMDcySkhrUUFNDQowMXQwWTAwMDAwNzJKSG9RQU0NCjAxdDBZMDAwMDA3MkpIcFFBTQ0KMDF0MFkwMDAwMDcySklCUUEyDQowMXQwWTAwMDAwNzJKSUhRQTINCjAxdDBZMDAwMDA3MkpJUFFBMg0KMDF0MFkwMDAwMDcySklWUUEyDQowMXQwWTAwMDAwNzJKSVhRQTINCjAxdDBZMDAwMDA3MkpKMFFBTQ0KMDF0MFkwMDAwMDcySkoyUUFNDQowMXQwWTAwMDAwNzJKSjhRQU0NCjAxdDBZMDAwMDA3MkpKQlFBMg0KMDF0MFkwMDAwMDcySkpkUUFNDQowMXQwWTAwMDAwNzJKSmxRQU0NCjAxdDBZMDAwMDA3MkpKbVFBTQ0KMDF0MFkwMDAwMDcySkp3UUFNDQowMXQwWTAwMDAwNzJKSnhRQU0NCjAxdDBZMDAwMDA3MkpKelFBTQ0KMDF0MFkwMDAwMDcySkszUUFNDQowMXQwWTAwMDAwNzJKSzlRQU0NCjAxdDBZMDAwMDA3MkpLQVFBMg0KMDF0MFkwMDAwMDcySktEUUEyDQowMXQwWTAwMDAwNzJKS0lRQTINCjAxdDBZMDAwMDA3MkpLTVFBMg0KMDF0MFkwMDAwMDcySktZUUEyDQowMXQwWTAwMDAwNzJKS2tRQU0NCjAxdDBZMDAwMDA3MkpLbFFBTQ0KMDF0MFkwMDAwMDcySktvUUFNDQowMXQwWTAwMDAwNzJKTENRQTINCjAxdDBZMDAwMDA3MkpMRlFBMg0KMDF0MFkwMDAwMDcySkxJUUEyDQowMXQwWTAwMDAwNzJKTEtRQTINCjAxdDBZMDAwMDA3MkpMTlFBMg0KMDF0MFkwMDAwMDcySkxPUUEyDQowMXQwWTAwMDAwNzJKTFBRQTINCjAxdDBZMDAwMDA3MkpMUlFBMg0KMDF0MFkwMDAwMDcySkxUUUEyDQowMXQwWTAwMDAwNzJKTFVRQTINCjAxdDBZMDAwMDA3MkpMcVFBTQ0KMDF0MFkwMDAwMDcySkx3UUFNDQowMXQwWTAwMDAwNzJKTHlRQU0NCjAxdDBZMDAwMDA3MkpMelFBTQ0KMDF0MFkwMDAwMDcySk00UUFNDQowMXQwWTAwMDAwNzJKTTdRQU0NCjAxdDBZMDAwMDA3MkpNQVFBMg0KMDF0MFkwMDAwMDcySk1FUUEyDQowMXQwWTAwMDAwNzJKTUtRQTINCjAxdDBZMDAwMDA3MkpNT1FBMg0KMDF0MFkwMDAwMDcySk1kUUFNDQowMXQwWTAwMDAwNzJKTWlRQU0NCjAxdDBZMDAwMDA3MkpNblFBTQ0KMDF0MFkwMDAwMDcySk13UUFNDQowMXQwWTAwMDAwNzJKTXlRQU0NCjAxdDBZMDAwMDA3MkpNelFBTQ0KMDF0MFkwMDAwMDcySk4xUUFNDQowMXQwWTAwMDAwNzJKTjRRQU0NCjAxdDBZMDAwMDA3MkpOSlFBMg0KMDF0MFkwMDAwMDcySk5NUUEyDQowMXQwWTAwMDAwNzJKTk5RQTINCjAxdDBZMDAwMDA3MkpOUlFBMg0KMDF0MFkwMDAwMDcySk5WUUEyDQowMXQwWTAwMDAwNzJKTldRQTINCjAxdDBZMDAwMDA3MkpOY1FBTQ0KMDF0MFkwMDAwMDcySk5nUUFNDQowMXQwWTAwMDAwNzJKTm1RQU0NCjAxdDBZMDAwMDA3MkpOdlFBTQ0KMDF0MFkwMDAwMDcySk9DUUEyDQowMXQwWTAwMDAwNzJKT0tRQTINCjAxdDBZMDAwMDA3MkpPTFFBMg0KMDF0MFkwMDAwMDcySk9OUUEyDQowMXQwWTAwMDAwNzJKT1BRQTINCjAxdDBZMDAwMDA3MkpPUlFBMg0KMDF0MFkwMDAwMDcySk9jUUFNDQowMXQwWTAwMDAwNzJKT2hRQU0NCjAxdDBZMDAwMDA3MkpPalFBTQ0KMDF0MFkwMDAwMDcySk9rUUFNDQowMXQwWTAwMDAwNzJKT2xRQU0NCjAxdDBZMDAwMDA3MkpPblFBTQ0KMDF0MFkwMDAwMDcySk9vUUFNDQowMXQwWTAwMDAwNzJKT3BRQU0NCjAxdDBZMDAwMDA3MkpPcVFBTQ0KMDF0MFkwMDAwMDcySk93UUFNDQowMXQwWTAwMDAwNzJKT3lRQU0NCjAxdDBZMDAwMDA3MkpQMFFBTQ0KMDF0MFkwMDAwMDcySlAzUUFNDQowMXQwWTAwMDAwNzJKUDZRQU0NCjAxdDBZMDAwMDA3MkpQQVFBMg0KMDF0MFkwMDAwMDcySlBCUUEyDQowMXQwWTAwMDAwNzJKUEtRQTINCjAxdDBZMDAwMDA3MkpQTFFBMg0KMDF0MFkwMDAwMDcySlBOUUEyDQowMXQwWTAwMDAwNzJKUFNRQTINCjAxdDBZMDAwMDA3MkpQVFFBMg0KMDF0MFkwMDAwMDcySlBVUUEyDQowMXQwWTAwMDAwNzJKUFZRQTINCjAxdDBZMDAwMDA3MkpQWFFBMg0KMDF0MFkwMDAwMDcySlBvUUFNDQowMXQwWTAwMDAwNzJKUHZRQU0NCjAxdDBZMDAwMDA3MkpRNlFBTQ0KMDF0MFkwMDAwMDcySlFBUUEyDQowMXQwWTAwMDAwNzJKUUNRQTINCjAxdDBZMDAwMDA3MkpRRFFBMg0KMDF0MFkwMDAwMDcySlFHUUEyDQowMXQwWTAwMDAwNzJKUU9RQTINCjAxdDBZMDAwMDA3MkpRVFFBMg0KMDF0MFkwMDAwMDcySlFaUUEyDQowMXQwWTAwMDAwNzJKUWFRQU0NCjAxdDBZMDAwMDA3MkpRZFFBTQ0KMDF0MFkwMDAwMDcySlF2UUFNDQowMXQwWTAwMDAwNzJKUjNRQU0NCjAxdDBZMDAwMDA3MkpSQVFBMg0KMDF0MFkwMDAwMDcySlJKUUEyDQowMXQwWTAwMDAwNzJKUktRQTINCjAxdDBZMDAwMDA3MkpSUFFBMg0KMDF0MFkwMDAwMDcySlJRUUEyDQowMXQwWTAwMDAwNzJKUlRRQTINCjAxdDBZMDAwMDA3MkpSalFBTQ0KMDF0MFkwMDAwMDcySlJvUUFNDQowMXQwWTAwMDAwNzJKUnlRQU0NCjAxdDBZMDAwMDA3MkpTMFFBTQ0KMDF0MFkwMDAwMDcySlMxUUFNDQowMXQwWTAwMDAwNzJKUzJRQU0NCjAxdDBZMDAwMDA3MkpTM1FBTQ0KMDF0MFkwMDAwMDcySlNGUUEyDQowMXQwWTAwMDAwNzJKU0pRQTINCjAxdDBZMDAwMDA3MkpTYlFBTQ0KMDF0MFkwMDAwMDcySlNlUUFNDQowMXQwWTAwMDAwNzJKU2ZRQU0NCjAxdDBZMDAwMDA3MkpUNFFBTQ0KMDF0MFkwMDAwMDcySlQ5UUFNDQowMXQwWTAwMDAwNzJKVEJRQTINCjAxdDBZMDAwMDA3MkpUZFFBTQ0KMDF0MFkwMDAwMDcySlRnUUFNDQowMXQwWTAwMDAwNzJKVGtRQU0NCjAxdDBZMDAwMDA3MkpUclFBTQ0KMDF0MFkwMDAwMDcySlR0UUFNDQowMXQwWTAwMDAwNzJKVHhRQU0NCjAxdDBZMDAwMDA3MkpVMVFBTQ0KMDF0MFkwMDAwMDcySlUyUUFNDQowMXQwWTAwMDAwNzJKVTVRQU0NCjAxdDBZMDAwMDA3MkpVN1FBTQ0KMDF0MFkwMDAwMDcySlU4UUFNDQowMXQwWTAwMDAwNzJKVTlRQU0NCjAxdDBZMDAwMDA3MkpVQlFBMg0KMDF0MFkwMDAwMDcySlVEUUEyDQowMXQwWTAwMDAwNzJKVUhRQTINCjAxdDBZMDAwMDA3MkpVSlFBMg0KMDF0MFkwMDAwMDcySlVQUUEyDQowMXQwWTAwMDAwNzJKVVRRQTINCjAxdDBZMDAwMDA3MkpVWlFBMg0KMDF0MFkwMDAwMDcySlVkUUFNDQowMXQwWTAwMDAwNzJKVWlRQU0NCjAxdDBZMDAwMDA3MkpVa1FBTQ0KMDF0MFkwMDAwMDcySlVvUUFNDQowMXQwWTAwMDAwNzJKVXZRQU0NCjAxdDBZMDAwMDA3MkpVeVFBTQ0KMDF0MFkwMDAwMDcySlYwUUFNDQowMXQwWTAwMDAwNzJKVjVRQU0NCjAxdDBZMDAwMDA3MkpWN1FBTQ0KMDF0MFkwMDAwMDcySlZDUUEyDQowMXQwWTAwMDAwNzJKVkRRQTINCjAxdDBZMDAwMDA3MkpWRlFBMg0KMDF0MFkwMDAwMDcySlZJUUEyDQowMXQwWTAwMDAwNzJKVkxRQTINCjAxdDBZMDAwMDA3MkpWTlFBMg0KMDF0MFkwMDAwMDcySlZRUUEyDQowMXQwWTAwMDAwNzJKVlNRQTINCjAxdDBZMDAwMDA3MkpWVlFBMg0KMDF0MFkwMDAwMDcySlZiUUFNDQowMXQwWTAwMDAwNzJKVmNRQU0NCjAxdDBZMDAwMDA3MkpWZ1FBTQ0KMDF0MFkwMDAwMDcySlZ0UUFNDQowMXQwWTAwMDAwNzJKVnpRQU0NCjAxdDBZMDAwMDA3MkpXMFFBTQ0KMDF0MFkwMDAwMDcySlcyUUFNDQowMXQwWTAwMDAwNzJKVzNRQU0NCjAxdDBZMDAwMDA3MkpXNFFBTQ0KMDF0MFkwMDAwMDcySlc3UUFNDQowMXQwWTAwMDAwNzJKVzlRQU0NCjAxdDBZMDAwMDA3MkpXRFFBMg0KMDF0MFkwMDAwMDcySldFUUEyDQowMXQwWTAwMDAwNzJKV2hRQU0NCjAxdDBZMDAwMDA3MkpXaVFBTQ0KMDF0MFkwMDAwMDcySldqUUFNDQowMXQwWTAwMDAwNzJKWDBRQU0NCjAxdDBZMDAwMDA3MkpYNlFBTQ0KMDF0MFkwMDAwMDcySlhFUUEyDQowMXQwWTAwMDAwNzJKWEZRQTINCjAxdDBZMDAwMDA3MkpYR1FBMg0KMDF0MFkwMDAwMDcySlhIUUEyDQowMXQwWTAwMDAwNzJKWElRQTINCjAxdDBZMDAwMDA3MkpYYlFBTQ0KMDF0MFkwMDAwMDcySlhyUUFNDQowMXQwWTAwMDAwNzJKWHNRQU0NCjAxdDBZMDAwMDA3MkpYd1FBTQ0KMDF0MFkwMDAwMDcySlh6UUFNDQowMXQwWTAwMDAwNzJKWTFRQU0NCjAxdDBZMDAwMDA3MkpZQlFBMg0KMDF0MFkwMDAwMDcySllTUUEyDQowMXQwWTAwMDAwNzJKWVRRQTINCjAxdDBZMDAwMDA3MkpZV1FBMg0KMDF0MFkwMDAwMDcySllZUUEyDQowMXQwWTAwMDAwNzJKWVpRQTINCjAxdDBZMDAwMDA3MkpZa1FBTQ0KMDF0MFkwMDAwMDcySllxUUFNDQowMXQwWTAwMDAwNzJKWXNRQU0NCjAxdDBZMDAwMDA3MkpaMFFBTQ0KMDF0MFkwMDAwMDcySlo3UUFNDQowMXQwWTAwMDAwNzJKWkRRQTINCjAxdDBZMDAwMDA3MkpaRlFBMg0KMDF0MFkwMDAwMDcySlpHUUEyDQowMXQwWTAwMDAwNzJKWkhRQTINCjAxdDBZMDAwMDA3MkpaSlFBMg0KMDF0MFkwMDAwMDcySlpLUUEyDQowMXQwWTAwMDAwNzJKWlFRQTINCjAxdDBZMDAwMDA3MkpaUlFBMg0KMDF0MFkwMDAwMDcySlpVUUEyDQowMXQwWTAwMDAwNzJKWldRQTINCjAxdDBZMDAwMDA3MkpaZVFBTQ0KMDF0MFkwMDAwMDcySlpoUUFNDQowMXQwWTAwMDAwNzJKWmlRQU0NCjAxdDBZMDAwMDA3MkpaalFBTQ0KMDF0MFkwMDAwMDcySlp0UUFNDQowMXQwWTAwMDAwNzJKYTFRQUUNCjAxdDBZMDAwMDA3MkphNVFBRQ0KMDF0MFkwMDAwMDcySmE2UUFFDQowMXQwWTAwMDAwNzJKYTdRQUUNCjAxdDBZMDAwMDA3MkphQlFBVQ0KMDF0MFkwMDAwMDcySmFGUUFVDQowMXQwWTAwMDAwNzJKYXpRQUUNCjAxdDBZMDAwMDA3MkpiMVFBRQ0KMDF0MFkwMDAwMDcySmIyUUFFDQowMXQwWTAwMDAwNzJKYkNRQVUNCjAxdDBZMDAwMDA3MkpiRFFBVQ0KMDF0MFkwMDAwMDcySmJFUUFVDQowMXQwWTAwMDAwNzJKYmJRQUUNCjAxdDBZMDAwMDA3MkpiZVFBRQ0KMDF0MFkwMDAwMDcySmJnUUFFDQowMXQwWTAwMDAwNzJKYnBRQUUNCjAxdDBZMDAwMDA3MkpicVFBRQ0KMDF0MFkwMDAwMDcySmJ0UUFFDQowMXQwWTAwMDAwNzJKYnlRQUUNCjAxdDBZMDAwMDA3MkpjMlFBRQ0KMDF0MFkwMDAwMDcySmNIUUFVDQowMXQwWTAwMDAwNzJKY0lRQVUNCjAxdDBZMDAwMDA3MkpjVlFBVQ0KMDF0MFkwMDAwMDcySmNaUUFVDQowMXQwWTAwMDAwNzJKY2FRQUUNCjAxdDBZMDAwMDA3MkpjZVFBRQ0KMDF0MFkwMDAwMDcySmNpUUFFDQowMXQwWTAwMDAwNzJKY2tRQUUNCjAxdDBZMDAwMDA3MkpjcVFBRQ0KMDF0MFkwMDAwMDcySmN0UUFFDQowMXQwWTAwMDAwNzJKY3VRQUUNCjAxdDBZMDAwMDA3MkpjeFFBRQ0KMDF0MFkwMDAwMDcySmQ3UUFFDQowMXQwWTAwMDAwNzJKZDhRQUUNCjAxdDBZMDAwMDA3MkpkOVFBRQ0KMDF0MFkwMDAwMDcySmRDUUFVDQowMXQwWTAwMDAwNzJKZERRQVUNCjAxdDBZMDAwMDA3MkpkRlFBVQ0KMDF0MFkwMDAwMDcySmRHUUFVDQowMXQwWTAwMDAwNzJKZFNRQVUNCjAxdDBZMDAwMDA3MkpkWlFBVQ0KMDF0MFkwMDAwMDcySmRhUUFFDQowMXQwWTAwMDAwNzJKZGRRQUUNCjAxdDBZMDAwMDA3MkpkZ1FBRQ0KMDF0MFkwMDAwMDcySmRqUUFFDQowMXQwWTAwMDAwNzJKZHRRQUUNCjAxdDBZMDAwMDA3MkpkdlFBRQ0KMDF0MFkwMDAwMDcySmUyUUFFDQowMXQwWTAwMDAwNzJKZUpRQVUNCjAxdDBZMDAwMDA3MkplS1FBVQ0KMDF0MFkwMDAwMDcySmVOUUFVDQowMXQwWTAwMDAwNzJKZU9RQVUNCjAxdDBZMDAwMDA3MkplVlFBVQ0KMDF0MFkwMDAwMDcySmVYUUFVDQowMXQwWTAwMDAwNzJKZWJRQUUNCjAxdDBZMDAwMDA3MkplblFBRQ0KMDF0MFkwMDAwMDcySmVwUUFFDQowMXQwWTAwMDAwNzJKZXNRQUUNCjAxdDBZMDAwMDA3MkpmUFFBVQ0KMDF0MFkwMDAwMDcySmZUUUFVDQowMXQwWTAwMDAwNzJKZldRQVUNCjAxdDBZMDAwMDA3MkpmWFFBVQ0KMDF0MFkwMDAwMDcySmZjUUFFDQowMXQwWTAwMDAwNzJKZmRRQUUNCjAxdDBZMDAwMDA3MkpmZlFBRQ0KMDF0MFkwMDAwMDcySmZoUUFFDQowMXQwWTAwMDAwNzJKZmtRQUUNCjAxdDBZMDAwMDA3MkpmbVFBRQ0KMDF0MFkwMDAwMDcySmdKUUFVDQowMXQwWTAwMDAwNzJKZ1pRQVUNCjAxdDBZMDAwMDA3MkpnYVFBRQ0KMDF0MFkwMDAwMDcySmdoUUFFDQowMXQwWTAwMDAwNzJKZ2lRQUUNCjAxdDBZMDAwMDA3MkpnbVFBRQ0KMDF0MFkwMDAwMDcySmdvUUFFDQowMXQwWTAwMDAwNzJKZ3NRQUUNCjAxdDBZMDAwMDA3Mkpnd1FBRQ0KMDF0MFkwMDAwMDcySmd5UUFFDQowMXQwWTAwMDAwNzJKZ3pRQUUNCjAxdDBZMDAwMDA3MkpoMFFBRQ0KMDF0MFkwMDAwMDcySmg3UUFFDQowMXQwWTAwMDAwNzJKaEhRQVUNCjAxdDBZMDAwMDA3MkpoS1FBVQ0KMDF0MFkwMDAwMDcySmhPUUFVDQowMXQwWTAwMDAwNzJKaFFRQVUNCjAxdDBZMDAwMDA3MkpoVFFBVQ0KMDF0MFkwMDAwMDcySmhhUUFFDQowMXQwWTAwMDAwNzJKaGRRQUUNCjAxdDBZMDAwMDA3MkpoZVFBRQ0KMDF0MFkwMDAwMDcySmhmUUFFDQowMXQwWTAwMDAwNzJKaGdRQUUNCjAxdDBZMDAwMDA3MkpobVFBRQ0KMDF0MFkwMDAwMDcySmhuUUFFDQowMXQwWTAwMDAwNzJKaHdRQUUNCjAxdDBZMDAwMDA3MkpoelFBRQ0KMDF0MFkwMDAwMDcySmkwUUFFDQowMXQwWTAwMDAwNzJKaUdRQVUNCjAxdDBZMDAwMDA3MkppVFFBVQ0KMDF0MFkwMDAwMDcySmlVUUFVDQowMXQwWTAwMDAwNzJKaVhRQVUNCjAxdDBZMDAwMDA3MkppZFFBRQ0KMDF0MFkwMDAwMDcySmlnUUFFDQowMXQwWTAwMDAwNzJKaWlRQUUNCjAxdDBZMDAwMDA3MkppalFBRQ0KMDF0MFkwMDAwMDcySmluUUFFDQowMXQwWTAwMDAwNzJKajVRQUUNCjAxdDBZMDAwMDA3MkpqQ1FBVQ0KMDF0MFkwMDAwMDcySmpJUUFVDQowMXQwWTAwMDAwNzJKalJRQVUNCjAxdDBZMDAwMDA3MkpqWVFBVQ0KMDF0MFkwMDAwMDcySmphUUFFDQowMXQwWTAwMDAwNzJKamNRQUUNCjAxdDBZMDAwMDA3MkpqZFFBRQ0KMDF0MFkwMDAwMDcySmppUUFFDQowMXQwWTAwMDAwNzJKamxRQUUNCjAxdDBZMDAwMDA3Mkpqb1FBRQ0KMDF0MFkwMDAwMDcySmpxUUFFDQowMXQwWTAwMDAwNzJKanVRQUUNCjAxdDBZMDAwMDA3MkpqeFFBRQ0KMDF0MFkwMDAwMDcySmswUUFFDQowMXQwWTAwMDAwNzJKazFRQUUNCjAxdDBZMDAwMDA3MkprQlFBVQ0KMDF0MFkwMDAwMDcySmtGUUFVDQowMXQwWTAwMDAwNzJKa0dRQVUNCjAxdDBZMDAwMDA3MkprSFFBVQ0KMDF0MFkwMDAwMDcySmtNUUFVDQowMXQwWTAwMDAwNzJKa05RQVUNCjAxdDBZMDAwMDA3MkprT1FBVQ0KMDF0MFkwMDAwMDcySmtpUUFFDQowMXQwWTAwMDAwNzJKa25RQUUNCjAxdDBZMDAwMDA3MkprcFFBRQ0KMDF0MFkwMDAwMDcySmtxUUFFDQowMXQwWTAwMDAwNzJKa3NRQUUNCjAxdDBZMDAwMDA3MkpreVFBRQ0KMDF0MFkwMDAwMDcySmxmUUFFDQowMXQwWTAwMDAwNzJKbGdRQUUNCjAxdDBZMDAwMDA3MkpsaFFBRQ0KMDF0MFkwMDAwMDcySmxyUUFFDQowMXQwWTAwMDAwNzJKbHRRQUUNCjAxdDBZMDAwMDA3MkpseVFBRQ0KMDF0MFkwMDAwMDcySmx6UUFFDQowMXQwWTAwMDAwNzJKbThRQUUNCjAxdDBZMDAwMDA3MkptT1FBVQ0KMDF0MFkwMDAwMDcySm1RUUFVDQowMXQwWTAwMDAwNzJKbVZRQVUNCjAxdDBZMDAwMDA3MkptaVFBRQ0KMDF0MFkwMDAwMDcySm1tUUFFDQowMXQwWTAwMDAwNzJKbXdRQUUNCjAxdDBZMDAwMDA3MkpuMlFBRQ0KMDF0MFkwMDAwMDcySm5EUUFVDQowMXQwWTAwMDAwNzJKblFRQVUNCjAxdDBZMDAwMDA3MkpuVFFBVQ0KMDF0MFkwMDAwMDcySm5XUUFVDQowMXQwWTAwMDAwNzJKbllRQVUNCjAxdDBZMDAwMDA3MkpuY1FBRQ0KMDF0MFkwMDAwMDcySm5kUUFFDQowMXQwWTAwMDAwNzJKbmdRQUUNCjAxdDBZMDAwMDA3MkpuaFFBRQ0KMDF0MFkwMDAwMDcySm5pUUFFDQowMXQwWTAwMDAwNzJKbmxRQUUNCjAxdDBZMDAwMDA3Mkpub1FBRQ0KMDF0MFkwMDAwMDcySm5wUUFFDQowMXQwWTAwMDAwNzJKbnFRQUUNCjAxdDBZMDAwMDA3Mkpuc1FBRQ0KMDF0MFkwMDAwMDcySm51UUFFDQowMXQwWTAwMDAwNzJKbnZRQUUNCjAxdDBZMDAwMDA3Mkpud1FBRQ0KMDF0MFkwMDAwMDcySm56UUFFDQowMXQwWTAwMDAwNzJKbzdRQUUNCjAxdDBZMDAwMDA3MkpvOFFBRQ0KMDF0MFkwMDAwMDcySm9DUUFVDQowMXQwWTAwMDAwNzJKb0VRQVUNCjAxdDBZMDAwMDA3MkpvSFFBVQ0KMDF0MFkwMDAwMDcySm9KUUFVDQowMXQwWTAwMDAwNzJKb0tRQVUNCjAxdDBZMDAwMDA3MkpvTlFBVQ0KMDF0MFkwMDAwMDcySm9TUUFVDQowMXQwWTAwMDAwNzJKb2FRQUUNCjAxdDBZMDAwMDA3MkpvZVFBRQ0KMDF0MFkwMDAwMDcySm9oUUFFDQowMXQwWTAwMDAwNzJKb2lRQUUNCjAxdDBZMDAwMDA3MkpvdFFBRQ0KMDF0MFkwMDAwMDcySm91UUFFDQowMXQwWTAwMDAwNzJKcDFRQUUNCjAxdDBZMDAwMDA3MkpwN1FBRQ0KMDF0MFkwMDAwMDcySnBDUUFVDQowMXQwWTAwMDAwNzJKcFRRQVUNCjAxdDBZMDAwMDA3MkpwZFFBRQ0KMDF0MFkwMDAwMDcySnBlUUFFDQowMXQwWTAwMDAwNzJKcGZRQUUNCjAxdDBZMDAwMDA3MkpwaFFBRQ0KMDF0MFkwMDAwMDcySnB0UUFFDQowMXQwWTAwMDAwNzJKcHVRQUUNCjAxdDBZMDAwMDA3MkpweFFBRQ0KMDF0MFkwMDAwMDcySnE4UUFFDQowMXQwWTAwMDAwNzJKcVFRQVUNCjAxdDBZMDAwMDA3MkpxUlFBVQ0KMDF0MFkwMDAwMDcySnFZUUFVDQowMXQwWTAwMDAwNzJKcWRRQUUNCjAxdDBZMDAwMDA3Mkpxa1FBRQ0KMDF0MFkwMDAwMDcySnFsUUFFDQowMXQwWTAwMDAwNzJKcW1RQUUNCjAxdDBZMDAwMDA3MkpyMFFBRQ0KMDF0MFkwMDAwMDcySnIxUUFFDQowMXQwWTAwMDAwNzJKcjJRQUUNCjAxdDBZMDAwMDA3MkpyN1FBRQ0KMDF0MFkwMDAwMDcySnJEUUFVDQowMXQwWTAwMDAwNzJKckVRQVUNCjAxdDBZMDAwMDA3MkpySFFBVQ0KMDF0MFkwMDAwMDcySnJMUUFVDQowMXQwWTAwMDAwNzJKck1RQVUNCjAxdDBZMDAwMDA3MkpyUVFBVQ0KMDF0MFkwMDAwMDcySnJaUUFVDQowMXQwWTAwMDAwNzJKcmFRQUUNCjAxdDBZMDAwMDA3MkpyY1FBRQ0KMDF0MFkwMDAwMDcySnJlUUFFDQowMXQwWTAwMDAwNzJKcmdRQUUNCjAxdDBZMDAwMDA3MkpyeFFBRQ0KMDF0MFkwMDAwMDcySnJ6UUFFDQowMXQwWTAwMDAwNzJKczRRQUUNCjAxdDBZMDAwMDA3MkpzQVFBVQ0KMDF0MFkwMDAwMDcySnNDUUFVDQowMXQwWTAwMDAwNzJKc0VRQVUNCjAxdDBZMDAwMDA3MkpzSFFBVQ0KMDF0MFkwMDAwMDcySnNLUUFVDQowMXQwWTAwMDAwNzJKc01RQVUNCjAxdDBZMDAwMDA3MkpzT1FBVQ0KMDF0MFkwMDAwMDcySnNkUUFFDQowMXQwWTAwMDAwNzJKc2VRQUUNCjAxdDBZMDAwMDA3MkpzZlFBRQ0KMDF0MFkwMDAwMDcySnNpUUFFDQowMXQwWTAwMDAwNzJKc2pRQUUNCjAxdDBZMDAwMDA3MkpzcFFBRQ0KMDF0MFkwMDAwMDcySnNzUUFFDQowMXQwWTAwMDAwNzJKc3dRQUUNCjAxdDBZMDAwMDA3MkpzelFBRQ0KMDF0MFkwMDAwMDcySnQxUUFFDQowMXQwWTAwMDAwNzJKdDJRQUUNCjAxdDBZMDAwMDA3Mkp0V1FBVQ0KMDF0MFkwMDAwMDcySnRZUUFVDQowMXQwWTAwMDAwNzJKdFpRQVUNCjAxdDBZMDAwMDA3Mkp0Y1FBRQ0KMDF0MFkwMDAwMDcySnRlUUFFDQowMXQwWTAwMDAwNzJKdGdRQUUNCjAxdDBZMDAwMDA3Mkp0aFFBRQ0KMDF0MFkwMDAwMDcySnRwUUFFDQowMXQwWTAwMDAwNzJKdHRRQUUNCjAxdDBZMDAwMDA3Mkp1MFFBRQ0KMDF0MFkwMDAwMDcySnU2UUFFDQowMXQwWTAwMDAwNzJKdUVRQVUNCjAxdDBZMDAwMDA3Mkp1S1FBVQ0KMDF0MFkwMDAwMDcySnVNUUFVDQowMXQwWTAwMDAwNzJKdU5RQVUNCjAxdDBZMDAwMDA3Mkp1T1FBVQ0KMDF0MFkwMDAwMDcySnVQUUFVDQowMXQwWTAwMDAwNzJKdVFRQVUNCjAxdDBZMDAwMDA3Mkp1UlFBVQ0KMDF0MFkwMDAwMDcySnVTUUFVDQowMXQwWTAwMDAwNzJKdVRRQVUNCjAxdDBZMDAwMDA3Mkp1V1FBVQ0KMDF0MFkwMDAwMDcySnVaUUFVDQowMXQwWTAwMDAwNzJKdWRRQUUNCjAxdDBZMDAwMDA3Mkp1a1FBRQ0KMDF0MFkwMDAwMDcySnV0UUFFDQowMXQwWTAwMDAwNzJKdXhRQUUNCjAxdDBZMDAwMDA3Mkp2MlFBRQ0KMDF0MFkwMDAwMDcySnY1UUFFDQowMXQwWTAwMDAwNzJKdjhRQUUNCjAxdDBZMDAwMDA3Mkp2RVFBVQ0KMDF0MFkwMDAwMDcySnZPUUFVDQowMXQwWTAwMDAwNzJKdm5RQUUNCjAxdDBZMDAwMDA3Mkp2clFBRQ0KMDF0MFkwMDAwMDcySnZ1UUFFDQowMXQwWTAwMDAwNzJKdnZRQUUNCjAxdDBZMDAwMDA3Mkp3NFFBRQ0KMDF0MFkwMDAwMDcySnc5UUFFDQowMXQwWTAwMDAwNzJKd0hRQVUNCjAxdDBZMDAwMDA3Mkp3SlFBVQ0KMDF0MFkwMDAwMDcySndPUUFVDQowMXQwWTAwMDAwNzJKd1FRQVUNCjAxdDBZMDAwMDA3Mkp3UlFBVQ0KMDF0MFkwMDAwMDcySndjUUFFDQowMXQwWTAwMDAwNzJKd2lRQUUNCjAxdDBZMDAwMDA3Mkp3blFBRQ0KMDF0MFkwMDAwMDcySnd5UUFFDQowMXQwWTAwMDAwNzJKeDFRQUUNCjAxdDBZMDAwMDA3Mkp4RlFBVQ0KMDF0MFkwMDAwMDcySnhJUUFVDQowMXQwWTAwMDAwNzJKeExRQVUNCjAxdDBZMDAwMDA3Mkp4TVFBVQ0KMDF0MFkwMDAwMDcySnhZUUFVDQowMXQwWTAwMDAwNzJKeGNRQUUNCjAxdDBZMDAwMDA3Mkp4ZVFBRQ0KMDF0MFkwMDAwMDcySnhmUUFFDQowMXQwWTAwMDAwNzJKeGhRQUUNCjAxdDBZMDAwMDA3Mkp4aVFBRQ0KMDF0MFkwMDAwMDcySnhqUUFFDQowMXQwWTAwMDAwNzJKeG1RQUUNCjAxdDBZMDAwMDA3Mkp4cVFBRQ0KMDF0MFkwMDAwMDcySnh1UUFFDQowMXQwWTAwMDAwNzJKeHpRQUUNCjAxdDBZMDAwMDA3Mkp5ZFFBRQ0KMDF0MFkwMDAwMDcySnlxUUFFDQowMXQwWTAwMDAwNzJKeXVRQUUNCjAxdDBZMDAwMDA3Mkp6MFFBRQ0KMDF0MFkwMDAwMDcySnoxUUFFDQowMXQwWTAwMDAwNzJKejJRQUUNCjAxdDBZMDAwMDA3Mkp6M1FBRQ0KMDF0MFkwMDAwMDcySnpGUUFVDQowMXQwWTAwMDAwNzJKekhRQVUNCjAxdDBZMDAwMDA3Mkp6TVFBVQ0KMDF0MFkwMDAwMDcySnpOUUFVDQowMXQwWTAwMDAwNzJKek9RQVUNCjAxdDBZMDAwMDA3Mkp6UFFBVQ0KMDF0MFkwMDAwMDcySnpUUUFVDQowMXQwWTAwMDAwNzJKelpRQVUNCjAxdDBZMDAwMDA3Mkp6YVFBRQ0KMDF0MFkwMDAwMDcySnpiUUFFDQowMXQwWTAwMDAwNzJKemhRQUUNCjAxdDBZMDAwMDA3Mkp6dVFBRQ0KMDF0MFkwMDAwMDcySzAxUUFFDQowMXQwWTAwMDAwNzJLMDJRQUUNCjAxdDBZMDAwMDA3MkswNlFBRQ0KMDF0MFkwMDAwMDcySzA3UUFFDQowMXQwWTAwMDAwNzJLMEJRQVUNCjAxdDBZMDAwMDA3MkswRVFBVQ0KMDF0MFkwMDAwMDcySzBIUUFVDQowMXQwWTAwMDAwNzJLMExRQVUNCjAxdDBZMDAwMDA3MkswT1FBVQ0KMDF0MFkwMDAwMDcySzBQUUFVDQowMXQwWTAwMDAwNzJLMFpRQVUNCjAxdDBZMDAwMDA3MkswYVFBRQ0KMDF0MFkwMDAwMDcySzBlUUFFDQowMXQwWTAwMDAwNzJLMGlRQUUNCjAxdDBZMDAwMDA3MksweVFBRQ0KMDF0MFkwMDAwMDcySzEwUUFFDQowMXQwWTAwMDAwNzJLMTJRQUUNCjAxdDBZMDAwMDA3MksxM1FBRQ0KMDF0MFkwMDAwMDcySzFDUUFVDQowMXQwWTAwMDAwNzJLMUZRQVUNCjAxdDBZMDAwMDA3MksxT1FBVQ0KMDF0MFkwMDAwMDcySzFRUUFVDQowMXQwWTAwMDAwNzJLMVNRQVUNCjAxdDBZMDAwMDA3MksxYVFBRQ0KMDF0MFkwMDAwMDcySzFlUUFFDQowMXQwWTAwMDAwNzJLMWZRQUUNCjAxdDBZMDAwMDA3MksxbFFBRQ0KMDF0MFkwMDAwMDcySzF2UUFFDQowMXQwWTAwMDAwNzJLMXhRQUUNCjAxdDBZMDAwMDA3MksyMFFBRQ0KMDF0MFkwMDAwMDcySzIxUUFFDQowMXQwWTAwMDAwNzJLMjJRQUUNCjAxdDBZMDAwMDA3MksyM1FBRQ0KMDF0MFkwMDAwMDcySzI0UUFFDQowMXQwWTAwMDAwNzJLMkJRQVUNCjAxdDBZMDAwMDA3MksyQ1FBVQ0KMDF0MFkwMDAwMDcySzJJUUFVDQowMXQwWTAwMDAwNzJLMlBRQVUNCjAxdDBZMDAwMDA3MksyUVFBVQ0KMDF0MFkwMDAwMDcySzJZUUFVDQowMXQwWTAwMDAwNzJLMlpRQVUNCjAxdDBZMDAwMDA3MksyZlFBRQ0KMDF0MFkwMDAwMDcySzJwUUFFDQowMXQwWTAwMDAwNzJLMnFRQUUNCjAxdDBZMDAwMDA3MksydFFBRQ0KMDF0MFkwMDAwMDcySzJ5UUFFDQowMXQwWTAwMDAwNzJLMzBRQUUNCjAxdDBZMDAwMDA3MkszMVFBRQ0KMDF0MFkwMDAwMDcySzMyUUFFDQowMXQwWTAwMDAwNzJLMzVRQUUNCjAxdDBZMDAwMDA3MkszQ1FBVQ0KMDF0MFkwMDAwMDcySzNFUUFVDQowMXQwWTAwMDAwNzJLM0pRQVUNCjAxdDBZMDAwMDA3MkszTVFBVQ0KMDF0MFkwMDAwMDcySzNOUUFVDQowMXQwWTAwMDAwNzJLM3RRQUUNCjAxdDBZMDAwMDA3Mkszd1FBRQ0KMDF0MFkwMDAwMDcySzQ5UUFFDQowMXQwWTAwMDAwNzJLNENRQVUNCjAxdDBZMDAwMDA3Mks0RlFBVQ0KMDF0MFkwMDAwMDcySzRhUUFFDQowMXQwWTAwMDAwNzJLNGNRQUUNCjAxdDBZMDAwMDA3Mks0ZFFBRQ0KMDF0MFkwMDAwMDcySzRlUUFFDQowMXQwWTAwMDAwNzJLNGxRQUUNCjAxdDBZMDAwMDA3Mks0bVFBRQ0KMDF0MFkwMDAwMDcySzRuUUFFDQowMXQwWTAwMDAwNzJLNG9RQUUNCjAxdDBZMDAwMDA3Mks0cFFBRQ0KMDF0MFkwMDAwMDcySzR3UUFFDQowMXQwWTAwMDAwNzJLNHhRQUUNCjAxdDBZMDAwMDA3Mks0elFBRQ0KMDF0MFkwMDAwMDcySzUwUUFFDQowMXQwWTAwMDAwNzJLNTJRQUUNCjAxdDBZMDAwMDA3Mks1NFFBRQ0KMDF0MFkwMDAwMDcySzU4UUFFDQowMXQwWTAwMDAwNzJLNUNRQVUNCjAxdDBZMDAwMDA3Mks1RlFBVQ0KMDF0MFkwMDAwMDcySzVHUUFVDQowMXQwWTAwMDAwNzJLNUpRQVUNCjAxdDBZMDAwMDA3Mks1S1FBVQ0KMDF0MFkwMDAwMDcySzVNUUFVDQowMXQwWTAwMDAwNzJLNVFRQVUNCjAxdDBZMDAwMDA3Mks1VlFBVQ0KMDF0MFkwMDAwMDcySzVnUUFFDQowMXQwWTAwMDAwNzJLNWxRQUUNCjAxdDBZMDAwMDA3Mks1cVFBRQ0KMDF0MFkwMDAwMDcySzV2UUFFDQowMXQwWTAwMDAwNzJLNXlRQUUNCjAxdDBZMDAwMDA3Mks2MVFBRQ0KMDF0MFkwMDAwMDcySzY1UUFFDQowMXQwWTAwMDAwNzJLNjZRQUUNCjAxdDBZMDAwMDA3Mks2T1FBVQ0KMDF0MFkwMDAwMDcySzZiUUFFDQowMXQwWTAwMDAwNzJLNmRRQUUNCjAxdDBZMDAwMDA3Mks2ZVFBRQ0KMDF0MFkwMDAwMDcySzZrUUFFDQowMXQwWTAwMDAwNzJLNnBRQUUNCjAxdDBZMDAwMDA3Mks2clFBRQ0KMDF0MFkwMDAwMDcySzZ0UUFFDQowMXQwWTAwMDAwNzJLNnpRQUUNCjAxdDBZMDAwMDA3Mks3QVFBVQ0KMDF0MFkwMDAwMDcySzdDUUFVDQowMXQwWTAwMDAwNzJLN0VRQVUNCjAxdDBZMDAwMDA3Mks3UFFBVQ0KMDF0MFkwMDAwMDcySzdTUUFVDQowMXQwWTAwMDAwNzJLN1dRQVUNCjAxdDBZMDAwMDA3Mks3ZVFBRQ0KMDF0MFkwMDAwMDcySzdmUUFFDQowMXQwWTAwMDAwNzJLN25RQUUNCjAxdDBZMDAwMDA3Mks3cVFBRQ0KMDF0MFkwMDAwMDcySzd0UUFFDQowMXQwWTAwMDAwNzJLN3VRQUUNCjAxdDBZMDAwMDA3Mks4MFFBRQ0KMDF0MFkwMDAwMDcySzhCUUFVDQowMXQwWTAwMDAwNzJLOFlRQVUNCjAxdDBZMDAwMDA3Mks4YVFBRQ0KMDF0MFkwMDAwMDcySzhmUUFFDQowMXQwWTAwMDAwNzJLOGlRQUUNCjAxdDBZMDAwMDA3Mks4dFFBRQ0KMDF0MFkwMDAwMDcySzh3UUFFDQowMXQwWTAwMDAwNzJLOHhRQUUNCjAxdDBZMDAwMDA3Mks5MFFBRQ0KMDF0MFkwMDAwMDcySzkyUUFFDQowMXQwWTAwMDAwNzJLOTRRQUUNCjAxdDBZMDAwMDA3Mks5NlFBRQ0KMDF0MFkwMDAwMDcySzk3UUFFDQowMXQwWTAwMDAwNzJLOUNRQVUNCjAxdDBZMDAwMDA3Mks5SlFBVQ0KMDF0MFkwMDAwMDcySzlNUUFVDQowMXQwWTAwMDAwNzJLOVFRQVUNCjAxdDBZMDAwMDA3Mks5UlFBVQ0KMDF0MFkwMDAwMDcySzlUUUFVDQowMXQwWTAwMDAwNzJLOWVRQUUNCjAxdDBZMDAwMDA3Mks5eVFBRQ0KMDF0MFkwMDAwMDcyS0FEUUEyDQowMXQwWTAwMDAwNzJLQUVRQTINCjAxdDBZMDAwMDA3MktBR1FBMg0KMDF0MFkwMDAwMDcyS0FJUUEyDQowMXQwWTAwMDAwNzJLQU9RQTINCjAxdDBZMDAwMDA3MktBUFFBMg0KMDF0MFkwMDAwMDcyS0FSUUEyDQowMXQwWTAwMDAwNzJLQVhRQTINCjAxdDBZMDAwMDA3MktBYVFBTQ0KMDF0MFkwMDAwMDcyS0FiUUFNDQowMXQwWTAwMDAwNzJLQWNRQU0NCjAxdDBZMDAwMDA3MktBZ1FBTQ0KMDF0MFkwMDAwMDcyS0FpUUFNDQowMXQwWTAwMDAwNzJLQWxRQU0NCjAxdDBZMDAwMDA3MktBbVFBTQ0KMDF0MFkwMDAwMDcyS0FxUUFNDQowMXQwWTAwMDAwNzJLQXNRQU0NCjAxdDBZMDAwMDA3MktBdlFBTQ0KMDF0MFkwMDAwMDcyS0F3UUFNDQowMXQwWTAwMDAwNzJLQXpRQU0NCjAxdDBZMDAwMDA3MktCMVFBTQ0KMDF0MFkwMDAwMDcyS0IzUUFNDQowMXQwWTAwMDAwNzJLQkFRQTINCjAxdDBZMDAwMDA3MktCQ1FBMg0KMDF0MFkwMDAwMDcyS0JEUUEyDQowMXQwWTAwMDAwNzJLQlhRQTINCjAxdDBZMDAwMDA3MktDM1FBTQ0KMDF0MFkwMDAwMDcyS0M4UUFNDQowMXQwWTAwMDAwNzJLQzlRQU0NCjAxdDBZMDAwMDA3MktDQVFBMg0KMDF0MFkwMDAwMDcyS0NKUUEyDQowMXQwWTAwMDAwNzJLQ1BRQTINCjAxdDBZMDAwMDA3MktDUVFBMg0KMDF0MFkwMDAwMDcyS0NYUUEyDQowMXQwWTAwMDAwNzJLQ1lRQTINCjAxdDBZMDAwMDA3MktDWlFBMg0KMDF0MFkwMDAwMDcyS0NqUUFNDQowMXQwWTAwMDAwNzJLQ29RQU0NCjAxdDBZMDAwMDA3MktDclFBTQ0KMDF0MFkwMDAwMDcyS0QwUUFNDQowMXQwWTAwMDAwNzJLRDJRQU0NCjAxdDBZMDAwMDA3MktEM1FBTQ0KMDF0MFkwMDAwMDcyS0Q0UUFNDQowMXQwWTAwMDAwNzJLRDVRQU0NCjAxdDBZMDAwMDA3MktEN1FBTQ0KMDF0MFkwMDAwMDcyS0Q4UUFNDQowMXQwWTAwMDAwNzJLREFRQTINCjAxdDBZMDAwMDA3MktESVFBMg0KMDF0MFkwMDAwMDcyS0ROUUEyDQowMXQwWTAwMDAwNzJLRFFRQTINCjAxdDBZMDAwMDA3MktEUlFBMg0KMDF0MFkwMDAwMDcyS0RUUUEyDQowMXQwWTAwMDAwNzJLRGFRQU0NCjAxdDBZMDAwMDA3MktEbFFBTQ0KMDF0MFkwMDAwMDcyS0UwUUFNDQowMXQwWTAwMDAwNzJLRURRQTINCjAxdDBZMDAwMDA3MktFRVFBMg0KMDF0MFkwMDAwMDcyS0VLUUEyDQowMXQwWTAwMDAwNzJLRVFRQTINCjAxdDBZMDAwMDA3MktFWFFBMg0KMDF0MFkwMDAwMDcyS0VsUUFNDQowMXQwWTAwMDAwNzJLRXhRQU0NCjAxdDBZMDAwMDA3MktFeVFBTQ0KMDF0MFkwMDAwMDcyS0ZJUUEyDQowMXQwWTAwMDAwNzJLRktRQTINCjAxdDBZMDAwMDA3MktGTFFBMg0KMDF0MFkwMDAwMDcyS0ZOUUEyDQowMXQwWTAwMDAwNzJLRk9RQTINCjAxdDBZMDAwMDA3MktGUFFBMg0KMDF0MFkwMDAwMDcyS0ZRUUEyDQowMXQwWTAwMDAwNzJLRlJRQTINCjAxdDBZMDAwMDA3MktGWFFBMg0KMDF0MFkwMDAwMDcyS0ZwUUFNDQowMXQwWTAwMDAwNzJLRzJRQU0NCjAxdDBZMDAwMDA3MktHM1FBTQ0KMDF0MFkwMDAwMDcyS0c2UUFNDQowMXQwWTAwMDAwNzJLRzhRQU0NCjAxdDBZMDAwMDA3MktHOVFBTQ0KMDF0MFkwMDAwMDcyS0dEUUEyDQowMXQwWTAwMDAwNzJLR0dRQTINCjAxdDBZMDAwMDA3MktHSFFBMg0KMDF0MFkwMDAwMDcyS0dhUUFNDQowMXQwWTAwMDAwNzJLR2ZRQU0NCjAxdDBZMDAwMDA3MktHclFBTQ0KMDF0MFkwMDAwMDcyS0d0UUFNDQowMXQwWTAwMDAwNzJLR3VRQU0NCjAxdDBZMDAwMDA3MktIMFFBTQ0KMDF0MFkwMDAwMDcyS0g2UUFNDQowMXQwWTAwMDAwNzJLSDdRQU0NCjAxdDBZMDAwMDA3MktIOFFBTQ0KMDF0MFkwMDAwMDcyS0hKUUEyDQowMXQwWTAwMDAwNzJLSEtRQTINCjAxdDBZMDAwMDA3MktITFFBMg0KMDF0MFkwMDAwMDcyS0hNUUEyDQowMXQwWTAwMDAwNzJLSFFRQTINCjAxdDBZMDAwMDA3MktIWFFBMg0KMDF0MFkwMDAwMDcyS0hZUUEyDQowMXQwWTAwMDAwNzJLSGFRQU0NCjAxdDBZMDAwMDA3MktIY1FBTQ0KMDF0MFkwMDAwMDcyS0hkUUFNDQowMXQwWTAwMDAwNzJLSGZRQU0NCjAxdDBZMDAwMDA3MktIeVFBTQ0KMDF0MFkwMDAwMDcyS0k2UUFNDQowMXQwWTAwMDAwNzJLSUNRQTINCjAxdDBZMDAwMDA3MktJRlFBMg0KMDF0MFkwMDAwMDcyS0lHUUEyDQowMXQwWTAwMDAwNzJLSUhRQTINCjAxdDBZMDAwMDA3MktJTVFBMg0KMDF0MFkwMDAwMDcyS0lOUUEyDQowMXQwWTAwMDAwNzJLSVBRQTINCjAxdDBZMDAwMDA3MktJUlFBMg0KMDF0MFkwMDAwMDcyS0lTUUEyDQowMXQwWTAwMDAwNzJLSVRRQTINCjAxdDBZMDAwMDA3MktJVVFBMg0KMDF0MFkwMDAwMDcyS0ljUUFNDQowMXQwWTAwMDAwNzJLSW9RQU0NCjAxdDBZMDAwMDA3MktJcFFBTQ0KMDF0MFkwMDAwMDcyS0lzUUFNDQowMXQwWTAwMDAwNzJLSXZRQU0NCjAxdDBZMDAwMDA3MktJd1FBTQ0KMDF0MFkwMDAwMDcyS0l4UUFNDQowMXQwWTAwMDAwNzJLSjFRQU0NCjAxdDBZMDAwMDA3MktKOVFBTQ0KMDF0MFkwMDAwMDcyS0pBUUEyDQowMXQwWTAwMDAwNzJLSkJRQTINCjAxdDBZMDAwMDA3MktKQ1FBMg0KMDF0MFkwMDAwMDcyS0pJUUEyDQowMXQwWTAwMDAwNzJLSkpRQTINCjAxdDBZMDAwMDA3MktKTlFBMg0KMDF0MFkwMDAwMDcyS0pRUUEyDQowMXQwWTAwMDAwNzJLSlZRQTINCjAxdDBZMDAwMDA3MktKWlFBMg0KMDF0MFkwMDAwMDcyS0plUUFNDQowMXQwWTAwMDAwNzJLSmdRQU0NCjAxdDBZMDAwMDA3MktKaFFBTQ0KMDF0MFkwMDAwMDcyS0ppUUFNDQowMXQwWTAwMDAwNzJLSnBRQU0NCjAxdDBZMDAwMDA3MktKcVFBTQ0KMDF0MFkwMDAwMDcyS0pyUUFNDQowMXQwWTAwMDAwNzJLSnVRQU0NCjAxdDBZMDAwMDA3MktKeFFBTQ0KMDF0MFkwMDAwMDcyS0p5UUFNDQowMXQwWTAwMDAwNzJLSzFRQU0NCjAxdDBZMDAwMDA3MktLM1FBTQ0KMDF0MFkwMDAwMDcyS0tJUUEyDQowMXQwWTAwMDAwNzJLS1FRQTINCjAxdDBZMDAwMDA3MktLU1FBMg0KMDF0MFkwMDAwMDcyS0tWUUEyDQowMXQwWTAwMDAwNzJLS1dRQTINCjAxdDBZMDAwMDA3MktLYlFBTQ0KMDF0MFkwMDAwMDcyS0tnUUFNDQowMXQwWTAwMDAwNzJLS2lRQU0NCjAxdDBZMDAwMDA3MktLbFFBTQ0KMDF0MFkwMDAwMDcyS0ttUUFNDQowMXQwWTAwMDAwNzJLS25RQU0NCjAxdDBZMDAwMDA3MktLb1FBTQ0KMDF0MFkwMDAwMDcyS0tyUUFNDQowMXQwWTAwMDAwNzJLS3ZRQU0NCjAxdDBZMDAwMDA3MktMSFFBMg0KMDF0MFkwMDAwMDcyS0xKUUEyDQowMXQwWTAwMDAwNzJLTE5RQTINCjAxdDBZMDAwMDA3MktMUVFBMg0KMDF0MFkwMDAwMDcyS0xSUUEyDQowMXQwWTAwMDAwNzJLTFlRQTINCjAxdDBZMDAwMDA3MktMYVFBTQ0KMDF0MFkwMDAwMDcyS0xmUUFNDQowMXQwWTAwMDAwNzJLTGdRQU0NCjAxdDBZMDAwMDA3MktMaFFBTQ0KMDF0MFkwMDAwMDcyS0xpUUFNDQowMXQwWTAwMDAwNzJLTGpRQU0NCjAxdDBZMDAwMDA3MktMa1FBTQ0KMDF0MFkwMDAwMDcyS0xzUUFNDQowMXQwWTAwMDAwNzJLTHRRQU0NCjAxdDBZMDAwMDA3MktMdVFBTQ0KMDF0MFkwMDAwMDcyS003UUFNDQowMXQwWTAwMDAwNzJLTThRQU0NCjAxdDBZMDAwMDA3MktNU1FBMg0KMDF0MFkwMDAwMDcyS01UUUEyDQowMXQwWTAwMDAwNzJLTVdRQTINCjAxdDBZMDAwMDA3MktNWVFBMg0KMDF0MFkwMDAwMDcyS01iUUFNDQowMXQwWTAwMDAwNzJLTWNRQU0NCjAxdDBZMDAwMDA3MktNdVFBTQ0KMDF0MFkwMDAwMDcyS015UUFNDQowMXQwWTAwMDAwNzJLTkVRQTINCjAxdDBZMDAwMDA3MktOSVFBMg0KMDF0MFkwMDAwMDcyS05iUUFNDQowMXQwWTAwMDAwNzJLTmVRQU0NCjAxdDBZMDAwMDA3MktOalFBTQ0KMDF0MFkwMDAwMDcyS05rUUFNDQowMXQwWTAwMDAwNzJLTnRRQU0NCjAxdDBZMDAwMDA3MktPNFFBTQ0KMDF0MFkwMDAwMDcyS083UUFNDQowMXQwWTAwMDAwNzJLT0FRQTINCjAxdDBZMDAwMDA3MktPQlFBMg0KMDF0MFkwMDAwMDcyS09HUUEyDQowMXQwWTAwMDAwNzJLT0pRQTINCjAxdDBZMDAwMDA3MktPS1FBMg0KMDF0MFkwMDAwMDcyS09MUUEyDQowMXQwWTAwMDAwNzJLT2xRQU0NCjAxdDBZMDAwMDA3MktPcVFBTQ0KMDF0MFkwMDAwMDcyS1BNUUEyDQowMXQwWTAwMDAwNzJLUE5RQTINCjAxdDBZMDAwMDA3MktQUVFBMg0KMDF0MFkwMDAwMDcyS1BSUUEyDQowMXQwWTAwMDAwNzJLUFZRQTINCjAxdDBZMDAwMDA3MktQV1FBMg0KMDF0MFkwMDAwMDcyS1BjUUFNDQowMXQwWTAwMDAwNzJLUGVRQU0NCjAxdDBZMDAwMDA3MktQZ1FBTQ0KMDF0MFkwMDAwMDcyS1BoUUFNDQowMXQwWTAwMDAwNzJLUG1RQU0NCjAxdDBZMDAwMDA3MktQblFBTQ0KMDF0MFkwMDAwMDcyS1ByUUFNDQowMXQwWTAwMDAwNzJLUHRRQU0NCjAxdDBZMDAwMDA3MktQeFFBTQ0KMDF0MFkwMDAwMDcyS1ExUUFNDQowMXQwWTAwMDAwNzJLUTVRQU0NCjAxdDBZMDAwMDA3MktRR1FBMg0KMDF0MFkwMDAwMDcyS1FTUUEyDQowMXQwWTAwMDAwNzJLUVhRQTINCjAxdDBZMDAwMDA3MktRYVFBTQ0KMDF0MFkwMDAwMDcyS1FnUUFNDQowMXQwWTAwMDAwNzJLUXpRQU0NCjAxdDBZMDAwMDA3MktSMFFBTQ0KMDF0MFkwMDAwMDcyS1IxUUFNDQowMXQwWTAwMDAwNzJLUjRRQU0NCjAxdDBZMDAwMDA3MktSQlFBMg0KMDF0MFkwMDAwMDcyS1JNUUEyDQowMXQwWTAwMDAwNzJLUmZRQU0NCjAxdDBZMDAwMDA3MktSZ1FBTQ0KMDF0MFkwMDAwMDcyS1JpUUFNDQowMXQwWTAwMDAwNzJLUnVRQU0NCjAxdDBZMDAwMDA3MktTQlFBMg0KMDF0MFkwMDAwMDcyS1NDUUEyDQowMXQwWTAwMDAwNzJLU0RRQTINCjAxdDBZMDAwMDA3MktTRVFBMg0KMDF0MFkwMDAwMDcyS1NGUUEyDQowMXQwWTAwMDAwNzJLU0dRQTINCjAxdDBZMDAwMDA3MktTSlFBMg0KMDF0MFkwMDAwMDcyS1NLUUEyDQowMXQwWTAwMDAwNzJLU0xRQTINCjAxdDBZMDAwMDA3MktTTlFBMg0KMDF0MFkwMDAwMDcyS1NPUUEyDQowMXQwWTAwMDAwNzJLU1pRQTINCjAxdDBZMDAwMDA3MktTalFBTQ0KMDF0MFkwMDAwMDcyS1NtUUFNDQowMXQwWTAwMDAwNzJLU25RQU0NCjAxdDBZMDAwMDA3MktTclFBTQ0KMDF0MFkwMDAwMDcyS1N0UUFNDQowMXQwWTAwMDAwNzJLVDVRQU0NCjAxdDBZMDAwMDA3MktUNlFBTQ0KMDF0MFkwMDAwMDcyS1REUUEyDQowMXQwWTAwMDAwNzJLVElRQTINCjAxdDBZMDAwMDA3MktUTlFBMg0KMDF0MFkwMDAwMDcyS1RWUUEyDQowMXQwWTAwMDAwNzJLVTJRQU0NCjAxdDBZMDAwMDA3MktVQVFBMg0KMDF0MFkwMDAwMDcyS1VGUUEyDQowMXQwWTAwMDAwNzJLVUhRQTINCjAxdDBZMDAwMDA3MktVSVFBMg0KMDF0MFkwMDAwMDcyS1VKUUEyDQowMXQwWTAwMDAwNzJLVU5RQTINCjAxdDBZMDAwMDA3MktVYVFBTQ0KMDF0MFkwMDAwMDcyS1VtUUFNDQowMXQwWTAwMDAwNzJLVXpRQU0NCjAxdDBZMDAwMDA3MktWMVFBTQ0KMDF0MFkwMDAwMDcyS1ZOUUEyDQowMXQwWTAwMDAwNzJLVlNRQTINCjAxdDBZMDAwMDA3MktWVVFBMg0KMDF0MFkwMDAwMDcyS1ZWUUEyDQowMXQwWTAwMDAwNzJLVllRQTINCjAxdDBZMDAwMDA3MktWWlFBMg0KMDF0MFkwMDAwMDcyS1ZjUUFNDQowMXQwWTAwMDAwNzJLVmRRQU0NCjAxdDBZMDAwMDA3MktWaVFBTQ0KMDF0MFkwMDAwMDcyS1ZxUUFNDQowMXQwWTAwMDAwNzJLVnlRQU0NCjAxdDBZMDAwMDA3MktXMVFBTQ0KMDF0MFkwMDAwMDcyS1c0UUFNDQowMXQwWTAwMDAwNzJLVzdRQU0NCjAxdDBZMDAwMDA3MktXOVFBTQ0KMDF0MFkwMDAwMDcyS1dGUUEyDQowMXQwWTAwMDAwNzJLV0hRQTINCjAxdDBZMDAwMDA3MktXTFFBMg0KMDF0MFkwMDAwMDcyS1dPUUEyDQowMXQwWTAwMDAwNzJLV1FRQTINCjAxdDBZMDAwMDA3MktXYVFBTQ0KMDF0MFkwMDAwMDcyS1djUUFNDQowMXQwWTAwMDAwNzJLV2RRQU0NCjAxdDBZMDAwMDA3MktXZVFBTQ0KMDF0MFkwMDAwMDcyS1dnUUFNDQowMXQwWTAwMDAwNzJLV2xRQU0NCjAxdDBZMDAwMDA3MktXblFBTQ0KMDF0MFkwMDAwMDcyS1dvUUFNDQowMXQwWTAwMDAwNzJLV3JRQU0NCjAxdDBZMDAwMDA3MktXdlFBTQ0KMDF0MFkwMDAwMDcyS1g4UUFNDQowMXQwWTAwMDAwNzJLWDlRQU0NCjAxdDBZMDAwMDA3MktYQlFBMg0KMDF0MFkwMDAwMDcyS1hEUUEyDQowMXQwWTAwMDAwNzJLWEVRQTINCjAxdDBZMDAwMDA3MktYR1FBMg0KMDF0MFkwMDAwMDcyS1hJUUEyDQowMXQwWTAwMDAwNzJLWExRQTINCjAxdDBZMDAwMDA3MktYTVFBMg0KMDF0MFkwMDAwMDcyS1hOUUEyDQowMXQwWTAwMDAwNzJLWFhRQTINCjAxdDBZMDAwMDA3MktYY1FBTQ0KMDF0MFkwMDAwMDcyS1hmUUFNDQowMXQwWTAwMDAwNzJLWTJRQU0NCjAxdDBZMDAwMDA3MktZNlFBTQ0KMDF0MFkwMDAwMDcyS1lCUUEyDQowMXQwWTAwMDAwNzJLWVFRQTINCjAxdDBZMDAwMDA3MktZUlFBMg0KMDF0MFkwMDAwMDcyS1lTUUEyDQowMXQwWTAwMDAwNzJLWVdRQTINCjAxdDBZMDAwMDA3MktZYlFBTQ0KMDF0MFkwMDAwMDcyS1lpUUFNDQowMXQwWTAwMDAwNzJLWWpRQU0NCjAxdDBZMDAwMDA3MktZcFFBTQ0KMDF0MFkwMDAwMDcyS1lyUUFNDQowMXQwWTAwMDAwNzJLWXNRQU0NCjAxdDBZMDAwMDA3MktZeVFBTQ0KMDF0MFkwMDAwMDcyS1l6UUFNDQowMXQwWTAwMDAwNzJLWjBRQU0NCjAxdDBZMDAwMDA3MktaVVFBMg0KMDF0MFkwMDAwMDcyS1paUUEyDQowMXQwWTAwMDAwNzJLWmNRQU0NCjAxdDBZMDAwMDA3MktabVFBTQ0KMDF0MFkwMDAwMDcyS1pzUUFNDQowMXQwWTAwMDAwNzJLWnRRQU0NCjAxdDBZMDAwMDA3MktadVFBTQ0KMDF0MFkwMDAwMDcyS1p5UUFNDQowMXQwWTAwMDAwNzJLYTNRQUUNCjAxdDBZMDAwMDA3MkthNFFBRQ0KMDF0MFkwMDAwMDcyS2E1UUFFDQowMXQwWTAwMDAwNzJLYTdRQUUNCjAxdDBZMDAwMDA3MkthQlFBVQ0KMDF0MFkwMDAwMDcyS2FKUUFVDQowMXQwWTAwMDAwNzJLYUxRQVUNCjAxdDBZMDAwMDA3MkthcFFBRQ0KMDF0MFkwMDAwMDcyS2IzUUFFDQowMXQwWTAwMDAwNzJLYjZRQUUNCjAxdDBZMDAwMDA3MktiOFFBRQ0KMDF0MFkwMDAwMDcyS2JBUUFVDQowMXQwWTAwMDAwNzJLYkNRQVUNCjAxdDBZMDAwMDA3MktiSFFBVQ0KMDF0MFkwMDAwMDcyS2JJUUFVDQowMXQwWTAwMDAwNzJLYk5RQVUNCjAxdDBZMDAwMDA3MktiVVFBVQ0KMDF0MFkwMDAwMDcyS2JXUUFVDQowMXQwWTAwMDAwNzJLYllRQVUNCjAxdDBZMDAwMDA3MktiZ1FBRQ0KMDF0MFkwMDAwMDcyS2JpUUFFDQowMXQwWTAwMDAwNzJLYm5RQUUNCjAxdDBZMDAwMDA3Mktib1FBRQ0KMDF0MFkwMDAwMDcyS2J3UUFFDQowMXQwWTAwMDAwNzJLY0xRQVUNCjAxdDBZMDAwMDA3MktjT1FBVQ0KMDF0MFkwMDAwMDcyS2NiUUFFDQowMXQwWTAwMDAwNzJLY2pRQUUNCjAxdDBZMDAwMDA3Mktja1FBRQ0KMDF0MFkwMDAwMDcyS2NuUUFFDQowMXQwWTAwMDAwNzJLY3FRQUUNCjAxdDBZMDAwMDA3Mktjc1FBRQ0KMDF0MFkwMDAwMDcyS2N0UUFFDQowMXQwWTAwMDAwNzJLY3dRQUUNCjAxdDBZMDAwMDA3MktkNVFBRQ0KMDF0MFkwMDAwMDcyS2RKUUFVDQowMXQwWTAwMDAwNzJLZE1RQVUNCjAxdDBZMDAwMDA3MktkT1FBVQ0KMDF0MFkwMDAwMDcyS2RUUUFVDQowMXQwWTAwMDAwNzJLZFZRQVUNCjAxdDBZMDAwMDA3MktkWVFBVQ0KMDF0MFkwMDAwMDcyS2RsUUFFDQowMXQwWTAwMDAwNzJLZG1RQUUNCjAxdDBZMDAwMDA3MktkdFFBRQ0KMDF0MFkwMDAwMDcyS2R4UUFFDQowMXQwWTAwMDAwNzJLZTJRQUUNCjAxdDBZMDAwMDA3MktlM1FBRQ0KMDF0MFkwMDAwMDcyS2U4UUFFDQowMXQwWTAwMDAwNzJLZUJRQVUNCjAxdDBZMDAwMDA3MktlRlFBVQ0KMDF0MFkwMDAwMDcyS2VIUUFVDQowMXQwWTAwMDAwNzJLZU1RQVUNCjAxdDBZMDAwMDA3MktlTlFBVQ0KMDF0MFkwMDAwMDcyS2VQUUFVDQowMXQwWTAwMDAwNzJLZVNRQVUNCjAxdDBZMDAwMDA3MktlVVFBVQ0KMDF0MFkwMDAwMDcyS2VYUUFVDQowMXQwWTAwMDAwNzJLZWJRQUUNCjAxdDBZMDAwMDA3MktlY1FBRQ0KMDF0MFkwMDAwMDcyS2VkUUFFDQowMXQwWTAwMDAwNzJLZWpRQUUNCjAxdDBZMDAwMDA3MktlcFFBRQ0KMDF0MFkwMDAwMDcyS2V1UUFFDQowMXQwWTAwMDAwNzJLZXdRQUUNCjAxdDBZMDAwMDA3MktleVFBRQ0KMDF0MFkwMDAwMDcyS2YwUUFFDQowMXQwWTAwMDAwNzJLZjVRQUUNCjAxdDBZMDAwMDA3MktmQ1FBVQ0KMDF0MFkwMDAwMDcyS2ZEUUFVDQowMXQwWTAwMDAwNzJLZm9RQUUNCjAxdDBZMDAwMDA3MktmcFFBRQ0KMDF0MFkwMDAwMDcyS2ZxUUFFDQowMXQwWTAwMDAwNzJLZnJRQUUNCjAxdDBZMDAwMDA3MktmdFFBRQ0KMDF0MFkwMDAwMDcyS2Z1UUFFDQowMXQwWTAwMDAwNzJLZnZRQUUNCjAxdDBZMDAwMDA3Mktmd1FBRQ0KMDF0MFkwMDAwMDcyS2c1UUFFDQowMXQwWTAwMDAwNzJLZ0JRQVUNCjAxdDBZMDAwMDA3MktnRVFBVQ0KMDF0MFkwMDAwMDcyS2dIUUFVDQowMXQwWTAwMDAwNzJLZ0tRQVUNCjAxdDBZMDAwMDA3MktnTFFBVQ0KMDF0MFkwMDAwMDcyS2dQUUFVDQowMXQwWTAwMDAwNzJLZ1VRQVUNCjAxdDBZMDAwMDA3MktnZFFBRQ0KMDF0MFkwMDAwMDcyS2dnUUFFDQowMXQwWTAwMDAwNzJLZ2hRQUUNCjAxdDBZMDAwMDA3MktncFFBRQ0KMDF0MFkwMDAwMDcyS2gyUUFFDQowMXQwWTAwMDAwNzJLaDNRQUUNCjAxdDBZMDAwMDA3MktoNFFBRQ0KMDF0MFkwMDAwMDcyS2g1UUFFDQowMXQwWTAwMDAwNzJLaENRQVUNCjAxdDBZMDAwMDA3MktoR1FBVQ0KMDF0MFkwMDAwMDcyS2hKUUFVDQowMXQwWTAwMDAwNzJLaEtRQVUNCjAxdDBZMDAwMDA3MktoTVFBVQ0KMDF0MFkwMDAwMDcyS2hSUUFVDQowMXQwWTAwMDAwNzJLaGlRQUUNCjAxdDBZMDAwMDA3MktoblFBRQ0KMDF0MFkwMDAwMDcyS2h0UUFFDQowMXQwWTAwMDAwNzJLaHVRQUUNCjAxdDBZMDAwMDA3MktpMlFBRQ0KMDF0MFkwMDAwMDcyS2lDUUFVDQowMXQwWTAwMDAwNzJLaUZRQVUNCjAxdDBZMDAwMDA3MktpVFFBVQ0KMDF0MFkwMDAwMDcyS2lVUUFVDQowMXQwWTAwMDAwNzJLaWJRQUUNCjAxdDBZMDAwMDA3MktpZFFBRQ0KMDF0MFkwMDAwMDcyS2lmUUFFDQowMXQwWTAwMDAwNzJLaW5RQUUNCjAxdDBZMDAwMDA3MktpclFBRQ0KMDF0MFkwMDAwMDcyS2l0UUFFDQowMXQwWTAwMDAwNzJLaXZRQUUNCjAxdDBZMDAwMDA3MktpeFFBRQ0KMDF0MFkwMDAwMDcyS2pJUUFVDQowMXQwWTAwMDAwNzJLalRRQVUNCjAxdDBZMDAwMDA3MktrMFFBRQ0KMDF0MFkwMDAwMDcyS2s2UUFFDQowMXQwWTAwMDAwNzJLazdRQUUNCjAxdDBZMDAwMDA3MktrQVFBVQ0KMDF0MFkwMDAwMDcyS2tEUUFVDQowMXQwWTAwMDAwNzJLa0tRQVUNCjAxdDBZMDAwMDA3MktrTlFBVQ0KMDF0MFkwMDAwMDcyS2tPUUFVDQowMXQwWTAwMDAwNzJLa1JRQVUNCjAxdDBZMDAwMDA3MktrWlFBVQ0KMDF0MFkwMDAwMDcyS2thUUFFDQowMXQwWTAwMDAwNzJLa2JRQUUNCjAxdDBZMDAwMDA3MktrZlFBRQ0KMDF0MFkwMDAwMDcyS2trUUFFDQowMXQwWTAwMDAwNzJLa25RQUUNCjAxdDBZMDAwMDA3Mktrb1FBRQ0KMDF0MFkwMDAwMDcyS2t3UUFFDQowMXQwWTAwMDAwNzJLa3pRQUUNCjAxdDBZMDAwMDA3MktsMFFBRQ0KMDF0MFkwMDAwMDcyS2wyUUFFDQowMXQwWTAwMDAwNzJLbDNRQUUNCjAxdDBZMDAwMDA3MktsNFFBRQ0KMDF0MFkwMDAwMDcyS2w1UUFFDQowMXQwWTAwMDAwNzJLbDZRQUUNCjAxdDBZMDAwMDA3MktsN1FBRQ0KMDF0MFkwMDAwMDcyS2xFUUFVDQowMXQwWTAwMDAwNzJLbEhRQVUNCjAxdDBZMDAwMDA3MktsSlFBVQ0KMDF0MFkwMDAwMDcyS2xZUUFVDQowMXQwWTAwMDAwNzJLbGFRQUUNCjAxdDBZMDAwMDA3MktscFFBRQ0KMDF0MFkwMDAwMDcyS201UUFFDQowMXQwWTAwMDAwNzJLbUtRQVUNCjAxdDBZMDAwMDA3Mkttd1FBRQ0KMDF0MFkwMDAwMDcyS24wUUFFDQowMXQwWTAwMDAwNzJLbjdRQUUNCjAxdDBZMDAwMDA3MktuOFFBRQ0KMDF0MFkwMDAwMDcyS25IUUFVDQowMXQwWTAwMDAwNzJLbktRQVUNCjAxdDBZMDAwMDA3MktuTVFBVQ0KMDF0MFkwMDAwMDcyS25QUUFVDQowMXQwWTAwMDAwNzJLblNRQVUNCjAxdDBZMDAwMDA3MktuWFFBVQ0KMDF0MFkwMDAwMDcyS25ZUUFVDQowMXQwWTAwMDAwNzJLblpRQVUNCjAxdDBZMDAwMDA3MktuZVFBRQ0KMDF0MFkwMDAwMDcyS25tUUFFDQowMXQwWTAwMDAwNzJLbm5RQUUNCjAxdDBZMDAwMDA3Mktub1FBRQ0KMDF0MFkwMDAwMDcyS250UUFFDQowMXQwWTAwMDAwNzJLbzFRQUUNCjAxdDBZMDAwMDA3MktvNFFBRQ0KMDF0MFkwMDAwMDcyS29KUUFVDQowMXQwWTAwMDAwNzJLb01RQVUNCjAxdDBZMDAwMDA3MktvUFFBVQ0KMDF0MFkwMDAwMDcyS29UUUFVDQowMXQwWTAwMDAwNzJLb2VRQUUNCjAxdDBZMDAwMDA3MktvZlFBRQ0KMDF0MFkwMDAwMDcyS29nUUFFDQowMXQwWTAwMDAwNzJLb2lRQUUNCjAxdDBZMDAwMDA3MktvbVFBRQ0KMDF0MFkwMDAwMDcyS293UUFFDQowMXQwWTAwMDAwNzJLcEhRQVUNCjAxdDBZMDAwMDA3MktwS1FBVQ0KMDF0MFkwMDAwMDcyS3BNUUFVDQowMXQwWTAwMDAwNzJLcFJRQVUNCjAxdDBZMDAwMDA3MktwVlFBVQ0KMDF0MFkwMDAwMDcyS3BiUUFFDQowMXQwWTAwMDAwNzJLcGRRQUUNCjAxdDBZMDAwMDA3MktwaVFBRQ0KMDF0MFkwMDAwMDcyS3FVUUFVDQowMXQwWTAwMDAwNzJLcVdRQVUNCjAxdDBZMDAwMDA3MktxWVFBVQ0KMDF0MFkwMDAwMDcyS3FaUUFVDQowMXQwWTAwMDAwNzJLcWFRQUUNCjAxdDBZMDAwMDA3MktxYlFBRQ0KMDF0MFkwMDAwMDcyS3FkUUFFDQowMXQwWTAwMDAwNzJLcWlRQUUNCjAxdDBZMDAwMDA3MktxcVFBRQ0KMDF0MFkwMDAwMDcyS3I5UUFFDQowMXQwWTAwMDAwNzJLckJRQVUNCjAxdDBZMDAwMDA3MktySFFBVQ0KMDF0MFkwMDAwMDcyS3JLUUFVDQowMXQwWTAwMDAwNzJLcmFRQUUNCjAxdDBZMDAwMDA3MktyZFFBRQ0KMDF0MFkwMDAwMDcyS3JlUUFFDQowMXQwWTAwMDAwNzJLcmZRQUUNCjAxdDBZMDAwMDA3MktyaFFBRQ0KMDF0MFkwMDAwMDcyS3JrUUFFDQowMXQwWTAwMDAwNzJLcnhRQUUNCjAxdDBZMDAwMDA3MktyelFBRQ0KMDF0MFkwMDAwMDcyS3MwUUFFDQowMXQwWTAwMDAwNzJLczZRQUUNCjAxdDBZMDAwMDA3MktzQlFBVQ0KMDF0MFkwMDAwMDcyS3NEUUFVDQowMXQwWTAwMDAwNzJLc0ZRQVUNCjAxdDBZMDAwMDA3MktzTFFBVQ0KMDF0MFkwMDAwMDcyS3NTUUFVDQowMXQwWTAwMDAwNzJLc1hRQVUNCjAxdDBZMDAwMDA3MktzWlFBVQ0KMDF0MFkwMDAwMDcyS3NzUUFFDQowMXQwWTAwMDAwNzJLc3RRQUUNCjAxdDBZMDAwMDA3Mkt0TlFBVQ0KMDF0MFkwMDAwMDcyS3RPUUFVDQowMXQwWTAwMDAwNzJLdFNRQVUNCjAxdDBZMDAwMDA3Mkt0VVFBVQ0KMDF0MFkwMDAwMDcyS3RWUUFVDQowMXQwWTAwMDAwNzJLdGJRQUUNCjAxdDBZMDAwMDA3Mkt0ZFFBRQ0KMDF0MFkwMDAwMDcyS3RsUUFFDQowMXQwWTAwMDAwNzJLdG1RQUUNCjAxdDBZMDAwMDA3Mkt0b1FBRQ0KMDF0MFkwMDAwMDcyS3R1UUFFDQowMXQwWTAwMDAwNzJLdTJRQUUNCjAxdDBZMDAwMDA3Mkt1N1FBRQ0KMDF0MFkwMDAwMDcyS3U4UUFFDQowMXQwWTAwMDAwNzJLdUZRQVUNCjAxdDBZMDAwMDA3Mkt1VFFBVQ0KMDF0MFkwMDAwMDcyS3VVUUFVDQowMXQwWTAwMDAwNzJLdVdRQVUNCjAxdDBZMDAwMDA3Mkt1YVFBRQ0KMDF0MFkwMDAwMDcyS3VkUUFFDQowMXQwWTAwMDAwNzJLdWxRQUUNCjAxdDBZMDAwMDA3Mkt1blFBRQ0KMDF0MFkwMDAwMDcyS3V0UUFFDQowMXQwWTAwMDAwNzJLdXlRQUUNCjAxdDBZMDAwMDA3Mkt2NVFBRQ0KMDF0MFkwMDAwMDcyS3Y3UUFFDQowMXQwWTAwMDAwNzJLdklRQVUNCjAxdDBZMDAwMDA3Mkt2SlFBVQ0KMDF0MFkwMDAwMDcyS3ZLUUFVDQowMXQwWTAwMDAwNzJLdlZRQVUNCjAxdDBZMDAwMDA3Mkt2aVFBRQ0KMDF0MFkwMDAwMDcyS3Z1UUFFDQowMXQwWTAwMDAwNzJLd0FRQVUNCjAxdDBZMDAwMDA3Mkt3aVFBRQ0KMDF0MFkwMDAwMDcyS3dqUUFFDQowMXQwWTAwMDAwNzJLd2xRQUUNCjAxdDBZMDAwMDA3Mkt3blFBRQ0KMDF0MFkwMDAwMDcyS3dxUUFFDQowMXQwWTAwMDAwNzJLd3ZRQUUNCjAxdDBZMDAwMDA3Mkt4MlFBRQ0KMDF0MFkwMDAwMDcyS3gzUUFFDQowMXQwWTAwMDAwNzJLeDRRQUUNCjAxdDBZMDAwMDA3Mkt4NlFBRQ0KMDF0MFkwMDAwMDcyS3g4UUFFDQowMXQwWTAwMDAwNzJLeDlRQUUNCjAxdDBZMDAwMDA3Mkt4QVFBVQ0KMDF0MFkwMDAwMDcyS3hFUUFVDQowMXQwWTAwMDAwNzJLeEpRQVUNCjAxdDBZMDAwMDA3Mkt4TlFBVQ0KMDF0MFkwMDAwMDcyS3hjUUFFDQowMXQwWTAwMDAwNzJLeGZRQUUNCjAxdDBZMDAwMDA3Mkt4aFFBRQ0KMDF0MFkwMDAwMDcyS3hpUUFFDQowMXQwWTAwMDAwNzJLeGpRQUUNCjAxdDBZMDAwMDA3Mkt4bFFBRQ0KMDF0MFkwMDAwMDcyS3h5UUFFDQowMXQwWTAwMDAwNzJLeHpRQUUNCjAxdDBZMDAwMDA3Mkt5MVFBRQ0KMDF0MFkwMDAwMDcyS3k1UUFFDQowMXQwWTAwMDAwNzJLeUFRQVUNCjAxdDBZMDAwMDA3Mkt5RFFBVQ0KMDF0MFkwMDAwMDcyS3lJUUFVDQowMXQwWTAwMDAwNzJLeUtRQVUNCjAxdDBZMDAwMDA3Mkt5UFFBVQ0KMDF0MFkwMDAwMDcyS3lRUUFVDQowMXQwWTAwMDAwNzJLeVJRQVUNCjAxdDBZMDAwMDA3Mkt5ZFFBRQ0KMDF0MFkwMDAwMDcyS3lmUUFFDQowMXQwWTAwMDAwNzJLeXVRQUUNCjAxdDBZMDAwMDA3Mkt6MlFBRQ0KMDF0MFkwMDAwMDcyS3o0UUFFDQowMXQwWTAwMDAwNzJLejdRQUUNCjAxdDBZMDAwMDA3Mkt6Q1FBVQ0KMDF0MFkwMDAwMDcyS3pPUUFVDQowMXQwWTAwMDAwNzJLelFRQVUNCjAxdDBZMDAwMDA3Mkt6dFFBRQ0KMDF0MFkwMDAwMDcyS3p3UUFFDQowMXQwWTAwMDAwNzJLenpRQUUNCjAxdDBZMDAwMDA3MkwwMFFBRQ0KMDF0MFkwMDAwMDcyTDBCUUFVDQowMXQwWTAwMDAwNzJMMEZRQVUNCjAxdDBZMDAwMDA3MkwwV1FBVQ0KMDF0MFkwMDAwMDcyTDBaUUFVDQowMXQwWTAwMDAwNzJMMGNRQUUNCjAxdDBZMDAwMDA3MkwwZlFBRQ0KMDF0MFkwMDAwMDcyTDBnUUFFDQowMXQwWTAwMDAwNzJMMGlRQUUNCjAxdDBZMDAwMDA3Mkwwa1FBRQ0KMDF0MFkwMDAwMDcyTDBsUUFFDQowMXQwWTAwMDAwNzJMMG1RQUUNCjAxdDBZMDAwMDA3MkwweFFBRQ0KMDF0MFkwMDAwMDcyTDB6UUFFDQowMXQwWTAwMDAwNzJMMTBRQUUNCjAxdDBZMDAwMDA3MkwxNVFBRQ0KMDF0MFkwMDAwMDcyTDFCUUFVDQowMXQwWTAwMDAwNzJMMURRQVUNCjAxdDBZMDAwMDA3MkwxRlFBVQ0KMDF0MFkwMDAwMDcyTDFHUUFVDQowMXQwWTAwMDAwNzJMMUxRQVUNCjAxdDBZMDAwMDA3MkwxTlFBVQ0KMDF0MFkwMDAwMDcyTDFRUUFVDQowMXQwWTAwMDAwNzJMMWxRQUUNCjAxdDBZMDAwMDA3MkwyNVFBRQ0KMDF0MFkwMDAwMDcyTDJBUUFVDQowMXQwWTAwMDAwNzJMMkJRQVUNCjAxdDBZMDAwMDA3MkwyQ1FBVQ0KMDF0MFkwMDAwMDcyTDJFUUFVDQowMXQwWTAwMDAwNzJMMktRQVUNCjAxdDBZMDAwMDA3MkwyTFFBVQ0KMDF0MFkwMDAwMDcyTDJPUUFVDQowMXQwWTAwMDAwNzJMMm1RQUUNCjAxdDBZMDAwMDA3Mkwyb1FBRQ0KMDF0MFkwMDAwMDcyTDJxUUFFDQowMXQwWTAwMDAwNzJMMnJRQUUNCjAxdDBZMDAwMDA3Mkwyd1FBRQ0KMDF0MFkwMDAwMDcyTDJ4UUFFDQowMXQwWTAwMDAwNzJMMzBRQUUNCjAxdDBZMDAwMDA3MkwzQ1FBVQ0KMDF0MFkwMDAwMDcyTDNEUUFVDQowMXQwWTAwMDAwNzJMM2FRQUUNCjAxdDBZMDAwMDA3MkwzY1FBRQ0KMDF0MFkwMDAwMDcyTDNkUUFFDQowMXQwWTAwMDAwNzJMM2VRQUUNCjAxdDBZMDAwMDA3MkwzaVFBRQ0KMDF0MFkwMDAwMDcyTDNqUUFFDQowMXQwWTAwMDAwNzJMM21RQUUNCjAxdDBZMDAwMDA3MkwzcFFBRQ0KMDF0MFkwMDAwMDcyTDN0UUFFDQowMXQwWTAwMDAwNzJMM3VRQUUNCjAxdDBZMDAwMDA3Mkwzd1FBRQ0KMDF0MFkwMDAwMDcyTDQwUUFFDQowMXQwWTAwMDAwNzJMNDNRQUUNCjAxdDBZMDAwMDA3Mkw0QlFBVQ0KMDF0MFkwMDAwMDcyTDREUUFVDQowMXQwWTAwMDAwNzJMNElRQVUNCjAxdDBZMDAwMDA3Mkw0WlFBVQ0KMDF0MFkwMDAwMDcyTDRpUUFFDQowMXQwWTAwMDAwNzJMNGxRQUUNCjAxdDBZMDAwMDA3Mkw1M1FBRQ0KMDF0MFkwMDAwMDcyTDU2UUFFDQowMXQwWTAwMDAwNzJMNThRQUUNCjAxdDBZMDAwMDA3Mkw1QVFBVQ0KMDF0MFkwMDAwMDcyTDVEUUFVDQowMXQwWTAwMDAwNzJMNUdRQVUNCjAxdDBZMDAwMDA3Mkw1TlFBVQ0KMDF0MFkwMDAwMDcyTDVPUUFVDQowMXQwWTAwMDAwNzJMNVFRQVUNCjAxdDBZMDAwMDA3Mkw1VFFBVQ0KMDF0MFkwMDAwMDcyTDVYUUFVDQowMXQwWTAwMDAwNzJMNWFRQUUNCjAxdDBZMDAwMDA3Mkw1YlFBRQ0KMDF0MFkwMDAwMDcyTDVjUUFFDQowMXQwWTAwMDAwNzJMNWtRQUUNCjAxdDBZMDAwMDA3Mkw1cVFBRQ0KMDF0MFkwMDAwMDcyTDVyUUFFDQowMXQwWTAwMDAwNzJMNXhRQUUNCjAxdDBZMDAwMDA3Mkw2N1FBRQ0KMDF0MFkwMDAwMDcyTDZHUUFVDQowMXQwWTAwMDAwNzJMNkxRQVUNCjAxdDBZMDAwMDA3Mkw2VlFBVQ0KMDF0MFkwMDAwMDcyTDZXUUFVDQowMXQwWTAwMDAwNzJMNlhRQVUNCjAxdDBZMDAwMDA3Mkw2YVFBRQ0KMDF0MFkwMDAwMDcyTDZqUUFFDQowMXQwWTAwMDAwNzJMNnBRQUUNCjAxdDBZMDAwMDA3Mkw2cVFBRQ0KMDF0MFkwMDAwMDcyTDdDUUFVDQowMXQwWTAwMDAwNzJMN0RRQVUNCjAxdDBZMDAwMDA3Mkw3SVFBVQ0KMDF0MFkwMDAwMDcyTDdRUUFVDQowMXQwWTAwMDAwNzJMN1NRQVUNCjAxdDBZMDAwMDA3Mkw3YVFBRQ0KMDF0MFkwMDAwMDcyTDdjUUFFDQowMXQwWTAwMDAwNzJMN2RRQUUNCjAxdDBZMDAwMDA3Mkw3ZVFBRQ0KMDF0MFkwMDAwMDcyTDdqUUFFDQowMXQwWTAwMDAwNzJMN3RRQUUNCjAxdDBZMDAwMDA3Mkw3dVFBRQ0KMDF0MFkwMDAwMDcyTDd2UUFFDQowMXQwWTAwMDAwNzJMN3lRQUUNCjAxdDBZMDAwMDA3Mkw4NFFBRQ0KMDF0MFkwMDAwMDcyTDg2UUFFDQowMXQwWTAwMDAwNzJMODdRQUUNCjAxdDBZMDAwMDA3Mkw4OVFBRQ0KMDF0MFkwMDAwMDcyTDhDUUFVDQowMXQwWTAwMDAwNzJMOEZRQVUNCjAxdDBZMDAwMDA3Mkw4T1FBVQ0KMDF0MFkwMDAwMDcyTDhiUUFFDQowMXQwWTAwMDAwNzJMOGtRQUUNCjAxdDBZMDAwMDA3Mkw4b1FBRQ0KMDF0MFkwMDAwMDcyTDhzUUFFDQowMXQwWTAwMDAwNzJMOHdRQUUNCjAxdDBZMDAwMDA3Mkw5SFFBVQ0KMDF0MFkwMDAwMDcyTDlhUUFFDQowMXQwWTAwMDAwNzJMOXFRQUUNCjAxdDBZMDAwMDA3Mkw5dFFBRQ0KMDF0MFkwMDAwMDcyTDl1UUFFDQowMXQwWTAwMDAwNzJMOXZRQUUNCjAxdDBZMDAwMDA3Mkw5d1FBRQ0KMDF0MFkwMDAwMDcyTDl6UUFFDQowMXQwWTAwMDAwNzJMQTBRQU0NCjAxdDBZMDAwMDA3MkxBSFFBMg0KMDF0MFkwMDAwMDcyTEFnUUFNDQowMXQwWTAwMDAwNzJMQWtRQU0NCjAxdDBZMDAwMDA3MkxCMFFBTQ0KMDF0MFkwMDAwMDcyTEI2UUFNDQowMXQwWTAwMDAwNzJMQjhRQU0NCjAxdDBZMDAwMDA3MkxCQlFBMg0KMDF0MFkwMDAwMDcyTEJDUUEyDQowMXQwWTAwMDAwNzJMQk1RQTINCjAxdDBZMDAwMDA3MkxCTlFBMg0KMDF0MFkwMDAwMDcyTEJQUUEyDQowMXQwWTAwMDAwNzJMQlJRQTINCjAxdDBZMDAwMDA3MkxCU1FBMg0KMDF0MFkwMDAwMDcyTEJmUUFNDQowMXQwWTAwMDAwNzJMQmhRQU0NCjAxdDBZMDAwMDA3MkxCcFFBTQ0KMDF0MFkwMDAwMDcyTEJzUUFNDQowMXQwWTAwMDAwNzJMQnhRQU0NCjAxdDBZMDAwMDA3MkxCeVFBTQ0KMDF0MFkwMDAwMDcyTENCUUEyDQowMXQwWTAwMDAwNzJMQ0hRQTINCjAxdDBZMDAwMDA3MkxDTlFBMg0KMDF0MFkwMDAwMDcyTENVUUEyDQowMXQwWTAwMDAwNzJMQ1hRQTINCjAxdDBZMDAwMDA3MkxDY1FBTQ0KMDF0MFkwMDAwMDcyTENnUUFNDQowMXQwWTAwMDAwNzJMQ2xRQU0NCjAxdDBZMDAwMDA3MkxDblFBTQ0KMDF0MFkwMDAwMDcyTEN5UUFNDQowMXQwWTAwMDAwNzJMRDNRQU0NCjAxdDBZMDAwMDA3MkxESVFBMg0KMDF0MFkwMDAwMDcyTEROUUEyDQowMXQwWTAwMDAwNzJMRFhRQTINCjAxdDBZMDAwMDA3MkxEWVFBMg0KMDF0MFkwMDAwMDcyTERjUUFNDQowMXQwWTAwMDAwNzJMRGVRQU0NCjAxdDBZMDAwMDA3MkxEa1FBTQ0KMDF0MFkwMDAwMDcyTERsUUFNDQowMXQwWTAwMDAwNzJMRG1RQU0NCjAxdDBZMDAwMDA3MkxEc1FBTQ0KMDF0MFkwMDAwMDcyTER3UUFNDQowMXQwWTAwMDAwNzJMRHhRQU0NCjAxdDBZMDAwMDA3MkxFMFFBTQ0KMDF0MFkwMDAwMDcyTEU5UUFNDQowMXQwWTAwMDAwNzJMRUVRQTINCjAxdDBZMDAwMDA3MkxFRlFBMg0KMDF0MFkwMDAwMDcyTEVIUUEyDQowMXQwWTAwMDAwNzJMRU1RQTINCjAxdDBZMDAwMDA3MkxFVFFBMg0KMDF0MFkwMDAwMDcyTEVYUUEyDQowMXQwWTAwMDAwNzJMRWFRQU0NCjAxdDBZMDAwMDA3MkxFYlFBTQ0KMDF0MFkwMDAwMDcyTEVqUUFNDQowMXQwWTAwMDAwNzJMRWxRQU0NCjAxdDBZMDAwMDA3MkxFbVFBTQ0KMDF0MFkwMDAwMDcyTEV1UUFNDQowMXQwWTAwMDAwNzJMRjFRQU0NCjAxdDBZMDAwMDA3MkxGSFFBMg0KMDF0MFkwMDAwMDcyTEZRUUEyDQowMXQwWTAwMDAwNzJMRlNRQTINCjAxdDBZMDAwMDA3MkxGVVFBMg0KMDF0MFkwMDAwMDcyTEZXUUEyDQowMXQwWTAwMDAwNzJMRlhRQTINCjAxdDBZMDAwMDA3MkxGYlFBTQ0KMDF0MFkwMDAwMDcyTEZlUUFNDQowMXQwWTAwMDAwNzJMRmdRQU0NCjAxdDBZMDAwMDA3MkxHMFFBTQ0KMDF0MFkwMDAwMDcyTEdCUUEyDQowMXQwWTAwMDAwNzJMR2JRQU0NCjAxdDBZMDAwMDA3MkxHZFFBTQ0KMDF0MFkwMDAwMDcyTEdnUUFNDQowMXQwWTAwMDAwNzJMR21RQU0NCjAxdDBZMDAwMDA3MkxHblFBTQ0KMDF0MFkwMDAwMDcyTEdvUUFNDQowMXQwWTAwMDAwNzJMR3JRQU0NCjAxdDBZMDAwMDA3MkxHdFFBTQ0KMDF0MFkwMDAwMDcyTEd4UUFNDQowMXQwWTAwMDAwNzJMR3lRQU0NCjAxdDBZMDAwMDA3MkxIMVFBTQ0KMDF0MFkwMDAwMDcyTEgyUUFNDQowMXQwWTAwMDAwNzJMSDRRQU0NCjAxdDBZMDAwMDA3MkxIOVFBTQ0KMDF0MFkwMDAwMDcyTEhCUUEyDQowMXQwWTAwMDAwNzJMSEdRQTINCjAxdDBZMDAwMDA3MkxISVFBMg0KMDF0MFkwMDAwMDcyTEhKUUEyDQowMXQwWTAwMDAwNzJMSEtRQTINCjAxdDBZMDAwMDA3MkxITlFBMg0KMDF0MFkwMDAwMDcyTEhPUUEyDQowMXQwWTAwMDAwNzJMSFZRQTINCjAxdDBZMDAwMDA3MkxIcFFBTQ0KMDF0MFkwMDAwMDcyTEhyUUFNDQowMXQwWTAwMDAwNzJMSHNRQU0NCjAxdDBZMDAwMDA3MkxJN1FBTQ0KMDF0MFkwMDAwMDcyTElCUUEyDQowMXQwWTAwMDAwNzJMSUZRQTINCjAxdDBZMDAwMDA3MkxJS1FBMg0KMDF0MFkwMDAwMDcyTElUUUEyDQowMXQwWTAwMDAwNzJMSVZRQTINCjAxdDBZMDAwMDA3MkxJWlFBMg0KMDF0MFkwMDAwMDcyTElsUUFNDQowMXQwWTAwMDAwNzJMSW5RQU0NCjAxdDBZMDAwMDA3MkxJdlFBTQ0KMDF0MFkwMDAwMDcyTEo3UUFNDQowMXQwWTAwMDAwNzJMSlBRQTINCjAxdDBZMDAwMDA3MkxKUVFBMg0KMDF0MFkwMDAwMDcyTEplUUFNDQowMXQwWTAwMDAwNzJMSmZRQU0NCjAxdDBZMDAwMDA3MkxKZ1FBTQ0KMDF0MFkwMDAwMDcyTEpsUUFNDQowMXQwWTAwMDAwNzJMSm9RQU0NCjAxdDBZMDAwMDA3MkxKdVFBTQ0KMDF0MFkwMDAwMDcyTEp3UUFNDQowMXQwWTAwMDAwNzJMSzRRQU0NCjAxdDBZMDAwMDA3MkxLN1FBTQ0KMDF0MFkwMDAwMDcyTEtCUUEyDQowMXQwWTAwMDAwNzJMS1JRQTINCjAxdDBZMDAwMDA3MkxLU1FBMg0KMDF0MFkwMDAwMDcyTEtUUUEyDQowMXQwWTAwMDAwNzJMS1VRQTINCjAxdDBZMDAwMDA3MkxLWVFBMg0KMDF0MFkwMDAwMDcyTEtiUUFNDQowMXQwWTAwMDAwNzJMS2RRQU0NCjAxdDBZMDAwMDA3MkxLZVFBTQ0KMDF0MFkwMDAwMDcyTEtpUUFNDQowMXQwWTAwMDAwNzJMS2tRQU0NCjAxdDBZMDAwMDA3MkxLbFFBTQ0KMDF0MFkwMDAwMDcyTEtyUUFNDQowMXQwWTAwMDAwNzJMTDBRQU0NCjAxdDBZMDAwMDA3MkxMNFFBTQ0KMDF0MFkwMDAwMDcyTEw1UUFNDQowMXQwWTAwMDAwNzJMTFlRQTINCjAxdDBZMDAwMDA3MkxMWlFBMg0KMDF0MFkwMDAwMDcyTExkUUFNDQowMXQwWTAwMDAwNzJMTGpRQU0NCjAxdDBZMDAwMDA3MkxMdVFBTQ0KMDF0MFkwMDAwMDcyTEx2UUFNDQowMXQwWTAwMDAwNzJMTUNRQTINCjAxdDBZMDAwMDA3MkxNRFFBMg0KMDF0MFkwMDAwMDcyTE1HUUEyDQowMXQwWTAwMDAwNzJMTUlRQTINCjAxdDBZMDAwMDA3MkxNTFFBMg0KMDF0MFkwMDAwMDcyTE1OUUEyDQowMXQwWTAwMDAwNzJMTVFRQTINCjAxdDBZMDAwMDA3MkxNU1FBMg0KMDF0MFkwMDAwMDcyTE1WUUEyDQowMXQwWTAwMDAwNzJMTWVRQU0NCjAxdDBZMDAwMDA3MkxNZlFBTQ0KMDF0MFkwMDAwMDcyTE1uUUFNDQowMXQwWTAwMDAwNzJMTXVRQU0NCjAxdDBZMDAwMDA3MkxNeFFBTQ0KMDF0MFkwMDAwMDcyTE42UUFNDQowMXQwWTAwMDAwNzJMTjdRQU0NCjAxdDBZMDAwMDA3MkxOOVFBTQ0KMDF0MFkwMDAwMDcyTE5BUUEyDQowMXQwWTAwMDAwNzJMTkJRQTINCjAxdDBZMDAwMDA3MkxOQ1FBMg0KMDF0MFkwMDAwMDcyTE5IUUEyDQowMXQwWTAwMDAwNzJMTk5RQTINCjAxdDBZMDAwMDA3MkxOYlFBTQ0KMDF0MFkwMDAwMDcyTE5xUUFNDQowMXQwWTAwMDAwNzJMT1pRQTINCjAxdDBZMDAwMDA3MkxPaFFBTQ0KMDF0MFkwMDAwMDcyTE9pUUFNDQowMXQwWTAwMDAwNzJMT2tRQU0NCjAxdDBZMDAwMDA3MkxPblFBTQ0KMDF0MFkwMDAwMDcyTE9wUUFNDQowMXQwWTAwMDAwNzJMT3VRQU0NCjAxdDBZMDAwMDA3MkxPelFBTQ0KMDF0MFkwMDAwMDcyTFAxUUFNDQowMXQwWTAwMDAwNzJMUDNRQU0NCjAxdDBZMDAwMDA3MkxQOVFBTQ0KMDF0MFkwMDAwMDcyTFBBUUEyDQowMXQwWTAwMDAwNzJMUERRQTINCjAxdDBZMDAwMDA3MkxQRVFBMg0KMDF0MFkwMDAwMDcyTFBGUUEyDQowMXQwWTAwMDAwNzJMUElRQTINCjAxdDBZMDAwMDA3MkxQUVFBMg0KMDF0MFkwMDAwMDcyTFBVUUEyDQowMXQwWTAwMDAwNzJMUFZRQTINCjAxdDBZMDAwMDA3MkxQaFFBTQ0KMDF0MFkwMDAwMDcyTFBtUUFNDQowMXQwWTAwMDAwNzJMUHBRQU0NCjAxdDBZMDAwMDA3MkxQdlFBTQ0KMDF0MFkwMDAwMDcyTFFBUUEyDQowMXQwWTAwMDAwNzJMUUNRQTINCjAxdDBZMDAwMDA3MkxRRVFBMg0KMDF0MFkwMDAwMDcyTFFQUUEyDQowMXQwWTAwMDAwNzJMUVFRQTINCjAxdDBZMDAwMDA3MkxRUlFBMg0KMDF0MFkwMDAwMDcyTFFZUUEyDQowMXQwWTAwMDAwNzJMUWFRQU0NCjAxdDBZMDAwMDA3MkxRYlFBTQ0KMDF0MFkwMDAwMDcyTFF5UUFNDQowMXQwWTAwMDAwNzJMUjRRQU0NCjAxdDBZMDAwMDA3MkxSNlFBTQ0KMDF0MFkwMDAwMDcyTFJLUUEyDQowMXQwWTAwMDAwNzJMUkxRQTINCjAxdDBZMDAwMDA3MkxST1FBMg0KMDF0MFkwMDAwMDcyTFJQUUEyDQowMXQwWTAwMDAwNzJMUmdRQU0NCjAxdDBZMDAwMDA3MkxSalFBTQ0KMDF0MFkwMDAwMDcyTFJsUUFNDQowMXQwWTAwMDAwNzJMUzdRQU0NCjAxdDBZMDAwMDA3MkxTRFFBMg0KMDF0MFkwMDAwMDcyTFNGUUEyDQowMXQwWTAwMDAwNzJMU0lRQTINCjAxdDBZMDAwMDA3MkxTT1FBMg0KMDF0MFkwMDAwMDcyTFNSUUEyDQowMXQwWTAwMDAwNzJMU1NRQTINCjAxdDBZMDAwMDA3MkxTWVFBMg0KMDF0MFkwMDAwMDcyTFNaUUEyDQowMXQwWTAwMDAwNzJMU2FRQU0NCjAxdDBZMDAwMDA3MkxTYlFBTQ0KMDF0MFkwMDAwMDcyTFNqUUFNDQowMXQwWTAwMDAwNzJMU25RQU0NCjAxdDBZMDAwMDA3MkxTcFFBTQ0KMDF0MFkwMDAwMDcyTFN5UUFNDQowMXQwWTAwMDAwNzJMVEJRQTINCjAxdDBZMDAwMDA3MkxUQ1FBMg0KMDF0MFkwMDAwMDcyTFRIUUEyDQowMXQwWTAwMDAwNzJMVE1RQTINCjAxdDBZMDAwMDA3MkxUTlFBMg0KMDF0MFkwMDAwMDcyTFRSUUEyDQowMXQwWTAwMDAwNzJMVFVRQTINCjAxdDBZMDAwMDA3MkxUVlFBMg0KMDF0MFkwMDAwMDcyTFRpUUFNDQowMXQwWTAwMDAwNzJMVG5RQU0NCjAxdDBZMDAwMDA3MkxUc1FBTQ0KMDF0MFkwMDAwMDcyTFR4UUFNDQowMXQwWTAwMDAwNzJMVHlRQU0NCjAxdDBZMDAwMDA3MkxVQlFBMg0KMDF0MFkwMDAwMDcyTFVHUUEyDQowMXQwWTAwMDAwNzJMVVlRQTINCjAxdDBZMDAwMDA3MkxWMFFBTQ0KMDF0MFkwMDAwMDcyTFY0UUFNDQowMXQwWTAwMDAwNzJMVkxRQTINCjAxdDBZMDAwMDA3MkxWTlFBMg0KMDF0MFkwMDAwMDcyTFZiUUFNDQowMXQwWTAwMDAwNzJMVmRRQU0NCjAxdDBZMDAwMDA3MkxWblFBTQ0KMDF0MFkwMDAwMDcyTFZzUUFNDQowMXQwWTAwMDAwNzJMVnZRQU0NCjAxdDBZMDAwMDA3MkxWeFFBTQ0KMDF0MFkwMDAwMDcyTFc5UUFNDQowMXQwWTAwMDAwNzJMV0VRQTINCjAxdDBZMDAwMDA3MkxXTlFBMg0KMDF0MFkwMDAwMDcyTFdUUUEyDQowMXQwWTAwMDAwNzJMV1dRQTINCjAxdDBZMDAwMDA3MkxXWFFBMg0KMDF0MFkwMDAwMDcyTFdZUUEyDQowMXQwWTAwMDAwNzJMV1pRQTINCjAxdDBZMDAwMDA3MkxXYVFBTQ0KMDF0MFkwMDAwMDcyTFdiUUFNDQowMXQwWTAwMDAwNzJMV2ZRQU0NCjAxdDBZMDAwMDA3MkxXclFBTQ0KMDF0MFkwMDAwMDcyTFgxUUFNDQowMXQwWTAwMDAwNzJMWDNRQU0NCjAxdDBZMDAwMDA3MkxYR1FBMg0KMDF0MFkwMDAwMDcyTFhJUUEyDQowMXQwWTAwMDAwNzJMWE1RQTINCjAxdDBZMDAwMDA3MkxYeVFBTQ0KMDF0MFkwMDAwMDcyTFh6UUFNDQowMXQwWTAwMDAwNzJMWTBRQU0NCjAxdDBZMDAwMDA3MkxZMlFBTQ0KMDF0MFkwMDAwMDcyTFlBUUEyDQowMXQwWTAwMDAwNzJMWURRQTINCjAxdDBZMDAwMDA3MkxZR1FBMg0KMDF0MFkwMDAwMDcyTFlOUUEyDQowMXQwWTAwMDAwNzJMWWFRQU0NCjAxdDBZMDAwMDA3MkxZaVFBTQ0KMDF0MFkwMDAwMDcyTFl1UUFNDQowMXQwWTAwMDAwNzJMWXZRQU0NCjAxdDBZMDAwMDA3MkxZd1FBTQ0KMDF0MFkwMDAwMDcyTFoyUUFNDQowMXQwWTAwMDAwNzJMWjNRQU0NCjAxdDBZMDAwMDA3MkxaNFFBTQ0KMDF0MFkwMDAwMDcyTFpBUUEyDQowMXQwWTAwMDAwNzJMWkVRQTINCjAxdDBZMDAwMDA3MkxaS1FBMg0KMDF0MFkwMDAwMDcyTFpPUUEyDQowMXQwWTAwMDAwNzJMWmJRQU0NCjAxdDBZMDAwMDA3MkxaY1FBTQ0KMDF0MFkwMDAwMDcyTFpkUUFNDQowMXQwWTAwMDAwNzJMWmtRQU0NCjAxdDBZMDAwMDA3MkxadVFBTQ0KMDF0MFkwMDAwMDcyTFp2UUFNDQowMXQwWTAwMDAwNzJMWndRQU0NCjAxdDBZMDAwMDA3MkxaelFBTQ0KMDF0MFkwMDAwMDcyTGEwUUFFDQowMXQwWTAwMDAwNzJMYThRQUUNCjAxdDBZMDAwMDA3MkxhRVFBVQ0KMDF0MFkwMDAwMDcyTGFhUUFFDQowMXQwWTAwMDAwNzJMYWVRQUUNCjAxdDBZMDAwMDA3MkxhaFFBRQ0KMDF0MFkwMDAwMDcyTGFpUUFFDQowMXQwWTAwMDAwNzJMYWpRQUUNCjAxdDBZMDAwMDA3Mkxha1FBRQ0KMDF0MFkwMDAwMDcyTGFsUUFFDQowMXQwWTAwMDAwNzJMYXRRQUUNCjAxdDBZMDAwMDA3MkxhdVFBRQ0KMDF0MFkwMDAwMDcyTGF5UUFFDQowMXQwWTAwMDAwNzJMYXpRQUUNCjAxdDBZMDAwMDA3MkxiMFFBRQ0KMDF0MFkwMDAwMDcyTGIxUUFFDQowMXQwWTAwMDAwNzJMYkhRQVUNCjAxdDBZMDAwMDA3MkxiSlFBVQ0KMDF0MFkwMDAwMDcyTGJLUUFVDQowMXQwWTAwMDAwNzJMYmpRQUUNCjAxdDBZMDAwMDA3MkxibVFBRQ0KMDF0MFkwMDAwMDcyTGMxUUFFDQowMXQwWTAwMDAwNzJMY0RRQVUNCjAxdDBZMDAwMDA3MkxjR1FBVQ0KMDF0MFkwMDAwMDcyTGNWUUFVDQowMXQwWTAwMDAwNzJMY2lRQUUNCjAxdDBZMDAwMDA3MkxjbFFBRQ0KMDF0MFkwMDAwMDcyTGNvUUFFDQowMXQwWTAwMDAwNzJMY3dRQUUNCjAxdDBZMDAwMDA3MkxjeVFBRQ0KMDF0MFkwMDAwMDcyTGQwUUFFDQowMXQwWTAwMDAwNzJMZEVRQVUNCjAxdDBZMDAwMDA3MkxkS1FBVQ0KMDF0MFkwMDAwMDcyTGRNUUFVDQowMXQwWTAwMDAwNzJMZE5RQVUNCjAxdDBZMDAwMDA3MkxkUFFBVQ0KMDF0MFkwMDAwMDcyTGRRUUFVDQowMXQwWTAwMDAwNzJMZFZRQVUNCjAxdDBZMDAwMDA3MkxkYVFBRQ0KMDF0MFkwMDAwMDcyTGRiUUFFDQowMXQwWTAwMDAwNzJMZGZRQUUNCjAxdDBZMDAwMDA3MkxkbVFBRQ0KMDF0MFkwMDAwMDcyTGRuUUFFDQowMXQwWTAwMDAwNzJMZHJRQUUNCjAxdDBZMDAwMDA3MkxkdVFBRQ0KMDF0MFkwMDAwMDcyTGR2UUFFDQowMXQwWTAwMDAwNzJMZThRQUUNCjAxdDBZMDAwMDA3MkxlOVFBRQ0KMDF0MFkwMDAwMDcyTGVCUUFVDQowMXQwWTAwMDAwNzJMZUNRQVUNCjAxdDBZMDAwMDA3MkxlRFFBVQ0KMDF0MFkwMDAwMDcyTGVKUUFVDQowMXQwWTAwMDAwNzJMZXNRQUUNCjAxdDBZMDAwMDA3MkxldFFBRQ0KMDF0MFkwMDAwMDcyTGV2UUFFDQowMXQwWTAwMDAwNzJMZXdRQUUNCjAxdDBZMDAwMDA3MkxleVFBRQ0KMDF0MFkwMDAwMDcyTGV6UUFFDQowMXQwWTAwMDAwNzJMZjFRQUUNCjAxdDBZMDAwMDA3MkxmRVFBVQ0KMDF0MFkwMDAwMDcyTGZIUUFVDQowMXQwWTAwMDAwNzJMZkpRQVUNCjAxdDBZMDAwMDA3MkxmT1FBVQ0KMDF0MFkwMDAwMDcyTGZSUUFVDQowMXQwWTAwMDAwNzJMZlNRQVUNCjAxdDBZMDAwMDA3MkxmVFFBVQ0KMDF0MFkwMDAwMDcyTGZhUUFFDQowMXQwWTAwMDAwNzJMZmZRQUUNCjAxdDBZMDAwMDA3Mkxma1FBRQ0KMDF0MFkwMDAwMDcyTGZzUUFFDQowMXQwWTAwMDAwNzJMZnZRQUUNCjAxdDBZMDAwMDA3Mkxmd1FBRQ0KMDF0MFkwMDAwMDcyTGdBUUFVDQowMXQwWTAwMDAwNzJMZ0RRQVUNCjAxdDBZMDAwMDA3MkxnRlFBVQ0KMDF0MFkwMDAwMDcyTGdIUUFVDQowMXQwWTAwMDAwNzJMZ0pRQVUNCjAxdDBZMDAwMDA3MkxnVFFBVQ0KMDF0MFkwMDAwMDcyTGdWUUFVDQowMXQwWTAwMDAwNzJMZ1dRQVUNCjAxdDBZMDAwMDA3MkxnYVFBRQ0KMDF0MFkwMDAwMDcyTGdtUUFFDQowMXQwWTAwMDAwNzJMZ3FRQUUNCjAxdDBZMDAwMDA3MkxndVFBRQ0KMDF0MFkwMDAwMDcyTGgxUUFFDQowMXQwWTAwMDAwNzJMaDlRQUUNCjAxdDBZMDAwMDA3MkxoRFFBVQ0KMDF0MFkwMDAwMDcyTGhiUUFFDQowMXQwWTAwMDAwNzJMaGZRQUUNCjAxdDBZMDAwMDA3Mkxoa1FBRQ0KMDF0MFkwMDAwMDcyTGhtUUFFDQowMXQwWTAwMDAwNzJMaHJRQUUNCjAxdDBZMDAwMDA3Mkxod1FBRQ0KMDF0MFkwMDAwMDcyTGh4UUFFDQowMXQwWTAwMDAwNzJMaHpRQUUNCjAxdDBZMDAwMDA3MkxpNVFBRQ0KMDF0MFkwMDAwMDcyTGlEUUFVDQowMXQwWTAwMDAwNzJMaUdRQVUNCjAxdDBZMDAwMDA3MkxpSFFBVQ0KMDF0MFkwMDAwMDcyTGlLUUFVDQowMXQwWTAwMDAwNzJMaUxRQVUNCjAxdDBZMDAwMDA3MkxpTlFBVQ0KMDF0MFkwMDAwMDcyTGlSUUFVDQowMXQwWTAwMDAwNzJMaVZRQVUNCjAxdDBZMDAwMDA3MkxpWFFBVQ0KMDF0MFkwMDAwMDcyTGlaUUFVDQowMXQwWTAwMDAwNzJMaWlRQUUNCjAxdDBZMDAwMDA3MkxpalFBRQ0KMDF0MFkwMDAwMDcyTGlsUUFFDQowMXQwWTAwMDAwNzJMaXpRQUUNCjAxdDBZMDAwMDA3MkxqSFFBVQ0KMDF0MFkwMDAwMDcyTGphUUFFDQowMXQwWTAwMDAwNzJMamZRQUUNCjAxdDBZMDAwMDA3MkxqZ1FBRQ0KMDF0MFkwMDAwMDcyTGpqUUFFDQowMXQwWTAwMDAwNzJMamxRQUUNCjAxdDBZMDAwMDA3MkxqblFBRQ0KMDF0MFkwMDAwMDcyTGtFUUFVDQowMXQwWTAwMDAwNzJMa1dRQVUNCjAxdDBZMDAwMDA3MkxrdFFBRQ0KMDF0MFkwMDAwMDcyTGt1UUFFDQowMXQwWTAwMDAwNzJMbERRQVUNCjAxdDBZMDAwMDA3MkxsRVFBVQ0KMDF0MFkwMDAwMDcyTGxHUUFVDQowMXQwWTAwMDAwNzJMbEhRQVUNCjAxdDBZMDAwMDA3MkxsSVFBVQ0KMDF0MFkwMDAwMDcyTGxLUUFVDQowMXQwWTAwMDAwNzJMbExRQVUNCjAxdDBZMDAwMDA3MkxsTVFBVQ0KMDF0MFkwMDAwMDcyTGxOUUFVDQowMXQwWTAwMDAwNzJMbGRRQUUNCjAxdDBZMDAwMDA3MkxscFFBRQ0KMDF0MFkwMDAwMDcyTGxxUUFFDQowMXQwWTAwMDAwNzJMbHVRQUUNCjAxdDBZMDAwMDA3MkxsdlFBRQ0KMDF0MFkwMDAwMDcyTG1TUUFVDQowMXQwWTAwMDAwNzJMbVZRQVUNCjAxdDBZMDAwMDA3MkxtalFBRQ0KMDF0MFkwMDAwMDcyTG1tUUFFDQowMXQwWTAwMDAwNzJMbW9RQUUNCjAxdDBZMDAwMDA3MkxtcVFBRQ0KMDF0MFkwMDAwMDcyTG1zUUFFDQowMXQwWTAwMDAwNzJMbXRRQUUNCjAxdDBZMDAwMDA3MkxtdVFBRQ0KMDF0MFkwMDAwMDcyTG12UUFFDQowMXQwWTAwMDAwNzJMbXdRQUUNCjAxdDBZMDAwMDA3MkxteFFBRQ0KMDF0MFkwMDAwMDcyTG4xUUFFDQowMXQwWTAwMDAwNzJMbjVRQUUNCjAxdDBZMDAwMDA3MkxuNlFBRQ0KMDF0MFkwMDAwMDcyTG44UUFFDQowMXQwWTAwMDAwNzJMbkVRQVUNCjAxdDBZMDAwMDA3MkxuSFFBVQ0KMDF0MFkwMDAwMDcyTG5MUUFVDQowMXQwWTAwMDAwNzJMbmRRQUUNCjAxdDBZMDAwMDA3Mkxub1FBRQ0KMDF0MFkwMDAwMDcyTG9EUUFVDQowMXQwWTAwMDAwNzJMb0VRQVUNCjAxdDBZMDAwMDA3MkxvRlFBVQ0KMDF0MFkwMDAwMDcyTG9MUUFVDQowMXQwWTAwMDAwNzJMb1ZRQVUNCjAxdDBZMDAwMDA3MkxvZFFBRQ0KMDF0MFkwMDAwMDcyTG9mUUFFDQowMXQwWTAwMDAwNzJMb2dRQUUNCjAxdDBZMDAwMDA3Mkxva1FBRQ0KMDF0MFkwMDAwMDcyTG9tUUFFDQowMXQwWTAwMDAwNzJMb29RQUUNCjAxdDBZMDAwMDA3MkxvcFFBRQ0KMDF0MFkwMDAwMDcyTG9zUUFFDQowMXQwWTAwMDAwNzJMb3ZRQUUNCjAxdDBZMDAwMDA3MkxveVFBRQ0KMDF0MFkwMDAwMDcyTHBCUUFVDQowMXQwWTAwMDAwNzJMcElRQVUNCjAxdDBZMDAwMDA3MkxwS1FBVQ0KMDF0MFkwMDAwMDcyTHBOUUFVDQowMXQwWTAwMDAwNzJMcGRRQUUNCjAxdDBZMDAwMDA3Mkxwb1FBRQ0KMDF0MFkwMDAwMDcyTHBzUUFFDQowMXQwWTAwMDAwNzJMcHVRQUUNCjAxdDBZMDAwMDA3MkxxM1FBRQ0KMDF0MFkwMDAwMDcyTHE0UUFFDQowMXQwWTAwMDAwNzJMcTZRQUUNCjAxdDBZMDAwMDA3MkxxN1FBRQ0KMDF0MFkwMDAwMDcyTHE5UUFFDQowMXQwWTAwMDAwNzJMcUFRQVUNCjAxdDBZMDAwMDA3MkxxRVFBVQ0KMDF0MFkwMDAwMDcyTHFHUUFVDQowMXQwWTAwMDAwNzJMcUtRQVUNCjAxdDBZMDAwMDA3MkxxTVFBVQ0KMDF0MFkwMDAwMDcyTHFaUUFVDQowMXQwWTAwMDAwNzJMcWFRQUUNCjAxdDBZMDAwMDA3MkxxY1FBRQ0KMDF0MFkwMDAwMDcyTHFrUUFFDQowMXQwWTAwMDAwNzJMcWxRQUUNCjAxdDBZMDAwMDA3MkxxeVFBRQ0KMDF0MFkwMDAwMDcyTHIzUUFFDQowMXQwWTAwMDAwNzJMckVRQVUNCjAxdDBZMDAwMDA3MkxyRlFBVQ0KMDF0MFkwMDAwMDcyTHJIUUFVDQowMXQwWTAwMDAwNzJMckxRQVUNCjAxdDBZMDAwMDA3MkxyTVFBVQ0KMDF0MFkwMDAwMDcyTHJTUUFVDQowMXQwWTAwMDAwNzJMcmJRQUUNCjAxdDBZMDAwMDA3MkxydlFBRQ0KMDF0MFkwMDAwMDcyTHJ4UUFFDQowMXQwWTAwMDAwNzJMczBRQUUNCjAxdDBZMDAwMDA3MkxzNFFBRQ0KMDF0MFkwMDAwMDcyTHM4UUFFDQowMXQwWTAwMDAwNzJMc29RQUUNCjAxdDBZMDAwMDA3Mkx0MVFBRQ0KMDF0MFkwMDAwMDcyTHQyUUFFDQowMXQwWTAwMDAwNzJMdDRRQUUNCjAxdDBZMDAwMDA3Mkx0OFFBRQ0KMDF0MFkwMDAwMDcyTHRBUUFVDQowMXQwWTAwMDAwNzJMdERRQVUNCjAxdDBZMDAwMDA3Mkx0UVFBVQ0KMDF0MFkwMDAwMDcyTHRqUUFFDQowMXQwWTAwMDAwNzJMdG1RQUUNCjAxdDBZMDAwMDA3Mkx0clFBRQ0KMDF0MFkwMDAwMDcyTHR2UUFFDQowMXQwWTAwMDAwNzJMdTJRQUUNCjAxdDBZMDAwMDA3Mkx1M1FBRQ0KMDF0MFkwMDAwMDcyTHU4UUFFDQowMXQwWTAwMDAwNzJMdUFRQVUNCjAxdDBZMDAwMDA3Mkx1RFFBVQ0KMDF0MFkwMDAwMDcyTHVHUUFVDQowMXQwWTAwMDAwNzJMdUhRQVUNCjAxdDBZMDAwMDA3Mkx1SlFBVQ0KMDF0MFkwMDAwMDcyTHVQUUFVDQowMXQwWTAwMDAwNzJMdW5RQUUNCjAxdDBZMDAwMDA3Mkx1cVFBRQ0KMDF0MFkwMDAwMDcyTHV1UUFFDQowMXQwWTAwMDAwNzJMdXlRQUUNCjAxdDBZMDAwMDA3Mkx2NVFBRQ0KMDF0MFkwMDAwMDcyTHZDUUFVDQowMXQwWTAwMDAwNzJMdkxRQVUNCjAxdDBZMDAwMDA3Mkx2TlFBVQ0KMDF0MFkwMDAwMDcyTHZPUUFVDQowMXQwWTAwMDAwNzJMdmNRQUUNCjAxdDBZMDAwMDA3Mkx2ZlFBRQ0KMDF0MFkwMDAwMDcyTHZqUUFFDQowMXQwWTAwMDAwNzJMdmtRQUUNCjAxdDBZMDAwMDA3Mkx2bFFBRQ0KMDF0MFkwMDAwMDcyTHZtUUFFDQowMXQwWTAwMDAwNzJMdm5RQUUNCjAxdDBZMDAwMDA3Mkx2dFFBRQ0KMDF0MFkwMDAwMDcyTHZ2UUFFDQowMXQwWTAwMDAwNzJMdzNRQUUNCjAxdDBZMDAwMDA3Mkx3OFFBRQ0KMDF0MFkwMDAwMDcyTHc5UUFFDQowMXQwWTAwMDAwNzJMd0JRQVUNCjAxdDBZMDAwMDA3Mkx3Q1FBVQ0KMDF0MFkwMDAwMDcyTHdEUUFVDQowMXQwWTAwMDAwNzJMd0ZRQVUNCjAxdDBZMDAwMDA3Mkx3U1FBVQ0KMDF0MFkwMDAwMDcyTHdiUUFFDQowMXQwWTAwMDAwNzJMd21RQUUNCjAxdDBZMDAwMDA3Mkx3blFBRQ0KMDF0MFkwMDAwMDcyTHdyUUFFDQowMXQwWTAwMDAwNzJMd3NRQUUNCjAxdDBZMDAwMDA3Mkx3eFFBRQ0KMDF0MFkwMDAwMDcyTHgwUUFFDQowMXQwWTAwMDAwNzJMeDRRQUUNCjAxdDBZMDAwMDA3Mkx4NVFBRQ0KMDF0MFkwMDAwMDcyTHhEUUFVDQowMXQwWTAwMDAwNzJMeEpRQVUNCjAxdDBZMDAwMDA3Mkx4S1FBVQ0KMDF0MFkwMDAwMDcyTHhNUUFVDQowMXQwWTAwMDAwNzJMeGdRQUUNCjAxdDBZMDAwMDA3Mkx4bVFBRQ0KMDF0MFkwMDAwMDcyTHhuUUFFDQowMXQwWTAwMDAwNzJMeHFRQUUNCjAxdDBZMDAwMDA3Mkx4c1FBRQ0KMDF0MFkwMDAwMDcyTHh0UUFFDQowMXQwWTAwMDAwNzJMeHVRQUUNCjAxdDBZMDAwMDA3Mkx4d1FBRQ0KMDF0MFkwMDAwMDcyTHh5UUFFDQowMXQwWTAwMDAwNzJMeTBRQUUNCjAxdDBZMDAwMDA3Mkx5M1FBRQ0KMDF0MFkwMDAwMDcyTHlDUUFVDQowMXQwWTAwMDAwNzJMeURRQVUNCjAxdDBZMDAwMDA3Mkx5R1FBVQ0KMDF0MFkwMDAwMDcyTHlIUUFVDQowMXQwWTAwMDAwNzJMeUpRQVUNCjAxdDBZMDAwMDA3Mkx5TFFBVQ0KMDF0MFkwMDAwMDcyTHlQUUFVDQowMXQwWTAwMDAwNzJMeVVRQVUNCjAxdDBZMDAwMDA3Mkx5VlFBVQ0KMDF0MFkwMDAwMDcyTHliUUFFDQowMXQwWTAwMDAwNzJMeWRRQUUNCjAxdDBZMDAwMDA3Mkx5aFFBRQ0KMDF0MFkwMDAwMDcyTHlrUUFFDQowMXQwWTAwMDAwNzJMeW1RQUUNCjAxdDBZMDAwMDA3Mkx5blFBRQ0KMDF0MFkwMDAwMDcyTHo3UUFFDQowMXQwWTAwMDAwNzJMekJRQVUNCjAxdDBZMDAwMDA3Mkx6SVFBVQ0KMDF0MFkwMDAwMDcyTHpKUUFVDQowMXQwWTAwMDAwNzJMelhRQVUNCjAxdDBZMDAwMDA3Mkx6ZVFBRQ0KMDF0MFkwMDAwMDcyTTA4UUFFDQowMXQwWTAwMDAwNzJNMDlRQUUNCjAxdDBZMDAwMDA3Mk0wQ1FBVQ0KMDF0MFkwMDAwMDcyTTBGUUFVDQowMXQwWTAwMDAwNzJNMEdRQVUNCjAxdDBZMDAwMDA3Mk0wSVFBVQ0KMDF0MFkwMDAwMDcyTTBNUUFVDQowMXQwWTAwMDAwNzJNME5RQVUNCjAxdDBZMDAwMDA3Mk0wUlFBVQ0KMDF0MFkwMDAwMDcyTTBUUUFVDQowMXQwWTAwMDAwNzJNMFdRQVUNCjAxdDBZMDAwMDA3Mk0xM1FBRQ0KMDF0MFkwMDAwMDcyTTE1UUFFDQowMXQwWTAwMDAwNzJNMUdRQVUNCjAxdDBZMDAwMDA3Mk0xTlFBVQ0KMDF0MFkwMDAwMDcyTTFPUUFVDQowMXQwWTAwMDAwNzJNMVBRQVUNCjAxdDBZMDAwMDA3Mk0xVFFBVQ0KMDF0MFkwMDAwMDcyTTFaUUFVDQowMXQwWTAwMDAwNzJNMWNRQUUNCjAxdDBZMDAwMDA3Mk0xZVFBRQ0KMDF0MFkwMDAwMDcyTTFmUUFFDQowMXQwWTAwMDAwNzJNMW1RQUUNCjAxdDBZMDAwMDA3Mk0xcFFBRQ0KMDF0MFkwMDAwMDcyTTF2UUFFDQowMXQwWTAwMDAwNzJNMXpRQUUNCjAxdDBZMDAwMDA3Mk0yNlFBRQ0KMDF0MFkwMDAwMDcyTTJBUUFVDQowMXQwWTAwMDAwNzJNMlBRQVUNCjAxdDBZMDAwMDA3Mk0yUVFBVQ0KMDF0MFkwMDAwMDcyTTJYUUFVDQowMXQwWTAwMDAwNzJNMllRQVUNCjAxdDBZMDAwMDA3Mk0yYlFBRQ0KMDF0MFkwMDAwMDcyTTJlUUFFDQowMXQwWTAwMDAwNzJNMmZRQUUNCjAxdDBZMDAwMDA3Mk0yaFFBRQ0KMDF0MFkwMDAwMDcyTTJpUUFFDQowMXQwWTAwMDAwNzJNMm1RQUUNCjAxdDBZMDAwMDA3Mk0zNlFBRQ0KMDF0MFkwMDAwMDcyTTNEUUFVDQowMXQwWTAwMDAwNzJNM0ZRQVUNCjAxdDBZMDAwMDA3Mk0zSVFBVQ0KMDF0MFkwMDAwMDcyTTNMUUFVDQowMXQwWTAwMDAwNzJNM01RQVUNCjAxdDBZMDAwMDA3Mk0zUVFBVQ0KMDF0MFkwMDAwMDcyTTNZUUFVDQowMXQwWTAwMDAwNzJNM1pRQVUNCjAxdDBZMDAwMDA3Mk0zYlFBRQ0KMDF0MFkwMDAwMDcyTTNjUUFFDQowMXQwWTAwMDAwNzJNM2lRQUUNCjAxdDBZMDAwMDA3Mk0zalFBRQ0KMDF0MFkwMDAwMDcyTTN4UUFFDQowMXQwWTAwMDAwNzJNNDVRQUUNCjAxdDBZMDAwMDA3Mk00TlFBVQ0KMDF0MFkwMDAwMDcyTTRPUUFVDQowMXQwWTAwMDAwNzJNNGpRQUUNCjAxdDBZMDAwMDA3Mk00b1FBRQ0KMDF0MFkwMDAwMDcyTTUxUUFFDQowMXQwWTAwMDAwNzJNNTJRQUUNCjAxdDBZMDAwMDA3Mk01NVFBRQ0KMDF0MFkwMDAwMDcyTTU2UUFFDQowMXQwWTAwMDAwNzJNNTlRQUUNCjAxdDBZMDAwMDA3Mk01RVFBVQ0KMDF0MFkwMDAwMDcyTTVLUUFVDQowMXQwWTAwMDAwNzJNNUxRQVUNCjAxdDBZMDAwMDA3Mk01T1FBVQ0KMDF0MFkwMDAwMDcyTTVTUUFVDQowMXQwWTAwMDAwNzJNNVVRQVUNCjAxdDBZMDAwMDA3Mk01VlFBVQ0KMDF0MFkwMDAwMDcyTTVXUUFVDQowMXQwWTAwMDAwNzJNNWFRQUUNCjAxdDBZMDAwMDA3Mk01aFFBRQ0KMDF0MFkwMDAwMDcyTTVxUUFFDQowMXQwWTAwMDAwNzJNNXJRQUUNCjAxdDBZMDAwMDA3Mk01d1FBRQ0KMDF0MFkwMDAwMDcyTTYxUUFFDQowMXQwWTAwMDAwNzJNNjZRQUUNCjAxdDBZMDAwMDA3Mk02Q1FBVQ0KMDF0MFkwMDAwMDcyTTZGUUFVDQowMXQwWTAwMDAwNzJNNmxRQUUNCjAxdDBZMDAwMDA3Mk02bVFBRQ0KMDF0MFkwMDAwMDcyTTZ3UUFFDQowMXQwWTAwMDAwNzJNNnhRQUUNCjAxdDBZMDAwMDA3Mk02eVFBRQ0KMDF0MFkwMDAwMDcyTTZ6UUFFDQowMXQwWTAwMDAwNzJNNzFRQUUNCjAxdDBZMDAwMDA3Mk03NFFBRQ0KMDF0MFkwMDAwMDcyTTc4UUFFDQowMXQwWTAwMDAwNzJNN0dRQVUNCjAxdDBZMDAwMDA3Mk03SFFBVQ0KMDF0MFkwMDAwMDcyTTdLUUFVDQowMXQwWTAwMDAwNzJNN09RQVUNCjAxdDBZMDAwMDA3Mk03UVFBVQ0KMDF0MFkwMDAwMDcyTTdVUUFVDQowMXQwWTAwMDAwNzJNN2NRQUUNCjAxdDBZMDAwMDA3Mk03a1FBRQ0KMDF0MFkwMDAwMDcyTTduUUFFDQowMXQwWTAwMDAwNzJNN3FRQUUNCjAxdDBZMDAwMDA3Mk03eFFBRQ0KMDF0MFkwMDAwMDcyTTgwUUFFDQowMXQwWTAwMDAwNzJNODFRQUUNCjAxdDBZMDAwMDA3Mk04SFFBVQ0KMDF0MFkwMDAwMDcyTThOUUFVDQowMXQwWTAwMDAwNzJNOFFRQVUNCjAxdDBZMDAwMDA3Mk04UlFBVQ0KMDF0MFkwMDAwMDcyTThUUUFVDQowMXQwWTAwMDAwNzJNOFVRQVUNCjAxdDBZMDAwMDA3Mk04VlFBVQ0KMDF0MFkwMDAwMDcyTThYUUFVDQowMXQwWTAwMDAwNzJNOFlRQVUNCjAxdDBZMDAwMDA3Mk04WlFBVQ0KMDF0MFkwMDAwMDcyTThhUUFFDQowMXQwWTAwMDAwNzJNOGNRQUUNCjAxdDBZMDAwMDA3Mk04Z1FBRQ0KMDF0MFkwMDAwMDcyTThrUUFFDQowMXQwWTAwMDAwNzJNOGxRQUUNCjAxdDBZMDAwMDA3Mk04bVFBRQ0KMDF0MFkwMDAwMDcyTThuUUFFDQowMXQwWTAwMDAwNzJNOHBRQUUNCjAxdDBZMDAwMDA3Mk04dFFBRQ0KMDF0MFkwMDAwMDcyTTh1UUFFDQowMXQwWTAwMDAwNzJNOTVRQUUNCjAxdDBZMDAwMDA3Mk05OVFBRQ0KMDF0MFkwMDAwMDcyTTlGUUFVDQowMXQwWTAwMDAwNzJNOU5RQVUNCjAxdDBZMDAwMDA3Mk05UFFBVQ0KMDF0MFkwMDAwMDcyTTlXUUFVDQowMXQwWTAwMDAwNzJNOVhRQVUNCjAxdDBZMDAwMDA3Mk05YVFBRQ0KMDF0MFkwMDAwMDcyTTliUUFFDQowMXQwWTAwMDAwNzJNOWVRQUUNCjAxdDBZMDAwMDA3Mk05ZlFBRQ0KMDF0MFkwMDAwMDcyTTlnUUFFDQowMXQwWTAwMDAwNzJNOWpRQUUNCjAxdDBZMDAwMDA3Mk05a1FBRQ0KMDF0MFkwMDAwMDcyTTltUUFFDQowMXQwWTAwMDAwNzJNOXBRQUUNCjAxdDBZMDAwMDA3Mk05clFBRQ0KMDF0MFkwMDAwMDcyTTlzUUFFDQowMXQwWTAwMDAwNzJNOXRRQUUNCjAxdDBZMDAwMDA3Mk1BV1FBMg0KMDF0MFkwMDAwMDcyTUFZUUEyDQowMXQwWTAwMDAwNzJNQWVRQU0NCjAxdDBZMDAwMDA3Mk1BaFFBTQ0KMDF0MFkwMDAwMDcyTUFqUUFNDQowMXQwWTAwMDAwNzJNQXdRQU0NCjAxdDBZMDAwMDA3Mk1CNFFBTQ0KMDF0MFkwMDAwMDcyTUJFUUEyDQowMXQwWTAwMDAwNzJNQktRQTINCjAxdDBZMDAwMDA3Mk1CUFFBMg0KMDF0MFkwMDAwMDcyTUJRUUEyDQowMXQwWTAwMDAwNzJNQm5RQU0NCjAxdDBZMDAwMDA3Mk1Cb1FBTQ0KMDF0MFkwMDAwMDcyTUJ5UUFNDQowMXQwWTAwMDAwNzJNQzNRQU0NCjAxdDBZMDAwMDA3Mk1DNVFBTQ0KMDF0MFkwMDAwMDcyTUM5UUFNDQowMXQwWTAwMDAwNzJNQ0JRQTINCjAxdDBZMDAwMDA3Mk1DRVFBMg0KMDF0MFkwMDAwMDcyTUNGUUEyDQowMXQwWTAwMDAwNzJNQ0dRQTINCjAxdDBZMDAwMDA3Mk1DSFFBMg0KMDF0MFkwMDAwMDcyTUNLUUEyDQowMXQwWTAwMDAwNzJNQ0xRQTINCjAxdDBZMDAwMDA3Mk1DTlFBMg0KMDF0MFkwMDAwMDcyTUNPUUEyDQowMXQwWTAwMDAwNzJNQ1BRQTINCjAxdDBZMDAwMDA3Mk1DUlFBMg0KMDF0MFkwMDAwMDcyTUNVUUEyDQowMXQwWTAwMDAwNzJNQ2JRQU0NCjAxdDBZMDAwMDA3Mk1EMFFBTQ0KMDF0MFkwMDAwMDcyTURRUUEyDQowMXQwWTAwMDAwNzJNRFdRQTINCjAxdDBZMDAwMDA3Mk1EWlFBMg0KMDF0MFkwMDAwMDcyTURjUUFNDQowMXQwWTAwMDAwNzJNRGZRQU0NCjAxdDBZMDAwMDA3Mk1EaFFBTQ0KMDF0MFkwMDAwMDcyTURqUUFNDQowMXQwWTAwMDAwNzJNRGtRQU0NCjAxdDBZMDAwMDA3Mk1Eb1FBTQ0KMDF0MFkwMDAwMDcyTUR3UUFNDQowMXQwWTAwMDAwNzJNRTBRQU0NCjAxdDBZMDAwMDA3Mk1FMlFBTQ0KMDF0MFkwMDAwMDcyTUUzUUFNDQowMXQwWTAwMDAwNzJNRTRRQU0NCjAxdDBZMDAwMDA3Mk1FNVFBTQ0KMDF0MFkwMDAwMDcyTUU2UUFNDQowMXQwWTAwMDAwNzJNRTdRQU0NCjAxdDBZMDAwMDA3Mk1FOFFBTQ0KMDF0MFkwMDAwMDcyTUVBUUEyDQowMXQwWTAwMDAwNzJNRUJRQTINCjAxdDBZMDAwMDA3Mk1FQ1FBMg0KMDF0MFkwMDAwMDcyTUVEUUEyDQowMXQwWTAwMDAwNzJNRUpRQTINCjAxdDBZMDAwMDA3Mk1FUVFBMg0KMDF0MFkwMDAwMDcyTUVTUUEyDQowMXQwWTAwMDAwNzJNRVhRQTINCjAxdDBZMDAwMDA3Mk1FbFFBTQ0KMDF0MFkwMDAwMDcyTUV6UUFNDQowMXQwWTAwMDAwNzJNRjBRQU0NCjAxdDBZMDAwMDA3Mk1GMlFBTQ0KMDF0MFkwMDAwMDcyTUZCUUEyDQowMXQwWTAwMDAwNzJNRkNRQTINCjAxdDBZMDAwMDA3Mk1GRFFBMg0KMDF0MFkwMDAwMDcyTUZFUUEyDQowMXQwWTAwMDAwNzJNRkZRQTINCjAxdDBZMDAwMDA3Mk1GSFFBMg0KMDF0MFkwMDAwMDcyTUZJUUEyDQowMXQwWTAwMDAwNzJNRk1RQTINCjAxdDBZMDAwMDA3Mk1GU1FBMg0KMDF0MFkwMDAwMDcyTUZsUUFNDQowMXQwWTAwMDAwNzJNRnhRQU0NCjAxdDBZMDAwMDA3Mk1HNFFBTQ0KMDF0MFkwMDAwMDcyTUdjUUFNDQowMXQwWTAwMDAwNzJNR2tRQU0NCjAxdDBZMDAwMDA3Mk1HeVFBTQ0KMDF0MFkwMDAwMDcyTUgxUUFNDQowMXQwWTAwMDAwNzJNSDdRQU0NCjAxdDBZMDAwMDA3Mk1IQVFBMg0KMDF0MFkwMDAwMDcyTUhJUUEyDQowMXQwWTAwMDAwNzJNSE1RQTINCjAxdDBZMDAwMDA3Mk1IU1FBMg0KMDF0MFkwMDAwMDcyTUhXUUEyDQowMXQwWTAwMDAwNzJNSFhRQTINCjAxdDBZMDAwMDA3Mk1IWVFBMg0KMDF0MFkwMDAwMDcyTUhnUUFNDQowMXQwWTAwMDAwNzJNSGhRQU0NCjAxdDBZMDAwMDA3Mk1IalFBTQ0KMDF0MFkwMDAwMDcyTUhrUUFNDQowMXQwWTAwMDAwNzJNSGxRQU0NCjAxdDBZMDAwMDA3Mk1Ib1FBTQ0KMDF0MFkwMDAwMDcyTUhxUUFNDQowMXQwWTAwMDAwNzJNSHdRQU0NCjAxdDBZMDAwMDA3Mk1IeVFBTQ0KMDF0MFkwMDAwMDcyTUh6UUFNDQowMXQwWTAwMDAwNzJNSTFRQU0NCjAxdDBZMDAwMDA3Mk1JNVFBTQ0KMDF0MFkwMDAwMDcyTUk5UUFNDQowMXQwWTAwMDAwNzJNSUVRQTINCjAxdDBZMDAwMDA3Mk1JR1FBMg0KMDF0MFkwMDAwMDcyTUlOUUEyDQowMXQwWTAwMDAwNzJNSWtRQU0NCjAxdDBZMDAwMDA3Mk1JbVFBTQ0KMDF0MFkwMDAwMDcyTUlxUUFNDQowMXQwWTAwMDAwNzJNSXJRQU0NCjAxdDBZMDAwMDA3Mk1KM1FBTQ0KMDF0MFkwMDAwMDcyTUo1UUFNDQowMXQwWTAwMDAwNzJNSjhRQU0NCjAxdDBZMDAwMDA3Mk1KOVFBTQ0KMDF0MFkwMDAwMDcyTUpBUUEyDQowMXQwWTAwMDAwNzJNSkRRQTINCjAxdDBZMDAwMDA3Mk1KRVFBMg0KMDF0MFkwMDAwMDcyTUpHUUEyDQowMXQwWTAwMDAwNzJNSklRQTINCjAxdDBZMDAwMDA3Mk1KTlFBMg0KMDF0MFkwMDAwMDcyTUplUUFNDQowMXQwWTAwMDAwNzJNSmdRQU0NCjAxdDBZMDAwMDA3Mk1KaVFBTQ0KMDF0MFkwMDAwMDcyTUpyUUFNDQowMXQwWTAwMDAwNzJNSzRRQU0NCjAxdDBZMDAwMDA3Mk1LNVFBTQ0KMDF0MFkwMDAwMDcyTUs5UUFNDQowMXQwWTAwMDAwNzJNS0JRQTINCjAxdDBZMDAwMDA3Mk1LRlFBMg0KMDF0MFkwMDAwMDcyTUtNUUEyDQowMXQwWTAwMDAwNzJNS1RRQTINCjAxdDBZMDAwMDA3Mk1LWVFBMg0KMDF0MFkwMDAwMDcyTUtoUUFNDQowMXQwWTAwMDAwNzJNS3RRQU0NCjAxdDBZMDAwMDA3Mk1LeFFBTQ0KMDF0MFkwMDAwMDcyTUt5UUFNDQowMXQwWTAwMDAwNzJNS3pRQU0NCjAxdDBZMDAwMDA3Mk1MNVFBTQ0KMDF0MFkwMDAwMDcyTUw4UUFNDQowMXQwWTAwMDAwNzJNTEFRQTINCjAxdDBZMDAwMDA3Mk1MQlFBMg0KMDF0MFkwMDAwMDcyTUxFUUEyDQowMXQwWTAwMDAwNzJNTEdRQTINCjAxdDBZMDAwMDA3Mk1MSVFBMg0KMDF0MFkwMDAwMDcyTUxNUUEyDQowMXQwWTAwMDAwNzJNTE5RQTINCjAxdDBZMDAwMDA3Mk1MT1FBMg0KMDF0MFkwMDAwMDcyTUxRUUEyDQowMXQwWTAwMDAwNzJNTFZRQTINCjAxdDBZMDAwMDA3Mk1MZVFBTQ0KMDF0MFkwMDAwMDcyTUxqUUFNDQowMXQwWTAwMDAwNzJNTHZRQU0NCjAxdDBZMDAwMDA3Mk1NMlFBTQ0KMDF0MFkwMDAwMDcyTU02UUFNDQowMXQwWTAwMDAwNzJNTThRQU0NCjAxdDBZMDAwMDA3Mk1NSlFBMg0KMDF0MFkwMDAwMDcyTU1LUUEyDQowMXQwWTAwMDAwNzJNTU5RQTINCjAxdDBZMDAwMDA3Mk1NUFFBMg0KMDF0MFkwMDAwMDcyTU1hUUFNDQowMXQwWTAwMDAwNzJNTWVRQU0NCjAxdDBZMDAwMDA3Mk1NZlFBTQ0KMDF0MFkwMDAwMDcyTU1pUUFNDQowMXQwWTAwMDAwNzJNTjJRQU0NCjAxdDBZMDAwMDA3Mk1OOFFBTQ0KMDF0MFkwMDAwMDcyTU45UUFNDQowMXQwWTAwMDAwNzJNTkVRQTINCjAxdDBZMDAwMDA3Mk1OTFFBMg0KMDF0MFkwMDAwMDcyTU5NUUEyDQowMXQwWTAwMDAwNzJNTk9RQTINCjAxdDBZMDAwMDA3Mk1OUlFBMg0KMDF0MFkwMDAwMDcyTU5XUUEyDQowMXQwWTAwMDAwNzJNTmFRQU0NCjAxdDBZMDAwMDA3Mk1OY1FBTQ0KMDF0MFkwMDAwMDcyTU5mUUFNDQowMXQwWTAwMDAwNzJNTnFRQU0NCjAxdDBZMDAwMDA3Mk1Od1FBTQ0KMDF0MFkwMDAwMDcyTU54UUFNDQowMXQwWTAwMDAwNzJNTzBRQU0NCjAxdDBZMDAwMDA3Mk1PNVFBTQ0KMDF0MFkwMDAwMDcyTU9EUUEyDQowMXQwWTAwMDAwNzJNT0VRQTINCjAxdDBZMDAwMDA3Mk1PS1FBMg0KMDF0MFkwMDAwMDcyTU9TUUEyDQowMXQwWTAwMDAwNzJNT1dRQTINCjAxdDBZMDAwMDA3Mk1PYlFBTQ0KMDF0MFkwMDAwMDcyTU9kUUFNDQowMXQwWTAwMDAwNzJNT2VRQU0NCjAxdDBZMDAwMDA3Mk1PaFFBTQ0KMDF0MFkwMDAwMDcyTU9rUUFNDQowMXQwWTAwMDAwNzJNT2xRQU0NCjAxdDBZMDAwMDA3Mk1QMVFBTQ0KMDF0MFkwMDAwMDcyTVAzUUFNDQowMXQwWTAwMDAwNzJNUDRRQU0NCjAxdDBZMDAwMDA3Mk1QNVFBTQ0KMDF0MFkwMDAwMDcyTVA4UUFNDQowMXQwWTAwMDAwNzJNUDlRQU0NCjAxdDBZMDAwMDA3Mk1QQVFBMg0KMDF0MFkwMDAwMDcyTVBEUUEyDQowMXQwWTAwMDAwNzJNUEVRQTINCjAxdDBZMDAwMDA3Mk1QRlFBMg0KMDF0MFkwMDAwMDcyTVBIUUEyDQowMXQwWTAwMDAwNzJNUElRQTINCjAxdDBZMDAwMDA3Mk1QS1FBMg0KMDF0MFkwMDAwMDcyTVBMUUEyDQowMXQwWTAwMDAwNzJNUE5RQTINCjAxdDBZMDAwMDA3Mk1QU1FBMg0KMDF0MFkwMDAwMDcyTVE0UUFNDQowMXQwWTAwMDAwNzJNUTVRQU0NCjAxdDBZMDAwMDA3Mk1RQ1FBMg0KMDF0MFkwMDAwMDcyTVFEUUEyDQowMXQwWTAwMDAwNzJNUUZRQTINCjAxdDBZMDAwMDA3Mk1RR1FBMg0KMDF0MFkwMDAwMDcyTVFJUUEyDQowMXQwWTAwMDAwNzJNUUtRQTINCjAxdDBZMDAwMDA3Mk1RTVFBMg0KMDF0MFkwMDAwMDcyTVFPUUEyDQowMXQwWTAwMDAwNzJNUVBRQTINCjAxdDBZMDAwMDA3Mk1RVFFBMg0KMDF0MFkwMDAwMDcyTVFVUUEyDQowMXQwWTAwMDAwNzJNUVdRQTINCjAxdDBZMDAwMDA3Mk1RWVFBMg0KMDF0MFkwMDAwMDcyTVFnUUFNDQowMXQwWTAwMDAwNzJNUWlRQU0NCjAxdDBZMDAwMDA3Mk1RbVFBTQ0KMDF0MFkwMDAwMDcyTVF6UUFNDQowMXQwWTAwMDAwNzJNUjNRQU0NCjAxdDBZMDAwMDA3Mk1SN1FBTQ0KMDF0MFkwMDAwMDcyTVJhUUFNDQowMXQwWTAwMDAwNzJNUmNRQU0NCjAxdDBZMDAwMDA3Mk1SZlFBTQ0KMDF0MFkwMDAwMDcyTVJuUUFNDQowMXQwWTAwMDAwNzJNUnVRQU0NCjAxdDBZMDAwMDA3Mk1TMVFBTQ0KMDF0MFkwMDAwMDcyTVMyUUFNDQowMXQwWTAwMDAwNzJNUzNRQU0NCjAxdDBZMDAwMDA3Mk1TNlFBTQ0KMDF0MFkwMDAwMDcyTVM3UUFNDQowMXQwWTAwMDAwNzJNU0JRQTINCjAxdDBZMDAwMDA3Mk1TclFBTQ0KMDF0MFkwMDAwMDcyTVQxUUFNDQowMXQwWTAwMDAwNzJNVDRRQU0NCjAxdDBZMDAwMDA3Mk1UN1FBTQ0KMDF0MFkwMDAwMDcyTVQ5UUFNDQowMXQwWTAwMDAwNzJNVExRQTINCjAxdDBZMDAwMDA3Mk1UT1FBMg0KMDF0MFkwMDAwMDcyTVRUUUEyDQowMXQwWTAwMDAwNzJNVGJRQU0NCjAxdDBZMDAwMDA3Mk1UZFFBTQ0KMDF0MFkwMDAwMDcyTVRlUUFNDQowMXQwWTAwMDAwNzJNVGhRQU0NCjAxdDBZMDAwMDA3Mk1UaVFBTQ0KMDF0MFkwMDAwMDcyTVRqUUFNDQowMXQwWTAwMDAwNzJNVGtRQU0NCjAxdDBZMDAwMDA3Mk1UbFFBTQ0KMDF0MFkwMDAwMDcyTVR0UUFNDQowMXQwWTAwMDAwNzJNVHZRQU0NCjAxdDBZMDAwMDA3Mk1UeVFBTQ0KMDF0MFkwMDAwMDcyTVVEUUEyDQowMXQwWTAwMDAwNzJNVVBRQTINCjAxdDBZMDAwMDA3Mk1VUlFBMg0KMDF0MFkwMDAwMDcyTVVWUUEyDQowMXQwWTAwMDAwNzJNVVlRQTINCjAxdDBZMDAwMDA3Mk1VY1FBTQ0KMDF0MFkwMDAwMDcyTVVmUUFNDQowMXQwWTAwMDAwNzJNVkpRQTINCjAxdDBZMDAwMDA3Mk1WTVFBMg0KMDF0MFkwMDAwMDcyTVZRUUEyDQowMXQwWTAwMDAwNzJNVlNRQTINCjAxdDBZMDAwMDA3Mk1WVVFBMg0KMDF0MFkwMDAwMDcyTVZiUUFNDQowMXQwWTAwMDAwNzJNVmNRQU0NCjAxdDBZMDAwMDA3Mk1WZVFBTQ0KMDF0MFkwMDAwMDcyTVZpUUFNDQowMXQwWTAwMDAwNzJNVm5RQU0NCjAxdDBZMDAwMDA3Mk1WcVFBTQ0KMDF0MFkwMDAwMDcyTVZyUUFNDQowMXQwWTAwMDAwNzJNVnNRQU0NCjAxdDBZMDAwMDA3Mk1WdFFBTQ0KMDF0MFkwMDAwMDcyTVZ1UUFNDQowMXQwWTAwMDAwNzJNVnZRQU0NCjAxdDBZMDAwMDA3Mk1Wd1FBTQ0KMDF0MFkwMDAwMDcyTVZ6UUFNDQowMXQwWTAwMDAwNzJNVzFRQU0NCjAxdDBZMDAwMDA3Mk1XMlFBTQ0KMDF0MFkwMDAwMDcyTVc1UUFNDQowMXQwWTAwMDAwNzJNVzZRQU0NCjAxdDBZMDAwMDA3Mk1XQVFBMg0KMDF0MFkwMDAwMDcyTVdCUUEyDQowMXQwWTAwMDAwNzJNV0pRQTINCjAxdDBZMDAwMDA3Mk1XTFFBMg0KMDF0MFkwMDAwMDcyTVdPUUEyDQowMXQwWTAwMDAwNzJNV1FRQTINCjAxdDBZMDAwMDA3Mk1XYVFBTQ0KMDF0MFkwMDAwMDcyTVdnUUFNDQowMXQwWTAwMDAwNzJNV2lRQU0NCjAxdDBZMDAwMDA3Mk1XbVFBTQ0KMDF0MFkwMDAwMDcyTVduUUFNDQowMXQwWTAwMDAwNzJNV3FRQU0NCjAxdDBZMDAwMDA3Mk1XdFFBTQ0KMDF0MFkwMDAwMDcyTVd3UUFNDQowMXQwWTAwMDAwNzJNV3lRQU0NCjAxdDBZMDAwMDA3Mk1XelFBTQ0KMDF0MFkwMDAwMDcyTVgxUUFNDQowMXQwWTAwMDAwNzJNWDNRQU0NCjAxdDBZMDAwMDA3Mk1YNVFBTQ0KMDF0MFkwMDAwMDcyTVhaUUEyDQowMXQwWTAwMDAwNzJNWGlRQU0NCjAxdDBZMDAwMDA3Mk1ZRVFBMg0KMDF0MFkwMDAwMDcyTVlOUUEyDQowMXQwWTAwMDAwNzJNWU9RQTINCjAxdDBZMDAwMDA3Mk1ZYlFBTQ0KMDF0MFkwMDAwMDcyTVlkUUFNDQowMXQwWTAwMDAwNzJNWWpRQU0NCjAxdDBZMDAwMDA3Mk1Zb1FBTQ0KMDF0MFkwMDAwMDcyTVlwUUFNDQowMXQwWTAwMDAwNzJNWXZRQU0NCjAxdDBZMDAwMDA3Mk1Zd1FBTQ0KMDF0MFkwMDAwMDcyTVoyUUFNDQowMXQwWTAwMDAwNzJNWjZRQU0NCjAxdDBZMDAwMDA3Mk1aSFFBMg0KMDF0MFkwMDAwMDcyTVpPUUEyDQowMXQwWTAwMDAwNzJNWlNRQTINCjAxdDBZMDAwMDA3Mk1aVVFBMg0KMDF0MFkwMDAwMDcyTVpZUUEyDQowMXQwWTAwMDAwNzJNWmFRQU0NCjAxdDBZMDAwMDA3Mk1aZVFBTQ0KMDF0MFkwMDAwMDcyTVpxUUFNDQowMXQwWTAwMDAwNzJNYU9RQVUNCjAxdDBZMDAwMDA3Mk1hUFFBVQ0KMDF0MFkwMDAwMDcyTWFaUUFVDQowMXQwWTAwMDAwNzJNYWNRQUUNCjAxdDBZMDAwMDA3Mk1hZlFBRQ0KMDF0MFkwMDAwMDcyTWFzUUFFDQowMXQwWTAwMDAwNzJNYXlRQUUNCjAxdDBZMDAwMDA3Mk1iMVFBRQ0KMDF0MFkwMDAwMDcyTWJDUUFVDQowMXQwWTAwMDAwNzJNYkRRQVUNCjAxdDBZMDAwMDA3Mk1iSlFBVQ0KMDF0MFkwMDAwMDcyTWJMUUFVDQowMXQwWTAwMDAwNzJNYk5RQVUNCjAxdDBZMDAwMDA3Mk1iUFFBVQ0KMDF0MFkwMDAwMDcyTWJSUUFVDQowMXQwWTAwMDAwNzJNYlRRQVUNCjAxdDBZMDAwMDA3Mk1iVlFBVQ0KMDF0MFkwMDAwMDcyTWJZUUFVDQowMXQwWTAwMDAwNzJNYmdRQUUNCjAxdDBZMDAwMDA3Mk1ia1FBRQ0KMDF0MFkwMDAwMDcyTWJ0UUFFDQowMXQwWTAwMDAwNzJNYzNRQUUNCjAxdDBZMDAwMDA3Mk1jNVFBRQ0KMDF0MFkwMDAwMDcyTWNFUUFVDQowMXQwWTAwMDAwNzJNY0pRQVUNCjAxdDBZMDAwMDA3Mk1jTVFBVQ0KMDF0MFkwMDAwMDcyTWNPUUFVDQowMXQwWTAwMDAwNzJNY1FRQVUNCjAxdDBZMDAwMDA3Mk1jWVFBVQ0KMDF0MFkwMDAwMDcyTWNhUUFFDQowMXQwWTAwMDAwNzJNY2lRQUUNCjAxdDBZMDAwMDA3Mk1jbFFBRQ0KMDF0MFkwMDAwMDcyTWNxUUFFDQowMXQwWTAwMDAwNzJNY3dRQUUNCjAxdDBZMDAwMDA3Mk1kMFFBRQ0KMDF0MFkwMDAwMDcyTWQ3UUFFDQowMXQwWTAwMDAwNzJNZElRQVUNCjAxdDBZMDAwMDA3Mk1kVlFBVQ0KMDF0MFkwMDAwMDcyTWUxUUFFDQowMXQwWTAwMDAwNzJNZTJRQUUNCjAxdDBZMDAwMDA3Mk1lNlFBRQ0KMDF0MFkwMDAwMDcyTWU3UUFFDQowMXQwWTAwMDAwNzJNZUpRQVUNCjAxdDBZMDAwMDA3Mk1lWlFBVQ0KMDF0MFkwMDAwMDcyTWViUUFFDQowMXQwWTAwMDAwNzJNZWNRQUUNCjAxdDBZMDAwMDA3Mk1lbFFBRQ0KMDF0MFkwMDAwMDcyTWVwUUFFDQowMXQwWTAwMDAwNzJNZXZRQUUNCjAxdDBZMDAwMDA3Mk1mVVFBVQ0KMDF0MFkwMDAwMDcyTWZWUUFVDQowMXQwWTAwMDAwNzJNZldRQVUNCjAxdDBZMDAwMDA3Mk1mWlFBVQ0KMDF0MFkwMDAwMDcyTWZhUUFFDQowMXQwWTAwMDAwNzJNZmpRQUUNCjAxdDBZMDAwMDA3Mk1ma1FBRQ0KMDF0MFkwMDAwMDcyTWZsUUFFDQowMXQwWTAwMDAwNzJNZm1RQUUNCjAxdDBZMDAwMDA3Mk1mc1FBRQ0KMDF0MFkwMDAwMDcyTWc2UUFFDQowMXQwWTAwMDAwNzJNZzhRQUUNCjAxdDBZMDAwMDA3Mk1nQVFBVQ0KMDF0MFkwMDAwMDcyTWdCUUFVDQowMXQwWTAwMDAwNzJNZ0NRQVUNCjAxdDBZMDAwMDA3Mk1nRVFBVQ0KMDF0MFkwMDAwMDcyTWdPUUFVDQowMXQwWTAwMDAwNzJNZ1BRQVUNCjAxdDBZMDAwMDA3Mk1nalFBRQ0KMDF0MFkwMDAwMDcyTWdrUUFFDQowMXQwWTAwMDAwNzJNZ25RQUUNCjAxdDBZMDAwMDA3Mk1ncFFBRQ0KMDF0MFkwMDAwMDcyTWdzUUFFDQowMXQwWTAwMDAwNzJNaE5RQVUNCjAxdDBZMDAwMDA3Mk1oU1FBVQ0KMDF0MFkwMDAwMDcyTWhiUUFFDQowMXQwWTAwMDAwNzJNaGdRQUUNCjAxdDBZMDAwMDA3Mk1oaVFBRQ0KMDF0MFkwMDAwMDcyTWhrUUFFDQowMXQwWTAwMDAwNzJNaHZRQUUNCjAxdDBZMDAwMDA3Mk1pSVFBVQ0KMDF0MFkwMDAwMDcyTWlKUUFVDQowMXQwWTAwMDAwNzJNaVFRQVUNCjAxdDBZMDAwMDA3Mk1pVFFBVQ0KMDF0MFkwMDAwMDcyTWlVUUFVDQowMXQwWTAwMDAwNzJNaVZRQVUNCjAxdDBZMDAwMDA3Mk1pYVFBRQ0KMDF0MFkwMDAwMDcyTWllUUFFDQowMXQwWTAwMDAwNzJNaWdRQUUNCjAxdDBZMDAwMDA3Mk1pcFFBRQ0KMDF0MFkwMDAwMDcyTWlzUUFFDQowMXQwWTAwMDAwNzJNaXRRQUUNCjAxdDBZMDAwMDA3Mk1pdVFBRQ0KMDF0MFkwMDAwMDcyTWl2UUFFDQowMXQwWTAwMDAwNzJNaXdRQUUNCjAxdDBZMDAwMDA3Mk1peVFBRQ0KMDF0MFkwMDAwMDcyTWpJUUFVDQowMXQwWTAwMDAwNzJNakxRQVUNCjAxdDBZMDAwMDA3Mk1qbVFBRQ0KMDF0MFkwMDAwMDcyTWpzUUFFDQowMXQwWTAwMDAwNzJNazNRQUUNCjAxdDBZMDAwMDA3Mk1rUFFBVQ0KMDF0MFkwMDAwMDcyTWtRUUFVDQowMXQwWTAwMDAwNzJNa2FRQUUNCjAxdDBZMDAwMDA3Mk1raFFBRQ0KMDF0MFkwMDAwMDcyTWtpUUFFDQowMXQwWTAwMDAwNzJNa25RQUUNCjAxdDBZMDAwMDA3Mk1rcFFBRQ0KMDF0MFkwMDAwMDcyTWtxUUFFDQowMXQwWTAwMDAwNzJNa3JRQUUNCjAxdDBZMDAwMDA3Mk1rc1FBRQ0KMDF0MFkwMDAwMDcyTWt0UUFFDQowMXQwWTAwMDAwNzJNa3lRQUUNCjAxdDBZMDAwMDA3Mk1sMlFBRQ0KMDF0MFkwMDAwMDcyTWwzUUFFDQowMXQwWTAwMDAwNzJNbEhRQVUNCjAxdDBZMDAwMDA3Mk1sS1FBVQ0KMDF0MFkwMDAwMDcyTWxRUUFVDQowMXQwWTAwMDAwNzJNbFJRQVUNCjAxdDBZMDAwMDA3Mk1sWlFBVQ0KMDF0MFkwMDAwMDcyTWxmUUFFDQowMXQwWTAwMDAwNzJNbHhRQUUNCjAxdDBZMDAwMDA3Mk1seVFBRQ0KMDF0MFkwMDAwMDcyTW1BUUFVDQowMXQwWTAwMDAwNzJNbWFRQUUNCjAxdDBZMDAwMDA3Mk1tYlFBRQ0KMDF0MFkwMDAwMDcyTW1jUUFFDQowMXQwWTAwMDAwNzJNbWZRQUUNCjAxdDBZMDAwMDA3Mk1tbFFBRQ0KMDF0MFkwMDAwMDcyTW5BUUFVDQowMXQwWTAwMDAwNzJNbkJRQVUNCjAxdDBZMDAwMDA3Mk1uRFFBVQ0KMDF0MFkwMDAwMDcyTW5IUUFVDQowMXQwWTAwMDAwNzJNbk9RQVUNCjAxdDBZMDAwMDA3Mk1uUVFBVQ0KMDF0MFkwMDAwMDcyTW5UUUFVDQowMXQwWTAwMDAwNzJNbmRRQUUNCjAxdDBZMDAwMDA3Mk1ualFBRQ0KMDF0MFkwMDAwMDcyTW5tUUFFDQowMXQwWTAwMDAwNzJNbnBRQUUNCjAxdDBZMDAwMDA3Mk1ucVFBRQ0KMDF0MFkwMDAwMDcyTW53UUFFDQowMXQwWTAwMDAwNzJNbnpRQUUNCjAxdDBZMDAwMDA3Mk1vM1FBRQ0KMDF0MFkwMDAwMDcyTW9BUUFVDQowMXQwWTAwMDAwNzJNb0ZRQVUNCjAxdDBZMDAwMDA3Mk1vSFFBVQ0KMDF0MFkwMDAwMDcyTW9OUUFVDQowMXQwWTAwMDAwNzJNb09RQVUNCjAxdDBZMDAwMDA3Mk1vUFFBVQ0KMDF0MFkwMDAwMDcyTW9RUUFVDQowMXQwWTAwMDAwNzJNb1JRQVUNCjAxdDBZMDAwMDA3Mk1vVVFBVQ0KMDF0MFkwMDAwMDcyTW9ZUUFVDQowMXQwWTAwMDAwNzJNb2NRQUUNCjAxdDBZMDAwMDA3Mk1vbFFBRQ0KMDF0MFkwMDAwMDcyTW9wUUFFDQowMXQwWTAwMDAwNzJNb3JRQUUNCjAxdDBZMDAwMDA3Mk1veFFBRQ0KMDF0MFkwMDAwMDcyTW95UUFFDQowMXQwWTAwMDAwNzJNb3pRQUUNCjAxdDBZMDAwMDA3Mk1wMFFBRQ0KMDF0MFkwMDAwMDcyTXBIUUFVDQowMXQwWTAwMDAwNzJNcEtRQVUNCjAxdDBZMDAwMDA3Mk1wUFFBVQ0KMDF0MFkwMDAwMDcyTXBRUUFVDQowMXQwWTAwMDAwNzJNcFVRQVUNCjAxdDBZMDAwMDA3Mk1wZVFBRQ0KMDF0MFkwMDAwMDcyTXBoUUFFDQowMXQwWTAwMDAwNzJNcGpRQUUNCjAxdDBZMDAwMDA3Mk1welFBRQ0KMDF0MFkwMDAwMDcyTXEwUUFFDQowMXQwWTAwMDAwNzJNcThRQUUNCjAxdDBZMDAwMDA3Mk1xOVFBRQ0KMDF0MFkwMDAwMDcyTXFQUUFVDQowMXQwWTAwMDAwNzJNcXpRQUUNCjAxdDBZMDAwMDA3Mk1yMVFBRQ0KMDF0MFkwMDAwMDcyTXIyUUFFDQowMXQwWTAwMDAwNzJNcjdRQUUNCjAxdDBZMDAwMDA3Mk1yOVFBRQ0KMDF0MFkwMDAwMDcyTXJCUUFVDQowMXQwWTAwMDAwNzJNclNRQVUNCjAxdDBZMDAwMDA3Mk1yb1FBRQ0KMDF0MFkwMDAwMDcyTXJ2UUFFDQowMXQwWTAwMDAwNzJNcnhRQUUNCjAxdDBZMDAwMDA3Mk1yelFBRQ0KMDF0MFkwMDAwMDcyTXM3UUFFDQowMXQwWTAwMDAwNzJNczhRQUUNCjAxdDBZMDAwMDA3Mk1zQlFBVQ0KMDF0MFkwMDAwMDcyTXNSUUFVDQowMXQwWTAwMDAwNzJNc2tRQUUNCjAxdDBZMDAwMDA3Mk1zd1FBRQ0KMDF0MFkwMDAwMDcyTXN6UUFFDQowMXQwWTAwMDAwNzJNdDBRQUUNCjAxdDBZMDAwMDA3Mk10M1FBRQ0KMDF0MFkwMDAwMDcyTXRDUUFVDQowMXQwWTAwMDAwNzJNdERRQVUNCjAxdDBZMDAwMDA3Mk10RVFBVQ0KMDF0MFkwMDAwMDcyTXRJUUFVDQowMXQwWTAwMDAwNzJNdG9RQUUNCjAxdDBZMDAwMDA3Mk10dFFBRQ0KMDF0MFkwMDAwMDcyTXR1UUFFDQowMXQwWTAwMDAwNzJNdHdRQUUNCjAxdDBZMDAwMDA3Mk10elFBRQ0KMDF0MFkwMDAwMDcyTXU0UUFFDQowMXQwWTAwMDAwNzJNdTVRQUUNCjAxdDBZMDAwMDA3Mk11NlFBRQ0KMDF0MFkwMDAwMDcyTXU4UUFFDQowMXQwWTAwMDAwNzJNdUFRQVUNCjAxdDBZMDAwMDA3Mk11QlFBVQ0KMDF0MFkwMDAwMDcyTXVDUUFVDQowMXQwWTAwMDAwNzJNdUhRQVUNCjAxdDBZMDAwMDA3Mk11UlFBVQ0KMDF0MFkwMDAwMDcyTXVYUUFVDQowMXQwWTAwMDAwNzJNdWVRQUUNCjAxdDBZMDAwMDA3Mk11bFFBRQ0KMDF0MFkwMDAwMDcyTXVwUUFFDQowMXQwWTAwMDAwNzJNdXJRQUUNCjAxdDBZMDAwMDA3Mk11c1FBRQ0KMDF0MFkwMDAwMDcyTXV0UUFFDQowMXQwWTAwMDAwNzJNdXZRQUUNCjAxdDBZMDAwMDA3Mk12NlFBRQ0KMDF0MFkwMDAwMDcyTXZHUUFVDQowMXQwWTAwMDAwNzJNdkhRQVUNCjAxdDBZMDAwMDA3Mk12SlFBVQ0KMDF0MFkwMDAwMDcyTXZLUUFVDQowMXQwWTAwMDAwNzJNdkxRQVUNCjAxdDBZMDAwMDA3Mk12U1FBVQ0KMDF0MFkwMDAwMDcyTXZkUUFFDQowMXQwWTAwMDAwNzJNdmVRQUUNCjAxdDBZMDAwMDA3Mk12Z1FBRQ0KMDF0MFkwMDAwMDcyTXZrUUFFDQowMXQwWTAwMDAwNzJNdm5RQUUNCjAxdDBZMDAwMDA3Mk12cFFBRQ0KMDF0MFkwMDAwMDcyTXZzUUFFDQowMXQwWTAwMDAwNzJNdnRRQUUNCjAxdDBZMDAwMDA3Mk12dlFBRQ0KMDF0MFkwMDAwMDcyTXZ3UUFFDQowMXQwWTAwMDAwNzJNdzRRQUUNCjAxdDBZMDAwMDA3Mk13QVFBVQ0KMDF0MFkwMDAwMDcyTXdGUUFVDQowMXQwWTAwMDAwNzJNd0dRQVUNCjAxdDBZMDAwMDA3Mk13SVFBVQ0KMDF0MFkwMDAwMDcyTXdZUUFVDQowMXQwWTAwMDAwNzJNd2hRQUUNCjAxdDBZMDAwMDA3Mk13blFBRQ0KMDF0MFkwMDAwMDcyTXd3UUFFDQowMXQwWTAwMDAwNzJNeDFRQUUNCjAxdDBZMDAwMDA3Mk14MlFBRQ0KMDF0MFkwMDAwMDcyTXg3UUFFDQowMXQwWTAwMDAwNzJNeDhRQUUNCjAxdDBZMDAwMDA3Mk14QVFBVQ0KMDF0MFkwMDAwMDcyTXhFUUFVDQowMXQwWTAwMDAwNzJNeEZRQVUNCjAxdDBZMDAwMDA3Mk14R1FBVQ0KMDF0MFkwMDAwMDcyTXhLUUFVDQowMXQwWTAwMDAwNzJNeExRQVUNCjAxdDBZMDAwMDA3Mk14TVFBVQ0KMDF0MFkwMDAwMDcyTXhQUUFVDQowMXQwWTAwMDAwNzJNeFJRQVUNCjAxdDBZMDAwMDA3Mk14VlFBVQ0KMDF0MFkwMDAwMDcyTXhjUUFFDQowMXQwWTAwMDAwNzJNeGVRQUUNCjAxdDBZMDAwMDA3Mk14ZlFBRQ0KMDF0MFkwMDAwMDcyTXhoUUFFDQowMXQwWTAwMDAwNzJNeHFRQUUNCjAxdDBZMDAwMDA3Mk15NFFBRQ0KMDF0MFkwMDAwMDcyTXk3UUFFDQowMXQwWTAwMDAwNzJNeTlRQUUNCjAxdDBZMDAwMDA3Mk15SVFBVQ0KMDF0MFkwMDAwMDcyTXlVUUFVDQowMXQwWTAwMDAwNzJNeVdRQVUNCjAxdDBZMDAwMDA3Mk15bVFBRQ0KMDF0MFkwMDAwMDcyTXozUUFFDQowMXQwWTAwMDAwNzJNejRRQUUNCjAxdDBZMDAwMDA3Mk16QVFBVQ0KMDF0MFkwMDAwMDcyTXpCUUFVDQowMXQwWTAwMDAwNzJNekRRQVUNCjAxdDBZMDAwMDA3Mk16WVFBVQ0KMDF0MFkwMDAwMDcyTXpoUUFFDQowMXQwWTAwMDAwNzJNemtRQUUNCjAxdDBZMDAwMDA3Mk16b1FBRQ0KMDF0MFkwMDAwMDcyTXpyUUFFDQowMXQwWTAwMDAwNzJNendRQUUNCjAxdDBZMDAwMDA3Mk4wMFFBRQ0KMDF0MFkwMDAwMDcyTjA1UUFFDQowMXQwWTAwMDAwNzJOMEdRQVUNCjAxdDBZMDAwMDA3Mk4wVFFBVQ0KMDF0MFkwMDAwMDcyTjBaUUFVDQowMXQwWTAwMDAwNzJOMHBRQUUNCjAxdDBZMDAwMDA3Mk4wdFFBRQ0KMDF0MFkwMDAwMDcyTjEwUUFFDQowMXQwWTAwMDAwNzJOMTNRQUUNCjAxdDBZMDAwMDA3Mk4xOVFBRQ0KMDF0MFkwMDAwMDcyTjFDUUFVDQowMXQwWTAwMDAwNzJOMUZRQVUNCjAxdDBZMDAwMDA3Mk4xU1FBVQ0KMDF0MFkwMDAwMDcyTjFiUUFFDQowMXQwWTAwMDAwNzJOMWRRQUUNCjAxdDBZMDAwMDA3Mk4xalFBRQ0KMDF0MFkwMDAwMDcyTjF3UUFFDQowMXQwWTAwMDAwNzJOMjNRQUUNCjAxdDBZMDAwMDA3Mk4yRVFBVQ0KMDF0MFkwMDAwMDcyTjJaUUFVDQowMXQwWTAwMDAwNzJOMmRRQUUNCjAxdDBZMDAwMDA3Mk4yaFFBRQ0KMDF0MFkwMDAwMDcyTjJtUUFFDQowMXQwWTAwMDAwNzJOMm9RQUUNCjAxdDBZMDAwMDA3Mk4ycVFBRQ0KMDF0MFkwMDAwMDcyTjJ3UUFFDQowMXQwWTAwMDAwNzJOMzRRQUUNCjAxdDBZMDAwMDA3Mk4zNlFBRQ0KMDF0MFkwMDAwMDcyTjM3UUFFDQowMXQwWTAwMDAwNzJOM0JRQVUNCjAxdDBZMDAwMDA3Mk4zQ1FBVQ0KMDF0MFkwMDAwMDcyTjNFUUFVDQowMXQwWTAwMDAwNzJOM0ZRQVUNCjAxdDBZMDAwMDA3Mk4zR1FBVQ0KMDF0MFkwMDAwMDcyTjNLUUFVDQowMXQwWTAwMDAwNzJOM0xRQVUNCjAxdDBZMDAwMDA3Mk4zVVFBVQ0KMDF0MFkwMDAwMDcyTjNiUUFFDQowMXQwWTAwMDAwNzJOM2ZRQUUNCjAxdDBZMDAwMDA3Mk40VVFBVQ0KMDF0MFkwMDAwMDcyTjRXUUFVDQowMXQwWTAwMDAwNzJONGFRQUUNCjAxdDBZMDAwMDA3Mk40aVFBRQ0KMDF0MFkwMDAwMDcyTjRqUUFFDQowMXQwWTAwMDAwNzJONGxRQUUNCjAxdDBZMDAwMDA3Mk40dFFBRQ0KMDF0MFkwMDAwMDcyTjR5UUFFDQowMXQwWTAwMDAwNzJONTBRQUUNCjAxdDBZMDAwMDA3Mk41QlFBVQ0KMDF0MFkwMDAwMDcyTjVHUUFVDQowMXQwWTAwMDAwNzJONUtRQVUNCjAxdDBZMDAwMDA3Mk41Z1FBRQ0KMDF0MFkwMDAwMDcyTjVqUUFFDQowMXQwWTAwMDAwNzJONWtRQUUNCjAxdDBZMDAwMDA3Mk41blFBRQ0KMDF0MFkwMDAwMDcyTjZrUUFFDQowMXQwWTAwMDAwNzJONm5RQUUNCjAxdDBZMDAwMDA3Mk42b1FBRQ0KMDF0MFkwMDAwMDcyTjZxUUFFDQowMXQwWTAwMDAwNzJONnJRQUUNCjAxdDBZMDAwMDA3Mk42d1FBRQ0KMDF0MFkwMDAwMDcyTjczUUFFDQowMXQwWTAwMDAwNzJONzRRQUUNCjAxdDBZMDAwMDA3Mk43QVFBVQ0KMDF0MFkwMDAwMDcyTjdCUUFVDQowMXQwWTAwMDAwNzJON0lRQVUNCjAxdDBZMDAwMDA3Mk43TVFBVQ0KMDF0MFkwMDAwMDcyTjdUUUFVDQowMXQwWTAwMDAwNzJON1ZRQVUNCjAxdDBZMDAwMDA3Mk43V1FBVQ0KMDF0MFkwMDAwMDcyTjd3UUFFDQowMXQwWTAwMDAwNzJON3hRQUUNCjAxdDBZMDAwMDA3Mk43eVFBRQ0KMDF0MFkwMDAwMDcyTjgwUUFFDQowMXQwWTAwMDAwNzJOODNRQUUNCjAxdDBZMDAwMDA3Mk44NlFBRQ0KMDF0MFkwMDAwMDcyTjg4UUFFDQowMXQwWTAwMDAwNzJOOEFRQVUNCjAxdDBZMDAwMDA3Mk44Q1FBVQ0KMDF0MFkwMDAwMDcyTjhHUUFVDQowMXQwWTAwMDAwNzJOOExRQVUNCjAxdDBZMDAwMDA3Mk44T1FBVQ0KMDF0MFkwMDAwMDcyTjhRUUFVDQowMXQwWTAwMDAwNzJOOFRRQVUNCjAxdDBZMDAwMDA3Mk44WlFBVQ0KMDF0MFkwMDAwMDcyTjhhUUFFDQowMXQwWTAwMDAwNzJOOGVRQUUNCjAxdDBZMDAwMDA3Mk45MVFBRQ0KMDF0MFkwMDAwMDcyTjk5UUFFDQowMXQwWTAwMDAwNzJOQTBRQU0NCjAxdDBZMDAwMDA3Mk5BQVFBMg0KMDF0MFkwMDAwMDcyTkFCUUEyDQowMXQwWTAwMDAwNzJOQVVRQTINCjAxdDBZMDAwMDA3Mk5BV1FBMg0KMDF0MFkwMDAwMDcyTkFaUUEyDQowMXQwWTAwMDAwNzJOQWlRQU0NCjAxdDBZMDAwMDA3Mk5BdFFBTQ0KMDF0MFkwMDAwMDcyTkIzUUFNDQowMXQwWTAwMDAwNzJOQjRRQU0NCjAxdDBZMDAwMDA3Mk5CRVFBMg0KMDF0MFkwMDAwMDcyTkJLUUEyDQowMXQwWTAwMDAwNzJOQkxRQTINCjAxdDBZMDAwMDA3Mk5CUFFBMg0KMDF0MFkwMDAwMDcyTkJVUUEyDQowMXQwWTAwMDAwNzJOQlpRQTINCjAxdDBZMDAwMDA3Mk5CZFFBTQ0KMDF0MFkwMDAwMDcyTkJlUUFNDQowMXQwWTAwMDAwNzJOQmhRQU0NCjAxdDBZMDAwMDA3Mk5CbFFBTQ0KMDF0MFkwMDAwMDcyTkJuUUFNDQowMXQwWTAwMDAwNzJOQnNRQU0NCjAxdDBZMDAwMDA3Mk5CdFFBTQ0KMDF0MFkwMDAwMDcyTkJ4UUFNDQowMXQwWTAwMDAwNzJOQnlRQU0NCjAxdDBZMDAwMDA3Mk5DMVFBTQ0KMDF0MFkwMDAwMDcyTkM2UUFNDQowMXQwWTAwMDAwNzJOQzdRQU0NCjAxdDBZMDAwMDA3Mk5DRFFBMg0KMDF0MFkwMDAwMDcyTkNFUUEyDQowMXQwWTAwMDAwNzJOQ0xRQTINCjAxdDBZMDAwMDA3Mk5DT1FBMg0KMDF0MFkwMDAwMDcyTkNQUUEyDQowMXQwWTAwMDAwNzJOQ1pRQTINCjAxdDBZMDAwMDA3Mk5DY1FBTQ0KMDF0MFkwMDAwMDcyTkNlUUFNDQowMXQwWTAwMDAwNzJOQ2xRQU0NCjAxdDBZMDAwMDA3Mk5DblFBTQ0KMDF0MFkwMDAwMDcyTkN2UUFNDQowMXQwWTAwMDAwNzJOQ3dRQU0NCjAxdDBZMDAwMDA3Mk5EMFFBTQ0KMDF0MFkwMDAwMDcyTkQ3UUFNDQowMXQwWTAwMDAwNzJOREZRQTINCjAxdDBZMDAwMDA3Mk5ESlFBMg0KMDF0MFkwMDAwMDcyTkRQUUEyDQowMXQwWTAwMDAwNzJORHlRQU0NCjAxdDBZMDAwMDA3Mk5FQVFBMg0KMDF0MFkwMDAwMDcyTkVMUUEyDQowMXQwWTAwMDAwNzJORU5RQTINCjAxdDBZMDAwMDA3Mk5FUFFBMg0KMDF0MFkwMDAwMDcyTkVRUUEyDQowMXQwWTAwMDAwNzJORVlRQTINCjAxdDBZMDAwMDA3Mk5FZlFBTQ0KMDF0MFkwMDAwMDcyTkVnUUFNDQowMXQwWTAwMDAwNzJORWpRQU0NCjAxdDBZMDAwMDA3Mk5Fa1FBTQ0KMDF0MFkwMDAwMDcyTkVsUUFNDQowMXQwWTAwMDAwNzJORXBRQU0NCjAxdDBZMDAwMDA3Mk5FdFFBTQ0KMDF0MFkwMDAwMDcyTkV3UUFNDQowMXQwWTAwMDAwNzJORjBRQU0NCjAxdDBZMDAwMDA3Mk5GMVFBTQ0KMDF0MFkwMDAwMDcyTkZoUUFNDQowMXQwWTAwMDAwNzJORmpRQU0NCjAxdDBZMDAwMDA3Mk5HN1FBTQ0KMDF0MFkwMDAwMDcyTkc5UUFNDQowMXQwWTAwMDAwNzJOR0NRQTINCjAxdDBZMDAwMDA3Mk5HRFFBMg0KMDF0MFkwMDAwMDcyTkdFUUEyDQowMXQwWTAwMDAwNzJOR0pRQTINCjAxdDBZMDAwMDA3Mk5HTVFBMg0KMDF0MFkwMDAwMDcyTkdPUUEyDQowMXQwWTAwMDAwNzJOR1NRQTINCjAxdDBZMDAwMDA3Mk5HV1FBMg0KMDF0MFkwMDAwMDcyTkdlUUFNDQowMXQwWTAwMDAwNzJOR2ZRQU0NCjAxdDBZMDAwMDA3Mk5HZ1FBTQ0KMDF0MFkwMDAwMDcyTkdoUUFNDQowMXQwWTAwMDAwNzJOR2lRQU0NCjAxdDBZMDAwMDA3Mk5HalFBTQ0KMDF0MFkwMDAwMDcyTkdrUUFNDQowMXQwWTAwMDAwNzJOR3VRQU0NCjAxdDBZMDAwMDA3Mk5HeVFBTQ0KMDF0MFkwMDAwMDcyTkgzUUFNDQowMXQwWTAwMDAwNzJOSDdRQU0NCjAxdDBZMDAwMDA3Mk5IQVFBMg0KMDF0MFkwMDAwMDcyTkhFUUEyDQowMXQwWTAwMDAwNzJOSFFRQTINCjAxdDBZMDAwMDA3Mk5IWVFBMg0KMDF0MFkwMDAwMDcyTkhiUUFNDQowMXQwWTAwMDAwNzJOSGdRQU0NCjAxdDBZMDAwMDA3Mk5IaFFBTQ0KMDF0MFkwMDAwMDcyTkhwUUFNDQowMXQwWTAwMDAwNzJOSHpRQU0NCjAxdDBZMDAwMDA3Mk5JNVFBTQ0KMDF0MFkwMDAwMDcyTkk3UUFNDQowMXQwWTAwMDAwNzJOSTlRQU0NCjAxdDBZMDAwMDA3Mk5JQVFBMg0KMDF0MFkwMDAwMDcyTklGUUEyDQowMXQwWTAwMDAwNzJOSUhRQTINCjAxdDBZMDAwMDA3Mk5JUFFBMg0KMDF0MFkwMDAwMDcyTkljUUFNDQowMXQwWTAwMDAwNzJOSWdRQU0NCjAxdDBZMDAwMDA3Mk5JaFFBTQ0KMDF0MFkwMDAwMDcyTklqUUFNDQowMXQwWTAwMDAwNzJOSW1RQU0NCjAxdDBZMDAwMDA3Mk5JeVFBTQ0KMDF0MFkwMDAwMDcyTko3UUFNDQowMXQwWTAwMDAwNzJOSklRQTINCjAxdDBZMDAwMDA3Mk5KVVFBMg0KMDF0MFkwMDAwMDcyTkplUUFNDQowMXQwWTAwMDAwNzJOSmpRQU0NCjAxdDBZMDAwMDA3Mk5Ka1FBTQ0KMDF0MFkwMDAwMDcyTkpwUUFNDQowMXQwWTAwMDAwNzJOSnVRQU0NCjAxdDBZMDAwMDA3Mk5KdlFBTQ0KMDF0MFkwMDAwMDcyTktKUUEyDQowMXQwWTAwMDAwNzJOS0tRQTINCjAxdDBZMDAwMDA3Mk5LTFFBMg0KMDF0MFkwMDAwMDcyTktQUUEyDQowMXQwWTAwMDAwNzJOS1JRQTINCjAxdDBZMDAwMDA3Mk5LVlFBMg0KMDF0MFkwMDAwMDcyTktYUUEyDQowMXQwWTAwMDAwNzJOS1lRQTINCjAxdDBZMDAwMDA3Mk5LWlFBMg0KMDF0MFkwMDAwMDcyTktrUUFNDQowMXQwWTAwMDAwNzJOS2xRQU0NCjAxdDBZMDAwMDA3Mk5Lc1FBTQ0KMDF0MFkwMDAwMDcyTkwwUUFNDQowMXQwWTAwMDAwNzJOTDNRQU0NCjAxdDBZMDAwMDA3Mk5MRFFBMg0KMDF0MFkwMDAwMDcyTkxHUUEyDQowMXQwWTAwMDAwNzJOTE5RQTINCjAxdDBZMDAwMDA3Mk5MUVFBMg0KMDF0MFkwMDAwMDcyTkxSUUEyDQowMXQwWTAwMDAwNzJOTFRRQTINCjAxdDBZMDAwMDA3Mk5MVVFBMg0KMDF0MFkwMDAwMDcyTkxZUUEyDQowMXQwWTAwMDAwNzJOTGJRQU0NCjAxdDBZMDAwMDA3Mk5MZ1FBTQ0KMDF0MFkwMDAwMDcyTkxoUUFNDQowMXQwWTAwMDAwNzJOTGlRQU0NCjAxdDBZMDAwMDA3Mk5MbVFBTQ0KMDF0MFkwMDAwMDcyTkxuUUFNDQowMXQwWTAwMDAwNzJOTHFRQU0NCjAxdDBZMDAwMDA3Mk5MdFFBTQ0KMDF0MFkwMDAwMDcyTkx1UUFNDQowMXQwWTAwMDAwNzJOTHZRQU0NCjAxdDBZMDAwMDA3Mk5Md1FBTQ0KMDF0MFkwMDAwMDcyTkx6UUFNDQowMXQwWTAwMDAwNzJOTTFRQU0NCjAxdDBZMDAwMDA3Mk5NNFFBTQ0KMDF0MFkwMDAwMDcyTk01UUFNDQowMXQwWTAwMDAwNzJOTTZRQU0NCjAxdDBZMDAwMDA3Mk5NOVFBTQ0KMDF0MFkwMDAwMDcyTk1OUUEyDQowMXQwWTAwMDAwNzJOTVlRQTINCjAxdDBZMDAwMDA3Mk5NY1FBTQ0KMDF0MFkwMDAwMDcyTk1nUUFNDQowMXQwWTAwMDAwNzJOTkRRQTINCjAxdDBZMDAwMDA3Mk5OUFFBMg0KMDF0MFkwMDAwMDcyTk5RUUEyDQowMXQwWTAwMDAwNzJOTlNRQTINCjAxdDBZMDAwMDA3Mk5OVFFBMg0KMDF0MFkwMDAwMDcyTk5VUUEyDQowMXQwWTAwMDAwNzJOTmJRQU0NCjAxdDBZMDAwMDA3Mk5OaFFBTQ0KMDF0MFkwMDAwMDcyTk5pUUFNDQowMXQwWTAwMDAwNzJOTmtRQU0NCjAxdDBZMDAwMDA3Mk5Ob1FBTQ0KMDF0MFkwMDAwMDcyTk52UUFNDQowMXQwWTAwMDAwNzJOTndRQU0NCjAxdDBZMDAwMDA3Mk5OelFBTQ0KMDF0MFkwMDAwMDcyTk80UUFNDQowMXQwWTAwMDAwNzJOTzVRQU0NCjAxdDBZMDAwMDA3Mk5PQVFBMg0KMDF0MFkwMDAwMDcyTk9DUUEyDQowMXQwWTAwMDAwNzJOT0lRQTINCjAxdDBZMDAwMDA3Mk5PUlFBMg0KMDF0MFkwMDAwMDcyTk9rUUFNDQowMXQwWTAwMDAwNzJOT2xRQU0NCjAxdDBZMDAwMDA3Mk5Pb1FBTQ0KMDF0MFkwMDAwMDcyTk9xUUFNDQowMXQwWTAwMDAwNzJOT3JRQU0NCjAxdDBZMDAwMDA3Mk5Pd1FBTQ0KMDF0MFkwMDAwMDcyTk95UUFNDQowMXQwWTAwMDAwNzJOUDJRQU0NCjAxdDBZMDAwMDA3Mk5QM1FBTQ0KMDF0MFkwMDAwMDcyTlA0UUFNDQowMXQwWTAwMDAwNzJOUDVRQU0NCjAxdDBZMDAwMDA3Mk5QNlFBTQ0KMDF0MFkwMDAwMDcyTlA3UUFNDQowMXQwWTAwMDAwNzJOUEFRQTINCjAxdDBZMDAwMDA3Mk5QQlFBMg0KMDF0MFkwMDAwMDcyTlBHUUEyDQowMXQwWTAwMDAwNzJOUEhRQTINCjAxdDBZMDAwMDA3Mk5QTFFBMg0KMDF0MFkwMDAwMDcyTlBRUUEyDQowMXQwWTAwMDAwNzJOUGNRQU0NCjAxdDBZMDAwMDA3Mk5Qb1FBTQ0KMDF0MFkwMDAwMDcyTlBxUUFNDQowMXQwWTAwMDAwNzJOUHpRQU0NCjAxdDBZMDAwMDA3Mk5RMFFBTQ0KMDF0MFkwMDAwMDcyTlE0UUFNDQowMXQwWTAwMDAwNzJOUUdRQTINCjAxdDBZMDAwMDA3Mk5RZlFBTQ0KMDF0MFkwMDAwMDcyTlFrUUFNDQowMXQwWTAwMDAwNzJOUW1RQU0NCjAxdDBZMDAwMDA3Mk5Rb1FBTQ0KMDF0MFkwMDAwMDcyTlFwUUFNDQowMXQwWTAwMDAwNzJOUXFRQU0NCjAxdDBZMDAwMDA3Mk5RelFBTQ0KMDF0MFkwMDAwMDcyTlIyUUFNDQowMXQwWTAwMDAwNzJOUkRRQTINCjAxdDBZMDAwMDA3Mk5STFFBMg0KMDF0MFkwMDAwMDcyTlJPUUEyDQowMXQwWTAwMDAwNzJOUlJRQTINCjAxdDBZMDAwMDA3Mk5SU1FBMg0KMDF0MFkwMDAwMDcyTlJZUUEyDQowMXQwWTAwMDAwNzJOUlpRQTINCjAxdDBZMDAwMDA3Mk5SYVFBTQ0KMDF0MFkwMDAwMDcyTlJjUUFNDQowMXQwWTAwMDAwNzJOUmZRQU0NCjAxdDBZMDAwMDA3Mk5SbVFBTQ0KMDF0MFkwMDAwMDcyTlJxUUFNDQowMXQwWTAwMDAwNzJOUzRRQU0NCjAxdDBZMDAwMDA3Mk5TOFFBTQ0KMDF0MFkwMDAwMDcyTlNFUUEyDQowMXQwWTAwMDAwNzJOU0hRQTINCjAxdDBZMDAwMDA3Mk5TSlFBMg0KMDF0MFkwMDAwMDcyTlNOUUEyDQowMXQwWTAwMDAwNzJOU1JRQTINCjAxdDBZMDAwMDA3Mk5TaVFBTQ0KMDF0MFkwMDAwMDcyTlNvUUFNDQowMXQwWTAwMDAwNzJOU3FRQU0NCjAxdDBZMDAwMDA3Mk5TdFFBTQ0KMDF0MFkwMDAwMDcyTlN2UUFNDQowMXQwWTAwMDAwNzJOU3hRQU0NCjAxdDBZMDAwMDA3Mk5TeVFBTQ0KMDF0MFkwMDAwMDcyTlQ3UUFNDQowMXQwWTAwMDAwNzJOVEVRQTINCjAxdDBZMDAwMDA3Mk5UR1FBMg0KMDF0MFkwMDAwMDcyTlRMUUEyDQowMXQwWTAwMDAwNzJOVE1RQTINCjAxdDBZMDAwMDA3Mk5UTlFBMg0KMDF0MFkwMDAwMDcyTlRRUUEyDQowMXQwWTAwMDAwNzJOVFJRQTINCjAxdDBZMDAwMDA3Mk5UWVFBMg0KMDF0MFkwMDAwMDcyTlR4UUFNDQowMXQwWTAwMDAwNzJOVHlRQU0NCjAxdDBZMDAwMDA3Mk5VNVFBTQ0KMDF0MFkwMDAwMDcyTlVTUUEyDQowMXQwWTAwMDAwNzJOVVRRQTINCjAxdDBZMDAwMDA3Mk5VV1FBMg0KMDF0MFkwMDAwMDcyTlVYUUEyDQowMXQwWTAwMDAwNzJOVVlRQTINCjAxdDBZMDAwMDA3Mk5VZlFBTQ0KMDF0MFkwMDAwMDcyTlVnUUFNDQowMXQwWTAwMDAwNzJOVW1RQU0NCjAxdDBZMDAwMDA3Mk5VcFFBTQ0KMDF0MFkwMDAwMDcyTlV0UUFNDQowMXQwWTAwMDAwNzJOVXdRQU0NCjAxdDBZMDAwMDA3Mk5VeVFBTQ0KMDF0MFkwMDAwMDcyTlYxUUFNDQowMXQwWTAwMDAwNzJOVkVRQTINCjAxdDBZMDAwMDA3Mk5WU1FBMg0KMDF0MFkwMDAwMDcyTlZaUUEyDQowMXQwWTAwMDAwNzJOVmZRQU0NCjAxdDBZMDAwMDA3Mk5WbFFBTQ0KMDF0MFkwMDAwMDcyTlczUUFNDQowMXQwWTAwMDAwNzJOVzRRQU0NCjAxdDBZMDAwMDA3Mk5XN1FBTQ0KMDF0MFkwMDAwMDcyTldBUUEyDQowMXQwWTAwMDAwNzJOV0JRQTINCjAxdDBZMDAwMDA3Mk5XRFFBMg0KMDF0MFkwMDAwMDcyTldKUUEyDQowMXQwWTAwMDAwNzJOV0xRQTINCjAxdDBZMDAwMDA3Mk5XTVFBMg0KMDF0MFkwMDAwMDcyTldOUUEyDQowMXQwWTAwMDAwNzJOV1BRQTINCjAxdDBZMDAwMDA3Mk5XUVFBMg0KMDF0MFkwMDAwMDcyTldhUUFNDQowMXQwWTAwMDAwNzJOV2NRQU0NCjAxdDBZMDAwMDA3Mk5XZVFBTQ0KMDF0MFkwMDAwMDcyTldmUUFNDQowMXQwWTAwMDAwNzJOV2dRQU0NCjAxdDBZMDAwMDA3Mk5XaFFBTQ0KMDF0MFkwMDAwMDcyTldpUUFNDQowMXQwWTAwMDAwNzJOV2tRQU0NCjAxdDBZMDAwMDA3Mk5Xb1FBTQ0KMDF0MFkwMDAwMDcyTldwUUFNDQowMXQwWTAwMDAwNzJOV3hRQU0NCjAxdDBZMDAwMDA3Mk5YYlFBTQ0KMDF0MFkwMDAwMDcyTlhoUUFNDQowMXQwWTAwMDAwNzJOWGxRQU0NCjAxdDBZMDAwMDA3Mk5YbVFBTQ0KMDF0MFkwMDAwMDcyTlh0UUFNDQowMXQwWTAwMDAwNzJOWHhRQU0NCjAxdDBZMDAwMDA3Mk5YeVFBTQ0KMDF0MFkwMDAwMDcyTlkxUUFNDQowMXQwWTAwMDAwNzJOWTNRQU0NCjAxdDBZMDAwMDA3Mk5ZOFFBTQ0KMDF0MFkwMDAwMDcyTllCUUEyDQowMXQwWTAwMDAwNzJOWURRQTINCjAxdDBZMDAwMDA3Mk5ZR1FBMg0KMDF0MFkwMDAwMDcyTllIUUEyDQowMXQwWTAwMDAwNzJOWUlRQTINCjAxdDBZMDAwMDA3Mk5ZS1FBMg0KMDF0MFkwMDAwMDcyTllNUUEyDQowMXQwWTAwMDAwNzJOWVBRQTINCjAxdDBZMDAwMDA3Mk5ZVFFBMg0KMDF0MFkwMDAwMDcyTllpUUFNDQowMXQwWTAwMDAwNzJOWXJRQU0NCjAxdDBZMDAwMDA3Mk5Zd1FBTQ0KMDF0MFkwMDAwMDcyTll5UUFNDQowMXQwWTAwMDAwNzJOWktRQTINCjAxdDBZMDAwMDA3Mk5aZlFBTQ0KMDF0MFkwMDAwMDcyTlpoUUFNDQowMXQwWTAwMDAwNzJOWmlRQU0NCjAxdDBZMDAwMDA3Mk5abFFBTQ0KMDF0MFkwMDAwMDcyTlp6UUFNDQowMXQwWTAwMDAwNzJOYTNRQUUNCjAxdDBZMDAwMDA3Mk5hNVFBRQ0KMDF0MFkwMDAwMDcyTmE5UUFFDQowMXQwWTAwMDAwNzJOYUFRQVUNCjAxdDBZMDAwMDA3Mk5hQ1FBVQ0KMDF0MFkwMDAwMDcyTmFFUUFVDQowMXQwWTAwMDAwNzJOYVFRQVUNCjAxdDBZMDAwMDA3Mk5hWVFBVQ0KMDF0MFkwMDAwMDcyTmI3UUFFDQowMXQwWTAwMDAwNzJOYjhRQUUNCjAxdDBZMDAwMDA3Mk5iOVFBRQ0KMDF0MFkwMDAwMDcyTmJZUUFVDQowMXQwWTAwMDAwNzJOYmFRQUUNCjAxdDBZMDAwMDA3Mk5iZFFBRQ0KMDF0MFkwMDAwMDcyTmJmUUFFDQowMXQwWTAwMDAwNzJOYzNRQUUNCjAxdDBZMDAwMDA3Mk5jQVFBVQ0KMDF0MFkwMDAwMDcyTmNEUUFVDQowMXQwWTAwMDAwNzJOY0tRQVUNCjAxdDBZMDAwMDA3Mk5jTFFBVQ0KMDF0MFkwMDAwMDcyTmNTUUFVDQowMXQwWTAwMDAwNzJOY2lRQUUNCjAxdDBZMDAwMDA3Mk5jcFFBRQ0KMDF0MFkwMDAwMDcyTmNyUUFFDQowMXQwWTAwMDAwNzJOY3VRQUUNCjAxdDBZMDAwMDA3Mk5kMlFBRQ0KMDF0MFkwMDAwMDcyTmRBUUFVDQowMXQwWTAwMDAwNzJOZExRQVUNCjAxdDBZMDAwMDA3Mk5kU1FBVQ0KMDF0MFkwMDAwMDcyTmRUUUFVDQowMXQwWTAwMDAwNzJOZFpRQVUNCjAxdDBZMDAwMDA3Mk5kZ1FBRQ0KMDF0MFkwMDAwMDcyTmRoUUFFDQowMXQwWTAwMDAwNzJOZGlRQUUNCjAxdDBZMDAwMDA3Mk5ka1FBRQ0KMDF0MFkwMDAwMDcyTmRuUUFFDQowMXQwWTAwMDAwNzJOZHBRQUUNCjAxdDBZMDAwMDA3Mk5kdlFBRQ0KMDF0MFkwMDAwMDcyTmR3UUFFDQowMXQwWTAwMDAwNzJOZHhRQUUNCjAxdDBZMDAwMDA3Mk5keVFBRQ0KMDF0MFkwMDAwMDcyTmR6UUFFDQowMXQwWTAwMDAwNzJOZUNRQVUNCjAxdDBZMDAwMDA3Mk5lRFFBVQ0KMDF0MFkwMDAwMDcyTmVGUUFVDQowMXQwWTAwMDAwNzJOZUpRQVUNCjAxdDBZMDAwMDA3Mk5lTVFBVQ0KMDF0MFkwMDAwMDcyTmVOUUFVDQowMXQwWTAwMDAwNzJOZVBRQVUNCjAxdDBZMDAwMDA3Mk5lVVFBVQ0KMDF0MFkwMDAwMDcyTmVWUUFVDQowMXQwWTAwMDAwNzJOZVdRQVUNCjAxdDBZMDAwMDA3Mk5lWFFBVQ0KMDF0MFkwMDAwMDcyTmVZUUFVDQowMXQwWTAwMDAwNzJOZWJRQUUNCjAxdDBZMDAwMDA3Mk5lY1FBRQ0KMDF0MFkwMDAwMDcyTmVkUUFFDQowMXQwWTAwMDAwNzJOZWVRQUUNCjAxdDBZMDAwMDA3Mk5lZlFBRQ0KMDF0MFkwMDAwMDcyTmVpUUFFDQowMXQwWTAwMDAwNzJOZWpRQUUNCjAxdDBZMDAwMDA3Mk5la1FBRQ0KMDF0MFkwMDAwMDcyTmVsUUFFDQowMXQwWTAwMDAwNzJOZW1RQUUNCjAxdDBZMDAwMDA3Mk5ldlFBRQ0KMDF0MFkwMDAwMDcyTmV6UUFFDQowMXQwWTAwMDAwNzJOZjFRQUUNCjAxdDBZMDAwMDA3Mk5mMlFBRQ0KMDF0MFkwMDAwMDcyTmZFUUFVDQowMXQwWTAwMDAwNzJOZkpRQVUNCjAxdDBZMDAwMDA3Mk5mTFFBVQ0KMDF0MFkwMDAwMDcyTmZNUUFVDQowMXQwWTAwMDAwNzJOZk5RQVUNCjAxdDBZMDAwMDA3Mk5mT1FBVQ0KMDF0MFkwMDAwMDcyTmZRUUFVDQowMXQwWTAwMDAwNzJOZlNRQVUNCjAxdDBZMDAwMDA3Mk5mVFFBVQ0KMDF0MFkwMDAwMDcyTmZVUUFVDQowMXQwWTAwMDAwNzJOZlZRQVUNCjAxdDBZMDAwMDA3Mk5mWVFBVQ0KMDF0MFkwMDAwMDcyTmZhUUFFDQowMXQwWTAwMDAwNzJOZmpRQUUNCjAxdDBZMDAwMDA3Mk5mcVFBRQ0KMDF0MFkwMDAwMDcyTmZ1UUFFDQowMXQwWTAwMDAwNzJOZ1pRQVUNCjAxdDBZMDAwMDA3Mk5nZFFBRQ0KMDF0MFkwMDAwMDcyTmdtUUFFDQowMXQwWTAwMDAwNzJOZ3JRQUUNCjAxdDBZMDAwMDA3Mk5ndVFBRQ0KMDF0MFkwMDAwMDcyTmd4UUFFDQowMXQwWTAwMDAwNzJOZ3lRQUUNCjAxdDBZMDAwMDA3Mk5oMFFBRQ0KMDF0MFkwMDAwMDcyTmg3UUFFDQowMXQwWTAwMDAwNzJOaEJRQVUNCjAxdDBZMDAwMDA3Mk5oSFFBVQ0KMDF0MFkwMDAwMDcyTmhNUUFVDQowMXQwWTAwMDAwNzJOaFVRQVUNCjAxdDBZMDAwMDA3Mk5oVlFBVQ0KMDF0MFkwMDAwMDcyTmhhUUFFDQowMXQwWTAwMDAwNzJOaGNRQUUNCjAxdDBZMDAwMDA3Mk5oZFFBRQ0KMDF0MFkwMDAwMDcyTmhmUUFFDQowMXQwWTAwMDAwNzJOaTRRQUUNCjAxdDBZMDAwMDA3Mk5pTVFBVQ0KMDF0MFkwMDAwMDcyTmlOUUFVDQowMXQwWTAwMDAwNzJOaVBRQVUNCjAxdDBZMDAwMDA3Mk5pUVFBVQ0KMDF0MFkwMDAwMDcyTmlTUUFVDQowMXQwWTAwMDAwNzJOaVdRQVUNCjAxdDBZMDAwMDA3Mk5pWlFBVQ0KMDF0MFkwMDAwMDcyTmlkUUFFDQowMXQwWTAwMDAwNzJOaWVRQUUNCjAxdDBZMDAwMDA3Mk5paVFBRQ0KMDF0MFkwMDAwMDcyTmlrUUFFDQowMXQwWTAwMDAwNzJOaW1RQUUNCjAxdDBZMDAwMDA3Mk5pcVFBRQ0KMDF0MFkwMDAwMDcyTmozUUFFDQowMXQwWTAwMDAwNzJOakFRQVUNCjAxdDBZMDAwMDA3Mk5qS1FBVQ0KMDF0MFkwMDAwMDcyTmpiUUFFDQowMXQwWTAwMDAwNzJOam9RQUUNCjAxdDBZMDAwMDA3Mk5qcVFBRQ0KMDF0MFkwMDAwMDcyTmpzUUFFDQowMXQwWTAwMDAwNzJOanVRQUUNCjAxdDBZMDAwMDA3Mk5qeFFBRQ0KMDF0MFkwMDAwMDcyTmp5UUFFDQowMXQwWTAwMDAwNzJOazBRQUUNCjAxdDBZMDAwMDA3Mk5rM1FBRQ0KMDF0MFkwMDAwMDcyTms2UUFFDQowMXQwWTAwMDAwNzJOazdRQUUNCjAxdDBZMDAwMDA3Mk5rOVFBRQ0KMDF0MFkwMDAwMDcyTmtKUUFVDQowMXQwWTAwMDAwNzJOa0tRQVUNCjAxdDBZMDAwMDA3Mk5rTFFBVQ0KMDF0MFkwMDAwMDcyTmtUUUFVDQowMXQwWTAwMDAwNzJOa1VRQVUNCjAxdDBZMDAwMDA3Mk5rVlFBVQ0KMDF0MFkwMDAwMDcyTmt5UUFFDQowMXQwWTAwMDAwNzJOa3pRQUUNCjAxdDBZMDAwMDA3Mk5sNFFBRQ0KMDF0MFkwMDAwMDcyTmw3UUFFDQowMXQwWTAwMDAwNzJObEZRQVUNCjAxdDBZMDAwMDA3Mk5sSFFBVQ0KMDF0MFkwMDAwMDcyTmxPUUFVDQowMXQwWTAwMDAwNzJObFJRQVUNCjAxdDBZMDAwMDA3Mk5sVlFBVQ0KMDF0MFkwMDAwMDcyTmxZUUFVDQowMXQwWTAwMDAwNzJObGNRQUUNCjAxdDBZMDAwMDA3Mk5sZlFBRQ0KMDF0MFkwMDAwMDcyTmxqUUFFDQowMXQwWTAwMDAwNzJObGtRQUUNCjAxdDBZMDAwMDA3Mk5sd1FBRQ0KMDF0MFkwMDAwMDcyTm00UUFFDQowMXQwWTAwMDAwNzJObUtRQVUNCjAxdDBZMDAwMDA3Mk5tWFFBVQ0KMDF0MFkwMDAwMDcyTm1uUUFFDQowMXQwWTAwMDAwNzJObXJRQUUNCjAxdDBZMDAwMDA3Mk5tc1FBRQ0KMDF0MFkwMDAwMDcyTm10UUFFDQowMXQwWTAwMDAwNzJObXlRQUUNCjAxdDBZMDAwMDA3Mk5uMVFBRQ0KMDF0MFkwMDAwMDcyTm4yUUFFDQowMXQwWTAwMDAwNzJObjNRQUUNCjAxdDBZMDAwMDA3Mk5uNlFBRQ0KMDF0MFkwMDAwMDcyTm5EUUFVDQowMXQwWTAwMDAwNzJObkVRQVUNCjAxdDBZMDAwMDA3Mk5uSVFBVQ0KMDF0MFkwMDAwMDcyTm5NUUFVDQowMXQwWTAwMDAwNzJOblVRQVUNCjAxdDBZMDAwMDA3Mk5ualFBRQ0KMDF0MFkwMDAwMDcyTm5rUUFFDQowMXQwWTAwMDAwNzJObnJRQUUNCjAxdDBZMDAwMDA3Mk5udFFBRQ0KMDF0MFkwMDAwMDcyTm81UUFFDQowMXQwWTAwMDAwNzJObzdRQUUNCjAxdDBZMDAwMDA3Mk5vOVFBRQ0KMDF0MFkwMDAwMDcyTm9KUUFVDQowMXQwWTAwMDAwNzJOb05RQVUNCjAxdDBZMDAwMDA3Mk5vV1FBVQ0KMDF0MFkwMDAwMDcyTm9rUUFFDQowMXQwWTAwMDAwNzJOb3JRQUUNCjAxdDBZMDAwMDA3Mk5vc1FBRQ0KMDF0MFkwMDAwMDcyTm91UUFFDQowMXQwWTAwMDAwNzJOb3hRQUUNCjAxdDBZMDAwMDA3Mk5velFBRQ0KMDF0MFkwMDAwMDcyTnBBUUFVDQowMXQwWTAwMDAwNzJOcFVRQVUNCjAxdDBZMDAwMDA3Mk5wVlFBVQ0KMDF0MFkwMDAwMDcyTnBXUUFVDQowMXQwWTAwMDAwNzJOcGFRQUUNCjAxdDBZMDAwMDA3Mk5wYlFBRQ0KMDF0MFkwMDAwMDcyTnBlUUFFDQowMXQwWTAwMDAwNzJOcGlRQUUNCjAxdDBZMDAwMDA3Mk5walFBRQ0KMDF0MFkwMDAwMDcyTnByUUFFDQowMXQwWTAwMDAwNzJOcHNRQUUNCjAxdDBZMDAwMDA3Mk5xOVFBRQ0KMDF0MFkwMDAwMDcyTnFBUUFVDQowMXQwWTAwMDAwNzJOcUpRQVUNCjAxdDBZMDAwMDA3Mk5xb1FBRQ0KMDF0MFkwMDAwMDcyTnFwUUFFDQowMXQwWTAwMDAwNzJOcXJRQUUNCjAxdDBZMDAwMDA3Mk5yQ1FBVQ0KMDF0MFkwMDAwMDcyTnJFUUFVDQowMXQwWTAwMDAwNzJOcktRQVUNCjAxdDBZMDAwMDA3Mk5yTFFBVQ0KMDF0MFkwMDAwMDcyTnJOUUFVDQowMXQwWTAwMDAwNzJOclBRQVUNCjAxdDBZMDAwMDA3Mk5yWVFBVQ0KMDF0MFkwMDAwMDcyTnJvUUFFDQowMXQwWTAwMDAwNzJOczFRQUUNCjAxdDBZMDAwMDA3Mk5zN1FBRQ0KMDF0MFkwMDAwMDcyTnM4UUFFDQowMXQwWTAwMDAwNzJOc0RRQVUNCjAxdDBZMDAwMDA3Mk5zSFFBVQ0KMDF0MFkwMDAwMDcyTnNPUUFVDQowMXQwWTAwMDAwNzJOc1JRQVUNCjAxdDBZMDAwMDA3Mk5zV1FBVQ0KMDF0MFkwMDAwMDcyTnNnUUFFDQowMXQwWTAwMDAwNzJOc3BRQUUNCjAxdDBZMDAwMDA3Mk5zcVFBRQ0KMDF0MFkwMDAwMDcyTnNyUUFFDQowMXQwWTAwMDAwNzJOc3VRQUUNCjAxdDBZMDAwMDA3Mk50MFFBRQ0KMDF0MFkwMDAwMDcyTnQyUUFFDQowMXQwWTAwMDAwNzJOdDVRQUUNCjAxdDBZMDAwMDA3Mk50NlFBRQ0KMDF0MFkwMDAwMDcyTnQ5UUFFDQowMXQwWTAwMDAwNzJOdEJRQVUNCjAxdDBZMDAwMDA3Mk50SFFBVQ0KMDF0MFkwMDAwMDcyTnRMUUFVDQowMXQwWTAwMDAwNzJOdE9RQVUNCjAxdDBZMDAwMDA3Mk50bFFBRQ0KMDF0MFkwMDAwMDcyTnRuUUFFDQowMXQwWTAwMDAwNzJOdHJRQUUNCjAxdDBZMDAwMDA3Mk50dFFBRQ0KMDF0MFkwMDAwMDcyTnR1UUFFDQowMXQwWTAwMDAwNzJOdHZRQUUNCjAxdDBZMDAwMDA3Mk51MlFBRQ0KMDF0MFkwMDAwMDcyTnU3UUFFDQowMXQwWTAwMDAwNzJOdThRQUUNCjAxdDBZMDAwMDA3Mk51SVFBVQ0KMDF0MFkwMDAwMDcyTnVKUUFVDQowMXQwWTAwMDAwNzJOdU5RQVUNCjAxdDBZMDAwMDA3Mk51UFFBVQ0KMDF0MFkwMDAwMDcyTnVRUUFVDQowMXQwWTAwMDAwNzJOdVJRQVUNCjAxdDBZMDAwMDA3Mk51WlFBVQ0KMDF0MFkwMDAwMDcyTnVhUUFFDQowMXQwWTAwMDAwNzJOdWZRQUUNCjAxdDBZMDAwMDA3Mk51Z1FBRQ0KMDF0MFkwMDAwMDcyTnV5UUFFDQowMXQwWTAwMDAwNzJOdjJRQUUNCjAxdDBZMDAwMDA3Mk52M1FBRQ0KMDF0MFkwMDAwMDcyTnY0UUFFDQowMXQwWTAwMDAwNzJOdjZRQUUNCjAxdDBZMDAwMDA3Mk52SlFBVQ0KMDF0MFkwMDAwMDcyTnZNUUFVDQowMXQwWTAwMDAwNzJOdk5RQVUNCjAxdDBZMDAwMDA3Mk52T1FBVQ0KMDF0MFkwMDAwMDcyTnZQUUFVDQowMXQwWTAwMDAwNzJOdnNRQUUNCjAxdDBZMDAwMDA3Mk52dFFBRQ0KMDF0MFkwMDAwMDcyTnZ3UUFFDQowMXQwWTAwMDAwNzJOdnpRQUUNCjAxdDBZMDAwMDA3Mk53MFFBRQ0KMDF0MFkwMDAwMDcyTnc1UUFFDQowMXQwWTAwMDAwNzJOdzZRQUUNCjAxdDBZMDAwMDA3Mk53QVFBVQ0KMDF0MFkwMDAwMDcyTndIUUFVDQowMXQwWTAwMDAwNzJOd0lRQVUNCjAxdDBZMDAwMDA3Mk53TFFBVQ0KMDF0MFkwMDAwMDcyTndZUUFVDQowMXQwWTAwMDAwNzJOd1pRQVUNCjAxdDBZMDAwMDA3Mk53YlFBRQ0KMDF0MFkwMDAwMDcyTndjUUFFDQowMXQwWTAwMDAwNzJOd2RRQUUNCjAxdDBZMDAwMDA3Mk53ZVFBRQ0KMDF0MFkwMDAwMDcyTndtUUFFDQowMXQwWTAwMDAwNzJOd29RQUUNCjAxdDBZMDAwMDA3Mk53cFFBRQ0KMDF0MFkwMDAwMDcyTndyUUFFDQowMXQwWTAwMDAwNzJOd3NRQUUNCjAxdDBZMDAwMDA3Mk53dFFBRQ0KMDF0MFkwMDAwMDcyTnd1UUFFDQowMXQwWTAwMDAwNzJOd3ZRQUUNCjAxdDBZMDAwMDA3Mk54MFFBRQ0KMDF0MFkwMDAwMDcyTngyUUFFDQowMXQwWTAwMDAwNzJOeDRRQUUNCjAxdDBZMDAwMDA3Mk54NVFBRQ0KMDF0MFkwMDAwMDcyTnhHUUFVDQowMXQwWTAwMDAwNzJOeE1RQVUNCjAxdDBZMDAwMDA3Mk54V1FBVQ0KMDF0MFkwMDAwMDcyTnhYUUFVDQowMXQwWTAwMDAwNzJOeGxRQUUNCjAxdDBZMDAwMDA3Mk55U1FBVQ0KMDF0MFkwMDAwMDcyTnlUUUFVDQowMXQwWTAwMDAwNzJOeVdRQVUNCjAxdDBZMDAwMDA3Mk55WlFBVQ0KMDF0MFkwMDAwMDcyTnlkUUFFDQowMXQwWTAwMDAwNzJOeWpRQUUNCjAxdDBZMDAwMDA3Mk55b1FBRQ0KMDF0MFkwMDAwMDcyTnowUUFFDQowMXQwWTAwMDAwNzJOejdRQUUNCjAxdDBZMDAwMDA3Mk56OVFBRQ0KMDF0MFkwMDAwMDcyTnpHUUFVDQowMXQwWTAwMDAwNzJOekxRQVUNCjAxdDBZMDAwMDA3Mk56blFBRQ0KMDF0MFkwMDAwMDcyTnpvUUFFDQowMXQwWTAwMDAwNzJOenNRQUUNCjAxdDBZMDAwMDA3Mk56dFFBRQ0KMDF0MFkwMDAwMDcyTnp2UUFFDQowMXQwWTAwMDAwNzJPMEpRQVUNCjAxdDBZMDAwMDA3Mk8wYlFBRQ0KMDF0MFkwMDAwMDcyTzBjUUFFDQowMXQwWTAwMDAwNzJPMHpRQUUNCjAxdDBZMDAwMDA3Mk8xM1FBRQ0KMDF0MFkwMDAwMDcyTzFGUUFVDQowMXQwWTAwMDAwNzJPMUtRQVUNCjAxdDBZMDAwMDA3Mk8xTFFBVQ0KMDF0MFkwMDAwMDcyTzFPUUFVDQowMXQwWTAwMDAwNzJPMVBRQVUNCjAxdDBZMDAwMDA3Mk8xUVFBVQ0KMDF0MFkwMDAwMDcyTzFVUUFVDQowMXQwWTAwMDAwNzJPMVZRQVUNCjAxdDBZMDAwMDA3Mk8xbFFBRQ0KMDF0MFkwMDAwMDcyTzFwUUFFDQowMXQwWTAwMDAwNzJPMXFRQUUNCjAxdDBZMDAwMDA3Mk8xdlFBRQ0KMDF0MFkwMDAwMDcyTzIxUUFFDQowMXQwWTAwMDAwNzJPMjJRQUUNCjAxdDBZMDAwMDA3Mk8yOVFBRQ0KMDF0MFkwMDAwMDcyTzJDUUFVDQowMXQwWTAwMDAwNzJPMkxRQVUNCjAxdDBZMDAwMDA3Mk8yZ1FBRQ0KMDF0MFkwMDAwMDcyTzJoUUFFDQowMXQwWTAwMDAwNzJPMmpRQUUNCjAxdDBZMDAwMDA3Mk8ya1FBRQ0KMDF0MFkwMDAwMDcyTzJsUUFFDQowMXQwWTAwMDAwNzJPMm1RQUUNCjAxdDBZMDAwMDA3Mk8zMFFBRQ0KMDF0MFkwMDAwMDcyTzMyUUFFDQowMXQwWTAwMDAwNzJPMzRRQUUNCjAxdDBZMDAwMDA3Mk8zN1FBRQ0KMDF0MFkwMDAwMDcyTzM4UUFFDQowMXQwWTAwMDAwNzJPMzlRQUUNCjAxdDBZMDAwMDA3Mk8za1FBRQ0KMDF0MFkwMDAwMDcyTzNtUUFFDQowMXQwWTAwMDAwNzJPNDRRQUUNCjAxdDBZMDAwMDA3Mk80NVFBRQ0KMDF0MFkwMDAwMDcyTzRCUUFVDQowMXQwWTAwMDAwNzJPNERRQVUNCjAxdDBZMDAwMDA3Mk80RlFBVQ0KMDF0MFkwMDAwMDcyTzROUUFVDQowMXQwWTAwMDAwNzJPNE9RQVUNCjAxdDBZMDAwMDA3Mk80UVFBVQ0KMDF0MFkwMDAwMDcyTzRUUUFVDQowMXQwWTAwMDAwNzJPNFZRQVUNCjAxdDBZMDAwMDA3Mk80WFFBVQ0KMDF0MFkwMDAwMDcyTzRaUUFVDQowMXQwWTAwMDAwNzJPNGFRQUUNCjAxdDBZMDAwMDA3Mk80YlFBRQ0KMDF0MFkwMDAwMDcyTzRkUUFFDQowMXQwWTAwMDAwNzJPNGVRQUUNCjAxdDBZMDAwMDA3Mk80ZlFBRQ0KMDF0MFkwMDAwMDcyTzRnUUFFDQowMXQwWTAwMDAwNzJPNGtRQUUNCjAxdDBZMDAwMDA3Mk80cVFBRQ0KMDF0MFkwMDAwMDcyTzRyUUFFDQowMXQwWTAwMDAwNzJPNHRRQUUNCjAxdDBZMDAwMDA3Mk80d1FBRQ0KMDF0MFkwMDAwMDcyTzR4UUFFDQowMXQwWTAwMDAwNzJPNHlRQUUNCjAxdDBZMDAwMDA3Mk81RFFBVQ0KMDF0MFkwMDAwMDcyTzVKUUFVDQowMXQwWTAwMDAwNzJPNUtRQVUNCjAxdDBZMDAwMDA3Mk82MFFBRQ0KMDF0MFkwMDAwMDcyTzYyUUFFDQowMXQwWTAwMDAwNzJPNjdRQUUNCjAxdDBZMDAwMDA3Mk82OFFBRQ0KMDF0MFkwMDAwMDcyTzZCUUFVDQowMXQwWTAwMDAwNzJPNkNRQVUNCjAxdDBZMDAwMDA3Mk82R1FBVQ0KMDF0MFkwMDAwMDcyTzZLUUFVDQowMXQwWTAwMDAwNzJPNlBRQVUNCjAxdDBZMDAwMDA3Mk82UlFBVQ0KMDF0MFkwMDAwMDcyTzZVUUFVDQowMXQwWTAwMDAwNzJPNzNRQUUNCjAxdDBZMDAwMDA3Mk83N1FBRQ0KMDF0MFkwMDAwMDcyTzdEUUFVDQowMXQwWTAwMDAwNzJPN0pRQVUNCjAxdDBZMDAwMDA3Mk83TFFBVQ0KMDF0MFkwMDAwMDcyTzdPUUFVDQowMXQwWTAwMDAwNzJPN1dRQVUNCjAxdDBZMDAwMDA3Mk83alFBRQ0KMDF0MFkwMDAwMDcyTzg5UUFFDQowMXQwWTAwMDAwNzJPOEJRQVUNCjAxdDBZMDAwMDA3Mk84RFFBVQ0KMDF0MFkwMDAwMDcyTzhHUUFVDQowMXQwWTAwMDAwNzJPOEtRQVUNCjAxdDBZMDAwMDA3Mk84UVFBVQ0KMDF0MFkwMDAwMDcyTzh2UUFFDQowMXQwWTAwMDAwNzJPOHlRQUUNCjAxdDBZMDAwMDA3Mk84elFBRQ0KMDF0MFkwMDAwMDcyTzkyUUFFDQowMXQwWTAwMDAwNzJPOTNRQUUNCjAxdDBZMDAwMDA3Mk85NFFBRQ0KMDF0MFkwMDAwMDcyTzk5UUFFDQowMXQwWTAwMDAwNzJPOUZRQVUNCjAxdDBZMDAwMDA3Mk85ZFFBRQ0KMDF0MFkwMDAwMDcyTzlrUUFFDQowMXQwWTAwMDAwNzJPOW1RQUUNCjAxdDBZMDAwMDA3Mk85dFFBRQ0KMDF0MFkwMDAwMDcyTzl1UUFFDQowMXQwWTAwMDAwNzJPQTBRQU0NCjAxdDBZMDAwMDA3Mk9BMlFBTQ0KMDF0MFkwMDAwMDcyT0E0UUFNDQowMXQwWTAwMDAwNzJPQTdRQU0NCjAxdDBZMDAwMDA3Mk9BOVFBTQ0KMDF0MFkwMDAwMDcyT0FEUUEyDQowMXQwWTAwMDAwNzJPQUZRQTINCjAxdDBZMDAwMDA3Mk9BUlFBMg0KMDF0MFkwMDAwMDcyT0FVUUEyDQowMXQwWTAwMDAwNzJPQVZRQTINCjAxdDBZMDAwMDA3Mk9BV1FBMg0KMDF0MFkwMDAwMDcyT0FYUUEyDQowMXQwWTAwMDAwNzJPQVpRQTINCjAxdDBZMDAwMDA3Mk9BYVFBTQ0KMDF0MFkwMDAwMDcyT0FpUUFNDQowMXQwWTAwMDAwNzJPQWpRQU0NCjAxdDBZMDAwMDA3Mk9BblFBTQ0KMDF0MFkwMDAwMDcyT0FwUUFNDQowMXQwWTAwMDAwNzJPQXFRQU0NCjAxdDBZMDAwMDA3Mk9BclFBTQ0KMDF0MFkwMDAwMDcyT0FzUUFNDQowMXQwWTAwMDAwNzJPQXZRQU0NCjAxdDBZMDAwMDA3Mk9Bd1FBTQ0KMDF0MFkwMDAwMDcyT0F5UUFNDQowMXQwWTAwMDAwNzJPQjlRQU0NCjAxdDBZMDAwMDA3Mk9CQVFBMg0KMDF0MFkwMDAwMDcyT0J4UUFNDQowMXQwWTAwMDAwNzJPQnlRQU0NCjAxdDBZMDAwMDA3Mk9DMVFBTQ0KMDF0MFkwMDAwMDcyT0M2UUFNDQowMXQwWTAwMDAwNzJPQ0FRQTINCjAxdDBZMDAwMDA3Mk9DQ1FBMg0KMDF0MFkwMDAwMDcyT0NEUUEyDQowMXQwWTAwMDAwNzJPQ0xRQTINCjAxdDBZMDAwMDA3Mk9DUVFBMg0KMDF0MFkwMDAwMDcyT0NjUUFNDQowMXQwWTAwMDAwNzJPQ2RRQU0NCjAxdDBZMDAwMDA3Mk9DZlFBTQ0KMDF0MFkwMDAwMDcyT0QxUUFNDQowMXQwWTAwMDAwNzJPRDhRQU0NCjAxdDBZMDAwMDA3Mk9ETFFBMg0KMDF0MFkwMDAwMDcyT0RVUUEyDQowMXQwWTAwMDAwNzJPRFZRQTINCjAxdDBZMDAwMDA3Mk9EWFFBMg0KMDF0MFkwMDAwMDcyT0RaUUEyDQowMXQwWTAwMDAwNzJPRG1RQU0NCjAxdDBZMDAwMDA3Mk9Eb1FBTQ0KMDF0MFkwMDAwMDcyT0RxUUFNDQowMXQwWTAwMDAwNzJPRHJRQU0NCjAxdDBZMDAwMDA3Mk9EdFFBTQ0KMDF0MFkwMDAwMDcyT0R1UUFNDQowMXQwWTAwMDAwNzJPRHZRQU0NCjAxdDBZMDAwMDA3Mk9EeFFBTQ0KMDF0MFkwMDAwMDcyT0R6UUFNDQowMXQwWTAwMDAwNzJPRTBRQU0NCjAxdDBZMDAwMDA3Mk9FNlFBTQ0KMDF0MFkwMDAwMDcyT0VBUUEyDQowMXQwWTAwMDAwNzJPRUJRQTINCjAxdDBZMDAwMDA3Mk9FQ1FBMg0KMDF0MFkwMDAwMDcyT0VFUUEyDQowMXQwWTAwMDAwNzJPRUdRQTINCjAxdDBZMDAwMDA3Mk9FSlFBMg0KMDF0MFkwMDAwMDcyT0VOUUEyDQowMXQwWTAwMDAwNzJPRVFRQTINCjAxdDBZMDAwMDA3Mk9FU1FBMg0KMDF0MFkwMDAwMDcyT0VrUUFNDQowMXQwWTAwMDAwNzJPRXFRQU0NCjAxdDBZMDAwMDA3Mk9FdVFBTQ0KMDF0MFkwMDAwMDcyT0V3UUFNDQowMXQwWTAwMDAwNzJPRmZRQU0NCjAxdDBZMDAwMDA3Mk9GbVFBTQ0KMDF0MFkwMDAwMDcyT0ZxUUFNDQowMXQwWTAwMDAwNzJPRnNRQU0NCjAxdDBZMDAwMDA3Mk9GdVFBTQ0KMDF0MFkwMDAwMDcyT0Z3UUFNDQowMXQwWTAwMDAwNzJPRnpRQU0NCjAxdDBZMDAwMDA3Mk9HMlFBTQ0KMDF0MFkwMDAwMDcyT0dEUUEyDQowMXQwWTAwMDAwNzJPR0pRQTINCjAxdDBZMDAwMDA3Mk9HVVFBMg0KMDF0MFkwMDAwMDcyT0dhUUFNDQowMXQwWTAwMDAwNzJPR2JRQU0NCjAxdDBZMDAwMDA3Mk9HZFFBTQ0KMDF0MFkwMDAwMDcyT0dlUUFNDQowMXQwWTAwMDAwNzJPR2ZRQU0NCjAxdDBZMDAwMDA3Mk9HZ1FBTQ0KMDF0MFkwMDAwMDcyT0dqUUFNDQowMXQwWTAwMDAwNzJPR25RQU0NCjAxdDBZMDAwMDA3Mk9HdFFBTQ0KMDF0MFkwMDAwMDcyT0gzUUFNDQowMXQwWTAwMDAwNzJPSDRRQU0NCjAxdDBZMDAwMDA3Mk9IOVFBTQ0KMDF0MFkwMDAwMDcyT0hJUUEyDQowMXQwWTAwMDAwNzJPSEpRQTINCjAxdDBZMDAwMDA3Mk9IbFFBTQ0KMDF0MFkwMDAwMDcyT0htUUFNDQowMXQwWTAwMDAwNzJPSG9RQU0NCjAxdDBZMDAwMDA3Mk9IcFFBTQ0KMDF0MFkwMDAwMDcyT0hyUUFNDQowMXQwWTAwMDAwNzJPSHZRQU0NCjAxdDBZMDAwMDA3Mk9Id1FBTQ0KMDF0MFkwMDAwMDcyT0h6UUFNDQowMXQwWTAwMDAwNzJPSUFRQTINCjAxdDBZMDAwMDA3Mk9JQlFBMg0KMDF0MFkwMDAwMDcyT0lEUUEyDQowMXQwWTAwMDAwNzJPSUVRQTINCjAxdDBZMDAwMDA3Mk9JSlFBMg0KMDF0MFkwMDAwMDcyT0lLUUEyDQowMXQwWTAwMDAwNzJPSUxRQTINCjAxdDBZMDAwMDA3Mk9JUlFBMg0KMDF0MFkwMDAwMDcyT0lXUUEyDQowMXQwWTAwMDAwNzJPSVpRQTINCjAxdDBZMDAwMDA3Mk9JYlFBTQ0KMDF0MFkwMDAwMDcyT0lxUUFNDQowMXQwWTAwMDAwNzJPSXJRQU0NCjAxdDBZMDAwMDA3Mk9KRFFBMg0KMDF0MFkwMDAwMDcyT0pGUUEyDQowMXQwWTAwMDAwNzJPSlZRQTINCjAxdDBZMDAwMDA3Mk9KbFFBTQ0KMDF0MFkwMDAwMDcyT0ptUUFNDQowMXQwWTAwMDAwNzJPSzRRQU0NCjAxdDBZMDAwMDA3Mk9LN1FBTQ0KMDF0MFkwMDAwMDcyT0s4UUFNDQowMXQwWTAwMDAwNzJPS3ZRQU0NCjAxdDBZMDAwMDA3Mk9MMVFBTQ0KMDF0MFkwMDAwMDcyT0wyUUFNDQowMXQwWTAwMDAwNzJPTDVRQU0NCjAxdDBZMDAwMDA3Mk9MN1FBTQ0KMDF0MFkwMDAwMDcyT0xFUUEyDQowMXQwWTAwMDAwNzJPTFNRQTINCjAxdDBZMDAwMDA3Mk9MZFFBTQ0KMDF0MFkwMDAwMDcyT0xlUUFNDQowMXQwWTAwMDAwNzJPTGlRQU0NCjAxdDBZMDAwMDA3Mk9Md1FBTQ0KMDF0MFkwMDAwMDcyT0x5UUFNDQowMXQwWTAwMDAwNzJPTThRQU0NCjAxdDBZMDAwMDA3Mk9NQVFBMg0KMDF0MFkwMDAwMDcyT01DUUEyDQowMXQwWTAwMDAwNzJPTURRQTINCjAxdDBZMDAwMDA3Mk9NSFFBMg0KMDF0MFkwMDAwMDcyT01VUUEyDQowMXQwWTAwMDAwNzJPTVdRQTINCjAxdDBZMDAwMDA3Mk9NWFFBMg0KMDF0MFkwMDAwMDcyT01ZUUEyDQowMXQwWTAwMDAwNzJPTWRRQU0NCjAxdDBZMDAwMDA3Mk9NZVFBTQ0KMDF0MFkwMDAwMDcyT01sUUFNDQowMXQwWTAwMDAwNzJPTW5RQU0NCjAxdDBZMDAwMDA3Mk9NdFFBTQ0KMDF0MFkwMDAwMDcyT011UUFNDQowMXQwWTAwMDAwNzJPTXdRQU0NCjAxdDBZMDAwMDA3Mk9NeFFBTQ0KMDF0MFkwMDAwMDcyT04xUUFNDQowMXQwWTAwMDAwNzJPTkFRQTINCjAxdDBZMDAwMDA3Mk9ORFFBMg0KMDF0MFkwMDAwMDcyT05PUUEyDQowMXQwWTAwMDAwNzJPT0FRQTINCjAxdDBZMDAwMDA3Mk9PQlFBMg0KMDF0MFkwMDAwMDcyT09GUUEyDQowMXQwWTAwMDAwNzJPT0pRQTINCjAxdDBZMDAwMDA3Mk9PTFFBMg0KMDF0MFkwMDAwMDcyT09OUUEyDQowMXQwWTAwMDAwNzJPT1NRQTINCjAxdDBZMDAwMDA3Mk9PcFFBTQ0KMDF0MFkwMDAwMDcyT09yUUFNDQowMXQwWTAwMDAwNzJPUEFRQTINCjAxdDBZMDAwMDA3Mk9QTlFBMg0KMDF0MFkwMDAwMDcyT1BPUUEyDQowMXQwWTAwMDAwNzJPUFBRQTINCjAxdDBZMDAwMDA3Mk9QV1FBMg0KMDF0MFkwMDAwMDcyT1BmUUFNDQowMXQwWTAwMDAwNzJPUGdRQU0NCjAxdDBZMDAwMDA3Mk9QaVFBTQ0KMDF0MFkwMDAwMDcyT1BtUUFNDQowMXQwWTAwMDAwNzJPUG9RQU0NCjAxdDBZMDAwMDA3Mk9QclFBTQ0KMDF0MFkwMDAwMDcyT1B0UUFNDQowMXQwWTAwMDAwNzJPUHVRQU0NCjAxdDBZMDAwMDA3Mk9QdlFBTQ0KMDF0MFkwMDAwMDcyT1E4UUFNDQowMXQwWTAwMDAwNzJPUUVRQTINCjAxdDBZMDAwMDA3Mk9RTlFBMg0KMDF0MFkwMDAwMDcyT1FRUUEyDQowMXQwWTAwMDAwNzJPUVpRQTINCjAxdDBZMDAwMDA3Mk9ReVFBTQ0KMDF0MFkwMDAwMDcyT1IxUUFNDQowMXQwWTAwMDAwNzJPUkRRQTINCjAxdDBZMDAwMDA3Mk9STFFBMg0KMDF0MFkwMDAwMDcyT1JRUUEyDQowMXQwWTAwMDAwNzJPUlhRQTINCjAxdDBZMDAwMDA3Mk9SWVFBMg0KMDF0MFkwMDAwMDcyT1JlUUFNDQowMXQwWTAwMDAwNzJPUmxRQU0NCjAxdDBZMDAwMDA3Mk9Sb1FBTQ0KMDF0MFkwMDAwMDcyT1JzUUFNDQowMXQwWTAwMDAwNzJPUnZRQU0NCjAxdDBZMDAwMDA3Mk9TMlFBTQ0KMDF0MFkwMDAwMDcyT1NTUUEyDQowMXQwWTAwMDAwNzJPU2NRQU0NCjAxdDBZMDAwMDA3Mk9TZFFBTQ0KMDF0MFkwMDAwMDcyT1NlUUFNDQowMXQwWTAwMDAwNzJPU2lRQU0NCjAxdDBZMDAwMDA3Mk9TbFFBTQ0KMDF0MFkwMDAwMDcyT1NtUUFNDQowMXQwWTAwMDAwNzJPU3BRQU0NCjAxdDBZMDAwMDA3Mk9TdVFBTQ0KMDF0MFkwMDAwMDcyT1N2UUFNDQowMXQwWTAwMDAwNzJPU3lRQU0NCjAxdDBZMDAwMDA3Mk9UMFFBTQ0KMDF0MFkwMDAwMDcyT1QzUUFNDQowMXQwWTAwMDAwNzJPVDRRQU0NCjAxdDBZMDAwMDA3Mk9UN1FBTQ0KMDF0MFkwMDAwMDcyT1RBUUEyDQowMXQwWTAwMDAwNzJPVENRQTINCjAxdDBZMDAwMDA3Mk9URFFBMg0KMDF0MFkwMDAwMDcyT1RFUUEyDQowMXQwWTAwMDAwNzJPVEZRQTINCjAxdDBZMDAwMDA3Mk9UR1FBMg0KMDF0MFkwMDAwMDcyT1RIUUEyDQowMXQwWTAwMDAwNzJPVEtRQTINCjAxdDBZMDAwMDA3Mk9UTFFBMg0KMDF0MFkwMDAwMDcyT1ROUUEyDQowMXQwWTAwMDAwNzJPVFFRQTINCjAxdDBZMDAwMDA3Mk9UUlFBMg0KMDF0MFkwMDAwMDcyT1RTUUEyDQowMXQwWTAwMDAwNzJPVFRRQTINCjAxdDBZMDAwMDA3Mk9UV1FBMg0KMDF0MFkwMDAwMDcyT1RhUUFNDQowMXQwWTAwMDAwNzJPVTBRQU0NCjAxdDBZMDAwMDA3Mk9VMVFBTQ0KMDF0MFkwMDAwMDcyT1U2UUFNDQowMXQwWTAwMDAwNzJPVTlRQU0NCjAxdDBZMDAwMDA3Mk9VR1FBMg0KMDF0MFkwMDAwMDcyT1VIUUEyDQowMXQwWTAwMDAwNzJPVUlRQTINCjAxdDBZMDAwMDA3Mk9VUlFBMg0KMDF0MFkwMDAwMDcyT1VTUUEyDQowMXQwWTAwMDAwNzJPVmZRQU0NCjAxdDBZMDAwMDA3Mk9Wa1FBTQ0KMDF0MFkwMDAwMDcyT1ZtUUFNDQowMXQwWTAwMDAwNzJPVnFRQU0NCjAxdDBZMDAwMDA3Mk9WclFBTQ0KMDF0MFkwMDAwMDcyT1czUUFNDQowMXQwWTAwMDAwNzJPVzRRQU0NCjAxdDBZMDAwMDA3Mk9XR1FBMg0KMDF0MFkwMDAwMDcyT1dNUUEyDQowMXQwWTAwMDAwNzJPV1FRQTINCjAxdDBZMDAwMDA3Mk9XU1FBMg0KMDF0MFkwMDAwMDcyT1dUUUEyDQowMXQwWTAwMDAwNzJPV2RRQU0NCjAxdDBZMDAwMDA3Mk9XaFFBTQ0KMDF0MFkwMDAwMDcyT1duUUFNDQowMXQwWTAwMDAwNzJPV3ZRQU0NCjAxdDBZMDAwMDA3Mk9YNFFBTQ0KMDF0MFkwMDAwMDcyT1hCUUEyDQowMXQwWTAwMDAwNzJPWFRRQTINCjAxdDBZMDAwMDA3Mk9YaVFBTQ0KMDF0MFkwMDAwMDcyT1hrUUFNDQowMXQwWTAwMDAwNzJPWHNRQU0NCjAxdDBZMDAwMDA3Mk9YdFFBTQ0KMDF0MFkwMDAwMDcyT1h1UUFNDQowMXQwWTAwMDAwNzJPWHZRQU0NCjAxdDBZMDAwMDA3Mk9ZMVFBTQ0KMDF0MFkwMDAwMDcyT1kyUUFNDQowMXQwWTAwMDAwNzJPWTNRQU0NCjAxdDBZMDAwMDA3Mk9ZNFFBTQ0KMDF0MFkwMDAwMDcyT1k2UUFNDQowMXQwWTAwMDAwNzJPWTdRQU0NCjAxdDBZMDAwMDA3Mk9ZQVFBMg0KMDF0MFkwMDAwMDcyT1lFUUEyDQowMXQwWTAwMDAwNzJPWUhRQTINCjAxdDBZMDAwMDA3Mk9ZSlFBMg0KMDF0MFkwMDAwMDcyT1lMUUEyDQowMXQwWTAwMDAwNzJPWVNRQTINCjAxdDBZMDAwMDA3Mk9ZWlFBMg0KMDF0MFkwMDAwMDcyT1lpUUFNDQowMXQwWTAwMDAwNzJPWW1RQU0NCjAxdDBZMDAwMDA3Mk9ZblFBTQ0KMDF0MFkwMDAwMDcyT1lvUUFNDQowMXQwWTAwMDAwNzJPWXBRQU0NCjAxdDBZMDAwMDA3Mk9ZcVFBTQ0KMDF0MFkwMDAwMDcyT1l0UUFNDQowMXQwWTAwMDAwNzJPWXZRQU0NCjAxdDBZMDAwMDA3Mk9ZeVFBTQ0KMDF0MFkwMDAwMDcyT1oyUUFNDQowMXQwWTAwMDAwNzJPWjdRQU0NCjAxdDBZMDAwMDA3Mk9aOFFBTQ0KMDF0MFkwMDAwMDcyT1pDUUEyDQowMXQwWTAwMDAwNzJPWkVRQTINCjAxdDBZMDAwMDA3Mk9aTlFBMg0KMDF0MFkwMDAwMDcyT1pPUUEyDQowMXQwWTAwMDAwNzJPWm9RQU0NCjAxdDBZMDAwMDA3Mk9adVFBTQ0KMDF0MFkwMDAwMDcyT2FwUUFFDQowMXQwWTAwMDAwNzJPYXJRQUUNCjAxdDBZMDAwMDA3Mk9hc1FBRQ0KMDF0MFkwMDAwMDcyT2F0UUFFDQowMXQwWTAwMDAwNzJPYXZRQUUNCjAxdDBZMDAwMDA3Mk9iOFFBRQ0KMDF0MFkwMDAwMDcyT2JHUUFVDQowMXQwWTAwMDAwNzJPYk5RQVUNCjAxdDBZMDAwMDA3Mk9iclFBRQ0KMDF0MFkwMDAwMDcyT2J0UUFFDQowMXQwWTAwMDAwNzJPYnhRQUUNCjAxdDBZMDAwMDA3Mk9jNFFBRQ0KMDF0MFkwMDAwMDcyT2M3UUFFDQowMXQwWTAwMDAwNzJPY0RRQVUNCjAxdDBZMDAwMDA3Mk9jSVFBVQ0KMDF0MFkwMDAwMDcyT2NKUUFVDQowMXQwWTAwMDAwNzJPY0tRQVUNCjAxdDBZMDAwMDA3Mk9jTVFBVQ0KMDF0MFkwMDAwMDcyT2NQUUFVDQowMXQwWTAwMDAwNzJPY1JRQVUNCjAxdDBZMDAwMDA3Mk9jVlFBVQ0KMDF0MFkwMDAwMDcyT2NmUUFFDQowMXQwWTAwMDAwNzJPY2hRQUUNCjAxdDBZMDAwMDA3Mk9jcFFBRQ0KMDF0MFkwMDAwMDcyT2N0UUFFDQowMXQwWTAwMDAwNzJPY3pRQUUNCjAxdDBZMDAwMDA3Mk9kNVFBRQ0KMDF0MFkwMDAwMDcyT2REUUFVDQowMXQwWTAwMDAwNzJPZEpRQVUNCjAxdDBZMDAwMDA3Mk9kS1FBVQ0KMDF0MFkwMDAwMDcyT2RMUUFVDQowMXQwWTAwMDAwNzJPZFBRQVUNCjAxdDBZMDAwMDA3Mk9kZFFBRQ0KMDF0MFkwMDAwMDcyT2RsUUFFDQowMXQwWTAwMDAwNzJPZTdRQUUNCjAxdDBZMDAwMDA3Mk9lQVFBVQ0KMDF0MFkwMDAwMDcyT2VHUUFVDQowMXQwWTAwMDAwNzJPZU5RQVUNCjAxdDBZMDAwMDA3Mk9lWVFBVQ0KMDF0MFkwMDAwMDcyT2VaUUFVDQowMXQwWTAwMDAwNzJPZWtRQUUNCjAxdDBZMDAwMDA3Mk9lblFBRQ0KMDF0MFkwMDAwMDcyT2VwUUFFDQowMXQwWTAwMDAwNzJPZkFRQVUNCjAxdDBZMDAwMDA3Mk9mQlFBVQ0KMDF0MFkwMDAwMDcyT2ZHUUFVDQowMXQwWTAwMDAwNzJPZkhRQVUNCjAxdDBZMDAwMDA3Mk9mSlFBVQ0KMDF0MFkwMDAwMDcyT2ZPUUFVDQowMXQwWTAwMDAwNzJPZlFRQVUNCjAxdDBZMDAwMDA3Mk9mVFFBVQ0KMDF0MFkwMDAwMDcyT2ZZUUFVDQowMXQwWTAwMDAwNzJPZlpRQVUNCjAxdDBZMDAwMDA3Mk9mY1FBRQ0KMDF0MFkwMDAwMDcyT2ZlUUFFDQowMXQwWTAwMDAwNzJPZmhRQUUNCjAxdDBZMDAwMDA3Mk9maVFBRQ0KMDF0MFkwMDAwMDcyT2ZrUUFFDQowMXQwWTAwMDAwNzJPZnBRQUUNCjAxdDBZMDAwMDA3Mk9mclFBRQ0KMDF0MFkwMDAwMDcyT2cwUUFFDQowMXQwWTAwMDAwNzJPZzFRQUUNCjAxdDBZMDAwMDA3Mk9nMlFBRQ0KMDF0MFkwMDAwMDcyT2dHUUFVDQowMXQwWTAwMDAwNzJPZ0lRQVUNCjAxdDBZMDAwMDA3Mk9nSlFBVQ0KMDF0MFkwMDAwMDcyT2dLUUFVDQowMXQwWTAwMDAwNzJPZ0xRQVUNCjAxdDBZMDAwMDA3Mk9nVFFBVQ0KMDF0MFkwMDAwMDcyT2dXUUFVDQowMXQwWTAwMDAwNzJPZ1hRQVUNCjAxdDBZMDAwMDA3Mk9nWVFBVQ0KMDF0MFkwMDAwMDcyT2diUUFFDQowMXQwWTAwMDAwNzJPZ2VRQUUNCjAxdDBZMDAwMDA3Mk9pQlFBVQ0KMDF0MFkwMDAwMDcyT2lDUUFVDQowMXQwWTAwMDAwNzJPaURRQVUNCjAxdDBZMDAwMDA3Mk9pRVFBVQ0KMDF0MFkwMDAwMDcyT2lIUUFVDQowMXQwWTAwMDAwNzJPaUtRQVUNCjAxdDBZMDAwMDA3Mk9pUVFBVQ0KMDF0MFkwMDAwMDcyT2lTUUFVDQowMXQwWTAwMDAwNzJPaW1RQUUNCjAxdDBZMDAwMDA3Mk9peFFBRQ0KMDF0MFkwMDAwMDcyT2l6UUFFDQowMXQwWTAwMDAwNzJPakRRQVUNCjAxdDBZMDAwMDA3Mk9qSVFBVQ0KMDF0MFkwMDAwMDcyT2pNUUFVDQowMXQwWTAwMDAwNzJPalpRQVUNCjAxdDBZMDAwMDA3Mk9qYlFBRQ0KMDF0MFkwMDAwMDcyT2pmUUFFDQowMXQwWTAwMDAwNzJPamdRQUUNCjAxdDBZMDAwMDA3Mk9qc1FBRQ0KMDF0MFkwMDAwMDcyT2syUUFFDQowMXQwWTAwMDAwNzJPazNRQUUNCjAxdDBZMDAwMDA3Mk9rNlFBRQ0KMDF0MFkwMDAwMDcyT2s3UUFFDQowMXQwWTAwMDAwNzJPa0NRQVUNCjAxdDBZMDAwMDA3Mk9rR1FBVQ0KMDF0MFkwMDAwMDcyT2tOUUFVDQowMXQwWTAwMDAwNzJPa09RQVUNCjAxdDBZMDAwMDA3Mk9rVlFBVQ0KMDF0MFkwMDAwMDcyT2tjUUFFDQowMXQwWTAwMDAwNzJPa2hRQUUNCjAxdDBZMDAwMDA3Mk9rbFFBRQ0KMDF0MFkwMDAwMDcyT2tuUUFFDQowMXQwWTAwMDAwNzJPa3JRQUUNCjAxdDBZMDAwMDA3Mk9rc1FBRQ0KMDF0MFkwMDAwMDcyT2t0UUFFDQowMXQwWTAwMDAwNzJPbDBRQUUNCjAxdDBZMDAwMDA3Mk9sMVFBRQ0KMDF0MFkwMDAwMDcyT2xEUUFVDQowMXQwWTAwMDAwNzJPbExRQVUNCjAxdDBZMDAwMDA3Mk9sU1FBVQ0KMDF0MFkwMDAwMDcyT2xrUUFFDQowMXQwWTAwMDAwNzJPbGxRQUUNCjAxdDBZMDAwMDA3Mk9sbVFBRQ0KMDF0MFkwMDAwMDcyT2xzUUFFDQowMXQwWTAwMDAwNzJPbTNRQUUNCjAxdDBZMDAwMDA3Mk9tOFFBRQ0KMDF0MFkwMDAwMDcyT21FUUFVDQowMXQwWTAwMDAwNzJPbUtRQVUNCjAxdDBZMDAwMDA3Mk9tTVFBVQ0KMDF0MFkwMDAwMDcyT21OUUFVDQowMXQwWTAwMDAwNzJPbVFRQVUNCjAxdDBZMDAwMDA3Mk9tVVFBVQ0KMDF0MFkwMDAwMDcyT21aUUFVDQowMXQwWTAwMDAwNzJPbWFRQUUNCjAxdDBZMDAwMDA3Mk9tZVFBRQ0KMDF0MFkwMDAwMDcyT243UUFFDQowMXQwWTAwMDAwNzJPbjlRQUUNCjAxdDBZMDAwMDA3Mk9uQVFBVQ0KMDF0MFkwMDAwMDcyT25CUUFVDQowMXQwWTAwMDAwNzJPbktRQVUNCjAxdDBZMDAwMDA3Mk9uWVFBVQ0KMDF0MFkwMDAwMDcyT25aUUFVDQowMXQwWTAwMDAwNzJPbmlRQUUNCjAxdDBZMDAwMDA3Mk9ualFBRQ0KMDF0MFkwMDAwMDcyT281UUFFDQowMXQwWTAwMDAwNzJPb0pRQVUNCjAxdDBZMDAwMDA3Mk9vY1FBRQ0KMDF0MFkwMDAwMDcyT295UUFFDQowMXQwWTAwMDAwNzJPb3pRQUUNCjAxdDBZMDAwMDA3Mk9wMlFBRQ0KMDF0MFkwMDAwMDcyT3A0UUFFDQowMXQwWTAwMDAwNzJPcEJRQVUNCjAxdDBZMDAwMDA3Mk9wRFFBVQ0KMDF0MFkwMDAwMDcyT3BFUUFVDQowMXQwWTAwMDAwNzJPcFFRQVUNCjAxdDBZMDAwMDA3Mk9wUlFBVQ0KMDF0MFkwMDAwMDcyT3BaUUFVDQowMXQwWTAwMDAwNzJPcHBRQUUNCjAxdDBZMDAwMDA3Mk9wc1FBRQ0KMDF0MFkwMDAwMDcyT3B0UUFFDQowMXQwWTAwMDAwNzJPcHdRQUUNCjAxdDBZMDAwMDA3Mk9weFFBRQ0KMDF0MFkwMDAwMDcyT3B6UUFFDQowMXQwWTAwMDAwNzJPcTZRQUUNCjAxdDBZMDAwMDA3Mk9xTVFBVQ0KMDF0MFkwMDAwMDcyT3FOUUFVDQowMXQwWTAwMDAwNzJPcU9RQVUNCjAxdDBZMDAwMDA3Mk9xUlFBVQ0KMDF0MFkwMDAwMDcyT3FhUUFFDQowMXQwWTAwMDAwNzJPcWJRQUUNCjAxdDBZMDAwMDA3Mk9xbFFBRQ0KMDF0MFkwMDAwMDcyT3FtUUFFDQowMXQwWTAwMDAwNzJPcW5RQUUNCjAxdDBZMDAwMDA3Mk9xc1FBRQ0KMDF0MFkwMDAwMDcyT3F4UUFFDQowMXQwWTAwMDAwNzJPcjBRQUUNCjAxdDBZMDAwMDA3Mk9yM1FBRQ0KMDF0MFkwMDAwMDcyT3JVUUFVDQowMXQwWTAwMDAwNzJPcldRQVUNCjAxdDBZMDAwMDA3Mk9yWVFBVQ0KMDF0MFkwMDAwMDcyT3JhUUFFDQowMXQwWTAwMDAwNzJPcmVRQUUNCjAxdDBZMDAwMDA3Mk9yc1FBRQ0KMDF0MFkwMDAwMDcyT3J4UUFFDQowMXQwWTAwMDAwNzJPczNRQUUNCjAxdDBZMDAwMDA3Mk9zNFFBRQ0KMDF0MFkwMDAwMDcyT3M1UUFFDQowMXQwWTAwMDAwNzJPczZRQUUNCjAxdDBZMDAwMDA3Mk9zN1FBRQ0KMDF0MFkwMDAwMDcyT3M5UUFFDQowMXQwWTAwMDAwNzJPc0FRQVUNCjAxdDBZMDAwMDA3Mk9zRlFBVQ0KMDF0MFkwMDAwMDcyT3NMUUFVDQowMXQwWTAwMDAwNzJPc09RQVUNCjAxdDBZMDAwMDA3Mk9zUlFBVQ0KMDF0MFkwMDAwMDcyT3NUUUFVDQowMXQwWTAwMDAwNzJPc1dRQVUNCjAxdDBZMDAwMDA3Mk9zWFFBVQ0KMDF0MFkwMDAwMDcyT3NZUUFVDQowMXQwWTAwMDAwNzJPc2dRQUUNCjAxdDBZMDAwMDA3Mk9zb1FBRQ0KMDF0MFkwMDAwMDcyT3NwUUFFDQowMXQwWTAwMDAwNzJPc3JRQUUNCjAxdDBZMDAwMDA3Mk9zdFFBRQ0KMDF0MFkwMDAwMDcyT3QzUUFFDQowMXQwWTAwMDAwNzJPdDRRQUUNCjAxdDBZMDAwMDA3Mk90YVFBRQ0KMDF0MFkwMDAwMDcyT3RlUUFFDQowMXQwWTAwMDAwNzJPdGhRQUUNCjAxdDBZMDAwMDA3Mk90alFBRQ0KMDF0MFkwMDAwMDcyT3RuUUFFDQowMXQwWTAwMDAwNzJPdG9RQUUNCjAxdDBZMDAwMDA3Mk90eFFBRQ0KMDF0MFkwMDAwMDcyT3R5UUFFDQowMXQwWTAwMDAwNzJPdTFRQUUNCjAxdDBZMDAwMDA3Mk91NFFBRQ0KMDF0MFkwMDAwMDcyT3VDUUFVDQowMXQwWTAwMDAwNzJPdUdRQVUNCjAxdDBZMDAwMDA3Mk91TFFBVQ0KMDF0MFkwMDAwMDcyT3VWUUFVDQowMXQwWTAwMDAwNzJPdVdRQVUNCjAxdDBZMDAwMDA3Mk91Y1FBRQ0KMDF0MFkwMDAwMDcyT3VkUUFFDQowMXQwWTAwMDAwNzJPdWpRQUUNCjAxdDBZMDAwMDA3Mk91b1FBRQ0KMDF0MFkwMDAwMDcyT3VwUUFFDQowMXQwWTAwMDAwNzJPdXhRQUUNCjAxdDBZMDAwMDA3Mk91elFBRQ0KMDF0MFkwMDAwMDcyT3YwUUFFDQowMXQwWTAwMDAwNzJPdlFRQVUNCjAxdDBZMDAwMDA3Mk92VlFBVQ0KMDF0MFkwMDAwMDcyT3ZZUUFVDQowMXQwWTAwMDAwNzJPdlpRQVUNCjAxdDBZMDAwMDA3Mk92Y1FBRQ0KMDF0MFkwMDAwMDcyT3ZrUUFFDQowMXQwWTAwMDAwNzJPdnFRQUUNCjAxdDBZMDAwMDA3Mk92d1FBRQ0KMDF0MFkwMDAwMDcyT3Z4UUFFDQowMXQwWTAwMDAwNzJPdnlRQUUNCjAxdDBZMDAwMDA3Mk93MlFBRQ0KMDF0MFkwMDAwMDcyT3czUUFFDQowMXQwWTAwMDAwNzJPdzRRQUUNCjAxdDBZMDAwMDA3Mk93NVFBRQ0KMDF0MFkwMDAwMDcyT3dCUUFVDQowMXQwWTAwMDAwNzJPd0ZRQVUNCjAxdDBZMDAwMDA3Mk93TFFBVQ0KMDF0MFkwMDAwMDcyT3dUUUFVDQowMXQwWTAwMDAwNzJPd1dRQVUNCjAxdDBZMDAwMDA3Mk93eVFBRQ0KMDF0MFkwMDAwMDcyT3gwUUFFDQowMXQwWTAwMDAwNzJPeDdRQUUNCjAxdDBZMDAwMDA3Mk94QVFBVQ0KMDF0MFkwMDAwMDcyT3hXUUFVDQowMXQwWTAwMDAwNzJPeHVRQUUNCjAxdDBZMDAwMDA3Mk94d1FBRQ0KMDF0MFkwMDAwMDcyT3h5UUFFDQowMXQwWTAwMDAwNzJPeHpRQUUNCjAxdDBZMDAwMDA3Mk95NlFBRQ0KMDF0MFkwMDAwMDcyT3k3UUFFDQowMXQwWTAwMDAwNzJPeTlRQUUNCjAxdDBZMDAwMDA3Mk95SFFBVQ0KMDF0MFkwMDAwMDcyT3lJUUFVDQowMXQwWTAwMDAwNzJPeVFRQVUNCjAxdDBZMDAwMDA3Mk95V1FBVQ0KMDF0MFkwMDAwMDcyT3llUUFFDQowMXQwWTAwMDAwNzJPeWlRQUUNCjAxdDBZMDAwMDA3Mk95dlFBRQ0KMDF0MFkwMDAwMDcyT3l5UUFFDQowMXQwWTAwMDAwNzJPejBRQUUNCjAxdDBZMDAwMDA3Mk96NFFBRQ0KMDF0MFkwMDAwMDcyT3o3UUFFDQowMXQwWTAwMDAwNzJPekJRQVUNCjAxdDBZMDAwMDA3Mk96c1FBRQ0KMDF0MFkwMDAwMDcyUDAzUUFFDQowMXQwWTAwMDAwNzJQMDVRQUUNCjAxdDBZMDAwMDA3MlAwNlFBRQ0KMDF0MFkwMDAwMDcyUDA5UUFFDQowMXQwWTAwMDAwNzJQMEtRQVUNCjAxdDBZMDAwMDA3MlAwWFFBVQ0KMDF0MFkwMDAwMDcyUDBpUUFFDQowMXQwWTAwMDAwNzJQMGpRQUUNCjAxdDBZMDAwMDA3MlAwblFBRQ0KMDF0MFkwMDAwMDcyUDBvUUFFDQowMXQwWTAwMDAwNzJQMHJRQUUNCjAxdDBZMDAwMDA3MlAwdlFBRQ0KMDF0MFkwMDAwMDcyUDEyUUFFDQowMXQwWTAwMDAwNzJQMTRRQUUNCjAxdDBZMDAwMDA3MlAxNVFBRQ0KMDF0MFkwMDAwMDcyUDE3UUFFDQowMXQwWTAwMDAwNzJQMThRQUUNCjAxdDBZMDAwMDA3MlAxRFFBVQ0KMDF0MFkwMDAwMDcyUDFFUUFVDQowMXQwWTAwMDAwNzJQMUdRQVUNCjAxdDBZMDAwMDA3MlAxUFFBVQ0KMDF0MFkwMDAwMDcyUDFRUUFVDQowMXQwWTAwMDAwNzJQMVZRQVUNCjAxdDBZMDAwMDA3MlAxWlFBVQ0KMDF0MFkwMDAwMDcyUDFmUUFFDQowMXQwWTAwMDAwNzJQMWdRQUUNCjAxdDBZMDAwMDA3MlAxaVFBRQ0KMDF0MFkwMDAwMDcyUDFwUUFFDQowMXQwWTAwMDAwNzJQMXpRQUUNCjAxdDBZMDAwMDA3MlAyMFFBRQ0KMDF0MFkwMDAwMDcyUDIxUUFFDQowMXQwWTAwMDAwNzJQMkFRQVUNCjAxdDBZMDAwMDA3MlAyRlFBVQ0KMDF0MFkwMDAwMDcyUDJIUUFVDQowMXQwWTAwMDAwNzJQMlBRQVUNCjAxdDBZMDAwMDA3MlAyVlFBVQ0KMDF0MFkwMDAwMDcyUDJhUUFFDQowMXQwWTAwMDAwNzJQMmNRQUUNCjAxdDBZMDAwMDA3MlAyalFBRQ0KMDF0MFkwMDAwMDcyUDJrUUFFDQowMXQwWTAwMDAwNzJQMm9RQUUNCjAxdDBZMDAwMDA3MlAycFFBRQ0KMDF0MFkwMDAwMDcyUDJxUUFFDQowMXQwWTAwMDAwNzJQMnZRQUUNCjAxdDBZMDAwMDA3MlAzM1FBRQ0KMDF0MFkwMDAwMDcyUDM3UUFFDQowMXQwWTAwMDAwNzJQM0FRQVUNCjAxdDBZMDAwMDA3MlAzQlFBVQ0KMDF0MFkwMDAwMDcyUDNFUUFVDQowMXQwWTAwMDAwNzJQM0pRQVUNCjAxdDBZMDAwMDA3MlAzUVFBVQ0KMDF0MFkwMDAwMDcyUDNVUUFVDQowMXQwWTAwMDAwNzJQM1ZRQVUNCjAxdDBZMDAwMDA3MlAzbVFBRQ0KMDF0MFkwMDAwMDcyUDQ4UUFFDQowMXQwWTAwMDAwNzJQNDlRQUUNCjAxdDBZMDAwMDA3MlA0QVFBVQ0KMDF0MFkwMDAwMDcyUDRCUUFVDQowMXQwWTAwMDAwNzJQNERRQVUNCjAxdDBZMDAwMDA3MlA0SlFBVQ0KMDF0MFkwMDAwMDcyUDRMUUFVDQowMXQwWTAwMDAwNzJQNFNRQVUNCjAxdDBZMDAwMDA3MlA0WlFBVQ0KMDF0MFkwMDAwMDcyUDR4UUFFDQowMXQwWTAwMDAwNzJQNTBRQUUNCjAxdDBZMDAwMDA3MlA1M1FBRQ0KMDF0MFkwMDAwMDcyUDU2UUFFDQowMXQwWTAwMDAwNzJQNUVRQVUNCjAxdDBZMDAwMDA3MlA1R1FBVQ0KMDF0MFkwMDAwMDcyUDVIUUFVDQowMXQwWTAwMDAwNzJQNUxRQVUNCjAxdDBZMDAwMDA3MlA1TVFBVQ0KMDF0MFkwMDAwMDcyUDVOUUFVDQowMXQwWTAwMDAwNzJQNU9RQVUNCjAxdDBZMDAwMDA3MlA1UFFBVQ0KMDF0MFkwMDAwMDcyUDVRUUFVDQowMXQwWTAwMDAwNzJQNVVRQVUNCjAxdDBZMDAwMDA3MlA1VlFBVQ0KMDF0MFkwMDAwMDcyUDVXUUFVDQowMXQwWTAwMDAwNzJQNVhRQVUNCjAxdDBZMDAwMDA3MlA1YVFBRQ0KMDF0MFkwMDAwMDcyUDVjUUFFDQowMXQwWTAwMDAwNzJQNWdRQUUNCjAxdDBZMDAwMDA3MlA1aVFBRQ0KMDF0MFkwMDAwMDcyUDVqUUFFDQowMXQwWTAwMDAwNzJQNW9RQUUNCjAxdDBZMDAwMDA3MlA1c1FBRQ0KMDF0MFkwMDAwMDcyUDV2UUFFDQowMXQwWTAwMDAwNzJQNXdRQUUNCjAxdDBZMDAwMDA3MlA2OFFBRQ0KMDF0MFkwMDAwMDcyUDY5UUFFDQowMXQwWTAwMDAwNzJQNlNRQVUNCjAxdDBZMDAwMDA3MlA2VFFBVQ0KMDF0MFkwMDAwMDcyUDZVUUFVDQowMXQwWTAwMDAwNzJQNlZRQVUNCjAxdDBZMDAwMDA3MlA2WlFBVQ0KMDF0MFkwMDAwMDcyUDZjUUFFDQowMXQwWTAwMDAwNzJQNmdRQUUNCjAxdDBZMDAwMDA3MlA2a1FBRQ0KMDF0MFkwMDAwMDcyUDZsUUFFDQowMXQwWTAwMDAwNzJQNm1RQUUNCjAxdDBZMDAwMDA3MlA2blFBRQ0KMDF0MFkwMDAwMDcyUDZ1UUFFDQowMXQwWTAwMDAwNzJQNzFRQUUNCjAxdDBZMDAwMDA3MlA3OVFBRQ0KMDF0MFkwMDAwMDcyUDdHUUFVDQowMXQwWTAwMDAwNzJQN0tRQVUNCjAxdDBZMDAwMDA3MlA3UVFBVQ0KMDF0MFkwMDAwMDcyUDdWUUFVDQowMXQwWTAwMDAwNzJQN1dRQVUNCjAxdDBZMDAwMDA3MlA3WVFBVQ0KMDF0MFkwMDAwMDcyUDdqUUFFDQowMXQwWTAwMDAwNzJQN3VRQUUNCjAxdDBZMDAwMDA3MlA4NlFBRQ0KMDF0MFkwMDAwMDcyUDhOUUFVDQowMXQwWTAwMDAwNzJQOFBRQVUNCjAxdDBZMDAwMDA3MlA4VVFBVQ0KMDF0MFkwMDAwMDcyUDhZUUFVDQowMXQwWTAwMDAwNzJQOGhRQUUNCjAxdDBZMDAwMDA3MlA4alFBRQ0KMDF0MFkwMDAwMDcyUDhvUUFFDQowMXQwWTAwMDAwNzJQOHVRQUUNCjAxdDBZMDAwMDA3MlA5MFFBRQ0KMDF0MFkwMDAwMDcyUDlEUUFVDQowMXQwWTAwMDAwNzJQOUhRQVUNCjAxdDBZMDAwMDA3MlA5TFFBVQ0KMDF0MFkwMDAwMDcyUDlPUUFVDQowMXQwWTAwMDAwNzJQOWlRQUUNCjAxdDBZMDAwMDA3MlA5bVFBRQ0KMDF0MFkwMDAwMDcyUDlxUUFFDQowMXQwWTAwMDAwNzJQQTZRQU0NCjAxdDBZMDAwMDA3MlBBOVFBTQ0KMDF0MFkwMDAwMDcyUEFLUUEyDQowMXQwWTAwMDAwNzJQQUxRQTINCjAxdDBZMDAwMDA3MlBBTVFBMg0KMDF0MFkwMDAwMDcyUEFOUUEyDQowMXQwWTAwMDAwNzJQQVBRQTINCjAxdDBZMDAwMDA3MlBBVFFBMg0KMDF0MFkwMDAwMDcyUEFVUUEyDQowMXQwWTAwMDAwNzJQQVZRQTINCjAxdDBZMDAwMDA3MlBBYVFBTQ0KMDF0MFkwMDAwMDcyUEFiUUFNDQowMXQwWTAwMDAwNzJQQWRRQU0NCjAxdDBZMDAwMDA3MlBBZVFBTQ0KMDF0MFkwMDAwMDcyUEFoUUFNDQowMXQwWTAwMDAwNzJQQXFRQU0NCjAxdDBZMDAwMDA3MlBCMVFBTQ0KMDF0MFkwMDAwMDcyUEJUUUEyDQowMXQwWTAwMDAwNzJQQlZRQTINCjAxdDBZMDAwMDA3MlBCWVFBMg0KMDF0MFkwMDAwMDcyUEJjUUFNDQowMXQwWTAwMDAwNzJQQmZRQU0NCjAxdDBZMDAwMDA3MlBCeFFBTQ0KMDF0MFkwMDAwMDcyUENCUUEyDQowMXQwWTAwMDAwNzJQQ1pRQTINCjAxdDBZMDAwMDA3MlBDZVFBTQ0KMDF0MFkwMDAwMDcyUENoUUFNDQowMXQwWTAwMDAwNzJQQ2lRQU0NCjAxdDBZMDAwMDA3MlBDbFFBTQ0KMDF0MFkwMDAwMDcyUENuUUFNDQowMXQwWTAwMDAwNzJQQ3NRQU0NCjAxdDBZMDAwMDA3MlBDelFBTQ0KMDF0MFkwMDAwMDcyUEQwUUFNDQowMXQwWTAwMDAwNzJQREJRQTINCjAxdDBZMDAwMDA3MlBESVFBMg0KMDF0MFkwMDAwMDcyUERMUUEyDQowMXQwWTAwMDAwNzJQRFBRQTINCjAxdDBZMDAwMDA3MlBEVVFBMg0KMDF0MFkwMDAwMDcyUERiUUFNDQowMXQwWTAwMDAwNzJQRGZRQU0NCjAxdDBZMDAwMDA3MlBEc1FBTQ0KMDF0MFkwMDAwMDcyUER5UUFNDQowMXQwWTAwMDAwNzJQRTBRQU0NCjAxdDBZMDAwMDA3MlBFMVFBTQ0KMDF0MFkwMDAwMDcyUEU0UUFNDQowMXQwWTAwMDAwNzJQRUhRQTINCjAxdDBZMDAwMDA3MlBFSlFBMg0KMDF0MFkwMDAwMDcyUEVNUUEyDQowMXQwWTAwMDAwNzJQRU9RQTINCjAxdDBZMDAwMDA3MlBFWFFBMg0KMDF0MFkwMDAwMDcyUEVaUUEyDQowMXQwWTAwMDAwNzJQRWNRQU0NCjAxdDBZMDAwMDA3MlBFZFFBTQ0KMDF0MFkwMDAwMDcyUEVuUUFNDQowMXQwWTAwMDAwNzJQRW9RQU0NCjAxdDBZMDAwMDA3MlBFdFFBTQ0KMDF0MFkwMDAwMDcyUEY0UUFNDQowMXQwWTAwMDAwNzJQRjVRQU0NCjAxdDBZMDAwMDA3MlBGSVFBMg0KMDF0MFkwMDAwMDcyUEZNUUEyDQowMXQwWTAwMDAwNzJQRk9RQTINCjAxdDBZMDAwMDA3MlBGUlFBMg0KMDF0MFkwMDAwMDcyUEZTUUEyDQowMXQwWTAwMDAwNzJQRlpRQTINCjAxdDBZMDAwMDA3MlBGYlFBTQ0KMDF0MFkwMDAwMDcyUEZjUUFNDQowMXQwWTAwMDAwNzJQRmdRQU0NCjAxdDBZMDAwMDA3MlBGa1FBTQ0KMDF0MFkwMDAwMDcyUEZwUUFNDQowMXQwWTAwMDAwNzJQR09RQTINCjAxdDBZMDAwMDA3MlBHUFFBMg0KMDF0MFkwMDAwMDcyUEdWUUEyDQowMXQwWTAwMDAwNzJQR1lRQTINCjAxdDBZMDAwMDA3MlBHZ1FBTQ0KMDF0MFkwMDAwMDcyUEdpUUFNDQowMXQwWTAwMDAwNzJQR3hRQU0NCjAxdDBZMDAwMDA3MlBINlFBTQ0KMDF0MFkwMDAwMDcyUEg4UUFNDQowMXQwWTAwMDAwNzJQSEhRQTINCjAxdDBZMDAwMDA3MlBIVFFBMg0KMDF0MFkwMDAwMDcyUEhXUUEyDQowMXQwWTAwMDAwNzJQSGJRQU0NCjAxdDBZMDAwMDA3MlBIaVFBTQ0KMDF0MFkwMDAwMDcyUEhzUUFNDQowMXQwWTAwMDAwNzJQSUdRQTINCjAxdDBZMDAwMDA3MlBJSlFBMg0KMDF0MFkwMDAwMDcyUElSUUEyDQowMXQwWTAwMDAwNzJQSVRRQTINCjAxdDBZMDAwMDA3MlBJVlFBMg0KMDF0MFkwMDAwMDcyUElXUUEyDQowMXQwWTAwMDAwNzJQSWZRQU0NCjAxdDBZMDAwMDA3MlBJd1FBTQ0KMDF0MFkwMDAwMDcyUEoxUUFNDQowMXQwWTAwMDAwNzJQSjVRQU0NCjAxdDBZMDAwMDA3MlBKOFFBTQ0KMDF0MFkwMDAwMDcyUEpBUUEyDQowMXQwWTAwMDAwNzJQSkRRQTINCjAxdDBZMDAwMDA3MlBKVlFBMg0KMDF0MFkwMDAwMDcyUEplUUFNDQowMXQwWTAwMDAwNzJQSmtRQU0NCjAxdDBZMDAwMDA3MlBKc1FBTQ0KMDF0MFkwMDAwMDcyUEp3UUFNDQowMXQwWTAwMDAwNzJQS0FRQTINCjAxdDBZMDAwMDA3MlBLQ1FBMg0KMDF0MFkwMDAwMDcyUEtFUUEyDQowMXQwWTAwMDAwNzJQS0ZRQTINCjAxdDBZMDAwMDA3MlBLTVFBMg0KMDF0MFkwMDAwMDcyUEtOUUEyDQowMXQwWTAwMDAwNzJQS1lRQTINCjAxdDBZMDAwMDA3MlBLZ1FBTQ0KMDF0MFkwMDAwMDcyUEtoUUFNDQowMXQwWTAwMDAwNzJQS2lRQU0NCjAxdDBZMDAwMDA3MlBLalFBTQ0KMDF0MFkwMDAwMDcyUEtrUUFNDQowMXQwWTAwMDAwNzJQS25RQU0NCjAxdDBZMDAwMDA3MlBLcFFBTQ0KMDF0MFkwMDAwMDcyUExUUUEyDQowMXQwWTAwMDAwNzJQTFdRQTINCjAxdDBZMDAwMDA3MlBMWFFBMg0KMDF0MFkwMDAwMDcyUExaUUEyDQowMXQwWTAwMDAwNzJQTGRRQU0NCjAxdDBZMDAwMDA3MlBMZVFBTQ0KMDF0MFkwMDAwMDcyUEx0UUFNDQowMXQwWTAwMDAwNzJQTHdRQU0NCjAxdDBZMDAwMDA3MlBNMlFBTQ0KMDF0MFkwMDAwMDcyUE02UUFNDQowMXQwWTAwMDAwNzJQTTlRQU0NCjAxdDBZMDAwMDA3MlBNR1FBMg0KMDF0MFkwMDAwMDcyUE1JUUEyDQowMXQwWTAwMDAwNzJQTU9RQTINCjAxdDBZMDAwMDA3MlBNUlFBMg0KMDF0MFkwMDAwMDcyUE1YUUEyDQowMXQwWTAwMDAwNzJQTWJRQU0NCjAxdDBZMDAwMDA3MlBNdVFBTQ0KMDF0MFkwMDAwMDcyUE4wUUFNDQowMXQwWTAwMDAwNzJQTjNRQU0NCjAxdDBZMDAwMDA3MlBON1FBTQ0KMDF0MFkwMDAwMDcyUE45UUFNDQowMXQwWTAwMDAwNzJQTkFRQTINCjAxdDBZMDAwMDA3MlBOR1FBMg0KMDF0MFkwMDAwMDcyUE5NUUEyDQowMXQwWTAwMDAwNzJQTk9RQTINCjAxdDBZMDAwMDA3MlBOWlFBMg0KMDF0MFkwMDAwMDcyUE54UUFNDQowMXQwWTAwMDAwNzJQTzJRQU0NCjAxdDBZMDAwMDA3MlBPM1FBTQ0KMDF0MFkwMDAwMDcyUE84UUFNDQowMXQwWTAwMDAwNzJQTzlRQU0NCjAxdDBZMDAwMDA3MlBPR1FBMg0KMDF0MFkwMDAwMDcyUE9KUUEyDQowMXQwWTAwMDAwNzJQT0xRQTINCjAxdDBZMDAwMDA3MlBPa1FBTQ0KMDF0MFkwMDAwMDcyUE9sUUFNDQowMXQwWTAwMDAwNzJQT21RQU0NCjAxdDBZMDAwMDA3MlBPcFFBTQ0KMDF0MFkwMDAwMDcyUE9xUUFNDQowMXQwWTAwMDAwNzJQT3RRQU0NCjAxdDBZMDAwMDA3MlBPdVFBTQ0KMDF0MFkwMDAwMDcyUE94UUFNDQowMXQwWTAwMDAwNzJQUEJRQTINCjAxdDBZMDAwMDA3MlBQRFFBMg0KMDF0MFkwMDAwMDcyUFBOUUEyDQowMXQwWTAwMDAwNzJQUE9RQTINCjAxdDBZMDAwMDA3MlBQVlFBMg0KMDF0MFkwMDAwMDcyUFBhUUFNDQowMXQwWTAwMDAwNzJQUGVRQU0NCjAxdDBZMDAwMDA3MlBQaVFBTQ0KMDF0MFkwMDAwMDcyUFBwUUFNDQowMXQwWTAwMDAwNzJQUHNRQU0NCjAxdDBZMDAwMDA3MlBQdFFBTQ0KMDF0MFkwMDAwMDcyUFB5UUFNDQowMXQwWTAwMDAwNzJQUTFRQU0NCjAxdDBZMDAwMDA3MlBRM1FBTQ0KMDF0MFkwMDAwMDcyUFE0UUFNDQowMXQwWTAwMDAwNzJQUURRQTINCjAxdDBZMDAwMDA3MlBRR1FBMg0KMDF0MFkwMDAwMDcyUFFRUUEyDQowMXQwWTAwMDAwNzJQUVVRQTINCjAxdDBZMDAwMDA3MlBRWVFBMg0KMDF0MFkwMDAwMDcyUFFaUUEyDQowMXQwWTAwMDAwNzJQUWFRQU0NCjAxdDBZMDAwMDA3MlBRYlFBTQ0KMDF0MFkwMDAwMDcyUFFmUUFNDQowMXQwWTAwMDAwNzJQUW5RQU0NCjAxdDBZMDAwMDA3MlBRcVFBTQ0KMDF0MFkwMDAwMDcyUFFyUUFNDQowMXQwWTAwMDAwNzJQUXRRQU0NCjAxdDBZMDAwMDA3MlBSbVFBTQ0KMDF0MFkwMDAwMDcyUFJwUUFNDQowMXQwWTAwMDAwNzJQUnRRQU0NCjAxdDBZMDAwMDA3MlBSeVFBTQ0KMDF0MFkwMDAwMDcyUFMwUUFNDQowMXQwWTAwMDAwNzJQUzhRQU0NCjAxdDBZMDAwMDA3MlBTQlFBMg0KMDF0MFkwMDAwMDcyUFNGUUEyDQowMXQwWTAwMDAwNzJQU0dRQTINCjAxdDBZMDAwMDA3MlBTSlFBMg0KMDF0MFkwMDAwMDcyUFNNUUEyDQowMXQwWTAwMDAwNzJQU1JRQTINCjAxdDBZMDAwMDA3MlBTU1FBMg0KMDF0MFkwMDAwMDcyUFNUUUEyDQowMXQwWTAwMDAwNzJQU1dRQTINCjAxdDBZMDAwMDA3MlBTY1FBTQ0KMDF0MFkwMDAwMDcyUFNuUUFNDQowMXQwWTAwMDAwNzJQU3FRQU0NCjAxdDBZMDAwMDA3MlBUNVFBTQ0KMDF0MFkwMDAwMDcyUFQ5UUFNDQowMXQwWTAwMDAwNzJQVEFRQTINCjAxdDBZMDAwMDA3MlBUQ1FBMg0KMDF0MFkwMDAwMDcyUFRHUUEyDQowMXQwWTAwMDAwNzJQVEpRQTINCjAxdDBZMDAwMDA3MlBUZFFBTQ0KMDF0MFkwMDAwMDcyUFRtUUFNDQowMXQwWTAwMDAwNzJQVHdRQU0NCjAxdDBZMDAwMDA3MlBVM1FBTQ0KMDF0MFkwMDAwMDcyUFVCUUEyDQowMXQwWTAwMDAwNzJQVUNRQTINCjAxdDBZMDAwMDA3MlBVRFFBMg0KMDF0MFkwMDAwMDcyUFVHUUEyDQowMXQwWTAwMDAwNzJQVUhRQTINCjAxdDBZMDAwMDA3MlBVUVFBMg0KMDF0MFkwMDAwMDcyUFVVUUEyDQowMXQwWTAwMDAwNzJQVW1RQU0NCjAxdDBZMDAwMDA3MlBVblFBTQ0KMDF0MFkwMDAwMDcyUFVzUUFNDQowMXQwWTAwMDAwNzJQVXVRQU0NCjAxdDBZMDAwMDA3MlBVdlFBTQ0KMDF0MFkwMDAwMDcyUFYzUUFNDQowMXQwWTAwMDAwNzJQVjRRQU0NCjAxdDBZMDAwMDA3MlBWR1FBMg0KMDF0MFkwMDAwMDcyUFZkUUFNDQowMXQwWTAwMDAwNzJQVnNRQU0NCjAxdDBZMDAwMDA3MlBWd1FBTQ0KMDF0MFkwMDAwMDcyUFZ4UUFNDQowMXQwWTAwMDAwNzJQVzBRQU0NCjAxdDBZMDAwMDA3MlBXMVFBTQ0KMDF0MFkwMDAwMDcyUFczUUFNDQowMXQwWTAwMDAwNzJQV0FRQTINCjAxdDBZMDAwMDA3MlBXSFFBMg0KMDF0MFkwMDAwMDcyUFdKUUEyDQowMXQwWTAwMDAwNzJQV01RQTINCjAxdDBZMDAwMDA3MlBXUFFBMg0KMDF0MFkwMDAwMDcyUFdaUUEyDQowMXQwWTAwMDAwNzJQV2FRQU0NCjAxdDBZMDAwMDA3MlBXalFBTQ0KMDF0MFkwMDAwMDcyUFd6UUFNDQowMXQwWTAwMDAwNzJQWDBRQU0NCjAxdDBZMDAwMDA3MlBYM1FBTQ0KMDF0MFkwMDAwMDcyUFhOUUEyDQowMXQwWTAwMDAwNzJQWFJRQTINCjAxdDBZMDAwMDA3MlBYVlFBMg0KMDF0MFkwMDAwMDcyUFhXUUEyDQowMXQwWTAwMDAwNzJQWFhRQTINCjAxdDBZMDAwMDA3MlBYZFFBTQ0KMDF0MFkwMDAwMDcyUFhmUUFNDQowMXQwWTAwMDAwNzJQWGxRQU0NCjAxdDBZMDAwMDA3MlBYc1FBTQ0KMDF0MFkwMDAwMDcyUFkwUUFNDQowMXQwWTAwMDAwNzJQWTNRQU0NCjAxdDBZMDAwMDA3MlBZNVFBTQ0KMDF0MFkwMDAwMDcyUFk2UUFNDQowMXQwWTAwMDAwNzJQWTdRQU0NCjAxdDBZMDAwMDA3MlBZOFFBTQ0KMDF0MFkwMDAwMDcyUFlCUUEyDQowMXQwWTAwMDAwNzJQWUZRQTINCjAxdDBZMDAwMDA3MlBZaVFBTQ0KMDF0MFkwMDAwMDcyUFlrUUFNDQowMXQwWTAwMDAwNzJQWWxRQU0NCjAxdDBZMDAwMDA3MlBZbVFBTQ0KMDF0MFkwMDAwMDcyUFl0UUFNDQowMXQwWTAwMDAwNzJQWXhRQU0NCjAxdDBZMDAwMDA3MlBaMVFBTQ0KMDF0MFkwMDAwMDcyUFo0UUFNDQowMXQwWTAwMDAwNzJQWjdRQU0NCjAxdDBZMDAwMDA3MlBaOVFBTQ0KMDF0MFkwMDAwMDcyUFpIUUEyDQowMXQwWTAwMDAwNzJQWkxRQTINCjAxdDBZMDAwMDA3MlBaTVFBMg0KMDF0MFkwMDAwMDcyUFpPUUEyDQowMXQwWTAwMDAwNzJQWlBRQTINCjAxdDBZMDAwMDA3MlBaUlFBMg0KMDF0MFkwMDAwMDcyUFpTUUEyDQowMXQwWTAwMDAwNzJQWlRRQTINCjAxdDBZMDAwMDA3MlBaVVFBMg0KMDF0MFkwMDAwMDcyUFp3UUFNDQowMXQwWTAwMDAwNzJQYWNRQUUNCjAxdDBZMDAwMDA3MlBhcFFBRQ0KMDF0MFkwMDAwMDcyUGFxUUFFDQowMXQwWTAwMDAwNzJQYXNRQUUNCjAxdDBZMDAwMDA3MlBhd1FBRQ0KMDF0MFkwMDAwMDcyUGIxUUFFDQowMXQwWTAwMDAwNzJQYkFRQVUNCjAxdDBZMDAwMDA3MlBiQlFBVQ0KMDF0MFkwMDAwMDcyUGJEUUFVDQowMXQwWTAwMDAwNzJQYk1RQVUNCjAxdDBZMDAwMDA3MlBiT1FBVQ0KMDF0MFkwMDAwMDcyUGJRUUFVDQowMXQwWTAwMDAwNzJQYlJRQVUNCjAxdDBZMDAwMDA3MlBiVFFBVQ0KMDF0MFkwMDAwMDcyUGJYUUFVDQowMXQwWTAwMDAwNzJQYmZRQUUNCjAxdDBZMDAwMDA3MlBiZ1FBRQ0KMDF0MFkwMDAwMDcyUGJqUUFFDQowMXQwWTAwMDAwNzJQY0tRQVUNCjAxdDBZMDAwMDA3MlBjTVFBVQ0KMDF0MFkwMDAwMDcyUGNOUUFVDQowMXQwWTAwMDAwNzJQY1BRQVUNCjAxdDBZMDAwMDA3MlBjVFFBVQ0KMDF0MFkwMDAwMDcyUGNpUUFFDQowMXQwWTAwMDAwNzJQY2pRQUUNCjAxdDBZMDAwMDA3MlBjbFFBRQ0KMDF0MFkwMDAwMDcyUGNvUUFFDQowMXQwWTAwMDAwNzJQY3BRQUUNCjAxdDBZMDAwMDA3MlBjclFBRQ0KMDF0MFkwMDAwMDcyUGNzUUFFDQowMXQwWTAwMDAwNzJQY3lRQUUNCjAxdDBZMDAwMDA3MlBjelFBRQ0KMDF0MFkwMDAwMDcyUGQyUUFFDQowMXQwWTAwMDAwNzJQZDRRQUUNCjAxdDBZMDAwMDA3MlBkNlFBRQ0KMDF0MFkwMDAwMDcyUGRCUUFVDQowMXQwWTAwMDAwNzJQZElRQVUNCjAxdDBZMDAwMDA3MlBkSlFBVQ0KMDF0MFkwMDAwMDcyUGRYUUFVDQowMXQwWTAwMDAwNzJQZFpRQVUNCjAxdDBZMDAwMDA3MlBlRFFBVQ0KMDF0MFkwMDAwMDcyUGVGUUFVDQowMXQwWTAwMDAwNzJQZUdRQVUNCjAxdDBZMDAwMDA3MlBlSVFBVQ0KMDF0MFkwMDAwMDcyUGVLUUFVDQowMXQwWTAwMDAwNzJQZVBRQVUNCjAxdDBZMDAwMDA3MlBlV1FBVQ0KMDF0MFkwMDAwMDcyUGVYUUFVDQowMXQwWTAwMDAwNzJQZVlRQVUNCjAxdDBZMDAwMDA3MlBlaVFBRQ0KMDF0MFkwMDAwMDcyUGVrUUFFDQowMXQwWTAwMDAwNzJQZXBRQUUNCjAxdDBZMDAwMDA3MlBlc1FBRQ0KMDF0MFkwMDAwMDcyUGV1UUFFDQowMXQwWTAwMDAwNzJQZXZRQUUNCjAxdDBZMDAwMDA3MlBleFFBRQ0KMDF0MFkwMDAwMDcyUGZMUUFVDQowMXQwWTAwMDAwNzJQZmZRQUUNCjAxdDBZMDAwMDA3MlBmaVFBRQ0KMDF0MFkwMDAwMDcyUGZsUUFFDQowMXQwWTAwMDAwNzJQZm1RQUUNCjAxdDBZMDAwMDA3MlBmcFFBRQ0KMDF0MFkwMDAwMDcyUGZxUUFFDQowMXQwWTAwMDAwNzJQZnpRQUUNCjAxdDBZMDAwMDA3MlBnMFFBRQ0KMDF0MFkwMDAwMDcyUGcxUUFFDQowMXQwWTAwMDAwNzJQZzJRQUUNCjAxdDBZMDAwMDA3MlBnNFFBRQ0KMDF0MFkwMDAwMDcyUGc1UUFFDQowMXQwWTAwMDAwNzJQZzdRQUUNCjAxdDBZMDAwMDA3MlBnRFFBVQ0KMDF0MFkwMDAwMDcyUGdMUUFVDQowMXQwWTAwMDAwNzJQZ1lRQVUNCjAxdDBZMDAwMDA3MlBnZFFBRQ0KMDF0MFkwMDAwMDcyUGdoUUFFDQowMXQwWTAwMDAwNzJQZ3VRQUUNCjAxdDBZMDAwMDA3MlBndlFBRQ0KMDF0MFkwMDAwMDcyUGd3UUFFDQowMXQwWTAwMDAwNzJQaDJRQUUNCjAxdDBZMDAwMDA3MlBoS1FBVQ0KMDF0MFkwMDAwMDcyUGhVUUFVDQowMXQwWTAwMDAwNzJQaGNRQUUNCjAxdDBZMDAwMDA3MlBoZFFBRQ0KMDF0MFkwMDAwMDcyUGhlUUFFDQowMXQwWTAwMDAwNzJQaGdRQUUNCjAxdDBZMDAwMDA3MlBoaFFBRQ0KMDF0MFkwMDAwMDcyUGhpUUFFDQowMXQwWTAwMDAwNzJQaGpRQUUNCjAxdDBZMDAwMDA3MlBobVFBRQ0KMDF0MFkwMDAwMDcyUGhuUUFFDQowMXQwWTAwMDAwNzJQaHBRQUUNCjAxdDBZMDAwMDA3MlBoc1FBRQ0KMDF0MFkwMDAwMDcyUGh1UUFFDQowMXQwWTAwMDAwNzJQaHhRQUUNCjAxdDBZMDAwMDA3MlBoeVFBRQ0KMDF0MFkwMDAwMDcyUGkwUUFFDQowMXQwWTAwMDAwNzJQaTNRQUUNCjAxdDBZMDAwMDA3MlBpSVFBVQ0KMDF0MFkwMDAwMDcyUGlLUUFVDQowMXQwWTAwMDAwNzJQaVNRQVUNCjAxdDBZMDAwMDA3MlBpYlFBRQ0KMDF0MFkwMDAwMDcyUGlvUUFFDQowMXQwWTAwMDAwNzJQaXJRQUUNCjAxdDBZMDAwMDA3MlBpelFBRQ0KMDF0MFkwMDAwMDcyUGoyUUFFDQowMXQwWTAwMDAwNzJQajVRQUUNCjAxdDBZMDAwMDA3MlBqN1FBRQ0KMDF0MFkwMDAwMDcyUGpBUUFVDQowMXQwWTAwMDAwNzJQandRQUUNCjAxdDBZMDAwMDA3MlBqeFFBRQ0KMDF0MFkwMDAwMDcyUGswUUFFDQowMXQwWTAwMDAwNzJQazJRQUUNCjAxdDBZMDAwMDA3MlBrQVFBVQ0KMDF0MFkwMDAwMDcyUGtDUUFVDQowMXQwWTAwMDAwNzJQa0VRQVUNCjAxdDBZMDAwMDA3MlBrSFFBVQ0KMDF0MFkwMDAwMDcyUGtSUUFVDQowMXQwWTAwMDAwNzJQa2hRQUUNCjAxdDBZMDAwMDA3MlBrc1FBRQ0KMDF0MFkwMDAwMDcyUGt0UUFFDQowMXQwWTAwMDAwNzJQbDlRQUUNCjAxdDBZMDAwMDA3MlBsSlFBVQ0KMDF0MFkwMDAwMDcyUGxOUUFVDQowMXQwWTAwMDAwNzJQbFBRQVUNCjAxdDBZMDAwMDA3MlBsUVFBVQ0KMDF0MFkwMDAwMDcyUGxTUUFVDQowMXQwWTAwMDAwNzJQbFRRQVUNCjAxdDBZMDAwMDA3MlBsVVFBVQ0KMDF0MFkwMDAwMDcyUGxjUUFFDQowMXQwWTAwMDAwNzJQbGRRQUUNCjAxdDBZMDAwMDA3MlBsaFFBRQ0KMDF0MFkwMDAwMDcyUGxpUUFFDQowMXQwWTAwMDAwNzJQbGpRQUUNCjAxdDBZMDAwMDA3MlBscFFBRQ0KMDF0MFkwMDAwMDcyUGxyUUFFDQowMXQwWTAwMDAwNzJQbWFRQUUNCjAxdDBZMDAwMDA3MlBtYlFBRQ0KMDF0MFkwMDAwMDcyUG1nUUFFDQowMXQwWTAwMDAwNzJQbWlRQUUNCjAxdDBZMDAwMDA3MlBtalFBRQ0KMDF0MFkwMDAwMDcyUG1sUUFFDQowMXQwWTAwMDAwNzJQbW5RQUUNCjAxdDBZMDAwMDA3MlBtcFFBRQ0KMDF0MFkwMDAwMDcyUG1zUUFFDQowMXQwWTAwMDAwNzJQbXZRQUUNCjAxdDBZMDAwMDA3MlBuMFFBRQ0KMDF0MFkwMDAwMDcyUG4xUUFFDQowMXQwWTAwMDAwNzJQbjJRQUUNCjAxdDBZMDAwMDA3MlBuNFFBRQ0KMDF0MFkwMDAwMDcyUG5BUUFVDQowMXQwWTAwMDAwNzJQblBRQVUNCjAxdDBZMDAwMDA3MlBuUlFBVQ0KMDF0MFkwMDAwMDcyUG5UUUFVDQowMXQwWTAwMDAwNzJQblVRQVUNCjAxdDBZMDAwMDA3MlBuWFFBVQ0KMDF0MFkwMDAwMDcyUG5mUUFFDQowMXQwWTAwMDAwNzJQbmlRQUUNCjAxdDBZMDAwMDA3MlBvNVFBRQ0KMDF0MFkwMDAwMDcyUG9BUUFVDQowMXQwWTAwMDAwNzJQb0lRQVUNCjAxdDBZMDAwMDA3MlBvT1FBVQ0KMDF0MFkwMDAwMDcyUG9hUUFFDQowMXQwWTAwMDAwNzJQb2NRQUUNCjAxdDBZMDAwMDA3MlBvZFFBRQ0KMDF0MFkwMDAwMDcyUG9yUUFFDQowMXQwWTAwMDAwNzJQb3NRQUUNCjAxdDBZMDAwMDA3MlBvdFFBRQ0KMDF0MFkwMDAwMDcyUHA0UUFFDQowMXQwWTAwMDAwNzJQcEFRQVUNCjAxdDBZMDAwMDA3MlBwTVFBVQ0KMDF0MFkwMDAwMDcyUHBvUUFFDQowMXQwWTAwMDAwNzJQcHBRQUUNCjAxdDBZMDAwMDA3MlBwdVFBRQ0KMDF0MFkwMDAwMDcyUHB4UUFFDQowMXQwWTAwMDAwNzJQcHpRQUUNCjAxdDBZMDAwMDA3MlBxMFFBRQ0KMDF0MFkwMDAwMDcyUHExUUFFDQowMXQwWTAwMDAwNzJQcVRRQVUNCjAxdDBZMDAwMDA3MlBxVlFBVQ0KMDF0MFkwMDAwMDcyUHFhUUFFDQowMXQwWTAwMDAwNzJQcWJRQUUNCjAxdDBZMDAwMDA3MlBxZ1FBRQ0KMDF0MFkwMDAwMDcyUHFrUUFFDQowMXQwWTAwMDAwNzJQcXZRQUUNCjAxdDBZMDAwMDA3MlBxeVFBRQ0KMDF0MFkwMDAwMDcyUHI2UUFFDQowMXQwWTAwMDAwNzJQcjlRQUUNCjAxdDBZMDAwMDA3MlByQVFBVQ0KMDF0MFkwMDAwMDcyUHJCUUFVDQowMXQwWTAwMDAwNzJQckhRQVUNCjAxdDBZMDAwMDA3MlByTFFBVQ0KMDF0MFkwMDAwMDcyUHJUUUFVDQowMXQwWTAwMDAwNzJQclVRQVUNCjAxdDBZMDAwMDA3MlByV1FBVQ0KMDF0MFkwMDAwMDcyUHJZUUFVDQowMXQwWTAwMDAwNzJQcmFRQUUNCjAxdDBZMDAwMDA3MlByZlFBRQ0KMDF0MFkwMDAwMDcyUHJpUUFFDQowMXQwWTAwMDAwNzJQcm1RQUUNCjAxdDBZMDAwMDA3MlByb1FBRQ0KMDF0MFkwMDAwMDcyUHJxUUFFDQowMXQwWTAwMDAwNzJQcnRRQUUNCjAxdDBZMDAwMDA3MlBzMlFBRQ0KMDF0MFkwMDAwMDcyUHM5UUFFDQowMXQwWTAwMDAwNzJQc0pRQVUNCjAxdDBZMDAwMDA3MlBzcFFBRQ0KMDF0MFkwMDAwMDcyUHNyUUFFDQowMXQwWTAwMDAwNzJQc3RRQUUNCjAxdDBZMDAwMDA3MlBzd1FBRQ0KMDF0MFkwMDAwMDcyUHN4UUFFDQowMXQwWTAwMDAwNzJQdDRRQUUNCjAxdDBZMDAwMDA3MlB0NVFBRQ0KMDF0MFkwMDAwMDcyUHQ2UUFFDQowMXQwWTAwMDAwNzJQdDdRQUUNCjAxdDBZMDAwMDA3MlB0Q1FBVQ0KMDF0MFkwMDAwMDcyUHREUUFVDQowMXQwWTAwMDAwNzJQdEdRQVUNCjAxdDBZMDAwMDA3MlB0TVFBVQ0KMDF0MFkwMDAwMDcyUHROUUFVDQowMXQwWTAwMDAwNzJQdGhRQUUNCjAxdDBZMDAwMDA3MlB1N1FBRQ0KMDF0MFkwMDAwMDcyUHVFUUFVDQowMXQwWTAwMDAwNzJQdUpRQVUNCjAxdDBZMDAwMDA3MlB1TFFBVQ0KMDF0MFkwMDAwMDcyUHVPUUFVDQowMXQwWTAwMDAwNzJQdVBRQVUNCjAxdDBZMDAwMDA3MlB1UVFBVQ0KMDF0MFkwMDAwMDcyUHVSUUFVDQowMXQwWTAwMDAwNzJQdVNRQVUNCjAxdDBZMDAwMDA3MlB1WFFBVQ0KMDF0MFkwMDAwMDcyUHVoUUFFDQowMXQwWTAwMDAwNzJQdjdRQUUNCjAxdDBZMDAwMDA3MlB2SVFBVQ0KMDF0MFkwMDAwMDcyUHZKUUFVDQowMXQwWTAwMDAwNzJQdlBRQVUNCjAxdDBZMDAwMDA3MlB2VVFBVQ0KMDF0MFkwMDAwMDcyUHZYUUFVDQowMXQwWTAwMDAwNzJQdlpRQVUNCjAxdDBZMDAwMDA3MlB2cVFBRQ0KMDF0MFkwMDAwMDcyUHc4UUFFDQowMXQwWTAwMDAwNzJQd0JRQVUNCjAxdDBZMDAwMDA3MlB3Q1FBVQ0KMDF0MFkwMDAwMDcyUHdFUUFVDQowMXQwWTAwMDAwNzJQd0ZRQVUNCjAxdDBZMDAwMDA3MlB3SFFBVQ0KMDF0MFkwMDAwMDcyUHdQUUFVDQowMXQwWTAwMDAwNzJQd1lRQVUNCjAxdDBZMDAwMDA3MlB3YlFBRQ0KMDF0MFkwMDAwMDcyUHdnUUFFDQowMXQwWTAwMDAwNzJQd21RQUUNCjAxdDBZMDAwMDA3MlB3cFFBRQ0KMDF0MFkwMDAwMDcyUHd3UUFFDQowMXQwWTAwMDAwNzJQd3hRQUUNCjAxdDBZMDAwMDA3MlB3eVFBRQ0KMDF0MFkwMDAwMDcyUHgxUUFFDQowMXQwWTAwMDAwNzJQeDVRQUUNCjAxdDBZMDAwMDA3MlB4Q1FBVQ0KMDF0MFkwMDAwMDcyUHhFUUFVDQowMXQwWTAwMDAwNzJQeEdRQVUNCjAxdDBZMDAwMDA3MlB4UFFBVQ0KMDF0MFkwMDAwMDcyUHhRUUFVDQowMXQwWTAwMDAwNzJQeFRRQVUNCjAxdDBZMDAwMDA3MlB4VVFBVQ0KMDF0MFkwMDAwMDcyUHhXUUFVDQowMXQwWTAwMDAwNzJQeGJRQUUNCjAxdDBZMDAwMDA3MlB4ZlFBRQ0KMDF0MFkwMDAwMDcyUHhoUUFFDQowMXQwWTAwMDAwNzJQeHZRQUUNCjAxdDBZMDAwMDA3MlB4eFFBRQ0KMDF0MFkwMDAwMDcyUHh5UUFFDQowMXQwWTAwMDAwNzJQeHpRQUUNCjAxdDBZMDAwMDA3MlB5MFFBRQ0KMDF0MFkwMDAwMDcyUHkxUUFFDQowMXQwWTAwMDAwNzJQeTJRQUUNCjAxdDBZMDAwMDA3MlB5NFFBRQ0KMDF0MFkwMDAwMDcyUHk1UUFFDQowMXQwWTAwMDAwNzJQeThRQUUNCjAxdDBZMDAwMDA3MlB5OVFBRQ0KMDF0MFkwMDAwMDcyUHlDUUFVDQowMXQwWTAwMDAwNzJQeUdRQVUNCjAxdDBZMDAwMDA3MlB5SVFBVQ0KMDF0MFkwMDAwMDcyUHlKUUFVDQowMXQwWTAwMDAwNzJQeUtRQVUNCjAxdDBZMDAwMDA3MlB5TFFBVQ0KMDF0MFkwMDAwMDcyUHlSUUFVDQowMXQwWTAwMDAwNzJQeWhRQUUNCjAxdDBZMDAwMDA3MlB5aVFBRQ0KMDF0MFkwMDAwMDcyUHo5UUFFDQowMXQwWTAwMDAwNzJQekFRQVUNCjAxdDBZMDAwMDA3MlB6Q1FBVQ0KMDF0MFkwMDAwMDcyUHpGUUFVDQowMXQwWTAwMDAwNzJQeklRQVUNCjAxdDBZMDAwMDA3MlB6TVFBVQ0KMDF0MFkwMDAwMDcyUHpOUUFVDQowMXQwWTAwMDAwNzJQelFRQVUNCjAxdDBZMDAwMDA3MlB6VlFBVQ0KMDF0MFkwMDAwMDcyUHpXUUFVDQowMXQwWTAwMDAwNzJQelpRQVUNCjAxdDBZMDAwMDA3MlB6ZlFBRQ0KMDF0MFkwMDAwMDcyUHpoUUFFDQowMXQwWTAwMDAwNzJQemlRQUUNCjAxdDBZMDAwMDA3MlB6a1FBRQ0KMDF0MFkwMDAwMDcyUHptUUFFDQowMXQwWTAwMDAwNzJQem5RQUUNCjAxdDBZMDAwMDA3MlB6b1FBRQ0KMDF0MFkwMDAwMDcyUHpwUUFFDQowMXQwWTAwMDAwNzJQenNRQUUNCjAxdDBZMDAwMDA3MlB6eFFBRQ0KMDF0MFkwMDAwMDcyUTA5UUFFDQowMXQwWTAwMDAwNzJRMEJRQVUNCjAxdDBZMDAwMDA3MlEwRFFBVQ0KMDF0MFkwMDAwMDcyUTBRUUFVDQowMXQwWTAwMDAwNzJRMFJRQVUNCjAxdDBZMDAwMDA3MlEwVFFBVQ0KMDF0MFkwMDAwMDcyUTBXUUFVDQowMXQwWTAwMDAwNzJRMGZRQUUNCjAxdDBZMDAwMDA3MlEwaVFBRQ0KMDF0MFkwMDAwMDcyUTBqUUFFDQowMXQwWTAwMDAwNzJRMGxRQUUNCjAxdDBZMDAwMDA3MlEwclFBRQ0KMDF0MFkwMDAwMDcyUTE0UUFFDQowMXQwWTAwMDAwNzJRMUNRQVUNCjAxdDBZMDAwMDA3MlExRlFBVQ0KMDF0MFkwMDAwMDcyUTFSUUFVDQowMXQwWTAwMDAwNzJRMVhRQVUNCjAxdDBZMDAwMDA3MlExaFFBRQ0KMDF0MFkwMDAwMDcyUTF4UUFFDQowMXQwWTAwMDAwNzJRMjJRQUUNCjAxdDBZMDAwMDA3MlEySFFBVQ0KMDF0MFkwMDAwMDcyUTJJUUFVDQowMXQwWTAwMDAwNzJRMkpRQVUNCjAxdDBZMDAwMDA3MlEyTFFBVQ0KMDF0MFkwMDAwMDcyUTJVUUFVDQowMXQwWTAwMDAwNzJRMldRQVUNCjAxdDBZMDAwMDA3MlEyYlFBRQ0KMDF0MFkwMDAwMDcyUTJjUUFFDQowMXQwWTAwMDAwNzJRMmZRQUUNCjAxdDBZMDAwMDA3MlEyZ1FBRQ0KMDF0MFkwMDAwMDcyUTJqUUFFDQowMXQwWTAwMDAwNzJRMnZRQUUNCjAxdDBZMDAwMDA3MlEzQ1FBVQ0KMDF0MFkwMDAwMDcyUTNQUUFVDQowMXQwWTAwMDAwNzJRM1VRQVUNCjAxdDBZMDAwMDA3MlEzVlFBVQ0KMDF0MFkwMDAwMDcyUTNsUUFFDQowMXQwWTAwMDAwNzJRM25RQUUNCjAxdDBZMDAwMDA3MlEzcVFBRQ0KMDF0MFkwMDAwMDcyUTNzUUFFDQowMXQwWTAwMDAwNzJRNDJRQUUNCjAxdDBZMDAwMDA3MlE0NFFBRQ0KMDF0MFkwMDAwMDcyUTQ2UUFFDQowMXQwWTAwMDAwNzJRNDhRQUUNCjAxdDBZMDAwMDA3MlE0QVFBVQ0KMDF0MFkwMDAwMDcyUTRCUUFVDQowMXQwWTAwMDAwNzJRNENRQVUNCjAxdDBZMDAwMDA3MlE0RVFBVQ0KMDF0MFkwMDAwMDcyUTRGUUFVDQowMXQwWTAwMDAwNzJRNEdRQVUNCjAxdDBZMDAwMDA3MlE0SFFBVQ0KMDF0MFkwMDAwMDcyUTRJUUFVDQowMXQwWTAwMDAwNzJRNEtRQVUNCjAxdDBZMDAwMDA3MlE0TFFBVQ0KMDF0MFkwMDAwMDcyUTRNUUFVDQowMXQwWTAwMDAwNzJRNFBRQVUNCjAxdDBZMDAwMDA3MlE0UlFBVQ0KMDF0MFkwMDAwMDcyUTRUUUFVDQowMXQwWTAwMDAwNzJRNFZRQVUNCjAxdDBZMDAwMDA3MlE0alFBRQ0KMDF0MFkwMDAwMDcyUTR0UUFFDQowMXQwWTAwMDAwNzJRNWNRQUUNCjAxdDBZMDAwMDA3MlE1ZlFBRQ0KMDF0MFkwMDAwMDcyUTVrUUFFDQowMXQwWTAwMDAwNzJRNWxRQUUNCjAxdDBZMDAwMDA3MlE1bVFBRQ0KMDF0MFkwMDAwMDcyUTVzUUFFDQowMXQwWTAwMDAwNzJRNXRRQUUNCjAxdDBZMDAwMDA3MlE1eVFBRQ0KMDF0MFkwMDAwMDcyUTV6UUFFDQowMXQwWTAwMDAwNzJRNjBRQUUNCjAxdDBZMDAwMDA3MlE2N1FBRQ0KMDF0MFkwMDAwMDcyUTZEUUFVDQowMXQwWTAwMDAwNzJRNmhRQUUNCjAxdDBZMDAwMDA3MlE2bVFBRQ0KMDF0MFkwMDAwMDcyUTZ3UUFFDQowMXQwWTAwMDAwNzJRNnpRQUUNCjAxdDBZMDAwMDA3MlE3MFFBRQ0KMDF0MFkwMDAwMDcyUTcxUUFFDQowMXQwWTAwMDAwNzJRNzNRQUUNCjAxdDBZMDAwMDA3MlE3NlFBRQ0KMDF0MFkwMDAwMDcyUTdGUUFVDQowMXQwWTAwMDAwNzJRN1NRQVUNCjAxdDBZMDAwMDA3MlE3ZFFBRQ0KMDF0MFkwMDAwMDcyUTd5UUFFDQowMXQwWTAwMDAwNzJRODFRQUUNCjAxdDBZMDAwMDA3MlE4NlFBRQ0KMDF0MFkwMDAwMDcyUThPUUFVDQowMXQwWTAwMDAwNzJRODZRQUUNCjAxdDBZMDAwMDA3MlE4T1FBVQ==';
            fld=TF_PPDProcessController.addListOfPrductsViaFile(newParentProduct3.id,encodeLarge,'SFDCId','Manual Curation','Include');
        //System.assert(fld.totalRecs>0); 
        //Product2 newParentProduct4=zTEST_Shared.insertProduct2(productRecordtypeId); 
        //fld=TF_PPDProcessController.addListOfPrductsViaFile(newParentProduct4.id,'1979','ISBN');
        //System.assert(fld.totalRecs>0);
        test.stopTest();
    }
    
    //Positive test for getStaticBundleTitles
    private static testmethod void getStaticBundleTitles(){
        test.startTest();
        Boolean expectedExceptionThrown=false;
        Product2 newParentProduct=new Product2(); 
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        system.debug(productRecordtypeId);
        newParentProduct.RecordTypeId=productRecordtypeId;
        newParentProduct.Name='test';
        newParentProduct.Type_of_Bundle__c='Static';
        newParentProduct.businessId__c='THM-PRODATA';
        newParentProduct.Product_category__c='SDGO';
        newParentProduct.Sales_Channels__c='UBX_sales';
        insert newParentProduct;
        try
        {TF_PPDProcessController.getBundleTitles(newParentProduct.id);  
        }
        Catch(exception e)
        {System.Debug(e.getMessage());
         expectedExceptionThrown = true;
         System.AssertEquals(expectedExceptionThrown, true); 
        }
        test.stopTest();
    }
    
    private static testmethod void addPriceBookEntry_return(){
        test.startTest();
        String result='';
        Decimal unitpriceinGBP=33.00;
        Decimal unitpriceinUSD=44.00;        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        system.debug(productRecordtypeId);       
        
       // Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        result =TF_PPDProcessController.addPriceBookEntry(newParentProduct.id, unitpriceinGBP,unitpriceinUSD, 1.2, 1.1,true);
        System.assert(result!= null);
        test.stopTest();
    }
    
    private static testMethod void updatePricebookEntry_return()
    {
        test.startTest();
        String result='';     
        Decimal unitpriceinGBP=56.00;
        Decimal unitpriceinUSD=88.00;
        
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        system.debug(productRecordtypeId);     
       // Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        //Product2 newchildProduct1=zTEST_Shared.insertProduct2(); 
        Product2 newchildProduct1=insertProductforTesting(productRecordtypeId);
        
        //Product2 newchildProduct2=zTEST_Shared.insertProduct2(); 
        Product2 newchildProduct2=insertProductforTesting(productRecordtypeId);
        
        system.debug('Test class parent product id' + newParentProduct.id);
        
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Product_Bundle_Parent__c = newParentProduct.id;
        lineItem.Product__c = newchildProduct1.id;
        insert lineItem;
        
        Id standardPriceBookId=Test.getStandardPricebookId();
        system.debug('StdPriceBookIDInTestclass' + '' + standardPriceBookId);
        PriceBookEntry pbeGBP = new PricebookEntry(Pricebook2Id=standardPriceBookId,Product2Id=newParentProduct.id, UnitPrice=2.00, IsActive=true, UseStandardPrice=false,CurrencyIsoCode='GBP');
        insert pbeGBP;  
        
        PriceBookEntry pbeUSD = new PricebookEntry(Pricebook2Id=standardPriceBookId,Product2Id=newParentProduct.id, UnitPrice=4.00, IsActive=true, UseStandardPrice=false,CurrencyIsoCode='USD');
        insert pbeUSD; 
        
        Id tfPricebookId='01s0Y00000832dDQAQ';
        
        
        
        PriceBookEntry tnfpbeGBP = new PricebookEntry(Pricebook2Id=tfPricebookId,Product2Id=newParentProduct.id, UnitPrice=2.00, UseStandardPrice=false,CurrencyIsoCode='GBP');
        insert tnfpbeGBP;  
        
        PriceBookEntry tnfpbeUSD = new PricebookEntry(Pricebook2Id=tfPricebookId,Product2Id=newParentProduct.id, UnitPrice=4.00,  UseStandardPrice=false,CurrencyIsoCode='USD');
        insert tnfpbeUSD; 
        
        result =TF_PPDProcessController.updatePricebookEntry(newParentProduct.id, unitpriceinGBP,unitpriceinUSD,2.0,1.0);    
        System.assert(result!= null);    
        test.stopTest();
        
    }
    
    private static testMethod void updatePricebookEntryWithActiveFlag_return()
    {
        test.startTest();
        String result='';     
        Decimal unitpriceinGBP=56.00;
        Decimal unitpriceinUSD=88.00;
        
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        system.debug(productRecordtypeId);     
       // Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        //Product2 newchildProduct1=zTEST_Shared.insertProduct2(); 
        Product2 newchildProduct1=insertProductforTesting(productRecordtypeId);
        
        //Product2 newchildProduct2=zTEST_Shared.insertProduct2(); 
        Product2 newchildProduct2=insertProductforTesting(productRecordtypeId);
        
        system.debug('Test class parent product id' + newParentProduct.id);
        
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Product_Bundle_Parent__c = newParentProduct.id;
        lineItem.Product__c = newchildProduct1.id;
        insert lineItem;
        
        Id standardPriceBookId=Test.getStandardPricebookId();
        system.debug('StdPriceBookIDInTestclass' + '' + standardPriceBookId);
        PriceBookEntry pbeGBP = new PricebookEntry(Pricebook2Id=standardPriceBookId,Product2Id=newParentProduct.id, UnitPrice=2.00, IsActive=true, UseStandardPrice=false,CurrencyIsoCode='GBP');
        insert pbeGBP;  
        
        PriceBookEntry pbeUSD = new PricebookEntry(Pricebook2Id=standardPriceBookId,Product2Id=newParentProduct.id, UnitPrice=4.00, IsActive=true, UseStandardPrice=false,CurrencyIsoCode='USD');
        insert pbeUSD; 
        
        Id tfPricebookId='01s0Y00000832dDQAQ';
        
        
        
        PriceBookEntry tnfpbeGBP = new PricebookEntry(Pricebook2Id=tfPricebookId,Product2Id=newParentProduct.id, UnitPrice=2.00, IsActive=true, UseStandardPrice=false,CurrencyIsoCode='GBP');
        insert tnfpbeGBP;  
        
        PriceBookEntry tnfpbeUSD = new PricebookEntry(Pricebook2Id=tfPricebookId,Product2Id=newParentProduct.id, UnitPrice=4.00, IsActive=true, UseStandardPrice=false,CurrencyIsoCode='USD');
        insert tnfpbeUSD; 
        
        result =TF_PPDProcessController.updatePricebookEntryWithActiveFlag(newParentProduct.id, unitpriceinGBP,unitpriceinUSD,1.0,1.0);    
        System.assert(result!= null);    
        test.stopTest();
        
    }
    
    
    private static testMethod void updatePricebookEntry_returnNULL()
    {   test.startTest();
     String result='';
     Decimal unitpriceinGBP=56.00;
     Decimal unitpriceinUSD=88.00;
     String testParentProduct='01t1l0000001EYDAA2';  
     Boolean expectedExceptionThrown =false;
     
     Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
     system.debug('test class' + productRecordtypeId);         
     try
     {
         result =TF_PPDProcessController.updatePricebookEntry(testParentProduct, unitpriceinGBP,unitpriceinUSD,1.0,1.0);  
     }
     Catch(exception e)
     {System.Debug(e.getMessage());
      expectedExceptionThrown = true;
      System.AssertEquals(expectedExceptionThrown, true); 
     }
     
     test.stopTest();
     
    }
    
    private static testmethod void getPriceBookEntry_return()
    {
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
       // Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        
        
        
        List<Pricebookentry> result =TF_PPDProcessController.getPriceBookEntry(newParentProduct.id); 
        System.assert(result!= null);
        test.stopTest();
        
    }
    
    private static testmethod void getSumOfStaticBundleTitles_return()
    {test.startTest();
     String resultSum='';
     String result='';
     Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
     
     //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId); 
     Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

     //Product2 newChildProduct1=zTEST_Shared.insertProduct2(productRecordtypeId); 
     Product2 newChildProduct1=insertProductforTesting(productRecordtypeId);

    // Product2 newChildProduct2=zTEST_Shared.insertProduct2(productRecordtypeId);
     Product2 newChildProduct2=insertProductforTesting(productRecordtypeId);

     //Product2 newChildProduct3=zTEST_Shared.insertProduct2(productRecordtypeId); 
     Product2 newChildProduct3=insertProductforTesting(productRecordtypeId);

     
     Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
     lineItem.Product_Bundle_Parent__c = newParentProduct.id;
     lineItem.Product__c = newchildProduct1.id;
     lineItem.Content_Position__c=1;
     insert lineItem;
     
     Id standardPriceBookId=Test.getStandardPricebookId();
     system.debug('StdPriceBookIDInTestclass' + '' + standardPriceBookId);
     PriceBookEntry pbeGBP = new PricebookEntry(Pricebook2Id=standardPriceBookId,Product2Id=newParentProduct.id, UnitPrice=2.00, IsActive=true, UseStandardPrice=false,CurrencyIsoCode='GBP');
     insert pbeGBP;  
     
     PriceBookEntry pbeUSD = new PricebookEntry(Pricebook2Id=standardPriceBookId,Product2Id=newParentProduct.id, UnitPrice=4.00, IsActive=true, UseStandardPrice=false,CurrencyIsoCode='USD');
     insert pbeUSD; 
     
     List<String> listProdIds=new List<String>();
     listProdIds.add(newChildProduct1.id);
     listProdIds.add(newChildProduct2.id);
     listProdIds.add(newChildProduct3.id);
     
     
     result =TF_PPDProcessController.addMultipleProductsToCollection(newParentProduct.id,listProdIds); 
     Decimal unitpriceinGBP=33.00;
     Decimal unitpriceinUSD=44.00;        
     //TF_PPDProcessController.addPriceBookEntry(newParentProduct.id, unitpriceinGBP,unitpriceinUSD); 
     resultSum =TF_PPDProcessController.getSumOfStaticBundleTitles(newParentProduct.id); 
     System.assert(result!= null);
     test.stopTest();       
     
    }
    
    public static testmethod void PriceSummaryWrapper(){
        test.startTest();        
        TF_PPDProcessController.PriceSummaryWrapper priceSummary = new  TF_PPDProcessController.PriceSummaryWrapper();
        priceSummary.UnitPriceinGBP=5;
        priceSummary.UnitPriceinUSD=2;
        test.stopTest();
    }
    
    //Postive Test for deleteProducts
    private static testMethod void deleteAllProducts_ReturnTrue(){
        test.startTest();
        list< Bundle_Line_Item__c> listofLineItems=new List<Bundle_Line_Item__c>();
        String result='';
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        system.debug(productRecordtypeId);
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
       // Product2 newChildProduct1=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newChildProduct1=insertProductforTesting(productRecordtypeId);
        //Product2 newChildProduct2=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newChildProduct2=insertProductforTesting(productRecordtypeId);
       // Product2 newChildProduct3=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newChildProduct3=insertProductforTesting(productRecordtypeId);
        
        result=TF_PPDProcessController.deleteAllProducts(newParentProduct.id);
        System.assert(result!= '');       
        test.stopTest();
    }
    //Negative Test for deleteProducts
    private static testMethod void deleteAllProducts_ReturnFalse(){
        test.startTest();
        String result='';
        String testParent='01t1l0000001EYDAA2';
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        system.debug(productRecordtypeId);
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        //Product2 newChildProduct1=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newChildProduct1=insertProductforTesting(productRecordtypeId);

        //Product2 newChildProduct2=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newChildProduct2=insertProductforTesting(productRecordtypeId);

        //Product2 newChildProduct3=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newChildProduct3=insertProductforTesting(productRecordtypeId);

        
        try
        { result=TF_PPDProcessController.deleteAllProducts(testParent);}
        Catch(exception e)
        {
            System.Debug(e.getMessage());
        }       
        System.assert(result!= '');       
        test.stopTest();
    }
    
    private static testMethod void updateApprovalProcessStatus()
    {
        test.startTest();
        String resultSum='';
        String result='';
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        
       // Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        //newParentProduct.Approval_Status__c='Draft';
        //update newParentProduct;
        result=TF_PPDProcessController.updateApprovalProcessStatus(newParentProduct.id);
        System.assert(result!= '');
        test.stopTest();
        
    }
    private static testMethod void getSubmitForApprovalStatusValue() {
        test.startTest();
        String result='';
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');        
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        newParentProduct.Approval_Status__c='Draft';
        
        result=TF_PPDProcessController.getSubmitForApprovalStatusValue(newParentProduct.id);
        System.assert(result!= '');
        test.stopTest();
    }
    
    //Postive Test for deleteAllProductsAndContents
    private static testMethod void deleteAllProductsAndContents(){
        test.startTest();
        list< Bundle_Line_Item__c> listofLineItems=new List<Bundle_Line_Item__c>();
        String result='';
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        
       // Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

       // Product2 newChildProduct1=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newChildProduct1=insertProductforTesting(productRecordtypeId);

       // Product2 newChildProduct2=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newChildProduct2=insertProductforTesting(productRecordtypeId);

        
        
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Product_Bundle_Parent__c = newParentProduct.id;
        lineItem.Product__c = newchildProduct1.id;
        insert lineItem; 
        Bundle_Line_Item__c lineItems = new Bundle_Line_Item__c();
        lineItems.Product_Bundle_Parent__c = newParentProduct.id;
        lineItems.Product__c = newChildProduct2.id;
        insert lineItems; 
        
        result=TF_PPDProcessController.deleteAllProductsAndContents(newParentProduct.id);
        System.assert(result!= '');      
        
        test.stopTest();
    }
    
    //Negative Test for deleteAllProductsAndContents
    /* private static testMethod void deleteAllProductsAndContents_returnnull(){
test.startTest();
list< Bundle_Line_Item__c> listofLineItems=new List<Bundle_Line_Item__c>();
String result='';
String testParent='01t1l0000001EYDAA2';
Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');

Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
Product2 newChildProduct1=zTEST_Shared.insertProduct2(productRecordtypeId); 
Product2 newChildProduct2=zTEST_Shared.insertProduct2(productRecordtypeId); 


Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
lineItem.Product_Bundle_Parent__c = testParent;
lineItem.Product__c = newchildProduct1.id;
insert lineItem; 
Bundle_Line_Item__c lineItems = new Bundle_Line_Item__c();
lineItems.Product_Bundle_Parent__c = testParent;
lineItems.Product__c = newChildProduct2.id;
insert lineItems; 

result=TF_PPDProcessController.deleteAllProductsAndContents(testParent);
System.assert(result!= '');      

test.stopTest();
}*/
    
    private static testMethod void getuserDetails(){
        test.startTest();
        String result='';
        result=TF_PPDProcessController.getuserDetails();
        System.assert(result!= '');  
        test.stopTest();
        
    }
    
    private static testMethod void getApprovalProcessStatus(){
        test.startTest();
        
        string jsonStr = 'validate test';
        
        Test.setMock(HttpCalloutMock.class, new zTest_TF_PPDProcessController(200, jsonStr));
        
        TF_PPDProcessController.InitialFieldValues result ;
        TF_PPDProcessController.InitialFieldValues resultapp ;
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');        
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        newParentProduct.Approval_Status__c='Draft';
        update newParentProduct;
        result=TF_PPDProcessController.getApprovalProcessStatus(newParentProduct.id);
        System.assert(result!= null); 
        
        //Product2 newParentProductapp=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newParentProductapp=insertProductforTesting(productRecordtypeId);
        newParentProductapp.Approval_Status__c='Approved';
        newParentProductapp.Dynamic_Collection_Criteria__c='testrule';
        update newParentProductapp;
        resultapp=TF_PPDProcessController.getApprovalProcessStatus(newParentProductapp.id);
        System.assert(resultapp!= null); 
        
        //Product2 newParentProduct2=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct2=insertProductforTesting(productRecordtypeId);

        newParentProduct2.Approval_Status__c='Approved';
        newParentProduct2.APIStatus__c='GetUUID Incomplete';
        update newParentProduct2;
        resultapp=TF_PPDProcessController.getApprovalProcessStatus(newParentProduct2.id);
        System.assert(resultapp!= null);
        
        test.stopTest();
    }
    private static testMethod void getUnsiloContents(){
        test.startTest();
        String result='';
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');        
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        //Product2 newChildProduct1=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newChildProduct1=insertProductforTesting(productRecordtypeId);

       // Product2 newChildProduct2=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newChildProduct2=insertProductforTesting(productRecordtypeId);

        
        
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Product_Bundle_Parent__c = newParentProduct.id;
        lineItem.Product__c = newchildProduct1.id;
        insert lineItem; 
        Bundle_Line_Item__c lineItems = new Bundle_Line_Item__c();
        lineItems.Product_Bundle_Parent__c = newParentProduct.id;
        lineItems.Product__c = newChildProduct2.id;
        insert lineItems; 
        
        result=TF_PPDProcessController.getUnsiloContents(newParentProduct.id);
        System.assert(result!= '');        
        test.stopTest();
    }
    
    private static testMethod void getProductVersion(){
        test.startTest();
        String result='';
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');        
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        newParentProduct.version__c='1.0.0';
        update newParentProduct;
        result=TF_PPDProcessController.getProductVersion( newParentProduct.version__c);   
        System.assert(result!= '');  
         
        test.stopTest();
    }
    
    
    private static testMethod void getClonedProduct(){
        test.startTest();
        list< Bundle_Line_Item__c> listofLineItems=new List<Bundle_Line_Item__c>();
        TF_PPDProcessController ppdCtrl = new TF_PPDProcessController();
        TF_PPDProcessController.ProductCloneResult result = new TF_PPDProcessController.ProductCloneResult();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        
       // Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        system.debug('======newParentProduct====id :'+newParentProduct.id);
        Decimal unitpriceinGBP=33.00;
        Decimal unitpriceinUSD=44.00;        
        TF_PPDProcessController.addPriceBookEntry(newParentProduct.id, unitpriceinGBP,unitpriceinUSD,1.0,1.0,true);  
        
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Product_Bundle_Parent__c = newParentProduct.id;
        lineItem.Content_Position__c = 1;
        insert lineItem; 
        Bundle_Line_Item__c lineItems = new Bundle_Line_Item__c();
        lineItems.Product_Bundle_Parent__c = newParentProduct.id;
        lineItems.Content_Position__c = 2;
        insert lineItems; 
        result = TF_PPDProcessController.getClonedProduct(newParentProduct.id);
        TF_PPDProcessController.cloneBundleItems(newParentProduct.id, result.productId, '0', '0', string.valueOf(result.totalRecords));
        
        System.assert(result.totalRecords > 0);      
        
        test.stopTest();
        
    }
    private static testMethod void getCloneDataForEdit(){
        String result='';
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
         Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        newParentProduct.Description='test';
        update newParentProduct;
        result=TF_PPDProcessController.getCloneDataForEdit(newParentProduct.id);
        System.assert(result!= '');   
        test.stopTest();
    }
    //Positive test for checkIfProductIsCloned
    private static testMethod void  checkIfProductIsCloned()
    {
        String result='';
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
         Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        newParentProduct.originalProductId__c='12345';
        update newParentProduct;
        result=TF_PPDProcessController.checkIfProductIsCloned(newParentProduct.id);
        System.assert(result== 'cloned');      
        test.stopTest();
    }
    
    //Negative test for checkIfProductIsCloned
    private static testMethod void  checkIfProductIsCloned_null()
    {
        String result='';
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
         Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        newParentProduct.originalProductId__c='';
        update newParentProduct;
        result=TF_PPDProcessController.checkIfProductIsCloned(newParentProduct.id);
        System.assert(result== 'original');      
        test.stopTest();
    }
    //Positive test for saveClonedProductDescription
    private static testMethod void  saveClonedProductDescription()
    {
        String result='';
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');      
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
         Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        //String ProductId=String.valueof(newParentProduct.Id);
        string Description='test';
        result=TF_PPDProcessController.saveClonedProductDescription(newParentProduct.Id,Description);
        System.assert(result== 'Record has been updated successfully!');      
        test.stopTest();
    }
    //Negative test for saveClonedProductDescription
    private static testMethod void  saveClonedProductDescription_null()
    {
        String result='';
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');      
        String testParent='01t1l0000001EYDAA2';
        string Description='test';
        result=TF_PPDProcessController.saveClonedProductDescription(testParent,Description);
        System.assert(result== 'Some error has occured,record has not been updated successfully!');      
        test.stopTest();
    }
    
    
    private static testMethod void  checkIfNewVersionExist()
    { 
        String result='';
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');      
       // Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
         Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        newParentProduct.Hub_Id__c='12345';
        update newParentProduct;
        result=TF_PPDProcessController.checkIfNewVersionExist(newParentProduct.Id);
        System.assert(result== 'false');      
        test.stopTest();
    }
    
    private static testMethod void  restoreClonedProductToOriginal()
    {   
        String result='';
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');      
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
         Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
       // Product2 newChildProduct1=zTEST_Shared.insertProduct2(productRecordtypeId); 
         Product2 newChildProduct1=insertProductforTesting(productRecordtypeId);
       // Product2 newChildProduct2=zTEST_Shared.insertProduct2(productRecordtypeId); 
         Product2 newChildProduct2=insertProductforTesting(productRecordtypeId);
        //inserting bundle line items for original 
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Product_Bundle_Parent__c = newParentProduct.id;
        lineItem.Product__c = newchildProduct1.id;
        lineItem.IsUnsilo__c=false;
        insert lineItem; 
        Bundle_Line_Item__c lineItems = new Bundle_Line_Item__c();
        lineItems.Product_Bundle_Parent__c = newParentProduct.id;
        lineItems.Product__c = newChildProduct2.id;
        lineItems.IsUnsilo__c=true;
        insert lineItems; 
        
        //Product2 newClonedProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
         Product2 newClonedProduct=insertProductforTesting(productRecordtypeId);
        newClonedProduct.version__c='1.0.1';
        newClonedProduct.Description='Cloned Description';
        newClonedProduct.Contributors__c='';
        newClonedProduct.Keywords__c='';
        update newClonedProduct; 
        
       // Product2 newClonedChildProduct1=zTEST_Shared.insertProduct2(productRecordtypeId); 
         Product2 newClonedChildProduct1=insertProductforTesting(productRecordtypeId);
       // Product2 newClonedChildProduct2=zTEST_Shared.insertProduct2(productRecordtypeId); 
         Product2 newClonedChildProduct2=insertProductforTesting(productRecordtypeId);
        
        //inserting bundle line items for cloned 
        Bundle_Line_Item__c clonedlineItem = new Bundle_Line_Item__c();
        clonedlineItem.Product_Bundle_Parent__c = newClonedProduct.id;
        clonedlineItem.Product__c = newClonedChildProduct1.id;
        insert clonedlineItem; 
        Bundle_Line_Item__c clonedlineItems = new Bundle_Line_Item__c();
        lineItems.Product_Bundle_Parent__c = newClonedProduct.id;
        lineItems.Product__c = newClonedChildProduct2.id;
        insert clonedlineItems; 
        TF_PPDProcessController.restoreClonedProductToOriginal(newClonedProduct.id,newParentProduct.Id);
        test.stopTest();
    }
    
    private static testMethod void  test_deleteLineitems(){
        
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');      
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Product_Bundle_Parent__c = newParentProduct.id;
        insert lineItem; 
        
        List<String> lineItmsToDelete = new List<String>();
        lineItmsToDelete.add(lineItem.id);
        TF_PPDProcessController.deleteLineitems(lineItmsToDelete);
        test.stopTest();
    }
    
    private static testMethod void  test_getPickListValues(){
        
        test.startTest();
        
        TF_PPDProcessController.getPickListValues('product2','family');
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
        Integer count= TF_PPDProcessController.getBundleItmsCount(newParentProduct.id);
        
        
    }
    private static testMethod void updateDynamicProductRule(){
        String result='';
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        newParentProduct.Description='test';
        update newParentProduct;
        result=TF_PPDProcessController.updateDynamicProductRule(newParentProduct.id, 'test Rule');
        System.assert(result == 'Rule Saved !');
        
        result=TF_PPDProcessController.updateDynamicProductRule('testid', 'test Rule');
        System.assert(result == 'Error');
        test.stopTest();
    }
    
    private static testMethod void  deletePriceBookEntry_return_Value(){
        Boolean result;
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');        
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
    Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        
        test.startTest();
        result=TF_PPDProcessController.deletePriceBookEntry(newParentProduct.id);
        System.assert(result == true);
        test.stopTest();
    }
    
    public static testmethod void testParseRuleJSON_ReturnNull(){  
        String filter='{"ISBN":"123","title":"sdfsdf","author":"asdf","doi":"123456","netbase":["WB010 - ENVIROnetBASE"],"subjectList":["Test Level 2"],"mediumData":"e-Book","publishData":"Include","minPrice":"10","maxPrice":"10","sortBy":"desc","sortOrderFieldName":"UnitPrice","drmData":"Both","currencyTypeData":"USD","firstPublishedYearData":"2019","publcFromDate":"2019-05-08","publcToDate":"2019-05-22"}';
        TF_PPDProcessController.querySaveElement fl=new TF_PPDProcessController.querySaveElement();
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');        
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        fl=TF_PPDProcessController.parseRuleJson(newParentProduct.id);
        test.stopTest();
    }
    
    public static testmethod void testParseRuleJSON_ReturnValue(){  
        String filter='{"ISBN":"123","title":"sdfsdf","author":"asdf","doi":"123456","netbase":["WB010 - ENVIROnetBASE"],"subjectList":["Test Level 2"],"mediumData":"e-Book","publishData":"Include","minPrice":"10","maxPrice":"10","sortBy":"desc","sortOrderFieldName":"UnitPrice","drmData":"Both","currencyTypeData":"USD","firstPublishedYearData":"2019","publcFromDate":"2019-05-08","publcToDate":"2019-05-22"}';
        TF_PPDProcessController.querySaveElement fl=new TF_PPDProcessController.querySaveElement();
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');        
       // Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        newParentProduct.Dynamic_Collection_Criteria__c='{"ISBN":"","title":"india","author":"","doi":"","netbase":["WB004 - ENGnetBASE","WB010 - ENVIROnetBASE","WB013 - AGRICULTUREnetBASE","WB014 - BUSINESSnetBASE/MANAGEMENTnetBASE","WB015 - NUTRITIONnetBASE","WB017 - MILITARYnetBASE","WB019 - FORENSICnetBASE/LawENFORCEMENTnetBASE","WB020 - STATSnetBASE","WB021 - MATHnetBASE","WB022 - ERGONOMICSnetBASE","WB023 - FOODnetBASE","WB028 - InfoSECURITYnetBASE","WB030 - NEUROSCIENCEnetBASE","WB032 - MATERIALSnetBASE","WB033 - NANOnetBASE","WB034 - POLYMERSnetBASE","WB035 - PHARMACEUTICALnetBASE","WB036 - CivilEngineeringnetBASE","WB037 - ElectricalEngineeringnetBASE","WB038 - MechanicalEngineeringnetBASE","WB039 - PublicADMINISTRATIONnetBASE","WB040 - PlantSCIENCEnetBASE","WB042 - BIOSCIENCEnetBASE","WB043 - CHEMLIBnetBASE","WB045 - ECONOMICSnetBASE","WB048 - PHYSICSnetBASE","WB050 - PROJECTMANAGEMENTnetBASE","WB052 - OCCUP-HEALTHandSAFETYnetBASE","WB055 - WATERnetBASE","WB056 - ENERGYANDCLEANTECHnetBASE","WB057 - SCI-TECHnetBASE","WB058 - COMPUTERSCIENCEnetBASE","WB059 - GEOnetBASE","WB061 - BIOMEDICALSCIENCEnetBASE","WB062 - CHEMICALENGINEERINGnetBASE","WB063 - CHEMISTRYnetBASE","WB064 - ENVIRONMENTALENGINEERINGnetBASE","WB065 - ENVIRONMENTALSCIENCEnetBASE","WB066 - GENERALENGINEERINGnetBASE","WB067 - HEALTHCAREnetBASE","WB068 - HOMELANDSECURITYnetBASE","WB069 - INDUSTRIALENGINEERINGnetBASE","WB070 - ITECHnetBASE","WB071 - LIFESCIENCEnetBASE","WB072 - MEDICINEnetBASE","WB073 - MININGENGINEERINGnetBASE","WB074 - INFORMATIONSCIENCEnetBASE","WB075 - STMnetBASE","WB076 - VETnetBASE","WB999 - ARCHIVEnetBASE"],"subjectList":[],"mediumData":"e-Book","publishData":"Include","minPrice":"","maxPrice":"","sortBy":"desc","sortOrderFieldName":"UnitPrice","drmData":"Both","currencyTypeData":"USD","firstPublishedYearData":"","publcFromDate":"","publcToDate":""}';
        update newParentProduct;
        fl=TF_PPDProcessController.parseRuleJson(newParentProduct.id);
        test.stopTest();
    }        
    
    //Positive Test for getProducts
    private static testMethod void testgetProductsFromPCM() {
        test.startTest();
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        product2 newParentProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Product_Bundle_Parent__c = newParentProduct.id;
        lineItem.Product__c = newParentProduct.id;
        lineItem.Content_Position__c =1;
        insert lineItem;
        
        TF_PPDProcessController.processedQuery pq=new TF_PPDProcessController.processedQuery();
         TF_PPDProcessController.processedQuery pq1=new TF_PPDProcessController.processedQuery();
       // String queryObject='[{"productType":"book","queryObject":[{"type":"separatorBEGIN"},{"type":"criteria","name":"book.format","value":["e-Book"],"operatior":"IN"},{"type":"separatorEND"},{"type":"logical","logicalOpp":"AND"},{"type":"separatorBEGIN"},{"type":"criteria","name":"rights.drm","value":["true"],"operatior":"Equals"},{"type":"separatorEND"}]}]';
        String queryObject='[{"type":"criteria","name":"format","value":["e-Book"],"operatior":"EQ","position":1,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"logical","name":"","value":[],"operatior":"","position":2,"logicalOpp":"AND","logicalOppStartPosLeft":1,"logicalOppEndPosLeft":1,"logicalOppStartPosRight":3,"logicalOppEndPosRight":3},{"type":"criteria","name":"firstPublishedYear","value":["2018"],"operatior":"EQ","position":3,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"logical","name":"","value":[],"operatior":"","position":4,"logicalOpp":"AND","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"criteria","name":"minPrice","value":["10"],"operatior":"GE","position":5,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"logical","name":"","value":[],"operatior":"","position":6,"logicalOpp":"AND","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"criteria","name":"maxPrice","value":["20"],"operatior":"LE","position":7,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"logical","name":"","value":[],"operatior":"","position":8,"logicalOpp":"AND","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"criteria","name":"currency","value":["USD"],"operatior":"EQ","position":9,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0}]';

        //calling mock
        string jsonStr = 'validate test';
        
        Test.setMock(HttpCalloutMock.class, new zTest_TF_PPDProcessController(200, jsonStr));

        pq=TF_PPDProcessController.getProductsFromPCM(newParentProduct.id,queryObject,'false',0,null,50,'USD', 'false','Book');
        pq1=TF_PPDProcessController.getProductsFromPCM(newParentProduct.id,queryObject,'true',0,null,50,'USD', 'false','Book');
        
        test.stopTest();
    }
    
     
    private static testMethod void testgetProductsFromPCMFromSavedQry() {
        test.startTest();
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        product2 newParentProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        
        TF_PPDProcessController.processedQuery pq=new TF_PPDProcessController.processedQuery();
        String savedQryObj='{"filterObject":{"ISBN":"","title":"","author":"","doi":"","netbase":[],"subjectList":[],"mediumData":"e-Book","publishData":"","minPrice":"10","maxPrice":"20","sortBy":"desc","sortOrderFieldName":"UnitPrice","drmData":"Both","currencyTypeData":"USD","firstPublishedYearData":"2018","publcFromDate":null,"publcToDate":null},"ruleElementLst":[{"type":"separator","value":"BEGIN"},{"attribute":"format","relationship":"EQ","type":"criteria","value":"e-Book"},{"type":"logical","value":"AND"},{"attribute":"firstPublishedYear","relationship":"EQ","type":"criteria","value":"2018"},{"type":"logical","value":"AND"},{"type":"separator","value":"BEGIN"},{"attribute":"prices.price","relationship":"GE","type":"criteria","value":"10"},{"type":"logical","value":"AND"},{"attribute":"prices.price","relationship":"LE","type":"criteria","value":"20"},{"type":"logical","value":"AND"},{"attribute":"prices.currency","relationship":"EQ","type":"criteria","value":"USD"},{"type":"separator","value":"END"},{"type":"separator","value":"END"}],"queryString":"format EQ e-Book AND firstPublishedYear EQ 2018 AND minPrice GE 10 AND maxPrice LE 20 AND currency EQ USD "}';
        newParentProduct.Dynamic_Collection_Criteria__c = savedQryObj ;
        update newParentProduct;
        //calling mock
        string jsonStr = 'validate test';
        
        Test.setMock(HttpCalloutMock.class, new zTest_TF_PPDProcessController(200, jsonStr));
        
        newParentProduct.Dynamic_Collection_Criteria__c = null ;
        update newParentProduct;
        
        pq=TF_PPDProcessController.getProductsFromPCM(newParentProduct.id,null,'true',0,'',50,'USD','false','Book');
        
        newParentProduct.Dynamic_Collection_Criteria__c = savedQryObj ;
        update newParentProduct;
        
        pq=TF_PPDProcessController.getProductsFromPCM(newParentProduct.id,null,'true',0,'',50,'USD','false','Book');
        
        TF_PPDProcessController.submitDynamicPackageToPCM(newParentProduct.id);
        test.stopTest();
    }
    
    private static testMethod void testgetPartsDownloadURL() {
        test.startTest();
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        product2 newParentProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        
        //calling mock
        string jsonStr = 'validate test';
        
        Test.setMock(HttpCalloutMock.class, new zTest_TF_PPDProcessController(200, jsonStr));
        String res = TF_PPDProcessController.getPartsDownloadURL(newParentProduct.id);
        
        Test.setMock(HttpCalloutMock.class, new zTest_TF_PPDProcessController(404, jsonStr));
        String res1 = TF_PPDProcessController.getPartsDownloadURL(newParentProduct.id);
        
        Test.setMock(HttpCalloutMock.class, new zTest_TF_PPDProcessController(500, jsonStr));
        String res2 = TF_PPDProcessController.getPartsDownloadURL(newParentProduct.id);
        
        test.stopTest();
    }
    
    private static testMethod void testaddProductsToCollectionFromPCM() {
        test.startTest();
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        product2 newParentProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        String productId = newParentProduct.id;
        String listOfProductsString = '[{"author":"Maryna Romanets","currencyTypeData":"USD","doi":"10.4324/9781351022187","format":"e-Book","id":"9c43274c-92ee-4347-94a0-1c98e5f76986","ISBN":"9781351022187","listPrice":154,"Name":"Ukrainian Erotomaniac Fictions: First Postindependence Wave","publicationDate":"2019-04-25","publisherImprint":"Routledge","title":"Ukrainian Erotomaniac Fictions: First Postindependence Wave","type":"Book"}]';
        String res = TF_PPDProcessController.addProductsToCollectionFromPCM(productId, listOfProductsString, 'true');
        
        String listOfProductsString2 = '[{"author":"Maryna Romanets","currencyTypeData":"USD","doi":"10.4324/9781351022187","format":"e-Book","id":"9c43274c-92ee-4347-94a0-1c98e5f76986","ISBN":"9781351022187","listPrice":154,"Name":"Ukrainian Erotomaniac Fictions: First Postindependence Wave","publicationDate":"2019-04-25","publisherImprint":"Routledge","title":"Ukrainian Erotomaniac Fictions: First Postindependence Wave","type":"Collection"}]';
        String res2 = TF_PPDProcessController.addProductsToCollectionFromPCM(productId, listOfProductsString2, 'true');
        
        test.stopTest();
    }
    
    //Positive Test for getStaticPkgPriceFromPCM
    private static testMethod void testgetStaticPkgPriceFromPCM() {
        test.startTest();
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        product2 newParentProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Product_Bundle_Parent__c = newParentProduct.id;
        lineItem.doi__c = 'doi1234';
        lineItem.PriceGBP__c = 10.00;
        lineItem.PriceUSD__c = 11.00;
        insert lineItem;
        
        TF_PPDProcessController.processedQuery pq=new TF_PPDProcessController.processedQuery();
        
        //calling mock
        string jsonStr = 'validate test';
        
        Test.setMock(HttpCalloutMock.class, new zTest_TF_PPDProcessController(200, jsonStr));
        
        pq=TF_PPDProcessController.getStaticPkgPriceFromPCM(newParentProduct.id,null,'doi','false');
        pq=TF_PPDProcessController.getStaticPkgPriceFromPCM(newParentProduct.id,null,'doi','true');
        pq=TF_PPDProcessController.getStaticPkgPriceFromPCM(newParentProduct.id,'["doi"]','doi','false');
        
        
        test.stopTest();
    }
    
    //Positive Test for getStaticPkgPriceFromPCM
    private static testMethod void testfileUploadAndGetFromPCM() {
        test.startTest();
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        product2 newParentProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        TF_PPDProcessController.processedQuery pq=new TF_PPDProcessController.processedQuery();
        String queryObject='[{"type":"criteria","name":"format","value":["e-Book"],"operatior":"EQ","position":1,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"logical","name":"","value":[],"operatior":"","position":2,"logicalOpp":"AND","logicalOppStartPosLeft":1,"logicalOppEndPosLeft":1,"logicalOppStartPosRight":3,"logicalOppEndPosRight":3},{"type":"criteria","name":"firstPublishedYear","value":["2018"],"operatior":"EQ","position":3,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"logical","name":"","value":[],"operatior":"","position":4,"logicalOpp":"AND","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"criteria","name":"minPrice","value":["10"],"operatior":"GE","position":5,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"logical","name":"","value":[],"operatior":"","position":6,"logicalOpp":"AND","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"criteria","name":"maxPrice","value":["20"],"operatior":"LE","position":7,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"logical","name":"","value":[],"operatior":"","position":8,"logicalOpp":"AND","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0},{"type":"criteria","name":"currency","value":["USD"],"operatior":"EQ","position":9,"logicalOpp":"","logicalOppStartPosLeft":0,"logicalOppEndPosLeft":0,"logicalOppStartPosRight":0,"logicalOppEndPosRight":0}]';
        //calling mock
        string jsonStr = 'validate test';
        
        Test.setMock(HttpCalloutMock.class, new zTest_TF_PPDProcessController(200, jsonStr));
        
        pq=TF_PPDProcessController.fileUploadAndGetFromPCM(newParentProduct.id,'10.4324%2F9781351022187%2C10.4324%2F9780203765531','identifiers.doi',0,10);
        
        test.stopTest();
    }
    
    //Positive Test for getProducts dynamic ui
    private static testMethod void testgetPrdsFromPCM_DynamicUI() {
        test.startTest();
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        product2 newParentProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Product_Bundle_Parent__c = newParentProduct.id;
        lineItem.Product__c = newParentProduct.id;
        lineItem.Content_Position__c =1;
        insert lineItem;
        
        TF_PPDProcessController.processedQuery pq=new TF_PPDProcessController.processedQuery();
        String queryObject='[{"productType":"book","queryObject":[{"type":"separatorBEGIN"},{"type":"criteria","name":"book.format","value":["e-Book"],"operatior":"IN"},{"type":"separatorEND"},{"type":"logical","logicalOpp":"AND"},{"type":"separatorBEGIN"},{"type":"criteria","name":"rights.drm","value":["true"],"operatior":"Equals"},{"type":"separatorEND"}]}]';
        //calling mock
        string jsonStr = 'validate test';
        
        Test.setMock(HttpCalloutMock.class, new zTest_TF_PPDProcessController(200, jsonStr));
        
        pq=TF_PPDProcessController.getPrdsFromPCM_DynamicUI(newParentProduct.id,queryObject,'false',0,null,50,'USD', 'false','Book','Collections');
        pq=TF_PPDProcessController.getPrdsFromPCM_DynamicUI(newParentProduct.id,queryObject,'true',0,null,50,'USD', 'true','Book','OPC');
        
        test.stopTest();
    }
    
    //Positive Test for getProducts dynamic ui
    private static testMethod void testgetCountsFromPCM_DynamicUI() {
        test.startTest();
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        product2 newParentProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Product_Bundle_Parent__c = newParentProduct.id;
        lineItem.Product__c = newParentProduct.id;
        lineItem.Content_Position__c =1;
        insert lineItem;
        
        TF_PPDProcessController.processedQuery pq=new TF_PPDProcessController.processedQuery();
        String queryObject='[{"productType":"book","queryObject":[{"type":"separatorBEGIN"},{"type":"criteria","name":"book.format","value":["e-Book"],"operatior":"IN"},{"type":"separatorEND"},{"type":"logical","logicalOpp":"AND"},{"type":"separatorBEGIN"},{"type":"criteria","name":"rights.drm","value":["true"],"operatior":"Equals"},{"type":"separatorEND"}]}]';
        //calling mock
        string jsonStr = 'validate test';
        
        Test.setMock(HttpCalloutMock.class, new zTest_TF_PPDProcessController(200, jsonStr));
        
        pq=TF_PPDProcessController.getCountsFromPCM_DynamicUI(newParentProduct.id,queryObject,'false',0,50,'USD', 'false','Book','Collections');
        pq=TF_PPDProcessController.getCountsFromPCM_DynamicUI(newParentProduct.id,queryObject,'true',0,50,'USD', 'true','Book','OPC');
        
        test.stopTest();
    }
    
    //getDynamicUIValues 
    private static testMethod void testgetDynamicUIValues() {
        test.startTest();        
        TF_PPDProcessController.getDynamicUIValues('Book','format','All');        
        test.stopTest();
    }
    
    private static testMethod void testgetNetBaseClassifications() {
        test.startTest();        
        Setting__c settingObj=new Setting__c(name='NetbaseClassifications');
        insert settingObj;
        
        TF_PPDProcessController.getNetBaseClassifications();
        test.stopTest();
    }
    
    
    private static testMethod void testWCClassifications() {
        test.startTest();        
        Setting__c settingObj=new Setting__c(name='WC_CodesClassifications');
        insert settingObj;
        
        TF_PPDProcessController.getWCClassifications();
        test.stopTest();
    }
    
    private static testMethod void testgetCountryForRestrictions() {
        test.startTest();        
        Setting__c settingObj=new Setting__c(name='Country_Codes');
        insert settingObj;
        
        TF_PPDProcessController.getCountryForRestrictions();
        test.stopTest();
    }
    private static testMethod void testTreeGetSubjectClassifications() {
        CAS_Subject_Code__c c123 = new CAS_Subject_Code__c();
        CAS_Subject_Code__c c1234 = new CAS_Subject_Code__c();
        CAS_Subject_Code__c c12345 = new CAS_Subject_Code__c();
        CAS_Subject_Code__c c123456 = new CAS_Subject_Code__c();
        CAS_Subject_Code__c c1234567 = new CAS_Subject_Code__c();
        List<CAS_Subject_Code__c> cList = new List<CAS_Subject_Code__c>();
        c123.Name = 'testdata';
        c123.GT_Cat_Code__c = 'qweruywq66777';
        insert c123;
        c1234.Name = 'testdata2';
        c1234.Parent__c = c123.Id;
        c1234.GT_Cat_Code__c = 'sjdkfgdif8768768';
        insert c1234;
        c12345.Name = 'testdata3';
        c12345.Parent__c = c1234.Id;
        c12345.GT_Cat_Code__c = 'sjdkfgdif87688979879';
        insert c12345;
        c123456.Name = 'testdata4';
        c123456.Parent__c = c12345.Id;
        c123456.GT_Cat_Code__c = 'sjdkfgdif876898798728';
        insert c123456;
        c1234567.Name = 'testdata5';
        c1234567.Parent__c = c123456.Id;
        c1234567.GT_Cat_Code__c = 'sjdkfgdif876893458728';
        insert c1234567;
        test.startTest();      
        String typeOfClassification = 'Subject';
        TF_PPDProcessController.TreeGetSubjectClassifications(typeOfClassification);
        test.stopTest();
    }  
    private static testMethod void testTreeGetDeweyClassifications() {
        DeweyCode__c c123 = new DeweyCode__c();
        DeweyCode__c c1234 = new DeweyCode__c();
        DeweyCode__c c12345 = new DeweyCode__c();
        DeweyCode__c c123456 = new DeweyCode__c();
        DeweyCode__c c1234567 = new DeweyCode__c();
        List<DeweyCode__c> cList = new List<DeweyCode__c>();
        c123.Name = 'testdata';
        
        insert c123;
        c1234.Name = 'testdata2';
        c1234.Parent__c = c123.Id;
        
        insert c1234;
        c12345.Name = 'testdata3';
        c12345.Parent__c = c1234.Id;
        
        insert c12345;
        c123456.Name = 'testdata4';
        c123456.Parent__c = c12345.Id;
        
        insert c123456;
        c1234567.Name = 'testdata5';
        c1234567.Parent__c = c123456.Id;
        
        insert c1234567;
        test.startTest();        
        TF_PPDProcessController.TreeGetDeweyClassifications();
        test.stopTest();
    }  
    
    
    private static testMethod void testgetDropDownListValues() {
        test.startTest();   
        Setting__c settingObj=new Setting__c(name='NetbaseClassifications');
        insert settingObj;
        TF_PPDProcessController.getDropDownListValues(settingObj.Name);
        test.stopTest();
    }
    
    private static testMethod void testgetNetBaseClassification() {
        test.startTest();  
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');        
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        newParentProduct.version__c='1.0.0';
        newParentProduct.Netbase_Classifications__c='test';
        update newParentProduct;
        TF_PPDProcessController.getNetBaseClassification(newParentProduct.Id);
        test.stopTest();
    }
    
    
    private static testMethod void testupdateNetBaseClassification()   {
        test.startTest();  
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');        
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        newParentProduct.version__c='1.0.0';
        newParentProduct.Netbase_Classifications__c='test';
        update newParentProduct;
        TF_PPDProcessController.updateNetBaseClassification(newParentProduct.Id,'test1');
        test.stopTest();
    }
    
    private static testMethod void testupdateSubjectClassification()   {
        test.startTest();  
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');        
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        newParentProduct.version__c='1.0.0';
        newParentProduct.Subject_Classifications__c='test';
        update newParentProduct;
        TF_PPDProcessController.updateSubjectClassification(newParentProduct.Id,'test1');
        test.stopTest();
    }
    
    private static testMethod void testgetSubjectClassification() {
        test.startTest();  
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');        
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        newParentProduct.version__c='1.0.0';
        newParentProduct.Subject_Classifications__c='test';
        update newParentProduct;
        TF_PPDProcessController.getSubjectClassification(newParentProduct.Id);
        test.stopTest();
    }
    
    private static testMethod void testupdateCollectionValidity()   {
        test.startTest();  
        Datetime ValidTo=System.today();
        Datetime ValidFrom=System.today();
        Datetime UpdatedFrom=System.today();
        Datetime UpdatedTo=System.today();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');        
       // Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        newParentProduct.version__c='1.0.0';
        newParentProduct.Collection_Valid_From__c =ValidFrom;
        newParentProduct.Collection_Valid_To__c =ValidTo;
        newParentProduct.Collection_updatedFrom__c =UpdatedFrom;
        newParentProduct.Collection_updatedTo__c =UpdatedTo;      
        
        update newParentProduct;
        TF_PPDProcessController.updateCollectionValidity(newParentProduct.Id,ValidTo,ValidFrom,UpdatedFrom,UpdatedTo);
        test.stopTest();
    }
    
    private static testMethod void testgetCollectionValidity() {
        test.startTest();  
        Datetime ValidTo=System.today();
        Datetime ValidFrom=System.today();
        Datetime UpdatedFrom=System.today();
        Datetime UpdatedTo=System.today();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');        
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        newParentProduct.version__c='1.0.0';
        newParentProduct.Collection_Valid_From__c =ValidFrom;
        newParentProduct.Collection_Valid_To__c =ValidTo;
        newParentProduct.Collection_updatedFrom__c =UpdatedFrom;
        newParentProduct.Collection_updatedTo__c =UpdatedTo;  
        update newParentProduct;
        TF_PPDProcessController.getCollectionValidity(newParentProduct.Id);
        test.stopTest();
    }
    
    
    private static testMethod void testgetDotNotations() { 
        test.startTest();  
        Datetime ValidTo=System.today();
        Datetime ValidFrom=System.today();
        Datetime UpdatedFrom=System.today();
        Datetime UpdatedTo=System.today();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');        
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        newParentProduct.version__c='1.0.0';
        newParentProduct.Collection_Valid_From__c =ValidFrom;
        newParentProduct.Collection_Valid_To__c =ValidTo;
        newParentProduct.Collection_updatedFrom__c =UpdatedFrom;
        newParentProduct.Collection_updatedTo__c =UpdatedTo;  
        update newParentProduct;
        TF_PPDProcessController.getDotNotations('Book','format');
        test.stopTest();
    }
    
    private static testMethod void testgetResultColumns() { 
        test.startTest();    
        Setting__c sets=new Setting__c(Checkbox_1_Label__c='',Checkbox_1_Order__c=1,Description__c='test',Name='DynamicSearchResultColumns');
        insert sets;
        Setting_Item__c settings = new Setting_Item__c(Checkbox_1__c=true, Text_1__c='Title',Text_2__c='Name',Text_3__c='text',Text_5__c='Book',Setting__c=sets.Id);
        insert settings;
        Setting_Item__c setting1 = new Setting_Item__c(Checkbox_1__c=true, Text_1__c='Author',Text_2__c='author',Text_3__c='text',Text_5__c='Book',Setting__c=sets.Id);
        insert setting1;
        Setting_Item__c setting2 = new Setting_Item__c(Checkbox_1__c=true, Text_1__c='Author',Text_2__c='author',Text_3__c='currency',Text_5__c='Book',Setting__c=sets.Id);
        insert setting2;
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');        
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        TF_PPDProcessController.getResultColumns();
        test.stopTest();
    }    
    
    private static testMethod void testcheckIfPriceBookEntryExist(){
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');        
       // Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        newParentProduct.version__c='1.0.0';          
        update newParentProduct;
        TF_PPDProcessController.checkIfPriceBookEntryExist(newParentProduct.Id);
        test.stopTest();
    }
    
    
    private static testMethod void testvalidateBusinessId(){
        test.startTest();
        String BusinessId='';
        BusinessId='SDG-PRODATA';
        TF_PPDProcessController.ValidateBusinessId(BusinessId);
        test.stopTest();
    }
    
    private static testMethod void testgetBusinessIdToUpdate(){
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        Product2 newParentProduct1=insertProductforTesting(productRecordtypeId);
    TF_PPDProcessController.getBusinessIdToUpdate(newParentProduct1.Id);
        test.stopTest();
    }
    
     private static testMethod void testgetBusinessIdPrefix(){
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        Product2 newParentProduct1=insertProductforTesting(productRecordtypeId);
    TF_PPDProcessController.getBusinessIdPrefix(newParentProduct1.Id);
        test.stopTest();
    }

private static testMethod void testsaveBusinessIdwithPrefix(){
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        Product2 newParentProduct1=insertProductforTesting(productRecordtypeId);
    TF_PPDProcessController.saveBusinessIdwithPrefix(newParentProduct1.Id);
        test.stopTest();
    }    
    
    private static testMethod void testsaveValidatedBusinessId(){
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        Product2 newParentProduct1=insertProductforTesting(productRecordtypeId);
    TF_PPDProcessController.saveValidatedBusinessId('SDG-TEST21',newParentProduct1.Id,true);
        test.stopTest();
    }  
    
    
     private static testMethod void testcheckIfBusinessIdExist() { 
        test.startTest();
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        Product2 newParentProduct1=insertProductforTesting(productRecordtypeId);
        product2 newParentProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
       
        //calling mock
        string jsonStr = 'validate test';
         integer rescode=0;
        
        Test.setMock(HttpCalloutMock.class, new zTest_TF_PPDProcessController(200, jsonStr));
        
        rescode=TF_PPDProcessController.checkIfBusinessIdExist(newParentProduct.id,'SDG-TOM','event');
        
        
        test.stopTest();
    }
   
     private static testMethod void testgetvalidImageName() { 
        test.startTest();
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        TF_PPDProcessController.ImageUploadNames imupload = new TF_PPDProcessController.ImageUploadNames();
        imupload=TF_PPDProcessController.getvalidImageName(newParentProduct.id);
        test.stopTest();
        
     }
    
    private static testMethod void testsubmitDynamicPackageToPCMCommonModel(){
        test.startTest();
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        Product2 newParentProduct=insertDynamicProductforTesting(productRecordtypeId);
        
        String jsonStr = 'validate test';
        Test.setMock(HttpCalloutMock.class, new zTest_TF_PPDProcessController(200, jsonStr));
        
        
        
        
        TF_PPDProcessController.submitDynamicPackageToPCMCommonModel(newParentProduct.id);
        
        test.stopTest();
    }
    
    private static testMethod void testuploadFile() { 
        test.startTest();
        Id imgId;
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        
        imgId=TF_PPDProcessController.uploadFile(newParentProduct.id,'test.jpg','dsddssddeerrww','JPG');
        test.stopTest();
        
     }
    
    private static testMethod void testImageuploadFile() { 
        test.startTest();
        Id imgId;
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        
        imgId=TF_PPDProcessController.uploadImageFile(newParentProduct.id,'test.jpg','dsddssddeerrww','JPG');
        test.stopTest();
        
     }
    
     private static testMethod void testgetFiles() { 
        test.startTest();
        Id imgId;
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        TF_PPDProcessController.uploadFile(newParentProduct.id,'test.jpg','dsddssddeerrww','JPG');
        List<ContentDocument> lstCDL=new List<ContentDocument>();
        lstCDL=TF_PPDProcessController.getFiles(newParentProduct.id);
        test.stopTest();
        
     }
    
    private static testMethod void testdeleteFile() { 
        test.startTest();
        boolean status;
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        TF_PPDProcessController.uploadFile(newParentProduct.id,'test.jpg','dsddssddeerrww','JPG');
        TF_PPDProcessController.deleteFile(newParentProduct.id);
        test.stopTest();
        
     }
    
    
    private static testMethod void testdeleteFileWithTitle() { 
        test.startTest();
        boolean status;
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        TF_PPDProcessController.uploadFile(newParentProduct.id,'test.jpg','dsddssddeerrww','JPG');
        status=TF_PPDProcessController.deleteFileWithTitle(newParentProduct.id,'test.jpg');
        test.stopTest();
        
     }
    
    private static testMethod void testfetchFiles() { 
        test.startTest();
        boolean status;
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        TF_PPDProcessController.uploadFile(newParentProduct.id,'test.jpg','dsddssddeerrww','JPG');
        TF_PPDProcessController.fetchFiles(newParentProduct.id);
        test.stopTest();
        
     }
    
    
    private static testMethod void testfetchFilesWithTitle() { 
        test.startTest();
        boolean status;
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        
        status=TF_PPDProcessController.fetchFilesWithTitle(newParentProduct.id,'test.jpg');
        test.stopTest();
        
     }
    
     private static testMethod void testgetImplicitFilters() { 
        test.startTest();
        boolean status;
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        List<TF_PPDProcessController.ImplicitFilterLst> impFilLst = new List<TF_PPDProcessController.ImplicitFilterLst>();
        TF_PPDProcessController.ImplicitFilter imp=new TF_PPDProcessController.ImplicitFilter();
        TF_PPDProcessController.getImplicitFilters('collection');
        test.stopTest();
        
     }
    
    private static testMethod void testdownloadSearchResultFromPCM() { 
        test.startTest();
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        product2 newParentProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Product_Bundle_Parent__c = newParentProduct.id;
        lineItem.Product__c = newParentProduct.id;
        lineItem.Content_Position__c =1;
        insert lineItem;
        
        TF_PPDProcessController.processedQuery pq=new TF_PPDProcessController.processedQuery();
        String queryObject='[{"productType":"book","queryObject":[{"type":"separatorBEGIN"},{"type":"criteria","name":"book.format","value":["e-Book"],"operatior":"IN"},{"type":"separatorEND"},{"type":"logical","logicalOpp":"AND"},{"type":"separatorBEGIN"},{"type":"criteria","name":"rights.drm","value":["true"],"operatior":"Equals"},{"type":"separatorEND"}]}]';
        //calling mock
        string jsonStr = 'validate test';
        newParentProduct.Dynamic_Collection_Criteria__c = null ;
        update newParentProduct;
        
        Test.setMock(HttpCalloutMock.class, new zTest_TF_PPDProcessController(202, jsonStr));
        
        pq=TF_PPDProcessController.downloadSearchResultFromPCM(newParentProduct.id,queryObject,'false',0,50,'USD', 'false','Book','Collections');
        
        String savedQryObj='{"filterObject":{"ISBN":"","title":"","author":"","doi":"","netbase":[],"subjectList":[],"mediumData":"e-Book","publishData":"","minPrice":"10","maxPrice":"20","sortBy":"desc","sortOrderFieldName":"UnitPrice","drmData":"Both","currencyTypeData":"USD","firstPublishedYearData":"2018","publcFromDate":null,"publcToDate":null},"ruleElementLst":[{"type":"separator","value":"BEGIN"},{"attribute":"format","relationship":"EQ","type":"criteria","value":"e-Book"},{"type":"logical","value":"AND"},{"attribute":"firstPublishedYear","relationship":"EQ","type":"criteria","value":"2018"},{"type":"logical","value":"AND"},{"type":"separator","value":"BEGIN"},{"attribute":"prices.price","relationship":"GE","type":"criteria","value":"10"},{"type":"logical","value":"AND"},{"attribute":"prices.price","relationship":"LE","type":"criteria","value":"20"},{"type":"logical","value":"AND"},{"attribute":"prices.currency","relationship":"EQ","type":"criteria","value":"USD"},{"type":"separator","value":"END"},{"type":"separator","value":"END"}],"queryString":"format EQ e-Book AND firstPublishedYear EQ 2018 AND minPrice GE 10 AND maxPrice LE 20 AND currency EQ USD "}';
        newParentProduct.Dynamic_Collection_Criteria__c = savedQryObj ;
        update newParentProduct;
        pq=TF_PPDProcessController.downloadSearchResultFromPCM(newParentProduct.id,queryObject,'true',0,50,'USD', 'true','Book','OPC');
        
        test.stopTest();
    }
    
    private static testMethod void testUpdateSKU(){
        test.startTest();
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        product2 newParentProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Product_Bundle_Parent__c = newParentProduct.id;
        lineItem.Product__c = newParentProduct.id;
        lineItem.Content_Position__c =1;
        insert lineItem;
                
        
        //TF_PPDProcessController.processedQuery pq=new TF_PPDProcessController.processedQuery();
        string jsonStr = 'validate test';
        Test.setMock(HttpCalloutMock.class, new zTest_TF_PPDProcessController(200, jsonStr));
        
        TF_PPDProcessController.updateSKU(newParentProduct.id);
        
        test.stopTest();
    }
    
    private static testMethod void testeBookCatalogueDownload() {
        test.startTest();
        //TF_OrgSpecificProps__c setting = new TF_OrgSpecificProps__c();
		//setting.New_Search_API_URL__c  = 'https://api-dev.taylorfrancis.com/v4/products/search/report?type=salessheets&apiVersion=4.0.1';
        //insert setting;
        //calling mock
        string jsonStr = 'validate test';
        
        Test.setMock(HttpCalloutMock.class, new zTest_TF_PPDProcessController(200, jsonStr));
        String res = TF_PPDProcessController.downloadeBookCatalogue();
        
        Test.setMock(HttpCalloutMock.class, new zTest_TF_PPDProcessController(404, jsonStr));
        String res1 = TF_PPDProcessController.downloadeBookCatalogue();
        
        Test.setMock(HttpCalloutMock.class, new zTest_TF_PPDProcessController(500, jsonStr));
        String res2 = TF_PPDProcessController.downloadeBookCatalogue();
        test.stopTest();
    }
    
  private static testMethod void testgetHubId(){
        test.startTest();
        Id productRecordTypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
    Product2 newParentProduct = insertProductforTesting(productRecordTypeId);
    String hubId = TF_PPDProcessController.getHubID(newParentProduct.id);
    test.stopTest();
    }
    
    private static testMethod void testgetRecordTypeId(){
        test.startTest();
        
    String recordTypeId = TF_PPDProcessController.getRecordTypeId('Product2', 'T&F - Collection');
    test.stopTest();
    }
    
    private static testMethod void testprocessQueryObj_Dynamic(){
        test.startTest();
    String  jsonObject = '[{"productType":"book","queryObject":[{"type":"separatorBEGIN"},{"type":"criteria","name":"book.format","value":["e-Book"],"operatior":"IN"},{"type":"separatorEND"},{"type":"logical","logicalOpp":"AND"},{"type":"separatorBEGIN"},{"type":"criteria","name":"rights.drm","value":["true"],"operatior":"Equals"},{"type":"separatorEND"}]}]';
    
    List<TF_PPDProcessController.MultiTypeRules> resultList = new List<TF_PPDProcessController.MultiTypeRules>();
    
    resultList = TF_PPDProcessController.processQueryObj_Dynamic(jsonObject);
    test.stopTest();
    }
    
    private static testMethod void testcheckIfUserIsAdmin() {
        test.startTest();        
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = uniqueName + '@test' + orgId + '.org', 
                         Username = uniqueName + '@test' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        
        
        insert uu;
        
        TF_PPDProcessController.checkIfUserIsAdmin();
        
        
        test.stopTest();
    }
    
    private static testMethod void testcheckIfValidityDatesExist(){
        test.startTest();
         
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        
        Product2 newParentProduct = insertProductforTesting(productRecordTypeId);
        
    String result = TF_PPDProcessController.checkIfValidityDatesExist(newParentProduct.id);
        
        Product2 newParentProduct1 = insertProductforTesting(productRecordTypeId);
        
        Datetime ValidTo=System.today();
        Datetime ValidFrom=System.today();
        Datetime UpdatedFrom=System.today();
        Datetime UpdatedTo=System.today();
        
        newParentProduct1.Collection_Valid_From__c =ValidFrom;
        newParentProduct1.Collection_Valid_To__c =ValidTo;
        newParentProduct1.Collection_updatedFrom__c =UpdatedFrom;
        newParentProduct1.Collection_updatedTo__c =UpdatedTo;      
        
        update newParentProduct1;
        String result1 = TF_PPDProcessController.checkIfValidityDatesExist(newParentProduct1.id);
    test.stopTest();
    }  
    
    private static testmethod void testdeletePriceBookEntry()
    {
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
       // Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        Id standardPriceBookId=Test.getStandardPricebookId();
     system.debug('StdPriceBookIDInTestclass' + '' + standardPriceBookId);
     PriceBookEntry pbeGBP = new PricebookEntry(Pricebook2Id=standardPriceBookId,Product2Id=newParentProduct.id, UnitPrice=2.00, IsActive=true, UseStandardPrice=false,CurrencyIsoCode='GBP');
     insert pbeGBP;  
     
     PriceBookEntry pbeUSD = new PricebookEntry(Pricebook2Id=standardPriceBookId,Product2Id=newParentProduct.id, UnitPrice=4.00, IsActive=true, UseStandardPrice=false,CurrencyIsoCode='USD');
     insert pbeUSD;
        
        
        
        Boolean result =TF_PPDProcessController.deletePriceBookEntry(newParentProduct.id); 
        System.assert(result!= false);
        test.stopTest();
        
    }
    
    private static testmethod void testgetDiscountedPercentage()
    {
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
       // Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        Product2 result =TF_PPDProcessController.getDiscountedPercentage(newParentProduct.id); 
        System.assert(result!= null);
        test.stopTest();
        
    }
    
    private static testmethod void testgetDiscountedPriceBookEntry()
    {
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
       // Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        Id standardPriceBookId=Test.getStandardPricebookId();
        id pbEbook='01s0Y00000832cjQAA';
        
        PriceBookEntry tnfstdpbeGBP = new PricebookEntry(Pricebook2Id=standardPriceBookId,Product2Id=newParentProduct.id, UnitPrice=2.00, UseStandardPrice=false,CurrencyIsoCode='GBP');
        insert tnfstdpbeGBP;
        
        PriceBookEntry tnfpbeGBP = new PricebookEntry(Pricebook2Id=pbEbook,Product2Id=newParentProduct.id, UnitPrice=2.00, UseStandardPrice=false,CurrencyIsoCode='GBP');
        insert tnfpbeGBP;  
 
        
        List<Pricebookentry> result =TF_PPDProcessController.getDiscountedPriceBookEntry(newParentProduct.id); 
        test.stopTest();
        
    }
    
    private static testmethod void testGetS3FileUsingFileId()
    {
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
       // Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        TF_PPDProcessController.GetS3FileUsingFileId(newParentProduct.id); 
        TF_PPDProcessController.getListViews();
        test.stopTest();
        
    }
    
    private static testmethod void testdeleteCollection()
    {
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        TF_PPDProcessController.deleteCollection(newParentProduct.id); 
        test.stopTest();
        
    }
    
    private static testmethod void testaddDiscountedPercentage()
    {
        test.startTest();
		Decimal discountPercent=3.00;
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);

        TF_PPDProcessController.addDiscountedPercentage(newParentProduct.id, discountPercent); 
        test.stopTest();
        
    }
    private static testMethod void testcheckIfCollectionNameExist() { 
        test.startTest();
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        Product2 newParentProduct1=insertProductforTesting(productRecordtypeId);
        product2 newParentProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
       
        //calling mock
        string jsonStr = 'validate test';
        //integer rescode=0;
        
        Test.setMock(HttpCalloutMock.class, new zTest_TF_PPDProcessController(200, jsonStr));
        Test.setMock(HttpCalloutMock.class, new zTest_TF_PPDProcessController(500, jsonStr));
        Test.setMock(HttpCalloutMock.class, new zTest_TF_PPDProcessController(404, jsonStr));
        TF_PPDProcessController.checkCollectionNameExist(newParentProduct.id, 'Test', 'event');
        test.stopTest();
    }
    
    private static testMethod void testsaveValidatedTitle(){
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        Product2 newParentProduct1=insertProductforTesting(productRecordtypeId);
    	TF_PPDProcessController.saveValidatedTitle('TestJuly',newParentProduct1.Id,true);
        test.stopTest();
    }
    
    private static testMethod void testNameToUpdate(){
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        Product2 newParentProduct1=insertProductforTesting(productRecordtypeId);
    	TF_PPDProcessController.getNameToUpdate(newParentProduct1.Id);
        test.stopTest();
    }
    
}