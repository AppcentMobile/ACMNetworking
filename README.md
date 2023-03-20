# ACMNetworking

ACMNetworking is package help developers to make requests easily.

## Install

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
network.request(to: endpoint) { (r: BaseResult<ProductResponse?, Error>) in
            switch r {
            case let .success(r):
                guard let response = r else {
                    return
                }
                print(response)
            case let .failure(error):
                print(error)
            }
        }
```

## Example Project

https://github.com/kilitbilgi/BANetworkSample

## License

 * MIT license ([LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT)

