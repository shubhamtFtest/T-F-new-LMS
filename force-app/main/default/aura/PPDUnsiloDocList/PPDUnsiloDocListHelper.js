({
    fetchTitles: function (cmp, resetPageIndex) {
       
        var recordID = cmp.get("v.recordId");
        var action = cmp.get("c.getUnsiloBundleRecords");
        var pageSize = cmp.get("v.pageSize");
        var paginationList = []; 
        var fullList = []; 
        var position = cmp.get("v.pstn") ;
        var lstLmt = cmp.get("v.lastPgLmt") ;
        var evt = cmp.get("v.paginationEvt") ;
        var addCriteria = cmp.get("v.showingSelectiveDel") ;
        if(addCriteria == 'true'){
            addCriteria = 'unsilo';
        }else if(cmp.get('v.additionType') == 'Exclusion'){
            addCriteria = 'Exclusion';
        }
        
        if((cmp.get("v.IsRecordLocked")=='true') && (cmp.get("v.collectionType") == 'Rule based')){
            
            cmp.set("v.hideCheckbox",false); 
        }
        else if((cmp.get("v.IsRecordLocked")=='false')&& (cmp.get("v.collectionType") == 'Rule based'))
        {
            cmp.set("v.hideCheckbox",true);
        }
        cmp.set("v.showingAll","true");
        
        console.log("===pstn==="+ position);
        //action.setStorable();
        action.setParams({ 
            "bundleID":recordID,
            "position": position.toString(),
            "lastPageLimit": lstLmt.toString(),
            "evnt": evt,
            "addionalCriteria": addCriteria
        });
        action.setCallback(this, function(response) {
            console.log('# getBundleTitles callback %f', (performance.now() - startTime));
            cmp.set("v.IsSpinner", false);
            cmp.set("v.showingValidation", "false");
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                fullList = result.prList;
                
                cmp.set("v.nexPstn", result.nextPstn);  
                cmp.set("v.prvPstn", result.prevPstn);           
                cmp.set("v.fullData", fullList);           
                cmp.set("v.recordCount",result.total);
                console.log("result.nextPstn"+ result.nextPstn);
                console.log("result.prevPstn"+ result.prevPstn);
                
                //New Pagination
                // cmp.set("v.maxPage", Math.floor((fullList.length+cmp.get("v.pageSize")-1)/cmp.get("v.pageSize"))); 
                cmp.set("v.totalMaxPage", Math.floor((cmp.get("v.recordCount")+cmp.get("v.pageSize")-1)/cmp.get("v.pageSize")));
                cmp.set("v.maxPage", Math.floor((cmp.get("v.recordCount")+cmp.get("v.pageSize")-1)/cmp.get("v.pageSize")));
				if(cmp.get("v.maxPage") == 0){
                    cmp.set("v.maxPage", 1);
                }
                this.sortBy(cmp, "content_Position");
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
        
        //var newEvent = $A.get("e.c:PPDGenericEvent");
        //newEvent.setParam("disableButton","ApprovalButton");
        //newEvent.setParam("buttonValue",true);
        //newEvent.setParam("buttonValue",false);  // to be changed to true once we have validate api ready.
        
        //newEvent.fire();
    },
    
    deleteAllTitles: function (component, event) { 
        var parentProductID = component.get("v.recordId");
        var action = component.get("c.deleteAllSpecifiedDocs");
        var delWhat = 'All';
        if(component.get('v.collectionType') == 'Manual Curation'){
            delWhat = 'All' ;
        }else if(component.get('v.collectionType') == 'Rule based'){
            if(component.get('v.additionType') == 'Inclusion'){
                delWhat = 'Inclusion' ;
            }else{
                delWhat = 'Exclusion' ;
            }
        }
        action.setParams({
            "parentProductID": parentProductID,
            "docsToDel": delWhat
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
                
                var totalPriceEvt = $A.get("e.c:PPDTotalPriceRefreshEvent");
                totalPriceEvt.setParam("isStatic",'true');
                totalPriceEvt.fire();
                
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
    
    saveEdition: function (component, draftValues) { 
        console.log('draftValues1'+JSON.stringify(draftValues));
        var action = component.get("c.updateContents");    
        action.setParams({
            "contentsListJSON": JSON.stringify(draftValues)
        }); 
        action.setCallback(this, function(response) {
            console.log('# update content data callback %f', (performance.now() - startTime));
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                component.set("v.IsSpinner",false);
                component.set("v.selectedRowsCount",0);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "message": result
                });
                toastEvent.fire();
                var newEvent = $A.get("e.c:PPDRefreshListEvent");
                newEvent.setParam("listToRefresh","UnsiloListUpdate");
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
    
    fetchSearchResult: function (cmp) {
        this.resetSelectedIds(cmp);
        var recordID = cmp.get("v.recordId");
        var pageSize = cmp.get("v.pageSize");
        var queryTerm = cmp.get("v.searchQueryText");
        var pageSize = cmp.get("v.pageSize");
        var paginationList = []; 
        var fullList = []; 
        var calledEvt = cmp.get("v.calledEvent");
        calledEvt = calledEvt + cmp.get('v.additionType');
        var action = cmp.get('c.getUnsiloBundleRecordsBySearchSOSQL');
        action.setParams({
            "searchText": queryTerm,
            "bundleID": recordID,
            "evt": calledEvt
        });
        
        action.setCallback(this, function(response) {
            
            if(cmp.get("v.calledEvent") != 'Validation'){
                cmp.set("v.showingValidation", "false");
            }
            console.log('# getUnsiloBundleRecordsBySearchSOSQL callback %f', (performance.now() - startTime));
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                fullList = result.prList;
                cmp.set("v.fullData", fullList);           
                cmp.set("v.totalSize", fullList.length);              
                cmp.set("v.recordCount",result.total);
                
                //New Pagination
                cmp.set("v.maxPage", Math.floor((fullList.length+cmp.get("v.pageSize")-1)/cmp.get("v.pageSize")));
                if(cmp.get("v.maxPage") == 0){
                    cmp.set("v.maxPage", 1);
                }
                cmp.set("v.pageNumber",1);
                var test=cmp.get("v.maxPage");         
                this.sortBy(cmp, "Publisher__c");
                cmp.set("v.IsSpinner", false);
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
    //Sorting and Pagination
    sortData: function (component, fieldName, sortDirection) {     
        this.sortBy(component,fieldName)        
        
    },  
    
    sortBy: function (component, field) {
        
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.fullData");
        if(field == "content_Position"){
            sortAsc = true;
        }else{
            sortAsc = sortField != field || !sortAsc;
        }
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
    
    renderPage: function(cmp) {
        this.getAllSelectedIds(cmp);
        // cmp.set("v.selectedRows",cmp.get("v.selectedRows"));
        
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
    
    submitCollection: function (cmp, event) { 
        
        var productID = cmp.get("v.recordId");
        
        var action = cmp.get('c.putCollectionJsonToS3AndNotify');
        action.setParams({
            "productId": productID
        });
        
        action.setCallback(this, function(response) {
            var successMsg ;
            var errorMsg ;
            var errorCode ;
            var msg ;
            console.log('# submitCollection callback %f', (performance.now() - startTime));
            cmp.set("v.IsSpinner", false);
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                successMsg = result.successMsg;
                errorMsg = result.errorMsg;
                errorCode = result.errorCode;
                cmp.set("v.snsMessageId", result.snsMessageId);
                cmp.set("v.s3Url", result.s3URL);
                
                if(successMsg != ''){
                    msg = successMsg;
                }else{
                    msg = errorMsg;
                }
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "message": msg
                });
                toastEvent.fire();
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
    
    validateAllLineItmHlpr: function(component, event, helper) {     
        
        var recId = component.get("v.recordId");
        var totalRecords = component.get("v.totalRecs");         
        var processedRecords = component.get("v.processedRecs");  
        var pos = component.get("v.pstnv");         

        var action=component.get("c.validateContentList");
        action.setParams({
            "productId":recId,
            "position":pos.toString(),
            "processedRecCount":processedRecords.toString(),
            "totalRecCount":totalRecords.toString()
        });
        action.setCallback(this, function(response) {   
            var state = response.getState();
            if(state=="SUCCESS"){

                var result = response.getReturnValue(); 
                
                console.log('result.processedRecords'+result.processedRecords);
                console.log('result.position'+result.position);
                console.log('result.totalRecords'+result.totalRecords);
                console.log('result.moreRecsToProcess'+result.moreRecsToProcess);
                
                
                component.set("v.processedRecs",result.processedRecords); 
                component.set("v.pstnv",result.position);
                component.set("v.totalRecords",result.totalRecords);
                
                if(result.moreRecsToProcess == 'True'){
                    
                    var progPercent = Math.floor((result.processedRecords / result.totalRecords) * 100)
                    var valProgressEvt = $A.get("e.c:PPDProgressEvent");
                    valProgressEvt.setParam("showStatusBar",true);
                    valProgressEvt.setParam("progressPercent",progPercent);
                    valProgressEvt.setParam("progressFor",'Validation Progress Status :');
                    
                    valProgressEvt.fire();
                    var valFor ;
                    if(component.get('v.collectionType') == 'Manual Curation'){
                        valFor = '';
                    }else{
                        valFor = 'Exclusion'; 
                    }
                    var valEvt = $A.get("e.c:PPDGenericEvent");
                    valEvt.setParam("validateAllItems",true);
                    valEvt.setParam("validationFor",valFor);
                    valEvt.fire();
                }else if(result.msg != 'Success'){
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": result.msg
                    });
                    toastEvent.fire();
                    component.set("v.IsSpinner", false);
                    component.set("v.processedRecs","0"); 
                    component.set("v.pstnv","0");
                    component.set("v.totalRecords","0");
                    var valProgressEvt = $A.get("e.c:PPDProgressEvent");
                    valProgressEvt.setParam("showStatusBar",false);
                    valProgressEvt.setParam("progressPercent",0);
                    valProgressEvt.setParam("progressFor",'Progress Status :');
                    
                    valProgressEvt.fire();
                    
                    var enableButtonEvt = $A.get("e.c:PPDGenericEvent");
                    enableButtonEvt.setParam("disableButton","ApprovalButton");
                    enableButtonEvt.setParam("buttonValue",true);
                }else{
                    var valResEvt = $A.get("e.c:PPDGenericEvent");
                    valResEvt.setParam("showValidationResult",true);
                    valResEvt.fire();
                    component.set("v.IsSpinner", false);
                    component.set("v.processedRecs","0"); 
                    component.set("v.pstnv","0");
                    component.set("v.totalRecords","0");
                    var valProgressEvt = $A.get("e.c:PPDProgressEvent");
                    valProgressEvt.setParam("showStatusBar",false);
                    valProgressEvt.setParam("progressPercent",0);
                    valProgressEvt.setParam("progressFor",'Progress Status :');
                    
                    valProgressEvt.fire();
                    
                    var enableButtonEvt = $A.get("e.c:PPDGenericEvent");
                    enableButtonEvt.setParam("disableButton","ApprovalButton");
                    enableButtonEvt.setParam("buttonValue",false);
                    
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
        $A.enqueueAction(action);
        component.set("v.IsSpinner", true);  
        
    },
    
    getAllSelectedIds : function (cmp,pgNum) { 
        var dat = cmp.find("contentTable");
        var selectedRows = dat.getSelectedRows();
        
        var selRows = cmp.get("v.selectedRows"); 
        if(selRows && selRows.length > 0){
            cmp.set("v.selectedRows",selRows);
        }
        var pageNum ;
        
        if(pgNum){
            pageNum = pgNum;
        }else{
            pageNum = cmp.get("v.prevPageNum");
        }
        console.log('pageNum'+pageNum);
        var allselectedRows = cmp.get("v.allSelected");
        
        if(! allselectedRows){
            allselectedRows = [];
        }
        console.log('length:'+allselectedRows.length);
        console.log('getSelectedRows:'+JSON.stringify(selectedRows));
        
        if(selectedRows.length > 0){
            var pageAdded = 'false';
            if(allselectedRows.length > 0){
                allselectedRows.forEach(function(val, index){
                    if(val.pageNum == pageNum){
                        val.rows = selectedRows.map(function myFunction(value) {
                            return value.id;
                        }) ;
                        pageAdded = 'true';
                    }
                }); 
                if(pageAdded == 'false'){
                    var selected = {
                        pageNum: pageNum,
                        rows : selectedRows.map(function myFunction(value) {
                            return value.id;
                        }),
                    };
                    allselectedRows.push(selected);
                }
                
            }else if(allselectedRows.length == 0){
                var selected = {
                    pageNum: pageNum,
                    rows : selectedRows.map(function myFunction(value) {
                        return value.id;
                    }),
                };
                allselectedRows.push(selected);
            }
        }else if(selectedRows.length == 0){
            var indexToSplice = -1;
            if(allselectedRows.length > 0){
                allselectedRows.forEach(function(val, index){
                    if(val.pageNum == pageNum){
                        indexToSplice = index;
                    }
                });  
                if(indexToSplice != -1){
                    allselectedRows.splice(indexToSplice,1);
                }
            }
        }
        console.log('allselectedRows:'+JSON.stringify(allselectedRows));
        cmp.set("v.allSelected",allselectedRows);
        var uiSelectedRowsArray = [];
        if(allselectedRows.length > 0){
            uiSelectedRowsArray = allselectedRows.map(function myFunction(value) {
                return value.rows;
            });
        }
        console.log('uiSelectedRowsArray:'+JSON.stringify(uiSelectedRowsArray));
        
        var uiSelectedRows = [];
        uiSelectedRowsArray.forEach(function(val, index){
            uiSelectedRows = uiSelectedRows.concat(val);
        });
        
        console.log('uiSelectedRows:'+JSON.stringify(uiSelectedRows));
        
        cmp.set("v.selectedRows",uiSelectedRows) ;
    },
    
    resetSelectedIds : function(cmp){
        var reset = [];
        cmp.set("v.allSelected",reset);
        cmp.set("v.selectedRows",reset);
        cmp.set("v.disableDelSelected",true);
        cmp.set("v.pageNumber",1);
        
        
    },
    
    delSelectedTitlesHlpr: function (component, event) { 
        
        var parentProductID = component.get("v.recordId");
        var action = component.get("c.deleteSelectedDocs"); 
        var selecRecs = [];
        selecRecs = component.get("v.selectedRows");
        console.log('selectedidsJSON'+JSON.stringify(selecRecs));
        action.setParams({
            "parentProductID": parentProductID,
            "idsToDeleteJSON": JSON.stringify(selecRecs)
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
                this.resetSelectedIds(component);//showingAll
                /* if(component.get("v.showingSearch") == 'true' && component.get("v.showingAll") == 'false' && component.get("v.showingValidation") != 'true'){
                this.fetchSearchResult(component);

            }else if(component.get("v.showingValidation") == 'true' && component.get("v.showingAll") == 'false' ){
                var valResEvt = $A.get("e.c:PPDGenericEvent");
                valResEvt.setParam("showValidationResult",true);
                valResEvt.fire();
            }else{
                var newEvent = $A.get("e.c:PPDRefreshListEvent");
                newEvent.setParam("listToRefresh","UnsiloListDelete");
                newEvent.fire();

            }*/
                var newEvent = $A.get("e.c:PPDRefreshListEvent");
                newEvent.setParam("listToRefresh","UnsiloListDelete");
                newEvent.fire();
                
                var totalPriceEvt = $A.get("e.c:PPDTotalPriceRefreshEvent");
                totalPriceEvt.setParam("isStatic",'true');
                totalPriceEvt.fire();
                
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
        
    },
    
    moveSelectedTitlesHlpr: function (component, event) { 
        
        var parentProductID = component.get("v.recordId");
        var action = component.get("c.moveSelectedDocs"); 
        var selecRecs = [];
        selecRecs = component.get("v.selectedRows");
        console.log('selectedidsJSON'+JSON.stringify(selecRecs));
        action.setParams({
            "parentProductID": parentProductID,
            "idsToMoveJSON": JSON.stringify(selecRecs)
        }); 
        action.setCallback(this, function(response) {
            console.log('# moveProducts callback %f', (performance.now() - startTime));
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                component.set("v.IsSpinner",false);
                component.set("v.selectedRowsCount",0);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Re positioned!",
                    "message": result
                });
                toastEvent.fire();
                this.resetSelectedIds(component);//showingAll
                
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