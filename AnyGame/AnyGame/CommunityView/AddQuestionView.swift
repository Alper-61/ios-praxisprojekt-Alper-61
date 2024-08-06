//
//  AddQuestionView.swift
//  AnyGame
//
//  Created by Alper Görler on 22.07.24.
//

import SwiftUI

import SwiftUI

struct AddQuestionView: View {
    @ObservedObject var viewModel: CommunityViewModel
    @Environment(\.dismiss) var dismiss
    @State private var questionText = ""
    @State private var isShowingImagePicker = false

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button("Abbrechen") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                    Spacer()
                    Button("Erstellen") {
                        viewModel.addQuestion(text: questionText)
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
                .padding()

                Form {
                    Section(header: Text("Bild")) {
                        if let image = viewModel.selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .clipped()
                        }
                        Button("Bild auswählen") {
                            isShowingImagePicker.toggle()
                        }
                    }
                    Section(header: Text("Frage")) {
                        TextField("Gib deine Frage ein", text: $questionText)
                    }
                }
                .background(Color.clear)
            }
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(selectedImage: $viewModel.selectedImage, isPresented: $isShowingImagePicker)
            }
        }
    }
}

#Preview {
    AddQuestionView(viewModel: CommunityViewModel())
}
