/***********************************
    zTEST_CLC_TF2 Test Class
    Created Date: 2017/02/01
***********************************/

@isTest
private class zTEST_CLC_TF2
{
    
   static testMethod void testActionButtons(){
        insertCustomSetting();
        
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
        createAccountContact(u);
        
        Lead l = getLead(u.Id, p.Id, 'Associate');
        Test.startTest();
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.campusName ='Test';
            //oCusLeadConvController.oppCloseDate =Date.Today();
            oCusLeadConvController.previous();
            oCusLeadConvController.cancel();
        
            oCusLeadConvController.wrapperIndex='1';
            oCusLeadConvController.cawList[1].checked = true;
            
            oCusLeadConvController.next();
            oCusLeadConvController.cawList[2].checked = true;
            
            oCusLeadConvController.next();
            oCusLeadConvController.getSortDirection();
            oCusLeadConvController.setSortDirection('ASC');
            oCusLeadConvController.searchByDomain();
            oCusLeadConvController.manageChecks1();
        Test.stopTest();
    }
    
    static testMethod void testActionButtonsIsLookup(){
        insertCustomSetting();
        
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
        createAccountContact(u);
        
        Lead l = getLead(u.Id, p.Id, 'Associate');
        Test.startTest();
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.previous();
            oCusLeadConvController.cancel();
        
            oCusLeadConvController.wrapperIndex='1';
            oCusLeadConvController.cawList[1].checked = true;
            oCusLeadConvController.cawList[1].isLookup = true;
            oCusLeadConvController.next();
            oCusLeadConvController.cawList[2].checked = true;
            oCusLeadConvController.cawList[2].isLookup = true;
            oCusLeadConvController.next();
            oCusLeadConvController.resetLevel2();
        Test.stopTest();
    }
   
    /*static testMethod void testGetAllCampusDepartmenttestGetAllCampusDepartment(){
        insertCustomSetting();
        
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
        createAccountContact(u);
        
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
        createCampusDept(a);
        Lead l = getLead(u.Id, p.Id, 'Associate');
        Test.startTest();
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.lookup.Account__c = a.id;
            oCusLeadConvController.wrapperIndex='1';
            oCusLeadConvController.getAllCampusDropDown();
            oCusLeadConvController.getAllDepartmentDropDown();
        Test.stopTest();
    }*/
    
    
    static testMethod void testGetCampusDepartment(){
        insertCustomSetting();
        
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
        createAccountContact(u);
        
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
        createCampusDept(a);
        Lead l = getLead(u.Id, p.Id, 'Associate');
        Test.startTest();
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.lookup.Account__c = a.id;
            oCusLeadConvController.wrapperIndex='1';
            oCusLeadConvController.getCampusDropDown();
            oCusLeadConvController.getDepartmentDropDown();
            oCusLeadConvController.campusID ='-None-';
            oCusLeadConvController.getDepartmentDropDown();
            oCusLeadConvController.getAllCampusDropDown();
            oCusLeadConvController.init();
         //   oCusLeadConvController.PreviousContactAccount();
            oCusLeadConvController.getPageNumberContactAccount();
           // oCusLeadConvController.showAccessPeriod();
           // oCusLeadConvController.checkContainOppRecTypeID();
        //    oCusLeadConvController.performLeadConvert();
            oCusLeadConvController.PreviousOpp();
           // oCusLeadConvController.campusID='NewCampus';
        Test.stopTest();
    }
    
    static testMethod void testGetCampusDepartmentNew(){
        
        insertCustomSetting();
        
        User u = zTEST_Shared.insertUser();
         system.debug('User'+u);
        Product2 p = getProduct();
        createAccountContact(u);
        system.debug('p'+p);
        
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
        
        Campus__c campus3 = new Campus__c();
        campus3.name ='NewCampus';
        campus3.Account__c = a.id;
        insert campus3;
        
        Department__c Dept3 = new Department__c();
        Dept3.Name ='NewDepartment';
        Dept3.Account__c = a.id;
        insert Dept3;
        system.debug('Dept3'+Dept3);
        
        Lead l = getLead(u.Id, p.Id, 'Associate');
        Test.startTest();
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            system.debug('oCusLeadConvController'+oCusLeadConvController);
            oCusLeadConvController.lookup.Account__c = a.id;
            oCusLeadConvController.wrapperIndex='1';
         //   oCusLeadConvController.getCampusDropDown();
         //   oCusLeadConvController.getDepartmentDropDown();
            oCusLeadConvController.campusID ='NewCampus';
          //  oCusLeadConvController.cawList[0].departmentId ='NewDepartment';
            //oCusLeadConvController.owList[0].isNewCreation =false;
            //oCusLeadConvController.renderedSection1=true;
             system.debug('oCusLeadConvController'+oCusLeadConvController);
           
        Test.stopTest();
    }
    
     static testMethod void testcreateCampusDepartment(){
        insertCustomSetting();
        
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
        createAccountContact(u);
        
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
        createCampusDept(a);
        Lead l = getLead(u.Id, p.Id, 'Associate');
        Test.startTest();
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.cawList[0].campusId ='NewCampus';
            oCusLeadConvController.cawList[0].departmentId ='NewDepartment';
            oCusLeadConvController.indexCampusDepartmentUpdate=1;
            oCusLeadConvController.convertedAccount =a;
            oCusLeadConvController.campusJsonString ='{"Account__c":"'+a.id+'","Name":"Test","Phone__c":"9999999999","Mailing_Street__c":"Test de","Mailing_City__c":"delhi","Mailing_Country_List__c":"United States","Mailing_State_Province_List__c":"FL","Mailing_ZIP_Postal_Code__c":"90076"}';
            
            oCusLeadConvController.createCampusDepartment();
             oCusLeadConvController.campusJsonString ='';
            oCusLeadConvController.departmentJsonString ='{"Account__c":"'+a.id+'","Name":"Test Rest","Phone__c":"9999999999","Mailing_Street__c":"Test de","Mailing_City__c":"Delhi","Mailing_Country_List__c":"United States","Mailing_State_Province_List__c":"GA","Mailing_ZIP_Postal_Code__c":"90076"}';
            oCusLeadConvController.createCampusDepartment();
         CustomLeadConversionTF2Controller oCusLeadConvController2 = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
         oCusLeadConvController2.campusID='campus';
         oCusLeadConvController2.cawList[0].campusId ='Campus';
            oCusLeadConvController2.cawList[0].departmentId ='Department';
            oCusLeadConvController2.indexCampusDepartmentUpdate=1;
            oCusLeadConvController2.convertedAccount =a;
            oCusLeadConvController2.campusJsonString ='{"Account__c":"'+a.id+'","Name":"Test2","Phone__c":"9999999999","Mailing_Street__c":"Test de","Mailing_City__c":"delhi","Mailing_Country_List__c":"United States","Mailing_State_Province_List__c":"FL","Mailing_ZIP_Postal_Code__c":"90076"}';
            
            oCusLeadConvController2.createCampusDepartment();
             oCusLeadConvController2.campusJsonString ='';
            oCusLeadConvController2.departmentJsonString ='{"Account__c":"'+a.id+'","Name":"Test Rest2","Phone__c":"9999999999","Mailing_Street__c":"Test de","Mailing_City__c":"Delhi","Mailing_Country_List__c":"United States","Mailing_State_Province_List__c":"GA","Mailing_ZIP_Postal_Code__c":"90076"}';
            oCusLeadConvController2.createCampusDepartment();
         
        System.debug('oCusLeadConvController1'+oCusLeadConvController);
            
        Test.stopTest();
    }
    
    static testMethod void testFinishRSectionIFCase(){
    
        insertCustomSetting();
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
        createAccountContact(u);

        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
      
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id);
        
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        CAS_Course_Cat1__c ccc1 = new CAS_Course_Cat1__c(Name='cat1');
        insert ccc1;
         
        Lead l = getLead(u.Id, p.Id, 'Associate');
        Test.startTest();

            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.selectedAccountForOpportunity=ReinggAccount.id;
            oCusLeadConvController.lookup.Account__c = a.id;
             oCusLeadConvController.wrapperIndex='1';
             oCusLeadConvController.isContactPage = false;
            oCusLeadConvController.cawList[1].checked = true;
            oCusLeadConvController.cawList[1].isLookup = true;
            oCusLeadConvController.next();
            oCusLeadConvController.cawList[2].checked = true;
            oCusLeadConvController.cawList[2].isLookup = true;
            oCusLeadConvController.next();

            oCusLeadConvController.owList[0].checked =true;
            oCusLeadConvController.owList[0].isNewCreation =false;
            oCusLeadConvController.renderedSection1=false;
            oCusLeadConvController.renderedSection2=true;
            oCusLeadConvController.selectedLevel1 = '--None--';
            oCusLeadConvController.oppObj.Name= null;
            oCusLeadConvController.oppObj.OwnerId = null;
            oCusLeadConvController.oppObj.CurrencyIsoCode = null;
            Update opp;
            oCusLeadConvController.finish();
                       
       Test.stopTest();
        
    }
    
   static testMethod void testFinish(){
    
        insertCustomSetting();
         //System.debug('000000000000');
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
        createAccountContact(u);
        //System.debug('111111111111111111');
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
         //System.debug('2222222222222222');
        
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
      
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id);
        //System.debug('33333333333333333');
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        
         //System.debug('3333333333333b');
        Lead l = getLead(u.Id, p.Id, 'Associate');
        Test.startTest();
         //System.debug('4444444444444444');
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.selectedAccountForOpportunity=ReinggAccount.id;
            oCusLeadConvController.lookup.Account__c = a.id;
             oCusLeadConvController.wrapperIndex='1';
             oCusLeadConvController.isContactPage = false;
            oCusLeadConvController.cawList[1].checked = true;
            oCusLeadConvController.cawList[1].isLookup = true;
            oCusLeadConvController.next();
            oCusLeadConvController.cawList[2].checked = true;
            oCusLeadConvController.cawList[2].isLookup = true;
            oCusLeadConvController.next();

            
            
             //System.debug('55555555555555555'+oCusLeadConvController.owList);
            oCusLeadConvController.owList[0].checked =true;
            oCusLeadConvController.owList[0].isNewCreation =true;
            
            oCusLeadConvController.renderedSection1=true;
            oCusLeadConvController.finish();
            
            Update opp;
       Test.stopTest();
        
    }
    
    static testMethod void testFinishRSection2(){
    
        insertCustomSetting();
         //System.debug('000000000000');
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
        createAccountContact(u);
        //System.debug('111111111111111111');
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
         //System.debug('2222222222222222');
      
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id);
        //System.debug('33333333333333333');
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        
         //System.debug('3333333333333b');
        Lead l = getLead(u.Id, p.Id, 'Associate');
        Test.startTest();
         //System.debug('4444444444444444');
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.selectedAccountForOpportunity=ReinggAccount.id;
            oCusLeadConvController.lookup.Account__c = a.id;
             oCusLeadConvController.wrapperIndex='1';
             oCusLeadConvController.isContactPage = false;
            oCusLeadConvController.cawList[1].checked = true;
            oCusLeadConvController.cawList[1].isLookup = true;
            oCusLeadConvController.next();
            oCusLeadConvController.cawList[2].checked = true;
            oCusLeadConvController.cawList[2].isLookup = true;
            oCusLeadConvController.next();

            
            
             //System.debug('55555555555555555'+oCusLeadConvController.owList);
            oCusLeadConvController.owList[0].checked =true;
            oCusLeadConvController.owList[0].isNewCreation =true;
            oCusLeadConvController.renderedSection2=true;
            oCusLeadConvController.finish();
            Update opp;
       Test.stopTest();
        
    }
    
    static testMethod void testFinishRSection3(){
    
        insertCustomSetting();
         //System.debug('000000000000');
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
        createAccountContact(u);
        //System.debug('111111111111111111');
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
         //System.debug('2222222222222222');
        
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id);
        //System.debug('33333333333333333');
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        
         //System.debug('3333333333333b');
        Lead l = getLead(u.Id, p.Id, 'Associate');
        Test.startTest();
         //System.debug('4444444444444444');
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.selectedAccountForOpportunity=ReinggAccount.id;
            oCusLeadConvController.lookup.Account__c = a.id;
             oCusLeadConvController.wrapperIndex='1';
             oCusLeadConvController.isContactPage = false;
            oCusLeadConvController.cawList[1].checked = true;
            oCusLeadConvController.cawList[1].isLookup = true;
            oCusLeadConvController.next();
            oCusLeadConvController.cawList[2].checked = true;
            oCusLeadConvController.cawList[2].isLookup = true;
            oCusLeadConvController.next();

            
            
             //System.debug('55555555555555555'+oCusLeadConvController.owList);
            oCusLeadConvController.owList[0].checked =true;
            oCusLeadConvController.owList[0].isNewCreation =false;
            oCusLeadConvController.renderedSection1=true;
            oCusLeadConvController.finish();
            Update opp;
       Test.stopTest();
        
    }
    
    
    
    
    static testMethod void testFinishRSection4(){
    
        insertCustomSetting();
         //System.debug('000000000000');
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
        p.productCode ='12345678901234';
        update p;
        createAccountContact(u);
        //System.debug('111111111111111111');
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
         //System.debug('2222222222222222');
        
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id);
        //System.debug('33333333333333333');
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        
         //System.debug('3333333333333b');
        Lead l = getLead(u.Id, p.Id, 'Associate');
        Test.startTest();
         //System.debug('Product=='+p);
         //System.debug('Lead=='+l);
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.selectedAccountForOpportunity=ReinggAccount.id;
            oCusLeadConvController.lookup.Account__c = a.id;
             oCusLeadConvController.wrapperIndex='1';
             oCusLeadConvController.isContactPage = false;
            oCusLeadConvController.cawList[1].checked = true;
            oCusLeadConvController.cawList[1].isLookup = true;
            oCusLeadConvController.next();
            oCusLeadConvController.cawList[2].checked = true;
            oCusLeadConvController.cawList[2].isLookup = true;
            oCusLeadConvController.next();

            
            
             //System.debug('55555555555555555'+oCusLeadConvController.owList);
            oCusLeadConvController.owList[0].checked =true;
            oCusLeadConvController.owList[0].isNewCreation =false;
            oCusLeadConvController.renderedSection2=true;
            oCusLeadConvController.finish();
            Update opp;
       Test.stopTest();
        
    }
    
    
    
    static testMethod void testFinishRSectionFalse(){
    
        insertCustomSetting();
         //System.debug('000000000000');
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
        createAccountContact(u);
        //System.debug('111111111111111111');
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
         //System.debug('2222222222222222');
      
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id);
        //System.debug('33333333333333333');
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        
         //System.debug('3333333333333b');
        Lead l = getLead(u.Id, p.Id, 'Associate');
        Test.startTest();
         //System.debug('4444444444444444');
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.selectedAccountForOpportunity=ReinggAccount.id;
            oCusLeadConvController.lookup.Account__c = a.id;
             oCusLeadConvController.wrapperIndex='1';
             oCusLeadConvController.isContactPage = false;
            oCusLeadConvController.cawList[1].checked = true;
            oCusLeadConvController.cawList[1].isLookup = true;
            oCusLeadConvController.next();
            oCusLeadConvController.cawList[2].checked = true;
            oCusLeadConvController.cawList[2].isLookup = true;
            oCusLeadConvController.next();

            
            
             //System.debug('55555555555555555'+oCusLeadConvController.owList);
            oCusLeadConvController.owList[0].checked =true;
            oCusLeadConvController.owList[0].isNewCreation =true;
            oCusLeadConvController.renderedSection2=false;
            oCusLeadConvController.renderedSection1=false;
            oCusLeadConvController.finish();
            Update opp;
       Test.stopTest();
        
    }
    static testMethod void testFinishRSectionFalse5(){
    
        insertCustomSetting();
         //System.debug('000000000000');
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
        createAccountContact(u);
        //System.debug('111111111111111111');
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
         //System.debug('2222222222222222');
      
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id);
        //System.debug('33333333333333333');
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        
         //System.debug('3333333333333b');
        Lead l = getLead(u.Id, p.Id, 'Associate');
        Test.startTest();
         //System.debug('4444444444444444');
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.selectedAccountForOpportunity=ReinggAccount.id;
            oCusLeadConvController.lookup.Account__c = a.id;
             oCusLeadConvController.wrapperIndex='1';
             oCusLeadConvController.isContactPage = false;
            oCusLeadConvController.cawList[1].checked = true;
            oCusLeadConvController.cawList[1].isLookup = true;
            oCusLeadConvController.next();
            oCusLeadConvController.cawList[2].checked = true;
            oCusLeadConvController.cawList[2].isLookup = true;
            oCusLeadConvController.cawList[0].accountObj= a;
            oCusLeadConvController.cawList[0].contactObj=c;
            oCusLeadConvController.cawList[0].isContact =true;
            oCusLeadConvController.firstPageSelectedRecord = oCusLeadConvController.cawList[0];
            oCusLeadConvController.next();

            
            
             //System.debug('55555555555555555'+oCusLeadConvController.owList);
            oCusLeadConvController.owList[0].checked =true;
            oCusLeadConvController.owList[0].isNewCreation =false;
            oCusLeadConvController.renderedSection2=false;
            oCusLeadConvController.renderedSection1=false;
            oCusLeadConvController.finish();
            Update opp;
       Test.stopTest();
        
    }
    
    static testMethod void testFinishRSectionFalse6(){
    
        insertCustomSetting();
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
        createAccountContact(u);
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
      
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id);
        //System.debug('33333333333333333');
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        Lead l = getLead(u.Id, p.Id, 'Associate');
        Test.startTest();
         
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.selectedAccountForOpportunity=ReinggAccount.id;
            oCusLeadConvController.lookup.Account__c = a.id;
             oCusLeadConvController.wrapperIndex='1';
             oCusLeadConvController.isContactPage = false;
            oCusLeadConvController.cawList[1].checked = true;
            oCusLeadConvController.cawList[1].isLookup = true;
            oCusLeadConvController.next();
            oCusLeadConvController.cawList[2].checked = true;
            oCusLeadConvController.cawList[2].isLookup = true;
            oCusLeadConvController.cawList[0].accountObj= a;
            oCusLeadConvController.cawList[0].contactObj=c;
            oCusLeadConvController.cawList[0].isContact =true;
            oCusLeadConvController.firstPageSelectedRecord = oCusLeadConvController.cawList[0];
            oCusLeadConvController.next();

            oCusLeadConvController.owList[0].checked =true;
            oCusLeadConvController.owList[0].isNewCreation =false;
            oCusLeadConvController.renderedSection2=false;
            oCusLeadConvController.renderedSection1=false;
            oCusLeadConvController.ocrObj.Role='Lecturer';
            oCusLeadConvController.finish();
            Update opp;
       Test.stopTest();
    }
    
    static testMethod void testFinishRSectionFalse7(){
    
        insertCustomSetting();
         //System.debug('000000000000');
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
         p.productCode ='12345678901234';
        update p;
        createAccountContact(u);
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
        CAS_Course_Cat1__c ccc1 = new CAS_Course_Cat1__c(Name='cat1');
        insert ccc1;
      
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id);
        //System.debug('33333333333333333');
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        Lead l = new Lead(ownerId=u.Id, company='tCom' ,lastName ='tlastName');
        insert l;
        Test.startTest();
         //System.debug('4444444444444444');
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.selectedAccountForOpportunity=ReinggAccount.id;
            oCusLeadConvController.lookup.Account__c = a.id;
             oCusLeadConvController.wrapperIndex='1';
             oCusLeadConvController.isContactPage = false;
            oCusLeadConvController.cawList[0].checked = true;
            oCusLeadConvController.cawList[0].isLookup = true;
            oCusLeadConvController.cawList[0].accountObj= a;
            oCusLeadConvController.cawList[0].contactObj=c;
            oCusLeadConvController.cawList[0].isContact =true;
            oCusLeadConvController.firstPageSelectedRecord = oCusLeadConvController.cawList[0];
            oCusLeadConvController.next();
          

            
            
             //System.debug('55555555555555555'+oCusLeadConvController.owList);
            oCusLeadConvController.owList[0].checked =true;
            oCusLeadConvController.owList[0].isNewCreation =true;
            oCusLeadConvController.renderedSection1 = true;
            //oCusLeadConvController.renderedSection2 = false;
            //oCusLeadConvController.oppObj.CurrencyIsoCode = null;
           // oCusLeadConvController.ocrObj.Role = 'Lecterer';
           oCusLeadConvController.selectedLevel1 = ccc1.id;
           oCusLeadConvController.oppObj.CurrencyIsoCode = 'USD';
           oCusLeadConvController.oppObj.OwnerId = u.Id;
           oCusLeadConvController.oppProductOBj.IC_Quantity__c = 5;
           oCusLeadConvController.firstPageSelectedRecord.accountObj = a;
           //oCusLeadConvController.oppObj.CurrencyIsoCode = null;
           //oCusLeadConvController.firstPageSelectedRecord.accountObj = ;
            if(oCusLeadConvController.product != null){
                oCusLeadConvController.product.Name ='Test Product';
                oCusLeadConvController.product.productCode ='12345678901234';
                upsert oCusLeadConvController.product;
            }else{
                
                oCusLeadConvController.product = p;
            }
            oCusLeadConvController.finish();
            Update opp;
       Test.stopTest();
        
        
    } 

    static testMethod void testFinishRSectionFalse7_1(){
    
        insertCustomSetting();
         //System.debug('000000000000');
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
         p.productCode ='12345678901234';
        update p;
        createAccountContact(u);
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
        CAS_Course_Cat1__c ccc1 = new CAS_Course_Cat1__c(Name='cat1');
        insert ccc1;
      
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id);
        //System.debug('33333333333333333');
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        Lead l = new Lead(ownerId=u.Id, company='tCom' ,lastName ='tlastName');
        insert l;
        Test.startTest();
         //System.debug('4444444444444444');
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.selectedAccountForOpportunity=ReinggAccount.id;
            oCusLeadConvController.lookup.Account__c = a.id;
             oCusLeadConvController.wrapperIndex='1';
            
             oCusLeadConvController.isContactPage = false;
            oCusLeadConvController.cawList[0].checked = true;
            oCusLeadConvController.cawList[0].isLookup = true;
            oCusLeadConvController.cawList[0].accountObj= a;
            oCusLeadConvController.cawList[0].contactObj=c;
            oCusLeadConvController.cawList[0].isContact =true;
            oCusLeadConvController.firstPageSelectedRecord = oCusLeadConvController.cawList[0];
            oCusLeadConvController.next();
          

            
            
             //System.debug('55555555555555555'+oCusLeadConvController.owList);
            oCusLeadConvController.owList[0].checked =true;
            oCusLeadConvController.owList[0].isNewCreation =true;
            //oCusLeadConvController.renderedSection1 = true;
            oCusLeadConvController.renderedSection2 = false;
            //oCusLeadConvController.oppObj.CurrencyIsoCode = null;
           // oCusLeadConvController.ocrObj.Role = 'Lecterer';
           oCusLeadConvController.selectedLevel1 = ccc1.id;
           oCusLeadConvController.oppObj.CurrencyIsoCode = 'Test';
           oCusLeadConvController.oppObj.OwnerId = u.Id;
           oCusLeadConvController.oppProductOBj.IC_Quantity__c = 5;
           oCusLeadConvController.firstPageSelectedRecord.accountObj = a;
           //oCusLeadConvController.oppObj.CurrencyIsoCode = null;
           //oCusLeadConvController.firstPageSelectedRecord.accountObj = ;
            if(oCusLeadConvController.product != null){
                oCusLeadConvController.product.Name ='Test Product';
                oCusLeadConvController.product.productCode ='12345678901234';
                upsert oCusLeadConvController.product;
            }else{
                
                oCusLeadConvController.product = p;
            }
             oCusLeadConvController.OpporIndexPoint='1';
            oCusLeadConvController.finish();
            oCusLeadConvController.parseError('TestException: testing error, Error');
        Update opp;
       Test.stopTest();
        
        
    }
    
    static testMethod void testFinishRSectionFalse7_2(){
    
        insertCustomSetting();
         //System.debug('000000000000');
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
         p.productCode ='12345678901234';
        update p;
        createAccountContact(u);
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
        CAS_Course_Cat1__c ccc1 = new CAS_Course_Cat1__c(Name='cat1');
        insert ccc1;
      
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id);
        //System.debug('33333333333333333');
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        Lead l = new Lead(ownerId=u.Id, company='tCom' ,lastName ='tlastName');
        insert l;
        Test.startTest();
         //System.debug('4444444444444444');
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.selectedAccountForOpportunity=ReinggAccount.id;
            oCusLeadConvController.lookup.Account__c = a.id;
             oCusLeadConvController.wrapperIndex='1';
            
             oCusLeadConvController.isContactPage = false;
            oCusLeadConvController.cawList[0].checked = true;
            oCusLeadConvController.cawList[0].isLookup = true;
            oCusLeadConvController.cawList[0].accountObj= a;
            oCusLeadConvController.cawList[0].contactObj=c;
            oCusLeadConvController.cawList[0].isContact =true;
            oCusLeadConvController.firstPageSelectedRecord = oCusLeadConvController.cawList[0];
            oCusLeadConvController.next();
          

            
            
             //System.debug('55555555555555555'+oCusLeadConvController.owList);
            oCusLeadConvController.owList[0].checked =true;
            oCusLeadConvController.owList[0].isNewCreation =true;
            //oCusLeadConvController.renderedSection1 = true;
            oCusLeadConvController.renderedSection2 = true;
            //oCusLeadConvController.oppObj.CurrencyIsoCode = null;
           // oCusLeadConvController.ocrObj.Role = 'Lecterer';
           oCusLeadConvController.selectedLevel1 = ccc1.id;
           oCusLeadConvController.oppObj.CurrencyIsoCode = 'USD';
           oCusLeadConvController.oppObj.OwnerId = u.Id;
           oCusLeadConvController.oppProductOBj.IC_Quantity__c = 5;
           oCusLeadConvController.firstPageSelectedRecord.accountObj = a;
           //oCusLeadConvController.oppObj.CurrencyIsoCode = null;
           //oCusLeadConvController.firstPageSelectedRecord.accountObj = ;
            if(oCusLeadConvController.product != null){
                oCusLeadConvController.product.Name ='Test Product';
                oCusLeadConvController.product.productCode ='12345678901234';
                upsert oCusLeadConvController.product;
            }else{
                
                oCusLeadConvController.product = p;
            }
             oCusLeadConvController.OpporIndexPoint='1';
            oCusLeadConvController.finish();
            Update opp;
       Test.stopTest();
        
        
    }
    
    static testMethod void testFinishRSectionFalse7_3(){
    
        insertCustomSetting();
         //System.debug('000000000000');
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
         p.productCode ='12345678901234';
        update p;
        createAccountContact(u);
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
        CAS_Course_Cat1__c ccc1 = new CAS_Course_Cat1__c(Name='cat1');
        insert ccc1;
      
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id);
        //System.debug('33333333333333333');
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        Lead l = new Lead(ownerId=u.Id, company='tCom' ,lastName ='tlastName');
        insert l;
        Test.startTest();
         //System.debug('4444444444444444');
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.selectedAccountForOpportunity=ReinggAccount.id;
            oCusLeadConvController.lookup.Account__c = a.id;
             oCusLeadConvController.wrapperIndex='1';
            
             oCusLeadConvController.isContactPage = false;
            oCusLeadConvController.cawList[0].checked = true;
            oCusLeadConvController.cawList[0].isLookup = true;
            oCusLeadConvController.cawList[0].accountObj= a;
            oCusLeadConvController.cawList[0].contactObj=c;
            oCusLeadConvController.cawList[0].isContact =true;
            oCusLeadConvController.firstPageSelectedRecord = oCusLeadConvController.cawList[0];
            oCusLeadConvController.next();
          

            
            
             //System.debug('55555555555555555'+oCusLeadConvController.owList);
            
            //oCusLeadConvController.renderedSection1 = true;
            oCusLeadConvController.renderedSection2 = true;
            //oCusLeadConvController.oppObj.CurrencyIsoCode = null;
           // oCusLeadConvController.ocrObj.Role = 'Lecterer';
           oCusLeadConvController.selectedLevel1 = ccc1.id;
           oCusLeadConvController.oppObj.CurrencyIsoCode = 'USD';
           oCusLeadConvController.oppObj.OwnerId = u.Id;
           oCusLeadConvController.oppProductOBj.IC_Quantity__c = 5;
           oCusLeadConvController.firstPageSelectedRecord.accountObj = a;
           //oCusLeadConvController.oppObj.CurrencyIsoCode = null;
           //oCusLeadConvController.firstPageSelectedRecord.accountObj = ;
            if(oCusLeadConvController.product != null){
                oCusLeadConvController.product.Name ='Test Product';
                oCusLeadConvController.product.productCode ='12345678901234';
                upsert oCusLeadConvController.product;
            }else{
                
                oCusLeadConvController.product = p;
            }
             oCusLeadConvController.OpporIndexPoint='0';
             oCusLeadConvController.owList[0].checked =true;
            oCusLeadConvController.owList[0].isNewCreation =false;
            oCusLeadConvController.finish();
            Update opp;
       Test.stopTest();
        
        
    }
    
    static testMethod void testFinishRSectionFalse7_4(){
    
        insertCustomSetting();
         //System.debug('000000000000');
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
         p.productCode ='12345678901234';
        update p;
        createAccountContact(u);
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
        CAS_Course_Cat1__c ccc1 = new CAS_Course_Cat1__c(Name='cat1');
        insert ccc1;
      
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id); 
        //System.debug('33333333333333333');
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        Lead l = new Lead(ownerId=u.Id, company='tCom' ,lastName ='tlastName');
        insert l;
        Test.startTest();
         //System.debug('4444444444444444');
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.selectedAccountForOpportunity=ReinggAccount.id;
            oCusLeadConvController.lookup.Account__c = a.id;
             oCusLeadConvController.wrapperIndex='1';
            
             oCusLeadConvController.isContactPage = false;
            oCusLeadConvController.cawList[0].checked = true;
            oCusLeadConvController.cawList[0].isLookup = true;
            oCusLeadConvController.cawList[0].accountObj= a;
            oCusLeadConvController.cawList[0].contactObj=c;
            oCusLeadConvController.cawList[0].isContact =true;
            oCusLeadConvController.firstPageSelectedRecord = oCusLeadConvController.cawList[0];
            oCusLeadConvController.next();
          

            
            
             //System.debug('55555555555555555'+oCusLeadConvController.owList);
            
            oCusLeadConvController.renderedSection1 = true;
            //oCusLeadConvController.renderedSection2 = true;
            //oCusLeadConvController.oppObj.CurrencyIsoCode = null;
           // oCusLeadConvController.ocrObj.Role = 'Lecterer';
           oCusLeadConvController.selectedLevel1 = ccc1.id;
           oCusLeadConvController.oppObj.CurrencyIsoCode = 'USD';
           oCusLeadConvController.oppObj.OwnerId = u.Id;
           oCusLeadConvController.oppProductOBj.IC_Quantity__c = 5;
           oCusLeadConvController.firstPageSelectedRecord.accountObj = a;
           //oCusLeadConvController.oppObj.CurrencyIsoCode = null;
           //oCusLeadConvController.firstPageSelectedRecord.accountObj = ;
            if(oCusLeadConvController.product != null){
                oCusLeadConvController.product.Name ='Test Product';
                oCusLeadConvController.product.productCode ='12345678901234';
                upsert oCusLeadConvController.product;
            }else{
                
                oCusLeadConvController.product = p;
            }
             oCusLeadConvController.OpporIndexPoint='0';
             oCusLeadConvController.owList[0].checked =true;
            oCusLeadConvController.owList[0].isNewCreation =false;
            oCusLeadConvController.finish();
            Update opp;
       Test.stopTest();
        
        
    }
    
    static testMethod void testFinishRSectionFalse7_5(){
    
        insertCustomSetting();
         //System.debug('000000000000');
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
         p.productCode ='12345678901234';
        update p;
        createAccountContact(u);
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
        CAS_Course_Cat1__c ccc1 = new CAS_Course_Cat1__c(Name='cat1');
        insert ccc1;
      
		Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
	  
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id); 
        //System.debug('33333333333333333');
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        Lead l = new Lead(ownerId=u.Id, company='tCom' ,lastName ='tlastName');
        insert l;
        Test.startTest();
         //System.debug('4444444444444444');
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.selectedAccountForOpportunity=ReinggAccount.id;
            oCusLeadConvController.lookup.Account__c = a.id;
             oCusLeadConvController.wrapperIndex='1';
            
             oCusLeadConvController.isContactPage = false;
            oCusLeadConvController.cawList[0].checked = true;
            oCusLeadConvController.cawList[0].isLookup = true;
            oCusLeadConvController.cawList[0].accountObj= a;
            oCusLeadConvController.cawList[0].contactObj=c;
            oCusLeadConvController.cawList[0].isContact =true;
            oCusLeadConvController.firstPageSelectedRecord = oCusLeadConvController.cawList[0];
            oCusLeadConvController.next();
          

            
            
             //System.debug('55555555555555555'+oCusLeadConvController.owList);
            
            //oCusLeadConvController.renderedSection1 = true;
            //oCusLeadConvController.renderedSection2 = true;
            //oCusLeadConvController.oppObj.CurrencyIsoCode = null;
           // oCusLeadConvController.ocrObj.Role = 'Lecterer';
           oCusLeadConvController.selectedLevel1 = ccc1.id;
           oCusLeadConvController.oppObj.CurrencyIsoCode = 'USD';
           oCusLeadConvController.oppObj.OwnerId = u.Id;
           oCusLeadConvController.oppProductOBj.IC_Quantity__c = 5;
           oCusLeadConvController.firstPageSelectedRecord.accountObj = a;
           //oCusLeadConvController.oppObj.CurrencyIsoCode = null;
           //oCusLeadConvController.firstPageSelectedRecord.accountObj = ;
            if(oCusLeadConvController.product != null){
                oCusLeadConvController.product.Name ='Test Product';
                oCusLeadConvController.product.productCode ='12345678901234';
                upsert oCusLeadConvController.product;
            }else{
                
                oCusLeadConvController.product = p;
            }
            oCusLeadConvController.oppObj.CurrencyIsoCode ='Test';
             oCusLeadConvController.OpporIndexPoint='0';
             oCusLeadConvController.owList[0].checked =true;
            oCusLeadConvController.owList[0].isNewCreation =false;
            oCusLeadConvController.finish();
            Update opp;
       Test.stopTest();
        
        
    }
    
    static testMethod void testFinishRSectionFalse7_6(){
    
        insertCustomSetting();
         //System.debug('000000000000');
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
         p.productCode ='12345678901234';
        update p;
        createAccountContact(u);
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
        CAS_Course_Cat1__c ccc1 = new CAS_Course_Cat1__c(Name='cat1');
        insert ccc1;
      
		Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
	  
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id); 
        //System.debug('33333333333333333');
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        Lead l = new Lead(ownerId=u.Id, company='tCom' ,lastName ='tlastName');
        insert l;
        Test.startTest();
         //System.debug('4444444444444444');
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.selectedAccountForOpportunity=ReinggAccount.id;
            oCusLeadConvController.lookup.Account__c = a.id;
             oCusLeadConvController.wrapperIndex='1';
            
             oCusLeadConvController.isContactPage = false;
            oCusLeadConvController.cawList[0].checked = true;
            oCusLeadConvController.cawList[0].isLookup = true;
            oCusLeadConvController.cawList[0].accountObj= a;
            oCusLeadConvController.cawList[0].contactObj=c;
            oCusLeadConvController.cawList[0].isContact =true;
            oCusLeadConvController.firstPageSelectedRecord = oCusLeadConvController.cawList[0];
            oCusLeadConvController.next();
          

            
            
             //System.debug('55555555555555555'+oCusLeadConvController.owList);
            
            //oCusLeadConvController.renderedSection1 = true;
            //oCusLeadConvController.renderedSection2 = true;
            //oCusLeadConvController.oppObj.CurrencyIsoCode = null;
            oCusLeadConvController.ocrObj.Role = 'Lecterer';
           oCusLeadConvController.selectedLevel1 = ccc1.id;
           //oCusLeadConvController.oppObj.CurrencyIsoCode = 'USD';
           oCusLeadConvController.oppObj.OwnerId = u.Id;
           oCusLeadConvController.oppProductOBj.IC_Quantity__c = 5;
           oCusLeadConvController.firstPageSelectedRecord.accountObj = a;
           //oCusLeadConvController.oppObj.CurrencyIsoCode = null;
           //oCusLeadConvController.firstPageSelectedRecord.accountObj = ;
            if(oCusLeadConvController.product != null){
                oCusLeadConvController.product.Name ='Test Product';
                oCusLeadConvController.product.productCode ='12345678901234';
                upsert oCusLeadConvController.product;
            }else{
                
                oCusLeadConvController.product = p;
            }
            oCusLeadConvController.oppObj.CurrencyIsoCode ='Test';
             oCusLeadConvController.OpporIndexPoint='0';
             oCusLeadConvController.owList[0].checked =true;
            oCusLeadConvController.owList[0].isNewCreation =false;
            oCusLeadConvController.finish();
            Update opp;
       Test.stopTest();
        
        
    }
    
    
    static testMethod void testFinishRSectionFalse10(){
    
        insertCustomSetting();
         //System.debug('000000000000');
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
         p.productCode ='12345678901234';
        update p;
        createAccountContact(u);
        //System.debug('111111111111111111');
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
         //System.debug('2222222222222222');
       CAS_Course_Cat1__c ccc1 = new CAS_Course_Cat1__c(Name='cat1');
        insert ccc1;
		
		Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
		
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id); 
        //System.debug('33333333333333333');
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        
         //System.debug('3333333333333b');
        Lead l = new Lead(ownerId=u.Id, company='tCom' ,lastName ='tlastName');
        insert l;
        Test.startTest();
         //System.debug('4444444444444444');
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.showEmailDomainMathes = true;
            oCusLeadConvController.searchContactsAndAccounts();
            oCusLeadConvController.selectedAccountForOpportunity=ReinggAccount.id;
            oCusLeadConvController.lookup.Account__c = a.id;
             oCusLeadConvController.wrapperIndex='1';
            
             oCusLeadConvController.isContactPage = false;
            oCusLeadConvController.cawList[0].checked = true;
            oCusLeadConvController.cawList[0].isLookup = true;
            oCusLeadConvController.cawList[0].accountObj= a;
            oCusLeadConvController.cawList[0].contactObj=c;
            oCusLeadConvController.cawList[0].isContact =true;
            oCusLeadConvController.firstPageSelectedRecord = oCusLeadConvController.cawList[0];
            oCusLeadConvController.next();
            

            
            
             //System.debug('55555555555555555'+oCusLeadConvController.owList);
            oCusLeadConvController.owList[0].checked =true;
            oCusLeadConvController.owList[0].isNewCreation =true;
            oCusLeadConvController.renderedSection1 = true;
           
           oCusLeadConvController.selectedLevel1 = ccc1.id;
           oCusLeadConvController.oppObj.CurrencyIsoCode = 'USD';
           oCusLeadConvController.oppObj.Name= 'testName';
           oCusLeadConvController.oppObj.OwnerId= u.Id;
           oCusLeadConvController.oppProductOBj.IC_Quantity__c = 5;
           oCusLeadConvController.oppProductOBj.Feedback_Notification__c = 'Send';
           oCusLeadConvController.oppObj.Course_Start_Date__c = System.Today(); 
           oCusLeadConvController.leadObj.Anticipated_Enrollment__c =1123; 
           oCusLeadConvController.firstPageSelectedRecord.accountObj = a;
           oCusLeadConvController.oppProductOBj.Order_Type__c ='Desk Copy';
           oCusLeadConvController.ocrObj.Role ='Decision Maker';
           //oCusLeadConvController.oppObj.CurrencyIsoCode = null;
           //oCusLeadConvController.firstPageSelectedRecord.accountObj = ;
           
          
           
           
            if(oCusLeadConvController.product != null){
                oCusLeadConvController.product.Name ='Test Product';
                oCusLeadConvController.product.productCode ='12345678901234';
                upsert oCusLeadConvController.product;
            }else{
                
                oCusLeadConvController.product = p;
            }
            oCusLeadConvController.lookup.Product__c = p.Id;
            
            oCusLeadConvController.OpporIndexPoint='1';
        
        //oCusLeadConvController.pricebookID =  (CasCS__c.getValues('Pricebook_Id') != null) ? CasCS__c.getValues('Pricebook_Id').Value__c : '01s60000000JOCGAA4';
        oCusLeadConvController.copyAddressTo = 'Both';
        oCusLeadConvController.deliveryAddress='testaddress'; 
        oCusLeadConvController.finish();
            Update opp;
       Test.stopTest();
        
        
    }
    
    static testMethod void testFinishRSectionFalse10_1(){
    
        insertCustomSetting();
         //System.debug('000000000000');
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
         p.productCode ='12345678901234';
        update p;
        createAccountContact(u);
        //System.debug('111111111111111111');
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
         //System.debug('2222222222222222');
       CAS_Course_Cat1__c ccc1 = new CAS_Course_Cat1__c(Name='cat1');
        insert ccc1;
		
		Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
		
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id); 
        //System.debug('33333333333333333');
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        
         //System.debug('3333333333333b');
        Lead l = new Lead(ownerId=u.Id, company='tCom' ,lastName ='tlastName');
        insert l;
        Test.startTest();
         //System.debug('4444444444444444');
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.showEmailDomainMathes = true;
            oCusLeadConvController.searchContactsAndAccounts();
            oCusLeadConvController.selectedAccountForOpportunity=ReinggAccount.id;
            oCusLeadConvController.lookup.Account__c = a.id;
             oCusLeadConvController.wrapperIndex='1';
            
             oCusLeadConvController.isContactPage = false;
            oCusLeadConvController.cawList[0].checked = true;
            oCusLeadConvController.cawList[0].isLookup = true;
            oCusLeadConvController.cawList[0].accountObj= a;
            oCusLeadConvController.cawList[0].contactObj=c;
            oCusLeadConvController.cawList[0].isContact =true;
            oCusLeadConvController.firstPageSelectedRecord = oCusLeadConvController.cawList[0];
            oCusLeadConvController.next();
            

            
            
             //System.debug('55555555555555555'+oCusLeadConvController.owList);
            oCusLeadConvController.owList[0].checked =true;
            oCusLeadConvController.owList[0].isNewCreation =true;
            oCusLeadConvController.renderedSection2 = true;
           
           oCusLeadConvController.selectedLevel1 = ccc1.id;
           oCusLeadConvController.oppObj.CurrencyIsoCode = 'USD';
           oCusLeadConvController.oppObj.Name= 'testName';
           oCusLeadConvController.oppObj.OwnerId= u.Id;
           oCusLeadConvController.oppObj.Volume_Year__c ='4';
           oCusLeadConvController.oppProductOBj.IC_Quantity__c = 5;
           oCusLeadConvController.oppProductOBj.Feedback_Notification__c = 'Send';
           oCusLeadConvController.oppObj.Course_Start_Date__c = System.Today(); 
           oCusLeadConvController.leadObj.Anticipated_Enrollment__c =1123; 
           oCusLeadConvController.firstPageSelectedRecord.accountObj = a;
           oCusLeadConvController.oppProductOBj.Order_Type__c ='Desk Copy';
           oCusLeadConvController.ocrObj.Role ='Decision Maker';
           //oCusLeadConvController.oppObj.CurrencyIsoCode = null;
           //oCusLeadConvController.firstPageSelectedRecord.accountObj = ;
           
          
           
           
            if(oCusLeadConvController.product != null){
                oCusLeadConvController.product.Name ='Test Product';
                oCusLeadConvController.product.productCode ='12345678901234';
                upsert oCusLeadConvController.product;
            }else{
                
                oCusLeadConvController.product = p;
            }
            oCusLeadConvController.lookup.Product__c = p.Id;
            
            oCusLeadConvController.OpporIndexPoint='1';
        
            //oCusLeadConvController.pricebookID =  (CasCS__c.getValues('Pricebook_Id') != null) ? CasCS__c.getValues('Pricebook_Id').Value__c : '01s60000000JOCGAA4';
            oCusLeadConvController.copyAddressTo = 'Both';
            oCusLeadConvController.finish();
            Update opp;
       Test.stopTest();
        
        
    }
    
    static testMethod void testFinishRSectionFalse10_2(){
    
        insertCustomSetting();
         //System.debug('000000000000');
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
         p.productCode ='12345678901234';
        update p;
        createAccountContact(u);
        //System.debug('111111111111111111');
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
        Id contactRecordtypeId = MiscFunctions.getRecordtypeId('Contact','T&F - Contacts');
        Contact c = zTEST_Shared.noinsertContact(u.id, a.id);
        c.FirstName = 'test1';
        c.LastName = 'name1';
        c.Email = 'test1@1test.com';
        c.RecordTypeId = contactRecordtypeId;
        insert c;
        
        Campus__c campus = new Campus__c();
        campus.name ='Test';
        campus.Account__c = a.id;
        insert campus;
        
        Campus__c campus2 = new Campus__c();
        campus2.name ='Test2';
        campus2.Account__c = a.id;
        insert campus2;
        
        Campus__c campus3 = new Campus__c();
        campus3.name ='NewCampus';
        campus3.Account__c = a.id;
        insert campus3;
        
        Department__c Dept = new Department__c();
        Dept.Name ='Test';
        Dept.Campus__c =campus.id;
        Dept.Account__c = a.id;
        insert Dept;
        c.Campus__c =campus.id;
        c.Department_Object__c = Dept.id;
        update c;
        
         Department__c Dept1 = new Department__c();
        Dept1.Name ='NewDepartment';
        Dept1.Campus__c =campus.id;
        Dept1.Account__c = a.id;
        insert Dept1;
        c.Campus__c =campus.id;
        c.Department_Object__c = Dept.id;
        update c;
        
        Department__c Dept2 = new Department__c();
        Dept2.Name ='Test2';
        
        Dept2.Account__c = a.id;
        insert Dept2;
        
        Department__c Dept3 = new Department__c();
        Dept3.Name ='NewDepartment';
        Dept3.Account__c = a.id;
        insert Dept3;
         //System.debug('2222222222222222');
       CAS_Course_Cat1__c ccc1 = new CAS_Course_Cat1__c(Name='cat1');
        insert ccc1;
		
		Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
		
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id); 
        //System.debug('33333333333333333');
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        
         //System.debug('3333333333333b');
        Lead l = new Lead(ownerId=u.Id, company='tCom' ,lastName ='tlastName');
        insert l;
        Test.startTest();
         //System.debug('4444444444444444');
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.showEmailDomainMathes = true;
            oCusLeadConvController.searchContactsAndAccounts();
            oCusLeadConvController.selectedAccountForOpportunity=ReinggAccount.id;
            oCusLeadConvController.lookup.Account__c = a.id;
             oCusLeadConvController.wrapperIndex='1';
            
             oCusLeadConvController.isContactPage = false;
            oCusLeadConvController.cawList[0].checked = true;
            oCusLeadConvController.cawList[0].isLookup = true;
            oCusLeadConvController.cawList[0].accountObj= a;
            oCusLeadConvController.cawList[0].contactObj=c;
            oCusLeadConvController.cawList[0].isContact =true;
            oCusLeadConvController.firstPageSelectedRecord = oCusLeadConvController.cawList[0];
            oCusLeadConvController.next();
            

            
            
             //System.debug('55555555555555555'+oCusLeadConvController.owList);
            oCusLeadConvController.owList[0].checked =true;
            oCusLeadConvController.owList[0].isNewCreation =true;
            //oCusLeadConvController.renderedSection2 = true;
           
           oCusLeadConvController.selectedLevel1 = ccc1.id;
           oCusLeadConvController.oppObj.CurrencyIsoCode = 'USD';
           oCusLeadConvController.oppObj.Name= 'testName';
           oCusLeadConvController.oppObj.OwnerId= u.Id;
           oCusLeadConvController.oppObj.Volume_Year__c ='4';
           oCusLeadConvController.oppProductOBj.IC_Quantity__c = 5;
           oCusLeadConvController.oppProductOBj.Feedback_Notification__c = 'Send';
           oCusLeadConvController.oppObj.Course_Start_Date__c = System.Today(); 
           oCusLeadConvController.leadObj.Anticipated_Enrollment__c =1123; 
           oCusLeadConvController.firstPageSelectedRecord.accountObj = a;
           oCusLeadConvController.oppProductOBj.Order_Type__c ='Desk Copy';
           oCusLeadConvController.ocrObj.Role ='Decision Maker';
           //oCusLeadConvController.oppObj.CurrencyIsoCode = null;
           //oCusLeadConvController.firstPageSelectedRecord.accountObj = ;
           
          
           
           
            if(oCusLeadConvController.product != null){
                oCusLeadConvController.product.Name ='Test Product';
                oCusLeadConvController.product.productCode ='12345678901234';
                upsert oCusLeadConvController.product;
            }else{
                
                oCusLeadConvController.product = p;
            }
            oCusLeadConvController.lookup.Product__c = p.Id;
            
            oCusLeadConvController.OpporIndexPoint='1';
        
            //oCusLeadConvController.pricebookID =  (CasCS__c.getValues('Pricebook_Id') != null) ? CasCS__c.getValues('Pricebook_Id').Value__c : '01s60000000JOCGAA4';
            oCusLeadConvController.copyAddressTo = 'Both';
            oCusLeadConvController.finish();
            oCusLeadConvController.createCampusIdToDepartmentsMap(new Set<Id>{campus.id});
            Map<String,String> ContIddepartIdMap = new Map<String,String>();
            ContIddepartIdMap.put(c.id,Dept.id);
            ContIddepartIdMap.put(c.id,Dept2.id);
            ContIddepartIdMap.put(c.id,Dept3.id);
            oCusLeadConvController.createContactToCampus(ContIddepartIdMap);
            Update opp;
       Test.stopTest();
        
        
    }
    
    static testMethod void testFinishRSectionFalse10_3(){
    
        insertCustomSetting2();
         //System.debug('000000000000');
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
         p.productCode ='12345678901234';
        update p;
        createAccountContact(u);
        //System.debug('111111111111111111');
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
        Id contactRecordtypeId = MiscFunctions.getRecordtypeId('Contact','T&F - Contacts');
        Contact c = zTEST_Shared.noinsertContact(u.id, a.id);
        c.FirstName = 'test1';
        c.LastName = 'name1';
        c.Email = 'test1@1test.com';
        c.RecordTypeId = contactRecordtypeId;
        insert c;
        
        Campus__c campus = new Campus__c();
        campus.name ='Test';
        campus.Account__c = a.id;
        insert campus;
        
        Campus__c campus2 = new Campus__c();
        campus2.name ='Test2';
        campus2.Account__c = a.id;
        insert campus2;
        
        Campus__c campus3 = new Campus__c();
        campus3.name ='NewCampus';
        campus3.Account__c = a.id;
        insert campus3;
        
        Department__c Dept = new Department__c();
        Dept.Name ='Test';
        Dept.Campus__c =campus.id;
        Dept.Account__c = a.id;
        insert Dept;
        c.Campus__c =campus.id;
        c.Department_Object__c = Dept.id;
        update c;
        
        Department__c Dept2 = new Department__c();
        Dept2.Name ='Test2';
        
        Dept2.Account__c = a.id;
        insert Dept2;
        
        Department__c Dept3 = new Department__c();
        Dept3.Name ='NewDepartment';
        Dept3.Account__c = a.id;
        insert Dept3;
         //System.debug('2222222222222222');
       CAS_Course_Cat1__c ccc1 = new CAS_Course_Cat1__c(Name='cat1');
        insert ccc1;
		
		Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
		
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id); 
        //System.debug('33333333333333333');
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        
         //System.debug('3333333333333b');
        Lead l = new Lead(ownerId=u.Id, company='tCom' ,lastName ='tlastName');
        insert l;
        Test.startTest();
         //System.debug('4444444444444444');
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.showEmailDomainMathes = true;
            oCusLeadConvController.searchContactsAndAccounts();
            oCusLeadConvController.selectedAccountForOpportunity=ReinggAccount.id;
            oCusLeadConvController.lookup.Account__c = a.id;
             oCusLeadConvController.wrapperIndex='1';
            
             oCusLeadConvController.isContactPage = false;
            oCusLeadConvController.cawList[0].checked = true;
            oCusLeadConvController.cawList[0].isLookup = true;
            oCusLeadConvController.cawList[0].accountObj= a;
            oCusLeadConvController.cawList[0].contactObj=c;
            oCusLeadConvController.cawList[0].isContact =true;
            oCusLeadConvController.firstPageSelectedRecord = oCusLeadConvController.cawList[0];
            oCusLeadConvController.next();
            

            
            
             //System.debug('55555555555555555'+oCusLeadConvController.owList);
            oCusLeadConvController.owList[0].checked =true;
            oCusLeadConvController.owList[0].isNewCreation =true;
            //oCusLeadConvController.renderedSection2 = true;
           
           oCusLeadConvController.selectedLevel1 = ccc1.id;
           oCusLeadConvController.oppObj.CurrencyIsoCode = 'USD';
           oCusLeadConvController.oppObj.Name= 'testName';
           oCusLeadConvController.oppObj.OwnerId= u.Id;
           oCusLeadConvController.oppObj.Volume_Year__c ='4';
           oCusLeadConvController.oppProductOBj.IC_Quantity__c = 5;
           oCusLeadConvController.oppProductOBj.Feedback_Notification__c = 'Send';
           oCusLeadConvController.oppObj.Course_Start_Date__c = System.Today(); 
           oCusLeadConvController.leadObj.Anticipated_Enrollment__c =1123; 
           oCusLeadConvController.firstPageSelectedRecord.accountObj = a;
           oCusLeadConvController.oppProductOBj.Order_Type__c ='Desk Copy';
           oCusLeadConvController.ocrObj.Role ='Decision Maker';
           //oCusLeadConvController.oppObj.CurrencyIsoCode = null;
           //oCusLeadConvController.firstPageSelectedRecord.accountObj = ;
           
          
           
           
            if(oCusLeadConvController.product != null){
                oCusLeadConvController.product.Name ='Test Product';
                oCusLeadConvController.product.productCode ='12345678901234';
                upsert oCusLeadConvController.product;
            }else{
                
                oCusLeadConvController.product = p;
            }
            oCusLeadConvController.lookup.Product__c = p.Id;
            
            oCusLeadConvController.OpporIndexPoint='1';
        
            //oCusLeadConvController.pricebookID =  (CasCS__c.getValues('Pricebook_Id') != null) ? CasCS__c.getValues('Pricebook_Id').Value__c : '01s60000000JOCGAA4';
            oCusLeadConvController.copyAddressTo = 'Both';
            oCusLeadConvController.finish();
           Update opp;
       Test.stopTest();
        
        
    }
    
    
    static testMethod void testGetPricebookNames(){
    
        insertCustomSetting();
        
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
        p.productCode ='12345678901234';
        update p;
        createAccountContact(u);
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
        CAS_Course_Cat1__c ccc1 = new CAS_Course_Cat1__c(Name='cat1');
        insert ccc1;
		
		Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
		
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id); 
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        Lead l = new Lead(ownerId=u.Id, company='tCom' ,lastName ='tlastName');
        insert l;

        CasCS__c casCS8 = new CasCS__c(Name='Pricebook_Id', Value__c=p.id, Description__c='test');
        insert casCS8;
        
        Test.startTest();
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.getPricebookNames();
            List<SelectOption> level1Items =oCusLeadConvController.level1Items;
            List<SelectOption> level2Items =oCusLeadConvController.level2Items;
            List<SelectOption> level3Items = oCusLeadConvController.level3Items;
            oCusLeadConvController.Lookup.Product__c =p.id;
            oCusLeadConvController.getProductDetail();
            Update opp;
       Test.stopTest();
        
        
    }
   
    
    
   
    
      static testMethod void testUpdateOptionsCampus(){
    
        insertCustomSetting();
         //System.debug('000000000000');
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
        createAccountContact(u);
        //System.debug('111111111111111111');
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
         //System.debug('2222222222222222');
      
	    Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
		
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id); 
        //System.debug('33333333333333333');
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        
         //System.debug('3333333333333b');
        Lead l = getLead(u.Id, p.Id, 'Associate');
        Test.startTest();
         //System.debug('4444444444444444');
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.updateOptionsCIndex = '1';
            oCusLeadConvController.updateOptionsCIsCampus ='Y';
            oCusLeadConvController.updateOptionsCName ='Test';
            oCusLeadConvController.updateOptions();
            Update opp;
       Test.stopTest();
        
    }
    
    static testMethod void testUpdateOptionsDept(){
    
        insertCustomSetting();
        //System.debug('000000000000');
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
        createAccountContact(u);
        //System.debug('111111111111111111');
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
         //System.debug('2222222222222222');
      
		Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
	  
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id); 
        //System.debug('33333333333333333');
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        
         //System.debug('3333333333333b');
        Lead l = getLead(u.Id, p.Id, 'Associate');
        Test.startTest();
         //System.debug('4444444444444444');
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.updateOptionsCIndex = '1';
            oCusLeadConvController.updateOptionsCIsCampus ='N';
            oCusLeadConvController.updateOptionsCName ='Test';
            oCusLeadConvController.updateOptions();
            Update opp;
       Test.stopTest();
        
    }
    
    
    static testMethod void testGetProductDetail(){
        insertCustomSetting();
        
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
        createAccountContact(u);
        
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
        //System.debug('a11'+a.id);
		
		Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
		
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id); 
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        
        
        Lead l = getLead(u.Id, p.Id, 'Associate');
        Test.startTest();
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.GetProductDetail();
            oCusLeadConvController.Lookup.Product__c =p.id;
            oCusLeadConvController.GetProductDetail();
            Update opp;
        Test.stopTest();
    }
    
    static testMethod void testCategories(){
        
        insertCustomSetting();
        
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
        createAccountContact(u);
        
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
     
    
        CAS_Course_Cat1__c ccc1 = new CAS_Course_Cat1__c(Name='cat1');
        insert ccc1;
        
        CAS_Course_Cat2__c ccc2 = new CAS_Course_Cat2__c(Name='cat2' ,CAS_Course_Cat1__c=ccc1.id);
        insert ccc2;
        
        CAS_Course_Cat3__c ccc3 = new CAS_Course_Cat3__c(Name='cat3', CAS_Course_Cat2__c = ccc2 .id);
        insert ccc3;
        
    
        Lead l = getLead(u.Id, p.Id, 'Associate');
        Test.startTest();
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            //System.debug(oCusLeadConvController.level1Items);
            oCusLeadConvController.selectedLevel1 = 'cat1';
            //System.debug(oCusLeadConvController.level2Items);
            oCusLeadConvController.selectedLevel2 = 'cat2';
            //System.debug(oCusLeadConvController.level3Items);
            oCusLeadConvController.selectedLevel3 = 'cat3';
            
            oCusLeadConvController.resetLevel2();
            
        Test.stopTest();
        
   
    }   
    
    
    static testMethod void testFinishRSectionFalse11(){
    
        insertCustomSetting();
         //System.debug('000000000000');
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
         p.productCode ='12345678901234';
        update p;
        createAccountContact(u);
        //System.debug('111111111111111111');
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
         //System.debug('2222222222222222');
       CAS_Course_Cat1__c ccc1 = new CAS_Course_Cat1__c(Name='cat1');
        insert ccc1;
		
		Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
		
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id); 
        //System.debug('33333333333333333');
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        
         //System.debug('3333333333333b');
        Lead l = new Lead(ownerId=u.Id, company='tCom' ,lastName ='tlastName');
        insert l;
        Test.startTest();
         //System.debug('4444444444444444');
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.showEmailDomainMathes = true;
            oCusLeadConvController.searchContactsAndAccounts();
            oCusLeadConvController.selectedAccountForOpportunity=ReinggAccount.id;
            oCusLeadConvController.lookup.Account__c = a.id;
             oCusLeadConvController.wrapperIndex='1';
            
             oCusLeadConvController.isContactPage = false;
            oCusLeadConvController.cawList[0].checked = true;
            oCusLeadConvController.cawList[0].isLookup = true;
            oCusLeadConvController.cawList[0].accountObj= a;
            oCusLeadConvController.cawList[0].contactObj=c;
            oCusLeadConvController.cawList[0].isContact =true;
            oCusLeadConvController.firstPageSelectedRecord = oCusLeadConvController.cawList[0];
            oCusLeadConvController.next();
            
             //System.debug('55555555555555555'+oCusLeadConvController.owList);
            oCusLeadConvController.owList[0].checked =true;
            oCusLeadConvController.owList[0].isNewCreation =true;
            oCusLeadConvController.renderedSection1 = true;
           
           
           oCusLeadConvController.selectedLevel1 = ccc1.id;
           oCusLeadConvController.oppObj.CurrencyIsoCode = 'USD';
           oCusLeadConvController.oppObj.Name= 'testName';
           oCusLeadConvController.oppObj.OwnerId= u.Id;
           oCusLeadConvController.oppProductOBj.IC_Quantity__c = 5;
           oCusLeadConvController.firstPageSelectedRecord.accountObj = a;
           //oCusLeadConvController.oppObj.CurrencyIsoCode = null;
           //oCusLeadConvController.firstPageSelectedRecord.accountObj = ;
           
          
           
           
            if(oCusLeadConvController.product != null){
                oCusLeadConvController.product.Name ='Test Product';
                oCusLeadConvController.product.productCode ='12345678901234';
                upsert oCusLeadConvController.product;
            }else{
                
                oCusLeadConvController.product = p;
            }
            oCusLeadConvController.lookup.Product__c = p.Id;
            
            oCusLeadConvController.OpporIndexPoint='0';
            //oCusLeadConvController.pricebookID =  (CasCS__c.getValues('Pricebook_Id') != null) ? CasCS__c.getValues('Pricebook_Id').Value__c : '01s60000000JOCGAA4';
            oCusLeadConvController.finish();
            Update opp;
       Test.stopTest();
        
        
    } 
    
    
    static testMethod void testFinishRSectionFalse13(){
    
        insertCustomSetting();
         //System.debug('000000000000');
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
         p.productCode ='12345678901234';
        update p;
        createAccountContact(u);
        //System.debug('111111111111111111');
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
         //System.debug('2222222222222222');
       CAS_Course_Cat1__c ccc1 = new CAS_Course_Cat1__c(Name='cat1');
        insert ccc1;
		
		Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
		
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id); 
        //System.debug('33333333333333333');
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        
         //System.debug('3333333333333b');
        Lead l = new Lead(ownerId=u.Id, company='tCom' ,lastName ='tlastName');
        insert l;
        Test.startTest();
         //System.debug('4444444444444444');
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.showEmailDomainMathes = true;
            oCusLeadConvController.searchContactsAndAccounts();
            oCusLeadConvController.selectedAccountForOpportunity=ReinggAccount.id;
            oCusLeadConvController.lookup.Account__c = a.id;
            oCusLeadConvController.showExistingContactRoles =false;
             oCusLeadConvController.wrapperIndex='1';
            
             oCusLeadConvController.isContactPage = false;
            oCusLeadConvController.cawList[0].checked = true;
            oCusLeadConvController.cawList[0].isLookup = true;
            oCusLeadConvController.cawList[0].accountObj= a;
            oCusLeadConvController.cawList[0].contactObj=c;
            oCusLeadConvController.cawList[0].isContact =true;
            oCusLeadConvController.firstPageSelectedRecord = oCusLeadConvController.cawList[0];
            oCusLeadConvController.next();
            
             //System.debug('55555555555555555'+oCusLeadConvController.owList);
            oCusLeadConvController.owList[0].checked =true;
            oCusLeadConvController.owList[0].isNewCreation =true;
            oCusLeadConvController.renderedSection1 = true;
           
           
           oCusLeadConvController.selectedLevel1 = ccc1.id;
           oCusLeadConvController.oppObj.CurrencyIsoCode = 'USD';
           oCusLeadConvController.oppObj.Name= 'testName';
           oCusLeadConvController.oppObj.OwnerId= u.Id;
           oCusLeadConvController.oppProductOBj.IC_Quantity__c = 5;
           oCusLeadConvController.firstPageSelectedRecord.accountObj = a;
           //oCusLeadConvController.oppObj.CurrencyIsoCode = null;
           //oCusLeadConvController.firstPageSelectedRecord.accountObj = ;
           
          
           
           
            /* if(oCusLeadConvController.product != null){
                oCusLeadConvController.product.productCode ='12345678901234';
                update oCusLeadConvController.product;
            }else{
                
                oCusLeadConvController.product = p;
            }
            oCusLeadConvController.lookup.Product__c = p.Id;
            
            oCusLeadConvController.OpporIndexPoint='0';
            //oCusLeadConvController.pricebookID =  (CasCS__c.getValues('Pricebook_Id') != null) ? CasCS__c.getValues('Pricebook_Id').Value__c : '01s60000000JOCGAA4';
            oCusLeadConvController.finish(); */
            Update opp;
       Test.stopTest();
        
        
    }
    
     static testMethod void testFinishRSectionFalse12(){
    
        insertCustomSetting();
         //System.debug('000000000000');
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
         p.productCode ='123456789012';
        update p;
        createAccountContact(u);
        //System.debug('111111111111111111');
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
         //System.debug('2222222222222222');
       CAS_Course_Cat1__c ccc1 = new CAS_Course_Cat1__c(Name='cat1');
        insert ccc1;
		
		Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
		
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id); 
        //System.debug('33333333333333333');
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        
         //System.debug('3333333333333b');
        Lead l = new Lead(ownerId=u.Id, company='tCom' ,lastName ='tlastName', ISBN__c='123456789012');
        insert l;
        Campus__c campus = new Campus__c();
        campus.name ='Test';
        campus.Account__c = a.id;
        insert campus;
        Contact c2 = getContact3(u.Id, a.Id);
        c2.Campus__c = campus.id;
        update c2;
        Test.startTest();
         //System.debug('4444444444444444');
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.leadObj.Email='test3@test.com';
            oCusLeadConvController.showEmailDomainMathes = true;
            oCusLeadConvController.searchContactsAndAccounts();
            oCusLeadConvController.sortExpression =null;
            oCusLeadConvController.getSortDirection();
            oCusLeadConvController.sortExp ='Name';
            oCusLeadConvController.sortExpression ='Name';
            oCusLeadConvController.getSortDirection();
         Update opp;
       Test.stopTest();
        
        
    } 
    
    
     //********************** Setup Sample Data **********************
    static PricebookEntry pbe ;
   /*static testMethod void testCustomLeadConversionTF2Controller()
    {
        //Setup sample data
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
        
        Lead l = getLead(u.Id, p.Id, 'Associate');
        
        Test.startTest();
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            //oCusLeadConvController.previous();
            oCusLeadConvController.Lookup.Product__c = p.id;
            //oCusLeadConvController.searchByDomain();
            //oCusLeadConvController.manageChecks1();
            oCusLeadConvController.wrapperIndex='1';
            oCusLeadConvController.getProductDetail();
            oCusLeadConvController.getAllCampusDropDown();
            oCusLeadConvController.getAllDepartmentDropDown();
            oCusLeadConvController.getDepartmentDropDown();
            oCusLeadConvController.getCampusDropDown();
            oCusLeadConvController.resetLevel2();
            //oCusLeadConvController.wrapperIndex='3';
            oCusLeadConvController.cawList[1].checked = true;
            oCusLeadConvController.next();
            oCusLeadConvController.cawList[2].checked = true;
            oCusLeadConvController.showExistingContactRoles = false;
            oCusLeadConvController.next();
            
            oCusLeadConvController.cancel();
        Test.stopTest();
    }
    */
   
    static void createCampusDept(Account a)
    {
        Campus__c campus = new Campus__c();
        campus.name ='Test';
        campus.Account__c = a.id;
        insert campus;
        
        Campus__c campus2 = new Campus__c();
        campus2.name ='Test2';
        campus2.Account__c = a.id;
        insert campus2;
        
        Campus__c campus3 = new Campus__c();
        campus3.name ='NewCampus';
        campus3.Account__c = a.id;
        insert campus3;
        
        Department__c Dept = new Department__c();
        Dept.Name ='Test';
        
        Dept.Account__c = a.id;
        insert Dept;
        
        Department__c Dept2 = new Department__c();
        Dept2.Name ='Test2';
        Dept2.Account__c = a.id;
        insert Dept2;
        
        Department__c Dept3 = new Department__c();
        Dept3.Name ='NewDepartment';
        Dept3.Account__c = a.id;
        insert Dept3;
    }
    
    static void insertCustomSetting()
    {
        List<CasCS__c> csList = new List<CasCS__c>();
        CasCS__c casCS1 = new CasCS__c(Name='Account_RT_Id', Value__c='0120Y000000Wn4vQAC', Description__c='test');
        csList.add(casCS1);
        CasCS__c casCS2 = new CasCS__c(Name='Contact_Roles_Id', Value__c='0120Y000000Wn9SQAS, 0122X000000KDOZQA4, 0120Y000000Wn8YQAS, 0120Y000000Wn8TQAS', Description__c='test');
        csList.add(casCS2);
        CasCS__c casCS3 = new CasCS__c(Name='Contact_RT_Id', Value__c='0120Y000000Wn68QAC', Description__c='test');
        csList.add(casCS3);
        CasCS__c casCS4 = new CasCS__c(Name='Informa_Contact_Roles_Id', Value__c='0120Y000000Wn9XQAS, 0122X000000KDOZQA4', Description__c='test');
        csList.add(casCS4);
        CasCS__c casCS5 = new CasCS__c(Name='opbs1', Value__c='0120Y000000Wn9SQAS', Description__c='test');
        csList.add(casCS5);
        CasCS__c casCS6 = new CasCS__c(Name='opbs2', Value__c='0120Y000000Wn8TQAS', Description__c='test');
        csList.add(casCS6);
        CasCS__c casCS7 = new CasCS__c(Name='Opportunity_RT_Ids', Value__c='0120Y000000Wn9SQAS, 0122X000000KDOZQA4, 0120Y000000Wn8YQAS, 0120Y000000Wn8TQAS, 0120Y000000Wn9XQAS', Description__c='test');
        csList.add(casCS7);
        CasCS__c casCS8 = new CasCS__c(Name='Pricebook_Id', Value__c='01s0Y00000832ctQAA', Description__c='test');
        csList.add(casCS8);
        insert csList;
    }
    
    
    static void insertCustomSetting2()
    {
        List<CasCS__c> csList = new List<CasCS__c>();
        CasCS__c casCS1 = new CasCS__c(Name='Account_RT_Id', Value__c='0120Y000000Wn4vQAC', Description__c='test');
        csList.add(casCS1);
        CasCS__c casCS2 = new CasCS__c(Name='Contact_Roles_Id', Value__c='0120Y000000Wn9SQAS, 0122X000000KDOZQA4, 0120Y000000Wn8YQAS, 0120Y000000Wn8TQAS', Description__c='test');
        //csList.add(casCS2);
        CasCS__c casCS3 = new CasCS__c(Name='Contact_RT_Id', Value__c='0120Y000000Wn68QAC', Description__c='test');
        csList.add(casCS3);
        CasCS__c casCS4 = new CasCS__c(Name='Informa_Contact_Roles_Id', Value__c='0120Y000000Wn9XQAS, 0122X000000KDOZQA4', Description__c='test');
        csList.add(casCS4);
        CasCS__c casCS5 = new CasCS__c(Name='opbs1', Value__c='0120Y000000Wn9SQAS', Description__c='test');
        csList.add(casCS5);
        CasCS__c casCS6 = new CasCS__c(Name='opbs2', Value__c='0120Y000000Wn8TQAS', Description__c='test');
        csList.add(casCS6);
        CasCS__c casCS7 = new CasCS__c(Name='Opportunity_RT_Ids', Value__c='0120Y000000Wn9SQAS, 0122X000000KDOZQA4, 0120Y000000Wn8YQAS, 0120Y000000Wn8TQAS, 0120Y000000Wn9XQAS', Description__c='test');
        csList.add(casCS7);
        CasCS__c casCS8 = new CasCS__c(Name='Pricebook_Id', Value__c='01s0Y00000832ctQAA', Description__c='test');
        csList.add(casCS8);
        insert csList;
    }
    static Product2 getProduct() {
        String product2RecordtypeId = [select id from RecordType where sobjecttype = 'Product2' limit 1].Id;
       
        Product2 p = zTEST_Shared.insertProduct2(product2RecordtypeId);
        Pricebook2 standardPb = zTEST_Shared.insertPricebook2_2();
        Pricebook2 pb = new Pricebook2();
        pb.Name = 'T&F Journals Price Book';
        pb.IsActive = true;
        insert pb;
        String pricebookID = (CasCS__c.getValues('Pricebook_Id') != null) ? CasCS__c.getValues('Pricebook_Id').Value__c : '01s0Y00000832ctQAA';
        PricebookEntry standardPbe = new PricebookEntry(Pricebook2Id=standardPb.Id, Product2Id=p.id, UnitPrice=1.00, IsActive=true, UseStandardPrice=false, CurrencyIsoCode='USD');
        insert standardPbe;
        //PricebookEntry pbe = new PricebookEntry(Pricebook2Id='01s60000000680d', Product2Id=p.id, UnitPrice=1.00, IsActive=true, UseStandardPrice=false, CurrencyIsoCode='USD');
        pbe = new PricebookEntry(Pricebook2Id=pricebookID,Product2Id=p.id, UnitPrice=1.00, IsActive=true, UseStandardPrice=false, CurrencyIsoCode='USD');
        insert pbe;
        return p;
    }
    
    static Lead getLead(Id userId, Id productId, String JobCategory) {

        Id recordtypeId = MiscFunctions.getRecordtypeId('Lead','T&F - Leads');
        Lead l = zTEST_Shared.insertLead(userId, recordtypeId);
        l.Email = 'test@test.com';
        l.Company = 'test';
        l.Course_Name__c ='Test';
        l.Order_Type__c='Both';
        l.CurrencyIsoCode='GBP';
        l.Course_Start_Date__c = Date.today();
        l.Product_Name__c = productId;
        l.Job_Category__c = JobCategory;
        l.Business__c ='Journals';
        l.Ringgold__c='RGID007';
        l.ISBN__c ='123456789012';
        update l;
        return l;
    }

    static Lead getLead_NoRingold(Id userId, Id productId, String JobCategory) {

        Id recordtypeId = MiscFunctions.getRecordtypeId('Lead','T&F - Leads');
        Lead l = zTEST_Shared.insertLead(userId, recordtypeId);
        l.Email = 'test@test.com';
        l.Company = 'test';
        l.Product_Name__c = productId;
        l.Job_Category__c = JobCategory;
        l.Business__c ='Journals';
        //l.Ringgold__c='RGID007';
        update l;
        return l;
    }
    
    static Contact getContact2(Id userId, Id accountId) {

        Id contactRecordtypeId = MiscFunctions.getRecordtypeId('Contact','T&F - Contacts');
        Contact c = zTEST_Shared.noinsertContact(userId, accountId);
        c.FirstName = 'test2';
        c.LastName = 'name2';
        c.Email = 'test2@test.com';
        c.RecordTypeId = contactRecordtypeId;
        insert c;
        return c;
    }
    
    static Contact getContact(Id userId, Id accountId) {

        Id contactRecordtypeId = MiscFunctions.getRecordtypeId('Contact','T&F - Contacts');
        Contact c = zTEST_Shared.noinsertContact(userId, accountId);
        c.FirstName = 'test';
        c.LastName = 'name';
        c.Email = 'test@test.com';
        c.RecordTypeId = contactRecordtypeId;
        insert c;
        return c;
    }
    
    static Contact getContact3(Id userId, Id accountId) {

        Id contactRecordtypeId = MiscFunctions.getRecordtypeId('Contact','T&F - Contacts');
        Contact c = zTEST_Shared.noinsertContact(userId, accountId);
        //c.FirstName = 'test';
        //c.LastName = 'name';
        c.Email = 'test3@test.com';
        c.RecordTypeId = contactRecordtypeId;
        insert c;
        return c;
    }
    static Account ReinggAccount ;
    static Account getAccount(Id userId,String Name) 
    {        
        Id accountRecordtypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        Account a = new Account();
        a.Name = Name;
        a.Type = 'Customer';
        a.OwnerId = userId;
        a.RecordTypeId = accountRecordtypeId;
        a.Ringgold_Account_ID__c='RGID007';
        insert a;
		
		Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
		
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, userId, a.Id); 
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        ReinggAccount = a;
        return a;
    }
    Static Contact c;
    Static Contact c2;
    static void createAccountContact(User u){
        
        
        Account a2 = new Account();
        a2.Name = 'TestName id';
        a2.Type = 'Customer';
        a2.OwnerId = u.Id;
        a2.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a2.Ringgold_Account_ID__c='RGID009';
        insert a2;
        //System.debug('a2'+a2.id);
        Account a1 = getAccount(u.Id,'test test');
        //System.debug('a1'+a1.id);
        Account a = new Account();
        a.Name = 'TestName id';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID006';
        insert a;
        //System.debug('a 1'+a.id);
        
        createCampusDept(a);
        createCampusDept(a1);
        createCampusDept(a2);
         c = getContact(u.Id, a.Id);
         c2 = getContact2(u.Id, a2.Id);
        
		Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
		
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id); 
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        
        Opportunity opp2 = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a2.Id); 
        OpportunityLineItem oli2 = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp2.Id);
        Update opp;
        Update opp2;
        
    }
    
    static testMethod void testFinishRSectionFalse10_Test(){
    
        insertCustomSetting();
         //System.debug('000000000000');
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
         p.productCode ='12345678901234';
        update p;
        createAccountContact(u);
        //System.debug('111111111111111111');
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
         //System.debug('2222222222222222');
       CAS_Course_Cat1__c ccc1 = new CAS_Course_Cat1__c(Name='cat1');
        insert ccc1;
		
		Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
		
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id); 
        //System.debug('33333333333333333');
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        
         //System.debug('3333333333333b');
        Lead l = new Lead(ownerId=u.Id, company='tCom' ,lastName ='tlastName');
        insert l;
        Test.startTest();
         //System.debug('4444444444444444');
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.showEmailDomainMathes = true;
            oCusLeadConvController.searchContactsAndAccounts();
            oCusLeadConvController.selectedAccountForOpportunity=ReinggAccount.id;
            oCusLeadConvController.lookup.Account__c = a.id;
            oCusLeadConvController.wrapperIndex='1';
            
             oCusLeadConvController.isContactPage = false;
            oCusLeadConvController.cawList[0].checked = true;
            oCusLeadConvController.cawList[0].isLookup = true;
            oCusLeadConvController.cawList[0].accountObj= a;
            oCusLeadConvController.cawList[0].contactObj=c;
            oCusLeadConvController.cawList[0].isContact =true;
            oCusLeadConvController.firstPageSelectedRecord = oCusLeadConvController.cawList[0];
            oCusLeadConvController.next();
            

            
            
             //System.debug('55555555555555555'+oCusLeadConvController.owList);
            oCusLeadConvController.owList[0].checked =true;
            oCusLeadConvController.owList[0].isNewCreation =true;
            oCusLeadConvController.renderedSection1 = true;
           
           oCusLeadConvController.selectedLevel1 = ccc1.id;
           oCusLeadConvController.oppObj.CurrencyIsoCode = 'USD';
           oCusLeadConvController.oppObj.Name= 'testName';
           oCusLeadConvController.oppObj.OwnerId= u.Id;
           oCusLeadConvController.oppProductOBj.IC_Quantity__c = 5;
           oCusLeadConvController.oppProductOBj.Feedback_Notification__c = 'Send';
           oCusLeadConvController.oppObj.Course_Start_Date__c = System.Today(); 
           oCusLeadConvController.leadObj.Anticipated_Enrollment__c =1123; 
           oCusLeadConvController.firstPageSelectedRecord.accountObj = a;
           oCusLeadConvController.oppProductOBj.Order_Type__c ='Desk Copy';
           oCusLeadConvController.ocrObj.Role ='Decision Maker';
           //oCusLeadConvController.oppObj.CurrencyIsoCode = null;
           //oCusLeadConvController.firstPageSelectedRecord.accountObj = ;
           
          
           
           
            if(oCusLeadConvController.product != null){
                oCusLeadConvController.product.Name ='Test Product';
                oCusLeadConvController.product.productCode ='12345678901234';
                upsert oCusLeadConvController.product;
            }else{
                
                oCusLeadConvController.product = p;
            }
            oCusLeadConvController.lookup.Product__c = p.Id;
            
            oCusLeadConvController.OpporIndexPoint='0';
        
            //oCusLeadConvController.pricebookID =  (CasCS__c.getValues('Pricebook_Id') != null) ? CasCS__c.getValues('Pricebook_Id').Value__c : '01s60000000JOCGAA4';
            oCusLeadConvController.copyAddressTo = 'Both';
           Update opp;
            oCusLeadConvController.finish();
            
       Test.stopTest();
        
        
    }
    
    static testMethod void testFinishRSectionFalse10_Test_1(){
    
        insertCustomSetting();
         //System.debug('000000000000');
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
         p.productCode ='12345678901234';
        update p;
        createAccountContact(u);
        //System.debug('111111111111111111');
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
         //System.debug('2222222222222222');
       CAS_Course_Cat1__c ccc1 = new CAS_Course_Cat1__c(Name='cat1');
        insert ccc1;
		
		Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
		
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id); 
        //System.debug('33333333333333333');
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        
         //System.debug('3333333333333b');
        Lead l = new Lead(ownerId=u.Id, company='tCom' ,lastName ='tlastName');
        insert l;
        Test.startTest();
         //System.debug('4444444444444444');
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.showEmailDomainMathes = true;
            oCusLeadConvController.searchContactsAndAccounts();
            oCusLeadConvController.selectedAccountForOpportunity=ReinggAccount.id;
            oCusLeadConvController.lookup.Account__c = a.id;
             oCusLeadConvController.wrapperIndex='1';
            
             oCusLeadConvController.isContactPage = false;
            oCusLeadConvController.cawList[0].checked = true;
            oCusLeadConvController.cawList[0].isLookup = true;
            oCusLeadConvController.cawList[0].accountObj= a;
            oCusLeadConvController.cawList[0].contactObj=c;
            oCusLeadConvController.cawList[0].isContact =true;
            oCusLeadConvController.firstPageSelectedRecord = oCusLeadConvController.cawList[0];
            oCusLeadConvController.next();
            

            
            
             //System.debug('55555555555555555'+oCusLeadConvController.owList);
            oCusLeadConvController.owList[0].checked =true;
            oCusLeadConvController.owList[0].isNewCreation =true;
            oCusLeadConvController.renderedSection2 = true;
           
           oCusLeadConvController.selectedLevel1 = ccc1.id;
           oCusLeadConvController.oppObj.CurrencyIsoCode = 'USD';
           oCusLeadConvController.oppObj.Name= 'testName';
           oCusLeadConvController.oppObj.OwnerId= u.Id;
           oCusLeadConvController.oppObj.Volume_Year__c ='4';
           oCusLeadConvController.oppProductOBj.IC_Quantity__c = 5;
           oCusLeadConvController.oppProductOBj.Feedback_Notification__c = 'Send';
           oCusLeadConvController.oppObj.Course_Start_Date__c = System.Today(); 
           oCusLeadConvController.leadObj.Anticipated_Enrollment__c =1123; 
           oCusLeadConvController.firstPageSelectedRecord.accountObj = a;
           oCusLeadConvController.oppProductOBj.Order_Type__c ='Desk Copy';
           oCusLeadConvController.ocrObj.Role ='Decision Maker';
           //oCusLeadConvController.oppObj.CurrencyIsoCode = null;
           //oCusLeadConvController.firstPageSelectedRecord.accountObj = ;
           
          
           
           
            if(oCusLeadConvController.product != null){
                oCusLeadConvController.product.Name ='Test Product';
                oCusLeadConvController.product.productCode ='12345678901234';
                upsert oCusLeadConvController.product;
            }else{
                
                oCusLeadConvController.product = p;
            }
            oCusLeadConvController.lookup.Product__c = p.Id;
            
            oCusLeadConvController.OpporIndexPoint='0';
        
            //oCusLeadConvController.pricebookID =  (CasCS__c.getValues('Pricebook_Id') != null) ? CasCS__c.getValues('Pricebook_Id').Value__c : '01s60000000JOCGAA4';
            oCusLeadConvController.copyAddressTo = 'Both';
            oCusLeadConvController.finish();
            Update opp;
       Test.stopTest();
        
        
    }
    
    static testMethod void testFinishRSectionFalse10_Test_2(){
    
        insertCustomSetting();
         //System.debug('000000000000');
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
         p.productCode ='12345678901234';
        update p;
        createAccountContact(u);
        //System.debug('111111111111111111');
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
        Id contactRecordtypeId = MiscFunctions.getRecordtypeId('Contact','T&F - Contacts');
        c = zTEST_Shared.noinsertContact(u.id, a.id);
        c.FirstName = 'test1';
        c.LastName = 'name1';
        c.Email = 'test1@1test.com';
        c.RecordTypeId = contactRecordtypeId;
        insert c;
        
        Campus__c campus = new Campus__c();
        campus.name ='Test';
        campus.Account__c = a.id;
        insert campus;
        
        Campus__c campus2 = new Campus__c();
        campus2.name ='Test2';
        campus2.Account__c = a.id;
        insert campus2;
        
        Campus__c campus3 = new Campus__c();
        campus3.name ='NewCampus';
        campus3.Account__c = a.id;
        insert campus3;
        
        Department__c Dept = new Department__c();
        Dept.Name ='Test';
        Dept.Campus__c =campus.id;
        Dept.Account__c = a.id;
        insert Dept;
        c.Campus__c =campus.id;
        c.Department_Object__c = Dept.id;
        update c;
        
        Department__c Dept2 = new Department__c();
        Dept2.Name ='Test2';
        
        Dept2.Account__c = a.id;
        insert Dept2;
        
         Department__c Dept3 = new Department__c();
        Dept3.Name ='NewDepartment';
        Dept3.Account__c = a.id;
        insert Dept3;
         //System.debug('2222222222222222');
       CAS_Course_Cat1__c ccc1 = new CAS_Course_Cat1__c(Name='cat1');
        insert ccc1;
		
		Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
		
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id); 
        //System.debug('33333333333333333');
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        
         //System.debug('3333333333333b');
        Lead l = new Lead(ownerId=u.Id, company='tCom' ,lastName ='tlastName');
        insert l;
        Test.startTest();
         //System.debug('4444444444444444');
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.showEmailDomainMathes = true;
            oCusLeadConvController.searchContactsAndAccounts();
            oCusLeadConvController.selectedAccountForOpportunity=ReinggAccount.id;
            oCusLeadConvController.lookup.Account__c = a.id;
             oCusLeadConvController.wrapperIndex='1';
            
             oCusLeadConvController.isContactPage = false;
            oCusLeadConvController.cawList[0].checked = true;
            oCusLeadConvController.cawList[0].isLookup = true;
            oCusLeadConvController.cawList[0].accountObj= a;
            oCusLeadConvController.cawList[0].contactObj=c;
            oCusLeadConvController.cawList[0].isContact =true;
            oCusLeadConvController.firstPageSelectedRecord = oCusLeadConvController.cawList[0];
            oCusLeadConvController.next();
            

            
            
             //System.debug('55555555555555555'+oCusLeadConvController.owList);
            oCusLeadConvController.owList[0].checked =true;
            oCusLeadConvController.owList[0].isNewCreation =true;
            //oCusLeadConvController.renderedSection2 = true;
           
           oCusLeadConvController.selectedLevel1 = ccc1.id;
           oCusLeadConvController.oppObj.CurrencyIsoCode = 'USD';
           oCusLeadConvController.oppObj.Name= 'testName';
           oCusLeadConvController.oppObj.OwnerId= u.Id;
           oCusLeadConvController.oppObj.Volume_Year__c ='4';
           oCusLeadConvController.oppProductOBj.IC_Quantity__c = 5;
           oCusLeadConvController.oppProductOBj.Feedback_Notification__c = 'Send';
           oCusLeadConvController.oppObj.Course_Start_Date__c = System.Today(); 
           oCusLeadConvController.leadObj.Anticipated_Enrollment__c =1123; 
           oCusLeadConvController.firstPageSelectedRecord.accountObj = a;
           oCusLeadConvController.oppProductOBj.Order_Type__c ='Desk Copy';
           oCusLeadConvController.ocrObj.Role ='Decision Maker';
           //oCusLeadConvController.oppObj.CurrencyIsoCode = null;
           //oCusLeadConvController.firstPageSelectedRecord.accountObj = ;
           
          
           
           
            if(oCusLeadConvController.product != null){
                oCusLeadConvController.product.Name ='Test Product';
                oCusLeadConvController.product.productCode ='12345678901234';
                upsert oCusLeadConvController.product;
            }else{
                
                oCusLeadConvController.product = p;
            }
            oCusLeadConvController.lookup.Product__c = p.Id;
            
            oCusLeadConvController.OpporIndexPoint='0';
        
            //oCusLeadConvController.pricebookID =  (CasCS__c.getValues('Pricebook_Id') != null) ? CasCS__c.getValues('Pricebook_Id').Value__c : '01s60000000JOCGAA4';
            oCusLeadConvController.copyAddressTo = 'Both';
            oCusLeadConvController.finish();
            oCusLeadConvController.createCampusIdToDepartmentsMap(new Set<Id>{campus.id});
            Map<String,String> ContIddepartIdMap = new Map<String,String>();
            ContIddepartIdMap.put(c.id,Dept.id);
            ContIddepartIdMap.put(c.id,Dept2.id);
            ContIddepartIdMap.put(c.id,Dept3.id);
            oCusLeadConvController.createContactToCampus(ContIddepartIdMap);
           
            
       Test.stopTest();
        
        
    }
    
    static testMethod void testFinishRSectionFalse10_Test_3(){
    
        insertCustomSetting2();
         //System.debug('000000000000');
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
         p.productCode ='12345678901234';
        update p;
        createAccountContact(u);
        //System.debug('111111111111111111');
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
        Id contactRecordtypeId = MiscFunctions.getRecordtypeId('Contact','T&F - Contacts');
        c = zTEST_Shared.noinsertContact(u.id, a.id);
        c.FirstName = 'test1';
        c.LastName = 'name1';
        c.Email = 'test1@1test.com';
        c.RecordTypeId = contactRecordtypeId;
        insert c;
        
        Campus__c campus = new Campus__c();
        campus.name ='Test';
        campus.Account__c = a.id;
        insert campus;
        
        Campus__c campus2 = new Campus__c();
        campus2.name ='Test2';
        campus2.Account__c = a.id;
        insert campus2;
        
        Campus__c campus3 = new Campus__c();
        campus3.name ='NewCampus';
        campus3.Account__c = a.id;
        insert campus3;
        
        Department__c Dept = new Department__c();
        Dept.Name ='Test';
        Dept.Campus__c =campus.id;
        Dept.Account__c = a.id;
        insert Dept;
        c.Campus__c =campus.id;
        c.Department_Object__c = Dept.id;
        update c;
        
        Department__c Dept2 = new Department__c();
        Dept2.Name ='Test2';
        
        Dept2.Account__c = a.id;
        insert Dept2;
        
        Department__c Dept3 = new Department__c();
        Dept3.Name ='NewDepartment';
        Dept3.Account__c = a.id;
        insert Dept3;
         //System.debug('2222222222222222');
       CAS_Course_Cat1__c ccc1 = new CAS_Course_Cat1__c(Name='cat1');
        insert ccc1;
		
		Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
		
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id); 
        //System.debug('33333333333333333');
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        
         //System.debug('3333333333333b');
        Lead l = new Lead(ownerId=u.Id, company='tCom' ,lastName ='tlastName');
        insert l;
        Test.startTest();
         //System.debug('4444444444444444');
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.showEmailDomainMathes = true;
            oCusLeadConvController.searchContactsAndAccounts();
            oCusLeadConvController.selectedAccountForOpportunity=ReinggAccount.id;
            oCusLeadConvController.lookup.Account__c = a.id;
             oCusLeadConvController.wrapperIndex='1';
            
             oCusLeadConvController.isContactPage = false;
            oCusLeadConvController.cawList[0].checked = true;
            oCusLeadConvController.cawList[0].isLookup = true;
            oCusLeadConvController.cawList[0].accountObj= a;
            oCusLeadConvController.cawList[0].contactObj=c;
            oCusLeadConvController.cawList[0].isContact =true;
            oCusLeadConvController.firstPageSelectedRecord = oCusLeadConvController.cawList[0];
            oCusLeadConvController.next();
            

            
            
             //System.debug('55555555555555555'+oCusLeadConvController.owList);
            oCusLeadConvController.owList[0].checked =true;
            oCusLeadConvController.owList[0].isNewCreation =true;
            //oCusLeadConvController.renderedSection2 = true;
           
           oCusLeadConvController.selectedLevel1 = ccc1.id;
           oCusLeadConvController.oppObj.CurrencyIsoCode = 'USD';
           oCusLeadConvController.oppObj.Name= 'testName';
           oCusLeadConvController.oppObj.OwnerId= u.Id;
           oCusLeadConvController.oppObj.Volume_Year__c ='4';
           oCusLeadConvController.oppProductOBj.IC_Quantity__c = 5;
           oCusLeadConvController.oppProductOBj.Feedback_Notification__c = 'Send';
           oCusLeadConvController.oppObj.Course_Start_Date__c = System.Today(); 
           oCusLeadConvController.leadObj.Anticipated_Enrollment__c =1123; 
           oCusLeadConvController.firstPageSelectedRecord.accountObj = a;
           oCusLeadConvController.oppProductOBj.Order_Type__c ='Desk Copy';
           oCusLeadConvController.ocrObj.Role ='Decision Maker';
           //oCusLeadConvController.oppObj.CurrencyIsoCode = null;
           //oCusLeadConvController.firstPageSelectedRecord.accountObj = ;
           
          
           
           
            if(oCusLeadConvController.product != null){
                oCusLeadConvController.product.Name ='Test Product';
                oCusLeadConvController.product.productCode ='12345678901234';
                upsert oCusLeadConvController.product;
            }else{
                
                oCusLeadConvController.product = p;
            }
            oCusLeadConvController.lookup.Product__c = p.Id;
            
            oCusLeadConvController.OpporIndexPoint='0';
        
            //oCusLeadConvController.pricebookID =  (CasCS__c.getValues('Pricebook_Id') != null) ? CasCS__c.getValues('Pricebook_Id').Value__c : '01s60000000JOCGAA4';
            oCusLeadConvController.copyAddressTo = 'Both';
            oCusLeadConvController.finish();
           Update opp;
       Test.stopTest();
        
        
    }
    
    static testMethod void testFinishRSectionFalse10_Test_4(){
    
        insertCustomSetting2();
         //System.debug('000000000000');
        User u = zTEST_Shared.insertUser();
        Product2 p = getProduct();
         p.productCode ='12345678901234';
        update p;
        createAccountContact(u);
        //System.debug('111111111111111111');
        Account a = new Account();
        a.Name = 'TestName id23';
        a.Type = 'Customer';
        a.OwnerId = u.Id;
        a.RecordTypeId = CasCS__c.getValues('Account_RT_Id').Value__c;
        a.Ringgold_Account_ID__c='RGID0010';
        insert a;
        Id contactRecordtypeId = MiscFunctions.getRecordtypeId('Contact','T&F - Contacts');
        c = zTEST_Shared.noinsertContact(u.id, a.id);
        c.FirstName = 'test1';
        c.LastName = 'name1';
        c.Email = 'test1@1test.com';
        c.RecordTypeId = contactRecordtypeId;
        insert c;
        
        Campus__c campus = new Campus__c();
        campus.name ='Test';
        campus.Account__c = a.id;
        insert campus;
        
        Campus__c campus2 = new Campus__c();
        campus2.name ='Test2';
        campus2.Account__c = a.id;
        insert campus2;
        
        Campus__c campus3 = new Campus__c();
        campus3.name ='NewCampus';
        campus3.Account__c = a.id;
        insert campus3;
        
        Department__c Dept = new Department__c();
        Dept.Name ='Test';
        Dept.Campus__c =campus.id;
        Dept.Account__c = a.id;
        insert Dept;
        c.Campus__c =campus.id;
        c.Department_Object__c = Dept.id;
        update c;
        
        Department__c Dept2 = new Department__c();
        Dept2.Name ='Test2';
        
        Dept2.Account__c = a.id;
        insert Dept2;
        
        Department__c Dept3 = new Department__c();
        Dept3.Name ='NewDepartment';
        Dept3.Account__c = a.id;
        insert Dept3;
         //System.debug('2222222222222222');
       CAS_Course_Cat1__c ccc1 = new CAS_Course_Cat1__c(Name='cat1');
        insert ccc1;
		
		Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
		
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id); 
        //System.debug('33333333333333333');
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        
         //System.debug('3333333333333b');
        Lead l = new Lead(ownerId=u.Id, company='tCom' ,lastName ='tlastName');
        insert l;
        Test.startTest();
         //System.debug('4444444444444444');
            ApexPages.currentPage().getParameters().put('id',l.id);
            CustomLeadConversionTF2Controller oCusLeadConvController = new CustomLeadConversionTF2Controller(new ApexPages.StandardController(l));
            oCusLeadConvController.showEmailDomainMathes = true;
            oCusLeadConvController.searchContactsAndAccounts();
            oCusLeadConvController.selectedAccountForOpportunity=ReinggAccount.id;
            oCusLeadConvController.lookup.Account__c = a.id;
             oCusLeadConvController.wrapperIndex='1';
            
             oCusLeadConvController.isContactPage = false;
            oCusLeadConvController.cawList[0].checked = true;
            oCusLeadConvController.cawList[0].isLookup = true;
            oCusLeadConvController.cawList[0].accountObj= a;
            oCusLeadConvController.cawList[0].contactObj=c;
            oCusLeadConvController.cawList[0].isContact =true;
            oCusLeadConvController.firstPageSelectedRecord = oCusLeadConvController.cawList[0];
            oCusLeadConvController.next();
            

            
            
             //System.debug('55555555555555555'+oCusLeadConvController.owList);
            oCusLeadConvController.owList[0].checked =true;
            oCusLeadConvController.owList[0].isNewCreation =true;
            //oCusLeadConvController.renderedSection2 = true;
           
           oCusLeadConvController.selectedLevel1 = ccc1.id;
           oCusLeadConvController.oppObj.CurrencyIsoCode = 'USD';
           oCusLeadConvController.oppObj.Name= 'testName';
           oCusLeadConvController.oppObj.OwnerId= u.Id;
           oCusLeadConvController.oppObj.Volume_Year__c ='4';
           oCusLeadConvController.oppProductOBj.IC_Quantity__c = 5;
           oCusLeadConvController.oppProductOBj.Feedback_Notification__c = 'Send';
           oCusLeadConvController.oppObj.Course_Start_Date__c = System.Today(); 
           oCusLeadConvController.leadObj.Anticipated_Enrollment__c =1123; 
           oCusLeadConvController.firstPageSelectedRecord.accountObj = a;
           oCusLeadConvController.oppProductOBj.Order_Type__c ='Desk Copy';
           oCusLeadConvController.ocrObj.Role ='Decision Maker';
           //oCusLeadConvController.oppObj.CurrencyIsoCode = null;
           //oCusLeadConvController.firstPageSelectedRecord.accountObj = ;
           
          oCusLeadConvController.NextContactAccount();
        oCusLeadConvController.getTotalPagesContactAccount();
        oCusLeadConvController.getDisablePreviousContactAccount();
        oCusLeadConvController.getDisableNextContactAccount();
           
           
            if(oCusLeadConvController.product != null){
                oCusLeadConvController.product.Name ='Test Product';
                oCusLeadConvController.product.productCode ='12345678901234';
                upsert oCusLeadConvController.product;
            }else{
                
                oCusLeadConvController.product = p;
            }
            oCusLeadConvController.lookup.Product__c = p.Id;
            
            oCusLeadConvController.OpporIndexPoint='0';
        
            //oCusLeadConvController.pricebookID =  (CasCS__c.getValues('Pricebook_Id') != null) ? CasCS__c.getValues('Pricebook_Id').Value__c : '01s60000000JOCGAA4';
            oCusLeadConvController.copyAddressTo = 'Both';
            oCusLeadConvController.NextOpp();
            oCusLeadConvController.getPageNumber();
            oCusLeadConvController.getDisablePrevious();
            oCusLeadConvController.getDisableNext();
            oCusLeadConvController.getTotalPages();
            
            oCusLeadConvController.closedPopup_ProductCancel();
            oCusLeadConvController.closedPopup_ProductContinue();
            oCusLeadConvController.closePopup_Cancel();
            oCusLeadConvController.closePopup_Continue();
          
            Update opp;
       Test.stopTest();
        
        
    }
    
}