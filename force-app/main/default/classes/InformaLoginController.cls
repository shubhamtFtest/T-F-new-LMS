/**
* Author     : Avinash Singh
* Company    : Informa
* Date       : 14/07/2017
* Test Class : zTest_InformaLoginController 100 %
* Description: Intermediate Page controller for redirecting user to the selected target org.
* Modified by:   
**/

Public Class InformaLoginController
{
    Public String orgName{get;set;}
    
    Public InformaLoginController()
    {
        orgName = 'Click here to login to ' + ApexPages.currentPage().getParameters().get('Org');
    }
       
    Public Pagereference click()
    {
        List<Salesforce_Org__c> tusr = [Select domain__c from Salesforce_Org__c where Name=:ApexPages.currentPage().getParameters().get('Org')];
        system.debug('test : '+tusr);
        String url = tusr[0].domain__c;
        Pagereference p = new Pagereference(url + '?username='+ApexPages.currentPage().getParameters().get('username'));
        system.debug(p);
        return p;     
    }
}