({
    init : function(component, event, helper) {
        helper.getAccountDetails(component);
        
    },
    next : function(component, event, helper) {
      // get the current selected tab value
        var currentTab = component.get("v.selTabId");
        if(currentTab == '1'){
            
          var childCmp = component.find('searchRG');
          var childRgId = JSON.stringify(childCmp.get('v.rgId'));
          component.set("v.ringgoldId" , childRgId); 
          var check = component.get("v.ringgoldId");
          if(check == 'null'|| check == null){
                alert('Further actions cannot be performed as Duplicate account found with the selected Ringgold Id Or Ringgold Id not selected');
          }else{
              component.set("v.selTabId" , '2');
              component.set("v.currentTabId" , '2');
              component.set("v.searchRinggoldTab" , false);
          	  component.set("v.accEnrichmentTab" , true);
          }
            $A.get('e.force:refreshView').fire();
        }
        if(currentTab == '2'){
          component.set("v.accEnrichmentTab" , false);
          component.set("v.searchRinggoldTab" , false);
          component.set("v.selTabId" , '3');  
          component.set("v.currentTabId" , '3');
          $A.get('e.force:refreshView').fire();
        }
        if(currentTab == '3'){
        	var childCmp = component.find('validateIP');
          	var validateCheck = JSON.stringify(childCmp.get('v.validateClicked'));
            var errorCheck = JSON.stringify(childCmp.get('v.validateFailed'));
            if(validateCheck == 'false'|| validateCheck == false || errorCheck == true || errorCheck == 'true'){
                alert('Further actions cannot be performed as Ips are not validated.');
            }else{
              component.set("v.selTabId" , '4');
              component.set("v.currentTabId" , '4');
              component.set("v.searchRinggoldTab" , false);
        	  component.set("v.accEnrichmentTab" , false);
                let button = component.find('disablebuttonidB');
    			button.set('v.disabled',true);
          }
        	
            $A.get('e.force:refreshView').fire();
        }
	},
    
    back : function(component, event, helper) {
     // get the current selected tab value  
       var currentTab = component.get("v.selTabId");
        
        if(currentTab == '3'){
          component.set("v.searchRinggoldTab" , false);
          component.set("v.accEnrichmentTab" , true);
          component.set("v.selTabId" , '2'); 
          component.set("v.currentTabId" , '2');
        }else if(currentTab == '2'){
          component.set("v.searchRinggoldTab" , true);
          component.set("v.accEnrichmentTab" , false);
          component.set("v.selTabId" , '1');
            component.set("v.currentTabId" , '1');
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