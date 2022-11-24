@RestResource(urlMapping='/quoteServiceV3/*')
global with sharing class TF_QuoteAPIServiceV3 {
	@HttpGet
    global static String doGet() {
        system.debug('inside doGet');
        String reqURI = RestContext.request.requestURI;
        String result = 'Not Found';
        //String reqStr = RestContext.request.requestBody.toString();
        //String req = RestContext.request.toString();
        String quoteUniqueId = reqURI.substringAfter('quoteServiceV3/');
        system.debug('quoteUniqueId-->'+quoteUniqueId);
        String quoteId =[SELECT Id FROM SBQQ__Quote__c WHERE randomstring__c =:quoteUniqueId].Id;
        system.debug('quoteId-->'+quoteId);
        if(String.isNotBlank(quoteId)){
            if ( quoteId.startsWith( SBQQ__Quote__c.sObjectType.getDescribe().getKeyPrefix() ) ) {
                try {
                    CPQ_ApiDataModels.QuoteModel qutModel = CPQ_ApiWrapper.calculateQuote(quoteId);
                    result = JSON.serialize(qutModel);
                } catch ( Exception ex ) {
                    
                }
            }
        }
        /*if ( reqURI.containsIgnoreCase('quoteId/') ) {
            String returnURI = '';
            returnURI = reqURI.subString(reqURI.lastIndexOf('/'), reqURI.length());
            returnURI = returnURI.remove('/');
            system.debug('returnURI-->'+returnURI);
            if ( returnURI.startsWith( SBQQ__Quote__c.sObjectType.getDescribe().getKeyPrefix() ) ) {
                try {
                    CPQ_ApiDataModels.QuoteModel qutModel = CPQ_ApiWrapper.calculateQuote(returnURI);
                    result = JSON.serialize(qutModel);
                } catch ( Exception ex ) {
                    
                }
            }
        }*/
        system.debug('result-->'+result);
        return result;
        //RestContext.response.responseBody = Blob.valueOf(result);
        //RestContext.response.addHeader('Content-Type', 'application/json');
    }
        
	
}