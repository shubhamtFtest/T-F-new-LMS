({
    MAX_FILE_SIZE: 2621440, //Max file size 2 MB 
    CHUNK_SIZE: 2621440, 
    
    getValidFileNames: function(component, event) {
        var action = component.get("c.getvalidImageName");
        action.setParams({
            bundleID: component.get("v.recordId")
            
        });
        
        // set call back 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();  
                component.set("v.validBannerImageName",result.banner);
                component.set("v.validCoverImageName",result.cover);
                //alert(component.get("v.validBannerImageName"));
                //alert(component.get("v.validCoverImageName"));
                if(component.get("v.selectedImageType")=='banner'){
                    component.set("v.fileNameRule",'Note: file will be saved as '+ component.get("v.validBannerImageName") +'.jpg/png!');
                }else if(component.get("v.selectedImageType")=='cover'){
                    component.set("v.fileNameRule",'Note: file will be saved as '+ component.get("v.validCoverImageName") +'.jpg/png!');
                }
            }
        });
        var startTime = performance.now();
        $A.enqueueAction(action);
    },
    
    getExitingUploadedImage: function(component, event) {
        //var action = component.get("c.getUploadedImage");
        
        var action = component.get("c.fetchFilesWithTitle");
        action.setParams({
            linkedRecId:component.get("v.recordId"),
            title:component.get("v.fileName")
        });
        
        // set call back 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue(); 
                if(result==true){
                    component.set("v.isImageAlreadyExist",'true');
                    component.set("v.ShowModal",'true');
                }
                else if(result==false){
                    this.uploadHelper(component, event);
                    component.set("v.isImageAlreadyExist",'false');
                    component.set("v.ShowModal",'false');
                    
                }
                
              /*  if(result.length>0){
               
                 if(result[0].ContentDocument.Title.includes('banner') && component.get("v.selectedImageType")=='banner'){
                    component.set("v.isImageAlreadyExist",'true');
                    component.set("v.ShowModal",'true');
                }
                else if(result[0].ContentDocument.Title.includes('cover') && component.get("v.selectedImageType")=='cover'){
                     component.set("v.isImageAlreadyExist",'true');
                    component.set("v.ShowModal",'true');
                }
                else if(result.length==0){
                    this.uploadHelper(component, event);
                    component.set("v.isImageAlreadyExist",'false');
                    component.set("v.ShowModal",'false');
                    
                }
                    
                     }
                else if(result.length==0 ){
                    this.uploadHelper(component, event);
                    component.set("v.isImageAlreadyExist",'false');
                    component.set("v.ShowModal",'false');
                    
                }*/
            }
        });
        var startTime = performance.now();
        $A.enqueueAction(action);
    },
    
    handleReplaceImageFromDB:function(component, event){
        var action = component.get("c.deleteFileWithTitle");
        action.setParams({
            recordId: component.get("v.recordId"),
            title: component.get("v.fileName")
        });
        
        // set call back 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();  
                if(result==true){
                    component.set("v.ShowModal", false);
                    this.uploadHelper(component, event);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Image Upload Status!",
                        "message": "Image has been replaced!"                    
                    });
                    toastEvent.fire(); 
                }
                else if(result==false){
                    
                }
            }
        });
        var startTime = performance.now();
        $A.enqueueAction(action);
    },
    
    saveFileForCollection:function(component, event){
        var fileInput = component.find("fileId").get("v.files");
        var file = fileInput[0];
        var objFileReader = new FileReader();
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            
            fileContents = fileContents.substring(dataStart);
            this.uploadProcess(component, file, fileContents);
        });
        
        objFileReader.readAsDataURL(file);
        
    },
    
    uploadHelper: function(component, event) {
        var fileInput = component.find("fileId").get("v.files");
        var file = fileInput[0];
        var self = this;
        /*if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
            return;
        }*/
        
        var objFileReader = new FileReader();
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            
            fileContents = fileContents.substring(dataStart);
            //fileContents= fileContents;
            self.uploadImage(component, file, fileContents,'');
        });
        
        objFileReader.readAsDataURL(file);
    },
    
    uploadImage: function(component, file, fileContents, attachId) {
        var getchunk = fileContents;
        var action = component.get("c.uploadFile");
        action.setParams({
            bundleID:component.get("v.recordId"),
            //fileName: file.name,
            fileName:component.get("v.fileName"),
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId
        });
        
        // set call back 
        action.setCallback(this, function(response) {
            attachId = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.IsSpinner", false);
                this.getUploadedFiles(component);
                this.showToast('Success','Success','File Uploaded successfully');   
                
            } else if (state === "INCOMPLETE") {
                this.showToast('Error','Error','Issue in uploading File '+response.getReturnValue());   
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        this.showToast('Error','Error','Issue in uploading File '+errors[0].message);   
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
        component.set("v.showSpinner", true); 
        component.set("v.IsSpinner", true); 
    },
    
    showToast : function(type, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": type,
            "title": title,
            "message": message
        });
        toastEvent.fire();
    },
    
    getUploadedFiles : function(component, event){
       /*  var action = component.get("c.getFiles");  
        action.setParams({  
            "recordId": component.get("v.recordId") 
        });      
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){  
                var result = response.getReturnValue();           
                component.set("v.files",result);  
            }  
        });  
        $A.enqueueAction(action);  */
        var action = component.get("c.fetchFiles");
        
        action.setParams({
            "linkedRecId" : component.get("v.recordId")
        });
        
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                var result = response.getReturnValue()
                component.set("v.filesIds",result);
            }
        });
        $A.enqueueAction(action);
        
    }, 
    
    deleteUploadedFile : function(component, event) {  
        var action = component.get("c.deleteFile");           
        action.setParams({
            "contentDocumentId": event.currentTarget.id            
        });  
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){  
                component.set("v.IsSpinner", false); 
                this.getUploadedFiles(component);
                // show toast on file deleted successfully
                this.showToast('Success','Success','File has been deleted successfully!');  
            }  
        });  
        $A.enqueueAction(action);
        component.set("v.IsSpinner", true); 
    },   
    
    
})