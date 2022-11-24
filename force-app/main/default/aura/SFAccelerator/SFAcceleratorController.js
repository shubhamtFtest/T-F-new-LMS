({
    init : function (component) {
        // Find the component whose aura:id is "Community_Flow"
        var flow = component.find("Community_salesforce_accelerator_flow");
        // In that component, start your flow. Reference the flow's Unique Name.
        flow.startFlow("Community_salesforce_accelerator_flow");
       
    },
})