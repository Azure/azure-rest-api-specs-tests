# Creating JSON-RPC server

The Azure SDK Live Test Framework uses JSON-RPC to call Azure SDK functions.

## 1. JSON-RPC

JSON-RPC for Swagger is based on

- [JSON-RPC 2.0 Specification](http://www.jsonrpc.org/specification) and
- [Visual Studio Code Language Server Protocol](https://github.com/Microsoft/language-server-protocol/blob/master/protocol.md#base-protocol).

## 2. Swagger JSON-RPC Mapping

### 2.1. Operation Mapping

|Swagger Title|Swagger Operation Id|JSON-RPC method|
|-------------|--------------------|---------------|
|`A`          |`B_C`               |`A.B_C`        |

### 2.2. Reserved Parameters

An additional parameter `__reserved` is added to each JSON-RPC call.

For example

```json
{
    "jsonrpc": "2.0",
    "method": "A.B_C",
    "id": "0",
    "params": {
        "__reserved": {
            "credentials": {
                "tenantId": "...",
                "clientId": "...",
                "secret": "..."
            }
        },
        "a": "Hello world!",
        "b": 42
    }
}
```

### 2.3. Result

The result structure should contain three fields
- **statusCode**
- **headers**
- **response**

For example

```json
{
    "jsonrpc": "2.0",
    "id": "0",
    "result": {
        "statusCode": 200,
        "headers": { },
        "response": "somevalue"
    }
}
```

## 3. Implementing Azure SDK Test Service

Eeach swagger operation may have several corresponded API functions. A service developer should decide which type of API functions should be implemented.
