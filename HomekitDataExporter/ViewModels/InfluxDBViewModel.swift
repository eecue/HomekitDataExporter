import SwiftUI

class InfluxDBViewModel: NSObject, ObservableObject {
    private let username = "influxdb_username"
    private let database = "influxdb_database"
    private let password = "influxdb_password"
    private let urlKey = "influxdb_url"
    
    @Published var influxDBUsername: String = ""
    @Published var influxDBDatabase: String = ""
    @Published var influxDBPassword: String = ""
    @Published var influxDBUrl: String = ""
    
    @Published var lastConnectionResult: String = ""
    
    var settingsComplete: Bool {
        return !influxDBUsername.isEmpty
            && !influxDBDatabase.isEmpty
            && !influxDBPassword.isEmpty
            && !influxDBUrl.isEmpty
    }
    
    
    private var timer: Timer!
    private var influxDBService = InfluxDBService()
    private var homeService = HomeService()
    
    
    override init(){
        super.init()
        loadFromUserDefaults()
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        }
    }

    func loadFromUserDefaults() {
        let defaults = UserDefaults.standard
        if let storedUsername = defaults.string(forKey: username) {
            influxDBUsername = storedUsername
        }
        if let storedDatabase = defaults.string(forKey: database) {
            influxDBDatabase = storedDatabase
        }
        if let storedPassword = defaults.string(forKey: password) {
            influxDBPassword = storedPassword
        }
        if let storedUrl = defaults.string(forKey: urlKey) {
            influxDBUrl = storedUrl
        }
    }
    
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(influxDBUsername, forKey: username)
        defaults.set(influxDBDatabase, forKey: database)
        defaults.set(influxDBPassword, forKey: password)
        defaults.set(influxDBUrl, forKey: urlKey)
    }
    
    func testConnection() {
        fireTimer()
    }
    
    
    @objc func fireTimer() {
        if settingsComplete {
            Task {
                let accessoryData = homeService.collectAccessoryData()
                
                let result: String
                do {
                    try await influxDBService.write(username: influxDBUsername, database: influxDBDatabase, password: influxDBPassword, url: influxDBUrl, data:accessoryData)
                    result = "Successfully connected - " + Date().description
                } catch {
                    result  = "Error writing to InfluxDB:\n\n\(error)"
                }
                await MainActor.run {
                    lastConnectionResult = result
                }
            }
        }
    }
}
