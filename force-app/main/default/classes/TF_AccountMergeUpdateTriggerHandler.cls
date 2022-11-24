/************************************************************************************
 This handler class is used for TF_AccountMergeTrigger trigger.
*************************************************************************************/
public with sharing class TF_AccountMergeUpdateTriggerHandler implements TriggerInterface_Account.Runnable {
      @future
      public static void accUpdate(String accToUpdateJSON){
          List<Account> accToUpdate = new List<Account>();
          accToUpdate = (List<Account>)JSON.deserialize(accToUpdateJSON,List<Account>.class);
          update accToUpdate;                 
      }
    
    public void run(TriggerInterface_Account.Trig trig) {
        List<Account> accToUpdate = new List<Account>();
        List<Account> accList = new List<Account>();
        Set<Id> masterAccIdSet = new Set<Id>();
        
        if (trig.isAfter && trig.isDelete) {
            for(Account accObj : trig.oldList){
                if(accObj.MasterRecordId != Null){
                    masterAccIdSet.add(accObj.MasterRecordId);
                }
            }
            
            accList = [SELECT Id ,MergedIds__c from Account WHERE Id in :masterAccIdSet];
            
            
            for (Account accObject : accList) {
            
                for(Account accObj : trig.oldList){
                    if(accObj.MasterRecordId != Null){
                        if(accObject.MergedIds__c == Null){
                        
                            accObject.MergedIds__c = accObj.Id;
                        }
                        
                        else{
                            accObject.MergedIds__c = accObject.MergedIds__c+','+accObj.id;      
                            system.debug('*******hello1 '+accObject.MergedIds__c);
                        }
                        
                    }
                }  
                accToUpdate.add(accObject);
            }
            
            if (!accToUpdate.isEmpty()){
                Set<Account> tempSet = new Set<Account>(accToUpdate);
                TF_AccountMergeUpdateTriggerHandler.accUpdate(JSON.serialize(tempSet));
            } 
        }
    }
}