@IsTest
private with sharing class TFOAC_AddExistingJournalControllerTest {

	//private static Id ACQRECORDTYPE = [SELECT Id FROM RecordType WHERE SobjectType = 'TFOAC_Opportunity__c' AND DeveloperName = 'TFOAC' LIMIT 1].get(0).ID;

	private static testMethod void testAddingExisitngProducts(){
        User u = zTEST_Shared.insertUser('T&F OAC Standard User', 'T&F OAC');
        TFOAC_Hierarchy_Code__c productHACode=null;
        List<GroupMember> gMemberLst = new List<GroupMember>();
        
        
        system.runAs(u){
            for(Group g : [SELECT Id FROM Group WHERE DeveloperName in ('T_F_HA_Science_Mathematics_Edit','T_F_HA_Allied_Public_Health_Edit')]){
            	GroupMember psmMember = new GroupMember(UserOrGroupId = u.Id, GroupId = g.Id);
            	gMemberLst.add(psmMember);
        	}
        	User u1 = zTEST_Shared.insertUser('T&F OAC Administrator', 'T&F OAC');
        	productHACode = TFOAC_UtilFactory.createHierarchyCode('Allied & Public Health', 'HA1', null);
            insert gMemberLst;
        }	
        		
		    
        

        
         
         system.runAs(u){
         	//T&F OAC
             TFOAC_Opportunity__c opp1 = new TFOAC_Opportunity__c();
             opp1.Host_Areas__c = 'Allied & Public Health';
             //opp1.TFACQ_Publishing_office__c = 'Asia Pacific & China';
             opp1.CurrencyIsoCode = 'GBP';
             opp1.RecordTypeId = Schema.SObjectType.TFOAC_Opportunity__c.getRecordTypeInfosByName().get('T&F OAC').getRecordTypeId();
             Boolean wasAbleToCreate = true;
             try{
                 insert opp1;
             }catch(Exception ex){
                 system.debug(LoggingLevel.ERROR,'displaye error:'+ex);
                 wasAbleToCreate = false;
             }
             
             system.assertEquals(true, wasAbleToCreate);
             TFOAC_Journal__c journal = new TFOAC_Journal__c();
             journal.Host_AreaCode__c = productHACode.id;
             journal.Name = 'Sample Product To Add';
             journal.CurrencyIsoCode = 'GBP';
             journal.RecordTypeId = Schema.SObjectType.TFOAC_Journal__c.getRecordTypeInfosByName().get('T&F OAC').getRecordTypeId();
             insert journal;
             
            
             
             TFOAC_Journal__c journal1 = new TFOAC_Journal__c();
             journal1.Host_AreaCode__c = productHACode.id;
             journal1.Name = 'Sample Product To Add 1';
             journal1.CurrencyIsoCode = 'GBP';
             journal1.RecordTypeId = Schema.SObjectType.TFOAC_Journal__c.getRecordTypeInfosByName().get('T&F OAC').getRecordTypeId();
             insert journal1;
             
             Test.startTest();
             Test.setCurrentPage(Page.TFOAC_AddExistingJournal);
             ApexPages.currentPage().getParameters().put('id',opp1.id);
             TFOAC_AddExistingJournalController pageController = new TFOAC_AddExistingJournalController(new ApexPages.StandardController(opp1));
             
             
             pageController.productNameToSearch = 'Sample Product To Add';
             pageController.searchProducts();
             system.assertEquals(true, !pageController.listOfProducts.isEmpty(), 'Product should be found');
             pageController.productSearchMap.get(pageController.listOfProducts.get(0).Id).selectedToAdd = true;
             pageController.productSearchMap.get(pageController.listOfProducts.get(1).Id).selectedToAdd = true;
             pageController.getListOfExistingProducts();
             pageController.next();
             pageController.previous();
             pageController.first();
             pageController.last();
             Boolean flag =  pageController.hasNext;
             flag = pageController.hasPrevious;
             pageController.getNumberOfRecords();
             pageController.getPageNumber();
             pageController.getTotalPages();
             pageController.addJournals();
             
             pageController = new TFOAC_AddExistingJournalController(new ApexPages.StandardController(opp1));
             system.assertEquals(2, [Select id FROM TFOAC_Journal__c WHERE OACOpportunity__c =: opp1.id].size());
             
             Test.stopTest();
             
         }
     }
	
}