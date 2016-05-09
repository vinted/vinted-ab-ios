What is Vinted-AB?
-------------------
If you didn't guess it from the name, this library is meant for ab testing. But it doesn't cover everything associated with it, it lacks configuration and management parts. The library is only used to determine which variant should be applied for a user. Two inputs are expected - [configuration](#configuration) and identifier. Identifier, at least in Vinted's case, represents users, but other scenarios are certainly possible.

Each identifier is assigned to a bucket, using a hashing function. Buckets can then be assigned to tests. That allows isolation control, when we don't want clashing and creation of biases. Each test also has a seed, which is used to randomise how identifiers are divided among test variants.

![users](https://cloud.githubusercontent.com/assets/54526/2971326/0535267a-db69-11e3-9878-e2b6a5d5505d.png)

This pod implements the logic in Objective-C and is designed to be used in iOS projects.

Running tests
-------------------
The project in this repository should be setup using Pods. So in order to run tests you need to do a few things:
- Checkout the repository
- Navigate to the directory of the repo
- Run ```pod install``` (*important:* make sure you have cocoapods installed)
- Open *vinted-ab.xcworkspace*
- Inspect examples, source code and run tests via CMD+U

Usage
-------------------
TBA
