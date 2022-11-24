public class OpportunitySearchController {
    
    @AuraEnabled
    public static List<String> getTypeValue(boolean IsCustomSelectValue){
        Profile__c recordtypeList;
        string recordIds;
        if(IsCustomSelectValue == true){
            Id profileId=UserInfo.getProfileId();
            recordtypeList=Profile__c.getInstance(profileId);
            recordIds=recordtypeList.RecordTypes__c;
        }
        List<String> pickListValuesList= new List<String>();   
        List<RecordType> objRecordType = [SELECT DeveloperName,Name,SobjectType FROM RecordType where sObjectType = 'Opportunity' limit 50000];
        system.debug('RecordType '+objRecordType);
        for(RecordType objRecordTypeName : objRecordType){
            if(recordtypeList !=null){
                	if(String.valueOf(objRecordTypeName.Name).startsWith('T&F') && recordIds.contains(objRecordTypeName.Id))
                    {
                    String RecordTypeName = objRecordTypeName.DeveloperName+'####'+objRecordTypeName.Name;
                    pickListValuesList.add(RecordTypeName);
                    }
            }
            else{
                if(String.valueOf(objRecordTypeName.Name).startsWith('T&F')){
                    String RecordTypeName = objRecordTypeName.DeveloperName+'####'+objRecordTypeName.Name;
                    pickListValuesList.add(RecordTypeName);
                }   
            }
            
        }
        system.debug('Pick'+pickListValuesList);
        return pickListValuesList;
    }
    
    @AuraEnabled
    public static List < OpportunityDataWrapper > opportunitySearchDefault(string accountId,string campusId,string deptId,integer pageNo,integer recordLimit) {
        Id profileId=UserInfo.getProfileId();
        Profile__c recordtypeList = Profile__c.getInstance(profileId);
        Integer skipRecords=integer.valueOf(pageNo);
         system.debug('skipRecords'+skipRecords);
        string recordsList=recordtypeList.RecordTypes__c;
        system.debug('recordsList'+recordsList);
        if(integer.valueOf(pageNo) > 1 )
            skipRecords=skipRecords*integer.valueOf(recordLimit);  
        else
            skipRecords =0;
        String countQuery='';
        List < OpportunityDataWrapper > opportunityWrapperList = new List < OpportunityDataWrapper > ();
        if(recordsList ==null){
            opportunityWrapperList=null;
            return opportunityWrapperList;
        }else{
            String Query = 'Select Id, StageName,Name, Type, Amount, CloseDate, AccountId, Account.Name, Campus__c, Campus__r.Name, Department__c, Department__r.Name, Course_Start_Date__c, ' +
                'Number_of_Students__c,Owner.Name From Opportunity '; 
            
            if(accountId != '' && recordsList!=null){
                Query+=' where AccountId = \''+ accountId + '\' and RecordtypeId IN ('+ recordsList +') Order By Name ASC Limit '+recordLimit+' OFFSET '+skipRecords;
                countQuery=' select count() from Opportunity where AccountId = \''+ accountId + '\' and RecordtypeId IN ('+ recordsList +') ';
            }
            else if(campusId != '' && recordsList!=null){
                Query+=' where Campus__r.id = \''+ campusId + '\' and RecordtypeId IN ('+ recordsList +') Order By Name ASC Limit '+recordLimit+' OFFSET '+skipRecords;
                countQuery=' select count() from Opportunity where Campus__r.id = \''+ campusId + '\' and RecordtypeId IN ('+ recordsList +')';
            }else if(deptId != '' && recordsList!=null){
                Query+=' where Department__r.Id = \''+ deptId + '\' and RecordtypeId IN ('+ recordsList +') Order By Name ASC Limit '+recordLimit+' OFFSET '+skipRecords;
                countQuery=' select count() from Opportunity where Department__r.Id = \''+ deptId + '\' and RecordtypeId IN ('+ recordsList +')';
            }
            integer totalRecords=Database.countQuery(countQuery);
            integer recordSize=integer.valueOf(recordLimit);
            opportunityWrapperList = doPrepareData(Query,totalrecords);
            return opportunityWrapperList;
        }
        
    }
    
    @AuraEnabled
    public static List < OpportunityDataWrapper > opportunitySearch(string accountId,string campusId,string deptId,String Name, String fromDate, String toDate, String DepartName,
                                                                    String CampusName, String OpportunityOwner,
                                                                    String VolumeYear, String Opportunitytype, String DateFilter,integer pageNo,integer recordLimit,string stage) {
                                                                       
                                                                        system.debug('Opportunitytype'+Opportunitytype);
                                                                        Id profileId=UserInfo.getProfileId();
                                                                        Profile__c recordtypeList = Profile__c.getInstance(profileId);
                                                                        string recordsList=recordtypeList.RecordTypes__c;
                                                                        List < OpportunityDataWrapper > opportunityWrapperList = new List < OpportunityDataWrapper > ();
                                                                        if(recordsList ==null){
                                                                            opportunityWrapperList=null;
                                                                            return opportunityWrapperList;
                                                                        }else{
                                                                            Integer skipRecords=Integer.valueOf(pageNo);
                                                                            if(integer.valueOf(pageNo) > 1 )
                                                                                skipRecords=skipRecords*integer.valueOf(recordLimit);  
                                                                            else
                                                                                skipRecords =0;
                                                                            system.debug(accountId+'##'+campusId+'##'+deptId+'##'+Name+'##'+ fromDate+'##'+ toDate+'##'+ DepartName+'##'+ CampusName+'##'+ OpportunityOwner+'##'+ VolumeYear+'##'+ Opportunitytype+'##'+ DateFilter+'##'+skipRecords+'##'+recordLimit+'##'+recordsList+'##'+stage);
                                                                            String Query = doPrepareQuery(accountId,campusId,deptId,Name, fromDate, toDate, DepartName, CampusName, OpportunityOwner, VolumeYear, Opportunitytype, DateFilter,skipRecords,recordLimit,recordsList,stage);
                                                                            Integer totalRecords=Integer.valueOf(Query.substringAfter('##'));
                                                                            system.debug(totalRecords+'totalRecords');
                                                                            Query =Query.substringBefore('##');
                                                                            opportunityWrapperList = doPrepareData(Query,totalRecords);
                                                                            return opportunityWrapperList;
                                                                        }
                                                                    }
    
    public static List < OpportunityDataWrapper > doPrepareData(String Query,integer TotalRecords) {
        List < OpportunityDataWrapper > opportunityWrapperList = new List < OpportunityDataWrapper > ();
        String baseURL = System.URL.getSalesforceBaseUrl().toExternalForm()+'/';
        System.debug('#### Query ' + Query);
        for (Opportunity opp: Database.query(Query)) {
            OpportunityDataWrapper opportunityWrapper = new OpportunityDataWrapper();
            opportunityWrapper.Name = opp.Name;
            opportunityWrapper.AccountName = opp.Account.Name;
            opportunityWrapper.StageName = opp.StageName;
            opportunityWrapper.CampusName = opp.Campus__r.Name;
            opportunityWrapper.DepartmentName = opp.Department__r.Name;
            opportunityWrapper.Amount = opp.Amount;
            opportunityWrapper.CloseDate = opp.CloseDate;
            opportunityWrapper.CourseStartDate = opp.Course_Start_Date__c;
            opportunityWrapper.NumberofStudents = opp.Number_of_Students__c;
            opportunityWrapper.Type = opp.Type;
            opportunityWrapper.Id = opp.Id;
            //opportunityWrapper.baseURL = baseURL +opp.Id+'/e?retURL='+'/'+opp.Id;
            opportunityWrapper.baseURL = baseURL +opp.Id;
            opportunityWrapper.TotalRecords=TotalRecords;
            opportunityWrapper.OwnerName=opp.Owner.Name;
            opportunityWrapperList.add(opportunityWrapper);
        }
        return opportunityWrapperList;
    }
    
    public static String doPrepareQuery(string accountId,string campusId,string deptId,String Name, String fromDate, String toDate, String DepartName,
                                        String CampusName, String OpportunityOwner,
                                        String VolumeYear, String Opportunitytype, String DateFilter,integer skipRecords,integer recordLimit,string recordsList,string stage) {
                                            String CountQuery='';
                                            String Query = 'Select Id, StageName,Name, Type, Amount, CloseDate, AccountId, Account.Name, Campus__c, Campus__r.Name, Department__c, ' +
                                                ' Department__r.Name, Course_Start_Date__c, Number_of_Students__c,Owner.Name From Opportunity ';
                                            
                                            if(accountId != ''){
                                                Query+=' where AccountId = \''+ accountId + '\'';
                                                countQuery=' select count() from Opportunity where AccountId = \''+ accountId + '\'';
                                            }
                                            else if(campusId != ''){
                                                Query+=' where Campus__r.id = \''+ campusId + '\'';
                                                countQuery=' select count() from Opportunity where Campus__r.id = \''+ campusId + '\'';
                                            }else if(deptId != ''){
                                                Query+=' where Department__r.Id = \''+ deptId + '\'';
                                                countQuery=' select count() from Opportunity where Department__r.Id = \''+ deptId + '\'';
                                            }
                                          
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

                                                if (DateFilter == 'CreatedDate' || DateFilter == 'LastModifiedDate'){
                                                    System.debug('#### DateFilter '+DateFilter);
                                                    Query += ' AND ' + DateFilter + ' >= ' + sDTTMFrom + ' AND ' + DateFilter + ' <= ' + sDTTMTo;
                                                    CountQuery += ' AND ' + DateFilter + ' >= ' + sDTTMFrom + ' AND ' + DateFilter + ' <= ' + sDTTMTo;
                                                } 
                                                if (DateFilter == 'CloseDate') {
                                                    System.debug('#### DateFilter '+DateFilter);
                                                    Query += ' AND ' + DateFilter + ' >= ' + dttmFromDate.format('yyyy-MM-dd') + ' AND ' + DateFilter + ' <= ' + dttmTodate.format('yyyy-MM-dd');
                                                    CountQuery +=  ' AND ' + DateFilter + ' >= ' + dttmFromDate.format('yyyy-MM-dd') + ' AND ' + DateFilter + ' <= ' + dttmTodate.format('yyyy-MM-dd');
                        
                                                }
                                                if (DateFilter == 'CourseStartDate') {
                                                    System.debug('#### DateFilter '+DateFilter);
                                                    Query += ' AND ' + DateFilter + ' >= ' + dttmFromDate.format('yyyy-MM-dd') + ' AND ' + DateFilter + ' <= ' + dttmTodate.format('yyyy-MM-dd');
                                                    CountQuery +=  ' AND ' + DateFilter + ' >= ' + dttmFromDate.format('yyyy-MM-dd') + ' AND ' + DateFilter + ' <= ' + dttmTodate.format('yyyy-MM-dd');
                                                }
                                                
                                            }
                                            If(Name != null && Name != '' ) {
                                                String nameFilter = '\'%' + Name + '%\'';
                                                Query += ' AND Account.Name Like ' + nameFilter;
                                                CountQuery +=   ' AND Account.Name Like ' + nameFilter;
                                            } if (CampusName != null && CampusName != '') {
                                                String campusNameFilter = '\'%' + CampusName + '%\'';
                                                Query += ' AND Campus__r.Name Like ' + campusNameFilter;
                                                CountQuery += ' AND Campus__r.Name Like ' + campusNameFilter;
                                                
                                            }  if (OpportunityOwner != null && OpportunityOwner != '') {
                                                String opportunityOwnerFilter = '\'%' + OpportunityOwner + '%\'';
                                                Query += ' AND Owner.Name Like ' + opportunityOwnerFilter;
                                                CountQuery += ' AND Owner.Name Like ' + opportunityOwnerFilter;
                                                
                                            }  if (DepartName != null && DepartName != '' ) {
                                                String departNameFilter = '\'%' + DepartName + '%\'';
                                                Query += ' AND Department__r.Name Like ' + departNameFilter;
                                                CountQuery += ' AND Department__r.Name Like ' + departNameFilter;
                                                
                                            }  if (VolumeYear != null && VolumeYear != '') {
                                                Query += ' AND Volume_Year__c = ' + '\''+VolumeYear+'\'';
                                                CountQuery += ' AND Volume_Year__c = ' + '\''+VolumeYear+'\'';
                                                system.debug('CountQuery'+CountQuery);
                                            } 
                                            system.debug('Opportunitytype'+Opportunitytype);
                                            if (Opportunitytype != null && Opportunitytype != '') {
                                             //   String OpportunitytypeFilter = '\'%' + Opportunitytype + '%\'';
                                                Query += ' AND RecordType.Name IN (' + Opportunitytype +')';
                                                CountQuery +=  ' AND RecordType.Name IN (' + Opportunitytype +')';
                                            }
                                             system.debug('stage'+stage);    
                                            if (stage != null && stage != '' && stage != 'ALL') {
                                                string stageName='';
                                                if(stage == 'Open')
                                                {
                                                    Query += ' AND (Not stageName Like \'%Closed%\') ';
                                                    CountQuery += ' AND (Not stageName Like \'%Closed%\') ';
                                                }
                                                else if(stage == 'Closed')
                                                {
                                                    Query += ' AND stageName Like \'%Closed%\'';
                                                    CountQuery += ' AND stageName Like \'%Closed%\'';
                                                }
                                                
                                            }
                                            //  Query += ' Order By Name ASC Limit 50000';
                                            system.debug('CountQuery##$$'+CountQuery);
                                            Integer totalRecords=Database.countQuery(CountQuery);
                                            Query += ' Order By Name ASC Limit '+recordLimit +' OFFSET ' +skipRecords;
                                            Query +='##'+totalRecords;
                                            System.debug('$$$$$$$TESTQueryQueryQueryQueryQuery$$$$$$ '+Query);
                                            return Query;
                                        }
    
    @AuraEnabled
    Public static string getAssignedRecordType(){
        Id profileId=UserInfo.getProfileId();
        Profile__c recordtypeList = Profile__c.getInstance(profileId);
        string recordsList=recordtypeList.RecordTypes__c;
        return recordsList;
    }
}