@isTest
private with sharing class ztest_TF_GenerateJson {
    
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
        setting.Parts_Api_Url__c='https://api-uat.taylorfrancis.com/v4/products/';
        setting.Dynamic_Package_API_URL__c='https://api-uat.taylorfrancis.com/v4/products/save';
        insert setting; 
        
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
        setting_Itm.Text_6__c = 'book';
        setting_Itm.Text_7__c = 'Manual Curation';

        
        Setting_Item__c setting_Itm2 = new Setting_Item__c();
        setting_Itm2.Setting__c = setting_cust.id ;
        setting_Itm2.Checkbox_1__c = true ;
        setting_Itm2.Text_1__c = 'Collections';
        setting_Itm2.Text_2__c = 'UBX_Sales';
        setting_Itm2.Text_3__c = 'CAN_HOST,INCLUDE_IN_DYNAMIC_PACKAGE';
        setting_Itm2.Text_4__c = 'ALL'; 
        setting_Itm2.Text_5__c = 'UBX';
        setting_Itm2.Text_6__c = 'book';
        setting_Itm.Text_7__c = 'Manual Curation';

        
        Setting_Item__c setting_Itm3 = new Setting_Item__c();
        setting_Itm3.Setting__c = setting_cust.id ;
        setting_Itm3.Checkbox_1__c = true ;
        setting_Itm3.Text_1__c = 'OPC';
        setting_Itm3.Text_2__c = 'UBX_Sales';
        setting_Itm3.Text_3__c = 'CAN_HOST,INCLUDE_IN_DYNAMIC_PACKAGE';
        setting_Itm3.Text_4__c = 'ALL'; 
        setting_Itm3.Text_5__c = 'UBX';
        setting_Itm3.Text_6__c = 'book';
        setting_Itm.Text_7__c = 'Rule based';

        
        List<Setting_Item__c> settingItmLst = new List<Setting_Item__c>();
        settingItmLst.add(setting_Itm);
        settingItmLst.add(setting_Itm2);
        settingItmLst.add(setting_Itm3);
 
        insert settingItmLst ;

                 
        List<QueryApiMapping__c> mapppingLst = new List<QueryApiMapping__c>{new QueryApiMapping__c(Query_Field_Label__c='maxPrice',Name='maxPrice',PCM_Query_Path__c='prices.price',Active__c=true), new QueryApiMapping__c(Query_Field_Label__c='minPrice',Name='minPrice',PCM_Query_Path__c='prices.price',Active__c=true) };
            insert mapppingLst ;
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        
        Product2 newParentProduct = new Product2();
        newParentProduct.name='testAwsService';
        newParentProduct.IsActive=true;
        newParentProduct.Description='test';
        newParentProduct.BusinessId__c='TEST-BUSID';
        newParentProduct.Collection_Banner_Image_Size__c='333';
        newParentProduct.Collection_Banner_Image_S3_location__c='http://s3.u.com';
        newParentProduct.Collection_Cover_Image_Size__c='3343';
        newParentProduct.Collection_Cover_Image_S3_location__c='http://s3.u.com';
        newParentProduct.RecordTypeId=productRecordtypeId;
        newParentProduct.Contributors__c='[{"name":"test test","givenName":"test","familyName":"test","role":"Editor","position":1}]';
        newParentProduct.keywords__c='[{"name":"harish","description":"HARISH","position":1}]';
        newParentProduct.copyrightyear__c='2018';
        newParentProduct.Lead_Author_Editor__c='test';
        newParentProduct.Product_Type_Author_Facing__c='Rule Based';
        newParentProduct.alternateName__c='alternate';
        newParentProduct.inLanguage__c='en';
        newParentProduct.version__c='1.0';
        newParentProduct.doi__c='122/33';
        newParentProduct.ean__c='333';
        newParentProduct.Abstract__c='333';
        //newParentProduct.Product_Publisher__c='TAYLOR';
        newParentProduct.copyrightyear__c='2019';
        //newParentProduct.Collection_Valid_To__c=DateTime.valueof('2021-03-01T00:00:00');
        newParentProduct.issn__c='12345';
        newParentProduct.Publisher__c='Pub';
        newParentProduct.Sales_Channels__c = 'UBX_Sales';
        newParentProduct.Applicable_Channels__c = 'UBX_Delivery';
        newParentProduct.Applicable_License_Types__c = 'Perpetual;Subscription';
        newParentProduct.Applicable_Customer_Types__c = 'Institution;Individual;Government';
        newParentProduct.Dynamic_Collection_Criteria__c = '{"filterObject":{"ISBN":"","title":"","author":"","doi":"","netbase":[],"subjectList":[],"mediumData":"e-Book","publishData":"","minPrice":"10","maxPrice":"20","sortBy":"desc","sortOrderFieldName":"UnitPrice","drmData":"Both","currencyTypeData":"USD","firstPublishedYearData":"2018","publcFromDate":null,"publcToDate":null},"ruleElementLst":[{"type":"separator","value":"BEGIN"},{"attribute":"format","relationship":"IN","type":"criteria","value":"e-Book"},{"type":"logical","value":"AND"},{"attribute":"firstPublishedYear","relationship":"EQ","type":"criteria","value":"2018"},{"type":"logical","value":"AND"},{"type":"separator","value":"BEGIN"},{"attribute":"prices.price","relationship":"GE","type":"criteria","value":"10"},{"type":"logical","value":"AND"},{"attribute":"prices.price","relationship":"LE","type":"criteria","value":"20"},{"type":"logical","value":"AND"},{"attribute":"prices.currency","relationship":"EQ","type":"criteria","value":"USD"},{"type":"separator","value":"END"},{"type":"separator","value":"END"}],"queryString":"format EQ e-Book AND firstPublishedYear EQ 2018 AND minPrice GE 10 AND maxPrice LE 20 AND currency EQ USD "}';
        newParentProduct.Subject_Classifications__c='SCAG0505,SCAG0510'; 
        insert newParentProduct;
        
       
        
        TF_generateJSON.DotNotation testJSON=new TF_generateJSON.DotNotation();
            testJSON.title='testTitle';
            testJSON.type='book';
            testJSON.Author='testAuthor';
            testJSON.publicationDate='23-03-2021';
            testJSON.Publisher='Taylor';
            testJSON.Format='ebook';
            testJSON.ListPrice='23.00';
            testJSON.currency_X='GBP';
            testJSON.Code='TEST';
            testJSON.role='TEST';
    }
    
     private static Product2 insertProductforTesting(String product2RecordtypeId){
         Product2 p = new Product2(name='test', ProductCode='12345', IsActive=true, Description='test', RecordTypeId=product2RecordtypeId,
            ISBN__c = '12345678901234', Competitor_Publisher__c='test', Subject_Code__c='test',BusinessId__c='SDGO-PRODATA',Product_category__c='SDGO',sales_Channels__c='UBX_sales');
          insert p;
        return p;
    }
    private static testMethod void TestGenerateS3Json() {
        String strJason;
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        system.debug(productRecordtypeId);
        
        product2 newParentProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        /*  Product2 newParentProduct = new Product2();
newParentProduct.name='test';
newParentProduct.IsActive=true;
newParentProduct.Description='test';
newParentProduct.RecordTypeId=productRecordtypeId;
// newParentProduct.Category__c='cat1,cat2,cat3';
//newParentProduct.keywords__c='key1,key2,key3';
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
newParentProduct.Sales_Channels__c = 'UNSDG;UBX;All';
newParentProduct.Applicable_Channels__c = 'All;UBX;ProQuest;Gobi';
newParentProduct.Applicable_License_Types__c = 'Perpetuity;Subscription;All';
newParentProduct.Applicable_Channels__c = 'All;UBX;ProQuest;Gobi;All';
newParentProduct.Applicable_Customer_Types__c = 'Institution;Individual;Government;All';

insert newParentProduct;*/
        
        list<Bundle_Line_Item__c> listofLineItems = new  list< Bundle_Line_Item__c>();
        Bundle_Line_Item__c bndlFirst = new Bundle_Line_Item__c();
        bndlFirst.Product_Bundle_Parent__c=newParentProduct.id;
        //bndlFirst.name='test1';
        bndlFirst.Title__c='testTitle1';
        
        Bundle_Line_Item__c bndlSecond = new Bundle_Line_Item__c();
        bndlSecond.Product_Bundle_Parent__c=newParentProduct.id;
        //bndlSecond.name='test2';
        bndlSecond.Title__c='testTitle2';
        listofLineItems.add(bndlFirst);
        listofLineItems.add(bndlSecond); 
        insert listofLineItems;
        
        strJason=TF_GenerateJson.GenerateS3Json(newParentProduct.Id, listofLineItems);
        strJason=TF_GenerateJson.GenerateS3Json(newParentProduct.Id, null);
        
        newParentProduct.Sales_Channels__c = 'UBX_Sales';
        newParentProduct.Applicable_License_Types__c = 'Perpetual;Subscription';
        newParentProduct.Applicable_Channels__c = 'UBX_Delivery';
        newParentProduct.Applicable_Customer_Types__c = 'Institution;Individual;Government';
        update newParentProduct;
        
        strJason=TF_GenerateJson.GenerateS3Json(newParentProduct.Id, listofLineItems);
        
        
        system.debug(strJason);
        System.assert(strJason!= null);
        test.stopTest();
    } 
    
    private static testMethod void TestGenerateSNSJson() {
        String strJason;
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        system.debug(productRecordtypeId);
        //Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        strJason=TF_GenerateJson.GenerateSNSJson(newParentProduct.Id,'https://s3-euw1-ap-pe-df-product-store-products-d.s3.eu-west-1.amazonaws.com/');
        System.assert(strJason!= null);
        test.stopTest();
    }
    
    private static testMethod void TestGenerateValidationJson() {
        String strJason;
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        
        product2 newParentProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        
        /*Product2 newParentProduct = new Product2();
newParentProduct.name='test1'; 
newParentProduct.IsActive=true;
newParentProduct.Description='test';
newParentProduct.RecordTypeId=productRecordtypeId;
newParentProduct.Product_Type_Author_Facing__c='Manual Curation';
newParentProduct.inLanguage__c='en';

insert newParentProduct;*/
        
        list<Bundle_Line_Item__c> listofLineItems = new  list< Bundle_Line_Item__c>();
        
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Title__c='World Heritage';
        lineItem.IsUnsilo__c=true;
        lineItem.Authors__c='Rosalie Callway'; 
        lineItem.doi__c='1234';
        lineItem.Content_Position__c= 1 ;
        lineItem.Type__c='creativeWork';
        lineItem.mediaType__c='doc';   
        lineItem.Product_Bundle_Parent__c=newParentProduct.id;
        insert lineItem;        
        Bundle_Line_Item__c lineItem2 = new Bundle_Line_Item__c();
        lineItem2.Title__c='World Heritage';
        lineItem2.IsUnsilo__c=true;
        lineItem2.Authors__c='Rosalie Callway'; 
        lineItem2.doi__c='5678';
        lineItem2.Content_Position__c= 2 ;
        lineItem2.Type__c='creativeWork';
        lineItem2.mediaType__c='doc';       
        lineItem2.Product_Bundle_Parent__c=newParentProduct.id;
        
        insert lineItem2;   
        
        listofLineItems.add(lineItem2);
        listofLineItems.add(lineItem);
        
        TF_GenerateJson.ValidationJson vj;
        
        vj = TF_GenerateJson.GenerateValidationJson(newParentProduct.id, system.now(),0,0,0,null);
        vj = TF_GenerateJson.GenerateValidationJson(newParentProduct.id, system.now(),0,0,0,listofLineItems);
        
        
        System.assert(vj.jsonString!= null);
        test.stopTest();
    }
    
    private static testMethod void TestGenerateQueryJson() {
        String strJason;
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        
        product2 newParentProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        TF_PPDProcessController.MultiTypeRules multiTypeRules = new TF_PPDProcessController.MultiTypeRules();
        List<TF_PPDProcessController.MultiTypeRules> multiTypeRulesLst = new List<TF_PPDProcessController.MultiTypeRules>();
        
        List<TF_PPDProcessController.RuleElement> ruleElementLst = new List<TF_PPDProcessController.RuleElement>();
        TF_PPDProcessController.querySaveElement savedQry = new TF_PPDProcessController.querySaveElement();
        savedQry = TF_PPDProcessController.parseRuleJson(newParentProduct.id);
        multiTypeRules.ruleElementLst = savedQry.ruleElementLst ;
        multiTypeRules.productType = 'Book';
        multiTypeRulesLst.add(multiTypeRules);
        strJason = TF_GenerateJson.GenerateQueryJson(newParentProduct.id,'Book',multiTypeRulesLst,0,10);
        
        System.assert(strJason != null);
        
        test.stopTest();
    }
    
    private static testMethod void TestGenerateDynamicPkgJson() {
        String strJason;
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        
        product2 newParentProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        List<TF_PPDProcessController.RuleElement> ruleElementLst = new List<TF_PPDProcessController.RuleElement>();
        List<TF_PPDProcessController.MultiTypeRules> multiTypeRulesLst = new List<TF_PPDProcessController.MultiTypeRules>();
        TF_PPDProcessController.MultiTypeRules multiTypeRules = new TF_PPDProcessController.MultiTypeRules();
        TF_PPDProcessController.querySaveElement savedQry = new TF_PPDProcessController.querySaveElement();
        savedQry = TF_PPDProcessController.parseRuleJson(newParentProduct.id);
        if(savedQry != null && savedQry.ruleElementLst != null){
            
            ruleElementLst = savedQry.ruleElementLst ;
            multiTypeRules.ruleElementLst = ruleElementLst ;
            multiTypeRules.productType = 'Book';
            multiTypeRulesLst.add(multiTypeRules);
        }

        strJason = TF_GenerateJson.GenerateDynamicPackageJson(newParentProduct.id,multiTypeRulesLst);
        
        System.assert(strJason != null);
        
        test.stopTest();
    }
    
    
    private static testMethod void TestGenerateQueryJsonNewModel() {
        String strJason;
        String strJason2;

        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        
        product2 newParentProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        TF_PPDProcessController.MultiTypeRules multiTypeRules = new TF_PPDProcessController.MultiTypeRules();
        List<TF_PPDProcessController.MultiTypeRules> multiTypeRulesLst = new List<TF_PPDProcessController.MultiTypeRules>();
        
        List<TF_PPDProcessController.RuleElement> ruleElementLst = new List<TF_PPDProcessController.RuleElement>();
        TF_PPDProcessController.querySaveElement savedQry = new TF_PPDProcessController.querySaveElement();
        savedQry = TF_PPDProcessController.parseRuleJson(newParentProduct.id);
        multiTypeRules.ruleElementLst = savedQry.ruleElementLst ;
        multiTypeRules.productType = 'book';
        multiTypeRulesLst.add(multiTypeRules);
        strJason = TF_GenerateJson.GenerateQueryJsonNewModel(newParentProduct.id,'book',multiTypeRulesLst,0,'',10,'Collections');
		strJason2 = TF_GenerateJson.GenerateQueryJsonNewModel(newParentProduct.id,'book',multiTypeRulesLst,0,'',10,'OPC');

        System.assert(strJason != null);
        System.assert(strJason2 != null);

        
        test.stopTest();
    }
    private static testMethod void TestGenerateCountAPIJson() {
        String strJason;
        String strJason2;
        
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        
        product2 newParentProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        TF_PPDProcessController.MultiTypeRules multiTypeRules = new TF_PPDProcessController.MultiTypeRules();
        List<TF_PPDProcessController.MultiTypeRules> multiTypeRulesLst = new List<TF_PPDProcessController.MultiTypeRules>();
        
        List<TF_PPDProcessController.RuleElement> ruleElementLst = new List<TF_PPDProcessController.RuleElement>();
        TF_PPDProcessController.querySaveElement savedQry = new TF_PPDProcessController.querySaveElement();
        savedQry = TF_PPDProcessController.parseRuleJson(newParentProduct.id);
        multiTypeRules.ruleElementLst = savedQry.ruleElementLst ;
        multiTypeRules.productType = 'book';
        multiTypeRulesLst.add(multiTypeRules);
        strJason = TF_GenerateJson.GenerateCountAPIJson(newParentProduct.id,'book',multiTypeRulesLst,0,10,'Collections');
        strJason2 = TF_GenerateJson.GenerateCountAPIJson(newParentProduct.id,'book',multiTypeRulesLst,0,10,'OPC');
        
         System.assert(strJason != null);
         System.assert(strJason2 != null);
        
        test.stopTest();
    }
    
     private static testMethod void TestGenerateCommonModelJson() {
          String strJason;
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        system.debug(productRecordtypeId);
        
        product2 newParentProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
         
          TF_PPDProcessController.MultiTypeRules multiTypeRules = new TF_PPDProcessController.MultiTypeRules();
        List<TF_PPDProcessController.MultiTypeRules> multiTypeRulesLst = new List<TF_PPDProcessController.MultiTypeRules>();
        
        List<TF_PPDProcessController.RuleElement> ruleElementLst = new List<TF_PPDProcessController.RuleElement>();
        TF_PPDProcessController.querySaveElement savedQry = new TF_PPDProcessController.querySaveElement();
        savedQry = TF_PPDProcessController.parseRuleJson(newParentProduct.id);
        multiTypeRules.ruleElementLst = savedQry.ruleElementLst ;
        multiTypeRules.productType = 'book';
        multiTypeRulesLst.add(multiTypeRules);
         
         
       list<Bundle_Line_Item__c> listofLineItems = new  list< Bundle_Line_Item__c>();
        Bundle_Line_Item__c bndlFirst = new Bundle_Line_Item__c();
        bndlFirst.Product_Bundle_Parent__c=newParentProduct.id;
        //bndlFirst.name='test1';
        bndlFirst.Title__c='testTitle1';
        
        Bundle_Line_Item__c bndlSecond = new Bundle_Line_Item__c();
        bndlSecond.Product_Bundle_Parent__c=newParentProduct.id;
        //bndlSecond.name='test2';
        bndlSecond.Title__c='testTitle2';
        listofLineItems.add(bndlFirst);
        listofLineItems.add(bndlSecond); 
        insert listofLineItems;
         
        strJason=TF_GenerateJson.GenerateCommonModelJson(newParentProduct.Id, listofLineItems,null);
        strJason=TF_GenerateJson.GenerateCommonModelJson(newParentProduct.Id, null,null);
         
        newParentProduct.Sales_Channels__c = 'UBX_Sales';
        newParentProduct.Applicable_License_Types__c = 'Perpetual;Subscription';
        newParentProduct.Applicable_Channels__c = 'UBX_Delivery';
        newParentProduct.Applicable_Customer_Types__c = 'Institution;Individual;Government';
        update newParentProduct;
        
        strJason=TF_GenerateJson.GenerateCommonModelJson(newParentProduct.Id, listofLineItems,null);
         
         strJason=TF_GenerateJson.GenerateCommonModelJson(newParentProduct.Id, null,multiTypeRulesLst);

        system.debug(strJason);
        System.assert(strJason== null);
        test.stopTest();
     }
    
     private static testMethod void TestGenerateDownloadSearchJson() {
         String strJason;
        String strJason2;

        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        
        product2 newParentProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        TF_PPDProcessController.MultiTypeRules multiTypeRules = new TF_PPDProcessController.MultiTypeRules();
        List<TF_PPDProcessController.MultiTypeRules> multiTypeRulesLst = new List<TF_PPDProcessController.MultiTypeRules>();
        
        List<TF_PPDProcessController.RuleElement> ruleElementLst = new List<TF_PPDProcessController.RuleElement>();
        TF_PPDProcessController.querySaveElement savedQry = new TF_PPDProcessController.querySaveElement();
        savedQry = TF_PPDProcessController.parseRuleJson(newParentProduct.id);
        multiTypeRules.ruleElementLst = savedQry.ruleElementLst ;
        multiTypeRules.productType = 'book';
        multiTypeRulesLst.add(multiTypeRules);
          strJason = TF_GenerateJson.GenerateDownloadSearchJson(newParentProduct.id,'book',multiTypeRulesLst,0,10,'Collections');
		strJason2 = TF_GenerateJson.GenerateDownloadSearchJson(newParentProduct.id,'book',multiTypeRulesLst,0,10,'OPC');

        System.assert(strJason != null);
        System.assert(strJason2 != null);

        
        test.stopTest();
         
         
     }
    
    
    private static testMethod void TestGenerateSkuUpdateJson() {
        String strJason;
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        system.debug(productRecordtypeId);
        
        Product2 newParentProduct=insertProductforTesting(productRecordtypeId);
        strJason=TF_GenerateJson.GenerateSkuUpdateJson(newParentProduct.Id);
        System.assert(strJason!= null);
        test.stopTest();
    }
        
}