public without sharing class Department_UpdatePartyId_Trig implements TriggerInterface_Department.Runnable {
    public void run(TriggerInterface_Department.Trig trig) {
        if (trig.isBefore && trig.isInsert) {
            integer qtyNeeded = trig.newList.size();
            List<integer> partyIds = PartyIdIncrementer.getNextPartyId(qtyNeeded);
            for (integer i=0; i < qtyNeeded; i++) {
                trig.newList[i].Party_Id__c  = string.valueOf(partyIds[i]);
            }
        }
    }
}