//
//  ContentView.swift
//  TCADemo
//
//  Created by Dan Tran on 18/12/2023.
//

import SwiftUI
import Products
import ComposableArchitecture

@Reducer
public struct ProfileDomain {
    public struct State: Equatable {
        public var firstName: String = ""
        public var lastName: String = ""
        public var email: String = ""
    }
    
    public enum Action: Equatable {
        case edit
    }
        
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .edit:
                return .none
            }
        }
    }
}

struct ProfileView: View {
    let store: Store<ProfileDomain.State, ProfileDomain.Action>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                ZStack {
                    Form {
                        Section {
                            Text(viewStore.firstName.capitalized)
                            +
                            Text(" \(viewStore.lastName.capitalized)")
                        } header: {
                            Text("Full name")
                        }
                        
                        Section {
                            Text(viewStore.email)
                        } header: {
                            Text("Email")
                        }
                    }
                }
                .navigationTitle("Profile")
            }
        }
    }
}

@Reducer
struct AppFeature {
    enum Tab {
        case productList
        case profile
    }
    
    struct State: Equatable {
        var tabSelected: Tab = .productList
        var productListSate = ProductListDomain.State()
        var profileSate = ProfileDomain.State()
    }
    
    enum Action {
        case selectTab(Tab)
        case productList(ProductListDomain.Action)
        case profile(ProfileDomain.Action)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .selectTab(let tab):
                state.tabSelected = tab
                return .none
            case .productList:
                return .none
            case .profile:
                return .none
            }
        }
        
        Scope(state: \.productListSate, action: \.productList) {
            ProductListDomain()
        }
        
        Scope(state: \.profileSate, action: \.profile) {
            ProfileDomain()
        }
    }
}

struct AppView: View {
    let store: Store<AppFeature.State, AppFeature.Action>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            TabView(
                selection: viewStore.binding(
                    get: \.tabSelected,
                    send: AppFeature.Action.selectTab
                )
            ) {
                ProductListView(
                    store: self.store.scope(
                        state: \.productListSate,
                        action: AppFeature.Action.productList
                    )
                )
                .tabItem {
                    Text("Products")
                }
                .tag(AppFeature.Tab.productList)
                
                ProfileView(
                    store: self.store.scope(
                        state: \.profileSate,
                        action: AppFeature.Action.profile
                    )
                )
                .tabItem {
                    Text("Profile")
                }
                .tag(AppFeature.Tab.profile)
            }
        }
    }
}

#Preview {
    AppView(
        store: Store(
        initialState: AppFeature.State()
        ) {
            AppFeature()
        }
    )
}
