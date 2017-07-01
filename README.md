# Live Testing for Azure REST API Specifications

The repository contains a set of scripts for Azure SDK live testing
[Azure REST API Specifications](https://github.com/Azure/azure-rest-api-specs).
The scripts use [Azure SDK for .Net](https://github.com/Azure/azure-sdk-for-net) to test other Azure SDKs for different programming languages. For example [Azure SDK for Go](https://github.com/Azure/azure-sdk-for-go).

## Build Definitions

- [Azure SDK CI](http://azuresdkci.cloudapp.net/job/azure-rest-api-specs-tests-all/)
- [VSTS](https://devdiv.visualstudio.com/NodeRepos/_build/index?definitionId=6392&_a=completed)

### Creating a Personal Build Definition

#### Requirements

- Windows 10
- PowerShell

#### Enviroment Variables

- `TEST_PROJECT` is a REST API specification name from [azure-rest-api-specs](https://github.com/Azure/azure-rest-api-specs). See [sdkinfo.json](sdkinfo.json) for available names. For example `arm-redis`.
- `TEST_LANG` is a Azure SDK programming language. For example `go`.
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

### Running Locally

1. Run [.\init.ps1](init.ps1) to clone the recent [Azure REST API specifications] and [Azure SDK for .Net]
1. Run [.\built.ps1 {service name}](build.ps1) to build a service project. For example, `.\build.ps1 -project arm-redis`.
1. Run [.\test.ps1 {service name}](test.ps1) to test a service project. For example, `.\test.ps1 -project arm-redis`.
arm-redis`.

See also
- [Creating an Azure Active Directory application and service principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal).
