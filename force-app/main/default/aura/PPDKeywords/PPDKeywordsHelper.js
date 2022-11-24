({
    fetchKeywords: function (cmp) {
        var action = cmp.get("c.getKeywords");
        action.setParams({
            "prodId": cmp.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue(); 
            if(result != null && result != ''){ 
                cmp.set('v.data', JSON.parse(result));
            }
        });
        $A.enqueueAction(action);
    },
    
    addWords: function (cmp, event) {
        
        var fulldata = [];
        var newFulldata = []
        var keyWrds = cmp.get("v.name");
        var keyWordsList = keyWrds.split(",");
        //  var uniqueKeysEntered = [];
        //  var uniqueKeysEnteredUpper = [];
        var fullUniqueKeyWords = [];
        var storedKeywords = [];
        //  var storedKeywordsUpper = [];
        var uniqueNamesReturned = [];  
        
        fulldata = cmp.get("v.data");
        uniqueNamesReturned = this.getUniqueKeywordList(fulldata,keyWordsList);
        
        fulldata.forEach(function(val, index){
            storedKeywords.push(val.name);
        })
        
        fullUniqueKeyWords = storedKeywords.concat(uniqueNamesReturned);
        
        fullUniqueKeyWords.forEach(function(val, index){
            var dat = {"name":val.trim(),
                       "description":val.trim().toUpperCase().replace(/\s+/g, ''),
                       "position":index +1
                      };
            newFulldata.push(dat);
            
        })
        cmp.set("v.data",newFulldata);
        this.updatePrdKeyWords(cmp);
    },
    
    deleteKeyWords: function (cmp, row) {
        var rows = cmp.get('v.data');
        var rowIndex = rows.indexOf(row);
        rows.splice(rowIndex, 1);
        rows.forEach(function(val, index){
            val.position = index + 1 ;
        })
        cmp.set('v.data', rows);
        this.updatePrdKeyWords(cmp);
    },
    
    editKeyWords: function (cmp, row) {
        var rows = cmp.get('v.data');
        cmp.set("v.isOpen", true);
        cmp.set("v.name",row.name);
        cmp.set("v.position",row.position);
        cmp.set("v.rowdata",row);
        cmp.set("v.rowIndx",rows.indexOf(row));
    },
    
    updateKeyWords: function (cmp,event) {
        var rowModified = cmp.get("v.rowdata");
        var keyWordsList = [];
        var uniqueNamesReturned = [];
        var rows = cmp.get("v.data");
        var rowIndex = cmp.get("v.rowIndx");
        var datList = [];        
        keyWordsList =(cmp.get("v.name").trim()).split(",");
        var keyWordsListUpper = [];
        var originalNameexists = "false";
        
        keyWordsList.forEach(function(val, index){
            keyWordsListUpper.push(val.trim().toUpperCase());
        })
        if((rowModified.name).trim().toUpperCase() != (cmp.get("v.name")).trim().toUpperCase()){
            uniqueNamesReturned = this.getUniqueKeywordList(rows,keyWordsList);
            if(keyWordsListUpper.indexOf(rowModified.name.trim().toUpperCase()) == -1){
                rows.splice(rowIndex, 1);
            }else{
                var updRow = rows[rowIndex] ;
                rows.splice(rowIndex, 1);
                rows.splice(Number(cmp.get("v.position")) - 1, 0,updRow);
                originalNameexists = "true";
            }
            if(uniqueNamesReturned.length > 0){
                var UniNameLength = uniqueNamesReturned.length ;
                for(var i=0; i < UniNameLength; i++ ){
                    var val = uniqueNamesReturned.pop();
                    var dat = {"name":val,
                               "description":val.trim().toUpperCase().replace(/\s+/g, ''),
                               "position":rowIndex +1
                              };
                    if(originalNameexists == "true"){
                        rows.splice(Number(cmp.get("v.position")), 0,dat);
                        
                    }else{
                        rows.splice(Number(cmp.get("v.position")) - 1, 0,dat);
                        
                    }
                }
                cmp.set("v.isOpen", false);
                rows.forEach(function(val, index){
                    val.position = index + 1 ;
                })
                cmp.set('v.data', rows);
            }else{
                var msg = 'Keyword already exists';
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "message": msg
                });
                toastEvent.fire(); 
            }
        }else{
            rowModified.name = cmp.get("v.name").trim();
            rowModified.description = (cmp.get("v.name")).trim().toUpperCase().replace(/\s+/g, '');
            rowModified.position = Number(cmp.get("v.position"));
            rows.splice(rowIndex, 1);
            rows.splice(Number(cmp.get("v.position")) - 1, 0,rowModified);
            rows.forEach(function(val, index){
                val.position = index + 1 ;
            })
            cmp.set('v.data', rows);
            cmp.set("v.isOpen", false);
        }
        this.updatePrdKeyWords(cmp);
    },
    
    getUniqueKeywordList: function (fulldata,keyWordsList){
        
        var storedKeywords = [];
        var storedKeywordsUpper = [];
        var uniqueKeysEntered = [];
        var uniqueKeysEnteredUpper = [];
        var uniqueNames = []; 
        fulldata.forEach(function(val, index){
            storedKeywords.push(val.name);
            storedKeywordsUpper.push(val.name.trim().toUpperCase());
        })
        
        keyWordsList.forEach(function(val, index){
            if(uniqueKeysEnteredUpper.indexOf(val.trim().toUpperCase()) == -1  && val.trim() != ''){
                uniqueKeysEnteredUpper.push(val.trim().toUpperCase());
                uniqueKeysEntered.push(val);
            }
        })
        
        uniqueKeysEntered.forEach(function(val, index){
            if(storedKeywordsUpper.indexOf(val.trim().toUpperCase()) == -1){
                uniqueNames.push(val);
            }
        })
        return uniqueNames ;
        
    },
    
    updatePrdKeyWords: function(cmp){
        var data ;
        if(cmp.get("v.data").length == 0){
            data = '';
        }else{
            data = JSON.stringify(cmp.get("v.data"));
        }
        if(data.length < 32768){
            var action = cmp.get("c.updateKeywords");
            action.setParams({
                "prodId": cmp.get("v.recordId"),
                "contJSON": data
            });
            action.setCallback(this, function(response) {
                var result = response.getReturnValue(); 
                if(result != null && result != 'success'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": result
                    });
                    toastEvent.fire(); 
                }
            });
            $A.enqueueAction(action);
            
        }else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "message": 'Could not add Keyword, delete some existing keywords to add new'
            });
            toastEvent.fire(); 
        }
    }
})