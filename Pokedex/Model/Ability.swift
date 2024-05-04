struct AbilityResponse: Decodable {
  let name: String
  let flavorTextEntries: [AbilityTextEntry]
}

struct AbilityTextEntry: Decodable {
  let flavorText: String
  let language: RetrievableValue
  let versionGroup: RetrievableValue
}
