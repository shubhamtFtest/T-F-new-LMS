@isTest(seeAllData=true)
private class OpportunityProductExtensionTest {

    static testMethod void myUnitTest() { 
    
    RecordType recType = [SELECT id, Name 
            FROM RecordType 
            WHERE sObjectType='Opportunity' 
            Limit 1];
            
    List<Account> accounts = new List<Account>{};
    
    Profile p = [select id from profile where name='Standard User'];
         //User u = new User(alias = 'standt1', email='standarduser@testorg1.com',
            //emailencodingkey='UTF-8', lastname='Testing1', languagelocalekey='en_US',
            //localesidkey='en_US', profileid = p.Id,
            //timezonesidkey='America/Los_Angeles', username='standardtquilabashuser2@testorg1.com');   
    User u = zTest_Shared.noinsertUser();        
    System.runAs(u) {
    for(Integer i = 0; i < 5; i++){
        Account a = new Account(Name = 'Test Account ' + i);
        accounts.add(a);
    }
   insert accounts;
   }
   Account a = [Select Id From Account Where Name='Test Account 1' Limit 1];
   
   Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - eBooks Opportunity'); //CHG0038379
        
   list<Opportunity> opportunities = new List<Opportunity>{}; 
    Pricebook2 pb2 = zTest_Shared.insertPricebook2(); 
    for(Integer i = 0; i < 5; i++){     
    Opportunity o = new Opportunity
    (
       Accountid  = a.Id,
       Name = 'opportunity ' + i,
       CloseDate = Date.today(),
       StageName = 'Prospect',
       RecordTypeId = oppRtId,  
      // CurrencyIsoCode = 'USD',
       pricebook2Id = pb2.id       
    );
    opportunities.add(o); 
    }

    test.startTest();
    insert opportunities;
    test.stopTest();
   
       
   //insert pb2;
   Product2 pro2 = new Product2(Name='Article Pass', isActive=true);
   insert pro2;
   PricebookEntry pbe =zTest_Shared.insertPricebookEntry(pb2.Id, pro2.Id); 
   Opportunitylineitem optli = zTest_Shared.insertOpportunityLineItem(pbe.Id,opportunities[0].Id);//[select Id from opportunityLineItem where id !=null Limit 1];
  // insert optli;
   String s = optli.id;
    
        ApexPages.StandardController cont = new ApexPages.StandardController(opportunities[0]);
        OpportunityProductExtension ext = new OpportunityProductExtension(cont);
        OpportunityProductExtension.ProductWrapper oProductWrapper = new OpportunityProductExtension.ProductWrapper();
        oProductWrapper.isToken = false;
        oProductWrapper.isCategory = false;
        ext.getSortDirection();//CHG0035801 
        ext.oppCurrency = 'Test';
        ext.hasPickAndMixProduct = false;
        ext.hasFeesProduct = false;
        ext.hasTokenProduct = false;
        ext.hasCategoryProduct = false;
        ext.getAllOppls();
        ext.getListOppls();
        ext.setListOppls(s);    
        ext.test();
        ext.AddProducts();
        ext.RemoveProducts();
                
    }
}