({
    getAccountDetails:function(component, event) {
        var accAction = component.get("c.getAccountDetails");
        accAction.setParams({
            "recordId": component.get("v.recordId")
        });
        accAction.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS" && response.getReturnValue() != null) {    
                component.set("v.accountRecord", response.getReturnValue());
                var accStatus = component.get("v.accountRecord.Onboarding_Status__c");
       			 if(accStatus == 'RingGold Identified'){
        		 	component.set("v.selTabId" , '2');
                    component.set("v.currentTabId" , '2');
                    component.set("v.accEnrichmentTab" , true);
                    component.set("v.searchRinggoldTab" , false);
       			 }else if(accStatus == 'IP Validation Done'){
        		 	component.set("v.selTabId" , '4');
                    component.set("v.currentTabId" , '4');
                    component.set("v.accEnrichmentTab" , false);
                    component.set("v.searchRinggoldTab" , false);
       			 }else if(accStatus == 'RingGold Enrichment Done'){
                    component.set("v.selTabId" , '3');
                     component.set("v.currentTabId" , '3');
                     component.set("v.searchRinggoldTab" , false);
                     component.set("v.accEnrichmentTab" , false);
                     
        		}else if(accStatus == 'Rejected'){
                    component.set("v.showErrors" , true);
                    component.set("v.errorMsg" , 'This account has been Rejected.');
                    component.set("v.noErrors" , false);
        		    component.set("v.selTabId" , '4');
                    component.set("v.currentTabId" , '4');
       			 }
			}
        });
 		
        $A.enqueueAction(accAction);
    },
    
    continueWithoutEnrichment:function(component, event) {
        var accAction = component.get("c.updateAccStatusPostEnrichment");
        accAction.setParams({
            "recordId": component.get("v.recordId")
        });
        $A.enqueueAction(accAction);
        component.set("v.accEnrichmentTab" , false);
        component.set("v.searchRinggoldTab" , false);
        component.set("v.selTabId" , '3');
        component.set("v.currentTabId" , '3');
        $A.get('e.force:refreshView').fire();
    }
})