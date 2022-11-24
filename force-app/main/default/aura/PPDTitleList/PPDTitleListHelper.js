({
    fetchTitles: function (cmp) {
        var recordID = cmp.get("v.recordId");
        var action = cmp.get("c.getBundleTitles");
        var pageSize = cmp.get("v.pageSize");
        var paginationList = []; 
        var fullList = [];               
        
        //action.setStorable();
        action.setParams({
            "bundleID":recordID,
        });
        action.setCallback(this, function(response) {
            console.log('# getBundleTitles callback %f', (performance.now() - startTime));
            var state = response.getState();
            if (state === "SUCCESS"){
                
                var result = response.getReturnValue();
                fullList = result.products;
                cmp.set("v.fullData", fullList); 
                cmp.set("v.recordCount",result.total);
                //New Pagination
                cmp.set("v.maxPage", Math.floor((fullList.length+9)/10)); 
                var test=cmp.get("v.maxPage");         
                this.sortBy(cmp, "Publisher__c");
                //New Pagination      
                var selectedrws = [];  
                cmp.set("v.selectedRows",selectedrws);
            }else if (state == "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "message": "No Internet Connection"
                });
                toastEvent.fire();
                
            } else if (state == "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "There was an issue while processing, please contact SFDC system admin."
                });
                toastEvent.fire();
            }
            
        });
        var startTime = performance.now();
        $A.enqueueAction(action);
    },
    
    removeTitle: function (cmp, row, event) {
        var row = event.getParam('row');
        var action = cmp.get("c.deleteProductFromStaticCollection");
        action.setParams({
            "parentProductID":cmp.get("v.recordId"),
            "productID":row.Id,
        })
        $A.enqueueAction(action);
        
        // Remove from the view
        var rows = cmp.get('v.data');
        var rowIndex = rows.indexOf(row);
        rows.splice(rowIndex, 1);
        cmp.set('v.data', rows);        
    },
    
    deleteTitles: function (component, event) { 
        
        var parentProductID = component.get("v.recordId");
        var listProductIDs = component.get("v.selectedProductsDetails");       
        var action = component.get("c.deleteProducts");    
        action.setParams({
            "parentProductID": parentProductID,
            "listProductIds" : listProductIDs
        }); 
        console.log("listProductIDs"+listProductIDs);
        console.log("parentProductID"+parentProductID);
        action.setCallback(this, function(response) {
            console.log('# deleteProducts callback %f', (performance.now() - startTime));
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                component.set("v.selectedRowsCount",0);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Products Deleted!",
                    "message": result
                });
                toastEvent.fire(); 
                var selectedrws = [];  
                component.set("v.selectedRows",selectedrws);
                this.disableApprovalBtn(component, event);
            }else if (state == "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "message": "No Internet Connection"
                });
                toastEvent.fire();
                
            } else if (state == "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "There was an issue while processing, please contact SFDC system admin."
                });
                toastEvent.fire();
            }
        });
        var startTime = performance.now();
        $A.enqueueAction(action);
        
    },
    
    deleteAllTitles: function (component, event) { 
        
        var parentProductID = component.get("v.recordId");
        var action = component.get("c.deleteAllProducts");    
        action.setParams({
            "parentProductID": parentProductID
        }); 
        action.setCallback(this, function(response) {
            console.log('# deleteProducts callback %f', (performance.now() - startTime));
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                component.set("v.IsSpinner",false);
                component.set("v.selectedRowsCount",0);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Products Deleted!",
                    "message": result
                });
                toastEvent.fire(); 
                this.disableApprovalBtn(component, event);
            }else if (state == "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "message": "No Internet Connection"
                });
                toastEvent.fire();
                
            } else if (state == "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "There was an issue while processing, please contact SFDC system admin."
                });
                toastEvent.fire();
            }
            
            
        });
        var startTime = performance.now();
        $A.enqueueAction(action);
        component.set("v.IsSpinner",true);
        
    },
    
    
    
    sortData: function (component, fieldName, sortDirection) {     
        this.sortBy(component,fieldName)        
        
    },      
    
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
    
    renderPage: function(component) {
        var records = component.get("v.fullData"),
            pageNumber = component.get("v.pageNumber"),         
            pageRecords = records.slice((pageNumber-1)*10, pageNumber*10);
        component.set("v.data", pageRecords);
    },
    
    disableApprovalBtn: function(cmp, event){
        
        var parentProductID = cmp.get("v.recordId");
        var act = cmp.get("c.getBundleItmsCount");    
        act.setParams({
            "bundleID": parentProductID            
        }); 
        
        act.setCallback(this, function(response) {  
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                
                if(result <= 0){
                    var enableButtonEvt = $A.get("e.c:PPDGenericEvent");
                    enableButtonEvt.setParam("disableButton","validateButton");
                    enableButtonEvt.setParam("buttonValue",true);
                    enableButtonEvt.fire();
                }
            }else if (state == "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "message": "No Internet Connection"
                });
                toastEvent.fire();
                
            } else if (state == "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "There was an issue while processing, please contact SFDC system admin."
                });
                toastEvent.fire();
            }
            
            
            
        });
        var startTime = performance.now();
        $A.enqueueAction(act);   
        
    }
    
})