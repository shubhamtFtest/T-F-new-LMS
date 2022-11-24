/**
* File Name: CreateForecastQuotaRecords
* Description : The class is used to fetch all forecast Quote ,insert & delete forecast Quote  
* @author :  shashank
* Test class: 
* Test coverage : 
* */ 

// # trim all fields before inserting 
public with sharing class CreateForecastQuotaRecords {
    public CreateForecastQuotaRecords() {
        
    }
    // map to names of territory & forescate type  
    @AuraEnabled
    public static TerFortypeClass getTerritoryForetypeMap(){
        Map<String,String> mapIdNameTerritory = new Map<String,String>();
        Map<String,String> mapIdNameForType = new Map<String,String>();
        for (Territory2 ter : [SELECT Id,Name  FROM Territory2] ) {
           mapIdNameTerritory.put(ter.id, ter.Name );
        }
        for (ForecastingType  forcastObj : [SELECT Id,MasterLabel  FROM ForecastingType where IsActive = true] ) {
           mapIdNameForType.put(forcastObj.id, forcastObj.MasterLabel );
        }
        TerFortypeClass TerFortypeClassObj = new TerFortypeClass();
        TerFortypeClassObj.mapIdNameTerritory =mapIdNameTerritory ;
        TerFortypeClassObj.mapIdNameForType = mapIdNameForType;
        
        return TerFortypeClassObj;
    }
    @AuraEnabled
    public static  List<ForecastingQuota> fetchForecastQuota(){
        List<ForecastingQuota> listForecatQuota= new List<ForecastingQuota>([SELECT Id,QuotaOwnerId,ForecastingTypeId,ProductFamily,QuotaAmount,QuotaQuantity,StartDate,CurrencyIsoCode,QuotaOwner.name,Territory2Id FROM ForecastingQuota]);
        system.debug('soql - '+ listForecatQuota);
        return listForecatQuota; 
    }
    @AuraEnabled 
    public static  void saveEditedRec(String strId , String  AmountQuota){
        system.debug('id - '+strId);
        system.debug('id - '+[SELECT Id FROM ForecastingQuota WHERE Id =:Id.valueOf(strId) ]);
        ForecastingQuota fq = new ForecastingQuota(Id= Id.valueOf(strId)  ) ;
        fq.QuotaAmount = (String.isNotBlank(AmountQuota)? Decimal.valueOf(AmountQuota) : 0  );

        if(fq != null){
            update fq;
        }
    }
    @AuraEnabled
    public static  void deleteForecastQuota(String Id ){
        if (!String.isEmpty(Id)) {
            system.debug('ID-'+Id);
            List<ForecastingQuota> listForecatQuota= new List<ForecastingQuota>([SELECT Id,QuotaOwnerId,ForecastingTypeId,ProductFamily,QuotaAmount,QuotaQuantity,StartDate,CurrencyIsoCode FROM ForecastingQuota where Id = :Id ]);
            if (listForecatQuota!= null && listForecatQuota.size()>0) {
               delete listForecatQuota;
            }
        }
    }
    // # cavhing updateRecord
    @AuraEnabled
    public static void createRecordDubDub ( String  ProductFamily , String  StartDate, string CurrencyIsoCode, String  QuotaAmount, String  QuotaQuantity,String QuotaOwner ,String Territory ,String ForecastingType,String endDate ){
        // required field Forecasting Type startdt  /**/
        system.debug('QuotaAmount-'+QuotaAmount); 
        system.debug('QuotaQuantity-'+QuotaQuantity); 
        system.debug('ProductFamily-'+ProductFamily);    
        system.debug('StartDate-'+StartDate); 
        system.debug('endDate-'+endDate); 
        ProductFamily = (String.isNotBlank(ProductFamily) ? ProductFamily.trim() : null );
        Date StartDateMod =  getDate(StartDate);
        Date endDateMod = ( (endDate != null && String.isNotBlank(endDate) && String.isNotEmpty(endDate) && endDate != '' ) ? getDate(endDate) : StartDateMod );  
            // create ForecastingQuota  //  QuotaOwner  Territory   ForecastingType   editMode
        System.debug('StartDateMod-'+StartDateMod);
        System.debug('endDateMod-'+endDateMod);
        List<ForecastingQuota> listForecastingQuota = new List<ForecastingQuota>();
        integer q= 0; // for appending monts 
        Integer monthsBetween =StartDateMod.monthsBetween(endDateMod);
        if (StartDateMod!=null ) {
            // insert hrere 
           for (integer i = 0 ; i <= monthsBetween; i++) {
                ForecastingQuota objs;
                objs = new ForecastingQuota( ProductFamily = ProductFamily,StartDate = StartDateMod.addMonths(q)  ); 
                q++;
                objs.ForecastingTypeId =  (String.isNotBlank(ForecastingType) ? ForecastingType : null ); 
                objs.Territory2Id =  (String.isNotBlank(Territory) ? Territory : null ) ;
                objs.QuotaAmount = (String.isNotBlank(QuotaAmount)? Decimal.valueOf(QuotaAmount) : 0  );
                objs.QuotaQuantity = (String.isNotBlank(QuotaQuantity)? Decimal.valueOf(QuotaQuantity) : 0  );
                objs.QuotaOwnerId =  (String.isNotBlank(QuotaOwner) ? QuotaOwner : UserInfo.getUserId() );
                objs.CurrencyIsoCode =  (String.isNotBlank(CurrencyIsoCode) ? CurrencyIsoCode.trim() : null ) ;
                listForecastingQuota.add(objs);
           }

        }
        
        try{
            System.debug('listForecastingQuota-'+listForecastingQuota);
            if(listForecastingQuota != null  && listForecastingQuota.size() >0 ){
                insert listForecastingQuota;
            }
            
        } catch (Exception e){
            
            throw new AuraHandledException( e.getMessage());
        }
        
    }
    public static Date getDate(String strDate  ){
        list<string> dateStr ;
        if(string.isNotEmpty(strDate)){
            dateStr = strDate.remove('\"').split('-');
            System.debug(dateStr);   
         // year date month
        integer yearInt=integer.valueOf(dateStr.get(0));System.debug('yearInt-'+yearInt);
        integer monthInt =integer.valueOf(dateStr.get(1)); System.debug('monthInt-'+monthInt);
        integer  dateInt=integer.valueOf(dateStr.get(2)); System.debug('dateInt-'+dateInt);
        Date dateComing =Date.newInstance(yearInt,monthInt,dateInt);
        System.debug('dateComing-'+dateComing);
        return dateComing;
        }
        return null;
    }  
    public class TerFortypeClass {
       @AuraEnabled
       public map<String,String> mapIdNameForType {get; set;}
       @AuraEnabled
       public map<String,String> mapIdNameTerritory {get; set;}
    }
    
}