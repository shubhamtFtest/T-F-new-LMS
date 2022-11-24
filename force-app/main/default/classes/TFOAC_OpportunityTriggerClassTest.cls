@isTest
private with sharing class TFOAC_OpportunityTriggerClassTest {
    
    private static testMethod void checkHostAreaForInsertAndUpdateTest(){
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
             //test success insert 
             Test.startTest();
             try{
                 insert opp1;
             }catch(Exception ex){
                 system.debug(LoggingLevel.ERROR,'displaye error:'+ex);
                 wasAbleToCreate = false;
             }

             system.assertEquals(true,wasAbleToCreate);
             
             //user should be able to change the host area to below one as he is assinged to 
             //T_F_HA_Science_Mathematics_Edit publick group
             opp1.Host_Areas__c = 'Physical Sciences & Mathematics';
             Boolean wasAbletoUpdate = true;
             TFOAC_Relationship__c oppRelation = new TFOAC_Relationship__c();
             oppRelation.OpportunityID__c = opp1.id;
             insert oppRelation;
             
             try{
                 update opp1;
             }catch(Exception ex){
                 wasAbletoUpdate = false;
             }
             
             system.assertEquals(true, wasAbletoUpdate);
             //check if host area under relationship record was also updated
             TFOAC_Relationship__c oppRelationAfterUpdate = [Select Host_Area_Text__c From TFOAC_Relationship__c where id=: oppRelation.id Limit 1];
             system.assertEquals(true, oppRelationAfterUpdate.Host_Area_Text__c != null);
             
             
             //test validation for insifficent Host Area
             TFOAC_Opportunity__c opp2 = new TFOAC_Opportunity__c();
             opp2.Host_Areas__c = 'Politics, Sport, Planning & Area Studies';
             //opp1.TFACQ_Publishing_office__c = 'Asia Pacific & China';
             opp2.CurrencyIsoCode = 'GBP';
             opp2.RecordTypeId = Schema.SObjectType.TFOAC_Opportunity__c.getRecordTypeInfosByName().get('T&F OAC').getRecordTypeId();
             String errorMsg = '';
             try{
                 insert opp2;
             }catch(Exception ex){
                 errorMsg = ex.getMessage();
                 wasAbleToCreate = false;
             }
             system.assertEquals(false,wasAbleToCreate,'User is not aligned to proper public group should not be able to create opportunity with Politics, Sport, Planning & Area Studies host ');
             system.assertEquals(true,errorMsg.containsIgnoreCase('access to opportunity with host areas'));
             
             
             //test validation for insifficent Host Area(digital Content)
             TFOAC_Opportunity__c opp3 = new TFOAC_Opportunity__c();
             opp3.Host_Areas__c = 'Digital Content';
             //opp1.TFACQ_Publishing_office__c = 'Asia Pacific & China';
             opp3.CurrencyIsoCode = 'GBP';
             opp3.RecordTypeId = Schema.SObjectType.TFOAC_Opportunity__c.getRecordTypeInfosByName().get('T&F OAC').getRecordTypeId();
            
             try{
                 insert opp3;
             }catch(Exception ex){
                 errorMsg = ex.getMessage();
                 wasAbleToCreate = false;
             }
             system.assertEquals(false,wasAbleToCreate,'User is not aligned to proper public group should not be able to create opportunity with Digital Content ');
             system.assertEquals(true,errorMsg.containsIgnoreCase('access to opportunity with host areas'));
             
                  //test validation for insifficent Host Area(Arts & Humanities)
             TFOAC_Opportunity__c opp4 = new TFOAC_Opportunity__c();
             opp4.Host_Areas__c = 'Arts & Humanities';
             //opp1.TFACQ_Publishing_office__c = 'Asia Pacific & China';
             opp4.CurrencyIsoCode = 'GBP';
             opp4.RecordTypeId = Schema.SObjectType.TFOAC_Opportunity__c.getRecordTypeInfosByName().get('T&F OAC').getRecordTypeId();
            
             try{
                 insert opp4;
             }catch(Exception ex){
                 errorMsg = ex.getMessage();
                 wasAbleToCreate = false;
             }
             system.assertEquals(false,wasAbleToCreate,'User is not aligned to proper public group should not be able to create opportunity with Arts & Humanities ');
             system.assertEquals(true,errorMsg.containsIgnoreCase('access to opportunity with host areas'));
             Test.stopTest();
         }
    }

    private static testMethod void checkPublishOfficeValidationTest(){
       User u = zTEST_Shared.insertUser('T&F OAC Standard User', 'T&F OAC');        
        TFOAC_Hierarchy_Code__c productHACode=null;             
        List<GroupMember> gMemberLst = new List<GroupMember>();
        
        system.runAs(u){
            for(Group g : [SELECT Id FROM Group WHERE DeveloperName in ('T_F_HA_Science_Mathematics_Edit','T_F_HA_Allied_Public_Health_Edit','T_F_HA_Australia_Edit')]){
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
                        
             opp1.Publishing_office__c = 'Australia';
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
             //test validation for insifficent Host Area
             TFOAC_Opportunity__c opp2 = new TFOAC_Opportunity__c();
             opp2.Host_Areas__c = 'Allied & Public Health';
             opp2.Publishing_office__c = 'UK';
             
             opp2.CurrencyIsoCode = 'GBP';
             opp2.RecordTypeId = Schema.SObjectType.TFOAC_Opportunity__c.getRecordTypeInfosByName().get('T&F OAC').getRecordTypeId();
             String errorMsg = '';
             try{
                 insert opp2;
             }catch(Exception ex){
                 errorMsg = ex.getMessage();
                 wasAbleToCreate = false;
             }
             system.assertEquals(true,wasAbleToCreate,'User is allowed to create OAC opportunities in this publishing office');
             system.assertEquals(false,errorMsg.containsIgnoreCase('access to opportunity with Publishing office'));
             Test.stopTest();
         }
    }

    private static testMethod void checkPublishOfficeProductValidationTest(){
        User u = zTEST_Shared.insertUser('T&F OAC Standard User', 'T&F OAC');
        User u1 = zTEST_Shared.insertUser('T&F OAC Administrator', 'T&F OAC');
        TFOAC_Hierarchy_Code__c productHACode=null;

        List<GroupMember> gMemberLst = new List<GroupMember>();
        
        system.runAs(u){
            for(Group g : [SELECT Id,DeveloperName FROM Group WHERE DeveloperName in ('T_F_HA_Science_Mathematics_Edit','T_F_HA_Allied_Public_Health_Edit','T_F_HA_Australia_Edit')]){
                GroupMember psmMember = new GroupMember(UserOrGroupId = u.Id, GroupId = g.Id);
                gMemberLst.add(psmMember);
                if(g.DeveloperName == 'T_F_HA_Allied_Public_Health_Edit'){
                    GroupMember psmMember1 = new GroupMember(UserOrGroupId = u1.Id, GroupId = g.Id);
                    gMemberLst.add(psmMember1);
                }
                
            }
            insert gMemberLst;
        }
        
        TFOAC_Opportunity__c opp2 = new TFOAC_Opportunity__c();
        system.runAs(u1){
            productHACode = TFOAC_UtilFactory.createHierarchyCode('Allied & Public Health', 'HA1', null);
            
             opp2.Host_Areas__c = 'Allied & Public Health';
             opp2.Publishing_office__c = 'UK';
             
             opp2.CurrencyIsoCode = 'GBP';
             opp2.RecordTypeId = Schema.SObjectType.TFOAC_Opportunity__c.getRecordTypeInfosByName().get('T&F OAC').getRecordTypeId();
             opp2.NDA_status__c = 'None';
             insert opp2;

             TFOAC_Opportunity__Share  oppShare = new TFOAC_Opportunity__Share();
             oppShare.ParentId = opp2.id;
             oppShare.UserOrGroupId = u.id;
             oppShare.AccessLevel ='Edit';
             //oppShare.RowCause = Schema.TFOAC_Opportunity__Share.RowCause.Manual;
             insert oppShare;


        }

         system.runAs(u){
            //T&F OAC
             TFOAC_Opportunity__c opp1 = new TFOAC_Opportunity__c();
             opp1.Host_Areas__c = 'Allied & Public Health';
             //opp1.TFACQ_Publishing_office__c = 'Asia Pacific & China';
             opp1.CurrencyIsoCode = 'GBP';
             opp1.RecordTypeId = Schema.SObjectType.TFOAC_Opportunity__c.getRecordTypeInfosByName().get('T&F OAC').getRecordTypeId();
             opp1.Publishing_office__c = 'Australia';
             
             insert opp1;
             
             Test.startTest();
             TFOAC_Journal__c journal1 = new TFOAC_Journal__c();
             journal1.Name = 'Journal 1';
             journal1.CurrentAnnualTurnover__c = 1;
             journal1.EstimatedGrossMarginYear1__c = 1;
             journal1.EstimatedYear1Turnover__c = 1;
             journal1.Purchase_price__c = 1;
             journal1.SignOnFee__c = 1;


             journal1.CurrencyIsoCode = 'GBP';
             journal1.Host_AreaCode__c = productHACode.id;
             journal1.OACOpportunity__c = opp1.id;

             Boolean wasAbleToCreate = true;
             try{
                insert journal1;
                    
             }catch(Exception ex){
                wasAbleToCreate = false;
             }
             
             system.assertEquals(true,wasAbleToCreate);

             TFOAC_Journal__c journal2 = new TFOAC_Journal__c();
             journal2.Name = 'Journal 2';
             journal2.CurrentAnnualTurnover__c = 1;
             journal2.EstimatedGrossMarginYear1__c = 1;
             journal2.EstimatedYear1Turnover__c = 1;
             journal2.Purchase_price__c = 1;
             journal2.SignOnFee__c = 1;


             journal2.CurrencyIsoCode = 'GBP';
             journal2.Host_AreaCode__c = productHACode.id;
             journal2.OACOpportunity__c = opp2.id;
             
             String errMsg = '';
             try{
                insert journal2;
             }catch(Exception ex){
                system.debug(LoggingLevel.ERROR,ex);
                wasAbleToCreate = false;
                errMsg = ex.getMessage();
             }

             system.assertEquals(false,wasAbleToCreate);
             system.debug(LoggingLevel.ERROR,errMsg);
             system.assertEquals(true,errMsg.containsIgnoreCase('access to opportunity with Publishing office'));


             Test.stopTest();
         }
    }
}