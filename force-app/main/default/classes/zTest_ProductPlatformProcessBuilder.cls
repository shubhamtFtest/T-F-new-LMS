/*
Created by: Matthew Smith - March 3rd 2019
Test class for Process Builder "Update Product Platform From Email Address - Cases" 
Edited by: Matthew Smith - July 23rd 2019. Updated the last method to pass Prod. 
*/

@isTest
public class zTest_ProductPlatformProcessBuilder {
    
    @isTest
    // Method for APC - apc@tandf.co.uk
    private static void creatingTestCaseForAPC(){
                
        // Creating a new case
        Case testCase = new Case();
        testCase.subject = 'Test Case';
        testCase.Status = 'New';
        // Inserting case
        insert testCase;
        
        // Create a new email
        EmailMessage testEmail = new EmailMessage();
        testEmail.ToAddress = 'apc@tandf.co.uk';
        testEmail.FromAddress = 'test@test.com';
        testEmail.Subject = 'Test Email';
        testEmail.HtmlBody = 'Testing case';
        testEmail.ParentId = testCase.Id;
        // Inserting email
        insert testEmail;
                
        // Loading case
        Case loadCase = [SELECT Product_Platform__c FROM Case WHERE Id = :testCase.Id];
        
        // Check to see if the product platform is APC
        System.assertEquals('APCs', loadCase.Product_Platform__c);
      
    }    
    
    @isTest
    // Method for Book Royalties - mpkroyalties@tandf.co.uk 
    private static void creatingTestCaseForBooksRoyalties(){
        // Creating a new case
        Case testCase = new Case();
        testCase.Subject = 'Test Case';
        testCase.Status = 'New';
        // Inserting case
        insert testCase;
        
        // Create a new email
        EmailMessage testEmail = new EmailMessage();
        testEmail.ToAddress = 'mpkroyalties@tandf.co.uk';
        testEmail.FromAddress = 'test@test.com';
        testEmail.Subject = 'Test Email';
        testEmail.HtmlBody = 'Testing case';
        testEmail.ParentId = testCase.Id;
        // Inserting email
        insert testEmail;
                
        // Loading case
        Case loadCase = [SELECT Product_Platform__c FROM Case WHERE Id = :testCase.Id];
        
        // Check to see if the product platform is Book Royalties
        System.assertEquals('Books Royalties', loadCase.Product_Platform__c);
      
    }

    @isTest
    // Method for Taylor and Francis eBooks - support@taylorfrancis.com
    private static void creatingTestCaseForEBooks(){
        // Creating a new case
        Case testCase = new Case();
        testCase.Subject = 'Test Case';
        testCase.Status = 'New';
        // Inserting case
        insert testCase;
        
        // Create a new email
        EmailMessage testEmail = new EmailMessage();
        testEmail.ToAddress = 'support@taylorfrancis.com';
        testEmail.FromAddress = 'test@test.com';
        testEmail.Subject = 'Test Email';
        testEmail.HtmlBody = 'Testing case';
        testEmail.ParentId = testCase.Id;
        // Inserting email
        insert testEmail;
                
        // Loading case
        Case loadCase = [SELECT Product_Platform__c FROM Case WHERE Id = :testCase.Id];
        
        // Check to see if the product platform is eBooks
        System.assertEquals('Taylor & Francis eBooks', loadCase.Product_Platform__c);
      
    }    
    
    @isTest
    // Method for UNSDGO - sdgsupport@taylorfrancis.com
    private static void creatingTestCaseForUNSDGO(){
        // Creating a new case
        Case testCase = new Case();
        testCase.Subject = 'Test Case';
        testCase.Status = 'New';
        // Inserting case
        insert testCase;
        
        // Create a new email
        EmailMessage testEmail = new EmailMessage();
        testEmail.ToAddress = 'sdgsupport@taylorfrancis.com';
        testEmail.FromAddress = 'test@test.com';
        testEmail.Subject = 'Test Email';
        testEmail.HtmlBody = 'Testing case';
        testEmail.ParentId = testCase.Id;
        // Inserting email
        insert testEmail;
                
        // Loading case
        Case loadCase = [SELECT Product_Platform__c FROM Case WHERE Id = :testCase.Id];
        
        // Check to see if the product platform is UNSDGO
        System.assertEquals('UNSDGO', loadCase.Product_Platform__c);
      
    }    
    
}