
import Foundation

// MARK: - new appoint api request
struct NewApmRequest: Codable {
    let userId, appointmentId: Int
    let userIds: [Int]
    let cardCategory, selectedCardUrl: String
    let appointmentName: AppointmentName
}

// MARK: - AppointmentName
struct AppointmentName: Codable {
    let name, menu, date, location: String
    let notes: String
}
