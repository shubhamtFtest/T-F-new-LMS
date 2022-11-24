({
    getTotalNumberOfOlis : function(component) {
        var recordID = component.get("v.recordId");
        var action = component.get("c.getTotalOLIs");
        action.setParams({"oliId": recordID});      
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                var resultData = response.getReturnValue();
                component.set("v.totalNumberOfRows", resultData);
            }
        });
        $A.enqueueAction(action);
    },
    getMoreOlis: function(component , rows){
        return new Promise($A.getCallback(function(resolve, reject) {
            var recordID = component.get("v.recordId");
            var action = component.get('c.getAllOpportunityLineItems');
            var recordOffset = component.get("v.currentCount");
            var recordLimit = component.get("v.initialRows");
            action.setParams({
                "recordLimit": recordLimit,
                "recordOffset": recordOffset,
                "oppId":recordID
            });           
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS"){
                    var resultData = response.getReturnValue();
                    resolve(resultData);
                    recordOffset = recordOffset+recordLimit;
                    component.set("v.currentCount", recordOffset);   
                }                
            });
            $A.enqueueAction(action);
        }));
    },    
    queryOLIs : function(component,event,helper,searchedIsbn) {       
        var recordID = component.get("v.recordId");       
        var act = component.get("c.checkUserPermissionAndOpp");
        act.setParams({"opportunityId": recordID});
        act.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var retVal = response.getReturnValue(); 
                var jsonObj = JSON.parse(retVal);            
                console.log(jsonObj);                        
                //setting user access attributes
                component.set("v.isSalesUser", jsonObj.iSSalesUser);
                component.set("v.isCustomerServicesUser", jsonObj.iSCustomerServiceUser);
                component.set("v.isProductionUser", jsonObj.iSProductionUser);
                component.set("v.isCreditControlUser", jsonObj.iSCreditControlUser);                
                
                var commonActions;
                var productionActions;
                var isEditable;
                if(jsonObj.isOpportunityClosedWon === true) {
                    commonActions = [{ label: 'Record Details', name: 'preview'}];                
                    productionActions = [{ label: 'Record Details', name: 'preview'}];
                    isEditable = false;
                } else {
                    commonActions = [
                        { label: 'Record Details', name: 'preview'}, 
                        { label: 'Edit', name: 'edit'},                     
                        { label: 'OLI Details', name: 'olihistory'},
                        { label: 'GM Override', name: 'gmoverride'},
                        { label: 'Delete', name: 'delete'}
                    ];
                    
                    productionActions = [
                        { label: 'Record Details', name: 'preview'}, 
                        { label: 'Edit', name: 'edit'}, 
                        { label: 'OLI Details', name: 'olihistory'},
                        { label: 'Print Cost Calculator', name: 'printcostcalculator'}
                        
                    ]; 
                    isEditable = true;
                }
                
                var typeColumn = '{"label": "Type", "fieldName": "type", "type": "text", "editable": true}';
                var deleteBtn = '{"type": "button", "typeAttributes": {"iconName": "action:delete,"name": "Delete,"title": "Delete","disabled": false,"value": "delete","iconPosition": "left"}}';
                
                if(jsonObj.iSSalesUser == true) {
                    component.set('v.columns', [
                        {label: 'Customer', fieldName: 'distributor', type: 'text', typeAttributes: {label: { fieldName: 'distributorName' }, target: '_blank'},"cellAttributes": {"class": {"fieldName": "showClass"}}},
                        {label: 'Product Name', fieldName: 'productName', type: 'text', typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'},"cellAttributes": {"class": {"fieldName": "showClass"}}},
                        {label: 'Type', fieldName: 'productType', type: 'text', editable: false,"cellAttributes": {"class": {"fieldName": "showClass"}}},
                        {label: 'UK ISBN', fieldName: 'globalISBN', type: 'text', editable: false,"cellAttributes": {"class": {"fieldName": "showClass"}}},
                        {label: 'Indian ISBN', fieldName: 'indiaISBN', type: 'text', editable: false,"cellAttributes": {"class": {"fieldName": "showClass"}}},
                        {label: 'Quantity', fieldName: 'quantity', type: 'number', editable: isEditable,"cellAttributes": {"class": {"fieldName": "showClass"}}},
                        {label: 'UMC(GBP)', fieldName: 'UMC', type: 'number',"cellAttributes": {"class": {"fieldName": "showClass"}}, typeAttributes: { minimumFractionDigits: 2 }},                    
                        {label: 'Indian Retail Price (INR)', fieldName: 'mrp', type: 'currency', editable: false,"cellAttributes": {"class": {"fieldName": "showClass"}}},
                        {label: 'GM', fieldName: 'gm', type: 'number', editable: false,"cellAttributes": {"class": {"fieldName": "showClass"}}},
                        {label: 'Customer Rate (GBP)', fieldName: 'customerRate', type: 'number',"cellAttributes": {"class": {"fieldName": "showClass"}}},                   
                        {label: 'Total Price', fieldName: 'totalPrice', type: 'number',"cellAttributes": {"class": {"fieldName": "showClass"}}},
                        {label: 'Reprint Eligibility', fieldName: 'reprintEligibility', type: 'text', editable: false,"cellAttributes": {"class": {"fieldName": "showClass"}}},            
                        {label: 'Proposal Stage/Status', fieldName: 'status', type: 'text', editable: false,"cellAttributes": {"class": {"fieldName": "showClass"}}},                               
                        {label: 'Required Binding', fieldName: 'requiredBinding', type: 'text', editable: false,"cellAttributes": {"class": {"fieldName": "showClass"}}},
                        {type: "button", typeAttributes: {label: 'Override',name: 'Override',title: 'Override',disabled: { fieldName: 'isActive'},value: 'override',iconPosition: 'left'},"cellAttributes": {"class": {"fieldName": "showClass"}}},
                        {type: 'action',typeAttributes: {rowActions: commonActions,menuAlignment: 'auto'}
                        }                        
                    ]);                
                } else if(jsonObj.iSProductionUser == true) {
                    component.set('v.columns', [
                        {label: 'Customer', fieldName: 'distributor', type: 'text', typeAttributes: {label: { fieldName: 'distributorName' }, target: '_blank'},"cellAttributes": {"class": {"fieldName": "showClass"}}},
                        {label: 'Product Name', fieldName: 'productName', type: 'text', typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'},"cellAttributes": {"class": {"fieldName": "showClass"}}},
                        {label: 'Type', fieldName: 'productType', type: 'text',"cellAttributes": {"class": {"fieldName": "showClass"}}},
                        {label: 'UK ISBN', fieldName: 'globalISBN', type: 'text', editable: false,"cellAttributes": {"class": {"fieldName": "showClass"}}},
                        {label: 'Indian ISBN', fieldName: 'indiaISBN', type: 'text', editable: false,"cellAttributes": {"class": {"fieldName": "showClass"}}},
                        {label: 'Quantity', fieldName: 'quantity', type: 'number', editable: isEditable, "cellAttributes": {"class": {"fieldName": "showClass"}}},           
                        {label: 'UMC(GBP)', fieldName: 'UMC', type: 'number', editable: isEditable, "cellAttributes": {"class": {"fieldName": "showClass"}}},
                        {label: 'Indian Retail Price (INR)', fieldName: 'mrp', type: 'currency', editable: false, "cellAttributes": {"class": {"fieldName": "showClass"}}},                   
                        {label: 'GM', fieldName: 'gm', type: 'number', editable: false,"cellAttributes": {"class": {"fieldName": "showClass"}}},
                        {label: 'Customer Rate (GBP)', fieldName: 'customerRate', type: 'number',"cellAttributes": {"class": {"fieldName": "showClass"}}},                    
                        {label: 'Total Price', fieldName: 'totalPrice', type: 'number',"cellAttributes": {"class": {"fieldName": "showClass"}}},
                        {label: 'Reprint Eligibility', fieldName: 'reprintEligibility', type: 'text',"cellAttributes": {"class": {"fieldName": "showClass"}}},            
                        {label: 'Proposal Stage/Status', fieldName: 'status', type: 'text',"cellAttributes": {"class": {"fieldName": "showClass"}}},                    
                        {label: 'Required Binding', fieldName: 'requiredBinding', type: 'text', editable: false,"cellAttributes": {"class": {"fieldName": "showClass"}}},
                        {type: 'action',typeAttributes: { rowActions: productionActions,menuAlignment: 'right'}}                                   
                    ]);            
                } else if(jsonObj.iSCustomerServiceUser == true) {
                    component.set('v.columns', [
                        {label: 'Customer', fieldName: 'distributor', type: 'text', typeAttributes: {label: { fieldName: 'distributorName' }, target: '_blank'},"cellAttributes": {"class": {"fieldName": "showClass"}}},
                        {label: 'Product Name', fieldName: 'productName', type: 'text', typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'},"cellAttributes": {"class": {"fieldName": "showClass"}}},
                        {label: 'Type', fieldName: 'productType', type: 'text', editable: false,"cellAttributes": {"class": {"fieldName": "showClass"}}},
                        {label: 'UK ISBN', fieldName: 'globalISBN', type: 'text', editable: false,"cellAttributes": {"class": {"fieldName": "showClass"}}},
                        {label: 'Indian ISBN', fieldName: 'indiaISBN', type: 'text', editable: false,"cellAttributes": {"class": {"fieldName": "showClass"}}},
                        {label: 'Quantity', fieldName: 'quantity', type: 'number', editable: isEditable,"cellAttributes": {"class": {"fieldName": "showClass"}}},           
                        {label: 'UMC(GBP)', fieldName: 'UMC', type: 'number',"cellAttributes": {"class": {"fieldName": "showClass"}}},
                        {label: 'Indian Retail Price (INR)', fieldName: 'mrp', type: 'currency', editable: isEditable,"cellAttributes": {"class": {"fieldName": "showClass"}}},       
                        {label: 'GM', fieldName: 'gm', type: 'number',"cellAttributes": {"class": {"fieldName": "showClass"}}},                   
                        {label: 'Customer Rate (GBP)', fieldName: 'customerRate', type: 'number',"cellAttributes": {"class": {"fieldName": "showClass"}}},
                        {label: 'Total Price', fieldName: 'totalPrice', type: 'number',"cellAttributes": {"class": {"fieldName": "showClass"}}},
                        {label: 'Reprint Eligibility', fieldName: 'reprintEligibility', type: 'text', editable: false,"cellAttributes": {"class": {"fieldName": "showClass"}}},            
                        {label: 'Status', fieldName: 'status', type: 'text', editable: false,"cellAttributes": {"class": {"fieldName": "showClass"}}},                               
                        {label: 'Required Binding', fieldName: 'requiredBinding', type: 'text', editable: false,"cellAttributes": {"class": {"fieldName": "showClass"}}},
                        {type: "button", typeAttributes: {label: 'Override',name: 'Override',title: 'Override',disabled: { fieldName: 'isActive'},value: 'override',iconPosition: 'left'},"cellAttributes": {"class": {"fieldName": "showClass"}}},
                        {type: 'action',typeAttributes: {rowActions: commonActions,menuAlignment: 'right'}
                        }                        
                    ]);            
                }
            }
        });       
        $A.enqueueAction(act);
        
        //start action
        var action = component.get("c.getAllOpportunityLineItems");
        action.setParams({
            "recordLimit": component.get("v.initialRows"),
            "recordOffset": component.get("v.rowNumberOffset"),
            "oppId": recordID,
            "searchIsbn" : searchedIsbn,
        });        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();               
                for (var i = 0; i < records.length; i++) {
                    var row = records[i];
                    if (records[i].Reprint_Eligibility__c === "Pass" )  
                        records[i].buttonColor = 'success';  
                    else if (records[i].Reprint_Eligibility__c === "Fail" )  
                        records[i].buttonColor = 'brand';                     
                } 
                component.set("v.oliList", records);
            } else if (state == "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({"title": "Oops!","message": "No Internet Connection"});
                toastEvent.fire();           
            } else if (state == "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({"title": "Error!","message": "There was an issue while processing, please contact SFDC system admin."});
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },    
    getOpportunity : function(component) {
        var recordID = component.get("v.recordId");
        var action = component.get("c.getOpportunity");
        action.setParams({ 
            "oppId":recordID
        });         
        action.setCallback(this, function(response) {  
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                component.set("v.oppName", result.Name);
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
                    "message": "There was an issue while processing, please contact SFDC system admin."
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    getPriceBookEntry : function(component) {
        var recordID = component.get("v.recordId");
        var action = component.get("c.getPriceBookEntry");    
        action.setParams({ 
            "oppId":recordID
        });        
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                //console.log('result.products'+ JSON.stringify(result.products));
                component.set("v.products", result.products);
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
                    "message": "There was an issue while processing, please contact SFDC system admin."
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    fireSuccessToast : function(component) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({ 
            'title' : 'Success', 
            'message' : 'Record has updated sucessfully.' ,
            'type':'success'
        }); 
        toastEvent.fire(); 
    },
    fireFailureToast : function(component) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({ 
            'title' : 'Failed', 
            'message' : 'An error occurred. Please contact your administrator.',
            'type':'error'
        }); 
        toastEvent.fire(); 
    },
    fireRefreshEvt : function(component) {
        var refreshEvent = $A.get("e.force:refreshView");
        if(refreshEvent){
            refreshEvent.fire();
        }
    },
    requestPricingHelper : function(component,event,helper) {       
        var oliIdList = component.get("v.selectedOLIIds");
        var selectedRowsCnt = component.get("v.selectedRowsCount");        
        var recordID = component.get("v.recordId");
        if(selectedRowsCnt < 1){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({ 
                'message' : 'Please select list of products before request pricing.',
                'type':'error'
            });
            toastEvent.fire();          
        }else{
            //check status
            var checkStatusAction = component.get("c.checkLineItemReprintEligibilityStatus");
            checkStatusAction.setParams({ "oppoptunityId":recordID, "lstId" : oliIdList});
            checkStatusAction.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var returnValue = response.getReturnValue(); 
                    if(returnValue == 'NOT_ALLOW_TO_CHECK_REPRINT_ELIGIBILITY'){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({ 
                            'message' : 'You can not select product which eligibility status is NULL.',
                            'type':'error'
                        });
                        toastEvent.fire();                     
                    } else {
                        var action = component.get("c.updateOppAndOppLineItems");    
                        action.setParams({ 
                            "oppoptunityId":recordID,
                            "status":"Pricing Requested",
                            "lstId" : oliIdList,
                            "isRenegotiateUMC" : 'false'
                        });         
                        action.setCallback(this, function(response){
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                var records = response.getReturnValue(); 
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({ 
                                    'title' : 'Success', 
                                    'message' : 'Request has been submitted sucessfully.' ,
                                    'type':'success'
                                }); 
                                location.reload();
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
                                    "message": "There was an issue while processing, please contact SFDC system admin."
                                });
                                toastEvent.fire();
                            }
                        });
                        $A.enqueueAction(action);                    
                    }                
                }
            });
            $A.enqueueAction(checkStatusAction);            
        }        
    },
    submitFinalApprovalHelper : function(component,event,helper) {       
        var oliIdList = component.get("v.selectedOLIIds");
        var selectedRowsCnt = component.get("v.selectedRowsCount");        
        var recordID = component.get("v.recordId");
        component.set("v.isSpinner", true);
        if(selectedRowsCnt < 1){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({ 
                'message' : 'Select product before approval.',
                'type':'error'
            });
            toastEvent.fire();          
        }else{
            //check status
            var checkStatusAction = component.get("c.checkLineItemStatusBeforeApproval");
            checkStatusAction.setParams({ "oppoptunityId":recordID, "lstId" : oliIdList});
            checkStatusAction.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var returnValue = response.getReturnValue(); 
                    if(returnValue == 'NOT_ALLOW_TO_REQUEST_APPROVAL'){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({ 
                            'message' : 'Select products which status is "Pricing Entered" only.',
                            'type':'error'
                        });
                        component.set("v.isSpinner", false);
                        toastEvent.fire();                     
                    }else{
                        var action = component.get("c.finalApproval");    
                        action.setParams({ 
                            "opportunityId":recordID,
                            "lstId" : oliIdList
                        });         
                        action.setCallback(this, function(response){
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                var records = response.getReturnValue(); 
                                if(records == 'NOT_ALLOW_TO_APPROVE') {
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({ 
                                        'message' : 'You can not select eligibility failed product OR product where gross margin is less than 2.5 OR without an India ISBN.' ,
                                        'type':'error'
                                    });                         
                                }else{
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({ 
                                        'title' : 'Success', 
                                        'message' : 'Request has been approved sucessfully.' ,
                                        'type':'success'
                                    }); 
                                    location.reload();
                                }     
                                component.set("v.isSpinner", false);
                                toastEvent.fire();                
                            }else if (state == "INCOMPLETE") {
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "Oops!",
                                    "message": "No Internet Connection"
                                });
                                component.set("v.isSpinner", false);
                                toastEvent.fire();                                
                            } else if (state == "ERROR") {
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "Error!",
                                    "message": "There was an issue while processing, please contact SFDC system admin."
                                });
                                component.set("v.isSpinner", false);
                                toastEvent.fire();
                            }
                        });
                        $A.enqueueAction(action);                
                    }
                }                
            });
            $A.enqueueAction(checkStatusAction);                   
        }        
    },    
    requestUMCHelper : function(component,event,helper) {       
        var oliIdList = component.get("v.selectedOLIIds");
        var selectedRowsCnt = component.get("v.selectedRowsCount");        
        var recordID = component.get("v.recordId");
        if(selectedRowsCnt < 1){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({ 
                'message' : 'Please select list of products before request UMC.',
                'type':'error'
            });
            toastEvent.fire();          
        }else{
            var action = component.get("c.updateOppAndOppLineItems");    
            action.setParams({ 
                "oppoptunityId":recordID,
                "status":"UMC Requested",
                "lstId" : oliIdList,
                "isRenegotiateUMC" : 'false'
            });         
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var records = response.getReturnValue(); 
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({ 
                        'title' : 'Success', 
                        'message' : 'Request has been submitted sucessfully.' ,
                        'type':'success'
                    });
                    location.reload();
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
                        "message": "There was an issue while processing, please contact SFDC system admin."
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action);
        }
    },
    renegotiateUMCHelper : function(component,event,helper) {       
        var oliIdList = component.get("v.selectedOLIIds");
        var selectedRowsCnt = component.get("v.selectedRowsCount");        
        var recordID = component.get("v.recordId");
        if(selectedRowsCnt < 1){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({ 
                'message' : 'Please select list of products before renegotiate request UMC.',
                'type':'error'
            });
            toastEvent.fire();          
        }else{
            component.set("v.isRenegotiateUMCReasonModalOpen", true);
            component.set("v.umcRenegotiateIds", oliIdList);
        }
    },    
    requestMRPHelper : function(component,event,helper) {       
        var oliIdList = component.get("v.selectedOLIIds");
        var selectedRowsCnt = component.get("v.selectedRowsCount");        
        var recordID = component.get("v.recordId");
        if(selectedRowsCnt < 1){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({ 
                'message' : 'Select product before submit to request MRP.',
                'type':'error'
            });
            toastEvent.fire();          
        }else{      
            //check status
            var checkStatusAction = component.get("c.checkLineItemStatus");
            checkStatusAction.setParams({ "oppoptunityId":recordID, "lstId" : oliIdList});
            checkStatusAction.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var returnValue = response.getReturnValue(); 
                    if(returnValue == 'NOT_ALLOW_TO_REQUEST_MRP'){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({ 
                            'message' : 'You can only select the products which status is either "UMC Entered" OR "UMC Confirmed".',
                            'type':'error'
                        });
                        toastEvent.fire();                     
                    }else{
                        var action = component.get("c.updateOppAndOppLineItems");    
                        action.setParams({ 
                            "oppoptunityId":recordID,
                            "status":"MRP Requested",
                            "lstId" : oliIdList,
                            "isRenegotiateUMC" : 'false'
                        });         
                        action.setCallback(this, function(response){
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                var records = response.getReturnValue(); 
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({ 
                                    'title' : 'Success', 
                                    'message' : 'Request has been submitted sucessfully.' ,
                                    'type':'success'
                                }); 
                                location.reload();
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
                                    "message": "There was an issue while processing, please contact SFDC system admin."
                                });
                                toastEvent.fire();
                            }
                        });
                        $A.enqueueAction(action);                
                    }
                } 
            });
            $A.enqueueAction(checkStatusAction);               
        }       
    },  
    pricingEnteredHelper : function(component,event,helper) {       
        var oliIdList = component.get("v.selectedOLIIds");
        var selectedRowsCnt = component.get("v.selectedRowsCount");        
        var recordID = component.get("v.recordId");
        if(selectedRowsCnt < 1){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({ 
                'message' : 'Select product before submit to check reprint eligibility.',
                'type':'error'
            });
            toastEvent.fire();          
        }else{
            var action = component.get("c.oliPricingEntered");    
            action.setParams({ 
                "opportunityId":recordID,
                "lstId" : oliIdList
            });          
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var records = response.getReturnValue(); 
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({ 
                        'title' : 'Success', 
                        'message' : 'Request has been submitted sucessfully.' ,
                        'type':'success'
                    }); 
                    location.reload();
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
                        "message": "There was an issue while processing, please contact SFDC system admin."
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action);            
        }                            
    }, 
    submitGMOverrideHelper : function(component,event,helper) {       
        var oliIdList = component.get("v.selectedOLIIds");
        var selectedRowsCnt = component.get("v.selectedRowsCount");        
        var recordID = component.get("v.recordId");
        if(selectedRowsCnt < 1){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({ 
                'message' : 'Select product before submit to GM Override.',
                'type':'error'
            });
            toastEvent.fire();          
        }else{
            var action = component.get("c.updateGMOverride");    
            action.setParams({ 
                "opportunityId":recordID,
                "lstId" : oliIdList
            });          
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var records = response.getReturnValue(); 
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({ 
                        'title' : 'Success', 
                        'message' : 'Request has been submitted sucessfully.' ,
                        'type':'success'
                    }); 
                    location.reload();
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
                        "message": "There was an issue while processing, please contact SFDC system admin."
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action);            
        }                            
    },    
    deleteOpportunityLineItemRecord : function(component,event,helper) {       
        //var recId = event.getParam('row').Id;
        var recordDeleteId = component.get("v.recordDeleteId");
        var recordID = component.get("v.recordId");
        var action = component.get("c.deleteOpportunityLineItem");    
        action.setParams({ 
            "oliId":recordDeleteId
        });         
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                if(records == 'RECORD_DELETED'){                
                    toastEvent.setParams({ 
                        'title' : 'Success', 
                        'message' : 'Record has deleted sucessfully.' ,
                        'type':'success'
                    });
                    toastEvent.fire();               
                }else{
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "There is an issue."
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
                    "message": "There was an issue while processing, please contact SFDC system admin."
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }, 
    overrideOpportunityLineItemRecord : function(component,event,helper) {       
        var recId = event.getParam('row').Id;
        var recordID = component.get("v.recordId");
        var action = component.get("c.overrideOpportunityLineItem");    
        action.setParams({ 
            "oliId":recId
        });         
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                if(records == 'RECORD_UPDATED'){                
                    toastEvent.setParams({ 
                        'title' : 'Success', 
                        'message' : 'Record has updated sucessfully.' ,
                        'type':'success'
                    });
                    toastEvent.fire();
                }else{
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "There is an issue."
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
                    "message": "There was an issue while processing, please contact SFDC system admin."
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }, 
    checkReprintEligibilityHelper : function(component,event,helper) {       
        var oliIdList = component.get("v.selectedOLIIds");
        var selectedRowsCnt = component.get("v.selectedRowsCount");
        var recordID = component.get("v.recordId");
        if(selectedRowsCnt < 1){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({ 
                'message' : 'Select product before submit to check reprint eligibility.',
                'type':'error'
            });
            toastEvent.fire();          
        }else{
            component.set("v.isSpinner", true);
            var action = component.get("c.validateReprintEligibility");    
            action.setParams({ 
                "opportunityId":recordID,
                "lstId" : oliIdList
            });         
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var returnVal = response.getReturnValue();
                    console.log('reprintEligibilityResult::'+returnVal);
                    var toastEvent = $A.get("e.force:showToast");
                    if(returnVal == 'SUCCESS_WITHOUT_RESPONSE_DATA' || returnVal == 'SUCCESS_WITH_RESPONSE_DATA'){                    
                        toastEvent.setParams({ 
                            'title' : 'Success', 
                            'message' : 'Request has been submitted sucessfully.' ,
                            'type':'success'
                        });
                        location.reload();
                    }else{
                        toastEvent.setParams({ 
                            'title' : 'Error', 
                            'message' : 'Exception:: '+returnVal,
                            'type':'error'
                        });                    
                    }
                    component.set("v.isSpinner", false);
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
                        "message": "There was an issue while processing, please contact SFDC system admin."
                    });
                    toastEvent.fire();
                }
                
            });        
            $A.enqueueAction(action);        
        }
    },  
    checkRequestSent : function(component,event,helper) {       
        var recordID = component.get("v.recordId");
        var action = component.get("c.getOpportunity");    
        action.setParams({ 
            "oppId":recordID
        });         
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnVal = response.getReturnValue();
                if(returnVal.Is_Pricing_Request_Sent__c == true){
                    component.set("v.isPricingRequestSent", true);  
                }
                if(returnVal.Is_Reprint_Eligibility_Request_Sent__c == true){
                    component.set("v.isReprintEligibilityRequestSent", true);
                }
                if(returnVal.Is_UMC_Request_Sent__c == true){
                    component.set("v.isUMCRequestSent", true);
                } 
                if(returnVal.Is_Reprint_Eligibility_Checked__c == true){
                    component.set("v.isReprintEligibilityChecked", true);
                }
                if(returnVal.Overall_Reprint_Eligibility__c == 'Pass'){
                    component.set("v.overallReprintEligibility", true);  
                }else{
                    component.set("v.overallReprintEligibility", false);
                }  
                if(returnVal.Is_MRP_Request_Sent__c == true){
                    component.set("v.isMRPRequestSent", true);
                }
                if(returnVal.Is_Pricing_Entered__c == true){
                    component.set("v.isPricingEntered", true);
                }
                if(returnVal.Is_Approved__c == true){
                    component.set("v.isApproved", true);
                } 
                if(returnVal.Is_GMOverride_Done__c == true){
                    component.set("v.isGMOverrideDone", true);
                } 
                component.set("v.oppStageName", returnVal.StageName);
                
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
                    "message": "There was an issue while processing, please contact SFDC system admin."
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }, 
    getOliRemarkHelper : function(component,event,helper) {
        //var recordID = component.get("v.oliRecordId");
        var recId = event.getParam('row').Id;
        var action = component.get("c.getOliRemarkHelper");
        action.setParams({ 
            "oliId":recId
        });
        action.setCallback(this, function(response) {  
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                component.set("v.oliremarks", result);
            }else if (state == "INCOMPLETE") {   
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "message": "No Internet Connection"
                });
                toastEvent.fire();               
            } else if (state == "ERROR") {
                this.fireFailureToast(component, event, helper);
            }
        });
        $A.enqueueAction(action);        
    },
    exportExcelHelper : function(component, event, helper) {
        var recordID = component.get("v.recordId");
        var action = component.get("c.exportExcelAction");
        action.setParams({ "opportunityId" : recordID});         
        action.setCallback(this, function(response) {  
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.ListOfOpportunityLineItems', response.getReturnValue());                
            }
        });
        $A.enqueueAction(action);
    },    
   convertArrayOfObjectsToCSV : function(component, objectRecords){
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;      
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
         }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header  
        keys = ['Id','HistoryId','Customer','GlobalISBN','IndiaISBN','Qty','UMC','MRP','CustomerQuote','GrossMargin','TitleName','ReprintEligibility','BindingType','Size','Pages','Inserts','TextColor','TextPaper','CoverColor','CoverPaper','UkPrice','ReprintBind','Extras','Gratis','ProductionComment','CustomerServiceComment','SalesComments','Lamination','PrinterName','YearOfPrint','Cancelled','Status','ishistory','isDelete'];       
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
 
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;          
             for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;  
                // add , [comma] after every String value,. [except first]
                  if(counter > 0){ 
                      csvStringResult += columnDivider; 
                   }   
                 var str=objectRecords[i][skey];
                 if(skey==="CoverColor" || skey==="CoverPaper" || skey==="Inserts"){
                      //str.replace(/%20/g, " ");
                    str=escape(str);
                 }
               csvStringResult += '"'+ str+'"';

               counter++; 
            } // inner for loop close 
             csvStringResult += lineDivider;
          }// outer main for loop close 

       // return the CSV formate String 
        return csvStringResult;        
    },    
})