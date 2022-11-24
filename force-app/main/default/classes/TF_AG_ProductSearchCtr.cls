/**
* File Name: TF_AG_ProductSearchCtr
* Description : 
* @author :  Arun Garg
* Modified By : Siddahant Tyagi
* Test class: TF_AG_ProductSearchCtr_testClass
* Test coverage : 90%
* */ 
public class TF_AG_ProductSearchCtr{
    public List<PricebookEntry> lstDownloadData {get;set;}
    public List<ProductWrapper> productWrapperList {get;set;}
    public string fileName {get;set;}
    public string userId{get;set;}
    
    public TF_AG_ProductSearchCtr(){
        try{
            userId=getDetails();
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
            List<String> subjectCode=new List<String>();
            string minPrice=apexpages.currentpage().getparameters().get('minprice');
            String maxPrice=apexpages.currentpage().getparameters().get('maxprice');
            system.debug('min-->'+minPrice+'--max-->'+maxPrice); 
            String downloadData = apexpages.currentpage().getparameters().get('paramdemo');
            String lstSubjectCode=apexpages.currentpage().getparameters().get('subjectCode');
            String subjectListval=apexpages.currentpage().getparameters().get('subjectList');
            String selectedMediumData=apexpages.currentpage().getparameters().get('lstSelectedMediumData');
            String multiIsbnData=apexpages.currentpage().getparameters().get('multiIsbnListData');
            String readCsv=apexpages.currentpage().getparameters().get('infoList');
            
            downloadData+=' LIMIT 90000';
            System.debug('downloadData:='+downloadData);
            System.debug('subjectListval'+subjectListval);
            
           
            /*----Create download data for ProductTab------*/
            /*If the search is invoked Using Subject Code*/
            if(lstSubjectCode !=null){
                List<String> listSplitSubCodes=lstSubjectCode.split(',');
                for(String subCode:listSplitSubCodes){
                    subCode=subCode.replace('!',',');
                    subCode=subCode.replace('~','&');
                    subjectCode.add(subCode);
                }
                System.debug('lstSubjectCode:='+subjectCode);
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
            if(lstDownloadData.size()>0){
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
    public static String getDetails() {
        String runningUserId='';
        Profile pfile = [Select Name from Profile where Id =: userinfo.getProfileid()];
        if(pfile.Name == 'Agent Extranet Community User'){
            runningUserId= UserInfo.getUserId(); 
        }
        return runningUserId;
    }   
    
    @AuraEnabled
    public static ProductDataWrapperWithCount getProductDetails(String ISBN,String title,String author,List<String> subjectCode, List<String> lstSubjectList,List<String> lstMediumData,String publishData,String publcFromDate,String publcToDate,String minPrice,String maxPrice,Integer displayPageData,Integer offsetVal,String sortBy,String sortOrderFieldName){
        List<PricebookEntry> lstPriceBookEntry=new List<PricebookEntry>();
        List<ProductDataWrapper> lstProductWrapper=new List<ProductDataWrapper>();
        ProductDataWrapperWithCount prodDataWrapWthCount = new ProductDataWrapperWithCount();
        List<String> lstMedium=new List<String>();
        String query;
        String queryCount = ''; // Siddhant Tyagi -- no of records in the same method to minimize the callouts
        String systemIdVal='GT_TF';
        String currencyType='USD';
        String priceBookName='T&F Pricebook';
        String sortOrderBy;
        if(sortOrderFieldName.equals('UnitPrice')){
            sortOrderBy='UnitPrice';
        }
        else{
            sortOrderBy='Product2.'+sortOrderFieldName;
        }
        try{
            query='Select Id,Pricebook2.name,UnitPrice,Product2.ID,Product2.ISBN__c,Product2.Name,Product2.US_Discount__c,Product2.Lead_Author_Editor__c,Product2.US_Publication_Date__c,Product2.US_Planned_Publication_Date__c,Product2.Version_Type__c,Product2.US_Inventory_Status__c,Product2.POD__c From PricebookEntry where CurrencyIsoCode=\''+currencyType+'\' and Product2.System_ID__c=\''+systemIdVal+'\' and Pricebook2.name=\''+priceBookName+'\'';
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
                query+=' and Product2.ProductCode=\''+ISBN+'\'';
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
            if(subjectCode !=null && subjectCode.size()>0){
                query+=' and Product2.Books_Subject_Description_1__c IN :subjectCode';
            }
            if(lstSubjectList!=null && lstSubjectList.size()>0){
                //String[] lstSubjectListval = lstSubjectList.split(',');
                query+=' and Product2.Business_Division__c IN :lstSubjectList';
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
                    query+=' and Product2.US_Publication_Date__c<=TODAY';
                }
                if(publishData == 'Only NYP'){
                    query+=' and Product2.US_Publication_Date__c>TODAY';
                }
            }
            if(String.isNotBlank(publcFromDate) && String.isNotBlank(publcToDate)){
                query+=' and Product2.US_Publication_Date__c>='+publcFromDate+' and Product2.US_Publication_Date__c<='+publcToDate;
                
            }
            if(String.isBlank(publcFromDate) && String.isNotBlank(publcToDate)){
                query+=' and Product2.US_Publication_Date__c<='+publcToDate;
            }
            if(String.isNotBlank(publcFromDate) && String.isBlank(publcToDate)){
                query+=' and Product2.US_Publication_Date__c>='+publcFromDate;
            }
            queryCount += query;
            query+=' order by '+sortOrderBy+' '+sortBy+' LIMIT 2000'; // removed the offset to make the pagination dynamic on javascript +displayPageData+' OFFSET '+offsetVal;
            queryCount+=' limit 2001';
            System.debug('query:='+query);
            if(String.isNotBlank(query)){
                lstPriceBookEntry=Database.query(query);
            }
            if(lstPriceBookEntry.size()>0){
                Integer count = 0;
                if(String.isNotBlank(queryCount)){
                    queryCount = queryCount.replace('Select Id,Pricebook2.name,UnitPrice,Product2.ID,Product2.ISBN__c,Product2.Name,Product2.US_Discount__c,Product2.Lead_Author_Editor__c,Product2.US_Publication_Date__c,Product2.US_Planned_Publication_Date__c,Product2.Version_Type__c,Product2.US_Inventory_Status__c,Product2.POD__c', 'Select count()');
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
        return prodDataWrapWthCount;
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
        lstResult=[SELECT Text_1__c FROM Setting_Item__c WHERE Setting__r.Name = 'AgentExtranet_DistinctListValueList' AND Checkbox_1__c = TRUE ORDER BY Text_1__c ASC]; 
        if(lstResult != null && lstResult.size()>0){
            return lstResult;
        }
        return lstResult;
    }
    @AuraEnabled
    public static List<ProductDataWrapper> getMultiIsbnList(String multiIsbn ,Integer displayPageData,Integer offsetVal,String sortBy,String sortOrderFieldName) {
        String query;
        String sortOrderBy;
        String systemIdVal='GT_TF';
        String currencyType='USD';
        String priceBookName='T&F Pricebook';
        if(sortOrderFieldName.equals('UnitPrice')){
            sortOrderBy='UnitPrice';
        }
        else{
            sortOrderBy='Product2.'+sortOrderFieldName;
        }
        List<PricebookEntry> lstPriceBookEntries=new List<PricebookEntry>();
        List<ProductDataWrapper> lstProductWrapper=new List<ProductDataWrapper>();
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
            if(multiIsbnListData!=null && multiIsbnListData.size()>0){
                query='SELECT Id,Product2.Name,Pricebook2.Name,Product2.ISBN__c,Product2.Lead_Author_Editor__c,Product2.Subject_Code__c,Product2.Version_Type__c,unitprice,Product2.US_Publication_Date__c,Product2.US_Planned_Publication_Date__c, Product2.System_ID__c,Product2.US_Discount__c,Product2.US_Inventory_Status__c,Product2.POD__c from PricebookEntry Where Product2.System_ID__c=\''+systemIdVal+'\'';
                query+=' and Product2.ProductCode IN :multiIsbnListData and Pricebook2.name=\''+priceBookName+'\' and CurrencyIsoCode=\''+currencyType+'\'';
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
            }
        catch(Exception e){
            System.debug('Message:='+e.getMessage()+'**Line='+e.getLineNumber());
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
        String priceBookName='T&F Pricebook';
        if(sortOrderFieldName.equals('UnitPrice')){
            sortOrderBy='UnitPrice';
        }
        else{
            sortOrderBy='Product2.'+sortOrderFieldName;
        }
        
        List<PricebookEntry> lstpricebookentries=new List<PricebookEntry>();
        List<ProductDataWrapper> lstProductWrapper=new List<ProductDataWrapper>();
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
            if(multiIsbnListData!=null && multiIsbnListData.size()>0){
                System.debug('multiIsbnListData:='+multiIsbnListData);
                query='SELECT Id,Product2.Name,Pricebook2.Name,Product2.ISBN__c,Product2.Lead_Author_Editor__c,Product2.Subject_Code__c,Product2.Version_Type__c,unitprice,Product2.US_Publication_Date__c,Product2.US_Planned_Publication_Date__c, Product2.System_ID__c,Product2.US_Discount__c,Product2.US_Inventory_Status__c,Product2.POD__c from PricebookEntry Where Product2.System_ID__c=\''+systemIdVal+'\'';
                query+=' and Product2.ProductCode IN :multiIsbnListData and Pricebook2.name=\''+priceBookName+'\' and CurrencyIsoCode=\''+currencyType+'\'';
                query+=' order by '+sortOrderBy+' '+sortBy+' LIMIT '+limitVal+' OFFSET '+offsetValue;
                if(String.isNotBlank(query)){
                    lstPriceBookEntries=Database.query(query);
                }
                if(lstPriceBookEntries.size()>0){
                    lstProductWrapper=getproductWrappedData(lstPriceBookEntries);
                }
                lstProductWrapper=getproductWrappedData(lstpricebookentries);
            }
        }
        catch(Exception e){
            System.debug('Message:='+e.getMessage()+'** Line ='+e.getLineNumber());
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
        Integer countValue=[SELECT count() from PricebookEntry Where CurrencyIsoCode='USD' and Product2.System_ID__c='GT_TF' and Pricebook2.name='T&F Pricebook' and Product2.ProductCode IN:multiIsbnListData];
        system.debug('countValue'+countValue);
        return countValue;
    }
    @AuraEnabled
    public static Integer getProductSearchCount(String ISBN,String title,String author,List<String> subjectCode,List<String> lstSubjectList,List<String> lstMediumData,String publishData,String publcFromDate,String publcToDate,String minPrice,String maxPrice){
        String query;
        Integer countValue=0;
        String systemIdVal='GT_TF';
        String currencyType='USD';
        String priceBookName='T&F Pricebook';
        system.debug('subjectCode'+subjectCode);
        
        try{
            query='Select count() From PricebookEntry where CurrencyIsoCode=\''+currencyType+'\' and Product2.System_ID__c=\''+systemIdVal+'\' and Pricebook2.name=\''+priceBookName+'\'';
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
                query+=' and Product2.ProductCode=\''+ISBN+'\'';
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
            if(subjectCode !=null && subjectCode.size()>0){
                system.debug('subjectCode'+subjectCode);
                query+=' and Product2.Books_Subject_Description_1__c IN :subjectCode';
            }
            
            if(lstSubjectList !=null && lstSubjectList.size()>0){
                system.debug('lstSubjectList--> '+lstSubjectList );
                query+=' and Product2.Business_Division__c IN :lstSubjectList';
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
                    query+=' and Product2.US_Publication_Date__c<=TODAY';
                }
                if(publishData == 'Only NYP'){
                    query+=' and Product2.US_Publication_Date__c>TODAY';
                }
            }
            if(String.isNotBlank(publcFromDate) && String.isNotBlank(publcToDate)){
                query+=' and Product2.US_Publication_Date__c>='+publcFromDate+' and Product2.US_Publication_Date__c<='+publcToDate;
                
            }
            if(String.isBlank(publcFromDate) && String.isNotBlank(publcToDate)){
                query+=' and Product2.US_Publication_Date__c<='+publcToDate;
                
            }
            if(String.isNotBlank(publcFromDate) && String.isBlank(publcToDate)){
                query+=' and Product2.US_Publication_Date__c>='+publcFromDate;
                
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
    public static String downloadCsvFileData(String ISBN,String title,String author,List<String> subjectCode,List<String> lstSubjectList,List<String> lstMediumData,String publishData,String publcFromDate,String publcToDate,String minPrice,String maxPrice,String sortBy,String sortOrderFieldName) {
        String query;
        List<String> lstMedium=new List<String>();
        String systemIdVal='GT_TF';
        String currencyType='USD';
        String priceBookName='T&F Pricebook';
        String sortOrderBy;
        if(sortOrderFieldName.equals('UnitPrice')){
            sortOrderBy='UnitPrice';
        }
        else{
            sortOrderBy='Product2.'+sortOrderFieldName;
        }
         try{
            query='Select Id,Pricebook2.name,UnitPrice,Product2.ID,Product2.ISBN__c,Product2.Name,Product2.US_Discount__c,Product2.Lead_Author_Editor__c,Product2.US_Publication_Date__c,Product2.US_Planned_Publication_Date__c,Product2.Version_Type__c,Product2.US_Inventory_Status__c,Product2.Edition_Number__c,Product2.Status__c,Product2.Imprint__c,Product2.POD__c From PricebookEntry where CurrencyIsoCode=\''+currencyType+'\' and Product2.System_ID__c=\''+systemIdVal+'\' and Pricebook2.name=\''+priceBookName+'\'';
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
                query+=' and Product2.ProductCode=\''+ISBN+'\'';
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
            if(subjectCode !=null && subjectCode.size()>0){
                query+=' and Product2.Books_Subject_Description_1__c IN :subjectCode';
            }
            if(lstSubjectList!=null && lstSubjectList.size()>0){
                query+=' and Product2.Business_Division__c IN :lstSubjectList';
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
                    query+=' and Product2.US_Publication_Date__c<=TODAY';
                }
                if(publishData == 'Only NYP'){
                    query+=' and Product2.US_Publication_Date__c>TODAY';
                }
            }
            if(String.isNotBlank(publcFromDate) && String.isNotBlank(publcToDate)){
                query+=' and Product2.US_Publication_Date__c>='+publcFromDate+' and Product2.US_Publication_Date__c<='+publcToDate;
                
            }
            if(String.isBlank(publcFromDate) && String.isNotBlank(publcToDate)){
                query+=' and Product2.US_Publication_Date__c<='+publcToDate;
                
            }
            if(String.isNotBlank(publcFromDate) && String.isBlank(publcToDate)){
                query+=' and Product2.US_Publication_Date__c>='+publcFromDate;
                
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
        String priceBookName='T&F Pricebook';
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
                query='SELECT Id,Product2.Name,Pricebook2.Name,Product2.ISBN__c,Product2.Lead_Author_Editor__c,Product2.Subject_Code__c,Product2.Version_Type__c,UnitPrice,Product2.US_Publication_Date__c,Product2.US_Planned_Publication_Date__c,Product2.System_ID__c,Product2.US_Discount__c,Product2.US_Inventory_Status__c,Product2.Edition_Number__c,Product2.Status__c,Product2.Imprint__c from PricebookEntry Where Product2.System_ID__c=\''+systemIdVal+'\'';
                query+=' and Product2.ProductCode IN :multiIsbnListData and Pricebook2.name=\''+priceBookName+'\' and CurrencyIsoCode=\''+currencyType+'\'';
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
        String priceBookName='T&F Pricebook';
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
                query='SELECT Id,Product2.Name,Pricebook2.Name,Product2.ISBN__c,Product2.Lead_Author_Editor__c,Product2.Subject_Code__c,Product2.Version_Type__c,unitprice,Product2.US_Publication_Date__c,Product2.US_Planned_Publication_Date__c,Product2.System_ID__c,Product2.US_Discount__c,Product2.US_Inventory_Status__c,Product2.Edition_Number__c,Product2.Status__c,Product2.Imprint__c from PricebookEntry Where Product2.System_ID__c=\''+systemIdVal+'\'';
                query+=' and Product2.ProductCode IN :readCsvListData and Pricebook2.name=\''+priceBookName+'\' and CurrencyIsoCode=\''+currencyType+'\'';
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
                    TF_PlatformExecuter  TAG = new TF_PlatformExecuter();
                	getToken=TF_PlatformExecuter.generateAccessToken();
                    String jsonStr;
                       String BMISEnpont ;
                    // BMIS_Endpoint__c , BMIS_Setting__c
                    BMIS_Setting__c BMISsetting = BMIS_Setting__c.getOrgDefaults();
                    
                    if (BMISsetting != null) { 
                        BMISEnpont = (String) BMISsetting.get('BMIS_Endpoint__c');
                        System.debug('BMISEnpont-'+BMISEnpont);
                    }
                    String endpoint = BMISEnpont + user.BMIS_Account_Number__c+'/us';
                 // String endpoint = 'https://api-uat.taylorandfrancis.com/v1/bmis/salesforce/accountInfo/'+user.BMIS_Account_Number__c+'/us';  //Change made for Dynamic URL
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
        try{
            //Locate the users discount code.
            if(productDiscountCodeToValueMap!=null){
                if(pricebook.Product2.US_Discount__c!=null){
                    if(productDiscountCodeToValueMap.get(pricebook.Product2.US_Discount__c.toUpperCase())!=null){
                        discountPercent=String.valueOf(productDiscountCodeToValueMap.get(pricebook.Product2.US_Discount__c.toUpperCase()));
                    }
                }
            }
        }
        catch(Exception e){
            System.debug('Message:'+e.getMessage()+'* Line='+e.getLineNumber());
        }
        return discountPercent;
    }
    
    public static List<ProductDataWrapper> getproductWrappedData(List<PricebookEntry> lstPriceBook){
        System.debug('lstPriceBook:='+lstPriceBook);
        List<ProductDataWrapper> lstProductWrapper=new List<ProductDataWrapper>();
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
            }
        }
        catch(Exception e){
            System.debug('Message:='+e.getMessage()+'** Line='+e.getLineNumber());
        }
        System.debug('lstProductWrapper-->'+lstProductWrapper);
        return lstProductWrapper;
    }
    
    @AuraEnabled
    public static ProductDataWrapperWithCount getProductDetailByISBN(String prodISBN){
        ProductDataWrapperWithCount prodDataWrapWthCount = new ProductDataWrapperWithCount();
        List<PricebookEntry> listPriceBkEntry=[Select Id,Pricebook2.name,UnitPrice,Product2.ID,Product2.ISBN__c,Product2.Name,Product2.US_Discount__c,
                                                Product2.Lead_Author_Editor__c,Product2.US_Publication_Date__c,Product2.US_Planned_Publication_Date__c,
                                                Product2.Version_Type__c,Product2.US_Inventory_Status__c,Product2.POD__c From PricebookEntry where 
                                                CurrencyIsoCode='USD' and Product2.System_ID__c='GT_TF' and Pricebook2.name='T&F Pricebook' and 
                                                Product2.ISBN__c=:prodISBN];
        prodDataWrapWthCount.prodDataWrap = getproductWrappedData(listPriceBkEntry);   
        return prodDataWrapWthCount;        
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

    }
    // Product Data Count Wrapper Class
    public class ProductDataWrapperWithCount{
        @AuraEnabled public Integer countRec;
        @AuraEnabled public List<ProductDataWrapper> prodDataWrap;
    }
}