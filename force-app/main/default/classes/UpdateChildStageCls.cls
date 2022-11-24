public class UpdateChildStageCls {
    
    @AuraEnabled
    public static string getDealInformation(Id recordID){
        string dealType=[select Deal_Type__c from opportunity where id =:recordID].Deal_Type__c;
        return dealType;
    }
    
    @AuraEnabled
    public static string updateStages(Id oppID){
        string output=OPP_UpdateChildStages.UpdateMembers(oppID);
        return output;
    }

}