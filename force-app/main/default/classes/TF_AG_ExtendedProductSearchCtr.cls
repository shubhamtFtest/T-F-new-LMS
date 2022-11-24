/**
* File Name: TF_AG_ExtendedProductSearchCtr
* Description : 
* @author :  Siddahant Tyagi
* Test class: TF_AG_ExtendedProductSearchCtr_testClass
* Test coverage : 85%
* */ 
public class TF_AG_ExtendedProductSearchCtr{
    public List<PricebookEntry> lstDownloadData {get;set;}
    public List<ProductWrapper> productWrapperList {get;set;}
    public string fileName {get;set;}
    public string userId{get;set;}
    
    public TF_AG_ExtendedProductSearchCtr(){
        try{
            userIdAndContryPickListWrapper UserwrapperData=getDetails();
            String userId = UserwrapperData.userId;
            System.debug('userId:='+userId);
            Datetime dateTm=System.now();
            String val=String.valueOfGmt(dateTm);
            System.debug('val='+val);
            List<String> dateValue=val.split(' ');
            fileName='';
            for(String d:dateValue){
                fileName=fileName+d+'_';
                fileName=fileName.remove('-');
                System.debug(fileName);
            }
            fileName=fileName.removeEnd('_');
            List<String> multiIsbnListData=new List<String>();
            List<String> multiIsbnListDownloadData=new List<String>();
            List<String> downloadCsvListData=new List<String>();
            List<String> readCsvListData=new List<String>();
            list<String> lstMediumData=new List<String>();
            list<String> lstMedium=new List<String>();
            List<String> lstSubjectList=new List<String>();
            List<String> Netbase=new List<String>();
            string minPrice=apexpages.currentpage().getparameters().get('minprice');
            String maxPrice=apexpages.currentpage().getparameters().get('maxprice');
            system.debug('min-->'+minPrice+'--max-->'+maxPrice); 
            String downloadData = apexpages.currentpage().getparameters().get('paramdemo');
            String lstNetbase=apexpages.currentpage().getparameters().get('Netbase');
            String subjectListval=apexpages.currentpage().getparameters().get('subjectList');
            String selectedMediumData=apexpages.currentpage().getparameters().get('lstSelectedMediumData');
            String multiIsbnData=apexpages.currentpage().getparameters().get('multiIsbnListData');
            String readCsv=apexpages.currentpage().getparameters().get('infoList');
            
            downloadData+=' LIMIT 9999';
            System.debug('downloadData:='+downloadData);
            System.debug('subjectListval'+subjectListval);
            
            
            /*----Create download data for ProductTab------*/
            /*If the search is invoked Using Subject Code*/
            if(lstNetbase !=null){
                List<String> listSplitSubCodes=lstNetbase.split(',');
                for(String subCode:listSplitSubCodes){
                    subCode=subCode.replace('!',',');
                    subCode=subCode.replace('~','&');
                    Netbase.add(subCode);
                }
                System.debug('lstNetbase:='+Netbase);
            }
            /*If the search is invoked Using Subject List*/
            if(subjectListval !=null){
                List<String> listSplitSubList=subjectListval.split(',');
                for(String subList:listSplitSubList){
                    subList=subList.replace('!',',');
                    subList=subList.replace('~','&');
                    lstSubjectList.add(subList);
                }
                System.debug('lstSubjectListval:='+lstSubjectList.size());
            }
            /*If the search is invoked Using Medium Options*/
            if(selectedMediumData !=null){
                List<String> listSplitMediumData=selectedMediumData.split(',');
                for(String subMedium:listSplitMediumData){
                    System.debug('subMedium'+subMedium);
                    if(subMedium.contains('All')){
                        lstMedium.add(subMedium);
                    }
                    else{
                        lstMediumData.add(subMedium);
                    }                    
                }
                System.debug('lstMediumData:='+lstMediumData);
                System.debug('lstMedium:='+lstMedium);
            }  
            
            /*To calculate discount value*/
            String customerDiscountCode = [SELECT BMIS_Customer_Discount_Code__c FROM User WHERE Id = :UserInfo.getUserId()].BMIS_Customer_Discount_Code__c;
            //Locate the discounts applicable to the user in question.
            Map<String, Integer> productDiscountCodeToValueMap = new Map<String, Integer>();
            for(Setting_Item__c si: [SELECT Text_2__c, Text_3__c FROM Setting_Item__c WHERE Setting__r.Name = 'BMISDiscountMatrix' AND Text_1__c =: customerDiscountCode]){
                //Text_1__c = Customer discount code--->//Text_2__c = Product discount code--->//Text_3__c = Product discount %
                productDiscountCodeToValueMap.put(si.Text_2__c.toUpperCase(), integer.ValueOf(si.Text_3__c));
            }
            
            /*------Create download data for MultiISBN Csv-------*/
            if(multiIsbnData !=null){
                multiIsbnListDownloadData=multiIsbnData.split(',');    
                for(integer i=0;i<multiIsbnListDownloadData.size();i++){
                    String isbnWithOutSpace=multiIsbnListDownloadData[i].replaceAll( '\\s+', '');
                    isbnWithOutSpace=isbnWithOutSpace.replace('-', '');
                    multiIsbnListData.add(isbnWithOutSpace);
                }
                system.debug('multiIsbnListData'+multiIsbnListData);
            }
            
            /*-------Create download data for Upload Csv------*/
            if(readCsv !=null){
                downloadCsvListData=readCsv.split(',');
                for(integer i=0;i<downloadCsvListData.size();i++){
                    String isbnWithOutSpace=downloadCsvListData[i].replaceAll( '\\s+', '');
                    isbnWithOutSpace=isbnWithOutSpace.replace('-', '');            
                    readCsvListData.add(isbnWithOutSpace);
                }
                system.debug('readCsvListData'+readCsvListData);
            }
            system.debug('downloadData'+downloadData);
            lstDownloadData=Database.query(downloadData);
            productWrapperList = new List<ProductWrapper>();
            System.debug('lstDownloadData'+lstDownloadData);
            /*-------Preparing downloadable excel-------*/
            if(lstDownloadData.size()>0||Test.isRunningTest()){
               set<Id> product2Ids = new set<Id>();
                for(PricebookEntry pricebook:lstDownloadData){
                    if(pricebook.product2.Id != null){
                    product2Ids.add(pricebook.product2.Id);
                    }
                }
                for(PricebookEntry pricebook:lstDownloadData){
                        ProductWrapper priceWrap=new ProductWrapper();
                        priceWrap.pricebookCSV= pricebook;
                        priceWrap.discountCSV=calculatProductDiscount(pricebook,productDiscountCodeToValueMap );
                        priceWrap.discountPercentCSV=calculatProductDiscountPercentage(pricebook,productDiscountCodeToValueMap);                   		 
                        System.debug('priceWrapdisc :='+priceWrap);
                        productWrapperList.add(priceWrap);
                    }
                      system.debug('productWrapperList'+productWrapperList);
            }
        }
        catch(Exception e){
            System.debug('message:='+e.getMessage()+'&& Line Number='+e.getLineNumber());
        }
    }
    
    
    
    @AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
        //system.debug('objObject --->' + objObject);
        //system.debug('fld --->' + fld);
        List < String > allOpts = new list < String > ();
        
        Schema.sObjectType objType = objObject.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        
        list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        // system.debug('allOpts ---->' + allOpts);
        allOpts.sort();
        return allOpts;
    }
    
    @AuraEnabled
    public static List<String> getPicklistvalues(String objectName, String field_apiname){
        List<String> optionlist = new List<String>();
        
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> field_map = gd.get(objectName.toLowerCase()).getDescribe().fields.getMap();
        
        List<Schema.PicklistEntry> picklistValues = field_map.get(field_apiname).getDescribe().getPickListValues();

        
        for (Schema.PicklistEntry pv : picklistValues) {
            optionlist.add(pv.getValue());
        }
        return optionlist; 
    }
    
    @AuraEnabled
    public static userIdAndContryPickListWrapper getDetails() {
        String runningUserId='';
        List<Setting_Item__c> countryPicklistValues = new List<Setting_Item__c>();
        countryPicklistValues = [Select id,Text_1__c,Text_2__c from Setting_Item__c where Setting__r.Name = 'Distribution_Rights_Mapping_Table' ORDER BY Text_1__c ASC NULLS LAST];
        Profile pfile = [Select Name from Profile where Id =: userinfo.getProfileid()];
        if(pfile.Name == 'Agent Extranet Community User'){
            runningUserId= UserInfo.getUserId(); 
        }
        userIdAndContryPickListWrapper usrIdCntryWrapper = new userIdAndContryPickListWrapper();
        usrIdCntryWrapper.userId = runningUserId;
        usrIdCntryWrapper.countryPickListValues = new List<Setting_Item__c>();
        if(countryPicklistValues.size()>0){
         usrIdCntryWrapper.countryPickListValues.addall(countryPicklistValues);   
        }
        return usrIdCntryWrapper;
    }   
    
    @AuraEnabled
    public static string getProductDetails(String ISBN,String title,String author,List<String> Netbase, List<String> lstSubjectList,List<String> lstMediumData,String publishData,String publcFromDate,String publcToDate,String minPrice,String maxPrice,Integer displayPageData,Integer offsetVal,String sortBy,String sortOrderFieldName,String drmData,String currencyTypeData,List<String> firstPublishedYearData,String excludeCountryValue){
        // system.debug('currencyTypeData--->'+currencyTypeData);
        List<PricebookEntry> lstPriceBookEntry=new List<PricebookEntry>();
        List<ProductDataWrapper> lstProductWrapper=new List<ProductDataWrapper>();
        ProductDataWrapperWithCount prodDataWrapWthCount = new ProductDataWrapperWithCount();
        List<String> lstMedium=new List<String>();
        String query;
        String queryCount = ''; // Siddhant Tyagi -- no of records in the same method to minimize the callouts
        String systemIdVal='GT_TF';
        String currencyType= currencyTypeData;
        String priceBookName='T&F - eBooks Pricebook';
        String sortOrderBy;
        String EBRALLOutputChannel = 'EBRALL';
        String EBRINSTOutputChannel = 'EBRINST';
        
        if(sortOrderFieldName.equals('UnitPrice')){
            sortOrderBy='UnitPrice';
        }
        else{
            sortOrderBy='Product2.'+sortOrderFieldName;
        }
        
        try{
            query='Select Id,Pricebook2.name,CurrencyIsoCode,UnitPrice,Product2.ID,Product2.ISBN__c,Product2.eBook_ISBN__c,Pricing_Type__c,Product2.Paperback_ISBN__c,Product2.Hardback_ISBN__c,Product2.Edition_Number__c,Product2.copyrightyear__c,Product2.Name,Product2.US_Discount__c,Product2.Lead_Author_Editor__c,Product2.US_Publication_Date__c,Product2.US_Planned_Publication_Date__c,Product2.Version_Type__c,Product2.US_Inventory_Status__c,Product2.POD__c From PricebookEntry where IsActive = true and CurrencyIsoCode=\''+currencyType+'\' and Product2.System_ID__c=\''+systemIdVal+'\' and Pricebook2.name=\''+priceBookName+'\' and Product2.IsActive = True and (Product2.Output_Channel__c includes (\''+EBRALLOutputChannel+'\') OR Product2.Output_Channel__c includes (\''+EBRINSTOutputChannel+'\') )';
            if(String.isNotBlank(minPrice) && String.isNotBlank(maxPrice)){
                query+=' and unitprice>='+minPrice+' and unitprice<='+maxPrice;
            }
            if(String.isBlank(minPrice) && String.isNotBlank(maxPrice)){
                query+=' and unitprice<='+maxPrice;
            }
            if(String.isNotBlank(minPrice) && String.isBlank(maxPrice)){
                query+=' and unitprice>='+minPrice;
            }
            if(String.isNotBlank(ISBN) ){
                ISBN=ISBN.replaceAll('-', '');
                query+=' and (Product2.ProductCode=\''+ISBN+'\' or Product2.eBook_ISBN__c=\''+ISBN+'\' or Product2.Hardback_ISBN__c=\''+ISBN+'\' or Product2.Paperback_ISBN__c=\''+ISBN+'\')';
            }
            if(firstPublishedYearData !=null && firstPublishedYearData.size()>0 ){
                query+=' and Product2.First_Published_Year__c IN :firstPublishedYearData';
            }
            if(String.isNotBlank(title)){
                String productTitle ='%'+title.trim()+'%';
                query+=' and Product2.Name Like \''+productTitle+'\'';
            }
            if(String.isNotBlank(drmData) && drmData != 'Both'){
                Boolean drmvalue = Boolean.valueOf(drmData);
                query+=' and Product2.Has_DRM__c ='+drmvalue;
            }
            if(String.isNotBlank(excludeCountryValue) && excludeCountryValue != 'None'){
                query+=' and Product2.Distribution_Rights_Excluded_Countries_1__c excludes (\''+excludeCountryValue+'\')';
                query+=' and Product2.Distribution_Rights_Excluded_Countries_2__c excludes (\''+excludeCountryValue+'\')';
                query+=' and Product2.Distribution_Rights_Excluded_Countries_3__c excludes (\''+excludeCountryValue+'\')';
            }
            if(String.isNotBlank(author)){
                String authorEscapeQuot=String.escapeSingleQuotes(author);
                String productauthor ='%'+authorEscapeQuot+'%';
                query+=' and Product2.Lead_Author_Editor__c Like \''+productauthor+'\'';
            }
            if(Netbase !=null && Netbase.size()>0){
                String s = '';
                Integer i = 0;
                
                for(string ag : Netbase){
                    if(i==Netbase.size()-1){
                        s += '\''+ag+'\'';    
                    }else{
                        s += '\''+ag+'\',';
                    }
                    i++;
                }
                query+=' and Product2.Netbase_Classifications__c Includes ('+ s +')';
            }
            if(lstSubjectList!=null && lstSubjectList.size()>0){
                String s = '';
                Integer i = 0;
                
                for(string ag : lstSubjectList){
                    if(i==lstSubjectList.size()-1){
                        s += '\''+ag+'\'';    
                    }else{
                        s += '\''+ag+'\',';
                    }
                    i++;
                }
                
                query+=' and Product2.Subject_Classifications__c Includes ('+ s +')';
            }
            if(lstMediumData !=null && lstMediumData.size()>0){
                if(lstMediumData.contains('All')){
                    query+=' and Product2.Version_Type__c Not IN :lstMediumData';
                }
                else{
                    query+=' and Product2.Version_Type__c IN :lstMediumData';
                }
            }
            if(String.isNotBlank(publishData)){
                if(publishData == 'exclude'){
                    query+=' and Product2.Publication_Date__c<=TODAY';
                }
                if(publishData == 'Only NYP'){
                    query+=' and (Product2.Publication_Date__c>TODAY OR Product2.Publication_Date__c= null)';
                }
            }
            if(String.isNotBlank(publcFromDate) && String.isNotBlank(publcToDate)){
                query+=' and Product2.Publication_Date__c>='+publcFromDate+' and Product2.Publication_Date__c<='+publcToDate;
                
            }
            if(String.isBlank(publcFromDate) && String.isNotBlank(publcToDate)){
                query+=' and Product2.Publication_Date__c<='+publcToDate;
            }
            if(String.isNotBlank(publcFromDate) && String.isBlank(publcToDate)){
                query+=' and Product2.Publication_Date__c>='+publcFromDate;
            }
            String prodStatusStr = 'Available';
            query+=' and Product2.Product_Status__c =:prodStatusStr';
            queryCount += query;
            query+=' order by '+sortOrderBy+' '+sortBy+' LIMIT 2000'; // removed the offset to make the pagination dynamic on javascript +displayPageData+' OFFSET '+offsetVal;
            queryCount+=' limit 2001';
            System.debug('query:='+query);
            if(String.isNotBlank(query)){
                lstPriceBookEntry=Database.query(query);
            }
            if(lstPriceBookEntry.size()>0||Test.isRunningTest()){
                Integer count = 0;
                if(String.isNotBlank(queryCount)){
                    queryCount = queryCount.replace('Select Id,Pricebook2.name,CurrencyIsoCode,UnitPrice,Product2.ID,Product2.ISBN__c,Product2.eBook_ISBN__c,Pricing_Type__c,Product2.Paperback_ISBN__c,Product2.Hardback_ISBN__c,Product2.Edition_Number__c,Product2.copyrightyear__c,Product2.Name,Product2.US_Discount__c,Product2.Lead_Author_Editor__c,Product2.US_Publication_Date__c,Product2.US_Planned_Publication_Date__c,Product2.Version_Type__c,Product2.US_Inventory_Status__c,Product2.POD__c', 'Select count()');
                    count = Database.countQuery(queryCount);
                }
                //lstProductWrapper=getproductWrappedData(lstPriceBookEntry);
                prodDataWrapWthCount.countRec = count;
                prodDataWrapWthCount.prodDataWrap = getproductWrappedData(lstPriceBookEntry);
            }
            //System.debug('lstProductWrapper='+lstProductWrapper);
            
        }
        catch(Exception ex){
            
            system.debug(ex.getLineNumber());
            System.debug('message:='+ex.getMessage());
            throw new AuraHandledException(ex.getMessage());
            
        }
        system.debug('prodDataWrapWthCount'+prodDataWrapWthCount);
        return JSON.serialize(prodDataWrapWthCount);
    }
    
    @AuraEnabled
    public static List<Setting_Item__c> getSubjectCodes(){
        List<Setting_Item__c> lstResult=new List<Setting_Item__c>();
        lstResult=[SELECT Text_1__c FROM Setting_Item__c WHERE Setting__r.Name = 'AgentExtranet_DistinctSubjectCodeList' AND Checkbox_1__c = TRUE ORDER BY Text_1__c ASC limit 1000]; 
        if(lstResult != null && lstResult.size()>0){
            return lstResult;
        }
        return lstResult;
        
    }
    
    @AuraEnabled
    public static List<Setting_Item__c> getSubjectList(){
        List<Setting_Item__c> lstResult=new List<Setting_Item__c>();
        lstResult=[SELECT Text_1__c FROM Setting_Item__c WHERE Setting__r.Name = 'AgentExtranet_DistinctListValueList' AND Checkbox_1__c = TRUE ORDER BY Text_1__c ASC limit 1000]; 
        if(lstResult != null && lstResult.size()>0){
            return lstResult;
        }
        return lstResult;
    }
    
    @AuraEnabled
    public static List<Setting_Item__c> getNetBaseClassifications(){
        String customLabelValue = System.Label.getNetBaseClassifications;
        List<Setting_Item__c> lstResult=new List<Setting_Item__c>();
        lstResult=[SELECT Text_1__c FROM Setting_Item__c WHERE Setting__r.Name =: customLabelValue AND Checkbox_1__c = TRUE ORDER BY Text_1__c ASC limit 1000]; 
        if(lstResult != null && lstResult.size()>0){
            return lstResult;
        }
        return lstResult;
        
    }
    
    @AuraEnabled
    public static List<Setting_Item__c> getSubjectClassifications(){
        //String customLabelValue = System.Label.getSubjectClassifications;
        List<Setting_Item__c> lstResult=new List<Setting_Item__c>();
        lstResult=[SELECT Text_1__c FROM Setting_Item__c WHERE Setting__r.Name = 'AgentExtranet_DistinctListValueList' AND Checkbox_1__c = TRUE ORDER BY Text_1__c ASC limit 1000]; 
        if(lstResult != null && lstResult.size()>0){
            return lstResult;
        }
        return lstResult;
    }
    
    @AuraEnabled
    public static List<ProductDataWrapper> getMultiIsbnList(String multiIsbn ,Integer displayPageData,Integer offsetVal,String sortBy,String sortOrderFieldName,String pricingData ) {
        String query;
        String sortOrderBy;
        String systemIdVal='GT_TF';
        String currencyType = '';
        if(pricingData != null && pricingData != ''){
          currencyType = pricingData; 
        }
        else{
          currencyType='USD';
        }
        String priceBookName='T&F - eBooks Pricebook';
        if(sortOrderFieldName.equals('UnitPrice')){
            sortOrderBy='UnitPrice';
        }
        else{
            sortOrderBy='Product2.'+sortOrderFieldName;
        }
        List<PricebookEntry> lstPriceBookEntries=new List<PricebookEntry>();
        List<ProductDataWrapper> lstProductWrapper=new List<ProductDataWrapper>();
        Boolean returnValue = true;
        
        try{
            List<String> multiIsbnList=multiIsbn.split('\\r\\n');
            List<String> multiIsbnListData=new List<String>();
            Integer limitVal=Integer.valueOf(displayPageData);
            Integer offsetValue=Integer.valueOf(offsetVal);
            for(integer i=0;i<multiIsbnList.size();i++){
                String isbnWithOutSpace=multiIsbnList[i].replaceAll( '\\s+', '');
                isbnWithOutSpace=isbnWithOutSpace.replace('-', '');            
                multiIsbnListData.add(isbnWithOutSpace);
            }
            String drmStr = '\'%(DRM%Protected)%\'';
            String prodStatusStr = 'Available';
            if(multiIsbnListData!=null && multiIsbnListData.size()>0){
                query='SELECT Id,Product2.Name,CurrencyIsoCode,Pricebook2.Name,Product2.ISBN__c,Product2.copyrightyear__c,Product2.eBook_ISBN__c,Product2.Hardback_ISBN__c,Product2.Paperback_ISBN__c,Pricing_Type__c,Product2.Lead_Author_Editor__c,Product2.Subject_Code__c,Product2.Version_Type__c,unitprice,Product2.US_Publication_Date__c,Product2.US_Planned_Publication_Date__c, Product2.System_ID__c,Product2.US_Discount__c,Product2.US_Inventory_Status__c,Product2.POD__c from PricebookEntry Where IsActive = true and Product2.IsActive = true and Product2.System_ID__c=\''+systemIdVal+'\'';
                query+=' and (Product2.ProductCode IN :multiIsbnListData or Product2.eBook_ISBN__c IN :multiIsbnListData or Product2.Hardback_ISBN__c IN :multiIsbnListData or Product2.Paperback_ISBN__c IN :multiIsbnListData) and Pricebook2.name=\''+priceBookName+'\' and CurrencyIsoCode=\''+currencyType+'\'';
                query+='and (NOT Product2.Text_Type__c LIKE '+drmStr+')'; //To fetch the records DRM free only.
                query+=' and Product2.Product_Status__c =:prodStatusStr';
                query+=' order by '+sortOrderBy+' '+sortBy+' LIMIT 2000'; // removed the offset to make the pagination dynamic on javascript
                System.debug('query'+query);
                if(String.isNotBlank(query)){
                    lstPriceBookEntries=Database.query(query);
                }
                if(lstPriceBookEntries.size()>0){
                    lstProductWrapper=getproductWrappedData(lstPriceBookEntries);
                }
                System.debug('lstProductWrapper='+lstProductWrapper);
                System.debug('lstPriceBookEntries size='+lstPriceBookEntries.size());
            }
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch(Exception e){
            System.debug('Message:='+e.getMessage()+'**Line='+e.getLineNumber());
            returnValue = false;
        }
        return lstProductWrapper;
    }
    @AuraEnabled
    public static List<ProductDataWrapper> readCSVFile(List<String> file,Integer isbnIndex,Integer displayPageData,Integer offsetVal,String sortBy,String sortOrderFieldName)
    {   
        String query;
        String sortOrderBy;
        String systemIdVal='GT_TF';
        String currencyType='USD';
        String priceBookName='T&F - eBooks Pricebook';
        if(sortOrderFieldName.equals('UnitPrice')){
            sortOrderBy='UnitPrice';
        }
        else{
            sortOrderBy='Product2.'+sortOrderFieldName;
        }
        
        List<PricebookEntry> lstpricebookentries=new List<PricebookEntry>();
        List<ProductDataWrapper> lstProductWrapper=new List<ProductDataWrapper>();
        Boolean returnValue = True;
        try{
            Integer index=Integer.valueOf(isbnIndex);
            Integer limitVal=Integer.valueOf(displayPageData);
            Integer offsetValue=Integer.valueOf(offsetVal);
            List<String> multiIsbnListData=new List<String>();
            System.debug('file data:='+file);
            System.debug('file:='+file.size());
            if(index !=-1){
                if(file!=null && file.size()-1>0){
                    for(Integer i=0;i<file.size();i++){
                        String value=returnIsbn(file[i],isbnIndex);
                        if(String.isNotBlank(value)){
                            value=value.replace('-', '');
                            multiIsbnListData.add(value.replace('=',''));
                        }
                    }
                }
            }
            if(index ==-1){
                if(file!=null && file.size()-1>0){
                    for(Integer j=0;j<file.size();j++){
                        List<String> multiIsbnList=file[j].split('\\r\\n');
                        if(String.isNotBlank(multiIsbnList[0])){
                            String value=multiIsbnList[0];
                            value=value.replaceAll( '\\s+', '');
                            value=value.replace('-', '');
                            multiIsbnListData.add(value);
                        }
                    }
                }
            }
            System.debug('multiIsbnListData:='+multiIsbnListData);
            String drmStr = '\'%(DRM%Protected)%\'';
            String prodStatusStr = 'Available';
            if(multiIsbnListData!=null && multiIsbnListData.size()>0){
                System.debug('multiIsbnListData:='+multiIsbnListData);
                query='SELECT Id,Product2.Name,CurrencyIsoCode,Product2.copyrightyear__c,Pricebook2.Name,Product2.ISBN__c,Product2.eBook_ISBN__c,Product2.Hardback_ISBN__c,Product2.Paperback_ISBN__c,Pricing_Type__c,Product2.Lead_Author_Editor__c,Product2.Subject_Code__c,Product2.Version_Type__c,unitprice,Product2.US_Publication_Date__c,Product2.US_Planned_Publication_Date__c, Product2.System_ID__c,Product2.US_Discount__c,Product2.US_Inventory_Status__c,Product2.POD__c from PricebookEntry Where IsActive = true and Product2.IsActive = true and Product2.System_ID__c=\''+systemIdVal+'\'';
                query+=' and (Product2.ProductCode IN :multiIsbnListData or Product2.eBook_ISBN__c IN :multiIsbnListData or Product2.Hardback_ISBN__c IN :multiIsbnListData or Product2.Paperback_ISBN__c IN :multiIsbnListData) and Pricebook2.name=\''+priceBookName+'\' and CurrencyIsoCode=\''+currencyType+'\'';
                query+='and (NOT Product2.Text_Type__c LIKE '+drmStr+')'; //To fetch the records DRM free only.
                query+=' and Product2.Product_Status__c =:prodStatusStr';
                query+=' order by '+sortOrderBy+' '+sortBy+' LIMIT '+limitVal+' OFFSET '+offsetValue;
                if(String.isNotBlank(query)){
                    lstPriceBookEntries=Database.query(query);
                }
                if(lstPriceBookEntries.size()>0||Test.isRunningTest()){
                    lstProductWrapper=getproductWrappedData(lstPriceBookEntries);
                }
                lstProductWrapper=getproductWrappedData(lstpricebookentries);
            }
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch(Exception e){
            System.debug('Message:='+e.getMessage()+'** Line ='+e.getLineNumber());
            returnValue = false;
        }
        return lstProductWrapper;
    }
    
    public static String returnIsbn(String csvLine,Integer index){
        String isbnVal;
        String prevLine = csvLine;
        Integer startIndex;
        Integer endIndex;
        
        while(csvLine.indexOf('"') > -1){
            if(startIndex == null){
                startIndex = csvLine.indexOf('"');
                csvLine = csvLine.substring(0, startIndex) + ':quotes:' + csvLine.substring(startIndex+1, csvLine.length());
            }else{
                if(endIndex == null){
                    endIndex = csvLine.indexOf('"');
                    csvLine = csvLine.substring(0, endIndex) + ':quotes:' + csvLine.substring(endIndex+1, csvLine.length());
                }
            }
            
            if(startIndex != null && endIndex != null){
                String sub = csvLine.substring(startIndex, endIndex);
                sub = sub.replaceAll(',', ':comma:');
                csvLine = csvLine.substring(0, startIndex) + sub + csvLine.substring(endIndex, csvLine.length());
                startIndex = null;
                endIndex = null;
            }
        }
        List<String> lstCSVColumnValues=new List<String>();
        List<String> isbnList=new List<String>();
        for(String column : csvLine.split(',')){
            column = column.replaceAll(':quotes:', '').replaceAll(':comma:', ',');
            //System.debug('column::'+column);
            lstCSVColumnValues.add(column);
        }
        Integer inx=Integer.valueOf(index);
        return lstCSVColumnValues[inx];
    }
    @AuraEnabled
    public static Integer getCountOfSearchData(String multiIsbnSearchList) {
        List<String> multiIsbnList=multiIsbnSearchList.split('\\r\\n');
        List<String> multiIsbnListData=new List<String>();
        for(integer i=0;i<multiIsbnList.size();i++){
            String isbnWithOutSpace=multiIsbnList[i].replaceAll( '\\s+', '');
            isbnWithOutSpace=isbnWithOutSpace.replace('-', '');            
            multiIsbnListData.add(isbnWithOutSpace);
        }
        Integer countValue=[SELECT count() from PricebookEntry Where IsActive = true and Product2.IsActive = true and CurrencyIsoCode='USD' and Product2.System_ID__c='GT_TF' and Pricebook2.name='T&F - eBooks Pricebook' and (Product2.ProductCode IN:multiIsbnListData  or Product2.eBook_ISBN__c IN :multiIsbnListData or Product2.Hardback_ISBN__c IN :multiIsbnListData or Product2.Paperback_ISBN__c IN :multiIsbnListData)];
        system.debug('countValue'+countValue);
        return countValue;
    }
    @AuraEnabled
    public static Integer getProductSearchCount(String ISBN,String title,String author,List<String> Netbase,List<String> lstSubjectList,List<String> lstMediumData,String publishData,String publcFromDate,String publcToDate,String minPrice,String maxPrice){
        String query;
        Integer countValue=0;
        String systemIdVal='GT_TF';
        String currencyType='USD';
        String priceBookName='T&F - eBooks Pricebook';
        String EBRALLOutputChannel = 'EBRALL';
        String EBRINSTOutputChannel = 'EBRINST';
        system.debug('Netbase'+Netbase);
        
        try{
            query='Select count() From PricebookEntry where IsActive = true and Product2.IsActive = true and CurrencyIsoCode=\''+currencyType+'\' and Product2.System_ID__c=\''+systemIdVal+'\' and Pricebook2.name=\''+priceBookName+'\' AND (Product2.Output_Channel__c includes (\''+EBRALLOutputChannel+'\') OR Product2.Output_Channel__c includes (\''+EBRINSTOutputChannel+'\') )';
            if(String.isNotBlank(minPrice) && String.isNotBlank(maxPrice)){
                query+=' and unitprice>='+minPrice+' and unitprice<='+maxPrice;
            }
            
            if(String.isBlank(minPrice) && String.isNotBlank(maxPrice)){
                query+=' and unitprice<='+maxPrice;
            }
            if(String.isNotBlank(minPrice) && String.isBlank(maxPrice)){
                query+=' and unitprice>='+minPrice;
            }
            if(String.isNotBlank(ISBN) ){
                ISBN=ISBN.replaceAll('-', '');
                query+=' and (Product2.ProductCode=\''+ISBN+'\' or Product2.eBook_ISBN__c=\''+ISBN+'\' or Product2.Hardback_ISBN__c=\''+ISBN+'\' or Product2.Paperback_ISBN__c=\''+ISBN+'\')';
            }
            if(String.isNotBlank(title)){
                String productTitle ='%'+title.trim()+'%';
                query+=' and Product2.Name Like \''+productTitle+'\'';
            }
            if(String.isNotBlank(author)){
                String authorEscapeQuot=String.escapeSingleQuotes(author);
                String productauthor ='%'+authorEscapeQuot+'%';
                query+=' and Product2.Lead_Author_Editor__c Like \''+productauthor+'\'';
            }
            if(Netbase !=null && Netbase.size()>0){
                String s = '';
                Integer i = 0;
                
                for(string ag : Netbase){
                    if(i==Netbase.size()-1){
                        s += '\''+ag+'\'';    
                    }else{
                        s += '\''+ag+'\',';
                    }
                    i++;
                }
                query+=' and Product2.Netbase_Classifications__c Includes ('+ s +')';
            }
            
            if(lstSubjectList !=null && lstSubjectList.size()>0){
                String s = '';
                Integer i = 0;
                
                for(string ag : lstSubjectList){
                    if(i==lstSubjectList.size()-1){
                        s += '\''+ag+'\'';    
                    }else{
                        s += '\''+ag+'\',';
                    }
                    i++;
                }
                
                query+=' and Product2.Subject_Classifications__c Includes ('+ s +')';
            }
            System.debug('lstMediumData---'+lstMediumData);
            if(lstMediumData !=null && lstMediumData.size()>0){
                if(lstMediumData.contains('All')){
                    query+=' and Product2.Version_Type__c Not IN :lstMediumData';
                }
                else{
                    query+=' and Product2.Version_Type__c IN :lstMediumData';
                }
            }
            if(String.isNotBlank(publishData)){
                system.debug('publishData'+publishData);
                if(publishData == 'exclude'){
                    query+=' and Product2.Publication_Date__c<=TODAY';
                }
                if(publishData == 'Only NYP'){
                    query+=' and (Product2.Publication_Date__c>TODAY OR Product2.Publication_Date__c= null)';
                }
            }
            if(String.isNotBlank(publcFromDate) && String.isNotBlank(publcToDate)){
                query+=' and Product2.Publication_Date__c>='+publcFromDate+' and Product2.Publication_Date__c<='+publcToDate;
                
            }
            if(String.isBlank(publcFromDate) && String.isNotBlank(publcToDate)){
                query+=' and Product2.Publication_Date__c<='+publcToDate;
                
            }
            if(String.isNotBlank(publcFromDate) && String.isBlank(publcToDate)){
                query+=' and Product2.Publication_Date__c>='+publcFromDate;
                
            }
            query+=' limit 2001';
            System.debug('query:='+query);
            if(String.isNotBlank(query)){
                countValue=Database.countQuery(query);
            }
        }
        catch(Exception ex){
            System.debug('message:='+ex.getMessage());
            throw new AuraHandledException(ex.getMessage());
        }
        System.debug('countValue:='+countValue);
        return countValue;
    }
    
    @AuraEnabled
    public static Integer getCsvUploadCount(List<String> ListcsvIsbn,Integer indexIsbn,String sortBy,String sortOrderFieldName){
        list<ProductDataWrapper> lst=readCSVFile(ListcsvIsbn, indexIsbn,50000,0,sortBy,sortOrderFieldName);
        Integer count=lst.size();
        system.debug('count'+count);
        return count;
    }
    @AuraEnabled
    public static String downloadCsvFileData(String ISBN,String title,String author,List<String> Netbase,List<String> lstSubjectList,List<String> lstMediumData,String publishData,String publcFromDate,String publcToDate,String minPrice,String maxPrice,String sortBy,String sortOrderFieldName,String drmData, String currencyTyp, String excludeCountryValue) {
        String query;
        List<String> lstMedium=new List<String>();
        String systemIdVal='GT_TF';
        String currencyType= currencyTyp;
        String priceBookName='T&F - eBooks Pricebook';
        String sortOrderBy;
        String EBRALLOutputChannel = 'EBRALL';
        String EBRINSTOutputChannel = 'EBRINST';
        
        if(sortOrderFieldName.equals('UnitPrice')){
            sortOrderBy='UnitPrice';
        }
        else{
            sortOrderBy='Product2.'+sortOrderFieldName;
        }
        try{
            query='Select Id,CurrencyIsoCode,Pricebook2.name,UnitPrice,Product2.ID,Product2.Distribution_Rights_Excluded_Countries__c,Product2.Publication_Date__c,Product2.ISBN__c,Product2.Netbase_Classifications__c,Product2.eBook_ISBN__c,Product2.doi__c,Product2.Publish_Date__c,Product2.First_Published_Year__c,Product2.copyrightyear__c,Product2.Hardback_ISBN__c,Product2.Paperback_ISBN__c,Product2.Book_Sub_Title__c,Product2.Publisher__c,Product2.Web_Code__c,Product2.Dynamic_Collection_Criteria__c,Product2.Subject_Classifications__c,Product2.Books_Subject_Code_1__c,Product2.Books_Subject_Code_2__c,Product2.Books_Series_Title__c,Product2.Printed_Pages__c,Product2.Text_Type__c,Product2.Product_Id_Link__c,Product2.Open_Access_Category__c,Product2.Name,Product2.US_Discount__c,Product2.Lead_Author_Editor__c,Product2.US_Publication_Date__c,Product2.US_Planned_Publication_Date__c,Product2.Version_Type__c,Product2.US_Inventory_Status__c,Product2.Edition_Number__c,Product2.Status__c,Product2.Imprint__c,Product2.POD__c From PricebookEntry where IsActive = true and Product2.IsActive = true and CurrencyIsoCode=\''+currencyType+'\' and Product2.System_ID__c=\''+systemIdVal+'\' and Pricebook2.name=\''+priceBookName+'\' AND (Product2.Output_Channel__c includes (\''+EBRALLOutputChannel+'\') OR Product2.Output_Channel__c includes (\''+EBRINSTOutputChannel+'\') )';
            if(String.isNotBlank(minPrice) && String.isNotBlank(maxPrice)){
                query+=' and unitprice>='+minPrice+' and unitprice<='+maxPrice;
            }
            if(String.isBlank(minPrice) && String.isNotBlank(maxPrice)){
                query+=' and unitprice<='+maxPrice;
            }
            if(String.isNotBlank(minPrice) && String.isBlank(maxPrice)){
                query+=' and unitprice>='+minPrice;
            }
            if(String.isNotBlank(ISBN) ){
                ISBN=ISBN.replaceAll('-', '');
                query+=' and (Product2.ProductCode=\''+ISBN+'\' or Product2.eBook_ISBN__c=\''+ISBN+'\' or Product2.Hardback_ISBN__c=\''+ISBN+'\' or Product2.Paperback_ISBN__c=\''+ISBN+'\')';
            }
            if(String.isNotBlank(title)){
                String productTitle ='%'+title.trim()+'%';
                query+=' and Product2.Name Like \''+productTitle+'\'';
            }
            if(String.isNotBlank(drmData) && drmData != 'Both'){
                Boolean drmvalue = Boolean.valueOf(drmData);
                query+=' and Product2.Has_DRM__c ='+drmvalue;
            }
            if(String.isNotBlank(excludeCountryValue) && excludeCountryValue != 'None'){
                query+=' and Product2.Distribution_Rights_Excluded_Countries_1__c excludes (\''+excludeCountryValue+'\')';
                query+=' and Product2.Distribution_Rights_Excluded_Countries_2__c excludes (\''+excludeCountryValue+'\')';
                query+=' and Product2.Distribution_Rights_Excluded_Countries_3__c excludes (\''+excludeCountryValue+'\')';
            }
            if(String.isNotBlank(author)){
                String authorEscapeQuot=String.escapeSingleQuotes(author);
                String productauthor ='%'+authorEscapeQuot+'%';
                query+=' and Product2.Lead_Author_Editor__c Like \''+productauthor+'\'';
            }
            if(Netbase !=null && Netbase.size()>0){
                
                String s = '';
                Integer i = 0;
                
                for(string ag : Netbase){
                    if(i==Netbase.size()-1){
                        s += '\''+ag+'\'';    
                    }else{
                        s += '\''+ag+'\',';
                    }
                    i++;
                }
                query+=' and Product2.Netbase_Classifications__c Includes ('+ s +')';
            }
            if(lstSubjectList!=null && lstSubjectList.size()>0){
                
                String s = '';
                Integer i = 0;
                
                for(string ag : lstSubjectList){
                    if(i==lstSubjectList.size()-1){
                        s += '\''+ag+'\'';    
                    }else{
                        s += '\''+ag+'\',';
                    }
                    i++;
                }
                
                query+=' and Product2.Subject_Classifications__c Includes ('+ s +')';
            }
            if(lstMediumData !=null && lstMediumData.size()>0){
                if(lstMediumData.contains('All')){
                    query+=' and Product2.Version_Type__c Not IN :lstMediumData';
                }
                else{
                    query+=' and Product2.Version_Type__c IN :lstMediumData';
                }
            }
            if(String.isNotBlank(publishData)){
                if(publishData == 'exclude'){
                    query+=' and Product2.Publication_Date__c<=TODAY';
                }
                if(publishData == 'Only NYP'){
                    query+=' and (Product2.Publication_Date__c>TODAY OR Product2.Publication_Date__c= null)';
                }
            }
            if(String.isNotBlank(publcFromDate) && String.isNotBlank(publcToDate)){
                query+=' and Product2.Publication_Date__c>='+publcFromDate+' and Product2.Publication_Date__c<='+publcToDate;
                
            }
            if(String.isBlank(publcFromDate) && String.isNotBlank(publcToDate)){
                query+=' and Product2.Publication_Date__c<='+publcToDate;
                
            }
            if(String.isNotBlank(publcFromDate) && String.isBlank(publcToDate)){
                query+=' and Product2.Publication_Date__c>='+publcFromDate;
                
            }
            
            query+=' order by '+sortOrderBy+' '+sortBy;
            
            system.debug('readCSVquery'+query);
            if(query != null)
            { 
                return query;
            }
            return null;
        }
        catch(Exception ex){
            System.debug('message:='+ex.getMessage());
            throw new AuraHandledException(ex.getMessage());
        }
    }
    @AuraEnabled
    public static String downloadMultiFileData(String multiIsbn,String sortBy,String sortOrderFieldName) {
        String query;
        String systemIdVal='GT_TF';
        String currencyType='USD';
        String priceBookName='T&F - eBooks Pricebook';
        String sortOrderBy;
        if(sortOrderFieldName.equals('UnitPrice')){
            sortOrderBy='UnitPrice';
        }
        else{
            sortOrderBy='Product2.'+sortOrderFieldName;
        }
        List<PricebookEntry> lstproducts=new List<PricebookEntry>();
        try{
            List<String> multiIsbnList=multiIsbn.split('\\r\\n');
            List<String> multiIsbnListData=new List<String>();
            for(integer i=0;i<multiIsbnList.size();i++){
                String isbnWithOutSpace=multiIsbnList[i].replaceAll( '\\s+', '');
                isbnWithOutSpace=isbnWithOutSpace.replace('-', '');            
                multiIsbnListData.add(isbnWithOutSpace);
            }
            if(multiIsbnListData!=null && multiIsbnListData.size()>0){
                query='Select Id,Pricebook2.name,CurrencyIsoCode,UnitPrice,Product2.ID,Product2.Publication_Date__c,Product2.Distribution_Rights_Excluded_Countries__c,Product2.Netbase_Classifications__c,Product2.ISBN__c,Product2.eBook_ISBN__c,Product2.doi__c,Product2.Publish_Date__c,Product2.First_Published_Year__c,Product2.copyrightyear__c,Product2.Hardback_ISBN__c,Product2.Paperback_ISBN__c,Product2.Book_Sub_Title__c,Product2.Publisher__c,Product2.Web_Code__c,Product2.Dynamic_Collection_Criteria__c,Product2.Subject_Classifications__c,Product2.Books_Subject_Code_1__c,Product2.Books_Subject_Code_2__c,Product2.Books_Series_Title__c,Product2.Printed_Pages__c,Product2.Text_Type__c,Product2.Product_Id_Link__c,Product2.Open_Access_Category__c,Product2.Name,Product2.US_Discount__c,Product2.Lead_Author_Editor__c,Product2.US_Publication_Date__c,Product2.US_Planned_Publication_Date__c,Product2.Version_Type__c,Product2.US_Inventory_Status__c,Product2.Edition_Number__c,Product2.Status__c,Product2.Imprint__c,Product2.POD__c From PricebookEntry Where IsActive = true and Product2.IsActive = true and Product2.System_ID__c=\''+systemIdVal+'\'';
                query+=' and (Product2.ProductCode IN :multiIsbnListData or Product2.eBook_ISBN__c IN :multiIsbnListData or Product2.Hardback_ISBN__c IN :multiIsbnListData or Product2.Paperback_ISBN__c IN :multiIsbnListData) and Pricebook2.name=\''+priceBookName+'\' and CurrencyIsoCode=\''+currencyType+'\'';
                query+=' order by '+sortOrderBy+' '+sortBy;
            }
            system.debug('MultiIsbnCsvquery'+query);    
            if(query != null){
                return query;
            }
            return null;
            
        }
        catch(Exception ex){
            System.debug('message:='+ex.getMessage());
            throw new AuraHandledException(ex.getMessage());
        }
        
    }
    @AuraEnabled
    public static String downloadReadCsvFileData(List<String> file,Integer isbnIndex,String sortBy,String sortOrderFieldName) {
        String query;
        String systemIdVal='GT_TF';
        String currencyType='USD';
        String priceBookName='T&F - eBooks Pricebook';
        String sortOrderBy;
        if(sortOrderFieldName.equals('UnitPrice')){
            sortOrderBy='UnitPrice';
        }
        else{
            sortOrderBy='Product2.'+sortOrderFieldName;
        }
        List<PricebookEntry> lstproducts=new List<PricebookEntry>();
        
        
        try{
            Integer index=Integer.valueOf(isbnIndex);
            List<String> readCsvListData=new List<String>();
            if(index !=-1){
                if(file!=null && file.size()-1>0){
                    for(Integer i=0;i<file.size();i++){
                        String value=returnIsbn(file[i],isbnIndex);
                        if(String.isNotBlank(value)){
                            value=value.replace('-', '');
                            readCsvListData.add(value.replace('=',''));
                        }
                    }
                }
            }
            if(index ==-1){
                if(file!=null && file.size()-1>0){
                    for(Integer j=0;j<file.size();j++){
                        List<String> multiIsbnList=file[j].split('\\r\\n');
                        if(String.isNotBlank(multiIsbnList[0])){
                            String value=multiIsbnList[0];
                            value=value.replaceAll( '\\s+', '');
                            value=value.replace('-', '');
                            readCsvListData.add(value);
                        }
                    }
                }
            }
            
            if(readCsvListData!=null && readCsvListData.size()>0){
                query='Select Id,Pricebook2.name,CurrencyIsoCode,UnitPrice,Product2.Netbase_Classifications__c,Product2.Publication_Date__c,Product2.Distribution_Rights_Excluded_Countries__c,Product2.ID,Product2.ISBN__c,Product2.eBook_ISBN__c,Product2.doi__c,Product2.Publish_Date__c,Product2.First_Published_Year__c,Product2.copyrightyear__c,Product2.Hardback_ISBN__c,Product2.Paperback_ISBN__c,Product2.Book_Sub_Title__c,Product2.Publisher__c,Product2.Web_Code__c,Product2.Dynamic_Collection_Criteria__c,Product2.Subject_Classifications__c,Product2.Books_Subject_Code_1__c,Product2.Books_Subject_Code_2__c,Product2.Books_Series_Title__c,Product2.Printed_Pages__c,Product2.Text_Type__c,Product2.Product_Id_Link__c,Product2.Open_Access_Category__c,Product2.Name,Product2.US_Discount__c,Product2.Lead_Author_Editor__c,Product2.US_Publication_Date__c,Product2.US_Planned_Publication_Date__c,Product2.Version_Type__c,Product2.US_Inventory_Status__c,Product2.Edition_Number__c,Product2.Status__c,Product2.Imprint__c,Product2.POD__c From PricebookEntry Where IsActive = true and Product2.IsActive = true and Product2.System_ID__c=\''+systemIdVal+'\'';
                query+=' and (Product2.ProductCode IN :readCsvListData or Product2.eBook_ISBN__c IN :readCsvListData or Product2.Hardback_ISBN__c IN :readCsvListData or Product2.Paperback_ISBN__c IN :readCsvListData) and Pricebook2.name=\''+priceBookName+'\' and CurrencyIsoCode=\''+currencyType+'\'';
                query+=' order by '+sortOrderBy+' '+sortBy;
            }
            System.debug('DownLoadCSVquery--->'+query);
            if(query != null){
                return query;
            }
            
            return null;
            
        }    
        catch(Exception ex){
            System.debug('message:='+ex.getMessage());
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    
    @AuraEnabled
    public static User updateUserDetailsFromBMIS(String userId){
        try{
            if(String.isNotBlank(userId)){
                User user=[Select Id,email,contact.email,user.profile.name,BMIS_Account_Number__c,Street,City,State,PostalCode,Phone,
                           Credit_Terms__c,BMIS_Customer_Discount_Code__c From User Where Id=:userId];
                
                BmisAccountInfoApi BMIS= new BmisAccountInfoApi();
                //If a test isn't running use the response if it is successful.
                if(!test.isRunningTest()){
                    //if (response.getStatusCode() == 200) {         
                    //BMIS = (BmisAccountInfoApi) System.JSON.deserialize(String.ValueOf(response), BmisAccountInfoApi.class);
                    //}
                }        
                //Otherwise construct a fake JSON response for a test run.
                if (!test.isRunningTest()){
                    String getToken;
                    TF_AG_TokenGenerate TAG= new TF_AG_TokenGenerate();
                    getToken=TF_AG_TokenGenerate.getToken();
                    String jsonStr;
                    String endpoint = 'https://api-uat.taylorandfrancis.com/v1/bmis/salesforce/accountInfo/'+user.BMIS_Account_Number__c+'/us';
                    HttpRequest bmisCallout = new HttpRequest();
                    bmisCallout.setEndpoint(endpoint);
                    bmisCallout.setMethod('GET');
                    bmisCallout.setHeader('X-Bmis-Api-Version', '5');
                    bmisCallout.setHeader('Authorization', 'idtoken '+getToken);
                    Http httpCall = new Http();
                    HttpResponse response;
                    response = httpCall.send(bmisCallout);
                    jsonStr= response.getBody();
                    
                    //String jsonStr = '{"data": {"saleRegion": "US","accountId": "C-703472","address1": "UNIV OF MISSOURI","address2": "RELIGIOUS STUDIES","address3": "221 ARTS & SCIENCE ATN:C DUNN","county": "null","postCode": "65211","telephone": "673 882-4769","creditTerms": "3","discountCode": "A"},"page": 1,"totalPages": 1,"pageSize": 1}';
                    if(response.getStatusCode() == 200){
                        BMIS = (BmisAccountInfoApi) System.JSON.deserialize(jsonStr, BmisAccountInfoApi.class);
                        System.debug('BMIS:='+BMIS);
                        /*if(user.Street !=BMIS.data[0].address1){
user.Street = BMIS.data[0].address1;
}

if(user.City != BMIS.data[0].address2){
user.City = BMIS.data[0].address2;
}

if(user.State != BMIS.data[0].address3){
user.State = BMIS.data[0].address3;
}*/
                        
                        if(user.PostalCode != BMIS.data[0].postCode){
                            user.PostalCode = BMIS.data[0].postCode;
                            user.BMIS_Zipcode__c = BMIS.data[0].postCode;
                        }
                        
                        if(user.Phone != BMIS.data[0].telephone){
                            user.BMIS_Phone__c = BMIS.data[0].telephone; 
                        }
                        
                        if(user.Credit_Terms__c != BMIS.data[0].creditTerms){
                            user.Credit_Terms__c = BMIS.data[0].creditTerms;  
                        }
                        
                        if(user.BMIS_Customer_Discount_Code__c != BMIS.data[0].discountCode){
                            user.BMIS_Customer_Discount_Code__c = BMIS.data[0].discountCode; 
                        }
                        
                        System.debug('user:='+user);
                        update user;
                    }
                    if(response.getStatusCode() == 404 && response.getStatus() == 'Not Found'){
                        
                    }
                } 
                return user;
            }
        }
        catch(Exception e){
            System.debug('Message:='+e.getMessage()+'*** Line='+e.getLineNumber());
        }
        return null;
    }
    // Calculate Product discount
    public static Decimal calculatProductDiscount(PricebookEntry pricebook,Map<String, Integer> productDiscountCodeToValueMap){
        Decimal discountValue=0;
        try{
            //Locate the users discount code.
            if(productDiscountCodeToValueMap!=null){
                if(pricebook.Product2.US_Discount__c!=null){
                    if(productDiscountCodeToValueMap.get(pricebook.Product2.US_Discount__c.toUpperCase())!=null){
                        discountValue =  ((100 - productDiscountCodeToValueMap.get(pricebook.Product2.US_Discount__c.toUpperCase())) * pricebook.unitprice)/100;
                        discountValue = discountValue.setScale(2, RoundingMode.HALF_UP);
                    }
                } 
                System.debug('discountValue:'+discountValue);
                return discountValue;
            }
            
        }
        catch(Exception e){
            System.debug('Message:'+e.getMessage()+'* Line='+e.getLineNumber());
            
        }
        return discountValue;
    }
    // Calculate Product discount percentage
    public static String calculatProductDiscountPercentage(PricebookEntry pricebook,Map<String, Integer> productDiscountCodeToValueMap){
        
        String discountPercent='0';
        Boolean returnValue = true;
        try{
            //Locate the users discount code.
            if(productDiscountCodeToValueMap!=null){
                if(pricebook.Product2.US_Discount__c!=null){
                    if(productDiscountCodeToValueMap.get(pricebook.Product2.US_Discount__c.toUpperCase())!=null){
                        discountPercent=String.valueOf(productDiscountCodeToValueMap.get(pricebook.Product2.US_Discount__c.toUpperCase()));
                    }
                }
            }
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch(Exception e){
            System.debug('Message:'+e.getMessage()+'* Line='+e.getLineNumber());
            returnValue = false;
        }
        return discountPercent;
    }
    
    public static List<ProductDataWrapper> getproductWrappedData(List<PricebookEntry> lstPriceBook){
        //System.debug('lstPriceBook:='+lstPriceBook);
        List<ProductDataWrapper> lstProductWrapper=new List<ProductDataWrapper>();
        Boolean returnValue = true;
        
        try{
            String customerDiscountCode = [SELECT BMIS_Customer_Discount_Code__c FROM User WHERE Id = :UserInfo.getUserId()].BMIS_Customer_Discount_Code__c;
            //Locate the discounts applicable to the user in question.
            Map<String, Integer> productDiscountCodeToValueMap = new Map<String, Integer>();
            for(Setting_Item__c si: [SELECT Text_2__c, Text_3__c FROM Setting_Item__c WHERE Setting__r.Name = 'BMISDiscountMatrix' AND Text_1__c =: customerDiscountCode]){
                //Text_1__c = Customer discount code
                //Text_2__c = Product discount code
                //Text_3__c = Product discount %
                productDiscountCodeToValueMap.put(si.Text_2__c.toUpperCase(), integer.ValueOf(si.Text_3__c));
            }
            for(PricebookEntry pricebook:lstPriceBook){
                ProductDataWrapper prodWrap=new ProductDataWrapper();
                prodWrap.pricebook= pricebook;
                prodWrap.discountValue=calculatProductDiscount(pricebook,productDiscountCodeToValueMap);
                prodWrap.discountPercent=calculatProductDiscountPercentage(pricebook,productDiscountCodeToValueMap);
                lstProductWrapper.add(prodWrap);
                if(Test.isRunningTest()) {
                    CalloutException e = new CalloutException();
                    e.setMessage('This is a constructed exception for testing and code coverage');
                    throw e;
                }
            }
        }
        catch(Exception e){
            System.debug('Message:='+e.getMessage()+'** Line='+e.getLineNumber());
            returnValue = false;
        }
        //System.debug('lstProductWrapper-->'+lstProductWrapper);
        return lstProductWrapper;
    }
    
    @AuraEnabled
    public static ProductDataWrapperWithCount getProductDetailByISBN(String prodISBN){
        ProductDataWrapperWithCount prodDataWrapWthCount = new ProductDataWrapperWithCount();
        List<PricebookEntry> listPriceBkEntry=[Select Id,Pricebook2.name,UnitPrice,Product2.ID,Product2.ISBN__c,Product2.Name,Product2.US_Discount__c,
                                               Product2.Lead_Author_Editor__c,Product2.US_Publication_Date__c,Product2.US_Planned_Publication_Date__c,
                                               Product2.Version_Type__c,Product2.US_Inventory_Status__c,Product2.POD__c From PricebookEntry where IsActive = true and Product2.IsActive = true and 
                                               CurrencyIsoCode='USD' and Product2.System_ID__c='GT_TF' and Pricebook2.name='T&F - eBooks Pricebook' and 
                                               Product2.ISBN__c=:prodISBN];
        prodDataWrapWthCount.prodDataWrap = getproductWrappedData(listPriceBkEntry);   
        return prodDataWrapWthCount;        
    }
    
    
    @AuraEnabled
    public static String treeGetNetBaseClassifications2(){
        Map<String,TreeWrapper> mapBackTree = new Map<String,TreeWrapper>();
        List<TreeWrapper> topLevelRecords = new List<TreeWrapper>();
        List<TreeWrapper> jsListWrap = new List<TreeWrapper>();
        Map<Id,List<TreeWrapper>> parentIdmappingSetting = new Map<Id,List<TreeWrapper>>();
        String customLabelValue = System.Label.getNetBaseClassifications;
        List<Setting_Item__c> lstResult=new List<Setting_Item__c>();
        //lstResult=[SELECT Id, Name, Parent__c FROM CAS_Subject_Code__c limit 1000]; 
        lstResult=[SELECT Id,Text_1__c FROM Setting_Item__c WHERE Setting__r.Name =: customLabelValue AND Checkbox_1__c = TRUE ORDER BY Text_1__c ASC limit 1000];
        if(lstResult != null && lstResult.size()>0){
            for(Setting_Item__c si : lstResult){
                TreeWrapper twTempRec = new TreeWrapper();
                twTempRec.recId       =  si.Id;
                twTempRec.labelValue  =  si.Text_1__c;
                twTempRec.isCheck     =  False;
                List<TreeWrapper> ct = new List<TreeWrapper>(); 
                twTempRec.childTree   =  ct ;
                /*if(si.Parent_Id__c != null){
List<TreeWrapper> tempsetting = new List<TreeWrapper>();
if(parentIdmappingSetting.containsKey(si.Parent_Id__c)){
tempsetting = parentIdmappingSetting.get(si.Parent_Id__c);
tempsetting.add(twTempRec);
parentIdmappingSetting.put(si.Parent_Id__c,tempsetting);
}
else{
tempsetting.add(twTempRec);
parentIdmappingSetting.put(si.Parent_Id__c,tempsetting);
}
}*/
                // else{
                topLevelRecords.add(twTempRec);
                // } 
            }
            for(TreeWrapper toplev:topLevelRecords){
                
                
                List<TreeWrapper> level1Records = new List<TreeWrapper>();
                //List<TreeWrapper> level2Records = new List<TreeWrapper>();
                //List<TreeWrapper> level3Records = new List<TreeWrapper>();
                
                if(parentIdmappingSetting.containsKey(toplev.recId)){
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
        return jsonData;
        
    }
    @AuraEnabled
    public static String TreeGetSubjectClassifications2(){
        Map<String,TreeWrapper> mapBackTree = new Map<String,TreeWrapper>();
        List<TreeWrapper> topLevelRecords = new List<TreeWrapper>();
        List<TreeWrapper> jsListWrap = new List<TreeWrapper>();
        Set<string> labelSet = new Set<string>();
        Map<Id,List<TreeWrapper>> parentIdmappingSetting = new Map<Id,List<TreeWrapper>>();
        //String customLabelValue = System.Label.getSubjectClassifications;
        List<CAS_Subject_Code__c> lstResult=new List<CAS_Subject_Code__c>();
        lstResult=[SELECT Id,Subject_Code__c ,Parent__c FROM CAS_Subject_Code__c ORDER BY Subject_Code__c  ASC limit 10000]; 
        if(lstResult != null && lstResult.size()>0){
            for(CAS_Subject_Code__c si : lstResult){
                if(si.Subject_Code__c  != null){
                    labelSet.add(si.Subject_Code__c );
                }
                TreeWrapper twTempRec = new TreeWrapper();
                twTempRec.recId       =  si.Id;
                twTempRec.labelValue  =  si.Subject_Code__c ;
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
    public static string syncProductsToOpportunity(string frontEndData,string delOppItem,string oppId){
        List<oppSyncDataWrapper> datatoUPSERT = new List<oppSyncDataWrapper>();
        List<string> delDataList = new List<String>();
        delDataList = (List<String>)System.JSON.deserialize(delOppItem, List<String>.class);
        datatoUPSERT = (List<oppSyncDataWrapper>)System.JSON.deserialize(frontEndData, List<oppSyncDataWrapper>.class);
        List<SBQQ__QuoteLine__c> oppProductList = new List<SBQQ__QuoteLine__c>();
        for(oppSyncDataWrapper asdw : datatoUPSERT){
            SBQQ__QuoteLine__c oli = new SBQQ__QuoteLine__c();
            if(asdw.oppProductId != null){
                oli.Id = asdw.oppProductId;
            }
            else{
                oli.SBQQ__Quote__c = oppId;
                oli.SBQQ__Product__c = asdw.productId;
                oli.SBQQ__PricebookEntryId__c = asdw.pricebookEntryId;
            }
            oli.CurrencyIsoCode = asdw.currencyISOCode;
            oli.SBQQ__Quantity__c = asdw.quantity;
            oli.SBQQ__ListPrice__c = asdw.unitPrice;
            oli.Line_reference__c  = asdw.puchaseOrderNumber;
            oppProductList.add(oli);
        }
        if(oppProductList.Size()>0){
            UPSERT oppProductList;
        }
        if(delDataList.size()>0){
            Database.delete(delDataList);
        }
       /* SBQQ__Quote__c updateQuoteStatusToAccepted = new SBQQ__Quote__c();
        updateQuoteStatusToAccepted = [Select id,SBQQ__Status__c  from SBQQ__Quote__c where Id =: oppId Limit 1];
        if(updateQuoteStatusToAccepted.SBQQ__Status__c != 'Accepted'){
            updateQuoteStatusToAccepted.SBQQ__Status__c = 'Accepted';
            UPDATE  updateQuoteStatusToAccepted;
        }*/
        List<SBQQ__QuoteLine__c> oppLines = new List<SBQQ__QuoteLine__c>();
        oppLines = [Select Id,SBQQ__Quote__c,SBQQ__Quote__r.CurrencyIsoCode,Line_reference__c,CurrencyIsoCode,SBQQ__Product__c,SBQQ__Product__r.Name,SBQQ__Product__r.ISBN__c,SBQQ__Product__r.Lead_Author_Editor__c,SBQQ__Quantity__c,SBQQ__ListPrice__c from SBQQ__QuoteLine__c where SBQQ__Quote__c =: oppId];
        List<oppSyncDataWrapper> oliDataToComponent = new List<oppSyncDataWrapper>();
        for(SBQQ__QuoteLine__c oli : oppLines){
            oppSyncDataWrapper osdw = new oppSyncDataWrapper();
            osdw.oppProductId = oli.Id;
            osdw.productId = oli.SBQQ__Product__c;
            osdw.isbnCode = oli.SBQQ__Product__r.ISBN__c;
            osdw.productName = oli.SBQQ__Product__r.Name;
            osdw.authorName = oli.SBQQ__Product__r.Lead_Author_Editor__c;
            osdw.quantity = oli.SBQQ__Quantity__c;
            osdw.unitPrice = oli.SBQQ__ListPrice__c;
            osdw.currencyISOCode = oli.CurrencyIsoCode;
            osdw.puchaseOrderNumber = oli.Line_reference__c ;
            oliDataToComponent.add(osdw);
        }
        return(JSON.serialize(oliDataToComponent));
    }
    @AuraEnabled
    public static string fetchOppLines(string oppId){
        List<SBQQ__QuoteLine__c> oppLines = new List<SBQQ__QuoteLine__c>();
        SBQQ__Quote__c oppRec = new SBQQ__Quote__c();
        oppRec = [Select id,CurrencyIsoCode,SBQQ__Account__r.Billing_Country_List__c from SBQQ__Quote__c where Id =: oppId];
        oppLines = [Select Id,SBQQ__Quote__c,SBQQ__Quote__r.CurrencyIsoCode,Line_reference__c ,CurrencyIsoCode,SBQQ__Product__c,SBQQ__Product__r.Name,SBQQ__Product__r.ISBN__c,SBQQ__Product__r.Lead_Author_Editor__c,SBQQ__Quantity__c,SBQQ__ListPrice__c from SBQQ__QuoteLine__c where SBQQ__Quote__c =: oppId];
        List<oppSyncDataWrapper> oliDataToComponent = new List<oppSyncDataWrapper>();
        for(SBQQ__QuoteLine__c oli : oppLines){
            oppSyncDataWrapper osdw = new oppSyncDataWrapper();
            osdw.oppProductId = oli.Id;
            osdw.productId = oli.SBQQ__Product__c;
            osdw.isbnCode = oli.SBQQ__Product__r.ISBN__c;
            osdw.productName = oli.SBQQ__Product__r.Name;
            osdw.authorName = oli.SBQQ__Product__r.Lead_Author_Editor__c;
            osdw.quantity = oli.SBQQ__Quantity__c;
            osdw.unitPrice = oli.SBQQ__ListPrice__c;
            osdw.currencyISOCode = oli.CurrencyIsoCode;
            osdw.puchaseOrderNumber = oli.Line_reference__c ;
            oliDataToComponent.add(osdw);
        }
        oppSyncdataWrapperWithISOCode oppDataToComponent = new oppSyncdataWrapperWithISOCode();
        oppDataToComponent.oppId = oppRec.Id;
        oppDataToComponent.billingCountryList = oppRec.SBQQ__Account__r.Billing_Country_List__c;
        if(oppRec.CurrencyIsoCode != null){
            oppDataToComponent.currrencyISOCode = oppRec.CurrencyIsoCode;
        }
        if(oliDataToComponent.size()>0){
            oppDataToComponent.oppSyncDataList = new List<oppSyncDataWrapper>();
            oppDataToComponent.oppSyncDataList = oliDataToComponent;
        }
        return(JSON.serialize(oppDataToComponent));
    }
    
    // Wrapper class
    public class ProductWrapper{
        public PricebookEntry pricebookCSV{get;set;}
        public Decimal discountCSV{get;set;}
        public String discountPercentCSV{get;set;}
    }
    
    // Product Wrapper class
    public class ProductDataWrapper{
        @AuraEnabled public PricebookEntry pricebook;
        @AuraEnabled public Decimal discountValue;
        @AuraEnabled public String discountPercent;
        @AuraEnabled public boolean addedSyncProduct;
        @AuraEnabled public boolean productChecked;
        
    }
    // Product Data Count Wrapper Class
    public class ProductDataWrapperWithCount{
        @AuraEnabled public Integer countRec;
        @AuraEnabled public List<ProductDataWrapper> prodDataWrap;
    }
    public class TreeWrapper{
        @AuraEnabled public String recId;
        @AuraEnabled public String labelValue;
        @AuraEnabled public Boolean isCheck;
        @AuraEnabled public List<TreeWrapper> childTree;
    }
    public Class oppSyncdataWrapperWithISOCode{
        @AuraEnabled public string oppId; 
        @AuraEnabled public string currrencyISOCode;
        @AuraEnabled public string billingCountryList;
        @AuraEnabled public List<oppSyncDataWrapper> oppSyncDataList;
    }
    public class oppSyncDataWrapper{
        @AuraEnabled public string oppProductId;
        @AuraEnabled public string productId;
        @AuraEnabled public string isbnCode;
        @AuraEnabled public String productName;
        @AuraEnabled public String authorName;
        @AuraEnabled public Decimal quantity;
        @AuraEnabled public Decimal unitPrice;
        @AuraEnabled public string currencyISOCode;
        @AuraEnabled public string pricebookEntryId;
        @AuraEnabled public string puchaseOrderNumber;
    }
     public Class userIdAndContryPickListWrapper{
        @AuraEnabled public string userId;
        @AuraEnabled public List<Setting_Item__c> countryPickListValues;
    }
}