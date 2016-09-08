# IPA Resign

##### 重签名步骤

```
// 1. 解压
unzip -q Example.ipa

// 2. 删除旧签名
rm -rf Payload/Example.app/_CodeSignature

// 3. Info.plist
/usr/libexec/PlistBuddy -c "Set CFBundleIdentifier ${NEW_BUNDLE_ID}" Playload/Example.app/Info.plist
/usr/libexec/PlistBuddy -c "Set CFBundleName ${NEW_APP_NAME}" Payload/Example.app/Info.pilst

// 如果需要还需copy 新的 embeded.mobileprovision
// 4. 强制重签名
// 因为证书有空格，所以证书那里必须用双引号括起来
codesign -f -s "${CERTIFICATE}" --identifier ${NEW_BUNDLE_ID} --entitlements ${ENTITLEMENTS} Playload/Example.app
// 查看签名是否正确
codesign -vv -d Payload/Example.app

// 5. 打包 ipa
zip -qr new.ipa Playload

// 清理
rm -rf Payload
```

> entitlements 可以改 entitlements.template

##### 涉及到的命令

```
// 查看本机证书
security find-identity -v -p codesigning

// 重签名
codesign -f -s ${CERTIFICATE_NAME} --identifier ${Bundle_ID} --entitlements Example.entitlements Payload/Example.app

// 查看签名
codesign -vv -d Example.app

// 验证签名
codesign --verify Example.ap

// 查看/修改 Plist
plutil -p Info.plist
PlistBuddy -c "Set CFBundleIdentifer ${BUNDLE_ID}" Info.plist

// 解压 / 压缩
unzip -q xxx.app
zip -qr xxx.ipa Payload
```

##### 备注

测试证书

```
Certificate: iPhone Developer: h s (5LW76GJTQE)
APP_ID_PREFIX: Q4JEMYK62P
```

entitlements 模板

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>application-identifier</key>
	<string>${APP_ID_PREFIX}.${BUNDLE_ID}</string>
	<key>com.apple.developer.team-identifier</key>
	<string>${APP_ID_PREFIX}</string>
	<key>get-task-allow</key>
	<true/>
</dict>
</plist>
```

参考：
[iOS批量自动打包和部署(Ⅱ):自动打包](http://www.vienta.me/2016/02/24/iOS%E6%89%B9%E9%87%8F%E8%87%AA%E5%8A%A8%E6%89%93%E5%8C%85%E5%92%8C%E9%83%A8%E7%BD%B2-%E2%85%A1-%E8%87%AA%E5%8A%A8%E6%89%93%E5%8C%85/)
[iOS批量自动打包和部署(Ⅲ):重新签名和自动部署](http://www.vienta.me/2016/02/25/iOS%E6%89%B9%E9%87%8F%E8%87%AA%E5%8A%A8%E6%89%93%E5%8C%85%E5%92%8C%E9%83%A8%E7%BD%B2-%E2%85%A2-%E9%87%8D%E6%96%B0%E7%AD%BE%E5%90%8D%E5%92%8C%E8%87%AA%E5%8A%A8%E9%83%A8%E7%BD%B2/)


