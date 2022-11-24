({
    init: function (cmp, event, helper) {
     
        var actions = [
            { label: 'Edit', name: 'edit_details' },
            { label: 'Delete', name: 'delete'}
        ];
        
        cmp.set('v.columns', [
            { label: 'Name', fieldName: 'name', type: 'text' },
            { label: 'Given Name', fieldName: 'givenName', type: 'text'},
            { label: 'Family Name', fieldName: 'familyName', type: 'text'},
            { label: 'Role', fieldName: 'role', type: 'text'},
            { label: 'Position', fieldName: 'position', type: 'number', initialWidth: 135},
            { type: 'action', typeAttributes: { rowActions: actions }}
        ]);
        var resetPageIndex = true;
        helper.fetchContributors(cmp);
    },
    
    addContributors: function (cmp, evt, helper) {
        var fName = cmp.get("v.givenname");
        var lName = cmp.get("v.familyname");
        var fullname ;
        if(fName==undefined){
            var msg = 'Please enter given name!';
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": msg
                    });
                    toastEvent.fire(); 
                    return;
        }else if(fName.trim()==""){
            var msg = 'Please enter given name!';
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": msg
                    });
                    toastEvent.fire(); 
                    return;
        }
        if(lName){
            fullname = fName.trim() +" "+ lName.trim();
        }else{
            fullname = fName.trim();
        }
        var fName = cmp.set("v.name",fullname);
        
        helper.addContributor(cmp, event)
    },
    
    closeModel: function(cmp, event, helper) {
        cmp.set("v.isOpen", false);
    },
    
    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
         var IsRecordLocked=	cmp.get("v.IsRecordLocked");
        switch (action.name) {
            case 'edit_details':
                   if(IsRecordLocked=='true'){
                helper.editContributor(cmp, row)
                break;
                   }
                else
                {
                    var msg = 'Record can not be updated since it is locked, Please contact system administrator!';
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": msg
                    });
                    toastEvent.fire(); 
                    return;
                }
            case 'delete':
                   if(IsRecordLocked=='true'){
                helper.deleteContributor(cmp, row)
                break;
                   }
                else
                {
                     var msg = 'Record can not be deleted since it is locked, Please contact system administrator!';
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": msg
                    });
                    toastEvent.fire(); 
                    return;
                    
                }
        }
    },
    
    updateRow : function(cmp,event,helper) {
        var fName = cmp.get("v.givenname");
        var lName = cmp.get("v.familyname");
        var fullname ;
        if(lName){
            fullname = fName.trim() +" "+ lName.trim();
        }else{
            fullname = fName.trim();
        }
        var fName = cmp.set("v.name",fullname);
        helper.updateContributor(cmp, event)
    },
    
    /* updateColumnSorting: function (cmp, event, helper) {
        setTimeout(function() {
            var fieldName = event.getParam('fieldName');
            var sortDirection = event.getParam('sortDirection');
            cmp.set("v.sortedBy", fieldName);
            cmp.set("v.sortedDirection", sortDirection);
            helper.sortData(cmp, fieldName, sortDirection);
        }, 0);
    }*/
})