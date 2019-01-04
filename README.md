# Unit 3 Final - Elements

**Unit 3 [Lessons](https://github.com/joinpursuit/Pursuit-Core-iOS/tree/master/units/unit03)**    

## Setup

1. Fork this repo.
1. Clone this repo to your laptop.
1. Work on the assessment as described below.
1. Commit your work.
1. Push it to your fork.
1. Create a pull request.
1. Submit your project to Canvas

## Helper classes we wrote 

<details> 
	<summary>Network Helper - wrapper for URLSession</summary>
	
```swift 
import Foundation

public final class NetworkHelper {
  private init() {
    let cache = URLCache(memoryCapacity: 10 * 1024 * 1024, diskCapacity: 10 * 1024 * 1024, diskPath: nil)
    URLCache.shared = cache
  }
  public static let shared = NetworkHelper()
  
  public func performDataTask(endpointURLString: String,
                              httpMethod: String,
                              httpBody: Data?,
                              completionHandler: @escaping (AppError?, Data?, HTTPURLResponse?) ->Void) {
    guard let url = URL(string: endpointURLString) else {
      completionHandler(AppError.badURL("\(endpointURLString)"), nil, nil)
      return
    }
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
      if let error = error {
        completionHandler(AppError.networkError(error), nil, response as? HTTPURLResponse)
        return
      } else if let data = data {
        completionHandler(nil, data, response as? HTTPURLResponse)
      }
    }
    task.resume()
  }
  
  public func performUploadTask(endpointURLString: String,
                                httpMethod: String,
                                httpBody: Data?,
                                completionHandler: @escaping (AppError?, Data?, HTTPURLResponse?) ->Void) {
    guard let url = URL(string: endpointURLString) else {
      completionHandler(AppError.badURL("\(endpointURLString)"), nil, nil)
      return
    }
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let task = URLSession.shared.uploadTask(with: request, from: httpBody) { (data, response, error) in
      if let error = error {
        completionHandler(AppError.networkError(error), nil, response as? HTTPURLResponse)
        return
      } else if let data = data {
        completionHandler(nil, data, response as? HTTPURLResponse)
      }
    }
    task.resume()
  }
}
```

</details> 


<details> 
	<summary>AppError - handles error throughout the app</summary>
	
```swift 
import Foundation

public enum AppError: Error {
  case badURL(String)
  case networkError(Error)
  case noResponse
  case decodingError(Error)
  case badStatusCode(String)
  case badMimeType(String)
  
  public func errorMessage() -> String {
    switch self {
    case .badURL(let message):
      return "badURL: \(message)"
    case .networkError(let error):
      return error.localizedDescription
    case .noResponse:
      return "no network response"
    case .decodingError(let error):
      return "decoding error: \(error)"
    case .badStatusCode(let message):
      return "bad status code: \(message)"
    case .badMimeType(let mimeType):
      return "bad mime type: \(mimeType)"
    }
  }
}
```

</details> 


<details> 
	<summary>ImageHelper - wrapper for image processing including caching images in memory for optimization in performance</summary>
	
```swift 
import UIKit

public final class ImageHelper {
  // Singleton instance to have only one instance in the app of the imageCache
  private init() {
    imageCache = NSCache<NSString, UIImage>()
    imageCache.countLimit = 100 // number of objects
    imageCache.totalCostLimit = 10 * 1024 * 1024 // max 10MB used
  }
  public static let shared = ImageHelper()
  
  private var imageCache: NSCache<NSString, UIImage>
  
  public func fetchImage(urlString: String, completionHandler: @escaping (AppError?, UIImage?) -> Void) {
    NetworkHelper.shared.performDataTask(endpointURLString: urlString, httpMethod: "GET", httpBody: nil) { (error, data, response) in
      if let error = error {
        completionHandler(error, nil)
        return
      }
      if let response = response {
        // response.allHeaderFields dictionary contains useful header information such as Content-Type, Content-Length
        // response also has the mimeType, such as image/jpeg, text/html, image/png
        let mimeType = response.mimeType ?? "no mimeType found"
        var isValidImage = false
        switch mimeType {
        case "image/jpeg":
          isValidImage = true
        case "image/png":
          isValidImage = true
        default:
          isValidImage = false
        }
        if !isValidImage {
          completionHandler(AppError.badMimeType(mimeType), nil)
          return
        } else if let data = data {
          let image = UIImage(data: data)
          DispatchQueue.main.async {
            if let image = image {
              ImageHelper.shared.imageCache.setObject(image, forKey: urlString as NSString)
            }
            completionHandler(nil, image)
          }
        }
      }
    }
  }
  
  public func image(forKey key: NSString) -> UIImage? {
    return imageCache.object(forKey: key)
  }
}
```

</details> 

## Key Projects 

- [RandomUsers](https://github.com/joinpursuit/Pursuit-Core-iOS-RandomUsers) - modifies App Transport Security to handle insecure http requests  
- [FellowBlogger](https://github.com/joinpursuit/Pursuit-Core-iOS-FellowBlogger) - packages a Swift object and uploads the JSON data to an API 
- [PodcastFavorites](https://github.com/joinpursuit/Pursuit-Core-iOS-PodcastFavorites) - packages a Swift object and uploads the JSON data to an API, uses ImageHelper for image processing

## Objective

* Build a table view that loads and displays a list of the Elements, one per cell/row. Use a custom UITableViewCell subclass.  It should have 2 labels and one image.  The image should be pinned to the left of cell from the small images endpoint below.  The labels should be configured as below:

    ```
    Name
    Symbol(Number) Atomic Weight

    e.g.

    Sodium
    Na(11) 22.989769282
    ```
    
    Load a thumbnail image on each row as described below under Endpoints > Images.  For full credit, use a custom tableViewCell to make the image more readable.
    
* Tapping a cell segues to a detail view that:
    * set the navigation bar title to the ```name``` of the element
    * shows the larger image 
    * and the following data:
        * symbol
        * number
        * weight
        * melting point
        * boiling point
        * discovery by

    * has a button that, when pressed, selects this element as your favorite. This
    should be implemented by a POST to the ```favorites``` endpoint.


Try to format the detail view as much like an individual element on a traditional periodic table as you can. You **cannot** use the thumbnail image inside the detail view controller, you need to format it yourself.

Sample element: [https://sciencenotes.org/wp-content/uploads/2015/04/06-Carbon-Tile.png](https://sciencenotes.org/wp-content/uploads/2015/04/06-Carbon-Tile.png)

## Endpoints

**Elements**

```
GET https://5c1d79abbc26950013fbcaa9.mockapi.io/api/v1/elements
```

This is a public read-only GET endpoint so no authentication is necessary.

**Images**

```
Thumbnail (for table view): http://www.theodoregray.com/periodictable/Tiles/ElementNumberWithThreeDigits/s7.JPG
Example: http://www.theodoregray.com/periodictable/Tiles/018/s7.JPG

Full-size: (for detail view): http://images-of-elements.com/lowercasedElementName.jpg
Example: http://images-of-elements.com/argon.jpg
```

Use the file naming convention illustrated here to generate urls for images.

These are both http urls, so you will need change your info.plist to [allow arbitrary loads](https://stackoverflow.com/questions/31254725/transport-security-has-blocked-a-cleartext-http).

No full size images are available for atomic numbers 90 and up.

**Favorites**

```
POST https://5c1d79abbc26950013fbcaa9.mockapi.io/api/v1/favorites
```

This endpoint expects JSON with the following keys: "favoritedBy", "elementName" and "elementSymbol".
Values should be your own name, and the symbol and name of the element currently displayed by the detail page, respectively.

Using Postman and the endpoint below verify that you have favorited an element
```
GET https://5c1d79abbc26950013fbcaa9.mockapi.io/api/v1/favorites
```

## JSON Info

Elements looks like this:

```json 
    {
        "name": "Hydrogen",
        "appearance": "colorless gas",
        "atomic_mass": 1.008,
        "boil": 20.271,
        "category": "diatomic nonmetal",
        "color": null,
        "density": 0.08988,
        "discovered_by": "Henry Cavendish",
        "melt": 13.99,
        "molar_heat": 28.836,
        "named_by": "Antoine Lavoisier",
        "number": 1,
        "period": 1,
        "phase": "Gas",
        "source": "https://en.wikipedia.org/wiki/Hydrogen",
        "spectral_img": "https://en.wikipedia.org/wiki/File:Hydrogen_Spectra.jpg",
        "summary": "Hydrogen is a chemical element with chemical symbol H and atomic number 1. With an atomic weight of 1.00794 u, hydrogen is the lightest element on the periodic table. Its monatomic form (H) is the most abundant chemical substance in the Universe, constituting roughly 75% of all baryonic mass.",
        "symbol": "H",
        "xpos": 1,
        "ypos": 1,
        "shells": [
            1
        ]
    },
    {
        "name": "Helium",
        "appearance": "colorless gas, exhibiting a red-orange glow when placed in a high-voltage electric field",
        "atomic_mass": 4.0026022,
        "boil": 4.222,
        "category": "noble gas",
        "color": null,
        "density": 0.1786,
        "discovered_by": "Pierre Janssen",
        "melt": 0.95,
        "molar_heat": null,
        "named_by": null,
        "number": 2,
        "period": 1,
        "phase": "Gas",
        "source": "https://en.wikipedia.org/wiki/Helium",
        "spectral_img": "https://en.wikipedia.org/wiki/File:Helium_spectrum.jpg",
        "summary": "Helium is a chemical element with symbol He and atomic number 2. It is a colorless, odorless, tasteless, non-toxic, inert, monatomic gas that heads the noble gas group in the periodic table. Its boiling and melting points are the lowest among all the elements.",
        "symbol": "He",
        "xpos": 18,
        "ypos": 1,
        "shells": [
            2
        ]
    }
```

## Rubric

Criteria | Points
:---|:---
App uses AutoLayout correctly for all iPhones in portrait | 8 Points
Variable Naming and Readability | 4 Points
App uses MVC Design Patterns | 4 Points
Elements model is built correctly and handles nils appropriately | 4 points
Elements are loaded into the tableview using a custom table view cell | 4 points
Thumbnail images are loaded into the tableview | 4 points
Detail view controller loads the element in correctly | 4 points
Detail view controller loads the large image appropriately | 4 points
Detail view controller button makes a Post request | 4 points

A total of 40 points.

## Bonus 

Get all favorites endpoint
```
GET https://5c1d79abbc26950013fbcaa9.mockapi.io/api/v1/favorites
```

Embed your ElementsViewController in a Tab Bar controller that has 2 viewcontrollers that includes the ElementsViewController. The first view controller should display the Elements. The second view controller should display only the Elements you have favorited. (Hint: filter{} using favoritedBy: "Your name") 

10 points.
