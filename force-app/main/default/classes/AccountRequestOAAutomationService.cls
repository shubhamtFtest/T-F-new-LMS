public class AccountRequestOAAutomationService implements Queueable, Database.AllowsCallouts {
    public Account accountRequest; 
    
    public AccountRequestOAAutomationService (Account accountReq ) {
        accountRequest = accountReq;
    }
    
    public void execute ( QueueableContext context ) {
        List<TF_AccountEnrichmentApexController.DataValueRec> dataChangeList = new List<TF_AccountEnrichmentApexController.DataValueRec>();
        System.debug('accountRequest'+accountRequest);
        
        	List<TF_AccountEnrichmentApexController.FieldData> fieldData = TF_AccountEnrichmentApexController.getCalloutResponseContents(accountRequest.id, accountRequest.Ringgold_Account_ID__c);
        	System.debug('fieldData: '+fieldData);
        	if(fieldData != null){
        		for(TF_AccountEnrichmentApexController.FieldData thisfieldData : fieldData){
            		TF_AccountEnrichmentApexController.DataValueRec thisDV = new TF_AccountEnrichmentApexController.DataValueRec();	
        			thisDV.fieldAPIName = thisfieldData.fieldAPIName;
                	thisDV.isEqualData = true;
                	dataChangeList.add(thisDV);
            	}
                System.debug('dataChangeList: '+dataChangeList);
            	if(dataChangeList != null && dataChangeList.size() > 0){
                	TF_AccountEnrichmentApexController.updateAccFields(JSON.serialize(dataChangeList), accountRequest.id, JSON.serialize(fieldData));
            		
                }
        	} 
        	if(!test.isRunningTest()){
            	Id automateValidateIPJobId = System.enqueueJob( new AsyncAutomateValidateIPQueueable( accountRequest ));
            }
    }
}