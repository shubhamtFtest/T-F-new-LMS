/* 
*  Tested by: zTEST_ICRInlineEditController.cls
*
*  Created by Jeff Lup - 2015.08.21 - PRJ0012643
*  Modified by Jeff Lup - 2016.03.28 - CHG0072245 - Errors on New Opportunity in Lightning
*/

public with sharing class ICR_InlineEditController {
    private ApexPages.StandardController controller {get; set;}
    private final Opportunity opp;    
    
    public Boolean isInlineEditMode {get { if (isInlineEditMode == null) isInlineEditMode = false; return isInlineEditMode;} set;}
    
    public String errorMessage {get;set;}
    public Boolean showErrorMessage {get;set;}
    
    public Integer selectedTempIcrId {get; set;}
    private Integer tempIcrId = 0;
    private List<Informa_Contact_Role__c> icrsToDelete = new List<Informa_Contact_Role__c>();
    
    public ICR_InlineEditController(ApexPages.StandardController controller) {
        this.controller = controller;
        this.opp = (Opportunity)controller.getRecord();
    }
        
    /******************************************/
    /*************** Load Data ****************/
    /******************************************/

    private Integer rowNumber;
    private Id icrRecordtypeId;
    
    public void init() {
        if (opp != null && opp.Id != null) { //CHG0072245
            if (icrWrapperList.size() == 0) {
    
                icrRecordtypeId = MiscFunctions.getRecordtypeId('Informa_Contact_Role__c', 'T&F Contact Roles');
            
                addICR();
            
                rowNumber = 0;
    
                //get existing ICRs
                List<Informa_Contact_Role__c> icrs = [SELECT Id, Contact__c, Contact__r.Name, Account__c, Contact__r.Account.Name, Contact__r.AccountId, Contact_Role_s__c, Email__c, Phone__c, Primary_Contact__c, Title__c, Contact__r.Agent__c,
                                                        Contact__r.MailingStreet, Contact__r.MailingCity, Contact__r.MailingState, Contact__r.MailingPostalCode, Contact__r.MailingCountry,
                                                        //Contact__r.SAP_BP_Number__c,
                                                        Contact__r.FirstName, Contact__r.LastName, Contact__r.Title, Contact__r.Phone, Contact__r.Email
                                                        ,Recordtype.Name, LastModifiedDate
                                                      FROM Informa_Contact_Role__c
                                                      WHERE Opportunity__c = :opp.Id];
                icrWrapperList = new List<ICRWrapper>();
                for (Informa_Contact_Role__c icr : icrs) {
                    addICRtoWrapper(icr);
                }
            }
        }
    }
    
    private void addICR() {
        //Long dt1Long = opp.CreatedDate.getTime();
        //Long dt2Long = DateTime.now().getTime();
        //Long milliseconds = dt2Long - dt1Long;
        //if ((milliseconds/1000) < 10) { //Opportunity was just created
            List<OpportunityContactRole> ocrs = [SELECT ContactId FROM OpportunityContactRole WHERE OpportunityId = :opp.Id ORDER BY CreatedDate DESC LIMIT 1];
            if (ocrs.size() > 0) {
                List<Informa_Contact_Role__c> icrs = [SELECT Id FROM Informa_Contact_Role__c WHERE Opportunity__c = :opp.Id LIMIT 1];
                if (icrs.size() == 0) {
                    Informa_Contact_Role__c icr = new Informa_Contact_Role__c();
                    icr.Opportunity__c = opp.Id;
                    icr.Contact__c = ocrs[0].ContactId;
                    icr.Primary_Contact__c = true;
                    icr.RecordtypeId = icrRecordtypeId;
                    icr.Contact_Role_s__c = 'Delivery'; //Role is a required field for the Primary contact
                    insert icr;
                }            
            }
        //}
    }
    
    private void addICRtoWrapper(Informa_Contact_Role__c icr) {
        ICRWrapper icrw = new ICRWrapper();
        
        tempIcrId++;
        icrw.tempIcrId = tempIcrId;

        icr.CurrencyIsoCode = opp.CurrencyIsoCode;

        icrw.icr = icr;
        icrw.address = (icr.Contact__r.MailingStreet == null ? '' : icr.Contact__r.MailingStreet + ', ') + (icr.Contact__r.MailingCity == null ? '' : icr.Contact__r.MailingCity + ', ') + (icr.Contact__r.MailingState == null ? '' : icr.Contact__r.MailingState + ' ') + (icr.Contact__r.MailingPostalCode == null ? '' : icr.Contact__r.MailingPostalCode + ' ') + (icr.Contact__r.MailingCountry == null ? '' : icr.Contact__r.MailingCountry);
        
        rowNumber++;
        icrw.rowNumber = rowNumber;
        icrWrapperList.add(icrw);
        //hideShowFields(icr);
    }
    
    public List<ICRWrapper> icrWrapperList {
        get {
          if (icrWrapperList == null) {
            icrWrapperList = new List<ICRWrapper>();
          }
          return icrWrapperList;
        }
        set;
    }

    /******************************************/
    /**************** Contact *****************/
    /******************************************/
    
    public Integer selectedRowNumber {get; set;}

    public ICRWrapper getCurrentICRw() {
        for (ICRWrapper icrw : icrWrapperList) {
            if (icrw.rowNumber == selectedRowNumber)
                return icrw;
        }
        return null;
    } 
    
    public Pagereference contactSelected() {
        //Get selected row
        ICRWrapper icrw = getCurrentICRw();
        //Check for duplicates
        Boolean ok2proceed = true;
        for (ICRWrapper otherIcrw : icrWrapperList) {
            if (icrw.rowNumber != otherIcrw.rowNumber && icrw.icr.Contact__c == otherIcrw.icr.Contact__c) {
                errorMessage = 'This Contact is already in use.  Please choose a different contact, or edit the role of the existing record instead.';
                showErrorMessage = true;
                ok2proceed = false;
                break;
            }
        }
        //Get Contact
        if (ok2proceed && icrw.icr.Contact__c != null) {
            Contact c = [SELECT Id, FirstName, LastName, Title, Phone, Email,
                            MailingStreet, MailingCity, MailingState, MailingPostalCode,
                            MailingCountry//, SAP_BP_Number__c
                         FROM Contact
                         WHERE Id = :icrw.icr.Contact__c];
            icrw.icr.Contact__r = c;
        } else {
            icrw.icr.Contact__r = new Contact();
            icrw.icr.Contact__c = null;
        }
        return null;
    }

    
    /******************************************/
    /************ Primary Contact *************/
    /******************************************/
    
    public Pagereference unselectOtherPrimary() {
        //Get selected row
        ICRWrapper icrw = getCurrentICRw();
        //Remove other checks (if necessary)
        if (icrw.icr.Primary_Contact__c) {
            for (ICRWrapper otherIcrw : icrWrapperList) {
                if (icrw.rowNumber != otherIcrw.rowNumber) {
                    otherIcrw.icr.Primary_Contact__c = false;
                }
            }
        }
        return null;
    }

    private Contact prevPrimaryContact;

    public Contact getPrimaryContact() {
        for (ICRWrapper icrw : icrWrapperList) {
            if (icrw.icr.Primary_Contact__c)
                return icrw.icr.Contact__r;
        }
        return null; //no primary found
    }
    
    /******************************************/
    /***************** Role *******************/
    /******************************************/
    
    public void roleChanged() {
        ICRWrapper w = getCurrentICRw();
        if (w != null) {
            if (!w.isDelivery)
                w.icr.Primary_Contact__c = false;
        }
    }
    

    /******************************************/
    /************ Edit and Cancel *************/
    /******************************************/
    
    public Pagereference editAll() {
        //enter Edit Mode
        isInlineEditMode = true;
        showErrorMessage = false;
        //get current Primary
        prevPrimaryContact = getPrimaryContact();
        return null;
    }

    public Pagereference cancel() {
        //reset page
        icrWrapperList = new List<ICRWrapper>();
        isInlineEditMode = false;
        showErrorMessage = false;
        init();
        return null;
    }
    
        
    /******************************************/
    /************ Delete Selected *************/
    /******************************************/

    public void removeICR() {
        // This function runs when a user hits "remove" on an item
        Integer count = 0;
        for (ICRWrapper w : icrWrapperList) {
            if (w.tempIcrId == selectedTempIcrId) {
                if (w.icr.Id != null)
                    icrsToDelete.add(w.icr);
                icrWrapperList.remove(count);
                break;
            }
            count++;
        }
    }
    

    
    /******************************************/
    /**************** Add New *****************/
    /******************************************/
    
    public Pagereference addNew() {
        Informa_Contact_Role__c icr = new Informa_Contact_Role__c();
        icr.Opportunity__c = opp.Id;
        icr.Contact__r = new Contact();
        icr.RecordTypeId = icrRecordtypeId;
        addICRtoWrapper(icr);
        return null;
    }


    /******************************************/
    /**************** Save All ****************/
    /******************************************/

    public Pagereference saveAll() {
        List<Informa_Contact_Role__c> icrsToInsert = new List<Informa_Contact_Role__c>();
        List<Informa_Contact_Role__c> icrsToUpdate = new List<Informa_Contact_Role__c>();
        List<Contact> contactsToUpdate = new List<Contact>();
        Boolean errorsFound = false;
        
        //check for primary
        Integer numPrimary = 0;
        for (ICRWrapper icrw : icrWrapperList) {
            if (icrw.icr != null) {
                if (icrw.icr.Primary_Contact__c)
                    numPrimary++;
            }
        }
        if (numPrimary != 1) {
            errorMessage = 'Please set one (and only one) of the contacts as Primary.';
            showErrorMessage = true;
            errorsFound = true;
        } else {
            for (ICRWrapper icrw : icrWrapperList) {
                icrw.showError_Role = false;
                if (icrw.icr != null && icrw.icr.Id == null && icrw.icr.Contact__c != null)
                    icrsToInsert.add(icrw.icr);
                else if (icrw.icr != null && icrw.icr.Id != null)
                    icrsToUpdate.add(icrw.icr);
                //icrw.icr.Contact__r.MailingState = icrw.icr.Contact__r.Mailing_State_List__c;
                //icrw.icr.Contact__r.MailingCountry = icrw.icr.Contact__r.Mailing_Country_List__c;
                Contact c = icrw.icr.Contact__r;
                c.Id = icrw.icr.Contact__c;
                contactsToUpdate.add(c);
            }
        }
    
        if (!errorsFound) {
            if (contactsToUpdate.size() > 0)
                update contactsToUpdate;
            for (ICRWrapper icrw : icrWrapperList) {
                icrw.icr.Contact__r = null; //not allowed to specify Contact__r in an update call
            }
            if (icrsToInsert.size() > 0)
                insert icrsToInsert;            
            if (icrsToUpdate.size() > 0)
                update icrsToUpdate;
            if (icrsToDelete.size() > 0)
                delete icrsToDelete;
            //Update Opp Name (if necessary)
            /*
            Contact newPrimaryContact = getPrimaryContact();
            if (newPrimaryContact != null && newPrimaryContact != prevPrimaryContact) {
                Opportunity opp = [SELECT Id, Name, Account.Name, CloseDate FROM Opportunity WHERE Id = :opp.Id];
                opp.Name = opp.Account.Name + ' - ' + newPrimaryContact.Name + ' - ' + MiscFunctions.convertDateToString_MMM_yyyy(opp.CloseDate).replace(' ','/');
                update opp;
            }
            */
            //reset page
            icrWrapperList = new List<ICRWrapper>();
            isInlineEditMode = false;
            showErrorMessage = false;
            init();
        }
        return null;
    }
    
        
    /******************************************/
    /************* Wrapper class **************/
    /******************************************/

    public class ICRWrapper {
        public Informa_Contact_Role__c icr {get; set;}
        public Integer tempIcrId {get; set;}
        public Boolean checked {get;set;}
        public String address {get; set;}
        public Integer rowNumber {get; set;}
        public Boolean showError_Role {get;set;}
        public Boolean showError_State {get;set;}

        public Boolean isDelivery {
            get {
                if (icr != null && icr.Contact_Role_s__c != null && icr.Contact_Role_s__c.contains('Delivery'))
                    return true;
                else
                    return false;
            }
        } 

    }

}