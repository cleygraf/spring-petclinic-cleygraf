# PetClinic and GitHub Actions

## 

## Requirements:

## Generic

A GitHub account is required.  In addition access to JFrog Artifactory is a must. To get started, JFrog SaaS is the best choice. Go here to start a trial: [Start a Trial With Artifactory and Xray | JFrog](https://jfrog.com/start-free/)

Please fork this repository first and create the secrets ( [Authentication](###Authentication) ) and the variables ( [Variables](###Variables )next.

### Authentication

The CI/CD pipeline needs to authenticate against the JFrog Platform in order to access JFrog Artifactory: [Setup JFrog CLI · Actions · GitHub Marketplace](https://github.com/marketplace/actions/setup-jfrog-cli)
You can use different ways to authenticate, in this case I have choosen to utilize a JFrog Access Token ( [ARTIFACTORY: Creating Access Tokens in Artifactory • ARTIFACTORY: Creating Access Tokens in Artifactory • Reader • JFrog Help Center](https://jfrog.com/help/r/how-to-generate-an-access-token-video/artifactory-creating-access-tokens-in-artifactory) ) . In this case you need to create these secrets in GitHub ( [Using secrets in GitHub Actions - GitHub Docs](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions) ):

    - JF_URL - JFrog platform url (for example: https://acme.jfrog.io)
    - JF_ACCESS_TOKEN - JFrog Platform access token

### Variables

To further configure the ci/cd pipeline, a set of GutHub repository variables ( [Variables - GitHub Docs](https://docs.github.com/en/actions/learn-github-actions/variables) ) needs to be populated:

    - MVN_DEV_REPO_DEPLOY_RELEASES
    - MVN_DEV_REPO_DEPLOY_SNAPSHOTS
    - MVN_DEV_REPO_RESOLVE_RELEASES
    - MVN_DEV_REPO_RESOLVE_SNAPSHOTS

These variables define, which repositories to use for resolving and deploying artifacts (for a snapshot or a releae build). 

