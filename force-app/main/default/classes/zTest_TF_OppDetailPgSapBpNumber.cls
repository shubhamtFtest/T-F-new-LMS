@istest
public class zTest_TF_OppDetailPgSapBpNumber {
@TestSetup
static void makeData(){
    Account acc = new account(name='testAcc',Billing_City__c='Abingdon',Billing_Country_List__c='',Billing_State_List__c='Oxfordshire',BillingStreet='street \n 101',ShippingStreet='street \n 101',Billing_Street__c='4 Park Square4 Park Square4 Park Square4 \n Park Square4 Park Square4 Park Square4 Park Square4 Park Square4 Park Square',Billing_ZIP__c='OX14 4RN');
    insert acc;  
    Contact c = new Contact(
    FirstName = 'Test Contact'   ,
    LastName = 'Test Last Name'  ,
    Email = 'abc@abc.com',
    AccountId = acc.Id ,
    Phone='0123456789'
    );
    insert c;

    Campus__c camp = new Campus__c
    (Name='testAccCamp', Account__c= acc.id );
    insert camp;

    SAP_BP__c sapPending = new SAP_BP__c(Name='PENDING' , Address_Type__c =  'Account Billing');
    insert sapPending;

    Opportunity opp = new Opportunity(
      name='testopp',
      Type = 'New Business',
      stagename='Verbal',
      Probability=80,
      closedate=Date.newInstance(2011, 01, 01),
      CurrencyIsoCode = 'EUR',
      accountId=acc.Id,
      Bill_to_BP__c    = sapPending.Id, 
      Ship_to_BP__c  = sapPending.Id,
      Sold_to_BP__c  = sapPending.Id,
      Payer_BP__c  = sapPending.Id
    );
    insert opp;

    Opportunity oppNosap = new Opportunity(
      name='testoppNoSap',
      Type = 'New Business',
      stagename='Verbal',
      Probability=80,
      closedate=Date.newInstance(2011, 01, 01),
      CurrencyIsoCode = 'EUR',
      accountId=acc.Id
    );
    insert oppNosap;
    
    
}

    @istest 
    public static void lookup(){
        List<String> listStr = new List<String>(); 
       listStr = TF_OppDetailPgSapBpNumber.splitStringBySpace('No past activity. Past meetings and tasks marked as done show up here.',35);
        // seetBpNumber 
        account acc  = [select id from account limit 1 ];
        Contact con = [select id from contact where LastName = 'Test Last Name' limit 1 ];
         List<TF_OppDetailPgSapBpNumber.SObJectResult> ls = TF_OppDetailPgSapBpNumber.getResults('account', 'name','testAcc', false , null , false,con.id); 

        Opportunity opp = [select id from Opportunity where name='testopp' limit 1 ];
        system.debug('---->'+acc+' -->'+con+' -->'+opp);
        String status2 = TF_OppDetailPgSapBpNumber.setBpNumber( con.Id , acc.id  , 'account' , 'Sold to BP' ,'Account Shipping',opp.Id );
       

    }  

    @istest 
    public static void getOppData(){
        account acc  = [select id from account where name='testAcc'  limit 1 ];
         Contact con = [select id from contact where LastName = 'Test Last Name' limit 1 ];
        List<TF_OppDetailPgSapBpNumber.SObJectResult> lstWithAcc = TF_OppDetailPgSapBpNumber.getResults('Campus__c', 'name','testAccCamp', true , acc.Id , true,con.id ); 
        String getSelectedContactEmail=TF_OppDetailPgSapBpNumber.getSelectedContactEmail(con.id);
        Opportunity opp = [select id from Opportunity where name='testopp' limit 1 ];
        TF_OppDetailPgSapBpNumber.OppSapData  oppdata = TF_OppDetailPgSapBpNumber.getOppData(opp.Id);


        Opportunity oppNoSap = [select id from Opportunity where name='testoppNoSap' limit 1 ];
        TF_OppDetailPgSapBpNumber.OppSapData  oppdataNoSap = TF_OppDetailPgSapBpNumber.getOppData(oppNoSap.Id);

        // seetBpNumber 
        // Contact con = [select id from contact where LastName = 'Test Last Name' limit 1 ];
        // String status1 = TF_OppDetailPgSapBpNumber.setBpNumber( con.Id , acc.id  , 'account' , 'Sold to BP' ,'Campus',opp.Id );
    }    

    @istest 
    public static void callSetBpNumber(){
        account acc  = [select id from account limit 1 ];
        Contact con = [select id from contact where LastName = 'Test Last Name' limit 1 ];
        Opportunity opp = [select id from Opportunity where name='testopp' limit 1 ];
        String status = TF_OppDetailPgSapBpNumber.setBpNumber( con.Id , acc.id  , 'account' , 'Sold to BP' ,'Account Mailing',opp.Id );
       TF_OppDetailPgSapBpNumber.copybilltoShip(opp.id);
		TF_OppDetailPgSapBpNumber.getSelectedAddress(acc.id, 'account', 'Account Mailing');        
        
        // String status3 = TF_OppDetailPgSapBpNumber.setBpNumber( con.Id , acc.id  , 'account' , 'Sold to BP' ,'Account Billing',opp.Id );
    }
    @istest
    public static void callinitMapgQuery(){
        String initMapgQuery=TF_OppDetailPgSapBpNumber.initMapgQuery('Campus');
        String initMapgQuery1=TF_OppDetailPgSapBpNumber.initMapgQuery('Account Billing');
    }

    
}