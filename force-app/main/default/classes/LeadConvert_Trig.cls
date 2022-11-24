//Tested by zTEST_LeadConvert_Trig.cls		100%
//
//Created by Jeff Lup - 2015.11.19 - moved existing Trigger into this Class

public with sharing class LeadConvert_Trig implements TriggerInterface_Lead.Runnable {
    public void run(TriggerInterface_Lead.Trig trig) {
        if (trig.isAfter && trig.isUpdate) {
            if (trig.TriggerSize == 1) {
                if (trig.oldList[0].isConverted == false && trig.newList[0].isConverted == true) { //the lead was just converted

                    String business = trig.mapRtIdsToParams.get(trig.newList[0].recordtypeid).get('Business');
        
                    // START CODE FOR CAS - Leads
                    if (business == 'CAS') { //CAS
                        
                        // if a new contact was created
                        if (trig.newList[0].ConvertedContactId != null) {
                    
                            // update the converted contact with the state and country values
                            Contact c = [Select c.Mailing_State_List__c, c.Mailing_Country_List__c, c.Id From Contact c Where c.Id = :trig.newList[0].ConvertedContactId];
                            c.Mailing_State_List__c = trig.newList[0].State_List__c;
                            c.Mailing_Country_List__c = trig.newList[0].Country_List__c;
                            update c;
                            
                            // copy over the subject codes from the lead to the contact
                            List<CAS_Subject_Code_Contact__c> toInsert = new List<CAS_Subject_Code_Contact__c>();
                            for (CAS_Subject_Code_Lead__c selected : [Select s.Subject_Code__c, s.Name, s.Lead__c From CAS_Subject_Code_Lead__c s Where s.Lead__c = :trig.oldList[0].Id]) {
                                
                                // create a new entry for contact
                                CAS_Subject_Code_Contact__c sc = new CAS_Subject_Code_Contact__c(
                                    Name = selected.Name,
                                    Contact__c = c.Id,
                                    Subject_Code__c = selected.Subject_Code__c              
                                );
                                
                                toInsert.add(sc);
                            }
                            
                            // insert the selected subject codes for the contact
                            if (toInsert.size() > 0)
                                insert toInsert;                    
                            
                        }
                        
                        // if a new opportunity was created
                        if (trig.newList[0].ConvertedOpportunityId != null) {
                            
                            if (trig.newList[0].Course_Name__c != null) {
                                // update the converted opportunity with the course name field from the lead and make it the opp's name
                                Opportunity opp = [Select o.Name from Opportunity o Where o.Id = :trig.newList[0].ConvertedOpportunityId];
                                opp.Name = trig.newList[0].Course_Name__c;
                                update opp;
                            }
                            
                        }               
                        
                    }
                }
            }       
        }
    }
}