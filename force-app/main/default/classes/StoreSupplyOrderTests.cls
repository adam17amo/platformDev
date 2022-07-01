@isTest
public with sharing class StoreSupplyOrderTests {
    @testSetup
    static void createData(){
        Account supplier = new Account();
        supplier.Name = 'Awesome Supplier';
        supplier.Primary_Contact_Email__c = 'adam@adamtoarchitect.com';
        supplier.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
                                                        .get('Supplier').getRecordTypeId();
        insert supplier;

        Store__c store = new Store__c();
        store.Name = 'Awesome Store';
        insert store;
    }

    @isTest
    static void testStoreSupplyOrderEmailFromFlow() {
        List<Store__c> stores = [SELECT ID FROM Store__c LIMIT 1];
        List<Account> suppliers = [SELECT ID FROM Account LIMIT 1];
        Store_Supply_Order__c order = new Store_Supply_Order__c();
        order.Store__c = stores[0].Id;
        order.Supplier__c = suppliers[0].Id;
        order.Order_Amount__c = 10000;
        insert order;

        System.assert(StoreSupplyOrderTriggerHandler.flowVariableMap.keySet().contains('SupplierList'),
                    'The flow variable map should contain the supplier list variable');
        List<Account> suppliersInFlow = (List<Account>)StoreSupplyOrderTriggerHandler.flowVariableMap.get('SupplierList');
        System.assertEquals(suppliers[0].Id, suppliersInFlow[0].Id,
                    'The supplier sent to the flow should match the supplier on the order');
    }
}
