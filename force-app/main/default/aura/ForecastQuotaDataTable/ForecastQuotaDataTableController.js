({
	onInit : function(cmp, event, helper) {
        // onit called after deletion
        cmp.set("v.Spinner", true);
        helper.fetchterritoryForcastType(cmp, event);
        $A.util.addClass(cmp.find('ModalPopUp'),'slds-hide');
		var action = cmp.get("c.fetchForecastQuota");        
        action.setCallback(this,function(a){
            //get the response state
            var state = a.getState();            
            //check if result is successfull
            if(state == "SUCCESS"){
                cmp.set("v.Spinner", false);
                cmp.set("v.listForecastingQuota",a.getReturnValue());
                console.log('fetchForecastQuota-'+JSON.stringify(a.getReturnValue()));
            } else if(state == "ERROR"){
                cmp.set("v.Spinner", false);
                var errors = a.getError();                
                if (errors) {
                    cmp.set("v.Spinner", false);
                    if (errors[0] && errors[0].message) 
                    {
                        console.error("Error message: " + errors[0].message);                                              
                    }
                } 
            }
        });        
        //adds the server-side action to the queue        
        $A.enqueueAction(action);
    },     
    editClicked : function (cmp, event, helper) { 
        console.log("You clicked: " + event.getSource().get("v.label"));
        cmp.find('newQuotaAmount').set("v.value","");
        $A.util.removeClass(cmp.find('ModalPopUp'),'slds-hide');
        var target = event.target;
        var index =  target.getAttribute("data-index");
        // objForecastingQuota listForecastingQuota
        // var objForquota = cmp.get("v.");
        var arrObj = cmp.get("v.listForecastingQuota");
        if($A.util.isArray(arrObj)) {
            var objForquota = arrObj[index];
            cmp.set("v.objForecastingQuota",objForquota);
            cmp.set("v.editRecId",objForquota.Id);
            // newQuotaAmount
            console.log('objForquota-'+JSON.stringify(objForquota)); 
            console.log('editRecId-'+cmp.get("v.editRecId"));
            
        }
    },    
    hidePopup : function (cmp, event, helper) {
        $A.util.addClass(cmp.find('ModalPopUp'),'slds-hide');
    },
    saveNewAmount : function (cmp, event, helper) {
        var objForquota = cmp.get("v.objForecastingQuota");
        var action = cmp.get("c.saveEditedRec");   
        action.setParams({
            strId : cmp.get("v.editRecId"),
            AmountQuota : cmp.find('newQuotaAmount').get("v.value")
        });     
        action.setCallback(this,function(a){
            //get the response state
            var state = a.getState();            
            //check if result is successfull
            if(state == "SUCCESS"){
                $A.util.addClass(cmp.find('ModalPopUp'),'slds-hide');
                cmp.set("v.showTable",false);                
                cmp.set("v.showTable",true);
            } else if(state == "ERROR"){
                var errors = a.getError();                
                if (errors) {
                    if (errors[0] && errors[0].message) 
                    {
                        console.error("Error message: " + errors[0].message);                                              
                    }
                } 
            }
        });        
        //adds the server-side action to the queue        
        $A.enqueueAction(action);
    },        
    CancelDel : function (cmp, event, helper) {
        $A.util.addClass( cmp.find('deletionCinfirmation'),'slds-hide');
    },
    delPopup : function (cmp, event, helper) {
        $A.util.removeClass( cmp.find('deletionCinfirmation'),'slds-hide');
        var target = event.target;
        var recordId = target.getAttribute("data-recordId");
        cmp.set("v.delRecId",recordId);
    },
    ConfirmDel : function (cmp, event, helper) {
        //console.log("You clicked: " + event.getSource().get("v.label"));
        cmp.set("v.Spinner", true);
        
        var action = cmp.get("c.deleteForecastQuota");   
        action.setParams({
            Id : cmp.get("v.delRecId")
        });     
        action.setCallback(this,function(a){
            //get the response state
            var state = a.getState();            
            //check if result is successfull
            if(state == "SUCCESS"){
                cmp.set("v.listForecastingQuota",a.getReturnValue());
                $A.util.addClass( cmp.find('deletionCinfirmation'),'slds-hide');
                var act = cmp.get("c.onInit");
                $A.enqueueAction(act);
                console.log('fetchForecastQuota-'+JSON.stringify(a.getReturnValue()));
            } else if(state == "ERROR"){
                var errors = a.getError();                
                if (errors) {
                    $A.util.addClass( cmp.find('deletionCinfirmation'),'slds-hide');
                    if (errors[0] && errors[0].message) 
                    {
                        console.error("Error message: " + errors[0].message);                                              
                    }
                } 
            }
        });        
        //adds the server-side action to the queue        
        $A.enqueueAction(action);
    },
})