@isTest
public class MockHttpResponseGenerator implements HttpCalloutMock 
{
    private integer statusCode; 
    private String responseJson; 
    
    public MockHttpResponseGenerator(integer statusCode, String responseJson){
        this.statusCode = statusCode; 
        this.responseJson = responseJson;
    }
    public HTTPResponse respond(HTTPRequest req) 
    {
        if(responseJson != 'validate test'){
            // Create a mock response
            HttpResponse resp = new HttpResponse();
            resp.setHeader('Content-Type', 'application/json');
            resp.setBody(responseJson);      
            resp.setStatusCode(statusCode);
            return resp;
        } else{
            String resptJson ;
            if(req.getEndpoint().endsWith('.json') && req.getMethod() == 'PUT'){
                resptJson = '{test}';
                HttpResponse resp = new HttpResponse();
                resp.setHeader('Content-Type', 'application/json');
                resp.setBody(resptJson);      
                resp.setStatusCode(200);
                return resp;
            } else if(req.getEndpoint().endsWith('user/auth/token')){
                resptJson = '{"access_token":"10edc9086eefa8e672eca3ad1b0040a2","token_type":"Bearer","expires_in":3600,"id_token":"eyJhbGciOiJSUzI1NiIsI"}';
                
                HttpResponse resp = new HttpResponse();
                resp.setHeader('Content-Type', 'application/json');
                resp.setBody(resptJson);       
                resp.setStatusCode(200);
                return resp;
            }else if(req.getEndpoint().contains('entitlements') && req.getMethod() == 'POST'){
                resptJson = '[{"customerId":"98422","packageId":"38149258","packageVersion":"null","productId":"0023303d-524f-49a0-93a5-00db3ccb9a39","licenseId":"118415","status":"ACTIVE"},{"customerId":"98422","packageId":"38149258","packageVersion":"null","productId":"005ba6ce-e021-4eb0-a358-00b0392029bc","licenseId":"118415","status":"ACTIVE"},{"customerId":"98422","packageId":"38149258","packageVersion":"null","productId":"0075083f-7492-47d5-818f-bf93bcde1fdf","licenseId":"118415","status":"ACTIVE"}]';
                HttpResponse resp = new HttpResponse();
                resp.setHeader('Content-Type', 'application/json');
                resp.setBody(resptJson);      
                resp.setStatusCode(200);
                return resp;
            }else if (req.getEndpoint().endsWith('type=partslist') && req.getMethod() == 'GET'){
                resptJson = '[{"location": "testlocation","type": "csv"}]';
                HttpResponse resp = new HttpResponse();
                resp.setHeader('Content-Type', 'application/json');
                resp.setBody(resptJson);      
                resp.setStatusCode(statusCode);
                return resp;
            }
            
        } 
        return null;
    }
    
}