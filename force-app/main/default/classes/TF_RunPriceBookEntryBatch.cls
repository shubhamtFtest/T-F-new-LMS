/**
 * Created by Amit Kumar
 * 
 *  Execute existing batch class
*/
public class TF_RunPriceBookEntryBatch {
    
    @AuraEnabled        
    public static String runPriceBookEntryBatch(){ 
        //excecute batch and return
    	return Database.executeBatch(new TF_SBcreatePriceBookEntry());  
    }
}