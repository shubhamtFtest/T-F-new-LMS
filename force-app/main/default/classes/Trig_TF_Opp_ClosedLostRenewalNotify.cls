/*
*   Created by Jeff Lup - 2015.01.28 - CHG0060253
*     Sends email if Renewal Opp with Subs Olis is Closed Lost
*   Test Method: zTEST_Trig_TF_Opp_ClosedLostRenNotify.class    97%
*/
public with sharing class Trig_TF_Opp_ClosedLostRenewalNotify implements TriggerInterface_Opp.Runnable {
    public void run(TriggerInterface_Opp.Trig trig) {
        if (trig.isAfter && trig.isUpdate) {
            //Get Opps which are Type of 'Renewal' and Stage of 'Closed Lost'
            List<Opportunity> opps = new List<Opportunity>();
            Set<Id> oppIds = new Set<Id>();
            for (integer i=0; i<trig.triggerSize; i++) {
                if (trig.newList[i].Type == 'Renewal' && trig.newList[i].StageName == 'Closed Lost' && trig.oldList[i].StageName != 'Closed Lost') {
                    opps.add(trig.newList[i]);
                    oppIds.add(trig.newList[i].Id);
                }
            }
            if (oppIds.size() > 0) {
                //For above Opps, get Olis whos ProductCode is 'SUBS' 
                List<OpportunityLineItem> olis = [SELECT Id, OpportunityId, ProductCode, Opportunity.Account.Name FROM OpportunityLineItem WHERE OpportunityId IN :oppIds];
                Set<Id> oppIdsWithSubs = new Set<Id>();
                Map<Id, String> mapOppIdToAccountName = new Map<Id,String>();
                for (OpportunityLineItem oli : olis) {
                    if (oli.ProductCode == 'SUBS') {
                        oppIdsWithSubs.add(oli.OpportunityId);
                        mapOppIdToAccountName.put(oli.OpportunityId, oli.Opportunity.Account.Name);
                    }
                }
                if (oppIdsWithSubs.size() > 0) {
                    //Get recipients from Group "T&F Journals - Sales Support"
                    List<GroupMember> gms = [SELECT Id, SystemModstamp, UserOrGroupId FROM GroupMember where GroupId = '00G60000002MaKB'];
                    Set<Id> userIds = new Set<Id>();
                	for (GroupMember gm : gms) {
                		if (((String)gm.UserOrGroupId).startsWith('005'))
                			userIds.add(gm.UserOrGroupId);
                	}
                	if (userIds.size() > 0) {
                		//Get Salesforce URL
                		String baseURL = URL.getSalesforceBaseUrl().toExternalForm().replace('http:','https:');
                		//Get recipients
                		List<User> users = [SELECT Id, Email FROM User WHERE Id IN :userIds];
                		List<String> toAddresses = new List<String>();
                		for (User u : users) {
                			toAddresses.add(u.Email);
                		}
                        //Construct emails
                        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
                        for (Opportunity opp : opps) {
                            if (oppIdsWithSubs.contains(opp.Id)) {
                                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                                email.setToAddresses(toAddresses);
                                email.setOrgWideEmailAddressId('0D260000000TNCX'); //do_not_reply.sfdc@informausa.com
                                email.setReplyTo('do_not_reply.sfdc@informausa.com');
                                String accountName = mapOppIdToAccountName.get(opp.Id);
						        email.setSubject('Renewal Opp for "' + accountName + '" is Closed Lost – please email CSD');
						        String emailBody = '<html><body>'
						        	+ 'The Renewal Opportunity "' + opp.Name + '" for the Account "' + accountName + '" has been moved to Closed Lost: '
						        	+ '<br/>'
						        	+ '<a href="' + baseURL + '/' + opp.Id + '">' + baseURL + '/' + opp.Id + '</a>'
						        	+ '<br/><br/>'
						        	+ 'When a Journals Renewal is moved to Closed Lost, normal renewal reminders must be reinstated for any subscriptions.'
						        	+ '<br/><br/>'
						        	+ 'If this Opportunity is in your territory, please proceed as follows:'
						        	+ '<br/><br/>'
						        	+ ' • email <a href="mailto:sales@tandf.co.uk">sales@tandf.co.uk</a> within 1 week'
						        	+ '<br/>'
						        	+ ' • attach a list (spreadsheet) of any and all associated subscription order numbers'
						        	+ '<br/><br/>'
						        	+ '***Please note that if this email does not go to CSD as required, renewal reminders will be suppressed for this customer'
						        	+ '</body></html>';
						        email.setHtmlBody(emailBody);
						        emails.add(email);
                            }
                        }
                        if (emails.size() > 0 && !Test.isRunningTest())
                            Messaging.SendEmailResult[] results = Messaging.sendEmail(emails);
                    }
                }
            }
        }
    }
}