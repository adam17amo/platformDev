/**
 * @author - Adam Olshansky
 * @description - Test class for Store Trigger, StoreTriggerHandler, StoreControllerExt,
 *                StoreCustomController, and MockCoffeePriceResponse classes
 */
@isTest
public with sharing class StoreTests {
    @testSetup
    static void createRecords(){
        TestFactory.createStores(1, true);
    }

    @isTest
    // Test to confirm that StoreTrigger and Handler work correctly
    static void testCustomerSatisfactionChange() {
        // Get the initial store and any existing cases
        List<Store__c> stores = [SELECT Id, Customer_Satisfaction_Score__c
                                 FROM Store__c
                                 WHERE Name LIKE 'San Francisco Hub%'];
        Assert.isTrue(!stores.isEmpty());
        Integer caseCountBefore = [SELECT COUNT()
                                   FROM Case
                                   WHERE Store__c = :stores[0].Id];

        System.debug('DML statements run before Test.startTest() ' + Limits.getDmlStatements());
        // Run the code
        Test.startTest();
        System.debug('DML statements run after Test.startTest() ' + Limits.getDmlStatements());
        stores[0].Customer_Satisfaction_Score__c = 70;
        update stores;
        Test.stopTest();

        // Get any cases created after the code ran and confirm details
        List<Case> casesAfter = [SELECT Subject, Status, Priority, Store__c
                                FROM Case WHERE Store__c = :stores[0].Id
                                ORDER BY LastModifiedDate DESC];

        Assert.areEqual(caseCountBefore + 1, casesAfter.size(), 'One new case should have been created');
        Assert.areEqual('Poor Customer Satisfaction', casesAfter[0].Subject,
                            'Subject should be Poor Customer Satisfaction');
        Assert.areEqual('New', casesAfter[0].Status, 'Status should be New');
        Assert.areEqual('High', casesAfter[0].Priority, 'Priority should be High');
        Assert.areEqual(false, StoreTriggerHandler.platformEventsFailed, 'All platform events should succeed');
    }

    @isTest
    // Test to confirm StoreControllerExt works correctly
    static void testStoreControllerExt() {
       // Get the initial store and any existing cases
        List<Store__c> stores = [SELECT Id, Customer_Satisfaction_Score__c
                                 FROM Store__c
                                 WHERE Name LIKE 'San Francisco Hub%'];
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
		
        Assert.areEqual(caseCountBefore + 1, openCases.size(), 'One new case should have been created');
        Assert.areEqual('Poor Customer Satisfaction', openCases[0].Subject,
                            'Subject should be Poor Customer Satisfaction');
        Assert.areEqual('New', openCases[0].Status, 'Status should be New');
        Assert.areEqual('High', openCases[0].Priority, 'Priority should be High');
    }

    @isTest
    // Test for the StoreCustomController create a Store functionality
    static void testStoreCustomControllerCreate() {
        PageReference pageRef = Page.StoreCreateCustom;
        Test.setCurrentPage(pageRef);

        Integer beforeStoreCount = [SELECT count() FROM Store__c];
      
        Test.startTest();
        StoreCustomController controller = new StoreCustomController();
        controller.name = 'Phoenix Hub';
        controller.buzzId = 'WBC002';
        controller.city = 'Phoenix';
        controller.stateProvince = 'AZ';
        controller.country = 'United States';
        controller.save();
        Test.stopTest();

        Integer afterStoreCount = [SELECT count() FROM Store__c];
        Assert.areEqual(beforeStoreCount + 1, afterStoreCount,
                        'One new store should have been created');
        Store__c newStore = [SELECT Name, Buzz_Id__c, City__c, State_Province__c, Country__c
                            FROM Store__c
                            WHERE Name = 'Phoenix Hub' LIMIT 1];
        Assert.areEqual(controller.name, newStore.Name, 'Name should have been set');
        Assert.areEqual(controller.buzzId, newStore.Buzz_Id__c, 'Buzz Id should have been set');
        Assert.areEqual(controller.city, newStore.City__c, 'City should have been set');
        Assert.areEqual(controller.stateProvince, newStore.State_Province__c,
                        'State Province should have been set');
        Assert.areEqual(controller.country, newStore.Country__c, 'Country should have been set');
    }

    @isTest
    // Test for the StoreCustomController update a Store functionality
    static void testStoreCustomControllerUpdate() {
        Store__c currentStore = [SELECT Name, Buzz_Id__c, City__c, State_Province__c, Country__c
                                FROM Store__c
                                WHERE Name LIKE 'San Francisco Hub%' LIMIT 1];
        PageReference pageRef = Page.StoreCreateCustom;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', currentStore.Id);
      
        Test.startTest();
        StoreCustomController controller = new StoreCustomController();
        controller.city = 'San Jose';
        PageReference saveRedirect = controller.save();
        Assert.areEqual('/' + currentStore.Id, saveRedirect.getUrl(),
                        'Redirect should be the record detail page');
        PageReference cancelRedirect = controller.cancel();
        Assert.areEqual('/lightning/o/Store__c/home', cancelRedirect.getUrl(),
                        'Redirect should be the Store home page');
        Test.stopTest();

        Store__c updatedStore = [SELECT City__c
                                FROM Store__c
                                WHERE Name LIKE 'San Francisco Hub%' LIMIT 1];
        Assert.areEqual(controller.city, updatedStore.City__c,
                        'City should reflect what was set on the page');
    }

    @isTest
    // Test for the StoreCustomController update a Store functionality without access
    static void testStoreCustomControllerUpdateNoAccess() {
        Store__c currentStore = [SELECT Name, Buzz_Id__c, City__c, State_Province__c, Country__c
                                FROM Store__c
                                WHERE Name LIKE 'San Francisco Hub%' LIMIT 1];
        PageReference pageRef = Page.StoreCreateCustom;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', currentStore.Id);
      
        Test.startTest();
        User standardUser = TestFactory.createUser('Standard User');
        // Standard users not have access to create stores
        System.runAs(standardUser) {
            StoreCustomController controller = new StoreCustomController();
            controller.city = 'San Jose';
            PageReference saveRedirect = controller.save();
            Assert.isNull(saveRedirect, 'Redirect should be null');
        }
        Test.stopTest();

        Store__c updatedStore = [SELECT City__c
                                FROM Store__c
                                WHERE Name LIKE 'San Francisco Hub%' LIMIT 1];
        Assert.areEqual(currentStore.City__c, updatedStore.City__c,
                        'City should not have been changed');
        Assert.areEqual(1, ApexPages.getMessages().size(), 'There should be 1 message');
        ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,
                                                            'User does not have access to create or edit a store');
        Assert.areEqual(errorMessage, ApexPages.getMessages()[0],
                        'The error message should reflect the lack of access');
    }

    @isTest
    // Test to confirm Invocable method in StoreTriggerHandler works correctly
    static void testInvocableMethod() {
        List<String> coffeeTypes = new List<String>{'Arabica;Robusta'};
        List<StoreTriggerHandler.CoffeePrice> coffeePrices = StoreTriggerHandler.updateCoffeePrices(coffeeTypes);
        String prices = coffeePrices[0].prices;
        Assert.isTrue(prices.contains('Arabica'), 'Arabica should be part of the response');
        Assert.isTrue(prices.contains('Robusta'), 'Robusta should be part of the response');
    }

    @isTest
    // Test to confirm Invocable method in StoreTriggerHandler works correctly using mock framework
    static void testExternalCallout() {
        Test.startTest();
        /* Please uncomment out line 130 and comment out lines 131-134 in StoreTriggerHandler 
        to properly invoke the mock framework */
        Test.setMock(HttpCalloutMock.class, new HttpMockCoffeePrice(200));
        List<String> coffeeTypes = new List<String>{'Arabica;Robusta'};
        List<StoreTriggerHandler.CoffeePrice> coffeePrices = StoreTriggerHandler.updateCoffeePrices(coffeeTypes);
        String prices = coffeePrices[0].prices;
        Assert.isTrue(prices.contains('Arabica'), 'Arabica should be part of the response');
        Assert.isTrue(prices.contains('Robusta'), 'Robusta should be part of the response');
        Test.stopTest();
    }
}
