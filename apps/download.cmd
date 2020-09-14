pushd %~dp0
if not exist bin mkdir bin
powershell "(New-Object System.Net.WebClient).DownloadFile('https://shrirspublic.blob.core.windows.net/public/samples/java-samples.zip', './bin/java-samples.zip')"
powershell "Expand-Archive .\bin\java-samples.zip bin"
popd
