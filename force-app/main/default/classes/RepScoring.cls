/**************************************************
* Created by Tom Reed, 2018.05.30
* Tested By zTest_RepScoring @ 99%
* Updated By Matthew Smith | 2020.03.17 | Case 00990401,01110668 | Adding opportunities where the stage = "Aceptance" and the record type is "T&F - CAS Opportunity" to be excluded from "Open" opps. 
* Updated By Matthew Smith | 2020.12.09 | Case 01691041 | Excluding Opportunities where the Opportunity is GOBI, OASIS, UBX and/or Riato
**************************************************/

global class RepScoring {
    
    public static void runTargetData(list<String> userIdsToProcess ){       
        
        //Used To Set How Far Back To The Class Should Run
        Integer runLength = 90;
        date runDate = date.today();
        date YearBackDate = runDate - 365;  // To calculate 1 year old date 
        date runStartDate = runDate - runLength;
        system.debug(runStartDate);
        list<Id> profilesInScope = new list<Id>();
        set<Id> userIds = New set<Id>();
        map<Id, Date> userIdToStartDate = new map<Id, Date>();
        map<Id, Set<Date>> userIdToLoginsMap = new map<Id, Set<Date>>();
        set<Id> userIdLoggedInLastTwoWeeks = new set<Id>();
        map<Id, Double> userIdWithTotalOppsCount = new map<Id, Double>();
        map<Id, Double> userIdWithTotalOppsUpdatedLastThirtyCount = new map<Id, Double>();
        map<Id, Double> userIdWithTotalOppsWithStageAcceptance = new map<Id, Double>();
        map<Id, Double> userIdWithAverageDaysToClose = new map<Id, Double>();
        map<Id, Double> userIdWithTotalLeadsCount = new map<Id, Double>();
        map<Id, Double> userIdWithTotalLeadsConvertedInAWeekCount = new map<Id, Double>();
        map<Id, Boolean> userIdMemberOfSuperGroup = new map<Id, Boolean>();
        map<Id, Id> userIdToRepscorecardIdMap = new map<Id, Id>();
        map<Id, List<T_F_Scorecard__c>> repScoreIdToTnFScoreList = new map<Id, List<T_F_Scorecard__c>>(); //Map to store TF scorecard records against Rep scorecard record :Case 00990401
        
        for(User u: [SELECT Id FROM User WHERE Id in: userIdsToProcess]){
            userIds.add(u.Id);  
        }
        
        //If the user was created in the last 90 days use their created date, otherwise use the run start date.
        for(user u: [SELECT Id, CreatedDate FROM USER WHERE Id in: userIds AND IsActive = True]){            
            if(u.CreatedDate > runStartDate)
                userIdToStartDate.put(u.Id, date.newinstance(u.CreatedDate.year(), u.CreatedDate.month(), u.CreatedDate.day()));    
            else 
                userIdToStartDate.put(u.Id, runStartDate);           
        }
        //Get Logins Since runStartDate and Number of Logins Without Duplicates
        for(LoginHistory u: [SELECT Id, UserId, LoginTime 
                             FROM LoginHistory
                             WHERE UserId in: userIds 
                             AND (LoginTime >=: runStartDate) Order By LoginTime desc]){
                                 Set<Date> dateSet = new Set<Date>();
                                 //Start by adding the users start and end date into the set
                                 if(userIdToLoginsMap.containsKey(u.Userid)){   
                                     dateSet = userIdToLoginsMap.get(u.Userid);                                            
                                 }
                                 dateSet.add(date.newinstance(u.LoginTime.year(), u.LoginTime.month(), u.LoginTime.day()));  
                                 userIdToLoginsMap.put(u.UserId,dateSet);
                             }    
        //Get Chatter Group And Members
        List<CollaborationGroup> chatterGroup = [SELECT Id 
                                                 FROM CollaborationGroup 
                                                 Where Name = 'T&F Salesforce Feedback Group' LIMIT 1];
        List<CollaborationGroupMember> chatterGroupMembers = new List<CollaborationGroupMember>();
        if(chatterGroup.size() >0){
            chatterGroupMembers = [SELECT MemberId 
                                   FROM CollaborationGroupMember 
                                   WHERE CollaborationGroupId =: chatterGroup];
        }
        Set<Id> chatterGroupUserIdSet = new set<Id>();
        for(CollaborationGroupMember cgm: chatterGroupMembers){
            system.debug('Group Member ' + cgm.MemberId);
            chatterGroupUserIdSet.add(cgm.MemberId);  
        }
        //Get If User Is Member Of Chatter Group
        for(User u: [SELECT Id FROM User WHERE Id in: userIds]){
            if(chatterGroupUserIdSet.contains(u.id)){
                system.debug('Running User ' + u.Id);
                userIdMemberOfSuperGroup.put(u.id, True);
            }
        }             
        
        //Get Total Open Opportunities Create Since The runStartDate By User
        for(AggregateResult ar: [SELECT Count(id) mycount, Ownerid
                                 FROM Opportunity 
                                 WHERE Ownerid in: userIds AND (CreatedDate >=: runStartDate or CreatedDate =: runDate) AND ((IsClosed = False) AND (StageName != 'Acceptance' OR RecordType.DeveloperName != 'CASCourseOpportunities')) AND ((NOT Name LIKE 'GOBI%') AND (NOT Name LIKE 'OASIS%') AND (NOT Name LIKE 'UBX eBooks%') AND (NOT Name LIKE 'Riato%')) group by Ownerid ]){ //Excluding Closed Opps and Opps which have the stage "Acceptance" when the record type is "T&F - CAS Opportunity" //Now excluding GOBI, OASIS, UBX and Riato Opportunities
                                    System.debug('@@total@@'+ar.get('mycount'));
                                     userIdWithTotalOppsCount.Put((Id) ar.get('Ownerid'),(Double) ar.get('mycount'));                                                               
                                 }
        
        //Get Total Open Opportunities Update In The Last 30 Days But Created Since The runStartDate
        for(AggregateResult ar: [SELECT Count(id) mycount, Ownerid
                                 FROM Opportunity 
                                 WHERE Ownerid in: userIds  
                                 AND (LastModifiedDate = LAST_N_DAYS:30 OR LastModifiedDate =: runDate) AND ((IsClosed = False) AND (StageName != 'Acceptance' OR RecordType.DeveloperName != 'CASCourseOpportunities') AND (NOT Name LIKE 'GOBI%')) AND ((NOT Name LIKE 'OASIS%') AND (NOT Name LIKE 'UBX eBooks%') AND (NOT Name LIKE 'Riato%')) //Excluding Closed Opps and Opps which have the stage "Acceptance" when the record type is "T&F - CAS Opportunity" //Now excluding GOBI, OASIS, UBX and Riato Opportunities
                                 AND ( CreatedDate >=: runStartDate or CreatedDate =: runDate) group by Ownerid]){
                                     System.debug('@@notmodif@@'+ar.get('mycount'));
                                     userIdWithTotalOppsUpdatedLastThirtyCount.Put((Id) ar.get('Ownerid'),(Double) ar.get('mycount'));                                                               
                                 }      
        system.debug('@user@'+userIds);
        
        //Get Sum of Days To Close On Opportunities Create Since runStartDate 
        for(AggregateResult ar: [SELECT Avg(Age__c) myAverage, Ownerid
                                 FROM Opportunity 
                                 WHERE Ownerid in: userIds AND (CreatedDate >=: runStartDate or CreatedDate =: runDate) AND ((IsClosed = True) OR (StageName = 'Acceptance' AND RecordType.DeveloperName = 'CASCourseOpportunities')) AND ((NOT Name LIKE 'GOBI%') AND (NOT Name LIKE 'OASIS%') AND (NOT Name LIKE 'UBX eBooks%') AND (NOT Name LIKE 'Riato%')) group by Ownerid ]){ //Including Closed Opps and Opps which have the stage "Acceptance" when the record type is "T&F - CAS Opportunity" //Now excluding GOBI, OASIS, UBX and Riato Opportunities
                                     userIdWithAverageDaysToClose.Put((Id) ar.get('Ownerid'),(Double) Double.valueof(ar.get('myAverage')));                                                               
                                 }
        
        
        //Get Leads Created in Last runLength Days and Converted In Under 7 Days
        for(AggregateResult ar: [SELECT count(id) myCount, Ownerid
                                 FROM Lead
                                 WHERE Ownerid in: userIds AND IsConverted = True AND Age__c <= 7 AND ( CreatedDate >=: runStartDate or CreatedDate =: runDate) group by Ownerid]){
                                     userIdWithTotalLeadsConvertedInAWeekCount.Put((Id) ar.get('Ownerid'),(Double) Double.valueof(ar.get('myCount')));                                                               
                                 }  
        //Get All Leads Created Since runStartDate and Converted
        for(AggregateResult ar: [SELECT count(id) myCount, Ownerid
                                 FROM Lead
                                 WHERE Ownerid in: userIds AND IsConverted = True AND (CreatedDate >=: runStartDate or CreatedDate =: runDate) group by Ownerid]){
                                     userIdWithTotalLeadsCount.Put((Id) ar.get('Ownerid'),(Double) Double.valueof(ar.get('myCount')));                                                               
                                 }  
        
        
        //Use The Existing Rep Scorecard Record If The User Is Known
        For(Rep_ScoreCard__c rs: [SELECT Id,(Select id,Name,CreatedDate from T_F_Scorecards2__r), User__c FROM Rep_ScoreCard__c WHERE User__c in: userIds]){
            userIdToRepscorecardIdMap.put(rs.User__c, rs.Id);   
            system.debug('@@TFListSize@@'+rs.T_F_Scorecards2__r.size());
            repScoreIdToTnFScoreList.put(rs.Id,rs.T_F_Scorecards2__r);
        }
        
        List<Rep_ScoreCard__c> scorecardRecordsToInsert = New List<Rep_ScoreCard__c>();
        //Create The Rep Scorecard Records If The User Is New, Then Add It To The Map For Later Use
        For(User rs: [SELECT Id, FirstName, LastName FROM User WHERE id in: userIds]){
            If(userIdToRepscorecardIdMap.size() == 0 || !userIdToRepscorecardIdMap.containskey(rs.id)){
                Rep_ScoreCard__c newScorecardRecord = New Rep_ScoreCard__c(Name = rs.FirstName + ' ' + rs.LastName, User__c = rs.Id, OwnerId = rs.Id);    
                scorecardRecordsToInsert.add(newScorecardRecord);                                  
            }
        }
        If(scorecardRecordsToInsert.size()>0){
            insert scorecardRecordsToInsert;
        }
        
        // Mark The Old Records For The Users To Not Be The Latest Scorecard Record
        List<T_F_Scorecard__c> scorecardsToUnFlag = New List<T_F_Scorecard__c>();       
        For(T_F_Scorecard__c scoreCardRecords: [SELECT Id FROM T_F_Scorecard__c WHERE User__c in: userIds]){
            scoreCardRecords.Latest_Scorecard__c = FALSE;
            scorecardsToUnFlag.add(scoreCardRecords);            
        }
        //Update Is Completed After The New Records Are Inserted To Ensure Nothing Fails
        
        For(Rep_ScoreCard__c rScorecard: scorecardRecordsToInsert){
            userIdToRepscorecardIdMap.put(rScorecard.User__c, rScorecard.Id);                
        }                          
        
        List<T_F_Scorecard__c> scoringRecordsToAdd = new List<T_F_Scorecard__c>();
        for(User u: [SELECT Id, FirstName, LastName FROM User WHERE Id in: userIds]){ 
            T_F_Scorecard__c scoringRecord = new T_F_Scorecard__c();
            scoringRecord.User__c = u.Id;
            scoringRecord.Run_Date__c = runDate;
            scoringRecord.Latest_Scorecard__c = TRUE;
            scoringRecord.Name = u.FirstName + ' ' + u.LastName + ' - ' + 'Scorecard' + ' - ' + String.ValueOf(runDate);
            scoringRecord.Rep_Scorecard__c = userIdToRepscorecardIdMap.get(u.id);
            
            //Is The Users Average Login <= 7 or <= 14
            if(userIdToStartDate.ContainsKey(u.id) && userIdToLoginsMap.ContainsKey(u.Id)){
                Integer loginCount = userIdToLoginsMap.get(u.Id).size();
                if(userIdToStartDate.get(u.id).daysbetween(runDate)/(loginCount + 1) <= 7) 
                    scoringRecord.Login_Last_7_Value__c = 1; 
                else 
                    scoringRecord.Login_Last_7_Value__c = 0;
                if(userIdToStartDate.get(u.id).daysbetween(runDate)/(loginCount + 1) > 7 && userIdToStartDate.get(u.id).daysbetween(runDate)/(loginCount + 1) <= 14) 
                    scoringRecord.Login_Last_14_Value__c = 1; 
                else 
                    scoringRecord.Login_Last_14_Value__c = 0;
            }                          
            
            //User Is Member Of Chatter Group
            if(userIdMemberOfSuperGroup.containskey(u.id)) scoringRecord.Feedback_Group_Value__c = 1; 
            else scoringRecord.Feedback_Group_Value__c = 0;    
            
            //Average Days To Close
            if(userIdWithAverageDaysToClose.containskey(u.id)) scoringRecord.Opportunity_Average_Days_to_Close__c = userIdWithAverageDaysToClose.get(u.Id); 
            else scoringRecord.Opportunity_Average_Days_to_Close__c = -1;  //To identify users who have no opportunities from those who score a 0
            
            //% Of Opps Not Updated In Last 30 Days : Updated as per case 01110668
            if(userIdWithTotalOppsCount.containskey(u.id)) {
                if(userIdWithTotalOppsUpdatedLastThirtyCount.containskey(u.id)){
                    scoringRecord.Percent_opportunities_not_modified__c = 
                            decimal.valueof(((userIdWithTotalOppsCount.get(u.Id) - userIdWithTotalOppsUpdatedLastThirtyCount.get(u.Id))/
                                             userIdWithTotalOppsCount.get(u.Id))*100).setscale(2);

                    system.debug('@@inside@@'+scoringRecord.Percent_opportunities_not_modified__c); 
                }
                else
                    scoringRecord.Percent_opportunities_not_modified__c = 100; 
            } else scoringRecord.Percent_opportunities_not_modified__c = 0;  
            
            //% Leads Converted In Under A Week
            if(userIdWithTotalLeadsCount.containskey(u.id) && userIdWithTotalLeadsConvertedInAWeekCount.containskey(u.id)){
                scoringRecord.Percent_leadsnotconvertedinweek__c = 
                    decimal.valueof(((userIdWithTotalLeadsCount.get(u.Id) - userIdWithTotalLeadsConvertedInAWeekCount.get(u.Id))/
                                     userIdWithTotalLeadsCount.get(u.Id))*100).setscale(2);   
            } else scoringRecord.Percent_leadsnotconvertedinweek__c = 0;  
            
            ScoringRecordsToAdd.add(scoringRecord);
        }
        if(ScoringRecordsToAdd.size()> 0) insert ScoringRecordsToAdd; 
        if(scorecardsToUnFlag.size()> 0) update scorecardsToUnFlag;

    }
    
}