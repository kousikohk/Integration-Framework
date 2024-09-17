import { LightningElement, track, wire } from 'lwc';
import getIntegrationOptions from '@salesforce/apex/IntegrationSimulatorController.getIntegrationOptions';
import simulateIntegrationCall from '@salesforce/apex/IntegrationSimulatorController.simulateIntegrationCall';

export default class IntegrationSimulator extends LightningElement {
    @track integrationOptions = [];
    @track selectedIntegration = '';
    @track useMock = false;
    @track response = '';

    @wire(getIntegrationOptions)
    wiredIntegrationOptions({ error, data }) {
        if (data) {
            this.integrationOptions = data.map(opt => ({ label: opt, value: opt }));
        } else if (error) {
            console.error('Error fetching integration options:', error);
        }
    }

    handleIntegrationChange(event) {
        this.selectedIntegration = event.detail.value;
    }

    handleMockChange(event) {
        this.useMock = event.target.checked;
    }

    handleSimulate() {
        simulateIntegrationCall({ 
            integrationName: this.selectedIntegration, 
            useMock: this.useMock 
        })
        .then(result => {
            this.response = result;
        })
        .catch(error => {
            console.error('Error in simulation:', error);
            this.response = 'Error: ' + error.body.message;
        });
    }
}
