/*
** Tested by: zTEST_TF_IndiaReprintRoundOfMRP.cls
**
** Created by Amit Kumar 24/02/2020
*/
global without sharing class TF_IndiaReprintRoundOfMRP {
    
    @InvocableMethod
    public static void roundOfMRP(List<Id> lstId) {
        Integer roundRate = 95;
        List<OpportunityLineItem> oliToUpdate = new List<OpportunityLineItem>();
        if(null != lstId){
            List<OpportunityLineItem> olis = [Select Id, MRP__c, UnitPrice, Gross_Margin__c From OpportunityLineItem where Id in :lstId];            
            system.debug('@@@@TF_IndiaReprintRoundOfMRP olis::'+olis);
            for(OpportunityLineItem oliObj : olis) {
                OpportunityLineItem oli = new OpportunityLineItem();
                oli.Id = oliObj.Id;
                Decimal mrp;
                if(oli.Gross_Margin__c < 2.5) {
                    mrp = RoundOfCustomOptionOne(oliObj.MRP__c, roundRate);
                } else {
                    mrp = RoundOfCustomOptionTwo(oliObj.MRP__c, roundRate);
                }
                system.debug('@@@TF_IndiaReprintRoundOfMRP RoundedMRP::'+mrp);
                oli.MRP__c = mrp;
                oliToUpdate.add(oli);
            }
            system.debug('@@@@TF_IndiaReprintRoundOfMRP oliToUpdate::'+oliToUpdate);
            if(!oliToUpdate.isEmpty()) { 
                update oliToUpdate;
            }           
        }
    }

    
    public static Decimal getRoundOfMRP(Decimal mrp, Decimal gm) {
        Integer roundRate = 95;        
        if(gm < 2.5) {
            mrp = RoundOfCustomOptionOne(mrp, roundRate);
        } else {
            mrp = RoundOfCustomOptionTwo(mrp, roundRate);
        }
        system.debug('@@@@TF_IndiaReprintRoundOfMRP::'+mrp);
        return mrp;            
    }    
    
    public static Decimal RoundOfCustomOptionOne(Decimal value, Integer conversionRate){
        Integer mrp = Integer.valueOf(value);
        Integer rate = Integer.valueOf(conversionRate);
        String mrpStr;
        Integer mrpNew;
        if(mrp <= 100){
            mrp = 95;
        } else if(mrp <=1000 && mrp > 100) {
            mrpStr = String.valueOf(mrp);
            mrpStr = mrpStr.substring(0,1);
            mrpNew = Integer.valueOf(mrpStr);
            mrp = (mrp == 1000) ? 995 : (mrpNew)*100+rate;
        } else if(mrp <=10000 && mrp > 1000) {
            mrpStr = String.valueOf(mrp);
            mrpStr = mrpStr.substring(0,2);
            mrpNew = Integer.valueOf(mrpStr);
            mrp = (mrp == 10000) ? 9995 : (mrpNew)*100+rate;
        }
        return Decimal.valueOf(mrp);
    } 
    
    public static Decimal RoundOfCustomOptionTwo(Decimal value, Integer conversionRate){
        Integer mrp = Integer.valueOf(value);
        Integer rate = Integer.valueOf(conversionRate);
        String mrpStr;
        Integer mrpNew;
        if(mrp <= 100){
            system.debug('OptionTwo mrp <= 100');
            mrp = 95;
        } else if(mrp <=1000 && mrp > 100) {
            system.debug('OptionTwo mrp <=1000 && mrp > 100');
            mrpStr = String.valueOf(mrp);
            mrpStr = mrpStr.substring(0,1);
            system.debug('OptionTwo mrpStr::'+mrpStr);
            mrpNew = Integer.valueOf(mrpStr);
            mrp = (mrp == 1000) ? 995 : (mrpNew)*100+rate;
        } else if(mrp <=10000 && mrp > 1000) {
            system.debug('OptionTwo mrp <=10000 && mrp > 1000');
            mrpStr = String.valueOf(mrp);
            mrpStr = mrpStr.substring(0,2);
            mrpNew = Integer.valueOf(mrpStr);
            mrp = (mrp == 10000) ? 9995 : (mrpNew)*100+rate;
        }
        return Decimal.valueOf(mrp);
    }    
    
}