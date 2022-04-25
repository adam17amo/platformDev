# Welcome to my Course

Thank you for starting one of my courses on Pluralsight! Here's some information to help you get the configuration and code used throughout the courses installed into your own org.

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

- Create a new [scratch org](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_scratch_orgs_create.htm) or Developer Edition org
- Create a local folder to store your source code and navigate to that folder
- Run `git clone https://github.com/adam17amo/platformDev.git` in VS Code to bring the source code to your local computer
- Authorize your org in VS Code
- Run `sfdx force:source:deploy -p force-app/main/default` for a Developer Edition org or `sfdx force:source:push` for a scratch org to push the files into your org
- Run `sfdx force:user:permset:assign --permsetname Wired_Brain` to assign yourself the permission set

## Installing Package

- Install [this package](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t5f000000zdEc) into your org
