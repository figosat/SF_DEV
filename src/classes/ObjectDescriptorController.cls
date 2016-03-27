/**
 * @author alk
 * @date 04/09/2015
 * @desc list all fields of an object
 */
public with sharing class ObjectDescriptorController {
	public String selectedObject {get; set;}
    public ObjectDescriptor objectDescriptor {get; set;}
    
    public ObjectDescriptorController() {}

    public Class ObjectDescriptor {//implements Comparable {
        public String objectLabel {get; set;}
        public String objectName {get; set;}
        public boolean isCustom {get; set;}
        public Integer nbTotalFields {get; set;}
        public Integer nbCustomFields {get; set;}
        public Integer nbStdFields {get; set;}
        public Integer nbRelationShips {get; set;}
        public List<FieldDescriptor> fields {get; set;}
        public List<RelationshipDescriptor> relationShips {get; set;}

        //public Integer compareTo(Object compareTo) {
        //    ObjectDescriptor compareToOD = (ObjectDescriptor) compareTo;
            
        //    //Compare two strings
        //    if (objectName.compareTo(compareToOD.objectName) == 0) return 0;
        //    if (objectName.compareTo(compareToOD.objectName) > 0) return 1;
        //    return -1;
        //}
    }

    public Class FieldDescriptor implements Comparable {
        public String fieldLabel {get; set;}
        public String fieldName {get; set;}
        public String fieldType {get; set;}
        public boolean isCustom {get; set;}
        public Integer fieldLength {get; set;}

        public Integer compareTo(Object compareTo) {
            FieldDescriptor compareToFD = (FieldDescriptor) compareTo;
            
            //Compare two strings
            if (fieldLabel.compareTo(compareToFD.fieldLabel) == 0) return 0;
            if (fieldLabel.compareTo(compareToFD.fieldLabel) > 0) return 1;
            return -1;
        }
    }

    public Class RelationshipDescriptor implements Comparable {
        public String childObject {get; set;}
        public String relatedField {get; set;}
        public String relationShipName {get; set;}
        public boolean isCascadeDelete {get; set;}

        public Integer compareTo(Object compareTo) {
            RelationshipDescriptor compareToFD = (RelationshipDescriptor) compareTo;
            
            //Compare two strings
            if (childObject.compareTo(compareToFD.childObject) == 0) return 0;
            if (childObject.compareTo(compareToFD.childObject) > 0) return 1;
            return -1;
        }
    }

    /**
     * ALK - getAllObjects get all object
     * @return List of SelectOption
     */
    public List<SelectOption> getAllObjetcs() {
        List<SelectOption> options = new List<SelectOption>();
        
        for(Schema.SObjectType gd :Schema.getGlobalDescribe().values()) {
            options.add(new SelectOption(gd.getDescribe().getName(), gd.getDescribe().getLabel()));
        }

        options.add(new SelectOption('0', '--None--'));

        options.sort();
        return options;
    }

    public void displayObjectFields() {
        if(selectedObject == '0') clear();
        else getObjectFields();
    }

    private void getObjectFields() {
        String[] types = new String[]{selectedObject};
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);

        for(Schema.DescribeSobjectResult res : results) {
            map<String, Schema.SObjectField> fieldMap = res.fields.getMap();
            objectDescriptor = new ObjectDescriptor();
            objectDescriptor.objectLabel = res.getLabel();
            objectDescriptor.objectName = res.getName();
            objectDescriptor.isCustom = res.isCustom();
            objectDescriptor.nbRelationShips = res.getChildRelationships().size();
            objectDescriptor.nbTotalFields = fieldMap.size();
            objectDescriptor.fields = new List<FieldDescriptor>();
            objectDescriptor.relationShips = new List<RelationshipDescriptor>();
            objectDescriptor.nbCustomFields = 0;
            objectDescriptor.nbStdFields = 0;

            for(String f :fieldMap.keySet()) {
                Schema.DescribeFieldResult dfr = fieldMap.get(f).getDescribe();
                FieldDescriptor fd = new FieldDescriptor();
                fd.fieldLabel = dfr.getLabel();
                fd.fieldName = dfr.getName();
                fd.fieldType = String.valueOf(dfr.getType()).toLowerCase();
                fd.isCustom = dfr.isCustom();
                if(fd.isCustom) objectDescriptor.nbCustomFields++;
                else objectDescriptor.nbStdFields++;
                fd.fieldLength = dfr.getLength();
                objectDescriptor.fields.add(fd);
            }

            for(Schema.ChildRelationship rs :res.getChildRelationships()) {
                RelationshipDescriptor rsDesc = new RelationshipDescriptor();
                rsDesc.childObject = rs.getChildSObject().getDescribe().getLabel();
                rsDesc.relatedField = rs.getField().getDescribe().getLabel();
                rsDesc.relationShipName = rs.getRelationshipName();
                rsDesc.isCascadeDelete = rs.isCascadeDelete();
                objectDescriptor.relationShips.add(rsDesc);
            }

            if(!objectDescriptor.fields.isEmpty()) objectDescriptor.fields.sort();
            if(!objectDescriptor.relationShips.isEmpty()) objectDescriptor.relationShips.sort();

        }
    }

    private void clear() {
        selectedObject = null;
        objectDescriptor = null;
    }
}