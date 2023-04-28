//
//  Nustatymai.swift
//  Valandu liturgija
//
// - data,
// - slinkimo greitis
// - laikyti ekraną įjungtą,
// -  "Garbė Dievui" - trumpas ar pilnas variantas
// - antro choro atskyrimas atitraukimu
// - antro choro atskyrimas tarpu tarp eilučių
//  Created by Rutenis Piksrys on 2021-02-14.
//

import SwiftUI
import WebKit

struct Nustatymai: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("greitis") var greitis: Double = 100
    @AppStorage("ekranas") var ekranas: Bool = false
    @AppStorage("marijos") var marijos: Bool = false
    @AppStorage("garbe") var garbe: Bool = false
    @AppStorage("chsp") var chsp: Bool = false
    @AppStorage("chat") var chat: Bool = false
    @AppStorage("m_slinkimas") var m_slinkimas: Bool = true
    @AppStorage("m_slinkimo_greitis") var m_slinkimo_greitis: Bool = true
    @AppStorage("m_diena_naktis") var m_diena_naktis: Bool = false
    @AppStorage("m_raidziu_dydis") var m_raidziu_dydis: Bool = false
    @AppStorage("m_pilnas_ekranas") var m_pilnas_ekranas: Bool = true
    @AppStorage("pilnas") var pilnas: Bool = false
    @AppStorage("m_i_virsu") var m_i_virsu: Bool = false
    @AppStorage("m_i_apacia") var m_i_apacia: Bool = false
    @AppStorage("zoom") var zoom: Double = 100
    @AppStorage("fonas") var fonas: Double = 4
    @AppStorage("sriftas") var sriftas: String = "Arial"
    @AppStorage("bgcolor") var bgColor: Color = Color(.sRGB, red: Double(251)/255.0, green: Double(245)/255.0, blue: Double(225)/255.0)

    @AppStorage("fcolor") var fcolor: Color =
        Color(.sRGB, red: Double(47)/255.0, green: Double(45)/255.0, blue: Double(41)/255.0)
    @AppStorage("hbgcolor") var hbgColor: String = "#FCF5E2"

    @AppStorage("hfcolor") var hfcolor: String = "#2F2D29"
    @AppStorage("naktis") var naktis:Bool = false
    @AppStorage("automode") var automode:Bool = false
    @AppStorage("darkas")  var darkas = false
    @AppStorage("ratas") var ratas: Bool = false
    @AppStorage("metur") var metur: String = "A"
    
    @AppStorage("pirmas") var pirmas:Int = 1
    
    @State var pekr:String = "Malda"
    @State var debug: String = "debug"
    @State private var revealDetails = false
    @State private var revealDetails2 = false
    @State var tekstas: String = "<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></head><body> <span style='color: #FF0000'> K. </span>Viešpatie, atverk mano lūpas.<br/> <span style='color: #FF0000'> A. </span>Ir aš tave šlovinsiu.</body>"
    @AppStorage("param") var param:String = "<script>document.getElementsByTagName( 'body' )[0].style['font-size'] = '120.0%';document.getElementsByTagName( 'body' )[0].style['font-family']='Arial';zoom =120.0;document.getElementsByTagName( 'body' )[0].style['color']='#2F2D29';document.getElementsByTagName( 'body' )[0].style['background-color']='#FBF5E1'; tamsa=false;hbgColor ='#FBF5E1'; Naktis();  garbed(false);  antrasch(false,false);  scrollp(100.0,120.0);  fmygt(true,true,false,false,true,false,false); </script></html>"
    
    init() {
        if(!automode) { darkas = naktis } else { darkas = (UIColor.myDarkas.accessibilityName == "dark red") }
        //print("52N_D darkas,UIColor.myDarkas.accessibilityName",darkas, UIColor.myDarkas.accessibilityName)
      }

    func dtime() -> String {
        let time = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "mm:ss"
        let stringDate = timeFormatter.string(from: time)
        return stringDate
    }

    
    var body: some View {

        ScrollView(.vertical){
        VStack {
            Group {
            Text("Raidžių dydis % \(Int(zoom))")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            HStack {
                Image(systemName: "minus")
                    .padding(.all, 10)
                    .onTapGesture {
                        zoom = zoom - 5
                        if zoom < 50 { zoom = 50}
                        paramf2()
                    }
            Slider(value: $zoom, in: 50...200, step: 5)
                .padding(.horizontal)
                .accentColor(.red)
                .onChange(of: zoom, perform: { value in
                paramf2()
            })
                Image(systemName: "plus")
                    .padding(.all, 10)
                    .onTapGesture {
                        zoom += 5
                        if zoom > 200 { zoom = 200}
                        paramf2()
                    }
            }

            DisclosureGroup("Šriftas: "+sriftas, isExpanded: $revealDetails) {
                Text("Andale Mono")
                    .font(.custom("Andale Mono", size: 17))
                    .onTapGesture { sriftas = "Andale Mono"
                        paramf2()
                        revealDetails = false }
                Text("Arial")
                    .font(.custom("Arial", size: 17))
                    .onTapGesture { sriftas = "Arial"
                        paramf2()
                        revealDetails = false }
                Text("Georgia")
                    .font(.custom("Georgia", size: 17))
                    .onTapGesture { sriftas = "Georgia"
                        paramf2()
                        revealDetails = false }
                Text("Times New Roman")
                    .font(.custom("Times New Roman", size: 17))
                    .onTapGesture { sriftas = "Times New Roman"
                        paramf2()
                        revealDetails = false }
                Text("Trebuchet MS")
                    .font(.custom("Trebuchet MS", size: 17))
                    .onTapGesture { sriftas = "Trebuchet MS"
                        paramf2()
                        revealDetails = false }
                Text("Verdana")
                    .font(.custom("Verdana", size: 17))
                    .onTapGesture { sriftas = "Verdana"
                        paramf2()
                        revealDetails = false  }
            }
            .font(.custom(sriftas, size: 17))
            .foregroundColor(naktis ? .green : .blue)
            .padding()
                
                Webhtml(html: tekstas + param,bgColor: (darkas ? .black : bgColor))
                    .padding(.horizontal)
                    .frame(width: 300, height: 100, alignment: .center)
        } //group

                Group {
                    Divider()
                    Text("Fono atspalvis")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    Slider(value: $fonas, in: 0...8, step: 1)
                        .padding(.horizontal)
                        .accentColor(.red)
                        .onChange(of: fonas, perform: { value in
                        paramf2()
                    })
                    Divider()
                    Text("Slinkimo greitis")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    Slider(value: $greitis, in: 50...200, step: 5)
                        .padding(.horizontal)
                        .accentColor(.red)
                        .onChange(of: greitis, perform: { value in
                            paramf2() }) }
                Group {
                        Divider()
                    Toggle("Automatinis 'Nakties režimas' :",isOn: $automode)
                    .padding(.horizontal)
                        .accentColor(.red)
                        .onChange(of: automode, perform: { value in
                                    paramf2() })
                    Toggle("Nakties režimas:",isOn: $naktis)
                        .disabled(automode == true)
                        .padding(.horizontal)
                    .accentColor(.red)
                    .onChange(of: naktis, perform: { value in
                                paramf2() })
                Divider()
                }
                

            Group {
                Toggle("Klasikinis kalendorius:",isOn: $ratas)
                .padding(.horizontal)
            Toggle("Ekraną laikyti įjungtą:",isOn: $ekranas)
                .onAppear { UIApplication.shared.isIdleTimerDisabled = ekranas }
            .padding(.horizontal)
                .onChange(of: ekranas, perform: { value in
                            ekranon() })

                Divider()
                Toggle("Pilnas „Garbė Dievui“ tekstas:",isOn: $garbe)
                    .onChange(of: garbe, perform: { value in
                                paramf2() })
                .padding(.horizontal)
                Divider()
                Toggle("Chorų atskyrimas tarpu tarp eilučių:",isOn: $chsp)
                    .onChange(of: chsp, perform: { value in
                                paramf2() })
                .padding(.horizontal)
                Toggle("Chorų atskyrimas atitraukimu:",isOn: $chat)
                    .onChange(of: chat, perform: { value in
                                paramf2() })
                .padding(.horizontal)
                
                DisclosureGroup("Pirmas ekranas: "+pekr, isExpanded: $revealDetails2) {
                    Text("Malda")
                        .onTapGesture { pirmas = 0
                            pekr = "Malda"
                            revealDetails2 = false  }
                    Text("Valandos")
                        .onTapGesture { pirmas = 1
                            pekr = "Valandos"
                            revealDetails2 = false  }
                    Text("Kalendorius")
                        .onTapGesture { pirmas = 2
                            pekr = "Kalendorius"
                            revealDetails2 = false  }
                    
                }
                .padding()
                .foregroundColor(naktis ? .green : .blue)
                .onAppear(){
                     switch pirmas {
                     case 0:
                         pekr = "Malda"
                     case 1:
                         pekr = "Valandos"
                     case 2:
                         pekr = "Kalendorius"
                     default:
                         pekr = "Malda"
                     }
                }
            }
                Group {
                Text("Naudojami mygtukai - funkcijos maldose")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                Toggle("Slinkimas:",isOn: $m_slinkimas)
                    .onChange(of: m_slinkimas, perform: { value in
                                paramf2()
                        print("N276_D",String(m_slinkimas))
                    })
                    .padding(.horizontal)
                Toggle("Slinkimo greitis:",isOn: $m_slinkimo_greitis)
                    .onChange(of: m_slinkimo_greitis, perform: { value in
                                paramf2() })
                    .padding(.horizontal)
                Toggle("Šviesus - Tamsus režimai:",isOn: $m_diena_naktis)
                    .onChange(of: m_diena_naktis, perform: { value in
                                paramf2() })
                    .padding(.horizontal)
                Toggle("Raidžių dydžio keitimas:",isOn: $m_raidziu_dydis)
                    .onChange(of: m_raidziu_dydis, perform: { value in
                                paramf2() })
                    .padding(.horizontal)
                Toggle("Pilno ekrano įjungimas:",isOn: $m_pilnas_ekranas)
                    .onChange(of: m_pilnas_ekranas, perform: { value in
                                paramf2() })
                    .padding(.horizontal)
                Toggle("Į viršų:",isOn: $m_i_virsu)
                    .onChange(of: m_i_virsu, perform: { value in
                                paramf2() })
                    .padding(.horizontal)
                Toggle("Į apačią:",isOn: $m_i_apacia)
                    .onChange(of: m_i_apacia, perform: { value in
                                paramf2() })
                    .padding(.horizontal)
                Divider()
                Button("Pradiniai parametrai") {
                ratas = false
                naktis = false
                automode = false
                zoom = 120
                greitis = 100
                ekranas = false
                marijos = false
                garbe = false
                chsp = false
                pilnas = false
                chat = false
                sriftas = "Arial"
                fonas = 4
                    m_slinkimas = true
                    m_slinkimo_greitis = true
                    m_diena_naktis = false
                    m_raidziu_dydis = false
                    m_pilnas_ekranas = true
                    m_i_virsu = false
                    m_i_apacia = false
                bgColor = Color(.sRGB, red: Double(251)/255.0, green: Double(245)/255.0, blue: Double(225)/255.0)
                fcolor =
                    Color(.sRGB, red: Double(47)/255.0, green: Double(45)/255.0, blue: Double(41)/255.0)
                hbgColor = "#FCF5E2"
                hfcolor = "#2F2D29"
                pirmas = 0
                paramf2()
            }
            .frame(width: 180, height: 30, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                .stroke(lineWidth: 2)
            )
            .padding(.bottom, 50)
            } //group
                } //Vstack pabaiga
        } //scrollview pabaiga
        .padding(.top, 1)
        
    }  //View  pabaiga

        func paramf2() {

 //           let currentSystemScheme = UITraitCollection.current.userInterfaceStyle
            if(!automode) { darkas = naktis } else { darkas = (UIColor.myDarkas.accessibilityName == "dark red") }
           // print("263N_D darkas,UIColor.myDarkas.accessibilityName",darkas, UIColor.myDarkas.accessibilityName)
               // print("18_D darkas,colorscheme",darkas, currentSystemScheme == .dark, currentSystemScheme == .light)

            
            bgColor = Color(.sRGB, red: Double(255 - fonas)/255.0, green: Double(255 - fonas*2.5)/255.0, blue: Double(255 - fonas*7.5)/255.0)
            hfcolor = fcolor.hexaRGB!
            hbgColor = bgColor.hexaRGB!
            param = "<script>document.getElementsByTagName( 'body' )[0].style['font-size'] = '" + String(zoom)+"%';"
        param += "document.getElementsByTagName( 'body' )[0].style['font-family']='" + sriftas + "';"
            param += "zoom =" + String(zoom) + ";"
            if(darkas) {
                param += "document.getElementsByTagName( 'body' )[0].style['color']='rgb(240,240,240)';"
                param += "document.getElementsByTagName( 'body' )[0].style['background-color']='rgb(15,15,15)';"
           //     param += "document.getElementById('myNak').innerHTML = '&#9788;'; tamsa=true;"
                param += " tamsa=true;"
           
            } else {
                param += "document.getElementsByTagName( 'body' )[0].style['color']='" + hfcolor + "';"
                param += "document.getElementsByTagName( 'body' )[0].style['background-color']='" + hbgColor + "';"
               // param += "document.getElementById('myNak').innerHTML = '&#9789;'; tamsa=false;"
                param += " tamsa=false;"
                param += "hbgColor ='" + hbgColor + "';"
            }
            param += " Naktis(); "
            if(garbe) {param += " garbed(true); "}
            else {param += " garbed(false); "}
            param += " antrasch(" + String(chsp) + ","
            param +=  String(chat) + "); "
            //param += "pilnas ='" + String(pilnas) + "';"
            param += " scrollp(" + String(greitis) + ","
                param += String(zoom) +  "); "
            param += " fmygt(" + String(m_slinkimas) + "," + String(m_slinkimo_greitis ) + "," + String(m_diena_naktis) + "," + String(m_raidziu_dydis) + "," + String(m_pilnas_ekranas) + "," + String(m_i_virsu) + "," + String(m_i_apacia) + "); "
           param += "</script></html>"
            //let ppp:String = param
            //print("N348 param: _D " + param)
            //return ppp
        }
    func ekranon() {
        UIApplication.shared.isIdleTimerDisabled = ekranas
    }
    }
    
 // view pabaiga

func gadatap() -> Date  {
    var gd:Date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    gd = formatter.date(from: "2035-12-31") ?? Date()
    return gd
}
public struct Webhtml: UIViewRepresentable {
    private let html: String
    private let configuration: WKWebViewConfiguration?
    private let bgColor: Color?
    
    public init(
        html: String,
        configuration: WKWebViewConfiguration? = nil,
        bgColor: Color = Color(.sRGB, red: Double(251)/255.0, green: Double(245)/255.0, blue: Double(225)/255.0)
    ) {
        self.html = html
        self.configuration = configuration
        self.bgColor = bgColor
    }

    public func makeUIView(context: Context) -> WKWebView {
        if let configuration = configuration {
            return .init(frame: .zero, configuration: configuration)
        } else {
            return .init()
        }
    }

    public func updateUIView(_ webView: WKWebView, context: Context) {
        webView.isOpaque = false;
        webView.backgroundColor = UIColor(bgColor ?? .black)
        webView.loadHTMLString(html, baseURL: nil)
    }
}
extension Color {
    var uiColor: UIColor { .init(self) }
    typealias RGBA = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    var rgba: RGBA? {
        var (r,g,b,a): RGBA = (0,0,0,0)
        return uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) ? (r,g,b,a) : nil
    }
    var hexaRGB: String? {
        guard let rgba = rgba else { return nil }
        return String(format: "#%02lX%02lX%02lX",
                      lroundf(Float(rgba.red*255)),
                      lroundf(Float(rgba.green*255)),
                      lroundf(Float(rgba.blue*255)))
    }
    var hexaRGBA: String? {
        guard let rgba = rgba else { return nil }
        return String(format: "#%02x%02x%02x%02x",
                      Int(rgba.red * 255),
                      Int(rgba.green * 255),
                      Int(rgba.blue * 255),
                      Int(rgba.alpha * 255))
    }
}
extension Color: RawRepresentable {
    // TODO: Sort out alpha
    public init?(rawValue: Int) {
        let red =   Double((rawValue & 0xFF0000) >> 16) / 0xFF
        let green = Double((rawValue & 0x00FF00) >> 8) / 0xFF
        let blue =  Double(rawValue & 0x0000FF) / 0xFF
        self = Color(red: red, green: green, blue: blue)
    }

    public var rawValue: Int {
        let red = Int(coreImageColor.red * 255 + 0.5)
        let green = Int(coreImageColor.green * 255 + 0.5)
        let blue = Int(coreImageColor.blue * 255 + 0.5)
        return (red << 16) | (green << 8) | blue
    }

    private var coreImageColor: CIColor {
        return CIColor(color: UIColor(self))
    }
}




struct Nustatymai_Previews: PreviewProvider {
    static var previews: some View {
        Nustatymai()
    }
}
