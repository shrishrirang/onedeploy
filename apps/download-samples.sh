# Get the script location and cd to it. This is needed because the script is invoked from a different working directory by the pipeline.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $DIR

mkdir -p bin
curl 'https://shrirspublic.blob.core.windows.net/public/samples/java-samples.zip' --output ./bin/java-samples.zip
unzip ./bin/java-samples.zip -d bin

popd
