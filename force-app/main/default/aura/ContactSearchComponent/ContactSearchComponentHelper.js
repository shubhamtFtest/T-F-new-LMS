({
    doDefaultSearch : function (component, event) {
        var accountId='',campusId='',deptId='';
        var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
        for(var i = 0; i < hashes.length; i++)
        {
            if(hashes[i].startsWith("c__accId")==true){
                accountId=hashes[i].replace("c__accId=","");
                component.set('v.accID',accountId);
                component.set('v.deptID','');
                component.set('v.campusID','');
                //component.find('AccountName').set('v.disabled',true);  
            }
            else if(hashes[i].startsWith("c__deptId")==true && hashes[i].length>=18 )
            {
                deptId=hashes[i].replace("c__deptId=","").substring(0,18);
                component.set('v.deptID',deptId);
                component.set('v.campusID','');
                component.set('v.accID','');
                //component.find('DepartmentName').set('v.disabled',true);
                
            }else if(hashes[i].startsWith("c__campId")==true && hashes[i].length>=18 ){
                campusId=hashes[i].replace("c__campId=","").substring(0,18);
                component.set('v.deptID','');
                component.set('v.accID','');
                component.set('v.campusID',campusId);
                //component.find('CampusName').set('v.disabled',true);
            }
        }
        this.callSearchfunction(component, event,accountId,campusId,deptId);
        
    },
    clearPageFields : function(component){
        component.set('v.totalPages',0);
        component.set('v.pageNo',1);
        component.set('v.defaultSearch',false);
    },
    callSearchfunction : function(component, event,accountId,campusId,deptId) {
         var accountId=component.get('v.accID');
         var campusId=component.get('v.campusID');
         var deptId=component.get('v.deptID');
        
        if(accountId != '')
            component.find('AccountName').set('v.disabled',true);
        else if(deptId != '')
            component.find('DepartmentName').set('v.disabled',true);
        else if(campusId != '')
            component.find('CampusName').set('v.disabled',true);
        
        var pageNumber=component.get('v.pageNo');
        var totalPages=component.set('v.totalPages');
        var action = component.get('c.contactSearchDefault');
    
        action.setParams({ 
            accountId : accountId ,
            campusId :  campusId,
            deptId : deptId,
            pageNo : pageNumber,
            recordLimit : component.get('v.recordPerPage')
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(response);
          
             console.log(response.getReturnValue());
            if(state === 'SUCCESS' && component.isValid() && response.getReturnValue().length>0){
                var state = response.getState();
                //var pageSize =parseInt(component.get("v.recordPerPage"));
               
                var pageSize =component.get("v.recordPerPage");
                var responseValue = response.getReturnValue();
                component.set('v.contactData' , responseValue);
               
                var totalRecords= responseValue[0]["TotalRecords"];
                component.set("v.totalRecords",totalRecords);
                var NoOfPages=totalRecords/pageSize;
                component.set('v.totalPages',parseInt(NoOfPages));
                var PaginationList=[];
                for(var i=0; i< responseValue.length; i++)
                {
                    if(component.get("v.contactData").length> i)
                        PaginationList.push(responseValue[i]);    
                }
                //component.set('v.PaginationList', PaginationList);
                
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
            }
            else{
                component.set('v.PaginationList', null);
                component.set("v.totalRecords",0);
                component.set('v.totalPages',0); 
            }
             component.set('v.isSending', false);
            
        });
        $A.enqueueAction(action);
    },
    doSearch :function (component, event) {
        component.set('v.PaginationList', null);
        component.set("v.totalRecords",0);
        component.set('v.totalPages',0); 
        var contact=component.find('ContactName').get('v.value');
        console.log(contact);
        var campusId=component.get('v.campusID');
        var deptId=component.get('v.deptID');
        var perPageRecord=component.get('v.recordPerPage');
        var accountID= component.get('v.accID');
    
        if(accountID != ''){
            component.find('AccountName').set('v.disabled',true);
        }else if(deptId != ''){
            component.find('DepartmentName').set('v.disabled',true);
        }else if(campusId != ''){
            component.find('CampusName').set('v.disabled',true);
        }          
        component.set('v.defaultSearch',false);
        var pageNumber=component.get('v.pageNo');
        var datePickList = component.find('datePickList').get('v.value');
        var fromdate ='';
        var toDate ='';
        var toDateFlag = true;
        var fromDateFlag = true;
        var recordTypeFlag = true;
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
        var accountName = component.find('AccountName').get('v.value'); 
        var departmentName = component.find('DepartmentName').get('v.value'); 
        var campusName = component.find('CampusName').get('v.value');
        var mailingCity = component.find('MailingCity').get('v.value'); 
        var business = component.find('Business').get('v.value'); 
        var contactType = component.find('ContactType').get('v.value'); 
        var status = component.find('Status').get('v.value'); 
        var contactRecordType = component.find('ContactRecordType').get('v.value');
        var action = component.get('c.doSearchContact');
        action.setParams({
            "accountId"				:  accountID,
            "campusId" 				:  campusId,
            "deptId" 				:  deptId,
            "accountName" 			:  accountName ,
            "DateFilter" 			:  datePickList ,
            "fromDate" 				:  fromdate ,
            "toDate" 				:  toDate, 
            "DepartName" 			:  departmentName , 
            "CampusName" 			:  campusName ,
            "mailingCity" 			:  mailingCity ,
            "status" 				:  status ,
            "contactRecordType" 	:  contactRecordType ,
            "business" 				:  business ,
            "contactType" 			:  contactType,
            "pageNo" 				:  pageNumber,
            "recordLimit" 			:  perPageRecord,
            "contactName"			: contact
            
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS' && component.isValid() && response.getReturnValue().length>0 ){
                var pageSize = component.get("v.pageSize");
                var responseValue = response.getReturnValue();
                
                if(responseValue.length > 0){
                    console.log('ENTER');
                    var totalRecords= responseValue[0]["TotalRecords"];
                    component.set("v.totalRecords",totalRecords);
                    var NoOfPages=totalRecords/pageSize;
                    component.set('v.totalPages',parseInt(NoOfPages));
                    console.log(responseValue);
                    //   component.set('v.contactData' , responseValue);
                    
                    //  component.set("v.totalRecords", component.get("v.contactData").length);
                    // component.set("v.startPage",0);
                    // component.set("v.endPage",pageSize-1);
                    
                    var PaginationList = [];
                    for(var i=0; i< responseValue.length; i++){
                        if(component.get("v.contactData").length> i)
                            PaginationList.push(responseValue[i]);    
                    }
                    component.set('v.PaginationList', PaginationList);
                }
                
            }else{
               
            }
            component.set('v.isSending', false);
        });
        if(fromDateFlag && toDateFlag && recordTypeFlag){
            $A.enqueueAction(action);
        }
    },
    sortData: function (component, fieldName, sortDirection) {
        //alert('Test');
        var contactDataSorted = component.get("v.PaginationList");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        contactDataSorted.sort(this.sortBy(fieldName, reverse))
        component.set("v.PaginationList", contactDataSorted);
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
    next : function(component, event){
        var Contactlist = component.get("v.contactData");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var PaginationList = [];
        
        var counter = 0;
        for(var i=end+1; i<end+pageSize+1; i++){
            if(Contactlist.length > i){  
                PaginationList.push(Contactlist[i]);
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        
        component.set('v.PaginationList', PaginationList);
    },
    previous : function(component, event) {
        var Contactlist = component.get("v.contactData");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var PaginationList = [];
        
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                PaginationList.push(Contactlist[i]);
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
    doHandlePageChange : function(component, event){
        component.set('v.isSending', true);
        var pageSizeCmp = component.find('selectPageSize');
        
        if(pageSizeCmp != undefined){
            var pageSize = pageSizeCmp.get('v.value');
            if(pageSize != null && pageSize != ''){
                component.set("v.pageSize", parseInt(pageSize));
            }else{
                component.set("v.pageSize", 10);
            }
            this.doDefaultSearch(component, event);
        }
    },
    doClearAll : function(component, event){
        component.set('v.isSending', true);
        var datePickList = component.find('datePickList').get('v.value');
        if(datePickList !=undefined && datePickList != '' && datePickList != null){
            component.find('fromdate').set('v.value','');
            component.find('toDate').set('v.value','');
            component.set('v.showDateFilters', false); 
        }
        component.find('datePickList').set('v.value', ''); 
        component.find('ContactName').set('v.value','');
        var accountName = component.find('AccountName').set('v.value', ''); 
        var departmentName = component.find('DepartmentName').set('v.value', ''); 
        var campusName = component.find('CampusName').set('v.value', '');  
        var mailingCity = component.find('MailingCity').set('v.value', ''); 
        var business = component.find('Business').set('v.value', ''); 
        var contactType = component.find('ContactType').set('v.value', ''); 
        var status = component.find('Status').set('v.value', ''); 
        var contactRecordType = component.find('ContactRecordType').set('v.value', ''); 
        this.doDefaultSearch(component, event);
    },
})