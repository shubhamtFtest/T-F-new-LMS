/**************************************************
* Created by Jeff Douglas
* jeff.douglas@informausa.com / 941-554-3584
* Test methods for various triggers
* Modified by Hailey Niemand - 2017.01.26 - CHG0031794
**************************************************/

@isTest
private class Tests_Triggers {
    
    /**********************************************************************
    * START TEST FOR (CAS) LeadConvert trigger 
    **********************************************************************/     
    public static testMethod void testCasLeadConvert() {
        
        Id leadRtId = MiscFunctions.getRecordtypeId('Lead', 'T&F - Leads'); //CHG0038379
        
        Lead lead = new Lead(
            firstName='Jeff',
            lastName='Test Lead',
            company='Jeff Test Company',
            course_name__c = 'My Course Name',
            recordtypeid=leadRtId,
            Country_List__c='United States',
            State_List__c='Florida'         
        );
        insert lead;
    
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(lead.id);
        
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        
        // fetch the lead again to get the converted ids
        lead = [Select l.Id, l.Course_Name__c, l.Country_List__c, l.State_List__c, l.ConvertedOpportunityId, l.ConvertedContactId, l.ConvertedAccountId From Lead l Where l.Id = :lead.Id];     
        
        Contact contact = [select Mailing_State_List__c, Mailing_Country_List__c from Contact where Id = :lead.ConvertedContactId]; 
        Opportunity opp = [select Name from Opportunity where Id = :lead.ConvertedOpportunityId];   
        
    }    

    /**********************************************************************
    * START TEST FOR (DM) LeadConvert trigger 
    **********************************************************************/ 
/*
    public static testMethod void testDatamonitorLeadConvert() {
        
        Id leadRtId = MiscFunctions.getRecordtypeId('Lead', 'T&F - Leads'); //CHG0038379
        
        Lead lead = new Lead(
            firstName='Jeff',
            lastName='Test Lead',
            company='Jeff Test Company',
            recordtypeid='01260000000DSdsAAG'
        );
        insert lead;
        
        Set<ID> sectorIds = new Set<ID>();
        Set<String> sectorNames = new Set<String>();
        Set<ID> subSectorIds = new Set<ID>();
        Set<String> subSectorNames = new Set<String>(); 
        String csvSectors = '';
        String csvSubsectors = '';      
        List<Subsector_Selected__c> sectorsToInsert = new List<Subsector_Selected__c>();
        
        // add some new sector/subsector data
        Sector_Subsector__c s1 = new Sector_Subsector__c(
            name='Sector 1',
            Company__c='Datamonitor'
        );
        insert s1;
        
        Sector_Subsector__c s2 = new Sector_Subsector__c(
            name='Sub Sector',
            Company__c='Datamonitor',
            Parent__c=s1.Id
        );
        insert s2;        
        
        
        // get some sectors
        for (Sector_Subsector__c sector : [Select s.Name, s.Id From Sector_Subsector__c s where s.Parent__c = null limit 2]) {
            sectorIds.add(sector.Id);
            sectorNames.add(sector.Name);
            csvSectors = csvSectors + sector.Name + ', ';
        }
        csvSectors = csvSectors.substring(0,csvSectors.length()-2);  
        
        // get their sub sectors
        for (Sector_Subsector__c sector : [Select s.Name, s.Id From Sector_Subsector__c s where s.Parent__c IN :sectorIds]) {
            subSectorIds.add(sector.Id);
            subSectorNames.add(sector.Name);
            csvSubsectors = csvSubsectors + sector.Name + ', ';
            
            // create a selected subsector to insert
            Subsector_Selected__c selected = new Subsector_Selected__c();
            selected.Name = sector.Name;
            selected.Lead__c = lead.id;
            selected.Sector_Subsector__c = sector.id;
            sectorsToInsert.add(selected);
        }       
        csvSubsectors = csvSubsectors.substring(0,csvSubsectors.length()-2); 
        
        //System.debug('========================== sector ids: '+sectorIds);
        //System.debug('========================== sector names: '+sectorNames);
        //System.debug('========================== sub sector ids: '+subSectorIds);
        //System.debug('========================== sub sector names: '+subSectorNames); 
        //System.debug('========================== sector display: '+csvSectors);
        //System.debug('========================== sub sector display: '+csvSubsectors);            
        
        // add the comma separated list to the lead in for the sector/subsectors
        lead.sector__c = csvSectors;
        lead.sub_sector__c = csvSubsectors;
        update lead;
        
        // add the selected subsectors to the table
        insert sectorsToInsert;
    
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(lead.id);
        
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.debug('========================== lead convert results: '+lcr);
        //System.assert(lcr.isSuccess());
        
        // fetch the lead again to get the converted ids
        lead = [Select l.Id, l.ConvertedOpportunityId, l.ConvertedContactId, l.ConvertedAccountId From Lead l Where l.Id = :lead.Id];       
        
        // fetch the newly inserted subsectors for leads
        List<Subsector_Selected__c> selectedLeads = [Select s.Sector_Subsector__c, s.Name, s.Lead__c From Subsector_Selected__c s Where s.Lead__c = :lead.Id];      
        
        // fetch the newly inserted subsectors for conacts
        List<Subsector_Selected__c> selectedContacts = [Select s.Sector_Subsector__c, s.Name, s.Contact__c From Subsector_Selected__c s Where s.Contact__c = :lead.ConvertedContactId];
        //System.assertEquals(selectedLeads.size(),selectedContacts.size());
        
    }
*/    
    /**********************************************************************
    * START TEST FOR Informa_SE_Germany_OppEventDetails trigger 
    **********************************************************************/     
/*
    public static testMethod void testOpportunityEventDetails() {
        
        // create an account for the opportunity
        Account a = new Account();
        a.Name = 'My Test Account';
        insert a;
        
        // create a new product
        Product2 p = new Product2();
        p.recordtypeID = '01260000000DTUz';
        p.name = 'My Test Product';
        insert p;
        
        Opportunity opp = new Opportunity();
        opp.name = 'My Test Opp';
        opp.recordtypeid = '01260000000DTUu';
        opp.Opportunity_Event__c = p.id;
        opp.accountid = a.id;
        opp.type = 'New Business';
        opp.leadsource = 'Advertisement';
        opp.stagename = '1. Initiating';
        opp.closedate = Date.valueOf('2010-01-01');
        opp.CurrencyIsoCode = 'USD';
        // insert the opportunity
        insert opp;
        //Commented out to allow Patrick to update field size case 00008159
        //String productDetails = [Select p.Event_Details__c From Product2 p where p.id = :p.id].Event_Details__c;
        //String opportunityDetails = [Select o.Event_Details__c From Opportunity o where o.id = :opp.id].Event_Details__c;
        
        //System.debug('==================== productDetails '+productDetails);
        //System.debug('==================== opportunityDetails '+opportunityDetails);
        
        //System.assertEquals(p.Event_Details__c,opp.Event_Details__c);
        
    }   
*/    

    /*****************************************
    * START TEST FOR CopyCountryState triggers 
    *****************************************/  
    // test the CountryUserTrigger trigger
    public static testMethod void testUserCopy() {
        
        // create a cas test user
        Profile p = [select id from profile where name='CAS - Sales User']; 
        
        // insert addresses match
        User user = zTEST_Shared.insertUser(); 
        
        user = [Select l.country, l.country_list__c, l.state, l.state_list__c From User l Where l.id = :user.id];
                
        // Change the standard field values
        user.country = 'Canada';
        user.state = 'California';

        update user;    
        
        user = [Select l.country, l.country_list__c, l.state, l.state_list__c From User l Where l.id = :user.id];
        
        // run CopyCountryFromPickList in the trigger
        update user;
        
    }       
    
    // test the CountryLeadTrigger trigger
    public static testMethod void testLeadCopy() {
    
        Id rtId = MiscFunctions.getRecordtypeId('Lead', 'T&F - Leads'); //CHG0038379
        //String rtId = '01260000000JM1aAAG'; //T&F - Leads
        //String rtId2 = '01260000000DYvAAAW';
        //String rtId3 = '01260000000DXrVAAW';
        
        zTEST_Shared.runTrigger('CountryAccountTrigger', rtId, 'Business=Other'); 
        //zTEST_Shared.runTrigger('CountryAccountTrigger', rtId2, 'Business=ITM');  
        //zTEST_Shared.runTrigger('CountryAccountTrigger', rtId3, 'Business=CAS'); 
        
        
        // insert addresses don't match
        Lead l1 = new Lead(
            firstname='Test',
            lastname='Lead',
            company='Test Company',
            recordtypeid=rtId,
            Country='United States',
            Country_List__c='United States',
            State='Florida',
            State_List__c='Florida'
        );
        insert l1;
        
        l1 = [Select l.country, l.country_list__c, l.state, l.state_list__c From Lead l Where l.id = :l1.id];
        
        // Change the standard field values
        l1.country_list__c = 'Canada';
        l1.state_list__c = 'CA';

        update l1;    
        
        l1 = [Select l.country, l.country_list__c, l.state, l.state_list__c From Lead l Where l.id = :l1.id];
       
        // run CopyCountryFromPickList in the trigger
        update l1;
        
        Lead l2 = new Lead(
            firstname='Test',
            lastname='Lead',
            company='Test Company',
            recordtypeid=rtId,
            Country='United States',
            Country_List__c='United States',
            State='Florida',
            State_List__c='Florida'
        );
        insert l2;
        
        l2 = [Select l.country, l.country_list__c, l.state, l.state_list__c From Lead l Where l.id = :l2.id];
        
        // Change the standard field values
        l2.country = 'Canada';
        l2.state = 'California';

        update l2;    
        
        l2 = [Select l.country, l.country_list__c, l.state, l.state_list__c From Lead l Where l.id = :l2.id];
        
        // run CopyCountryFromPickList in the trigger
        update l2;
        
        Lead l3 = new Lead(
            firstname='Test',
            lastname='Lead',
            company='Test Company',
            recordtypeid=rtId,
            Country='United States',
            Country_List__c='United States',
            State='Florida',
            State_List__c='Florida'
        );
        insert l3;
        
        l3 = [Select l.country, l.country_list__c, l.state, l.state_list__c From Lead l Where l.id = :l3.id];
        
        // Change the custom field values
        l3.country_list__c = 'Canada';
        l3.state_list__c = 'California';

        update l3;    
        
        l3 = [Select l.country, l.country_list__c, l.state, l.state_list__c From Lead l Where l.id = :l3.id];
        
        // run CopyCountryFromPickList in the trigger
        update l3;
        
    }       
    
    // test the CountryAccountTrigger trigger
    public static testMethod void testAccountCopy() {
        
        Id rtId = MiscFunctions.getRecordtypeId('Account', 'T&F - Accounts'); //CHG0038379
        
        //String rtId = '01260000000DXrpAAG'; //CHG0031794
        //String rtId = '01260000000J08bAAC';
        //String rtId2 = '01260000000DYv6AAG';
        
        zTEST_Shared.runTrigger('CountryAccountTrigger', rtId, 'Business=Other'); 
        zTEST_Shared.runTrigger('CountryAccountTrigger', rtId, 'Business=ITM'); 
        
        // insert addresses match
        Account a1 = new Account(
            recordtypeid=rtId,
            name='Test Account',
            billingstreet='100 Main St.',
            billingcity='Anywhere',
            billingstate='Florida',
            billingpostalcode='11111',
            billingcountry='United States',
            billing_country_list__c='United States',
            billing_state_list__c='Florida' ,
            shippingstreet='123 Elm St',
            shippingstate='Anglesey',
            shippingpostalcode='11111',
            shippingcountry='United Kindgom',
            Shipping_Country_List__c ='United Kindgom',
            Shipping_State_List__c='Anglesey',
            mailing_country_list__c='United Kindgom',
            mailing_state_list__c='Anglesey'
        );
        insert a1;
        
        a1 = [Select a.Shipping_State_List__c, a.ShippingState, a.Shipping_Country_List__c, a.ShippingCountry, a.Mailing_State_List__c, a.Mailing_Country_List__c, a.Billing_ZIP__c, a.Billing_Street__c, a.Billing_State__c, a.Billing_State_List__c, a.Billing_Country__c, a.Billing_Country_List__c, a.Billing_City__c, a.BillingStreet, a.BillingState, a.BillingPostalCode, a.BillingCountry, a.BillingCity, a.Name From Account a Where a.id = :a1.id];
        
        // Change the standard field values
        a1.shippingstreet='100 Main St.';
        a1.Shipping_State_List__c='Florida';
        a1.shippingpostalcode='11111';
        a1.Shipping_Country_List__c='United States';
        system.debug('hailey');
        update a1;  
        
        a1 = [Select a.Shipping_State_List__c, a.ShippingState, a.Shipping_Country_List__c, a.ShippingCountry, a.Mailing_State_List__c, a.Mailing_Country_List__c, a.Billing_ZIP__c, a.Billing_Street__c, a.Billing_State__c, a.Billing_State_List__c, a.Billing_Country__c, a.Billing_Country_List__c, a.Billing_City__c, a.BillingStreet, a.BillingState, a.BillingPostalCode, a.BillingCountry, a.BillingCity, a.Name From Account a Where a.id = :a1.id];
        
        // run CopyCountryFromPickList in the trigger
        update a1;
        
        // insert addresses match
        Account a2 = new Account(
            recordtypeid=rtId,
            name='Test Account',
            billingstreet='100 Main St.',
            billingcity='Anywhere',
            billingstate='Florida',
            billingpostalcode='11111',
            billingcountry='United States',
            billing_country_list__c='United States',
            billing_state_list__c='Florida' ,
            shippingstreet='123 Elm St',
            shippingstate='Anglesey',
            shippingpostalcode='11111',
            shippingcountry='United Kindgom',
            Shipping_Country_List__c ='United Kindgom',
            Shipping_State_List__c='Anglesey',
            mailing_country_list__c='United Kindgom',
            mailing_state_list__c='Anglesey'
        );
        insert a2;
        
        a2 = [Select a.Shipping_State_List__c, a.ShippingState, a.Shipping_Country_List__c, a.ShippingCountry, a.Mailing_State_List__c, a.Mailing_Country_List__c, a.Billing_ZIP__c, a.Billing_Street__c, a.Billing_State__c, a.Billing_State_List__c, a.Billing_Country__c, a.Billing_Country_List__c, a.Billing_City__c, a.BillingStreet, a.BillingState, a.BillingPostalCode, a.BillingCountry, a.BillingCity, a.Name From Account a Where a.id = :a2.id];
        
        // Change the custom field values
        a2.shippingstreet='100 Main St.';
        a2.Shipping_State_List__c='FL';
        a2.shippingpostalcode='11111';
        a2.Shipping_Country_List__c='United States';

        update a2;  
        
        a2 = [Select a.Shipping_State_List__c, a.ShippingState, a.Shipping_Country_List__c, a.ShippingCountry, a.Mailing_State_List__c, a.Mailing_Country_List__c, a.Billing_ZIP__c, a.Billing_Street__c, a.Billing_State__c, a.Billing_State_List__c, a.Billing_Country__c, a.Billing_Country_List__c, a.Billing_City__c, a.BillingStreet, a.BillingState, a.BillingPostalCode, a.BillingCountry, a.BillingCity, a.Name From Account a Where a.id = :a2.id];
        
        // run CopyCountryFromPickList in the trigger
        update a2;
    }   
    
    // test the ContactCopyStateCountryList trigger
    public static testMethod void testContactCopy() {
    
        Id rtId = MiscFunctions.getRecordtypeId('Contact', 'T&F - Contacts'); //CHG0038379
        
        //String rtId = '01260000000DXruAAG'; //CHG0031794
        //String rtId = '01260000000J2hmAAC';
        //String rtId2 = '01260000000DYv9AAG';
        
        zTEST_Shared.runTrigger('CountryContactTrigger', rtId, 'Business=Other'); 
        //zTEST_Shared.runTrigger('CountryContactTrigger', rtId2, 'Business=ITM'); 
        
        // insert addresses  match
        Contact c1 = new Contact(
            recordtypeid=rtId,
            firstname='Test',
            lastname='Test',
            mailingstate='Florida',
            mailing_state_list__c='Florida',            
            mailingcountry='United States',
            mailing_country_list__c='United States',
            otherstate='Anglesey',
            other_state_list__c='Anglesey',
            othercountry='United Kindgom',
            other_country_list__c='United Kindgom'
        );
        insert c1;
        
        c1 = [Select recordtypeid,mailingstate,mailing_state_list__c,mailingcountry,mailing_country_list__c,otherstate,other_state_list__c,othercountry,other_country_list__c from Contact where id = :c1.id];
        
        // Change the standard field values
        c1.mailing_state_list__c='FL';
        c1.mailing_country_list__c='United States';
        c1.other_state_list__c='London';
        c1.other_country_list__c='United Kingdom';
        update c1;  
        
        c1 = [Select recordtypeid,mailingstate,mailing_state_list__c,mailingcountry,mailing_country_list__c,otherstate,other_state_list__c,othercountry,other_country_list__c from Contact where id = :c1.id];
        
        // run CopyCountryFromPickList in the trigger
        update c1;
        
        User u = zTEST_Shared.insertUser();
        
        Id accountRtId = MiscFunctions.getRecordtypeId('Account', 'T&F - Accounts'); //CHG0038379
        
        //Account a2 = zTEST_Shared.insertAccount (u.Id, '01260000000DYv6AAG');
        Account a2 = zTEST_Shared.insertAccount (u.Id, accountRtId);
        
        Contact c2 = new Contact(
            //recordtypeid=rtID2,
      recordtypeid=rtID,
            firstname='Test',
            lastname='Test',
            mailingstate='FL',
            mailing_state_list__c='FL',            
            mailingcountry='United States',
            mailing_country_list__c='United States',
            otherstate='London',
            other_state_list__c='London',
            othercountry='United Kingdom',
            other_country_list__c='United Kingdom',
            accountId = a2.Id
        );
        insert c2;
        
        c2 = [Select recordtypeid,mailingstate,mailing_state_list__c,mailingcountry,mailing_country_list__c,otherstate,other_state_list__c,othercountry,other_country_list__c from Contact where id = :c2.id];
        
        // Change the custom field values
        c2.mailing_state_list__c='FL';
        c2.mailing_country_list__c='USA';
        c2.otherstate='London';
        c2.othercountry='United Kingdom';
        update c2;  
        
        c2 = [Select recordtypeid,mailingstate,mailing_state_list__c,mailingcountry,mailing_country_list__c,otherstate,other_state_list__c,othercountry,other_country_list__c from Contact where id = :c2.id];
       
        // run CopyCountryFromPickList in the trigger
        update c2;
        
    }
    
    /*****************************************
    * START TEST FOR CreateUserNotification trigger 
    *****************************************/  
    public static testMethod void testUserCreation() {
    
        User u = zTEST_Shared.noinsertUser();
        
        u.FirstName = 'Jeff';
        u.LastName = 'Douglas';
        u.Email = 'jeff.douglas@informausa.com';
        u.Username = 'jeff.douglas@informausa.com.neptune-test5';
        u.Informa_Business_Unit__c = 'ESI';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.LocaleSidKey = 'en_US';
        u.TimeZoneSidKey = 'America/New_York';
        u.LanguageLocaleKey = 'en_US';
        
        Insert u;
        
    }    
   
}