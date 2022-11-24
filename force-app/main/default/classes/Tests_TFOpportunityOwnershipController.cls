@isTest
private class Tests_TFOpportunityOwnershipController {
    private static Account acc;
    private static Opportunity opp;
    
    private static String OPT_PRICEAGREEMENT = 'Price Agreement';
    private static String OPT_DIRECTDEAL = 'Direct Deal';
    private static String OPT_CONS_MEM = 'Consortium Member';
    private static String CONSORTIUM = 'Consortium';    

    static testMethod void testController() {
        initData();
        
        // Test 1 - invalid id
        ApexPages.CurrentPage().getParameters().put('id',null);
        TFOpportunityOwnershipController tooc = new TFOpportunityOwnershipController();
        
        System.assertEquals(null, tooc.opp);
        System.assert(tooc.isError);
        
        // Test 2 - valid opp Id with no acc Id as a URL parm
        ApexPages.CurrentPage().getParameters().put('id',opp.id);
        tooc = new TFOpportunityOwnershipController();
        
        System.assert(!tooc.isError);
        System.assertEquals(acc.id, tooc.opp.accountId);
    }
    
    static testMethod void testRefreshMemberList(){
        // Setup the data
        initData();
        Account consortiumMember = setupTestAccount('Non-Consort',UserInfo.getUserId());
        TandF_Account_to_Consortium__c membershipLink = new TandF_Account_to_Consortium__c(ConsortiumParent__c=acc.id, consortium_member__c=consortiumMember.id);
        insert membershipLink;
        
        // Test 1 - Selected Deal - Direct Deal
        ApexPages.CurrentPage().getParameters().put('id',opp.id);
        TFOpportunityOwnershipController tooc = new TFOpportunityOwnershipController();
        tooc.selectedDeal = OPT_DIRECTDEAL;
        
        tooc.refreshMemberList();
        
        for(SelectOption opt: tooc.memberOptions){
            //System.assert(opt.getDisabled());
        }
        
        // Test 2 - Seleted Deal - Price Agreement
        tooc.selectedDeal = OPT_PRICEAGREEMENT;
        tooc.refreshMemberList();
        
        for(SelectOption opt: tooc.memberOptions){
            System.assert(!opt.getDisabled());
        }       
    }
    
    static testMethod void testSaveRecord(){
        // Setup the data
        initData();
        Account consortiumMember = setupTestAccount('Non-Consort',UserInfo.getUserId());
        TandF_Account_to_Consortium__c membershipLink = new TandF_Account_to_Consortium__c(ConsortiumParent__c=acc.id, consortium_member__c=consortiumMember.id);
        insert membershipLink;
        
        ApexPages.CurrentPage().getParameters().put('id',opp.id);
        TFOpportunityOwnershipController tooc = new TFOpportunityOwnershipController();
        tooc.selectedDeal = OPT_PRICEAGREEMENT;
        
        // Test 1 - No consortium members belong to this opp yet
        List<Account_To_Opportunity__c> accsToOpps = [SELECT id,account__c FROM Account_To_Opportunity__c WHERE opportunity__c = :opp.id];
        System.assertEquals(0,accsToOpps.size());
        
        tooc.selectedMembers.add(tooc.memberOptions[0].getValue());
        tooc.saveRecord();        
        
        // Test 2 - 1 member now
        accsToOpps = [SELECT id,account__c FROM Account_To_Opportunity__c WHERE opportunity__c = :opp.id];
        System.assertEquals(1,accsToOpps.size());
                
    }
    
    /* Shared Methods */
    private static void initData(){
        setupTestAccount();
        setupTestOpp(acc.id);
    }
    
    private static void setupTestAccount(){
        acc = setupTestAccount('Test',UserInfo.getUserId());
    }
    
    private static Account setupTestAccount(String accountName, ID userId) {
        Account a = new Account(name=accountName,
            OwnerId=userId,
            BillingStreet='1234 Main Street');  
        insert a;
        return a;
    } 
        
    private static void setupTestOpp(Id accId){
        opp = setupTestOpportunity('Test', accId, 'Test', 'Test', UserInfo.getUserId());
    }
    
    private static Opportunity setupTestOpportunity(String oppName, ID accountId, String oppType, String oppStageName, Id ownerId) {
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
        Opportunity o = new Opportunity(
            name=oppName,
            Type = oppType,
            stagename=oppStageName,
            CurrencyIsoCode = 'USD',
            Probability=100,
            closedate=Date.newInstance(2011, 01, 01),
            accountId=accountId,
            RecordTypeid = oppRtId,
            OwnerId = ownerId
        );
        insert o;
        return o;
    } 
}