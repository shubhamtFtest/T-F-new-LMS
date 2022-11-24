({
    fetchProductFromPCM: function (cmp, resetPageIndex) {
        var thisUUID = cmp.get("v.uuId"); 
        
        var productType=cmp.get("v.productType");  
        var actionCount=cmp.get("c.getProductsFromPCMById");
        actionCount.setParams({ 
            "bundleID":thisUUID,
            "productType":productType
        });
        
        actionCount.setCallback(this, function(response) {
            console.log('# getProducts callback %f', (performance.now() - startTime));
            var state = response.getState();
            var result = response.getReturnValue();
            
            if (state === "SUCCESS"){     
                if(result.msg=="Success"){                 
                    //cmp.set("v.fullData", result.prList);
                    cmp.set("v.totalRecordCount", result.total);
                    cmp.set("v.recordCount",result.total);
                    cmp.set("v.returnProductType",result.productTypeReturned);                   
                    cmp.set("v.productType",result.productTypeReturned);
                    //(cmp.get("v.productType"));
                    var recCountLst = result.counts;  
                    if(result.prList && result.prList.length > 1){
                        cmp.set("v.showProductTypes",true);                            
                        var radioOptions = [];
                        for(var rec of result.prList){
                            if(rec.type != 'Total'){
                                var radioOption = {
                                    label: rec.count,
                                    value: rec.type
                                }
                                radioOptions.push(radioOption);
                            } 
                            
                            if(rec.type == result.productTypeReturned){
                                cmp.set("v.recordCount",rec.count);                                    
                            }
                        }                            
                        cmp.set("v.radioOptions",radioOptions);  
                        
                    }else{                           
                        var radioOptions = [];
                        cmp.set("v.showProductTypes",false);
                        cmp.set("v.radioOptions",radioOptions);                            
                    }  
                    
                    this.fetchPartsFromPCM(cmp, resetPageIndex);
                }
            }
            else if (state == "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "message": "No Internet Connection"
                });
                toastEvent.fire();
                cmp.set("v.IsSpinner",false);
                
                var progressEvt = $A.get("e.c:PPDProgressEvent");
                progressEvt.setParam("showStatusBar",false);
                progressEvt.setParam("progressPercent",0);
                progressEvt.setParam("progressFor",'Progress Status :');
                
                progressEvt.fire();
                
            } else if (state == "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "There was an issue while processing, please contact SFDC system admin."
                });
                toastEvent.fire();
                component.set("v.IsSpinner",false);
                
                var progressEvt = $A.get("e.c:PPDProgressEvent");
                progressEvt.setParam("showStatusBar",false);
                progressEvt.setParam("progressPercent",0);
                progressEvt.setParam("progressFor",'Progress Status :');                
                progressEvt.fire();
            }
        });
        var startTime = performance.now();
        $A.enqueueAction(actionCount);
        cmp.set("v.IsSpinner", true); 
    },
    
    fetchPartsFromPCM: function (cmp, resetPageIndex) {
        var recordID = cmp.get("v.recordId");     
        var productType=cmp.get("v.productType");    
        
        var action = cmp.get("c.getPartsFromPCMNewDataModel");        
        var pageSize = cmp.get("v.pageSize");
        var paginationList = []; 
        var fullList = []; 
        var position = cmp.get("v.pstn") ;
        
        action.setParams({ 
            "bundleID":recordID,
            "position": position.toString(),
            "productType":cmp.get("v.returnProductType")         
        });
        
        
        action.setCallback(this, function(response) {
            console.log('# getBundleTitles callback %f', (performance.now() - startTime));
            cmp.set("v.IsSpinner", false);
            // alert(cmp.get("v.productType"))
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                if(result.msg == 'Success'){                    
                    fullList = result.prList;
                    
                    cmp.set("v.fullData", fullList);           
                    //cmp.set("v.recordCount",result.total);
                    //cmp.set("v.recordCount",cmp.get("v.totalRecordCount")); 
                    cmp.set("v.totalMaxPage", Math.floor((cmp.get("v.recordCount")+cmp.get("v.pageSize")-1)/cmp.get("v.pageSize")));
                    cmp.set("v.maxPage", Math.floor((cmp.get("v.recordCount")+cmp.get("v.pageSize")-1)/cmp.get("v.pageSize")));
                    
                    if(cmp.get("v.maxPage") == 0){
                        cmp.set("v.maxPage", 1);
                    }
                    
                    this.renderPage(cmp);
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": result.msg
                    });
                    toastEvent.fire();
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
        $A.enqueueAction(action);
        cmp.set("v.IsSpinner", true);  
        
    },
    
    fetchBLIFromProduct: function (cmp, resetPageIndex ) {
        debugger;
       
        var recordID = cmp.get("v.recordId");   
        var action = cmp.get("c.getBundleLineItemsByProductId");        
        var pageSize = cmp.get("v.pageSize");
        var paginationList = []; 
        var fullList = []; 
        var position = cmp.get("v.pstn") ;
        
        action.setParams({ 
            "productId":recordID,
        });
        action.setCallback(this, function(response) {
            console.log('# getBundleTitles callback %f', (performance.now() - startTime));
            cmp.set("v.IsSpinner", false);
            // alert(cmp.get("v.productType"))
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                cmp.set('v.data', result);
                cmp.set("v.fullData", result); 
                cmp.set("v.recordCount",result.length);
                //cmp.set("v.recordCount",cmp.get("v.totalRecordCount")); 
                cmp.set("v.totalMaxPage", Math.floor((cmp.get("v.recordCount")+cmp.get("v.pageSize")-1)/cmp.get("v.pageSize")));
                cmp.set("v.maxPage", Math.floor((cmp.get("v.recordCount")+cmp.get("v.pageSize")-1)/cmp.get("v.pageSize")));
                
                if(cmp.get("v.maxPage") == 0){
                    cmp.set("v.maxPage", 1);
                }
                
                this.renderPage(cmp);
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
        cmp.set("v.IsSpinner", true);  
        
    },
    
    renderPage: function(cmp) {        
        var pgsPerQry = cmp.get("v.pagesPerQuery");
        var records = cmp.get("v.fullData") ;
        var pageNumber = cmp.get("v.pageNumber") ; 
        if(pageNumber > pgsPerQry && cmp.get("v.nxtClked") == 'true'){
            pageNumber = pageNumber % pgsPerQry ; 
            
            if(pageNumber == 0){
                pageNumber = pgsPerQry ;
            }
        }else if(cmp.get("v.prevClked") == 'true'){
            if(pageNumber % pgsPerQry == 0){
                pageNumber = pgsPerQry ;
            }else{
                pageNumber = pageNumber % pgsPerQry ;
            }
        }else if(pageNumber == cmp.get("v.maxPage") && cmp.get("v.nxtClked") == 'false'){
            pageNumber = pageNumber % pgsPerQry ;
            if(pageNumber == 0){
                pageNumber = pgsPerQry;
            }
        }
        
        var pageRecords = records.slice((pageNumber-1)*cmp.get("v.pageSize"), pageNumber*cmp.get("v.pageSize"));
        
        cmp.set("v.data", pageRecords);
    },
    
    getAllSelectedIds : function (cmp,pgNum) { 
        debugger;
        var dat = cmp.find("contentTable");
        var selectedRows = dat.getSelectedRows();
        
        var selRows = cmp.get("v.selectedRows"); 
        if(selRows && selRows.length > 0){
            cmp.set("v.selectedRows",selRows);
        }
    },
    
    deleteAllTitles: function (component, event) { 
        debugger;
        var lineItems = component.get("v.data");
        
        //component.set("v.IsSpinner",false);
        var parentProductID = component.get("v.recordId");
        var action = component.get("c.deleteAllSpecifiedBundles");
       
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
                    "title": "Deleted!",
                    "message": result
                });
                toastEvent.fire();
                var newEvent = $A.get("e.c:PPDRefreshListEvent");
                newEvent.setParam("listToRefresh","UnsiloListDelete");
                newEvent.fire();
             
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
    
    delSelectedTitlesHlpr: function (component, event) { 
        debugger;
        var bundleItems = component.get("v.selectedData");
        var action = component.get("c.deleteSpecifiedBundles");
        
        action.setParams({
            "bundleItems": bundleItems
        });
        
        action.setCallback(this, function(response) {
            console.log('# deleteProducts callback %f', (performance.now() - startTime));
            var state = response.getState();
            if (state === "SUCCESS"){
                component.set("v.IsSpinner",false);
                
                var result = response.getReturnValue();
                var cmpEvent = $A.get("e.c:RefreshPCMOppComp");
                cmpEvent.fire();
                
                component.set("v.selectedRowsCount",0);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Deleted!",
                    "message": result
                });
                toastEvent.fire();
                var newEvent = $A.get("e.c:PPDRefreshListEvent");
                newEvent.setParam("listToRefresh","UnsiloListDelete");
                newEvent.fire();
                
               
                
                
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
    
})