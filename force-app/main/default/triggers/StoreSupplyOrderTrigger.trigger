trigger StoreSupplyOrderTrigger on Store_Supply_Order__c (before insert, before update, after insert, after update) {
    if(Trigger.isInsert && Trigger.isAfter) {
        StoreSupplyOrderTriggerHandler.handleAfterInsert(Trigger.new);
    }
}