@isTest
public class TestOACOpportunityCurrencyUpdate_Trg {
    testMethod static void OACOppMethod(){
        TFOAC_Opportunity__c oOpp = new TFOAC_Opportunity__c();
        oOpp.Currency_Code__c = 'GBP';
        Insert oOpp;
        TFOAC_Journal__c oJournal = new TFOAC_Journal__c();
        oJournal.CurrencyIsoCode  = 'GBP';
        oJournal.OACOpportunity__c = oOpp.Id;
        insert oJournal;
        TFOAC_Opportunity__c opp =[Select Id,Currency_Code__c from TFOAC_Opportunity__c where Id=:oOpp.Id];
        System.debug('Avi opp : '+opp);
        opp.Currency_Code__c = 'USD';
        update opp;
    }
}