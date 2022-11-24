({
    /**
    * Search Account by Name
    **/
    SearchByNameHelper : function(component,event,helper,nextSearch,prevSearch,PageNumberSearch,offSetSearch) {
        debugger;
        offSetSearch = offSetSearch || 0;
        component.set('v.searchedAccountColumn', [
            {label: 'Requested Date', fieldName: 'Requested_Date_c', type: 'date', typeAttributes: {day: 'numeric',month: 'short',year: 'numeric',hour: '2-digit',minute: '2-digit',second: '2-digit',hour12: true}, sortable : true},
            {label: 'Requested By', fieldName: 'Request_CreatedBy_c', type: 'text', sortable : true},
            {label: 'Requested Name', fieldName: 'Request_Account_Name_c', type: 'text'},
            {label: 'Account Name', fieldName: 'Name', type: 'text', sortable : true},
            {label: 'Status', fieldName: 'Onboarding_Status_c', type: 'text'},
            {label: 'RingGold Id', fieldName: 'Ringgold_Account_ID_c', type: 'text'},
            {label: 'Customer Id', fieldName: 'Customer_Id_c', type: 'text'},
        ]);
            var action = component.get("c.fetchAccountDataByName");   
            
            var showSearchLoadSpinner = component.get('v.showSearchLoadSpinner');
            if(showSearchLoadSpinner){
            	component.set("v.onSearchLoadSpinner",true);
            }
            
            var searchKeyWord = component.get("v.searchNameKeyword");
            var startDate = component.get("v.startDate");
            var endDate = component.get("v.endDate");
            
            //If both date and name fields are empty
            if(($A.util.isEmpty(startDate) || $A.util.isUndefined(startDate)) && ($A.util.isEmpty(endDate) || $A.util.isUndefined(endDate)) && ($A.util.isEmpty(searchKeyWord) || $A.util.isUndefined(searchKeyWord))){
            	this.showToastMessage(component,event,helper,'Either Account Name or Date is required for search','Error','Error');  
                component.set("v.showSearchTable",false);
                component.set("v.showTotalRecordsApproved",false);
                
                component.set("v.noRecordsInApproedTab",true);
                var nextSearch = false;
                var prevSearch = false;
                component.set("v.PageNumberSearch", 1);
                var PageNumberSearch = component.get("v.PageNumberSearch");
                
                helper.getApprovedCustomer(component,event,helper,nextSearch,prevSearch,PageNumberSearch);
            	component.set("v.onSearchLoadSpinner",false);
                return;
            }
            
			//If search name field contains only white space
            if(!$A.util.isEmpty(searchKeyWord) && $A.util.isEmpty(startDate) && $A.util.isEmpty(endDate)){
                if(!searchKeyWord.replace(/\s/g, '').length){
                    this.showToastMessage(component,event,helper,'Either Account Name or Date is required for search','Error','Error');  
                    component.set("v.showSearchTable",false);
                    component.set("v.showTotalRecordsApproved",false);
                    
                    component.set("v.noRecordsInApproedTab",true);
                    var nextSearch = false;
                    var prevSearch = false;
                    component.set("v.PageNumberSearch", 1);
                    var PageNumberSearch = component.get("v.PageNumberSearch");
                    
                    helper.getApprovedCustomer(component,event,helper,nextSearch,prevSearch,PageNumberSearch);
                    component.set("v.onSearchLoadSpinner",false);
                    return;
                }
            }

            //If start date is not null but end date is null
            if(startDate !== null){
                if($A.util.isEmpty(endDate) || $A.util.isUndefined(endDate)){
                    this.showToastMessage(component,event,helper,'End Date is missing','Error','Error');  
                    component.set("v.showSearchTable",false);
                    component.set("v.showTotalRecordsApproved",false);
                    
                    component.set("v.noRecordsInApproedTab",true);
                    var nextSearch = false;
                    var prevSearch = false;
                    component.set("v.PageNumberSearch", 1);
                    var PageNumberSearch = component.get("v.PageNumberSearch");
                    
                    helper.getApprovedCustomer(component,event,helper,nextSearch,prevSearch,PageNumberSearch);
           			component.set("v.onSearchLoadSpinner",false);
                    return;
                }
            }
            
            //If end date is not null but start date is null
            if(endDate !== null){
                if($A.util.isEmpty(startDate) || $A.util.isUndefined(startDate)){
                    this.showToastMessage(component,event,helper,'Start Date is missing','Error','Error'); 
                    component.set("v.showSearchTable",false);
                    component.set("v.showTotalRecordsApproved",false);
                    
                    component.set("v.noRecordsInApproedTab",true);
                    var nextSearch = false;
                    var prevSearch = false;
                    component.set("v.PageNumberSearch", 1);
                    var PageNumberSearch = component.get("v.PageNumberSearch");
                    
                    helper.getApprovedCustomer(component,event,helper,nextSearch,prevSearch,PageNumberSearch);
            		component.set("v.onSearchLoadSpinner",false);
                    return;
                }
            }
            
            //If start date is greater than end date
            if(startDate !== null && endDate !== null){
                if(Date.parse(endDate) < Date.parse(startDate)){
                    this.showToastMessage(component,event,helper,'End Date cannot be less than Start Date','Error','Error');
                    component.set("v.showSearchTable",false);
                    component.set("v.showTotalRecordsApproved",false);
                    
                    component.set("v.noRecordsInApproedTab",true);
                    var nextSearch = false;
                    var prevSearch = false;
                    component.set("v.PageNumberSearch", 1);
                    var PageNumberSearch = component.get("v.PageNumberSearch");
                    
                    helper.getApprovedCustomer(component,event,helper,nextSearch,prevSearch,PageNumberSearch);
            		component.set("v.onSearchLoadSpinner",false);
                    return;
                }
            }
            action.setParams({
            "searchNameKeyword":searchKeyWord,
            "startDate":startDate,
            "endDate":endDate,
            "nextSearch" : nextSearch,
            "prevSearch" : prevSearch,
            "off" : offSetSearch,
            "PageNumberSearch" : PageNumberSearch});
            
            action.setCallback(this, function(response) {
            var state = response.getState(); 
            if(state === "SUCCESS"){
                
                var storeResponse = response.getReturnValue().ListOfAccount;
                var storeResponseAll = response.getReturnValue().totalSearch;
            
            	if(showSearchLoadSpinner){
                component.set("v.onSearchLoadSpinner",false);
                }
            
                if($A.util.isEmpty(storeResponse) || $A.util.isUndefined(storeResponse)){
                    component.set("v.showSearchTable",false);
                    component.set("v.showTotalRecordsApproved",false);
                    //component.set("v.showTotalApprovedCustomerList",false);
                    //component.set("v.showApprovedCustomerList",false);
                    
                    component.set("v.noRecordsInApproedTab",true);
                    var nextSearch = false;
                    var prevSearch = false;
                    component.set("v.PageNumberSearch", 1);
                    var PageNumberSearch = component.get("v.PageNumberSearch");
                    helper.getApprovedCustomer(component,event,helper,nextSearch,prevSearch,PageNumberSearch);
                    
                    this.showToastMessage(component,event,helper,'No Records Found with your search details...','Error','Error');
                }
                else{
                    component.set("v.showApprovedCustomerList",false);
                    component.set("v.showTotalApprovedCustomerList",false);
                    component.set("v.showTotalRecordsApproved",true);
                    component.set("v.TotalNumberOfRecordPendingAllSearch", storeResponseAll);
                    component.set("v.showSearchTable",true);             
                } 
                
                var result = response.getReturnValue(); 
                component.set("v.searchedAccountList",result.ListOfAccount);
                component.set('v.offSetSearch',result.offstSearch);
                component.set('v.nextSearch',result.hasNextSearch);
                component.set('v.prevSearch',result.hasPrevSearch);
                component.set('v.RecordStartSearch',result.RecordStartSearch);   
                component.set('v.RecordEndSearch',result.recordEnd);   
                component.set("v.TotalPagesSearch", Math.ceil(result.totalSearch / result.pageSizeSearch));
                component.set("v.PageNumberSearch", result.PageNumberSearch);
            }            
        });
        $A.enqueueAction(action);
     },
            
            
    /**
    * Get Account list in approved customer tab
    **/
       getApprovedCustomer : function(component,event,helper,nextSearch,prevSearch,PageNumberSearch,offSetSearch) {
            debugger;
            offSetSearch = offSetSearch || 0;
            component.set('v.searchedAccountColumn', [
            {label: 'Requested Date', fieldName: 'Requested_Date_c', type: 'date', typeAttributes: {day: 'numeric',month: 'short',year: 'numeric',hour: '2-digit',minute: '2-digit',second: '2-digit',hour12: true}, sortable : true},
            {label: 'Requested By', fieldName: 'Request_CreatedBy_c', type: 'text', sortable : true},
            {label: 'Requested Name', fieldName: 'Request_Account_Name_c', type: 'text'},
            {label: 'Account Name', fieldName: 'Name', type: 'text', sortable : true},
            {label: 'Status', fieldName: 'Onboarding_Status_c', type: 'text'},
            {label: 'RingGold Id', fieldName: 'Ringgold_Account_ID_c', type: 'text'},
            {label: 'Customer Id', fieldName: 'Customer_Id_c', type: 'text'},
        ]);
        var action = component.get('c.fetchAccountDataByName');
        
        var showApprovedLoadSpinner = component.get('v.showApprovedLoadSpinner');
        if(showApprovedLoadSpinner){
            component.set("v.onApprovedLoadSpinner",true);
        }
        //component.set("v.onApprovedLoadSpinner",true);
        action.setParams({
            "nextSearch" : nextSearch,
            "prevSearch" : prevSearch,
            "off" : offSetSearch,
            "PageNumberSearch" : PageNumberSearch});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                var storeResponse = response.getReturnValue().ListOfAccount;
                var storeResponseAll = response.getReturnValue().totalSearch;
                
                if(showApprovedLoadSpinner){
                    component.set("v.onApprovedLoadSpinner",false);
                }
                
                if($A.util.isEmpty(storeResponse) || $A.util.isUndefined(storeResponse)){
                    component.set("v.showApprovedCustomerList",false);
                    component.set("v.showTotalApprovedCustomerList",false);
                    component.set("v.messageNoRecordsApproved",true);
                    //this.showToastMessage(component,event,helper,'No Records Found...','Error','Error');                   
                }
                else{
                    component.set("v.showTotalApprovedCustomerList",true);
                    component.set("v.TotalNumberOfRecordPendingAllSearch", storeResponseAll);
                    component.set("v.showApprovedCustomerList",true);             
                } 
                
                var result = response.getReturnValue(); 
                component.set("v.ApprovedCustomerList",result.ListOfAccount);
                component.set('v.offSetSearch',result.offstSearch);
                component.set('v.nextSearch',result.hasNextSearch);
                component.set('v.prevSearch',result.hasPrevSearch);
                component.set('v.RecordStartSearch',result.RecordStartSearch);   
                component.set('v.RecordEndSearch',result.recordEnd);   
                component.set("v.TotalPagesSearch", Math.ceil(result.totalSearch / result.pageSizeSearch));
                component.set("v.PageNumberSearch", result.PageNumberSearch);
            	
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " +errors[0].message);
                    }
                } else {
                    alert("Unknown error");
                }
            }            
        });
        $A.enqueueAction(action);
    },
    
    /**
    * Show Toast Messages
    **/
    showToastMessage:function(component,event,helper,message,title,type){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title,
            message:message,
            messageTemplate: 'Mode is pester ,duration is 2sec and Message is overrriden',
            duration:'50',
            key: 'info_alt',
            type: type,
            mode: 'Timed'
        });
        toastEvent.fire();
    },
    
    /**
    * Create or update account in Salesforce
    **/
    createAccountRecord : function(component, event, helper) { 
        var Account = component.get("v.Account"); 
        var ListForIP = component.get("v.ListForIP");
        var ListForContact = component.get("v.ListForContact");
        var EndUserRemoteAccess = component.get("v.EndUserRemoteAccess");
        var BillingAddLine1 = component.get("v.BillingAddLine1");
        var BillingAddLine2 = component.get("v.BillingAddLine2");
        var MailingAddLine1 = component.get("v.MailingAddLine1");
        var MailingAddLine2 = component.get("v.MailingAddLine2");
        var ShippingAddLine1 = component.get("v.ShippingAddLine1");
        var ShippingAddLine2 = component.get("v.ShippingAddLine2");
        var updateOrInsert = component.get("v.updateOrInsert"); 
        var NewListForContact = component.get("v.NewListForContact");
        var NewEndUserRemoteAccessSet = component.get("v.NewEndUserRemoteAccessSet");
        var NewListForIPSet = component.get("v.NewListForIPSet");
        var mailingStateNoneUpdate = component.get("v.mailingStateNoneUpdate");
        var mailingCountryNotUpdate = component.get("v.mailingCountryNotUpdate");
        var shippingStateNoneUpdate = component.get("v.shippingStateNoneUpdate");
        var shippingCountryNotUpdate = component.get("v.shippingCountryNotUpdate");
        var billingStateNoneUpdate = component.get("v.billingStateNoneUpdate");
        var billingCountryNotUpdate = component.get("v.billingCountryNotUpdate");
        var verifyAddresses = component.get("v.verifyAddresses");
        var RequestNotes = component.get("v.RequestNotes");
       
        //If required fields are missing in organization details tab 
        if(($A.util.isEmpty(Account.Mailing_Country_List__c) || $A.util.isUndefinedOrNull(Account.Mailing_Country_List__c)) || ($A.util.isEmpty(MailingAddLine1) || $A.util.isUndefinedOrNull(MailingAddLine1)) || ($A.util.isEmpty(Account.Name) || $A.util.isUndefinedOrNull(Account.Name)) || ($A.util.isEmpty(Account.BillingCity) || $A.util.isUndefinedOrNull(Account.BillingCity)) || ($A.util.isEmpty(Account.BillingPostalCode) || $A.util.isUndefinedOrNull(Account.BillingPostalCode))){
            component.find('MailingAddLine1').showHelpMessageIfInvalid();
            component.find('Name').showHelpMessageIfInvalid();
            component.find('BillingCity').showHelpMessageIfInvalid();
            component.find('BillingPostalCode').showHelpMessageIfInvalid();
            
            /*var mailingCountry = component.find('mailingCountry')
			mailingCountry.setCustomValidity("Country is required.");
            mailingCountry.reportValidity();*/
            
            helper.showToastMessage(component,event,helper,'Required field is missing','Error','Error');
            component.set("v.selTabId" , '1');
            return;
        }
        
        //If required fields contains only space in organization details tab    
        if (!MailingAddLine1.replace(/\s/g, '').length || !Account.Name.replace(/\s/g, '').length || !Account.BillingCity.replace(/\s/g, '').length || !Account.BillingPostalCode.replace(/\s/g, '').length) {
            helper.showToastMessage(component,event,helper,'Required field is missing','Error','Error');
            component.set("v.selTabId" , '1');
            return;
        } 
        
        //Check Account's website is valid or not, if present    
        if(!$A.util.isEmpty(Account.Website)){   
            var websiteField = component.find("websiteValidate");
            var websiteFieldValue = component.get("v.Account.Website");
            var res = websiteFieldValue.match(/^((https?|ftp|smtp):\/\/)?(www.)?[a-z0-9]+(\.[a-z]{2,}){1,3}(#?\/?[a-zA-Z0-9#]+)*\/?(\?[a-zA-Z0-9-_]+=[a-zA-Z0-9-%]+&?)?$/);
            if(res === null){
                this.showToastMessage(component,event,helper,'Website is invalid','Error','Error');
                websiteField.setCustomValidity("Website is invalid");
                websiteField.reportValidity();
                component.set("v.selTabId" , '1');
                return;
            }
        }
        
        //Check Account's phone number is valid or not, if present    
        if(!$A.util.isEmpty(Account.Phone)){   
            var phone = component.find("phone");
            var phoneFieldValue = component.get("v.Account.Phone");
            var res = phoneFieldValue.match(/^(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:\(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?$/);
            if(res === null){
                this.showToastMessage(component,event,helper,'Account phone number is invalid','Error','Error');
                phone.setCustomValidity("Please enter a 10 digit number from 0-9.");
                phone.reportValidity();
                component.set("v.selTabId" , '1');
                return;
            }
        }
       
        //If Shipping address line 2 is not null but Shipping address line 1 is null
        /*if(!$A.util.isEmpty(ShippingAddLine2)){
            if($A.util.isEmpty(ShippingAddLine1) || $A.util.isUndefined(ShippingAddLine1)){
                component.set("v.selTabId" , '2');
                this.showToastMessage(component,event,helper,'Fill Shipping Address line 1','Error','Error');  
                var ShippingAddLine1 = component.find("ShippingAddLine1");
                ShippingAddLine1.setCustomValidity("Fill Shipping Address line 1");
                ShippingAddLine1.reportValidity();
                return;
            }
        }*/
        if(!$A.util.isEmpty(ShippingAddLine2)){
            if(ShippingAddLine2.replace(/\s/g, '').length){
                if($A.util.isUndefined(ShippingAddLine1)){
                    component.set("v.selTabId" , '2');
                    this.showToastMessage(component,event,helper,'Fill Shipping Address line 1','Error','Error');  
                    var ShippingAddLine1 = component.find("ShippingAddLine1");
                    ShippingAddLine1.setCustomValidity("Fill Shipping Address line 1");
                    ShippingAddLine1.reportValidity();
                    return;
                }
                else{
                    if(!ShippingAddLine1.replace(/\s/g, '').length){
                        component.set("v.selTabId" , '2');
                        this.showToastMessage(component,event,helper,'Fill Shipping Address line 1','Error','Error');  
                        var ShippingAddLine1 = component.find("ShippingAddLine1");
                        ShippingAddLine1.setCustomValidity("Fill Shipping Address line 1");
                        ShippingAddLine1.reportValidity();
                        return;
                    }
                }
            }
        }
        
        
        
        //If Billing address line 2 is not null but Billing address line 1 is null
        /*if(!$A.util.isEmpty(BillingAddLine2)){
            if($A.util.isEmpty(BillingAddLine1) || $A.util.isUndefined(BillingAddLine1)){
                this.showToastMessage(component,event,helper,'Fill Billing Address line 1','Error','Error');  
                component.set("v.selTabId" , '2');
                return;
            }
        }*/
        if(!$A.util.isEmpty(BillingAddLine2)){
            if(BillingAddLine2.replace(/\s/g, '').length){
                if($A.util.isUndefined(BillingAddLine1)){
                    component.set("v.selTabId" , '2');
                    this.showToastMessage(component,event,helper,'Fill Billing Address line 1','Error','Error');  
                    var BillingAddLine1 = component.find("BillingAddLine1");
                    BillingAddLine1.setCustomValidity("Fill Billing Address line 1");
                    BillingAddLine1.reportValidity();
                    return;
                }
                else{
                    if(!BillingAddLine1.replace(/\s/g, '').length){
                        component.set("v.selTabId" , '2');
                        this.showToastMessage(component,event,helper,'Fill Billing Address line 1','Error','Error');  
                        var BillingAddLine1 = component.find("BillingAddLine1");
                        BillingAddLine1.setCustomValidity("Fill Billing Address line 1");
                        BillingAddLine1.reportValidity();
                        return;
                    }
                }
            }
        }
        
        
        //If id field is not null but value of entity is null for remote access in profile data tab  
        if(!$A.util.isEmpty(EndUserRemoteAccess[0].Id__c)){
            if(EndUserRemoteAccess[0].Entity_ID__c === ''){
                EndUserRemoteAccess.splice(0, 1);
                component.set("v.EndUserRemoteAccess", EndUserRemoteAccess);
            }
        } 
        
        //If id field is not null but value of description, ip list and type fields are null for ip ranges in profile data tab in edit case 
        for(var i = 0; i < ListForIP.length; i++){
            if(!$A.util.isEmpty(ListForIP[i].Id__c)){
                if($A.util.isEmpty(ListForIP[i].Description__c) && $A.util.isEmpty(ListForIP[i].IP_Range__c) && $A.util.isEmpty(ListForIP[i].Type__c)){
                    ListForIP.splice(i, 1);
                    component.set("v.ListForIP", ListForIP);
                }
            }
        }
        
		debugger;        
        //IP range validation
        for(var i = 0; i < ListForIP.length; i++){
            if(!$A.util.isEmpty(ListForIP[i].IP_Range__c)){
                if(ListForIP[i].IP_Range__c.replace(/\s/g, '').length){
                    
                    if( ListForIP[i].IP_Range__c.includes(':')){
                        var IPList=[];
                        IPList = ListForIP[i].IP_Range__c.split(':');
                        for(j in IPList){
                            IPList[j];
                            var ipRes = IPList[j].match(/^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/);
                            
                            if(ipRes === null || IPList[1]<IPList[0]){
                                this.showToastMessage(component,event,helper,'IP is invalid','Error','Error');
                                component.set("v.selTabId" , '3');
                                return;
                            } 
                        }
                    }
                    else{
                        var ipRes = ListForIP[i].IP_Range__c.match(/^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/);
                        
                        if(ipRes === null){
                            this.showToastMessage(component,event,helper,'IP is invalid','Error','Error');
                            component.set("v.selTabId" , '3');
                            return;
                        } 
                    }                    
                   
                }
            }
        }
        
        //If Name is missing in contact list    
        for(var i = 0; i < ListForContact.length; i++){
            if(JSON.stringify(ListForContact[i].LastName) === '""'){
                this.showToastMessage(component,event,helper,'Contact Name is missing','Error','Error');
                return;
            }
            if(!$A.util.isEmpty(JSON.stringify(ListForContact[i].LastName))){
                if(!ListForContact[i].LastName.replace(/\s/g, '').length){ 
                    this.showToastMessage(component,event,helper,'Contact Name is missing','Error','Error');
                    return;
                }
            }
            if(JSON.stringify(ListForContact[i].Email) === undefined || JSON.stringify(ListForContact[i].Email) === '""'){
                this.showToastMessage(component,event,helper,'Contact Email is missing','Error','Error');
                return;
            }
        }
        
        //If email of two contacts are same then through eror
        for(var i = 0; i < ListForContact.length; i++){
            for(var j = i+1; j < ListForContact.length; j++){
                if(JSON.stringify(ListForContact[i].Email) === JSON.stringify(ListForContact[j].Email) ){
                    this.showToastMessage(component,event,helper,'Email of two Contacts cannot be same','Error','Error');
                    return;
                }
            }
        }
            
        //Email validation on Contact in authorised user information tab
      	for(var i = 0; i < ListForContact.length; i++){
            var contactEmailFields = component.find("formFieldToValidate");
            // Initialize the counter to zero - used to check validity of fields
            var blankVar=0;
            // If there are more than 1 fields
            if(contactEmailFields.length!=undefined) {
                // Iterating all the fields
                var allValidImp = contactEmailFields.reduce(function (validSoFar, inputCmp) {
                    // Show help message if single field is invalid
                    inputCmp.showHelpMessageIfInvalid();
                    // return whether all fields are valid or not
                    return validSoFar && inputCmp.get('v.validity').valid;
                }, true);
                // If all fields are not valid increment the counter
                if (!allValidImp) {
                    blankVar++;
                    this.showToastMessage(component,event,helper,'Contact email is invalid.','Error','Error');
                    return;
                }
            } else {
                // If there is only one field, get that field and check for validity (true/false)
                var allValidImp = contactEmailFields;
                // If field is not valid, increment the counter
                if (!allValidImp.get('v.validity').valid) {
                    blankVar++;
                    this.showToastMessage(component,event,helper,'Contact email is invalid.','Error','Error');
                    return;
                }
            }
        }
        
        for(var i = 0; i < ListForContact.length; i++){
            //var inputCmp = ListForContact[i].Phone.trim();
            var contactFields = component.find("fieldToValidate");
            // Initialize the counter to zero - used to check validity of fields
            var blank=0;
            // If there are more than 1 fields
            if(contactFields.length!=undefined) {
                // Iterating all the fields
                var allValid = contactFields.reduce(function (validSoFar, inputCmp) {
                    // Show help message if single field is invalid
                    inputCmp.showHelpMessageIfInvalid();
                    // return whether all fields are valid or not
                    return validSoFar && inputCmp.get('v.validity').valid;
                }, true);
                // If all fields are not valid increment the counter
                if (!allValid) {
                    blank++;
                    this.showToastMessage(component,event,helper,'Contact phone number is invalid. Please enter the 10 digit number from 0-9.','Error','Error');
                    return;
                }
            } else {
                // If there is only one field, get that field and check for validity (true/false)
                var allValid = contactFields;
                // If field is not valid, increment the counter
                if (!allValid.get('v.validity').valid) {
                    blank++;
                    this.showToastMessage(component,event,helper,'Contact phone number is invalid. Please enter the 10 digit number from 0-9.','Error','Error');
                    return;
                }
            }
        }
        
        //Check Contact's phone number is valid or not, if present   
        /*for(var i = 0; i < ListForContact.length; i++){
            if(updateOrInsert === 'NewCustomer'){
                if(JSON.stringify(ListForContact[i].Phone) !== '""' && !$A.util.isEmpty(JSON.stringify(ListForContact[i].Phone))){
                    var contactPhoneFieldValue = ListForContact[i].Phone;
                    var resPhone = contactPhoneFieldValue.match(/^(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:\(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?$/);
                    if(resPhone === null){
                        this.showToastMessage(component,event,helper,'Contact phone number is invalid. Please enter a 10 digit number from 0-9.','Error','Error');
                        return;
                    }
                }
            }
            
            if(updateOrInsert === 'updateCustomer'){
                if(JSON.stringify(ListForContact[i].Phone) !==  ' '){
                    if(!$A.util.isEmpty(JSON.stringify(ListForContact[i].Phone)) !== false){
                        if(JSON.stringify(ListForContact[i].Phone) !== '""'){
                            var contactPhoneFieldValue = ListForContact[i].Phone;
                            var phoneRes = contactPhoneFieldValue.match(/^(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:\(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?$/);
                            if(phoneRes === null){
                                this.showToastMessage(component,event,helper,'Contact phone number is invalid. Please enter a 10 digit number from 0-9.','Error','Error');
                                return;
                            }
                        }
                    }
                }
            }
            
        }*/
        
        var mylabel= event.getSource().get("v.label");
        if(mylabel === 'Save'){
            Account.Onboarding_Status__c = 'Draft';
            var action = component.get('c.createAccount');
            action.setParams({"Account" : Account, "verifyAddresses" : verifyAddresses, "shippingStateNoneUpdate" : shippingStateNoneUpdate, "shippingCountryNotUpdate" : shippingCountryNotUpdate, "billingStateNoneUpdate" : billingStateNoneUpdate, "billingCountryNotUpdate" : billingCountryNotUpdate, "mailingCountryNotUpdate" : mailingCountryNotUpdate, "mailingStateNoneUpdate" : mailingStateNoneUpdate, "NewEndUserRemoteAccessSet" : NewEndUserRemoteAccessSet, "NewListForIPSet" : NewListForIPSet, "NewListForContact" : NewListForContact, "updateOrInsert" : updateOrInsert, "ListForContact" : ListForContact, "ListForIP" : ListForIP, "EndUserRemoteAccess" : EndUserRemoteAccess, "BillingAddLine1" : BillingAddLine1, "BillingAddLine2" : BillingAddLine2, "MailingAddLine1" : MailingAddLine1, "MailingAddLine2" : MailingAddLine2, "ShippingAddLine1" : ShippingAddLine1, "ShippingAddLine2" : ShippingAddLine2,"RequestNotes": RequestNotes }); 
        }
        if(mylabel === 'Submit For Approval'){
            Account.Onboarding_Status__c = 'Submitted for Approval';
            
            //If onboarding status is "Submitted for Approval" then set verifyAddresses attribute as verifying so, we will able to verify account request's addresses in apex
            component.set("v.verifyAddresses" , 'verifying');  
            var verifyAddressesInfo = component.get("v.verifyAddresses");
            
            var action = component.get('c.createAccount');
            action.setParams({"Account" : Account, "verifyAddressesInfo" : verifyAddressesInfo, "shippingStateNoneUpdate" : shippingStateNoneUpdate, "shippingCountryNotUpdate" : shippingCountryNotUpdate, "billingStateNoneUpdate" : billingStateNoneUpdate, "billingCountryNotUpdate" : billingCountryNotUpdate, "mailingCountryNotUpdate" : mailingCountryNotUpdate, "mailingStateNoneUpdate" : mailingStateNoneUpdate, "NewEndUserRemoteAccessSet" : NewEndUserRemoteAccessSet, "NewListForIPSet" : NewListForIPSet, "NewListForContact" : NewListForContact, "updateOrInsert" : updateOrInsert, "ListForContact" : ListForContact, "ListForIP" : ListForIP, "EndUserRemoteAccess" : EndUserRemoteAccess, "BillingAddLine1" : BillingAddLine1, "BillingAddLine2" : BillingAddLine2, "MailingAddLine1" : MailingAddLine1, "MailingAddLine2" : MailingAddLine2, "ShippingAddLine1" : ShippingAddLine1, "ShippingAddLine2" : ShippingAddLine2,"RequestNotes": RequestNotes}); 
        }  
        
        component.set("v.Spinner",true);
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){   
                component.set("v.Spinner",false);
                
                //If errorStringSet is not empty then set account status as "Draft" and show error message
                var errorStringSet = response.getReturnValue();
                
                for(var i = 0; i < errorStringSet.length; i++){
                    if(!$A.util.isEmpty(errorStringSet[i]) !=''){
                        
                        component.set("v.addressInvalidMessage", true);
                        var addressInvalidMessage = component.get("v.addressInvalidMessage");
                        
                        component.set("v.mailingAddressError" , errorStringSet[0]);
                        var mailingAddressError = component.get("v.mailingAddressError");
                        if(!$A.util.isEmpty(mailingAddressError)){
                            component.set("v.showMailingAddressError" , true);
                        }
                        
                        component.set("v.shippingAddressError" , errorStringSet[1]);
                        var shippingAddressError = component.get("v.shippingAddressError");
                        if(!$A.util.isEmpty(shippingAddressError)){
                            component.set("v.showShippingAddressError" , true);
                        }
                        
                        component.set("v.billingAddressError" , errorStringSet[2]);
                        var billingAddressError = component.get("v.billingAddressError");
                        if(!$A.util.isEmpty(billingAddressError)){
                            component.set("v.showBillingAddressError" , true);
                        }
                    }
                }
                
                
                //If value of updateOrInsert attribute is NewCustomer that means account is created successfully
                if(updateOrInsert === 'NewCustomer'){
                    //helper.showToastMessage(component,event,helper,'Account Created Successfully','Success','Success');
                    component.set("v.AccountRequestPage",false);
                    component.set("v.cancelButtonOnEdit",false);
                    component.set("v.ThankYouPage",true);
                    if(addressInvalidMessage !== true){
                        component.set("v.showAccCreatedMessage",true);
                        helper.showToastMessage(component,event,helper,'Account Created Successfully','Success','Success');
                    }
                }
                
                //If value of updateOrInsert attribute is updateCustomer that means account is updated successfully
                if(updateOrInsert === 'updateCustomer'){
                    //helper.showToastMessage(component,event,helper,'Account Updated Successfully','Success','Success');
                    component.set("v.AccountRequestPage",false);
                    component.set("v.cancelButtonOnEdit",false);
                    component.set("v.ThankYouUpdatePage",true);
                    if(addressInvalidMessage !== true){
                        component.set("v.showAccUpdatedMessage",true);
                        helper.showToastMessage(component,event,helper,'Account Updated Successfully','Success','Success');
                    }
                }
            } else if(state == "ERROR"){
                component.set("v.Spinner",false);
                helper.showToastMessage(component,event,helper,'Error in calling server side action','Error','Error');
            }
        });     
        $A.enqueueAction(action);        
    },
    
    /**
    * Add row of IP ranges in profile data tab 
    **/    
    addEndUserRecord: function(component, event) {  
        var ListForIP = component.get("v.ListForIP");
        //Add new End_User_Access__c record for IP ranges
        ListForIP.push({
            'sobjectType': 'End_User_Access__c',
            'Description__c': '',
            'IP_Range__c': '',
            'Type__c': ''
        });
        component.set("v.ListForIP", ListForIP);
    },
    
    /**
    * Add row of remote access in profile data tab 
    **/    
    addEndUserRemoteRecord: function(component, event) {  
        var EndUserRemoteAccess = component.get("v.EndUserRemoteAccess");
        //Add new End_User_Access__c record of remote access
        EndUserRemoteAccess.push({
            'sobjectType': 'End_User_Access__c',
            'Entity_ID__c': ''
            
        });
        component.set("v.EndUserRemoteAccess", EndUserRemoteAccess);
    },    
    
    /**
    * Method gets called by onsort action for pending Request tab 
    **/        
    sortData : function(component,fieldName,sortDirection){
        var data = component.get("v.pandingReqAcctList");
        //function to return the value stored in the field
        var key = function(a) { return a[fieldName]; }
        var reverse = sortDirection == 'asc' ? 1: -1;
        
        // to handel number/currency type fields 
        if(fieldName == 'NumberOfEmployees'){ 
            data.sort(function(a,b){
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a>b) - (b>a));
            }); 
        }
        else{// to handel text type fields 
            data.sort(function(a,b){ 
                var a = key(a) ? key(a).toLowerCase() : '';//To handle null values , uppercase records during sorting
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a>b) - (b>a));
            });    
        }
        component.set("v.pandingReqAcctList",data);
    },
    
    /**
    * Method gets called by onsort action for approved customer tab in search case
    **/        
    sortApprovedCustomer : function(component,fieldName,sortDirection){
        var data = component.get("v.searchedAccountList");
        //function to return the value stored in the field
        var key = function(a) { return a[fieldName]; }
        var reverse = sortDirection == 'asc' ? 1: -1;
        
        // to handel number/currency type fields 
        if(fieldName == 'NumberOfEmployees'){ 
            data.sort(function(a,b){
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a>b) - (b>a));
            }); 
        }
        else{// to handel text type fields 
            data.sort(function(a,b){ 
                var a = key(a) ? key(a).toLowerCase() : '';//To handle null values , uppercase records during sorting
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a>b) - (b>a));
            });    
        }
        component.set("v.searchedAccountList",data);
    },
    
    /**
    * Method gets called by onsort action for approved customer tab 
    **/        
    sortApprovedCustomerOnLoad : function(component,fieldName,sortDirection){
        var data = component.get("v.ApprovedCustomerList");
        //function to return the value stored in the field
        var key = function(a) { return a[fieldName]; }
        var reverse = sortDirection == 'asc' ? 1: -1;
        
        // to handel number/currency type fields 
        if(fieldName == 'NumberOfEmployees'){ 
            data.sort(function(a,b){
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a>b) - (b>a));
            }); 
        }
        else{// to handel text type fields 
            data.sort(function(a,b){ 
                var a = key(a) ? key(a).toLowerCase() : '';//To handle null values , uppercase records during sorting
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a>b) - (b>a));
            });    
        }
        component.set("v.ApprovedCustomerList",data);
    },
    
    /**
    * Get list of Account in pending request tab
    **/
    getPendingRequestList: function(component,next,prev,pageNumber,offset) {
        debugger;
        offset = offset || 0;
        var actions = [
            { label: 'Edit', name: 'Edit' },
            { label: 'Delete', name: 'Delete' },
        ]
            
            component.set('v.pendingRequestTabColumn', [
            {type: "button", typeAttributes: {
                label: 'Edit',
                name: 'Edit',
                title: 'Edit',
                disabled: false,
                value: 'Edit',
                variant: 'base'
            }},
            {type: "button", typeAttributes: {
                label: 'Delete',
                name: 'Delete',
                title: 'Delete',
                disabled: false,
                value: 'Delete',
            	variant: 'base'
            }},
            {label: 'Account Name', fieldName: 'Name', type: 'text', sortable : true},
            {label: 'Status', fieldName: 'Onboarding_Status__c', type: 'text', sortable : true},
            {label: 'Country', fieldName: 'Mailing_Country_List__c', type: 'text'},
            {label: 'State', fieldName: 'Mailing_State_List__c', type: 'text'},
            /*{ type: 'action', typeAttributes: { rowActions: actions } }*/
            
        ])
        var action = component.get('c.getAccount');
        
        var showPendingLoadSpinner = component.get('v.showPendingLoadSpinner');
        if(showPendingLoadSpinner){
            component.set("v.onPendingLoadSpinner",true);
        }
        
        action.setParams({
            "next" : next,
            "prev" : prev,
            "off" : offset,
            "pageNumber" : pageNumber
        })
        
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS") { 
                var storeResponse = response.getReturnValue().pandingReqAcctList;
                var storeResponseAll = response.getReturnValue().total;  
                
                if(showPendingLoadSpinner){
                    component.set("v.onPendingLoadSpinner",false);
                }
                
                if($A.util.isEmpty(storeResponse) || $A.util.isUndefined(storeResponse)){
                    component.set("v.showPendingRequestTable",false);
                    component.set("v.showTotalRecordsPending",false);
                    component.set("v.Message", true);                    
                }
                else{
                    component.set("v.showPendingRequestTable",true);
                    //component.set("v.TotalNumberOfRecordPending", storeResponse.length); //Set total number of records on current page
                    component.set("v.TotalNumberOfRecordPendingAll", storeResponseAll);  //Set total number of records
                    component.set("v.Message", false);
                }
                var result=response.getReturnValue(); 
                component.set('v.offset',result.offst);
                component.set('v.next',result.hasnext);
                component.set('v.prev',result.hasprev);
                component.set('v.pandingReqAcctList', result.pandingReqAcctList);
                component.set('v.RecordStart',result.recordStart);   
                component.set('v.RecordEnd',result.recordEnd);   
                component.set("v.TotalPages", Math.ceil(result.total / result.pagesize));
                component.set("v.PageNumber", result.pageNumber);
            }
        });
        $A.enqueueAction(action);
    },
    
    /**
    * Add row of contact in authorised user information tab
    **/    
    addContactRecord: function(component, event) {  
        var ListForContact = component.get("v.ListForContact");
        //Add new Contact record 
        ListForContact.push({
            'sobjectType': 'Contact',
            'LastName': '',
            'Title': '',
            'Email': '',
            'Phone': '',
            'Functional_Role__c': ''
        });
        component.set("v.ListForContact", ListForContact);
    },
    
    /**
    * Get mailing picklist values on load
    **/
    fetchMailingPicklistValues: function(component, Account, controllerField, dependentField) {
        var action = component.get("c.getMailingDependentMap");
        action.setParams({
            'Account' : Account,
            'contrfieldApiName': controllerField,
            'depfieldApiName': dependentField 
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                //store the return response from server (map<string,List<string>>)  
                var StoreResponse = response.getReturnValue();
                
                component.set("v.mailingDepnedentFieldMap",StoreResponse);
                
                // create a empty array for store map keys(which is controller picklist values) 
                var listOfkeys = []; // for store all map keys (controller picklist values)
                var ControllerField = []; // for store controller picklist value to set on lightning:select. 
                
                // play a for loop on Return map 
                // and fill the all map key on listOfkeys variable.
                for (var singlekey in StoreResponse) {
                    listOfkeys.push(singlekey);
                }
                
                //set the controller field value for lightning:select
                if (listOfkeys != undefined && listOfkeys.length > 0) {
                    ControllerField.push('--- None ---');
                }
                
                for (var i = 0; i < listOfkeys.length; i++) {
                    ControllerField.push(listOfkeys[i]);
                }  
                // set the ControllerField variable values to country(controller picklist field)
             var countryvalue=   component.set("v.mailingListControllingValues", ControllerField);
                console.log("countryvalue",countryvalue);
            }else{
                //alert('Something went wrong..');
            }
        });
        $A.enqueueAction(action);
    },
    
    /**
    * Get mailing status picklist options on change
    **/
    fetchDepValues: function(component, ListOfDependentFields) {
        // create a empty array var for store dependent picklist values for controller field  
        var dependentFields = [];
        dependentFields.push('--- None ---');
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push(ListOfDependentFields[i]);
        }
        component.set("v.mailingListDependingValues", dependentFields);
    },
    
    /**
    * Get shipping picklist values on load
    **/
    fetchShippingPicklistValues: function(component, Account, controllerField, dependentField) {
        var action = component.get("c.getShippingDependentMap");
        action.setParams({
            'Account' : Account,
            'contrfieldApiName': controllerField,
            'depfieldApiName': dependentField 
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                //store the return response from server (map<string,List<string>>)  
                var StoreResponse = response.getReturnValue();
                component.set("v.shippingDepnedentFieldMap",StoreResponse);
                
                // create a empty array for store map keys(which is controller picklist values) 
                var listOfkeys = []; // for store all map keys (controller picklist values)
                var ControllerField = []; // for store controller picklist value to set on lightning:select. 
                
                // play a for loop on Return map 
                // and fill the all map key on listOfkeys variable.
                for (var singlekey in StoreResponse) {
                    listOfkeys.push(singlekey);
                }
                
                //set the controller field value for lightning:select
                if (listOfkeys != undefined && listOfkeys.length > 0) {
                    ControllerField.push('--- None ---');
                }
                
                for (var i = 0; i < listOfkeys.length; i++) {
                    ControllerField.push(listOfkeys[i]);
                }  
                // set the ControllerField variable values to country(controller picklist field)
                component.set("v.shippingListControllingValues", ControllerField);
            }else{
                //alert('Something went wrong..');
            }
        });
        $A.enqueueAction(action);
    },
    
    /**
    * Get mailing status picklist options on change
    **/
    fetchShippingDepValues: function(component, ListOfDependentFields) {
        // create a empty array var for store dependent picklist values for controller field  
        var dependentFields = [];
        dependentFields.push('--- None ---');
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push(ListOfDependentFields[i]);
        }
        // set the dependentFields variable values to store(dependent picklist field) on lightning:select
        component.set("v.shippingListDependingValues", dependentFields);
    },
    
    /**
    * Get billing picklist values on load
    **/
    fetchBillingPicklistValues: function(component, Account, controllerField, dependentField) {
        var action = component.get("c.getBillingDependentMap");
        action.setParams({
            'Account' : Account,
            'contrfieldApiName': controllerField,
            'depfieldApiName': dependentField 
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                //store the return response from server (map<string,List<string>>)  
                var StoreResponse = response.getReturnValue();
                component.set("v.billingDepnedentFieldMap",StoreResponse);
                
                // create a empty array for store map keys(which is controller picklist values) 
                var listOfkeys = []; // for store all map keys (controller picklist values)
                var ControllerField = []; // for store controller picklist value to set on lightning:select. 
                
                // play a for loop on Return map 
                // and fill the all map key on listOfkeys variable.
                for (var singlekey in StoreResponse) {
                    listOfkeys.push(singlekey);
                }
                
                //set the controller field value for lightning:select
                if (listOfkeys != undefined && listOfkeys.length > 0) {
                    ControllerField.push('--- None ---');
                }
                
                for (var i = 0; i < listOfkeys.length; i++) {
                    ControllerField.push(listOfkeys[i]);
                }  
                // set the ControllerField variable values to country(controller picklist field)
                component.set("v.billingListControllingValues", ControllerField);
            }else{
                //alert('Something went wrong..');
            }
        });
        $A.enqueueAction(action);
    },
    
    /**
    * Get mailing status picklist options on change
    **/
    fetchBillingDepValues: function(component, ListOfDependentFields) {
        // create a empty array var for store dependent picklist values for controller field  
        var dependentFields = [];
        dependentFields.push('--- None ---');
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push(ListOfDependentFields[i]);
        }
        // set the dependentFields variable values to store(dependent picklist field) on lightning:select
        component.set("v.billingListDependingValues", dependentFields);
    },
    
    /**
    * Delete account request record on delete button in pending request tab
    **/
    deleteRecord : function(component, event, helper) {
        var next = false;
        var prev = false;
        var pageNumber = component.get("v.PageNumber");
        var offset;
        
        var action = event.getParam('action');
        var row = event.getParam('row');
        
        var action = component.get("c.deleteAccount");
        action.setParams({
            "acc": row
        });
        component.set("v.deleteSpinner",true);
        action.setCallback(this, function(response) {
            debugger;
            var state = response.getState();
            if (state === "SUCCESS" ) {
                location.reload(true);
            } 
        });
        $A.enqueueAction(action);
    },
    checkPostalCodeReq:function(component, event, helper) {
        
        var thisCountry = event.getSource().get("v.value");;
        var action= component.get("c.checkIfPostalCodeReq");  
        action.setParams({  
            "country" : thisCountry
        });
        action.setCallback(this, function(result){
            if ( result.getReturnValue() != null) 
            {
                component.set("v.reqPostalCode",result.getReturnValue());
            }
        });
        $A.enqueueAction(action);   
        
    }
    
})