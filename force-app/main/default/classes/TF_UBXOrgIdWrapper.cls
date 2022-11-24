public class TF_UBXOrgIdWrapper {
    public Metadata metadata;
	public Data data;
	
	public class Message {
	    public String key;
	    public String value;
	}
	
	public class Metadata {
		public String status;
		public Message message;
	}
	
	public class Data {
		public String x_id; // in json: _id
		public String org_id;
		public String name;
		public Boolean isActive;
		public String entityId;
		public String metadata;
		public String attribute_standard;
		public Integer x_v; // in json: __v
		public List<String> federation;
	}
}