import SwiftUI

struct ExportView: View {
    enum FocusedField:Hashable{
            case username_input, database_input, password_input, url_input
        }
    @FocusState var focus:FocusedField?
    
    @ObservedObject var settings = InfluxDBViewModel()
    
    var body: some View {
        VStack {
            Text("InfluxDB Export Settings")
                .font(.largeTitle)
            
            VStack(alignment: .leading) {
                Text("Username").font(.title3)
                
                TextField(
                    "Username",
                    text: $settings.influxDBUsername
                )
                .focused($focus, equals: .username_input)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .border(.secondary)
            }.padding(.top, 20)
            
            VStack(alignment: .leading) {
                Text("Database").font(.title3)
                
                TextField(
                    "Database",
                    text: $settings.influxDBDatabase
                )
                .focused($focus, equals: .database_input)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .border(.secondary)
            }.padding(.top, 20)
            
            VStack(alignment: .leading) {
                Text("Password").font(.title3)
                
                TextField(
                    "[PASSWORD]",
                    text: $settings.influxDBPassword
                )
                .focused($focus, equals: .password_input)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .border(.secondary)
            }.padding(.top, 20)
            
            VStack(alignment: .leading) {
                Text("URL").font(.title3)
                
                TextField(
                    "InfluxDB connection URL",
                    text: $settings.influxDBUrl
                )
                .focused($focus, equals: .url_input)
                .keyboardType(.URL)
                .textContentType(.URL)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .border(.secondary)
            }
            .padding(.top, 20)
            
            if settings.settingsComplete {
                Button {
                    settings.testConnection()
                } label: {
                    Text("Test connection")
                        .padding(20)
                }
                
                Text(settings.lastConnectionResult)
                    .lineLimit(10)
            }
            
        }
        .padding()
        .onChange(of: focus) {
            settings.save()
        }
    }
    
    
}

#Preview {
    ExportView()
}
