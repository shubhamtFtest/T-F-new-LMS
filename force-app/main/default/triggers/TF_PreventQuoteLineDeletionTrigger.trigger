trigger TF_PreventQuoteLineDeletionTrigger on SBQQ__QuoteLine__c (before delete, after update, after delete, after insert) {
    /*if(Trigger.isDelete && Trigger.isBefore) {
            Set<Id> quotelineSet =Trigger.OldMap.keyset();
            TF_PreventQuoteLineDelTrigHandler.preventQuoteLineDeletion(quotelineSet);
     }*/
    
    if(Trigger.isUpdate && Trigger.isAfter) {
            TF_PreventQuoteLineDelTrigHandler.updateSocietyManualCheck(Trigger.new);
     }
    
    if(Trigger.isDelete && Trigger.isAfter) {
            TF_PreventQuoteLineDelTrigHandler.updateSocManualCheckAfterDel(Trigger.old);
     }
    
    if(Trigger.isInsert && Trigger.isAfter) {
            TF_PreventQuoteLineDelTrigHandler.updateJournalFieldOnQuote(Trigger.new);
     }
}