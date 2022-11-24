public class TF_AG_TokenGenerate {
    private static AuthSetting authSetting;
    private static String oAuthURI;
     /**
     * To get the Auth details from Customer Meta data API.
     **/
    public TF_AG_TokenGenerate() {
        if(authSetting == null) {
            Auth_Setting__mdt setting = [SELECT Auth_Url__c, Client_Id__c,
                                  Client_Secret__c, Grant_Type__c, 
                                  Redirect_uri__c, Platform_uri__c FROM Auth_Setting__mdt 
                                  WHERE DeveloperName = 'TF_AG_UAT_AUTH' limit 1];
            authSetting = new AuthSetting();
            authSetting.client_id = setting.Client_Id__c;
            authSetting.client_secret = setting.Client_Secret__c;
            authSetting.grant_type = setting.Grant_Type__c;
            authSetting.redirect_uri = setting.Redirect_uri__c;
            oAuthURI=setting.Auth_Url__c;
    
        }
    }
    
    /**
     * To generate a new OAuth token 
     **/
    public static String getToken() {
        HttpRequest req = new HttpRequest();
        String body = JSON.serializePretty(authSetting);
        System.debug('body:='+body);
        req.setEndpoint(oAuthURI);
        req.setHeader('Content-Type','application/json');
        req.setMethod('POST');
        req.setBody(body);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        String responseBody = res.getBody();
        TokenDetails request = (TokenDetails)JSON.deserialize(responseBody, TokenDetails.class);
        System.debug('tokenb:='+request.id_token);
        return request.id_token;
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