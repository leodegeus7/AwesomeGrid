# Awesome Grid Layout
> Create a simple and easy-to-use Grid Layout


![](https://i.imgur.com/fE20esN.jpg)


With this tool you can create an awesome grid layout based in collection view. It's simple, easy to implement and highly customizable. 


## Installation

POD Installation:

```sh
pod 'GridLayout', :git => 'https://github.com/leodegeus7/awesomeGrid.git'
```

![](https://media.giphy.com/media/3ohjURLa8P6rKniUtW/giphy.gif)

## Usage example

To use this tool you need to follow few steps:

1) Create a Collection View inside a Controller on StoryBoard and set "GridView" in class of object and "GridLayout" in Custom Layout Class;
2) Create an outlet with this object in your Controller, import the framework GridLayout and set the delegate GridLayoutDelegate;
3) Override the func viewDidLayoutSubviews of your View Controller and insert the follow code inside:

```sh
collectionView.gridDelegate = self
collectionView.initialize(numberOfColumns: Int, debug: Bool ,optionalPadding: Int)
```
4) Get de function getCellsSupport of delegate in your Controller, and create a array of CellSupports.
CellSupport is the way that you set the content of cell and the position of cell in grid. You can construct a CellSupport passing your grid Layout and the coordinates of item:

```sh
CellSupport(gridView: GridLayout, row: Int, column: Int, squaresOfHeight: Int, squaresOfWidth: Int)
```

5) Customize the view of your new Cell Support adding subViews in cellSupport.view
6) Override func viewWillTransition of your Controller and set

```sh
gridLayour.viewWillTransition(size: size)
```


## Release History

* 0.0.1
    * First Commit

## Meta

Leonardo Alexandre de Geus – [@leodegeus7](https://www.linkedin.com/in/leodegeus7/) – leonardodegeus@gmail.com

See ``LICENSE`` for more information.

[https://github.com/leodegeus7](https://github.com/leodegeus7)
