/*
* Test Class: zTEST_TF_SAP_BP_ErrorHandling
* Description :  class of Error handling class for SAP BP address verification, SAP BP number creation, Order tax calculation and Order POH failed 
* Created by Piyush Jain
*/

public class TF_SAP_BP_ErrorHandling {
    
	private static List<SAP_BP__c> updateSapBpList = new List<SAP_BP__c>();
	private static Set<Id> addressNotVerifiedSapBPIdsSet = new Set<Id>();
    private static Set<Id> generatedSapBPIdsSet = new Set<Id>();
    private static Set<Id> sapBPIdsSet = new Set<Id>();
	private static List<SAP_BP__c> SapBpList = new List<SAP_BP__c>();
    private static String lookupFieldSap;
    private static  Map<String , Map < String , String>> mapAddTypeFieldApiName ;
    private static Map<String, String> mapFieldApiName ;
    private static  String vat;
    private static List<SAP_BP__c> passSapBpsList = new List<SAP_BP__c>();
    private static string oppId;
    private static boolean run1 = true;
    public static boolean runOnce1(){
        if(run1){
            run1=false;
            return true;
        }
        else{
            return run1;
        }
    }
    
    //Get message from message field of Order and Opportunity
    @AuraEnabled
    public static messageWrapper getErrorMessage(String Id, String objectName){
        messageWrapper messageWrapperObj = new messageWrapper();	
        List<String> messageList = new List<String>();
        List<Order> orderList = new List<Order>();
        List<Opportunity> oppDetails = new List<Opportunity>();
        List<SBQQ__Quote__c> sbqqQuaoteOrders = new List<SBQQ__Quote__c>();
        //Get message field on Opportunity
        if(objectName == 'Opportunity'){
            //Get value of message field on opportunity
            oppDetails = [SELECT Id, Order_Status__c, Name, StageName, Message__c, SBQQ__PrimaryQuote__c, Ship_to_BP__c, Bill_to_BP__c, Bill_to_BP__r.Message__c, Ship_to_BP__r.Message__c  FROM Opportunity where id =:Id];
            if(!oppDetails.isEmpty() && oppDetails != NULL){
                sbqqQuaoteOrders =[ SELECT Id,SBQQ__Status__c,(select id,Message__c,OpportunityId,IsRecursion__c from SBQQ__Orders__r )FROM SBQQ__Quote__c WHERE Id =: oppDetails.get(0).SBQQ__PrimaryQuote__c ];
                if(!sbqqQuaoteOrders.isEmpty() && !sbqqQuaoteOrders.get(0).SBQQ__Orders__r.isEmpty() && sbqqQuaoteOrders.get(0).SBQQ__Orders__r !=NULL) {
                    orderList = sbqqQuaoteOrders.get(0).SBQQ__Orders__r;
                    system.debug('orderList '+orderList);
                }
                if(!orderList.isEmpty() && orderList != NULL && String.isNotBlank(orderList.get(0).Message__c)){
                    //Split message field value by "~msg~" and add that message in to messageList
                    messageList.addAll(orderList.get(0).Message__c.split('~msg~'));
                    system.debug('ordMessageList '+messageList);
                }
                if(String.isNotBlank(oppDetails[0].Message__c)){
                    //Split message field value by "~msg~" and add that message in to messageList
                    messageList.addAll(oppDetails.get(0).Message__c.split('~msg~'));
                    system.debug('oppMessageList '+messageList);
                    system.debug('SBQQ__PrimaryQuote__c '+oppDetails.get(0).SBQQ__PrimaryQuote__c);
                }
                else{
                    messageWrapperObj.directSalesProcessSuccess = 'failed';
					messageWrapperObj.addressBillToValidationSuccess = 'failed';
					messageWrapperObj.addressShipToValidationSuccess = 'failed';
                    messageWrapperObj.directSalesProcessMessage = 'Failed'+ ', ';
                    messageWrapperObj.addressBillToValidationMessage = 'Failed';
                    //messageWrapperObj.addressShipToValidationMessage ='Failed';
                }
            }
        }
        
        for(String message : messageList){
            if(message.containsIgnoreCase('Bill to: Address Verified')){
                messageWrapperObj.addressBillToValidationSuccess = 'success';
            }
            if(message.containsIgnoreCase('Bill to: Address Not Verified')){
                messageWrapperObj.addressBillToValidationSuccess = 'failed';
                messageWrapperObj.addressBillToValidationMessage = message + ' ';
            }
            if(message.containsIgnoreCase('Ship to: Address Verified')){
                messageWrapperObj.addressShipToValidationSuccess = 'success';
            }
            if(message.containsIgnoreCase('Ship to: Address Not Verified')){
                messageWrapperObj.addressShipToValidationSuccess = 'failed';
                messageWrapperObj.addressShipToValidationMessage = message + ' ';
            }
            if(message.containsIgnoreCase('Generation Failed') || message.containsIgnoreCase('Tax Calculation-Failed') || message.containsIgnoreCase('Posting order to order hub-Failed')){
                messageWrapperObj.directSalesProcessMessage += message + ', ';
            }
        }
        if(!oppDetails.isEmpty() && oppDetails != NULL && (oppDetails.get(0).Order_Status__c == 'Pending' || (!sbqqQuaoteOrders.isEmpty() && sbqqQuaoteOrders != NULL && sbqqQuaoteOrders.get(0).SBQQ__Status__c != 'Accepted'))){
             messageWrapperObj.directSalesProcessSuccess = 'notAttempted';
             messageWrapperObj.directSalesProcessMessage += '';
            if(!oppDetails.isEmpty() && oppDetails != NULL && oppDetails.get(0).Bill_to_BP__c == NULL && oppDetails.get(0).Ship_to_BP__c == NULL){
                messageWrapperObj.addressBillToValidationSuccess = 'notAttempted';
                messageWrapperObj.addressShipToValidationSuccess = 'notAttempted';
                messageWrapperObj.addressBillToValidationMessage += '';
                messageWrapperObj.addressShipToValidationMessage += '';
            }
        }
        else if(!sbqqQuaoteOrders.isEmpty() && sbqqQuaoteOrders != NULL && sbqqQuaoteOrders.get(0).SBQQ__Status__c == 'Accepted' && !oppDetails.isEmpty() && oppDetails != NULL && oppDetails.get(0).Bill_to_BP__c == NULL && oppDetails.get(0).Ship_to_BP__c == NULL){
            messageWrapperObj.directSalesProcessSuccess = 'failed';
            messageWrapperObj.addressBillToValidationSuccess = 'failed';
            messageWrapperObj.addressShipToValidationSuccess = 'failed';
            messageWrapperObj.directSalesProcessMessage += 'No SAP BP is present' + ', ';
            messageWrapperObj.addressBillToValidationMessage += ' No SAP BP is present';
            //messageWrapperObj.addressShipToValidationMessage += 'No SAP BP is present' + ', ';
        }
        else if(messageList.toString().containsIgnoreCase('Generation Failed') || messageList.toString().containsIgnoreCase('Tax Calculation-Failed') || messageList.toString().containsIgnoreCase('Posting order to order hub-Failed')){
               messageWrapperObj.directSalesProcessSuccess = 'failed';
           }
		/*else if(!messageList.toString().containsIgnoreCase('Generation Failed') && !messageList.toString().containsIgnoreCase('Generated Successfully') && 
                !messageList.toString().containsIgnoreCase('Address Not Verified') && !messageList.toString().containsIgnoreCase('Address Verified') &&
                !messageList.toString().containsIgnoreCase('Tax Calculation') && 
                !messageList.toString().containsIgnoreCase('Posting order to order hub')){
                    messageWrapperObj.directSalesProcessSuccess = 'notAttempted';
                    messageWrapperObj.addressBillToValidationSuccess = 'notAttempted';
                    messageWrapperObj.addressShipToValidationSuccess = 'notAttempted';
                }
        else if(!messageList.toString().containsIgnoreCase('Generation Failed') && !messageList.toString().containsIgnoreCase('Generated Successfully') && 
                !messageList.toString().containsIgnoreCase('Tax Calculation') &&
                !messageList.toString().containsIgnoreCase('Posting order to order hub')){
                    messageWrapperObj.directSalesProcessSuccess = 'notAttempted';
                }*/
        else if(!oppDetails.isEmpty() && oppDetails != NULL && oppDetails.get(0).Bill_to_BP__c != NULL && oppDetails.get(0).Ship_to_BP__c != NULL){
            if(messageList.toString().containsIgnoreCase('Bill to: Generated Successfully') && messageList.toString().containsIgnoreCase('Ship to: Generated Successfully')
               && messageList.toString().containsIgnoreCase('Tax Calculation-Success') && messageList.toString().containsIgnoreCase('Posting order to order hub-Success')){
                   messageWrapperObj.directSalesProcessSuccess = 'success';
               }else{
                   messageWrapperObj.directSalesProcessSuccess = 'failed';
                   messageWrapperObj.directSalesProcessMessage += 'Failed' + ', ';
               }
        }
        else if(!oppDetails.isEmpty() && oppDetails != NULL && oppDetails.get(0).Bill_to_BP__c != NULL && oppDetails.get(0).Ship_to_BP__c == NULL){
            if(messageList.toString().containsIgnoreCase('Bill to: Generated Successfully') &&
               messageList.toString().containsIgnoreCase('Tax Calculation-Success') &&
               messageList.toString().containsIgnoreCase('Posting order to order hub-Success')){
                   messageWrapperObj.directSalesProcessSuccess = 'success';
               }else{
                   messageWrapperObj.directSalesProcessSuccess = 'failed';
                   messageWrapperObj.directSalesProcessMessage += 'Failed' + ', ';
               }
        }
        else if(!oppDetails.isEmpty() && oppDetails != NULL && oppDetails.get(0).Bill_to_BP__c == NULL && oppDetails.get(0).Ship_to_BP__c != NULL){
            if(messageList.toString().containsIgnoreCase('Ship to: Generated Successfully') &&
               messageList.toString().containsIgnoreCase('Tax Calculation-Success') &&
               messageList.toString().containsIgnoreCase('Posting order to order hub-Success')){
                   messageWrapperObj.directSalesProcessSuccess = 'success';
               }else{
                   messageWrapperObj.directSalesProcessSuccess = 'failed';
                   messageWrapperObj.directSalesProcessMessage += 'Failed' + ', ';
               }
        }
        
        messageWrapperObj.directSalesProcessMessage = messageWrapperObj.directSalesProcessMessage.removeEnd(', ');
        
        system.debug(messageList);
        system.debug('messageWrapperObj.addressBillToValidationSuccess '+messageWrapperObj.addressBillToValidationSuccess);
        system.debug('messageWrapperObj.addressBillToValidationMessage '+messageWrapperObj.addressBillToValidationMessage);
        system.debug('messageWrapperObj.addressShipToValidationSuccess '+messageWrapperObj.addressShipToValidationSuccess);
        system.debug('messageWrapperObj.addressShipToValidationMessage '+messageWrapperObj.addressShipToValidationMessage);
        system.debug('messageWrapperObj.directSalesProcessMessage '+messageWrapperObj.directSalesProcessMessage);
        system.debug('messageWrapperObj.directSalesProcessSuccess '+messageWrapperObj.directSalesProcessSuccess);
        return messageWrapperObj;
    }
    
    public class messageWrapper{
        @AuraEnabled
        public String directSalesProcessMessage = '';
        @AuraEnabled
        public String directSalesProcessSuccess = 'notAttempted';
        @AuraEnabled
        public String addressShipToValidationMessage = '';
        @AuraEnabled
        public String addressShipToValidationSuccess = 'notAttempted';  
        @AuraEnabled
        public String addressBillToValidationMessage = '';
        @AuraEnabled
        public String addressBillToValidationSuccess = 'notAttempted';
        
    }
    
    //Call this method from lightning web component's retry button
	@AuraEnabled    
    Public static messageWrapperClass retry(List<String> retryMethodList, String opportunityId, String orderId){
        messageWrapperClass messageWrapperClassObj = new messageWrapperClass();	
        messageWrapperClassObj.successMessageList = new List<String>();
        messageWrapperClassObj.errorMessageList = new List<String>();
        List<String> MsgList = new List<String>();
        List<Opportunity> OpportunityList = new List<Opportunity>();
		List<Order> orderList = new List<Order>();
        Map<String, Id> SapIdToLookupMap = new Map<String, Id>();
        Boolean billToBpNotGenerated = false;
		Boolean shipToBpNotGenerated = false;
        Set<id> setSapBpIds = new Set<Id>();
        
        TF_AddressVerification.addressVerificationWrapperClass addressVerificationWrapperClassObj = new TF_AddressVerification.addressVerificationWrapperClass();
        addressVerificationWrapperClassObj.updateSapBpList = new List<SAP_BP__c>();
        addressVerificationWrapperClassObj.oppUpdate = new List<Opportunity>();
        
        if(runOnce1()){
            try{
                system.debug('opportunityId==> '+ opportunityId);
                oppId = opportunityId;
                Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F Automated eBooks Opportunity').getRecordTypeId();
                Id BPCoppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F - OA BPC Opportunity').getRecordTypeId();
                
                OpportunityList = [SELECT id, Order_Status__c, Account.Name, Ship_to_BP__r.Name, Bill_to_BP__r.Name, Bill_to_BP__r.Has_Valid_BP__c, Ship_to_BP__r.Has_Valid_BP__c, SBQQ__PrimaryQuote__c ,Ship_to_BP__r.Message__c,Bill_to_BP__r.Message__c,RecordTypeId,Message__c,Sold_to_BP__c,Ship_to_BP__c,Payer_BP__c,StageName,AccountId,Bill_to_BP__r.Email__c, Name, Bill_to_BP__r.First_Name__c, Bill_to_BP__r.Last_Name__c, Bill_to_BP__r.Country__c, Bill_to_BP__r.Region__c, Bill_to_BP__r.State__c, Bill_to_BP__r.Street__c, Bill_to_BP__r.ZIP__c, Bill_to_BP__c, Bill_to_BP__r.City__c, Ship_to_BP__r.Email__c, Ship_to_BP__r.First_Name__c, Ship_to_BP__r.Last_Name__c, Ship_to_BP__r.Country__c, Ship_to_BP__r.Region__c, Ship_to_BP__r.State__c, Ship_to_BP__r.Street__c, Ship_to_BP__r.ZIP__c, Ship_to_BP__r.City__c FROM opportunity WHERE  id =: opportunityId LIMIT 1 ];
                if(!OpportunityList.isEmpty()){
                    //Update Sap Bp details here from it's account details
                    if(OpportunityList.get(0).Bill_to_BP__c != NULL){
                        setSapBpIds.add(OpportunityList.get(0).Bill_to_BP__c);
                    }
                    if(OpportunityList.get(0).Ship_to_BP__c != NULL) {
                        setSapBpIds.add(OpportunityList.get(0).Ship_to_BP__c);
                    }
                    if(!setSapBpIds.isEmpty()){//CHeck all fields with address verification class
                        passSapBpsList = [ SELECT Id, Care_Of__c, Department__c, Tax_Number_Category__c, Tax_Registration_Number__c, Account_Id__c, Campus_Id__c, Department_Id__c, Has_Valid_BP__c,SAddress_RRAdd_ID__c, Message__c, Name, Address_ID__c, CurrencyIsoCode, City__c, Country__c, State__c, Street__c, ZIP__c, Region__c, First_Name__c, Last_Name__c, Email__c, BP__c, Status__c, Address_Type__c FROM SAP_BP__c WHERE Id IN: setSapBpIds ];
                    } 
                    system.debug('setSapBpIds '+ setSapBpIds +'-----'+' passSapBpsList '+passSapBpsList.size());
                    
                    //To fetch orders out of quote so executing soql
                    List<SBQQ__Quote__c> sbqqQuaoteOrders = new List<SBQQ__Quote__c>([ SELECT Id,SBQQ__Status__c,(select id,Message__c,OpportunityId,IsRecursion__c from SBQQ__Orders__r )FROM SBQQ__Quote__c WHERE Id =: OpportunityList.get(0).SBQQ__PrimaryQuote__c ]);
                    
                    if(!sbqqQuaoteOrders.isEmpty() && sbqqQuaoteOrders != NULL && !sbqqQuaoteOrders.get(0).SBQQ__Orders__r.isEmpty() && sbqqQuaoteOrders.get(0).SBQQ__Orders__r !=NULL) {
                        orderList = sbqqQuaoteOrders.get(0).SBQQ__Orders__r;system.debug('orderList '+orderList);
                    }
                    system.debug('StageName '+OpportunityList.get(0).StageName);
                    if(String.isNotBlank(OpportunityList.get(0).Message__c)){
                        if(!orderList.isEmpty()){
                            //Ckeck if address is not verified and order is present then retry only address verfication here
                            if(OpportunityList.get(0).Message__c.containsIgnoreCase('Address Not Verified') && (!sbqqQuaoteOrders.isEmpty() && sbqqQuaoteOrders != NULL && sbqqQuaoteOrders.get(0).SBQQ__Status__c != 'Accepted') && (OpportunityList.get(0).recordTypeId == recordTypeId || OpportunityList.get(0).recordTypeId == BPCoppRecordTypeId)){
                                system.debug('Only Address Verification Retry');
                                addressVerification(OpportunityList.get(0), passSapBpsList);
                            }
                            //Only direct sales retry
                            else if(!OpportunityList.get(0).Message__c.containsIgnoreCase('Address Not Verified') && (OpportunityList.get(0).Message__c.containsIgnoreCase('Generation Failed') || (orderList.get(0).Message__c == NULL || !orderList.get(0).Message__c.containsIgnoreCase('Tax Calculation-Success') || !orderList.get(0).Message__c.containsIgnoreCase('Posting order to order hub-Success')))){
                                system.debug('Only Direct Sales Retry');
                                if(OpportunityList.get(0).Order_Status__c == 'Failed' && (OpportunityList.get(0).recordTypeId == recordTypeId || OpportunityList.get(0).recordTypeId == BPCoppRecordTypeId)){
                                    //Retry direct sales functionality
                                    directSalesRetry(OpportunityList.get(0), orderList.get(0), passSapBpsList, SapIdToLookupMap, billToBpNotGenerated, shipToBpNotGenerated);
                                } 
                            }
                            //Both address verification and direct sales retry
                            else if(OpportunityList.get(0).Message__c.containsIgnoreCase('Address Not Verified') && (OpportunityList.get(0).Message__c.containsIgnoreCase('Generation Failed') || (orderList.get(0).Message__c == NULL || !orderList.get(0).Message__c.containsIgnoreCase('Tax Calculation-Success') || !orderList.get(0).Message__c.containsIgnoreCase('Posting order to order hub-Success'))))
                            {
                                //In this method we are retrying first address verification then direct sales processs
                                if(OpportunityList.get(0).recordTypeId == BPCoppRecordTypeId)
                                    addressVerificationAndDirectSales(OpportunityList.get(0), orderList.get(0), BPCoppRecordTypeId, SapIdToLookupMap, billToBpNotGenerated, shipToBpNotGenerated, generatedSapBPIdsSet);
                                else addressVerificationAndDirectSales(OpportunityList.get(0), orderList.get(0), recordTypeId, SapIdToLookupMap, billToBpNotGenerated, shipToBpNotGenerated, generatedSapBPIdsSet);
                            }
                        }else{
                            //Ckeck if address is not verified and also order is not present then retry only address verfication here
                            if(OpportunityList.get(0).Message__c.containsIgnoreCase('Address Not Verified') && (OpportunityList.get(0).recordTypeId == recordTypeId || OpportunityList.get(0).recordTypeId == BPCoppRecordTypeId)){
                                addressVerification(OpportunityList.get(0), passSapBpsList);
                            }
                        }
                    }else{
                        //If opportunity's message field is blank then retry both functionalities, address verify and direct sales process
                        if(!orderList.isEmpty()){
                            //In this method we are retrying first address verification then direct sales processs
                            if(OpportunityList.get(0).recordTypeId == BPCoppRecordTypeId)
                                addressVerificationAndDirectSales(OpportunityList.get(0), orderList.get(0), BPCoppRecordTypeId, SapIdToLookupMap, billToBpNotGenerated, shipToBpNotGenerated, generatedSapBPIdsSet);
                            else addressVerificationAndDirectSales(OpportunityList.get(0), orderList.get(0), recordTypeId, SapIdToLookupMap, billToBpNotGenerated, shipToBpNotGenerated, generatedSapBPIdsSet);
                        }else{
                            //Order is not present then retry only address verfication here
                            addressVerification(OpportunityList.get(0), passSapBpsList);
                        }
                    }
				}
            }
            catch(Exception ex){
                System.debug('***********RETRY Exception :' + ex.getMessage() +'****'+ ex.getLineNumber());
            } 
        }
        return messageWrapperClassObj;
    }
    
    //Retry only address verification process
    public static void addressVerification(Opportunity opp, List<SAP_BP__c> passSapBpsList){
        TF_AddressVerification.addressVerificationWrapperClass addressVerificationWrapperClassObj = new TF_AddressVerification.addressVerificationWrapperClass();
        addressVerificationWrapperClassObj.updateSapBpList = new List<SAP_BP__c>();
        addressVerificationWrapperClassObj.oppUpdate = new List<Opportunity>();
        
        system.debug('Only Address Verification Retry');
        //Call this method for address verification retry
        addressVerificationWrapperClassObj = TF_AddressVerification.retryAddressVerification(opp, passSapBpsList); 
        //Update sap bp list and opportunity message field here in address verification retry case
        if(addressVerificationWrapperClassObj.updateSapBpList != NULL && !addressVerificationWrapperClassObj.updateSapBpList.isEmpty()){
            update addressVerificationWrapperClassObj.updateSapBpList;
        }
        if(addressVerificationWrapperClassObj.oppUpdate != NULL && !addressVerificationWrapperClassObj.oppUpdate.isEmpty()){
            update addressVerificationWrapperClassObj.oppUpdate;
        }
    } 
    
    //First we are retrying address verification then direct sales process
    private static void addressVerificationAndDirectSales(Opportunity opp, Order ord, Id recordTypeId, Map<String, Id> SapIdToLookupMap, Boolean billToBpNotGenerated, Boolean shipToBpNotGenerated, Set<Id> generatedSapBPIdsSet){
        system.debug('Both Address and direct sales Retry');
        TF_AddressVerification.addressVerificationWrapperClass addressVerificationWrapperClassObj = new TF_AddressVerification.addressVerificationWrapperClass();
        addressVerificationWrapperClassObj.updateSapBpList = new List<SAP_BP__c>();
        addressVerificationWrapperClassObj.oppUpdate = new List<Opportunity>();
        
        addressVerificationWrapperClassObj = TF_AddressVerification.retryAddressVerification(opp, passSapBpsList);
        if(opp.Order_Status__c == 'Failed' && opp.recordTypeId == recordTypeId && addressVerificationWrapperClassObj != NULL)
        {
            if(addressVerificationWrapperClassObj.oppUpdate != NULL)
            //Retry direct sales functionality
            directSalesRetry(addressVerificationWrapperClassObj.oppUpdate.get(0), ord, addressVerificationWrapperClassObj.updateSapBpList, SapIdToLookupMap, billToBpNotGenerated, shipToBpNotGenerated);
        }
    }
	
    //Retry direct sales functionality 
    private static void directSalesRetry(Opportunity opp, Order ord, List<SAP_BP__c> updatedSapList, Map<String, Id> SapIdToLookupMap, Boolean billToBpNotGenerated, Boolean shipToBpNotGenerated){
        if(opp != NULL && opp.Bill_to_BP__c != NULL){
            if(String.isNotBlank(opp.Bill_to_BP__r.Name) && !opp.Bill_to_BP__r.Name.containsIgnoreCase('PENDING') && opp.Bill_to_BP__r.Has_Valid_BP__c == true){
                generatedSapBPIdsSet.add(opp.Bill_to_BP__c);
            }else{
                sapBPIdsSet.add(opp.Bill_to_BP__c);
                billToBpNotGenerated = true;
            }
            SapIdToLookupMap.put('Bill to', opp.Bill_to_BP__c);
        }
        if(opp != NULL && opp.Ship_to_BP__c != NULL){
            if(String.isNotBlank(opp.Ship_to_BP__r.Name) && !opp.Ship_to_BP__r.Name.containsIgnoreCase('PENDING') && opp.Ship_to_BP__r.Has_Valid_BP__c == true){
                generatedSapBPIdsSet.add(opp.Ship_to_BP__c);
            }else{
                sapBPIdsSet.add(opp.Ship_to_BP__c);
                shipToBpNotGenerated = true;
            }
            SapIdToLookupMap.put('Ship to', opp.Ship_to_BP__c);
        }
        for (SAP_BP__c sapObj  : updatedSapList) {
            if(String.isBlank(sapObj.Message__c) || (String.isNotBlank(sapObj.Message__c) && !sapObj.Message__c.containsIgnoreCase('Address Verified'))) addressNotVerifiedSapBPIdsSet.add(sapObj.id);
        }
        
        //If address is not verified then update sap bp and opportunity message field here	
        if(!addressNotVerifiedSapBPIdsSet.isEmpty()){	
            system.debug('addressNotVerifiedSapBPIdsSet '+addressNotVerifiedSapBPIdsSet);
            for(SAP_BP__c sapBp : updatedSapList){	
                if(!sapBp.Message__c.containsIgnoreCase('Address Verified')) sapBpList.add(sapBp);
                else updateSapBpList.add(sapBp);
            }
            if(!sapBpList.isEmpty() && sapBpList != NULL){
                for(SAP_BP__c sapBp : sapBpList){	
                    //In this method we are updating sap bp message field 	
                    SAP_BP__c sap = new SAP_BP__c();
                    sap = updateSapMessage(sapBp, 'Please verify address first', SapIdToLookupMap);
                    updateSapBpList.add(sap);											
                }	
            }
            updateOppMessage(updateSapBpList, oppId);
        }
        //If sap bp number is already generated then call order tax calculation class
        else if(!billToBpNotGenerated && !shipToBpNotGenerated && !generatedSapBPIdsSet.isEmpty() && generatedSapBPIdsSet != NULL){
            system.debug('Order Call');
            system.debug('generatedSapBPIdsSet '+generatedSapBPIdsSet);
            //When sap bp number is already created then do order tax calculation callout directly 
            TF_OrderTaxCalculation_Handler.orderCallout(ord.id, true, true, opp, updatedSapList);	
        } 
        else if(!sapBPIdsSet.isEmpty() && sapBPIdsSet != NULL){
            //Call this method to do callout for sap bp number creation
            system.debug('sapBPIdsSet '+sapBPIdsSet);
            TF_SAP_BP_Creation_Handler.directSalesRetry(updatedSapList, opp, SapIdToLookupMap, ord.id, opp.Account.Name);
        } 
    }
    
	//Call this method in case of address not verified and update sapbpList and opportunity here	
    public static SAP_BP__c updateSapMessage(SAP_BP__c sapBp, String messageString, Map<String, Id> SapIdToLookupMap){	
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
        return sapBp;	
    }
    
    public static void updateOppMessage(List<SAP_BP__c> updateSapBpList, String opportunityId){
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
    
    public class messageWrapperClass{
        @AuraEnabled
        public List<String> successMessageList;
        @AuraEnabled
        public List<String> errorMessageList;
    }
    
    
}