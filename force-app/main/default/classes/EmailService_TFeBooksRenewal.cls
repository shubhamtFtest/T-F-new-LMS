global class EmailService_TFeBooksRenewal implements Messaging.inboundEmailHandler{
	global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope env) {
		
		Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
		
		String errorRecipient = TF_ERN_Settings__c.getOrgDefaults().Inbound_Email_Error_Address__c;
		
		try {		
			String subject = (email.subject == null ? '' : email.subject.remove(' '));
			Integer firstBrace = subject.indexOf('[');
			String response = subject.left(firstBrace);
			String oppId = subject.mid(firstBrace+5,18);
			
			system.debug('response = ' + response);
			system.debug('oppId = ' + oppId);
		
			Opportunity opp = [SELECT Id FROM Opportunity WHERE Id = :oppId];
			if (response.toUpperCase() == 'RENEW')
				opp.Customer_Response__c = 'Renew';
			else if (response.toUpperCase() == 'PARTIALLYRENEW')
				opp.Customer_Response__c = 'Partially Renew';
			else if (response.toUpperCase() == 'DECLINE')
				opp.Customer_Response__c = 'Decline';
			else if (response.toUpperCase() == 'UNDECIDED')
				opp.Customer_Response__c = 'Undecided';
			else if (response.toUpperCase() == 'SPEAK')
				opp.Customer_Response__c = 'I Want to Speak to my Sales Rep';
			opp.Customer_Feedback__c = email.plainTextBody.replace('Please provide any feedback in the body of this email, but do not change the email subject.','');
			update opp;			
			
		} catch (Exception e) {
			System.debug('Error processing inbound email: ' + e);
			
			List<Messaging.SingleEmailMessage> errorEmails = new List<Messaging.SingleEmailMessage>();
			Messaging.SingleEmailMessage errorEmail = new Messaging.SingleEmailMessage();
	        errorEmail.setToAddresses(new String[] {errorRecipient});
	        errorEmail.setSubject('Error processing renewal response');
	        errorEmail.setPlainTextBody('Subject: ' + (email.subject == null ? '' : email.subject) + '\n\nBody: ' + (email.plainTextBody == null ? '' : email.plainTextBody));
	        errorEmails.add(errorEmail);
	        Messaging.SendEmailResult[] results = Messaging.sendEmail(errorEmails);
		}
		result.success = true; //Set the result to true so an email is not sent back to the user with an error message
		return result;
	}
}