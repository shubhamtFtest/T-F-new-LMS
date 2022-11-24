global class Contact_UpdateCaseContactBatchApex implements Database.Batchable<Sobject>, Database.Stateful {
	global String SOQL;
	global Id contactId;
	
	global Database.QueryLocator start(Database.BatchableContext BC){
		System.debug('DEBUG: Inside Database.QueryLocator');
		return Database.getQueryLocator(SOQL);
	}
   	
	global void execute(Database.BatchableContext BC, List<Sobject> scope){
		System.debug('DEBUG: Inside execute');
		List<Case> cases = new List<Case>();		
		for(sobject s : scope){
			Case c = (Case)s;
			c.ContactId = contactId;
			cases.add(c);
		}
		try {
			Database.DMLOptions dlo = new Database.DMLOptions();
			dlo.optAllOrNone = false;
			database.update(cases,dlo);
		} catch (Exception e) {
		}
	}

	global void finish(Database.BatchableContext BC){
		System.debug('DEBUG: Inside finish');
	}

}