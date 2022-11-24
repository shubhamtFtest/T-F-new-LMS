({
    init: function (cmp, event, helper) {
        
        cmp.set('v.columns', [
            { label: 'Product Name', fieldName: 'Product_Id_Link__c', type: 'url', sortable: true, typeAttributes: { label: { fieldName: 'Name'}, target: '_blank'}},
            { label: 'Lead Author', fieldName: 'Lead_Author_Editor__c', type: 'text', sortable: true },
            { label: 'Publisher', fieldName: 'Publisher__c', type: 'text', sortable: true },
            { label: 'ISBN', fieldName: 'ISBN__c', type: 'text', sortable: true }
        ]);
        
        
        helper.fetchTitles(cmp);
    },   
    
    
    
    handleSelectedRow: function(component, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        var arrSelectedProdIds = [];
        for (var i = 0; i < selectedRows.length; i++) {
            arrSelectedProdIds.push(selectedRows[i].Id);       
        }
        component.set("v.selectedProductsDetails" ,arrSelectedProdIds );
        component.set("v.selectedRowsCount", selectedRows.length);      
        component.set("v.selectedRowsList", selectedRows);
       
    },    
    
    deletePrds : function(component, event, helper) {
        var selectedProductsIdList =  component.get("v.selectedProductsDetails");  
        
        if (selectedProductsIdList== null || selectedProductsIdList=='[]') {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "",
                "message": "Please add atleast one product from the list!"
            });
            toastEvent.fire();
            return;
        }
        helper.deleteTitles(component, event);  
        var newEvent = $A.get("e.c:PPDTitleRefreshEvent");
        newEvent.fire();
         component.set("v.selectedProductsDetails" ,null);
        //changed by chetan
        //helper.fetchTitles(component);
    },
    
    deleteAllPrds : function(component, event, helper) {
        var toggleTxt = component.find("dispMsg");        
        $A.util.addClass(toggleTxt, "hideCmp");
        $A.util.removeClass(toggleTxt, "showCmp"); 
        helper.deleteAllTitles(component, event);  
        var newEvent = $A.get("e.c:PPDTitleRefreshEvent");
        newEvent.fire();
    },
    
    refreshChild: function(cmp, event, helper) {
        helper.fetchTitles(cmp);
        console.log('test refresh call');
    },
    
 
    
    showMsg: function(component, event, helper) {		            
        var toggleTxt = component.find("dispMsg");        
        $A.util.addClass(toggleTxt, "showCmp");
        $A.util.removeClass(toggleTxt, "hideCmp");   
    },
    
    hideMsg: function(component, event, helper) {			            
        var toggleTxt = component.find("dispMsg");        
        $A.util.addClass(toggleTxt, "hideCmp");
        $A.util.removeClass(toggleTxt, "showCmp");   
    },
    
    
     sortColumn: function(component, event, helper) {       
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortData(component, fieldName, sortDirection);
     },
    renderPage:function(component, event, helper)
    {
        helper.renderPage(component);
    }
})