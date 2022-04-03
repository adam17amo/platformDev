@isTest
public with sharing class StoreTests {
    @testSetup
    static void createRecords(){
       Store__c store = new Store__c();
       store.Name = 'San Francisco Hub';
       store.Latest_Health_Score__c = 100;
       store.Customer_Satisfaction_Score__c = 90.00;
       store.Date_of_Establishment__c = Date.today().addYears(-1);
       store.Street__c = '123 Sesame St.';
       store.City__c = 'San Francisco';
       store.State_Province__c = 'CA';
       store.Zip_Postal_Code__c = '95102';
       store.Country__c = 'United States';
       insert store;
    }

    @isTest
    // Test to confirm that StoreTrigger and Handler work correctly
    static void testCustomerSatisfactionChange() {
        // Get the initial store and any existing cases
        List<Store__c> stores = [SELECT Id, Customer_Satisfaction_Score__c
                                 FROM Store__c
                                 WHERE Name = 'San Francisco Hub'];
        Integer caseCountBefore = [SELECT COUNT()
                                   FROM Case
                                   WHERE Store__c = :stores[0].Id];

        // Run the code
        Test.startTest();
        stores[0].Customer_Satisfaction_Score__c = 70;
        update stores;
        Test.stopTest();

        // Get any cases created after the code ran and confirm details
        List<Case> casesAfter = [SELECT Subject, Status, Priority, Store__c
                                FROM Case WHERE Store__c = :stores[0].Id];

        System.assertEquals(caseCountBefore + 1, casesAfter.size(), 'One new case should have been created');
        System.assertEquals('Poor Customer Satisfaction', casesAfter[0].Subject,
                            'Subject should be Poor Customer Satisfaction');
        System.assertEquals('New', casesAfter[0].Status, 'Status should be New');
        System.assertEquals('High', casesAfter[0].Priority, 'Priority should be High');
        System.assertEquals(false, StoreTriggerHandler.platformEventsFailed, 'All platform events should succeed');
    }

    @isTest
    // Test to confirm StoreControllerExt works correctly
    static void testStoreControllerExt() {
       // Get the initial store and any existing cases
        List<Store__c> stores = [SELECT Id, Customer_Satisfaction_Score__c
                                 FROM Store__c
                                 WHERE Name = 'San Francisco Hub'];
        Integer caseCountBefore = [SELECT COUNT()
                                   FROM Case
                                   WHERE Store__c = :stores[0].Id];
        
        // Initialize the controller extension
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(stores[0]);
	    StoreControllerExt extension  = new StoreControllerExt(stdCtrlr);

        // Run the code
        Test.startTest();
        stores[0].Customer_Satisfaction_Score__c = 70;
        update stores;

        List<Case> openCases = extension.getOpenCases();
        Test.stopTest();                         
		
        System.assertEquals(caseCountBefore + 1, openCases.size(), 'One new case should have been created');
        System.assertEquals('Poor Customer Satisfaction', openCases[0].Subject,
                            'Subject should be Poor Customer Satisfaction');
        System.assertEquals('New', openCases[0].Status, 'Status should be New');
        System.assertEquals('High', openCases[0].Priority, 'Priority should be High');
    }
}
