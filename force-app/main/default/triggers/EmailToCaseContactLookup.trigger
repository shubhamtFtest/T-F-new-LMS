/**************************************************
* Created by Jeff Lup - 2010.01.26 - 
*   EmailToCase searches all contacts in the database
*   when looking for an email address match.  We need
*   it to only find matches from the correct business.
* Modified by Jeff Lup - 2013.09.12 - CTASK0036214 - 
*   Commented out 2 of the IBI recordtypes because they
*   are also in EmailToCaseContactLookup_Bulk
**************************************************/

trigger EmailToCaseContactLookup on Case (before insert) {
    //no bulk processing, trigger only on an single incoming email
    if (Trigger.new.size() == 1) {
        
        //Recordtpes for which this trigger should run...
        Set<ID> CaseRecordtypes = new Set<ID>{//'01260000000DZtcAAG' //IBI - Case
                                             '01260000000HxMpAAK' //IBI - LLI Analyst
                                             //,'01260000000Det7AAC' //IBI - Pharma case
                                             ,'01260000000DKZfAAO' //IBI - Healthcare Case
                                             //,'01260000000J2k3AAC' //T&F – CSD
                                             //,'01260000000J2m4AAC' //T&F – CSD eBooks
                                             //,'012g000000007q4AAA'//T&F – CSD eBooks UAT
                                             };     
        
        //We're only looking for cases created by EmailToCase
        if (CaseRecordtypes.contains(Trigger.new[0].RecordTypeId) && Trigger.new[0].Origin == 'Email' && Trigger.new[0].Status == 'New') 
        {
            System.debug('This is a new case created by EmailToCase.');

            if (Trigger.new[0].RecordTypeId == '01260000000DZtcAAG' || Trigger.new[0].RecordTypeId == '01260000000DKZfAAO' || Trigger.new[0].RecordTypeId == '01260000000HxMpAAK' || Trigger.new[0].RecordTypeId == '01260000000Det7AAC') { //"IBI - Case" & "IBI - Healthcare Case" &"IBI - Pharma" & "IBI - LLI Analyst" 
                Set<ID> ContactRecordtypes = new Set<ID>{'01260000000DVb3AAG','01260000000DVb8AAG'}; //"IBI Academic - Contacts" & "IBI Commercial - Contacts"
                Contact[] contacts = [SELECT Id FROM Contact WHERE Email = :Trigger.new[0].SuppliedEmail AND RecordTypeId IN :ContactRecordtypes limit 2];
                if (contacts.size() == 1) {
                    System.debug('One contact found from the correct recordtype.  Case will be updated with this contact.');
                    Trigger.new[0].ContactId = contacts[0].Id;
                } else {
                    System.debug('No contact (or more than one contact) was found from the correct recordtype.  Contact will be removed from the case so the user may select the correct one.');
                    Trigger.new[0].ContactId = null;
                }
            
            } else if (Trigger.new[0].RecordTypeID == '01260000000J2k3AAC' || Trigger.new[0].RecordTypeID == '01260000000J2m4AAC') { //TF Case Record Types //RQ - '012g000000007q4AAA' T&F - CSD eBooks to be replaced with '01260000000J2m4AAC' T&F - CSD eBooks for Production
                Set<ID> ContactRecordtypes = new Set<ID> {'01260000000J2hmAAC'}; // T&F - Online Contacts
                Contact[] contacts = [SELECT Id FROM Contact WHERE Email = :Trigger.new[0].SuppliedEmail AND RecordTypeId IN :ContactRecordtypes limit 2];
                if (contacts.size() == 1) {
                    System.debug('One contact found from the correct recordtype.  Case will be updated with this contact.');
                    Trigger.new[0].ContactId = contacts[0].Id; 
                } else {
                    System.debug('No contact (or more than one contact) was found from the correct recordtype.  Contact will be removed from the case so the user may select the correct one.');
                    Trigger.new[0].ContactId = null;
                }
            }
        }
    }
}