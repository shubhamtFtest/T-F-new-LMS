/*
* Test Class: zTEST_TF_SAP_BP_updateCountryISOCode
* Description : After insert and after update trigger updates country code on SAP BP
* Created by Piyush Jain
*/
public class TF_SAP_BP_updateCountryISOCode implements TriggerInterface_SAP_BP.Runnable{
    
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
    
    public void run(TriggerInterface_SAP_BP.Trig trig){
        Set<Id> sapBPIdsSet = new Set<Id>();
        Set<String> sapBPCountrySet = new Set<String>();
        map<string,Country__c> countryMap = new map<string,Country__c>() ;
        List<SAP_BP__c> updateSapBpList = new List<SAP_BP__c>();
        String countryISOCode;
        //Run this trigger only once 
        if(runOnce1()){ 
            //After inset and after update trigger on sap bp object
            if((trig.isAfter && trig.isInsert) || (trig.isAfter && trig.isUpdate)){ 
                for(SAP_BP__c sapBp : trig.newList){ 
                    sapBPIdsSet.add(sapBp.id);
                    if(String.isNotBlank(sapBp.Country__c)){
                        sapBPCountrySet.add(sapBp.Country__c);
                    }
                }
                
                //If sapBPCountrySet is not empty then do query from country object and put the data in country name to country object map
                if(!sapBPCountrySet.isEmpty()){
                    for(Country__c country : [SELECT Country_2__c, Name FROM Country__c where Name In : sapBPCountrySet]){
                        if(country.Name!=null){
                            if(String.isNotBlank(country.Country_2__c)){
                                countryMap.put(country.Name,country);
                            }
                        }
                    }
                }
                //If sapBPIdsSet is not empty then do query on sap bp object and get country of sap bp
                if(!sapBPIdsSet.isEmpty()){
                    for(SAP_BP__c sap : [SELECT Id, Country_Code__c, Country__c FROM SAP_BP__c WHERE Id IN: sapBPIdsSet]){
                        
                        if(String.isNotBlank(sap.Country__c) && countryMap.containsKey(sap.Country__c)){
                            //Get country code from country name to country object map accordingly
                            countryISOCode = countryMap.get(sap.Country__c).Country_2__c;
                            if(String.isNotBlank(countryISOCode)){
                                sap.Country_Code__c = countryISOCode;
                            }
                        }
                        //If sap country is blank then black country code too if present
                        else if(String.isBlank(sap.Country__c) && String.isNotBlank(sap.Country_Code__c)) sap.Country_Code__c = ''; 
                        updateSapBpList.add(sap); 
                    }
                }
                if(!updateSapBpList.isEmpty()) update updateSapBpList; 
            }
        }
        
    }
}