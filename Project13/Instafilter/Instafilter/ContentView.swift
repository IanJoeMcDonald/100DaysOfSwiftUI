//
//  ContentView.swift
//  Instafilter
//
//  Created by Ian McDonald on 12/02/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    @State private var filterIntensity = 0.5
    @State private var showingImagePicker = false
    @State private var showingFilterSheet = false
    @State private var showingSaveErrorAlert = false
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    @State private var filterName = "Sepia Tone"
    let context = CIContext()
    
    var body: some View {
        let intensity = Binding<Double>(
            get: {
                self.filterIntensity
        },
            set: {
                self.filterIntensity = $0
                self.applyProcessing()
        }
        )
        
        return NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.secondary)
                    
                    if image != nil {
                        image?
                            .resizable()
                            .scaledToFit()
                    } else {
                        Text("Tap to select a picture")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                .onTapGesture {
                    self.showingImagePicker = true
                }
                
                HStack {
                    Text("Intensity")
                    Slider(value: intensity)
                }.padding(.vertical)
                
                HStack {
                    Button(filterName) {
                        self.showingFilterSheet = true
                    }
                    
                    Spacer()
                    
                    Button("Save") {
                        guard let processedImage = self.processedImage else {
                            self.showingSaveErrorAlert = true
                            return
                        }
                        
                        let imageSaver = ImageSaver()
                        imageSaver.successHandler = {
                            print("Success!")
                        }
                        imageSaver.errorHandler = {
                            print("Oops: \($0.localizedDescription)")
                        }
                        
                        imageSaver.writeToPhotoAlbum(image: processedImage)
                    }
                }
            }
        }
        .padding([.horizontal, .bottom])
        .navigationBarTitle("Instafilter")
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }
        .actionSheet(isPresented: $showingFilterSheet) {
            ActionSheet(title: Text("Select a filter"), buttons: [
                .default(Text("Crystallize")) {
                    self.setFilter(CIFilter.crystallize(),named: "Crystallize")
                },
                .default(Text("Edges")) {
                    self.setFilter(CIFilter.edges(), named: "Edges")
                },
                .default(Text("Gaussian Blur")) {
                    self.setFilter(CIFilter.gaussianBlur(), named: "Gaussian Blur")
                },
                .default(Text("Pixellate")) {
                    self.setFilter(CIFilter.pixellate(), named: "Pixellate")
                },
                .default(Text("Sepia Tone")) {
                    self.setFilter(CIFilter.sepiaTone(),named: "Sepia Tone")
                },
                .default(Text("Unsharp Mask")) {
                    self.setFilter(CIFilter.unsharpMask(), named: "Unsharp Mask")
                },
                .default(Text("Vignette")) {
                    self.setFilter(CIFilter.vignette(), named: "Vignette")
                },
                .cancel()
            ])
        }
        .alert(isPresented: $showingSaveErrorAlert) {
            Alert(title: Text("Error"), message: Text("No image selected"),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
    
    func setFilter(_ filter: CIFilter, named: String) {
        filterName = named
        currentFilter = filter
        loadImage()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
