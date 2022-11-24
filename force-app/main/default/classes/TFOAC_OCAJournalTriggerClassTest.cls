/*********************************************************
 * Modified by Hailey Niemand - 2017.01.26 - CHG0031794
*********************************************************/

@isTest
private with sharing class TFOAC_OCAJournalTriggerClassTest {
	
	private static testMethod void testCalculateOpportunityAmounts(){
		User u = zTEST_Shared.insertUser('T&F OAC Standard User', 'T&F OAC');
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
             try{
                 insert opp1;
             }catch(Exception ex){
                 system.debug(LoggingLevel.ERROR,'displaye error:'+ex);
                 wasAbleToCreate = false;
             }

             Test.startTest();
             /*
             CurrentAnnualTurnover__c','EstimatedGrossMarginYear1__c',
        															  'EstimatedYear1Turnover__c','Purchase_price__c',
        															  'SignOnFee__c','WeightedTurnoverYear1__c','OACOpportunity__c'
			 */
			 List<TFOAC_Journal__c> journalsToAdd = new List<TFOAC_Journal__c>();

			 for(Integer i=0;i<5;i++){
			 	TFOAC_Journal__c journal1 = new TFOAC_Journal__c();
	             journal1.Name = 'Journal '+i;
	             journal1.CurrentAnnualTurnover__c = 1;
	             journal1.EstimatedGrossMarginYear1__c = 1;
	             journal1.EstimatedYear1Turnover__c = 1;
	             journal1.Purchase_price__c = 1;
	             journal1.SignOnFee__c = 1;


	             journal1.CurrencyIsoCode = 'GBP';
	             journal1.Host_AreaCode__c = productHACode.id;
	             journal1.OACOpportunity__c = opp1.id;
	             journalsToAdd.add(journal1);	
			 }
             insert journalsToAdd; 
             
             List<TFOAC_Opportunity__c> oppLst = [Select id,CurrentAnnualTurnover__c,Year_1_turnover__c,Sign_on_fee__c,Purchase_price__c From TFOAC_Opportunity__c];
             /*
             system.assertEquals(1,oppLst.size());
             system.assertEquals(5,(Integer)oppLst.get(0).CurrentAnnualTurnover__c);
             system.assertEquals(5,(Integer)oppLst.get(0).Year_1_turnover__c);
             system.assertEquals(5,(Integer)oppLst.get(0).Sign_on_fee__c);
             system.assertEquals(5,(Integer)oppLst.get(0).Purchase_price__c);
			*/
             
             system.assertEquals(1,oppLst.size());
             system.assertEquals(4,(Integer)oppLst.get(0).CurrentAnnualTurnover__c);
             system.assertEquals(4,(Integer)oppLst.get(0).Year_1_turnover__c);
             system.assertEquals(4,(Integer)oppLst.get(0).Sign_on_fee__c);
             system.assertEquals(4,(Integer)oppLst.get(0).Purchase_price__c);
             
             //test journal ungling from joural
             journalsToAdd.get(0).OACOpportunity__c = null;
	         update journalsToAdd.get(0);

	         oppLst = [Select id,CurrentAnnualTurnover__c,Year_1_turnover__c,Sign_on_fee__c,Purchase_price__c From TFOAC_Opportunity__c];
			 /*
			 system.assertEquals(4,(Integer)oppLst.get(0).CurrentAnnualTurnover__c);
             system.assertEquals(4,(Integer)oppLst.get(0).Year_1_turnover__c);
             system.assertEquals(4,(Integer)oppLst.get(0).Sign_on_fee__c);
             system.assertEquals(4,(Integer)oppLst.get(0).Purchase_price__c);
			 */
             
			 system.assertEquals(3,(Integer)oppLst.get(0).CurrentAnnualTurnover__c);
             system.assertEquals(3,(Integer)oppLst.get(0).Year_1_turnover__c);
             system.assertEquals(3,(Integer)oppLst.get(0).Sign_on_fee__c);
             system.assertEquals(3,(Integer)oppLst.get(0).Purchase_price__c);
             
             //unaling all journlas from opportunity
             for(TFOAC_Journal__c journal :  journalsToAdd){
             	journal.OACOpportunity__c = null;
             }

             update journalsToAdd;

             oppLst = [Select id,CurrentAnnualTurnover__c,Year_1_turnover__c,Sign_on_fee__c,Purchase_price__c From TFOAC_Opportunity__c];
			 system.assertEquals(null,oppLst.get(0).CurrentAnnualTurnover__c);
             system.assertEquals(null,oppLst.get(0).Year_1_turnover__c);
             system.assertEquals(null,oppLst.get(0).Sign_on_fee__c);
             system.assertEquals(null,oppLst.get(0).Purchase_price__c);        

             //align all journlas back to opportunity
             for(TFOAC_Journal__c journal :  journalsToAdd){
             	journal.OACOpportunity__c = opp1.id;
             }

             update journalsToAdd;

             oppLst = [Select id,CurrentAnnualTurnover__c,Year_1_turnover__c,Sign_on_fee__c,Purchase_price__c From TFOAC_Opportunity__c];
			 /*
			 system.assertEquals(5,(Integer)oppLst.get(0).CurrentAnnualTurnover__c);
             system.assertEquals(5,(Integer)oppLst.get(0).Year_1_turnover__c);
             system.assertEquals(5,(Integer)oppLst.get(0).Sign_on_fee__c);
             system.assertEquals(5,(Integer)oppLst.get(0).Purchase_price__c); 
			 */
             
			 system.assertEquals(4,(Integer)oppLst.get(0).CurrentAnnualTurnover__c);
             system.assertEquals(4,(Integer)oppLst.get(0).Year_1_turnover__c);
             system.assertEquals(4,(Integer)oppLst.get(0).Sign_on_fee__c);
             system.assertEquals(4,(Integer)oppLst.get(0).Purchase_price__c); 
             
             //delete all journals
             delete journalsToAdd;
             oppLst = [Select id,CurrentAnnualTurnover__c,Year_1_turnover__c,Sign_on_fee__c,Purchase_price__c From TFOAC_Opportunity__c];
			 system.assertEquals(null,oppLst.get(0).CurrentAnnualTurnover__c);
             system.assertEquals(null,oppLst.get(0).Year_1_turnover__c);
             system.assertEquals(null,oppLst.get(0).Sign_on_fee__c);
             system.assertEquals(null,oppLst.get(0).Purchase_price__c);

             //check if journal was inserted
            
             Test.stopTest();
         }    
	}

    private static testMethod void testUpdateHostAreUnderJournal(){
        User u = zTEST_Shared.insertUser('T&F OAC Standard User', 'T&F OAC');
        TFOAC_Hierarchy_Code__c productHACode=null;
        TFOAC_Hierarchy_Code__c productHACode1=null;

        system.runAs(u){
            List<GroupMember> gMemberLst = new List<GroupMember>();
            for(Group g : [SELECT Id FROM Group WHERE DeveloperName in ('T_F_HA_Science_Mathematics_Edit','T_F_HA_Allied_Public_Health_Edit')]){
                GroupMember psmMember = new GroupMember(UserOrGroupId = u.Id, GroupId = g.Id);
                gMemberLst.add(psmMember);
            }
            insert gMemberLst;
    	}
    
        User u1 = zTEST_Shared.insertUser('T&F OAC Administrator', 'T&F OAC');

        system.runAs(u1){
            productHACode = TFOAC_UtilFactory.createHierarchyCode('Allied & Public Health', 'HA1', null);
            productHACode1 = TFOAC_UtilFactory.createHierarchyCode('Physical Sciences & Mathematics', 'HA1', null);
            
        }

         system.runAs(u){
            //T&F OAC
             TFOAC_Opportunity__c opp1 = new TFOAC_Opportunity__c();
             opp1.Host_Areas__c = 'Multiple Host Areas';
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
             
             List<TFOAC_Journal__c> journalsToAdd = new List<TFOAC_Journal__c>();

             for(Integer i=0;i<5;i++){
                TFOAC_Journal__c journal1 = new TFOAC_Journal__c();
                 journal1.Name = 'Journal '+i;
                 journal1.CurrentAnnualTurnover__c = 1;
                 journal1.EstimatedGrossMarginYear1__c = 1;
                 journal1.EstimatedYear1Turnover__c = 1;
                 journal1.Purchase_price__c = 1;
                 journal1.SignOnFee__c = 1;


                 journal1.CurrencyIsoCode = 'GBP';
                 journal1.Host_AreaCode__c = productHACode.id;
                 journal1.OACOpportunity__c = opp1.id;
                 journalsToAdd.add(journal1);   
             }
             insert journalsToAdd; 

             //create Relationships aligned to each journal
             List<TFOAC_Relationship__c> relationsToInsert = new List<TFOAC_Relationship__c>();
             for(TFOAC_Journal__c journalItem : journalsToAdd){
                TFOAC_Relationship__c relationItem = new TFOAC_Relationship__c();
                relationItem.ProductID__c = journalItem.id;
                relationsToInsert.add(relationItem);
             }

             insert relationsToInsert;
             Map<Id,TFOAC_Relationship__c> relationsAfterInsertMap = new Map<Id,TFOAC_Relationship__c>([Select Host_Area_Text__c From TFOAC_Relationship__c where id in: relationsToInsert]);
             //update hot area under journals 
             for(TFOAC_Journal__c journalItem : journalsToAdd){
                journalItem.Host_AreaCode__c = productHACode1.id;
             }

             //check if user is able to update Host Area under jornal once it's aligne to opportunity with Multiple Host Areas
             Boolean wasbAbleToChangeHostArea = true;
             try{
                update journalsToAdd;
             }catch(Exception ex){
                wasbAbleToChangeHostArea = false;
             }

             system.assertEquals(true,wasbAbleToChangeHostArea);

             Map<Id,TFOAC_Relationship__c> relationsAfterUpdateMap = new Map<Id,TFOAC_Relationship__c>([Select Host_Area_Text__c From TFOAC_Relationship__c where id in: relationsToInsert]);
             for(Id relId : relationsAfterInsertMap.keySet()){
                //check if host areas were change after Host Area update under journal
                system.assertEquals(true,relationsAfterUpdateMap.get(relId).Host_Area_Text__c != relationsAfterInsertMap.get(relId).Host_Area_Text__c,'Host Area text should change after aligned joural Host Area change');
             }
             
            
             Test.stopTest();
         }    
    }
}