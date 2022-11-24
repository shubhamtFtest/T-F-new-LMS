/*
* Tested by zTest_Account_Usage_Denials @ 100%
* Created by Tom Reed - 2017.08.24 - CHG0037041
* Modified by Tom Reed - 2017.11.01 - CHG0039058
* Modified by Kam Chandi - 2021.28.06 - Case 01931858  (new fields added to query)
*/


public class Account_Usage_Denials_Ctr {
    
    public Usage_Denials__c UDdata {get; set;}
    
    public Account_Usage_Denials_Ctr (ApexPages.StandardController controller)
    { 
        
        if(ApexPages.currentPage().getParameters().containsKey('id') && String.valueOf(ApexPages.currentPage().getParameters().get('id')).length() >=15 ){
        
          List<Usage_Denials__c>  UDdatalist = [select Journals_Usage_YTD__c,
                      Journals_Usage_PYTD__c,
                      Journals_Unique_Usage_YTD__c,
                      Journals_Unique_Usage_PYTD__c,
                      Journals_Unique_Usage_Change__c,
                      Net_Bases_eBooks_Usage_PYTD__c,
                      Net_Bases_eBooks_usage_YTD__c,
                      Net_Bases_eBooks_Total_Usage_YTD__c,
                      Net_Bases_eBooks_Total_Usage_PYTD__c,
                      Net_Bases_eBooks_Total_Usage_Change__c,
                      TFE_eBooks_Usage_PYTD__c,
                      TFE_eBooks_Usage_YTD__c,
                      Journals_Usage_Change__c,
                      Net_Bases_eBooks_Denials_PYTD__c,
                      Net_Bases_eBooks_Denials_YTD__c,
                      TFE_eBooks_Denials_PYTD__c,
                      TFE_eBooks_Denials_YTD__c,
                      Journals_Denials_PYTD__c,
                      Journals_Denials_YTD__c,
                      Journals_Denials_Change__c,
                      Net_Bases_eBooks_Usage_Change__c,
                      Net_Bases_eBooks_Denials_Change__c,
                      TFE_eBooks_Usage_Change__c,
                      TFE_eBooks_Denials_Change__c,
                      Last_Refresh_Date__c, //CHG0039058    
                      UBX_Refresh_Date__c, // case: 01468515                 
                      Account__r.Mastervision__c
                      from Usage_Denials__c where Account__c = :ApexPages.currentPage().getParameters().get('id') limit 1]; 
                      
              if(UDdatalist!=null && UDdatalist.size() >0)
                  UDdata = UDdatalist[0];  
                        
        }
       
               
            
            
            
        }
    }