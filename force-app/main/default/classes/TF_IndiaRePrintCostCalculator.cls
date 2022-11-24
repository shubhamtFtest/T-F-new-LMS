public class TF_IndiaRePrintCostCalculator {

    public class OpportunityLineItemDetails {      
        @AuraEnabled
        public String oliId { get;set; }        
        @AuraEnabled
        public Integer Qty { get;set; } 
        @AuraEnabled
        public String popularFormat { get;set; }
        @AuraEnabled
        public Decimal formatHeight { get;set; }
        @AuraEnabled
        public Decimal formatWidth { get;set; } 
        @AuraEnabled
        public String versionType { get;set; }        
        @AuraEnabled
        public String requiredVersionType { get;set; }
        @AuraEnabled
        public String textColour { get;set; }
        @AuraEnabled
        public String paperTypeGSM { get;set; }
        @AuraEnabled
        public Decimal extent { get;set; }
        @AuraEnabled
        public Decimal printedPages { get;set; }
        @AuraEnabled
        public String supplyDate { get;set; } 
        @AuraEnabled
        public String printerName { get;set; } 
        @AuraEnabled
        public Decimal mrp { get;set; }        
    }
    
    public class wrapProduct {        
        @AuraEnabled
        public String productId { get;set; } 
        @AuraEnabled
        public String productCode { get;set; }         
        @AuraEnabled
        public String popularFormat { get;set; } 
        @AuraEnabled
        public Integer formatHeight { get;set; }        
        @AuraEnabled
        public Integer formatWidth { get;set; }
        @AuraEnabled
        public String textColour { get;set; } 
        @AuraEnabled
        public String paperType { get;set; }
        @AuraEnabled
        public String versionType { get;set; }        
        @AuraEnabled
        public Integer extent { get;set; }       
        @AuraEnabled
        public String lastUMCPopularFormat { get;set; }
        @AuraEnabled
        public Integer lastUMCFormatHeight { get;set; }
        @AuraEnabled
        public Integer lastUMCFormatWidth { get;set; }
        @AuraEnabled
        public String lastUMCPaperType { get;set; }
        @AuraEnabled
        public String lastUMCVersionType { get;set; }
        @AuraEnabled
        public String lastUMCTextColour { get;set; }
        @AuraEnabled
        public Integer lastUMCQuantity { get;set; }        
        @AuraEnabled
        public Decimal lastUMC { get;set; }
        @AuraEnabled
        public Date lastUMCDate { get;set; } 
        @AuraEnabled
        public Decimal lastUMCCustomerQuote { get;set; }  
        @AuraEnabled
        public String pInsert { get;set; } 
        @AuraEnabled
        public String coverColor { get;set; }
        @AuraEnabled
        public String insertColor { get;set; }
        @AuraEnabled
        public String insertPaper { get;set; }
        @AuraEnabled
        public String coverPaper { get;set; }
        @AuraEnabled
        public String extras { get;set; } 
        @AuraEnabled
        public String supplyDate { get;set; } 
        @AuraEnabled
        public String printerName { get;set; } 
        @AuraEnabled
        public Decimal mrp { get;set; }        
    }
    
    public class PagedResultDetails {        
        @AuraEnabled
        public Integer Quantity { get;set; }
        @AuraEnabled
        public String msg { get;set; }        
        @AuraEnabled
        public List <wrapProduct> prList { get;set; }        
    }
    
    public class ProductionHistoryDetails {      
        @AuraEnabled
        public String title { get;set; } 
        @AuraEnabled
        public String IndianISBN { get;set; } 
        @AuraEnabled
        public String binding { get;set; } 
        @AuraEnabled
        public Decimal Qty { get;set; }        
        @AuraEnabled
        public Decimal umc { get;set; }        
        @AuraEnabled
        public Integer gratis { get;set; } 
        @AuraEnabled
        public String customerQuote { get;set; } 
        @AuraEnabled
        public Decimal gm { get;set; }   
        @AuraEnabled
        public Decimal mrp { get;set; }
        @AuraEnabled
        public String year { get;set; }        
    }
       
    @AuraEnabled 
    public static List<ProductionHistoryDetails> getProductionHistory(String oliId){
        List<ProductionHistoryDetails> historyWrapLst = new List<ProductionHistoryDetails>();
        List<OpportunityLineItem> oliLst = [select Id, ProductCode, Global_ISBN__c, Indian_Isbn__c from OpportunityLineItem where Id =:oliId limit 1]; 
        List<Print_Order_Item__c> poiList;
        OpportunityLineItem oli = oliLst[0];
        String IndiaISBN = oli.Indian_Isbn__c;
        String GlobalISBN = oli.Global_ISBN__c;
        system.debug('IndiaISBN::'+IndiaISBN+' and GlobalISBN::'+GlobalISBN);
        if(String.isNotBlank(IndiaISBN)){
            poiList = [SELECT Id, UMC__c, mrp__c, Customer_Quote__c, Printed_Pages__c, Gratis__c, Cover_Color__c, Binding__c, year__c, Reference_Number__c, ISBN__c, Indian_Isbn__c, Title__c, Gross_Margins__c, Print_Run__c,List_Price_GBP__c  
                       FROM Print_Order_Item__c WHERE year__c!='' and Indian_Isbn__c = :IndiaISBN order by year__c desc]; 
        }else{
            poiList = [SELECT Id, UMC__c, mrp__c, Customer_Quote__c, Printed_Pages__c, Gratis__c, Cover_Color__c, Binding__c, year__c, ISBN__c, Indian_Isbn__c, Title__c, Gross_Margins__c, Print_Run__c,List_Price_GBP__c 
                       FROM Print_Order_Item__c WHERE year__c!='' and ISBN__c = :GlobalISBN order by year__c desc];             
        }
        system.debug('TF_IndiaRePrintCostCalculator:'+poiList);
        if(poiList.size() > 0) { 
            for(Print_Order_Item__c poiObj : poiList) {
                ProductionHistoryDetails poiWrapObj = new ProductionHistoryDetails();
                poiWrapObj.title = poiObj.Title__c;                
                poiWrapObj.IndianISBN = poiObj.Indian_Isbn__c;
                poiWrapObj.binding = poiObj.Binding__c;
                poiWrapObj.Qty = poiObj.Print_Run__c;            
                poiWrapObj.umc = poiObj.UMC__c;
                poiWrapObj.gratis = Integer.valueOf(poiObj.Gratis__c);                                              
                if(poiObj.List_Price_GBP__c == ''){
                    poiWrapObj.customerQuote = String.ValueOf(poiObj.Customer_Quote__c);
                }else{
                    poiWrapObj.customerQuote =poiObj.List_Price_GBP__c; 
                }         
                poiWrapObj.gm = poiObj.Gross_Margins__c;
                poiWrapObj.mrp = poiObj.mrp__c; 
                poiWrapObj.year = poiObj.year__c;
                historyWrapLst.add(poiWrapObj);
            }
        } 
        return historyWrapLst;
    }
    
    @AuraEnabled
    public static Decimal getCoversionRate() {
        IndiaReprintSettings__c IndiaReprintSettings = IndiaReprintSettings__c.getOrgDefaults();
        Decimal coversionRate = (Decimal) IndiaReprintSettings.get('Customer_Quote_Conversion_Rate__c'); 
        return coversionRate;
    }

    @AuraEnabled
    public static List<OpportunityLineItemDetails> getOLIDetail(String prodId) {  
        List<OpportunityLineItemDetails> oliWrapLst = new List<OpportunityLineItemDetails>();
        List<OpportunityLineItem> oliList = [SELECT Id, Quantity, Printed_Pages__c, Extent__c, UMC__c, Popular_Format__c, Format_Height_mm__c, 
                                             Required_Version_Type__c, Format_Width_mm__c, Product2.Version_Type__c,Version_Type__c,
                                             Text_Colour__c,Paper_Type_GSM__c,Printer_Name__c,Supply_Date__c,Production_Comments__c 
                                             FROM OpportunityLineItem WHERE Id = :prodId Limit 1];
        if(oliList.size() > 0) {
            for(OpportunityLineItem oliObj : oliList) {
                OpportunityLineItemDetails oliWrapObj = new OpportunityLineItemDetails();
                oliWrapObj.oliId = oliObj.Id;              
                oliWrapObj.Qty = Integer.valueOf(oliObj.Quantity);       
                oliWrapObj.popularFormat = oliObj.Popular_Format__c;       
                oliWrapObj.formatHeight = oliObj.Format_Height_mm__c;         
                oliWrapObj.formatWidth = oliObj.Format_Width_mm__c;          
                oliWrapObj.versionType = oliObj.Version_Type__c;                 
                oliWrapObj.requiredVersionType = oliObj.Required_Version_Type__c;         
                oliWrapObj.textColour = oliObj.Text_Colour__c;       
                oliWrapObj.paperTypeGSM = oliObj.Paper_Type_GSM__c;
                oliWrapObj.extent = oliObj.Extent__c;
                oliWrapObj.printedPages = oliObj.Printed_Pages__c;
                oliWrapObj.printerName = oliObj.Printer_Name__c;
                oliWrapObj.supplyDate = oliObj.Supply_Date__c;
                oliWrapLst.add(oliWrapObj);
            }
        }
        return oliWrapLst;
    }
    
    @AuraEnabled
    public static String getProductId(String opportunityLineItemId) {
        List<OpportunityLineItem> productLst = [SELECT Id,Product2Id FROM OpportunityLineItem WHERE Id = :opportunityLineItemId Limit 1];        
        String productId = productLst[0].Product2Id; 
        return productId; 
    }
    
    @AuraEnabled
    public static PagedResultDetails getLastPrintDetails(String oliId) {         
        PagedResultDetails prDetail = new PagedResultDetails();
        List<wrapProduct> productWrapLst = new List<wrapProduct>();              
        List<Product2> prdLst = new List<Product2>();
        String productId = getProductId(oliId);
        try {
            prdLst = [SELECT Id, ProductCode, Last_UMC_Popular_Formats__c, Last_UMC_Format_Width_mm__c, Last_UMC_Format_Height_mm__c, 
                      Last_Print_Pages__c, Last_UMC_Text_Colour__c, Last_UMC_Paper_Type__c, Insert__c, Extras__c, Last_UMC_Version_Type__c,
                      Last_UMC_Quantity__c, UMC__c, Date_of_Last_UMC__c, Last_UMC_Customer_Quote__c,Cover_color__c, Insert_Color__c,                  
                      Insert_Paper__c, Cover_Paper__c, Printer_Name__c, Supply_Date__c
                      FROM Product2 WHERE Id = :productId Limit 1];
                system.debug('prdLst::'+prdLst);
            if(prdLst.size() > 0) {
                for(Product2 prdObj : prdLst) {					                   
                    wrapProduct productWrapObj = new wrapProduct();
                    productWrapObj.productId = prdObj.Id;
                    productWrapObj.productCode = prdObj.ProductCode;                                          
                    //last UMC details
                    productWrapObj.lastUMCPopularFormat = prdObj.Last_UMC_Popular_Formats__c;
                    productWrapObj.lastUMCFormatHeight = Integer.valueOf(prdObj.Last_UMC_Format_Height_mm__c);                    
                    productWrapObj.lastUMCFormatWidth = Integer.valueOf(prdObj.Last_UMC_Format_Width_mm__c);                    
                    productWrapObj.lastUMCPaperType = prdObj.Last_UMC_Paper_Type__c;                   
                    productWrapObj.lastUMCVersionType = prdObj.Last_UMC_Version_Type__c;                   
                    productWrapObj.lastUMCTextColour = prdObj.Last_UMC_Text_Colour__c;                                                           
                    productWrapObj.lastUMC = prdObj.UMC__c;
                    productWrapObj.lastUMCDate = prdObj.Date_of_Last_UMC__c;
                    productWrapObj.lastUMCQuantity = Integer.valueOf(prdObj.Last_UMC_Quantity__c);
                    productWrapObj.lastUMCCustomerQuote = prdObj.Last_UMC_Customer_Quote__c; 
                    productWrapObj.extent = Integer.valueOf(prdObj.Last_Print_Pages__c);
                    
                    productWrapObj.pInsert = prdObj.Insert__c;
                    productWrapObj.coverColor = prdObj.Cover_color__c; 
                    productWrapObj.insertColor = prdObj.Insert_Color__c;
                    productWrapObj.insertPaper = prdObj.Insert_Paper__c; 
                    productWrapObj.coverPaper = prdObj.Cover_Paper__c; 
                    productWrapObj.extras = prdObj.Extras__c; 
                    productWrapObj.printerName = prdObj.Printer_Name__c;
                    productWrapObj.supplyDate = prdObj.Supply_Date__c;
                    productWrapObj.mrp = 0;//need to get pricebook MRP                    
                    productWrapLst.add(productWrapObj);
                } 
                prDetail.Quantity = 100;
                prDetail.prList = productWrapLst;
            }            
        } catch(Exception ex) {
            System.debug(ex.getMessage());
        }
        return prDetail;        
    }    
      
    @AuraEnabled 
    public static Map<String, String> getSizeInInches(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Print_Cost_Calculator_Setting__c.Size_in_Inches__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            //Put Picklist Value & Label in Map
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }
    
    @AuraEnabled
    public static String updateUMC(String oliId, String umc, String qty, String extent, String popularFormat, String formatHeight, String formatWidth, String versionType, String textColour, String paperType) {   
        String msg='RECORD_NOT_FOUND'; 
        try {           
            Decimal toroundUMC  = Decimal.valueOf(umc);
            Decimal roundedUMC = toroundUMC.setScale(2, RoundingMode.HALF_UP);
            Id userId = UserInfo.getUserId();
            Date today = system.today();        
            if(String.isNotBlank(oliId)){
                List<OpportunityLineItem> olis = [select Id,UMC__c,Popular_Format__c,Format_Height_mm__c,Format_Width_mm__c,Extent__c,Quantity,Version_Type__c,Text_Colour__c,Paper_Type_GSM__c from OpportunityLineItem where Id =:oliId LIMIT 1];
                OpportunityLineItem oliObj = olis[0];
                oliObj.UMC__c = roundedUMC;
                oliObj.Quantity = Integer.valueOf(qty);
                oliObj.Extent__c = Integer.valueOf(extent);
                oliObj.Popular_Format__c = popularFormat;
                oliObj.Format_Height_mm__c = Integer.valueOf(formatHeight);
                oliObj.Format_Width_mm__c = Integer.valueOf(formatWidth);                                   
                oliObj.Version_Type__c = versionType;
                oliObj.Text_Colour__c = textcolour;
                oliObj.Paper_Type_GSM__c = papertype;
                if(olis.size() > 0){
                    update olis;
                }
                //TF_IRPOLIHistory_Utils.createOLIHistoryRecord(oliId);
                msg ='RECORD_UPDATED';
            }
            return msg;            
        } catch (Exception ex){
            system.debug('Exception::' + ex.getMessage());
            return msg;
        }
    }
    
    @AuraEnabled
    public static Map<String, Decimal> getPopularFormats(String size, String qty) { 
        String msg = 'No Records to update';        
        String productName;
        String selectQuery;  
        String where_Clause;        
        Integer quantity = Integer.valueOf(qty);
        Map<String, Decimal> mm = new Map<String, Decimal>();
        List<Print_Cost_Calculator_Setting__c> pccsLst = [select Id, Size_in_Inches__c, Format_Height_mm__c, Format_Width_mm__c, 
                                                         X70gsm__c, X80gsm__c, Sewing__c, Hard_Case_PLC__c, Dust_Jacket__c, color__c From 
                                                         Print_Cost_Calculator_Setting__c where Size_in_Inches__c =:size limit 1];

        List<Print_Cost_Calculator_Setting__c> umcLst = new List<Print_Cost_Calculator_Setting__c>();
        String query = 'Select Id, Size_in_Inches__c, Format_Height_mm__c, Format_Width_mm__c,';
        query+= 'X70gsm__c,X80gsm__c, Sewing__c, Hard_Case_PLC__c, Dust_Jacket__c, color__c';
        query+= ' From Print_Cost_Calculator_Setting__c Where Is_Active__c = true and Size_in_Inches__c=\''+size+'\'';
        String quantityRange1 = '1 to 10';
        String quantityRange2 = '11 to 30';
        String quantityRange3 = '31 and Above';
        if(quantity > 0 && quantity <= 10){
            query+= ' and Quantity__c = \''+quantityRange1+'\'';
        }
        if(quantity > 10 && quantity <= 30){
            query+= ' and Quantity__c = \''+quantityRange2+'\'';
        }
        if(quantity > 30){
            query+= ' and Quantity__c = \''+quantityRange3+'\'';
        }        
        query+= ' Limit 1';
        umcLst = Database.query(query);
        system.debug('Print Cost Calculator Setting Query::'+query);
        if(umcLst.size() > 0){
            Print_Cost_Calculator_Setting__c umcObj = umcLst[0];            
            mm.put('formatHeight',umcObj.Format_Height_mm__c);
            mm.put('formatWidth',umcObj.Format_Width_mm__c);
            mm.put('X70gsm',umcObj.X70gsm__c);
            mm.put('X80gsm',umcObj.X80gsm__c);
            mm.put('sewing',umcObj.Sewing__c);
            mm.put('hardCasePLC',umcObj.Hard_Case_PLC__c);
            mm.put('dustJacket',umcObj.Dust_Jacket__c);
            mm.put('color',umcObj.color__c);
        }
        return mm;
    }    
}