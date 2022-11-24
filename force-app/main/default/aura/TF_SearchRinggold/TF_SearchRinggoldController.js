({
	calloutCtrl : function(component, event, helper) {
        helper.getResponse(component);
        helper.getAccountDetails(component);
        var cols = [
            {label: 'RinggoldId', fieldName: 'ringgoldId', type: 'number'},
            {label: 'Account Name', fieldName: 'accountName', type: 'text'},
            {label: 'City', fieldName: 'city', type: 'text'},
            {label: 'Country', fieldName: 'country', type: 'text'}
        ];
        component.set("v.tableCols", cols);
    },
    searchRinggoldCtrl : function(component, event, helper) {
        component.set("v.Spinner", true);
        helper.getUIResponse(component);
        var cols = [
            {label: 'RinggoldId', fieldName: 'ringgoldId', type: 'number'},
            {label: 'Account Name', fieldName: 'accountName', type: 'text'},
            {label: 'City', fieldName: 'city', type: 'text'},
            {label: 'Country', fieldName: 'country', type: 'text'}
        ];
        component.set("v.tableCols", cols);
    },
    handleInputNameChange : function(component, event, helper) {
        var value = event.currentTarget.value;
        component.set("v.AccRec.Name", value);
    },
    handleInputCityChange : function(component, event, helper) {
        var value = event.currentTarget.value;
        component.set("v.AccRec.BillingCity", value);
    },
    handleInputStateChange : function(component, event, helper) {
        var value = event.currentTarget.value;
        component.set("v.AccRec.BillingState", value);
    },
    handleInputWebsiteChange : function(component, event, helper) {
    	var value = event.currentTarget.value;
        component.set("v.AccRec.Website", value);
    },
    handleInputZipChange : function(component, event, helper) {
    	var value = event.currentTarget.value;
        component.set("v.AccRec.BillingPostalCode", value);
    },
    handleInputCountryChange : function(component, event, helper) {
    	var value = event.currentTarget.value;
        component.set("v.AccRec.BillingCountry", value);
    },
        // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
   },
    
 // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner    
       component.set("v.Spinner", false);
    },
    handleSelect : function(component, event, helper) {
        
        var selectedRows = event.getParam('selectedRows'); 
        var rgid;
        var setRows = [];
        for ( var i = 0; i < selectedRows.length; i++ ) {
            
            setRows.push(selectedRows[i]);
			rgid = selectedRows[i].ringgoldId;
        }
        component.set("v.selectedRows", setRows);
        component.set("v.rgId", rgid);
        helper.findDupAccount(component, event);
        
    },
    
    rejectRequest :  function(component, event, helper) {
        var reject = component.get("v.thirdParty");
        if(component.get("v.thirdParty")){
            helper.thirdPartyRejectRequest(component, event);
        }else{
        	helper.rejectRequest(component, event);
        }
    }
})