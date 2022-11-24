@isTest
public with sharing class Tests_TFConsortiumMembershipComCon {
    private static Account acc;
    private static String CONSORTIUM = 'Consortium';
    private static String OTHER = 'Other';

    static TestMethod void testConstructor(){
        // Test 1 - No id in parms
        TFConsortiumMembershipComController cmcc = new TFConsortiumMembershipComController();
        System.assertEquals(null,cmcc.oAccount);
        
        // Test 2 - Invalid Id in parm
        ApexPages.CurrentPage().getParameters().put('id','xxx');
        cmcc = new TFConsortiumMembershipComController();
        System.assert(ApexPages.hasMessages());
        
        // Test 3 - Valid id in parm
        initData();
        ApexPages.CurrentPage().getParameters().put('id',acc.id);
        
        cmcc = new TFConsortiumMembershipComController();
        System.assertEquals(acc.name, cmcc.oAccount.name);
    }
    
    static TestMethod void testConsortiaList(){
        initData();
        ApexPages.CurrentPage().getParameters().put('id',acc.id);
        
        TFConsortiumMembershipComController cmcc = new TFConsortiumMembershipComController();
        
        // Test 1 - ensure the list is getting populated  correctly
        Integer numConsortia = [SELECT count() FROM Account WHERE type=:CONSORTIUM AND RecordType.Name = 'T&F - Consortium'];
        System.assertEquals(numConsortia, cmcc.consortiaList.size());
    }
    
    static TestMethod void testGetMemberList(){
        initData();
        ApexPages.CurrentPage().getParameters().put('id',acc.id);
        
        TFConsortiumMembershipComController cmcc = new TFConsortiumMembershipComController();
        
        // Test 1 - Empty member list
        System.assertEquals(0, cmcc.memberList.size());
        
        // Test 2 - 1 member
        Account parent = setupTestAccount('Test', UserInfo.getUserId(), CONSORTIUM);
        
        TandF_Account_to_Consortium__c a2c = new TandF_Account_to_Consortium__c(consortium_member__c=acc.id, consortiumParent__c=parent.id);
        insert a2c;
        
        cmcc = new TFConsortiumMembershipComController();
        System.assertEquals(1, cmcc.memberList.size());
    }
    
    static TestMethod void testAddMember(){
        initData();
        ApexPages.CurrentPage().getParameters().put('id',acc.id);
        
        // Test 1 - duplicate membership
        Account parent = setupTestAccount('Test', UserInfo.getUserId(), CONSORTIUM);
        
        TandF_Account_to_Consortium__c a2c = new TandF_Account_to_Consortium__c(consortium_member__c=acc.id, consortiumParent__c=parent.id);
        insert a2c;
        
        TFConsortiumMembershipComController cmcc = new TFConsortiumMembershipComController();
        
        cmcc.newConsortiaValue = a2c.id;
        
        cmcc.addMember();
        System.assert(ApexPages.getMessages().size() > 0);
        
        // Test 2 - valid membership
        ApexPages.getMessages().clear();
        Account parent2 = setupTestAccount('+ve Test', UserInfo.getUserId(), CONSORTIUM);
        cmcc.newConsortiaValue = parent2.id;
        
        cmcc.addMember();
        System.assert(ApexPages.hasMessages());
        
    }
    
    static testMethod void testDeleteMember(){
        initData(OTHER);
        ApexPages.CurrentPage().getParameters().put('id',acc.id);
        
        // Test 1 - valid deletion
        Account parent = setupTestAccount('Test', UserInfo.getUserId(), CONSORTIUM);
        
        TFConsortiumMembershipComController cmcc = new TFConsortiumMembershipComController();
        cmcc.newConsortiaValue = parent.id;
        cmcc.addMember();
        
        cmcc.editRowMemberId = [SELECT id FROM TandF_Account_to_Consortium__c WHERE consortiumParent__c = :parent.id].id;
        
        cmcc.deleteMember();
        
        System.assert(!ApexPages.hasMessages());
    }
    
    static testMethod void testSaveMember(){
        
    }

    /* Shared Methods */
    private static void initData(String t){
        //List<Account> consortia = [SELECT id FROM Account WHERE type=:CONSORTIUM];
        //delete consortia;
        
        setupTestAccount(t);
    }
        
    private static void initData(){     
        initData(CONSORTIUM);
    }
    
    private static void setupTestAccount(String t){
        acc = setupTestAccount('Test',UserInfo.getUserId(),t);
    }
    
    private static Account setupTestAccount(String accountName, ID userId, String t) {
        Account a = new Account(name=accountName,
            OwnerId=userId,
            BillingStreet='1234 Main Street',
            type=t);  
        insert a;
        return a;
    } 
    
}