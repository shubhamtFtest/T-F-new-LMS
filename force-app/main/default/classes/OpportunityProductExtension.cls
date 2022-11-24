/*
* For testing use OpportunityProductExtensionTest (last tested 21/06/21 by Kam Chandi @81%)
* Created By Bashir Qaasim - 2011.09.23
* Modified By Hailey Niemand - 04.06.2013 - CHG0050810: "Netbase Select" require same setting as Pick and Mix product
* Modified by Hailey Niemand 2013.08.09 - CHG0048108 - Rename T&F Opportunity Record Types
* Modified by Hailey Niemand - 2014.01.13 - CHG0055795: Display Subject Area
* Modified by Hailey Niemand - 2015.07.28 - CHG0067203: Revised Product Structure to Include Category
* Modified by Hailey Niemand - 2015.11.05 - CHG0069531: New Article Pass Field
* Modified by Piyush Jain -2017.7.17 -CHG0035801 for sorting the record based on Invoice Date
* Modified by Rishabh Singh - 2017.08.24 - CHG0036420
* Modified by Tom Reed - 2018.02.26 - Updated old org ids to new
* Modified by Tom Reed - 2018.03.09 - Updated new field expiry date
* Modified by Amit Kumar - 2018.07.17 - CHG0043878: Invoice System (SAP,PT,Quickfill), invoice number validation rule
* Modified by Matthew Smith - 2021.04.06 - Updating query on line 63 to pull in Category
* Modified by Kam Chandi - 2021.06.18 - Updated query on line 63 to pull in Agent's Name
* Modified by Matthew Smith - 2021.10.25 - Supporting the new F1000 Pricebook with the new F1000 Opportunity record types.
*/

public with sharing class OpportunityProductExtension {
    public String sortDirection = 'DESC'; //CHG0035801
    public String sortExp = 'Invoice_Date__c';//CHG0035801
    private ApexPages.StandardController controller;                                  
    
    //CHG0045928
    public Boolean isBooks {get; set;}
    //T&F Record Types renamed per CHG0048108
    private set<Id> EBOOK_RECORDTYPES = new Set<Id>{'0120Y000000Wn8YQAS' //T&F eBooks Customer Opportunity (Direct)
                                                   ,'0120Y000000Wn9YQAS' //T&F eBooks Consortium Opportunity (Direct)
                                                   ,'0120Y000000Wn9ZQAS' //T&F eBooks Consortium Opportunity (Price Agreement)
                                                   };
    
    public String oppCurrency { get; set; }
    
    public Boolean hasPickAndMixProduct {get; set;} //CHG0048678
    public Boolean hasFeesProduct {get; set;} //CHG0048678
    public Boolean hasTokenProduct {get; set;} //CHG0048678
    public Boolean hasCategoryProduct {get; set;} //CHG0067203
    public Boolean isArticlePassProd{get;set;}//CHG0036420
   
    
    public OpportunityProductExtension(ApexPages.StandardController controller) {
        this.controller = controller;
        
        //CHG0045928
        List<Opportunity> opps  = [Select RecordTypeId, CurrencyIsoCode From Opportunity Where Id =:controller.getRecord().Id];
        if (opps.size() > 0) {
            oppCurrency = opps[0].CurrencyIsoCode;
            if (EBOOK_RECORDTYPES.contains(opps[0].RecordTypeId))
                isBooks = true;
            else 
                isBooks = false;
        } else {
            isBooks = false;
        }
    }    
    
    OpportunityLineItem[] OpplList;
    
    public void getAllOppls() {
       
        OpplList = new OpportunityLineItem[]{};
        productWrapperList = new List<ProductWrapper>();
        // Make the dynamic query so that short the record based on invoice Date CHG0035801
        String scontrollerId = controller.getId();
        String sortFullExp = sortExpression  + ' ' + sortDirection;
        String querystring = 'SELECT Id, ProductName__c,Quantity, ServiceDate, Description, ListPrice, UnitPrice,OpportunityId, PricebookEntryId, TotalPrice, TotalPrice_EUR__c, TotalPrice_GBP__c,TotalPrice_USD__c, TotalPrice_AUD__c,eBook_Order_Type__c, Seats_Users__c,Agent_s_Name__c, Invoice_Number__c, Invoice_Date__c, Net_Price__c,PricebookEntry.Product2.Service_Description__c,PricebookEntry.Product2.Name,Subject_Area__c, PricebookEntry.Product2Id,Token_Quantity__c,Budget_Availability__c,Article_Pass__c,Expiry_date__C,Invoice_System__c, Category__c From OpportunityLineItem ';
        querystring = querystring + ' where opportunityId=:scontrollerId';
        querystring = querystring + ' order by ' + sortFullExp;
        OpplList =  Database.query(queryString);
        
        TFSettings__c setting = TFSettings__c.getInstance(); //CHG0055795
        String sArticlePassProduct;//CHG0036420
        //CHG0048678
        for (OpportunityLineItem oli : OpplList) {
            if (oli.PriceBookEntry.Product2Id == '01t0Y0000080nlpQAA' || oli.PriceBookEntry.Product2Id == '01t0Y0000072JCPQA2') //only for Pick & Mix, per CHG0048678. CHG0050810 - include Netbase Select Product
                hasPickAndMixProduct = true;
            if (oli.PricebookEntry.Product2.Service_Description__c != 'Subscription')
                hasFeesProduct = true;
            /*if (oli.ProductName__c == 'Article Pass – 100 Tokens' || oli.ProductName__c == 'Article Pass – 250 Tokens' || oli.ProductName__c == 'Article Pass – 500 Tokens' || oli.ProductName__c == 'Article Pass – 750 Tokens' || oli.ProductName__c == 'Article Pass – 1000 Tokens' || oli.ProductName__c == 'Article Pass – 1500 Tokens' || oli.ProductName__c == 'Article Pass – Open Number')
                hasTokenProduct = true;*/ //CHG0055795
            
            ProductWrapper pw = new ProductWrapper();
            pw.oli = oli;
            if(oli.ProductName__c !=null){
                sArticlePassProduct = oli.ProductName__c;//CHG0036420
            }    
             if(String.isNotBlank(sArticlePassProduct) && sArticlePassProduct.startsWith('Article Pass')){  
                pw.hasArticlePassProduct = true;//CHG0036420 
                isArticlePassProd = true;//CHG0036420
            }
            if (setting.TokenProducts__c.contains(oli.ProductName__c)) {
                hasTokenProduct = true;
                pw.isToken = true;
            }
            //CHG0067203
            if (setting.CategoryProducts__c.contains(oli.ProductName__c)) {
                hasCategoryProduct = true;
                pw.isCategory = true;
            }
            productWrapperList.add(pw);
        }      
        
    }
        
              
    String s;
    public String getListOppls() {
        return s;
    }
    public void setListOppls(String s) {
        this.s = s;
    }
        
    String ActivityType = null;
    public PageReference test() {
        return null;
    }
    
    public PageReference AddProducts() {
        //Default Pricebook - Jeff Lup - 2011.12.14 - CHG0039592
        //Opportunity opp  = [Select Id, Pricebook2Id From Opportunity Where Id =:controller.getRecord().Id];
        List<Opportunity> opps  = [Select Id, Pricebook2Id, recordtypeid From Opportunity Where Id =:controller.getRecord().Id];
        if (opps.size() > 0) {
            if (opps[0].Pricebook2Id == null) {//RQ 27.06.2012 - rows 38-41 amended to set default pricebook according to opportunity record types
                if(opps[0].recordtypeid == '0120Y000000Wn9WQAS'||opps[0].recordtypeid == '0120Y000000Wn8TQAS'||opps[0].recordtypeid == '0120Y000000Wn9VQAS') {
                //opps[0].Pricebook2Id = '01s60000000680d'; //T&F Pricebook //2012.01.06 - Jeff Lup - per Andrew Ciccone
                opps[0].Pricebook2Id = '01s0Y00000832cyQAA';} //T&F Journals Price Book //2012.01.06 - Jeff Lup - per Andrew Ciccone
                else if(opps[0].recordtypeid == '0127R000000m3qdQAA'|| opps[0].recordtypeid == '0127R000000m3qeQAA'|| opps[0].recordtypeid == '0127R000000m4I9QAI'){ //F10000 record types
                   opps[0].Pricebook2Id = '01s7R00000224UiQAI';} //F1000 Pricebook
                else {opps[0].Pricebook2Id = '01s0Y00000832cjQAA';}//T&F eBooks Price Book//2012.07.05 - Roger Quinn - CHG0043425
                update opps[0];
                }
        }
        //Add Products
        controller.save();
        PageReference pageRef = new PageReference(Page.Opportunityproductentry.getURL() );
        pageRef.getParameters().put('id',controller.getid());
        pageRef.setRedirect(true);
        return pageRef;
     }
     
    public void RemoveProducts() {
    
    Opportunity thisOpp  = [Select Id, StageName From Opportunity Where Id =:controller.getRecord().Id];
    
    list<Opportunity> opp = [Select Id from Opportunity Where Parent_Opportunty__c =:thisOpp.Id];
    
    try{
        delete opp;
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Child Opportunities has been removed'));
    }
    catch(exception e){
        system.debug(e);
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'There was an error please contact your Administrator'));
    }
     }
     
    /************* Wrapper class **************/
    public class ProductWrapper {
        public boolean isToken {get; set;}
        public boolean isCategory {get; set;} //CHG0067203
        public OpportunityLineItem oli {get; set;}
        public Boolean hasArticlePassProduct{get;set;}//CHG0036420
    }
    public List<ProductWrapper> productWrapperList {
        get {
            if (productWrapperList == null) {
                productWrapperList = new List<ProductWrapper>();
                getAllOppls();
            }
            return productWrapperList;
        }
        set;
    }
      
      //use to short record on page CHG0035801
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
    
     //use to change the direction symbol CHG0035801
    public String getSortDirection(){
        //if not column is selected 
        if (sortExpression == null || sortExpression == '')
          return 'DESC';
        else
         return sortDirection;
    }
    }