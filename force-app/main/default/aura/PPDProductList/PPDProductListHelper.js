({
	loalProducts : function(component, page) {
		var action = component.get("c.getProducts");
        action.setStorable();
		action.setParams({
      		"filters": JSON.stringify(component.get("v.filterObject")),
    	}); 
        action.setCallback(this, function(response) {
            console.log('# getProducts callback %f', (performance.now() - startTime));
			var result = response.getReturnValue();
            component.set("v.products", result.products);
    	});
        var startTime = performance.now();
    	$A.enqueueAction(action);
	}
})