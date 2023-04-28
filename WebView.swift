//
//  WebView.swift
//  Valandu liturgija
//
//  Created by Rutenis Piksrys on 2021-03-01.
//
import Foundation
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {

    private let html: String?
    private let js: String?
    private let bgColor: Color?
    @AppStorage("pilnas") var pilnas: Bool = false
  //  private let darkas: Bool? = false
 //   @AppStorage("darkas")  var darkas = false
  //  var bgColor: Color = Color(.sRGB, red: Double(251)/255.0, green: Double(245)/255.0, blue: Double(225)/255.0)
    
    public init(
        html: String? = nil,
        js: String? = nil,
        bgColor: Color = Color(.sRGB, red: Double(251)/255.0, green: Double(245)/255.0, blue: Double(225)/255.0)


    ) {
        self.html = html
        self.js = js
        self.bgColor = bgColor
    //    self.darkas = darkas
        

    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()
        webview.configuration.userContentController.add(ContentController(), name:"jsHandler")

        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.viewTap))
        tapGesture.delegate = context.coordinator

        webview.addGestureRecognizer(tapGesture)
        return webview
    }

    class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate, UIGestureRecognizerDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        @objc func viewTap() {
            print("Tap gesture executed")
        }
   func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
       return true
   }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    class ContentController: NSObject, WKScriptMessageHandler {
        @AppStorage("pilnas") var pilnas: Bool = false
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "jsHandler"{
                print("W43_D",message.body)
                if(message.body as! String=="true") {print("W44_D", "pilnas")
                    pilnas = false
                }
                if(message.body as! String=="false") {print("W45_D", "nepilnas")
                    pilnas = true
                }
            }
        }
    }
    //UIViewRepresentableContext<WebView>
    func updateUIView(_ webview: WKWebView, context:UIViewRepresentableContext<WebView> ) {
        let baseUrl = Bundle.main.bundleURL


        //let url = Bundle.main.url(forResource: "totop", withExtension: "png", subdirectory: "tekstai")!
        //webview.configuration.userContentController.add(contentController, name: "jsHandler")
       // print("_D",url)
        webview.isOpaque = false;
        webview.backgroundColor = UIColor(bgColor ?? .black)
        //webview.backgroundColor(darkas == true ? .black : bgColor)
        //if darkas ?? false {
        //    webview.backgroundColor = UIColor.black } else {
        //        webview.backgroundColor = UIColor(bgColor)
        //    }
        webview.loadHTMLString(html ?? "", baseURL: baseUrl)
        //print("W71_D")
        webview.evaluateJavaScript(js ?? "",  completionHandler: nil)
        }
    //

    //
}

struct WebView2: UIViewRepresentable {
    var url: URL
    var zoom: Double
    func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()

        return webview
    }
    @AppStorage("lit_colorx") var lit_colorx: String = "green"
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let contentController = ContentController(webView)
        var js: String = "document.body.style.fontSize = '" + String(zoom*3)+"%' ; "
        js += "  var elems = document.getElementsByTagName('span');"
        js += "  for(i = 0; i < elems.length; i++) { "
        js += "  elems[i].setAttribute('style', 'font-size:" + String(zoom)+"%' + '!important');  }"
        let userScript = WKUserScript(source: js, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
        webView.configuration.userContentController.addUserScript(userScript)
        webView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        webView.evaluateJavaScript(js , completionHandler: nil)
        webView.load(URLRequest(url: url))
        webView.isOpaque = false
        webView.backgroundColor = UIColor(Color(lit_colorx ))
    }

    
    class ContentController: NSObject, WKScriptMessageHandler {
        var parent: WKWebView?
        init(_ parent: WKWebView?) {
            self.parent = parent
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage)  {   parent?.evaluateJavaScript("", completionHandler: nil)
        }
    }
}



struct WebView3: UIViewRepresentable {
    var url: URL
    func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()

        return webview
    }
    @AppStorage("lit_colorx") var lit_colorx: String = "green"
    func updateUIView(_ webView: WKWebView, context: Context) {
        let contentController = ContentController(webView)
        var js: String = "var all = document.getElementsByClassName('lit-pav');"
        js += "for (var i = 0; i < all.length; i++) {  all[i].style.fontFamily = 'Roboto'; }"
            
        let userScript = WKUserScript(source: js, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
        webView.configuration.userContentController.addUserScript(userScript)
        webView.evaluateJavaScript(js , completionHandler: nil)
        webView.load(URLRequest(url: url))
        webView.isOpaque = false
        webView.backgroundColor = UIColor(Color(lit_colorx ))

    }
    class ContentController: NSObject, WKScriptMessageHandler {
        var parent: WKWebView?
        init(_ parent: WKWebView?) {
            self.parent = parent
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage)  {   parent?.evaluateJavaScript("", completionHandler: nil)
        }
    }
}

struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero

  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    value = nextValue()
  }
}

