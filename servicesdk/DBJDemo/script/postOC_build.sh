#!/usr/bin/env bash
set -e

BASE_PWD="$PWD"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
OUTPUT_DIR=$( mktemp -d )
COMMON_SETUP="-project ${SCRIPT_DIR}/../DBJDemo.xcodeproj -scheme DBJOCKit -configuration Release -quiet SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES"

# iOS
DERIVED_DATA_PATH=$( mktemp -d )
xcrun xcodebuild build \
    $COMMON_SETUP \
    -derivedDataPath "${DERIVED_DATA_PATH}" \
    -destination 'generic/platform=iOS'

mkdir -p "${OUTPUT_DIR}/iphoneos"
ditto "${DERIVED_DATA_PATH}/Build/Products/Release-iphoneos/DBJOCKit.framework" "${OUTPUT_DIR}/iphoneos/DBJOCKit.framework"
rm -rf "${DERIVED_DATA_PATH}"

# iOS Simulator
DERIVED_DATA_PATH=$( mktemp -d )
xcrun xcodebuild build \
    $COMMON_SETUP \
    -derivedDataPath "${DERIVED_DATA_PATH}" \
    -destination 'generic/platform=iOS Simulator'

mkdir -p "${OUTPUT_DIR}/iphonesimulator"
ditto "${DERIVED_DATA_PATH}/Build/Products/Release-iphonesimulator/DBJOCKit.framework" "${OUTPUT_DIR}/iphonesimulator/DBJOCKit.framework"
rm -rf "${DERIVED_DATA_PATH}"


# XCFRAMEWORK
rm -rf ${SCRIPT_DIR}/../DBJOCKit.xcframework
xcrun xcodebuild -quiet -create-xcframework \
    -framework "${OUTPUT_DIR}/iphoneos/DBJOCKit.framework" \
    -framework "${OUTPUT_DIR}/iphonesimulator/DBJOCKit.framework" \
    -output ${SCRIPT_DIR}/../DBJOCKit.xcframework

# pushd ${OUTPUT_DIR}
# popd

echo "✔️ DBJOCKit.xcframework"
echo ${OUTPUT_DIR}

rm -rf ${OUTPUT_DIR}
cd ${BASE_PWD}
