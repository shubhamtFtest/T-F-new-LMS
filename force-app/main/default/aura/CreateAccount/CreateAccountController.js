({
    
    doInit: function(component, event, helper) { 
    /**
    * Get current User details
    **/        
        var action = component.get("c.fetchUser");
        component.set("v.onLoadSpinner",true);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.onLoadSpinner",false);
                var val12 = component.get("v.onLoadSpinner");
                var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
            }
        });
        $A.enqueueAction(action);        
    
    /**
    * Get role picklist value
    **/        
        /*var action = component.get("c.getRoleList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var ContactRoleMap = [];
                for(var key in result){
                    ContactRoleMap.push({key: key, value: result[key]});
                }
                component.set("v.ContactRoleMap", ContactRoleMap);
            }
        });
        $A.enqueueAction(action);*/
        
    /**
    * Get type picklist value
    **/        
        var action = component.get("c.getTypeList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var TypeMap = [];
                for(var key in result){
                    TypeMap.push({key: key, value: result[key]});
                }
                component.set("v.TypeMap", TypeMap);
            }
        });
        $A.enqueueAction(action);
        
    /**
    * Get list of Account in pending request tab
    **/      
        var next = false;
        var prev = false;
        var pageNumber = component.get("v.PageNumber");
        helper.getPendingRequestList(component,next,prev,pageNumber);
        
    /**
    * Create a Default RowItem [IP Ranges Instance] on first time Component Load, in Profile Data tab
    **/ 
        helper.addEndUserRecord(component, event);
        
    /**
    * Create a Default RowItem [Contact Instance] on first time Component Load, in authorised user information tab
    **/ 
        helper.addContactRecord(component, event);
    
    /**
    * Create a Default RowItem [Remote Access Instance] on first time Component Load, in profile data tab
    **/
         helper.addEndUserRemoteRecord(component, event);
        
    /**
    * Get the mailing country and status fields API name and pass it to helper function
    **/    
        var mailingControllingFieldAPI = component.get("v.mailingControllingFieldAPI");
        var mailingDependingFieldAPI = component.get("v.mailingDependingFieldAPI");
        var Account = component.get("v.Account");
        helper.fetchMailingPicklistValues(component,Account,mailingControllingFieldAPI, mailingDependingFieldAPI);
    
    /**
    * Get the shipping country and status fields API name and pass it to helper function
    **/
        var shippingControllingFieldAPI = component.get("v.shippingControllingFieldAPI");
        var shippingDependingFieldAPI = component.get("v.shippingDependingFieldAPI");
        var Account = component.get("v.Account");
        helper.fetchShippingPicklistValues(component,Account,shippingControllingFieldAPI, shippingDependingFieldAPI);
        
   /**
    * Get the billing country and status fields API name and pass it to helper function
    **/   
        var billingControllingFieldAPI = component.get("v.billingControllingFieldAPI");
        var billingDependingFieldAPI = component.get("v.billingDependingFieldAPI");
        var Account = component.get("v.Account");
        helper.fetchBillingPicklistValues(component,Account,billingControllingFieldAPI, billingDependingFieldAPI);
        
   /**
    * Get list of Account in approved customer tab
    **/      
        var nextSearch = false;
        var prevSearch = false;
        var PageNumberSearch = component.get("v.PageNumberSearch");
        helper.getApprovedCustomer(component,event,helper,nextSearch,prevSearch,PageNumberSearch);
    },
    
    /**
    * Create Account in Salesforce
    **/    
    submitAccountRequest : function(component, event, helper){  
        helper.createAccountRecord(component, event, helper);
    },

    /**
    * Search Account by Name and createdDtae 
    **/
    SearchAccount : function(component,event,helper) {
        var searchNameField = component.find('searchNameField');
        component.set("v.noRecordsInApproedTab",false);
        
        var nextSearch = false;
        var prevSearch = false;
        component.set("v.PageNumberSearch", 1);
        var PageNumberSearch = component.get("v.PageNumberSearch");
                
        helper.SearchByNameHelper(component,event,helper,nextSearch,prevSearch,PageNumberSearch);
    },

    /**
    * Next Button in Second tabset
    **/    
    next : function(component, event, helper) {
        var currentTab = component.get("v.selTabId");
        
        if(currentTab == '1'){       
            component.set("v.selTabId" , '2');                   
        }else if(currentTab == '2'){
            component.set("v.selTabId" , '3');     
        }else if(currentTab == '3'){
            component.set("v.selTabId" , '4');             
        }
    },

    /**
    * Previous Button in Second tabset
    **/    
    back : function(component, event, helper) {
        var currentTab = component.get("v.selTabId");
        
        if(currentTab == '2'){
            component.set("v.selTabId" , '1');     
        } else if(currentTab == '3'){
            component.set("v.selTabId" , '2');     
        }else if(currentTab == '4'){
            component.set("v.selTabId" , '3');     
        } 
    },
    
    /**
    * Add another row of IP ranges in profile data tab 
    **/
    addRow: function(component, event, helper) {
        helper.addEndUserRecord(component, event);
    },
    
    /**
    * Remove row from IP ranges in profile data tab 
    **/
    removeRow: function(component, event, helper) {
        //Get the account list
        var ListForIP = component.get("v.ListForIP");
        //Get the target object
        var selectedItem = event.currentTarget;
        //Get the selected item index
        var index = selectedItem.dataset.record;
        ListForIP.splice(index, 1);
        component.set("v.ListForIP", ListForIP);
    },
    
    /**
    * Redirect again on Account request page
    **/
    BackToAccountRequestPage: function(component, helper){
        //component.set("v.updateOrInsert" , 'NewCustomer');
        location.reload(true);
    },
    
    /**
    * Logout current user
    **/
    LogOutUser: function(component, helper){
        window.location.replace("https://devcustlif-tandf.cs108.force.com/AccountRequest/login?ec=302&startURL=%2FAccountRequest%2Fs%2F");
    },
       
    /**
    * Method gets called by onsort action for pending Request tab
    **/
    SortPendingRequestTable : function(component,event,helper){
        var sortBy = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");
        component.set("v.sortBy",sortBy);
        component.set("v.sortDirection",sortDirection);
        helper.sortData(component,sortBy,sortDirection);
    },
    
  	/**
    * Method gets called by onsort action for approved customer tab in search case
    **/
    SortApprovedCustomerTable : function(component,event,helper){
        var sortBy = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");
        component.set("v.sortApprovedCustomerTab",sortBy);
        component.set("v.sortDirectionApprovedTab",sortDirection);
        helper.sortApprovedCustomer(component,sortBy,sortDirection);
    },
    
  	/**
    * Method gets called by onsort action for approved customer tab
    **/
    SortApprovedCustomerTableOnLoad : function(component,event,helper){
        var sortBy = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");
        component.set("v.sortApprovedCustomerTab",sortBy);
        component.set("v.sortDirectionApprovedTab",sortDirection);
        helper.sortApprovedCustomerOnLoad(component,sortBy,sortDirection);
    },    
    
    /**
    * Next Button in pending request tab used for pagination
    **/
    OnNext:function(component,event,helper)
    {
        var next = true;
        var prev = false;
        var offset = component.get("v.offset");
        var pageNumber = component.get("v.PageNumber");
        pageNumber++;
        component.set("v.showPendingLoadSpinner",false);
        
        helper.getPendingRequestList(component,next,prev,pageNumber,offset);
    },
    
    /**
    * Previous Button in pending request tab used for pagination
    **/
    OnPrevious:function(component,event,helper)
    {
        var next = false;
        var prev = true;
        var offset = component.get("v.offset");
        var pageNumber = component.get("v.PageNumber");
        pageNumber--;
        component.set("v.showPendingLoadSpinner",false);
        
        helper.getPendingRequestList(component,next,prev,pageNumber,offset);
    },  
    
    /**
    * Edit and delete button in pending request tab used for again edit details or delete account request 
    **/
    EditAccount: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        //alert(JSON.stringify(row));
        
        switch (action.name) {
            
            case 'Edit':
                //If onboarding status of acount is "Submitted for Approval" then you can not edit that account request
                if(row.Onboarding_Status__c == 'Submitted for Approval'){
                    helper.showToastMessage(component,event,helper,'Account with status Submitted for Approval can not be edited...','Error','Error');
                    return;
                }
                
                //Set some fields blank in edit mode
                var setIpListBlank=[];
                var setIpListBlankObj = new Object();
                component.set("v.ListForIP", setIpListBlankObj);
                
                var setContactListBlank=[];
                var setContactListBlankObj = new Object();
                component.set("v.ListForContact", setContactListBlankObj);
                
                component.set("v.MailingAddLine2" , '');
                component.set("v.ShippingAddLine1" , '');
                component.set("v.ShippingAddLine2" , '');
                component.set("v.BillingAddLine1" , '');
                component.set("v.BillingAddLine2" , '');
                
                //Set tab ids
                component.set("v.selTabIdOuterTab" , 'one');  
                component.set("v.selTabId" , '1');
                component.set("v.cancelButtonOnEdit" , true);
                component.set("v.updateOrInsert" , 'updateCustomer');
                
                //Map mailing country's value and on the basis of that show dependent picklist(mailing status) values
                if(!$A.util.isUndefinedOrNull(row.Mailing_Country_List__c)){
                    var mailingControllerValueKey = row.Mailing_Country_List__c; 
                    var mailingDepnedentFieldMap = component.get("v.mailingDepnedentFieldMap");
                    var ListOfDependentFields = mailingDepnedentFieldMap[mailingControllerValueKey];
                    if(ListOfDependentFields.length > 0){
                        component.set("v.mailingDisabledDependentFld" , false);
                        helper.fetchDepValues(component, ListOfDependentFields); 
                    }
                }
                
                //Map shipping country's value and on the basis of that show dependent picklist(shipping status) values
                if(!$A.util.isUndefinedOrNull(row.Shipping_Country_List__c)){
                    var shippingControllerValueKey = row.Shipping_Country_List__c; 
                    var shippingDepnedentFieldMap = component.get("v.shippingDepnedentFieldMap");
                    var ListOfDependentFields = shippingDepnedentFieldMap[shippingControllerValueKey];
                    if(ListOfDependentFields.length > 0){
                        component.set("v.shippingDisabledDependentFld" , false);  
                        helper.fetchShippingDepValues(component, ListOfDependentFields); 
                    }
                }
                
                //Map billing country's value and on the basis of that show dependent picklist(billing status) values
                if(!$A.util.isUndefinedOrNull(row.Billing_Country_List__c)){
                    var billingControllerValueKey = row.Billing_Country_List__c; 
                    var billingDepnedentFieldMap = component.get("v.billingDepnedentFieldMap");
                    var ListOfDependentFields = billingDepnedentFieldMap[billingControllerValueKey];
                    if(ListOfDependentFields.length > 0){
                        component.set("v.billingDisabledDependentFld" , false);  
                        helper.fetchBillingDepValues(component, ListOfDependentFields);
                    }
                }
                component.set("v.Account", row);
                component.set("v.RequestNotes", row.Request_Notes__c );
                
                //Map Mailing address line 1 and address line 2
                if(!$A.util.isUndefinedOrNull(row.Mailing_Street_Account_Request__c)){
                    var MailingStreetArr = row.Mailing_Street_Account_Request__c.split(';');
                    if (MailingStreetArr.length > 0)
                    {
                        component.set("v.MailingAddLine1" , MailingStreetArr[0]);
                        component.set("v.MailingAddLine2" , MailingStreetArr[1]);
                    }
                }  
                
                //Map Shipping address line 1 and address line 2 
                if(!$A.util.isUndefinedOrNull(row.Shipping_Street_Account_Request__c)){
                    var ShippingStreetArr = row.Shipping_Street_Account_Request__c.split(';');
                    if (ShippingStreetArr.length > 0)
                    {
                        component.set("v.ShippingAddLine1" , ShippingStreetArr[0]);
                        component.set("v.ShippingAddLine2" , ShippingStreetArr[1]);
                    }
                }
                
                //Map Billing address line 1 and address line 2
                if(!$A.util.isUndefinedOrNull(row.Billing_Street_Account_Request__c)){
                    var BillingStreetArr = row.Billing_Street_Account_Request__c.split(';');
                    if (BillingStreetArr.length > 0)
                    {
                        component.set("v.BillingAddLine1" , BillingStreetArr[0]);
                        component.set("v.BillingAddLine2" , BillingStreetArr[1]);
                    }
                }
                
                //Map list of contact
                if(!$A.util.isUndefinedOrNull(row.Contacts)){
                    var contacts = JSON.stringify(row.Contacts);
                    var contactsObj = JSON.parse(contacts);
                    component.set("v.ListForContact", contactsObj);
                    component.set("v.NewListForContact", contactsObj);
                }
                
                //Map list of IP ranges and remote access field
                if(!$A.util.isUndefinedOrNull(row.End_User_Accesses__r)){
                    var endUser = JSON.stringify(row.End_User_Accesses__r);
                    var endUserObj = JSON.parse(endUser); 
                    
                    var entity=[]; 
                    var ip=[]; 
                    var entityObj = new Object();
                    
                    for(var i = 0; i < endUserObj.length; i++){
                        if(JSON.stringify(endUserObj[i].Entity_ID__c)){
                            var entityId = endUserObj[i].Id;
                            var entityValue = endUserObj[i].Entity_ID__c;
                            var entityIdValue = endUserObj[i].Id__c;
                            entityObj.Entity_ID__c = entityValue;
                            entityObj.id = entityId;
                            entityObj.Account__c = endUserObj[i].Account__c;
                            entityObj.Id__c = entityIdValue;
                        }
                        var IPObj = new Object();
                        if(JSON.stringify(endUserObj[i].Description__c) || JSON.stringify(endUserObj[i].IP_Range__c) || JSON.stringify(endUserObj[i].Type__c)){
                            var descriptionValue = endUserObj[i].Description__c;
                            var ipRangesValue = endUserObj[i].IP_Range__c;
                            var typeValue = endUserObj[i].Type__c;
                            var Id = endUserObj[i].Id;
                            var idValue = endUserObj[i].Id__c;
                            IPObj.id = Id;
                            IPObj.Description__c=descriptionValue;
                            IPObj.IP_Range__c=ipRangesValue;
                            IPObj.Type__c=typeValue;
                            IPObj.Id__c=idValue;
                            IPObj.Account__c=endUserObj[i].Account__c;
                            ip.push(IPObj);
                        }
                        
                    }
                    entity.push(entityObj);
                    
                    component.set("v.EndUserRemoteAccess", entity);
                    component.set("v.ListForIP", ip);
                    
                    //If length of IP ranges are equal to zero then push a blank object 
                    if(ip.length == 0){
                        var ipObj = new Object();
                        ip.push(ipObj);
                        component.set("v.ListForIP", ip);
                    }
                    
                    //Create a set of entity id for update the remote access value in profile data tab
                    var entitySet = [];
                    for(var i = 0; i < entity.length; i++){
                        entitySet.push(entity[i].id);
                    }
                    component.set("v.NewEndUserRemoteAccessSet", entitySet);
                    
                    //Create a set of Ip ranges id for update the ip ranges values in profile data tab
                    var ipSet = [];
                    for(var i = 0; i < ip.length; i++){
                        ipSet.push(ip[i].id);
                    }
                    component.set("v.NewListForIPSet", ipSet);
                }
                break;
                
            case 'Delete':
                helper.deleteRecord(component, event, helper);
                break;
        }
    },
    
    /**
    * Add another Contact row in authorised user information tab 
    **/
    addContactRow: function(component, event, helper) {
        helper.addContactRecord(component, event);
    },
    
    /**
    * Remove Contact row in authorised user information tab 
    **/
    removeContactRow: function(component, event, helper) {
        //Get the contact list
        var ListForContact = component.get("v.ListForContact");
        //Get the target object
        var selectedItem = event.currentTarget;
        //Get the selected item index
        var index = selectedItem.dataset.record;
        ListForContact.splice(index, 1);
        component.set("v.ListForContact", ListForContact);
    },
    
    /**
    * Cancel button confirmation in edit mode
    **/
    confirmCancelOrNot: function(component, event, helper){
        var confirmCancel = confirm("Are you sure want to cancel update Account request?");
        if(confirmCancel){
            location.reload(true);
        }
        
    },
    
    /**
    * Get mailing state picklist values
    **/
    mailingControllerFieldChange: function(component, event, helper) { 
        
        helper.checkPostalCodeReq(component, event, helper);
        var mailingControllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        var mailingDepnedentFieldMap = component.get("v.mailingDepnedentFieldMap");
       
        if (mailingControllerValueKey != '--- None ---') {
            var ListOfDependentFields = mailingDepnedentFieldMap[mailingControllerValueKey];
            
            var updateOrInsert = component.get("v.updateOrInsert");
            if(updateOrInsert === 'updateCustomer'){
                component.set("v.mailingStateNoneUpdate", ListOfDependentFields);
                component.set("v.mailingCountryNotUpdate" , true);
            }
            
            if(ListOfDependentFields.length > 0){
                component.set("v.mailingDisabledDependentFld" , false);  
                helper.fetchDepValues(component, ListOfDependentFields); 
                
            }else{
                component.set("v.mailingDisabledDependentFld" , true); 
                component.set("v.mailingListDependingValues", ['--- None ---']);
            }  
            
        } else {
            component.set("v.mailingListDependingValues", ['--- None ---']);
            component.set("v.mailingDisabledDependentFld" , true);
        }
    },
    
    /**
    * Get shipping state picklist values
    **/
    shippingControllerFieldChange: function(component, event, helper) {     
        var shippingControllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        var shippingDepnedentFieldMap = component.get("v.shippingDepnedentFieldMap");
        
        if (shippingControllerValueKey != '--- None ---') {
            var ListOfDependentFields = shippingDepnedentFieldMap[shippingControllerValueKey];
            
            var updateOrInsert = component.get("v.updateOrInsert");
            if(updateOrInsert === 'updateCustomer'){
                component.set("v.shippingStateNoneUpdate", ListOfDependentFields);
                component.set("v.shippingCountryNotUpdate" , true);
            }
            
            if(ListOfDependentFields.length > 0){
                component.set("v.shippingDisabledDependentFld" , false);  
                helper.fetchShippingDepValues(component, ListOfDependentFields);    
            }else{
                component.set("v.shippingDisabledDependentFld" , true); 
                component.set("v.shippingListDependingValues", ['--- None ---']);
            }  
            
        } else {
            component.set("v.shippingListDependingValues", ['--- None ---']);
            component.set("v.shippingDisabledDependentFld" , true);
        }
    },

    /**
    * Get billing state picklist values
    **/    
    billingControllerFieldChange: function(component, event, helper) {    
        var billingControllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        var billingDepnedentFieldMap = component.get("v.billingDepnedentFieldMap");
        
        if (billingControllerValueKey != '--- None ---') {
            var ListOfDependentFields = billingDepnedentFieldMap[billingControllerValueKey];
            
            var updateOrInsert = component.get("v.updateOrInsert");
            if(updateOrInsert === 'updateCustomer'){
                component.set("v.billingStateNoneUpdate", ListOfDependentFields);
                component.set("v.billingCountryNotUpdate" , true);
            }
            
            if(ListOfDependentFields.length > 0){
                component.set("v.billingDisabledDependentFld" , false);  
                helper.fetchBillingDepValues(component, ListOfDependentFields);    
            }else{
                component.set("v.billingDisabledDependentFld" , true); 
                component.set("v.billingListDependingValues", ['--- None ---']);
            }  
            
        } else {
            component.set("v.billingListDependingValues", ['--- None ---']);
            component.set("v.billingDisabledDependentFld" , true);
        }
    },
    
    /**
    * Next button in approved customer tab used for pagination
    **/
    OnNextSearch:function(component,event,helper)
    {
        debugger;
        var nextSearch = true;
        var prevSearch = false;
        var offSetSearch = component.get("v.offSetSearch");
        var PageNumberSearch = component.get("v.PageNumberSearch");
        PageNumberSearch++;
        
        var searchKeyWord = component.get("v.searchNameKeyword");
        var startDate = component.get("v.startDate");
        var endDate = component.get("v.endDate");
        
        var noRecordsInApproedTab = component.get("v.noRecordsInApproedTab");
        
        if(noRecordsInApproedTab){
            component.set("v.showApprovedLoadSpinner",false);
            helper.getApprovedCustomer(component,event,helper,nextSearch,prevSearch,PageNumberSearch,offSetSearch);
        }
        
        if(($A.util.isEmpty(startDate) || $A.util.isUndefined(startDate)) && ($A.util.isEmpty(endDate) || $A.util.isUndefined(endDate)) && ($A.util.isEmpty(searchKeyWord) || $A.util.isUndefined(searchKeyWord))){
            component.set("v.showApprovedLoadSpinner",false); 
            helper.getApprovedCustomer(component,event,helper,nextSearch,prevSearch,PageNumberSearch,offSetSearch);
        }
        
        if(!noRecordsInApproedTab && (!$A.util.isEmpty(startDate) || !$A.util.isEmpty(endDate) || !$A.util.isUndefined(searchKeyWord))){
      		component.set("v.showSearchLoadSpinner",false);
            helper.SearchByNameHelper(component,event,helper,nextSearch,prevSearch,PageNumberSearch,offSetSearch);
        }
        
       /* else{
            helper.SearchByNameHelper(component,event,helper,nextSearch,prevSearch,PageNumberSearch,offSetSearch);
        }*/
        //helper.SearchByNameHelper(component,event,helper,nextSearch,prevSearch,PageNumberSearch,offSetSearch);
    },

    /**
    * Previous button in approved customer tab used for pagination 
    **/    
    OnPreviousSearch:function(component,event,helper)
    {
        var nextSearch = false;
        var prevSearch = true;
        var offSetSearch = component.get("v.offSetSearch");
        var PageNumberSearch = component.get("v.PageNumberSearch");
        PageNumberSearch--;
        
        var searchKeyWord = component.get("v.searchNameKeyword");
        var startDate = component.get("v.startDate");
        var endDate = component.get("v.endDate");
        
        var noRecordsInApproedTab = component.get("v.noRecordsInApproedTab");
        
        if(noRecordsInApproedTab){
            component.set("v.showApprovedLoadSpinner",false);
            helper.getApprovedCustomer(component,event,helper,nextSearch,prevSearch,PageNumberSearch,offSetSearch);
        }
        
        if(($A.util.isEmpty(startDate) || $A.util.isUndefined(startDate)) && ($A.util.isEmpty(endDate) || $A.util.isUndefined(endDate)) && ($A.util.isEmpty(searchKeyWord) || $A.util.isUndefined(searchKeyWord))){
            component.set("v.showApprovedLoadSpinner",false);
            helper.getApprovedCustomer(component,event,helper,nextSearch,prevSearch,PageNumberSearch,offSetSearch);
        }
        
        if(!noRecordsInApproedTab && (!$A.util.isEmpty(startDate) || !$A.util.isEmpty(endDate) || !$A.util.isUndefined(searchKeyWord))){
      		component.set("v.showSearchLoadSpinner",false);
            helper.SearchByNameHelper(component,event,helper,nextSearch,prevSearch,PageNumberSearch,offSetSearch);
        }
        /*else{
            helper.SearchByNameHelper(component,event,helper,nextSearch,prevSearch,PageNumberSearch,offSetSearch);
        }*/
        
    }, 
    

})