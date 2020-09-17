# Horae

Seeding information for JFrog Platform Deployment free trial

## Getting Started

Fork this project (shimib/Horae) along with https://github.com/jfrogtraining/project-examples

### Prerequisites

You will need to have a fresh instance of JFrog Artifactory whether it is commercial or a free trial
https://jfrog.com/platform/free-trial/


### Installing

#### Configure Integrations under "Pipelines"
  Artifactory
  Distribution
  Github
  
 *Note that the integration names must match the source name in the yml configuration and is case-sensitive*
 
 
#### Configure Pipeline Sources
  Add your forked repository (forked from shimib/Horae) as a pipelines source
  
#### Configure Distribution
  You will need to add a GPG signing key. Please follow the instructions here [https://www.jfrog.com/confluence/display/JFROG/GPG+Signing] in order to generate your
  GPG singing key pair. *Note: Passphrase should be left empty when creating this key pair.*
  You can use the following REST API in order to upload your GPG signing key and propagate it to your edge node : [https://www.jfrog.com/confluence/display/JFROG/Distribution+REST+API#DistributionRESTAPI-UploadandPropagateGPGSigningKeysforDistribution]
 

### Deployment

#### Run Pipelines
  1. Run the init pipeline 1st which should : create users, groups, perms, repositories, xray policy & watch, and update xray indexes
  2. Run the gradle_build pipeline
  3. Run the npm_build pipeline
  4. (The distribution pipeline should be triggered automatically)

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Authors

* **Shimi Bandiel**

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
