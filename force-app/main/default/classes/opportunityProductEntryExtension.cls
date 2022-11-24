/*
* For testing use opportunityProductEntryTests (last tested 21/06/21 by Kam Chandi @84%)
* Modified By Hailey Niemand - 17.06.2013 - CHG0050810: "Netbase Select" require same setting as Pick and Mix product
* Modified by Hailey Niemand 2013.08.09 - CHG0048108 - Rename T&F Opportunity Record Types
* Modified by Hailey Niemand - 2014.01.13 - CHG0055795: Display Subject Area
* Modified by Hailey Niemand - 2014.09.15 - CHG0061380: Increase limit of products displayed to 1000
* Modified by Jeff Lup - 2014.11.11 - eBooks Renewal Project: filter search results by Opp.Product_Family__c
* Modified by Hailey Niemand - 2015.07.28 - CHG0067203: Revised Product Structure to Include Category
* Modified by Hailey Niemand - 2015.11.05 - CHG0069531: New Article Pass Field
* Modified by Jeff Lup - 2016.03.11 - CHG0071993
* Modified by Rishabh Singh - 2017.08.24 - CHG0036420
* Modified by Rishabh Singh - 2017.09.11 - CHG0036420
* Modified by Chetan Bhatla -09/03/2018-CHG0042234-updated new field Expiry date
* Modified by Amit Kumar - 2018.07.17 - CHG0043878: Invoice System (SAP,PT,Quickfill), invoice number validation rule
* Modified by Kam Chandi - 2021.06.18 - Updated SOQL to pull in Agent's Name
*/

public class opportunityProductEntryExtension {
    /* start CHG0043363 */
    public OpportunityLineItem invoiceSystem {get;set;}
    public List<SelectOption> statusOptions {get;set;}
    public string isSelectedValue { get;set; }
    /* end CHG0043363 */ 
    
    public Opportunity theOpp {get;set;}
    public String searchString {get;set;}
    //public opportunityLineItem[] shoppingCart {get;set;} //replaced with shoppingCart Class - CHG0045928
    public priceBookEntry[] AvailableProducts {get;set;}
    public Pricebook2 theBook {get;set;}   
    
    public String toSelect {get; set;}
    public String toUnselect {get; set;}
    public Decimal Total {get;set;}
    
    public Boolean overLimit {get;set;}
    public Boolean multipleCurrencies {get; set;}
    
    private Boolean forcePricebookSelection = false;

    
    private TFSettings__c setting;
    
    private opportunityLineItem[] forDeletion = new opportunityLineItem[]{};
    
    //CHG0067203
    public map<Id, Set<String>> mapProductToCategories = new map<Id, Set<String>>();
    public map<String, String> mapProductToName = new map<String, String>();
    public map<String, String> mapProductToCode = new map<String, String>();
    
    
    public list<Opportunity> oppinsert = new list<Opportunity>();
    list<TandF_Account_to_Consortium__c> accs2consorts;
    list<Account_To_Opportunity__c> a2os;
    list<Opportunity> someOpp;
    public Opportunity opp;
    Account a;
    Recordtype rec;
    
    //CHG0045928
    public Boolean isBooks {get; set;}
    //T&F Record Types renamed per CHG0048108
    private set<Id> EBOOK_RECORDTYPES = new Set<Id>{'0120Y000000Wn8YQAS' //T&F eBooks Customer Opportunity (Direct)
                                                   ,'0120Y000000Wn9YQAS' //T&F eBooks Consortium Opportunity (Direct) 
                                                   ,'0120Y000000Wn9ZQAS' //T&F eBooks Consortium Opportunity (Price Agreement)
                                                   };
    
    public String masterOptyId; 
    
    
    //CHG0048678
    public Boolean hasPickAndMixProduct {get; set;}
    public Boolean hasFeesProduct {get; set;}
    public Boolean hasTokenProduct {get; set;}
    public Boolean hasCategoryProduct {get; set;} //CHG0067203 
    public Boolean isThisArticlePass{get;set;}//CHG0036420
    
    
   
    
    private void resetColumnVisibility() {
        hasPickAndMixProduct = false;
        hasFeesProduct = false;
        hasTokenProduct = false;
        isThisArticlePass=false;
        String sArticlepassProduct;// CHG0036420
        for (Cart c : shoppingCart) {
             sArticlepassProduct = c.oli.PricebookEntry.Product2.name;
             if (c.oli.PriceBookEntry.Product2Id == '01t0Y0000080nlp' || c.oli.PriceBookEntry.Product2Id == '01t0Y0000072JCP') //only for Pick & Mix, per CHG0048678. CHG0050810 - include Netbase Select Product
                hasPickAndMixProduct = true;
             
            if (c.oli.PricebookEntry.Product2.Service_Description__c != 'Subscription')
                hasFeesProduct = true;
            String n = c.oli.PricebookEntry.Product2.Name;
            //if (n == 'Article Pass – 100 Tokens' || n == 'Article Pass – 250 Tokens' || n == 'Article Pass – 500 Tokens' || n == 'Article Pass – 750 Tokens' || n == 'Article Pass – 1000 Tokens' || n == 'Article Pass – 1500 Tokens' || n == 'Article Pass – Open Number')
            if (setting.TokenProducts__c.contains(n))
                hasTokenProduct = true;
            if (setting.CategoryProducts__c.contains(n))
                hasCategoryProduct = true; 
            if(String.isNotBlank(sArticlepassProduct) && sArticlepassProduct.startsWith('Article Pass')){
                isThisArticlePass=true;
            }
            
                        
        }
    }
    
    
    public opportunityProductEntryExtension(ApexPages.StandardController controller) {
        
        shoppingCart = new List<cart>();
       
        // Need to know if org has multiple currencies enabled
        multipleCurrencies = UserInfo.isMultiCurrencyOrganization();
       
        // Get information about the Opportunity being worked on
        if(multipleCurrencies)
            //theOpp = database.query('select Id, Deal_Type__c, Account.name, Pricebook2Id, Pricebook2.Name, CurrencyIsoCode from Opportunity where Id = \'' + controller.getRecord().Id + '\' limit 1'); //Jeff Lup - 2014.11.11 - eBooks Renewal Project
            theOpp = database.query('select Id, Product_Family__c, Deal_Type__c, Account.name, Pricebook2Id, Pricebook2.Name, CurrencyIsoCode from Opportunity where Id = \'' + controller.getRecord().Id + '\' limit 1');
        else
            //theOpp = [select Id, Deal_Type__c, Account.name,  Account.Id, Pricebook2Id, PriceBook2.Name from Opportunity where Id = :controller.getRecord().Id limit 1]; //Jeff Lup - 2014.11.11 - eBooks Renewal Project
            theOpp = [select Id, Product_Family__c, Deal_Type__c, Account.name,  Account.Id, Pricebook2Id, PriceBook2.Name from Opportunity where Id = :controller.getRecord().Id limit 1];
            
        opp = [Select Id, Name, Account.Id, Account.name, Type,  Pricebook2Id, 
        LeadSource, CurrencyIsoCode, StageName, Amount, CloseDate, RecordTypeId,
        NextStep, Reason_Lost__c, Volume_Year__c, Invoice_Status__c, Core_Subs_Amount__c,
        Deal_Type__c, Number_of_members__c, Auto_Renew__c, Renewal_Date__c, 
        Maintenance_Fee__c, //Renewal_Cycle__c,
        Previous_Renewal__c, 
        //Amount_AUD__c, Amount_GBP__c, Amount_USD__c, Amount_EUR__c, removed because of CHG0045776, roll ups used now
        Solutions_Area_Interest__c, Business_Issues__c,
        Trial_Start__c, Expected_Cash_Received_Date__c,
        Date_Deal_Invoiced__c, Trial_End__c, Actual_Cash_Received_Date__c,
        Description, Legacy_ID__c, System_ID__c,
        start_date__c,end_date__c//These 3 added RQ 26.06.2012

        From Opportunity where Id = :controller.getRecord().Id Limit 1];
        
        a = [Select Id From Account Where id=:opp.Account.Id Limit 1];
        // Removed by Michael Brookes. Workflow is completing the record type change.//RQ 2012.07.06 - where record types need to be changed from the defaults this is done by workflows - 01Q60000000JXnL, 01Q60000000JXnN, 01Q60000000JXnO and eBooks equivalents 
        //rec = [Select Name, Id From RecordType where sObjectType='Opportunity' AND
        //Name IN ('T&F Journals Consortium Opportunity (Direct)', 'T&F Journals Consortium Opportunity (Price Agreement)' ) Limit 1];
        //above row amended to include ebooks record type by RQ 2012.06.26
        // Initialize
        a2os = new list<Account_To_Opportunity__c>();
        masterOptyId = controller.getRecord().Id;
        
        // If products were previously selected need to put them in the "selected products" section to start with
        List<OpportunityLineItem> olis = [SELECT Id,ProductName__c,Article_Pass__c , Unique__c, Quantity, TotalPrice, UnitPrice, Description,
                                            PriceBookEntryId, PriceBookEntry.Name, PriceBookEntry.IsActive,
                                            PriceBookEntry.Product2Id, PriceBookEntry.Product2.Name, PriceBookEntry.Product2.ProductCode,
                                            PriceBookEntry.PriceBook2Id, AccountName__c,
                                            Seats_Users__c, Agent_s_Name__c, ServiceDate, eBook_Order_Type__c,
                                            Invoice_Number__c, Invoice_Date__c, Net_Price__c, //CHG0047104
                                            PricebookEntry.Product2.Service_Description__c, //CHG0048320
                                            Subject_Area__c, //CHG0049016
                                            Category__c, Product_Name__c, Product_Code__c, //CHG0067203
                                            Token_Quantity__c, //CHG0069531
                                            Budget_Availability__c, // CHG0073710
                                            Invoice_System__c, //CHG0043363
                                            Expiry_date__c //CHG0042234
                                          FROM opportunityLineItem
                                          WHERE OpportunityId = :theOpp.Id
                                          ORDER BY Id];
        
        setting = TFSettings__c.getInstance(); //CHG0055795
        String sCheckArticlePassProd;// CHG0036420
        for (OpportunityLineItem oli : olis) {
            cartId++;
            Cart cart = new Cart();
            cart.oli = oli;
            cart.cartId = cartId;
            /* Start CHG0036420 */
            if(String.isNotBlank(oli.PriceBookEntry.Product2.Name)){
                sCheckArticlePassProd = oli.PriceBookEntry.Product2.Name;
            }
            if(String.isNotBlank(sCheckArticlePassProd) && sCheckArticlePassProd.startsWith('Article Pass')){     
                cart.hasArticlePassProduct = true;//CHG0036420
            }
            /* End CHG0036420 */
            
            if (setting.TokenProducts__c.contains(oli.PriceBookEntry.Product2.Name))
                cart.isToken = true; //CHG0055795
            if (setting.CategoryProducts__c.contains(oli.PriceBookEntry.Product2.Name)) //CHG0067203
                cart.isCategory = true; 
            cart.mapProductToCategories = mapProductToCategories;
            cart.mapProductToName = mapProductToName;
            cart.mapProductToCode = mapProductToCode;
            shoppingCart.add(cart);
        }
        
        // Check if Opp has a pricebook associated yet
        
        if(theOpp.Pricebook2Id == null){
            Pricebook2[] activepbs = [select Id, Name from Pricebook2 where isActive = true limit 2];
            if(activepbs.size() == 2){
                forcePricebookSelection = true;
                theBook = new Pricebook2();
            }
            else{
                theBook = activepbs[0];
            }
        }
        else {
            theBook = theOpp.Pricebook2;
        }
        /* //CHG0067203
        system.debug('hn Pricebook: ' + theOpp.Pricebook2Id);
        if(theOpp.Pricebook2Id == null && !EBOOK_RECORDTYPES.contains(opp.RecordTypeId))
            theBook = [select Id, Name from Pricebook2 where Id ='01s6000000063zlAAA']; //T&F Journals Pricebook
        if(theOpp.Pricebook2Id == null && EBOOK_RECORDTYPES.contains(opp.RecordTypeId))
            theBook = [select Id, Name from Pricebook2 where Id ='01s600000006DDMAA2']; //T&F eBooks Pricebook
        else 
            theBook = theOpp.Pricebook2;
        system.debug('hn The Book: ' + theBook);
        */
        
        //CHG0045928
        if (EBOOK_RECORDTYPES.contains(opp.RecordTypeId))
            isBooks = true;
        else 
            isBooks = false;

        if(!forcePricebookSelection)
            updateAvailableList();
            
        resetColumnVisibility();
        
        //CHG0067203
        List<Setting_Item__c> settingItems= [SELECT Text_1__c, Product_1__c, Text_2__c, Text_3__c
                                   FROM Setting_Item__c 
                                   WHERE Setting__r.Name = 'TF Product Categories'];
        for (Setting_Item__c settingItem: settingItems) {
            Set<String> setCategories = new Set<String>();
            if (mapProductToCategories.containsKey(settingItem.Product_1__c))
                setCategories = mapProductToCategories.get(settingItem.Product_1__c);
            setCategories.add(settingItem.Text_1__c);
            mapProductToCategories.put(settingItem.Product_1__c, setCategories);
            mapProductToName.put(settingItem.Product_1__c + ':' + settingItem.Text_1__c, settingItem.Text_2__c);
            mapProductToCode.put(settingItem.Product_1__c + ':' + settingItem.Text_1__c, settingItem.Text_3__c);
        }
        //Amit
        Schema.DescribeFieldResult statusFieldDescription = opportunityLineItem.Invoice_System__c.getDescribe();
        invoiceSystem = new OpportunityLineItem();        
        statusOptions = new List<SelectOption>();
        
        statusOptions.add(new selectOption('', '- None -'));
        for (Schema.Picklistentry picklistEntry:statusFieldDescription.getPicklistValues()){
            statusOptions.add(new SelectOption( pickListEntry.getValue(),pickListEntry.getLabel()));       
            if (picklistEntry.defaultValue){
                invoiceSystem.Invoice_System__c = pickListEntry.getValue();
            }  
            //system.debug('isdefault->'+picklistEntry.isDefaultValue());
            if (picklistEntry.isDefaultValue()) {
                //defaultValue = 'SAP';
                invoiceSystem.Invoice_System__c = 'SAP';
            }
            if (isBooks) {
                isSelectedValue = 'SAP';
            }            
        }         
    }
    
    // this is the 'action' method on the page
    public PageReference priceBookCheck(){
    
        // if the user needs to select a pricebook before we proceed we send them to standard pricebook selection screen
        if(forcePricebookSelection){        
            return changePricebook();
        }
        else{
        
            //if there is only one active pricebook we go with it and save the opp
            if(theOpp.pricebook2Id != theBook.Id){
                try{
                    theOpp.Pricebook2Id = theBook.Id;
                    update(theOpp);
                }
                catch(Exception e){
                    ApexPages.addMessages(e);
                }
            }
            
            return null;
        }
    }
       
    public String getChosenCurrency(){
    
        if(multipleCurrencies)
            return (String)theOpp.get('CurrencyIsoCode');
        else
            return '';
    }

    public void updateAvailableList() {
    
        // We dynamically build a query string and exclude items already in the shopping cart
        //String qString = 'select Id, Pricebook2Id, IsActive, Product2.Name, Product2.Family, Product2.IsActive, Product2.Description, UnitPrice from PricebookEntry where IsActive=true and Pricebook2Id = \'' + theBook.Id + '\'';
        //String qString = 'select Id, PricebookEntry.Product2.Service_Description__c, Pricebook2Id, IsActive, Product2.Name, Product2.ProductCode, Product2.Family, Product2.IsActive, Product2.Description, UnitPrice from PricebookEntry where IsActive=true and Pricebook2Id = \'' + theBook.Id + '\''; //CHG0048320
        String qString = 'select Id, PricebookEntry.Product2.Service_Description__c, Pricebook2Id, IsActive, Product2.Name, Product2.ProductCode, Product2.Family, Product2.IsActive, Product2.Description, UnitPrice from PricebookEntry where IsActive=true and Pricebook2.IsActive=true and Product2.IsActive=true and Pricebook2Id = \'' + theBook.Id + '\''; //CHG0071993
        if (multipleCurrencies)
            qstring += ' and CurrencyIsoCode = \'' + theOpp.get('currencyIsoCode') + '\'';
        
        if (isBooks) //Jeff Lup - 2014.11.11 - eBooks Renewal Project
            qstring += ' and Product2.Family = \'' + theOpp.get('Product_Family__c') + '\'';
        
        // note that we are looking for the search string entered by the user in the name OR description
        // modify this to search other fields if desired
        if(searchString!=null){
            qString+= ' and (Product2.Name like \'%' + searchString + '%\' or Product2.Description like \'%' + searchString + '%\')';
        }
        
        /*per comment from Andrew in CHG0045928, Journals recordtypes should also be allowed to add the same product more than once
        if (!isBooks) { //CHG0045928
            Set<Id> selectedEntries = new Set<Id>();
            for (Cart cart : shoppingCart) {
                selectedEntries.add(cart.oli.PricebookEntryId);
            }
            
            if (selectedEntries.size() > 0) {
                String tempFilter = ' and Id not in (';
                for(Id i : selectedEntries){
                    tempFilter+= '\'' + (String)i + '\',';
                }
                String extraFilter = tempFilter.substring(0,tempFilter.length()-1);
                extraFilter+= ')';
                
                qString+= extraFilter;
            }
        }
        */
        
        //qString+= ' order by Product2.Name';
        qString+= ' order by Product2.Product_Group__c DESC, Product2.Name ASC'; //CHG0043287 - Jeff Lup - 2012.07.25
        qString+= ' limit 351';
        
        system.debug('qString:' +qString);        
        AvailableProducts = database.query(qString);
        
        // We only display up to 350 results... if there are more than we let the user know (see vf page)
        if(AvailableProducts.size()==351){ //limit increased to 1350 CHG0061380
            AvailableProducts.remove(350);
            overLimit = true;
        }
        else{
            overLimit=false;
        }
    }
    
    public void addToShoppingCart(){
    
       if (theOpp.Deal_Type__c == 'Price Agreement'){    
            // Query only the selected child opportunities
            try{
                a2os = [SELECT id, Account__c, Opportunity__c, Opportunity__r.name, Account__r.name    
                          FROM Account_To_Opportunity__c 
                          WHERE Opportunity__c=:masterOptyId ORDER BY Name];
            }
            catch(exception e){
                system.debug(e);
            }                                                                                                   
        }
        system.debug('***a2os: ' + a2os);
                                                                                                                                                     
        Set<String> accSet = new Set<String>(); 
        Set<String> someAcc = new Set<String>();     
                                                                                              
        if(a2os.size() > 0){
            for(Account_To_Opportunity__c a2c: a2os){             
                Opportunity o = new Opportunity(
                Accountid = a2c.Account__c, 
                Name = opp.name + '-' + a2c.Account__r.name,
                Type = opp.Type,
                LeadSource = opp.leadsource,        
                CurrencyIsoCode = opp.CurrencyIsoCode,
                StageName = opp.StageName,
                Amount = opp.Amount,
                CloseDate = opp.CloseDate,
                Parent_Opportunty__c = opp.Id,
                //RecordTypeId = rec.id,
                Pricebook2Id = opp.Pricebook2Id,
                NextStep = opp.NextStep, 
                Reason_Lost__c = opp.Reason_Lost__c, 
                Volume_Year__c = opp.Volume_Year__c, 
                Invoice_Status__c = opp.Invoice_Status__c, 
                //Subs_Amount_USD__c = opp.Subs_Amount_USD__c, removed due to CHG0045638, workflow now used.
                Auto_Renew__c = opp.Auto_Renew__c, 
                Renewal_Date__c = opp.Renewal_Date__c, 
                Maintenance_Fee__c = opp.Maintenance_Fee__c, 
                //Renewal_Cycle__c = opp.Renewal_Cycle__c, 
                Previous_Renewal__c = opp.Previous_Renewal__c, 
                //Amount_GBP__c = opp.Amount_GBP__c, 
                //Amount_USD__c = opp.Amount_USD__c, 
                //Amount_EUR__c = opp.Amount_EUR__c,
                //Amount_AUD__c = opp.Amount_AUD__c,//RQ 26.06.2012
                Solutions_Area_Interest__c = opp.Solutions_Area_Interest__c, 
                Business_Issues__c = opp.Business_Issues__c, 
                Trial_Start__c = opp.Trial_Start__c, 
                Expected_Cash_Received_Date__c = opp.Expected_Cash_Received_Date__c,
                Date_Deal_Invoiced__c = opp.Date_Deal_Invoiced__c, 
                Trial_End__c = opp.Trial_End__c, 
                Actual_Cash_Received_Date__c = opp.Actual_Cash_Received_Date__c, 
                Description = opp.Description, 
                Legacy_ID__c = opp.Legacy_ID__c, 
                System_ID__c = opp.System_ID__c,
                start_date__c = opp.start_date__c,//RQ 26.06.2012
                end_date__c = opp.end_date__c,//RQ 26.06.2012
                Checkopp__c = true             
                );
                system.debug('***o: ' + o);
                oppinsert.add(o);
                accSet.add(a2c.Account__c);   
            }
        }
        system.debug('***oppinsert: ' + oppinsert);
        system.debug('***accSet: ' + accSet);
    
        if (theOpp.Deal_Type__c == 'Price Agreement'){
            someOpp = [select Id, Account.name, Deal_Type__c from Opportunity where Parent_Opportunty__c =:theOpp.id AND AccountId IN:accSet];
            system.debug('***someOpp1: ' + someOpp);
/*MH 14/03/2012 Why is the accSet being initialised here?
            accSet = new Set<String>();
*/
            for (Opportunity opp:someOpp) {
                someAcc.add(opp.AccountId);
            }
            system.debug('***someAcc: ' + someAcc);
        }

        try{
            if (oppinsert.size() != someOpp.size()){
                List<Opportunity> tempOptys = new List<Opportunity>();
                for (Opportunity opp:oppinsert) {
                    if (!someAcc.contains(opp.AccountId))
                        tempOptys.add(opp);
                }
                system.debug('***tempOptys: ' + tempOptys); 
                insert tempOptys;
                
                someOpp = [select Id, Account.name, Deal_Type__c from Opportunity where Parent_Opportunty__c =:theOpp.id AND AccountId IN:accSet];
                system.debug('***someOpp2: ' + someOpp); 
            }
        }
        catch(exception e){
            system.debug(e);
        }
    
        if(theOpp.Deal_Type__c == 'Price Agreement' && someOpp.isempty()){
            system.debug('SomeOpp Size:' +someOpp.size());
            try{
                insert oppinsert;
            }
            catch(exception e){
                system.debug('***Error message:' + e);
            }
            someOpp = [select Id, Deal_Type__c, Account.name from Opportunity where Parent_Opportunty__c =:theOpp.id AND AccountId IN:accSet];
            system.debug('***someOpp3: ' + someOpp); 
        }
        
        // This function runs when a user hits "select" button next to a product
        if(theOpp.Deal_Type__c == 'Direct Deal' || theOpp.Deal_Type__c == null || theOpp.Deal_Type__c == ''){
            someOpp =[select Id, Deal_Type__c, Account.name, Account.Id, Pricebook2Id, PriceBook2.Name from Opportunity where Id = :theopp.Id limit 1];
        }
        String sArticleProduct;// CHG0036420
        if (someOpp.size() > 0 && AvailableProducts.size() > 0){
            for(Opportunity o : someOpp){   
                for(PricebookEntry d : AvailableProducts){
                    if((String)d.Id==toSelect){
                        cartId++;
                        //OpportunityLineItem oli = new OpportunityLineItem(OpportunityId=o.Id, PriceBookEntry=d, PriceBookEntryId=d.Id, UnitPrice=d.UnitPrice, AccountName__c=o.Account.name);
                        String InvoiceSystemVal;                        
                        if(isBooks==true){
                           InvoiceSystemVal = 'SAP'; 
                        }else{
                          InvoiceSystemVal = '';
                        }                        
                        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId=o.Id, PriceBookEntry=d, PriceBookEntryId=d.Id, UnitPrice=d.UnitPrice, AccountName__c=o.Account.name,Invoice_System__c = InvoiceSystemVal);
                        
                        
                        Cart cart = new Cart();
                        cart.oli = oli;
                        cart.cartId = cartId;   
                        /* Start CHG0036420 */
                        if(d.Product2.Name !=null){
                            sArticleProduct= d.Product2.Name;
                        }  
                        if(String.isNotBlank(sArticleProduct) && sArticleProduct.startsWith('Article Pass')){     
                            cart.hasArticlePassProduct = true;//CHG0036420
                        }
                        else{
                              cart.hasArticlePassProduct = false;
                        }
                        /* End CHG0036420 */
                        if (setting.TokenProducts__c.contains(d.Product2.Name))
                            cart.isToken = true; //CHG0055795
                        if (setting.CategoryProducts__c.contains(d.Product2.Name)) //CHG0067203
                            cart.isCategory = true;
                        cart.mapProductToCategories = mapProductToCategories;
                        cart.mapProductToName = mapProductToName;
                        cart.mapProductToCode = mapProductToCode;
                        shoppingCart.add(cart);
                        //shoppingCart.add(new opportunityLineItem(Unique__c= o.Id + '' + d + '' + uniqueSuffix, OpportunityId=o.Id, PriceBookEntry=d, PriceBookEntryId=d.Id, UnitPrice=d.UnitPrice, AccountName__c=o.Account.name));
                        break;
                    }
                }
            } 
        }
        system.debug('***shoppingCart: ' + shoppingCart); 
        
        updateAvailableList();
        resetColumnVisibility();
    }
    

    public PageReference removeFromShoppingCart(){
        // This function runs when a user hits "remove" on an item in the "Selected Products" section
        Integer count = 0;
        for (Cart cart : shoppingCart) {
            if(String.valueOf(cart.cartId) == toUnselect) {
                if(cart.oli.Id != null)
                    forDeletion.add(cart.oli);
                shoppingCart.remove(count);
                break;
            }
            count++;
        }
        updateAvailableList();
        resetColumnVisibility();
        return null;
    }
    
    public PageReference onSave(){
        
        list<Opportunity> myopplist = new list<opportunity>();
        
        Opportunity thisOpp  = [Select Id, StageName, Subs_Amount_USD__c, Subs_Amount_GBP__c From Opportunity Where Id =:theopp.Id];
        list<Opportunity> myopp = [Select Id from Opportunity Where Parent_Opportunty__c =:thisOpp.Id And Checkopp__c = true];
        
        if(myopp.isEmpty()){
            for(Opportunity myoppcheck: myopp){
                myoppcheck.Checkopp__c = false;
                myopplist.add(myoppcheck);
            }   
            try{
                update myopplist;
            }
            catch(exception e){
                system.debug(e);
            }
        }
        // If previously selected products are now removed, we need to delete them
        if(forDeletion.size()>0)
            delete(forDeletion);
    
        // Previously selected products may have new quantities and amounts, and we may have new products listed, so we use upsert here
        try{
            if(shoppingCart.size()>0) {
                List<OpportunityLineItem> olisToUpsert = new List<OpportunityLineItem>();
                for (Cart cart : shoppingCart) {
                    if (cart.isCategory == true) {
                        cart.oli.Product_Name__c = mapProductToName.get(cart.oli.PricebookEntry.Product2Id + ':' + cart.oli.Category__c);
                        cart.oli.Product_Code__c = mapProductToCode.get(cart.oli.PricebookEntry.Product2Id + ':' + cart.oli.Category__c);
                    } else {
                        cart.oli.Product_Name__c = cart.oli.PricebookEntry.Product2.Name;
                        cart.oli.Product_Code__c = cart.oli.PricebookEntry.Product2.ProductCode;
                    }
                    olisToUpsert.add(cart.oli);
                }
                upsert(olisToUpsert);
            }
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }  
           
        // After save return the user to the Opportunity

        /* this didn't work, replaced it with reloadNeeded functionality - Jeff Lup - 2012.11.28
        PageReference pageRef = new PageReference(Page.OpportunityAddProducts.getURL() );
        pageRef.getParameters().put('id',ApexPages.currentPage().getParameters().get('Id'));
        pageRef.setRedirect(true);
        return pageRef;
        
        //return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
        */
        
        //CHG0046761 - Jeff Lup - 2012.12.13
        List<OpportunityLineItem> subs = [SELECT TotalPrice_USD__c, TotalPrice_GBP__c
                                          FROM OpportunityLineItem
                                          WHERE OpportunityId = :theOpp.Id
                                            AND PricebookEntry.Product2.Service_Description__c = 'Subscription'];
        Decimal subsTotal_USD = 0.00;
        Decimal subsTotal_GBP = 0.00;
        for (OpportunityLineItem sub : subs) {
            subsTotal_USD += (sub.TotalPrice_USD__c == null ? 0 : sub.TotalPrice_USD__c);
            subsTotal_GBP += (sub.TotalPrice_GBP__c == null ? 0 : sub.TotalPrice_GBP__c);
        }       
        thisOpp.Subs_Amount_USD__c = subsTotal_USD;
        thisOpp.Subs_Amount_GBP__c = subsTotal_GBP;
        update thisOpp;
                
        reloadNeeded = true;
        return null;
    }
    
    public PageReference onCancel(){
        
        Opportunity thisOpp  = [Select Id, StageName From Opportunity Where Id =:theopp.Id];
        list<Opportunity> myopp = [Select Id from Opportunity Where Parent_Opportunty__c =:thisOpp.Id And Checkopp__c = true And Product_Count__c = 0];
        
        
        
    try{
        delete myopp;
    }
    catch(exception e){
        system.debug(e);
    }
        // If user hits cancel we commit no changes and return them to the Opportunity 
        /*  
        PageReference pageRef = new PageReference(Page.OpportunityAddProducts.getURL() );
        pageRef.getParameters().put('id',ApexPages.currentPage().getParameters().get('Id'));
        pageRef.setRedirect(true);
        return pageRef;
        */
        reloadNeeded = true; //CHG0071993
        return null;
    }
    
    public PageReference changePricebook(){
    
        // This simply returns a PageReference to the standard Pricebook selection screen
        // Note that is uses retURL parameter to make sure the user is sent back after they choose
    
        PageReference ref = new PageReference('/oppitm/choosepricebook.jsp');
        ref.getParameters().put('id',theOpp.Id);
        ref.getParameters().put('retURL','/apex/opportunityProductEntry?id=' + theOpp.Id);
        
        return ref;
    }
    
    //**** Used for Shopping Cart ****//
    private Integer cartId = 0;
    public List<cart> shoppingCart {get; set;}
    public class Cart {
        public OpportunityLineItem oli {get; set;}
        public Integer cartId {get; set;}
        public boolean isToken {get; set;} 
        public boolean isCategory {get; set;} //CHG0067203
        public boolean isInvoiceSystem {get; set;} //Amit
        public Map<Id, Set<String>> mapProductToCategories {get; set;} //CHG0067203
        public Map<String, String> mapProductToName {get; set;} 
        public Map<String, String> mapProductToCode {get; set;}
        public Boolean hasArticlePassProduct{get;set;}//CHG0036420
        
        //CHG0067203
        public List<SelectOption> categories {
            get {
                List<SelectOption> options = new List<SelectOption>();
                Set<String> categories = mapProductToCategories.get(oli.PricebookEntry.Product2Id);
                options.add(new SelectOption('','----NONE----'));
                for (String category : categories) { 
                    options.add(new SelectOption(category,category));
                }
                return options;
            }
            set;
        }    
    }    
    
    //**** Used for Parent page refresh ****//  
    public String pageURL {set;}
    public Boolean reloadNeeded {get; set;}
    
    public String getPageURL() {
        ApexPages.StandardController sc = new ApexPages.StandardController(theOpp); 
        PageReference pageRef = sc.view();
        return pageRef.getUrl();    
    }
}