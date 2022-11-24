({
    doInit : function(component, event, helper) { 
        helper.getTotalNumberOfOlis(component);        
        helper.queryOLIs(component,event,helper);        
        helper.checkRequestSent(component,event,helper);        
        helper.exportExcelHelper(component, event, helper);
    },
    searchIsbn: function(component, event, helper){
        var recordID = component.get("v.recordId");
        var searchedisbn = component.find("searchisbn").get("v.value"); 
        if(searchedisbn == '' || searchedisbn == null){
            component.set('v.searchError', 'Search field can not be blank.');
            helper.queryOLIs(component,event,helper);
        }else{
            var action = component.get("c.doesProductCodeExistInOpp");
            action.setParams({"oppId": recordID, "isbn": searchedisbn});
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var retval = response.getReturnValue();
                    if(retval == true){
                        component.set('v.searchError', '');
                        helper.queryOLIs(component,event,helper,searchedisbn);   
                    } else {
                        component.set('v.searchError', 'Record does not exist.');
                        helper.queryOLIs(component,event,helper);  
                    }
                } 
            });
            $A.enqueueAction(action);        
        }
    },
    handleLoadMoreOlis: function (component, event, helper) {
        event.getSource().set("v.isLoading", true);
        component.set('v.loadMoreStatus', 'Loading....');
        helper.getMoreOlis(component, component.get('v.rowsToLoad')).then($A.getCallback(function (data) {
            if (component.get('v.oliList').length == component.get('v.totalNumberOfRows')) {
                component.set('v.enableInfiniteLoading', false);
                component.set('v.loadMoreStatus', 'No more data to load');
            } else {
                var currentData = component.get('v.oliList');
                var newData = currentData.concat(data);
                component.set('v.oliList', newData);
                component.set('v.loadMoreStatus', 'Please scroll down to load more data');
            }
            event.getSource().set("v.isLoading", false);
        }));
    },
    openBulkUpdateModal : function(component, event, helper) {
        component.set("v.isBulkUpdateModalOpen", true);
    },
    exportCSV : function(component, event, helper) { 
        var stockData = component.get("v.ListOfOpportunityLineItems");
        
        console.log(stockData);
        // call the helper function which "return" the CSV data as a String   
        var csv = helper.convertArrayOfObjectsToCSV(component, stockData);   
        if (csv == null){return;}            
        var hiddenElement = document.createElement('a');
        csv=csv.replace(/%20/g, " ");
        csv=csv.replace(/%23/g, " ");
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        hiddenElement.target = '_self'; // 
        hiddenElement.download = 'ExportProposalData.csv';  // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
    },
    openAddOppProductModal: function(component, event, helper) {
        component.set("v.isOpenAddOppProductModal", true);
    }, 
    closeAddOppProductModal: function(component, event, helper) { 
        component.set("v.isOpenAddOppProductModal", false);
    },    
    openHistoryModel: function(component, event, helper) {
        component.set("v.isHistoryModalOpen", true);
    },
    closeHistoryModel: function(component, event, helper) { 
        component.set("v.isHistoryModalOpen", false);
    },    
    openOverrideModel: function(component, event, helper) {
        component.set("v.isOverrideModalOpen", true);
    },
    closeOverrideModel: function(component, event, helper) { 
        component.set("v.isOverrideModalOpen", false);
    },    
    openModel: function(component, event, helper) {
        component.set("v.isOpen", true);
        helper.getPriceBookEntry(component);
    },
    openInvoiceUploadModel: function(component, event, helper) { 
        component.set("v.isOpenInvoiceUploadModal", true);
    },    
    closeInvoiceUploadModel: function(component, event, helper) { 
        component.set("v.isOpenInvoiceUploadModal", false);
    },    
    updateOLI : function(component, event, helper) {
        
    },
    handleSaveOpps: function (component, event, helper) {   
        var editedRecords = event.getParam('draftValues');
        var json  = JSON.stringify(editedRecords);
		var obj = JSON.parse(json)[0];        
		if(obj['mrp']){
			obj.MRP__c = obj.mrp;
			delete obj.mrp;	
		}else if(obj['quantity']){
			obj.Quantity = obj.quantity;
			delete obj.quantity;			
		}else if(obj['unitPrice']){
			obj.UnitPrice = obj.unitPrice;
			delete obj.unitPrice;			
		}else if(obj['UMC']){
			obj.UMC__c = obj.UMC;
			delete obj.UMC;			
		}	
		
		json = JSON.stringify([obj]);               
        var draftValues = JSON.parse(json); 
        console.log(draftValues);        
        var action = component.get('c.inlineUpdateOpportunityLineItem');
        action.setParams({"opportunityLineItem": draftValues});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                helper.fireSuccessToast(component);  
                helper.fireRefreshEvt(component);
            } else if (state === "ERROR") {
                var errors = response.getError();
                helper.fireFailureToast(component);  
            }
        });
        $A.enqueueAction(action);
    },
    handleRowAction: function(component, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        component.set("v.selectedOLIIds",selectedRows); 
        component.set("v.selectedRowsCount" ,selectedRows.length );
    },    
    buttonAction : function(component, event, helper) {
        var recId = event.getParam('row').Id;
        var actionName = event.getParam('action').name;
        
        var action = event.getParam('action');
        var row = event.getParam('row');        
        //if (actionName == 'olihistory') {
        //    component.set("v.oliId", recId);
        //    component.set("v.isHistoryModalOpen", true);            
        //}         
        switch (action.name) {
            case 'preview':
                var navEvt = $A.get("event.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": recId,
                    "slideDevName": "detail"
                });
                navEvt.fire();                
                break;
            case 'edit':
                var editRecordEvent = $A.get("e.force:editRecord");
                editRecordEvent.setParams({
                    "recordId": recId
                });
                editRecordEvent.fire();                 
                break;
            case 'delete':
                var recDelId = event.getParam('row').Id;
                component.set("v.recordDeleteId", recDelId);
                component.set('v.showConfirmDialog', true);                                   
                break;
            case 'printcostcalculator':
                component.set("v.oliId", recId);
                component.set("v.isOpenUMCCalulatorModal", true);
                break;
            case 'openInvoiceUploadModal':
                component.set("v.oliId", recId);
                component.set("v.isOpenInvoiceUploadModal", true);
                break;
            case 'olihistory':
            	component.set("v.oliId", recId);
            	component.set("v.isHistoryModalOpen", true);
                break;               
        }        
        
        var apexaction = component.get('c.getOLIDetails');
        apexaction.setParams({"oliId": recId});
        apexaction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var olival = response.getReturnValue();
                //console.log(olival);
                if (actionName == 'Override') {
                    component.set("v.isOverrideModalOpen", true);
                    component.set("v.oliId", recId);
                    component.set("v.oliremark", olival.Remarks__c);
                    component.set("v.oppOwnerId", olival.Opportunity.OwnerId);
                    component.set("v.oppCreatedById", olival.Opportunity.CreatedById);
                }
                if (actionName == 'gmoverride') {
                    component.set("v.isGMOverrideModalOpen", true);
                    component.set("v.oliId", recId);
                    component.set("v.grossMargin", olival.Gross_Margin__c);
                }                
            } else if (state === "ERROR") {
                var errors = response.getError();
                helper.fireFailureToast(component);  
            }
        });
        $A.enqueueAction(apexaction);        
    },
	handleConfirmDialogYes : function(component, event, helper) {
        component.set('v.showConfirmDialog', false);
        helper.deleteOpportunityLineItemRecord(component, event);
        var triggerDoInit = component.get('c.doInit');
        $A.enqueueAction(triggerDoInit);        
    },
     
    handleConfirmDialogNo : function(component, event, helper) {
        component.set('v.showConfirmDialog', false);
    },    
    requestPricing: function(component, event, helper) {
        helper.requestPricingHelper(component);        
    },
    requestUMC: function(component, event, helper) {
        helper.requestUMCHelper(component);        
    },
    renegotiateUMC: function(component, event, helper) {
        helper.renegotiateUMCHelper(component);        
    },    
    requestMRP: function(component, event, helper) {
        helper.requestMRPHelper(component);      
    },
    pricingEntered: function(component, event, helper) {
        helper.pricingEnteredHelper(component);      
    },    
    checkReprintEligibility: function(component, event, helper) {
        helper.checkReprintEligibilityHelper(component);       
    },
    submitFinalApproval: function(component, event, helper) {
        helper.submitFinalApprovalHelper(component);       
    },
    submitGMOverride: function(component, event, helper) {
        helper.submitGMOverrideHelper(component);       
    },    
    doDelete : function(component, event, helper){
        var oliIdList = component.get("v.selectedOLIIds");
        var selectedRowsCnt = component.get("v.selectedRowsCount");
        var action = component.get('c.deleteForm');
        action.setParams({lstId : oliIdList});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                alert(selectedRowsCnt);
                $A.get('e.force:refreshView').fire();
                alert('Successfully Deleted');   
            }
        });
        $A.enqueueAction(action);
    },
    openColorInfoModal : function(component, event, helper){
        component.set("v.isOpenColorInfoModal", true);
    },
    closeColorInfoModal : function(component, event, helper){
        component.set("v.isOpenColorInfoModal", false);
    },    
})