/**
   Author : shashank
   Test class : zTestTF_OrderHubIntegrationSchduled
   Description :This is a generic class which helps in calling out Order HUb APIs. In case, if any error occurs then it will be properly logged in setting object.
   Dev Info : using TF_OhIntclneChain instead TF_OrderHubIntegration
 */
public with sharing class TF_OrderHubPlatformExecutor {

private static AuthSetting authSetting;
private static String oAuthURI;
private static String platformURI;
private static Id settingObjID;


public TF_OrderHubPlatformExecutor() {

}




/**
 * To get the Auth details from Customer Meta data API.
 **/
private static void init() {
	if(authSetting == null) {
		Auth_Setting__mdt setting = [SELECT Auth_Url__c, Client_Id__c,
		                             Client_Secret__c, Grant_Type__c,
		                             Redirect_uri__c, Platform_uri__c FROM Auth_Setting__mdt
		                             WHERE DeveloperName = 'TandF_Auth_Provider' limit 1];
		System.debug('setting-'+setting);
		authSetting = new AuthSetting();
		authSetting.client_id = setting.Client_Id__c;
		authSetting.client_secret = setting.Client_Secret__c;
		authSetting.grant_type = setting.Grant_Type__c;
		authSetting.redirect_uri = setting.Redirect_uri__c;
		oAuthURI = setting.Auth_Url__c;
		platformURI = setting.Platform_uri__c;

	}
}

/**
 * to execute a http call.
 **/
public static HttpResponse execute(String uri, String method, String tokenType, String body,  Map<String,String> headers, Boolean ignoreAuth) {
	
	init();
	HttpResponse res;
	try{
		system.debug('in execute method ');
		HttpRequest req = new HttpRequest();
		Http http = new Http();
		if(uri.startsWith('http'))
		{
			req.setEndpoint(uri);
		}
		else
		{
			req.setEndpoint(platformURI + uri);
		}

		//req.setEndpoint(uri);

		req.setMethod(method);
		for(String header : headers.keySet()) {
			req.setHeader(header, headers.get(header));
		}
		if(ignoreAuth != true ) { //
			req.setHeader('Authorization', tokenType + ' ' + getToken());

		} else  {
			req.setHeader('ignore-auth', 'true');
		}

		if(body != null) {
			req.setBody(body);
		}
		req.settimeout(120000);

		// system.debug('TF_PlatformExecuter req'+req);
		res =  http.send(req);
		return res;
	} catch(System.CalloutException e) {
		System.debug('Callout error : '+ e );
		HttpResponse resp = new HttpResponse();
		resp.setStatus('Callout Failure');
		resp.setBody(e.getMessage());
		resp.setStatusCode(500);
		// logging the error
		// getIdSetting();
		System.debug('#112-sendEmail');
		TF_OhIntclneChain TF_OhIntclneChainObj = new TF_OhIntclneChain();
		TF_OhIntclneChainObj.sendEmail(String.valueOf(e.getMessage()),true,resp.getBody());
		System.debug('after send email');
		return resp;
	}
}

/**
 * To generate a new OAuth token
 **/
private static String getToken() {
	HTTPResponse res;
	try {
		HttpRequest req = new HttpRequest();
		String body = JSON.serializePretty(authSetting);
		System.debug('body-'+body);
		req.setEndpoint(oAuthURI);
		req.setHeader('Content-Type','application/json');
		req.setMethod('POST');
		req.setBody(body);
		req.settimeout(120000);
		Http http = new Http();
		// system.debug('TF_PlatformExecuter req'+req);
		res = http.send(req);
		String responseBody = res.getBody();
		//integer o = 1/0;
		// String s;
		// Boolean b = s.contains('abc');
		// system.debug('responseBody==='+ responseBody.replaceAll('\n', ''));
		TokenDetails request = (TokenDetails)JSON.deserialize(responseBody, TokenDetails.class);
		return request.id_token;
	} catch (Exception e) {
		System.debug('Callout error : '+ e );
		// logging the error
		System.debug('#154-sendEmail');
		TF_OhIntclneChain TF_OhIntclneChainObj = new TF_OhIntclneChain();
		TF_OhIntclneChainObj.sendEmail(String.valueOf(e.getMessage()),true,'No response found');
		return NULL;
	}
}


class TokenDetails {
private String access_token;
private String token_type;
private Decimal expires_in;
private String id_token;
private String refresh_token;
}

class AuthSetting {
private String client_id;
private String client_secret;
private String grant_type;
private String redirect_uri;
}
}