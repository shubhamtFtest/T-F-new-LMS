/**************************************************
* Created by Tom Reed
* Test methods for Controller_Account_Usage_and_Denials
**************************************************/

@istest
public class zTest_Account_Usage_Denials {
 
    Public Static testMethod void TestController(){   
        
        // Create a test account    
        Account Acc = New Account();
        Acc.Name = 'Test Account123';
        Acc.Phone = '55555555555';
        Acc.type = 'Customer';
        Acc.Classification__c = 'Institution';
        Acc.Mailing_Country_List__c = 'United Kingdom';
        Acc.Locale__c = 'EMEA';
        Acc.Sales_Region__c  = 'United Kingdom';
        Acc.HE_Sales_Territory__c = 'London';
        Acc.Shipping_Country_List__c  = 'United Kingdom';
        Insert Acc;
            
        // Create test Usage and Denials data
        Usage_Denials__c UandD = New Usage_Denials__c();
        UandD.Account__c = Acc.id;
        UandD.Journals_Usage_YTD__c = 10;
        UandD.Journals_Usage_PYTD__c = 100;  
        UandD.Journals_Denials_PYTD__c = 50;
        UandD.Journals_Denials_YTD__c = 30;
        UandD.Net_Bases_eBooks_Usage_PYTD__c = 1;
        UandD.Net_Bases_eBooks_Denials_PYTD__c = 25;
        UandD.Net_Bases_eBooks_Denials_YTD__c = 1;
        UandD.Net_Bases_eBooks_usage_YTD__c = 33;
        UandD.TFE_eBooks_Denials_PYTD__c = 12345;
        UandD.TFE_eBooks_Denials_YTD__c = 7;
        UandD.TFE_eBooks_Usage_PYTD__c = 10;
        UandD.TFE_eBooks_Usage_YTD__c = 44;                  
        Insert UandD;
                
        System.debug(Acc);        
        System.debug(UandD); 
         
        Test.startTest();       
             
        // set the test's page to my VF page
        Test.setCurrentPage(Page.TF_Account_Usage_and_Denials);
        ApexPages.currentPage().getParameters().put('id',Acc.Id);
        // constructor call
        Account_Usage_Denials_Ctr controller = new Account_Usage_Denials_Ctr (new ApexPages.StandardController(Acc));
        
        // Validate the results        
        System.assertEquals(10, Controller.UDdata.Journals_Usage_YTD__c);        
        System.assertEquals(44, Controller.UDdata.TFE_eBooks_Usage_YTD__c ); 
        System.assertEquals(33, UandD.Net_Bases_eBooks_usage_YTD__c ); 
        System.assertEquals(1, UandD.Net_Bases_eBooks_Denials_YTD__c  ); 
             
        Test.stopTest();
       
    }
   
}