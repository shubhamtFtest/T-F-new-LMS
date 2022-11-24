({
    //for closing the licence create quick action
    closeModal: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    //sets the mandatory fields dynamically on some conditions
    SetMandatory: function(component, event, helper) {
        var val = event.getSource().get("v.value");
        if(val!=='' && val!=='Perpetual'){
            $A.util.removeClass(component.find("End_Date__c"), "none"); //UBX-10932
            $A.util.addClass(component.find("End_Date__c"), "customRequired");
        }
        else if(val!=='' && val==='Perpetual'){
            $A.util.removeClass(component.find("End_Date__c"), "customRequired");
            $A.util.addClass(component.find("End_Date__c"), "none"); //UBX-10932
        }
        //this if-else block is to hide and show of purchase date on UI
        if ( val!=='' && val!=='Trial' ) {
            $A.util.addClass(component.find("Purchase_Date__c"), "customRequired");
            $A.util.removeClass(component.find("Purchase_Date__c"), "none");
        }
        else {
            $A.util.removeClass(component.find("Purchase_Date__c"), "customRequired");
            $A.util.addClass(component.find("Purchase_Date__c"), "none");
        }
    },
    
    updateTypeMandatory: function(component, event, helper) {
        var updateTypeVal = event.getSource().get("v.value");
        if ( updateTypeVal!=='' && updateTypeVal!=='Dynamic' ) {
            $A.util.removeClass(component.find("Dynamic_License_End_Date__c"), "customRequired");
            $A.util.removeClass(component.find("Dynamic_License_End_Date__c"), "CustleftPadding");
            $A.util.addClass(component.find("Dynamic_License_End_Date__c"), "none");
        }else if( updateTypeVal==='Dynamic' )
        {
            $A.util.addClass(component.find("Dynamic_License_End_Date__c"), "customRequired");
            $A.util.addClass(component.find("Dynamic_License_End_Date__c"), "CustleftPadding");
            $A.util.removeClass(component.find("Dynamic_License_End_Date__c"), "none");
        }else if( updateTypeVal==='' )
        {
            $A.util.removeClass(component.find("Dynamic_License_End_Date__c"), "customRequired");
            $A.util.removeClass(component.find("Dynamic_License_End_Date__c"), "CustleftPadding");
            $A.util.addClass(component.find("Dynamic_License_End_Date__c"), "none");
        }
        
        var updateTyype = component.find("Update_Type__c").get("v.value");
        if ( updateTyype==='Static' || updateTyype==='' || updateTyype===null || updateTyype==='undefined' ) {
            var datte = '';
            component.set("v.dynamicEndDateValue", datte);
        }
    },
    
    //handles onload to get all the information related to contact
    fetchContactDetails: function(component, event, helper) {   
        var conid= component.get("{!v.recordId}");
        var localeShortFormat = $A.get("$Locale.shortDateFormat");
        var partyIdUpdateStatus;
        component.set("{!v.ParentContactId}",conid);
        component.set("{!v.PurchaseDatee}", $A.localizationService.formatDateTime(new Date(), "YYYY-MM-DD"));
        var todaysDaate = $A.localizationService.formatDate(new Date());
        component.set('v.minDate', todaysDaate);
        var todaysStartDaate = new Date();
        var todaysStartDaateFormat = $A.localizationService.formatDate(todaysStartDaate, localeShortFormat);
        var getStartDate = todaysStartDaate.getDate();
        var getStartMonth = todaysStartDaate.getMonth()+1;
        var getStartYear = todaysStartDaate.getFullYear();
        /*
        alert('todaysStartDaate =====>' + todaysStartDaate);
        alert('todaysStartDaate getDatee =====>' + getStartDate);
        alert('todaysStartDaate getMonthh =====>' + getStartMonth);
        alert('todaysStartDaate getYearr =====>' + getStartYear);
        alert('todaysStartDaateFormat.toString() =====>' + todaysStartDaateFormat.toString());
        alert('Check Start date =====>' + todaysStartDaateFormat.toString().startsWith(getStartDate));
        alert('Check Start month =====>' + todaysStartDaateFormat.toString().startsWith(getStartMonth));
        alert('Check Start year =====>' + todaysStartDaateFormat.toString().startsWith(getStartYear));
        */
        if ( todaysStartDaateFormat.toString().startsWith(getStartDate) ) {
            var setStartDatee = todaysStartDaate.getDate() + '/' + (todaysStartDaate.getMonth() + 1) + '/' + todaysStartDaate.getFullYear();
            component.set('v.startDateMessage', 'Value must be '+ setStartDatee + ' or later.');
        } else if ( todaysStartDaateFormat.toString().startsWith(getStartMonth) ) {
            var setStartDatee = (todaysStartDaate.getMonth() + 1) + '/' + todaysStartDaate.getDate() + '/' + todaysStartDaate.getFullYear();
            component.set('v.startDateMessage', 'Value must be '+ setStartDatee + ' or later.');
        } else if ( todaysStartDaateFormat.toString().startsWith(getStartYear) ) {
            var setStartDatee = todaysStartDaate.getFullYear() + '/' + (todaysStartDaate.getMonth() + 1) + '/' + todaysStartDaate.getDate();
            component.set('v.startDateMessage', 'Value must be '+ setStartDatee + ' or later.');
        } else {
            component.set('v.startDateMessage', 'Value must be '+ todaysStartDaate.toLocaleDateString() + ' or later.');
        }
        var resultEndDate = new Date();
		resultEndDate.setDate(resultEndDate.getDate() + 1);
        var endDaate = $A.localizationService.formatDate(resultEndDate);
        component.set('v.endMinDate', endDaate);
        var endDaateFormat = $A.localizationService.formatDate(resultEndDate, localeShortFormat);
        var getDatee = resultEndDate.getDate();
        var getMonthh = resultEndDate.getMonth()+1;
        var getYearr = resultEndDate.getFullYear();
        /*
        //Value must be Sep 23, 2020 or later.
        alert('resultEndDate =====>' + resultEndDate);
        alert('resultEndDate getDatee =====>' + getDatee);
        alert('resultEndDate getMonthh =====>' + getMonthh);
        alert('resultEndDate getYearr =====>' + getYearr);
        alert('endDaateFormat.toString() =====>' + endDaateFormat.toString());
        alert('Check date =====>' + endDaateFormat.toString().startsWith(getDatee));
        alert('Check month =====>' + endDaateFormat.toString().startsWith(getMonthh));
        alert('Check year =====>' + endDaateFormat.toString().startsWith(getYearr));
        */
        if ( endDaateFormat.toString().startsWith(getDatee) ) {
            var setEndDatee = resultEndDate.getDate() + '/' + (resultEndDate.getMonth() + 1) + '/' + resultEndDate.getFullYear();
            component.set('v.endDateMessage', 'Value must be '+ setEndDatee + ' or later.');
        } else if ( endDaateFormat.toString().startsWith(getMonthh) ) {
            var setEndDatee = (resultEndDate.getMonth() + 1) + '/' + resultEndDate.getDate() + '/' + resultEndDate.getFullYear();
            component.set('v.endDateMessage', 'Value must be '+ setEndDatee + ' or later.');
        } else if ( endDaateFormat.toString().startsWith(getYearr) ) {
            var setEndDatee = resultEndDate.getFullYear() + '/' + (resultEndDate.getMonth() + 1) + '/' + resultEndDate.getDate();
            component.set('v.endDateMessage', 'Value must be '+ setEndDatee + ' or later.');
        } else {
            component.set('v.endDateMessage', 'Value must be '+ resultEndDate.toLocaleDateString() + ' or later.');
        }
        //var dynamicEndDaate = $A.localizationService.formatDate(resultEndDate);
        var dynamicEndDaate = $A.localizationService.formatDate(todaysDaate);
        component.set('v.dynamicEndMinnDate', dynamicEndDaate);
        component.set('v.dynamicEndDateValue', dynamicEndDaate);
        var action = component.get("c.fetchContactDetailForLicense");        
        action.setParams({
            "contactId": conid 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var contactRecord = response.getReturnValue();            
                var hasPartyId=contactRecord.Party_Id__c; 
                var contactEmail=contactRecord.Email;
                var conName = contactRecord.Name;
                component.set("{!v.ParentAccountName}",conName);
                
                //Checking the parent account to have customerId or not.                
                if(hasPartyId=='' || hasPartyId==null ||hasPartyId==undefined) {   
                    component.set("{!v.hasPartyId}",'false'); 
                    // call update party id method to fetch partyid
                    var updateAction = component.get("c.updateContactPartyIdForLicense"); 
                    updateAction.setParams({
                        "contactId": conid,
                        "contactEmail":contactEmail                        
                    });
                    updateAction.setCallback(this, function(response) {
                        var updateState = response.getState();
                        if (updateState === "SUCCESS") {                            
                            
                        }                        
                    });
                    $A.enqueueAction(updateAction); 
                }
                else if(hasPartyId!='' || hasPartyId!=null|| hasPartyId!=undefined){
                    component.set("{!v.hasPartyId}",'true');
                }
                
                // Again confirming partyid
                var conAction = component.get("c.fetchContactDetailForLicense"); 
                conAction.setParams({
                    "contactId": conid 
                });
                conAction.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var updatedContactRecord = response.getReturnValue();          
                        var hasUpdatedPartyId=updatedContactRecord.Party_Id__c;                
                        if(hasUpdatedPartyId=='' || hasUpdatedPartyId==null ||hasUpdatedPartyId==undefined){
                            component.set("{!v.isFormOpen}", false);
                            component.set("{!v.ErrorMessage}", "Licence can not be created as contact does not have party Id!")
                        }
                        else{
                            component.set("{!v.isFormOpen}", true)}
                    }
                });
                $A.enqueueAction(conAction); 
            }
            else if(state === "ERROR") {
                component.set("{!v.hasPartyId}",'false');
            }
        });
        $A.enqueueAction(action);        
        
        
        //get recordtype id of T&F Individual License  
        var getRecordTypeAction = component.get("c.getRecordTypeId");        
        getRecordTypeAction.setParams({
            "objectName": 'License__c',
            "recordTypeName":'T&F Individual License'
        });
        getRecordTypeAction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var recordTypeIdRecord = response.getReturnValue();          
                component.set("{!v.RecordTypeId}",recordTypeIdRecord);
            }
        });
        $A.enqueueAction(getRecordTypeAction); 
    },
    
    
    //handles when user clicks on submit
    CreateLicense: function(component, event, helper) {
        event.preventDefault(); //Prevent default submit
        var eventFields = event.getParam("fields");
        var contactId=component.get("{!v.ParentContactId}");
        var checkEndDate;
        var startDatee = component.find("Start_Date__c").get("v.value");
        var endDatee = component.find("End_Date__c").get("v.value");
        var dynamicEndDatee = component.find("Dynamic_License_End_Date__c").get("v.value");
        var todaysDaatte = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        
        /*if ( eventFields["Start_Date__c"]!=='' ||eventFields["Start_Date__c"]!==null ) {
            checkEndDate = eventFields["Start_Date__c"];
        }*/
        if ( startDatee!=='' || startDatee!==null || startDatee!=='undefined' ) {
            checkEndDate = startDatee;
            component.set("v.startDateValue", startDatee);
        }
        
        // UBX-10932 - START
        var perpetualTypeCheck = component.find("License_Type__c").get("v.value");
        if ( perpetualTypeCheck!=='' && perpetualTypeCheck!==null && perpetualTypeCheck!=='undefined' && perpetualTypeCheck==='Perpetual' ) {
            eventFields["End_Date__c"]=''; // UBX-10932 - END
        } else if ( endDatee!=='' || endDatee!==null || endDatee!=='undefined' ) {
        	component.set("v.endDateValue", endDatee);
        }
        
        if ( eventFields["License_Type__c"]==='Trial' ) {
            //component.set("{!v.PurchaseDatee}", '\'\'');
            //component.find("Purchase_Date__c").set("v.fieldName","Purchase_Date__c");
            //component.find("Purchase_Date__c").set("v.value",'');
            eventFields["Purchase_Date__c"]='';
        }
        
        if (eventFields["Product__c"]==='' || eventFields["Product__c"]===null)
        {
            component.set("v.message",'Please enter product!');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Create New License",
                "message": 'Please enter product!'
            });
            toastEvent.fire();
            return;
        }
        //else if (eventFields["Start_Date__c"]==='' ||eventFields["Start_Date__c"]===null) {
        else if (startDatee==='' || startDatee===null || startDatee==='undefined') {
            component.set("v.message",'Please enter Start Date!');          
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Create New License",
                "message": 'Please enter Start Date!'
            });
            toastEvent.fire();   
            return;
        }
        else if ( startDatee!=='' && startDatee!==null && startDatee!=='undefined' && startDatee < todaysDaatte ) {
            component.set("v.message",'Start Date should not be previous date!');          
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Create New License",
                "message": 'Start Date should not be previous date!'
            });
            toastEvent.fire();   
            return;
        }
        //else if ((eventFields["License_Type__c"]!=='Perpetual' && (eventFields["End_Date__c"]==='' || eventFields["End_Date__c"]===null))) {
        else if ((eventFields["License_Type__c"]!=='Perpetual' && (endDatee==='' || endDatee===null || endDatee==='undefined'))) {
            component.set("v.message",'Please enter all the mandatory fields!');          
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Create New License",
                "message": 'Please enter End Date!'
            });
            toastEvent.fire();   
            return;
        }
        //else if (eventFields["End_Date__c"]===checkEndDate ) {
        else if (eventFields["License_Type__c"]!=='Perpetual' && endDatee<=checkEndDate ) {
            component.set("v.message",'Please enter End Date greater than Start Date!');          
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Create New License",
                "message": 'Please enter End Date greater than Start Date!'
            });
            toastEvent.fire();   
            return;
        }
        
        if ( eventFields["Update_Type__c"]==='Dynamic' && (dynamicEndDatee==='' || dynamicEndDatee===null || dynamicEndDatee==='undefined') ) {
            component.set("v.message",'Please enter Dynamic License End Date for "Dynamic" License Type!');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Create New License",
                "message": 'Please enter Dynamic License End Date for "Dynamic" License Type!'
            });
            toastEvent.fire();   
            return;
        }
        else if ( eventFields["Update_Type__c"]==='Dynamic' && (dynamicEndDatee!=='' || dynamicEndDatee!==null || dynamicEndDatee!=='undefined') && dynamicEndDatee<checkEndDate ) {
            component.set("v.message",'Dynamic License End Date should be greater than or equal to the Start Date!');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Create New License",
                "message": 'Dynamic License End Date should be greater than or equal to the Start Date!'
            });
            toastEvent.fire();   
            return;
        }
        else if ( eventFields["Update_Type__c"]==='Dynamic' && (dynamicEndDatee!=='' || dynamicEndDatee!==null || dynamicEndDatee!=='undefined') && (eventFields["License_Type__c"]!=='Perpetual') && dynamicEndDatee>endDatee ) {
            component.set("v.message",'Dynamic License End Date should be less than or equal to the End Date!');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Create New License",
                "message": 'Dynamic License End Date should be less than or equal to the End Date!'
            });
            toastEvent.fire();   
            return;
        }
        
        var action = component.get("c.fetchContactDetailForLicense");
        action.setParams({
            "contactId": contactId 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var contactRecord = response.getReturnValue();               
                var hasContactPartyId=contactRecord.Party_Id__c; 
                
                if(hasContactPartyId=='' || hasContactPartyId==null ||hasContactPartyId==undefined){ 
                    component.set("{!v.hasContactPartyId}","false"); 
                }
                else{
                    component.set("{!v.hasContactpartyId}","true");
                }
                
                if (eventFields["Start_Date__c"]==='' ||eventFields["Start_Date__c"]===null || (eventFields["License_Type__c"]!=='Perpetual' && (eventFields["End_Date__c"]==='' || eventFields["End_Date__c"]===null)))  {
                    component.set("v.message",'Please enter all the mandatory fields!');         
                    return;
                }
                else if (eventFields["Product__c"]==='' || eventFields["Product__c"]===null){
                    component.set("v.message",'Please enter all the mandatory fields!');
                    return;
                }
                    else if (component.get("v.hasContactPartyId")=='false'){    
                        component.set("v.message",'License can not be created!');
                        return;
                    }
                        else {component.find('LicenseCreateForm').submit(eventFields);            
                             }
            }
        });
        component.set("{!v.isSaveDisable}",'true');
        $A.enqueueAction(action);      
    },
    
    //handles when licence gets created succesfully  
    handleOnSuccess: function(component, event, helper) {     
        var params = event.getParams();  
        //component.set("{!v.licenceId}",params.response.id)
        $A.get("e.force:closeQuickAction").fire();
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Create New License",
            "message": "License has been created succesfully!",
            duration : 7000            
        });
        toastEvent.fire();
    },
     //handles when error for license creation
    handleOnError: function(component, event, helper) {     
        $A.get("e.force:closeQuickAction").fire();
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Create New License",
            "message": "Some Error has occured, Please contact your administrator!",
            duration : 6000
            
        });
        toastEvent.fire();     
    },
    
    checkStartDate: function(component, event, helper) {
        var startDatee = component.find("Start_Date__c").get("v.value");
        if ( startDatee!=='' || startDatee!==null || startDatee!=='undefined' ) {
            component.set("v.startDateValue", startDatee);
        }
    },
    
    checkEndDate: function(component, event, helper) {
        var endDatee = component.find("End_Date__c").get("v.value");
        if ( endDatee!=='' || endDatee!==null || endDatee!=='undefined' ) {
        	component.set("v.endDateValue", endDatee);
        }
    },
    
    checkDynamicEndDate: function(component, event, helper) {
        var dynamicEndDatee = component.find("Dynamic_License_End_Date__c").get("v.value");
        if ( dynamicEndDatee!=='' || dynamicEndDatee!==null || dynamicEndDatee!=='undefined' ) {
        	component.set("v.dynamicEndDateValue", dynamicEndDatee);
        } else if ( dynamicEndDatee==='' || dynamicEndDatee===null || dynamicEndDatee==='undefined' ) {
            component.set("v.dynamicEndDateValue", dynamicEndDatee);
        }
    }
})