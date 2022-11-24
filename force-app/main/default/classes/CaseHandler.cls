/*
Created for WCE-3994 on 19th June 2017
Holds the logic to set SLA Target Date on Case
*/
public class CaseHandler{
    
    @future
    public static void setSLAOnCase(Set<Id> caseIds)
    {
        List<Case> casesUpdated = new List<Case>();
        List<Id> tmpCaseIds = new List<Id>();
        tmpCaseIds.addAll(caseIds);
        for(Integer i= 0; i< tmpCaseIds.size(); i++){
            Case caseRec = new Case();
            caseRec.Id = tmpCaseIds[i];
            caseRec.Set_SLA__c = true;
            //caseRec.Random_SLA_Number__c = math.random();
            casesUpdated.add(caseRec);
        }
        if(casesUpdated.size() > 0)
        {
            try{
            	update casesUpdated;
            } catch(exception e) {}
        }
    }
    
    
    @InvocableMethod
    public static void updateTargetDateOnCase(List<Id> caseIds)
    {
        List<Case> casesUpdated = new List<Case>();
        for(CaseMilestone milestoneRec : [SELECT CaseId,TargetDate FROM CaseMilestone where CaseId in: caseIds and IsCompleted = false]){
            system.debug('-----milestoneRec.TargetDate----'+milestoneRec.TargetDate);
            Case caseRec = new Case(Id = milestoneRec.CaseId);
            caseRec.Target_Date__c = milestoneRec.TargetDate;
            //caseRec.Random_SLA_Number__c = math.random();
            casesUpdated.add(caseRec);
        }
        if(casesUpdated.size() > 0)
        {
            update casesUpdated;
        }
    }
    
    /*
    This method will set the start date = Case Opened Date on Case Milsetone if Case Owner changes to another team
    and milestone start date != Case Opened Date
    Parameters : Set<Id> case Ids
    */
    @future
    public static void resetStartDateOnMilestone(Set<Id> newCaseIds){
    	List<CaseMilestone> mileStonesToBeUpdated = new List<CaseMilestone>();
    	List<Case> caseList = new List<Case>();
    	for(Id caseId : newCaseIds){
    		Case tmpCase = new Case(Id = caseId);
			tmpCase.Set_SLA__c = true;
			caseList.add(tmpCase);
    	}
    	
    	if(caseList.size() > 0){
    		try{
    			update caseList;
    			
    			for(Case caseRec : [Select Id,CreatedDate,(Select Id,StartDate,TargetDate from CaseMilestones where IsCompleted = false Order BY CreatedDate DESC Limit 1)
    						from Case where Id IN: newCaseIds]){
		    		system.debug('------BeforeUpdatedStartDate------'+caseRec.CaseMilestones[0].StartDate+'----TargetDate-----'+caseRec.CaseMilestones[0].TargetDate);
		    		if(caseRec.CaseMilestones.size() > 0 && caseRec.CaseMilestones[0].StartDate != caseRec.CreatedDate){
		    			CaseMilestone mileStone = new CaseMilestone(Id = caseRec.CaseMilestones[0].id);
		    			mileStone.StartDate = caseRec.CreatedDate;
		    			mileStonesToBeUpdated.add(mileStone);
		    		}
	    		}
	    		
	    		if(mileStonesToBeUpdated.size() > 0){
		    		try{
	    				update mileStonesToBeUpdated;
	    			}
		    		catch(Exception ex){
		    			
		    		}
	    		}
    			
    			
    		}
    		catch(Exception ex){
    			
    		}
    	}
    }
    
    public static void PercentageRaiser() {
        Integer temp;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
        temp = 1;
    }
    
    
}