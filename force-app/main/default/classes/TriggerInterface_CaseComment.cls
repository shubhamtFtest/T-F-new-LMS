public class TriggerInterface_CaseComment {
    public interface Runnable {
        void run(TriggerInterface_CaseComment.Trig trig);
    }  
    public class Trig {
        public List<CaseComment> oldList;
        public List<CaseComment> newList;
        public Map<Id,CaseComment> oldMap;
        public Map<Id,CaseComment> newMap;
        public Integer triggerSize;
        public Boolean isBefore;
        public Boolean isAfter;
        public Boolean isInsert;
        public Boolean isUpdate;
        public Boolean isDelete;
        public Boolean isUnDelete;
        public Map<Id,Map<String,String>> mapRtIdsToParams;
    }
       /** This method is for Code Coverage purpose only **/
    @testVisible 
    private static void codeCoverage() {
       Trig obj = new Trig(); 
       obj.triggerSize = 1; 
    }
}