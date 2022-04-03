trigger StoreTrigger on Store__c (before insert, after insert, before update, after update) {
    if(Trigger.isAfter) {
        StoreTriggerHandler.handleAfterInsertUpdate(Trigger.new, Trigger.oldMap);
    }
}