//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Masipack Eletronica on 26/02/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI
import CodeScanner
import UserNotifications

struct ProspectsView: View {
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    enum OrderType {
        case name, added
    }
    
    @EnvironmentObject var prospects: Prospects
    
    @State private var isShowingScanner = false
    @State private var isShowingOrderBy = false
    @State private var orderBy = OrderType.name
    
    let filter:FilterType
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    
    var filteredProspects: [Prospect] {
        let filteredList: [Prospect]
        switch filter {
        case .none:
            filteredList =  prospects.people
        case .contacted:
            filteredList = prospects.people.filter { $0.isContacted }
        case .uncontacted:
            filteredList =  prospects.people.filter { !$0.isContacted }
        }
        
        switch orderBy {
        case .name:
            return filteredList.sorted(by: { $0.name < $1.name })
        case .added:
            return filteredList.sorted(by: { $0.added > $1.added })
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProspects) { prospect in
                    HStack {
                        if self.filter == .none {
                            Image(systemName: prospect.isContacted ? "checkmark.circle" :
                                "questionmark.diamond")
                        }
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                        }
                    }
                    .contextMenu {
                        Button(prospect.isContacted ? "Mark Uncontacted" : "Mark Contacted") {
                            self.prospects.toggle(prospect)
                        }
                        if !prospect.isContacted {
                            Button("Remind Me") {
                                self.addNotification(for: prospect)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(title)
            .navigationBarItems(leading: Button(action: {
                self.isShowingOrderBy = true
            }) {
                Image(systemName: "arrow.up.arrow.down.square")
                Text("Order By")
                },trailing: Button(action: {
                    self.isShowingScanner = true
                }) {
                    Image(systemName: "qrcode.viewfinder")
                    Text("Scan")
            })
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr],
                                simulatedData: "Paul Hudson\npaul@hackingwithswift.com",
                                completion: self.handleScan)
            }
            .actionSheet(isPresented: $isShowingOrderBy) {
                ActionSheet(title: Text("Filter By: ..."), message: nil, buttons: [
                    .default(Text("Name"), action: { self.orderBy = .name }),
                    .default(Text("Added"), action: { self.orderBy = .added })
                ])
            }
        }
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        switch result {
        case .success(let code):
            let details = code.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            
            self.prospects.add(person)
        case .failure(let error):
            print("Scanning failed")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,
                                                        repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("D'oh")
                    }
                }
            }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}
