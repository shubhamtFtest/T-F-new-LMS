/*
Created for WCE-3994 on 19th June 2017
It holds the logic to complete the Milestone when Case is Closed
*/
public class milestoneUtils {
    
    public static void completeMilestone(List<Id> caseIds) {
        
        List<CaseMilestone> cmsToUpdate = new List<CaseMilestone>();
        for(CaseMilestone milestoneRec : [select Id, completionDate from CaseMilestone
                                         where caseId in :caseIds and completionDate = null ])
        {
            milestoneRec.completionDate = system.now();
            cmsToUpdate.add(milestoneRec);
        }
        if(cmsToUpdate.size() > 0)
            update cmsToUpdate;
        }
    
}