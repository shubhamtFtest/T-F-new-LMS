/**************************************************
* Created by Jeff Lup
* Modified by Hailey Niemand 2014.01.09 - Profiles renamed/deleted
* Test methods for:
*   - ForecastInfoWrapper.cls 91%
*   - CASContactSearchExportWrapper.cls 100%
**************************************************/
@isTest
private class Tests_Wrappers {

    static testMethod void testCASContactSearchExportWrapper() {
        //User u =  zTEST_Shared.insertUser('ESI - Marketing - 1.0', 'ESI');
        //User u =  zTEST_Shared.insertUser('ESI - US Marketing', 'ESI'); //2014.01.09 - Profiles renamed/deleted
        User u =  zTEST_Shared.insertUser('CAS - Marketing User', 'Taylor & Francis'); //2014.12.02 - Profiles deleted
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c1 = zTEST_Shared.insertContact(u.Id, a.Id);
        Contact c = [select id, accountid, account.name, MailingStreet, OtherStreet from contact where id = :c1.id];

        CASContactSearchExportWrapper cls = new CASContactSearchExportWrapper(c);
        cls.MailingStreetFull = 'test';
        String MailingStreetFull = cls.MailingStreetFull;
        cls.MailingStreet1 = 'test';
        String MailingStreet1 = cls.MailingStreet1;
        cls.MailingStreet2 = 'test';
        String MailingStreet2 = cls.MailingStreet2;
        cls.MailingStreet3 = 'test';
        String MailingStreet3 = cls.MailingStreet3;
        cls.OtherStreetFull = 'test';
        String OtherStreetFull = cls.OtherStreetFull;
        cls.OtherStreet1 = 'test';
        String OtherStreet1 = cls.OtherStreet1;
        cls.OtherStreet2 = 'test';
        String OtherStreet2 = cls.OtherStreet2;
        cls.OtherStreet3 = 'test';
        String OtherStreet3 = cls.OtherStreet3;
        cls.CleanedAccountName = 'test';
        String CleanedAccountName = cls.CleanedAccountName;
        Contact contact = cls.contact;
        cls.contact = c;
    }

/* was PI only 
    
    static testMethod void testForecastInfoWrapper() {
        User u = zTEST_Shared.insertUser('System Administrator', 'ITM');
        Account a = zTEST_Shared.insertAccount(u.Id);
        Opportunity o = zTEST_Shared.insertOpportunity('01260000000DYvBAAW', u.Id, a.Id);
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry();
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, o.Id);
        
        ForecastInfoWrapper cls = new ForecastInfoWrapper(oli);
        Decimal Price = cls.Price;
        cls.NumToClone = 0;
        Integer NumToClone = cls.NumToClone;
        List<SelectOption> getEsiSessionStatusList = cls.getEsiSessionStatusList();
        boolean dataChanged = cls.dataChanged();
        boolean alreadyScheduled = cls.alreadyScheduled();
        boolean getRecordLocked = cls.getRecordLocked();
        boolean getRecordEnabled = cls.getRecordEnabled();
        boolean getPriceLocked = cls.getPriceLocked();
        boolean getPriceEnabled = cls.getPriceEnabled();
        cls.FormattedUnitPrice = '1,000';
        String FormattedUnitPrice = cls.FormattedUnitPrice;
        cls.FormattedUnitPrice = null;
        FormattedUnitPrice = cls.FormattedUnitPrice;
        oli.ESI_Session_Status__c = 'Invoiced';
        getPriceLocked = cls.getPriceLocked();
        oli.ESI_Session_Status__c = 'Scheduled';
        getRecordLocked = cls.getRecordLocked();
        alreadyScheduled = cls.alreadyScheduled();
    }
*/

    /*private static User getNewUser(String profileName, String userName, String aliasName, String informaBusinessUnit, String userRegion, String userType){
        Profile p = [select id from profile where name = :profileName]; 
        User u = new User(alias=aliasName, email=userName, firstname='Testing',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, country='United States',
            Informa_Business_Unit__c = informaBusinessUnit,
            Region__c = userRegion, Type__c = userType,
            IsActive = true,
            UserRoleId = '00E60000000jZ8SEAU', Legal_Entity__c='INFORMA PLC (CH004)',
            timezonesidkey='America/Los_Angeles', username=userName);
        insert u;
        return u;   
    }
    
    private static Account setupTestAccount(String accountName, ID userId) {
        Account a = new Account(name=accountName,
            OwnerId=userId,
            BillingStreet='1234 Main Street');  
        insert a;
        return a;
    } 
    
    private static Opportunity setupTestOpportunity(String oppName, ID accountId, String oppType, String oppStageName, Id ownerId) {
        Opportunity opp = new Opportunity(
            name=oppName,
            Type = oppType,
            stagename=oppStageName,
            CurrencyIsoCode = 'USD',
            Probability=100,
            closedate=Date.newInstance(2011, 01, 01),
            accountId=accountId,
            RecordTypeid = '01260000000DYvBAAW',
            OwnerId = ownerId
        );
        insert opp;
        return opp;
    }       
    
    private static OpportunityLineItem setupAddOppLineItems(ID opportunityId) { 
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = opportunityId;
        oli.Quantity = 1;
        oli.UnitPrice = 100.00;
        //oli.TotalPrice = 100.00;
        oli.Trial_Status__c = 'Trial Requested';
        Product2 p = [SELECT Id FROM Product2 WHERE Product__c = 'Newsletter' AND ITM_Edition__c = 'TGMC' LIMIT 1];     
        oli.PricebookEntryId = [Select pbe.Id From PricebookEntry pbe Where pbe.IsActive = true AND pbe.Product2Id = :p.Id AND pbe.CurrencyIsoCode = 'USD' limit 1].Id;
        // insert the opportunity line item
        insert oli;
        return oli;
    }  
    
    private static Contact setupTestContact(String lastname, Id accountId){
        Contact c = new Contact(
            accountId=accountId,
            firstname='test',
            lastname=lastname,
            salutation='Mr',
            email='test@example.com',
            phone='111-111-1111',
            MailingCountry='United States',
            MailingPostalCode='11111',
            MailingState='Florida',
            MailingCity='New York',
            MailingStreet='100 Main St.',
            Sector__c='MySector',
            Sub_Sector__c='MySubSector'
        );
        insert c;       
        return c;       
    }
    */
}