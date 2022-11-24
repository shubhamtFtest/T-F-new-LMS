trigger TF_Case_PopulateSLA on Case (before insert, after insert, after update) {
    Set<Id> caseIds = new Set<Id>();
    Set<Id> newCaseIds = new Set<Id>();
    List<Entitlement> entList = new List<Entitlement>();
    entList = [Select Id,Name from Entitlement where Name = 'T&F SLA' limit 1];
    List<Id> updateCases = new List<Id>();
    Map<ID,Schema.RecordTypeInfo> rt_Map = Case.sObjectType.getDescribe().getRecordTypeInfosById();
    
    
    for (Case c : Trigger.new) {
        
        // swith created to control the SLA functionality
        if(system.label.Switch_For_SLA == 'On')
        {
            // logic will work only for 'T&F - CSD' case record types
            if(rt_map.get(c.recordTypeID).getName().containsIgnoreCase('T&F - CSD') || rt_map.get(c.recordTypeID).getName().containsIgnoreCase('T&F - Sales') || rt_map.get(c.recordTypeID).getName().containsIgnoreCase('T&F - Prod') || rt_map.get(c.recordTypeID).getName().containsIgnoreCase('T&F - US') || rt_map.get(c.recordTypeID).getName().containsIgnoreCase('T&F - eBooks'))
            {
                if(trigger.isBefore && trigger.isInsert)
                {
                    if(entList.size() > 0)
                    c.EntitlementId = entList[0].Id;
                }
                if(trigger.isAfter && trigger.isInsert)
                {
                    caseIds.add(c.Id);
                }
                if(trigger.isUpdate && trigger.isAfter)
                {
                    Case oldCase = new Case();
                    oldCase = Trigger.OldMap.get(c.Id);
                    if(c.Status == 'Re - Opened' && c.Status != oldCase.Status)
                    {
                        caseIds.add(c.Id);
                    }
                    // logic for Team change , SLA will reflected correctly
                    if(c.OwnerId != oldCase.OwnerId && string.ValueOf(c.OwnerId).startsWith('00G'))
                    {
                        //for Re-Opened cases
                        if(c.Status != 'New'){
                            caseIds.add(c.Id);
                        }
                        //for New cases
                        else{
                            newCaseIds.add(c.Id);
                        }
                    }
                    // once case is Closed , auto-complete the milestone
                    if (((c.isClosed == true)||(c.Status == 'Closed'))&&((c.SlaStartDate <= system.now())&&(c.SlaExitDate == null)))
                    {
                        updateCases.add(c.Id);
                    }
                }
            }
        }
        
    }
    if(caseIds.size() > 0)
    {
        CaseHandler.setSLAOnCase(caseIds);
    }
    if(updateCases.size() > 0)
    {
        milestoneUtils.completeMilestone(updateCases);
    }
    //Scenario for New cases
    if(newCaseIds.size() > 0){
        CaseHandler.resetStartDateOnMilestone(newCaseIds);
    }
}