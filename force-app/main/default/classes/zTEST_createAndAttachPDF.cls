@isTest
private class zTEST_createAndAttachPDF {

/*
 * This section onwards are for the tests
 */
 

/*
 * This is a basic test where the PDF is created and attached to a Lead record
 */
    
        static testMethod void basicTest() {

        // Create dummy lead
        Lead testLead = new Lead(Company='Test Lead',FirstName='John',LastName='Doe');
        insert testLead;

        createAndAttachPDF aPdfPlugin = new createAndAttachPDF();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();

        inputParams.put('recordID',testLead.ID);
        inputParams.put('pdfAttachmentName','PDF Attachment');
        inputParams.put('pdfAttachmentContent','Dear All This is a test');
        
        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = aPdfPlugin.invoke(request);
        System.debug(result);
        
        System.assertEquals(result.OutputParameters.get('Status'),'SUCCESS');     

        Attachment anAttach = [select parentID, name from attachment where parentiD =:testLead.ID];
        System.AssertEquals(anAttach.name, 'PDF Attachment' );            
        
        
        }
        
        /*
        * basic -eve test with an invalid recordID
        */        
        static testMethod void negativeTest() {


        createAndAttachPDF aPdfPlugin = new createAndAttachPDF();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();

        //Pass in invalid ID
        inputParams.put('recordID','blah');
        inputParams.put('pdfAttachmentName','PDF Attachment');
        inputParams.put('pdfAttachmentContent','Dear All This is a test');
        
        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = aPdfPlugin.invoke(request);
   
        System.debug(result);
        System.assertEquals(result.OutputParameters.get('Status'),'ERROR');     
        
        }


 /*
  * This test is to test the describe() method
  */ 
        static testMethod void describeTest() {

                createAndAttachPDF aPdfPlugin = new createAndAttachPDF();
                Process.PluginDescribeResult result = aPdfPlugin.describe();
                
                System.AssertEquals(result.inputParameters.size(), 3);
                System.AssertEquals(result.OutputParameters.size(), 2);
        
        }
}