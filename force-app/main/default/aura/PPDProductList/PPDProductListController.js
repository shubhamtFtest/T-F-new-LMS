({
    
       doInit: function(component, event, helper) {
        var filterObject = {
            productName: '',
            leadAuthor: '',
            publisher: ''
        }
        component.set("v.filterObject", filterObject);

        },
	productFilterChangeHandler : function(component, event, helper) {
        var filterObject = component.get("v.filterObject");
        if (event.getParam("productName") !== undefined) {
	        filterObject.productName = event.getParam("productName");
        }
        if (event.getParam("leadAuthor") !== undefined) {
	        filterObject.leadAuthor = event.getParam("leadAuthor");
        }
        if (event.getParam("publisher") !== undefined) {
	        filterObject.publisher = event.getParam("publisher");;
        }
        //component.set("v.filterObject",filterObject);
        console.log(filterObject);

        helper.loalProducts(component);		
	},
    //Select all products
    handleSelectAllProducts: function(component, event, helper) {
        var getID = component.get("v.products");
        var checkvalue = component.find("selectAll").get("v.value");        
        var checkProduct = component.find("checkProduct"); 
        if(checkvalue == true){
            for(var i=0; i<checkProduct.length; i++){
                checkProduct[i].set("v.value",true);
            }
        }
        else{ 
            for(var i=0; i<checkProduct.length; i++){
                checkProduct[i].set("v.value",false);
            }
        }
    },
     
    //Process the selected products
    handleSelectedPrducts: function(component, event, helper) {
        var selectedProducts = [];
        var checkvalue = component.find("checkProduct");
         
        if(!Array.isArray(checkvalue)){
            if (checkvalue.get("v.value") == true) {
                selectedProducts.push(checkvalue.get("v.text"));
            }
        }else{
            for (var i = 0; i < checkvalue.length; i++) {
                if (checkvalue[i].get("v.value") == true) {
                    selectedProducts.push(checkvalue[i].get("v.text"));
                }
            }
        }
        component.set("v.isOpen",false);
        console.log('selectedProducts-' + selectedProducts);
    }    
})