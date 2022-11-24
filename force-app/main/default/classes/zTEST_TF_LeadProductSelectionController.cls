/**
 * Tests: TF_LeadProductSelectionController.cls    86%
 * 
 */
@isTest

private class zTEST_TF_LeadProductSelectionController {

  static testMethod void test_TF_LeadProductSelectionController() {
    User u = zTEST_Shared.insertUser();
    Product2 p = zTEST_Shared.insertProduct2();
    Pricebook2 standardPb = zTEST_Shared.insertPricebook2_2();
    Pricebook2 pb = new Pricebook2();
    pb.Name = 'T&F Journals Price Book';
    pb.IsActive = true;
    insert pb;
    PricebookEntry standardPbe = new PricebookEntry(Pricebook2Id=standardPb.Id, Product2Id=p.id, UnitPrice=1.00, IsActive=true, UseStandardPrice=false, CurrencyIsoCode='USD');
    PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pb.Id, Product2Id=p.id, UnitPrice=1.00, IsActive=true, UseStandardPrice=false, CurrencyIsoCode='USD');
    //Update the RecordType on 10/09/2016
    Id recordtypeId = MiscFunctions.getRecordtypeId('Lead', 'T&F - Leads');    
    Lead l = zTEST_Shared.insertLead(u.Id, recordtypeId);
    
    Test.startTest();
    
    pageReference pg = Page.TF_LeadProductSelection;
    pg.getParameters().put('id', l.Id);
    Test.setCurrentPage(pg);
    TF_LeadProductSelectionController con = new TF_LeadProductSelectionController(new ApexPages.StandardController(l));
    
    List<SelectOption> tfProducts = con.gettfProducts();

    Boolean bTest = con.isEditMode;
    bTest = con.isDisplayMode;

    con.changeProduct();
    
    String sTest = con.tfProductId;
    sTest = con.tfProductName;
    con.tfProductId = p.Id;
    con.tfProductName = p.Name;
    sTest = con.tfProductId;
    sTest = con.tfProductName;
    
    con.updateProduct();
    con.cancel();
    
    Test.stopTest();
  }
}