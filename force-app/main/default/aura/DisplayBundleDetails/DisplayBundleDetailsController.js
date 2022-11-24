({
    doInit : function(component, event, helper) {
        debugger;
        console.log('ccccccccccccccc' + component.get("v.collectionType"));
        var thisUUid = component.get("v.uuId");
        var action = component.get("c.getBundleRuleInformation"); 
        action.setParams({
            "bundleID":thisUUid,
        });
        action.setCallback(this, function(response) {  
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();               
                component.set('v.typeOfCollection',result.productType);
                
                if((result.dynamicRule!=undefined || result.dynamicRule!=null)&& (result.productType=='Rule based')){
                    component.set('v.isRulePresent','true');                     
                }
                
                if(result.productState =='true' && result.AllowUserToUpdate =='true'){
                    component.set("v.IsRecordLocked",'true');
                }
                if ( result.productCollectionupdatedFrom != undefined && result.productCollectionupdatedFrom != null && result.productCollectionupdatedFrom != '' ) {
                    component.set("v.updatedFromDate", result.productCollectionupdatedFrom);
                    var dd = String(new Date(component.get("v.updatedFromDate")).getDate()).padStart(2, '0');
                    var mm = String(new Date(component.get("v.updatedFromDate")).getMonth() + 1).padStart(2, '0');
                    var yyyy = new Date(component.get("v.updatedFromDate")).getFullYear();
                    var fromDateeVaal = $A.localizationService.formatDate((yyyy+'-'+mm+'-'+ dd), "YYYY-MM-DD");
        			component.set('v.updatedFromDate', fromDateeVaal);
                    console.log('Init updatedFromDate =====>' + component.get('v.updatedFromDate'));
                    $A.enqueueAction(component.get('c.handleFromDate'));
                }
                if ( result.productCollectionupdatedTo != undefined && result.productCollectionupdatedTo != null && result.productCollectionupdatedTo != '' ) {
                    component.set("v.updatedToDate", result.productCollectionupdatedTo);
                    var ddDate = String(new Date(component.get("v.updatedToDate")).getDate()).padStart(2, '0');
                    var mmDate = String(new Date(component.get("v.updatedToDate")).getMonth() + 1).padStart(2, '0');
                    var yyyyDate = new Date(component.get("v.updatedToDate")).getFullYear();
                    var toDateeVaal = $A.localizationService.formatDateTimeUTC((yyyyDate+'-'+mmDate+'-'+ddDate), "YYYY-MM-DD");
        			component.set('v.updatedToDate', toDateeVaal);
                    console.log('Init updatedToDate =====>' + component.get('v.updatedToDate'));
                    $A.enqueueAction(component.get('c.handleToDate'));
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
            
        });
        $A.enqueueAction(action);  
        
        
    },
    handleSubmit : function(component, event, helper) {
        debugger;
        component.set('v.mySpinner',true);
    },
    handleError : function(component, event, helper) {
        debugger;
        component.set('v.mySpinner',false);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'errror',
            message: event.getParam("message"),
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();        
        
    },
    handleSuccess : function(component, event, helper) {
        component.set('v.mySpinner',false);
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: 'Bundle Has been Updated Succesfully!!',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    handleFromDate : function(component, event, helper) { //SFAL-383 Vikas Varshney
        var enteredFromDate = component.find("Collection_updateddFrom__c").get("v.value");
        /*var fromDateeVal = $A.localizationService.formatDateTimeUTC(enteredFromDate, "YYYY-MM-DDThh:mm:ssZ");
        component.set('v.updatedFromDateTime', fromDateeVal);
        console.log('NewupdatedFromDateTime =====>' + component.get('v.updatedFromDateTime'));*/
        var fromDateeVal = new Date(enteredFromDate).toLocaleString("en-US", {timeZone: "GMT"});
        var userDate = new Date(enteredFromDate).toLocaleString("en-US", {timeZone: $A.get("$Locale.timezone")});
        var hoursDiff = (new Date(fromDateeVal) - new Date(userDate))/(1000*60*60);
        console.log('hoursDiff =====>' + hoursDiff);
        if ( hoursDiff > 0 ) {
            fromDateeVal = enteredFromDate + 'T' + String(Math.ceil(hoursDiff)).padStart(2, '0') + ':00:00.000Z';
        } else {
            fromDateeVal = new Date(enteredFromDate).setHours(-24);
            fromDateeVal = $A.localizationService.formatDateTime(new Date(fromDateeVal), "YYYY-MM-DD") + 'T' + (24+Math.ceil(hoursDiff)) + ':00:00.000Z';
        }
        component.set('v.updatedFromDateTime', fromDateeVal);
        console.log('NewupdatedFromDateTime =====>' + component.get('v.updatedFromDateTime'));
    },
    
    handleToDate : function(component, event, helper) { //SFAL-383 Vikas Varshney
        var enteredToDate = component.find("Collection_updateddTo__c").get("v.value");
        /*var toDateeVal = $A.localizationService.formatDateTimeUTC(enteredToDate, "YYYY-MM-DDThh:mm:ssZ");
        component.set('v.updatedToDateTime', toDateeVal);*/
        var toDateeVal = new Date(enteredToDate).toLocaleString("en-US", {timeZone: "GMT"});
        var userDate = new Date(enteredToDate).toLocaleString("en-US", {timeZone: $A.get("$Locale.timezone")});
        var hoursDiff = (new Date(toDateeVal) - new Date(userDate))/(1000*60*60);
        if ( hoursDiff > 0 ) {
            toDateeVal = enteredToDate + 'T' + String(Math.ceil(hoursDiff)).padStart(2, '0') + ':00:00.000Z';
        } else {
            toDateeVal = new Date(enteredToDate).setHours(-24);
            toDateeVal = $A.localizationService.formatDateTime(new Date(toDateeVal), "YYYY-MM-DD") + 'T' + (24+Math.ceil(hoursDiff)) + ':00:00.000Z';
        }
        component.set('v.updatedToDateTime', toDateeVal);
        console.log('NewupdatedToDateTime =====>' + component.get('v.updatedToDateTime'));
    }
})