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

## Contributors

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/shimib"><img src="https://avatars0.githubusercontent.com/u/2115093?s=400&u=83fe53677b3bbabf095ac89911d7ccccbb756f65&v=4" width="100px;" alt=""/><br /><sub><b>Shimi Bandiel</b></sub></a><br /><a title="Answering Questions">💬</a> <a href="https://github.com/shimib/Horae/commits?author=shimib" title="Documentation">📖</a> <a title="Reviewed Pull Requests">👀</a> <a title="Talks">📢</a></td>

<td align="center"><a href="https://github.com/sauravthefrog"><img src="https://avatars1.githubusercontent.com/u/61025719?s=400&u=2ff91a2ea0b176d1bd10e0acc3c44c50e4a5bb24&v=4" width="100px;" alt=""/><br /><sub><b>Saurav Agrawal</b></sub></a><br /><a href="https://github.com/shimib/Horae/commits?author=sauravthefrog" title="Documentation">📖</a> <a title="Reviewed Pull Requests">👀</a> <a title="Tools">🔧</a></td>
  </tr>
 </table>
 <!-- markdownlint-enable -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->

See also the list of [contributors](https://github.com/shimib/Horae/blob/master/contributors.md) who participated in this project.

## License

This project is licensed under the - see the [LICENSE.md](LICENSE.md) file for details
