@isTest
private class zTest_TF_PlatformExecuter {

    private static final String uri ='/v1/collection';
    private static final String method = 'POST';
    private static final String tokenType = 'idtoken';
    private static final String body = '{}';
    private static final  Map<String,String> headers = new Map<String,String>();

    static testMethod void testExecuteMethod() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TF_PlatformExecuterMockHttpResponseGenerator());
        HttpResponse res = TF_PlatformExecuter.execute(uri,method,tokenType,body,headers,false);
        Test.stopTest();
        System.assertEquals(200,res.getStatusCode());
        

    }
    


    public  class TF_PlatformExecuterMockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            TokenDetails token = new TokenDetails();
            res.setBody(JSON.serialize(token));
            res.setStatusCode(200);
            return res;
        }
    }

    class TokenDetails {
        private String access_token ='123';
        private String token_type ='123';
        private Decimal expires_in = 123;
        private String id_token='123'; 
        private String refresh_token='123';
    }
}