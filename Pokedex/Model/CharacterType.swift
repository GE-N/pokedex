struct TypeResponse: Decodable {
  let damageRelations: DamageReduction
  let name: String
}

struct DamageReduction: Decodable {
  let doubleDamageFrom: [RetrievableValue]
  let doubleDamageTo: [RetrievableValue]
  let halfDamageFrom: [RetrievableValue]
  let halfDamageTo: [RetrievableValue]
  let noDamageFrom: [RetrievableValue]
  let noDamageTo: [RetrievableValue]
}
