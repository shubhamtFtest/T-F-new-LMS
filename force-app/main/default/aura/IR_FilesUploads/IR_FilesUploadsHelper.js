({
MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
CHUNK_SIZE: 750000,      //Chunk Max size 750Kb 
//Update the fileName colour to show black if the size is under 2MB again.
		changeFileNameFontColourOk: function(component, event) {
		  
},
		//Update the fileName colour to show red when a file is uploaded over 2MB.
		changeFileNameFontColour: function(component, event) {
		   
},
_invoke: function(component, parameters, onSuccessCallback, onErrorCallback) {
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
			let parameters = {
				action: "InsertAttach:Attachments",
				parameters: {
					parentId:component.get("v.parentId"),
					fileName:filename,
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
},
UpdatePrintOrder: function(component, event, helper) {
			component.set("v.ShowModel",false);  
			component.set("v.spinner",true);  

var dateval = component.find("DateField").get("v.value");
	var Updaterecid=component.get("v.recordId");
 console.log(dateval); 
	 let parameters = {
		action: "Printorder:UpdatePrintOrder",
		parameters: {
			recordId    : Updaterecid,
			DeliveryDate: dateval 
		}
	};
let onSuccess = $A.getCallback(response => { // Custom success callback
		//  component.set("v.spinner",true);  

			 var PrintOrderItem;
		for (var i = 0; i < response.length; i++) { 
		PrintOrderItem= response[i].PrintOrderItemList; 
	}
	component.set("v.PrintorderiteamList",PrintOrderItem);  
	component.set("v.PrintOrder",response);  
	console.log('List of PrintOrderIteam'+JSON.stringify(PrintOrderItem)); 
			component.set("v.spinner",false);  

});

let onError = $A.getCallback(errors => { // Custom error callback
									component.set("v.spinner",false);  

});
this._invoke(component, parameters, onSuccess, onError);
}
})