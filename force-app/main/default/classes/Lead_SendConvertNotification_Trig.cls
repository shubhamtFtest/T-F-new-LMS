public with sharing class Lead_SendConvertNotification_Trig implements TriggerInterface_Lead.Runnable {
    public void run(TriggerInterface_Lead.Trig trig) {
        List<Id> opportunityIds = new List<Id>();
        List<Id> leadQaulifierIds = new List<Id>();
        List<Id> leadOwnerIds = new List<Id>();
        List<Id> leadIds = new List<Id>();
        
        for(Lead lead: trig.newList){
            //if((lead.Status =='Converted' || lead.Status =='Disqualified') && lead.Lead_Qualifier__c !=null){
            if((lead.Status =='Converted' || lead.Status =='Disqualified') && lead.Lead_Qualifier__c !=null && String.valueOf(lead.OwnerId).Left(3) != '00G'){ //INC1790089 (and not a queue)
                leadOwnerIds.add(lead.OwnerId);
                leadQaulifierIds.add(lead.Lead_Qualifier__c);
                leadIds.add(lead.Id);
                if(lead.IsConverted)
                    opportunityIds.add(lead.ConvertedOpportunityId);
           }
        }

        if(!leadQaulifierIds.isEmpty()){
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            Map<Id,Opportunity> convertedOppMap = new Map<Id,Opportunity>([Select Id,Name from Opportunity where Id=:opportunityIds]);
            Map<Id,User> LeadQualifierMap = new Map<Id,User>([Select Id,Name,Email from User where Id=:leadQaulifierIds]);
            Map<Id,User> LeadOwnerMap = new Map<Id,User>([Select Id,Name,Email from User where Id=:leadOwnerIds]);
            System.Debug('Converted Opp : '+convertedOppMap);
            for(String key:leadIds){
                Lead lead = Trig.newMap.get(key);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                string body='';
                String leadUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/'+lead.Id;
                    
                if(lead.Status =='Converted'){
                       body = 'Your salesforce.com request to convert a lead into the following records has successfully completed: <br />';
                       body +='Institution   : '+lead.Company +' <br />'; 
                       body +='Contact Name  : '+lead.FirstName+ ' '+lead.LastName + ' <br />'; 
                       body +='Sales Manager : '+LeadOwnerMap.get(lead.OwnerId).Name+' <br />'; 
                       body +='Description   : '+lead.Company +' <br />'; 
                       body +='Job Category   : '+lead.Job_Category__c +' <br />';    
                       body +='Opportunity   : '+convertedOppMap.get(lead.ConvertedOpportunityId).Name +' <br />'; 
                       body +='Lead URL   : '+leadUrl +' <br />'; 
                       mail.setSubject('Lead Converted');
                }
                else if(lead.Status =='Disqualified'){   // Notifiaction for disqualified leads.
                    body='Following lead has been disqualified : <br />';
                    body +='Institution   : '+lead.Company +' <br />'; 
                    body +='Contact Name  : '+lead.FirstName+ ' '+lead.LastName + ' <br />'; 
                    body +='Sales Manager : '+LeadOwnerMap.get(lead.OwnerId).Name+' <br />'; 
                    body +='Description   : '+lead.Company +' <br />'; 
                    body +='Job Category   : '+lead.Job_Category__c +' <br />';  
                    body +='Reason Disqualified   : '+lead.Reason_Disqualified__c +' <br />';
                    body +='Lead URL   : '+leadUrl +' <br />'; 
                    mail.setSubject('Lead Disqualified');
                }
                String[] toAddresses = new String[] {LeadQualifierMap.get(lead.Lead_Qualifier__c).Email} ;
                mail.setToAddresses(toAddresses);
                mail.setSaveAsActivity(false);
                mail.setHtmlBody(body); mails.add(mail);
            }
            Messaging.sendEmail(mails);
        }
    }
}