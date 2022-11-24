public class TFUnsiloClasses {
    public List<Classes> classes {get;set;}
    
    public class Exports {
        public String id {get;set;}
        public String exportTimestamp {get;set;}
    }
    
    public class Classes {
        public String id {get;set;}
        public String title {get;set;}
        public List<Exports> exports {get;set;}
    }
}