//Tested by zTEST_LeadCopyOtherAddressUponConvert.cls		100%
//
//Created by Jeff Lup - 2015.11.24 - moved existing Trigger into this Class

public with sharing class LeadCopyOtherAddressUponConvert_Trig implements TriggerInterface_Lead.Runnable {
    public void run(TriggerInterface_Lead.Trig trig) {
        if (trig.isAfter && trig.isUpdate) {
            if (trig.triggerSize == 1) {
                if (trig.oldList[0].ConvertedContactId == null && trig.newList[0].ConvertedContactId != null) {
                    if (trig.newList[0].Other_Street__c != null || trig.newList[0].Other_City__c != null) { //Case#33771: Make sure the Lead has an Other address
                        Contact c = [SELECT Id FROM Contact WHERE Id = :trig.newList[0].ConvertedContactId];
                        c.Other_Address_Type__c = 'Other';
                        c.OtherStreet = trig.newList[0].Other_Street__c;
                        c.OtherCity = trig.newList[0].Other_City__c;
                        c.OtherState = trig.newList[0].Other_State_Province__c;
                        c.Other_State_List__c = trig.newList[0].Other_State_Province__c;
                        c.OtherCountry = trig.newList[0].Other_Country__c;
                        c.Other_Country_List__c = trig.newList[0].Other_Country__c;
                        c.OtherPostalCode = trig.newList[0].Other_Postal_Code__c;
                        update c;
                    }
                }
            }
        }
    }
}