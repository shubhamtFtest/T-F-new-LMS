public without sharing class Account_UpdatePartyId_Trig implements TriggerInterface_Account.Runnable {
    public void run(TriggerInterface_Account.Trig trig) {
        if (trig.isBefore && trig.isInsert) {
            integer qtyNeeded = trig.newList.size();
            List<integer> partyIds = PartyIdIncrementer.getNextPartyId(qtyNeeded);
            for (integer i=0; i < qtyNeeded; i++) {
                if(String.isEmpty(trig.newList[i].Customer_Id__c)) {
                   trig.newList[i].Customer_Id__c  = string.valueOf(partyIds[i]); 
                }
            }
            
            //logic implemented for SAL-5111 By Shanu Kumar  before Insert few fields value will populate if record type is an Account Request Type
            String accountRqRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account Request').getRecordTypeId();
            for(Account acc: trig.newList){
                if(acc.recordtypeId == accountRqRecTypeId){
                    acc.Billing_Region__c = acc.Billing_State__c!=null?acc.Billing_State__c:null;
                    acc.Shipping_Region__c = acc.ShippingState!=null?acc.ShippingState:null;
                }
            }
           //logic ends for SAL-5111
        }
    }
}