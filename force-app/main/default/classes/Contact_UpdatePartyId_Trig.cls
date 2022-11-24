public without sharing class Contact_UpdatePartyId_Trig implements TriggerInterface_Contact.Runnable {
    public void run(TriggerInterface_Contact.Trig trig) {
        if (trig.isBefore && trig.isInsert) {
            integer qtyNeeded = trig.newList.size();
            List<integer> partyIds = PartyIdIncrementer.getNextPartyId(qtyNeeded);
            for (integer i=0; i < qtyNeeded; i++) {
                if(trig.newList[i].Party_Id__c == null || trig.newList[i].Party_Id__c == ''){
                    trig.newList[i].Party_Id__c  = string.valueOf(partyIds[i]);
                }
            }
        }
    }
}