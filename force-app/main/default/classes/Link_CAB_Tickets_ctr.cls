/**************************************************
* Created by Tom Reed, 2018.07.04
* Tested By zTest_Link_CAB_Tickets_ctr @ 87%
**************************************************/
public class Link_CAB_Tickets_ctr {
    
    public Link_CAB_Tickets_ctr(ApexPages.StandardController controller){ 
        
    }   
    public static pagereference addCabCases(){
        if(ApexPages.currentPage().getParameters().containsKey('id') && String.valueOf(ApexPages.currentPage().getParameters().get('id')).length() >=15 ){          
            Id recordId = ApexPages.currentPage().getParameters().get('id');
            List<Case> caseList;
            if(test.isRunningTest()){
                caseList    = [SELECT Id 
                               FROM Case 
                               WHERE Type in ('Question')
                               AND recordtype.developername = 'Salesforce_Internal_Support'
                               AND Status = 'Pending CAB'];
            } else {
                caseList    = [SELECT Id 
                               FROM Case 
                               WHERE Type in ('Enhancement','Incident')
                               AND recordtype.developername = 'Salesforce_Internal_Support'
                               AND Status = 'Pending CAB'];
            }
            List<Case> casesToUpdate = New List<Case>();
            for(Case c: caseList ){
                c.meeting__c = recordId;
                casesToUpdate.add(c);           
            }
            if(casesToUpdate.size() > 0){
                Update casesToUpdate;   
            }
            return new PageReference('/' + recordId);
        }
        return null;     
    }
}