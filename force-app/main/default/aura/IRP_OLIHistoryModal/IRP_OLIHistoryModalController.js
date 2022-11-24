({
    doInit: function(component, event, helper) {              
        helper.getOLIHistory(component);
    },    
    closeHistoryModel: function(component, event, helper) { 
        component.set("v.isHistoryModalOpen", false);
    },
    saveFinalUMC: function(component, event, helper){        
        helper.saveFinalUMCHelper(component, event, helper);
    },
    DeleteRec: function(component, event, helper){        
        helper.deleteOliHistory(component, event, helper);
    }
    
})