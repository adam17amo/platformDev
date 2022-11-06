echo "Updating data with Supplier record type Id"
sfdx force:data:soql:query -q "SELECT Id FROM RecordType WHERE DeveloperName = 'Supplier'" | grep -E -o "([0-9])\w+" > recordType.txt; sed -i '' "s/\supplierRecordTypeId/$(cat recordType.txt)/g" ../../data/suppliers.json; rm recordType.txt
echo "Record Type Id Updated"
echo "Creating data..."
sfdx force:data:tree:import -p ../../data/data-plan.json
echo "Data creation complete"