//
//  Formavimas.swift
//  Valandu liturgija
//
//  Created by Rutenis Piksrys on 2021-03-17.
//

import Foundation
import SwiftUI
import SQLite3

struct Formavimas {

    var dbpath = ""
    var db: OpaquePointer?
    var duomenys = Duomenys()
    @AppStorage("selection")  var selection = 0
    @AppStorage("metur") var metur: String = "A"
    @AppStorage("MMdd")  var MMdd: String = "0101"
    @AppStorage("eil_sav") var eil_sav: Int = 0
    @AppStorage("sav_diena")  var sav_diena: Int = 0
    @AppStorage("savaite") var savaite: Int = 0
    @AppStorage("data_md")  var data_md: Int = 1
    @AppStorage("kal_md")  var kal_md: Int = 359
    @AppStorage("vel_md")  var vel_md: Int = 120
    @AppStorage("pas_md")  var pas_md: Int = 330
    @AppStorage("krk_md")  var krk_md: Int = 7
    @AppStorage("kra_md")  var kra_md: Int = 6
    @AppStorage("pel_md")  var pel_md: Int = 100
    @AppStorage("iskk") var iskk: String = ""
    @AppStorage("ikkr") var ikkr: String = ""
    @AppStorage("lit_per") var lit_per: String = "eil"
    @AppStorage("ausrin") var ausrin: String = ""
    @AppStorage("izang") var izang: String = ""
    @AppStorage("naktin") var naktin: String = ""
    @AppStorage("pavak") var pavak: String = ""
    @AppStorage("priesp") var priesp: String = ""
    @AppStorage("rytmet") var rytmet: String = ""
    @AppStorage("vakar") var vakar: String = ""
    @AppStorage("vidut") var vidut: String = ""
    @AppStorage("kreipinys") var kreipinys: String = " Aleliuja."
    @AppStorage("laikasV")  var laikasV: String = ""
    @AppStorage("krk")  var krk:String = "0106"
    @AppStorage("tipas") var tipas: String = ""
    @AppStorage("pnr") var pnr: Int = 0 //pasirinkimas ka publikuoti
    @AppStorage("sv0") var sv0: String = ""
    @AppStorage("sv1") var sv1: String = ""
    @AppStorage("sv2") var sv2: String = ""
    @AppStorage("nakt_d") var nakt_d:String = "0"
    
    var lit_perx: String = "eil"
    var indek:  [String:  String]   =  [:]
    var psal: String = ""
    var skt: String = ""
    var marprieg: String = ""
    var Zprieg: String = ""
    var svvx:String = ""
    
    func dtime() -> String {
        let time = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "mm:ss"
        let stringDate = timeFormatter.string(from: time)
        return stringDate
    }
    init() {
     //   print(66,"Formavimas_init_D",dtime(),self.selection)
        dbpath = Bundle.main.path(forResource: "valanduliturgija",  ofType: "db", inDirectory:"tekstai")!
        if sqlite3_open(dbpath, &db) != SQLITE_OK {
          print("error opening database")
            sqlite3_close(db)
            db = nil
            return
        } //else { formavimas()}
    }
    mutating func formavimas() {
        // print(76,"Formavimas_formavimas_D",dtime())
        lit_perx = lit_per
        kreipinys = " Aleliuja."
        let ps_sav: Int = savaite - Int((savaite - 1) / 4) * 4
        psal = String(ps_sav) + String(sav_diena)
        let sktx = "0" + String(savaite) + String(ps_sav) + String(sav_diena)
         skt = String(sktx.suffix(4))
        var query:String =  "SELECT * FROM 'index'"
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let malda = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                let tekstas = String(describing: String(cString: sqlite3_column_text(statement, 2)))
               // let valanda = sqlite3_column_int(statement, 0)
               // indek.updateValue(tekstas as String, forKey: malda as String)
                if(tekstas.isEmpty) { indek[malda] = " " } else {indek[malda] = tekstas }
            }
        }
        if (iskk == "nms") {
            lit_per = "eil"
            MMdd = "1401"
            iskk = ""
            tipas = "pr"
        }

        // -------- Priegiesmių užrašymas ----------
        // Vakarines Marijos priegesmis  metur

        var vm: String = "vm" + ikkr + "1v" + metur
        query = "SELECT tekstas FROM 'priegiesmiai' WHERE  laukas='" + vm + "' LIMIT 1"
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement)  == SQLITE_ROW {
                marprieg = String(describing: String(cString: sqlite3_column_text(statement, 0)))
            }
        }


        vm = "vm" + MMdd
        query = "SELECT tekstas FROM 'priegiesmiai' WHERE  laukas='" + vm + "' LIMIT 1"
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement)  == SQLITE_ROW {
                marprieg = String(describing: String(cString: sqlite3_column_text(statement, 0)))
            }
        }
        vm = "vm" + String(eil_sav) + String(sav_diena) + metur;
        query = "SELECT tekstas FROM 'priegiesmiai' WHERE  laukas='" + vm + "' LIMIT 1"
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement)  == SQLITE_ROW {
                marprieg = String(describing: String(cString: sqlite3_column_text(statement, 0)))
            }
        }
        vm = "vm" + iskk + metur;
        query = "SELECT tekstas FROM 'priegiesmiai' WHERE  laukas='" + vm + "' LIMIT 1"
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement)  == SQLITE_ROW {
                marprieg = String(describing: String(cString: sqlite3_column_text(statement, 0)))
            }
        }
        if (marprieg.count > 5) {
            marprieg = "<p><span class=\"auto-style8 \">Marijos giesmės prieg.</span><br>" + marprieg + "</p>"
            //print("135_D",marprieg)
            indek["MP"] =  marprieg
        }

         // Zikarijos giesmės priegesmis
         vm = "zg" + MMdd
        query = "SELECT tekstas FROM 'priegiesmiai' WHERE  laukas='" + vm + "' LIMIT 1"
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement)  == SQLITE_ROW {
                Zprieg = String(describing: String(cString: sqlite3_column_text(statement, 0)))
            }
        }

         vm = "zg" + String(eil_sav) + metur + String(sav_diena)
        query = "SELECT tekstas FROM 'priegiesmiai' WHERE  laukas='" + vm + "' LIMIT 1"
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement)  == SQLITE_ROW {
                Zprieg = String(describing: String(cString: sqlite3_column_text(statement, 0)))
            }
        }
       
         if(!iskk.isEmpty)  {vm = "za" + iskk + metur
            query = "SELECT tekstas FROM 'priegiesmiai' WHERE  laukas='" + vm + "' LIMIT 1"
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement)  == SQLITE_ROW {
                    Zprieg = String(describing: String(cString: sqlite3_column_text(statement, 0)))
                }
            } }
        if((lit_per == "adv" || lit_per == "ksp")  && sav_diena==0) {
             vm = "za" + String(savaite) + metur
            query = "SELECT tekstas FROM 'priegiesmiai' WHERE  laukas='" + vm + "' LIMIT 1"
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement)  == SQLITE_ROW {
                    Zprieg = String(describing: String(cString: sqlite3_column_text(statement, 0)))
                }
            }
         }
        //
        if (Zprieg.count > 5) {
            Zprieg = "<p><span style=\"color: #FF0000\">Zacharijo giesmės prieg.</span><br>" + Zprieg + "</p>"
            indek["ZP"] =  Zprieg
        }
         // -------- Priegiesmių užrašymas pabaiga ----------
         
        // ------- Iškilmių užpildymas --------------
        var isk_ben = duomenys.isk_ben
        lit_perx = lit_per
        //print("174_D",iskk,isk_ben[iskk])
        if (!iskk.isEmpty) {
            if(lit_perx == "gav") {    //gavenioslykų laikotarpi
                kreipinys=""
                gav_uzpildymas()
            }
            if (iskk == "mbm" || iskk == "jkk") {
                uzpildymas()
                //print("178_D",indek["D1R"])
            }
            if let val = isk_ben[iskk] { iskbendr()
                //print("180_D",indek["D1R"])
            }
            else { iskil_uzp()
            //print("198_D")
            }
 
        } //iškilmių apdorojimo pabaiga  */
        // ------- Iškilmių užpildymo pabaiga ---------
        
        let isk_tipas = duomenys.isk_tipas

        if (iskk.isEmpty) { //nera iskilmiu
            if(lit_perx == "gav") {    //gavenioslykų laikotarpi
                kreipinys=""
                gav_uzpildymas()
            }
            if lit_perx == "eil" {
                uzpildymas()
            }
            if(lit_perx == "vel" || lit_perx == "ve8") {    //velykų laikotarpi
                vel_uzpildymas()
            }

            if(lit_perx == "gad" || lit_perx == "ve3" ) {  //didžioji savaitė ir velykų tridienis
                 kreipinys=""
                 gd3_uzpildymas()
             }
            if(lit_perx == "adv" || lit_perx == "ksp" ) {    //adventas ksp
                adv_uzpildymas()
            }
            if(!tipas.isEmpty) { sventojo_uzp() }
            //print("F226_D",indek["VL"])
            if(lit_perx == "kal" || lit_perx == "ka8" ) {    //  kal ka8
                if(data_md > (pas_md + 20)) { savaite = 4 }
                if(data_md > (pas_md + 27)) { savaite = 1 }
                 if(data_md < 20) {
                    var pdsk:Int = 0
                    let krkm: String = String(krk.suffix(2))
                    if (krkm == "0108" || krkm == "0109") { pdsk = 1 }
                    var dsk:Int  = data_md
                    if(data_md > krk_md) { dsk = data_md - krk_md + pdsk }
                 savaite = (dsk / 7) + 1; }
                 kal_uzpildymas()
             }
            //print("F232_D",indek["VL"])
            if (sav_diena == 6)  { indek["vkp"] = "<p class=\"auto-style3\">"+laikasV+"<br><br><strong>I Vakarinė</strong></p>"  }
            if (data_md == vel_md - 1) { indek["vkp"] = "<p class=\"auto-style3\"><strong>Vakarinė</strong></p>"  }
            if(sav_diena == 0) { indek["vkp"] = "<p class=\"auto-style3\"><strong>II Vakarinė</strong></p>" }
            
        }  // nera iskilmiu pabaiga
             //------- Iškilmių 1 vakarinė ------------
            //print("F244_D",ikkr,iskk)
            var vak2:Bool = false
             // 1. ar rytoj yra iškilmė
            let ikkrx = ikkr
            if(ikkr == "pel") { ikkr="" }
            
            if (!ikkr.isEmpty) { laikasV = duomenys.iskm_pav[ikkr] ?? "" }
            
            if (!ikkr.isEmpty && ikkr != "svs" &&  ikkr != "krk" &&  ikkr != "krs") { if( isk_tipas[ikkr] != "is") { ikkr = ""} }
            
            if (!iskk.isEmpty  && isk_tipas[iskk] == "is"  &&  ikkr != "krs")  { ikkr = ""}
            if(ikkrx == "krs") {ikkr = ikkrx}
            print("F253_D",ikkr,iskk)
            
            if (!ikkr.isEmpty) {
                print("259_D",ikkr)
                 if (sav_diena != 0 || ikkr == "kra" || ikkr == "mdg" || ikkr == "jon" || ikkr == "ppa")
                     { vak2 = true; }
                 if (ikkr == "zol" || ikkr == "sil" || ikkr == "vsv" || ikkr == "mgm" || ikkr == "svs" || ikkr == "sek" || ikkr == "krs")
                     { vak2 = true }
                 if (ikkr == "kaz" && lit_perx == "eil")
                     {vak2 = true } //šventas kazimieras per eilinį laikotarpį
                 if (vak2) {
                    indek["vkp"] = "<p class=\"auto-style3\"><br><strong>I Vakarinė</strong></p>"
                    // Cursor cui = myDB.rawQuery("SELECT * FROM 'iskilmes' WHERE failas='" + isk_kodasr + "-1V'", null);
                    var laukas:String = ""
                    var tekstas:String = ""
                    let SQL = "SELECT * FROM 'iskilmes' WHERE failas='" + ikkr + "-1V'"
                    if sqlite3_prepare_v2(db, SQL, -1, &statement, nil) == SQLITE_OK {
                       while sqlite3_step(statement)  == SQLITE_ROW {
                           laukas = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                           tekstas = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                            indek[laukas] = tekstas
                       }
                    }
                 }
             }
                if(data_md < 7 && sav_diena==6) { k2s_v_1_uzpildymas() }   // II sekmadienio vakarinė
             //------- Iškilmių 1 vakarinės užpildymo pabaiga ------------
            
        
        //naktines
        nakt_d = String(sav_diena)
         if(data_md > kal_md && data_md < kal_md+7 && sav_diena > 0 && sav_diena < 6 ) {
             nakt_d="0";
            if(sav_diena % 2 == 0) { nakt_d="6"} }

        if(MMdd == "1401" && sav_diena < 6) { nakt_d = "0"}
        if ( !iskk.isEmpty && isk_tipas[iskk] == "is") { nakt_d = "0"}
        if (!ikkr.isEmpty) {    if isk_tipas[ikkr] == "is"   { nakt_d = "6"} }

        
        
        if (ikkr == "pel") { nakt_d = "2"} //pelenų dienai
        if (iskk == "pel") {nakt_d = "3"
            kreipinys = "" }//pelenų dienai
        if (iskk == "vel") { nakt_d = "e"} //velykos
        if (sav_diena == 0 && lit_per == "adv") { nakt_d = "0" } //advento sekmadienis
        if (!iskk.isEmpty && isk_tipas[iskk] == "is" && sav_diena == 6 && (lit_per == "gav" || lit_per == "adv")) {  nakt_d = "6" }
        if (sav_diena == 4 && lit_per == "gad") { nakt_d = "k" }  //didžiosios savaitės ketvirtadienis
        if (sav_diena == 5 && lit_per == "ve3") { nakt_d = "p" }  //didžiosios savaitės penktadienis
        if (sav_diena == 6 && lit_per == "ve3") { nakt_d = "s" }  //didžiosios savaitės šeštadienis
        if (lit_per == "ve8" && (sav_diena == 1 || sav_diena == 3 || sav_diena == 5 || sav_diena == 6)) {  nakt_d = "v1" }
        if (lit_per == "ve8" && (sav_diena == 2 || sav_diena == 4 || sav_diena == 0)) { nakt_d = "v2" }
        if (data_md > vel_md + 7 && data_md <= vel_md + 49 && (iskk.isEmpty || sav_diena == 0)) { nakt_d = String(sav_diena) + "v"}
        let failas = "naktine-" + nakt_d
        //print("302_D",failas)
        var  path = Bundle.main.path(forResource: failas,  ofType: "html", inDirectory:"naktines")!
        naktin =  try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
        if(lit_perx == "gav" || lit_perx == "gad" || lit_perx == "ve3"  || iskk == "ver") { kreipinys = "" }
        if(kreipinys.isEmpty) {
            let Nak = naktin
            naktin = Nak.replacingOccurrences(of: "Aleliuja.", with: "")
        }
        // paskutine liturgine savaite
        if(indek["sv"] == " "  && eil_sav == 34) {
         //   print("305_D tinka")
            var laukas:String = ""
            var tekstas:String = ""
            var mmm:String = ""
            var nnn:String = ""
             query = "SELECT * FROM 'psalmynas' WHERE failas='74'"
             if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
                 while sqlite3_step(statement)  == SQLITE_ROW {
                     laukas = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                    tekstas = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                     if(laukas=="AH" || laukas=="RH" || laukas=="VH") {
                         mmm = indek[laukas] ?? ""
                        nnn = tekstas + "<div id='" + laukas + "s'>" + mmm + "</div>"
                         indek[laukas] = ""
                         indek[laukas]?.append(nnn)
                     }
                 }
                // print("321_D",nnn)
             }

//           Cursor cup = myDB.rawQuery("SELECT * FROM 'psalmynas' WHERE failas='74'", null);
//           if (cup.moveToFirst()) {
//               do {
//                   String malda = cup.getString(1);
//                   // Log.d("mx",malda+":"+malda.indexOf("V"));
//                   if (malda.indexOf("H") >= 0) {
//                       mmm ="<div id='"+malda+"s'>"+ HM.get(malda)+"</div>";
//                       HM.put(malda, cup.getString(2).replace("\n", "")+mmm);

//                   }
//               } while (cup.moveToNext());
//               cup.close();

    }
        
        //galutinis suformavimas

        let cookieJar = HTTPCookieStorage.shared

        for cookie in cookieJar.cookies! {
            cookieJar.deleteCookie(cookie)
        }
        HTTPCookieStorage.shared.cookies?.forEach(HTTPCookieStorage.shared.deleteCookie)

        path = Bundle.main.path(forResource: "iza",  ofType: "txt", inDirectory:"tekstai")!
        let izangx =  try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
        var priegm = indek["IR"] ?? ""
        //print("289_D",priegm)
        priegm = priegm.replacingOccurrences(of: "svvardas", with: svvx) //prieg.replace("svvardas", svvx);
        if(kreipinys.isEmpty) {
            izang = "<script> var prieg='" + priegm.replacingOccurrences(of: "aleliuja", with: "")
        } else {
            izang = "<script> var prieg='" + priegm}
        izang  += "'; var puslp ='izan'; </script>" + izangx
        //print("F350_D",izang)
        ausrin = "<script>  var puslp ='ausr'; </script>"
        pavak = "<script>  var puslp ='pava'; </script>"
        priesp = "<script>  var puslp ='prie'; </script>"
        rytmet = "<script>  var puslp ='rytm'; </script>"
        vakar = "<script>  var puslp ='vaka'; </script>"
        vidut = "<script>  var puslp ='vidu'; </script>"
        let vmm = indek["VM"] ?? ""
        let rmm = indek["RM"] ?? ""
        indek["RM"] = "<div id='RM'>" + rmm + "</div>"
        indek["VM"] = "<div id='VM'>" + vmm + "</div>"
        //var mppx:String = indek["MP"]
        indek["MP"] = indek["MP"]?.replacingOccurrences(of: "svvardas", with: svvx)
        var dppr:String = ""
        var dpvi:String = ""
        var dppa:String = ""
        //papildomos psalmodijos
        if (iskk.isEmpty) {
            if sqlite3_prepare_v2(db, "SELECT * FROM 'papildoma'", -1, &statement, nil) == SQLITE_OK {
                var ii = 1
                while sqlite3_step(statement) == SQLITE_ROW {
                    if(ii == 1) { dppr = String(describing: String(cString: sqlite3_column_text(statement, 1))) }
                    if(ii == 2) { dpvi = String(describing: String(cString: sqlite3_column_text(statement, 1))) }
                    if(ii == 3) { dppa = String(describing: String(cString: sqlite3_column_text(statement, 1))) }
                    ii += 1
                }
              let a1dr = indek["AD1R"] ?? ""
              if(a1dr.count > 2)  {
                  let dpprx = dppr.replacingOccurrences(of: "class=\"DPR\"", with:  " style=\"display: none;\"");
                dppr=dpprx.replacingOccurrences(of: "<div class=\"AD1R\"></div>", with: "<div class=\"AD1R\">"+a1dr+"</div>");
              }
                let a2dr = indek["AD2R"] ?? ""
              if(a2dr.count > 2)  {
                let dpvix = dpvi.replacingOccurrences(of: "class=\"DPR\"", with:  " style=\"display: none;\"");
                  dpvi=dpvix.replacingOccurrences(of: "<div class=\"AD2R\"></div>", with: "<div class=\"AD2R\">"+a2dr+"</div>");
              }
                let a3dr = indek["AD3R"] ?? ""
              if(a3dr.count  > 2)  {
                  let dppax = dppa.replacingOccurrences(of: "class=\"DPR\"", with:  " style=\"display: none;\"");
                  dppa = dppax.replacingOccurrences(of: "<div class=\"AD3R\"></div>", with: "<div class=\"AD3R\">"+a3dr+"</div>");
              }
            }
          }
        //print("F406_D",lit_per)
        var tekstar = "<p style='color:red; ' >Arba:</p>"
        query =  "SELECT * FROM 'index'"
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let key = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                let valanda = sqlite3_column_int(statement, 0)
                var teksas:String = indek[key] ?? ""
                if key == "DH11" && indek.keys.contains("DH1") {teksas = indek["DH1"] ?? ""}
                if key == "DH21" && indek.keys.contains("DH2") {teksas = indek["DH2"] ?? ""}
                if key == "DH31" && indek.keys.contains("DH3") {teksas = indek["DH3"] ?? ""}

                var tekstas:String = teksas.replacingOccurrences(of: "<span class=\"KK\"></span>", with: kreipinys)
                if(key == "sv") {tekstas = "<div id='sv'>" + tekstas + "</div>"}
              //  if(MMdd == "1102" & key == ){

            switch  valanda {
            case 1:
                ausrin += tekstas

            case 2:
                rytmet += tekstas
                //print("424_D",key,tekstas)
    
            case 3:
                //print("424_D",key,tekstas)
                /*        if((lit_per == "adv" && pdata <"1216") || pdata < "0106" || pdata > "1224")
                 { $("#DH12").addClass('d-none');$("#DH22").addClass('d-none');$("#DH32").addClass('d-none');
                 $("#DH1A").addClass('d-none');$("#DH2A").addClass('d-none');$("#DH3A").addClass('d-none');    }
                 if((pdata >"1216" && pdata <"1225") || (pdata > "0105" && data_md <= d_krik_md))
                 */
                if( key == "DH11") {
                    if(((MMdd > "1216") && (MMdd < "1225"))  || (MMdd > "0105" && data_md <= krk_md ))  {tekstas = "";
                        tekstar = "<p style='color:red; font-variant-caps: small-caps;  '  >Himnas</p>";
                    }
                   // print("F423_D",tekstar)
                }
                if( key == "DH12") {  // kaledinis
                    //print("445_D",key,lit_per,tekstas)
                    if(((lit_per == "adv") && (MMdd < "1217")) || MMdd < "0106" || MMdd > "1224" || lit_per == "gav" || lit_per == "gad" || lit_per == "ve8" || lit_per == "ve3" || lit_per == "vel") {tekstas = "";
                        tekstar = ""
                    }
                    else {tekstas = tekstar + tekstas}
                }
                if( key == "D1S") {  priesp += dppr    }
                priesp += tekstas
                //print("453_D",key,teksas)
            case 4:
                if( key == "DH21") {
                    if(((MMdd > "1216") && (MMdd < "1225"))  || (MMdd > "0105" && data_md <= krk_md ))   {tekstas = "";
                        tekstar = "<p style='color:red; font-variant-caps: small-caps;  '  >Himnas</p>";
                    }
                }
                if( key == "DH22") {  // kaledinis
                    if(((lit_per == "adv") && (MMdd < "1217")) || MMdd < "0106" || MMdd > "1224" || lit_per == "gav" || lit_per == "gad" || lit_per == "ve8" || lit_per == "ve3" || lit_per == "vel") {tekstas = "";
                        tekstar = ""
                    }
                    else {tekstas = tekstar + tekstas}
                }
                if( key == "D2S") {  vidut += dpvi    }
                vidut += tekstas
            case 5:
                if( key == "DH31") {
                    if(((MMdd > "1216") && (MMdd < "1225"))  || (MMdd > "0105" && data_md <= krk_md ))   {tekstas = "";
                        tekstar = "<p style='color:red; font-variant-caps: small-caps;  '  >Himnas</p>";
                    }
                }
                if( key == "DH32") {  // kaledinis
                    if(((lit_per == "adv") && (MMdd < "1217")) || MMdd < "0106" || MMdd > "1224" || lit_per == "gav" || lit_per == "gad" || lit_per == "ve8" || lit_per == "ve3" || lit_per == "vel")  {tekstas = "";
                        tekstar = ""
                    }
                    else {tekstas = tekstar + tekstas}
                }
                if( key == "D3S") {  pavak += dppa    }
                pavak += tekstas
            case 6:
                vakar += tekstas
            default:
                let rezervas = ""
            }
        }
            if(sav_diena > 0) {
            priesp = "<style> div.DDP2, div.DDP3, div.DP1 { display:none; }  </style>" + priesp
            vidut = "<style> div.DDP1, div.DDP3, div.DP1 { display:none; }  </style>" + vidut
            pavak = "<style> div.DDP1, div.DDP2, div.DP1 { display:none; }  </style>" + pavak
            } else {
                priesp = "<style> div.DDP2, div.DDP3, div.DP0 { display:none; }  </style>" + priesp
                vidut = "<style> div.DDP1, div.DDP3, div.DP0 { display:none; }  </style>" + vidut
                pavak = "<style> div.DDP1, div.DDP2, div.DP0 { display:none; }  </style>" + pavak
            }
            if (kreipinys.isEmpty) {
                let Aus = ausrin.replacingOccurrences(of: ", aleliuja", with: "")
                ausrin = Aus.replacingOccurrences(of: "Aleliuja", with: "")
                ausrin = Aus.replacingOccurrences(of: "aleliuja", with: "")
                let Ryt = rytmet.replacingOccurrences(of: ", aleliuja", with: "")
                rytmet = Ryt.replacingOccurrences(of: "Aleliuja", with: "")
                rytmet = Ryt.replacingOccurrences(of: "aleliuja", with: "")
                let Pri = priesp.replacingOccurrences(of: ", aleliuja", with: "")
                priesp = Pri.replacingOccurrences(of: "Aleliuja", with: "")
                let Vid = vidut.replacingOccurrences(of: ", aleliuja", with: "")
                vidut = Vid.replacingOccurrences(of: "Aleliuja", with: "")
                let Pav = pavak.replacingOccurrences(of: ", aleliuja", with: "")
                pavak = Pav.replacingOccurrences(of: "Aleliuja", with: "")
                let Vak = vakar.replacingOccurrences(of: ", aleliuja", with: "")
                vakar = Vak.replacingOccurrences(of: "Aleliuja", with: "")
                vakar = Vak.replacingOccurrences(of: "aleliuja", with: "")
                //Nak = Nak.replace("Aleliuja.", "");
            }

            
        }
    }
    mutating func uzpildymas() {
        //print("Uzpildymas_D",dtime())
        if (sav_diena == 0) { sekm_malda() }
        var tekstas: String = ""
        var statement: OpaquePointer?
        //priegiesmis
        var query = "SELECT tekstas FROM 'psalmynas' WHERE failas=" + psal + " and laukas='IR' LIMIT 1"
         if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
             while sqlite3_step(statement)  == SQLITE_ROW {
                 tekstas = String(describing: String(cString: sqlite3_column_text(statement, 0)))
             }
         }
        indek["IR"] = tekstas
        //psalmyno nuskaitymas
        var laukas:String = ""
         query = "SELECT * FROM 'psalmynas' WHERE failas=" + psal
         if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
             while sqlite3_step(statement)  == SQLITE_ROW {
                 laukas = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                tekstas = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                indek[laukas] = tekstas
             }
         }
        //skaitiniu nuskaitymas
        query = "SELECT * FROM 'skaitiniai' WHERE failas='" + skt + "'"
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement)  == SQLITE_ROW {
                laukas = String(describing: String(cString: sqlite3_column_text(statement, 1)))
               tekstas = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                indek[laukas] = tekstas
            }
        }
        //print("503_D",indek["D1R"])
    }
    mutating func iskbendr() {
        var statement: OpaquePointer?
        var laukas:String = ""
        var tekstas:String = ""
        let isk_ben = duomenys.isk_ben
        let isk_bend:String = isk_ben[iskk] ?? ""
        let query = "SELECT * FROM 'bendrieji' WHERE failas='" + isk_bend + "'"
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement)  == SQLITE_ROW {
                laukas = String(describing: String(cString: sqlite3_column_text(statement, 1)))
               tekstas = String(describing: String(cString: sqlite3_column_text(statement, 2)))
               indek[laukas] = tekstas
            }
        }
        //print("451_D",marprieg)
        if(marprieg.count > 5) { indek["MP"] = marprieg }
        if (!Zprieg.isEmpty) { indek["ZP"] = Zprieg }

        iskil_uzp();
        //print("583_D call")
    }
    mutating func iskil_uzp() {
        //print("584_D iskil_uzp")
        var statement: OpaquePointer?
        var laukas:String = ""
        var tekstas:String = ""
        var malda2:String = ""
        let query = "SELECT * FROM 'iskilmes' WHERE failas='" + iskk + "'"
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement)  == SQLITE_ROW {
                laukas = String(describing: String(cString: sqlite3_column_text(statement, 1)))
               tekstas = String(describing: String(cString: sqlite3_column_text(statement, 2)))
               indek[laukas] = tekstas
                if laukas == "DM" { malda2 = tekstas}
              //  if(laukas=="R2P") { print("516_D",indek["R2P"]) }
            }
        }
        
        let malda = indek["AM"]
        if malda2.isEmpty { malda2 = malda ?? ""}
        if(MMdd != "1225") {indek["RL"] = malda }
        if(iskk != "mbm" ) {
        indek["D1M"] = malda2
        indek["D2M"] = malda2
        indek["D3M"] = malda2 }
        indek["VL"] = malda
        let isk_tipas = duomenys.isk_tipas
        if (sav_diena == 6 && isk_tipas[iskk] != "is") { isk_sest_vak() }  // išimtis: pseudoiškilmės šeštadinį
          if (sav_diena == 6 && (lit_per == "gav" || lit_per == "adv"))
          { isk_sest_vak() }  //sekm.I vakarines imti
    }
    mutating func isk_sest_vak() {
        var statement: OpaquePointer?
        var query = "SELECT * FROM 'psalmynas' WHERE failas='" + psal + "'";
        if lit_perx == "gav" { query = "SELECT * FROM 'gavenia' WHERE failas='" + "g" + String(savaite) + String(sav_diena)+"'" }
        if(lit_perx == "adv") { query = "SELECT * FROM 'adventas' WHERE failas='" + "ad" + String(savaite) + String(sav_diena) + "'" }
        var laukas:String = ""
        var tekstas:String = ""
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
           while sqlite3_step(statement)  == SQLITE_ROW {
               laukas = String(describing: String(cString: sqlite3_column_text(statement, 1)))
               tekstas = String(describing: String(cString: sqlite3_column_text(statement, 2)))
            if laukas.hasPrefix("V") { indek[laukas] = tekstas }
               if laukas == "MP" { indek[laukas] = tekstas }
           }
        }
        if lit_perx != "gav" {  indek["vkp"] = "<p class=\"auto-style3\"><strong>SEKMADIENIO I Vakarinė</strong></p>" }
        if lit_perx == "gav" { indek["vkp"] = "<p class=\"auto-style3\">" + IntR(iss: (savaite+1)) + " GAVĖNIOS SEKMADIENIS<br><strong>I Vakarinė</strong></p>" }
    }
    mutating func gav_uzpildymas() {
        var statement: OpaquePointer?
        let ps_sav: Int = savaite - Int((savaite - 1) / 4) * 4
        //ps_sav = (int) (savaite - Math.floor((savaite - 1) / 4) * 4);
        //gav_tekstai ='tekstai/gavenia/g'+savaite+diena+'.html';
        let vps:String =  String(ps_sav) + String(sav_diena)
        var query = "SELECT * FROM 'psalmynas' WHERE failas='" + vps + "'"
        //var query = "SELECT * FROM 'gavenia' WHERE failas='" + vps + "'"
        
        //print("F608_D",vps,savaite,Int((savaite - 1) / 4),Int((savaite - 1) / 4) * 4)
        var laukas:String = ""
        var tekstas:String = ""
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
           while sqlite3_step(statement)  == SQLITE_ROW {
               laukas = String(describing: String(cString: sqlite3_column_text(statement, 1)))
               tekstas = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                indek[laukas] = tekstas
           }
        }
        if (data_md < pel_md + 4) {savaite = 0}
        let vfailas = "g" + String(savaite) + String(sav_diena)
        query = "SELECT * FROM 'gavenia' WHERE failas='" + vfailas + "'"
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
           while sqlite3_step(statement)  == SQLITE_ROW {
               laukas = String(describing: String(cString: sqlite3_column_text(statement, 1)))
               tekstas = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                indek[laukas] = tekstas
           }
        }
        //print("F631_D",vfailas,indek["A1P"])
        let malda = indek["AM"]
        var malda2:String = malda ?? ""
        if indek["DDM"] != nil { malda2 = indek["DDM"] ?? "" }
        indek["RL"] = malda
        indek["D1M"] = malda2
        indek["D2M"] = malda2
        indek["D3M"] = malda2
        //indek["VL"] = malda
        if(sav_diena != 6) { indek["VL"] = malda }

    }
    mutating func vel_uzpildymas() {
        let vdiena = data_md - vel_md
        savaite = (vdiena / 7) + 1
        var vsav:Int = savaite
        if(vsav > 4) { vsav -= 4 }
        let vps:String = String(vsav) + String(sav_diena)
        var statement: OpaquePointer?
        var query = "SELECT * FROM 'psalmynas' WHERE failas='" + vps + "'"
        var laukas:String = ""
        var tekstas:String = ""
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
           while sqlite3_step(statement)  == SQLITE_ROW {
               laukas = String(describing: String(cString: sqlite3_column_text(statement, 1)))
               tekstas = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                indek[laukas] = tekstas
           }
        }
        if(data_md == vel_md+7) {    savaite = 2 }
        let vfailas = "v" + String(savaite) + String(sav_diena)
        query = "SELECT * FROM 'velykos' WHERE failas='" + vfailas + "'"
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
           while sqlite3_step(statement)  == SQLITE_ROW {
               laukas = String(describing: String(cString: sqlite3_column_text(statement, 1)))
               tekstas = String(describing: String(cString: sqlite3_column_text(statement, 2)))
            if(laukas != "ZP") {
                indek[laukas] = tekstas } else {
                    if(indek[laukas]!.count < 5) {indek[laukas] = tekstas}
                    indek[laukas] = tekstas
                }
                }
        }
        let malda = indek["AM"]
        var malda2:String = malda ?? ""
        if indek["DDM"] != nil { malda2 = indek["DDM"] ?? "" }
        indek["RL"] = malda
        indek["D1M"] = malda2
        indek["D2M"] = malda2
        indek["D3M"] = malda2
        if(sav_diena != 6 ) {  indek["VL"] = malda }
        if(sav_diena == 6 && ikkr.isEmpty )  {
            indek["vkp"] = "<p class=\"auto-style3\"><strong>" + laikasV + "<br><br>I Vakarinė</strong></p>" }
    }
    mutating func gd3_uzpildymas() {
        let gfailas:String = "d"+String(sav_diena)
        var statement: OpaquePointer?
        let query = "SELECT * FROM 'gavenia' WHERE failas='" + gfailas + "'"
        var laukas:String = ""
        var tekstas:String = ""
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
           while sqlite3_step(statement)  == SQLITE_ROW {
               laukas = String(describing: String(cString: sqlite3_column_text(statement, 1)))
               tekstas = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                indek[laukas] = tekstas
           }
        }
        let malda = indek["AM"]
        var malda2:String = malda ?? ""
        if indek["DDM"] != nil { malda2 = indek["DDM"] ?? "" }
        indek["RL"] = malda
        indek["D1M"] = malda2
        indek["D2M"] = malda2
        indek["D3M"] = malda2
        indek["VL"] = malda
    }
    mutating func adv_uzpildymas() {
        let afailas:String = "ad" + String(savaite) + String(sav_diena)
        var statement: OpaquePointer?
        var query = "SELECT * FROM 'adventas' WHERE failas='" + afailas + "'"
        var laukas:String = ""
        var tekstas:String = ""
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
           while sqlite3_step(statement)  == SQLITE_ROW {
               laukas = String(describing: String(cString: sqlite3_column_text(statement, 1)))
               tekstas = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                indek[laukas] = tekstas
           }
        }
        let malda = indek["AM"]
        var malda2:String = malda ?? ""
        if indek["DDM"] != nil { malda2 = indek["DDM"] ?? "" }
        indek["RL"] = malda
        indek["D1M"] = malda2
        indek["D2M"] = malda2
        indek["D3M"] = malda2
        indek["VL"] = malda
        //adventinis psalmynas
        let apfailas:String = "ps" + String(savaite) + String(sav_diena)
        query = "SELECT * FROM 'adventas' WHERE failas='" + apfailas + "'"
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
           while sqlite3_step(statement)  == SQLITE_ROW {
               laukas = String(describing: String(cString: sqlite3_column_text(statement, 1)))
               tekstas = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                indek[laukas] = tekstas
           }
        }
        //
        query = "SELECT * FROM 'adventas' WHERE failas='iki1217'"
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
           while sqlite3_step(statement)  == SQLITE_ROW {
               laukas = String(describing: String(cString: sqlite3_column_text(statement, 1)))
               tekstas = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                indek[laukas] = tekstas
           }
        }
        indek["AD1R"] = indek["r1"]
        indek["AD2R"] = indek["r2"]
        indek["AD3R"] = indek["r3"]
        indek["D1R"] = ""
        indek["D2R"] = ""
        indek["D3R"] = ""
        //print("F712_D")
      /*  Cursor cuik = myDB.rawQuery("SELECT * FROM 'adventas' WHERE failas='iki1217'", null);
           if (cuik.moveToFirst()) {
               do {
                   malda = cuik.getString(1);
                   HM.put(malda, cuik.getString(2).replace("\n", " "));
                   //                  Log.d("mx", "1280 malda: "+malda+" "+ HM.get(malda).toString() );
               } while (cuik.moveToNext());
           }
           cuik.close();
           HM.put("AD1R", HM.get("r1"));
           HM.put("AD2R", HM.get("r2"));
           HM.put("AD3R", HM.get("r3"));
           HM.put("D1R", "");
           HM.put("D2R", "");
           HM.put("D3R", ""); */
        //
        if(lit_per == "ksp") {
                   // po1216
            query = "SELECT * FROM 'adventas' WHERE failas='po1216'"
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
               while sqlite3_step(statement)  == SQLITE_ROW {
                   laukas = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                   tekstas = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                    indek[laukas] = tekstas
               }
            }
            //prieg1724
            if(sav_diena > 0) {
                query = "SELECT * FROM 'adventas' WHERE failas='prieg17-24'"
                if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
                   while sqlite3_step(statement)  == SQLITE_ROW {
                       laukas = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                       tekstas = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                        indek[laukas] = tekstas
                   }
                }
                let pr1 = indek["r"+String(sav_diena)+"1"]
                let pr2 = indek["r"+String(sav_diena)+"2"]
                let pr3 = indek["r"+String(sav_diena)+"3"]
                indek["R1R"] = pr1
                indek["V1R"] = pr1
                indek["R2R"] = pr2
                indek["V2R"] = pr2
                indek["R3R"] = pr3
                indek["V3R"] = pr3 }
                indek["D1R"] = ""
                indek["D2R"] = ""
                indek["D3R"] = ""
                if(MMdd == "1224") { //prie1224
                    indek["IR"] = "<p><span style=\"color:#FF0000;\">Prieg. </span><span>Šiandien sužinosit, kad Viešpats ateina,<br/>rytoj pamatysit jo garbę.</span></p>"
                    indek["R1R"] = "<p><span style=\"color:#FF0000;\">1 prieg. </span><span>Tu, Judo žemės Betliejau, nebūsi menkiausias;<br>iš tavęs išeis vadas,<br>kuris ganys mano tautą – Izraelį.</span></p>"
                    indek["R2R"] = "<p><span style=\"color:#FF0000;\">2 prieg. </span><span>Pakelkite galvas,<br>nes jūsų atpirkimas artėja.</span></p>"
                    indek["R3R"] = "<p><span style=\"color:#FF0000;\">3 prieg. </span><span>„Rytoj ateis jums išgelbėjimas“, –<br>sako Viešpats, galybių Dievas.</span></p>"
                }
                //diena_po1216
                let maldax = indek["AM"]
                query = "SELECT * FROM 'adventas' WHERE failas='" + MMdd + "'"
                if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement)  == SQLITE_ROW {
                   laukas = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                   tekstas = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                    if(sav_diena > 0) { indek[laukas] = tekstas }
                    if((sav_diena == 0) && (laukas == "MP" )) { indek[laukas] = tekstas }
                    if((sav_diena == 0) && (laukas.prefix(1) == "A" )) { indek[laukas] = tekstas }

                    }
                }
                var malda = indek["AM"]
            if(sav_diena == 0) { malda=maldax }
            indek["RL"] = malda
            indek["D1M"] = malda
            indek["D2M"] = malda
            indek["D3M"] = malda
            indek["VL"] = malda
            indek["AM"] = malda
        }
        // 1V užpildymas
        if(sav_diena == 6) {
            laikasV =  IntR(iss: (savaite+1)) + " ADVENTO SEKMADIENIS"
            query = "SELECT * FROM 'adventas' WHERE failas='ad" + String(savaite+1) + "0-1V'"
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement)  == SQLITE_ROW {
               laukas = String(describing: String(cString: sqlite3_column_text(statement, 1)))
               tekstas = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                indek[laukas] = tekstas
                }
            }
            query = "SELECT * FROM 'adventas' WHERE failas='ps" + String(savaite+1) + "0-1V'"
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement)  == SQLITE_ROW {
               laukas = String(describing: String(cString: sqlite3_column_text(statement, 1)))
               tekstas = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                indek[laukas] = tekstas
                }
            }
            
        }
    }
    mutating func kal_uzpildymas() {
       
         // 1. psalmynas
        var dd1p:String = ""
        var dd2p:String = ""
        var dd3p:String = ""
        var statement: OpaquePointer?
        var laukas:String = ""
        var tekstas:String = ""
        let vps = String(savaite) + String(sav_diena)
        var SQL:String = "SELECT * FROM 'psalmynas' WHERE failas='" + vps + "'"
        if sqlite3_prepare_v2(db, SQL, -1, &statement, nil) == SQLITE_OK {
           while sqlite3_step(statement)  == SQLITE_ROW {
               laukas = String(describing: String(cString: sqlite3_column_text(statement, 1)))
               tekstas = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                indek[laukas] = tekstas
           }
        }
        //print("F829_D",indek["D1R"])
        dd1p = indek["D1P"] ?? ""
        dd2p = indek["D2P"] ?? ""
        dd3p = indek["D3P"] ?? ""
        if(data_md < krk_md) {
            var savnr:String = "1";
            if(data_md-1 > sav_diena) { savnr="2" }
            let apfailas = "ps" + savnr + String(sav_diena)
            SQL = "SELECT * FROM 'adventas' WHERE failas='" + apfailas + "'"
            if sqlite3_prepare_v2(db, SQL, -1, &statement, nil) == SQLITE_OK {
               while sqlite3_step(statement)  == SQLITE_ROW {
                   laukas = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                   tekstas = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                    indek[laukas] = tekstas
               }
            }
        }
 

             var kd:String = MMdd
            if(data_md > 6 && data_md < krk_md) { kd="sd"+String(data_md - kra_md) }  //tarp triejų karalių ir kristaus krikšto
            //print("844_D",kd)
             SQL = "SELECT * FROM 'kaledos' WHERE failas='" + kd + "'"
            if sqlite3_prepare_v2(db, SQL, -1, &statement, nil) == SQLITE_OK {
               while sqlite3_step(statement)  == SQLITE_ROW {
                   laukas = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                   tekstas = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                    indek[laukas] = tekstas
               }
            }
        let kvl = indek["VL"]
            if(sav_diena == 0 && iskk.isEmpty) {
                 kd = "2ks";  //antras kalėdų sekmadienis
                 SQL = "SELECT * FROM 'kaledos' WHERE failas='" + kd + "'";
                if sqlite3_prepare_v2(db, SQL, -1, &statement, nil) == SQLITE_OK {
                   while sqlite3_step(statement)  == SQLITE_ROW {
                       laukas = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                       tekstas = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                        indek[laukas] = tekstas
                   }
                }
             }
            let malda:String = indek["AM"] ?? ""
            indek["RL"] = malda
                indek["D1M"] = malda
                indek["D2M"] = malda
                indek["D3M"] = malda
        if(MMdd == "1228") {indek["VL"] = malda}
        //print("875_D",lit_per,indek["VL"])
        if(lit_per != "ka8") {indek["VL"] = malda} else { indek["VL"] = kvl        }
        
             if(data_md > kal_md) {
                indek["D1P"] = dd1p
                indek["D2P"] = dd2p
                indek["D3P"] = dd3p
             }
        //print("F881_D",indek["D1R"])
        }
    
    mutating func  k2s_v_1_uzpildymas() {
        let kd = "2s-1V";  //antras kalėdų sekmadienis
        laikasV = "II KALĖDŲ SEKMADIENIS";
        var statement: OpaquePointer?
        var laukas:String = ""
        var tekstas:String = ""
        let SQL = "SELECT * FROM 'kaledos' WHERE failas='" + kd + "'"
        if sqlite3_prepare_v2(db, SQL, -1, &statement, nil) == SQLITE_OK {
           while sqlite3_step(statement)  == SQLITE_ROW {
               laukas = String(describing: String(cString: sqlite3_column_text(statement, 1)))
               tekstas = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                indek[laukas] = tekstas
           }
        }
        }
    mutating func sventojo_uzp(){
        //1. koks tas šventasis
        var sv_ind:String = MMdd
        if(pnr == 3) {sv_ind += "a"}
        if(pnr == 4) {sv_ind += "b"}
        if(pnr == 2 && sv0.contains("šeštadienis")) {sv_ind = "1402"}
        if(pnr == 3 && sv1.contains("šeštadienis")) {sv_ind = "1402"}
        if(pnr == 4 && sv2.contains("šeštadienis")) {sv_ind = "1402"}
        //print("782_D",sv_ind)
        var vak_malda:String = ""
        var statement: OpaquePointer?
        var tekstas: String = ""
        var laukas: String = ""
        if(lit_per != "vel" && lit_per != "adv") {
            let query = "SELECT * FROM 'skaitiniai' WHERE failas='" + skt + "'"
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement)  == SQLITE_ROW {
                    laukas = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                   tekstas = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                    indek[laukas] = tekstas
                    if(laukas == "VL") { vak_malda = tekstas}
                }
            }
        }
        //print("F923_D",indek["D1R"])
        //reikiamus parametrus pasirenkame
        if(sv_ind == "1402") { tipas="la" }
        var uzpil:  [String:  String] = [:]
        if(tipas == "la") { uzpil = duomenys.uzp_la }
        if(tipas == "pr") { uzpil = duomenys.uzp_pr }
        if(tipas == "sv") { uzpil = duomenys.uzp_sv }
        if(tipas == "is") { uzpil = duomenys.uzp_is }
        //bendraisiais uzpildom
        var bend:String = ""
        var benda:[String] = []
        if let bendx = duomenys.bendrieji[sv_ind] {
            bend = bendx
           benda = bend.components(separatedBy: ",")
            
        }
        for (key, names) in uzpil {
            let malda = key
            let p1 = Array(names)[0]
            let p2 = Array(names)[1]
            let p3 = Array(names)[2]
            if (p1 == "1" && lit_per != "vel" && lit_per != "adv" ) {
                let query = "SELECT tekstas FROM 'psalmynas' WHERE failas='" + psal + "' and laukas='" + malda + "' LIMIT 1"
                if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
                    while sqlite3_step(statement)  == SQLITE_ROW {
                        indek[malda] = String(describing: String(cString: sqlite3_column_text(statement, 0)))
                    }
                }
            }
            if (p2 == "1") {
                for bendr in benda {
                    let query = "SELECT * FROM 'bendrieji' WHERE failas='" + bendr + "' and laukas='" + malda + "'"
                    if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
                        while sqlite3_step(statement)  == SQLITE_ROW {
                            indek[malda] = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                        }
                    }
                }
            }
            if (p3 == "1") {
                let query = "SELECT tekstas FROM 'sventieji' WHERE failas='" + sv_ind + "' and laukas='" + malda + "'"
                if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
                    while sqlite3_step(statement)  == SQLITE_ROW {
                        indek[malda] = String(describing: String(cString: sqlite3_column_text(statement, 0)))
                    }
                }
            }

        } //for
 
        //priegiesmio sventojo vardą
        var query = "SELECT tekstas FROM 'sventieji' WHERE failas='" + sv_ind + "' and laukas='vvardas' LIMIT 1"

        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement)  == SQLITE_ROW {
                svvx = String(describing: String(cString: sqlite3_column_text(statement, 0)))
            }
        }
        //apie šventąjį
        query = "SELECT tekstas FROM 'sventieji' WHERE failas='" + sv_ind + "' and laukas='sv' LIMIT 1"
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement)  == SQLITE_ROW {
                indek["sv"] = String(describing: String(cString: sqlite3_column_text(statement, 0)))
            }
        }
        let am = indek["AM"]
        indek["RL"] = am
        
        if (lit_per != "ka8") { indek["VL"] = am }
        //if (MMdd == "1228")  { indek["VL"] = am }
        //print("F992_D",indek["VL"],lit_per)
         if (tipas == "sv" || tipas == "is") {
             //print("F992_D",indek["D1R"])
             indek["D1M"] = am
            indek["D2M"] = am
            indek["D3M"] = am
             //užpildyti iš psalmių
            query = "SELECT * FROM 'psalmes'"
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement)  == SQLITE_ROW {
                    if String(describing: String(cString: sqlite3_column_text(statement, 0))) == "62" {
                        indek["R1P"] = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                    }
                    if String(describing: String(cString: sqlite3_column_text(statement, 0))) == "149" {
                        indek["R2P"] = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                    }
                    if String(describing: String(cString: sqlite3_column_text(statement, 0))) == "Dan" {
                        indek["RG"] = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                    }
                    if (tipas == "is") {
                        if String(describing: String(cString: sqlite3_column_text(statement, 0))) == "1171" {
                            indek["D1P"] = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                        }
                        if String(describing: String(cString: sqlite3_column_text(statement, 0))) == "1172" {
                            indek["D2P"] = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                        }
                        if String(describing: String(cString: sqlite3_column_text(statement, 0))) == "1173" {
                            indek["D3P"] = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                        }
                    }
                }
            }
         }
        var prieg = indek["IR"]
        if (sav_diena == 6) {
            query  = "SELECT * FROM 'psalmynas' WHERE failas='" + psal + "'"
            if(lit_per == "vel") {
                let vdiena: Int = data_md - vel_md
                 savaite = (vdiena / 7) + 1
                if(data_md == vel_md+7) {    savaite = 2 }
                let vfailas = "v" + String(savaite) + String(sav_diena)
                query = "SELECT * FROM 'velykos' WHERE failas='" + vfailas + "'"
            }
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement)  == SQLITE_ROW {
                    let malda = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                    if (malda.contains("V") || malda.contains("MP") ) {
                        indek[malda] = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                    }
                }
            }
            if(lit_per != "vel") {indek["VL"] = vak_malda }
            if(marprieg.count>5 && lit_per != "vel") { indek["MP"] =  marprieg }
            indek["vkp"] = "<p class=\"auto-style3\"><strong>"+laikasV+"<br><br>I Vakarinė</strong></p>"
            
            
        }
      //  print("F1047_D",indek["VL"])
    }
    mutating func sekm_malda() {
        var statement: OpaquePointer?
        var tekstas: String = ""
       var query = "SELECT tekstas FROM 'sekm_malda' WHERE laukas='m" + String(eil_sav) + "' LIMIT 1"
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement)  == SQLITE_ROW {
                tekstas = String(describing: String(cString: sqlite3_column_text(statement, 0)))
            }
        }
        tekstas = "<p class=\"auto-style13\">Malda<br /></p><p>" + tekstas + "</p>"
        indek["AM"] = tekstas
        indek["RL"] = tekstas
        indek["VL"] = tekstas
        indek["D1M"] = tekstas
        indek["D2M"] = tekstas
        indek["D3M"] = tekstas
        query = "SELECT tekstas FROM 'sekm_malda' WHERE laukas='mahd' LIMIT 1"
         if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
             while sqlite3_step(statement)  == SQLITE_ROW {
                 tekstas = String(describing: String(cString: sqlite3_column_text(statement, 0)))
                 indek["AHD"] = tekstas
             }
         }
    }
    func IntR(iss: Int) -> String {
        var integerValue:Int = iss
        var numeralString = ""
            let mappingList: [(Int, String)] = [(1000, "M"), (900, "CM"), (500, "D"), (400, "CD"), (100, "C"), (90, "XC"), (50, "L"), (40, "XL"), (10, "X"), (9, "IX"), (5, "V"), (4, "IV"), (1, "I")]
            for i in mappingList {
                while (integerValue >= i.0) {
                    integerValue -= i.0
                    numeralString += i.1
                }
            }
            return numeralString
       
    }

}

