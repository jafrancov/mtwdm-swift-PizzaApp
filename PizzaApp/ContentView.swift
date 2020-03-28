//
//  ContentView.swift
//  PizzaApp
//
//  Created by Alejandro Franco on 28/03/20.
//  Copyright © 2020 Alejandro Franco. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var showOrderSheet = false
    
    @FetchRequest(
        entity: Order.entity(),
        sortDescriptors: [
            NSSortDescriptor(key: "tableNumber", ascending: true)
        ],
        predicate: NSPredicate(format: "status != %@", Status.completed.rawValue)
    ) var orders : FetchedResults<Order>
    
    var body: some View {
        NavigationView  {
            List {
                ForEach(orders) { order in
                    HStack {
                        VStack(alignment:.leading){
                            Text("\(order.pizzaType) - \(order.numberOfSlices) slices")
                                .font(.headline)
                            Text("Table \(order.tableNumber)")
                                .font(.subheadline)
                        }
                        Spacer()
                        Button(action:{print("Updateorder")}) {
                            Text(order.orderStatus == .pending ? "Prepare" : "Complete")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationBarTitle("My Orders")
            .navigationBarItems(trailing: Button(action: {
                self.showOrderSheet = true
            }, label: {
                Image(systemName: "plus.circle")
                .resizable()
                    .frame(width: 32, height: 32, alignment: .center )
            }))
        }
        .sheet(isPresented: $showOrderSheet) {
            OrderSheet().environment(\.managedObjectContext, self.managedObjectContext)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
