//
//  OrderSheet.swift
//  PizzaApp
//
//  Created by Alejandro Franco on 28/03/20.
//  Copyright © 2020 Alejandro Franco. All rights reserved.
//

import SwiftUI
import CoreData

struct OrderSheet: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectionPizzaIndex = 1
    @State private var numberOfSlices = 1
    @State private var tableNumber = ""
    let pizzaTypes = ["Puntas de filete", "Especial", "Mexicana", "Carnes frias"]
    
    var body: some View {
        NavigationView {
            Form {
                Section (header: Text("Pizza details")) {
                    Picker("Pizza type", selection: $selectionPizzaIndex) {
                        ForEach(0 ..< pizzaTypes.count) {
                            Text(self.pizzaTypes[$0])
                        }
                    }
                    Stepper("\(numberOfSlices)", value: $numberOfSlices, in: 1...12)
                }
                Section(header: Text("Table")) {
                    TextField("Table number", text: $tableNumber)
                        .keyboardType(.numberPad)
                }
                Button("Add order") {
                    guard self.tableNumber != "" else { return }
                    
                    let newOrder = Order(context: self.managedObjectContext)
                    newOrder.id = UUID()
                    newOrder.pizzaType = self.pizzaTypes[self.selectionPizzaIndex]
                    newOrder.orderStatus = .pending
                    newOrder.tableNumber = self.tableNumber
                    newOrder.numberOfSlices = Int16(self.numberOfSlices)
                    
                    do {
                        try self.managedObjectContext.save()
                        print("Order saved")
                        self.presentationMode.wrappedValue.dismiss()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        .navigationBarTitle("Take order")
        }
    }
}

struct OrderSheet_Previews: PreviewProvider {
    static var previews: some View {
        OrderSheet()
    }
}
