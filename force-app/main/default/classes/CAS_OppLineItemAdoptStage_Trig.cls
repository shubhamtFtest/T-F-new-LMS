/*
** Tested by: zTest_CAS_OppLineItemAdoptStage.cls
**
** CHG0039660 Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2011.12.13
** Modified by Jeff Lup - 2015.02.27 - Moved Trigger into this TrigClass
*/

public without sharing class CAS_OppLineItemAdoptStage_Trig implements TriggerInterface_OLI.Runnable {
    public void run(TriggerInterface_OLI.Trig trig) {
        if (trig.isAfter && trig.isUpdate) {
            if (trig.newList.size() == 1) { //We only want this to run if a business user updates the record 
            
                String closedVal = 'Closed By Sales Rep';
                list<CAS_Inspection_Copy__c> updateAdoptStages = new list<CAS_Inspection_Copy__c>();
                Map<Id,string> mapAdoptStage = new Map<Id,string>();
                for (Integer i=0;i<trig.newList.size();i++) {
                    if (trig.newList[i].LastModifiedById != '0050Y000002IwmG' && trig.newList[i].Adoption_Stage__c != trig.oldList[i].Adoption_Stage__c && trig.newList[i].Adoption_Stage__c != null) {
                        boolean match = false;
                        String adoptionStage=null;
                        String val = trig.newList[i].Adoption_Stage__c;
                        System.debug('######DEBUG: val:' + val);
                        
                        if (val == 'Completed - Adopted')
                            adoptionStage= 'Completed - Adopted, ' + closedVal;
                        else if (val == 'Completed - Order Confirmed')
                            adoptionStage= 'Completed - Order Confirmed, ' + closedVal;
                        else if (val == 'Completed - Purchased')
                            adoptionStage= 'Completed - Purchased, ' + closedVal;
                        else if (val == 'Completed - Not appropriate')
                            adoptionStage= 'Completed - Not appropriate, ' + closedVal;
                        else if (val == 'Completed - Library Purchase')
                            adoptionStage= 'Completed - Library Purchase, ' + closedVal;
                        else if (val == 'Completed - No Response')
                            adoptionStage= 'Completed - No Response, ' + closedVal;
                
                        System.debug('######DEBUG: adoptionStage:' + adoptionStage);
                        mapAdoptStage.put(trig.newList[i].Id,adoptionStage);
                    }
                }
                
                System.debug('######DEBUG: mapAdoptStage.Size():' + mapAdoptStage.Size());
                if (mapAdoptStage.Size() > 0) {
                System.debug('######DEBUG: mapAdoptStage.get(mapAdoptStage.KeySet):' + mapAdoptStage.KeySet());
                    for (CAS_Inspection_Copy__c textBook : [Select c.Id, c.Adoption_Stage__c ,c.Opportunity__c, c.Opportunity_Product__c from CAS_Inspection_Copy__c c  Where c.Opportunity_Product__c  IN :mapAdoptStage.KeySet()]) {
                        System.debug('######DEBUG: mapAdoptStage.get(textBook.Opportunity_Product__c):' + mapAdoptStage.get(textBook.Opportunity_Product__c));
                        if (textBook.Adoption_Stage__c != mapAdoptStage.get(textBook.Opportunity_Product__c)) {
                            CAS_Inspection_Copy__c adoptStage = new CAS_Inspection_Copy__c (Id = textBook.Id, Adoption_Stage__c = mapAdoptStage.get(textBook.Opportunity_Product__c));
                            updateAdoptStages.add(adoptStage);
                        }
                    }
                }

                System.debug('######DEBUG: updateAdoptStages.Size():' + updateAdoptStages.Size());
                if (updateAdoptStages.Size() > 0)
                    Update updateAdoptStages;
            }
        }
    }
}