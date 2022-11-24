/******************************************************************
CustomLeadConversionTF2Controller for page Custom Lead Conversion TF2
Test Class: zTEST_CLC_TF2
Created Date: 2017/01/30
Piyush Jain: Modified on  - 2017/05/26 pn line number :130 :- Add Trim on List
Rishabh Singh: Modified on- 2017/06/20 - CHG0033734 
Modified by Jeff Lup      - 2017.07.20 - CHG0036312 - Remove North_America__c
Modified by Rishabh Singh - 2017.09.27 - CHG0038130
Modified by Piyush Jain   - 2018.04.05 - CHG0042968 
Modified by Matthew Smith - 2020.03.31 - 01484071 - Replacing US/CIS Opp Record Type with 'T&F Global Corporate / Special Sales Opportunity' 
Modified by Matthew Smith - 2020.12.14 - 01733308 - Update Manual Lead Convert For Corporate Leads
Modified By Sid C         - 2021.04.07 - 01845505
Modified by Matthew Smith - 2021.05.18 - 01890248 - Updating Opportunity Type Values
Modified by Matthew Smith - 2022.02.21 - SAL-5376 - Updating F1000 Record Types
Modified by Renil Rejith  - 2022.03.24 - [MES-21] - Update Custom Lead Convert for F1000
										 [MES-21] - change 1 - Null condition Check for oObj.
										 [MES-21] - change 2 - Commneted to make it public and access in other methods by Renil.
										 [MES-21] - change 3 - Skip all validations if selected opportunity record type contains opbs_F1000 in its name.
										 [MES-21] - change 4 - check if no opportunities have been selected in the opportunity creation page.
										 [MES-21] - change 5 - Null condition Check for converted Account,Contact and Opportunity.

Modified by Renil Rejith  - 2022.03.24 - [MES-178] - Update Custom Lead Convert for TnF Commission
										 [MES-178] - change 1 -  Skip all validations if selected opportunity record type contains opbs_TF_Commissioning in its name.
******************************************************************/

public with sharing class CustomLeadConversionTF2Controller{
    public String leadId {get; set;}
    public Lead leadObj {get; set;}
    public String leadAddress {get; set;}
    public String copyAddressTo { get; set; }
    public String deliveryAddress { get; set; }
    public Boolean showEmailDomainMathes {get; set;}
    public Boolean showCampusAndDepartment {get; set;}
    public Boolean showRinggoldAndBP {get; set;}
    public Boolean showAccountSite {get; set;}
    public List<ContactAccountWrapper> cawList {get; set;}
    private String contactRTID;
    private String accountRTID;
    private List<Id> pricebookIDLst;
    String domainPart;
    public String OpporIndexPoint{get;set;}
    public String wrapperIndex {get; set;}
    public String campusID {get; set;}
    public Boolean isContactPage {get; set;}
    public Visualforce_Control__c lookup {get; set;}
    public String campusJsonString {get; set;}
    public String departmentJsonString {get; set;}
    public String errorMessage {get; set;}
    public Boolean showErrorMessage {get; set;}
    public Boolean isNotValidEamilId{get;set;}
    public Opportunity oppObj {get; set;}
    public List<OpportunityWrapper> owList {get; set;}
    public String selectedAccountForOpportunity {get; set;}
    public String selectedContactForOpportunity {get; set;}
    
    public Boolean showExistingContactRoles {get; set;}
    public Boolean hideClosedOpportunities {get; set;}
    public Boolean showAllRecordTypes {get; set;}
    public String selectedOppRecordType {get; set;}
    private String OpportunityRTIds;
    public OpportunityLineItem oppProductOBj {get; set;}
    public OpportunityContactRole ocrObj {get; set;}
    public ContactAccountWrapper firstPageSelectedRecord {get; set;}
    public OpportunityWrapper selectedOpportunityWrapper {get; set;}
    public Account convertedAccount {get; set;}
    public Contact convertedContact {get; set;}
    public Opportunity convertedOpportunity {get; set;}
    
    public Boolean renderedSection1 {get; set;}
    public Boolean renderedSection2 {get; set;}
    public Boolean renderedSection3 {get; set;}
    public Boolean renderedSection4 {get; set;}
    public Boolean renderedSection5 {get; set;}
    public Boolean isFinalPage {get; set;}
    public Product2 product {get; set;} 
    public String campusName {get; set;}
    
  
    public String updateOptionsCName {get; set;}
    public String updateOptionsCIndex {get; set;}
    public String updateOptionsCIsCampus {get; set;}
    public Integer indexCampusDepartmentUpdate {get; set;}
    
    public Map<Integer,List<SelectOption>> mapAddNewDept{get;set;} //Added New Departments
    
    public Map<String, String> oppRTToVFSectionMap = new Map<String, String>();
   
    private String pricebookID;
    public String sortDirection = 'DESC';
    public String sortExp = 'CloseDate';
   
    public List<SelectOption> getCurrencies()
    {
        
      
        Map<String,SelectOption> mapCurrencyIsoCode = new  Map<String,SelectOption>();
        List<CurrencyType> lstPBEntry  = new List<CurrencyType> ([select isocode from CurrencyType where IsActive= true]);
        for(CurrencyType pbe:lstPBEntry){
            mapCurrencyIsoCode.put(pbe.isocode,new SelectOption(String.valueOf(pbe.get('isocode')), String.valueOf(pbe.get('isocode'))));
        }
        
       
        return mapCurrencyIsoCode.values();
    }
    
    public String removeQuote(String sValue){
        
        if(sValue != null && String.isNotBlank(sValue)){
            sValue =String.escapeSingleQuotes(sValue);
        }
        return sValue;
    }

    
    //Constructor
    public CustomLeadConversionTF2Controller(ApexPages.StandardController controller){
        defaultInitialization();
        initializeFromCustomSetting();
        isFinalPage = false;
        OpporIndexPoint ='-1';
        oppProductOBj.IC_Quantity__c = 1;
        oppProductOBj.Quantity = 1;
        oppProductOBj.Feedback_Notification__c = 'Send';
        selectedOppRecordType = '0120Y000000Wn9SQAS'; //T&F - CAS Opportunity
        
        List<Schema.RecordTypeInfo> infos = Schema.SObjectType.Opportunity.RecordTypeInfos;
        for (Schema.RecordTypeInfo info : infos) {
            if (info.DefaultRecordTypeMapping) {
                selectedOppRecordType = info.RecordTypeId;
            }
        }
        isCreateWithoutProduct = false;
        showExistingContactRoles = true;
        hideClosedOpportunities = true;
        showAllRecordTypes = false;
        isContactPage = true;
        
        if(String.isNotBlank(pricebookID))
        {
            for(String pBookId:pricebookID.split(','))
            {
                if(String.isNotBlank(pBookId))
                {
                    pricebookIDLst.add(pBookId.trim());
                }
            }
        }
        
        
        
        showEmailDomainMathes = false;
        showCampusAndDepartment = true;
        showRinggoldAndBP = false;
        showAccountSite = false;
        isNotValidEamilId = false; 
        leadId = ApexPages.currentPage().getParameters().get('id'); //getting lead from page to convert.
        if(leadId != null){
            List<Lead> leadList = [SELECT ID,Name,Street, City, State, PostalCode, Country,Email,ISBN__c,Ringgold__c,Course_Name__c,
                                    Course_Start_Date__c,Country_List__c,State_List__c,OwnerId,Anticipated_Enrollment__c,Lead_Qualifier__c,Promotion_Name__c,Lead_Source_Description__c,Solutions_Area_Interest__c,LeadSource,Market__c, Title,Company,Phone,Department__c,Job_Category__c,Publisher__c FROM Lead where id =: leadId];//CHG0038130
                                    
            if(leadList.size() > 0){
                leadObj = leadList[0];
                leadAddress = MiscFunctions.cleanAddress(leadObj.Street, leadObj.City, leadObj.State, leadObj.PostalCode, leadObj.Country, true);
                domainPart = (leadObj.Email != null) ? leadObj.Email.substring(leadObj.Email.indexOf('@') + 1) : null;
                if(leadObj.ISBN__c != null){
                    List<Product2> productList = [SELECT id, ProductCode, Lead_Author_Editor__c, Publisher__c, Version_Type__c, Business_Division__c, Text_Type__c FROM Product2 WHERE ProductCode = :leadObj.ISBN__c AND IsActive = true LIMIT 1];
                    if(productList != null && productList.size() > 0){
                        product = productList[0];
                        Lookup.Product__c = product.id;
                    }
                    else{
                        product = new Product2();
                    }
                }
              
            }
        }
        getCurrencies();
        searchContactsAndAccounts();
        getOppRTList();
    }

    public void init() {
    if(leadObj.Email != null)
        {
            try {
                update leadObj;
            } catch (Exception e) {
                if (e.getMessage().contains('INVALID_EMAIL_ADDRESS'))
                    errorMessage = 'The email address is not in a valid format.';
                else
                  errorMessage = e.getMessage();
                showErrorMessage = true; 
                isNotValidEamilId = true;
            }
        }
    }
    
    //Default initialization for all variables (Set, List, Map and others) with new keyword.    
    private void defaultInitialization(){
        ocrObj = new OpportunityContactRole();
        mapAddNewDept =new Map<Integer,List<SelectOption>>();
        oppProductOBj = new OpportunityLineItem();
        oppObj = new Opportunity();
        owList = new List<OpportunityWrapper>();
         pricebookIDLst = new List<String>();
        lookup = new Visualforce_Control__c();
        cawList = new List<ContactAccountWrapper>();    
    }
    
    //getting values from custom setting (CasCS__c)
    private void initializeFromCustomSetting(){
        contactRTId = CasCS__c.getValues('Contact_RT_Id').Value__c;
        accountRTId = CasCS__c.getValues('Account_RT_Id').Value__c;
        OpportunityRTIds = CasCS__c.getValues('Opportunity_RT_Ids').Value__c;
        pricebookID = (CasCS__c.getValues('Pricebook_Id') != null) ? CasCS__c.getValues('Pricebook_Id').Value__c : '01s0Y00000832dDQAQ';
    }
    
    
    // Functions used for pagination for Contact and Account records
    private integer counterContAcc =0;  //keeps track of the offset
    public integer list_sizeContAcc =10;//sets the page size or number of rows
    public integer total_sizeContAcc; //used to show user the total size of the list
    public PageReference PreviousContactAccount() { //user clicked previous button
      counterContAcc -= list_sizeContAcc;
      searchContactsAndAccounts();
      return null;
    }

    public PageReference NextContactAccount() { //user clicked next button
      counterContAcc += list_sizeContAcc;
      searchContactsAndAccounts();
      return null;
    }
    public Integer getPageNumberContactAccount() {
      return counterContAcc/list_sizeContAcc + 1;
    }
    public Integer getTotalPagesContactAccount() {
      if (math.mod(total_sizeContAcc, list_sizeContAcc) > 0) {
         return total_sizeContAcc/list_sizeContAcc + 1;
      } else {
         return (total_sizeContAcc/list_sizeContAcc);
      }
    }
    public Boolean getDisablePreviousContactAccount(){
       //this will disable the previous and beginning buttons
      if (counterContAcc>0) return false; else return true;
    }

    public Boolean getDisableNextContactAccount() {
        //this will disable the previous and beginning buttons
         if (counterContAcc + list_sizeContAcc < total_sizeContAcc) return false; else return true;
    }
    //creating list of Contact and Account to showing on first page of lead conversion
    public void searchContactsAndAccounts() {
        Map<String,List<SelectOption>> mapExistDeptOnCont = new Map<String,List<SelectOption>>();
        System.debug('showEmailDomainMathes=='+showEmailDomainMathes);
        cawList.clear();
        total_sizeContAcc = 0;
        //accountIdForUsedContactList.clear();
        Set<Id> accountIdForUsedContactList = new Set<Id>();
        String queryString = '';
        queryString = 'Select Id, AccountId,Account.Name,salutation,Account.Ringgold_Account_ID__c, Account.BP__c,Name, Account.Site, Email, Campus__c, Campus__r.Name, Department_Object__c,Contact_Type__c, Department_Object__r.Name, MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet, OtherCity,OtherCountry,OtherPostalCode,OtherState,OtherStreet from contact';
        String queryCount = 'Select count() from contact';
        // added debug here
        System.debug('@@@'+queryCount);
        String filterQuery;
        if(leadObj.Email != null){
            if(showEmailDomainMathes){
                filterQuery = ' where RecordTypeId = '+'\''+contactRTId+'\' AND (Name = '+'\''+ removeQuote(leadObj.Name) +'\' OR Email = '+'\''+removeQuote(leadObj.Email)+'\' OR EmailDomain__c = '+'\''+domainPart+'\')';
                queryCount +=' where RecordTypeId = '+'\''+contactRTId+'\' AND (Name = '+'\''+ removeQuote(leadObj.Name) +'\' OR Email = '+'\''+removeQuote(leadObj.Email)+'\' OR EmailDomain__c = '+'\''+domainPart+'\')';
            }else{
                filterQuery = ' where RecordTypeId = '+'\''+contactRTId+'\' AND (Name = '+'\''+ removeQuote(leadObj.Name) +'\' OR Email = '+'\''+removeQuote(leadObj.Email)+'\')';
                queryCount +=' where RecordTypeId = '+'\''+contactRTId+'\' AND (Name = '+'\''+ removeQuote(leadObj.Name) +'\' OR Email = '+'\''+removeQuote(leadObj.Email)+'\')';
            }
        }else{
            filterQuery = ' where RecordTypeId = '+'\''+contactRTId+'\' AND (Name = '+'\''+ removeQuote(leadObj.Name) +'\')';
            queryCount += ' where RecordTypeId = '+'\''+contactRTId+'\' AND (Name = '+'\''+ removeQuote(leadObj.Name) +'\')';
        }
        queryString += filterQuery ;
        System.debug('queryString=='+queryString);
        queryString += ' ORDER By LastModifiedDate Desc limit '+list_sizeContAcc+' OFFSET '+counterContAcc;
        List<Contact> contactList = new List<Contact>();
        contactList = Database.query(queryString);
        System.debug('queryCount'+queryString);
        List<Contact> contactCount = new List<Contact>();
        total_sizeContAcc = Database.countQuery(queryCount); 
        //total_sizeContAcc = contactCount.size();
        List<Id> contactsAcountIdSet = new List<Id>();
        Map<String, String> contactIdToAccountId = new Map<String, String>();
        Set<Id> campusIdSet = new Set<Id>();
        Map<String,String> deparmentIdMap = new Map<String,String>();
        
        for(Contact conObj : contactList){ 
            if(conObj.AccountId != null){ 
                contactsAcountIdSet.add(conObj.AccountId); //for getting all accounts which is in use
                contactIdToAccountId.put(conObj.Id, conObj.AccountId);
                if(conObj.Campus__c != null){
                    campusIdSet.add(conObj.Campus__c); //for getting all campuses which is in use
                }if(conObj.Department_Object__c != null){
                    deparmentIdMap.put(conObj.id,conObj.Department_Object__c);
                }
            }
            
        }
        Map<String,Account> contactIdToAccountMap = new Map<String,Account>();
        Map<String, List<SelectOption>> campusIdToDepartmentsMap = new Map<String, List<SelectOption>>();
        Map<String, List<SelectOption>> accIdToDepartmentsMap = new Map<String, List<SelectOption>>();
        Map<String, List<SelectOption>> accIdToCampusesMap = new Map<String, List<SelectOption>>();
        accIdToCampusesMap = createCOptionsMap(contactsAcountIdSet); 
        accIdToDepartmentsMap = createDOptionsMap(contactsAcountIdSet);
        mapExistDeptOnCont = createContactToCampus(deparmentIdMap);
        contactIdToAccountMap = createContactAccountMap(contactIdToAccountId);
        System.debug('campusIdSet'+campusIdSet);
        campusIdToDepartmentsMap =createCampusIdToDepartmentsMap(campusIdSet);
        List<SelectOption> campusOptions;
        List<SelectOption> departmentOptions;
        
        
        for(Contact contactObj : contactList){
            accountIdForUsedContactList.add(contactObj.AccountId); //all accounts id which is used in contact list. We will check this when fetching data from account.
            campusOptions = new List<SelectOption>();
            departmentOptions = new List<SelectOption>();
        system.debug('departmentOptions'+departmentOptions);
            if(contactObj.Campus__c == null && contactObj.Department_Object__c != null){    
               
                               
                     campusOptions = mapExistDeptOnCont.get(deparmentIdMap.get(contactObj.id));
                 }else if(contactObj.Campus__c != null && contactObj.Department_Object__c == null){
                     system.debug(contactObj.Campus__c+'campus');
                     system.debug('campusIdToDepartmentsMap'+campusIdToDepartmentsMap.get(contactObj.Campus__c));
                     system.debug('deptsize'+campusIdToDepartmentsMap.size());
                     if(campusIdToDepartmentsMap.size() == 0 || campusIdToDepartmentsMap.get(contactObj.Campus__c) == null){
                         system.debug('departmentOptions#####2222'+departmentOptions);
                          departmentOptions.add(new SelectOption('-None-','-None-'));

                       //  departmentOptions=departmentOptions new SelectOption('-None-','-None-');
                       //  departmentOptions= (List<SelectOption>)(new List<SelectOption>().add(new SelectOption('-None-','-None-')));
                         system.debug('departmentOptions#####2'+departmentOptions);
                     }else{
                         departmentOptions=(List<SelectOption>)campusIdToDepartmentsMap.get(contactObj.Campus__c);
                     }
                 
               // departmentOptions = (List<SelectOption>)(campusIdToDepartmentsMap.get(contactObj.Campus__c) != null ? campusIdToDepartmentsMap.get(contactObj.Campus__c) : new List<SelectOption>().add(new SelectOption('-None-','-None-')));                      
             system.debug('departmentOptions'+departmentOptions);
                 }else if(contactObj.Campus__c == null && contactObj.Department_Object__c == null){
                campusOptions = (List<SelectOption>)(accIdToCampusesMap.get(contactObj.AccountId) != null ? accIdToCampusesMap.get(contactObj.AccountId) : new List<SelectOption>().add(new SelectOption('-None-','-None-'))); 
                departmentOptions = (List<SelectOption>)(accIdToDepartmentsMap.get(contactObj.AccountId) != null ? accIdToDepartmentsMap.get(contactObj.AccountId) : new List<SelectOption>().add(new SelectOption('-None-','-None-'))); 
            }
            Account accountObj = contactIdToAccountMap.get(contactObj.Id) != null ? contactIdToAccountMap.get(contactObj.Id) : null;
            
            cawList.add(new ContactAccountWrapper(contactObj, accountObj, cawList.size()+1, campusOptions, departmentOptions)); //creating wrapper object for Contact
        }
     
          
        String accQuery =  'select id, name, BP__c, Site, Ringgold_Account_ID__c, RecordTypeId, BillingCity,BillingCountry,BillingState,BillingStreet,BillingPostalCode from Account'; 
        if(leadObj.Ringgold__c != null){
            if(accountIdForUsedContactList.size() > 0){
             accQuery += ' where (RecordTypeId = '+'\''+accountRTId+'\' AND Id not in '+refineListForDQuery(accountIdForUsedContactList)+') AND (Name = '+'\''+ removeQuote(leadObj.Name) +'\' OR Ringgold_Account_ID__c = '+'\''+leadObj.Ringgold__c+'\')';
            }else{
                accQuery += ' where RecordTypeId = '+'\''+accountRTId+'\'  AND (Name = '+'\''+ removeQuote(leadObj.Name) +'\' OR Ringgold_Account_ID__c = '+'\''+leadObj.Ringgold__c+'\')';
            }       
        }else{
            if(accountIdForUsedContactList.size() > 0){
                accQuery += ' where (RecordTypeId = '+'\''+accountRTId+'\' AND Id not in '+refineListForDQuery(accountIdForUsedContactList)+') AND (Name = '+'\''+ removeQuote(leadObj.Name) +'\')';
            }else{
                accQuery += ' where RecordTypeId = '+'\''+accountRTId+'\'  AND (Name = '+'\''+ removeQuote(leadObj.Name) +'\')';
            } 
        }
        
        accQuery += ' ORDER By LastModifiedDate Desc limit 10';
        List<Account> accountList = new List<Account>();
        accountList = Database.query(accQuery);
       
        for(Account accObj : accountList){
          cawList.add(new ContactAccountWrapper(null, accObj, cawList.size()+1, null, null)); //creating wrapper object for Account
        }
        
        cawList.add(new ContactAccountWrapper(null, null, cawList.size()+1, null, null)); //creating wrapper object for Lookeup Account/new Contact
        
    
    }
    //Wrapper class for Contact/Account list which will show on first page of lead conversion.
    public class ContactAccountWrapper {
        public Integer index {get; set;}
        public Boolean isContact {get; set;}
        public Contact contactObj {get; set;}
        public Account accountObj {get; set;}
        public boolean checked { get; set;}
        public String contactMailingAddress { get; set; }
        public String accountMailingAddress { get; set; }
        public String contactOtherAddress { get; set; }
        public List<SelectOption> campusOptions {get; set;}
        public List<SelectOption> departmentOptions {get; set;}
        public String departmentId {get; set;}
        public String campusId {get; set;}
        public Boolean isLookup {get; set;}
        public Boolean isLookupButton {get; set;}
        
        
        public ContactAccountWrapper(Contact contactObj, Account accountObj, Integer index, List<SelectOption> campusOptions, List<SelectOption> departmentOptions){
            if(contactObj == null && accountObj == null){//create new Account
                this.campusOptions = new List<SelectOption>();
                this.departmentOptions = new List<SelectOption>();
                isLookup = true;
                isLookupButton = false;
                this.checked = false;
            }else if(contactObj == null){//Account
                this.campusOptions = new List<SelectOption>();
                this.departmentOptions = new List<SelectOption>();
                isContact = false;
                this.accountObj = accountObj;
                this.accountMailingAddress = MiscFunctions.cleanAddress(accountObj.BillingStreet, accountObj.BillingCity, accountObj.BillingState, accountObj.BillingPostalCode, accountObj.BillingCountry, true);
                this.checked = false;
                if(campusOptions == null){
                    campusOptions = new List<SelectOption>();
                    campusOptions.add(new SelectOption('-None-','-None-'));         
                }
                else {
                    campusOptions.add(new SelectOption('-None-','-None-'));
                }
                if(departmentOptions == null)
                {
                    departmentOptions = new List<SelectOption>();
                    departmentOptions.add(new SelectOption('-None-','-None-'));
                }
                else {
                    departmentOptions.add(new SelectOption('-None-','-None-'));
                }
                if(accountObj.Campuses__r != null && accountObj.Campuses__r.size() >0){
                    for(Campus__c cObj : accountObj.Campuses__r){
                        campusOptions.add(new SelectOption(cObj.Id, cObj.Name));
                    }
                }
                if(accountObj.Departments__r != null && accountObj.Departments__r.size() >0){
                    for(Department__c dObj : accountObj.Departments__r){
                        departmentOptions.add(new SelectOption(dObj.Id, dObj.Name));
                    }
                }
                isLookup = false;
            }else{//Contact
                isContact = true;
                this.contactObj = contactObj;
                this.contactMailingAddress = MiscFunctions.cleanAddress(contactObj.MailingStreet, contactObj.MailingCity, contactObj.MailingState, contactObj.MailingPostalCode, contactObj.MailingCountry, true);
                this.contactOtherAddress = MiscFunctions.cleanAddress(contactObj.OtherStreet, contactObj.OtherCity, contactObj.OtherState, contactObj.OtherPostalCode, contactObj.OtherCountry, true);
                this.checked = false;
                if(contactObj.Campus__c != null){
                    campusId = contactObj.Campus__c;
                }
                 if(contactObj.Department_Object__c != null){
                    departmentId = contactObj.Department_Object__c;
                }
                this.campusOptions = campusOptions;
                this.departmentOptions = departmentOptions;
                this.accountObj = accountObj;
                isLookup = false;
            }
            this.index = index;
        }
    }
    
    public PageReference previous(){
        isContactPage = true;
        return null;
    }
    
    public PageReference cancel(){
        PageReference pg = new PageReference('/'+leadObj.Id);
        pg.setRedirect(true);
        return pg;
    }

    //called from page when we click on next button to move for second page.
    public PageReference next(){
        showErrorMessage = false;
        Integer countCheck = 0;
        Integer countIndex = 0;
        for(ContactAccountWrapper cawObj : cawList){
            if(cawObj.checked){
                countCheck++;
                countIndex = cawObj.index;
                
            }
        }
        if(countCheck == 1){
            
            firstPageSelectedRecord = cawList[countIndex - 1];
            indexCampusDepartmentUpdate = countIndex;
            if(firstPageSelectedRecord.isLookup){
                if(lookup.Account__c == null){
                    errorMessage = 'Please select account for this record';
                    showErrorMessage = true;
                    return null;
                }else{
                    firstPageSelectedRecord.accountObj = [select id,name from Account where id=:lookup.Account__c LIMIT 1];
                    selectedAccountForOpportunity = firstPageSelectedRecord.accountObj.Id;
                    selectedContactForOpportunity = null;
                }
            }else{
                if(firstPageSelectedRecord.contactObj != null){
                    selectedAccountForOpportunity = firstPageSelectedRecord.contactObj.AccountId;
                    selectedContactForOpportunity = firstPageSelectedRecord.contactObj.Id;
                }else{
                    selectedAccountForOpportunity = firstPageSelectedRecord.accountObj.Id;
                }
            }
            //isContactPage = false;
            
            checkPastOpps(true);
            
        }else{
            errorMessage = 'Please select at least one record';
            showErrorMessage = true;
            return null;
        }
        getProductDetail();
        searchOpportunities();      
        return null;
    }
    
    //called from page when we checked for longer search with domain name
    public void searchByDomain(){
        searchContactsAndAccounts();
    }
    
    //called from page when clicked on any of the filterd checkboxes, We are filterning query on the basis of that checkboxes
    public void manageChecks1(){
        searchOpportunities();
    }
    
    
    //getting department dropdown on the basis of campus id - Updated CHG0033734
    public void getDepartmentDropDown(){
        //System.debug('wrapperIndex=='+wrapperIndex);
        List<SelectOption> retVal = new List<SelectOption>();
        retVal.add(new SelectOption('-None-','-None-'));
        if(wrapperIndex != null){
            Integer index = Integer.valueOf(wrapperIndex);
            if(campusID =='-None-'){
                if(cawList[index-1].isLookup){
                    for(Department__c dObj : [Select id, name from Department__c where Account__c =: lookup.Account__c ORDER BY Name,LastModifiedDate LIMIT 300]){
                                System.debug('dObj =='+dObj );

                        retVal.add(new SelectOption(dObj.Id, dObj.Name));
                    }
                }else{
                    for(Department__c dObj : [Select id, name from Department__c where Account__c =: cawList[index-1].accountObj.Id AND Campus__c =: '' ORDER BY Name,LastModifiedDate LIMIT 300]){
                        retVal.add(new SelectOption(dObj.Id, dObj.Name));
                    }
                }
                //Cheching new added Department in map
                if(mapAddNewDept != null)
                {
                    if(mapAddNewDept.containskey(index-1)){
                        List<SelectOption> lstNewDept = mapAddNewDept.get(index-1);
                        for(SelectOption options: lstNewDept){
                            retVal.add(options);
                        }
                    }
                }
            }
            else{
                for(Department__c dObj : [Select id, name from Department__c where Campus__c =: campusID ORDER BY Name,LastModifiedDate LIMIT 300]){
                                                System.debug('dObj =='+dObj );

                    retVal.add(new SelectOption(dObj.Id, dObj.Name));
                }
                
                //Piyush Change
                if(mapAddNewDept != null)
                {
                    if(mapAddNewDept.containskey(index-1)){
                        List<SelectOption> lstNewDept = mapAddNewDept.get(index-1);
                        for(SelectOption options: lstNewDept){
                            retVal.add(options);
                        }
                    }
                }
            }
            system.debug('retVal'+retVal);
            cawList[index-1].departmentOptions = retVal;
           
        }
        
    }
    
    //getting all campuses drop down on the basis of account id
    public void getAllCampusDropDown(){
        List<SelectOption> retVal = new List<SelectOption>();
        retVal.add(new SelectOption('-None-','-None-'));
        if(wrapperIndex != null){
            Integer index = Integer.valueOf(wrapperIndex);
            for(Campus__c cObj : [Select id, name from Campus__c where Account__c =: lookup.Account__c ORDER BY Name,LastModifiedDate LIMIT 300]){
                retVal.add(new SelectOption(cObj.Id, cObj.Name));
            }
            cawList[index-1].campusOptions = retVal;
            cawList[index-1].isLookupButton = true;
        }
    }
    
    //getting all departments drop down on the basis of account id - Updated CHG0033734
    public void getAllDepartmentDropDown(){
        List<SelectOption> retVal = new List<SelectOption>();
        retVal.add(new SelectOption('-None-','-None-'));
        if(wrapperIndex != null){
            Integer index = Integer.valueOf(wrapperIndex);
           
            for(Department__c dObj : [Select id, name from Department__c where Account__c =: lookup.Account__c ORDER BY Name,LastModifiedDate LIMIT 300]){
                retVal.add(new SelectOption(dObj.Id, dObj.Name));
            }
            cawList[index-1].departmentOptions = retVal;
        }
        
    }
    
    //getting campus dropdown on the basis of accountid on change
    public void getCampusDropDown(){
        //System.debug('wrapperIndex=='+wrapperIndex);
        List<SelectOption> retVal = new List<SelectOption>();
        retVal.add(new SelectOption('-None-','-None-'));
        if(wrapperIndex != null){
            Integer index = Integer.valueOf(wrapperIndex);
            for(Campus__c cObj : [Select id, name from Campus__c where Account__c =: lookup.Account__c ORDER BY Name,LastModifiedDate LIMIT 300]){
                retVal.add(new SelectOption(cObj.Id, cObj.Name));
            }
            cawList[index-1].campusOptions = retVal;
            cawList[index-1].isLookupButton = true;
        }
        getAllDepartmentDropDown();
    }
    
    //use to short record on page
    public String sortExpression{
        get{
            return sortExp;
        }
        set{
            //if the column is clicked on then switch between Ascending and Descending modes
            if (value == sortExp)
             sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            else
            sortDirection = 'DESC';
            sortExp = value;
        }
    }

    //use to short record on page
    public String getSortDirection(){
        //if not column is selected 
        if (sortExpression == null || sortExpression == '')
          return 'DESC';
        else
         return sortDirection;
    }
    //use to short record on page
    public void setSortDirection(String value){
       sortDirection = value;
    }
    
    //crating opportunity list for showing on second page of lead conversion
    public void searchOpportunities() {
        string sortFullExp = sortExpression  + ' ' + sortDirection;
        if(!isCreateWithoutProduct){
            OpporIndexPoint = '-1';
        }
        //total_size = 0;
        if(!isContactPage){
            Boolean isNewC = false;
            owList.clear();
            createOpportunityPopUpFields();
            Set<Id> oppIdsToInclude = new Set<Id>();
            List<OpportunityContactRole> ocrs = [SELECT Id, OpportunityId FROM OpportunityContactRole WHERE ContactId = :selectedContactForOpportunity  LIMIT 500];
                        for (OpportunityContactRole ocr : ocrs) {
                            oppIdsToInclude.add(ocr.OpportunityId);
                        }  
                        //System.debug('oppIdsToInclude=='+oppIdsToInclude);
            //System.debug('selectedopprt=='+selectedOppRecordType);
            String queryString = 'SELECT id,pricebook2Id,pricebook2.Name, Name, Course_Start_Date__c,Number_of_Students__c, CurrencyIsoCode, Amount, StageName, CloseDate, OwnerId, Owner.Name, RecordTypeId, RecordType.Name  from Opportunity';
            queryString += ' WHERE  AccountId = '+'\''+selectedAccountForOpportunity+'\'';
            String sCountquery ='SELECT id from Opportunity ';
            sCountquery += ' WHERE  AccountId = '+'\''+selectedAccountForOpportunity+'\'';
            if(!showAllRecordTypes){
                queryString += ' AND  RecordtypeId = '+'\''+selectedOppRecordType+'\'';
                sCountquery += ' AND  RecordtypeId = '+'\''+selectedOppRecordType+'\'';
            }
            if(hideClosedOpportunities){
                queryString += ' AND IsClosed = FALSE';
                sCountquery += ' AND IsClosed = FALSE';
            }
            if(!showExistingContactRoles){
                if(oppIdsToInclude.size()>0){
                    queryString += ' AND Id IN '+refineListForDQuery(oppIdsToInclude);
                    sCountquery += ' AND Id IN '+refineListForDQuery(oppIdsToInclude);
                }else{
                    isNewC = true;
                    queryString +=' ORDER BY '+sortFullExp +' LIMIT 0';
                    total_size = 0;
                }
            }
            
            if(!isNewC){
                queryString +=' ORDER BY '+sortFullExp +' limit '+list_size+' OFFSET '+counter;
                List<Opportunity> opportunityListCount = new List<Opportunity>();
                opportunityListCount = Database.query(sCountquery +' limit 2000');
                total_size = opportunityListCount.size();
            }
            
            //System.debug('queryString11=='+queryString);
            List<Opportunity> opportunityList = new List<Opportunity>();
            opportunityList = Database.query(queryString);
            //System.debug('opportunityList'+opportunityList);
            for(Opportunity o : opportunityList){
                owList.add(new OpportunityWrapper(o, owList.size()+1, false,selectedOppRecordType));
            }
            owList.add(new OpportunityWrapper(null, owList.size()+1, true, selectedOppRecordType));
        }
    }
    
    //Wrapper class for opportunities
    public class OpportunityWrapper {
        
        public Integer index {get; set;}
        public Opportunity oObj {get; set;}
        public Boolean checked {get; set;}
        public Boolean isNewCreation {get; set;}
        public Boolean isOtherRT {get; set;}
        
        public OpportunityWrapper(Opportunity oObj, Integer index, Boolean isNewCreation, String selectedOppRecordType){
            if(isNewCreation){ //for new creation
                this.isNewCreation = isNewCreation;
                this.index = index;
                isOtherRT = false;
                checked = false;
            }else{ //for existing opportunities
                if(oObj != null) //[MES-21]-change 1 by Renil Rejith.
                {
                    this.oObj = oObj;
                    this.index = index;
                    this.isNewCreation = isNewCreation;
                    if(oObj.RecordTypeId != null && oObj.RecordTypeId == selectedOppRecordType){
                        isOtherRT = false;  
                    }else{
                        isOtherRT = true;
                    } 
                    checked = false;
                }
            }
        }
    }
    
    //crating campus and department on finish of lead conversion page
    public void createCampusDepartment(){
        try{
            String campusId = '';
            String departmentId = '';
            campusId = cawList[indexCampusDepartmentUpdate - 1].campusId;
            departmentId = cawList[indexCampusDepartmentUpdate - 1].departmentId;
            Campus__c cObj;
            Department__c dObj;
            System.debug('campusJsonString'+campusJsonString);
            if(campusId != null && campusId.contains('NewCampus')){
                cObj = new Campus__c();
                if(campusJsonString != null && campusJsonString !='' && String.isNotBlank(campusJsonString)){
                    Map<String, Object> cObjMap = (Map<String, Object>) JSON.deserializeUntyped(campusJsonString);
                    for(String s : cObjMap.keySet()){
                        if(cObjMap.get(s) != null && cObjMap.get(s) != 'null'){
                            cObj.put(s, cObjMap.get(s));
                        }
                    }
                    cObj.Account__c = convertedAccount.Id;
                    insert cObj;
                    convertedContact.Campus__c = cObj.Id;
                    update convertedContact;
                }
            }
            else{
                if(campusId != null && campusId !='-None-'){
                    convertedContact.Campus__c = campusId; 
                    update convertedContact;
                }
            }
            if(departmentId != null && departmentId.contains('NewDepartment')){
                //System.debug('departmentJsonString'+departmentJsonString);
                dObj = new Department__c();
                if(departmentJsonString != null && departmentJsonString !='' && String.isNotBlank(departmentJsonString)){
                    Map<String, Object> dObjMap = (Map<String, Object>) JSON.deserializeUntyped(departmentJsonString);
                    for(String s : dObjMap.keySet()){
                        if(dObjMap.get(s) != null && dObjMap.get(s) != 'null')
                        dObj.put(s, dObjMap.get(s));
                    }
                   if(campusId != null && campusId !='-None-' && !campusId.contains('NewCampus'))
                        dObj.Campus__c = campusId;
                    else if(cObj != null)
                        dObj.Campus__c = cObj.Id;
                    dObj.Account__c = convertedAccount.Id;
                    insert dObj;
                    convertedContact.Department_Object__c = dObj.Id;
                    update convertedContact;
                }
            }
            else{
                if(departmentId != null && departmentId !='-None-'){
                    convertedContact.Department_Object__c = departmentId;
                    update convertedContact;
                }
            }
        }catch(Exception e){
            System.debug('Error :'+e.getMessage()+'Error Number'+e.getLineNumber());
            
        }
    }
    
    //getting all opportunities recordtypes to showing on opportunityPage (second page) of lead conversion (id stored in custom setting)
    public List<SelectOption> getOppRTList(){
        List<SelectOption> oppRTList = new List<SelectOption>();
       
        for(RecordType rt : Database.query('SELECT Id, name, developerName FROM RecordType WHERE sObjectType = \'Opportunity\' AND id in '+getListFromString(OpportunityRTIds) +' order by name  LIMIT 20')){
            //if(rt.developerName.contains('T&F')){
                oppRTList.add(new SelectOption(rt.Id, rt.name));
                //rtSet.add(rt.Id);
            //}
        }
        createoppRTToVFSectionMap();
        return oppRTList;
        
    }
    
    //creating opportuniy's popup fields to shown on opportunityPage (second page) of lead conversion
    public void createOpportunityPopUpFields(){
        if(!isCreateWithoutProduct){
            oppObj.Name = leadObj.Course_Name__c;
          
            oppObj.CurrencyIsoCode = [SELECT DefaultCurrencyIsoCode FROM User WHERE Id = :Userinfo.getUserId()].DefaultCurrencyIsoCode; //CHG0065665 - default currency should be the currency of the user who is converting the Lead
           
            oppObj.OwnerId = getDefaultOppOwner();
            oppObj.Course_Start_Date__c = leadObj.Course_Start_Date__c;
         
            oppObj.closeDate = Date.today();
        }
    }
    
    public Boolean showAccessPeriod {
        get {
            if (oppProductOBj.Order_Type__c != null && oppProductOBj.Order_Type__c.contains('Vitalsource e-Exam copy') ){
                return true;
                }
            else{
                return false; }
        }
        set;
    }
    
    
    
    //refining list of database query, getting string format from set of ides
    public String refineListForDQuery(Set<Id> idSet){
        String retVal='(';
        for(String idString : idSet){
            retVal += '\''+idString+'\',';
        }
        retVal = retVal.subString(0, retVal.length()-1);
        retVal += ')';
        return retVal;
    }
    
    //refining list of database query, getting string format from comma seperated values of string
    public String getListFromString(String ids){
        //System.debug('ids=='+ids);
        String retVal='(';
        for(String idString : ids.split(',')){
            retVal += '\''+idString.trim()+'\',';
        }
        retVal = retVal.subString(0, retVal.length()-1);
        retVal += ')';
        return retVal;
         
    }
    
    //creating a map which is used on page for selecting section of opportuniy to show on perticular record type of opportunity. (on changing on recordtype dropdown)
    public void createoppRTToVFSectionMap(){
        //Map<String, String> oppRTToVFSectionMap = new Map<String, String>(); //[MES-21]-change 2 commneted by Renil Rejith
        List<CasCS__c> casCSList = [Select id, Name, value__c from CasCS__c where name LIKE 'opbs%'];
        for(CasCS__c cCSOBJ : casCSList){
            oppRTToVFSectionMap.put(cCSOBJ.value__c, cCSOBJ.name);
        }

        if(oppRTToVFSectionMap.get(selectedOppRecordType) != null && oppRTToVFSectionMap.get(selectedOppRecordType) == 'opbs1'){
             renderedSection1 = true;
             renderedSection2 = false;
             renderedSection3 = false;
             renderedSection4 = false;
             renderedSection5 = false;
        }else if(oppRTToVFSectionMap.get(selectedOppRecordType) != null && oppRTToVFSectionMap.get(selectedOppRecordType) == 'opbs2'){
             renderedSection1 = false;
             renderedSection2 = true;
             renderedSection3 = false;
             renderedSection4 = false;
             renderedSection5 = false;
        }else if(oppRTToVFSectionMap.get(selectedOppRecordType) != null && oppRTToVFSectionMap.get(selectedOppRecordType) == 'opbs_Corporate'){ //Corporate changes
             renderedSection1 = false;
             renderedSection2 = false;
             renderedSection3 = false;  
             renderedSection4 = true;
             renderedSection5 = false;
        }else if(oppRTToVFSectionMap.get(selectedOppRecordType) != null && (oppRTToVFSectionMap.get(selectedOppRecordType) == 'opbs_F1000_Article' || oppRTToVFSectionMap.get(selectedOppRecordType) == 'opbs_F1000_Collection' || oppRTToVFSectionMap.get(selectedOppRecordType) == 'opbs_F1000_Advisory_Board' || oppRTToVFSectionMap.get(selectedOppRecordType) == 'opbs_TF_Commissioning_Guest_Advisor')){ //F1000 Record Type changes.
             renderedSection1 = false;
             renderedSection2 = false;
             renderedSection3 = false;  
             renderedSection4 = false;
             renderedSection5 = true;
        }else{
             renderedSection1 = false;
             renderedSection2 = false;
             renderedSection3 = true;
             renderedSection4 = false;
             renderedSection5 = false;
             if(!checkContainOppRecTypeID(selectedOppRecordType)){
                 selectedOppRecordType = '0122X000000KDOZQA4'; //T&F - Global Corporate / Special Sales Opportunity
             }
             
        }
        searchOpportunities();
    }
    
    
    public Boolean checkContainOppRecTypeID(String sSelectedOppRecordType){
        for(RecordType rt : Database.query('SELECT Id, name, developerName FROM RecordType WHERE sObjectType = \'Opportunity\' AND id in '+getListFromString(OpportunityRTIds) +' order by name  LIMIT 20')){
            if(selectedOppRecordType == rt.Id)
            {
                return true;
            }
        }
        return false; 
    }
    
    //getting product detail
    public void getProductDetail() {
        if (Lookup.Product__c != null) {
            product = [SELECT id, ProductCode,  Lead_Author_Editor__c, Publisher__c, Version_Type__c,
                            Business_Division__c, Text_Type__c
                       FROM Product2
                       WHERE Id = :Lookup.Product__c LIMIT 1];
            isChangeCat1 =false;
            checkPastOpps(false);
            //Get Opp Owner
        } else {
            product = new Product2();
            checkPastOpps(false);
        }
        
    }
    
    //get Default Opp Owner
    public id getDefaultOppOwner() {
        List<Setting_Item__c> settingItems = [SELECT User_1__c
                                              FROM Setting_Item__c
                                              WHERE Setting__r.Name = 'CAS Opp Owner Map'
                                                AND Text_1__c = :leadObj.Country_List__c
                                                AND Text_2__c = :leadObj.State_List__c
                                              LIMIT 1];
        if (settingItems.size() > 0)
            return settingItems[0].User_1__c;
        else if (String.valueOf(leadObj.OwnerId).StartsWith('005'))
            return leadObj.OwnerId;
        else
            return Userinfo.getUserId();
    }
    
    //final button on page to finish the lead conversion process
    public PageReference finish(){
        Savepoint sp = Database.setSavepoint(); //getting save poing which may be used later for rollback
		
        try{
            if(oppRTToVFSectionMap.get(selectedOppRecordType) != null)
            {
                System.debug('selectedOppRecordType**** '+oppRTToVFSectionMap.get(selectedOppRecordType));
                //[MES-21] - change 3 added If and Else statement by Renil Rejith
				//[MES-178] - change 1 added another condition in If Statement by Renil Rejith.
                if(!oppRTToVFSectionMap.get(selectedOppRecordType).contains('opbs_F1000') && !oppRTToVFSectionMap.get(selectedOppRecordType).contains('opbs_TF_Commissioning')/* && oppRTToVFSectionMap.get(selectedOppRecordType) != null*/)
                { 
                    showErrorMessage = false;
                    Integer countCheck = 0;
                    Integer countIndex = 0;
                    
                    
                    if(OpporIndexPoint == '-1'){
                        errorMessage = 'Please select at least one opportunity, or select to create a new opportunity';
                        showErrorMessage = true;
                        return null;
                    }else{
                        countIndex = Integer.valueOf(OpporIndexPoint);
                        selectedOpportunityWrapper = owList[countIndex];
                    }
                    if(selectedOpportunityWrapper.isNewCreation) {
                        if(renderedSection1){
                            if(oppObj.Course_Start_Date__c == null || leadObj.Anticipated_Enrollment__c == null || ocrObj.Role == null || selectedLevel1 == null || selectedLevel1 == '--None--' || oppObj.Name == null || oppObj.CurrencyIsoCode == null || oppObj.OwnerId == null || oppProductOBj.IC_Quantity__c == null || oppProductOBj.Order_Type__c == null || oppProductOBj.Feedback_Notification__c == null ){
                                errorMessage = 'Please fill out all Red and Blue mandatory fields.';
                                showErrorMessage = true;
                                return null;
                            }
                            else if((oppProductOBj.VitalSource_Access_Period__c == null || oppProductOBj.VitalSource_Access_Period__c =='--None--') && (oppProductOBj.Order_Type__c == 'Vitalsource e-Exam copy' || oppProductOBj.Order_Type__c == 'CRC Vitalsource e-Exam copy' || oppProductOBj.Order_Type__c == 'HSS Vitalsource e-Exam copy')){
                                errorMessage = 'Please fill out all Red and Blue mandatory fields.';
                                showErrorMessage = true;
                                return null;
                            }
                        }else if(renderedSection2){
                            if(oppObj.Name == null || oppObj.CurrencyIsoCode == null || oppObj.OwnerId == null || oppObj.Volume_Year__c == null || ocrObj.Role == null){
                                errorMessage = 'Please fill out all Red and Blue mandatory fields.';
                                showErrorMessage = true;
                                return null;
                            }
                        }else{
                            if(oppObj.CloseDate == null || oppObj.CurrencyIsoCode == null || oppObj.OwnerId == null || ocrObj.Role == null){
                                errorMessage = 'Please fill out all Red and Blue mandatory fields.';
                                showErrorMessage = true;
                                return null;
                            }
                        }
                        
                        //Checking Current CurrencyIsoCode is same for selected product for opp.
                        if(oppObj.CurrencyIsoCode != null && Lookup != null && Lookup.Product__c != null)
                        {
                            List<PricebookEntry> lstPBECurISOCode = [SELECT Id, CurrencyIsoCode FROM PricebookEntry  WHERE Product2Id = :lookup.Product__c AND Pricebook2Id IN :pricebookIDLst AND CurrencyIsoCode =: oppObj.CurrencyIsoCode  LIMIT 10];
                            //System.debug('lstPBECurISOCode'+lstPBECurISOCode);
                            if(lstPBECurISOCode.size() ==0)
                            {
                                errorMessage = 'You have chosen "'+oppObj.CurrencyIsoCode+'" opportunity linked to the "'+getPricebookNames()+'", but your Product is not available to be sold in that Pricebook or Currency.';
                                
                                showErrorMessage = true;
                                return null;
                            }
                        }
                    }else{
                        if(renderedSection1){
                            
                            if(oppObj.Course_Start_Date__c == null || leadObj.Anticipated_Enrollment__c == null || ocrObj.Role == null || oppProductOBj.Order_Type__c == null || oppProductOBj.Feedback_Notification__c == null){
                                errorMessage = 'Please fill out all Blue mandatory fields.';
                                showErrorMessage = true;
                                return null;
                            }
                            else if((oppProductOBj.VitalSource_Access_Period__c == null || oppProductOBj.VitalSource_Access_Period__c =='--None--') && (oppProductOBj.Order_Type__c == 'Vitalsource e-Exam copy' || oppProductOBj.Order_Type__c == 'CRC Vitalsource e-Exam copy' || oppProductOBj.Order_Type__c == 'HSS Vitalsource e-Exam copy')){
                                errorMessage = 'Please fill out all Blue mandatory fields.';
                                showErrorMessage = true;
                                return null;
                            }
                        }else if(renderedSection2){
                            if(ocrObj.Role == null){
                                errorMessage = 'Please fill out all Blue mandatory fields.';
                                showErrorMessage = true;
                                return null;
                            }
                        }else{
                            
                            if(ocrObj.Role == null){
                                errorMessage = 'Please fill out all Blue mandatory fields.';
                                showErrorMessage = true;
                                return null;
                            }
                        }
                        
                        //Checking Current CurrencyIsoCode is same for selected product for opp.
                        if(oppObj.CurrencyIsoCode != null && lookup != null && lookup.Product__c != null)
                        {
                            
                            List<PricebookEntry> lstPBECurISOCode = [SELECT Id, Pricebook2.Name, CurrencyIsoCode FROM PricebookEntry  WHERE Product2Id = :lookup.Product__c AND Pricebook2Id =:selectedOpportunityWrapper.oObj.pricebook2Id AND CurrencyIsoCode =: selectedOpportunityWrapper.oObj.CurrencyIsoCode  LIMIT 10];
                            
                            
                            
                            if(lstPBECurISOCode.size() ==0)
                            {
                                
                                if(selectedOpportunityWrapper.oObj.pricebook2.Name != null)
                                {
                                    errorMessage = 'You have chosen "'+selectedOpportunityWrapper.oObj.CurrencyIsoCode+'" opportunity linked to the "'+selectedOpportunityWrapper.oObj.pricebook2.Name+'", but your Product is not available to be sold in that Pricebook or Currency.  Please select another Product.';
                                    showErrorMessage = true;
                                    return null;
                                }
                                else{
                                    
                                    String sPricebookID = (CasCS__c.getValues('Pricebook_Id') != null) ? CasCS__c.getValues('Pricebook_Id').Value__c : '01s0Y00000832dDQAQ';
                                    if(sPricebookID != null  && String.isNotBlank(sPricebookID)){
                                        Opportunity objOpp = selectedOpportunityWrapper.oObj;
                                        //String[] priceBook =sPricebookID.split(',')[0]; 
                                        objOpp.pricebook2Id = sPricebookID.split(',')[0];
                                        update objOpp;
                                        selectedOpportunityWrapper.oObj.pricebook2Id = sPricebookID.split(',')[0];
                                    }
                                    else{
                                        errorMessage = 'You have chosen "'+selectedOpportunityWrapper.oObj.CurrencyIsoCode+'" opportunity which is not linked to any pricebook. Please select another opportunity';
                                        showErrorMessage = true;
                                        return null;
                                    }
                                }
                            }
                        }
                        
                    }
                    if(product == null || product.ProductCode == null){
                        
                        if(!isCreateWithoutProduct)
                        {       
                            isCreateWithoutProduct=true;
                            return null;
                        }
                    }
                    if(isCreateWithoutProduct){
                        product = new Product2();
                        isCreateWithoutProduct = false;
                    }              
                }
                else {
                    // When no Opporunity is selected added by Renil Rejith on 14/06/2022 to fix F1000 issue
                    if(Integer.valueOf(OpporIndexPoint) == -1)
                    {
                        selectedOpportunityWrapper = new OpportunityWrapper(null, owList.size()+1, false, selectedOppRecordType);
                    }
                    //when exisitng Opporunity is selected added by Renil Rejith on 14/06/2022 to fix F1000 issue
                    else{
                        Integer countIndex = 0;
                        countIndex = Integer.valueOf(OpporIndexPoint);
                        selectedOpportunityWrapper = owList[countIndex];
                    }
                    System.debug('selectedOpportunityWrapper*** '+selectedOpportunityWrapper);
                }
                return performLeadConvert();
            }
        }
        catch(Exception ex){
            errorMessage = ex.getMessage();
            parseError(errorMessage);
            showErrorMessage = true;
            Database.rollback(sp);
                        
        }
        return null;
        
        /*
        
        
        You have chosen 'GBP' opportunity linked to the 'T&F Pricebook', but your Product is not available to be sold in that Pricebook or Currency.  Please select another Product."
        
        */
        
    }
    
    // use to parse error message
    public void parseError(String errorMessage)
    {
        try{
            String[] errMsg = errorMessage.split(':');
            if(errMsg.size() > 1){
                //String errMsg2 = errMsg[1].substring(errMsg[1].indexOf(','),errMsg[1].length);
                this.errorMessage = errMsg[1].substring(errMsg[1].indexOf(',')+1,errMsg[1].length());
                if(this.errorMessage.contains('duplicate value found'))
                {
                    this.errorMessage ='A contact with this same Email address already exists.';
                }
                else if(this.errorMessage.contains('field integrity exception')){
                    this.errorMessage ='Please select another product. This Product is not active.';
                }
            }
        }
        catch(Exception ex){
            this.errorMessage= errorMessage;
        }       
    }
    
    public Boolean isCreateWithoutProduct{get;set;}
    public PageReference closedPopup_ProductCancel(){
        isCreateWithoutProduct = false;
        return null;
    }
    
    public PageReference closedPopup_ProductContinue(){
        isCreateWithoutProduct = true;
        finish();
        return null;
    }
    
    //performing lead conversion
    public Pagereference performLeadConvert() {
        
        //System.debug('performLeadConvert==');
        showErrorMessage = false;
        
        //Get PricebookEntryId 
        PricebookEntry pbe;
        String currencyCode;
        
        //[MES-21]-change 4 by Renil Rejith
        if(selectedOpportunityWrapper.oObj == null) {
            currencyCode = oppObj.CurrencyIsoCode;
        }else{
            currencyCode = selectedOpportunityWrapper.oObj.CurrencyIsoCode;
        }
        
        //Setup Lead Convert
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(leadObj.Id);
        lc.setConvertedStatus('Qualified'); 
        lc.setOwnerId(oppObj.ownerId);
        
        if (selectedOpportunityWrapper.oObj == null && oppRTToVFSectionMap.get(selectedOppRecordType) != null && Integer.valueOf(OpporIndexPoint) != -1){
            //System.debug('Creates Opp');
            lc.setDoNotCreateOpportunity(false);     
        }
        else{
            //System.debug('Does not Create Opp');
            lc.setDoNotCreateOpportunity(true);
        }
        String billingCity = '';
        String billingCountry = '';
        String billingPostalCode = '';
        String billingState = '';
        String billingStreet = '';
        String locale = '';
        String mailingCountryList = '';
        String mailingStateList = '';
        String salesRegion = '';
        Account aObj;
        try{
            aObj = [SELECT BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet,Locale__c,Mailing_Country_List__c,Mailing_State_List__c,Sales_Region__c FROM Account where id =: selectedAccountForOpportunity LIMIT 1];
            billingCity = aObj.billingCity;
            billingCountry = aObj.billingCountry;
            billingPostalCode = aObj.billingPostalCode;
            billingState = aObj.billingState;
            billingStreet = aObj.billingStreet;
            locale = aObj.Locale__c;
            mailingCountryList = aObj.Mailing_Country_List__c;
            mailingStateList = aObj.Mailing_State_List__c;
            salesRegion = aObj.Sales_Region__c;
        }catch(Exception e){
            
        }
        if (firstPageSelectedRecord.accountObj != null)
            lc.setAccountId(selectedAccountForOpportunity);
            
        if (firstPageSelectedRecord.contactObj != null)
            lc.setContactId(firstPageSelectedRecord.contactObj.Id);
        
        
        
        
        //Convert Lead      
        Database.LeadConvertResult lcr;
        try {                 
            //System.debug('firstPageSelectedRecord.contactObj.Id'+firstPageSelectedRecord.contactObj.Id);
            lcr = Database.convertLead(lc);
        }
       	catch (Exception e) {
            errorMessage = e.getMessage();
            parseError(errorMessage);
            
            showErrorMessage = true;
            //System.debug('errorMessage80'+errorMessage);
            return null;
        } 
        
        //Get OppId
        Id oppId;
        Boolean isNewOpp = false;
        
        if (selectedOpportunityWrapper.oObj != null){
            oppId = selectedOpportunityWrapper.oObj.Id;
        }else{
            oppId = lcr.OpportunityId;
            isNewOpp = true;
        } 
        
        //Update Opportunity
        Opportunity opp;
        //System.debug('oppId '+oppId);
        if (oppId !=  null) {
            opp = [SELECT Type,Campus__c,Department__c , pricebook2Id, RecordtypeId,pricebook2.Name, Lead_Passed_From__c, Promotion_Name__c, LeadSource, Solutions_Area_Interest__c, Market__c, ISBN__c, CurrencyIsoCode, OwnerId, Stagename FROM Opportunity WHERE Id = :oppId LIMIT 1];
            if(isNewOpp){
                if(renderedSection1){ //CAS Leads
                    opp.Name= oppObj.Name;
                    opp.CurrencyIsoCode = oppObj.CurrencyIsoCode;
                    opp.OwnerId = oppObj.OwnerId;
                    opp.Course_Start_Date__c = oppObj.Course_Start_Date__c;
                    opp.CAS_Course_Cat1__c = selectedLevel1;
                    opp.CAS_Course_Cat2__c = selectedLevel2;
                    opp.CAS_Course_Cat3__c = selectedLevel3;
                    opp.Type = 'Course';
                }else if(renderedSection2){ //Journal Leads
                    opp.Name= oppObj.Name;
                    opp.CurrencyIsoCode = oppObj.CurrencyIsoCode;
                    opp.OwnerId = oppObj.OwnerId;
                    opp.Volume_Year__c = oppObj.Volume_Year__c;
                    opp.Type = 'New Business';
                }else if(renderedSection4){ //Corporate Leads
                    opp.Name= oppObj.Name;
                    opp.CurrencyIsoCode = oppObj.CurrencyIsoCode;
                    opp.OwnerId = oppObj.OwnerId;  
                    opp.Type = 'New Business';
                }else if(renderedSection5){ //F1000 Article Leads
                    opp.Name= oppObj.Name;
                    opp.CurrencyIsoCode = oppObj.CurrencyIsoCode;
                    opp.OwnerId = oppObj.OwnerId;  
                }else{
                    opp.CloseDate = oppObj.CloseDate;
                    opp.CurrencyIsoCode = oppObj.CurrencyIsoCode;
                    opp.OwnerId = oppObj.OwnerId;
                    opp.Type = 'New Business';
                }
                system.debug('In update req start');
                //opp.Type = 'New Business';
                opp.RecordtypeId = selectedOppRecordType;
                opp.Lead_Passed_From__c = leadObj.Lead_Qualifier__c;
                opp.Promotion_Name__c = leadObj.Promotion_Name__c;
                opp.Lead_Source_Description__c = leadObj.Lead_Source_Description__c;
                opp.LeadSource = leadObj.LeadSource;
                opp.Solutions_Area_Interest__c = leadObj.Solutions_Area_Interest__c;
                opp.Market__c = leadObj.Market__c;
                opp.ISBN__c = product.ProductCode;
                opp.CurrencyIsoCode = currencyCode;
                opp.OwnerId = oppObj.ownerId;
                opp.Number_of_Students__c=leadObj.Anticipated_Enrollment__c;
                //Added for populate campus and department Piyush//
                
                System.debug('convertedContact.Campus__c'+cawList[indexCampusDepartmentUpdate - 1].campusId);
                System.debug('comID'+campusId);
                if(campusId != null && !campusId.contains('NewCampus'))
                {
                    opp.Campus__c = cawList[indexCampusDepartmentUpdate - 1].campusId;
                }
                //   system.debug('***Department '+ cawList.departmentId  +'lcr.contactId*** '+lcr.ContactId);
                
                System.debug('deptID'+cawList[indexCampusDepartmentUpdate - 1].departmentId);
                if(!Test.isRunningTest()){
                    if(!cawList[indexCampusDepartmentUpdate - 1].departmentId.contains('NewDepartment'))
                    {
                        Contact c = [select id,Department_Object__c  from Contact where id =:lcr.contactId Limit 1];
                        //Department was not getting populated Updated By Sid c Case No- 01845505 Date:-4/72021
                        system.debug('!!@'+cawList[indexCampusDepartmentUpdate - 1].departmentId);
                        if(cawList[indexCampusDepartmentUpdate - 1].departmentId!='-None-'){
                            opp.Department__c =cawList[indexCampusDepartmentUpdate - 1].departmentId;
                        }
                        // opp.Department__c = c.Department_Object__c;
                    }
                }
                // End Piyush//
                system.debug('***Else condition123 '+ cawList[indexCampusDepartmentUpdate - 1].departmentId  +'lcr.contactId*** '+lcr.ContactId);
                if(renderedSection1){
                    opp.Stagename = 'Investigating';
                }else{
                    opp.Stagename = 'Prospect';
                }
                update opp;
            }
            else{
                
                Boolean updateReq = false;
                if(renderedSection1){
                    // Piyush Change
                    System.debug('campusId'+campusId);
                    if(campusId != null && !campusId.contains('NewCampus'))
                    {
                        opp.Campus__c = cawList[indexCampusDepartmentUpdate - 1].campusId;
                    }
                    System.debug('indexCampusDepartmentUpdate'+cawList[indexCampusDepartmentUpdate - 1].departmentId);
                    if(cawList[indexCampusDepartmentUpdate - 1].departmentId!= null && !cawList[indexCampusDepartmentUpdate - 1].departmentId.contains('NewDepartment'))
                    {
                        Contact c = [select id,Department_Object__c  from Contact where id =:lcr.contactId Limit 1];
                        opp.Department__c = c.Department_Object__c;
                    }
                    // Piyush Change
                    opp.Course_Start_Date__c = oppObj.Course_Start_Date__c;
                    updateReq = true;
                }
                
                updateReq = true;
                // Piyush Change
                
                if(campusId != null && !campusId.contains('NewCampus'))
                {
                    opp.Campus__c = cawList[indexCampusDepartmentUpdate - 1].campusId;
                    
                }
                //   Contact c = [select id,Department_Object__c  from Contact where id =:lcr.contactId Limit 1];
                if(cawList[indexCampusDepartmentUpdate - 1].departmentId!= null && !cawList[indexCampusDepartmentUpdate - 1].departmentId.contains('NewDepartment')){
                    System.debug('Test3'+opp.Department__c);
                    Contact c = [select id,Department_Object__c  from Contact where id =:lcr.contactId Limit 1];
                }
                //Piyush
                if(updateReq){
                    system.debug('In update req');
                    update opp;
                }
            }
        }
        
        //Insert/Update OCR
        String role;
        role = ocrObj.Role;
        
        String contactRoleIDs =  OpportunityRTIds = CasCS__c.getValues('Contact_Roles_Id').Value__c;
        String informaContactRoleIds =  OpportunityRTIds = CasCS__c.getValues('Informa_Contact_Roles_Id').Value__c;
        OpportunityContactRole ocr;
        try{
            //oppId != null check added by Renil on 14/06/2022 in the F1000 scenario oppId could be null.
            if(isContainsId(contactRoleIDs, selectedOppRecordType) && oppId != null){
                ocr = [SELECT ContactId,CreatedById,CreatedDate,//Division,
                       Id,IsDeleted,IsPrimary,LastModifiedById,LastModifiedDate,OpportunityId,Role,SystemModstamp FROM OpportunityContactRole WHERE 
                       ContactId =:lcr.ContactId AND OpportunityId =: oppId AND contact.accountid=:lcr.AccountId LIMIT 1];
                
                ocr.IsPrimary = true;
                ocr.Role = role;
                update ocr;
            }
            //oppId != null check added by Renil on 14/06/2022 in the F1000 scenario oppId could be null
            else if(isContainsId(informaContactRoleIds, selectedOppRecordType) && oppId != null){
                List<Informa_Contact_Role__c> icrs = [SELECT id,Opportunity__c,Contact__c,Contact_Role_s__c,Primary_Contact__c FROM Informa_Contact_Role__c WHERE Opportunity__c = :oppId AND Contact__c = :lcr.ContactId AND (Contact_Role_s__c = :role)];
                if (icrs.size() > 0) {
                    Boolean updateNeeded = false;
                    for (Informa_Contact_Role__c icr : icrs) {
                        icr.Primary_Contact__c = true;
                        updateNeeded = true;
                        break;
                    }
                    if(updateNeeded){
                        update icrs;
                    }
                } else {
                    Informa_Contact_Role__c icr = new Informa_Contact_Role__c();
                    icr.Opportunity__c = oppId;
                    icr.Contact__c = lcr.ContactId;
                    icr.Contact_Role_s__c = role;
                    icr.Primary_Contact__c = true;
                    insert icr;
                }  
            }else{
                //in case no record type id matched from custom setting
            }
            
        }catch(Exception e){
            ocr = new OpportunityContactRole();
            ocr.ContactId = lcr.ContactId;
            ocr.OpportunityId = oppId;
            ocr.IsPrimary = true;
            ocr.Role = role;
            insert ocr;
        }
        
        //OLI (As per given document, always insert new OLI, even if the product is already there)
        // try{
        List<PriceBookEntry> pbeList;
        PricebookEntry objPBEntry;
        if(isNewOpp && pricebookIDLst != null){
            pbeList = [SELECT Id, UnitPrice, CurrencyIsoCode FROM PricebookEntry  WHERE Product2Id = :lookup.Product__c AND Pricebook2Id IN :pricebookIDLst AND CurrencyIsoCode =: currencyCode  LIMIT 1];  
            if(pbeList.size() > 0){
                objPBEntry = pbeList[0];
            }
        }
        else{
            if (oppId !=  null && opp != null) {
                pbeList = [SELECT Id, UnitPrice, CurrencyIsoCode FROM PricebookEntry  WHERE Product2Id = :lookup.Product__c AND Pricebook2Id = :opp.pricebook2Id AND CurrencyIsoCode =: currencyCode  LIMIT 1];  
                if(pbeList.size() > 0){
                    objPBEntry = pbeList[0];
                }
            }else{
                pbeList = [SELECT Id, UnitPrice, CurrencyIsoCode FROM PricebookEntry  WHERE Product2Id = :lookup.Product__c AND Pricebook2Id IN :pricebookIDLst AND CurrencyIsoCode =: currencyCode  LIMIT 1];  
                if(pbeList.size() > 0){
                    objPBEntry = pbeList[0];
                }
            }
        }
        
        //PricebookEntry objPBEntry;
        if(objPBEntry != null){
            OpportunityLineItem objLineItem = new OpportunityLineItem();
            objLineItem.UnitPrice = objPBEntry.UnitPrice;
            objLineItem.Recipient__c = lcr.ContactId;
            objLineItem.Recipient_Address__c = deliveryAddress;
            objLineItem.PricebookEntryId = objPBEntry.Id; 
            if(renderedSection1){ //CAS Leads
                objLineItem.Quantity = 1;
                objLineItem.IC_Quantity__c = oppProductOBj.IC_Quantity__c;
                if((oppProductOBj.Order_Type__c != 'Vitalsource e-Exam copy' && oppProductOBj.Order_Type__c != 'CRC Vitalsource e-Exam copy' && oppProductOBj.Order_Type__c != 'HSS Vitalsource e-Exam copy') && product != null && product.Version_Type__c != null && (product.Version_Type__c.toUpperCase() == 'E-BOOK' || product.Version_Type__c.toUpperCase() == 'EBOOK') && leadObj.Publisher__c == 'CRC Press'){
                    objLineItem.Adoption_Stage__c = 'In-Process';
                }else{
                    objLineItem.Adoption_Stage__c = 'Created';
                }
                if(oppProductOBj.Order_Type__c == 'Vitalsource e-Exam copy' || oppProductOBj.Order_Type__c == 'CRC Vitalsource e-Exam copy' || oppProductOBj.Order_Type__c == 'HSS Vitalsource e-Exam copy'){
                    objLineItem.VitalSource_Access_Period__c = oppProductOBj.VitalSource_Access_Period__c;
                }
                objLineItem.Order_Type__c = oppProductOBj.Order_Type__c;
                objLineItem.Feedback_Notification__c = oppProductOBj.Feedback_Notification__c;
            }else if(renderedSection4){ //Corporate Leads
                objLineItem.Quantity = 1;
                if((oppProductOBj.Order_Type__c != 'Vitalsource e-Exam copy' && oppProductOBj.Order_Type__c != 'Corporate Vitalsource e-Exam copy') && product != null && product.Version_Type__c != null && (product.Version_Type__c.toUpperCase() == 'E-BOOK' || product.Version_Type__c.toUpperCase() == 'EBOOK') && leadObj.Publisher__c == 'CRC Press'){
                    objLineItem.Adoption_Stage__c = 'In-Process';
                }else{
                    objLineItem.Adoption_Stage__c = 'Created';
                }
                if(oppProductOBj.Order_Type__c == 'Vitalsource e-Exam copy' || oppProductOBj.Order_Type__c == 'Corporate Vitalsource e-Exam copy'){
                    objLineItem.VitalSource_Access_Period__c = oppProductOBj.VitalSource_Access_Period__c;
                }
                objLineItem.Order_Type__c = oppProductOBj.Order_Type__c;
                objLineItem.Feedback_Notification__c = oppProductOBj.Feedback_Notification__c;                    
            }   
            else{
                objLineItem.Quantity = 1;
                objLineItem.IC_Quantity__c = 1;
            }
            objLineItem.OpportunityID = oppId;
            Insert objLineItem;
        }
    	
        //}
        
        //[MES-21]-change 5 by Renil Rejith
        if(lcr.AccountId != null)
        {
        	convertedAccount = [SELECT Id, Name FROM Account WHERE Id = :lcr.AccountId LIMIT 1];
        }
        if(lcr.ContactId != null)
        {
            convertedContact = [SELECT Id, Name FROM Contact WHERE Id = :lcr.ContactId LIMIT 1];
        }
        if(oppId != null)
        {
            convertedOpportunity = [SELECT Id, Name FROM Opportunity WHERE Id = :oppId LIMIT 1];
        }	
        
        //Update Contact address (if requested)
        system.debug('*****'+copyAddressTo);
        if (copyAddressTo == 'Mailing' || copyAddressTo == 'Both') {
            convertedContact.MailingStreet = leadObj.Street;
            convertedContact.MailingCity = leadObj.City;
            convertedContact.MailingState = leadObj.State;
            convertedContact.Mailing_State_List__c = leadObj.State_List__c;
            convertedContact.MailingCountry = leadObj.Country;
            convertedContact.Mailing_Country_List__c = leadObj.Country_List__c;
            convertedContact.MailingPostalCode = leadObj.PostalCode;
        }
        if (copyAddressTo == 'Other' || copyAddressTo == 'Both') {
            convertedContact.OtherStreet = leadObj.Street;
            convertedContact.OtherCity = leadObj.City;
            convertedContact.OtherState = leadObj.State;
            convertedContact.Other_State_List__c = leadObj.State_List__c;
            convertedContact.OtherCountry = leadObj.Country;
            convertedContact.Other_Country_List__c = leadObj.Country_List__c;
            convertedContact.OtherPostalCode = leadObj.PostalCode;
        }
        if (copyAddressTo != '--None--'){
            update convertedContact;
        }
        if(aObj != null){
            aObj.billingCity = billingCity;
            aObj.billingCountry = billingCountry;
            aObj.billingPostalCode = billingPostalCode;
            aObj.billingState = billingState;
            aObj.billingStreet = billingStreet;
            aObj.Locale__c = locale;
            aObj.Mailing_Country_List__c =  mailingCountryList;
            aObj.Mailing_State_List__c = mailingStateList;
            aObj.Sales_Region__c = salesRegion;
            update aObj;
        }
        createCampusDepartment();
        //opp != null check added by Renil on 14/06/2022 in the F1000 scenario oppId could be null
        If(isNewOpp && opp !=  null)
        {
                system.debug('NOnetest'+isNewOpp);
                campusId = cawList[indexCampusDepartmentUpdate - 1].campusId;
                 system.debug('NOnetest1'+campusId);

                if(campusId != null && campusId.contains('NewCampus'))
                        {
                        opp.Campus__c =convertedContact.Campus__c;
                            }
                 
         
            //   Contact c = [select id,Department_Object__c  from Contact where id =:lcr.contactId Limit 1];
                String departmentId = '';
                departmentId = cawList[indexCampusDepartmentUpdate - 1].departmentId;
                if(departmentId!= null && departmentId.contains('NewDepartment'))
                          {
                          opp.Department__c = convertedContact.Department_Object__c;
                           }
                    
              update opp;   
        }
        
         //Get converted details to display on the Finish page
        isFinalPage = true;
        return null;
    }
    
    
    //used to check id is exising in list of ids or not 
    //listId=list of ides in single string comma seperated
    //singleId=single id 
    public Boolean isContainsId(String listId, String singleId){
        Boolean flag = false;
        for(String sId : listId.split(',')){
            if(sId.trim() == singleId){
                flag = true;
                break;
            }
        }
        return flag;
    }
  
  //Course Category starts  
    public string selectedLevel1 {get; set;}
    public string selectedLevel2 {get; set;}
    public string selectedLevel3 {get; set;}
    public Boolean isChangeCat1{get;set;}
    //getting level_1 categories on the basis of loged-in user
    public List<SelectOption> level1Items {
        get {
            List<SelectOption> options = new List<SelectOption>();
            try{
            
            //selectedLevel1 ='';
            
            /*    CHG0036312
           boolean showNorthAmerica = false;   
            // find out what country the current user is from
            string country = [select Id, Country from User where Id = :UserInfo.getUserId()].Country;
            if (country == 'United States' || country == 'Canada')
                showNorthAmerica = true;*/
            
            options.add(new SelectOption('','-- Choose a Category --'));
            //List<CAS_Course_Cat1__c> lstCAT1 = new List<CAS_Course_Cat1__c> ([select Id, Name from CAS_Course_Cat1__c where North_America__c = :showNorthAmerica Order By Name]);   CHG0036312
            List<CAS_Course_Cat1__c> lstCAT1 = new List<CAS_Course_Cat1__c> ([select Id, Name from CAS_Course_Cat1__c Order By Name]);
            for (CAS_Course_Cat1__c cat : lstCAT1){
                if(product != null && (product.Business_Division__c != null && product.Business_Division__c == cat.Name && !isChangeCat1)){
                    selectedLevel1 =cat.Id;
                    isChangeCat1 = true;
                } 
                options.add(new SelectOption(cat.Id,cat.Name));
            }
            
            }catch(Exception ex){
                System.debug('Error'+ex.getMessage()+'Error Line number'+ex.getLineNumber());
            }       
             return options;        
        }
        set;
    }
    
    //getting level_1 categories on the basis of level_1 category
    public List<SelectOption> level2Items {
        get {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','-- Choose a Category --'));
            if (selectedLevel1 != NULL) {
                List<CAS_Course_Cat2__c> lstCat2 = new List<CAS_Course_Cat2__c>([select Id, Name from CAS_Course_Cat2__c Where CAS_Course_Cat1__c = :selectedLevel1 Order By Name]);
                for (CAS_Course_Cat2__c cat : lstCat2)
                    options.add(new SelectOption(cat.Id,cat.Name));
            }
            
            return options;         
        }
        set;
    }    
    
    //getting level_1 categories on the basis of level_2 category
    public List<SelectOption> level3Items {
        get {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','-- Choose a Category --'));
            if (selectedLevel2 != NULL) {
                List<CAS_Course_Cat3__c> lstCat3 = new List<CAS_Course_Cat3__c>([select Id, Name from CAS_Course_Cat3__c Where CAS_Course_Cat2__c = :selectedLevel2 Order By Name]);
                for (CAS_Course_Cat3__c cat :lstCat3 )
                    options.add(new SelectOption(cat.Id,cat.Name));
            }
            return options;         
        }
        set;
    }   
    
    // reset level2 so that level 3 will reset also
    public PageReference resetLevel2() {
        selectedLevel2 = '';
        return null;
    }
    
    //updating drop down of campus and department when creating new campus/department by clicking on green plus button
    public PageReference updateOptions(){
        try{
            Integer indexInt = Integer.valueOf(updateOptionsCIndex);
                    List<SelectOption> retVal = new List<SelectOption>();
            system.debug('TESTcampusid'+updateOptionsCName+'ndexc'+indexInt);
            if(updateOptionsCIsCampus == 'Y'){
                cawList[indexInt - 1].campusId = updateOptionsCName+' (NewCampus)';
                cawList[indexInt - 1].campusOptions.add(new SelectOption(updateOptionsCName+' (NewCampus)', updateOptionsCName+' (NewCampus)'));
                system.debug('campusId'+campusId);
                 retVal.add(new SelectOption('-None-','-None-'));
                system.debug('campusId2'+campusId);
                 //  Check the below condition lines of code as campus id is null
                   If(campusId.contains('NewCampus') ){
                    for(Department__c dObj : [Select id, name from Department__c where Account__c =: cawList[indexInt -1].accountObj.Id ORDER BY Name,LastModifiedDate LIMIT 300]){
                        retVal.add(new SelectOption(dObj.Id, dObj.Name));
                    }
               }
                   system.debug('TESTvalue'+retVal);
              //  system.debug('retVal '+retVal );
              //  Check the below 2 lines of code
                cawList[indexInt -1].departmentOptions = retVal;
                system.debug('TESTvalue'+retVal);
               // cawList[indexInt - 1].departmentOptions.add(new SelectOption(updateOptionsCName, updateOptionsCName));
            }else{
                system.debug('DepartmentName'+updateOptionsCName);
                cawList[indexInt - 1].departmentOptions.add(new SelectOption(updateOptionsCName + ' (NewDepartment)',updateOptionsCName+ ' (NewDepartment)'));
                cawList[indexInt - 1].departmentId = updateOptionsCName+' (NewDepartment)';
                // cawList[indexInt - 1].departmentId ='NewDepartment'+String.valueOf(indexInt - 1);
                system.debug('cawList[indexInt - 1].departmentId'+cawList[indexInt - 1].departmentId);
                system.debug('mapAddNewDept'+mapAddNewDept);
                if(mapAddNewDept != null  ) {
                    system.debug('mapAddNewDeptEnter Loop');
                    if(mapAddNewDept.containskey(indexInt - 1))
                    {
                        List<SelectOption> lstNewDept = mapAddNewDept.get(indexInt - 1);
                        system.debug('map contains');
                        lstNewDept.add(new SelectOption(String.valueOf(indexInt - 1)+' (NewDepartment)',updateOptionsCName+' (NewDepartment)'));
                        mapAddNewDept.put(indexInt - 1,lstNewDept);
                    }
                    else
                    {
                          system.debug('map contains not contain');
                        List<SelectOption> lstNewDept = new List<SelectOption>();
                        lstNewDept.add(new SelectOption(String.valueOf(indexInt - 1)+' (NewDepartment)',updateOptionsCName+' (NewDepartment)'));
                          system.debug('lstNewDept'+indexInt);
                        mapAddNewDept.put(indexInt - 1,lstNewDept);
                           system.debug('mapAddNewDept'+mapAddNewDept);
                    }
                }
            }
                       
        }catch(Exception e){
            system.debug('exception'+e.getStackTraceString());
        }
        return null;
    }   
    
      //Course Category ends 
    
    //crating map for campus and department with corresponding accounts
    //contactsAcountIdSet = all accounts which used on contact/account list page (first page of lead conversion)
    
    public Map<String, List<SelectOption>> createCOptionsMap(List<Id> contactsAcountIdSet){
        //Map<String, List<SelectOption>> accIdToDepartmentsMap = new Map<String, List<SelectOption>>();
        Map<String, List<SelectOption>> accIdToCampusesMap = new Map<String, List<SelectOption>>();
        List<SelectOption> campusOptions;
        //List<SelectOption> departmentOptions;
        List<Account> lstAcc = new List<Account>([select id, name, BP__c, Site, Ringgold_Account_ID__c, RecordTypeId, BillingCity,BillingCountry,BillingState,BillingStreet,BillingPostalCode, (select id, Name from Campuses__r ORDER BY Name,LastModifiedDate LIMIT 300) from Account where id IN: contactsAcountIdSet limit 2000]);
        for(Account accObj :lstAcc){
            //System.debug('opop3'+accObj.name);
            campusOptions = new List<SelectOption>();
            campusOptions.add(new SelectOption('-None-','-None-'));
            /* departmentOptions = new List<SelectOption>();
            departmentOptions.add(new SelectOption('-None-','-None-')); */
            
            if(accObj.Campuses__r != null && accObj.Campuses__r.size() >0){
                for(Campus__c cObj : accObj.Campuses__r){
                    campusOptions.add(new SelectOption(cObj.Id, cObj.Name));
                }
            }
          
            accIdToCampusesMap.put(accObj.Id, campusOptions); // all campuses corresponding to account
            //accIdToDepartmentsMap.put(accObj.Id, departmentOptions); // all departments corresponding to account
        }
        return accIdToCampusesMap;
    }
    
    public Map<String, List<SelectOption>> createDOptionsMap(List<Id> contactsAcountIdSet){
        Map<String, List<SelectOption>> accIdToDepartmentsMap = new Map<String, List<SelectOption>>();
        List<SelectOption> departmentOptions;
        List<Account> lstAcc = new List<Account>([select id, name, BP__c, Site, Ringgold_Account_ID__c, RecordTypeId, BillingCity,BillingCountry,BillingState,BillingStreet,BillingPostalCode, (select id, Name, campus__c,campus__r.Name from Departments__r ORDER BY Name,LastModifiedDate LIMIT 300) from Account where id IN: contactsAcountIdSet limit 2000]);
        system.debug(contactsAcountIdSet);
        for(Account accObj :lstAcc){
            //System.debug('opop3'+accObj.name);
            departmentOptions = new List<SelectOption>();
            departmentOptions.add(new SelectOption('-None-','-None-'));
            if(accObj.Departments__r != null && accObj.Departments__r.size() >0){
                for(Department__c dObj : accObj.Departments__r){
                    departmentOptions.add(new SelectOption(dObj.Id, dObj.Name));
                }
            }
            //accIdToCampusesMap.put(accObj.Id, campusOptions); // all campuses corresponding to account
            accIdToDepartmentsMap.put(accObj.Id, departmentOptions); // all departments corresponding to account
        }
        return accIdToDepartmentsMap;
    }
    
    //creating map for contact/account key=contactId value=account
    public Map<String,Account> createContactAccountMap(Map<String, String> contactIdToAccountId){
        Map<String,Account> contactIdToAccountMap = new Map<String,Account>();
        for(Account a : [select id, name, BP__c, Site, Ringgold_Account_ID__c, RecordTypeId, BillingCity,BillingCountry,BillingState,BillingStreet,BillingPostalCode,
                            (select id, name from contacts WHERE id IN : contactIdToAccountId.keySet() ORDER By LastModifiedDate Desc LIMIT 1000) from Account WHERE id IN : contactIdToAccountId.values()]){
            if(a.contacts != null && a.contacts.size()>0){
                for(Contact c : a.contacts){
                    if(contactIdToAccountId.containsKey(c.Id)){
                        contactIdToAccountMap.put(c.Id, a);
                    }
                }
            }
            
        }
        return contactIdToAccountMap;
    }    
    
    //creating map for campus/department key=campusId value=list of departments
    //campusIdSet is all campuses which used on page
    public Map<String, List<SelectOption>> createCampusIdToDepartmentsMap(Set<Id> campusIdSet){
        Map<String, List<SelectOption>> campusIdToDepartmentsMap = new Map<String, List<SelectOption>>();
        
        List<Department__c> lstDept= new List<Department__c> ([Select id, name, Campus__c from Department__c where Campus__c IN : campusIdSet ORDER By Name]);
        system.debug('##cmplist'+campusIdSet );
         system.debug('##lstDept'+lstDept );
        if(lstDept != null && lstDept.size()>0){
            for(Department__c dObj : lstDept){
                if(campusIdToDepartmentsMap.get(dObj.Campus__c) != null){
                    campusIdToDepartmentsMap.get(dObj.Campus__c).add(new SelectOption(dObj.Id, dObj.Name));
                }else{
                    List<SelectOption> newList = new List<SelectOption>();
                    newList.add(new SelectOption('-None-','-None-'));
                    newList.add(new SelectOption(dObj.Id, dObj.Name));
                    campusIdToDepartmentsMap.put(dObj.Campus__c, newList);
                }
            }
        }
        else{
            system.debug('test');
            List<SelectOption> newList = new List<SelectOption>();
            newList.add(new SelectOption('-None-','-None-'));
          //  campusIdToDepartmentsMap.put('', newList);
        }
        system.debug('campusIdToDepartmentsMap#####'+campusIdToDepartmentsMap);
        return campusIdToDepartmentsMap;
    }
    
    //getting pricebook names on the basis of ides which is stored in custom setting
    public String getPricebookNames(){
        String priceBookNames = '';
        String pricebookID = (CasCS__c.getValues('Pricebook_Id') != null) ? CasCS__c.getValues('Pricebook_Id').Value__c : '01s0Y00000832dDQAQ';
        List<Pricebook2> lstPriceBook2 = Database.query('Select id, name from Pricebook2 where id IN'+getListFromString(pricebookID));
        //////System.debug('lstPriceBook2 size'+lstPriceBook2.size());
        for(Pricebook2 p : lstPriceBook2){
            //System.debug('p.Name 2'+p.Name);
            priceBookNames += (String.isNotBlank(priceBookNames) && priceBookNames != null? ', '+p.Name:p.Name);
        }
       
        return priceBookNames;
    }
    
    public Map<String,List<SelectOption>> createContactToCampus(Map<String,String> ContIddepartIdMap){
        Map<String,List<SelectOption>> mapExistDeptOnCont = new Map<String,List<SelectOption>>();
        List<Department__c> lstdept = new List<Department__c>([select id, Name, campus__c,campus__r.Name from Department__c where id IN : ContIddepartIdMap.values() ORDER By Name]);
         for(Department__c dept:lstdept){
            
            if(dept.campus__c != null){
                mapExistDeptOnCont.put(dept.id,new List<SelectOption>{new SelectOption('-None-','-None-'), new SelectOption(dept.campus__c, dept.campus__r.Name )});
            }
            else{
                mapExistDeptOnCont.put(dept.id,new List<SelectOption>{new SelectOption('-None-','-None-')});
            }
        }
        
        return mapExistDeptOnCont;
            
    }
    
    public Boolean displayPopUp {get; set;}
    //public String popupTitle { get; set; }
    public String popupMessage { get; set; }

    public Boolean isRequestedPreviouslyOrdered { get; set; }
    public Boolean isDeliveredPreviouslyOrdered { get; set; }

    public pageReference closePopup_Cancel() {
        displayPopUp = false;
        isContactPage = true;
        return null;
    }
    public pageReference closePopup_Continue() {
        displayPopUp = false;
        isContactPage = false;
        searchOpportunities();
        return null;
    }

    public void checkPastOpps(Boolean isFirstCheck) {
            
        //if (selectedContactAccountWrapper != null && selectedContactAccountWrapper.contactId != null) {
        if (firstPageSelectedRecord != null && firstPageSelectedRecord.contactObj != null && Lookup != null && Lookup.Product__c != null) {
            List<OpportunityLineItem> olis = new List<OpportunityLineItem> ();
            
                olis =[SELECT Id, CreatedDate FROM OpportunityLineItem WHERE Recipient__c = :firstPageSelectedRecord.contactObj.Id AND 
                        PricebookEntry.Product2Id = :Lookup.Product__c ORDER BY CreatedDate DESC LIMIT 1];
                                                        
            if (isFirstCheck) {
                if (olis.size() > 0) {
                    //popupTitle = 'Duplicate Order';
                    popupMessage = 'This product was ordered on ' + MiscFunctions.convertDateToString_MMM_d_yyyy(olis[0].CreatedDate.Date()) + ' by this contact.  Are you sure you wish to proceed?';
                    isRequestedPreviouslyOrdered = true;
                    isDeliveredPreviouslyOrdered = true;
                    displayPopUp = True;
                    //isContactPage = true;
                } else {
                    isRequestedPreviouslyOrdered = false;
                    isDeliveredPreviouslyOrdered = false;
                    isContactPage = false;
                }
            } else {
                if (olis.size() > 0) 
                    isDeliveredPreviouslyOrdered = true;
                else 
                    isDeliveredPreviouslyOrdered = false;
            }
        } else {
            //isRequestedPreviouslyOrdered = false;
            isDeliveredPreviouslyOrdered = false;
            if (isFirstCheck) {
                isContactPage = false;
            }
        }   
    }
    
    // Functions used for pagination
    private integer counter=0;  //keeps track of the offset
    public integer list_size =15;//sets the page size or number of rows
    public integer total_size; //used to show user the total size of the list
    public PageReference PreviousOpp() { //user clicked previous button
      counter -= list_size;
      searchOpportunities();
      return null;
    }

    public PageReference NextOpp() { //user clicked next button
      counter += list_size;
      searchOpportunities();
      return null;
    }
    public Integer getPageNumber() {
      return counter/list_size + 1;
    }
    public Integer getTotalPages() {
      if (math.mod(total_size, list_size) > 0) {
         return total_size/list_size + 1;
      } else {
         return (total_size/list_size);
      }
    }
    public Boolean getDisablePrevious(){
       //this will disable the previous and beginning buttons
      if (counter>0) return false; else return true;
    }

    public Boolean getDisableNext() {
        //this will disable the previous and beginning buttons
         if (counter + list_size < total_size) return false; else return true;
    }
}