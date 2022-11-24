public class TF_BatchCaseUpdate implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQUeryLocator([SELECT Id FROM Case where id in (Select ParentId from EmailMessage where ParentId != null) AND InboundOutBound_Updated__c!=True LIMIT 50000]);
    }
    public void execute(Database.BatchableContext context, Case[] scope) {
        
        Map<Boolean, Map<Id, Integer>> results = new Map<Boolean, Map<Id, Integer>> {
            true => new Map<Id, Integer>(), false => new Map<Id, Integer>()
        };
        for(Case record: scope) {
            results.get(true).put(record.Id, 0);
            results.get(false).put(record.Id, 0);
        }
        for(AggregateResult result: [SELECT COUNT(Id) sum, Incoming incoming, ParentId id FROM EmailMessage 
                                     WHERE ParentId IN :scope GROUP BY Incoming, ParentId]) {
            results.get((Boolean)result.get('incoming')).put((Id)result.get('id'), ((Decimal)result.get('sum')).intValue());
        }
        for(Case record: scope) {
            record.Inbound__c = results.get(true).get(record.Id);
            record.Outbound__c = results.get(false).get(record.Id);
            record.InboundOutBound_Updated__c = True;
        }
        update scope;
    }
    public void finish(Database.BatchableContext context) {

    }
}