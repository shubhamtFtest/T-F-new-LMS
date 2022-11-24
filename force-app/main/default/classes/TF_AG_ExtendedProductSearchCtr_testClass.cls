@isTest
public class TF_AG_ExtendedProductSearchCtr_testClass {
    @isTest
    private static  void createProductRecord(){
        Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            Account accObject = new Account(Name = 'Test Account',
                                        RecordTypeId = TFAccountsRecordTypeId,
                                        Type = 'Customer'); 
			insert accObject;
			
            Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
            Product2 prodObject = new Product2(Name = 'Test Product', 
                                           RecordTypeId = TFProductsRecordTypeId,
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           Readership_Level__c = 'Test');	
            insert prodObject;										   
										
            Prepay_Accounts__c prepayAccountObj = new Prepay_Accounts__c(Name = 'Test Prepay Account', AccountName__c = accObject.Id, Total_Budgeted_Amount__c=2000.00);
            insert prepayAccountObj;  

            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Account__c = accObject.Id, Payer_Account__c = accObject.Id, SBQQ__ExpirationDate__c = date.today()+20, Use_Prepay_Budget__c = true);   
			insert quoteObject;
			
			SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteObject.Id, SBQQ__Product__c = prodObject.Id, Discount_Rules_Applied__c = 'Prepay');
            insert quoteLineObject;
        
        
        
        
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
        
        Product2 prod=new Product2(Name='testProduct1',US_Discount__c = 'V' ,Business_Division__c='History',Books_Subject_Description_1__c='Acting',Sales_Organization__c='IN01',Article_Type__c  ='Report',CurrencyIsoCode='AED',ISBN__c='8898415570503',Publication_Date__c=System.today()+1,Version_Type__c='other',Lead_Author_Editor__c='test');
        insert prod;
        List<Product2> lstProd = [Select id,Name,Sales_Organization__c from Product2 where id=:prod.id];
        System.assertEquals(prod.Name,lstProd[0].Name);
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        TF_AG_ExtendedProductSearchCtr.ProductWrapper wrap= new TF_AG_ExtendedProductSearchCtr.ProductWrapper();
        wrap.pricebookCSV=standardPrice;
        wrap.discountCSV=45.60;
        wrap.discountPercentCSV='30';
        String min=string.valueOf(8000);
        String max=string.valueOf(12000);
        String pubfrmDate=string.valueOf(prod.Publication_Date__c);
        String pubToDate=string.valueOf(prod.Publication_Date__c+1);
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
        Map<String, Integer> productDiscountCodeToValueMapTest = new Map<String, Integer>();
        productDiscountCodeToValueMapTest.put('V',12);
        Test.startTest();
        Decimal abcdefg = TF_AG_ExtendedProductSearchCtr.calculatProductDiscount(standardPrice,productDiscountCodeToValueMapTest);
        List<Setting_Item__c> testSubjectCode=TF_AG_ExtendedProductSearchCtr.getSubjectCodes();
        //System.assertNotEquals(0, testSubjectCode.size());
        List<Setting_Item__c> testSubjectList=TF_AG_ExtendedProductSearchCtr.getSubjectList();
       // system.assertNotEquals(0, testSubjectList.size());
        List<String> readFile=new List<string>();
        readFile.add('9781877743009,9781315564555,9781409410621,9781482213201,9780415840781');
        String csvISBN='9781877743009,9781315564555,9781409410621,9781482213201,9780415840781';
        
        List<TF_AG_ExtendedProductSearchCtr.ProductDataWrapper> multiIsbnSrch=TF_AG_ExtendedProductSearchCtr.getMultiIsbnList('9781315879307', 2, 0,'asc','name','USD');
        try{
            List<TF_AG_ExtendedProductSearchCtr.ProductDataWrapper> multiIsbnSrchCatchBlock=TF_AG_ExtendedProductSearchCtr.getMultiIsbnList(prod.ISBN__c, 2,-1,'asc','UnitPrice','USD');
        } catch(DMLException e) {
           
        }
        list<TF_AG_ExtendedProductSearchCtr.ProductDataWrapper> readCsv=TF_AG_ExtendedProductSearchCtr.readCSVFile(readFile,2,50,0,'asc','name');
        
        list<TF_AG_ExtendedProductSearchCtr.ProductDataWrapper> readCsvNeg=TF_AG_ExtendedProductSearchCtr.readCSVFile(readFile,-1,50,0,'asc','name');
        
        Integer countSearch=TF_AG_ExtendedProductSearchCtr.getCountOfSearchData(prod.ISBN__c);
        //system.assertEquals(0, countSearch);
        List<string> pubYearTest = new List<string>();
        string prodCountWrap=TF_AG_ExtendedProductSearchCtr.getProductDetails(prod.ISBN__c,prod.Name,prod.Lead_Author_Editor__c,subjectCode,subjectList,lstMediumAll,'exclude',pubFrmDate,pubToDate,min,max,5,0,'asc','name','False','USD',pubYearTest,'ABC');
        string prodCountWrap2=TF_AG_ExtendedProductSearchCtr.getProductDetails(prod.ISBN__c,prod.Name,prod.Lead_Author_Editor__c,subjectCode,subjectList,lstMedium,'exclude','',pubToDate,'',max,5,0,'asc','UnitPrice','False','USD',pubYearTest,'ABC');
        string prodCountWrap3=TF_AG_ExtendedProductSearchCtr.getProductDetails(prod.ISBN__c,prod.Name,prod.Lead_Author_Editor__c,subjectCode,subjectList,lstMediumAll,'Only NYP',pubFrmDate,'',min,'',5,0,'asc','name','False','USD',pubYearTest,'ABC');
        string prodCountWrap4=TF_AG_ExtendedProductSearchCtr.getProductDetails(prod.ISBN__c,prod.Name,prod.Lead_Author_Editor__c,subjectCode,subjectList,lstMedium,'exclude',pubFrmDate,pubToDate,'','',5, 0,'asc','name','False','USD',pubYearTest,'ABC');
        
        Integer prodSrchCount=TF_AG_ExtendedProductSearchCtr.getProductSearchCount(prod.ISBN__c, prod.Name, prod.Lead_Author_Editor__c,subjectCode,subjectList, lstMedium, 'Only NYP', pubFrmDate, pubToDate, min, max);
        Integer prodSrchCount1=TF_AG_ExtendedProductSearchCtr.getProductSearchCount(prod.ISBN__c, prod.Name, prod.Lead_Author_Editor__c,subjectCode,subjectList, lstMedium, 'Only NYP', pubFrmDate,'',min,'');
        Integer prodSrchCount2=TF_AG_ExtendedProductSearchCtr.getProductSearchCount(prod.ISBN__c, prod.Name, prod.Lead_Author_Editor__c,subjectCode,subjectList, lstMediumAll, 'exclude','', pubToDate,'',max);    
        //System.assertNotEquals(prodSrchCount,prodSrchCount1);
        //System.assertNotEquals(prodSrchCount2,prodSrchCount1);
        
        String returnIsbnLine=TF_AG_ExtendedProductSearchCtr.returnIsbn(prod.ISBN__c, 0);
        System.assertEquals(returnIsbnLine, prod.ISBN__c);
        Integer uploadCount=TF_AG_ExtendedProductSearchCtr.getCsvUploadCount(readFile,0,'asc','UnitPrice');
        system.assertEquals(prod.Article_Type__c, 'Report');
        
        TF_AG_ExtendedProductSearchCtr.userIdAndContryPickListWrapper getDetailsTest=TF_AG_ExtendedProductSearchCtr.getDetails();
        //System.assertEquals('', getDetailsTest);
        
        String downloadTest=TF_AG_ExtendedProductSearchCtr.downloadCsvFileData(prod.ISBN__c, prod.Name, prod.Lead_Author_Editor__c,subjectCode,subjectList, lstMedium,'exclude',pubFrmDate,'','2','','asc','Name','True','USD','ABC');
        String downloadTest1=TF_AG_ExtendedProductSearchCtr.downloadCsvFileData(prod.ISBN__c, prod.Name, prod.Lead_Author_Editor__c,subjectCode,subjectList, lstMediumAll,'Only NYP','',pubToDate,'','10','asc','UnitPrice','True','USD','ABC');
        String downloadTest2=TF_AG_ExtendedProductSearchCtr.downloadCsvFileData(prod.ISBN__c, prod.Name, prod.Lead_Author_Editor__c,subjectCode,subjectList, lstMediumAll,'Only NYP','02/05/2018','10/06/2018','2','10','asc','UnitPrice','True','USD','ABC');
        
        String downloadMultiFile=TF_AG_ExtendedProductSearchCtr.downloadMultiFileData(csvISBN,'asc','UnitPrice');
        String downloadMultiFile1=TF_AG_ExtendedProductSearchCtr.downloadMultiFileData(prod.ISBN__c,'asc','Name');
        String addedQuoteLines = TF_AG_ExtendedProductSearchCtr.fetchOppLines(quoteObject.Id);
       // Test.setMock(HttpCalloutMock.class, new TF_AG_MockHttpResponseGenerator());
        User use=TF_AG_ExtendedProductSearchCtr.updateUserDetailsFromBMIS('ID');
        
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
        
        Product2 prod=new Product2(Name='Epicureanism',CurrencyIsoCode='USD',ISBN__c='9781844651696',Business_Division__c='History',Books_Subject_Description_1__c='Acting',Sales_Organization__c='IN01',Article_Type__c  ='Report',Publication_Date__c=System.today()-5000,Version_Type__c='Hardback',Lead_Author_Editor__c='test');
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
        String pubfrmDate=string.valueOf(prod.Publication_Date__c);
        String pubToDate=string.valueOf(prod.Publication_Date__c+1);
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
        
        

        TF_AG_ExtendedProductSearchCtr controller = new TF_AG_ExtendedProductSearchCtr();
        
        
        ApexPages.currentPage().getParameters().put('lstSelectedMediumData', lstMedium);
        system.runAs(u){
        test.startTest();
        
        TF_AG_ExtendedProductSearchCtr controller1 = new TF_AG_ExtendedProductSearchCtr();
        
        test.stopTest();
        
        
        }
        //TF_AG_ExtendedProductSearchCtr controller2 = new TF_AG_ExtendedProductSearchCtr();
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
        
        Setting__c settingObj1=new Setting__c(name='NetbaseClassifications');
        insert settingObj1;
        List<Setting__c> lstSet1 = [Select id,name from Setting__c where id=:settingObj1.id];
        System.assertEquals(settingObj1.name,lstSet1[0].name);
        
        Setting_Item__c set_item1=new Setting_Item__c(Checkbox_1__c = TRUE,Setting__c=settingObj1.Id,Text_1__c='T',Text_2__c='T',Text_3__c='30');
        insert set_item1;
        List<Setting_Item__c> lstItem1 = [Select id,Setting__c from Setting_Item__c where id=:set_item1.id];
        System.assertEquals(set_item1.Setting__c,lstItem1[0].Setting__c);
        
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
        List<string> pubYearTest = new List<string>();
        TF_AG_ExtendedProductSearchCtr.getProductSearchCount('','picu','',subjectCode,subjectList,lstMediumData,'Include','','','','');
        TF_AG_ExtendedProductSearchCtr.getProductDetails('','picu','',subjectCode,subjectList,lstMediumData,'','','','','',50,0,'desc','Name','False','USD',pubYearTest,'ABC');
        TF_AG_ExtendedProductSearchCtr.downloadCsvFileData('','picu','',subjectCode,subjectList,lstMediumData,'','','','','','desc','Name','True','USD','ABC');
        TF_AG_ExtendedProductSearchCtr.getNetBaseClassifications();
        TF_AG_ExtendedProductSearchCtr.getSubjectClassifications();
        TF_AG_ExtendedProductSearchCtr.treeGetNetBaseClassifications2();
        TF_AG_ExtendedProductSearchCtr.TreeGetSubjectClassifications2();
        
        
        PageReference pref = Page.TF_AG_exportcsv;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('paramdemo',paramdemo);
        ApexPages.currentPage().getParameters().put('lstSelectedMediumData','All');
        ApexPages.currentPage().getParameters().put('subjectList', '1');
        TF_AG_ExtendedProductSearchCtr controller = new TF_AG_ExtendedProductSearchCtr();
        controller.lstDownloadData.add(standardPrice);
        TF_AG_ExtendedProductSearchCtr.getProductDetailByISBN(prod.ISBN__c);
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
        List<TF_AG_ExtendedProductSearchCtr.ProductDataWrapper> csvRead=TF_AG_ExtendedProductSearchCtr.readCSVFile(csvFileLines,0,50000,0,'asc','UnitPrice');
        String isbnReturn=TF_AG_ExtendedProductSearchCtr.returnIsbn(str, 0);
        List<TF_AG_ExtendedProductSearchCtr.ProductDataWrapper> csvReadNegative=TF_AG_ExtendedProductSearchCtr.readCSVFile(csvFileLines,-1,50000,0,'asc','name');
        Test.stopTest();
    }
    
    static testMethod void NegativeSubjectcodesTest(){
        Test.startTest();       
        List<Setting_Item__c> testSubjectCode=TF_AG_ExtendedProductSearchCtr.getSubjectCodes();
        System.assertEquals(0, testSubjectCode.size());
        List<Setting_Item__c> testSubjectList=TF_AG_ExtendedProductSearchCtr.getSubjectList();
        system.assertEquals(0, testSubjectList.size());        
        Test.stopTest();
    }
    
    static testMethod void testdownloadReadCsvFileData(){ 
        Test.startTest();
        csvFileBody = Blob.valueOf(str);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n'); 
        String downloadcsvRead=TF_AG_ExtendedProductSearchCtr.downloadReadCsvFileData(csvFileLines,0,'asc','UnitPrice');
        String downloadReadCsvFile1=TF_AG_ExtendedProductSearchCtr.downloadReadCsvFileData(csvFileLines,-1,'asc','Name');
        Test.stopTest();
    }
    
    static testMethod void testgetselectOptions(){ 
        Test.startTest();
        Product2 prod = new Product2();
        List<String> testList=TF_AG_ExtendedProductSearchCtr.getselectOptions(prod,'Name');
        Test.stopTest();
    }
  
}