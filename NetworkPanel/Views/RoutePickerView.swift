import SwiftUI
import UIKit

struct RoutePickerView: View {
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var runner: TrafficRunner
    @Environment(\.dismiss) private var dismiss
    @State private var showingAdd = false
    @State private var showingImport = false
    @State private var editingRoute: TrafficRoute?

    var body: some View {
        let theme = store.currentTheme
        NavigationStack {
            ZStack {
                LinearGradient(colors: [theme.backgroundTop.color, theme.backgroundBottom.color], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                List {
                    ForEach(store.routes) { route in
                        Button {
                            store.select(route: route)
                            runner.switchRoute(to: route, store: store)
                            dismiss()
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(route.displayName)
                                        .font(.system(size: 17, weight: .heavy))
                                    Spacer()
                                    if route.id == store.selectedRouteID {
                                        Text("当前")
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundStyle(theme.primary.color)
                                    }
                                }
                                Text(route.normalizedURL)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(theme.muted.color)
                                    .lineLimit(1)
                            }
                        }
                        .listRowBackground(theme.surface.color)
                        .swipeActions {
                            Button {
                                editingRoute = route
                            } label: {
                                Text("编辑")
                            }
                            .tint(theme.primary.color)
                            Button(role: .destructive) {
                                let deletingSelectedRoute = route.id == store.selectedRouteID
                                store.deleteRoute(route)
                                if deletingSelectedRoute {
                                    if let route = store.selectedRoute {
                                        runner.switchRoute(to: route, store: store)
                                    } else {
                                        runner.pause()
                                    }
                                }
                            } label: {
                                Text("删除")
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("选择线路")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("关闭") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 14) {
                        Button("导入") { showingImport = true }
                        Button("添加") { showingAdd = true }
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                RouteEditorView()
                    .environmentObject(store)
                    .environmentObject(runner)
            }
            .sheet(isPresented: $showingImport) {
                RouteImportView()
                    .environmentObject(store)
            }
            .sheet(item: $editingRoute) { route in
                RouteEditorView(route: route)
                    .environmentObject(store)
                    .environmentObject(runner)
            }
        }
    }
}

struct RouteImportView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss
    @State private var text = ""
    @State private var resultMessage = ""

    var body: some View {
        let theme = store.currentTheme
        NavigationStack {
            ZStack {
                LinearGradient(colors: [theme.backgroundTop.color, theme.backgroundBottom.color], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 14) {
                    Text("每行一个节点，支持“名称 链接”“名称,链接”“名称|链接”，也可以直接粘贴链接。")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(theme.muted.color)
                        .fixedSize(horizontal: false, vertical: true)

                    TextEditor(text: $text)
                        .font(.system(size: 15, weight: .semibold, design: .monospaced))
                        .foregroundStyle(theme.text.color)
                        .scrollContentBackground(.hidden)
                        .padding(12)
                        .frame(minHeight: 220)
                        .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(theme.surface.color).overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).stroke(theme.line.color)))
                        .overlay(alignment: .topLeading) {
                            if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                Text("移动云盘 https://example.com/file.zip")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(theme.muted.color.opacity(0.7))
                                    .padding(.top, 20)
                                    .padding(.leading, 18)
                                    .allowsHitTesting(false)
                            }
                        }

                    if !resultMessage.isEmpty {
                        Text(resultMessage)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(theme.primary.color)
                    }

                    Button {
                        text = UIPasteboard.general.string ?? ""
                    } label: {
                        Text("从剪贴板粘贴")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(ChipButtonStyle(theme: theme, minWidth: 0, minHeight: 46))

                    Spacer(minLength: 0)
                }
                .padding(20)
            }
            .navigationTitle("导入节点")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("导入") {
                        let result = store.importRoutes(from: text)
                        resultMessage = result.message
                        if result.imported > 0 {
                            dismiss()
                        }
                    }
                    .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .tint(theme.primary.color)
            .onAppear {
                if text.isEmpty, let clipboard = UIPasteboard.general.string {
                    text = clipboard
                }
            }
        }
    }
}

struct RouteEditorView: View {
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var runner: TrafficRunner
    @Environment(\.dismiss) private var dismiss
    let route: TrafficRoute?
    @State private var name = ""
    @State private var url = ""

    init(route: TrafficRoute? = nil) {
        self.route = route
        _name = State(initialValue: route?.name ?? "")
        _url = State(initialValue: route?.url ?? "")
    }

    var body: some View {
        let theme = store.currentTheme
        NavigationStack {
            Form {
                Section("线路") {
                    TextField("名称", text: $name)
                    TextField("下载链接", text: $url)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                }
            }
            .navigationTitle(route == nil ? "添加线路" : "编辑线路")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("保存") {
                        if let existingRoute = route {
                            var updatedRoute = existingRoute
                            updatedRoute.name = name
                            updatedRoute.url = url
                            store.updateRoute(updatedRoute)
                            if store.selectedRouteID == updatedRoute.id {
                                runner.switchRoute(to: updatedRoute, store: store)
                            }
                        } else {
                            let newRoute = store.addRoute(name: name, url: url)
                            runner.switchRoute(to: newRoute, store: store)
                        }
                        dismiss()
                    }
                    .disabled(url.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .tint(theme.primary.color)
        }
    }
}
