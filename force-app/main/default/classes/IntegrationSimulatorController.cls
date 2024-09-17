public with sharing class IntegrationSimulatorController {

    @AuraEnabled(cacheable=true)
    public static List<String> getIntegrationOptions() {
        List<String> integrationNames = new List<String>();

        // Fetch available integrations from Custom Metadata
        List<Integration_Config__mdt> configs = [SELECT DeveloperName FROM Integration_Config__mdt];
        for (Integration_Config__mdt config : configs) {
            integrationNames.add(config.DeveloperName);
        }

        return integrationNames;
    }

    @AuraEnabled
    public static String simulateIntegrationCall(String integrationName, Boolean useMock) {
        // Use custom metadata to set runtime configuration
        Integration_Config__mdt config = [SELECT Use_Mock__c FROM Integration_Config__mdt WHERE DeveloperName = :integrationName LIMIT 1];
        if (config != null) {
            config.Use_Mock__c = useMock;
        }

        // Call the integration manager to simulate the service call
        String response = IntegrationManager.callExternalService(integrationName, '{}');
        return response;
    }
}
