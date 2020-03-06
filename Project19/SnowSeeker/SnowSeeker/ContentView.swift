//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Masipack Eletronica on 05/03/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    enum sortTypes { case normal, alpha, country }
    enum filterTypes {
        case none
        case france, austria, italy, usa, canada
        case small, medium, large
        case price$, price$$, price$$$
    }
    @ObservedObject var favorites = Favorites()
    
    @State private var isShowingAlert = false
    @State private var isShowingSort = true
    @State private var sortType: sortTypes = .normal
    @State private var filterType:filterTypes = .none
    
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    var resortsList: [Resort] {
        let unsortedList:[Resort]
        
        switch filterType {
        case .none:
            unsortedList = resorts
        case .austria:
            unsortedList = resorts.filter({ $0.country == "Austria" })
        case .canada:
            unsortedList = resorts.filter({ $0.country == "Canada" })
        case .france:
            unsortedList = resorts.filter({ $0.country == "France" })
        case .italy:
            unsortedList = resorts.filter({ $0.country == "Italy" })
        case .usa:
            unsortedList = resorts.filter({ $0.country == "United States" })
        case .small:
            unsortedList = resorts.filter({ $0.size == 1 })
        case .medium:
            unsortedList = resorts.filter({ $0.size == 2 })
        case .large:
            unsortedList = resorts.filter({ $0.size == 3 })
        case .price$:
            unsortedList = resorts.filter({ $0.price == 1 })
        case .price$$:
            unsortedList = resorts.filter({ $0.price == 2 })
        case .price$$$:
            unsortedList = resorts.filter({ $0.price == 3 })
        }
        
        let list:[Resort]
        switch sortType {
        case .normal:
            list = unsortedList
        case .alpha:
            list = unsortedList.sorted(by: { $0.name < $1.name })
        case .country:
            list = unsortedList.sorted(by: { $0.country < $1.country })
        }
        
        return list
    }
    
    var body: some View {
        NavigationView {
            List(resortsList) { resort in
                NavigationLink(destination: ResortView(resort: resort)) {
                    Image(resort.country)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 25)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    VStack(alignment: .leading) {
                        Text(resort.name)
                            .font(.headline)
                        Text("\(resort.runs) runs")
                            .foregroundColor(.secondary)
                    }
                    .layoutPriority(1)
                    
                    if self.favorites.contains(resort) {
                        Spacer()
                        Image(systemName: "heart.fill")
                        .accessibility(label: Text("This is a favorite resort"))
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle("Resorts")
            .navigationBarItems(leading:
                Button(action: {
                    self.isShowingSort = true
                    self.isShowingAlert = true
                },label: {
                    Text("Sort")
                })
                , trailing:
                Button(action: {
                    self.isShowingSort = false
                    self.isShowingAlert = true
                }, label: {
                    Text("Filter")
                })
            )
                .actionSheet(isPresented: $isShowingAlert) {
                    if isShowingSort {
                        return ActionSheet(title: Text("Select sort order"),
                                           message: Text("Sort by ..."),
                                           buttons:
                            [.default(Text("Default"), action: { self.sortType = .normal }),
                             .default(Text("Alphabetical"), action: { self.sortType = .alpha }),
                             .default(Text("Country"), action: { self.sortType = .country })])
                    } else {
                        return ActionSheet(title: Text("Select filter"),
                                           message: Text("Filter by ..."),
                                           buttons:
                            [.default(Text("None"), action:  { self.filterType = .none }),
                             .default(Text("Country: Austria"), action: { self.filterType = .austria }),
                             .default(Text("Country: Canada"), action: { self.filterType = .canada }),
                             .default(Text("Country: France"), action: { self.filterType = .france }),
                             .default(Text("Country: Italy"), action: { self.filterType = .italy }),
                             .default(Text("Country: USA"), action: { self.filterType = .usa }),
                             .default(Text("Size: Small"), action: { self.filterType = .small }),
                             .default(Text("Size: Medium"), action: { self.filterType = .medium }),
                             .default(Text("Size: Large"), action: { self.filterType = .large }),
                             .default(Text("Price: $"), action: { self.filterType = .price$ }),
                             .default(Text("Price: $$"), action: { self.filterType = .price$$ }),
                             .default(Text("Price: $$$"), action: { self.filterType = .price$$$ })])
                    }
            }
            
            WelcomeView()
        }
        .environmentObject(favorites)
        //.phoneOnlyStackNavigationView()
    }
}

extension View {
    func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
