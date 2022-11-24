({
	 doInit : function(component, event, helper) {
        var key = component.get("v.key");
        var map = component.get("v.map");
         console.log('map-'+map);
         if(component.get("v.showTerritory")){
        	component.set("v.territoryName" , map[key]);     
         }else{
             component.set("v.forecasteName" , map[key]);     
         }
        
    },
})