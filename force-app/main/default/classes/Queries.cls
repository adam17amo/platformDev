/**
 * @description - Class used for SOQL and SOSL examples
 */
public with sharing class Queries {
    /**
     * @description - Method with basic SOQL query examples
     */
    public static void basicSOQL() {
        // Basic query for Accounts
        List<Account> accounts = [SELECT Name 
                                FROM Account];
        for(Account acct : accounts) {
            System.debug('Acct is ' + acct);
        }

        // Only query the first 5 Accounts alphabetically
        List<Account> firstFive = [SELECT Name 
                                FROM Account 
                                ORDER BY Name ASC 
                                LIMIT 5];
        for(Account acct : firstFive) {
            System.debug('Acct in firstFive is ' + acct);
        }

        // Query all stores with a health score above 97 and order them by score, then name
        List<Store__c> stores = [SELECT Name, Latest_Health_Score__c
                                FROM Store__c
                                WHERE Latest_Health_Score__c > 97
                                ORDER BY Latest_Health_Score__c DESC, Name ASC];
        for(Store__c store : stores) {
            System.debug('Store is ' + store);
        }
    }

    /**
     * @description - Method with parent child relationship queries
     * Queries both up and down in the object hierarchy
     */
    public static void relationshipSOQL() {
        // Query parent Store record info from the child Store Supply Orders
        List<Store_Supply_Order__c> ordersWithStores = [SELECT Name, Order_Amount__c, Store__r.Name 
                                                    FROM Store_Supply_Order__c];
        for(Store_Supply_Order__c order : ordersWithStores) {
            System.debug('Order in ordersWithStores is ' + order);
        }

        // Query child Store Supply Orders from the parent Stores, note the relationship name
        List<Store__c> storesWithOrders = [SELECT Name, 
                                            (SELECT Name, Order_Amount__c 
                                            FROM Store_Supply_Orders__r) 
                                        FROM Store__c];
        for(Store__c store : storesWithOrders) {
            System.debug('Store is ' + store);
            for(Store_Supply_Order__c order : store.Store_Supply_Orders__r) {
                System.debug('Order is ' + order);
            }
        }
    }

    /**
     * @description - Dynamic SOQL examples that takes parameters to construct a SOQL query
     * @param objectName Name of the object to query
     * @param threshold Threshold to apply to the where clause
     * @param recordLimit Limit of how many records to query
     */
    public static void dynamicSOQL(String objectName, Decimal threshold, Integer recordLimit){
        // Populate the fields and object name
        String soqlQuery = 'SELECT Name FROM ' + objectName;
        // Create an empty where clause
        String whereClause = '';
        // Use a different condition per object
        if(objectName == 'Store__c') {
            whereClause += ' WHERE Latest_Health_Score__c > ' + threshold;
        } else if(objectName == 'Store_Supply_Order__c') {
            whereClause += ' WHERE Order_Amount__c > ' + threshold;
        }
        // Add the where clause to the query
        soqlQuery += whereClause;
        // Add a limit if there is one
        if(recordLimit != null) {
            soqlQuery += ' LIMIT ' + recordLimit;
        }
        // Print out the query as a sanity check
        System.debug('SOQL query is ' + soqlQuery);
        // Run the query
        List<sObject> records = Database.query(soqlQuery);
        for(sObject record : records) {
            System.debug('Record is ' + record);
        }
    }

    /**
     * @description - Method with basic SOSL query example
     */
    public static void SOSL() {
        List<List<sObject>> hubRecords = [FIND 'Hub' 
                                        IN ALL FIELDS 
                                        RETURNING Store__c(Name), Store_Supply_Order__c(Name)];
        for(List<sObject> records : hubRecords) {
            System.debug('Total records in object ' + records.size());
            for(sObject record : records) {
                System.debug('Record is ' + record);
            }
        }
    }
}
