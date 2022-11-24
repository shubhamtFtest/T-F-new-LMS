/******************************************************************
* Tests: zTEST_TF_IndiaRePrintCloneOpportunity             100%
*******************************************************************/

@isTest
private class zTEST_TF_IndiaRePrintCloneOpportunity {
    static testMethod void testCloneOpportunity() {   
        test.startTest();
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry();

        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(pbe.Id, opp.Id, 'Created');
        oli.Recipient__c = c.Id;
        insert oli; 
        TF_IndiaRePrintCloneOpportunity.cloneOpportunity(opp.Id);
		test.stopTest();
    }
    
    @testSetup
    public static void createTestData() {
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newParentProduct = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);
        newParentProduct.name='test';
        newParentProduct.IsActive=true;
        newParentProduct.Description='test';
        newParentProduct.RecordTypeId=productRecordtypeId;
        newParentProduct.ProductCode='9780367463151';
        newParentProduct.keywords__c='';
        newParentProduct.Popular_Formats__c	= '5.5 X 8.5';
        newParentProduct.Format_Height_mm__c = 100;
        newParentProduct.Format_Width_mm__c	= 200;
        newParentProduct.Text_Colour__c	= 'Mono';
        newParentProduct.Paper_Type__c	= 'Hadback';       
        newParentProduct.UMC__c	= 5;       	
        newParentProduct.Date_of_Last_UMC__c = startDate;	        
        newParentProduct.Last_UMC_Popular_Formats__c = '5.5 X 8.5';	        
        newParentProduct.Last_UMC_Format_Height_mm__c = 100;	        
        newParentProduct.Last_UMC_Format_Width_mm__c = 200;	        
        newParentProduct.Last_UMC_Version_Type__c = 'Hadback';	
        newParentProduct.Last_UMC_Text_Colour__c = 'Mono';	
        newParentProduct.Last_UMC_Paper_Type__c	= '80gsm';
        newParentProduct.Last_UMC_Quantity__c = 5;
        newParentProduct.Last_UMC_Customer_Quote__c	= 500;       
        insert newParentProduct;
    }    
}