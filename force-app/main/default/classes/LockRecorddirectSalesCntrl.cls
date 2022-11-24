/**
Author : shashank
Test class :  zTest_LockRecDS
Description : This class is being used to create order on order HUb side . order will only get inserted 1 at a time so NO BULKIFICATION is done. The order once created will not get update. 
**/
public class LockRecorddirectSalesCntrl {
    @AuraEnabled
    public static boolean showMessg( String recordId , String sObjectName ){
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F Automated eBooks Opportunity').getRecordTypeId();

        System.debug('showMsg');
        if ( sObjectName == 'opportunity') {
            opportunity opp = [SELECT id,stagename,recordTypeId FROM Opportunity WHERE id=:recordId limit 1 ];
            List<SBQQ__Quote__c> listQuote = new List<SBQQ__Quote__c>([ SELECT Name,id,SBQQ__Status__c,SBQQ__Primary__c FROM SBQQ__Quote__c WHERE  SBQQ__Opportunity2__c =:recordId  LIMIT 1 ]);
           
            if (  opp.recordTypeId == oppRecordTypeId  && opp.stagename == 'Closed Won'  ) {
                System.debug('showMsg');
                   return true;
            }
        } 
        /*
        else if(sObjectName == 'Order') {
            Order ord = [ SELECT id,opportunityid,opportunity.stagename,opportunity.recordTypeid FROM order where id=:recordId limit 1 ];

            List<SBQQ__Quote__c> listQuote = new List<SBQQ__Quote__c>([ SELECT Name,id,SBQQ__Status__c,SBQQ__Primary__c FROM SBQQ__Quote__c WHERE  SBQQ__Opportunity2__c =:ord.opportunityid  LIMIT 1 ]);

            if ( ord.opportunity.recordTypeid == oppRecordTypeId && (ord.opportunity.stagename == 'Closed Won' || (!listQuote.isEmpty() && listQuote.get(0).SBQQ__Status__c =='Accepted' )) ) {
                System.debug('showMsg');
                return true;
            }
            
        } else if( sObjectName == 'SBQQ__Quote__c' ){
            List<SBQQ__Quote__c> listQuote = new List<SBQQ__Quote__c>([ SELECT Name,id,SBQQ__Status__c,SBQQ__Primary__c,SBQQ__Opportunity2__c,SBQQ__Opportunity2__r.stagename,SBQQ__Opportunity2__r.recordTypeId  FROM SBQQ__Quote__c WHERE  id=:recordId  LIMIT 1 ]);

            if (!listQuote.isEmpty() && listQuote.get(0).SBQQ__Opportunity2__r.recordTypeId == oppRecordTypeId  &&  (listQuote.get(0).SBQQ__Opportunity2__r.stagename == 'Closed Won' ||  listQuote.get(0).SBQQ__Status__c =='Accepted') )  {
                System.debug('showMsg');
                return true;
            }
        }
        */

        return null;
    }
}