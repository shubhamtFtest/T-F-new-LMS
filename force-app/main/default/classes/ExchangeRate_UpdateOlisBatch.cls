global class ExchangeRate_UpdateOlisBatch implements Database.Batchable<Sobject>, Database.Stateful{
	
	global Double rateAUD;
	global Double rateEUR;
	global Double rateGBP;
	global Double rateUSD;
	global Double rateSEK;
	global String SOQL;
	global Map<Integer, Double> mapYearToRate = new Map<Integer, Double>();
	
	global Database.QueryLocator start(Database.BatchableContext BC){
		System.debug('DEBUG: Inside Database.QueryLocator');
		return Database.getQueryLocator(SOQL);
	}
   	
	global void execute(Database.BatchableContext BC, List<sObject> scope){
		System.debug('DEBUG: Inside execute');
		for(sobject s : scope) {
			OpportunityLineItem oli = (OpportunityLineItem)s;			
			Decimal oldAmt = oli.TotalPrice;
			String oldCurrency = oli.CurrencyIsoCode;
			Double oldRate = 0;
			if (oldCurrency == 'AUD')
				oldRate = rateAUD;
			else if (oldCurrency == 'EUR')
				oldRate = rateEUR;
			else if (oldCurrency == 'GBP')
				oldRate = rateGBP;
			else if (oldCurrency == 'USD')
				oldRate = rateUSD;
			else if (oldCurrency == 'SEK')
				oldRate = rateSEK;
			
			if (oldRate > 0) {
				s.put('TotalPrice_AUD__c', oldAmt * (rateAUD/oldRate));
				s.put('TotalPrice_EUR__c', oldAmt * (rateEUR/oldRate));
				s.put('TotalPrice_GBP__c', oldAmt * (rateGBP/oldRate));
				s.put('TotalPrice_USD__c', oldAmt * (rateUSD/oldRate));
			}
		} 
		update scope;
	}

	global void finish(Database.BatchableContext BC){
		System.debug('DEBUG: Inside finish');
	}

}