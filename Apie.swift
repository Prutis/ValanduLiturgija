//
//  Apie.swift
//  Valandu liturgija
//
//  Created by Rutenis Piksrys on 2021-02-15.
//

import SwiftUI
import WebKit

struct Apie: View {
    @AppStorage("param") var param:String = ""
    @AppStorage("sapkat") var sapkat: String = ""
    var apie:String = ""
    var path = ""
    var duomenys = Duomenys()
    init() {

    }
    var body: some View {
        VStack {
            WebView(html: duomenys.prhtml+sapkat+duomenys.apie+duomenys.pohtml+param)
        .frame(width: UIScreen.main.bounds.size.width)
                

    }
    }
}


struct Apie_Previews: PreviewProvider {
    static var previews: some View {
        Apie()
    }
}
