({
    fetchContributors: function (cmp) {
        var action = cmp.get("c.getContributors");
        action.setParams({
            "prodId": cmp.get("v.recordId"),
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue(); 
            if(result != null && result != ''){ 
                cmp.set('v.data', JSON.parse(result));
            }
        });
        $A.enqueueAction(action);
        
    },
    editContributor: function (cmp, row) {
        var rows = cmp.get('v.data');
        cmp.set("v.isOpen", true);
        cmp.set("v.name",row.name);
        cmp.set("v.givenname",row.givenName);
        cmp.set("v.familyname",row.familyName);
        cmp.set("v.role",row.role);
        cmp.set("v.position",row.position);
        cmp.set("v.rowdata",row);
        cmp.set("v.rowIndx",rows.indexOf(row));
    },
    
    deleteContributor: function (cmp, row) {
        var rows = cmp.get('v.data');
        var rowIndex = rows.indexOf(row);
        rows.splice(rowIndex, 1);
        rows.forEach(function(val, index){
            val.position = index + 1 ;
        })
        cmp.set('v.data', rows);
        this.updatePrdContributors(cmp);
        
    },
    
    updateContributor: function (cmp, event) {
        var rowModified = cmp.get("v.rowdata");
        
        var rows = cmp.get("v.data");
        var rowIndex = cmp.get("v.rowIndx");
        rowModified.name = cmp.get("v.name");
        rowModified.givenName = cmp.get("v.givenname");
        rowModified.familyName = cmp.get("v.familyname");
        rowModified.role = cmp.get("v.role");
        rowModified.position = Number(cmp.get("v.position"));
        cmp.set("v.rowdata",rowModified);
        var dup = this.checkUpdateDuplicates(rows,rowModified,rowIndex);
        if(dup != 'true'){
            rows.splice(rowIndex, 1, rowModified);
            cmp.set("v.data", rows);
            cmp.set("v.isOpen", false);
            this.updatePrdContributors(cmp);
        }
    },
    
    addContributor: function (cmp, event) {
        
        var fulldata = [];
        fulldata = cmp.get("v.data");
        var allValid = cmp.find('field').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        var name = cmp.get("v.name");
        var givenName = cmp.get("v.givenname");
        var familyName = cmp.get("v.familyname");
        var role = cmp.get("v.role");
        var position = fulldata.length + 1;
        
        if (allValid) {
            var data = {"name":name,"givenName":givenName,"familyName":familyName,"role":role,"position":position};
            var dup = this.checkDuplicates(fulldata,data);
            if(dup != 'true'){
                fulldata.push(data);
                cmp.set("v.data",fulldata);
                this.updatePrdContributors(cmp);                
            }
            
        } else {
            var msg = 'Please update the invalid form entries and try again.';
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "message": msg
            });
            toastEvent.fire(); 
        }
    },
    
    checkDuplicates: function (fulldat, dat){
        var dup = 'false';
        if(fulldat.length > 0){
            fulldat.forEach(function(val, index){
                if((val.name.trim().concat(val.role.trim())).toUpperCase()  == (dat.name.trim().concat(dat.role.trim())).toUpperCase()){
                    dup = 'true';
                    var msg = 'Contributor record with same Name and Role already exists';
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": msg
                    });
                    toastEvent.fire(); 
                }
            })
        }
        return dup;
    },
    
    checkUpdateDuplicates: function (fulldat, dat, indx){
        var dup = 'false';
        if(fulldat.length > 0){
            fulldat.forEach(function(val, index){
                if((((val.name.trim().concat(val.role.trim())).toUpperCase())  == ((dat.name.trim().concat(dat.role.trim())).toUpperCase())) && indx != index ){
                    dup = 'true';
                    var msg = 'Contributor record with same Name and Role already exists';
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": msg
                    });
                    toastEvent.fire(); 
                }
            })
        }
        return dup;
    },
    
    updatePrdContributors: function(cmp){
        this.sortData(cmp,'position','asc');
        var data ;
        if(cmp.get("v.data").length == 0){
            data = '';
        }else{
            data = JSON.stringify(cmp.get("v.data"));
        }
        if(data.length < 32768){
            var action = cmp.get("c.updateContributors");
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
                "message": 'Could not add Contributor, delete some existing contributors to add new'
            });
            toastEvent.fire(); 
        }
        
    },
    
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.data");
        var reverse = sortDirection !== 'asc';
        
        data = Object.assign([],
                             data.sort(this.sortBy(fieldName, reverse ? -1 : 1))
                            );
        cmp.set("v.data", data);
    },
    
    sortBy: function (field, reverse, primer) {
        var key = primer
        ? function(x) { return primer(x[field]) }
        : function(x) { return x[field] };
        
        return function (a, b) {
            var A = key(a);
            var B = key(b);
            return reverse *(A - B);
            //return reverse * ((A > B) - (B > A));
        };
    },
})