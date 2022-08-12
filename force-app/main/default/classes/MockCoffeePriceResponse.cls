/**
 * @description - Mock API response from an external system
 */
public with sharing class MockCoffeePriceResponse {
    public static String coffeeApiResponse = '{' + 
                                            '"base":"USD",' +
                                            '"currentDate":"2022-07-30",' +
                                            '"rates": [' +
                                                '{"coffeeName":"Arabica",' +
                                                ' "price":"4.500"},' +
                                                '{"coffeeName":"Robusta",' +
                                                ' "price":"2.500"}' +
                                            '],' +
                                            '"unit": "per kg"' +
                                            '}';
}