({
    
    init : function(component, event, helper) {
        var recordID = component.get("v.recordId"); 
        
        var action = component.get("c.getApprovalProcessStatus"); 
        action.setParams({
            "bundleID":recordID,
        });
        action.setCallback(this, function(response) {  
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue(); 
                console.log('ResultTabWizard123: ' + JSON.stringify(result));
                component.set('v.CreatedBy',result.createdByName + ' ' + 'On ' + result.createdDate);
                component.set('v.LastModifiedBy',result.lastModifiedByName + ' ' + 'On ' + result.lastModifiedDate);
                component.set('v.RecordTypeName',result.recordTypeName);
                component.set('v.CreatedById',result.salesforceURL + result.createdById);
                component.set('v.LastModifiedById',result.salesforceURL + result.lastModifiedById);               
                component.set('v.typeOfCollection',result.productType);  
                component.set('v.IsRecordActive',result.isProductActive) ;
                component.set('v.CreatedByDate',result.createdDate) ;
                component.set('v.ModifiedByDate',result.lastModifiedDate) ;
                component.set('v.isCollectionFree', result.isCollectionFree);
                
                if(result.isUserAdmin=='true'){
                    component.set('v.IsUserAdmin','true')
                }
                else if(result.isUserAdmin=='false'){
                    component.set('v.IsUserAdmin','false')
                }
                
                if((result.dynamicRule!=undefined || result.dynamicRule!=null)&& (result.productType=='Rule based')){
                    component.set('v.isRulePresent','true');                     
                }
                
                if(result.productState =='ackApiFailed'){
                    component.set("v.isAckFailed",'true');                    
                    var msgApiFailedText = component.find("msgApiFailedText");
                    msgApiFailedText.set("v.value", '<span style="color: #bf4040;"><b>There was an issue in processing of this product due to some technical issues, please contact SFDC Admin.</b></span>');
                }
                
                if(result.productState =='true' && result.AllowUserToUpdate =='true'){
                    component.set("v.IsRecordLocked",'true');
                    // component.set("v.IsButtonDisabled",'false');
                    component.set("v.IsEditProductButtonDisabled",'true'); 
                    component.set("v.disableDelete",'false');
                }
                else if(result.productState =='true' && result.AllowUserToUpdate =='false'){                
                    component.set("v.isRecordAccessible",'false');
                    component.set("v.IsRecordLocked",'false');
                    // component.set("v.IsButtonDisabled",'false');
                    component.set("v.IsEditProductButtonDisabled",'false');
                    var infoMsgRichText = component.find("infoMsgRichText"); 
                    infoMsgRichText.set("v.value", '<span style="color: #bf4040;"><b>This record is locked for editing, only the owner or SFDC admin is allowed to edit this record!</b></span>');
                }
                    else if(result.productState =='false') {               
                        component.set("v.IsRecordLocked",'false');
                        component.set("v.IsButtonDisabled",'true');
                        component.set("v.IsEditProductButtonDisabled",'false');                    
                    }else if(result.productState =='retrySubmit'){
                        component.set("v.IsRecordLocked",'false');
                        component.set("v.IsButtonDisabled",'true');
                        component.set("v.IsEditProductButtonDisabled",'false');
                        component.set("v.retrySubmit",'true');
                        var mvgRichText = component.find("msgRichText");
                        mvgRichText.set("v.value", '<span style="color: #bf4040;"><b>There was an issue submitting the product for Approval, please submit again.</b></span>');
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
            if(component.get('v.typeOfCollection')=='Rule based'){
                component.set('v.SelectCriteria','Create Rule');
                component.set('v.FileUpload','Inclusion/Exclusion');
            }else{
                component.set('v.SelectCriteria','Search');
                component.set('v.FileUpload','Identifiers File Upload');
            }  
           // alert('MainTab:' + component.get("v.mainTabId"));
           // alert('isFromFinishButton:' + component.get("v.isFromFinishButton"));
            /*if(component.get("v.mainTabId") == 'Titles' && component.get("v.IsRecordLocked") == 'true'&& component.get("v.isFromFinishButton") == 'True'){
               // alert('inside if');
                var prev = component.get("c.handlePreviewFromFinish");   
                $A.enqueueAction(prev); 
            }*/
            
            
         });
        $A.enqueueAction(action);  
        
       
        
    },
    
    submitForApproval: function (component, event, helper) { 
        var parentProductID = component.get("v.recordId");        
        var action = component.get("c.updateApprovalProcessStatus");    
        action.setParams({
            "bundleID": parentProductID            
        }); 
        
        action.setCallback(this, function(response) {  
            var state = response.getState();
            if (state === "SUCCESS"){
                component.set("v.retrySubmit", 'false');
                component.set("v.showValidate",'false');
                var result = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Approval Status!",
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
                    "message": "Some error has occurred,Please contact your administrator!"
                });
                toastEvent.fire();
            } 
            
        });
        var startTime = performance.now();
        $A.enqueueAction(action);       
        $A.get('e.force:refreshView').fire();
        var a = component.get('c.init');
        $A.enqueueAction(a); 
         },
    
    checkforUnsiloContent: function (component, event, helper) { 
        var parentProductID = component.get("v.recordId");
        var action = component.get("c.getUnsiloContents");    
        action.setParams({
            "bundleID": parentProductID            
        }); 
        
        action.setCallback(this, function(response) {  
            var state = response.getState();
            if (state === "SUCCESS"){
                
                var result = response.getReturnValue();
                var status=result;   
                component.set("v.hasUnsiloContent",status)
                //checking condition
                var check=component.get("v.hasUnsiloContent");   
                //alert(check);
                if ((check=='nocontent')&& (component.get('v.typeOfCollection') == 'Manual Curation')){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Approval Request Denied!",
                        "message": "No valid content to submit for approval!"
                    });
                    toastEvent.fire(); 
                    return;
                }else if(check=='nohubid'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Approval Request Denied!. Hub Id is blank.",
                        "message": "There was an issue while processing, please contact SFDC system admin.",
                        "type": 'error'
                    });
                    toastEvent.fire(); 
                    return;
                }
                    else if(check=='noPriceBookEntry'){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Approval Request Denied!",
                            "message": "Please make the base price entry for this collection!",
                            "type": 'warning'
                        });
                        toastEvent.fire(); 
                        return;
                    }
                
                        else if(check=='noValidityDatesExists'){
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Approval Request Denied!",
                                "message": "Please enter validity dates for this collection!",
                                "type": 'warning'
                            });
                            toastEvent.fire(); 
                            return;
                        }
                
                            else if(check=='noValidBusinessIdExists'){
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "Approval Request Denied!",
                                    "message": "Please enter valid Business Id!",
                                    "type": 'warning'
                                });
                                toastEvent.fire(); 
                                return;
                            }
                                else if(check=='noValidCollectionNameExists'){
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                    "title": "Approval Request Denied!",
                                    "message": "Please enter valid Collection Name!",
                                    "type": 'warning'
                                });
                                toastEvent.fire(); 
                                return;
                                }
                                else if(check=='norule'){
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        "title": "No Rule Exists!",
                                        "message": "Please save the rule for Rule based collection!",
                                        "type": 'warning'
                                    });
                                    toastEvent.fire(); 
                                    return;
                                }
                                    else{
                                        
                                        var a = component.get('c.submitForApproval');
                                        $A.enqueueAction(a);
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
    //Edit Product
    checkForEditProduct: function (component, event, helper) { 
        helper.getSubmitForApprovalStatusValue(component, event, helper);
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
                
                if(component.get("v.IsRecordLocked")=='true' && component.get("v.IsClonedRecord")==false) {                
                    helper.openRecordInEditMode(component, event, helper);
                }
                
                else if(component.get("v.IsRecordLocked")=='true' && component.get("v.IsClonedRecord")==true){               
                    component.set("v.ShowClonedModal",true);
                    //helper.getCloneDataforEdit(component, event, helper);
                }
                
                    else if(component.get("v.IsRecordLocked")=='false' && component.get("v.approvalStatus")=='Pending') {                   
                        //component.set("v.ShowModal",true);
                        //helper.checkIfNewProductVersionExist(component, event, helper);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Record Edit Status!",
                            "message": 'Record can not be edited as it is under approval process!'
                        });
                        toastEvent.fire();   
                        return;
                    }
                
                        else if(component.get("v.IsRecordLocked")=='false' && component.get("v.approvalStatus")=='Approved') {                       
                            //component.set("v.ShowModal",true);
                            helper.checkIfNewProductVersionExist(component, event, helper);                
                        }
                            else if((component.get("v.IsRecordLocked")=='false')&& (component.get("v.isRecordAccessible")=='false')){
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "Approval Request Denied!",
                                    "message": "This record is locked for editing, only the owner or SFDC admin is allowed to edit this record!",
                                    "type": 'warning'
                                });
                                toastEvent.fire(); 
                                return;
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
    
    
    HideMe: function(component, event, helper) {
        component.set("v.ShowModal", false);
    },
    CloneHideMe: function(component, event, helper) {
        component.set("v.ShowClonedModal", false);
    },
    HideBusinessIdModal: function(component, event, helper) {
        component.set("v.ShowBusinessIdModal", false);
        component.set("v.IsmsgFromBusinessModal", 'false');
        
    },
    
    HideCollectionModal: function(component, event, helper) {
        component.set("v.ShowCollectionNameModal", false);
        component.set("v.IsmsgFromCollectionModal", 'false');
        
    },
    //updating the cloned Product data
    UpdateClonedData: function(component, event, helper) {
        event.preventDefault(); //Prevent default submit
        var eventFields = event.getParam("fields");        
        //if (eventFields["Description"]=='' || eventFields["Description"]==null|| eventFields["Sales_Channels__c"]==null || eventFields["Sales_Channels__c"]=='' || eventFields["Applicable_Channels__c"]==null || eventFields["Applicable_Channels__c"]==''|| eventFields["Applicable_Customer_Types__c"]==null || eventFields["Applicable_Customer_Types__c"]==''|| eventFields["Applicable_License_Types__c"]==null || eventFields["Applicable_License_Types__c"]==''){        
        if ( eventFields["Abstract__c"]=='' || eventFields["Abstract__c"]==null){    
            //helper.checkIfNewProductVersionExist(component, event, helper);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Record Edit Status!",
                "message": 'Please enter all the mandatory fields!'
            });
            toastEvent.fire();   
            return;
            
        }
        else{        
            component.find('ProductEditForm').submit(eventFields);
        }
        
    },
    
    //updating the cloned Product data
    handleOnSuccess: function(component, event, helper) {      
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Record update Status!",
            "message": "Record has been updated Succesfully!"
        });
        toastEvent.fire();    
        helper.CloneHideMe(component, event, helper);
        
        var evt = $A.get("e.c:PPDRecordEditRefreshEvent");
        evt.fire();
        
        $A.get('e.force:refreshView').fire();
        var a = component.get('c.init');
        $A.enqueueAction(a);
    },
    
    enableSubmitForApproval: function(component, event, helper) {       
        if (event.getParam("disableButton") !== undefined && event.getParam("disableButton") == "ApprovalButton") {
            if(event.getParam("buttonValue") !== undefined && event.getParam("buttonValue") == false){
                component.set("v.IsButtonDisabled",'false');
            }else if(event.getParam("buttonValue") !== undefined && event.getParam("buttonValue") == true){
                component.set("v.IsButtonDisabled",'true');
            }
        }
        if (event.getParam("disableButton") !== undefined && event.getParam("disableButton") == "validateButton") {
            if(event.getParam("buttonValue") !== undefined && event.getParam("buttonValue") == true){
                component.set("v.showValidate",'false');
            }
        }        
    },
    
    validatePkg: function(component, event, helper) {
        var cldFor ;
        if(component.get('v.typeOfCollection') == 'Manual Curation'){
            cldFor = '';
        }else{
            cldFor = 'Exclusion'; 
        }
        var evt = $A.get("e.c:PPDValidateEvent");
        evt.setParam("calledFor",cldFor);
        evt.fire();
    },
    
    progressBarUpdate: function(component, event, helper) {        
        if (event.getParam("showStatusBar") !== undefined && event.getParam("showStatusBar") == true) {
            if (event.getParam("progressFor") !== undefined) {
                component.set("v.progressBarMessage", event.getParam("progressFor") );
            }            
            component.set("v.showProgressBar", true );
            if (event.getParam("progressPercent") !== undefined) {
                component.set("v.progress", event.getParam("progressPercent") );
            }
        }else{
            component.set("v.showProgressBar", false );
        }
    },
    
    showRequiredFields: function(component, event, helper){
        $A.util.removeClass(component.find("Sales_Channels__c"), "none");
        $A.util.removeClass(component.find("Applicable_Channels__c"), "none");
        $A.util.removeClass(component.find("Description"), "none");
        $A.util.removeClass(component.find("Applicable_Customer_Types__c"), "none");
        $A.util.removeClass(component.find("Applicable_License_Types__c"), "none");
    },
    
    handleTabSelect: function (cmp, event, helper) {
        
        if(event.getParam('id') == 'Titles' && cmp.get("v.tabId") == 'firstTime'){
            cmp.set("v.tabId",'UNSILORecords');
        }else if(event.getParam('id') == 'TitleSelection' && cmp.get("v.titleSeltabId") == 'firstTime' && cmp.get('v.typeOfCollection')=='Manual Curation'){
            cmp.set("v.titleSeltabId",'ContentSelection');
            //Adding condition to rename tab
            if( cmp.get('v.typeOfCollection')=='Manual Curation'){
                cmp.set('v.SelectCriteria','Search');
                cmp.set('v.FileUpload','Identifiers File Upload');
            }
            else if(cmp.get('v.typeOfCollection')=='Rule based'){
                cmp.set('v.SelectCriteria','Create Rule');
                cmp.set('v.FileUpload','Inclusion/Exclusion');
            }   
            //Adding condition to rename tab
        }
            else if(event.getParam('id') == 'TitleSelection' && cmp.get("v.titleSeltabId") == 'firstTime' && cmp.get('v.typeOfCollection')=='Rule based'){
                cmp.set("v.titleSeltabId",'productselection');
                //Adding condition to rename tab
                if( cmp.get('v.typeOfCollection')=='Manual Curation'){
                    cmp.set('v.SelectCriteria','Search');
                    cmp.set('v.FileUpload','Identifiers File Upload');
                }
                else if(cmp.get('v.typeOfCollection')=='Rule based'){
                    cmp.set('v.SelectCriteria','Create Rule');
                    cmp.set('v.FileUpload','Inclusion/Exclusion');
                }   
                //Adding condition to rename tab
            }
        
        if(event.getParam('id') == 'Titles' && cmp.get("v.IsRecordLocked") == 'true'){            
            var parentProductID = cmp.get("v.recordId");
            var action = cmp.get("c.getBundleItmsCount");    
            action.setParams({
                "bundleID": parentProductID            
            });             
            action.setCallback(this, function(response) {  
                var state = response.getState();
                if (state === "SUCCESS"){
                    
                    var result = response.getReturnValue();
                    if(result > 0){
                        cmp.set("v.showValidate",'true');
                    }else{
                        cmp.set("v.showValidate",'false');
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
        }else{
            cmp.set("v.showValidate",'false');
        }
    },
    
    downloadParts:  function(component, event, helper){
        component.set("v.disableDownload", true);
        var url = '';
        var recordID = component.get("v.recordId");       
        var action = component.get("c.getPartsDownloadURL"); 
        action.setParams({
            "bundleId":recordID
        });
        action.setCallback(this, function(response) {  
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                
                if(result != null && result != 'Error' && result != 'File not found'){
                    url = result;
                    window.location.href = url;                    
                }else if(result != null && result == 'File not found'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Could not downlaod",
                        "message": result,
                        "type": 'warning'
                    });
                    toastEvent.fire();
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Could not downlaod",
                        "message": "There was an issue downloading the file, please try later or contact SFDC system admin.",
                        "type": 'warning'
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
            component.set("v.disableDownload", false);
            
        });
        $A.enqueueAction(action);       
        
    },
    
    onSelectChange: function (cmp, evt, helper) {       
        var stringUnsilo=cmp.find('selectUnsilo').get('v.value');
        cmp.set("v.SelectedUnsilo", stringUnsilo);
        
    },
    
    updateBusinessIdStatus: function(component, event, helper) {   
        if (event.getParam("IsBusinessIdExist") !== undefined && event.getParam("IsBusinessIdExist") == 'true') {
            component.set("v.IsBusinessIdValid",'Invalid');
            component.set("v.IsBusinessIdValidatedFromPCM",false);
            helper.saveValidatedBusinessId(component, event, helper);
            
        }
        else if(event.getParam("IsBusinessIdExist") !== undefined && event.getParam("IsBusinessIdExist") == 'false'){
            component.set("v.IsBusinessIdValid",'valid');
            component.set("v.IsBusinessIdValidatedFromPCM",true);
            helper.saveValidatedBusinessId(component, event, helper);
        }
        
        console.log('collectionNameStatus: ' + event.getParam("IsCollectionNameExist") + '  **  ' + event.getParam("IsCollectionNameExist"));
        if (event.getParam("IsCollectionNameExist") !== undefined && event.getParam("IsCollectionNameExist") == 'true') {
            component.set("v.IsCollectionNameValid",'Invalid');
            component.set("v.IsCollNameValidatedFromPCM",false);
            helper.saveValidatedTitle(component, event, helper);
            
        }
        else if(event.getParam("IsCollectionNameExist") !== undefined && event.getParam("IsCollectionNameExist") == 'false'){
            component.set("v.IsCollectionNameValid",'valid');
            component.set("v.IsCollNameValidatedFromPCM",true);
            helper.saveValidatedTitle(component, event, helper);
        }
    },
    
    updateCollectionStatus: function(component, event, helper) { 
        console.log('collectionNameStatus: ' + event.getParam("IsCollectionNameExist") + '  **  ' + event.getParam("IsCollectionNameExist"));
        if (event.getParam("IsCollectionNameExist") !== undefined && event.getParam("IsCollectionNameExist") == 'true') {
            component.set("v.IsCollectionNameValid",'Invalid');
            component.set("v.IsCollNameValidatedFromPCM",false);
            helper.saveValidatedTitle(component, event, helper);
            
        }
        else if(event.getParam("IsCollectionNameExist") !== undefined && event.getParam("IsCollectionNameExist") == 'false'){
            component.set("v.IsCollectionNameValid",'valid');
            component.set("v.IsCollNameValidatedFromPCM",true);
            helper.saveValidatedTitle(component, event, helper);
        }
    },
    
    handleBusinessIdClick: function(component, event, helper) {  
        
        helper.getBusinessIdToUpdate(component, event, helper);
        component.set("v.ShowBusinessIdModal",true);
        component.set("v.IsmsgFromBusinessModal", 'true');
    },
    
    handleCollectionNameClick: function(component, event, helper) {  
        
        helper.getNameToUpdate(component, event, helper);
        component.set("v.ShowCollectionNameModal",true);
        component.set("v.IsmsgFromCollectionModal", 'true');
    },
    
    handleBusinessIdUpdateClick: function(component, event, helper) { 
        var businessIdToValidate=component.get("v.businessIdToValidate");
        var msgBusinessIdValidity = component.find("msgBusinessIdValidity");
        msgBusinessIdValidity.set("v.value",'');
        if(businessIdToValidate.length>14){
            msgBusinessIdValidity.set("v.value", '<span style="color: #bf4040;"><b>BusinessId length should not exceed 14 characters!</b></span>');
            
        }else{
            helper.getBusinessIdValiditycheck(component, event, helper);
            // alert(component.get("v.IsBusinessIdRegexValidated"));
            
        }
        
    },
    
    handleCollectionNameUpdateClick: function(component, event, helper) { 
        var titleToValidate=component.get("v.titleToValidate");
        var msgCollectionNameValidity = component.find("msgCollectionNameValidity");
        msgCollectionNameValidity.set("v.value",'');
 		console.log('handleCollectionNameUpdateClick');
        helper.getCollectionNameValidityStatus(component, event, helper);
       
        
    },
    
    handlemyRecordFormSubmit:function(component, event, helper){
        //event.preventDefault();
        var showValidationError = false;
        var fields = component.find("newProductField");
        var fieldBusid=component.find("newProductFieldBusId");
        var vaildationFailReason = '';
        var form=component.find('myRecordForm');
        var prodMsg=component.find('ProdMessage');
        
        //custom validation
        
        fields.forEach(function (field) {
            if(field.get("v.fieldName") === 'Name' && $A.util.isEmpty(field.get("v.value"))){
                showValidationError = true;
                vaildationFailReason = "The field 'Product Name' cannot be empty!";
                component.set("v.StrTitleFromEditModal",field.get("v.value"));
               
            }
            else if (field.get("v.fieldName") === 'Abstract__c' && $A.util.isEmpty(field.get("v.value"))){
                showValidationError = true;
                vaildationFailReason = "The field 'Abstract' cannot be empty!";
                return;
            }else if (field.get("v.fieldName") === 'Applicable_License_Types__c' && $A.util.isEmpty(field.get("v.value"))){
                showValidationError = true;
                vaildationFailReason = "The field 'Business Model' cannot be empty!";
            }else if (field.get("v.fieldName") === 'copyrightyear__c' && $A.util.isEmpty(field.get("v.value"))){
                showValidationError = true;
                vaildationFailReason = "The field 'Product Created Year' cannot be empty!";
                return;
            }else if (field.get("v.fieldName") === 'Product_Type_Author_Facing__c' &&  $A.util.isEmpty(field.get("v.value"))){
                showValidationError = true;
                vaildationFailReason = "The field 'Definition Model' cannot be empty!";
            }else if (field.get("v.fieldName") === 'Product_Category__c' &&  $A.util.isEmpty(field.get("v.value"))){
                showValidationError = true;
                vaildationFailReason = "The field 'Product Category' cannot be empty!";
            }/*else if (field.get("v.fieldName") === 'Sales_Channels__c' &&  $A.util.isEmpty(field.get("v.value"))){
                 showValidationError = true;
                 vaildationFailReason = "The field 'Sales Channel' cannot be empty!";
            }else if (field.get("v.fieldName") === 'Applicable_Channels__c' && $A.util.isEmpty(field.get("v.value"))){
                 showValidationError = true;
                 vaildationFailReason = "The field 'Delivery Channels' cannot be empty!";
             }*/else if (field.get("v.fieldName") === 'Applicable_Customer_Types__c' &&  $A.util.isEmpty(field.get("v.value"))){
                 showValidationError = true;
                 vaildationFailReason = "The field 'Applicable Customer Types' cannot be empty!";
             }else if (field.get("v.fieldName") === 'Collection_Subject_Area__c' &&  $A.util.isEmpty(field.get("v.value"))){
                showValidationError = true;
                vaildationFailReason = "The field 'Collection Subject Area' cannot be empty!";
                console.log('CollectionSubjectAreaText: ' + field.get("v.value"));
            }else if (field.get("v.fieldName") === 'businessId__c' &&  $A.util.isEmpty(field.get("v.value"))){
                 showValidationError = true;
                 vaildationFailReason = "The field 'Business Id' cannot be empty!";
             }else if (field.get("v.fieldName") === 'businessId__c' &&  $A.util.isEmpty(field.get("v.value"))==false && field.get("v.value").length>14){
                 showValidationError = true;
                 vaildationFailReason = "The field 'Business Id' length can be upto 14 characters!";
             }else if (field.get("v.fieldName") === 'businessId__c' && $A.util.isEmpty(field.get("v.value"))==false && field.get("v.value").length<=14){
                 component.set("v.StrBusinessIdFromEditModal",field.get("v.value"));
                 //helper.getbusinessIdValiditycheckForEditForm(component, event, helper);
                 var businessId = component.get("v.StrBusinessIdFromEditModal");
                 var action = component.get("c.ValidateBusinessId"); 
                 action.setParams({
                     "businessId":businessId
                 });
                 action.setCallback(this, function(response) {  
                     var state = response.getState();
                     if (state === "SUCCESS"){
                         var result = response.getReturnValue();
                         if(result==true){
                             showValidationError = false;
                             component.set("v.IsBusinessIdRegexValidatedForEditForm",'true');
                         }else{
                             showValidationError = true;
                             vaildationFailReason = "The field 'Business Id' is not valid!";
                             component.set("v.IsBusinessIdRegexValidatedForEditForm",'false');
                         } }           
                 });
                 $A.enqueueAction(action);    
             }  
        });
        
        if (!showValidationError) {
            component.set('v.spinner', true);
            component.find('myRecordForm').submit();  
        }else {
           component.find('ProdMessage').setError(vaildationFailReason);
           component.set('v.spinner', false); 
        }
        
     },
    
    handleSuccess: function(component, event) {
        console.log('getTitleValue: ' + component.get("v.StrTitleFromEditModal"));
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Record update Status!",
            "message": "Record has been updated Successfully!"
        });
        
        toastEvent.fire(); 
        var evt = $A.get("e.c:PPDRecordEditRefreshEvent");
        evt.setParams({
            "businessId": component.get("v.StrBusinessIdFromEditModal"),
            "title": component.get("v.StrTitleFromEditModal")
        });
        evt.fire();
        component.set("v.ShowNewEditRecordModal",false);
    },
    
    handlemyRecordFormCancel:function(component, event, helper){
        component.set("v.ShowNewEditRecordModal",false);
    },
    
    
    HideEditForm:function(component, event, helper){
        component.set("v.ShowNewEditRecordModal",false);
    },
    
     handlePreviewFromFinish: function (cmp, event, helper) {
             if(cmp.get("v.mainTabId") == 'Titles' && cmp.get("v.IsRecordLocked") == 'true'&& cmp.get("v.isFromFinishButton") == 'True'){
             var parentProductID = cmp.get("v.recordId");
            var action = cmp.get("c.getBundleItmsCount");    
            action.setParams({
                "bundleID": parentProductID            
            });             
            action.setCallback(this, function(response) {  
                var state = response.getState();
                if (state === "SUCCESS"){
                    
                    var result = response.getReturnValue();
                    if(result > 0){
                        cmp.set("v.showValidate",'true');
                    }else{
                        cmp.set("v.showValidate",'false');
                        cmp.set("v.isFromFinishButton",'False');
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
        }else{
            cmp.set("v.isFromFinishButton",'False');
            cmp.set("v.showValidate",'false');
        }
        
        
    },
    
     deleteCollectionRecord:  function(component, event, helper){
         component.set("v.ShowDeleteModal", false);
       helper.deleteCollectionRecord(component, event, helper);
         
         
     },
    
    
    deleteCollectionClick:  function(component, event, helper){
        component.set("v.ShowDeleteModal",'true')
         
     },
    
     closeModal: function(component, event, helper) {     
        component.set("v.ShowDeleteModal", false);
    },
    
    showSpinner : function(component,event,helper){
      // display spinner when aura:waiting (server waiting)
        component.set("v.toggleSpinner", true);  
      },
    hideSpinner : function(component,event,helper){
   // hide when aura:downwaiting
        component.set("v.toggleSpinner", false);
        
    },
    
    searchContentHandler: function(cmp, event, helper) {
        if (event.getParam("searchText") !== undefined && event.getParam("calledFrom") !== undefined && event.getParam("calledFrom") == cmp.get("v.additionType")) {
            var searchText=event.getParam("searchText");
            cmp.set("v.searchQueryText",searchText);
            
            if(searchText){
                cmp.set("v.showingAll","false");
                cmp.set("v.showingSearch","true");
                cmp.set("v.calledEvent","");
                cmp.set("v.pagesPerQuery",cmp.get("v.searchQueryLimit")/cmp.get("v.pageSize"));
                if(cmp.get("v.showingSelectiveDel") == 'true'){
                    cmp.set("v.calledEvent","selectAndDel");
                }else if(cmp.get("v.additionType") == 'Exclusion'){
                    cmp.set("v.calledEvent",'search');
                }else{
                    cmp.set("v.calledEvent",'');
                }
                helper.fetchSearchResult(cmp);
            }else{
                helper.resetSelectedIds(cmp);
                cmp.set("v.showingAll","true");
                cmp.set("v.showingSearch","false");
                cmp.set("v.pagesPerQuery", cmp.get("v.queryLimit")/cmp.get("v.pageSize"));
                cmp.set("v.pstn","0");
                cmp.set("v.paginationEvt","First");
                var resetPageIndex = true;
                if(cmp.get("v.showingSelectiveDel") == 'true'){
                    cmp.set("v.calledEvent","selectAndDel");
                }else{
                    cmp.set("v.calledEvent",'');
                }
                helper.fetchTitles(cmp, resetPageIndex);
            }
        }
    },
})