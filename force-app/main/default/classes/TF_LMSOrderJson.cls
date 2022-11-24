/***************************************************************************
Author : Vikas Varshney
Description : This class is used for bespoke collection JSON creation for SingleTitles/Bespoke Collections, Collections (Static/Dynamic) //SFAL-117, SFAL-338, SFAL-438
Test class : zTest_TF_LMSOrderJson
****************************************************************************/

public class TF_LMSOrderJson {
    static Map<String, String> countryNameToCodeMap = new Map<String, String>();
    
    //this method is used to create JSON for SingleTitles/Bespoke Collections for multiple quotes with bulkification
    public static Map<String, String> createLMSOrderJson (List<String> quoteIdList) {
        Map<String, String> quoteIdToJsonMap = new Map<String, String>();
        
        try {
            List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
            Set<String> oppIdSet = new Set<String>();
            Map<String, List<Order>> opportunityidToOrderListMap = new Map<String, List<Order>>();
            Map<String, List<Bundle_Line_Item__c>> productIdToBundleItemListMap = new Map<String, List<Bundle_Line_Item__c>>();
            //String bespokeProdRTId = PCMOppSyncControllerDS.getCustomSettingData().recordTypeId;
            String bespokeProdRTId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - BespokeCollection').getRecordTypeId(); //PCMOppSyncControllerDS.getProdRecordTypeId('Product2', 'T&F - BespokeCollection');
            
            //fetching Quotes and it's items details
            quoteList = [ SELECT id, Name, SBQQ__Opportunity2__c, SBQQ__Opportunity2__r.AccountId, SBQQ__Opportunity2__r.Account.Customer_Id__c, SBQQ__Opportunity2__r.TF_eBook_License_Type__c, SBQQ__Opportunity2__r.Bill_to_BP__c, SBQQ__Opportunity2__r.Bill_to_BP__r.Address_Type__c, SBQQ__Opportunity2__r.Bill_to_BP__r.Account_Id__c, SBQQ__Opportunity2__r.Bill_to_BP__r.Account_Id__r.Customer_Id__c, SBQQ__Opportunity2__r.Bill_to_BP__r.Campus_Id__c, SBQQ__Opportunity2__r.Bill_to_BP__r.Campus_Id__r.Account__c, SBQQ__Opportunity2__r.Bill_to_BP__r.Campus_Id__r.Account__r.Customer_Id__c, SBQQ__Opportunity2__r.Bill_to_BP__r.Department_Id__c, SBQQ__Opportunity2__r.Bill_to_BP__r.Department_Id__r.Account__c, SBQQ__Opportunity2__r.Bill_to_BP__r.Department_Id__r.Account__r.Customer_Id__c, SBQQ__Opportunity2__r.Bill_to_BP__r.Name, SBQQ__Opportunity2__r.Bill_to_BP__r.Region__c, SBQQ__Opportunity2__r.Bill_to_BP__r.State__c, SBQQ__Opportunity2__r.Bill_to_BP__r.Street__c, SBQQ__Opportunity2__r.Bill_to_BP__r.ZIP__c, SBQQ__Opportunity2__r.Bill_to_BP__r.City__c, SBQQ__Opportunity2__r.Bill_to_BP__r.Country__c, SBQQ__Opportunity2__r.Bill_to_BP__r.Status__c, SBQQ__Opportunity2__r.Bill_to_BP__r.Email__c, SBQQ__Opportunity2__r.Bill_to_BP__r.First_Name__c, SBQQ__Opportunity2__r.Bill_to_BP__r.Last_Name__c, SBQQ__Opportunity2__r.Bill_to_BP__r.Department__c, SBQQ__Opportunity2__r.Bill_to_BP__r.Tax_Registration_Number__c, SBQQ__Opportunity2__r.Bill_to_BP__r.Care_of__c, SBQQ__Opportunity2__r.Bill_to_BP__r.Tax_Number_Category__c, SBQQ__Opportunity2__r.Ship_to_BP__c, SBQQ__Opportunity2__r.Ship_to_BP__r.Name, SBQQ__Opportunity2__r.Ship_to_BP__r.Address_Type__c, SBQQ__Opportunity2__r.Ship_to_BP__r.Account_Id__c, SBQQ__Opportunity2__r.Ship_to_BP__r.Campus_Id__c, SBQQ__Opportunity2__r.Ship_to_BP__r.Department_Id__c, SBQQ__Opportunity2__r.Ship_to_BP__r.Region__c, SBQQ__Opportunity2__r.Ship_to_BP__r.State__c, SBQQ__Opportunity2__r.Ship_to_BP__r.Street__c, SBQQ__Opportunity2__r.Ship_to_BP__r.ZIP__c, SBQQ__Opportunity2__r.Ship_to_BP__r.City__c, SBQQ__Opportunity2__r.Ship_to_BP__r.Country__c, SBQQ__Opportunity2__r.Ship_to_BP__r.Status__c, SBQQ__Opportunity2__r.Ship_to_BP__r.Email__c, SBQQ__Opportunity2__r.Ship_to_BP__r.First_Name__c, SBQQ__Opportunity2__r.Ship_to_BP__r.Last_Name__c, SBQQ__Opportunity2__r.Ship_to_BP__r.Department__c, SBQQ__Opportunity2__r.Ship_to_BP__r.Tax_Registration_Number__c, SBQQ__Opportunity2__r.Ship_to_BP__r.Care_of__c, SBQQ__Opportunity2__r.Ship_to_BP__r.Tax_Number_Category__c, CreatedDate, RecordTypeId, Purchase_Order_Number__c, SBQQ__Notes__c, Invoice_Format__c, DOI__c, SBQQ__NetAmount__c, Quote_Sales_Type__c, TF_eBook_Subscription_Start_Date__c, TF_eBook_Subscription_End_Date__c, Business_Model__c, ( SELECT id, SBQQ__Product__c, SBQQ__Product__r.RecordTypeId, SBQQ__Product__r.Product_Type_Author_Facing__c, PCM_UUID__c FROM SBQQ__LineItems__r ) FROM SBQQ__Quote__c WHERE id IN:quoteIdList ]; //need to add isPrimary
            
            //creating opportunity id's set to get its order to submit to OMS
            if ( !quoteList.isEmpty() ) {
                for ( SBQQ__Quote__c sbqqQuote : quoteList ) {
                    if ( sbqqQuote.SBQQ__Opportunity2__c != Null ) {
                        oppIdSet.add( sbqqQuote.SBQQ__Opportunity2__c );
                    }
                    
                    if ( !sbqqQuote.SBQQ__LineItems__r.isEmpty() && sbqqQuote.SBQQ__LineItems__r[0].SBQQ__Product__c != Null && bespokeProdRTId == sbqqQuote.SBQQ__LineItems__r[0].SBQQ__Product__r.RecordTypeId && 'Manual Curation'.equalsIgnoreCase(sbqqQuote.SBQQ__LineItems__r[0].SBQQ__Product__r.Product_Type_Author_Facing__c) ) {
                        productIdToBundleItemListMap.put( sbqqQuote.SBQQ__LineItems__r[0].SBQQ__Product__c, new List<Bundle_Line_Item__c>() );
                    }
                }
            }
            
            //creating a map of opportunity id and its orders
            if ( !oppIdSet.isEmpty() ) {
                //fetching orders and order items for each opportunity
                for ( Order ord : [ SELECT id, OrderNumber, OpportunityId, AccountId, CreatedDate, SBQQ_TotalAmount__c, TotalAmount, ( SELECT id, Product2Id, Product2.Product_Type_Author_Facing__c, SBQQ_NetTotal__c, SBQQ__TaxAmount__c, ISBN__c, PCM_UUID__c, SBQQ__QuotedListPrice__c, CurrencyIsoCode, SBQQ__OrderedQuantity__c, Total_Discount_Percentage__c FROM OrderItems ) FROM Order WHERE OpportunityId IN:oppIdSet ] ) {
                    if ( !opportunityidToOrderListMap.containsKey( ord.OpportunityId ) ) {
                        opportunityidToOrderListMap.put( ord.OpportunityId, new List<Order>() );
                    }
                    opportunityidToOrderListMap.get(ord.OpportunityId).add(ord);
                }
            }
            
            //fetching bundle line items for each parent product
            if ( !productIdToBundleItemListMap.isEmpty() ) {
                for ( Bundle_Line_Item__c bundleLineItem : [ SELECT id, name, CurrencyIsoCode, Product_Bundle_Parent__c, Title__c, Authors__c, doi__c, Product_Doi__c, Type__c, uuid__c, mediaType__c, lineItemStatus__c, Publisher__c, Open_access__c, Publication_Date__c, PriceUSD__c, PriceGBP__c, Product_Isbn__c FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c IN:productIdToBundleItemListMap.keySet() ORDER BY Content_Position__c ASC ] ) {
                    productIdToBundleItemListMap.get(bundleLineItem.Product_Bundle_Parent__c).add(bundleLineItem);
                }
            }
            
            //fetching country ISO2 code
            for ( Country__c counttry : [ SELECT Name, Country_2__c FROM Country__c ] ) {
                countryNameToCodeMap.put(counttry.Name, counttry.Country_2__c);
            }
            
            if ( !quoteList.isEmpty() ) {
                for ( SBQQ__Quote__c quoteRecord : quoteList ) {
                    //Assuming there would be a single order for each opportunity in case of bespoke
                    List<SAP_BP__c> billToSapBPList = new List<SAP_BP__c>();
                    List<SAP_BP__c> shipToSapBPList = new List<SAP_BP__c>();
                    Order orderRecord = new Order();
                    Decimal orderItemsNetTotalSum = 0;
                    Decimal orderItemsTaxAmtSum = 0;
                    
                    //creating Bill To BP list
                    if ( quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__c != Null ) {
                        billToSapBPList.add( new SAP_BP__c( id = quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__c, Name = quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.Name, Address_Type__c = quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.Address_Type__c, Account_Id__c = quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.Account_Id__c, Campus_Id__c = quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.Campus_Id__c, Department_Id__c = quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.Department_Id__c, Region__c = quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.Region__c, State__c = quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.State__c, Street__c = quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.Street__c, ZIP__c = quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.ZIP__c, City__c = quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.City__c, Country__c = quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.Country__c, Status__c = quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.Status__c, Email__c = quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.Email__c, First_Name__c = quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.First_Name__c, Last_Name__c = quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.Last_Name__c, Department__c = quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.Department__c, Tax_Registration_Number__c = quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.Tax_Registration_Number__c, Care_of__c = quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.Care_of__c, Tax_Number_Category__c = quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.Tax_Number_Category__c ) );
                    }
                    
                    //creating Ship To BP list
                    if ( quoteRecord.SBQQ__Opportunity2__r.Ship_to_BP__c != Null ) {
                        shipToSapBPList.add( new SAP_BP__c( id = quoteRecord.SBQQ__Opportunity2__r.Ship_to_BP__c, Name = quoteRecord.SBQQ__Opportunity2__r.Ship_to_BP__r.Name, Address_Type__c = quoteRecord.SBQQ__Opportunity2__r.Ship_to_BP__r.Address_Type__c, Account_Id__c = quoteRecord.SBQQ__Opportunity2__r.Ship_to_BP__r.Account_Id__c, Campus_Id__c = quoteRecord.SBQQ__Opportunity2__r.Ship_to_BP__r.Campus_Id__c, Department_Id__c = quoteRecord.SBQQ__Opportunity2__r.Ship_to_BP__r.Department_Id__c, Region__c = quoteRecord.SBQQ__Opportunity2__r.Ship_to_BP__r.Region__c, State__c = quoteRecord.SBQQ__Opportunity2__r.Ship_to_BP__r.State__c, Street__c = quoteRecord.SBQQ__Opportunity2__r.Ship_to_BP__r.Street__c, ZIP__c = quoteRecord.SBQQ__Opportunity2__r.Ship_to_BP__r.ZIP__c, City__c = quoteRecord.SBQQ__Opportunity2__r.Ship_to_BP__r.City__c, Country__c = quoteRecord.SBQQ__Opportunity2__r.Ship_to_BP__r.Country__c, Status__c = quoteRecord.SBQQ__Opportunity2__r.Ship_to_BP__r.Status__c, Email__c = quoteRecord.SBQQ__Opportunity2__r.Ship_to_BP__r.Email__c, First_Name__c = quoteRecord.SBQQ__Opportunity2__r.Ship_to_BP__r.First_Name__c, Last_Name__c = quoteRecord.SBQQ__Opportunity2__r.Ship_to_BP__r.Last_Name__c, Department__c = quoteRecord.SBQQ__Opportunity2__r.Ship_to_BP__r.Department__c, Tax_Registration_Number__c = quoteRecord.SBQQ__Opportunity2__r.Ship_to_BP__r.Tax_Registration_Number__c, Care_of__c = quoteRecord.SBQQ__Opportunity2__r.Ship_to_BP__r.Care_of__c, Tax_Number_Category__c = quoteRecord.SBQQ__Opportunity2__r.Ship_to_BP__r.Tax_Number_Category__c ) );
                    }
                    
                    if ( opportunityidToOrderListMap.containsKey(quoteRecord.SBQQ__Opportunity2__c) ) {
                        orderRecord = opportunityidToOrderListMap.get(quoteRecord.SBQQ__Opportunity2__c)[0];
                    }
                    
                    //populating wrapper record
                    BespokeOrderWrapper BespokeOrderWrapRecord = new BespokeOrderWrapper ();
                    BespokeOrderWrapRecord.billingAddress = new BillingAddress();
                    BespokeOrderWrapRecord.shippingAddress = new ShippingAddress();
                    BespokeOrderWrapRecord.orderedItem = new List<OrderedItem>();
                    BespokeOrderWrapRecord.orderType = 'SALES';
                    BespokeOrderWrapRecord.channel = 'UBX';
                    BespokeOrderWrapRecord.externalSystemRefId = orderRecord.OpportunityId != Null ? orderRecord.OpportunityId : ( quoteRecord.SBQQ__Opportunity2__c != Null ? quoteRecord.SBQQ__Opportunity2__c : '' ); //SFAL-597 Vikas Varshney
                    //BespokeOrderWrapRecord.fulfillments = new List<String>(); //SFAL-597 Vikas Varshney
                    BespokeOrderWrapRecord.externalOrderRef =  ( String.isNotBlank(quoteRecord.Purchase_Order_Number__c) ? quoteRecord.Purchase_Order_Number__c : ( orderRecord.OrderNumber != Null ? orderRecord.OrderNumber : '' ) );
                    BespokeOrderWrapRecord.notes = ( quoteRecord.SBQQ__Notes__c != NULL ? quoteRecord.SBQQ__Notes__c : '' );
                    BespokeOrderWrapRecord.customerId = ( ( quoteRecord.SBQQ__Opportunity2__r.Account != Null && quoteRecord.SBQQ__Opportunity2__r.Account.Customer_Id__c != NULL ) ? quoteRecord.SBQQ__Opportunity2__r.Account.Customer_Id__c : '' );
                    BespokeOrderWrapRecord.buyerId = ( ( quoteRecord.SBQQ__Opportunity2__r.Account != Null && quoteRecord.SBQQ__Opportunity2__r.Account.Customer_Id__c != NULL ) ? quoteRecord.SBQQ__Opportunity2__r.Account.Customer_Id__c : '' );
                    if ( quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__c != Null && quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.Address_Type__c.containsIgnoreCase('Account') ) {
                        BespokeOrderWrapRecord.buyerId = ( quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.Account_Id__c != Null && quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.Account_Id__r.Customer_Id__c != Null ) ? quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.Account_Id__r.Customer_Id__c : ''; //instead of blank we can give opportunity's account's party id
                    } else if ( quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__c != Null && quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.Address_Type__c.containsIgnoreCase('Campus') ) {
                        BespokeOrderWrapRecord.buyerId = ( quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.Campus_Id__c != Null && quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.Campus_Id__r.Account__c != Null && quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.Campus_Id__r.Account__r.Customer_Id__c != Null ) ? quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.Campus_Id__r.Account__r.Customer_Id__c : ''; //instead of blank we can give opportunity's account's party id
                    } else if ( quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__c != Null && quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.Address_Type__c.containsIgnoreCase('Department') ) {
                        BespokeOrderWrapRecord.buyerId = ( quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.Department_Id__c != Null && quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.Department_Id__r.Account__c != Null && quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.Department_Id__r.Account__r.Customer_Id__c != Null ) ? quoteRecord.SBQQ__Opportunity2__r.Bill_to_BP__r.Department_Id__r.Account__r.Customer_Id__c : ''; //instead of blank we can give opportunity's account's party id
                    }
                    BespokeOrderWrapRecord.orderDate = orderRecord.CreatedDate != Null ? String.valueOf(orderRecord.CreatedDate) : '';
                    BespokeOrderWrapRecord.orderStatus = 'OPEN';
                    BespokeOrderWrapRecord.seller = 'TANDF';
                    BespokeOrderWrapRecord.subTotalPrice = orderRecord.TotalAmount != Null ? orderRecord.TotalAmount : 0;
                    
                    if ( quoteRecord.Quote_Sales_Type__c != Null && quoteRecord.SBQQ__Opportunity2__r.TF_eBook_License_Type__c != Null && quoteRecord.Quote_Sales_Type__c.equalsIgnoreCase('Bespoke Collection')  && quoteRecord.SBQQ__Opportunity2__r.TF_eBook_License_Type__c.equalsIgnoreCase('Static') && !quoteRecord.SBQQ__LineItems__r.isEmpty() && bespokeProdRTId == quoteRecord.SBQQ__LineItems__r[0].SBQQ__Product__r.RecordTypeId && 'Manual Curation'.equalsIgnoreCase(quoteRecord.SBQQ__LineItems__r[0].SBQQ__Product__r.Product_Type_Author_Facing__c) ) { //for single title no fulfillmentRequest should populate
                        //populating fulfillmentRequest
                        BespokeOrderWrapRecord.fulfillmentRequest = new FulfillmentRequest();
                        BespokeOrderWrapRecord.fulfillmentRequest.policies = new Policies();
                        if ( quoteRecord.SBQQ__LineItems__r != Null && String.isNotBlank(quoteRecord.SBQQ__LineItems__r[0].PCM_UUID__c) ) {
                            BespokeOrderWrapRecord.fulfillmentRequest.productId = quoteRecord.SBQQ__LineItems__r[0].PCM_UUID__c;
                        } else {
                            BespokeOrderWrapRecord.fulfillmentRequest.productId = ''; //mapping need to check with Chetan --> PCMUUID field on QLI
                        }
                        BespokeOrderWrapRecord.fulfillmentRequest.requestType = 'EBOOK_CONTENT_ACCESS';
                        BespokeOrderWrapRecord.fulfillmentRequest.productType = 'BESPOKE COLLECTION'; //SFAL-530
                        BespokeOrderWrapRecord.fulfillmentRequest.startDate = quoteRecord.TF_eBook_Subscription_Start_Date__c != Null ? String.valueOf(quoteRecord.TF_eBook_Subscription_Start_Date__c) : ''; //SFAL-160 Vikas Varshney
                        BespokeOrderWrapRecord.fulfillmentRequest.endDate = ( quoteRecord.Business_Model__c != Null && quoteRecord.TF_eBook_Subscription_End_Date__c != Null && quoteRecord.Business_Model__c.containsIgnoreCase('Subscription') ) ? String.valueOf(quoteRecord.TF_eBook_Subscription_End_Date__c) : ''; //SFAL-160 Vikas Varshney
                        BespokeOrderWrapRecord.fulfillmentRequest.licenseType = 'Perpetual'; //In phase 2 "Subscription" sales need to handle
                        /*if ( quoteRecord.SBQQ__LineItems__r != Null && 'Manual Curation'.equalsIgnoreCase(quoteRecord.SBQQ__LineItems__r[0].SBQQ__Product__r.Product_Type_Author_Facing__c) && bespokeProdRTId == quoteRecord.SBQQ__LineItems__r[0].SBQQ__Product__r.RecordTypeId ) {
                            BespokeOrderWrapRecord.fulfillmentRequest.licenseUpdateType = 'Static';
                        } else if ( quoteRecord.SBQQ__LineItems__r != Null && 'Rule based'.equalsIgnoreCase(quoteRecord.SBQQ__LineItems__r[0].SBQQ__Product__r.Product_Type_Author_Facing__c) && bespokeProdRTId == quoteRecord.SBQQ__LineItems__r[0].SBQQ__Product__r.RecordTypeId ) {
                            BespokeOrderWrapRecord.fulfillmentRequest.licenseUpdateType = 'Static'; //Dynamic based license type need to be concluded with BA
                        } else {
                            BespokeOrderWrapRecord.fulfillmentRequest.licenseUpdateType = 'Static';
                        }*/
                        BespokeOrderWrapRecord.fulfillmentRequest.licenseUpdateType = quoteRecord.SBQQ__Opportunity2__r.TF_eBook_License_Type__c != Null ? quoteRecord.SBQQ__Opportunity2__r.TF_eBook_License_Type__c : 'Static'; //SFAL-530 Vikas Varshney/26-Aug-2022
                        BespokeOrderWrapRecord.fulfillmentRequest.licenseUpdateEndDate = ''; //Depends on Dynamic case license type
                        BespokeOrderWrapRecord.fulfillmentRequest.accessScope = 'Global';
                        BespokeOrderWrapRecord.fulfillmentRequest.policies.drm = false;
                        BespokeOrderWrapRecord.fulfillmentRequest.policies.concurrency = '1';
                        BespokeOrderWrapRecord.fulfillmentRequest.policies.grantType = new List<String>{'ViewOnline','Download'};
                        BespokeOrderWrapRecord.fulfillmentRequest.policies.copyCount = '0';
                        BespokeOrderWrapRecord.fulfillmentRequest.policies.printCount = '0';
                    }
                    
                    //populating orderedItem list in case of static collection
                    if ( !quoteRecord.SBQQ__LineItems__r.isEmpty() ) {
                        if ( quoteRecord.Quote_Sales_Type__c != Null && quoteRecord.Quote_Sales_Type__c.equalsIgnoreCase('Bespoke Collection') && bespokeProdRTId == quoteRecord.SBQQ__LineItems__r[0].SBQQ__Product__r.RecordTypeId && 'Manual Curation'.equalsIgnoreCase(quoteRecord.SBQQ__LineItems__r[0].SBQQ__Product__r.Product_Type_Author_Facing__c) && productIdToBundleItemListMap.containsKey(quoteRecord.SBQQ__LineItems__r[0].SBQQ__Product__c) && !productIdToBundleItemListMap.get(quoteRecord.SBQQ__LineItems__r[0].SBQQ__Product__c).isEmpty() ) { //for static bespoke case
                            for ( Bundle_Line_Item__c bundleItem : productIdToBundleItemListMap.get(quoteRecord.SBQQ__LineItems__r[0].SBQQ__Product__c) ) { //Iteration for static bespoke collection
                                OrderedItem bundleWrapperRecord = new OrderedItem();
                                bundleWrapperRecord.productId = bundleItem.Product_Isbn__c != Null ? bundleItem.Product_Isbn__c : ''; //bundleItem.ISBN__c //need to check with Chetan
                                bundleWrapperRecord.altProductId = bundleItem.uuid__c;
                                if ( bundleItem.CurrencyIsoCode.equalsIgnoreCase('USD') ) {
                                    bundleWrapperRecord.price = bundleItem.PriceUSD__c != Null ? bundleItem.PriceUSD__c : 0;
                                    if ( bundleItem.PriceUSD__c != Null ) {
                                        orderItemsNetTotalSum += bundleItem.PriceUSD__c;
                                    }
                                    orderItemsTaxAmtSum += 0; //need to check with Chetan
                                } else if ( bundleItem.CurrencyIsoCode.equalsIgnoreCase('GBP') ) {
                                    bundleWrapperRecord.price = bundleItem.PriceGBP__c != Null ? bundleItem.PriceGBP__c : 0;
                                    orderItemsNetTotalSum += bundleItem.PriceGBP__c;
                                    orderItemsTaxAmtSum += 0; //need to check with Chetan
                                }
                                
                                if ( bundleItem.CurrencyIsoCode.equalsIgnoreCase('USD') ) {
                                    bundleWrapperRecord.sellingPrice = bundleItem.PriceUSD__c != Null ? bundleItem.PriceUSD__c : 0;
                                } else if ( bundleItem.CurrencyIsoCode.equalsIgnoreCase('GBP') ) {
                                    bundleWrapperRecord.sellingPrice = bundleItem.PriceGBP__c != Null ? bundleItem.PriceGBP__c : 0;
                                }
                                bundleWrapperRecord.currency_z = bundleItem.CurrencyIsoCode;
                                bundleWrapperRecord.quantity = 1;
                                bundleWrapperRecord.orderedQuantity = 1;
                                if ( 'Manual Curation'.equalsIgnoreCase(quoteRecord.SBQQ__LineItems__r[0].SBQQ__Product__r.Product_Type_Author_Facing__c) && bespokeProdRTId == quoteRecord.SBQQ__LineItems__r[0].SBQQ__Product__r.RecordTypeId ) {
                                    bundleWrapperRecord.lineItemType = 'EBOOK-BESPOKEBUNDLE-STATIC';
                                }/* else if ( quoteRecord.SBQQ__LineItems__r != Null && 'Rule based'.equalsIgnoreCase(quoteRecord.SBQQ__LineItems__r[0].SBQQ__Product__r.Product_Type_Author_Facing__c) && bespokeProdRTId == quoteRecord.SBQQ__LineItems__r[0].SBQQ__Product__r.RecordTypeId ) {
                                    bundleWrapperRecord.lineItemType = 'EBOOK-BESPOKEBUNDLE-DYNAMIC';
                                }*/ else {
                                    bundleWrapperRecord.lineItemType = '';
                                }
                                bundleWrapperRecord.startDate = quoteRecord.TF_eBook_Subscription_Start_Date__c != Null ? String.valueOf(quoteRecord.TF_eBook_Subscription_Start_Date__c) : ''; //SFAL-160 Vikas Varshney
                                bundleWrapperRecord.endDate = ( quoteRecord.Business_Model__c != Null && quoteRecord.TF_eBook_Subscription_End_Date__c != Null && quoteRecord.Business_Model__c.containsIgnoreCase('Subscription') ) ? String.valueOf(quoteRecord.TF_eBook_Subscription_End_Date__c) : ''; //SFAL-160 Vikas Varshney
                                bundleWrapperRecord.salesType = 'PURCHASE';
                                bundleWrapperRecord.discount = 0; //need to check with Chetan
                                bundleWrapperRecord.taxAmount = 0; //depends on SFAL-51
                                bundleWrapperRecord.salesOrg = 'IN01';
                                bundleWrapperRecord.externalProductRefId = ''; //not required as per last discussion with Sharad on dated 19th July, 2022
                                BespokeOrderWrapRecord.orderedItem.add(bundleWrapperRecord);
                            }
                        } else if ( !orderRecord.OrderItems.isEmpty() ) { //Iteration for single-title, static-collection, dynamic-collection, dymanic-bespoke-collection
                            for ( OrderItem oli : orderRecord.OrderItems ) {
                                OrderedItem oliWrapperRecord = new OrderedItem();
                                oliWrapperRecord.productId = oli.ISBN__c;
                                oliWrapperRecord.altProductId = oli.PCM_UUID__c;
                                oliWrapperRecord.price = oli.SBQQ__QuotedListPrice__c != Null ? oli.SBQQ__QuotedListPrice__c : 0;
                                oliWrapperRecord.sellingPrice =  ( oli.SBQQ_NetTotal__c != NULL ? oli.SBQQ_NetTotal__c : 0 ); //In case of collection it should come from PCM
                                oliWrapperRecord.currency_z = oli.CurrencyIsoCode;
                                oliWrapperRecord.quantity = oli.SBQQ__OrderedQuantity__c != Null ? oli.SBQQ__OrderedQuantity__c : 1;
                                oliWrapperRecord.orderedQuantity = oli.SBQQ__OrderedQuantity__c != Null ? oli.SBQQ__OrderedQuantity__c : 1;
                                if ( quoteRecord.Quote_Sales_Type__c.equalsIgnoreCase('Single Title') ) {
                                    oliWrapperRecord.lineItemType = 'DIRECT-EBOOK';
                                } else if ( quoteRecord.Quote_Sales_Type__c.equalsIgnoreCase('Bespoke Collection') ) {
                                    oliWrapperRecord.lineItemType = 'EBOOK-BESPOKEBUNDLE-DYNAMIC';
                                } else if ( quoteRecord.Quote_Sales_Type__c.equalsIgnoreCase('Collection') && oli.Product2Id != Null && 'Manual Curation'.equalsIgnoreCase(oli.Product2.Product_Type_Author_Facing__c) ) {
                                    oliWrapperRecord.lineItemType = 'EBOOK-COLLECTION-STATIC'; //need to check with Chetan how to know static or dynamic collection
                                } else if ( quoteRecord.Quote_Sales_Type__c.equalsIgnoreCase('Collection') && oli.Product2Id != Null && 'Rule based'.equalsIgnoreCase(oli.Product2.Product_Type_Author_Facing__c) ) {
                                    oliWrapperRecord.lineItemType = 'EBOOK-COLLECTION-DYNAMIC'; //need to check with Chetan how to know static or dynamic collection
                                } else {
                                    oliWrapperRecord.lineItemType = '';
                                }
                                oliWrapperRecord.startDate = quoteRecord.TF_eBook_Subscription_Start_Date__c != Null ? String.valueOf(quoteRecord.TF_eBook_Subscription_Start_Date__c) : ''; //SFAL-160 Vikas Varshney
                                oliWrapperRecord.endDate = ( quoteRecord.Business_Model__c != Null && quoteRecord.TF_eBook_Subscription_End_Date__c != Null && quoteRecord.Business_Model__c.containsIgnoreCase('Subscription') ) ? String.valueOf(quoteRecord.TF_eBook_Subscription_End_Date__c) : ''; //SFAL-160 Vikas Varshney
                                oliWrapperRecord.salesType = 'PURCHASE'; //mapping need to check with Chetan
                                oliWrapperRecord.discount = oli.Total_Discount_Percentage__c != Null ? oli.Total_Discount_Percentage__c : ( oli.Total_Discount_Amount__c != Null ? oli.Total_Discount_Amount__c : 0); //mapping need to check with Chetan
                                oliWrapperRecord.taxAmount = oli.SBQQ__TaxAmount__c != Null ? oli.SBQQ__TaxAmount__c : 0; //need to check with Chetan in case of bundle = true
                                oliWrapperRecord.salesOrg = 'IN01';
                                oliWrapperRecord.externalProductRefId = ''; //no mapping present, mapping need to check with Chetan
                                //populating order item fulfillmentRequest
                                oliWrapperRecord.fulfillmentRequest = new FulfillmentRequest();
                                oliWrapperRecord.fulfillmentRequest.policies = new Policies();
                                oliWrapperRecord.fulfillmentRequest.policies.drm = false;
                                oliWrapperRecord.fulfillmentRequest.policies.concurrency = '1';
                                oliWrapperRecord.fulfillmentRequest.policies.grantType = new List<String>{'ViewOnline','Download'};
                                oliWrapperRecord.fulfillmentRequest.policies.copyCount = '0';
                                oliWrapperRecord.fulfillmentRequest.policies.printCount = '0';
                                oliWrapperRecord.fulfillmentRequest.productId = String.isNotBlank(oli.PCM_UUID__c) ? oli.PCM_UUID__c : '';
                                if ( quoteRecord.Quote_Sales_Type__c.equalsIgnoreCase('Single Title') ) {
                                    oliWrapperRecord.fulfillmentRequest.productType = 'SINGLE TITLE'; //SFAL-530
                                } else if ( quoteRecord.Quote_Sales_Type__c.equalsIgnoreCase('Bespoke Collection') ) {
                                    oliWrapperRecord.fulfillmentRequest.productType = 'BESPOKE COLLECTION'; //SFAL-530
                                } else if ( quoteRecord.Quote_Sales_Type__c.equalsIgnoreCase('Collection') ) {
                                    oliWrapperRecord.fulfillmentRequest.productType = 'COLLECTION'; //SFAL-530
                                } else {
                                    oliWrapperRecord.fulfillmentRequest.productType = '';
                                }
                                oliWrapperRecord.fulfillmentRequest.requestType = 'EBOOK_CONTENT_ACCESS';
                                oliWrapperRecord.fulfillmentRequest.startDate = quoteRecord.TF_eBook_Subscription_Start_Date__c != Null ? String.valueOf(quoteRecord.TF_eBook_Subscription_Start_Date__c) : ''; //SFAL-160 Vikas Varshney
                                oliWrapperRecord.fulfillmentRequest.endDate = ( quoteRecord.Business_Model__c != Null && quoteRecord.TF_eBook_Subscription_End_Date__c != Null && quoteRecord.Business_Model__c.containsIgnoreCase('Subscription') ) ? String.valueOf(quoteRecord.TF_eBook_Subscription_End_Date__c) : ''; //SFAL-160 Vikas Varshney
                                oliWrapperRecord.fulfillmentRequest.licenseType = 'Perpetual';
                                //oliWrapperRecord.fulfillmentRequest.licenseUpdateType = 'Static'; //Dynamic //Static //need to check mapping with the new field to be introduced
                                oliWrapperRecord.fulfillmentRequest.licenseUpdateType = quoteRecord.SBQQ__Opportunity2__r.TF_eBook_License_Type__c != Null ? quoteRecord.SBQQ__Opportunity2__r.TF_eBook_License_Type__c : 'Static'; //SFAL-530 Vikas Varshney/26-Aug-2022
                                oliWrapperRecord.fulfillmentRequest.licenseUpdateEndDate = ''; //no mapping present
                                oliWrapperRecord.fulfillmentRequest.accessScope = 'Global';
                                
                                if ( oli.SBQQ_NetTotal__c != Null ) {
                                    orderItemsNetTotalSum += oli.SBQQ_NetTotal__c;
                                }
                                
                                if ( oli.SBQQ__TaxAmount__c != Null ) {
                                    orderItemsTaxAmtSum += oli.SBQQ__TaxAmount__c;
                                }
                                
                                BespokeOrderWrapRecord.orderedItem.add(oliWrapperRecord);
                            }
                        }
                    }
                    
                    BespokeOrderWrapRecord.orderPrice = orderItemsNetTotalSum;
                    BespokeOrderWrapRecord.totalTax = orderItemsTaxAmtSum;
                    
                    //populating billing address
                    if ( !billToSapBPList.isEmpty() ) {
                        BespokeOrderWrapRecord.billingAddress = billingSapBPAddressLMS(quoteRecord, billToSapBPList);
                    }
                    
                    //populating shipping address
                    if ( !shipToSapBPList.isEmpty() ) {
                        BespokeOrderWrapRecord.shippingAddress = sapBPShippingAddressLMS(shipToSapBPList);
                    }
                    
                    String jsonStr = JSON.serializePretty(BespokeOrderWrapRecord);
                    jsonStr = jsonStr.replace('currency_z', 'currency');
                    quoteIdToJsonMap.put( quoteRecord.id, jsonStr );
                    /*if ( quoteRecord.SBQQ__LineItems__r.isEmpty() ) { //need to check with Chetan this condition
                        jsonStr = '';
                        quoteIdToJsonMap.put( quoteRecord.id, jsonStr );
                    }*/
                    billToSapBPList.clear();
                    shipToSapBPList.clear();
                    System.debug('jsonStr =====>' + jsonStr);
                }
            }
        } catch ( Exception ex ) {
            System.debug('*********** TF_BespokeOrderJson Exception ***********' + ex.getMessage() + '********* Line Number *********' + ex.getLineNumber());
        }
        
        return quoteIdToJsonMap;
    }
    
    //SFAL-438 Vikas Varshney dated 21-July-2022
    //Reusing Existing code for billing and shipping addresses due to dependency
    public static BillingAddress billingSapBPAddressLMS ( SBQQ__Quote__c quot, List<SAP_BP__c> listSap ) {
        BillingAddress BillingAddressesObj = new BillingAddress();
        Trig_Order_PostOH.sapCreationTimeAddressDetailsWrap sapCreationTimeAddressDetailsWrapObj = new Trig_Order_PostOH.sapCreationTimeAddressDetailsWrap();
        //Call address formatting method and we are doing these steps because of char limit on invoice
        sapCreationTimeAddressDetailsWrapObj = Trig_Order_PostOH.mapAddressvalues(listSap.get(0));
        if(sapCreationTimeAddressDetailsWrapObj != null)
        {
            BillingAddressesObj.addressLine1 = sapCreationTimeAddressDetailsWrapObj.addressLine1;
            BillingAddressesObj.addressLine2 = sapCreationTimeAddressDetailsWrapObj.addressLine2;
            BillingAddressesObj.addressLine3 = sapCreationTimeAddressDetailsWrapObj.addressLine3;
            BillingAddressesObj.addressOrganisation =  sapCreationTimeAddressDetailsWrapObj.addressOrganisation;
        }
        BillingAddressesObj.taxRegistrationNumber =  listSap.get(0).Tax_Registration_Number__c;
        BillingAddressesObj.taxCategory = listSap.get(0).Tax_Number_Category__c;
        BillingAddressesObj.careOf =  listSap.get(0).Care_of__c;
        BillingAddressesObj.addressContactFirstName =  listSap.get(0).First_Name__c;
        BillingAddressesObj.addressContactLastName =  listSap.get(0).Last_Name__c; 
        BillingAddressesObj.addressCountry =  listSap.get(0).Country__c;
        BillingAddressesObj.addressLocality =  listSap.get(0).City__c;
        BillingAddressesObj.addressRegion =  listSap.get(0).State__c;
        BillingAddressesObj.addressContactName =  listSap.get(0).First_Name__c + ' '+ listSap.get(0).Last_Name__c ;
        BillingAddressesObj.addressContactEmail =  listSap.get(0).Email__c;
        BillingAddressesObj.postalCode =  listSap.get(0).ZIP__c;
        BillingAddressesObj.businessPartnerNo = listSap.get(0).name;
        //List<Country__c> listCountry = new List<Country__c>([SELECT Country_2__c, Name FROM Country__c where Name like :listSap.get(0).Country__c limit 1]);
        //if(!listCountry.isEmpty()) BillingAddressesObj.countryCode = listCountry.get(0).Country_2__c; 
        BillingAddressesObj.countryCode = countryNameToCodeMap.containsKey(listSap.get(0).Country__c) ? countryNameToCodeMap.get(listSap.get(0).Country__c) : '';
        //if(quot.RecordTypeID == quoteOARecordTypeId){ // need to check with Chetan for attribute --> externalCustomerAddressId and RT --> quoteOARecordTypeId
        BillingAddressesObj.externalCustomerAddressId = quot.Id;
        //if(BillingAddressesObj.countryCode == null){
            //BillingAddressesObj.countryCode = 'AZ';
        //}
        //}
        
        return BillingAddressesObj;
    }
    
    //Reusing Existing code for billing and shipping addresses due to dependency
    public static ShippingAddress sapBPShippingAddressLMS ( List<SAP_BP__c> listSapShip ) {
        ShippingAddress ShippingAddressObj = new ShippingAddress();
        Trig_Order_PostOH.sapCreationTimeAddressDetailsWrap sapCreationTimeAddressDetailsWrapShipObj = new Trig_Order_PostOH.sapCreationTimeAddressDetailsWrap();
        //Call address formatting method and we are doing these steps because of char limit on invoice
        sapCreationTimeAddressDetailsWrapShipObj = Trig_Order_PostOH.mapAddressvalues(listSapShip.get(0));
        if(sapCreationTimeAddressDetailsWrapShipObj != null)
        {
                
            ShippingAddressObj.addressLine1 = sapCreationTimeAddressDetailsWrapShipObj.addressLine1;
            ShippingAddressObj.addressLine2 = sapCreationTimeAddressDetailsWrapShipObj.addressLine2;
            ShippingAddressObj.addressLine3 = sapCreationTimeAddressDetailsWrapShipObj.addressLine3;
            ShippingAddressObj.addressOrganisation =  sapCreationTimeAddressDetailsWrapShipObj.addressOrganisation;
        }
        ShippingAddressObj.taxRegistrationNumber =  listSapShip.get(0).Tax_Registration_Number__c;
        ShippingAddressObj.taxCategory =  listSapShip.get(0).Tax_Number_Category__c;
        ShippingAddressObj.careOf =  listSapShip.get(0).Care_of__c;
        ShippingAddressObj.addressContactFirstName =  listSapShip.get(0).First_Name__c;
        ShippingAddressObj.addressContactLastName =  listSapShip.get(0).Last_Name__c;
        ShippingAddressObj.addressCountry =  listSapShip.get(0).Country__c;
        ShippingAddressObj.addressLocality =  listSapShip.get(0).City__c;
        ShippingAddressObj.addressRegion =  listSapShip.get(0).State__c;
        ShippingAddressObj.addressContactName =  listSapShip.get(0).First_Name__c + ' '+ listSapShip.get(0).Last_Name__c ;
        ShippingAddressObj.addressContactEmail =  listSapShip.get(0).Email__c;
        ShippingAddressObj.postalCode =  listSapShip.get(0).ZIP__c;
        ShippingAddressObj.businessPartnerNo = listSapShip.get(0).name;
        ShippingAddressObj.countryCode = countryNameToCodeMap.containsKey(listSapShip.get(0).Country__c) ? countryNameToCodeMap.get(listSapShip.get(0).Country__c) : '';
        
        return ShippingAddressObj;
    }
    
    /*********** private Wrappers ***********/
    public class BespokeOrderWrapper {
        public String orderType;
        public String channel;
        public String externalSystemRefId; //SFAL-597 Vikas Varshney
        public String externalOrderRef;
        public String notes;
        public String customerId;
        public String buyerId;
        public String orderDate;
        public Decimal orderPrice;
        public String orderStatus;
        public String seller;
        public BillingAddress billingAddress;
        public ShippingAddress shippingAddress;
        public FulfillmentRequest fulfillmentRequest;
        public List<OrderedItem> orderedItem;
        public Decimal subTotalPrice;
        public Decimal totalTax;
        //public List<String> fulfillments; //SFAL-597 Vikas Varshney
    }
    
    public class BillingAddress {
        public String houseNumber;
        public String addressOrganisation;
        public String postalCode;
        public String addressContactEmail;
        public String streetAddress;
        public String addressContactName;
        public String businessPartnerNo;
        public String addressRegion;
        public String countryCode;
        public String addressLocality;
        public String telephoneNo;
        public String addressCountry;
        public String externalCustomerAddressId;
        public String addressLine3;
        public String taxRegistrationNumber;
        public String addressLine2;
        public String taxCategory;
        public String addressLine1;
        public String careOf;
        public String addressContactFirstName;
        public String addressContactLastName;
    }
    
    public class ShippingAddress {
        public String houseNumber;
        public String addressOrganisation;
        public String postalCode;
        public String addressContactEmail;
        public String streetAddress;
        public String addressContactName;
        public String businessPartnerNo;
        public String addressRegion;
        public String countryCode;
        public String addressLocality;
        public String telephoneNo;
        public String addressCountry;
        public String externalCustomerAddressId;
        public String addressLine3;
        public String taxRegistrationNumber;
        public String addressLine2;
        public String taxCategory;
        public String addressLine1;
        public String careOf;
        public String addressContactFirstName;
        public String addressContactLastName;
    }
    
    public class FulfillmentRequest {
        public String productId;
        public String requestType;
        public String productType;
        public String startDate;
        public String endDate;
        public String licenseType;
        public String licenseUpdateType;
        public String licenseUpdateEndDate;
        public String accessScope;
        public Policies policies;
    }
    
    public class Policies {
        public Boolean drm;
        public String concurrency;
        public List<String> grantType;
        public String copyCount;
        public String printCount;
    }
    
    public class OrderedItem {
        public String productId;
        public String altProductId;
        public Decimal price;
        public Decimal sellingPrice;
        public String currency_z; //in json: currency
        public Decimal quantity;
        public Decimal orderedQuantity;
        public String lineItemType;
        public String startDate;
        public String endDate;
        public String salesType;
        public Decimal discount;
        public Decimal taxAmount;
        public String salesOrg;
        public String externalProductRefId;
        public FulfillmentRequest fulfillmentRequest;
    }
}