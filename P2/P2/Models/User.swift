
import Foundation

struct User : Codable {
  let id: Int?
  var email: String?
  var first_name: String?
  var last_name: String?
  var avatar: String?
    
  
  enum CodingKeys: String, CodingKey {
    case id = "id"
    case email = "email"
    case first_name = "first_name"
    case last_name = "last_name"
    case avatar = "avatar"
  }
    
      init(decoder : Decoder) throws {
          let values = try decoder.container(keyedBy: CodingKeys.self)
          id = try values.decodeIfPresent(Int.self, forKey: .id)
          email = try values.decodeIfPresent(String.self, forKey: .email)
          first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
          last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
          avatar = try values.decodeIfPresent(String.self, forKey: .avatar)
      }
  
}
