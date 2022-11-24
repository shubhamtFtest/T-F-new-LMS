/************************************************************************** 
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2012-04-09
** Modified by Hailey Niemand - 2017.01.26 - CHG0031794
** CAS_OpportuntityAutoCloseSchedule
** CAS_OpportuntityAutoCloseBatch
***************************************************************************/
@isTest
private class zTEST_CAS_OpportuntityAutoCloseBatch {

    static testMethod void myUnitTest() {
        //zTEST_Shared testShared = new zTEST_Shared();
        
        //RecordType rtOpp = [Select r.Id, r.Name, r.SobjectType, r.SystemModstamp from RecordType r  where r.SobjectType = 'opportunity' and r.Name like 'CAS%' and IsActive = true order by  r.SystemModstamp limit 1];
        RecordType rtOpp = [Select r.Id, r.Name, r.SobjectType, r.SystemModstamp from RecordType r  where r.SobjectType = 'opportunity' and r.Name like 'T&F - CAS%' and IsActive = true order by  r.SystemModstamp limit 1]; //CHG0031794
        PricebookEntry pbe = insertPricebookEntry();
        
        User u = zTEST_Shared.noinsertUser();
        insert u;
        //Closed Won  Scenario
        Opportunity oppClosedWon = new Opportunity(StageName = 'proposal', CloseDate= system.now().date().addDays(-50),ownerId = u.Id, RecordTypeId = rtOpp.Id,Name = 'Test', Course_Start_Date__c = system.now().date().addDays(-130));
        insert oppClosedWon;
        
        OpportunityLineItem oliClosedWon = zTEST_Shared.noinsertOpportunityLineItem(pbe.id,oppClosedWon.id,'Completed - Order Confirmed');
        insert oliClosedWon;
        
        
        //Completed  Scenario
        Opportunity oppClosedLost = new Opportunity(StageName = 'proposal', CloseDate= system.now().date().addDays(-50), ownerId = u.Id, RecordTypeId = rtOpp.Id,Name = 'Test', Course_Start_Date__c = system.now().date().addDays(-130));
        insert oppClosedLost;
        
        OpportunityLineItem oliClosedLost = zTEST_Shared.noinsertOpportunityLineItem(pbe.id,oppClosedLost.id,'Created');
        insert oliClosedLost;
        
        Opportunity oppIgnore = new Opportunity(StageName = 'proposal', CloseDate= system.now().date().addDays(-50),ownerId = u.Id, RecordTypeId = rtOpp.Id,Name = 'Test', Course_Start_Date__c = system.now().date().addDays(-130));
        insert oppIgnore;
        
        OpportunityLineItem oliIgnore = zTEST_Shared.noinsertOpportunityLineItem(pbe.id,oppIgnore.id,'Open - Under Consideration');
        insert oliIgnore;
        
        Opportunity oppInProcess= new Opportunity(StageName = 'proposal', CloseDate= system.now().date().addDays(-50),ownerId = u.Id, RecordTypeId = rtOpp.Id,Name = 'Test', Course_Start_Date__c = system.now().date().addDays(-130));
        insert oppInProcess;
        
        OpportunityLineItem oliInProcess = zTEST_Shared.noinsertOpportunityLineItem(pbe.id,oppInProcess.id,'In-Process');
        insert oliInProcess;
        
        
        
        Test.StartTest();
        CAS_OpportuntityAutoCloseBatch OpportuntityAutoClose = new CAS_OpportuntityAutoCloseBatch();
        OpportuntityAutoClose.isTesting = true;
        ID batchprocessid = Database.executeBatch(OpportuntityAutoClose); 
        Test.stopTest();
        
        System.Assert(true);
    }
    
    static testMethod void OpportuntityAutoCloseSchedule()  
    {
        Test.startTest();
        // Schedule the test job
        CAS_OpportuntityAutoCloseSchedule m = new CAS_OpportuntityAutoCloseSchedule();
        m.sendStatus = true;
        String sch = '20 30 8 10 2 ?';
        System.schedule('TEST_OpportuntityAutoCloseSchedule',sch, m);
        
        
        Test.stopTest();
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