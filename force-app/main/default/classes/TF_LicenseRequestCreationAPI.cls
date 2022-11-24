/***************************************************************************
* Created by: Shubham Kumar, 2022.03.19
* Test Class: zTEST_TF_LicenseCreateRequestAPI
* Description: This class is called by the Order hub whenever an License(Assest) has to be created so that the request can be stored to an object for future reference.
Example Salesforce:-
1) Endpoint (POST) = /services/apexrest/LicenseCreateRequestAPI/salesforceLicenseCreation/
**************************************************************************/
@RestResource(urlMapping='/LicenseCreateRequestAPI/*')
global with sharing class TF_LicenseRequestCreationAPI{
    
    @HttpPost
    global static void licenseCreationSync() {
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        String result               = '';
        String command              = getCommand(RestContext.request.requestURI);
        String operation            = operationLookup('POST', command);
        String jsonStr              = RestContext.request.requestBody != null ? RestContext.request.requestBody.toString() : null;
        
        System.debug('command =====>' + command);
        System.debug('operation =====>' + operation);
        
        if(jsonStr!=null){
            if (operation == 'salesforceLicenseCreation') {
                Licenseresponse = salesforceLicenseCreation(jsonStr);
            } else {
                result = 'Invalid Resource';
            }
            system.debug('result'+result);
            if ( String.isNotBlank(JSON.serialize(result))) {
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(Licenseresponse));
                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.statusCode = Licenseresponse.statuscode;
            }
        } else{
            RestContext.response.statusCode = 404;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize('Invalid JSON'));
            RestContext.response.addHeader('Content-Type', 'application/json');
        }
        
    }
    
    public static TF_LicenseCreateRequestWrapper.LicenseCreateResponse salesforceLicenseCreation ( String jsonString ) {
        TF_LicenseCreateRequestWrapper.LicenseCreateResponse Licenseresponse = new TF_LicenseCreateRequestWrapper.LicenseCreateResponse();
        try {
            TF_LicenseCreateRequestWrapper request = (TF_LicenseCreateRequestWrapper)JSON.deserialize(jsonString, TF_LicenseCreateRequestWrapper.class);
            TF_licenseCreationService licenseService = new TF_licenseCreationService();
            Licenseresponse = licenseService.create(request);
            return Licenseresponse;//json.serialize(response);
        }
        catch(exception e){
            Licenseresponse.statuscode = 400;
            Licenseresponse.statusMessage = e.getMessage();
            system.debug('Exception =====>'+e.getMessage()+'@ line number'+e.getLineNumber());
            return Licenseresponse;//'Some Error Occured';
        }
    }
    
    private static String getCommand(String requestedUri) {
        return requestedUri.substring(requestedUri.lastIndexOf('/LicenseCreateRequestAPI/'));
    }
    
    private static String operationLookup ( String method, String command ) {
        String operation = 'unknown';
        if(method.equals('POST')) {
            if (command.contains('salesforceLicenseCreation')) {
                operation = 'salesforceLicenseCreation';
            }
        } else if (method.equals('DELETE')) {
            
        } else if (method.equals('PUT')) {
            
        }
        return operation;
    }   
}