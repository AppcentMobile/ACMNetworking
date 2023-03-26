# ACMNetworking

ACMNetworking is a network library that help developers to make requests easily.

## Install

Via Cocoapods
```bash
pod 'ACMNetworking'
```

Via SPM, add new package, search url below
```bash
https://github.com/AppcentMobile/ACMNetworking
```

## Basic Usage

- Create plist file called ACMConfig
- Add these keys
```bash
baseURL (String)(without http(s))
isLogEnabled (Bool)
timeout (Number)
```
- Build a request via builder
```bash
let endpoint = ACMEndpoint()
            .set(method: .get)
            .set(path: BAPathModel(path: "products", value: id))
            .add(header: BAHeaderModel(field: "fieldOne", value: "valueOne"))
            .add(header: BAHeaderModel(field: "fieldTwo", value: "valueTwo"))
            .add(queryItem: BAQueryModel(name: "nameOne", value: "valueOne"))
            .add(queryItem: BAQueryModel(name: "nameTwo", value: "valueTwo"))
            .build()
```

- Make request!
```bash
network.request(to: endpoint) { (response: ProductResponse) in
                print(response)
            } onError: { error in
                print(error)
            }
```

## Example Project

https://github.com/AppcentMobile/ACMNetworkingSample

## Documentation

https://acmnetworking-fbacf.web.app

## License

 * Apache License 2.0 ([LICENCE-Apache-2.0](LICENCE) or https://opensource.org/license/apache-2-0/)

