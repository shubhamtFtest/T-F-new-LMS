/**************************************************************
* Created by Shay Spoonmore (shay.spoonmore@informausa.com)
* Last Modified by Jeff Lup (jeff.lup@informausa.com) - 2010.06.17
* Last Modified by shay.spoonmore@informausa.com - 2011.04.25
* Last Modified by Jeff Lup - Greenfield project
* Last Modified by Hailey Niemand - CHG0053289 - 2013.09.25
* Last Modified by Hailey Niemand - CHG0053969 - 2014.02.07
* Last Modified by Hailey Niemand - Use trigger record type object to enable trigger and manage which version to run - 2014.02.19
**************************************************************/

trigger CountryLeadTrigger on Lead (before insert, before update) {

/*       
    Set<ID> lRecordTypes = new Set<ID>{
        '01260000000DYvAAAW' //ITM Lead V2.0
        ,'01260000000DXrVAAW' //CAS - Leads
        ,'01260000000DKDeAAO' //Omega - Leads (Shay Spoonmore - 2009.05.05)
        ,'01260000000DJBcAAO' //Huthwaite - Leads (Case 9651 - Jeff Lup - 2009.08.06)
        //,'01230000000DHVQAA4' //ESI - Leads (Case 14672 - Jeff Lup 2010.03.11) (disabled per Case 20867 - Jeff Lup 2010.04.29)
        ,'01260000000DKB4' //Forum - Leads (Case 25551 - Jeff Lup - 2010.06.17)
        ,'01260000000DJ5KAAW'//AchieveGlobal - Leads (CASE 38135 Shay Spoonmore 2011.04.25)
        ,'01260000000DJDiAAO' //IIR UK Exhbitions - Leads (CHG0053289 Hailey Niemand 2013.09.25)
        };
        
    Set<Id> otherRtIds = MiscFunctions.getRecordtypeIds('Lead', 'Greenfield Leads');
    
    Set<ID> itmRecordTypes = new Set<ID>{ //CHG0053969 
        '01260000000JGO6AAO' //Ovum - Leads (Sales) 
        ,'01260000000JGNwAAO' //ITM - Leads (Sales) 
    };
        
    
    // no bulk processing; will only run from the UI
    if (Trigger.new.size() == 1) {  
        
        if (lRecordTypes.contains(Trigger.new[0].RecordTypeId) || otherRtIds.contains(Trigger.new[0].RecordTypeId)) {      
            CopyCountryFromPickList.LeadCountry(Trigger.new);
            
            //Set locales is only setup for CAS at the moment
            if (Trigger.new[0].RecordTypeId == '01260000000DXrVAAW')
                SetLocaleSalesRegionByCountry.setLead(Trigger.new, 'CAS'); 
        
        //CHG0053969 ITM - Leads (Sales) or Ovum - Leads (Sales)
        } else if (itmRecordTypes.contains(Trigger.new[0].RecordTypeId)) {
            if ((trigger.isInsert || Trigger.new[0].Country_List__c != trigger.old[0].Country_List__c) && Trigger.new[0].Country_List__c != null) {
                Trigger.new[0].Country = Trigger.new[0].Country_List__c;
            }      
            
            if ((trigger.isInsert || Trigger.new[0].State_List__c != trigger.old[0].State_List__c) && Trigger.new[0].State_List__c != null) {
                Trigger.new[0].State = Trigger.new[0].State_List__c;
            }
        }
    }     
*/

Map<Id,Map<String,String>> mapRtsToRun = MiscFunctions.triggerEnabledRecordtypesWithParams('CountryLeadTrigger');
    if (mapRtsToRun.containsKey(trigger.new[0].recordtypeid)) {

    // no bulk processing; will only run from the UI
        if (Trigger.new.size() == 1) {  
        
            string business = mapRtsToRun.get(trigger.new[0].recordtypeid).get('Business');
            
            if (business == null || business == 'Other') {
                CopyCountryFromPickList.LeadCountry(Trigger.new);
                
            } else if (business == 'CAS') {
                CopyCountryFromPickList.LeadCountry(Trigger.new);
                //Set locales is only setup for CAS at the moment
                SetLocaleSalesRegionByCountry.setLead(Trigger.new, 'CAS'); 
            
            } else if (business == 'ITM') {
                if ((trigger.isInsert || Trigger.new[0].Country_List__c != trigger.old[0].Country_List__c) && Trigger.new[0].Country_List__c != null) {
                    Trigger.new[0].Country = Trigger.new[0].Country_List__c;
                }      
                
                if ((trigger.isInsert || Trigger.new[0].State_List__c != trigger.old[0].State_List__c) && Trigger.new[0].State_List__c != null) {
                    Trigger.new[0].State = Trigger.new[0].State_List__c;
                }
            }
        }  
    }
}