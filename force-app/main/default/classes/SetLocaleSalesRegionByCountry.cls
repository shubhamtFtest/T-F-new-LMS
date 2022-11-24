/**************************************************************
* Created by Shay Spoonmore (shay.spoonmore@informausa.com)20090122
* Modified by ....
**************************************************************/

public class SetLocaleSalesRegionByCountry {
    
    
    public static void setLead(Lead[] lead, String RecordtypePrefix)
    {
        for (Lead l:lead)
        {
    
            // GET Region and Locale
            for (CountryRegionLocaleMapping__c  CRL : [Select c.ISO_Country__c, c.ISO_Country__r.ISO_Code__c, c.ISO_Country__r.Name, c.Locale__c, c.Name, c.Sales_Region__c from CountryRegionLocaleMapping__c c 
                        Where c.ISO_Country__r.Name = :l.Country_List__c AND c.Name = :RecordtypePrefix]) 
            {
            
                System.debug('#############> existing RecordtypePrefix: '+ RecordtypePrefix + '-Country:' + CRL.ISO_Country__r.Name + '-Locale:' + CRL.Locale__c + '-Sales_Region:' + CRL.Sales_Region__c); 
        
        
                if (CRL.Locale__c != null)
                {l.Locale__c = CRL.Locale__c;}
        
                if (CRL.Sales_Region__c != null)
                {l.Sales_Region__c = CRL.Sales_Region__c;}
        
            }

        }
    }
}