({
    firstPage: function(component, event, helper) {
        component.set("v.nextClicked", "false");
        component.set("v.prevClicked", "false");
        component.set("v.lastClicked", "false");
        component.set("v.firstClicked", "true");
        component.set("v.prevPageNumber", component.get("v.currentPageNumber"));
        component.set("v.currentPageNumber", 1);
        
    },
    prevPage: function(component, event, helper) {
        component.set("v.nextClicked", "false");
        component.set("v.prevClicked", "true");
        component.set("v.lastClicked", "false");
        component.set("v.firstClicked", "false");
        component.set("v.prevPageNumber", component.get("v.currentPageNumber"));
        component.set("v.currentPageNumber", Math.max(component.get("v.currentPageNumber")-1, 1));
        
    },
    nextPage: function(component, event, helper) {
        component.set("v.prevClicked", "false");
        component.set("v.nextClicked", "true");
        component.set("v.lastClicked", "false");
        component.set("v.firstClicked", "false");
        component.set("v.prevPageNumber", component.get("v.currentPageNumber"));
        component.set("v.currentPageNumber", Math.min(component.get("v.currentPageNumber")+1, component.get("v.maxPageNumber")));
        
    },
    lastPage: function(component, event, helper) {
        component.set("v.nextClicked", "false");
        component.set("v.prevClicked", "false");
        component.set("v.lastClicked", "true");
        component.set("v.firstClicked", "false");
        component.set("v.prevPageNumber", component.get("v.currentPageNumber"));
        component.set("v.currentPageNumber", component.get("v.maxPageNumber"));
        
    }
})