/******************************************************************
* Tests: zTEST_TF_IRP_DeleteOLIHistory_Trig             100%
*******************************************************************/


@isTest
private class zTEST_TF_IRP_DeleteOLIHistory_Trig {
    
    static testMethod void testMetho1() {   
        String priceBookName = 'T&F India Pricebook';
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');       
        Product2 prdObj = createProductTestData();
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> priceBEList = new List<PricebookEntry>();
        PricebookEntry priceBE1 = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, 
            										  Product2Id = prdObj.Id, UnitPrice = 100.00
                                                    );                                  
        priceBEList.add(priceBE1);                              
        insert priceBEList;
        
        Pricebook2 priceBook2 = new Pricebook2(Name = priceBookName, IsActive = True);
        insert priceBook2;
        
        List<PricebookEntry> priceBEList2 = new List<PricebookEntry>();
        PricebookEntry priceBE2 = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = priceBook2.Id, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00);                                            
        priceBEList2.add(priceBE2);                              
        insert priceBEList2;
        
        
        TriggerInterfaceHelper.runTrigger('TF_IRP_DeleteOLIHistory_Trig', 'OpportunityLineItem', 99, 'ad', oppRecordtypeId, null);
        
        try {
            List<OpportunityLineItem> lstOLIInsert = new List<OpportunityLineItem>();         
            OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                												PricebookEntryId = priceBEList2[0].Id, IR_Product_Type__c = 'Rerun'
                                                             );
            lstOLIInsert.add(oli);               
            insert lstOLIInsert;  
            
			//create OLIHistory record
            OLIHistory__c OLIHistoryObj = new OLIHistory__c();
            Date startDate = date.newInstance(2020, 02, 20);        
            OLIHistoryObj.Is_Approved_UMC__c = true;
            OLIHistoryObj.OpportunityId__c = opp.Id;
            OLIHistoryObj.OpportunityLineItemId__c = oli.Id;
            OLIHistoryObj.UMC__c = 4.2;
            OLIHistoryObj.MRP__c = 100;
            OLIHistoryObj.Customer_Quote__c = 100;
            OLIHistoryObj.Gross_Margin__c = 2;
            OLIHistoryObj.Text_Color__c = 'Mono';
            OLIHistoryObj.Paper_size__c = 564;
            OLIHistoryObj.Paper_GSM__c = '80gsm';
            OLIHistoryObj.Date_of_Last_UMC__c = startDate;
            OLIHistoryObj.Version_Type__c = 'Paperback';
            OLIHistoryObj.Quantity__c = 5;
            OLIHistoryObj.Popular_Formats__c = '5.5 X 8.5';
            OLIHistoryObj.Format_Height_mm__c = 100;
            OLIHistoryObj.Format_Width_mm__c =200;       
            insert OLIHistoryObj;
            
            //delete opportunity line item
            delete oli;            
        }
        catch(Exception ex) {
            system.debug('Exception::'+ex.getMessage());
        }
    }
 
    private static Product2 createProductTestData() {
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 product = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);
        product.name='test';
        product.IsActive=true;
        product.Description='test';
        product.RecordTypeId=productRecordtypeId;
        product.ProductCode='9780367463151';       
        insert product;
        return product;
    }     
}