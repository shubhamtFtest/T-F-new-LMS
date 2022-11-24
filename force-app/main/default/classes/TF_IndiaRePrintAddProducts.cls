public class TF_IndiaRePrintAddProducts {
    public String sortDirection = 'DESC'; 
    OpportunityLineItem[] OpplList;
    
         public class wrapdatadup {      
        @AuraEnabled
        public String ISBN { get;set; }        
        @AuraEnabled
        public String Quantity { get;set; } 
        @AuraEnabled
        public String Binding { get;set; } 
    }
    public class wrapdata {      
        @AuraEnabled
        public String Ids { get;set; }        
        @AuraEnabled
        public String productCode { get;set; } 
        @AuraEnabled
        public String OppName { get;set; } 
    }
    
    public class ProductDetails {      
        @AuraEnabled
        public String productId { get;set; }        
        @AuraEnabled
        public String productCode { get;set; }        
        @AuraEnabled
        public String versionType { get;set; }
        @AuraEnabled
        public String DACKey { get;set; }  
    }
    
    public class ProductSearchResult {      
        @AuraEnabled
        public String productId { get;set; }        
        @AuraEnabled
        public String productCode { get;set; }        
        @AuraEnabled
        public String versionType { get;set; }
        @AuraEnabled
        public String DACKey { get;set; }
        @AuraEnabled
        public Decimal unitPrice { get;set; }  
        @AuraEnabled
        public String currencyIsoCode { get;set; }        
    }
    
    public class SearchResult {
        @AuraEnabled
        public String pbId { get;set; }        
        @AuraEnabled
        public String productId { get;set; }        
        @AuraEnabled
        public String productName { get;set; } 
        @AuraEnabled
        public String productCode { get;set; }        
        @AuraEnabled
        public String versionType { get;set; }
        @AuraEnabled
        public Decimal unitPrice { get;set; }  
        @AuraEnabled
        public String currencyIsoCode { get;set; }        
        @AuraEnabled
        public String inrISBN { get;set; }
        @AuraEnabled
        public String globalISBN { get;set; }        
        @AuraEnabled       
        public Boolean isRerun { get;set; }
    }
    
    public class PagedResult {        
        @AuraEnabled
        public Integer pageSize { get;set; }        
        @AuraEnabled
        public Integer page { get;set; }        
        @AuraEnabled
        public Integer total { get;set; }       
        @AuraEnabled
        public List<PricebookEntry> products { get;set; }
    }
    
    public class Items {
        @AuraEnabled
        public String Binding { get;set; }        
        @AuraEnabled
        public String ISBN { get;set; }
        @AuraEnabled
        public String IndianISBN { get;set; }        
        @AuraEnabled
        public String Quantity { get;set; }
        @AuraEnabled
        public String Id { get;set; }        
    }
    
    public class ListItems {
        @AuraEnabled
        public String Id { get;set; }         
        @AuraEnabled
        public String Binding { get;set; } 
        @AuraEnabled
        public String requiredBinding { get;set; }               
        @AuraEnabled
        public String ISBN { get;set; }
        @AuraEnabled
        public String Quantity { get;set; } 
        @AuraEnabled
        public String WorkNumber { get;set; }
        @AuraEnabled
        public String indiaISBN { get;set; } 
        @AuraEnabled
        public String isRerun { get;set; }                       
    }   
  
    @AuraEnabled
    public static List<wrapdatadup> checkCurrentProposalDuplicate(String jsonStr, String oppId) {
        List<wrapdatadup> returnlist=new List<wrapdatadup>();
        list<Items> listItems = (list<Items>)JSON.deserialize(jsonStr, Items[].class); 
        map<String,Items> mapstr=new map<String,Items>();
        	List<String> Allisbn=new List<String>();

        List<String> IndianIsbnset=new List<String>();
        for (Items item : listItems) {
            mapstr.put(item.ISBN,item);
            Allisbn.add(item.ISBN);
        }
        Set<wrapdatadup> setob=new Set<wrapdatadup>();
        for(Opportunitylineitem obj:[select id,Binding_Type__c,Global_ISBN__c ,Required_Version_Type__c,Product2.productcode,Quantity  from Opportunitylineitem where OpportunityId =:oppId]){
            if(mapstr.containskey(obj.Global_ISBN__c)){
            if(obj.Global_ISBN__c==mapstr.get(obj.Global_ISBN__c).ISBN && obj.Quantity ==decimal.valueof(mapstr.get(obj.Global_ISBN__c).Quantity)
               && obj.Required_Version_Type__c ==mapstr.get(obj.Global_ISBN__c).Binding){
                   wrapdatadup wrapobj= new wrapdatadup();
                   wrapobj.ISBN=mapstr.get(obj.Global_ISBN__c).ISBN;
                   wrapobj.Quantity=mapstr.get(obj.Global_ISBN__c).Quantity;
                   wrapobj.Binding=mapstr.get(obj.Global_ISBN__c).Binding;
                   setob.add(wrapobj);
            }
            }
        }
       map<string,wrapdatadup>  mapob=new map<string,wrapdatadup>();
        for(wrapdatadup obj :setob){
            mapob.put(String.valueof(obj.ISBN),obj);
        }

        returnlist.addall(mapob.values());
        return returnlist;
    }
        @AuraEnabled
    public static List<wrapdata> checkexistingProposal(String jsonStr, String oppId) {
    Set<wrapdata> wrapSet=new Set<wrapdata>();
	List<String> Allisbn=new List<String>();
	Set<String> IndianIsbnset=new Set<String>();
	Set<String> OrignalIsbnset=new Set<String>();
        
        list<Items> listItems = (list<Items>)JSON.deserialize(jsonStr, Items[].class);  
        for (Items item : listItems) {
            Allisbn.add(item.ISBN);
        }
        for(product2 obj:[select id,version_type__c,productcode from product2 where (version_type__c='Paperback' Or Version_type__c='Hardback') and productcode in:Allisbn]){
            OrignalIsbnset.add(obj.productcode);
        }
        List<String> productName=new List<String>();
        List<ProductSearchResult> productSearchResult = getReprintProductOne(productName, Allisbn);
        for(ProductSearchResult pobj:productSearchResult){
            IndianIsbnset.add(pobj.productCode);
        }
        for(Opportunitylineitem oliobj:[select id,Name,OpportunityID,product2.productcode,Opportunity.Name from Opportunitylineitem where Opportunity.stageName!='Closed Won' and Opportunity.recordtype.name='T&F - India Reprint' and (product2.productcode in:IndianIsbnset Or product2.productcode in:OrignalIsbnset)]){
            wrapdata owrap=new wrapdata();
            owrap.Ids=oliobj.OpportunityID;
            owrap.productCode=oliobj.product2.productcode;
            wrapSet.add(owrap);
        }
        Map<String, wrapdata> mapstr = new Map<String, wrapdata>();
        for(wrapdata acc : wrapSet){
            string str=String.valueof(acc.Ids+'#'+acc.productCode);
            mapstr.put(str, acc);
        }
        List<wrapdata> wrapList=new List<wrapdata>();
        wrapList.addAll(mapstr.values());
        return wrapList;
    }
     
    @AuraEnabled 
    public static List<wrapdata> doesProductExistInActiveOpp(Id productId, Id opportunityId, String currencyISOCode, String requiredQty, String requiredVersionType, String globalISBN, String inrISBN) { 
        String isbn = String.isNotBlank(inrISBN) ? inrISBN : globalISBN;
        List<OpportunityLineItem> olis = [SELECT Id,OpportunityId,product2.ProductCode FROM OpportunityLineItem WHERE Opportunity.StageNAme!='Closed Won' AND Opportunity.recordtype.name='T&F - India Reprint' AND ProductCode =: isbn];                    
        Map<String, wrapdata> mapstr = new Map<String, wrapdata>();
        Set<wrapdata> wrapSet=new Set<wrapdata>();
            for(OpportunityLineItem oliobj:olis){
                wrapdata owrap=new wrapdata();
                owrap.Ids=oliobj.OpportunityID;
                owrap.productCode=oliobj.product2.productcode;
                wrapSet.add(owrap);
            }
            for(wrapdata acc : wrapSet){
                string str=String.valueof(acc.Ids+'#'+acc.productCode);
                mapstr.put(str, acc);
            }
            List<wrapdata> wrapList=new List<wrapdata>();
            wrapList.addAll(mapstr.values());
            return wrapList;
    }
    @AuraEnabled
    public static String importOpportunityLineItems(String jsonStr, String oppId) {
        List<OpportunityLineItem> lstOLIInsert = new List<OpportunityLineItem>();
        List<Decimal> AllQuantity=new List<Decimal>();
        List<String> productName=new List<String>();
        List<String> Allisbn=new List<String>();
        List<String> IndianIsbnset=new List<String>();
        List<PricebookEntry> aLlISBNpriceBookEntry=new  List<PricebookEntry> ();
        map<String,priceBookEntry> mapAllidPricebookentry=new map<String,priceBookEntry>();
        List<PricebookEntry> iNdianISBNpriceBookEntry=new  List<PricebookEntry> ();
        map<String,String> mapisbnkey=new map<String,String>();
        map<String,priceBookEntry> mapIndianISBNidPricebookentry=new map<String,priceBookEntry>();
        String msg = 'NO_RECORD_TO_INSERT';
        Id theBookId = [SELECT Id FROM PriceBook2 WHERE Name = 'T&F India Pricebook' LIMIT 1].Id;
        list<Items> listItems = (list<Items>)JSON.deserialize(jsonStr, Items[].class);  
        Id accountId = [select AccountId From Opportunity where Id =:oppId LIMIT 1].AccountId; 
        for (Items item : listItems) {
            Allisbn.add(item.ISBN);
            AllQuantity.add(Decimal.valueof(item.Quantity));
        }
      system.debug(listItems.size()+'^T^^'+Allisbn.size());
        List<ProductSearchResult> productSearchResult = getReprintProductOne(productName, Allisbn);
        system.debug('getReprintProductOne'+productSearchResult.size());
        for(ProductSearchResult pobj:productSearchResult){
            IndianIsbnset.add(pobj.productCode);
        }
        
        List<String> isbns=new List<String>();
        for(PriceBookEntry objpe:[select Id, ProductCode,IsActive, Unitprice, Pricebook2Id,Product2.DAC_Key__c, Product2.Last_UMC_Customer_Quote__c,
                                 	Product2.UMC__c, Product2.Date_of_Last_UMC__c, Product2.Last_UMC_Popular_Formats__c, Product2.Last_UMC_Format_Width_mm__c, 
                                 	Product2.Last_UMC_Format_Height_mm__c, Product2.Last_UMC_Version_Type__c, Product2.Last_UMC_Text_Colour__c, 
                                 	Product2.Last_UMC_Paper_Type__c,Product2.Printed_Pages__c,Product2.Insert__c,Product2.Cover_color__c, 
                                 	Product2.Insert_Color__c, Product2.Insert_Paper__c, Product2.Cover_Paper__c, Product2.Extras__c,
									Product2.Printer_Name__c,Product2.ProductCode, Product2.Year_of_Print__c, Product2.Supply_Date__c, Product2.Lamination__c                                    
                                    FROM PriceBookEntry 
                                    WHERE   (product2.version_type__c='Indian Edition Paperback' or product2.version_type__c='Indian Edition Hardback') and Pricebook2Id =:theBookId and 
                                    Product2.ProductCode in :IndianIsbnset ]){
                                        
                                         if(objpe.IsActive==false){
                                         objpe.IsActive=true;
                                     }
            iNdianISBNpriceBookEntry.add(objpe);
            isbns.add(objpe.Product2.ProductCode);
            
        }
        update iNdianISBNpriceBookEntry;
        List<PricebookEntry> pbelist=new List<PricebookEntry>();
        
        for(PricebookEntry pbeobj:[SELECT Id,product2id,unitprice,Pricebook2.IsStandard,Product2.ProductCode,currencyisocode FROM PricebookEntry  where Pricebook2.IsStandard=true and Product2.ProductCode in :IndianIsbnset and currencyisocode='INR']){
            if(!isbns.contains(pbeobj.Product2.ProductCode))
            {
            PricebookEntry pbe =new PricebookEntry();
            pbe.currencyisocode='INR';
            pbe.Pricebook2Id=theBookId;
            pbe.product2id=pbeobj.product2id;
            pbe.UnitPrice= pbeobj.UnitPrice; 
                pbe.IsActive=true;
            pbelist.add(pbe); 
            }
        } 
        if(pbelist.size()>0){
        insert pbelist;
		iNdianISBNpriceBookEntry.addall(pbelist);
        }
        List<id> productwithnostandardinrprice=new list<Id>(); 
        for(pricebookentry pbs:iNdianISBNpriceBookEntry){
            productwithnostandardinrprice.add(pbs.product2id);
        }
        List<PricebookEntry> pbezerolist=new List<PricebookEntry>();
                List<PricebookEntry> standardentry=new List<PricebookEntry>();

        for(product2 pc:[select id,productcode from product2 where productcode in:IndianIsbnset]){
            if(!productwithnostandardinrprice.contains(pc.id)){
                PricebookEntry pbestandardentry =new PricebookEntry();
                pbestandardentry.UnitPrice= 0; 
                pbestandardentry.IsActive=true;
                pbestandardentry.product2id=pc.id;
                pbestandardentry.Pricebook2Id='01s0Y0000082FixQAE';
                pbestandardentry.currencyisocode='INR';
				standardentry.add(pbestandardentry);
                PricebookEntry pbe =new PricebookEntry();
                pbe.currencyisocode='INR';
                pbe.Pricebook2Id=theBookId;
                pbe.product2id=pc.id;
                pbe.UnitPrice= 0; 
                pbe.IsActive=true;
                pbezerolist.add(pbe); 
            }
        }
        insert standardentry;
        insert pbezerolist;
        iNdianISBNpriceBookEntry.addall(pbezerolist);

      /*  iNdianISBNpriceBookEntry = [select Id, ProductCode, Unitprice, Pricebook2Id,Product2.DAC_Key__c, Product2.Last_UMC_Customer_Quote__c,
                                 	Product2.UMC__c, Product2.Date_of_Last_UMC__c, Product2.Last_UMC_Popular_Formats__c, Product2.Last_UMC_Format_Width_mm__c, 
                                 	Product2.Last_UMC_Format_Height_mm__c, Product2.Last_UMC_Version_Type__c, Product2.Last_UMC_Text_Colour__c, 
                                 	Product2.Last_UMC_Paper_Type__c,Product2.Printed_Pages__c,Product2.Insert__c,Product2.Cover_color__c, 
                                 	Product2.Insert_Color__c, Product2.Insert_Paper__c, Product2.Cover_Paper__c, Product2.Extras__c,
									Product2.Printer_Name__c, Product2.Year_of_Print__c, Product2.Supply_Date__c, Product2.Lamination__c                                    
                                    FROM PriceBookEntry 
                                    WHERE  Pricebook2.IsActive=true and Pricebook2Id =:theBookId and 
                                    Product2.ProductCode in :IndianIsbnset ];//And  Product2.Quantity__c in:AllQuantity];*/
      
        system.debug(iNdianISBNpriceBookEntry.size()+'IndianISBNpriceBookEntry'+iNdianISBNpriceBookEntry); 
        for(PricebookEntry pbobj:iNdianISBNpriceBookEntry){
            mapIndianISBNidPricebookentry.put(pbobj.Product2.DAC_Key__c,pbobj);
        }
        for(PriceBookEntry objpe:[select Id,IsActive, ProductCode, Unitprice, Pricebook2Id, Product2.DAC_Key__c, Product2.Last_UMC_Customer_Quote__c, 
                                 Product2.UMC__c, Product2.Date_of_Last_UMC__c, Product2.Last_UMC_Popular_Formats__c, Product2.Last_UMC_Format_Width_mm__c, 
                                 Product2.Last_UMC_Format_Height_mm__c, Product2.Last_UMC_Version_Type__c, Product2.Last_UMC_Text_Colour__c, 
                                 Product2.Last_UMC_Paper_Type__c,Product2.Printed_Pages__c,Product2.Insert__c,Product2.Cover_color__c,product2.version_type__c, 
                                 Product2.Insert_Color__c, Product2.Insert_Paper__c, Product2.Cover_Paper__c, Product2.Extras__c,
                                 Product2.Printer_Name__c, Product2.Year_of_Print__c, Product2.Supply_Date__c, Product2.Lamination__c
                                 FROM PriceBookEntry 
                                 WHERE  (product2.version_type__c='Paperback' or product2.version_type__c='Hardback') and Pricebook2Id =:theBookId and 
                                 Product2.ProductCode in :Allisbn]){
                                     if(objpe.IsActive==false){
                                         objpe.IsActive=true;
                                     }
            aLlISBNpriceBookEntry.add(objpe);
        }
        update aLlISBNpriceBookEntry;
       /* aLlISBNpriceBookEntry = [select Id, ProductCode, Unitprice, Pricebook2Id, Product2.DAC_Key__c, Product2.Last_UMC_Customer_Quote__c, 
                                 Product2.UMC__c, Product2.Date_of_Last_UMC__c, Product2.Last_UMC_Popular_Formats__c, Product2.Last_UMC_Format_Width_mm__c, 
                                 Product2.Last_UMC_Format_Height_mm__c, Product2.Last_UMC_Version_Type__c, Product2.Last_UMC_Text_Colour__c, 
                                 Product2.Last_UMC_Paper_Type__c,Product2.Printed_Pages__c,Product2.Insert__c,Product2.Cover_color__c, 
                                 Product2.Insert_Color__c, Product2.Insert_Paper__c, Product2.Cover_Paper__c, Product2.Extras__c,
                                 Product2.Printer_Name__c, Product2.Year_of_Print__c, Product2.Supply_Date__c, Product2.Lamination__c
                                 FROM PriceBookEntry 
                                 WHERE  Pricebook2.IsActive=true and Pricebook2Id =:theBookId and 
                                 Product2.ProductCode in :Allisbn ];//And  Product2.Quantity__c in:AllQuantity];*/
        
        system.debug(aLlISBNpriceBookEntry.size()+'List Size aLlISBNpriceBookEntry'+aLlISBNpriceBookEntry);
        
        for(PricebookEntry pbobj:aLlISBNpriceBookEntry){
            mapAllidPricebookentry.put(pbobj.Product2.DAC_Key__c,pbobj);
        }
        Set<Id> productidforpriceentry=new set<Id>();
        for(Product2 poobj:[select id,DAC_Key__c,productcode from Product2 where productcode in:Allisbn or productcode in:IndianIsbnset]){
            if(poobj.productcode!=null){
            mapisbnkey.put(poobj.productcode,poobj.DAC_Key__c);
            }
        }
        
        system.debug(mapisbnkey+''+mapAllidPricebookentry);
        List<string> listInvalidisbn=new List<string>();
       	map<string,Items> mapquantitybinding =new map<string,Items>();
          for (Items item : listItems) {
            if(mapisbnkey.containskey(item.ISBN)){
            if(mapIndianISBNidPricebookentry.containskey(mapisbnkey.get(item.ISBN))){
                OpportunityLineItem oliObj = new OpportunityLineItem();
                String isbn = item.ISBN;
                oliObj.OpportunityId = oppId;
                oliObj.PricebookEntryId =mapIndianISBNidPricebookentry.get(mapisbnkey.get(item.ISBN)).Id;
                oliObj.Product_Code__c = item.ISBN;
                oliObj.Quantity = Integer.valueOf(item.Quantity);
                oliObj.Required_Version_Type__c = item.Binding;
                oliObj.Distributor__c = AccountId;
                oliObj.IR_Product_Type__c = 'Rerun';                
                oliObj.Global_ISBN__c = item.ISBN;
                oliObj.Indian_Isbn__c =mapIndianISBNidPricebookentry.get(mapisbnkey.get(item.ISBN)).productcode;
                
                oliObj.MRP__c = mapIndianISBNidPricebookentry.get(mapisbnkey.get(item.ISBN)).UnitPrice;
                oliObj.UMC__c = mapIndianISBNidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.UMC__c;
                oliObj.Customer_Quote__c = mapIndianISBNidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Last_UMC_Customer_Quote__c;                
                oliObj.Date_of_Last_UMC__c = mapIndianISBNidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Date_of_Last_UMC__c;                    
                oliObj.Popular_Format__c = mapIndianISBNidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Last_UMC_Popular_Formats__c;
                oliObj.Format_Width_mm__c = mapIndianISBNidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Last_UMC_Format_Width_mm__c;
                oliObj.Format_Height_mm__c = mapIndianISBNidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Last_UMC_Format_Height_mm__c;                   
                oliObj.Version_Type__c = mapIndianISBNidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Last_UMC_Version_Type__c;
                oliObj.Text_Colour__c = mapIndianISBNidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Last_UMC_Text_Colour__c;
                oliObj.Paper_Type_GSM__c = mapIndianISBNidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Last_UMC_Paper_Type__c;
                oliObj.Extent__c = mapIndianISBNidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Printed_Pages__c;                   
                oliObj.Insert__c = mapIndianISBNidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Insert__c;
                oliObj.Cover_color__c = mapIndianISBNidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Cover_color__c;
                oliObj.Insert_Color__c = mapIndianISBNidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Insert_Color__c;
                oliObj.Insert_Paper__c = mapIndianISBNidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Insert_Paper__c;
                oliObj.Cover_Paper__c = mapIndianISBNidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Cover_Paper__c;
                oliObj.Extras__c = mapIndianISBNidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Extras__c;                                
                oliObj.Printer_Name__c = mapIndianISBNidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Printer_Name__c;
                oliObj.Year_of_Print__c = mapIndianISBNidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Year_of_Print__c;
                oliObj.Supply_Date__c = mapIndianISBNidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Supply_Date__c;
                oliObj.Lamination__c = mapIndianISBNidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Lamination__c;
                lstOLIInsert.add(oliObj);
            }else{
                if(mapAllidPricebookentry.containskey(mapisbnkey.get(item.ISBN)) ){                    
                    OpportunityLineItem oliObj = new OpportunityLineItem();
                    String isbn = item.ISBN;
                    oliObj.OpportunityId = oppId;
                    oliObj.PricebookEntryId = mapAllidPricebookentry.get(mapisbnkey.get(item.ISBN)).Id;
                    oliObj.Product_Code__c = item.ISBN;
                    oliObj.Quantity = Integer.valueOf(item.Quantity);
                    oliObj.Required_Version_Type__c = item.Binding;
                    oliObj.Distributor__c = AccountId;
                    oliObj.IR_Product_Type__c = 'New';
                    oliObj.Global_ISBN__c = item.ISBN;
                    oliObj.Indian_Isbn__c = '';
                    
                    oliObj.UMC__c = mapAllidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.UMC__c;
                    oliObj.Customer_Quote__c = mapAllidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Last_UMC_Customer_Quote__c;                
                    oliObj.Date_of_Last_UMC__c = mapAllidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Date_of_Last_UMC__c;                    
                    oliObj.Popular_Format__c = mapAllidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Last_UMC_Popular_Formats__c;
                    oliObj.Format_Width_mm__c = mapAllidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Last_UMC_Format_Width_mm__c;
                    oliObj.Format_Height_mm__c = mapAllidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Last_UMC_Format_Height_mm__c;                   
                    oliObj.Version_Type__c = mapAllidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Last_UMC_Version_Type__c;
                    oliObj.Text_Colour__c = mapAllidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Last_UMC_Text_Colour__c;
                    oliObj.Paper_Type_GSM__c = mapAllidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Last_UMC_Paper_Type__c;
                    oliObj.Extent__c = mapAllidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Printed_Pages__c;                   
                    oliObj.Insert__c = mapAllidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Insert__c;
                    oliObj.Cover_color__c = mapAllidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Cover_color__c;
                    oliObj.Insert_Color__c = mapAllidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Insert_Color__c;
                    oliObj.Insert_Paper__c = mapAllidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Insert_Paper__c;
                    oliObj.Cover_Paper__c = mapAllidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Cover_Paper__c;
                    oliObj.Extras__c = mapAllidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Extras__c;                                
                    oliObj.Printer_Name__c = mapAllidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Printer_Name__c;
                    oliObj.Year_of_Print__c = mapAllidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Year_of_Print__c;
                    oliObj.Supply_Date__c = mapAllidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Supply_Date__c;
                    oliObj.Lamination__c = mapAllidPricebookentry.get(mapisbnkey.get(item.ISBN)).Product2.Lamination__c;                    
                    lstOLIInsert.add(oliObj);
                }
            }
            if(!mapIndianISBNidPricebookentry.containskey(mapisbnkey.get(item.ISBN)) && !mapAllidPricebookentry.containskey(mapisbnkey.get(item.ISBN))){
               listInvalidisbn.add(item.ISBN); 
            }
            }
        }
        insert lstOLIInsert;
                List<String> stlist=new List<String>();

        String attName = 'InvalidIsbns.csv'; 
        String subject = 'Re-Evaluate Thise ISBNS';
        String bodycsv = 'This Email Contains The Info Of All Invalid ISBN(Products)'; 
        // Creating the CSV file
        String finalstr = 'ISBN,ERROR \n';
        String ERROR='INVALID ISBN';
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage> ();
        for(String st:listInvalidisbn){
                string recordString = '"'+st+'","'+Error+'"\n';
                finalstr = finalstr +recordString;
                stlist.add(st);
        }
        
        // Create the email attachment    
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'apc@tandf.co.uk'];
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName(attName);
        efa.setBody(Blob.valueOf(finalstr));
        for(User printeruseer:[Select id,email,profile.name from user where id=:UserInfo.getUserId() limit 1]){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
              if ( owea.size() > 0 ) {
                email.setOrgWideEmailAddressId(owea[0].Id);
            }
            email.setSubject(subject);
            email.setToAddresses(new string[] {printeruseer.Email});
            email.setPlainTextBody(bodycsv); 
            // Attach file using setFileAttachments function
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            // Sends the email
            mails.add(email);
        }   
        system.debug(stlist.size()+'stlist'+stlist);
        if(stlist.size()>0){
        Messaging.SendEmailResult[] sentEmails;
       // sentEmails=Messaging.sendEmail(mails);
        }
        System.debug(lstOLIInsert.size()+'@@@ lstOLIInsert::'+lstOLIInsert);
        return msg;
    }
    
    
    public static list<ProductSearchResult> getReprintProductOne(List<String> productName, List<String> isbn) {
        List<String> stlist=new List<String>();
        List<ProductSearchResult> resultList = new List<ProductSearchResult>();
        map<String,string> product2worknoversionmap=new map<String,string>();
        List<String> isbncheck=new List<String>();
        for(product2 proobj:[select id,productcode,DAC_Key__c,Version_Type__c from product2 where DAC_Key__c !=null and productcode in:isbn]){
            isbncheck.add(proobj.productcode);
            product2worknoversionmap.put(proobj.DAC_Key__c,proobj.Version_Type__c);
        }
        String attName = 'InvalidIsbns.csv'; 
        String subject = 'Re-Evaluate Thise ISBNS';
        String bodycsv = 'This Email Contains The Info Of All Invalid ISBN(Products)'; 
        // Creating the CSV file
        String finalstr = 'ISBN,ERROR \n';
        String ERROR='INVALID ISBN';
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage> ();
        for(String st:isbn){
            if(!isbncheck.contains(st)){
                string recordString = '"'+st+'","'+Error+'"\n';
                finalstr = finalstr +recordString;
                stlist.add(st);
            }
        }
        
        // Create the email attachment    
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName(attName);
        efa.setBody(Blob.valueOf(finalstr));
        for(User printeruseer:[Select id,email,profile.name from user where profile.name='India Reprint Customer Service' ]){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
            email.setSubject(subject);
            email.setToAddresses(new string[] {printeruseer.Email});
            email.setPlainTextBody(bodycsv); 
            // Attach file using setFileAttachments function
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            // Sends the email
            mails.add(email);
        }   
        if(stlist.size()>0){
        Messaging.SendEmailResult[] sentEmails;
       // sentEmails=Messaging.sendEmail(mails);
        }
        if(product2worknoversionmap.size()>0){
            for(Product2 lstObj : [SELECT Id,Version_Type__c,DAC_Key__c,ProductCode FROM Product2 WHERE DAC_Key__c !=null And (version_type__c = 'Indian Edition Paperback' Or version_type__c = 'Indian Edition Hardback') And DAC_Key__c in:product2worknoversionmap.keyset()]){
                ProductSearchResult srObj = new ProductSearchResult();
                srObj.productId = lstObj.Id;
                if(product2worknoversionmap.get(lstObj.DAC_Key__c)=='Paperback'){
                    srObj.versionType = 'Indian Edition Paperback';
                }else if(product2worknoversionmap.get(lstObj.DAC_Key__c)=='Hardback'){
                    srObj.versionType = 'Indian Edition Hardback';
                }
                srObj.productCode = lstObj.ProductCode;
                srObj.DACKey = lstObj.DAC_Key__c;
                resultList.add(srObj);
            }	
        }
       
        return resultList;
    }
    
    @AuraEnabled
    public static Boolean isProductExistInTandFIndiaPricebook(Id productId){
        Boolean isProductExist = false;
        Id priceBook2Id = [SELECT Id FROM PriceBook2 WHERE Name = 'T&F India Pricebook' LIMIT 1].Id;
        Id standardPriceBookId = Test.isRunningTest() ? Test.getStandardPricebookId() : [SELECT Id FROM Pricebook2 WHERE isStandard = true limit 1].Id;        
        List<PricebookEntry> listObj = [SELECT Id, Pricebook2Id, IsActive FROM PricebookEntry WHERE Pricebook2Id=:priceBook2Id AND Product2.Id=:productId];                       
        if(listObj.size() > 0) {
            Boolean isPBActive = listObj[0].IsActive;
            Id pbEntryId = listObj[0].Id;
            if(isPBActive == false){
                PricebookEntry pbe = new PricebookEntry();
                pbe.Id = pbEntryId;
                pbe.IsActive = true;
                update pbe;
                isProductExist = true;
            }else{
                isProductExist = true; 
            } 
        }
        return isProductExist;
    }
    
    @AuraEnabled
    public static String checkAndCreateStandardPriceBookEntry(Id productId){
        String msg;
        //Id standardPriceBookId = [Select Id From Pricebook2 where IsStandard = true LIMIT 1].Id;
        Id standardPriceBookId = Test.isRunningTest() ? Test.getStandardPricebookId() : [SELECT Id FROM Pricebook2 WHERE isStandard = true limit 1].Id;
        List<PriceBookEntry> priceBookEntry = [SELECT Id from PriceBookEntry WHERE Pricebook2Id = :standardPriceBookId AND Product2Id = :productID AND CurrencyIsoCode = 'INR' limit 1];         
        if(priceBookEntry.size() > 0) {
            msg = 'RECORD_EXIST';
        }else{
            PricebookEntry pbe = new PricebookEntry(
                Pricebook2Id = standardPriceBookId,CurrencyIsoCode = 'INR',Product2Id = productId,
                UnitPrice = 0,IsActive = true,UseStandardPrice = false
            );
            Insert pbe; 
            msg = 'RECORD_CREATED';
        }
        return msg;
    }
    
    @AuraEnabled
    public static String checkAndCreateCustomPriceBookEntry(Id productId){
        String msg;
        //Id priceBook2Id = [SELECT Id FROM PriceBook2 WHERE Name = 'T&F India Pricebook' LIMIT 1].Id;
        Id priceBook2Id = Test.isRunningTest() ? Test.getStandardPricebookId() : [SELECT Id FROM PriceBook2 WHERE Name = 'T&F India Pricebook' LIMIT 1].Id;
        List<PriceBookEntry> priceBookEntry = [SELECT Id from PriceBookEntry WHERE Pricebook2Id = :priceBook2Id AND Product2Id = :productID AND CurrencyIsoCode = 'INR' limit 1];         
        if(priceBookEntry.size() > 0) {
            msg = 'RECORD_EXIST';
        }else{
            PricebookEntry pbe = new PricebookEntry(
                Pricebook2Id = priceBook2Id,CurrencyIsoCode = 'INR',Product2Id = productId,
                UnitPrice = 0,IsActive = true,UseStandardPrice = false
            );
            Insert pbe;
            msg = 'RECORD_CREATED';            
        }
        return msg;   
    }
    
    @AuraEnabled
    public static Boolean doesProductExistInCurrentOppLineItem(Id oppId, Integer Qty, String versionType, String globalISBN, String inrISBN) {
        Boolean status = false;
        String isbn = String.isNotBlank(inrISBN) ? inrISBN : globalISBN;
        List<OpportunityLineItem> olis = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId =:oppId AND Quantity =:Qty AND Required_Version_Type__c =:versionType AND ProductCode =: isbn];                    
        if(olis.size() > 0){
            status = true;
        }
        return status;
    }
    
    @AuraEnabled
    public static String createOpportunityLineItem(Id productId, Id opportunityId, String currencyISOCode, String requiredQty, String requiredVersionType, String globalISBN, String inrISBN) { 
        String msg = 'No Records to update';
        Integer reQty = Integer.valueof(requiredQty);
        Id priceBook2Id;
        if (test.isrunningtest()) {
            priceBook2Id = Test.getStandardPricebookId();
        } else {
            priceBook2Id = [SELECT Id FROM PriceBook2 WHERE Name = 'T&F India Pricebook' LIMIT 1].Id;
        }
        Boolean isProductExist = doesProductExistInCurrentOppLineItem(opportunityId, reQty, requiredVersionType, globalISBN, inrISBN);
        if(isProductExist == false) {
            List<opportunity> oppListObj = [select id, AccountId From Opportunity where Id =:opportunityId LIMIT 1];
            Opportunity oppObj = oppListObj[0];
            List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
            String IndiaIsbn = [SELECT ProductCode FROM Product2 WHERE Id =:productId LIMIT 1].ProductCode;
            Boolean isExist = isProductExistInTandFIndiaPricebook(productId);
            system.debug('productId::'+productId+',priceBook2Id::'+priceBook2Id+',currencyISOCode::'+currencyISOCode);
            if(String.isNotBlank(inrISBN)) {                         
                PriceBookEntry priceBookEntry = getPriceBookEntry(productId, priceBook2Id, currencyISOCode);         
                system.debug('RerunProduct PriceBookEntryId::'+priceBookEntry.Id);
                OpportunityLineItem oli = new OpportunityLineItem(
                    OpportunityId = opportunityId, 
                    Quantity = reQty, 
                    Required_Version_Type__c = requiredVersionType,
                    PricebookEntryId = priceBookEntry.Id, 
                    Distributor__c = oppObj.AccountId,
                    IR_Product_Type__c = 'Rerun',
                    Indian_Isbn__c = inrISBN,
                    Global_ISBN__c = globalISBN
                );
                oliList.add(oli);       
                if(oliList.size() > 0) {
                    insert oliList;
                    msg = 'Record inserted successfully';
                } 
            } else {
                //string msg1 = checkAndCreateStandardPriceBookEntry(productId);
                //string msg2 = checkAndCreateCustomPriceBookEntry(productId);
                PriceBookEntry priceBookEntry = getPriceBookEntry(productId, priceBook2Id, currencyISOCode);         
                system.debug('NewProduct PriceBookEntryId::'+priceBookEntry.Id);
                OpportunityLineItem oli = new OpportunityLineItem(
                    OpportunityId = opportunityId, 
                    Quantity = reQty, 
                    Required_Version_Type__c = requiredVersionType,
                    PricebookEntryId = priceBookEntry.Id, 
                    Distributor__c = oppObj.AccountId, 
                    IR_Product_Type__c = 'New',
                    Indian_Isbn__c = inrISBN,
                    Global_ISBN__c = globalISBN
                );
                oliList.add(oli);       
                if(oliList.size() > 0) { 
                    insert oliList;
                    msg = 'Record inserted successfully';
                }            
            }
        } else {
            msg = 'RECORD_EXIST';
        }       
        return msg;
    }
    
    //this is to get pricebook entry id of a product
    private static PriceBookEntry getPriceBookEntry(Id productID, Id priceBookId, String currencyIsoCode) {
        PriceBookEntry priceBookEntry = null;
        try {
            priceBookEntry = [SELECT Id from PriceBookEntry WHERE Pricebook2Id = :priceBookId AND
                              Product2Id = :productID AND CurrencyIsoCode = :currencyIsoCode];           
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }    
        return priceBookEntry;
    }
    
    
    public static list<ProductDetails> getProduct(String productName, String isbn) {
        List<ProductDetails> resultList = new List<ProductDetails>();
        String prdQry = 'Select Id, ProductCode, Version_Type__c, DAC_Key__c From Product2 Where (IsActive = true OR IsActive = false)';       
        if(productName != null){
            prdQry+= ' and Name like \'%' + productName + '%\'';
        }       
        if(isbn != null){
            prdQry+= ' and ProductCode = \'' + isbn + '\'';
        } 
        prdQry+= ' LIMIT 1';
        List<Product2> prdLst = Database.query(prdQry);
        
        if(prdLst.size() > 0) {
            for(Product2 lstObj : prdLst){
                ProductDetails srObj = new ProductDetails();
                srObj.productId = lstObj.Id;
                srObj.versionType = lstObj.Version_Type__c;
                srObj.productCode = lstObj.ProductCode;
                srObj.DACKey = lstObj.DAC_Key__c;
                resultList.add(srObj);
            }             
        }        
        return resultList;        
    }
    
    public static list<ProductSearchResult> getReprintProduct(String productName, String isbn) {
        List<ProductSearchResult> resultList = new List<ProductSearchResult>();
        List<ProductDetails> prdDetails = getProduct(productName, isbn);
        String versionType = prdDetails[0].versionType;
        String workNumber = prdDetails[0].DACKey;
        String vType;
        List<Product2> prdLst = null;
        system.debug('versionType::'+versionType+',workNumber::'+workNumber+',vType::'+vType);
        if(versionType == 'Paperback'){
            prdLst = [SELECT Id,Version_Type__c,DAC_Key__c,ProductCode FROM Product2 WHERE version_type__c = 'Indian Edition Paperback' AND DAC_Key__c =:workNumber LIMIT 1];
            if(prdLst.size() == 0){
                prdLst = [SELECT Id,Version_Type__c,DAC_Key__c,ProductCode FROM Product2 WHERE version_type__c = 'Indian Edition Hardback' AND DAC_Key__c =:workNumber LIMIT 1];
            }
        }else if(versionType == 'Hardback'){
            prdLst = [SELECT Id,Version_Type__c,DAC_Key__c,ProductCode FROM Product2 WHERE version_type__c = 'Indian Edition Hardback' AND DAC_Key__c =:workNumber LIMIT 1];
            if(prdLst.size() == 0){
                prdLst = [SELECT Id,Version_Type__c,DAC_Key__c,ProductCode FROM Product2 WHERE version_type__c = 'Indian Edition Paperback' AND DAC_Key__c =:workNumber LIMIT 1];
            }            
        }
        
        if(prdLst.size() > 0) {
            for(Product2 lstObj : prdLst){
                ProductSearchResult srObj = new ProductSearchResult();
                srObj.productId = lstObj.Id;
                srObj.versionType = lstObj.Version_Type__c;
                srObj.productCode = lstObj.ProductCode;
                srObj.DACKey = lstObj.DAC_Key__c;
                resultList.add(srObj);
            }             
        }        
        return resultList;
    }
    
    @AuraEnabled
    public static list<SearchResult> getListOfPriceBookEntryNew(String oppId, String productName, String isbn) { 
        Id standardPriceBookId = '01s0Y0000082Fix'; 
        Id customPriceBookId; 
        if (test.isrunningtest()) {
            customPriceBookId = Test.getStandardPricebookId();
        } else {
            customPriceBookId = [SELECT Id FROM PriceBook2 WHERE Name = 'T&F India Pricebook' LIMIT 1].Id;
        }        
        List<PricebookEntry> pbeLst = new List<PricebookEntry>();
        List<SearchResult> resultList = new List<SearchResult>();        
        List<Product2> prdLst = new List<Product2>();
        List<ProductSearchResult> productSearchResult = getReprintProduct(productName, isbn);
        system.debug('productSearchResult::'+productSearchResult);
        
        /////////
        if(productSearchResult.size() > 0) {
            //Search in PricebookEntry
            String qry = 'Select Id, PricebookEntry.Product2.Service_Description__c, Pricebook2Id, IsActive,Product2.Name, Product2.ProductCode,';
            qry+='Product2.Family, Product2.IsActive, Product2.Description,Product2.Version_Type__c,UnitPrice,CurrencyIsoCode From ';
            qry+='PricebookEntry where ';
            qry+='Pricebook2Id = \'' + customPriceBookId + '\'';
            qry+= ' and Product2.ProductCode = \'' + productSearchResult[0].productCode + '\'';       
            qry+= ' LIMIT 1';
            system.debug('qry::'+qry);
            pbeLst = Database.query(qry);
            if(pbeLst.size()==0){
                List<product2> productid=new list<product2>([select id,productcode from product2 where productcode=:productSearchResult[0].productCode]);
               List<pricebookentry> listtoupdate=new list<pricebookentry>();
                List<PricebookEntry> pbeobj=new list<PricebookEntry>([SELECT Id,product2id,unitprice,Pricebook2.IsStandard,Product2.ProductCode,currencyisocode FROM PricebookEntry  where Pricebook2.IsStandard=true and Product2.ProductCode =:productSearchResult[0].productCode and currencyisocode='INR']);
                if(pbeobj.size()>0){
                    PricebookEntry pbe =new PricebookEntry();
                    pbe.currencyisocode='INR';
                    pbe.Pricebook2Id=customPriceBookId;
                    pbe.product2id=pbeobj[0].product2id;
                    pbe.UnitPrice= pbeobj[0].UnitPrice; 
                    pbe.IsActive=true;
                    listtoupdate.add(pbe);                     
                }else{
                    PricebookEntry pbeYD = new PricebookEntry();
                    pbeYD.Pricebook2Id = standardPriceBookId;
                    pbeYD.Product2Id = productid[0].id;
                    pbeYD.UnitPrice = 0; 
                    insert pbeYD;
                    PricebookEntry pbe =new PricebookEntry();
                    pbe.currencyisocode='INR';
                    pbe.Pricebook2Id=customPriceBookId;
                    pbe.product2id=productid[0].id;
                    pbe.UnitPrice= 0; 
                    pbe.IsActive=true;
                    listtoupdate.add(pbe);
                }
                insert listtoupdate;
            }
            if(pbeLst.size() > 0) {
                for(PricebookEntry pbeObj : pbeLst){
                    SearchResult srObj = new SearchResult();
                    srObj.pbId = pbeObj.Pricebook2Id;
                    srObj.productId = pbeObj.Product2.Id;
                    srObj.productName = pbeObj.Product2.Name; 
                    srObj.versionType = pbeObj.Product2.Version_Type__c;
                    srObj.productCode = pbeObj.Product2.ProductCode;
                    srObj.globalISBN = isbn;
                    srObj.inrISBN = pbeObj.Product2.ProductCode;
                    srObj.unitPrice = pbeObj.UnitPrice;
                    srObj.currencyIsoCode = pbeObj.CurrencyIsoCode;
                    srObj.isRerun = true;
                    resultList.add(srObj);
                }             
            }            
        } else { 
                //if product is Original and does not exist in "T&F India Pricebook" pricebook
                String prdQry = 'Select Id, Name, Service_Description__c, ProductCode, Family, Description, Version_Type__c';
                prdQry += ' From Product2 Where (IsActive = true OR IsActive = false)';
                if(productName != null){
                    prdQry += ' and Name like \'%' + productName + '%\'';
                }  
                
                if(isbn != null){
                    prdQry += ' and ProductCode = \'' + isbn + '\'';
                } 
                prdQry += ' LIMIT 1';             
                system.debug('prdQry::'+prdQry);
                prdLst = Database.query(prdQry);
                if(prdLst.size() > 0) {
                    for(Product2 prObj : prdLst){
                        SearchResult srObj = new SearchResult();
                        srObj.pbId = '';
                        srObj.productId = prObj.Id;
                        srObj.productName = prObj.Name; 
                        srObj.versionType = prObj.Version_Type__c;
                        srObj.productCode = prObj.ProductCode;
                        srObj.globalISBN = isbn;
                        srObj.inrISBN = '';
                        srObj.unitPrice = 0.00;
                        srObj.currencyIsoCode = '';
                        srObj.isRerun = false;
                        resultList.add(srObj);
                    }             
                }                
        }
        return resultList;
    }   
}