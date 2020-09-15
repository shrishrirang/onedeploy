# Instructions for deploying to Windows

- Obtain the Windows site's publishing credentials
- Define the `sitename`, `username` and `password` environment variables in a Windows command-prompt
```cmd
    set sitename=<name of site>
    set username=<username>
    set password=<password>
```
Example:
```cmd
    set username=$my-testsite1
    set password=my-testsite1-password
    set sitename=my-testsite1
```
- Now, run the following script to update your site to use custom Kudu bits
```cmd
    deploy.cmd
```
- Done! Your site will now be running with the custom Kudu bits we just deployed in the above steps.
