/*
   Author : shashank
   Date created :  3/18/2019
   Description : This class handles backend functionality to lightning component related to order Hub.
   Test class : zTestOrderHubCustomerDetailCntrl

 */
public class TF_OrderHubCustomerDetailCntrl {
private static String orderHubURI = '/v1/orders/';
private static String fetchSpecificOrderURI = '/v1/orders/';
private static String createOrderURI = orderHubURI;
private static string hostname='';

private static void init() {
	if(hostname != null && String.isNotBlank(hostname)) {
		// no strings attached
	}else {

		TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();

		if (orgSpecificProps != null) {
			hostname = (String) orgSpecificProps.get('UBX_Order_Platform_uri__c');
			System.debug('hostname-'+hostname);
		}

	}
}
@AuraEnabled
public static TF_OrderHubIntJSONResp getOrderForOpp(String objId, String channel, String sObjectName, String pagesize, String pageno )
{
	if (sObjectName == 'Account')
	{
		return getOrdersForCustomer(objId,channel, pagesize,pageno );
	}
	return null;
}

@AuraEnabled
Public static TF_OrderHubIntJSONResp  getOrdersForCustomer(String accountId,String channel, String pagesize, String pageno)
{
    System.debug('accountId'+accountId);
    System.debug('channel'+channel);
    System.debug('pagesize'+pagesize);
    System.debug('pageno'+pageno);
	init();
	System.debug('getOrdersForCustomer');
	if (accountId != NULL && String.isNotBlank(accountId) )
	{
		List<account> listAccountDb = new List<account>([SELECT id,Customer_ID__c FROM account WHERE id =: accountId LIMIT 1  ]);
		if (listAccountDb!=NULL && listAccountDb.size() > 0 && listAccountDb.get(0).Customer_ID__c != NULL && String.isNotBlank(listAccountDb.get(0).Customer_ID__c) )
		{
			createOrderURI = hostname + createOrderURI + '?customerId=' + listAccountDb.get(0).Customer_ID__c + '&channel=' + channel.toUpperCase() +'&pagesize=' +pagesize +'&pageno='+pageno;
			System.debug('createOrderURI-'+createOrderURI);
			Map<String, String> headers = new Map<String,String>();
			headers.put('Content-Type', 'application/json');

			try {
				HttpResponse res = null;
				if( false) {
					// To mock the result
					//res = createMockResponse();

				} else {
					res = TF_PlatformExecuter.execute(createOrderURI,'GET','idtoken', null, headers, false);
					system.debug('res-'+String.valueof(res));
				}
				if (res.getStatusCode() == 201 || res.getStatusCode() == 200) {
					String responseBody = res.getBody();
					//res.getHeader(key) TF_OrderHubIntJSONResp
					System.debug('****ResponseCode****!' + res.getStatusCode());
					System.debug('****responseBody****!' + res.getBody());
					TF_OrderHubIntJSONResp TF_OrderHubIntJSONRespObj =(TF_OrderHubIntJSONResp) System.JSON.deserialize(mogrifyJSON(res.getBody()), TF_OrderHubIntJSONResp.class);
					TF_OrderHubIntJSONRespObj.metadata.totalPagesize = Integer.valueOf(res.getHeader('total_pages'));
					// setting addresMappg on wrapper acc to setting obj to use either billing address or shipping address
					if (TF_OrderHubIntJSONRespObj!= NULL && TF_OrderHubIntJSONRespObj.metadata !=NULL)  {
						// order detail mapping also used on order lightning tab 
						List<Setting__c> ListOrderDetailPageMapping  = [SELECT Id,Name FROM Setting__c WHERE Name = 'Order Detail Page Mapping' limit 1];
						List<Setting_Item__c>  listPageMappingSetgItem = [SELECT Checkbox_1__c,Checkbox_2__c,
						Text_1__c, Setting__c FROM Setting_Item__c where Setting__c = :ListOrderDetailPageMapping.get(0).Id ];
						
						for (Setting_Item__c settgObj : listPageMappingSetgItem) {
							String chnlJSON =channel;
							if(String.isNotBlank(chnlJSON) && chnlJSON.equalsIgnoreCase(settgObj.Text_1__c) )
							{
								if(settgObj.Checkbox_1__c == true  ){
									TF_OrderHubIntJSONRespObj.metadata.addresMappg = 'shippingAddress' ;
								}
								else if(settgObj.Checkbox_2__c == true ){
									TF_OrderHubIntJSONRespObj.metadata.addresMappg = 'billingAddress' ;
								}
								
							}
						}
						//
					}
					system.debug('TF_OrderHubIntJSONRespObj-'+TF_OrderHubIntJSONRespObj);
					return TF_OrderHubIntJSONRespObj;
				}
				else
				{
					system.debug('#####!DEBUG'+ '' + res);
					//system.debug('#####!DEBUG'+ '' + Id);
					return null;
				}
			}
			catch (Exception ex) {
				System.debug('******** Exception : ' + ex.getMessage());
				return null;
			}
		}
	}
	return NULL;
}

// method to fetch specific orders  // orderNum fetchSpecificOrder()
@AuraEnabled
public Static TF_SingleOrderDetailJsonResponse fetchSpecificOrder( String orderNum, string AccountId ){
	init();
	String AccountNameStr;
	if (AccountId != null  ) {
		Account acc = [SELECT id, Name FROM account WHERE id = :AccountId ];
		if (acc != null) {
			AccountNameStr = acc.Name;
		}
	}


	fetchSpecificOrderURI = hostname + fetchSpecificOrderURI  + orderNum;
	system.debug('fetchSpecificOrderURI-'+fetchSpecificOrderURI);
	Map<String, String> headers = new Map<String,String>();
	headers.put('Content-Type', 'application/json');

	// try {
	HttpResponse res = null;
	if( false) {
		// To mock the result
		//res = createMockResponse();

	} else {
		res = TF_PlatformExecuter.execute(fetchSpecificOrderURI,'GET','idtoken', null, headers, false);
		system.debug('res-'+res);
	}
	if (res.getStatusCode() == 201 || res.getStatusCode() == 200) {
		String responseBody = res.getBody();
		System.debug('********!' + responseBody);
		System.debug('****ResponseCode****!' + res.getStatusCode());
		// System.debug('****responseBody****!' + res.getBody());
		TF_SingleOrderDetailJsonResponse TF_SingleOrderDetailJsonResponseObj =(TF_SingleOrderDetailJsonResponse) System.JSON.deserialize(mogrifyJSON(res.getBody()), TF_SingleOrderDetailJsonResponse.class);
		if (TF_SingleOrderDetailJsonResponseObj!= Null && TF_SingleOrderDetailJsonResponseObj.order!= NULL && TF_SingleOrderDetailJsonResponseObj.order.orderedItem!= NULL ) {
			
			List<Setting__c> ListOrderDetailPageMapping  = [SELECT Id,Name FROM Setting__c WHERE Name = 'Order Detail Page Mapping' limit 1];
			List<Setting_Item__c>  listPageMappingSetgItem = [SELECT Checkbox_1__c,Checkbox_2__c,
			Text_1__c, Setting__c FROM Setting_Item__c where Setting__c = :ListOrderDetailPageMapping.get(0).Id ];
			

			list<TF_SingleOrderDetailJsonResponse.orderedItem> listOrderItem =TF_SingleOrderDetailJsonResponseObj.order.orderedItem;
			TF_SingleOrderDetailJsonResponseObj.order.AccountName = AccountNameStr;
			// System.debug('listOrderItem-'+listOrderItem);
			if (listOrderItem!= null && listOrderItem.size() >0  ) {
				Set<String> setProdId = new Set<String>(); // basically these are ProductCode returning in JSON
				for (TF_SingleOrderDetailJsonResponse.orderedItem obj  : listOrderItem) {
					setProdId.add(obj.productId);

				}
				//    System.debug('setProdId'+setProdId);
				Map<String, Product2> mapPcodeProd = new Map<String, Product2>();
				Map<Id, Product2> mapProduct = new Map<Id, Product2>([SELECT id,Name,Lead_Author_Editor__c,ProductCode FROM product2 WHERE ProductCode IN: setProdId AND IsActive = true AND ProductCode != null]);
				for(Product2 prod : [SELECT id,Name,Lead_Author_Editor__c,ProductCode,Version_Type__c FROM product2 WHERE ProductCode IN:setProdId AND IsActive = true AND ProductCode != null ] ) {
					mapPcodeProd.put(prod.ProductCode,prod );
				}
				for (TF_SingleOrderDetailJsonResponse.orderedItem obj  : TF_SingleOrderDetailJsonResponseObj.order.orderedItem) {
					if ( mapPcodeProd.containsKey(String.valueOf( obj.productId ) ) ) {
						obj.prodName = mapPcodeProd.get(obj.productId).Name;
						obj.prodAuthor = mapPcodeProd.get(obj.productId).Lead_Author_Editor__c;
						obj.versionType = mapPcodeProd.get(obj.productId).Version_Type__c;
					}
				}
			}
		}
		// system.debug('TF_SingleOrderDetailJsonResponseObj-'+TF_SingleOrderDetailJsonResponseObj);
		return TF_SingleOrderDetailJsonResponseObj;

	}
	else
	{
		system.debug('#####!DEBUG'+ '' + res);
		//system.debug('#####!DEBUG'+ '' + Id);
		return null;
	}
	// }
	// catch (Exception ex) {
	//     System.debug('******** Exception : ' + ex.getMessage()+' at line no.-'+ ex.getLineNumber() +' getTypeName-' +ex.getTypeName());
	//     return null;
	// }
}

@AuraEnabled
public static String searchDB(String objectName, String fld_API_Text, String fld_API_Val,  Integer lim,String fld_API_Search,String searchText ){

	searchText='\'%' + String.escapeSingleQuotes(searchText.trim()) + '%\'';
	String query;

	query = 'SELECT '+fld_API_Text+' ,'+fld_API_Val+
	        ' FROM '+objectName+
	        ' WHERE '+fld_API_Search+' LIKE '+searchText+
	        ' LIMIT '+lim;

	List<sObject> sobjList = Database.query(query);
	List<ResultWrapper> lstRet = new List<ResultWrapper>();

	for(SObject s : sobjList) {
		ResultWrapper obj = new ResultWrapper();
		obj.objName = objectName;
		obj.text = String.valueOf(s.get(fld_API_Text));
		obj.val = String.valueOf(s.get(fld_API_Val));
		lstRet.add(obj);
	}
	return JSON.serialize(lstRet);
}
    
    //Method to fetch sales type from settings
    @AuraEnabled
    public static List<Setting_Item__c> getSalesType() {
        List<Setting_Item__c> salesTypeList = new List<Setting_Item__c>([select id, Setting__c, Text_1__c,Text_2__c from Setting_Item__c  where Setting__r.Name  = 'Order Detail Page Mapping' and Checkbox_1__c = true ]);	
        return salesTypeList;
    }



public class ResultWrapper {
public String objName {get; set;}
public String text {get; set;}
public String val {get; set;}
}
// Also used in class TF_ubxSelfServiceOrderSchduled
public static String mogrifyJSON(String data) {
	// Regex to match the start of the line and the key
	// surrounded by quotes and ending with a colon
	String regexFormat = '(?m)^\\s*"{0}"\\s*:';

	// Replacement format of the new key surrounded by
	// quotes and ending with a colon
	String replacementFormat = '"{0}" :';

	// A map of existing key to replacement key
	Map<String, String> replacements = new Map<String, String> {
		'currency' => 'currencyy'
	};

	// Since our JSON can come in formatted however the
	// endpoint wants, we need to format it to a standard
	// we know and can handle
	String formattedJSON = JSON.serializePretty(JSON.deserializeUntyped(data));

	// Iterate over all the keys we want to replace
	for (String key : replacements.keySet()) {
		// Generate our regex based on the key
		String regex = String.format(
			regexFormat,
			new List<String> {key}
			);

		// Generate our replacement
		String replacement = String.format(
			replacementFormat,
			new List<String> {replacements.get(key)}
			);

		// Find all and replace
		formattedJSON = formattedJSON.replaceAll(regex, replacement);
		// System.debug('formattedJSON-'+formattedJSON);
	}

	return formattedJSON;
}
}