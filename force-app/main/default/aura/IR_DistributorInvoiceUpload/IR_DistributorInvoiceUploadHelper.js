({
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb 
   	 fetchRecords: function(component,row,sortField){
        let parameters = {
            action: "Printorder:uploadDistrInvoice",
            parameters: {
                recordId: component.get("v.recordId") 
            }
        };
        let onSuccess = $A.getCallback(response => { // Custom success callback
            if(response==true){
            component.set("v.profcheck",false);  
        }else{
        component.set("v.profcheck",true);  
    }
});


let onError = $A.getCallback(errors => { // Custom error callback
});
this._invoke(component, parameters, onSuccess, onError);
},
    changeFileNameFontColourOk: function(component, event) {
        
    }, _invoke: function(component, parameters, onSuccessCallback, onErrorCallback) {
        const server = component.find('server');
        const serversideAction = component.get("c.invoke");
        if (server) {
            server.invoke(
                serversideAction, // Server-side action
                parameters, // Action parameters
                false, // Disable cache if false
                onSuccessCallback,
                onErrorCallback,
                true //enable error notifications
            );
        }
    },uploadHelper: function(component, event) {
        component.set("v.spinner",true);  
        var fileInput = component.find("fileId").get("v.files");
        // get the first file using array index[0]  
        var file = fileInput[0];
        var self = this;
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
            return;
        }
        
        // create a FileReader object 
        var objFileReader = new FileReader();
        // set onload function of FileReader object   
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            
            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method
            self.uploadProcess(component, file, fileContents);
        });
        
        objFileReader.readAsDataURL(file);
    },
    
    uploadProcess: function(component, file, fileContents) {
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
        
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '');
    },
    
    
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId) {
        var getchunk = fileContents.substring(startPosition, endPosition);
        var Selectedval = component.get("v.Selectedval");
        var filename=Selectedval+'_'+file.name;
        var str=component.get("v.oppRecordId");
        var invoiceNo=component.find("invoiceNo").get("v.value");
         var isichar= invoiceNo.charAt(invoiceNo.length-1);
        console.log('!!!!'+isichar);
        if(isichar!='i' && isichar!='I'){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error Message',
            message:'Please Enter a valid Invoice Number!',
            messageTemplate: 'Mode is pester ,duration is 5sec and Message is overrriden',
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
                        window.location.reload();

        }
        else{
            //Add Attachment Upload with opp,oli, update oli with attachmentid
            let parameters = {
                action: "InsertAttach:Attachments",
                parameters: {
                    InvoiceNo:invoiceNo,
                    parentId:component.get("v.parentId"),
                    fileName: filename,
                    base64Data: encodeURIComponent(getchunk),
                    contentType: file.type,
                    fileId: attachId      
                }
            };
        
        
        let onSuccess = $A.getCallback(response => { // Custom success callback
            component.set("v.PrintorderList",response);
            console.log('response.active'+JSON.stringify(response));
            startPosition = endPosition;
            endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
            if (startPosition < endPosition) {
            this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId);
        } else {
            alert('Your File is uploaded successfully');
            component.set("v.spinner",false);  
            window.location.reload();
            
        }    
        });
            
            let onError = $A.getCallback(errors => { // Custom error callback
            var errors = response.getError();
            if (errors) {
            if (errors[0] && errors[0].message) {
            console.log("Error message: " + errors[0].message);
        }
        }
        });
            
            this._invoke(component, parameters, onSuccess, onError);
        }
            // Save record after Approval
        }
        })