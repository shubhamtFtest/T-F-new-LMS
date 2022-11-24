@isTest
public class TF_AG_TokenGenerate_testClass 
{
    @isTest
    public static void func1()
    {
        TF_AG_TokenGenerate obj = new TF_AG_TokenGenerate(); 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TF_AG_MockHttpResponseGenerator());        
        TF_AG_TokenGenerate.getToken();
        Test.stopTest();
    }
}