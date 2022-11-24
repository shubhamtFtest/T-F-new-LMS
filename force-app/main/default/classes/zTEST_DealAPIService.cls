@isTest
public class zTEST_DealAPIService {
    @testSetup 
    public static void setupMethod() {
        String priceBookName = 'T&F CPQ Price Book 2017';
        Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
   
        Account accObject1 = new Account(); 
        accObject1.Name = 'Test1Acc11032022';
        accObject1.Ringgold_Account_ID__c = '9451865';
        accObject1.Type = 'Consortium';
        insert accObject1;
        Account accObject2 = new Account(Name = 'Test2Acc11032022',Type = 'Institution',RecordTypeId = TFAccountsRecordTypeId,Manual_Check__c = True , Ringgold_Account_ID__c='677822163',Ringgold_Access_ID__c='677822163' , Ringgold_Org_ID__c='677822163'); 
        insert accObject2;
        Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
        Product2 prodObject = new Product2(Name = 'Test Product', 
                                           RecordTypeId = TFProductsRecordTypeId,
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           ProductCode = 'XYZ',
                                           Readership_Level__c = 'Test',
                                           IsActive = true,
                                           Family = 'Journal Service Product');  
        insert prodObject;                 
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> priceBEList = new List<PricebookEntry>();
        PricebookEntry priceBE1 = new PricebookEntry(CurrencyIsoCode = 'USD',IsActive = True, Pricebook2Id = standardPricebookId, Product2Id = prodObject.Id,UnitPrice = 100.00);                                  
        priceBEList.add(priceBE1);                              
        insert priceBEList;
        Pricebook2 priceBook2 = new Pricebook2(Name = priceBookName, IsActive = True);
        insert priceBook2;
        List<PricebookEntry> priceBEList2 = new List<PricebookEntry>();
        PricebookEntry priceBE2 = new PricebookEntry(CurrencyIsoCode = 'USD',IsActive = True, Pricebook2Id = priceBook2.Id, Product2Id = prodObject.Id,UnitPrice = 100.00);                                                           
        priceBEList2.add(priceBE2);                              
        insert priceBEList2;
        Id promoCodeRecTypeId = Schema.SObjectType.Sales_Deal__c.getRecordTypeInfosByName().get('Promocode Deal').getRecordTypeId();      
        Sales_Deal__c sd = new Sales_Deal__c(Deal_Name__c='test name1',Start_Date__c=date.today(),End_Date__c=date.today()+50,Type_of_Deal__c='APC Deal',Promocode__c='testCode',Discount_Category__c='Ad hoc', RecordTypeId= promoCodeRecTypeId,Product__c=prodObject.id);
        insert sd;
        Deal_Member__c dm1 = new Deal_Member__c(Sales_Deal__c=sd.Id, Account__c=accObject1.Id,Type__c='Consortium');
        insert dm1;        
        Deal_Member__c dm2 = new Deal_Member__c(Account__c=accObject2.Id,Type__c='Institution',Deal_Member__c = dm1.Id);
        insert dm2;  
        Deal_Member__c dm3 = new Deal_Member__c();
        dm3.Type__c = 'Department';
        dm3.Department_RinggoldId__c = '99930022544';
        dm3.Department_name__c = 'test department';
        insert dm3;  
    }
    /*Test method for Get Deal API*/
    private static testmethod void testMethod1(){
		//consortium         
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/dealAPIService';
        req.httpMethod = 'GET';
        req.addParameter('ringGoldId','9451865');
        RestContext.request = req;
        RestContext.response= res;
		Test.startTest();        
        TF_DealAPIService.doGet();
        Test.stopTest(); 
        
    }
    
    private static testmethod void testMethod2(){
        //Institution
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/dealAPIService';
        req.httpMethod = 'GET';
        req.addParameter('ringGoldId', '677822163');
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        TF_DealAPIService.doGet();
        Test.stopTest(); 
        
    }
    
    private static testmethod void testMethod3(){
        //Department
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/dealAPIService';
        req.httpMethod = 'GET';
        req.addParameter('ringGoldId','99930022544');
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        TF_DealAPIService.doGet();
        Test.stopTest(); 
        
    }
    
    private static testmethod void testMethod4(){
        //no sales deals.
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        //req.params = 'ringGoldId=1026';
        req.requestURI = '/services/apexrest/dealAPIService';
        req.httpMethod = 'GET';
        req.addParameter('ringGoldId','9999999999');
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        TF_DealAPIService.doGet();
        Test.stopTest(); 
    }
	/*Test method for Get Deal API*/
    
    /*Test method for POST method*/
    private static testmethod void testMethod5(){
        String inputPayload = '{"source" : "OAD","config" :{"name" : "Test03FebABC","shortDescription":"OA Deal","description" : "","startDate" : "11/04/2020","endDate" : "11/04/2030","type" : "Institution Deal","active":"true","productType" : "APC Deal","fundType" : "PrePayment","apcConfig" : {"openAccessCategory" : "Open Select","priceCategory" : "Standard","productInclusion" : ["TMRL","CIJW"],"productExclusion" : ["ASDF"]},"customerConfig": [{"type" : "Institution","ringGoldId" : "56390","name" : "University of the Western Cape","isTnFAccount" : true,"children" : [{"type" : "Department","ringGoldId" : "162931","name" : "University of the Western Cape Department of English","isTnFAccount" : false},{"type" : "Department","ringGoldId" : "446278","name" : "University of the Western Cape Department of Anthropology and Sociology","isTnFAccount" : false}]},{"type" : "Consortium","ringGoldId" : "8808","name" : "Irel","isTnFAccount" : true,"children":[{"type" : "Institution","ringGoldId" : "8809","name" : "University of Limerick","isTnFAccount" : true,"children" : [{"type" : "Department","ringGoldId" : "455907","name" : "University of Limerick Language Centre","isTnFAccount" : false},{"type" : "Department","ringGoldId" : "64577","name" : "University of Limerick Department of Economics","isTnFAccount" : false} ]} ] }],"discountConfig" :{"discountType" : "% Discount","discountValue": "100"}}} ';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        //req.params = 'ringGoldId=1026';
        req.requestURI = '/services/apexrest/dealAPIService';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(inputPayload);
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        TF_DealAPIService.doPost();
        Test.stopTest(); 
    }
    
    /*Test method for DELETE method*/
    private static testmethod void testMethod6(){
        //delete Department
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        Deal_Member__c dmRec = [SELECT Id FROM Deal_Member__c WHERE Department_RinggoldId__c = '99930022544' LIMIT 1];
        String dealId = dmRec.Id;
        req.requestURI = '/services/apexrest/dealAPIService/'+dealId;
        req.httpMethod = 'DELETE';
        req.addParameter('type','Department');
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        TF_DealAPIService.doDelete();
        Test.stopTest();         
    }
    private static testmethod void testMethod7(){
        //delete institution
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        Deal_Member__c dmRec = [SELECT Id FROM Deal_Member__c WHERE Account_RingGold_ID__c='677822163' LIMIT 1];
        String dealId = dmRec.Id;
        req.requestURI = '/services/apexrest/dealAPIService/'+dealId;
        req.httpMethod = 'DELETE';
        req.addParameter('type','Institution');
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        TF_DealAPIService.doDelete();
        Test.stopTest();         
    }
    private static testmethod void testMethod8(){
        //delete Consortium
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        Deal_Member__c dmRec = [SELECT Id FROM Deal_Member__c WHERE Account_RingGold_ID__c='9451865' LIMIT 1];
        
        String dealId = dmRec.Id;
        req.requestURI = '/services/apexrest/dealAPIService/'+dealId;
        req.httpMethod = 'DELETE';
        req.addParameter('type','Consortium');
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        TF_DealAPIService.doDelete();
        Test.stopTest();         
    }
    private static testmethod void testMethod9(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/dealAPIService';
        req.httpMethod = 'GET';
        req.addParameter('ringGoldId','9451865');
        req.addParameter('includeParentDeal','test');
        RestContext.request = req;
        RestContext.response= res;
		Test.startTest();        
        TF_DealAPIService.doGet();
        Test.stopTest(); 
    }
}