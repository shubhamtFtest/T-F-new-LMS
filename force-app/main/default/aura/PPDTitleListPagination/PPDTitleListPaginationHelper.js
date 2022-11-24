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
            var result = response.getReturnValue();
            fullList = result.products;
            cmp.set("v.fullData", fullList);
           
            cmp.set("v.maxPage", Math.floor((fullList.length+9)/10)); 
            var test=cmp.get("v.maxPage");
         
            this.sortBy(cmp, "Publisher__c");
            
            cmp.set("v.selectedRows",[]);
           
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
            var result = response.getReturnValue();
            component.set("v.selectedRowsCount",0);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Products Deleted!",
                "message": result
            });
            toastEvent.fire();           
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
            var result = response.getReturnValue();
            component.set("v.IsSpinner",false);
            component.set("v.selectedRowsCount",0);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Products Deleted!",
                "message": result
            });
            toastEvent.fire();           
        });
        var startTime = performance.now();
        $A.enqueueAction(action);
        component.set("v.IsSpinner",true);
        
    },
    
    next: function(cmp){ 
        var fullList = cmp.get("v.fullData");
        var paginationList = [];  
        var end = cmp.get("v.end"); 
        var start = cmp.get("v.start"); 
        
        
        
        var pageSize = cmp.get("v.pageSize"); 
        var counter = 0; 
        
        
        for(var i=end+1; i<end+pageSize+1; i++){ 
            if(fullList.length > end && i <= (fullList.length)-1) 
            { 
                paginationList.push(fullList[i]); 
                counter ++ ; 
            } 
        } 
        start = start + counter; 
        end = end + counter;         
        cmp.set("v.start",start); 
        cmp.set("v.end",end);         
        cmp.set('v.data', paginationList); 
        
    }, 
    
    previous: function(cmp){ 
        console.log('in previous helper');
        var fullList = cmp.get("v.fullData");
        var end = cmp.get("v.end"); 
        var start = cmp.get("v.start");        
        
        
        var pageSize = cmp.get("v.pageSize"); 
        var paginationList = [];         
        var counter = 0; 
        for(var i= start-pageSize; i < start ; i++) 
        { 
            if(i > -1) 
            { 
                paginationList.push(fullList[i]); 
                counter ++; 
            } 
            else { 
                start++; 
            } 
        } 
        start = start - counter; 
        end = end - counter;         
        cmp.set("v.start",start); 
        cmp.set("v.end",end);       
        cmp.set('v.data', paginationList);        
        
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
    }
    
    
})