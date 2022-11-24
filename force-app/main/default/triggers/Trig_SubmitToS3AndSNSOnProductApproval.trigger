trigger Trig_SubmitToS3AndSNSOnProductApproval on Product2 (after update) {
    // recordtypeid for T&F - Collection
    Id PRODUCTRECORDTYPEID = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection'); 
    system.debug('==== Trig_SubmitToS3AndSNSOnProductApproval entered ====');
    
    // only fires for a single insert/update -- no bulk processing
    if (Trigger.new.size() == 1) {  
        Map<Id,product2> oldPrdMap = new Map<Id,product2>();
        oldPrdMap = Trigger.oldMap ;
        for (Product2 p : Trigger.new) {
            // only do the update/insert if it is a T&F-Collection
            product2 olpPrd = oldPrdMap.get(p.id) ;
            
            if (p.RecordTypeId == PRODUCTRECORDTYPEID && p.Approval_Status__c=='Approved' && olpPrd.Approval_Status__c != 'Approved') {
                if(!system.isFuture()){
                    if(p.Product_Type_Author_Facing__c  == 'Manual Curation'){
                        //TF_ProductApprovalS3Submit.putCollectionJsonToS3(p.Id);
                        system.debug('==== Trig_SubmitToS3AndSNSOnProductApproval triggered manual Curation ====');
                    }
                    
                    if(p.Product_Type_Author_Facing__c  == 'Rule based'){
                        system.debug('==== Trig_SubmitToS3AndSNSOnProductApproval triggered Rule based ====');
                       // TF_PPDProcessController.submitDynamicPackageToPCMasynch(p.Id);
                    }
                }
            }
            
            if (p.RecordTypeId == PRODUCTRECORDTYPEID && p.Approval_Status__c=='Approved' && p.APIStatus__c == 'Success' && olpPrd.APIStatus__c != 'Success') {
                
                if(p.originalProductId__c!=null && p.originalProductId__c!='')
                {
                    //String jobId = Database.executeBatch(new TF_Batch_updOriginalPrdDeleteBundelItms(p.originalProductId__c,p.Id), 9000);
                }
            }
        }   
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        setupCountryCode.afterUpdateProcess(Trigger.newMap,Trigger.oldMap);
    }
}