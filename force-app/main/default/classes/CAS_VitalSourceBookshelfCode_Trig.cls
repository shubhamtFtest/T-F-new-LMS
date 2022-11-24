/*
** Tested by: Tests_CASVitalSource.cls
**
** Modified by Shay Spoonmore - 2014-11-04
** Modified by Jeff Lup - 2015.02.26 - Moved trigger into this class
** Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2015-05-28 CHG0065975
** Modified by Hailey Niemand - 2015.08.24 - CHG0068281
** Modified by Matthew Smith - 2020.04.11 - Updating line 16, so the code runs for any order type where the text contains "Vitalsource e-Exam copy" - 01672236
*/
public without sharing class CAS_VitalSourceBookshelfCode_Trig implements TriggerInterface_OLI.Runnable {
    public void run(TriggerInterface_OLI.Trig trig) {
        if (trig.isAfter && (trig.isInsert || trig.isUpdate)) {
            //Get Bookshelf codes: Process is for a single user because of callout limitations. Back ground service checks throughout the day looking for products that become available and creates the codes.
            if (!System.isFuture() && !System.isBatch() && Trigger.new.size()==1) {
                if(trig.newList[0].Adoption_Stage__c == 'Created' && trig.newList[0].VitalSource_Bookshelf_Code__c == null && trig.newList[0].VitalSource_Bookshelf_Date__c==null 
                    && (trig.newList[0].Order_Type__c != null && trig.newList[0].Order_Type__c.contains('Vitalsource e-Exam copy'))) //&& trig.newList[0].Order_Type__c !='Vitalsource e-Exam copy')// TEMP - Order_Type__c !='Vitalsource e-Exam copy' because some records have this old value that should be updated with correct order type //CHG0068281  Exclude null Order_Type__c
                    //&& (trig.newList[0].Order_Type__c=='Vitalsource e-Exam copy' || trig.newList[0].Order_Type__c=='CRC Vitalsource e-Exam copy' || trig.newList[0].Order_Type__c=='HSS Vitalsource e-Exam copy')) 
                {
                    Map<ID,Opportunity> opp = new Map<ID,Opportunity>([Select Id,StageName, IsWon, IsClosed From Opportunity o Where Id =:trig.newList[0].OpportunityId]);
                    if (opp != null) { //Changed CHG0062258 && opp.get(Trigger.new[0].OpportunityId).IsClosed == false
                        //Map<ID,Product2> product = new Map<ID,Product2>([Select p.VitalSource_Status__c, p.VitalSource_SKU__c, p.US_Publication_Date__c, p.UK_Publication_Date__c, p.Imprint__c, p.Id, p.Group_Company__c, p.Company__c From Product2 p Where Id =:trig.newList[0].Product2Id]);
                        Map<ID,Product2> product = new Map<ID,Product2>([Select p.VitalSource_Status__c, p.VitalSource_SKU__c, p.US_Publication_Date__c, p.UK_Publication_Date__c, p.Imprint__c, p.Id, p.Group_Company__c From Product2 p Where Id =:trig.newList[0].Product2Id]);
                        if (product != null && (product.get(trig.newList[0].Product2Id).VitalSource_Status__c == 'Live' || product.get(trig.newList[0].Product2Id).VitalSource_Status__c == 'In Inventory')) {
                            String accessCode = '30';
                            if (trig.newList[0].VitalSource_Access_Period__c != null)
                                accessCode = trig.newList[0].VitalSource_Access_Period__c;
                            //need to find out how to tell diff componies
                            CAS_VitalSource.GetBookshelfCode(trig.newList[0].Id, product.get(trig.newList[0].Product2Id).VitalSource_SKU__c,accessCode,'Routledge');
                        }                       
                    }
                }
            }
        }
    }
}