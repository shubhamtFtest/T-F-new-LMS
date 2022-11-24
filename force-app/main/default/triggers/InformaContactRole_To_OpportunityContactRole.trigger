trigger InformaContactRole_To_OpportunityContactRole on Informa_Contact_Role__c (after delete, after insert, after undelete, after update) {
    
    //@@ CHG0031775 : Set public variable true to avoid execution of opportunity trigger on rollup
    System.Debug('PublicVariables.Opp_StageUpdatedThroughCode : '+PublicVariables.Opp_StageUpdatedThroughCode);
    if(Trigger.isInsert || Trigger.isDelete || Trigger.isUnDelete ){
        PublicVariables.Opp_StageUpdatedThroughCode =true;
    }
    Set<Id> rtsToRun = MiscFunctions.triggerEnabledRecordtypes('InformaContactRole_To_OpportunityContactRole');
    Set<Id> oppIds = new Set<Id>();
    for (integer i = 0; i < trigger.size; i++) {
        if (rtsToRun.contains(trigger.isDelete ? trigger.old[i].RecordTypeId : trigger.new[i].RecordTypeId))
            oppIds.add(trigger.isDelete ? trigger.old[i].Opportunity__c : trigger.new[i].Opportunity__c);
    }
    if (oppIds.size() > 0) {
        //Delete existing OpportunityContactRole records
        List<OpportunityContactRole> ocrsToDelete = [SELECT Id FROM OpportunityContactRole WHERE OpportunityId IN :oppIds];
        delete ocrsToDelete;
        //Insert OpportunityContactRole records to match Informa_Contact_Role__c records
        List<Informa_Contact_Role__c> icrs = [SELECT Opportunity__c, Contact__c, Contact_Role_s__c, Primary_Contact__c
                                              FROM Informa_Contact_Role__c
                                              WHERE Opportunity__c IN :oppIds];
        if (icrs.size() > 0) {
            List<OpportunityContactRole> ocrsToInsert = new List<OpportunityContactRole>();
            for (Informa_Contact_Role__c icr : icrs) {
                if (icr.Contact_Role_s__c == null) {
                    trigger.new[0].addError('Please specify at least one role');
                } else {
                    List<String> roles = icr.Contact_Role_s__c.split(';', 0);
                    for (String role : roles) {
                        OpportunityContactRole ocr = new OpportunityContactRole();
                        ocr.OpportunityId = icr.Opportunity__c;
                        ocr.ContactId = icr.Contact__c;         
                        ocr.Role = role.trim();
                        ocr.IsPrimary = icr.Primary_Contact__c;
                        ocrsToInsert.add(ocr);
                    }
                }
            }
            if (ocrsToInsert.size() > 0)
                insert ocrsToInsert;
        }
    }
}