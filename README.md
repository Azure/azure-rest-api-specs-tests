# Live Testing for Azure REST API Specifications

The repository contains a set of scripts for Azure SDK live testing
[Azure REST API Specifications](https://github.com/Azure/azure-rest-api-specs).
The scripts use [Azure SDK for .Net](https://github.com/Azure/azure-sdk-for-net) to test other Azure SDKs for different programming languages. For example [Azure SDK for Go](https://github.com/Azure/azure-sdk-for-go).

## Build Definitions

- [VSTS](https://devdiv.visualstudio.com/NodeRepos/_build/index?definitionId=6392&_a=completed)
- [Azure SDK CI](http://azuresdkci.cloudapp.net/job/azure-rest-api-specs-tests/)

### Creating a Personal Build Definition

#### Requirements

- Windows 10
- PowerShell

#### Enviroment Variables

- `TEST_PROJECT` is a folder name from the [Azure SDK for .Net](https://github.com/Azure/azure-sdk-for-net/tree/vs17Dev/src/SDKs). For example `RedisCache`.
- `TEST_LANG` is a Azure SDK progamming language. For example `go`.
- `TEST_CSM_ORGID_AUTHENTICATION` is a connection string, in a format `SubscriptionId=...;ServicePrincipal=...;ServicePrincipalSecret=...;AADTenant=...;`
- `TEST_FORK` is a GitHub fork name of the [azure-rest-api-specs](https://github.com/Azure/azure-rest-api-specs).
- `TEST_BRANCH` is a GitHub fork branch name of the [azure-rest-api-specs](https://github.com/Azure/azure-rest-api-specs).

#### Build Stages

- [install.ps1](install.ps1)
- [build.ps1](build.ps1)
- [test.ps1](test.ps1)

## Contributing

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

### Adding a New Language for Testing

1. Create a new folder for the language, for example [go](go).
1. Create the PowerShell scripts in this folder:
   - `install.ps1`, install all required software to the `x` folder, for example [go/install.ps1](go/install.ps1)
   - `build.ps1`, build a `JSON-RPC` server for the Azure REST API specifications, for example [go/build.ps1](go/build.ps1)
   - `test.ps1`, set the `SDK_REMOTE_SERVER` environment variable to a path on the created `JSON-RPC` server, for example [go/test.ps1](go/test.ps1)

See also [Creating JSON-RPC server](json-rpc-server.md).


