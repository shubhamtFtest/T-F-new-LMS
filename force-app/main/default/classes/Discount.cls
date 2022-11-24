/*Created By: Piyush Jain
 *Description: Used in FSD discounting flow as part of FSD Project
 *Test Class: ztest_ProductDiscountService
**/
public class Discount {
    public String discountName;
	public String typeOfDiscount; 
    public Decimal percentageValue;
    public Decimal listPrice;
    public Sales_Deal__c appliedSalesDeal;
    public List<DiscountPrice> discountPrice = new List<DiscountPrice>();
    public String countryCurrency;
    
    public class BestDiscount{
        public Decimal discountPercentge;
        public Decimal discountAmount;
        public Sales_Deal__c salesDeal;
        public Decimal discountAmountTemp;
    }
   
   
    public static BestDiscount getBestPercentageOfDiscount(List<Discount> discounts) {
        system.debug('@getBestPercentageOfDiscount!!');
        //Decimal discountPercentge = 0;
        BestDiscount bestDiscount = new BestDiscount();
        bestDiscount.discountPercentge = 0;
        bestDiscount.salesDeal = new Sales_Deal__c();
        System.debug('List of discounts '+discounts);
        for(Discount discount : discounts) {   
            if(discount != null && discount.typeOfDiscount != null)
            if(discount.typeOfDiscount.equals('% Discount')) {
                
                system.debug('@@bestDiscount.discountPercentge '+bestDiscount.discountPercentge);
                system.debug('@@discount.percentageValue '+discount.percentageValue);
                
                if(bestDiscount.discountPercentge < discount.percentageValue) {
                    bestDiscount.discountPercentge = discount.percentageValue;
                    System.debug('@@applied sales'+discount.appliedSalesDeal);
                    
                    bestDiscount.salesDeal = discount.appliedSalesDeal;
                    
                    System.debug('In @@@ best percenatge'+bestDiscount);
                }
            }
        }
        return bestDiscount;
    }
    
    public static BestDiscount getBestFixedAmountOfDiscount(List<Discount> discounts) {
        system.debug('@getBestFixedAmountOfDiscount!!');
        //Decimal discountAmount = 0;
        BestDiscount bestDiscount = new BestDiscount();
        bestDiscount.discountAmount = 0;//bestDiscount.discountAmount = null;//
        bestDiscount.discountAmountTemp = 0;//Storing a temporary value for fixed amount discount calculation 
        bestDiscount.salesDeal = new Sales_Deal__c();
        System.debug('List of discounts '+discounts);
        
        for(Discount discount : discounts) { 
            if(discount != null && discount.typeOfDiscount != null && discount.typeOfDiscount == 'Fixed Amount Discount') {
                system.debug('@Fixed Amount Discount!!');
                for(DiscountPrice discPrice : discount.discountPrice){
                    system.debug('@2 currency '+discPrice.discountCurrency+' '+discount.countryCurrency);
                    system.debug('@discount.listPrice '+discount.listPrice);
                    system.debug('@discPrice.discountValue '+discPrice.discountValue);//Deal discount value of SD
                    if(discPrice.discountCurrency.equalsIgnoreCase(discount.countryCurrency))
                    {
                        system.debug('Fixed currency check pass!!');
						if((bestDiscount.discountAmountTemp == 0 || bestDiscount.discountAmountTemp > discPrice.discountValue) && discPrice.discountValue > discount.listPrice && discount.appliedSalesDeal.Apply_list_price_if_lower_than_discount__c){//Need to enhance country logic further for exclude countries //Shalini: modified if condition to fix SFSD- 1861
                            system.debug('checked');
                            system.debug('discountAmountTemp '+bestDiscount.discountAmountTemp);
                            bestDiscount.discountAmount = 0;
                            bestDiscount.salesDeal = discount.appliedSalesDeal;
							bestDiscount.discountAmountTemp = discPrice.discountValue;//Shalini: Added this line to fix SFSD- 1861
                        }
                        else if(bestDiscount.discountAmountTemp == 0 || bestDiscount.discountAmountTemp > discPrice.discountValue){
                            system.debug('Unchecked');
                            bestDiscount.salesDeal = discount.appliedSalesDeal;
                            bestDiscount.discountAmountTemp = discPrice.discountValue;
                            bestDiscount.discountAmount = discount.listPrice - discPrice.discountValue;
                        }
                    }
                }
            }
        }
        system.debug('bestDiscount '+bestDiscount);
        return bestDiscount;
    }
    
    public static BestDiscount getBestAmountOfDiscount(List<Discount> discounts) {
        system.debug('@getBestAmountOfDiscount!!');
        //Decimal discountAmount = 0;
        BestDiscount bestDiscount = new BestDiscount();
        bestDiscount.discountAmount = 0;//bestDiscount.discountAmount = null;//
        bestDiscount.salesDeal = new Sales_Deal__c();
        System.debug('List of discounts '+discounts);
        for(Discount discount : discounts) { 
            if(discount != null && discount.typeOfDiscount != null && discount.typeOfDiscount == 'Amount Discount') {
                system.debug('@Amount Discount!!');
                for(DiscountPrice discPrice : discount.discountPrice){
                    system.debug('@2 currency '+discPrice.discountCurrency+' '+discount.countryCurrency);
                    system.debug('@discount.listPrice '+discount.listPrice);
                    system.debug('@discPrice.discountValue '+discPrice.discountValue);//Deal discount value of SD
                    if(discPrice.discountCurrency.equalsIgnoreCase(discount.countryCurrency))
                    {
                        if(bestDiscount.discountAmount < discPrice.discountValue){
                            bestDiscount.discountAmount = discPrice.discountValue;
                            bestDiscount.salesDeal = discount.appliedSalesDeal;
                        }
                    }
                }
            }
        }
        system.debug('bestDiscount '+bestDiscount);
        return bestDiscount;
    }
    
     
     
    public static Discount getDiscountBulk(Sales_Deal__c salesDeal,  DiscountRequest request,List<Deal_Discount__C> dealDiscountList) {
        System.debug('Called!');
        List<Deal_Discount__C> dealDiscounts = new List<Deal_Discount__C>();
        Discount discount = new Discount();
        system.debug('dealDiscountList '+dealDiscountList.size()+' '+dealDiscountList);
        if(!dealDiscountList.isEmpty()){
            dealDiscounts.addAll(dealDiscountList);
        }
        
        if (salesDeal.RecordTypeId == Schema.SObjectType.Sales_Deal__c.getRecordTypeInfosByName().get('Promocode Deal').getRecordTypeId()) 
        {
            if(dealDiscounts.size()>0){
                //PromoCode__c promocode = [SELECT Deal_Discount__c, Deal_Discount__r.Discount_Value_Percentage__c FROM PromoCode__c WHERE Name = :request.promoCode LIMIT 1];
                PromoCode__c promocode = new PromoCode__c(); 
                promocode = request.promoCodeRec;
                // Percentage Discount
                if(dealDiscounts[0].Discount_Type__c == '% Discount'){
                    
                    discount.appliedSalesDeal = salesDeal;
                    discount.discountName = dealDiscounts[0].Sales_Deal__r.Discount_Display_Name__c; // Might need to get this details from promocode object
                    //   discount.typeOfDiscount = '% Discount';
                    discount.typeOfDiscount = dealDiscounts[0].Discount_Type__c;
                    discount.percentageValue = dealDiscounts[0].Discount_Value_Percentage__c;
                    discount.listPrice = request.quoteLineListPrice;
                    return discount;
                }
                else{
                    discount.appliedSalesDeal = salesDeal;
                    discount.discountName = dealDiscounts[0].Sales_Deal__r.Discount_Display_Name__c; // Might need to get this details from promocode object
                    //   discount.typeOfDiscount = '% Discount';
                    discount.typeOfDiscount = dealDiscounts[0].Discount_Type__c;
                    //    discount.percentageValue = dealDiscounts[0].Discount_Value_Percentage__c;
                    discount.listPrice = request.quoteLineListPrice;
                    discount.countryCurrency = request.country.Preferred_currency__c ;//added by Shalini
                    DiscountPrice price = new DiscountPrice();
                    price.discountCurrency = dealDiscounts[0].CurrencyIsoCode;
                    price.discountValue = dealDiscounts[0].Discount_Value_Amount__c;
                    discount.discountPrice.add(price);
                    return discount;
                }
            }
            else return discount;
            
        } else {
            return getDiscountBulk(salesDeal,dealDiscountList,request);
        }
    }
    
    
     
    
    private static Discount getDiscountBulk(Sales_Deal__c salesDeal,List<Deal_Discount__C> dealDiscountList,DiscountRequest request) {
     
        List<Deal_Discount__C> dealDiscounts = new List<Deal_Discount__C>();
        if(!dealDiscountList.isEmpty()){
            dealDiscounts.addAll(dealDiscountList);
        }
        System.debug('In Discount Apex');
        System.debug('@dealDiscounts '+dealDiscounts);
        Discount discount;
        for(Deal_Discount__C dealDiscount : dealDiscounts){
            if(dealDiscount.Discount_Type__c == '% Discount'){
                discount = new Discount();
                discount.appliedSalesDeal = salesDeal;
                discount.discountName = salesDeal.Discount_Display_Name__c;
                discount.typeOfDiscount = dealDiscount.Discount_Type__c;
                discount.percentageValue = dealDiscount.Discount_Value_Percentage__c;
                discount.listPrice = request.quoteLineListPrice;
                System.debug('Inside if in Discount'+ discount);
                return discount;
            }else{
                discount = new Discount();
                
        		discount.appliedSalesDeal = salesDeal;
                discount.discountName = salesDeal.Discount_Display_Name__c;
                discount.typeOfDiscount = dealDiscount.Discount_Type__c;
                discount.listPrice = request.quoteLineListPrice;
                discount.countryCurrency = request.country.Preferred_currency__c ;//added by Shalini
                DiscountPrice price = new DiscountPrice();
                price.discountCurrency = dealDiscount.CurrencyIsoCode;
                price.discountValue = dealDiscount.Discount_Value_Amount__c;
                discount.discountPrice.add(price);
                return discount;
            }
        }
        return discount;

    }
}