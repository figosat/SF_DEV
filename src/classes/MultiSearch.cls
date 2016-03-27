/**
* @author: aleibek
* @date: 04/06/2015
* @desc: Search users/contacts/accounts from each other
*/

public with sharing class MultiSearch {
    public String textResearch {get; set;}
    public List<SearchWrapper> result {get; set;}
    public String selectedObject {get; set;}
    public String selectedField {get; set;}
    public List<sObject> listSObj {get; set;}
    public String wrapperJSON {get; set;}

    public MultiSearch() {
    	wrapperJSON = '';
    }

    public Class SearchWrapper {
        public Id id {get; set;}
        public String name {get; set;}

        public SearchWrapper(Id id, String name) {
            this.Id = id;
            this.name = name;
        }
    }


    /**********************************************
    *   Search
    /**********************************************/
    public void search() {
    	result = new List<SearchWrapper>();
    	listSObj = new List<sObject>();
        System.debug('>>>>>> ALK - in search ');
        String query = 'Select Id, ' + selectedField + ' from ' + selectedObject + ' where ' + selectedField + ' like \'%' + textResearch + '%\'';
        System.debug('>>>>>> ALK - Query : ' + query);
        //List<sObject> l = Database.query(query);
        for(sObject s: Database.query(query)) {
        	system.debug('>>>> ALK s : ' + s);
        	listSObj.add(s);
        	//SearchWrapper sw = new SearchWrapper(s.Id, String.valueOf(s));
        	//result.add(sw);
        }

        wrapperJSON = JSON.serialize(listSObj);
        System.debug('>>>> ALK - wrapperJSON : ' + wrapperJSON);

        //textResearch = '%' + textResearch + '%';
        //Get contacts
        //for(Contact c :[Select Id, Name from Contact where Name like :textResearch]) {
        //    SearchWrapper sw = new SearchWrapper(c.Id, c.Name);
        //    result.add(sw);
        //}

        ////getUsers();
        //for(User u :[Select Id, Name from User where Name like :textResearch]) {
        //    SearchWrapper sw = new SearchWrapper(u.Id, u.Name);
        //    result.add(sw);
        //}

        ////getAccounts();
        //for(Account a :[Select Id, Name from Account where Name like :textResearch]) {
        //    SearchWrapper sw = new SearchWrapper(a.Id, a.Name);
        //    result.add(sw);
        //}

        //System.debug('>>>>>> ALK - l : ' + l);
    }

    /**********************************************
    *   List All Objects 
    /**********************************************/
    public List<SelectOption> getAllObjetcs() {
        List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();
        List<SelectOption> options = new List<SelectOption>();
    
        for(Schema.SObjectType f : gd) {
            options.add(new SelectOption(f.getDescribe().getName(),f.getDescribe().getLabel() + ' - ' + f.getDescribe().getName()));
        }

        if(String.isEmpty(selectedObject)) selectedObject = options[0].getValue();

        return options;
    }

    /**********************************************
    *   List All fields for an sobject 
    ///**********************************************/
    public List<SelectOption> getAllFields() {
        List<SelectOption> options = new List<SelectOption>();
        String[] types = new String[]{selectedObject};
    	Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        
        for(Schema.DescribeSobjectResult res : results) {
        	map<String, Schema.SObjectField> fieldMap = res.fields.getMap();
		    //System.debug('>>>>>> ALK - sObject Label: ' + res.getLabel());
		    //System.debug('>>>>>> ALK - Number of fields: ' + fieldMap.size());
		    //System.debug(res.isCustom() ? '>>>>>> ALK - This is a custom object.' : '>>>>>> ALK - This is a standard object.');
		    // Get child relationships
		    //Schema.ChildRelationship[] rels = res.getChildRelationships();
		    //if (rels.size() > 0) {
		    //    System.debug('>>>>>> ALK -  : ' + res.getName() + ' has ' + rels.size() + ' child relationships.');
		    //}

		    //Feed selectOption
		    for(String f :fieldMap.keySet()) {
		    	if(System.Label.FIELD_TYPE.toUpperCase().contains(''+fieldMap.get(f).getDescribe().getType())) {
		    		//options.add(new SelectOption(f,fieldMap.get(f).getDescribe().getType() + ' - ' + fieldMap.get(f).getDescribe().getLabel()));	
		    		options.add(new SelectOption(f,fieldMap.get(f).getDescribe().getLabel()));	
		    	}
		    	//System.debug('>>>>>>> ALK - fieldMap.get(f) : ' + fieldMap.get(f));
		    	//System.debug('>>>>>>> ALK - fieldMap.get(f).getDescribe() : ' + fieldMap.get(f).getDescribe().getLabel());
		    }
		}

        return options;
    }

    /************************************************
    * Update field's selectlist
    *************************************************/
    public void updateFieldsList() {
    	getAllFields();
    }

}