# Pokedex iOS

A pokemon index on iOS. User can search and see a useful Pokemon's information such as stat, type strenghten and weakness and evolution's map.

A source of data referred to `https://pokeapi.co/`.

App was written by UIKit Swift with Clean RxSwift MVVM architecture on Xcode 15.0.1. Minimum support at iOS 16.

##### Dependencies

- RxSwift & RxCocoa : For data binding between view and viewModel.
- Kingfisher : For image loading with cache.
- RxSwift's twoWayBind extension : For mapping on textfields.

##### Features

- [✓] Show a Pokemons index.
- [✓] Filterable by name or id.
- [✓] Retry if home screen load fail.
- [✓] Show details of selected Pokemon.
- [✓] Reload if pokemon details load fail.

##### Error handling

It's difficult to reproduce then prove by record with mocked result.

| Home | Details |
|------|---------|
|![home retry](/images/pokedex-retry-home.gif)|![details retry](/images/pokedex-retry-details.gif)|

---

### How to setup

1. Clone this project then double-click on Pokedex.xcodeproj.
2. Xcode should get an app's dependencies automatically. In case if not you could go to Xcode menu File -> packages -> resolve package version to get a dependencies.

### Time consumed

Total time ~16 hrs

- Read API documentation and app design ~3 hrs.
- Home screen implement ~3 hrs.
- Details screen implementation ~10 hrs

### Limitation

- Localization not apply.

##### Home screen

- Not applied default image for non provided default sprite.
- Expected item's `url` field always be `id` value and image stored at `https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/{id}.png`.

##### Details screen

- Not apply default image for non provided official artwork.
- Not apply unknown stat if api response not provided.
- Cannot retry load on section type and ability ability. In case it error will just hidden.

### What can improve

- Show evolution map on details screen.
- Filterable information for each game version.
- Show list of characters by type selected.
- ...