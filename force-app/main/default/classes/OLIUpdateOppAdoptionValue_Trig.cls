/*
Created by		: Syam Nukilla
Created Date	: 2020.04.24
Description		: for an incoming OLI record, if there is any change in Adoption_Level__c then 
				  check the Adoption_Value_Criteria__mdt custom meta data for calculations based on country 
                  which is fetched from account mailing list field and update the adoption value in Opportunity,  
Test Class		: zTest_OLIUpdateOppAdoptionValue @ 100%
************************************************************
Last Modified by Jeff Lup - 2020.12.03 - Case# 01717571
************************************************************
Last Modified by Renil Rejith - 2021.11.09 - User story:SAL4958
Description:* fix-1: Changed the class to run on before trigger events because a custom field 
					 had to be populated on OLI object.
			* fix-2: To prevent adoption value calculation when the Product's sales price is less than 0.	
			* fix-3: Calculating the oli's Total price manually as the system generated field(oli.TotalPrice) is returning null
					 for before trigger events.
			* fix-4: Condition to prevent recalculation of adoption values when adoption level/added value/x100 enrollment 
			  		 is NOT changed.
 			* fix-5: Storing each products adoption value in its record.
			* fix-6: Trigger updation on Opportunity record is not required as a rollup summary field is now used to 
					 calculate Forecast Adoption Value
************************************************************
*/
public without sharing class OLIUpdateOppAdoptionValue_Trig implements TriggerInterface_OLI.Runnable {
    public void run(TriggerInterface_OLI.Trig trig) {
        //if (trig.isAfter && (trig.isInsert || trig.isUpdate) ){
		if (trig.isBefore && (trig.isInsert || trig.isUpdate) ){ //User story - SAL4958 fix-1
            Map<String,Adoption_Value_Criteria__mdt> cmdtMap = new Map<String,Adoption_Value_Criteria__mdt>();
            Decimal adptSellthrPrcnt = 0.0;
            Decimal adptDisPrcnt = 0.0;
            Decimal oliTotalPrice = 0.0; 
            Decimal adptValue = 0.0;
            Map<String,Decimal> oppAdptValMap = new Map<String,Decimal>(); //Map to hold OppId and Adoption value.  
            List<Opportunity> oppListToUpdate = new List<Opportunity>();//To update the Adoption value field on Opportunity.             
            
            //for fetching the custom metadata values to calculate Adoption value based on Country.  
            for(Adoption_Value_Criteria__mdt cmdt: [SELECT Country__c,HR_Sell_Through__c,HR_Discount__c,
                                                    Core_Sell_Through__c, Effect_On_ST_of_100_Enrollment_or_AV__c,
                                                    Core_Discount__c, Effect_on_Discount_100_Enrollment_or_AV__c
                                                    FROM Adoption_Value_Criteria__mdt]){
                    cmdtMap.put(cmdt.Country__c,cmdt);
            }
            
            // for getting Mailist list value from account
            Set<String> oppIdSet = new Set<String>();
            for(OpportunityLineItem oli:trig.newList){
                oppIdSet.add(oli.OpportunityId);
            }
            Map<String,String> oppAccCountryMap = new Map<String,String>();
            for(Opportunity opp:[SELECT Id,Account.Mailing_Country_List__c FROM Opportunity WHERE Id IN:oppIdSet]){
                oppAccCountryMap.put(opp.Id, opp.Account.Mailing_Country_List__c);
            }
            
            //for an incoming record to get the values from MDT and calucalute Adoption value.
            for(OpportunityLineItem oli:trig.newList){
                /*if( (trig.isInsert && oli.Adoption_Level__c != Null)||(trig.isUpdate && oli.Adoption_Level__c != Null &&
                                                             (oli.Adoption_Level__c != trig.oldMap.get(oli.Id).Adoption_Level__c ||
                                                              oli.Quantity != trig.oldMap.get(oli.Id).Quantity ||
                                                              oli.X100_Enrolment__c != trig.oldMap.get(oli.Id).X100_Enrolment__c ||
                                                              oli.Added_Value__c != trig.oldMap.get(oli.Id).Added_Value__c ||
                                                              oli.UnitPrice != trig.oldMap.get(oli.Id).UnitPrice) )){ */
                /*if( trig.isInsert || (trig.isUpdate &&
                                      (oli.Adoption_Level__c != trig.oldMap.get(oli.Id).Adoption_Level__c ||
                                       oli.Quantity != trig.oldMap.get(oli.Id).Quantity ||
                                       oli.X100_Enrolment__c != trig.oldMap.get(oli.Id).X100_Enrolment__c ||
                                       oli.Added_Value__c != trig.oldMap.get(oli.Id).Added_Value__c ||
                                       oli.UnitPrice != trig.oldMap.get(oli.Id).UnitPrice) )){ //Case 01717571
                */
                
                if( trig.isInsert || trig.isUpdate ){ //Case 01717571  temporary  
                    if(oli.UnitPrice > 0) //User story - SAL4958 fix-2
                    {
                        //commented By renil for SAL-4958 fix
                        //oliTotalPrice = oli.TotalPrice;
                        if(oli.Discount != null)//User story - SAL4958 fix-3
                        {
                            oliTotalPrice = (oli.UnitPrice-(oli.UnitPrice*oli.Discount))*oli.Quantity; 
                        }
                        else
                        {
                            oliTotalPrice = (oli.UnitPrice-(oli.UnitPrice*0))*oli.Quantity;
                        }
                        System.debug('totalPrice '+oliTotalPrice);
                        String countryStr = oppAccCountryMap.get(oli.OpportunityId); 
                        //String countryStr = oli.Opportunity.Account.Mailing_Country_List__c; 
                        System.debug('countryStr-->'+countryStr);
                        if(oli.Adoption_Level__c == 'Highly Recommended'){
                            adptSellthrPrcnt = cmdtMap.get(countryStr).HR_Sell_Through__c;  
                            adptDisPrcnt = cmdtMap.get(countryStr).HR_Discount__c;
                        //}else if(oli.Adoption_Level__c == 'Core Text'){
                        }else if(oli.Adoption_Level__c == null || oli.Adoption_Level__c == 'Core Text'){
                            if(oli.Added_Value__c != null || oli.X100_Enrolment__c != null){
                                adptSellthrPrcnt = cmdtMap.get(countryStr).Core_Sell_Through__c 
                                                   + cmdtMap.get(countryStr).Effect_On_ST_of_100_Enrollment_or_AV__c;
                                adptDisPrcnt = cmdtMap.get(countryStr).Core_Discount__c 
                                                   + cmdtMap.get(countryStr).Effect_on_Discount_100_Enrollment_or_AV__c;
                            }else{
                                adptSellthrPrcnt = cmdtMap.get(countryStr).Core_Sell_Through__c;
                                adptDisPrcnt = cmdtMap.get(countryStr).Core_Discount__c;
                            }
                        }else{ 
                            adptSellthrPrcnt = 0.0;
                            adptDisPrcnt = 0.0;
                        }
                        //User story - SAL4958 fix-4
                        if(trig.isInsert || (trig.isUpdate && (oli.Added_Value__c != trig.oldMap.get(oli.Id).Added_Value__c || 
                                             oli.X100_Enrolment__c != trig.oldMap.get(oli.Id).X100_Enrolment__c ||
                                             oli.Adoption_Level__c != trig.oldMap.get(oli.Id).Adoption_Level__c || 
                                             oli.System_ID__c != trig.oldMap.get(oli.Id).System_ID__c)))
                        {
                            adptValue = oliTotalPrice * adptSellthrPrcnt * (1-adptDisPrcnt);
                            System.debug('adptValue '+adptValue);
                            //commented below for SAL4958 fix
                        	//oppAdptValMap.put(oli.OpportunityId,adptValue);
                            oli.Adoption_Value__c  = adptValue;//User story - SAL4958 fix-5
                            System.debug('oli.Adoption_Value__c '+oli.Adoption_Value__c);
                        }    
                    }  
                }
            }// end of for loop
            
            //commented below for User story - SAL4958 fix-6
            //getting related Opp for an incoming product and updation Adoption value on this Opp. 
            /*if(oppAdptValMap != Null){
                System.debug('oppAdptValMap-->'+oppAdptValMap.keyset());
                for(Opportunity opp:[SELECT Id,Adoption_Value2__c FROM Opportunity WHERE Id IN:oppAdptValMap.keySet()]){
                    System.debug('opp.Adoption_Value2__c *** '+opp.Adoption_Value2__c);
                    //opp.Adoption_Value2__c = oppAdptValMap.get(opp.Id);
                    //
                    if(opp.Adoption_Value2__c != null)//User story - SAL4958
                    {
                        opp.Adoption_Value2__c += oppAdptValMap.get(opp.Id);
                    }
                    else
                    {
                        opp.Adoption_Value2__c = oppAdptValMap.get(opp.Id);
                    }
                    oppListToUpdate.add(opp);  
                    System.debug('opp.Adoption_Value2__c--> '+opp.Adoption_Value2__c);
                }
            }
            if(!oppListToUpdate.isEmpty()){ 
                update oppListToUpdate;
            }*/
        } // end of after if cond.
    }// end of run method    
}