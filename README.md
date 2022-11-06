# Welcome to my Course

Thank you for starting one of my courses on Pluralsight! Here's some information to help you get the configuration and code used throughout the courses installed into your own org. This repository covers the following courses

- Salesforce Development: Fundamentals
- Salesforce Development: Data Modeling and Management
- Salesforce Development: Process Automation and Logic
- Salesforce Development: User Interface 

## How Do You Plan to Deploy Your Changes?

Choose whether you want to use a developer org or scratch org. Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)

# Options for Install

## Using Git

1. Clone the repository to your computer and navigate to that folder
    ```
    git clone https://github.com/adam17amo/platformDev.git 

    cd platformDev
    ```
2. Create a new [Developer Edition](https://developer.salesforce.com/signup) org and authorize it in VS code or create a [scratch org](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_scratch_orgs_create.htm) org with the alias platformDev
    ```
    sfdx force:org:create -s -f config/project-scratch-def.json -a platformDev --durationdays 30
    ```
3. If you're using a Developer Edition Org to deploy the code
   ```
   sfdx force:source:deploy -p force-app/main/default
   ```

   If you're using a Scratch Org to deploy the code
    ```
    sfdx force:source:push
    ```
4. Assign yourself the permission set
    ```
    sfdx force:user:permset:assign --permsetname Wired_Brain
    ```
5. Run the commands to import the data
    ```
    cd scripts/dataSetup
    chmod 744 createSampleData.sh
    ./createSampleData.sh
    ```
    These commands navigate to the scripts directory, grant you access to run the script, and then run the script.

## Installing Package

1. Install [this package](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t5f000000zed0) into your org
2. Assign yourself the Wired Brain permission set
3. (Optional) Create some sample data for Stores, Suppliers (Accounts), and Store Supply Orders
4. Download the code to your computer to follow along
    ```
    git clone https://github.com/adam17amo/platformDev.git 

    cd platformDev
    ```