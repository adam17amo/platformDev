/**
 * @description - Controller Extension to be used for Visualforce pages on Store records
 */
public with sharing class StoreControllerExt {
    private final Store__c store;
    
    /**
     * @description - Constructor for Visualforce controller extension.
     * Specifies the store record being used by the page
     * @param stdController The Visualforce standard controller
     */
    public StoreControllerExt(ApexPages.StandardController stdController) {
        this.store = (Store__c)stdController.getRecord();
    }

    /**
     * @description - Getter method for open cases variable from Visualforce page. Calls the getOpenCasesWithId method
     * @return List of open cases
    */
    public List<Case> getOpenCases() {
        return getOpenCasesWithId(store.Id);
    }

    /**
     * @description - Returns all open cases related to the given store Id. To be used for Lightning Web Component
     * @param storeId Id of a parent store record
     * @return List of open cases under a parent store record
     */
    @AuraEnabled(cacheable=true)
    public static List<Case> getOpenCasesWithId(Id storeId) {
        return [SELECT Subject, Status, Priority, CreatedDate 
                FROM Case 
                WHERE IsClosed = false AND Store__c = :storeId];
    }
}
