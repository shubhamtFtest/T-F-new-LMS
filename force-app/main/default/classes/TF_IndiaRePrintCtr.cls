/*
** Tested by: zTEST_TF_IndiaRePrintCtr.cls
**
** Created by Amit Kumar 10/02/2020
*/
public class TF_IndiaRePrintCtr {
    
    public String sortDirection = 'DESC';
    OpportunityLineItem[] OpplList;
    
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
    
    public class Filter {        
        @AuraEnabled
        public String productName { get;set; }        
        @AuraEnabled
        public String leadAuthor { get;set; }        
        @AuraEnabled
        public String publisher { get;set; }        
        @AuraEnabled
        public List<String> versionTypes { get;set; }
        @AuraEnabled
        public String productFamily { get;set; }
    }
    
    public class SettingResult {
        @AuraEnabled
        public String opportunityId { get;set; }        
        @AuraEnabled
        public Boolean isOpportunityClosedWon { get;set; }         
        @AuraEnabled
        public Boolean iSSalesUser { get;set; } 
        @AuraEnabled
        public Boolean iSCustomerServiceUser { get;set; }
        @AuraEnabled
        public Boolean iSProductionUser { get;set; }
        @AuraEnabled
        public Boolean iSCreditControlUser { get;set; }        
    }
    
    public class OpportunityLineItemDetails {      
        @AuraEnabled
        public String Id { get;set; } 
        @AuraEnabled
        public String CoverColor { get;set; }
        @AuraEnabled
        public String CoverPaper { get;set; }
        @AuraEnabled
        public Decimal UkPrice { get;set; }
        @AuraEnabled
        public String ProductCode { get;set; }          
        @AuraEnabled
        public String GlobalISBN { get;set; }
        @AuraEnabled
        public String IndiaISBN { get;set; }        
        @AuraEnabled        
        public Integer Qty { get;set; } 
        @AuraEnabled
		public Decimal UMC { get;set; }
        @AuraEnabled
		public Decimal MRP { get;set; } 
        @AuraEnabled
		public Decimal CustomerQuote { get;set; }
        @AuraEnabled
		public Decimal GrossMargin { get;set; }
        @AuraEnabled
        public Boolean Status { get;set; }
        @AuraEnabled
        public Boolean Cancelled { get;set; }
        @AuraEnabled
        public String TitleName { get;set; }
        @AuraEnabled
        public String ReprintEligibility { get;set; }
        @AuraEnabled
        public String Distributor { get;set; }
        @AuraEnabled
        public Decimal Pages { get;set; }
        @AuraEnabled
        public String BindingType { get;set; } 
		@AuraEnabled
        public String Size { get;set; } 
		@AuraEnabled
        public String Inserts { get;set; } 
		@AuraEnabled
        public String TextColor { get;set; } 
		@AuraEnabled
        public String TextPaper { get;set; }
        @AuraEnabled
        public String ReprintBind { get;set; }
		@AuraEnabled
        public String Extras { get;set; }       
        @AuraEnabled
        public decimal Gratis { get;set; }        
		@AuraEnabled
        public String ProductionComment { get;set; }
		@AuraEnabled
        public String Lamination { get;set; }
		@AuraEnabled
        public String PrinterName { get;set; }
		@AuraEnabled
        public String YearOfPrint { get;set; } 
		@AuraEnabled
        public String Customer { get;set; }
		@AuraEnabled
        public String CustomerServiceComment { get;set; }
		@AuraEnabled
        public String SalesComments { get;set; }       
        @AuraEnabled
        public String ishistory{ get;set; } 
        @AuraEnabled
        public String HistoryId{ get;set; } 
        @AuraEnabled
        public String isDelete{ get;set; } 
    }

	public class ImportItems {
        @AuraEnabled
        public String CoverColor { get;set; }
        @AuraEnabled
        public String CoverPaper { get;set; }
        @AuraEnabled
        public Decimal UkPrice { get;set; }
        @AuraEnabled
		public String Id { get;set; } 
		@AuraEnabled
        public String GlobalISBN { get;set; }
		@AuraEnabled
        public String IndiaISBN { get;set; }         
		@AuraEnabled
        public String ProductCode { get;set; }        
		@AuraEnabled
        public String Qty { get;set; }
        @AuraEnabled
		public String UMC { get;set; }
        @AuraEnabled
		public String MRP { get;set; }
        @AuraEnabled
		public String CustomerQuote { get;set; }
        @AuraEnabled
		public String GrossMargin { get;set; }
        @AuraEnabled    
        public String TitleName { get;set; }
        @AuraEnabled
        public String ReprintEligibility { get;set; }
        @AuraEnabled
        public String BindingType { get;set; }
        @AuraEnabled
        public String Size { get;set; }	
        @AuraEnabled
        public String Pages { get;set; }
        @AuraEnabled
        public String Inserts { get;set; }
        @AuraEnabled
        public String TextColor { get;set; }
        @AuraEnabled
        public String TextPaper { get;set; }
        @AuraEnabled
        public String ReprintBind { get;set; }
        @AuraEnabled
        public String Extras { get;set; } 
        @AuraEnabled
        public decimal Gratis { get;set; }        
        @AuraEnabled
		public String Status { get;set; }
        @AuraEnabled
        public String Cancelled { get;set; } 
        @AuraEnabled    
        public String ProductionComment { get;set; }
        @AuraEnabled
        public String Lamination { get;set; }
        @AuraEnabled
        public String PrinterName { get;set; }
        @AuraEnabled
        public String YearOfPrint { get;set; }         
        @AuraEnabled
        public String SalesComments { get;set; }
        @AuraEnabled
        public String CustomerServiceComment { get;set; }      
        @AuraEnabled
        public String HistoryId { get;set; }
        @AuraEnabled
        public String ishistory{ get;set; } 
        @AuraEnabled
        public String isDelete{ get;set; } 
	}
    
    @AuraEnabled
    public static List<OpportunityLineItem> fetchOpportunity(String searchKeyWord) {
        String searchKey = searchKeyWord + '%';
        List<OpportunityLineItem> returnList = new List<OpportunityLineItem>();
        List<OpportunityLineItem> lstOfOpportunity = [SELECT Id, ProductCode, Opportunity.Name, Opportunity.StageName FROM OpportunityLineItem where Opportunity.StageName!='Closed Won' and ProductCode =:searchKeyWord limit 500]; 
        //for (OpportunityLineItem oppLst: lstOfOpportunity) {
        //    returnList.add(oppLst);
        //}
        return lstOfOpportunity;
    }
    
    //Get Total Number of OLIs in opp
    @AuraEnabled
    public static Integer getTotalOLIs(String oliId){
        AggregateResult results = [SELECT Count(Id) TotalOlis  From OpportunityLineItem WHERE OpportunityId=:oliId];
        Integer totalOlis = (Integer)results.get('TotalOlis') ; 
        return totalOlis;
    } 
    
    @AuraEnabled
    public static String validateReprintEligibility(String opportunityId, List<OpportunityLineItem> lstId) {         
        String res = TF_IndiaRePrintServiceCallout.checkEligibility(opportunityId, lstId);
        system.debug('TF_IndiaRePrintServiceCallout Response::'+res);
        if(res == 'SUCCESS_WITHOUT_RESPONSE_DATA' && lstId.size() > 10){
            sendEmailNotification(opportunityId, 'ReprintEligibilityPending');
        }else if(res == 'SUCCESS_WITH_RESPONSE_DATA' && lstId.size() <= 10){
            sendEmailNotification(opportunityId, 'ReprintEligibility');
        }
        return res;
    }
    
    
    @AuraEnabled
    public static OpportunityLineItem getOLIDetails(Id oliId) {
        OpportunityLineItem oli = null;
        try {
            oli = [SELECT Id, Opportunity.OwnerId, Opportunity.CreatedById, Gross_Margin__c, Remarks__c FROM OpportunityLineItem WHERE Id =:oliId];            
        } catch(Exception ex) {
            System.debug(ex.getMessage());
        }
        return oli;
    }
    
    @AuraEnabled
    public static String bulkUpdateOpportunityLineItems(String jsonStr, String oppId){
        String msg = 'ERROR';
        system.debug('jsonStr'+jsonStr);
        jsonStr = jsonStr.replace('\\"', '');
        List<OpportunityLineItem> oliObjLst = new List<OpportunityLineItem>();
        list<ImportItems> listItems = (list<ImportItems>)JSON.deserialize(jsonStr, ImportItems[].class);       
        System.debug('@@@ listItems::'+listItems); 
        List<OpportunityLineItem> oliListToUpdate = new List<OpportunityLineItem>();
        Boolean isProductionUser = iSProductionUser();
        Boolean isCustomerServiceUser = iSCustomerServiceUser();
        Boolean isSalesUser = iSSalesUser();
        
        /***/
        Set<String> ids = new Set<String>();
        for (ImportItems lstitem : listItems) {
            if(lstitem.Status == 'true'){
                ids.add(lstitem.Id);
            }
        }
        List<OpportunityLineItem> lstoli = [SELECT Id FROM OpportunityLineItem WHERE Id in :ids LIMIT 4999];         
         map<String,ImportItems> mapids=new map<String,ImportItems>(); 
        for (ImportItems item : listItems) {
            if(item.HistoryId!=null && item.HistoryId!=''){
            mapids.put(item.HistoryId,item);
            }
            OpportunityLineItem oliObj = new OpportunityLineItem(); 
            oliObj.Id = Id.valueOf(item.Id);   
            String qty = item.Qty;
            String requiredVersionType = item.ReprintBind;
            String mrp = item.MRP; 
            String customerQuote = item.CustomerQuote;                 
            String indianIsbn = item.IndiaISBN;
            String reprintEligibility = item.ReprintEligibility;
            String salesComments = item.SalesComments;
            String customerServiceComment = item.CustomerServiceComment;                      
            String umc = item.UMC;
            String popularFormat = item.Size;
            String extent = item.Pages;
            String inserts = item.Inserts;
            String textColour = item.TextColor;
            String paperTypeGSM = item.TextPaper;
            String requiredVersion_Type = item.ReprintBind;
            String extras = item.Extras; 
            Decimal gratic = item.Gratis;
            String productionComments = item.ProductionComment;
            String lamination = item.Lamination;
            String printerName = item.PrinterName;
            String yearofPrint = item.YearOfPrint;
            string CoverColor=item.CoverColor;
            string CoverPaper=item.CoverPaper;
            Decimal UkPrice=item.UkPrice;
            //If the logged-In user is CSD/Sales
            //Qty,ReprintBind,MRP,GlobalISBN,IndiaISBN,CustomerQuote,ReprintEligibility,SalesComment,CustomerServiceComment
            if(isCustomerServiceUser == true || isSalesUser == true) {                
                oliObj.Quantity = Decimal.valueOf(qty.trim());
                oliObj.Required_Version_Type__c = requiredVersionType.trim();
                oliObj.MRP__c = Decimal.valueOf(mrp.trim()); 
                oliObj.Customer_Quote__c = Decimal.valueOf(customerQuote.trim());                 
                oliObj.Indian_Isbn__c = indianIsbn.trim();
                oliObj.Reprint_Eligibility__c = reprintEligibility.trim();
                oliObj.Sales_Comments__c = salesComments.trim();
                oliObj.Customer_Service_Comment__c = customerServiceComment.trim();
                oliObj.Gratis__c = gratic;
            }
            
            //If the logged-In user is production user
            if(isProductionUser == true) { 
                oliObj.UMC__c = Decimal.valueOf(umc.trim());
                oliObj.Popular_Format__c = popularFormat.trim();
                oliObj.Extent__c = Integer.valueOf(extent.trim());
                oliObj.Insert__c = inserts.trim();
                oliObj.Text_Colour__c = textColour.trim();
                oliObj.Paper_Type_GSM__c = paperTypeGSM.trim();
                oliObj.Required_Version_Type__c = requiredVersionType.trim();
                oliObj.Extras__c = extras.trim();               
                oliObj.Production_Comments__c = productionComments.trim();
                oliObj.Lamination__c = lamination.trim();
                oliObj.Printer_Name__c = printerName.trim();
                oliObj.Year_of_Print__c = yearOfPrint.trim();
                oliObj.Cover_color__c = CoverColor.trim();
                oliObj.Cover_Paper__c	 = CoverPaper.trim();
                oliObj.UK_ISBN_Price__c = UkPrice;

            }
            oliObj.Cancelled__c = item.Cancelled == 'true' ? true : false;
            if(item.Status == 'true')  {           
                oliListToUpdate.add(oliObj);
            }
        }
        system.debug('oliListToUpdate::'+oliListToUpdate);
        try{
            if(oliListToUpdate.size() > 0) {
                update oliListToUpdate;
            }
            msg ='UPDATE_DONE';
        }  catch (Exception ex) {
            System.debug(ex.getMessage()); 
            msg ='EXCEPTION';
        }

        List<OLIHistory__c> olilist=new List<OLIHistory__c>();
        for(OLIHistory__c olih:[Select id  from OLIHistory__c where id in:mapids.keyset()]){
            if(mapids.get(olih.Id).isDelete=='TRUE' && mapids.get(olih.Id).ishistory=='History'){
                olilist.add(olih);
            }
        }
                Delete olilist;

        return msg;
    }
    
    @AuraEnabled
    public static List<OpportunityLineItemDetails> exportExcelAction(String opportunityId){
        Set<Id> oliIds = new Set<Id>();
        List<OpportunityLineItemDetails> oliWrapLst = new List<OpportunityLineItemDetails>();
        List<OpportunityLineItem> olis = [SELECT Id,Extent__c,Cover_color__c,Cover_Paper__c,UK_ISBN_Price__c, ProductCode, Global_ISBN__c, Indian_Isbn__c, Quantity, UMC__c, MRP__c,Year_of_Print__c, 
                                          Customer_Quote__c, Gross_Margin__c, Cancelled__c,Required_Version_Type__c,Printer_Name__c,
                                          Product2.Name, Product2.Popular_Formats__c, Product2.Text_Colour__c, Product2.Insert__c, 
                                          Product2.Paper_Type__c, Product2.Extras__c, Reprint_Eligibility__c,Lamination__c,
                                          Status__c, Distributor__r.Name, Printed_Pages__c, Binding_Type__c,Production_Comments__c,
                                          Popular_Format__c, Insert__c, Text_Colour__c, Paper_Type_GSM__c, Extras__c, Gratis__c,
                                          Customer_Service_Comment__c, Sales_Comments__c
                                          FROM OpportunityLineItem WHERE OpportunityId =:opportunityId];
        if(olis.size() > 0) {
            for(OpportunityLineItem oliObj : olis){               
                OpportunityLineItemDetails oliWrapObj = new OpportunityLineItemDetails();
                oliIds.add(oliObj.Id);
                oliWrapObj.Id = oliObj.Id;
                oliWrapObj.HistoryId='';
				oliWrapObj.isDelete='False';
                oliWrapObj.ProductCode = oliObj.ProductCode;
				oliWrapObj.GlobalISBN = oliObj.Global_ISBN__c;
    			oliWrapObj.IndiaISBN = (oliObj.Indian_Isbn__c == null) ? '' : oliObj.Indian_Isbn__c;
                Decimal qty = oliObj.Quantity;
                oliWrapObj.Qty = qty.intValue();               
                oliWrapObj.UMC = (oliObj.UMC__c == null) ? 0.0 : oliObj.UMC__c;
                oliWrapObj.MRP = (oliObj.MRP__c == null) ? 0.0 : oliObj.MRP__c;
                oliWrapObj.CustomerQuote = (oliObj.Customer_Quote__c == null) ? 0.0 : oliObj.Customer_Quote__c;
                oliWrapObj.GrossMargin = (oliObj.Gross_Margin__c == null) ? 0.0 : oliObj.Gross_Margin__c;                             
                oliWrapObj.Cancelled = oliObj.Cancelled__c;
                oliWrapObj.Status = false;				                
                oliWrapObj.TitleName = oliObj.Product2.Name;
                oliWrapObj.ReprintEligibility = (oliObj.Reprint_Eligibility__c == null) ? '' : oliObj.Reprint_Eligibility__c;
                oliWrapObj.Pages = oliObj.Extent__c;
                oliWrapObj.BindingType = oliObj.Binding_Type__c;
                
                oliWrapObj.Customer = String.isBlank(oliObj.Distributor__c) ? '' : oliObj.Distributor__r.Name;    
                oliWrapObj.CustomerServiceComment = (oliObj.Customer_Service_Comment__c == null) ? '' : oliObj.Customer_Service_Comment__c;
                oliWrapObj.SalesComments = (oliObj.Sales_Comments__c == null) ? '' : oliObj.Sales_Comments__c;
                
                oliWrapObj.Size = (oliObj.Popular_Format__c == null) ? '' : oliObj.Popular_Format__c;
                oliWrapObj.Inserts = (oliObj.Insert__c == null) ? '' : oliObj.Insert__c;
                oliWrapObj.TextColor = (oliObj.Text_Colour__c == null) ? '' : oliObj.Text_Colour__c;
                oliWrapObj.TextPaper = (oliObj.Paper_Type_GSM__c == null) ? '' : oliObj.Paper_Type_GSM__c;
                oliWrapObj.ReprintBind = (oliObj.Required_Version_Type__c == null) ? '' : oliObj.Required_Version_Type__c;              
                oliWrapObj.Extras = (oliObj.Extras__c == null) ? '' : oliObj.Extras__c;
                oliWrapObj.Gratis = (oliObj.Gratis__c == null) ? 0.0 : oliObj.Gratis__c;
                oliWrapObj.CoverColor=(oliObj.Cover_color__c == null) ? '' : oliObj.Cover_color__c;
                oliWrapObj.CoverPaper=(oliObj.Cover_Paper__c == null) ? '' : oliObj.Cover_Paper__c;
                oliWrapObj.UkPrice=(oliObj.UK_ISBN_Price__c == null) ? 0 : oliObj.UK_ISBN_Price__c;
                oliWrapObj.ProductionComment = (oliObj.Production_Comments__c == null) ? '' : oliObj.Production_Comments__c;
                oliWrapObj.Lamination = (oliObj.Lamination__c == null) ? '' : oliObj.Lamination__c;
                oliWrapObj.PrinterName = (oliObj.Printer_Name__c == null) ? '' : oliObj.Printer_Name__c;
                oliWrapObj.YearOfPrint = (oliObj.Year_of_Print__c == null) ? '' : oliObj.Year_of_Print__c;    
                oliWrapObj.ishistory='oli'; 
                oliWrapLst.add(oliWrapObj);
            }
        	List<OLIHistory__c> histList = [SELECT Id, Customer_Quote__c, Date_of_Last_UMC__c, Extras__c, Gratis__c, Format_Height_mm__c, 
                                            Format_Width_mm__c, Global_ISBN__c,Gross_Margin__c,Indian_Isbn__c, Insert__c, 
                                            Is_Approved_UMC__c, MRP__c, OpportunityId__c, OpportunityLineItemId__c, Pages__c, 
                                            Paper_GSM__c, Paper_size__c, Popular_Formats__c, ProductCode__c, Quantity__c, 
                                            Reprint_Eligibility__c, Required_Version_Type__c, Text_Color__c, Title_Name__c, 
                                            UMC__c, Version_Type__c, Cancelled__c, Production_Comments__c,Customer_Service_Comment__c,
                                            Printer_Name__c, Year_of_Print__c, Lamination__c,Distributor__c,Sales_Comments__c
                                            FROM OLIHistory__c WHERE OpportunityLineItemId__c in :oliIds and Is_Approved_UMC__c = false];
            for(OLIHistory__c histObj : histList) {
                OpportunityLineItemDetails oliWrpObj = new OpportunityLineItemDetails();
                oliWrpObj.Id = histObj.OpportunityLineItemId__c;
                oliWrpObj.HistoryId=histObj.Id;
                oliWrpObj.ProductCode = histObj.ProductCode__c;
				oliWrpObj.GlobalISBN = histObj.Global_ISBN__c;
                oliWrpObj.HistoryId=histObj.Id;
    			oliWrpObj.IndiaISBN = (histObj.Indian_Isbn__c == null) ? '' : histObj.Indian_Isbn__c;
                Decimal qty = histObj.Quantity__c;
                oliWrpObj.Qty = qty.intValue();               
                oliWrpObj.UMC = (histObj.UMC__c == null) ? 0.0 : histObj.UMC__c;
                oliWrpObj.MRP = (histObj.MRP__c == null) ? 0.0 : histObj.MRP__c;
                oliWrpObj.CustomerQuote = (histObj.Customer_Quote__c == null) ? 0.0 : histObj.Customer_Quote__c;
                oliWrpObj.GrossMargin = (histObj.Gross_Margin__c == null) ? 0.0 : histObj.Gross_Margin__c;                             
                oliWrpObj.Cancelled = histObj.Cancelled__c;
                oliWrpObj.Cancelled = FALSE;
                oliWrpObj.Status = false;				                
                oliWrpObj.TitleName = histObj.Title_Name__c;
                oliWrpObj.ReprintEligibility = (histObj.Reprint_Eligibility__c == null) ? '' : histObj.Reprint_Eligibility__c;
                oliWrpObj.Pages =(histObj.Pages__c == null) ? 0 :  histObj.Pages__c;
                oliWrpObj.BindingType = histObj.Version_Type__c;
                
                oliWrpObj.Customer = (histObj.Distributor__c == null) ? '' : histObj.Distributor__c;    
                oliWrpObj.CustomerServiceComment = (histObj.Customer_Service_Comment__c == null) ? '' : histObj.Customer_Service_Comment__c;
                oliWrpObj.SalesComments = (histObj.Sales_Comments__c == null) ? '' : histObj.Sales_Comments__c;
                                
                oliWrpObj.Size = (histObj.Popular_Formats__c == null) ? '' : histObj.Popular_Formats__c;
                oliWrpObj.Inserts = (histObj.Insert__c == null) ? '' : histObj.Insert__c;
                oliWrpObj.TextColor = (histObj.Text_Color__c == null) ? '' : histObj.Text_Color__c;
                oliWrpObj.TextPaper = (histObj.Paper_GSM__c == null) ? '' : histObj.Paper_GSM__c;
                oliWrpObj.ReprintBind = (histObj.Required_Version_Type__c == null) ? '' : histObj.Required_Version_Type__c;              
                oliWrpObj.Extras = (histObj.Extras__c == null) ? '' : histObj.Extras__c;
                oliWrpObj.Gratis = (histObj.Gratis__c == null) ? 0.0 : histObj.Gratis__c;
                oliWrpObj.ProductionComment = (histObj.Production_Comments__c == null) ? '' : histObj.Production_Comments__c;
                oliWrpObj.Lamination = (histObj.Lamination__c == null) ? '' : histObj.Lamination__c;
                oliWrpObj.PrinterName = (histObj.Printer_Name__c == null) ? '' : histObj.Printer_Name__c;
                oliWrpObj.YearOfPrint = (histObj.Year_of_Print__c == null) ? '' : histObj.Year_of_Print__c;
                oliWrpObj.ishistory='History';
                oliWrpObj.isDelete='False';
                oliWrpObj.CoverColor='';
                oliWrpObj.CoverPaper='';
                oliWrpObj.UkPrice= 0;
                oliWrapLst.add(oliWrpObj);                
            }            
        }
        return oliWrapLst;
    }

    @AuraEnabled
    public static String renegotiateUMCAction(List<OpportunityLineItem> lstId, String opportunityId, String UMCRenegotiateReason) {
        String msg = '';
        List<opportunity> listOppToUpdate = new List<opportunity>();
        List<OpportunityLineItem> listOliToUpdate = new List<OpportunityLineItem>();
        List<OpportunityLineItem> olisList = [SELECT Id, Status__c, Type__c, UMC_Renegotiate_Reason__c FROM OpportunityLineItem WHERE Id in :lstId];
        for(OpportunityLineItem oliObj : olisList){
            oliObj.Status__c = 'UMC Requested';
            oliObj.UMC_Renegotiate_Reason__c = UMCRenegotiateReason;
            listOliToUpdate.add(oliObj);
        } 
        
        List<opportunity> listOpportunity = [Select Id, Is_UMC_Request_Sent__c, Is_MRP_Request_Sent__c FROM opportunity WHERE Id =:opportunityId LIMIT 1];
        if(listOpportunity.size() > 0){
            for(Opportunity opp: listOpportunity){
                opp.Is_UMC_Request_Sent__c = true;
                opp.Is_MRP_Request_Sent__c = false;
                listOppToUpdate.add(opp);
            }   
        }        
        try{
            //update opportunity line items
            if(listOliToUpdate!= null && listOliToUpdate.size() > 0 ){
            	update listOliToUpdate;
            }   
            
            //update opportunity
            if(listOppToUpdate!= null && listOppToUpdate.size() > 0 ){
                update listOppToUpdate;
            } 
            msg='Record has been updated successfully.';           
        }
        Catch(exception e){
            msg='Please contact your administrator!';
            System.debug('Error in renegotiateUMCAction: '+ e.getMessage());
        }         
        return msg;
    }
    
    @AuraEnabled
    public static Boolean isOpportunityClosedWon(String opportunityId) {
        try {
			List<opportunity> listOpportunity = [select id, StageName From Opportunity where Id =:opportunityId LIMIT 1];            
            Opportunity lstOpp = listOpportunity[0];
            String oppStage = lstOpp.StageName;            
            if(oppStage == 'Closed Won'){
                return true;
            } else {
                return false;
            }
        }
        catch(exception ex){
            System.debug('isOpportunityClosedWon' + ex.getMessage());
            return false;
        }         
    }
    
    @AuraEnabled
    public static Boolean doesProductCodeExistInOpp(String oppId, String isbn){
        Boolean isExist = false;
        List<OpportunityLineItem> oliLst = [SELECT Id FROM OpportunityLineItem WHERE opportunityId =:oppId AND Global_ISBN__c =:isbn];
        if(oliLst.size() > 0){
            isExist = true;
        }
        return isExist;
    }
    
    @AuraEnabled
    public static List <OpportunityLineItemWrapper> getAllOpportunityLineItems(String recordLimit, String recordOffset, String oppId, String searchIsbn) {     
        Integer intLimit = Integer.valueof(recordLimit);
        Integer intOffset = Integer.valueof(recordOffset);        
        List <OpportunityLineItemWrapper> listOliWrapper = new List <OpportunityLineItemWrapper>();
        Boolean isProductionUser = iSProductionUser();
        opportunity opp = [SELECT Id, Is_UMC_Request_Sent__c FROM opportunity WHERE Id =:oppId LIMIT 1];        
        if(isProductionUser == true && opp.Is_UMC_Request_Sent__c == false) {
            system.debug('do not display data grid');
        } else {
            List<OpportunityLineItem> oliLst;
            String oliQry = 'select Id,ProductName__c,Type__c,UnitPrice,Quantity,ListPrice,UMC__c,MRP__c,Customer_Quote__c,Required_Version_Type__c,'; 
            oliQry+= 'IR_Product_Type__c, Indian_Isbn__c, Date_of_Last_UMC__c, Discount,Total_Price_GBP__c, Reprint_Eligibility__c, Is_Approved__c,';
            oliQry+= 'Global_ISBN__c, Status__c,Distributor__r.Name, Gross_Margin__c';
            oliQry+= ' FROM OpportunityLineItem WHERE opportunityId = \'' + oppId + '\' AND Cancelled__c = false ';                             		
            if(String.isNotBlank(searchIsbn)){
                oliQry+= ' AND Global_ISBN__c = \'' + searchIsbn + '\'';                
            }
            oliQry+= ' ORDER BY LastModifiedDate DESC';
            oliQry+= ' LIMIT '+intLimit+' Offset '+intOffset;
            oliLst = Database.query(oliQry);			                                
            if(oliLst.size() > 0) {
                for (OpportunityLineItem oli : oliLst) {               
                    OpportunityLineItemWrapper OliWrap = new OpportunityLineItemWrapper();
                    OliWrap.Id = oli.Id;                
                    OliWrap.productName = oli.ProductName__c;
                    OliWrap.type = oli.Type__c;
                    OliWrap.unitPrice = oli.UnitPrice;
                    OliWrap.quantity = oli.Quantity;
                    OliWrap.listPrice = oli.ListPrice;
                    OliWrap.mrp = oli.MRP__c;
                    OliWrap.gm = oli.Gross_Margin__c;
                    OliWrap.customerRate = oli.Customer_Quote__c;
                    OliWrap.UMC = oli.UMC__c;
                    OliWrap.dateofLastUMC = oli.Date_of_Last_UMC__c;
                    OliWrap.discount = oli.Discount;
                    OliWrap.totalPrice = oli.Total_Price_GBP__c;
                    OliWrap.reprintEligibility = oli.Reprint_Eligibility__c;
                    OliWrap.status = oli.Status__c;
                    OliWrap.distributor = oli.Distributor__r.Name;
                    OliWrap.requiredBinding = oli.Required_Version_Type__c;
                    OliWrap.productType = oli.IR_Product_Type__c;
                    OliWrap.globalISBN = oli.Global_ISBN__c;
                    OliWrap.indiaISBN = oli.Indian_Isbn__c;
                    if(oli.Reprint_Eligibility__c == 'Pass'){
                        OliWrap.isActive = true;
                    }else if(oli.Reprint_Eligibility__c == 'Fail'){
                        OliWrap.isActive = false;
                    }else{
                        OliWrap.isActive = true;
                    }                                           
                    OliWrap.isSalesUser = true;
                    if(oli.Is_Approved__c == true) {
                        OliWrap.showClass = 'greencolor';
                    }else if(oli.Status__c == 'UMC Requested') {
                        OliWrap.showClass = 'hotpinkcolor';
                    }else if(oli.Status__c == 'UMC Entered') {
                        OliWrap.showClass = 'orangecolor';
                    }else if(oli.Status__c == 'UMC Confirmed') {
                        OliWrap.showClass = 'olivecolor';
                    }else if(oli.Status__c == 'Pricing Entered') {
                        OliWrap.showClass = 'bluecolor';
                    }else if(oli.Status__c == 'Pricing Requested') {
                        OliWrap.showClass = 'tealcolor';
                    }else if(oli.Status__c == 'Pending') {
                        OliWrap.showClass = 'purplecolor';
                    }
                    listOliWrapper.add(OliWrap);
                }
            }
        }
        return listOliWrapper;        
    }
      
    @AuraEnabled
    public static String checkOpportunityOverallReprintEligibility(String opportunityId) {
        String status;
        List<opportunity> listOpportunity = [select id,Overall_Reprint_Eligibility__c from opportunity where Id =:opportunityId LIMIT 1];
        if(listOpportunity.size() > 0){
            status = listOpportunity[0].Overall_Reprint_Eligibility__c;           
        }                  
        return status; 
    }
    
    @AuraEnabled
    public static String checkIsMRPRequestSent(String opportunityId) {
        String status;
        List<opportunity> listOpportunity = [select id, Is_MRP_Request_Sent__c from opportunity where Id =:opportunityId LIMIT 1];
        if(listOpportunity.size() > 0){
            status = (listOpportunity[0].Is_MRP_Request_Sent__c == true) ? 'true' : 'false';         
        }                  
        return status; 
    }
    
    @AuraEnabled
    public static String checkIsPricingEntered(String opportunityId) {
        String status;
        List<opportunity> listOpportunity = [select id, Is_Pricing_Entered__c from opportunity where Id =:opportunityId LIMIT 1];
        if(listOpportunity.size() > 0){
            status = (listOpportunity[0].Is_Pricing_Entered__c == true) ? 'true' : 'false';         
        }                  
        return status; 
    }

    @AuraEnabled
    public static String checkIsApproved(String opportunityId) {
        String status;
        List<opportunity> listOpportunity = [select id, Is_Approved__c from opportunity where Id =:opportunityId LIMIT 1];
        if(listOpportunity.size() > 0){
            status = (listOpportunity[0].Is_Approved__c == true) ? 'true' : 'false';         
        }                  
        return status; 
    }
    
    @AuraEnabled
    public static String getOliRemarkHelper(Id oliId) {
        String msg = 'RECORD_NOT_FOUND';
        if(String.isNotBlank(oliId)){
            List<OpportunityLineItem> olis = [select id,Remarks__c from OpportunityLineItem where Id =:oliId LIMIT 1];
            if(olis.size() > 0){
                msg = olis[0].Remarks__c;
            }                        
        }
        return msg;
    }

    @AuraEnabled
    public static String saveGrossMarginApproval(String oliId, String comment) {
        String msg='RECORD_NOT_FOUND';
        Id userId = UserInfo.getUserId();
        Date today = system.today();
		Datetime currentdate = System.now();        
        if(String.isNotBlank(oliId)){
            List<OpportunityLineItem> olis = [SELECT Id, GM_Approve_By__c, GM_Approve_Date__c, GM_Approve_Comment__c FROM OpportunityLineItem WHERE Id =:oliId LIMIT 1];
            olis[0].GM_Approve_Comment__c = comment;
            olis[0].GM_Approve_By__c = userId; //sales rep user id
            olis[0].GM_Approve_Date__c = today; //approve date            
            if(olis.size() > 0){
                update olis;
            }
            msg ='RECORD_UPDATED';
        }
        return msg;
    }
    
    @AuraEnabled
    public static String approveOverride(String oliId, String eligibility, String comment) {
        String msg='RECORD_NOT_FOUND';
        Id userId = UserInfo.getUserId();
        Date today = system.today();        
        if(String.isNotBlank(oliId)){
            List<OpportunityLineItem> olis = [select id,Reprint_Eligibility__c,comment__c,OverrideApproveBy__c,OverrideApproveDate__c from OpportunityLineItem where Id =:oliId LIMIT 1];
            olis[0].Reprint_Eligibility__c = eligibility;
            olis[0].comment__c = comment;
            olis[0].OverrideApproveBy__c = userId; //sales rep user id
            olis[0].OverrideApproveDate__c = today; //approve date            
            if(olis.size() > 0){
                update olis;
            }
            msg ='RECORD_UPDATED';
        }
        return msg;
    }
    
    @AuraEnabled
    public static String approveOverrideRequest(String oliId, String reprintEligibility, String comment) {
        String msg = 'RECORD_NOT_FOUND';
        Id userId = UserInfo.getUserId();
        Date today = system.today();
        if(String.isNotBlank(oliId)){
            List<OpportunityLineItem> olis = [select id,Reprint_Eligibility__c,comment__c,OverrideApproveBy__c,OverrideApproveDate__c from OpportunityLineItem where Id =:oliId LIMIT 1];
            if(olis.size() > 0){
                olis[0].Reprint_Eligibility__c = reprintEligibility;
                olis[0].comment__c = comment;
                olis[0].OverrideApproveBy__c = userId; //sales rep user id
                olis[0].OverrideApproveDate__c = today; //approve date
                update olis;
            }
            msg = 'RECORD_UPDATED';                       
        }
        return msg;
    }

    @AuraEnabled
    public static String finalApproval(String opportunityId, List<OpportunityLineItem> lstId){            
        String msg = '';
        Decimal GrossMargin = 2.5;
        List<OpportunityLineItem> olis = [SELECT Id, Reprint_Eligibility__c, Gross_Margin__c, Indian_Isbn__c, GM_Approve_Comment__c FROM OpportunityLineItem WHERE Id in :lstId AND (Reprint_Eligibility__c='Fail' OR (Gross_Margin__c < :GrossMargin AND GM_Approve_Comment__c = null) OR (Indian_Isbn__c = '' OR Indian_Isbn__c = null))];
        if(olis.size() > 0){ 
            msg = 'NOT_ALLOW_TO_APPROVE';
            return msg;
        }else{
            List<opportunity> oppListToUpdate = new List<opportunity>();
            List<OpportunityLineItem> listOliToUpdate = new List<OpportunityLineItem>();
            List<opportunity> listOpportunity = [select Id, StageName, Is_Approved__c from opportunity where Id =:opportunityId LIMIT 1];
            try{
                if(listOpportunity.size() > 0){
                    for(Opportunity opp: listOpportunity){
                        opp.Is_Approved__c = true;
                        opp.StageName = 'Closed Won';
                        oppListToUpdate.add(opp);
                    }   
                } 
                
                if(oppListToUpdate != null && oppListToUpdate.size()>0 ){
                    update oppListToUpdate;
                }
                
                //update OLI            
                List<OpportunityLineItem> olisList = [SELECT Id, Status__c, Type__c FROM OpportunityLineItem WHERE Id in :lstId];
                for(OpportunityLineItem oliObj : olisList){
                    oliObj.Is_Approved__c = true;
                    oliObj.Status__c = 'Submitted';
                    listOliToUpdate.add(oliObj);
                } 
                if(listOliToUpdate!= null && listOliToUpdate.size()>0 ){
                    update listOliToUpdate;
                } 
                //updateOliStatusAsCloseWonORCloseLost(opportunityId, lstId);
                //create order
                IR_CreateSalesOrders CreateSalesOrderObj = new IR_CreateSalesOrders();
                CreateSalesOrderObj.CreateOrder(oppListToUpdate);                
                msg = 'RECORD_UPDATED';            
            }catch(exception e){        
                msg = 'Please contact your administrator!';
                System.debug(e.getMessage() + 'Error in updateOpportunity');
            }
            return msg;            
        }            
    }    
    
    
    @AuraEnabled
    public static String checkLineItemReprintEligibilityStatus(String opportunityId, List<OpportunityLineItem> lstId){            
        String msg = 'SUCCESS';
        List<OpportunityLineItem> olis = [SELECT Id FROM OpportunityLineItem WHERE Id in :lstId AND Reprint_Eligibility__c = null];
        if(olis.size() > 0){ 
            msg = 'NOT_ALLOW_TO_CHECK_REPRINT_ELIGIBILITY';
        } 
       return msg;                      
    }
    
    @AuraEnabled
    public static String checkLineItemStatus(String opportunityId, List<OpportunityLineItem> lstId){            
        String msg = 'SUCCESS';
        List<OpportunityLineItem> olis = [SELECT Id FROM OpportunityLineItem WHERE Id in :lstId AND (Status__c != 'UMC Entered' AND Status__c != 'UMC Confirmed')];
        if(olis.size() > 0){ 
            msg = 'NOT_ALLOW_TO_REQUEST_MRP';
        } 
       return msg;                      
    } 

    @AuraEnabled
    public static String checkLineItemStatusBeforeApproval(String opportunityId, List<OpportunityLineItem> lstId){            
        String msg = 'SUCCESS';
        List<OpportunityLineItem> olis = [SELECT Id FROM OpportunityLineItem WHERE Id in :lstId AND Status__c != 'Pricing Entered'];
        if(olis.size() > 0){ 
            msg = 'NOT_ALLOW_TO_REQUEST_APPROVAL';
        } 
       return msg;                      
    }
    
    @AuraEnabled
    public static String updateOppAndOppLineItems(String oppoptunityId, String status, List<OpportunityLineItem> lstId, String isRenegotiateUMC) {
        String msg='';
        //update OLI status
        List<OpportunityLineItem> listOliToUpdate = new List<OpportunityLineItem>();
        List<OpportunityLineItem> olisList = [SELECT Id,Status__c,Type__c FROM OpportunityLineItem WHERE Id in :lstId];
        for(OpportunityLineItem oliObj : olisList){
            oliObj.Status__c = status;
            listOliToUpdate.add(oliObj);
        }        
        try{
            if(listOliToUpdate!= null && listOliToUpdate.size()>0 ){
                if(status != 'MRP Requested'){
                    update listOliToUpdate;
                }
            }             
            String responseMsg = updateOpportunity(oppoptunityId, status, lstId, isRenegotiateUMC);
            sendEmailNotification(oppoptunityId, status);
            msg='Record has been updated successfully';           
        }
        Catch(exception e){
            msg='Please contact your administrator!';
            System.debug(e.getMessage() + 'Error in updateOppAndOppLineItems method.');
        }        
        return msg;
    }    
 
    @AuraEnabled
    public static String updateGMOverride(String opportunityId, List<OpportunityLineItem> lstId) {
        String msg='';
        Id userId = UserInfo.getUserId();
        Date today = system.today();        
        List<Opportunity> listOppToUpdate = new List<Opportunity>();
        List<Opportunity> oppsList = [SELECT Id, Is_GMOverride_Done__c FROM Opportunity WHERE Id =:opportunityId LIMIT 1];
        for(Opportunity opps : oppsList){
            opps.Is_GMOverride_Done__c = true;
            listOppToUpdate.add(opps);
        }
        //update OLI status
        List<OpportunityLineItem> listOliToUpdate = new List<OpportunityLineItem>();
        List<OpportunityLineItem> olisList = [SELECT Id,GM_Approve_By__c, GM_Approve_Date__c, GM_Approve_Comment__c FROM OpportunityLineItem WHERE Id in :lstId];
        for(OpportunityLineItem oliObj : olisList){
            oliObj.GM_Approve_By__c = userId;
            oliObj.GM_Approve_Date__c = today;
            oliObj.GM_Approve_Comment__c = 'Bulk GM Override';
            listOliToUpdate.add(oliObj);
        }        
        try{
            //update opportunity
            if(listOppToUpdate!= null && listOppToUpdate.size()>0 ){
                update listOppToUpdate;
            }       
            
            //update opportunity line items
            if(listOliToUpdate!= null && listOliToUpdate.size()>0 ){
                update listOliToUpdate;
            }             
            msg='Record has been updated successfully';           
        }
        Catch(exception e){
            msg='Please contact your administrator!';
            System.debug(e.getMessage() + 'Error in updateGMOverride method.');
        }        
        return msg;
    } 
    
    @AuraEnabled
    public static String updateOpportunity(Id opportunityId, String status, List<OpportunityLineItem> lstId,String isRenegotiateUMC){            
        String msg = '';
        List<opportunity> listOppToUpdate = new List<opportunity>();
        List<opportunity> listOpportunity = [select id,Is_Pricing_Request_Sent__c,Is_MRP_Request_Sent__c,Is_Pricing_Entered__c from opportunity where Id =:opportunityId LIMIT 1];
        try{
            if(listOpportunity.size() > 0){
                for(Opportunity opp: listOpportunity){
                    if(status == 'Pricing Requested'){
                        opp.Is_Pricing_Request_Sent__c = true;
                    }else if(status == 'UMC Requested'){
                        opp.Is_UMC_Request_Sent__c = true;
                    }else if(status == 'MRP Requested'){
                        opp.Is_MRP_Request_Sent__c = true;
                    }
                    if(isRenegotiateUMC == 'true') {
                        opp.Is_MRP_Request_Sent__c = false;
                    }
                    listOppToUpdate.add(opp);
                }   
            }           
            if(listOppToUpdate!= null && listOppToUpdate.size()>0 ){
                update listOppToUpdate;
            }            
        }catch(exception e){        
            msg = 'Please contact your administrator!';
            System.debug(e.getMessage() + 'Error in updateOpportunity');
        }        
        return msg;        
    }


    @AuraEnabled
    public static String oliPricingEntered(Id opportunityId, List<OpportunityLineItem> lstId){            
        String msg = '';
        List<opportunity> listOppToUpdate = new List<opportunity>();
        List<opportunity> listOpportunity = [select id,Is_Pricing_Entered__c from opportunity where Id =:opportunityId LIMIT 1];
        
        List<OpportunityLineItem> listOliToUpdate = new List<OpportunityLineItem>();
        List<OpportunityLineItem> olisList = [SELECT Id,Status__c,Type__c FROM OpportunityLineItem WHERE Id in :lstId]; 
        
        try {
            if(listOpportunity.size() > 0){
                for(Opportunity opp: listOpportunity){
                    opp.Is_Pricing_Entered__c = true;
                    listOppToUpdate.add(opp);
                }   
            } 

            //update opportunity
            if(listOppToUpdate!= null && listOppToUpdate.size()>0 ){
                update listOppToUpdate;
            }
            
            //update oli
            for(OpportunityLineItem oliObj : olisList){
                oliObj.Status__c = 'Pricing Entered';
                listOliToUpdate.add(oliObj);
            }            
            if(listOliToUpdate!= null && listOliToUpdate.size()>0 ){
                update listOliToUpdate;
                sendEmailNotification(opportunityId, 'Pricing Entered');
            }              
            msg = 'RECORD_UPDATED';            
        }catch(exception e){        
            msg = 'Please contact your administrator!';
            System.debug(e.getMessage() + 'Error in updateOpportunity');
        }        
        return msg;        
    } 

    @AuraEnabled
    public static boolean inlineUpdateOpportunityLineItem(List<OpportunityLineItem> opportunityLineItem){
        try {
            Database.update(opportunityLineItem);
            return true;
        }
        catch(Exception ex){
            system.debug(ex.getMessage());
            return false;
        }
    }
    
    @AuraEnabled
    public static String deleteOpportunityLineItem(Id oliId){
        String msg = 'RECORD_NOT_FOUND';
        if(String.isNotBlank(oliId)){
            List<OpportunityLineItem> olis = [select Id, Product2.Id from OpportunityLineItem where Id =:oliId];
            if(olis.size() > 0){
                delete olis;
                msg = 'RECORD_DELETED';
                return msg;
            }
        }
        return msg;
    }    
    
    @AuraEnabled
    public static String overrideOpportunityLineItem(Id oliId){
        String msg = 'RECORD_NOT_FOUND';
        if(String.isNotBlank(oliId)){
            List<OpportunityLineItem> olis = [select id,Reprint_Eligibility__c from OpportunityLineItem where Id =:oliId LIMIT 1];
            if(olis.size() > 0){
                olis[0].Reprint_Eligibility__c = 'Pass';               
                update olis;
            }
            msg = 'RECORD_UPDATED';                       
        }
        return msg;
    }
    
    @AuraEnabled
    public static List <String> getselectOptions(sObject objObject, string fld) {
        system.debug('objObject --->' + objObject);
        system.debug('fld --->' + fld);
        List < String > allOpts = new list < String > ();
        // Get the object type of the SObject.
        Schema.sObjectType objType = objObject.getSObjectType();        
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map <String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        // Get the list of picklist values for this field.
        list <Schema.PicklistEntry > values = fieldMap.get(fld).getDescribe().getPickListValues();
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        system.debug('allOpts ---->' + allOpts);
        allOpts.sort();
        return allOpts;
    } 
    
    
    @AuraEnabled
    public static String checkUserPermissionAndOpp(String opportunityId){
        String JSONStr;
        SettingResult setting =  new SettingResult();
        setting.opportunityId = opportunityId;
        setting.isOpportunityClosedWon = isOpportunityClosedWon(opportunityId);
        setting.iSSalesUser = FeatureManagement.checkPermission('India_Reprint_Sales');
        setting.iSCustomerServiceUser = FeatureManagement.checkPermission('India_Reprint_Customer_services'); 
        setting.iSProductionUser = FeatureManagement.checkPermission('India_Reprint_Production');
        setting.iSCreditControlUser = FeatureManagement.checkPermission('India_Reprint_Credit_Control');        
        JSONStr = JSON.serialize(setting);
        return JSONStr;
    }

    @AuraEnabled
    public static Boolean iSSalesUser() {
        String customPermissionName = 'India_Reprint_Sales';
        Boolean hasCustomPermission = FeatureManagement.checkPermission(customPermissionName);
        return hasCustomPermission;
    } 
    
    @AuraEnabled
    public static Boolean iSCustomerServiceUser() {
        String customPermissionName = 'India_Reprint_Customer_services';
        Boolean hasCustomPermission = FeatureManagement.checkPermission(customPermissionName);
        return hasCustomPermission;
    } 
    
    @AuraEnabled
    public static Boolean iSProductionUser() {
        String customPermissionName = 'India_Reprint_Production';
        Boolean hasCustomPermission = FeatureManagement.checkPermission(customPermissionName);
        return hasCustomPermission;
    }
    
    @AuraEnabled
    public static Boolean iSCreditControlUser() {
        String customPermissionName = 'India_Reprint_Credit_Control';
        Boolean hasCustomPermission = FeatureManagement.checkPermission(customPermissionName);
        return hasCustomPermission;
    }

    @AuraEnabled
    public static Boolean checkUserHasCustomPermissionAccess(String customPermissionName) {
        Id userId = userInfo.getUserId();
        Set <Id> permissionSetIds = new Set <Id>();
        List <User> userList = new List <User>();
        for ( SetupEntityAccess access : [ SELECT ParentId FROM SetupEntityAccess 
                                          WHERE SetupEntityId IN ( SELECT Id 
                                                                  FROM CustomPermission 
                                                                  WHERE DeveloperName =:customPermissionName )
                                         ]) 
            permissionSetIds.add(access.ParentId);
        userList = [ SELECT Username FROM User WHERE Id IN (
            SELECT AssigneeId FROM PermissionSetAssignment
            WHERE PermissionSetId IN :permissionSetIds AND AssigneeId =: userId ) ];
        return userList.isEmpty() ? false : true;
    }  
    
    @AuraEnabled
    public static String IsUMCRequested(String opportunityId) {
        Integer contentCount = 0 ;
        contentCount = [SELECT count() FROM OpportunityLineItem WHERE OpportunityId =:opportunityId AND Status__c = 'UMC Requested'];
        return (contentCount > 0) ? 'true' : 'false';
    } 
    
    @AuraEnabled
    public static String IsPricingRequested(String opportunityId) {
        Integer contentCount = 0 ;
        contentCount = [SELECT count() FROM OpportunityLineItem WHERE OpportunityId =:opportunityId AND Status__c = 'Pricing Requested'];
        return (contentCount > 0) ? 'true' : 'false';
    }
    
    public static String getPublicGroupName(String status){
        String publicGroupName;
        if(String.isNotBlank(status)) { 
            switch on status {
                when 'ReprintEligibility' {	
                    publicGroupName = 'IR_Sales Profile Users';
                }
                when 'UMC Requested' {	
                    publicGroupName = 'IR_Production Profile Users';
                }
                when 'MRP Requested' {
                    publicGroupName = 'IR_CSD Profile Users';
                }
                when 'Pricing Entered' {
                    publicGroupName = 'IR_CSD Profile Users';
                }
                when else {
                    publicGroupName = 'IR_Sales Profile Users';
                }
            }
        }
        return publicGroupName;
    }

    /**
    * Method to send send notifications 
    */     
    public static void sendEmailNotification(Id oppId, String status){
        String prodPublicGroupName = 'IR_Production Profile Users';
        List<String> prodToAddresses = getEmailAddresses(prodPublicGroupName);
        try {
            List<Opportunity> oppLst = [SELECT Id, Name, CreatedBy.Name, CreatedBy.Email, Owner.name, Owner.email FROM Opportunity WHERE Id =:oppId];                       
            Opportunity opp = oppLst[0];            
            Contact contact = [SELECT Id FROM Contact LIMIT 1];
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'apc@tandf.co.uk'];
            List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>(); 
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            if ( owea.size() > 0 ) {
                email.setOrgWideEmailAddressId(owea[0].Id);
            }
            email.setTargetObjectId(contact.Id);
            email.setTreatTargetObjectAsRecipient(false);
            email.saveAsActivity = false;
            String[] toAddresses = new String[] {opp.CreatedBy.Email, opp.Owner.email};            
            String bodyStr='<html><body><table width="550" border="0">';
            if(status == 'ReprintEligibility') {
                email.setToAddresses(toAddresses);
                email.setSubject('India Reprint – Reprint Eligibility Status Update');
                bodyStr+='<tr><td>Dear '+ opp.CreatedBy.Name +' , '+ opp.Owner.Name +' <br><br>';
                bodyStr+=' Please note that the opportunity <a href="'+system.url.getSalesforceBaseUrl().toExternalForm() + '/' + oppId +'" target="_blank"><b>'+ opp.Name +'</b></a>';            
                bodyStr+=' has status (PASSED/FAILED/PARTIALLY PASSED) the eligibility criteria.</td></tr>';
                bodyStr+='<tr><td><br>With regards,<br>CSD Team</td></tr>';                
            } else if(status == 'ReprintEligibilityPending') {
                email.setToAddresses(toAddresses);
                email.setSubject('India Reprint - Eligibility Check Pending Notification');
                bodyStr+='<tr><td>Dear '+ opp.CreatedBy.Name +' , '+ opp.Owner.Name +' <br><br>';
                bodyStr+='Please note that the opportunity <a href="'+system.url.getSalesforceBaseUrl().toExternalForm() + '/' + oppId +'" target="_blank"><b>'+ opp.Name +'</b></a>';
                bodyStr+=' eligibility check is pending. We will notify you once eligibility check is done.</td></tr>';
                bodyStr+='<tr><td><br>With regards,<br>CSD Team</td></tr>';                
            }else if(status == 'UMC Requested') {
                email.setToAddresses(prodToAddresses);
                email.setSubject('India Reprint - UMC Requested');
                bodyStr+='<tr><td>Hello,<br><br>';
                bodyStr+='Please note that the opportunity <a href="'+system.url.getSalesforceBaseUrl().toExternalForm() + '/' + oppId +'" target="_blank"><b>'+ opp.Name +'</b></a>';
                bodyStr+=' has been requested for UMC.</td></tr>';
                bodyStr+='<tr><td><br>With regards,<br>CSD Team</td></tr>';                
            } else if(status == 'MRP Requested') {
            	email.setToAddresses(toAddresses);
                email.setSubject('India Reprint - MRP Requested');
                bodyStr+='<tr><td>Dear '+ opp.CreatedBy.Name +' , '+ opp.Owner.Name +' <br><br>';
                bodyStr+='Please note that Production team has provided UMC details for opportunity <a href="'+system.url.getSalesforceBaseUrl().toExternalForm() + '/' + oppId +'" target="_blank"><b>'+ opp.Name +'</b></a>';
                bodyStr+=' and it has been now requested for MRP.</td></tr>';
                bodyStr+='<tr><td><br>With regards,<br>Production Team</td></tr>';                
            } else if (status == 'Pricing Requested') {
                email.setToAddresses(toAddresses);
                email.setSubject('India Reprint - Pricing Requested'); 
                bodyStr+='<tr><td>Dear '+ opp.CreatedBy.Name +' , '+ opp.Owner.Name +' <br><br>';
                bodyStr+='Please note that Pricing has been requested for opportunity  <a href="'+system.url.getSalesforceBaseUrl().toExternalForm() + '/' + oppId +'" target="_blank"><b>'+ opp.Name +'</b></a>';
                bodyStr+='</td></tr>';
                bodyStr+='<tr><td><br>With regards,<br>CSD Team</td></tr>';                 
            } else if (status == 'Pricing Entered') {
                email.setToAddresses(toAddresses);
                email.setSubject('India Reprint - Pricing Entered'); 
                bodyStr+='<tr><td>Dear '+ opp.CreatedBy.Name +' , '+ opp.Owner.Name +' <br><br>';
                bodyStr+='Please note that pricing has been entered for opportunity <a href="'+system.url.getSalesforceBaseUrl().toExternalForm() + '/' + oppId +'" target="_blank"><b>'+ opp.Name +'<b></a>';
                bodyStr+='</td></tr>';
                bodyStr+='<tr><td><br>With regards,<br>CSD Team</td></tr>';                 
            }
            bodyStr+='</table></body></html>';
            email.setHtmlBody(bodyStr);            
            emailList.add(email);            
            Messaging.SendEmailResult [] r = Messaging.sendEmail(emailList);
        } 
        catch(Exception e){
            System.debug('Error'+e.getMessage());
        }
    }

	public static List<String> getEmailAddresses(String pubGroup) {
		List<String> idList = new List<String>();
		List<String> mailToAddresses = new List<String>();
		Group g = [SELECT (select userOrGroupId from groupMembers) FROM group WHERE name =:pubGroup];
		for (GroupMember gm : g.groupMembers) {
			idList.add(gm.userOrGroupId);
		}
		User[] usr = [SELECT email FROM user WHERE id IN :idList];
		for(User u : usr) {
			mailToAddresses.add(u.email);
		}
		return mailToAddresses;
    }
        
    @AuraEnabled
    public static Opportunity getOpportunity(Id oppId) {
        opportunity opp = null;
        try {
            opp = [
                SELECT Id, Name, StageName, Is_Pricing_Request_Sent__c, Is_Reprint_Eligibility_Request_Sent__c, 
                Is_UMC_Request_Sent__c, Is_Reprint_Eligibility_Checked__c, Overall_Reprint_Eligibility__c,
                Is_MRP_Request_Sent__c, Is_Pricing_Entered__c, Is_Approved__c, Is_GMOverride_Done__c
                FROM opportunity WHERE Id =:oppId
            ];            
        } catch(Exception ex) {
            System.debug(ex.getMessage());
        }
        return opp;
    }
    
    //seems not in use
    @AuraEnabled
    public static String getProductName(String productID){
        String productName ;
        List<Product2> prdLst = new List<Product2>();
        prdLst = [Select Id,Name From Product2 where id =:productID] ;        
        if(prdLst.size() > 0){
            Product2 prd = prdLst[0]; 
            productName = prd.Name ;
        }        
        return productName ;
    }
    
    //seems not in use
    @AuraEnabled
    public static list<opportunity> getOppList(){   
        Id oppRT = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');
        list<opportunity> opps = new list<opportunity>([select Id, Name, AccountId, probability, stageName from opportunity WHERE RecordType.Id =:oppRT]);
        return opps;
    }     
}