({
	doInit : function(component, event, helper) {
        var pageReference = component.get("v.pageReference");

      //  var urlParams = new URLSearchParams(window.location.search);
		component.set('v.isSending', true);

        component.set('v.columsToDisplay', [
            //{label: 'Action', fieldName: 'baseURL', type: 'url' , typeAttributes : { target : 'self'}},
            //{label: 'Name', fieldName: 'Name', type: 'text' , sortable : true},
            {label: 'Name', fieldName: 'baseURL', type: 'url' , sortable : true, typeAttributes: {label: { fieldName: 'Name' }, target: 'self'}},
            {label: 'Title', fieldName: 'Title', type: 'text' , sortable : true},
            {label: 'Account Name', fieldName: 'AccountName', type: 'text', sortable : true},
            {label: 'Campus Name', fieldName: 'CampusName', type: 'text', sortable : true},
            {label: 'Department name', fieldName: 'DepartmentName', type: 'text', sortable : true},
            {label: 'Mailing Country List', fieldName: 'MailingCountry', type: 'text', sortable : true},
            {label: 'Phone', fieldName: 'MobilePhone', type: 'phone', sortable : true},
            {label: 'Email', fieldName: 'Email', type: 'email', sortable : true},
            {label: 'Status', fieldName: 'Status', type: 'text', sortable : true},
            {label: 'Contact Type', fieldName: 'ContactType', type: 'text', sortable : true}
        ]);
       
     	helper.doDefaultSearch(component, event);
        var action1 = component.get("c.getpicklistValue"); 
        console.log('test'+action1);
        var inputsel =  component.find("Status");
        var inputsel2 =  component.find("ContactRecordType");
        var opts1=[];
        var opts2=[];
        action1.setCallback(this, function(a) {
            opts1.push({"class": "optionClass", label: "None", value: ""});
            var wrapperClassobj = a.getReturnValue();
            for(var i=0;i< wrapperClassobj.listStatus.length;i++){
                opts1.push({"class": "optionClass", label: wrapperClassobj.listStatus[i], value: wrapperClassobj.listStatus[i]});
            }
            inputsel.set("v.options", opts1);  
            opts2.push({"class": "optionClass", label: "None", value: ""});
            for(var i=0;i< wrapperClassobj.listContactRecordType.length;i++){
                opts2.push({"class": "optionClass", label: wrapperClassobj.listContactRecordType[i].split('####')[1], value: wrapperClassobj.listContactRecordType[i].split('####')[1]});
            }
            inputsel2.set("v.options", opts2);
        });
      
        $A.enqueueAction(action1);
       
	},
    handleonChange : function(component, event){ 
        var dateSelctValue = component.find('datePickList').get('v.value');
        if(dateSelctValue!= undefined && dateSelctValue!= ''){
           component.set('v.showDateFilters', true); 
        }else{
            component.set('v.showDateFilters', false); 
        }
    },
    doPerformSearch : function(component, event, helper){ 
		helper.clearPageFields(component);
    	component.set('v.isSending', true);
        helper.doSearch(component, event);
    },
    doHandleClear : function(component, event, helper){ 
    	helper.doClearAll(component, event);
    },
    updateColumnSorting : function(component, event, helper){ 
        component.set('v.isSending', true);
        var fieldName = event.getParam('fieldName');
  
        var sortDirection = event.getParam('sortDirection');
        var ltngTableComponent = component.find('contactDataDetails');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        ltngTableComponent.set("v.sortedBy", fieldName);
        ltngTableComponent.set("v.sortedDirection", sortDirection);
        helper.sortData(component, fieldName, sortDirection);
    },
    doHandleRowSelection : function(component, event){ 
    
    },
    previous : function(component, event, helper){ 
        
         component.set('v.isSending', true);
    	//helper.previous(component, event);
    	var pageNumber= component.get('v.pageNo');
        var searchType=component.get('v.defaultSearch');
        var accountId='',campusId='',deptId='';
        accountId=component.get('v.accID');
        campusId=component.get('v.campusID');
        deptId=component.get('v.deptID');
        pageNumber=parseInt(pageNumber)-1;
        component.set('v.pageNo',pageNumber);
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
        component.set('v.pageNo',String(pageNumber));
        if(searchType == true){
            helper.callSearchfunction(component, event,accountId,campusId,deptId); 
        }else{
         
            helper.doSearch(component, event); 
        }

        
    
    },
    doHandlePageChange : function(component, event, helper){ 
    	helper.doHandlePageChange(component, event);
    }
})