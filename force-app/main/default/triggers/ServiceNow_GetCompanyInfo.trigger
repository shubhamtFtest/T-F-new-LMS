/**************************************************************************
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2015-08-28
** NOTE: Trigger will not work with SN callouts because we hit DML limits. Trigger will only work with batches of 200 and the SN callout will do the matching in it’s process.
***************************************************************************/
trigger ServiceNow_GetCompanyInfo on Active_Directory_Details__c (Before insert, Before update)//(After insert, After update) 
{
    if(Trigger.new.size()<=200)
    {
    set<String> setCompany = new set<String>();
    set<String> setDivision = new set<String>();
    set<String> setDepartment = new set<String>();
    for (Integer i=0;i< Trigger.new.size();i++) 
    { 
       
        if(Trigger.new[i].SN_Department_Id__c != null  ) setDepartment.add(Trigger.new[i].SN_Department_Id__c);
        if(Trigger.new[i].SN_Company_Id__c != null) setCompany.add(Trigger.new[i].SN_Company_Id__c);
        if(Trigger.new[i].SN_Division_Id__c != null) setDivision.add(Trigger.new[i].SN_Division_Id__c);
    }
    
    //Create Mappings
    map<String,String> mapCompany = new map<String,String>();
    map<String,String> mapDivision = new map<String,String>();
    map<String,String> mapDepartment = new map<String,String>();
    if(setCompany.size()>0)
    {
        for (ServiceNow_Company__c snCompany : [SELECT Id,SN_Sys_Id__c FROM ServiceNow_Company__c Where SN_Sys_Id__c=:setCompany])
        {
            mapCompany.put(snCompany.SN_Sys_Id__c, snCompany.Id);
        }
    }
    if(setDivision.Size()>0)
    {
        for (ServiceNow_Division__c snDivision : [SELECT Id,SN_Sys_Id__c FROM ServiceNow_Division__c Where SN_Sys_Id__c=:setDivision])
        {
            mapDivision.put(snDivision.SN_Sys_Id__c, snDivision.Id);
        }
    }
    if(setDepartment.Size()>0)
    {
        for (ServiceNow_Department__c snDepartment : [SELECT Id,SN_Sys_Id__c FROM ServiceNow_Department__c Where SN_Sys_Id__c=:setDepartment])
        {
            mapDepartment.put(snDepartment.SN_Sys_Id__c, snDepartment.Id);
        }
    }
    
    //Add Company Info
    if(mapDepartment.size()>0 || mapDivision.size()>0 || mapCompany.size()>0)
    {
        List<Active_Directory_Details__c> updateAD = new List<Active_Directory_Details__c>();
        for (Integer i=0;i<Trigger.new.size();i++) 
        {
            String companyId = mapCompany.get(Trigger.new[i].SN_Company_Id__c);
            String departmentId = mapDepartment.get(Trigger.new[i].SN_Department_Id__c);
            String divisionId = mapDivision.get(Trigger.new[i].SN_Division_Id__c);
            
            if((companyId + departmentId + divisionId) != null)
            {
                //Active_Directory_Details__c ad = new Active_Directory_Details__c();
                //ad.Id = Trigger.new[i].Id;
                //if(companyId != null)ad.ServiceNow_Company__c=companyId;
                //if(departmentId != null)ad.ServiceNow_Department__c=departmentId;
                //if(divisionId != null)ad.ServiceNow_Division__c=divisionId;
                //updateAD.add(ad);
                //
                if(companyId != null && Trigger.new[i].ServiceNow_Company__c!=companyId)Trigger.new[i].ServiceNow_Company__c=companyId;
                if(departmentId != null && Trigger.new[i].ServiceNow_Department__c!=departmentId)Trigger.new[i].ServiceNow_Department__c=departmentId;
                if(divisionId != null && Trigger.new[i].ServiceNow_Division__c!=divisionId)Trigger.new[i].ServiceNow_Division__c=divisionId;
                
            }
            
            
            
            
        }
        
        //if(updateAD.size()>0)
        //{
        //    update updateAD;
        //}
    } 
    
}
}