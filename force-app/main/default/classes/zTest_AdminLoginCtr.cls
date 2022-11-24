/**
* Author     : Avinash Singh
* Company    : Informa
* Date       : 2017-03-15
* Class 	 : AdminLoginCtr 
* Modified by:   
**/

@isTest
public class zTest_AdminLoginCtr
{
    public static testmethod void AdminLoginCtr() 
    {
        
        AdminLoginCtr adOrg = new AdminLoginCtr();        
        
        AdminLoginCtr.deserializeResponse deserial = new AdminLoginCtr.deserializeResponse();
       // deserial.id = 'https://informakn--DevGirikon.cs88.my.salesforce.com/00D9E0000000VxT/0059E000001B1E6';
        //deserial.access_token='1750719156243900593';
        
        deserial.id = 'https://login.salesforce.com/id/00D28000001OkO8EAK/00528000003nx4mAAA';
        deserial.access_token = '00D28000001OkO8!ARcAQOe8RnFO8mVASOR_QA2';
        
        AdminLoginCtr.UserDetails usrDet = new AdminLoginCtr.UserDetails();
        usrDet.id = 'tets' ;
        usrDet.FirstName = 'tets';
        usrDet.LastName = 'tets';
        usrDet.UserName = 'tets';
        usrDet.isActive = true;
        usrDet.Email = 'tets@js.com';
        
        adOrg.requesting_userid = 'testuserid';
        adOrg.requesting_uname = 'testid';
        
        
        Salesforce_Org__c so = new Salesforce_Org__c(Name='KN Devgirikon',ClientKey__c='3MVG9lcxCTdG2Vbst29c12EPEE7aCEORZZjZ6dSbStREgYSZsUz.77ClbYk816Zzcq1T1HGl4mxn0XvEiflpT',Target_Oid__c='00D9E0000000VxT', ClientSecret__c='1750719156243900593', domain__c='https://informakn--DevGirikon.cs88.my.salesforce.com', Email__c='avinash.c.singh@informa.com', Password__c='Test@12345', User_Name__c='lma@informa.com.kn.devgirikon');        
        
        insert so;
        adOrg.configId = so.id;
        adOrg.requested_userid = '00528000003o1f3AAA';
        
        adOrg.getItems();                  
        adOrg.getToken(so);  
        adOrg.Next();   
        adOrg.deactivate();
                                      
    }
}