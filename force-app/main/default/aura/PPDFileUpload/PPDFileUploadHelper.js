({
    getItemsFromPCMandInsert : function (component, event) {
        let map = new Map();
        map.set('1', 'str1');   // a string key
        map.set(1, 'num1');     // a numeric key
        map.set(true, 'bool1'); // a boolean key
        if(component.get("v.CollectionType")=='Rule based'){
            component.set("v.uniqueId","identifiers.isbn");
        }
        var action = component.get("c.fileUploadAndGetFromPCM");       
        console.log('fileContent--------'+JSON.stringify(component.get("v.fileContent")));
      
        action.setParams({
            "parentProductID": component.get("v.recordId"),
            "fileInpt": JSON.stringify(component.get("v.fileContent")),
            "IdType": component.get("v.uniqueId"),
            "offsetValue": component.get("v.pstn"),
            "limitValue": component.get("v.queryLimit")
        }); 
        
        action.setCallback(this, function(response) {
            console.log('# getProducts callback %f', (performance.now() - startTime));
            var state = response.getState();
            if (state === "SUCCESS"){                
                var result = response.getReturnValue();
                
                if(result.msg=="Success"){
                    
                    var totalCount = result.total ;
                    var position = result.offset ;
                    var dataLst = result.prList ;
                    console.log('dataLst'+JSON.stringify(dataLst));
                    var availableIdLst = component.get("v.availableIds");
                    
                    for (var dat of dataLst) {
                        if(component.get("v.uniqueId") == 'identifiers.doi' || component.get("v.uniqueId") =='doi_chapter' || component.get("v.uniqueId") =='doi_article'|| component.get("v.uniqueId") =='doi_creativework' || component.get("v.uniqueId") == 'doi_entryversion'){
                            availableIdLst.push(dat.doi);
                        }else if(component.get("v.uniqueId") == 'identifiers.isbn'){
                            availableIdLst.push(dat.isbn);
                        }
                    }
                    
                    component.set("v.availableIds",availableIdLst);
                    var limitVal = component.get("v.queryLimit");
                    if(totalCount > (limitVal + position)){
                        position = position + limitVal ;
                        component.set("v.pstn",position);
                        
                        
                        var progPercent = Math.floor((position / result.total) * 100)
                        var ProgressEvt = $A.get("e.c:PPDProgressEvent");
                        ProgressEvt.setParam("showStatusBar",true);
                        ProgressEvt.setParam("progressPercent",progPercent);
                        ProgressEvt.setParam("progressFor",'Progress Status :');
                        
                        ProgressEvt.fire();
                        
                        var valEvt = $A.get("e.c:PPDGenericEvent");
                        valEvt.setParam("fileUpload",true);
                        valEvt.fire();
                        
                        
                    }else{
                        component.set("v.pstn",0);
                        var progPercent = 100 ;
                        var ProgressEvt = $A.get("e.c:PPDProgressEvent");
                        ProgressEvt.setParam("showStatusBar",false);
                        ProgressEvt.setParam("progressPercent",progPercent);
                        ProgressEvt.setParam("progressFor",'Progress Status :');
                        
                        ProgressEvt.fire();
                        component.set("v.IsSpinner",false);
                        
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "message": "Process completed"
                        });
                        toastEvent.fire();
                        
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
                
                else if(result.msg=="Products not found"){
                    
                    var availableIdLst = [] ;
                    component.set("v.availableIds",availableIdLst);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": "Products not found!"
                    });
                    toastEvent.fire();
                    component.set("v.IsSpinner",false);
                    
                }
                
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
            console.log('available list'+JSON.stringify(component.get("v.availableIds")));
            var fullLst = component.get("v.uploadedIds");
            var avList = component.get("v.availableIds");
            let difference = fullLst.filter(x => !avList.includes(x));
            console.log('difference:'+JSON.stringify(difference));
            console.log('difference:'+difference.length);

            
            var msg ='Total'+' '+ avList.length + ' ' + 'records has been added successfully out of' + ' ' + fullLst.length + ' ' + 'records.';
            
            if((avList.length < fullLst.length && difference.length == 0) || ((avList.length + difference.length) < fullLst.length)){
                msg = msg + 'Duplicate ids were ignored.' 
            }
            if(difference.length > 0 && avList.length > 0){
                component.set("v.showDownloadBtn","true");
                msg = msg + '<br><br> Download unavailable Ids';
            }

            if(avList.length == 0){
                msg = 'No records available.';
            }
            var infoMessage=component.find("infoMessage");
            infoMessage.set("v.value", msg);
            
            var errorMessage= component.find("errorMessage");
            errorMessage.set("v.value", ''); 
            
            let csvContent = "data:text/csv;charset=utf-8,";
            var dffStr = difference.toString();
            dffStr = dffStr.replace(/,/g, '\n');
            csvContent = csvContent + dffStr +"\r\n";
            
            var encodedUri = encodeURI(csvContent);
            component.set("v.unAvailableIds",encodedUri);
        }); 
        
        
        var startTime = performance.now();
        $A.enqueueAction(action);
        
    }
})