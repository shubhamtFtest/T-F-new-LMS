/**************************************************
* Created by Jeff Lup, 2011.04.28
* Shared methods used for all Test methods
* Updated by Ashish Purwar, 2018.04.16
* Added methods for case
**************************************************/

public class zTEST_Shared {

    public static Id getProfileId(String profileName){
        return [select Id from profile where name = :profileName].Id; 
    }

    public static User insertUser(){
        User u = noinsertUser(); //System Administrator
        insert u;
        return u;
    }
    public static User insertUser(String profileName, String informaBusinessUnit){
        User u = noinsertUser();
        u.ProfileId = getProfileId(profileName);
        u.Informa_Business_Unit__c = informaBusinessUnit;
        insert u;
        return u;
    }
    public static User insertUser(String profileName, String informaBusinessUnit, String userRegion, String userType){
        User u = noinsertUser();
        u.ProfileId = getProfileId(profileName);
        u.Informa_Business_Unit__c = informaBusinessUnit;
        u.Region__c = userRegion;
        u.Type__c = userType;
        insert u;
        return u;
    }
    
    public static User noinsertUser(){
        String adUsername = 'testinguser1' + system.now().second() + system.now().millisecond();
        String adOU = 'ukcorplan';
            
        //For active directory validation rule
        String adstr= adOU + '\\' + adUsername;
        Active_Directory_Details__c acd = new Active_Directory_Details__c(Name='TestAd', sys_id__c='sys123', u_office_365__c = 'TestOfc' ,USER_Name__c=adstr,CurrencyIsoCode=UserInfo.getDefaultCurrency());
        insert acd;
    
        User u = new User(alias='test', email='test@example.com', firstname='Testing',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', country='United States',
            timezonesidkey='America/Los_Angeles', username='test@example.com.informaplc' + system.now().second() + system.now().millisecond() + math.random(),
            Informa_Business_Unit__c='INFORMA USA INC',
            //profileid='00e30000000guhiAAA',
            profileid=getProfileId('System Administrator'), //CHG0038379
            Legal_Entity__c='INFORMA PLC (CH004)',
            Reporting_Unit__c='AE005',
            Admin_Options__c='Manage Licenses',
            Active_Directory_Username__c=adUsername,
            Active_Directory_OU__c=adOU);
            //Active_Directory_Username__c='testinguser1' + system.now().second() + system.now().millisecond(),
            //Active_Directory_OU__c='ukcorplan');
        return u;
    }
        
    /*public static Pricebook2 insertPricebook2(){
        Pricebook2 pb = [select id from Pricebook2 where IsStandard = true];        
        return pb;
    }*/

    public static Pricebook2 insertPricebook2(){
        List<Pricebook2> pbList = [select id from Pricebook2 where IsStandard = true];        
        Pricebook2 pb = new Pricebook2();
        if ( pbList.size() > 0 ) {
            pb = pbList[0];
        }
        
        return pb;
    }
    
    public static Pricebook2 insertPricebook2_2(){ //written because the other one is not working with the new api
        //Pricebook2 pb = new Pricebook2(Id = '01s300000001JicAAE');
        Pricebook2 pb = new Pricebook2(Id = Test.getStandardPricebookId()); //CHG0038379
        return pb;
    }
    
    public static Product2 insertProduct2(){
        Product2 p = noinsertProduct2();
        insert p;
        return p;
    }
    public static Product2 insertProduct2(String product2RecordtypeId){
        Product2 p = noinsertProduct2(product2RecordtypeId);
        insert p;
        return p;
    }
    public static Product2 noinsertProduct2(String product2RecordtypeId){
        Product2 p = new Product2(name='test', ProductCode='12345', IsActive=true, Description='test', RecordTypeId=product2RecordtypeId,
            ISBN__c = '12345678901234', Competitor_Publisher__c='test', Subject_Code__c='test');
        return p;
    }
    public static Product2 noinsertProduct2(){
        String product2RecordtypeId = [select id from RecordType where sobjecttype = 'Product2' limit 1].Id;
        Product2 p = noinsertProduct2(product2RecordtypeId);
        return p;
    }

    public static PricebookEntry insertPricebookEntry(String pricebook2Id, String product2Id){
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pricebook2Id, Product2Id=product2Id, UnitPrice=1.00, IsActive=true, UseStandardPrice=false);
        insert pbe;
        return pbe;
    }

    public static PricebookEntry insertPricebookEntry(String product2RecordtypeId){
        //Pricebook2 pb = [select id from Pricebook2 where IsStandard = true]; //for some reason this now errors in a test method   
        Product2 p = insertProduct2(product2RecordtypeId);
        //PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pb.id, Product2Id=p.id, UnitPrice=1.00, IsActive=true, UseStandardPrice=false);
        
        //PricebookEntry pbe = new PricebookEntry(Pricebook2Id='01s300000001JicAAE', Product2Id=p.id, UnitPrice=1.00, IsActive=true, UseStandardPrice=false);
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=Test.getStandardPricebookId(), Product2Id=p.id, UnitPrice=1.00, IsActive=true, UseStandardPrice=false); //CHG0038379
        insert pbe;
        return pbe;
    }
    public static PricebookEntry insertPricebookEntry(){
        //Pricebook2 pb = [select id from Pricebook2 where IsStandard = true]; //for some reason this now errors in a test method
        String product2RecordtypeId = [select id from RecordType where sobjecttype = 'Product2' limit 1].Id;
        Product2 p = insertProduct2(product2RecordtypeId);
        //PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pb.id, Product2Id=p.id, UnitPrice=1.00, IsActive=true, UseStandardPrice=false);
        //PricebookEntry pbe = new PricebookEntry(Pricebook2Id='01s300000001JicAAE', Product2Id=p.id, UnitPrice=1.00, IsActive=true, UseStandardPrice=false);
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=Test.getStandardPricebookId(), Product2Id=p.id, UnitPrice=1.00, IsActive=true, UseStandardPrice=false); //CHG0038379
        insert pbe;
        return pbe;
    }
    public static PricebookEntry insertPricebookEntryWithCurrency(String currencyIsoCode){
        String product2RecordtypeId = [select id from RecordType where sobjecttype = 'Product2' limit 1].Id;
        Product2 p = insertProduct2(product2RecordtypeId);
        //PricebookEntry pbe = new PricebookEntry(Pricebook2Id='01s300000001JicAAE', Product2Id=p.id, UnitPrice=1.00, IsActive=true, UseStandardPrice=false, CurrencyIsoCode=currencyIsoCode);
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=Test.getStandardPricebookId(), Product2Id=p.id, UnitPrice=1.00, IsActive=true, UseStandardPrice=false, CurrencyIsoCode=currencyIsoCode); //CHG0038379
        insert pbe;
        return pbe;
    }
    
    public static Opportunity insertOpportunity(String oppRecordtypeId, String ownerId, String accountId){
        Opportunity opp = noinsertOpportunity(oppRecordtypeId, ownerId);
        opp.AccountId = accountId;
        insert opp;
        return opp;
    }
    public static Opportunity insertOpportunity(String oppRecordtypeId, String ownerId){
        Opportunity opp = noinsertOpportunity(oppRecordtypeId, ownerId);
        insert opp;
        return opp;
    }
    public static Opportunity noinsertOpportunity(String oppRecordtypeId, String ownerId, String accountId){
        Opportunity opp = noinsertOpportunity(oppRecordtypeId, ownerId);
        opp.AccountId = accountId;
        return opp;
    }
    public static Opportunity noinsertOpportunity(String oppRecordtypeId, String ownerId){
        Opportunity opp = new Opportunity(name='Test', recordtypeid=oppRecordtypeId, StageName = 'Prospect',
            CloseDate = date.today(), OwnerId = ownerId, Number_of_Students__c = 1);
        return opp;
    }
    
    public static Opportunity noinsertOpportunity2(String oppRecordtypeId, String ownerId){
        Opportunity opp = new Opportunity(name='Test', recordtypeid=oppRecordtypeId, StageName = 'Prospect',
            CloseDate = date.today(), OwnerId = ownerId, Number_of_Students__c = 1);
        return opp;
    }
    
    public static OpportunityLineItem noinsertOpportunityLineItem(String opportunityId){
        PricebookEntry pbe = insertPricebookEntry();
        OpportunityLineItem oli = noinsertOpportunityLineItem(pbe.Id, opportunityId, null);
        return oli;
    }
    public static OpportunityLineItem insertOpportunityLineItem(String opportunityId){
        PricebookEntry pbe = insertPricebookEntry();
        OpportunityLineItem oli = noinsertOpportunityLineItem(pbe.Id, opportunityId, null);
        insert oli;
        return oli;
    }
    public static OpportunityLineItem insertOpportunityLineItem(String pricebookEntryId, String opportunityId){
        OpportunityLineItem oli = noinsertOpportunityLineItem(pricebookEntryId, opportunityId, null);
        insert oli;
        return oli;
    }
    public static OpportunityLineItem insertOpportunityLineItem(String pricebookEntryId, String opportunityId, String adoptionStage){
        OpportunityLineItem oli = noinsertOpportunityLineItem(pricebookEntryId, opportunityId, adoptionStage);
        insert oli;
        return oli;
    }
    public static OpportunityLineItem noinsertOpportunityLineItem(String pricebookEntryId, String opportunityId){
        OpportunityLineItem oli = noinsertOpportunityLineItem(pricebookEntryId, opportunityId, null);
        return oli;
    }
    public static OpportunityLineItem noinsertOpportunityLineItem(String pricebookEntryId, String opportunityId, String adoptionStage){
        
        User usr = insertUser();
        
        Account acct = insertAccount(usr.Id);
        
        Contact cont = insertContact(usr.Id, acct.Id);
        
        OpportunityLineItem oli 	= new OpportunityLineItem();
        oli.Adoption_Stage__c 		= adoptionStage;
        oli.Quantity 				= 1;
        oli.TotalPrice 				= 1;
        oli.PricebookEntryId 		= pricebookEntryId;
        oli.OpportunityId 			= opportunityId;
        oli.IsTesting__c 			= True; //speeds up Future call
        oli.Recipient__c 			= cont.Id;
        return oli;
    }

    public static OpportunityContactRole insertOpportunityContactRole(String opportunityId, String contactId, String role){
        OpportunityContactRole ocr = new OpportunityContactRole();
            ocr.OpportunityId = opportunityId;
            ocr.ContactId = contactId;
            ocr.Role = role;
            ocr.IsPrimary = true;
        insert ocr;
        return ocr;
    }
    public static OpportunityContactRole insertOpportunityContactRole(String opportunityId, String contactId){
        OpportunityContactRole ocr = new OpportunityContactRole();
            ocr.OpportunityId = opportunityId;
            ocr.ContactId = contactId;
            ocr.IsPrimary = true;
        insert ocr;
        return ocr;
    }

    public static Account noinsertAccount(String ownerId){
        Account a = new Account();
        a.Name = 'test';
        a.OwnerId = ownerId;
        return a;
    }
    public static Account insertAccount(String ownerId){
        Account a = noinsertAccount(ownerId);
        insert a;
        return a;
    }
    public static Account insertAccount(String ownerId, String recordtypeId){
        Account a = noinsertAccount(ownerId);
        a.RecordTypeId = recordtypeId;
        a.BillingCity = 'Test Billing';
        a.BillingStreet = 'Test Billing';
        a.BillingPostalCode = '111111';
        a.ShippingCity = 'Test Shipping';
        insert a;
        return a;
    }
    
    public static Lead noinsertLead(String ownerId){
        Lead l = new Lead();
        l.FirstName = 'test';
        l.LastName = 'test';
        l.Company = 'test';
        l.OwnerId = ownerId;
        return l;
    }
    public static Lead insertLead(String ownerId){
        Lead l = noinsertLead(ownerId);
        insert l;
        return l;
    }
    public static Lead insertLead(String ownerId, String recordtypeId){
        Lead l = noinsertLead(ownerId);
        l.RecordTypeId = recordtypeId;
        insert l;
        return l;
    }
    
    public static Contact noinsertContact(String ownerId, String accountId){
        Contact c = new Contact();
        c.AccountId = accountId;
        c.FirstName = 'test';
        c.LastName = 'test';
        c.OwnerId = ownerId;
        c.MailingCountry = 'United States';
        c.MailingStreet = '1234 Main St\nSuite100\nAttn:John Doe';
        c.OtherStreet = '1234 Main St\nSuite100\nAttn:John Doe';
        return c;
    }

    public static Contact insertContact(String ownerId, String accountId){
        Contact c = noinsertContact(ownerId, accountId);
        insert c;
        return c;
    }

    public static Contact insertContact(String ownerId, String accountId, String recordtypeId){
        Contact c = noinsertContact(ownerId, accountId);
        c.RecordTypeId = recordtypeId;
        insert c;
        return c;
    }
        
    public static CAS_Subject_Code__c insertCASSubjectCode(String ownerId){
        CAS_Subject_Code__c sc = new CAS_Subject_Code__c();
        sc.Name = 'test';
        sc.OwnerId = ownerId;
        sc.GT_Cat_Code__c = 'test';
        insert sc;
        return sc;
    }
    
    public static CAS_Subject_Code_Contact__c insertCASSubjectCodeContact(String subjectCodeId, String contactId, String ownerId){
        CAS_Subject_Code_Contact__c scc = new CAS_Subject_Code_Contact__c();
        scc.Subject_Code__c = subjectCodeId;
        scc.Contact__c = contactId;
        scc.OwnerId = ownerId;
        insert scc;
        return scc;
    }
    
    public static CAS_Inspection_Copy__c insertCASInspectionCopy(String oppId, String oliId){
        CAS_Inspection_Copy__c ic = new CAS_Inspection_Copy__c();
        ic.Opportunity__c = oppId;
        ic.Opportunity_Product__c = oliId;
        ic.Book_Order__c = '1234';
        ic.Book_Title__c = 'My title';
        ic.ISBN__c = '123';
        ic.Contact_Name__c = 'no name';
        ic.Adoption_Level__c = 'Required Textbook';
        //ic.Adoption_Stage__c = 'I would like to return this book';
        ic.Year_of_Study__c = '3rd year undergraduate';
        ic.Book_Strengths__c = 'strengths';
        ic.Book_Weaknesses__c = 'weaknesses';
        ic.IsTesting__c = True; //speeds up Future call
        insert ic;
        return ic;
    }
    
    public static Campaign insertCampaign(String ownerId, String recordtypeId, Date endDate, String prevCampaignId){
        Campaign camp = new Campaign();
        camp.Name = 'test';
        camp.OwnerId = ownerId;
        camp.EndDate = endDate;
        camp.RecordTypeId = recordtypeId;
        camp.Previous_Campaign_Id__c = prevCampaignId;
        camp.IsActive = true;
        camp.Status = 'In Progress';
        insert camp;
        return camp;
    }
    
    public static Campaign insertCampaign(String ownerId, String recordtypeId, Date endDate){
        Campaign camp = new Campaign();
        camp.Name = 'test';
        camp.OwnerId = ownerId;
        camp.EndDate = endDate;
        camp.RecordTypeId = recordtypeId;
        camp.IsActive = true;
        camp.Status = 'In Progress';
        insert camp;
        return camp;
    }
    public static Campaign insertCampaign(String ownerId){
        Campaign camp = new Campaign();
        camp.Name = 'test';
        camp.OwnerId = ownerId;
        camp.IsActive = true;
        insert camp;
        return camp;
    }

    public static CampaignMember insertCampaignMember(String campaignId, String leadId, String contactId){
        CampaignMember cm = new CampaignMember();
        cm.CampaignId = campaignId;
        cm.LeadId = leadId;
        cm.ContactId = contactId;
        insert cm;
        return cm;
    }
    //Added methods for case :Ashish Purwar : 16/04/2018
    public static Case noinsertCase(Id InputId, string Type){
        Case c = new Case();        
        c.Status = 'New';
        if(Type=='Account')
        c.accountId = InputId;
        else
        c.contactId= InputId;
        return c;
    }
    
    
    public static Case insertCase(Id InputId, string Type){
        Case C = noinsertCase(InputId,Type);                
        insert c;        
        return c;
    }
     //Added methods for CSAT:Ashish Purwar : 16/04/2018
    public static CSAT__c noinsertCSAT(String name,Id CaseId,Date SurveyDate,String CustomerSatisfaction,Decimal CustomerEffortScoreCES,Decimal NetPromotorScoreNPS, String CurrencyISOCode){
        CSAT__c csat = new CSAT__c();
        csat.Name=name;
        csat.Case__c=CaseId;
        csat.Survey_Status__c='Response Received';
        csat.Survey_Date__c=SurveyDate;
        csat.Customer_Satisfaction_CSAT__c=CustomerSatisfaction;
        csat.Customer_Effort_Score_CES__c=CustomerEffortScoreCES;
        csat.Net_Promotor_Score_NPS__c=NetPromotorScoreNPS;
        csat.CurrencyIsoCode=CurrencyISOCode;
        return csat;
    }
    public static CSAT__c insertCSAT(String name,String CaseId,Date SurveyDate,String CustomerSatisfaction,Decimal CustomerEffortScoreCES,Decimal NetPromotorScoreNPS, String CurrencyISOCode){
        CSAT__c C = noinsertCSAT(name,CaseId,SurveyDate,CustomerSatisfaction,CustomerEffortScoreCES,NetPromotorScoreNPS,CurrencyISOCode);        
        insert c;
        return c;
    }
    //Updated by: Amit
    public static Campus__c insertCampus(){
        Campus__c camp = new Campus__c();
        camp.Name = 'test';       
        insert camp;
        return camp;
    }

    public static void assignUserToAPermissionSet(Id userId, String permissionSet) {
        PermissionSet ps;
        List<PermissionSet> psList = [SELECT Id FROM PermissionSet WHERE Name = :permissionSet];
        if (psList.size() == 0) {
            Id userLicenseId = [select id from userlicense where name = 'Salesforce'].id;
            ps = new PermissionSet();
            ps.Label = permissionSet;
            ps.Name = permissionSet;
            //ps.UserLicenseId = '10060000000021WAAQ'; //Salesforce
            ps.UserLicenseId = userLicenseId;
            insert ps;  
        } else {
            ps = psList[0];
        }           
        
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = userId;
        psa.PermissionSetId = ps.Id;
        insert psa;
    }
    
    public static set<String> runTriggers = new set<String>();
    public static map<String, Set<Id>> runTriggersForRecordtypes = new map<String, Set<Id>>();
    public static map<String, Map<Id,Map<String,String>>> runTriggersForRecordtypesWithParams = new map<String, Map<Id,Map<String,String>>>();
    
    public static void runTrigger(String triggerName) {
        runTriggers.add(triggerName);
    }

    public static void runTrigger(String triggerName, String recordtypeId) {
        runTriggersForRecordtypes.put(triggerName, new Set<Id>{recordtypeId});
    }

    public static void runTrigger(String triggerName, String recordtypeId, String params) {
        Map<String,String> mapParams = new Map<String,String>();
        List<String> split1 = params.split(';');
        for (String param : split1) {
            if (param.contains('=')) {
                List<String> split2 = param.split('=');
                mapParams.put(split2[0], split2[1]);
            } else {
                mapParams.put('Parameters', param);
            }
        }
        Map<Id, Map<String,String>> mapIdToParams;
        if (runTriggersForRecordtypesWithParams.containsKey(triggerName))
            mapIdToParams = runTriggersForRecordtypesWithParams.get(triggerName);
        else
            mapIdToParams = new Map<Id, Map<String,String>>();
        mapIdToParams.put(recordtypeId, mapParams);
        runTriggersForRecordtypesWithParams.put(triggerName, mapIdToParams);
    }

}