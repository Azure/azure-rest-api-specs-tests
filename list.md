# A List of Services

## Build Passed

- **arm-insights**
    - [Live Test](https://devdiv.visualstudio.com/NodeRepos/_build/index?buildId=800424&_a=summary&tab=ms.vss-test-web.test-result-details)
    - [Go](https://devdiv.visualstudio.com/NodeRepos/_build/index?buildId=800434&_a=summary&tab=ms.vss-test-web.test-result-details)
- **arm-monitor**
    - [Live Test](https://devdiv.visualstudio.com/NodeRepos/_build/index?buildId=800721&_a=summary)
- **arm-servicebus**
- **arm-servicefabric**
- **arm-trafficmanager**

### Build Passed But Live Test Failed

- **arm-analysisservices**
    - [Live Test](https://devdiv.visualstudio.com/NodeRepos/_build/index?buildId=799962&_a=summary&tab=ms.vss-test-web.test-result-details).
- **arm-authorization**
    - [Live Test](https://devdiv.visualstudio.com/NodeRepos/_build/index?buildId=799982&_a=summary&tab=ms.vss-test-web.test-result-details)
- **arm-automation**
    - [Live Test](https://devdiv.visualstudio.com/NodeRepos/_build/index?buildId=800000&_a=summary&tab=ms.vss-test-web.test-result-details).
- **arm-billing**
    - [Live Test](https://devdiv.visualstudio.com/NodeRepos/_build/index?buildId=800014&_a=summary&tab=ms.vss-test-web.test-result-details).
- **arm-cognitiveservices**
    - [Live Test](https://devdiv.visualstudio.com/NodeRepos/_build/index?buildId=800033&_a=summary&tab=ms.vss-test-web.test-result-details).
- **arm-consumption**
    - [Live Test](https://devdiv.visualstudio.com/NodeRepos/_build/index?buildId=800138&_a=summary&tab=ms.vss-test-web.test-result-details).
- **arm-customer-insights**
    - [Live Test](https://devdiv.visualstudio.com/NodeRepos/_build/index?buildId=800160&_a=summary&tab=ms.vss-test-web.test-result-details)
- **arm-datalake-analytics/account**
- **arm-datalake-analytics/job**
- **arm-datalake-analytics/catalog**
    - [Live Test](https://devdiv.visualstudio.com/NodeRepos/_build/index?buildId=800186&_a=summary&tab=ms.vss-test-web.test-result-details)
- **arm-datalake-store/account**
- **arm-datalake-store/filesystem**
    - [Live Test](https://devdiv.visualstudio.com/NodeRepos/_build/index?buildId=800295&_a=summary&tab=ms.vss-test-web.test-result-details)
- **arm-devtestlabs**
    - [Live Test](https://devdiv.visualstudio.com/NodeRepos/_build/index?buildId=800377&_a=summary&tab=ms.vss-test-web.test-result-details)
- **arm-eventhub**
    - [Live Test](https://devdiv.visualstudio.com/NodeRepos/_build/index?buildId=800392&_a=summary&tab=ms.vss-test-web.test-result-details)
- **arm-graphrbac**
    - [Live Test](https://devdiv.visualstudio.com/NodeRepos/_build/index?buildId=800410&_a=summary&tab=ms.vss-test-web.test-result-details)
- **arm-iothub**
    - [Live Test](https://devdiv.visualstudio.com/NodeRepos/_build/index?buildId=800579&_a=summary&tab=ms.vss-test-web.test-result-details)
- **arm-keyvault**
    - [Live Test](https://devdiv.visualstudio.com/NodeRepos/_build/index?buildId=800583&_a=summary&tab=ms.vss-test-web.test-result-details)
- **arm-logic**
    - [Live Test](https://devdiv.visualstudio.com/NodeRepos/_build/index?buildId=800620&_a=summary&tab=ms.vss-test-web.test-result-details)
- **arm-machinelearning/2017-01-01/swagger/webservices.json**
- **arm-machinelearning/2016-05-01-preview/swagger/commitmentPlans.json**
    - [Live Test](https://devdiv.visualstudio.com/NodeRepos/_build/index?buildId=800629&_a=summary&tab=ms.vss-test-web.test-result-details)
- **arm-network**
    - [Live Test (8.2 h!)](https://devdiv.visualstudio.com/NodeRepos/_build/index?buildId=800727&_a=summary)
- **arm-notificationhubs**
    - [Live Test](https://devdiv.visualstudio.com/NodeRepos/_build/index?buildId=801454&_a=summary)
- **arm-powerbiembedded**
    - [Live Tests](https://devdiv.visualstudio.com/NodeRepos/_build/index?buildId=801466&_a=summary)
- **arm-recoveryservices**
    - [Live Test](https://devdiv.visualstudio.com/NodeRepos/_build/index?buildId=801492&_a=summary)
- **arm-recoveryservicesbackup**
    - [Live Test](https://devdiv.visualstudio.com/NodeRepos/_build/index?buildId=801496&_a=summary)
- **arm-relay**
    - [Live Test](https://devdiv.visualstudio.com/NodeRepos/_build/index?buildId=801664&_a=summary)
- **arm-resources/resources**
- **arm-resources/locks**
- **arm-resources/features**
- **arm-resources/subscriptions**
- **arm-resources/policy**
- **arm-resources/links**
    - [Live Test](https://devdiv.visualstudio.com/NodeRepos/_build/index?buildId=801895&_a=summary)
- **arm-scheduler**
    - [Live Test](https://devdiv.visualstudio.com/NodeRepos/_build/index?buildId=801976&_a=summary)
- **arm-search**
    - [Live Test](https://devdiv.visualstudio.com/NodeRepos/_build/index?buildId=802076&_a=summary)
- **arm-servermanagement**
    - [Live Test](https://devdiv.visualstudio.com/NodeRepos/_build/index?buildId=802235&_a=summary)

### Build Passed But With Specific Version Of AutoRest

For these services, we can't use a JSON-RPC client without modifications in .Net tests.

- **arm-batch**
- **arm-compute**
- **arm-containerregistry**
- **arm-redis**
- **arm-storage**

## Build Errors

- **arm-operationalinsights**
    - a commit is a2afb19c0d17535c1d0c3ebf05258e25375fc5a3
    - a specific version of AutoRest
- **arm-cdn**
    - a commit id is unknown
    - a specific AutoRest version
- **arm-mediaservices**
    - a commit id is unknown
    - a specific AutoRest version
- **arm-sql**
    - a commit is b1c64e75e3e0e3e9c3546d4466c7ebd0d5948cfe
    - AutoRest version is unknown
- **arm-web**
    - a commit id is unknown
    - a specific AutoRest version
- **arm-intune**
    - a project file is broken