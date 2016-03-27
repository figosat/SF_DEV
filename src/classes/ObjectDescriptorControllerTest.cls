@isTest
private class ObjectDescriptorControllerTest {
	
	@isTest static void test_method() {
		ObjectDescriptorController od = new ObjectDescriptorController();
		List<SelectOption> allObjects = od.getAllObjetcs();

		System.assert(!allObjects.isEmpty(), 'Objects should be displayed');

		od.selectedObject = 'Account';
		od.displayObjectFields();

		System.assert(od.objectDescriptor != null && !od.objectDescriptor.fields.isEmpty(), 'Fields should be displayed');

		od.selectedObject = '0';
		od.displayObjectFields();
		System.assert(od.objectDescriptor == null, 'Fields should be cleared');

	}
	
}