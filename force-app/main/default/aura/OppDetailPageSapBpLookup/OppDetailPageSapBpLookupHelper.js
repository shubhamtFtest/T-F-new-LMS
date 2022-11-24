({
    getRecordsFromBPTable : function(component, event) {
        debugger;
        var action = component.get("c.accountSearch");
        action.setParams({
            "userInput": component.get("v.accountNameUserInput"),
            "accountfilterId": component.get("v.recordId"),
            "pickedValue": component.get("v.pickedValue")
        });
        var opts = [];
        action.setCallback(this, function(response) {
            component.set('v.issearching', false);
            component.set('v.mySpinner',false);
            if (response.getState() == "SUCCESS") {
                var returnValue = response.getReturnValue();
                if(!$A.util.isEmpty(returnValue) && !$A.util.isUndefinedOrNull(returnValue))
                {
                    var accObj = new Object();
                    accObj.Name = returnValue.accountName;
                    accObj.Id = returnValue.AccountId;
                    component.set("v.selectedRecord" , accObj);
                    
                    component.set('v.wrapperData',returnValue);
                    component.set('v.accountNameUserInput',returnValue.accountName);
                    component.set('v.originalSapList', returnValue.sapBPList);
                    
                    if(returnValue.sapBPList.length>0){
                        component.set('v.noRecordsFoundMsg',false);
                        component.set('v.isSapBpListPresent',true);
                    }else {
                        component.set('v.noRecordsFoundMsg',true);
                        component.set('v.isSapBpListPresent',false);
                    }   
                }
            }
        });
        $A.enqueueAction(action);
    },
    saveBP : function(component,event,bpValue){
        var rowIndexValue = parseInt(event.currentTarget.dataset.rowIndex,10);
        var listofSAPbp = component.get('v.wrapperData.sapBPList');
        var selectedRecordId = listofSAPbp[rowIndexValue].Id;
        
        var action = component.get("c.saveBPtoOpportunity");
        action.setParams({
            "recordID": component.get("v.recordId"),
            "BPId": selectedRecordId,
            "bpDetail": bpValue
        });
        action.setCallback(this, function(response){
            component.set('v.mySpinner',false);
            if (response.getState() == "SUCCESS") {
                var returnValue = response.getReturnValue();
                
                $A.get('e.force:refreshView').fire();
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": component.get("v.recordId"),
                    "slideDevName": "detail"
                });
                navEvt.fire();
            }
        });
        $A.enqueueAction(action);
    },
    getRecordsofBP : function(component,event){
        var action = component.get("c.getBPDetails");
        action.setParams({
            "recordID": component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            component.set('v.mySpinner',false);
            if (response.getState() == "SUCCESS") {
                var returnValue = response.getReturnValue();
                
                component.set('v.billToBP',returnValue.billToBP);
                component.set('v.shipToBP',returnValue.shipToBP);
                
                if(!$A.util.isEmpty(returnValue.billToBpName) && !$A.util.isUndefinedOrNull(returnValue.billToBpName)){
                    component.set('v.billToBpName',returnValue.billToBpName);
                    component.set('v.billToBpUrl', window.location.origin + '/' + returnValue.billToBpId);
                }
                
                if(!$A.util.isEmpty(returnValue.shipToBpName) && !$A.util.isUndefinedOrNull(returnValue.shipToBpName)){
                    component.set('v.shipToBpName',returnValue.shipToBpName);
                    component.set('v.shipToBpUrl', window.location.origin + '/' + returnValue.shipToBpId);
                }
                
            }
        });
        $A.enqueueAction(action);
        
    },
    copyBillTo : function(component, event){
        var action = component.get("c.copyBillToSap");
        action.setParams({
            "recordID": component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState()=="SUCCESS"){
                var returnValue = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                
                if(returnValue==='No Bill To BP Found'){
                    toastEvent.setParams({
                        "title": "Alert!",
                        "message": returnValue
                    });
                }else if(returnValue==='Bill To BP has been Copied to Ship To BP'){
                    toastEvent.setParams({
                        "title": "Success!",
                        "type":'success',
                        "message": returnValue
                    });
                }
                
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": component.get("v.recordId"),
                    "slideDevName": "detail"
                });
                navEvt.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    sapBpResponseHelper : function(component,event,helper){
        debugger;
        var bpResponse = event.getParam("sapBpCreationResponse");
        var bpValue = component.get('v.bpDetail');
        var bpResponseObj = JSON.parse(bpResponse);
        console.log('bpResponseObj '+JSON.stringify(bpResponseObj));
        var selectedRecordId = bpResponseObj.objectData.salesforceRecordId;
         
        var action = component.get("c.saveBPtoOpportunity");
        action.setParams({
            "recordID": component.get("v.recordId"),
            "BPId": selectedRecordId,
            "bpDetail": bpValue
        });
        action.setCallback(this, function(response){
            component.set('v.mySpinner',false);
            if (response.getState() == "SUCCESS") {
                var returnValue = response.getReturnValue();
                
                $A.get('e.force:refreshView').fire();
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": component.get("v.recordId"),
                    "slideDevName": "detail"
                });
                navEvt.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
})