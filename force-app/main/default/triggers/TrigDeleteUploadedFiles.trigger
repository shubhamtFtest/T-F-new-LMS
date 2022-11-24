trigger TrigDeleteUploadedFiles on Product2 (before delete) {
    
    // recordtypeid for T&F - Collection
    Id PRODUCTRECORDTYPEID = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection'); 
    
    // only fires for a single insert/update -- no bulk processing
    if (Trigger.old.size() == 1) {   
        
        for (Product2 p : Trigger.old) {
            // only do the update/insert if it is a T&F-Collection
            if (p.RecordTypeId == PRODUCTRECORDTYPEID) {
                TF_ProcessUnsiloresponse.deleteUploadedFiles(p.Id);
            }
            
            if (p.RecordTypeId == PRODUCTRECORDTYPEID) {
                TF_ProcessUnsiloresponse.deleteBundleLineItemsOnProductDelete(p.Id);
            }            
        }   
        
    }
    
}