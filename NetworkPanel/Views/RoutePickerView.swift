import SwiftUI

struct RoutePickerView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss
    @State private var showingAdd = false
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
                                Text("\(route.threads) 线程 · \(route.normalizedURL)")
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
                                store.deleteRoute(route)
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
                    Button("添加") { showingAdd = true }
                }
            }
            .sheet(isPresented: $showingAdd) {
                RouteEditorView()
                    .environmentObject(store)
            }
            .sheet(item: $editingRoute) { route in
                RouteEditorView(route: route)
                    .environmentObject(store)
            }
        }
    }
}

struct RouteEditorView: View {
    @EnvironmentObject private var store: AppStore
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
                        if var route {
                            route.name = name
                            route.url = url
                            store.updateRoute(route)
                        } else {
                            store.addRoute(name: name, url: url)
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
