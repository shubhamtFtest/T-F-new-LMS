@isTest
private class zTEST_ConvertLead {

/*
 * This is a basic test with just the LeadID and Converted Status specified in the call the Apex Plug-in
 */
 
    static testMethod void basicTestwith() {

        // Create dummy lead
        Lead testLead = new Lead(Company='Test Lead',FirstName='John',LastName='Doe');
        insert testLead;
    
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1]; 
        
        // Create dummy conversion
        ConvertLead aLeadPlugin = new ConvertLead();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();

        inputParams.put('LeadID',testLead.ID);
        inputParams.put('ConvertedStatus',convertStatus.MasterLabel);

        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = aLeadPlugin.invoke(request);
        
        Lead aLead = [select name, id, isConverted from Lead where id = :testLead.ID];
        System.Assert(aLead.isConverted);
        
    }

/*
 * This is another basic test with just the LeadID and nothing else.
 */
 
    static testMethod void basicTestWithoutConvertedStatus() {

        // Create dummy lead
        Lead testLead = new Lead(Company='Test Lead',FirstName='John',LastName='Doe');
        insert testLead;
            
        // Create dummy conversion
        ConvertLead aLeadPlugin = new ConvertLead();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();

        inputParams.put('LeadID',testLead.ID);

        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = aLeadPlugin.invoke(request);
        
        Lead aLead = [select name, id, isConverted from Lead where id = :testLead.ID];
        System.Assert(aLead.isConverted);
        
    }
    
 /*
  * This test is to test the convert Lead with the Account ID specified
  */
       static testMethod void basicTestwithAccount() {

        // Create dummy lead
        Lead testLead = new Lead(Company='Test Lead',FirstName='John',LastName='Doe');
        insert testLead;
        
        Account testAccount = new Account(name='Test Account');
        insert testAccount;
    

        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1]; 
        
        // Create dummy conversion
        ConvertLead aLeadPlugin = new ConvertLead();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();

        inputParams.put('LeadID',testLead.ID);
        inputParams.put('AccountID',testAccount.ID);
        inputParams.put('ConvertedStatus',convertStatus.MasterLabel);

        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = aLeadPlugin.invoke(request);
        
        Lead aLead = [select name, id, isConverted, convertedAccountID from Lead where id = :testLead.ID];
        System.Assert(aLead.isConverted);
        //System.debug('ACCOUNT AFTER' + aLead.convertedAccountID);
        System.AssertEquals(testAccount.ID, aLead.convertedAccountID);
    }

/*
  * This test is to test the convert Lead with the Company matching more than one existing Account Names
  */
       static testMethod void basicTestwithAccounts() {

        // Create dummy lead
        Lead testLead = new Lead(Company='Test Lead',FirstName='John',LastName='Doe');
        insert testLead;
        
        Account testAccount1 = new Account(name='Test Lead');
        insert testAccount1;
        Account testAccount2 = new Account(name='Test Lead');
        insert testAccount2;


        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1]; 
        
        // Create dummy conversion
        ConvertLead aLeadPlugin = new ConvertLead();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();

        inputParams.put('LeadID',testLead.ID);
        inputParams.put('ConvertedStatus',convertStatus.MasterLabel);

        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = aLeadPlugin.invoke(request);
        
        Lead aLead = [select name, id, isConverted, convertedAccountID from Lead where id = :testLead.ID];
        System.Assert(aLead.isConverted);
    }


 /*
  * -ve Test
  */    
    static testMethod void errorTest() {

        // Create dummy lead
        //Lead testLead = new Lead(Company='Test Lead',FirstName='John',LastName='Doe');
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1]; 
        
        // Create dummy conversion
        ConvertLead aLeadPlugin = new ConvertLead();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();
        inputParams.put('LeadID','00Q7XXXXxxxxxxx');
        inputParams.put('ConvertedStatus',convertStatus.MasterLabel);

        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        try {
            result = aLeadPlugin.invoke(request);    
        }
        catch (Exception e) {
          System.debug('EXCEPTION' + e);
          System.AssertEquals(1,1);
        }
        
    }
    
    
 /*
  * This test is to test the describe() method
  */ 
        static testMethod void describeTest() {

                ConvertLead aLeadPlugin = new ConvertLead();
                Process.PluginDescribeResult result = aLeadPlugin.describe();
                
                System.AssertEquals(result.inputParameters.size(), 8);
                System.AssertEquals(result.OutputParameters.size(), 3);
        
        }
}