struct SpeciesResponse: Decodable {
  let flavorTextEntries: [TextEntry]
}

struct TextEntry: Decodable {
  let flavorText: String
  let language: RetrievableValue
  let version: RetrievableValue
}
