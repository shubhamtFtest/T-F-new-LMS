/**
/************************************************************************** 
** CHG0042490 Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2012-05-16
** Modified by Hailey Niemand - 2017.01.26 - CHG0031794
** 
***************************************************************************/
@isTest
private class zTest_CAS_NewOpportunityProduct {

    static testMethod void myUnitTest() {
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity');
        TriggerInterfaceHelper.runTrigger('CAS_NewOpportunityProduct_Trig', 'OpportunityLineItem', 99, 'ai', oppRecordtypeId, null); //CAS - Course Opportunities
        
        
        //RecordType rtOpp = [Select r.Id, r.Name, r.SobjectType, r.SystemModstamp from RecordType r  where r.SobjectType = 'opportunity' and r.Name like 'CAS%' and IsActive = true order by  r.SystemModstamp limit 1];
        RecordType rtOpp = [Select r.Id, r.Name, r.SobjectType, r.SystemModstamp from RecordType r  where r.SobjectType = 'opportunity' and r.Name like 'T&F - CAS%' and IsActive = true order by  r.SystemModstamp limit 1]; //CHG0031794
        PricebookEntry pbe = insertPricebookEntry();
        
        User u = zTEST_Shared.noinsertUser();
        
        insert u;
        //Closed Won  Scenario
        Opportunity opp = new Opportunity(StageName = 'proposal', CloseDate= system.now().date().addDays(50),ownerId = u.Id, RecordTypeId = oppRecordtypeId,Name = 'TestNewOpportunityProduct', Course_Start_Date__c = system.now().date());
        insert opp;
        
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(pbe.id,opp.id);
        insert oli;
        
        u.Email = 'error@testmethoderror.net';
        update u;
        
        OpportunityLineItem oli2 = zTEST_Shared.noinsertOpportunityLineItem(pbe.id,opp.id);
        insert oli2;
    }
    
    
      public static PricebookEntry insertPricebookEntry(){
        
        //Pricebook2 pb = [Select p.Id, p.IsActive, p.IsStandard, p.Name, p.SystemModstamp from Pricebook2 p  where p.IsStandard = true limit 1];
        
        String product2RecordtypeId = [select id from RecordType where sobjecttype = 'Product2' and IsActive = true limit 1].Id;
        Product2 p = zTEST_Shared.insertProduct2(product2RecordtypeId);
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id='01s0Y0000082FixQAE', Product2Id=p.id, UnitPrice=1.00, IsActive=true, UseStandardPrice=false);
        insert pbe;
        return pbe;
    }
    
    
}