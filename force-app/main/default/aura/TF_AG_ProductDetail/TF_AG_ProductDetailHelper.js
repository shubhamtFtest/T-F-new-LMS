({
	getProductDetailsHelper : function(component,event,isbn) {
        var action = component.get("c.getProductDetailByISBN");
        action.setParams({ prodISBN : isbn});
        action.setCallback(this, function(res){
            var state = res.getState();
            if(state === 'SUCCESS'){
                var rtnValue = res.getReturnValue();
                component.set("v.priceBookEntryData",rtnValue);
            }
        });
        $A.enqueueAction(action);
	}
})