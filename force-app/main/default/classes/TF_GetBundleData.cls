/**
Author : Radhikay Banerjee
Test class :  TF_GetBundleDataTest
Description : This class is used as a controller class for DisplayBundleInformation, DisplayBundleDetails and DisplayBundleItems aura components.
**/
public class TF_GetBundleData {
    
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
    }
    
    public class InitialFieldValues {        
        @AuraEnabled
        public String productState { get;set; }
        @AuraEnabled
        public String productType { get;set; }
        @AuraEnabled
        public String dynamicRule { get;set; }     
        @AuraEnabled
        public String AllowUserToUpdate { get;set; }
        @AuraEnabled
        public String isProductActive { get;set; }
        @AuraEnabled
        public String isUserAdmin { get;set; }
        @AuraEnabled
        public String createdByName { get;set; }
        @AuraEnabled
        public String lastModifiedByName { get;set; }
        @AuraEnabled
        public String recordTypeName { get;set; }
        @AuraEnabled
        public String createdById { get;set; }
        @AuraEnabled
        public String lastModifiedById { get;set; }
        @AuraEnabled
        public String salesforceURL { get;set; }
        @AuraEnabled
        public String createdDate { get;set; }
        @AuraEnabled
        public String lastModifiedDate { get;set; }
        @AuraEnabled
        public String productCollectionupdatedFrom { get;set; }
        @AuraEnabled
        public String productCollectionupdatedTo { get;set; }
    }
    
    @AuraEnabled
    public static PagedResultDetails getProductsFromPCMById(String bundleID, String productType){
        List<PagedResult> pr = new List<PagedResult>(); 
        PagedResultDetails prDetail = new PagedResultDetails();
        Integer TotalCount=0; 
        String uuid ;
        productType = 'book';
        String newPartsApiURI='/v4/products/53f568df-61c8-461a-805b-fe04e5f4b689/parts?offset=0&limit=2&expanded=true';
        Map<String, String> headers = new Map<String,String>();
        Map<String, String> childParentMap = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        String request='{"apiVersion" : "4.0.1",  "responseGroup":"large"}';
        
        try{           
            
           Product2 prdt=[SELECT id, hub_Id__c FROM Product2 WHERE id = :bundleID]; 
           //uuid=bundleID;
           uuid=prdt.Hub_Id__c;
            System.debug('uuid'+uuid);
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            newPartsApiURI = (String) orgSpecificProps.get('Parts_Api_Url__c');
            newPartsApiURI = newPartsApiURI + uuid +'?apiVersion=4.0.1&responseGroup=large';
            
            HTTPResponse res = TF_PlatformExecuter.execute(newPartsApiURI,'GET','idtoken', null, headers, false);
            
            system.debug('newPartsApiURI$$$$' + newPartsApiURI);
            system.debug('getStatusCode###' +res.getStatusCode());
            System.debug('======== get product API Response ========'+ res.getbody());
            
            if(String.valueOf(res.getStatusCode()).startsWith('2')){
                childParentMap.put('Chapter','Book');
                childParentMap.put('ScholarlyArticle','Periodical');
                system.debug('Inside GetProductNewAPI');
                system.debug('statuscode' + ' ' + res.getStatusCode());
                system.debug(res.getBody());
                String resBody=res.getBody(); 
                system.debug('======Parts API response====='+resBody);
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
                        System.debug('contentDataList'+contentDataList);
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
                system.debug('=======prDetail====='+prDetail);
                return prDetail;  
            }else if(res.getStatusCode() == 404){
                system.debug('code##'+res.getStatusCode());
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
            System.debug('Cause: ' + ex.getCause());    
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
        productType = 'book';
        String newPartsApiURI='/v4/products/53f568df-61c8-461a-805b-fe04e5f4b689/parts?offset=0&limit=500&expanded=true';
        Map<String, String> headers = new Map<String,String>();
        Map<String, String> childParentMap = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        String request='{"apiVersion" : "4.0.1",  "responseGroup":"large",  "offset" : 0,  "limit" : 100}';
        
        try{           
            // Product2 prd  = [SELECT Hub_Id__c FROM Product2 WHERE id = :bundleID]; 
             Product2 prdt=[SELECT id, hub_Id__c FROM Product2 WHERE id = :bundleID]; 
           //uuid=bundleID;
           uuid=prdt.Hub_Id__c;
           
            system.debug('uuid-getPartsFromPCMNewDataModel##'+uuid);
            //uuid = 'b770a8bb-287f-4123-8e6f-71def0e5fa4c';
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            newPartsApiURI = (String) orgSpecificProps.get('Parts_Api_Url__c');
            system.debug('##productType##' + productType);
            newPartsApiURI = newPartsApiURI + uuid + '/parts?apiVersion=4.0.1&responseGroup=medium&type=' + productType + '&offset=' + offsetValue + '&limit=' + limitValue;
            system.debug('##newPartsApiURI##' + newPartsApiURI);
            HTTPResponse res = TF_PlatformExecuter.execute(newPartsApiURI,'GET','idtoken', null, headers, false);
            
            if(String.valueOf(res.getStatusCode()).startsWith('2')){
                childParentMap.put('Chapter','Book');
                childParentMap.put('ScholarlyArticle','Periodical');
                
                system.debug('statuscode' + ' ' + res.getStatusCode());
                system.debug(res.getBody());
                String resBody=res.getBody(); 
                system.debug('======Parts API response====='+resBody);
                resBody=resBody.replace('"_id":', '"id":');
                resBody=resBody.replace('"@type":', '"type":'); 
                resBody=resBody.replace('"isPartOf":"UNSDG",', '');
                //for Author name null issue
                resBody=resBody.replace('"fullName":null', '"fullName":"null"');
                //Replacing Empty String
                resBody=resBody.replace('"fullName":""', '"fullName":"null"');
                
                resBody=resBody.replace('”','"');
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
                system.debug('resBodyresBody' + resBody);
                //partsDoc = (TFCollectionPartsDocNewModel)JSON.deserialize(resBody, TFCollectionPartsDocNewModel.class); 
                partsDoc=(List<TFCollectionPartsDocNewModel>)JSON.deserialize(resBody, List<TFCollectionPartsDocNewModel>.class);
                System.debug('partsDoc' + partsDoc);
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
                system.debug('=======prDetail====='+prDetail);
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
            System.debug('Cause: ' + ex.getCause());    
            system.debug('Trace' + ex.getStackTraceString());
            prDetail.prList = null ;
            prDetail.msg = 'There was an issue getting the details, please try later or contact SFDC system admin';
        }
        return prDetail; 
    }
    
    @AuraEnabled
    public static InitialFieldValues getBundleRuleInformation(String bundleID) {
        InitialFieldValues inVals = new InitialFieldValues();
        inVals.dynamicRule = null;
        Product2 product = [SELECT id, Name, Approval_Status__c, APIStatus__c, Product_Type_Author_Facing__c, Type_of_Bundle__c, Dynamic_Collection_Criteria__c,CreatedBy.Id,CreatedBy.Name,LastModifiedBy.Id,LastModifiedBy.Name, MaxReAttempts__c,RecordType.Name,createddate,lastmodifiedDate, isActive, Collection_updatedFrom__c, Collection_updatedTo__c FROM Product2 WHERE id = :bundleID limit 1];
        if(product!=null){
            inVals.productType = product.Product_Type_Author_Facing__c;
        inVals.isProductActive = product.isActive ? 'True' : 'False';
        if(product.Dynamic_Collection_Criteria__c != null){
            inVals.dynamicRule = product.Dynamic_Collection_Criteria__c ;
        }
        inVals.AllowUserToUpdate='true';
        if(product.Approval_Status__c == 'Draft' || product.Approval_Status__c == 'Rejected') {
            inVals.productState = 'true';
        } 
        else if((product.Approval_Status__c == 'Pending for Approval' || product.Approval_Status__c == 'Approved') && (product.APIStatus__c != 'GetUUID Incomplete' && product.APIStatus__c != 'Failure' && product.APIStatus__c != 'Submit To PCM Failed')){
            inVals.productState = 'false';
        }
        else if(product.APIStatus__c == 'GetUUID Incomplete'){
            inVals.productState = 'retrySubmit';
        }
        else if((product.APIStatus__c == 'Failure' || product.APIStatus__c == 'Submit To PCM Failed')&& product.Approval_Status__c == 'Approved' && product.MaxReAttempts__c>3){
            inVals.productState = 'ackApiFailed';
        }
        else{        
            inVals.productState = 'false';
        }
        
        if ( product.Collection_updatedFrom__c != Null ) { //SFAL-383 Vikas Varshney dated 10-Aug-2022
            inVals.productCollectionupdatedFrom = String.valueOf(product.Collection_updatedFrom__c);
        }
        
        if ( product.Collection_updatedTo__c != Null ) { //SFAL-383 Vikas Varshney dated 10-Aug-2022
            inVals.productCollectionupdatedTo = String.valueOf(product.Collection_updatedTo__c);
        }
        
        return inVals;
        }else{
            return null;
        }
        
    }
    
    //SFAL 264 Shubham kumar
    //@ Description : Getting the bundle Line Items.
    @AuraEnabled
    public static List<Bundle_Line_Item__c> getBundleLineItemsByProductId(String productId) {
        system.debug('productId'+productId);
        try{
            List<Bundle_Line_Item__c> bundleListItems = [select Product_Bundle_Parent__c,Title__c,PriceUSD__c,publication_date__c,Publisher__c,Authors__c,doi__c,mediaType__c,Product_Doi__c,Product__c,lineItemStatus__c,Source__c,Content_Position__c,Type__c,Valid__c,uuid__c from Bundle_Line_Item__c where Product_Bundle_Parent__c = :productId];
            return bundleListItems;
        }
        catch(exception e){
            system.debug('Error Message is'+e.getMessage()+' @ '+e.getLineNumber());
            return null;
        }
    }
    //SFAL 264 Shubham kumar
    //@ Description : Deleting all the bundle Line Items corresponding to the ProductId.
    @AuraEnabled
    public static String deleteAllSpecifiedBundles(String parentProductID) {
        try{
            Integer totalRecords;
            String msg = 'No records to delete';
            Boolean inclusion = true ;
            system.debug('parentProductIDparentProductIDparentProductID' +  parentProductID);
            SBQQ__QuoteLine__c quoteLine = new  SBQQ__QuoteLine__c();
            if(parentProductID != null){
                system.debug('4464464446');
                quoteLine = [Select id , name , SBQQ__Product__c  from SBQQ__QuoteLine__c where SBQQ__Product__c  =:parentProductID  AND SBQQ__Bundled__c = True][0];
                system.debug('quoteLine'+quoteLine);
            }
            
            Product2 bundleProd = [select Id,Name,List_Price__c,Sales_Price__c from product2 where id = :parentProductID];
            
            bundleProd.Sales_Price__c = 0;
            bundleprod.List_Price__c = 0;
            database.update(bundleProd);
            
            //Updating the QLI details
            quoteLine.SBQQ__ListPrice__c = bundleProd.List_Price__c;
            quoteLine.Original_List_Price__c = bundleProd.Sales_Price__c;
            try{
                database.update(quoteLine);    
            }catch(exception e){
                system.debug('Exception @'+e.getLineNumber() +'message'+e.getMessage());
            }
            
            
            totalRecords = [SELECT count() FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :parentProductID ];
            list< Bundle_Line_Item__c> listofLineItems = [SELECT id, name FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :parentProductID  limit 10000];
            
            if(listofLineItems.size() > 0 && listofLineItems.size() < 10000){
                delete listofLineItems;
                msg = 'All Products have been deleted from the Collection';
                return msg;
            }else if(listofLineItems.size() > 10000){
                delete listofLineItems;
                msg = '10000 Products have been deleted from the Collection, click the buton again to delete the remaining products';
                return msg;
            }
            return msg;
        }
        catch(exception e ){
            system.debug('Error Message'+e.getMessage());
            return null;
        }
        
    }
    //SFAL 264 Shubham kumar
    //@ Description : Deleting specific bundle Line Items.
    @AuraEnabled
    public static String deleteSpecifiedBundles( list<Bundle_Line_Item__c> bundleItems) {
        try{
            system.debug('bundleItems'+bundleItems);
            
            String bundleProdId = bundleItems[0].Product_Bundle_Parent__c ;
            SBQQ__QuoteLine__c quoteLine = new  SBQQ__QuoteLine__c();
            if(bundleProdId != null){
                quoteLine = [Select id , name , SBQQ__Product__c  from SBQQ__QuoteLine__c where SBQQ__Product__c  =:bundleProdId  AND SBQQ__Bundled__c = True][0];
                system.debug('quoteLine'+quoteLine);
            }
            
            Decimal valueToBeDecreased = 0;
            for(Bundle_Line_Item__c bli : bundleItems){
                valueToBeDecreased = valueToBeDecreased + bli.PriceUSD__c;
            }
            
            Product2 bundleProd = [select Id,Name,List_Price__c,Sales_Price__c from product2 where id = :bundleProdId];
            
            bundleProd.Sales_Price__c = bundleProd.Sales_Price__c - valueToBeDecreased;
            bundleprod.List_Price__c = bundleProd.List_Price__c - valueToBeDecreased;
            database.update(bundleProd);
            
            //Updating the QLI details
            quoteLine.SBQQ__ListPrice__c = bundleProd.List_Price__c;
            quoteLine.Original_List_Price__c = bundleProd.Sales_Price__c;
            try{
                database.update(quoteLine);    
            }catch(exception e){
                system.debug('Exception @'+e.getLineNumber() +'message'+e.getMessage());
            }
            
            if(bundleItems.size() > 0){
                database.delete(bundleItems);
            }
            string msg = 'records have been deleted from the Collection';
            return msg;
        }
        catch(exception e ){
            system.debug('Error Message'+e.getMessage());
            return null;
        }
    }
}