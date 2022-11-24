@isTest
public with sharing class TFOAC_RelationshipTriggerClassTest {
    
	private static testMethod void setHostAreaTest(){
		User u = zTEST_Shared.insertUser('T&F OAC Standard User', 'T&F OAC');
        Id contactRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('T&F - OAC Contacts').getRecordTypeId();
        TFOAC_Hierarchy_Code__c productHACode=null;

        List<GroupMember> gMemberLst = new List<GroupMember>();
        
        system.runAs(u){
            for(Group g : [SELECT Id FROM Group WHERE DeveloperName in ('T_F_HA_Science_Mathematics_Edit','T_F_HA_Allied_Public_Health_Edit')]){
                GroupMember psmMember = new GroupMember(UserOrGroupId = u.Id, GroupId = g.Id);
                gMemberLst.add(psmMember);
            }
            
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
             //test success insert 
             Test.startTest();
             try{
                 insert opp1;
             }catch(Exception ex){
                 system.debug(LoggingLevel.ERROR,'displaye error:'+ex);
                 wasAbleToCreate = false;
             }

             system.assertEquals(true,wasAbleToCreate);
             Account defaultAccount = zTEST_Shared.noinsertAccount(u.id);
             defaultAccount.BillingState = 'UK';
             insert defaultAccount;
            
             TF_Acqusition_Setting__c tfSetting = new TF_Acqusition_Setting__c();
             tfSetting.DefaultAccount__c = defaultAccount.id;
             insert tfSetting;
            
             Contact testContact = new Contact();
             testContact.FirstName = 'Test';
             testContact.LastName = 'User Contact';
             testContact.RecordTypeId = contactRecordType;
             insert testContact;
             
             TFOAC_Relationship__c relationshipAlignedToOpportunity = new TFOAC_Relationship__c();
             
             relationshipAlignedToOpportunity.ContactId__c = testContact.id;
             relationshipAlignedToOpportunity.OpportunityID__c = opp1.id;
             insert relationshipAlignedToOpportunity;
             
             TFOAC_Relationship__c relationshipAfterInsert = [Select id,Host_Area_Text__c,OpportunityNDAStatus__c From TFOAC_Relationship__c where id=: relationshipAlignedToOpportunity.id Limit 1];
             //check if host area was set under relationship properly
             system.assertEquals(true, relationshipAfterInsert.Host_Area_Text__c != null);
             Test.stopTest();
         }
	}
}