//
//  ViewController.swift
//  How is the weather?
//
//  Created by Nayer Kotry on 03/09/2023.
//

import UIKit

class HomeViewController: UIViewController {
  
    

    // MARK: Outlets
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    
    // MARK: Variables
    var searchClicked = false
    var cellSelectedIndex: Int = -1
    
    var homepageViewModel: HomepageViewModel!
    var userLocationManager: UserLocationManager!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homepageViewModel = HomepageViewModel()
        tableViewOutlet.dataSource = self
        tableViewOutlet.delegate = self
        tableViewOutlet.register(UINib(nibName: Constants.Homepage.TableView.nibName, bundle: nil), forCellReuseIdentifier: Constants.Homepage.TableView.identifier)
        searchbar.delegate = self
        hideKeyBoardOnTap()
        homepageViewModel.fetchCities(cities: Constants.defaultCities){ [weak self] Result  in
            switch(Result){
            case .success(_):
                DispatchQueue.main.async {
                    self?.tableViewOutlet.reloadData()
                }
            
            case.failure(let err):
                print(err)
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(setupObserver(_:)), name: NSNotification.Name("DidUpdateLocation "), object: nil)
        
        userLocationManager = UserLocationManager()
        userLocationManager.delegate = self
        userLocationManager.checkIfLocationServicesIsEnabled()
        
        
    }
    
    @objc private func setupObserver(_ notification: NSNotification) {
        print(notification)
    }
    
    //MARK: METHODS
    


    func hideKeyBoardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
    }
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
   
    
}

//MARK: location manager extension
extension HomeViewController: LocationProtocol {
    func locationUpdated(with Coordinates: Coordinates?) {
        guard let coordinates = Coordinates  else {
            return
        }
        let coorStr = "\(coordinates.latitude),\(coordinates.longitude)"
        print(coorStr)
        homepageViewModel.fetchCityWeather(city: coorStr, userLocation: true){ [weak self] Result in
            guard let self = self else { return }
            switch(Result){
            case .failure(let err):
                print(err)
            case .success(let cityWeather):
                
                if let weather = cityWeather {
                    homepageViewModel.setUserCity(with: weather)
                    //                homepageViewModel.setUserCtyUnformatted(with: unformattedcity!)
                    
                    if let userCity = homepageViewModel.getCity(at: 0) {
                        if  userCity.userLocation {
                            homepageViewModel.removeCity(at: 0)
                            homepageViewModel.appendCityFirst(city: weather)
                            homepageViewModel.removeUnformatedCity(at: 0)
                            //                        homepageViewModel.appendUnformatedCityFirst(city: unformattedcity!)
                            return
                        }
                    }
                    homepageViewModel.appendCityFirst(city: weather)
                    //                homepageViewModel.appendUnformatedCityFirst(city: unformattedcity!)
                    self.tableViewOutlet.reloadData()
                }
            }
        }
        
        
       
       
    }
}

//MARK: tableView class extension

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homepageViewModel.getCitiesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Homepage.TableView.identifier, for: indexPath) as! WeatherHomeTableViewCell
        cell.configNib(cityWeather: homepageViewModel.getCity(at: indexPath.row)!)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellSelectedIndex = indexPath.row
        
        performSegue(withIdentifier: Constants.Homepage.segues.homeToDetails, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? WeatherDetailsViewController {
            destinationVC.homeData = homepageViewModel.getCity(at: cellSelectedIndex)
            destinationVC.currentWeatherAPIData = homepageViewModel.getUnformatedCity(at: cellSelectedIndex)
            if let userloc = homepageViewModel.getCity(at: cellSelectedIndex)?.userLocation {
                destinationVC.userLoc = userloc
                
            }
            else {
                destinationVC.userLoc = false
            }
        }
    }
    
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchClicked = true
        searchBar.endEditing(true)
        
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {

        if searchClicked && searchBar.text == "" {
            searchBar.placeholder = "Enter a city.."
            searchClicked = false
            return false
        }
        searchBar.placeholder = "search"
        return true
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        if let inputCity = searchBar.text {
            if searchClicked {
                searchBar.showsCancelButton = true
                searchClicked = false
                print(inputCity)
                homepageViewModel.fetchCityWeather(city: inputCity){ [weak self] Result in
                    guard let self = self else { return }
                    switch(Result){
                    case.failure(let err):
                        print(err)
                    case .success(let cityWeather):
                        if let weather = cityWeather {
                            homepageViewModel.setAllCities(cities: [weather])
    //                        homepageViewModel.setAllUnformatedCities(cities: [unformatted!])
                            self.tableViewOutlet.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        homepageViewModel.fetchCities(cities: Constants.defaultCities){ [weak self] Result  in
            guard let self = self else { return }
            var arrUnformated = self.homepageViewModel.getAllUnformatedCities()
            switch(Result){
            case.failure(let err):
                print(err)
            case .success(let data):
                if var arr = data {
                    if let userCity = self.homepageViewModel.getUserCity() {
                        arr.insert(userCity, at: 0)
//                        arrUnformated.insert(self.homepageViewModel.getUserUnformattedCity()!, at: 0)
                        
                    }
                    self.homepageViewModel.setAllCities(cities: arr)
                    self.homepageViewModel.setAllUnformatedCities(cities: arrUnformated)
                    DispatchQueue.main.async {
                        self.tableViewOutlet.reloadData()
                    }
                }
            }
        }
        searchBar.text = ""
        searchBar.showsCancelButton = false
    }
    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchBar.showsCancelButton = true
//    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("touched")
//        self.view.endEditing(true)
//    }
    //func searchBar
}


