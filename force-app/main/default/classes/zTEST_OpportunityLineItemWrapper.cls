/******************************************************************
* Tests: zTEST_OpportunityLineItemWrapper             100%
*******************************************************************/

@isTest
private class zTEST_OpportunityLineItemWrapper {
    private static testmethod void testOpportunityLineItemWrapper(){
        OpportunityLineItemWrapper wrapper= new OpportunityLineItemWrapper();
        wrapper.Id = 'Test Wrapper';
        wrapper.isActive = true;      
        wrapper.productName = 'Test';        
        wrapper.globalISBN = '123';        
        wrapper.indiaISBN = '456';            
        wrapper.type = 'Test';        
        wrapper.productType = 'product Type';            
        wrapper.requiredBinding = 'Paperback';        
        wrapper.unitPrice = 100;        
        wrapper.quantity = 100;        
        wrapper.listPrice = 100;        
        wrapper.mrp = 100;            
        wrapper.UMC = 4.5;        
        wrapper.dateofLastUMC = Date.today();        
        wrapper.discount = 50;        
        wrapper.totalPrice = 200;        
        wrapper.reprintEligibility = 'Pass';        
        wrapper.status = 'status';        
        wrapper.distributor = 'distributor id';
        wrapper.isSalesUser = true;        
        wrapper.isApproved = true;       
        wrapper.showClass = 'TestWrapperClass'; 
    }    
}