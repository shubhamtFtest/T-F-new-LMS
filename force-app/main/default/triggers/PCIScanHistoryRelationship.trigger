trigger PCIScanHistoryRelationship on PCI_Scan_History__c (after insert, after update) {


Map<String,Id> mapIds = new Map<String,Id>();
List<string> systemScanIds = new List<string>();
String ids = ''; 

 for (Integer i=0;i<Trigger.new.size();i++)   
 {
   systemScanIds.add(Trigger.new[i].System_Scan_Id__c);
   mapIds.put(Trigger.new[i].System_Scan_Id__c, Trigger.new[i].Id);
     
   ids = ids + ', \'' + Trigger.new[i].System_Scan_Id__c + '\''; 
 } 
 
if (systemScanIds.size() > 0)  
{
  
String query = 'Select Id,System_Scan_Id__c  from PCI_Credit_Card_Numbers__c Where PCI_Scan_History__c = null and System_Scan_Id__c IN (' + ids.substring(1, ids.length()).trim() + ')';
System.debug('*****SELECT=' + query);
PCIScanHistoryRelationship checkCNN = new PCIScanHistoryRelationship();
checkCNN.query = query;
checkCNN.isTesting = false;
checkCNN.systemScanIds = systemScanIds ; 
checkCNN.mapIds = mapIds;
ID batchprocessid = Database.executeBatch(checkCNN);
}
 
 
  /**************************************************************************
List<PCI_Credit_Card_Numbers__c> updateMissingRelationship = new List<PCI_Credit_Card_Numbers__c>();
for (PCI_Credit_Card_Numbers__c ccn : [Select Id,System_Scan_Id__c  from PCI_Credit_Card_Numbers__c Where PCI_Scan_History__c = null and System_Scan_Id__c IN :systemScanIds])
 {
   
         System.debug('*****ccn.Id' + ccn.Id);
                System.debug('*****mapIds.get(ccn.System_Scan_Id__c)=' + mapIds.get(ccn.System_Scan_Id__c));
                PCI_Credit_Card_Numbers__c updateCNN = new PCI_Credit_Card_Numbers__c(
                    Id = ccn.Id,
                    PCI_Scan_History__c = mapIds.get(ccn.System_Scan_Id__c)
                    );   
            
                updateMissingRelationship.add(updateCNN);
        
 }
 
 if(updateMissingRelationship.size() > 0) update updateMissingRelationship;
***************************************************************************/
}