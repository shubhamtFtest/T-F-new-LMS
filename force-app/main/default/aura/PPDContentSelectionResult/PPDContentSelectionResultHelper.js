({    
    loadProducts : function(component, resetPageIndex, countStr) {
        console.log('pstn'+component.get("v.pstn"));
      
        
        var svdRul = 'false';
        if(component.get("v.calledFrom") == 'Titles'){
            svdRul = 'true';
        }
        
        var position = component.get("v.pstn") ;
        var limitVal = component.get("v.queryLimit");          
        var action ;
        var actionCount;
        var isDunamicUi = component.get("v.isDynamicUI");
        var cursorOffsetValue ;
        
        if(isDunamicUi == 'false'){
            actionCount=component.get("c.getCountsFromPCM_DynamicUI");
            action = component.get("c.getProductsFromPCM");
        }
        
        if(isDunamicUi == 'true'){
            actionCount=component.get("c.getCountsFromPCM_DynamicUI");
            action = component.get("c.getPrdsFromPCM_DynamicUI");
        }
        
      	// calculating offset cursor value for pagination 
        if(component.get("v.prevClked") == 'true'){
            cursorOffsetValue = component.get("v.PrevPageCursorValue");
        }  
            
        if(component.get("v.nxtClked") == 'true'){
            cursorOffsetValue = component.get("v.nextPageCursorValue");
        } 
        
        if(component.get("v.lastClicked") == 'true'){
            cursorOffsetValue = component.get("v.lastPageCursor");
        }
        // end offset cursor
        
        if(component.get("v.addAllFromPCM") == 'true'){
            if(position > 0){
            	cursorOffsetValue = component.get("v.nextPageCursorValue");
            }
        }
       
        //  action.setStorable();
        
        //setting actionParam for actionCount
        actionCount.setParams({
            "bundleId": component.get("v.recordId"),
            "queryObj": JSON.stringify(component.get("v.queryObject")),
            "savedRule": svdRul,
            "offsetValue": position,
            "limitValue": limitVal,
            "searchCurrency":component.get("v.searchCurrency"),
            "getAll":component.get("v.addAllFromPCM"),
            "productType": component.get("v.productType"),
            "consumer": component.get("v.consumer")
        });
        
        //setting actionParam for products list
        action.setParams({
            "bundleId": component.get("v.recordId"),
            "queryObj": JSON.stringify(component.get("v.queryObject")),
            "savedRule": svdRul,
            "offsetValue": position,
            "offsetCursor": cursorOffsetValue,
            "limitValue": limitVal,
            "searchCurrency":component.get("v.searchCurrency"),
            "getAll":component.get("v.addAllFromPCM"),
            "productType": component.get("v.productType"),
            "consumer": component.get("v.consumer")
        }); 
        
        action.setBackground();
        actionCount.setBackground();
        //alert(JSON.stringify(component.get("v.queryObject")));
        //calling actionCount setCallback
        actionCount.setCallback(this, function(response) {
            console.log('# getProducts callback %f', (performance.now() - startTime));
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('#######OffsetResult%%%%%%%%' , state);
            if (state === "SUCCESS"){     
                if(result.msg=="Success"){
                    
                    component.set("v.totalRecordCount", result.total);
                    //component.set("v.totalPriceUSD",result.totalPriceUSD);
                    //component.set("v.totalPriceGBP",result.totalPriceGBP);
                    
                    var recCountLst = result.counts;  
                    if(recCountLst && recCountLst.length > 2){                        
                        component.set("v.showProductTypes",true);
                        
                        var radioOptions = [];
                        for(var rec of recCountLst){
                            if(rec.productType != 'Total'){
                                var radioOption = {
                                    label: rec.count,
                                    value: rec.productType
                                }
                                radioOptions.push(radioOption);
                            } 
                            if(rec.productType == result.productTypeReturned){
                                component.set("v.recordCount",rec.count);
                            }
                        }
                        
                        component.set("v.radioOptions",radioOptions);
                        
                    }else{
                        var radioOptions = [];
                        component.set("v.showProductTypes",false);
                        component.set("v.radioOptions",radioOptions);
                    }
                    
                }
            }
            else if (state == "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "message": "No Internet Connection"
                });
                toastEvent.fire();
                component.set("v.IsSpinner",false);
                
                var progressEvt = $A.get("e.c:PPDProgressEvent");
                progressEvt.setParam("showStatusBar",false);
                progressEvt.setParam("progressPercent",0);
                progressEvt.setParam("progressFor",'Progress Status :');
                
                progressEvt.fire();
                component.set("v.addAllFromPCM",'false');
                
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
                component.set("v.addAllFromPCM",'false');
                
            }
        });
        //End of actionCount setCallback
        action.setCallback(this, function(response) {
            console.log('# getProducts callback %f', (performance.now() - startTime));
            var state = response.getState();
            console.log('actionState: ' , state);
            if (state === "SUCCESS"){             
                
                var result = response.getReturnValue();
                var querySaveElementVar = component.get("v.querySaveElement");
                var querySaveElementVarLst = [] ;
                console.log('ResultMessage111: ' , result.msg);
                if(result.msg=="Success"){
                    if(component.get("v.addAllFromPCM") == 'false'){
                        
                        component.set("v.ruleElementList", result.ruleElementLst);
                        //component.set("v.totalRecordCount", result.total);
                        component.set("v.queryString", result.queryString);
                        component.set("v.OriginalfullData", result.prList);
                        
                           component.set("v.nextPageCursorValue", result.nextPageCursor); 
                     
                            component.set("v.nextPageCursorValue", result.nextPageCursor);
                     
                            component.set("v.PrevPageCursorValue", result.prevPageCursor); 
                            component.set("v.lastPageCursor", result.lastPageCursor);
                        console.log('lastPageCursorValue:'+result.lastPageCursor + '  **  ' + result.nextPageCursor);
                        if(component.get("v.pstn") == 0){                            
                            querySaveElementVar.ruleElementLst = result.ruleElementLst;
                            querySaveElementVar.multiTypeRulesLst = result.multiTypeRulesLst;
                            querySaveElementVar.queryString = result.queryString ;
                            querySaveElementVar.filterObject = component.get("v.filterObject");
                            component.set("v.querySaveElement",querySaveElementVar);  
                            console.log('PositionValue1112: ' , result.queryString);
                        }
                        
                        // for Unmatched download
                        var dataLst = result.prList;
                        var availableIdLst = component.get("v.availableIds");
                        var queryObj=JSON.stringify(component.get("v.queryObject"));
                        
                          if(queryObj.includes("identifiers.doi")==true && queryObj.includes("identifiers.isbn")==true ){
                            component.set("v.hasFileUpload","false");
                          }
                       
                        if(queryObj.includes("identifiers.doi")==true ||queryObj.includes("identifiers.isbn")==true ){
                            component.set("v.hasFileUpload","true");
                            if(queryObj.includes("identifiers.doi")==true && queryObj.includes("identifiers.isbn")==true ){
                            component.set("v.hasFileUpload","false");
                          }
                            if(queryObj.includes("identifiers.doi")==true){
                                component.set("v.uniqueId","identifiers.doi");
                            }else if(queryObj.includes("identifiers.isbn")==true){
                                component.set("v.uniqueId","identifiers.isbn");
                            }
                      
                        for (var dat of dataLst) {
                            if(component.get("v.uniqueId") == 'identifiers.doi'){
                                availableIdLst.push(dat.doi);
                            }else if(component.get("v.uniqueId") == 'identifiers.isbn'){
                                availableIdLst.push(dat.isbn);
                            }
                        }
                        component.set("v.availableIds",availableIdLst);
                        var fullLst = component.get("v.uploadedIds");
                        var avList = component.get("v.availableIds");
                        
                        let difference = fullLst.filter(x => !avList.includes(x));
                        
                        console.log('difference:'+JSON.stringify(difference));
                        console.log('difference:'+difference.length);
                        
                            if(component.get("v.hasFileUpload")!="false"){
                                
                           
                        var msg ='Total'+' '+ result.total + ' ' + 'records have been found out of' + ' ' + fullLst.length + ' ' + 'uploaded records.';
                        
                        if((avList.length < fullLst.length && difference.length == 0) || ((avList.length + difference.length) < fullLst.length)){
                            msg = msg + 'Duplicate ids were ignored.' 
                        }
                        if(difference.length > 0 && avList.length > 0){
                            component.set("v.showDownloadBtn","true");
                             msg = msg + 'Please click on Download unmatched results button!' 
                        }
                        
                        if(avList.length == 0){
                            msg = 'No records available.';
                            component.set("v.showDownloadBtn","false");
                        }
                        //var infoMessage=component.find("infoMessage");
                        //infoMessage.set("v.value", msg);
                        var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Search Results!",
                     "type": 'info',
                    "duration":'10000',
                    "message": msg
                });
                toastEvent.fire();
                  
                        
                        var errorMessage= component.find("errorMessage");
                        errorMessage.set("v.value", ''); 
                        
                        let csvContent = "data:text/csv;charset=utf-8,";
                        var dffStr = difference.toString();
                        dffStr = dffStr.replace(/,/g, '\n');
                        csvContent = csvContent + dffStr +"\r\n";
                        
                        var encodedUri = encodeURI(csvContent);
                        component.set("v.unAvailableIds",encodedUri);
                                 }
                        }    
                        // End for Unmatched download 
                        
                        //for pagination
                        component.set("v.fullData", result.prList);           
                        component.set("v.recordCount",result.total);
                        component.set("v.totalPriceUSD",result.totalPriceUSD);
                        component.set("v.totalPriceGBP",result.totalPriceGBP);
                        component.set("v.returnProductType",result.productTypeReturned);
                        var recCountLst = result.counts;
                        
                        component.set("v.totalMaxPage", Math.floor((component.get("v.recordCount")+component.get("v.pageSize")-1)/component.get("v.pageSize")));
                        component.set("v.maxPage", Math.floor((component.get("v.recordCount")+component.get("v.pageSize")-1)/component.get("v.pageSize")));
                        component.set("v.countLst",result.counts);
                        
                        
                        if(component.get("v.maxPage") == 0){
                            component.set("v.maxPage", 1);
                        }
                        this.renderPage(component);
                        console.log('result==='+ JSON.stringify(result));
                        component.set("v.IsSpinner",false);
                        
                    }else if(component.get("v.addAllFromPCM") == 'true'){
                        
                            component.set("v.nextPageCursorValue", result.nextPageCursor);
                   
                        
                        component.set("v.PrevPageCursorValue", result.prevPageCursor); 
                        component.set("v.lastPageCursor", result.lastPageCursor);//end change
                        
                        var totalCount =  component.get("v.recordCount");
                        
                        var limitVal = component.get("v.queryLimit");
                        if(totalCount > (limitVal + position)){
                            position = position + limitVal ;
                            component.set("v.pstn",position);
                            console.log('123pstn.Position: ' + position);
                            
                            var progPercent = Math.floor((position / component.get("v.recordCount")) * 100)
                            var ProgressEvt = $A.get("e.c:PPDProgressEvent");
                            ProgressEvt.setParam("showStatusBar",true);
                            ProgressEvt.setParam("progressPercent",progPercent);
                            ProgressEvt.setParam("progressFor",'Progress Status :');
                            
                            ProgressEvt.fire();
                            
                            var valEvt = $A.get("e.c:PPDGenericEvent");
                            valEvt.setParam("addAllItems",true);
                            valEvt.fire();
                            
                            
                        }else{
                            component.set("v.pstn",component.get("v.paginationPstn"));
                            var progPercent = 100 ;
                            var ProgressEvt = $A.get("e.c:PPDProgressEvent");
                            ProgressEvt.setParam("showStatusBar",false);
                            ProgressEvt.setParam("progressPercent",progPercent);
                            ProgressEvt.setParam("progressFor",'Progress Status :');
                            
                            ProgressEvt.fire();
                            component.set("v.addAllFromPCM",'false');
                            component.set("v.IsSpinner",false);
                            
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Products Added!",
                                "message": "All products added successfully"
                            });
                            toastEvent.fire();
                            
                            var enableButtonEvt = $A.get("e.c:PPDGenericEvent");
                            enableButtonEvt.setParam("disableButton","ApprovalButton");
                            enableButtonEvt.setParam("buttonValue",true);
                            
                            enableButtonEvt.fire();
                            
                            var newEvent = $A.get("e.c:PPDRefreshListEvent");
                            newEvent.setParam("listToRefresh","UnsiloList");
                            newEvent.fire();
                            
                            var totalPriceEvt = $A.get("e.c:PPDTotalPriceRefreshEvent");
                            totalPriceEvt.setParam("totalPriceUSD",component.get("v.totalPriceUSD"));
                            totalPriceEvt.setParam("totalPriceGBP",component.get("v.totalPriceGBP"));
                            totalPriceEvt.setParam("isStatic",'true');
                            
                            totalPriceEvt.fire();
                            
                        }
                    }
                    
                }
                
                else if(result.msg=="Products not found"){                     
                    component.set("v.fullData", result.prList);                       
                    component.set("v.OriginalfullData", result.prList);
                    //component.set("v.totalRecordCount", result.total);
                    component.set("v.pageNumber",1);
                    component.set("v.maxPage", 1);
                    //component.set("v.showProductTypes",false);
                    component.set("v.recordCount",result.total);
                    component.set("v.returnProductType",component.get("v.productType"));
                    console.log('component.get("v.productType")=======', component.get("v.productType"));
                    
                    //component.set("v.returnProductType",'');
                    
                    component.set("v.pstn",0);
                    var msg = '';
                    msg = 'Number of records : '+ component.get("v.totalRecordCount") + '. No Match found.';
                    component.set("v.totalRowsMsg",msg);
                    
                    var progressEvt = $A.get("e.c:PPDProgressEvent");
                    progressEvt.setParam("showStatusBar",false);
                    progressEvt.setParam("progressPercent",0);
                    progressEvt.setParam("progressFor",'Progress Status :');
                    
                    progressEvt.fire();
                    
                    component.set("v.IsSpinner",false); 
                    component.set("v.addAllFromPCM",'false');
                    
                    this.renderPage(component);
                }                
                    else if(result.msg=="Server Not Responding"){                       
                        component.set("v.fullData", result.prList);                       
                        component.set("v.OriginalfullData", result.prList);
                        component.set("v.totalRecordCount", result.total);
                        component.set("v.pageNumber",1);
                        component.set("v.maxPage", 1);
                        component.set("v.pstn",0);
                        component.set("v.IsSpinner",false); 
                        component.set("v.addAllFromPCM",'false');
                        component.set("v.showProductTypes",false);
                        component.set("v.recordCount",result.total);        
                        component.set("v.returnProductType",'');
                        
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type": "warning",
                            "title": "Server Error",
                            "message": "Server not responding, please try again."
                        });
                        toastEvent.fire();
                        
                        this.renderPage(component);
                    }
          
                
                
            }else if (state == "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "message": "No Internet Connection"
                });
                toastEvent.fire();
                component.set("v.IsSpinner",false);
                
                var progressEvt = $A.get("e.c:PPDProgressEvent");
                progressEvt.setParam("showStatusBar",false);
                progressEvt.setParam("progressPercent",0);
                progressEvt.setParam("progressFor",'Progress Status :');
                
                progressEvt.fire();
                component.set("v.addAllFromPCM",'false');
                
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
                component.set("v.addAllFromPCM",'false');
                
            }
            
        });        
        var startTime = performance.now();
        if(countStr != 'NoCount'){
            $A.enqueueAction(actionCount);
        }
        $A.enqueueAction(action);
        component.set("v.IsSpinner",true);                
        //  }
        
    },
    
    
    addProduct: function (component, event) {
        var parentProductID = component.get("v.recordId");
        var row = event.getParam('row');
        var productID = row.Id;
        var action = component.get("c.addProductsToCollection");      
        
        action.setParams({
            "parentProductID": parentProductID,
            "productID" : productID,
        }); 
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                component.set("v.IsSpinner",false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Product Added!",
                    "message": result
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
        $A.enqueueAction(action);
        component.set("v.IsSpinner",true);
        
    },    
    
    // Function to add multiple products to the collection.
    addMultipleProducts: function (component, event, allPrds) {
        var parentProductID = component.get("v.recordId");
        var listProductIDs = component.get("v.selectedRows"); 
        var listOfProducts = component.get("v.selectedFullRows");  
        if(allPrds && allPrds == 'true'){
            var fullData = component.get("v.fullData");
            var i;
            var arrSelectedProdIds = [];
            
            for(i in fullData){
                arrSelectedProdIds.push(fullData[i].id);       
            }
            var listProductIDs = arrSelectedProdIds;  
        }
        /*  var action = component.get("c.addMultipleProductsToCollection");    
action.setParams({
"parentProductID": parentProductID,
"listProductIds" : listProductIDs
});     */
        var action = component.get("c.addProductsToCollectionFromPCM");    
        action.setParams({
            "parentProductID": parentProductID,
            "listOfProductsString" : JSON.stringify(listOfProducts),
            "IsInclude" : 'true'
        }); 
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                component.set("v.IsSpinner",false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Products Added!",
                    "message": result
                });
                toastEvent.fire();
                
                var enableButtonEvt = $A.get("e.c:PPDGenericEvent");
                enableButtonEvt.setParam("disableButton","ApprovalButton");
                enableButtonEvt.setParam("buttonValue",true);
                
                enableButtonEvt.fire();
                
                var newEvent = $A.get("e.c:PPDRefreshListEvent");
                newEvent.setParam("listToRefresh","UnsiloList");
                newEvent.fire();
                
                var totalPriceEvt = $A.get("e.c:PPDTotalPriceRefreshEvent");
                totalPriceEvt.setParam("totalPriceUSD",component.get("v.totalPriceUSD"));
                totalPriceEvt.setParam("totalPriceGBP",component.get("v.totalPriceGBP"));
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
        $A.enqueueAction(action);
        component.set("v.IsSpinner",true);
        
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
    
    sortByForSearch: function (component, field) {        
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.data");        
        sortAsc = sortField != field || !sortAsc;
        records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.data", records);
        //this.renderPageForSearch(component);
        this.renderPage(component);
    },    
    
    sortData: function (component, fieldName, sortDirection) {     
        this.sortBy(component,fieldName);        
    },      
    
    renderPage: function(component) {
        
        /*  if(component.get("v.isStatic")==true){            
                                                                                        var checkSearch= component.get("v.IsSearch");       
                                                                                        this.getAllSelectedIds(component);
                                                                                        var records = component.get("v.fullData"),
                                                                                            pageNumber = component.get("v.pageNumber");   
                                                                                            //if(records!=null && records!='undefined'){
                                                                                           var pageRecords = records.slice((pageNumber-1)*50, pageNumber*50);
                                                                                                //}
                                                                                        component.set("v.data", pageRecords);
                                                                                    }*/
        //dynamic pagination
        //    else if(component.get("v.isStatic")==false){   
        this.getAllSelectedIds(component);
        var pgsPerQry = component.get("v.pagesPerQuery");           
        var records = component.get("v.fullData") ;
        var pageNumber = component.get("v.pageNumber") ; 
        if(pageNumber > pgsPerQry && component.get("v.nxtClked") == 'true'){
            pageNumber = pageNumber % pgsPerQry ;                 
            if(pageNumber == 0){
                pageNumber = pgsPerQry ;
            }
        }else if(component.get("v.prevClked") == 'true'){
            if(pageNumber % pgsPerQry == 0){
                pageNumber = pgsPerQry ;
            }else{
                pageNumber = pageNumber % pgsPerQry ;
            }
        }else if(pageNumber == component.get("v.maxPage") && component.get("v.nxtClked") == 'false'){
            pageNumber = pageNumber % pgsPerQry ;
            if(pageNumber == 0){
                pageNumber = pgsPerQry;
            }
        }
        if(records!=null && records!='undefined'){
            var pageRecords = records.slice((pageNumber-1)*component.get("v.pageSize"), pageNumber*component.get("v.pageSize"));                  
        }
        component.set("v.data", pageRecords);
        // }
        
        
    },
    
    renderPageForSearch: function(component) {
        this.getAllSelectedIds(component);
        var records = component.get("v.data"),
            pageNumber = component.get("v.pageNumber"),         
            pageRecords = records.slice((pageNumber-1)*50, pageNumber*50);
        component.set("v.data", pageRecords);    
        
    },
    
    getAllSelectedIds : function (cmp,pgNum) { 
        var dat = cmp.find("productTable");
        var selectedRows = dat.getSelectedRows();
        console.log('selectedRows'+selectedRows);
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
                    //if the page number exists in the list then the corresponding page selected items are updated.
                    if(val.pageNum == pageNum){
                        val.rows = selectedRows.map(function myFunction(value) {
                            return value.id;
                        }) ;
                        val.fullRows =  selectedRows ;                                                                       
                        pageAdded = 'true';
                    }
                }); 
                //if page number not found in the existing list a new object is added to the list.
                if(pageAdded == 'false'){
                    var selected = {
                        pageNum: pageNum,
                        rows : selectedRows.map(function myFunction(value) {
                            return value.id;
                        }),
                        fullRows : selectedRows
                    };
                    allselectedRows.push(selected);
                }
                
            }else if(allselectedRows.length == 0){
                var selected = {
                    pageNum: pageNum,
                    rows : selectedRows.map(function myFunction(value) {
                        return value.id;
                    }),
                    fullRows : selectedRows
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
        var uiSelectedFullRowsArray = [];
        
        if(allselectedRows.length > 0){
            uiSelectedRowsArray = allselectedRows.map(function myFunction(value) {
                return value.rows;
            });
            uiSelectedFullRowsArray = allselectedRows.map(function myFunction(value) {
                return value.fullRows;
            });
        }
        console.log('uiSelectedRowsArray:'+JSON.stringify(uiSelectedRowsArray));
        
        var uiSelectedRows = [];
        var uiSelectedFullRows = [];
        
        uiSelectedRowsArray.forEach(function(val, index){
            uiSelectedRows = uiSelectedRows.concat(val);
        });
        
        uiSelectedFullRowsArray.forEach(function(val, index){
            uiSelectedFullRows = uiSelectedFullRows.concat(val);
        });
        
        console.log('uiSelectedRows:'+JSON.stringify(uiSelectedRows));
        console.log('uiSelectedFullRows:'+JSON.stringify(uiSelectedFullRows));
        
        
        cmp.set("v.selectedRows",uiSelectedRows) ;
        cmp.set("v.selectedFullRows",uiSelectedFullRows) ;
    },
    
    
    filterSearch: function(component, event, helper) {        
        // var data = component.get("v.fullData"),
        var data = component.get("v.OriginalfullData"),
            term = component.get("v.filter"),
            results = data, regex;        
        try {
            if (term!='' || term !=null ){ 
                
                regex = new RegExp(term, "i");
                // filter checks each row, constructs new array where function returns true                
                results = data.filter(row=>regex.test(row.ISBN) || regex.test(row.Name)|| regex.test(row.author)|| regex.test(row.pubDate)|| regex.test(row.planPubDate)|| regex.test(row.currAvailability) || regex.test(row.edition));
                
            }          
            
        } catch(e) {
            // invalid regex, use full list
            results=data;
        }
        //component.set("v.data", results);
        var originalresult = component.get("v.OriginalfullData");
        var seachedresult=component.get("v.fullData");
        if (results != null && results.length > 0 && originalresult.length==results.length )
        {
            component.set("v.fullData", component.get("v.OriginalfullData"));                 
            component.set("v.recordCount",originalresult.length); 
            component.set("v.maxPage", Math.floor((originalresult.length+49)/50)); 
            this.sortBy(component, "title");
            component.set("v.pageNumber",1);
        }
        
        if(originalresult.length!=results.length)
        {
            component.set("v.fullData", results);  
            component.set("v.recordCount",results.length);
            component.set("v.maxPage", Math.floor((results.length+49)/50));  
            this.sortBy(component, "title");
            component.set("v.pageNumber",1);
            
        }
    },
    
    getTableColumns: function(component, event, helper) {        
        var action = component.get("c.getResultColumns");    
        action.setCallback(this, function(response) {
            console.log('# getProducts callback %f', (performance.now() - startTime));
            var state = response.getState();
            if (state == "SUCCESS"){                
                var result = response.getReturnValue();
                console.log('result==='+ JSON.stringify(result));
                
                
                // columns for each type
                var BookColumns = [];
                var CollectionColumns = [];
                var ChapterColumns = [];
                var CreativeWorkColumns = [];
                var ArticleColumns = [];
                var SetColumns = [];
                var SeriesColumns = [];
                var EntryVersionColumns = [];
                
                
                var BookColumns_full = [];
                var CollectionColumns_full = [];
                var ChapterColumns_full = [];
                var CreativeWorkColumns_full = [];
                var ArticleColumns_full = [];
                var SetColumns_full = [];
                var SeriesColumns_full = [];
                var EntryVersionColumns_full = [];
                
                var BookOptns = [];
                var CollectionOptns = [];
                var ChapterOptns = [];
                var CreativeWorkOptns = [];
                var ArticleOptns = [];
                var SetOptns = [];
                var SeriesOptns = []; 
                var EntryVersionOptns = []; 
                
                var selectedBookOptns = [];
                var selectedCollectionOptns = [];
                var selectedChapterOptns = [];
                var selectedCreativeWorkOptns = [];
                var selectedArticleOptns = [];
                var selectedSetOptns = [];
                var selectedSeriesOptns = [];
                var selectedEntryVersionOptns = [];
                
                result.forEach(function(pval, pindex){
                    var clumns = pval.columns;
                    
                    if(clumns.length > 0){
                        
                        clumns.forEach(function(val, index){
                            
                            if(pval.type.toUpperCase() == 'BOOK'){
                                if(val.showVal == 'True'){
                                    BookColumns.push(val.resCol);
                                    selectedBookOptns.push(val.resCol.fieldName);
                                }
                                BookColumns_full.push(val.resCol);
                                var optn = { label:val.resCol.label , value: val.resCol.fieldName};
                                BookOptns.push(optn);
                            }
                            if(pval.type.toUpperCase() == 'COLLECTION'){
                                if(val.showVal == 'True'){
                                    CollectionColumns.push(val.resCol);
                                    selectedCollectionOptns.push(val.resCol.fieldName);
                                }
                                CollectionColumns_full.push(val.resCol);
                                var optn = { label:val.resCol.label , value: val.resCol.fieldName};
                                CollectionOptns.push(optn);
                            }
                            if(pval.type.toUpperCase() == 'CHAPTER'){
                                if(val.showVal == 'True'){
                                    ChapterColumns.push(val.resCol);
                                    selectedChapterOptns.push(val.resCol.fieldName);
                                }
                                ChapterColumns_full.push(val.resCol);
                                var optn = { label:val.resCol.label , value: val.resCol.fieldName};
                                ChapterOptns.push(optn);
                            }
                            if(pval.type.toUpperCase() == 'CREATIVEWORK'){
                                if(val.showVal == 'True'){
                                    CreativeWorkColumns.push(val.resCol);
                                    selectedCreativeWorkOptns.push(val.resCol.fieldName);
                                }
                                CreativeWorkColumns_full.push(val.resCol);
                                var optn = { label:val.resCol.label , value: val.resCol.fieldName};
                                CreativeWorkOptns.push(optn);
                            }
                            if(pval.type.toUpperCase() == 'SCHOLARLYARTICLE'){
                                if(val.showVal == 'True'){
                                    ArticleColumns.push(val.resCol);
                                    selectedArticleOptns.push(val.resCol.fieldName);
                                }
                                ArticleColumns_full.push(val.resCol);
                                var optn = { label:val.resCol.label , value: val.resCol.fieldName};
                                ArticleOptns.push(optn);
                            }
                            if(pval.type.toUpperCase() == 'SET'){
                                if(val.showVal == 'True'){
                                    SetColumns.push(val.resCol);
                                    selectedSetOptns.push(val.resCol.fieldName);
                                }
                                SetColumns_full.push(val.resCol);
                                var optn = { label:val.resCol.label , value: val.resCol.fieldName};
                                selectedSeriesOptns.push(optn);
                            }
                            if(pval.type.toUpperCase() == 'SERIES'){
                                if(val.showVal == 'True'){
                                    SeriesColumns.push(val.resCol);
                                    selectedSeriesOptns.push(val.resCol.fieldName);
                                }
                                SeriesColumns_full.push(val.resCol);
                                var optn = { label:val.resCol.label , value: val.resCol.fieldName};
                                SeriesOptns.push(optn);
                            }
                            if(pval.type.toUpperCase() == 'ENTRYVERSION'){
                                
                                if(val.showVal == 'True'){
                                    EntryVersionColumns.push(val.resCol);
                                    selectedEntryVersionOptns.push(val.resCol.fieldName);
                                }
                                EntryVersionColumns_full.push(val.resCol);
                                var optn = { label:val.resCol.label , value: val.resCol.fieldName};
                                EntryVersionOptns.push(optn);
                                console.log('productTypeResultHelper1: ' + pval.type + ' **show: ' + val.resCol.fieldName);
                            }
                        }); 
                        
                    }
                });
                component.set("v.columns_Book",BookColumns);
                component.set("v.columns_Chapters",ChapterColumns);
                component.set("v.columns_Collections",CollectionColumns);
                component.set("v.columns_CreativeWs",CreativeWorkColumns);
                component.set("v.columns_Articles",ArticleColumns);
                component.set("v.columns_Set",SetColumns);
                component.set("v.columns_Series",SeriesColumns);
                component.set("v.columns_EntryVersion",EntryVersionColumns);
                
                component.set("v.columns_Book_full",BookColumns_full);
                component.set("v.columns_Chapters_full",ChapterColumns_full);
                component.set("v.columns_Collections_full",CollectionColumns_full);
                component.set("v.columns_CreativeWs_full",CreativeWorkColumns_full);
                component.set("v.columns_Articles_full",ArticleColumns_full);
                component.set("v.columns_Set_full",SetColumns_full);
                component.set("v.columns_Series_full",SeriesColumns_full);
                 component.set("v.columns_EntryVersion_full",EntryVersionColumns_full);
                
                component.set("v.columns_Book_Optns",BookOptns);
                component.set("v.columns_Chapters_Optns",ChapterOptns);
                component.set("v.columns_Collections_Optns",CollectionOptns);
                component.set("v.columns_CreativeWs_Optns",CreativeWorkOptns);
                component.set("v.columns_Articles_Optns",ArticleOptns);
                component.set("v.columns_Set_Optns",SetOptns);
                component.set("v.columns_Series_Optns",SeriesOptns);
                component.set("v.columns_EntryVersion_Optns",EntryVersionOptns);
                
                component.set("v.selected_Book_Optns",selectedBookOptns);
                component.set("v.selected_Chapters_Optns",selectedChapterOptns);
                component.set("v.selected_Collections_Optns",selectedCollectionOptns);
                component.set("v.selected_CreativeWs_Optns",selectedCreativeWorkOptns);
                component.set("v.selected_Articles_Optns",selectedArticleOptns);
                component.set("v.selected_Set_Optns",selectedSetOptns);
                component.set("v.selected_Series_Optns",selectedSeriesOptns);
                component.set("v.selected_EntryVersion_Optns",selectedEntryVersionOptns);
                
                component.set("v.IsSpinner",false);
                
            }else if (state == "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "message": "No Internet Connection"
                });
                toastEvent.fire();
                component.set("v.IsSpinner",false);
                
                
            } else if (state == "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "There was an issue while processing, please contact SFDC system admin."
                });
                toastEvent.fire();
                component.set("v.IsSpinner",false);
            }
            
        });        
        var startTime = performance.now();
        $A.enqueueAction(action);
        component.set("v.IsSpinner",true);                
    },
    
    checkIfProductIsCloned :function(component, event, helper){
        var recordID = component.get("v.recordId");
        var action = component.get("c.checkIfProductIsCloned");    
        action.setParams({
            "bundleID": recordID
        }); 
        
        action.setCallback(this, function(response) {  
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();                
                if (result=='cloned') {               
                    component.set("v.IsClonedRecord",true);
                }
                else if (result=='original'){                
                    component.set("v.IsClonedRecord",false);
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
                    "message": "Some error has occurred,Please contact your administrator!"
                });
                toastEvent.fire();
            }   
            
        });
        var startTime = performance.now();
        $A.enqueueAction(action);   
    },
    
    downloadSearchResultFromPCM :function(component, event, helper){
        var recordID = component.get("v.recordId");
        var svdRul = 'false';
        if(component.get("v.calledFrom") == 'Titles'){
            svdRul = 'true';
        }
        var position = component.get("v.pstn") ;
        var limitVal = component.get("v.queryLimit"); 
        var action = component.get("c.downloadSearchResultFromPCM");    
        action.setParams({
            "bundleId": component.get("v.recordId"),
            "queryObj": JSON.stringify(component.get("v.queryObject")),
            "savedRule": svdRul,
            "offsetValue": position,
            "limitValue": limitVal,
            "searchCurrency":component.get("v.searchCurrency"),
            "getAll":component.get("v.addAllFromPCM"),
            "productType": component.get("v.productType"),
            "consumer": component.get("v.consumer")
        }); 
        
        action.setCallback(this, function(response) {  
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();                
                if (result.msg=='Success') {               
                    //component.set("v.IsClonedRecord",true);
                    component.set("v.IsSpinner", false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Your request has been submitted, results will be sent over email soon!"
                    });
                    toastEvent.fire();
                    
                }
                else if (result.msg=='Failure'){                
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Some error has occurred,Please contact your administrator!"
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
                    "message": "Some error has occurred,Please contact your administrator!"
                });
                toastEvent.fire();
            }   
            
        });
        $A.enqueueAction(action);   
        component.set("v.IsSpinner", true); 
    },

    downloadDailyReport :function(component, event, helper){
    	//var action = component.get("c.downloadDailyReport");
        var toastEvent = $A.get("e.force:showToast");;
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "---- Testing ---- No API ----"
                    });
                    toastEvent.fire();
        
	}
})