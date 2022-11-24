//Test Class-zTest_TF_PPDProcessController
global with sharing class TF_PPDProcessController {    
    public class PagedResult {        
        @AuraEnabled 
        public String isbn { get;set; }        
        @AuraEnabled 
        public String title { get;set; }
        @AuraEnabled
        public String name { get;set; }   
        @AuraEnabled
        public String author { get;set; }       
        @AuraEnabled  
        public String planPubDate { get;set; }  
        @AuraEnabled
        public String id { get;set; }
        @AuraEnabled
        public integer edition { get;set; }
        @AuraEnabled
        public String format { get;set; }
        @AuraEnabled
        public String type { get;set; }
        @AuraEnabled
        public String subType { get;set; }
        @AuraEnabled
        public String publicationDate { get;set; }
        @AuraEnabled
        public String doi { get;set; }
        @AuraEnabled
        public String publisherImprint { get;set; }
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
        @AuraEnabled
        public String firstPublishedYear { get;set; }
        @AuraEnabled
        public String copyRightYear { get;set; }
        @AuraEnabled
        public String textType { get;set; }
        @AuraEnabled
        public String dacKey { get;set; }
        @AuraEnabled
        public String sku { get;set; }
        @AuraEnabled
        public String editor { get;set; }
        @AuraEnabled
        public String openAccess { get;set; } 
        @AuraEnabled
        public String drm { get;set; } 
        @AuraEnabled
        public String publisherArea { get;set; }
        @AuraEnabled
        public String status { get;set; }
        @AuraEnabled
        public String categoryType { get;set; }
        @AuraEnabled
        public String classificationGroup { get;set; }
        /*@AuraEnabled
        public String statuscode { get;set; }
        @AuraEnabled
        public String location { get;set; }*/
        
        @AuraEnabled
        public String productCategory {get;set;}
         @AuraEnabled
        public String freeAccess { get;set; } 
    }
    
    public class PagedResultDetails {        
        @AuraEnabled
        public Integer total { get;set; }
        @AuraEnabled
        public List <PagedResult> prList { get;set; }
        @AuraEnabled
        public String msg { get;set; }        
    }
    
    public class ResultCoulmn {        
        @AuraEnabled 
        public String label { get;set; }        
        @AuraEnabled
        public String fieldName { get;set; }
        @AuraEnabled
        public String type { get;set; }   
        @AuraEnabled
        public ResulttypeAttributes typeAttributes { get;set; }       
        @AuraEnabled
        public ResultcellAttributes cellAttributes { get;set; }  
        
    }
    
    public class ResultCoulmnWithDefault {        
        @AuraEnabled 
        public ResultCoulmn resCol { get;set; }        
        @AuraEnabled
        public String showVal { get;set; }
        
    }
    
    public class ResulttypeAttributes {        
        @AuraEnabled 
        public String currencyCode { get;set; }        
    }
    
    public class ResultcellAttributes {        
        @AuraEnabled 
        public String alignment { get;set; }
    }
    
    public class ResultCoulmnsForType { 
        @AuraEnabled
        public String type { get;set; }   
        @AuraEnabled
        public List <ResultCoulmnWithDefault> columns { get;set; }
    }
    
    public class Filter {        
        @AuraEnabled
        public String ISBN { get;set; }  
        @AuraEnabled
        public String title { get;set; }
        @AuraEnabled
        public String author { get;set; }
        @AuraEnabled
        public String doi { get;set; }
        @AuraEnabled
        public List<String> netbase { get;set; }
        @AuraEnabled
        public List<String> subjectList { get;set; }
        @AuraEnabled
        public String mediumData { get;set; }
        @AuraEnabled
        public String publishData { get;set; }       
        @AuraEnabled
        public String publcFromDate { get;set; } 
        @AuraEnabled
        public String publcToDate { get;set; }       
        @AuraEnabled
        public String minPrice { get;set; }
        @AuraEnabled
        public String maxPrice { get;set; }
        @AuraEnabled
        public String sortBy { get;set; }
        @AuraEnabled
        public String sortOrderFieldName { get;set; }
        @AuraEnabled
        public String drmData { get;set; }
        @AuraEnabled
        public String currencyTypeData { get;set; }
        @AuraEnabled
        public String textType { get;set; }
        @AuraEnabled
        public String publisherImprint { get;set; }
        @AuraEnabled
        public String firstPubYearDataFrom { get;set; }
        @AuraEnabled
        public String firstPubYearDataTo { get;set; }
    }  
    
    public class QueryObject {   
        @AuraEnabled
        public String type { get;set; }  
        @AuraEnabled
        public String name { get;set; } 
        @AuraEnabled
        public String queryLabel { get;set; } 
        @AuraEnabled
        public List<String> value { get;set; }
        @AuraEnabled
        public String operatior { get;set; }
        @AuraEnabled
        public Integer position { get;set; }
        @AuraEnabled
        public String logicalOpp { get;set; }
        @AuraEnabled
        public Integer logicalOppStartPosLeft { get;set; }
        @AuraEnabled
        public Integer logicalOppEndPosLeft { get;set; }
        @AuraEnabled
        public Integer logicalOppStartPosRight { get;set; }
        @AuraEnabled
        public Integer logicalOppEndPosRight { get;set; }
    }
    
    public class MultiTypeQueryObjects {   
        @AuraEnabled
        public String productType { get;set; }
        @AuraEnabled
        public List<QueryObject> queryObject { get;set; }  
    }
    
    public class RuleElement {   
        @AuraEnabled
        public String type { get;set; }  
        @AuraEnabled
        public String attribute { get;set; } 
        @AuraEnabled
        public String relationship { get;set; }
        @AuraEnabled
        public String value { get;set; }
        @AuraEnabled
        public String attributeLabel { get;set; } 
        @AuraEnabled
        public String relationshipLabel { get;set; }
    }
    
    
    public class querySaveElement {   
        @AuraEnabled
        public Filter filterObject { get;set; }  
        @AuraEnabled
        public List<RuleElement> ruleElementLst { get;set; }  
        @AuraEnabled
        public String queryString { get;set; }
        @AuraEnabled
        public String isDynamicUi { get;set; }
        @AuraEnabled
        public List<MultiTypeRules> multiTypeRulesLst { get;set; } 
    }
    
    public class MultiTypeRules {   
        @AuraEnabled
        public String productType { get;set; }
        @AuraEnabled
        public List<RuleElement> ruleElementLst { get;set; }  
        @AuraEnabled
        public String queryString { get;set; } 
    }
    
    
    public class processedQuery {   
        @AuraEnabled
        public String jsonString { get;set; } 
        @AuraEnabled
        public String queryString { get;set; } 
        @AuraEnabled
        public List<RuleElement> ruleElementLst { get;set; }
        @AuraEnabled
        public List<MultiTypeRules> multiTypeRulesLst { get;set; } 
        @AuraEnabled
        public Integer total { get;set; }
        @AuraEnabled
        public Integer offset { get;set; }
        @AuraEnabled
        public List <PagedResult> prList { get;set; }
        @AuraEnabled
        public List <PagedResult> prListVal { get;set; }
        @AuraEnabled
        public String msg { get;set; }
        @AuraEnabled
        public decimal totalPriceUSD { get;set; }
        @AuraEnabled
        public decimal totalPriceGBP { get;set; }
        @AuraEnabled
        public List<Counts> counts {get;set;} 
        @AuraEnabled
        public String productTypeReturned { get;set; } 
        @AuraEnabled
        public List <ResultCoulmn> columnsLst { get;set; }
        @AuraEnabled
        public String nextPageCursor {get;set;}
        @AuraEnabled
        public String prevPageCursor {get;set;}
        @AuraEnabled
        public String lastPageCursor {get;set;}
    }
    
    public class Counts {
        @AuraEnabled
        public Integer count {get;set;} 
        @AuraEnabled
        public String productType {get;set;}
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
    
    public class FileUploadDetails {        
        @AuraEnabled
        public String Msg { get;set; } 
        @AuraEnabled
        public String errMsg { get;set; }
        @AuraEnabled
        public String formatErrMsg { get;set; }        
        @AuraEnabled
        public integer successRecCnt { get;set; }
        @AuraEnabled
        public integer totalRecs { get;set; }
        
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
        public Boolean isCollectionFree {get; set;}
    }
    
    public class PartsDownload {   
        @AuraEnabled
        public String location { get;set; }  
        @AuraEnabled
        public String type_z { get;set; }
    }
    
    public class TreeWrapper{
        @AuraEnabled public String recId;
        @AuraEnabled public String labelValue;
        @AuraEnabled public Boolean isCheck;
        @AuraEnabled public List<TreeWrapper> childTree;
    }
    
    public class DynamicUIValue{        
        @AuraEnabled public String grandParent { get;set; }        
        @AuraEnabled public String parent { get;set; }
        @AuraEnabled public String fieldLabel { get;set; }   
        @AuraEnabled public String fieldValue { get;set; }
        @AuraEnabled public String dataType { get;set; }
        @AuraEnabled public String supportedOperator { get;set; }
        @AuraEnabled public String dotNotation { get;set; }
        @AuraEnabled public String queryLabel { get;set; }
        @AuraEnabled public String useValueFrom { get;set; }
        @AuraEnabled public Boolean fileUpload;
        @AuraEnabled public Boolean hasChild;
        @AuraEnabled public Boolean hasOperator;
        
    }

    public class ImplicitFilter{        
        @AuraEnabled public String prdType { get;set; }        
        @AuraEnabled public String dotNotation { get;set; }
        @AuraEnabled public String qryLabel { get;set; }   
        @AuraEnabled public String operatior { get;set; }
        @AuraEnabled public String value { get;set; }
        @AuraEnabled public Boolean useImpVal { get;set; }
    }
    
    public class DynamicUIValueLst{
        @AuraEnabled public List<DynamicUIValue> valueLst { get;set; }
    }
    
    public class ImplicitFilterLst{
        @AuraEnabled public List<ImplicitFilter> valueLst { get;set; }
    }
    
    public class ImageUploadNames {        
        @AuraEnabled 
        public String banner { get;set; }        
        @AuraEnabled
        public String cover { get;set; }
      }
    
    @AuraEnabled
    public static PagedResultDetails getProducts(String filters) {
        //processQueryObj(queryObj);
        PagedResultDetails prDetails = new PagedResultDetails();
        List<PagedResult> prlst =  new List<PagedResult>(); 
        String recordTypeID=getRecordTypeId('Product2','T&F - Collection');
        
        Filter filter = (Filter) JSON.deserialize(filters, TF_PPDProcessController.Filter.class);
        List<PricebookEntry> lstPriceBookEntry=new List<PricebookEntry>();
        String query;
        String selectQuery;
        String queryCount = ''; 
        String systemIdVal='GT_TF';
        String currencyType;
        //String priceBookName='T&F Pricebook';
        String priceBookName='T&F - eBooks Pricebook';
        String sortOrderBy;
        String ISBN = filter.ISBN ;
        String doi = filter.doi ;
        String title = filter.title ;
        String author = filter.author ;
        List<String> netbase = filter.netbase ;
        List<String> subjectList = filter.subjectList ;
        String mediumData = filter.mediumData ;
        String publishData = filter.publishData ;
        String publcFromDate = filter.publcFromDate ;
        String publcToDate = filter.publcToDate ;
        String minPrice = filter.minPrice ;
        String maxPrice = filter.maxPrice ;
        String sortBy = filter.sortBy ;
        String sortOrderFieldName = filter.sortOrderFieldName ;
        String drmData = filter.drmData ;
        String currencyTypeData = filter.currencyTypeData ;
        String firstPubYearDataFrom = filter.firstPubYearDataFrom ; 
        String firstPubYearDataTo = filter.firstPubYearDataTo ;
        String textType = filter.textType ;
        String publisherImprint = filter.publisherImprint ;
        
        
        String where_Clause ;
        Integer count = 0;
        
        /* if(test.isRunningTest()){
priceBookName='Standard Price Book';
}*/
        
        if(sortOrderFieldName.equals('UnitPrice')){
            sortOrderBy='UnitPrice';
        }
        else{
            sortOrderBy='Product2.'+sortOrderFieldName;
        }
        
        try{            
            selectQuery = 'Select Id,Pricebook2.name,CurrencyIsoCode,UnitPrice,Product2.ID,Product2.ISBN__c,Product2.Product_Id_Link__c,Product2.eBook_ISBN__c,Product2.Paperback_ISBN__c,Product2.Hardback_ISBN__c,Product2.Edition_Number__c,Product2.Name,Product2.Lead_Author_Editor__c,Product2.US_Publication_Date__c,Product2.US_Planned_Publication_Date__c,Product2.Version_Type__c,Product2.US_Inventory_Status__c,Product2.POD__c ';
            if(String.isNotBlank(mediumData) && mediumData!='Collection'){
                where_Clause = ' From PricebookEntry  where Pricebook2.IsActive = true and Product2.IsActive = true and Product2.doi__c != null and IsActive = true and CurrencyIsoCode=\''+currencyTypeData+'\' and Product2.System_ID__c=\''+systemIdVal+'\' and Pricebook2.name=\''+priceBookName+'\'';
            }
            if(String.isNotBlank(mediumData) && mediumData=='Collection'){
                where_Clause = ' From PricebookEntry  where Pricebook2.IsActive = true and Product2.IsActive = true and IsActive = true and CurrencyIsoCode=\''+currencyTypeData+'\' and Pricebook2.name=\''+priceBookName+'\'';
            }
            
            if(String.isNotBlank(minPrice) && String.isNotBlank(maxPrice)){
                where_Clause+=' and unitprice>='+minPrice+' and unitprice<='+maxPrice;
            }
            if(String.isBlank(minPrice) && String.isNotBlank(maxPrice)){
                where_Clause+=' and unitprice<='+maxPrice;
            }
            if(String.isNotBlank(minPrice) && String.isBlank(maxPrice)){ 
                where_Clause+=' and unitprice>='+minPrice;
            }
            if(String.isNotBlank(ISBN) ){
                ISBN = ISBN.replaceAll('-', '');
                ISBN = ISBN.deleteWhitespace();
                where_Clause+=' and Product2.ProductCode=\''+ISBN+'\'';
            }
            if(String.isNotBlank(doi) ){
                doi = doi.deleteWhitespace();
                where_Clause+=' and Product2.doi__c=\''+doi+'\'';
            }
            if(String.isNotBlank(textType) ){
                where_Clause+=' and Product2.Text_Type__c=\''+textType+'\'';
            }
            if(String.isNotBlank(publisherImprint) ){
                where_Clause+=' and Product2.Publisher__c=\''+publisherImprint+'\'';
            }
            if(String.isNotBlank(firstPubYearDataFrom) ){
                where_Clause+=' and Product2.First_Published_Year__c>=\''+firstPubYearDataFrom+'\'';
            }
            if(String.isNotBlank(firstPubYearDataTo) ){
                where_Clause+=' and Product2.First_Published_Year__c<=\''+firstPubYearDataTo+'\'';
            }
            if(String.isNotBlank(title)){
                String productTitle ='%'+title.trim()+'%';
                where_Clause+=' and Product2.Name Like \''+productTitle+'\'';
            }
            if(String.isNotBlank(drmData) && drmData != 'Both'){
                Boolean drmvalue = Boolean.valueOf(drmData);
                where_Clause+=' and Product2.Has_DRM__c ='+drmvalue;
            }
            if(String.isNotBlank(author)){
                String authorEscapeQuot=String.escapeSingleQuotes(author);
                String productauthor ='%'+authorEscapeQuot+'%';
                where_Clause+=' and Product2.Lead_Author_Editor__c Like \''+productauthor+'\'';
            }
            if(netbase !=null && netbase.size()>0){
                String netbaseStr = String.join(netbase, '\',\'');
                netbaseStr = '\''+netbaseStr+'\'';
                
                where_Clause+=' and Product2.Netbase_Classifications__c INCLUDES ('+netbaseStr+')';
            }
            if(subjectList!=null && subjectList.size()>0){
                String subjectListStr = String.join(subjectList, ',');
                subjectListStr = '\''+subjectListStr+'\'';
                where_Clause+=' and Product2.Subject_Classifications__c INCLUDES ('+subjectListStr+')';
            }
            if(String.isNotBlank(mediumData) && mediumData!='Collection'){
                where_Clause+=' and Product2.Version_Type__c = \''+ mediumData + '\'';
            }
            if(String.isNotBlank(mediumData) && mediumData=='Collection'){
                where_Clause+=' and Product2.recordtypeid  = \''+ recordTypeID + '\'';
            }
            if(String.isNotBlank(publcFromDate) && String.isNotBlank(publcToDate)){
                where_Clause+=' and Product2.Publication_Date__c >='+publcFromDate+' and Product2.Publication_Date__c <='+publcToDate;
            }
            if(String.isBlank(publcFromDate) && String.isNotBlank(publcToDate)){
                where_Clause+=' and Product2.Publication_Date__c <='+publcToDate;
            }
            if(String.isNotBlank(publcFromDate) && String.isBlank(publcToDate)){
                where_Clause+=' and Product2.Publication_Date__c >='+publcFromDate;
            }
            query = selectQuery + where_Clause + ' order by '+sortOrderBy+' '+sortBy+' LIMIT 2001'; 
            System.debug('query:='+query);
            System.debug('where_Clause:='+where_Clause);            
            
            if(String.isNotBlank(query)){
                lstPriceBookEntry=Database.query(query);
            }
            
            if(lstPriceBookEntry != null){
                prDetails.total = lstPriceBookEntry.size();
                if(lstPriceBookEntry.size() == 2001){
                    lstPriceBookEntry.clear();
                }
            }
            
            for(PricebookEntry pbe : lstPriceBookEntry ){
                PagedResult pr = new PagedResult();                
                pr.ISBN = pbe.Product2.ISBN__c ;
                pr.title = pbe.Product2.Product_Id_Link__c ;
                pr.Name = pbe.Product2.Name ;
                pr.author = pbe.Product2.Lead_Author_Editor__c ;
                //  pr.pubDate = string.valueOf(pbe.Product2.US_Publication_Date__c) ;
                pr.planPubDate = string.valueOf(pbe.Product2.US_Planned_Publication_Date__c) ;
                //  pr.currAvailability = pbe.Product2.US_Inventory_Status__c ;
                pr.id = pbe.Product2.id ;
                //pr.eBookISBN = pbe.Product2.eBook_ISBN__c ;
                //pr.paperbackISBN = pbe.Product2.Paperback_ISBN__c ;
                //pr.hardbackISBN = pbe.Product2.Hardback_ISBN__c ;
                pr.edition = integer.valueOf(pbe.Product2.Edition_Number__c) ;
                pr.priceBYOUSD = integer.valueOf(pbe.UnitPrice);
                // pr.currencyTypeData = currencyTypeData ;
                prlst.add(pr);
            }
            /*     }else{
sortOrderBy='Name';
List<Product2> productLst=new List<Product2>();

selectQuery = 'Select Id,Name,ISBN__c,Product_Id_Link__c,Edition_Number__c,Lead_Author_Editor__c,US_Publication_Date__c,US_Planned_Publication_Date__c,Version_Type__c,US_Inventory_Status__c,POD__c,eBook_ISBN__c ';
where_Clause = ' From Product2  where IsActive = true and System_ID__c=\''+systemIdVal+'\'';
if(String.isNotBlank(ISBN) ){
ISBN=ISBN.replaceAll('-', '');
where_Clause+=' and ProductCode=\''+ISBN+'\'';
}
if(String.isNotBlank(doi) ){
doi = doi.trim();
where_Clause+=' and doi__c=\''+doi+'\'';
}
if(String.isNotBlank(firstPublishedYearData) ){
where_Clause+=' and First_Published_Year__c=\''+firstPublishedYearData+'\'';
}
if(String.isNotBlank(title)){
String productTitle ='%'+title.trim()+'%';
where_Clause+=' and Name Like \''+productTitle+'\'';
}
if(String.isNotBlank(drmData) && drmData != 'Both'){
Boolean drmvalue = Boolean.valueOf(drmData);
where_Clause+=' and Has_DRM__c ='+drmvalue;
}
if(String.isNotBlank(author)){
String authorEscapeQuot=String.escapeSingleQuotes(author);
String productauthor ='%'+authorEscapeQuot+'%';
where_Clause+=' and Lead_Author_Editor__c Like \''+productauthor+'\'';
}
if(netbase !=null && netbase.size()>0){
where_Clause+=' and Netbase_Classifications__c IN :netbase';
}
if(subjectList!=null && subjectList.size()>0){
//String[] subjectListval = subjectList.split(',');
where_Clause+=' and Subject_Classifications__c IN :subjectList';
}
if(String.isNotBlank(mediumData)){
where_Clause+=' and Version_Type__c = \''+ mediumData + '\'';
}

if(String.isNotBlank(publcFromDate) && String.isNotBlank(publcToDate)){
where_Clause+=' and US_Publication_Date__c>='+publcFromDate+' and US_Publication_Date__c<='+publcToDate;

}
if(String.isBlank(publcFromDate) && String.isNotBlank(publcToDate)){
where_Clause+=' and US_Publication_Date__c<='+publcToDate;
}
if(String.isNotBlank(publcFromDate) && String.isBlank(publcToDate)){
where_Clause+=' and US_Publication_Date__c>='+publcFromDate;
}
queryCount = 'Select count() ' + where_Clause;
query = selectQuery + where_Clause + ' order by '+sortOrderBy+' '+sortBy+' LIMIT 500'; 
// queryCount+=' limit 2001';
System.debug('query:='+query);
System.debug('queryCount:='+queryCount);

if(String.isNotBlank(queryCount)){
//   count = Database.countQuery(queryCount);
prDetails.total = count;
}

if(String.isNotBlank(query)){
productLst=Database.query(query);
}

for(Product2 prd : productLst ){
PagedResult pr = new PagedResult();

pr.ISBN = prd.ISBN__c ;
pr.title = prd.Product_Id_Link__c ;
pr.Name = prd.Name ;
pr.author = prd.Lead_Author_Editor__c ;
pr.pubDate = string.valueOf(prd.US_Publication_Date__c) ;
pr.planPubDate = string.valueOf(prd.US_Planned_Publication_Date__c) ;
pr.currAvailability = prd.US_Inventory_Status__c ;
pr.eBookISBN = prd.eBook_ISBN__c ;
pr.edition = integer.valueOf(prd.Edition_Number__c) ;
//  pr.listPrice = integer.valueOf(pbe.UnitPrice);
pr.currencyTypeData = currencyTypeData ;
prlst.add(pr);
}
}*/
            prDetails.prList = prlst;
        }
        catch(Exception ex){
            system.debug(ex.getLineNumber());
            System.debug('message:='+ex.getMessage());
            throw new AuraHandledException(ex.getMessage());
        }
        
        return prDetails;
    }
    
    
    @Future(callout=true)
    public static void submitDynamicPackageToPCMasynch(String bundleId) {
        //submitDynamicPackageToPCM(bundleId);
        submitDynamicPackageToPCMCommonModel(bundleId);
    }
    
    public static void submitDynamicPackageToPCM(String bundleId) {
        List<TF_PPDProcessController.RuleElement> ruleElementLst = new List<TF_PPDProcessController.RuleElement>();
        List<TF_PPDProcessController.MultiTypeRules> multiTypeRulesLst = new List<TF_PPDProcessController.MultiTypeRules>();
        TF_PPDProcessController.MultiTypeRules multiTypeRules = new TF_PPDProcessController.MultiTypeRules();
        querySaveElement savedQry = new querySaveElement();
        String productType ;
        String jsonStr ;
        Map<String, String> headers = new Map<String,String>(); 
        String dynamicPackageEndpoint = '';
        String searchResponse='';
        Filter filters = new Filter();
        
        system.debug('line674' + bundleId);
        savedQry = parseRuleJson(bundleId);
        
        if(savedQry != null){
            
            if(savedQry.isDynamicUi == 'true'){
                multiTypeRulesLst = savedQry.multiTypeRulesLst ;
                
            }else{
                ruleElementLst = savedQry.ruleElementLst ;
                filters = savedQry.filterObject;
                multiTypeRules.ruleElementLst = ruleElementLst ;
                productType = productType == 'e-Book' ? 'book' : productType;
                multiTypeRules.productType = productType;
                multiTypeRulesLst.add(multiTypeRules);
            }
            
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            dynamicPackageEndpoint = (String) orgSpecificProps.get('Dynamic_Package_API_URL__c');
            
            jsonStr = TF_GenerateJson.GenerateDynamicPackageJson(bundleId, multiTypeRulesLst);
            system.debug('======jsonStr====='+jsonStr);
            
            headers.put('Content-Type', 'application/json');
            
            HttpResponse res = new HttpResponse();
            
            res = TF_PlatformExecuter.execute(dynamicPackageEndpoint,'POST','idtoken', jsonStr, headers, false);
            
            if (res.getStatusCode() == 201 || res.getStatusCode() == 200) { 
                system.debug('=======res body====='+res.getBody());
                Product2 prd = new Product2();
                prd.id = bundleId ;
                prd.APIStatus__c = 'Submit To PCM Success';
                prd.API_Error_Cause__c='Submit To PCM Success';
                update prd ;
            }else{
                system.debug('=======res body====='+res.getBody());
                Product2 prd = new Product2();
                prd.id = bundleId ;
                prd.APIStatus__c = 'Submit To PCM Failed';
                prd.API_Error_Cause__c='Submit To PCM Failed';
                update prd ;
            }
        }
    }
    
    public static void submitDynamicPackageToPCMCommonModel(String bundleId) {
        List<TF_PPDProcessController.RuleElement> ruleElementLst = new List<TF_PPDProcessController.RuleElement>();
        List<TF_PPDProcessController.MultiTypeRules> multiTypeRulesLst = new List<TF_PPDProcessController.MultiTypeRules>();
        TF_PPDProcessController.MultiTypeRules multiTypeRules = new TF_PPDProcessController.MultiTypeRules();
        querySaveElement savedQry = new querySaveElement();
        String productType ;
        String jsonStr ;
        Map<String, String> headers = new Map<String,String>(); 
        String dynamicPackageEndpoint = '';
        String searchResponse='';
        String orgPrdId;
        String uuid;
        Filter filters = new Filter();
        Product2 prdt=[SELECT originalProductId__c,hub_Id__c, RecordTypeId FROM Product2 WHERE id = :bundleID]; 
        orgPrdId=prdt.originalProductId__c;
		uuid=prdt.hub_Id__c;
        system.debug('line737' + bundleId);
        savedQry = parseRuleJson(bundleId);
        
        if(savedQry != null){
            
            if(savedQry.isDynamicUi == 'true'){
                multiTypeRulesLst = savedQry.multiTypeRulesLst ;
                
            }else{
                ruleElementLst = savedQry.ruleElementLst ;
                filters = savedQry.filterObject;
                multiTypeRules.ruleElementLst = ruleElementLst ;
                productType = productType == 'e-Book' ? 'book' : productType;
                multiTypeRules.productType = productType;
                multiTypeRulesLst.add(multiTypeRules);
            }
            
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            dynamicPackageEndpoint = (String) orgSpecificProps.get('Dynamic_Package_API_URL__c');
            
			//SFAL-158 Vikas Varshney
			//Adding condition for Bespoke collection
			Id productBespokeRT = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - BespokeCollection').getRecordTypeId();
			if ( productBespokeRT == prdt.RecordTypeId ) {
				jsonStr = TF_GenerateJson.GenerateCommonModelJsonBespokeLMS(bundleId, null,multiTypeRulesLst);
			} else {
				// jsonStr = TF_GenerateJson.GenerateDynamicPackageJson(bundleId, multiTypeRulesLst);
				jsonStr = TF_GenerateJson.GenerateCommonModelJson(bundleId, null,multiTypeRulesLst);
            }
			system.debug('======jsonStr====='+jsonStr);
            headers.put('Content-Type', 'application/json');
            
            HttpResponse res = new HttpResponse();
             if(orgPrdId==null || orgPrdId==''){
            res = TF_PlatformExecuter.execute(dynamicPackageEndpoint,'POST','idtoken', jsonStr, headers, false);
             }else if(orgPrdId!=null || orgPrdId!=''){
                 dynamicPackageEndpoint=dynamicPackageEndpoint + '/'+ uuid;
                 res = TF_PlatformExecuter.execute(dynamicPackageEndpoint,'PUT','idtoken', jsonStr, headers, false);
            
             }
            if (res.getStatusCode() == 202) { 
                system.debug('=======res body====='+res.getBody());
                Product2 prd = new Product2();
                prd.id = bundleId ;
                prd.APIStatus__c = 'Submit To PCM Success';
                update prd ;
            }else{
                system.debug('=======res body====='+res.getBody());
                Product2 prd = new Product2();
                prd.id = bundleId ;
                prd.APIStatus__c = 'Submit To PCM Failed';
                update prd ;
            }
        }
    }
    
    public static void submitStaticPackageToPCMCommonModel(String bundleId,String jsonRequest) {
        String StaticPackageEndpoint = '';
        String searchResponse='';
        String orgPrdId;
        String uuid;
         Map<String, String> headers = new Map<String,String>(); 
        
        Product2 prdt=[SELECT originalProductId__c,hub_Id__c FROM Product2 WHERE id = :bundleID]; 
        orgPrdId=prdt.originalProductId__c;
        uuid=prdt.hub_Id__c;
        if(!String.isBlank(jsonRequest)){
         TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            StaticPackageEndpoint = (String) orgSpecificProps.get('Dynamic_Package_API_URL__c');
            headers.put('Content-Type', 'application/json');
            
            HttpResponse res = new HttpResponse();
            if(orgPrdId==null || orgPrdId==''){
               res = TF_PlatformExecuter.execute(StaticPackageEndpoint,'POST','idtoken', jsonRequest, headers, false);
 
            }
            else if(orgPrdId!=null || orgPrdId!=''){
             StaticPackageEndpoint=StaticPackageEndpoint + '/'+ uuid;
               res = TF_PlatformExecuter.execute(StaticPackageEndpoint,'PUT','idtoken', jsonRequest, headers, false);
  
            }
                        
            if (res.getStatusCode() == 202) { 
                system.debug('=======res body====='+res.getBody());
                Product2 prd = new Product2();
                prd.id = bundleId ;
                prd.APIStatus__c = 'Submit To PCM Success';
                prd.API_Error_Cause__c='Submit To PCM Success';
                update prd ;
            }else{
                system.debug('=======res body====='+res.getBody());
                Product2 prd = new Product2();
                prd.id = bundleId ;
                prd.APIStatus__c = 'Submit To PCM Failed';
                prd.API_Error_Cause__c='Submit To PCM Failed';
                update prd ;
            }
        }
        else{
           
        }
    }
    
    @AuraEnabled
    public static processedQuery getProductsFromPCM(String bundleId, String queryObj, String savedRule, Integer offsetValue,String offsetCursor, Integer limitValue,String searchCurrency, String getAll, String productType) {
        system.debug('inside getProductsFromPCM');
        String jsonStr = '';
        String productTypeFromQuery ;
        List<TF_PPDProcessController.RuleElement> ruleElementLst = new List<TF_PPDProcessController.RuleElement>();
        List<TF_PPDProcessController.MultiTypeRules> multiTypeRulesLst = new List<TF_PPDProcessController.MultiTypeRules>();
        TF_PPDProcessController.MultiTypeRules multiTypeRules = new TF_PPDProcessController.MultiTypeRules();
        Filter filters = new Filter();
        system.debug('queryObj***' + queryObj);
        processedQuery queryStrAndObj = new processedQuery();
        
        System.debug('queryStrAndObj.columnsLst'+queryStrAndObj.columnsLst);
        
        if(savedRule != 'true'){
            
            queryStrAndObj = processQueryObj(queryObj);
            ruleElementLst = queryStrAndObj.ruleElementLst ; 
            multiTypeRules.ruleElementLst = ruleElementLst ;
            multiTypeRules.productType = productType;
            multiTypeRulesLst.add(multiTypeRules);
        }
        
        if(savedRule == 'true'){
            querySaveElement savedQry = new querySaveElement();
            system.debug('line865' + bundleId);
            savedQry = parseRuleJson(bundleId);
            system.debug('savedQry#SavedRuleisTrue###' +savedQry);
            if(savedQry != null && (savedQry.ruleElementLst != null || savedQry.multiTypeRulesLst != null)){
                if(savedQry.isDynamicUi == 'true'){                    
                    multiTypeRulesLst = savedQry.multiTypeRulesLst ;
                    if(productType == '' || productType == null){
                        productTypeFromQuery = multiTypeRulesLst[0].productType ;
                        productType = productTypeFromQuery;
                    }
                }else{
                    ruleElementLst = savedQry.ruleElementLst ;
                    if(productType == '' || productType == null){
                        filters = savedQry.filterObject;
                        productType = filters.mediumData ;
                        
                    }
                    system.debug('ruleElementLst====='+ruleElementLst);
                    multiTypeRules.ruleElementLst = ruleElementLst ;
                    productType = productType == 'e-Book' ? 'book' : productType;
                    multiTypeRules.productType = productType;
                    multiTypeRulesLst.add(multiTypeRules);
                }
                
            }else{
                List <PagedResult> pr = new List <PagedResult>();
                queryStrAndObj.total = 0;
                queryStrAndObj.prList = pr;
                queryStrAndObj.msg = 'Products not found';
                return queryStrAndObj;  
            }
        }
        
        system.debug('queryStrAndObj.ruleElementLst***' + queryStrAndObj.ruleElementLst);
        //jsonStr = TF_GenerateJson.GenerateQueryJson(bundleId, productType, multiTypeRulesLst, offsetValue, limitValue);
        //queryStrAndObj = callQueryAPI(queryStrAndObj, jsonStr, offsetValue, limitValue,searchCurrency, getAll, bundleId);
        jsonStr = TF_GenerateJson.GenerateQueryJsonNewModel(bundleId, productType, multiTypeRulesLst, offsetValue,offsetCursor, limitValue, 'Collections');
        system.debug('jsonStrfromgetproductfromPCM'+ jsonStr);
        system.debug('offsetCursorValuePPD' + offsetCursor);
        queryStrAndObj = callNewModelQueryAPI(queryStrAndObj, jsonStr, offsetValue, limitValue,searchCurrency, getAll, bundleId);
        
        if(offsetValue > 0){
            queryStrAndObj.ruleElementLst = null;
            queryStrAndObj.queryString = null;
        }
        
        return queryStrAndObj;  
    }
    
    
    private static TF_PPDProcessController.processedQuery callNewModelQueryAPI( TF_PPDProcessController.processedQuery queryStrAndObj, String jsonStr, Integer offsetValue, Integer limitValue,String searchCurrency, String getAll, String bundleId){
        try {
            system.debug('queryStrAndObj##'+queryStrAndObj);
            system.debug('jsonStr##'+jsonStr);
            system.debug('offsetValue##'+offsetValue);
            system.debug('limitValue##'+limitValue);
            system.debug('searchCurrency##'+searchCurrency);
            system.debug('getAll##'+getAll);
            system.debug('bundleId##'+bundleId);
            Boolean isCollectionFree;
            if(bundleId != null){
                Product2 prd=[SELECT id,Is_collection_free__c FROM Product2 WHERE id=: bundleId LIMIT 1];
            	isCollectionFree = prd.Is_collection_free__c; 
            }
 			           
            
            Map<String, String> headers = new Map<String,String>(); 
            List<PagedResult> contentDataList = new  List<PagedResult>();
            String searchAPIEndpoint = '';
            String searchResponse='';
            System.debug('====jsonStr===' + jsonStr);
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            searchAPIEndpoint= (String) orgSpecificProps.get('New_Search_API_URL__c') ;   
            searchAPIEndpoint=searchAPIEndpoint+ '/search';
            headers.put('Content-Type', 'application/json');
            
            HttpResponse resSearch = new HttpResponse();
            
            resSearch = TF_PlatformExecuter.execute(searchAPIEndpoint,'POST','idtoken', jsonStr, headers, false);
            
            List<Bundle_Line_Item__c> lineItms = [SELECT Content_Position__c FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :bundleId ORDER BY Content_Position__c DESC LIMIT 1];
            
            system.debug('searchAPIEndpoint$$$$' + searchAPIEndpoint);
            system.debug('getStatusCode###' +resSearch.getStatusCode());
            System.debug('======== query API Response ========'+ resSearch.getbody());
            system.debug('*****QueryResponse****' + resSearch);
            if (resSearch.getStatusCode() == 201 || resSearch.getStatusCode() == 200) {                     
                System.debug('======== query API Response 200, 201 ========'+ resSearch.getbody());
                searchResponse=resSearch.getbody();
                searchResponse=searchResponse.replace('"currency":', '"X_currency":');
                searchResponse=searchResponse.replace('"type":', '"type_Z":');
                searchResponse=searchResponse.replace('"@id":', '"id_Y":');
                searchResponse=searchResponse.replace('"_id":', '"x_id":'); 
                searchResponse=searchResponse.replace('"limit":', '"limit_Z":');
                searchResponse=searchResponse.replace('"@type":', '"type_W":');
                searchResponse=searchResponse.replace('"group":', '"group_Z":');
                searchResponse=searchResponse.replace('"_status":', '"status":');
                //searchResponse=searchResponse.replace('"product":', '"product_W":');
                //for Author name null issue
                searchResponse=searchResponse.replace('"fullName":null', '"fullName":"null"');
                //Replacing Empty String
                searchResponse=searchResponse.replace('"fullName":""', '"fullName":"null"');
                
                system.debug('searchResponseAfterReplace##' + searchResponse);
                TF_PCMResponseNewModel listRuleBasedSearchResponseDoc = new TF_PCMResponseNewModel(); 
                
                List<TF_PCMResponseNewModel.Data> docData = new List<TF_PCMResponseNewModel.Data>();           
                List<TF_PCMResponseNewModel.Contributors> contributors = new List<TF_PCMResponseNewModel.Contributors>();
                List<TF_PCMResponseNewModel.categories> categories = new List<TF_PCMResponseNewModel.categories>();
                List<TF_PCMResponseNewModel.Classifications> Classifications = new List<TF_PCMResponseNewModel.Classifications>();
                List<TF_PCMResponseNewModel.Prices> prices = new List<TF_PCMResponseNewModel.Prices>();
                List<TF_PCMResponseNewModel.Prices> totalPrices = new List<TF_PCMResponseNewModel.Prices>();
                List<TF_PCMResponseNewModel.Counts> counts = new List<TF_PCMResponseNewModel.Counts>();
                List<TF_PCMResponseNewModel.Permissions> permissions = new List<TF_PCMResponseNewModel.Permissions>();
                List<TF_PCMResponseNewModel.IsPartOf> isPartOfLst = new List<TF_PCMResponseNewModel.IsPartOf>();
                //List<TF_PCMResponseNewModel.impressionLocations> impressionLocations  = new List<TF_PCMResponseNewModel.impressionLocations>();


                TF_PCMResponseNewModel.Product products = new TF_PCMResponseNewModel.Product();
                TF_PCMResponseNewModel.Book books = new TF_PCMResponseNewModel.Book();
                TF_PCMResponseNewModel.creativeWork creativeWork = new TF_PCMResponseNewModel.creativeWork();
                TF_PCMResponseNewModel.scholarlyArticle scholarlyArticle = new TF_PCMResponseNewModel.scholarlyArticle();
                TF_PCMResponseNewModel.collection collection = new TF_PCMResponseNewModel.collection();
                TF_PCMResponseNewModel.identifiers identifiers = new TF_PCMResponseNewModel.identifiers();
                TF_PCMResponseNewModel.Chapter chapter = new TF_PCMResponseNewModel.Chapter();
                
                TF_PCMResponseNewModel.entryVersion entryVersion = new TF_PCMResponseNewModel.entryVersion();
                TF_PCMResponseNewModel.Metadata metadata = new TF_PCMResponseNewModel.Metadata();  
                TF_PCMResponseNewModel.identifiers isPartIdentifiers = new TF_PCMResponseNewModel.identifiers();
                //TF_PCMResponseNewModel.distributionCenter  distributionCenter  = new TF_PCMResponseNewModel.distributionCenter();  
                
                
                listRuleBasedSearchResponseDoc = (TF_PCMResponseNewModel)JSON.deserialize(searchResponse, TF_PCMResponseNewModel.class);
                docData=listRuleBasedSearchResponseDoc.Data;
                system.debug('###docData###' + docData);
                List<PagedResult> pr = new List<PagedResult>(); 
                List<Counts> queryCounts = new List<Counts>();
                String title = '';               
                
                //title
                counts = listRuleBasedSearchResponseDoc.Metadata.Counts ;
                metadata = listRuleBasedSearchResponseDoc.Metadata ;
                queryStrAndObj.offset = metadata.offset ;
                queryStrAndObj.nextPageCursor = metadata.nextPageCursor;
                queryStrAndObj.prevPageCursor = metadata.prevPageCursor;
                queryStrAndObj.lastPageCursor = metadata.lastPageCursor;
                
                totalPrices = metadata.prices ;
                if(counts != null){
                    for(TF_PCMResponseNewModel.Counts count : counts){
                        system.debug('==========count======='+count);
                        if(count.type_Z == 'Total'){
                            queryStrAndObj.total = count.count;
                        }
                        Counts queryCount = new Counts();
                        queryCount.productType = count.type_Z ;
                        queryCount.count = count.count ;
                        queryCounts.add(queryCount);
                    }     
                }
                
                queryStrAndObj.counts = queryCounts ;
                queryStrAndObj.productTypeReturned = metadata.type_Z;                
               list< Bundle_Line_Item__c> listofLineItems = new list< Bundle_Line_Item__c>();    
                for(TF_PCMResponseNewModel.Data dt: docData){ 
                    PagedResult contentData = new PagedResult();
                    decimal priceUSD = 0.0;
                    decimal priceGBP = 0.0;
                    products=dt.product;
                    if(products != null){ 
                        contentData.title =  products.title; 
                        //system.debug('EVTitle: ' + products.title +  '**Id** ' + products.x_id);
                        contentData.name=products.title;
                        contentData.id=products.x_id;
                        contentData.type=products.type_Z;
                        contentData.subType=products.subType;
                        contentData.status=products.status;
                        contributors=products.contributors;
                        categories=products.categories;
                        Classifications=products.Classifications;
                        prices=products.prices;
                        books=products.book;
                        identifiers=products.identifiers;
                        creativeWork=products.creativeWork;
                        scholarlyArticle=products.scholarlyArticle;
                        collection=products.collection;
                        entryVersion=products.entryVersion;
                        chapter=products.chapter;
                        isPartOfLst=products.isPartOf;
                        permissions=products.permissions;
                       // impressionLocations=products.impressionLocations;
 
                        
                        //Adding authors
                        if(contributors != null){
                            contentData.author ='';
                            contentData.editor ='';
                            for(TF_PCMResponseNewModel.Contributors author : contributors){
                                if(author.roles != null && (author.roles.contains('author')|| author.roles.contains('Author'))){
                                    String authorFullName=String.ValueOf(author.fullName);   
                                    if(authorFullName!='null'){
                                        contentData.author = contentData.author + authorFullName + ' || ';
                                        
                                    }
                                }
                                if(author.roles != null && (author.roles.contains('editor')|| author.roles.contains('Editor'))){
                                    String editorFullName=String.ValueOf(author.fullName);   
                                    if(editorFullName!='null'){
                                        contentData.editor = contentData.editor + editorFullName + ' || ';
                                    }
                                }
                                
                            }          //End of contributor loop   
                            //system.debug('++AuthorValue++' + contentData.author);
                            contentData.author = contentData.author != null ? contentData.author.left(contentData.author.length() - 4) : null ;
                            contentData.author = contentData.author; 
                            
                            contentData.editor = contentData.editor != null ? contentData.editor.left(contentData.editor.length() - 4) : null ;
                            contentData.editor = contentData.editor; 
                            
                        }//contributor if
                        
                         if(categories != null){
                            contentData.categorytype ='';
                              contentData.productCategory='';
                            for(TF_PCMResponseNewModel.categories category : categories){
                                contentData.categoryType=category.type_Z;
                                if(category.name=='collection-type'){
                                    contentData.productCategory=category.type_Z;
                                }
                                
                            }
                         }
                        
                        
                        if(Classifications != null){
                            contentData.classificationGroup ='';
                            for(TF_PCMResponseNewModel.Classifications classification : Classifications){
                                contentData.classificationGroup=classification.group_Z;
                            }
                         }
                        
                        // processing pemissions like DRM, OpenAccess etc
                        contentData.openAccess = 'No';
                        contentData.drm = 'DRM Free';

                        if(permissions != null){
                            for(TF_PCMResponseNewModel.Permissions permission : permissions){
                                if(permission.type_Z == 'access' && permission.name == 'open-access'){
                                    contentData.openAccess = 'Yes';
                                }
                                if(permission.type_Z == 'access' && permission.code == 'DRMY'){
                                    contentData.drm = 'DRM Protected';
                                }
                            }
                        }
                        //Adding book block
                        if(books != null){                        
                            contentData.PublicationDate=books.publicationDate;
                            contentData.publisherImprint=books.publisherImprint;
                            contentData.format=books.format;
                            contentData.firstPublishedYear=books.firstPublishedYear;
                            contentData.textType=books.textType;  
                            contentData.planPubDate=books.plannedPublicationDate;
                            contentData.publisherArea=books.publisherArea;
                            contentData.status=books.status; 
                            contentData.edition=books.edition;
                        }
                        if(products.type_Z=='creativeWork'){
                            if(creativeWork != null){                        
                                contentData.PublicationDate=creativeWork.publicationDate;
                                contentData.publisherImprint=creativeWork.publisherImprint;
                                contentData.format=creativeWork.format;
                                
                                
                            }                         
                            
                        }
                        
                        if(products.type_Z=='chapter'){
                            if(chapter!= null){                        
                                contentData.PublicationDate=chapter.publicationDate;
                                contentData.publisherImprint=chapter.publisherImprint;
                                contentData.firstPublishedYear=chapter.firstPublishedYear;
                                contentData.planPubDate=chapter.plannedPublicationDate;  
                                if(isPartOfLst != null){
                                    for(TF_PCMResponseNewModel.IsPartOf ispo : isPartOfLst){
                                        isPartIdentifiers = ispo.identifiers;
                                        if(ispo.type_Z == 'book'){
                                         contentData.isbn = isPartIdentifiers.isbn;
                                        }
                                    }
                                }
                            }                         
                            
                        }
                        if(products.type_Z=='scholarlyArticle'){
                            if(scholarlyArticle != null){                        
                                contentData.PublicationDate=scholarlyArticle.publicationDate;
                                contentData.publisherImprint=scholarlyArticle.publisherImprint;
                                
                            }
                        }
                        
                        if(products.type_Z=='collection'){
                            if(collection != null){                        
                                contentData.PublicationDate=collection.publicationDate;
                                contentData.publisherImprint=collection.publisherImprint;
                                //contentData.type = categories[0].type_Z;
                            }                      
                            
                        }
                        
                        if(products.type_Z=='entryVersion'){
                            if(entryVersion != null){                        
                                contentData.PublicationDate=entryVersion.publicationDate;
                                contentData.publisherImprint=entryVersion.publisherImprint;
                                
                            }
                        }
                        
                        //System.debug(identifiers);
                        if(identifiers != null){                             
                            contentData.doi=identifiers.doi;
                            if(contentData.isbn == null){
                                contentData.isbn=identifiers.isbn;
                            }
                            contentData.dacKey=identifiers.dacKey;
                            contentData.sku=identifiers.sku; 
                            //contentData.editionId=contentData.editionId;                            
                        }       
                        
                         //Adding impressionLocations block
                         
                     /*   if(impressionLocations != null){
                            for(TF_PCMResponseNewModel.impressionLocations imp : impressionLocations){
                                 distributionCenter =imp.distributionCenter;
                                 if(distributionCenter.code=='USNY'){ 
                                    contentData.location=distributionCenter.location;
                                    contentData.Status_US=distributionCenter.status;
                                    contentData.StatusCode=distributionCenter.statuscode;
                                      system.debug('Status_US'+contentData.Status_US);
                                }
                                
                            }
                        }*/
                         
                        
                        
                        //}//end of book if
                        
                        //geting Listprices                    
                        if(prices != null && prices.size() > 0){
                            for(TF_PCMResponseNewModel.Prices listPrice : prices){
                                if(listPrice.priceTypeCode=='BYO' || listPrice.priceTypeCode==null){
                                    
                                    if(listPrice.X_currency == 'USD'){
                                        contentData.priceBYOUSD = Decimal.valueOf(listPrice.price);
                                    }
                                    if(listPrice.X_currency == 'GBP'){
                                        contentData.priceBYOGBP = Decimal.valueOf(listPrice.price);
                                    }
                                } 
                                // for IS prices
                                if(listPrice.priceTypeCode=='IS'){                                   
                                    
                                    if(listPrice.X_currency == 'USD'){                                        
                                        contentData.priceISUSD = Decimal.valueOf(listPrice.price);
                                    }
                                    if(listPrice.X_currency == 'GBP'){                                        
                                        contentData.priceISGBP = Decimal.valueOf(listPrice.price);
                                    }
                                }
                                //for LP prices                            
                                if(listPrice.priceTypeCode=='LP'){                                   
                                    
                                    if(listPrice.X_currency == 'USD'){                                        
                                        contentData.priceLPUSD = Decimal.valueOf(listPrice.price);
                                    }
                                    if(listPrice.X_currency == 'GBP'){                                        
                                        contentData.priceLPGBP = Decimal.valueOf(listPrice.price);
                                    }
                                }
                            }
                        }//end of price if
                        
                        //}//end of products loop
                    }
                    contentDataList.add(contentData);  
                   // list< Bundle_Line_Item__c> listofLineItems = new list< Bundle_Line_Item__c>();  
                    
                    if(getAll == 'true'){
                        integer position = 1;
                        String productRecordtypeId = getRecordtypeId('Product2', 'T&F - Collection');
                        
                        
                        if(lineItms.size() > 0){
                            position = Integer.valueOf(lineItms[0].Content_Position__c) + 1;
                        }
                       
                        
                        String productDoi = contentData.doi +'||'+ bundleId;
                        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
                        lineItem.Product_Bundle_Parent__c = bundleId;
                        lineitem.Journal__c = contentData.title;
                        lineitem.Authors__c = contentData.author;
                        lineitem.Publisher__c=contentData.publisherImprint;
                        lineitem.doi__c = contentData.doi;
                        lineitem.Publication_Date__c = contentData.publicationDate != null ? Date.valueOf(contentData.publicationDate) : null;
                        lineItem.Product_Doi__c =  productDoi;
                        lineItem.Type__c = contentData.type;
                        lineItem.Valid__c = contentData.id != null && contentData.id != '' ? 'true' : 'false';
                        lineitem.uuid__c = contentData.id;
                        lineItem.Source__c = 'PCM';
                        lineItem.IsIncluded__c=true;
                        lineItem.PriceUSD__c = contentData.priceBYOUSD;
                        lineItem.PriceGBP__c = contentData.priceBYOGBP;
                        lineItem.mediaType__c=contentData.format;
                        lineItem.lineItemStatus__c ='IsInsert';
                        
                        if(isCollectionFree){
                            lineItem.Open_access__c = true;
                        }
                        
                        if(contentData.type=='Collection'){                
                            lineItem.Product_Doi__c = contentData.id +'||'+ bundleId;
                            lineitem.doi__c = contentData.id;
                        }
                        
                        
                        lineItem.Content_Position__c  = position++ ;
                        listofLineItems.add(lineItem); 
                    }
                  /*  if(listofLineItems != null && listofLineItems.size() > 0){
                        Database.UpsertResult[] srList = Database.upsert(listofLineItems,bundle_line_item__c.Product_Doi__c,false);
                        system.debug('database updated');
                    }*/
                    
                    
                }//end of data loop
                
                System.debug('====jsonStr===123' + jsonStr);
                system.debug('MetadataContentLastPage123*****' + offsetValue);
                if(listofLineItems != null && listofLineItems.size() > 0){
                        Database.UpsertResult[] srList = Database.upsert(listofLineItems,bundle_line_item__c.Product_Doi__c,false);
                        system.debug('database updated');
                    }
                
                pr = contentDataList; 
                queryStrAndObj.prList = pr ;
                
                //Set total price
                /*if(totalPrices != null && totalPrices.size() > 0){
for(TFRuleBasedSearchResponseNewModel.Prices listPrice : totalPrices){
if(listPrice.priceTypeCode=='BYO'){
if(listPrice.X_currency == 'USD' && listPrice.priceTypeCode=='BYO' ){
queryStrAndObj.totalPriceUSD =  Decimal.valueOf(listPrice.price);
}
if(listPrice.X_currency == 'GBP' && listPrice.priceTypeCode=='BYO' ){
queryStrAndObj.totalPriceGBP =  Decimal.valueOf(listPrice.price);

}
}                     
}
}*/
                
                queryStrAndObj.msg = 'Success'; 
                System.debug('======== query API Response ========'+ resSearch.getbody());
                system.debug('queryStrAndObj.prList****' + queryStrAndObj.prList);
                return queryStrAndObj;
            }
            else if(resSearch.getStatusCode() == 404 || resSearch.getStatusCode() == 400){             
                queryStrAndObj.total=0;
                queryStrAndObj.prList = null;
                queryStrAndObj.msg = 'Products not found';
                return queryStrAndObj;
            }else if(String.ValueOf(resSearch.getStatusCode()).StartsWith('50') ){
                queryStrAndObj.total=0;
                queryStrAndObj.prList = null;
                queryStrAndObj.msg = 'Server Not Responding';
                return queryStrAndObj;
            }
            system.debug('QueryResultPCM******' + queryStrAndObj);
            //system.debug('QueryResultData%%%%%%%%' + queryStrAndObj.nextPageCursor);
            return queryStrAndObj;
        }
        catch(Exception e)
        {
            system.debug('e.getMessage()');
            return queryStrAndObj;
        }
        
    }
    
    private static TF_PPDProcessController.processedQuery callCountsAPI( TF_PPDProcessController.processedQuery queryStrAndObj, String jsonStr, Integer offsetValue, Integer limitValue,String searchCurrency, String getAll, String bundleId){
        Map<String, String> headers = new Map<String,String>(); 
        List<PagedResult> contentDataList = new  List<PagedResult>();
        String searchAPIEndpoint = '';
        String searchResponse='';
        System.debug('====CountjsonStr===' + jsonStr);
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        
        searchAPIEndpoint= (String) orgSpecificProps.get('New_Search_API_URL__c')+'/search';        
        headers.put('Content-Type', 'application/json');        
        HttpResponse resSearch = new HttpResponse();        
        resSearch = TF_PlatformExecuter.execute(searchAPIEndpoint,'POST','idtoken', jsonStr, headers, false); 
        
        List<Bundle_Line_Item__c> lineItms = [SELECT Content_Position__c FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :bundleId ORDER BY Content_Position__c DESC LIMIT 1];
        
        system.debug('searchAPIEndpoint$$$$' + searchAPIEndpoint);
        system.debug('getStatusCode###' +resSearch.getStatusCode());
        System.debug('======== query API Response ========'+ resSearch.getbody());
        
        if (resSearch.getStatusCode() == 201 || resSearch.getStatusCode() == 200) {                     
            System.debug('======== query API Response 200, 201 ========'+ resSearch.getbody());
            searchResponse=resSearch.getbody();
            searchResponse=searchResponse.replace('"currency":', '"X_currency":');
            searchResponse=searchResponse.replace('"type":', '"type_Z":'); 
            
            system.debug('searchResponseAfterReplace##' + searchResponse);
            TFCountsResponse listCountsResponseDoc = new TFCountsResponse(); 
            
            List<TFCountsResponse.Prices> prices = new List<TFCountsResponse.Prices>();
            List<TFCountsResponse.Prices> totalPrices = new List<TFCountsResponse.Prices>();
            List<TFCountsResponse.Counts> counts = new List<TFCountsResponse.Counts>();
            TFCountsResponse.Metadata metadata = new TFCountsResponse.Metadata();                     
            
            
            listCountsResponseDoc = (TFCountsResponse)JSON.deserialize(searchResponse, TFCountsResponse.class);
            system.debug('listRuleBasedSearchResponseDoc##'+listCountsResponseDoc);
            List<PagedResult> pr = new List<PagedResult>(); 
            List<Counts> queryCounts = new List<Counts>();
            
            counts = listCountsResponseDoc.Metadata.Counts ;
            totalPrices = listCountsResponseDoc.Metadata.prices ;
            prices=listCountsResponseDoc.Metadata.prices;
            
            metadata = listCountsResponseDoc.Metadata ;
            //totalPrices = metadata.prices ;
            for(TFCountsResponse.Counts count : counts){
                system.debug('==========count======='+count);
                if(count.type_Z == 'Total'){
                    queryStrAndObj.total = count.count;
                }
                Counts queryCount = new Counts();
                queryCount.productType = count.type_Z ;
                queryCount.count = count.count ;
                queryCounts.add(queryCount);
            }     
            
            /*for(TFCountsResponse.Prices price : prices){

}*/
            
            queryStrAndObj.counts = queryCounts ;
            //queryStrAndObj.productTypeReturned = metadata.type_Z;
            
            
            
            
            //pr = contentDataList; 
            //queryStrAndObj.prList = pr ;
            System.debug('totalPricestotalPricestotalPrices##' +totalPrices);
            //Set total price
            if(totalPrices != null && totalPrices.size() > 0){
                for(TFCountsResponse.Prices listPrice : totalPrices){
                    if(listPrice.priceTypeCode=='BYO'){
                        if(listPrice.X_currency == 'USD' && listPrice.priceTypeCode=='BYO' ){
                            queryStrAndObj.totalPriceUSD =  Decimal.valueOf(listPrice.price);
                        }
                        if(listPrice.X_currency == 'GBP' && listPrice.priceTypeCode=='BYO' ){
                            queryStrAndObj.totalPriceGBP =  Decimal.valueOf(listPrice.price);
                            
                        }
                    }                     
                }
            }
            
            queryStrAndObj.msg = 'Success'; 
            return queryStrAndObj;
        }
        else if(resSearch.getStatusCode() == 404 || resSearch.getStatusCode() == 400){             
            queryStrAndObj.total=0;
            queryStrAndObj.prList = null;
            queryStrAndObj.msg = 'Products not found';
            return queryStrAndObj;
        }else if(String.ValueOf(resSearch.getStatusCode()).StartsWith('50') ){
            queryStrAndObj.total=0;
            queryStrAndObj.prList = null;
            queryStrAndObj.msg = 'Server Not Responding';
            return queryStrAndObj;
        }
        return queryStrAndObj;
    }
    private static processedQuery processQueryObj(String queryObj){
        System.debug('queryObj'+queryObj);
        List<String> fullQuerlListStr = new  List<String>();
        List<String> fullStrWithSeparatorLst = new  List<String>();
        
        MAP<Integer,String> queryStrMap = new  MAP<Integer,String>();
        MAP<Integer,List<RuleElement>> queryElementMap = new  MAP<Integer,List<RuleElement>>();
        List<List<RuleElement>> queryElementLstOfLst = new  List<List<RuleElement>>();
        List<RuleElement> queryElementLst = new List<RuleElement>();
        MAP<Integer,RuleElement> tempQueryElementMAP = new MAP<Integer,RuleElement>();
        List<RuleElement> tempQueryElementLst = new List<RuleElement>();
        processedQuery returnObj = new processedQuery();
        
        String fullStr = '';
        String fullStrWithSeparator = '';
        
        List<QueryObject> QueryObjectList = (List<QueryObject>) JSON.deserialize(queryObj, List<QueryObject>.class);
        if(QueryObjectList != null && QueryObjectList.size() > 0){
            
            Map<String, QueryApiMapping__c> qryFldLblAndAttrMap = new Map<String, QueryApiMapping__c>();
            
            qryFldLblAndAttrMap = QueryApiMapping__c.getAll();
            
            Integer counter = 1 ;
            for(QueryObject obj : QueryObjectList){
                
                RuleElement ruleEle = new RuleElement();
                List<RuleElement> ruleElementList = new List<RuleElement>();
                
                List<String> QryTypeList = new  List<String>();
                String QryStr = '';
                
                if(obj.type == 'criteria'){
                    QryStr = obj.name +' '+ obj.operatior +' ';
                    String valueStr = '';
                    if(obj.value.size() > 0){
                        for(String valStr : obj.value){
                            QryStr = QryStr + valStr + ',';
                            valueStr = valueStr + valStr + ',';
                        }
                        QryStr = QryStr.left(QryStr.length() - 1);
                        valueStr = valueStr.left(valueStr.length() - 1);
                    }else{
                        QryStr = QryStr + ' ()';
                    }
                    
                    ruleEle.type = 'criteria';
                    ruleEle.attribute = qryFldLblAndAttrMap != null && qryFldLblAndAttrMap.get(obj.name) != null && qryFldLblAndAttrMap.get(obj.name).Active__c ? qryFldLblAndAttrMap.get(obj.name).PCM_Query_Path__c : obj.name ;
                    ruleEle.relationship = obj.operatior;
                    ruleEle.value = valueStr;
                }
                
                if(obj.type == 'logical'){
                    QryStr = obj.logicalOpp;
                    ruleEle.type = 'logical';
                    ruleEle.value = obj.logicalOpp;
                }
                
                QryStr = '#-#-#'+ QryStr +'#-#-#';
                
                ruleElementList.add(ruleEle);
                queryElementMap.put(counter,ruleElementList);
                queryStrMap.put(counter,QryStr);
                counter++ ;
            }
            
            for(QueryObject obj : QueryObjectList){
                if(obj.type == 'logical'){
                    
                    List<RuleElement> ruleEleList = new List<RuleElement>();
                    String leftStart =  queryStrMap.get(obj.logicalOppStartPosLeft);
                    String leftEnd =  queryStrMap.get(obj.logicalOppEndPosLeft);
                    String rightStart =  queryStrMap.get(obj.logicalOppStartPosRight);
                    String rightEnd =  queryStrMap.get(obj.logicalOppEndPosRight);
                    if(leftStart != null){
                        RuleElement ruleEle = new RuleElement();
                        ruleEleList = queryElementMap.get(obj.logicalOppStartPosLeft);
                        ruleEle.type = 'separator';
                        ruleEle.value = 'BEGIN';
                        ruleEleList.add(0,ruleEle);
                        queryElementMap.put(obj.logicalOppStartPosLeft,ruleEleList);
                        
                        queryStrMap.put(obj.logicalOppStartPosLeft, '(#-#-#'+queryStrMap.get(obj.logicalOppStartPosLeft));
                    }
                    if(leftEnd != null){
                        RuleElement ruleEle = new RuleElement();
                        ruleEleList = queryElementMap.get(obj.logicalOppEndPosLeft);
                        ruleEle.type = 'separator';
                        ruleEle.value = 'END';
                        ruleEleList.add(ruleEle);
                        queryElementMap.put(obj.logicalOppEndPosLeft,ruleEleList);
                        
                        queryStrMap.put(obj.logicalOppEndPosLeft, queryStrMap.get(obj.logicalOppEndPosLeft)+'#-#-#)');
                    }                
                    if(rightStart != null){
                        RuleElement ruleEle = new RuleElement();
                        ruleEleList = queryElementMap.get(obj.logicalOppStartPosRight);
                        ruleEle.type = 'separator';
                        ruleEle.value = 'BEGIN';
                        ruleEleList.add(0,ruleEle);
                        queryElementMap.put(obj.logicalOppStartPosRight,ruleEleList);
                        
                        queryStrMap.put(obj.logicalOppStartPosRight, '(#-#-#'+queryStrMap.get(obj.logicalOppStartPosRight));
                    }             
                    if(rightEnd != null){
                        RuleElement ruleEle = new RuleElement();
                        ruleEleList = queryElementMap.get(obj.logicalOppEndPosRight);
                        ruleEle.type = 'separator';
                        ruleEle.value = 'END';
                        ruleEleList.add(ruleEle);
                        queryElementMap.put(obj.logicalOppEndPosRight,ruleEleList);
                        
                        queryStrMap.put(obj.logicalOppEndPosRight, queryStrMap.get(obj.logicalOppEndPosRight)+'#-#-#)');
                    }
                }
            }
            system.debug('queryStrMap2==='+queryStrMap);
            
            fullStrWithSeparatorLst = queryStrMap.values();
            queryElementLstOfLst = queryElementMap.values();
        }
        
        
        for(String qryStrSep : fullStrWithSeparatorLst){
            fullStrWithSeparator = fullStrWithSeparator + qryStrSep ;
        }
        
        for(List<RuleElement> ruleEleLst : queryElementLstOfLst){
            queryElementLst.addAll(ruleEleLst);
        }
        
        Integer count = 0;
        for(RuleElement qryEle : queryElementLst){
            tempQueryElementMAP.put(count,qryEle);
            count ++;
        }
        //The following code is to group prices togather.
        boolean containsPrice = false ;
        for(integer i = 0 ; i < queryElementLst.size() ; i++){
            string attr = queryElementLst[i].attribute ;
            if(queryElementLst[i].type == 'criteria' && attr.startsWithIgnoreCase('prices.')){
                containsPrice = true ;
                tempQueryElementMAP.remove(i);
                if(i != queryElementLst.size()-1){
                    tempQueryElementMAP.remove(i+1);
                }
            }
        }
        tempQueryElementLst = tempQueryElementMAP.values();
        
        RuleElement ruleEleStart = new RuleElement();
        ruleEleStart.type = 'separator';
        ruleEleStart.value = 'BEGIN';
        
        RuleElement ruleEleEnd = new RuleElement();
        ruleEleEnd.type = 'separator';
        ruleEleEnd.value = 'END';
        
        if(containsPrice){
            
            tempQueryElementLst.add(ruleEleStart) ;
            
            for(integer i = 0 ; i < queryElementLst.size() ; i++){
                string attr = queryElementLst[i].attribute ;
                if(queryElementLst[i].type == 'criteria' && attr.startsWithIgnoreCase('prices.')){
                    tempQueryElementLst.add(queryElementLst[i]);
                    if(i != queryElementLst.size()-1){
                        tempQueryElementLst.add(queryElementLst[i+1]);
                    }
                }
            }
            
            tempQueryElementLst.add(ruleEleEnd);
            queryElementLst.clear();
            queryElementLst = tempQueryElementLst ;
        }
        if(queryElementLst != null && queryElementLst.size() > 0){
            queryElementLst.add(0,ruleEleStart);
            queryElementLst.add(ruleEleEnd);  
        }else if(queryElementLst != null){
            queryElementLst.add(ruleEleStart);
            queryElementLst.add(ruleEleEnd);  
        }
        
        
        fullQuerlListStr = fullStrWithSeparator.split('#-#-#');
        for(String str : fullQuerlListStr){
            if(str.trim() != null && str.trim() != '' ){
                fullStr = fullStr + str.trim() +' ';
            }
        }
        system.debug('fullStrWithSeparator'+ fullStrWithSeparator);
        system.debug('fullQuerlList'+ fullQuerlListStr);
        system.debug('fullStr'+ fullStr);
        system.debug('queryElementLst'+ queryElementLst);
        system.debug('queryElementLstSTRING'+ JSON.serialize(queryElementLst)); 
        
        returnObj.queryString = fullStr;
        returnObj.ruleElementLst = queryElementLst;
        
        return returnObj ;
    }
    
    @AuraEnabled
    public static PagedResultDetails getBundleTitles(String bundleID) {
        Product2 product = [SELECT id, Name, Type_of_Bundle__c, Dynamic_Collection_Criteria__c FROM Product2 WHERE id = :bundleID limit 1];
        if(product.Type_of_Bundle__c == 'Static') {
            return getStaticBundleTitles(bundleID);
        } else if (product.Type_of_Bundle__c == 'Dynamic') {
            return getDynamicBundleTitles(product.Dynamic_Collection_Criteria__c);
        } 
        else {
            return getStaticBundleTitles(bundleID);
        }       
    }
    
    @AuraEnabled
    public static String addProductsToCollection(String parentProductID, String productID) {
        integer position = 1;
        
        List<Bundle_Line_Item__c> lineItms = [SELECT Content_Position__c FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :parentProductID ORDER BY Content_Position__c DESC LIMIT 1];
        
        if(lineItms.size() > 0){
            position = Integer.valueOf(lineItms[0].Content_Position__c) + 1;
        }
        
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Product_Bundle_Parent__c = parentProductID;
        lineItem.Product__c = productID;
        lineItem.Product_Doi__c =  productID+'||'+ parentProductID;
        lineItem.Content_Position__c  = position++ ;
        insert lineItem;
        lineItem = [SELECT id, Product__r.name from Bundle_Line_Item__c WHERE id = :lineItem.Id];
        return lineItem.Product__r.name + ' has been added into Collection';
    }
    
    @AuraEnabled
    public static String addMultipleProductsToCollection(String parentProductID, List<String>listProductIds) {
        String returnMsg='';
        String IsIncluded='true';
        returnMsg = addMultipleProductsToCollection(parentProductID,listProductIds, IsIncluded);
        return returnMsg;
        
    }
    
    @AuraEnabled
    public static String addMultipleProductsToCollection(String parentProductID, List<String>listProductIds, String IsInclude) {
        
        Try{
            list< Bundle_Line_Item__c> listofLineItems = new list< Bundle_Line_Item__c>();  
            integer position = 1;
            List<product2> prdLst = new List<product2>();
            String productRecordtypeId = getRecordtypeId('Product2', 'T&F - Collection');
            prdLst = [SELECT id,Name,Author__c, Hub_Id__c,Publication_Date__c,doi__c,recordtypeid,Publisher__c  FROM product2 WHERE id in :listProductIds];
            
            List<Bundle_Line_Item__c> lineItms = [SELECT Content_Position__c FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :parentProductID ORDER BY Content_Position__c DESC LIMIT 1];
            
            if(lineItms.size() > 0){
                position = Integer.valueOf(lineItms[0].Content_Position__c) + 1;
            }
            
            for (product2 strProduct : prdLst) {
                String productDoi = strProduct.doi__c +'||'+ parentProductID;
                Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
                lineItem.Product_Bundle_Parent__c = parentProductID;
                lineitem.Journal__c = strProduct.Name;
                lineitem.Authors__c = strProduct.Author__c;
                lineitem.Publisher__c=strProduct.Publisher__c;
                lineitem.doi__c = strProduct.doi__c;
                // lineitem.uuid__c = strProduct.Hub_Id__c;
                lineitem.Publication_Date__c = strProduct.Publication_Date__c;
                lineItem.Product_Doi__c =  productDoi;
                lineItem.Product__c = strProduct.id;
                lineItem.Source__c = 'Salesforce';
                if(IsInclude=='Include'){
                    lineItem.IsIncluded__c=true;
                }
                else if (IsInclude=='Exclude'){
                    lineItem.IsIncluded__c=false;
                }
                
                if(strProduct.recordtypeid==productRecordtypeId){                
                    lineItem.Type__c = 'Collection';
                    lineItem.Valid__c = strProduct.Hub_Id__c != null && strProduct.Hub_Id__c != '' ? 'true' : 'false';
                    lineitem.uuid__c = strProduct.Hub_Id__c;
                    lineItem.Product_Doi__c = strProduct.Hub_Id__c +'||'+ parentProductID;
                    lineitem.doi__c = strProduct.Hub_Id__c;
                    
                }
                else if(strProduct.recordtypeid!=productRecordtypeId){
                    lineItem.Type__c = 'Book';
                    lineItem.Valid__c ='';
                }
                
                lineItem.Content_Position__c  = position++ ;
                listofLineItems.add(lineItem); 
            }
            system.debug('listofLineItems'+listofLineItems);            
            Database.UpsertResult[] srList = Database.upsert(listofLineItems,bundle_line_item__c.Product_Doi__c,false);
            
            /* for (Database.SaveResult sr : srList) {
if (sr.isSuccess()) {
// Operation was successful, so get the ID of the record that was processed
//System.debug('Successfully inserted record: ' + sr.getId());
}
else {
// Operation failed, so get all errors
for(Database.Error err : sr.getErrors()) {
System.debug('The following error has occurred.');
System.debug(err.getStatusCode() + ': ' + err.getMessage());
System.debug('fields that affected this error: ' + err.getFields());
}
}
}*/
            
            return 'Selected Products have been added into the Collection';
        }
        catch(Exception ex){
            System.debug(ex.getMessage());
            return 'There was an issue in adding the products, please try later or contact SFDC system admin';
        }        
        
    }
    
    @AuraEnabled
    public static String deleteProducts(String parentProductID, List<String>listProductIds) {
        list< Bundle_Line_Item__c> listofLineItems = [SELECT id, name FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :parentProductID AND Product__c = :listProductIds];
        System.debug('listofLineItems'+listofLineItems);
        DELETE listofLineItems;
        return 'Selected Products have been deleted from the Collection';
    }
    
    @AuraEnabled
    public static String deleteAllProducts(String parentProductID) {
        Integer totalRecords;
        String msg = 'No records to delete';
        
        totalRecords = [SELECT count() FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :parentProductID];
        list< Bundle_Line_Item__c> listofLineItems = [SELECT id, name FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :parentProductID and IsUnsilo__c = false limit 10000];
        
        if(totalRecords <= 10000 && totalRecords > 0 && listofLineItems.size() > 0){
            msg = 'All Products have been deleted from the Collection';
        }else if(totalRecords > 10000 && listofLineItems.size() > 0){
            msg = '10000 Products have been deleted from the Collection, click the buton again to delete the remaining products';
        }
        
        if(listofLineItems.size() > 0){
            delete listofLineItems;
            return msg;
        }
        
        return msg;
        
    }
    
    @AuraEnabled
    public static String deleteAllProductsAndContents(String parentProductID) {
        Integer totalRecords;
        String msg = 'No records to delete';
        
        totalRecords = [SELECT count() FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :parentProductID];
        list< Bundle_Line_Item__c> listofLineItems = [SELECT id, name FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :parentProductID];
        
        if(totalRecords <= 10000 && totalRecords > 0 && listofLineItems.size() > 0){
            delete listofLineItems;
        }else if(totalRecords > 10000 && listofLineItems.size() > 0){
            List<String> lineItmsToDelete;
            for(Bundle_Line_Item__c bdl:listofLineItems){            
                lineItmsToDelete.add(bdl.Id);
            }
            deleteLineitems(lineItmsToDelete);
        }
        
        
        return msg;
        
    }
    
    @AuraEnabled
    public static String deleteCollection(String parentProductID) {
        String msg = 'No records to delete';
        Integer totalRecords;
        try{
            deletePriceBookEntry(parentProductID);
            Product2 prd=[SELECT id, name FROM Product2 WHERE id = :parentProductID];
            delete prd;
            msg='Success';
            return msg;
        }catch (exception ex){
            system.debug(ex.getMessage());
            return 'Fail';
        }
        
    }
    
    /*@AuraEnabled
public static String updateDynamicCollectionCrtieria(String productID, String filters) {
Product2 dynamicCollectionProduct = [SELECT Id, Name, Dynamic_Collection_Criteria__c from Product2 WHERE Id = :productID limit 1];
dynamicCollectionProduct.Dynamic_Collection_Criteria__c = filters;
UPDATE dynamicCollectionProduct;
return 'Upated successfully';
} */
    
    /* @AuraEnabled
public static void deleteProductFromStaticCollection(String parentProductID, String productID) {
Bundle_Line_Item__c lineItem  = [SELECT id, name FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :parentProductID AND Product__c = :productID limit 1];
DELETE lineItem;        
}*/
    
    private static PagedResultDetails getStaticBundleTitles(String bundleID) {
        /*    PagedResult r =  new PagedResult();
// @Harish Would you please review this query
r.total = [SELECT count() FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :bundleID AND IsUnsilo__c = false];
r.products = [SELECT id, Name, Lead_Author_Editor__c, Product_Publisher__c, ISBN__c,Product_Id_Link__c FROM 
product2 WHERE id IN 
(SELECT Product__c 
FROM Bundle_Line_Item__c
WHERE Product_Bundle_Parent__c = :bundleID)];        
return r;    */
        return null;
    }
    
    private static PagedResultDetails getDynamicBundleTitles(String filters) {
        return getProducts(filters);
    }
    
    @AuraEnabled
    public static FileUploadDetails addListOfPrductsViaFile(String parentProductID, String fileInpt, String uniqueId,String CollectionType, String IsInclude) {        
        
        fileInpt = EncodingUtil.urlDecode(fileInpt, 'UTF-8');
        Blob fileBlob;
        String fileBody;
        List<String> searchStrings = new List<String>();
        List<Id> productIdList = new List<Id>();         
        Map<Id,Product2> productsMap;
        Map<String,Product2> productsISBNMap ;
        Map<Id,Product2> productsResultMap;
        Set<String> setOfIds = new Set<String>();
        String msg='';
        String errMsg='';
        String validVersionType='e-Book';
        FileUploadDetails filedtls = new FileUploadDetails();
        System.debug('===IsInclude===' + IsInclude);
        try{
            //msg = 'No titles were added as no IDs were recognized.';
            filedtls.Msg=msg;
            fileBlob = EncodingUtil.base64Decode(fileInpt);
            fileBody = fileBlob.toString();
            fileBody = fileBody.replace('-','');
            fileBody = fileBody.replace('\n',',');
            fileBody = fileBody.deleteWhitespace();
            searchStrings = fileBody.split(',');
            
            
            if((searchStrings != null && searchStrings.size() > 0 && searchStrings.size() <= 5000 &&  CollectionType=='Manual Curation')||(searchStrings != null && searchStrings.size() > 0 && searchStrings.size() <= 500 &&  CollectionType=='Rule Based') ){
                setOfIds.addAll(searchStrings);  
                filedtls.totalRecs=setOfIds.size();
                
                if(uniqueId == 'SFDCId'){                
                    productsMap =  new Map<Id,Product2>([SELECT Id, ISBN__c FROM Product2 WHERE isactive=true and version_type__c =:validVersionType and doi__c!=null and id in : setOfIds]);  
                }else if(uniqueId == 'ISBN'){            
                    productsISBNMap =  new Map<String,Product2>([SELECT Id,ISBN__c,productcode FROM Product2 WHERE isactive=true and version_type__c =:validVersionType and doi__c!=null and productcode in : setOfIds]);
                }            
                
            }else if(searchStrings != null && searchStrings.size() > 5000  && CollectionType=='Manual Curation'){            
                msg = 'Number of rows/Ids exeeds 5000, please upload a file containing less than 5000 rows/Ids';
                filedtls.Msg=msg;
                return filedtls;
            }  
            
            else if(searchStrings != null && searchStrings.size() > 500 && CollectionType=='Rule Based'){            
                msg = 'Number of rows/Ids exeeds 500, please upload a file containing less than 500 rows/Ids';
                filedtls.Msg=msg;
                return filedtls;
            }  
            
            //checking for products not found for SFDCID
            if(productsMap != null && productsMap.size() > 0 && uniqueId == 'SFDCId'){
                list<String>inValidRecord=new list<String>();
                
                if (setOfIds.size()!=productsMap.size()){                    
                    List<Id> IdList = new List<Id>();
                    IdList.addAll(productsMap.keySet());              
                    
                    for(String str : setOfIds){                     
                        if(IdList.contains(str)==false){
                            inValidRecord.add(str);
                        } 
                    }
                }
                
                if(inValidRecord.size()>0 && uniqueId == 'SFDCId'){
                    String inValStr = '';
                    for(String str : inValidRecord){
                        inValStr = inValStr + str + '<br>';
                    }
                    errMsg='Records with following SFDC Ids could not be uploaded in salesforce.<br> <br>'+ inValStr;
                    filedtls.errMsg=errMsg;
                }
                
                //filedtls.successRecCnt= filedtls.totalRecs-inValidRecord.size();
                filedtls.successRecCnt= filedtls.totalRecs-inValidRecord.size();
                filedtls.formatErrMsg='Total'+' '+ filedtls.successRecCnt+ ' ' + 'records have been uploaded succesfully out of' + ' ' + filedtls.totalRecs+ ' ' + 'unique records';
                
            }
            else if(uniqueId == 'SFDCId' && productsMap.size() == 0){            
                filedtls.formatErrMsg='No records have been uploaded, Please check your file.';
                Return filedtls;
            }
            
            //checking for products not found for ISBNs
            else if(productsISBNMap!= null && productsISBNMap.size() > 0 && uniqueId == 'ISBN'){
                list<String>inValidIsbnRecord=new list<String>();
                list<String>lstProductCode=new list<String>();
                list<Product2>lstPrd=new List<product2>();
                lstPrd=productsISBNMap.values();
                for(product2 p :lstPrd){
                    lstProductCode.add(p.productcode);
                }
                
                
                if (setOfIds.size()!=productsISBNMap.size()){      
                    for(String str : setOfIds){                    
                        if(lstProductCode.contains(str)==false){                     
                            inValidIsbnRecord.add(str);
                        } 
                    }
                }
                
                if(inValidIsbnRecord.size()>0 && uniqueId == 'ISBN'){
                    String inValISBN = '';
                    for(String str : inValidIsbnRecord){
                        inValISBN = inValISBN + str + '<br>';
                    }
                    
                    errMsg = 'Records with following ISBNs could not be uploaded in salesforce. <br><br>' + inValISBN;
                    filedtls.errMsg=errMsg;
                }          
                filedtls.successRecCnt= filedtls.totalRecs-inValidIsbnRecord.size();
                filedtls.formatErrMsg='Total'+' '+ filedtls.successRecCnt+ ' ' + 'records have been uploaded succesfully out of' + ' ' + filedtls.totalRecs+ ' ' + 'unique records';
                
            } 
            else if (uniqueId == 'ISBN' && productsISBNMap.size() == 0){
                filedtls.formatErrMsg='No records have been uploaded, Please check your file.';
                Return filedtls;
            }
            
            
            //Adding the products for SFDCID
            if(productsMap != null && productsMap.size() > 0 && uniqueId == 'SFDCId'){
                productIdList.addAll(productsMap.keySet());
                msg = addMultipleProductsToCollection(parentProductID, productIdList);
                filedtls.Msg=msg;
                System.debug('msg'+msg);
            }
            
            //Adding the products for ISBN
            if(productsISBNMap != null && productsISBNMap.size() > 0 && uniqueId == 'ISBN' && CollectionType=='Manual Curation'){               
                // productsResultMap =  new Map<Id,Product2>([SELECT Id,ISBN__c FROM Product2 WHERE isactive=true  and productcode in : setOfIds]);
                list<Id>lstProductId=new list<Id>();
                list<Product2>lstPrd=new List<product2>();
                lstPrd=productsISBNMap.values();
                for(product2 p :lstPrd){
                    lstProductId.add(p.Id);
                }                               
                
                msg = addMultipleProductsToCollection(parentProductID, lstProductId);
                filedtls.Msg=msg;
                System.debug('msg'+msg);
            }
            
            
            //Adding the inclusions/ exclusions for ISBN for Dynamic Collection
            if(productsISBNMap != null && productsISBNMap.size() > 0 && uniqueId == 'ISBN' && CollectionType=='Rule Based'){               
                // productsResultMap =  new Map<Id,Product2>([SELECT Id,ISBN__c FROM Product2 WHERE isactive=true  and productcode in : setOfIds]);
                list<Id>lstProductId=new list<Id>();
                list<Product2>lstPrd=new List<product2>();
                lstPrd=productsISBNMap.values();
                for(product2 p :lstPrd){
                    lstProductId.add(p.Id);
                }
                
                msg = addMultipleProductsToCollection(parentProductID, lstProductId,IsInclude);
                filedtls.Msg=msg;
                System.debug('msg'+msg);
            }
            
            return filedtls;
        }
        Catch(Exception ex){
            System.debug(ex.getMessage());
            msg='There was an issue in uploading the products, please try later or contact SFDC system admin';
            filedtls.msg=msg;
            return filedtls;
        }
        
    }
    // for PriceBookEntry
    @AuraEnabled
    public static String addPriceBookEntry(String parentProductID, Decimal unitPriceInGBP, Decimal unitPriceInUSD,Decimal discountedPriceInGBP, Decimal discountedPriceInUSD,Boolean IsActive) {   
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
        PricebookEntry pbeInGBP;
        PricebookEntry pbeInUSD;
        
        if(IsActive==false){
         pbeInGBP= insertPricebookEntry(parentProductID,'GBP',standardPriceBookId,unitPriceInGBP);
         pbeInUSD= insertPricebookEntry(parentProductID,'USD',standardPriceBookId,unitPriceInUSD);
        }else if(IsActive==true){
         pbeInGBP= insertPricebookEntryWithActiveFlag(parentProductID,'GBP',standardPriceBookId,unitPriceInGBP);
         pbeInUSD= insertPricebookEntryWithActiveFlag(parentProductID,'USD',standardPriceBookId,unitPriceInUSD);
        }
        
        if(! test.isrunningtest()&& IsActive==false){
            PricebookEntry tfpbeInGBP= insertPricebookEntry(parentProductID,'GBP',tfPricebookId,unitPriceInGBP);
            PricebookEntry tfpbeInUSD= insertPricebookEntry(parentProductID,'USD',tfPricebookId,unitPriceInUSD);
            
            PricebookEntry tfEbookPbeInGBP= insertPricebookEntry(parentProductID,'GBP',tfEbookPricebookId,discountedPriceInGBP);
            PricebookEntry tfEbookPbeInUSD= insertPricebookEntry(parentProductID,'USD',tfEbookPricebookId,discountedPriceInUSD);
            
            if (pbeInGBP.id!=null && pbeInUSD.id!=null && tfpbeInGBP.id!=null && tfpbeInUSD.id!=null && tfEbookPbeInGBP.id!=null && tfEbookPbeInUSD.id!=null){            
                msg='Base price has been saved successfully';
                system.debug(msg);
            }
        }
        
         if(! test.isrunningtest()&& IsActive==true){
            PricebookEntry tfpbeInGBP= insertPricebookEntryWithActiveFlag(parentProductID,'GBP',tfPricebookId,unitPriceInGBP);
            PricebookEntry tfpbeInUSD= insertPricebookEntryWithActiveFlag(parentProductID,'USD',tfPricebookId,unitPriceInUSD);
            
            PricebookEntry tfEbookPbeInGBP= insertPricebookEntryWithActiveFlag(parentProductID,'GBP',tfEbookPricebookId,discountedPriceInGBP);
            PricebookEntry tfEbookPbeInUSD= insertPricebookEntryWithActiveFlag(parentProductID,'USD',tfEbookPricebookId,discountedPriceInUSD);
            
            if (pbeInGBP.id!=null && pbeInUSD.id!=null && tfpbeInGBP.id!=null && tfpbeInUSD.id!=null && tfEbookPbeInGBP.id!=null && tfEbookPbeInUSD.id!=null){            
                msg='Base price has been saved successfully';
                system.debug(msg);
            }
        }
        Return msg;
    }
    //Add Discountedpercentage
   @AuraEnabled
    public static String addDiscountedPercentage(String parentProductID, Decimal discountedPercentage) {   
        try{
        String msg='';
        Product2 prd =[select Id from Product2 where id=:parentProductID];
        prd.DiscountedPercentage__c =discountedPercentage;
        update prd;
        Return 'Success';
            
        }Catch(Exception ex){
            system.debug('adddiscountedPercentage' + ex.getMessage());
            Return 'Fail';
        }
        
        
    }
    
    //Insert PriceBook Entry
    private static PricebookEntry insertPricebookEntry(String parentProductID,String currencyIsoCode, Id standardPriceBookId, Decimal unitPrice){
        List<Product2> ProductName=[select name from Product2 where id=:parentProductID];
        String prdName=ProductName[0].name;
        system.debug(prdName);        
        PriceBookEntry pbe = new PricebookEntry(Pricebook2Id=standardPriceBookId,Product2Id=parentProductID, UnitPrice=unitPrice, UseStandardPrice=false,CurrencyIsoCode=currencyIsoCode);
        insert pbe;        
        return pbe;
    }
    
     //Insert PriceBook Entry
    private static PricebookEntry insertPricebookEntryWithActiveFlag(String parentProductID,String currencyIsoCode, Id standardPriceBookId, Decimal unitPrice){
        List<Product2> ProductName=[select name from Product2 where id=:parentProductID];
        String prdName=ProductName[0].name;
        system.debug(prdName);        
        PriceBookEntry pbe = new PricebookEntry(Pricebook2Id=standardPriceBookId,Product2Id=parentProductID, IsActive=true,
 UnitPrice=unitPrice, UseStandardPrice=false,CurrencyIsoCode=currencyIsoCode);
        insert pbe;        
        return pbe;
    }
    
    //Update PriceBook Entry
    @AuraEnabled
    public static String updatePricebookEntry(String parentProductID,Decimal unitPriceInGBP, Decimal unitPriceInUSD,Decimal discountedPriceInGBP, Decimal discountedPriceInUSD){
        String msg='';
        List<Pricebook2> TandfpriceBookId;
        Id tfPricebookId;
        
        List<Pricebook2> priceBookId;
        Id standardPriceBookId;
        
        List<Pricebook2> listTfEbookPriceBookId;
        Id tfEbookPriceBookId;
        
        
        if (test.isrunningtest()) {       
            standardPriceBookId=Test.getStandardPricebookId();
            tfPricebookId='01s0Y00000832dDQAQ';
            tfEbookPriceBookId='01s0Y00000832cjQAA';
            system.debug('StdPriceBookIDInTestrunningmethodclass' + '' + standardPriceBookId);
        }
        else{        
            priceBookId=[select Id from Pricebook2 where isStandard=true];
            standardPriceBookId= priceBookId[0].id;
            
            TandfpriceBookId =[select Id from Pricebook2 where name='T&F Pricebook'];
            tfPricebookId = TandfpriceBookId[0].id;
            
            listTfEbookPriceBookId =[select Id from Pricebook2 where name='T&F - eBooks Pricebook'];
            tfEbookPriceBookId = listTfEbookPriceBookId[0].id;
        }
        
        List <PricebookEntry> stdpricebook = [Select id,Name,CurrencyIsoCode,UnitPrice from Pricebookentry where pricebook2id=:standardPriceBookId and Product2Id=:parentProductID];
        List <PricebookEntry> tnfpricebook = [Select id,Name,CurrencyIsoCode,UnitPrice from Pricebookentry where pricebook2id=:tfPricebookId and Product2Id=:parentProductID];
        List <PricebookEntry> tnfEbookPricebook = [Select id,Name,CurrencyIsoCode,UnitPrice from Pricebookentry where pricebook2id=:tfEbookPriceBookId and Product2Id=:parentProductID];
        
        if(stdpricebook.isEmpty() && tnfpricebook.isEmpty() && tnfEbookPricebook.isEmpty()){
            addPriceBookEntry(parentProductID,unitPriceInGBP,unitPriceInUSD,discountedPriceInGBP,discountedPriceInUSD,false); 
        }
        
        for (PricebookEntry pbe : stdpricebook) {
            If(pbe.CurrencyIsoCode=='GBP') {           
                pbe.UnitPrice=unitPriceInGBP;
            }
            else if (pbe.CurrencyIsoCode=='USD') {           
                pbe.UnitPrice=unitPriceInUSD;
            }
             
        }
        //update T and f Pricebook
        for (PricebookEntry tnfpbe : tnfpricebook) {
            If(tnfpbe.CurrencyIsoCode=='GBP'){            
                tnfpbe.UnitPrice=unitPriceInGBP;
            }
            else if (tnfpbe.CurrencyIsoCode=='USD') {           
                tnfpbe.UnitPrice=unitPriceInUSD;
            }
            
        }
        //update T and f Ebook Pricebook
        for (PricebookEntry tnfEbookpbe : tnfEbookPricebook) {
            If(tnfEbookpbe.CurrencyIsoCode=='GBP') {           
                tnfEbookpbe.UnitPrice=discountedPriceInGBP;
            }
            else if (tnfEbookpbe.CurrencyIsoCode=='USD') {           
                tnfEbookpbe.UnitPrice=discountedPriceInUSD;
            }
            
        }
        Try{
            update stdpricebook; 
            update tnfpricebook;
            update tnfEbookPricebook;
            msg='Base Price has been updated successfully';           
        }
        Catch(exception e){        
            msg='Please contact your administrator!';
            System.debug(e.getMessage() + 'Error in updatePricebookEntry');
        }        
        return msg;
    }
    
     @AuraEnabled
    public static String updatePricebookEntryWithActiveFlag(String parentProductID,Decimal unitPriceInGBP, Decimal unitPriceInUSD,Decimal discountedPriceInGBP, Decimal discountedPriceInUSD){
        String msg='';
        List<Pricebook2> TandfpriceBookId;
        Id tfPricebookId;
        
        List<Pricebook2> priceBookId;
        Id standardPriceBookId;
        
        List<Pricebook2> listTfEbookPriceBookId;
        Id tfEbookPriceBookId;
       
        
        if (test.isrunningtest()) {       
            standardPriceBookId=Test.getStandardPricebookId();
            tfPricebookId='01s0Y00000832dDQAQ';
            tfEbookPriceBookId='01s0Y00000832cjQAA';
            system.debug('StdPriceBookIDInTestrunningmethodclass' + '' + standardPriceBookId);
        }
        else{        
            priceBookId=[select Id from Pricebook2 where isStandard=true];
            standardPriceBookId= priceBookId[0].id;
            
            TandfpriceBookId =[select Id from Pricebook2 where name='T&F Pricebook'];
            tfPricebookId = TandfpriceBookId[0].id;
            
            listTfEbookPriceBookId =[select Id from Pricebook2 where name='T&F - eBooks Pricebook'];
            tfEbookPriceBookId = listTfEbookPriceBookId[0].id;
        }
        
        List <PricebookEntry> stdpricebook = [Select id,Name,CurrencyIsoCode,UnitPrice from Pricebookentry where pricebook2id=:standardPriceBookId and Product2Id=:parentProductID];
        List <PricebookEntry> tnfpricebook = [Select id,Name,CurrencyIsoCode,UnitPrice from Pricebookentry where pricebook2id=:tfPricebookId and Product2Id=:parentProductID];
        List <PricebookEntry> tnfEbookPricebook = [Select id,Name,CurrencyIsoCode,UnitPrice from Pricebookentry where pricebook2id=:tfEbookPriceBookId and Product2Id=:parentProductID];
        
        if(stdpricebook.isEmpty() && tnfpricebook.isEmpty() && tnfEbookPricebook.isEmpty()){
            addPriceBookEntry(parentProductID,unitPriceInGBP,unitPriceInUSD,discountedPriceInGBP,discountedPriceInUSD,true); 
        }
        
        for (PricebookEntry pbe : stdpricebook) {
            If(pbe.CurrencyIsoCode=='GBP') {           
                pbe.UnitPrice=unitPriceInGBP;
                pbe.IsActive=true;
            }
            else if (pbe.CurrencyIsoCode=='USD') {           
                pbe.UnitPrice=unitPriceInUSD;
                pbe.IsActive=true;
            }
        }
        //update T and f Pricebook
        for (PricebookEntry tnfpbe : tnfpricebook) {
            If(tnfpbe.CurrencyIsoCode=='GBP'){            
                tnfpbe.UnitPrice=unitPriceInGBP;
                tnfpbe.IsActive=true;
            }
            else if (tnfpbe.CurrencyIsoCode=='USD') {           
                tnfpbe.UnitPrice=unitPriceInUSD;
                tnfpbe.IsActive=true;
            }
        }
        //update T and f Ebook Pricebook
        for (PricebookEntry tnfEbookpbe : tnfEbookPricebook) {
            If(tnfEbookpbe.CurrencyIsoCode=='GBP') {           
                tnfEbookpbe.UnitPrice=discountedPriceInGBP;
                tnfEbookpbe.IsActive=true;
            }
            else if (tnfEbookpbe.CurrencyIsoCode=='USD') {           
                tnfEbookpbe.UnitPrice=discountedPriceInUSD;
                tnfEbookpbe.IsActive=true;
            }
        }
        Try{
            update stdpricebook; 
            update tnfpricebook;
            update tnfEbookPricebook;
            msg='Base Price has been updated successfully';           
        }
        Catch(exception e){        
            msg='Please contact your administrator!';
            System.debug(e.getMessage() + 'Error in updatePricebookEntry');
        }        
        return msg;
    }

    @AuraEnabled
    public static void updatePriceBookEntryAsActive(String parentProductID){
        List<Pricebook2> TandfpriceBookId;
        Id tfPricebookId;
        
        List<Pricebook2> priceBookId;
        Id standardPriceBookId;
        
        List<Pricebook2> listTfEbookPriceBookId;
        Id tfEbookPriceBookId;
        
        if (test.isrunningtest()) {       
            standardPriceBookId=Test.getStandardPricebookId();
            tfPricebookId='01s0Y00000832dDQAQ';
            tfEbookPriceBookId='01s0Y00000832cjQAA';
            system.debug('StdPriceBookIDInTestrunningmethodclass' + '' + standardPriceBookId);
        }
        else{        
            priceBookId=[select Id from Pricebook2 where isStandard=true];
            standardPriceBookId= priceBookId[0].id;
            
            TandfpriceBookId =[select Id from Pricebook2 where name='T&F Pricebook'];
            tfPricebookId = TandfpriceBookId[0].id;
            
            listTfEbookPriceBookId =[select Id from Pricebook2 where name='T&F - eBooks Pricebook'];
            tfEbookPriceBookId = listTfEbookPriceBookId[0].id;
        }
        
        List <PricebookEntry> stdpricebook = [Select id,Name,CurrencyIsoCode,UnitPrice from Pricebookentry where pricebook2id=:standardPriceBookId and Product2Id=:parentProductID];
        List <PricebookEntry> tnfpricebook = [Select id,Name,CurrencyIsoCode,UnitPrice from Pricebookentry where pricebook2id=:tfPricebookId and Product2Id=:parentProductID];
        List <PricebookEntry> tnfEbookPricebook = [Select id,Name,CurrencyIsoCode,UnitPrice from Pricebookentry where pricebook2id=:tfEbookPriceBookId and Product2Id=:parentProductID];
          for (PricebookEntry pbe : stdpricebook) {
            pbe.IsActive=true;
        }
        //update T and f Pricebook
        for (PricebookEntry tnfpbe : tnfpricebook) {
            tnfpbe.IsActive=true;
        }
        //update T and f Ebook Pricebook
        for (PricebookEntry tnfEbookpbe : tnfEbookPricebook) {
           tnfEbookpbe.IsActive=true;
        }
        Try{
            update stdpricebook; 
            update tnfpricebook;
            update tnfEbookPricebook;
        }
        Catch(exception e){        
            System.debug(e.getMessage() + 'Error in updatePriceBookEntryAsActive');
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
        
        List <PricebookEntry> pbe = [select UnitPrice,CurrencyIsoCode,IsActive from Pricebookentry where pricebook2id=:standardPriceBookId and product2id=:parentProductID];
        Return pbe;
    }
    //Get discountedPriceBookEntry
    @AuraEnabled
    public static List<Pricebookentry>getDiscountedPriceBookEntry(String parentProductID){
        List<Pricebookentry> result;             
        List<Pricebook2> priceBookId;
        Id tandfEbookPricebook;
        Id standardPriceBookId;
        if (test.isrunningtest()){
            standardPriceBookId=Test.getStandardPricebookId();
            List <PricebookEntry> pbe = [select UnitPrice,CurrencyIsoCode,IsActive from Pricebookentry where pricebook2id=:standardPriceBookId and product2id=:parentProductID];
            Return pbe;
        }else{
            priceBookId=[select Id from Pricebook2 where name='T&F - eBooks Pricebook'];
            tandfEbookPricebook= priceBookId[0].id;
            List <PricebookEntry> pbe = [select UnitPrice,CurrencyIsoCode,IsActive from Pricebookentry where pricebook2id=:tandfEbookPricebook and product2id=:parentProductID];
            Return pbe;
        }
               
        
       
    }
    //Get Price Book Entry Values by BundleId
    @AuraEnabled
    public static Product2 getDiscountedPercentage(String parentProductID) {  
        Product2 result;             
        result=[select Id,DiscountedPercentage__c  from Product2 where id=:parentProductID];
        return result;          
     }
    
    //Delete Prcebook Entry for product
    @AuraEnabled
    public static Boolean deletePriceBookEntry(String parentProductID) {  
        try{
            List<Pricebookentry> result;             
            List<Pricebook2> priceBookId;     
            List <PricebookEntry> pbe = [select UnitPrice,CurrencyIsoCode from Pricebookentry where product2id=:parentProductID];
            if(pbe.size()>0){
                delete pbe; 
            }
            
            Return true;
        }
        Catch(Exception ex){
            system.debug(ex.getMessage());
            Return false;
        }
        
    }
    
    // for getting the summed price of static collection products.
    @AuraEnabled
    public static String getSumOfStaticBundleTitles(String bundleID) {
        PriceSummaryWrapper priceSummaryDetail = new PriceSummaryWrapper();
        
        List<Pricebook2> priceBookId;
        Id standardPriceBookId;
        
        if (test.isrunningtest()) {       
            standardPriceBookId=Test.getStandardPricebookId();       
        }
        else {       
            priceBookId=[select Id from Pricebook2 where isStandard=true];
            standardPriceBookId= priceBookId[0].id;     
            
        }
        Decimal Final_Sum_GBP=0.00;   
        Decimal Final_Sum_USD=0.00;         
        
        List <PricebookEntry> unitpriceListInGBP=[SELECT UnitPrice,CurrencyIsoCode   FROM 
                                                  Pricebookentry WHERE CurrencyIsoCode ='GBP' and PriceBook2Id=:standardPriceBookId and isActive=true and product2id IN (SELECT Product__c FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :bundleID)];
        
        List <PricebookEntry> unitpriceListInUSD=[SELECT UnitPrice,CurrencyIsoCode   FROM 
                                                  Pricebookentry WHERE CurrencyIsoCode = 'USD' and PriceBook2Id=:standardPriceBookId and isActive=true and product2id IN (SELECT Product__c FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :bundleID)];
        //getting the sum of all the unit prices in GBP
        if(unitpriceListInGBP.size()>0){
            for (PricebookEntry pbe : unitpriceListInGBP) {         
                Final_Sum_GBP=Final_Sum_GBP + pbe.UnitPrice;              
            }
        }
        
        if(unitpriceListInUSD.size()>0){
            for (PricebookEntry pbe : unitpriceListInUSD) {           
                Final_Sum_USD=Final_Sum_USD + pbe.UnitPrice;             
            }
        }
        
        //getting the sum of all the unit prices in USD        
        
        priceSummaryDetail.UnitPriceinGBP=Final_Sum_GBP;
        priceSummaryDetail.UnitPriceinUSD=Final_Sum_USD;
        return JSON.serialize(priceSummaryDetail);
        //return Final_Sum_GBP; 
    }
    
    //wrapper class for sending he Pricesummaryresults
    public class PriceSummaryWrapper{    
        public Decimal UnitPriceinGBP;
        public Decimal UnitPriceinUSD;         
        public PriceSummaryWrapper(){}
        
    }    
    @AuraEnabled
    public static String getuserDetails()
    {   String Username;
     User u = [select Id, username from User where Id = :UserInfo.getUserId()];
     Username=u.username;       
     return Username;
    }
    
    @AuraEnabled
    public static InitialFieldValues getApprovalProcessStatus(String bundleID) {
        InitialFieldValues inVals = new InitialFieldValues();
        Boolean isUserAdmin;
        String strOwnerId;
        String strOwnerName;
        String strLastModifiedName;
        String strLastModifiedId;
        String strRecordTypeName;
        String strCurrentUserId;
        String dateFormatString = 'dd-MM-yyyy';
        isUserAdmin=checkIfUserIsAdmin();
        system.debug('isUserAdmin' + isUserAdmin);
        inVals.dynamicRule = null;
        Product2 product = [SELECT id, Name, Approval_Status__c, APIStatus__c, Product_Type_Author_Facing__c, Type_of_Bundle__c, Dynamic_Collection_Criteria__c,CreatedBy.Id,CreatedBy.Name,LastModifiedBy.Id,LastModifiedBy.Name, MaxReAttempts__c,RecordType.Name,createddate,lastmodifiedDate, isActive, Is_collection_free__c FROM Product2 WHERE id = :bundleID limit 1];
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
        inVals.productType = product.Product_Type_Author_Facing__c;
        inVals.isProductActive = product.isActive ? 'True' : 'False';
        strOwnerId=String.valueOf(product.CreatedBy.Id);
        strOwnerName=String.valueOf(product.CreatedBy.name);
        system.debug('strOwnerName' + strOwnerName);
        strCurrentUserId=String.valueOf(UserInfo.getUserId());
        strLastModifiedName =String.valueOf(product.LastModifiedBy.Name);
        strRecordTypeName=String.valueOf(product.RecordType.Name);
        strLastModifiedId=String.valueOf(product.LastModifiedBy.Id);
        inVals.createdByName =strOwnerName;
        inVals.lastModifiedByName =strLastModifiedName;
        invals.recordTypeName =strRecordTypeName;
        inVals.createdById=strOwnerId;
        inVals.lastModifiedById=strLastModifiedId;
        invals.salesforceURL=getSalesforceBaseUrl();
        invals.isCollectionFree=product.Is_collection_free__c;
        
        invals.createdDate=product.createddate.format(dateFormatString);
        invals.lastModifiedDate=product.lastmodifieddate.format(dateFormatString);
        
        if(product.Dynamic_Collection_Criteria__c != null){
            inVals.dynamicRule = product.Dynamic_Collection_Criteria__c ;
        }
        
        if(isUserAdmin== true){
            inVals.isUserAdmin = 'true' ;
        }
        else if (isUserAdmin== false){
            inVals.isUserAdmin = 'false';
        }
        
        
        if((strOwnerId!= strCurrentUserId)&& isUserAdmin!=true){         
            inVals.AllowUserToUpdate='false';
        }
        else  if((strOwnerId!= strCurrentUserId)&& isUserAdmin==true){       
            inVals.AllowUserToUpdate='true'; 
        }
        else if (strOwnerId== strCurrentUserId){
            inVals.AllowUserToUpdate='true';
        }
        
        return inVals;
    }
    
    @AuraEnabled
    public static String updateApprovalProcessStatus(String bundleID) {
        Product2 product = [SELECT id, Name, Approval_Status__c FROM Product2 WHERE id = :bundleID limit 1];
        product.Approval_Status__c='Pending';
        product.APIStatus__c ='';
        
        update product;
        updatePriceBookEntryAsActive(bundleID);
        String jobId = Database.executeBatch(new TF_Batch_DeleteInvalidContent(bundleID), 5000);
        return 'Product has been Submitted for Approval';        
    }
    
    @AuraEnabled
    public static String updateDynamicProductRule(String bundleID, String rule) {
        List<Product2> productLst = new List<Product2>();
        productLst = [SELECT id FROM Product2 WHERE id = :bundleID limit 1];
        system.debug('##rule##'+rule);
        if(productLst != null && productLst.size() > 0 ){
            product2 prd = new product2();
            prd.id = productLst[0].id ;
            //prd.List_Price__c = 100;
            prd.Dynamic_Collection_Criteria__c = rule;
            update prd;
            system.debug('prdprdprdprpd' + prd);
            return 'Rule Saved !';
        }else{
            return 'Error';
        }
    }
    
    @AuraEnabled
    public static String getSubmitForApprovalStatusValue(String bundleID) {
        system.debug( '&&' + bundleID );
        Product2 product = [SELECT id, Name, Approval_Status__c FROM Product2 WHERE id = :bundleID limit 1];
        system.debug('$$$$$$$' + product.id + '&&' + bundleID );
        Return product.Approval_Status__c;     
    }
    @AuraEnabled
    public static String getUnsiloContents(String bundleID) {
        Integer contentSubmitCount = 0 ;
        String DynamicCollectionCriteria;
        String ProductType;
        String hubId ;
        Product2 product=[SELECT Dynamic_Collection_Criteria__c,Product_Type_Author_Facing__c FROM Product2 where id=:bundleID];
        // if(product.Product_Type_Author_Facing__c=='Rule based'){
        DynamicCollectionCriteria=product.Dynamic_Collection_Criteria__c;
        ProductType=product.Product_Type_Author_Facing__c;
        // }
        
        
        contentSubmitCount = [SELECT count() FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c =:bundleID and (Valid__c  != 'false' or uuid__c != null)];
        hubId = getHubID(bundleID);
        if(string.isBlank(hubId)){
            TF_ProductHubWebServiceCallout.getHubIDSync(bundleID);  
            hubId = getHubId(bundleID);
        }
        
        //checking the PricebookEntryInfo
        List <PricebookEntry> pbe = getPriceBookEntry(bundleID);
        //Decimal UnitPriceInGBP=0.00;
        //Decimal UnitPriceInUSD=0.00;
        Decimal UnitPriceInGBP;
        Decimal UnitPriceInUSD;
        for(PricebookEntry pb: pbe){
            if(pb.CurrencyIsoCode=='GBP') {           
                UnitPriceInGBP=pb.UnitPrice;  
                system.debug('UnitPriceInGBP' + UnitPriceInGBP);
            }
            else if(pb.CurrencyIsoCode=='USD'){            
                UnitPriceInUSD=pb.UnitPrice;
                system.debug('UnitPriceInUSD' + UnitPriceInUSD);                    
            }
        }  
        
        // get collection validity
      String prdValidity=checkIfValidityDatesExist(bundleID);
        //get BusinessId validity
       String prdBusinessIdValidity=checkIfValidBusinessIdExist(bundleID);
        String prdCollectionNameValidity=checkIfValidCollectionNameExist(bundleID);
        system.debug('prdValidityprdValidity%%'+prdValidity);
         system.debug('prdBusinessIdValidity%%'+prdBusinessIdValidity);
        
        system.debug('$$$$$contentSubmitCount' + contentSubmitCount);
        if(ProductType=='Manual Curation' && contentSubmitCount >0 && string.isNotBlank(hubId)&& (prdValidity=='True'&& prdBusinessIdValidity=='True' && prdCollectionNameValidity=='True' &&(UnitPriceInGBP>=0.00 && UnitPriceInGBP!=null)&&(UnitPriceInUSD>=0.00 && UnitPriceInUSD!=null))){
            return 'true';
        }
        else if (ProductType=='Manual Curation' && contentSubmitCount >0 && string.isNotBlank(hubId)&& (UnitPriceInGBP<0.00 || UnitPriceInGBP==null)&&(UnitPriceInUSD<0.00 || UnitPriceInUSD==null)){
            system.debug('noPriceBookEntry');
            return 'noPriceBookEntry';            
        }
        
        else if (ProductType=='Manual Curation' && contentSubmitCount >0 && string.isNotBlank(hubId)&& prdValidity=='False'&& (UnitPriceInGBP>=0.00 && UnitPriceInGBP!=null)&&(UnitPriceInUSD>=0.00 && UnitPriceInUSD!=null)){
            system.debug('noValidityDatesExists');
            return 'noValidityDatesExists';            
        }
        
         else if (ProductType=='Manual Curation' && contentSubmitCount >0 && string.isNotBlank(hubId)&& prdValidity=='True'&& prdBusinessIdValidity=='False'&&(UnitPriceInGBP>=0.00 && UnitPriceInGBP!=null)&&(UnitPriceInUSD>=0.00 && UnitPriceInUSD!=null)){
            system.debug('noValidBusinessIdExists');
            return 'noValidBusinessIdExists';            
        }
        
        else if (ProductType=='Manual Curation' && contentSubmitCount >0 && string.isNotBlank(hubId)&& prdValidity=='True'&& prdBusinessIdValidity=='True' && prdCollectionNameValidity=='False' &&(UnitPriceInGBP>=0.00 && UnitPriceInGBP!=null)&&(UnitPriceInUSD>=0.00 && UnitPriceInUSD!=null)){
            system.debug('noValidCollectionNameExists');
            return 'noValidCollectionNameExists';            
        }
        //for dynamic collection
        else if ((ProductType=='Rule based') && ((string.isBlank(DynamicCollectionCriteria) || DynamicCollectionCriteria==null)) && string.isNotBlank(hubId) && (prdValidity=='True'&& prdBusinessIdValidity=='True'&&(UnitPriceInGBP>=0.00 && UnitPriceInGBP!=null)&&(UnitPriceInUSD>=0.00 && UnitPriceInUSD!=null))){
            system.debug('no rule');
            return 'norule';
        }
        else if ((ProductType=='Rule based') && ((string.isNotBlank(DynamicCollectionCriteria)|| DynamicCollectionCriteria!=null)) && string.isNotBlank(hubId) && (UnitPriceInGBP<0.00 || UnitPriceInGBP==null)&&(UnitPriceInUSD<0.00 || UnitPriceInUSD==null)){
            system.debug('noPriceBookEntry for dynamic');
            return 'noPriceBookEntry';
        }
        
        else if ((ProductType=='Rule based') && ((string.isNotBlank(DynamicCollectionCriteria)|| DynamicCollectionCriteria!=null)) && string.isNotBlank(hubId) && (prdValidity=='False'&&(UnitPriceInGBP>=0.00 && UnitPriceInGBP!=null)&&(UnitPriceInUSD>=0.00 && UnitPriceInUSD!=null))){
            system.debug('noValidityDatesExists for dynamic');
            return 'noValidityDatesExists';
        }
        
        else if ((ProductType=='Rule based') && ((string.isNotBlank(DynamicCollectionCriteria)|| DynamicCollectionCriteria!=null)) && string.isNotBlank(hubId) && (prdValidity=='True'&& prdBusinessIdValidity=='False'&&(UnitPriceInGBP>=0.00 && UnitPriceInGBP!=null)&&(UnitPriceInUSD>=0.00 && UnitPriceInUSD!=null))){
            system.debug('noValidBusinessIdExists for dynamic');
            return 'noValidBusinessIdExists';
        }
        
        else if ((ProductType=='Rule based') && ((string.isNotBlank(DynamicCollectionCriteria)|| DynamicCollectionCriteria!=null)) && string.isNotBlank(hubId) && (prdValidity=='True'&& prdBusinessIdValidity=='True' && prdCollectionNameValidity=='False' &&(UnitPriceInGBP>=0.00 && UnitPriceInGBP!=null)&&(UnitPriceInUSD>=0.00 && UnitPriceInUSD!=null))){
            system.debug('noValidCollectionNameExists for dynamic');
            return 'noValidCollectionNameExists';
        }
        
        else if (string.isBlank(hubId)){
            system.debug('nohubid');
            return 'nohubid';
        }
        else{
            system.debug('nocontent');
            return 'nocontent';
        }       
        
        
    }
    @AuraEnabled
    public static String getHubID(String bundleID){
        String hubId ;
        List<Product2> prdLst = new List<Product2>();
        prdLst = [Select Hub_Id__c From Product2 where id =:bundleID] ;        
        if(prdLst.size() > 0){
            Product2 prd = prdLst[0]; 
            hubId = prd.Hub_Id__c ;
        }        
        return hubId ;
    }
    
    @AuraEnabled
    public static Integer getBundleItmsCount(String bundleID) {
        Integer contentCount = 0 ;
        String hubId ;
        Product2 product = [SELECT id, Name, Product_Type_Author_Facing__c,Dynamic_Collection_Criteria__c FROM Product2 WHERE id = :bundleID limit 1];
        if(product.Product_Type_Author_Facing__c=='Manual Curation'){
            contentCount = [SELECT count() FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c =:bundleID];
            return contentCount ;
        }        
        else  if(product.Product_Type_Author_Facing__c=='Rule based' && product.Dynamic_Collection_Criteria__c!=null){
            
            return 1 ;
        } 
        else{
            return contentCount ;
        }
    }
    
    // to get the updated incremented version number for same product update
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
                system.debug('#@#@Final String #@#@' + '' + finalver);
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
            /* Id productRecordtypeId = MiscFunctions.getRecordtypeId(Objectname, RecordTypeName);         
string recordtypeId=String.valueof(productRecordtypeId);    
system.debug(recordtypeId);
return recordtypeId;*/
            Id productRecordtypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(RecordTypeName).getRecordTypeId();
            string recordtypeId=String.valueof(productRecordtypeId);  
            return recordtypeId;
        }
        catch(Exception ex){
            system.debug('getRecordTypeId Error debug' + ex.getMessage());
            return null;
        }             
        
    }
    
    /*  @AuraEnabled
public static String getClonedProduct(String bundleID) {
Savepoint sp = Database.setSavepoint(); 
Try
{     Product2 originalProduct = [select name, Hub_Id__c,alternateName__c,version__c,issn__c,Product_Publisher__c,Applicable_Channels__c,Applicable_Customer_Types__c,inLanguage__c,Description,
doi__c,ean__c,copyrightyear__c,Lead_Author_Editor__c,Applicable_License_Types__c,Contributors__c,Keywords__c,Family FROM Product2 WHERE id = :bundleID limit 1];

Product2 clonedProduct = originalProduct.clone(false, true, false, false);
clonedProduct.version__c=getProductVersion(originalProduct.version__c);
clonedProduct.originalProductId__c=String.valueof(bundleID);
clonedProduct.Status__c = 'Draft';
clonedProduct.RecordTypeId=getRecordTypeId('Product2','T&F - Collection');
//clonedProduct.RecordTypeId=getRecordTypeId('Product2','T&F - ClonedCollection');

// clonedProduct.Hub_Id__c=originalProduct.Hub_Id__c;
insert clonedProduct; 
system.debug('clonedProductId' + ' ' + clonedProduct.id);
String CloneProductId = String.valueof(clonedProduct.id);
system.debug('clonedProductIdString' + ' ' + CloneProductId);

//cloning Bundle line items
list< Bundle_Line_Item__c> BundleItms = new list< Bundle_Line_Item__c>(); 
BundleItms = [select Authors__c,Content_ID__c,Content_Position__c,CurrencyIsoCode,doi__c,IsDeleted,IsUnsilo__c,Journal__c,Name,Open_access__c,Product__c,
Publication_Date__c,Product_Publisher__c,Title__c,Product_Bundle_Parent__c from bundle_line_item__c where Product_Bundle_Parent__c= :bundleID];

list< Bundle_Line_Item__c> clonedBundleLineItems = new list< Bundle_Line_Item__c>();

for (Bundle_Line_Item__c bdl : BundleItms) {
Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
lineItem=bdl.clone(false, true, false, false);
lineItem.Product_Bundle_Parent__c = CloneProductId;
if(bdl.IsUnsilo__c==true)
{
lineItem.Product_Doi__c = bdl.doi__c + '||' +  CloneProductId;
}
else if (bdl.IsUnsilo__c==false)
{
lineItem.Product_Doi__c ='';
lineItem.doi__c='';
}
clonedBundleLineItems.add(lineItem); 
system.debug(bdl.doi__c + '||' +  CloneProductId);
}
insert clonedBundleLineItems;

//updating the product hub Id


//cloning the base prices of the parent product
List <PricebookEntry> pbe = getPriceBookEntry(bundleID);
Decimal UnitPriceInGBP=0.00;
Decimal UnitPriceInUSD=0.00;
for(PricebookEntry pb: Pbe)
{ if(pb.CurrencyIsoCode=='GBP')
{
UnitPriceInGBP=pb.UnitPrice;
}
else if(pb.CurrencyIsoCode=='USD')
{
UnitPriceInUSD=pb.UnitPrice;
}

}

String msg=addPriceBookEntry(CloneProductId, UnitPriceInGBP, UnitPriceInUSD);

//returning the parent product cloned Id
Return CloneProductId;
}
Catch(Exception ex)
{ 
Database.rollback(sp); 
system.debug('error in getClonedProduct' + ' ' + ex.getmessage());
Return null;
}
}*/
    
    @AuraEnabled
    public static ProductCloneResult getClonedProduct(String bundleID){
        system.debug('getClonedProduct**&&');
        ProductCloneResult pcr = new ProductCloneResult();
        pcr.position = 0 ;
        Savepoint sp = Database.setSavepoint(); 
        Try{             
            Product2 originalProduct = [select name, businessId__c,Hub_Id__c,alternateName__c,version__c,issn__c,Product_Publisher__c,Applicable_Channels__c,Applicable_Customer_Types__c,inLanguage__c,Description,
                                        doi__c,ean__c,copyrightyear__c,Lead_Author_Editor__c,Applicable_License_Types__c,Contributors__c,Keywords__c,Family,Sales_Channels__c,Product_Type_Author_Facing__c,Dynamic_Collection_Criteria__c,Collection_Valid_From__c,Collection_Valid_To__c,Collection_updatedFrom__c,Collection_updatedTo__c,Netbase_Classifications__c,Subject_Classifications__c,Product_Category__c,Product_Type__c,Collection_Subject_Area__c FROM Product2 WHERE id = :bundleID limit 1];
            system.debug('originalProduct.Product_Type__c&&&'+ originalProduct.Product_Type__c);
            system.debug('originalProduct.Collection_Subject_Area__c&&&'+ originalProduct.Collection_Subject_Area__c);
            Product2 clonedProduct = originalProduct.clone(false, false, false, false);
            clonedProduct.version__c=getProductVersion(originalProduct.version__c);
            clonedProduct.originalProductId__c=String.valueof(bundleID);
            clonedProduct.Status__c = 'Draft';
           // clonedProduct.Product_Type__c=originalProduct.Product_Type__c;
            clonedProduct.RecordTypeId=getRecordTypeId('Product2','T&F - Collection');            
            insert clonedProduct;
            system.debug('clonedProduct.Product_Type__c##'+clonedProduct.Product_Type__c);
            system.debug('clonedProduct.Collection_Subject_Area__c##'+ clonedProduct.Collection_Subject_Area__c);
           // Product2 updateClonedProduct=new Product2();
            //updateClonedProduct= [SELECT id,name FROM Product2 WHERE id=:clonedProduct.id LIMIT 1];
           // updateClonedProduct.Product_Type__c=null;
           // updateClonedProduct.Product_Type__c=originalProduct.Product_Type__c;
           // update updateClonedProduct;
 
            pcr.productId =  clonedProduct.id ;            
            pcr.totalRecords = [select count() from bundle_line_item__c where Product_Bundle_Parent__c= :bundleID];            
            List<Bundle_Line_Item__c> lineItems = [SELECT Content_Position__c FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :bundleID ORDER BY Content_Position__c LIMIT 1];
            
            if(lineItems.size() > 0){
                pcr.position = Integer.valueOf(lineItems[0].Content_Position__c) -1;
            }
            
            //cloning the base prices of the parent product
            List <PricebookEntry> pbe = getPriceBookEntry(bundleID);
            //Decimal UnitPriceInGBP=0.00;
            //Decimal UnitPriceInUSD=0.00;
            Decimal UnitPriceInGBP;
            Decimal UnitPriceInUSD;
            Decimal discountedPriceInGBP;
            Decimal discountedPriceInUSD;
            Decimal discountedpercentage=0.00;
            for(PricebookEntry pb: pbe){
                if(pb.CurrencyIsoCode=='GBP') {               
                    UnitPriceInGBP=pb.UnitPrice;
                }
                else if(pb.CurrencyIsoCode=='USD'){                
                    UnitPriceInUSD=pb.UnitPrice;
                }
            }
            if(UnitPriceInGBP!=null && UnitPriceInUSD!=null){
                addPriceBookEntry(clonedProduct.id, UnitPriceInGBP, UnitPriceInUSD,discountedPriceInGBP,discountedPriceInUSD,true);
            }
            
            //cloning uploaded images
            return pcr ;
            
        }  Catch(Exception ex){ 
            Database.rollback(sp); 
            system.debug('error in getClonedProduct' + ' ' + ex.getmessage());
            Return null;
        } 
    }
    
    @AuraEnabled
    public static ProductCloneResult cloneBundleItems(String bundleID, String CloneProductId, String position, String processedRecCount, String totalRecCount) {
        ProductCloneResult pcr = new ProductCloneResult();
        pcr.position = Integer.valueOf(position);
        Integer recsProcessed = Integer.valueOf(processedRecCount);
        Integer totalRecs = Integer.valueOf(totalRecCount);
        Integer pstn = Integer.valueOf(position);
        system.debug('bundleID,CloneProductId,position,processedRecCount,totalRecCount'+bundleID+' === '+CloneProductId+' === '+position+' === '+processedRecCount+' === '+totalRecCount);
        Savepoint sp = Database.setSavepoint(); 
        Try  {            
            
            list< Bundle_Line_Item__c> bundleItms = new list< Bundle_Line_Item__c>(); 
            bundleItms = [select Authors__c,Content_ID__c,Content_Position__c,CurrencyIsoCode,doi__c,IsDeleted,IsUnsilo__c,Journal__c,Name,Open_access__c,Product__c,
                          Publication_Date__c,Product_Publisher__c,Title__c,Product_Bundle_Parent__c, uuid__c, Type__c, Source__c,mediaType__c,Publisher__c,IsIncluded__c,PriceGBP__c,PriceUSD__c  from bundle_line_item__c where Product_Bundle_Parent__c= :bundleID and Content_Position__c > :pstn ORDER BY Content_Position__c LIMIT 9000];
            
            list< Bundle_Line_Item__c> clonedBundleLineItems = new list< Bundle_Line_Item__c>();
            
            for (Bundle_Line_Item__c bdl : bundleItms) {
                Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
                lineItem=bdl.clone(false, true, false, false);
                lineItem.Product_Bundle_Parent__c = CloneProductId;
                lineItem.Product_Doi__c = bdl.doi__c + '||' +  CloneProductId;                
                clonedBundleLineItems.add(lineItem); 
            }
            if(clonedBundleLineItems.size() > 0){
                //Database.insert(clonedBundleLineItems, false);
            }
            
            if(bundleItms.size() > 0 ){
                pcr.position = integer.valueOf(bundleItms[bundleItms.size() - 1].Content_Position__c) ;
            }
            recsProcessed = recsProcessed + bundleItms.size() ;
            pcr.processedRecords = recsProcessed ;
            pcr.productId = CloneProductId ;
            pcr.moreRecsToProcess = recsProcessed == totalRecs ? 'False' : 'True' ;
            
            return pcr ;
        }
        Catch(Exception ex){         
            Database.rollback(sp); 
            system.debug('error in getClonedProduct' + ' ' + ex.getmessage());
            Return null;
        }
    }
    
    @AuraEnabled
    public static void restoreClonedProductToOriginal(String clonedBundleID,String originalBundleId) {
        Savepoint sp = Database.setSavepoint(); 
        System.debug('restoreClonedProductToOriginal');
        try {       
            Product2 originalProduct = [select Id,name, Hub_Id__c FROM Product2 WHERE id = :originalBundleId limit 1];
            Product2 clonedProduct = [select Id,version__c, Description,Contributors__c,Keywords__c,Is_collection_free__c FROM Product2 WHERE id = :clonedBundleID limit 1];
            //updating the original Product
            system.debug('cloned version' + clonedProduct.version__c);
            originalProduct.version__c=clonedProduct.version__c;
            originalProduct.Description=clonedProduct.Description;
            originalProduct.Contributors__c=clonedProduct.Contributors__c;
            originalProduct.Keywords__c=clonedProduct.Keywords__c;   
            originalProduct.Is_collection_free__c=clonedProduct.Is_collection_free__c;
            update originalProduct;
            
            //deleting the existing products before copying from cloned product
            String msg=deleteAllProductsAndContents(originalBundleId);
            //deleting the existing contents before copying from cloned product
            system.debug('Delete Complete');
            
            //updating bundle line items from approved cloned product to original one
            list< Bundle_Line_Item__c> BundleItms = new list< Bundle_Line_Item__c>(); 
            
            BundleItms = [select Authors__c,Content_ID__c,Content_Position__c,CurrencyIsoCode,doi__c,IsDeleted,IsUnsilo__c,Journal__c,Name,Open_access__c,Product_Doi__c,Product__c,
                          Publication_Date__c,Product_Publisher__c,Title__c,Product_Bundle_Parent__c from bundle_line_item__c where  Product_Bundle_Parent__c= :clonedBundleID];
            
            list< Bundle_Line_Item__c> clonedBundleLineItems = new list< Bundle_Line_Item__c>();
            for (Bundle_Line_Item__c bdl : BundleItms) {
                Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
                lineItem=bdl.clone(false, true, false, false);
                lineItem.Product_Bundle_Parent__c = originalBundleId;
                if(bdl.IsUnsilo__c==true) {               
                    lineItem.Product_Doi__c = bdl.doi__c + '||' +  originalBundleId;                    
                }else if(bdl.IsUnsilo__c==false){
                    lineItem.Product_Doi__c = bdl.Product__c + '||' + clonedBundleID;
                    lineItem.doi__c='';
                }                
                clonedBundleLineItems.add(lineItem); 
            }
            insert clonedBundleLineItems;
            // add the code
            
            //Copying the price entry from cloned to original product            
            List <PricebookEntry> pbe = getPriceBookEntry(clonedBundleID);
            //Decimal UnitPriceInGBP=0.00;
            //Decimal UnitPriceInUSD=0.00;
            Decimal UnitPriceInGBP;
            Decimal UnitPriceInUSD;
            Decimal discountedPriceInGBP;
            Decimal discountedPriceInUSD;
            Decimal discountedPercentage;
            for(PricebookEntry pb: Pbe)
            { if(pb.CurrencyIsoCode=='GBP'){            
                UnitPriceInGBP=pb.UnitPrice;
            }
             else if(pb.CurrencyIsoCode=='USD'){             
                 UnitPriceInUSD=pb.UnitPrice;
             }
             
            }
            if(UnitPriceInGBP!=null && UnitPriceInUSD!=null){
                String successMsg=updatePricebookEntry(originalBundleId, UnitPriceInGBP, UnitPriceInUSD,discountedPriceInGBP,discountedPriceInUSD);
            }          
            
            //delete the cloned product after restoring it
            delete clonedProduct;          
            
        }
        catch(Exception ex){
            Database.rollback(sp); 
            system.debug('Failure' + ex.getmessage());            
        }        
    }
    @AuraEnabled
    public static String checkIfNewVersionExist(String bundleID) {
        try{        
            Product2 originalProduct = [select Id,name, Hub_Id__c,version__c FROM Product2 WHERE id = :bundleID limit 1];
            String HubId=originalProduct.Hub_Id__c;
            String Version=originalProduct.version__c;
            Integer count=[select Count() FROM Product2 WHERE Hub_Id__c = :HubId];
            If (count>1) {           
                system.debug('true');
                Return 'true';                
            }
            else{
                system.debug('false');
                Return 'false';             
            }
        }
        Catch(Exception ex) {       
            system.debug(ex.getMessage());
            return null;
        }
    }
    
    @future
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
    }
    
    
    @AuraEnabled
    public static String saveClonedProductDescription(String bundleID,String cloneDescription) {
        String msg='';
        try{          
            Product2 clonedProduct = [select Id,name,Description FROM Product2 WHERE id = :bundleID limit 1]; 
            clonedProduct.Description=cloneDescription;
            update clonedProduct;
            msg= 'Record has been updated successfully!';
            return msg;
        }
        catch(exception ex) {       
            system.debug(ex.getMessage());
            msg= 'Some error has occured,record has not been updated successfully!';
            return msg;
        }
    }
    
    @AuraEnabled
    public static String checkIfProductIsCloned(String bundleID) {
        String msg='';        
        try{          
            Product2 clonedProduct = [select Id,name,Description,originalProductId__c FROM Product2 WHERE id = :bundleID limit 1]; 
            String originalProductId = clonedProduct.originalProductId__c;
            if(String.isBlank(originalProductId)) {           
                msg= 'original';
            }
            else{            
                msg= 'cloned';
            }          
            system.debug(msg);
            return msg;
        }
        catch(exception ex){        
            system.debug(ex.getMessage());
            msg= 'Some error has occured,record has not been updated successfully!';
            return msg;
        }
    }
    
    @AuraEnabled
    public static String getCloneDataForEdit(String bundleID) {
        String msg='';
        try{          
            Product2 clonedProduct = [select Id,name,Description,originalProductId__c FROM Product2 WHERE id = :bundleID limit 1]; 
            msg=clonedProduct.Description;            
            return msg;
        }
        catch(exception ex){        
            system.debug(ex.getMessage());
            msg= '';
            return msg;
        }
    }
    
    @AuraEnabled
    public static List<String> getPickListValues(String ObjectApiName, String fieldApiName) {
        List<String> pickListValuesList= new List<String>();
        if(String.isNotBlank(ObjectApiName) && String.isNotBlank(fieldApiName)){
            List<String> objectLst = new List<String>();
            objectLst.add(ObjectApiName);
            Schema.DescribeSobjectResult[] descSobjLst = Schema.describeSObjects(objectLst);            
            for(Schema.DescribeSobjectResult obj : descSobjLst) {
                for (Schema.PicklistEntry entry : obj.fields.getMap().get(fieldApiName).getDescribe().getPicklistValues()) {
                    if (entry.isActive()){
                        pickListValuesList.add(entry.getValue());
                    }
                }
            }
        }
        return pickListValuesList;
    }
    
    @AuraEnabled
    public static List<String> getDropDownListValues(String settingName) {
        List<String> pickListValuesList= new List<String>();
        List<Setting_Item__c> settingList = new List<Setting_Item__c>();
        settingList = [SELECT Setting__r.Name, Text_1__c, Text_2__c
                       FROM Setting_Item__c 
                       WHERE Setting__r.Name =: settingName AND Checkbox_1__c = true];
        
        for (Setting_Item__c settingItem : settingList){
            pickListValuesList.add(settingItem.Text_1__c);
        }
        
        return pickListValuesList ;
    }
    
    
    @AuraEnabled
    public static Boolean checkIfUserIsAdmin() {  
        try{
            Id profileId=userinfo.getProfileId();
            String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
            system.debug('ProfileName'+profileName);
            if(profileName=='System Administrator'){
                return true;
            }
            else {
                return false;
            }
        }
        catch(exception ex){
            System.debug('checkIfUserIsAdmin' + ex.getMessage());
            return false;
        }
    }
    
    
    
    @AuraEnabled
    public static querySaveElement parseRuleJson(String bundleID) {
        String strRuleJSON='';
        querySaveElement savedQry = new querySaveElement();
        try{          
            Product2 clonedProduct = [select Id,name,Dynamic_Collection_Criteria__c FROM Product2 WHERE id = :bundleID limit 1]; 
            strRuleJSON=clonedProduct.Dynamic_Collection_Criteria__c;  
            system.debug('strRuleJSON'+strRuleJSON);
            
            if( String.IsNotBlank(strRuleJSON) ){   
                savedQry = (querySaveElement)JSON.deserialize(strRuleJSON, querySaveElement.class);
                system.debug(savedQry);
            }
            else{
                savedQry=null;                
            }
            system.debug('outside fl'+savedQry);
            return savedQry;           
        }
        catch(exception ex){        
            system.debug(ex.getMessage());
            system.debug(ex.getStackTraceString());
            return savedQry;
        }
    }
    
    @AuraEnabled
    public static String getPartsDownloadURL(String bundleId) {
        
        Map<String, String> headers = new Map<String,String>(); 
        String downloadEndpoint = '';
        String hubId = '';
        String resBody ;
        
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        downloadEndpoint = (String) orgSpecificProps.get('downloadPartsAPI_url__c');
        
        List<Product2> prdLst = new List<Product2>();
        prdLst = [Select Hub_Id__c From Product2 where id =:bundleId] ;  
        hubId = prdLst != null && prdLst.size() >0 ? prdLst[0].Hub_Id__c : '';
        system.debug('====hubId====='+hubId);
        //downloadEndpoint = downloadEndpoint + hubId +'?type=exportcsv';
        downloadEndpoint = downloadEndpoint + hubId +'?apiVersion=4.0.1&type=partslist';
        headers.put('Content-Type', 'application/json');
        
        HttpResponse res = new HttpResponse();
        
        res = TF_PlatformExecuter.execute(downloadEndpoint,'GET','idtoken', null, headers, false);
        
        if (res.getStatusCode() == 201 || res.getStatusCode() == 200) { 
            resBody=res.getbody();
            resBody=resBody.replace('"type":', '"type_Z":');
            
            List<PartsDownload> partsDownloadLst = new List<PartsDownload>(); 
            partsDownloadLst = (List<PartsDownload>)JSON.deserialize(resBody, List<PartsDownload>.class);
            system.debug('location for s3 file' + partsDownloadLst[0].location);
            return partsDownloadLst[0].location ;
            
        }else if(res.getStatusCode() == 404){
            return 'File not found' ;
        }else{
            return 'Error';
        }
        
    }
    
    @AuraEnabled
    public static String addProductsToCollectionFromPCM(String parentProductID, String listOfProductsString, String IsInclude) {
        
        Try{
            system.debug('listOfProductsString'+listOfProductsString);
            list< Bundle_Line_Item__c> listofLineItems = new list< Bundle_Line_Item__c>();  
            integer position = 1;
            String productRecordtypeId = getRecordtypeId('Product2', 'T&F - Collection');
            
            List<Bundle_Line_Item__c> lineItms = [SELECT Content_Position__c FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :parentProductID ORDER BY Content_Position__c DESC LIMIT 1];
            Product2 p = [SELECT id,Is_collection_free__c FROM Product2 WHERE id=: parentProductID LIMIT 1];
            Boolean collectionStatus = p.Is_collection_free__c;
            system.debug('CollectionFree? ' + p.Is_collection_free__c);
            
            if(lineItms.size() > 0){
                position = Integer.valueOf(lineItms[0].Content_Position__c) + 1;
            }
            
            List<PagedResult> pagedResultList = (List<PagedResult>) JSON.deserialize(listOfProductsString, List<PagedResult>.class);
            
            
            for (PagedResult prd : pagedResultList) {
                String productDoi = prd.doi +'||'+ parentProductID;
                Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
                lineItem.Product_Bundle_Parent__c = parentProductID;
                lineitem.Journal__c = prd.title;
                lineitem.Authors__c = prd.author;
                lineitem.Publisher__c=prd.publisherImprint;
                lineitem.doi__c = prd.doi;
                lineitem.Publication_Date__c = prd.publicationDate != null ? Date.valueOf(prd.publicationDate) : null;
                lineItem.Product_Doi__c =  productDoi;
                lineItem.Type__c = prd.type;
                lineItem.Valid__c = prd.id != null && prd.id != '' ? 'true' : 'false';
                lineitem.uuid__c = prd.id;
                lineItem.PriceUSD__c = prd.priceBYOUSD;
                lineItem.PriceGBP__c = prd.priceBYOGBP;
                lineItem.mediaType__c=prd.format;
                //  lineItem.Product__c = prd.id;
                lineItem.Source__c = 'PCM';
                system.debug('FreeAccessValue: ' + prd.openAccess);
                if(collectionStatus){
                    lineItem.Open_access__c = true;
                } else {
                    lineItem.Open_access__c = false;
                }
               /* string checkDeleteStatus=checkIfProductExistedinDeletedList(productDoi);
                if(checkDeleteStatus=='false'){
                     lineItem.lineItemStatus__c ='IsInsert';
                }else if(checkDeleteStatus=='true'){
                     lineItem.lineItemStatus__c ='IsUpdate';
                }*/
               lineItem.lineItemStatus__c ='IsInsert';
                if(IsInclude=='Include'){
                    lineItem.IsIncluded__c=true;
                }
                else if (IsInclude=='Exclude'){
                    lineItem.IsIncluded__c=false;
                }
                
                if(prd.type=='Collection'){                
                    lineItem.Product_Doi__c = prd.id +'||'+ parentProductID;
                    lineitem.doi__c = prd.id;
                }
                
                
                lineItem.Content_Position__c  = position++ ;
                listofLineItems.add(lineItem); 
            }
            system.debug('listofLineItems'+listofLineItems);            
            Database.UpsertResult[] srList = Database.upsert(listofLineItems,bundle_line_item__c.Product_Doi__c,false);
            
            return 'Selected Products have been added into the Collection';
        }
        catch(Exception ex){
            System.debug(ex.getMessage());
            System.debug(ex.getStackTraceString());
            
            return 'There was an issue in adding the products, please try later or contact SFDC system admin';
        }        
        
    }
    
    
    @AuraEnabled
    public static processedQuery getStaticPkgPriceFromPCM(String parentProductID, String listOfIds, String IdType, String useSF) {
        Integer itmCount = [SELECT COUNT() FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c =:parentProductID] ;
         MultiTypeQueryObjects multiTypeQueryObject = new MultiTypeQueryObjects();
 		 List<MultiTypeQueryObjects> multiTypeQueryObjectLst = new List<MultiTypeQueryObjects>();
         String Ids='';
        String bundleStatus='IsDelete';
         List<String> idstrLstEbook = new List<String>();
         idstrLstEbook.add('e-Book');
        if(useSF == 'false' && itmCount <= 25000){
            List<QueryObject> QueryObjectLst = new List<QueryObject>();
            List<String> idstrLst = new List<String>();
             List<String> idstrLstFinal = new List<String>();
            processedQuery pq = new processedQuery();
            QueryObject qO = new QueryObject();
            QueryObject qO1 = new QueryObject();   
       	    QueryObject qO2 = new QueryObject();

            qO.type = 'criteria' ;
            qO.name = IdType ;
            qO.operatior = 'IN' ;
            qO.position = 1 ;
            
            if(string.isNotBlank(listOfIds)){
                qO.value = (List<String>) JSON.deserialize(listOfIds, List<String>.class) ; 
            }else{
                list< Bundle_Line_Item__c>  listofLineItems = new list< Bundle_Line_Item__c>();
                for(List<Bundle_Line_Item__c> lineItems : Database.Query('SELECT id,doi__c FROM Bundle_Line_Item__c WHERE lineItemStatus__c!=:bundleStatus and Product_Bundle_Parent__c =:parentProductID limit 50000')){
                    listofLineItems.addAll(lineItems);
                }
                
                for(Bundle_Line_Item__c lI : listofLineItems){
                    //idstrLst.add(lI.doi__c);
                    Ids+=lI.doi__c + ',';
                }
                Ids=Ids.removeEnd(',');
                
                
                //Ids=idstrLst.tostring();
                idstrLstFinal.add(Ids);
                system.debug('Ids####'+ Ids);
                qO.value = idstrLstFinal; 
                //qO.value=Ids;
            }
            system.debug('idstrLst##'+idstrLst);
            qO1.type = 'logical';
            qO1.logicalOpp = 'AND';
            qO1.position = 2;
            qO2.type = 'criteria' ;
            qO2.name = 'book.format' ;
            qO2.operatior = 'IN' ;
            qO2.position = 3 ;
            qO2.value = idstrLstEbook ; 

            QueryObjectLst.add(qO);
            QueryObjectLst.add(qO1);
            QueryObjectLst.add(qO2);

        multiTypeQueryObject.productType = 'book';
        multiTypeQueryObject.queryObject = QueryObjectLst;
        multiTypeQueryObjectLst.add(multiTypeQueryObject);
            system.debug('FinalString###' + JSON.serialize(multiTypeQueryObjectLst));
            
            //pq = getProductsFromPCM(parentProductID ,JSON.serialize(QueryObjectLst) ,'false',0 ,10 ,'USD', 'false','book');
            
            pq= getCountsFromPCM_DynamicUI(parentProductID ,JSON.serialize(multiTypeQueryObjectLst) ,'false',0 ,10 ,'USD', 'true','book','Collections');
            
            return pq;
        }else{
            processedQuery pq = new processedQuery();
            Decimal PriceUSD = 0.0;
            Decimal PriceGBP = 0.0;
            List<AggregateResult> res = [select SUM(PriceGBP__c) PriceGBP, SUM(PriceUSD__c) PriceUSD from Bundle_Line_Item__c WHERE  PriceGBP__c != null AND PriceUSD__c != null AND Product_Bundle_Parent__c =:parentProductID];
            system.debug('PriceUSD'+res[0].get('PriceUSD'));
            system.debug('PriceGBP'+res[0].get('PriceGBP'));
            if(res != null){
                //PriceUSD = Integer.valueOf(res[0].get('PriceUSD')) != null ? Integer.valueOf(res[0].get('PriceUSD')) : 0;
                //PriceGBP = Integer.valueOf(res[0].get('PriceGBP')) != null ? Integer.valueOf(res[0].get('PriceGBP')) : 0;
           		PriceUSD = (Decimal)(res[0].get('PriceUSD')) != null ? (Decimal)(res[0].get('PriceUSD')) : 0;
                PriceGBP = (Decimal)(res[0].get('PriceGBP')) != null ? (Decimal)(res[0].get('PriceGBP')) : 0;
    
            
            }
            pq.queryString = null;
            pq.ruleElementLst = null;
            pq.total = 0;
            pq.offset = 0;
            pq.prList = null;
            pq.msg = 'Success';
            pq.totalPriceUSD = PriceUSD;
            pq.totalPriceGBP = PriceGBP;
            return pq; 
        }
    }
    
    @AuraEnabled
    public static processedQuery fileUploadAndGetFromPCM(String parentProductID, String fileInpt, String IdType, Integer offsetValue, Integer limitValue) {
        System.debug('fileInpt'+fileInpt);
        
        MultiTypeQueryObjects multiTypeQueryObject = new MultiTypeQueryObjects();
        List<MultiTypeQueryObjects> multiTypeQueryObjectLst = new List<MultiTypeQueryObjects>();
        
        List<QueryObject> QueryObjectLst = new List<QueryObject>();
        List<String> idstrLstwithblank = new List<String>();
        List<String> idstrLst = new List<String>();
        List<String> idstrLstEbook = new List<String>();
        idstrLstEbook.add('e-Book');
        String fileBody;
        Blob fileBlob;
        String type='book';
        
        fileInpt = EncodingUtil.urlDecode(fileInpt, 'UTF-8');
        
        fileInpt = (String) JSON.deserialize(fileInpt,String.class);
        system.debug('fileInpt String======='+fileInpt);
       // idstrLst = fileInpt.split(',');
        idstrLst.add(fileInpt);
        
        if(IdType=='doi_chapter'){
            IdType='identifiers.doi';
            type='chapter';
        }
        else if (IdType=='doi_article'){
            IdType='identifiers.doi';
            type='scholarlyArticle';
        }
        else if (IdType=='doi_creativework'){
            IdType='identifiers.doi';
            type='creativeWork';
        }
        else if (IdType== 'doi_entryversion'){
            IdType='identifiers.doi';
            type='entryVersion';
        }
        
        processedQuery pq = new processedQuery();
        QueryObject qO = new QueryObject();
        
        qO.type = 'criteria' ;
        qO.name = IdType ;
        qO.operatior = 'IN' ;
        qO.position = 1 ;
        qO.value = idstrLst ; 
        
        //second criteria
        QueryObject qO1 = new QueryObject();   
        QueryObject qO2 = new QueryObject();
        if(type=='book' && IdType=='identifiers.doi'){
            qO1.type = 'logical';
            qO1.logicalOpp = 'AND';
            qO1.position = 2;
            qO2.type = 'criteria' ;
            qO2.name = 'book.format' ;
            qO2.operatior = 'IN' ;
            qO2.position = 3 ;
            qO2.value = idstrLstEbook ; 
        }
        
        
        
        QueryObjectLst.add(qO);
        if(type=='book' && IdType=='identifiers.doi'){
            QueryObjectLst.add(qO1);
            QueryObjectLst.add(qO2);
        }
        
        
        multiTypeQueryObject.productType = type;
        multiTypeQueryObject.queryObject = QueryObjectLst;
        multiTypeQueryObjectLst.add(multiTypeQueryObject);
        // pq = getProductsFromPCM(parentProductID ,JSON.serialize(QueryObjectLst) ,'false',offsetValue ,limitValue ,'USD', 'true','Book');
        pq = getPrdsFromPCM_DynamicUI(parentProductID ,JSON.serialize(multiTypeQueryObjectLst) ,'false',offsetValue, null ,limitValue ,'USD', 'true',type,'Collections');
        
        return pq;
    }
    
    
    @AuraEnabled
    public static List<Setting_Item__c> getNetBaseClassifications(){
        String customLabelValue = System.Label.getNetBaseClassifications;
        system.debug('customLabelValue' + ' ' + customLabelValue);
        List<Setting_Item__c> lstResult=new List<Setting_Item__c>();
        lstResult=[SELECT Text_1__c FROM Setting_Item__c WHERE Setting__r.Name =: customLabelValue AND Checkbox_1__c = TRUE ORDER BY Text_1__c ASC limit 1000]; 
        if(lstResult != null && lstResult.size()>0){
            return lstResult;
        }
        return lstResult;
        
    }
    
    
    @AuraEnabled
    public static List<Setting_Item__c> getWCClassifications(){
        String customLabelValue = 'WC_CodesClassifications';
        system.debug('customLabelValue' + ' ' + customLabelValue);
        List<Setting_Item__c> lstResult=new List<Setting_Item__c>();
        lstResult=[SELECT Text_1__c FROM Setting_Item__c WHERE Setting__r.Name =: customLabelValue AND Checkbox_1__c = TRUE ORDER BY Text_1__c ASC limit 1000]; 
        if(lstResult != null && lstResult.size()>0){
            return lstResult;
        }
        return lstResult;
        
    }
    
    @AuraEnabled
    public static List<Setting_Item__c> getCountryForRestrictions(){
        String customLabelValue = 'Country_Codes';
        system.debug('customLabelValue' + ' ' + customLabelValue);
        List<Setting_Item__c> lstResult=new List<Setting_Item__c>();
        lstResult=[SELECT Text_1__c FROM Setting_Item__c WHERE Setting__r.Name =: customLabelValue AND Checkbox_1__c = TRUE ORDER BY Text_1__c ASC limit 1000]; 
        if(lstResult != null && lstResult.size()>0){
            return lstResult;
        }
        return lstResult;
        
    }
    
    @AuraEnabled
    public static String TreeGetSubjectClassifications(String ClassificationType){
        Map<String,TreeWrapper> mapBackTree = new Map<String,TreeWrapper>();
        List<TreeWrapper> topLevelRecords = new List<TreeWrapper>();
        List<TreeWrapper> jsListWrap = new List<TreeWrapper>(); 
        Set<string> labelSet = new Set<string>();
        Map<Id,List<TreeWrapper>> parentIdmappingSetting = new Map<Id,List<TreeWrapper>>();
        //String customLabelValue = System.Label.getSubjectClassifications;
        List<CAS_Subject_Code__c> lstResult=new List<CAS_Subject_Code__c>();
        system.debug('ClassificationType: ' + ClassificationType);
        //lstResult=[SELECT Id,Name,Parent__c FROM CAS_Subject_Code__c WHERE Group_ID__c='CAS' ORDER BY Name ASC limit 10000]; 
        if(ClassificationType == 'BISAC'){
            lstResult=[SELECT Id,Subject_Code__c,Parent__c FROM CAS_Subject_Code__c WHERE Group_ID__c='BISAC' ORDER BY Subject_Code__c ASC limit 10000]; 
        } else if(ClassificationType == 'Subject'){
            lstResult=[SELECT Id,Name,Parent__c FROM CAS_Subject_Code__c WHERE Group_ID__c='CAS' ORDER BY Name ASC limit 10000]; 
        }
  
        if(lstResult != null && lstResult.size()>0){
            for(CAS_Subject_Code__c si : lstResult){
                /* if(si.Name != null){
                    labelSet.add(si.Name);
                }
                    
                TreeWrapper twTempRec = new TreeWrapper();
                twTempRec.recId       =  si.Id;
                    twTempRec.labelValue  =  si.Name;*/
               
                if(ClassificationType == 'Subject'){
                if(si.Name != null){
                    labelSet.add(si.Name);
                }} else if(ClassificationType == 'BISAC'){
                   if(si.Subject_Code__c != null){
                    labelSet.add(si.Subject_Code__c);
                } 
                }
                TreeWrapper twTempRec = new TreeWrapper();
                twTempRec.recId       =  si.Id;
                if(ClassificationType == 'Subject'){
                    twTempRec.labelValue  =  si.Name;
                } else if(ClassificationType == 'BISAC'){
                    twTempRec.labelValue  =  si.Subject_Code__c;
                }
                
                twTempRec.isCheck     =  False;
                List<TreeWrapper> ct = new List<TreeWrapper>(); 
                twTempRec.childTree   =  ct ;
                if(si.Parent__c != null){
                    List<TreeWrapper> tempsetting = new List<TreeWrapper>();
                    if(parentIdmappingSetting.containsKey(si.Parent__c)){
                        tempsetting = parentIdmappingSetting.get(si.Parent__c);
                        tempsetting.add(twTempRec);
                        parentIdmappingSetting.put(si.Parent__c,tempsetting);
                    }
                    else{
                        tempsetting.add(twTempRec);
                        parentIdmappingSetting.put(si.Parent__c,tempsetting);
                    }
                }
                else{
                    topLevelRecords.add(twTempRec);
                }  
            }
            for(TreeWrapper toplev:topLevelRecords){
                
                
                List<TreeWrapper> level1Records = new List<TreeWrapper>();
                //List<TreeWrapper> level2Records = new List<TreeWrapper>();
                //List<TreeWrapper> level3Records = new List<TreeWrapper>();
                
                if(parentIdmappingSetting.containsKey(toplev.recId)||Test.isRunningTest()){
                    level1Records.addAll(parentIdmappingSetting.get(toplev.recId));
                    for(TreeWrapper tw1 : level1Records){
                        List<TreeWrapper> level2Records = new List<TreeWrapper>();    
                        if(parentIdmappingSetting.containsKey(tw1.recId)){
                            level2Records.addAll(parentIdmappingSetting.get(tw1.recId));
                            for(TreeWrapper tw2 : level2Records){
                                List<TreeWrapper> level3Records = new List<TreeWrapper>();    
                                if(parentIdmappingSetting.containsKey(tw2.recId)){
                                    level3Records.addAll(parentIdmappingSetting.get(tw2.recId));
                                    for(TreeWrapper tw3 : level3Records){
                                        List<TreeWrapper> level4Records = new List<TreeWrapper>();    
                                        if(parentIdmappingSetting.containsKey(tw3.recId)){
                                            level4Records.addAll(parentIdmappingSetting.get(tw3.recId));
                                            for(TreeWrapper tw4 : level4Records){
                                                List<TreeWrapper> level5Records = new List<TreeWrapper>();    
                                                if(parentIdmappingSetting.containsKey(tw4.recId)){
                                                    level5Records.addAll(parentIdmappingSetting.get(tw4.recId));
                                                }
                                                tw4.childTree.addAll(level5Records);
                                            }
                                        }
                                        tw3.childTree.addAll(level4Records);
                                    }
                                }
                                tw2.childTree.addAll(level3Records);
                            }
                        }
                        tw1.childTree.addAll(level2Records);
                    }
                }
                toplev.childTree.addAll(level1Records);
                
            }
            
            
            
            
        }
        
        String jsonData = JSON.serialize(topLevelRecords);
        String labelN = JSON.serialize(labelSet);
        system.debug('CodesJSON: ' + jsonData +'$$$$$$$$$$'+ labelN);
        return jsonData +'$$$$$$$$$$'+ labelN;
    }
    
    @AuraEnabled
    public static String TreeGetDeweyClassifications(){
        Map<String,TreeWrapper> mapBackTree = new Map<String,TreeWrapper>();
        List<TreeWrapper> topLevelRecords = new List<TreeWrapper>();
        List<TreeWrapper> jsListWrap = new List<TreeWrapper>();
        Set<string> labelSet = new Set<string>();
        Map<Id,List<TreeWrapper>> parentIdmappingSetting = new Map<Id,List<TreeWrapper>>();
        //String customLabelValue = System.Label.getSubjectClassifications;
        List<DeweyCode__c> lstResult=new List<DeweyCode__c>();
        lstResult=[SELECT Id,Name,Parent__c FROM DeweyCode__c ORDER BY Name ASC limit 10000]; 
        if(lstResult != null && lstResult.size()>0){
            for(DeweyCode__c si : lstResult){
                if(si.Name != null){
                    labelSet.add(si.Name);
                }
                TreeWrapper twTempRec = new TreeWrapper();
                twTempRec.recId       =  si.Id;
                twTempRec.labelValue  =  si.Name;
                twTempRec.isCheck     =  False;
                List<TreeWrapper> ct = new List<TreeWrapper>(); 
                twTempRec.childTree   =  ct ;
                if(si.Parent__c != null){
                    List<TreeWrapper> tempsetting = new List<TreeWrapper>();
                    if(parentIdmappingSetting.containsKey(si.Parent__c)){
                        tempsetting = parentIdmappingSetting.get(si.Parent__c);
                        tempsetting.add(twTempRec);
                        parentIdmappingSetting.put(si.Parent__c,tempsetting);
                    }
                    else{
                        tempsetting.add(twTempRec);
                        parentIdmappingSetting.put(si.Parent__c,tempsetting);
                    }
                }
                else{
                    topLevelRecords.add(twTempRec);
                }  
            }
            for(TreeWrapper toplev:topLevelRecords){
                
                
                List<TreeWrapper> level1Records = new List<TreeWrapper>();
                //List<TreeWrapper> level2Records = new List<TreeWrapper>();
                //List<TreeWrapper> level3Records = new List<TreeWrapper>();
                
                if(parentIdmappingSetting.containsKey(toplev.recId)||Test.isRunningTest()){
                    level1Records.addAll(parentIdmappingSetting.get(toplev.recId));
                    for(TreeWrapper tw1 : level1Records){
                        List<TreeWrapper> level2Records = new List<TreeWrapper>();    
                        if(parentIdmappingSetting.containsKey(tw1.recId)){
                            level2Records.addAll(parentIdmappingSetting.get(tw1.recId));
                            for(TreeWrapper tw2 : level2Records){
                                List<TreeWrapper> level3Records = new List<TreeWrapper>();    
                                if(parentIdmappingSetting.containsKey(tw2.recId)){
                                    level3Records.addAll(parentIdmappingSetting.get(tw2.recId));
                                    for(TreeWrapper tw3 : level3Records){
                                        List<TreeWrapper> level4Records = new List<TreeWrapper>();    
                                        if(parentIdmappingSetting.containsKey(tw3.recId)){
                                            level4Records.addAll(parentIdmappingSetting.get(tw3.recId));
                                            for(TreeWrapper tw4 : level4Records){
                                                List<TreeWrapper> level5Records = new List<TreeWrapper>();    
                                                if(parentIdmappingSetting.containsKey(tw4.recId)){
                                                    level5Records.addAll(parentIdmappingSetting.get(tw4.recId));
                                                }
                                                tw4.childTree.addAll(level5Records);
                                            }
                                        }
                                        tw3.childTree.addAll(level4Records);
                                    }
                                }
                                tw2.childTree.addAll(level3Records);
                            }
                        }
                        tw1.childTree.addAll(level2Records);
                    }
                }
                toplev.childTree.addAll(level1Records);
                
            }
            
            
            
            
        }
        
        String jsonData = JSON.serialize(topLevelRecords);
        String labelN = JSON.serialize(labelSet);
        return jsonData +'$$$$$$$$$$'+ labelN;
    }
    
   
    
    @AuraEnabled
    public static DynamicUIValueLst getDynamicUIValues(String grandParent , String parent, String consumer) {
        
        String query;
        String selectAndWhere_Clause;
        DynamicUIValueLst dUILst = new DynamicUIValueLst();
        List<DynamicUIValue> dValLst = new List<DynamicUIValue>();
        
        List<Setting_Item__c> settingItemLst = new List<Setting_Item__c>();
        selectAndWhere_Clause = 'SELECT Id,Checkbox_1__c,Checkbox_2__c,Checkbox_3__c, Checkbox_4__c,Text_1__c,Text_2__c,Text_3__c,Text_4__c,Text_5__c,Text_6__c,Long_Text_1__c,Text_7__c, Text_8__c From Setting_Item__c WHERE ';
        
        if(String.isNotBlank(grandParent)){
            selectAndWhere_Clause+= 'Text_1__c = \''+grandParent+'\' AND ' ;
        }
        
        if(String.isNotBlank(consumer) && !consumer.equalsIgnoreCase('All')){
            query = selectAndWhere_Clause + 'Text_2__c = \''+parent+'\' AND Setting__r.Name = \'DynamicSearchUIValues\' AND M_Picklist_1__c INCLUDES (\''+consumer+'\') AND Checkbox_4__c = true order by Text_3__c LIMIT 5000'; 
        }else{
            query = selectAndWhere_Clause + 'Text_2__c = \''+parent+'\' AND Setting__r.Name = \'DynamicSearchUIValues\'  AND Checkbox_4__c = true order by Text_3__c LIMIT 5000';  
        }
        
        system.debug(query);
        if(String.isNotBlank(query)){
            settingItemLst = Database.query(query);
        }
        
        if(settingItemLst != null){
            for(Setting_Item__c sItm : settingItemLst){
                DynamicUIValue dVal = new DynamicUIValue();
                dVal.grandParent= sItm.Text_1__c;
                dVal.parent= sItm.Text_2__c;
                dVal.fieldLabel= sItm.Text_3__c;
                dVal.fieldValue= sItm.Text_4__c;
                dVal.dataType= sItm.Text_5__c;
                dVal.supportedOperator= sItm.Long_Text_1__c;
                dVal.dotNotation= sItm.Text_6__c;
                dVal.useValueFrom= sItm.Text_7__c;
                dVal.fileUpload= sItm.Checkbox_1__c;
                dVal.hasChild= sItm.Checkbox_2__c;
                dVal.hasOperator= sItm.Checkbox_3__c;
                dVal.queryLabel = sItm.Text_8__c;
                dValLst.add(dVal);
            }
        }else{
            return null;
        }
        
        dUILst.valueLst = dValLst;
        system.debug('===dUILst===' + dUILst);
        return dUILst ;
    }
    
    @AuraEnabled
    public static List<TF_PPDProcessController.MultiTypeRules> processQueryObj_Dynamic(String queryObj){
        System.debug('queryObj'+queryObj);
        // if(queryObj!='[{}]'){
        List<String> fullQuerlListStr = new  List<String>();
        List<String> productTypeList = new  List<String>();
        MAP<String,String> OpeValMap = new MAP<String,String>();
        MAP<Integer,RuleElement> tempQueryElementMAP = new MAP<Integer,RuleElement>();
        List<RuleElement> tempQueryElementLst = new List<RuleElement>();
        processedQuery returnObj = new processedQuery();
        List<TF_PPDProcessController.MultiTypeRules> multiTypeRulesLstLst = new List<TF_PPDProcessController.MultiTypeRules>();
        
        List<MultiTypeQueryObjects> multiQueryObjectList = (List<MultiTypeQueryObjects>) JSON.deserialize(queryObj, List<MultiTypeQueryObjects>.class);
        List<MultiTypeQueryObjects> mergerMultiQueryObjectList = new List<MultiTypeQueryObjects>();
        
        OpeValMap.put('IN','IN');
        OpeValMap.put('NOT IN','NI');
        OpeValMap.put('Minimum','GE');
        OpeValMap.put('Maximum','LE');
        OpeValMap.put('After','GT');
        OpeValMap.put('Before','LT');
        OpeValMap.put('Equals','EQ');
        OpeValMap.put('Not Equals','NE');
        OpeValMap.put('Like','LIKE');
        OpeValMap.put('Prefix','PREFIX');
        
        if(multiQueryObjectList != null && multiQueryObjectList.size() > 0){
            
            for (MultiTypeQueryObjects mulObjOut : multiQueryObjectList){
                if(productTypeList != null && !productTypeList.contains(mulObjOut.productType)){
                    MultiTypeQueryObjects mergerMultiQueryObject = new MultiTypeQueryObjects();
                    List<QueryObject> QueryObjectList = new  List<QueryObject>();
                    QueryObject qObj = new QueryObject();
                    qObj.type = 'logical';
                    qObj.logicalOpp = 'OR';
                    QueryObject qObjBEGIN = new QueryObject();
                    qObjBEGIN.type = 'separatorBEGIN';
                    QueryObject qObjEND = new QueryObject();
                    qObjEND.type = 'separatorEND';
                    
                    for (MultiTypeQueryObjects mulObjin : multiQueryObjectList){
                        if(mulObjOut.productType == mulObjin.productType){
                            productTypeList.add(mulObjOut.productType);
                            mergerMultiQueryObject.productType = mulObjOut.productType;
                            QueryObjectList.addAll(mulObjin.queryObject);
                            QueryObjectList.add(qObj);
                        }
                    }
                    QueryObjectList.remove(QueryObjectList.size()-1);
                    mergerMultiQueryObject.queryObject = QueryObjectList;
                    mergerMultiQueryObjectList.add(mergerMultiQueryObject);
                }
            }
            multiQueryObjectList.clear();
            for (MultiTypeQueryObjects mulObj : mergerMultiQueryObjectList){
                List<QueryObject> QueryObjectList = new  List<QueryObject>();
                List<RuleElement> queryElementLst = new List<RuleElement>();
                String fullStr = '';
                
                QueryObjectList = mulObj.queryObject ;
                
                Integer counter = 1 ;
                for(QueryObject obj : QueryObjectList){
                    
                    RuleElement ruleEle = new RuleElement();
                    
                    List<String> QryTypeList = new  List<String>();
                    String QryStr = '';
                    List<String> valueLst = new List<String> ();
                    if(obj.type == 'criteria'){
                        QryStr = obj.queryLabel +' '+ obj.operatior +' ';
                        valueLst = obj.value ;
                        // String valueStr = '';
                        QryStr = QryStr + obj.value ;
                  
                        ruleEle.type = 'criteria';
                        ruleEle.attribute = obj.name;
                        ruleEle.relationship = OpeValMap.get(obj.operatior);
                        ruleEle.relationshipLabel = obj.operatior;
                        ruleEle.attributeLabel = obj.queryLabel;
                        ruleEle.value = valueLst[0];
                        //ruleEle.value = valueStr;
                    }
                    
                    if(obj.type == 'logical'){
                        QryStr = obj.logicalOpp;
                        ruleEle.type = 'logical';
                        ruleEle.value = obj.logicalOpp;
                    }
                    
                    if(obj.type == 'separatorBEGIN'){
                        QryStr = '{ ';
                        ruleEle.type = 'separator';
                        ruleEle.value = 'BEGIN';
                    }
                    
                    if(obj.type == 'separatorEND'){
                        QryStr = ' }';
                        ruleEle.type = 'separator';
                        ruleEle.value = 'END';
                    }
                    
                    QryStr = '#-#-#'+ QryStr +'#-#-#';
                    
                    queryElementLst.add(ruleEle);
                    fullStr = fullStr + QryStr ;
                    counter++ ;
                }
                
                RuleElement ruleEleStart = new RuleElement();
                ruleEleStart.type = 'separator';
                ruleEleStart.value = 'BEGIN';
                
                RuleElement ruleEleEnd = new RuleElement();
                ruleEleEnd.type = 'separator';
                ruleEleEnd.value = 'END';
                
                if(queryElementLst != null && queryElementLst.size() > 0){
                    queryElementLst.add(0,ruleEleStart);
                    queryElementLst.add(ruleEleEnd);  
                }else if(queryElementLst != null){
                    queryElementLst.add(ruleEleStart);
                    queryElementLst.add(ruleEleEnd);  
                }
                
                
                fullQuerlListStr = fullStr.split('#-#-#');
                fullStr = '' ;
                for(String str : fullQuerlListStr){
                    if(str.trim() != null && str.trim() != '' ){
                        fullStr = fullStr + str.trim() +' ';
                    }
                }
                system.debug('fullStr'+ fullStr);
                system.debug('queryElementLst'+ queryElementLst);
                system.debug('queryElementLstSTRING'+ JSON.serialize(queryElementLst)); 
                
                returnObj.queryString = fullStr;
                returnObj.ruleElementLst = queryElementLst;
                
                TF_PPDProcessController.MultiTypeRules multiTypeRulesLst = new TF_PPDProcessController.MultiTypeRules();
                
                multiTypeRulesLst.queryString = fullStr ;
                multiTypeRulesLst.ruleElementLst = queryElementLst ;
                multiTypeRulesLst.productType = mulObj.productType ;
                
                multiTypeRulesLstLst.add(multiTypeRulesLst);
            }
        }
        return multiTypeRulesLstLst ;
        //}
        //else {
        // return null;
        //}
    }
    
    private static String getSalesforceBaseUrl(){
        String host = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        return host;
    }
    
    @AuraEnabled
    public static processedQuery getPrdsFromPCM_DynamicUI(String bundleId, String queryObj, String savedRule, Integer offsetValue,String offsetCursor, Integer limitValue,String searchCurrency, String getAll, String productType, String consumer) {
        
        String jsonStr = '';
        List<TF_PPDProcessController.RuleElement> ruleElementLst = new List<TF_PPDProcessController.RuleElement>();
        List<TF_PPDProcessController.MultiTypeRules> multiTypeRulesLst = new List<TF_PPDProcessController.MultiTypeRules>();
        TF_PPDProcessController.MultiTypeRules multiTypeRules = new TF_PPDProcessController.MultiTypeRules();
        processedQuery queryStrAndObj = new processedQuery();
       
        if(savedRule == 'true'){
            querySaveElement savedQry = new querySaveElement();
            Filter filters = new Filter();
            savedQry = parseRuleJson(bundleId);
            if(savedQry != null && (savedQry.ruleElementLst != null || savedQry.multiTypeRulesLst != null)){
                if(savedQry.isDynamicUi == 'true'){                    
                    multiTypeRulesLst = savedQry.multiTypeRulesLst ;
                    if(productType == '' || productType == null){
                        productType = multiTypeRulesLst[0].productType ;
                    }
                }else{
                    ruleElementLst = savedQry.ruleElementLst ;
                    if(productType == '' || productType == null){
                        filters = savedQry.filterObject;
                        productType = filters.mediumData ;
                        
                    }
                    system.debug('ruleElementLst====='+ruleElementLst);
                    multiTypeRules.ruleElementLst = ruleElementLst ;
                    productType = productType == 'e-Book' ? 'book' : productType;
                    multiTypeRules.productType = productType;
                    multiTypeRulesLst.add(multiTypeRules);
                }
            }else{
                List <PagedResult> pr = new List <PagedResult>();
                queryStrAndObj.total = 0;
                queryStrAndObj.prList = pr;
                queryStrAndObj.msg = 'Products not found';
                return queryStrAndObj;  
            }
        }else{
            multiTypeRulesLst = processQueryObj_Dynamic(queryObj);  
            
        }
        jsonStr = TF_GenerateJson.GenerateQueryJsonNewModel(bundleId, productType, multiTypeRulesLst, offsetValue, offsetCursor , limitValue, consumer);
       	system.debug('jsonStr' +jsonStr );
        queryStrAndObj = callNewModelQueryAPI(queryStrAndObj, jsonStr, offsetValue, limitValue, searchCurrency, getAll, bundleId);
        
        queryStrAndObj.multiTypeRulesLst = multiTypeRulesLst;
        
        // below value is captured in component on first call hence we need not send this back to UI for every page.
        
        if(offsetValue > 0){
            queryStrAndObj.multiTypeRulesLst = null;
            queryStrAndObj.queryString = null;
        }
        
        system.debug('queryStrAndObj' + queryStrAndObj);
        
        return queryStrAndObj;  
    }
    
    /* public static processedQuery getPrdsFromPCM_DynamicUI(String bundleId, String queryObj, String savedRule, Integer offsetValue, Integer limitValue,String searchCurrency, String getAll, String productType) {
System.debug('queryObjInsidegetPrdsFromPCM_DynamicUI' + queryObj);
String jsonStr = '';
List<TF_PPDProcessController.RuleElement> ruleElementLst = new List<TF_PPDProcessController.RuleElement>();
List<TF_PPDProcessController.MultiTypeRules> multiTypeRulesLst = new List<TF_PPDProcessController.MultiTypeRules>();
TF_PPDProcessController.MultiTypeRules multiTypeRules = new TF_PPDProcessController.MultiTypeRules();
processedQuery queryStrAndObj = new processedQuery();

multiTypeRulesLst = processQueryObj_Dynamic(queryObj);  
system.debug('###multiTypeRulesLst###'+multiTypeRulesLst);
//jsonStr = TF_GenerateJson.GenerateQueryJson(bundleId, productType, multiTypeRulesLst, offsetValue, limitValue);
jsonStr = TF_GenerateJson.GenerateQueryJsonNewModel(bundleId, productType, multiTypeRulesLst, offsetValue, limitValue);
//queryStrAndObj = callQueryAPI(queryStrAndObj, jsonStr, offsetValue, limitValue, searchCurrency, getAll, bundleId);
queryStrAndObj = callNewModelQueryAPI(queryStrAndObj, jsonStr, offsetValue, limitValue, searchCurrency, getAll, bundleId);

queryStrAndObj.multiTypeRulesLst = multiTypeRulesLst;
if(offsetValue > 0){
queryStrAndObj.multiTypeRulesLst = null;
queryStrAndObj.queryString = null;
}
system.debug('queryStrAndObj' + queryStrAndObj);
return queryStrAndObj;  
}
*/
    @AuraEnabled
    
    public static processedQuery getCountsFromPCM_DynamicUI(String bundleId, String queryObj, String savedRule, Integer offsetValue, Integer limitValue,String searchCurrency, String getAll, String productType, String consumer) {
        System.debug('queryCountsAPI' + queryObj);
        system.debug('Inside getCountsFromPCM_DynamicUI'  + bundleId);
        system.debug('line4079' + savedRule);
        system.debug('line4080' + offsetValue);
        system.debug('line4081' + limitValue); 
        system.debug('String4082'+ searchCurrency);
        system.debug('String4083' + getAll);
        system.debug('String4084' + productType);
        system.debug('String4085'+ consumer);
        //currentRecord = [SELECT Id FROM Product2 WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        
        String jsonStr = '';
        List<TF_PPDProcessController.RuleElement> ruleElementLst = new List<TF_PPDProcessController.RuleElement>();
        List<TF_PPDProcessController.MultiTypeRules> multiTypeRulesLst = new List<TF_PPDProcessController.MultiTypeRules>();
        TF_PPDProcessController.MultiTypeRules multiTypeRules = new TF_PPDProcessController.MultiTypeRules();
        processedQuery queryStrAndObj = new processedQuery(); 
        
        system.debug('multiTypeRulesLst'+multiTypeRulesLst);
        // for savedRule
        if(savedRule == 'true'){
            String productTypeFromQuery ;
            Filter filters = new Filter();
            querySaveElement savedQry = new querySaveElement();
            system.debug('line4094' +bundleId );
            savedQry = parseRuleJson(bundleId);
            if(savedQry != null && (savedQry.ruleElementLst != null || savedQry.multiTypeRulesLst != null)){
                if(savedQry.isDynamicUi == 'true'){                    
                    multiTypeRulesLst = savedQry.multiTypeRulesLst ;
                    if(productType == '' || productType == null){
                        productType = multiTypeRulesLst[0].productType;
                    }
                }else{
                    ruleElementLst = savedQry.ruleElementLst ;
                    if(productType == '' || productType == null){
                        filters = savedQry.filterObject;
                        productType = filters.mediumData ;
                        
                    }
                    system.debug('ruleElementLst====='+ruleElementLst);
                    multiTypeRules.ruleElementLst = ruleElementLst ;
                    productType = productType == 'e-Book' ? 'book' : productType;
                    multiTypeRules.productType = productType;
                    multiTypeRulesLst.add(multiTypeRules);
                }
            }else{
                List <PagedResult> pr = new List <PagedResult>();
                queryStrAndObj.total = 0;
                queryStrAndObj.prList = pr;
                queryStrAndObj.msg = 'Products not found';
                return queryStrAndObj;  
            }
        }else{
            If(queryObj!=null){
                multiTypeRulesLst = processQueryObj_Dynamic(queryObj); 
            }            
        }
        
        //End Of SavedRule
        
        jsonStr = TF_GenerateJson.GenerateCountAPIJson(bundleId, productType, multiTypeRulesLst, offsetValue, limitValue, consumer);
        system.debug('CountsjsonStr====' +jsonStr);
        queryStrAndObj = callCountsAPI(queryStrAndObj, jsonStr, offsetValue, limitValue, searchCurrency, getAll, bundleId);
        queryStrAndObj.multiTypeRulesLst = multiTypeRulesLst;
        if(offsetValue > 0){
            queryStrAndObj.multiTypeRulesLst = null;
            queryStrAndObj.queryString = null;
        }
        system.debug('queryStrAndObj' + queryStrAndObj);
        return queryStrAndObj;   
    }
    
    @AuraEnabled
    public static String checkIfPriceBookEntryExist(String bundleID) {
        try{        
            //checking the PricebookEntryInfo
            List <PricebookEntry> pbe = getPriceBookEntry(bundleID);
            //Decimal UnitPriceInGBP=0.00;
            //Decimal UnitPriceInUSD=0.00;
            Decimal UnitPriceInGBP;
            Decimal UnitPriceInUSD;
            for(PricebookEntry pb: pbe){
                if(pb.CurrencyIsoCode=='GBP') {           
                    UnitPriceInGBP=pb.UnitPrice;  
                    system.debug('UnitPriceInGBP' + UnitPriceInGBP);
                }
                else if(pb.CurrencyIsoCode=='USD'){            
                    UnitPriceInUSD=pb.UnitPrice;
                    system.debug('UnitPriceInUSD' + UnitPriceInUSD);                    
                }
            }  
            
            if((UnitPriceInGBP<0.00 || UnitPriceInGBP==null)&&(UnitPriceInUSD<0.00 || UnitPriceInUSD==null)){
                Return 'False';
            }
            else {
                Return 'True';
            }
        }
        Catch(Exception ex) {       
            system.debug(ex.getMessage());
            return 'False';
        }
    }
    
    @AuraEnabled
    public static String checkIfValidityDatesExist(String bundleID) {
        try{        
            product2 prd=getCollectionValidity(bundleID);
            
            if(prd.Collection_Valid_From__c  !=null || prd.Collection_Valid_To__c!=null ||   prd.Collection_updatedFrom__c!=null|| prd.Collection_updatedTo__c!=null){
                Return 'True';
            }
            else {
                Return 'False';
            }
        }
        Catch(Exception ex) {       
            system.debug(ex.getMessage());
            return 'False';
        }
    }
    
    @AuraEnabled
    public static String checkIfValidBusinessIdExist(String bundleID) {
        try{        
            Product2 prd = new Product2();
            prd = [SELECT Id,IsBusinessIdValidated__c  FROM Product2 WHERE id = :bundleID limit 1];
            
            if(prd.IsBusinessIdValidated__c ==true ){
                Return 'True';
            }
            else if(prd.IsBusinessIdValidated__c ==false ){
                Return 'False';
            }
            else{
                Return 'False';
            }
        }
        Catch(Exception ex) {       
            system.debug(ex.getMessage());
            return 'False';
        }
    }
    
    
    @AuraEnabled
    public static String updateNetBaseClassification(String bundleID, String NetbaseCollections) {
        List<Product2> productLst = new List<Product2>();
        productLst = [SELECT id FROM Product2 WHERE id = :bundleID limit 1];
        
        if(productLst != null && productLst.size() > 0 ){
            product2 prd = new product2();
            prd.id = productLst[0].id ;
            //prd.NetBaseClassifications__c = NetbaseCollections;
            prd.Netbase_Classifications__c = NetbaseCollections;
            update prd;
            return 'NetBase Collections Saved!';
        }else{
            return 'Error';
        }
    }
    
    @AuraEnabled
    public static  Product2 getNetBaseClassification(String bundleID) {
        Product2 product = new Product2();
        product = [SELECT id,Netbase_Classifications__c FROM Product2 WHERE id = :bundleID limit 1];
        
        if(product != null){
            
            return product;
        }else{
            return null;
        }
    }
    
    
    @AuraEnabled
    public static String updateSubjectClassification(String bundleID, String SubjectClassifications) {
        List<Product2> productLst = new List<Product2>();
        productLst = [SELECT id FROM Product2 WHERE id = :bundleID limit 1];
        
        if(productLst != null && productLst.size() > 0 ){
            product2 prd = new product2();
            prd.id = productLst[0].id ;
            // prd.SubjectClassifications__c = SubjectClassifications;
            prd.Subject_Classifications__c = SubjectClassifications;
            update prd;
            return 'Subject Classifications Saved!';
        }else{
            return 'Error';
        }
    }
    
    @AuraEnabled
    public static Product2 getSubjectClassification(String bundleID) {
        Product2 product = new Product2();
        product = [SELECT id,Subject_Classifications__c  FROM Product2 WHERE id = :bundleID limit 1];
        
        if(product != null){
            
            return product;
        }else{
            return null;
        }
    }
    
    @AuraEnabled
    public static String updateCollectionValidity(String bundleID, Datetime ValidTo, Datetime ValidFrom,Datetime UpdatedFrom,Datetime UpdatedTo) {
        List<Product2> productLst = new List<Product2>();
        productLst = [SELECT id FROM Product2 WHERE id = :bundleID limit 1];
        
        if(productLst != null && productLst.size() > 0 ){
            product2 prd = new product2();
            prd.id = productLst[0].id ;
            //prd.NetBaseClassifications__c = NetbaseCollections;
            prd.Collection_Valid_From__c = ValidFrom;
            prd.Collection_Valid_To__c = ValidTo;
            prd.Collection_updatedFrom__c=UpdatedFrom;
            prd.Collection_updatedTo__c=UpdatedTo;
            
            
            update prd;
            return 'Info Saved!';
        }else{
            return 'Error';
        }
    }
    
    @AuraEnabled
    public static  Product2 getCollectionValidity(String bundleID) {
        Product2 product = new Product2();
        product = [SELECT Id,Collection_Valid_To__c,Collection_Valid_From__c,Collection_updatedTo__c,Collection_updatedFrom__c FROM Product2 WHERE id = :bundleID limit 1];
        
        if(product != null){
            
            return product;
        }else{
            return null;
        }
    }
    
    @AuraEnabled
    public static DynamicUIValueLst getDotNotations(String grandParent , String parent) {
        
        String query;
        String selectAndWhere_Clause;
        DynamicUIValueLst dUILst = new DynamicUIValueLst();
        List<DynamicUIValue> dValLst = new List<DynamicUIValue>();
        
        List<Setting_Item__c> settingItemLst = new List<Setting_Item__c>();
        selectAndWhere_Clause = 'SELECT Id,Checkbox_1__c,Checkbox_2__c,Checkbox_3__c, Checkbox_4__c,Text_1__c,Text_2__c,Text_3__c,Text_4__c,Text_5__c,Text_6__c,Long_Text_1__c,Text_7__c, Text_8__c From Setting_Item__c WHERE ';
        
        if(String.isNotBlank(grandParent)){
            selectAndWhere_Clause+= 'Text_1__c = \''+grandParent+'\' AND ' ;
        }
        
        query = selectAndWhere_Clause + 'Text_2__c = \''+parent+'\' AND Setting__r.Name = \'DynamicSearchUIValues\'  AND Checkbox_4__c = true order by Text_3__c LIMIT 5000'; 
        system.debug(query);
        if(String.isNotBlank(query)){
            settingItemLst = Database.query(query);
        }
        
        if(settingItemLst != null){
            for(Setting_Item__c sItm : settingItemLst){
                DynamicUIValue dVal = new DynamicUIValue();
                dVal.grandParent= sItm.Text_1__c;
                dVal.parent= sItm.Text_2__c;
                dVal.fieldLabel= sItm.Text_3__c;
                dVal.fieldValue= sItm.Text_4__c;
                dVal.dataType= sItm.Text_5__c;
                dVal.supportedOperator= sItm.Long_Text_1__c;
                dVal.dotNotation= sItm.Text_6__c;
                dVal.useValueFrom= sItm.Text_7__c;
                dVal.fileUpload= sItm.Checkbox_1__c;
                dVal.hasChild= sItm.Checkbox_2__c;
                dVal.hasOperator= sItm.Checkbox_3__c;
                dVal.queryLabel = sItm.Text_8__c;
                dValLst.add(dVal);
            }
        }else{
            return null;
        }
        
        dUILst.valueLst = dValLst;
        system.debug('===dUILst===' + dUILst);
        return dUILst ;
    }
    
    @AuraEnabled
    public static  List<ResultCoulmnsForType> getResultColumns() {
        List<String> fieldLst;
        String query;
        String selectAndWhere_Clause;
        List<ResultCoulmnsForType> typeDUIColLst = new List<ResultCoulmnsForType>();
        List<Setting_Item__c> settingItemLst = new List<Setting_Item__c>();
        Map<String,List<ResultCoulmnWithDefault>> typeDUIColLstMap = new Map<String,List<ResultCoulmnWithDefault>>();
        
        selectAndWhere_Clause = 'SELECT Id,Checkbox_1__c,Checkbox_2__c,Text_1__c,Text_2__c,Text_3__c,Text_4__c,Text_5__c,Number_1__c From Setting_Item__c WHERE ';
        
        query = selectAndWhere_Clause + 'Setting__r.Name = \'DynamicSearchResultColumns\'  AND Checkbox_1__c = true order by Text_5__c, Number_1__c LIMIT 5000'; 
        
        system.debug(query);
        if(String.isNotBlank(query)){
            settingItemLst = Database.query(query);
        }
        
        if(settingItemLst != null){
            
            for(Setting_Item__c sItm : settingItemLst){
                ResultCoulmn dUICol = new ResultCoulmn();
                ResultCoulmnWithDefault dUIColDef = new ResultCoulmnWithDefault();
                dUIColDef.showVal = 'False';
                dUICol.label= sItm.Text_1__c;
                dUICol.fieldName= sItm.Text_2__c;
                dUICol.type= sItm.Text_3__c;
                
                if(sItm.Text_3__c == 'currency'){
                    ResulttypeAttributes resAttr = new ResulttypeAttributes();
                    resAttr.currencyCode = sItm.Text_4__c ;
                    
                    ResultcellAttributes resCellAttr = new ResultcellAttributes();
                    resCellAttr.alignment = 'left' ;
                    
                    dUICol.typeAttributes = resAttr ;
                    dUICol.cellAttributes = resCellAttr ;
                }
                
                if(sItm.Checkbox_2__c){
                    dUIColDef.showVal = 'True';
                }
                
                dUIColDef.resCol = dUICol ;
                if(typeDUIColLstMap.get(sItm.Text_5__c) == null){
                    List<ResultCoulmnWithDefault> dUIColLst = new List<ResultCoulmnWithDefault>();
                    dUIColLst.add(dUIColDef);
                    typeDUIColLstMap.put(sItm.Text_5__c,dUIColLst);
                }else{
                    typeDUIColLstMap.get(sItm.Text_5__c).add(dUIColDef);
                }
            }
            
        }else{
            return null;
        }
        if(typeDUIColLstMap.size() > 0){
            for(String typeStr : typeDUIColLstMap.keySet()){
                ResultCoulmnsForType typeDUICol = new ResultCoulmnsForType();
                typeDUICol.type = typeStr;
                typeDUICol.columns = typeDUIColLstMap.get(typeStr);
                typeDUIColLst.add(typeDUICol);
            }
        }else{
            return null;
        }
        
        system.debug('===typeDUIColLst===q'+ JSON.serialize(typeDUIColLst));
        return typeDUIColLst ;
    }
    
 	 @AuraEnabled
    public static Integer checkIfBusinessIdExist(String bundleID, String businessIdToValidate, String calledFrom){
        try{
        String searchAPIEndpoint='';
        String businessId='';
            //saveBusinessIdwithPrefix(bundleID);
            Product2 product = new Product2();
            if(businessIdToValidate!=null && bundleID!=null){
                String Prefix='';
                product = [SELECT Id,businessId__c,Product_category__c FROM Product2 WHERE id = :bundleID limit 1];
                Prefix=product.Product_category__c;
                Prefix=Prefix.toUpperCase(); 
                Prefix=Prefix.substring(0,3)+'-';
                businessId=(Prefix+businessIdToValidate).toUpperCase();
            }else if(calledFrom == 'event' && bundleID!=null){
                product = [SELECT Id,businessid__c, Product_Category__c,Business_Id_Calc__c FROM Product2 WHERE id = :bundleID limit 1];
                businessId = product.Business_Id_Calc__c ;
                if(businessId!=null && businessId.length() > 4  ){
                    businessId=product.Business_Id_Calc__c;
                }
            }
        Map<String, String> headers = new Map<String,String>();
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();    
        searchAPIEndpoint= (String) orgSpecificProps.get('New_Search_API_URL__c');  
        searchAPIEndpoint=searchAPIEndpoint+'/?apiVersion=4.0.1&identifierName=collectionId&identifierValues='+businessId;    
        system.debug('searchAPIEndpoint');    
        headers.put('Content-Type', 'application/json');        
        HttpResponse res = new HttpResponse();        
        res = TF_PlatformExecuter.execute(searchAPIEndpoint,'GET','idtoken', null, headers, false); 
         
        system.debug('##ResBody##' + res.getBody()); 
       
        return res.getStatusCode(); 
        }
        catch(exception ex){
         system.debug(ex.getMessage());
         return 0;
        }
    }   
    
     
    
     @AuraEnabled
    public static boolean saveValidatedBusinessId(String businessId, String bundleID,Boolean IsBusinessIdValidated){
        try{
            Product2 product = new Product2();
            //saveBusinessIdwithPrefix(bundleID);
            product = [SELECT Id,businessId__c FROM Product2 WHERE id = :bundleID limit 1];
            if(IsBusinessIdValidated==true && businessId!=null){
                product.businessId__c = businessId;
            }
            product.IsBusinessIdValidated__c =IsBusinessIdValidated;
            update product;
            return true;
            
        }
        Catch(exception ex){
            system.debug(ex.getMessage());
            return false;
        }
    }
    
    @AuraEnabled
    public static boolean saveBusinessIdwithPrefix(String bundleID){
        try{
            String Prefix='';
            Product2 product = new Product2();
            product = [SELECT Id,businessId__c,Product_category__c FROM Product2 WHERE id = :bundleID limit 1];
            Prefix=product.Product_category__c;
            Prefix=Prefix.toUpperCase(); 
            Prefix=Prefix.substring(0,3)+'-';
            system.debug('Prefix## ' + Prefix);
            //product.businessId__c=Prefix + product.businessId__c;
            //update product;
            return true;
            
        }
        Catch(exception ex){
            system.debug(ex.getMessage());
            return false;
        }
    }
    
    
     @AuraEnabled
    public static String getBusinessIdPrefix(String bundleID){
         try{
            String Prefix='';
            Product2 product = new Product2();
            product = [SELECT Id,businessId__c,Product_category__c FROM Product2 WHERE id = :bundleID limit 1];
            Prefix=product.Product_category__c;
            Prefix=Prefix.toUpperCase(); 
            Prefix=Prefix.substring(0,3)+'-';
            return Prefix;
            }
        Catch(exception ex){
            system.debug(ex.getMessage());
            return null;
        }
    }
    
    
     @AuraEnabled
    public static String getBusinessIdToUpdate(String bundleID){
        try{
            Product2 product = new Product2();
            //saveBusinessIdwithPrefix(bundleID);
            product = [SELECT Id,businessId__c FROM Product2 WHERE id = :bundleID limit 1];
            if(product.businessId__c!=null){
                 return product.businessId__c;
            }
            else{
                return null;
            }
           
            
        }
        Catch(exception ex){
            system.debug(ex.getMessage());
            return null;
        }
    }
    
    @AuraEnabled
    public Static Boolean ValidateBusinessId(String businessId) 
    {
        Boolean result = false;
        String businessIdRegex = '[A-Za-z0-9-]+';
        Pattern businessIdPattern = Pattern.compile(businessIdRegex);
        Matcher businessIdMatcher = businessIdPattern.matcher(businessId);
        if(businessIdMatcher.matches()){
            result = true;
        }
        return result;
    }
  
        @AuraEnabled
    public static ImplicitFilterLst getImplicitFilters(String consumer) {
        
        String query;
        String selectAndWhere_Clause;
        ImplicitFilterLst impLst = new ImplicitFilterLst();
        List<ImplicitFilter> impFilLst = new List<ImplicitFilter>();
        
        List<Setting_Item__c> settingItemLst = new List<Setting_Item__c>();
        selectAndWhere_Clause = 'SELECT Id,Checkbox_1__c,Checkbox_2__c,Text_1__c,Text_2__c,Text_3__c,Text_4__c,Text_5__c,Text_6__c From Setting_Item__c WHERE ';

        if(String.isNotBlank(consumer)){
            query = selectAndWhere_Clause + ' Setting__r.Name = \'ImplicitPCMFilter\' AND M_Picklist_1__c INCLUDES (\''+consumer+'\') AND Checkbox_1__c = true LIMIT 5000'; 
        }
        
        system.debug(query);
        if(String.isNotBlank(query)){
            settingItemLst = Database.query(query);
        }
        
        if(settingItemLst != null){
            for(Setting_Item__c sItm : settingItemLst){
                ImplicitFilter impFltr = new ImplicitFilter();
                impFltr.prdType = sItm.Text_1__c;
                impFltr.dotNotation = sItm.Text_2__c;
                impFltr.qryLabel = sItm.Text_3__c;
                impFltr.operatior = sItm.Text_4__c;
                impFltr.value = sItm.Text_5__c;
                impFltr.useImpVal = sItm.Checkbox_2__c;
                
                impFilLst.add(impFltr);
            }
            impLst.valueLst = impFilLst ;
        }
        return impLst;
    }
    
    
    @AuraEnabled
    public Static ImageUploadNames getvalidImageName(String bundleID)  {
        try{
            List<string> validFileNames=new List<String>();
            Product2 product = new Product2();
            ImageUploadNames Img=new ImageUploadNames();
            product = [SELECT Id,businessId__c, Business_Id_Calc__c  FROM Product2 WHERE id = :bundleID limit 1];
            if(product.businessId__c!=null){
                 Img.banner= product.Business_Id_Calc__c +'_bannerimage';
                 Img.cover= product.Business_Id_Calc__c +'_coverimage';
                 return Img;
            }
            else{
                return null;
            }
           
            
        }
        Catch(exception ex){
            system.debug(ex.getMessage());
            return null;
        }
    }
    
   /*  @AuraEnabled
    public Static Boolean getUploadedImage(String bundleID, String validImageName)  {
        try{
            List<string> validFileNames=new List<String>();
            ContentVersion CV = new ContentVersion();
            ImageUploadNames Img=new ImageUploadNames();
            CV = [SELECT Id,ContentDocumentId,ContentSize,FileType,FirstPublishLocationId,IsDeleted,PathOnClient FROM ContentVersion WHERE FirstPublishLocationId  = :bundleID and PathOnClient=:validImageName];
            if(CV.PathOnClient!=null && CV.PathOnClient==validImageName){
              return true;
            }
            else{
                return false;
            }
          }
        Catch(exception ex){
            system.debug(ex.getMessage());
            return false;
        }
    }*/
    
    
   /* @AuraEnabled
    public Static Boolean deleteUploadedImage(String bundleID, String validImageName)  {
        try{
            List<string> validFileNames=new List<String>();
            ContentVersion CV = new ContentVersion();
            ContentDocument CD = new ContentDocument();
            ImageUploadNames Img=new ImageUploadNames();
            CV = [SELECT Id,ContentDocumentId,ContentSize,FileType,FirstPublishLocationId,IsDeleted,PathOnClient FROM ContentVersion WHERE FirstPublishLocationId  = :bundleID and PathOnClient=:validImageName];
            if(CV.PathOnClient!=null && CV.PathOnClient==validImageName){
               CD = [SELECT Id,ContentSize,FileType FROM ContentDocument WHERE id  =: CV.ContentDocumentId];
                delete CD;
                return true;
            }
            else{
                return false;
            }
          }
        Catch(exception ex){
            system.debug(ex.getMessage());
            return false;
        }
    }*/
    
   /* @AuraEnabled
    public static string saveFileForCollection(Id bundleID, String strFileName, String base64Data, String contentType) {
        // Decoding base64Data
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');        
        // inserting file
        ContentVersion cv = new ContentVersion();
        //cv.ContentLocation = 'S';
        cv.Title = strFileName;
        cv.PathOnClient = '/' + strFileName;
        cv.FirstPublishLocationId = bundleid;
        cv.VersionData = EncodingUtil.base64Decode(base64Data);
        cv.IsMajorVersion = true;
        List<ContentVersion> cvList=new List<ContentVersion>();
        cvList.add(cv);
        Database.SaveResult[] srList = Database.insert(cvList, false);
        
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                return 'Success';
            }
            else {
                return 'Failed';
            }
        }
        return null;
    }  */
    
    @AuraEnabled
    public static Id uploadFile(String bundleID,String fileName, String base64Data, String contentType) {
        try{        
            base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');              
            ContentVersion cv = createContentVersion(base64Data, filename,bundleID);
            ContentDocumentLink cdl = createContentDocumentLink(cv.Id, bundleID);
            if (cv == null || cdl==null) { return null; }
            system.debug('ContentDocumentLink: ' + cdl.Id);
            return cdl.Id;   
            }         
         catch(Exception exc) {
            System.debug('Error: ' + exc.getStackTraceString() + ' ' + exc.getMessage());
             throw new AuraHandledException('ISSUE_UPLOADING_FILE');
        }   
    }
    
    @AuraEnabled
    public static Id uploadImageFile(String bundleID,String fileName, String base64Data, String contentType) {
        try{        
            //base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');              
            ContentVersion cv = createContentVersion(base64Data, filename,bundleID);
            ContentDocumentLink cdl = createContentDocumentLink(cv.Id, bundleID);
            if (cv == null || cdl==null) { return null; }
            return cdl.Id;   
            }         
         catch(Exception exc) {
            System.debug('Error: ' + exc.getStackTraceString() + ' ' + exc.getMessage());
             throw new AuraHandledException('ISSUE_UPLOADING_FILE');
        }   
    }
    
    private static ContentVersion createContentVersion(String base64, String filename, String bundleID) {
        ContentVersion cv = new ContentVersion();
        cv.VersionData = EncodingUtil.base64Decode(base64);
        cv.Title = filename;
        //cv.ContentLocation = 'S';
        cv.PathOnClient = filename;
        //cv.FirstPublishLocationId=bundleID;
          insert cv;
          return cv;
      }
  
    private static ContentDocumentLink createContentDocumentLink(String contentVersionId, String recordId) {
           if (contentVersionId == null || recordId == null) { return null; }
              
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = [
              SELECT ContentDocumentId 
              FROM ContentVersion 
              WHERE Id =: contentVersionId
            ].ContentDocumentId;
    
            cdl.LinkedEntityId = recordId;
            cdl.ShareType = 'V';
            cdl.Visibility = 'InternalUsers';
              insert cdl;
              return cdl;
          }    
    
    @AuraEnabled  
    public static List<ContentDocument> getFiles(String recordId){ 
        Set<Id> recordIds = new Set<Id>{recordId};
        List<ContentDocumentLink> cdlList = [SELECT Id, LinkedEntityId, ContentDocumentId FROM 
                                             ContentDocumentLink WHERE LinkedEntityId IN :recordIds
                                            ];                         
        Set<Id> documentIds = new Set<Id>(); 
        for(ContentDocumentLink cdl:cdlList){  
            documentIds.add(cdl.ContentDocumentId);  
        }    
        return [SELECT Id, Title, FileType FROM ContentDocument WHERE Id IN :documentIds];        
    } 
    
    @AuraEnabled  
    public static void deleteFile(String contentDocumentId){ 
        delete [SELECT Id from ContentDocument WHERE Id = :contentDocumentId];       
    } 
     
    @AuraEnabled  
    public static boolean deleteFileWithTitle(String recordId, String title){ 
       /* try{
            delete [SELECT Id from ContentDocument WHERE title = :title];  
            return true;
        }catch(Exception ex){
            system.debug(ex.getMessage());
            return false;
        }*/
        
        
        
         List<ContentDocumentLink> cdlList = [SELECT ContentDocumentId,ContentDocument.title  FROM ContentDocumentLink WHERE LinkedEntityId =: recordId];
        String titlewithoutExt=title.substringBefore('.');
        boolean flag=false;
        ContentDocument delCD=new ContentDocument();
        if(cdlList.size()>0){
            for(ContentDocumentLink CD :cdlList){
                system.debug('titlewithoutExt' + titlewithoutExt);
                system.debug(CD.ContentDocument.title.substringBefore('.'));
                if(titlewithoutExt==CD.ContentDocument.title.substringBefore('.')){
                    system.debug('name matched');
                     delCD.id=CD.ContentDocumentId;
                    flag= true;
                    break;
                }
            }
            
            if(flag==true){
                delete [SELECT Id from ContentDocument WHERE id = :delCD.id]; 
                return true;
            }else if(flag==false){
                return false;
            }
            else{
                return false;
            }
           
        }else{
            return false;
        }
        
    }  
    
    @AuraEnabled
    public static List<ContentDocumentLink> fetchFiles(String linkedRecId){	
        List<ContentDocumentLink> cdlList = [SELECT ContentDocumentId,ContentDocument.title  FROM ContentDocumentLink WHERE LinkedEntityId =: linkedRecId];
        return cdlList;
    } 
    
    @AuraEnabled
    public static boolean fetchFilesWithTitle(String linkedRecId, String title){	
        List<ContentDocumentLink> cdlList = [SELECT ContentDocumentId,ContentDocument.title  FROM ContentDocumentLink WHERE LinkedEntityId =: linkedRecId];
        String titlewithoutExt=title.substringBefore('.');
        boolean flag=false;
        if(cdlList.size()>0){
            for(ContentDocumentLink CD :cdlList){
                if(titlewithoutExt==CD.ContentDocument.title.substringBefore('.')){
                    flag= true;
                }
            }
            if(flag==true){
                return true;
            }else if(flag==false){
                return false;
            }
            else{
                return false;
            }
           
        }else{
            return false;
        }
        
        
    } 
    
  //  @Future(callout=true)
    public static void submitCollectionImageonS3(String bundleId) {
        try{
            system.debug('submitCollectionImageonS3 entered');
            List<string> ids=new List<string>();
            List<ContentDocumentLink> cdlList = [SELECT ContentDocumentId,ContentDocument.title  FROM ContentDocumentLink WHERE LinkedEntityId =: bundleId];
            if(cdlList!=null){
                for (ContentDocumentLink cdl : cdlList) {
                    ids.add(cdl.ContentDocumentId);
                }
            }
            TF_PPDImageUploadToS3 imgUpload=new TF_PPDImageUploadToS3();
            imgUpload.UploadDocuments(ids,bundleId);  
        }catch(exception ex){
            system.debug(ex.getMessage());
        }
     }
    
      @AuraEnabled
      public static processedQuery downloadSearchResultFromPCM(String bundleId, String queryObj, String savedRule, Integer offsetValue, Integer limitValue,String searchCurrency, String getAll, String productType, String consumer) {
        try{
            string downloadSearchResultAPIEndpoint='';
            String jsonStr='';
            String status='';
            Map<String, String> headers = new Map<String,String>(); 
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            downloadSearchResultAPIEndpoint= (String) orgSpecificProps.get('New_Search_API_URL__c');        
            headers.put('Content-Type', 'application/json');
            HttpResponse resSearch = new HttpResponse();
            //multityperulelist
             System.debug('queryObjInsidegetPrdsFromPCM_DynamicUI' + queryObj);
        List<TF_PPDProcessController.RuleElement> ruleElementLst = new List<TF_PPDProcessController.RuleElement>();
        List<TF_PPDProcessController.MultiTypeRules> multiTypeRulesLst = new List<TF_PPDProcessController.MultiTypeRules>();
        TF_PPDProcessController.MultiTypeRules multiTypeRules = new TF_PPDProcessController.MultiTypeRules();
        processedQuery queryStrAndObj = new processedQuery();
        
        if(savedRule == 'true'){
            querySaveElement savedQry = new querySaveElement();
            Filter filters = new Filter();
            savedQry = parseRuleJson(bundleId);
            if(savedQry != null && (savedQry.ruleElementLst != null || savedQry.multiTypeRulesLst != null)){
                if(savedQry.isDynamicUi == 'true'){                    
                    multiTypeRulesLst = savedQry.multiTypeRulesLst ;
                    if(productType == '' || productType == null){
                        productType = multiTypeRulesLst[0].productType ;
                    }
                }else{
                    ruleElementLst = savedQry.ruleElementLst ;
                    if(productType == '' || productType == null){
                        filters = savedQry.filterObject;
                        productType = filters.mediumData ;
                        
                    }
                    system.debug('ruleElementLst====='+ruleElementLst);
                    multiTypeRules.ruleElementLst = ruleElementLst ;
                    productType = productType == 'e-Book' ? 'book' : productType;
                    multiTypeRules.productType = productType;
                    multiTypeRulesLst.add(multiTypeRules);
                }
            }else{
                List <PagedResult> pr = new List <PagedResult>();
                queryStrAndObj.total = 0;
                queryStrAndObj.prList = pr;
                queryStrAndObj.msg = 'Products not found';
                return queryStrAndObj;  
            }
        }else{
            multiTypeRulesLst = processQueryObj_Dynamic(queryObj);  
            system.debug('multiTypeRulesLst##'+multiTypeRulesLst);
        }
            jsonStr=TF_GenerateJson.GenerateDownloadSearchJson(bundleId, productType, multiTypeRulesLst, offsetValue, limitValue, consumer);
            resSearch = TF_PlatformExecuter.execute(downloadSearchResultAPIEndpoint,'POST','idtoken', jsonStr, headers, false);

             if (resSearch.getStatusCode() == 202) {  
                 status='Success';
                 queryStrAndObj.msg=status;
                 system.debug('status code' + resSearch.getStatusCode());
             }
            else{
                status='Failure';
                queryStrAndObj.msg=status;
                system.debug('status code' + resSearch.getStatusCode());
            }
           return queryStrAndObj;
            
        }catch(exception ex){
            system.debug(ex.getMessage());
            return null; 
        }
     }
    
    
    @AuraEnabled
    public static List<ListView> getListViews() {
        List<ListView> listviews = [SELECT Id, Name FROM ListView WHERE SobjectType = 'Product2' and Name='Recently Viewed'];
        return listviews;
    } 
    
    @Future(callout=true)
    public static void submitSKU(String bundleId) {
        updateSKU(bundleId);
    }
    
     //@Future(callout=true)
    public static void updateSKU(String bundleId) {
        String status='';
		Map<String, String> headers = new Map<String,String>(); 
        headers.put('Content-Type', 'application/json');
        
        Product2 product = [SELECT Hub_Id__c FROM Product2 WHERE id = :bundleId];
        String hubId = product.Hub_Id__c;
        
        String searchAPIEndpoint;
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();    
        searchAPIEndpoint= (String) orgSpecificProps.get('New_Search_API_URL__c');  
        searchAPIEndpoint=searchAPIEndpoint+'/'+hubId; 
                
        String jsonStr ;
		jsonStr = TF_GenerateJson.GenerateSkuUpdateJson(bundleId);
		system.debug('======updateSKUjsonStr====='+jsonStr);
        
        HttpResponse res = new HttpResponse();
        res = TF_PlatformExecuter.execute(searchAPIEndpoint,'PATCH','idtoken', jsonStr, headers, false);
		system.debug('=======updateSKUres body====='+res.getBody());
        system.debug('##ResBody##' + res.getBody()); 
        processedQuery queryStrAndObj = new processedQuery();
        
        if (res.getStatusCode() == 202) {  
                 status='Success';
                 queryStrAndObj.msg=status;
                 system.debug('status code' + res.getStatusCode());
             }
            else{
                status='Failure';
                queryStrAndObj.msg=status;
                system.debug('status code' + res.getStatusCode());
            }            
        
    }
     
    @AuraEnabled
    public static String downloadeBookCatalogue(){
        Map<String, String> headers = new Map<String,String>(); 
        String downloadEndpoint = '';
        String hubId = '';
        String resBody ;
        
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        downloadEndpoint = (String) orgSpecificProps.get('New_Search_API_URL__c');
        
        downloadEndpoint = downloadEndpoint +'/report?type=salessheets&apiVersion=4.0.1';
        headers.put('Content-Type', 'application/json');
        
        HttpResponse res = new HttpResponse();
        
        res = TF_PlatformExecuter.execute(downloadEndpoint,'GET','idtoken', null, headers, false);
        
        system.debug('DownloadStatusCode: ' + res.getStatusCode());
        if (res.getStatusCode() == 201 || res.getStatusCode() == 200) { 
            resBody=res.getbody();
            resBody=resBody.replace('"type":', '"type_Z":');
            system.debug('DownloadResBody: ' + resBody);
           	            
            PartsDownload data = (PartsDownload)JSON.deserialize(resBody, PartsDownload.class);
            String locationName = data.location;
            system.debug('location for s3 file' + locationName);
            return locationName ;
            
        }else if(res.getStatusCode() == 404){
            return 'File not found' ;
        }else{
            return 'Error';
        }
    }
    
    @Future(callout=true)
    public static void GetS3FileUsingFileId(string recordId)
    {   
        List<String> ImageResponse=new List<String>();
        TF_PPDImageUploadToS3 ImageUpload=new TF_PPDImageUploadToS3();
        ImageResponse=ImageUpload.DownloadDocuments(recordId);
        
        //system.debug('datadatadata###'+data);
        //return data; 
    }  
   
   //start changes by Geetika for PCH-3787
	@AuraEnabled
    public static String getCollectionTitle(String bundleId){
        String productName;
        try{
            Product2 product=[SELECT Name,id FROM Product2 WHERE id = :bundleID]; 
            productName = product.Name;
            system.debug('collectionName: ' + productName);
            return productName;
        }catch(exception ex){        
            system.debug(ex.getMessage());
            productName= 'Error';
            return productName;
        }
        
    }  
    
    @AuraEnabled
    public static Integer checkCollectionNameExist(String bundleId,String collectionName, String calledFrom){
        try{
            String collectionTitle='';
            String searchAPIEndpoint='';
            system.debug('collectionName123: ' + bundleId + '  **  ' + calledFrom + '  ** ' + collectionName);
            if(calledFrom == 'event' && bundleId!=null){
                Product2 product=[SELECT Name FROM Product2 WHERE id =:bundleId]; 
            	collectionTitle = product.Name;
            
            }else if(calledFrom == 'ui' && bundleId!=null){
                collectionTitle = collectionName;
            }
            collectionTitle = EncodingUtil.urlEncode(collectionTitle, 'UTF-8').replace('+', '%20');
            system.debug('collectionName: ' + collectionTitle );
            Map<String, String> headers = new Map<String,String>();
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();    
            searchAPIEndpoint= (String) orgSpecificProps.get('New_Search_API_URL__c');  
            searchAPIEndpoint=searchAPIEndpoint+'/?apiVersion=4.0.1&identifierName=title&identifierValues='+collectionTitle+ '&type=collection&responseGroup=small';    
            system.debug('searchAPIEndpointCollection: ' + searchAPIEndpoint);    
            headers.put('Content-Type', 'application/json');        
            HttpResponse res = new HttpResponse();        
            
            res = TF_PlatformExecuter.execute(searchAPIEndpoint,'GET','idtoken', null, headers, false); 
             
            system.debug('##ResBody##' + res.getBody()); 
       
        	return res.getStatusCode(); 
        }catch(exception ex){
            system.debug(ex.getMessage());
         	return 0;
        }
    }
   
    @AuraEnabled
    public static boolean saveValidatedTitle(String title, String bundleID,Boolean isTitleValid){
        try{
            Product2 product = new Product2();
            product = [SELECT Id,Name FROM Product2 WHERE id = :bundleID limit 1];
            if(isTitleValid==true && title!=null){
                product.Name = title;
            }
            product.IsTitleValidated__c =isTitleValid;
            update product;
            return true;
            
        }
        Catch(exception ex){
            system.debug(ex.getMessage());
            return false;
        }
    }
    
    @AuraEnabled
    public static String getNameToUpdate(String bundleID){
        try{
            Product2 product = new Product2();
            product = [SELECT Id,Name FROM Product2 WHERE id = :bundleID limit 1];
            if(product.Name!=null){
                 return product.Name;
            }
            else{
                return null;
            }
            
        }
        Catch(exception ex){
            system.debug(ex.getMessage());
            return null;
        }
    }
   @AuraEnabled
    public static String checkIfValidCollectionNameExist(String bundleID) {
        try{        
            Product2 prd = new Product2();
            prd = [SELECT Id,IsTitleValidated__c  FROM Product2 WHERE id = :bundleID limit 1];
            
            if(prd.IsTitleValidated__c ==true ){
                Return 'True';
            }
            else if(prd.IsTitleValidated__c ==false ){
                Return 'False';
            }
            else{
                Return 'False';
            }
        }
        Catch(Exception ex) {       
            system.debug(ex.getMessage());
            return 'False';
        }
    } //end changes for PCH-3787
    
    
    //start changes by Geetika for PCH-3886
    public static void isBundleItemsFree(String bundleId) {
        try{
            Product2 product = [SELECT id,Is_collection_free__c FROM Product2 WHERE id = :bundleID];
            
            List<Bundle_Line_Item__c> lineItms = [SELECT id,Open_access__c FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :product.id];
            Boolean isCollectionFree = product.Is_collection_free__c;
            if(isCollectionFree){
                for(Bundle_Line_Item__c b: lineItms){
                    b.Open_access__c = true;
                }  
            } else {
                for(Bundle_Line_Item__c b: lineItms){
                    b.Open_access__c = false;
                }  
            }
            update(lineItms);
        }catch(Exception e){
            system.debug(e.getMessage());
        }
    } //end changes for PCH-3886
    
    
}