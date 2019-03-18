# Update assets/swlegion (https://github.com/hquplink/swlegion-assets/).
# NOTE: Always execute this from the root of the package (hquplink/).
#
# https://stackoverflow.com/questions/4632028/how-to-create-a-temporary-directory

# Directory of the script.
CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ASSETS_PATH="$PWD/assets"
WORKING_PATH=`mktemp -d -t "update-assets.sh"`

if [[ ! "$WORKING_PATH" || ! -d "$WORKING_PATH" ]]; then
  echo "Could not create temporary directory!"
  exit 1
fi

# Deletes the temp directory.
function cleanup {      
  rm -rf "$WORKING_PATH"
  echo "Deleted temp working directory $WORKING_PATH"
}

# Register the cleanup function to be called on the EXIT signal.
trap cleanup EXIT

# Execute git clone, copy assets, exit.
pushd $WORKING_PATH
echo "Working in $WORKING_PATH..."

# TODO: Add ability to pin the SHA.
git clone https://github.com/hquplink/swlegion-assets/
echo "Copying cards to $ASSETS_PATH..."
cp -r swlegion-assets/cards $ASSETS_PATH
echo "Copying dice to $ASSETS_PATH..."
cp -r swlegion-assets/dice $ASSETS_PATH
echo "Copying faction to $ASSETS_PATH..."
cp -r swlegion-assets/faction $ASSETS_PATH
echo "Done!"
popd
exit 0
