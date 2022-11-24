/**************************************************
* Created by: Tom Reed: 2018-07-24
* Test method: zTest_DashboardTracker_ctr @81%
**************************************************/
public class DashboardTracker_ctr {
    
    public String userId {get;set;}
    
    public void getData(){ 
        userId = UserInfo.getUserId();
        Datetime currentDateTime = datetime.now();
        Date currentDate = date.newinstance(currentDateTime.year(), currentDateTime.month(), currentDateTime.day());
        Date dateToAdd = currentDate.toStartOfMonth(); 
        Dashboard_Tracking__c dashboardTrackingList;
        //If the user already has a record for the current month add to the count.
        try{
        dashboardTrackingList = [SELECT Id, View_Count__c FROM Dashboard_Tracking__c WHERE User__c =: userId AND View_Date__c =: dateToAdd LIMIT 1];
        }
        catch (exception e){
        system.debug('Error is ' + e.getMessage());   
        }
        if(dashboardTrackingList != null){
            dashboardTrackingList.View_Count__c = dashboardTrackingList.View_Count__c + 1;
            dashboardTrackingList.Last_Viewed_Date__c = currentDateTime;
            update dashboardTrackingList;
        } else {
            //Otherwise continue with creating a new record.
            Dashboard_Tracking__c newTrackerRecord = new Dashboard_Tracking__c(User__c=userId  ,View_Date__c=dateToAdd, View_Count__c = 1,Last_Viewed_Date__c = currentDateTime);
            insert newTrackerRecord;   
            
        }
    }       
}