public class TF_UBXIpAuthPartyIdWrapper {
    public Metadata metadata;
	public List<Data> data;

	public class Message {
	    public String key;
	    public String value;
	}

	public class Metadata {
		public String status;
		public Message message;
	}

	public class Data {
		public String ip_access_control_id;
		public String ip_start;
		public String ip_end;
		public String access_type;
		public String party_id;
		public DateTime db_add_date;
		public DateTime db_update_date;
		public String created_by;
		public String updated_by;
		public DateTime deleted_on;
		public String description;
		public Integer ip_type_id;
		public String source;
        public String threat_type;
	}
}