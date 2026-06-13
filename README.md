# 网络面板 iOS

网络面板的 iPhone / iPad 原生 SwiftUI 版本，用于自签后在 iPhone、iPad 和 iPadOS 分屏环境中使用。

## 特点

- 中文界面
- 默认线路：移动云盘
- 支持多主题切换
- 支持 iPad 横屏与分屏
- 支持地区延迟检测
- 支持 GitHub Actions 生成 unsigned IPA

## 默认线路

- 名称：移动云盘
- 地址：https://yun.mcloud.139.com/hongseyunpan/2.43G.zip

## 发布

仓库通过 GitHub Actions 自动构建。
推送 `v*` 标签后，会在 Release 里生成 unsigned IPA。

## 说明

这是用于自签和侧载的构建，不包含 App Store 提交流程。
