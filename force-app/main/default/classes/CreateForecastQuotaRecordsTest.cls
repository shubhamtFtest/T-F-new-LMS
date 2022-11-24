@istest
private class CreateForecastQuotaRecordsTest {
    @testSetup
    static void setup(){
        
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        System.debug(usr);
        System.runAs(usr){
        List<Territory2> territories = [SELECT ID, DeveloperName, Name, Territory2TypeId FROM Territory2];
        System.debug(territories);
        }
    }
    @isTest public static void callingConstructorTest(){
        CreateForecastQuotaRecords cfqr = new CreateForecastQuotaRecords();
    }
      
    @isTest public static void fetchForecastQuotaTest() {
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        List<ForecastingQuota> fq= new List<ForecastingQuota>();    
            System.RunAs(usr)
                {
                    Test.startTest();
                      fq= CreateForecastQuotaRecords.fetchForecastQuota();
                    Test.stopTest();
                }
        System.debug('fq-'+fq);
        }
        
        
    @isTest public static void getDateTest() {
        String inputDate = '2018-05-12'; 
        CreateForecastQuotaRecords.getDate(inputDate);
    }
     
    @isTest public static void deleteForecastQuotaTest() {
        ID getID;
        for(List<ForecastingType> i : [SELECT ID FROM ForecastingType limit 1]){
            getID=i[0].id;
        }
        ForecastingQuota forcastObj = new ForecastingQuota(ForecastingTypeId=getID,QuotaAmount= 54,QuotaOwnerId= UserInfo.getUserId(),CurrencyIsoCode='USD',
                                                               StartDate= System.today());
        
        CreateForecastQuotaRecords.deleteForecastQuota(getID);
    }
    
    @isTest public static void getTerritoryForetypeMapTest(){
    User usr = [Select id from User where Id = :UserInfo.getUserId()];
    //createRecordDubDub ( String  ProductFamily , String  StartDate, string CurrencyIsoCode, String  QuotaAmount, String  QuotaQuantity,String QuotaOwner ,String Territory ,String ForecastingType,String endDate )
     System.RunAs(usr)
                {
                Test.startTest();
                        CreateForecastQuotaRecords.getTerritoryForetypeMap();   
                Test.stopTest();
                }
    }
    
    @isTest public static void saveEditedRecTest(){
    List<ForecastingQuota> listquota = new List<ForecastingQuota>();
    User usr = [Select id from User where Id = :UserInfo.getUserId()];
    ID getID;
    for(List<ForecastingType> i : [SELECT ID FROM ForecastingType where IsActive = true limit 1 ]){
            getID=i[0].id;
        }
    ForecastingQuota forcastObj = new ForecastingQuota(ForecastingTypeId=getID,QuotaAmount= 54,QuotaOwnerId= UserInfo.getUserId(),CurrencyIsoCode='USD',
                                                               StartDate= System.today());
    
    listquota.add(forcastObj);
    insert listquota;
        
    String quotaId;
        for(List<ForecastingQuota> i : [SELECT ID FROM ForecastingQuota ]){
            quotaId=i[0].id;
        }
    //createRecordDubDub ( String  ProductFamily , String  StartDate, string CurrencyIsoCode, String  QuotaAmount, String  QuotaQuantity,String QuotaOwner ,String Territory ,String ForecastingType,String endDate )
     System.RunAs(usr)
                {
                Test.startTest();
                        CreateForecastQuotaRecords.saveEditedRec(quotaId,'200');   
                Test.stopTest();
                }
        
    Account a = new Account(name = 'New Account test' );
    insert a;
    Lookup.searchDB('Account','Id','name',1,'name','New Account test');
    }
    
    @isTest public static void createRecordDubTest(){
    String ProductFamily='Library';
    String StartDate='2018-05-12';
    String CurrencyIsoCode='USD';
    String QuotaAmount='20';
    String QuotaQuantity;
    String QuotaOwner=UserInfo.getUserId();
    String nameTerritory;
    String ForecastingType;
    String endDate='2018-05-12';
    List<Opportunity> listOpportunity;
    ID getID;
    User usr = [Select id from User where Id = :UserInfo.getUserId()];
    ID getTID;
    List<Territory2Type> terriType   = [SELECT id, DeveloperName from Territory2Type where  DeveloperName = 'DeveloperName' LIMIT 1];
    for(List<ForecastingType> i : [SELECT ID FROM ForecastingType where IsActive = true limit 1 ]){
            getID=i[0].id;
        }
        ForecastingType=String.valueOf(getID);
    for(List<Territory2> territories : [SELECT ID, DeveloperName, Name, Territory2TypeId FROM Territory2]){
        nameTerritory=territories[0].id;
    }
    System.debug(nameTerritory);
    try{
        CreateForecastQuotaRecords.createRecordDubDub(ProductFamily,StartDate,CurrencyIsoCode,QuotaAmount,QuotaQuantity,QuotaOwner,nameTerritory,ForecastingType,endDate);     
    }catch(Exception e){
        System.debug(e);
    }
    
    
    }
}