# Hoare

Setup an end to end example project for JFrog Platform Deployment leveraging the JFrog free trial.

## Getting Started

### Prerequisites

You will need to have a fresh instance of JFrog Platform whether it is commercial or a [free trial](https://jfrog.com/platform/free-trial/)


### Installing

#### 1.0 Configure Integrations under "Pipelines"
You'll need to create 3 Pipelines integrations - [see documentation](https://www.jfrog.com/confluence/display/JFROG/Configuring+Pipelines#ConfiguringPipelines-add-integrationAddingAdministrationIntegrations) in order to setup JFrog Pipelines to work with your Artifactory & Distribution services, as well as pull the Pipelines sample code from GitHub. 

##### 1.1 Github 
   1.1.1 In order to create a GitHub integration, you need the generate a GitHub Personal Access token first.
   As also stated in the documentation instructions below, generate a Github Personal Access Token with the 
   following permissions:
    
    * repo (all)
    * admin:repo_hook (read, write)
    * admin:public_key (read, write)
   
   An example token would look like that  `2f3ed30dec7537a56064436cbedacc00813d247d`
    
   1.1.2 Create a Pipelines integration of type GitHub named "**GitHub**" and provide connection details generated according to the [documentation](https://www.jfrog.com/confluence/display/JFROG/GitHub+Integration).

  
#####  1.2 Artifactory
   In order to create an Artifactory integration, we recommend that you'll generate an API Key following these [instructions]( https://www.jfrog.com/confluence/display/JFROG/User+Profile#UserProfile-APIKey]).
   
   Create a Pipelines integration of type Artifactory named "**Artifactory**" and provide the details for your Artifactory access (URL, admin user and password/apikey).
   
   As an example:
    
    URL - https://myserver.domain.com/artifactory
    Admin user - myname@domain.com
    Password/APIKey - AKCp8hyPw7CP3GuGCxqThixEJCjjuY26v1BotRtVctcdcgudsn7JDMBvHBYfDCMyGD6Htu65Y'

##### 1.3 Distribution
###### Only for Enterprise+ subsription (not to perform on the free tier)
   Create a Pipelines integration of type Distribution named "**Distribution**" and provide connection details to your Distribution endpoint.
    
   As an example:
   
    URL - https://myserver.domain.com/distribution
    Admin user - myname@domain.com
    Password/APIKey - AKCp8hyPw7CP3GuGCxqThixEJCjjuY26v1BotRtVctcdcgudsn7JDMBvHBYfDCMyGD6Htu65Y
  
 > **Note that the integration names must match the source name in the yaml configuration and are case-sensitive**

 
#### 2.0 Configure Pipeline Sources
2.1 Fork the following two (2) repositories:
  
  * https://github.com/shimib/Hoare
  * https://github.com/shimib/project-examples (Make sure you fork the following branch: eplus-v2-orbitera or simply "all branches")
  
2.2 Next we'll need to modify some of the configuration in the forked code:

2.2.1 Go to Hoare/pipelines/base_init.yml and modify the following values based on your github path.

> Hoare/pipelines/base_init.yml:  
```
resources:  
  - name: demo_gitRepo  
    type: GitRepo  
    configuration:  
      path: [your_Github_username]/Hoare  <<<--- CHANGE HERE
      gitProvider: GitHub  
  - name: gitRepo_code  
    type: GitRepo  
    configuration:  
      path: [your_Github_username]/project-examples  <<<--- CHANGE HERE 
      gitProvider: GitHub  CHANGE 
      branches:  
        include: eplus-v2-orbitera  
```     
2.3 Add your forked repository (forked from **shimib/Hoare**) as a pipelines source.
You can follow the instructions [here](https://www.jfrog.com/confluence/display/JFROG/Managing+Pipeline+Sources#ManagingPipelineSources-AddingaPipelineSource(SingleBranch)) on how to add a **"Single-branch"** source

> Note: 
    
    > Enterprise+ Trial: Use -- 
        Pipeline Config File Filter : pipelines/.*\.yml
    
    > Free tier: Use --
        Pipeline Config File Filter: pipelines/base_.*yml
  

### 3.0 Deployment

You're all set now, and ready to initialize your environment and run your first Pipelines!

#### 4.0 Run Pipelines

  4.1. Run the init pipeline 1st which should: Create users, groups, permissions, repositories, Xray policies & watches, update Xray indexes and setup Access Federation.
  
  4.2. Run the gradle_build pipeline
  
  4.3. Run the npm_build pipeline
  
  4.4. (The distribution pipeline should be triggered automatically)

## Contributing

Please read [CONTRIBUTING.md](https://github.com/shimib/Hoare/blob/master/CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Contributors

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/shimib"><img src="https://avatars0.githubusercontent.com/u/2115093?s=400&u=83fe53677b3bbabf095ac89911d7ccccbb756f65&v=4" width="100px;" alt=""/><br /><sub><b>Shimi Bandiel</b></sub></a><br /><a title="Answering Questions">💬</a> <a href="https://github.com/shimib/Hoare/commits?author=shimib" title="Documentation">📖</a> <a title="Reviewed Pull Requests">👀</a> <a title="Talks">📢</a></td>

<td align="center"><a href="https://github.com/sauravthefrog"><img src="https://avatars1.githubusercontent.com/u/61025719?s=400&u=2ff91a2ea0b176d1bd10e0acc3c44c50e4a5bb24&v=4" width="100px;" alt=""/><br /><sub><b>Saurav Agrawal</b></sub></a><br /><a href="https://github.com/shimib/Hoare/commits?author=sauravthefrog" title="Documentation">📖</a> <a title="Reviewed Pull Requests">👀</a> <a title="Tools">🔧</a></td>

<td align="center"><a href="https://github.com/ronenl"><img src="https://avatars2.githubusercontent.com/u/7105951?s=400&v=4" width="100px;" alt=""/><br /><sub><b>Ronen Lewit</b></sub></a><br /><a href="https://github.com/shimib/Hoare/commits?author=ronenl10" title="Documentation">📖</a> <a title="Reviewed Pull Requests">👀</a> <a title="Tools">🔧</a></td>
  </tr>
 </table>
 <!-- markdownlint-enable -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->

See also the list of [contributors](https://github.com/shimib/Hoare/blob/master/contributors.md) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](https://github.com/shimib/Hoare/blob/master/LICENSE.md) file for details
