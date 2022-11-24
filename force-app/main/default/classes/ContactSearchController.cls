public class ContactSearchController {
    
    @AuraEnabled
    public static List < ContactDataWrapper > contactSearchDefault(string accountId,string campusId,string deptId,integer pageNo,integer recordLimit) {
        Integer skipRecords=integer.valueOf(pageNo);
       
        if(integer.valueOf(pageNo) > 1 )
           skipRecords=skipRecords*integer.valueOf(recordLimit);  
        else
            skipRecords =0;
       
        List < ContactDataWrapper > contactWrapperList = new List < ContactDataWrapper > ();
        String countQuery='';
        String Query = 'Select Id, Name,Salutation, AccountId, Account.Name, Campus__c, Campus__r.Name, Email, Department, MobilePhone, Title, Contact_Type__c,  ' +
            ' Mailing_Country_List__c, Status__c, Department_Object__c, Department_Object__r.Name From Contact ';
        if(accountId != '' && accountId!=null){
          
            Query+=' where AccountId = \''+ accountId + '\' Order By Name ASC Limit '+recordLimit+' OFFSET '+skipRecords;
            countQuery=' select count() from Contact where AccountId = \''+ accountId + '\'';
        }
        else if(campusId != ''&& campusId!=null){
         
            Query+=' where Campus__r.id = \''+ campusId + '\' Order By Name ASC Limit '+recordLimit+' OFFSET '+skipRecords;
            countQuery=' select count() from Contact where Campus__r.id = \''+ campusId + '\'';
        }else if(deptId != ''&& deptId!=null){
            Query+=' where Department_Object__r.Id = \''+ deptId + '\' Order By Name ASC Limit '+recordLimit+' OFFSET '+skipRecords;
            countQuery=' select count() from Contact where Department_Object__r.Id = \''+ deptId + '\'';
        }
      
        integer totalRecords=Database.countQuery(countQuery);
 
        //  Where CreatedDate = THIS_WEEK OR LastModifiedDate = THIS_WEEK
       
        integer recordSize=integer.valueOf(recordLimit);
        contactWrapperList = doPrepareData(Query,totalrecords);
       
        
       
        return contactWrapperList;
    }
    
    @AuraEnabled
    public static List<ContactDataWrapper> doSearchContact(string accountId,string campusId,string deptId,String accountName, 
                                                           String DateFilter, String fromDate, String toDate, String DepartName,
                                                           String CampusName, String mailingCity, String status, String contactRecordType,
                                                           String business, String contactType,integer pageNo,integer recordLimit,string contactName){ 
                                                               Integer skipRecords=Integer.valueOf(pageNo);
                                                               if(integer.valueOf(pageNo) > 1 )
                                                                   skipRecords=skipRecords*integer.valueOf(recordLimit);  
                                                               else
                                                                   skipRecords =0;
                                                               List < ContactDataWrapper > contactWrapperList = new List < ContactDataWrapper > ();
                                                               
                                                               String Query = doPrepareQuery(accountId,campusId,deptId,accountName, DateFilter, fromDate, toDate, DepartName, CampusName, mailingCity, status, contactRecordType, business, contactType,skipRecords,recordLimit,contactName);
                                                               Integer totalRecords=Integer.valueOf(Query.substringAfter('##'));
                                                               Query =Query.substringBefore('##');
                                                            
                                                               contactWrapperList = doPrepareData(Query,totalRecords);    
                                                               return contactWrapperList;
                                                           } 
    
    public static String doPrepareQuery(string accountId,string campusId,string deptId,String accountName, String DateFilter, String fromDate, String toDate, String DepartName,
                                        String CampusName, String mailingCity, String status, String contactRecordType,
                                        String business, String contactType,integer skipRecords,integer recordLimit,string contactName){
                                            String CountQuery='';
                                            String Query = 'Select Id, Name,Salutation, AccountId, Account.Name, Campus__c, Campus__r.Name, Email, Department, MobilePhone, Title, Contact_Type__c,  ' +
                                                ' Mailing_Country_List__c, Status__c, Department_Object__c, Department_Object__r.Name From Contact ' ;// AND RecordType.Name like '+'\'T&F%\'';
                                            if(accountId != ''){
                                                Query+=' where AccountId = \''+ accountId + '\'';
                                                countQuery=' select count() from Contact where AccountId = \''+ accountId + '\'';
                                            }
                                            else if(campusId != ''){
                                                Query+=' where Campus__r.id = \''+ campusId + '\'';
                                                countQuery=' select count() from Contact where Campus__r.id = \''+ campusId + '\'';
                                            }else if(deptId != ''){
                                                Query+=' where Department_Object__r.Id = \''+ deptId + '\'';
                                                countQuery=' select count() from Contact where Department_Object__r.Id = \''+ deptId + '\'';
                                            }
                                         //   String contactTypeFilter       = '\'%' + contactType        + '%\'';
                                            
                                         //   String businessFilter          = '\'%' + business             + '%\'';
                                            
                                            IF(DateFilter != null && DateFilter != '') {
                                                String sDTTMFrom = '';
                                                String sDTTMTo = '';
                                                Date fromDateFilter;
                                                Date toDateFilter;
                                                DateTime dttmFromDate;
                                                DateTime dttmTodate;
                                                fromDateFilter = Date.newInstance(Integer.valueOf(fromDate.split('-')[0]), Integer.valueOf(fromDate.split('-')[1]), Integer.valueOf(fromDate.split('-')[2]));
                                                toDateFilter = Date.newInstance(Integer.valueOf(toDate.split('-')[0]), Integer.valueOf(toDate.split('-')[1]), Integer.valueOf(toDate.split('-')[2]));
                                                Time tm = Time.newInstance(0, 0, 0, 0);
                                                dttmFromDate = DateTime.newInstanceGMT(fromDateFilter, tm);
                                                dttmTodate = DateTime.newInstanceGMT(toDateFilter, tm);
                                                sDTTMFrom = dttmFromDate.formatGMT('yyyy-MM-dd') + 'T' + dttmFromDate.formatGMT('HH:mm:ss.SSS') + 'Z';
                                                sDTTMTo = dttmTodate.formatGMT('yyyy-MM-dd') + 'T' + dttmTodate.formatGMT('HH:mm:ss.SSS') + 'Z';
                                                if (DateFilter != 'CloseDate') Query += ' AND ' + DateFilter + ' >= ' + sDTTMFrom + ' AND ' + DateFilter + ' <= ' + sDTTMTo;
                                                if (DateFilter == 'CloseDate') Query += ' AND ' + DateFilter + ' >= ' + dttmFromDate.format('yyyy-MM-dd') + ' AND ' + DateFilter + ' <= ' + dttmTodate.format('yyyy-MM-dd');
                                            }
                                            
                                            If(contactType !=null && contactType != '' ){
                                                Query += ' AND Contact_Type__c INCLUDES(\''+   contactType + '\')';
                                                CountQuery += ' AND Contact_Type__c INCLUDES(\''+   contactType + '\')';
                                            }
                                            If(business !=null && business != '' ){
                                                Query += ' AND Business__c INCLUDES(\''+   business + '\')';
                                                CountQuery += ' AND Business__c INCLUDES(\''+   business + '\')';
                                            }
                                            
                                            If(contactName !=null && contactName != '' ){
                                                Query += ' AND Name Like \'%'+   contactName + '%\' ';
                                                CountQuery += ' AND Name Like \'%'+   contactName + '%\' ';
                                            }
                                            

                                            If(accountName !=null && accountName != '' ){
                                                String accountNameFilter       = '\'%' + accountName        + '%\'';
                                                Query += ' AND Account.Name like '+   accountNameFilter;
                                                CountQuery += ' AND Account.Name like '+   accountNameFilter;
                                                

                                            }  If(DepartName != null && DepartName != ''){
                                                String departNameFilter        = '\'%' + DepartName         + '%\'';
                                                Query += ' AND Department_Object__r.Name like '+   departNameFilter;
                                                 CountQuery += ' AND Department_Object__r.Name like '+   departNameFilter;
                                                
                                            } If( CampusName != null && CampusName != ''){
                                                String campusNameFilter        = '\'%' + CampusName         + '%\'';
                                                Query += ' AND Campus__r.Name like '+   campusNameFilter;
                                                CountQuery +=' AND Campus__r.Name like '+   campusNameFilter;
                                                 
                                            } If(mailingCity != null && mailingCity != ''){
                                                String mailingCityFilter       = '\'%' + mailingCity        + '%\'';
                                                Query += ' AND 	Mailing_City__c like '+   mailingCityFilter;
                                                CountQuery += ' AND 	Mailing_City__c like '+   mailingCityFilter;
                                                 
                                            } If(status != '' && status != null){
                                                String ststusFilter            = '\'%' + status             + '%\'';
                                                Query += ' AND 	Status__c like '+   ststusFilter;
                                                CountQuery += ' AND Status__c like '+   ststusFilter;
                                               
                                            } If(contactRecordType != null && contactRecordType != ''){
                                                String contactRecordTypeFilter = '\'%' + contactRecordType  + '%\'';
                                                Query += ' AND RecordType.Name like '+   contactRecordTypeFilter;
                                                CountQuery += ' AND RecordType.Name like '+   contactRecordTypeFilter;
                                              
                                            } 
                                            
                                            Integer totalRecords=Database.countQuery(CountQuery);
                                            Query += ' Order By Name ASC Limit '+recordLimit +' OFFSET ' +skipRecords;
                                          
                                        /*    
                                            if(contactRecordType != null || contactRecordType != '')
                                                 Query += ' Order By Name ASC Limit 999 ';
                                                // Query += ' AND RecordType.Name like '+'\'T&F%\''; 
                                          */     
                                            Query=Query+'##'+totalRecords;
                                            
                                            return Query;
                                        }
    
    public static List < ContactDataWrapper > doPrepareData(String Query,integer TotalRecords) {
        List < ContactDataWrapper > contactWrapperList = new List < ContactDataWrapper > ();
        String baseURL = System.URL.getSalesforceBaseUrl().toExternalForm()+'/';
       
        for(Contact con: Database.query(Query)) {
            ContactDataWrapper contactWrapper = new ContactDataWrapper();
            if(con.Salutation != null)
                contactWrapper.Name = con.Salutation +' '+con.Name;
            else
                contactWrapper.Name = con.Name;
            contactWrapper.AccountName = con.Account.Name;
            contactWrapper.CampusName = con.Campus__r.Name;
            contactWrapper.DepartmentName = con.Department_Object__r.Name;
            contactWrapper.Title = con.Title;
            contactWrapper.Email = con.Email;
            contactWrapper.Status = con.Status__c;
            contactWrapper.MobilePhone = con.MobilePhone;
            contactWrapper.MailingCountry = con.Mailing_Country_List__c;
            contactWrapper.ContactType = con.Contact_Type__c;
            contactWrapper.Id = con.Id;
            //contactWrapper.baseURL = baseURL +con.Id+'/e?retURL='+'/'+con.Id;
            contactWrapper.baseURL = baseURL +con.Id;
            contactWrapper.TotalRecords=TotalRecords;
            contactWrapperList.add(contactWrapper);
        }
        return contactWrapperList;
    }
    @AuraEnabled
    public static wrapperClass getpicklistValue(){
        
        Set<String> StatepickListValuesList= new Set<String>();
        Schema.DescribeFieldResult fieldResult = Contact.Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            StatepickListValuesList.add(pickListVal.getLabel());
        }     
        
        Set<String> ContactRecordTypepickListValuesList= new Set<String>();
        List<RecordType> objRecordType = [SELECT DeveloperName,Name,SobjectType FROM RecordType where sObjectType = 'Contact' limit 20];
        for(RecordType objRecordTypeName : objRecordType){
            if(String.valueOf(objRecordTypeName.Name).startsWith('T&F')){
                String RecordTypeName = objRecordTypeName.DeveloperName+'####'+objRecordTypeName.Name;
                ContactRecordTypepickListValuesList.add(RecordTypeName);
            }     
        }
        
        return new wrapperClass(StatepickListValuesList,ContactRecordTypepickListValuesList);
        
    }
    public class wrapperClass{
        @AuraEnabled public Set<String> listStatus{set;get;}
        @AuraEnabled public Set<String> listContactRecordType{set;get;}
        public wrapperClass(Set<String> listStatus,Set<String> listContactRecordType){
            this.listStatus = listStatus;
            this.listContactRecordType = listContactRecordType;
        }
    }
}