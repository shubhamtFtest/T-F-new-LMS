/************************************************************************** 
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2013-02-27
* Modified by Hailey Niemand - 2017.01.26 - CHG0031794
* Modified by Jeff Lup - 2017.10.09 - CHG0038379
***************************************************************************/
@isTest
private class ZTest_CASPushlists {

    static testMethod void TestPushLists() {
        
        String isbn = '999Pushlists333';
        String profileId = '333';
        //RecordType rtOpp = [Select r.Id, r.Name, r.SobjectType, r.SystemModstamp from RecordType r  where r.SobjectType = 'opportunity' and r.Name like 'CAS%' and IsActive = true order by  r.SystemModstamp limit 1];
        RecordType rtOpp = [Select r.Id, r.Name, r.SobjectType, r.SystemModstamp from RecordType r  where r.SobjectType = 'opportunity' and r.Name like 'T&F - CAS%' and IsActive = true order by  r.SystemModstamp limit 1]; //CHG0031794
        PricebookEntry pbe = insertPricebookEntry(isbn);
        User u = zTEST_Shared.noinsertUser();
        insert u;
        
        Opportunity opp = new Opportunity(StageName = 'proposal', CloseDate= system.now().date().addDays(150),ownerId = u.Id, RecordTypeId = rtOpp.Id,Name = 'TestNewOpportunityProduct', Course_Start_Date__c = system.now().date());
        insert opp;
        
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(pbe.id,opp.id);
        insert oli;
        
        
        //Covers triggers TF_GTPushlistMapping & TF_GTPushlist
        UpsertPushlist(profileId, 'WhatzUp!!!!!!', 'WhatzUp!!!!!!', 'I');
        UpsertPushlistMappings(isbn, profileId, 'I');
        
        T_F_GT_Pushlist_Mappings__c PM = [Select t.Id, t.ISBN__c, t.ISBN_ProfileId__c, t.Name, t.Process__c, t.Product__c, t.PROFILE_NAME__c, t.T_F_GT_Pushlists__c from T_F_GT_Pushlist_Mappings__c t where t.ISBN__c =:isbn LIMIT 1];
        System.debug('####PM.Product__c: ' + PM.Product__c);
        System.debug('####PM.T_F_GT_Pushlists__c: ' + PM.T_F_GT_Pushlists__c);
        
        
        
        //Test controllers with data OpporttunityProductPushlistsCon & OpporttunityPushlistsCon
        TestOpporttunityPushlistsCon(opp);
        TestOpporttunityProductPushlistsCon(oli);
        
        //Covers triggers TF_GTPushlistMapping & TF_GTPushlist
        UpsertPushlist(profileId, 'WhatzUp!!!!!!', 'WhatzUp!!!!!!', 'D');
        UpsertPushlistMappings(isbn, profileId, 'D');
        
        //Test controllers without data OpporttunityProductPushlistsCon & OpporttunityPushlistsCon
        TestOpporttunityPushlistsCon(opp);
        TestOpporttunityProductPushlistsCon(oli);
    }
    
    
     private static void TestOpporttunityProductPushlistsCon(OpportunityLineItem oli) {
       
        PageReference pref = Page.Opportunity_Products_Pushlists;
        pref.getParameters().put('id',oli.id);
        Test.setCurrentPage(pref);
        OpporttunityProductPushlistsCon ext = new OpporttunityProductPushlistsCon(new ApexPages.StandardController(oli));
        ext.getPush();
        
    } 
    
     private static void TestOpporttunityPushlistsCon(Opportunity opp) {
       
        PageReference pref = Page.Opportunity_Pushlists;
        pref.getParameters().put('id',opp.Id);
        Test.setCurrentPage(pref);
        OpporttunityPushlistsCon ext = new OpporttunityPushlistsCon(new ApexPages.StandardController(opp));
        ext.getPush();
        
    } 
    
    
    static void UpsertPushlist(String profileId, String nameShort, String nameLong, String processType)
    {
     T_F_GT_Pushlists__c p = new T_F_GT_Pushlists__c( Name = nameShort, Process__c=processType, PROFILE_NAME__c=nameLong, SEL_ID_PROFILE__c =profileId  );
    
     upsert p SEL_ID_PROFILE__c;
     
    }
    
    static void UpsertPushlistMappings(String isbn, String profileId, String processType)
    {
        
        String externalId= '['+profileId+']' +isbn;
    T_F_GT_Pushlist_Mappings__c pm = new T_F_GT_Pushlist_Mappings__c( ISBN__c=isbn, ISBN_ProfileId__c=externalId, Name=profileId, Process__c= processType);
    upsert pm ISBN_ProfileId__c;
    }
    
     public static PricebookEntry insertPricebookEntry(String isbn){
        
        //Pricebook2 pb = [Select p.Id, p.IsActive, p.IsStandard, p.Name, p.SystemModstamp from Pricebook2 p  where p.IsStandard = true limit 1];
        
        String product2RecordtypeId = [select id from RecordType where sobjecttype = 'Product2' and name like 'T&F%' and IsActive = true limit 1].Id;
        Product2 p = zTEST_Shared.noinsertProduct2(product2RecordtypeId);
        p.ISBN__c = isbn;
        p.ProductCode = isbn;
        insert p;
        
        //PricebookEntry pbe = new PricebookEntry(Pricebook2Id='01s300000001JicAAE', Product2Id=p.id, UnitPrice=1.00, IsActive=true, UseStandardPrice=false);
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=Test.getStandardPricebookId(), Product2Id=p.id, UnitPrice=1.00, IsActive=true, UseStandardPrice=false);
        insert pbe;
        
        return pbe;
    }
    
}