/*Created By: Piyush Jain
 *Description: Used in FSD discounting flow as part of FSD Project
 *Test Class: ztest_ProductDiscountService
**/
public class DiscountCalculatorEngine {
    
    public DiscountCalculator discountCalc;
    public List<DiscountCalculator> discountCalculators = new List<DiscountCalculator>();
    Set<Id> recordTypeIdSet = new Set<Id>();
    
    public DiscountCalculatorEngine() {
        Schema.DescribeSObjectResult record = Sales_Deal__c.SObjectType.getDescribe();
		List<Schema.RecordTypeInfo> recordTypes = record.getRecordTypeInfos();
   		System.debug('DiscountCalculatorEngine Constructor');
        for(Schema.RecordTypeInfo recordType : recordTypes) {
            recordTypeIdSet.add(recordType.getRecordTypeId());
        }
   		SalesDealDiscountCalculator calculator = new SalesDealDiscountCalculator(recordTypeIdSet);
        discountCalc = calculator;
    }
    
     public List<DiscountRequest> getDiscountBulk(List<DiscountRequest> requestList) {
        requestList = discountCalc.getDiscountBulk(requestList);
        return requestList;
    }
    
    /* BULKIFICATION CHANGES END */

}