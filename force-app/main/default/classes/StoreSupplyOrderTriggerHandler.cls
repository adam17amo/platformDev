/**
 * @description - Class to handle logic for trigger on Store Supply Order object
 */
public with sharing class StoreSupplyOrderTriggerHandler {
    @TestVisible
    private static Map<String, Object> flowVariableMap = new Map<String, Object>();

    /**
     * @description - Finds suppliers on new orders and sends them an email
     * @param newOrders List of newly created store supply order records
     */
    public static void handleAfterInsert(List<Store_Supply_Order__c> newOrders) {
        Set<Id> supplierIds = new Set<Id>();
        for(Store_Supply_Order__c order : newOrders){
            supplierIds.add(order.Supplier__c);
        }
        // Get the suppliers of these orders
        List<Account> suppliers = [SELECT Name, Primary_Contact_Email__c 
                                FROM Account 
                                WHERE Id IN :supplierIds];
        sendEmails(suppliers);
    }

    /**
     * @description - Calls a flow to email the suppliers
     * @param suppliers List of supplier accounts to email
     */
    private static void sendEmails(List<Account> suppliers) {
        // Populate a map referencing an input variable in the flow
        flowVariableMap.put('SupplierList', suppliers);
        // Call the flow
        Flow.Interview.New_Order_Email_to_Supplier sendEmailFlow = 
                                                        new Flow.Interview.New_Order_Email_to_Supplier(flowVariableMap);
        sendEmailFlow.start();
    }
}
