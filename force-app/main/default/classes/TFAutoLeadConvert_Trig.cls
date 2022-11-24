/*
Trigger class for Auto-Lead convert project (CHG0036304)
Created By Mindtree.com

Updated By Faiz Ali - 30/10/2019- To accomodate the changes for US ebooks and Print product Lead Auto convert (01392135)
Updated By Sourabh Goyal and Matthew Smith - 22/10/2020 - Updating Auto Convert to use Custom Settings for Enrollment and Price (01574264)
-------------------------------------------------------------------------------------
Updated by Renil 		- 14.12.2021 for user story [SAL-4582]. 
	[SAL-4582] change 1 - A Bypass rule checkbox in the custom setting. If checked, the lead should bypass all rules apart from the lead being an existing contact and the contact not being a book grabber. 	
	[SAL-4582] change 2	- Allow users to retry lead auto convert by checking a checkbox in lead.
-------------------------------------------------------------------------------------
Updated by Renil - 2022/05/16 - Lead auto convert to support only if the 'Book Requested type is ebook' and 'Order type is e-inspection copy'
-------------------------------------------------------------------------------------
*/
public class TFAutoLeadConvert_Trig implements TriggerInterface_Lead.Runnable 
{ 
    public void run(TriggerInterface_Lead.Trig trig) 
    {
        
        LeadConvertFailHandler lobj=new LeadConvertFailHandler();
        //TF_LeadConvert_Countries__c
        Map<String,TF_LeadConvert_Countries__c> MapCountryLC_C= new Map<string,TF_LeadConvert_Countries__c>();
        List<TF_LeadConvert_Countries__c> ListLC_C=[select id,Name,Anticipated_Enrollment__c,Price_GBP__c, Bypass_Rules__c from TF_LeadConvert_Countries__c];
        
        for(TF_LeadConvert_Countries__c CountryLC_C : ListLC_C)
        {
            MapCountryLC_C.put(CountryLC_C.Name,CountryLC_C);
        }
        
        /*Schema.DescribeSObjectResult leadSchema = Schema.SObjectType.Lead; 
        Map<String,Schema.RecordTypeInfo> leadRecordTypeInfo = leadSchema.getRecordTypeInfosByName(); 
        Id leadrtId = leadRecordTypeInfo.get('T&F - Leads').getRecordTypeId();*/
        
        //    T_F_Lead_Source_Webform_Mapping__c setting = T_F_Lead_Source_Webform_Mapping__c.getInstance();
        //   Boolean IsMappingOn = setting.IsMappingOn__c;
        
        Map<String, TF_LeadConvert_Countries__c> allowedCountries = new Map<String, TF_LeadConvert_Countries__c>();
        
        // Map and List to fetch the print premium countries Custom Metadata for Lead Auto Convert
        Map<String, T_F_Print_Auto_Lead_Convert_Country__mdt> allowedCountriesPremium = new Map<String, T_F_Print_Auto_Lead_Convert_Country__mdt>();
        List<T_F_Print_Auto_Lead_Convert_Country__mdt> ListCustomMtdtCountries= new list<T_F_Print_Auto_Lead_Convert_Country__mdt>([SELECT MasterLabel, DeveloperName, Anticipated_Enrollment__c,Price_GBP__c FROM T_F_Print_Auto_Lead_Convert_Country__mdt]);
        
        for(T_F_Print_Auto_Lead_Convert_Country__mdt mtdt : ListCustomMtdtCountries)
        {
            allowedCountriesPremium.put(mtdt.MasterLabel, mtdt);
        }
        System.debug('allowedCountriesPremium '+allowedCountriesPremium);
        allowedCountries 						= TF_LeadConvert_Countries__c.getAll();
        Set<Id> leadIds 						= new Set<Id>();
        Set<Id> leadIdsforBypass				= new Set<Id>();
        map<Id,string> failedleadIdsErrorMap 	= new map<Id,string>();
        
        for(Lead leadRec : trig.newList)
        {
            // we have to execute Auto-Convert logic only on After Insert/Update event If Bypass is true then ignore all failure reasons
            // else check for faliure reasons - ** [SAL-4582] change 1(if block) and change 2(elseif block)**
            system.debug('before if statement');
            system.debug('Lead Record Country List: ' + leadRec.Country_List__c);
            system.debug('Lead Record Country List Map: ' + MapCountryLC_C.get(leadRec.Country_List__c));
            
            if(MapCountryLC_C.get(leadRec.Country_List__c) != null) 
            { //this is needed as if the custom setting doesn't have the lead records country, the lead won't be able to save.
                if((trig.isAfter && trig.isInsert && MapCountryLC_C.get(leadRec.Country_List__c).Bypass_Rules__c == TRUE && leadRec.Book_Requested_Type__c == 'eBook' && leadRec.Order_Type__c == 'e-Inspection Copy')//&& leadRec.Book_Requested_Type__c != 'Print' && leadRec.Order_Type__c != 'Corporate' 
                   || (trig.isAfter && trig.isUpdate && MapCountryLC_C.get(leadRec.Country_List__c).Bypass_Rules__c == TRUE && leadRec.Retry_Lead_Auto_Convert__c == true && leadRec.Status != 'Qualified' && leadRec.Book_Requested_Type__c == 'eBook' && leadRec.Order_Type__c == 'e-Inspection Copy'))//leadRec.Book_Requested_Type__c != 'Print' && leadRec.Order_Type__c != 'Corporate'      
                {
                    system.debug('after statement, before execution');
                    leadIdsforBypass.add(leadRec.Id);
                }
                else if (trig.isAfter && (trig.isInsert || ( trig.isUpdate  && leadRec.Retry_Lead_Auto_Convert__c == true && leadRec.Status != 'Qualified')))
                {  
                    //lead auto convert logic to include eBook Products     
                    DateTime d1 = leadRec.CreatedDate.addYears(3);   
                    //check for CAS & Allowed Country conditions
                    if(leadRec.Business__c.contains('CAS')&&
                       allowedCountries.containsKey(leadRec.Country_List__c)&&
                       leadRec.Delivery_Instructions__c == null &&
                       leadRec.Book_Requested_Type__c == 'eBook' && leadRec.Order_Type__c == 'e-Inspection Copy' && leadRec.Course_Start_Date__c < d1)//leadRec.Book_Requested_Type__c != 'Print' && leadRec.Order_Type__c != 'Desk Copy Review' && leadRec.Order_Type__c != 'Corporate' 
                    {
                        if(leadRec.Price_GBP__c<=MapCountryLC_C.get(leadRec.Country_List__c).Price_GBP__c && leadRec.Anticipated_Enrollment__c>=MapCountryLC_C.get(leadRec.Country_List__c).Anticipated_Enrollment__c && MapCountryLC_C.get(leadRec.Country_List__c).Bypass_Rules__c == FALSE)
                        {    
                            leadIds.add(leadRec.Id);
                        }
                        
                        system.debug('In If');
                        if(leadRec.Anticipated_Enrollment__c < MapCountryLC_C.get(leadRec.Country_List__c).Anticipated_Enrollment__c)
                        {
                            failedleadIdsErrorMap.put(leadRec.id,lobj.errorMsgOne);
                            
                        }
                        
                        if(leadRec.Price_GBP__c > MapCountryLC_C.get(leadRec.Country_List__c).Price_GBP__c)
                        {
                            failedleadIdsErrorMap.put(leadRec.id,lobj.errorMsgSecond);
                        }
                    }
                    
                    //lead auto convert logic to include Print Products for US with Text type Premium and Premium Plus   
                    else if(leadRec.Text_Type__c != null && leadRec.Text_Type__c != '')
                    {
                        system.debug('test class line 48'+leadRec.Text_Type__c);
                        if(leadRec.Business__c.contains('CAS')&&
                           allowedCountriesPremium.containsKey(leadRec.Country_List__c)&&
                           leadRec.Delivery_Instructions__c == null &&
                           (leadRec.Book_Requested_Type__c == 'Print' || leadRec.Book_Requested_Type__c == 'eBook') && (leadRec.Text_Type__c.containsIgnoreCase('premium') || leadRec.Text_Type__c.containsIgnoreCase('premium plus')) && leadRec.Order_Type__c == 'e-Inspection Copy' && leadRec.Course_Start_Date__c < d1)// leadRec.Order_Type__c != 'Desk Copy Review' && leadRec.Order_Type__c != 'Corporate'
                        {
                            if(leadRec.Price_GBP__c <= allowedCountriesPremium.get(leadRec.Country_List__c).Price_GBP__c && leadRec.Anticipated_Enrollment__c >= allowedCountriesPremium.get(leadRec.Country_List__c).Anticipated_Enrollment__c){
                                leadIds.add(leadRec.Id);
                            }
                            
                            if(leadRec.Anticipated_Enrollment__c <= allowedCountriesPremium.get(leadRec.Country_List__c).Anticipated_Enrollment__c){
                                failedleadIdsErrorMap.put(leadRec.id,lobj.errorMsgOne);
                            }
                            if(leadRec.Price_GBP__c >= allowedCountriesPremium.get(leadRec.Country_List__c).Price_GBP__c){
                                failedleadIdsErrorMap.put(leadRec.id,lobj.errorMsgSecond);
                            }   
                        }
                    }   
                    
                    /*System.debug('Test1'+allowedCountriesPremium.containsKey(leadRec.Country_List__c));
                    System.debug('Test2'+leadRec.Text_Type__c);
                    System.debug('Test5'+leadRec.Product_Name__c);
                    System.debug('Test5'+leadRec);
                    System.debug('Test3'+leadRec.Book_Requested_Type__c);
                    System.debug('Test4'+leadRec.Order_Type__c);
                    system.debug('DateTime d1---- '+d1 + '****-----'+leadRec.Course_Start_Date__c + ' ----> '+leadIds);  */
                } 
            }
            else if(!allowedCountries.containsKey(leadRec.Country_List__c))
            {
                failedleadIdsErrorMap.put(leadRec.id,lobj.errorMsgThird);
            }
            /* Lead Source mapping for the leads coming from Web form
            Split the led source string by '::' character , first part --> 'Lead Source'
            second part --> 'Lead Source Detail'
            */
            
            //System.debug('Test'+trig.isAfter);
            if (trig.isBefore && trig.isInsert)
            {
                if(leadRec.LeadSource != null && leadRec.LeadSource.contains('::') && system.label.T_F_Lead_Source_Webform_Mapping == 'On'){
                    List<String> leadSourceValues = new List<String>();
                    leadSourceValues = leadRec.LeadSource.split('::');
                    if(leadSourceValues.size() == 2){
                        // leadRec.LeadSource = leadSourceValues[0];
                        // leadRec.Lead_Source_Detail__c = leadSourceValues[1];
                        System.debug(' leadRec.Lead_Source_Detail__c'+ leadRec.Lead_Source_Detail__c);
                    }
                }
            }                     
        }
        
        if(leadIdsforBypass.size() > 0 && System.isFuture() == false)
        {
            System.debug('leadIdsforBypass*** '+leadIdsforBypass);
            LeadConvertBypassHandler.processLeadBypassConvert(leadIdsforBypass);
        }
        
        if(leadIds.size() > 0 && System.isFuture() == false)
        {
            System.debug('LeadIds*** '+leadIds);
            LeadConvertHandler.processLeadConvert(leadIds);
        }
        
        if(FailedleadIdsErrorMap.size()>0 && System.isFuture() == false)
        {
            System.debug('FailedLeadIdsErrorMap*** '+ failedleadIdsErrorMap);
            LeadConvertFailHandler.processFailLeadConvert(failedleadIdsErrorMap);
        }
    }
}