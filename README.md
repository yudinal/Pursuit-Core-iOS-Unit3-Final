# Unit 3 Final - Elements

## Setup

1. Clone this repo to your laptop.
1. Create a branch for your project.
1. Work on the assessment as described below.
1. Commit your work.
1. Push it to your branch.
1. Create a pull request.
1. Submit your project to Canvas


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
Thumbnail (for table view): http://www.theodoregray.com/periodictable/Tiles/{ElementIDWithThreeDigits}/s7.JPG
Example: http://www.theodoregray.com/periodictable/Tiles/018/s7.JPG

Full-size: (for detail view): http://images-of-elements.com/{lowercasedElementName}.jpg
Example: http://images-of-elements.com/argon.jpg
```

Use the file naming convention illustrated here to generate urls for images.

These are both http urls, so you will need change your info.plist to [allow arbitrary loads](https://stackoverflow.com/questions/31254725/transport-security-has-blocked-a-cleartext-http).

No full size images are available for atomic numbers 90 and up.

**Favorites**

```
POST http://5c1d79abbc26950013fbcaa9.mockapi.io/api/v1/favorites
```

#### Sample JSON Favorites 

```json 
[
    {
        "id": "1",
        "category": "metalloid",
        "melt": 2349,
        "boil": 4200,
        "period": 2,
        "symbol": "B",
        "discovered_by": "Joseph Louis Gay-Lussac",
        "molar_heat": 11.087,
        "phase": "Solid",
        "source": "https://en.wikipedia.org/wiki/Boron",
        "summary": "Boron is a metalloid chemical element with symbol B and atomic number 5. Produced entirely by cosmic ray spallation and supernovae and not by stellar nucleosynthesis, it is a low-abundance element in both the Solar system and the Earth's crust. Boron is concentrated on Earth by the water-solubility of its more common naturally occurring compounds, the borate minerals.",
        "favoritedBy": "Pascal",
        "number": 5,
        "appearance": "black-brown",
        "density": 2.08,
        "atomic_mass": 10.81,
        "name": "Boron"
    },
    {
        "id": "2",
        "category": "alkali metal",
        "melt": 370.944,
        "boil": 1156.09,
        "period": 3,
        "symbol": "Na",
        "discovered_by": "Humphry Davy",
        "molar_heat": 28.23,
        "phase": "Solid",
        "source": "https://en.wikipedia.org/wiki/Sodium",
        "summary": "Sodium /ˈsoʊdiəm/ is a chemical element with symbol Na (from Ancient Greek Νάτριο) and atomic number 11. It is a soft, silver-white, highly reactive metal. In the Periodic table it is in column 1 (alkali metals), and shares with the other six elements in that column that it has a single electron in its outer shell, which it readily donates, creating a positively charged atom - a cation.",
        "favoritedBy": "Edison",
        "number": 11,
        "appearance": "silvery white metallic",
        "density": 0.968,
        "atomic_mass": 22.989769282,
        "name": "Sodium"
    }
]
```


Using Postman and the endpoint below verify that you have favorited an element
```
GET http://5c1d79abbc26950013fbcaa9.mockapi.io/api/v1/favorites
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

![Elements Rubric](./ElementsAssessmentRubric.png)



## Bonus 

Get all favorites endpoint
```
GET http://5c1d79abbc26950013fbcaa9.mockapi.io/api/v1/favorites
```

1. Embed your ElementsViewController in a Tab Bar controller that has 2 viewcontrollers that includes the ElementsViewController. The first view controller should display the Elements. The second view controller should display only the Elements you have favorited. (Hint: filter{} using favoritedBy: "Your name")

2. In the elements endpoint abover there are 100 elements. The periodic table has 118 elements. Using the following endpoint ```https://5c1d79abbc26950013fbcaa9.mockapi.io/api/v1/elements_remaining``` append the remaining 18 elements to your table vie of elements.

3. Add Unit test(s). 
