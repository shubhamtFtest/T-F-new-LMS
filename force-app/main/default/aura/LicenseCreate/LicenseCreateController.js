({
    
    showRequiredFields: function(component, event, helper){
        $A.util.removeClass(component.find("Start_Date__c"), "none");
        $A.util.removeClass(component.find("License_Type__c"), "none");
        $A.util.removeClass(component.find("Description__c"), "none");
        $A.util.removeClass(component.find("Product__c"), "none");
        $A.util.removeClass(component.find("Grant_Type__c"), "none");
    },
    //handles when licence gets created succesfully  
    handleOnSuccess: function(component, event, helper) {     
        var params = event.getParams();  
        component.set("{!v.licenceId}",params.response.id);
        $A.get("e.force:closeQuickAction").fire();
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Create New License",
            "message": "License has been created succesfully!",
            duration : 7000
        });
        toastEvent.fire();     
        //updating license members after licence gets created      
        if(component.get("{!v.isSelected}")==false)
        {
            helper.updateConsortiumMembersHelper(component, event,component.get("{!v.allvalidMembers}")); 
        }
        else if (component.get("{!v.isSelected}")==true)
        {           
            helper.updateConsortiumMembersHelper(component, event,component.get("{!v.defaultOptions}"));
        }        
        $A.get('e.force:refreshView').fire();
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
    
    //for closing the licence create quick action
    closeModal: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    
    SetMandatory: function(component, event, helper) {
        var val = event.getSource().get("v.value");
        if(val!=='' && val!=='Perpetual')
        {
            $A.util.removeClass(component.find("End_Date__c"), "none"); //UBX-10932
            $A.util.addClass(component.find("End_Date__c"), "customRequired");
        }
        else if(val!=='' && val==='Perpetual')
        {
            $A.util.removeClass(component.find("End_Date__c"), "customRequired");
            $A.util.addClass(component.find("End_Date__c"), "none"); //UBX-10932
        }
        else if (val=='')
        {
            $A.util.removeClass(component.find("End_Date__c"), "customRequired");
        }
        if ( val!=='' && val!=='Trial' ) {
            $A.util.addClass(component.find("Purchase_Date__c"), "customRequired");
            $A.util.removeClass(component.find("Purchase_Date__c"), "none");
        }
        else if ( val!=='' && val==='Trial' ) {
            $A.util.removeClass(component.find("Purchase_Date__c"), "customRequired");
            $A.util.addClass(component.find("Purchase_Date__c"), "none");
        }
        else if ( val=='' ) {
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
    
    //handles when user clicks on submit
    CreateLicense: function(component, event, helper) {
        event.preventDefault(); //Prevent default submit
        var eventFields = event.getParam("fields");
        var checkEndDate;
        var startDatee = component.find("Start_Date__c").get("v.value");
        var endDatee = component.find("End_Date__c").get("v.value");
        var dynamicEndDatee = component.find("Dynamic_License_End_Date__c").get("v.value");
        var todaysDaatte = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        
        //if ( eventFields["Start_Date__c"]!=='' ||eventFields["Start_Date__c"]!==null ) {
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
        //if (eventFields["Start_Date__c"]==='' ||eventFields["Start_Date__c"]===null || (eventFields["License_Type__c"]!=='Perpetual' && (eventFields["End_Date__c"]==='' || eventFields["End_Date__c"]===null)))  {
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
        else if ( eventFields["Update_Type__c"]==='Dynamic' && (dynamicEndDatee==='' || dynamicEndDatee===null || dynamicEndDatee==='undefined') ) {
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
        else if (component.get("v.hasCustomerId")=='false')
            {
                component.set("v.message",'License can not be created as customer Id does not exist for this account!'); 
                return;
            }
                else if (component.get("{!v.listInvalidOptions}")!='valid' && component.get("{!v.isSelected}")==false && component.get("v.isConsortium")==true)
                {                 
                    component.set("v.message",'License can not be created as' + ' ' + component.get("v.listInvalidOptions") + ' ' + 'members do not have customer Id!');
                    return;
                }
                    else if(component.get("{!v.isSelected}")==true && (component.get("{!v.defaultOptions}")==null || component.get("{!v.defaultOptions}")==''))
                    {
                        component.set("v.message",'License can not be created as member has not been selected!');
                        return;
                    }
                        else if((component.get("{!v.open}")=='false'||component.get("{!v.open}")==undefined)&&(component.get("{!v.allvalidMembers}")==null || component.get("{!v.allvalidMembers}")=='')&& (component.get("{!v.isConsortium}")==true))
                        {
                            component.set("v.message",'License can not be created as member has not been added into the account!');
                            return;
                        }
                            else 
                            {
                                component.find('LicenseCreateForm').submit(eventFields);
                            }
        component.set("{!v.isSaveDisable}",'true');        
    },
    //handles onload to get all the information related to account
    fetchAccountDetails: function(component, event, helper) {
        var accid= component.get("{!v.recordId}");
        var localeShortFormat = $A.get("$Locale.shortDateFormat");
        component.set("{!v.ParentAccountId}",accid);     
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
        var action = component.get("c.fetchAccountDetailForLicense");
        action.setParams({
            "accountId": accid 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var accountRecord = response.getReturnValue();
                var hasCustomerId=accountRecord.Customer_Id__c ;
                var accName = accountRecord.Name;
                component.set("{!v.ParentAccountName}",accName);
                //Checking the parent account to have customerId or not.                
                if(hasCustomerId=='' || hasCustomerId==null ||hasCustomerId==undefined)
                {
                    var accReccordId = component.get("{!v.recordId}");
                    var ubxResponseAction = component.get("c.isUbxAccResponse");
                    var isUbxReesponse = false;
                    ubxResponseAction.setParams({
                        "acountId": accReccordId,
                    });
                    ubxResponseAction.setCallback(this, function(response) {
                        var ubxResp = response.getState();
                        if (ubxResp === "SUCCESS") {
                            isUbxReesponse = response.getReturnValue();
                            if (isUbxReesponse=='Licence can not be created as account does not have party Id!') {
                                component.set("v.isFormOpen",false);
                                component.set("v.Accountmessage","Licence can not be created as account does not have party Id!");
                            }
                            if (isUbxReesponse=='false') {
                                component.set("v.isFormOpen",false);
                                component.set("v.Accountmessage","License can't be created as the corresponding account is not a valid UBX customer");
                            }
                            if ( isUbxReesponse=='true' ) {
                                component.set("{!v.hasCustomerId}",'false');
                                var accRecordId = component.get("{!v.recordId}");
                                var updateAction = component.get("c.updateAccountPartyIdForLicense"); 
                                updateAction.setParams({
                                    "accountId": accRecordId,
                                });
                                updateAction.setCallback(this, function(response) {
                                    var updateState = response.getState();
                                    if (updateState === "SUCCESS") {
                                        var updatedAccountCustomerId = response.getReturnValue();
                                        if ( updatedAccountCustomerId!='' && updatedAccountCustomerId!=null && updatedAccountCustomerId!=undefined ) {
                                            component.set("{!v.hasCustomerId}",'true');
                                        }
                                        if (component.get("v.hasCustomerId")=='false'){
                                            component.set("v.isFormOpen",false);
                                            component.set("v.Accountmessage","License can't be created as the corresponding 'Customer ID' is not available in Customer Hub");
                                        }
                                        else if(component.get("v.hasCustomerId")=='true'){
                                            component.set("v.isFormOpen",true);
                                        }
                                    }
                                });
                                $A.enqueueAction(updateAction); 
                            }
                        }
                    });
                    $A.enqueueAction(ubxResponseAction); 
                }
                else if(hasCustomerId!='' || hasCustomerId!=null|| hasCustomerId!=undefined)
                {
                    component.set("{!v.hasCustomerId}",'true');
                    var accRecoordId = component.get("{!v.recordId}");
                    var ubxRespoonsAction = component.get("c.isUbxAccResponse");
                    var isUbxRspons = false;
                    ubxRespoonsAction.setParams({
                        "acountId": accRecoordId,
                    });
                    ubxRespoonsAction.setCallback(this, function(response) {
                        var ubxRespoonse = response.getState();
                        if (ubxRespoonse === "SUCCESS") {
                            isUbxRspons = response.getReturnValue();
                            if (isUbxRspons=='false') {
                                component.set("v.isFormOpen",false);
                                component.set("v.Accountmessage","License can't be created as the corresponding account is not a valid UBX customer");
                            }
                        }
                    });
                    $A.enqueueAction(ubxRespoonsAction);
                }
                
                //checking if the account is of type consortium
                if(accountRecord != null && accountRecord.Type=='Consortium'){
                    component.set("{!v.isOpen}",true);
                    component.set("{!v.isConsortium}",true);
                }
                else
                {
                    component.set("{!v.isOpen}",false); 
                    component.set("{!v.isConsortium}",false);
                }
            }
            else if(state === "ERROR") {}
        });
        $A.enqueueAction(action);
        
        //get recordtype id of T&F Individual License  
        var getRecordTypeAction = component.get("c.getRecordTypeId");        
        getRecordTypeAction.setParams({
            "objectName": 'License__c',
            "recordTypeName":'T&F Account License'
        });
        getRecordTypeAction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var recordTypeIdRecord = response.getReturnValue();          
                component.set("{!v.RecordTypeId}",recordTypeIdRecord);
            }
        });
        $A.enqueueAction(getRecordTypeAction);
        
        //Code for Managing Dual Box
        var options = [];
        var multipleOptions=[];
        var invalidOptions=[];
        var actions = component.get("c.getConsortiumMembersForAccount");
        actions.setParams({
            "CustomerId": component.get("v.recordId"),
        }); 
        component.set("v.listOptions", options);
        actions.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state == 'SUCCESS') {   
                var resultArray = response.getReturnValue()[1];
                var selectedAccount = response.getReturnValue()[2];
                var invalidmembers='';
                var invalidmembersIds='';
                var membersIds=[];
                resultArray.forEach(function(result)  { 
                    options.push({ value: result.Id, label: result.Name});
                    membersIds.push(result.Id);
                    if(result.Customer_Id__c=='' || result.Customer_Id__c==null){
                        invalidmembers=invalidmembers+result.Name+','; 
                        invalidmembersIds=invalidmembersIds+result.Id+',';
                    }
                });
                invalidmembers = invalidmembers.slice(0, -1);
                //membersIds = membersIds.slice(0, -1);
                invalidmembersIds=invalidmembersIds.slice(0,-1);
                //console.log(membersIds);
                component.set("{!v.allvalidMembers}",membersIds);             
                if(invalidmembers.length=='0'){
                    component.set("v.listInvalidOptions", "valid");
                    component.set("v.listInvalidOptionsIds","");
                }
                else 
                {
                    component.set("v.listInvalidOptions", invalidmembers); 
                    component.set("v.listInvalidOptionsIds",invalidmembersIds);
                }
                
                if(membersIds==''||membersIds==null)
                {
                    component.set("{!v.isOpen}",false); 
                }
                else if ((membersIds!=''||membersIds!=null)&& (component.get("v.isConsortium")==true))
                { 
                    component.set("{!v.isOpen}",true); 
                }
                component.set("v.listOptions", options);                                 
                //component.set("v.defaultOptions", selectedAccount);
                //display message on page layout for invalid members..
                if (component.get("{!v.listInvalidOptions}")!='valid' && component.get("v.isConsortium")==true)
                {component.set("v.message",'Members with names' + ' ' + component.get("v.listInvalidOptions") + ' ' + 'do not have customer Id!');
                }
            } else {
                console.log('Failed with state: ' + state);
            }
        });
        $A.enqueueAction(actions); 
        //End Code for Managing Dual Box
    },
    
    checkforselectoption: function(component, event, helper) {
        var changeValue = event.getParam("value");
        if(changeValue=='option2')
        {
            component.set("{!v.isSelected}",true); 
        }
        else
        {
            component.set("{!v.isSelected}",false); 
        }       
        
    },
    
    handleChange: function (component, event,helper) {
        var selectedOptionsList = event.getParam("value");
        var finalList=[];        
        var listofAllInValidMembersIds=component.get("v.listInvalidOptionsIds");    
        var ExistingInValidMembersIds=listofAllInValidMembersIds.toString().split(",");
        var selectedOptionlists= selectedOptionsList.toString().split(",");
        //alert(selectedOptionlists);
        ExistingInValidMembersIds.forEach(function(ival, index){
            selectedOptionlists.forEach(function(sval, index){
                if(ival != sval && finalList.indexOf(sval) == -1 && ExistingInValidMembersIds.includes(sval) == false){
                    //alert(ival +' != '+sval +' ' + finalList.indexOf(sval));
                    finalList.push(sval);
                    //membersIds=membersIds+sval.toString()+',';
                }
                
            });
        });
        //console.log(finalList.toString());
        // membersIds = membersIds.slice(0, -1);
        component.set("v.defaultOptions", finalList);
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