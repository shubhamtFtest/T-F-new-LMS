//test class- ztest_TrigSubmitToPCM
trigger Trig_SubmitToPCMOnProductApproval on Product2 (after update, after insert) {
    // recordtypeid for T&F - Collection
    Id PRODUCTRECORDTYPEID = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection'); 
    Id bespokeRecordTypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - BespokeCollection'); //SFAL-228 Vikas Varshney
    system.debug('==== Trig_SubmitToPCMOnProductApproval entered ====');
    List<User> integrationUsers=[select id,userName,isactive from user where name='Product Integration' and isactive =true];
    Id UserId=integrationUsers[0].id;
    // only fires for a single insert/update -- no bulk processing
    if (Trigger.new.size() == 1) {
        Map<Id,product2> oldPrdMap = new Map<Id,product2>();
        oldPrdMap = Trigger.oldMap ;
        for (Product2 p : Trigger.new) {
            if(Trigger.isAfter && Trigger.isInsert && p.CreatedById==UserId){
                if(p.RecordTypeId == PRODUCTRECORDTYPEID){
                    system.debug('submitSKU triggered');
                    TF_PPDProcessController.GetS3FileUsingFileId(p.Id);
                    TF_PPDProcessController.submitSKU(p.Id);
                }
            }  
            if(Trigger.isAfter && Trigger.isUpdate){
                // only do the update/insert if it is a T&F-Collection
                product2 olpPrd = oldPrdMap.get(p.id) ;
                
                //start change- Geetika for PCH-3886
				if (p.RecordTypeId == PRODUCTRECORDTYPEID){
                    	TF_PPDProcessController.isBundleItemsFree(p.Id);
                } //end change - Geetika for PCH-3886          
                 
                
                if (p.RecordTypeId == PRODUCTRECORDTYPEID && p.Approval_Status__c=='Approved' && olpPrd.Approval_Status__c != 'Approved') {
                    if(!system.isFuture()){
                        if(p.Product_Type_Author_Facing__c  == 'Manual Curation'){
                            TF_ApprovedProdPcmSubmit.putStaticCollectionJsonToPCM(p.Id);
                            system.debug('==== Trig_SubmitToS3AndSNSOnProductApproval triggered manual Curation/Static ====');
                        }
                        if(p.Product_Type_Author_Facing__c  == 'Rule based'){
                            system.debug('==== Trig_SubmitToS3AndSNSOnProductApproval triggered Rule based ====');
                            TF_PPDProcessController.submitDynamicPackageToPCMasynch(p.Id);
                        }
                    }
                }
                if (p.RecordTypeId == PRODUCTRECORDTYPEID && p.Approval_Status__c=='Approved' && p.APIStatus__c == 'Success' && olpPrd.APIStatus__c != 'Success') {
                    if(p.originalProductId__c!=null && p.originalProductId__c!='')
                    {
                        String jobId = Database.executeBatch(new TF_Batch_updOriginalPrdDeleteBundelItms(p.originalProductId__c,p.Id), 9000);
                    }
                }
                if ( p.RecordTypeId == bespokeRecordTypeId && p.Dynamic_Collection_Criteria__c != NULL && olpPrd.Dynamic_Collection_Criteria__c != p.Dynamic_Collection_Criteria__c && 'Rule based'.equalsIgnoreCase(p.Product_Type_Author_Facing__c) ) { //SFAL-228 Vikas Varshney
                    TF_GetBespokeCountPCM.getBespokeCountToUpdatePBE(p.id, bespokeRecordTypeId, p.CurrencyIsoCode);
                }
                if ( p.RecordTypeId == bespokeRecordTypeId && p.Sales_Price__c != olpPrd.Sales_Price__c) { //SFAL-363 Radhikay Banerjee
                    TF_GetBespokeCountPCM.updatePriceBookEntryData(p.id, bespokeRecordTypeId, p.Sales_Price__c, p.CurrencyIsoCode);
                }
            } 
        }
    }
}