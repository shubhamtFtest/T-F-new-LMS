trigger Trig_UploadCollectionImageOnS3 on Product2 (after update) {
    // recordtypeid for T&F - Collection
    Id PRODUCTRECORDTYPEID = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection'); 
    system.debug('==== Trig_UploadCollectionImageOnS3 entered ====');
    
    // only fires for a single insert/update -- no bulk processing
    if (Trigger.new.size() == 1) {  
        Map<Id,product2> oldPrdMap = new Map<Id,product2>();
        oldPrdMap = Trigger.oldMap ;
        for (Product2 p : Trigger.new) {
            // only do the update/insert if it is a T&F-Collection
            product2 olpPrd = oldPrdMap.get(p.id) ;
            system.debug('Latest Status***'+p.Approval_Status__c);
              system.debug('Old Status***'+olpPrd.Approval_Status__c);
            if (p.RecordTypeId == PRODUCTRECORDTYPEID && p.Approval_Status__c=='Pending' && olpPrd.Approval_Status__c != 'Pending' && p.APIStatus__c != 'Validation Complete') {
               if(!system.isFuture()){
                TF_PPDProcessController.submitCollectionImageonS3(p.id);
                system.debug('submitCollectionImageonS3 finish');
                }
            }
            
            
        }   
    }
}