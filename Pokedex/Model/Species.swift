struct SpeciesResponse: Decodable {
  let flavorTextEntries: [SpeciesTextEntry]
}

struct SpeciesTextEntry: Decodable {
  let flavorText: String
  let language: RetrievableValue
  let version: RetrievableValue
}
