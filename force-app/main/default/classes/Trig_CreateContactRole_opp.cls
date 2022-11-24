//Trigger for creating contact roles when new opportunity is created from the contact.
public with sharing class Trig_CreateContactRole_opp implements TriggerInterface_Opp.Runnable {
    
    @future
    public static void resetPrimaryContact(List<String> OppIds){                        
        List<Opportunity> opps= new List<Opportunity>();
        
        for (String Oppid : OppIds)
        {   Opportunity opp=new Opportunity(id=Oppid,Primary_contact__c=NULL);   
         opps.add(opp);                         
        }             
        update opps;
    }
    
    public void run(TriggerInterface_Opp.Trig trig) {             
        //creating list of opportunity Contact roles
        List<OpportunityContactRole> newContactRoleList = new List<OpportunityContactRole>();
        List <string> opportunityIds=new List<string>();       
        
        if(trig.isInsert) {       
            for(Opportunity opp : trig.newList) {
                    if(opp.Primary_Contact__c != null && opp.Previous_Renewal__c == null && opp.Next_Renewal__c == null) {
                        system.debug('Previous Renewal '+opp.Previous_Renewal__c);
                        system.debug('Next Renewal '+opp.Next_Renewal__c);
                        system.debug('Who is the Primary Contact field' + opp.Primary_Contact__c);
                        //Adding new Contact role without role
                        newContactRoleList.add(new OpportunityContactRole(ContactId=opp.Primary_Contact__c,OpportunityId=opp.Id,Role=NULL,IsPrimary=true));   opportunityIds.add(Opp.id);               
                    }
            }        
            //try block
            try {
                //inserting new contact roles
                if(newContactRoleList.size()>0)
                system.debug('List has contact roles');
                insert newContactRoleList;
                system.debug('contact roles has been added');
                resetPrimaryContact(opportunityIds);                     
            }
            catch(Exception e) {
                System.debug(e);
                //trigger.new[0].addError('An error has occurred. Please contact your system administrator.');
            }
            //end try block
            
        }//end of trig.insert
        
        
    }
    
    
}