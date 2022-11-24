/******************************************************************
* Tests: TF_IRP_UpdateOppStage_Trig             100%
*******************************************************************/

@isTest
private class zTEST_TF_IRP_UpdateOppStage_Trig {
    
    static testMethod void testMetho1() {   
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');       
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry();
        Product2 prdObj = createProductTestData();
        TriggerInterfaceHelper.runTrigger('TF_IRP_UpdateOppStage_Trig', 'Opportunity', 99, 'ai,au', oppRecordtypeId, null);
        
        try {
            Opportunity oppObj = new Opportunity();
            oppObj.Id = opp.Id;
            oppObj.Is_Reprint_Eligibility_Request_Sent__c = true;
            oppObj.Is_Reprint_Eligibility_Checked__c = true;
            update oppObj; 
            
            List<Opportunity> opps = [SELECT Id, StageName FROM Opportunity WHERE Id=:opp.Id];
            system.assertEquals('Investigating', opps[0].StageName);
            
        }
        catch(Exception ex) {
            system.debug('Exception::'+ex.getMessage());
        }
    }

    static testMethod void testMetho2() {   
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');       
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry();
        Product2 prdObj = createProductTestData();
        TriggerInterfaceHelper.runTrigger('TF_IRP_UpdateOppStage_Trig', 'Opportunity', 99, 'ai,au', oppRecordtypeId, null);
        
        try {
            Opportunity oppObj = new Opportunity();
            oppObj.Id = opp.Id;
            oppObj.Is_Reprint_Eligibility_Request_Sent__c = true;
            oppObj.Is_Reprint_Eligibility_Checked__c = true;
            oppObj.Is_UMC_Request_Sent__c = true;
            update oppObj; 
            
            List<Opportunity> opps = [SELECT Id, StageName FROM Opportunity WHERE Id=:opp.Id];
            system.assertEquals('Evaluating', opps[0].StageName);   
        }
        catch(Exception ex) {
            system.debug('Exception::'+ex.getMessage());
        }
    }

    static testMethod void testMetho3() {   
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');       
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry();
        Product2 prdObj = createProductTestData();
        TriggerInterfaceHelper.runTrigger('TF_IRP_UpdateOppStage_Trig', 'Opportunity', 99, 'ai,au', oppRecordtypeId, null);
        
        try {
            Opportunity oppObj = new Opportunity();
            oppObj.Id = opp.Id;
            oppObj.Is_Reprint_Eligibility_Request_Sent__c = true;
            oppObj.Is_Reprint_Eligibility_Checked__c = true;
            oppObj.Is_UMC_Request_Sent__c = true;
            oppObj.Is_MRP_Request_Sent__c = true;
            update oppObj; 
            
            List<Opportunity> opps = [SELECT Id, StageName FROM Opportunity WHERE Id=:opp.Id];
            system.assertEquals('Negotiation', opps[0].StageName);   
        }
        catch(Exception ex) {
            system.debug('Exception::'+ex.getMessage());
        }
    }

    static testMethod void testMetho4() {   
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');       
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry();
        Product2 prdObj = createProductTestData();
        TriggerInterfaceHelper.runTrigger('TF_IRP_UpdateOppStage_Trig', 'Opportunity', 99, 'ai,au', oppRecordtypeId, null);
        
        try {
            Opportunity oppObj = new Opportunity();
            oppObj.Id = opp.Id;
            oppObj.Is_Reprint_Eligibility_Request_Sent__c = true;
            oppObj.Is_Reprint_Eligibility_Checked__c = true;
            oppObj.Is_UMC_Request_Sent__c = true;
            oppObj.Is_MRP_Request_Sent__c = true;
            oppObj.Is_Pricing_Entered__c = true;
            update oppObj; 
            
            List<Opportunity> opps = [SELECT Id, StageName FROM Opportunity WHERE Id=:opp.Id];
            system.assertEquals('Acceptance', opps[0].StageName);   
        }
        catch(Exception ex) {
            system.debug('Exception::'+ex.getMessage());
        }
    }
    
    private static Product2 createProductTestData() {
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 product = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);
        product.name='test';
        product.IsActive=true;
        product.Description='test';
        product.RecordTypeId=productRecordtypeId;
        product.ProductCode='9780367463151';       
        insert product;
        return product;
    }     
}