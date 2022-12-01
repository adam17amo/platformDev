/**
 * @author - Adam Olshansky
 * @description - Custom Controller to be used for a Store Supply Order records
 */
public with sharing class StoreSupplyOrderController {
    /**
     * @description - Query for Store Supply Orders from a Store
     * @param storeId - Id of the Store to get Store Supply Order records for
     * @return - List of Store Supply Order records under the requested Store
     */
    @AuraEnabled(cacheable=true)
    public static List<Store_Supply_Order__c> getStoreSupplyOrders(Id storeId) {
        return [SELECT Id, Name, Order_Amount__c, Order_Status__c, Product_Ordered__c, Quantity__c
                FROM Store_Supply_Order__c
                WHERE Store__c = :storeId];
    }
}