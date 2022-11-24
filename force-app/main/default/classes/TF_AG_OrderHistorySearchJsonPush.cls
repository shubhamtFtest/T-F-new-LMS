public class TF_AG_OrderHistorySearchJsonPush {
    @AuraEnabled
    public List<OrderData_Class> data;
    @AuraEnabled
    public String page;
    @AuraEnabled
    public String totalPages;
    @AuraEnabled
    public String pageSize;
    public class OrderData_Class{
        @AuraEnabled
        public String accountId;
        @AuraEnabled
        public String orderId;
        @AuraEnabled
        public String poNumber;
        @AuraEnabled
        public String orderDate;
        @AuraEnabled
        public String orderValue;
        @AuraEnabled
        public String isbn;
        @AuraEnabled
        public String quantity;
        @AuraEnabled
        public String orderStatus;
        @AuraEnabled
        public String titleStatus;
        @AuraEnabled
        public String replenType;
        @AuraEnabled
        public String trackingNumber;
        @AuraEnabled
        public String type;
        
    }
    public TF_AG_OrderHistorySearchJsonPush(){
        
    }
    /*@AuraEnabled
    public String ORDERID{get;set;}
    @AuraEnabled
    public String ORDERDATE{get;set;}
    @AuraEnabled
    public String FEDID{get;set;}
    @AuraEnabled
    public String GSTID{get;set;}
    @AuraEnabled
    public String REMITPAYMENTINUSTO{get;set;}
    @AuraEnabled
    public String InvoiceNo{get;set;}
    @AuraEnabled
    public String DateData{get;set;}
    @AuraEnabled
    public String RefNo{get;set;}
    @AuraEnabled
    public String BillTo{get;set;}
    @AuraEnabled
    public String Code{get;set;}
    @AuraEnabled
    public String ShipTo{get;set;}
    @AuraEnabled
    public String PO{get;set;}
    @AuraEnabled
    public String ShipVia{get;set;}
    @AuraEnabled
    public String TotalAmountDue{get;set;}
    @AuraEnabled
    public String TrackingNumber{get;set;}
    @AuraEnabled
    public list<LineItems> LineItems{get;set;}
        public class LineItems{
            @AuraEnabled
            public String Ord{get;set;}
            @AuraEnabled
            public String Avail{get;set;}
            @AuraEnabled
            public String Catalogue{get;set;}
            @AuraEnabled
            public String ISBN13{get;set;}
            @AuraEnabled
            public String Title{get;set;}
            @AuraEnabled
            public String Description{get;set;}
            @AuraEnabled
            public String Listget{get;set;}
            @AuraEnabled
            public String Disc{get;set;}
            @AuraEnabled
            public String Net{get;set;}
            @AuraEnabled
            public String NetAmount{get;set;}
            @AuraEnabled
            public String Tax{get;set;}
            @AuraEnabled
            public String SAndH{get;set;}
            @AuraEnabled
            public String SundryCharges{get;set;}
            @AuraEnabled
            public String LessAmtPaid{get;set;}
            @AuraEnabled
            public String AmountDue{get;set;}
        }
    @AuraEnabled
    public String SendCheckPaymentsto{get;set;}
    @AuraEnabled
    public String SendWirePaymentsto{get;set;}
    @AuraEnabled
    public String ACHTransfer{get;set;}
    @AuraEnabled
    public String WireTransfer{get;set;}
    @AuraEnabled
    public String AccountNumber{get;set;}
    @AuraEnabled
    public String SwiftID{get;set;}*/
    
}