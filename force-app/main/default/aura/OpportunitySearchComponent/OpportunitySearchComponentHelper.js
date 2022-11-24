({
    doDefaultSearch : function(component, event) { 
        var queryString=window.location.href.slice(window.location.href.indexOf('?')+1).split('&');
       // console.log('#quryayi#'+queryString);
      
        var accountId='',campusId='',deptId='';
        for(var i=0;i< queryString.length;i++){
            if(queryString[i].startsWith("c__accId")==true){
                accountId=queryString[i].replace("c__accId=","");
                component.set('v.accID',accountId);
                component.set('v.deptID','');
                component.set('v.campusID','');
            }
            else if(queryString[i].startsWith("c__deptId")==true && queryString[i].length>=18 )
            {
                deptId=queryString[i].replace("c__deptId=","").substring(0,18);
                component.set('v.deptID',deptId);
                component.set('v.campusID','');
                component.set('v.accID','');
            }else if(queryString[i].startsWith("c__campId")==true && queryString[i].length>=18 ){
              
                campusId=queryString[i].replace("c__campId=","").substring(0,18);
                 
                component.set('v.deptID','');
                component.set('v.accID','');
                component.set('v.campusID',campusId);
            }
        }
       // console.log('#accid#'+component.get("v.accID"));
        this.callSearchfunction(component, event,accountId,campusId,deptId);
        
    },
    callSearchfunction : function(component, event,accountId,campusId,deptId) {
        if(accountId != '')
            component.find('AccountName').set('v.disabled',true);
        else if(deptId != '')
            component.find('DepartmentName').set('v.disabled',true);
        else if(campusId != '')
            component.find('CampusName').set('v.disabled',true);
      
        var pageNumber=component.get('v.pageNo');
        var action = component.get('c.opportunitySearchDefault');
        
        action.setParams({ 
            accountId : accountId ,
            campusId :  campusId,
            deptId : deptId,
            pageNo : pageNumber,
            recordLimit : component.get('v.recordPerPage')
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS' && component.isValid() && response.getReturnValue()!=null){
                var state = response.getState();
                var pageSize = component.get("v.recordPerPage");
                var responseValue = response.getReturnValue();              
                if(responseValue.length>0){
                    component.set('v.opportunityData', responseValue);
                     
                    
                    component.set("v.totalRecords", component.get("v.opportunityData").length);
         
                    var totalRecords= responseValue[0]["TotalRecords"];
                    component.set("v.totalRecords",totalRecords);
                    var NoOfPages=totalRecords/pageSize;
                    component.set('v.totalPages',parseInt(NoOfPages));
                    var PaginationList = [];
                    for(var i=0; i< responseValue.length; i++)
                    {
                        if(component.get("v.opportunityData").length> i)
                            PaginationList.push(responseValue[i]);    
                    }
                    if(accountId != ''){
                        component.find('AccountName').set('v.value',PaginationList[0]["AccountName"]);
                        component.find('AccountName').set('v.disabled',true);
                    }else if(deptId != ''){
                        component.find('DepartmentName').set('v.value',PaginationList[0]["DepartmentName"]);  
                        component.find('DepartmentName').set('v.disabled',true);
                    }else if(campusId != ''){
                        component.find('CampusName').set('v.value',PaginationList[0]["CampusName"]);  
                        component.find('CampusName').set('v.disabled',true);
                    }
                    component.set('v.PaginationList', PaginationList);
                   	console.log(PaginationList);
                
                }
                
            }
            else{
                  component.set('v.opportunityData', null);
            }
              component.set('v.isSending', false);
        });
        $A.enqueueAction(action);
    },
    clearPageFields : function(component){
        component.set('v.totalPages',0);
        component.set('v.pageNo',1);
        component.set('v.defaultSearch',false);
    },
    doSearch : function(component, event) {
        var contactName=component.get('v.ContactName');
        var stage=component.find('stageName').get('v.value');
        var campusId=component.get('v.campusID');
        var deptId=component.get('v.deptID');
    
        var perPageRecord=component.get('v.recordPerPage');
        var accountID= component.get('v.accID');
        
        component.set('v.defaultSearch',false);
        var accountName = component.find('AccountName').get('v.value');
        var DepartmentName = component.find('DepartmentName').get('v.value');
        var datePickList = component.find('datePickList').get('v.value');
        
        var fromdate ='';
        var toDate ='';
        var toDateFlag = true;
        var fromDateFlag = true;
        if(datePickList !=undefined && datePickList != '' && datePickList != null){
            fromdate = component.find('fromdate').get('v.value');
            if(fromdate == '' || fromdate == undefined || fromdate == null){
                component.set('v.showFromDateError', true);
                fromDateFlag = false;
                component.set('v.isSending', false);
            }else{
                component.set('v.showFromDateError', false);
            }
            toDate = component.find('toDate').get('v.value');
            if(toDate == '' || toDate == undefined || toDate == null){
                component.set('v.showToDateError', true);
                toDateFlag = false;
                component.set('v.isSending', false);
            }else{
                component.set('v.showToDateError', false); 
            }
        }
        var CampusName = component.find('CampusName').get('v.value');
        var OpportunityOwner = component.find('Opportunity Owner').get('v.value');
        var VolumeYear = component.find('Volume Year').get('v.value');
        var Opportunitytype = component.get('v.selectedSkillsItems');
        var oppListIds='';
        for(var i=0;i<Opportunitytype.length;i++){
            if(i==Opportunitytype.length -1)
                oppListIds=oppListIds+"'"+Opportunitytype[i]+"'";
            else
                 oppListIds=oppListIds+"'"+Opportunitytype[i]+"',";
        }
     
      
        var action = component.get('c.opportunitySearch');
        var pageNumber=component.get('v.pageNo');
        var perPageRecord=component.get('v.recordPerPage');
        action.setParams({
            "accountId"	:  accountID,
            "campusId": campusId,
            "deptId" : deptId,
            "Name" : accountName,
            "fromDate" : fromdate,
            "toDate" : toDate,
            "DepartName" : DepartmentName,
            "CampusName" : CampusName,
            "OpportunityOwner" : OpportunityOwner,
            "VolumeYear" : VolumeYear,
            "Opportunitytype" : oppListIds,
            "DateFilter" : datePickList,
            "pageNo" 				:  pageNumber,
            "recordLimit" 			:  perPageRecord,
            "stage"					: stage,
            "contactName" : contactName
        });
        action.setCallback(this, function(response){
        
            var state = response.getState();
            var pageSize = component.get("v.recordPerPage");
            if(state === 'SUCCESS' && component.isValid() && response.getReturnValue()!=null){
                var responseValue = response.getReturnValue();
             
                if(responseValue.length > 0){
                    var totalRecords= responseValue[0]["TotalRecords"];
                    component.set("v.totalRecords",totalRecords);
                    var NoOfPages=totalRecords/pageSize;
                    component.set('v.totalPages',parseInt(NoOfPages));
                    component.set('v.opportunityData', responseValue);
                    console.log('responseValue '+responseValue);
                    component.set("v.totalRecords", component.get("v.opportunityData").length);
                    component.set("v.startPage",0);
                    component.set("v.endPage",pageSize-1);
                    
                    var PaginationList = [];
                    for(var i=0; i< pageSize; i++)
                    {
                        if(component.get("v.opportunityData").length> i)
                            PaginationList.push(responseValue[i]);    
                    }
                    
                }else{
                    component.set('v.PaginationList', null);
                    component.set("v.totalRecords",0);
                    component.set('v.totalPages',0); 
                }
                
                component.set('v.PaginationList', PaginationList);
            }else{		
	                component.set('v.PaginationList', null);		
	                component.set("v.totalRecords",0);		
	                component.set('v.totalPages',0); 		
            }
            component.set('v.isSending', false);
        });
        if(fromDateFlag && toDateFlag){
            $A.enqueueAction(action);
        }
    },
    sortData: function (component, fieldName, sortDirection) {
        var opportunityDataSorted = component.get("v.PaginationList");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        opportunityDataSorted.sort(this.sortBy(fieldName, reverse))
        component.set("v.PaginationList", opportunityDataSorted);
        component.set('v.isSending', false);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
        function(x) {return x[field]};
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    clearAll  : function(component, event, helper) { 
        component.set('v.isSending', true);
        component.find('Volume Year').set('v.value','');
        component.find('stageName').set('v.value','');
      //  component.find('Opportunity Name').set('v.value','');
        component.find('DepartmentName').set('v.value','');
        var datePickList = component.find('datePickList').get('v.value');
        if(datePickList !=undefined && datePickList != '' && datePickList != null){
            component.find('fromdate').set('v.value','');
            component.find('toDate').set('v.value','');
            component.set('v.showDateFilters', false); 
        }else{
            //component.find('fromdate').set('v.value','');
            //component.find('toDate').set('v.value','');
            //component.set('v.showDateFilters', false); 
        }
        component.find('datePickList').set('v.value','');
        component.find('CampusName').set('v.value','');
        component.find('Opportunity Owner').set('v.value','');
        component.find('Volume Year').get('v.value');       
        this.doDefaultSearch(component, event);
    },
    next : function(component, event){
        var Opportunitylist = component.get("v.opportunityData");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var PaginationList = [];
        
        var counter = 0;
        for(var i=end+1; i<end+pageSize+1; i++){
            if(Opportunitylist.length > i){  
                PaginationList.push(Opportunitylist[i]);
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', PaginationList);
    },
    previousPage : function(component, event) {
        var Opportunitylist = component.get("v.opportunityData");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var PaginationList = [];
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                PaginationList.push(Opportunitylist[i]);
                counter ++;
            }
            else{
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', PaginationList);
    },
    doSetPageSize : function(component, event){
        component.set('v.isSending', true);
        var pageSizeCmp = component.find('selectPageSize');
        
        if(pageSizeCmp != undefined){
            var pageSize = pageSizeCmp.get('v.value');
            var ne = parseInt(pageSize) + 1;
            if(pageSize != null && pageSize != ''){
                component.set("v.pageSize", parseInt(pageSize));
            }else{
                component.set("v.pageSize", 150);
            }
            this.doDefaultSearch(component, event);
        }
    },
    doPerformRowSelection : function(component, event){
        var selectedRows = event.getParam('selectedRows');
        for (var i = 0; i < selectedRows.length; i++){
            component.set('v.recordIdToEdit' , selectedRows[i].Id);
        }
    },
    closeModal: function(component, event){    
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack, 'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
    },
    openModal: function(component, event) {
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open'); 
    },
    fetchPickListVal: function(component){
        var action1 = component.get("c.getTypeValue"); 
        var opts=[];
        action1.setParams({
            IsCustomSelectValue : false
        });
        action1.setCallback(this, function(a) {
            var responseValue = a.getReturnValue();
            console.log(a.getReturnValue());
            console.log(a.getReturnValue().length);
            for(var i=0;i< a.getReturnValue().length;i++){
                opts.push({label: responseValue[i].split('####')[1], value: responseValue[i].split('####')[1]});
            }
            component.set("v.listSkillsOptions", opts); 
         //   component.set("v.selectedSkillsItems", opts); 
        });
         $A.enqueueAction(action1);
    },
     getCustomRecordValues : function(component, event, helper){ 
        var opts=[];
 
        var action = component.get("c.getTypeValue"); 
         action.setParams({
             IsCustomSelectValue : true
         });
         action.setCallback(this, function(a) {
             var responseValue = a.getReturnValue();
            for(var i=0;i< a.getReturnValue().length;i++){
                opts.push(responseValue[i].split('####')[1]);
            }
           
            component.set("v.selectedSkillsItems", opts); 
           //  component.set("v.AssignedRecordType", responseValue); 
            // var arrVal=[];
            // arrVal=responseValue.split(',');
         
            
             //   component.set("v.selectedSkillsItems", opts); 
         });
        $A.enqueueAction(action);      
    }
})