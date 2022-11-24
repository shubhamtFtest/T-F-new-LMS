trigger UpdateProductHubIdForCollectionProduct on Product2 (after insert) {
    
    // recordtypeid for T&F - Collection
    Id PRODUCTRECORDTYPEID = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection'); 
    Id BESPOKEPRODUCTRECORDTYPEID = MiscFunctions.getRecordtypeId('Product2', 'T&F - BespokeCollection'); //SFAL-148
    
    // only fires for a single insert/update -- no bulk processing
    if (Trigger.new.size() == 1) {  
        
        for (Product2 p : Trigger.new) {
            // only do the update/insert if it is a T&F-Collection
            if ((p.RecordTypeId == PRODUCTRECORDTYPEID && p.version__c=='1.0.0') || p.RecordTypeId==BESPOKEPRODUCTRECORDTYPEID) {

                //TF_ProductHubWebServiceCallout.getHubId(p.Id);
                TF_ProductHubWebServicecallout_NewModel.getHubId(p.Id);
            }
        }   
    
    }

}