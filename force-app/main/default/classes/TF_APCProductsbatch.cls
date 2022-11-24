global class TF_APCProductsbatch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        string query= '';
        query = 'select id,currencyisocode from pricebookentry where currencyisocode in (\'GBP\',\'EUR\') and  product2.isactive = true and product2.OA_Offered__c = true and ';
        query += 'product2.Open_Access_Category__c = \'Open Select\' and product2.Article_Type__c = \'Full Rate\' and ';
        query += 'product2.Family = \'Journals-Author Side Charges\'';
        
        set<Id> excludedProductIds = new set<Id>{'01t0Y00000810EA','01t0Y00000810EJ','01t0Y0000080zxZ','01t0Y0000080zxn','01t0Y0000080zy4','01t0Y0000080zyJ','01t0Y0000080zyg','01t0Y00000810f3','01t0Y00000810eU','01t0Y00000810e1','01t0Y00000810dW','01t0Y00000810d8','01t0Y00000810ar','01t0Y00000810YQ','01t0Y00000810YN','01t0Y0000081wh9','01t0Y0000081wh8','01t0Y00000810Y9','01t0Y00000810Y4','01t0Y000007Gdfg','01t0Y00000810XX','01t0Y00000810XL','01t0Y0000081wh7','01t0Y00000810Wo','01t0Y00000810WY','01t0Y0000081wh6','01t0Y00000810Vr','01t0Y00000810Us','01t0Y00000810Ty','01t0Y00000810Ra','01t0Y000007GdfS','01t0Y00000810NT','01t0Y0000081whQ','01t0Y0000081whO','01t0Y000008109o','01t0Y00000810Gy','01t0Y00000810Fi','01t0Y0000081014','01t0Y000008100z','01t0Y000008100q','01t0Y000008100p','01t0Y000008100N','01t0Y0000081000','01t0Y0000080zzi','01t0Y0000080zze','01t0Y0000080zzV','01t0Y0000080zzM','01t0Y0000080zzH','01t0Y0000080zzC','01t0Y0000080zz8','01t0Y0000080zz2','01t0Y0000080zyy','01t0Y0000080zyp','01t0Y0000080zyl','01t0Y00000810Dk'}; 
        
        if(excludedProductIds.Size() > 0){
            query += ' and product2Id not in : excludedProductIds';    
        }
        
             
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<PriceBookEntry> scope) {        
        List<PriceBookEntry> prcBookEntryLst = new List<PriceBookEntry>();
        for(PriceBookEntry pbe : (List<PriceBookEntry>)scope){
           if(pbe.currencyisocode == 'GBP'){
               pbe.UnitPrice = 1895;
           }
           if(pbe.currencyisocode == 'EUR'){
               pbe.UnitPrice = 2275;
           }
           prcBookEntryLst.add(pbe);
        }
        List<Database.SaveResult> updateResults = database.update(prcBookEntryLst);
        
        for(Database.SaveResult result : updateResults){
            if (!result.isSuccess()){
                for (Database.Error err : result.getErrors()){  
                    system.debug(err.getMessage());
                }
            }
        }
    }
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations
    }
}