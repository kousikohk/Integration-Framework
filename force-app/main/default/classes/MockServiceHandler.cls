public class MockServiceHandler {

    public static String getMockResponse(String integrationName) {
        // Fetch mock configuration using custom metadata
        List<Integration_Mock_Config__mdt> mockConfigs = [SELECT Mock_Enabled__c, Response_Payload__c, Error_Scenario__c
                                                          FROM Integration_Mock_Config__mdt 
                                                          WHERE DeveloperName = :integrationName];
                                                          
        if (!mockConfigs.isEmpty()) {
            Integration_Mock_Config__mdt mockConfig = mockConfigs[0];
            if (mockConfig.Mock_Enabled__c) {
                // Simulate different error scenarios
                if (mockConfig.Error_Scenario__c == 'Timeout') {
                    throw new CalloutException('Mock Timeout Exception');
                } else if (mockConfig.Error_Scenario__c == 'Error') {
                    throw new CalloutException('Mock Error Exception');
                }
                return mockConfig.Response_Payload__c;
            }
        }
        return 'Default Mock Response';
    }
}
