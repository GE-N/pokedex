import UIKit

struct Style {
  // MARK: Theme, Font & Color
  let mainTextColor = UIColor(hex: "333333")
  let subTextColor = UIColor(hex: "888888")
  
  let lightGrayColor = UIColor(hex: "EEEEEE")
  
  let titleFont = UIFont.systemFont(ofSize: 18, weight: .bold)
  let mainTextFont = UIFont.systemFont(ofSize: 16, weight: .bold)
  let detailsFont = UIFont.systemFont(ofSize: 16, weight: .regular)
  let subTextFont = UIFont.systemFont(ofSize: 14, weight: .bold)
  let subTextFont2 = UIFont.systemFont(ofSize: 12, weight: .bold)
  
  // MARK: Dimension
  let padding = 8.0
  let cornerRadius = 8.0
  
  // MARK: - Home
  let homeCollectionViewContentInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
  let homeColumnPerRow = 3
  let homeCellHeight = 150.0
  
  // MARK: - Loading View
  let loadingViewWidth = 250.0
}
