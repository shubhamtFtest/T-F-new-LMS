({
    init : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        var dateTime = new Date().toISOString();
        var currentTime = new Date();
        var year = String(currentTime.getFullYear());
        //SFAL-383 Vikas Varshney CustomDynamic-[date]-[time]
        var todaysDate = $A.localizationService.formatDate(new Date(), "YYYY/MM/DD");
        var nowTimeVal =String(new Date().getHours()).padStart(2, '0') + ':' + String(new Date().getMinutes()).padStart(2, '0') + ':' + String(new Date().getSeconds()).padStart(2, '0');
        var prodCustName = 'CustomDynamic - ' + todaysDate + ' - ' + nowTimeVal;
        //component.set('v.nowTime', nowTimeVal);
        console.log('prodCustName =====>' + prodCustName);
        component.set('v.prodCustomName', prodCustName);
        component.set('v.validFromDate', dateTime);
        
        
        var action = component.get("c.getOppAndSapDetails");
        component.set("v.mySpinner", true);
        action.setParams({
            "quoteId" : component.get('v.recordId'),
        });
        action.setCallback(this, function(response) {
            component.set("v.mySpinner", false); 
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if(!$A.util.isEmpty(result) && !$A.util.isUndefinedOrNull(result))
                {
                    component.set('v.implicitFltrValues', [{name: 'Restricted Country',value: result,prdType: 'book'}]);
                    console.log('implicitFltrValues DS '+JSON.stringify(component.get('v.implicitFltrValues')));
                }
            }
        });
        $A.enqueueAction(action);
        
        //get recordtype id for "T&F - BespokeCollection" from Product2
        /*var getRecordTypeAction = component.get("c.getProdRecordTypeId");        
        getRecordTypeAction.setParams({
            "objectName": 'Product2',
            "recordTypeName":'T&F - BespokeCollection'
        });
        getRecordTypeAction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.prodRecordTypeId",result.recordTypeId);
                component.set("v.bespokeBusinessId", result.bespokeBusinessId);
                console.log('prodRecordTypeId =====>' + component.get('v.prodRecordTypeId'));
            }
        });
        $A.enqueueAction(getRecordTypeAction);*/
        
        var getBespokeBusinessIdAction = component.get("c.getCustomSettingData");        
        getBespokeBusinessIdAction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.prodRecordTypeId",result.recordTypeId);
                component.set("v.bespokeBusinessId", result.bespokeBusinessId);
                console.log('businessBespokeId =====>' + component.get('v.bespokeBusinessId'));
            }
        });
        $A.enqueueAction(getBespokeBusinessIdAction);
        
        //checking if dynamic bespoke collection exists on quote or not (SFAL-228)
        var getDynamicQLIAction = component.get("c.getDynamicBespokeQLI");        
        getDynamicQLIAction.setParams({
            "quoteId" : component.get('v.recordId'),
        });
        getDynamicQLIAction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var isBespokeQLI = response.getReturnValue();
                console.log('JSON bespoke QLI =====>' + JSON.stringify(isBespokeQLI));
                if ( isBespokeQLI.Id !== null && isBespokeQLI.Id !== '' && isBespokeQLI.Id !== undefined ) {
                    console.log('Check Null =====>');
                    if ( isBespokeQLI.SBQQ__Product__r.Product_Type_Author_Facing__c === 'Rule based' ) {
                        console.log('Inside if =====>');
                        component.set("v.isBespokeCollection", true);
                        component.set("v.ShowNewEditRecordModal", false);
                        component.set("v.newBespokeCollectionId", isBespokeQLI.SBQQ__Product__c);
                    } else if ( isBespokeQLI.SBQQ__Product__r.Product_Type_Author_Facing__c === 'Manual Curation' || isBespokeQLI.SBQQ__Product__r.Product_Type_Author_Facing__c === 'Static' ) { //SFAL-281
                        console.log('Inside else =====>');
                        component.set("v.isBespokeCollection", false);
                        component.set("v.ShowNewEditRecordModal", false);
                        component.set("v.newBespokeCollectionId", isBespokeQLI.SBQQ__Product__c);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Warning",
                            "message": "Already a static Bespoke Collection exist. Please use it or contact your Admin."
                        });
                        toastEvent.fire();
                    } else { //SFAL-281
                        component.set("v.isBespokeCollection", false);
                        component.set("v.ShowNewEditRecordModal", false);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Warning",
                            "message": "Already single titles exist. Please contact your Admin."
                        });
                        toastEvent.fire();
                    }
                }
                console.log('isBespokeCollection =====>' + component.get('v.isBespokeCollection'));
                console.log('ShowNewEditRecordModal =====>' + component.get('v.ShowNewEditRecordModal'));
            }
        });
        $A.enqueueAction(getDynamicQLIAction);
    },
    
    handleSuccess: function(component, event) {
        var bespokeId = event.getParams().response.id;
        console.log('bespokeId =====>' + bespokeId);
        component.set("v.newBespokeCollectionId", bespokeId);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "Record has been created Successfully!"
        });
        toastEvent.fire();
        component.set("v.ShowNewEditRecordModal", false);
        component.set("v.isBespokeCollection", true);
        component.set('v.mySpinner', false);
        
        if ( component.get("v.isBespokeCollection") === true ) {
            /*var actionPBE = component.get("c.createPBE");
            actionPBE.setParams({
                "quoteRecId" : component.get("v.recordId"),
                "bundleProdId" : bespokeId,
                "unitPrice" : null,
                "totalsalePrice" : null,
            });
            actionPBE.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    if ( !$A.util.isEmpty(result) && !$A.util.isUndefinedOrNull(result) ) {
                        console.log('actionPBE success result =====>' + result);
                    } else {
                        console.log('actionPBE error result =====>' + result);
                    }
                }
            });
            $A.enqueueAction(actionPBE);*/
            
            var actionQLI = component.get("c.createBespokeQLI");
            actionQLI.setParams({
                "quoteId" : component.get("v.recordId"),
                "bespokeProductId" : bespokeId,
                "totalsalePrice" : null,
            });
            actionQLI.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    if ( !$A.util.isEmpty(result) && !$A.util.isUndefinedOrNull(result) ) {
                        console.log('actionQLI success result =====>' + result);
                    } else {
                        console.log('actionQLI error result =====>' + result);
                    }
                }
            });
            $A.enqueueAction(actionQLI);
        }
    },
    
    handlemyRecordFormCancel:function(component, event, helper){
        component.set("v.ShowNewEditRecordModal", false);
    },
    
    handleError:function(component, event, helper){
        component.set('v.mySpinner', false);
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
    
    handlemyRecordFormSubmit:function(component, event, helper){
        //event.preventDefault();
        var showValidationError = false;
        var fields = component.find("newProductField");
        var vaildationFailReason = '';
       
        //custom validation
        fields.forEach(function (field) {
            if(field.get("v.fieldName") === 'Name' && $A.util.isEmpty(field.get("v.value"))){
                showValidationError = true;
                vaildationFailReason = "The field 'Product Name' cannot be empty!";
                return;
            } else if (field.get("v.fieldName") === 'Applicable_License_Types__c' && $A.util.isEmpty(field.get("v.value"))){
                showValidationError = true;
                vaildationFailReason = "The field 'Business Model' cannot be empty!";
                return;
            } else if (field.get("v.fieldName") === 'Applicable_Customer_Types__c' &&  $A.util.isEmpty(field.get("v.value"))){
                showValidationError = true;
                vaildationFailReason = "The field 'Applicable Customer Types' cannot be empty!";
                return;
            }/* else if (field.get("v.fieldName") === 'Applicable_Channels__c' && $A.util.isEmpty(field.get("v.value"))){
                showValidationError = true;
                vaildationFailReason = "The field 'Delivery Channel' cannot be empty!";
                return;
            }else if (field.get("v.fieldName") === 'Sales_Channels__c' && $A.util.isEmpty(field.get("v.value"))){
                showValidationError = true;
                vaildationFailReason = "The field 'Sales Channel' cannot be empty!";
                return;
            } */
        });
        
        if (component.find("Collection_updateddFrom__c").get("v.label") === 'Collection updatedFrom' &&  $A.util.isEmpty(component.find("Collection_updateddFrom__c").get("v.value"))){
            showValidationError = true;
            vaildationFailReason = "";
            return;
        } else if (component.find("Collection_updateddTo__c").get("v.label") === 'Collection updatedTo' &&  $A.util.isEmpty(component.find("Collection_updateddTo__c").get("v.value"))){
            showValidationError = true;
            vaildationFailReason = "";
            return;
        }
        
        if (!showValidationError) {
            component.set('v.mySpinner', true);
        } else {
            component.find('ProdMessage').setError(vaildationFailReason);
            component.set('v.mySpinner', false);
        }
    },
    
    handleComponentEvent : function(component, event, helper) {
        debugger;
        var activeT = event.getParam("isActiveTab");
        component.set("v.activeTab", activeT);
        var uuId = event.getParam("pcmUUID");//pcmUUID
        component.set("v.uuID", uuId);
        component.set("v.selectedTab",'bundleItems');
        var inSalesforce = event.getParam("inSalesforce");
        component.set("v.inSalesforce",inSalesforce);
        var isBespokeQLI = event.getParam("isBespokeQLI");
        component.set("v.isBespokeQLI",isBespokeQLI);
    },
    
    handleFromDate : function(component, event, helper) { //SFAL-383 Vikas Varshney
        var enteredFromDate = component.find("Collection_updateddFrom__c").get("v.value");
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