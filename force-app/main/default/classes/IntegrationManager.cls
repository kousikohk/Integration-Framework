public class IntegrationManager {

    public static String callExternalService(String integrationName, String requestPayload) {
        // Fetch integration configuration using custom metadata
        Integration_Config__mdt config = getIntegrationConfig(integrationName);

        if (config != null && config.Use_Mock__c) {
            // Call the mock service handler
            return MockServiceHandler.getMockResponse(integrationName);
        } else {
            // Logic to call the actual external service
            return callActualExternalService(requestPayload);
        }
    }

    private static Integration_Config__mdt getIntegrationConfig(String integrationName) {
        List<Integration_Config__mdt> configs = [SELECT Use_Mock__c FROM Integration_Config__mdt WHERE DeveloperName = :integrationName];
        if (!configs.isEmpty()) {
            return configs[0];
        }
        return null;
    }

    private static String callActualExternalService(String requestPayload) {
        // Logic to perform HTTP callout to external service
        return 'Actual Service Response';
    }
}
