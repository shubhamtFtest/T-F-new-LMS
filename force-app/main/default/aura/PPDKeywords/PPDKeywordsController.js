({
    init: function (cmp, event, helper) {
        var actions = [
            { label: 'Edit', name: 'edit_details' },
            { label: 'Delete', name: 'delete' }
        ];
        cmp.set('v.columns', [
            { label: 'Name', fieldName: 'name', type: 'text' },
            { label: 'Position', fieldName: 'position', type: 'number', initialWidth: 100},
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);
        helper.fetchKeywords(cmp);
    },
    
    addKeywords: function (cmp, evt, helper) {
        var isEnterKey = evt.keyCode === 13;
        if (isEnterKey) {
            var keyString = cmp.find('keywordfield').get('v.value');
            if(keyString){
                helper.addWords(cmp, evt);
            }
        }
    },
    
    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        var IsRecordLocked=	cmp.get("v.IsRecordLocked");
        switch (action.name) {
            case 'edit_details':
                if(IsRecordLocked=='true'){
                    helper.editKeyWords(cmp, row)
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
                    helper.deleteKeyWords(cmp, row)
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
    
    closeModel: function(cmp, event, helper) {
        cmp.set("v.isOpen", false);
    },
    
    updateRow : function(cmp,event,helper) {
        var allValid = cmp.find('field').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if (allValid) {
            helper.updateKeyWords(cmp, event)
        } else {
            var msg = 'Please update the invalid form entries and try again.';
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "message": msg
            });
            toastEvent.fire(); 
        }
    }
})