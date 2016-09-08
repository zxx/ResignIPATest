#!/bin/bash

CERTIFICATE_NAME="iPhone Developer: h s (5LW76GJTQE)"
ENTITIMENTS=entitlements.template
BUNDLE_ID=com.uunnii.lalala
IPA_FILE=autobuildtest.ipa
APP_NAME=AutoBuildTest

echo ${CFBundleIdentifier}
echo ${ENTITIMENTS}
echo ${BUNDLE_ID}
echo ${IPA_FILE}
echo ${APP_NAME}

if [[ -e Payload ]]; then
    rm -rf Payload
fi

if [[ -f resigned.ipa ]]; then 
    rm -rf resigned.ipa
fi

if [[ ! -f ${ENTITIMENTS} ]];then
    echo "Missing entitlements file"
fi

if [[ ! -f ${IPA_FILE} ]]; then
    echo "ipa file not found"
fi

# 1. unzip
unzip -q ${IPA_FILE}

# 2. Remote _CodeSignature
rm -rf Payload/${APP_NAME}.app/_CodeSignature

ls Payload/${APP_NAME}.app/

# 3. Change 
/usr/libexec/PlistBuddy -c "Set CFBundleIdentifier ${BUNDLE_ID}" Payload/${APP_NAME}.app/Info.plist
/usr/libexec/PlistBuddy -c "Set CFBundleName ResignedApp" Payload/${APP_NAME}.app/Info.plist

#plutil -p Payload/${APP_NAME}.app/Info.plist

# Resign
# 注意 "${CERTIFICATE_NAME}" 一定要带着 "" 号，可能因为有空格。不带定位不了证书
echo "codesign -f -s ${CERTIFICATE_NAME} --identifier ${BUNDLE_ID} --entitlements ${ENTITIMENTS} Payload/${APP_NAME}.app"
codesign -f -s "${CERTIFICATE_NAME}" --identifier ${BUNDLE_ID} --entitlements ${ENTITIMENTS} Payload/${APP_NAME}.app

codesign -vv -d Payload/${APP_NAME}.app

# zip
zip -qr resigned.ipa Payload

# Cleanup 
rm -rf Payload
