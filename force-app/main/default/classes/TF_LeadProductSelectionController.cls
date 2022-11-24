/*
*
* Created by Jeff Lup - 2014.11.19 - CHG0060297
*
*/

public class TF_LeadProductSelectionController {
    private ApexPages.StandardController controller {get; set;}
    private final Lead l;
    private map<Id, String> mapProducts = new map<Id, String>();
    private list<SelectOption> pOptions;
    private Id pricebook2Id;
    
    public TF_LeadProductSelectionController (ApexPages.StandardController controller){
        this.controller = controller;
        //this.l = (Lead)controller.getRecord();
        this.l = [SELECT Id, Product_Name__c, Product_Name__r.Name, RecordTypeId FROM Lead WHERE Id = :ApexPages.currentPage().getParameters().get('id')]; 
        tfProductId = l.Product_Name__c;
        tfProductName = l.Product_Name__r.Name;
        pricebook2Id = getPricebook2Id();
    }
  
    public List<SelectOption> gettfProducts() {
        if (pOptions == null) {
            pOptions = new list<SelectOption>();
            pOptions.add(new SelectOption('','----NONE----'));
            list<PricebookEntry>pbeList = [SELECT Product2.Id, Product2.Name
                                              FROM PricebookEntry
                                              WHERE Pricebook2Id = :pricebook2Id
                                                AND Pricebook2.IsActive = true
                                                AND Product2.IsActive = true
                                                AND PricebookEntry.IsActive = true
                                                AND CurrencyIsoCode = 'USD' //This is temporary, actual PBE is chosen after save of Opp
                                              ORDER BY Product2.Name];
            for (PricebookEntry pbe : pbeList) {
                pOptions.add(new SelectOption(pbe.Product2.Id, pbe.Product2.Name));
                mapProducts.put(pbe.Product2.Id, pbe.Product2.Name);
            } 
        }
        return pOptions;
    }
    
    private Id getPricebook2Id() {
        String leadRecordtypeName = [SELECT Name FROM Recordtype WHERE Id = :l.RecordTypeId].Name;
        if (leadRecordtypeName == 'T&F - Leads') {
             return [SELECT Id FROM Pricebook2 WHERE Name = 'T&F Journals Price Book'].Id; //'01s6000000063zlAAA'
        } else if (leadRecordtypeName == 'T&F - Leads') {
            return [SELECT Id FROM Pricebook2 WHERE Name = 'T&F - eBooks Pricebook'].Id; //'01s600000006DDMAA2'
        } else {
            return '';
        }
    }
  
    public Boolean isEditMode {
        get {
          if (isEditMode == null)
            isEditMode = false;
          return isEditMode;   
        }
        set;
    }
    
    public Boolean isDisplayMode {
        get {
          return !isEditMode;   
        }
        set;
    }  

    public String tfProductId {
        get {
          if (tfProductId == null)
            tfProductId = '';
          return tfProductId;   
        }
        set;
    }
  
    public String tfProductName {
        get {
          if (tfProductName == null)
            tfProductName = '';
          return tfProductName;   
        }
        set;
    }
    
    public Pagereference changeProduct() {
        isEditMode = true;
        return null;
    }
    
    public Pagereference updateProduct() { 
        //page to refresh to display latest parent opportunity value
        PageReference pr = ApexPages.CurrentPage();
        pr.setRedirect(true);
    
        if (tfProductId != null && tfProductId != '') {
            tfProductName = mapProducts.get(tfProductId);
            l.Product_Name__c = tfProductId;
            update l;
        } else {
            tfProductName = '';
            l.Product_Name__c = null;
            update l;
        }
        //leave edit mode
        isEditMode = false;
        
        //return null;
        return pr;
    }
    
    public Pagereference cancel() {
        isEditMode = false;
        return null;
    }  

}