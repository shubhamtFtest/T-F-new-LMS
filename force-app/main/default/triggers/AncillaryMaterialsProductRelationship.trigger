/************************************************************************** 
**CHG0055654 
**Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2014-05-06
** 
***************************************************************************/
trigger AncillaryMaterialsProductRelationship on Ancillary_Materials__c (after insert, after update) 
{
    if (CASEmail.hasRunBeforeTrigger == false)//dont run if a instance is running
    {
        CASEmail.hasRunBeforeTrigger = true;
        //Get ISBN's
        Set<String> isbn = new Set<String>();
        for (Integer i=0;i<Trigger.new.size();i++)   
         {
            
            isbn.add(Trigger.new[i].Acillary_Materials_ISBN__c);
            isbn.add(Trigger.new[i].Product_ISBN__c);
            
         }
    
        if (isbn.size() > 0)
        {
            //Get Products from Isbn
                Map<String,String> mapISBN = new Map<String,String>();
                List<Product2> prods = [Select Id, ISBN__C from Product2 o where ISBN__C=: isbn];
                for (Product2 prod : prods)     
                {
                    mapISBN.put(prod.ISBN__C, prod.Id);
                }
            
                if(mapISBN.size() >0)
                {
                
                    //Update products from ISBN/ Product Id maps
                    List<Ancillary_Materials__c> updateAncillaryMaterials = new List<Ancillary_Materials__c>();
                    for (Integer i=0;i<Trigger.new.size();i++)   
                     {
                        Ancillary_Materials__c am = new Ancillary_Materials__c(Id=Trigger.new[i].Id, Ancillary_Materials_Product__c=mapISBN.get(Trigger.new[i].Acillary_Materials_ISBN__c), Product__c=mapISBN.get(Trigger.new[i].Product_ISBN__c));
                        updateAncillaryMaterials.add(am);
                        
                     }
                    
                    
                    if (updateAncillaryMaterials.size() > 0)
                    {
                        update updateAncillaryMaterials;
                    }
                }
            
        }
    }

}