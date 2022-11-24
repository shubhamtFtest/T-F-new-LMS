/*Created By: Piyush Jain
 *Description: Used in FSD discounting flow as part of FSD Project
 *Test Class: ztest_ProductDiscountService
**/
@RestResource(urlMapping='/discount/*')
global without sharing class ProductDiscountService {
    
    global class Response {
        public Decimal discount;
        public List<Decimal> discountPercentList;
        public List<Decimal> discountAmountList;
        public List<Sales_Deal__c> appliedSalesDealList;
    }
    
    @HttpPost
    global static void doPost() {
        DiscountRequest discountReq = new DiscountRequest();
        List<DiscountRequest> discountReqList = new List<DiscountRequest>();
        //List<Decimal> discountReceivedList = new List<Decimal>();
        String jsonStr = RestContext.request.requestBody != null ? RestContext.request.requestBody.toString(): null;
        System.debug(jsonStr);
        discountReqList = (List<DiscountRequest>)JSON.deserialize(jsonStr, List<DiscountRequest>.class);
        
        DiscountInterface discountServ = new V1DiscountService();
        Response response = new Response();
        response.discountPercentList = new List<Decimal>();
        response.discountAmountList = new List<Decimal>();
        response.appliedSalesDealList = new List<Sales_Deal__c>();
        discountReqList = discountServ.getBestDiscountBulk(discountReqList);
        if (!discountReqList.isEmpty()) {
            for ( DiscountRequest reqq : discountReqList ) {
                system.debug('reqq.appliedSalesDeal=='+reqq.appliedSalesDeal);
                if(reqq.appliedSalesDeal != null)
                    response.appliedSalesDealList.add(reqq.appliedSalesDeal);
                if(reqq.discountReceived!= null)
                    response.discountPercentList.add(reqq.discountReceived);
                else if(reqq.discountAmountReceived != null)
                    response.discountAmountList.add(reqq.discountAmountReceived);
                
                SBQQ__QuoteLine__c quoteLineUpdateRecord = new SBQQ__QuoteLine__c();
                
            }
            
        }
        
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(response));
    }
    
}