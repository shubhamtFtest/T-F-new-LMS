/*
Created for WCE-3994.
Extension controller for SLA timer on Case
*/
public class CaseSLAExtensions {
    
    Case caseRec = new Case();
    public CaseSLAExtensions(ApexPages.StandardController controller) {
        caseRec = [Select Id,Target_Date__c,IsClosed from Case where Id =: ApexPages.currentPage().getParameters().get('id')];
    }
    // method called from Page laod , it will set Target Date on case
    public void updateTargetDateOnCase(){
        
        List<CaseMilestone> milestoneRec = new List<CaseMilestone>();
        if(caseRec.IsClosed == false)
        {
            milestoneRec = [SELECT CaseId,TargetDate FROM CaseMilestone where CaseId =: caseRec.Id and IsCompleted = false];
            // After Case Owner change update correct Traget Date on Case
            if(milestoneRec.size() > 0)
            {
                if(milestoneRec[0].TargetDate != caseRec.Target_Date__c)
                {
                    caseRec.Target_Date__c = milestoneRec[0].TargetDate;
                    //caseRec.Random_SLA_Number__c = math.random();
                    update caseRec;
                }
            }
            
        }
    }

}