trigger PCIOwnership on PCI_Credit_Card_Numbers__c (before insert, before update) {
  
  Set<String> objectIds = new Set<String>();
    Set<String> objectFields = new Set<String>();
    Set<String> lastDigits = new Set<String>();
    
    
    for (Integer i=0;i<Trigger.new.size();i++)   
   {
     
     //Begin Short Value
    
      if (Trigger.new[i].Field_Value__c != null && (Trigger.new[i].Field_Value__c.length() <= 50))
      {
        Trigger.new[i].Field_Value_Short__c = Trigger.new[i].Field_Value__c;
      }
      else if (Trigger.new[i].Field_Value__c != null)
      {
        Integer fieldLength= Trigger.new[i].Field_Value__c.length();
        
        Trigger.new[i].Field_Value_Short__c = Trigger.new[i].Field_Value__c.substring(fieldLength-50, fieldLength);
      }
    
      //End Short Value
     
     
     
     
     if (Trigger.new[i].Record_Action__c == 'Pending')
     {
       objectIds.add(Trigger.new[i].Record_Id__c);
       objectFields.add(Trigger.new[i].Field_Name__c);
       lastDigits.add(Trigger.new[i].CCN_Last_4_Digits__c);
     }
   }
  AggregateResult[] cnnFalsePositives= [Select p.Record_Id__c, p.Field_Name__c, p.CCN_Last_4_Digits__c, COUNT(Id) From PCI_Credit_Card_Numbers__c p 
                    Where  p.Record_Action__c = 'False Positive' AND Record_Id__c =:objectIds AND Field_Name__c =:objectFields AND CCN_Last_4_Digits__c  =:lastDigits
                    GROUP BY p.Record_Id__c, p.Field_Name__c, p.CCN_Last_4_Digits__c ];
  if (cnnFalsePositives.Size() > 0)  
  {
     for (Integer i=0;i<Trigger.new.size();i++)   
     {
     if (Trigger.new[i].Record_Action__c == 'Pending')
     {
       for (Integer j=0;j<cnnFalsePositives.size();j++)   
       {
         if (Trigger.new[i].Record_Id__c == cnnFalsePositives[j].get('Record_Id__c') && Trigger.new[i].Field_Name__c == cnnFalsePositives[j].get('Field_Name__c') && Trigger.new[i].CCN_Last_4_Digits__c == cnnFalsePositives[j].get('CCN_Last_4_Digits__c'))
         {
           Trigger.new[i].Record_Action__c  = 'False Positive';
           Break;
         }
         
       }
       
     }
  
     }
  }                
                    
  
  PCIOwnership.ProcessingOwnership(Trigger.new ,true); 
 
}