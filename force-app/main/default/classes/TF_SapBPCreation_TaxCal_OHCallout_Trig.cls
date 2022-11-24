/*
* Test Class: ztest_TF_SapBPCreation_TaxCal_OHCallout
* Description :  After quote update trigger for direct sales process
* Created by Piyush Jain
*/
public class TF_SapBPCreation_TaxCal_OHCallout_Trig implements TriggerInterface_SBQQ_Quote.Runnable{
    Id quoteOARecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('T&F - OA Journal Quote').getRecordTypeId();
    Id oppOARecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F OA Journal Opportunity').getRecordTypeId();

    Id quoteRecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Automated eBook Direct Sales Orders').getRecordTypeId();
    Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F Automated eBooks Opportunity').getRecordTypeId();
    
    Id BPCquoteRecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('T&F - BPC Quote Type').getRecordTypeId();
    Id BPCoppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F - OA BPC Opportunity').getRecordTypeId();
    
    String bespokeProductRTId = PCMOppSyncControllerDS.getProdRecordTypeId('Product2', 'T&F - BespokeCollection');
    
    private static boolean run = true;
    private Set<Id> quoteIdSet = new Set<Id>();
    private Set<Id> oppIdSet = new Set<Id>();
    private List<SBQQ__Quote__c> sbqqQuaoteList = new List<SBQQ__Quote__c>();
    private List<Opportunity> OpportunityList = new List<Opportunity>();
    
    public static boolean runOnce1(){
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
    
    public void run(TriggerInterface_SBQQ_Quote.Trig trig){
        if(runOnce1()){
            List<order> orderList = new List<Order>();
            SBQQ__Quote__c  quoteObj = new SBQQ__Quote__c(); 
            quoteObj = trig.newList[0];
            
            // to fetch orders out of quote so executing soql 
            List<SBQQ__Quote__c> sbqqQuaoteOrders = new List<SBQQ__Quote__c>([ SELECT Id,(select id,OpportunityId,IsRecursion__c from SBQQ__Orders__r ), ( SELECT id, SBQQ__Product__c, SBQQ__Product__r.RecordTypeId, SBQQ__Product__r.Product_Type_Author_Facing__c FROM SBQQ__LineItems__r ) FROM SBQQ__Quote__c WHERE Id =: quoteObj.id ]);
            
            if(!sbqqQuaoteOrders.isEmpty() && sbqqQuaoteOrders.get(0).SBQQ__Orders__r !=NULL ) orderList = sbqqQuaoteOrders.get(0).SBQQ__Orders__r;
            
            Order orderObj = new Order();
            
            //if((trig.isAfter && trig.isUpdate && quoteObj.SBQQ__Primary__c == true  && quoteObj.SBQQ__Status__c == 'Accepted' && quoteObj.RecordTypeID  == quoteRecordTypeId  && trig.oldList.get(0) != NULL && trig.oldList.get(0).SBQQ__Status__c != 'Accepted'  && !orderList.isEmpty()  ))
            if(trig.isAfter && trig.isUpdate && quoteObj.SBQQ__Status__c == 'Accepted')
            {   
                if(quoteObj.SBQQ__Primary__c == true && (quoteObj.RecordTypeID  == quoteRecordTypeId || quoteObj.RecordTypeID  == quoteOARecordTypeId || quoteObj.RecordTypeID  == BPCquoteRecordTypeId)  && trig.oldList.get(0) != NULL && trig.oldList.get(0).SBQQ__Status__c != 'Accepted'  && !orderList.isEmpty())
                {
                    /********************** SFAL-317 START **********************/
                    //SFAL-317 Vikas Varshney
                    SBQQ__QuoteLine__c bespokeCollection = new SBQQ__QuoteLine__c();
                    String bespokeDefinitionModel = '';
                    
                    if ( !sbqqQuaoteOrders.isEmpty() && !sbqqQuaoteOrders[0].SBQQ__LineItems__r.isEmpty() ) {
                        for ( SBQQ__QuoteLine__c bespokeQLI : sbqqQuaoteOrders[0].SBQQ__LineItems__r ) {
                            if ( bespokeQLI.SBQQ__Product__r.RecordTypeId == bespokeProductRTId ) {
                                bespokeCollection = bespokeQLI;
                                bespokeDefinitionModel = bespokeQLI.SBQQ__Product__r.Product_Type_Author_Facing__c;
                            }
                        }
                    }
                    
                    if ( bespokeCollection != NULL ) {
                        if ( String.isNotBlank(bespokeDefinitionModel) && 'Manual Curation'.equalsIgnoreCase(bespokeDefinitionModel) ) {
                            String bespokeJobId = Database.executeBatch(new TF_Batch_SubmitStaticColToPcm(bespokeCollection.SBQQ__Product__c), 1);
                            System.debug('bespokeJobId =====>'+ bespokeJobId);
                        } else if ( String.isNotBlank(bespokeDefinitionModel) && 'Rule based'.equalsIgnoreCase(bespokeDefinitionModel) ) {
                            TF_PPDProcessController.submitDynamicPackageToPCMasynch(bespokeCollection.SBQQ__Product__c);
                            System.debug('***** Inside Dynamic Bespoke *****');
                        }
                    }
                    
                    /********************** SFAL-317 END **********************/
                    
                    // fetch the order related to the quote 
                    // SELECT Active_Quote__c,Id,(select id from SBQQ__Orders__r )FROM SBQQ__Quote__c WHERE Id =: quoteObj.id                
                    
                    System.debug('orderList'+orderList);
                    if (!orderList.isEmpty()) {
                        orderObj = orderList.get(0);
                    }
                    for(Order ord : orderList){                    
                        System.debug('quoteIdSet =====>'+quoteIdSet);
                        if ( ord.OpportunityId != NULL ) {
                            oppIdSet.add(ord.OpportunityId);
                        }
                        System.debug('oppIdSet =====>'+oppIdSet);
                    }
                    
                    // sbqqQuaoteList = [ SELECT RecordTypeId,id,SBQQ__Status__c,SBQQ__Primary__c,Quote_Type__c,Purchase_Order_Number__c FROM SBQQ__Quote__c WHERE  id IN:quoteIdSet LIMIT 1 ];                                                        
                    sbqqQuaoteList = trig.newList;
                    OpportunityList = [ SELECT Account.Name, Order_Status__c, id, Ship_to_BP__r.Name,Bill_to_BP__r.Name, Bill_to_BP__r.Has_Valid_BP__c, Ship_to_BP__r.Has_Valid_BP__c, Bill_to_BP__r.Message__c, Ship_to_BP__r.Message__c, RecordTypeId,Message__c,Sold_to_BP__c,Ship_to_BP__c,Payer_BP__c,StageName,AccountId,Bill_to_BP__r.Email__c, Name, Bill_to_BP__r.First_Name__c, Bill_to_BP__r.Last_Name__c, Bill_to_BP__r.Country__c, Bill_to_BP__r.Region__c, Bill_to_BP__r.State__c, Bill_to_BP__r.Street__c, Bill_to_BP__r.ZIP__c, Bill_to_BP__c, Bill_to_BP__r.City__c FROM opportunity WHERE  id IN:oppIdSet LIMIT 1 ];
                    System.debug('sbqqQuaoteList =====>'+sbqqQuaoteList);
                    System.debug('sbqqQuaoteList Size =====>'+sbqqQuaoteList.size());
                    System.debug('OpportunityList =====>'+OpportunityList);
                    System.debug('OpportunityList Size =====>'+OpportunityList.size());
                    system.debug('***********IsRecursion__c'+orderObj.IsRecursion__c);
                    system.debug('sbqqQuaoteList.get(0).SBQQ__Status__c '+sbqqQuaoteList.get(0).SBQQ__Status__c);
                    system.debug('OpportunityList.get(0).StageName '+OpportunityList.get(0).StageName);
                    system.debug('sbqqQuaoteList.get(0).SBQQ__Primary__c '+sbqqQuaoteList.get(0).SBQQ__Primary__c);
                    system.debug('sbqqQuaoteList.get(0).SBQQ__Status__c '+sbqqQuaoteList.get(0).SBQQ__Status__c);
                    system.debug('sbqqQuaoteList.get(0).RecordTypeID '+sbqqQuaoteList.get(0).RecordTypeID);
                    system.debug('OpportunityList.get(0).RecordTypeID '+OpportunityList.get(0).RecordTypeID);
                    system.debug('OpportunityList.get(0).Order_Status__c '+OpportunityList.get(0).Order_Status__c);
                    
                    if(orderObj!= NULL && orderObj.IsRecursion__c == false && (OpportunityList.get(0).Order_Status__c == 'Pending' || OpportunityList.get(0).Order_Status__c == 'Failed') && sbqqQuaoteList.get(0).SBQQ__Primary__c == true && 
                       ((sbqqQuaoteList.get(0).RecordTypeID == quoteRecordTypeId && OpportunityList.get(0).RecordTypeID == oppRecordTypeId) ||  (sbqqQuaoteList.get(0).RecordTypeID == quoteOARecordTypeId && OpportunityList.get(0).RecordTypeID == oppOARecordTypeId) || (sbqqQuaoteList.get(0).RecordTypeID == BPCquoteRecordTypeId && OpportunityList.get(0).RecordTypeID == BPCoppRecordTypeId))) {
                        TF_SAP_BPcreation.sap_BP_Details(OpportunityList[0], orderObj.id);
                    }
                }else{
                    trig.newList[0].addError('Please try after sometime ! ');
                    
                }
            }
        }        
    }
}