/**************************************************************
* Created by Shay Spoonmore (shay.spoonmore@informausa.com)
* Last Modified by Jeff Lup (jeff.lup@informausa.com) - 2010.06.17
* Last Modified by shay.spoonmore@informausa.com - 2011.04.25
* Last Modified by Jeff Lup - Greenfield project
* Last Modified by Hailey Niemand - CHG0053289 - 2013.09.25
* Last Modified by Hailey Niemand - CHG0053969 - 2014.02.07
* Last Modified by Hailey Niemand - Use trigger record type object to enable trigger and manage which version to run - 2014.02.19
**************************************************************/

trigger CountryContactTrigger on Contact (before insert, before update) {

    /* Hailey Niemand - 2014.02.19
    Set<ID> cRecordTypes = new Set<ID>{
        '01260000000DXruAAG' //CAS - Contacts
        ,'01260000000DKEIAA4' //Omega - Contacts (Shay Spoonmore - 2009.05.05)
        ,'01260000000DJBwAAO' //Huthwaite - Contacts (Case 9651 - Jeff Lup - 2009.08.06)
        //,'01230000000DHb9AAG' //ESI - Contact Record Type (Case 14672 - Jeff Lup 2010.03.11) (disabled per Case 20867 - Jeff Lup 2010.04.29)
        //,'01260000000DJa8AAG' //ESI - Inside Sales/TAD Contact (Case 14672 - Jeff Lup 2010.03.11) (Disabled per Case 19747 - Jeff Lup 2010.04.15)
        ,'01260000000DVb3' //IBI Academic - Contacts (Case 15432 - Shay Spoonmore 2010.04.27)        
        ,'01260000000DVb8' //IBI Commercial - Contacts (Case 15432 - Shay Spoonmore 2010.04.27)
        ,'01260000000Dcsg' //IBI Agra Spex - Contact (Case 15432 - Shay Spoonmore 2010.04.28)
        ,'01260000000DKBO' //Forum - Contact (Case 25551 - Jeff Lup - 2010.06.17)
        ,'01260000000DJ5ZAAW'//AchieveGlobal - Contact (CASE 38135 Shay Spoonmore 2011.04.25)
        ,'01260000000DJDsAAO' //IIR UK Exhbitions - Contacts (CHG0053289 Hailey Niemand 2013.09.25)
        };
        
        Set<Id> otherRtIds = MiscFunctions.getRecordtypeIds('Contact', 'Greenfield Contacts');
        
        Set<ID> itmRecordTypes = new Set<ID>{ //CHG0053969 
            '01260000000DYv9AAG' //ITM Contact
            ,'01260000000J14oAAC' //Ovum Contacts 
        };
        
    // no bulk processing; will only run from the UI since a manual "copy" process
    if (Trigger.new.size() == 1) {
        
        for (Contact c : Trigger.new) {
            
            if (cRecordTypes.contains(c.RecordTypeId) || otherRtIds.contains(c.RecordTypeId)) {
                CopyCountryFromPickList.ContactCountry(Trigger.new); 
            
            //CHG0053969 ITM Contacts and Ovum Contacts
            } else if (itmRecordTypes.contains(c.RecordTypeId)) {
                //MAILING ADDRESS         
                if ((trigger.isInsert || c.Mailing_Country_List__c != trigger.old[0].Mailing_Country_List__c) && c.Mailing_Country_List__c != null) {
                    c.MailingCountry = c.Mailing_Country_List__c;
                    }
                
                if ((trigger.isInsert || c.Mailing_State_List__c != trigger.old[0].Mailing_State_List__c) && c.Mailing_State_List__c != null) {
                    c.MailingState = c.Mailing_State_List__c;
                }
            }
        }
    }   
    */
    
    Map<Id,Map<String,String>> mapRtsToRun = MiscFunctions.triggerEnabledRecordtypesWithParams('CountryContactTrigger');
    if (mapRtsToRun.containsKey(trigger.new[0].recordtypeid)) {
    
        // no bulk processing; will only run from the UI since a manual "copy" process
        if (Trigger.new.size() == 1) {
            
            for (Contact c : Trigger.new) {
                
                string business = mapRtsToRun.get(c.recordtypeid).get('Business');
                
                if (business == null || business == 'Other') {
                    CopyCountryFromPickList.ContactCountry(Trigger.new); 
                
                //CHG0053969 ITM Contacts and Ovum Contacts
                } else if (business == 'ITM') {
                    //MAILING ADDRESS         
                    if ((trigger.isInsert || c.Mailing_Country_List__c != trigger.old[0].Mailing_Country_List__c) && c.Mailing_Country_List__c != null) {
                        c.MailingCountry = c.Mailing_Country_List__c;
                        }
                    
                    if ((trigger.isInsert || c.Mailing_State_List__c != trigger.old[0].Mailing_State_List__c) && c.Mailing_State_List__c != null) {
                        c.MailingState = c.Mailing_State_List__c;
                    }
                }
            }
        }       
    }
}