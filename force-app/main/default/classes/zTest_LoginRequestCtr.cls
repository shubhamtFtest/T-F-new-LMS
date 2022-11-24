/**
* Author     : Avinash Singh
* Company    : Informa
* Date       : 2017-03-16
* Class 	 : LoginRequestCtr 
* Description: For sending request approved notification mail to the requesting user.
* Modified by:   
**/

@isTest
public class zTest_LoginRequestCtr
{
    public static testmethod void AdminApprovenDecline()
    {
        
        
        Salesforce_Org__c so = new Salesforce_Org__c (User_Type__c = 'Integration User',Name='QuickSilver',ClientKey__c='3MVG9ZL0ppGP5UrA91pNZMs8eQ1qX6ejh2JBTdE4AMnYyWsp0HQxR_ATj6Wi6nIezzmP4Ye7CCcFfYOr8f5wL',Target_Oid__c='00D28000001OkO8EAK', ClientSecret__c='5405636128108993139', domain__c='https://quicksilver-dev-ed.my.salesforce.com', Email__c='kritika.1967@gmail.com', Org__c='QuickSilver', Password__c='cgiytr456', User_Name__c='quicksilver@marvels.com');                
        insert so;
        
        ApexPages.currentPage().getParameters().put('requested_uid', 'sdgadh' ); 
        ApexPages.currentPage().getParameters().put('requesting_uid', so.id );
        ApexPages.currentPage().getParameters().put('oid', '00D28000001OkO8EAK');
        
        LoginRequestCtr adap = new LoginRequestCtr();
        adap.userUpdate();
        adap.approveUserReq();
        adap.declineNotification();
       
        
    }
}