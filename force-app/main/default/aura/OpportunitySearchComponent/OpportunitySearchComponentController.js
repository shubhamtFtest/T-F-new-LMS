({
    doInit : function(component, event, helper) {
        helper.fetchPickListVal(component);
        var queryString=window.location.href.slice(window.location.href.indexOf('?')+1).split('&');
      //  console.log('###uery##'+queryString);
        var pageReference = component.get("v.pageReference");
      //  console.log('#state#'+pageReference.state.c__accId);
      //  component.set("v.myAttr", pageReference.state.c__accId);

        component.set('v.isSending', true);
        component.set('v.columsToDisplay', [
            //{label: 'Action', fieldName: 'baseURL', type: 'url' , typeAttributes : { target : 'self'}},
            //{label: 'Opportunity Name', fieldName: 'Name', type: 'text' , sortable : true},
            {label: 'Opportunity Name', fieldName: 'baseURL', type: 'url' , sortable : true, typeAttributes: {label: { fieldName: 'Name' }, target: 'self'}},
            {label: 'Account Name', fieldName: 'AccountName', type: 'text', sortable : true},
            {label: 'StageName', fieldName: 'StageName', type: 'picklist', sortable : true},
            {label: 'Campus Name', fieldName: 'CampusName', type: 'text', sortable : true},
            {label: 'Department name', fieldName: 'DepartmentName', type: 'text', sortable : true},
            {label: 'Type', fieldName: 'Type', type: 'picklist', sortable : true},
            {label: 'Amount', fieldName: 'Amount', type: 'number', sortable : true},
            {label: 'Close Date', fieldName: 'CloseDate', type: 'date', sortable : true},
            {label: 'Course Start Date', fieldName: 'CourseStartDate', type: 'date', sortable : true},
            {label: 'Number of Students', fieldName: 'NumberofStudents', type: 'number', sortable : true},
            {label: 'Opportunity Owner', fieldName: 'OwnerName', type: 'string', sortable : true}

            
        ]);
        helper.doDefaultSearch(component, event);
        helper.getCustomRecordValues(component, event, helper)
    },
    reInit : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    updateColumnSorting : function(component, event, helper) {
        component.set('v.isSending', true);
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        var ltngTableComponent = component.find('oppDataDetails');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        ltngTableComponent.set("v.sortedBy", fieldName);
        ltngTableComponent.set("v.sortedDirection", sortDirection);
        helper.sortData(component, fieldName, sortDirection);
    },
    doPerformSearch : function(component, event, helper){
        component.set('v.isSending', true);
        helper.doSearch(component, event);
        helper.clearPageFields(component);
     
    },
    handleChangeRecordType: function (component, event) {
       // get the updated/changed values   
        var selectedOptionsList = event.getParam("value");
       // get the updated/changed source  
        var targetName = event.getSource().get("v.name");
       
        // update the selected itmes  
        if(targetName == 'Skills'){ 
            component.set("v.selectedSkillsItems" , selectedOptionsList);
        }
        
    },
    handleonChange : function(component, event){ 
        var dateSelctValue = component.find('datePickList').get('v.value');
        if(dateSelctValue!= undefined && dateSelctValue!= ''){
           component.set('v.showDateFilters', true); 
        }else{
            component.set('v.showDateFilters', false); 
        }
    },
    doHandleClear : function(component, event, helper){ 
        helper.clearAll(component, event, helper);
    },
    previousPage : function(component, event, helper){ 
        component.set('v.isSending', true);
        //helper.previous(component, event);
        var pageNumber= component.get('v.pageNo');
        var searchType=component.get('v.defaultSearch');
        var accountId='',campusId='',deptId='';
        accountId=component.get('v.accID');
        campusId=component.get('v.campusID');
        deptId=component.get('v.deptID');
        pageNumber=parseInt(pageNumber)-1;
        component.set('v.pageNo',parseInt(pageNumber));
        if(searchType == true){
            helper.callSearchfunction(component, event,accountId,campusId,deptId); 
        }else{
         
            
            helper.doSearch(component, event); 
        }
        
    },
    next : function(component, event, helper){ 
         component.set('v.isSending', true);
        var pageNumber=component.get('v.pageNo');
        var searchType=component.get('v.defaultSearch');
        var accountId='',campusId='',deptId='';
        accountId=component.get('v.accID');
        campusId=component.get('v.campusID');
        deptId=component.get('v.deptID');
        pageNumber=parseInt(pageNumber)+1;
        component.set('v.pageNo',parseInt(pageNumber));
        if(searchType == true){
            helper.callSearchfunction(component, event,accountId,campusId,deptId); 
        }else{
            helper.doSearch(component, event); 
        }
    },
    doHandlePageChange : function(component, event, helper){
        helper.doSetPageSize(component, event);
    },
    doHandleRowSelection : function(component, event, helper){
        helper.doPerformRowSelection(component, event);
    },
    closeModal : function(component, event, helper){  
        helper.closeModal(component, event);
    },
    openModal : function(component, event, helper){  
        helper.openModal(component, event);
    }
   
})