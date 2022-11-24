({
	searchTree : function(cmp,element, matchingTitle){ 
       var treeData = cmp.get("v.gridData");
        if(element.labelValue.toLowerCase().indexOf(matchingTitle.toLowerCase()) > -1){ 
            treeData.push(element); 
        }
        else if(element._children != undefined){  
           for(var i=0; i < element._children.length; i++){ 
               this.searchTree(cmp,element._children[i], matchingTitle); 
           } 
           //treeData.push(result);  
       } 
       if(treeData.length>0){
            cmp.set("v.gridData",treeData);
        }
	},
    
    selectChildTree : function(cmp,elementId,treeData){ 
    	debugger;
        var parentData = [];
        //treeData = cmp.get("v.gridData");
        for(var i in treeData){
            if(treeData[i].recId == elementId){
               parentData.push(treeData[i]);
            }
            else if(treeData[i]._children != undefined){
             for(var j=0; j < treeData[i]._children.length; j++){
               var a = [];
               a.push(treeData[i]._children[j]);
               this.selectChildTree(cmp,elementId,a); 
           }   
            }
        }
        if(parentData.length>0){
            console.log(parentData);
            var abc  =  cmp.get('v.selectedIds');
            for(var a in parentData){
                abc.push(parentData[a].recId);
                if(parentData[a]._children != undefined){
                    for(var b in parentData[a]._children){
                        abc.push(parentData[a]._children[b].recId);
                    }
                } 
            }
           cmp.set('v.selectedIds',abc); 
        }
       	//cmp.set("v.gridData",treeData);
	}
})