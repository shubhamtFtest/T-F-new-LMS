/**
 *
 */
@IsTest
private class CASReAdoptControllerTest {
  static testMethod void testCASReAdoptController () {
    test.startTest();
    //User oUser = zTest_Shared.insertUser();
    //Insert Setting record.
    Setting__c setting = new Setting__c(name='Adoption Stages For ReAdopt');
    Insert setting;
    Setting_Item__c item = new Setting_Item__c(Text_1__c='Completed - Adopted',Setting__c=setting.Id);
    Insert item;
    
    //Insert Test account      
    Account oAccount = zTEST_Shared.insertAccount(UserInfo.getUserId() );
    contact cont=ztest_shared.noinsertContact(UserInfo.getUserId(), oAccount.Id);
    insert cont;
      
    Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
      
    Opportunity opp = zTest_Shared.noinsertOpportunity(oppRtId, UserInfo.getUserId() , oAccount.Id);
    opp.StageName ='Closed Won';
    opp.LeadSource= 'Advertisement';
    opp.CloseDate = System.today(); 
    opp.Course_Start_Date__c=Date.newInstance(2016, 12, 9);
    Insert opp;
      
    //Insert Contact Role  
    OpportunityContactRole OCR=ztest_shared.insertOpportunityContactRole(opp.id, cont.id) ;   
      
   
      
    Opportunity testOpp = [Select Id,Name,StageName,isClosed,isWon,Next_Renewal__c,Previous_Renewal__c from Opportunity where Id=:opp.Id];
    System.debug('opp : '+testOpp);
    System.debug('opp : '+testOpp.IsWon);
      
    //Insert Opplineitem
    OpportunityLineItem oli = zTest_Shared.noinsertOpportunityLineItem(opp.Id);
    oli.Adoption_Stage__c = 'Completed - Adopted';
    insert oli;
    
    opp.StageName ='Closed Won';
    update opp;
      
    CASReAdoptController oCASReAdoptCont = new CASReAdoptController(new ApexPages.StandardController(testOpp));
    oCASReAdoptCont.adoptionAllowed = true;
    oCASReAdoptCont.errorMessage = 'Test';
    oCASReAdoptCont.doAction();
      
    test.stopTest();
  }    
}