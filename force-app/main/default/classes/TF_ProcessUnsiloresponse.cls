//Test Class-zTest_TF_ProcessUnsiloresponse
global with sharing class TF_ProcessUnsiloresponse{
    public class PagedResult {        
        @AuraEnabled 
        public String doi { get;set; }        
        @AuraEnabled
        public String publisher { get;set; }     
        @AuraEnabled
        public String prodId { get;set; }       
        @AuraEnabled
        public String journal { get;set; }
        @AuraEnabled
        public String publication_date { get;set; }  
        @AuraEnabled
        public String title { get;set; }  
        @AuraEnabled
        public String authors { get;set; }         
        @AuraEnabled
        public String concepts { get;set; }
        @AuraEnabled
        public String id { get;set; }
        @AuraEnabled
        public boolean Open_access { get;set; }
        @AuraEnabled
        public integer content_Position { get;set; }
        @AuraEnabled
        public String content_icon { get;set; }
        @AuraEnabled
        public String validationResult { get;set; }
        @AuraEnabled
        public String datePublished { get;set; } 
        @AuraEnabled
        public String uuid { get;set; } 
        @AuraEnabled
        public String keywords { get;set; }
        @AuraEnabled
        public String type { get;set; }
        @AuraEnabled
        public String source { get;set; }
        @AuraEnabled
        public String mediaType { get;set; }
        @AuraEnabled
        public String isIncluded { get;set; }
        @AuraEnabled
        public String isIncludedIcon { get;set; }
        @AuraEnabled
        public String totalCount { get;set; }
        @AuraEnabled
        public Integer count { get;set; }   
        @AuraEnabled
        public decimal priceBYOGBP { get;set; }
        @AuraEnabled
        public decimal priceBYOUSD { get;set; }
        @AuraEnabled
        public decimal priceISGBP { get;set; }
        @AuraEnabled
        public decimal priceISUSD { get;set; }
        @AuraEnabled
        public decimal priceLPGBP { get;set; }
        @AuraEnabled
        public decimal priceLPUSD { get;set; }
        
    }
    
    public class PagedResultDetails {        
        @AuraEnabled
        public Integer total { get;set; }
        @AuraEnabled
        public Integer prevPstn { get;set; }
        @AuraEnabled
        public Integer nextPstn { get;set; }
        @AuraEnabled
        public Integer currPstn { get;set; }
        @AuraEnabled
        public List <PagedResult> prList { get;set; }
        @AuraEnabled
        public String msg { get;set; }  
        @AuraEnabled
        public String productTypeReturned { get;set; } 
        //Added by Geetika for PCH-3712
        @AuraEnabled
        public String nextPageCursor {get;set;}
        @AuraEnabled
        public String prevPageCursor {get;set;}
        @AuraEnabled
        public String lastPageCursor {get;set;} // end for PCH-3712
    }
    
    public class ContentUploadDetails {        
        @AuraEnabled
        public String errMsg { get;set; }        
        @AuraEnabled
        public String formatErrMsg { get;set; }        
        @AuraEnabled
        public String insertErrMsg { get;set; } 
        @AuraEnabled
        public integer successRecCnt { get;set; }
        @AuraEnabled
        public integer totalRecs { get;set; }
        @AuraEnabled
        public integer position { get;set; }
        @AuraEnabled
        public String containsDupes { get;set; }
        @AuraEnabled
        public String duplicateDOIs { get;set; }
    }
    
    public class AwsResponseDetails {        
        @AuraEnabled
        public String successMsg { get;set; }        
        @AuraEnabled
        public String errorCode { get;set; }
        @AuraEnabled
        public String errorMsg { get;set; }
        @AuraEnabled
        public String s3URL { get;set; }
        @AuraEnabled
        public String snsMessageId { get;set; }
    }
    
    public class PagedResultCollections {        
        @AuraEnabled
        public String value { get;set; }
        @AuraEnabled
        public String label { get;set; }           
    }
    
    public class PagedResultCollDtls {              
        @AuraEnabled
        public List <PagedResultCollections> prList { get;set; }
        @AuraEnabled
        public String msg { get;set; }        
    }
    
    public class ExportIdDtls {              
        @AuraEnabled
        public String exportId { get;set; } 
        @AuraEnabled
        public String msg { get;set; }        
    }
    
    public class LineitemsToValidate {        
        @AuraEnabled
        public Integer totalRecords { get;set; }
        @AuraEnabled
        public Integer position { get;set; }
        @AuraEnabled
        public Integer processedRecords { get;set; }          
        @AuraEnabled
        public String productId { get;set; }
        @AuraEnabled
        public String moreRecsToProcess { get;set; }
        @AuraEnabled
        public String msg { get;set; }
    }
    
    public class LineitemsUUID {        
        @AuraEnabled
        public List <Bundle_Line_Item__c> bundleItmsList { get;set; }
        @AuraEnabled
        public String msg { get;set; }
    }
    
    public class ProductCloneResult {        
        @AuraEnabled
        public Integer position { get;set; }        
        @AuraEnabled
        public Integer processedRecords { get;set; }        
        @AuraEnabled
        public Integer totalRecords { get;set; }        
        @AuraEnabled
        public String productId { get;set; }
        @AuraEnabled
        public String moreRecsToProcess { get;set; }
    }
    
    
    
    @AuraEnabled
    public static PagedResultDetails callUnsiloWithRetry(String classid, String exportid, string retryCount, String type) {
        integer count = integer.valueof(retryCount);
        PagedResultDetails prDetail = new PagedResultDetails();
        while(count > 0){
            prDetail = callUnsilo(classid, exportid, type);
            if(prDetail.msg != 'NOT_FOUND'){
                return prDetail ;
            }
            count-- ;
        }
        prDetail.msg = 'There was an issue getting the details, please try again.';
        return prDetail;        
    }
    
    /*
* The Following method makes a callout to unsilo to get all the documents based on the class id and the export id passed to it.
*/
    
    @AuraEnabled
    public static PagedResultDetails callUnsilo(String classid, String exportid, String type) { 
        List<PagedResult> pr = new List<PagedResult>(); 
        PagedResultDetails prDetail = new PagedResultDetails();
        
        try{
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            if(type.equalsIgnoreCase('ScholarlyArticle')){
                //req.setEndpoint('callout:unsilo/tandf-journals/classes/'+classid+'/exports/'+exportid);
                req.setEndpoint('callout:unsilo_journals/classes/'+classid+'/exports/'+exportid);
            }else{
                //req.setEndpoint('callout:unsilo/tandf-books/classes/'+classid+'/exports/'+exportid);
                req.setEndpoint('callout:unsilo_books/classes/'+classid+'/exports/'+exportid);
            }
            system.debug('callout:unsilo_books/classes/'+classid+'/exports/'+exportid);
            req.setMethod('GET');
            req.setHeader('Content-Type','application/json');
            req.settimeout(120000);
            
            HTTPResponse res = http.send(req);
            system.debug(res.getBody());
            system.debug(String.valueOf(res.getStatusCode()));
            if(String.valueOf(res.getStatusCode()).startsWith('2')){
                TFUnsiloDocument unsiloDoc = new TFUnsiloDocument(); 
                unsiloDoc = (TFUnsiloDocument)JSON.deserialize(res.getBody().replace('"export":', '"export_Z":'), TFUnsiloDocument.class);            
                TFUnsiloDocument.Export_Z exports = unsiloDoc.Export_Z;
                
                List<TFUnsiloDocument.Documents> docs = exports.documents;
                pr = processDocs(docs); 
                prDetail.prList = pr ;
                prDetail.msg = 'Success';
                system.debug(prDetail.prList);
                return prDetail;  
            }else if(res.getStatusCode() == 404){
                prDetail.prList = null ;
                prDetail.msg = 'NOT_FOUND';
                return prDetail;   
            }else{
                prDetail.prList = null ;             
                prDetail.msg = 'There was an issue getting the details, please try later or contact SFDC system admin';
                return prDetail;   
                
            }
        }catch(Exception ex){
            prDetail.prList = null ;
            system.debug(ex.getmessage());
            prDetail.msg = 'There was an issue getting the details, please try later or contact SFDC system admin';
        }
        return prDetail; 
    }
    
    /*
* The Following method makes a callout to unsilo to get all the collections.
*/
    
    @AuraEnabled
    public static PagedResultCollDtls getUnsiloCollections(String type) { 
        List<PagedResultCollections> pr = new List<PagedResultCollections>(); 
        PagedResultCollDtls prDetail = new PagedResultCollDtls();
        
        try{
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            if(type.equalsIgnoreCase('ScholarlyArticle')){
                //req.setEndpoint('callout:unsilo/tandf-journals/collections');
                req.setEndpoint('callout:unsilo_journals/collections');
                
            }else{
                //req.setEndpoint('callout:unsilo/tandf-books/collections');
                req.setEndpoint('callout:unsilo_books/collections');
                
            }
            req.setMethod('GET');
            req.setHeader('Content-Type','application/json');
            req.settimeout(120000); 
            
            HTTPResponse res = http.send(req);
            if(String.valueOf(res.getStatusCode()).startsWith('2')){
                system.debug('res'+ res.getBody());
                TFUnsiloCollections unsiloCollections = new TFUnsiloCollections(); 
                unsiloCollections = (TFUnsiloCollections)JSON.deserialize(res.getBody(), TFUnsiloCollections.class);  
                List<TFUnsiloCollections.Collections> colls = unsiloCollections.collections;
                pr = processColls(colls); 
                prDetail.prList = pr ;
                prDetail.msg = 'Success';
                return prDetail;  
            }else{
                prDetail.prList = null ;
                prDetail.msg = 'There was an issue getting the collection details, please try later or contact SFDC system admin';
                return prDetail;   
            }
        }catch(Exception ex){
            prDetail.prList = null ;
            prDetail.msg = 'There was an issue getting the collection details, please try later or contact SFDC system admin';
        }
        return prDetail; 
    }
    
    /*
* The Following method makes a callout to unsilo to get all the classes based on the collection id passed.
*/
    @AuraEnabled
    public static PagedResultCollDtls getUnsiloClasses(String collectionId, String type) { 
        List<PagedResultCollections> pr = new List<PagedResultCollections>(); 
        PagedResultCollDtls prDetail = new PagedResultCollDtls();
        
        try{
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            if(type.equalsIgnoreCase('ScholarlyArticle')){
                //req.setEndpoint('callout:unsilo/tandf-journals/classes?collectionId='+collectionId);
                req.setEndpoint('callout:unsilo_journals/classes?collectionId='+collectionId);
                
            }else{
                //req.setEndpoint('callout:unsilo/tandf-books/classes?collectionId='+collectionId);
                req.setEndpoint('callout:unsilo_books/classes?collectionId='+collectionId);
                
            }
            req.setMethod('GET');
            req.setHeader('Content-Type','application/json');
            req.settimeout(120000);
            
            HTTPResponse res = http.send(req);
            if(String.valueOf(res.getStatusCode()).startsWith('2')){
                system.debug('res'+ res.getBody());
                TFUnsiloClasses unsiloClasses = new TFUnsiloClasses(); 
                unsiloClasses = (TFUnsiloClasses)JSON.deserialize(res.getBody(), TFUnsiloClasses.class);  
                List<TFUnsiloClasses.Classes> classes = unsiloClasses.classes;
                pr = processClasses(classes); 
                prDetail.prList = pr ;
                prDetail.msg = 'Success';
                return prDetail;  
            }else{
                prDetail.prList = null ;
                prDetail.msg = 'There was an issue getting the class details, please try later or contact SFDC system admin';
                return prDetail;   
            }
        }catch(Exception ex){
            prDetail.prList = null ;
            prDetail.msg = 'There was an issue getting the class details, please try later or contact SFDC system admin';
            system.debug('error details'+ ex.getStackTraceString());
        }
        return prDetail; 
    }
    
    /*
* The Following method makes a callout to unsilo to generate new export id and pass it back for the provided class id.
*/
    @AuraEnabled
    public static ExportIdDtls getUnsiloExportId(String classId, String type){ 
        ExportIdDtls expdtls = new ExportIdDtls(); 
        expdtls.exportId = '';
        expdtls.msg = '';
        try{
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            if(type.equalsIgnoreCase('ScholarlyArticle')){
                //req.setEndpoint('callout:unsilo/tandf-journals/classes/'+classId+'/exports');
                req.setEndpoint('callout:unsilo_journals/classes/'+classId+'/exports');
                
            }else{
                // req.setEndpoint('callout:unsilo/tandf-books/classes/'+classId+'/exports');
                req.setEndpoint('callout:unsilo_books/classes/'+classId+'/exports');
                
            }
            
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json');
            req.settimeout(120000);
            
            HTTPResponse res = http.send(req);
            if(String.valueOf(res.getStatusCode()).startsWith('2')){
                system.debug('res'+ res.getBody());
                String exportIdTxt = 'id';
                JSONParser parser = JSON.createParser(res.getBody());
                while (parser.nextToken() != null) {
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                        String message= parser.getText();
                        parser.nextToken();
                        if(message!= null && message.equalsIgnoreCase(exportIdTxt)) {
                            expdtls.exportId = parser.getText();
                        } 
                    }
                }
                expdtls.msg = 'Success';
                return expdtls;  
            }else{
                expdtls.exportId = null ;
                expdtls.msg = 'There was an issue getting the export Id, please try later or contact SFDC system admin';
                return expdtls;   
            }
        }catch(Exception ex){
            expdtls.exportId = null ;
            expdtls.msg = 'There was an issue getting the export Id, please try later or contact SFDC system admin';
            system.debug('error details'+ ex.getStackTraceString());
        }
        return expdtls; 
    }
    
    /*
* The following method inserts the content records and links it to the product. This method is used to add contents via unsilo and Content Cration Tab.
* 
*/
    
    @AuraEnabled
    public static void addContents(String productID, String contentsListJSON, String classId, String source, String type) {
        PagedResult pr = new PagedResult();
        String contentDocId ;
        String description;
        integer position = 1;
        Set<String> classesSet = new  Set<String>();
        String classes ;
        List<PagedResult> contentsList = (List<PagedResult>) JSON.deserialize(contentsListJSON, List<PagedResult>.class);
        
        if(productID != null && classId != '0'){
            List<Product2> prdList = [SELECT Unsilo_Class_Id__c FROM Product2 WHERE id = :productID];
            Product2 prd = prdList[0];
            classes = prd.Unsilo_Class_Id__c ;
            if(string.isNotBlank(classes)){
                classesSet = (Set<String>)JSON.deserialize(classes, Set<String>.class);
                classesSet.add(classId);
                classes = JSON.serialize(classesSet);
            }else{
                classesSet.add(classId);
                classes = JSON.serialize(classesSet);
            }
            prd.Unsilo_Class_Id__c = classes ;
            update prd ;
        }
        
        List<Bundle_Line_Item__c> lineItms = [SELECT Content_Position__c FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :productID ORDER BY Content_Position__c DESC LIMIT 1];
        
        if(lineItms.size() > 0){
            if(Integer.valueOf(lineItms[0].Content_Position__c) < 1){
                position = 1;
            }else{
                position = Integer.valueOf(lineItms[0].Content_Position__c) + 1;
            }
        }
        
        List<Bundle_Line_Item__c> lineItems = new List<Bundle_Line_Item__c>();
        for(PagedResult result : contentsList) {
            Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
            lineItem.Product_Bundle_Parent__c = productID;
            lineItem.doi__c = result.doi;
            lineItem.Content_ID__c = result.prodId;
            lineItem.Product_Doi__c = result.doi +'||'+ productID;
            lineItem.Journal__c = result.journal != null ? (result.journal).left(250) : null ;
            //lineItem.Publication_Date__c = Date.valueOf(result.publication_date);
            lineItem.Publication_Date__c = result.publication_date!=null? Date.valueOf(result.publication_date) :null;
            lineItem.Title__c = result.title != null ? (result.title).left(250) : null ;
            lineItem.Authors__c = result.authors != null ? (result.authors).left(250) : null ;
            lineItem.Publisher__c = result.publisher;
            lineItem.IsUnsilo__c = true ;
            lineItem.Source__c = source ;
            lineItem.uuid__c=result.uuid;
            lineItem.mediaType__c=result.mediaType;
            lineItem.Type__c= result.type != null ? (result.type).left(100) : type ;
            lineItem.Content_Position__c  = position++ ;
            lineItems.add(lineItem);
        }
        //upsert lineItems Product2.Fields.Content_ID__c;
        Database.SaveResult[] srList = Database.insert(lineItems,false);
        
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                //System.debug('Successfully inserted record: ' + sr.getId());
            }
            else {
                // Operation failed, so get all errors
                for(Database.Error err : sr.getErrors()) {
                    //  System.debug('The following error has occurred.');
                    //   System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    //  System.debug('fields that affected this error: ' + err.getFields());
                }
            }
        }
        
        //  product2 prd = new Product2();
        
        description = 'Version added by '+userinfo.getFirstName()+' '+ userinfo.getLastName()+ ' on '+ system.now()+' with Classid '+classId;
        Blob contentsListJSONBlob = Blob.valueOf(contentsListJSON);
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData = contentsListJSONBlob;
        cv.Title = productID;
        cv.PathOnClient = productID;
        cv.Description = description;
        cv.ReasonForChange = description;
        
        insert cv;
        
        contentDocId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = contentDocId ;
        cdl.LinkedEntityId = productID;
        cdl.ShareType = 'V';
        insert cdl;
        //  prd.id = productID;
        //  prd.Unsilo_Class_Id__c = classId ;
        
        //  update prd ;
    }
    
    /*
* This method is used to insert the file uploaded tab delimited content records.  
*/
    @AuraEnabled
    public static ContentUploadDetails addContentsViaFileUpload(String productID, String documentId) {
        String msg = '' ;
        String invalidFileMsg = '' ;
        String formatErrorMsg = '' ;
        String insertErrorMsg = '' ;
        String fileData ;
        String partialFileData ;
        String headerStr ;
        String reformattedMsg = '';
        boolean invalid = false;
        boolean hasError = false;
        integer numberOfRecords ;
        integer processedRecCount = 0 ;
        integer fullLstCounter = 0;
        integer currentPosition = 0;
        List<String> headerList = new List<String>();
        List<String> recordValueList = new List<String>();
        List<String> listOFContentRecords = new List<String>();
        List<String> partlistOFContentRecords = new List<String>();
        List<String> listofDois = new List<String>();
        
        ContentUploadDetails cudtls = new ContentUploadDetails();
        cudtls.errMsg = '';
        cudtls.formatErrMsg = '';
        cudtls.insertErrMsg = '';
        cudtls.successRecCnt = 0 ;
        cudtls.totalRecs = 0 ;
        cudtls.containsDupes = 'false';
        try{
            if(! string.isBlank(documentId)){
                ContentVersion cv = new ContentVersion();
                cv = [SELECT Id, ContentDocumentId,VersionData,Title,PathOnClient,Description FROM ContentVersion WHERE ContentDocumentId =: documentId];
                fileData = (cv.VersionData).toString();
                //  system.debug('fileData'+fileData);
                fileData = fileData.trim();
                
                msg = checkFileFormat(fileData);
                if(msg == 'Success'){
                    
                    /*  for(List<Bundle_Line_Item__c> listofLineItems : Database.Query('SELECT doi__c FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :productID and IsUnsilo__c = true limit 50000')){
for(Bundle_Line_Item__c bli : listofLineItems){
listofDois.add(bli.doi__c);
}
} */
                    
                    List<Bundle_Line_Item__c> lineItems = [SELECT Content_Position__c FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :productID ORDER BY Content_Position__c LIMIT 1];
                    
                    if(lineItems.size() > 0){
                        currentPosition = Integer.valueOf(lineItems[0].Content_Position__c);
                    }
                    
                    headerStr = (fileData.substring(0,fileData.IndexOf('\n'))).toUpperCase();
                    headerList = headerStr.trim().split('\t');
                    
                    numberOfRecords = fileData.countMatches('\n');
                    cudtls.totalRecs = numberOfRecords ;
                    cudtls.position = - numberOfRecords -1 + currentPosition ;
                    while(fileData.countMatches('\n') > 1000){
                        partialFileData = fileData.left(fileData.indexOf('\n',fileData.length() >= 20000 ? 20000 : 1000));
                        listOFContentRecords.addAll(partialFileData.split('\n'));
                        if(listOFContentRecords.size() >= 1000){
                            fullLstCounter = fullLstCounter + listOFContentRecords.size();
                            processLineItemsToInsert(listOFContentRecords, headerList, productID, listofDois, cudtls, fullLstCounter);
                            listOFContentRecords.clear();
                        }
                        
                        fileData = fileData.substring(partialFileData.length()+1);
                        partialFileData = '';
                    }
                    if(fileData.countMatches('\n') > 0){
                        listOFContentRecords.addAll(fileData.split('\n'));
                        fullLstCounter = fullLstCounter + listOFContentRecords.size();
                        processLineItemsToInsert(listOFContentRecords, headerList, productID, listofDois, cudtls, fullLstCounter);
                        listOFContentRecords.clear();
                    }
                    cudtls.errMsg = msg;
                    
                    ContentVersion conv = new ContentVersion();
                    conv.ContentLocation = 'S';
                    conv.VersionData = Blob.valueOf(((cv.VersionData).toString()) + '\n\n==========File Upload Details==========\n\n Inserted '+ cudtls.successRecCnt +'rows.\n\n Rows with Format issue : \n'+ (cudtls.formatErrMsg != '' ? ((cudtls.formatErrMsg).replace('<br>','\n')) : '0 rows \n')+ 'Rows with data issue on insert : \n'+ (cudtls.insertErrMsg != '' ? ((cudtls.insertErrMsg).replace('<br>','\n')) : '0 rows \n') + '\n\n Duplicates : \n \n'+ (cudtls.containsDupes == 'true' ? '\n Duplicate DOIs and DOIs already part of collection were not considered for processing.' : 'No duplicates \n'));
                    conv.Title = cv.Title +'_'+ productID;
                    conv.PathOnClient = cv.PathOnClient;
                    conv.Description = 'Version added by '+userinfo.getFirstName()+' '+ userinfo.getLastName()+ ' on '+ system.now();
                    conv.ReasonForChange = 'Version added by '+userinfo.getFirstName()+' '+ userinfo.getLastName()+ ' on '+ system.now();
                    insert conv;
                    cudtls.duplicateDOIs = '';
                    String contentDocId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: conv.Id].ContentDocumentId;
                    
                    ContentDocumentLink cdl = new ContentDocumentLink();
                    cdl.ContentDocumentId = contentDocId ;
                    cdl.LinkedEntityId = productID;
                    cdl.ShareType = 'V';
                    insert cdl;
                    if(! String.isBlank(cdl.id) && cudtls.successRecCnt != 0){
                        ContentDocument cd = new ContentDocument();
                        cd.id = documentId;
                        delete cd;
                    }
                    
                }else{
                    cudtls.errMsg = msg;
                    invalid = true ;
                }
            }else{
                cudtls.errMsg = 'Not able to access the uploaded file';
                invalid = true ;
            }
            if(cudtls.successRecCnt == 0){
                invalid = true;
            }
            if(invalid){
                ContentDocument cd = new ContentDocument();
                cd.id = documentId;
                delete cd;
            }
            
        }catch(Exception ex){
            cudtls.errMsg = 'There was an issue while processing the file, please contact SFDC system admin';
            system.debug(ex.getMessage());
            system.debug(ex.getStackTraceString());
            
            return cudtls;
        }
        return cudtls;
    }
    
    private Static void processLineItemsToInsert(List<String> listOFContentRecords, List<String> headerList, String productID, List<String> listofDois, ContentUploadDetails cudtls, integer counter){
        String formatErrorMsg = '' ;
        integer mapKey = 1;
        integer typeIndex ;
        integer doiIndex ;
        integer chapterIndex ;
        integer bookIndex ;
        integer authorIndex ;
        integer position = 0 ;
        String dupDOIs = '';
        List<String> recordValueList = new List<String>();
        List<Bundle_Line_Item__c> lineItemsList = new List<Bundle_Line_Item__c>();
        Map<integer,String> recsForProcessingMap = new Map<integer,String>();
        List<String> ProdDoiList = new List<String>();
        List<String> typeValues = new List<String>{'CHAPTER','COLLECTION','CREATIVEWORK','BOOK','SCHOLARLYARTICLE'};
            typeIndex = headerList.indexOf('TYPE');
        doiIndex = headerList.indexOf('DOI');
        bookIndex = headerList.indexOf('BOOK NAME / JOURNAL NAME');
        chapterIndex = headerList.indexOf('CHAPTER NAME / ARTICLE NAME');
        authorIndex = headerList.indexOf('AUTHORS');
        counter = counter - listOFContentRecords.size() + 1 ;
        position = cudtls.position ;
        
        for(String rec : listOFContentRecords){
            recordValueList = rec.split('\t');
            if(recordValueList.size() == 5 && String.isNotBlank(recordValueList[doiIndex])){
                ProdDoiList.add(recordValueList[doiIndex].trim() +'||'+ productID);
            }
        }
        
        listofDois.clear() ;
        
        for(List<Bundle_Line_Item__c> listofLineItems : Database.Query('SELECT doi__c FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :productID and IsUnsilo__c = true and Product_Doi__c in : ProdDoiList limit 50000')){
            for(Bundle_Line_Item__c bli : listofLineItems){
                listofDois.add(bli.doi__c);
            }
        }
        
        for(String rec : listOFContentRecords){
            recordValueList = rec.split('\t');
            if(recordValueList.size() == 5 && String.isNotBlank(recordValueList[0]) && String.isNotBlank(recordValueList[1]) && String.isNotBlank(recordValueList[2]) && String.isNotBlank(recordValueList[3]) && String.isNotBlank(recordValueList[4])){
                if(typeValues.contains((recordValueList[typeIndex].left(100)).toUpperCase())){
                    if(counter != 1 && ! listofDois.contains(recordValueList[doiIndex].trim())){
                        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
                        lineItem.Product_Bundle_Parent__c = productID;
                        lineItem.doi__c = recordValueList[doiIndex];
                        lineItem.Product_Doi__c = recordValueList[doiIndex].trim() +'||'+ productID;
                        lineItem.Content_ID__c = recordValueList[doiIndex];
                        lineItem.Journal__c = recordValueList[bookIndex].left(250);
                        lineItem.Title__c = recordValueList[chapterIndex].left(250);
                        lineItem.Authors__c = recordValueList[authorIndex].left(250);
                        lineItem.Type__c = recordValueList[typeIndex].left(100);
                        lineItem.Source__c = 'Manual';
                        lineItem.Content_Position__c = position ++ ;
                        lineItem.IsUnsilo__c = true ;
                        
                        lineItemsList.add(lineItem);
                        recsForProcessingMap.put(mapKey,'<b>Row number - </b>'+ counter + ' ,<b>Row data - </b>'+ rec+'<br>');
                        mapKey ++;
                    }else if(cudtls.containsDupes == 'false' && listofDois.contains(recordValueList[doiIndex])){
                        cudtls.containsDupes = 'true';
                    }
                }else if(counter != 1){
                    formatErrorMsg = formatErrorMsg + '<b>Row number - </b>'+ counter + ' ,<b>Row data (Invalid Type) - </b>'+ rec+'<br>'; 
                }
            }else{
                formatErrorMsg = formatErrorMsg + '<b>Row number - </b>'+ counter + ' ,<b>Row data - </b>'+ rec+'<br>';
            }
            counter ++ ;
        }
        cudtls.formatErrMsg = cudtls.formatErrMsg + formatErrorMsg;
        cudtls.position = position;
        insertLineItems(lineItemsList, recsForProcessingMap, cudtls);
    }
    
    private Static void insertLineItems(List<Bundle_Line_Item__c> lineItemsSubList, Map<integer,String> recsForProcessingMap, ContentUploadDetails cudtls){
        String insertMsg = '' ;
        boolean hasError = false ;
        integer counter = 1 ;
        integer processedRecCount = 0 ;
        if(lineItemsSubList.size() > 0){
            List<Database.SaveResult> iResults = Database.insert(lineItemsSubList,false);
            for(Database.SaveResult result:iResults) {
                if (!result.isSuccess()){
                    hasError = true ;
                    String errMsg = '';
                    
                    for(Database.Error e : result.getErrors()) {
                        if(e.getStatusCode() != StatusCode.DUPLICATE_VALUE){
                            errMsg = errMsg + e.getMessage() + '<br>' ;
                        }else if(cudtls.containsDupes == 'false'){
                            cudtls.containsDupes = 'true';
                        }
                    }
                    if(String.isNotBlank(errMsg)){
                        insertMsg = insertMsg + recsForProcessingMap.get(counter) + 'Error details : ' + errMsg + '<br>';
                    }
                }else{
                    processedRecCount ++ ;
                }
                counter ++ ;
            }
        }
        cudtls.insertErrMsg = cudtls.insertErrMsg + insertMsg;
        cudtls.successRecCnt = cudtls.successRecCnt + processedRecCount ;
    }
    
    private Static String checkFileFormat(String fileData){
        String msg = 'Success';
        String headerStr ;
        integer numberOfRecords ;
        List<String> headerList = new List<String>();
        
        if(string.isBlank(fileData)){
            msg = 'Uploaded empty file';
            return msg;
        }
        
        if(fileData.IndexOf('\n') == -1){
            msg = '<span style="color: #b30000;">Data not present.</span>';
            return msg;
        }
        
        headerStr = (fileData.substring(0,fileData.IndexOf('\n'))).toUpperCase();
        headerList = headerStr.trim().split('\t');
        
        if(!(headerList.size() == 5 && headerList.contains('TYPE') && headerList.contains('DOI') && headerList.contains('BOOK NAME / JOURNAL NAME') && headerList.contains('CHAPTER NAME / ARTICLE NAME') && headerList.contains('AUTHORS'))){
            msg = '<span style="color: #b30000;">Invalid header format.</span> <br> Example header(Header to have these values in a tab separated format) : Type || DOI || Book Name / Journal Name || Chapter Name / Article Name || Authors';
            return msg;
        }
        
        numberOfRecords = fileData.countMatches('\n');
        if(numberOfRecords > 5000){
            msg = '<span style="color: #b30000;">File exceeds maximum number of rows.</span>';
            return msg;
        }
        return msg;
    }
    
    private Static List<PagedResult> processDocs(List<TFUnsiloDocument.Documents> docs){
        
        List<PagedResult> contentDataList = new  List<PagedResult>();
        List<TFUnsiloDocument.Authors> authors = new List<TFUnsiloDocument.Authors>();
        
        for(TFUnsiloDocument.Documents doc : docs){
            authors = doc.authors ;
            PagedResult contentData = new PagedResult();
            String author = ''; 
            contentData.id = doc.doi;
            contentData.doi = doc.doi;
            contentData.prodId = doc.id;
            contentData.journal = doc.journal;
            contentData.publication_date = doc.publicationDate;
            contentData.publisher = doc.publisher;
            contentData.title = doc.title;
            if(authors!=null){
                for(TFUnsiloDocument.Authors auth: authors){
                    author = author + '||' + auth.lastName;
                }  
                
                if(author.length() > 0){
                    contentData.authors = author.right(author.length() - 2);
                } 
            }
            contentDataList.add(contentData);                
        }
        return contentDataList;
    }
    
    private Static List<PagedResultCollections> processColls(List<TFUnsiloCollections.Collections> colls){
        
        List<PagedResultCollections> collectionList = new  List<PagedResultCollections>();
        
        for(TFUnsiloCollections.Collections coll : colls){
            PagedResultCollections collection = new PagedResultCollections();
            
            collection.label = coll.title ;
            collection.value = coll.id ;
            collectionList.add(collection);
        }
        
        return collectionList;
    }
    
    
    private Static List<PagedResultCollections> processClasses(List<TFUnsiloClasses.Classes> classes){
        
        List<PagedResultCollections> classesList = new  List<PagedResultCollections>();
        
        for(TFUnsiloClasses.Classes cls : classes){
            PagedResultCollections prCls = new PagedResultCollections();
            //  String exportId ;
            // exportId = cls.exports != null ? cls.exports.isEmpty() ? '' : cls.exports[0].id : '' ;
            prCls.label = cls.title ;
            // prCls.value = cls.id +'||'+ exportId;
            prCls.value = cls.id ;
            
            classesList.add(prCls);
        }
        PagedResultCollections prCls = new PagedResultCollections();
        /* prCls.label = '--None--';
prCls.value = '--None--';
classesList.add(0,prCls);*/
        return classesList;
    }
    
    @AuraEnabled
    public static PagedResultDetails getUnsiloBundleRecords(String bundleID, String position, String lastPageLimit, String evnt, String addionalCriteria) {
        system.debug(bundleID +','+ position +','+ lastPageLimit +','+evnt);
        List<Bundle_Line_Item__c> lineItems = new List<Bundle_Line_Item__c>();
        List<PagedResult> contentDataList = new  List<PagedResult>();
        PagedResultDetails prDetails = new PagedResultDetails();
        prDetails.nextPstn = 0 ;
        prDetails.prevPstn = 0 ;
        Integer currPstn = Integer.valueOf(position);
        Integer nextPstn ;
        Integer prevPstn ;
        Integer lstPgLmt = Integer.valueOf(lastPageLimit);
        Integer totalRecords ;
        String selectStrg ;
        String whereClause ;
        String unsilo = 'UNSILO';
        String lineItemStatus='IsDelete';
        
        //selectStrg = 'SELECT id, Product_Bundle_Parent__c, doi__c, Content_ID__c, Journal__c,Publication_Date__c, Title__c, Authors__c, Product_Publisher__c, Open_access__c, Content_Position__c, ValidationResult__c, Type__c, Source__c FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :bundleID and IsUnsilo__c = true ';
        selectStrg = 'SELECT id, Product_Bundle_Parent__c, doi__c, Content_ID__c, Journal__c,Publication_Date__c, Title__c, Authors__c, Publisher__c, Open_access__c, Content_Position__c, ValidationResult__c, Type__c, Source__c, Product__r.Product_Id_Link__c, IsIncluded__c  FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :bundleID' + ' and lineItemStatus__c != :lineItemStatus' ;
        if(evnt == 'Next'){
            whereClause = ' and Content_Position__c > :currPstn ORDER BY Content_Position__c limit 1500';
        }else if(evnt == 'Prev'){
            whereClause = ' and Content_Position__c < :currPstn ORDER BY Content_Position__c DESC limit 1500';
        }else if(evnt == 'First'){
            whereClause = ' ORDER BY Content_Position__c limit 1500';
        }else if(evnt == 'Last'){
            whereClause = ' ORDER BY Content_Position__c DESC limit :lstPgLmt';
        }
        if(addionalCriteria == 'unsilo'){
            whereClause = ' and Source__c != :unsilo ' + whereClause;
        }else if(addionalCriteria == 'Exclusion'){
            whereClause = ' and IsIncluded__c = false ' + whereClause;
        }else{
            whereClause = ' and IsIncluded__c = true ' + whereClause;
        }
        system.debug('selectStrg  whereClause'+ selectStrg + whereClause);
        
        lineItems = Database.Query(selectStrg + whereClause);
        
        
        /*for(List<Bundle_Line_Item__c> listofLineItems : Database.Query('SELECT id, Product_Bundle_Parent__c, doi__c, Content_ID__c, Journal__c,Publication_Date__c, Title__c, Authors__c, Publisher__c, Open_access__c, Content_Position__c  FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :bundleID and IsUnsilo__c = true limit 50000')){
lineItems.addAll(listofLineItems);
}*/
        if(lineItems.size() > 0 && evnt != 'Last' && evnt != 'Prev' ){
            nextPstn =  integer.valueOf(lineItems[lineItems.size() - 1].Content_Position__c) ;
            prevPstn =  integer.valueOf(lineItems[0].Content_Position__c) ;
            prDetails.nextPstn = nextPstn ;
            prDetails.prevPstn = prevPstn ;
        }else if(lineItems.size() > 0 && evnt == 'Prev' ){
            prevPstn =  integer.valueOf(lineItems[lineItems.size() - 1].Content_Position__c) ;
            nextPstn =  integer.valueOf(lineItems[0].Content_Position__c) ;
            prDetails.nextPstn = nextPstn ;
            prDetails.prevPstn = prevPstn ;
        }else if(lineItems.size() > 0 && evnt == 'Last' ){
            prevPstn =  integer.valueOf(lineItems[lineItems.size() - 1].Content_Position__c) ;
            nextPstn =  integer.valueOf(lineItems[0].Content_Position__c) ;
            prDetails.nextPstn = nextPstn ;
            prDetails.prevPstn = prevPstn ;
        }
        if(addionalCriteria == 'unsilo'){
            
            totalRecords = [SELECT count() FROM 
                            Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :bundleID and Source__c != :unsilo and lineItemStatus__c != :lineItemStatus];
        }else if(addionalCriteria == 'Exclusion'){
            totalRecords = [SELECT count() FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :bundleID and IsIncluded__c  = false and lineItemStatus__c != :lineItemStatus];
        }else{
            totalRecords = [SELECT count() FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :bundleID and IsIncluded__c  = true and lineItemStatus__c != :lineItemStatus];
        }
        
        List<Product2> p = [SELECT id,Is_collection_free__c FROM Product2 WHERE id=: bundleID];
        Boolean collectionStatus = p[0].Is_collection_free__c;
        
        for(Bundle_Line_Item__c itm : lineItems){
            PagedResult contentData = new PagedResult();
            contentData.id = itm.id;
            contentData.doi = itm.doi__c;
            contentData.prodId = itm.Content_ID__c;
            contentData.journal = itm.Journal__c;
            contentData.publication_date = String.valueOf(itm.Publication_Date__c);
            contentData.publisher = itm.Publisher__c;
            contentData.title = itm.Title__c;
            contentData.authors = itm.Authors__c;
            contentData.Open_access = itm.Open_access__c;
            contentData.validationResult = itm.ValidationResult__c;
            contentData.source = itm.Source__c ;
            contentData.type = itm.Type__c;
            contentData.content_Position = integer.valueOf(itm.Content_Position__c);
            contentData.isIncluded = itm.IsIncluded__c ? 'Included' : 'Excluded' ;
            contentData.isIncludedIcon = itm.IsIncluded__c ? 'custom:custom6' : 'custom:custom12' ;
            /*if(collectionStatus){
                contentData.Open_access = true;
            } else {
                contentData.Open_access = false;
            }*/
            system.debug('openAccessUnsilo ' + contentData.Open_access);
            contentDataList.add(contentData);                
        }
        prDetails.total = totalRecords;
        prDetails.prList = contentDataList;
        // prevPstn nextPstn
        //  prDetails.nextPstn = 0;
        return prDetails;          
    }
    
    @AuraEnabled
    public static String getContributors(String prodId) {
        String contributors = '';
        if(prodId != null){
            product2 prd = [SELECT id, Contributors__c  FROM Product2 WHERE id = :prodId Limit 1];
            if(prd != null){
                contributors =  prd.Contributors__c ;
            }
        }
        return contributors;
    }
    
    @AuraEnabled
    public static String getKeywords(String prodId) {
        String keywords = '';
        if(prodId != null){
            product2 prd = [SELECT id, Keywords__c  FROM Product2 WHERE id = :prodId Limit 1];
            if(prd != null){
                keywords =  prd.Keywords__c ; 
            }
        }
        return keywords;
    }
    
    
    @AuraEnabled
    public static String deleteAllSpecifiedDocs(String parentProductID, String docsToDel) {
        system.debug('docsToDel '+docsToDel);
        Integer totalRecords;
        String msg = 'No records to delete';
        Boolean inclusion = true ;
        if(docsToDel != null && (docsToDel == 'All' || docsToDel == 'Inclusion')){
            inclusion = true ;
        }else if(docsToDel != null && docsToDel == 'Exclusion'){
            inclusion = false ;
        }
        totalRecords = [SELECT count() FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :parentProductID and IsIncluded__c =: inclusion];
        list< Bundle_Line_Item__c> listofLineItems = [SELECT id, name FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :parentProductID and IsIncluded__c =: inclusion limit 10000];
        
        if(totalRecords <= 9000 && totalRecords > 0 && listofLineItems.size() > 0){
            if(docsToDel == 'Inclusion'){
                msg = 'All inclusion records have been deleted from the Collection';
            }else if(docsToDel == 'Exclusion'){
                msg = 'All exclusion records have been deleted from the Collection';
            }else{
                msg = 'All records have been deleted from the Collection';
            }
        }else if(totalRecords > 9000 && listofLineItems.size() > 0){
            msg = '9000 records have been deleted from the Collection, click the buton again to delete the remaining documents';
        }
        
        if(listofLineItems.size() > 0){
            delete listofLineItems;
            
            product2 prd = new Product2();
            prd.id = parentProductID;
            prd.Unsilo_Class_Id__c = '' ;
            update prd ;
            
            return msg;
        }
        
        return msg;
    }
    
    //search methodby SOQL   
    @AuraEnabled
    public static PagedResultDetails getUnsiloBundleRecordsBySearchSOSQL(String searchText,String bundleID, String evt) {
        Integer totalRecords ;
        String isDelete='IsDelete';
        String FinalSearchString='%'+searchText+'%';  
        //Date DateSearchText=Date.valueof(searchText);
        PagedResultDetails prDetails = new PagedResultDetails();
        List<PagedResult> contentDataList = new  List<PagedResult>();
        List<Bundle_Line_Item__c> lineItems = new List<Bundle_Line_Item__c>();
        if(evt == 'Validation' || evt == 'ValidationInclusion'){
            lineItems = [SELECT id, Product_Bundle_Parent__c, doi__c, Content_ID__c, Journal__c,Publication_Date__c, Title__c, Authors__c, Product_Publisher__c, Open_access__c, ValidationResult__c, Type__c, Source__c,Publisher__c FROM 
                         Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :bundleID and lineItemStatus__c!=:isDelete 
                         and Valid__c = 'false' and IsIncluded__c = true LIMIT 9000];  
            totalRecords = [SELECT count() FROM 
                            Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :bundleID and lineItemStatus__c!=:isDelete
                            and Valid__c = 'false' and IsIncluded__c = true LIMIT 9000];
        }else if(evt == 'ValidationExclusion'){
            lineItems = [SELECT id, Product_Bundle_Parent__c, doi__c, Content_ID__c, Journal__c,Publication_Date__c, Title__c, Authors__c, Product_Publisher__c, Open_access__c, ValidationResult__c, Type__c, Source__c,Publisher__c FROM 
                         Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :bundleID  and lineItemStatus__c!=:isDelete
                         and Valid__c = 'false' and IsIncluded__c = false LIMIT 9000];  
            totalRecords = [SELECT count() FROM 
                            Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :bundleID and lineItemStatus__c!=:isDelete
                            and Valid__c = 'false' and IsIncluded__c = false LIMIT 9000];
        }else if(evt == 'selectAndDel'){
            lineItems = [SELECT id, Product_Bundle_Parent__c, doi__c, Content_ID__c, Journal__c,Publication_Date__c, Title__c, Authors__c, Product_Publisher__c, Open_access__c,ValidationResult__c, Type__c, Source__c,Publisher__c FROM 
                         Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :bundleID  and lineItemStatus__c!=:isDelete
                         and Source__c  != 'UNSILO' and (Journal__c like :FinalSearchString or Title__c like :FinalSearchString or doi__c like :FinalSearchString
                                                         or Authors__c like : FinalSearchString or  Publisher__c like :FinalSearchString or Type__c like :FinalSearchString or Source__c like :FinalSearchString) LIMIT 9000];
            totalRecords = [SELECT count() FROM 
                            Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :bundleID and lineItemStatus__c!=:isDelete
                            and Source__c  != 'UNSILO' and (Journal__c like :FinalSearchString or Title__c like :FinalSearchString or doi__c like :FinalSearchString or Authors__c like : FinalSearchString or  Publisher__c like :FinalSearchString or Type__c like :FinalSearchString or Source__c like :FinalSearchString) LIMIT 9000]; //Source__c  != 'UNSILO'
        }else if(evt == 'searchExclusion'){
            lineItems = [SELECT id, Product_Bundle_Parent__c, doi__c, Content_ID__c, Journal__c,Publication_Date__c, Title__c, Authors__c, Product_Publisher__c, Open_access__c,ValidationResult__c, Type__c, Source__c, Publisher__c FROM 
                         Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :bundleID  and lineItemStatus__c!=:isDelete
                         and (Journal__c like :FinalSearchString or Title__c like :FinalSearchString or doi__c like :FinalSearchString
                              or Authors__c like : FinalSearchString or  Publisher__c like :FinalSearchString or Type__c like :FinalSearchString or Source__c like :FinalSearchString) and IsIncluded__c = false LIMIT 9000];  
            totalRecords = [SELECT count() FROM 
                            Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :bundleID and lineItemStatus__c!=:isDelete
                            and (Journal__c like :FinalSearchString or Title__c like :FinalSearchString or doi__c like :FinalSearchString or Authors__c like : FinalSearchString or  Publisher__c like :FinalSearchString or Type__c like :FinalSearchString or Source__c like :FinalSearchString) and IsIncluded__c = false LIMIT 9000];
        }else{
            lineItems = [SELECT id, Product_Bundle_Parent__c, doi__c, Content_ID__c, Journal__c,Publication_Date__c, Title__c, Authors__c, Product_Publisher__c, Open_access__c,ValidationResult__c, Type__c, Source__c, Publisher__c FROM 
                         Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :bundleID and lineItemStatus__c!=:isDelete
                         and (Journal__c like :FinalSearchString or Title__c like :FinalSearchString or doi__c like :FinalSearchString
                              or Authors__c like : FinalSearchString or  Publisher__c like :FinalSearchString or Type__c like :FinalSearchString or Source__c like :FinalSearchString) and IsIncluded__c = true  LIMIT 9000];  
            totalRecords = [SELECT count() FROM 
                            Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :bundleID and lineItemStatus__c!=:isDelete
                            and (Journal__c like :FinalSearchString or Title__c like :FinalSearchString or doi__c like :FinalSearchString or Authors__c like : FinalSearchString or  Publisher__c like :FinalSearchString or Type__c like :FinalSearchString or Source__c like :FinalSearchString) and IsIncluded__c = true LIMIT 9000];
        }
        for(Bundle_Line_Item__c itm : lineItems){ 
            PagedResult contentData = new PagedResult();
            contentData.id = itm.id;
            contentData.doi = itm.doi__c;
            contentData.prodId = itm.Content_ID__c;
            contentData.journal = itm.Journal__c;
            contentData.publication_date = String.valueOf(itm.Publication_Date__c);
            contentData.publisher = itm.Publisher__c;
            contentData.title = itm.Title__c;
            contentData.authors = itm.Authors__c;
            contentData.type = itm.Type__c;
            contentData.source = itm.Source__c;
            contentData.Open_access = itm.Open_access__c;
            
            contentData.validationResult = itm.ValidationResult__c;
            
            contentDataList.add(contentData);                
        }
        prDetails.total = totalRecords;     
        prDetails.prList = contentDataList;
        return prDetails;          
    }
    
    
    @AuraEnabled
    public static String updateContents(String contentsListJSON) {
        String msg = 'No Records to update';
        List<PagedResult> contentsList = (List<PagedResult>) JSON.deserialize(contentsListJSON, List<PagedResult>.class);
        System.debug('JSON ' + contentsListJSON);
        if(contentsList != null){
            List<Bundle_Line_Item__c> lineItems = new List<Bundle_Line_Item__c>();
            for(PagedResult pr: contentsList){
                Bundle_Line_Item__c lineItm = new Bundle_Line_Item__c();
                lineItm.id = pr.id ;
                lineItm.Open_access__c = pr.Open_access ;
                lineItm.lineItemStatus__c='IsUpdate';
                lineItems.add(lineItm);
            }
            
            if(lineItems.size() > 0){
                update lineItems;
                msg = 'Records updated successfully';
            }
        }
        return msg;
    }
    
    @AuraEnabled
    public static AwsResponseDetails putCollectionJsonToS3AndNotify(String productId, String s3JsonString) {
        AwsResponseDetails awsResponse = new AwsResponseDetails();
        // String s3JsonString ;
        String response ;
        String bucketName ;
        // s3JsonString = TF_GenerateJson.GenerateS3Json(productId);
        if(!String.isBlank(s3JsonString)){
            TF_AWSService awsService = new TF_AWSService();
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            bucketName = (String) orgSpecificProps.get('AWS_S3_Approved_Bucket__c');
            response = awsService.putProductJsonToS3(s3JsonString, productId, bucketName);
            if(response != null){
                awsResponse.successMsg = 'Collection JSON Successfully placed in S3 bucket. Location : '+response;
                awsResponse.errorCode = '';
                awsResponse.errorMsg = '';
                awsResponse.s3URL = response;
            }else{
                awsResponse.successMsg = '';
                awsResponse.errorCode = '';
                awsResponse.s3URL = '';
                awsResponse.errorMsg = 'There was an issue placing the JSON to S3, please try later or contact SFDC system admin';
            }
            
            if(!String.isBlank(awsResponse.successMsg)){
                String msgId ;
                String snsJson;
                snsJson = TF_GenerateJson.GenerateSNSJson(productId, awsResponse.s3URL);
                HttpResponse resp = awsService.postNotificationToSNS(snsJson, productId);
                
                if(resp != null && String.valueOf(resp.getStatusCode()).startsWith('2')){
                    Dom.Document doc = resp.getBodyDocument();
                    Dom.XMLNode awsSNSResp = doc.getRootElement();
                    
                    for(Dom.XMLNode child : awsSNSResp.getChildElements()){
                        String childTagName = child.getName();
                        String value = child.getText();
                        if(isValuePresent(childTagName)){
                            if(childTagName == 'PublishResult'){
                                for(Dom.XMLNode gchild : child.getChildElements()){
                                    String gchildTagName = gchild.getName();
                                    String gcvalue = gchild.getText();
                                    if(isValuePresent(childTagName)){
                                        if(gchildTagName == 'MessageId'){
                                            msgId = gcvalue;
                                        }
                                    }
                                }
                            }
                        }
                    } 
                    awsResponse.successMsg = 'Successfully published to SNS. Message Id: '+ msgId;
                    awsResponse.errorCode = '';
                    awsResponse.errorMsg = '';
                    awsResponse.snsMessageId = msgId;
                }else{
                    
                    awsResponse.successMsg = '';
                    awsResponse.snsMessageId = '';
                    awsResponse.errorCode = String.valueOf(resp.getStatusCode());
                    awsResponse.errorMsg = 'There was an issue Publishing the JSON to SNS, please try later or contact SFDC system admin';
                }
            }
        }else{
            awsResponse.successMsg = '';
            awsResponse.errorCode = '';
            awsResponse.errorMsg = 'JSON string is blank';
            awsResponse.s3URL = '';
        }
        System.debug('successMsg '+awsResponse.successMsg);
        System.debug('errorCode '+awsResponse.errorCode);
        System.debug('errorMsg '+awsResponse.errorMsg);
        
        return awsResponse;
    }
    
    @AuraEnabled
    public static Product2 getProductDetails(String prodId) {
        product2 prd = [SELECT id, Unsilo_Class_Id__c FROM Product2 WHERE id = :prodId Limit 1];
        return prd ;
    }
    
    @AuraEnabled
    public static String updateContributors(String prodId, String contJSON) {
        String msg = 'success' ;
        try{
            system.debug('contJSON'+contJSON);
            if(prodId != null){
                product2 prod = new product2();
                prod.id = prodId;
                prod.Contributors__c = contJSON;
                update prod;
            }else{
                msg = 'Product id is null';
            }
        }catch(Exception ex){
            msg = 'There was an issue updating the details, please contact SFDC system admin';
        }
        return msg;        
    }
    
    
    @AuraEnabled
    public static String updateKeywords(String prodId, String contJSON) {
        String msg = 'success' ;
        try{
            system.debug('contJSON'+contJSON);
            if(prodId != null){
                product2 prod = new product2();
                prod.id = prodId;
                prod.Keywords__c  = contJSON;
                update prod;
            }else{
                msg = 'Product id is null';
            }
        }catch(Exception ex){
            msg = 'There was an issue updating the details, please contact SFDC system admin';
        }
        return msg;        
    }
    
    /**
* To Check values present or not in Response  
*
*/
    private static boolean isValuePresent(String value){
        if(value != null){
            return value.trim().length() > 0;
        }
        return false;
    } 
    
    @future
    public static void updateLineitems(Map<String,String> lineItmIdUUIDMap){   
        Set<String> lineItmIdSet = new Set<String>();
        List<String> uuidLst = new List<String>();
        List<String> lineItmIdLst = new List<String>();
        List<Bundle_Line_Item__c> lineItmsList = new List<Bundle_Line_Item__c>();
        lineItmIdLst.addAll(lineItmIdSet);
        lineItmIdSet = lineItmIdUUIDMap.keySet();
        uuidLst = lineItmIdUUIDMap.values();
        for(String itmId : lineItmIdLst){
            Bundle_Line_Item__c lItm = new Bundle_Line_Item__c();
            lItm.id = itmId ;
            lItm.uuid__c = lineItmIdUUIDMap.get(lItm.id);
            lineItmsList.add(lItm);
        }
        if(lineItmsList.size() > 0){
            database.update(lineItmsList, false);
        }
    }
    
    /* @future
public static void deleteLineitems(List<String> lineItmsToDelete){ 
List<Bundle_Line_Item__c> lineItmsList = new List<Bundle_Line_Item__c>();

for(String itmId : lineItmsToDelete){
Bundle_Line_Item__c lItm = new Bundle_Line_Item__c();
lItm.id = itmId ;
lineItmsList.add(lItm);
}
if(lineItmsList.size() > 0){
database.delete(lineItmsList, false);
}
}*/
    // This function calls the content curator API to get the content.
    @AuraEnabled
    public static PagedResultDetails callContentCurator() { 
        List<PagedResult> pr = new List<PagedResult>(); 
        PagedResultDetails prDetail = new PagedResultDetails();
        //String contentCuratorApiURI='/v3/products/curated-content';
        //String contentCuratorApiURI='/v4/products';
        String contentCuratorApiURI='/v4/products/?type=creativework';
        Map<String, String> headers = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        String request='{ "type" : "curated-content"}';
        try{           
            
            HTTPResponse res = TF_PlatformExecuter.execute(contentCuratorApiURI,'GET','idtoken', null, headers, false);
            
            if(String.valueOf(res.getStatusCode()).startsWith('2')){
                system.debug('statuscode' + ' ' + res.getStatusCode());
                system.debug(res.getBody());
                String resBody=res.getBody(); 
                system.debug('content curator response '+resBody);
                resBody=resBody.replace('"_id":', '"x_id":');
                resBody=resBody.replace('"@id":', '"id":');
                resBody=resBody.replace('"@type":', '"type":');
                resBody=resBody.replace('"abstract":', '"abstract_Z":');
                resBody=resBody.replace('"__v":', '"x_v":');
                system.debug('filtered json' + resBody);
                
                List<TFContentCuratorDocument> listcontentCuratorDoc = new List<TFContentCuratorDocument>(); 
                List<TFContentCuratorDocument.Contributor> authors = new List<TFContentCuratorDocument.Contributor>();
                List<TFContentCuratorDocument.keywords> keywords = new List<TFContentCuratorDocument.keywords>();
                
                listcontentCuratorDoc = (List<TFContentCuratorDocument>)JSON.deserialize(resBody, List<TFContentCuratorDocument>.class);  
                
                List<PagedResult> contentDataList = new  List<PagedResult>();
                for(TFContentCuratorDocument doc : listcontentCuratorDoc){
                    authors = doc.contributor;
                    keywords = doc.keywords;                    
                    PagedResult contentData = new PagedResult();
                    String author = ''; 
                    String keyword = '';
                    contentData.doi = doc.doi;
                    contentData.Id = doc.id;
                    contentData.publication_date = doc.datePublished;
                    contentData.publisher = doc.publisher;
                    contentData.title = doc.title;
                    contentdata.uuid=doc.id;
                    contentData.type = doc.type;
                    contentData.mediaType=doc.mediaType;
                    
                    
                    for(TFContentCuratorDocument.contributor auth: authors){
                        if(auth.Position==1)
                        {
                            author =  auth.name;
                        }
                        
                    } 
                    if(author.length() > 0){
                        contentData.authors = author;
                    }
                    
                    for(TFContentCuratorDocument.Keywords key: Keywords){                       
                        keyword =  keyword + key.name + ',';                     
                    } 
                    
                    if(keyword.length() > 0){
                        //remove extra comma 
                        keyword=keyword.substring(0,keyword.length()-1);
                        keyword=keyword.toLowerCase();
                        contentData.keywords = keyword;
                    }                    
                    
                    //adding the data into the list
                    contentDataList.add(contentData);
                }              
                pr = contentDataList; 
                prDetail.prList = pr ;
                //
                prDetail.msg = 'Success';            
                return prDetail;  
            }else if(res.getStatusCode() == 404){
                prDetail.prList = null ;
                prDetail.msg = 'NOT_FOUND';              
                return prDetail;   
            }else{
                prDetail.prList = null ;
                prDetail.msg = 'There was an issue getting the details, please try later or contact SFDC system admin';               
                return prDetail;  
                
            }
        }catch(Exception ex){
            system.debug('ExMessage' + ex.getMessage());
            System.debug('Cause: ' + ex.getCause());    
            system.debug('Trace' + ex.getStackTraceString());
            prDetail.prList = null ;
            prDetail.msg = 'There was an issue getting the details, please try later or contact SFDC system admin';
        }
        return prDetail; 
    }
    
    @AuraEnabled
    public static LineitemsToValidate validateContentList(String productId, String position, String processedRecCount, String totalRecCount) {
        TF_GenerateJson.ValidationJson vJ ;
        LineitemsToValidate lItmsToVal = new LineitemsToValidate();
        /*String s3JsonString ;
        String response ;
        String bucketName ;
        String uUIDString ;
        String reqFolder ;
        String reqFilename ;
        String resFolder ;
        String resFilename ;
        String productHubURI = '/v4/products/validation';
        String responseS3Loc ;
        DateTime now = Datetime.now();
        list< Bundle_Line_Item__c> listofLineItems = new list< Bundle_Line_Item__c>();
        vJ = TF_GenerateJson.GenerateValidationJson(productId, now, Integer.valueOf(position), Integer.valueOf(processedRecCount), Integer.valueOf(totalRecCount),listofLineItems);
        
        if(!String.isBlank(vj.jsonString)){ 
            s3JsonString = vj.jsonString;
            
            TF_AWSService awsService = new TF_AWSService();
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            bucketName = (String) orgSpecificProps.get('AWS_S3_Validation_Bucket__c');
            reqFilename = String.valueOf(now.formatGMT('yyyy-MM-dd-HH-mm-ss-SSS')) + '.json' ;
            reqFolder = 'Integrations/Identifier-Identifier-Map/Requests/' + String.valueOf(now.formatGMT('yyyy/MM/dd/HH/mm/ss')) ;
            response = awsService.putUUIDRequestJsonToS3(s3JsonString,reqFilename,bucketName,reqFolder);
            system.debug('putUUIDRequestJsonToS3 '+response);
            if(response != null){
                response = '{"validation" : true, "s3Location": "'+ response +'"}';
                Map<String, String> headers = new Map<String,String>();
                headers.put('Content-Type', 'application/json');
                HttpResponse res = new HttpResponse();
                res = TF_PlatformExecuter.execute(productHubURI,'POST','idtoken', response, headers, false);
                if (res.getStatusCode() == 201 || res.getStatusCode() == 200) { 
                    String responseBody = res.getBody();
                    // String responseBody = '{"s3Location": "s3-euw1-ap-pe-df-product-store-products/Integrations/Identifier-Identifier-Map/Responses/2018/11/23/15/25/2018-11-23-15-25-10-001.json"}';
                    String ststicFolderPath = 'Integrations/validations/Responses/';
                    //https://s3-euw1-ap-pe-df-product-store-products-d.s3.eu-west-1.amazonaws.com/Integrations/Identifier-Identifier-Map/Responses/2018/11/23/15/25/2018-11-23-15-25-10-001.json
                    System.debug('responseBody '+responseBody);
                    JSONParser parser = JSON.createParser(responseBody);
                    while (parser.nextToken() != null) {
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                            String message= parser.getText();
                            parser.nextToken();
                            if(message!= null && message.equalsIgnoreCase('s3Response')) {
                                responseS3Loc = parser.getText();
                            } 
                        }
                    }
                    resFolder = ststicFolderPath + responseS3Loc.substring(responseS3Loc.indexOf(ststicFolderPath) + ststicFolderPath.length(),responseS3Loc.lastIndexOf('/')); 
                    resFilename = responseS3Loc.substringAfterLast('/');
                    System.debug('resFolder'+resFolder);
                    System.debug('resFilename'+resFilename);
                    
                    
                    uUIDString = awsService.getUUIDJsonFromS3(resFilename,resFolder);
                    
                    if(uUIDString != null){
                        TFContentValidationResp contentValResp = new TFContentValidationResp(); 
                        contentValResp = (TFContentValidationResp)JSON.deserialize(uUIDString, TFContentValidationResp.class);
                        system.debug('contentValResp'+contentValResp);
                        uUIDString = null;
                        List<TFContentValidationResp.Responses> responses = contentValResp.responses ; 
                        contentValResp = null;
                        List<TFContentValidationResp.Targets> targets = new List<TFContentValidationResp.Targets>();
                        if(responses.size() > 0 && responses[0].keyType.equalsIgnoreCase('doi')){
                            targets = responses[0].targets ;
                        }
                        
                        List<Bundle_Line_Item__c> errorItmList = new List<Bundle_Line_Item__c>();
                        for(TFContentValidationResp.Targets targ : targets){
                            if(string.isNotBlank(targ.result) && string.isNotBlank(targ.value) && targ.result.equalsIgnoreCase('Failure')){
                                Bundle_Line_Item__c errorItm = new Bundle_Line_Item__c();
                                errorItm.Product_Doi__c = targ.value+'||'+productId ;
                                errorItm.ValidationResult__c = targ.error ;
                                errorItm.Valid__c = 'false' ;
                                errorItmList.add(errorItm);}
                        } 
                        
                        if(errorItmList.size() > 0 && errorItmList.size() < 9000){
                            
                            List<Database.upsertResult> results = database.upsert(errorItmList, Bundle_Line_Item__c.Product_Doi__c, false);
                            
                        }
                        // The following commented code can be used when we get more than 9K invalid data, as of 23-1-19 we are validating 1k records by looping in lightning component.
                        
                        /*else if(errorItmList.size() > 0 && errorItmList.size() > 9000){
integer counter = 1 ;
List<Bundle_Line_Item__c> partErrorItmList = new List<Bundle_Line_Item__c>();

for(Bundle_Line_Item__c lineItm : errorItmList){
partErrorItmList.add(lineItm);
counter ++ ;
if(math.mod(counter, 9000) == 0 && counter == 9000){

List<Database.upsertResult> results = database.upsert(partErrorItmList, Bundle_Line_Item__c.Product_Doi__c, false);

partErrorItmList.clear();
}else if(math.mod(counter, 9000) == 0){
Map<String,String> updLstMap = new Map<String,String>();
for(Bundle_Line_Item__c itm : partErrorItmList){
updLstMap.put(itm.Product_Doi__c, itm.ValidationResult__c);
}
updateLineitems1(updLstMap);//this code is commented, uncomment if this code is used.
updLstMap.clear();
partErrorItmList.clear();

}
}
if(partErrorItmList.size() > 0){
Map<String,String> updLstMap = new Map<String,String>();
for(Bundle_Line_Item__c itm : partErrorItmList){
updLstMap.put(itm.Product_Doi__c, itm.ValidationResult__c);
}
updateLineitems1(updLstMap);//this code is commented, uncomment if this code is used.
updLstMap.clear();
partErrorItmList.clear();                         
}

partErrorItmList.clear();
} // uncommented **
                        
                        lItmsToVal.totalRecords = vJ.totalRecs;
                        lItmsToVal.position = vJ.position;
                        lItmsToVal.processedRecords = vJ.processedRecs;
                        lItmsToVal.moreRecsToProcess = vJ.moreRecsToProcess;
                        lItmsToVal.msg = 'Success';
                    }else{
                        lItmsToVal.msg = 'There was an issue in validating, please try later or contact SFDC system admin';
                    }  
                }else{
                    lItmsToVal.msg = 'There was an issue in validating, please try later or contact SFDC system admin';
                }  
            }else{
                lItmsToVal.msg = 'There was an issue in validating, please try later or contact SFDC system admin';
            }
        }else{
            lItmsToVal.msg = 'There was an issue in validating, please try later or contact SFDC system admin';
        }*/
        			    lItmsToVal.totalRecords = 0;
                        lItmsToVal.position = 0;
                        lItmsToVal.processedRecords = 0;
                        lItmsToVal.moreRecsToProcess = 'false';
                        lItmsToVal.msg = 'Success';
        return lItmsToVal;
    }
    
    
    /*  @future
public static void updateLineitems1(Map<String,String> errorMap){ 
List<Bundle_Line_Item__c> errorItmList = new List<Bundle_Line_Item__c>();
if(errorMap.size() > 0) {
Set<String> extIdSet = new Set<String>();
extIdSet = errorMap.keySet();
for(String extId : extIdSet ){
Bundle_Line_Item__c lItm = new Bundle_Line_Item__c();
lItm.Product_Doi__c = extId ;
lItm.ValidationResult__c = errorMap.get(extId);
lItm.Valid__c = 'false' ;
errorItmList.add(lItm);
}
}
if(errorItmList.size() > 0){
List<Database.upsertResult> results =  database.upsert(errorItmList, Bundle_Line_Item__c.Product_Doi__c, false);
}
} */
    
    @AuraEnabled
    public static LineitemsUUID getUUIDForContentList(String productId, String s3JsonString, Map<String,String> doiIdMap) {
        LineitemsUUID lItmsUUID = new LineitemsUUID();
        String response ;
        String bucketName ;
        String uUIDString ;
        String reqFolder ;
        String reqFilename ;
        String resFolder ;
        String resFilename ;
        String productHubURI = '/v4/products/validation';
        String responseS3Loc ;
        DateTime now = Datetime.now();
        list< Bundle_Line_Item__c> listofLineItems = new list< Bundle_Line_Item__c>();
        lItmsUUID.bundleItmsList = null;
        lItmsUUID.msg = 'Success';
        
        if(!String.isBlank(s3JsonString)){
            
            TF_AWSService awsService = new TF_AWSService();
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            bucketName = (String) orgSpecificProps.get('AWS_S3_Validation_Bucket__c');
            reqFilename = String.valueOf(now.formatGMT('yyyy-MM-dd-HH-mm-ss-SSS')) + '.json' ;
            reqFolder = 'Integrations/Identifier-Identifier-Map/Requests/' + String.valueOf(now.formatGMT('yyyy/MM/dd/HH/mm/ss')) ;
            response = awsService.putUUIDRequestJsonToS3(s3JsonString,reqFilename,bucketName,reqFolder);
            system.debug('putUUIDRequestJsonToS3 '+response);
            if(response != null){
                response = '{"validation" : false, "s3Location": "'+ response +'"}';
                Map<String, String> headers = new Map<String,String>();
                headers.put('Content-Type', 'application/json');
                HttpResponse res = new HttpResponse();
                res = TF_PlatformExecuter.execute(productHubURI,'POST','idtoken', response, headers, false);
                if (res.getStatusCode() == 201 || res.getStatusCode() == 200) { 
                    String responseBody = res.getBody();
                    // String responseBody = '{"s3Location":"https://s3-eu-west-1.amazonaws.com/s3-euw1-ap-pe-df-product-store-products-d/Integrations/Identifier-Identifier-Map/Responses/2019/01/24/14/49/07/2019-01-24-14-49-07-014.json"}';
                    String ststicFolderPath = 'Integrations/Identifier-Identifier-Map/Responses/';
                    //https://s3-euw1-ap-pe-df-product-store-products-d.s3.eu-west-1.amazonaws.com/Integrations/Identifier-Identifier-Map/Responses/2018/11/23/15/25/2018-11-23-15-25-10-001.json
                    System.debug('responseBody------'+responseBody);
                    JSONParser parser = JSON.createParser(responseBody);
                    while (parser.nextToken() != null) {
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                            String message= parser.getText();
                            parser.nextToken();
                            if(message!= null && message.equalsIgnoreCase('s3Location')) {
                                responseS3Loc = parser.getText();
                            } 
                        }
                    } 
                    //https://s3-eu-west-1.amazonaws.com/s3-euw1-ap-pe-df-product-store-products-d/Integrations/Identifier-Identifier-Map/Responses/2019/01/11/14/33/31/2019-01-11-14-33-31-596.json
                    resFolder = ststicFolderPath + responseS3Loc.substring(responseS3Loc.indexOf(ststicFolderPath) + ststicFolderPath.length(),responseS3Loc.lastIndexOf('/')); 
                    resFilename = responseS3Loc.substringAfterLast('/');
                    System.debug('resFolder '+resFolder);
                    System.debug('resFilename '+resFilename);
                    
                    
                    uUIDString = awsService.getUUIDJsonFromS3(resFilename,resFolder);
                    
                    if(uUIDString != null){
                        TFContentValidationResp contentValResp = new TFContentValidationResp(); 
                        contentValResp = (TFContentValidationResp)JSON.deserialize(uUIDString, TFContentValidationResp.class);
                        uUIDString = null;
                        List<TFContentValidationResp.Responses> responses = contentValResp.responses ; 
                        contentValResp = null;
                        List<TFContentValidationResp.Targets> targets = new List<TFContentValidationResp.Targets>();
                        if(responses.size() > 0 && responses[0].keyType.equalsIgnoreCase('doi')){
                            targets = responses[0].targets ;
                        }
                        
                        List<Bundle_Line_Item__c> uUIDItmList = new List<Bundle_Line_Item__c>();
                        for(TFContentValidationResp.Targets targ : targets){
                            if(string.isNotBlank(targ.result) && string.isNotBlank(targ.value) && targ.result.equalsIgnoreCase('Success') && string.isNotBlank(targ.uuid)){
                                Bundle_Line_Item__c uUIDItm = new Bundle_Line_Item__c();
                                uUIDItm.id = doiIdMap.get(targ.value);
                                uUIDItm.uuid__c = targ.uuid ;
                                uUIDItm.Valid__c = 'true' ;
                                uUIDItm.ValidationResult__c = 'valid' ;
                                uUIDItmList.add(uUIDItm);
                            }
                        } 
                        
                        if(uUIDItmList.size() > 0 ){
                            lItmsUUID.bundleItmsList =  uUIDItmList ;
                        }
                    }else{
                        lItmsUUID.msg = 'There was an issue getting the JSON from S3, please try later or contact SFDC system admin';
                    }   
                    
                }else{
                    lItmsUUID.msg = 'There was an issue placing the JSON to S3, please try later or contact SFDC system admin';
                }
            }else{
                lItmsUUID.msg = 'JSON string is blank';
            }
            return lItmsUUID;
        }
        return lItmsUUID;
    }
    
    @AuraEnabled
    public static String deleteSelectedDocs(String parentProductID, String idsToDeleteJSON) {
        List<String> idsList = (List<String>) JSON.deserialize(idsToDeleteJSON, List<String>.class);
        String msg = 'No records to delete';
        Bundle_Line_Item__c lineItems =new Bundle_Line_Item__c();
        list< Bundle_Line_Item__c> listofUpdatedLineItems=new list<Bundle_Line_Item__c>();
        list< Bundle_Line_Item__c> listofLineItems = [SELECT id, name FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :parentProductID and id in :idsList limit 10000];
        
        if(listofLineItems.size() > 0){
            for (Bundle_Line_Item__c bdl:listofLineItems)
            {
                bdl.lineItemStatus__c='IsDelete';
                listofUpdatedLineItems.add(bdl);
                
            }
            msg = 'All selected content records have been deleted from the Collection';
            update listofUpdatedLineItems;
            //database.delete(listofLineItems,false);
            
            return msg;
        }
        
        return msg;
    }
    
    @AuraEnabled
    public static Integer getBundleItmsCount(String bundleID) {
        Integer contentCount = 0 ;
        String hubId ;
        contentCount = [SELECT count() FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c =:bundleID];
        return contentCount ;
    }
    
    public static void deleteUploadedFiles(Id productID) {         
        try
        {
            List<String> ContentDocIds=new List<String>();
            List<ContentDocumentLink> listCdl = new List<ContentDocumentLink>();
            listCdl = [SELECT Id, ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId =: productID];
            for(ContentDocumentLink cdl :listCdl ){
                ContentDocIds.add(cdl.ContentDocumentId);
            }
            // contentDocId=cdl.ContentDocumentId;
            delete listCdl;
            
            //ContentVersion cv = new ContentVersion();
            //cv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId =: contentDocId];
            //delete cv;
            List<ContentDocument> listCd = new List<ContentDocument>();
            for(String strcd :ContentDocIds ){
                ContentDocument cdl =new ContentDocument();
                cdl.id=strcd;
                listCd.add(cdl);
            }
            delete listCd;
            
        }               
        catch(Exception ex)
        {
            System.debug(ex.getMessage());
        }
        
        
    }
    
    public static void deleteBundleLineItemsOnProductDelete(Id productID) {   
        Try{
            Integer count=getBundleItmsCount(productID);
            List<Bundle_Line_Item__c> lineItems = new List<Bundle_Line_Item__c>();
            lineItems = [SELECT id, Product_Bundle_Parent__c, doi__c, Content_ID__c, Journal__c,Publication_Date__c, Title__c, Authors__c, Product_Publisher__c, Open_access__c, ValidationResult__c, Type__c, Source__c FROM 
                         Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :productID]; 
            if(count<9000){
                delete lineItems;
            }
            else if(count>9000)
            {
                String jobId = Database.executeBatch(new TF_Batch_DelBndlLineItmsOnProdDelete(productID), 5000);
                
            }
        }
        catch(Exception Ex){
            System.debug(ex.getMessage());            
        }
    }
    
    @AuraEnabled
    public static String moveSelectedDocs(String parentProductID, String idsToMoveJSON) {
        String msg = 'No records to re order';  
        system.debug('idsToMoveJSON' + idsToMoveJSON);
        try {
            List<String> idsList = (List<String>) JSON.deserialize(idsToMoveJSON, List<String>.class);
            
            integer currentHighestPosition = 0;    
            integer counter=0;
            list< Bundle_Line_Item__c> listofLineItems = [SELECT id, name FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :parentProductID and id in :idsList ORDER BY Content_Position__c limit 10000];
            
            List<AggregateResult> res = [SELECT max(Content_Position__c)maxpostion FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :parentProductID and id in :idsList];
            Decimal highestPosition=(Decimal)res[0].get('maxpostion'); 
            system.debug('highestPosition'+highestPosition);
            if(listofLineItems.size() > 0){
                List<Bundle_Line_Item__c> lineItms = [SELECT Content_Position__c FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :parentProductID ORDER BY Content_Position__c LIMIT 1];
                if(lineItms.size() > 0){
                    currentHighestPosition=Integer.valueOf(lineItms[0].Content_Position__c);
                    system.debug('currentHighestPosition : ' + currentHighestPosition);
                    counter = -   listofLineItems.size()-1 + currentHighestPosition;
                    Product2 prd = [SELECT id, name FROM Product2 WHERE id = :parentProductID];
                    prd.lastBundleItemPosition__c =highestPosition;
                    update prd;
                    // counter=counter + lineItms.size();       
                }
                list< Bundle_Line_Item__c> listofLineItms=new list<Bundle_Line_Item__c>();
                for( Bundle_Line_Item__c lineItem : listofLineItems){
                    Bundle_Line_Item__c lineItm = new Bundle_Line_Item__c();      
                    lineItm.id=lineItem.id;
                    //lineItm.Content_Position__c =currentHighestPosition-(counter);
                    lineItm.Content_Position__c =counter;
                    lineItm.lineItemStatus__c='IsUpdate';
                    listofLineItms.add(lineItm);
                    counter++;
                }
                if(listofLineItms.size() > 0){
                    update listofLineItms;
                    
                    msg = 'All selected content records have been re positioned to the top';  
                }
                
                return msg;
            }
            
            return msg;
        }
        
        
        catch(exception ex){
            system.debug(ex.getMessage());
            msg='There was an issue in processing, please try later or contact SFDC system admin';
            return msg;
        }
        
    }
    
    @AuraEnabled
    public static PagedResultDetails getPartsFromPCM(String bundleID, String position) { 
        List<PagedResult> pr = new List<PagedResult>(); 
        PagedResultDetails prDetail = new PagedResultDetails();
        String offsetValue = position;
        String limitValue = '10';
        Integer nextPstn ;
        Integer prevPstn ;
        String uuid ;
        String contentCuratorApiURI='/v4/products/53f568df-61c8-461a-805b-fe04e5f4b689/parts?offset=0&limit=2&expanded=true';
        Map<String, String> headers = new Map<String,String>();
        Map<String, String> childParentMap = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        String request='{ "type" : "curated-content"}';
        try{           
            Product2 prd  = [SELECT Hub_Id__c FROM Product2 WHERE id = :bundleID]; 
            uuid = prd.Hub_Id__c;
            // uuid = '53f568df-61c8-461a-805b-fe04e5f4b689';
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            contentCuratorApiURI = (String) orgSpecificProps.get('Parts_Api_Url__c');
            contentCuratorApiURI = contentCuratorApiURI + uuid + '/parts?offset=' + offsetValue + '&limit=' + limitValue + '&expanded=true';
            HTTPResponse res = TF_PlatformExecuter.execute(contentCuratorApiURI,'GET','idtoken', null, headers, false);
            
            if(String.valueOf(res.getStatusCode()).startsWith('2')){
                childParentMap.put('Chapter','Book');
                childParentMap.put('ScholarlyArticle','Periodical');
                
                system.debug('statuscode' + ' ' + res.getStatusCode());
                system.debug(res.getBody());
                String resBody=res.getBody(); 
                system.debug('Parts API response '+resBody);
                resBody=resBody.replace('"@id":', '"id":');
                resBody=resBody.replace('"@type":', '"type":'); 
                resBody=resBody.replace('"isPartOf":"UNSDG",', '');
                resBody=resBody.replace('"givenName":null', '"givenName":"null"');
                resBody=resBody.replace('"familyName":null', '"familyName":"null"');
                resBody=resBody.replace('"fullName":null', '"fullName":"null"');
                //Replacing Empty String
                resBody=resBody.replace('"fullName":""', '"fullName":"null"');
                resBody=resBody.replace('"givenName":""', '"givenName":"null"');
                resBody=resBody.replace('"familyName":""', '"familyName":"null"');
                
                
                system.debug('filtered json' + resBody);
                
                TFCollectionPartsDocument partsDoc = new TFCollectionPartsDocument(); 
                List<TFCollectionPartsDocument.Parts> partsDocParts = new List<TFCollectionPartsDocument.Parts>(); 
                List<TFCollectionPartsDocument.IsPartOf> partOf = new List<TFCollectionPartsDocument.IsPartOf>();
                List<TFCollectionPartsDocument.Contributors> contributors = new List<TFCollectionPartsDocument.Contributors>();
                
                partsDoc = (TFCollectionPartsDocument)JSON.deserialize(resBody, TFCollectionPartsDocument.class); 
                partsDocParts = partsDoc.parts ;
                Integer TotalCount=0;
                if(partsDoc.partsCount!=null){                   
                    TotalCount=Integer.valueOf(partsDoc.partsCount);               
                }
                
                List<PagedResult> contentDataList = new  List<PagedResult>();
                for(TFCollectionPartsDocument.Parts doc : partsDocParts){
                    partOf = doc.isPartOf ;
                    contributors = doc.contributors;                    
                    PagedResult contentData = new PagedResult();
                    
                    contentData.doi = doc.doi;
                    contentData.source=doc.curationSource;
                    contentData.Id = doc.id;
                    contentData.publication_date = doc.publicationDate;
                    contentData.publisher = doc.publisherImprint;
                    contentData.title = doc.title;
                    contentdata.uuid=doc.id;
                    contentData.type = doc.type;
                    contentData.Open_access = doc.isAccessibleForFree;
                    
                    system.debug('partOf '+partOf);
                    if(partOf != null){
                        for(TFCollectionPartsDocument.IsPartOf parent : partOf){
                            
                            if(childParentMap.get(doc.type) == parent.type){ 
                                contentData.journal = parent.title ;
                            }
                        } 
                    }
                    
                    if(contributors != null){
                        contentData.authors ='';
                        for(TFCollectionPartsDocument.Contributors author : contributors){
                            if(author.roles != null && author.roles.contains('author')){
                                //contentData.authors = contentData.authors + author.givenName +' '+ author.familyName + ' || ';
                                if(author.givenName!='null' && author.familyName!='null'){
                                    contentData.authors = contentData.authors + author.givenName +' '+ author.familyName + ' || ';
                                }
                                else if(author.givenName=='null' && author.familyName!='null'){
                                    contentData.authors = contentData.authors + '' +' '+ author.familyName + ' || ';
                                    
                                }
                                else if(author.givenName!='null' && author.familyName=='null'){
                                    contentData.authors = contentData.authors + author.givenName +' '+ '' + ' || ';
                                    
                                }
                                else if(author.givenName=='null' && author.familyName=='null' && author.fullname!='null'){
                                    contentData.authors = contentData.authors + author.fullname + ' || ';
                                    
                                }
                                else if(author.givenName=='null' && author.familyName=='null' && author.fullname=='null'){
                                    contentData.authors = contentData.authors + '';
                                    
                                }
                                
                            }
                        }
                        contentData.authors = contentData.authors != null ? contentData.authors.left(contentData.authors.length() - 4) : null ;
                    }
                    contentData.authors = contentData.authors;
                    
                    contentDataList.add(contentData);
                }              
                pr = contentDataList; 
                prDetail.prList = pr ;
                prDetail.total = TotalCount;
                prDetail.msg = 'Success';
                system.debug('prDetail '+prDetail);
                return prDetail;  
            }else if(res.getStatusCode() == 404){
                prDetail.prList = null ;
                prDetail.msg = 'NOT_FOUND';              
                return prDetail;   
            }else{
                prDetail.prList = null ;
                prDetail.msg = 'There was an issue getting the details, please try later or contact SFDC system admin';               
                return prDetail;   
                
            }
        }catch(Exception ex){
            system.debug('ExMessage' + ex.getMessage());
            System.debug('Cause ' + ex.getCause());    
            system.debug('Trace' + ex.getStackTraceString());
            prDetail.prList = null ;
            prDetail.msg = 'There was an issue getting the details, please try later or contact SFDC system admin';
        }
        return prDetail; 
    }
    
    
    @AuraEnabled
    public static PagedResultDetails getPartsFromPCMNewDataModel(String bundleID, String position, String productType) { 
        List<PagedResult> pr = new List<PagedResult>(); 
        PagedResultDetails prDetail = new PagedResultDetails();
        String offsetValue = position;
        String limitValue = '500';
        Integer nextPstn ;
        Integer prevPstn ; 
        String uuid ;
        String newPartsApiURI='/v4/products/53f568df-61c8-461a-805b-fe04e5f4b689/parts?offset=0&limit=500&expanded=true';
        Map<String, String> headers = new Map<String,String>();
        Map<String, String> childParentMap = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        String request='{"apiVersion" : "4.0.1",  "responseGroup":"large",  "offset" : 0,  "limit" : 100}';
        
        try{           
            Product2 prd  = [SELECT Hub_Id__c FROM Product2 WHERE id = :bundleID]; 
            uuid = prd.Hub_Id__c;
            // uuid = '53f568df-61c8-461a-805b-fe04e5f4b689';
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            newPartsApiURI = (String) orgSpecificProps.get('Parts_Api_Url__c');
            newPartsApiURI = newPartsApiURI + uuid + '/parts?apiVersion=4.0.1&responseGroup=medium&type=' + productType + '&offset=' + offsetValue + '&limit=' + limitValue;
            HTTPResponse res = TF_PlatformExecuter.execute(newPartsApiURI,'GET','idtoken', null, headers, false);
            
            if(String.valueOf(res.getStatusCode()).startsWith('2')){
                childParentMap.put('Chapter','Book');
                childParentMap.put('ScholarlyArticle','Periodical');
                
                system.debug('statuscode' + ' ' + res.getStatusCode());
                system.debug(res.getBody());
                String resBody=res.getBody(); 
                system.debug('Parts API response '+resBody);
                resBody=resBody.replace('"_id":', '"id":');
                resBody=resBody.replace('"@type":', '"type":'); 
                resBody=resBody.replace('"isPartOf":"UNSDG",', '');
                //for Author name null issue
                resBody=resBody.replace('"fullName":null', '"fullName":"null"');
                //Replacing Empty String
                resBody=resBody.replace('"fullName":""', '"fullName":"null"');
                
                
                system.debug('filtered json' + resBody);
                
                //TFCollectionPartsDocNewModel partsDoc = new TFCollectionPartsDocNewModel(); 
                List<TFCollectionPartsDocNewModel> partsDoc = new List<TFCollectionPartsDocNewModel>();
                List<TFCollectionPartsDocNewModel.Contributors> contributors = new List<TFCollectionPartsDocNewModel.Contributors>();
                TFCollectionPartsDocNewModel.Book books = new TFCollectionPartsDocNewModel.Book();
                TFCollectionPartsDocNewModel.creativeWork creativeWork = new TFCollectionPartsDocNewModel.creativeWork();
                TFCollectionPartsDocNewModel.scholarlyArticle scholarlyArticle = new TFCollectionPartsDocNewModel.scholarlyArticle();
                TFCollectionPartsDocNewModel.chapter chapter = new TFCollectionPartsDocNewModel.chapter();
                TFCollectionPartsDocNewModel.collection collection = new TFCollectionPartsDocNewModel.collection();
                TFCollectionPartsDocNewModel.identifiers identifiers = new TFCollectionPartsDocNewModel.identifiers();
                
                //partsDoc = (TFCollectionPartsDocNewModel)JSON.deserialize(resBody, TFCollectionPartsDocNewModel.class); 
                partsDoc=(List<TFCollectionPartsDocNewModel>)JSON.deserialize(resBody, List<TFCollectionPartsDocNewModel>.class);
                
                List<PagedResult> contentDataList = new  List<PagedResult>();
                for(TFCollectionPartsDocNewModel doc : partsDoc) {
                    contributors = doc.contributors; 
                    identifiers=doc.identifiers;
                    books=doc.book;
                    creativeWork=doc.creativeWork;
                    scholarlyArticle=doc.scholarlyArticle;
                    chapter=doc.chapter;
                    collection=doc.collection;
                    
                    
                    PagedResult contentData = new PagedResult();
                    //contentData.doi=doc.doi;
                    contentData.id=doc.id;    
                    contentData.type = doc.type;
                    contentData.mediaType=doc.format;
                    contentData.Open_access=doc.isFree;
                    contentData.title = doc.title;
                    contentdata.uuid=doc.id;
                    contentData.source='PCM';  
                    if(contributors != null){
                        contentData.authors ='';
                        for(TFCollectionPartsDocNewModel.Contributors author : contributors){
                            if(author.roles != null && (author.roles.contains('author')|| author.roles.contains('Author'))){
                                String authorFullName=String.ValueOf(author.fullName);   
                                if(authorFullName!='null'){
                                    contentData.authors = contentData.authors + authorFullName + ' || ';
                                    
                                }
                            }
                        }
                        contentData.authors = contentData.authors != null ? contentData.authors.left(contentData.authors.length() - 4) : null ;
                    }
                    if(identifiers != null){                          
                        contentData.doi=identifiers.doi;                        
                    }
                    if(books != null){                          
                        contentData.publisher=books.publisherImprint;   
                        contentData.publication_date=books.publicationDate;
                    }
                    
                    if(collection != null){                          
                        contentData.publisher=collection.publisherImprint;   
                        contentData.publication_date=collection.publicationDate;
                        contentData.doi=contentdata.uuid;
                    }
                    
                    if(creativeWork != null){                          
                        contentData.publisher=creativeWork.publisherImprint;   
                        contentData.publication_date=creativeWork.publicationDate;
                        contentData.mediaType=creativeWork.format;
                    }
                    
                    if(scholarlyArticle != null){                          
                        contentData.publisher=scholarlyArticle.publisherImprint;   
                        contentData.publication_date=scholarlyArticle.publicationDate;
                    }
                    
                    if(chapter != null){                          
                        contentData.publisher=chapter.publisherImprint;   
                        contentData.publication_date=chapter.publicationDate;
                    }
                    
                    contentData.authors = contentData.authors;  
                    contentDataList.add(contentData);
                }
                pr = contentDataList; 
                prDetail.prList = pr ;
                // prDetail.total = TotalCount;
                prDetail.msg = 'Success';
                system.debug('prDetail '+prDetail);
                return prDetail;  
            }else if(res.getStatusCode() == 404){
                prDetail.prList = null ;
                prDetail.msg = 'NOT_FOUND';              
                return prDetail;   
            }else{
                prDetail.prList = null ;
                prDetail.msg = 'There was an issue getting the details, please try later or contact SFDC system admin';               
                return prDetail;   
                
            }
        }
        
        catch(Exception ex){
            system.debug('ExMessage' + ex.getMessage());
            System.debug('Cause ' + ex.getCause());    
            system.debug('Trace' + ex.getStackTraceString());
            prDetail.prList = null ;
            prDetail.msg = 'There was an issue getting the details, please try later or contact SFDC system admin';
        }
        return prDetail; 
    }
    
    @AuraEnabled
    public static PagedResultDetails getProductFromPCMById(String bundleID, String productType){
        List<PagedResult> pr = new List<PagedResult>(); 
        PagedResultDetails prDetail = new PagedResultDetails();
        Integer TotalCount=0; 
        String uuid ;
        String newPartsApiURI='/v4/products/53f568df-61c8-461a-805b-fe04e5f4b689/parts?offset=0&limit=2&expanded=true';
        Map<String, String> headers = new Map<String,String>();
        Map<String, String> childParentMap = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        String request='{"apiVersion" : "4.0.1",  "responseGroup":"large"}';
        
        try{           
            Product2 prd  = [SELECT Hub_Id__c FROM Product2 WHERE id = :bundleID]; 
            uuid = prd.Hub_Id__c;
            
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            newPartsApiURI = (String) orgSpecificProps.get('Parts_Api_Url__c');
            newPartsApiURI = newPartsApiURI + uuid;
            
            HTTPResponse res = TF_PlatformExecuter.execute(newPartsApiURI,'GET','idtoken', null, headers, false);
            
            system.debug('newPartsApiURI' + newPartsApiURI);
            system.debug('getStatusCode' +res.getStatusCode());
            System.debug('get product API Response '+ res.getbody());
            
            if(String.valueOf(res.getStatusCode()).startsWith('2')){
                childParentMap.put('Chapter','Book');
                childParentMap.put('ScholarlyArticle','Periodical');
                
                system.debug('statuscode' + ' ' + res.getStatusCode());
                system.debug(res.getBody());
                String resBody=res.getBody(); 
                system.debug('Parts API response '+resBody);
                resBody=resBody.replace('"@id":', '"id":');
                resBody=resBody.replace('"@type":', '"type":'); 
                resBody=resBody.replace('"isPartOf":"UNSDG",', '');
                resBody=resBody.replace('"givenName":null', '"givenName":"null"');
                resBody=resBody.replace('"familyName":null', '"familyName":"null"');
                resBody=resBody.replace('"fullName":null', '"fullName":"null"');
                //Replacing Empty String
                resBody=resBody.replace('"fullName":""', '"fullName":"null"');
                resBody=resBody.replace('"givenName":""', '"givenName":"null"');
                resBody=resBody.replace('"familyName":""', '"familyName":"null"');
                
                
                system.debug('filtered json' + resBody);
                
                TFGetProductFromPCMById partsDoc = new TFGetProductFromPCMById(); 
                List<TFGetProductFromPCMById.partsCount> partsCount = new List<TFGetProductFromPCMById.partsCount>(); 
                
                partsDoc = (TFGetProductFromPCMById)JSON.deserialize(resBody, TFGetProductFromPCMById.class); 
                partsCount=partsDoc.partsCount;
                
                List<PagedResult> contentDataList = new  List<PagedResult>();
                
                if(partsCount != null){                   
                    for(TFGetProductFromPCMById.PartsCount partDoc : partsCount){
                        PagedResult contentData = new PagedResult();
                        contentData.type=partDoc.type;
                        contentData.count=partDoc.count;
                        TotalCount=TotalCount+partDoc.count;
                        
                        contentDataList.add(contentData);
                    }
                }
                
                
                pr = contentDataList; 
                prDetail.prList = pr ;
                prDetail.total = TotalCount;
                if(productType==null){
                    prDetail.productTypeReturned=contentDataList[0].type;
                }
                else{
                    prDetail.productTypeReturned=productType;
                }
                prDetail.msg = 'Success';
                system.debug('prDetail   '+prDetail);
                return prDetail;  
            }else if(res.getStatusCode() == 404){
                system.debug('code '+res.getStatusCode());
                prDetail.prList = null ;
                prDetail.msg = 'NOT_FOUND';              
                return prDetail;   
            }else{
                prDetail.prList = null ;
                prDetail.msg = 'There was an issue getting the details, please try later or contact SFDC system admin';               
                return prDetail;   
                
            }
        }
        
        catch(Exception ex){
            system.debug('ExMessage' + ex.getMessage());
            System.debug('Cause ' + ex.getCause());    
            system.debug('Trace' + ex.getStackTraceString());
            prDetail.prList = null ;
            prDetail.msg = 'There was an issue getting the details, please try later or contact SFDC system admin';
        }
        return prDetail;
        
    } 
    
    @AuraEnabled
    public static PagedResultDetails getProductsFromPCMById(String bundleID, String productType){
        List<PagedResult> pr = new List<PagedResult>(); 
        PagedResultDetails prDetail = new PagedResultDetails();
        Integer TotalCount=0; 
        String uuid ;
        String newPartsApiURI='/v4/products/53f568df-61c8-461a-805b-fe04e5f4b689/parts?offset=0&limit=2&expanded=true';
        Map<String, String> headers = new Map<String,String>();
        Map<String, String> childParentMap = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        String request='{"apiVersion" : "4.0.1",  "responseGroup":"large"}';
        
        try{           
            Product2 prd  = [SELECT Hub_Id__c FROM Product2 WHERE id = :bundleID]; 
            uuid = prd.Hub_Id__c;
            
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            newPartsApiURI = (String) orgSpecificProps.get('Parts_Api_Url__c');
            newPartsApiURI = newPartsApiURI + uuid +'?apiVersion=4.0.1&responseGroup=large';
            
            HTTPResponse res = TF_PlatformExecuter.execute(newPartsApiURI,'GET','idtoken', null, headers, false);
            
            system.debug('newPartsApiURI  ' + newPartsApiURI);
            system.debug('getStatusCode  ' +res.getStatusCode());
            System.debug('get product API Response  '+ res.getbody());
            
            if(String.valueOf(res.getStatusCode()).startsWith('2')){
                childParentMap.put('Chapter','Book');
                childParentMap.put('ScholarlyArticle','Periodical');
                system.debug('Inside GetProductNewAPI');
                system.debug('statuscode' + ' ' + res.getStatusCode());
                system.debug(res.getBody());
                String resBody=res.getBody(); 
                system.debug('Parts API response '+resBody);
                resBody=resBody.replace('"@id":', '"id":');
                resBody=resBody.replace('"type":', '"type_Z":');              
                
                
                system.debug('filtered json' + resBody);
                
                TFGetProductsFromPCMById partsDoc = new TFGetProductsFromPCMById(); 
                TFGetProductsFromPCMById.Product Product=new TFGetProductsFromPCMById.Product();
                List<TFGetProductsFromPCMById.Counts> Counts = new List<TFGetProductsFromPCMById.Counts>(); 
                TFGetProductsFromPCMById.Collection Collection=new TFGetProductsFromPCMById.Collection();
                partsDoc = (TFGetProductsFromPCMById)JSON.deserialize(resBody, TFGetProductsFromPCMById.class); 
                //Counts=partsDoc.Counts;
                Product=partsDoc.Product;
                Collection=Product.Collection;
                Counts=Collection.Counts;
                List<PagedResult> contentDataList = new  List<PagedResult>();
                
                if(Counts != null){                   
                    for(TFGetProductsFromPCMById.Counts partDoc : Counts){
                        PagedResult contentData = new PagedResult();
                        contentData.type=partDoc.type_Z;
                        contentData.count=partDoc.count;
                        TotalCount=TotalCount+partDoc.count;                        
                        contentDataList.add(contentData);
                    }
                }
                
                
                pr = contentDataList; 
                prDetail.prList = pr ;
                prDetail.total = TotalCount;
                if(productType==null){
                    prDetail.productTypeReturned=contentDataList[0].type;
                    system.debug('productTypeReturned' + contentDataList[0].type);
                }
                else{
                    prDetail.productTypeReturned=productType;
                    system.debug('productType' + productType);
                }
                prDetail.msg = 'Success';
                system.debug('prDetail  '+prDetail);
                return prDetail;  
            }else if(res.getStatusCode() == 404){
                system.debug('code  '+res.getStatusCode());
                prDetail.prList = null ;
                prDetail.msg = 'NOT_FOUND';              
                return prDetail;   
            }else{
                prDetail.prList = null ;
                prDetail.msg = 'There was an issue getting the details, please try later or contact SFDC system admin';               
                return prDetail;   
                
            }
        }
        
        catch(Exception ex){
            system.debug('ExMessage' + ex.getMessage());
            System.debug('Cause ' + ex.getCause());    
            system.debug('Trace' + ex.getStackTraceString());
            prDetail.prList = null ;
            prDetail.msg = 'There was an issue getting the details, please try later or contact SFDC system admin';
        }
        return prDetail;
        
    }
    
    @AuraEnabled
    public static String copyBundleLineItemsFromPartsAPI(String OriginalbundleId, String clonedProductId) {
        Integer totalPartsCount=0;
        Integer totalPartsToProcess=0;
        Integer numberOfFutureMethods=0;
        Integer startPoint=0;
        Integer endPoint=0;
        Product2 prod  = [SELECT id,Product_Type_Author_Facing__c FROM Product2 WHERE id = :clonedProductId];
        
        if(prod.Product_Type_Author_Facing__c=='Manual Curation'){
            PagedResultDetails prd = new PagedResultDetails();
            prd= getProductsFromPCMById(OriginalbundleId,'');
            totalPartsCount=prd.total;
            system.debug('totalPartsCount  '+ totalPartsCount);
            
            // calculating number of future calls required..
             numberOfFutureMethods=getTotalAverageCount(totalPartsCount,5000);
             system.debug('numberOfFutureMethods  ' + numberOfFutureMethods);
           
             startpoint=0;
            //List<Integer> countList=new List<Integer>{0,0};
            List<Integer> countList=new List<Integer>();
            if(totalPartsCount>0){
          countList=divideNumberIntoNParts(totalPartsCount,5000);
             system.debug('countListzfull '  +countList);
            }
            for (Integer i = 0; i <numberOfFutureMethods; i++) {
                system.debug('startpoint  ' + startpoint);
                system.debug('countList ' + countList[i]);
                if(i!=numberOfFutureMethods-1){
                    callParts(OriginalbundleId,clonedProductId,countList[i],false,startPoint,endPoint);
                }else if(i==numberOfFutureMethods-1){
                    system.debug('i value calling send email method' + i);
                     callParts(OriginalbundleId,clonedProductId,countList[i],true,startPoint,endPoint);
                }
               
                startpoint=startpoint+5000;
                
            }
            //sendMailForClonedRequest(clonedProductId);
                Return 'Success';
            
        }else if(prod.Product_Type_Author_Facing__c=='Rule based'){
            sendMailForClonedRequest(clonedProductId);
            Return 'Success';
        }
        Return 'Success';      
    }
    
    
    @Future(callout=true)
    public static void callParts(String orgPrdId,String clonedPrdId,Integer totalPartsCount, boolean isLastIteration, Integer startPoint, Integer endPoint){
        String newPartsApiURI;
        Integer offsetValue = startPoint;
        Integer limitValue = 500; 
      //  Integer maxLimit=500;
        String uuid ;
        Integer i=0;
        Integer numberOfApiCalls=0;
        
        numberOfApiCalls=getTotalAverageCount(totalPartsCount,500);
        
        List<PagedResult> pr = new List<PagedResult>(); 
        List<PagedResult> contentDataList = new  List<PagedResult>();
        
        PagedResultDetails prDetail = new PagedResultDetails();
        Map<String, String> headers = new Map<String,String>();
        Map<String, String> childParentMap = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        
        for(i=0; i<numberOfApiCalls;i++){
            try{
                String bundleID=clonedPrdId;
                Product2 prd  = [SELECT Hub_Id__c FROM Product2 WHERE id = :orgPrdId]; 
                uuid = prd.Hub_Id__c;
                system.debug('uuid'+uuid+' '+ orgPrdId);
                TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
                newPartsApiURI = (String) orgSpecificProps.get('Parts_Api_Url__c');
                newPartsApiURI = newPartsApiURI + uuid + '/parts?apiVersion=4.0.1&responseGroup=medium&offset=' + offsetValue + '&limit=' + limitValue;
                system.debug('newPartsApiURI '+newPartsApiURI);
                HTTPResponse res = TF_PlatformExecuter.execute(newPartsApiURI,'GET','idtoken', null, headers, false);
                system.debug('response code for parts API' + res.getStatusCode());
                
                if(String.valueOf(res.getStatusCode()).startsWith('2')){
                    childParentMap.put('Chapter','Book');
                    childParentMap.put('ScholarlyArticle','Periodical');
                    
                    system.debug('statuscode' + ' ' + res.getStatusCode());
                    system.debug(res.getBody());
                    String resBody=res.getBody(); 
                    system.debug('Parts API response '+resBody);
                    resBody=resBody.replace('"_id":', '"id":');
                    resBody=resBody.replace('"@type":', '"type":'); 
                    resBody=resBody.replace('"isPartOf":"UNSDG",', '');
                    //for Author name null issue
                    resBody=resBody.replace('"fullName":null', '"fullName":"null"');
                    //Replacing Empty String
                    resBody=resBody.replace('"fullName":""', '"fullName":"null"');
                    
                    
                    system.debug('filtered json' + resBody);
                    
                    //TFCollectionPartsDocNewModel partsDoc = new TFCollectionPartsDocNewModel(); 
                    List<TFCollectionPartsDocNewModel> partsDoc = new List<TFCollectionPartsDocNewModel>();
                    List<TFCollectionPartsDocNewModel.Contributors> contributors = new List<TFCollectionPartsDocNewModel.Contributors>();
                    TFCollectionPartsDocNewModel.Book books = new TFCollectionPartsDocNewModel.Book();
                    TFCollectionPartsDocNewModel.creativeWork creativeWork = new TFCollectionPartsDocNewModel.creativeWork();
                    TFCollectionPartsDocNewModel.scholarlyArticle scholarlyArticle = new TFCollectionPartsDocNewModel.scholarlyArticle();
                    TFCollectionPartsDocNewModel.chapter chapter = new TFCollectionPartsDocNewModel.chapter();
                    TFCollectionPartsDocNewModel.collection collection = new TFCollectionPartsDocNewModel.collection();
                    TFCollectionPartsDocNewModel.identifiers identifiers = new TFCollectionPartsDocNewModel.identifiers();
                    
                    //partsDoc = (TFCollectionPartsDocNewModel)JSON.deserialize(resBody, TFCollectionPartsDocNewModel.class); 
                    partsDoc=(List<TFCollectionPartsDocNewModel>)JSON.deserialize(resBody, List<TFCollectionPartsDocNewModel>.class);
                    
                    
                    for(TFCollectionPartsDocNewModel doc : partsDoc) {
                        contributors = doc.contributors; 
                        identifiers=doc.identifiers;
                        books=doc.book;
                        creativeWork=doc.creativeWork;
                        scholarlyArticle=doc.scholarlyArticle;
                        chapter=doc.chapter;
                        collection=doc.collection;
                        
                        
                        PagedResult contentData = new PagedResult();
                        //contentData.doi=doc.doi;
                        contentData.id=doc.id;    
                        contentData.type = doc.type;
                        contentData.mediaType=doc.format;
                        contentData.Open_access=doc.isFree;
                        contentData.title = doc.title;
                        contentdata.uuid=doc.id;
                        contentData.source='PCM'; 
                        contentData.content_Position=doc.position;
                        if(contributors != null){
                            contentData.authors ='';
                            for(TFCollectionPartsDocNewModel.Contributors author : contributors){
                                if(author.roles != null && (author.roles.contains('author')|| author.roles.contains('Author'))){
                                    String authorFullName=String.ValueOf(author.fullName);   
                                    if(authorFullName!='null'){
                                        contentData.authors = contentData.authors + authorFullName + ' || ';
                                        
                                    }
                                }
                            }
                            contentData.authors = contentData.authors != null ? contentData.authors.left(contentData.authors.length() - 4) : null ;
                        }
                        if(identifiers != null){                          
                            contentData.doi=identifiers.doi;                        
                        }
                        if(books != null){                          
                            contentData.publisher=books.publisherImprint;   
                            contentData.publication_date=books.publicationDate;
                            contentData.mediaType=books.format;
                        }
                        
                        if(collection != null){                          
                            contentData.publisher=collection.publisherImprint;   
                            contentData.publication_date=collection.publicationDate;
                            contentData.doi=contentdata.uuid;
                        }
                        
                        if(creativeWork != null){                          
                            contentData.publisher=creativeWork.publisherImprint;   
                            contentData.publication_date=creativeWork.publicationDate;
                            contentData.mediaType=creativeWork.format;
                        }
                        
                        if(scholarlyArticle != null){                          
                            contentData.publisher=scholarlyArticle.publisherImprint;   
                            contentData.publication_date=scholarlyArticle.publicationDate;
                        }
                        
                        if(chapter != null){                          
                            contentData.publisher=chapter.publisherImprint;   
                            contentData.publication_date=chapter.publicationDate;
                        }
                        
                        contentData.authors = contentData.authors;  
                        contentDataList.add(contentData);
                    }
                    pr = contentDataList; 
                    prDetail.prList = pr ;
                    // prDetail.total = TotalCount; 
                    prDetail.msg = 'Success';
                    system.debug('prDetail '+prDetail);
                    
                    
                    //return prDetail;  
                }else if(res.getStatusCode() == 404){
                    prDetail.prList = null ;
                    prDetail.msg = 'NOT_FOUND'; 
                    
                    //return prDetail;   
                }else{
                    prDetail.prList = null ;
                    prDetail.msg = 'There was an issue getting the details, please try later or contact SFDC system admin';               
                    //return prDetail;   
                    
                }
            }
            catch(Exception ex){
                system.debug('ExMessage' + ex.getMessage());
                System.debug('Cause ' + ex.getCause());    
                system.debug('Trace' + ex.getStackTraceString());
                prDetail.prList = null ;
                prDetail.msg = 'There was an issue getting the details, please try later or contact SFDC system admin';
            }
            offsetValue=offsetValue+500;  
        }// end of loop
        
        //adding parts to SF
        AddPartsToSF(contentDataList,clonedPrdId);
        if(isLastIteration==true){
             sendMailForClonedRequest(clonedPrdId);
        }
    }
 
    
    
    @AuraEnabled
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
    
    @AuraEnabled
    public static List<Integer> divideNumberIntoNParts(Integer numb, Integer divide){
        //integer numb = 8500;
        //integer divide = 5000;
        integer noOfParts = numb / divide;
        integer remaining = math.mod(numb,divide);
        List<integer> parts = new List<integer>();
        for (integer i = 0; i < noOfParts; i++){
            parts.Add(divide);
        }
        parts.Add(remaining);
        system.debug(parts);
        return parts;

    }
    
    @AuraEnabled
    public static void AddPartsToSF(List<PagedResult> contentDataList,String clonedPrdId){
        try{
            //Adding records into bundle Line Items
            String bundleID=clonedPrdId;
            list< Bundle_Line_Item__c> listofLineItems = new list< Bundle_Line_Item__c>(); 
            
            //integer position = 1;
            String productDoi;
            for(TF_ProcessUnsiloresponse.PagedResult contentData:contentDataList){
                Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
                lineItem.Product_Bundle_Parent__c = bundleID;
                productDoi = contentData.doi +'||'+ bundleID;
                lineitem.Journal__c = contentData.title;
                lineitem.Authors__c = contentData.authors;
                lineitem.Publisher__c=contentData.publisher;
                lineitem.doi__c = contentData.doi;
                lineitem.Publication_Date__c = contentData.publication_date != null ? Date.valueOf(contentData.publication_date) : null;
                lineItem.Product_Doi__c =  productDoi;
                lineItem.Type__c = contentData.type;
                lineItem.Valid__c = contentData.id != null && contentData.id != '' ? 'true' : 'false';
                lineitem.uuid__c = contentData.id;
                lineItem.Source__c = 'PCM';
                lineItem.IsIncluded__c=true;
                lineItem.PriceUSD__c = contentData.priceBYOUSD;
                lineItem.PriceGBP__c = contentData.priceBYOGBP;
                lineItem.mediaType__c=contentData.mediaType;
                lineItem.Open_access__c=contentData.Open_access;
                lineItem.lineItemStatus__c ='IsFromPcm'; 
                lineItem.IsLineItemFromPcm__c  =true;
                
                
                if(contentData.type=='Collection'){                
                    lineItem.Product_Doi__c = contentData.id +'||'+ bundleId;
                    lineitem.doi__c = contentData.id;
                }
                
                
                lineItem.Content_Position__c  = contentData.content_Position;
                listofLineItems.add(lineItem); 
            }//end of loop
            if(listofLineItems != null && listofLineItems.size() > 0){
                Database.UpsertResult[] srList = Database.upsert(listofLineItems,bundle_line_item__c.Product_Doi__c,false);
                system.debug('database updated');
            }
        }
        Catch(Exception ex){
            system.debug('ExMessage' + ex.getMessage());
            System.debug('Cause ' + ex.getCause());    
            system.debug('Trace' + ex.getStackTraceString());
        }
    }
    
    @AuraEnabled
    public static ProductCloneResult getClonedProduct(String bundleID){
        ProductCloneResult pcr = new ProductCloneResult();
        pcr.position = 0 ;
        Savepoint sp = Database.setSavepoint(); 
        Try{             
            Product2 originalProduct = [select name,businessId__c, IsBusinessIdValidated__c,Hub_Id__c,alternateName__c,version__c,issn__c,Product_Publisher__c,Applicable_Channels__c,Applicable_Customer_Types__c,inLanguage__c,Description,
                                        doi__c,ean__c,copyrightyear__c,Lead_Author_Editor__c,Applicable_License_Types__c,Contributors__c,Keywords__c,Family,Sales_Channels__c,Product_Type_Author_Facing__c,Dynamic_Collection_Criteria__c,
                                        Collection_Valid_From__c,Collection_Valid_To__c,Collection_updatedFrom__c,Collection_updatedTo__c,Netbase_Classifications__c,Subject_Classifications__c,Product_Category__c,
                                        Collection_Banner_Image_S3_location__c,Collection_Cover_Image_S3_location__c ,Collection_Banner_Image_Size__c ,Collection_Cover_Image_Size__C,Abstract__c,Product_Type__c,Collection_Subject_Area__c,
                                        Collection_Auto_Rollover__c,DiscountedPercentage__c,Backlist__c, Is_collection_free__c,IsTitleValidated__c   FROM Product2 WHERE id = :bundleID limit 1];
            
            Product2 clonedProduct = originalProduct.clone(false, true, false, false);
            clonedProduct.version__c=getProductVersion(originalProduct.version__c);
            clonedProduct.originalProductId__c=String.valueof(bundleID);
            clonedProduct.Status__c = 'Draft';
            clonedProduct.RecordTypeId=getRecordTypeId('Product2','T&F - Collection');            
            insert clonedProduct;
            pcr.productId =  clonedProduct.id ;  
            system.debug('ClonedProductId' + pcr.productId);
            pcr.totalRecords = [select count() from bundle_line_item__c where Product_Bundle_Parent__c= :bundleID];            
            List<Bundle_Line_Item__c> lineItems = [SELECT Content_Position__c FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :bundleID ORDER BY Content_Position__c LIMIT 1];
            
            if(lineItems.size() > 0){
                pcr.position = Integer.valueOf(lineItems[0].Content_Position__c) -1;
            }
            
            //cloning the base prices of the parent product 
            List <PricebookEntry> pbe = getPriceBookEntry(bundleID);
            List <PricebookEntry> disPbe = getDiscountedPriceBookEntry(bundleID);
            //Decimal UnitPriceInGBP=0.00;
            //Decimal UnitPriceInUSD=0.00;
            Decimal UnitPriceInGBP;
            Decimal UnitPriceInUSD;
            Decimal discountedPriceInGBP;
            Decimal discountedPriceInUSD;
            
            for(PricebookEntry pb: pbe){
                system.debug('UnitPrice ' + pb.UnitPrice);
                if(pb.CurrencyIsoCode=='GBP') {               
                    UnitPriceInGBP=pb.UnitPrice;
                }
                else if(pb.CurrencyIsoCode=='USD'){                
                    UnitPriceInUSD=pb.UnitPrice;
                }
            }
            
            system.debug('UnitPriceGBP ' + UnitPriceInGBP);
            system.debug('UnitPriceUSD ' + UnitPriceInUSD);
            for(PricebookEntry pb: disPbe){
                if(pb.CurrencyIsoCode=='GBP') {               
                    discountedPriceInGBP=pb.UnitPrice;
                }
                else if(pb.CurrencyIsoCode=='USD'){                
                    discountedPriceInUSD=pb.UnitPrice;
                }
            }
            if(UnitPriceInGBP!=null && UnitPriceInUSD!=null){
                addPriceBookEntry(clonedProduct.id, UnitPriceInGBP, UnitPriceInUSD,discountedPriceInGBP,discountedPriceInUSD);
            }
            
            //cloning Uploaded Image
            copyUploadedImageToClonedProd(pcr.productId);
            return pcr ;
            
        }  Catch(Exception ex){ 
            Database.rollback(sp); 
            system.debug('error in getClonedProduct' + ' ' + ex.getmessage() + ex.getLineNumber() + ex.getCause());
            Return null;
        } 
    }
    
    // for PriceBookEntry
    @AuraEnabled
    public static String addPriceBookEntry(String parentProductID, Decimal unitPriceInGBP, Decimal unitPriceInUSD, Decimal discountedPriceInGBP,Decimal discountedPriceInUSD) {   
        String msg='';
        // List<Pricebook2> priceBookId =[select Id from Pricebook2 where isStandard=true];
        //Id standardPriceBookId = priceBookId[0].id;
        List<Pricebook2> TandfpriceBookId;
        Id tfPricebookId;
        
        List<Pricebook2> priceBookId;
        Id standardPriceBookId;        
        
        List<Pricebook2> TandfEbookpriceBookId;
        Id tfEbookPricebookId;
        
        if (test.isrunningtest()) {       
            standardPriceBookId=Test.getStandardPricebookId();
            tfPricebookId='01s0Y00000832dDQAQ';
            tfEbookPricebookId='01s0Y00000832cjQAA';          
        }
        else {       
            priceBookId=[select Id from Pricebook2 where isStandard=true];
            standardPriceBookId= priceBookId[0].id;
            
            TandfpriceBookId =[select Id from Pricebook2 where name='T&F Pricebook'];
            tfPricebookId = TandfpriceBookId[0].id;
            
            TandfEbookpriceBookId =[select Id from Pricebook2 where name='T&F - eBooks Pricebook'];
            tfEbookPricebookId = TandfEbookpriceBookId[0].id;            
            
        }        
        
        PricebookEntry pbeInGBP= insertPricebookEntry(parentProductID,'GBP',standardPriceBookId,unitPriceInGBP);
        PricebookEntry pbeInUSD= insertPricebookEntry(parentProductID,'USD',standardPriceBookId,unitPriceInUSD);
        if(! test.isrunningtest()){
            PricebookEntry tfpbeInGBP= insertPricebookEntry(parentProductID,'GBP',tfPricebookId,unitPriceInGBP);
            PricebookEntry tfpbeInUSD= insertPricebookEntry(parentProductID,'USD',tfPricebookId,unitPriceInUSD);
            
            PricebookEntry tfEbookPbeInGBP= insertPricebookEntry(parentProductID,'GBP',tfEbookPricebookId,discountedPriceInGBP);
            PricebookEntry tfEbookPbeInUSD= insertPricebookEntry(parentProductID,'USD',tfEbookPricebookId,discountedPriceInUSD);
            
            if (pbeInGBP.id!=null && pbeInUSD.id!=null && tfpbeInGBP.id!=null && tfpbeInUSD.id!=null && tfEbookPbeInGBP.id!=null && tfEbookPbeInUSD.id!=null){            
                msg='Base price has been saved successfully';
                system.debug(msg);
            }
        }
        Return msg;
    }
    //Insert PriceBook Entry
    private static PricebookEntry insertPricebookEntry(String parentProductID,String currencyIsoCode, Id standardPriceBookId, Decimal unitPrice){
        List<Product2> ProductName=[select name from Product2 where id=:parentProductID];
        String prdName=ProductName[0].name;
        system.debug(prdName);  
        PriceBookEntry pbe = new PricebookEntry(Pricebook2Id=standardPriceBookId,Product2Id=parentProductID, UnitPrice=unitPrice, IsActive=true, UseStandardPrice=false,CurrencyIsoCode=currencyIsoCode);
        
        insert pbe;    
        return pbe;
    }
    
    @AuraEnabled
    public static String getProductVersion(String currentVersion) {
        Try
        {        
            String versionToUpdate=currentVersion;
            if (versionToUpdate !='' || versionToUpdate != null){                            
                versionToUpdate=versionToUpdate.substringAfterLast('.');
                // Incrementing the last digit by 1
                Integer intver=Integer.valueof(versiontoupdate.trim());
                intver=intver+1;
                versiontoupdate=String.valueof(intver);
                // concatenating the incremented value in the original string
                String finalver=currentVersion.substring(0, currentVersion.lastIndexOf('.')+1)+versiontoupdate;
                system.debug('Final String  ' + '' + finalver);
                Return finalver;
            }
            else {           
                return '1.0.0';
            }
        }
        catch(Exception ex){
            system.debug(ex.getMessage());
            return '1.0.0';
        }
        
    }
    
    @AuraEnabled
    public static String getRecordTypeId(String ObjectName,String RecordTypeName) {
        Try{        
            
            Id productRecordtypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(RecordTypeName).getRecordTypeId();
            string recordtypeId=String.valueof(productRecordtypeId);  
            return recordtypeId;
        }
        catch(Exception ex){
            system.debug('getRecordTypeId Error debug' + ex.getMessage());
            return null;
        }             
        
    }
    
    //Get Price Book Entry Values by BundleId
    @AuraEnabled
    public static List<Pricebookentry> getPriceBookEntry(String parentProductID) {  
        List<Pricebookentry> result;             
        List<Pricebook2> priceBookId;
        Id standardPriceBookId;
        
        if (test.isrunningtest()){
            standardPriceBookId=Test.getStandardPricebookId(); }
        else{
            priceBookId=[select Id from Pricebook2 where isStandard=true];
            standardPriceBookId= priceBookId[0].id; }       
        
        List <PricebookEntry> pbe = [select UnitPrice,CurrencyIsoCode from Pricebookentry where pricebook2id=:standardPriceBookId and product2id=:parentProductID];
        Return pbe;
    }
    
     @AuraEnabled
    public static List<Pricebookentry> getDiscountedPriceBookEntry(String parentProductID) {  
        List<Pricebookentry> result;             
        List<Pricebook2> priceBookId;
        Id ebookPriceBookId;
        
        if (test.isrunningtest()){
            ebookPriceBookId=Test.getStandardPricebookId(); }
        else{
            priceBookId=[select Id from Pricebook2 where name='T&F - eBooks Pricebook'];
            ebookPriceBookId= priceBookId[0].id; }       
        
        List <PricebookEntry> pbe = [select UnitPrice,CurrencyIsoCode from Pricebookentry where pricebook2id=:ebookPriceBookId and product2id=:parentProductID];
        Return pbe;
    }
    
   /* @InvocableMethod(Label='SubmitSkuToPCM')
    public static List<Integer> submitApi(List<String> bundleID){
        List<Integer>intresponse=new List<Integer>();
        submitSKUUpdateApi(bundleID[0]);
        return intresponse;
    }*/
    
  /* @future(callout='true')
    public static void submitSKUUpdateApi(String bundleID){
         try{
            system.debug('Inside submitApi');
            String searchAPIEndpoint='';
            String hubId=''; 
            String jsonStr='';
            //String bundleIDs=bundleID[0];
			List<Integer> intResponses=new List<Integer>();
			
            Product2 product = new Product2();
            product = [SELECT Id,Hub_Id__c  FROM Product2 WHERE id = :bundleID limit 1];
            hubId=product.Hub_Id__c;
            
            Map<String, String> headers = new Map<String,String>();
            jsonStr = TF_GenerateJson.GeneratePatchApiJson(bundleID);
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();    
            searchAPIEndpoint= (String) orgSpecificProps.get('New_Search_API_URL__c');  
            searchAPIEndpoint=searchAPIEndpoint+'/'+hubId;    
            system.debug('searchAPIEndpoint');    
            headers.put('Content-Type', 'application/json');        
            HttpResponse res = new HttpResponse();        
            res = TF_PlatformExecuter.execute(searchAPIEndpoint,'PATCH','idtoken', jsonStr, headers, false); 
           
             if ( res.getStatusCode() == 202) { 
                system.debug('res body '+res.getBody());
                Product2 prd = new Product2();
                prd.id = bundleID ;
                prd.APIStatus__c = 'SKU Update Success';
                prd.API_Error_Cause__c=res.getBody();
                update prd ;
            }else{
                system.debug('res body '+res.getBody());
                Product2 prd = new Product2();
                prd.id = bundleID ;
                prd.APIStatus__c = 'SKU Update Success';
                prd.API_Error_Cause__c=res.getBody(); 
                update prd ;
            }
            intResponses.add(res.getStatusCode());
            //return res.getStatusCode(); 
  			//return intResponses;
        }
        catch(exception ex){
            system.debug(ex.getMessage());
            //return null;
        }
    }*/
    
    @AuraEnabled
    public static void sendMailForClonedRequest(String clonedProductId){
        try{
            List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
            User u = [select Id, username,name,email from User where Id = :UserInfo.getUserId()];
            String mailAddress=u.email;
            String baseUrl=URL.getSalesforceBaseUrl().toExternalForm();
            String productUrl=baseUrl+'/'+clonedProductId;
            
            system.debug(u.Email);
            List<String> sendTo = new List<String>();
            sendTo.add(mailAddress);
            mail.setToAddresses(sendTo);
            
            mail.setReplyTo('noreply@gmail.com'); 
            mail.setSenderDisplayName('Salesforce Support');
            
            mail.setSubject('Request Processed Successfully!');
            mail.setHtmlBody('Hello '+ ' ' +u.name+', <br/><br/>Your request has been processed successfully. Click the link below to view the product<br> '+productUrl+'<br/><br/>Regards<br/> Salesforce');
            //mail.setHtmlBody(body);
            
            mails.add(mail);
            
            Messaging.sendEmail(mails);
        }
        catch(exception ex){
            system.debug(ex.getMessage());
        }
        
        
    }
    
    
    
    //Copy uploaded Image to cloned product
    private static boolean copyUploadedImageToClonedProd(String clonedProductId){
        try{  
            Product2 Prd=[select name,OriginalProductId__c from Product2 where id=:clonedProductId];
            Set<Id> recordIds = new Set<Id>{Prd.OriginalProductId__c};
        List<ContentDocumentLink> cdlList = [SELECT Id, LinkedEntityId, ContentDocumentId FROM 
                                             ContentDocumentLink WHERE LinkedEntityId IN :recordIds
                                            ];                         
        Set<Id> documentIds = new Set<Id>(); 
        for(ContentDocumentLink cdl:cdlList){  
            documentIds.add(cdl.ContentDocumentId);  
        }    
            
          list<ContentVersion> originalCV = [select id,pathonclient,title,Versiondata from contentversion where ContentdocumentId IN : documentIds];
       
            for(ContentVersion cv :originalCV){
                ContentVersion contver = new ContentVersion();
       		    contver.VersionData = cv.Versiondata;
       		    contver.Title = cv.title;
                contver.PathOnClient = cv.title;
                insert contver;
                
                ContentDocumentLink cdl = new ContentDocumentLink();
                 cdl.ContentDocumentId = [
              SELECT ContentDocumentId 
              FROM ContentVersion 
              WHERE Id =: contver.Id
            ].ContentDocumentId;
                cdl.LinkedEntityId=clonedProductId;
                cdl.ShareType = 'V';
            	//cdl.Visibility = 'InternalUsers';
                cdl.Visibility ='AllUsers'; 
                insert cdl;
            }
            
            
            
            // return [SELECT Id, Title, FileType FROM ContentDocument WHERE Id IN :documentIds];   
            return true;
            
        }catch(exception ex){
            system.debug(ex.getMessage());
            return false;
        }
    }
    
    //Added by Geetika for PCH-3886
    @AuraEnabled
    public static Boolean collectionStatus(String recordID) {
        system.debug('BundleID123 ' + recordID);
        try{
            Product2 product = new Product2();
        	product = [SELECT id, Is_collection_free__c FROM Product2 WHERE id = :recordID LIMIT 1];
            system.debug('BundleID123 ' + product.Is_collection_free__c);
            if(product.Is_collection_free__c){
                return true;
            } else {
                return false;
            }
        	
        } catch (exception e){
            system.debug(e.getMessage());
            return false;
        }
        
    } //end for PCH-3886
    
    
    //Added by Geetika for PCH-3712
    @AuraEnabled
    public static PagedResultDetails searchBundleLineItems(String bundleID ,String queryTerm , String offsetCursor){
        List<PagedResult> pr = new List<PagedResult>();
        PagedResultDetails prDetail = new PagedResultDetails();
        String searchAPIEndpoint='';
        String hubId;
        try{
            
            
            Map<String, String> childParentMap = new Map<String,String>();
            
            Product2 product=[SELECT id,Hub_Id__c FROM Product2 WHERE id =:bundleId];
            hubId = product.Hub_Id__c;
            system.debug('queryTerm ' + queryTerm + ' + ' + offsetCursor + ' + ' + bundleID + ' + ' + hubId);
            Map<String, String> headers = new Map<String,String>();
            queryTerm = EncodingUtil.urlEncode(queryTerm, 'UTF-8').replace('+', '%20');
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();    
            searchAPIEndpoint= (String) orgSpecificProps.get('New_Search_API_URL__c');  
            searchAPIEndpoint=searchAPIEndpoint+'/'+hubId+'/parts?apiVersion=4.1.0&responseGroup=medium&q='+queryTerm+'&limit=500&appName=SF&offsetCursor='+offsetCursor;    
            system.debug('searchAPIEndpointCollection ' + searchAPIEndpoint);    
            headers.put('Content-Type', 'application/json');        
            HttpResponse res = new HttpResponse();        
            
            res = TF_PlatformExecuter.execute(searchAPIEndpoint,'GET','idtoken', null, headers, false); 
            system.debug('searchTextResponse ' + res.getBody());
            if(String.valueOf(res.getStatusCode()).startsWith('2') || test.isRunningTest()){
                String resBody=res.getBody();
                
                resBody=resBody.replace('"@id":', '"id":');
                resBody=resBody.replace('"@type":', '"type":'); 
                resBody=resBody.replace('"isPartOf":"UNSDG",', '');
                resBody=resBody.replace('"givenName":null', '"givenName":"null"');
                resBody=resBody.replace('"familyName":null', '"familyName":"null"');
                resBody=resBody.replace('"fullName":null', '"fullName":"null"');
                //Replacing Empty String
                resBody=resBody.replace('"fullName":""', '"fullName":"null"');
                resBody=resBody.replace('"givenName":""', '"givenName":"null"');
                resBody=resBody.replace('"familyName":""', '"familyName":"null"');
                resBody=resBody.replace('"type":', '"type_Z":'); 
                TFCollectionPartsDocNewModel listSearchResponse = new TFCollectionPartsDocNewModel();
                List<TFCollectionPartsDocNewModel> partsDoc = new List<TFCollectionPartsDocNewModel>();
                List<TFCollectionPartsDocNewModel.Data> docData = new List<TFCollectionPartsDocNewModel.Data>();
                List<TFCollectionPartsDocNewModel.Prices> prices = new List<TFCollectionPartsDocNewModel.Prices>();
                List<TFCollectionPartsDocNewModel.Contributors> contributors = new List<TFCollectionPartsDocNewModel.Contributors>();
                TFCollectionPartsDocNewModel.Data data = new TFCollectionPartsDocNewModel.Data();
                TFCollectionPartsDocNewModel.Book books = new TFCollectionPartsDocNewModel.Book();
                TFCollectionPartsDocNewModel.creativeWork creativeWork = new TFCollectionPartsDocNewModel.creativeWork();
                TFCollectionPartsDocNewModel.scholarlyArticle scholarlyArticle = new TFCollectionPartsDocNewModel.scholarlyArticle();
                TFCollectionPartsDocNewModel.chapter chapter = new TFCollectionPartsDocNewModel.chapter();
                TFCollectionPartsDocNewModel.collection collection = new TFCollectionPartsDocNewModel.collection();
                TFCollectionPartsDocNewModel.identifiers identifiers = new TFCollectionPartsDocNewModel.identifiers();
                TFCollectionPartsDocNewModel.Metadata metadata = new TFCollectionPartsDocNewModel.Metadata();
                List<TFCollectionPartsDocNewModel.Counts> counts = new List<TFCollectionPartsDocNewModel.Counts>();
                
                listSearchResponse = (TFCollectionPartsDocNewModel) JSON.deserialize(resBody, TFCollectionPartsDocNewModel.class);
                docData = listSearchResponse.Data;
                //PagedResult contentData = new PagedResult();
                system.debug('filtered json' + listSearchResponse);
                List<Counts> queryCounts = new List<Counts>();
                counts = listSearchResponse.Metadata.Counts ;
                if(counts != null){
                    for(TFCollectionPartsDocNewModel.Counts count : counts){
                        system.debug('count '+count);
                        if(count.type_Z == 'Total'){
                            prDetail.total = count.count;
                        }
                       
                    }     
                }
                metadata = listSearchResponse.Metadata ;
                prDetail.nextPageCursor = metadata.nextPageCursor;
                prDetail.prevPageCursor = metadata.prevPageCursor;
                prDetail.lastPageCursor = metadata.lastPageCursor;
                
                List<PagedResult> contentDataList = new  List<PagedResult>();
                for(TFCollectionPartsDocNewModel.Data doc : docData) {
                   
                    contributors = doc.contributors; 
                    identifiers=doc.identifiers;
                    books=doc.book;
                    creativeWork=doc.creativeWork;
                    scholarlyArticle=doc.scholarlyArticle;
                    chapter=doc.chapter;
                    collection=doc.collection;
                    
                    
              		PagedResult contentData = new PagedResult();
                    //contentData.doi=doc.doi;
                    contentData.id=doc.x_id;    
                    contentData.type = doc.type_Z;
                    //contentData.mediaType=doc.format;
                    contentData.Open_access=doc.isFree;
                    contentData.title = doc.title;
                    contentdata.uuid=doc.x_id;
                    contentData.source='PCM';  
                    
                    if(contributors != null){
                        contentData.authors ='';
                        for(TFCollectionPartsDocNewModel.Contributors author : contributors){
                            if(author.roles != null && (author.roles.contains('author')|| author.roles.contains('Author'))){
                                String authorFullName=String.ValueOf(author.fullName);   
                                if(authorFullName!='null'){
                                    contentData.authors = contentData.authors + authorFullName + ' || ';
                                    
                                }
                            }
                        }
                        contentData.authors = contentData.authors != null ? contentData.authors.left(contentData.authors.length() - 4) : null ;
                    }
                    if(identifiers != null){                          
                        contentData.doi=identifiers.doi;                        
                    }
                    if(books != null){                          
                        contentData.publisher=books.publisherImprint;   
                        contentData.publication_date=books.publicationDate;
                    }
                    
                    if(collection != null){                          
                        contentData.publisher=collection.publisherImprint;   
                        contentData.publication_date=collection.publicationDate;
                        contentData.doi=contentdata.uuid;
                    }
                    
                    if(creativeWork != null){                          
                        contentData.publisher=creativeWork.publisherImprint;   
                        contentData.publication_date=creativeWork.publicationDate;
                        contentData.mediaType=creativeWork.format;
                    }
                    
                    if(scholarlyArticle != null){                          
                        contentData.publisher=scholarlyArticle.publisherImprint;   
                        contentData.publication_date=scholarlyArticle.publicationDate;
                    }
                    
                    if(chapter != null){                          
                        contentData.publisher=chapter.publisherImprint;   
                        contentData.publication_date=chapter.publicationDate;
                    }
                    
                    contentData.authors = contentData.authors;  
                    contentDataList.add(contentData);
                }
                pr = contentDataList; 
                prDetail.prList = pr ;
                //prDetail.total = TotalCount;
                prDetail.msg = 'Success';
                system.debug('prDetailSearch '+prDetail);
                return prDetail;  
            }else if(res.getStatusCode() == 404){
                prDetail.prList = null ;
                prDetail.msg = 'NOT_FOUND';              
                return prDetail;   
            }else{
                prDetail.prList = null ;
                prDetail.msg = 'There was an issue getting the details, please try later or contact SFDC system admin';               
                return prDetail;   
                
            }
        }
        
        catch(exception ex){
            system.debug('ExMessage' + ex.getMessage());
         	prDetail.prList = null ;
            prDetail.msg = 'There was an issue getting the details, please try later or contact SFDC system admin';
        }
        return prDetail; 
    }  
    
    public class Counts {
        @AuraEnabled
        public Integer count {get;set;} 
        @AuraEnabled
        public String productType {get;set;}
    }
    //end for PCH-3712
    
}