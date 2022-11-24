/*
*
* Last Modified by Jeff Lup - 2013.06.24 - CHG0051242
* Last Modified by Hailey Niemand - 2014.02.05 - CHG0056245
* Last Modified by Hailey Niemand - 2014.05.11 - CHG0058014
* Last Modified by Hailey Niemand - 2015.02.18 - CHG0064416
*/

public with sharing class Case_AccountSearchController {
    private ApexPages.StandardController controller {get; set;}
    private Case cse;
    
    public String errorMessage {get; set;}
    public Boolean showErrorMessage {get; set;}
    public Integer pageNum {get; set;}

    public Account a {get; set;}
    public Contact c {get; set;}
    
    public String searchMethod {get { if (searchMethod == null) searchMethod = 'Account Name'; return searchMethod; } set;}
    public String searchValue {get; set;}
            
    public Case_AccountSearchController(ApexPages.StandardController controller) {
        this.controller = controller;
        this.cse = (Case)controller.getRecord();
        pageNum = 1;
        a = new Account();
        c = new Contact();
    }
    
    public List<Account> accounts {
        get {
            if (searchValue != null && searchValue != '') {
                if (searchMethod == 'Account Name' && searchValue != null)
                    //return [SELECT Name, Ringgold_Account_ID__c, BP__c, Billing_City__c FROM Account WHERE Name LIKE :(searchValue + '%')]; //CHG0056245
                    return [SELECT Name, Ringgold_Account_ID__c, BP__c, Shipping_City__c, Key_Account__c FROM Account WHERE Name LIKE :(searchValue + '%')]; //CHG0058014
                else if (searchMethod == 'Ringgold ID' && searchValue != null)
                    //return [SELECT Name, Ringgold_Account_ID__c, BP__c, Billing_City__c FROM Account WHERE Ringgold_Account_ID__c = :searchValue]; //CHG0056245
                    return [SELECT Name, Ringgold_Account_ID__c, BP__c, Shipping_City__c, Key_Account__c FROM Account WHERE Ringgold_Account_ID__c = :searchValue]; //CHG0058014
                else if (searchMethod == 'BP' && searchValue != null)
                    //return [SELECT Name, Ringgold_Account_ID__c, BP__c, Billing_City__c FROM Account WHERE BP__c = :searchValue]; //CHG0056245
                    return [SELECT Name, Ringgold_Account_ID__c, BP__c, Shipping_City__c, Key_Account__c FROM Account WHERE BP__c = :searchValue]; //CHG0058014
                else
                    return null;
            } else
                return null;
        }
        set;
    }
    
    public Pagereference doSearch() {
        return null; //search is automatic as part of rerender
    }

    public Pagereference doCancel() {
        return new Pagereference('/' + cse.Id);
    }

    public Pagereference doAddNew() {
        pageNum = 2;
        return null;
    }

    public Pagereference doSave() {
        showErrorMessage = false;
        if ((a.Shipping_Country_List__c == 'United States' || a.Shipping_Country_List__c == 'Canada') && a.Shipping_State_List__c == null) {
            errorMessage = 'Shipping State is required when the Shipping Country is \'United States\' or \'Canada\'';
            showErrorMessage = true;
            return null;
        } else if (isDuplicateEmail()) {
            showErrorMessage = true;
            return null;
        } else { 
            /* CHG0056245
            getCountryCodes();
            a.ShippingCountry = mapCountryToCode.get(a.Shipping_Country_List__c);
            a.ShippingState = a.Shipping_State_List__c;
            */
            
            insert a;
            
            ID shareIdToDelete;
            
            try {
                Account a1 = [SELECT Id, OwnerId FROM Account WHERE Id = :a.Id];
            } catch(Exception e) {
                //Add manual sharing so that the user who created the account has access to it as sharing is only calculated when the method completes
                ID accountId = a.Id;
                ID userId = UserInfo.getUserId();
                shareIdToDelete = SharingUtil.CreateShares(accountId, userId);
            }
            
            c.AccountId = a.Id;
            insert c;
            cse.AccountId = a.Id;
            //CHG0056245
            cse.ContactId = c.Id;
            update cse; 
            
            //Delete Manual sharing added in line 85
            if (shareIdToDelete != null)
                SharingUtil.DeleteShares(shareIdToDelete); 
            
           return new Pagereference('/' + cse.Id);
           // return new Pagereference('/' + a.Id);
        }
        
    }
    
    public Pagereference goBackToSearch() {
        pageNum = 1;
        return null;
    }

    public Id accountId { get; set; }

    public Pagereference doSelect() {
        cse.AccountId = accountId;
        update cse;
        return new Pagereference('/' + cse.Id);
    }
    
    //CHG0056245
    /* private map<String,String> mapCountryToCode;
    private void getCountryCodes() {
        if (mapCountryToCode == null) {
            mapCountryToCode = new map<String,String>();
            List<ISO_Country__c> countries = [SELECT Name, ISO_Code__c FROM ISO_Country__c];
            for (ISO_Country__c country : countries) {
                mapCountryToCode.put(country.Name, country.ISO_Code__c);
            }
        }
    }
    */

    public Boolean showDupeSelector { get; set; }
    public String dupeContact { get; set; }
    public String dupeAccount { get; set; }
    private Id dupeAccountId;
    
    private Boolean isDuplicateEmail() {
        showDupeSelector = false;
        List<Contact> dupeContacts = [SELECT Id, Name, Account.Name, AccountId FROM Contact WHERE Email = :c.Email LIMIT 1];
        if (dupeContacts.size() > 0 && dupeContacts[0].AccountId == null) {
            dupeContact = dupeContacts[0].Name;
            errorMessage = 'This email address is already in use by a Contact without an Account.';
            return true;
        } else if (dupeContacts.size() > 0 && dupeContacts[0].AccountId != null) {
            dupeContact = dupeContacts[0].Name;
            dupeAccount = dupeContacts[0].Account.Name;
            dupeAccountId = dupeContacts[0].AccountId;
            showDupeSelector = true;
            errorMessage = 'This email address is already in use by ' + dupeContacts[0].Name + ' from ' + dupeContacts[0].Account.Name + '. ';
            return true;
        } else
            return false;
    }

    public Pagereference useDupe() {
        accountId = dupeAccountId;
        return doSelect();
    }
    
    /*
    public List<SelectOption> countries {
        get {
            List<String> shippingCountries = MiscFunctions.getListFromPicklist(Account.Shipping_Country_List__c);
            List<SelectOption> options = new List<SelectOption>();
            for (String country : shippingCountries) { 
                options.add(new SelectOption(country,country));
            }
            return options;
        }
        set;
    }
    */

}