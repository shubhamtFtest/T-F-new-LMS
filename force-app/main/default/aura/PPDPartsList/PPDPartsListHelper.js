({
    fetchTitles: function (cmp, resetPageIndex) {
        var recordID = cmp.get("v.recordId");
        var action = cmp.get("c.getPartsFromPCM");
        var pageSize = cmp.get("v.pageSize");
        var paginationList = []; 
        var fullList = []; 
        var position = cmp.get("v.pstn") ;
        //alert(position);
        action.setParams({ 
            "bundleID":recordID,
            "position": position.toString()
        });
        action.setCallback(this, function(response) {
            console.log('# getBundleTitles callback %f', (performance.now() - startTime));
            cmp.set("v.IsSpinner", false);
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                if(result.msg == 'Success'){
                    
                    fullList = result.prList;
                    
                    cmp.set("v.fullData", fullList);           
                    cmp.set("v.recordCount",result.total);
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
    fetchProductFromPCM: function (cmp, resetPageIndex) {
         var recordID = cmp.get("v.recordId"); 
         var productType=cmp.get("v.productType");  
         var actionCount=cmp.get("c.getProductsFromPCMById");
        actionCount.setParams({ 
            "bundleID":recordID,
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
        
        //var actionCount=cmp.get("c.getProductFromPCMById");
        var action = cmp.get("c.getPartsFromPCMNewDataModel");        
        var pageSize = cmp.get("v.pageSize");
        var paginationList = []; 
        var fullList = []; 
        var position = cmp.get("v.pstn") ;
       /* actionCount.setParams({ 
            "bundleID":recordID,
            "productType":productType
        });*/
       
        action.setParams({ 
            "bundleID":recordID,
            "position": position.toString(),
            "productType":cmp.get("v.returnProductType")         
        });
        
       /* actionCount.setCallback(this, function(response) {
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
                                    cmp.set("v.productType",rec.type);
                                }
                            }
                            
                            cmp.set("v.radioOptions",radioOptions);
                            
                        }else{
                           
                            var radioOptions = [];
                            cmp.set("v.showProductTypes",false);
                            cmp.set("v.radioOptions",radioOptions);
                            
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
        });*/
        action.setCallback(this, function(response) {
            console.log('# getBundleTitles callback %f', (performance.now() - startTime));
            cmp.set("v.IsSpinner", false);
           // alert(cmp.get("v.productType"))
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                if(result.msg == 'Success'){                    
                    fullList = result.prList;
                    console.log('fullList: ' + fullList);
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
    
    renderPage: function(cmp) {        
        var pgsPerQry = cmp.get("v.pagesPerQuery");
        var records = cmp.get("v.fullData") ;
        var pageNumber = cmp.get("v.pageNumber") ; 
        console.log('renderPageHelper: ' + pageNumber + ' + ' + pgsPerQry + ' + ' + cmp.get("v.nxtClked") + ' + ' + cmp.get("v.maxPage"));
        if(pageNumber > pgsPerQry && cmp.get("v.nxtClked") == 'true'){
            pageNumber = pageNumber % pgsPerQry ; 
            cmp.set("v.nxtClked", false);
            if(pageNumber == 0){
                pageNumber = pgsPerQry ;
            }
        }else if(cmp.get("v.prevClked") == 'true'){
            cmp.set("v.prevClked", false);
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
    
    // added by Geetika for PCH- 3712
    fetchSearchResult: function (cmp) {
        var cursorOffsetValue="";
        
        var recordID = cmp.get("v.recordId");
        var pageSize = cmp.get("v.pageSize");
        var queryTerm = cmp.get("v.searchQueryText");
        var pageSize = cmp.get("v.pageSize");
        var paginationList = []; 
        var fullList = []; 
        var calledEvt = cmp.get("v.calledEvent");
        calledEvt = calledEvt + cmp.get('v.additionType');
        console.log('searchQueryTerm: ' + queryTerm + ' + ' + cmp.get("v.nxtClked"));
        if(cmp.get("v.prevClked") == 'true'){
            cursorOffsetValue = cmp.get("v.PrevPageCursorValue");
        }  
            
       if(cmp.get("v.nxtClked") == 'true'){
            cursorOffsetValue = cmp.get("v.nextPageCursorValue");
           	console.log('searchQueryTerm: True' + cursorOffsetValue);
        } 
        
        if(cmp.get("v.lastClicked") == 'true'){
            cursorOffsetValue = cmp.get("v.lastPageCursor");
        }
        
        var action = cmp.get('c.searchBundleLineItems');
        action.setParams({
            "queryTerm": queryTerm,
            "bundleID": recordID,
            "offsetCursor": cursorOffsetValue
        });
        
        action.setCallback(this, function(response) {
            
            if(cmp.get("v.calledEvent") != 'Validation'){
                cmp.set("v.showingValidation", "false");
            }
            console.log('# getUnsiloBundleRecordsBySearchSOSQL callback %f', (performance.now() - startTime));
            var state = response.getState();
            console.log('SearchStatus: ' + JSON.stringify(response));
            if (state == "SUCCESS"){
                var result = response.getReturnValue();
                console.log('getResult: ' + JSON.stringify(result.msg));
                
                if(result.msg =='Success'){
                    fullList = result.prList;
                    cmp.set("v.fullData", fullList);           
                    //cmp.set("v.totalSize", fullList.length);              
                    cmp.set("v.recordCount",result.total);
                    cmp.set("v.maxPage", Math.floor((result.total+cmp.get("v.pageSize")-1)/cmp.get("v.pageSize")));
                    console.log('MaxPageHelper: ' + cmp.get("v.maxPage"));
                    if(cmp.get("v.maxPage") == 0){
                        cmp.set("v.maxPage", 1);
                    }
                
                    cmp.set("v.PrevPageCursorValue", result.prevPageCursor);
                    cmp.set("v.nextPageCursorValue", result.nextPageCursor);
                    cmp.set("v.lastPageCursor", result.lastPageCursor);
                    console.log('NextPageCursor: ' + result.nextPageCursor + ' + ' + cmp.get("v.nextPageCursorValue"))
                    
                    //cmp.set("v.pageNumber",1);        
                    this.renderPage(cmp);
                    cmp.set("v.IsSpinner", false);
                
                } else {
                    cmp.set("v.IsSpinner", false);
                    cmp.set("v.fullData", fullList); 
                    cmp.set("v.recordCount",0);
                    cmp.set("v.maxPage", 1);
                    this.renderPage(cmp);
                    
                
                }
                /*fullList = result.prList;
                console.log('getResult: ' + JSON.stringify(result.msg));
                cmp.set("v.fullData", fullList);           
                //cmp.set("v.totalSize", fullList.length);              
                cmp.set("v.recordCount",result.total);
                cmp.set("v.maxPage", Math.floor((result.total+cmp.get("v.pageSize")-1)/cmp.get("v.pageSize")));
                console.log('MaxPageHelper: ' + cmp.get("v.maxPage"));
                if(cmp.get("v.maxPage") == 0){
                    cmp.set("v.maxPage", 1);
                }
                
                cmp.set("v.PrevPageCursorValue", result.prevPageCursor);
                cmp.set("v.nextPageCursorValue", result.nextPageCursor);
                cmp.set("v.lastPageCursor", result.lastPageCursor);
                console.log('NextPageCursor: ' + result.nextPageCursor + ' + ' + cmp.get("v.nextPageCursorValue"))
                
                //cmp.set("v.pageNumber",1);        
                this.renderPage(cmp);
                cmp.set("v.IsSpinner", false);*/
                
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
    },  //end for PCH-3712
    
    
})