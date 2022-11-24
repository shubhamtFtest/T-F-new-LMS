@isTest
global with sharing class zTEST_Do_Nothing {

    @isTest static void testName() {
    	Test.startTest();
        Do_Nothing.doNothing(); 
        Test.stopTest();
    }
}