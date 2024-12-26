//
//  SearchView.swift
//  CombineWeather
//
//  Created by Dongik Song on 12/24/24.
//

import SwiftUI
import SwiftData
import Combine

struct SearchView: View {
    
    @State var searchText: String = ""
    
    private var searchSubject = CurrentValueSubject<String, Never>("")
    @EnvironmentObject private var networkViewModel: NetworkViewModel
    @State private var cancellables = Set<AnyCancellable>()
    
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Search Location")
                
                List(0..<10) { _ in
                    Text("Location")
                }
            }
        }
        .searchable(text: $searchText)
        .onAppear(perform: {
            bind()
        })
        .onChange(of: searchText) {
            searchSubject.send(searchText)
        }
    }
    
    private func bind() {
        searchSubject
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { text in
                networkViewModel.fetchWeather(city: text)
            }
            .store(in: &cancellables)
    }
}

//#Preview {
//    NavigationStack {
//        SearchView(networkViewModel: NetworkViewModel(networkManager: NetworkManager()))
//            .modelContainer(for: Item.self, inMemory: true)
//    }
//}
