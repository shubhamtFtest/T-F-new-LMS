/*
* Created By Jeff Lup - 2014.05.01
* Modified By Hailey Niemand - 2014.08.13 - CHG0060537
* Modified by Jeff Lup - 2015.02.23 - CHG0064313 - T&Cs & OCF rework for BI
* Modified by Jeff Lup - 2015.03.05 - CHG0064801 - Use Primary Billing/Delivery, when more than one found
* Modified by Mondtree.com - 2017.09.14 - CHG0037592 - Correct Billing AMount from individual Billing's Total Price instead of Opp AMount
* Modified by Tom Reed - 2019.05.03 - 01187849 - If an address is populated on opportunity it is to be used over the billing contact address.
* Modified by Faiz Ali - 2019.08.13 -01295816- OCF not to fetch address fields from contact neither they should override the address fields on Opp.
                                               User should manually enter address fields on Opp, error message thrown if he fails to do so.
* Modified by Matthew Smith - 2021.01.14 - 01765787 - Making the PDF dynamic so it supports more than one URL for T&Cs
*/
public with sharing class IHC_OCF_Controller {
    private ApexPages.StandardController controller {get; set;}
    private final Opportunity opp;

    private List<OpportunityLineItem> olis;
    private Map<String, OpportunityContactRole> ocrMap;
    public String productTotal {get;set;}
    public String productCostTotal {get;set;}
    public Boolean hasOppAddress {get;set;}
    public String OLISalesType {get;set;}
    
    //public Account account {get;set;}
    
    public List<Bill> bills {get;set;}
     
    public IHC_OCF_Controller(ApexPages.StandardController controller) {
        this.controller = controller;
        //this.opp = (Opportunity)controller.getRecord();
        this.opp = [SELECT Id, Owner.Email, Owner.Name, Owner.Phone, Owner.Legal_Entity__c,
                //Email_Subject__c, Email_Body__c, Pricing_Letter__c
                Amount, AccountId,
                CurrencyIsoCode, //Non_Standard_Terms__c, //Addendum__c,
                //Sales_Organisation__c, OCF_Approved__c, 
                Payment_Terms__c, Client_PO_No__c,
                //Delivery_Method__c,
                Start_Date__c, End_Date__c, //Length_of_Contract__c,
                Pricebook2Id, StageName,
                //Countersignature_Required__c, //Autorenewal_Clause_Removed__c,
                //Governing_Law__c,
                //Additional_Permitted_Use__c, Append_Terms_to_OCF__c,
                Tax_Code__c, Tax_Code_Number__c, Description,Shipping_City__c,Shipping_Country__c,Shipping_State_Province__c,Shipping_Street__c,Shipping_Zip_Postal_Code__c,
                Address_City__c, Address_Country__c, Address_State_Province__c, Address_Street__c, Address_Zip_Postal_Code__c
            FROM Opportunity WHERE ID = :ApexPages.currentPage().getParameters().get('id')];
        
        if(opp.Address_City__c!=null && opp.Address_Country__c!=null  && opp.Address_Street__c!=null
            && opp.Address_Zip_Postal_Code__c!=null && opp.Shipping_City__c!=null && opp.Shipping_Country__c!=null  && opp.Shipping_Street__c!=null
            && opp.Shipping_Zip_Postal_Code__c!=null){hasOppAddress=true;} 
       else{
           hasOppAddress=false;                     
           }
        
        Boolean success;
        success = getOlis();
        if (success)
            success = checkRequiredFields();
        if (success)
            success = getOcrs();
        //if (success) 
        //    success = getAccount();
        if (success) 
            success = getBillings();
        
        //Show report or error message
        if (success) {
            isPDF = 'PDF';
            showReport = true;
        } else {
            isPDF = '';
            showReport = false;
        }
    }
    
    public void populateOppAddress() {

        //If there is no opportunity address populated, add the address from the billing contact.            
        if(!hasOppAddress && ocrMap.containsKey('Billing')){
            
            OpportunityContactRole ocrBillingAddress = ocrMap.get('Billing');
            Boolean needsUpdate = false;
            
            if(ocrBillingAddress.Contact.MailingCity != null){
                this.opp.Address_City__c = ocrBillingAddress.Contact.MailingCity;
                needsUpdate = true;    
            }
            if(ocrBillingAddress.Contact.MailingCountry != null){
                this.opp.Address_Country__c = ocrBillingAddress.Contact.MailingCountry;
                needsUpdate = true;    
            }
            if(ocrBillingAddress.Contact.MailingState != null){
                this.opp.Address_State_Province__c = ocrBillingAddress.Contact.MailingState;
                needsUpdate = true;    
            }
            if(ocrBillingAddress.Contact.MailingStreet != null){
                this.opp.Address_Street__c = ocrBillingAddress.Contact.MailingStreet;
                needsUpdate = true;    
            }
            if(ocrBillingAddress.Contact.MailingPostalCode != null){
                this.opp.Address_Zip_Postal_Code__c = ocrBillingAddress.Contact.MailingPostalCode;
                needsUpdate = true;    
            }
          //  if(needsUpdate) update this.opp;
            //Reconstruct the billing address on the VF page.
            fullAddress('Billing');
            
        }
        
        
    }
    
    private Boolean getOlis() {
        olis = [SELECT PricebookEntry.ProductCode, PricebookEntry.Product2.Name,
                    PricebookEntry.Product2.Service_Description__c,
                    UnitPrice, TotalPrice,
                    //License_Type_ITM__c, Site__c, Country_List__c, Region_ITM__c, Seats_Users_ITM__c, Number_of_Hours__c,
                    Start_Date__c, End_Date__c, Description, //PricebookEntry.Product2.Product_Category__c, 
                    Authorized_User_Notes__c, IHC_Sales_Type__c, Deliver_By__c, Split_Delivery__c, Digital_Object_Identifier__c,
                    Colour__c, Shrink_Wrap__c, Quantity, Delivery_Cost__c, Gross_Cost__c, Other_Notes__c,
                    Duration_IHC__c, Size__c, Ad_Orientation__c, Position__c, Fulfilled__c, IHC_Product_Family__c,
                    Total_Cost_IHC__c, Split_Billing__c, Billing_Notes__c, Delivery_Instructions__c, Qty__c, Number_of_Issues__c,
                    Volume__c, Issue__c, Rate_Card_Price__c, Series_Discount__c
                FROM OpportunityLineItem
                WHERE OpportunityId = :opp.Id
                ORDER BY CreatedDate]; 
        if (olis.size() == 0) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'There were no Products found for this Opportunity.  Please add products before proceeding.'));
            return false;
        } else {
            return true;            
        }
    }
    
    private Boolean checkRequiredFields() {
        
        for (OpportunityLineItem oli : olis) {
            if (oli.IHC_Sales_Type__c == null) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'One or more Products are missing a Sales Type.  Please add before proceeding.'));
                return false;
            }
         
        }
        return true;
    }
    
    private Boolean getOcrs() {
        List<OpportunityContactRole> ocrs = [SELECT Id, Role, Contact.Name, Contact.Email, Contact.MailingStreet,
                                                Contact.MailingCity, Contact.MailingState, Contact.MailingPostalCode,
                                                Contact.MailingCountry, Contact.Account.Name            
                                            FROM OpportunityContactRole
                                            WHERE OpportunityId = :opp.Id
                                            ORDER BY IsPrimary ASC]; //Primary will be last, so map will keep last Delivery/Billing - CHG0064801
                                            
        ocrMap = new Map<String, OpportunityContactRole>();
        for (OpportunityContactRole ocr : ocrs) {
            ocrMap.put(ocr.Role, ocr);
        }
        system.debug('##map##'+ocrMap.keyset() );
        if (!ocrMap.containsKey('Billing') || !ocrMap.containsKey('Delivery')) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please add an Billing and Delivery contact before proceeding.'));
            return false;
        }
        system.debug('#hasOppAddress#'+hasOppAddress);
        if(!hasOppAddress){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Kindly fill in OCF Billing & Shipping Address fields before proceeding.'));
            system.debug('inside');
            return false;
        }
        return true;
    }

    //private Boolean getAccount() {
    //    account = [SELECT Tax_Code_1__c, Tax_Code_2__c, Tax_Code_3__c,
    //                Tax_Code_Number_1__c, Tax_Code_Number_2__c, Tax_Code_Number_3__c
    //              FROM Account
    //              WHERE Id = :opp.AccountId];
    //    return true;
    //}

    public T_F_One_Off_Settings__c tfSetting {
        get {
            if (tfSetting == null)
                tfSetting = tfSetting = T_F_One_Off_Settings__c.getOrgDefaults();
            return tfSetting;
        }
        set;
    }

    public string companyAddress {
        get {
            if (tfSetting.Company_Address__c == null)
                return '';
            else 
                return tfSetting.Company_Address__c.replaceAll('\n','<br />');
        }
        set;
    }           
    
    public string companyPhone {
        get {
            if (tfSetting.Company_Phone__c == null)
                return opp.Owner.Phone;
            else 
                return tfSetting.Company_Phone__c;
        }
        set;
    }
    
    private Boolean getBillings(){
    
     List<Billing__c> billings = [SELECT Bill_Date__c, Total_Price__c, Payment_Terms__c,Issue__c,Amount__c
                                     FROM Billing__c
                                     WHERE Opportunity__c = :opp.Id
                                     ORDER BY Bill_Date__c ASC];
     List<OpportunityLineItem> olisSalestype = [SELECT IHC_Sales_Type__c  FROM OpportunityLineItem WHERE OpportunityId =:opp.Id];                          
     if (billings.size() == 0 && olisSalestype[0].IHC_Sales_Type__c  == 'Advertising Sales') {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'There were no Billings found for this Opportunity.  Please add Billings before proceeding.'));
            return false;
        } else
         {
          bills = new List<Bill>();
          for (Billing__c billing : billings) {
                    Bill bill = new Bill();
                    bill.billDate = billing.Bill_Date__c == null ? '' : billing.Bill_Date__c.format();
                    //bill.amount = this.opp.Amount + ' ' + opp.CurrencyIsoCode; //Commented the line as per CHG0037592
                    bill.amount = billing.Amount__c == null ? '' : billing.Amount__c.format() + ' ' + opp.CurrencyIsoCode; //Changed to individual Bill's Amount field as per CHG0037592
                    bill.paymentTerms = billing.Payment_Terms__c;
                    bill.Issue = billing.Issue__c;
                    bills.add(bill);
                    System.debug('bill'+bill);
                }
             
          return true;
         }
           
       
    } 
    
    
    
    
     public class Bill {
        public String billDate {get;set;}
        public String amount {get;set;}
        public String paymentTerms {get;set;}
        public string Issue{get;set;}
    }
    
    public String isPDF {get; set;}
    public Boolean showReport {get; set;}
    public String ocfDate {get { return date.today().format(); } set;}
    
    public String serviceDates { get { return ''; }} //no longer used

    public String billingContact { get { return ocrMap.get('Billing').Contact.Name; }}
    public String billingEmail { get { return ocrMap.get('Billing').Contact.Email; }}
    public String billingBusinessName { get { return ocrMap.get('Billing').Contact.Account.Name; }}
    public String billingAddress { get { return fullAddress('Billing'); }}

    public String deliveryContact { get { return ocrMap.get('Delivery').Contact.Name; }}
    public String deliveryEmail { get { return ocrMap.get('Delivery').Contact.Email; }}
    public String deliveryBusinessName { get { return ocrMap.get('Delivery').Contact.Account.Name; }}
    public String deliveryAddress { get { return fullAddress('Delivery'); }}

    private String fullAddress(String addressType) {
        string temp = '';
        //If the Billing address is being processed use the address fields on the Opportunity.
        if(addressType=='Billing'){
            if (opp.Address_Street__c != null)
                temp += opp.Address_Street__c + '<br />';
            if (opp.Address_City__c != null)
                temp += opp.Address_City__c + ', ';
            if (opp.Address_State_Province__c != null)
                temp += opp.Address_State_Province__c + ' ';
            if (opp.Address_Zip_Postal_Code__c != null)
                temp += opp.Address_Zip_Postal_Code__c + '<br />';
            if (opp.Address_Country__c != null)
                temp += opp.Address_Country__c + '<br />';                         
        } else 
        /*if (ocrMap.containsKey(addressType)) {
            if (ocrMap.get(addressType).Contact.MailingStreet != null)
                temp += (ocrMap.get(addressType).Contact.MailingStreet).replaceAll('\n','<br />') + '<br />';
            if (ocrMap.get(addressType).Contact.MailingCity != null)
                temp += ocrMap.get(addressType).Contact.MailingCity + ', ';
            if (ocrMap.get(addressType).Contact.MailingState != null)
                temp += ocrMap.get(addressType).Contact.MailingState + ' ';
            if (ocrMap.get(addressType).Contact.MailingPostalCode != null)
                temp += ocrMap.get(addressType).Contact.MailingPostalCode + '<br />';
            if (ocrMap.get(addressType).Contact.MailingCountry != null)
                temp += ocrMap.get(addressType).Contact.MailingCountry + '<br />';
        } */
        if (addressType=='Delivery') {
            if (opp.Shipping_Street__c != null)
                temp += (opp.Shipping_Street__c).replaceAll('\n','<br />') + '<br />';
            if (opp.Shipping_City__c != null)
                temp += opp.Shipping_City__c + ', ';
            if (opp.Shipping_State_Province__c != null)
                temp += opp.Shipping_State_Province__c + ' ';
            if (opp.Shipping_Zip_Postal_Code__c != null)
                temp += opp.Shipping_Zip_Postal_Code__c + '<br />';
            if (opp.Shipping_Country__c != null)
                temp += opp.Shipping_Country__c + '<br />';
        }
        return temp;
    }
    
    public String taxCodes {
        get {
            if (opp.Tax_Code__c != null && opp.Tax_Code__c != 'N/A')
                return opp.Tax_Code__c + ': ' + opp.Tax_Code_Number__c;
            else
                return 'N/A';
        }
    }
    
    public String taxWarning {
        get {
            if (taxCodes == 'N/A')
                return '(sales tax and/or other applicable taxes will be charged unless provided)';
            else 
                return '';
        }
    }

    public String otherInfo{
        get {
            if (opp.Description == null)
                return '';
            else 
                return 'Other information: ' + opp.Description;
        }
    }
    
    public String accessRun{
        get {
            if (opp.Start_Date__c == null || opp.End_Date__c == null)
                return '';
            else 
                //return 'Access Runs from ' + MiscFunctions.convertDateToString_MMM_d_yyyy(opp.Start_Date__c) + ' to ' + MiscFunctions.convertDateToString_MMM_d_yyyy(opp.End_Date__c) + ' (' + opp.Length_of_Contract__c + ' months)';
                //return 'Term of License: ' + MiscFunctions.convertDateToString_MMM_d_yyyy(opp.Start_Date__c) + ' to ' + MiscFunctions.convertDateToString_MMM_d_yyyy(opp.End_Date__c) + ' (' + opp.Length_of_Contract__c + ' months)';
                return 'Term of License: ' + MiscFunctions.convertDateToString_MMM_d_yyyy(opp.Start_Date__c) + ' to ' + MiscFunctions.convertDateToString_MMM_d_yyyy(opp.End_Date__c);
        }
    }

    //public String deliveryMethod{
    //    get {
    //        if (opp.Delivery_Method__c == null || opp.Delivery_Method__c == null)
    //            return '';
    //        else 
    //            return 'Delivery Method: ' + opp.Delivery_Method__c;
    //    }
    //}
        
    public String specialTerms {
        get {
            string temp = '';
            //if (opp.Non_Standard_Terms__c != null || opp.Non_Standard_Terms__c != '' )
            //    temp = opp.Non_Standard_Terms__c; 
            if (temp == '' || temp == null)
                temp = 'N/A';
            return temp;
        }
    }
    
    public String showIfJapan {
        get {
            if (ocrMap.get('Delivery').Contact.MailingCountry == 'Japan')
                return '';
            else
                return 'isHidden';
        }
        set;
    }
    
    //CHG0064313
    public String productDetails {
        get {
            string temp = '<table width="100%">';
            //temp += '<tr>';
            //temp += '<td width="15%">Permitted Use:</td>';
            //temp += '<td width="85%">Information made available through the Licensed Product(s) may be displayed, reformatted and distributed internally within the Customer\'s organization only in insubstantial portions for research and related work in the ordinary course of the Customer\'s business. No other internal or external dissemination of any portion of the Licensed Product(s) is permitted except as expressly indicated below.</td>';
            //temp += '</tr>';
            //if (opp.Additional_Permitted_Use__c != null) {
            //    temp += '<tr>';
            //    temp += '<td width="15%">Additional Permitted Use:</td>';
            //    temp += '<td width="85%">' + opp.Additional_Permitted_Use__c.replace('\n','<br>') + '</td>';
            //    temp += '</tr>';
            //}
            //String provisions = '';
            //if (opp.Autorenewal_Clause_Removed__c)
            //    provisions += 'The auto renewal provisions contained in the terms are hereby removed. ';
            //if (opp.Non_Standard_Terms__c != null)
            //    provisions += opp.Non_Standard_Terms__c;
            //if (provisions != '') {
            //    temp += '<tr>';
            //    temp += '<td>Supplementary Provisions:</td>';
            //    temp += '<td>' + provisions.replace('\n','<br>') + '</td>';
            //    temp += '</tr>';
            //}
            //if (opp.Addendum__c != null) {
            //    temp += '<tr>';
            //    temp += '<td>Addendum:</td>';
            //    temp += '<td>' + opp.Addendum__c.replace('\n','<br>') + '</td>';
            //    temp += '</tr>';
            //} 
            //if (opp.Governing_Law__c != null) {
            //    temp += '<tr>';
            //    temp += '<td>Governing Law:</td>';
            //    temp += '<td>Governing law and jurisdiction is amended to ' + opp.Governing_Law__c + '</td>';
            //    temp += '</tr>';
            //}           
            temp += '</table>';
            return temp;            
        }
    }
    
    public List<OppProduct> products {
        get {
            if (products == null) {
                Decimal total = 0;
                Decimal costTotal = 0;
                products = new List<OppProduct>();
                for (OpportunityLineItem oli:olis) {
                    OppProduct product = new OppProduct();
					OLISalesType = oli.IHC_Sales_Type__c;
                    //Product Column
                    product.productName = '<b>' + oli.PricebookEntry.ProductCode + ' - ' + oli.PricebookEntry.Product2.Name + '</b>';
                    if (oli.IHC_Sales_Type__c == 'Advertising Sales')
                        product.productname += ' - ' + oli.IHC_Product_Family__c + '</b>';
                    else
                        product.productname += '</b>';
                    product.productName += ' (' + oli.IHC_Sales_Type__c + ')';
                    if (oli.IHC_Sales_Type__c != 'Advertising Sales' & oli.Authorized_User_Notes__c != null)
                        product.productName += '<br/>' + oli.Authorized_User_Notes__c.replace('\n','<br/>');                        
                    
                    if (oli.IHC_Sales_Type__c == 'Commercial Reprints') {
                        //Product Details
                        product.productName += '<table>';
                        product.productName += '<tr><td width="10"></td><td style="min-width:100px">Deliver By: ' + (oli.Deliver_By__c == null ? '' : String.valueOf(oli.Deliver_By__c)) + '</td><td style="min-width:100px">Split Delivery: ' + (oli.Split_Delivery__c ? 'Yes' : 'No') + '</td><td style="min-width:100px">DOI: ' + (oli.Digital_Object_Identifier__c == null ? '' : oli.Digital_Object_Identifier__c) + '</td></tr>';
                        product.productName += '<tr><td></td><td>Colour: ' + (oli.Colour__c == null ? '' : oli.Colour__c) + '</td><td>Qty: ' + oli.Qty__c + '</td><td>Shrink Wrap: ' + (oli.Shrink_Wrap__c == null ? '' : oli.Shrink_Wrap__c) + '</td></tr>';
                        product.productName += '<tr><td></td><td colspan="3">Delivery Instructions: ' + (oli.Delivery_Instructions__c == null ? '' : oli.Delivery_Instructions__c.replace('\n','<br/>')) + '</td></tr>';
                        product.productName += '</table>';
                        //Product Costs
                        product.extraInfo = '<table>';
                        product.extraInfo += '<tr><td style="padding-left: 10px; min-width:100px">Sales Price: ' + oli.UnitPrice + '</td><td>Delivery Cost: ' + oli.Delivery_Cost__c + '</tr>';
                        product.extraInfo += '<tr><td style="padding-left: 10px">Split Billing: ' + (oli.Split_Billing__c ? 'Yes' : 'No') + '</td><td>Other Costs: ' + oli.Gross_Cost__c + '</td></tr>';
                        product.extraInfo += '<tr><td style="padding-left: 10px" colspan="3">Other Desc: ' + (oli.Other_Notes__c == null ? '' : oli.Other_Notes__c.replace('\n','<br/>')) + '</td></tr>';
                        product.extraInfo += '<tr><td style="padding-left: 10px" colspan="3">Billing Notes: ' + (oli.Billing_Notes__c == null ? '' : oli.Billing_Notes__c.replace('\n','<br/>')) + '</td></tr>';
                        product.extraInfo += '</table>';
                        
                    } else if (oli.IHC_Sales_Type__c == 'Commercial ePrints') {
                        //Product Details
                        product.productName += '<table>';
                        product.productName += '<tr><td width="10"></td><td style="min-width:100px">Deliver By: ' + (oli.Deliver_By__c == null ? '' : String.valueOf(oli.Deliver_By__c)) + '</td><td style="min-width:100px">Qty: ' + oli.Qty__c + '</td><td style="min-width:100px">DOI: ' + (oli.Digital_Object_Identifier__c == null ? '' : oli.Digital_Object_Identifier__c) + '</td></tr>';
                        product.productName += '<tr><td></td><td colspan="3">Shrink Wrap: ' + (oli.Shrink_Wrap__c == null ? '' : oli.Shrink_Wrap__c) + '</td></tr>';
                        product.productName += '</table>';
                        //Product Costs
                        product.extraInfo = '<table>';
                        product.extraInfo += '<tr><td style="padding-left: 10px; min-width:100px">Sales Price: ' + oli.UnitPrice + '</td><td>Delivery Cost: ' + oli.Delivery_Cost__c + '</tr>';
                        product.extraInfo += '<tr><td style="padding-left: 10px">Split Billing: ' + (oli.Split_Billing__c ? 'Yes' : 'No') + '</td><td>Other Costs: ' + oli.Gross_Cost__c + '</td></tr>';
                        product.extraInfo += '<tr><td style="padding-left: 10px" colspan="3">Other Desc: ' + (oli.Other_Notes__c == null ? '' : oli.Other_Notes__c.replace('\n','<br/>')) + '</td></tr>';
                        product.extraInfo += '</table>';

                    } else if (oli.IHC_Sales_Type__c == 'Commercial Permissions') {
                        //Product Details
                        product.productName += '<table>';
                        product.productName += '<tr><td width="10"></td><td style="min-width:100px">Qty: ' + oli.Qty__c + '</td><td colspan="2">DOI: ' + (oli.Digital_Object_Identifier__c == null ? '' : oli.Digital_Object_Identifier__c) + '</td></tr>';
                        product.productName += '</table>';
                        //Product Costs
                        product.extraInfo = '<table>';
                        product.extraInfo += '<tr><td style="padding-left: 10px; min-width:100px">Sales Price: ' + oli.UnitPrice + '</td><td>Split Billing: ' + (oli.Split_Billing__c ? 'Yes' : 'No') + '</tr>';
                        product.extraInfo += '<tr><td style="padding-left: 10px" colspan="3">Billing Notes: ' + (oli.Billing_Notes__c == null ? '' : oli.Billing_Notes__c.replace('\n','<br/>')) + '</td></tr>';
                        product.extraInfo += '</table>';

                    } else if (oli.IHC_Sales_Type__c == 'Sponsored Focus') {
                        //Product Details
                        product.productName += '<table>';
                        product.productName += '<tr><td width="10"></td><td style="min-width:100px">Start Date: ' + MiscFunctions.convertDateToString_MMM_d_yyyy(oli.Start_Date__c) + '</td><td style="min-width:100px">End Date: ' + MiscFunctions.convertDateToString_MMM_d_yyyy(oli.End_Date__c) + '</td></tr>';
                        product.productName += '<tr><td></td><td>Duration: ' + (oli.Duration_IHC__c == null ? '' : oli.Duration_IHC__c) + '</td><td>DOI: ' + (oli.Digital_Object_Identifier__c == null ? '' : oli.Digital_Object_Identifier__c) + '</td></tr>';
                        product.productName += '</table>';
                        //Product Costs
                        product.extraInfo = '<table>';
                        product.extraInfo += '<tr><td style="padding-left: 10px; min-width:100px">Sales Price: ' + oli.UnitPrice + '</td><td>Split Billing: ' + (oli.Split_Billing__c ? 'Yes' : 'No') + '</tr>';
                        product.extraInfo += '<tr><td style="padding-left: 10px" colspan="3">Billing Notes: ' + (oli.Billing_Notes__c == null ? '' : oli.Billing_Notes__c.replace('\n','<br/>')) + '</td></tr>';
                        product.extraInfo += '</table>';

                    } else if (oli.IHC_Sales_Type__c == 'Advertising Sales') {
                        //Product Details
                        product.productName += '<table>';
                        product.productName += '<tr><td width="10"></td><td style="min-width:100px">Size: ' + (oli.Size__c == null ? '' : oli.Size__c) + '</td><td colspan="2" style="min-width:100px">Position: ' + (oli.Position__c == null ? '' : oli.Position__c) + '</td></tr>';
                        product.productName += '<tr><td></td><td style="min-width:100px">Orientation: ' + (oli.Ad_Orientation__c == null ? '' : oli.Ad_Orientation__c) + '</td><td style="min-width:100px">Colour: ' + (oli.Colour__c == null ? '' : oli.Colour__c) + '</td><td style="min-width:100px">Number of Issues: ' + oli.Number_of_Issues__c + '</td></tr>';
                        product.productName += '<tr><td></td><td style="min-width:100px">Volume: ' + (oli.Volume__c == null ? '' : oli.Volume__c) + '</td><td colspan="2" style="min-width:100px">' + (oli.Issue__c == null ? '' : 'Issue: ' + oli.Issue__c) + '</td></tr>';
                        product.productName += '</table>';
                        //Product Costs
                        product.extraInfo = '<table>';
                        product.extraInfo += '<tr><td style="padding-left: 10px; min-width:100px">Rate Card: ' + (oli.Rate_Card_Price__c == null ? 0 : oli.Rate_Card_Price__c) + '</td><td>Series Discount: ' + (oli.Series_Discount__c == null ? 0 : oli.Series_Discount__c) + '</tr>';
                        product.extraInfo += '<tr><td style="padding-left: 10px; min-width:100px">Sales Price: ' + oli.UnitPrice + '</td><td>Split Billing: ' + (oli.Split_Billing__c ? 'Yes' : 'No') + '</tr>';
                        product.extraInfo += '<tr><td style="padding-left: 10px" colspan="3">Billing Notes: ' + (oli.Billing_Notes__c == null ? '' : oli.Billing_Notes__c.replace('\n','<br/>')) + '</td></tr>';
                        product.extraInfo += '</table>';

                    } else if (oli.IHC_Sales_Type__c == 'Commercial Supplements') {
                        //Product Details
                        product.productName += '<table>';
                        product.productName += '<tr><td width="10"></td><td style="min-width:100px">Deliver By: ' + (oli.Deliver_By__c == null ? '' : String.valueOf(oli.Deliver_By__c)) + '</td><td style="min-width:100px">Split Delivery: ' + (oli.Split_Delivery__c ? 'Yes' : 'No') + '</td><td style="min-width:100px">Fulfilled: ' + (oli.Fulfilled__c ? 'Yes' : 'No') + '</td></tr>';
                        product.productName += '<tr><td></td><td>Colour: ' + (oli.Colour__c == null ? '' : oli.Colour__c) + '</td><td>Qty: ' + oli.Qty__c + '</td><td>Shrink Wrap: ' + (oli.Shrink_Wrap__c == null ? '' : oli.Shrink_Wrap__c) + '</td></tr>';
                        product.productName += '<tr><td></td><td colspan="3">Delivery Instructions: ' + (oli.Delivery_Instructions__c == null ? '' : oli.Delivery_Instructions__c.replace('\n','<br/>')) + '</td></tr>';
                        product.productName += '</table>';
                        //Product Costs
                        product.extraInfo = '<table>';
                        product.extraInfo += '<tr><td style="padding-left: 10px; min-width:100px">Sales Price: ' + oli.UnitPrice + '</td><td>Delivery Cost: ' + oli.Delivery_Cost__c + '</tr>';
                        product.extraInfo += '<tr><td style="padding-left: 10px">Split Billing: ' + (oli.Split_Billing__c ? 'Yes' : 'No') + '</td><td>Other Costs: ' + oli.Gross_Cost__c + '</td></tr>';
                        product.extraInfo += '<tr><td style="padding-left: 10px" colspan="3">Other Desc: ' + (oli.Other_Notes__c == null ? '' : oli.Other_Notes__c.replace('\n','<br/>')) + '</td></tr>';
                        product.extraInfo += '<tr><td style="padding-left: 10px" colspan="3">Billing Notes: ' + (oli.Billing_Notes__c == null ? '' : oli.Billing_Notes__c.replace('\n','<br/>')) + '</td></tr>';
                        product.extraInfo += '</table>';
                    }
                    
                    //Costs
                    product.oliTotalPrice = oli.TotalPrice;
                    product.oliTotalCost = oli.Total_Cost_IHC__c;
                    
                    addProductToList(product);
                    total += (oli.TotalPrice == null ? 0 : oli.TotalPrice);
                    costTotal += (oli.Total_Cost_IHC__c == null ? 0 : oli.Total_Cost_IHC__c);
                }
                productTotal = MiscFunctions.formattedAmount(total);                
                productCostTotal = MiscFunctions.formattedAmount(costTotal);                
            }
            return products;
        }
        set;
    }
   
    private void addProductToList(OppProduct product) {
        Boolean found = false;
        //Group Products
        /*for (OppProduct existingProduct : products) {
            if (existingProduct.productCode == product.productCode && existingProduct.productName == product.productName && existingProduct.extraInfo == product.extraInfo) {
                existingProduct.oliTotalPrice += product.oliTotalPrice;
                found = true;
                break;
            }
        }
        */
        if (!found)
            products.add(product);
    }
    
    public class OppProduct {
        public String productCode {get;set;}
        public String productName {get;set;}
        public String salesType {get;set;}
        public String extraInfo {get;set;}
        public String authorizedUserNotes {get;set;}
        //public String startDate {get;set;}
        //public String endDate {get;set;}
        //public String totalPrice {get;set;}
        public Integer quantity {get;set;}
        public String totalPrice {get{return MiscFunctions.formattedAmount(oliTotalPrice);}set;}
        public String totalCost {get{return MiscFunctions.formattedAmount(oliTotalCost);}set;}
        public Decimal oliTotalPrice {get;set;}
        public Decimal oliTotalCost {get;set;}
    }
    
    public void testProducts() {
        //used so Test Method can test both "products" method and "OppProducts" class
        OppProduct test = new OppProduct();
        test.productCode = 'test';
        test.productName = 'test';
        test.salesType = 'test';
        test.extraInfo = 'test';
        test.authorizedUserNotes = 'test';
        test.quantity = 1;
        test.totalPrice = '0';
        test.totalCost = '0';
        
        String sTest = test.productCode;
        sTest = test.productName;
        sTest = test.salesType;
        sTest = test.extraInfo;
        sTest = test.authorizedUserNotes;
        Integer nTest = test.quantity;
        sTest = test.totalPrice;
        sTest = test.totalCost;
        
        List<OppProduct> testList = products;
    } 
}