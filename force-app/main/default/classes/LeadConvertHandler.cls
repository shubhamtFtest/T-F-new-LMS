/*
Handler class created for Auto-Lead project
Future action called from Trigger class "TFAutoLeadConvert_Trig" 
Created By : Mindtree.com
Updated on 30th August , to fix auto lead issues
Updates made by Faiz Ali (01392135) on December 12th 2019
Updated By Sourabh Goyal and Matthew Smith - 22/10/2020 - Updating Auto Convert to use Custom Settings for Enrollment and Price (01574264)
Updated by Matthew Smith on 04.11.2020 - Updating order type from HSS Vitalsource e-Exam copy to Vitalsource e-Exam copy (01672236)
Updated by Renil Rejith on 10.12.2021 for user story [SAL-4582], autoconvert faliure reason issues, allowing users to retry lead auto convert.
*/
public class LeadConvertHandler{
     
    public static Map<String,Contact> emailContactMap; // Map of Email & related Contact
    public static Map<String,Lead> emailLeadMap; // Map of Email & related incoming Lead
    public static Map<String,Integer> customerICsMap; // map of Email & current Opportunity Product count related to that Customer
    public static Map<String,Lead> courseLeadMap; // Map of (CourseName + Course Start Date) as key & Lead record as value
    public static Map<String,Opportunity> courseOppMap; // Map of existing Opportunity based on Course Name & Corse Start Date
    public static Map<Id,Lead> productIdLeadMap; // Map of Product Id as key & Lead Record as value
    public static Map<Id,PricebookEntry> productPriceBookMap; // Map of requested Product on Lead & it's PriceBookEntry
    public static List<OpportunityLineItem> lineItems; // List of new Opportunity Products inserted
    // Map of Business Division (field present on Product) & related Course Category Id (this Id populated on Opportunity)
    public static Map<String,Id> businessDivCourseCatMap; 
    public static List<Id> accountIdList; //list of Account Ids
    
    public static Set<String> courseNames;
    public static Set<Date> courseStartDates;
    
    public static Set<Id> existingICsIdSet;
    public static Set<Id> existingConRoleIds;
    public static boolean isAnyException; // Set to True if any Exception occurs
    
    public static List<OpportunityContactRole> contactRoles;
    public static Map<String,String> usInventoryStatusMap; //map of lead Email & respective product's US Inventory Status
    public static Map<String,String> rowInventoryStatusMap; //map of lead Email & respective product's UK Inventory Status
    public static Map<Id, String> exisitingProductMap;
    public static Id conrtId; // T&F Contact record type Id             
    /*
    Invocable action called from Process Builder 'T&F Lead Convert'
    Parameters : List<Lead> --> List of Lead records
    Return Type : Void
    */
    
    //@invocableMethod
    //public static void processLeadConvert(List<Lead> leadList)
    
    /*
    Future action called from Trigger class "TFAutoLeadConvert_Trig"
    Parameters : List<Id> lead record Ids
    Return Type : Void
    */
    @future
    public static void processLeadConvert(Set<Id> leadIds)
    {
        usInventoryStatusMap    = new Map<String,String>();
        rowInventoryStatusMap   = new Map<String,String>();
        List<Lead> leadList     = new List<Lead>();
        List<Lead> leadlistAlt  = new List<Lead>();
        exisitingProductMap     = new Map<Id, String>();
        //Redundent Code
        /*TF_LeadConvert_Countries__c
        Map<String,TF_LeadConvert_Countries__c> MapCountryLC_C= new Map<string,TF_LeadConvert_Countries__c>();
        List<TF_LeadConvert_Countries__c> ListLC_C=[select id,Name,Anticipated_Enrollment__c,Price_GBP__c from TF_LeadConvert_Countries__c];
        for(TF_LeadConvert_Countries__c CountryLC_C:ListLC_C){
        MapCountryLC_C.put(CountryLC_C.Name,CountryLC_C);
        }*/
        leadlistAlt= [Select Id,Name,Email,Business_Division__c,Department__c,Product_Name__c,
                      Course_Name__c,Course_Start_Date__c,Anticipated_Enrollment__c,
                      City,State,Street,Country,PostalCode,Country_List__c,
                      Product_Name__r.Name,ISBN__c,Author__c,CreatedDate,Book_Requested_Type__c,
                      Current_Text__c,Price_GBP__c,Order_Type__c,Website_Source__c, Retry_Lead_Auto_Convert__c
                      from Lead
                      where Id IN: leadIds];

        for(Lead Leaddata:leadlistAlt)
        {
            /* commented as redundant Check Same as trigger class
            if(MapCountryLC_C.containskey(Leaddata.Country_List__c)){
            if(Leaddata.Price_GBP__c<=MapCountryLC_C.get(Leaddata.Country_List__c).Price_GBP__c && Leaddata.Anticipated_Enrollment__c>=MapCountryLC_C.get(Leaddata.Country_List__c).Anticipated_Enrollment__c){ //using the trigger for this
            
            
            system.debug('MapCountryLC_C.get(Leaddata.Country_List__c).Price_GBP__c***'+MapCountryLC_C.get(Leaddata.Country_List__c).Price_GBP__c);
            system.debug('MapCountryLC_C.get(Leaddata.Country_List__c).Anticipated_Enrollment__c***'+MapCountryLC_C.get(Leaddata.Country_List__c).Anticipated_Enrollment__c);
            
            }
            }
            commented as redundant Check Same as trigger class
            else{
            system.debug('Country field is empty');
            }*/
            system.debug('Retry_Lead_Auto_Convert__c***'+Leaddata.Retry_Lead_Auto_Convert__c);
            system.debug('Leaddata***'+Leaddata.Price_GBP__c);
            system.debug('Leaddata***'+Leaddata.Anticipated_Enrollment__c); 
            leadList.add(Leaddata);
            system.debug('whats in the leaddata ' +  Leaddata);
        }

        /* leadList = [Select Id,Name,Email,Business_Division__c,Department__c,Product_Name__c,
        Course_Name__c,Course_Start_Date__c,Anticipated_Enrollment__c,
        City,State,Street,Country,PostalCode,Country_List__c,
        Product_Name__r.Name,ISBN__c,Author__c,CreatedDate,Book_Requested_Type__c,
        Current_Text__c,Price_GBP__c,Order_Type__c,Website_Source__c
        from Lead
        where Id IN: leadIds AND Price_GBP__c<=120];*/
        //decimal acc= MapCountryLC_C.get('United States').Price_GBP__c;
        
        system.debug('leadList***'+leadList);
        isAnyException      = false;
        accountIdList       = new List<Id>();
        courseNames         = new Set<String>();
        courseStartDates    = new Set<Date>();
        existingICsIdSet    = new set<Id>();
        existingConRoleIds  = new Set<Id>();
        contactRoles        = new List<OpportunityContactRole>();
        
        List<Database.LeadConvert> leadConvertList          = new List<Database.LeadConvert>(); // List of LeadConvert process
        List<Database.LeadConvert> leadConvertListForNewOpp = new List<Database.LeadConvert>();
        List<Opportunity> oppList                           = new List<Opportunity>(); // List of new Opportunity records to be inserted
        
        // custom setting used to store the Business Division & Course Category Names
        Map<String, BusinessDivision_CourseCategory__c> businessDivisions = new Map<String, BusinessDivision_CourseCategory__c>();
        businessDivisions = BusinessDivision_CourseCategory__c.getAll(); // get the Data from custom setting
        
        Map<String,Department__c> departmentMap = new Map<String,Department__c>(); // Map of (Name of Department & Department record)
        Map<Id,Id> accountContactMap            = new Map<Id,Id>(); // Map of AccountId & Contact Id 
        emailLeadMap                            = new Map<String,Lead>();
        emailContactMap                         = new Map<String,Contact>();
        customerICsMap                          = new Map<String,Integer>();
        courseLeadMap                           = new Map<String,Lead>();
        courseOppMap                            = new Map<String,Opportunity>();
        productIdLeadMap                        = new Map<Id,Lead>();
        Set<String> departNames                 = new Set<String>();
        Map<String,Lead> courseCategoryLeadMap  = new Map<String,Lead>();
        businessDivCourseCatMap                 = new Map<String,Id>();
        List<Contact> contactsUpdated           = new List<Contact>();

        Map<String,Opportunity_Owner_Mapping__c> oppOwnerMap = new Map<String,Opportunity_Owner_Mapping__c>();
        oppOwnerMap = Opportunity_Owner_Mapping__c.getAll();
        
        //Map of custom setting which holds the Business Divisions for which Lead to be proceeed manually
        Map<String,Divisions_Processed_Manually__c> businessDivisionMap = new Map<String,Divisions_Processed_Manually__c>();
        businessDivisionMap = Divisions_Processed_Manually__c.getAll();
        
        // get T&F contact record type Id to process (added on 30th August)
        Schema.DescribeSObjectResult conSchema = Schema.SObjectType.Contact; 
        Map<String,Schema.RecordTypeInfo> contactRecordTypeInfo = conSchema.getRecordTypeInfosByName(); 
        conrtId = contactRecordTypeInfo.get('T&F - Contacts').getRecordTypeId();
        
        system.debug('*****'+leadList);
        
        for(Lead leadRec : leadList)
        {
            // Consider lead for Auto Convert for required Business Divisions only
            if(!businessDivisionMap.containsKey(leadRec.Business_Division__c))
            {
                emailLeadMap.put(leadRec.Email.toLowerCase(),leadRec);
                // map of Product Id as key & Lead Record as value
                productIdLeadMap.put(leadRec.Product_Name__c,leadRec);
                departNames.add(leadRec.Department__c); // Department from Lead
                // Map of Course Category (get category from respective Business Division) & Lead record
                if(leadRec.Business_Division__c != null && businessDivisions.containsKey(leadRec.Business_Division__c))
                    courseCategoryLeadMap.put(businessDivisions.get(leadRec.Business_Division__c).Course_Category__c , leadRec);
            }
        }
        
        system.debug('*****'+courseCategoryLeadMap);
        
        // From Business Division , get the required Course Category Id
        if(courseCategoryLeadMap.size() > 0)
        {
            businessDivCourseCatMap = getCourseCategory(courseCategoryLeadMap);
        }
        
        system.debug('*****'+emailLeadMap);
        
        if(emailLeadMap.size() > 0)
        {
            map <Id,string> leadIdErrorFailmap=new map<Id,string>();   
            
            system.debug('*****vinmethod');
            
            emailContactMap = searchExistingCustomer(emailLeadMap); //get the Existing customer based on Email{
            productPriceBookMap = getPriceBookEntry(productIdLeadMap); //get PrioceBookEntry for requested Product
            
            system.debug('*****emailContactMap'+emailContactMap);
            
            if(emailContactMap.size() > 0)
            {
                //if customer found then get the number of already requested Ics (Opportunity Products)
                customerICsMap = serachforICs(emailContactMap);
            }
            
            for(String leadEmail : emailLeadMap.keySet())
            {
                
                if(!emailContactMap.containsKey(leadEmail)){
                    leadIdErrorFailmap.put(emailLeadMap.get(leadEmail).Id,'Contact Not Found or Book Grabber');
                }
                /*
                 * Commented by renil to fix autoconvert issue on 10/12/2021.
                 * if(customerICsMap.containsKey(leadEmail)){
                    leadIdErrorFailmap.put(emailLeadMap.get(leadEmail).Id,'Product Already Requested');
                }*/
                
                //added by Renil on 10/12/2021 - User story SAL-4582
                System.debug('exisitingProductMap '+exisitingProductMap);
                if(productIdLeadMap.size() > 0)
                {
                   for(Id leadProdId : productIdLeadMap.keySet())
                    {
                        if(exisitingProductMap.containsKey(leadProdId))
                        {
                            leadIdErrorFailmap.put(emailLeadMap.get(leadEmail).Id,'Product Already Requested');
                        }
                    } 
                }

                String CourseName_CourseStartDate = emailLeadMap.get(leadEmail).Course_Name__c + '-' + string.valueOf(emailLeadMap.get(leadEmail).Course_Start_Date__c);
                courseNames.add(emailLeadMap.get(leadEmail).Course_Name__c);
                courseStartDates.add(emailLeadMap.get(leadEmail).Course_Start_Date__c);
                /*
                consider Lead for Auto-Convert only when 
                1. Anticipated Enrollment >= 5
                AND
                (
                2. If country is US , then 'US Inventory Status' on Product selected != 'Out of Print'
                OR
                3. If country is ROW , then 'UK Inventory Status' on Product selected != 'Out of Print'
                )
                */
                //if(emailLeadMap.get(leadEmail).Anticipated_Enrollment__c >=MapCountryLC_C.get(emailLeadMap.get(leadEmail).Country_List__c).Anticipated_Enrollment__c && 
                if((emailLeadMap.get(leadEmail).Country_List__c == 'United States' && usInventoryStatusMap.containsKey(leadEmail) && usInventoryStatusMap.get(leadEmail) != 'Out of Print')
                   ||
                   (emailLeadMap.get(leadEmail).Country_List__c != 'United States' && rowInventoryStatusMap.containsKey(leadEmail) && rowInventoryStatusMap.get(leadEmail) != 'Out of Print')
                  )
                    //)
                {
                    // if existing ICs found against customer
                    if(customerICsMap.containsKey(leadEmail))
                    {
                        system.debug('@if@');
                        // If less than 15 ICs requested within last 365 days then proceed with Opportunity Sreach Logic
                        if(customerICsMap.get(leadEmail)< 15)
                        {
                            // prepare Map of (CourseName + Course Start Date) as key & Lead record as value
                            courseLeadMap.put(CourseName_CourseStartDate,emailLeadMap.get(leadEmail));
                        }
                        // (if ICs received > 15 & No.of Student > 50) , then proceeed with further logic
                        
                        //if(customerICsMap.get(leadEmail)> 15 && emailLeadMap.get(leadEmail).Anticipated_Enrollment__c > 50)
                        
                        /*Changes Done by Sourabh for lead convert. LINE NUMBER 178*/
                        system.debug('emailLeadMap.get(leadEmail).Anticipated_Enrollment__c***'+emailLeadMap.get(leadEmail).Anticipated_Enrollment__c);
                        // system.debug('MapCountryLC_C.get(emailLeadMap.get(leadEmail).Country_List__c).Anticipated_Enrollment__c***'+MapCountryLC_C.get(emailLeadMap.get(leadEmail).Country_List__c).Anticipated_Enrollment__c);
                        System.debug('customerICsMap '+customerICsMap);
                       
                        if(customerICsMap.get(leadEmail) >= 15)
                        {
                            leadIdErrorFailmap.put(emailLeadMap.get(leadEmail).Id,'Book Request Limit Reached');
                            //commented by Renil on 10/12/2021 - User story SAL-4582
                            //courseLeadMap.put(CourseName_CourseStartDate,emailLeadMap.get(leadEmail));
                        }
                    }
                    //If no Opportunity/Ics found against the customer
                    else
                    {
                        system.debug('@else@');
                        courseLeadMap.put(CourseName_CourseStartDate,emailLeadMap.get(leadEmail));
                    }
                }
            }
            List<lead> updateErrorMsg=new List<lead>();
            
            if(leadIdErrorFailmap.size()>0){
                
                system.debug('leadIdErrorFailmap='+leadIdErrorFailmap);
                List<Lead> leadlistitem=new List<Lead>();
                
                for(lead loj:[select id,Lead_Auto_Convert_Failed_Reason__c from lead where id in:leadIdErrorFailmap.keyset()]){
                    loj.Lead_Auto_Convert_Failed_Reason__c=leadIdErrorFailmap.get(loj.id);
                    leadlistitem.add(loj);
                }

                system.debug('leadIdErrorFailmap='+leadlistitem); 
                
                update leadlistitem;
            }  
        }
        
        if(departNames.size() > 0)
        {
            // get the Department record based on Department text from Lead
            departmentMap = getDepartments(departNames);
        }
        
        Map<String,Id> OppNameProductMap = new Map<String,Id>();
        lineItems = new List<OpportunityLineItem>();
        system.debug('-----courseLeadMap------'+courseLeadMap);
        system.debug('-----emailContactMap------'+emailContactMap);
        
        if(courseLeadMap.size() > 0)
        {
            List<Lead> LeadsToUpdate = new List<Lead>();
            //serach for Opportunity based on Course Name & Course Start Date
            courseOppMap = returnOpportunity(courseLeadMap);
            System.debug('courseLeadMap.keySet() '+courseLeadMap.keySet());
            for(String key : courseLeadMap.keySet())
            {
                System.debug('emailContactMap ========>' +emailContactMap.size());
                System.debug('-------->'+emailContactMap.containsKey(courseLeadMap.get(key).Email.toLowerCase()));
                System.debug('existingICsIdSet' + !(existingICsIdSet.contains(courseLeadMap.get(key).Product_Name__c)));
                
                if((emailContactMap.size() > 0  && emailContactMap.containsKey(courseLeadMap.get(key).Email.toLowerCase())) && !(existingICsIdSet.contains(courseLeadMap.get(key).Product_Name__c)))
                {
                    // If Existing Opportunity found then add the requested Product to Opportunity
                    DateTime d1;
                    if(courseLeadMap.size()>0){
                        d1 = courseLeadMap.get(key).Course_Start_Date__c;
                    }
                    
                    DateTime d2 = courseLeadMap.get(key).CreatedDate.addDays(-14);
                    
                    DateTime d3 = courseLeadMap.get(key).CreatedDate;
                    
                    //if(courseOppMap.containsKey(key))
                    /* Changes done by Sourabh */
                    System.debug('d1'+d1);
                    System.debug('d2'+d2);
                    System.debug('d3'+d3);
                    //system.debug('stagename*****'+courseOppMap.get(key).StageName +'true/false**** '+courseOppMap.get(key).StageName);
                    system.debug('courseOppMap.containsKey(key)'+courseOppMap.containsKey(key));
                    system.debug('!courseOppMap.get(key).StageName.contains(\'Closed\'))'+courseOppMap.get(key));
                    if(courseOppMap.containsKey(key) && d1 > d3 && (!courseOppMap.get(key).StageName.contains('Closed'))){
                        system.debug('*****opp found with course start date in future');
                        // add the requested product to the Opportunity
                        
                        OpportunityLineItem lineItem        = new OpportunityLineItem();
                        lineItem.OpportunityId              = courseOppMap.get(key).Id;
                        lineItem.PricebookEntryId           = productPriceBookMap.get(courseLeadMap.get(key).Product_Name__c).id;
                        lineItem.UnitPrice                  = productPriceBookMap.get(courseLeadMap.get(key).Product_Name__c).UnitPrice;
                        lineItem.Quantity                   = 1;
                        lineItem.IC_Quantity__c             = 1;
                        lineItem.Feedback_Notification__c   = 'Send';//'Do Not Send';
                        lineItem.Order_Type__c              = 'Vitalsource e-Exam copy';
                        lineItem.Recipient__c               = emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).Id;
                        lineItems.add(lineItem);
                        
                        //Field updation in lead which are auto converted
                        Lead ld                 = courseLeadMap.get(key);
                        ld.Lead_Auto_Convert__c = true;
                        if(ld.Retry_Lead_Auto_Convert__c == true)
                        {
                            ld.Lead_Auto_Convert_Failed_Reason__c = '';
                        }
                        LeadsToUpdate.add(ld);
                        
                        //if product requested with new contact other than current contact role association then insert contact role
                        if(!existingConRoleIds.contains(emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).Id))
                        {
                            OpportunityContactRole contactRole  = new OpportunityContactRole();
                            contactRole.ContactId               = emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).Id;
                            //contactRole.IsPrimary = true;
                            contactRole.OpportunityId           = courseOppMap.get(key).Id;
                            contactRole.Role                    = 'Decision Maker';
                            contactRoles.add(contactRole);
                        }
                        //convert the lead
                        Database.LeadConvert lc = new Database.LeadConvert();
                        lc.setLeadId(courseLeadMap.get(key).id);
                        lc.setConvertedStatus('Qualified');
                        lc.setAccountId(emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).AccountId);
                        lc.setContactId(emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).id);
                        lc.setDoNotCreateOpportunity(true);
                        lc.setOwnerId('0050Y000002ItxQ'); //T&F Online
                        System.debug('lc'+lc);
                        leadConvertList.add(lc);
                        
                        List<Opportunity> Listopp = new list<opportunity>();
                        Listopp = [select id ,Lead_Auto_Converted__c from opportunity where id =: courseOppMap.get(key).Id];
                        if(Listopp.size()>0){
                            Listopp[0].Lead_Auto_Converted__c = True;
                            update Listopp;
                        }
                    }
                    else if(courseOppMap.containsKey(key) && d1 > d2 && (!courseOppMap.get(key).StageName.contains('Closed'))){
                        system.debug('*****opp found with course start date is greater than -2 weeks of lead created date');
                        // add the requested product to the Opportunity
                        OpportunityLineItem lineItem = new OpportunityLineItem();
                        lineItem.OpportunityId = courseOppMap.get(key).Id;
                        lineItem.PricebookEntryId = productPriceBookMap.get(courseLeadMap.get(key).Product_Name__c).id;
                        lineItem.UnitPrice = productPriceBookMap.get(courseLeadMap.get(key).Product_Name__c).UnitPrice;
                        lineItem.Quantity = 1;
                        lineItem.IC_Quantity__c = 1;
                        lineItem.Feedback_Notification__c = 'Send';//'Do Not Send';
                        lineItem.Order_Type__c = 'Vitalsource e-Exam copy';
                        lineItem.Recipient__c = emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).Id;
                        lineItems.add(lineItem);
                        
                        //Field updation in lead which are auto converted
                        Lead ld = courseLeadMap.get(key);
                        ld.Lead_Auto_Convert__c = true;
                        if(ld.Retry_Lead_Auto_Convert__c == true)
                        {
                            ld.Lead_Auto_Convert_Failed_Reason__c = '';
                        }
                        LeadsToUpdate.add(ld);
                        
                        //if product requested with new contact other than current contact role association then insert contact role
                        if(!existingConRoleIds.contains(emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).Id)){
                            OpportunityContactRole contactRole = new OpportunityContactRole();
                            contactRole.ContactId = emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).Id;
                            //contactRole.IsPrimary = true;
                            contactRole.OpportunityId = courseOppMap.get(key).Id;
                            contactRole.Role = 'Decision Maker';
                            contactRoles.add(contactRole);
                        }
                        //convert the lead
                        Database.LeadConvert lc = new Database.LeadConvert();
                        lc.setLeadId(courseLeadMap.get(key).id);
                        lc.setConvertedStatus('Qualified');
                        lc.setAccountId(emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).AccountId);
                        lc.setContactId(emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).id);
                        lc.setDoNotCreateOpportunity(true);
                        lc.setOwnerId('0050Y000002ItxQ'); //T&F Online
                        System.debug('lc'+lc);
                        leadConvertList.add(lc);
                        
                        List<Opportunity> Listopp = new list<opportunity>();
                        Listopp = [select id ,Lead_Auto_Converted__c from opportunity where id =: courseOppMap.get(key).Id];
                        if(Listopp.size()>0){
                            Listopp[0].Lead_Auto_Converted__c = True;
                            update Listopp;
                        }
                    }
                    else if(courseOppMap.containsKey(key) && (courseOppMap.get(key).StageName.contains('Closed'))){
                        
                        system.debug('*****opp found with close won');
                        //convert the lead
                        Database.LeadConvert lc = new Database.LeadConvert();
                        lc.setLeadId(courseLeadMap.get(key).id);
                        lc.setConvertedStatus('Qualified');
                        lc.setAccountId(emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).AccountId);
                        lc.setContactId(emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).id);
                        lc.setOwnerId('0050Y000002ItxQ'); //T&F Online
                        Database.LeadConvertResult lcr ;
                        lcr = Database.convertLead(lc);
                        
                        //Field updation in lead which are auto converted
                        Lead ld = courseLeadMap.get(key);
                        ld.Lead_Auto_Convert__c = true;
                        LeadsToUpdate.add(ld);
                        
                        Opportunity opp = new Opportunity(Id = lcr.OpportunityId);
                        opp.Name = courseLeadMap.get(key).Course_Name__c;
                        opp.Lead_Auto_Converted__c = True;
                        OppNameProductMap.put(opp.Name,courseLeadMap.get(key).Product_Name__c);
                        opp.Course_Start_Date__c = courseLeadMap.get(key).Course_Start_Date__c;
                        opp.Number_of_Students__c = courseLeadMap.get(key).Anticipated_Enrollment__c;
                        opp.RecordTypeId = CasCS__c.getValues('opbs1').Value__c; // CAS Record Type
                        if(courseLeadMap.get(key).Country_List__c == 'United States'){
                            opp.CurrencyIsoCode = 'USD';
                        }
                        else{
                            opp.CurrencyIsoCode = 'GBP';//UserInfo.getDefaultCurrency(); // User's default currency
                        }
                        // Based on HE Sales Territory on Account, assign the Opportunity Owner
                        
                        if(oppOwnerMap.ContainsKey(emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).Account.HE_Sales_Territory__c))
                        {
                            opp.OwnerId = oppOwnerMap.get(emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).Account.HE_Sales_Territory__c).Sales_Rep__c;//UserInfo.getUserId();
                        }
                        opp.Order_Type__c = 'Vitalsource e-Exam copy';
                        //opp.Number_of_Students__c = courseLeadMap.get(key).Anticipated_Enrollment__c;
                        if(businessDivCourseCatMap.containsKey(courseLeadMap.get(key).Business_Division__c))
                        {
                            opp.CAS_Course_Cat1__c = businessDivCourseCatMap.get(courseLeadMap.get(key).Business_Division__c);//Get the Course Category from Business Division
                        }
                        opp.AccountId = emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).AccountId;
                        accountContactMap.put(emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).AccountId,emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).Id);
                        opp.StageName = 'Investigating';
                        opp.CloseDate = system.today()+1; //As per existing manual Convert logic , set Close Date to (Today+1)
                        if(departmentMap.size() > 0 && departmentMap.containsKey(courseLeadMap.get(key).Department__c))
                            opp.Department__c = departmentMap.get(courseLeadMap.get(key).Department__c).Id; //Populate Department lookup
                        if(courseLeadMap.get(key).Product_Name__r.Name.normalizeSpace().length() > 100){
                            opp.Book_Requested__c = courseLeadMap.get(key).Product_Name__r.Name.normalizeSpace().substring(0,100);
                        }
                        else{
                            opp.Book_Requested__c = courseLeadMap.get(key).Product_Name__r.Name.normalizeSpace();
                        }
                        opp.ISBN__c = courseLeadMap.get(key).ISBN__c;
                        opp.Author__c = courseLeadMap.get(key).Author__c;
                        opp.Book_Requested_Type__c = courseLeadMap.get(key).Book_Requested_Type__c;
                        opp.Current_Text__c = courseLeadMap.get(key).Current_Text__c;
                        opp.Order_Type__c = courseLeadMap.get(key).Order_Type__c;
                        opp.Website_Source__c = courseLeadMap.get(key).Website_Source__c;
                        oppList.add(opp);
                        
                        //prepare LineItem data
                        OpportunityLineItem lineItem = new OpportunityLineItem();
                        lineItem.OpportunityId = opp.Id;
                        lineItem.PricebookEntryId = productPriceBookMap.get(courseLeadMap.get(key).Product_Name__c).id;
                        lineItem.UnitPrice = productPriceBookMap.get(courseLeadMap.get(key).Product_Name__c).UnitPrice;
                        lineItem.Quantity = 1;
                        lineItem.IC_Quantity__c = 1;
                        lineItem.Feedback_Notification__c = 'Send';//'Do Not Send';
                        lineItem.Order_Type__c = 'Vitalsource e-Exam copy';
                        lineItem.Recipient__c = lcr.ContactId;
                        lineItems.add(lineItem);
                    }
                    
                    /**************/
                    
                    // Else create the new Opoortunity
                    else
                    {
                        
                        system.debug('*****else part');
                        //convert the lead
                        Database.LeadConvert lc = new Database.LeadConvert();
                        lc.setLeadId(courseLeadMap.get(key).id);
                        lc.setConvertedStatus('Qualified');
                        lc.setAccountId(emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).AccountId);
                        lc.setContactId(emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).id);
                        lc.setOwnerId('0050Y000002ItxQ'); //T&F Online
                        Database.LeadConvertResult lcr ;
                        lcr = Database.convertLead(lc);
                        
                        //Field updation in lead which are auto converted
                        Lead ld                 = courseLeadMap.get(key);
                        ld.Lead_Auto_Convert__c = true;
                        LeadsToUpdate.add(ld);
                        
                        System.debug('lcrelse '+lcr );
                        
                        Opportunity opp                 = new Opportunity(Id = lcr.OpportunityId);
                        opp.Name                        = courseLeadMap.get(key).Course_Name__c;
                        opp.Lead_Auto_Converted__c      = True;
                        OppNameProductMap.put(opp.Name,courseLeadMap.get(key).Product_Name__c);
                        opp.Course_Start_Date__c        = courseLeadMap.get(key).Course_Start_Date__c;
                        opp.Number_of_Students__c       = courseLeadMap.get(key).Anticipated_Enrollment__c;
                        opp.RecordTypeId                = CasCS__c.getValues('opbs1').Value__c; // CAS Record Type

                        if(courseLeadMap.get(key).Country_List__c == 'United States'){
                            opp.CurrencyIsoCode         = 'USD';
                        }
                        else{
                            opp.CurrencyIsoCode         = 'GBP';//UserInfo.getDefaultCurrency(); // User's default currency
                        }
                        // Based on HE Sales Territory on Account, assign the Opportunity Owner
                        
                        if(oppOwnerMap.ContainsKey(emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).Account.HE_Sales_Territory__c))
                        {
                            opp.OwnerId                 = oppOwnerMap.get(emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).Account.HE_Sales_Territory__c).Sales_Rep__c;//UserInfo.getUserId();
                        }

                        opp.Order_Type__c               = 'Vitalsource e-Exam copy';
                        //opp.Number_of_Students__c = courseLeadMap.get(key).Anticipated_Enrollment__c;

                        if(businessDivCourseCatMap.containsKey(courseLeadMap.get(key).Business_Division__c))
                        {
                            opp.CAS_Course_Cat1__c      = businessDivCourseCatMap.get(courseLeadMap.get(key).Business_Division__c);//Get the Course Category from Business Division
                        }
                        opp.AccountId                   = emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).AccountId;

                        accountContactMap.put(emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).AccountId,emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).Id);

                        opp.StageName                   = 'Investigating';
                        opp.CloseDate                   = system.today()+1; //As per existing manual Convert logic , set Close Date to (Today+1)

                        if(departmentMap.size() > 0 && departmentMap.containsKey(courseLeadMap.get(key).Department__c))
                        {
                            opp.Department__c           = departmentMap.get(courseLeadMap.get(key).Department__c).Id; //Populate Department lookup
                        }
                            
                        if(courseLeadMap.get(key).Product_Name__r.Name.normalizeSpace().length() > 100){
                            opp.Book_Requested__c       = courseLeadMap.get(key).Product_Name__r.Name.normalizeSpace().substring(0,100);
                        }
                        else{
                            opp.Book_Requested__c       = courseLeadMap.get(key).Product_Name__r.Name.normalizeSpace();
                        }

                        opp.ISBN__c                     = courseLeadMap.get(key).ISBN__c;
                        opp.Author__c                   = courseLeadMap.get(key).Author__c;
                        opp.Book_Requested_Type__c      = courseLeadMap.get(key).Book_Requested_Type__c;
                        opp.Current_Text__c             = courseLeadMap.get(key).Current_Text__c;
                        opp.Order_Type__c               = courseLeadMap.get(key).Order_Type__c;
                        opp.Website_Source__c           = courseLeadMap.get(key).Website_Source__c;
                        oppList.add(opp);
                        
                        //prepare LineItem data
                        OpportunityLineItem lineItem        = new OpportunityLineItem();
                        lineItem.OpportunityId              = opp.Id;
                        lineItem.PricebookEntryId           = productPriceBookMap.get(courseLeadMap.get(key).Product_Name__c).id;
                        lineItem.UnitPrice                  = productPriceBookMap.get(courseLeadMap.get(key).Product_Name__c).UnitPrice;
                        lineItem.Quantity                   = 1;
                        lineItem.IC_Quantity__c             = 1;
                        lineItem.Feedback_Notification__c   = 'Send';//'Do Not Send';
                        lineItem.Order_Type__c              = 'Vitalsource e-Exam copy';
                        lineItem.Recipient__c               = lcr.ContactId;
                        lineItems.add(lineItem);
                        
                        
                    }
                    
                    //system.debug('*####'+leadConvertList);
                    
                    
                    //if there is change in Address then update the same on Contact's Mailing Address
                    if(emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).MailingCity != courseLeadMap.get(key).City ||
                       emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).MailingState != courseLeadMap.get(key).State ||
                       emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).MailingStreet != courseLeadMap.get(key).Street ||
                       emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).MailingCountry != courseLeadMap.get(key).Country ||
                       emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).MailingPostalCode != courseLeadMap.get(key).PostalCode
                      )
                    {
                        emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).MailingCity = courseLeadMap.get(key).City;
                        emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).MailingState = courseLeadMap.get(key).State;
                        emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).MailingStreet = courseLeadMap.get(key).Street;
                        emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).MailingCountry = courseLeadMap.get(key).Country;
                        emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).MailingPostalCode = courseLeadMap.get(key).PostalCode;
                        contactsUpdated.add(emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()));
                    }
                    // if Department on Contact is Blank then populate it based on Department from Lead
                    if(emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).Department_Object__c == null && departmentMap.containsKey(courseLeadMap.get(key).Department__c))
                    {
                        emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()).Department_Object__c = departmentMap.get(courseLeadMap.get(key).Department__c).Id;
                        if(contactsUpdated.size() == 0)
                        {
                            contactsUpdated.add(emailContactMap.get(courseLeadMap.get(key).Email.toLowerCase()));
                        }     
                    }
                }
                
            }
            if(LeadsToUpdate.size() != 0 && LeadsToUpdate != null){
                try{
                    update LeadsToUpdate;
                }
                catch(Exception ex)
                {
                    system.debug('Lead auto convert field update failed'+ex);
                }
            }
        }
        
        
        Savepoint sp = Database.setSavepoint();
        if(oppList.size() > 0)
        {
            try
            {
                //update the newly created Opportunities
                update oppList;
            }
            catch(Exception ex)
            {
                isAnyException = true;
                system.debug('----ExceptionForOppInOppBlock----'+ex);
                Database.rollback(sp);
            }
        }
        if(contactRoles.size() > 0){
            try{
                insert contactRoles;
            }
            catch(Exception ex)
            {
                isAnyException = true;
                system.debug('----ExceptionForConRole----'+ex);
                Database.rollback(sp);
            }
        }
        if(lineItems.size() > 0)
        {
            try{
                insert lineItems;
            }
            catch(Exception ex)
            {
                isAnyException = true;
                system.debug('----ExceptionInOppProduct----'+ex);
                Database.rollback(sp);
            }
        }
        
        //update the Contacts if Address/Department change
        if(contactsUpdated.size() > 0)
        {
            try{
                update contactsUpdated;
            }
            catch(Exception ex)
            {
                isAnyException = true;
                system.debug('----ExceptionInContact-----'+ex);
                Database.rollback(sp);
            }
        }
        
        system.debug('$$$$$$'+leadConvertList);
        
        if(leadConvertList.size() > 0)
        {
            try{
                
                
                if(isAnyException == false)
                {
                    Database.convertLead(leadConvertList);
                    
                }
            }
            catch(Exception ex)
            {
                system.debug('------ExceptionInLead------'+ex);
                Database.rollback(sp);
            }
        }
    }
    
    // search existing customer based on Email field
    public static Map<String,Contact> searchExistingCustomer(Map<String,Lead> emailLeadMap)
    {
        Map<String,Contact> emailContactMap = new Map<String,Contact>();
        for(Contact con: [Select Id,Email,AccountId,Account.HE_Sales_Territory__c,Department_Object__c,
                          MailingCity,MailingState,MailingCountry,MailingPostalCode,MailingStreet 
                          from Contact where Email IN: emailLeadMap.keySet()
                          AND RecordTypeId = : conrtId // added T&F - Contact record type condition (added on 30th August)
                          AND Contact_Type__c excludes ('Book Grabber','Blacklisted Book Grabber')])
        {
            emailContactMap.put(con.Email.toLowerCase(), con);
            accountIdList.add(con.AccountId);
        }
        return emailContactMap;
    }
    
    // serah for Opportunity Product numbers for the serached customer
    public static Map<String,Integer> serachforICs(Map<String,Contact> emailContactMap)
    {
        String casRecTypeId = CasCS__c.getValues('opbs1').Value__c;// get CAS record type Id
        Map<String,Integer> emailICsMap = new Map<String,Integer>();
        List<AggregateResult> groupedResults = new List<AggregateResult>();
        groupedResults = [Select Contact.Email email,SUM(Opportunity.Product_Count__c) 
                          from OpportunityContactRole 
                          where Contact.Email IN: emailContactMap.keySet()
                          AND Contact.RecordTypeId = : conrtId // added T&F - Contact record type condition (added on 30th August)
                          AND Opportunity.CreatedDate = LAST_N_DAYS:365
                          AND Opportunity.RecordTypeId =: casRecTypeId
                          Group By Contact.Email];
        for(AggregateResult ar :groupedResults)
        {
            emailICsMap.put((String)ar.get('email'),Integer.valueOf(ar.get('expr0')));
        }
        
        Set<Id> OppIds = new Set<Id>();
        for(OpportunityContactRole conRole :[Select Opportunity.Id,Contact.Id from OpportunityContactRole
                                             where Contact.Email IN: emailContactMap.keySet()
                                             AND Opportunity.CreatedDate = LAST_N_DAYS:365
                                             AND Opportunity.RecordTypeId =: casRecTypeId])
        {
            OppIds.add(conRole.Opportunity.Id);
            existingConRoleIds.add(conRole.Contact.Id);
        }
        //prepare the set of Existing Product against an Opportunity
        for(OpportunityLineItem lineItem : [Select Product2Id, OpportunityId 
                                            From OpportunityLineItem
                                            where OpportunityId IN: OppIds])
        {
            existingICsIdSet.add(lineItem.Product2Id);
            
            //added by Renil on 10/12/2021 - User story SAL-4582
            if(!exisitingProductMap.containsKey(lineItem.Product2Id))
            {
                exisitingProductMap.put(lineItem.Product2Id,'Exisitng Product');
            }
        }
        System.debug('existingICsIdSet ========>' + existingICsIdSet);
        
        return emailICsMap;
    }
    
    // search for existing Opportunity based on Course Name & Corse Start Date
    public static Map<String,Opportunity> returnOpportunity(Map<String,Lead> courseLeadMap)
    {
        Map<String,Opportunity> courseOppRecMap = new Map<String,Opportunity>();
        for(Opportunity Opp: [Select Id,Name,StageName,Lead_Auto_Converted__c,Course_Start_Date__c from Opportunity 
                              where Name IN: courseNames AND Course_Start_Date__c IN: courseStartDates
                              AND AccountId IN: accountIdList
                              AND RecordTypeId =: CasCS__c.getValues('opbs1').Value__c])
            
        {
            String key = opp.Name + '-' + String.valueOf(opp.Course_Start_Date__c);
            courseOppRecMap.put(key,opp);
        }
        return courseOppRecMap;
    }
    
    // serach for PriceBookEntry records for the Products selected on Lead record
    public static Map<Id,PricebookEntry> getPriceBookEntry(Map<Id,Lead> productIdLeadMap)
    {
        List<String> priceBookIds = new List<String>();
        priceBookIds = (CasCS__c.getValues('Pricebook_Id').Value__c).split(',');// get T&F PriceBook Id
        Map<Id,PricebookEntry> productIdPriceBookEntryIdMap = new Map<Id,PricebookEntry>();
        String userDefualtCurrencyCode = UserInfo.getDefaultCurrency();
        /*for(PricebookEntry pEntry : [Select Id,UnitPrice,Product2Id from PricebookEntry 
        where Product2Id IN: productIdLeadMap.keySet()
        AND Pricebook2Id =: priceBookIds[0]
        AND CurrencyIsoCode =: userDefualtCurrencyCode])*/
        for(PricebookEntry pEntry : [Select Id,UnitPrice,Product2Id,Product2.US_Inventory_Status__c,
                                     Product2.UK_Inventory_Status__c,CurrencyIsoCode from PricebookEntry 
                                     where Product2Id IN: productIdLeadMap.keySet()
                                     AND Pricebook2Id =: priceBookIds[0]])
        {
            Lead leadRec = new Lead();
            leadRec = productIdLeadMap.get(pEntry.Product2Id);
            if(leadRec.Country_List__c == 'United States' && pEntry.CurrencyIsoCode == 'USD'){
                productIdPriceBookEntryIdMap.put(pEntry.Product2Id,pEntry);
                usInventoryStatusMap.put(leadRec.Email.toLowerCase(),pEntry.Product2.US_Inventory_Status__c);
            }
            else if(leadRec.Country_List__c != 'United States' && pEntry.CurrencyIsoCode == 'GBP'){
                productIdPriceBookEntryIdMap.put(pEntry.Product2Id,pEntry);
                rowInventoryStatusMap.put(leadRec.Email.toLowerCase(),pEntry.Product2.UK_Inventory_Status__c);
            }
            //productIdPriceBookEntryIdMap.put(pEntry.Product2Id,pEntry);
        }
        return  productIdPriceBookEntryIdMap;
    }
    
    //search for the departments based on Department field on Lead
    public static Map<String,Department__c> getDepartments(Set<String> departmentSet)
    {
        Map<String,Department__c> departments = new Map<String,Department__c>();
        for(Department__c depart : [select Id,Name from Department__c 
                                    where Name in: departmentSet
                                    and Account__c IN: accountIdList])
        {
            departments.put(depart.Name,depart);
        }
        return departments;
    }
    
    //serach the Course Category based on Bsuiness Division from the requested Product
    public static Map<String,Id> getCourseCategory(Map<String,Lead> leadMap)
    {
        Map<String,Id> businessDivCourseMap = new Map<String,Id>();
        for(CAS_Course_Cat1__c cat : [Select Name from CAS_Course_Cat1__c where Name IN: leadMap.keySet()])
        {
            businessDivCourseMap.put(leadMap.get(cat.Name).Business_Division__c , cat.Id);
        }
        return businessDivCourseMap;
    } 
}