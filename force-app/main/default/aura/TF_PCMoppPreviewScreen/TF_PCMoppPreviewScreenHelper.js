({
	//shalini; To show dynamic tost messages
    showToastMessage:function(component,event,helper,message,title,type){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title,
            message:message,
            messageTemplate: 'Mode is pester ,duration is 2sec and Message is overrriden',
            duration:'100',
            key: 'info_alt',
            type: type,
            mode: 'Timed'
        });
        toastEvent.fire();
    }, 
    
    CSV2JSON: function (component,csv) {
        debugger;
        var arr = []; 
        
        arr =  csv.split('\n');
        console.log('arr = '+arr);
        arr.pop();
        var jsonObj = [];
        var headers = arr[0].split(',');
        console.log('headers--> '+headers);
        for(var i = 1; i < arr.length; i++) {
            var data = arr[i].split(',');
            var obj = {};
            for(var j = 0; j < data.length; j++) {
                
                if(data[j].includes('"'))
                {
                    console.log('CSV contains comma');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message: 'Something is wrong in CSV file, please check it and try again!!',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    return;
                }
                else{
                    obj[headers[j].trim()] = data[j].trim();
                    console.log('obj headers = ' + obj[headers[j].trim()]);
                }
                
            }
            jsonObj.push(obj);
        }
        
        var json = JSON.stringify(jsonObj);
        console.log('json = '+json.length+' '+ json);
        return json;
    },
})