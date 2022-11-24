/**************************************************
* Tests:
*   ExchangeRate_UpdateOlis.trigger         90%
*   ExchangeRate_UpdateOlisBatch.cls        100%
*   OLI_UpdateCurrencies_Trig.cls           100%
*   Opp_UpdateCurrencies_Trig.cls           100%
**************************************************/
@isTest
private class zTEST_ExchangeRate {
    static testMethod void test_VolumeYear() {
        
        Id oppJournalsRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Opportunity'); //CHG0038379

        TriggerInterfaceHelper.runTrigger('OLI_UpdateCurrencies_Trig', 'OpportunityLineItem', 99, 'bi,bu', oppJournalsRecordtypeId, 'year=volumeyear');
		TriggerInterfaceHelper.runTrigger('Opp_UpdateCurrencies_Trig', 'Opportunity', 99, 'au', oppJournalsRecordtypeId, 'year=volumeyear');
		
        User u = zTEST_Shared.insertUser();

        zTEST_Shared.runTriggers.add('ExchangeRate_UpdateOlis');
        Exchange_Rate__c rate = new Exchange_Rate__c();
        rate.Year__c = '2012';
        rate.AUD__c = 1.4;
        rate.EUR__c = 1.2;
        rate.GBP__c = 1;
        rate.USD__c = 1.5;
        rate.SEK__c = 2;
        insert rate;
                
        Opportunity opp1 = zTEST_Shared.noinsertOpportunity(oppJournalsRecordtypeId, u.Id);
        opp1.Volume_Year__c = '2012';
        opp1.CurrencyIsoCode = 'AUD';
        insert opp1;
        PricebookEntry pbe1 = zTEST_Shared.insertPricebookEntryWithCurrency('AUD');
        OpportunityLineItem oli1 = zTEST_Shared.noinsertOpportunityLineItem(pbe1.Id, opp1.Id);
        oli1.UnitPrice = 500;
        oli1.TotalPrice = null;
        oli1.Quantity = 2;
        insert oli1;

        Opportunity opp2 = zTEST_Shared.noinsertOpportunity(oppJournalsRecordtypeId, u.Id);
        opp2.Volume_Year__c = '2012';
        opp2.CurrencyIsoCode = 'EUR';
        insert opp2;        
        PricebookEntry pbe2 = zTEST_Shared.insertPricebookEntryWithCurrency('EUR');
        OpportunityLineItem oli2 = zTEST_Shared.noinsertOpportunityLineItem(pbe2.Id, opp2.Id);
        oli2.UnitPrice = 500;
        oli2.TotalPrice = null;
        oli2.Quantity = 2;
        insert oli2;

        Opportunity opp3 = zTEST_Shared.noinsertOpportunity(oppJournalsRecordtypeId, u.Id);
        opp3.Volume_Year__c = '2012';
        opp3.CurrencyIsoCode = 'GBP';
        insert opp3;
        PricebookEntry pbe3 = zTEST_Shared.insertPricebookEntryWithCurrency('GBP');
        OpportunityLineItem oli3 = zTEST_Shared.noinsertOpportunityLineItem(pbe3.Id, opp3.Id);
        oli3.UnitPrice = 500;
        oli3.TotalPrice = null;
        oli3.Quantity = 2;
        insert oli3;

        Opportunity opp4 = zTEST_Shared.noinsertOpportunity(oppJournalsRecordtypeId, u.Id);
        opp4.Volume_Year__c = '2012';
        opp4.CurrencyIsoCode = 'USD';
        insert opp4;        
        PricebookEntry pbe4 = zTEST_Shared.insertPricebookEntryWithCurrency('USD');
        OpportunityLineItem oli4 = zTEST_Shared.noinsertOpportunityLineItem(pbe4.Id, opp4.Id);
        oli4.UnitPrice = 500;
        oli4.TotalPrice = null;
        oli4.Quantity = 2;
        insert oli4;

        Opportunity opp5 = zTEST_Shared.noinsertOpportunity(oppJournalsRecordtypeId, u.Id);
        opp5.Volume_Year__c = '2012';
        opp5.CurrencyIsoCode = 'SEK';
        insert opp5;        
        PricebookEntry pbe5 = zTEST_Shared.insertPricebookEntryWithCurrency('SEK');
        OpportunityLineItem oli5 = zTEST_Shared.noinsertOpportunityLineItem(pbe5.Id, opp5.Id);
        oli5.UnitPrice = 500;
        oli5.TotalPrice = null;
        oli5.Quantity = 2;
        insert oli5;
        
        test.startTest();
            update rate;
    
            opp1.Volume_Year__c = '2013';
            update opp1;
            opp2.Volume_Year__c = '2013';
            update opp2;
            opp3.Volume_Year__c = '2013';
            update opp3;
            opp4.Volume_Year__c = '2013';
            update opp4;
            opp5.Volume_Year__c = '2013';
            update opp5;
        test.stopTest();

        try {
            rate.Year__c = 'test';      
            update rate;
        } catch (Exception e) {
        }               
    }

    static testMethod void test_VolumeYear2() {

        Id oppJournalsRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Opportunity'); //CHG0038379
        
        User u = zTEST_Shared.insertUser();

        zTEST_Shared.runTriggers.add('ExchangeRate_UpdateOlis');
        Exchange_Rate__c rate = new Exchange_Rate__c();
        rate.Year__c = '2016';
        rate.AUD__c = 1.4;
        rate.EUR__c = 1.2;
        rate.GBP__c = 1;
        rate.USD__c = 1.5;
        rate.SEK__c = 2;
        insert rate;
        
        test.startTest();
        	Exchange_Rate__c rate2 = new Exchange_Rate__c();
            rate2.Year__c = '2015';
            rate2.AUD__c = 1.44;
            rate2.EUR__c = 1.22;
            rate2.GBP__c = 1.1;
            rate2.USD__c = 1.55;
            rate2.SEK__c = 2.2;
        	insert rate2;
        test.stopTest();
    }

    static testMethod void test_CloseDate() {

        Id oppEbooksRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - eBooks Opportunity'); //CHG0038379
        
        TriggerInterfaceHelper.runTrigger('OLI_UpdateCurrencies_Trig', 'OpportunityLineItem', 99, 'bi,bu', oppEbooksRecordtypeId, 'year=closedate');
		TriggerInterfaceHelper.runTrigger('Opp_UpdateCurrencies_Trig', 'Opportunity', 99, 'au', oppEbooksRecordtypeId, 'year=closedate');

        User u = zTEST_Shared.insertUser();

        Exchange_Rate__c rate = new Exchange_Rate__c();
        rate.Year__c = '2012';
        rate.AUD__c = 1.4;
        rate.EUR__c = 1.2;
        rate.GBP__c = 1;
        rate.USD__c = 1.5;
        rate.SEK__c = 2;
        insert rate;
        
        Opportunity opp1 = zTEST_Shared.noinsertOpportunity(oppEbooksRecordtypeId, u.Id);
        opp1.CloseDate = date.newInstance(2011, 1, 1);
        opp1.CurrencyIsoCode = 'AUD';
        insert opp1;
        PricebookEntry pbe1 = zTEST_Shared.insertPricebookEntryWithCurrency('AUD');
        OpportunityLineItem oli1 = zTEST_Shared.noinsertOpportunityLineItem(pbe1.Id, opp1.Id);
        oli1.UnitPrice = 500;
        oli1.TotalPrice = null;
        oli1.Quantity = 2;
        insert oli1;

        Opportunity opp2 = zTEST_Shared.noinsertOpportunity(oppEbooksRecordtypeId, u.Id);
        opp2.CloseDate = date.newInstance(2013, 1, 1);
        opp2.CurrencyIsoCode = 'EUR';
        insert opp2;        
        PricebookEntry pbe2 = zTEST_Shared.insertPricebookEntryWithCurrency('EUR');
        OpportunityLineItem oli2 = zTEST_Shared.noinsertOpportunityLineItem(pbe2.Id, opp2.Id);
        oli2.UnitPrice = 500;
        oli2.TotalPrice = null;
        oli2.Quantity = 2;
        insert oli2;

        Opportunity opp3 = zTEST_Shared.noinsertOpportunity(oppEbooksRecordtypeId, u.Id);
        opp3.CloseDate = date.newInstance(2012, 1, 1);
        opp3.CurrencyIsoCode = 'GBP';
        insert opp3;
        PricebookEntry pbe3 = zTEST_Shared.insertPricebookEntryWithCurrency('GBP');
        OpportunityLineItem oli3 = zTEST_Shared.noinsertOpportunityLineItem(pbe3.Id, opp3.Id);
        oli3.UnitPrice = 500;
        oli3.TotalPrice = null;
        oli3.Quantity = 2;
        insert oli3;

        Opportunity opp4 = zTEST_Shared.noinsertOpportunity(oppEbooksRecordtypeId, u.Id);
        opp4.CloseDate = date.newInstance(2012, 1, 1);
        opp4.CurrencyIsoCode = 'USD';
        insert opp4;        
        PricebookEntry pbe4 = zTEST_Shared.insertPricebookEntryWithCurrency('USD');
        OpportunityLineItem oli4 = zTEST_Shared.noinsertOpportunityLineItem(pbe4.Id, opp4.Id);
        oli4.UnitPrice = 500;
        oli4.TotalPrice = null;
        oli4.Quantity = 2;
        insert oli4;

        Opportunity opp5 = zTEST_Shared.noinsertOpportunity(oppEbooksRecordtypeId, u.Id);
        opp5.CloseDate = date.newInstance(2012, 1, 1);
        opp5.CurrencyIsoCode = 'SEK';
        insert opp5;        
        PricebookEntry pbe5 = zTEST_Shared.insertPricebookEntryWithCurrency('SEK');
        OpportunityLineItem oli5 = zTEST_Shared.noinsertOpportunityLineItem(pbe5.Id, opp5.Id);
        oli5.UnitPrice = 500;
        oli5.TotalPrice = null;
        oli5.Quantity = 2;
        insert oli5;
        
        test.startTest();
            update rate;
            
            opp1.CloseDate = opp1.CloseDate.addYears(-1);
            update opp1;
            opp2.CloseDate = opp2.CloseDate.addYears(1);
            update opp2;
            opp3.CloseDate = opp3.CloseDate.addYears(1);
            update opp3;
            opp4.CloseDate = opp4.CloseDate.addYears(1);
            update opp4;
            opp5.CloseDate = opp4.CloseDate.addYears(1);
            update opp5;
        test.stopTest();
    }
    
    static testMethod void test_CloseDate_Bulk() {
        
        Id oppEbooksRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - eBooks Opportunity'); //CHG0038379
        Id oppJournalsRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Opportunity'); //CHG0038379

        TriggerInterfaceHelper.runTrigger('OLI_UpdateCurrencies_Trig', 'OpportunityLineItem', 99, 'bi,bu', oppEbooksRecordtypeId, 'year=closedate');
        TriggerInterfaceHelper.runTrigger('OLI_UpdateCurrencies_Trig', 'OpportunityLineItem', 99, 'bi,bu', oppJournalsRecordtypeId, 'year=volumeyear');

		TriggerInterfaceHelper.runTrigger('Opp_UpdateCurrencies_Trig', 'Opportunity', 99, 'au', oppEbooksRecordtypeId, 'year=closedate');
		TriggerInterfaceHelper.runTrigger('Opp_UpdateCurrencies_Trig', 'Opportunity', 99, 'au', oppJournalsRecordtypeId, 'year=volumeyear');
        
        User u = zTEST_Shared.insertUser();

        Exchange_Rate__c rate = new Exchange_Rate__c();
        rate.Year__c = '2012';
        rate.AUD__c = 1.4;
        rate.EUR__c = 1.2;
        rate.GBP__c = 1;
        rate.USD__c = 1.5;
        rate.SEK__c = 2;
        insert rate;
        
        Opportunity opp1 = zTEST_Shared.noinsertOpportunity(oppEbooksRecordtypeId, u.Id);
        opp1.CloseDate = date.newInstance(2012, 1, 1);
        opp1.CurrencyIsoCode = 'AUD';
        insert opp1;
        PricebookEntry pbe1 = zTEST_Shared.insertPricebookEntryWithCurrency('AUD');
        OpportunityLineItem oli1 = zTEST_Shared.noinsertOpportunityLineItem(pbe1.Id, opp1.Id);
        oli1.UnitPrice = 500;
        oli1.TotalPrice = null;
        oli1.Quantity = 2;
        insert oli1;

        Opportunity opp2 = zTEST_Shared.noinsertOpportunity(oppEbooksRecordtypeId, u.Id);
        opp2.CloseDate = date.newInstance(2012, 1, 1);
        opp2.CurrencyIsoCode = 'EUR';
        insert opp2;        
        PricebookEntry pbe2 = zTEST_Shared.insertPricebookEntryWithCurrency('EUR');
        OpportunityLineItem oli2 = zTEST_Shared.noinsertOpportunityLineItem(pbe2.Id, opp2.Id);
        oli2.UnitPrice = 500;
        oli2.TotalPrice = null;
        oli2.Quantity = 2;
        insert oli2;
        
        Opportunity opp3 = zTEST_Shared.noinsertOpportunity(oppJournalsRecordtypeId, u.Id);
        opp3.Volume_Year__c = '2012';
        opp3.CurrencyIsoCode = 'GBP';
        insert opp3;
        PricebookEntry pbe3 = zTEST_Shared.insertPricebookEntryWithCurrency('GBP');
        OpportunityLineItem oli3 = zTEST_Shared.noinsertOpportunityLineItem(pbe3.Id, opp3.Id);
        oli3.UnitPrice = 500;
        oli3.TotalPrice = null;
        oli3.Quantity = 2;
        insert oli3;

        Opportunity opp4 = zTEST_Shared.noinsertOpportunity(oppJournalsRecordtypeId, u.Id);
        opp4.Volume_Year__c = '2012';
        opp4.CurrencyIsoCode = 'USD';
        insert opp4;        
        PricebookEntry pbe4 = zTEST_Shared.insertPricebookEntryWithCurrency('USD');
        OpportunityLineItem oli4 = zTEST_Shared.noinsertOpportunityLineItem(pbe4.Id, opp4.Id);
        oli4.UnitPrice = 500;
        oli4.TotalPrice = null;
        oli4.Quantity = 2;
        insert oli4;

        Opportunity opp5 = zTEST_Shared.noinsertOpportunity(oppJournalsRecordtypeId, u.Id);
        opp5.Volume_Year__c = '2012';
        opp5.CurrencyIsoCode = 'SEK';
        insert opp5;        
        PricebookEntry pbe5 = zTEST_Shared.insertPricebookEntryWithCurrency('SEK');
        OpportunityLineItem oli5 = zTEST_Shared.noinsertOpportunityLineItem(pbe5.Id, opp5.Id);
        oli5.UnitPrice = 500;
        oli5.TotalPrice = null;
        oli5.Quantity = 2;
        insert oli5;
        
        test.startTest();
            List<Opportunity> oppsToUpdate = new List<Opportunity>();
            opp1.CloseDate = opp1.CloseDate.addYears(1);
            oppsToUpdate.add(opp1);
            opp2.CloseDate = opp2.CloseDate.addYears(1);
            oppsToUpdate.add(opp2);
            opp3.Volume_Year__c = opp3.Volume_Year__c = '2013';
            oppsToUpdate.add(opp3);
            opp4.Volume_Year__c = opp4.Volume_Year__c = '2013';
            oppsToUpdate.add(opp4);
            opp5.Volume_Year__c = opp5.Volume_Year__c = '2013';
            oppsToUpdate.add(opp5);
            update oppsToUpdate;
        test.stopTest();
    }
}