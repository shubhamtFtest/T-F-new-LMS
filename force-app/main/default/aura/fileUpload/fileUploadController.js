({
  
    doSave: function(component, event, helper) {
        if (component.find("fileId").get("v.files").length > 0) {
            helper.uploadHelper(component, event);
        } else {
           
               var toastEvent = $A.get("e.force:showToast");
                      toastEvent.setParams({
                      "title": "File Upload Status!",
                      "message": "Please select a valid file!"                    
                        });
                       toastEvent.fire();  
        }
    },
 
    handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    },
    //for getting flow variable
    
    
})