/***************************************************************************
* Created by: Tom Reed, 2019.01.02
* Modified by : Harish ms on 2019-11-14 Case - 01375447.
* Modified by : Tom Reed on 2019-11-14 Case - 01373482. (Distribution Rights)
* Tested By: zTest_ProductAPI @ 92%
* Description: Product API endpoint which is called by the product hub whenever a product is created or updated.
* NOTE: Although bulkified in most places this class is designed to run for one isbn per payload.
* Extensive testing is needed if the code is to be completely bulkified in future.
* **************************************************************************/

@RestResource(urlMapping='/ProductAPI/*')
global class ProductAPI {    
    
    public static Map<String, String> sourceRoleToSalesforceRoleMap = new Map<String, String>();
    public static Map<String, Map<String, Setting_Item__c>> objectTypeToSalesforceFieldToSourceField = new Map<String, Map<String, Setting_Item__c>>();
    //Deserialize the JSON request body.
    public static Map<String, Map<String,String>> isbnToArrayKeyMap = new Map<String, Map<String,String>>();
    //Example {12345678910={Pricing1=GBP, Pricing2=USD}}
    public static Map<String,String> arrayKeyToUniqueIdentifierMap = new Map<String,String>();
    //Example {Pricing1=GBP,Pricing2=USD, distributioncenters1=Oxford}
    public static Map<String, Map<String, String>> isbnToFieldToValueMap = new Map<String, Map<String, String>>();
    //Example {12345678910={FieldName1=Value1,FieldName2=Value2}}
    public static Map<Integer, Map<String, String>> keyTofieldToValueMap = new Map<Integer, Map<String, String>>();
    //This is a holding map to be used eventually in the map above.
    //Examlple {1={ISBN=12345678910,FieldName1=Value1,FieldName2=Value2}}
    public static Map<String,  Map<String, String>> arrayKeyToFieldToValueMap = new Map<String,  Map<String, String>>();
    //Example {Pricing1={Currency=GBP,Price=100}}
    public static Set<String> isbnSet = new Set<String>();
    //Locate any Product2 records which already have PricebookEntries.
    public static Map<String, PricebookEntry> existingProduct2IdCurrencyPricebookKeyToPricebookEntry = new Map<String, PricebookEntry>();
    //Example: {123456789gbpt&f pricebook = PricebookEntry Record}
    public static String currencyValue = '';
    public static String jsonString = '';
    public static String messageKey = '';
    public static Set<String> dacKeySet = new Set<String>();
    public static Set<String> netbaseExclusionSet = new Set<String>();
    
    //Locate the standard pricebook and T&F pricebook id.
    public static Pricebook2 tfPriceBook = [SELECT Id, Name FROM Pricebook2 WHERE Name = 'T&F Pricebook' LIMIT 1];
    public static Pricebook2 standardPriceBook = [SELECT Id, Name FROM Pricebook2 WHERE Name = 'Standard Price Book' LIMIT 1];
    public static Pricebook2 ebookPriceBook = [SELECT Id, Name FROM Pricebook2 WHERE Name = 'T&F - eBooks Pricebook' LIMIT 1];  
    
    //Test endpoint to verify authentication.
    //ENDPOINT: https://taylorandfrancis.my.salesforce.com/services/apexrest/productSyncTest
    @HttpGet
    global static void productSyncTest(){ 
        RestResponse response = RestContext.response;
        response.responseBody = blob.ValueOf('Successful Authentication');    
        response.statusCode = 200; 
    }    
    
    //ENDPOINT: https://taylorandfrancis.my.salesforce.com/services/apexrest/ProductAPI    
    @HttpPost
    global static void productSync(){         
        //Locate the request body from the api call.           
        RestRequest req = RestContext.request;
        Blob body = req.requestBody;
        jsonString = body.toString(); 
        
        string processingResult = ProductAPI.runProductSync(jsonString);
        
        //If the error is due to a record lockout a success is still passed.
        if(processingResult == 'Successful Update/Insert' || processingResult.containsIgnoreCase('UNABLE_TO_LOCK_ROW')){
            RestResponse response = RestContext.response;
            response.responseBody = blob.ValueOf('Successful Update/Insert');    
            response.statusCode = 200;
        } else {
            RestResponse response = RestContext.response;
            response.responseBody = blob.ValueOf(processingResult);    
            response.statusCode = 400;  
        }     
    }
    
    public static string runProductSync(string jsonString){
        
        String isbnValue = '';
        messageKey = '';
        
        try{     
            JSONParser parser = JSON.createParser(jsonString);          
            Boolean jsonIsArray = False;
            //If the code is in a sub array.
            Boolean isInSubArray = False;
            //If the code is in a top level array.
            Boolean isInTopLevelArray = False;
            //The field name of the previous token.
            String previousTokenField = '';
            //The type of sub array.
            String arrayType = '';
            //A key to identify which array the code is in.
            Integer arrayKey = 0;
            //A key to identify which top level array the coe is in.
            Integer topLevelKey = 0;
            //If the code has reached the first array.
            Boolean inStartArray = false;
            //If the code has reached the first object.
            Integer objectLevel = 0;
            Boolean isFirstObject = False;
            //A list of the array keys.
            List<String> arrayKeyList = new List<String>();
            
/**************************************************************************
* 
*  Parse the JSON payload.
* 
* *************************************************************************/  
            
            //Loop through the json body.
            while (parser.nextToken() != null) {                                    
                //system.debug(parser.getCurrentToken());
                //system.debug(parser.getText());            
                
                //If the code has reached a start object.
                if(parser.getCurrentToken() == JSONToken.START_OBJECT){
                    isFirstObject = True;
                    objectLevel++;  
                }
                
                //If the code has reached an end object.
                if(parser.getCurrentToken() == JSONToken.END_OBJECT){
                    objectLevel--;  
                }
                
                //If the code has reached a start array.
                if(parser.getCurrentToken() == JSONToken.START_ARRAY){
                    inStartArray = True;  
                }                 
                
                //If an array starts before the first object the json must be in a format of an array.
                if(inStartArray == True && isFirstObject == False){
                    if(jsonIsArray == False){
                        jsonIsArray = True; 
                    }
                }
                
                //If the code isn't currently in a sub array and has reached the next object create a new
                //top level key to be used.
                if(isInSubArray == false && parser.getCurrentToken() == JSONToken.START_OBJECT){
                    topLevelKey++; 
                }          
                
                //If the code isn't currently in a sub array and the current token is a field add
                //the field label and its value into the map.
                if(parser.getCurrentToken() == JSONToken.FIELD_NAME && isInSubArray == false){
                    //Get the field name.
                    String fieldName = parser.getText().ToLowerCase();
                    //Set the previous token field.
                    previousTokenField = parser.getText().ToLowerCase();
                    //Get the next token which will be the field value.
                    parser.nextToken();
                    String fieldValue = parser.getText();   
                    //If the code has reached a start object.
                    if(parser.getCurrentToken() == JSONToken.START_OBJECT){
                        objectLevel++;  
                    }
                    //If the code has reached an end object.
                    if(parser.getCurrentToken() == JSONToken.END_OBJECT){
                        objectLevel--;  
                    }
                    Map<String,String> fieldToValueMap = new Map<String,String>();
                    //If the top level key is already in the map grab the existing values and add the new.
                    if(keyTofieldToValueMap.containskey(topLevelKey)){
                        fieldToValueMap = keyTofieldToValueMap.get(topLevelKey);
                    }
                    fieldToValueMap.put(fieldName, fieldValue);
                    System.debug('key ====fieldName, fieldValue==='+topLevelKey+'====='+fieldName+'===='+ fieldValue);
                    keyTofieldToValueMap.put(topLevelKey, fieldToValueMap);
                }
                
                //If it's the first time the code has reached JSONToken.START_ARRAY look back to the previous value
                //to see what type of arrey it is. The previous value will be the last field the code recieved.
                if(parser.getCurrentToken() == JSONToken.START_ARRAY){
                    arrayType = previousTokenField;
                }
                
                //If the code is in a sub array and is starting on a new object create a new sub array key.
                if(isInSubArray && parser.getCurrentToken() == JSONToken.START_OBJECT){
                    arrayKey++;               
                }
                
                //If the code is in a sub array and the object is ending.
                if(isInSubArray && parser.getCurrentToken() == JSONToken.END_OBJECT){
                    
                    //Add the key into the array list so the correct values can be pulled out of the map later.

                    arrayKeyList.add(arrayType+arrayKey);
                    //Create a map using the unique identifier in each of the sub arrays.
                    if(arrayType == 'pricing'){
                        String uniqueIdentifierValue = arrayKeyToFieldToValueMap.get(arrayType+arrayKey).get('currency');
                        arrayKeyToUniqueIdentifierMap.put(arrayType+arrayKey, uniqueIdentifierValue.ToLowerCase());
                    }
                    //Create a map using the unique identifier in each of the sub arrays.
                    if(arrayType == 'distributioncenters'){
                        String uniqueIdentifierValue = arrayKeyToFieldToValueMap.get(arrayType+arrayKey).get('distributioncenter');
                        arrayKeyToUniqueIdentifierMap.put(arrayType+arrayKey, uniqueIdentifierValue.ToLowerCase());                    
                        
                    } 
                    //Create a map using the unique identifier in each of the sub arrays.
                    if(arrayType == 'originators'){
                        String uniqueIdentifierValue = arrayKeyToFieldToValueMap.get(arrayType+arrayKey).get('firstname') + arrayKeyToFieldToValueMap.get(arrayType+arrayKey).get('lastname');
                        arrayKeyToUniqueIdentifierMap.put(arrayType+arrayKey, uniqueIdentifierValue.ToLowerCase());                    
                        
                    }
                    if(arrayType == 'subjectclassifications'){
                        String uniqueIdentifierValue = arrayKeyToFieldToValueMap.get(arrayType+arrayKey).get('code');
                        arrayKeyToUniqueIdentifierMap.put(arrayType+arrayKey, uniqueIdentifierValue.ToLowerCase());  
                    }
                    
                    if(arrayType == 'exclusionlist'){ //Case 01373482
                        String uniqueIdentifierValue = arrayKeyToFieldToValueMap.get(arrayType+arrayKey).get('name');
                        arrayKeyToUniqueIdentifierMap.put(arrayType+arrayKey, uniqueIdentifierValue.ToLowerCase());  
                    }                           
                }
                
                //Create a map of the sub array values specific for the top level object currently being processed
                //using the list of array keys which has been kept to this point.
                Map<String, String> isbnSpecificarrayKeyToUniqueIdentifierMap = new Map<String, String>();
                for(String s: arrayKeyList){                
                    isbnSpecificarrayKeyToUniqueIdentifierMap.put(s, arrayKeyToUniqueIdentifierMap.get(s));                
                }
                
                //If the code is currently in a sub array and it meets a field name.
                if(parser.getCurrentToken() == JSONToken.FIELD_NAME && isInSubArray == true){
                    //Get the field name.
                    String fieldName2 = parser.getText().ToLowerCase();              
                    previousTokenField = parser.getText().ToLowerCase();
                    //Set the previous token field.
                    parser.nextToken();
                    String fieldValue2 = parser.getText();
                    
                    //If the code has reached a start object.
                    if(parser.getCurrentToken() == JSONToken.START_OBJECT){
                        objectLevel++;  
                    }
                    //If the code has reached an end object.
                    if(parser.getCurrentToken() == JSONToken.END_OBJECT){
                        objectLevel--;  
                    }
                    Map<String,String> fieldToValueSubMap = new Map<String,String>();
                    //If the sub array level key is already in the map grab the existing values and add the new.
                    if(arrayKeyToFieldToValueMap.containskey(arrayType+arrayKey)){                    
                        fieldToValueSubMap = arrayKeyToFieldToValueMap.get(arrayType+arrayKey);
                    }                
                    fieldToValueSubMap.put(fieldName2, fieldValue2);
                    arrayKeyToFieldToValueMap.put(arrayType+arrayKey,fieldToValueSubMap); 
                }
                
                //If the code meets the start of an array.
                if (parser.getCurrentToken() == JSONToken.START_ARRAY){
                    
                    //If the array which is met is at the top level and the payload is an array.
                    if(isInTopLevelArray == False && jsonIsArray==True){
                        isInTopLevelArray = True;   
                    } else {
                        //Otherwise the array which has been met must be an sub array.
                        isInSubArray = True;
                        arrayType = previousTokenField.ToLowerCase();
                    }
                }  
                
                //If the code has met an ending array.
                if (parser.getCurrentToken() == JSONToken.END_ARRAY){
                    //If it has met a top level ending array.
                    if(isInSubArray == False){
                        isInTopLevelArray = False;   
                    } else {
                        //Otherwise it's a sub array which is ending.
                        isInSubArray = False;
                        //Set the array type = '' because the sub array has ended.
                        arrayType = '';
                    }
                }
                
                //If the code isn't in a sub array and is ending on a top level array.
                //The code below must run when an end of top level array is met because it has to have located the objects
                //ISBN number to replace the top level key with this value in the new map.
                if(parser.getCurrentToken() == JSONToken.END_OBJECT && objectLevel == 0 && isInSubArray == False){
                    
                    //Use the top level key to locate the applicable isbn and add all of its field names to values.
                    isbnToFieldToValueMap.put(keyTofieldToValueMap.get(topLevelKey).get('isbn'), keyTofieldToValueMap.get(topLevelKey));                
                    system.debug('topLevelKey=====isbnToFieldToValueMap====='+topLevelKey+'==='+isbnToFieldToValueMap.keySet());
                    
                    //Use the top level key to locate the applicable isbn and add sub array mappings.
                    isbnToArrayKeyMap.put(keyTofieldToValueMap.get(topLevelKey).get('isbn'), isbnSpecificarrayKeyToUniqueIdentifierMap);
                    arrayKeyList.clear();
                    
                    //Add the isbn to the set to be used later but only is it's not null.
                    if(keyTofieldToValueMap.get(topLevelKey).get('isbn') != 'null' && keyTofieldToValueMap.get(topLevelKey).get('isbn') != ''){
                        isbnSet.add(keyTofieldToValueMap.get(topLevelKey).get('isbn'));
                        //To be used later by the error handler.
                        isbnValue = keyTofieldToValueMap.get(topLevelKey).get('isbn'); 
                        messageKey = keyTofieldToValueMap.get(topLevelKey).get('isbn') +':'+keyTofieldToValueMap.get(topLevelKey).get('messagedate') ;
                    }
                }
            }
            
            /*
system.debug(isbnToArrayKeyMap);
system.debug(arrayKeyToFieldToValueMap);
system.debug(isbnToFieldToValueMap);
system.debug(isbnSet);
*/
            //Only run the code if isbnSet > 0.
            if(isbnSet.size()>0){
/**************************************************************************
* 
*  Create the mappings from the JSON payload to the Salesforce fields & Product Originator roles.
* 
* *************************************************************************/  
                
                //Initialize the field mappings from the Setting_Item__c object.
                //***ProductAPIMappings
                //Text_1__c = Source Field Name.
                //Text_2__c = Salesforce Field API Name.
                
                //***ProductAPIMappings_PO_Role
                //Text_1__c = API Source Role.
                //Text_2__c = Salesforce Role.
                
                //***ProductAPIMappings_ActiveStatusCodes
                //Text_1__c = Status Code Value.
                //Text_2__c = Status Code Description.            
                
                
                //List of active StatusCodes.
                Set<String> activeCodes = new Set<String>();
                
                for(Setting_Item__c si: [SELECT Setting__r.Name, Text_1__c, Text_2__c, Text_3__c
                                         FROM Setting_Item__c 
                                         WHERE (Setting__r.Name = 'ProductAPIMappings' 
                                                OR Setting__r.Name = 'ProductAPIMappings_PO_Role'
                                                OR Setting__r.Name = 'ProductAPIMappings_ActiveStatusCodes'
                                                OR Setting__r.Name = 'ProductAPI_NetbaseExclusions') AND Checkbox_1__c = TRUE]){
                                                    
                                                    if(si.Setting__r.Name == 'ProductAPIMappings'){
                                                        //Create a map for each of the object types linked to their field source names and api names.                                
                                                        Map<String, Setting_Item__c> fieldToValueMap = new Map<String, Setting_Item__c>();    
                                                        if(objectTypeToSalesforceFieldToSourceField.ContainsKey(si.Text_3__c.ToLowerCase())){         
                                                            fieldToValueMap = objectTypeToSalesforceFieldToSourceField.get(si.Text_3__c.ToLowerCase());
                                                        }                                
                                                        fieldToValueMap.put(si.Text_2__c.ToLowerCase(), si); 
                                                        objectTypeToSalesforceFieldToSourceField.put(si.Text_3__c.ToLowerCase(), fieldToValueMap);    
                                                    }                                          
                                                    if(si.Setting__r.Name == 'ProductAPIMappings_PO_Role'){
                                                        sourceRoleToSalesforceRoleMap.put(si.Text_1__c.ToLowerCase(), si.Text_2__c);
                                                    }
                                                    if(si.Setting__r.Name == 'ProductAPIMappings_ActiveStatusCodes'){
                                                        activeCodes.add(si.Text_1__c);
                                                    }            
                                                    if(si.Setting__r.Name == 'ProductAPI_NetbaseExclusions'){
                                                        netbaseExclusionSet.add(si.Text_1__c);
                                                    }                                                       
                                                }   
                
/**************************************************************************
* 
*  Product2
* 
* *************************************************************************/      
                
                List<Product2> productsToUpsertList = new List<Product2>();
                Set<String> activeISBNs = new Set<String>();
                
                //Any new Product2 records will use the T&F - Products record type.
                Id productRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();  
                
                //Loop through any existing Salesforce records for the incoming ISBNs.          
                //As we're ordering by ProductCode, IsActive desc the active Product2 records will be processed first.
                for(Product2 p: [SELECT Id, ProductCode, API_Last_Message_Date__c, System_ID__c, ESB_System_Id__c, RecordTypeId, Name, Books_Subject_Code_1__c, Books_Subject_Code_2__c
                                 ,Books_Subject_Code_3__c, Books_Subject_Description_1__c, Books_Subject_Description_2__c, Books_Subject_Description_3__c
                                 FROM Product2 WHERE ProductCode in: isbnSet AND ProductCode != null ORDER BY ProductCode, IsActive desc]){         
                                     
                                     //Remove the ISBN from the payload ISBN set so we know what's left to create.
                                     isbnSet.remove(p.ProductCode);
                                     
                                     String messageDateTime = isbnToFieldToValueMap.get(p.ProductCode).get('messagedate');
                                     if(messageDateTime.contains('T') && messageDateTime.contains('Z')){
                                         messageDateTime = messageDateTime.replace('T', ' ');
                                         messageDateTime = messageDateTime.replace('Z', ' ');                   
                                     }       
                                     
                                     //Only process the update if the incoming message date is >= the existing products API_Last_Message_Date__c or the Product's API_Last_Message_Date__c = null.
                                     if(p.API_Last_Message_Date__c == null || p.API_Last_Message_Date__c <= DateTime.ValueOf(messageDateTime)){
                                         
                                         //Call the method which maps the incoming payload fields to our Salesforce fields.
                                         processFieldUpdates(p, 'product2', null, p, p.ProductCode);
                                         
                                         //Call the method which maps the Product2 subject codes.
                                         ProductAPI.processClassifications(p);        
                                         
                                         //Process Distribution Rights. //Case - 01373482.
                                         processDistributionRights(p);
                                         
                                         //Map any additional fields which can't be mapped through the Setting__c record.
                                         
                                         //Check to see if the Product should be set to active and the ISBN doesn't already have a product which was set to active.                                     
 
                                         String isSellable = isbnToFieldToValueMap.get(p.ProductCode).get('issellable'); //Case 01375447
                                         
                                         if(!activeISBNs.contains(p.ProductCode) && isSellable.equalsIgnoreCase('true')){
                                             p.IsActive = True ;
                                             //Add the isbn to our list so we don't try to activate a duplicate Product2 record as active also.
                                             activeISBNs.add(p.ProductCode);
                                         }else {
                                                p.IsActive = False;
                                            }  
                                         p.API_Last_Message_Date__c =  DateTime.ValueOf(messageDateTime);
                                         p.System_ID__c = 'GT_TF';
                                         p.ESB_System_Id__c = 'GT_TF';
                                         p.RecordTypeId = productRecordTypeId;
                                         p.ESB_Legacy_ID__c = '[GT_TF]' + p.ProductCode;
                                         String titleName = isbnToFieldToValueMap.get(p.ProductCode).get('title');
                                         if(titleName.ToLowerCase() == 'null'){titleName = '';}
                                         String subtitleName = isbnToFieldToValueMap.get(p.ProductCode).get('subtitle'); 
                                         if(subtitleName.ToLowerCase() == 'null' || subtitleName.ToLowerCase() == ''){
                                             subtitleName = '';
                                         } else {
                                             subtitleName = ': '+subtitleName;
                                         }                                             
                                         String fullTitleName = titleName+subtitleName;  
                                         if(fullTitleName.Length()>255){
                                             fullTitleName = fullTitleName.substring(0, 255);
                                         }      
                                         p.Name = fullTitleName;
                                         //Set the lead author to blank as it will be updated below.
                                         p.Lead_Author_Editor__c = '';
                                         //Also set the UK/US inventory status and discount codes to blank as they will be updated below.
                                         p.Planned_Date__c = null;
                                         p.Publication_Date__c = null;
                                         p.US_Discount__c = '';
                                         p.US_Planned_Publication_Date__c = null;
                                         p.US_Publication_Date__c = null;
                                         p.US_Inventory_Status__c = '';
                                         p.UK_Discount__c = '';
                                         p.UK_Planned_Publication_Date__c = null;
                                         p.UK_Publication_Date__c = null;
                                         p.UK_Inventory_Status__c = '';                                       
                                         productsToUpsertList.add(p);                    
                                     }
                                 }
                
                //Loop through the remaining ISBNs and create new Product2 Records.
                System.debug('=====isbnSet===='+isbnSet);
                for(String isbn: isbnSet){         
                    Product2 p = new Product2();

                    String messageDateTime = isbnToFieldToValueMap.get(isbn).get('messagedate');
                    if(messageDateTime.contains('T') && messageDateTime.contains('Z')){
                        messageDateTime = messageDateTime.replace('T', ' ');
                        messageDateTime = messageDateTime.replace('Z', ' ');                   
                    }                                                   
                    //Call the method which maps the incoming payload fields to our Salesforce fields.
                    processFieldUpdates(p, 'product2', null, p, isbn);
                    
                    //Call the method which maps the Product2 subject codes.
                    ProductAPI.processClassifications(p);

                    //Process Distribution Rights. //Case - 01373482.
                    processDistributionRights(p);
                                             
                    //Map any additional fields which can't be mapped through the Setting__c record.

                    //Check to see if the Product should be set to active and the ISBN doesn't already have a product which was set to active.  
                    
                    String isSellable = isbnToFieldToValueMap.get(isbn).get('issellable'); //Case 01375447
                                   
                    if(!activeISBNs.contains(isbn) && isSellable.equalsIgnoreCase('true')){
                           p.IsActive = True;
                           //Add the isbn to our list so we don't try to activate a duplicate Product2 record as active also.
                           activeISBNs.add(isbn);
                       } else {
                           p.IsActive = False;
                       }                                              
                    
                    p.API_Last_Message_Date__c =  DateTime.ValueOf(messageDateTime);
                    p.System_ID__c = 'GT_TF';
                    p.ESB_System_Id__c = 'GT_TF';
                    p.RecordTypeId = productRecordTypeId;
                    p.ESB_Legacy_ID__c = '[GT_TF]' + p.ProductCode;
                    String titleName = isbnToFieldToValueMap.get(isbn).get('title');
                    if(titleName.ToLowerCase() == 'null'){titleName = '';}
                    String subtitleName = isbnToFieldToValueMap.get(isbn).get('subtitle');
                    if(subtitleName.ToLowerCase() == 'null' || subtitleName.ToLowerCase() == ''){
                        subtitleName = '';
                    } else {
                        subtitleName = ': '+subtitleName;
                    }                      
                    String fullTitleName = titleName+subtitleName;  
                    if(fullTitleName.Length()>255){
                        fullTitleName = fullTitleName.substring(0, 255);
                    }
                    p.Name = fullTitleName;
                    productsToUpsertList.add(p);                                       
                }
                
                if(productsToUpsertList.size()>0){upsert productsToUpsertList;}
                
                List<Id> fullProductIdList = new List<Id>();
                //Create a list of all Product2 ids.
                for(Product2 p: [SELECT Id, ProductCode FROM Product2 WHERE Id in: productsToUpsertList AND ProductCode != null ORDER BY ProductCode, IsActive Desc]){            
                    fullProductIdList.add(p.Id);
                }
                
                Map<String, String> dacVersionTypeToIsbn = new Map<String, String>();
                //Example {C2009-0-08735-8e-Book: 12345}
                
                //Loop through the DacKeys to link the different version types.
                if(dacKeySet.size()>0){
                for(Product2 p: [SELECT ProductCode, eBook_ISBN__c, Paperback_ISBN__c, Hardback_ISBN__c, Version_Type__c, DAC_Key__c
                                 FROM Product2 WHERE DAC_Key__c in: dacKeySet AND Version_Type__c != null AND DAC_Key__c != null]){
                                 dacVersionTypeToIsbn.put(p.DAC_Key__c.ToLowerCase()+p.Version_Type__c.ToLowerCase(), p.ProductCode);    
                    
                }
                List<Product2> productsToUpdateDacLink = new List<Product2>();
                //Loop back through to update the products using the newly created map.
                for(Product2 p: [SELECT ProductCode, eBook_ISBN__c, Paperback_ISBN__c, Hardback_ISBN__c, Version_Type__c, DAC_Key__c
                                 FROM Product2 WHERE DAC_Key__c in: dacKeySet AND Version_Type__c != null AND DAC_Key__c != null]){
                                 p.Paperback_ISBN__c = dacVersionTypeToIsbn.get(p.DAC_Key__c.ToLowerCase()+'paperback');
                                 p.Hardback_ISBN__c = dacVersionTypeToIsbn.get(p.DAC_Key__c.ToLowerCase()+'hardback');
                                 p.eBook_ISBN__c = dacVersionTypeToIsbn.get(p.DAC_Key__c.ToLowerCase()+'e-book');
                                 productsToUpdateDacLink.add(p);
                    
                }                    
                    if(productsToUpdateDacLink.size()>0){update productsToUpdateDacLink;}    
                }
                
                
                
                //Only process the remaining updates if a Product2 record was updated/inserted.
                
                if(fullProductIdList.size()>0){
/**************************************************************************
* 
*  PricebookEntry (Pricing)
* 
* *************************************************************************/
                    
                    Set<Id> existingPricebookIds = new Set<Id>();
                    for(PricebookEntry pe: [SELECT Id, IsActive, UnitPrice, Product2.ProductCode, CurrencyIsoCode, Pricebook2.Name, Product2.Id, Pricing_Type__c
                                            FROM PricebookEntry WHERE Product2Id in: fullProductIdList]){
                        String keyValue = pe.CurrencyIsoCode+pe.Pricebook2.Name;
                        //pe.Product2.Id is added after because it's case sensitive so can't be .ToLowerCase().
                        existingProduct2IdCurrencyPricebookKeyToPricebookEntry.put(pe.Product2.Id+keyValue.ToLowerCase(), pe);  
                        existingPricebookIds.add(pe.Id);
                    }
                    
                    //Create a list of valid CurrencyISOCodes
                    List<String> validCurrenciesList = new List<String>();
                    Schema.DescribeFieldResult fieldResult = PricebookEntry.CurrencyIsoCode.getDescribe();
                    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                    for( Schema.PicklistEntry pickListVal : ple){
                        validCurrenciesList.add(pickListVal.getValue().ToLowerCase());
                    }           
                    
                    //Map<String, Set<String>> isbnToExistingCurrenciesMap = new Map<String, Set<String>>();
                    List<PricebookEntry> pricebookEntriesToUpsert = new List<PricebookEntry>();
                    List<PricebookEntry> StandardpricebookEntriesToUpsert = new List<PricebookEntry>();
                                       
                    
                    
                    
                    Set<String> pbeRecordsProcessed = new Set<String>();
                    
                    for(Product2 p: [SELECT Id, ProductCode, IsActive FROM Product2 WHERE Id in: fullProductIdList]){
                        
                         Set<String> currenciesWithRetailPriceProcessed = new Set<String>();
                         List<String> currenciesWithBYOPriceProcessed = new List<String>();
                        //Locate the related record from the JSON payload.
                        For(String ss: isbnToArrayKeyMap.get(p.ProductCode).keyset()){
                            
                            if(ss.Containsignorecase('pricing')){ //This identifies that the array is of the pricing type.    
                                
                                //Locate the pricing type.
                                String priceTypeCode = arrayKeyToFieldToValueMap.get(ss).get('pricetypecode');
                                priceTypeCode = priceTypeCode.ToLowerCase();     
                                currencyValue = arrayKeyToUniqueIdentifierMap.get(ss).ToLowerCase();
                                
                                //Only process the insert/update if the currency is valid in Salesforce and is a retail price priceTypeCode = "LP".
                                //or if the product is an eBook and the pricing type = "byo" or "IS".
                                if(
                                    validCurrenciesList.Contains(currencyValue) && 
                                    (priceTypeCode == 'lp' || priceTypeCode == 'byo' || priceTypeCode == 'is')
                                    
                                ){                                    
                                    
                                    //Create a set of pricebooks which need updating to loop through.
                                    Set<String> pricebooksToUpdate = new Set<String>{'standard'};
                                        if(priceTypeCode == 'lp'){pricebooksToUpdate.add('tandf');}
                                        if(isbnToFieldToValueMap.get(p.ProductCode).get('versiontypecode').ToLowerCase() == 'ebk' && (priceTypeCode == 'byo' || priceTypeCode == 'is')){pricebooksToUpdate.add('ebook');}    
                                    
                                    for(String s: pricebooksToUpdate){
                                                                                
                                        String priceBookName = '';
                                        Id priceBookId;
                                        if(priceTypeCode == 'lp'){currenciesWithRetailPriceProcessed.add(currencyValue);}
                                        if(priceTypeCode == 'byo'){currenciesWithBYOPriceProcessed.add(currencyValue);}
                                        if(s == 'standard'){priceBookName=standardPriceBook.Name.ToLowerCase(); priceBookId=standardPriceBook.Id;}
                                        if(s == 'tandf'){priceBookName=tfPriceBook.Name.ToLowerCase(); priceBookId=tfPriceBook.Id;}
                                        if(s == 'ebook'){priceBookName=ebookPriceBook.Name.ToLowerCase(); priceBookId=ebookPriceBook.Id;}
                                        
                                        //Not already processed a retail for the currency in the standard pricebook and the price being processed is BYO.
                                        if((!currenciesWithRetailPriceProcessed.contains(currencyValue) && priceTypeCode == 'byo' && s=='standard')
                                           //Not already processed a retail for the currency or BYO in the standard pricebook and the price being processed is Institutional.
                                           || (!currenciesWithRetailPriceProcessed.contains(currencyValue) && !currenciesWithBYOPriceProcessed.contains(currencyValue) && priceTypeCode == 'is' && s=='standard')
                                           //The price being process is Institutional and a BYO price hasn't already been processed for that currency and the pricebook is eBooks.
                                           || (priceTypeCode == 'is' && s == 'ebook' && !currenciesWithBYOPriceProcessed.contains(currencyValue))
                                           //The price being processed is BYO and the pricebook is eBooks.
                                           || (priceTypeCode == 'byo' && s == 'ebook')
                                           //The price being processed is retail and the pricebook is not eBooks.
                                           || (priceTypeCode == 'lp' && s != 'ebook')){                                        
                                                                                                               
                                    String updateType = 'insert';
                                    Boolean priceChange = true;
                                    Boolean pricingTypeChange = true;
                                    Boolean existingPricebookEntryIsInactive = true;
                                    PricebookEntry pe = new PricebookEntry();
                                    Decimal priceBeforeUpdate = 0;
                                               
                                    String pricingType = '';
                                              if(priceTypeCode=='lp'){pricingType='Retail';}
                                              if(priceTypeCode=='byo'){pricingType='BYO';}
                                              if(priceTypeCode=='is'){pricingType='Institutional';}                                               
                                    
                                    //Check if the Pricebook Entry is already in Salesforce.
                                    if(existingProduct2IdCurrencyPricebookKeyToPricebookEntry.ContainsKey(p.Id+currencyValue+priceBookName)){
                                        pe = existingProduct2IdCurrencyPricebookKeyToPricebookEntry.get(p.Id+currencyValue+priceBookName);  
                                        updateType = 'update';
                                        priceBeforeUpdate = pe.UnitPrice;
                                        //Check to see if the price is changing.
                                        priceChange = pe.UnitPrice == Decimal.ValueOf(arrayKeyToFieldToValueMap.get(ss).get('price')) ? false : true;
                                        //Check to see if the pricing type is changing.
                                        pricingTypeChange = pe.Pricing_Type__c == pricingType ? false : true; 
                                        //Check to see if the existing pricebookentry is inactive.
                                        existingPricebookEntryIsInactive = pe.IsActive == false ? true : false;
                                    }     
                                    
                                    processPriceUpdates(updateType, pe, priceBookId, arrayKeyToFieldToValueMap.get(ss).get('currency'), p.Id, Decimal.ValueOf(arrayKeyToFieldToValueMap.get(ss).get('price')), pricingType);
                                    //System.debug(currencyValue);  
                                    //System.debug(priceTypeCode);  
                                    //System.debug(priceBookName);
                                    //System.debug(currenciesWithRetailPriceProcessed);
                                    
                                    //If the price is "byo" or "is" and a retail price hasn't already been added to the standard pricebook make the standard pricebook value 0.
                                    if(!currenciesWithRetailPriceProcessed.contains(currencyValue) && (priceTypeCode == 'byo' || priceTypeCode == 'is') && priceBookName==standardPriceBook.Name.ToLowerCase()){
                                        //If the currency doesn't already have a standard pricebook entry set the unitprice to 0.
                                        if(!existingProduct2IdCurrencyPricebookKeyToPricebookEntry.containskey(p.Id+currencyValue+standardPriceBook.Name.ToLowerCase())){
                                        pe.UnitPrice = 0;   
                                        } else {pe.UnitPrice=priceBeforeUpdate;}
                                        pe.IsActive = false;
                                    }               
                                        
                                    //Only add the price if it's being changed or is an insert.
                                    if(updateType=='insert' || (updateType=='update' && (pricingTypeChange == true || priceChange == true || existingPricebookEntryIsInactive == true))){                        
                                        //If the pricebookentry has already been added to the list remove it and add the new update.
                                        //If the update/insert is for the standard pricebook. This had to be split because the standard pricebookentry
                                        //needs to be created before any other pricebook entries can be added.
                                        if(priceBookName==standardPriceBook.Name.ToLowerCase()){
                                        if(StandardpricebookEntriesToUpsert.contains(pe)){
                                            Integer i = StandardpricebookEntriesToUpsert.indexOf(pe);
                                            StandardpricebookEntriesToUpsert.remove(i);                                                
                                        }
                                            StandardpricebookEntriesToUpsert.add(pe);                                                
                                            
                                        } else {
                                            if(pricebookEntriesToUpsert.contains(pe)){
                                                Integer i = pricebookEntriesToUpsert.indexOf(pe);
                                                pricebookEntriesToUpsert.remove(i);                                                
                                            }
                                            pricebookEntriesToUpsert.add(pe);    
                                        }
                                    }
                                    
                                    existingProduct2IdCurrencyPricebookKeyToPricebookEntry.put(p.Id+currencyValue+priceBookName, pe);    
                                    //Add the record to the list of records that have been processed.
                                    pbeRecordsProcessed.add(p.Id+currencyValue+priceBookName);
                                    //Set back to true ready to be evaluated again.
                                    priceChange = true;
                                    existingPricebookEntryIsInactive = true;
                                    }
                                    }                                
                                }
                            }             
                        }
                    }                
                    //for(Pricebookentry p: pricebookEntriesToUpsert){system.debug(p.pricebook2Id+p.CurrencyIsoCode+p.UnitPrice);}

                    //Loop through the existing pricebook entries to makew anything which wasn't processed 0.
                    for(Pricebookentry pbe: [SELECT Id, Product2.Id, CurrencyIsoCode, Pricebook2.Name
                                             FROM Pricebookentry WHERE Id in: existingPricebookIds]){
                        String keyValuePBE = pbe.CurrencyIsoCode+pbe.Pricebook2.Name;
                        //If the PBE hasn't been updates/processed. Note anything where a price hasn't changed will be included in "existingProduct2IdCurrencyPricebookKeyToPricebookEntry"
                        //so that prices which haven't changed don't get overwritten.
                        if(!pbeRecordsProcessed.contains(pbe.Product2.Id+keyValuePBE.ToLowerCase())){
                          pbe.IsActive=false;
                          pricebookEntriesToUpsert.add(pbe);  
                        }
                    }
                    
                    
                    
                    //This had to be split because a standard pricebookentry needs to be created before any others can be added.
                    if(StandardpricebookEntriesToUpsert.size()>0){upsert StandardpricebookEntriesToUpsert;}
                    if(pricebookEntriesToUpsert.size()>0){upsert pricebookEntriesToUpsert;}
                                      
/**************************************************************************
* 
*  Product_Originator__c (originators)
* 
* *************************************************************************/   
                    
                    List<Product_Originator__c> existingPORecordList = new List<Product_Originator__c>();
                    for(Product_Originator__c po: [SELECT Id, Originator_Name__c, First_Name__c, Last_Name__c, Product__r.ProductCode 
                                                   FROM Product_Originator__c WHERE Product__c in: fullProductIdList]){
                                                       existingPORecordList.add(po);
                                                   }
                    
                    List<Product_Originator__c> productOriginatorsToInsert = new List<Product_Originator__c>();
                    List<Product2> productsToUpdateOnPO = new List<Product2>();
                    
                    for(Product2 p: [SELECT Id, ProductCode FROM Product2 WHERE Id in: fullProductIdList]){
                        
                        Boolean productNeedsUpdate = false;
                        String leadAuthorValue = '';
                        
                        //Locate the related record from the JSON payload.
                        For(String ss: isbnToArrayKeyMap.get(p.ProductCode).keyset()){
                            
                            if(ss.Containsignorecase('originators')){ //This identifies that the array is of the originators type.
                                String originatorName = arrayKeyToUniqueIdentifierMap.get(ss).ToLowerCase();
                                Product_Originator__c po = new Product_Originator__c();
                                po.Product__c = p.Id; 
                                
                                //Map the incoming payload fields to our Salesforce fields.
                                ProductAPI.processFieldUpdates(po, 'product_originator__c', ss, p, p.ProductCode);
                                
                                String poName = po.First_Name__c + ' ' + po.Last_Name__c;
                                if(poName.Length()>80){poName = poName.substring(0,80);}
                                po.Name = poName;
                                productOriginatorsToInsert.add(po);   
                                
                                //If the Product Originator Display_Order__c = 1.
                                if(po.Display_Order__c == 1){
                                    if(leadAuthorValue == ''){
                                        leadAuthorValue = poName;
                                    } else {
                                        leadAuthorValue += '; ' + poName;    
                                    }
                                    p.Lead_Author_Editor__c = leadAuthorValue;                                  
                                    productNeedsUpdate = true;
                                    
                                }                           
                            }
                        }
                        if(productNeedsUpdate == true && !productsToUpdateOnPO.contains(p)){productsToUpdateOnPO.add(p);}
                    }           
                    if(productsToUpdateOnPO.size()>0){update productsToUpdateOnPO;}
                    if(productOriginatorsToInsert.size()>0){insert productOriginatorsToInsert;}
                    //Delete out any existing Product_Originator__c records and add the new from the incoming payload.        
                    if(existingPORecordList.size()>0){delete existingPORecordList;}
                    
/**************************************************************************
* 
*  Product_Geographical_Information__c (distributionCenters)
* 
* *************************************************************************/    
                    
                    List<Product_Geographical_Information__c> existingPGIRecordList = new List<Product_Geographical_Information__c>();
                    for(Product_Geographical_Information__c pgi: [SELECT Id, Name, Product__r.ProductCode 
                                                                  FROM Product_Geographical_Information__c WHERE Product__c in: fullProductIdList]){
                                                                      existingPGIRecordList.add(pgi);
                                                                  }      
                    
                    //Any new Product2 records will use the T&F - Products record type.
                    Id pgiRecordTypeId = Schema.SObjectType.Product_Geographical_Information__c.getRecordTypeInfosByName().get('T&F - Publish Info').getRecordTypeId();
                    
                    List<Product_Geographical_Information__c> productGeographicalInformationToInsert = new List<Product_Geographical_Information__c>();
                    List<Product2> productsToUpdate = new List<Product2>();
                    
                    for(Product2 p: [SELECT Id,Planned_Date__c,Publication_Date__c, ProductCode,
                                     US_Discount__c,US_Planned_Publication_Date__c,US_Publication_Date__c,US_Inventory_Status__c,
                                     UK_Discount__c,UK_Planned_Publication_Date__c,UK_Publication_Date__c,UK_Inventory_Status__c
                                     FROM Product2 WHERE Id in: fullProductIdList]){
                                         
                                         //Identifies if a product needs to be updated.
                                         Boolean updateNeeded = False;
                                         
                                         //Locate the related record from the JSON payload.
                                         For(String ss: isbnToArrayKeyMap.get(p.ProductCode).keyset()){
                                             
                                             if(ss.Containsignorecase('distributioncenters')){ //This identifies that the array is of the distributionCenters type.
                                                 String distributionCenterName = arrayKeyToUniqueIdentifierMap.get(ss).ToLowerCase();
                                                 
                                                 Product_Geographical_Information__c pgi = new Product_Geographical_Information__c();
                                                 string distributionCenterCode = arrayKeyToFieldToValueMap.get(ss).get('distributioncentercode').ToLowerCase();
                                                 
                                                 //Map the incoming payload fields to our Salesforce fields.
                                                 ProductAPI.processFieldUpdates(pgi, 'product_geographical_information__c', ss, p, p.ProductCode);
                                                 
                                                 //If the Distribution Center is primary update the associated fields on the Product2 record.                                       
                                                     
                                                 
                                                 if(pgi.Primary_Distribution_Center__c == True){
                                                     p.Planned_Date__c = pgi.Planned_Date__c;
                                                     p.Publication_Date__c = pgi.Publish_Date__c;
                                                     updateNeeded = True;
                                                 }
                                                 
                                                 //If the Distribution Center is UK/US update the associated fields on the Product2 record.
                                                 if(distributionCenterCode == 'usny'){
                                                     p.US_Discount__c = pgi.Discount_Code__c;
                                                     p.US_Planned_Publication_Date__c = pgi.Planned_Date__c;
                                                     p.US_Publication_Date__c = pgi.Publish_Date__c;
                                                     p.US_Inventory_Status__c = pgi.Status__c;
                                                     updateNeeded = True;                    
                                                 }  
                                                 if(distributionCenterCode == 'loc1'){
                                                     p.UK_Discount__c = pgi.Discount_Code__c;
                                                     p.UK_Planned_Publication_Date__c = pgi.Planned_Date__c;
                                                     p.UK_Publication_Date__c = pgi.Publish_Date__c;
                                                     p.UK_Inventory_Status__c = pgi.Status__c;
                                                     updateNeeded = True;                    
                                                 }                                                                  
                                                 
                                                 pgi.Product__c = p.Id;
                                                 productGeographicalInformationToInsert.add(pgi);                                
                                             }
                                         }
                                         //If the Product2 record is already in the list to be updated don't add it again.
                                         if(updateNeeded == True && !productsToUpdate.contains(p)){productsToUpdate.add(p);}                                     
                                         
                                     }
                    
                    if(productGeographicalInformationToInsert.size()>0){insert productGeographicalInformationToInsert;}
                    //Delete out any existing Product_Originator__c records and add the new from the incoming payload.        
                    if(existingPGIRecordList.size()>0){delete existingPGIRecordList;}  
                    
                    if(productsToUpdate.size()>0){update productsToUpdate;}
                    
                } 
                
                
                //If the payload which has successfully been processed had previously caused an error flag it as resolved.
                List<Setting_Item__c> settingItemsToUpdate = new List<Setting_Item__c>();
                for(Setting_Item__c si: [SELECT Checkbox_1__c FROM Setting_Item__c WHERE Text_3__c =: messageKey AND Setting__r.Name = 'ProductAPI_ErrorLogs']){
                    si.Checkbox_1__c = true;
                    settingItemsToUpdate.add(si);
                }
                if(settingItemsToUpdate.size()>0){update settingItemsToUpdate;}
            }
            
            return 'Successful Update/Insert';
            
        } catch(exception e){
            system.debug('exception details' + e.getStackTraceString());
            string myString = 'ERROR: '+ e.getMessage() +' on line ' + e.getLineNumber() +' '+'ISBN: ' + isbnValue+'</br>'+' payload: '+jsonString;
            string responseBody = 'ERROR: '+ e.getMessage() +' on line ' + e.getLineNumber();
            //Locate the email addresses which the error should be sent to.
            boolean createErrorLog = false;
            boolean sendErrorEmail = false;
            List<String> toAddressList = new List<String>();
            for(ProductAPISettings__c ps: [SELECT Error_Recipient_Email_Address__c, Send_Error_Emails__c, Create_Setting_Item_Error_Logs__c FROM ProductAPISettings__c LIMIT 1]){
                toAddressList = ps.Error_Recipient_Email_Address__c.Split(',');
                if(ps.Create_Setting_Item_Error_Logs__c == true){createErrorLog = true;}
                if(ps.Send_Error_Emails__c == true){sendErrorEmail = true;}
            }
            
            //If the JSON string is too long to store in a setting item.
            jsonString = jsonString.length() > 32768 ? jsonString.substring(0, 32768) : jsonString;
            
            //If the error message is too long to store in a setting item.
            responseBody = responseBody.length() > 255 ? responseBody.substring(0, 255) : responseBody;
            List<Setting_Item__c> errorList = new List<Setting_Item__c>();
            if(createErrorLog == True){
                Id settingRecordId = [SELECT Id FROM Setting__c WHERE Name = 'ProductAPI_ErrorLogs'].Id;
                Setting_Item__c newErrorLog = new Setting_Item__c();
                newErrorLog.Setting__c = settingRecordId;
                newErrorLog.Text_1__c = String.ValueOf(system.now());
                newErrorLog.Text_2__c = responseBody;
                newErrorLog.Text_3__c = messageKey;
                newErrorLog.Long_Text_1__c = jsonString;
                
                for(Setting_Item__c si: [SELECT Text_3__c, Text_2__c 
                                         FROM Setting_Item__c WHERE Text_3__c =: newErrorLog.Text_3__c
                                         AND Text_3__c != ''
                                         AND Setting__r.Name = 'ProductAPI_ErrorLogs']){
                                             
                                             //If the error is already stored update it with the latest error message.
                                             si.Text_2__c = responseBody;
                                             errorList.add(si);
                                         }
                
                //If an existing error hasn't been added add the new one we've just created.
                if(errorList.size()==0){errorList.add(newErrorLog);}
                
                if(errorList.size()>0){upsert errorList;}
            }
            
            
            if(toAddressList.size()>0 && sendErrorEmail == true){   
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = toAddressList;
                mail.setSubject('ProductAPI Exception');
                mail.setHtmlBody(myString);
                mail.setToAddresses(toAddresses);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
            
            return responseBody;
            
        }
    }
    
    public static void processClassifications(Product2 record){
        //Set all subject code to blank.
        record.Subject_Code__c = '';
        record.Books_Subject_Code_1__c = '';
        record.Books_Subject_Code_2__c = '';
        record.Books_Subject_Code_3__c = '';
        record.Books_Subject_Description_1__c = '';
        record.Books_Subject_Description_2__c = '';
        record.Books_Subject_Description_3__c = '';
        record.Subject_Classifications__c = '';
        record.Netbase_Classifications__c = '';
        
        //Set the variable used to identify how many subject codes have been populated to 1.
        Integer subjectCodesMapped = 0;
        String subjectCodeString = '';
        String fullSubjectCodeString = '';
        String fullNetbaseString = '';
        //added by Siddhant
        List<netbaseWrapper> netWrapperList = new List<netbaseWrapper>();
        set<string> netCodeSet = new set<string>();
        //Loop through the Subject Codes from the payload.
        For(String ss: isbnToArrayKeyMap.get(record.ProductCode).keyset()){
            //added by Siddhant
            netbaseWrapper netBase = new netbaseWrapper();
            if(ss.Containsignorecase('netbaseclassifications')){
                String netBaseCode = arrayKeyToFieldToValueMap.get(ss).get('code');
                //added by Siddhant
                netBase.code = netBaseCode;
                
                //If the Netbase code isn't in the exclusion list add it.
                if(!netbaseExclusionSet.contains(netBaseCode)){                
                String netBaseDescription = arrayKeyToFieldToValueMap.get(ss).get('description');
                //added by Siddhant
                netBase.description = netBaseDescription;
                fullNetbaseString = netBaseCode + ' - ' + netBaseDescription + ';';
                fullNetbaseString = fullNetbaseString.replace('null - null','');
                record.Netbase_Classifications__c += fullNetbaseString;
                //Added by Siddhant
                System.debug('---> netBaseCode'+netBaseCode);

                string likeNetbase = netBaseCode+ ' - ' +netBaseDescription;
                netCodeSet.add(likeNetbase);
                //added by Siddhant
                netWrapperList.add(netBase); 
                }
                
                
                 
            }
            
            if(ss.Containsignorecase('subjectclassifications')){ //This identifies that the array is of the Subject Code type.
                String subjectCodeValue = arrayKeyToUniqueIdentifierMap.get(ss);
                if(subjectCodeValue.ToLowerCase() == 'null'){subjectCodeValue = '';}
                boolean subjectCodeMapped = false;
                
                //If Subejct Code Level 1.
                if(subjectCodesMapped == 0){
                    record.Books_Subject_Code_1__c = arrayKeyToFieldToValueMap.get(ss).get('code');
                    record.Books_Subject_Description_1__c = arrayKeyToFieldToValueMap.get(ss).get('description');
                    subjectCodeMapped = true;
                    subjectCodeString = record.Books_Subject_Code_1__c+' - '+record.Books_Subject_Description_1__c;
                }
                //If Subejct Code Level 2.
                if(subjectCodesMapped == 1){
                    record.Books_Subject_Code_2__c = arrayKeyToFieldToValueMap.get(ss).get('code');
                    record.Books_Subject_Description_2__c = arrayKeyToFieldToValueMap.get(ss).get('description');
                    subjectCodeMapped = true;
                    subjectCodeString+= ';'+record.Books_Subject_Code_2__c+' - '+record.Books_Subject_Description_2__c;
                }                            
                //If Subejct Code Level 3.
                if(subjectCodesMapped == 2){
                    record.Books_Subject_Code_3__c = arrayKeyToFieldToValueMap.get(ss).get('code');
                    record.Books_Subject_Description_3__c = arrayKeyToFieldToValueMap.get(ss).get('description');
                    subjectCodeMapped = true; 
                    subjectCodeString+= ';'+record.Books_Subject_Code_3__c+' - '+record.Books_Subject_Description_3__c;
                }   
                
                //If a subject code has been mapped during the loop increment which subject code needs to be mapped next.
                if(subjectCodeMapped==true){subjectCodesMapped++;}
                //Create the full subject code string.
                fullSubjectCodeString += arrayKeyToFieldToValueMap.get(ss).get('code') + ' - ' + arrayKeyToFieldToValueMap.get(ss).get('description') + ';';
                fullSubjectCodeString = fullSubjectCodeString.replace('null - null','');
                subjectCodeString = subjectCodeString.replace('null','');
                record.Subject_Code__c = subjectCodeString;
                record.Subject_Classifications__c = fullSubjectCodeString;
            }
        }
        // added by Siddhant
        // ------------------------------------------------------------------------------------------- 
        try{      
       if(netWrapperList.size()>0 && netCodeSet.size()>0){
            
            string netbaseSettingId = '';
            List<netbaseWrapper> listToInsert = new List<netbaseWrapper>();
            system.debug('--->netCodeSet'+netCodeSet);
            List<Setting_Item__c> netbaseBackEndItems = new List<Setting_Item__c>([SELECT Text_1__c,Setting__c from Setting_Item__c where Text_1__c IN : netCodeSet and Setting__r.Name = 'NetbaseClassifications' and Checkbox_1__c = true]);
            if(netbaseBackEndItems.size()>0){
                for(netbaseWrapper nbw : netWrapperList){
                    Boolean itemResides = False;
                for(Setting_Item__c setItem : netbaseBackEndItems){
                    netbaseSettingId = setItem.Setting__c;
                    if(setItem.Text_1__c.containsIgnoreCase(nbw.code)){
                        itemResides = True;
                    }
                }
                if(itemResides == false){
                    listToInsert.add(nbw);
                }
            }
            }
            else{
               listToInsert.addAll(netWrapperList); 
            }
            if(listToInsert.size()>0){
                if(netbaseSettingId == ''){
                    netbaseSettingId = [Select Id from Setting__c where Name = 'NetbaseClassifications' Limit 1].Id;
                }

                List<Setting_Item__c> netInsertList = new List<Setting_Item__c>();
                for(netbaseWrapper nbwi : listToInsert){
                    Setting_Item__c itemToInsert = new Setting_Item__c();
                    itemToInsert.Setting__c = netbaseSettingId;
                    if(nbwi.description != null){
                       nbwi.code =  nbwi.code+' - '+nbwi.description;
                    }
                    itemToInsert.Text_1__c = nbwi.code;
                    itemToInsert.Checkbox_1__c = True;
                    netInsertList.add(itemToInsert);
                }
                if(netInsertList.size()>0){
                    insert netInsertList;
                }
            }
        }
        }
        catch(Exception e){
            system.debug(e.getLineNumber());
            system.debug(e.getMessage());
        }

        // -------------------------------------------------------------------------------------------       
    }
    
    public static set<String> processFieldUpdates(sObject record, String objectType, String arrayKey, Product2 productRecord, String isbn){
        
        //Fields updated via the method.
        Set<String> apiFieldNamesMapped = new Set<String>();
        
        //Only loop through the fields if the setting map contains values for the object type.
        if(objectTypeToSalesforceFieldToSourceField.containskey(objectType)){
            //Loop through the fields which should be mapped on PricebookEntry.
            for(String sv: objectTypeToSalesforceFieldToSourceField.get(objectType).keyset()){ 
                
                String fieldType = getDataType(objectType, sv);   
                //If the incoming has an arrayKey.
                String fieldValue = '';
                if(arrayKey != null){
                    fieldValue = arrayKeyToFieldToValueMap.get(arrayKey).get(objectTypeToSalesforceFieldToSourceField.get(objectType).get(sv).Text_1__c.ToLowerCase());
                } else {
                    fieldValue = isbnToFieldToValueMap.get(isbn).get(objectTypeToSalesforceFieldToSourceField.get(objectType).get(sv).Text_1__c.ToLowerCase());
                }
                
                if(fieldValue == 'null' || fieldValue == null){fieldValue = '';}
                String fieldName = sv.ToLowerCase(); 
                apiFieldNamesMapped.add(fieldName);       
                
                //If the incoming field is "dac" add it to the dacKeySet to be used later.
                if(fieldName=='dac_key__c' && fieldValue != null && fieldValue != ''){dacKeySet.add(fieldValue);}
                
                //Get the max length of each field to ensure the code doesn't fail if a string which is too long is pushed into a field.
                SObjectType r = ((SObject)(Type.forName('Schema.'+objectType).newInstance())).getSObjectType();
                DescribeSObjectResult d = r.getDescribe();
                Integer maxLengthOfField = d.fields.getMap().get(fieldName).getDescribe().getLength();
                
                Integer valueLength = fieldValue == '' ? 0 : fieldValue.length();
                
                if((fieldType.toLowerCase() == 'string' ||  fieldType.toLowerCase() == 'textarea') && valueLength > maxLengthOfField){
                    fieldValue = fieldValue.substring(0, maxLengthOfField);
                }
                
                //If the field is Role__c the mappings need to be used to ensure a bad value isn't pushed into Salesforce.
                if(objectType == 'product_originator__c' && sv == 'role__c' && sourceRoleToSalesforceRoleMap.ContainsKey(fieldValue.ToLowerCase())){
                    fieldValue = sourceRoleToSalesforceRoleMap.get(fieldValue.ToLowerCase());
                }                       
                
                //If the type is DateTime convert the string to DateTime.
                if(fieldType.toLowerCase() == 'datetime'){
                    String dateValue = fieldValue;
                    if(fieldValue.contains('T') && fieldValue.contains('Z')){
                        dateValue = fieldValue.replace('T', ' '); 
                        dateValue = dateValue.replace('Z', ' ');
                    }
                    if(dateValue == ''){record.put(fieldName, null);} else { record.put(fieldName, DateTime.ValueOf(dateValue)); }                            
                    
                } 
                
                if(fieldType.toLowerCase() == 'date'){
                    String dateValue = fieldValue;
                    if(fieldValue.contains('T') && fieldValue.contains('Z')){
                        dateValue = fieldValue.replace('T', ' '); 
                        dateValue = dateValue.replace('Z', ' ');
                    }
                    if(dateValue == ''){record.put(fieldName, null);} else{ record.put(fieldName, Date.ValueOf(dateValue)); }                            
                }                         
                
                if(fieldType.toLowerCase() == 'decimal' || fieldType.toLowerCase() == 'currency' || fieldType.toLowerCase() == 'double' || fieldType.toLowerCase() == 'integer'){
                    record.put(fieldName, Decimal.ValueOf(fieldValue)); 
                }  
                
                if(fieldType.toLowerCase() == 'boolean'){
                    record.put(fieldName, Boolean.ValueOf(fieldValue)); 
                }                     
                
                if(fieldType.toLowerCase() != 'boolean' && fieldType.toLowerCase() != 'date' && fieldType.toLowerCase() != 'datetime' && fieldType.toLowerCase() != 'decimal' && fieldType.toLowerCase() != 'currency' && fieldType.toLowerCase() != 'decimal' && fieldType.toLowerCase() != 'double' && fieldType.toLowerCase() != 'integer'){
                    record.put(fieldName, fieldValue);
                }   
            }    
        }
        return apiFieldNamesMapped;        
    }
    
    public static void processPriceUpdates(String updateType, Pricebookentry newPBE, Id pricebookId, String currencyVal, Id productId, Decimal unitPriceVal, String pricingType){

        //Map the PricebookEntry fields.                                                
        newPBE.UnitPrice = unitPriceVal;
        newPBE.UseStandardPrice = False;
        newPBE.Pricing_Type__c = pricingType;
        if(updateType=='insert'){
        newPBE.Product2Id = productId;
        newPBE.Pricebook2Id = pricebookId;
        newPBE.CurrencyIsoCode = currencyVal.toUpperCase();
        }        
        //Activate the PricebookEntry. We're only going to active/deactivate at the product level.
        newPBE.IsActive = True;     
    }   
    
    public static String getDataType(String objectName,String fieldName){   
        SObjectType r = ((SObject)(Type.forName('Schema.'+objectName).newInstance())).getSObjectType();
        DescribeSObjectResult d = r.getDescribe();
        //system.debug(String.ValueOf(d.fields.getMap().get(fieldName).getDescribe().getType()));
        return String.ValueOf(d.fields.getMap().get(fieldName).getDescribe().getType());
    }
    
    //Case - 01373482.
    public static void processDistributionRights(Product2 productRecord){
        
        String drValue1 = '';
        String drValue2 = '';
        String drValue3 = '';
        Integer drloopValue = 1;
        
        //Loop through the Distribution Rights from the payload.
        For(String ss: isbnToArrayKeyMap.get(productRecord.ProductCode).keyset()){
            if(ss.Containsignorecase('exclusionlist')){ //This identifies that the array is of the Distribution Rights type.  
                
                if(arrayKeyToFieldToValueMap.get(ss).get('name').tolowercase()!= 'null' && arrayKeyToFieldToValueMap.get(ss).get('name')!=''){
                    
                    String drValueTemp = '; ' + arrayKeyToFieldToValueMap.get(ss).get('name'); 
                    
                    if(drloopValue<101){
                        drValue1+= drValueTemp;   
                        if(drloopValue==0){drValue1=drValue1.replace('; ', '');}
                    }
                    if(drloopValue>100 && drloopValue<201){
                        drValue2+= drValueTemp;    
                        if(drloopValue==101){drValue2=drValue2.replace('; ', '');}
                    }
                    if(drloopValue>200 && drloopValue<301){
                        drValue3+= drValueTemp;  
                        if(drloopValue==201){drValue3=drValue3.replace('; ', '');}
                    }                    
                    drloopValue++;
                }                   
            }             
            productRecord.Distribution_Rights_Excluded_Countries_1__c = drValue1;
            productRecord.Distribution_Rights_Excluded_Countries_2__c = drValue2;
            productRecord.Distribution_Rights_Excluded_Countries_3__c = drValue3; 
        }
    }
    
    //added by Siddhant
    public class netbaseWrapper{
        public string code;
        public string description;
    }
}