@isTest
private with sharing class TFOAC_JournalControllerTest {

    private static Id getRoleId(String RoleName){
        return [select Id from userRole where name = :RoleName].Id; 
    }
    
    public static Id getProfileId(String profileName){
        return [select Id from profile where name = :profileName].Id; 
    }
    
    private static User insertUser(String profileName, String informaBusinessUnit, string RoleName){
        String adUsername = 'testinguser1' + system.now().second() + system.now().millisecond();
        String adOU = 'ukcorplan';  
        InsertADDetails(adUsername,adOU);
         User u = new User(alias='test', email='test@example.com', firstname='Testing',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', country='United States',
            timezonesidkey='America/Los_Angeles', username='test@example.com.informaplc' + system.now().second() + system.now().millisecond() + math.random(),
            Informa_Business_Unit__c='INFORMA USA INC',           
            profileid=getProfileId('System Administrator'), //CHG0038379
            Legal_Entity__c='INFORMA PLC (CH004)',
            Reporting_Unit__c='AE005',
            Admin_Options__c='Manage Licenses',
            Active_Directory_Username__c=adUsername,
            Active_Directory_OU__c=adOU);           
        u.UserRoleId = getRoleId(RoleName);
        u.ProfileId = getProfileId(profileName);       
        u.Informa_Business_Unit__c = informaBusinessUnit;         
        insert u;
        return u;
    }
    @future
    private static void InsertADDetails(String adUsername,String adOU){
         //For active directory validation rule
        String adstr= adOU + '\\' + adUsername;
        Active_Directory_Details__c acd = new Active_Directory_Details__c(Name='TestAd', sys_id__c='sys123', u_office_365__c = 'TestOfc' ,USER_Name__c=adstr,CurrencyIsoCode=UserInfo.getDefaultCurrency());
        insert acd;
    }
  private static testMethod void testConstructorUnderRelatedList(){

    	User u = insertUser('T&F OAC Standard User', 'T&F OAC','T&F OAC');
        TFOAC_Hierarchy_Code__c productHACode=null;

        List<GroupMember> gMemberLst = new List<GroupMember>();
        for(Group g : [SELECT Id FROM Group WHERE DeveloperName in ('T_F_HA_Science_Mathematics_Edit','T_F_HA_Allied_Public_Health_Edit')]){
            GroupMember psmMember = new GroupMember(UserOrGroupId = u.Id, GroupId = g.Id);
            gMemberLst.add(psmMember);
        }
        System.runAs(new User(Id = UserInfo.getUserId())){
          insert gMemberLst;
        }
        User u1 = insertUser('T&F OAC Administrator', 'T&F OAC','T&F OAC Manager');		
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

             Test.setCurrentPage(Page.TFOAC_JournalEditPage);
             ApexPages.currentPage().getParameters().put('lkid',opp1.id);
             TFOAC_Journal__c initialJournal = new TFOAC_Journal__c();
             
             TFOAC_JournalController pageController = new TFOAC_JournalController(new ApexPages.StandardController(initialJournal));
             pageController.oppCurrency = 'Test';
             pageController.resetFlag();
             pageController.setHostAreaVisibility();
             pageController.isDigitalContentUser = false;
             system.assertEquals(true,pageController.currentOpportunity !=null);
             PageReference pageRef = pageController.saveProduct();
             //check if journal was inserted
             system.assertEquals(true,pageRef == null);
             Test.stopTest();
         }    

  }
    
    private static testMethod void testJournalInsert(){

    User u = insertUser('T&F OAC Standard User', 'T&F OAC','T&F OAC');
        TFOAC_Hierarchy_Code__c productHACode=null;

        List<GroupMember> gMemberLst = new List<GroupMember>();
        for(Group g : [SELECT Id FROM Group WHERE DeveloperName in ('T_F_HA_Science_Mathematics_Edit','T_F_HA_Allied_Public_Health_Edit')]){
            GroupMember psmMember = new GroupMember(UserOrGroupId = u.Id, GroupId = g.Id);
            gMemberLst.add(psmMember);
        }
        System.runAs(new User(Id = UserInfo.getUserId())){
          insert gMemberLst;
        }
        User u1 = insertUser('T&F OAC Administrator', 'T&F OAC','T&F OAC Manager');

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

             Test.setCurrentPage(Page.TFOAC_JournalEditPage);
             ApexPages.currentPage().getParameters().put('lkid',opp1.id);
             TFOAC_Journal__c initialJournal = new TFOAC_Journal__c();
             TFOAC_JournalController pageController = new TFOAC_JournalController(new ApexPages.StandardController(initialJournal));
             system.assertEquals(true,pageController.currentOpportunity !=null);
             pageController.productToCreate.Name = 'TestJournal';
             pageController.productToCreate.Host_AreaCode__c=productHACode.id;
             PageReference pageRef = pageController.saveProduct();
             //check if journal was inserted
             system.assertEquals(true,pageRef != null);
             //check if validations for online issn were triggered
             pageController.productToCreate.OnlineISSN__c = 'adasd';
             PageReference pageRef1 = pageController.saveProduct();
             Boolean onlineIssnError = false;
             for(ApexPages.Message msg : ApexPages.getMessages()){
                 system.debug(LoggingLevel.ERROR,'validation online issn msg: '+msg.getSummary());
                 if(msg.getSummary().containsIgnoreCase('Online ISSN field wrong format')){
                     onlineIssnError = true;
                 }
             }
             //check if onlneIssnError validation was thrown
             //system.assertEquals(true, onlineIssnError);
                 
             pageController.productToCreate.OnlineISSN__c = '0000-0000';
             pageController.productToCreate.PrintISSN__c = 'aaa';
             PageReference pageRef2 = pageController.saveProduct();
             Boolean printIssnError = false;
             for(ApexPages.Message msg : ApexPages.getMessages()){
                 system.debug(LoggingLevel.ERROR,'validation print issn msg: '+msg.getSummary());
                 if(msg.getSummary().containsIgnoreCase('Print ISSN field wrong format')){
                     printIssnError = true;
                 }
             }
             //check if onlneIssnError validation was thrown
             //system.assertEquals(true, printIssnError);
             Test.stopTest();
         }    

  }

  private static testMethod void testHierarchyCodesSelection(){

    User u = insertUser('T&F OAC Standard User', 'T&F OAC','T&F OAC');
        TFOAC_Hierarchy_Code__c productHACode=null;

        List<GroupMember> gMemberLst = new List<GroupMember>();
        for(Group g : [SELECT Id FROM Group WHERE DeveloperName in ('T_F_HA_Science_Mathematics_Edit','T_F_HA_Allied_Public_Health_Edit')]){
            GroupMember psmMember = new GroupMember(UserOrGroupId = u.Id, GroupId = g.Id);
            gMemberLst.add(psmMember);
        }
        System.runAs(new User(Id = UserInfo.getUserId())){
          insert gMemberLst;
        }
        User u1 = insertUser('T&F OAC Administrator', 'T&F OAC','T&F OAC Manager');

        system.runAs(u1){
          TFOAC_UtilFactory.createAllHierachyCodes();
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

             Test.setCurrentPage(Page.TFOAC_JournalEditPage);

             ApexPages.currentPage().getParameters().put('lkid',opp1.id);
             TFOAC_Journal__c initialJournal = new TFOAC_Journal__c();
             TFOAC_JournalController pageController = new TFOAC_JournalController(new ApexPages.StandardController(initialJournal));
             pageController.productToCreate.DivisionCode__c =  Id.valueOf(pageController.getDivision().get(1).getValue());
             //system.assertEquals(true,pageController.productToCreate.DivisionCode__c != null);
             pageController.resetFieldsWhenDivisionChange();
             pageController.productToCreate.Host_AreaCode__c =  Id.valueOf(pageController.getHosArea().get(1).getValue());

             //system.assertEquals(true,pageController.productToCreate.Host_AreaCode__c != null);
             pageController.resetFieldsWhenHostAreaChange();
             pageController.productToCreate.SegmentCode__c =  Id.valueOf(pageController.getSegment().get(1).getValue());
             //system.assertEquals(true,pageController.productToCreate.SegmentCode__c != null);
             pageController.resetFieldsWhenSegmentChange();
             pageController.productToCreate.SectorCode__c =  Id.valueOf(pageController.getSector().get(1).getValue());
             //system.assertEquals(true,pageController.productToCreate.SectorCode__c != null);
             pageController.resetFieldsWhenSectorChange();
             pageController.productToCreate.Subject_AreaCode__c =  Id.valueOf(pageController.getSubjectArea().get(1).getValue());
             //system.assertEquals(true,pageController.productToCreate.Subject_AreaCode__c != null);
             pageController.productToCreate.Name ='Sample Journal';
             PageReference pageRef = pageController.saveProduct();

             //test page for existing journal
             ApexPages.currentPage().getParameters().put('id', pageController.productToCreate.id);
             TFOAC_JournalController pageController1 = new TFOAC_JournalController(new ApexPages.StandardController(pageController.productToCreate));
             
             
             //check validation for print issn and online issn
             pageController1.productToCreate.OnlineISSN__c = 'aaaa';
             pageController1.productToCreate.PrintISSN__c = 'aaaa';
             PageReference pageRef1 = pageController1.saveProduct();

             //system.assertEquals(true,ApexPages.hasMessages(ApexPages.Severity.ERROR));

             pageController1.productToCreate.OnlineISSN__c = 'aaaa-aaaa';
             pageController1.productToCreate.PrintISSN__c = 'aaaa-aaaa';
             PageReference pageRef2 = pageController1.saveProduct();

                             
             pageController1.checkCurrentAcqType();
             pageController1.sharingPage();
             Test.stopTest();
         }    

  }
}