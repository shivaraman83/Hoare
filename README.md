# Horae

Seeding information for JFrog Platform Deployment free trial

## Getting Started

Fork this project (shimib/Horae) along with https://github.com/jfrogtraining/project-examples

### Prerequisites

You will need to have a fresh instance of JFrog Artifactory whether it is commercial or a free trial
https://jfrog.com/platform/free-trial/


### Installing

#### Configure Integrations under "Pipelines"
#####  Artifactory
    Create a Pipelines integration of type Artifactory named "Artifactory" and provide the details for your Artifactory access (URL, admin user and password/apikey).

##### Github 
    Create a Pipelines integration of type GitHub named "Github" and provide connection details generated according to: https://www.jfrog.com/confluence/display/JFROG/GitHub+Integration

According to the instructios above, generate a Github Personal Access Token with the following permissions
* repo (all)
* admin:repo_hook (read, write)
* admin:public_key (read, write)
  
##### Distribution
###### Only for E+ subsription (not to perform on the free tier)
    Create a Pipelines integration of type Distribution named Distribution and provide connection details to your Distribution endpoint.
  
  
 > *Note that the integration names must match the source name in the yml configuration and is case-sensitive*
 
 https://www.jfrog.com/confluence/display/JFROG/Configuring+Pipelines#ConfiguringPipelines-add-integrationAddingAdministrationIntegrations
 
 
#### Configure Pipeline Sources
Fork the following two (2) repositories:
  
  * https://github.com/shimib/Horae
  * https://github.com/shimib/project-examples
  
Add your forked repository (forked from **shimib/Horae**) as a pipelines source
  

### Deployment

#### Run Pipelines
  1. Run the init pipeline 1st which should : create users, groups, perms, repositories, xray policy & watch, and update xray indexes
  2. Run the gradle_build pipeline
  3. Run the npm_build pipeline
  4. (The distribution pipeline should be triggered automatically)

## Contributing

Please read [CONTRIBUTING.md](https://github.com/shimib/Horae/blob/master/CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Authors

* **Shimi Bandiel**
* **Saurav Agrawal**

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the - see the [LICENSE.md](LICENSE.md) file for details
