@isTest
public class TF_AG_ProductSearchCtr_testClass {
    @isTest(SeeAllData=true)
    private static  void createProductRecord(){
        
        Account ac = new Account(name ='testAcc') ;
        insert ac; 
        List<Account> lstAcc = [Select id,Name from Account where id=:ac.id];
        System.assertEquals(ac.Name,lstAcc[0].Name);
        
        Contact con = new Contact(LastName ='testCon',AccountId = ac.Id);
        insert con; 
        List<Contact> lstCon = [Select id,Lastname from Contact where id=:con.id];
        System.assertEquals(con.LastName,lstCon[0].LastName);
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Agent Extranet Community User'];
        User u = new User(Alias = 'standt1',BMIS_Account_Number__c  ='00001111',CommunityNickname='testNick',CurrencyIsoCode='AED',Country='United Kingdom',Email='demo1@randomdemodomain.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='testAgentExtra@agent.com', ContactId = con.Id);
        insert u;
        List<User> lstUsr = [Select id,Alias from User where id=:u.id];
        System.assertEquals(u.Alias,lstUsr[0].Alias);
        
        Setting__c settingObj=new Setting__c(name='testsetting');
        insert settingObj;
        List<Setting__c> lstSet = [Select id,name from Setting__c where id=:settingObj.id];
        System.assertEquals(settingObj.name,lstSet[0].name);
        
        Setting_Item__c set_item=new Setting_Item__c(Checkbox_1__c = TRUE,Setting__c=settingObj.Id,Text_1__c='testTxt1');
        insert set_item;
        List<Setting_Item__c> lstItem = [Select id,Setting__c from Setting_Item__c where id=:set_item.id];
        System.assertEquals(set_item.Setting__c,lstItem[0].Setting__c);
        
        Product2 prod=new Product2(Name='testProduct1',Business_Division__c='History',Books_Subject_Description_1__c='Acting',Sales_Organization__c='IN01',Article_Type__c  ='Report',CurrencyIsoCode='AED',ISBN__c='8898415570503',US_Publication_Date__c=System.today()+1,Version_Type__c='other',Lead_Author_Editor__c='test');
        insert prod;
        List<Product2> lstProd = [Select id,Name,Sales_Organization__c from Product2 where id=:prod.id];
        System.assertEquals(prod.Name,lstProd[0].Name);
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        TF_AG_ProductSearchCtr.ProductWrapper wrap= new TF_AG_ProductSearchCtr.ProductWrapper();
        wrap.pricebookCSV=standardPrice;
        wrap.discountCSV=45.60;
        wrap.discountPercentCSV='30';
        String min=string.valueOf(8000);
        String max=string.valueOf(12000);
        String pubfrmDate=string.valueOf(prod.US_Publication_Date__c);
        String pubToDate=string.valueOf(prod.US_Publication_Date__c+1);
        List<String> subjectCode=new List<string>();
        subjectCode.add(prod.Books_Subject_Description_1__c);
        List<String> subjectList=new List<string>();
        subjectList.add(prod.Business_Division__c);
        List<Product2> lst=[select name from product2 where id=:prod.id];
        system.assertEquals(1, lst.size());
        List<String> lstMedium=new List <String>();
        lstMedium.add(prod.Version_Type__c);
        List<String> lstMediumAll=new List <String>();
        lstMediumAll.add('All');
        Test.startTest();
        List<Setting_Item__c> testSubjectCode=TF_AG_ProductSearchCtr.getSubjectCodes();
        System.assertNotEquals(0, testSubjectCode.size());
        List<Setting_Item__c> testSubjectList=TF_AG_ProductSearchCtr.getSubjectList();
        system.assertNotEquals(0, testSubjectList.size());
        List<String> readFile=new List<string>();
        readFile.add('9781877743009,9781315564555,9781409410621,9781482213201,9780415840781');
        String csvISBN='9781877743009,9781315564555,9781409410621,9781482213201,9780415840781';
        
        List<TF_AG_ProductSearchCtr.ProductDataWrapper> multiIsbnSrch=TF_AG_ProductSearchCtr.getMultiIsbnList('9781315879307', 2, 0,'asc','name');
        try{
            List<TF_AG_ProductSearchCtr.ProductDataWrapper> multiIsbnSrchCatchBlock=TF_AG_ProductSearchCtr.getMultiIsbnList(prod.ISBN__c, 2,-1,'asc','UnitPrice');
        } catch(DMLException e) {
           
        }
        list<TF_AG_ProductSearchCtr.ProductDataWrapper> readCsv=TF_AG_ProductSearchCtr.readCSVFile(readFile,2,50,0,'asc','name');
        
        list<TF_AG_ProductSearchCtr.ProductDataWrapper> readCsvNeg=TF_AG_ProductSearchCtr.readCSVFile(readFile,-1,50,0,'asc','name');
        
        Integer countSearch=TF_AG_ProductSearchCtr.getCountOfSearchData(prod.ISBN__c);
        system.assertEquals(0, countSearch);
        TF_AG_ProductSearchCtr.ProductDataWrapperWithCount prodCountWrap=TF_AG_ProductSearchCtr.getProductDetails(prod.ISBN__c,prod.Name,prod.Lead_Author_Editor__c,subjectCode,subjectList,lstMediumAll,'exclude',pubFrmDate,pubToDate,min,max,5,0,'asc','name');
        TF_AG_ProductSearchCtr.ProductDataWrapperWithCount prodCountWrap2=TF_AG_ProductSearchCtr.getProductDetails(prod.ISBN__c,prod.Name,prod.Lead_Author_Editor__c,subjectCode,subjectList,lstMedium,'exclude','',pubToDate,'',max,5,0,'asc','UnitPrice');
        TF_AG_ProductSearchCtr.ProductDataWrapperWithCount prodCountWrap3=TF_AG_ProductSearchCtr.getProductDetails(prod.ISBN__c,prod.Name,prod.Lead_Author_Editor__c,subjectCode,subjectList,lstMediumAll,'Only NYP',pubFrmDate,'',min,'',5,0,'asc','name');
        TF_AG_ProductSearchCtr.ProductDataWrapperWithCount prodCountWrap4=TF_AG_ProductSearchCtr.getProductDetails(prod.ISBN__c,prod.Name,prod.Lead_Author_Editor__c,subjectCode,subjectList,lstMedium,'exclude',pubFrmDate,pubToDate,'','',5, 0,'asc','name');
        
        Integer prodSrchCount=TF_AG_ProductSearchCtr.getProductSearchCount(prod.ISBN__c, prod.Name, prod.Lead_Author_Editor__c,subjectCode,subjectList, lstMedium, 'Only NYP', pubFrmDate, pubToDate, min, max);
        Integer prodSrchCount1=TF_AG_ProductSearchCtr.getProductSearchCount(prod.ISBN__c, prod.Name, prod.Lead_Author_Editor__c,subjectCode,subjectList, lstMedium, 'Only NYP', pubFrmDate,'',min,'');
        Integer prodSrchCount2=TF_AG_ProductSearchCtr.getProductSearchCount(prod.ISBN__c, prod.Name, prod.Lead_Author_Editor__c,subjectCode,subjectList, lstMediumAll, 'exclude','', pubToDate,'',max);    
        //System.assertNotEquals(prodSrchCount,prodSrchCount1);
        //System.assertNotEquals(prodSrchCount2,prodSrchCount1);
        
        String returnIsbnLine=TF_AG_ProductSearchCtr.returnIsbn(prod.ISBN__c, 0);
        System.assertEquals(returnIsbnLine, prod.ISBN__c);
        Integer uploadCount=TF_AG_ProductSearchCtr.getCsvUploadCount(readFile,0,'asc','UnitPrice');
        system.assertEquals(prod.Article_Type__c, 'Report');
        
        String getDetailsTest=TF_AG_ProductSearchCtr.getDetails();
        System.assertEquals('', getDetailsTest);
        
        String downloadTest=TF_AG_ProductSearchCtr.downloadCsvFileData(prod.ISBN__c, prod.Name, prod.Lead_Author_Editor__c,subjectCode,subjectList, lstMedium,'exclude',pubFrmDate,'','2','','asc','Name');
        String downloadTest1=TF_AG_ProductSearchCtr.downloadCsvFileData(prod.ISBN__c, prod.Name, prod.Lead_Author_Editor__c,subjectCode,subjectList, lstMediumAll,'Only NYP','',pubToDate,'','10','asc','UnitPrice');
        String downloadTest2=TF_AG_ProductSearchCtr.downloadCsvFileData(prod.ISBN__c, prod.Name, prod.Lead_Author_Editor__c,subjectCode,subjectList, lstMediumAll,'Only NYP','02/05/2018','10/06/2018','2','10','asc','UnitPrice');
        
        String downloadMultiFile=TF_AG_ProductSearchCtr.downloadMultiFileData(csvISBN,'asc','UnitPrice');
        String downloadMultiFile1=TF_AG_ProductSearchCtr.downloadMultiFileData(prod.ISBN__c,'asc','Name');
        Test.setMock(HttpCalloutMock.class, new TF_AG_MockHttpResponseGenerator());
        User use=TF_AG_ProductSearchCtr.updateUserDetailsFromBMIS('ID');
        
        Test.stopTest();
    } 
    
    
    @isTest
    private static void constructorTest(){
        Account ac = new Account(name ='testAcc') ;
        insert ac; 
        Contact con = new Contact(LastName ='testCon',AccountId = ac.Id);
        insert con; 
        Profile p = [SELECT Id FROM Profile WHERE Name='Agent Extranet Community User'];
        User u = new User(Alias = 'standt1',BMIS_Account_Number__c  ='00001111',CommunityNickname='testNick',CurrencyIsoCode='USD',Country='United Kingdom',Email='demo1@randomdemodomain.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='testAgentExtra@agent.com',ContactId = con.Id,BMIS_Customer_Discount_Code__c='T');
        insert u;
        List<User> lstUsr = [Select id,Alias from User where id=:u.id];
        System.assertEquals(u.Alias,lstUsr[0].Alias);
        
        Setting__c settingObj=new Setting__c(name='BMISDiscountMatrix');
        insert settingObj;
        List<Setting__c> lstSet = [Select id,name from Setting__c where id=:settingObj.id];
        System.assertEquals(settingObj.name,lstSet[0].name);
        
        Setting_Item__c set_item=new Setting_Item__c(Checkbox_1__c = TRUE,Setting__c=settingObj.Id,Text_1__c='T',Text_2__c='T',Text_3__c='30');
        insert set_item;
        List<Setting_Item__c> lstItem = [Select id,Setting__c from Setting_Item__c where id=:set_item.id];
        System.assertEquals(set_item.Setting__c,lstItem[0].Setting__c);
        
        Product2 prod=new Product2(Name='Epicureanism',CurrencyIsoCode='USD',ISBN__c='9781844651696',Business_Division__c='History',Books_Subject_Description_1__c='Acting',Sales_Organization__c='IN01',Article_Type__c  ='Report',US_Publication_Date__c=System.today()-5000,Version_Type__c='Hardback',Lead_Author_Editor__c='test');
        insert prod;
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 8079, IsActive = true);
        insert standardPrice;
        List<Product2> lstProd = [Select id,Name,Sales_Organization__c from Product2 where id=:prod.id];
        System.assertEquals(prod.Name,lstProd[0].Name);    
        String min=string.valueOf(8000);
        String max=string.valueOf(12000);
        String pubfrmDate=string.valueOf(prod.US_Publication_Date__c);
        String pubToDate=string.valueOf(prod.US_Publication_Date__c+1);
        String subjectCode=prod.Books_Subject_Description_1__c;
        String subjectList=prod.Business_Division__c;
        String lstMedium=prod.Version_Type__c;
        String lstMediumAll='All';
        String readFile='9780714618074,'+'9781138679894,'+'9781138241992';
        
        PageReference pref = Page.TF_AG_exportcsv;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('minprice',min);
        ApexPages.currentPage().getParameters().put('maxprice',max);
        ApexPages.currentPage().getParameters().put('subjectCode', subjectCode);
        ApexPages.currentPage().getParameters().put('subjectList', subjectList);
        ApexPages.currentPage().getParameters().put('lstSelectedMediumData', lstMediumAll);
        ApexPages.currentPage().getParameters().put('multiIsbnListData', readFile);  
        ApexPages.currentPage().getParameters().put('infoList', readFile);
        
        

        TF_AG_ProductSearchCtr controller = new TF_AG_ProductSearchCtr();
        
        
        ApexPages.currentPage().getParameters().put('lstSelectedMediumData', lstMedium);
        system.runAs(u){
        test.startTest();
        
        TF_AG_ProductSearchCtr controller1 = new TF_AG_ProductSearchCtr();
        
        test.stopTest();
        
        
        }
        //TF_AG_ProductSearchCtr controller2 = new TF_AG_ProductSearchCtr();
    }
    static testMethod void constructorWithQueryTest(){
        Account ac = new Account(name ='testAcc') ;
        insert ac; 
        Contact con = new Contact(LastName ='testCon',AccountId = ac.Id);
        insert con; 
        Profile p = [SELECT Id FROM Profile WHERE Name='Agent Extranet Community User'];
        User u = new User(Alias = 'standt1',BMIS_Account_Number__c  ='00001111',CommunityNickname='testNick',CurrencyIsoCode='USD',Country='United Kingdom',Email='demo1@randomdemodomain.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='testAgentExtra@agent.com',ContactId = con.Id,BMIS_Customer_Discount_Code__c='T');
        insert u;
        List<User> lstUsr = [Select id,Alias from User where id=:u.id];
        System.assertEquals(u.Alias,lstUsr[0].Alias);
        
        Setting__c settingObj=new Setting__c(name='BMISDiscountMatrix');
        insert settingObj;
        List<Setting__c> lstSet = [Select id,name from Setting__c where id=:settingObj.id];
        System.assertEquals(settingObj.name,lstSet[0].name);
        
        Setting_Item__c set_item=new Setting_Item__c(Checkbox_1__c = TRUE,Setting__c=settingObj.Id,Text_1__c='T',Text_2__c='T',Text_3__c='30');
        insert set_item;
        List<Setting_Item__c> lstItem = [Select id,Setting__c from Setting_Item__c where id=:set_item.id];
        System.assertEquals(set_item.Setting__c,lstItem[0].Setting__c);
        
        Product2 prod=new Product2(Name='Epicurean Tradition',CurrencyIsoCode='USD',ISBN__c='9780415075541',Business_Division__c='Classics',Version_Type__c='Paperback',Lead_Author_Editor__c='Howard Jones',US_Inventory_Status__c='Available',Edition_Number__c=1);
        insert prod;
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 8079, IsActive = true);
        insert standardPrice;
        List<Product2> lstProd = [Select id,Name,Sales_Organization__c from Product2 where id=:prod.id];
        System.assertEquals(prod.Name,lstProd[0].Name);
        List<String> subjectCode=new List<string>();
        //subjectCode.add();
        List<String> subjectList=new List<string>();
        //subjectList.add(prod.Business_Division__c);
        List<String> lstMediumData=new List <String>();
        lstMediumData.add('All');
        String systemIdVal='GT_TF';
        String currencyType='USD';
        String priceBookName='T&F Pricebook';
        String likeType='%picu%';
        String paramdemo='Select Id,Pricebook2.name,UnitPrice,Product2.ID,Product2.ISBN__c,Product2.Name,Product2.US_Discount__c,Product2.Lead_Author_Editor__c,Product2.US_Publication_Date__c,Product2.US_Planned_Publication_Date__c,Product2.Version_Type__c,Product2.US_Inventory_Status__c,Product2.Edition_Number__c,Product2.Status__c,Product2.Imprint__c,Product2.POD__c From PricebookEntry where CurrencyIsoCode=\''+currencyType+'\' and Product2.System_ID__c=\''+systemIdVal+'\' and Pricebook2.name=\''+priceBookName+'\' and Product2.Name Like \''+likeType+'\' and Product2.Version_Type__c Not IN :lstMediumData order by Product2.Name';
        
        Test.startTest(); 
        TF_AG_ProductSearchCtr.getProductSearchCount('','picu','',subjectCode,subjectList,lstMediumData,'Include','','','','');
        TF_AG_ProductSearchCtr.getProductDetails('','picu','',subjectCode,subjectList,lstMediumData,'','','','','',50,0,'desc','Name');
        TF_AG_ProductSearchCtr.downloadCsvFileData('','picu','',subjectCode,subjectList,lstMediumData,'','','','','','desc','Name');
        
        PageReference pref = Page.TF_AG_exportcsv;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('paramdemo',paramdemo);
        ApexPages.currentPage().getParameters().put('lstSelectedMediumData','All');
        ApexPages.currentPage().getParameters().put('subjectList', '1');
        TF_AG_ProductSearchCtr controller = new TF_AG_ProductSearchCtr();
        controller.lstDownloadData.add(standardPrice);
        TF_AG_ProductSearchCtr.getProductDetailByISBN(prod.ISBN__c);
        Test.stopTest();
        
        system.debug('controll--'+controller.lstDownloadData);
        
    }
        
    static String str = 'Name,AccountNumber,"Type,Accountsource,Industry\n Esha Patharabe,10001,Prospect,Test,Banking\n Trupti Nimje,10002,Prospect,Test,Banking';       
    public static String[] csvFileLines;
    public static Blob csvFileBody;
    
    static testMethod void testfileupload(){
               
        csvFileBody = Blob.valueOf(str);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n'); 
        Test.startTest();
        List<TF_AG_ProductSearchCtr.ProductDataWrapper> csvRead=TF_AG_ProductSearchCtr.readCSVFile(csvFileLines,0,50000,0,'asc','UnitPrice');
        String isbnReturn=TF_AG_ProductSearchCtr.returnIsbn(str, 0);
        List<TF_AG_ProductSearchCtr.ProductDataWrapper> csvReadNegative=TF_AG_ProductSearchCtr.readCSVFile(csvFileLines,-1,50000,0,'asc','name');
        Test.stopTest();
    }
    
    static testMethod void NegativeSubjectcodesTest(){
        Test.startTest();       
        List<Setting_Item__c> testSubjectCode=TF_AG_ProductSearchCtr.getSubjectCodes();
        System.assertEquals(0, testSubjectCode.size());
        List<Setting_Item__c> testSubjectList=TF_AG_ProductSearchCtr.getSubjectList();
        system.assertEquals(0, testSubjectList.size());        
        Test.stopTest();
    }
    
    static testMethod void testdownloadReadCsvFileData(){
        Test.startTest();
        csvFileBody = Blob.valueOf(str);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n'); 
        String downloadcsvRead=TF_AG_ProductSearchCtr.downloadReadCsvFileData(csvFileLines,0,'asc','UnitPrice');
        String downloadReadCsvFile1=TF_AG_ProductSearchCtr.downloadReadCsvFileData(csvFileLines,-1,'asc','Name');
        Test.stopTest();
    }
}