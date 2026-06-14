# 发布指南

这个仓库会通过 GitHub Actions 自动生成未签名 IPA。
生成的 IPA 适合自签或侧载使用。

## 未签名 IPA

推送版本标签：

```powershell
git tag v0.1.13
git push origin main
git push origin v0.1.13
```

Actions 会上传：

```text
network-panel-ios-v0.1.13-unsigned.ipa
```

## 后续自动签名

如果后续想在 Actions 里自动签名，需要把 Apple 签名材料加入 GitHub Secrets，并扩展工作流：

- Apple 证书 `.p12`
- 证书密码
- provisioning profile
- bundle identifier 映射

当前仓库不会包含任何私人签名材料。
