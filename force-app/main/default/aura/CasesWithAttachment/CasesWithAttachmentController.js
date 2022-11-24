({
	doInit : function(component, event, helper) {
		helper.getCaseDetails(component, event, helper);
	},
    handleClick : function(component, event, helper) {
        var recordId = event.target.dataset.caseid;
        
        var sObectEvent = $A.get("e.force:navigateToSObject");
        sObectEvent.setParams({
            "recordId": recordId,
            "slideDevName": "detail"
        });
        sObectEvent.fire();
    },
    handleClickAttachment : function(component, event, helper) {
        var attachmentId = event.target.dataset.attachid;
        
        var relatedListEvent = $A.get("e.force:navigateToRelatedList");
        relatedListEvent.setParams({
            "relatedListId": "CombinedAttachments",
            "parentRecordId": attachmentId
        });
        relatedListEvent.fire();
    },
    downloadCases : function(component, event, helper) {
        
        var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
        var yyyy = today.getFullYear();
        
        var now = today = mm + '/' + dd + '/' + yyyy;
        console.log(now);
        var allSelectedCase=component.get("v.attachmentDetails");
        console.log(allSelectedCase);
        component.set("v.finalListToAdd",allSelectedCase);
        var finalListToDownload=component.get("v.finalListToAdd");
        var csv=helper.convertArrayOfObjectsToCSV(component,finalListToDownload); 
        if(csv==null)
        {
            return ;
        }                         
        var elementLink=document.createElement('a');
        elementLink.href='data:text/csv;charset=utf-8,'+encodeURI(csv);
        elementLink.target='_self';
        elementLink.download= now +' CATS.csv';
        document.body.appendChild(elementLink);
        elementLink.click();
        $A.get('e.force:refreshView').fire(); 
    }
})