@isTest
public class zTEST_TF_PostOrderOnOrderHubWrapRequest {
    @isTest
    public static void TF_PostOrderOnOrderHubWrapRequestTest(){
        
        TF_PostOrderOnOrderHubWrapRequest TF_PostOrderOnOrderHubWrapRequestObj = new TF_PostOrderOnOrderHubWrapRequest();
        TF_PostOrderOnOrderHubWrapRequestObj.invoiceFormat = 'Normal';
        
        TF_PostOrderOnOrderHubWrapRequestObj.orderDate = 'Test';
        TF_PostOrderOnOrderHubWrapRequestObj.buyerId = 'Test';
        TF_PostOrderOnOrderHubWrapRequestObj.orderPrice = 1;
        TF_PostOrderOnOrderHubWrapRequestObj.customerId = 'Test';
        TF_PostOrderOnOrderHubWrapRequestObj.orderStatus = 'Test';
        TF_PostOrderOnOrderHubWrapRequestObj.confirmationNumber = 'Test';
        TF_PostOrderOnOrderHubWrapRequestObj.seller = 'Test';
        TF_PostOrderOnOrderHubWrapRequestObj.quoteNumber = 'Test';
        TF_PostOrderOnOrderHubWrapRequestObj.notes = 'Test';
        TF_PostOrderOnOrderHubWrapRequestObj.opportunityId = 'Test';
        TF_PostOrderOnOrderHubWrapRequestObj.externalOrderRef = 'Test';
        TF_PostOrderOnOrderHubWrapRequestObj.externalSystemRefId = 'Test';
        TF_PostOrderOnOrderHubWrapRequestObj.subTotalPrice = 1;
        TF_PostOrderOnOrderHubWrapRequestObj.channel = 'Test';
        TF_PostOrderOnOrderHubWrapRequestObj.totalTax = 1;
        TF_PostOrderOnOrderHubWrapRequestObj.orderType = 'Test';
        
        TF_PostOrderOnOrderHubWrapRequest.fulfillments flm = new  TF_PostOrderOnOrderHubWrapRequest.fulfillments();
        flm.description='test';
        flm.licenseType='test';
        flm.termEndDate='test';
        flm.termStartDate='test';
        flm.grantType = new list<string>{'1','2'};
            flm.name='xyz';
        TF_PostOrderOnOrderHubWrapRequestObj.fulfillments = new list<TF_PostOrderOnOrderHubWrapRequest.fulfillments>{flm};
            
            List<integer> sponsorRefId = new List<integer>();
        
        for(integer i=0 ; i<5;i++){
            sponsorRefId.add(i);
        }
        
        TF_PostOrderOnOrderHubWrapRequest.orderedItem orderedItemm = new TF_PostOrderOnOrderHubWrapRequest.orderedItem();
        orderedItemm.salesOrg = 'Test';
        orderedItemm.productId = 'Test';
        orderedItemm.discountCode = 'Test';
        orderedItemm.discountCurrency = 'Test';
        orderedItemm.lineItemType = 'Test';
        orderedItemm.taxCode = 'Test';
        orderedItemm.currencyy = 'Test';
        orderedItemm.description = 'Test';
        orderedItemm.price = 1;
        orderedItemm.discount = 1;
        orderedItemm.discountAmount = 1;
        orderedItemm.orderedQuantity = 1;
        orderedItemm.quantity = 1;
        orderedItemm.taxAmount = 1;
        orderedItemm.sellingPrice = 1;
        orderedItemm.sponsorRefId = sponsorRefId;
        orderedItemm.altProductId = 'Test';
        orderedItemm.salesType = 'test';
        TF_PostOrderOnOrderHubWrapRequestObj.orderedItem = new list<TF_PostOrderOnOrderHubWrapRequest.orderedItem>{orderedItemm};
            
            TF_PostOrderOnOrderHubWrapRequest.shippingAddress  shippingAddresss = new TF_PostOrderOnOrderHubWrapRequest.shippingAddress();
        shippingAddresss.houseNumber ='Test';
        shippingAddresss.addressOrganisation ='Test';
        shippingAddresss.postalCode ='Test';
        shippingAddresss.addressContactEmail ='Test';
        shippingAddresss.streetAddress ='Test';
        shippingAddresss.addressContactName ='Test';
        shippingAddresss.businessPartnerNo ='Test';
        shippingAddresss.addressRegion ='Test';
        shippingAddresss.countryCode ='Test';
        shippingAddresss.addressLocality ='Test';
        shippingAddresss.telephoneNo ='Test';
        shippingAddresss.addressCountry ='Test';
        shippingAddresss.externalCustomerAddressId ='Test';
        shippingAddresss.addressLine3 ='Test';
        shippingAddresss.taxRegistrationNumber ='Test';
        shippingAddresss.addressLine2 ='Test';
        shippingAddresss.taxCategory ='Test';
        shippingAddresss.addressLine1 ='Test';
        shippingAddresss.careOf ='Test';
        shippingAddresss.addressContactFirstName ='Test';
        shippingAddresss.addressContactLastName ='Test';
        
        //TF_PostOrderOnOrderHubWrapRequest.shippingAddress = shippingAddresss;
        
        TF_PostOrderOnOrderHubWrapRequest.billingAddress  billingAddresss = new TF_PostOrderOnOrderHubWrapRequest.billingAddress();
        billingAddresss.houseNumber ='Test';
        billingAddresss.addressOrganisation='Test'; 
        billingAddresss.postalCode ='Test';
        billingAddresss.addressContactEmail='Test'; 
        billingAddresss.streetAddress ='Test';
        billingAddresss.addressContactName='Test'; 
        billingAddresss.businessPartnerNo ='Test';
        billingAddresss.addressRegion='Test'; 
        billingAddresss.countryCode ='Test';
        billingAddresss.addressLocality='Test'; 
        billingAddresss.telephoneNo ='Test';
        billingAddresss.addressCountry='Test'; 
        billingAddresss.externalCustomerAddressId ='Test';
        billingAddresss.addressLine3='Test'; 
        billingAddresss.taxRegistrationNumber ='Test';
        billingAddresss.addressLine2='Test'; 
        billingAddresss.taxCategory ='Test';
        billingAddresss.addressLine1='Test';
        billingAddresss.careOf='Test'; 
        billingAddresss.addressContactFirstName ='Test';
        billingAddresss.addressContactLastName='Test';
        
        TF_PostOrderOnOrderHubWrapRequest.funderlicense  funderlicense = new TF_PostOrderOnOrderHubWrapRequest.funderlicense();
        funderlicense.description ='Test';
        funderlicense.type='Test'; 
        funderlicense.location ='Test';
        
        TF_PostOrderOnOrderHubWrapRequest.funderdetails  funderdetails = new TF_PostOrderOnOrderHubWrapRequest.funderdetails();
        funderdetails.name ='Test';
        funderdetails.awardId='Test'; 
        funderdetails.awardType ='Test';
        funderdetails.sfCustomerId ='Test';
        funderdetails.externalRefId='Test'; 
        funderdetails.orcidId ='Test';
        
        TF_PostOrderOnOrderHubWrapRequest.fundersponsor  fundersponsor = new TF_PostOrderOnOrderHubWrapRequest.fundersponsor();
        fundersponsor.refId = 121;
        fundersponsor.fundingStatement='Test'; 
        fundersponsor.details = funderdetails;
        fundersponsor.license= funderlicense; 
        
        List<TF_PostOrderOnOrderHubWrapRequest.fundersponsor> sponsorslist = new List<TF_PostOrderOnOrderHubWrapRequest.fundersponsor>();
        sponsorslist.add(fundersponsor);
        
        //TF_PostOrderOnOrderHubWrapRequest.sponsors = sponsorslist;
    }
}