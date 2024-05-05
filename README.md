# Pokedex iOS

A pokemon index on iOS. User can search and see a useful Pokemon's information such as stat, type strenghten and weakness and evolution's map.

A source of data referred to `https://pokeapi.co/`.

App was written by UIKit Swift on Clean RxSwift MVVM architecture.

##### Dependencies

- RxSwift & RxCocoa : For data binding between view and viewModel.
- Kingfisher : For image loading with cache.
- RxSwift's twoWayBind extension : For mapping on textfields.

##### Features

[✓] Show a Pokemons index.
[✓] Filterable by name or id.
[] Retry if home screen load fail.
[✓] Show details of selected Pokemon.
[✓] Reload if pokemon details load fail.

---

### How to setup

### Time consumed

- Read API documentation and app design ~3 hrs.
- Home screen implement ~3 hrs.

### Limitation

##### Home screen

- Not applied default image for non provided default sprite.
- Expected item's `url` field always be `id` value and image stored at `https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/{id}.png`

##### Details screen

- Not applied default image for non provided official artwork.