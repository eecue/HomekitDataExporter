
import Foundation
import InfluxDBSwift

class InfluxDBService: NSObject, ObservableObject {
    
    func write(username: String, database: String, password: String, url: String, data: [AccessoryData]) async throws {
        
        
        //
        // Initialize Client for v1.8
        //
        let client = InfluxDBClient(
            url: url,
            token: "\(username):\(password)",
            options: InfluxDBClient.InfluxDBOptions(bucket: "\(database)", org: ""))
        
        
        var points: [InfluxDBClient.Point] = []
        data.forEach { accessoryData in
            var accessoryPoint = InfluxDBClient
                .Point("home")
                .addField(key: accessoryData.measurement, value: .double(accessoryData.value))
            accessoryData.tags.forEach { tag in
                accessoryPoint = accessoryPoint.addTag(key: tag.key, value: tag.value)
            }
            points.append(accessoryPoint)
        }
        
        try await client.makeWriteAPI().write(points: points)
            print("Written data:\n\n\(points.map { "\t- \($0)" }.joined(separator: "\n"))")
            print("\nSuccess!")
        
        client.close()
    }
}
