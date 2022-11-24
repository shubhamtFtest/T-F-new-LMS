({
    handleActive: function (component, event) {
        var tab = event.getSource();
        switch (tab.get('v.id')) {
            case 'printCostCalculator' :
                this.getPopularFormatsPicklistHelper(component, event);
                this.getOpportunityLineItemDetails(component, event);                
                break;
            case 'lastUMCDetails' :
                this.getLastPrintDetailHelper(component, event);
                break;
            case 'history':
                this.getProductionHistoryHelper(component,event);
                break;
        }
    },    
    getProductionHistoryHelper : function(component){
        var oId = component.get("v.opportunityLineItemId");
        var action = component.get("c.getProductionHistory");                   
        action.setParams({ "oliId" : oId });
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS"){
                var history = response.getReturnValue();
                //alert(history.length);
                component.set("v.productionhistory", history);
                component.set("v.isSending", false);
            }else if (state == "INCOMPLETE") {
				this.fireFailureToast(component,event, 'No internet connection');                
            } else if (state == "ERROR") {
				this.fireFailureToast(component,event, 'There was an issue while processing.');
            }
        });
        $A.enqueueAction(action);        
    },
    getCoversionRateHelper : function(component){     
        var action = component.get("c.getCoversionRate");                   
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS"){
                var coversionRateVal = response.getReturnValue();
                component.set("v.coversionRate", coversionRateVal);
            }else if (state == "INCOMPLETE") {
				this.fireFailureToast(component,event, 'No internet connection');                
            } else if (state == "ERROR") {
				this.fireFailureToast(component,event, 'There was an issue while processing.');
            }
        });
        $A.enqueueAction(action);
    },    
    getPopularFormatsPicklistHelper: function(component, event) {
        var action = component.get("c.getSizeInInches");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var industryMap = [];
                for(var key in result){
                    industryMap.push({key: key, value: result[key]});
                }
                component.set("v.popularFormatMap", industryMap);
            }
        });
        $A.enqueueAction(action);
    }, 
    getOpportunityLineItemDetails : function(component){        
        var oliId = component.get("v.opportunityLineItemId");      
        var action = component.get("c.getOLIDetail");    
        action.setParams({ "prodId" : oliId });                
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log(result);
                component.set("v.trimSize", result[0].popularFormat);
                component.set("v.versionType", result[0].versionType);
                component.set("v.requiredVersionType", result[0].requiredVersionType);
                component.set("v.quantity", result[0].Qty);
                if( typeof result[0].extent !== 'undefined') {
                   component.set("v.extent", result[0].extent); 
                } else {
                    component.set("v.extent", result[0].printedPages);
                }             
                this.getPopularFormatValues(component, result[0].popularFormat);
            }else if (state == "INCOMPLETE") {
				this.fireFailureToast(component,event,'No internet connection');                
            } else if (state == "ERROR") {
				this.fireFailureToast(component,event,'There was an issue while processing getOpportunityLineItemDetails.');
            }
        });
        $A.enqueueAction(action);
    },        
    getLastPrintDetailHelper: function(component, event) {
        var oppLineItemId = component.get("v.opportunityLineItemId");
        var action = component.get("c.getLastPrintDetails");
        action.setParams({ "oliId" : oppLineItemId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var jsonString1 = JSON.stringify(result);               
                console.log(result);
                //setting default values                                                             
                component.set("v.lastPrintTrimSize", result.prList[0].lastUMCPopularFormat);
                component.set("v.lastPrintFormatHeight", result.prList[0].lastUMCFormatHeight);
                component.set("v.lastPrintFormatWidth", result.prList[0].lastUMCFormatWidth);                                              
                component.set("v.lastPrintVersionType", result.prList[0].lastUMCVersionType);
                component.set("v.lastPrintTextColour", result.prList[0].lastUMCTextColour);
                component.set("v.lastPrintPaperType", result.prList[0].lastUMCPaperType);                               
                component.set("v.lastPrintInsert", result.prList[0].pInsert);               
                component.set("v.lastPrintCoverColor", result.prList[0].coverColor);
                component.set("v.lastPrintInsertColor", result.prList[0].insertColor);
                component.set("v.lastPrintInsertPaper", result.prList[0].insertPaper);
                component.set("v.lastPrintCoverPaper", result.prList[0].coverPaper);
                component.set("v.lastPrintExtras", result.prList[0].extras);                
                component.set("v.lastPrintUMC", result.prList[0].lastUMC);
                component.set("v.lastPrintUMCDate", result.prList[0].lastUMCDate);
                component.set("v.lastPrintCustomerQuote", result.prList[0].lastUMCCustomerQuote);                
                component.set("v.lastPrintQty", result.prList[0].lastUMCQuantity);                
                component.set("v.lastPrintRetailPrice", result.prList[0].mrp);
                component.set("v.lastPrintPrinter", result.prList[0].printerName);
                component.set("v.lastPrintSupplyDate", result.prList[0].supplyDate);
                component.set("v.lastPrintPages", result.prList[0].extent);                
				this.getPopularFormatValues(component, result.prList[0].popularFormat);
                component.set("v.wrapProductRecord", result);
            }
        });
        $A.enqueueAction(action);
    }, 
	getPopularFormatValues : function(component, popularFormat) {
        var quantity = component.get("v.quantity");       
        var action = component.get("c.getPopularFormats"); 
        action.setParams({ "size" : popularFormat, "qty" : quantity }); 
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue(); 
                console.log('@@@@getPopularFormatValues@@@@');
                console.log(result);
                component.set("v.formatHeight", result.formatHeight);
                component.set("v.formatWidth", result.formatWidth);                
                component.set("v.hardCasePLCValue", result.hardCasePLC);
                component.set("v.colorValue", result.color);
                component.set("v.sewingValue", result.sewing);
                component.set("v.x70gsmValue", result.X70gsm);
                component.set("v.x80gsmValue", result.X80gsm);                                
            }else if (state == "INCOMPLETE") {
				this.fireFailureToast(component,event,'No internet connection');                
            } else if (state == "ERROR") {
                this.fireFailureToast(component,event,'There was an issue while processing getPopularFormatValues.');
            }
        });
        $A.enqueueAction(action);
	},        
    fireSuccessToast : function(component,event,message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({ 
            'title' : 'Success', 
            'message' : message,
            'type':'success'
        }); 
        toastEvent.fire(); 
    },    
    fireFailureToast : function(component,event,message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({ 
            'title' : 'Failed', 
            'message' : message,
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
})