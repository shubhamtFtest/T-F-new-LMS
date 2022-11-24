@isTest 
private class zTEST_SetLocaleSalesRegionByCountry {  

    public static testmethod void test_setLead() {
    
        Lead lead1 = new Lead(
            //Country='US',
            Country_List__c='United States',
            //State = 'FL',
            State_List__c='Florida'
        );
        
        SetLocaleSalesRegionByCountry.setLead(new Lead[]{lead1}, 'CAS');
        
        // make sure the values where changed correctly
        //System.assertEquals(lead1.Country,lead1.Country_List__c);
        //System.assertEquals(lead1.State,lead1.State_List__c); 
        
    }  
}