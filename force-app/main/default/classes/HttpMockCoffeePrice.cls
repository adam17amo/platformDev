/**
 * @author - Adam Olshansky
 * @description - Mock class that will make fire when external callouts are made in a test context 
 */
@isTest
global class HttpMockCoffeePrice implements HttpCalloutMock{
    Integer statusCode;

    /**
     * @description - Constructor to create a new instance of the mock class with a status code
     * @param statusCode The status code of the mock external callout
     */
    public HttpMockCoffeePrice(Integer statusCode) {
        this.statusCode = statusCode;
    }

    /**
     * @description - Creates a mock response for a callout in a test context
     * @param req An HTTPRequest called from the code
     * @return HTTPResponse A response that mocks what would be actually returned from an external system
     */
    global HTTPResponse respond(HTTPRequest req) {
        System.debug('Mock class has fired');
        HttpResponse response = new HttpResponse();
        response.setStatusCode(this.statusCode);
        if(this.statusCode == 200) {
            response.setStatus('OK');
            response.setBody(MockCoffeePriceResponse.coffeeApiResponse);
        }

        return response;
    }
}