({
    
    init: function (cmp, event, helper) {   
         helper.getValidFileNames(cmp, event, helper);
        helper.getUploadedFiles(cmp, event);
          //var imageUrl = 'https://s3-euw1-ap-pe-df-pch-content-public-u.s3.eu-west-1.amazonaws.com/collection/6e2cc511-9346-43f5-8c43-aeb0c612946e/sal-roll_bannerimage.jpeg';
         //var newMapAttributes = {"src": imageUrl};
        //cmp.find("imgDiv").set("v.HTMLAttributes",newMapAttributes);
       },
    
    handleUploadFinished: function (cmp, event) {
        var uploadedFiles = event.getParam("files");
        var documentId = uploadedFiles[0].documentId;
        var fileName = uploadedFiles[0].name;
        var filesize=uploadedFiles[0].size;
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "File "+fileName+" Uploaded successfully."
        });
        toastEvent.fire();
        
        $A.get('e.lightning:openFiles').fire({
            recordIds: [documentId]
        });
    },
    
    onChange: function (cmp, evt, helper) {
        
        if(cmp.find("Imgselect").get("v.value")=='img_cover'){
        cmp.set("v.labelTitle",'Select cover image');
        cmp.set("v.saveTitle",'Save cover image');
        cmp.set("v.fileNameRule",'Note: file will be saved as businessId_cover.jpg/png!');
        cmp.set("v.selectedImageType",'cover');
        cmp.set("v.fileNameRule",'Note: file will be saved as '+ cmp.get("v.validCoverImageName") +'.jpg/png!');
  
        }else if(cmp.find("Imgselect").get("v.value")=='img_banner'){
        cmp.set("v.labelTitle",'Select banner image');
        cmp.set("v.saveTitle",'Save banner image');
        cmp.set("v.fileNameRule",'Note: file will be saved as businessId_banner.jpg/png!');
        cmp.set("v.selectedImageType",'banner');
        cmp.set("v.fileNameRule",'Note: file will be saved as '+ cmp.get("v.validBannerImageName") +'.jpg/png!');
  
        }
        
    },
       
    handleFilesChange: function(component, event, helper) {
        var fileInput = component.find("fileId").get("v.files");
        var file = fileInput[0];
        var fileExtension;
        
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
            fileExtension= fileName.split('.').pop().toLowerCase();
        }
        
        if(component.get("v.selectedImageType")=='banner'){
            component.set("v.fileName", component.get("v.validBannerImageName")+'.' +fileExtension);
        }else if(component.get("v.selectedImageType")=='cover'){
            component.set("v.fileName", component.get("v.validCoverImageName")+'.' +fileExtension);
        }
        //component.set("v.fileName", fileName); 
        component.set("v.fileSize", file.size);
       //calling save button functionality here..
         var size=component.get("v.fileSize");
        var ImageName=component.get("v.fileName");
        var varActualImageName = ImageName.split('.').slice(0, -1).join('.');
       if (component.get("v.fileName")=='No File Selected..') {
           var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": "Please upload the file",
                        "type":"Warning"
                    });
                    toastEvent.fire();
            
            return;
       }
        
        if (!fileName.endsWith('.png') && !fileName.endsWith('.jpg')&& !fileName.endsWith('.jpeg')){
           var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": "Please upload the file with jpg/png/jpeg extention!",
                        "type":"Warning"
                    });
                    toastEvent.fire();
            
            return;
       }
       
         if (size > 2097152) {
             var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": "File size cannot exceed 2 MB!",
                        "type":"Warning"
                    });
                    toastEvent.fire();
            
            return;
        }
        
         
        
        if (component.get("v.fileName")!='No File Selected..') {
            helper.getExitingUploadedImage(component, event);
           // helper.uploadImageFile(component, event);
        } else {
            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "File Upload Status!",
                "message": "Please select a valid file!"                    
            });
            toastEvent.fire();  
        }
        },
    
    doSave: function(component, event, helper) {
        var size=component.get("v.fileSize");
        var ImageName=component.get("v.fileName");
        var varActualImageName = ImageName.split('.').slice(0, -1).join('.');
       if (component.get("v.fileName")=='No File Selected..') {
           var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": "Please upload the file",
                        "type":"Warning"
                    });
                    toastEvent.fire();
            
            return;
       }
       
         if (size > 2097152) {
             var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": "File size cannot exceed 2 MB!",
                        "type":"Warning"
                    });
                    toastEvent.fire();
            
            return;
        }
        
         /*if(component.get("v.selectedImageType")=='banner'){
             if(varActualImageName!=component.get("v.validBannerImageName")){
                 var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": "Invalid File Name!",
                        "type":"Warning"
                    });
                    toastEvent.fire();
            
            return;
             }
             
        }else if(component.get("v.selectedImageType")=='cover'){
          
            if(varActualImageName!=component.get("v.validCoverImageName")){
                 var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": "Invalid File Name!",
                        "type":"Warning"
                    });
                    toastEvent.fire();
            
            return;
             }
        }*/
        
        if (component.get("v.fileName")!='No File Selected..') {
            helper.getExitingUploadedImage(component, event);
           // helper.uploadImageFile(component, event);
        } else {
            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "File Upload Status!",
                "message": "Please select a valid file!"                    
            });
            toastEvent.fire();  
        }
    },
    
    HideMe: function(component, event, helper) {
        component.set("v.ShowModal", false);
    },
    
    handleReplaceImage: function(component, event, helper) {
        helper.handleReplaceImageFromDB(component, event, helper);
    },
    
    deleteSelectedFile : function(component, event, helper){
        if( confirm("Confirm deleting this file?")){
            component.set("v.showSpinner", true); 
            helper.deleteUploadedFile(component, event);                
        }
    },
    
    previewFile : function(component, event, helper){  
        $A.get('e.lightning:openFiles').fire({ 
            recordIds: [event.currentTarget.id]
        });  
    },   
 
 
})