trigger PCICreditCardRelationship on PCI_Credit_Card_Numbers__c (before insert, before update) {




//if (trigger.isAfter)PCIOwnership.ProcessingOwnership(Trigger.new);
 

if (trigger.isbefore) 
{
SET<string> systemScanIds = new SET<string>();
List<string> ccnIds = new List<string>();
//String ids = '';
 for (Integer i=0;i<Trigger.new.size();i++) 
 {
   if(Trigger.new[i].PCI_Scan_History__c == null)
   {
   systemScanIds.add(Trigger.new[i].System_Scan_Id__c);
   ccnIds.add(Trigger.new[i].Id);
   //ids = ids + ', \'' + Trigger.new[i].System_Scan_Id__c + '\''; 
   }
 }
 
 //Get mappings to ids
 if (systemScanIds.Size() > 0)
 {
  Map<String,Id> mapScanIds = new Map<String,Id>();
  for (PCI_Scan_History__c scan : [Select Id,System_Scan_Id__c  from PCI_Scan_History__c Where System_Scan_Id__c IN :systemScanIds])
   {
         mapScanIds.put(scan.System_Scan_Id__c, scan.Id);
         System.debug('*****ccn.Id' + scan.Id);
                System.debug('*****mapScanIds.get(scan.System_Scan_Id__c)=' + mapScanIds.get(scan.System_Scan_Id__c));
                     
   }
 
 
 //Get scan id
   for (Integer i=0;i<Trigger.new.size();i++) 
   {
     if(Trigger.new[i].PCI_Scan_History__c == null)
     {
     Trigger.new[i].PCI_Scan_History__c = mapScanIds.get(Trigger.new[i].System_Scan_Id__c);
     }
   }
 }
}
 
 /**************************************************************************
List<PCI_Credit_Card_Numbers__c> updateMissingRelationship = new List<PCI_Credit_Card_Numbers__c>();
for (PCI_Credit_Card_Numbers__c ccn : [Select Id,System_Scan_Id__c  from PCI_Credit_Card_Numbers__c Where PCI_Scan_History__c = null and System_Scan_Id__c IN :systemScanIds])
 {
   
         System.debug('*****ccn.Id' + ccn.Id);
                System.debug('*****mapIds.get(ccn.System_Scan_Id__c)=' + mapScanIds.get(ccn.System_Scan_Id__c));
                PCI_Credit_Card_Numbers__c updateCNN = new PCI_Credit_Card_Numbers__c(
                    Id = ccn.Id,
                    PCI_Scan_History__c = mapScanIds.get(ccn.System_Scan_Id__c)
                    );   
            
                updateMissingRelationship.add(updateCNN);
        
 }
 
 
 if(updateMissingRelationship.size() > 0) update updateMissingRelationship;
 
 
if (systemScanIds.size() > 0)  
{
  
String query = 'Select Id,System_Scan_Id__c  from PCI_Credit_Card_Numbers__c Where PCI_Scan_History__c = null and System_Scan_Id__c IN (' + ids.substring(1, ids.length()).trim() + ')';
System.debug('*****SELECT=' + query);
PCIScanHistoryRelationship checkCNN = new PCIScanHistoryRelationship();
checkCNN.query = query;
checkCNN.isTesting = false;
checkCNN.systemScanIds = systemScanIds ; 
checkCNN.mapIds = mapScanIds;
ID batchprocessid = Database.executeBatch(checkCNN);  
  
}


String query = 'Select Id,System_Scan_Id__c  from PCI_Scan_History__c Where System_Scan_Id__c IN (' + ids.substring(1, ids.length()).trim() + ')';
System.debug('*****SELECT=' + query);
PCICreditCardRelationship checkCNN = new PCICreditCardRelationship();
checkCNN.query = query;
checkCNN.isTesting = false;
checkCNN.systemScanIds = systemScanIds ;
checkCNN.ccnIds = ccnIds;
ID batchprocessid = Database.executeBatch(checkCNN);
 
 //build update 
 List<PCI_Credit_Card_Numbers__c> updateMissingRelationship = new List<PCI_Credit_Card_Numbers__c>();
 for (Integer i=0;i<ccnIds.size();i++) 
 {
 System.debug('*****mapScanIds.get(systemScanIds[i])=' + mapScanIds.get(systemScanIds[i]));
 PCI_Credit_Card_Numbers__c updateCNN = new PCI_Credit_Card_Numbers__c(
                    Id = ccnIds[i],
                    PCI_Scan_History__c = mapScanIds.get(systemScanIds[i])
                    );   
            
                updateMissingRelationship.add(updateCNN);
 
 }
 
 
 
 
 if(updateMissingRelationship.size() > 0) update updateMissingRelationship;
 ***************************************************************************/

}