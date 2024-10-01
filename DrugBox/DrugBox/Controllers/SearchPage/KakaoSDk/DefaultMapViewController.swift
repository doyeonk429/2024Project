//
//  DefaultMapViewController.swift
//  DrugBox
//
//  Created by 김도연 on 9/25/24.
//
//
//import UIKit
//import SnapKit
//import Then
//import KakaoMapsSDK
//
//class DefaultMapViewController: UIViewController, MapControllerDelegate {
//    
//    var mapContainer: KMViewContainer?
//    var mapController: KMController?
//    var _observerAdded: Bool
//    var _auth: Bool
//    var _appear: Bool
//    
//    init() {
//        _observerAdded = false
//        _auth = false
//        _appear = false
//        super.init(nibName: nil, bundle: nil) // Use nibName and bundle as nil for programmatic use
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        _observerAdded = false
//        _auth = false
//        _appear = false
//        super.init(coder: aDecoder)
//    }
//    
//    
//    deinit {
//        mapController?.pauseEngine()
//        mapController?.resetEngine()
//        print("deinit")
//    }
//    
//    override func loadView() {
//        // Set the main view as KMViewContainer
//        self.view = KMViewContainer()
//    }
//    
//    override func viewDidLoad() {
//        
//        super.viewDidLoad()
//        
//        self.navigationItem.hidesBackButton = false
//        self.navigationController?.navigationBar.prefersLargeTitles = false
//        
//        // Cast the main view to KMViewContainer after loadView() sets it
//        guard let container = self.view as? KMViewContainer else {
//            print("Error: View is not of type KMViewContainer")
//            return
//        }
//        mapContainer = container
//        
//        mapController = KMController(viewContainer: mapContainer!)
//        mapController?.delegate = self
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        addObservers()
//        _appear = true
//        if mapController?.isEnginePrepared == false {
//            mapController?.prepareEngine()
//        }
//        
//        if mapController?.isEngineActive == false {
//            mapController?.activateEngine()
//        }
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        _appear = false
//        mapController?.pauseEngine()  //렌더링 중지.
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        removeObservers()
//        mapController?.resetEngine()     //엔진 정지. 추가되었던 ViewBase들이 삭제된다.
//    }
//    
//    // 인증 성공시 delegate 호출.
//    func authenticationSucceeded() {
//        // 일반적으로 내부적으로 인증과정 진행하여 성공한 경우 별도의 작업은 필요하지 않으나,
//        // 네트워크 실패와 같은 이슈로 인증실패하여 인증을 재시도한 경우, 성공한 후 정지된 엔진을 다시 시작할 수 있다.
//        if _auth == false {
//            _auth = true
//        }
//        
//        if _appear && mapController?.isEngineActive == false {
//            mapController?.activateEngine()
//        }
//    }
//    
//    // 인증 실패시 호출.
//    func authenticationFailed(_ errorCode: Int, desc: String) {
//        print("error code: \(errorCode)")
//        print("desc: \(desc)")
//        _auth = false
//        switch errorCode {
//        case 400:
//            showToast(self.view, message: "지도 종료(API인증 파라미터 오류)")
//            break;
//        case 401:
//            showToast(self.view, message: "지도 종료(API인증 키 오류)")
//            break;
//        case 403:
//            showToast(self.view, message: "지도 종료(API인증 권한 오류)")
//            break;
//        case 429:
//            showToast(self.view, message: "지도 종료(API 사용쿼터 초과)")
//            break;
//        case 499:
//            showToast(self.view, message: "지도 종료(네트워크 오류) 5초 후 재시도..")
//            
//            // 인증 실패 delegate 호출 이후 5초뒤에 재인증 시도..
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//                print("retry auth...")
//                
//                self.mapController?.prepareEngine()
//            }
//            break;
//        default:
//            break;
//        }
//    }
//    
//    func addViews() {
//        //여기에서 그릴 View(KakaoMap, Roadview)들을 추가한다.
//        let defaultPosition: MapPoint = MapPoint(longitude: 127.108678, latitude: 37.402001)
//        //지도(KakaoMap)를 그리기 위한 viewInfo를 생성
//        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 7)
//        
//        //KakaoMap 추가.
//        mapController?.addView(mapviewInfo)
//    }
//    
//    func viewInit(viewName: String) {
//        print("OK")
//    }
//    
//    //addView 성공 이벤트 delegate. 추가적으로 수행할 작업을 진행한다.
//    func addViewSucceeded(_ viewName: String, viewInfoName: String) {
//        let view = mapController?.getView("mapview") as! KakaoMap
//        view.viewRect = mapContainer!.bounds    //뷰 add 도중에 resize 이벤트가 발생한 경우 이벤트를 받지 못했을 수 있음. 원하는 뷰 사이즈로 재조정.
//        viewInit(viewName: viewName)
//    }
//    
//    //addView 실패 이벤트 delegate. 실패에 대한 오류 처리를 진행한다.
//    func addViewFailed(_ viewName: String, viewInfoName: String) {
//        print("Failed")
//    }
//    
//    //Container 뷰가 리사이즈 되었을때 호출된다. 변경된 크기에 맞게 ViewBase들의 크기를 조절할 필요가 있는 경우 여기에서 수행한다.
//    func containerDidResized(_ size: CGSize) {
//        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
//        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)   //지도뷰의 크기를 리사이즈된 크기로 지정한다.
//    }
//    
//    func addObservers(){
//        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
//        
//        _observerAdded = true
//    }
//    
//    func removeObservers(){
//        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
//        
//        _observerAdded = false
//    }
//    
//    @objc func willResignActive(){
//        mapController?.pauseEngine()  //뷰가 inactive 상태로 전환되는 경우 렌더링 중인 경우 렌더링을 중단.
//    }
//    
//    @objc func didBecomeActive(){
//        mapController?.activateEngine() //뷰가 active 상태가 되면 렌더링 시작. 엔진은 미리 시작된 상태여야 함.
//    }
//    
//    func showToast(_ view: UIView, message: String, duration: TimeInterval = 2.0) {
//        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 150, y: view.frame.size.height-100, width: 300, height: 35))
//        toastLabel.backgroundColor = UIColor.black
//        toastLabel.textColor = UIColor.white
//        toastLabel.textAlignment = NSTextAlignment.center;
//        view.addSubview(toastLabel)
//        toastLabel.text = message
//        toastLabel.alpha = 1.0
//        toastLabel.layer.cornerRadius = 10;
//        toastLabel.clipsToBounds  =  true
//        
//        UIView.animate(withDuration: 0.4,
//                       delay: duration - 0.4,
//                       options: UIView.AnimationOptions.curveEaseOut,
//                       animations: {
//            toastLabel.alpha = 0.0
//        },
//                       completion: { (finished) in
//            toastLabel.removeFromSuperview()
//        })
//    }
//    
//    
//}
//
