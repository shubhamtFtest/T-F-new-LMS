public class TF_ApprovedProdPcmSubmit {
    
public static void putStaticCollectionJsonToPCM(String Id){   
        
        String jobId = Database.executeBatch(new TF_Batch_SubmitStaticColToPcm(Id), 5000);
        system.debug('======TF_Batch_SubmitStaticColToPcm jobId======'+ jobId);

    }
}