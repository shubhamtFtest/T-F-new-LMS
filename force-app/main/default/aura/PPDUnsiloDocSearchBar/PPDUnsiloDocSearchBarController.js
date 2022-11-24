({
    
    handleKeyUp: function (cmp, evt) {
        var contentSearchEvent = $A.get("e.c:PPDContentSearchEvent");
        var recordID = cmp.get("v.recordId");
        var isEnterKey = evt.keyCode === 13;
        var fullList = [];
        var queryTerm = cmp.find('contentSearch').get('v.value');
        var cldFrom = cmp.get("v.calledFrom");
        console.log('CalledFrom: ' + cldFrom);
        if (isEnterKey) {
            cmp.set('v.issearching', true);
            setTimeout(function() {
                //alert('Searched for "' + queryTerm + '"!');
                cmp.set('v.issearching', false);
            }, 1500);
            
            contentSearchEvent.setParams({
                'searchText' : queryTerm,
                'calledFrom' : cldFrom
            }); 
            contentSearchEvent.fire();   
        }//isEnterKey 
    },
    
    changeEvt: function (cmp, evt) {
        var queryTerm = cmp.find('contentSearch').get('v.value');
        if (queryTerm == '' || queryTerm == null) {
            var contentSearchEvent = $A.get("e.c:PPDContentSearchEvent");
            var cldFrom = cmp.get("v.calledFrom");
            cmp.set('v.issearching', true);
            setTimeout(function() {
                cmp.set('v.issearching', false);
            }, 1500);
            
            contentSearchEvent.setParams({
                'searchText' : queryTerm,
                'calledFrom' : cldFrom
            }); 
            contentSearchEvent.fire();   
        }
    }
})