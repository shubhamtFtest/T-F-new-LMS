/*
Created by: Matthew Smith - July 22nd 2019
Test class for Process Builder "Populate Geo Location - Sales CW Access Cases" 
*/

@isTest
public class zTest_GeoLocationSalesCWProcessBuilder {
    
	@isTest
    private static void salesCWAccessAustralasia() { //Sales CW Access - Australaisa
		Group queue = [select Name from group where type = 'Queue' and name = 'Sales CW Access - Australasia'];  
        RecordType recordTypeName = [select Name from recordtype where sObjectType = 'Case' and Name = 'T&F - Sales Companion Website Access'];
        //Creating New Case
        Case testCase = new Case ();
        testCase.Subject = 'Test';
        testCase.OwnerId = queue.Id;
        testCase.RecordTypeId = recordTypeName.Id;
		//testCase.OwnerId = '00G1j000000sogX';
        //testCase.RecordTypeId = '0121j000000A5OkAAK';
		
        insert testCase;
        
        // Loading case
        Case loadCase = [SELECT Geographic_Location__c FROM Case WHERE Id = :testCase.Id];
        
        // Check to see if the product platform is Australaisa
        System.assertEquals('Australaisa', loadCase.Geographic_Location__c);
    }
    
    @isTest
    private static void salesCWAccessBenelux() { //Sales CW Access - Benelux
		Group queue = [select Name from group where type = 'Queue' and name = 'Sales CW Access - Benelux'];  
        RecordType recordTypeName = [select Name from recordtype where sObjectType = 'Case' and Name = 'T&F - Sales Companion Website Access'];
        //Creating New Case
        Case testCase = new Case ();
        testCase.Subject = 'Test';
        testCase.OwnerId = queue.Id;
        testCase.RecordTypeId = recordTypeName.Id;
		
        insert testCase;
        
        // Loading case
        Case loadCase = [SELECT Geographic_Location__c FROM Case WHERE Id = :testCase.Id];
        
        // Check to see if the product platform is Benelux
        System.assertEquals('Benelux', loadCase.Geographic_Location__c);
    }

    @isTest
    private static void salesCWAccessCentralSouthErurope() { //Sales CW Access - Central & South Europe
		Group queue = [select Name from group where type = 'Queue' and name = 'Sales CW Access - Central & South Europe'];  
        RecordType recordTypeName = [select Name from recordtype where sObjectType = 'Case' and Name = 'T&F - Sales Companion Website Access'];
        //Creating New Case
        Case testCase = new Case ();
        testCase.Subject = 'Test';
        testCase.OwnerId = queue.Id;
        testCase.RecordTypeId = recordTypeName.Id;
		
        insert testCase;
        
        // Loading case
        Case loadCase = [SELECT Geographic_Location__c FROM Case WHERE Id = :testCase.Id];
        
        // Check to see if the product platform is Central and Southern Europe
        System.assertEquals('Central and Southern Europe', loadCase.Geographic_Location__c);
    }
    
    @isTest
    private static void salesCWAccessEasternEurope() { //Sales CW Access - Eastern Europe
		Group queue = [select Name from group where type = 'Queue' and name = 'Sales CW Access - Eastern Europe'];  
        RecordType recordTypeName = [select Name from recordtype where sObjectType = 'Case' and Name = 'T&F - Sales Companion Website Access'];
        //Creating New Case
        Case testCase = new Case ();
        testCase.Subject = 'Test';
        testCase.OwnerId = queue.Id;
        testCase.RecordTypeId = recordTypeName.Id;
		
        insert testCase;
        
        // Loading case
        Case loadCase = [SELECT Geographic_Location__c FROM Case WHERE Id = :testCase.Id];
        
        // Check to see if the product platform is Eastern Europe
        System.assertEquals('Eastern Europe', loadCase.Geographic_Location__c);
    }

    @isTest
    private static void salesCWAccessIreland() { //Sales CW Access - Ireland
		Group queue = [select Name from group where type = 'Queue' and name = 'Sales CW Access - Ireland'];  
        RecordType recordTypeName = [select Name from recordtype where sObjectType = 'Case' and Name = 'T&F - Sales Companion Website Access'];
        //Creating New Case
        Case testCase = new Case ();
        testCase.Subject = 'Test';
        testCase.OwnerId = queue.Id;
        testCase.RecordTypeId = recordTypeName.Id;
		
        insert testCase;
        
        // Loading case
        Case loadCase = [SELECT Geographic_Location__c FROM Case WHERE Id = :testCase.Id];
        
        // Check to see if the product platform is Ireland
        System.assertEquals('Ireland', loadCase.Geographic_Location__c);
    }
    
	@isTest
    private static void salesCWAccessIsrael() { //Sales CW Access - Israel
		Group queue = [select Name from group where type = 'Queue' and name = 'Sales CW Access - Israel'];  
        RecordType recordTypeName = [select Name from recordtype where sObjectType = 'Case' and Name = 'T&F - Sales Companion Website Access'];
        //Creating New Case
        Case testCase = new Case ();
        testCase.Subject = 'Test';
        testCase.OwnerId = queue.Id;
        testCase.RecordTypeId = recordTypeName.Id;
		
        insert testCase;
        
        // Loading case
        Case loadCase = [SELECT Geographic_Location__c FROM Case WHERE Id = :testCase.Id];
        
        // Check to see if the product platform is Israel
        System.assertEquals('Israel', loadCase.Geographic_Location__c);
    }
    
	@isTest
    private static void salesCWAccessNoridcs() { //Sales CW Access - Nordics
		Group queue = [select Name from group where type = 'Queue' and name = 'Sales CW Access - Nordics'];  
        RecordType recordTypeName = [select Name from recordtype where sObjectType = 'Case' and Name = 'T&F - Sales Companion Website Access'];
        //Creating New Case
        Case testCase = new Case ();
        testCase.Subject = 'Test';
        testCase.OwnerId = queue.Id;
        testCase.RecordTypeId = recordTypeName.Id;
		
        insert testCase;
        
        // Loading case
        Case loadCase = [SELECT Geographic_Location__c FROM Case WHERE Id = :testCase.Id];
        
        // Check to see if the product platform is Nordics
        System.assertEquals('Nordics', loadCase.Geographic_Location__c);
    }
    
	@isTest
    private static void salesCWAccessROW() { //Sales CW Access - ROW
		Group queue = [select Name from group where type = 'Queue' and name = 'Sales CW Access - ROW'];  
        RecordType recordTypeName = [select Name from recordtype where sObjectType = 'Case' and Name = 'T&F - Sales Companion Website Access'];
        //Creating New Case
        Case testCase = new Case ();
        testCase.Subject = 'Test';
        testCase.OwnerId = queue.Id;
        testCase.RecordTypeId = recordTypeName.Id;
		
        insert testCase;
        
        // Loading case
        Case loadCase = [SELECT Geographic_Location__c FROM Case WHERE Id = :testCase.Id];
        
        // Check to see if the product platform is Rest of World
        System.assertEquals('Rest of World', loadCase.Geographic_Location__c);
    }
    
	@isTest
    private static void salesCWAccessUK() { //Sales CW Access - UK
		Group queue = [select Name from group where type = 'Queue' and name = 'Sales CW Access - UK'];  
        RecordType recordTypeName = [select Name from recordtype where sObjectType = 'Case' and Name = 'T&F - Sales Companion Website Access'];
        //Creating New Case
        Case testCase = new Case ();
        testCase.Subject = 'Test';
        testCase.OwnerId = queue.Id;
        testCase.RecordTypeId = recordTypeName.Id;
		
        insert testCase;
        
        // Loading case
        Case loadCase = [SELECT Geographic_Location__c FROM Case WHERE Id = :testCase.Id];
        
        // Check to see if the product platform is UK
        System.assertEquals('UK', loadCase.Geographic_Location__c);
    }
    
	@isTest
    private static void salesCWAccessUSLatAmCanada() { //Sales CW Access - US, LatAm & Canada
		Group queue = [select Name from group where type = 'Queue' and name = 'Sales CW Access - US, LatAm & Canada'];  
        RecordType recordTypeName = [select Name from recordtype where sObjectType = 'Case' and Name = 'T&F - Sales Companion Website Access'];
        //Creating New Case
        Case testCase = new Case ();
        testCase.Subject = 'Test';
        testCase.OwnerId = queue.Id;
        testCase.RecordTypeId = recordTypeName.Id;
		
        insert testCase;
        
        // Loading case
        Case loadCase = [SELECT Geographic_Location__c FROM Case WHERE Id = :testCase.Id];
        
        // Check to see if the product platform is US, Latin America and Canada
        System.assertEquals('US, Latin America and Canada', loadCase.Geographic_Location__c);
    }
    
}