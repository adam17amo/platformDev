/**
 * @author - Adam Olshansky
 * @description - Test class for AccountUtility, OutputEncoder, and Exceptions classes
 */
@isTest
public with sharing class MiscTests {
    @isTest
    static void testAccountUtility() {
        List<Account> accounts = TestFactory.createAccounts(3, true);

        Test.startTest();
        List<Account> accountsFromSearch = AccountUtility.getAccountsForSearch('Account 0');
        Test.stopTest();

        Assert.areEqual(1, accountsFromSearch.size(), 'One account should be found');
    }

    @isTest
    static void testAccountUtilityBlankSearch() {
        Test.startTest();
        List<Account> accountsFromSearch = AccountUtility.getAccountsForSearch('');
        Test.stopTest();

        Assert.isNull(accountsFromSearch);
    }

    @isTest
    static void testAccountUtilityBadQuery() {
        Test.startTest();        
        List<Account> accountsFromSearch = AccountUtility.getAccountsForSearch('\'badSearchHere');
        Test.stopTest();

        Assert.areEqual(0, accountsFromSearch.size());
    }
   
    @isTest
    static void testOutputEncoder() {
        PageReference pageRef = Page.OutputPage;
        Test.setCurrentPage(pageRef);
        String htmlInput = '<b>htmlInput</b>';
        ApexPages.currentPage().getParameters().put('input', htmlInput);
      
        Test.startTest();
        OutputEncoder encoder = new OutputEncoder();
        Test.stopTest();

        Assert.areNotEqual(htmlInput, encoder.encodedOutput,
                            'Output should have stripped HTML characters');
        String expectedOutput = htmlInput.escapeHtml4();
        // Should be '&lt;b&gt;htmlInput&lt;/b&gt;'
        Assert.areEqual(expectedOutput, encoder.encodedOutput, 'Output should be encoded');
    }

    @isTest
    static void exceptionsTestThrowException() {
        Test.startTest();
        Exceptions.createStore('New Store', true);
        Test.stopTest();

        Integer newStoreCount = [SELECT count() FROM Store__c WHERE Name = 'New Store'];
        Assert.areEqual(0, newStoreCount, 'No new stores should have been created');
    }

    @isTest
    static void exceptionsTestCreateStore() {
        Test.startTest();
        Exceptions.createStore('New Store', false);
        Test.stopTest();

        Integer newStoreCount = [SELECT count() FROM Store__c WHERE Name = 'New Store'];
        Assert.areEqual(1, newStoreCount, 'No new stores should have been created');
    }

    @isTest
    static void testSchedulableJob() {
        Test.startTest();
        // This test runs a scheduled job tomorrow at midnight
        String CRON_EXP = '0 0 0 * * ?';
        String jobId = System.schedule('Task Creator Batch', CRON_EXP, new ScheduleTaskCreatorBatch(30));
        // Get the information from the CronTrigger API object 
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId]; 
        // Verify the job has not run 
        Assert.areEqual(0, ct.TimesTriggered, 'The job should not have fired yet'); 
        // Verify the next time the job will run 
        Date tomorrow = Date.today().addDays(1);
        Time midnight = Time.newInstance(0, 0, 0, 0);
        DateTime tomorrowMidnight = DateTime.newInstance(tomorrow, midnight);
        Assert.areEqual(String.valueOf(tomorrowMidnight), String.valueOf(ct.NextFireTime),
                        'Confirm the job is scheduled to fire tomorrow at midnight');   
        Test.stopTest();
        // Job should execute immediately
    }

    @isTest
    static void testTaskCreatorJobSuccess() {
        // Create a store
        List<Store__c> newStores = TestFactory.createStores(1, true);
        Assert.areEqual(1, newStores.size(), 'There should be one store created');
        
        // Create some new cases and tie them to the store
        Integer openCasesToCreate = 3;
        Integer threshold = 30;
        List<Case> newCases = TestFactory.createCases(openCasesToCreate, false);
        for(Case newCase : newCases) {
            newCase.Store__c = newStores[0].Id;
            newCase.OwnerId = UserInfo.getUserId();
        }
        insert newCases;
        // Set the created date to be 31 days in the past
        for(Case newCase : newCases) {
            Test.setCreatedDate(newCase.Id, Date.today().addDays(-31));
        }

        Integer taskCountBefore = [SELECT count() FROM Task];

        Test.startTest();
        // Create and fire the batch job
        TaskCreatorBatch tcb = new TaskCreatorBatch(threshold, false);
        Database.executeBatch(tcb, 5);
        Test.stopTest();
        // Job should execute synchronously

        // Get the newly created tasks
        List<Task> tasksAfter = [SELECT Status,
                                        Subject,
                                        Priority,
                                        Description
                                FROM Task];

        Assert.areEqual(taskCountBefore + openCasesToCreate, tasksAfter.size(),
                        'There should have been ' + openCasesToCreate + ' new tasks created');
        for(Task newTask : tasksAfter) {
            Assert.areEqual('In Progress', newTask.Status, 'The new task status should be In Progress');
            Assert.areEqual('Other', newTask.Subject, 'The new task subject should be Other');
            Assert.areEqual('High', newTask.Priority, 'The new task priority should be High');
            Assert.areEqual('This case has been open for more than ' + threshold + ' days',
                            newTask.Description,
                            'The new task description should be reference how long it has been open');
        }
    }

    @isTest
    static void testTaskCreatorJobException() {
        // Create a store
        List<Store__c> newStores = TestFactory.createStores(1, true);
        Assert.areEqual(1, newStores.size(), 'There should be one store created');
        
        // Create some new cases and tie them to the store
        Integer openCasesToCreate = 3;
        Integer threshold = 30;
        List<Case> newCases = TestFactory.createCases(openCasesToCreate, false);
        for(Case newCase : newCases) {
            newCase.Store__c = newStores[0].Id;
            newCase.OwnerId = UserInfo.getUserId();
        }
        insert newCases;
        // Set the created date to be 31 days in the past
        for(Case newCase : newCases) {
            Test.setCreatedDate(newCase.Id, Date.today().addDays(-31));
        }

        Integer taskCountBefore = [SELECT count() FROM Task];

        Test.startTest();
        // Create and fire the batch job, specifying the exception should be thrown
        TaskCreatorBatch tcb = new TaskCreatorBatch(threshold, true);
        Database.executeBatch(tcb, 5);
        Test.stopTest();
        // Job should execute synchronously

        Integer taskCountAfter = [SELECT count() FROM Task];

        Assert.areEqual(taskCountBefore, taskCountAfter,
                        'There should not have been any new tasks created');
    }
}
