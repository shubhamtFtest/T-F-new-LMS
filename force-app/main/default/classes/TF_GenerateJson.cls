//Test Class=ztest_TF_GenerateJson
global with sharing class TF_GenerateJson {
    
    public class ValidationJson {        
        @AuraEnabled
        public String jsonString { get;set; } 
        @AuraEnabled
        public Integer processedRecs { get;set; } 
        
        @AuraEnabled
        public Integer position { get;set; }
        @AuraEnabled
        public Integer totalRecs { get;set; }
        @AuraEnabled
        public String moreRecsToProcess { get;set; }
    }
    
    public class Keywords {        
        public String name { get;set; }
        public String description { get;set; }
        public Integer position { get;set; }           
    } 
    
    public class Contributors {        
        public String name { get;set; }
        public String givenName { get;set; }
        public String familyName { get;set; }
        public String role { get;set; }
        public Integer position { get;set; }           
    }
    
    public class DotNotation {        
        public String title { get;set; }
        public String type { get;set; }
        public String Author { get;set; }
        public String publicationDate { get;set; }
        public String Publisher { get;set; }
        public String Format { get;set; }     
        public String ListPrice { get;set; }
        public String currency_X { get;set; }
        public String Code { get;set; } 
        public String Role { get;set; }
        public String subType { get;set; }
        
    }
    
    public class AvailabilityDetails {        
        
        public Map<String,Map<String,List<Setting_Item__c>>> availabilityTypeMap { get;set; }
        public Map<String,List<Setting_Item__c>> settingItemLstMap { get;set; }
    }
    
    public class ruleObj{
        public rule rule{get;set;}
        public String type{get;set;}
    }
    
    public class rule{
        public String value{get;set;}
    }
    
    public class ruleObjVals{
        public ruleVals rule{get;set;}
        public String type{get;set;}
    }
    
    public class ruleVals{
        public list<String> values{get;set;}
        public String relationship{get;set;}
        public String attribute{get;set;}
    }
    
    public class ruleObjVal{
        public ruleVal rule{get;set;}
        public String type{get;set;}
    }
    
    public class ruleVal{
        public String value{get;set;}
        public String relationship{get;set;}
        public String attribute{get;set;}
    }
    
    @AuraEnabled
    public static String GenerateS3Json(String bundleId, list< Bundle_Line_Item__c> listofLineItems) { 
        String str;
        List<Product2> prdList =new List<Product2>();
        Product2 originalPrdList =new Product2();
        Product2 prd =new Product2();
        Map<String,String> typeMap = new Map<String,String>();
        typeMap.put('CHAPTER','Chapter');
        typeMap.put('SCHOLARLYARTICLE','ScholarlyArticle');
        typeMap.put('CREATIVEWORK','CreativeWork');
        typeMap.put('BOOK','Book');
        typeMap.put('COLLECTION','Collection');
        
        /*  prdList =[SELECT Hub_Id__c, name,alternateName__c,Product_Type_Author_Facing__c,inLanguage__c,version__c,doi__c,ean__c,issn__c,id,Description,Product_Publisher__c,
CreatedDate,LastModifiedDate,copyrightyear__c,Lead_Author_Editor__c,Category__c,Keywords__c, Contributors__c
FROM Product2 where id=:bundleId and Product_Type_Author_Facing__c='UNSDG'                     
];*/
        
        prdList =[SELECT Hub_Id__c, name,alternateName__c,Product_Type_Author_Facing__c,inLanguage__c,version__c,doi__c,ean__c,issn__c,id,Description,Product_Publisher__c,
                  CreatedDate,LastModifiedDate,copyrightyear__c,Lead_Author_Editor__c,Category__c,Keywords__c, Contributors__c,Sales_Channels__c,
                  Applicable_Channels__c,Applicable_License_Types__c,Applicable_Customer_Types__c,originalProductId__c
                  FROM Product2 where id=:bundleId                      
                 ];
        
        
        if(!prdList.isEmpty()){
            prd = prdList[0];
        }
        
        if(prd.originalProductId__c!=NULL){
            originalPrdList=[SELECT Hub_Id__c, name, CreatedDate,LastModifiedDate from product2 where id=:prd.originalProductId__c];
        }
        
        // list< Bundle_Line_Item__c> listofLineItems = [SELECT id,name,Title__c,Content_ID__c FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c =:bundleId and IsUnsilo__c=true ORDER BY Content_Position__c limit 10000];
        // list< Bundle_Line_Item__c> listofLineItems = new list< Bundle_Line_Item__c>();
        if(listofLineItems == null || (listofLineItems != null && listofLineItems.isEmpty())){
            listofLineItems = new list< Bundle_Line_Item__c>();
            for(List<Bundle_Line_Item__c> lineItems : Database.Query('SELECT id,name,Title__c,Content_ID__c,uuid__c, Open_access__c, Type__c, Source__c,mediaType__c FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c =:bundleId and uuid__c != null ORDER BY Content_Position__c limit 50000')){
                listofLineItems.addAll(lineItems);
            }
        }
        List<Pricebookentry> lstpbe = getPriceBookEntry(bundleId);
        
        JSONGenerator gen = JSON.createGenerator(true);
        String Category=prd.Category__c;
        String keywords=prd.Keywords__c;
        
        List<String> listCategory = new List<String>();
        if(String.isNotBlank(Category)){
            listCategory = Category.split(',');
        }        
        
        //List<String> listkeywords = keywords.split(',');    
        
        gen.writeStartObject();
        gen.writeStringField('@id',prd.Hub_Id__c==null ? '': prd.Hub_Id__c);    
        gen.writeStringField('@type','Collection'); 
        gen.writeStringField('@additionalType','UNSDG');
        gen.writeStringField('name',prd.name==null ? '' : prd.name);
        gen.writeStringField('alternateName',prd.alternateName__c==null ? '' : prd.alternateName__c);
        gen.writeStringField('inLanguage',prd.inLanguage__c==null ? '' : prd.inLanguage__c);
        gen.writeStringField('version',prd.version__c==null ? '' : prd.version__c);
        gen.writeStringField('doi',prd.doi__c==null ? '' : prd.doi__c);
        gen.writeStringField('ean',prd.ean__c == null ? '' : prd.ean__c);
        gen.writeStringField('issn',prd.issn__c==null ? '' : prd.issn__c);
        gen.writeStringField('sku',prd.id==null ? '' : prd.id);
        gen.writeStringField('productID',prd.id==null ? '' : prd.id);
        gen.writeStringField('description',prd.description==null ? '' : prd.description);
        gen.writeStringField('publisher',prd.Product_Publisher__c==null ? '' : prd.Product_Publisher__c);
        if(prd.version__c!=NULL && prd.version__c=='1.0.0'&& prd.originalProductId__c==NULL){
            gen.writeDateTimeField('dateCreated',prd.CreatedDate);
            gen.writeDateTimeField('dateModified',prd.LastModifiedDate);
        }
        else if(prd.version__c!=NULL && prd.version__c!='1.0.0' && prd.originalProductId__c!=NULL){
            gen.writeDateTimeField('dateCreated',originalPrdList.CreatedDate);
            gen.writeDateTimeField('dateModified',prd.LastModifiedDate);
        }
        //gen.writeDateTimeField('dateCreated',prd.CreatedDate);
        //gen.writeDateTimeField('dateModified',prd.LastModifiedDate);
        gen.writeStringField('copyrightYear',prd.copyrightyear__c==null ? '' : prd.copyrightyear__c);
        gen.writeFieldName('copyrightHolder');
        gen.writeStartObject();
        gen.writeFieldName('name'); 
        gen.writeString(prd.Lead_Author_Editor__c==null ? '' : prd.Lead_Author_Editor__c);
        gen.writeEndObject();
        //gen.writeEndObject(); 
        //writting identifier
        gen.writeFieldName('identifier');
        gen.writeStartArray();
        gen.writeStartObject();
        gen.writeFieldName('code'); 
        gen.writeString('');
        gen.writeEndObject(); 
        gen.writeEndArray();
        //writting Categoy part
        
        gen.writeFieldName('category');
        
        gen.writeStartArray();
        for (String strCategory : listCategory) {            
            gen.writeStartObject();
            gen.writeFieldName('subject'); 
            gen.writeString(strCategory);
            gen.writeEndObject();            
        }
        gen.writeEndArray();
        
        //writting keywords part
        gen.writeFieldName('keywords');
        
        if(String.isNotBlank(prd.Keywords__c)){
            gen.writeObject(JSON.deserializeUntyped(prd.Keywords__c));
        }else{
            gen.writeStartArray();
            gen.writeEndArray();
        }
        
        /*gen.writeStartArray();
for (String strkeywords : listkeywords) {

gen.writeStartObject();
gen.writeFieldName('name'); 
gen.writeString(strkeywords);
gen.writeEndObject();

}
gen.writeEndArray();*/
        //writting offers section
        gen.writeFieldName('contributor');
        if(String.isNotBlank(prd.Contributors__c)){
            gen.writeObject(JSON.deserializeUntyped(prd.Contributors__c));
        }else{
            gen.writeStartArray();
            gen.writeEndArray();
        }
        /* gen.writeStartArray();
gen.writeStartObject();
gen.writeFieldName('name'); 
gen.writeString('');
gen.writeFieldName('givenname'); 
gen.writeString('');
gen.writeFieldName('familyname'); 
gen.writeString('');
gen.writeFieldName('role'); 
gen.writeString('');
gen.writeFieldName('position'); 
gen.writeNumber(0);
gen.writeEndObject();

gen.writeEndArray();   */
        //writting offers section
        gen.writeFieldName('offers');
        gen.writeStartArray();
        
        for (PricebookEntry pbe : lstPbe) {
            
            gen.writeStartObject();
            gen.writeDateTimeField('validFrom',pbe.CreatedDate);
            gen.writeFieldName('priceCurrency'); 
            gen.writeString(pbe.CurrencyIsoCode==null ? '' : pbe.CurrencyIsoCode);           
            gen.writeFieldName('price'); 
            //gen.writeNumber(pbe.UnitPrice==null ? 0.00  : pbe.UnitPrice);
            gen.writeString(String.valueOf(pbe.UnitPrice)==null ? '0.00'  : String.valueOf(pbe.UnitPrice));
            gen.writeEndObject();
            
        }
        gen.writeEndArray();
        
        //writting hasparts part
        gen.writeFieldName('hasPart');
        gen.writeStartArray();
        Integer intPosition=1;
        for (Bundle_Line_Item__c bundlehaspart : listofLineItems) {           
            
            gen.writeStartObject();
            gen.writeFieldName('@id'); 
            gen.writeString(bundlehaspart.uuid__c==null ? '' : bundlehaspart.uuid__c);
            gen.writeFieldName('@type'); 
            gen.writeString(bundlehaspart.Type__c==null ? 'Chapter' : typeMap.get(bundlehaspart.Type__c.toUpperCase()) != null ? typeMap.get(bundlehaspart.Type__c.toUpperCase()) : 'Chapter');
            gen.writeFieldName('isAccessibleForFree'); 
            gen.writeBoolean(bundlehaspart.Open_access__c);
            gen.writeFieldName('position'); 
            gen.writeNumber(intPosition);
            gen.writeFieldName('curationSource'); 
            gen.writeString(bundlehaspart.Source__c==null ? '' : bundlehaspart.Source__c);
            if(bundlehaspart.Type__c!=NULL && bundlehaspart.Type__c.equalsIgnoreCase('creativeWork')){               
                gen.writeFieldName('mediaType');  
                gen.writeString(bundlehaspart.mediaType__c==null ? '' : bundlehaspart.mediaType__c);
            }
            gen.writeEndObject();  
            intPosition++;
        }
        gen.writeEndArray();
        
        //Writing Configuration
        gen.writeFieldName('configurations');
        gen.writeStartArray();
        //factors
        gen.writeStartObject();
        gen.writeFieldName('factors');
        gen.writeStartArray();
        //Saleschannel
        gen.writeStartObject();
        
        gen.writeFieldName('name'); 
        gen.writeString('SalesChannels');
        
        gen.writeFieldName('values');
        gen.writeStartArray();
        if(String.isNotBlank(prd.Sales_Channels__c)){
            List<String> lstSalesChannels = prd.Sales_Channels__c.split(';');
            If( lstSalesChannels.contains('All')){
                lstSalesChannels.clear();
                lstSalesChannels.add('All');
            }
            for (String strSalesChannel : lstSalesChannels) {           
                
                gen.writeStartObject();
                gen.writeFieldName('value'); 
                gen.writeString(strSalesChannel);    
                gen.writeEndObject();       
            }
        }
        
        gen.writeEndArray();
        
        gen.writeEndObject();
        //End Saleschannel
        //delivery channel
        gen.writeStartObject();
        
        gen.writeFieldName('name'); 
        gen.writeString('deliveryChannels');
        
        gen.writeFieldName('values');
        gen.writeStartArray();
        if(String.isNotBlank(prd.Applicable_Channels__c)){
            List<String> lstdeliveryChannels = prd.Applicable_Channels__c.split(';');
            If( lstdeliveryChannels.contains('All')){
                lstdeliveryChannels.clear();
                lstdeliveryChannels.add('All');
            }
            for (String strdeliveryChannel : lstdeliveryChannels) {           
                
                gen.writeStartObject();
                gen.writeFieldName('value'); 
                gen.writeString(strdeliveryChannel);    
                gen.writeEndObject();       
            }
        }
        
        gen.writeEndArray();
        
        gen.writeEndObject();
        //End Delivery channel
        
        //BusinessModel channel
        gen.writeStartObject();
        
        gen.writeFieldName('name'); 
        gen.writeString('businessModels');
        
        gen.writeFieldName('values');
        gen.writeStartArray();
        if(String.isNotBlank(prd.Applicable_License_Types__c)){
            List<String> lstbusinessModels = prd.Applicable_License_Types__c.split(';');
            If( lstbusinessModels.contains('All')){
                lstbusinessModels.clear();
                lstbusinessModels.add('All');
            }
            for (String strbusinessModel : lstbusinessModels) {           
                
                gen.writeStartObject();
                gen.writeFieldName('value'); 
                gen.writeString(strbusinessModel);    
                gen.writeEndObject();       
            }
        }
        
        gen.writeEndArray();
        
        gen.writeEndObject();
        //End BusinessModel channel
        //customerTypes channel
        gen.writeStartObject();
        
        gen.writeFieldName('name'); 
        gen.writeString('customerTypes');
        
        gen.writeFieldName('values');
        gen.writeStartArray();
        if(String.isNotBlank(prd.Applicable_Customer_Types__c)){
            List<String> lstcustomerTypes = prd.Applicable_Customer_Types__c.split(';');
            If( lstcustomerTypes.contains('All')){
                lstcustomerTypes.clear();
                lstcustomerTypes.add('All');
            }
            for (String strcustomerType : lstcustomerTypes) {           
                
                gen.writeStartObject();
                gen.writeFieldName('value'); 
                gen.writeString(strcustomerType);    
                gen.writeEndObject();       
            }
        }
        
        gen.writeEndArray();
        
        gen.writeEndObject();
        //End customerTypes channel
        gen.writeEndArray();
        gen.writeEndObject();
        
        //factors
        
        gen.writeEndArray();
        //End of Writing configuration
        
        
        gen.writeEndObject();
        
        String jsonString = gen.getAsString();
        System.debug('jsonS3String:'+jsonString);
        Return jsonString;
    }   
    
    
    
 
    
    @AuraEnabled
    public static String GenerateSNSJson(String bundleId, String s3Location) { 
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        String topicArn = (String) orgSpecificProps.get('AWS_SNS_TopicArn__c');
        String str;
        String strUUID=generateUUID();
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();        
        gen.writeFieldName('header');
        
        gen.writeStartObject();
        gen.writeStringField('id',strUUID);    
        gen.writeStringField('source','Salesforce'); 
        gen.writeStringField('application','Rest'); 
        gen.writeStringField('timestamp',String.valueOf(Datetime.now())); 
        //gen.writeStringField('topic',topicArn); 
        gen.writeStringField('topic',topicArn==null ? '' : topicArn);
        gen.writeStringField('type','application/json');
        gen.writeEndObject();
        
        gen.writeFieldName('body');
        gen.writeStartObject();
        //
        gen.writeFieldName('identifiers');
        gen.writeStartObject();
        gen.writeStringField('@id',bundleId==null ? '' : bundleId); 
        gen.writeEndObject();
        
        gen.writeFieldName('payload');
        gen.writeStartObject();
        gen.writeStringField('location',s3Location==null ? '' : s3Location);    
        gen.writeStringField('type','application/json '); 
        gen.writeEndObject();
        
        
        gen.writeEndObject();
        gen.writeEndObject();
        
        
        
        
        String jsonString = gen.getAsString();
        System.debug('jsonCommonModelString:'+jsonString);
        Return jsonString;
    }
    
     
    @AuraEnabled 
    public static ValidationJson GenerateValidationJson(String bundleId, DateTime now, Integer position, Integer processedRecCount, Integer totalRecs, List<bundle_line_item__c> lineItemList) { 
        String str;
        String excludeTypeforvalidation='CMS';
        ValidationJson vJson = new ValidationJson();
        Integer pstn = position;
        Integer totalRecords = totalRecs ;
        Integer recsProcessed = processedRecCount ;
        
        if(position == 0){
            list< Bundle_Line_Item__c> lItemList = new list< Bundle_Line_Item__c>();
            
            lItemList = [select  Content_Position__c from bundle_line_item__c where Product_Bundle_Parent__c = :bundleId ORDER BY Content_Position__c LIMIT 1] ;
            if(lItemList.size() > 0){
                vJson.position =  Integer.valueOf(lItemList[0].Content_Position__c) -1 ;
            }
            
            pstn = vJson.position ;
        }
        
        if(totalRecs == 0){
            //totalRecords = [SELECT count() FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c =:bundleId and IsUnsilo__c=true and uuid__c = null and doi__c != null] ;
            //totalRecords = [SELECT count() FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c =:bundleId and uuid__c = null and doi__c != null] ;
            totalRecords = [SELECT count() FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c =:bundleId and Type__c!= 'CMS' and doi__c != null] ;
            vJson.totalRecs = totalRecords ;
        }
        
        list< Bundle_Line_Item__c> listofLineItems = new list< Bundle_Line_Item__c>();
        if(lineItemList == null || (lineItemList != null && lineItemList.size() == 0)){
            /*for(List<Bundle_Line_Item__c> lineItems : Database.Query('SELECT id, Product_Bundle_Parent__c, doi__c, Content_ID__c, Journal__c,Publication_Date__c, Title__c, Authors__c, Product_Publisher__c, Open_access__c, Content_Position__c,Publisher__c FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c =:bundleId and IsUnsilo__c=true and Content_Position__c > :pstn and uuid__c = null and doi__c != null ORDER BY Content_Position__c limit 1000')){
listofLineItems.addAll(lineItems);
}*/
            /*for(List<Bundle_Line_Item__c> lineItems : Database.Query('SELECT id, Product_Bundle_Parent__c, doi__c, Content_ID__c, Journal__c,Publication_Date__c, Title__c, Authors__c, Product_Publisher__c, Open_access__c, Content_Position__c,Publisher__c FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c =:bundleId and Content_Position__c > :pstn and uuid__c = null and doi__c != null ORDER BY Content_Position__c limit 1000')){
listofLineItems.addAll(lineItems);
}*/
            for(List<Bundle_Line_Item__c> lineItems : Database.Query('SELECT id, Product_Bundle_Parent__c, doi__c, Content_ID__c, Journal__c,Publication_Date__c, Title__c, Authors__c, Product_Publisher__c, Open_access__c, Content_Position__c,Publisher__c FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c =:bundleId and Content_Position__c > :pstn and Type__c!= :excludeTypeforvalidation and doi__c != null and uuid__c = null ORDER BY Content_Position__c limit 1000')){
                listofLineItems.addAll(lineItems);
            }
            
        }else{
            listofLineItems.addAll(lineItemList);
            lineItemList.clear();
        }
        
        if(listofLineItems.size() > 0 ){
            vJson.position = integer.valueOf(listofLineItems[listofLineItems.size() - 1].Content_Position__c) ;
            recsProcessed = recsProcessed + listofLineItems.size() ;
            vJson.processedRecs = recsProcessed;
            vJson.moreRecsToProcess = recsProcessed == totalRecords ? 'False' : 'True' ;
        }
        
        try{
            JSONGenerator gen = JSON.createGenerator(true);
            
            
            gen.writeStartObject();
            gen.writeStringField('topic','product-info-request');    
            gen.writeStringField('source','salesforce'); 
            gen.writeStringField('application','product-packaging');
            gen.writeStringField('timestamp',now.formatGMT('yyyy-MM-dd')+'T'+now.formatGMT('HH-mm-ss-SSS')+'Z');
            
            
            gen.writeFieldName('requests');
            gen.writeStartArray();
            gen.writeStartObject();
            
            
            
            gen.writeStringField('keyType','doi'); 
            gen.writeFieldName('values'); 
            gen.writeStartArray();
            
            for (Bundle_Line_Item__c litm : listofLineItems) {        
                
                gen.writeStartObject();
                gen.writeStringField('value', litm.doi__c == null ? '' : litm.doi__c);
                gen.writeEndObject();  
                
            }
            gen.writeEndArray();
            
            gen.writeFieldName('validations'); 
            
            gen.writeStartArray();
            gen.writeEndArray();
            
            gen.writeEndObject();
            
            gen.writeEndArray();
            gen.writeEndObject();
            
            String jsonString = gen.getAsString();
            vJson.jsonString = jsonString ;
            System.Debug('ValidationString' + jsonString);
        }catch(Exception e){
            System.debug('ValidationString getStackTrace' + e.getStackTraceString());
        }
        
        return vJson;
    }   
    
    public static List<Pricebookentry> getPriceBookEntry(String parentProductID) {  
        List<Pricebookentry> result;             
        List<Pricebook2> priceBookId;
        Id tandfPriceBookId;
        
        if (test.isrunningtest())
        { 
            tandfPriceBookId=Test.getStandardPricebookId();       
        }
        else
        {
            priceBookId=[select Id from Pricebook2 where name='T&F Pricebook'];
            tandfPriceBookId= priceBookId[0].id;    
            
        }      
        
        List <PricebookEntry> pbe = [select UnitPrice,CurrencyIsoCode,CreatedDate from Pricebookentry where pricebook2id=:tandfPriceBookId and product2id=:parentProductID];
        Return pbe;
    }
    
    public static List<Pricebookentry> getDiscountedPriceBookEntry(String parentProductID) {  
        List<Pricebookentry> result;             
        List<Pricebook2> priceBookId;
        Id tandfEbookPriceBookId;
        
        if (test.isrunningtest())
        { 
            tandfEbookPriceBookId=Test.getStandardPricebookId();       
        }
        else
        {
            priceBookId=[select Id from Pricebook2 where name='T&F - eBooks Pricebook'];
            tandfEbookPriceBookId= priceBookId[0].id;    
            
        }      
        
        List <PricebookEntry> pbe = [select UnitPrice,CurrencyIsoCode,CreatedDate from Pricebookentry where pricebook2id=:tandfEbookPriceBookId and product2id=:parentProductID];
        Return pbe;
    }
    
    private static String generateUUID(){
        String hashString = '1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
        String hexDigest = EncodingUtil.convertToHex(hash);
        return hexDigest;
        
    }
    
    @AuraEnabled 
    public static String GenerateQueryJson(String bundleId, String type , List<TF_PPDProcessController.MultiTypeRules> multiTypeRules, Integer offsetValue, Integer limitValue) { 
        //  Integer offsetValue = 0;
        // Integer limitValue = 30;       
        
        List<Product2> prdList =new List<Product2>();
        Product2 prd =new Product2();
        
        prdList =[SELECT Hub_Id__c, Id FROM Product2 where id=:bundleId];
        
        if(!prdList.isEmpty()){
            prd = prdList[0];
        }
        
        try{
            JSONGenerator gen = JSON.createGenerator(true);
            
            gen.writeStartObject();
            
            gen.writeFieldName('metadata');
            gen.writeStartObject();
            
            gen.writeStringField('Application','SF');    
            gen.writeStringField('@id',prd.Hub_Id__c != null ? prd.Hub_Id__c : prd.Id); 
            
            gen.writeFieldName('query');
            gen.writeStartObject();
            
            gen.writeFieldName('offset'); 
            gen.writeNumber(offsetValue);
            
            gen.writeFieldName('limit'); 
            gen.writeNumber(limitValue);
            
            gen.writeFieldName('type'); 
            gen.writeString(type != null ? type : 'Book');
            
            gen.writeFieldName('includeTotalPrice'); 
            gen.writeBoolean(true);
            
            gen.writeEndObject();
            
            gen.writeEndObject();
            
            gen.writeFieldName('data');
            gen.writeStartArray();
            
            for (TF_PPDProcessController.MultiTypeRules multiRuleEle : multiTypeRules) {  
                
                gen.writeStartObject();
                
                gen.writeStringField('type',multiRuleEle.productType != null ? multiRuleEle.productType : 'Book');
                
                gen.writeFieldName('rules');
                gen.writeStartArray();
                List<TF_PPDProcessController.RuleElement> ruleElementLst = new List<TF_PPDProcessController.RuleElement>();
                ruleElementLst = multiRuleEle.ruleElementLst ;
                Integer intPosition=1;
                for (TF_PPDProcessController.RuleElement ruleEle : ruleElementLst) {  
                    
                    gen.writeStartObject();
                    
                    gen.writeFieldName('type'); 
                    gen.writeString(ruleEle.type);
                    
                    gen.writeFieldName('rule');
                    gen.writeStartObject();
                    
                    if(ruleEle.type == 'separator'){
                        
                        gen.writeFieldName('value'); 
                        gen.writeString(ruleEle.value);
                    }
                    
                    if(ruleEle.type == 'criteria'){
                        
                        gen.writeFieldName('attribute'); 
                        gen.writeString(ruleEle.attribute);
                        
                        gen.writeFieldName('relationship'); 
                        gen.writeString(ruleEle.relationship);
                        
                        if(ruleEle.relationship == 'IN' || ruleEle.relationship == 'NI'){
                            List<String> valueList = new  List<String>();
                            String valueStr = ruleEle.value ;
                            valueStr=valueStr.replace('\n', ',');
                            valueList = valueStr.split(',');
                            gen.writeFieldName('values'); 
                            gen.writeObject(valueList);
                        }else{
                            gen.writeFieldName('value'); 
                            gen.writeString(ruleEle.value);
                        }
                    }
                    
                    if(ruleEle.type == 'logical'){
                        
                        gen.writeFieldName('value'); 
                        gen.writeString(ruleEle.value);
                    }
                    
                    gen.writeEndObject();
                    
                    gen.writeFieldName('position'); 
                    gen.writeNumber(intPosition);
                    
                    gen.writeEndObject();
                    
                    intPosition++;
                }            
                gen.writeEndArray(); // for rules
                
                gen.writeEndObject();
            }
            gen.writeEndArray(); // for data
            
            gen.writeEndObject();
            
            String jsonString = gen.getAsString();
            System.Debug('QueryPCMJSONString' + jsonString);
            return jsonString ;
        }catch(Exception e){
            System.debug('QueryPCMJSON getStackTrace' + e.getStackTraceString());
            return null;
        }
        
    }
       
    @AuraEnabled 
    public static String GenerateDynamicPackageJson(String bundleId, List<TF_PPDProcessController.MultiTypeRules> multiTypeRules){ 
        
        List<Product2> prdList =new List<Product2>();
        Product2 originalPrdList =new Product2();
        Product2 prd =new Product2();
        
        prdList =[SELECT Hub_Id__c, name,alternateName__c,Product_Type_Author_Facing__c,inLanguage__c,version__c,doi__c,ean__c,issn__c,id,Description,Product_Publisher__c,
                  CreatedDate,LastModifiedDate,copyrightyear__c,Lead_Author_Editor__c,Category__c,Keywords__c, Contributors__c,Sales_Channels__c,
                  Applicable_Channels__c,Applicable_License_Types__c,Applicable_Customer_Types__c,originalProductId__c
                  FROM Product2 where id=:bundleId                      
                 ];
        
        
        if(!prdList.isEmpty()){
            prd = prdList[0];
        }
        
        if(prd.originalProductId__c!=NULL){
            originalPrdList=[SELECT Hub_Id__c, name, CreatedDate,LastModifiedDate from product2 where id=:prd.originalProductId__c];
        } 
        
        List<Pricebookentry> lstpbe = getPriceBookEntry(bundleId);
        
        String contributors = prd.Contributors__c;
        String keywords = prd.Keywords__c;
        
        List<Contributors> contributorsLst = new List<Contributors>(); 
        List<Keywords> keywordsLst = new List<Keywords>();    
        
        if(contributors != null){
            contributorsLst = (List<Contributors>) JSON.deserialize(contributors, List<Contributors>.class);
        }
        
        if(keywords != null){
            keywordsLst = ( List<Keywords>) JSON.deserialize(keywords,  List<Keywords>.class);
        }
        
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();//start 1
        
        gen.writeStringField('@id',prd.Hub_Id__c==null ? '': prd.Hub_Id__c);
        gen.writeStringField('Application','SF');
        gen.writeStringField('action','save');
        gen.writeFieldName('data');
        
        gen.writeStartObject();//start 2
        
        gen.writeStringField('@type','Collection');
        if(prd.version__c!=NULL && prd.version__c=='1.0.0'&& prd.originalProductId__c==NULL){
            gen.writeDateTimeField('createdDate',prd.CreatedDate);
            gen.writeDateTimeField('modifiedDate',prd.LastModifiedDate);
        }
        else if(prd.version__c!=NULL && prd.version__c!='1.0.0' && prd.originalProductId__c!=NULL){
            gen.writeDateTimeField('createdDate',originalPrdList.CreatedDate);
            gen.writeDateTimeField('modifiedDate',prd.LastModifiedDate);
        }
        gen.writeStringField('version',prd.version__c==null ? '' : prd.version__c);
        gen.writeStringField('title',prd.name==null ? '' : prd.name);
        gen.writeStringField('subtitle',prd.alternateName__c==null ? '' : prd.alternateName__c);
        gen.writeStringField('description',prd.description==null ? '' : prd.description);
        gen.writeStringField('inLanguage',prd.inLanguage__c==null ? '' : prd.inLanguage__c);
        gen.writeStringField('publisherImprint',prd.Product_Publisher__c==null ? '' : prd.Product_Publisher__c);
        
        gen.writeFieldName('copyright');
        gen.writeStartObject();//start 3
        gen.writeEndObject();//end 3
        
        gen.writeFieldName('rights');
        gen.writeStartObject();//start 4
        gen.writeEndObject();//end 4        
        
        gen.writeFieldName('restrictions');
        gen.writeStartObject();//start 4
        gen.writeEndObject();//end 4 
        
        gen.writeFieldName('classifications');
        gen.writeStartArray();//start 5
        gen.writeEndArray();//end 5
        
        
        if(contributorsLst != null && contributorsLst.size() > 0){
            
            gen.writeFieldName('contributors');
            gen.writeStartArray();//start 6
            for(Contributors contributor : contributorsLst){
                gen.writeStartObject();//start 15
                gen.writeFieldName('roles');
                
                gen.writeStartArray();//start 7
                gen.writeString(contributor.role);
                // gen.writeFieldName(contributor.role);
                gen.writeEndArray();//end 7
                
                gen.writeStringField('givenName',contributor.givenName==null ? '' : contributor.givenName);
                gen.writeStringField('familyName',contributor.familyName==null ? '' : contributor.familyName);
                gen.writeNumberField('position', contributor.position==null ? 0 : contributor.position);
                
                gen.writeEndObject();//end 15
            }
            gen.writeEndArray();//end 6
            
            
        }else{
            gen.writeFieldName('contributors');
            gen.writeStartArray();//start 8
            gen.writeEndArray();//end 8
            
        }
        
        if(keywordsLst != null && keywordsLst.size() > 0){
            
            gen.writeFieldName('keywords');
            gen.writeStartArray();//start 10
            gen.writeStartObject();//start 21
            
            gen.writeStringField('type','editor');
            
            gen.writeFieldName('entries');
            gen.writeStartArray();//start 12
            system.debug('keywordsLst====='+ keywordsLst);
            for(Keywords keyword : keywordsLst){
                gen.writeStartObject();//start 17
                
                gen.writeStringField('name',keyword.name==null ? '' : keyword.name);
                gen.writeNumberField('position', keyword.position==null ? 0 : keyword.position);
                
                gen.writeEndObject();//end 17
            }
            gen.writeEndArray();//end 12
            gen.writeEndObject();//end 21
            
            gen.writeEndArray();//end 10
            
        }else{
            gen.writeFieldName('keywords');
            gen.writeStartArray();//start 14
            gen.writeEndArray();//end 14
        }
        
        gen.writeFieldName('prices');
        gen.writeStartArray();//start 19
        
        for (PricebookEntry pbe : lstPbe) {
            
            gen.writeStartObject();//start 18
            
            gen.writeFieldName('price'); 
            gen.writeString(String.valueOf(pbe.UnitPrice)==null ? '0.00'  : String.valueOf(pbe.UnitPrice));
            gen.writeFieldName('currency'); 
            gen.writeString(pbe.CurrencyIsoCode==null ? '' : pbe.CurrencyIsoCode); 
            gen.writeDateTimeField('validFrom',pbe.CreatedDate);
            
            
            gen.writeEndObject();//end 18
            
        }
        gen.writeEndArray();//end 19
        
        gen.writeFieldName('isPartOf');
        gen.writeStartArray();//start 22
        gen.writeEndArray();//end 22
        
        gen.writeStringField('collectionType','dynamic');
        gen.writeStringField('doi',prd.doi__c==null ? '' : prd.doi__c);
        gen.writeStringField('ean',prd.ean__c == null ? '' : prd.ean__c);
        gen.writeStringField('issn',prd.issn__c==null ? '' : prd.issn__c);
        gen.writeStringField('sku',prd.id==null ? '' : prd.id);
        gen.writeStringField('productId',prd.id==null ? '' : prd.id);
        
        
        gen.writeFieldName('queries');
        gen.writeStartArray();
        
        for (TF_PPDProcessController.MultiTypeRules multiRuleEle : multiTypeRules) {  
            
            gen.writeStartObject();
            
            gen.writeStringField('type',multiRuleEle.productType != null ? multiRuleEle.productType : 'Book');
            
            gen.writeFieldName('rules');
            gen.writeStartArray();
            List<TF_PPDProcessController.RuleElement> ruleElementLst = new List<TF_PPDProcessController.RuleElement>();
            ruleElementLst = multiRuleEle.ruleElementLst ;
            Integer intPosition=1;
            for (TF_PPDProcessController.RuleElement ruleEle : ruleElementLst) {  
                
                gen.writeStartObject();
                
                gen.writeFieldName('type'); 
                gen.writeString(ruleEle.type);
                
                gen.writeFieldName('rule');
                gen.writeStartObject();
                
                if(ruleEle.type == 'separator'){
                    
                    gen.writeFieldName('value'); 
                    gen.writeString(ruleEle.value);
                }
                
                if(ruleEle.type == 'criteria'){
                    
                    gen.writeFieldName('attribute'); 
                    gen.writeString(ruleEle.attribute);
                    
                    gen.writeFieldName('relationship'); 
                    gen.writeString(ruleEle.relationship);
                    
                    if(ruleEle.relationship == 'IN' || ruleEle.relationship == 'NI'){
                        List<String> valueList = new  List<String>();
                        String valueStr = ruleEle.value ;
                        valueStr=valueStr.replace('\n', ',');
                        valueList = valueStr.split(',');
                        gen.writeFieldName('values'); 
                        gen.writeObject(valueList);
                    }else{
                        gen.writeFieldName('value'); 
                        gen.writeString(ruleEle.value);
                    }
                }
                
                if(ruleEle.type == 'logical'){
                    
                    gen.writeFieldName('value'); 
                    gen.writeString(ruleEle.value);
                }
                
                gen.writeEndObject();
                
                gen.writeFieldName('position'); 
                gen.writeNumber(intPosition);
                
                gen.writeEndObject();
                
                intPosition++;
            }            
            gen.writeEndArray(); // for rules
            
            gen.writeEndObject();
        }
        gen.writeEndArray(); // for queries
        
        gen.writeEndObject();//end 2
        
        gen.writeEndObject();//end 1
        
        String jsonString = gen.getAsString();
        return jsonString;
        
    }
    
    private static AvailabilityDetails calculateAvailability(String consumer, String bundleId) {
        List<Product2> prdLst = new List<Product2>();
        List<Setting_Item__c> settingItemLst = new List<Setting_Item__c>();
        Product2 prd = new Product2();
        List<String> salesChannelLst = new List<String>();
        List<String> deliveryChannelLst = new List<String>();
        List<String> allChannelLst = new List<String>();
        Map<String,List<Setting_Item__c>> channelAvailabilityMap = new  Map<String,List<Setting_Item__c>>();
        Map<String,List<Setting_Item__c>> channelAvailabilityTypMap = new  Map<String,List<Setting_Item__c>>();
        Map<String,Map<String,List<Setting_Item__c>>> availabilityTypeMap = new  Map<String,Map<String,List<Setting_Item__c>>>();
        Map<String,List<Setting_Item__c>> settingItemLstMap = new Map<String,List<Setting_Item__c>>();
        String salesChannels = null;
        String deliveryChannels = null;
        String collectionType = null;
        AvailabilityDetails availabilityDetails = new availabilityDetails();
        
        if(consumer != 'Collections'){
            settingItemLst = [SELECT Id,Checkbox_1__c,Text_1__c,Text_2__c,Text_3__c,Text_4__c,Text_6__c From Setting_Item__c WHERE Text_1__c =: consumer AND Checkbox_1__c = true AND Setting__r.Name = 'SearchAvailability'];
            
            if(settingItemLst != null && settingItemLst.size() > 0){
                for(Setting_Item__c setItm : settingItemLst){
                    if(settingItemLstMap.get(setItm.Text_6__c) == null){
                        List<Setting_Item__c> settingMapItm = new List<Setting_Item__c>();
                        settingMapItm.add(setItm); 
                        settingItemLstMap.put(setItm.Text_6__c,settingMapItm);  
                    }else{
                        settingItemLstMap.get(setItm.Text_6__c).add(setItm);
                    }
                }
                
            }
            availabilityDetails.settingItemLstMap = settingItemLstMap;
        }else{
            prdLst =[SELECT Hub_Id__c,name,id,Sales_Channels__c,Applicable_Channels__c,originalProductId__c,Product_Type_Author_Facing__c FROM Product2 where id=:bundleId];
            if(prdLst != null && prdLst.size() > 0){
                prd =  prdLst[0];
                salesChannels = prd.Sales_Channels__c;
                deliveryChannels = prd.Applicable_Channels__c;
                collectionType = prd.Product_Type_Author_Facing__c;
                if(salesChannels != null){
                    salesChannelLst = salesChannels.split(';');
                    allChannelLst.addAll(salesChannelLst);
                }
                
                if(deliveryChannels != null){
                    deliveryChannelLst = deliveryChannels.split(';');
                    allChannelLst.addAll(deliveryChannelLst);
                }
            }
            settingItemLst = [SELECT Id,Checkbox_1__c,Text_1__c,Text_2__c,Text_3__c,Text_4__c,Text_5__c,Text_6__c From Setting_Item__c WHERE Text_1__c =: consumer AND Text_2__c in: allChannelLst AND Checkbox_1__c = true AND Text_7__c =: collectionType AND Setting__r.Name = 'SearchAvailability'];
            
            
            if(settingItemLst != null && settingItemLst.size() > 0){
                Set<String> typesSet = new Set<String>();
                List<String> typeLst = new List<String>();
                for(Setting_Item__c setItm : settingItemLst){
                    if(setItm.Text_6__c != null){
                        typesSet.add(setItm.Text_6__c);
                    }
                }
                typeLst.addAll(typesSet);
                for(String typ : typeLst){
                    for(Setting_Item__c setItm : settingItemLst){
                        if(setItm.Text_6__c == typ){
                            if(channelAvailabilityTypMap.get(typ) == null){
                                List<Setting_Item__c> settingLst = new List<Setting_Item__c>();
                                settingLst.add(setItm);
                                channelAvailabilityTypMap.put(typ,settingLst);
                            }else{
                                channelAvailabilityTypMap.get(typ).add(setItm);
                            }
                        }
                    }
                }
                
                for(String typ : typeLst){
                    List<Setting_Item__c> settingLst = new List<Setting_Item__c>();
                    settingLst = channelAvailabilityTypMap.get(typ);
                    Map<String,List<Setting_Item__c>> channelAvalTypeMap = new  Map<String,List<Setting_Item__c>>();
                    
                    for(Setting_Item__c setItm : settingLst){
                        if(channelAvalTypeMap.get(setItm.Text_5__c) == null){
                            List<Setting_Item__c> settingMapItm = new List<Setting_Item__c>();
                            settingMapItm.add(setItm) ; 
                            channelAvalTypeMap.put(setItm.Text_5__c,settingMapItm) ;  
                        }else{
                            channelAvalTypeMap.get(setItm.Text_5__c).add(setItm);
                        }
                    }
                    availabilityTypeMap.put(typ,channelAvalTypeMap);
                }
            }
            availabilityDetails.availabilityTypeMap = availabilityTypeMap ;
        }
        return availabilityDetails;
    }
    
    @AuraEnabled 
    public static String GenerateCountAPIJson(String bundleId, String type , List<TF_PPDProcessController.MultiTypeRules> multiTypeRules, Integer offsetValue, Integer limitValue, String consumer) { 
        
        List<DotNotation> DotNotationLst = new List<DotNotation>(); 
        DotNotation dotNot = new DotNotation();
        List<SearchQueryDotNotations__c> strDotNotations = new List<SearchQueryDotNotations__c>();
        Map<String, SearchQueryDotNotations__c> dotNotationMap = new Map<String, SearchQueryDotNotations__c>();
        dotNotationMap = SearchQueryDotNotations__c.getAll();
        List<Setting_Item__c> settingItemLst = new List<Setting_Item__c>();
        List<Product2> prdLst = new List<Product2>();
        Product2 prd = new Product2();
        List<String> salesChannelLst = new List<String>();
        List<String> deliveryChannelLst = new List<String>();
        List<String> allChannelLst = new List<String>();
        Map<String,List<Setting_Item__c>> channelAvailabilityMap = new  Map<String,List<Setting_Item__c>>();
        Map<String,List<Setting_Item__c>> channelAvailabilityTypMap = new  Map<String,List<Setting_Item__c>>();
        Map<String,Map<String,List<Setting_Item__c>>> availabilityTypeMap = new  Map<String,Map<String,List<Setting_Item__c>>>();
        Map<String,List<Setting_Item__c>> settingItemLstMap = new Map<String,List<Setting_Item__c>>();
        
        String salesChannels = null;
        String deliveryChannels = null;
        
        strDotNotations=[select DotNotation__c from SearchQueryDotNotations__c where type__c='Common'];
        
        
        try{
            JSONGenerator gen = JSON.createGenerator(true);            
            gen.writeStartObject();         
            
            gen.writeStringField('apiVersion','4.0.1'); 
            gen.writeStringField('action','count');  
            
            gen.writeFieldName('hasCounts'); 
            gen.writeBoolean(true);
            
            gen.writeFieldName('hasTotalPrices'); 
            if(consumer == 'Collections'){
                gen.writeBoolean(true);           
            }else{
                gen.writeBoolean(false);           
            }
            
            gen.writeFieldName('rulesList');
            gen.writeStartArray();
            for (TF_PPDProcessController.MultiTypeRules multiRuleEle : multiTypeRules) { 
                
                gen.writeStartObject();        
                gen.writeStringField('type',multiRuleEle.productType != null ? multiRuleEle.productType : 'book'); 
                
                // Start of attributes
                gen.writeFieldName('attributes');
                gen.writeStartArray();    
                
                for(SearchQueryDotNotations__c dotNote:strDotNotations){
                    gen.writeString(String.valueOf(dotNote.DotNotation__c)); 
                }
                gen.writeEndArray();
                // End of attributes
                gen.writeFieldName('rules');//intenal rules
                gen.writeStartArray();//Start IR1 array
                gen.writeStartObject();//Start IR1 Obj 
                
                gen.writeStringField('type','group');
                gen.writeStringField('name','product');
                
                //Start of query rules
                gen.writeFieldName('rules');
                gen.writeStartArray();
                
                List<TF_PPDProcessController.RuleElement> ruleElementLst = new List<TF_PPDProcessController.RuleElement>();
                ruleElementLst = multiRuleEle.ruleElementLst ;
                Integer intPosition=1;
                for (TF_PPDProcessController.RuleElement ruleEle : ruleElementLst) {                      
                    gen.writeStartObject();
                    
                    gen.writeFieldName('type'); 
                    gen.writeString(ruleEle.type);
                    
                    gen.writeFieldName('rule');
                    gen.writeStartObject();
                    
                    if(ruleEle.type == 'separator'){                        
                        gen.writeFieldName('value'); 
                        gen.writeString(ruleEle.value);
                    }
                    
                    if(ruleEle.type == 'criteria'){
                        
                        gen.writeFieldName('attribute'); 
                        gen.writeString(ruleEle.attribute);
                        
                        gen.writeFieldName('relationship'); 
                        gen.writeString(ruleEle.relationship);
                        
                        if(ruleEle.relationship == 'IN' || ruleEle.relationship == 'NI'){
                            List<String> valueList = new  List<String>();
                            String valueStr = ruleEle.value ;
                            valueStr=valueStr.replace('\n', ',');
                            valueList = valueStr.split(',');
                            gen.writeFieldName('values'); 
                            gen.writeObject(valueList);
                        }else{
                            gen.writeFieldName('value'); 
                            gen.writeString(ruleEle.value);
                        }
                    }                    
                    if(ruleEle.type == 'logical'){                        
                        gen.writeFieldName('value'); 
                        gen.writeString(ruleEle.value);
                    }                    
                    gen.writeEndObject();                    
                    gen.writeFieldName('position'); 
                    gen.writeNumber(intPosition);                    
                    gen.writeEndObject();                    
                    intPosition++;
                }          
                gen.writeEndArray();
                //End of query rules
                
                gen.writeEndObject(); //End IR1 Obj
                
                //Availability object declarations
                
                ruleObj rObjBEGIN = new ruleObj();
                rObjBEGIN.type = 'separator';
                ruleObj rObjEND = new ruleObj();
                rObjEND.type = 'separator';
                ruleObj rObjAND = new ruleObj();
                rObjAND.type = 'logical';
                ruleObjVal rObjName = new ruleObjVal();
                rObjName.type = 'criteria';
                ruleObjVals rObjStatus = new ruleObjVals();
                rObjStatus.type = 'criteria';
                
                rule rBEGIN = new rule();
                rBEGIN.value = 'BEGIN';
                rObjBEGIN.rule = rBEGIN;
                
                
                rule rEND =  new rule();
                rEND.value = 'END';
                rObjEND.rule = rEND;
                
                rule rAND = new rule() ;
                rAND.value = 'AND';
                rObjAND.rule = rAND;
                
                ruleVal rName = new ruleVal() ;
                rName.attribute = 'availability.name';
                rName.relationship = 'EQ';
                rObjName.rule = rName;
                
                
                ruleVals rStatus = new ruleVals() ;
                rStatus.attribute = 'availability.status';
                rObjStatus.rule = rStatus;
                
                if(consumer != 'Collections'){
                    AvailabilityDetails availabilityDetails = new AvailabilityDetails();
                    availabilityDetails= calculateAvailability(consumer,bundleId);
                    settingItemLstMap = availabilityDetails.settingItemLstMap;
                    
                    if(settingItemLstMap != null && settingItemLstMap.size() > 0 &&  settingItemLstMap.get(multiRuleEle.productType) != null){
                        List<Setting_Item__c> settingItemTypeLst = new List<Setting_Item__c>();
                        settingItemTypeLst = settingItemLstMap.get(multiRuleEle.productType);
                        
                        if(settingItemTypeLst != null && settingItemTypeLst.size() > 0){
                            gen.writeStartObject();//Start IR2 Obj
                            
                            gen.writeStringField('type','group');
                            gen.writeStringField('name','availability');
                            
                            gen.writeFieldName('rules');
                            gen.writeStartArray();//availability rules arr start
                            
                            
                            gen.writeObject(rObjBEGIN);
                            
                            Integer loopCount = 0;
                            for(Setting_Item__c setItm : settingItemTypeLst){
                                
                                gen.writeObject(rObjBEGIN);
                                
                                rName.value = setItm.Text_2__c; 
                                gen.writeObject(rObjName);
                                
                                gen.writeObject(rObjAND);
                                
                                rStatus.relationship = setItm.Text_4__c;
                                
                                String status = '';
                                status = setItm.Text_3__c;
                                if(status != null){
                                    List<String> statusLst = new List<String>();
                                    statusLst = status.split(',');
                                    rStatus.values = statusLst;
                                }
                                
                                gen.writeObject(rObjStatus);
                                
                                gen.writeObject(rObjEND);
                                
                                loopCount++;
                                
                                if(loopCount < settingItemTypeLst.size()){
                                    gen.writeObject(rObjAND);
                                }
                            }
                            
                            gen.writeObject(rObjEND);
                            
                            gen.writeEndArray();//availability rules arr End
                            gen.writeEndObject(); //End IR2 Obj 
                        }
                    }
                }else{
                    AvailabilityDetails availabilityDetails = new AvailabilityDetails();
                    availabilityDetails= calculateAvailability(consumer,bundleId);
                    availabilityTypeMap = availabilityDetails.availabilityTypeMap;
                    
                    allChannelLst.clear();
                    system.debug('availabilityTypeMap====='+ JSON.serialize(availabilityTypeMap));
                    channelAvailabilityMap = availabilityTypeMap.get(multiRuleEle.productType);
                    if(channelAvailabilityMap  != null && channelAvailabilityMap.size() > 0){
                        allChannelLst.addAll(channelAvailabilityMap.keySet());
                    }
                    system.debug('allChannelLst====='+ JSON.serialize(allChannelLst));
                    
                    if(allChannelLst != null && allChannelLst.size() > 0){
                        
                        gen.writeStartObject();//Start IR2 Obj
                        
                        gen.writeStringField('type','group');
                        gen.writeStringField('name','availability');
                        
                        gen.writeFieldName('rules');
                        gen.writeStartArray();//availability rules arr start
                        
                        
                        gen.writeObject(rObjBEGIN);
                        
                        Integer loopCount = 0;
                        for(String channelName : allChannelLst){
                            
                            gen.writeObject(rObjBEGIN);
                            
                            rName.value = channelName; 
                            gen.writeObject(rObjName);
                            
                            gen.writeObject(rObjAND);
                            
                            
                            List<Setting_Item__c> settingItmLst = new  List<Setting_Item__c>();
                            settingItmLst = channelAvailabilityMap.get(channelName);
                            String statusOpe = settingItmLst[0].Text_4__c;
                            
                            List<String> statusLst = new List<String>();
                            Set<String> statusSet = new Set<String>();
                            for(Setting_Item__c itm :settingItmLst){
                                if(itm.Text_3__c != null){
                                    statusLst.addAll(itm.Text_3__c.split(','));
                                    statusSet.addAll(statusLst);
                                    statusLst.clear();
                                    statusLst.addAll(statusSet);
                                }
                            }
                            
                            rStatus.relationship = statusOpe;
                            rStatus.values = statusLst;
                            
                            gen.writeObject(rObjStatus);
                            
                            gen.writeObject(rObjEND);
                            
                            loopCount++;
                            
                            if(loopCount < allChannelLst.size()){
                                gen.writeObject(rObjAND);
                            }
                        }
                        
                        gen.writeObject(rObjEND);
                        
                        gen.writeEndArray();//availability rules arr End
                        gen.writeEndObject(); //End IR2 Obj 
                    }
                }                
                gen.writeEndArray();//End IR1 array
                
                gen.writeEndObject();
                //break;
                
            }//End of loop
            gen.writeEndArray();// End of rulesList
            gen.writeEndObject();//first bracet closed           
            String jsonString = gen.getAsString();
            System.Debug('QueryPCMJSONString' + jsonString);
            return jsonString ;
        }catch(Exception e){
            System.debug('QueryPCMJSON getStackTrace' + e.getStackTraceString());
            return null;
        }
        
    }
    
    @AuraEnabled 
    public static String GenerateQueryJsonNewModel(String bundleId, String type , List<TF_PPDProcessController.MultiTypeRules> multiTypeRules, Integer offsetValue, String offsetCursor, Integer limitValue, String consumer) { 
        
        List<DotNotation> DotNotationLst = new List<DotNotation>(); 
        DotNotation dotNot = new DotNotation();
        Map<String, SearchQueryDotNotations__c> dotNotationMap = new Map<String, SearchQueryDotNotations__c>();
        dotNotationMap = SearchQueryDotNotations__c.getAll();
        string jsonstrdotNotation = JSON.serialize(dotNotationMap);
       
        List<SearchQueryDotNotations__c> strDotNotations = new List<SearchQueryDotNotations__c>();
        List<Setting_Item__c> settingItemLst = new List<Setting_Item__c>();
        Map<String,List<Setting_Item__c>> settingItemLstMap = new Map<String,List<Setting_Item__c>>();
        
        List<Product2> prdLst = new List<Product2>();
        Product2 prd = new Product2();
        List<String> salesChannelLst = new List<String>();
        List<String> deliveryChannelLst = new List<String>();
        List<String> allChannelLst = new List<String>();
        Map<String,List<Setting_Item__c>> channelAvailabilityMap = new  Map<String,List<Setting_Item__c>>();
        Map<String,List<Setting_Item__c>> channelAvailabilityTypMap = new  Map<String,List<Setting_Item__c>>();
        Map<String,Map<String,List<Setting_Item__c>>> availabilityTypeMap = new  Map<String,Map<String,List<Setting_Item__c>>>();
        String salesChannels = null;
        String deliveryChannels = null;
        
        strDotNotations=[select DotNotation__c from SearchQueryDotNotations__c where type__c=:type OR type__c='Common'];
        
        try{
            JSONGenerator gen = JSON.createGenerator(true);            
            gen.writeStartObject();         
            
            gen.writeStringField('apiVersion','4.0.1'); 
            gen.writeStringField('action','query'); 
            
            if(offsetCursor != null){
                gen.writeFieldName('offsetCursor'); 
				gen.writeString(offsetCursor);
            } else {
                gen.writeFieldName('offset'); 
            	//gen.writeNumber(offsetValue);
				gen.writeNumber(0);
                gen.writeFieldName('offsetCursor'); 
				gen.writeString('');
            }
          
            gen.writeFieldName('limit'); 
            gen.writeNumber(limitValue);
            
            gen.writeFieldName('hasCounts'); 
            gen.writeBoolean(true);
            
            gen.writeFieldName('hasTotalPrices'); 
            if(consumer == 'Collections'){
                gen.writeBoolean(true);           
            }else{
                gen.writeBoolean(false);           
            }
            
            gen.writeFieldName('rulesList');
            
            gen.writeStartArray();
            
            for (TF_PPDProcessController.MultiTypeRules multiRuleEle : multiTypeRules) { 
                if(type!=multiRuleEle.productType){
                    continue;
                }
                gen.writeStartObject();        
                gen.writeStringField('type',multiRuleEle.productType != null ? multiRuleEle.productType : 'book'); 
                
                // Start of attributes
                gen.writeFieldName('attributes');
                gen.writeStartArray();    
                
                for(SearchQueryDotNotations__c dotNote:strDotNotations){
                    gen.writeString(String.valueOf(dotNote.DotNotation__c)); 
                }
                gen.writeEndArray();
                // End of attributes
                gen.writeFieldName('rules');//intenal rules
                gen.writeStartArray();//Start IR1 array
                gen.writeStartObject();//Start IR1 Obj 
                
                gen.writeStringField('type','group');
                gen.writeStringField('name','product');
                
                //Start of query rules
                gen.writeFieldName('rules');
                gen.writeStartArray();
                
                List<TF_PPDProcessController.RuleElement> ruleElementLst = new List<TF_PPDProcessController.RuleElement>();
                ruleElementLst = multiRuleEle.ruleElementLst ;
                Integer intPosition=1;
                for (TF_PPDProcessController.RuleElement ruleEle : ruleElementLst) {                      
                    gen.writeStartObject();
                    
                    gen.writeFieldName('type'); 
                    gen.writeString(ruleEle.type);
                    
                    gen.writeFieldName('rule');
                    gen.writeStartObject();
                    
                    if(ruleEle.type == 'separator'){                        
                        gen.writeFieldName('value'); 
                        gen.writeString(ruleEle.value);
                    }
                    
                    if(ruleEle.type == 'criteria'){
                        
                        gen.writeFieldName('attribute'); 
                        gen.writeString(ruleEle.attribute);
                        
                        gen.writeFieldName('relationship'); 
                        gen.writeString(ruleEle.relationship);
                        
                        if(ruleEle.relationship == 'IN' || ruleEle.relationship == 'NI'){
                            List<String> valueList = new  List<String>();
                            String valueStr = ruleEle.value ;
                            system.debug('%%%%%valueStr%%-' + valueStr);
                            valueStr=valueStr.replace('\n', ',');
                            valueList = valueStr.split(',');
                            gen.writeFieldName('values'); 
                            gen.writeObject(valueList);
                        }else{
                            gen.writeFieldName('value'); 
                            gen.writeString(ruleEle.value);
                        }
                    }                    
                    if(ruleEle.type == 'logical'){                        
                        gen.writeFieldName('value'); 
                        gen.writeString(ruleEle.value);
                    }                    
                    gen.writeEndObject();                    
                    gen.writeFieldName('position'); 
                    gen.writeNumber(intPosition);                    
                    gen.writeEndObject();                    
                    intPosition++;
                }          
                gen.writeEndArray();
                //End of query rules
                
                gen.writeEndObject(); //End IR1 Obj
                
                //Availability object declarations
                
                ruleObj rObjBEGIN = new ruleObj();
                rObjBEGIN.type = 'separator';
                ruleObj rObjEND = new ruleObj();
                rObjEND.type = 'separator';
                ruleObj rObjAND = new ruleObj();
                rObjAND.type = 'logical';
                ruleObjVal rObjName = new ruleObjVal();
                rObjName.type = 'criteria';
                ruleObjVals rObjStatus = new ruleObjVals();
                rObjStatus.type = 'criteria';
                
                rule rBEGIN = new rule();
                rBEGIN.value = 'BEGIN';
                rObjBEGIN.rule = rBEGIN;
                
                
                rule rEND =  new rule();
                rEND.value = 'END';
                rObjEND.rule = rEND;
                
                rule rAND = new rule() ;
                rAND.value = 'AND';
                rObjAND.rule = rAND;
                
                ruleVal rName = new ruleVal() ;
                rName.attribute = 'availability.name';
                rName.relationship = 'EQ';
                rObjName.rule = rName;
                
                
                ruleVals rStatus = new ruleVals() ;
                rStatus.attribute = 'availability.status';
                rObjStatus.rule = rStatus;
                
                if(consumer != 'Collections'){
                    AvailabilityDetails availabilityDetails = new AvailabilityDetails();
                    availabilityDetails= calculateAvailability(consumer,bundleId);
                    settingItemLstMap = availabilityDetails.settingItemLstMap;
                    
                    if(settingItemLstMap != null && settingItemLstMap.size() > 0 &&  settingItemLstMap.get(multiRuleEle.productType) != null){
                        List<Setting_Item__c> settingItemTypeLst = new List<Setting_Item__c>();
                        settingItemTypeLst = settingItemLstMap.get(multiRuleEle.productType);
                        
                        if(settingItemTypeLst != null && settingItemTypeLst.size() > 0){
                            gen.writeStartObject();//Start IR2 Obj
                            
                            gen.writeStringField('type','group');
                            gen.writeStringField('name','availability');
                            
                            gen.writeFieldName('rules');
                            gen.writeStartArray();//availability rules arr start
                            
                            
                            gen.writeObject(rObjBEGIN);
                            
                            Integer loopCount = 0;
                            for(Setting_Item__c setItm : settingItemTypeLst){
                                
                                gen.writeObject(rObjBEGIN);
                                
                                rName.value = setItm.Text_2__c; 
                                gen.writeObject(rObjName);
                                
                                gen.writeObject(rObjAND);
                                
                                rStatus.relationship = setItm.Text_4__c;
                                
                                String status = '';
                                status = setItm.Text_3__c;
                                if(status != null){
                                    List<String> statusLst = new List<String>();
                                    statusLst = status.split(',');
                                    rStatus.values = statusLst;
                                }
                                
                                gen.writeObject(rObjStatus);
                                
                                gen.writeObject(rObjEND);
                                
                                loopCount++;
                                
                                if(loopCount < settingItemTypeLst.size()){
                                    gen.writeObject(rObjAND);
                                }
                            }
                            
                            gen.writeObject(rObjEND);
                            
                            gen.writeEndArray();//availability rules arr End
                            gen.writeEndObject(); //End IR2 Obj 
                        }
                    }
                }else{
                    AvailabilityDetails availabilityDetails = new AvailabilityDetails();
                    availabilityDetails= calculateAvailability(consumer,bundleId);
                    availabilityTypeMap = availabilityDetails.availabilityTypeMap;
                    
                    allChannelLst.clear();
                    system.debug('availabilityTypeMap====='+ JSON.serialize(availabilityTypeMap));
                    channelAvailabilityMap = availabilityTypeMap.get(multiRuleEle.productType);
                    if(channelAvailabilityMap  != null && channelAvailabilityMap.size() > 0){
                        allChannelLst.addAll(channelAvailabilityMap.keySet());
                    }
                    system.debug('allChannelLst====='+ JSON.serialize(allChannelLst));
                    
                    if(allChannelLst != null && allChannelLst.size() > 0){
                        
                        gen.writeStartObject();//Start IR2 Obj
                        
                        gen.writeStringField('type','group');
                        gen.writeStringField('name','availability');
                        
                        gen.writeFieldName('rules');
                        gen.writeStartArray();//availability rules arr start
                        
                        
                        gen.writeObject(rObjBEGIN);
                        
                        Integer loopCount = 0;
                        for(String channelName : allChannelLst){
                            
                            gen.writeObject(rObjBEGIN);
                            
                            rName.value = channelName; 
                            gen.writeObject(rObjName);
                            
                            gen.writeObject(rObjAND);
                            
                            
                            List<Setting_Item__c> settingItmLst = new  List<Setting_Item__c>();
                            settingItmLst = channelAvailabilityMap.get(channelName);
                            String statusOpe = settingItmLst[0].Text_4__c;
                            
                            List<String> statusLst = new List<String>();
                            Set<String> statusSet = new Set<String>();
                            for(Setting_Item__c itm :settingItmLst){
                                if(itm.Text_3__c != null){
                                    statusLst.addAll(itm.Text_3__c.split(','));
                                    statusSet.addAll(statusLst);
                                    statusLst.clear();
                                    statusLst.addAll(statusSet);
                                }
                            }
                            
                            rStatus.relationship = statusOpe;
                            rStatus.values = statusLst;
                            
                            gen.writeObject(rObjStatus);
                            
                            gen.writeObject(rObjEND);
                            
                            loopCount++;
                            
                            if(loopCount < allChannelLst.size()){
                                gen.writeObject(rObjAND);
                            }
                        }
                        
                        gen.writeObject(rObjEND);
                        
                        gen.writeEndArray();//availability rules arr End
                        gen.writeEndObject(); //End IR2 Obj 
                    }
                }                
                gen.writeEndArray();//End IR1 array
                
                gen.writeEndObject();
                //break;
                
            }//End of loop
            gen.writeEndArray();// End of rulesList
            gen.writeEndObject();//first bracet closed           
            String jsonString = gen.getAsString();
            System.Debug('QueryPCMJSONString' + jsonString);
            return jsonString ;
        }catch(Exception e){
            System.debug('QueryPCMJSON getStackTrace' + e.getStackTraceString());
            return null;
        }
        
    }
     
    @AuraEnabled
    public static String GenerateCommonModelJson(String bundleId, list< Bundle_Line_Item__c> listofLineItems,List<TF_PPDProcessController.MultiTypeRules> multiTypeRules) { 
        String jsonString;
        List<Product2> prdList =new List<Product2>();
        Product2 originalPrdList =new Product2();
        Product2 prd =new Product2();
        list< Bundle_Line_Item__c> listofLineItemsForUpdate = new list< Bundle_Line_Item__c>();
        list< Bundle_Line_Item__c> listofLineItemsForDelete = new list< Bundle_Line_Item__c>();
        Map<String,String> typeMap = new Map<String,String>();
        Map<String,Map<String,List<Setting_Item__c>>> availabilityTypeMap = new  Map<String,Map<String,List<Setting_Item__c>>>();
        Map<String,List<Setting_Item__c>> channelAvailabilityMap = new  Map<String,List<Setting_Item__c>>();
        
        List<String> allChannelLst = new List<String>();
        typeMap.put('CHAPTER','Chapter');
        typeMap.put('SCHOLARLYARTICLE','ScholarlyArticle');
        typeMap.put('CREATIVEWORK','CreativeWork');
        typeMap.put('BOOK','Book');
        typeMap.put('COLLECTION','Collection');
        Integer i=0;
        String isUpdate='IsUpdate';
        String isDelete='IsDelete';
        String isInsert='IsInsert';
        Boolean isValidUpdate=False;
        Boolean isValidDelete=False;
        Boolean isValidInsert=False; 
        Set<String> typeSet = new Set<String>();
        Set<String> formatSet = new Set<String>();
        List<String> typelst = new List<String>();
        String sapTaxCode = 'NQ';
        Boolean mixedTypeParts = false ;

        
        try{
            prdList =[SELECT Hub_Id__c, name,alternateName__c,Product_Type_Author_Facing__c,inLanguage__c,version__c,doi__c,ean__c,issn__c,id,Description,Product_Publisher__c,
                      CreatedDate,LastModifiedDate,copyrightyear__c,Lead_Author_Editor__c,Category__c,Keywords__c, Contributors__c,toLabel(Sales_Channels__c),
                      toLabel(Applicable_Channels__c),toLabel(Applicable_License_Types__c),toLabel(Applicable_Customer_Types__c),originalProductId__c,Product_Category__c,Collection_updatedFrom__c ,
                      Collection_updatedTo__c,Collection_Valid_From__c ,Collection_Valid_To__c,BusinessId__c,Business_Id_Calc__c,Collection_Banner_Image_S3_location__c,Collection_Cover_Image_S3_location__c,
                      Collection_Banner_Image_Size__c,Collection_Cover_Image_Size__c,Abstract__c,Subject_Classifications__c, Product_Type__c, Collection_Subject_Area__c, Collection_Auto_Rollover__c, DiscountedPercentage__c,
                      Backlist__c
                      FROM Product2 where id=:bundleId                      
                     ];
            
            if(!prdList.isEmpty()){
                prd = prdList[0];
            }
            
            if(prd.originalProductId__c!=NULL){
                originalPrdList=[SELECT Hub_Id__c, name, CreatedDate,LastModifiedDate from product2 where id=:prd.originalProductId__c];
            }
            if(listofLineItems == null || (listofLineItems != null && listofLineItems.isEmpty())){
                listofLineItems = new list< Bundle_Line_Item__c>();
                for(List<Bundle_Line_Item__c> lineItems : Database.Query('SELECT id,name,Title__c,Content_ID__c,uuid__c, Open_access__c, Type__c, Source__c,mediaType__c, Content_Position__c,lineItemActualStatus__c  FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c =:bundleId and uuid__c != null and lineItemStatus__c != :isDelete ORDER BY Content_Position__c limit 50000')){
                    listofLineItems.addAll(lineItems);
                }
            }
            
            
            List<Pricebookentry> lstpbe = getPriceBookEntry(bundleId);
            List<Pricebookentry> disCountedLstpbe = getDiscountedPriceBookEntry(bundleId);
            
            //generating JSON
            JSONGenerator gen = JSON.createGenerator(true);
            
            gen.writeStartObject();
            gen.writeStringField('apiVersion','4.0.1'); 
            gen.writeStringField('action','save'); 
            gen.writeFieldName('product');
            gen.writeStartObject();
            
            gen.writeStringField('_id',prd.Hub_Id__c==null ? '': prd.Hub_Id__c); 
            
            gen.writeStringField('type','collection'); 
            if(prd.Product_Type__c!=null){
            gen.writeStringField('subType',prd.Product_Type__c==null ? '' : prd.Product_Type__c); 
             }
            //Identifiers
            gen.writeFieldName('identifiers');
            gen.writeStartObject();
            gen.writeFieldName('doi'); 
            gen.writeString(prd.doi__c==null ? '' : prd.doi__c);
            gen.writeFieldName('sku'); 
            gen.writeString(prd.id==null ? '' : prd.id);
            gen.writeFieldName('collectionId'); 
            gen.writeString(prd.Business_Id_Calc__c==null ? '' :prd.Business_Id_Calc__c);
            gen.writeEndObject();
            
            //gen.writeStringField('version',prd.version__c==null ? '' : prd.version__c);
            gen.writeStringField('_schemaVersion','4.0.1');
            //gen.writeStringField('_schemaVersion',prd.version__c==null ? '' : prd.version__c);
            gen.writeStringField('title',prd.name==null ? '' : prd.name);
            //Sources
            gen.writeFieldName('_source');
            gen.writeStartObject();
            gen.writeFieldName('type'); 
            gen.writeString('product');
            gen.writeFieldName('source'); 
            gen.writeString('SALESFORCE');
            gen.writeEndObject(); 
            
            
            gen.writeFieldName('categories');
            gen.writeStartArray();
            gen.writeStartObject();
            gen.writeFieldName('code'); 
            gen.writeString('');
            gen.writeFieldName('name'); 
            gen.writeString('collection-type');
            gen.writeFieldName('type'); 
            gen.writeString(prd.Product_Category__c==null ? '' : prd.Product_Category__c.toLowerCase());
            gen.writeEndObject();
            
            gen.writeStartObject();
            gen.writeFieldName('code'); 
            gen.writeString('');
            gen.writeFieldName('name'); 
            gen.writeString('collection-update-type');
            gen.writeFieldName('type'); 
            if(prd.Product_Type_Author_Facing__c=='Manual Curation'){
                gen.writeString('static');
            }else if(prd.Product_Type_Author_Facing__c=='Rule based'){
                gen.writeString('dynamic');
            }
            
            gen.writeEndObject();
            gen.writeEndArray();
            
            gen.writeFieldName('classifications');
            gen.writeStartArray();
            if(prd.Subject_Classifications__c!=null){
            List<String> lstClassifications = prd.Subject_Classifications__c.split(',');
        for (String cls : lstClassifications) {
            gen.writeStartObject();
            gen.writeStringField('group','');
            gen.writeStringField('code',cls);
            gen.writeStringField('name','');
            gen.writeStringField('type','subject');
            gen.writeEndObject();
        }
                }
            gen.writeEndArray();
            
            //keywords
            
            String keywords = prd.Keywords__c;
            List<Keywords> keywordsLst = new List<Keywords>();    
            
            if(keywords != null){
                keywordsLst = ( List<Keywords>) JSON.deserialize(keywords,  List<Keywords>.class);
            }
            
            if(keywordsLst != null && keywordsLst.size() > 0){
                gen.writeFieldName('keywords');
                gen.writeStartArray();
                for(Keywords keyword : keywordsLst){
                    gen.writeStartObject();
                    gen.writeStringField('type','catchword');
                    gen.writeStringField('name',keyword.name==null ? '' : keyword.name);
                    gen.writeFieldName('position');
                    gen.writeNumber(keyword.position); 
                    //gen.writeStringField('weightage',''); 
                    gen.writeEndObject(); 
                }
                gen.writeEndArray(); 
            }
            //end of keywords
            
            //contributors
            String contributors = prd.Contributors__c;
            List<Contributors> contributorsLst = new List<Contributors>(); 
            if(contributors != null){
                contributorsLst = (List<Contributors>) JSON.deserialize(contributors, List<Contributors>.class);
            }
            
            if(contributorsLst != null && contributorsLst.size() > 0){
                gen.writeFieldName('contributors');
                gen.writeStartArray();
                for(Contributors contributor : contributorsLst){
                    gen.writeStartObject();
                    gen.writeFieldName('roles');
                    gen.writeStartArray();
                    gen.writeString(contributor.role);
                    gen.writeEndArray();
                    gen.writeStringField('givenName',contributor.givenName==null ? '' : contributor.givenName);
                    gen.writeStringField('familyName',contributor.familyName==null ? '' : contributor.familyName);
                    gen.writeStringField('fullName',contributor.name==null ? '' : contributor.name);
                    gen.writeNumberField('position', contributor.position==null ? 0 :contributor.position);
                    
                    gen.writeEndObject();
                }
                gen.writeEndArray();
                
                
            }
            // end of contributors
            
            // Prices
            gen.writeFieldName('prices');
            gen.writeStartArray();
            
            for (PricebookEntry pbe : lstPbe) {
                
                gen.writeStartObject();
                for (PricebookEntry disPbe : disCountedLstpbe){
                    if(disPbe.CurrencyIsoCode==pbe.CurrencyIsoCode){
                gen.writeFieldName('price'); 
                gen.writeNumber(disPbe.UnitPrice==null ? 0.00  : disPbe.UnitPrice);
                        }
                    }
                gen.writeFieldName('currency'); 
                gen.writeString(pbe.CurrencyIsoCode==null ? '' : pbe.CurrencyIsoCode); 
                gen.writeDateTimeField('validFrom',pbe.CreatedDate); 
                gen.writeStringField('priceType','BYO Library Price'); 
                gen.writeStringField('priceTypeCode','BYO'); 
                gen.writeFieldName('discountPercentage');
                gen.writeNumber(prd.DiscountedPercentage__c==null ? 0.00  : prd.DiscountedPercentage__c);
                gen.writeFieldName('listPrice'); 
                gen.writeNumber(pbe.UnitPrice==null ? 0.00  : pbe.UnitPrice);
                gen.writeEndObject();
                
            }
            gen.writeEndArray();
            // end of Price
            //permissions
            gen.writeFieldName('permissions');
            gen.writeStartArray();
            gen.writeEndArray();
            gen.writeFieldName('associatedMedia');
            gen.writeStartArray();
            if(prd.Collection_Banner_Image_Size__c!=null && prd.Collection_Banner_Image_S3_location__c!=null){
                gen.writeStartObject();
                gen.writeStringField('_id','');   
                gen.writeStringField('type','bannerimage');
                gen.writeFieldName('size'); 
                gen.writeNumber(Integer.valueof(prd.Collection_Banner_Image_Size__c));
                gen.writeStringField('location',prd.Collection_Banner_Image_S3_location__c);
                gen.writeEndObject(); 
            }
            
            if(prd.Collection_Cover_Image_Size__c!=null && prd.Collection_Cover_Image_S3_location__c!=null){
                gen.writeStartObject();
                gen.writeStringField('type','coverimage');
                gen.writeFieldName('size'); 
                gen.writeNumber(Integer.valueof(prd.Collection_Cover_Image_Size__c));
                gen.writeStringField('location',prd.Collection_Cover_Image_S3_location__c);
                gen.writeEndObject();
            }
            
            
            gen.writeEndArray();
            
                        set<String> typeUpperC =  new set<String>();
            //partsUpdated
            if(prd.originalProductId__c!=NULL){
                gen.writeFieldName('partsUpdated');
                gen.writeStartArray(); 
                if(listofLineItems.size()>0) {
                    Integer IntPos=1;
                    for (Bundle_Line_Item__c bundlehasUpdatePart : listofLineItems) {           
                        gen.writeStartObject();
                        gen.writeFieldName('type'); 
                        gen.writeString(bundlehasUpdatePart.Type__c==null ? '' : bundlehasUpdatePart.Type__c);
                        typeSet.add(bundlehasUpdatePart.Type__c);
                        if((bundlehasUpdatePart.Type__c).toUpperCase() == 'BOOK'){
                             typeUpperC.add((bundlehasUpdatePart.mediaType__c).toUpperCase());
                        }else{
                            typeUpperC.add((bundlehasUpdatePart.Type__c).toUpperCase());
                        }
                        gen.writeFieldName('identifier'); 
                        gen.writeString(bundlehasUpdatePart.uuid__c==null ? '' : bundlehasUpdatePart.uuid__c);
                        gen.writeFieldName('isFree'); 
                        gen.writeBoolean(bundlehasUpdatePart.Open_access__c);
                        // gen.writeNumberField('position',bundlehasUpdatePart.Content_Position__c);
                        gen.writeNumberField('position',IntPos);
                        gen.writeEndObject();  
                        IntPos++;
                    }
                    
                }
                
                gen.writeEndArray();      
            }  
            //partsAdded
            if(prd.originalProductId__c==NULL){
                gen.writeFieldName('partsAdded');
                gen.writeStartArray();
                if(listofLineItems.size()>0) {
                    Integer IntPos=1;
                    for (Bundle_Line_Item__c bundlehaspart : listofLineItems) {           
                        gen.writeStartObject();
                        gen.writeFieldName('type'); 
                        gen.writeString(bundlehaspart.Type__c==null ? '' : bundlehaspart.Type__c);
                        typeSet.add(bundlehaspart.Type__c);
                        if((bundlehaspart.Type__c).toUpperCase() == 'BOOK'){
                            typeUpperC.add((bundlehaspart.mediaType__c).toUpperCase());
                        }else{
                            typeUpperC.add((bundlehaspart.Type__c).toUpperCase());
                        }                        
                        gen.writeFieldName('identifier'); 
                        gen.writeString(bundlehaspart.uuid__c==null ? '' : bundlehaspart.uuid__c);
                        gen.writeFieldName('isFree'); 
                        gen.writeBoolean(bundlehaspart.Open_access__c);
                        //gen.writeNumberField('position',bundlehaspart.Content_Position__c);
                        gen.writeNumberField('position',IntPos);
                        gen.writeEndObject();  
                        IntPos++;
                    }
                }
                gen.writeEndArray();   
            }
            
            // Sap tax code
            
            if(typeUpperC.size() == 1 && typeUpperC.contains('E-BOOK')){
                sapTaxCode = 'Q';
            }else if(typeUpperC.size() > 0){
                mixedTypeParts = true ;
            }
            

            //partsRemoved
            /* gen.writeFieldName('partsRemoved');
gen.writeStartArray();   
if(listofLineItemsForDelete.size()>0) {
for (Bundle_Line_Item__c bundlehasDeletePart : listofLineItemsForDelete) {           
gen.writeStartObject();
gen.writeFieldName('type'); 
gen.writeString(bundlehasDeletePart.Type__c==null ? '' : bundlehasDeletePart.Type__c);
gen.writeFieldName('identifier'); 
gen.writeString(bundlehasDeletePart.uuid__c==null ? '' : bundlehasDeletePart.uuid__c);
gen.writeFieldName('isFree'); 
gen.writeBoolean(bundlehasDeletePart.Open_access__c);
//gen.writeNumberField('position',bundlehasDeletePart.Content_Position__c);

gen.writeEndObject();  

}

}
gen.writeEndArray();  */
            
            
            //Availability object declarations
            
            ruleObj rObjBEGIN = new ruleObj();
            rObjBEGIN.type = 'separator';
            ruleObj rObjEND = new ruleObj();
            rObjEND.type = 'separator';
            ruleObj rObjAND = new ruleObj();
            rObjAND.type = 'logical';
            ruleObjVal rObjName = new ruleObjVal();
            rObjName.type = 'criteria';
            ruleObjVals rObjStatus = new ruleObjVals();
            rObjStatus.type = 'criteria';
            
            rule rBEGIN = new rule();
            rBEGIN.value = 'BEGIN';
            rObjBEGIN.rule = rBEGIN;
            
            
            rule rEND =  new rule();
            rEND.value = 'END';
            rObjEND.rule = rEND;
            
            rule rAND = new rule() ;
            rAND.value = 'AND';
            rObjAND.rule = rAND;
            
            ruleVal rName = new ruleVal() ;
            rName.attribute = 'availability.name';
            rName.relationship = 'EQ';
            rObjName.rule = rName;
            
            
            ruleVals rStatus = new ruleVals() ;
            rStatus.attribute = 'availability.status';
            rObjStatus.rule = rStatus;
            
            //
            //Rulelist
            if(prd.Product_Type_Author_Facing__c=='Rule based'){
                
                AvailabilityDetails availabilityDetails = new AvailabilityDetails();
                availabilityDetails= calculateAvailability('Collections',bundleId);
                availabilityTypeMap = availabilityDetails.availabilityTypeMap;
                
                gen.writeFieldName('rulesList');
                gen.writeStartArray(); 
                if(multiTypeRules!=null){
                    
                    for (TF_PPDProcessController.MultiTypeRules multiRuleEle : multiTypeRules) { 
                        
                        gen.writeStartObject();        
                        gen.writeStringField('type',multiRuleEle.productType != null ? multiRuleEle.productType : 'book'); 
                        typeSet.add((multiRuleEle.productType).toUpperCase());

                        gen.writeFieldName('rules');//intenal rules
                        gen.writeStartArray();//Start IR1 array
                        gen.writeStartObject();//Start IR1 Obj 
                        
                        gen.writeStringField('type','group');
                        gen.writeStringField('name','product');
                        
                        //Start of query rules
                        gen.writeFieldName('rules');
                        gen.writeStartArray();
                        
                        List<TF_PPDProcessController.RuleElement> ruleElementLst = new List<TF_PPDProcessController.RuleElement>();
                        ruleElementLst = multiRuleEle.ruleElementLst ;
                        Integer intPosition=1;
                        for (TF_PPDProcessController.RuleElement ruleEle : ruleElementLst) {
                           
                            gen.writeStartObject();
                            
                            gen.writeFieldName('type'); 
                            gen.writeString(ruleEle.type);
                            
                            gen.writeFieldName('rule');
                            gen.writeStartObject();
                            
                            if(ruleEle.type == 'separator'){                        
                                gen.writeFieldName('value'); 
                                gen.writeString(ruleEle.value);
                            }
                            
                            if(ruleEle.type == 'criteria'){
                                 if((multiRuleEle.productType).toUpperCase() == 'BOOK' && ruleEle.attribute == 'book.format'){
                                formatSet.add((ruleEle.value).toUpperCase());
                            }
                                gen.writeFieldName('attribute'); 
                                gen.writeString(ruleEle.attribute);
                                
                                gen.writeFieldName('relationship'); 
                                gen.writeString(ruleEle.relationship);
                                
                                if(ruleEle.relationship == 'IN' || ruleEle.relationship == 'NI'){
                                    List<String> valueList = new  List<String>();
                                    String valueStr = ruleEle.value ;
                                    valueStr=valueStr.replace('\n', ',');
                                    valueList = valueStr.split(',');
                                    gen.writeFieldName('values'); 
                                    gen.writeObject(valueList);
                                }else{
                                    gen.writeFieldName('value'); 
                                    gen.writeString(ruleEle.value);
                                }
                            }                    
                            if(ruleEle.type == 'logical'){                        
                                gen.writeFieldName('value'); 
                                gen.writeString(ruleEle.value);
                            }                    
                            gen.writeEndObject();                    
                            gen.writeFieldName('position'); 
                            gen.writeNumber(intPosition);                    
                            gen.writeEndObject();                    
                            intPosition++;
                        }          
                        gen.writeEndArray();
                        //End of query rules
                        
                        gen.writeEndObject(); //End IR1 Obj
                        

                        allChannelLst.clear();
                        system.debug('availabilityTypeMap====='+ JSON.serialize(availabilityTypeMap));
                        channelAvailabilityMap = availabilityTypeMap.get(multiRuleEle.productType);
                        if(channelAvailabilityMap  != null && channelAvailabilityMap.size() > 0){
                            allChannelLst.addAll(channelAvailabilityMap.keySet());
                        }
                        system.debug('allChannelLst====='+ JSON.serialize(allChannelLst));
                        
                        if(allChannelLst != null && allChannelLst.size() > 0){
                            
                            gen.writeStartObject();//Start IR2 Obj
                            
                            gen.writeStringField('type','group');
                            gen.writeStringField('name','availability');
                            
                            gen.writeFieldName('rules');
                            gen.writeStartArray();//availability rules arr start
                            
                            
                            gen.writeObject(rObjBEGIN);
                            
                            Integer loopCount = 0;
                            for(String channelName : allChannelLst){
                                
                                gen.writeObject(rObjBEGIN);
                                
                                rName.value = channelName; 
                                gen.writeObject(rObjName);
                                
                                gen.writeObject(rObjAND);
                                
                                
                                List<Setting_Item__c> settingItmLst = new  List<Setting_Item__c>();
                                settingItmLst = channelAvailabilityMap.get(channelName);
                                String statusOpe = settingItmLst[0].Text_4__c;
                                
                                List<String> statusLst = new List<String>();
                                Set<String> statusSet = new Set<String>();
                                for(Setting_Item__c itm :settingItmLst){
                                    if(itm.Text_3__c != null){
                                        statusLst.addAll(itm.Text_3__c.split(','));
                                        statusSet.addAll(statusLst);
                                        statusLst.clear();
                                        statusLst.addAll(statusSet);
                                    }
                                }
                                
                                rStatus.relationship = statusOpe;
                                rStatus.values = statusLst;
                                
                                gen.writeObject(rObjStatus);
                                
                                gen.writeObject(rObjEND);
                                
                                loopCount++;
                                
                                if(loopCount < allChannelLst.size()){
                                    gen.writeObject(rObjAND);
                                }
                            }
                            
                            gen.writeObject(rObjEND);
                            
                            gen.writeEndArray();//availability rules arr End
                            gen.writeEndObject(); //End IR2 Obj 
                        }
                        gen.writeEndArray();//End IR1 array
                        
                        gen.writeEndObject();
                        //break;
                        
                    }//End of loop
                    
                }
                gen.writeEndArray();// end rulesList
            }
            else if(prd.Product_Type_Author_Facing__c=='Manual Curation'){
                
                AvailabilityDetails availabilityDetails = new AvailabilityDetails();
                availabilityDetails= calculateAvailability('Collections',bundleId);
                availabilityTypeMap = availabilityDetails.availabilityTypeMap;
                typeLst.addAll(typeSet);
                 
                gen.writeFieldName('rulesList');
                gen.writeStartArray();
                
                for (String typ : typeLst) {  
                     allChannelLst.clear();
                    system.debug('availabilityTypeMap====='+ JSON.serialize(availabilityTypeMap));
                    channelAvailabilityMap = availabilityTypeMap.get(typ);
                    if(channelAvailabilityMap  != null && channelAvailabilityMap.size() > 0){
                        allChannelLst.addAll(channelAvailabilityMap.keySet());
                    }
                    
                    if(allChannelLst != null && allChannelLst.size() > 0){
                        gen.writeStartObject();        
                        gen.writeStringField('type',typ); 
                        
                        gen.writeFieldName('rules');//intenal rules
                        gen.writeStartArray();//Start IR1 array                
                        
                        
                        system.debug('allChannelLst====='+ JSON.serialize(allChannelLst));

                        
                        gen.writeStartObject();//Start IR2 Obj
                        
                        gen.writeStringField('type','group');
                        gen.writeStringField('name','availability');
                        
                        gen.writeFieldName('rules');
                        gen.writeStartArray();//availability rules arr start
                        
                        
                        gen.writeObject(rObjBEGIN);
                        
                        Integer loopCount = 0;
                        for(String channelName : allChannelLst){
                            
                            gen.writeObject(rObjBEGIN);
                            
                            rName.value = channelName; 
                            gen.writeObject(rObjName);
                            
                            gen.writeObject(rObjAND);
                            
                            
                            List<Setting_Item__c> settingItmLst = new  List<Setting_Item__c>();
                            settingItmLst = channelAvailabilityMap.get(channelName);
                            String statusOpe = settingItmLst[0].Text_4__c;
                            
                            List<String> statusLst = new List<String>();
                            Set<String> statusSet = new Set<String>();
                            for(Setting_Item__c itm :settingItmLst){
                                if(itm.Text_3__c != null){
                                    statusLst.addAll(itm.Text_3__c.split(','));
                                    statusSet.addAll(statusLst);
                                    statusLst.clear();
                                    statusLst.addAll(statusSet);
                                }
                            }
                            
                            rStatus.relationship = statusOpe;
                            rStatus.values = statusLst;
                            
                            gen.writeObject(rObjStatus);
                            
                            gen.writeObject(rObjEND);
                            
                            loopCount++;
                            
                            if(loopCount < allChannelLst.size()){
                                gen.writeObject(rObjAND);
                            }
                        }
                        
                        gen.writeObject(rObjEND);
                        
                        gen.writeEndArray();//availability rules arr End
                        gen.writeEndObject(); //End IR2 Obj 
                    gen.writeEndArray();//End IR1 array
                    
                    gen.writeEndObject();
                    //break;
                    }
                }
                gen.writeEndArray();
                
            }
            
            if(typeSet.size() == 1 && typeSet.contains('BOOK') && formatSet.size() == 1 && formatSet.contains('E-BOOK') && ! mixedTypeParts){
                sapTaxCode = 'Q';
            }
            
                        //collection
            gen.writeFieldName('collection');
            gen.writeStartObject();
            gen.writeStringField('subtitle','');
            gen.writeStringField('description',prd.Description==null ? '' : prd.Description);
            gen.writeStringField('status','planned');
            gen.writeDateTimeField('plannedPublicationDate',prd.Collection_Valid_From__c); 
            gen.writeStringField('publisherImprint',prd.Product_Publisher__c==null ? '' : prd.Product_Publisher__c);
            gen.writeNumberField('firstPublishedYear',Integer.valueOf(prd.copyrightyear__c));
           // gen.writeStringField('inLanguage','eng');
             
            if(prd.Collection_Valid_From__c !=null){
                gen.writeDateTimeField('validFrom',prd.Collection_Valid_From__c );
            }
            if(prd.Collection_Valid_To__c!=null){
                gen.writeDateTimeField('validTo',prd.Collection_Valid_To__c );
            }
            gen.writeStringField('taxType',sapTaxCode);
            gen.writeStringField('subjectAreaCode',prd.Collection_Subject_Area__c);
            gen.writeFieldName('autoRollover'); 
            gen.writeBoolean(prd.Collection_Auto_Rollover__c);
            gen.writeFieldName('backList');
            gen.writeBoolean(prd.Backlist__c);
             
            
            //abstract
            gen.writeFieldName('abstracts');
            gen.writeStartArray();
            gen.writeStartObject();
            gen.writeStringField('type','text');
            gen.writeStringField('value',prd.Abstract__c==null ? '' : prd.Abstract__c);
            gen.writeEndObject(); 
            gen.writeEndArray();   
            //Channels
            gen.writeFieldName('channels');
            gen.writeStartArray();
            if(String.isNotBlank(prd.Sales_Channels__c)){
                List<String> lstSalesChannels = prd.Sales_Channels__c.split(';');
                If( lstSalesChannels.contains('All')){
                    lstSalesChannels.clear();
                    lstSalesChannels.add('All');
                }
                for (String strSalesChannel : lstSalesChannels) {           
                    
                    gen.writeStartObject();
                    gen.writeFieldName('name'); 
                    gen.writeString(strSalesChannel);
                    gen.writeFieldName('type'); 
                    gen.writeString('sales');
                    gen.writeEndObject();       
                }
            }    
            // delivery channels 
            if(String.isNotBlank(prd.Applicable_Channels__c)){
                List<String> lstdeliveryChannels = prd.Applicable_Channels__c.split(';');
                If( lstdeliveryChannels.contains('All')){
                    lstdeliveryChannels.clear();
                    lstdeliveryChannels.add('All');
                }
                for (String strdeliveryChannel : lstdeliveryChannels) {           
                    
                    gen.writeStartObject();
                    gen.writeFieldName('name'); 
                    gen.writeString(strdeliveryChannel);  
                    gen.writeFieldName('type'); 
                    gen.writeString('delivery');
                    gen.writeEndObject();       
                }
            }
            
            gen.writeEndArray();   
            
            //licenses
            gen.writeFieldName('licenses');
            gen.writeStartArray();
            if(String.isNotBlank(prd.Applicable_License_Types__c)){
                List<String> lstbusinessModels = prd.Applicable_License_Types__c.split(';');
                If( lstbusinessModels.contains('All')){
                    lstbusinessModels.clear();
                    lstbusinessModels.add('All');
                }
                for (String strbusinessModel : lstbusinessModels) {           
                    
                    gen.writeStartObject();
                    gen.writeFieldName('name'); 
                    gen.writeString(strbusinessModel);   
                    gen.writeFieldName('type'); 
                    gen.writeString('license');
                    gen.writeEndObject();       
                }
            }
            
            gen.writeEndArray();  
            
            //Customers
            gen.writeFieldName('customers');
            gen.writeStartArray();
            if(String.isNotBlank(prd.Applicable_Customer_Types__c)){
                List<String> lstcustomerTypes = prd.Applicable_Customer_Types__c.split(';');
                If( lstcustomerTypes.contains('All')){
                    lstcustomerTypes.clear();
                    lstcustomerTypes.add('All');
                }
                for (String strcustomerType : lstcustomerTypes) {           
                    
                    gen.writeStartObject();
                    gen.writeFieldName('name'); 
                    gen.writeString(strcustomerType); 
                    gen.writeFieldName('type'); 
                    gen.writeString('customer');
                    gen.writeEndObject();       
                }
            }    
            gen.writeEndArray();    
            if(prd.Product_Type_Author_Facing__c=='Rule based'){
                if((prd.Collection_updatedFrom__c!=null)&&(prd.Collection_updatedTo__c!=null)){
                    gen.writeDateTimeField('ruleUpdateStartDate',prd.Collection_updatedFrom__c  ==null ? null :prd.Collection_updatedFrom__c);    
                    gen.writeDateTimeField('ruleUpdateEndDate',prd.Collection_updatedTo__c ==null ? null : prd.Collection_updatedTo__c);    
                }              
            }
            
            gen.writeEndObject();
            //End of collection
            gen.writeEndObject();//Product Object End
            //first object end
            gen.writeEndObject();
            jsonString = gen.getAsString();
            System.debug('commonJsonString:'+jsonString);   
            
        }
        catch(Exception ex){
            System.debug('Exception:'+ex.getMessage());
            System.debug('Exception:'+ex.getLineNumber());
            System.debug('Exception:'+ex.getStackTraceString());
        }
        
        Return jsonString;
    }
    
     
    @AuraEnabled 
    public static String GenerateDownloadSearchJson(String bundleId, String type , List<TF_PPDProcessController.MultiTypeRules> multiTypeRules, Integer offsetValue, Integer limitValue, String consumer) { 
      
         List<DotNotation> DotNotationLst = new List<DotNotation>(); 
        DotNotation dotNot = new DotNotation();
        Map<String, SearchQueryDotNotations__c> dotNotationMap = new Map<String, SearchQueryDotNotations__c>();
        dotNotationMap = SearchQueryDotNotations__c.getAll();
        string jsonstrdotNotation = JSON.serialize(dotNotationMap);
        system.debug('jsonstrdotNotation###' + jsonstrdotNotation);
        List<SearchQueryDotNotations__c> strDotNotations = new List<SearchQueryDotNotations__c>();
        List<Setting_Item__c> settingItemLst = new List<Setting_Item__c>();
        Map<String,List<Setting_Item__c>> settingItemLstMap = new Map<String,List<Setting_Item__c>>();
        String fileName='';
        List<Product2> prdLst = new List<Product2>();
        Product2 prd = new Product2();
        List<String> salesChannelLst = new List<String>();
        List<String> deliveryChannelLst = new List<String>();
        List<String> allChannelLst = new List<String>();
        Map<String,List<Setting_Item__c>> channelAvailabilityMap = new  Map<String,List<Setting_Item__c>>();
        Map<String,List<Setting_Item__c>> channelAvailabilityTypMap = new  Map<String,List<Setting_Item__c>>();
        Map<String,Map<String,List<Setting_Item__c>>> availabilityTypeMap = new  Map<String,Map<String,List<Setting_Item__c>>>();
        String salesChannels = null;
        String deliveryChannels = null;
         User u = [select Id, username,name,email from User where Id = :UserInfo.getUserId()];
        String mailAddress=u.email;
        if(consumer=='Collections'){
        Product2 prds=[select id,name, Business_Id_Calc__c from product2 where id=:bundleId];
        fileName=prds.Business_Id_Calc__c + '-'+ Datetime.now().format('yyyy-MM-dd\'_\'HH-mm-ss'); 
        }else if(consumer=='OPC_External'){
        fileName='SearchResults' + '-'+ Datetime.now().format('yyyy-MM-dd\'_\'HH-mm-ss');
        }
        strDotNotations=[select DotNotation__c from SearchQueryDotNotations__c where type__c=:type OR type__c='Common'];
        
        
        try{
            JSONGenerator gen = JSON.createGenerator(true);            
            gen.writeStartObject();         
            
            gen.writeStringField('apiVersion','4.0.1'); 
            gen.writeStringField('action','download'); 
            
            gen.writeFieldName('recipients');
            gen.writeStartObject(); 
            gen.writeFieldName('to');
            gen.writeStartArray();    
            gen.writeString(mailAddress); 
            gen.writeEndArray();
            gen.writeFieldName('cc');
            gen.writeStartArray();    
            //gen.writeString('chetan.bhatla@tandfindia.com'); 
            gen.writeEndArray();
            
            
              gen.writeEndObject(); 
            
            gen.writeStringField('fileName',fileName);        
            
            gen.writeFieldName('rulesList');
            
            gen.writeStartArray();
            
            for (TF_PPDProcessController.MultiTypeRules multiRuleEle : multiTypeRules) { 
                //if(type!=multiRuleEle.productType){
                   // continue;
                //}
                gen.writeStartObject();        
                gen.writeStringField('type',multiRuleEle.productType != null ? multiRuleEle.productType : 'book'); 
                
                gen.writeFieldName('rules');//intenal rules
                gen.writeStartArray();//Start IR1 array
                gen.writeStartObject();//Start IR1 Obj 
                
                gen.writeStringField('type','group');
                gen.writeStringField('name','product');
                
                //Start of query rules
                gen.writeFieldName('rules');
                gen.writeStartArray();
                
                List<TF_PPDProcessController.RuleElement> ruleElementLst = new List<TF_PPDProcessController.RuleElement>();
                ruleElementLst = multiRuleEle.ruleElementLst ;
                Integer intPosition=1;
                for (TF_PPDProcessController.RuleElement ruleEle : ruleElementLst) {                      
                    gen.writeStartObject();
                    
                    gen.writeFieldName('type'); 
                    gen.writeString(ruleEle.type);
                    
                    gen.writeFieldName('rule');
                    gen.writeStartObject();
                    
                    if(ruleEle.type == 'separator'){                        
                        gen.writeFieldName('value'); 
                        gen.writeString(ruleEle.value);
                    }
                    
                    if(ruleEle.type == 'criteria'){
                        
                        gen.writeFieldName('attribute'); 
                        gen.writeString(ruleEle.attribute);
                        
                        gen.writeFieldName('relationship'); 
                        gen.writeString(ruleEle.relationship);
                        
                        if(ruleEle.relationship == 'IN' || ruleEle.relationship == 'NI'){
                            List<String> valueList = new  List<String>();
                            String valueStr = ruleEle.value ;
                            valueStr=valueStr.replace('\n', ',');
                            valueList = valueStr.split(',');
                            gen.writeFieldName('values'); 
                            gen.writeObject(valueList);
                        }else{
                            gen.writeFieldName('value'); 
                            gen.writeString(ruleEle.value);
                        }
                    }                    
                    if(ruleEle.type == 'logical'){                        
                        gen.writeFieldName('value'); 
                        gen.writeString(ruleEle.value);
                    }                    
                    gen.writeEndObject();                    
                    gen.writeFieldName('position'); 
                    gen.writeNumber(intPosition);                    
                    gen.writeEndObject();                    
                    intPosition++;
                }          
                gen.writeEndArray();
                //End of query rules
                
                gen.writeEndObject(); //End IR1 Obj
                
                //Availability object declarations
                
                ruleObj rObjBEGIN = new ruleObj();
                rObjBEGIN.type = 'separator';
                ruleObj rObjEND = new ruleObj();
                rObjEND.type = 'separator';
                ruleObj rObjAND = new ruleObj();
                rObjAND.type = 'logical';
                ruleObjVal rObjName = new ruleObjVal();
                rObjName.type = 'criteria';
                ruleObjVals rObjStatus = new ruleObjVals();
                rObjStatus.type = 'criteria';
                
                rule rBEGIN = new rule();
                rBEGIN.value = 'BEGIN';
                rObjBEGIN.rule = rBEGIN;
                
                
                rule rEND =  new rule();
                rEND.value = 'END';
                rObjEND.rule = rEND;
                
                rule rAND = new rule() ;
                rAND.value = 'AND';
                rObjAND.rule = rAND;
                
                ruleVal rName = new ruleVal() ;
                rName.attribute = 'availability.name';
                rName.relationship = 'EQ';
                rObjName.rule = rName;
                
                
                ruleVals rStatus = new ruleVals() ;
                rStatus.attribute = 'availability.status';
                rObjStatus.rule = rStatus;
                
                if(consumer != 'Collections'){
                    AvailabilityDetails availabilityDetails = new AvailabilityDetails();
                    availabilityDetails= calculateAvailability(consumer,bundleId);
                    settingItemLstMap = availabilityDetails.settingItemLstMap;
                    
                    if(settingItemLstMap != null && settingItemLstMap.size() > 0 &&  settingItemLstMap.get(multiRuleEle.productType) != null){
                        List<Setting_Item__c> settingItemTypeLst = new List<Setting_Item__c>();
                        settingItemTypeLst = settingItemLstMap.get(multiRuleEle.productType);
                        
                        if(settingItemTypeLst != null && settingItemTypeLst.size() > 0){
                            gen.writeStartObject();//Start IR2 Obj
                            
                            gen.writeStringField('type','group');
                            gen.writeStringField('name','availability');
                            
                            gen.writeFieldName('rules');
                            gen.writeStartArray();//availability rules arr start
                            
                            
                            gen.writeObject(rObjBEGIN);
                            
                            Integer loopCount = 0;
                            for(Setting_Item__c setItm : settingItemTypeLst){
                                
                                gen.writeObject(rObjBEGIN);
                                
                                rName.value = setItm.Text_2__c; 
                                gen.writeObject(rObjName);
                                
                                gen.writeObject(rObjAND);
                                
                                rStatus.relationship = setItm.Text_4__c;
                                
                                String status = '';
                                status = setItm.Text_3__c;
                                if(status != null){
                                    List<String> statusLst = new List<String>();
                                    statusLst = status.split(',');
                                    rStatus.values = statusLst;
                                }
                                
                                gen.writeObject(rObjStatus);
                                
                                gen.writeObject(rObjEND);
                                
                                loopCount++;
                                
                                if(loopCount < settingItemTypeLst.size()){
                                    gen.writeObject(rObjAND);
                                }
                            }
                            
                            gen.writeObject(rObjEND);
                            
                            gen.writeEndArray();//availability rules arr End
                            gen.writeEndObject(); //End IR2 Obj 
                        }
                    }
                }else{
                    AvailabilityDetails availabilityDetails = new AvailabilityDetails();
                    availabilityDetails= calculateAvailability(consumer,bundleId);
                    availabilityTypeMap = availabilityDetails.availabilityTypeMap;
                    
                    allChannelLst.clear();
                    system.debug('availabilityTypeMap====='+ JSON.serialize(availabilityTypeMap));
                    channelAvailabilityMap = availabilityTypeMap.get(multiRuleEle.productType);
                    if(channelAvailabilityMap  != null && channelAvailabilityMap.size() > 0){
                        allChannelLst.addAll(channelAvailabilityMap.keySet());
                    }
                    system.debug('allChannelLst====='+ JSON.serialize(allChannelLst));
                    
                    if(allChannelLst != null && allChannelLst.size() > 0){
                        
                        gen.writeStartObject();//Start IR2 Obj
                        
                        gen.writeStringField('type','group');
                        gen.writeStringField('name','availability');
                        
                        gen.writeFieldName('rules');
                        gen.writeStartArray();//availability rules arr start
                        
                        
                        gen.writeObject(rObjBEGIN);
                        
                        Integer loopCount = 0;
                        for(String channelName : allChannelLst){
                            
                            gen.writeObject(rObjBEGIN);
                            
                            rName.value = channelName; 
                            gen.writeObject(rObjName);
                            
                            gen.writeObject(rObjAND);
                            
                            
                            List<Setting_Item__c> settingItmLst = new  List<Setting_Item__c>();
                            settingItmLst = channelAvailabilityMap.get(channelName);
                            String statusOpe = settingItmLst[0].Text_4__c;
                            
                            List<String> statusLst = new List<String>();
                            Set<String> statusSet = new Set<String>();
                            for(Setting_Item__c itm :settingItmLst){
                                if(itm.Text_3__c != null){
                                    statusLst.addAll(itm.Text_3__c.split(','));
                                    statusSet.addAll(statusLst);
                                    statusLst.clear();
                                    statusLst.addAll(statusSet);
                                }
                            }
                            
                            rStatus.relationship = statusOpe;
                            rStatus.values = statusLst;
                            
                            gen.writeObject(rObjStatus);
                            
                            gen.writeObject(rObjEND);
                            
                            loopCount++;
                            
                            if(loopCount < allChannelLst.size()){
                                gen.writeObject(rObjAND);
                            }
                        }
                        
                        gen.writeObject(rObjEND);
                        
                        gen.writeEndArray();//availability rules arr End
                        gen.writeEndObject(); //End IR2 Obj 
                    }
                }                
                gen.writeEndArray();//End IR1 array
                
                gen.writeEndObject();
                //break;
                
            }//End of loop
            gen.writeEndArray();// End of rulesList
            gen.writeEndObject();//first bracet closed           
            String jsonString = gen.getAsString();
            System.Debug('QueryPCMJSONString' + jsonString);
            return jsonString ;
        }catch(Exception e){
            System.debug('QueryPCMJSON getStackTrace' + e.getStackTraceString());
            return null;
        }
        
    }
    
    
    @AuraEnabled
    public static String GenerateSkuUpdateJson(String bundleId){
        String jsonString = '';
        JSONGenerator gen = JSON.createGenerator(true);            
        gen.writeStartObject(); 
		gen.writeFieldName('apiVersion'); 
        gen.writeString('4.0.1');        
        
        gen.writeFieldName('data');
        gen.writeStartArray();   
        gen.writeStartObject();
        gen.writeFieldName('op'); 
        gen.writeString('replace');
        
        gen.writeFieldName('path'); 
        gen.writeString('identifiers.sku');
        
        gen.writeFieldName('value'); 
        gen.writeString(bundleId);
        gen.writeEndObject();
        gen.writeEndArray();
        
        gen.writeEndObject();
        jsonString = gen.getAsString();
        return jsonString;
    }
	
	public static String GenerateSNSJsonRevAllcocation(Asset thisAsset, Order thisOrder) { 

        JSONGenerator gen = JSON.createGenerator(true);
        System.debug('thisAsset' + thisAsset);
        System.debug('thisOrder' + thisOrder);
        gen.writeStartObject();
        gen.writeStringField('orderType','SALES');    
        gen.writeStringField('channel','UBX'); 
        gen.writeStringField('customerId',thisAsset.TF_Customer_Id__c==null ? '' :thisAsset.TF_Customer_Id__c); 
        gen.writeStringField('orderNumber',thisAsset.TF_OMS_Order_Id__c ==null ? '' : thisAsset.TF_OMS_Order_Id__c); 
        gen.writeStringField('orderDate',thisOrder.EffectiveDate==null ? '' : String.valueof(thisOrder.EffectiveDate));
        gen.writeStringField('orderPrice',thisOrder.Total_Price__c==null ? '' :String.valueOf(thisOrder.Total_Price__c));
        gen.writeStringField('productId',thisAsset.Product2Id ==null ? '' :thisAsset.Product2Id);
        gen.writeStringField('productType',thisAsset.TF_Product_Type__c == null ? '' :thisAsset.TF_Product_Type__c);
        gen.writeStringField('startDate',thisAsset.InstallDate == null ? '' :String.valueOf(thisAsset.InstallDate));
        gen.writeStringField('endDate',thisAsset.UsageEndDate == null ? '' :String.valueOf(thisAsset.UsageEndDate));
        gen.writeStringField('licenseId',thisAsset.Id);
        gen.writeStringField('licenseType',thisAsset.TF_Business_Model__c);
        gen.writeStringField('licenseUpdateType',thisAsset.TF_License_Type__c);
        gen.writeStringField('licenseUpdateEndDate',thisAsset.TF_Subscription_End_Date__c == null ? '' :String.valueOf(thisAsset.TF_Subscription_End_Date__c));
        
        gen.writeEndObject();
       

        String jsonString = gen.getAsString();
        System.debug('jsonCommonModelString:'+jsonString);
        Return jsonString;

	}
	
	public static String GenerateCommonModelJsonBespokeLMS(String bundleId, list< Bundle_Line_Item__c> listofLineItems,List<TF_PPDProcessController.MultiTypeRules> multiTypeRules) { //SFAL-229 Vikas Varshney
        String jsonString;
        List<Product2> prdList =new List<Product2>();
        Product2 originalPrdList =new Product2();
        Product2 prd =new Product2();
        list< Bundle_Line_Item__c> listofLineItemsForUpdate = new list< Bundle_Line_Item__c>();
        list< Bundle_Line_Item__c> listofLineItemsForDelete = new list< Bundle_Line_Item__c>();
        Map<String,String> typeMap = new Map<String,String>();
        Map<String,Map<String,List<Setting_Item__c>>> availabilityTypeMap = new  Map<String,Map<String,List<Setting_Item__c>>>();
        Map<String,List<Setting_Item__c>> channelAvailabilityMap = new  Map<String,List<Setting_Item__c>>();
        set<String> typeUpperC =  new set<String>();
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        String bespokeBusinessId = (String) orgSpecificProps.get('Bespoke_businessId__c');
        
        List<String> allChannelLst = new List<String>();
        typeMap.put('CHAPTER','Chapter');
        typeMap.put('SCHOLARLYARTICLE','ScholarlyArticle');
        typeMap.put('CREATIVEWORK','CreativeWork');
        typeMap.put('BOOK','Book');
        typeMap.put('COLLECTION','Collection');
        Integer i=0;
        String isUpdate='IsUpdate';
        String isDelete='IsDelete';
        String isInsert='IsInsert';
        Boolean isValidUpdate=False;
        Boolean isValidDelete=False;
        Boolean isValidInsert=False; 
        Set<String> typeSet = new Set<String>();
        Set<String> formatSet = new Set<String>();
        List<String> typelst = new List<String>();
        String sapTaxCode = 'NQ';
        Boolean mixedTypeParts = false ;

        
        try{
            prdList =[SELECT Hub_Id__c, name,alternateName__c,Product_Type_Author_Facing__c,inLanguage__c,version__c,doi__c,ean__c,issn__c,id,Description,Product_Publisher__c,
                      CreatedDate,LastModifiedDate,copyrightyear__c,Lead_Author_Editor__c,Category__c,Keywords__c, Contributors__c,toLabel(Sales_Channels__c),
                      toLabel(Applicable_Channels__c),toLabel(Applicable_License_Types__c),toLabel(Applicable_Customer_Types__c),originalProductId__c,Product_Category__c,Collection_updatedFrom__c ,
                      Collection_updatedTo__c,Collection_Valid_From__c ,Collection_Valid_To__c,BusinessId__c,Business_Id_Calc__c,Collection_Banner_Image_S3_location__c,Collection_Cover_Image_S3_location__c,
                      Collection_Banner_Image_Size__c,Collection_Cover_Image_Size__c,Abstract__c,Subject_Classifications__c, Product_Type__c, Collection_Subject_Area__c, Collection_Auto_Rollover__c, DiscountedPercentage__c
                      ,Backlist__c
                      FROM Product2 where id=:bundleId                      
                     ];
            
            if(!prdList.isEmpty()){
                prd = prdList[0];
            }
            
            if(prd.originalProductId__c!=NULL){
                originalPrdList=[SELECT Hub_Id__c, name, CreatedDate,LastModifiedDate from product2 where id=:prd.originalProductId__c];
            }
            if(listofLineItems == null || (listofLineItems != null && listofLineItems.isEmpty())){
                listofLineItems = new list< Bundle_Line_Item__c>();
                for(List<Bundle_Line_Item__c> lineItems : Database.Query('SELECT id,name,Title__c,Content_ID__c,uuid__c, Open_access__c, Type__c, Source__c,mediaType__c, Content_Position__c,lineItemActualStatus__c  FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c =:bundleId and uuid__c != null and lineItemStatus__c != :isDelete ORDER BY Content_Position__c limit 50000')){
                    listofLineItems.addAll(lineItems);
                }
            }
            
            
            List<Pricebookentry> lstpbe = getPriceBookEntry(bundleId);
            List<Pricebookentry> disCountedLstpbe = getDiscountedPriceBookEntry(bundleId);
            
            //generating JSON
            JSONGenerator gen = JSON.createGenerator(true);
            
            gen.writeStartObject();
            gen.writeStringField('apiVersion','4.0.1'); 
            gen.writeStringField('action','save'); 
            gen.writeFieldName('product');
            gen.writeStartObject();
            
            gen.writeStringField('_id',prd.Hub_Id__c==null ? '': prd.Hub_Id__c); 
            
            gen.writeStringField('type','collection'); 
            //if(prd.Product_Type__c!=null){
            gen.writeStringField('subType','Bespoke Collection'); 
            //}
            //Identifiers
            gen.writeFieldName('identifiers');
            gen.writeStartObject();
            //gen.writeFieldName('doi'); 
            //gen.writeString(prd.doi__c==null ? '' : prd.doi__c);
            gen.writeFieldName('sku'); 
            gen.writeString(prd.id==null ? '' : prd.id);
            gen.writeFieldName('collectionId'); 
            //gen.writeString(prd.Business_Id_Calc__c==null ? '' :prd.Business_Id_Calc__c);
            gen.writeString(String.isNotBlank(bespokeBusinessId) ? bespokeBusinessId : 'BD.EBOOK');
            gen.writeEndObject();
            
            //gen.writeStringField('version',prd.version__c==null ? '' : prd.version__c);
            gen.writeStringField('_schemaVersion','4.0.1');
            //gen.writeStringField('_schemaVersion',prd.version__c==null ? '' : prd.version__c);
            gen.writeStringField('title',prd.name==null ? '' : prd.name);
            //Sources
            gen.writeFieldName('_source');
            gen.writeStartObject();
            gen.writeFieldName('type'); 
            gen.writeString('product');
            gen.writeFieldName('source'); 
            gen.writeString('SALESFORCE');
            gen.writeEndObject(); 
            
            
            gen.writeFieldName('categories');
            gen.writeStartArray();
            gen.writeStartObject();
            gen.writeFieldName('code'); 
            gen.writeString('');
            gen.writeFieldName('name'); 
            gen.writeString('collection-type');
            gen.writeFieldName('type'); 
            //gen.writeString(prd.Product_Category__c==null ? '' : prd.Product_Category__c.toLowerCase());
            gen.writeString('bespoke');
            gen.writeEndObject();
            
            gen.writeStartObject();
            gen.writeFieldName('code'); 
            gen.writeString('');
            gen.writeFieldName('name'); 
            gen.writeString('collection-update-type');
            gen.writeFieldName('type'); 
            if(prd.Product_Type_Author_Facing__c=='Manual Curation'){
                gen.writeString('static');
            } else if(prd.Product_Type_Author_Facing__c=='Rule based'){
                gen.writeString('dynamic');
            } else {
                gen.writeString('');
            }
            
            gen.writeEndObject();
            gen.writeEndArray();
            //change
            gen.writeFieldName('classifications');
            gen.writeStartArray();
            if(prd.Subject_Classifications__c!=null){
            List<String> lstClassifications = prd.Subject_Classifications__c.split(',');
        for (String cls : lstClassifications) {
            gen.writeStartObject();
            gen.writeStringField('group','');
            gen.writeStringField('code',cls);
            gen.writeStringField('name','');
            gen.writeStringField('type','subject');
            gen.writeEndObject();
        }
                }
            gen.writeEndArray();
            
            //keywords
            
            String keywords = prd.Keywords__c;
            List<Keywords> keywordsLst = new List<Keywords>();    
            
            if(keywords != null){
                keywordsLst = ( List<Keywords>) JSON.deserialize(keywords,  List<Keywords>.class);
            }
            
            if(keywordsLst != null && keywordsLst.size() > 0){
                gen.writeFieldName('keywords');
                gen.writeStartArray();
                for(Keywords keyword : keywordsLst){
                    gen.writeStartObject();
                    gen.writeStringField('type','catchword');
                    gen.writeStringField('name',keyword.name==null ? '' : keyword.name);
                    gen.writeFieldName('position');
                    gen.writeNumber(keyword.position); 
                    //gen.writeStringField('weightage',''); 
                    gen.writeEndObject(); 
                }
                gen.writeEndArray(); 
            }
            //end of keywords
            
            //contributors
            String contributors = prd.Contributors__c;
            List<Contributors> contributorsLst = new List<Contributors>(); 
            if(contributors != null){
                contributorsLst = (List<Contributors>) JSON.deserialize(contributors, List<Contributors>.class);
            }
            
            if(contributorsLst != null && contributorsLst.size() > 0){
                gen.writeFieldName('contributors');
                gen.writeStartArray();
                for(Contributors contributor : contributorsLst){
                    gen.writeStartObject();
                    gen.writeFieldName('roles');
                    gen.writeStartArray();
                    gen.writeString(contributor.role);
                    gen.writeEndArray();
                    gen.writeStringField('givenName',contributor.givenName==null ? '' : contributor.givenName);
                    gen.writeStringField('familyName',contributor.familyName==null ? '' : contributor.familyName);
                    gen.writeStringField('fullName',contributor.name==null ? '' : contributor.name);
                    gen.writeNumberField('position', contributor.position==null ? 0 :contributor.position);
                    
                    gen.writeEndObject();
                }
                gen.writeEndArray();
                
                
            }
            // end of contributors
            
            // Prices
            gen.writeFieldName('prices');
            gen.writeStartArray();
            
            for (PricebookEntry pbe : lstPbe) {
                
                gen.writeStartObject();
                for (PricebookEntry disPbe : disCountedLstpbe){
                    if(disPbe.CurrencyIsoCode==pbe.CurrencyIsoCode){
                gen.writeFieldName('price'); 
                gen.writeNumber(disPbe.UnitPrice==null ? 0.00  : disPbe.UnitPrice);
                        }
                    }
                gen.writeFieldName('currency'); 
                gen.writeString(pbe.CurrencyIsoCode==null ? '' : pbe.CurrencyIsoCode); 
                gen.writeDateTimeField('validFrom',pbe.CreatedDate); 
                gen.writeStringField('priceType','BYO Library Price'); 
                gen.writeStringField('priceTypeCode','BYO'); 
                gen.writeFieldName('discountPercentage');
                gen.writeNumber(prd.DiscountedPercentage__c==null ? 0.00  : prd.DiscountedPercentage__c);
                gen.writeFieldName('listPrice'); 
                gen.writeNumber(pbe.UnitPrice==null ? 0.00  : pbe.UnitPrice);
                gen.writeEndObject();
                
            }
            gen.writeEndArray();
            // end of Price
            
            /*
            //permissions
            gen.writeFieldName('permissions');
            gen.writeStartArray();
            gen.writeEndArray();
            gen.writeFieldName('associatedMedia');
            gen.writeStartArray();
            if(prd.Collection_Banner_Image_Size__c!=null && prd.Collection_Banner_Image_S3_location__c!=null){
                gen.writeStartObject();
                gen.writeStringField('_id','');   
                gen.writeStringField('type','bannerimage');
                gen.writeFieldName('size'); 
                gen.writeNumber(Integer.valueof(prd.Collection_Banner_Image_Size__c));
                gen.writeStringField('location',prd.Collection_Banner_Image_S3_location__c);
                gen.writeEndObject(); 
            }
            
            if(prd.Collection_Cover_Image_Size__c!=null && prd.Collection_Cover_Image_S3_location__c!=null){
                gen.writeStartObject();
                gen.writeStringField('type','coverimage');
                gen.writeFieldName('size'); 
                gen.writeNumber(Integer.valueof(prd.Collection_Cover_Image_Size__c));
                gen.writeStringField('location',prd.Collection_Cover_Image_S3_location__c);
                gen.writeEndObject();
            }
            
            
            gen.writeEndArray();
            
            //partsUpdated
            if(prd.originalProductId__c!=NULL){
                gen.writeFieldName('partsUpdated');
                gen.writeStartArray(); 
                if(listofLineItems.size()>0) {
                    Integer IntPos=1;
                    for (Bundle_Line_Item__c bundlehasUpdatePart : listofLineItems) {           
                        gen.writeStartObject();
                        gen.writeFieldName('type'); 
                        gen.writeString(bundlehasUpdatePart.Type__c==null ? '' : bundlehasUpdatePart.Type__c);
                        typeSet.add(bundlehasUpdatePart.Type__c);
                        if((bundlehasUpdatePart.Type__c).toUpperCase() == 'BOOK'){
                             typeUpperC.add((bundlehasUpdatePart.mediaType__c).toUpperCase());
                        }else{
                            typeUpperC.add((bundlehasUpdatePart.Type__c).toUpperCase());
                        }
                        gen.writeFieldName('identifier'); 
                        gen.writeString(bundlehasUpdatePart.uuid__c==null ? '' : bundlehasUpdatePart.uuid__c);
                        gen.writeFieldName('isFree'); 
                        gen.writeBoolean(bundlehasUpdatePart.Open_access__c);
                        // gen.writeNumberField('position',bundlehasUpdatePart.Content_Position__c);
                        gen.writeNumberField('position',IntPos);
                        gen.writeEndObject();  
                        IntPos++;
                    }
                    
                }
                
                gen.writeEndArray();      
            }  */
            
            //partsAdded
            if(prd.originalProductId__c==NULL){
                gen.writeFieldName('partsAdded');
                gen.writeStartArray();
                if(listofLineItems.size()>0) {
                    Integer IntPos=1;
                    for (Bundle_Line_Item__c bundlehaspart : listofLineItems) {           
                        gen.writeStartObject();
                        gen.writeFieldName('type'); 
                        gen.writeString(bundlehaspart.Type__c==null ? '' : bundlehaspart.Type__c);
                        typeSet.add(bundlehaspart.Type__c);
                        if((bundlehaspart.Type__c).toUpperCase() == 'BOOK'){
                            typeUpperC.add((bundlehaspart.mediaType__c).toUpperCase());
                        }else{
                            typeUpperC.add((bundlehaspart.Type__c).toUpperCase());
                        }                        
                        gen.writeFieldName('identifier'); 
                        gen.writeString(bundlehaspart.uuid__c==null ? '' : bundlehaspart.uuid__c);
                        gen.writeFieldName('isFree'); 
                        gen.writeBoolean(bundlehaspart.Open_access__c);
                        //gen.writeNumberField('position',bundlehaspart.Content_Position__c);
                        gen.writeNumberField('position',IntPos);
                        gen.writeEndObject();  
                        IntPos++;
                    }
                }
                gen.writeEndArray();   
            }
            
            // Sap tax code
            if(typeUpperC.size() == 1 && typeUpperC.contains('E-BOOK')){
                sapTaxCode = 'Q';
            }else if(typeUpperC.size() > 0){
                mixedTypeParts = true ;
            }
            

            //partsRemoved
            /* gen.writeFieldName('partsRemoved');
gen.writeStartArray();   
if(listofLineItemsForDelete.size()>0) {
for (Bundle_Line_Item__c bundlehasDeletePart : listofLineItemsForDelete) {           
gen.writeStartObject();
gen.writeFieldName('type'); 
gen.writeString(bundlehasDeletePart.Type__c==null ? '' : bundlehasDeletePart.Type__c);
gen.writeFieldName('identifier'); 
gen.writeString(bundlehasDeletePart.uuid__c==null ? '' : bundlehasDeletePart.uuid__c);
gen.writeFieldName('isFree'); 
gen.writeBoolean(bundlehasDeletePart.Open_access__c);
//gen.writeNumberField('position',bundlehasDeletePart.Content_Position__c);

gen.writeEndObject();  

}

}
gen.writeEndArray();  */
            
            
            //Availability object declarations
            
            ruleObj rObjBEGIN = new ruleObj();
            rObjBEGIN.type = 'separator';
            ruleObj rObjEND = new ruleObj();
            rObjEND.type = 'separator';
            ruleObj rObjAND = new ruleObj();
            rObjAND.type = 'logical';
            ruleObjVal rObjName = new ruleObjVal();
            rObjName.type = 'criteria';
            ruleObjVals rObjStatus = new ruleObjVals();
            rObjStatus.type = 'criteria';
            
            rule rBEGIN = new rule();
            rBEGIN.value = 'BEGIN';
            rObjBEGIN.rule = rBEGIN;
            
            
            rule rEND =  new rule();
            rEND.value = 'END';
            rObjEND.rule = rEND;
            
            rule rAND = new rule() ;
            rAND.value = 'AND';
            rObjAND.rule = rAND;
            
            ruleVal rName = new ruleVal() ;
            rName.attribute = 'availability.name';
            rName.relationship = 'EQ';
            rObjName.rule = rName;
            
            
            ruleVals rStatus = new ruleVals() ;
            rStatus.attribute = 'availability.status';
            rObjStatus.rule = rStatus;
            
            //
            //Rulelist
            if(prd.Product_Type_Author_Facing__c=='Rule based'){
                
                AvailabilityDetails availabilityDetails = new AvailabilityDetails();
                availabilityDetails= calculateAvailability('Collections',bundleId);
                availabilityTypeMap = availabilityDetails.availabilityTypeMap;
                
                gen.writeFieldName('rulesList');
                gen.writeStartArray(); 
                if(multiTypeRules!=null){
                    
                    for (TF_PPDProcessController.MultiTypeRules multiRuleEle : multiTypeRules) { 
                        
                        gen.writeStartObject();        
                        gen.writeStringField('type',multiRuleEle.productType != null ? multiRuleEle.productType : 'book'); 
                        typeSet.add((multiRuleEle.productType).toUpperCase());

                        gen.writeFieldName('rules');//intenal rules
                        gen.writeStartArray();//Start IR1 array
                        gen.writeStartObject();//Start IR1 Obj 
                        
                        gen.writeStringField('type','group');
                        gen.writeStringField('name','product');
                        
                        //Start of query rules
                        gen.writeFieldName('rules');
                        gen.writeStartArray();
                        
                        List<TF_PPDProcessController.RuleElement> ruleElementLst = new List<TF_PPDProcessController.RuleElement>();
                        ruleElementLst = multiRuleEle.ruleElementLst ;
                        Integer intPosition=1;
                        for (TF_PPDProcessController.RuleElement ruleEle : ruleElementLst) {
                           
                            gen.writeStartObject();
                            
                            gen.writeFieldName('type'); 
                            gen.writeString(ruleEle.type);
                            
                            gen.writeFieldName('rule');
                            gen.writeStartObject();
                            
                            if(ruleEle.type == 'separator'){                        
                                gen.writeFieldName('value'); 
                                gen.writeString(ruleEle.value);
                            }
                            
                            if(ruleEle.type == 'criteria'){
                                 if((multiRuleEle.productType).toUpperCase() == 'BOOK' && ruleEle.attribute == 'book.format'){
                                formatSet.add((ruleEle.value).toUpperCase());
                            }
                                gen.writeFieldName('attribute'); 
                                gen.writeString(ruleEle.attribute);
                                
                                gen.writeFieldName('relationship'); 
                                gen.writeString(ruleEle.relationship);
                                
                                if(ruleEle.relationship == 'IN' || ruleEle.relationship == 'NI'){
                                    List<String> valueList = new  List<String>();
                                    String valueStr = ruleEle.value ;
                                    valueList = valueStr.split(',');
                                    gen.writeFieldName('values'); 
                                    gen.writeObject(valueList);
                                }else{
                                    gen.writeFieldName('value'); 
                                    gen.writeString(ruleEle.value);
                                }
                            }                    
                            if(ruleEle.type == 'logical'){                        
                                gen.writeFieldName('value'); 
                                gen.writeString(ruleEle.value);
                            }                    
                            gen.writeEndObject();                    
                            gen.writeFieldName('position'); 
                            gen.writeNumber(intPosition);                    
                            gen.writeEndObject();                    
                            intPosition++;
                        }          
                        gen.writeEndArray();
                        //End of query rules
                        
                        gen.writeEndObject(); //End IR1 Obj
                        

                        allChannelLst.clear();
                        system.debug('availabilityTypeMap====='+ JSON.serialize(availabilityTypeMap));
                        channelAvailabilityMap = availabilityTypeMap.get(multiRuleEle.productType);
                        if(channelAvailabilityMap  != null && channelAvailabilityMap.size() > 0){
                            allChannelLst.addAll(channelAvailabilityMap.keySet());
                        }
                        system.debug('allChannelLst====='+ JSON.serialize(allChannelLst));
                        
                        if(allChannelLst != null && allChannelLst.size() > 0){
                            
                            gen.writeStartObject();//Start IR2 Obj
                            
                            gen.writeStringField('type','group');
                            gen.writeStringField('name','availability');
                            
                            gen.writeFieldName('rules');
                            gen.writeStartArray();//availability rules arr start
                            
                            
                            gen.writeObject(rObjBEGIN);
                            
                            Integer loopCount = 0;
                            for(String channelName : allChannelLst){
                                
                                gen.writeObject(rObjBEGIN);
                                
                                rName.value = channelName; 
                                gen.writeObject(rObjName);
                                
                                gen.writeObject(rObjAND);
                                
                                
                                List<Setting_Item__c> settingItmLst = new  List<Setting_Item__c>();
                                settingItmLst = channelAvailabilityMap.get(channelName);
                                String statusOpe = settingItmLst[0].Text_4__c;
                                
                                List<String> statusLst = new List<String>();
                                Set<String> statusSet = new Set<String>();
                                for(Setting_Item__c itm :settingItmLst){
                                    if(itm.Text_3__c != null){
                                        statusLst.addAll(itm.Text_3__c.split(','));
                                        statusSet.addAll(statusLst);
                                        statusLst.clear();
                                        statusLst.addAll(statusSet);
                                    }
                                }
                                
                                rStatus.relationship = statusOpe;
                                rStatus.values = statusLst;
                                
                                gen.writeObject(rObjStatus);
                                
                                gen.writeObject(rObjEND);
                                
                                loopCount++;
                                
                                if(loopCount < allChannelLst.size()){
                                    gen.writeObject(rObjAND);
                                }
                            }
                            
                            gen.writeObject(rObjEND);
                            
                            gen.writeEndArray();//availability rules arr End
                            gen.writeEndObject(); //End IR2 Obj 
                        }
                        gen.writeEndArray();//End IR1 array
                        
                        gen.writeEndObject();
                        //break;
                        
                    }//End of loop
                    
                }
                gen.writeEndArray();// end rulesList
            }
            else if(prd.Product_Type_Author_Facing__c=='Manual Curation'){
                
                AvailabilityDetails availabilityDetails = new AvailabilityDetails();
                availabilityDetails= calculateAvailability('Collections',bundleId);
                availabilityTypeMap = availabilityDetails.availabilityTypeMap;
                typeLst.addAll(typeSet);
                 
                gen.writeFieldName('rulesList');
                gen.writeStartArray();
                
                for (String typ : typeLst) {  
                     allChannelLst.clear();
                    system.debug('availabilityTypeMap====='+ JSON.serialize(availabilityTypeMap));
                    channelAvailabilityMap = availabilityTypeMap.get(typ);
                    if(channelAvailabilityMap  != null && channelAvailabilityMap.size() > 0){
                        allChannelLst.addAll(channelAvailabilityMap.keySet());
                    }
                    
                    if(allChannelLst != null && allChannelLst.size() > 0){
                        gen.writeStartObject();        
                        gen.writeStringField('type',typ); 
                        
                        gen.writeFieldName('rules');//intenal rules
                        gen.writeStartArray();//Start IR1 array                
                        
                        
                        system.debug('allChannelLst====='+ JSON.serialize(allChannelLst));

                        
                        gen.writeStartObject();//Start IR2 Obj
                        
                        gen.writeStringField('type','group');
                        gen.writeStringField('name','availability');
                        
                        gen.writeFieldName('rules');
                        gen.writeStartArray();//availability rules arr start
                        
                        
                        gen.writeObject(rObjBEGIN);
                        
                        Integer loopCount = 0;
                        for(String channelName : allChannelLst){
                            
                            gen.writeObject(rObjBEGIN);
                            
                            rName.value = channelName; 
                            gen.writeObject(rObjName);
                            
                            gen.writeObject(rObjAND);
                            
                            
                            List<Setting_Item__c> settingItmLst = new  List<Setting_Item__c>();
                            settingItmLst = channelAvailabilityMap.get(channelName);
                            String statusOpe = settingItmLst[0].Text_4__c;
                            
                            List<String> statusLst = new List<String>();
                            Set<String> statusSet = new Set<String>();
                            for(Setting_Item__c itm :settingItmLst){
                                if(itm.Text_3__c != null){
                                    statusLst.addAll(itm.Text_3__c.split(','));
                                    statusSet.addAll(statusLst);
                                    statusLst.clear();
                                    statusLst.addAll(statusSet);
                                }
                            }
                            
                            rStatus.relationship = statusOpe;
                            rStatus.values = statusLst;
                            
                            gen.writeObject(rObjStatus);
                            
                            gen.writeObject(rObjEND);
                            
                            loopCount++;
                            
                            if(loopCount < allChannelLst.size()){
                                gen.writeObject(rObjAND);
                            }
                        }
                        
                        gen.writeObject(rObjEND);
                        
                        gen.writeEndArray();//availability rules arr End
                        gen.writeEndObject(); //End IR2 Obj 
                    gen.writeEndArray();//End IR1 array
                    
                    gen.writeEndObject();
                    //break;
                    }
                }
                gen.writeEndArray();
                
            }
            
            if(typeSet.size() == 1 && typeSet.contains('BOOK') && formatSet.size() == 1 && formatSet.contains('E-BOOK') && ! mixedTypeParts){
                sapTaxCode = 'Q';
            }
            
            //collection
            gen.writeFieldName('collection');
            gen.writeStartObject();
            gen.writeStringField('subtitle','');
            //gen.writeStringField('description',prd.Description==null ? '' : prd.Description);
            gen.writeStringField('description','');
            gen.writeStringField('status','planned');
           
            if ( prd.Collection_Valid_From__c != NULL ) {
                gen.writeDateTimeField('plannedPublicationDate',prd.Collection_Valid_From__c);
            }
            //gen.writeStringField('publisherImprint',prd.Product_Publisher__c==null ? '' : prd.Product_Publisher__c);
            gen.writeStringField('publisherImprint','');
            gen.writeNumberField('firstPublishedYear',Integer.valueOf(prd.copyrightyear__c));
            //gen.writeStringField('inLanguage','eng');
             
            if(prd.Collection_Valid_From__c !=null){
                gen.writeDateTimeField('validFrom',prd.Collection_Valid_From__c );
            }
            if(prd.Collection_Valid_To__c!=null){
                gen.writeDateTimeField('validTo',prd.Collection_Valid_To__c );
            }
            gen.writeStringField('taxType',sapTaxCode);
            //gen.writeStringField('taxType','');
            gen.writeStringField('subjectAreaCode',prd.Collection_Subject_Area__c==null ? '' : prd.Collection_Subject_Area__c);
            //gen.writeStringField('subjectAreaCode','');
            gen.writeFieldName('autoRollover'); 
            gen.writeBoolean(prd.Collection_Auto_Rollover__c);
            gen.writeFieldName('backList');
            gen.writeBoolean(prd.Backlist__c);
             
            
            //abstract
            gen.writeFieldName('abstracts');
            gen.writeStartArray();
            gen.writeStartObject();
            gen.writeStringField('type','text');
            //gen.writeStringField('value',prd.Abstract__c==null ? '' : prd.Abstract__c);
            gen.writeStringField('value', 'bespoke');
            gen.writeEndObject(); 
            gen.writeEndArray();   
            //Channels
            gen.writeFieldName('channels');
            gen.writeStartArray();
            if(String.isNotBlank(prd.Sales_Channels__c)){
                List<String> lstSalesChannels = prd.Sales_Channels__c.split(';');
                If( lstSalesChannels.contains('All')){
                    lstSalesChannels.clear();
                    lstSalesChannels.add('All');
                }
                for (String strSalesChannel : lstSalesChannels) {           
                    
                    gen.writeStartObject();
                    gen.writeFieldName('name'); 
                    gen.writeString(strSalesChannel);
                    gen.writeFieldName('type'); 
                    gen.writeString('sales');
                    gen.writeEndObject();
                }
            }    
            // delivery channels 
            if(String.isNotBlank(prd.Applicable_Channels__c)){
                List<String> lstdeliveryChannels = prd.Applicable_Channels__c.split(';');
                If( lstdeliveryChannels.contains('All')){
                    lstdeliveryChannels.clear();
                    lstdeliveryChannels.add('All');
                }
                for (String strdeliveryChannel : lstdeliveryChannels) {           
                    
                    gen.writeStartObject();
                    gen.writeFieldName('name'); 
                    gen.writeString(strdeliveryChannel);  
                    gen.writeFieldName('type'); 
                    gen.writeString('delivery');
                    gen.writeEndObject();       
                }
            }
            
            gen.writeEndArray();   
            
            //licenses
            gen.writeFieldName('licenses');
            gen.writeStartArray();
            if(String.isNotBlank(prd.Applicable_License_Types__c)){
                List<String> lstbusinessModels = prd.Applicable_License_Types__c.split(';');
                If( lstbusinessModels.contains('All')){
                    lstbusinessModels.clear();
                    lstbusinessModels.add('All');
                }
                for (String strbusinessModel : lstbusinessModels) {           
                    
                    gen.writeStartObject();
                    gen.writeFieldName('name'); 
                    gen.writeString(strbusinessModel);   
                    gen.writeFieldName('type'); 
                    gen.writeString('license');
                    gen.writeEndObject();       
                }
            }
            
            gen.writeEndArray();  
            
            //Customers
            gen.writeFieldName('customers');
            gen.writeStartArray();
            if(String.isNotBlank(prd.Applicable_Customer_Types__c)){
                List<String> lstcustomerTypes = prd.Applicable_Customer_Types__c.split(';');
                If( lstcustomerTypes.contains('All')){
                    lstcustomerTypes.clear();
                    lstcustomerTypes.add('All');
                }
                for (String strcustomerType : lstcustomerTypes) {           
                    
                    gen.writeStartObject();
                    gen.writeFieldName('name'); 
                    gen.writeString(strcustomerType); 
                    gen.writeFieldName('type'); 
                    gen.writeString('customer');
                    gen.writeEndObject();       
                }
            }    
            gen.writeEndArray();    
            if(prd.Product_Type_Author_Facing__c=='Rule based'){
                if((prd.Collection_updatedFrom__c!=null)&&(prd.Collection_updatedTo__c!=null)){
                    gen.writeDateTimeField('ruleUpdateStartDate',prd.Collection_updatedFrom__c  ==null ? null :prd.Collection_updatedFrom__c);    
                    gen.writeDateTimeField('ruleUpdateEndDate',prd.Collection_updatedTo__c ==null ? null : prd.Collection_updatedTo__c);    
                }              
            }
            
            gen.writeEndObject();
            //End of collection
            gen.writeEndObject();//Product Object End
            //first object end
            gen.writeEndObject();
            jsonString = gen.getAsString();
            System.debug('commonBundleBespokeJsonString:'+jsonString);   
            
        }
        catch(Exception ex){
            System.debug('Exception:'+ex.getMessage());
            System.debug('Exception:'+ex.getLineNumber());
            System.debug('Exception:'+ex.getStackTraceString());
        }
        
        Return jsonString;
    }
}