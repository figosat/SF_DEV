/**
 * ALK - DeleteAll data from an sObject
 */

public with sharing class DeleteAllController {
    public String selectedObject {set; get;}
    public Integer counter {set; get;}

    public DeleteAllController() {}


    //////////////////////////////////
    //        GET OBJECTS           //
    //////////////////////////////////
    public List<SelectOption> getAllObjetcs() {
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('0', '-none-'));
        options.add(new SelectOption('Account', 'Account'));
        options.add(new SelectOption('Produit_Retractation__c', 'Produit_Retractation__c'));
        options.add(new SelectOption('Ressenti_Post_Appel__c', 'Ressenti_Post_Appel__c'));
        options.add(new SelectOption('Product_DCS__c', 'Product_DCS__c'));
        options.add(new SelectOption('Product_Box__c', 'Product_Box__c'));
        options.add(new SelectOption('Case', 'Case'));
        options.add(new SelectOption('DCS__c', 'DCS__c'));
        options.add(new SelectOption('Commande_Logistique_History__c', 'Commande_Logistique_History__c'));
        options.add(new SelectOption('Commande__c', 'Commande__c'));
        options.add(new SelectOption('Commande_Logistique__c', 'Commande_Logistique__c'));
        options.add(new SelectOption('Commande_Articles__c', 'Commande_Articles__c'));
        options.add(new SelectOption('Avis_Client__c', 'Avis_Client__c'));
        options.add(new SelectOption('Balance_History__c', 'Store Credit'));
        options.sort();

        return options;
    }

    public void countRecords() {
        List<AggregateResult> results = Database.query('Select count(id) from ' + selectedObject);
        if(!results.isEmpty()) {
            counter = (Integer) results[0].get('expr0');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,selectedObject + ' has ' + counter + ' records to delete'));
        }
    }

    //////////////////////////////
    //       DELETE ALL         //
    //////////////////////////////
    public void deleteAll() {
        List<sObject> data = Database.query('Select id from ' + selectedObject + ' Limit 10000');
        if(!data.isEmpty()) deleteData(data);
        if(ApexPages.getMessages().isEmpty()) ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'10 000 records of ' + selectedObject + ' were deleted'));
    }

    ///////////////////////////////////
    //         DELETE DATA           //
    ///////////////////////////////////
    public static void deleteData(List<sObject> dataToDelete) {
        try {
                String error;
                String ret;
                Database.DeleteResult[] drList = Database.delete (dataToDelete, false);
                for (Integer i=0; i < drList.size(); i++) {
                    Database.DeleteResult dr = drList.get(i);
                    if (!dr.isSuccess()) {
                        for(Database.Error err : dr.getErrors()) {
                                error = 'The following error has occurred : '  + err.getStatusCode() + ' : ' + err.getMessage()
                                                + ' Fields that affected this error : ' + err.getFields();
                        }
                        System.debug(error);
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,error));
                    }
                }
            } catch(Exception e) {
                System.debug(e.getTypeName() + ' - ' + e.getCause() + ': ' + e.getMessage());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getTypeName() + ' - ' + e.getCause() + ': ' + e.getMessage()));
            }
    }
}