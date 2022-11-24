// Modified by Hailey Niemand 2013.08.09 - CHG0048108 - Rename T&F Opportunity Record Types

trigger ExchangeRate_UpdateOlis on Exchange_Rate__c (after insert, after update) {
    if (MiscFunctions.triggerEnabled('ExchangeRate_UpdateOlis')) {
        if (!trigger.new[0].Year__c.isNumeric()) {
            trigger.new[0].addError('Please enter a valid four digit year.');
        } else {
            //is this the lastest year?
            String soqlOperator = '=';
            List<Exchange_Rate__c> rates = [SELECT Id FROM Exchange_Rate__c WHERE Year__c > :trigger.new[0].Year__c];
            if (rates.size() == 0)
                soqlOperator = '>=';
            else {
                //is this the earliest year?
                rates = [SELECT Id FROM Exchange_Rate__c WHERE Year__c < :trigger.new[0].Year__c];
                if (rates.size() == 0)
                    soqlOperator = '<=';
            }
            
            ExchangeRate_UpdateOlisBatch apexJob1 = new ExchangeRate_UpdateOlisBatch();
            apexJob1.rateAUD = trigger.new[0].AUD__c;
            apexJob1.rateEUR = trigger.new[0].EUR__c;
            apexJob1.rateGBP = trigger.new[0].GBP__c;
            apexJob1.rateUSD = trigger.new[0].USD__c;
            apexJob1.rateSEK = trigger.new[0].SEK__c;
            
            
            apexJob1.SOQL = 'SELECT Id, TotalPrice, CurrencyIsoCode,'
                         + '   TotalPrice_AUD__c, TotalPrice_EUR__c, TotalPrice_GBP__c, TotalPrice_USD__c'
                         + ' FROM OpportunityLineItem'
                         + ' WHERE Opportunity.Volume_Year__c ' + soqlOperator + ' \'' + trigger.new[0].Year__c + '\''
                         + '   AND Opportunity.RecordTypeId IN (' //Record Types renamed per CHG0048108 
                                    + '\'0120Y000000Wn8TQAS\''   //T&F Journals Customer Opportunity (Direct)
                                    + ', \'0120Y000000Wn9VQAS\'' //T&F Journals Consortium Opportunity (Direct)
                                    + ', \'0120Y000000Wn9WQAS\'' //T&F Journals Consortium Opportunity (Price Agreement)
                                    + ', \'0120Y000000Wn9XQAS\'' //T&F One-Off Opportunity
                                    + ', \'012g0000000DS3JAAW\'' //T&F One-Off Opportunity (in DevIHC)
                                + ')';
                                
            //ID batchprocessid1 = Database.ExecuteBatch(apexJob1);
            List<OpportunityLineItem> oliCheck1 = database.query(apexJob1.SOQL + ' LIMIT 1');
            if (oliCheck1.size() > 0)
                Database.ExecuteBatch(apexJob1);
        
            ExchangeRate_UpdateOlisBatch apexJob2 = new ExchangeRate_UpdateOlisBatch();
            apexJob2.rateAUD = trigger.new[0].AUD__c;
            apexJob2.rateEUR = trigger.new[0].EUR__c;
            apexJob2.rateGBP = trigger.new[0].GBP__c;
            apexJob2.rateUSD = trigger.new[0].USD__c;
            apexJob2.rateSEK = trigger.new[0].SEK__c;
            apexJob2.SOQL = 'SELECT Id, TotalPrice, CurrencyIsoCode,'
                         + '   TotalPrice_AUD__c, TotalPrice_EUR__c, TotalPrice_GBP__c, TotalPrice_USD__c'
                         + ' FROM OpportunityLineItem'
                         + ' WHERE CALENDAR_YEAR(Opportunity.CloseDate) ' + soqlOperator + ' ' + trigger.new[0].Year__c
                         + '   AND Opportunity.RecordTypeId IN (' //Record Types renamed per CHG0048108 
                                    + '\'0120Y000000Wn8YQAS\''   //T&F eBooks Customer Opportunity (Direct)
                                    + ', \'0120Y000000Wn9YQAS\'' //T&F eBooks Consortium Opportunity (Direct)
                                    + ', \'0120Y000000Wn9ZQAS\'' //T&F eBooks Consortium Opportunity (Price Agreement)
                                    + ', \'01260000000Df3lAAC\'' //T&F - eBook Opportunities
                                + ')';
            
            //ID batchprocessid2 = Database.ExecuteBatch(apexJob2);
            List<OpportunityLineItem> oliCheck2 = database.query(apexJob2.SOQL + ' LIMIT 1');
            if (oliCheck2.size() > 0)
                Database.ExecuteBatch(apexJob2);
        }   
    }
}