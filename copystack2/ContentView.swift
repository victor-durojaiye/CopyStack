//
//  ContentView.swift
//  CopyFlow
//
//  Created by Victor Durojaiye on 8/22/23.
//

import SwiftUI

struct ContentView: View {
    @State private var copiedItems: [String] = []
    @State private var temporaryColor: Bool = false

    var body: some View {
        VStack {
            Text("CopyStack")
            List(copiedItems, id: \.self){ item in
                Text(item)
                    .onTapGesture {
                        let pasteBoard = NSPasteboard.general
                        pasteBoard.clearContents()
                        pasteBoard.setString(item, forType: .string)
                        temporaryColor = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            temporaryColor = false
                        }
                    }
                    .contextMenu {
                        Button("Remove") {
                            if let index = copiedItems.firstIndex(of: item) {
                                copiedItems.remove(at: index)
                                }
                            }
                        }
                    .foregroundColor(temporaryColor ? .blue : .primary)
            }
           
            .onAppear(perform: {
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                            if let clipBoard = NSPasteboard.general.string(forType: .string) {
                                if !copiedItems.contains(clipBoard) {
                                    copiedItems.append(clipBoard)
                                }
                            }
                        }
                    })
            Button("Reset List"){
                copiedItems.removeAll()
            }
        }
        .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
