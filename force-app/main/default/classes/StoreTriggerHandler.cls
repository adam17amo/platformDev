/**
 * @description - Class to handle logic for trigger on Store object
 */
public with sharing class StoreTriggerHandler {

    @TestVisible
    private static Boolean platformEventsFailed = false;

    /**
     * @description - Perform checks on the newly inserted and updated store records including cSAT scores
     * @param newStores List of newly created or updated store records
     * @param oldStoreMap Map of IDs to old values of updated store records
     */
    public static void handleAfterInsertUpdate(List<Store__c> newStores, Map<Id, Store__c> oldStoreMap) {
        List<Case> casesToInsert = new List<Case>();
        List<Customer_Satisfaction_Update__e> cSatUpdateEvents = new List<Customer_Satisfaction_Update__e>();

        // Cycle through all newly inserted or updated stores
        for(Store__c store : newStores) {
            /* Get the previous values of the store,
               will be null for newly created stores using safe navigation operator */
            Store__c oldStore = oldStoreMap?.get(store.Id);
            if(isStoreWithBadSatisfaction(store, oldStore)) {
                // If the store's cSAT has fallen below 75%, create a case
                Case newCase = new Case();
                newCase.Subject = 'Poor Customer Satisfaction';
                newCase.Status = 'New';
                newCase.Priority = 'High';
                newCase.Description =
                    'This store\'s customer satisfaction has dropped to ' + store.Customer_Satisfaction_Score__c;
                newCase.Store__c = store.Id;
                newCase.OwnerId = store.OwnerId;
                casesToInsert.add(newCase);
                cSatUpdateEvents.add(new Customer_Satisfaction_Update__e(Store_Id__c = store.Id));
            }
        }
        // Insert all new cases
        insert casesToInsert;
        // Call method to publish cSAT platform events
        List<Database.SaveResult> results = EventBus.publish(cSatUpdateEvents);
        for(Database.SaveResult result : results) {
            if(!result.isSuccess()) {
                platformEventsFailed = true;
            }
        }
    }
    
    /**
     * @description - Returns true if store was newly created with a cSAT below 75 or was updated and
     * previously had a cSAT of higher than 75% but is now lower than 75%
     * @param newStore Newly created or existing updated store record
     * @param oldStore Previous values of the store record for existing stores or null for newly created stores
     * @return Boolean specifying if store's cSAT started below 75 or has fallen below 75
     */
    private static Boolean isStoreWithBadSatisfaction(Store__c newStore, Store__c oldStore) {
        if(oldStore != null) {
            return (newStore.Customer_Satisfaction_Score__c < 75 &&
            oldStore.Customer_Satisfaction_Score__c > 75);
        }
        return (newStore.Customer_Satisfaction_Score__c < 75);
    }
}
