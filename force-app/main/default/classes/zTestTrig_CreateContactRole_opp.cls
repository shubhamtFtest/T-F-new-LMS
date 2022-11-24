@istest
public class zTestTrig_CreateContactRole_opp
{   
    
    @isTest static void Trig_CreateContactRole_opp()
    {   
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Opportunity'); 
        TriggerInterfaceHelper.runTrigger('Trig_CreateContactRole_opp', 'Opportunity', 1, 'bi,bu',  oppRtId , null);   
        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id);
        List<String> opportunityIds=new list<string>();
        opportunityIds.add(opp.id);
        
        if(opp.Primary_Contact__c!=NULL)
        {
            OpportunityContactRole newContactRoleList= zTEST_Shared.insertOpportunityContactRole(opp.Id, c.Id, 'Test');
            newContactRoleList.IsPrimary = true;
            List<OpportunityContactRole> newContactRoleLists= new List<OpportunityContactRole>();
            newContactRoleLists.add(newContactRoleList);
            
            try {
                if(newContactRoleLists.size()>0)
                {
                    insert newContactRoleLists;
                    System.debug('created opportunity contact role for primary');
                    test.startTest();
                    Trig_CreateContactRole_opp.ResetPrimaryContact(opportunityIds);
                    update opp;
                    test.stopTest();
                    
                }
                
            } 
            catch (Exception e){
                System.assert(e.getMessage().contains('An error has occurred. Please contact your system administrator'));
                opp.adderror('An error has occurred. Please contact your system administrator.');
                
                
                
            }
            
            
        }//end if 
        
    }
    
}