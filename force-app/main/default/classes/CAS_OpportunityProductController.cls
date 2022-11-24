/*
* Tested by zTEST_CAS_OpportunityProductController @ 81%
*
* Created by Hailey Niemand - 2015.09.21 - CHG0068080
* Modified by Jeff Lup - 2015.11.19 - INC1646381 & WRQ0503135
* Modified by Shefali Arora - 2019.06.25 - Case no : 01248205
*/

public with sharing class CAS_OpportunityProductController {
//**** Variables for entire page ****
    private ApexPages.StandardController controller;    
    public Opportunity opp {get; set;}
    private List<OpportunityLineItem> OLIs;                             
    public Boolean isEditMode {get; set;}                            
    public Boolean isUk {get; set;}                           
    public Boolean isSgIn {get; set;} //Additional field to be displayed for Singapore and India Users
    
    //**** Variables for edit section only ****
    public List<priceBookEntry> availableProducts {get; set;}
    public String searchString {get; set;}
    public Boolean overLimit {get; set;}
    public Id selectedPbeId {get; set;}
    public Integer selectedTempOliId {get; set;}
    private Integer tempOliId = 0;
    private List<opportunityLineItem> olisToDelete = new List<opportunityLineItem>();
    public String oCurrency='USD';
    public String nCurrency='GBP';
    
    public List<Decimal> listTotalPrice;

    //**** Constructor ****
    public CAS_OpportunityProductController(ApexPages.StandardController controller) {
        this.controller = controller;
        this.opp = (Opportunity)controller.getRecord();
        refreshOLIs();
        isEditMode = false;
        if (UserInfo.getLocale() == 'en_GB') {
            isUk = true;
        } else
            isUk = false;
        if (UserInfo.getProfileId() == '00e0Y000000x4yVQAQ' || UserInfo.getProfileId() == '00e0Y000000x4yWQAQ' ||  UserInfo.getProfileId() == '00e0Y000000x4yRQAQ') { //CAS India & CAS Singapore Profiles
            isSgIn = true;
        } else
            isSgIn = false;
    }

    //**** Refresh OLIs ***
    private void refreshOLIs() {
        
        //Removed "TotalPrice" from the query as it was not being used anywhere ( Case no: 01248205)
        OLIs = [SELECT Id, ProductName__c, Quantity, Description, ListPrice, UnitPrice, OpportunityId, PricebookEntryId, 
                PriceBookEntry.Product2.Name, Lead_Author_Editor__c, Recipient__c, Delivery_Method__c, Adoption_Stage__c, Adoption_Level__c, 
                Book_Order__c, Order_Type__c, IC_Quantity__c, Adoption_Owner__c, Adoption_Date__c, Rep_Verified__c, 
                Future_Ship_Date__c, Feedback_Notification__c, VitalSource_Access_Period__c, Recipient_Address__c, 
                Adoption_Type__c, ServiceDate, CreatedById, CreatedBy.Name, CreatedDate, Fulfillment_House__c
                FROM OpportunityLineItem where OpportunityId =: controller.getid()
                ORDER BY Id];
        
        Set<Id> oliIds = new Set<Id>();
        for (OpportunityLineItem oli : OLIs) {
            oliIds.add(oli.Id);
        }        

        productWrapperList = new List<ProductWrapper>();
        for (OpportunityLineItem oli : OLIs) {
            addOLItoWrapper(oli);
        }
    }

    private void addOLItoWrapper(OpportunityLineItem oli) {
        ProductWrapper pw = new ProductWrapper();
        pw.oli = oli;
        tempOliId++;
        pw.tempOliId = tempOliId;
        if (pw.oli.Future_Ship_Date__c == null)
                pw.oli.Future_Ship_Date__c = Date.today();
        productWrapperList.add(pw);
    }    

    public PageReference cancel() {
        PageReference ref = new PageReference('/' + opp.Id);
        return ref;
    }
  
    public PageReference save() {
    listTotalPrice=new List<Decimal>();
    Decimal grandtotal = 0.0;
    system.debug('LUP: save()');
    system.debug('LUP: save(WrapperLISt**---->)'+productWrapperList);
        overLimit = false;
        // If previously selected products are now removed, we need to delete them
        if (olisToDelete.size() > 0) {
            delete(olisToDelete);
            olisToDelete.clear();
        }
        //Upsert remaining records 
        system.debug('*****-->'+productWrapperList.size());   
        if (productWrapperList.size() > 0) {
            List<OpportunityLineItem> olisToUpsert = new List<OpportunityLineItem>();
            Boolean errorFound = false;
            
            for (ProductWrapper pw : productWrapperList) {

                //Check for Required fields
                pw.showError_Quantity = false;
                pw.showError_ICQuantity = false;
                pw.showError_TextbookFeedbackNotification = false;
                
                

                if (pw.oli.Quantity == null)
                    pw.showError_Quantity = true;
                
                if(pw.oli.Quantity>10000){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Quantity should be 10,000 or less'));
                    return null;
                }
                
                if (pw.oli.IC_Quantity__c == null)
                    pw.showError_ICQuantity = true;
                
                if (pw.oli.Feedback_Notification__c == null)
                    pw.showError_TextbookFeedbackNotification = true;

                if (pw.showError_Quantity || pw.showError_ICQuantity || pw.showError_TextbookFeedbackNotification)
                    errorFound = true;
                else
                    olisToUpsert.add(pw.oli);
                    
                
                if(pw.oli.Quantity!=null && pw.oli.UnitPrice !=null ){
                    system.debug('geandtotal--->InLoop'+pw.oli.Quantity*pw.oli.UnitPrice);
                    Decimal totalPrice=pw.oli.Quantity*pw.oli.UnitPrice;
                    listTotalPrice.add(totalPrice);
                    //grandtotal=grandtotal+totalPrice;
                    System.debug('listTotalPrice---->'+listTotalPrice);
                }
                
                
                
            }
            system.debug('listTotalPrice after---->'+listTotalPrice);
            for(Decimal value:listTotalPrice){
                grandtotal+=value;
            }
            
            System.debug('grandtotal---->'+grandtotal);
            /***Currency Conversion in GBP***/
            
            Set<String> isoCodes = new Set<String>();

            Map<String,Decimal> conversion_rates = new Map<String,Decimal>();
    
            
    
            isoCodes.add(oCurrency);
    
            isoCodes.add(nCurrency);
    
            
    
            for(CurrencyType curr: [SELECT IsoCode,ConversionRate 
    
                                                 FROM CurrencyType 
    
                                                 WHERE IsoCode in: isoCodes]){          
    
                conversion_rates.put(curr.IsoCode,curr.ConversionRate);        
    
            }
            
            //Convert incoming Opportuntiy Amount into USD…

            Double conversionRate = conversion_rates.get(oCurrency);
    
            grandtotal = grandtotal / conversionRate;
    
            
    
            //convert amount as per new currency. 
    
            if(nCurrency != 'USD'){
    
                conversionRate = conversion_rates.get(nCurrency);
    
                grandtotal = grandtotal * conversionRate;
    
            }
            system.debug('*****------->>>>'+grandtotal);
            
            if(grandtotal > 10000000){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'An opportunity can\'t be more than £10,000,000.'));
                return null;
            }

            if (errorFound)
                return null;
            
            update opp;
            upsert(olisToUpsert);
        }

        PageReference ref = new PageReference('/' + opp.Id);
        return ref;
    }
    
   //this is the 'action' method on the page. It will ensure a Pricebook is always selected for the given Opportunity
    public PageReference priceBookCheck(){
        if(opp.pricebook2Id == null){
            try{
                opp.Pricebook2Id = '01s0Y00000832dDQAQ'; //T&F Pricebook as this is the only one CAS uses
                update(opp);
            }
            catch(Exception e){
                ApexPages.addMessages(e);
            }
        }
        return null;
    }
    
    public void updateAvailableList() {
        
        String qString = 'SELECT Id, Pricebook2Id, Product2Id, Product2.Name, Product2.ProductCode, ';
        qString += 'UnitPrice, Product2.Lead_Author_Editor__c, Product2.Edition_Number__c, Product2.Version_Type__c, ';
        qString += 'Product2.Group_Company__c,  Product2.VitalSource_Status__c, Product2.UK_Inventory_Status__c, ';
        qString += 'Product2.UK_Planned_Publication_Date__c, Product2.UK_Publication_Date__c, ';
        qString += 'Product2.US_Inventory_Status__c, Product2.US_Planned_Publication_Date__c, Product2.US_Publication_Date__c ';
        qString += 'FROM PricebookEntry ';
        qString += 'WHERE IsActive = true AND Product2.IsActive = true AND Pricebook2.IsActive = true ';
        qString += ' AND Pricebook2Id = \'' + opp.Pricebook2Id + '\'';
        qString += ' AND CurrencyIsoCode = \'' + opp.currencyIsoCode + '\'';
        
        if (searchString != null) {
            string cleanSearchString = searchString.replace('\'','\\\'');
            if (cleanSearchString.contains('-')) {
                if (cleanSearchString.contains(',')) {
                    string cleanContainsString = cleanSearchString.replace(',','\',\'').replace(' ',''); 
                    qString += ' AND (Product2.Name LIKE \'%' + cleanSearchString + '%\' OR Product2.ProductCode IN (\'' + cleanContainsString + '\') OR Product2.ISBN__c IN (\'' + cleanContainsString + '\') OR Product2.Description LIKE \'%' + cleanSearchString + '%\')';
                } else 
                    qString += ' AND (Product2.Name LIKE \'%' + cleanSearchString + '%\' OR Product2.ProductCode LIKE \'%' + cleanSearchString + '%\' OR Product2.ISBN__c LIKE \'%' + cleanSearchString + '%\' OR Product2.Description LIKE \'%' + cleanSearchString + '%\')';
            } else {
                if (cleanSearchString.contains(',')) {
                    string cleanContainsString = cleanSearchString.replace(',','\',\'').replace(' ',''); 
                    //qString += ' AND (Product2.Name LIKE \'%' + cleanSearchString + '%\' OR Product2.ProductCode IN (\'' + cleanContainsString + '\') OR Product2.Description LIKE \'%' + cleanSearchString + '%\')';
                    qString += ' AND (Product2.Name LIKE \'%' + cleanSearchString + '%\' OR Product2.ProductCode IN (\'' + cleanContainsString + '\') OR Product2.Order_Number__c IN (\'' + cleanContainsString + '\') OR Product2.Description LIKE \'%' + cleanSearchString + '%\')'; //CHG0070223
                } else 
                    //qString += ' AND (Product2.Name LIKE \'%' + cleanSearchString + '%\' OR Product2.ProductCode LIKE \'%' + cleanSearchString + '%\' OR Product2.Description LIKE \'%' + cleanSearchString + '%\')';
                    qString += ' AND (Product2.Name LIKE \'%' + cleanSearchString + '%\' OR Product2.ProductCode LIKE \'%' + cleanSearchString + '%\' OR Product2.Order_Number__c = \'' + cleanSearchString + '\' OR Product2.Description LIKE \'%' + cleanSearchString + '%\')'; //CHG0070223
            }                    
        }
                
        qString+= ' ORDER BY Product2.Name';
        qString+= ' LIMIT 151'; //for performance reasons
        
        system.debug('qString:' +qString);        
        AvailableProducts = database.query(qString);
        
        // We only display up to 150 results... if there are more than we let the user know (see vf page)
        if(AvailableProducts.size()==151) {
            AvailableProducts.remove(150);
            overLimit = true;
        }
        else {
            overLimit = false;
        }
    }

    public void addToSelectedProducts() {
        for (PricebookEntry pbe : availableProducts) {
            if (pbe.Id == selectedPbeId) {
                //Declare new OLI
                OpportunityLineItem oli = new OpportunityLineItem();
                oli.OpportunityId = opp.Id;
                oli.PriceBookEntry = pbe; //relationship set, so vf page can see the Product Name
                oli.PriceBookEntryId = pbe.Id;
                oli.UnitPrice = pbe.UnitPrice;
                //per Sarah the below fields should be defaulted
                oli.Quantity = 1;
                oli.IC_Quantity__c = 1;
                oli.Feedback_Notification__c = 'Send';
                oli.Order_Type__c = 'Complimentary Exam Copy';
                oli.Adoption_Stage__c = 'Created';
                oli.Recipient_Address__c = 'Mailing';
                oli.Delivery_Method__c = 'Standard';
                oli.VitalSource_Access_Period__c = 'Perpetual Access';

                //Add to the wrapper
                addOLItoWrapper(oli);

                //record found, so no need to loop through any more records
                break;
            }
        }
    }
    
    public void removeFromSelectedProducts() {
        // This function runs when a user hits "remove" on an item in the "Selected Products" section
        Integer count = 0;
        for (ProductWrapper pw : productWrapperList) {
            if (pw.tempOliId == selectedTempOliId) {
                if (pw.oli.Id != null)
                    olisToDelete.add(pw.oli);
                productWrapperList.remove(count);
                break;
            }
            count++;
        }
    }
    
/******************************************/
/************* Wrapper class **************/
/******************************************/

    public class ProductWrapper {
        public OpportunityLineItem oli {get; set;}  
        public Integer tempOliId {get; set;}
        public Boolean showError_Quantity {get{if(showError_Quantity == null) showError_Quantity = false; return showError_Quantity;} set;}
        public Boolean showError_ICQuantity {get{if(showError_ICQuantity == null) showError_ICQuantity = false; return showError_ICQuantity;} set;}
        public Boolean showError_TextbookFeedbackNotification {get{if(showError_TextbookFeedbackNotification == null) showError_TextbookFeedbackNotification = false; return showError_TextbookFeedbackNotification;} set;}
        
        public string formattedUnitPrice {
            get {
                return MiscFunctions.formattedAmount(oli.UnitPrice);
            }
            set;
        }
    }
    public List<ProductWrapper> productWrapperList {
        get {
          if (productWrapperList == null) {
            productWrapperList = new List<ProductWrapper>();
          }
          return productWrapperList;
        }
        set;
    }
}