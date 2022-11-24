/**************************************************
* Created by: Tom Reed: 2018-07-24
* Test methods for DashboardTracker_ctr
**************************************************/

@istest
public class zTest_DashboardTracker_ctr {
    
    Public Static testMethod void TestController(){          
        
        Id userId = UserInfo.getUserId();
        Datetime currentDateTime = datetime.now();
        Date currentDate = date.newinstance(currentDateTime.year(), currentDateTime.month(), currentDateTime.day());
        Date dateToAdd = currentDate.toStartOfMonth();
        
        Dashboard_Tracking__c newTrackerRecord = new Dashboard_Tracking__c(User__c=userId  ,View_Date__c=dateToAdd, View_Count__c = 1,Last_Viewed_Date__c = currentDateTime);
        insert newTrackerRecord;
        
        Test.startTest();       
        
        // set the test's page to my VF page
        Test.setCurrentPage(Page.DashboardTracker);
        // constructor call
        DashboardTracker_ctr controller = new DashboardTracker_ctr ();
        controller.getData();          
        Test.stopTest();
        
    }
    
}