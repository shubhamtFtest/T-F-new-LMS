({
    onInit : function(component, event, helper) {
        helper.fetchRecords(component,'');
 
    } ,
    HideMe : function(component, event, helper) {
        component.set('v.hasModalOpen',false);
    },
    CreatePrintOrder : function(component, event, helper) {
        helper.CreatePrintOrder(component, event, helper);
    },
     SendToProd : function(component, event, helper) {
        helper.SendToProd(component, event, helper);
    },
    
    updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');         
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },getSelectedName: function (cmp, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        var listitem=[];
        var SelectPrinterOrNot=[];
        for (var i = 0; i < selectedRows.length; i++){
         console.log(selectedRows[i].Printer+"You selected: " + selectedRows[i].recordId);
         listitem.push(selectedRows[i].recordId);
            if(selectedRows[i].Printer==null || selectedRows[i].Printer==''){
            SelectPrinterOrNot.push(selectedRows[i].recordId);
            }

        }
        cmp.set("v.SelectIds", listitem);
         cmp.set("v.SelectPrinterOrNot", SelectPrinterOrNot);

    },
    buttonAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        var recid=row.recordId;
        cmp.set("v.OrliId", recid);
        var orderlineitemlist=cmp.get("v.OrderLineItemList");
        for(var i=0;i<=orderlineitemlist.length;i++){
            if(orderlineitemlist[i]!=undefined){
                var str=JSON.stringify(orderlineitemlist[i].recordId);
                var record=str.replace(/"([^"]+(?="))"/g, '$1');
                
                if(record===recid){
                    cmp.set("v.OrderLineItem",orderlineitemlist[i]);

                }
            }
        }

        cmp.set("v.hasModalOpen", true);
      // helper.sortData(cmp, fieldName, sortDirection);

    },
       
    
   onfocus : function(component,event,helper){
       $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC  
         var getInputkeyWord = '';
         //helper.searchHelper(component,event,getInputkeyWord);
    },
    onblur : function(component,event,helper){       
       /* component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
       $A.util.addClass(forclose, 'slds-is-close');
      $A.util.removeClass(forclose, 'slds-is-open');*/
    },
      selectRecord : function(component, event, helper){      
          // get the selected record from list  
          var selectedItem = event.currentTarget; // Get the target object
          var index = selectedItem.dataset.record;
          var selectedStore = component.get("v.listOfSearchRecords")[index];
          component.set("v.Idrec",component.get("v.listOfSearchRecords")[index].Id);

          
          var currentvalue = selectedStore;
          //console.log(JSON.currentvalue.length);
          //component.set("v.selectedRecord" , JSON.parse(JSON.stringify(currentvalue))); 
          component.set("v.selectedRecord",currentvalue);
          var forclose = component.find("lookup-pill");
          $A.util.addClass(forclose, 'slds-show');
          $A.util.removeClass(forclose, 'slds-hide');
          
          var forclose = component.find("searchRes");
          $A.util.addClass(forclose, 'slds-is-close');
          $A.util.removeClass(forclose, 'slds-is-open');
          
          var lookUpTarget = component.find("lookupField");
          $A.util.addClass(lookUpTarget, 'slds-hide');
          $A.util.removeClass(lookUpTarget, 'slds-show');  

    },
    keyPressController : function(component, event, helper) {
       // get the search Input keyword   
         var getInputkeyWord = component.get("v.SearchKeyWord");
       // check if getInputKeyWord size id more then 0 then open the lookup result List and 
       // call the helper 
       // else close the lookup result List part. 
        if( getInputkeyWord.length > 0 ){
             var forOpen = component.find("searchRes");
             $A.util.addClass(forOpen, 'slds-is-open');
              $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
             component.set("v.listOfSearchRecords", null ); 
             var forclose = component.find("searchRes");
               $A.util.addClass(forclose, 'slds-is-close');
               $A.util.removeClass(forclose, 'slds-is-open');
          }
	},
    
  // function for clear the Record Selaction 
    clear :function(component,event,heplper){
         var pillTarget = component.find("lookup-pill");
         var lookUpTarget = component.find("lookupField"); 
        
         $A.util.addClass(pillTarget, 'slds-hide');
         $A.util.removeClass(pillTarget, 'slds-show');
        
         $A.util.addClass(lookUpTarget, 'slds-show');
         $A.util.removeClass(lookUpTarget, 'slds-hide');
      
         component.set("v.SearchKeyWord",null);
         component.set("v.listOfSearchRecords", null );
         component.set("v.selectedRecord", {} );   
    },
    
  // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
    // get the selected Account record from the COMPONETN event 	 
       var selectedAccountGetFromEvent = event.getParam("recordByEvent");
	   component.set("v.selectedRecord" , selectedAccountGetFromEvent); 
       
        var forclose = component.find("lookup-pill");
           $A.util.addClass(forclose, 'slds-show');
           $A.util.removeClass(forclose, 'slds-hide');
  
        var forclose = component.find("searchRes");
           $A.util.addClass(forclose, 'slds-is-close');
           $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show');  
      
    },SaveRecord : function(cmp, event, helper) {
        helper.updateDistributor(cmp, event, helper);
    }
 
})