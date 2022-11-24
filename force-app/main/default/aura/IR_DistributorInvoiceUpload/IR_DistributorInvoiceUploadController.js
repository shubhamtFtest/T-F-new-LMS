({
	 onInit : function(component, event, helper) {
        var recid=component.get("v.recordId");
        component.set("v.parentId",recid);
         	helper.fetchRecords(component,'');

    }, closeInvoiceUploadModel: function(component, event, helper) { 
        component.set("v.isOpenInvoiceUploadModal", false);
    },  
    doSave: function(component, event, helper) {
        if (component.find("fileId").get("v.files").length > 0) {
            helper.uploadHelper(component, event);
        } else {
            alert('Please Select a Valid File');
        }
    },
    removeFile : function(component, event, helper) {
        var currentFileName = component.get("{!v.fileName}");
        if(currentFileName != 'No File Selected..'){
            //Make the link disappear.
            component.set("v.removeButtonLabel", "");
            component.set("v.fileName", "");
            component.set("v.fileTooLarge", false);
        }
    }, handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected..';
        var MAX_FILE_SIZE = 2000000; //Max file size is 2MB
        //Set the maximum file size attribute to be used later in the helper.
        component.set("v.maxFileSize", MAX_FILE_SIZE);
        
        //Show the 'remove' button link next to the file.
        component.set("v.removeButtonLabel", "Remove");
        
        //If file size is under the limit.
        if (event.getSource().get("v.files").length > 0) {
            component.set("v.isdisabled",false);

            //If file length is ok.
            component.set("v.fileTooLarge", false);
            fileName = event.getSource().get("v.files")[0]['name'];
            helper.changeFileNameFontColourOk(component, event);
        }
        
        //If the max file size is over the limit flag to the user.
        if(event.getSource().get("v.files")[0].size > MAX_FILE_SIZE){
            component.set("v.fileTooLarge", true);
            helper.changeFileNameFontColour(component, event);
            fileName = 'Please ensure file size is less than 2MB';
        }
        component.set("v.fileName", fileName);
    },closeInvoiceUploadModel: function(component, event, helper) { 
        component.set("v.isOpenInvoiceUploadModal", false);
    },    
})