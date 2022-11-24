({
    init : function(component, event, helper) {
        helper.getAccountDetails(component);
    },
    next : function(component, event, helper) {
        component.set("v.nextClicked" , true);
      // get the current selected tab value
        var currentTab = component.get("v.selTabId");
        
        if(currentTab == '1'){
          var childCmp = component.find('searchRG');
          var childRgId = JSON.stringify(childCmp.get('v.rgId'));
          component.set("v.ringgoldId" , childRgId);
          var check = component.get("v.ringgoldId"); 
          if(check == 'null'){
                alert('Further actions cannot be performed as Duplicate account found with the selected Ringgold Id');
          }else{
                component.set("v.selTabId" , '2');
              	component.set("v.currentTabId" , '2');
              	component.set("v.accEnrichmentTab" , true);
          		component.set("v.searchRinggoldTab" , false);
          }
          
          $A.get('e.force:refreshView').fire();
        }
        if(currentTab == '2'){
          var childCmp = component.find('accEnrichment');
          var childStatus = JSON.stringify(childCmp.get('v.statusOk'));
          component.set("v.enrichmentDone" , childStatus);
          component.set("v.accEnrichmentTab" , false);
          component.set("v.searchRinggoldTab" , false);
          component.set("v.goBack" , true);
          component.set("v.selTabId" , '3'); 
            component.set("v.currentTabId" , '3');
        }
        if(currentTab == '3'){
          
          component.set("v.accEnrichmentTab" , false);
          component.set("v.searchRinggoldTab" , false);
		  component.set("v.selTabId" , '4');
            component.set("v.currentTabId" , '4');
        }
	},
    
    back : function(component, event, helper) {
     // get the current selected tab value  
       var currentTab = component.get("v.selTabId");
        
        if(currentTab == '2'){
            var status = component.get("v.enrichmentDone");
            if( status == 'true'){
                component.set("v.searchRinggoldTab" , false);
            }else{
                component.set("v.searchRinggoldTab" , true);
            }
          
          component.set("v.accEnrichmentTab" , false);
          component.set("v.selTabId" , '1');
            component.set("v.currentTabId" , '1');
        } else if(currentTab == '3'){
          var childCmp = component.find('addressValidation');
          var childStatus = JSON.stringify(childCmp.get('v.statusFail'));
           
            if(childStatus == 'false'){
            	alert('Account already submitted for approval');
            }else{
                component.set("v.accEnrichmentTab" , true);
          		component.set("v.searchRinggoldTab" , false);
          		component.set("v.selTabId" , '2'); 
            	component.set("v.currentTabId" , '2');
            }
          
        }
	},
    continueWithoutEnrichment : function(component, event, helper) {
    	helper.continueWithoutEnrichment(component);
	},
    disableTabSwitch : function(component, event, helper) {
        var tabId = component.get("v.currentTabId");
    	component.set("v.selTabId" , tabId );
	}
    
})