/*
Created by Amit
Updated on 07/June/2018
Test class for TFAutoLeadConvert_Trig
*/
@isTest
private class zTEST_TF_LeadConvertHandler {
    
    static Account accRec;
    static Contact conRec;
    static Contact conRec2;
    static Contact conRec3;
    static Opportunity oppRec;
    static Opportunity oppRec2;
    static Opportunity oppRec3;
    static Product2 prod;
    static Product2 prod2;
    static Product2 prod3;
    static PricebookEntry customPrice;
    static void setup()
    {
        
        //insert Account record
        Schema.DescribeSObjectResult accSchema = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> accountRecordTypeInfo = accSchema.getRecordTypeInfosByName(); 
        Id rtId = accountRecordTypeInfo.get('T&F - Accounts').getRecordTypeId();
        accRec = new Account();
        accRec.RecordTypeId = rtId;
        accRec.Name = 'T&F SLA Account';
        accRec.Phone = '123456789';
        accRec.Type = 'Other';
        accRec.Classification__c = 'Institution';
        accRec.Mailing_Country_List__c = 'United Kingdom';
        accRec.Locale__c = 'Europe';
        accRec.Sales_Region__c = 'Europe';
        accRec.HE_Sales_Territory__c = 'North & Scotland';
        insert accRec;
        
        //insert Department
        Department__c department = new Department__c();
        department.Name = 'testDepartment';
        department.Account__c = accRec.Id;
        insert department;
        
        //insert Course Category
        CAS_Course_Cat1__c courseCat = new CAS_Course_Cat1__c();
        courseCat.Name = 'Architecture';
        insert courseCat; 
        CAS_Course_Cat1__c courseCat2 = new CAS_Course_Cat1__c();
        courseCat2.Name = 'ESI Books';
        insert courseCat2; 
        
        
        //insert Contact record
        Schema.DescribeSObjectResult conSchema = Schema.SObjectType.Contact; 
        Map<String,Schema.RecordTypeInfo> contactRecordTypeInfo = conSchema.getRecordTypeInfosByName(); 
        Id conrtId = contactRecordTypeInfo.get('T&F - Contacts').getRecordTypeId();
        conRec = new Contact();
        conRec.FirstName = 'first';
        conRec.LastName = 'last';
        conRec.RecordTypeId = conrtId;
        conRec.AccountId = accRec.Id;
        conRec.Email = 'test@test.com';
        conRec.Mailing_Country_List__c = 'United Kingdom';
        conRec.Business__c = 'CAS';
        insert conRec;
        
        //insert Contact record
        conRec2 = new Contact();
        conRec2.FirstName = 'first2';
        conRec2.LastName = 'last2';
        conRec2.RecordTypeId = conrtId;
        conRec2.AccountId = accRec.Id;
        conRec2.Email = 'test2@test.com';
        conRec2.Mailing_Country_List__c = 'United Kingdom';
        conRec2.Business__c = 'CAS';
        insert conRec2;
        
        //insert Contact record
        conRec3 = new Contact();
        conRec3.FirstName = 'first3';
        conRec3.LastName = 'last3';
        conRec3.RecordTypeId = conrtId;
        conRec3.AccountId = accRec.Id;
        conRec3.Email = 'test3@test.com';
        conRec3.Mailing_Country_List__c = 'United Kingdom';
        conRec3.Business__c = 'CAS';
        insert conRec3;
        
        //insert Contact record
        Id contactRTId = contactRecordTypeInfo.get('T&F - OAC Contacts').getRecordTypeId();
        Contact conRec4 = new Contact();
        conRec4.FirstName = 'first4';
        conRec4.LastName = 'last4';
        //conRec4.RecordTypeId = contactRTId;
        conRec4.RecordTypeId = conrtId;
        conRec4.AccountId = accRec.Id;
        conRec4.Email = 'test4@test.com';
        conRec4.Mailing_Country_List__c = 'United Kingdom';
        conRec4.Business__c = 'CAS';
        insert conRec4;
        
        
        //insert Opportunity record
        Schema.DescribeSObjectResult oppSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> oppRecordTypeInfo = oppSchema.getRecordTypeInfosByName(); 
        Id opprtId = oppRecordTypeInfo.get('T&F - CAS Opportunity').getRecordTypeId();
        oppRec = new Opportunity();
        oppRec.RecordTypeId = opprtId;
        oppRec.Name = 'testOpp';
        oppRec.AccountId = accRec.Id;
        oppRec.CloseDate = system.today()+1;
        oppRec.StageName = 'Investigating';
        oppRec.Course_Start_Date__c = system.today();
        oppRec.CurrencyIsoCode = 'GBP';
        oppRec.ReVisit_Date__c = Date.today();
        insert oppRec;
        
        oppRec2 = new Opportunity();
        oppRec2.RecordTypeId = opprtId;
        oppRec2.Name = 'testOpp2';
        oppRec2.AccountId = accRec.Id;
        oppRec2.CloseDate = system.today()+10;
        oppRec2.StageName = 'Closed';
        oppRec2.Course_Start_Date__c = system.today()+5;
        oppRec2.CurrencyIsoCode = 'GBP';
        oppRec2.ReVisit_Date__c = Date.today()+10;
        insert oppRec2;
        
        oppRec3 = new Opportunity();
        oppRec3.RecordTypeId = opprtId;
        oppRec3.Name = 'testOpp';
        oppRec3.AccountId = accRec.Id;
        oppRec3.CloseDate = system.today()+1;
        oppRec3.StageName = 'Prospect';
        oppRec3.Course_Start_Date__c = system.today()-1;
        oppRec3.CurrencyIsoCode = 'GBP';
        oppRec3.ReVisit_Date__c = Date.today()+5;
        insert oppRec3;
        
        Opportunity oppRec4 = new Opportunity();
        oppRec4.RecordTypeId = opprtId;
        oppRec4.Name = 'testOpp4';
        oppRec4.AccountId = accRec.Id;
        oppRec4.CloseDate = system.today()+1;
        oppRec4.StageName = 'Prospect';
        oppRec4.Course_Start_Date__c = system.today()+2;
        oppRec4.CurrencyIsoCode = 'GBP';
        oppRec4.ReVisit_Date__c = Date.today()+15;
        insert oppRec4;
        
        //insert OpportunityContactRole record
        OpportunityContactRole ocr = zTEST_Shared.insertOpportunityContactRole( oppRec.id, conRec.id, 'Decision Maker' );
        OpportunityContactRole ocr2 = zTEST_Shared.insertOpportunityContactRole( oppRec2.id, conRec2.id, 'Decision Maker' );
        OpportunityContactRole ocr3 = zTEST_Shared.insertOpportunityContactRole( oppRec3.id, conRec3.id, 'Decision Maker' );
        OpportunityContactRole ocr4 = new OpportunityContactRole();
        ocr4.OpportunityId = oppRec3.id;
        ocr4.ContactId = conRec4.id;
        ocr4.role = 'Decision Maker';
        insert ocr4;
        
        Pricebook2 customPB = new Pricebook2(Name='T&F Pricebook', isActive=true);
        insert customPB;
        
        //insert CasCS__c custom setting value
        List<CasCS__c> casList = new List<CasCS__c>();
        CasCS__c casCS = new CasCS__c();
        casCS.Name = 'Pricebook_Id';
        casCS.Description__c = 'testDesc';
        casCS.Value__c = customPB.Id + ',';
        casList.add(casCS);
        
        CasCS__c casCS1 = new CasCS__c();
        casCS1.Name = 'opbs1';
        casCS1.Description__c = 'testOppRecId';
        casCS1.Value__c = opprtId;
        casList.add(casCS1);
        
        insert casList;
        
        //insert Product
        prod = new Product2();
        prod.Name = 'testProd';
        prod.Business_Division__c = 'Architecture';
        prod.isActive = true;
        prod.Text_Type__c = 'Textbook (Standard) (DRM-Free)';
        insert prod;
        prod2 = new Product2();
        prod2.Name = 'testProd2';
        prod2.isActive = true;
        prod2.Business_Division__c = 'ESI Books';
        prod2.UK_Inventory_Status__c = 'Available';
        prod2.Text_Type__c = 'Textbook (Standard) (DRM-Free)';
        insert prod2;
        prod3 = new Product2();
        prod3.Name = 'testProd3';
        prod3.isActive = true;
        prod3.Business_Division__c = 'ESI Books';
        prod3.Text_Type__c = 'Textbook (Standard) (DRM-Free)';
        prod3.UK_Inventory_Status__c = 'Contracted';
        insert prod3;
        
        //insert Price Book entry record
        PricebookEntry standardPbe = new PricebookEntry(Pricebook2Id=Test.getStandardPricebookId(), Product2Id=prod2.id, UnitPrice=1.00, IsActive=true, UseStandardPrice=false, CurrencyIsoCode='GBP');
        insert standardPbe;
        PricebookEntry standardPbe2 = new PricebookEntry(Pricebook2Id=Test.getStandardPricebookId(), Product2Id=prod3.id, UnitPrice=1.00, IsActive=true, UseStandardPrice=false, CurrencyIsoCode='GBP');
        insert standardPbe2;
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=customPB.id, Product2Id=prod2.id, UnitPrice=1.00, IsActive=true, UseStandardPrice=false, CurrencyIsoCode='GBP');
        insert pbe;
        PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id=customPB.id, Product2Id=prod3.id, UnitPrice=1.00, IsActive=true, UseStandardPrice=false, CurrencyIsoCode='GBP');
        insert pbe2;
        
        //insert Opportunity Line item record
        OpportunityLineItem oli2 = new OpportunityLineItem();
        oli2.Quantity = 1;
        oli2.TotalPrice = 1;
        oli2.PricebookEntryId = pbe.id;
        oli2.OpportunityId = oppRec2.id;
        oli2.IsTesting__c = True;
        insert oli2;
        List<OpportunityLineItem> oppItemsList = new List<OpportunityLineItem>();
        for ( integer i = 0; i < 20; i++ ) {
            OpportunityLineItem oli3 = new OpportunityLineItem();
            oli3.Quantity = 1;
            oli3.TotalPrice = 1;
            oli3.PricebookEntryId = pbe.id;
            oli3.OpportunityId = oppRec3.id;
            oli3.IsTesting__c = True;
            oli3.Adoption_Stage__c = '';
            oppItemsList.add( oli3 );
        }
        
        insert oppItemsList;
        
        OpportunityLineItem oli4 = new OpportunityLineItem();
        oli4.Quantity = 1;
        oli4.TotalPrice = 1;
        oli4.PricebookEntryId = pbe2.id;
        oli4.OpportunityId = oppRec4.id;
        oli4.IsTesting__c = True;
        insert oli4;
        
        //insert PriceBookEntry for the Product
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true , CurrencyIsoCode = 'GBP');
        insert standardPrice;
        
        customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = prod.Id,
            UnitPrice = 12000, IsActive = true , CurrencyIsoCode = 'GBP');
        insert customPrice;
        
        //insert oli record
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.Quantity = 1;
        oli.TotalPrice = 1;
        oli.PricebookEntryId = customPrice.id;
        oli.OpportunityId = oppRec.id;
        oli.IsTesting__c = True;
        insert oli;
        
        //insert custom Allowed Country setting data
        TF_LeadConvert_Countries__c allowedCountry = new TF_LeadConvert_Countries__c();
        allowedCountry.Name = 'United Kingdom';
        allowedCountry.Price_GBP__c=integer.valueOf('2');
        allowedCountry.Anticipated_Enrollment__c=integer.valueOf('5');
        insert allowedCountry;
        
        //insert custom setting
        T_F_Lead_Source_Webform_Mapping__c tfS = new T_F_Lead_Source_Webform_Mapping__c();
        tfS.IsMappingOn__c = true;
        insert tfS;      
    }
    
    static testmethod void testLeadConvert()
    {
        setup();
        // insert BusinessDivision_CourseCategory__c custom setting
        BusinessDivision_CourseCategory__c divCat = new BusinessDivision_CourseCategory__c();
        divCat.Name = 'Architecture';
        divCat.Business_Division__c = 'Architecture';
        divCat.Course_Category__c = 'Architecture';
        insert divCat;
        BusinessDivision_CourseCategory__c divCat2 = new BusinessDivision_CourseCategory__c();
        divCat2.Name = 'ESI Books';
        divCat2.Business_Division__c = 'ESI Books';
        divCat2.Course_Category__c = 'ESI Books';
        insert divCat2;
        test.startTest();
        
        Opportunity_Owner_Mapping__c oppOwner = new Opportunity_Owner_Mapping__c();
        oppOwner.Name = 'North & Scotland';
        oppOwner.HE_Sales_Territory__c = 'North & Scotland';
        oppOwner.Sales_Rep__c = UserInfo.getUserId();
        insert oppOwner;
        //insert Lead Record
        Schema.DescribeSObjectResult leadSchema = Schema.SObjectType.Lead; 
        Map<String,Schema.RecordTypeInfo> leadRecordTypeInfo = leadSchema.getRecordTypeInfosByName(); 
        Id leadrtId = leadRecordTypeInfo.get('T&F - Leads').getRecordTypeId();
        
        TriggerInterfaceHelper.runTrigger('TFAutoLeadConvert_Trig', 'Lead', 99, 'ai', leadrtId, null);
             //    String testLbl = system.Label.T_F_Lead_Source_Webform_Mapping;

       // TriggerInterfaceHelper.runTrigger('TF_SplitLeadSource', 'Lead', 99, 'ai', leadrtId, testLbl);

        
        Lead leadRec = new Lead();
        leadRec.RecordTypeId = leadrtId;
        leadRec.Company = accRec.Name;
        leadRec.Email = 'test@test.com';
        leadRec.FirstName = 'first';
        leadRec.LastName = 'last';
        leadRec.Department__c = 'testDepartment';
        leadRec.LeadSource = 'Advertisement';
        leadRec.Country_List__c = 'United Kingdom';
        leadRec.Business__c = 'CAS';
        leadRec.Product_Name__c = prod.id;
        leadRec.Anticipated_Enrollment__c=10;
        leadRec.Course_Name__c='testOpp';
        leadRec.Price_GBP__c = 1;
        leadRec.Course_Start_Date__c = system.today()+1;
        insert leadRec;
        if(conRec!=null){
            delete oppRec;
            Lead leadRecd = new Lead();
        leadRecd.RecordTypeId = leadrtId;
        leadRecd.Company = accRec.Name;
        leadRecd.Email = 'test@test.com';
        leadRecd.FirstName = 'first';
        leadRecd.LastName = 'last';
        leadRecd.Department__c = 'testDepartment';
        leadRecd.LeadSource = 'Advertisement';
        leadRecd.Country_List__c = 'United Kingdom';
        leadRecd.Business__c = 'CAS';
        leadRecd.Product_Name__c = prod.id;
        leadRecd.Anticipated_Enrollment__c=10;
        leadRecd.Price_GBP__c = 1;
        leadRecd.Course_Start_Date__c = system.today()+1;
        insert leadRecd;
        }
        Lead leadRec2 = new Lead();
        leadRec2.RecordTypeId = leadrtId;
        leadRec2.Company = accRec.Name;
        leadRec2.Email = 'test2@test.com';
        leadRec2.FirstName = 'first2';
        leadRec2.LastName = 'last2';
        leadRec2.Department__c = 'testDepartment';
        leadRec2.LeadSource = 'Customer Interaction::Conference';
        leadRec2.Country_List__c = 'United Kingdom';
        leadRec2.Business__c = 'CAS';
        leadRec2.Product_Name__c = prod2.id;
        leadRec2.Price_GBP__c = 200;
        leadRec2.Course_Name__c = 'eBooks';
        leadRec2.Course_Start_Date__c = system.today()+1;
        leadRec2.Anticipated_Enrollment__c = 50;
        insert leadRec2;
        if(conRec2!=null){
            delete oppRec2;
        oppRec2 = new Opportunity();
        oppRec2.Name = 'testOpp2';
        oppRec2.AccountId = accRec.Id;
        oppRec2.CloseDate = system.today()+10;
        oppRec2.StageName = 'Closed';
        oppRec2.Course_Start_Date__c = system.today()+5;
        oppRec2.CurrencyIsoCode = 'GBP';
        oppRec2.ReVisit_Date__c = Date.today()+10;
        insert oppRec2;
            Lead leadRecd2 = new Lead();
        leadRecd2.RecordTypeId = leadrtId;
        leadRecd2.Course_Name__c='testOpp';
        leadRecd2.Company = accRec.Name;
        leadRecd2.Email = 'test2@test.com';
        leadRecd2.FirstName = 'first';
        leadRecd2.LastName = 'last';
        leadRecd2.Department__c = 'testDepartment';
        leadRecd2.LeadSource = 'Advertisement';
        leadRecd2.Country_List__c = 'United Kingdom';
        leadRecd2.Business__c = 'CAS';
        leadRecd2.Product_Name__c = prod.id;
        leadRecd2.Anticipated_Enrollment__c=10;
        leadRecd2.Price_GBP__c = 1;
        leadRecd2.Course_Start_Date__c = system.today()+1;
        insert leadRecd2;
        }
        Lead leadRec3 = new Lead();
        leadRec3.RecordTypeId = leadrtId;
        leadRec3.Company = accRec.Name;
        leadRec3.Email = 'test3@test.com';
        leadRec3.FirstName = 'first3';
        leadRec3.LastName = 'last3';
        leadRec3.Department__c = 'testDepartment';
        leadRec3.LeadSource = 'Advertisement';
        leadRec3.Country_List__c = 'United Kingdom';
        leadRec3.Business__c = 'CAS';
        leadRec3.Product_Name__c = prod2.id;
        leadRec3.Price_GBP__c = 1;
        leadRec3.Book_Requested_Type__c = 'eBook';
        leadRec3.Course_Name__c = 'eBooks';
        leadRec3.Course_Start_Date__c = system.today()+1;
        leadRec3.Anticipated_Enrollment__c = 10;
        insert leadRec3;
        system.debug('Hey I am here too');
        if(conRec3!=null){
          //  delete oppRec3;
        oppRec3 = new Opportunity();
        oppRec3.Name = 'testOpp3';
        oppRec3.AccountId = accRec.Id;
        oppRec3.CloseDate = system.today()+10;
        oppRec3.StageName = 'Closed';
        oppRec3.Course_Start_Date__c = system.today()+5;
        oppRec3.CurrencyIsoCode = 'GBP';
        oppRec3.ReVisit_Date__c = Date.today()+10;
        insert oppRec3;
        Lead leadRecd3 = new Lead();
        leadRecd3.RecordTypeId = leadrtId;
        leadRecd3.Course_Name__c='testOpp';
        leadRecd3.Company = accRec.Name;
        leadRecd3.Email = 'test3@test.com';
        leadRecd3.FirstName = 'first';
        leadRecd3.LastName = 'last';
        leadRecd3.Department__c = 'testDepartment';
        leadRecd3.LeadSource = 'Advertisement';
        leadRecd3.Country_List__c = 'United Kingdom';
        leadRecd3.Business__c = 'CAS';
        leadRecd3.Product_Name__c = prod.id;
        leadRecd3.Anticipated_Enrollment__c=10;
        leadRecd3.Price_GBP__c = 1;
        leadRecd3.Course_Start_Date__c = system.today()-1;
        insert leadRecd3;
            system.debug('leadRecd3'+leadRecd3.Course_Start_Date__c);
        }
       Lead leadRec4 = new Lead();
        leadRec4.RecordTypeId = leadrtId;
        leadRec4.Company = accRec.Name;
        leadRec4.Email = 'test4@test.com';
        leadRec4.FirstName = 'first4';
        leadRec4.LastName = 'last4';
        leadRec4.Department__c = 'testDepartment';
        leadRec4.LeadSource = 'Advertisement';
        leadRec4.Country_List__c = 'United Kingdom';
        leadRec4.Business__c = 'Journals';
        leadRec4.Product_Name__c = prod3.id;
        leadRec4.Price_GBP__c = 10;
        leadRec4.Book_Requested_Type__c = 'eBook';
        leadRec4.Course_Name__c = 'eBooks';
        leadRec4.LeadSource='test::';
        leadRec4.Course_Start_Date__c = system.today()+1;
        leadRec4.Anticipated_Enrollment__c = 100;
        insert leadRec4;
        system.debug('$$$$'+leadRec4.Text_Type__c);
        Lead leadupdate = new Lead( id = leadRec.id, Book_Requested_Type__c = 'e-Inspection Copy' );
        update leadupdate;
        
        Lead leadupdate2 = new Lead( id = leadRec2.id, Book_Requested_Type__c = 'Print' );
        update leadupdate2;
        
        test.stopTest();
        
    }
    
    static testmethod void testLeadForExistingOpportunity()
    {
        setup();
        // insert BusinessDivision_CourseCategory__c custom setting
        BusinessDivision_CourseCategory__c divCat = new BusinessDivision_CourseCategory__c();
        divCat.Name = 'Architecture';
        divCat.Business_Division__c = 'Architecture';
        divCat.Course_Category__c = 'Architecture';
        insert divCat;
        test.startTest();
        
        // add the requested product to the Opportunity
        OpportunityLineItem lineItem = new OpportunityLineItem();
        lineItem.OpportunityId = oppRec.Id;
        lineItem.PricebookEntryId = customPrice.id;
        lineItem.UnitPrice = customPrice.UnitPrice;
        lineItem.Quantity = 1;
        lineItem.IC_Quantity__c = 1;
        lineItem.Feedback_Notification__c = 'Send';//'Do Not Send';
        insert lineItem;
        
        OpportunityContactRole contactRole = new OpportunityContactRole();
        contactRole.ContactId = conRec.Id;
        contactRole.IsPrimary = true;
        contactRole.OpportunityId = oppRec.Id;
        contactRole.Role = 'Decision Maker';
        insert contactRole;
        
        Opportunity_Owner_Mapping__c oppOwner = new Opportunity_Owner_Mapping__c();
        oppOwner.Name = 'North & Scotland';
        oppOwner.HE_Sales_Territory__c = 'North & Scotland';
        oppOwner.Sales_Rep__c = '00560000001sJrXAAU';
        insert oppOwner;
        //insert Lead Record
        Schema.DescribeSObjectResult leadSchema = Schema.SObjectType.Lead; 
        Map<String,Schema.RecordTypeInfo> leadRecordTypeInfo = leadSchema.getRecordTypeInfosByName(); 
        Id leadrtId = leadRecordTypeInfo.get('T&F - Leads').getRecordTypeId();
        
        TriggerInterfaceHelper.runTrigger('TFAutoLeadConvert_Trig', 'Lead', 99, 'ai', leadrtId, null);
        
        Lead leadRec = new Lead();
        leadRec.RecordTypeId = leadrtId;
        leadRec.Company = accRec.Name;
        leadRec.Email = 'test@test.com';
        leadRec.FirstName = 'first';
        leadRec.LastName = 'last';
        leadRec.Department__c = 'testDepartment';
        leadRec.LeadSource = 'Advertisement';
        leadRec.Country_List__c = 'United Kingdom';
        leadRec.Business__c = 'CAS';
        leadRec.Course_Start_Date__c = system.today();
        insert leadRec;
        Opportunity Opp = new Opportunity();
        opp = [Select Id, (Select Id From OpportunityLineItems) From Opportunity where Id =: oppRec.Id];
        system.assert(opp.OpportunityLineItems.size()>0);
        test.stopTest();
        
    }
    
    static testmethod void testforOpp()
    {
        setup();
        // insert BusinessDivision_CourseCategory__c custom setting
        BusinessDivision_CourseCategory__c divCat = new BusinessDivision_CourseCategory__c();
        divCat.Name = 'Architecture';
        divCat.Business_Division__c = 'Architecture';
        divCat.Course_Category__c = 'Architecture';
        insert divCat;
        test.startTest();
        
        //insert Opportunity record
        Schema.DescribeSObjectResult oppSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> oppRecordTypeInfo = oppSchema.getRecordTypeInfosByName(); 
        Id opprtId = oppRecordTypeInfo.get('T&F - CAS Opportunity').getRecordTypeId();
        oppRec = new Opportunity();
        oppRec.RecordTypeId = opprtId;
        oppRec.Name = 'testOpp1';
        oppRec.AccountId = accRec.Id;
        oppRec.CloseDate = system.today()+10;
        oppRec.StageName = 'Investigating';
        oppRec.Course_Start_Date__c = system.today();
        oppRec.CurrencyIsoCode = 'GBP';
        oppRec.ReVisit_Date__c = Date.today();
        insert oppRec;
        
        //insert Lead Record
        Schema.DescribeSObjectResult leadSchema = Schema.SObjectType.Lead; 
        Map<String,Schema.RecordTypeInfo> leadRecordTypeInfo = leadSchema.getRecordTypeInfosByName(); 
        Id leadrtId = leadRecordTypeInfo.get('T&F - Leads').getRecordTypeId();
        
        TriggerInterfaceHelper.runTrigger('TFAutoLeadConvert_Trig', 'Lead', 99, 'ai,bi', leadrtId, null);
        
        Lead leadRec = new Lead();
        leadRec.RecordTypeId = leadrtId;
        leadRec.Company = accRec.Name;
        leadRec.Email = 'test@test.com';
        leadRec.FirstName = 'first';
        leadRec.LastName = 'last';
        leadRec.Department__c = 'testDepartment';
        leadRec.LeadSource = 'Direct::Bespoke email campaign';
        leadRec.Country_List__c = 'United Kingdom';
        leadRec.Business__c = 'CAS';

        leadRec.Course_Start_Date__c = system.today();
        //insert leadRec;
        
        TriggerInterfaceHelper.runTrigger('TF_SplitLeadSource', 'Lead', 99, 'ai,bi', leadrtId, null);
        
        Lead leadRec1 = new Lead();
        leadRec1.RecordTypeId = leadrtId;
        leadRec1.Company = accRec.Name;
        leadRec1.Email = 'test4@test4.com';
        leadRec1.FirstName = 'first';
        leadRec1.LastName = 'last';
        leadRec1.Department__c = 'testDepartment';
        leadRec1.LeadSource = 'Direct::Bespoke email campaign';
        leadRec1.Country_List__c = 'United Kingdom';
        leadRec1.Business__c = 'CAS';
        leadRec1.Anticipated_Enrollment__c = 10;
        leadRec1.Course_Start_Date__c = system.today();
        //insert leadRec1;
        test.stopTest();
    }
    
    
}