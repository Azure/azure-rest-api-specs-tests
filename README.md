# Live Testing for Azure REST API Specifications

The repository contains a set of scripts for Azure SDK live testing
[Azure REST API Specifications](https://github.com/Azure/azure-rest-api-specs).
The scripts use [Azure SDK for .Net](https://github.com/Azure/azure-sdk-for-net) to test other Azure SDKs for different programming languages. For example [Azure SDK for Go](https://github.com/Azure/azure-sdk-for-go).

## Build Definitions

- [VSTS](https://devdiv.visualstudio.com/NodeRepos/_build/index?definitionId=6392&_a=completed).

### Creating a Personal Build Definition

#### Requirements

- PowerShell

#### Enviroment Variables

- `TEST_PROJECT` is a name of folder from the [Azure SDK for .Net](https://github.com/Azure/azure-sdk-for-net/tree/vs17Dev/src/SDKs). For example `RedisCache`.
- `TEST_LANG` is a Azure SDK progamming language. For example `go`.
- `TEST_CSM_ORGID_AUTHENTICATION` is a connection string.

## Contributing

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

### Adding a New Language for Testing

1. Create a new folder for the language, for example [go](go).
1. Create the PowerShell scripts in this folder:
   - `install.ps1`, for example [go/install.ps1](go/install.ps1)
   - `build.ps1`, for example [go/build.ps1](go/build.ps1)
   - `test.ps1`, for example [go/test.ps1](go/test.ps1)