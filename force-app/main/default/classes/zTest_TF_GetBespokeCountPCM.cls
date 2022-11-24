/***************************************************************************
Author : Vikas Varshney
Apex class : TF_GetBespokeCountPCM
****************************************************************************/

@isTest
global class zTest_TF_GetBespokeCountPCM {
    
    static testMethod void PCMCountTest() {
        Id productBespokeRT = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - BespokeCollection').getRecordTypeId();
        
        Account acc = new Account();
        acc.Customer_Id__c = '98422';
        acc.name = 'TestAcc';
        insert acc;
        
        Product2 p = new Product2();
        p.RecordTypeId = productBespokeRT;
        p.Product_Type_Author_Facing__c = 'Rule based';
        p.Name = 'Test_Bespoke_Dynamic';
        p.IsActive = true;
        p.Hub_Id__c = 'e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a';
        p.inLanguage__c = 'en';
        insert p;
        
        //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 stdPricebook = new Pricebook2( Id = Test.getStandardPricebookId(), IsActive = true );
        Update stdPricebook;
         
        //Query for the Pricebook2 record, to check IsStandard field
        stdPricebook = [ SELECT Id, IsStandard FROM Pricebook2 WHERE Id =:stdPricebook.Id ];
        //It should return true
        System.assertEquals(true, stdPricebook.IsStandard);
        
        PricebookEntry standardPriceEntry = new PricebookEntry(
            Pricebook2Id = stdPricebook.id, Product2Id = p.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPriceEntry;
        
        Pricebook2 customPB = new Pricebook2(Name='T&F Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPriceEntry = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = p.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPriceEntry;
        
        Test.startTest();
        String ruleStr = '{"filterObject":{"ISBN":"","title":"","author":"","doi":"","netbase":[],"subjectList":[],"mediumData":"","publishData":"","minPrice":"","maxPrice":"","sortBy":"","sortOrderFieldName":"UnitPrice","drmData":"","currencyTypeData":"","firstPubYearDataFrom":"","firstPubYearDataTo":"","textType":"","publisherImprint":"","publcFromDate":"","publcToDate":""},"multiTypeRulesLst":[{"productType":"book","queryString":"{ { First Published Year After (2020) } AND { Status Equals (Available) } AND { Open Access Not Equals (open-access) } AND { Restricted Country NOT IN (GB) } AND { Format IN (e-Book) } AND { Permission Not Equals (drm) } } ","ruleElementLst":[{"type":"separator","value":"BEGIN"},{"type":"separator","value":"BEGIN"},{"type":"separator","value":"BEGIN"},{"attribute":"book.firstPublishedYear","attributeLabel":"First Published Year","relationship":"GT","relationshipLabel":"After","type":"criteria","value":"2020"},{"type":"separator","value":"END"},{"type":"logical","value":"AND"},{"type":"separator","value":"BEGIN"},{"attribute":"book.status","attributeLabel":"Status","relationship":"EQ","relationshipLabel":"Equals","type":"criteria","value":"Available"},{"type":"separator","value":"END"},{"type":"logical","value":"AND"},{"type":"separator","value":"BEGIN"},{"attribute":"permissions.name","attributeLabel":"Open Access","relationship":"NE","relationshipLabel":"Not Equals","type":"criteria","value":"open-access"},{"type":"separator","value":"END"},{"type":"logical","value":"AND"},{"type":"separator","value":"BEGIN"},{"attribute":"rights.iso2","attributeLabel":"Restricted Country","relationship":"NI","relationshipLabel":"NOT IN","type":"criteria","value":"GB"},{"type":"separator","value":"END"},{"type":"logical","value":"AND"},{"type":"separator","value":"BEGIN"},{"attribute":"book.format","attributeLabel":"Format","relationship":"IN","relationshipLabel":"IN","type":"criteria","value":"e-Book"},{"type":"separator","value":"END"},{"type":"logical","value":"AND"},{"type":"separator","value":"BEGIN"},{"attribute":"permissions.name","attributeLabel":"Permission","relationship":"NE","relationshipLabel":"Not Equals","type":"criteria","value":"drm"},{"type":"separator","value":"END"},{"type":"separator","value":"END"},{"type":"separator","value":"END"}]}],"jsonString":"","isDynamicUi":"true"}';
        Product2 productUpdate = new Product2();
        productUpdate.id = p.id;
        productUpdate.Dynamic_Collection_Criteria__c = ruleStr;
        update productUpdate;
        
        /*String ruleStr2 = '{"filterObject":{"ISBN":"","title":"","author":"","doi":"","netbase":[],"subjectList":[],"mediumData":"","publishData":"","minPrice":"","maxPrice":"","sortBy":"","sortOrderFieldName":"UnitPrice","drmData":"","currencyTypeData":"","firstPubYearDataFrom":"","firstPubYearDataTo":"","textType":"","publisherImprint":"","publcFromDate":"","publcToDate":""},"multiTypeRulesLst":[{"productType":"book","queryString":"{ { First Published Year After (2021) } AND { Status Equals (Available) } AND { Open Access Not Equals (open-access) } AND { Restricted Country NOT IN (GB) } AND { Format IN (e-Book) } AND { Permission Not Equals (drm) } } ","ruleElementLst":[{"type":"separator","value":"BEGIN"},{"type":"separator","value":"BEGIN"},{"type":"separator","value":"BEGIN"},{"attribute":"book.firstPublishedYear","attributeLabel":"First Published Year","relationship":"GT","relationshipLabel":"After","type":"criteria","value":"2021"},{"type":"separator","value":"END"},{"type":"logical","value":"AND"},{"type":"separator","value":"BEGIN"},{"attribute":"book.status","attributeLabel":"Status","relationship":"EQ","relationshipLabel":"Equals","type":"criteria","value":"Available"},{"type":"separator","value":"END"},{"type":"logical","value":"AND"},{"type":"separator","value":"BEGIN"},{"attribute":"permissions.name","attributeLabel":"Open Access","relationship":"NE","relationshipLabel":"Not Equals","type":"criteria","value":"open-access"},{"type":"separator","value":"END"},{"type":"logical","value":"AND"},{"type":"separator","value":"BEGIN"},{"attribute":"rights.iso2","attributeLabel":"Restricted Country","relationship":"NI","relationshipLabel":"NOT IN","type":"criteria","value":"GB"},{"type":"separator","value":"END"},{"type":"logical","value":"AND"},{"type":"separator","value":"BEGIN"},{"attribute":"book.format","attributeLabel":"Format","relationship":"IN","relationshipLabel":"IN","type":"criteria","value":"e-Book"},{"type":"separator","value":"END"},{"type":"logical","value":"AND"},{"type":"separator","value":"BEGIN"},{"attribute":"permissions.name","attributeLabel":"Permission","relationship":"NE","relationshipLabel":"Not Equals","type":"criteria","value":"drm"},{"type":"separator","value":"END"},{"type":"separator","value":"END"},{"type":"separator","value":"END"}]}],"jsonString":"","isDynamicUi":"true"}';
        Product2 productUpdate2 = new Product2();
        productUpdate2.id = p.id;
        productUpdate2.Dynamic_Collection_Criteria__c = ruleStr2;
        update productUpdate2;*/
        Test.stopTest();
    }
     static testMethod void test_updatePriceBookEntryData() {
     Id productBespokeRT = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - BespokeCollection').getRecordTypeId();
        
        Account acc = new Account();
        acc.Customer_Id__c = '98422';
        acc.name = 'TestAcc';
        insert acc;
        
        Product2 p = new Product2();
        p.RecordTypeId = productBespokeRT;
        p.Product_Type_Author_Facing__c = 'Rule based';
        p.Name = 'Test_Bespoke_Dynamic';
        p.IsActive = true;
        p.Hub_Id__c = 'e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a';
        p.inLanguage__c = 'en';
        p.Sales_Price__c = 122;
        insert p;
        //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 stdPricebook = new Pricebook2( Id = Test.getStandardPricebookId(), IsActive = true );
        Update stdPricebook;
         
        //Query for the Pricebook2 record, to check IsStandard field
        stdPricebook = [ SELECT Id, IsStandard FROM Pricebook2 WHERE Id =:stdPricebook.Id ];
        //It should return true
        System.assertEquals(true, stdPricebook.IsStandard);
        
        PricebookEntry standardPriceEntry = new PricebookEntry(
            Pricebook2Id = stdPricebook.id, Product2Id = p.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPriceEntry;
        
        Pricebook2 customPB = new Pricebook2(Name='T&F - eBooks Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPriceEntry = new PricebookEntry(
        Pricebook2Id = customPB.Id, Product2Id = p.Id,
        UnitPrice = 12000, IsActive = true);
        insert customPriceEntry;
        
        Test.startTest();
        Product2 productUpdate = new Product2();
        productUpdate.id = p.id;
        productUpdate.Sales_Price__c = 200;
        update productUpdate;
        
        Test.stopTest();
        List<Pricebook2> bespokePriceBookList = new List<Pricebook2>();
        bespokePriceBookList = [ SELECT Id FROM Pricebook2 WHERE Name = 'T&F - eBooks Pricebook' ];
        PricebookEntry customPriceEntry1 = [SELECT id, UnitPrice, CurrencyIsoCode FROM PricebookEntry WHERE Product2Id =: p.id AND Pricebook2Id IN:bespokePriceBookList];
        System.assertEquals(customPriceEntry1.UnitPrice, 200);
     }
}