({
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 4500000,      //Chunk Max size 4.5mb 
    fetchRecords: function(component,row,sortField) { 
        console.log('recordId'+component.get("v.recordId"));
        var recid=component.get("v.recordId");
        component.set("v.parentId",recid);
        
        let parameters = {
            action: "Printorder:PrintorderRecDetail",
            parameters: {
                recordId: recid 
            }
        };
        let onSuccess = $A.getCallback(response => { // Custom success callback
            var PrintOrderItem;
            var PrintOrderFiles;
            console.log('response.length'+JSON.stringify(response));
            for (var i = 0; i < response.length; i++) { 
            PrintOrderItem= response[i].PrintOrderItemList; 
            PrintOrderFiles= response[i].PrintOrderFiles;
            
        }
                                       component.set("v.PrintorderiteamList",PrintOrderItem);  
        component.set("v.PrintOrder",response);  
        component.set("v.lstContentDoc", PrintOrderFiles);
          component.set("v.isCreditReq", response[0].isCreditReq);
        component.set("v.isDistributerCheckForsave",response[0].isdistributor);
        component.set("v.showuploadbutton",response[0].isPrinter);
        component.set("v.isApproved",response[0].isapproved); 
        component.set("v.isDocumentApproved",response[0].DocumentApproved);  
        component.set("v.islock",response[0].isLock);  
        component.set("v.isPrinter",response[0].isPrinter);  
        
        console.log('List of PrintOrderIteam');            
    });
    
    let onError = $A.getCallback(errors => { // Custom error callback
});
this._invoke(component, parameters, onSuccess, onError);
},//Update the fileName colour to show black if the size is under 2MB again.
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
                        },
                            UpdatePrintOrder: function(component, event, helper) {
                                component.set("v.ShowModel",false);  
                                component.set("v.spinner",true);  
                                
                                var dateval = component.find("DateField").get("v.value");
                                var Updaterecid=component.get("v.recordId");
                                var Remarks=component.find("Remarks").get("v.value");
                                
                                let parameters = {
                                    action: "Printorder:UpdatePrintOrder",
                                    parameters: {
                                        recordId    : Updaterecid,
                                        DeliveryDate: dateval,
                                        Remarks     :Remarks
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
                                location.reload();
                            });
                            
                            let onError = $A.getCallback(errors => { // Custom error callback
                            component.set("v.spinner",false);  
                            
                        });
                        this._invoke(component, parameters, onSuccess, onError);
                    },
                        // Save record after Approval
                        SaveRecords: function(component,row,sortField) {
                            
                            var isapproved=component.get("v.isApproved");
                            let parameters = {
                                action: "Printorder:SavePrintOrderRecord",
                                parameters: {
                                    recordId:component.get("v.recordId"),
                                    isapproved:isapproved
                                }
                            };
                            let onSuccess = $A.getCallback(response => { // Custom success callback
                                component.set("v.spinner",false);  
                            });
                                
                                let onError = $A.getCallback(errors => { // Custom error callback
                            });
                                this._invoke(component, parameters, onSuccess, onError);                              
                            },
                                ExportExcel: function(component,row,sortField) {
                                    var SelectedList = [];
                                    var checkvalue = component.find("checkPrintitems");
                                    
                                    if(!Array.isArray(checkvalue)){
                                        if (checkvalue.get("v.value") == true) {
                                            SelectedList.push(checkvalue.get("v.text"));
                                        }
                                    }else{
                                        for (var i = 0; i < checkvalue.length; i++) {
                                            if (checkvalue[i].get("v.value") == true) {
                                                SelectedList.push(checkvalue[i].get("v.text"));
                                            }
                                        }
                                    }
                                    component.set("v.spinner",true);  
                                    
                                    console.log('selectedRec-' + SelectedList);
                                    
                                    let parameters = {
                                        action: "Printorder:ExportExcel",
                                        parameters: {
                                            SelectedList:SelectedList
                                        }
                                    };
                                    
                                    let onSuccess = $A.getCallback(response => { // Custom success callback
                                        component.set("v.spinner",false); 
                                        var stockData = response
                                        // call the helper function which "return" the CSV data as a String   
                                        var csv = this.convertArrayOfObjectsToCSV(component, stockData);    
                                        if (csv == null){return;}             
                                        var hiddenElement = document.createElement('a');
                                        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
                                        hiddenElement.target = '_self'; // 
                                        hiddenElement.download = 'ExportPrintItemsData.csv';  // CSV file Name* you can change it.[only name not .csv] 
                                        document.body.appendChild(hiddenElement); // Required for FireFox browser
                                        hiddenElement.click(); // using click() js function to download csv file
                                    });
                                        
                                        let onError = $A.getCallback(errors => { // Custom error callback
                                    });
                                        this._invoke(component, parameters, onSuccess, onError);                                          
                                    },
                                        
                                        convertArrayOfObjectsToCSV : function(component, objectRecords){
                                            // declare variables
                                            var csvStringResult, counter,keysheadeer, keys, columnDivider, lineDivider;      
                                            // check if "objectRecords" parameter is null, then return from function
                                            if (objectRecords == null || !objectRecords.length) {
                                                return null;
                                            }
                                            // store ,[comma] in columnDivider variabel for sparate CSV values and 
                                            // for start next line use '\n' [new line] in lineDivider varaible  
                                            columnDivider = ',';
                                            lineDivider =  '\n';
                                            // in the keys valirable store fields API Names as a key 
                                            // this labels use in CSV file header  
                                            keys = ['Id','ISBN__c','Indian_Isbn__c','Title__c','List_Price_GBP__c','MRP__c','Customer_Quote__c','UMC__c'];
                                            keysheadeer = ['Id','ISBN','IndiaISBN','Title','ListPriceGBP','MRP','CustomerQuote','UMC'];       

                                            csvStringResult = '';
                                            csvStringResult += keysheadeer.join(columnDivider);
                                            csvStringResult += lineDivider;
                                            
                                            for(var i=0; i < objectRecords.length; i++){   
                                                counter = 0;          
                                                for(var sTempkey in keys) {
                                                    var skey = keys[sTempkey] ;  
                                                    // add , [comma] after every String value,. [except first]
                                                    if(counter > 0){ 
                                                        csvStringResult += columnDivider; 
                                                    }                  
                                                    csvStringResult += '"'+ objectRecords[i][skey]+'"';                
                                                    counter++; 
                                                } // inner for loop close 
                                                csvStringResult += lineDivider;
                                            }// outer main for loop close 
                                            
                                            // return the CSV formate String 
                                            return csvStringResult;        
                                        }              
                                    })