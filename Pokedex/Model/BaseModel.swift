import Foundation

/**
 An object for represent a JSON value which contain `name` and `url` which based in many values of api response.
 
 A value will contains in `name` field and api for details of value will provided in `url` field.
*/
class RetrievableValue: Decodable {
  let name: String
  let url: String
}
