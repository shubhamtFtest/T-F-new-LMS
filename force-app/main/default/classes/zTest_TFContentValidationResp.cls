@isTest

public class zTest_TFContentValidationResp {
    
    private static testmethod void testAllFields(){
        
        TFContentValidationResp.Targets targ = new TFContentValidationResp.Targets();         
        targ.error = 'testerror';
        targ.result = 'testresult';
        targ.uuid = 'testuuid';
        targ.value = 'testvalue';
        
        TFContentValidationResp.Responses res = new TFContentValidationResp.Responses();   
        res.keyType = 'doi';
        res.targets = new List<TFContentValidationResp.Targets>{targ};
            
            
            TFContentValidationResp valResp = new TFContentValidationResp();
        valResp.application = 'SFDC'; 
        valResp.source = 'Product Hub';
        valResp.timestamp = '2018-04-17T13:01:00.180Z';
        valResp.topic = 'product-validation-response';
        valResp.Responses = new List<TFContentValidationResp.Responses>{res};
            
            }
}