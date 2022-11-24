global with sharing class TF_SBcreatePriceBookEntry_webservice{
    webService static String runBatch() {
        return Database.executeBatch(new TF_SBcreatePriceBookEntry());
    }
}