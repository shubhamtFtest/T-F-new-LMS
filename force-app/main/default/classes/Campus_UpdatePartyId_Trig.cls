public without sharing class Campus_UpdatePartyId_Trig implements TriggerInterface_Campus.Runnable {
    public void run(TriggerInterface_Campus.Trig trig) {
        if (trig.isBefore && trig.isInsert) {
            integer qtyNeeded = trig.newList.size();
            List<integer> partyIds = PartyIdIncrementer.getNextPartyId(qtyNeeded);
            for (integer i=0; i < qtyNeeded; i++) {
                trig.newList[i].Party_Id__c  = string.valueOf(partyIds[i]);
            }
        }
    }
}