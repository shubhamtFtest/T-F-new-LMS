@IsTest
private class MassTransferOpportunityTeamTest {
  static testMethod void testMassTransferOpportunityTeam () {
    test.startTest();
    MassTransferOpportunityTeam oMtOppTeam = new MassTransferOpportunityTeam();
    User u = zTest_Shared.insertUser();
    system.debug('id ayi@@'+u.id);
    Opportunity testOpp = new Opportunity(Name = 'Test', Amount = 20000, StageName = 'Acceptance',Lead_Passed_From__c= u.id, Volume_Year__c = '2016', CloseDate = System.today());
    insert testOpp;
    system.debug('@@oppId'+testOpp.Lead_Passed_From__c+'@id@'+testOpp.id);
    Opportunity testOpp2 = new Opportunity(Name = 'Test', Amount = 20000, StageName = 'Acceptance',Lead_Passed_From__c= u.id, Volume_Year__c = '2016', CloseDate = System.today(), OwnerId= UserInfo.getUserId());
    OpportunityTeamMember oOppTeamMem = new OpportunityTeamMember(TeamMemberRole = 'Sales Support', OpportunityAccessLevel = 'Read', OpportunityId = testOpp.Id, UserId = UserInfo.getUserId());
    oMtOppTeam.oppSearch = testOpp;
    oMtOppTeam.teamSearch = oOppTeamMem;
    oMtOppTeam.strSelectedOppId= String.valueOf(testOpp.Id);
    oMtOppTeam.opportunity = testOpp2;
    oMtOppTeam.oOppTeamMem =oOppTeamMem;
    oMtOppTeam.save();
    
    OpportunityTeamMember oOppTeamMem2 = new OpportunityTeamMember(TeamMemberRole = 'Sales Support', OpportunityAccessLevel = 'Read', OpportunityId = testOpp.Id, UserId =UserInfo.getUserId());
    insert oOppTeamMem;
    
    List<OpportunityTeamMember>  lstOpp = oMtOppTeam.getOpportunities();
    oMtOppTeam.FirstPage();
    oMtOppTeam.previous();
    oMtOppTeam.next();
    oMtOppTeam.LastPage();
    oMtOppTeam.getRecordTypeNames();
   
    boolean isPrev = oMtOppTeam.getprev();
    boolean isNxt = oMtOppTeam.getnxt();
    test.stopTest();
  }    
}