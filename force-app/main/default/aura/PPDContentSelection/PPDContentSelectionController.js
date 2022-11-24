({
	search : function(component, event, helper) {
        //var productSearchEvent = component.getEvent("productSearchEvent");
        var productSearchEvent = $A.get("e.c:PPDProductSearchEvent");
		productSearchEvent.setParams({
            productName : component.find("productName").get("v.value"),
            leadAuthor : component.find("leadAuthor").get("v.value"),
            publisher : component.find("publisher").get("v.value")
        });
     //   alert('1'+ component.find("productName"));
    //    alert('2'+ component.find("productName").get("v.value"));
     //   alert('3'+ component.get("v.productName"));
    //    alert('4'+ productSearchEvent.getParam("productName"));
        component.set("v.isOpen", true);
		productSearchEvent.fire();
        
    }
})