/**
 * @description - Class to be used for demonstrating how to create variables in Salesforce
 */
public with sharing class Variables {
    /**
     * @description - Variable examples of primitive types that can't be broken down
     */
    public static void primitiveVariables() {
        // Strings are text values
        String complimentString = 'You are amazing';
        String favoriteAnimal = 'dolphin';

        // Integers are numbers
        Integer myInt = 3;
        Integer updatedInt = myInt + 5; // 8
        System.debug('My int is ' + myInt + ' and updatedInt is ' + updatedInt);
        updatedInt = myInt + 10; // 13
        System.debug('My int is ' + myInt + ' and updatedInt is ' + updatedInt);

        // Decimals have decimal points
        Decimal piValue = 3.14;
        Decimal milesToKm = 1.609;
        Decimal distanceInKm = myInt * milesToKm;
        System.debug('3 miles in km is ' + distanceInKm + ' km');

        // Booleans are like checkboxes and are true, false, or null
        Boolean skyIsBlue = true;
        Boolean skyIsGray = false;
        Boolean beachIsRelaxing = true;
        Boolean beachIsClosed = false;
        Boolean vacationWasFun = (skyIsBlue && beachIsRelaxing); // true AND true = true
        System.debug('Result of vacationWasFun ' + vacationWasFun);
        Boolean vacationWasRuined = (skyIsGray || beachIsClosed); // false OR false = false
        System.debug('Result of vacationWasRuined ' + vacationWasRuined);
    }

    /**
     * @description - Variables of Salesforce objects
     */
    public static void sObjectVariables() {
        Account myAcct = new Account();
        Account acctWithName = new Account(Name='Retail Chain');
        System.debug('New account is ' + acctWithName);

        Store__c sfHub = new Store__c(Name='San Francisco Hub');
        System.debug('New store is ' + sfHub);
    }

    /**
     * @description - Variables of Salesforce collections; lists, sets, and maps
     */
    public static void collectionVariables() {
        List<String> animals = new List<String>{'Lion', 'Tiger', 'Bear'};
        animals.add('Cow');
        System.debug('Number of animals ' + animals.size()); // Should be 4
        System.debug('First animal in list is ' + animals[0]); // Should be Lion

        Set<String> sports = new Set<String>();
        sports.add('Hockey');
        sports.add('Baseball');
        sports.add('Basketball');
        sports.add('Football');
        sports.add('Hockey');
        System.debug('Size of sports set is ' + sports.size()); // Should be 4
        
        Map<Integer, String> addresses = new Map<Integer, String>();
        addresses.put(1600, 'White House');
        addresses.put(123, 'Sesame St');
        addresses.put(90210, 'Hollywood');
        addresses.put(90210, 'Beverly Hills');
        System.debug('Contents of addresses ' + addresses);
        System.debug('Size of addresses is ' + addresses.size()); // Should be 3
        System.debug('Address of 123 is ' + addresses.get(123));
    }

    /**
     * @description - Variables using constants
     */
    public static void variablesWithConstants() {
        Integer radiusOfCircle = 5;
        Decimal circumferenceOfCircle = 2 * Constants.VALUE_OF_PI * radiusOfCircle;
        System.debug('Circumference of circle is ' + circumferenceOfCircle); // 31.40

        // Constants.VALUE_OF_PI = 3.15; // This line will throw an error

        String legalDocumentStart = 'Thank you for doing business with '
                                    + Constants.COMPANY_LEGAL_NAME;
        System.debug('Beginning of legal document is ' + legalDocumentStart);
    }
}
