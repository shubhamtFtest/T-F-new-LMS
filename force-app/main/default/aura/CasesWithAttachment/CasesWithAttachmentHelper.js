({
    getCaseDetails : function(component, event, helper) {
        var action = component.get("c.getData");
        action.setCallback(this, function(result){
            var response = result.getReturnValue();
            console.log(response);
            
            var ids =[];
            for(var i in response){
                ids.push({
                    Name : i,
                    Case : response[i]
                });
                //alert(i); // alerts key
                //alert(response[i]); //alerts key's value
            }
            console.log(ids);
            console.log(JSON.stringify(ids));
            component.set("v.attachmentDetails", ids);
            
        });
        $A.enqueueAction(action);
    },
    convertArrayOfObjectsToCSV : function(component,objRecords){
        //alert('Im in Helper Class');
        console.log(objRecords);
        var csvStringResult,counter,keys,lineDivider,columnDivider;
        if(objRecords==null || !objRecords.length)
        {
            return null;         
        }
        columnDivider=',';
        lineDivider='\n';
        keys=['Owner','CaseNumber','Id','Subject','Status','Priority','FileName'];
        csvStringResult='';
        csvStringResult+=keys.join(columnDivider);
        csvStringResult+=lineDivider;
        console.log(objRecords.length);
        for(var i=0;i<objRecords.length;i++){
            counter=0;
            for(var tempKey in keys){
                //console.log(tempKey);
                var skey=keys[tempKey];
                //console.log(skey);
                if(counter>0)
                {
                    csvStringResult+=columnDivider;
                }
                //console.log(objRecords[i].Case[0]);
                //console.log(objRecords[i][skey]);
                if(skey==='FileName'){
                    //console.log(objRecords[i].Name);
                    csvStringResult+='"'+objRecords[i].Name+'"';
                    counter ++;
                }
                else if(skey==='Owner'){
                    //console.log(objRecords[i].Case[0].Owner.Name);
                    csvStringResult+='"'+objRecords[i].Case[0].Owner.Name+'"';
                    counter ++;
                }
                else if(skey==='CaseNumber'){
                    //console.log(objRecords[i].Case[0].CaseNumber);
                    csvStringResult+='"'+objRecords[i].Case[0].CaseNumber+'"';
                    counter ++;
                }
                else if(skey==='Id'){
                    //console.log(objRecords[i].Case[0].Id);
                    csvStringResult+='"'+objRecords[i].Case[0].Id+'"';
                    counter ++;
                }
                else if(skey==='Subject'){
                    //console.log(objRecords[i].Case[0].Subject);
                    csvStringResult+='"'+objRecords[i].Case[0].Subject+'"';
                    counter ++;
                }
                else if(skey==='Priority'){
                    //console.log(objRecords[i].Case[0].Priority);
                    csvStringResult+='"'+objRecords[i].Case[0].Priority+'"';
                    counter ++;
                }
            }
            csvStringResult+=lineDivider;
        }
        return csvStringResult
        console.log(csvStringResult);
    }
})