@isTest
global class TF_AG_MockHttpResponseGenerator_Order implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('http://example.com/example/test', req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"data":[{"accountId": "S00086","orderId": "TJ069959","orderValue": "86.9","orderStatus": null,"isbn": "9781482253443","quantity": "1","titleStatus": null,"replenType": null}],"page": 1,"totalPages": 1,"pageSize": 1}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}