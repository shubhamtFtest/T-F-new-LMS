public class CustomScriptOnQuote implements TriggerInterface_SBQQ_Quote.Runnable{
    private static boolean run1 = true;
    public static boolean runOnce1(){
        System.debug('@runonce@'+ run1);
        if(run1){
            run1=false;
            return true;
        }
        else{
            return run1;
        } 
    }
     
    public void run(TriggerInterface_SBQQ_Quote.Trig trig){
        System.debug('Discount Trigger Called!');
        Set<String> quoteIdSet = new Set <String>();
        //map<id,Decimal> manuelDiscountQuoteIdmap = new map <id,Decimal>();
        //Boolean isEligibleQuoteCalculationRetry = true;//Added by Shalini as part of re-work
        
        Id quoteRecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('T&F - CPQ Quote').getRecordTypeId();
        Id quoteRecordTypeReadId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('T&F - Read Only Quote').getRecordTypeId();
        Set<String> RecordtypequoteIdSet = new Set <String>();
        RecordtypequoteIdSet.add(quoteRecordTypeReadId);
        RecordtypequoteIdSet.add(quoteRecordTypeId);
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        DateTime calculateSdOldQuotesDate = (DateTime) orgSpecificProps.get('Calculate_SD_Date__c');
        system.debug('@calculateSdOldQuotesDate '+calculateSdOldQuotesDate);
                
        if(runOnce1()){
            if(trig.isAfter && trig.isUpdate){
                for (SBQQ__Quote__c q : trig.newList){
                     system.debug('@quoteIdfsd-->'+q.Id);
                    Date LastModifiedDate;      
                    if(trig.oldMap !=null && trig.oldMap.size()>0 && trig.oldMap.get(q.Id).LastModifiedDate !=null)
                    LastModifiedDate = Date.newInstance(trig.oldMap.get(q.Id).LastModifiedDate.year(),trig.oldMap.get(q.Id).LastModifiedDate.month(), trig.oldMap.get(q.Id).LastModifiedDate.day());
                    system.debug('@LastModifiedDate '+LastModifiedDate);
                    system.debug('@IsInsert Check '+trig.isInsert);
                    system.debug('@q.Entry_Point__c '+q.Entry_Point__c);
                    system.debug('@q.Author_Status__c '+q.Author_Status__c);
                    
                    if((RecordtypequoteIdSet.contains(q.RecordTypeId) || userinfo.getUserId()=='0050Y000002quITQAY') && !system.isFuture() && 
                       (String.isBlank(q.Author_Status__c) || 
                        q.Entry_Point__c == 'OAD' ||
                        (calculateSdOldQuotesDate !=null && LastModifiedDate !=null && LastModifiedDate <= calculateSdOldQuotesDate) ||
                        q.Calculate_SD__c))
                    {
                        quoteIdSet.add(q.Id);
                    }
                }
                system.debug('@quoteIdSet1-->'+quoteIdSet);
                
                if(!quoteIdSet.isEmpty()){
                    try{
                        sendInfoToDiscountService(quoteIdSet, trig.oldMap);
                        for (SBQQ__Quote__c q : trig.newList){
                            if((!system.isFuture() && q.isFutureHandler__c == false && quoteRecordTypeId == q.RecordTypeId && q.SBQQ__LineItemCount__c > 0 ) && q.Partner_Discount_Percent__c==null){ //&& isEligibleQuoteCalculationRetry
                                   system.debug('@Before quoteCalculationRetry !!');
                                   quoteCalculationRetry(q.Id);
                               } 
                        } 
                    }catch(Exception ex){
                        system.debug('******** Exception in CustomScriptOnQuote Trigger : ' +  String.valueOf(' Exception Type :-'+ex.getTypeName()+' ** Message:-'+ex.getMessage()+' ** Line Number:-'+ex.getLineNumber()+' ** Stack Trace :- '+ ex.getStackTraceString()));
                        //isEligibleQuoteCalculationRetry = false;//Added by Shalini as part of re-work to stop stucking in infinite loop
                    }
                }
                 
                /*for (SBQQ__Quote__c q : trig.newList){
                    if((!system.isFuture() && q.isFutureHandler__c == false && quoteRecordTypeId == q.RecordTypeId && q.SBQQ__LineItemCount__c > 0 ) && q.Partner_Discount_Percent__c==null
                       && isEligibleQuoteCalculationRetry){
                           system.debug('@Before quoteCalculationRetry !!');
                           quoteCalculationRetry(q.Id);
                       } 
                }*/    
            }
            
        }
    }
    
    public static void sendInfoToDiscountService(Set<String> quoteIdSet, Map<Id,SBQQ__Quote__c> oldMap) {
        system.debug('sendInfoToDiscountService !!');
        List<String> requestBodyList = new List<String>();
        List<DiscountRequest> discountReqList = new List<DiscountRequest>();
        //FSD_DiscountService discountServ = new FSD_DiscountService();
        V1DiscountService discountServ = new V1DiscountService();

        List<DiscountRequest> discountList = new List<DiscountRequest>();
        List<SBQQ__Quote__c> quoteUpdateList = new List<SBQQ__Quote__c>();
        List<SBQQ__QuoteLine__c> quoteLineUpdateList = new List<SBQQ__QuoteLine__c>();
        Map<String, SBQQ__QuoteLine__c> quoteIdToQuoteMap = new Map<String, SBQQ__QuoteLine__c>();
        
        for(SBQQ__QuoteLine__c quoteLine: [SELECT Id,SBQQ__Quote__r.Country_Code__c,SBQQ__Product__r.Is_Service_Discount__c,Parent_Product_Code__c,SBQQ__Quote__r.Country_Applicable_List__c,SBQQ__Quote__r.currencyIsocode,SBQQ__Quote__r.isFutureHandler__c,SBQQ__Quote__c,SBQQ__Quote__r.Use_Prepay_Budget__c,SBQQ__ListPrice__c,SBQQ__Quote__r.EIFL_Type__c,SBQQ__Quote__r.SBQQ__BillingCountry__c,SBQQ__Quote__r.Today_Date__c,SBQQ__Quote__r.Apply_Country_Discount__c,SBQQ__Quote__r.Payer_Party_ID__c,SBQQ__Quote__r.PromoCode__c,Product_Open_Access_Category__c,SBQQ__Discount__c,Product_UUID__c,SBQQ__ProductCode__c,Parent_Product_UUID__c, SBQQ__ProductFamily__c, Is_Service_Discount__c,SBQQ__Quote__r.Payer_Organization_RinGold_ID__c,SBQQ__Quote__r.Partner_Discount_Percent__c   FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c IN :quoteIdSet]){
            quoteIdToQuoteMap.put(quoteLine.id, quoteLine);
            system.debug('quoteLine-->'+quoteLine.Parent_Product_Code__c);
            DateTime todayDate = quoteLine.SBQQ__Quote__r.Today_Date__c;
            Date myDate = todayDate.date();
            String mDate = String.valueOf(myDate);
            Date nDate = Date.valueOf(mDate);
            String body = '{\n' +
                '  "customerID" : "'+quoteLine.SBQQ__Quote__r.Payer_Party_ID__c+'",\n' +
                '  "billingCountry" : "'+quoteLine.SBQQ__Quote__r.SBQQ__BillingCountry__c+'",\n' +
                '  "BillingCountryCode" : "'+quoteLine.SBQQ__Quote__r.Country_Code__c+'",\n' +
                '  "promoCode" : "'+quoteLine.SBQQ__Quote__r.PromoCode__c+'",\n' +
                '  "productID" : "'+quoteLine.Product_UUID__c+'",\n' +
                '  "productCode" : "'+quoteLine.SBQQ__ProductCode__c+'",\n' +
                '  "parentProduct" : "'+quoteLine.Parent_Product_UUID__c+'",\n' + 
                //'  "parentProductCode" : "'+quoteLine.Parent_Product_Code__c +'",\n' +
                '  "applycountryDiscount" : '+quoteLine.SBQQ__Quote__r.Apply_Country_Discount__c+',\n'  +  
                '  "applyPrePayDiscount" : '+quoteLine.SBQQ__Quote__r.Use_Prepay_Budget__c+',\n'  +   
                
                '  "CurrencyIsoCode" : "'+quoteLine.SBQQ__Quote__r.currencyIsocode+'",\n' +     
                '  "startDate" : "'+myDate+'",\n' +     
                '  "endDate" : "'+myDate+'",\n' +   
                '  "EIFLType" : "'+quoteLine.SBQQ__Quote__r.EIFL_Type__c+'",\n' +
                //'  "openAccessCategory" : "'+quoteLine.Product_Open_Access_Category__c+'",\n' +//Removed by Shalini as we are considering its parent product OAC, as part of SFSD- 1202 
                '  "quoteLineId" : "'+quoteLine.id+'",\n' +
                '  "quoteLineListPrice" : '+quoteLine.SBQQ__ListPrice__c+',\n' +
                '  "quoteId" : "'+quoteLine.SBQQ__Quote__c+'",\n' +
                '  "ringoldId" : "'+quoteLine.SBQQ__Quote__r.Payer_Organization_RinGold_ID__c+'",\n' + //Added by Shalini as part of ticket no - SFSD-1202
                '  "partnerDiscount" : '+quoteLine.SBQQ__Quote__r.Partner_Discount_Percent__c+',\n' + //Added by Shalini as part of partner discount logic
                '  "isEligibleForDiscount" : '+quoteLine.SBQQ__Product__r.Is_Service_Discount__c+'\n' + //Updated by Shalini as part of ticket no - SFSD-1202
                //'  "isEligibleForDiscount" : "'+quoteLine.SBQQ__Product__r.Is_Service_Discount__c+'"\n' + //Added by Faiz as part of ticket no - https://taylorfrancis.atlassian.net/browse/SFSD-1205
                '}';
            requestBodyList.add(body);
        
        }
        System.debug('Request list size********'+requestBodyList.size());
        System.debug(requestBodyList);
        if(!requestBodyList.isempty()){ 
            for(String record : requestBodyList){
                system.debug('@record'+ record);
                DiscountRequest discountReq = (DiscountRequest)System.JSON.deserialize(record, DiscountRequest.class);
                discountReqList.add(discountReq);
            }
        } 
      
        try{
            if(!discountReqList.isEmpty())
                discountList = discountServ.getBestDiscountBulk(discountReqList);
            
            System.debug('response---'+discountList);
            
            if (!discountList.isEmpty()) {
                for ( DiscountRequest reqq : discountList ) {
                  //  system.debug('reqq.appliedSalesDeal.Id-->'+reqq.appliedSalesDeal.Id);
                    SBQQ__Quote__c quoteUpdateRecord = new SBQQ__Quote__c();
                    quoteUpdateRecord.isFutureHandler__c = true;
                    quoteUpdateRecord.Id = reqq.quoteId;
                    //if(reqq.appliedSalesDeal != null)
                        //quoteUpdateRecord.Sales_Deal__c = reqq.appliedSalesDeal.Id;//Shalini-Added this condition below, as if the product is not eligible for discount then we don't wanna assign the SD as well
                    
                    SBQQ__QuoteLine__c quoteLineUpdateRecord = new SBQQ__QuoteLine__c();
                    //quoteLineUpdateRecord.SBQQ__Discount__c = reqq.discountReceived;
                    quoteLineUpdateRecord.Id = reqq.quoteLineId;
                    
                    /*if ( !quoteIdToQuoteMap.get(reqq.quoteLineId).Is_Service_Discount__c && quoteIdToQuoteMap.get(reqq.quoteLineId).SBQQ__ProductFamily__c.containsIgnoreCase('journal') ) {
                        quoteLineUpdateRecord.SBQQ__Discount__c = 0;
                    }*/
                    
                    
                    //Adding to Support data migration
                    Date LastModifiedDate;      
                    if(oldMap !=null && oldMap.size()>0 && oldMap.get(reqq.quoteId).LastModifiedDate !=null)
                    LastModifiedDate = Date.newInstance(oldMap.get(reqq.quoteId).LastModifiedDate.year(),oldMap.get(reqq.quoteId).LastModifiedDate.month(), oldMap.get(reqq.quoteId).LastModifiedDate.day());
                    system.debug('@LastModifiedDate '+LastModifiedDate);
                    
                    TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
                    DateTime calculateSdOldQuotesDate = (DateTime) orgSpecificProps.get('Calculate_SD_Date__c');
                    system.debug('@calculateSdOldQuotesDate '+calculateSdOldQuotesDate);
                    
                    if(calculateSdOldQuotesDate !=null && LastModifiedDate !=null && LastModifiedDate <= calculateSdOldQuotesDate)
                    {
                        system.debug('@Data Migration');
                        system.debug('@Data Migration2'+oldMap.get(reqq.quoteId).Total_Discount_Percent__c);
                        system.debug('@Data Migration3'+reqq.discountReceived);
                        system.debug('@Data Migration4 '+reqq.appliedSalesDeal);
                        if(oldMap.get(reqq.quoteId).Total_Discount_Percent__c != null && reqq.discountReceived != null &&
                           oldMap.get(reqq.quoteId).Total_Discount_Percent__c == reqq.discountReceived && reqq.appliedSalesDeal != null)
                        {
                            system.debug('@Data Migration- Discount Match');
                            quoteLineUpdateRecord.Sales_Deal__c = reqq.appliedSalesDeal.Id;
                            quoteUpdateRecord.Sales_Deal__c = reqq.appliedSalesDeal.Id;
                        }
                    }
                    else 
                    {
                        if ( !quoteIdToQuoteMap.get(reqq.quoteLineId).Is_Service_Discount__c || String.isBlank(quoteIdToQuoteMap.get(reqq.quoteLineId).SBQQ__ProductFamily__c)
                            || !quoteIdToQuoteMap.get(reqq.quoteLineId).SBQQ__ProductFamily__c.containsIgnoreCase('Journal Service Product') ) {
                                //quoteLineUpdateRecord.SBQQ__Discount__c = 0;
                                quoteLineUpdateRecord.SBQQ__AdditionalDiscountAmount__c=null;
                                quoteLineUpdateRecord.SBQQ__Discount__c=null;
                            }
                        else { 
                            
                            if(reqq.appliedSalesDeal != null){
                                quoteLineUpdateRecord.Sales_Deal__c = reqq.appliedSalesDeal.Id;
                                quoteUpdateRecord.Sales_Deal__c = reqq.appliedSalesDeal.Id;
                            }
                            else{
                                /*updated as part of SFSD-590 - Syam.N 
To remove the discount on Quoteline which got already applied, firstly salesdeal will be removed.
If there is no salesdeal then in that case we are making discount fields 
--> SBQQ__AdditionalDiscountAmount__c,SBQQ__Discount__c as null in order to remove the complete discount on ql.
*/
                                quoteLineUpdateRecord.SBQQ__AdditionalDiscountAmount__c=null;
                                quoteLineUpdateRecord.SBQQ__Discount__c=null;
                                quoteLineUpdateRecord.Sales_Deal__c = null;
                                quoteUpdateRecord.Sales_Deal__c = null;
                            }
                            /*if(reqq.appliedSalesDeal.Id == null){
/*updated as part of SFSD-590 - Syam.N 
To remove the discount on Quoteline which got already applied, firstly salesdeal will be removed.
If there is no salesdeal then in that case we are making discount fields 
--> SBQQ__AdditionalDiscountAmount__c,SBQQ__Discount__c as null in order to remove the complete discount on ql.

quoteLineUpdateRecord.SBQQ__AdditionalDiscountAmount__c=null;
quoteLineUpdateRecord.SBQQ__Discount__c=null;//We should set SD to null as well 
}*/                            
                            if(reqq.discountReceived != null)
                            {
                                quoteLineUpdateRecord.SBQQ__AdditionalDiscountAmount__c=null;
                                quoteLineUpdateRecord.SBQQ__Discount__c = reqq.discountReceived;
                            }
                            else if(reqq.discountAmountReceived != null ){
                                quoteLineUpdateRecord.SBQQ__Discount__c=null;
                                quoteLineUpdateRecord.SBQQ__AdditionalDiscountAmount__c = reqq.discountAmountReceived;
                            }
                            
                            
                            //Shalini- Start partner discount logic 
                            if(reqq.partnerDiscount != null && reqq.discountReceived != null)
                            {
                                if(reqq.partnerDiscount >= reqq.discountReceived)
                                {
                                    quoteLineUpdateRecord.SBQQ__Discount__c = reqq.partnerDiscount;
                                    quoteLineUpdateRecord.Sales_Deal__c = null;   
                                    quoteUpdateRecord.Sales_Deal__c = null;
                                }
                                else
                                {
                                    //quoteLineUpdateRecord.SBQQ__Discount__c = reqq.discountReceived;
                                    quoteUpdateRecord.Partner_Discount_Percent__c = 0;
                                }
                            }
                            else if(reqq.partnerDiscount != null && (reqq.discountReceived == null || reqq.discountAmountReceived != null))//added reqq.discountAmountReceived condition here so if any SD get applicable of type fixed/amount then give preference to partner discount
                            {
                                quoteLineUpdateRecord.SBQQ__Discount__c = reqq.partnerDiscount;
                                quoteLineUpdateRecord.Sales_Deal__c = null;
                                quoteLineUpdateRecord.SBQQ__AdditionalDiscountAmount__c = null;
                                quoteUpdateRecord.Sales_Deal__c = null;
                            }
                            //Shalini- End partner discount logic
                            
                            
                        }
                    }
                    
                    
                    
                    
                    system.debug('quoteLineUpdateRecord='+quoteLineUpdateRecord);
                    quoteLineUpdateList.add(quoteLineUpdateRecord);
                  //  if(oldMap.size()>0 && oldMap.get(reqq.quoteId).Approved_Rejected_Date__c !=null)
               //     quoteUpdateRecord.Approved_Rejected_Date__c=oldMap.get(reqq.quoteId).Approved_Rejected_Date__c;
                    quoteUpdateList.add(quoteUpdateRecord);
                    
                }
            } 
            
            if(quoteLineUpdateList.size()>0){
                update quoteLineUpdateList;
                system.debug('quoteLineUpdateList-->'+quoteLineUpdateList);
                
            } 
            if(quoteUpdateList.size()>0){
                //To remove duplicacy of Quote Record
                Set<SBQQ__Quote__c> quoteSet = new Set<SBQQ__Quote__c>();
                quoteSet.addAll(quoteUpdateList);
                quoteUpdateList.clear();
                quoteUpdateList.addAll(quoteSet);
                update quoteUpdateList;
            }
            
        }
        catch(System.CalloutException e){
            System.debug('Error-' + e.getMessage());  
        }
    }
    
  @Future(callout=true)
    public static void quoteCalculationRetry(String quoteId){
        QuoteReader reader = new QuoteReader();
        QuoteModel quoteM = reader.read(quoteId); //Pass here quote id
        QuoteCalculator calculator = new QuoteCalculator();
        calculator.calculate(quoteM, 'QuoteCalculateCallback');
        
    }
    
    public class Response {
        public Decimal discount;
    }
}