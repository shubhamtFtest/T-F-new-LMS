/**************************************************
* Created by Tom Reed, 2018.08.10
* Tested By zTest_RepScoring @ 100%
* Updated by Matthew Smith and Tom Reed on 2020.03.23 (01110668, 00990401)
**************************************************/

global class ScheduleRepScorecard implements Schedulable{
    
    // ******* TR ******* //
    public set<User> userIds;
    
    global void execute(SchedulableContext SC) {    
        
        list<Id> profilesInScope = new list<Id>();
        
        //Initialize The Users
        List<Setting__c> sr = [SELECT ID FROM Setting__c WHERE Name = 'RepScoringProfiles'];   
        List<Setting_Item__c> si = [SELECT Text_1__c FROM Setting_Item__c WHERE Setting__c in: sr];
        for(Setting_Item__c p: si){           
            profilesInScope.add(p.Text_1__c);   
        }
        
        //Users In Scope. While running the test class it will provide the user ids to run, otherwise the logic below will identify which users to run for.
        if (!test.isRunningTest()) {        
        userIds = new Set<User>();
        for(User u: [SELECT Id, CreatedDate FROM USER WHERE ProfileId in: profilesInScope AND IsActive = True]){            
            userIds.add(u);
        }
        }
        list<String> userIdsToRun;
        Integer leftToRun = userIds.size();
        for(User u: userIds){
            //If first run instantiate the list.
            If(leftToRun == userIds.size()){userIdsToRun = new List<String>();}
            leftToRun = leftToRun - 1;
            userIdsToRun.add(u.Id);
            //If the list gets to 10 start processing in the future method.
            if(userIdsToRun.size() == 10 || leftToRun == 0){
                runRepScorecardClass(userIdsToRun); 
                userIdsToRun = new List<String>();
            }               
        }
    }
    
    @Future
    Public static void runRepScorecardClass(list<String> userIdsToRun){
        system.debug('bbbbbbbbbb: ' + userIdsToRun);
        RepScoring.runTargetData(userIdsToRun);       
    }
}