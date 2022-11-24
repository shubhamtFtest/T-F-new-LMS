/*************************
Author : Vikas Varshney
Description : Main Asset Interface
**************************/

public with sharing class TriggerInterface_Asset
{
    public interface Runnable 
    {
        void run(TriggerInterface_Asset.Trig trig);
    }   
    public class Trig 
    {
        public List<Asset> oldList;
        public List<Asset> newList;
        public Map<Id,Asset> oldMap;
        public Map<Id,Asset> newMap;
        public Integer triggerSize;
        public Boolean isBefore;
        public Boolean isAfter;
        public Boolean isInsert;
        public Boolean isUpdate;
        public Boolean isDelete;
        public Boolean isUnDelete;
        public Map<Id,Map<String,String>> mapRtIdsToParams;
    }
}