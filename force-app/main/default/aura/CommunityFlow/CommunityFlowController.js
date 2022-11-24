({
    init : function (component) {
        // Find the component whose aura:id is "Community_Flow"
        var flow = component.find("CommunityFlow_version1");
        // In that component, start your flow. Reference the flow's Unique Name.
        flow.startFlow("CommunityFlow_version1");
       
    },
})