/**
* This planform executer can be used by any Callout to call TandF Platform API
**/

public class TF_PlatformExecuter {
    
    private static AuthSetting authSetting;
    private static AuthSetting_SA authSettingSA;
    private static String oAuthURI;
    private static String platformURI;
    private static Boolean useServiceAccount;
    private static String serviceAccClientId;
    private static String serviceAccSecret;
    private static String serviceAccEmail;
    private static String serviceAccPrivateKey;
    private static String sourceURL;

    
    /**
* To get the Auth details from Custom Meta data.
**/
    private static void init() {
         
        Auth_Setting__mdt setting = [SELECT Auth_Url__c, Client_Id__c,
                                     Client_Secret__c, Grant_Type__c, 
                                     Redirect_uri__c, Platform_uri__c, useSeviceAccount__c, 
                                     Client_Id_SA__c, Client_Secret_SA__c, Service_Account_Email__c, 
                                     AuthPrivateKey__c, Service_Account_Auth_URL__c, Source_Org_URL__c 
                                     FROM Auth_Setting__mdt 
                                     WHERE DeveloperName = 'TandF_Auth_Provider' limit 1];

        if(setting != null){
            if(setting.useSeviceAccount__c || Test.isRunningTest()){
                useServiceAccount = true ;
                authSettingSA = new AuthSetting_SA();
                authSettingSA.grant_type = 'jwt-bearer';
                oAuthURI = setting.Service_Account_Auth_URL__c;
                serviceAccClientId = setting.Client_Id_SA__c;
                serviceAccSecret = setting.Client_Secret_SA__c;
                serviceAccEmail = setting.Service_Account_Email__c;
                serviceAccPrivateKey = setting.AuthPrivateKey__c;
                sourceURL = setting.Source_Org_URL__c ;
                platformURI = setting.Platform_uri__c;

            }
            
            if(!setting.useSeviceAccount__c || Test.isRunningTest()){
                useServiceAccount = false ;
                authSetting = new AuthSetting();
                authSetting.client_id = setting.Client_Id__c;
                authSetting.client_secret = setting.Client_Secret__c;
                authSetting.grant_type = setting.Grant_Type__c;
                authSetting.redirect_uri = setting.Redirect_uri__c;
                oAuthURI = setting.Auth_Url__c;
                platformURI = setting.Platform_uri__c;
            }
        }
    }
    
    /**
* to execute a http call.
**/
    public static HttpResponse execute(String uri, String method, String tokenType, String body,  Map<String,String> headers, Boolean ignoreAuth) {
        init();
        try{
            HttpRequest req = new HttpRequest();
            Http http = new Http();
            if(uri.startsWith('http')){
                req.setEndpoint(uri);
            }else{
                req.setEndpoint(platformURI + uri);
            }
            
            req.setMethod(method);
            for(String header : headers.keySet()) {
                req.setHeader(header, headers.get(header));
            }
            if(ignoreAuth != true) {
                if(useServiceAccount || Test.isRunningTest()){
                    req.setHeader('Authorization', tokenType + ' ' + getServiceAccToken());
                }
                if(!useServiceAccount || Test.isRunningTest()){
                    req.setHeader('Authorization', tokenType + ' ' + getToken());
                }
                
            } else  {
                req.setHeader('ignore-auth', 'true');
            }
            
            if(body != null) {
                req.setBody(body);
            }
            req.settimeout(120000);
            
            system.debug('TF_PlatformExecuter req'+req);
            return http.send(req);
        } catch(System.CalloutException e) {
            System.debug('Callout error : '+ e );
            HttpResponse resp = new HttpResponse();
            resp.setStatus('Callout Failure');
            resp.setBody(e.getMessage());
            resp.setStatusCode(500);
            return resp;
        }
    }
    
    /**
* To generate a new OAuth token 
**/
    private static String getToken() {
        
        HttpRequest req = new HttpRequest();
        String body = JSON.serializePretty(authSetting);
        req.setEndpoint(oAuthURI);
        req.setHeader('Content-Type','application/json');
        req.setMethod('POST');
        req.setBody(body);
        system.debug('TF_PlatformExecuter token req'+req);
        
        Http http = new Http();

        HTTPResponse res = http.send(req);
        String responseBody = res.getBody();
        system.debug('responseBody==='+ responseBody);
        TokenDetails request = (TokenDetails)JSON.deserialize(responseBody, TokenDetails.class);
        return request.id_token;
    }
    
    /**
* To generate Service Account OAuth token 
**/
    public static String getServiceAccToken() {
        
        String token = generateSfJWT();
        HttpRequest req = new HttpRequest();
        String body = JSON.serializePretty(authSettingSA);
        req.setEndpoint(oAuthURI);
        req.setHeader('Content-Type','application/json');
        req.setHeader('secret', serviceAccSecret);
        req.setHeader('Authorization', token);
        
        req.setMethod('POST');
        req.setBody(body);
        Http http = new Http();
        
        system.debug('TF_PlatformExecuter Service Account token req'+req);
        
        HTTPResponse res = http.send(req);
        String responseBody = res.getBody();
        system.debug('responseBody==='+ responseBody);
        TokenDetails request = (TokenDetails)JSON.deserialize(responseBody, TokenDetails.class);
        return request.id_token;
    }
    
    /**
* To generate salesfforce JWT token 
**/
    private static String generateSfJWT() {
        String jwt = '';
        String pvtKeyStr = serviceAccPrivateKey ;
        String encodedHeader = '';
        Blob privateKey ;
        Blob signature ;
        
        // create JWT header
        JSONGenerator header = JSON.createGenerator(false);
        header.writeStartObject();
        header.writeStringField('alg', 'RS256');
        header.writeStringField('typ', 'JWT');
        header.writeEndObject();
        
        encodedHeader = base64URLencode(Blob.valueOf(header.getAsString()));
        
        // create JWT body with required claims
        
        Auth.JWT body = new Auth.JWT();
        
        body.setAud(serviceAccClientId);
        body.setIss(sourceURL);
        body.setValidityLength(3600);
        
        //setting ddditional claims, email is the unique emailid provided by service account team
        
        Map<String, Object> claims = new Map<String, Object>();
        claims.put('email',serviceAccEmail);
        
        body.setAdditionalClaims(claims);
        
        jwt = encodedHeader + '.' + base64URLencode(Blob.valueOf(body.toJSONString()));
        
        privateKey = EncodingUtil.base64Decode(pvtKeyStr);
        signature = Crypto.sign('rsa-sha256', Blob.valueOf(jwt), privateKey);
        
        jwt += '.' + base64URLencode(signature);  
        
        system.debug(jwt);
        return jwt;
    }
    
    /**
* To generate auth token from other class 
**/
    public static String generateAccessToken() {
        init();
        String token = '';
        if(useServiceAccount || Test.isRunningTest()){
            token = getServiceAccToken();
        }
        if(!useServiceAccount || Test.isRunningTest()){
            token = getToken();
        }
        return token ;
    }
    
    private static String base64URLencode(Blob input){ 
        String output = encodingUtil.base64Encode(input);
        
        output = output.replace('+', '-');
        output = output.replace('/', '_');
        
        while ( output.endsWith('=')){
            output = output.subString(0,output.length()-1);
        }
        return output;
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
    
    class AuthSetting_SA {
        private String grant_type;
    }
    
}