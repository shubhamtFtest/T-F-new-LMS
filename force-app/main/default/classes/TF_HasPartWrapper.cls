/***********************************************************************************
    // This wrapper class is being used in "TF_HasPartUpdate_Cls""
    // Created by Vikas Varshney on dated 26 May, 2020 for UBX-920
    // Modified by Vikas Varshney on dated 25 Aug, 2020 for UBX-12715
    // Modified by Vikas Varshney on dated 25 Sep, 2020 for UBX-13873
***********************************************************************************/

public class TF_HasPartWrapper {
    public Header header;
    public Body body;
    
    public class Header {
        public String id;
        public String timestamp;
        public String version;
        public String source;
        public String application;
        public String event;
        public String event_payload_type;
        public String event_type;
        public String status;
        public String status_description;
        public String locations;
    }
    
    public class Parts {
        public String x_id;
        public String type;
        public String version;
        public Integer position;
    }
    
    public class Product {
        public String x_id;
        public String type;
        public String version;
        public String title;
        public String packageId;
    }
    
    public class Body {
        public Product product;
        public List<Parts> parts;
        public List<String> partsAdded;
        public List<String> partsDeleted;
        public List<licenseDetails> licenses;
    }
    
    public class licenseDetails {
        public String licenseId;
        public String partyId;
        public String access_scope;
        public String status;
        public String licenseName; //UBX-12715
        public String licenseType; //UBX-12715
        public List<ChildPartyIds> childParties; //UBX-12715
        public List<String> grantType; //UBX-13873
    }
    
    public class ChildPartyIds {
        public String partyID;
    }
}