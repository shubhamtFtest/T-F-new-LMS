@isTest
global class TF_AG_MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('http://example.com/example/test', req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"access_token":"f53490297036576a7c62a3bae1d418f8","token_type":"Bearer","expires_in": 3600,"id_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpcCI6IiIsImNvbnRlbnRfY2Vuc29yaW5nX2VuYWJsZWQiOmZhbHNlLCJzY29wZSI6WyJ1bmxpY2Vuc2VkX3NlYXJjaCIsInByb2R1Y3RfYWNjZXNzIl0sInRlcnJpdG9yeV90eXBlIjoiY291bnRyeSIsImNsaWVudCI6eyJfaWQiOiI1YmNkNzQxMjg0ZDJjZjFmMDBjOTI3NmUiLCJ1c2VybmFtZSI6InJhamVzaC5rdXNod2FoYS5nYjFAaW5mb3JtYS5jb20iLCJuYW1lIjoiVU5TREciLCJjbGllbnRJZCI6IjhjMDYxOWVhN2U3ZGM2ODE5YjdlYzY1MTliYTZjOTc0MDVhMDQyZjRkMTM4Mzc1ZDQ1MDgxNDUxYzk5MDU4MTAiLCJyZWRpcmVjdF91cmlzIjpbImh0dHA6Ly9sb2NhbGhvc3Q6ODA4MCJdfSwiciI6WyJCVVMiXSwiaXNzIjoiaHR0cHM6Ly9hY2NvdW50cy11YXQudGF5bG9yZnJhbmNpcy5jb20vaWRlbnRpdHkvIiwiZXhwIjoxNTU2NzA2NDAzLCJpYXQiOjE1NTY3MDI4MDMsImF1ZCI6IjhjMDYxOWVhN2U3ZGM2ODE5YjdlYzY1MTliYTZjOTc0MDVhMDQyZjRkMTM4Mzc1ZDQ1MDgxNDUxYzk5MDU4MTAiLCJzdWIiOm51bGx9.TR_bIrIOEOwV844gYevwXqfAVSEW6C2QI2EqU838UXz5N8O_kn_ixezI87lR6HfjYECm_nCtD1J7xQw4hVrcGHDQ9j5YS3iBI33M9BDDjblC9YODNsRdjvCn4ggG1CTGZ4wV9Ie_ya4QVKr7JjF3jqeu3wdXQrjXLeudqRd10lyGSkZAXv4A9J4okUvy9LuLvcNFk3KkP3M6TQwPHuTbvC9LZxJFu5qcxQP3yDZnRQDaHi1EuV-A43e_BcQufVz3TPXz1dMNZ13VX1Hez2gteOewp9hglvheaMDjr7ytTJ8QCJ5v9VmMWcTosljOVRvW38C5_APnxnpXcJMYNPc-lQ"}');
        res.setStatusCode(200);
        return res;
    }
}