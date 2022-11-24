public class TF_BatchHandleFailureFromPCM implements Schedulable {   
    
    public  void execute(SchedulableContext  SC) {
        list< Product2> ListProductItems = new list<Product2>(); 
        List<String> StatusLst = new List<String>{'Failure','Submit To PCM Failed'};
        Integer count=0;
        List<Product2> prdToUpdate = new List<Product2>();
        
        ListProductItems =[SELECT Id, Name, APIStatus__c,MaxReAttempts__c from Product2 where APIStatus__c in: StatusLst AND (MaxReAttempts__c<3 OR MaxReAttempts__c=NULL)];
        
        for (Product2 Pd : ListProductItems) {
            Product2 lineItem = new Product2();                        
            //TF_ProductApprovalS3Submit.putCollectionJsonToS3(Pd.Id);
            if(Pd.APIStatus__c == 'Failure'){
                String jobId = Database.executeBatch(new TF_Batch_PlaceContentToProductHub(Pd.Id), 5000);
                system.debug('======TF_Batch_PlaceContentToProductHub jobId======'+ jobId); 
            }else if(Pd.APIStatus__c == 'Submit To PCM Failed'){ 
                TF_PPDProcessController.submitDynamicPackageToPCM(pd.Id);
            }
            lineItem.Id=pd.Id;
            if(pd.MaxReAttempts__c!=NULL){ lineItem.MaxReAttempts__c= pd.MaxReAttempts__c+1;}           
            
            else{
                lineItem.MaxReAttempts__c=1;
            }
            prdToUpdate.add(lineItem);
        } 
        update prdToUpdate;     
        
    }
  
}