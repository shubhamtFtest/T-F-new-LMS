({
    handleFilesChange: function(component, event, helper) {
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
        }
        
        //If the max file size is over the limit flag to the user.
        if(event.getSource().get("v.files")[0].size > MAX_FILE_SIZE){
            component.set("v.fileTooLarge", true);
            fileName = 'Please ensure file size is less than 2MB';
        }
        component.set("v.fileName", fileName);
    },   
    closeBulkUpdateModel: function(component, event, helper) { 
        component.set("v.isBulkUpdateModalOpen", false);
    },
    doUpdate: function(component, event, helper) {
        var fileInput = component.find("file").get("v.files");
        if(fileInput == null){
            component.set("v.fileName", 'Alert : Please select CSV file to import.');
        } else {
            component.set("v.spinner", true);
            var file = fileInput[0];
            console.log("File::"+file);
            var reader = new FileReader();            
            reader.readAsText(file, "UTF-8");
            reader.onload = function (evt) {
                console.log("EVT FN");
                var csv = evt.target.result;
                console.log('@@@ csv file contains'+ csv);
                var result = helper.CSV2JSON(component,csv);
                console.log('@@@ result = ' + result);
                //console.log('@@@ Result = '+JSON.parse(result));
                window.setTimeout($A.getCallback(function(){
                    helper.bulkUpdateOpportunityLineItems(component,result);
                }), 10);                
            }
            reader.onerror = function (evt) {
                console.log("error reading file");
            }
        }       
    }
})