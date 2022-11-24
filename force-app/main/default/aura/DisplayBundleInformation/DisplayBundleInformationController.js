({
    doInit : function(component, event, helper) {
        debugger;
        var abc = component.get('v.isBespokeQLI');
        
    },
    handleComponentEvent : function(component, event, helper) {
        debugger;
        console.log('indisplaycomponent');
        var activeT = event.getParam("isActiveTab");
        component.set("v.activeTab", activeT);
        var uuId = event.getParam("pcmUUID");//pcmUUID
        component.set("v.uuID", uuId);
        component.set("v.selectedTab",'bundleItems');
        var inSalesforce = event.getParam("inSalesforce");
        component.set("v.inSalesforce",inSalesforce);
        var isBespokeQLI = event.getParam("isBespokeQLI");
        console.log('indisplaycomp' + isBespokeQLI);
        component.set("v.isBespokeQLI",isBespokeQLI);
        var isCollection= event.getParam("iscollection");
        component.set("v.isCollection",isCollection);
        
    }
})