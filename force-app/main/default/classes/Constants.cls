/**
 * @description - Class to be used for demonstrating how to create constants in Salesforce
 */
public with sharing class Constants {
    public static final Decimal VALUE_OF_PI = 3.14;
    public static final Decimal MILES_TO_KM = 1.609;
    public static final String COMPANY_LEGAL_NAME = 'Wired Brain Coffee LLC';
    public static final List<String> COLORS_OF_RAINBOW = 
        new List<String>{'Red', 'Orange', 'Yellow', 'Green', 'Blue', 'Indigo', 'Violet'};
}
