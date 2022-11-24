trigger PCIUpdateRemoveRecord on PCI_Credit_Card_Numbers__c (after update) {
  
  List<SObject> o = new List<SObject>();
  //List<Id> o = new List<Id>();
  for (Integer i=0;i<trigger.new.size();i++)   
   {
   
     if(Trigger.new[i].Record_Action__c == 'Removed'  ) 
     {
       try
       {
         System.debug('Object_Name__c : '+Trigger.new[i].Object_Name__c);
       if (Trigger.new[i].Object_Name__c == 'Task' )
         {
           Task record = [Select Id from Task where id=:Trigger.new[i].Record_Id__c AND IsDeleted = false limit 1 All ROWS];
           //record.Id = Trigger.new[i].Record_Id__c;
           if (record != null)
           o.add(record); 
         }
       else if (Trigger.new[i].Object_Name__c == 'Event')
         {
           Event record = [Select Id from Event where id=:Trigger.new[i].Record_Id__c AND IsDeleted = false limit 1 All ROWS];
           //record.Id = Trigger.new[i].Record_Id__c;
           if (record != null)
           o.add(record); 
         }
       else
         {
           SObject record = Database.query('Select Id from ' + Trigger.new[i].Object_Name__c + ' where id= \'' + Trigger.new[i].Record_Id__c + '\' limit 1');
           //record.Id = Trigger.new[i].Record_Id__c;
           if (record != null)
           o.add(record); 
         }
       }
       catch(QueryException e)
       { 
         Trigger.new[i].addError(' If the record was deleted before reviewed or Credit Card, please select "No Credit Card - Deleted Record" or “Had Credit Card - Deleted Record”.<BR><BR>' + e);
         //throw e.setMessage('If the record no longer exists, please select "Missing Record" insted of "Remove".');
       }
       
       
     }else if (Trigger.new[i].Record_Action__c == 'No Credit Card - Deleted Record' || Trigger.new[i].Record_Action__c == 'Had Credit Card - Deleted Record')
     {
      
       try
       {
       SObject record = Database.query('Select Id from ' + Trigger.new[i].Object_Name__c + ' where id= \'' + Trigger.new[i].Record_Id__c + '\' limit 1');
       //record.Id = Trigger.new[i].Record_Id__c;
       if (record != null)
       {Trigger.new[i].addError(' The record exists, Please select the appropriate value after you review the record.');} 
       
       }
       catch(QueryException e)
       { 
         //Don't throw exception because record has been Deleted
       }
     
     
     }
     
   }
  
  if (o.Size() >0)
  {
  Update o;
  }

}