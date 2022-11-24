//mate  Cannot update quantity on a revenue quota: [QuotaAmount] - error message to be shown if it includes 
({
    onInit :  function(cmp, event, helper) {        
        cmp.set("v.showTable",true);
        cmp.set("v.showFormQuota",false);
        // InsertQuotaType 
        
        
    },
    
    // this function automatic call by aura:waiting event  
    showSpinner: function(cmp, event, helper) {
        // make Spinner attribute true for display loading spinner 
        cmp.set("v.Spinner", true); 
    },
    
    // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(cmp,event,helper){
        // make Spinner attribute to false for hide loading spinner    
        cmp.set("v.Spinner", false);
    },
    
    showForm : function(cmp,event,helper){
        // choosing territory from dropdown going back & again getting to form makes drop down value rights
        cmp.set("v.InsertQuotaType","Revenue");
        // hiding menu items 
        cmp.set("v.showMenu",true);
        cmp.set("v.showTable",false);
        cmp.set("v.editMode",false);
        cmp.set("v.showFormQuota",true);
        console.log('showing form');     
    },
    handleSelect: function (cmp, event) {
        // This will contain the string of the "value" attribute of the selected
        // lightning:menuItem
        var selectedMenuItemValue = event.getParam("value");
        console.log("Menu item selected with value: " + selectedMenuItemValue);
        // Find all menu items
        var menuItems = cmp.find("menuItems"); 
        menuItems.forEach(function (menuItem) {
            // For each menu item, if it was checked, un-check it. This ensures that only one
            // menu item is checked at a time
            if (menuItem.get("v.checked")) {
                menuItem.set("v.checked", false);
            }
            // Check the selected menu item
            if (menuItem.get("v.value") === selectedMenuItemValue) {
                menuItem.set("v.checked", true);
            }
        });
        cmp.set("v.InsertQuotaType",selectedMenuItemValue);
        cmp.set("v.showFormQuota",false);
        cmp.set("v.showFormQuota",true);
    }
})