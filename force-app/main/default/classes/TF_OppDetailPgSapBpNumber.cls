/**
 * Author : Shashank   
 * Detail : This class is used to locate the Sap Bp no. 
 * Test class : zTest_TF_OppDetailPgSapBpNumber 
 */ 
public  class TF_OppDetailPgSapBpNumber {
    
    public static String lookupFieldSap;
    public static  Map<String , Map < String , String>> mapAddTypeFieldApiName ;
    public static Map<String, String> mapFieldApiName ;
    public static  String vat;
        
    @testVisible
    private Static String initMapgQuery(String addressType){
        String fieldApiNameCommaSepartd =''; // for query
        mapAddTypeFieldApiName = new Map<String , Map < String , String> >();
        mapFieldApiName = new Map<String, String>();
        if ( String.isNotBlank(addressType) && ( addressType.equalsIgnoreCase('Campus') ||  addressType.equalsIgnoreCase('Department') ) ) {
            mapFieldApiName.clear();
            mapFieldApiName.put( 'city','Mailing_City__c' );
            mapFieldApiName.put( 'country','Mailing_Country_List__c' );
            mapFieldApiName.put( 'state','Mailing_State_Province_List__c' );
            mapFieldApiName.put( 'street','Mailing_Street__c' );
            mapFieldApiName.put( 'zip','Mailing_ZIP_Postal_Code__c' );  
            mapFieldApiName.put( 'VAT','Account__r.VAT_Number__c' );
            if(addressType.equalsIgnoreCase('Campus')){
                lookupFieldSap = 'Campus_Id__c';
                mapAddTypeFieldApiName.put('Campus',mapFieldApiName);
            }
            if(addressType.equalsIgnoreCase('Department')) {
                lookupFieldSap = 'Department_Id__c';            
                mapAddTypeFieldApiName.put('Department',mapFieldApiName);
            }
        }
        if ( String.isNotBlank(addressType) && addressType.equalsIgnoreCase('Account Mailing') ) {
            mapFieldApiName.clear();
            mapFieldApiName.put( 'city','BillingCity' );
            mapFieldApiName.put( 'country','Mailing_Country_List__c' );
            mapFieldApiName.put( 'state','Mailing_State_List__c' );
            mapFieldApiName.put( 'street','BillingStreet' );
            mapFieldApiName.put( 'zip','BillingPostalCode' );  
            mapFieldApiName.put( 'VAT','VAT_Number__c' );
            mapAddTypeFieldApiName.put('Account Mailing',mapFieldApiName);      
            lookupFieldSap = 'Account_Id__c';                  
        }
        if ( String.isNotBlank(addressType) && addressType.equalsIgnoreCase('Account Shipping') ) {
            mapFieldApiName.clear();
            mapFieldApiName.put( 'city','ShippingCity' ); // ShippingCity  Shipping_City__c
            mapFieldApiName.put( 'country','Shipping_Country_List__c' );
            mapFieldApiName.put( 'state','Shipping_State_List__c' );
            mapFieldApiName.put( 'street','ShippingStreet' ); // ShippingStreet  Shipping_Street__c
            mapFieldApiName.put( 'zip','ShippingPostalCode' );      // ShippingPostalCode   Shipping_ZIP_Postal_Code__c     
            mapFieldApiName.put( 'VAT','VAT_Number__c' );
            mapAddTypeFieldApiName.put('Account Shipping',mapFieldApiName);                   
            lookupFieldSap = 'Account_Id__c';                  
        }
        if ( String.isNotBlank(addressType) && addressType.equalsIgnoreCase('Account Billing') ) {
            mapFieldApiName.clear();
            mapFieldApiName.put( 'city','Billing_City__c' );
            mapFieldApiName.put( 'country','Billing_Country_List__c' );
            mapFieldApiName.put( 'state','Billing_State_List__c' );
            mapFieldApiName.put( 'street','Billing_Street__c' );
            mapFieldApiName.put( 'zip','Billing_ZIP__c' ); 
            mapFieldApiName.put( 'VAT','VAT_Number__c' );
            mapAddTypeFieldApiName.put('Account Billing',mapFieldApiName);      
            lookupFieldSap = 'Account_Id__c';                  
        }

        System.debug('mapAddTypeFieldApiName-'+mapAddTypeFieldApiName);
        // return the fields api name ( comma separated)
        Integer lastElementIndex = mapFieldApiName.values().size() ;
        Integer i = 0 ;
            for (String fieldApiName  : mapFieldApiName.values()) {
                i++;
                if (i != lastElementIndex ) {
                    fieldApiNameCommaSepartd = fieldApiNameCommaSepartd + fieldApiName + ' ,' ;
                }else {
                    fieldApiNameCommaSepartd = fieldApiNameCommaSepartd + fieldApiName ;
                }               
            }          
        return fieldApiNameCommaSepartd;
    } 

    @AuraEnabled
    public static String getSelectedContactEmail(String sobjectId){
        List<Contact> listSObjectDb = new List<Contact>();
        String dynamicQueryForSobject;
        String Email;
        dynamicQueryForSobject = 'Select id, Email FROM Contact WHERE id = :sobjectId LIMIT 1 ' ;
        if ( String.isNotBlank(dynamicQueryForSobject)) {   
            System.debug('dynamicQueryForSobject -'+ dynamicQueryForSobject);
            listSObjectDb = Database.query(dynamicQueryForSobject);             
            System.debug('listSObjectDb -'+ listSObjectDb);
            if ( !listSObjectDb.isEmpty()) {    
                Contact sObj = listSObjectDb.get(0);
                Email = ( String.valueOf(sObj.Email));
            }
        }
        //if(Email != NULL) return Email;
        return Email;
    }
     @AuraEnabled
    public static String getSelectedAddress(String sobjectId , String sObjectName , String addressType){
        List<SObject> listSObjectDb = new List<SObject>();
        String dynamicQueryForSobject;
        // generating query for sobject dynamic  - account /campus / departemnt  
        dynamicQueryForSobject = 'Select Name,' + initMapgQuery(addressType) + ' FROM ' + sObjectName + ' WHERE id = :sobjectId LIMIT 1 ' ;
         // fetching account / department / campus                        
        if ( String.isNotBlank(dynamicQueryForSobject)) {                 
            System.debug('dynamicQueryForSobject -'+ dynamicQueryForSobject);
            listSObjectDb = Database.query(dynamicQueryForSobject);      // Acc / campus / department   (only 1 element )           
            System.debug('listSObjectDb -'+ listSObjectDb);
            if ( !listSObjectDb.isEmpty() && !mapFieldApiName.isEmpty() ) {                                                  
                sObject sObj = listSObjectDb.get(0);
                String Street = ( String.valueOf(sObj.get(mapFieldApiName.get('street'))))    ; 
                String City = (String.valueOf(sObj.get(mapFieldApiName.get('city'))))       ;                     
                String State = (String.valueOf(sObj.get(mapFieldApiName.get('state'))))  ;
                String Country = (String.valueOf(sObj.get(mapFieldApiName.get('country')))) ;
                String ZIP = (String.valueOf(sObj.get(mapFieldApiName.get('zip')))) ;

                String selectedAdd = (String.isNotBlank(street) ? street +', ' : '') + (String.isNotBlank(city) ? city + ', ' : '') + (String.isNotBlank(state) ? state +', ' : '') + (String.isNotBlank(country) ? country+', ' : '') + (String.isNotBlank(zip) ? zip : '');
                System.debug('selectedAdd-'+selectedAdd);
                return selectedAdd; 
            }
        }
        return null;
    }


    @AuraEnabled
    public static void copybilltoShip( Id oppId){
        List<opportunity> listoppDb = new List<opportunity>([SELECT id,Sold_to_BP__c,Ship_to_BP__c,Bill_to_BP__c,Payer_BP__c FROM opportunity WHERE id = :oppId  limit 1 ]);
        if ( !listoppDb.isEmpty() && listoppDb.get(0).Bill_to_BP__c != NULL) {
            listoppDb.get(0).Ship_to_BP__c = listoppDb.get(0).Bill_to_BP__c;
            update listoppDb;
        }
        
    }
    
/**
* setBpNumber description :  the method will serach for the exact Bp match then will update the Bp Number on opp 
* @param  conId           :  contact Id 
* @param  sobjectId       :  campus/department/account id 
* @param  sObjectName     :  campus/department/account object API Name 
* @param  whichBpHearder  :  sold to , ship to , bill to , payer bp - which bp field to update   
* @return                 :  May be a success  message .
**/
    @AuraEnabled
    public static String setBpNumber(String conId ,String sobjectId , String sObjectName , String whichBpHearder ,String addressType ,String oppId){
        system.debug('****Method Called***');

        try {                        
            System.debug(' setBpNumber called ');
            Map<Id, SAP_BP__c> mapIdSapBpDB = new Map<Id, SAP_BP__c>();
            List<Campus__c> listCampusDb = new List<Campus__c>();
            List<SAP_BP__c> listSapDb = new List<SAP_BP__c>();
            List<Account> listAccpuntDb = new List<Account>();
            List<Department__c> listDepartmentDb = new List<Department__c>();
            List<SObject> listSObjectDb = new List<SObject>();
            List<Contact> listContactDb = new List<Contact>();
            Set<Id> setMatchedIds = new Set<Id>(); // SAL-1209 :- only if more than 1 match found then to protect it from deactivation 
            String dynamicQueryForSobject;
            String addressLine1 = '';
            String addressLine2 = '';
            String addressLine3 = '';
            String querySap = 'SELECT Name,Tax_Registration_Number__c,Region__c,State__c,Street__c,ZIP__c,City__c,Country__c,Status__c,Email__c,First_Name__c,Last_Name__c,Department_Id__c,Account_Id__c,Campus_Id__c,Address_Type__c FROM SAP_BP__c ' ; 
            if ( String.isNotBlank(sobjectId) && String.isNotBlank(sObjectName) && String.isNotBlank(addressType) && String.isNotBlank(conId) ){
                // fetch contact
                listContactDb = [SELECT id, firstName , lastName , email,Phone FROM Contact WHERE id = : conId LIMIT 1] ;

                // generating query for sobject dynamic  - account /campus / departemnt  
                dynamicQueryForSobject = 'Select Name,' + initMapgQuery(addressType) + ' FROM ' + sObjectName + ' WHERE id = :sobjectId LIMIT 1 ' ;
                
                // fetching account / department / campus                        
                if ( String.isNotBlank(dynamicQueryForSobject)) {                 
                    querySap = querySap + ' WHERE '+ lookupFieldSap +' = :sobjectId ' + ' AND Address_Type__c = :addressType' ; 
                    System.debug('querySap -'+ querySap);
                    system.debug('sobjectId-'+sobjectId +'-addressType '+addressType);
                    System.debug('dynamicQueryForSobject -'+ dynamicQueryForSobject);
                    listSapDb = Database.query(querySap);  // there can be many elements               
                    listSObjectDb = Database.query(dynamicQueryForSobject);      // Acc / campus / department   (only 1 element )           
                    System.debug('listSapDb -'+ listSapDb);
                    System.debug('listSapDb.size() -'+ listSapDb.size());
                    System.debug('listSObjectDb -'+ listSObjectDb);
                    Boolean matchFound = false ; 
                    SAP_BP__c matchedSapBpObj ;
                    Contact con = listContactDb.get(0); 
                    
                    // compare all the fields in sap bp table
                    if ( !listSObjectDb.isEmpty() && !mapFieldApiName.isEmpty() && !listContactDb.isEmpty()) {                                                  
                        sObject sObj = listSObjectDb.get(0);
                        system.debug('sObj-'+sObj);
                        string streetStr = String.valueOf(sObj.get(mapFieldApiName.get('street')));
                        if( String.isNotBlank(streetStr) ){
                            System.debug('-  streetStr-'+streetStr);
                            streetStr = streetStr.replace('\n', ' '); 
                            streetStr = streetStr.replace('\r', ' ');
                            streetStr = streetStr.replace('\t', ' ');
                            System.debug('-  streetStr-'+streetStr);
                        }
                        
                        if(sObjectName.containsIgnoreCase('Account') ) vat =  String.valueOf(sObj.get('VAT_Number__c'));
                        else vat =  String.valueOf(sObj.getSobject('Account__r').get('VAT_Number__c'));

                    //Code for seperating addressLine1,addressLine2,addressLine3 from street field.
                    //system.debug('debug1---'+String.valueOf(sObj.get(mapFieldApiName.get('street')))+'--->'+String.valueOf(sObj.get(mapFieldApiName.get('street'))).length());
                    
                        
                    List<String> listStr = new List<String>();
                                                              
                    if(String.isNotBlank(String.valueOf(sObj.get(mapFieldApiName.get('street')))) && String.valueOf(sObj.get(mapFieldApiName.get('street'))).length() > 34  ){
                    system.debug('entered in if condition');
                    listStr=splitStringBySpace(String.valueOf(sObj.get(mapFieldApiName.get('street'))),34); 
                        system.debug('split'+listStr);
                        
                        if(!listStr.isEmpty() ){
                            addressLine1 = listStr.get(0);
                            system.debug('splitaddressLine1'+addressLine1);
                            addressLine2 = listStr.get(1);
                            system.debug('splitaddressLine2'+addressLine2);
                            addressLine3 = listStr.get(2);
                            system.debug('splitaddressLine3'+addressLine3);
                        }
                        
                    } 
                    system.debug('****'+addressLine1+' ***'+addressLine2+' ***'+addressLine3);   
                       
                        
                        for ( SAP_BP__c spBpObj  : listSapDb ) {
                            // address matching 
                            system.debug('spBpObj-'+spBpObj );
                            System.debug(spBpObj.Street__c);
                            System.debug(( String.valueOf(sObj.get(mapFieldApiName.get('street')))));
                            system.debug((spBpObj.Tax_Registration_Number__c ==  vat ));                                                     
                            System.debug(spBpObj.Street__c == ( String.valueOf(sObj.get(mapFieldApiName.get('street')))) );
                            System.debug(spBpObj.City__c == (String.valueOf(sObj.get(mapFieldApiName.get('city')))) );
                            System.debug(spBpObj.State__c == (String.valueOf(sObj.get(mapFieldApiName.get('state'))))  );
                            System.debug( spBpObj.Country__c == (String.valueOf(sObj.get(mapFieldApiName.get('country')))));
                            System.debug( spBpObj.ZIP__c == (String.valueOf(sObj.get(mapFieldApiName.get('zip')))));
                            System.debug( spBpObj.Email__c == (con.Email));
                            System.debug(  spBpObj.First_Name__c == (con.FirstName ));
                            System.debug(  spBpObj.Last_Name__c == (con.LastName) );

                            if ( spBpObj.Street__c == streetStr  && 
                            spBpObj.City__c == (String.valueOf(sObj.get(mapFieldApiName.get('city')))) &&                             
                            spBpObj.State__c == (String.valueOf(sObj.get(mapFieldApiName.get('state'))))  &&
                            spBpObj.Country__c == (String.valueOf(sObj.get(mapFieldApiName.get('country')))) &&
                            spBpObj.ZIP__c == (String.valueOf(sObj.get(mapFieldApiName.get('zip')))) &&
                            spBpObj.Email__c == (con.Email) &&
                            spBpObj.First_Name__c == (con.FirstName ) &&
                            spBpObj.Last_Name__c == (con.LastName)  &&
							spBpObj.Tax_Registration_Number__c ==  vat                             
                               ){
                                matchFound  = true ; 
                                matchedSapBpObj = spBpObj;
                                setMatchedIds.add(spBpObj.id);
                                //break;                            
                            }                                                                                                            
                        }

                        /* https://taylorfrancis.atlassian.net/browse/SAL-1209  */ 
                        List<SAP_BP__c> listSapBPToUnactivate = new List<SAP_BP__c>();
                        for ( SAP_BP__c spBpObj  : listSapDb ) {
                            if( !setMatchedIds.contains(spBpObj.id) ){
                                //spBpObj.Status__c = false;
                                listSapBPToUnactivate.add(spBpObj); 
                            }
                        }    //update listSapBPToUnactivate; 

                        /* https://taylorfrancis.atlassian.net/browse/SAL-1209  */ 
                        List<opportunity> listoppDb = new List<opportunity>([SELECT id,Sold_to_BP__c,Ship_to_BP__c,Bill_to_BP__c,Payer_BP__c FROM opportunity WHERE id = :oppId  limit 1 ]);
                        Opportunity oppobj = new Opportunity();
                        if( !listoppDb.isEmpty()) oppobj = listoppDb.get(0);
                        System.debug('matchFound-'+matchFound);
                        System.debug('matchedSapBpObj-'+matchedSapBpObj);
                        if(!matchFound) {
                            //  create sapBp record as pending obj   
                            /*
                            ( whichBpHearder.equalsIgnoreCase('Sold to BP') && oppobj.Sold_to_BP__c == NULL ) || ( whichBpHearder.equalsIgnoreCase('Ship to BP') && oppobj.Ship_to_BP__c == NULL ) || (whichBpHearder.equalsIgnoreCase('Bill to BP') && oppobj.Bill_to_BP__c ==NULL ) || ( whichBpHearder.equalsIgnoreCase('Payer BP') && oppobj.Payer_BP__c == NULL)
                            */
                            Id idLastSapBp ;
                            if (whichBpHearder.equalsIgnoreCase('Sold to BP') && oppobj.Sold_to_BP__c != NULL ) {
                                idLastSapBp =  oppobj.Sold_to_BP__c;
                            }
                            else if (whichBpHearder.equalsIgnoreCase('Ship to BP') && oppobj.Ship_to_BP__c == NULL) {
                                idLastSapBp =  oppobj.Ship_to_BP__c;
                            }
                            else if (whichBpHearder.equalsIgnoreCase('Bill to BP') && oppobj.Bill_to_BP__c ==NULL ) {
                                idLastSapBp =  oppobj.Bill_to_BP__c;

                            }
                            else if (whichBpHearder.equalsIgnoreCase('Payer BP') && oppobj.Payer_BP__c == NULL ) {
                                idLastSapBp =  oppobj.Payer_BP__c;
                            }
                            SAP_BP__c sapPending;
                            if (idLastSapBp != null ) {
                                List<SAP_BP__c> listSapLast = new List<SAP_BP__c>([select id, name ,Email__c, Street__c,Region__c,City__c,State__c,Country__c,ZIP__c  from SAP_BP__c WHERE id = : idLastSapBp LIMIT 1]); 
                                // has got id And name not pending then DO NOT  overwrite that record 
                                if( !listSapLast.isEmpty() && (listSapLast.get(0).name != 'PENDING' || (listSapLast.get(0).name!= null && !listSapLast.get(0).name.containsIgnoreCase('PENDING'))) ){
                                    // to avoid overwriting any other sap bp record which is not pending
                                    sapPending = new SAP_BP__c(Name='PENDING');   
                                }
                                // has got id And name ==  pending then overwrite that record 
                                else {                                                                         
                                    sapPending = listSapLast.get(0);  
                                }

                            }
                            // dont have any id , its a blank value
                            else {
                                sapPending = new SAP_BP__c(Name='PENDING'  );       //, Address_Type__c =  addressType
                            }
            
                            sapPending.Street__c = String.valueOf(sObj.get(mapFieldApiName.get('street')));
                            if(addressLine1 != '' || addressLine2 !='' || addressLine3 !=''){
                                system.debug('in if condition ----');
                                sapPending.address_line1__c = addressLine1;
                                sapPending.address_line2__c = addressLine2;
                                sapPending.address_line3__c = addressLine3;
                            }
                            else{
                                system.debug('in else condition ----');
                                sapPending.address_line1__c = String.valueOf(sObj.get(mapFieldApiName.get('street')));
                            }
                            system.debug('no condition ----');
                            
                           // sapPending.Telephone__c=
                            sapPending.City__c = String.valueOf(sObj.get(mapFieldApiName.get('city')));
                            sapPending.State__c = String.valueOf(sObj.get(mapFieldApiName.get('state')));
                            sapPending.Country__c =String.valueOf(sObj.get(mapFieldApiName.get('country'))) ;
                            sapPending.ZIP__c = String.valueOf(sObj.get(mapFieldApiName.get('zip')));
                            //sapPending.Status__c = true ;
                            sapPending.Category__c = 'Organisation' ;
                            sapPending.Source__c = 'Direct/Agent Opp Order' ;
                            sapPending.Email__c = con.Email;
                            sapPending.First_Name__c = con.FirstName ;
                            sapPending.Last_Name__c = con.LastName;
                            sapPending.Address_Type__c = addressType;
                            system.debug('con.Phone'+con.Phone);
                            if(con.Phone!=null)
                            sapPending.Telephone__c=con.Phone;
                            sapPending.put(lookupFieldSap,sObj.id); 

                            upsert sapPending;
                            System.debug('sapPending-'+sapPending);
                            matchedSapBpObj = sapPending;  
                            // update opp lookup
                            /* doing by process builder https://taylorfrancis.atlassian.net/browse/SAL-1128 -- automatically default Sold To & Payer to be set to the same values as the Billing Address */
                            if( whichBpHearder.equalsIgnoreCase('Bill to BP'))  {
                                oppobj.Bill_to_BP__c = matchedSapBpObj.id;
                                // oppobj.Sold_to_BP__c = matchedSapBpObj.id;                            
                                // oppobj.Payer_BP__c = matchedSapBpObj.id;
                            }
                            if( whichBpHearder.equalsIgnoreCase('Ship to BP'))  oppobj.Ship_to_BP__c = matchedSapBpObj.id;
                            update oppobj;
                            return 'success';
                                                
                        }
                        if (matchFound) {                     
                            System.debug('update opp lookup-');   
                            // update opp lookup  ,
                            /*doing by process builder  https://taylorfrancis.atlassian.net/browse/SAL-1128 -- automatically default Sold To & Payer to be set to the same values as the Billing Address */
                            if( whichBpHearder.equalsIgnoreCase('Bill to BP')){
                                oppobj.Bill_to_BP__c = matchedSapBpObj.id;
                                // oppobj.Sold_to_BP__c = matchedSapBpObj.id;
                                // oppobj.Payer_BP__c = matchedSapBpObj.id;
                            }  
                            // if( whichBpHearder.equalsIgnoreCase('Sold to BP'))                              
                            // if( whichBpHearder.equalsIgnoreCase('Payer BP'))      
                            if( whichBpHearder.equalsIgnoreCase('Ship to BP'))  oppobj.Ship_to_BP__c = matchedSapBpObj.id;          
                            update oppobj;            
                            return 'success';
                        }
                    }
                }                                                                
            }      
            return 'error';      
        } 
        
        catch (Exception e ) {
            System.debug('I am at line ' + String.valueOf(e.getLineNumber())); 
             throw new AuraHandledException('Darn it! Something went wrong: ' + e.getMessage()); 
             


        }      
    }
    
    @AuraEnabled(cacheable=false)
    public static OppSapData getOppData( String recId){
        String bill_to_BP_nameVar;
        String bill_to_BP_IdVar;
        String bill_to_BP_EmailVar;
        String bill_to_BP_AddressVar;
        
        String ship_to_BP_nameVar;
        String ship_to_BP_IdVar;
        String ship_to_BP_EmailVar;
        String ship_to_BP_AddressVar;
        
        String sold_to_BP_nameVar;
        String sold_to_BP_IdVar;
        String sold_to_BP_EmailVar;
        String sold_to_BP_AddressVar;
        
        String payer_BP_nameVar;
        String payer_BP_IdVar;
        String payer_BP_EmailVar;
        String payer_BP_AddressVar;
        
        Set<Id> setSapBpIds = new Set<Id>();
        Map<String, Id> mapWhichBpNameId = new Map<String, Id>();
        List<Opportunity>  listOpp = new List<Opportunity>([Select id ,Bill_to_BP__c, Ship_to_BP__c,Sold_to_BP__c , Payer_BP__c FROM Opportunity WHERE id = : recId LIMIT 1  ]);
        
        if (!listOpp.isEmpty()) {
            Opportunity opp  = listOpp.get(0);
            System.debug('opp-'+opp.id);
            System.debug('opp.Bill_to_BP__c-'+opp.Bill_to_BP__c);
            System.debug('opp.Ship_to_BP__c-'+opp.Ship_to_BP__c);
            System.debug('opp.Sold_to_BP__c-'+opp.Sold_to_BP__c);
            System.debug('opp.Payer_BP__c-'+opp.Payer_BP__c);
            
            // mapping so that work will be completed in 1 query  
            if(opp.Bill_to_BP__c != NULL){
                mapWhichBpNameId.put( 'Bill_to_BP__c',opp.Bill_to_BP__c  );
                setSapBpIds.add(opp.Bill_to_BP__c);
            }
            if(opp.Ship_to_BP__c != NULL) {
                mapWhichBpNameId.put( 'Ship_to_BP__c',opp.Ship_to_BP__c  );
                setSapBpIds.add(opp.Ship_to_BP__c);
            }
            if(opp.Sold_to_BP__c != NULL) {
                mapWhichBpNameId.put( 'Sold_to_BP__c',opp.Sold_to_BP__c  );
                setSapBpIds.add(opp.Sold_to_BP__c);
            }
            if(opp.Payer_BP__c != NULL){
                mapWhichBpNameId.put( 'Payer_BP__c',opp.Payer_BP__c  );
                setSapBpIds.add(opp.Payer_BP__c);
            }
            
            System.debug('mapWhichBpNameId.keyset()-'+mapWhichBpNameId.keySet());
            System.debug('setSapBpIds-'+setSapBpIds);
            
            if ( !setSapBpIds.isEmpty() ) {                
                Map<Id, SAP_BP__c> mapIdSapBpDB = new Map<Id, SAP_BP__c>([select id, name ,Email__c, Street__c,Region__c,City__c,State__c,Country__c,ZIP__c  from SAP_BP__c WHERE id IN :setSapBpIds ]);
                System.debug('mapIdSapBpDB.keySet()-'+mapIdSapBpDB.keySet());
                System.debug('mapIdSapBpDB-'+mapIdSapBpDB);
                for (String  whichBp : mapWhichBpNameId.keySet()) {
                    Id spBpObjId = mapWhichBpNameId.get(whichBp);
                    
                    if ( mapIdSapBpDB.containsKey(spBpObjId) && mapIdSapBpDB.get(spBpObjId) != NULL) {
                        String street = mapIdSapBpDB.get(spBpObjId).Street__c  ;
                        String city =  mapIdSapBpDB.get(spBpObjId).City__c;
                        String state = mapIdSapBpDB.get(spBpObjId).State__c;
                        String country = mapIdSapBpDB.get(spBpObjId).Country__c;
                        String zip = mapIdSapBpDB.get(spBpObjId).ZIP__c;
                        if(whichBp.equals('Bill_to_BP__c')){
                            bill_to_BP_nameVar = mapIdSapBpDB.get(spBpObjId).name;
                            bill_to_BP_IdVar = spBpObjId;
                            bill_to_BP_EmailVar= mapIdSapBpDB.get(spBpObjId).Email__c; // 
                            bill_to_BP_AddressVar = (String.isNotBlank(street) ? street +', ' : '') + (String.isNotBlank(city) ? city + ', ' : '') + (String.isNotBlank(state) ? state +', ' : '') + (String.isNotBlank(country) ? country+', ' : '') + (String.isNotBlank(zip) ? zip : '');
                            if(bill_to_BP_AddressVar.endsWith(', ')){
                                bill_to_BP_AddressVar = bill_to_BP_AddressVar.removeEnd(', ');
                            }                                                       
                        }   
                        if(whichBp.equals('Ship_to_BP__c')){
                            ship_to_BP_nameVar = mapIdSapBpDB.get(spBpObjId).name;                            
                            ship_to_BP_IdVar = spBpObjId;                            
                            ship_to_BP_EmailVar= mapIdSapBpDB.get(spBpObjId).Email__c;                            
                            ship_to_BP_AddressVar   = (String.isNotBlank(street) ? street +', ' : '') + (String.isNotBlank(city) ? city + ', ' : '') + (String.isNotBlank(state) ? state +', ' : '') + (String.isNotBlank(country) ? country+', ' : '') + (String.isNotBlank(zip) ? zip : '');
                            if(ship_to_BP_AddressVar.endsWith(', ')){
                                ship_to_BP_AddressVar = ship_to_BP_AddressVar.removeEnd(', ');
                            }   
                        }   
                        if(whichBp.equals('Sold_to_BP__c')){
                            sold_to_BP_nameVar = mapIdSapBpDB.get(spBpObjId).name;
                            sold_to_BP_IdVar = spBpObjId;
                            sold_to_BP_EmailVar= mapIdSapBpDB.get(spBpObjId).Email__c;
                            sold_to_BP_AddressVar = (String.isNotBlank(street) ? street +', ' : '') + (String.isNotBlank(city) ? city + ', ' : '') + (String.isNotBlank(state) ? state +', ' : '') + (String.isNotBlank(country) ? country+', ' : '') + (String.isNotBlank(zip) ? zip : '');
                            if(sold_to_BP_AddressVar.endsWith(',')){
                                sold_to_BP_AddressVar = sold_to_BP_AddressVar.removeEnd(',');
                            }
                            
                        }   
                        if(whichBp.equals('Payer_BP__c')){
                            payer_BP_nameVar = mapIdSapBpDB.get(spBpObjId).name;
                            payer_BP_IdVar = spBpObjId;
                            payer_BP_EmailVar= mapIdSapBpDB.get(spBpObjId).Email__c;
                            payer_BP_AddressVar = (String.isNotBlank(street) ? street +', ' : '') + (String.isNotBlank(city) ? city + ', ' : '') + (String.isNotBlank(state) ? state +', ' : '') + (String.isNotBlank(country) ? country+', ' : '') + (String.isNotBlank(zip) ? zip : '');
                            if(payer_BP_AddressVar.endsWith(', ')){
                                payer_BP_AddressVar = payer_BP_AddressVar.removeEnd(', ');
                            }  
                        }   
                    }
                }
                // create the wrraper obj 
                OppSapData oppSapDataObj = new  OppSapData( Bill_to_BP_nameVar,   Bill_to_BP_IdVar, bill_to_BP_EmailVar, bill_to_BP_AddressVar,
                                                           Ship_to_BP_nameVar,  Ship_to_BP_IdVar, ship_to_BP_EmailVar,ship_to_BP_AddressVar,
                                                           Sold_to_BP_nameVar,   Sold_to_BP_IdVar,  sold_to_BP_EmailVar,sold_to_BP_AddressVar,
                                                           Payer_BP_nameVar,   payer_BP_IdVar, payer_BP_EmailVar,  payer_BP_AddressVar );
                System.debug('oppSapDataObj-'+oppSapDataObj);
                return oppSapDataObj;
            }
            else {
                // create oppSapDataObj with null values
                return new oppSapData(  NULL ,NULL ,NULL ,NULL ,
                                      NULL ,NULL ,NULL ,NULL ,
                                      NULL ,NULL ,NULL ,NULL ,
                                      NULL ,NULL ,NULL ,NULL  ) ; 
            }
            
        }
        return NULL;
    }
    
    public class OppSapData{
        @AuraEnabled public String Bill_to_BP_name;
        @AuraEnabled public String Bill_to_BP_Id;
        @AuraEnabled public String bill_to_BP_Email;
        @AuraEnabled public String bill_to_BP_Address;
        
        @AuraEnabled public String Ship_to_BP_name;
        @AuraEnabled public String Ship_to_BP_Id;
        @AuraEnabled public String ship_to_BP_Email;
        @AuraEnabled public String ship_to_BP_Address;
        
        @AuraEnabled public String Sold_to_BP_name;
        @AuraEnabled public String Sold_to_BP_Id;
        @AuraEnabled public String sold_to_BP_Email;
        @AuraEnabled public String sold_to_BP_Address;
        
        @AuraEnabled public String Payer_BP_name;
        @AuraEnabled public String Payer_BP_Id;
        @AuraEnabled public String payer_BP_Email;
        @AuraEnabled public String payer_BP_Address;
        
        public OppSapData(String Bill_to_BP_nameVar,  String Bill_to_BP_IdVar, String bill_to_BP_EmailVar , String  bill_to_BP_AddressVar,
                          String Ship_to_BP_nameVar, String Ship_to_BP_IdVar ,String ship_to_BP_EmailVar, String  ship_to_BP_AddressVar ,
                          String Sold_to_BP_nameVar, String Sold_to_BP_IdVar , String sold_to_BP_EmailVar, String  sold_to_BP_AddressVar,
                          String Payer_BP_nameVar, String payer_BP_IdVar , String payer_BP_EmailVar, String  payer_BP_AddressVar )
        {
            Bill_to_BP_name  = Bill_to_BP_nameVar;
            Bill_to_BP_Id = Bill_to_BP_IdVar;
            bill_to_BP_Email = bill_to_BP_EmailVar;
            bill_to_BP_Address = bill_to_BP_AddressVar ;
            
            Ship_to_BP_name = Ship_to_BP_nameVar;
            Ship_to_BP_Id = Ship_to_BP_IdVar;
            ship_to_BP_Email = ship_to_BP_EmailVar ;
            ship_to_BP_Address = ship_to_BP_AddressVar;
            
            Sold_to_BP_name = Sold_to_BP_nameVar;
            Sold_to_BP_Id = Sold_to_BP_IdVar;
            sold_to_BP_Email = sold_to_BP_EmailVar;
            sold_to_BP_Address =  sold_to_BP_AddressVar;
            
            Payer_BP_name = Payer_BP_nameVar;
            Payer_BP_Id = payer_BP_IdVar;
            payer_BP_Email =  payer_BP_EmailVar;
            payer_BP_Address =  payer_BP_AddressVar;                                    
            
        }        
    }
    
    @AuraEnabled(cacheable=true)
    public static List<SObJectResult> getResults(String ObjectName, String fieldName, String value , Boolean isAccountForCampusDepart , Id accountIdForCampusDepartment, Boolean isSearchUnderAccount , Id conAccntId ) {
        List<SObJectResult> sObjectResultList = new List<SObJectResult>();
        system.debug(fieldName+'-------------'+ObjectName+'---++----------'+value);
        if(String.isNotEmpty(value)){
            value = String.escapeSingleQuotes(value.trim()); 
            // campus & department should be serached under account given       
            if ( isSearchUnderAccount && String.isNotBlank(accountIdForCampusDepartment) && ( ObjectName.equalsIgnoreCase('Campus__c') || ObjectName.equalsIgnoreCase('Department__c') ) ) {
                System.debug('query -'+'Select Id,'+fieldName+' FROM '+ObjectName+' WHERE '+fieldName+' LIKE \'%' + value + '%\'' +' AND Account__c = '+ accountIdForCampusDepartment );
                for(sObject so : Database.Query('Select Id,'+fieldName+' FROM '+ObjectName+' WHERE '+fieldName+' LIKE \'%' + value + '%\'' +' AND Account__c = :accountIdForCampusDepartment LIMIT 10')) { 
                    String fieldvalue = (String)so.get(fieldName);
                    sObjectResultList.add(new SObjectResult(fieldvalue, so.Id));
                }
            }
            else if ( ObjectName.equalsIgnoreCase('Contact') ) {
                System.debug('query-'+'Select Id,'+fieldName+' FROM '+ObjectName+' WHERE '+fieldName+' LIKE \'%' + value +  '%\'' + ' AND accountId = '+ '\''+ conAccntId + '\'' +' LIMIT 10' );
                for(sObject so : Database.Query('Select Id,'+fieldName+' FROM '+ObjectName+' WHERE '+fieldName+' LIKE \'%' + value +  '%\'' + ' AND accountId = '+ '\''+ conAccntId + '\'' +' LIMIT 10')) {
                    String fieldvalue = (String)so.get(fieldName);
                    sObjectResultList.add(new SObjectResult(fieldvalue, so.Id));
                }
            }           
            else {
                System.debug('query-'+'Select Id,'+fieldName+' FROM '+ObjectName+' WHERE '+fieldName+' LIKE \'%' + value + '%\'');
                for(sObject so : Database.Query('Select Id,'+fieldName+' FROM '+ObjectName+' WHERE '+fieldName+' LIKE \'%' + value + '%\' LIMIT 20')) {
                    String fieldvalue = (String)so.get(fieldName);
                    sObjectResultList.add(new SObjectResult(fieldvalue, so.Id));
                }    
            }            
        }
        return sObjectResultList;
    }
    
    public static List<String> splitStringBySpace(String str , integer charLimit){
        //string str = 'Returns a new String that begins with the character at the specified zero-based startIndex and extends to the character at endIndex - 1';
        List<String> listStr = new List<String>(); 
        string strSplit1 ='';
        string strSplit2 ='';
        string strSplit3 ='';
        system.debug('str-'+str);
        integer strLength = str.length();
        system.debug('strLength-'+strLength);
        string restStr ='';
        if(String.isNotBlank(str)){     
            
            // process for 1st variable
            if(str.length() < charLimit){
                strSplit1 = str;
                system.debug('strSplit1-'+strSplit1);
            }
            if (str.length() > charLimit){
                strSplit1  = str.substring(0,charLimit).substringBeforeLast(' ');  // till 39th char 
                restStr =  str.substring((strSplit1.length()) ,strLength);
                system.debug('strSplit1-'+strSplit1+' size-'+strSplit1.length());
                system.debug('restStr-'+restStr);
            }
            // process for 2nd variable
            if(restStr.length() < charLimit && String.isNotBlank(restStr)){
                strSplit2  = restStr;
                restStr = ''; // no string left to process
                system.debug('strSplit2-'+strSplit2+' size-'+strSplit2.length());
                system.debug('restStr-'+restStr);
            }
            if(restStr.length() > charLimit && String.isNotBlank(restStr)){
                strSplit2  = restStr.substring(0,charLimit).substringBeforeLast(' ');  // till 39th char 
                restStr =  restStr.substring((strSplit2.length() ),restStr.length());
                system.debug('strSplit2-'+strSplit2+' size-'+strSplit2.length());
                system.debug('restStr-'+restStr);
            }
            //  No need to process for 3rd variable
            strSplit3  = restStr;
            system.debug('strSplit3-'+strSplit3+' size-'+strSplit3.length());
            system.debug('restStr-'+restStr);
        }
        system.assertEquals(strSplit1+strSplit2+strSplit3,str );
        system.assertEquals((strSplit1.length()+strSplit2.length()+strSplit3.length()),str.length());
        listStr.add(strSplit1);
        listStr.add(strSplit2);
        listStr.add(strSplit3);
        return listStr;
    }
    
    public class SObJectResult {
        @AuraEnabled
        public String recName;
        @AuraEnabled
        public Id recId;
        
        public SObJectResult(String recNameTemp, Id recIdTemp) {
            recName = recNameTemp;
            recId = recIdTemp;
        }
    }       
}