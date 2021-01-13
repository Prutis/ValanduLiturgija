//
//  ViewController.swift
//  ValanduLiturgija
//
//  Created by Rutenis Piksrys on 2020-12-31.
//
import SideMenu
import UIKit
import WebKit
import AppCenter
import AppCenterCrashes


class ViewController: UIViewController, WKUIDelegate {
    
    var menu: SideMenuNavigationController?

    @IBOutlet weak var DataB: UIBarButtonItem!

    @IBOutlet weak var Datapicker: UIDatePicker!
    @IBOutlet weak var DPtoolbar: UIToolbar!

    @IBOutlet weak var Naktis: UIBarButtonItem!
    @IBOutlet weak var Check: UIBarButtonItem!
    
    @IBOutlet weak var webview: WKWebView!


    
    var ein_data: Date = Date()
    var ausrin = ""
    var naktis = 0
    var slinktis = 0
    var scrollHeight: CGFloat = 5
    let defaults = UserDefaults.standard
    var pozic:CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppCenter.start(withAppSecret: "11d32172-e9d7-4474-801e-a5d3f2987b2b", services:[
          Crashes.self
        ])
        menu = SideMenuNavigationController(rootViewController: MenuListController())
        menu?.leftSide = true
        menu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        DataB.title = formatter.string(from: ein_data)
        DPtoolbar.isHidden = true
        let path = Bundle.main.path(forResource: "aus",  ofType: "txt")!
        ausrin = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
        //webview.sca
        webview.loadHTMLString(ausrin, baseURL: nil)
        webview.sizeToFit()
        if defaults.object(forKey: "naktis") != nil {
            naktis = defaults.integer(forKey: "naktis") }
        if naktis == 1  { webview.evaluateJavaScript("naktis(1)")
            Naktis.image = UIImage(systemName: "sun.max")
        }
        //Datapicker?.inputAccessoryView = pickerToolbar
       
        // Do any additional setup after loading the view.≈
    }
    @IBAction func didTapMenu() {
        present(menu!,animated: true)
    }

    @IBAction func Xmarkclicked(_ sender: UIBarButtonItem) {
        Datapicker.isEnabled = false
        Datapicker.isHidden = true
        DPtoolbar.isHidden = true
        webview.isHidden = false
    }
    @IBAction func Checkclicked(_ sender: UIBarButtonItem) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        DataB.title = formatter.string(from: Datapicker.date)
        ein_data = Datapicker.date
        Datapicker.isEnabled = false
        Datapicker.isHidden = true
        DPtoolbar.isHidden = true
        webview.isHidden = false
    }
    @IBAction func datapr(_ sender: UIBarButtonItem) {
        webview.isHidden = true
        
        Datapicker.date = ein_data
        Datapicker.isEnabled = true
        Datapicker.isHidden = false
        Datapicker.preferredDatePickerStyle = .inline
        Datapicker.accessibilityViewIsModal = true
        Datapicker.tintColor = UIColor.red
        DPtoolbar.isHidden = false
        DPtoolbar.barTintColor = UIColor.white
        DPtoolbar.tintColor = UIColor.red

    }

    @IBAction func naktis(_ sender: UIBarButtonItem) {
        if naktis == 1  { webview.evaluateJavaScript("naktis(0)")
            naktis = 0
            Naktis.image = UIImage(systemName: "moon.circle")
            defaults.setValue(0, forKey: "naktis")
        } else {naktis = 1
            webview.evaluateJavaScript("naktis(1)")
            Naktis.image = UIImage(systemName: "sun.max")
            defaults.setValue(1, forKey: "naktis")}
        defaults.synchronize()
    }
    
    
    @IBAction func slinktis(_ sender: UIBarButtonItem) { if slinktis == 0 {
        slinktis = 1
        //webview.scrollView.contentOffset.y
        pozic = webview.scrollView.contentOffset.y
        var wvaukstis:CGFloat = webview.scrollView.contentSize.height - UIScreen.main.bounds.height + 160
        //print(wvaukstis)
        scrollHeight = 7
        var timer: Timer?
        Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { [self] timer in
            pozic = webview.scrollView.contentOffset.y+self.scrollHeight
          //  print(pozic)
            webview.scrollView.setContentOffset(CGPoint.init(x: 0.0, y: pozic+scrollHeight), animated: true)

            if slinktis == 0 || pozic > wvaukstis {
                timer.invalidate()
            }
        }

        }  else {
        slinktis = 0
        }
    }
}


class MenuListController: UITableViewController {
    var items = ["Įžanga","Aušrinė","Rytmetinė","Priešpiečio","Vidudienio","Pavakario","Vakarinė","Naktinė","Nustatymai","Apie aplikaciją"]
    var iconos = ["rectangle.righthalf.inset.fill.arrow.right","book","sunrise","sun.max","sun.max","sun.max","sunset","moon","gearshape","doc.text"]
    let darkcolor = UIColor(red: 239/255.0, green: 227/255.0, blue: 206/255.0, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = darkcolor
        //tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.textColor = .black
        cell.backgroundColor = darkcolor
        
        cell.imageView!.image = UIImage(systemName: iconos[indexPath.row])
        cell.tintColor = .black
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
       return "Valandų liturgija"
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        //let hw:UIView = UIView(frame: CGRect(x:0, y:0, width:tableView.bounds.size.width, height:50))
        let hw:UIView = UIView()
        hw.backgroundColor =  UIColor(red: 233/255.0, green: 201/255.0, blue: 177/255.0, alpha: 1)

        return hw
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         let view = UIView(frame: CGRect(x: 0, y: 0, width:tableView.bounds.size.width, height: 50))
        view.backgroundColor =  UIColor(red: 233/255.0, green: 201/255.0, blue: 177/255.0, alpha: 1)
         let label = UILabel(frame: view.frame)
        label.font = label.font.withSize(20)
         label.text = "Valandų liturgija\n Bandomoji versija"
        let label2 = UILabel(frame: view.frame)
       label2.font = label.font.withSize(12)
        label2.text = "Bandomoji versija"
        label.textColor = UIColor(red: 93/255.0, green: 69/255.0, blue: 26/255.0, alpha: 1)
        label.frame = CGRect( x:53, y:1, width:150, height: 30)
        label2.frame = CGRect( x:63, y:27, width:150, height: 20)
        // label.sizeToFit()
        view.addSubview(label)
        view.addSubview(label2)
        var imageView : UIImageView!
        //imageView  = UIImageView(frame:CGRect(x:5, y:5, width:43, height:43));
        
        let image : UIImage = UIImage(named:"Image")!
        imageView = UIImageView(image: image)
        imageView.frame = CGRect(x:5, y:5, width:40, height:40)
        view.addSubview(imageView)
        
         view.frame = CGRect(x: 0, y: 0, width:tableView.bounds.size.width, height: 50)
         return view
    }


}


