({
    handleUploadFinished: function (cmp, event) {
        var uploadedFiles = event.getParam("files");
        var docId ;
        if(uploadedFiles && uploadedFiles.length > 0){
            docId = uploadedFiles[0].documentId ;
            
            var action = cmp.get("c.addContentsViaFileUpload");
            action.setParams({
                "productID": cmp.get("v.recordId"),
                "documentId": docId
            });
            
            action.setCallback(this, function(response) {
                var result = response.getReturnValue(); 
                if(result != null && result != ''){ 
                    cmp.set("v.IsSpinner", false);

                    var mvgRichText = cmp.find("msgRichText");
                    
                    if(result.errMsg == 'Success' && result.successRecCnt == result.totalRecs){
                        mvgRichText.set("v.value", '<span style="color: #339966;"><b>All the rows inserted successfully !</b></span>');
                    }
                    
                    if(result.errMsg != 'Success'){
                        var  msg = '<span style="color: #339966;"><b>Upload details :</b></span><br><br> <b>';
                        msg = msg + result.errMsg;
                        mvgRichText.set("v.value", msg);
                    }
                    if(result.errMsg == 'Success'){
                        var  msg = '<span style="color: #339966;"><b>Upload details :</b></span><br><br> <b>'+ result.successRecCnt + '</b> rows got inserted out of <b>'+ result.totalRecs + '</b> uploaded. <br><br>';
                        
                        if(result.containsDupes == 'true'){
                            msg = msg + '<b>Duplicate DOIs and DOIs already part of collection were not considered for processing.</b> <br><br>'
                        }
                        if(result.formatErrMsg != ''){
                            msg = msg + '<b><span style="color: #b30000;">Following rows were not considered for processing either due to missing mandatory values or due to incorrect format :</b></span> <br><br>'+ result.formatErrMsg ;
                        }
                        
                        if(result.insertErrMsg != ''){
                            msg = msg + '<br><br><span style="color: #b30000;"><b>Following rows were not inserted due to data discrepancy :</b></span> <br><br>'+ result.insertErrMsg ;
                        }
                        
                        mvgRichText.set("v.value", msg);
                    }
                    
                    if(result.errMsg == 'Success' && result.successRecCnt > 0){
                        
                        var enableButtonEvt = $A.get("e.c:PPDGenericEvent");
                        enableButtonEvt.setParam("disableButton","ApprovalButton");
                        enableButtonEvt.setParam("buttonValue",true);
                        
                        enableButtonEvt.fire();
                    }
                    
                    var newEvent = $A.get("e.c:PPDRefreshListEvent");
                    newEvent.setParam("listToRefresh","UnsiloList");
                    newEvent.fire();                    
                }
            });
            $A.enqueueAction(action);
            cmp.set("v.IsSpinner", true);
            
        }
    }
})