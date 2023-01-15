# Welcome to my Courses!

Thank you for starting one of my courses on Pluralsight! Here's some information to help you get the configuration and code used throughout the courses installed into your own org. This repository covers the following courses

- Salesforce Development: Fundamentals
- Salesforce Development: Data Modeling and Management
- Salesforce Development: Process Automation and Logic
- Salesforce Development: User Interface 

If you run into any issues or want to leave some feedback for me, feel free to drop a comment in Pluralsight or reach out to me on [Twitter](https://twitter.com/adam17amo) or [LinkedIn](https://www.linkedin.com/in/adamolshansky/)!

## How Do You Plan to Deploy Your Changes?

Choose whether you want to use a developer org or scratch org. Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).

# Tools to Install
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Salesforce CLI](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_install_cli.htm)
- Relevant Salesforce extensions for your IDE
    - For VS Code, [Salesforce Extension Pack](https://marketplace.visualstudio.com/items?itemName=salesforce.salesforcedx-vscode)

## Additional Resources

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)

# Options for Installing Files for Courses

## Upload Code Using Git

1. Clone the repository to your computer and navigate to that folder
    ```
    git clone https://github.com/adam17amo/platformDev.git 
    ```
    ```
    cd platformDev
    ```
2. Open the platformDev folder in your IDE
3. Create a new [Developer Edition](https://developer.salesforce.com/signup) org or [Enable an org as a Dev Hub](https://help.salesforce.com/s/articleView?id=sf.sfdx_setup_enable_devhub.htm&type=5) and create a [scratch org](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_scratch_orgs_create.htm) org with the alias platformDev

    3a. Authorize your Developer Edition org via your IDE or via a command
    ```
    sfdx force:auth:web:login --setalias platformDev --instanceurl https://login.salesforce.com --setdefaultusername
    ```
    3b. If you don't already have your [Dev Hub authorized](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_cli_usernames_orgs.htm), authorize it via your IDE or run the first command. Once it's authorized, create your scratch org via the second command
    ```
    sfdx auth:web:login --setdefaultdevhubusername --setalias my-hub-org
    ```
    ```
    sfdx force:org:create -s -f config/project-scratch-def.json -a platformDev --durationdays 30
    ```
4. Deploy the code to your org

    4a. If you're using a Developer Edition Org to deploy the code
   ```
   sfdx force:source:deploy -p force-app/main/default
   ```

   4b. If you're using a Scratch Org to deploy the code
    ```
    sfdx force:source:push
    ```
5. Assign yourself the permission set
    ```
    sfdx force:user:permset:assign --permsetname Wired_Brain
    ```

## Upload Code by Installing Package

1. Install [this package](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t5f000000zed0) into your org
2. Assign yourself the Wired Brain permission set
3. (Optional) Create some sample data for Stores, Suppliers (Accounts), and Store Supply Orders. Feel free to use the data folder as a guide
4. (Optional) Download the code to your computer to follow along
    ```
    git clone https://github.com/adam17amo/platformDev.git 
    ```
    ```
    cd platformDev
    ```

## Installing Sample Data (Optional)
1. Update the suppliers.json file to create sample data with the ID of the Supplier record type by running these commands in a terminal in your IDE

    1a. For Mac
    ```
    sfdx force:data:soql:query -q "SELECT Id FROM RecordType WHERE DeveloperName = 'Supplier'" | grep -E -o "([0-9])\w+" > recordType.txt; sed -i '' "s/\supplierRecordTypeId/$(cat recordType.txt)/g" ../../data/suppliers.json; rm recordType.txt
    ```

    1b. For Windows
    ```
    sfdx force:data:soql:query -q "SELECT Id FROM RecordType WHERE DeveloperName = 'Supplier'" | findstr /R "012[a-zA-Z0-9]*" > recordType.txt
    ```
    ```
    (Get-Content data/suppliers.json) -replace 'supplierRecordTypeId', (Get-Content recordType.txt).substring(1,18) | Set-Content data/suppliers.json; rm recordType.txt
    ```

    1c. Manually (if the above scripts don't work)
    - Navigate to your Salesforce Org -> Setup -> Object Manager -> Account -> Record Types -> Supplier and get the ID from the URL (starts with '012')
    - In the code, navigate to the suppliers.json file in the data folder and replace all instances of supplierRecordTypeId with the ID from the previous bullet

2. Import the sample data
    ```
    sfdx force:data:tree:import -p data/data-plan.json
    ```