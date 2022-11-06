/**
 * @author - Adam Olshansky
 * @description - Custom Controller to encode outputs
 */
public with sharing class OutputEncoder {
    public final String encodedOutput {get; set;}
    /**
     * @description - Constructor for Visualforce controller.
     * Retrieves the input passed in as a parameter and escapes HTML characters
     */
    public OutputEncoder() {
        String urlParam = ApexPages.currentPage().getParameters().get('input');
        if(String.isNotBlank(urlParam)) {
            this.encodedOutput = urlParam.escapeHtml4();
        }
    }
}