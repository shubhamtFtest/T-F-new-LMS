({
    doInit: function(component,event,value) {
        console.log(component.get('v.sobject'))
         var recordid=component.get("v.recordId");
          var BaseUrl = document.URL;
        var SelectdStr = window.location.protocol+'//'+window.location.host
 
    	var accs="";
        var campus="";
        var dept="";
        var Sobject=component.get('v.sobject');
        
        if(Sobject=="Account")
            accs=recordid;
        else if(Sobject=="Campus__c")
            campus=recordid;
        else if(Sobject=="Department__c")
            dept=recordid;

        window.setTimeout(
            $A.getCallback(function() {
                $A.get("e.force:closeQuickAction").fire();
            })
        );

        //window.open(SelectdStr+"/lightning/n/ContactSearch?accId="+accs+"&campId="+campus+"&deptId="+dept+"");
        var navService = component.find("navService");
        // Sets the route to /lightning/o/Account/home
        var pageReference = {
            type: "standard__component",
            attributes: {
                componentName: "c__ContactSearchComponent"
            },
            state: {

                "c__accId": accs,
                "c__campId": campus,
                "c__deptId": dept

            }

        };
        component.set("v.pageReference", pageReference);
        // Set the URL on the link or use the default if there's an error
        var defaultUrl = "#";
        navService.generateUrl(pageReference)
            .then($A.getCallback(function(url) {
                component.set("v.url", url ? url : defaultUrl);
            }), $A.getCallback(function(error) {
                component.set("v.url", defaultUrl);
            }));
     //   console.log('#url#'+component.get("v.url"));
        var pageReference = component.get("v.pageReference");
      //  event.preventDefault();
        navService.navigate(pageReference);
       
    }
    
})