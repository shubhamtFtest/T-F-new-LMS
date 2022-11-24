({
    sortBy: function (component, field) {
        
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.fullData");
        
        sortAsc = sortField != field || !sortAsc;
        records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.fullData", records);
        this.renderPage(component);
    },
    
    sortData: function (component, fieldName, sortDirection) {     
        this.sortBy(component,fieldName)        
        
    },  
    
    renderPage: function(component) {     
        var records = component.get("v.fullData"),
            pageNumber = component.get("v.pageNumber"),         
            pageRecords = records.slice((pageNumber-1)*50, pageNumber*50);
        component.set("v.data", pageRecords);
    },
    
    getUnsiloXML : function (cmp, event) {
        var action = cmp.get("c.callUnsiloWithRetry");
        var fullList = []; 
        var conType = cmp.get("v.contentType");
        
        action.setParams({
            "classid": cmp.get("v.classesId"),
            "exportid": cmp.get("v.exportId"),
            "retryCount": '3',
            "type": conType
        });
        
        action.setCallback(this, function(response) {
            var result = response.getReturnValue(); 
            
            //fullList = result;
            if(result != null && result.prList != null){ 
                var resultdata = result.prList;
                cmp.set("v.fullData", result.prList);  
             
                //New Pagination
                if(result != null){
                    cmp.set("v.recordCount",resultdata.length);
                    cmp.set("v.maxPage", Math.floor((resultdata.length+49)/50));         
                    this.sortBy(cmp, "Publisher__c");
                }
            }else if(result != null && result.msg != 'Success'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "message": result.msg
                });
                toastEvent.fire(); 
            }
            
            //New Pagination
            
            //cmp.set("v.data",result);
            cmp.set("v.activeAccordion",'result');
            cmp.find("accordion").set('v.activeSectionName',cmp.get("v.activeAccordion"));
            cmp.set("v.IsSpinner",false);
            
        });
        
        $A.enqueueAction(action);
        cmp.set("v.IsSpinner",true);
    },
    
    loadCollections: function (cmp) {
        var action = cmp.get("c.getUnsiloCollections");
        var conType = cmp.get("v.contentType");
        
        action.setParams({
            "type": conType
        });
        
        action.setCallback(this, function(response) {
            var result = response.getReturnValue(); 
            
            if(result != null && result.prList != null){
                var noneVal = {
                    label: "--None--",
                    value: "--None--"
                };
                var resultdata = this.sortUnsiloData(result.prList,'label');
                // cmp.set("v.collections", result.prList);
                resultdata.unshift(noneVal)
                cmp.set("v.collections", resultdata);
            }else if(result != null && result.msg != 'Success'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "message": result.msg
                });
                toastEvent.fire(); 
            }
            cmp.set("v.IsSpinner",false);
        });
        
        $A.enqueueAction(action);
        cmp.set("v.IsSpinner",true);
    },
    
    loadClasses: function (cmp, classId) {
        
        var action = cmp.get("c.getUnsiloClasses");
		var conType = cmp.get("v.contentType");
        action.setParams({
            "collectionId":classId,
			"type": conType
        });
        
        action.setCallback(this, function(response) {
            var result = response.getReturnValue(); 
            
            if(result != null && result.prList != null){ 
                var resultdata = this.sortUnsiloData(result.prList,'label');
                var noneVal = {
                    label: "--None--",
                    value: "--None--"
                };
                resultdata.unshift(noneVal);
                cmp.set("v.classes", resultdata);
                
            }else if(result != null && result.msg != 'Success'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "message": result.msg
                });
                toastEvent.fire(); 
            }
            cmp.set("v.IsSpinner",false);
        });
        $A.enqueueAction(action);
        cmp.set("v.IsSpinner",true);
    },
    
    getExportId: function (cmp,evt,classId) {
        
        var action = cmp.get("c.getUnsiloExportId");
        var conType = cmp.get("v.contentType");
        
        action.setParams({
            "classId":classId,
            "type": conType
        });
        
        action.setCallback(this, function(response) {
            var result = response.getReturnValue(); 
            
            if(result != null && result.msg == 'Success' && result.exportId){ 
                var expId = result.exportId;
                cmp.set("v.exportId",expId);
                cmp.set("v.IsSpinner",false);
                console.log('exportId2: '+expId);
            }else if(result != null && result.msg != 'Success'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "message": result.msg
                });
                toastEvent.fire(); 
            }
        });
        $A.enqueueAction(action);
        cmp.set("v.IsSpinner",true);
        
    },
    
    sortUnsiloData: function (records,field) {
        
        var sortAsc = true ;
        
        records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
        });
        return records ;
    }
    
})