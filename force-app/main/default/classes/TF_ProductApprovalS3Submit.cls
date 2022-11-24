public class TF_ProductApprovalS3Submit {
    
    public static void putCollectionJsonToS3(String Id){   
        
        String jobId = Database.executeBatch(new TF_Batch_PlaceContentToProductHub(Id), 5000);
        system.debug('======TF_Batch_PlaceContentToProductHub jobId======'+ jobId);

    }
    
}