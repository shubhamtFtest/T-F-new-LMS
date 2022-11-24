public class AsyncAutomateValidateIPQueueable implements Queueable, Database.AllowsCallouts{
    public Account accountRequest; 
    
    public AsyncAutomateValidateIPQueueable (Account accountReq ) {
        accountRequest = accountReq;
    }
     public void execute ( QueueableContext context ) {
     	List<TF_ValidateIPRangeCalloutController.DataWrapper> dRList = TF_ValidateIPRangeCalloutController.getCalloutResponseContents(accountRequest.id);
        if(dRList != null && dRList.size() > 0){
            for(TF_ValidateIPRangeCalloutController.DataWrapper thisDR : dRList){
                if(thisDR.status == 'Failed'){
                    System.debug('IP Validation Failed');
                }
            }
            
        }    
    }

}