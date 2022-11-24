({
	fetchterritoryForcastType : function(cmp, event) {
		var act = cmp.get("c.getTerritoryForetypeMap");        
        act.setCallback(this,function(a){
            //get the response state
            var state = a.getState();            
            //check if result is successfull  mapTerritory mapForecastType
            if(state == "SUCCESS"){
				// mapIdNameTerritory mapIdNameForType
				var TerFortypeClassObj = a.getReturnValue();
                cmp.set("v.TerFortypeClassObj",a.getReturnValue());
                cmp.set("v.mapIdNameTerritory",TerFortypeClassObj.mapIdNameTerritory);
                cmp.set("v.mapIdNameForType",TerFortypeClassObj.mapIdNameForType);
				console.log('TerFortypeClassObj-'+JSON.stringify(a.getReturnValue()));
				console.log('TerFortypeClassObj.mapIdNameTerritory-'+TerFortypeClassObj.mapIdNameTerritory);
				console.log('TerFortypeClassObj.mapIdNameForType-'+TerFortypeClassObj.mapIdNameForType);
            } else if(state == "ERROR"){
                cmp.set("v.Spinner", false);
                var errors = a.getError();                
                if (errors) {
                    cmp.set("v.Spinner", false);
                    if (errors[0] && errors[0].message) 
                    {
                        console.error("Error message: " + errors[0].message);                                              
                    }
                } 
            }
        });        
        //adds the server-side act to the queue        
        $A.enqueueAction(act);
	}
})