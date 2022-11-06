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
}
