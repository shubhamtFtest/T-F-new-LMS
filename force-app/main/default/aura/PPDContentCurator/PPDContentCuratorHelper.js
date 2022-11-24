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
        this.sortBy(component,fieldName);        
    },  
    
    renderPage: function(component) {
        var records = component.get("v.fullData"),
            pageNumber = component.get("v.pageNumber"),         
            pageRecords = records.slice((pageNumber-1)*20, pageNumber*20);
        component.set("v.data", pageRecords);
    },
    
    getContentCurator : function (cmp, event) {
        var action = cmp.get("c.callContentCurator");
        var fullList = []; 
        
        action.setCallback(this, function(response) {
            var result = response.getReturnValue(); 
            //fullList = result;
            if(result != null && result.prList != null){ 
                var resultdata = result.prList;
                cmp.set("v.fullData", result.prList);  
                //New Pagination
                if(result != null){
                    cmp.set("v.recordCount",resultdata.length);
                    cmp.set("v.maxPage", Math.floor((resultdata.length+19)/20));  
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
            cmp.set("v.activeAccordion",'result');
            cmp.find("accordion").set('v.activeSectionName',cmp.get("v.activeAccordion"));
            cmp.set("v.IsSpinner",false);
            
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
    },
    
    addSelectedCuratedContent: function (component, event) {
        var parentProductID = component.get("v.recordId");
        var listContentIDs = component.get("v.selectedCuratedContentDetails");
        var dataList = component.get("v.selectedRowsList");
        var action = component.get("c.addContents");    
        action.setParams({
            "productID": parentProductID,
            "contentsListJSON" : JSON.stringify(dataList),
            "classId" : '0',
            "source" : 'CMS'
            
        });     
        action.setCallback(this, function(response) {
            var result = response.getReturnValue(); 
            component.set("v.IsSpinner",false);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Contents Added!",
                "message": "Selected curated content has been added!"
            });
            toastEvent.fire();
            
            var enableButtonEvt = $A.get("e.c:PPDGenericEvent");
            enableButtonEvt.setParam("disableButton","ApprovalButton");
            enableButtonEvt.setParam("buttonValue",true);
            
            enableButtonEvt.fire();
            
            var newEvent = $A.get("e.c:PPDRefreshListEvent");
            newEvent.setParam("listToRefresh","UnsiloList");
            newEvent.fire();
            
        });
        $A.enqueueAction(action);
        component.set("v.IsSpinner",true);
    }
    
})