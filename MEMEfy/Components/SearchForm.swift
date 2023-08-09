//
//  SearchForm.swift
//  MEMEfy
//
//  Created by Airis Wang on 7/29/23.
//

import SwiftUI
import GiphyUISDK

struct GiphyPicker: UIViewControllerRepresentable {
    var completion: ((String) -> Void)
    var onShouldDismissGifPicker: () -> Void
    
    func makeUIViewController(context: Context) -> GiphyViewController {
        guard let apiKey = readApiKeyFromPlist() else {
            fatalError("API Key not found in plist")
        }
        
        Giphy.configure(apiKey: apiKey)
        let giphy = GiphyViewController()
        GiphyViewController.trayHeightMultiplier = 0.8
        giphy.mediaTypeConfig = [.gifs]
        giphy.delegate = context.coordinator
        giphy.theme = GPHTheme(type: .lightBlur)
        giphy.swiftUIEnabled = true
        giphy.shouldLocalizeSearch = true
        giphy.dimBackground = true
        giphy.modalPresentationStyle = .currentContext
        return giphy
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }

    func readApiKeyFromPlist() -> String? {
        guard let path = Bundle.main.path(forResource: "apiKey", ofType: "plist"),
              let data = FileManager.default.contents(atPath: path),
              let plist = try? PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [String: Any],
              let apiKeyValue = plist["apiKey"] as? String
        else {
            return nil
        }
        return apiKeyValue
    }
    
    func makeCoordinator() -> Coordinator {
       return  GiphyPicker.Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, GiphyDelegate {
        var parent: GiphyPicker
        
        init(parent: GiphyPicker) {
            self.parent = parent
        }
        
        func didDismiss(controller: GiphyViewController?) {
            self.parent.onShouldDismissGifPicker()
        }
        
        func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia) {
            // retrieving url
            let url = media.url(rendition: .fixedWidth, fileType: .gif)

            DispatchQueue.main.async {
                self.parent.completion(url ?? "")
            }
        }
    }
}

struct SearchForm: View {
    @State private var isGiphyPickerPresented = false
    @State private var selectedGifURL = ""
    
    var body: some View {
        VStack {
            GiphyPicker { url in
                selectedGifURL = url
                print("gif url: \(selectedGifURL)")
                isGiphyPickerPresented = false
            } onShouldDismissGifPicker: {
                isGiphyPickerPresented = false
            }
        .ignoresSafeArea()
        }
    }
}

struct SearchForm_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            ZStack {
                Image("Wallpaper")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                
                SearchForm()
            }
        }
    }
}
