/**
 * TF License Expose Service
 * Test class "zTest_TF_LicenseAPIExposeService"
 * Created by Vikas Varshney for LMS-189 on dated 7th August, 2019
 * Example Salesforce:-
 * 1) Endpoint (GET) = /services/apexrest/licenses/customer/100?status=Active&limit=10&offset=0
 * 2) Endpoint (GET) = /services/apexrest/licenses/multipleLicenses?Ids=a3K1l000000AlafEAC,a3K1l000000ARygEAG,a3K1l000000AQKtEAO,a3K1l000000AR2hEAG,a3K1l000000A5KtEAK,a3K1l000000AS1uEAG
 * 3) Endpoint (GET) = /services/apexrest/licenses/validateCollectionLicense?limit=10&partyId=12345,123456
 * 4) Endpoint (GET) = /services/apexrest/licenses/appliedCollectionCount/partyId/12345 //this api is not valid anymore
 * 5) Endpoint (GET) = /services/apexrest/licenses/getIndividualContacts?limit=10&offset=0
 * 6) Endpoint (POST) = /services/apexrest/licenses/fetchLicenseByIds
 * 7) Endpoint (POST) = /services/apexrest/licenses/postHasPartUpdate?type=update_dynamic_license
 * 8) Endpoint (GET) = /services/apexrest/licenses/getLicenseByOrganization?orgId=0011q00000P9KLrAAN&partyId=100&licenseId=a3K1l000000ARygEAG
 * Modified by Vikas Varshney for LMS-282 on dated 18th Sep, 2019
 * Modified by Vikas Varshney for LMS-300 on dated 24th Sep, 2019
 * Modified by Vikas Varshney for LMS-334 on dated 26th Sep, 2019
 * Modified by Vikas Varshney for LMS-299 on dated 1st Oct, 2019
 * Modified by Vikas Varshney for LMS-409 on dated 25th Oct, 2019
 * Modified by Vikas Varshney for LMS-412 on dated 8th Nov, 2019
 * Modified by Vikas Varshney for LMS-414 on dated 20th Nov, 2019
 * Modified by Vikas Varshney for LMS-441 on dated 7th Jan, 2020
 * Modified by Vikas Varshney for UBX-765 on dated 6th May, 2020
 * Modified by Vikas Varshney for UBX-764 on dated 18th May, 2020
 * Modified by Vikas Varshney for UBX-920 on dated 02nd June, 2020
 * Modified by Vikas Varshney for UBX-10649 on dated 20th August, 2020
 * Modified by Vikas Varshney for UBXC-1560 on dated 19th May, 2021 - CHG0048117
 * Modified by Vikas Varshney for UBXC-1732 on dated 7th June, 2021 - CHG0050604
 * Modified by Vikas Varshney for UBXC-1733 on dated 15th June, 2021 - CHG0050604
 * Modified by Vikas Varshney for UBXC-2013 on dated 21st July, 2021
 * Modified by Vikas Varshney for UBXC-2263 on dated 03rd Sep, 2021 - CHG0052518
 * Modified by Vikas Varshney for UBXC-2917 on dated 27th Oct, 2021 - CHG0052518 //https://api-uat.taylorfrancis.com/v3/sf/licenses/multipleLicenses?Ids=a3X1q0000009kfmEAA&partyId=102462
 * Modified by Vikas Varshney for UBXC-3087 on dated 02nd Dec, 2021 - CHG0052518
 **/

@RestResource(urlMapping='/licenses/*')
global class TF_LicenseAPIExposeService {
    public static ErrStrWrapper errObj = new ErrStrWrapper();
    
    // ***** Response object definition for partId *****
    global class LicenseExposeResponse {
        public Integer totalRecords;
        public String partyId;
        public List<Licenses> licenses;
    }
    
    public class Product {
        public String name;
        public String category;
    }
    
    public class Licenses {
        public String licenseId;
        public String customerId;
        public String contactId;
        public String licenseType;
        public List<String> grantType;
        public List<String> productBundles;
        public Product product;
        public String orderNumber;
        public String purchaseDate;
        public String licenseName;
        public String startDate;
        public String endDate;
        public String status;
        public String createdby;
        public String lastmodifiedBy;
        public String createdOn;
        public String lastmodifiedOn;
        public String partyId;
    }
    
    // ***** Response object definition for multiple license ids *****
    global class MultipleLicenseResponse {
        public List<LicenseIds> licenseIds;
    }
    
    public class LicenseIds {
        public String licenseId;
        public String customerId;
        public String contactId;
        public String licenseType;
        public List<String> grantType;
        public String productBundleId;
        public String productCategory;
        public String orderNumber;
        public String purchaseDate;
        public String licenseName;
        public String startDate;
        public String endDate;
        public String status;
        public String createdby;
        public String lastmodifiedBy;
        public String createdOn;
        public String lastmodifiedOn;
        public String partyId;
        public String productName;
        public String customerType;
        public String description;
        public List<licenseMembers> members;
    }
    
    public class licenseMembers {
        public String childName;
        public String childRingGoldId;
        public String childCustomerType;
    }
    
    public class CollectionResponse {
        public List<Data> data;
    }

    public class Data {
        public String partyId;
        public String collectionLicense;
    }
    
    public class ContactsOrderByName {
        public Integer total;
        public List<ContactInfo> contacts;
    }
    
    public class ContactInfo {
        public String name;
        public String email;
        public String partyId;
        public String customerType;
    }
    
    private Class FetchLicenseByIdsWrapper {
        private List<String> licenseIds;
    }
    
    public class HasPartResponse {
        public String message;
        
        public void setHasPartMessage(String message) {
            this.message = message;
        }
    }
    
    public class ErrStrWrapper {
        public String errStr;
    }
    
    // ----- Error Response object definition ------
    public class ErrorResponse {
        public String errorMessage;

        public void setError(String errorMessage) {
            this.errorMessage = errorMessage;
        }
    }
    
    public static ErrorResponse errorResp = new ErrorResponse();
    
    @HttpGet
    global static void doGet() {
        String result                   = '';
        String command                  = getCommand(RestContext.request.requestURI);
        String operation                = operationLookup('GET', command);
        Map<String, String> paramMap    = RestContext.request.params;
        
        errObj.errStr = 'GET : ' + RestContext.request.requestURI;
        
        if (paramMap.size() > 0) {
            errObj.errStr += '?';
            for (String str : paramMap.keySet()) {
                errObj.errStr += str + '=' + paramMap.get(str) + '&';
            }
        }
        errObj.errStr = errObj.errStr.removeEnd('&');
        
        if ( operation == 'getLicensesByPartyId' ) {
            result = getLicensesByPartyId(paramMap, command);
        } else if ( operation == 'getLicensesByMultipleIds' ) {
            result = getLicensesByMultipleIds(paramMap, command);
        } else if ( operation == 'getCollectionLicense' ) {
            result = getCollectionLicense(paramMap, command);
        } else if ( operation == 'getIndividualContacts' ) {
            result = getIndividualContacts(paramMap);
        } else if ( operation == 'getLicenseByOrganization' ) {
            result = getLicenseByOrganization(paramMap);
        } else {
            errorResp.setError('Invalid Resource');
            RestContext.response.statusCode = 400;
            result = JSON.serialize(errorResp);
        }
        
        if ( String.isNotBlank(result) ) {
            RestContext.response.responseBody = Blob.valueOf(result);
            RestContext.response.addHeader('Content-Type', 'application/json');
        }
    }
    
    @HttpPost
    global static void doPost() {
        String result                   = '';
        String command                  = getCommand(RestContext.request.requestURI);
        String operation                = operationLookup('POST', command);
        Blob postBody                   = RestContext.request.requestBody;
        Map<String, String> paramMap    = RestContext.request.params;
        
        errObj.errStr = 'POST : ' + RestContext.request.requestURI;
        
        if ( operation == 'fetchLicenseByIds' ) {
            result = fetchLicenseByIds( postBody );
        } else if ( 'postHasPartUpdate'.equalsIgnoreCase(operation) ) {
            result = postHasPartUpdate( paramMap, postBody );
        } else {
            errorResp.setError('Invalid Resource');
            RestContext.response.statusCode = 400;
            result = JSON.serialize(errorResp);
        }
        
        RestContext.response.responseBody = Blob.valueOf(result);
        RestContext.response.addHeader('Content-Type', 'application/json');
    }
    
    private static String getLicensesByPartyId ( Map<String, String> paramsMap, String commandURI ) {
        LicenseExposeResponse response = new LicenseExposeResponse();
        
        try {
            String licPartyId = '';
            
            if ( String.isNotBlank(commandURI) )
                licPartyId = commandURI.remove('customer/');
            
            if ( String.isBlank(licPartyId) ) {
                errorResp.setError('Party Id can\'t be empty');
                RestContext.response.statusCode = 400;
                return JSON.serialize(errorResp);
            } else {
                Account acc = new Account();
                //Checking party id exist in SF or not
                try {
                    acc = [ SELECT id, customer_Id__c FROM Account WHERE customer_Id__c =:licPartyId LIMIT 1 ];
                } catch ( Exception ex ) {
                    if ( acc.id == NULL ) {
                        try {
                            Contact con = new Contact();
                            con = [ SELECT id, party_Id__c FROM Contact WHERE party_Id__c =:licPartyId LIMIT 1 ];
                        } catch ( Exception e ) {
                            errorResp.setError('Party Id does not exist');
                            RestContext.response.statusCode = 404;
                            return JSON.serialize(errorResp);
                        }
                    }
                }
                List<License__c> licenseList = new List<License__c>();
                Set<String> statusSet = new Set<String>();
                if ( paramsMap.isEmpty() ) {
                    errorResp.setError('Status param mandatory');
                    RestContext.response.statusCode = 400;
                    return JSON.serialize(errorResp);
                } else if ( String.isBlank(paramsMap.get('status')) ) {
                    errorResp.setError('Status param can\'t be blank');
                    RestContext.response.statusCode = 400;
                    return JSON.serialize(errorResp);
                } else if ( String.isNotBlank(paramsMap.get('status')) ) {
                    String statusParam = paramsMap.get('status').toUpperCase();
                    statusParam = statusParam.deleteWhitespace();
                    Set<String> paramStatusSet = new Set<String>();
                    String paramStatusVal = statusParam.toUpperCase();
                    if ( statusParam.contains(',') ) {
                        List<String> statusSplitList = new List<String>();
                        statusSplitList = paramStatusVal.split(',');
                        paramStatusSet.addAll( statusSplitList );
                    } else {
                        paramStatusSet.add(paramStatusVal);
                    }
                    Set<String> statusPickListValuesSet = new Set<String>();
                    statusPickListValuesSet.add('ALL');
                    
                    Schema.DescribeFieldResult fieldResult = License__c.Status__c.getDescribe();
                    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                    for( Schema.PicklistEntry pickListVal : ple){
                        String str = pickListVal.getValue().toUpperCase();
                        if ( !(str.containsIgnoreCase('License created successfully')) ) {
                            str = str.deleteWhitespace();
                            statusPickListValuesSet.add(str);
                        }
                        statusSet.add(pickListVal.getValue());
                    }
                    
                    if ( paramStatusSet.size() > 1 && paramStatusSet.contains('ALL') ) {
                        errorResp.setError('Status param \'All\' should not come along with another value');
                        RestContext.response.statusCode = 400;
                        return JSON.serialize(errorResp);
                    }

                    //if ( !statusPickListValuesSet.contains(statusParam) && !statusParam.equalsIgnoreCase('All') ) {
                    if ( !statusPickListValuesSet.containsAll(paramStatusSet) ) {
                        errorResp.setError('Status value does not exist in Salesforce since the value provided is not one of All,Active,Expired,InProgress or Deactivated');
                        RestContext.response.statusCode = 404;
                        return JSON.serialize(errorResp);
                    }
                    
                    Integer offsetVar = 0; //Initializing OFFSET
                    if ( !paramsMap.isEmpty() && ( !paramsMap.containsKey('offset') || String.isBlank(paramsMap.get('offset')) ) ) {
                        errorResp.setError('Provide offset parameter value');
                        RestContext.response.statusCode = 400;
                        return JSON.serialize(errorResp);
                    }
                    
                    if ( !paramsMap.get('limit').isNumeric() ) { //checking for correct endpoint
                        errorResp.setError('Provide the numeric limit');
                        RestContext.response.statusCode = 400;
                        return JSON.serialize(errorResp);
                    }
                    
                    if ( !paramsMap.get('offset').isNumeric() ) { //checking for correct endpoint
                        errorResp.setError('Provide the numeric offset');
                        RestContext.response.statusCode = 400;
                        return JSON.serialize(errorResp);
                    }
                    
                    if ( !paramsMap.isEmpty() && paramsMap.containsKey('offset') && String.isNotBlank(paramsMap.get( 'offset' )) ) { //Initializing OFFSET dynamically from request
                        offsetVar = Integer.valueOf(paramsMap.get( 'offset' ));
                    }
                    
                    Integer soqlLimit = 10; //Initializing query LIMIT
                    if ( paramsMap.containsKey('limit') && String.isNotBlank(paramsMap.get( 'limit' )) ) { //Initializing LIMIT dynamically from request
                        soqlLimit = Integer.valueOf(paramsMap.get( 'limit' ));
                    }
                    
                    //UBX-10649
                    Set<Id> licIdsSet = new Set<Id>();
                    for (License_Memeber__c licMember : [ SELECT License__c FROM License_Memeber__c WHERE Account__r.customer_Id__c =:licPartyId ]) {
                        licIdsSet.add(licMember.License__c);
                    }
                    
                    Integer totalLicenseRecrds;
                    if ( statusParam.equalsIgnoreCase('All') ) {
                        totalLicenseRecrds = [ SELECT count() FROM License__c WHERE (id IN:licIdsSet OR (customer__r.customer_Id__c =:licPartyId OR contact__r.Party_Id__c =:licPartyId)) AND Status__c IN:statusSet ];
                        response.totalRecords = totalLicenseRecrds;
                    } else if ( statusParam.equalsIgnoreCase('InProgress') ) {
                        totalLicenseRecrds = [ SELECT count() FROM License__c WHERE (id IN:licIdsSet OR (customer__r.customer_Id__c =:licPartyId OR contact__r.Party_Id__c =:licPartyId)) AND Status__c != 'Active' AND Status__c != 'Expired' AND Status__c != 'Deactivated' AND Status__c != 'Inactive' ];
                        response.totalRecords = totalLicenseRecrds;
                    } else {
                        //totalLicenseRecrds = [ SELECT count() FROM License__c WHERE (customer__r.customer_Id__c =:licPartyId OR contact__r.Party_Id__c =:licPartyId) AND Status__c =:paramsMap.get('status') ];
                        if ( paramStatusSet.contains('INPROGRESS') ) {
                            paramStatusSet.remove('INPROGRESS');
                            paramStatusSet.add('In progress');
                            for ( String licStatus : statusSet ) {
                                if ( licStatus.containsIgnoreCase('License created successfully') ) {
                                    paramStatusSet.add(licStatus);
                                }
                            }
                        }
                        totalLicenseRecrds = [ SELECT count() FROM License__c WHERE (id IN:licIdsSet OR (customer__r.customer_Id__c =:licPartyId OR contact__r.Party_Id__c =:licPartyId)) AND Status__c IN:paramStatusSet ];
                        response.totalRecords = totalLicenseRecrds;
                    }
                    
                    if ( totalLicenseRecrds == 0 ) {
                        errorResp.setError('No records found with status ' + paramsMap.get('status'));
                        RestContext.response.statusCode = 404;
                        return JSON.serialize(errorResp);
                    }
                    
                    if ( offsetVar >= totalLicenseRecrds ) {
                        errorResp.setError('Offset should be less than total records = '+totalLicenseRecrds);
                        RestContext.response.statusCode = 400;
                        return JSON.serialize(errorResp);
                    }
                    
                    if ( offsetVar > 2000 ) {
                        errorResp.setError('Offset should be less than 2000');
                        RestContext.response.statusCode = 400;
                        return JSON.serialize(errorResp);
                    }
                    
                    //First all active licenses (including in progress) will be shown, with recently updated license coming first, then Deactivated licenses will show up and at the end all expired licenses will be shown
                    if ( statusParam.equalsIgnoreCase('All') ) {
                        //licenseList = [ SELECT id, name, customer__c, customer__r.Name, customer__r.customer_Id__c, contact__c, contact__r.Name, contact__r.party_Id__c, License_Type__c, Grant_Type__c, Product__c, Product__r.Hub_Id__c, Order_Number__c, Purchase_Date__c, Start_Date__c, End_Date__c, Status__c, createdById, CreatedDate, createdBy.Name, lastModifiedById, LastModifiedDate, lastModifiedBy.Name FROM License__c WHERE customer__r.customer_Id__c =:licPartyId OR contact__r.Party_Id__c =:licPartyId ORDER BY LastModifiedDate ASC NULLS LAST LIMIT :soqlLimit OFFSET :offsetVar ];
                        List<License__c> activeLicenseList = new List<License__c>();
                        //List<License__c> inprogressLicenseList = new List<License__c>();
                        List<License__c> deactivatedLicenseList = new List<License__c>();
                        List<License__c> expiredLicenseList = new List<License__c>();
                        Set<String> activeStatusSet = new Set<String>(); //= 'Active' OR Status__c = 'In progress'
                        activeStatusSet.addAll(statusSet);
                        activeStatusSet.remove('Expired');
                        activeStatusSet.remove('Deactivated');
                        
                        //this soql is to fetch all active licenses (including in progress)
                        activeLicenseList = [ SELECT id, name, customer__c, customer__r.Name, customer__r.customer_Id__c, contact__c, contact__r.Name, contact__r.party_Id__c, License_Type__c, Grant_Type__c, Product__c, Product__r.Hub_Id__c, Product__r.name, Product__r.Product_Category__c, Order_Number__c, Purchase_Date__c, Start_Date__c, End_Date__c, Status__c, createdById, CreatedDate, createdBy.Name, lastModifiedById, LastModifiedDate, lastModifiedBy.Name FROM License__c WHERE (id IN:licIdsSet OR (customer__r.customer_Id__c =:licPartyId OR contact__r.Party_Id__c =:licPartyId)) AND Status__c IN:activeStatusSet ORDER BY LastModifiedDate DESC NULLS LAST LIMIT :soqlLimit OFFSET :offsetVar ];
                        licenseList.addAll(activeLicenseList);

                        if ( licenseList.size() < soqlLimit ) { //this block is to fetch deactivated licenses
                            Integer deactivatedSoqlLimit = ( soqlLimit - licenseList.size() );
                            Integer deactivatedOffsetVar = 0;
                            Integer activeCount = 0;
                            
                            if ( activeLicenseList.isEmpty() ) {
                                activeCount = [ SELECT count() FROM License__c WHERE (id IN:licIdsSet OR (customer__r.customer_Id__c =:licPartyId OR contact__r.Party_Id__c =:licPartyId)) AND Status__c IN:activeStatusSet ];
                                deactivatedOffsetVar = Math.abs(offsetVar - activeCount);
                            }
                            deactivatedLicenseList = [ SELECT id, name, customer__c, customer__r.Name, customer__r.customer_Id__c, contact__c, contact__r.Name, contact__r.party_Id__c, License_Type__c, Grant_Type__c, Product__c, Product__r.Hub_Id__c, Product__r.name, Product__r.Product_Category__c, Order_Number__c, Purchase_Date__c, Start_Date__c, End_Date__c, Status__c, createdById, CreatedDate, createdBy.Name, lastModifiedById, LastModifiedDate, lastModifiedBy.Name FROM License__c WHERE (id IN:licIdsSet OR (customer__r.customer_Id__c =:licPartyId OR contact__r.Party_Id__c =:licPartyId)) AND Status__c = 'Deactivated' ORDER BY LastModifiedDate DESC NULLS LAST LIMIT :deactivatedSoqlLimit OFFSET :deactivatedOffsetVar ];
                            licenseList.addAll(deactivatedLicenseList);
                        }
                        
                        if ( licenseList.size() < soqlLimit ) { //this block is to fetch expired licenses
                            Integer expiredSoqlLimit = ( soqlLimit - licenseList.size() );
                            Integer expiredOffsetVar = 0;
                            Integer deactivatedCount = 0;
                            
                            if ( deactivatedLicenseList.isEmpty() && activeLicenseList.isEmpty() ) {
                                Set<String> deactivatedCountSet = new Set<String>();
                                deactivatedCountSet.addAll(activeStatusSet);
                                deactivatedCountSet.add('Deactivated');
                                deactivatedCount = [ SELECT count() FROM License__c WHERE (id IN:licIdsSet OR (customer__r.customer_Id__c =:licPartyId OR contact__r.Party_Id__c =:licPartyId)) AND Status__c IN:deactivatedCountSet ];
                                expiredOffsetVar = Math.abs(offsetVar - deactivatedCount);
                            }
                            expiredLicenseList = [ SELECT id, name, customer__c, customer__r.Name, customer__r.customer_Id__c, contact__c, contact__r.Name, contact__r.party_Id__c, License_Type__c, Grant_Type__c, Product__c, Product__r.Hub_Id__c, Product__r.name, Product__r.Product_Category__c, Order_Number__c, Purchase_Date__c, Start_Date__c, End_Date__c, Status__c, createdById, CreatedDate, createdBy.Name, lastModifiedById, LastModifiedDate, lastModifiedBy.Name FROM License__c WHERE (id IN:licIdsSet OR (customer__r.customer_Id__c =:licPartyId OR contact__r.Party_Id__c =:licPartyId)) AND Status__c = 'Expired' ORDER BY LastModifiedDate DESC NULLS LAST LIMIT :expiredSoqlLimit OFFSET :expiredOffsetVar ];
                            licenseList.addAll(expiredLicenseList);
                        }
                    } else if ( statusParam.equalsIgnoreCase('InProgress') ) {
                        licenseList = [ SELECT id, name, customer__c, customer__r.Name, customer__r.customer_Id__c, contact__c, contact__r.Name, contact__r.party_Id__c, License_Type__c, Grant_Type__c, Product__c, Product__r.Hub_Id__c, Product__r.name, Product__r.Product_Category__c, Order_Number__c, Purchase_Date__c, Start_Date__c, End_Date__c, Status__c, createdById, CreatedDate, createdBy.Name, lastModifiedById, LastModifiedDate, lastModifiedBy.Name FROM License__c WHERE (id IN:licIdsSet OR (customer__r.customer_Id__c =:licPartyId OR contact__r.Party_Id__c =:licPartyId)) AND Status__c != 'Active' AND Status__c != 'Expired' AND Status__c != 'Deactivated' AND Status__c != 'Inactive' ORDER BY LastModifiedDate DESC NULLS LAST LIMIT :soqlLimit OFFSET :offsetVar ];
                    } else {
                        //if (true)
                            //return JSON.serialize(paramStatusSet);
                        //licenseList = [ SELECT id, name, customer__c, customer__r.Name, customer__r.customer_Id__c, contact__c, contact__r.Name, contact__r.party_Id__c, License_Type__c, Grant_Type__c, Product__c, Product__r.Hub_Id__c, Order_Number__c, Purchase_Date__c, Start_Date__c, End_Date__c, Status__c, createdById, CreatedDate, createdBy.Name, lastModifiedById, LastModifiedDate, lastModifiedBy.Name FROM License__c WHERE (customer__r.customer_Id__c =:licPartyId OR contact__r.Party_Id__c =:licPartyId) AND Status__c IN:paramStatusSet ORDER BY LastModifiedDate DESC NULLS LAST LIMIT :soqlLimit OFFSET :offsetVar ];
                        List<License__c> activeLicenseList = new List<License__c>();
                        List<License__c> deactivatedLicenseList = new List<License__c>();
                        List<License__c> expiredLicenseList = new List<License__c>();
                        Set<String> activeStatusSet = new Set<String>(); //= 'Active' OR Status__c = 'In progress'
                        
                        if ( paramStatusSet.contains('ACTIVE') ) {
                            activeStatusSet.addAll(paramStatusSet);
                            activeStatusSet.remove('EXPIRED');
                            activeStatusSet.remove('DEACTIVATED');
                            
                            //this soql is to fetch all active licenses (including in progress)
                            activeLicenseList = [ SELECT id, name, customer__c, customer__r.Name, customer__r.customer_Id__c, contact__c, contact__r.Name, contact__r.party_Id__c, License_Type__c, Grant_Type__c, Product__c, Product__r.Hub_Id__c, Product__r.name, Product__r.Product_Category__c, Order_Number__c, Purchase_Date__c, Start_Date__c, End_Date__c, Status__c, createdById, CreatedDate, createdBy.Name, lastModifiedById, LastModifiedDate, lastModifiedBy.Name FROM License__c WHERE (id IN:licIdsSet OR (customer__r.customer_Id__c =:licPartyId OR contact__r.Party_Id__c =:licPartyId)) AND Status__c IN:activeStatusSet ORDER BY LastModifiedDate DESC NULLS LAST LIMIT :soqlLimit OFFSET :offsetVar ];
                            licenseList.addAll(activeLicenseList);
                        }

                        if ( licenseList.size() < soqlLimit && paramStatusSet.contains('DEACTIVATED') ) { //this block is to fetch deactivated licenses
                            Integer deactivatedSoqlLimit = ( soqlLimit - licenseList.size() );
                            Integer deactivatedOffsetVar = 0;
                            Integer activeCount = 0;
                            
                            if ( activeLicenseList.isEmpty() && paramStatusSet.contains('ACTIVE') ) {
                                activeCount = [ SELECT count() FROM License__c WHERE (id IN:licIdsSet OR (customer__r.customer_Id__c =:licPartyId OR contact__r.Party_Id__c =:licPartyId)) AND Status__c IN:activeStatusSet ];
                                deactivatedOffsetVar = Math.abs(offsetVar - activeCount);
                            }
                            deactivatedLicenseList = [ SELECT id, name, customer__c, customer__r.Name, customer__r.customer_Id__c, contact__c, contact__r.Name, contact__r.party_Id__c, License_Type__c, Grant_Type__c, Product__c, Product__r.Hub_Id__c, Product__r.name, Product__r.Product_Category__c, Order_Number__c, Purchase_Date__c, Start_Date__c, End_Date__c, Status__c, createdById, CreatedDate, createdBy.Name, lastModifiedById, LastModifiedDate, lastModifiedBy.Name FROM License__c WHERE (id IN:licIdsSet OR (customer__r.customer_Id__c =:licPartyId OR contact__r.Party_Id__c =:licPartyId)) AND Status__c = 'Deactivated' ORDER BY LastModifiedDate DESC NULLS LAST LIMIT :deactivatedSoqlLimit OFFSET :deactivatedOffsetVar ];
                            licenseList.addAll(deactivatedLicenseList);
                        }
                        
                        if ( licenseList.size() < soqlLimit && paramStatusSet.contains('EXPIRED') ) { //this block is to fetch expired licenses
                            Integer expiredSoqlLimit = ( soqlLimit - licenseList.size() );
                            Integer expiredOffsetVar = 0;
                            Integer deactivatedCount = 0;
                            
                            if ( deactivatedLicenseList.isEmpty() && activeLicenseList.isEmpty() && paramStatusSet.contains('DEACTIVATED') ) {
                                Set<String> deactivatedCountSet = new Set<String>();
                                deactivatedCountSet.addAll(activeStatusSet);
                                deactivatedCountSet.add('Deactivated');
                                deactivatedCount = [ SELECT count() FROM License__c WHERE (id IN:licIdsSet OR (customer__r.customer_Id__c =:licPartyId OR contact__r.Party_Id__c =:licPartyId)) AND Status__c IN:deactivatedCountSet ];
                                expiredOffsetVar = Math.abs(offsetVar - deactivatedCount);
                            }
                            expiredLicenseList = [ SELECT id, name, customer__c, customer__r.Name, customer__r.customer_Id__c, contact__c, contact__r.Name, contact__r.party_Id__c, License_Type__c, Grant_Type__c, Product__c, Product__r.name, Product__r.Hub_Id__c, Product__r.Product_Category__c, Order_Number__c, Purchase_Date__c, Start_Date__c, End_Date__c, Status__c, createdById, CreatedDate, createdBy.Name, lastModifiedById, LastModifiedDate, lastModifiedBy.Name FROM License__c WHERE (id IN:licIdsSet OR (customer__r.customer_Id__c =:licPartyId OR contact__r.Party_Id__c =:licPartyId)) AND Status__c = 'Expired' ORDER BY LastModifiedDate DESC NULLS LAST LIMIT :expiredSoqlLimit OFFSET :expiredOffsetVar ];
                            licenseList.addAll(expiredLicenseList);
                        }
                    }
                }

                response.partyId = licPartyId;
                response.licenses = new List<Licenses>();
                
                Set<Id> licTestSet = new Set<Id>();
                if ( !licenseList.isEmpty() ) {
                    for ( License__c lic : licenseList ) {
                        List<String> grantList = new List<String>();
                        
                        if ( lic.Grant_Type__c != NULL ) {
                            if ( lic.Grant_Type__c.contains(';') )
                                grantList = lic.Grant_Type__c.split(';');
                            else
                                grantList.add( lic.Grant_Type__c );
                        }
                        
                        //Creating product bundle list
                        List<String> bundleIdList = new List<String>();
                        if ( lic.Product__c != NULL && lic.Product__r.Hub_Id__c != NULL ) {
                            bundleIdList.add(String.valueOf( lic.Product__r.Hub_Id__c ));
                        }
                        
                        Product productWrap = new Product();
                        if ( lic.Product__c != NULL ) {
                            productWrap.name = lic.Product__r.name;
                            productWrap.category = String.isNotBlank(lic.Product__r.Product_Category__c) ? lic.Product__r.Product_Category__c : '';
                        }
                        
                        Licenses license = new Licenses();
                        license.licenseId = String.valueOf( lic.id );
                        license.customerId = lic.customer__c != NULL ? String.valueOf( lic.customer__c ) : '';
                        license.contactId = lic.contact__c != NULL ? String.valueOf( lic.contact__c ) : '';
                        license.licenseType = String.isNotBlank(lic.License_Type__c) ? lic.License_Type__c : '';
                        license.grantType = grantList;
                        license.productBundles = new List<String>();
                        if ( !bundleIdList.isEmpty() ) {
                            license.productBundles.addAll( bundleIdList );
                        }
                        license.product = productWrap; //UBXC-1732
                        license.orderNumber = String.isNotBlank(lic.Order_Number__c) ? lic.Order_Number__c : '';
                        license.purchaseDate = lic.Purchase_Date__c != NULL ? String.valueOf( lic.Purchase_Date__c ) : '';
                        license.licenseName = lic.name;
                        license.startDate = lic.Start_Date__c != NULL ? String.valueOf( lic.Start_Date__c ) : '';
                        license.endDate = lic.End_Date__c != NULL ? String.valueOf( lic.End_Date__c ) : '';
                        license.status = String.isNotBlank(lic.Status__c) ? lic.Status__c : '';
                        license.createdby = String.valueOf( lic.createdBy.Name );
                        license.lastmodifiedBy = String.valueOf( lic.lastModifiedBy.Name );
                        license.createdOn = String.valueOf( lic.CreatedDate );
                        license.lastmodifiedOn = String.valueOf( lic.LastModifiedDate );
                        license.partyId = ( ( lic.customer__c != NULL && String.isNotBlank(lic.customer__r.customer_Id__c) ? String.valueOf(lic.customer__r.customer_Id__c) : ( ( lic.contact__c != NULL && String.isNotBlank(lic.contact__r.party_Id__c) ) ? String.valueOf(lic.contact__r.party_Id__c) : '') ) );
                        response.licenses.add( license );
                        licTestSet.add( lic.id );
                    }
                }
            }
        } catch ( Exception ex ) {
            String emailFailureMsg = System.Url.getSalesforceBaseUrl().getHost() + ' Webservice TF_LicenseAPIExposeService.getLicensesByPartyId is failing. ' + ex.getMessage() + ', Line : ' + ex.getLineNumber() + '-------' + errObj.errStr;
            //mail notification
            emailFailure(emailFailureMsg);
            //Logging an exception
            apiExceptionLog('getLicensesByPartyId', (ex.getMessage() + ', Line : ' + ex.getLineNumber()), (ex.getTypeName() + ', Line : ' + ex.getLineNumber()), errObj.errStr);
            errorResp.setError('Internal server error');
            RestContext.response.statusCode = 500;
            
            return JSON.serialize(errorResp);
        }
        
        return JSON.serialize(response);
    }
    
    private static String getLicensesByMultipleIds ( Map<String, String> paramsMap, String commandURI ) {
        MultipleLicenseResponse response = new MultipleLicenseResponse();
        response.licenseIds = new List<LicenseIds>();
        
        try {
            if ( 'multipleLicenses'.equalsIgnoreCase(commandURI) ) {
                Set<String> licenseIdsSet = new Set<String>();
                Map<Id, License__c> licenseIdToLicenseMap;
                Set<String> availbaleLicIdSet = new Set<String>();
                
                if ( !paramsMap.isEmpty() && paramsMap.containsKey('Ids') ) {
                    List<String> licIdsList = new List<String>();
                    if ( String.isBlank(paramsMap.get('Ids')) ) {
                        errorResp.setError('License Ids not provided');
                        RestContext.response.statusCode = 400;
                        return JSON.serialize(errorResp);
                    } else if ( paramsMap.get('Ids').contains(',') ) {
                        licIdsList = paramsMap.get('Ids').split(',');
                        licenseIdsSet.addAll( licIdsList );
                    } else if ( !paramsMap.get('Ids').contains(',') ) {
                        licIdsList.add( paramsMap.get('Ids') );
                        licenseIdsSet.addAll( licIdsList );
                    }
                } else {
                    errorResp.setError('License Ids not provided');
                    RestContext.response.statusCode = 400;
                    return JSON.serialize(errorResp);
                }
                
                if ( !licenseIdsSet.isEmpty() ) {
                    if ( licenseIdsSet.size() == 1 && paramsMap.containsKey('partyId') ) { //UBXC-2917
                        try {
                            List<License__c> licReccList = new List<License__c>();
                            licReccList = [ Select id FROM License__c WHERE Id IN:licenseIdsSet AND ( customer__r.customer_Id__c =:paramsMap.get('partyId') OR contact__r.party_Id__c =:paramsMap.get('partyId') ) LIMIT 1 ];
                            
                            if ( licReccList.size() == 0 ) {
                                List<License_Memeber__c> licMemberList = new List<License_Memeber__c>(); //UBXC-3087
                                licMemberList = [ SELECT id, License__c, License__r.Name, Account__c, Account__r.Type, Account__r.customer_Id__c FROM License_Memeber__c WHERE License__c IN:licenseIdsSet AND Account__r.customer_Id__c =:paramsMap.get('partyId') LIMIT 1 ];
                                
                                if ( licMemberList.size() == 0 ) {
                                    errorResp.setError('Not found.');
                                    RestContext.response.statusCode = 404;
                                    return JSON.serialize(errorResp);
                                }
                            }
                        } catch ( Exception ex ) {
                            errorResp.setError('Internal Server Error');
                            RestContext.response.statusCode = 500;
                            return JSON.serialize(errorResp);
                        }
                    }
                    
                    if ( licenseIdsSet.size() > 10 ) {
                        errorResp.setError('Only 10 license ids can be passed');
                        RestContext.response.statusCode = 400;
                        return JSON.serialize(errorResp);
                    }
                    
                    try {
                        licenseIdToLicenseMap = new Map<Id, License__c>( [ SELECT id, name, customer__c, customer__r.Name, customer__r.customer_Id__c, customer__r.Type, contact__c, contact__r.Name, contact__r.party_Id__c, License_Type__c, Grant_Type__c, Product__c, Product__r.Hub_Id__c, Product__r.name, Product__r.Product_Category__c, Description__c, Order_Number__c, Purchase_Date__c, Start_Date__c, End_Date__c, Status__c, createdById, CreatedDate, createdBy.Name, lastModifiedById, LastModifiedDate, lastModifiedBy.Name, ( SELECT id, Account__c, Account__r.Type, Account__r.Name, Account__r.Ringgold_Account_ID__c FROM License_Memebers__r ) FROM License__c WHERE Id IN:licenseIdsSet ] );
                        for ( Id licId : licenseIdToLicenseMap.keySet() ) {
                            availbaleLicIdSet.add(licId);
                        }
                    } catch ( Exception ex ) {
                        String emailFailureMsg = System.Url.getSalesforceBaseUrl().getHost() + ' Webservice TF_LicenseAPIExposeService.getLicensesByMultipleIds is failing. ' + ex.getMessage() + ', Line : ' + ex.getLineNumber() + '-------' + errObj.errStr;
                        emailFailure(emailFailureMsg);
                        apiExceptionLog('getLicensesByMultipleIds', (ex.getMessage() + ', Line : ' + ex.getLineNumber()), (ex.getTypeName() + ', Line : ' + ex.getLineNumber()), errObj.errStr);
                        licenseIdToLicenseMap = new Map<Id, License__c>();
                        errorResp.setError(ex.getMessage());
                        RestContext.response.statusCode = 500;
                        return JSON.serialize(errorResp);
                    }
                    
                    List<LicenseIds> licrecordList = new List<LicenseIds>();
                    for ( String licId : licenseIdsSet ) {
                        if ( !availbaleLicIdSet.contains( licId ) ) {
                            LicenseIds licensRecord = new LicenseIds();
                            licensRecord.licenseId = 'License Id ' + String.valueOf( licId ) + ' not exist in Database';
                            licrecordList.add( licensRecord );
                        }
                    }

                    if ( !licenseIdToLicenseMap.isEmpty() ) {
                        for ( License__c lic : licenseIdToLicenseMap.values() ) {
                            List<String> grantList = new List<String>();
                        
                            if ( lic.Grant_Type__c != NULL ) {
                                if ( lic.Grant_Type__c.contains(';') )
                                    grantList = lic.Grant_Type__c.split(';');
                                else
                                    grantList.add( lic.Grant_Type__c );
                            }
                            
                            LicenseIds licenseRecord = new LicenseIds();
                            licenseRecord.licenseId = String.valueOf( lic.id );
                            licenseRecord.customerId = lic.customer__c != NULL ? String.valueOf( lic.customer__c ) : '';
                            licenseRecord.contactId = lic.contact__c != NULL ? String.valueOf( lic.contact__c ) : '';
                            licenseRecord.licenseType = String.isNotBlank(lic.License_Type__c) ? lic.License_Type__c : '';
                            licenseRecord.grantType = grantList;
                            licenseRecord.productBundleId = ( lic.Product__c != NULL && lic.Product__r.Hub_Id__c != NULL ) ? String.valueOf( lic.Product__r.Hub_Id__c ) : '';
                            licenseRecord.productCategory = ( lic.Product__r.Product_Category__c != NULL ) ? String.valueOf( lic.Product__r.Product_Category__c ) : ''; //UBXC-1733
                            licenseRecord.orderNumber = String.isNotBlank(lic.Order_Number__c) ? lic.Order_Number__c : '';
                            licenseRecord.purchaseDate = lic.Purchase_Date__c != NULL ? String.valueOf( lic.Purchase_Date__c ) : '';
                            licenseRecord.licenseName = lic.name;
                            licenseRecord.startDate = lic.Start_Date__c != NULL ? String.valueOf( lic.Start_Date__c ) : '';
                            licenseRecord.endDate = lic.End_Date__c != NULL ? String.valueOf( lic.End_Date__c ) : '';
                            licenseRecord.status = String.isNotBlank(lic.Status__c) ? lic.Status__c : '';
                            licenseRecord.createdby = String.valueOf( lic.createdBy.Name );
                            licenseRecord.lastmodifiedBy = String.valueOf( lic.lastModifiedBy.Name );
                            licenseRecord.createdOn = String.valueOf( lic.CreatedDate );
                            licenseRecord.lastmodifiedOn = String.valueOf( lic.LastModifiedDate );
                            licenseRecord.partyId = ( ( lic.customer__c != NULL && String.isNotBlank(lic.customer__r.customer_Id__c) ? String.valueOf(lic.customer__r.customer_Id__c) : ( ( lic.contact__c != NULL && String.isNotBlank(lic.contact__r.party_Id__c) ) ? String.valueOf(lic.contact__r.party_Id__c) : '') ) );
                            licenseRecord.productName = lic.Product__c != NULL ? lic.Product__r.name : '';
                            licenseRecord.customerType = ( lic.customer__c != NULL && lic.customer__r.Type != NULL && lic.customer__r.Type.equalsIgnoreCase('Consortium') ) ? 'Consortium' : ( ( lic.customer__c != NULL && lic.customer__r.Type != NULL && !lic.customer__r.Type.equalsIgnoreCase('Consortium') ? 'Institute' : ( ( lic.Contact__c != NULL ) ? 'Individual' : '' ) ) );
                            licenseRecord.description = lic.Description__c != NULL ? lic.Description__c : '';
                            licenseRecord.members = new List<licenseMembers>();
                            if ( licenseRecord.customerType.equalsIgnoreCase('Consortium') ) {
                                if ( !lic.License_Memebers__r.isEmpty() ) {
                                    for ( License_Memeber__c licMember : lic.License_Memebers__r ) {
                                        licenseMembers licMemberRecord = new licenseMembers();
                                        licMemberRecord.childName = licMember.Account__r.Name;
                                        licMemberRecord.childRingGoldId = String.isNotBlank(licMember.Account__r.Ringgold_Account_ID__c) ? licMember.Account__r.Ringgold_Account_ID__c : '' ;
                                        licMemberRecord.childCustomerType = String.isNotBlank(licMember.Account__r.Type) ? licMember.Account__r.Type : '';
                                        licenseRecord.members.add(licMemberRecord);
                                    }
                                }
                            }
                            response.licenseIds.add( licenseRecord );
                        }
                    }
                    
                    if ( !licrecordList.isEmpty() ) {
                        response.licenseIds.addAll( licrecordList );
                    }
                    RestContext.response.statusCode = 200;
                } else {
                    errorResp.setError('License Ids not provided');
                    RestContext.response.statusCode = 400;
                    return JSON.serialize(errorResp);
                }
            }
        } catch ( Exception ex ) {
            String emailFailureMsg = System.Url.getSalesforceBaseUrl().getHost() + ' Webservice TF_LicenseAPIExposeService.getLicensesByMultipleIds is failing. ' + ex.getMessage() + ', Line : ' + ex.getLineNumber() + '-------' + errObj.errStr;
            emailFailure(emailFailureMsg);
            apiExceptionLog('getLicensesByMultipleIds', (ex.getMessage() + ', Line : ' + ex.getLineNumber()), (ex.getTypeName() + ', Line : ' + ex.getLineNumber()), errObj.errStr);
            errorResp.setError('Internal server error');
            RestContext.response.statusCode = 500;
            return JSON.serialize(errorResp);
        }
        
        return JSON.serialize(response);
    }
    
    //API method to validate party Id has license or not for consortium, institue and individual
    //Collection license means whether party id passed having any license in Salesforce or not
    private static String getCollectionLicense ( Map<String, String> paramsMap, String commandURI ) {
        CollectionResponse response = new CollectionResponse();
        response.data = new List<Data>();
        List<Data> dataList = new List<Data>();
        Set<String> partyIdSet = new Set<String>();
        Map<Id, License__c> existingLicenseIdToLicenseMap;
        Map<String, String> partyIdToLicBooleanMap = new Map<String, String>();
        Set<String> existingPartyIdSet = new Set<String>();
        Map<String, String> nonExistingPartyIdMap = new Map<String, String>();
        Integer reqLimit = 10;
        
        try {
            if ( paramsMap.isEmpty() ) { //checking for correct endpoint
                errorResp.setError('No party id provided as parameter');
                RestContext.response.statusCode = 400;
                return JSON.serialize(errorResp);
            }  else if ( !paramsMap.isEmpty() && !paramsMap.containsKey('partyId') ) { //checking for correct endpoint
                errorResp.setError('No party id provided as parameter');
                RestContext.response.statusCode = 400;
                return JSON.serialize(errorResp);
            } else if ( paramsMap.get('partyId').length() == 0 ) { //checking for correct endpoint
                errorResp.setError('Provide the party id');
                RestContext.response.statusCode = 400;
                return JSON.serialize(errorResp);
            }
            
            if ( !paramsMap.containsKey('limit') ) {
                paramsMap.put('limit', '10');
            }
            
            if ( !paramsMap.get('limit').isNumeric() ) { //checking for correct endpoint
                errorResp.setError('Provide the numeric limit');
                RestContext.response.statusCode = 400;
                return JSON.serialize(errorResp);
            } else if ( !paramsMap.isEmpty() && paramsMap.containsKey('limit') && ( Integer.valueOf(paramsMap.get('limit')) <= 0 ) ) { //checking for correct endpoint
                errorResp.setError('Provide the limit greater than 0');
                RestContext.response.statusCode = 400;
                return JSON.serialize(errorResp);
            } else if ( Integer.valueOf(paramsMap.get('limit')) > 1000 ) { //checking for correct endpoint
                errorResp.setError('Limit can not exceed more than 1000');
                RestContext.response.statusCode = 400;
                return JSON.serialize(errorResp);
            }
            
            //creating set of all paraty ids coming from request
            List<String> partyIdList = new List<String>();
            if ( paramsMap.get('partyId').contains(',') ) {
                partyIdList = paramsMap.get('partyId').split(',');
                partyIdSet.addAll( partyIdList );
            } else if ( !paramsMap.get('partyId').contains(',') ) {
                partyIdList.add( paramsMap.get('partyId') );
                partyIdSet.addAll( partyIdList );
            }
            
            if ( ( partyIdSet.size() > Integer.valueOf(paramsMap.get('limit')) ) ) {
                errorResp.setError('Party ids can\'t be more than limit size');
                RestContext.response.statusCode = 400;
                return JSON.serialize(errorResp);
            }
            
            if ( Integer.valueOf(paramsMap.get('limit')) > 10 ) {
                reqLimit = Integer.valueOf(paramsMap.get('limit'));
            }
            
            //checking party id exist in Salesforce or not
            if ( !partyIdSet.isEmpty() ) {
                try { //this block is to check whether party id is available for account level in SF or not
                    List<Account> accList = new List<Account>();
                    accList = [ SELECT id, customer_Id__c FROM Account WHERE customer_Id__c IN:partyIdSet ORDER BY CreatedDate ASC LIMIT :reqLimit ];
                    
                    if ( !accList.isEmpty() ) {
                        for ( Account acc : accList ) {
                            if ( String.isNotBlank(acc.customer_Id__c) ) {
                                existingPartyIdSet.add(acc.customer_Id__c);
                            }
                        }
                    }
                } catch ( Exception ex ) {
                    String emailFailureMsg = System.Url.getSalesforceBaseUrl().getHost() + ' Webservice TF_LicenseAPIExposeService.getCollectionLicense is failing. ' + ex.getMessage() + ', Line : ' + ex.getLineNumber() + '-------' + errObj.errStr;
                    emailFailure(emailFailureMsg);
                    apiExceptionLog('getCollectionLicense', (ex.getMessage() + ', Line : ' + ex.getLineNumber()), (ex.getTypeName() + ', Line : ' + ex.getLineNumber()), errObj.errStr);
                    
                    errorResp.setError('Party Id does not exist in Salesforce');
                    RestContext.response.statusCode = 404;
                    return JSON.serialize(errorResp);
                }
                
                // this block is to check whether party id is available for contact level in SF of not
                try {
                    List<Contact> conList = new List<Contact>();
                    conList = [ SELECT id, party_Id__c FROM Contact WHERE party_Id__c IN:partyIdSet ORDER BY CreatedDate ASC LIMIT :reqLimit ];
                    
                    if ( !conList.isEmpty() ) {
                        for ( Contact con : conList ) {
                            if ( String.isNotBlank(con.party_Id__c) ) {
                                existingPartyIdSet.add( con.party_Id__c );
                            }
                        }
                    }
                } catch ( Exception e ) {
                    String emailFailureMsg = System.Url.getSalesforceBaseUrl().getHost() + ' Webservice TF_LicenseAPIExposeService.getCollectionLicense is failing. ' + e.getMessage() + ', Line : ' + e.getLineNumber() + '-------' + errObj.errStr;
                    emailFailure(emailFailureMsg);
                    apiExceptionLog('getCollectionLicense', (e.getMessage() + ', Line : ' + e.getLineNumber()), (e.getTypeName() + ', Line : ' + e.getLineNumber()), errObj.errStr);
                    
                    errorResp.setError('Party Id does not exist in Salesforce');
                    RestContext.response.statusCode = 404;
                    return JSON.serialize(errorResp);
                }
                
                if ( !existingPartyIdSet.equals(partyIdSet) ) {
                    for ( String requestPartyId : partyIdSet ) {
                        if ( !existingPartyIdSet.contains(requestPartyId) ) {
                            nonExistingPartyIdMap.put(requestPartyId, 'Party Id '+requestPartyId+' does not exist in Salesforce');
                        }
                    }
                }
            }
            
            //fetching all the existing licenses for all party ids in the request
            if ( !partyIdSet.isEmpty() ) {
                try {
                    existingLicenseIdToLicenseMap = new Map<Id, License__c>( [ SELECT id, RecordType.Name, customer__c, customer__r.customer_Id__c, Contact__c, Contact__r.party_Id__c, Status__c FROM License__c WHERE (customer__r.customer_Id__c IN:partyIdSet OR Contact__r.party_Id__c IN:partyIdSet) AND Status__c = 'Active' ] );
                } catch ( Exception ex ) {
                    String emailFailureMsg = System.Url.getSalesforceBaseUrl().getHost() + ' Webservice TF_LicenseAPIExposeService.getCollectionLicense is failing. ' + ex.getMessage() + ', Line : ' + ex.getLineNumber() + '-------' + errObj.errStr;
                    emailFailure(emailFailureMsg);
                    apiExceptionLog('getCollectionLicense', (ex.getMessage() + ', Line : ' + ex.getLineNumber()), (ex.getTypeName() + ', Line : ' + ex.getLineNumber()), errObj.errStr);
                    
                    existingLicenseIdToLicenseMap = new Map<Id, License__c>();
                    errorResp.setError(ex.getMessage());
                    RestContext.response.statusCode = 500;
                    return JSON.serialize(errorResp);
                }
            }
            
            if ( !existingLicenseIdToLicenseMap.isEmpty() ) {
                for ( License__c lic : existingLicenseIdToLicenseMap.values() ) {
                    String partyId = '';
                    partyId = ( lic.customer__c != NULL && lic.customer__r.customer_Id__c != NULL && ( lic.RecordType.Name == 'T&F Account License' || String.isBlank(lic.RecordType.Name) ) ) ? lic.customer__r.customer_Id__c : ( ( lic.Contact__c != NULL && lic.Contact__r.party_Id__c != NULL && lic.RecordType.Name == 'T&F Individual License' ) ? lic.Contact__r.party_Id__c : '' );
                    if ( String.isNotBlank(partyId) ) {
                        partyIdToLicBooleanMap.put( partyId, 'true' );
                    }
                }
                
            }
            
            //cretaing response 
            for ( String reqPartyId : partyIdSet ) {
                Data dataRecord = new Data();
                dataRecord.partyId = nonExistingPartyIdMap.containsKey(reqPartyId) ? nonExistingPartyIdMap.get(reqPartyId) : reqPartyId;
                dataRecord.collectionLicense = partyIdToLicBooleanMap.containsKey(reqPartyId) ? partyIdToLicBooleanMap.get(reqPartyId) : ( nonExistingPartyIdMap.containsKey(reqPartyId) ? 'null' : 'false' );
                response.data.add( dataRecord );
            }
        } catch ( Exception ex ) {
            String emailFailureMsg = System.Url.getSalesforceBaseUrl().getHost() + ' Webservice TF_LicenseAPIExposeService.getCollectionLicense is failing. ' + ex.getMessage() + ', Line : ' + ex.getLineNumber() + '-------' + errObj.errStr;
            emailFailure(emailFailureMsg);
            apiExceptionLog('getCollectionLicense', (ex.getMessage() + ', Line : ' + ex.getLineNumber()), (ex.getTypeName() + ', Line : ' + ex.getLineNumber()), errObj.errStr);
            errorResp.setError('Internal server error');
            RestContext.response.statusCode = 500;
            return JSON.serialize(errorResp);
        }
        
        return JSON.serialize(response);
    }
    
    //This method is to expose all contacts to CSD dashboard (LMS-414) if it has any license
    private static String getIndividualContacts ( Map<String, String> paramsMap ) {
        Integer limitVar = 10; //Initializing LIMIT
        Integer offsetVar = 0; //Initializing OFFSET
        Integer totalLicenseRecrds = 0;
        List<Contact> contactList = new List<Contact>();
        ContactsOrderByName response = new ContactsOrderByName();
        
        try {
            if ( !paramsMap.containsKey('limit') ) {
                paramsMap.put('limit', '10');
            }
            
            if ( !paramsMap.get('limit').isNumeric() ) { //checking for correct endpoint
                errorResp.setError('Provide the numeric limit');
                RestContext.response.statusCode = 400;
                return JSON.serialize(errorResp);
            } else if ( !paramsMap.isEmpty() && paramsMap.containsKey('limit') && ( Integer.valueOf(paramsMap.get('limit')) <= 0 ) ) { //checking for correct endpoint
                errorResp.setError('Provide the limit greater than 0');
                RestContext.response.statusCode = 400;
                return JSON.serialize(errorResp);
            } else if ( Integer.valueOf(paramsMap.get('limit')) > 1000 ) { //checking for correct endpoint
                errorResp.setError('Limit can not exceed more than 1000');
                RestContext.response.statusCode = 400;
                return JSON.serialize(errorResp);
            }
            
            if ( paramsMap.containsKey('offset') && !paramsMap.get('offset').isNumeric() ) {
                errorResp.setError('Provide the numeric offset');
                RestContext.response.statusCode = 400;
                return JSON.serialize(errorResp);
            } else if ( paramsMap.containsKey('offset') ) {
                offsetVar = Integer.valueOf(paramsMap.get('offset'));
            }
            
            if ( paramsMap.containsKey('limit') ) {
                limitVar = Integer.valueOf(paramsMap.get('limit'));
            }
            
            List<AggregateResult> distinctContactIdsList = new List<AggregateResult>();
            distinctContactIdsList = [ SELECT contact__c con, Contact__r.name FROM License__c WHERE Contact__r.name != NULL GROUP BY contact__c, contact__r.name ORDER BY contact__r.name ];
            List<String> conIdList = new List<String>();
            
            if ( !distinctContactIdsList.isEmpty() ) {
                totalLicenseRecrds = distinctContactIdsList.size();
            }
            
            if ( totalLicenseRecrds == 0 ) {
                errorResp.setError('No Contacts found in SF');
                RestContext.response.statusCode = 404;
                return JSON.serialize(errorResp);
            }
            
            if ( offsetVar >= totalLicenseRecrds ) {
                errorResp.setError('Offset should be less than total records = '+totalLicenseRecrds);
                RestContext.response.statusCode = 400;
                return JSON.serialize(errorResp);
            }
            
            if ( !distinctContactIdsList.isEmpty() ) {
                integer startValue = Integer.valueOf(paramsMap.get('offset'));
                integer endValue = Integer.valueOf(paramsMap.get('offset')) + Integer.valueOf(paramsMap.get('limit'));
                conIdList.clear();
                for ( integer i = startValue; i < endValue; i++ ) {
                    conIdList.add( (String)distinctContactIdsList[i].get('con') );
                    if ( i == (distinctContactIdsList.size() -1) ) {
                        break;
                    }
                }
            }
            
            contactList = [ SELECT id, name, email, party_Id__c FROM Contact WHERE id IN:conIdList ORDER BY Name ASC NULLS LAST ];
            
            if ( !contactList.isEmpty() ) {
                response.total = totalLicenseRecrds;
                List<ContactInfo>  conRecordsList = new List<ContactInfo>();
                for ( Contact con :contactList ) {
                    ContactInfo conRecord = new ContactInfo();
                    conRecord.name = String.isNotBlank(con.name) ? con.name.remove('"') : '';
                    conRecord.email = String.isNotBlank(con.email) ? con.email : '';
                    conRecord.partyId = String.isNotBlank(con.party_Id__c) ? con.party_Id__c : '';
                    conRecord.customerType = 'Individual';
                    conRecordsList.add( conRecord );
                }
                response.contacts = conRecordsList;
            }
        } catch ( Exception ex ) {
            String emailFailureMsg = System.Url.getSalesforceBaseUrl().getHost() + ' Webservice TF_LicenseAPIExposeService.getIndividualContacts is failing. ' + ex.getMessage() + ', Line : ' + ex.getLineNumber() + '-------' + errObj.errStr;
            emailFailure(emailFailureMsg);
            apiExceptionLog('getIndividualContacts', (ex.getMessage() + ', Line : ' + ex.getLineNumber()), (ex.getTypeName() + ', Line : ' + ex.getLineNumber()), errObj.errStr);
            errorResp.setError('Internal server error');
            RestContext.response.statusCode = 500;
            return JSON.serialize(errorResp);
        }
        
        return JSON.serialize(response);
    }
    
    private static String fetchLicenseByIds ( Blob reqBody ) {
        MultipleLicenseResponse response = new MultipleLicenseResponse();
        response.licenseIds = new List<LicenseIds>();
        String licenseIdsBody = '';
        FetchLicenseByIdsWrapper licenseIdsWrapper = new FetchLicenseByIdsWrapper();
        Set<String> licenseIdSet = new Set<String>();
        Map<Id, License__c> licenseIdToLicenseMap;
        Set<String> availbaleLicIdSet = new Set<String>();
        List<LicenseIds> licrecordList = new List<LicenseIds>();
        
        try {
            if ( reqBody != NULL ) {
                licenseIdsBody = reqBody.toString();
            }

            if ( String.isNotBlank(licenseIdsBody) && licenseIdsBody.containsIgnoreCase('"licenseIds"') ) {
                licenseIdsWrapper = (FetchLicenseByIdsWrapper)System.JSON.deserialize( licenseIdsBody, FetchLicenseByIdsWrapper.class);
            } else {
                errorResp.setError('BAD REQUEST');
                RestContext.response.statusCode = 400;
                return JSON.serialize(errorResp);
            }
            
            if ( licenseIdsWrapper != NULL ) {
                System.debug('licenseIdsWrapper =====>' + licenseIdsWrapper);
                if ( licenseIdsWrapper.licenseIds != NULL && licenseIdsWrapper.licenseIds.size() > 500 ) {
                    errorResp.setError('Request Entity too large. Request should have license ids size less than 500');
                    RestContext.response.statusCode = 413;
                    return JSON.serialize(errorResp);
                }
                
                if ( licenseIdsWrapper.licenseIds != NULL ) {
                    System.debug('licenseIdsWrapper Size =====>' + licenseIdsWrapper.licenseIds.size());
                    
                    for ( String licenseIdd : licenseIdsWrapper.licenseIds ) {
                        licenseIdSet.add( licenseIdd );
                    }
                }
                
                if ( !licenseIdSet.isEmpty() ) {
                    System.debug('licenseIdSet =====>' + licenseIdSet);
                    System.debug('licenseIdSet Size =====>' + licenseIdSet.size());
                    
                    try {
                        licenseIdToLicenseMap = new Map<Id, License__c>( [ SELECT id, name, customer__c, customer__r.Name, customer__r.customer_Id__c, customer__r.Type, contact__c, contact__r.Name, contact__r.party_Id__c, License_Type__c, Grant_Type__c, Product__c, Product__r.Hub_Id__c, Product__r.name, Description__c, Order_Number__c, Purchase_Date__c, Start_Date__c, End_Date__c, Status__c, createdById, CreatedDate, createdBy.Name, lastModifiedById, LastModifiedDate, lastModifiedBy.Name, ( SELECT id, Account__c, Account__r.Type, Account__r.Name, Account__r.Ringgold_Account_ID__c FROM License_Memebers__r ) FROM License__c WHERE Id IN:licenseIdSet ] );
                        for ( Id licId : licenseIdToLicenseMap.keySet() ) {
                            availbaleLicIdSet.add(licId);
                        }
                    } catch ( Exception ex ) {
                        String emailFailureMsg = System.Url.getSalesforceBaseUrl().getHost() + ' Webservice TF_LicenseAPIExposeService.fetchLicenseByIds is failing. ' + ex.getMessage() + ', Line : ' + ex.getLineNumber() + '-------' + (errObj.errStr + '------' + licenseIdsBody);
                        emailFailure(emailFailureMsg);
                        apiExceptionLog('fetchLicenseByIds', (ex.getMessage() + ', Line : ' + ex.getLineNumber()), (ex.getTypeName() + ', Line : ' + ex.getLineNumber()), (errObj.errStr + '------' + licenseIdsBody));
                        
                        System.debug('Exception =====>' + ex.getMessage());
                        licenseIdToLicenseMap = new Map<Id, License__c>();
                        errorResp.setError('Internal server error');
                        RestContext.response.statusCode = 500;
                        return JSON.serialize(errorResp);
                    }
                    
                    for ( String licId : licenseIdSet ) {
                        if ( !availbaleLicIdSet.contains( licId ) ) {
                            LicenseIds licensRecord = new LicenseIds();
                            licensRecord.licenseId = 'License Id ' + String.valueOf( licId ) + ' not exist in Database';
                            licrecordList.add( licensRecord );
                        }
                    }
                }
                
                if ( !licenseIdToLicenseMap.isEmpty() ) {
                    for ( License__c lic : licenseIdToLicenseMap.values() ) {
                        List<String> grantList = new List<String>();
                    
                        if ( lic.Grant_Type__c != NULL ) {
                            if ( lic.Grant_Type__c.contains(';') )
                                grantList = lic.Grant_Type__c.split(';');
                            else
                                grantList.add( lic.Grant_Type__c );
                        }
                            
                        LicenseIds licenseRecord = new LicenseIds();
                        licenseRecord.licenseId = String.valueOf( lic.id );
                        licenseRecord.customerId = lic.customer__c != NULL ? String.valueOf( lic.customer__c ) : '';
                        licenseRecord.contactId = lic.contact__c != NULL ? String.valueOf( lic.contact__c ) : '';
                        licenseRecord.licenseType = String.isNotBlank(lic.License_Type__c) ? lic.License_Type__c : '';
                        licenseRecord.grantType = grantList;
                        licenseRecord.productBundleId = ( lic.Product__c != NULL && lic.Product__r.Hub_Id__c != NULL ) ? String.valueOf( lic.Product__r.Hub_Id__c ) : '';
                        licenseRecord.orderNumber = String.isNotBlank(lic.Order_Number__c) ? lic.Order_Number__c : '';
                        licenseRecord.purchaseDate = lic.Purchase_Date__c != NULL ? String.valueOf( lic.Purchase_Date__c ) : '';
                        licenseRecord.licenseName = lic.name;
                        licenseRecord.startDate = lic.Start_Date__c != NULL ? String.valueOf( lic.Start_Date__c ) : '';
                        licenseRecord.endDate = lic.End_Date__c != NULL ? String.valueOf( lic.End_Date__c ) : '';
                        licenseRecord.status = String.isNotBlank(lic.Status__c) ? lic.Status__c : '';
                        licenseRecord.createdby = String.valueOf( lic.createdBy.Name );
                        licenseRecord.lastmodifiedBy = String.valueOf( lic.lastModifiedBy.Name );
                        licenseRecord.createdOn = String.valueOf( lic.CreatedDate );
                        licenseRecord.lastmodifiedOn = String.valueOf( lic.LastModifiedDate );
                        licenseRecord.partyId = ( ( lic.customer__c != NULL && String.isNotBlank(lic.customer__r.customer_Id__c) ? String.valueOf(lic.customer__r.customer_Id__c) : ( ( lic.contact__c != NULL && String.isNotBlank(lic.contact__r.party_Id__c) ) ? String.valueOf(lic.contact__r.party_Id__c) : '') ) );
                        licenseRecord.productName = lic.Product__c != NULL ? lic.Product__r.name : '';
                        licenseRecord.customerType = ( lic.customer__c != NULL && lic.customer__r.Type != NULL && lic.customer__r.Type.equalsIgnoreCase('Consortium') ) ? 'Consortium' : ( ( lic.customer__c != NULL && lic.customer__r.Type != NULL && !lic.customer__r.Type.equalsIgnoreCase('Consortium') ? 'Institute' : ( ( lic.Contact__c != NULL ) ? 'Individual' : '' ) ) );
                        licenseRecord.description = lic.Description__c != NULL ? lic.Description__c : '';
                        licenseRecord.members = new List<licenseMembers>();
                        if ( licenseRecord.customerType.equalsIgnoreCase('Consortium') ) {
                            if ( !lic.License_Memebers__r.isEmpty() ) {
                                for ( License_Memeber__c licMember : lic.License_Memebers__r ) {
                                    licenseMembers licMemberRecord = new licenseMembers();
                                    licMemberRecord.childName = licMember.Account__r.Name;
                                    licMemberRecord.childRingGoldId = String.isNotBlank(licMember.Account__r.Ringgold_Account_ID__c) ? licMember.Account__r.Ringgold_Account_ID__c : '' ;
                                    licMemberRecord.childCustomerType = String.isNotBlank(licMember.Account__r.Type) ? licMember.Account__r.Type : '';
                                    licenseRecord.members.add(licMemberRecord);
                                }
                            }
                        }
                        response.licenseIds.add( licenseRecord );
                    }
                }
                
                if ( !licrecordList.isEmpty() ) {
                    response.licenseIds.addAll( licrecordList );
                }
            }
            RestContext.response.statusCode = 201;
        } catch ( Exception ex ) {
            String emailFailureMsg = System.Url.getSalesforceBaseUrl().getHost() + ' Webservice TF_LicenseAPIExposeService.fetchLicenseByIds is failing. ' + ex.getMessage() + ', Line : ' + ex.getLineNumber() + '-------' + (errObj.errStr + '------' + licenseIdsBody);
            emailFailure(emailFailureMsg);
            apiExceptionLog('fetchLicenseByIds', (ex.getMessage() + ', Line : ' + ex.getLineNumber()), (ex.getTypeName() + ', Line : ' + ex.getLineNumber()), (errObj.errStr + '------' + licenseIdsBody));
            System.debug('Exception =====>' + ex.getMessage());
            errorResp.setError('Internal server error');
            RestContext.response.statusCode = 500;
            return JSON.serialize(errorResp);
        }
        
        //return licenseIdsBody;
        return JSON.serialize(response);
    }
    
    private static String postHasPartUpdate ( Map<String, String> paramsMap, Blob reqBody ) {
        HasPartResponse response = new HasPartResponse();
        String requesttBody = '';
        //HasPartRequest hasPartRequestt = new HasPartRequest();
        TF_HasPartWrapper hasPartRequestt = new TF_HasPartWrapper();
        String paramLicenseType = 'UPDATE_DYNAMIC_LICENSE';

        try {
            requesttBody = reqBody.toString();
            
            if ( paramsMap.containsKey('type') ) {
                if ( paramsMap.get('type').containsIgnoreCase('All') ) {
                    paramLicenseType = 'UPDATE_ALL_LICENSE';
                }
            }
            System.debug('paramLicenseType =====>' + paramLicenseType);
            
            if ( String.isBlank(requesttBody) ) {
                response.setHasPartMessage('No Body');
                RestContext.response.statusCode = 204;
                return JSON.serialize(response);
            } else {
                requesttBody = requesttBody.replaceAll( '_id', 'x_id' );
                requesttBody = requesttBody.replaceAll( 'event-payload-type', 'event_payload_type' );
                requesttBody = requesttBody.replaceAll( 'event-type', 'event_type' );
                requesttBody = requesttBody.replaceAll( 'status-description', 'status_description' );
                //hasPartRequestt = (HasPartRequest)System.JSON.deserialize( requesttBody, HasPartRequest.class);
                hasPartRequestt = (TF_HasPartWrapper)System.JSON.deserialize( requesttBody, TF_HasPartWrapper.class);
                requesttBody = null;

                if ( hasPartRequestt.header == NULL && hasPartRequestt.body == NULL ) {
                    response.setHasPartMessage('BAD REQUEST. Request should contain header and body attributes.');
                    RestContext.response.statusCode = 400;
                    return JSON.serialize(response);
                }
                
                //now process the has part update flow
                Map<String, String> hubIdToJsonStrMap = new Map<String, String>();
                if ( hasPartRequestt.body.product.x_id != NULL && ( hasPartRequestt.body.partsAdded.size() > 0 || hasPartRequestt.body.partsDeleted.size() > 0 ) ) { //UBXC-1560
                    hubIdToJsonStrMap.put(hasPartRequestt.body.product.x_id, JSON.serialize(hasPartRequestt));
                }
                hasPartRequestt = null;
                                
                if ( !hubIdToJsonStrMap.isEmpty() ) {
                    TF_HasPartUpdate_Cls.hasPartCallout( paramLicenseType, hubIdToJsonStrMap );
                }
                
                response.setHasPartMessage('Success');
                RestContext.response.statusCode = 201;
            }
        } catch ( Exception ex ) {
            String boddy = '';
            if (reqBody != null) {
                boddy = reqBody.toString();
            }
            String emailFailureMsg = System.Url.getSalesforceBaseUrl().getHost() + ' Webservice TF_LicenseAPIExposeService.postHasPartUpdate is failing. ' + ex.getMessage() + ', Line : ' + ex.getLineNumber() + '-------' + (errObj.errStr + '------' + boddy);
            emailFailure(emailFailureMsg);
            apiExceptionLog('postHasPartUpdate', (ex.getMessage() + ', Line : ' + ex.getLineNumber()), (ex.getTypeName() + ', Line : ' + ex.getLineNumber()), (errObj.errStr + '------' + boddy));
            System.debug('Exception =====>' + ex.getMessage());
            response.setHasPartMessage('Internal server error');
            RestContext.response.statusCode = 500;
        }
        
        return JSON.serialize(response);
    }
    
    private static String getLicenseByOrganization ( Map<String, String> paramsMap ) { //UBXC-2263
        //services/apexrest/licenses/getLicenseByOrganization?orgId=0011q00000P9KLrAAN&partyId=100&licenseId=a3K1l000000ARygEAG
        LicenseIds licResponse = new LicenseIds();
        String orgId;
        String partyId;
        String licenseId;
        if ( ( paramsMap.containsKey('orgId') || paramsMap.containsKey('partyId') ) && paramsMap.containsKey('licenseId') ) {
            licenseId = paramsMap.get('licenseId');
            licenseId = licenseId.deleteWhiteSpace();
            
            if (licenseId.contains(',')) {
                List<String> licenseIdList = new List<String>();
                licenseIdList = licenseId.split(',');
                if ( licenseIdList != null && licenseIdList.size() > 1 ) {
                    errorResp.setError('licenseId param should be single');
                    RestContext.response.statusCode = 400;
                    return JSON.serialize(errorResp);
                }
            }
            
            if ( paramsMap.containsKey('orgId') ) {
                orgId = paramsMap.get('orgId');
                orgId = orgId.deleteWhiteSpace();
                
                if (orgId.contains(',')) {
                    List<String> orgIdList = new List<String>();
                    orgIdList = orgId.split(',');
                    if ( orgIdList != null && orgIdList.size() > 1 ) {
                        errorResp.setError('orgId param should be single');
                        RestContext.response.statusCode = 400;
                        return JSON.serialize(errorResp);
                    }
                }
            }
            
            if ( paramsMap.containsKey('partyId') ) {
                partyId = paramsMap.get('partyId');
                partyId = partyId.deleteWhiteSpace();
                
                if (partyId.contains(',')) {
                    List<String> partyIdList = new List<String>();
                    partyIdList = partyId.split(',');
                    if ( partyIdList != null && partyIdList.size() > 1 ) {
                        errorResp.setError('partyId param should be single');
                        RestContext.response.statusCode = 400;
                        return JSON.serialize(errorResp);
                    }
                }
            }
            
            licenseId = licenseId.replaceAll(',', '');
            orgId = orgId.replaceAll(',', '');
            partyId = partyId.replaceAll(',', '');
            
            for ( License__c lic : [ SELECT id, name, customer__c, customer__r.Name, customer__r.customer_Id__c, customer__r.Type, contact__c, contact__r.Name, contact__r.party_Id__c, License_Type__c, Grant_Type__c, Product__c, Product__r.Hub_Id__c, Product__r.name, Product__r.Product_Category__c, Description__c, Order_Number__c, Purchase_Date__c, Start_Date__c, End_Date__c, Status__c, createdById, CreatedDate, createdBy.Name, lastModifiedById, LastModifiedDate, lastModifiedBy.Name, ( SELECT id, Account__c, Account__r.Type, Account__r.Name, Account__r.Ringgold_Account_ID__c FROM License_Memebers__r ) FROM License__c WHERE Id =:licenseId AND (( customer__c =:orgId OR contact__c =:orgId ) OR ( customer__r.customer_Id__c =:partyId OR contact__r.party_Id__c =:partyId )) LIMIT 1 ] ) {
                List<String> grantList = new List<String>();
                        
                if ( lic.Grant_Type__c != NULL ) {
                    if ( lic.Grant_Type__c.contains(';') )
                        grantList = lic.Grant_Type__c.split(';');
                    else
                        grantList.add( lic.Grant_Type__c );
                }
                licResponse.licenseId = String.valueOf( lic.id );
                licResponse.customerId = lic.customer__c != NULL ? String.valueOf( lic.customer__c ) : '';
                licResponse.contactId = lic.contact__c != NULL ? String.valueOf( lic.contact__c ) : '';
                licResponse.licenseType = String.isNotBlank(lic.License_Type__c) ? lic.License_Type__c : '';
                licResponse.grantType = grantList;
                licResponse.productBundleId = ( lic.Product__c != NULL && lic.Product__r.Hub_Id__c != NULL ) ? String.valueOf( lic.Product__r.Hub_Id__c ) : '';
                licResponse.productCategory = ( lic.Product__r.Product_Category__c != NULL ) ? String.valueOf( lic.Product__r.Product_Category__c ) : ''; //UBXC-1733
                licResponse.orderNumber = String.isNotBlank(lic.Order_Number__c) ? lic.Order_Number__c : '';
                licResponse.purchaseDate = lic.Purchase_Date__c != NULL ? String.valueOf( lic.Purchase_Date__c ) : '';
                licResponse.licenseName = lic.name;
                licResponse.startDate = lic.Start_Date__c != NULL ? String.valueOf( lic.Start_Date__c ) : '';
                licResponse.endDate = lic.End_Date__c != NULL ? String.valueOf( lic.End_Date__c ) : '';
                licResponse.status = String.isNotBlank(lic.Status__c) ? lic.Status__c : '';
                licResponse.createdby = String.valueOf( lic.createdBy.Name );
                licResponse.lastmodifiedBy = String.valueOf( lic.lastModifiedBy.Name );
                licResponse.createdOn = String.valueOf( lic.CreatedDate );
                licResponse.lastmodifiedOn = String.valueOf( lic.LastModifiedDate );
                licResponse.partyId = ( ( lic.customer__c != NULL && String.isNotBlank(lic.customer__r.customer_Id__c) ? String.valueOf(lic.customer__r.customer_Id__c) : ( ( lic.contact__c != NULL && String.isNotBlank(lic.contact__r.party_Id__c) ) ? String.valueOf(lic.contact__r.party_Id__c) : '') ) );
                licResponse.productName = lic.Product__c != NULL ? lic.Product__r.name : '';
                licResponse.customerType = ( lic.customer__c != NULL && lic.customer__r.Type != NULL && lic.customer__r.Type.equalsIgnoreCase('Consortium') ) ? 'Consortium' : ( ( lic.customer__c != NULL && lic.customer__r.Type != NULL && !lic.customer__r.Type.equalsIgnoreCase('Consortium') ? 'Institute' : ( ( lic.Contact__c != NULL ) ? 'Individual' : '' ) ) );
                licResponse.description = lic.Description__c != NULL ? lic.Description__c : '';
                licResponse.members = new List<licenseMembers>();
                if ( licResponse.customerType.equalsIgnoreCase('Consortium') ) {
                    if ( !lic.License_Memebers__r.isEmpty() ) {
                        for ( License_Memeber__c licMember : lic.License_Memebers__r ) {
                            licenseMembers licMemberRecord = new licenseMembers();
                            licMemberRecord.childName = licMember.Account__r.Name;
                            licMemberRecord.childRingGoldId = String.isNotBlank(licMember.Account__r.Ringgold_Account_ID__c) ? licMember.Account__r.Ringgold_Account_ID__c : '' ;
                            licMemberRecord.childCustomerType = String.isNotBlank(licMember.Account__r.Type) ? licMember.Account__r.Type : '';
                            licResponse.members.add(licMemberRecord);
                        }
                    }
                }
            }
            
            if ( licResponse == null || licResponse.licenseId == null ) {
                errorResp.setError('Not found.');
                RestContext.response.statusCode = 404;
                return JSON.serialize(errorResp);
            } else {
                RestContext.response.statusCode = 200;
            }
        } else {
            errorResp.setError('Not found.');
            RestContext.response.statusCode = 404;
            return JSON.serialize(errorResp);
        }
        
        return JSON.serialize(licResponse);
    }
    
    public static void emailFailure (String textBody) {
        Messaging.SingleEmailMessage objEmail = new Messaging.SingleEmailMessage();
        List<String> sendToEmailList = new List<String>();
        sendToEmailList.add('vikas.c.varshney@informa.com');
        objEmail.setToAddresses(sendToEmailList);
        objEmail.setSubject('Salesforce License webservice failure Notification');
        String htmlBody = textBody + '';

        objEmail.setHtmlBody(htmlBody);

        if(!Test.isRunningTest()) {
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{objEmail});
            if ( results[0].success ) {
                System.debug('********** Email sent successfully **********');
            } else {
                System.debug('********** Error in sending email **********');
            }
        }
    }
    
    public static void apiExceptionLog ( String apiName, String erroeMsg, String errorType, String req ) { //UBXC-2013
        Exception_Log__c exceptionLogInsert = new Exception_Log__c();
        exceptionLogInsert.ownerId = UserInfo.getUserId();
        exceptionLogInsert.Object_ID__c = 'Api ' + apiName;
        exceptionLogInsert.Object_Type__c = 'License';
        exceptionLogInsert.Error_Type__c = 'Inbound';
        exceptionLogInsert.Error_message__c = System.Url.getSalesforceBaseUrl().getHost() + ' organisation error message : ' + erroeMsg + '-------' + 'Salesforce Webservice -- Failure Errortype : ' + errorType;
        exceptionLogInsert.Request_JSON__c = req;
        exceptionLogInsert.Resolution_Status__c = 'New';
        
        try {
            insert exceptionLogInsert;
        } catch ( Exception ex ) {
            String emailFailureMsg = System.Url.getSalesforceBaseUrl().getHost() + ' DML for TF_LicenseAPIExposeService.apiExceptionLog is failing. ' + ex.getMessage();
            emailFailure(emailFailureMsg);
            System.debug('Exception =====>' + ex.getMessage());
        }
    }
    
    // ***** Private method definition *****
    private static String getCommand(String requestedUri) {
        String returnURI = '';
        if ( requestedUri.containsIgnoreCase('customer') ) {
            returnURI = 'customer' + requestedUri.subString(requestedUri.lastIndexOf('/'), requestedUri.length());
        }
        else if ( requestedUri.containsIgnoreCase('multipleLicenses') )
            returnURI = 'multipleLicenses';
        else if ( requestedUri.containsIgnoreCase('validateCollectionLicense') )
            returnURI = 'validateCollectionLicense';
        else if ( requestedUri.containsIgnoreCase('getIndividualContacts') )
            returnURI = 'getIndividualContacts';
        else if ( requestedUri.containsIgnoreCase('fetchLicenseByIds') )
            returnURI = 'fetchLicenseByIds';
        else if ( requestedUri.containsIgnoreCase('postHasPartUpdate') )
            returnURI = 'postHasPartUpdate';
        else if ( requestedUri.containsIgnoreCase('getLicenseByOrganization') ) {
            returnURI = 'getLicenseByOrganization';
        }
        
        return returnURI;
    }
    
    private static String operationLookup(String method, String command) {
        String operation = 'unknown';
        if (method.equals('GET')) {
            if (command.containsIgnoreCase('customer')) {
                operation = 'getLicensesByPartyId';
            } else if (command.containsIgnoreCase('multipleLicenses')) {
                operation = 'getLicensesByMultipleIds';
            } else if (command.containsIgnoreCase('validateCollectionLicense')) {
                operation = 'getCollectionLicense';
            } else if (command.containsIgnoreCase('getIndividualContacts')) {
                operation = 'getIndividualContacts';
            } else if (command.containsIgnoreCase('getLicenseByOrganization')) {
                operation = 'getLicenseByOrganization';
            }
        } else if(method.equals('POST')) {
            if (command.equalsIgnoreCase('fetchLicenseByIds')) {
                operation = 'fetchLicenseByIds';
            } else if (command.equalsIgnoreCase('postHasPartUpdate')) {
                operation = 'postHasPartUpdate';
            }
        } else if (method.equals('DELETE')) {
            
        } else if (method.equals('PUT')) {
            
        }
        return operation;
    }
}