public with sharing class TFOAC_AddExistingJournalController {

	private TFOAC_Opportunity__c currentOpportunity;
	private Map<ID,TFOAC_Journal__c> mapOfProducts{get;set;}
	public List<TFOAC_Journal__c> listOfProducts{get;set;}
	public Map<Id,ProductWithPriceBookEntry> productSearchMap {get;set;}
	public String productNameToSearch{get;set;}
	public Integer recordsOnPage{get;set;}
	public TFOAC_AddExistingJournalController(ApexPages.StandardController std) {
		recordsOnPage = 10;
		if(ApexPages.currentPage().getParameters().containsKey('id')){
			
			currentOpportunity = [Select Id,Host_Areas__c,CurrencyIsoCode From TFOAC_Opportunity__c where id =: ApexPages.currentPage().getParameters().get('id')];
		}else{
			currentOpportunity = null;
		}
		mapOfProducts = new Map<ID,TFOAC_Journal__c>();
        productSearchMap = new Map<Id,ProductWithPriceBookEntry>();
        listOfProducts = new List<TFOAC_Journal__c>();
        setCon = new ApexPages.StandardSetController(listOfProducts);
        system.debug('set controller is set to '+setCon);
        system.debug('set controller is set to 1 '+listOfProducts);
	}

	public void searchProducts(){
        mapOfProducts = new Map<ID,TFOAC_Journal__c>();
        productSearchMap = new Map<Id,ProductWithPriceBookEntry>();
        listOfProducts = new List<TFOAC_Journal__c>();
        String phaseToSearch = '%'+productNameToSearch+'%';
        Id productRecordType = Schema.SObjectType.TFOAC_Journal__c.getRecordTypeInfosByName().get('T&F OAC').getRecordTypeId();
        Map<Id,List<PricebookEntry>> productPriceBookEntries = new Map<Id,List<PricebookEntry>>();
        for(TFOAC_Journal__c prod : [Select id,Host_AreaCode__r.Name,Name,AcqType__c,OACOpportunity__c,OACOpportunity__r.Host_Areas__c,CurrencyIsoCode From TFOAC_Journal__c where Name like :phaseToSearch and RecordTypeId =:productRecordType AND OACOpportunity__c = NULL order by Name desc Limit 400]){
            
            mapOfProducts.put(prod.id,prod);
            listOfProducts.add(prod);
            String msg = 'ok';
            System.debug(LoggingLevel.ERROR,'check opportunity: '+currentOpportunity);
            System.debug(LoggingLevel.ERROR,'check opportunity 1: '+prod);
            if(currentOpportunity.Host_Areas__c != null && (currentOpportunity.Host_Areas__c != 'Multiple Host Areas' && currentOpportunity.Host_Areas__c != 'Digital Content') && prod.Host_AreaCode__r != null &&  prod.Host_AreaCode__r.Name != null && !currentOpportunity.Host_Areas__c.containsIgnoreCase(prod.Host_AreaCode__r.Name)){
                msg = 'Host area for the Journal must match the Host area for the Opportunity:'+currentOpportunity.Host_Areas__c;
            }
            
            if(currentOpportunity.Host_Areas__c != null && (currentOpportunity.Host_Areas__c != 'Multiple Host Areas' && currentOpportunity.Host_Areas__c == 'Digital Content') &&  prod.AcqType__c != null && !currentOpportunity.Host_Areas__c.containsIgnoreCase(prod.AcqType__c)){
                msg = 'Journal need to be in Digital Content contract type';
        	}
            
        	productSearchMap.put(prod.id,new ProductWithPriceBookEntry(msg,false));
            
            
            //productPriceBookEntries.put(prod.id,prod.PricebookEntries);
        }
        setCon = new ApexPages.StandardSetController(listOfProducts);

        
    }

    public PageReference addJournals(){
        Boolean defaultPricbookSet = false;
        List<TFOAC_Journal__c> productsToAling = new List<TFOAC_Journal__c>();
        for(Id prodId : productSearchMap.keySet()){
            if(productSearchMap.get(prodId).selectedToAdd){
            	mapOfProducts.get(prodId).OACOpportunity__c = currentOpportunity.id;
            	mapOfProducts.get(prodId).CurrencyIsoCode = currentOpportunity.CurrencyIsoCode;
                productsToAling.add(mapOfProducts.get(prodId));
           }
       }
       update productsToAling;
       ApexPages.StandardController oppController = new ApexPages.StandardController(currentOpportunity);
       return oppController.view();
        
    }

	/*******************************************************************
    @Purpose:  StandardSetContoller responsible for handling pagination
               for workshops
    ********************************************************************/
    public ApexPages.StandardSetController setCon{
        
        get{
            if(setCon == null){
                setCon = new ApexPages.StandardSetController(listOfProducts);
            }
            
            setCon.setPageSize(recordsOnPage);
            return setCon;
        }
        set;
    }
    
    /*******************************************************************
    @Purpose:  Return ProductWithPriceBookEntry for current page
    ********************************************************************/
    public List<TFOAC_Journal__c> getListOfExistingProducts(){
        return (List<TFOAC_Journal__c>)setCon.getRecords();
    }
    
    /*******************************************************************
    @Purpose:  Navigate to next page of Products  
    ********************************************************************/
    public void next(){ 
        setCon.next();
    }
    
    /*******************************************************************
    @Purpose:  Navigate to previous page of Product records
    ********************************************************************/
    public void previous(){
        setCon.previous();
    }
    
    /*******************************************************************
    @Purpose: Navigate to first page of Product records
    ********************************************************************/
    public void first(){
        setCon.first();
    }
    
    /*******************************************************************
    @Purpose: Navigate to last page of Product records
    ********************************************************************/
    public void last(){
        setCon.last();
    }
    
    /*************************************************************************
    @Purpose: Indicates whether there are more records after current Product 
              page
    *************************************************************************/
    public Boolean hasNext{
        get{ 
            return setCon.getHasNext(); 
        }    
    }
    
    /**************************************************************************
    @Purpose:  Indicates whether there are more records before current Product 
              page
    ***************************************************************************/
    public Boolean hasPrevious{
       get{  
           return setCon.getHasPrevious();    
       }    
    }
    
    /*******************************************************************
    @Purpose: Return total number of Product records in set
    ********************************************************************/
    public Integer getNumberOfRecords(){
        return setCon.getResultSize();
    }
    
    /*******************************************************************
    @Purpose: Return the page number of Product Workshop page
    ********************************************************************/
    public Integer getPageNumber(){
        return setCon.getPageNumber();
    }
    
    /*******************************************************************
    @Purpose: Return total number of pages for Product
    ********************************************************************/
    public Integer getTotalPages(){
        Integer numOfRecords=setCon.getResultSize();
        Integer totalPages= Math.mod(numOfRecords, recordsOnPage) > 0 ? Integer.valueOf(Math.floor(numOfRecords/recordsOnPage)+1) : Integer.valueOf(numOfRecords/recordsOnPage);
        return totalPages;
        
    }
    //Add existing product functionality with standard set controller support
    
    public class ProductWithPriceBookEntry{
        public String message{get;set;}
        public Boolean selectedToAdd{get;set;}
        
        public ProductWithPriceBookEntry(String str, Boolean b){
            this.message = str;
            this.selectedToAdd = false;
        }
        
    }
}