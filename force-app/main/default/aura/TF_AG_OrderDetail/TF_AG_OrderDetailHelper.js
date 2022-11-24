({
    getOrderDetailsHelper : function(component,event,orderid) {
        var ordrid = orderid;
        var action = component.get("c.getOrderData");
        action.setParams({OrderId: ordrid});
         action.setCallback(this, function(res){
            var state = res.getState();
            if(state === 'SUCCESS'){
                this.hideSpinner(component,event);
                var rtnValue = res.getReturnValue();
                if(rtnValue===null){
                    this.showModal(component,event);
                } 
                if(rtnValue!==null){  
                component.set("v.wrapperData",rtnValue.data);
                }
                else{
                    this.showModal(component,event);
                }
            }
        });
        $A.enqueueAction(action);
    },
    showSpinner :function(component,event,helper){
     component.set("v.Spinner",true);
    },
    hideSpinner :function(component,event){
        component.set("v.Spinner",false);
    },
    showModal :function(component,event){
        component.set("v.modalPopup",true);
    },
    hideModal:function(){
        component.set("v.modalPopup",false);
    } 

})