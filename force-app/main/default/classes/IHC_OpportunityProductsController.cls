/*
* Created By Jeff Lup - 2015.07.29 - IHC Separation Project
* Modified by Jeff Lup - 2016.03.28 - CHG0072245 - Errors on New Opportunity in Lightning
* Modified by Sheena John -2022.08.19 -GRQ0326681 - Added 6 aditional fields in Commercial Permissions Sales type
*/

public with sharing class IHC_OpportunityProductsController {

    //**** Variables for entire page ****
    private ApexPages.StandardController controller;     
    public Opportunity opp {get; set;}
    private List<OpportunityLineItem> olis;                             
    public Boolean isEditMode {get; set;}
    public Id clickedOliId {get; set;}
    public Double currencyConversionRate;
    
    //**** Variables for edit section only ****
    public List<priceBookEntry> availableProducts {get; set;}
    public String searchString {get; set;}
    public Boolean overLimit {get; set;}
    public Id selectedPbeId {get; set;}
    public Integer selectedTempOliId {get; set;}
    private Integer tempOliId = 0;
    private List<opportunityLineItem> olisToDelete = new List<opportunityLineItem>();
    public String errorMessage {get;set;}
    public Boolean isProductFamilyRequired {get; set;}

    //**** Constructor ****
    public IHC_OpportunityProductsController(ApexPages.StandardController controller) {
        this.controller = controller;
        this.opp = (Opportunity)controller.getRecord();
        currencyConversionRate = MiscFunctions.getDatedConversionRate(opp.CloseDate, opp.CurrencyIsoCode, Userinfo.getDefaultCurrency());
        refreshOLIs();
        isEditMode = false;
    }
    
    public void init() {
        if (opp != null && opp.Id != null) //CHG0072245
            setPricebook();
    }
    
    private void setPricebook() {
        if (opp.Pricebook2Id == null) {
            opp.Pricebook2Id = '01s0Y00000832ctQAA'; // T&F One-Off Price Book
            update opp;
            controller.save();
        }
        if (opp.Pricebook2Id == '01s0Y00000832ctQAA') // T&F One-Off Price Book
            isProductFamilyRequired = true;
        else
            isProductFamilyRequired = false;
    }
    
    //**** Refresh OLIs ***
    private void refreshOLIs() {
        olis = [SELECT Id, ProductName__c, ProductCode, Recipient__c, Ad_Orientation__c, Colour__c, Position__c, Size__c,
                    Quantity, Description, ListPrice, UnitPrice, TotalPrice, OpportunityId, PricebookEntryId, 
                    PricebookEntry.Product2Id, PriceBookEntry.Product2.ProductCode, PriceBookEntry.Product2.Name, //Opportunity_Product_Type__c,
                    Start_Date__c, End_Date__c, Digital_Object_Identifier__c, Authorized_User_Notes__c,
                    Gross_Cost__c, Other_Notes__c, Split_Delivery__c, Shrink_Wrap__c, Deliver_By__c,
                    IHC_Sales_Type__c, Duration_IHC__c, Fulfilled__c, Delivery_Cost__c, Total_Cost_IHC__c, IHC_Product_Family__c,Publication_Date__c,Art_Required_Date__c, Art_Received__c,
                    Split_Billing__c, Billing_Notes__c, Billing_Month__c, Invoiced__c, Delivery_Instructions__c, Qty__c, Number_of_Issues__c,Planning_Buying_Agency__c,Creative_Art_Agency__c,
                    Rate_Card_Price__c, Series_Discount__c, Volume__c, Issue__c,Article_type__c,Dove_details__c,Drug_Compound__c,Therapy_Area__c,Therapeutic_Indication__c,Language__c
                FROM OpportunityLineItem where OpportunityId =: controller.getid()
                ORDER BY Id];

        productWrapperList = new List<ProductWrapper>();
        for (OpportunityLineItem oli : olis) {
            addOLItoWrapper(oli);
        }
        if (olis.size() == 0)
            selectedTab = 'tabProductSearch';
        else
            selectedTab = 'tabSelectedProducts';
    }

    private void addOLItoWrapper(OpportunityLineItem oli) {
        ProductWrapper pw = new ProductWrapper();
        pw.oli = oli;
        pw.opp = opp;
        pw.currencyConversionRate = currencyConversionRate;
        tempOliId++;
        pw.tempOliId = tempOliId;
        productWrapperList.add(pw);
    }    
    
/******************************************/
/************** Display Mode **************/
/******************************************/
    
    public string selectedTab {get;set;}
    
    //**** Button event for Add/Edit Products
    public PageReference addEditProducts() {
        isEditMode = true; //Go to edit mode
        return null;
     }
     
/******************************************/
/*************** Edit Mode ****************/
/******************************************/

    public Boolean denyClose {
        get {
            denyClose = false;
            if (productWrapperList != null) {
                for (ProductWrapper pw : productWrapperList) {
                    if (pw.showError_StartDate || pw.showError_EndDate || pw.showError_SalesType || pw.showError_ProductFamily || pw.showError_Quantity || pw.showError_Price || pw.showError_Color || pw.showError_DOI ||pw.showError_DoveDetails || pw.showError_FullCitation || pw.showError_Size || pw.showError_Position || pw.showError_Orientation || pw.showError_Duration || pw.showError_Delivery || pw.showError_Billing || pw.showError_RateCard || pw.showError_Volume) {
                        denyClose = true;
                        break;
                    }
                }
            }
            return denyClose;
        }
        set;
    }
    
    public PageReference cancel() {
        overLimit = false;
        refreshOLIs();
        isEditMode = false; //Go back to display mode
        return null;
    }

    public PageReference save() {
        system.debug('LUP: save()');
        overLimit = false;
        // If previously selected products are now removed, we need to delete them
        if (olisToDelete.size() > 0) {
            delete(olisToDelete);
            olisToDelete.clear();
        }
        //Upsert remaining records    
        if (productWrapperList.size() > 0) {
            List<OpportunityLineItem> olisToUpsert = new List<OpportunityLineItem>();
            Boolean errorFound = false;
            for (ProductWrapper pw : productWrapperList) {
                
                //Set defaults
                pw.oli.Quantity = 1;
                if (pw.oli.IHC_Sales_Type__c == 'Commercial Permissions' || pw.oli.IHC_Sales_Type__c == 'Sponsored Focus' || pw.oli.IHC_Sales_Type__c == 'Advertising Sales') {
                    pw.oli.Delivery_Cost__c = 0;
                    pw.oli.Gross_Cost__c = 0; //Other Cost
                }
                
                //Check for Required fields
                pw.showError_StartDate = false;
                pw.showError_EndDate = false;
                pw.showError_SalesType = false;
                pw.showError_ProductFamily = false;
                pw.showError_Quantity = false;
                pw.showError_Price = false;
                pw.showError_Color = false;
                pw.showError_DOI = false;
                pw.showError_DoveDetails = false;
                pw.showError_FullCitation = false;
                pw.showError_Size = false;
                pw.showError_Position = false;
                pw.showError_Orientation = false;
                pw.showError_Duration = false;
                pw.showError_Delivery = false;
                pw.showError_Billing = false;
                pw.showError_RateCard = false;
                pw.showError_Volume = false;
                //pw.showError_Issue = false;
                
                if (pw.oli.IHC_Sales_Type__c == 'Sponsored Focus') {
                    if (pw.oli.Start_Date__c == null) {      
                        pw.showError_StartDate = true;
                        errorFound = true;
                    }
                    if (pw.oli.End_Date__c == null && pw.oli.Duration_IHC__c != 'perpetual' && pw.oli.Duration_IHC__c != 'Perpetual') {
                        pw.showError_EndDate = true;
                        errorFound = true;
                    }
                }
                if (pw.oli.IHC_Sales_Type__c == null) {
                    pw.showError_SalesType = true;
                    errorFound = true;
                }
                if (pw.oli.IHC_Product_Family__c == null && isProductFamilyRequired && pw.oli.IHC_Sales_Type__c == 'Advertising Sales') {
                    pw.showError_ProductFamily = true;
                    errorFound = true;
                }
                if ((pw.oli.Quantity == null || pw.oli.Quantity == 0) && pw.oli.IHC_Sales_Type__c != 'Sponsored Focus') {
                    pw.showError_Quantity = true;
                    errorFound = true;
                    pw.oli.Quantity = null;
                }
                if (pw.oli.UnitPrice == null) {
                    pw.showError_Price = true;
                    errorFound = true;
                }
                if (pw.oli.Colour__c == null && (pw.oli.IHC_Sales_Type__c == 'Commercial Reprints' || pw.oli.IHC_Sales_Type__c == 'Advertising Sales' || pw.oli.IHC_Sales_Type__c == 'Commercial Supplements')) {
                    pw.showError_Color = true;
                    errorFound = true;
                }
                if ((pw.oli.Digital_Object_Identifier__c == null || pw.oli.Digital_Object_Identifier__c == '') && pw.oli.IHC_Sales_Type__c != 'Advertising Sales' && pw.oli.IHC_Sales_Type__c != 'Commercial Supplements') {
                    pw.showError_DOI = true;
                    errorFound = true;
                }
               if ((pw.oli.Dove_details__c == null || pw.oli.Dove_details__c == '')) {
                   pw.showError_DoveDetails = true;
                    errorFound = true;
                }
                
                if ((pw.oli.Authorized_User_Notes__c == null || pw.oli.Authorized_User_Notes__c == '') && pw.oli.IHC_Sales_Type__c != 'Advertising Sales') {
                    pw.showError_FullCitation = true;
                    errorFound = true;
                }
                if (pw.oli.Size__c == null && pw.oli.IHC_Sales_Type__c == 'Advertising Sales') {
                    pw.showError_Size = true;
                    errorFound = true;
                }
                if (pw.oli.Position__c== null && pw.oli.IHC_Sales_Type__c == 'Advertising Sales') {
                    pw.showError_Position = true;
                    errorFound = true;
                }
                if (pw.oli.Ad_Orientation__c == null && pw.oli.Size__c == '1/2 Page' && pw.oli.IHC_Sales_Type__c == 'Advertising Sales') {
                    pw.showError_Orientation = true;
                    errorFound = true;
                }
                if (pw.oli.Duration_IHC__c == null && pw.oli.IHC_Sales_Type__c == 'Sponsored Focus') {
                    pw.showError_Duration = true;
                    errorFound = true;
                }
                if ((pw.oli.Delivery_Instructions__c == null || pw.oli.Delivery_Instructions__c == '') && pw.oli.Split_Delivery__c && (pw.oli.IHC_Sales_Type__c == 'Commercial Reprints' || pw.oli.IHC_Sales_Type__c == 'Commercial Supplements')) {
                    pw.showError_Delivery = true;
                    errorFound = true;
                }
                if ((pw.oli.Billing_Notes__c == null || pw.oli.Billing_Notes__c == '') && pw.oli.Split_Billing__c && pw.oli.IHC_Sales_Type__c != 'Commerical ePrints') {
                    pw.showError_Billing = true;
                    errorFound = true;
                }
                if ((pw.oli.Rate_Card_Price__c == null || pw.oli.Rate_Card_Price__c < pw.oli.UnitPrice) && pw.oli.IHC_Sales_Type__c == 'Advertising Sales') {
                    pw.showError_RateCard = true;
                    errorFound = true;
                }
                if ((pw.oli.Volume__c == null || pw.oli.Volume__c == '') && pw.oli.IHC_Sales_Type__c == 'Advertising Sales') {
                    pw.showError_Volume = true;
                    errorFound = true;
                }
                //if ((pw.oli.Issue__c == null || pw.oli.Issue__c == '') && pw.oli.IHC_Sales_Type__c == 'Advertising Sales') {
                //    pw.showError_Issue = true;
                //    errorFound = true;
                //}
                
                if (!errorFound) {
                    pw.oli.Series_Discount__c = (pw.oli.Rate_Card_Price__c == null ? 0 : pw.oli.Rate_Card_Price__c) - pw.oli.UnitPrice;
                    olisToUpsert.add(pw.oli);
                }
            }
            if (!errorFound) {
                errorMessage = '';
                upsert(olisToUpsert);
            } else {
                errorMessage = ' Please see below errors...';
            }
        }
        return null;
    }
    
    public void updateAvailableList() {
        String qString = 'SELECT Id, PricebookEntry.Product2.Service_Description__c, Pricebook2Id, Product2Id,';
        qString += ' IsActive, Product2.ProductCode, Product2.Name, Product2.Family, Product2.IsActive, Product2.Description,';
        qString += ' UnitPrice ';
        qString += 'FROM PricebookEntry ';
        qString += 'WHERE IsActive=true';
        qString += ' AND Pricebook2Id = \'' + opp.Pricebook2Id + '\'';
        qString += ' AND CurrencyIsoCode = \'' + opp.currencyIsoCode + '\'';
        
        if (searchString != null){
            qString += ' AND (Product2.Name LIKE \'%' + searchString + '%\' OR Product2.ProductCode LIKE \'%' + searchString + '%\' OR Product2.Description LIKE \'%' + searchString + '%\')';
        }
        
        qString+= ' ORDER BY Product2.Name';
        qString+= ' LIMIT 151'; //for performance reasons
        
        system.debug('qString:' +qString);        
        availableProducts = database.query(qString);
        
        //TODO: Ask Andrew about limit *************************************************
        
        // We only display up to 150 results... if there are more than we let the user know (see vf page)
        if(availableProducts.size()==151){
            availableProducts.remove(150);
            overLimit = true;
        }
        else{
            overLimit = false;
        }
    }

    public void addToSelectedProducts() {
        for (PricebookEntry pbe : availableProducts) {
            if (pbe.Id == selectedPbeId) {
                //Declare new OLI
                OpportunityLineItem oli = new OpportunityLineItem();
                oli.OpportunityId = opp.Id;
                oli.PriceBookEntry = pbe; //relationship set, so vf page can see the Product Name (this stopped working)
                oli.PriceBookEntryId = pbe.Id;
                oli.UnitPrice = pbe.UnitPrice;
                oli.Quantity = 1;
                //if (pbe.Product2.Product_Category__c == 'Subscription')
                //    oli.SAP_Order_Type_ITM__c = 'ZTLV';
                //else if (pbe.Product2.Product_Category__c == 'Consulting')
                //    oli.SAP_Order_Type_ITM__c = 'ZCLT';
                //else if (pbe.Product2.Product_Category__c == 'Single Copy')
                //    oli.SAP_Order_Type_ITM__c = 'ZSIN';

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

    //TODO: Is this needed???????????????
    /* 
    public PageReference changePricebook(){    
        // This simply returns a PageReference to the standard Pricebook selection screen
        // Note that is uses retURL parameter to make sure the user is sent back after they choose
        PageReference ref = new PageReference('/oppitm/choosepricebook.jsp');
        ref.getParameters().put('id', opp.Id);
        ref.getParameters().put('retURL','/apex/opportunityProductEntry?id=' + opp.Id);
        return ref;
    }
    */
    
/******************************************/
/************* Wrapper class **************/
/******************************************/

    public class ProductWrapper {
        public Opportunity opp {get; set;}  
        public OpportunityLineItem oli {get; set;}  
        public Integer tempOliId {get; set;}
        public Double currencyConversionRate {get; set;}
        public String dualTotalPrice {
            get {
                if (opp.CurrencyIsoCode == Userinfo.getDefaultCurrency()) {
                    dualTotalPrice = opp.CurrencyIsoCode + ' ' + MiscFunctions.formattedAmount(oli.TotalPrice == null ? 0 : oli.TotalPrice);
                } else {
                    dualTotalPrice = opp.CurrencyIsoCode + ' ' + MiscFunctions.formattedAmount(oli.TotalPrice == null ? 0 : oli.TotalPrice) + '<br>(' + Userinfo.getDefaultCurrency() + ' ' + MiscFunctions.formattedAmount((oli.TotalPrice == null ? 0 : oli.TotalPrice) * currencyConversionRate) + ')';
                }
                return dualTotalPrice;
            }
            set;
        }        
        public String dualTotalCost {
            get {
                if (opp.CurrencyIsoCode == Userinfo.getDefaultCurrency()) {
                    dualTotalCost = opp.CurrencyIsoCode + ' ' + MiscFunctions.formattedAmount(oli.Total_Cost_IHC__c == null ? 0 : oli.Total_Cost_IHC__c);
                } else {
                    dualTotalCost = opp.CurrencyIsoCode + ' ' + MiscFunctions.formattedAmount(oli.Total_Cost_IHC__c == null ? 0 : oli.Total_Cost_IHC__c) + '<br>(' + Userinfo.getDefaultCurrency() + ' ' + MiscFunctions.formattedAmount((oli.Total_Cost_IHC__c == null ? 0 : oli.Total_Cost_IHC__c) * currencyConversionRate) + ')';
                }
                return dualTotalCost;
            }
            set;
        }        
        public String dualUnitPrice {
            get {
                if (opp.CurrencyIsoCode == Userinfo.getDefaultCurrency()) {
                    dualUnitPrice = opp.CurrencyIsoCode + ' ' + MiscFunctions.formattedAmount(oli.UnitPrice == null ? 0 : oli.UnitPrice);
                } else {
                    dualUnitPrice = opp.CurrencyIsoCode + ' ' + MiscFunctions.formattedAmount(oli.UnitPrice == null ? 0 : oli.UnitPrice) + '<br>(' + Userinfo.getDefaultCurrency() + ' ' + MiscFunctions.formattedAmount((oli.UnitPrice == null ? 0 : oli.UnitPrice) * currencyConversionRate) + ')';
                }
                return dualUnitPrice;
            }
            set;
        }
        public String dualRateCard {
            get {
                if (opp.CurrencyIsoCode == Userinfo.getDefaultCurrency()) {
                    dualRateCard = opp.CurrencyIsoCode + ' ' + MiscFunctions.formattedAmount(oli.Rate_Card_Price__c == null ? 0 : oli.Rate_Card_Price__c);
                } else {
                    dualRateCard = opp.CurrencyIsoCode + ' ' + MiscFunctions.formattedAmount(oli.Rate_Card_Price__c == null ? 0 : oli.Rate_Card_Price__c) + '<br>(' + Userinfo.getDefaultCurrency() + ' ' + MiscFunctions.formattedAmount((oli.Rate_Card_Price__c == null ? 0 : oli.Rate_Card_Price__c) * currencyConversionRate) + ')';
                }
                return dualRateCard;
            }
            set;
        }
        public String dualSeriesDiscount {
            get {
                if (opp.CurrencyIsoCode == Userinfo.getDefaultCurrency()) {
                    dualSeriesDiscount = opp.CurrencyIsoCode + ' ' + MiscFunctions.formattedAmount(oli.Series_Discount__c == null ? 0 : oli.Series_Discount__c);
                } else {
                    dualSeriesDiscount = opp.CurrencyIsoCode + ' ' + MiscFunctions.formattedAmount(oli.Series_Discount__c == null ? 0 : oli.Series_Discount__c) + '<br>(' + Userinfo.getDefaultCurrency() + ' ' + MiscFunctions.formattedAmount((oli.Series_Discount__c == null ? 0 : oli.Series_Discount__c) * currencyConversionRate) + ')';
                }
                return dualSeriesDiscount;
            }
            set;
        }
        
        public Boolean showError_StartDate {get{if(showError_StartDate == null) showError_StartDate=false; return showError_StartDate;} set;}
        public Boolean showError_EndDate {get{if(showError_EndDate == null) showError_EndDate=false; return showError_EndDate;} set;}
        public Boolean showError_SalesType {get{if(showError_SalesType == null) showError_SalesType=false; return showError_SalesType;} set;}
        public Boolean showError_ProductFamily {get{if(showError_ProductFamily == null) showError_ProductFamily=false; return showError_ProductFamily;} set;}
        public Boolean showError_Quantity {get{if(showError_Quantity == null) showError_Quantity=false; return showError_Quantity;} set;}
        public Boolean showError_Price {get{if(showError_Price == null) showError_Price=false; return showError_Price;} set;}
        public Boolean showError_Color {get{if(showError_Color == null) showError_Color=false; return showError_Color;} set;}
        public Boolean showError_DOI {get{if(showError_DOI == null) showError_DOI=false; return showError_DOI;} set;}
        public Boolean showError_DoveDetails {get{if(showError_DoveDetails == null) showError_DoveDetails=false; return showError_DoveDetails;} set;}
        public Boolean showError_FullCitation {get{if(showError_FullCitation == null) showError_FullCitation=false; return showError_FullCitation;} set;}
        public Boolean showError_Size {get{if(showError_Size == null) showError_Size=false; return showError_Size;} set;}
        public Boolean showError_Position {get{if(showError_Position == null) showError_Position=false; return showError_Position;} set;}
        public Boolean showError_Orientation {get{if(showError_Orientation == null) showError_Orientation=false; return showError_Orientation;} set;}
        public Boolean showError_Duration {get{if(showError_Duration == null) showError_Duration=false; return showError_Duration;} set;}
        public Boolean showError_Delivery {get{if(showError_Delivery == null) showError_Delivery=false; return showError_Delivery;} set;}
        public Boolean showError_Billing {get{if(showError_Billing == null) showError_Billing=false; return showError_Billing;} set;}
        public Boolean showError_RateCard {get{if(showError_RateCard == null) showError_RateCard=false; return showError_RateCard;} set;}
        public Boolean showError_Volume {get{if(showError_Volume == null) showError_Volume=false; return showError_Volume;} set;}
        //public Boolean showError_Issue {get{if(showError_Issue == null) showError_Issue=false; return showError_Issue;} set;}
        
        
        /*
        public List<SelectOption> getSizeList() {
            //get available choices from product
            List<Product_Dependent_Picklists__c> picklists = [SELECT Size__c
                FROM Product_Dependent_Picklists__c
                WHERE Product__c = :oli.PricebookEntry.Product2Id
                    AND Size__c <> null];
    
            //put in Set to remove dupes
            Set<String> setItems = new Set<String>();
            for (Product_Dependent_Picklists__c picklist : picklists) {
                setItems.add(picklist.Size__c);         
            }
            if (setItems.size() == 1)
                oli.Size__c = getSoleItemFromSet(setItems);
            return getPicklistsFromSet(setItems);
        }
    
        public List<SelectOption> getPositionList() {
            //get available choices from product
            List<Product_Dependent_Picklists__c> picklists = [SELECT Position__c
                FROM Product_Dependent_Picklists__c
                WHERE Product__c = :oli.PricebookEntry.Product2Id
                    AND (Size__c = :oli.Size__c OR Size__c = null)
                    AND Position__c <> null];
    
            //put in Set to remove dupes
            Set<String> setItems = new Set<String>();
            for (Product_Dependent_Picklists__c picklist : picklists) {
                setItems.add(picklist.Position__c);         
            }
            if (setItems.size() == 1)
                oli.Position__c = getSoleItemFromSet(setItems);
            return getPicklistsFromSet(setItems);
        }

        public List<SelectOption> getOrientationList() {
            //get available choices from product
            List<Product_Dependent_Picklists__c> picklists = [SELECT Orientation__c
                FROM Product_Dependent_Picklists__c
                WHERE Product__c = :oli.PricebookEntry.Product2Id
                    AND (Position__c = :oli.Position__c OR Position__c = null)
                    AND (Size__c = :oli.Size__c OR Size__c = null)
                    AND Orientation__c <> null];
    
            //put in Set to remove dupes
            Set<String> setItems = new Set<String>();
            for (Product_Dependent_Picklists__c picklist : picklists) {
                setItems.add(picklist.Orientation__c);          
            }
            if (setItems.size() == 1)
                oli.Ad_Orientation__c = getSoleItemFromSet(setItems);
            return getPicklistsFromSet(setItems);
        }
    
        public List<SelectOption> getColourList() {
            //get available choices from product
            List<Product_Dependent_Picklists__c> picklists = [SELECT Colour_or_BW__c
                FROM Product_Dependent_Picklists__c
                WHERE Product__c = :oli.PricebookEntry.Product2Id
                    AND (Position__c = :oli.Position__c OR Position__c = null)
                    AND (Size__c = :oli.Size__c OR Size__c = null)
                    AND (Orientation__c = :oli.Ad_Orientation__c OR Orientation__c = null)
                    AND Colour_or_BW__c <> null];
    
            //put in Set to remove dupes
            Set<String> setItems = new Set<String>();
            for (Product_Dependent_Picklists__c picklist : picklists) {
                setItems.add(picklist.Colour_or_BW__c);         
            }
            if (setItems.size() == 1)
                oli.Colour__c = getSoleItemFromSet(setItems);
            return getPicklistsFromSet(setItems);
        }
        
        private List<SelectOption> getPicklistsFromSet(Set<String> setItems) {
            //put back in List to sort
            List<String> listItems = new List<String>();
            for (String item : setItems) {
                listItems.add(item);
            }
            listItems.sort();
    
            // Create the Select Options
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('', ''));
            for (String item : listItems) {
                options.add(new SelectOption(item, item));
            }
            return options;
        }
    
        private String getSoleItemFromSet(Set<String> setItems) {
            if (setItems.size() == 1) {
                for (String item : setItems) {
                    return item;
                }
            }
            return null;
        }   
        */
        
        /*
        public boolean hasSeats {get; set;}
        public boolean hasRegion {get; set;}
        public boolean hasCountry {get; set;}
        public boolean hasHours {get; set;}
        public Boolean showError_OppProdType {get{if(showError_OppProdType == null) showError_OppProdType=false; return showError_OppProdType;} set;}
        public Boolean showError_LicenseType {get{if(showError_LicenseType == null) showError_LicenseType=false; return showError_LicenseType;} set;}
        public Boolean showError_LicenseDetail {get{if(showError_LicenseDetail == null) showError_LicenseDetail=false; return showError_LicenseDetail;} set;}
        public Boolean hasChildren {get; set;} 
        public Boolean isSubscription {get; set;} 

        public string formattedUnitPrice {
            get {
                return MiscFunctions.formattedAmount(oli.UnitPrice);
            }
            set;
        }
        */
        
        //TODO: See InformOvum_OpportunityProductController if there is more stuff to add
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
    
    public void testhelper() { //called by test method
        for (ProductWrapper pw : productWrapperList) {
            String sTest = pw.dualTotalPrice;
            sTest = pw.dualTotalCost;
            sTest = pw.dualUnitPrice;
            sTest = pw.dualRateCard;
            sTest = pw.dualSeriesDiscount;
        }        
    }
    
}