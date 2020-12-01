# General API description

API is hosted in the Kudu website at `POST /api/publish`.

Query parameters:
- `type=<war|jar|ear|lib|startup|static|zip>`
    - Required parameter
    - `type=war` will deploy the war file to `/home/site/wwwroot/app.war` if `path` is _not_ specified
    - `type=war&path=webapps/<appname\` will behave exactly like wardeploy by unzipping app to /home/site/wwwroot/webapps/\<appname\>
    - `type=jar` will deploy the war file to `/home/site/wwwroot/app.jar`. `path` parameter will be ignored
    - `type=ear` will deploy the war file to `/home/site/wwwroot/app.ear`. `path` parameter will be ignored
    - `type=lib` will deploy the jar to /home/site/libs. `path` parameter must be specified
    - `type=static` will deploy the script to `/home/site/scripts`. `path` parameter must specified
    - `type=startup` will deploy the script as `startup.sh` (Linux) or `startup.cmd` (Windows) to `/home/site/scripts/`. `path` parameter will be ignored
    - `type=zip` will unzip the zip to `/home/site/wwwroot`. `path` parameter is optional.
- `path=<path>` (Required or Optional, depending on the type parameter)
    - This can be either a relative path or an absolute path
        - The relative path will be interpreted relative to the default root directory for the artifact `type` being deployed. Example: For `type=script`, relative path `helper.sh` will deploy to `/home/site/scripts/helper.sh`
        - The absolute path must match the default root directory for the artifact `type` being deployed. Example: For `type=script`, absolute path `/home/site/scripts/helper.sh` is valid, but `/home/site/scripts2/helper.sh` is invalid.
- `ignorestack=<true|false>` (Optional. However, required until November)
    - OneDeploy looks for `WEBSITE_STACK` environment variable that is injected by the platform to make sure that you are deploying war to a Tomcat app, jar to a Java SE app and so on. However, this environment variable is not being injected by the platform yet and will be available in November. Until then `ignorestack=true` can be used. This can also be used later for deploying to HttpPlatformHandler sites (Windows) or custom container sites (Linux) where the stack is controlled by the app developer
- `restart=<true|false>` (Optional)
    - By default, any OneDeploy call will restart the site. This behavior can be altered using `restart=false`
- `clean=<true|false>` (Optional)
    - By default `type=zip` and `type=war&path=webapps/<appname>` performs clean deployment. All other types of artifacts will be deployed incrementally. The default behavior for any artifact type can be changed using the `clean` parameter. A clean deployment nukes the default directory associated with the type of artifact being deployed.
- Default root directory for various artifact types are as follows

# Setup

Instructions assume you are running the scripts from *__bash__* in *__Linux__* or *__WSL in Windows__*.

Before proceeding any further, define the `$cred` environment variable by running the following script. To run the script, edit the placeholder values for `sitename`, `username` and `password`. [This](https://github.com/projectkudu/kudu/wiki/Deployment-credentials) wiki page explains how you can get the [credentials for your web app](https://github.com/projectkudu/kudu/wiki/Deployment-credentials).

```bash
# *** BEGIN *** Customizations
sitename='site1' # if you site is site1.azurewebsites.net
username='yourusername' # Example: username='$site1' (NOT 'site1\$site1', NOT 'site1\site1'. Also, note the single quotes.)
password='yourpassword'
# *** END *** Customizations

# Note that no quotes should be used here
cred=$username:$password
```

# Usage

Refer below usage instructions for deploying various artifact types.

# Basic deployment scenarios

## Deploy war (Tomcat)

```bash
curl -X POST -u $cred "https://$sitename.scm.azurewebsites.net/api/publish?type=war&ignorestack=true" --data-binary @'../apps/bin/tiny-testapp.war'
```

## Deploy war in the deprecated legacy mode, i.e. wardeploy   (Tomcat)

```bash
curl -X POST -u $cred "https://$sitename.scm.azurewebsites.net/api/publish?type=war&path=webapps/ROOT&ignorestack=true" --data-binary @'../apps/bin/tiny-testapp.war'
```

## Deploy jar (Java SE)

```bash
curl -X POST -u $cred "https://$sitename.scm.azurewebsites.net/api/publish?type=jar&ignorestack=true" --data-binary @'../apps/bin/petclinic-use-java8.jar'
```

## Deploy ear (not available yet)

```bash
curl -X POST -u $cred "https://$sitename.scm.azurewebsites.net/api/publish?type=ear&ignorestack=true" --data-binary @'../apps/bin/petclinic-use-java8.jar'
```

## Deploy lib

```bash
curl -X POST -u $cred "https://$sitename.scm.azurewebsites.net/api/publish?type=lib&ignorestack=true&path=mydriver.jar" --data-binary @'../apps/bin/postgresql-driver.jar'
```
## Deploy static

```bash
curl -X POST -u $cred "https://$sitename.scm.azurewebsites.net/api/publish?type=static&ignorestack=true&path=mytest.txt" --data-binary @'../apps/bin/test.txt'
```
## Deploy startup

```bash
curl -X POST -u $cred "https://$sitename.scm.azurewebsites.net/api/publish?type=startup&ignorestack=true" --data-binary @'../apps/bin/startup.cmd'
```

## Deploy script

```bash
curl -X POST -u $cred "https://$sitename.scm.azurewebsites.net/api/publish?type=script&ignorestack=true&path=helper.cmd" --data-binary @'../apps/bin/helper.cmd'
```
## Deploy zip

```bash
curl -X POST -u $cred "https://$sitename.scm.azurewebsites.net/api/publish?type=zip&ignorestack=true" --data-binary @'../apps/bin/ziptest.zip'
```

# Advanced scenarios

## Deploy to a custom path

```bash
curl -X POST -u $cred "https://$sitename.scm.azurewebsites.net/api/publish?type=script&ignorestack=true&path=subdir/helper.cmd" --data-binary @'../apps/bin/helper.cmd'
```

This will deploy helper.cmd to the /home/site/scripts/subdir location.

## Override default clean behavior

```bash
# Force an incremental zip deployment
curl -X POST -u $cred "https://$sitename.scm.azurewebsites.net/api/publish?type=zip&ignorestack=true&clean=false" --data-binary @'../apps/bin/ziptest.zip'
```

```bash
# Force a clean startup script deployment
curl -X POST -u $cred "https://$sitename.scm.azurewebsites.net/api/publish?type=startup&ignorestack=true&clean=true" --data-binary @'../apps/bin/startup.cmd'
```

## Override default restart behavior

```bash
curl -X POST -u $cred "https://$sitename.scm.azurewebsites.net/api/publish?type=startup&ignorestack=true&restart=false" --data-binary @'../apps/bin/startup.cmd'
```
