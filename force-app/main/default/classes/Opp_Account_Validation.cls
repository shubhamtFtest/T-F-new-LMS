public class Opp_Account_Validation implements TriggerInterface_Opp.Runnable{
    private static boolean run1 = true;
    
    public void run(TriggerInterface_Opp.Trig trig){
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F Automated eBooks Opportunity').getRecordTypeId();
        if(runOnce1()){
            if(trig.isAfter && (trig.isUpdate || trig.isInsert)){
                for(Opportunity opp : trig.newList){
                    if(opp.recordTypeId == oppRecordTypeId){
                        system.debug('AccountId '+opp.AccountId);
                        if(opp.AccountId != NULL && !system.isFuture()) validateUBXPlatformOnAccount(opp.AccountId, opp.id);
                    }
                } 
            }
        }
    } 
    
    @Future(callout=true)
    public static void validateUBXPlatformOnAccount(String accountId, String oppId){
        TF_ValidateUBXPlatformAccessApexCont.UBXDataWrapper UBXDataWrapperClassObj = new TF_ValidateUBXPlatformAccessApexCont.UBXDataWrapper();
        UBXDataWrapperClassObj = TF_ValidateUBXPlatformAccessApexCont.getCalloutResponseContents(accountId);
        system.debug('UBXDataWrapperClassObj '+UBXDataWrapperClassObj);
        Opportunity opp = [Select id, Account_Validate_Opp__c from Opportunity where id=: oppId];
        
        if(UBXDataWrapperClassObj != NULL && (UBXDataWrapperClassObj.hasIP || UBXDataWrapperClassObj.hasIDP || UBXDataWrapperClassObj.hasMFA)) opp.Account_Validate_Opp__c = true;
        else opp.Account_Validate_Opp__c = false;
        update opp;
    }
    
    public static boolean runOnce1(){
        if(run1){
            run1=false;
            return true;
        }
        else{
            return run1;
        }
    }
     
}