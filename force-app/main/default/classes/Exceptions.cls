public with sharing class Exceptions {
    public class MyStoreException extends Exception{}

    /**
     * @description - Method to create a store
     * @param storeName Name of the store to create
     * @param throwException Boolean specifying whether or not to throw an exception
     */
    public static void createStore(String storeName, Boolean throwException) {
        Store__c store = new Store__c(Name=storeName);
        try {
            if(throwException) {
                throw new MyStoreException('Friendly store failure error message');
            }
            insert store;
        } catch(DMLException de) {
            System.debug('I caught a DML exception with message ' + de.getMessage()
                        + ' caused by ' + de.getStackTraceString());
        } catch(Exception e) {
            System.debug('I caught another exception ' + e.getTypeName() + 
                        ' with message ' + e.getMessage());
        }
    }
}
