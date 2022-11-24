/*
* Test Class: zTEST_TF_SAP_BPcreation
* Description : SAP BP Creation by calling SAP API, This class is called by TF_SapBPCreation_TaxCal_OHCallout_Trig
* Created by Piyush Jain - 2019.11.04
*/
public with sharing class TF_SAP_BPcreation{
    private static List<SAP_BP__c> updateSapBpList = new List<SAP_BP__c>();
    
    //Call this method from quote update trigger(TF_SapBPCreation_TaxCal_OHCallout_Trig)
    Public static void sap_BP_Details(Opportunity opp, String orderId){
        Map<String, Id> SapIdToLookupMap = new Map<String, Id>();
        List<SAP_BP__c> sapBpList = new List<SAP_BP__c>();
        Set<Id> sapBPIdsSet = new Set<Id>();
        String opportunityId = opp.id;
        system.debug(opportunityId);
        Boolean billToBpNotGenerated = false;
        Boolean shipToBpNotGenerated = false;
        Set<Id> generatedSapBPIdsSet = new Set<Id>();
        Set<Id> addressNotVerifiedSapBPIdsSet = new Set<Id>();
        
        if (opp.Bill_to_BP__c != NULL ) {                    
            if(String.isNotBlank(opp.Bill_to_BP__r.Name) && !opp.Bill_to_BP__r.Name.containsIgnoreCase('PENDING') && opp.Bill_to_BP__r.Name != 'PENDING' && opp.Bill_to_BP__r.Has_Valid_BP__c == true){   
                generatedSapBPIdsSet.add(opp.Bill_to_BP__c);
                SapIdToLookupMap.put('Bill to', opp.Bill_to_BP__c);
            }else{
                sapBPIdsSet.add(opp.Bill_to_BP__c);
                SapIdToLookupMap.put('Bill to', opp.Bill_to_BP__c);
                billToBpNotGenerated = true;
            }
            if(String.isBlank(opp.Bill_to_BP__r.Message__c) || (String.isNotBlank(opp.Bill_to_BP__r.Message__c) && !opp.Bill_to_BP__r.Message__c.containsIgnoreCase('Address Verified'))){
                addressNotVerifiedSapBPIdsSet.add(opp.Bill_to_BP__c);
            }
        }
        
        if ( opp.Ship_to_BP__c != NULL) {                    
            if(String.isNotBlank(opp.Ship_to_BP__r.Name) && !opp.Ship_to_BP__r.Name.containsIgnoreCase('PENDING') && opp.Ship_to_BP__r.Name != 'PENDING' && opp.Ship_to_BP__r.Has_Valid_BP__c == true){ 
                generatedSapBPIdsSet.add(opp.Ship_to_BP__c);
                SapIdToLookupMap.put('Ship to', opp.Ship_to_BP__c);
            }else{
                sapBPIdsSet.add(opp.Ship_to_BP__c);
                SapIdToLookupMap.put('Ship to', opp.Ship_to_BP__c);
                shipToBpNotGenerated = true;
            }
            if(String.isBlank(opp.Ship_to_BP__r.Message__c) || (String.isNotBlank(opp.Ship_to_BP__r.Message__c) && !opp.Ship_to_BP__r.Message__c.containsIgnoreCase('Address Verified'))){
                addressNotVerifiedSapBPIdsSet.add(opp.Ship_to_BP__c);
            }
        }   
        //If address is not verified then update sap bp and opportunity message field here
        if(!addressNotVerifiedSapBPIdsSet.isEmpty()){
            sapBpList= [ SELECT Id, Message__c FROM SAP_BP__c WHERE Id IN: addressNotVerifiedSapBPIdsSet ];
            for(SAP_BP__c sapBp : sapBpList){
                //In this method we are updating sap bp message field 
                updateSapMessage(sapBp, 'Please verify address first', SapIdToLookupMap);
            }
            //Update list of sap bp
            if(!updateSapBpList.isEmpty() && updateSapBpList != NULL) update updateSapBpList;
            String errorMessageOnOppNew = '';
            //Update proper message field on opportunity and set Order_Status__c as Failed
            List<Opportunity> oppUpdate = new List<Opportunity>([Select id, Message__c, Bill_to_BP__c, Ship_to_BP__c, Bill_to_BP__r.Message__c, Ship_to_BP__r.Message__c, Order_Status__c from Opportunity where id =: opportunityId]);
            if(!oppUpdate.isEmpty()){		
                if(oppUpdate.get(0).Bill_to_BP__c !=NULL && String.isNotBlank(oppUpdate.get(0).Bill_to_BP__r.Message__c)) 
                {
                    if(oppUpdate.get(0).Bill_to_BP__r.Message__c.containsIgnoreCase('Ship to')){
                        errorMessageOnOppNew += oppUpdate.get(0).Bill_to_BP__r.Message__c.replace('Ship to', 'Bill to') + ' ~msg~ ';
                    }
                    else errorMessageOnOppNew += oppUpdate.get(0).Bill_to_BP__r.Message__c + ' ~msg~ ';
                }
                if(oppUpdate.get(0).Ship_to_BP__c !=NULL && String.isNotBlank(oppUpdate.get(0).Ship_to_BP__r.Message__c))
                {
                    if(oppUpdate.get(0).Ship_to_BP__r.Message__c.containsIgnoreCase('Bill to')){
                        errorMessageOnOppNew += oppUpdate.get(0).Ship_to_BP__r.Message__c.replace('Bill to', 'Ship to') + ' ~msg~ ';
                    }
                    else errorMessageOnOppNew += oppUpdate.get(0).Ship_to_BP__r.Message__c + ' ~msg~ ';
                }
                errorMessageOnOppNew = errorMessageOnOppNew.removeEnd(' ~msg~ ');
                Integer maxSize = 65536;
                if(errorMessageOnOppNew.length() > maxSize ){
                    errorMessageOnOppNew = errorMessageOnOppNew.substring(0, maxSize);
                    oppUpdate.get(0).Message__c = errorMessageOnOppNew;
                }else{
                    oppUpdate.get(0).Message__c = errorMessageOnOppNew;
                }
                //Update order status field 
                oppUpdate.get(0).Order_Status__c = 'Failed';
                update oppUpdate.get(0);
            }
        }
        //If sap bp number is already generated then call order tax calculation class
        else if(!billToBpNotGenerated && !shipToBpNotGenerated && !generatedSapBPIdsSet.isEmpty()){
            system.debug('Order Call future method');
			//When sap bp number is already created then do order tax calculation callout directly 
            TF_OrderTaxCalculation_Handler.directOrderCallout(orderId, true, true, opportunityId, generatedSapBPIdsSet);
        } 	
        else if(!sapBPIdsSet.isEmpty()){
            system.debug('Bp creation call future method');
            //Call this method to do callout for sap bp number creation
            TF_SAP_BP_Creation_Handler.sap_BP_Callout(sapBPIdsSet, generatedSapBPIdsSet, opportunityId, SapIdToLookupMap, orderId, opp.Account.Name);
        }
    }
    
    
    //Called this method in case of address not verified and update sapbpList and opportunity here
    public static void updateSapMessage(SAP_BP__c sapBp, String messageString, Map<String, Id> SapIdToLookupMap){
        system.debug('InUpdateMethod');
        String errorMessageOnOpp = ''; 
        List<String> messageList = new List<String>();
        //If id's of bill to bp and ship to bp is similar to each other then remove ship to from map
        if(SapIdToLookupMap.containsKey('Bill to') && SapIdToLookupMap.containsKey('Ship to') && SapIdToLookupMap.get('Bill to') == sapBp.id && SapIdToLookupMap.get('Ship to') == sapBp.id)
            SapIdToLookupMap.remove('Ship to');
        
        if(String.isNotBlank(sapBp.Message__c)){
            Map<integer,String> mapIndexValue = new Map<integer,String>();
            integer j = 0 ;
            messageList = sapBp.Message__c.split('~msg~');
            for(String msgStr : messageList){
                if (msgStr!=NULL && msgStr.containsIgnoreCase('Generation Failed')) {
                    // overwrite string 
                    if(SapIdToLookupMap.containsKey('Bill to')){
                        if(SapIdToLookupMap.get('Bill to') == sapBp.id){
                            mapIndexValue.put( j , ' Bill to: Generation Failed, '+messageString + ' ' );  
                        }
                    }
                    if(SapIdToLookupMap.containsKey('Ship to')){
                        if(SapIdToLookupMap.get('Ship to') == sapBp.id){
                            mapIndexValue.put( j , ' Ship to: Generation Failed, '+messageString + ' ' );                          
                        }
                    } 
                }
                j++;
            }
            if(SapIdToLookupMap.containsKey('Bill to')){
                if(SapIdToLookupMap.get('Bill to') == sapBp.id){
                    if(!sapBp.Message__c.containsIgnoreCase('Generation Failed')) messageList.add(' Bill to: Generation Failed, '+messageString + ' ');
                }
            }
            if(SapIdToLookupMap.containsKey('Ship to')){
                if(SapIdToLookupMap.get('Ship to') == sapBp.id){
                    if(!sapBp.Message__c.containsIgnoreCase('Generation Failed')) messageList.add(' Ship to: Generation Failed, '+messageString + ' ');
                }
            }
            for (integer i  : mapIndexValue.keySet()) {
                messageList.remove(i);
                messageList.add(mapIndexValue.get(i));
            }
            system.debug('messageList-'+messageList);
            // combine the string 
            String finalStr;
            for (Integer i = 0; i < messageList.size(); i++) {  
                if(i==0) finalStr = messageList.get(0) +' ';
                else finalStr = finalStr  + '~msg~' + messageList.get(i) +' ';   
            }
            if ( String.isNotBlank( finalStr)) {
                sapBp.Message__c = finalStr;
            }
        }else if(String.isBlank(sapBp.Message__c)){
            if(SapIdToLookupMap.containsKey('Bill to')){
                if(SapIdToLookupMap.get('Bill to') == sapBp.id){
                    sapBp.Message__c = '  Bill to: Generation Failed, '+messageString;
                }
            }
            if(SapIdToLookupMap.containsKey('Ship to')){
                if(SapIdToLookupMap.get('Ship to') == sapBp.id){
                    sapBp.Message__c = '  Ship to: Generation Failed, '+messageString;
                }
            } 
        }
        updateSapBpList.add(sapBp);
    }
    
}