/****************************************************************************
Trigger On Contact to change active = False if Status = Inactive or Invalid .
Created By: Sourabh Goyal at Girikon LLC
Last modified by: Sourabh Goyal
*****************************************************************************/

public class TF_UpdateContactActiveCheck_Trig implements TriggerInterface_Contact.Runnable {
    
    contact con_New;
    contact con_old;
    
    public void run(TriggerInterface_Contact.Trig trig) {
        
        for(Contact con : trig.newMap.values())
        {
            if(con.Status__c!=null){
                if(con.Status__c.contains('Inactive') || con.Status__c.contains('Invalid')) {
                    
                    con.Active__c = false;
                } 
            }
        }
        
        if(trig.Isupdate){
            for(Contact con : trig.newMap.values())
            {
                con_New = trig.newMap.get(con.id);
                con_old = trig.oldMap.get(con.id);
                
                if( con_old.Status__c!=null && (con_old.Status__c.contains('Inactive') || con_old.Status__c.contains('Invalid') ) && con_new.Status__c == 'Active'){
                    
                    con.Active__c = true;
                }
                
            } 
            
        }
        
        
    }
}