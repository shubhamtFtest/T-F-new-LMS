public with sharing class TFOAC_OCAJournalTriggerClass {
	/*
     * List fields which will be tracked under opportunity lin
     */ 
    public static final List<String> fieldsToTrack = new List<String>{'CurrentAnnualTurnover__c','EstimatedGrossMarginYear1__c',
        															  'EstimatedYear1Turnover__c','Purchase_price__c',
        															  'SignOnFee__c','WeightedTurnoverYear1__c','OACOpportunity__c'};
    
    public static void setFieldsUnderOpportunity(String field,TFOAC_Opportunity__c op,String opportunityField,String lineItemField, AggregateResult ag,Double conversionRate){
        //system.debug('****setFieldsUnderOpportunity callout input params '+field+';'+ag+';'+conversionRate);
        Decimal convertedAmount = ag.get(field) == null ? null : (Decimal)ag.get(field)*conversionRate;    
        if(ag.get(field) != null){
            op.put(opportunityField,convertedAmount);
        }else{
            op.put(opportunityField,null);
        }  
    }
    
    public static void calculateOpportunityAmounts(Map<Id,TFOAC_Journal__c> recordsToPorcess,Map<Id,TFOAC_Journal__c> oldMap){
        Map<Id,TFOAC_Journal__c> recordsToPorcessTemp = recordsToPorcess.clone();
        Set<Id> opportunityIDs = new Set<ID>();
        
        for(TFOAC_Journal__c item : recordsToPorcessTemp.values()){
            opportunityIDs.add(item.OACOpportunity__c);
            if(oldMap != null){
                opportunityIDs.add(oldMap.get(item.id).OACOpportunity__c);
            }

        }
        
        List<RecordType> rt = [SELECT Id FROM RecordType WHERE SobjectType = 'TFOAC_Opportunity__c' AND DeveloperName = 'TFOAC' LIMIT 1];
          
        Set<ID> opportunityRecordsToProcess = new Set<ID>();
        //below set have the journal which were unAligned from opportunity
        Set<ID> journalsWhichShouldNotBeCalculated = new Set<ID>();
        Map<ID,Map<String,Boolean>> opportunityVSChangedFields = new Map<ID,Map<String,Boolean>>();
        Map<Id,String> opportunitiesCurrency = new Map<Id,String>();
        //process only opportunity line items which are alinged to opportunities with record type Acquisition
        for(TFOAC_Opportunity__c opp : [Select Id,CurrencyIsoCode FROM TFOAC_Opportunity__c WHERE id in : opportunityIDs and RecordTypeId =: rt.get(0).id]){
            
            //track opportunities currencies
            opportunitiesCurrency.put(opp.id,opp.CurrencyIsoCode);
            opportunityRecordsToProcess.add(opp.id);
        }
        
       
       
        Map<String,Double> currencyConvertionRates = new Map<String,Double>();
        for(CurrencyType cType :[SELECT conversionrate,isocode FROM currencytype WHERE isocode =: opportunitiesCurrency.values()]){
            currencyConvertionRates.put(cType.isocode,cType.conversionrate);
        }
        
        
        Map<Id,TFOAC_Opportunity__c> opportunitiesToUpdate = new Map<Id,TFOAC_Opportunity__c>();
        
        Set<ID> opportunitiesToReset = opportunityRecordsToProcess.clone();
		TF_Acqusition_Setting__c tfSetting = TF_Acqusition_Setting__c.getOrgDefaults();
        //sum(EstimatedGrossMarginYear1__c) estGross,
        system.debug('check list of journlas which should be excluded:'+journalsWhichShouldNotBeCalculated);
        for(AggregateResult ag : [Select sum(CurrentAnnualTurnover__c) currentTurnOver, 
                                sum(EstimatedYear1Turnover__c) estTurnOver,sum(Purchase_price__c) purchasePrice, sum(SignOnFee__c) signFee, 
                                sum(WeightedTurnoverYear1__c) weightedTurnOver,OACOpportunity__c 
                                From TFOAC_Journal__c
                                WHERE  OACOpportunity__c in: opportunityRecordsToProcess and OACOpportunity__r.RecordTypeId =: rt.get(0).id 
                                GROUP BY OACOpportunity__c]){
                                    
      		Id OpportunityId = (ID)ag.get('OACOpportunity__c');
            opportunitiesToReset.remove(OpportunityId);
       		TFOAC_Opportunity__c oppToUpdate = new TFOAC_Opportunity__c(); 
            oppToUpdate.Id = OpportunityId;
            Double conversionRate = 1;
            try{
                //if(!tfSetting.IsDataLoad__c){
               		conversionRate = currencyConvertionRates.get(opportunitiesCurrency.get(oppToUpdate.Id));     
                //}
                
            }catch(Exception ex){
               system.debug('In system there is not defined convertion rates for this currency'+opportunitiesCurrency.get(oppToUpdate.Id)+'System used default orgazniaztion currency'); 
            }                                    
            
            //setFieldsUnderOpportunity('estGross',oppToUpdate,'EstimatedGrossMarginYear1__c','EstimatedGrossMarginYear1__c',ag,opportunityVSChangedFields.get(oppToUpdate.Id),conversionRate);
			setFieldsUnderOpportunity('weightedTurnOver',oppToUpdate,'Weighted_Turnover_Year_1__c','WeightedTurnoverYear1__c',ag,conversionRate);
            setFieldsUnderOpportunity('estTurnOver',oppToUpdate,'Year_1_turnover__c','EstimatedYear1Turnover__c',ag,conversionRate);
            setFieldsUnderOpportunity('purchasePrice',oppToUpdate,'Purchase_price__c','Purchase_price__c',ag,conversionRate);
            setFieldsUnderOpportunity('signFee',oppToUpdate,'Sign_on_fee__c','SignOnFee__c',ag,conversionRate);
            setFieldsUnderOpportunity('currentTurnOver',oppToUpdate,'CurrentAnnualTurnover__c','CurrentAnnualTurnover__c',ag,conversionRate);                             
            
            opportunitiesToUpdate.put(oppToUpdate.id,oppToUpdate);                        
       }
       // calculate estimate gross margin
       Map<Id,Decimal> fullEstimateAmount = new Map<Id,Decimal>();
       Map<Id,Decimal> partialEstimateAmount = new Map<Id,Decimal>();
       //if(UserInfo.getUserId() == '005m0000001kt37AAA'){
       for(TFOAC_Journal__c oppLineItem  : [Select EstimatedYear1Turnover__c,EstimatedGrossMarginYear1__c,OACOpportunity__c 
                                                    From TFOAC_Journal__c
                                                    WHERE  OACOpportunity__c in: opportunityRecordsToProcess and OACOpportunity__r.RecordTypeId =: rt.get(0).id
                                                    Order BY OACOpportunity__r.Name]){
                                                         
                                                     
              		if(fullEstimateAmount.containsKey(oppLineItem.OACOpportunity__c)){
                        Decimal temp = fullEstimateAmount.get(oppLineItem.OACOpportunity__c);
                    	temp += oppLineItem.EstimatedYear1Turnover__c == null ? 0 : oppLineItem.EstimatedYear1Turnover__c; 
                        fullEstimateAmount.put(oppLineItem.OACOpportunity__c,temp);
                    }else{
                        Decimal temp = oppLineItem.EstimatedYear1Turnover__c == null ? 0 : oppLineItem.EstimatedYear1Turnover__c;
                        fullEstimateAmount.put(oppLineItem.OACOpportunity__c,temp);
                    }
                    //calculate amounts                                    
                    if(partialEstimateAmount.containsKey(oppLineItem.OACOpportunity__c)){
                        Decimal temp = partialEstimateAmount.get(oppLineItem.OACOpportunity__c);
                        Decimal tempEstAmount = oppLineItem.EstimatedYear1Turnover__c == null ? 0 : oppLineItem.EstimatedYear1Turnover__c;
                        Decimal tempPercent = oppLineItem.EstimatedGrossMarginYear1__c == null ? 0 : oppLineItem.EstimatedGrossMarginYear1__c; 
                    	temp += (tempEstAmount * tempPercent)/100; 
                        partialEstimateAmount.put(oppLineItem.OACOpportunity__c,temp);
                    }else{
                        Decimal temp = oppLineItem.EstimatedYear1Turnover__c == null ? 0 : oppLineItem.EstimatedYear1Turnover__c;
                        Decimal tempPercent = oppLineItem.EstimatedGrossMarginYear1__c == null ? 0 : oppLineItem.EstimatedGrossMarginYear1__c; 
                    	temp = (temp * tempPercent)/100; 
                        partialEstimateAmount.put(oppLineItem.OACOpportunity__c,temp);
                    }                                    
              }
              for(Id oppId : fullEstimateAmount.keySet()){
                  TFOAC_Opportunity__c oppToUpdate = new TFOAC_Opportunity__c(); 
                  if(opportunitiesToUpdate.containsKey(oppId)){
                    oppToUpdate = opportunitiesToUpdate.get(oppId);
                  }else{
                      oppToUpdate.Id = oppId;
                  }
            	  
                  if(fullEstimateAmount.get(oppId) != 0){
                      oppToUpdate.EstimatedGrossMarginYear1__c = (partialEstimateAmount.get(oppId)/fullEstimateAmount.get(oppId))*100;
                  }else{
                      oppToUpdate.EstimatedGrossMarginYear1__c = null;
                  }
                  
                  opportunitiesToUpdate.put(oppId,oppToUpdate); 
       }
       //}
        
       if(!opportunitiesToReset.isEmpty()){
            //all opportunity line items were removed need to reset values under opportunities
            for(ID opportunityID : opportunitiesToReset){
                TFOAC_Opportunity__c oppToUpdate = new TFOAC_Opportunity__c();
                if(opportunitiesToUpdate.containsKey(opportunityID)){
                    oppToUpdate = opportunitiesToUpdate.get(opportunityID);
                }else{
                    oppToUpdate.Id = opportunityID;
                }
                oppToUpdate.EstimatedGrossMarginYear1__c = null;
				oppToUpdate.Weighted_Turnover_Year_1__c = null;                              
                oppToUpdate.Year_1_turnover__c = null;
                oppToUpdate.Purchase_price__c = null;
                oppToUpdate.Sign_on_fee__c = null;
                oppToUpdate.CurrentAnnualTurnover__c = null;
                opportunitiesToUpdate.put(opportunityID,oppToUpdate);                        
            }
        }
        
        try{
            update opportunitiesToUpdate.values();    
        }catch(Exception ex){
            if(ex.getMessage().containsIgnoreCase('Doesn\'t have access to opportunity with Publishing office:')){
                system.debug('do not throw this error for user under interface');
            }else{
                throw new JournalTriggerException(ex.getMessage());
            }
        }
        
        
        
        
        
    }

    public static void updateHostAreaText(List<TFOAC_Journal__c> newJournals){
        //proceess only T&F - Journal Products
        List<RecordType> rt = [SELECT Id FROM RecordType WHERE SobjectType = 'TFOAC_Journal__c' AND DeveloperName = 'TFOAC' LIMIT 1];
        if(rt.size() == 0){
            return;
        }
        
        Set<Id> hierarchyCodeIds = new Set<Id>();
        Map<Id,TFOAC_Hierarchy_Code__c> hierarchyCodeMap = new Map<Id,TFOAC_Hierarchy_Code__c>();
        for(TFOAC_Journal__c journal : newJournals){
            if(journal.RecordTypeId == rt.get(0).Id && journal.Host_AreaCode__c != null){
                
                hierarchyCodeIds.add(journal.Host_AreaCode__c);
            }
        }

        system.debug('check hierarchy Code List: '+hierarchyCodeIds);
        if(!hierarchyCodeIds.isEmpty()){
            hierarchyCodeMap = new Map<Id,TFOAC_Hierarchy_Code__c>([Select id,Name FROM TFOAC_Hierarchy_Code__c WHERE id in: hierarchyCodeIds]);
        }

        for(TFOAC_Journal__c journal : newJournals){
            if(journal.AcqType__c == 'Digital Content'){
                journal.Host_Area_Text__c = TFOAC_OpportunityTriggerClass.getHostAreaTextField(journal.AcqType__c);
                system.debug('check if journal sharing was set:'+journal);
            }else if(journal.Host_AreaCode__c != null && hierarchyCodeMap.containsKey(journal.Host_AreaCode__c)){
                journal.Host_Area_Text__c = TFOAC_OpportunityTriggerClass.getHostAreaTextField(hierarchyCodeMap.get(journal.Host_AreaCode__c).Name);
            }

        }
        
    }

    public class JournalTriggerException extends Exception{

    }
}