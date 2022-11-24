@isTest
public with sharing class TFOAC_OpprotunityControllerTest {
    private static testMethod void testConstructorUnderRelatedList(){

        User u = zTEST_Shared.insertUser('T&F OAC Standard User', 'T&F OAC');
        TFOAC_Hierarchy_Code__c productHACode=null;

        List<GroupMember> gMemberLst = new List<GroupMember>();
        for(Group g : [SELECT Id FROM Group WHERE DeveloperName in ('T_F_HA_Science_Mathematics_Edit','T_F_HA_Allied_Public_Health_Edit')]){
            GroupMember psmMember = new GroupMember(UserOrGroupId = u.Id, GroupId = g.Id);
            gMemberLst.add(psmMember);
        }
        System.runAs(new User(Id = UserInfo.getUserId())){
          insert gMemberLst;
        }
        User u1 = zTEST_Shared.insertUser('T&F OAC Administrator', 'T&F OAC');

        system.runAs(u1){
            productHACode = TFOAC_UtilFactory.createHierarchyCode('Allied & Public Health', 'HA1', null);
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

             Test.startTest();

             Test.setCurrentPage(Page.TFOAC_OpportunityEdit);
             ApexPages.currentPage().getParameters().put('id',opp1.id);
             
             TFOAC_OpprotunityController pageController = new TFOAC_OpprotunityController(new ApexPages.StandardController(opp1));
             pageController.isDigitalContentUser = false;
             system.assertEquals(true,pageController.opportunityId !=null);
             
             Test.stopTest();
         }    

    }
}