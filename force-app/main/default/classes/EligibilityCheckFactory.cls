/*Created By: Piyush Jain
 *Description: Used in FSD discounting flow as part of FSD Project
 *Test Class: ztest_ProductDiscountService
**/
public class EligibilityCheckFactory {
    private Sales_Deal__c salesDeal;
    private DiscountRequest request;
    
    public EligibilityCheckFactory(Sales_Deal__c sd, DiscountRequest req) {
    	salesDeal = sd;
        request = req;
    }
    
    public AccountEligibilityCheck getAccountEligibilityCheck() {
    
        if(salesDeal.RecordTypeId == Schema.SObjectType.Sales_Deal__c.getRecordTypeInfosByName().get('Consortium Deal').getRecordTypeId()) {
            return new ConsortiumEligibilityCheck(); 
        } else if (salesDeal.RecordTypeId == Schema.SObjectType.Sales_Deal__c.getRecordTypeInfosByName().get('Institution Deal').getRecordTypeId()) {
            return new InstitutionEligibiligyCheck(); 
        } else if ((salesDeal.RecordTypeId == Schema.SObjectType.Sales_Deal__c.getRecordTypeInfosByName().get('Country Deal').getRecordTypeId())) {
            return new CountryBasedInstitutionEligibiligyCheck();
        } else if((salesDeal.RecordTypeId == Schema.SObjectType.Sales_Deal__c.getRecordTypeInfosByName().get('Promocode Deal').getRecordTypeId())) {
            System.debug('Here in Promocode');
            return new PromoCodeInstitutionEligibiligyCheck();
        }
        return null;
    }
    
    public ProductEligibilityCheck getProductEligibilityCheck() {
        
        System.debug('@In getProductEligibilityCheck');
        Id promocodeRecordTypeId = Schema.SObjectType.Sales_Deal__c.getRecordTypeInfosByName().get('Promocode Deal').getRecordTypeId();
        System.debug('@promocodeRecordTypeId '+promocodeRecordTypeId);
        System.debug('@salesDeal.RecordTypeId '+salesDeal.RecordTypeId);
        
        if (salesDeal.RecordTypeId == promocodeRecordTypeId ) {
            return new JournalProductEligibilityCheckForPromo();
        } else if (salesDeal.Type_of_Deal__c.equalsIgnoreCase('APC Deal')) {
            return new JournalProductEligibilityCheckForAPC();
        } 
        return null;
    }
}