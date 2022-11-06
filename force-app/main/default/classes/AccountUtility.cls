/**
 * @author - Adam Olshansky
 * @description - Custom Controller to retrieve accounts for searching using dynamic SOQL
 */
public with sharing class AccountUtility {
    /**
     * @description - Search method for accounts with specified name
     * An expected input would be one of your account names
     * A vulnerable input could be something like Globo Mart' OR AnnualRevenue > 1000000 OR Name = '
     * @param searchTerm - The account name to search for
     * @return - The list of accounts that match the search term
     */
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountsForSearch(String searchTerm) {
        List<Account> queriedAccounts = new List<Account>();
        // Return immediately if nothing is being searched
        if(String.isBlank(searchTerm)) {
            return null;
        }
        // Escape any single quotes from the search term to avoid unexpected results
        String sanitizedSearchTerm = String.escapeSingleQuotes(searchTerm);
        System.debug('Sanitized search term is ' + sanitizedSearchTerm);
        String accountQuery = 'SELECT Id, ' +
                                    'Name, ' +
                                    'AnnualRevenue, ' +
                                    'Customer_Priority__c '+
                                'FROM ' +
                                    'Account ' +
                                'WHERE ' +
                                'Name LIKE ' + '\'' + searchTerm + '\'';
                                // Uncomment the line below and comment out the line above
                                // 'Name LIKE ' + '\'' + sanitizedSearchTerm + '\'';
        System.debug('Search query is ' + accountQuery);
        try {
            queriedAccounts = (List<Account>)Database.query(accountQuery);
        } catch(Exception e) {
            System.debug('Exception was ' + e.getMessage());
        }
        return queriedAccounts;
    }
}