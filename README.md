# HDZoomCollectionView for iOS

`UICollectionView` is great, but it is not zoomable (which is rather strange since
it is inherits from `UIScrollView`). This project is an attempt to implement zooming
using custom a `UICollectionViewLayout` which resizes itself to simulate the effect
we know and love from `UIScrollView`.

![](assets/iPad 9.7.gif)

## How does it work?

`HDZoomCollectionView` is a container view that encapsulates three views:

- A `UICollectionView` for the actual collection data
- A `UIScrollView` for the zoom/scroll hooks
- A dummy `UIView` that the scroll view uses for its zooming capabilities

When the scroll view is zoomed or scrolled it forwards the content offset to
the collection view and the scale factor to the `UICollectionViewLayout` 

How the layout recalculates its attributes is implementation specific but an example

can be found in `HDZoomCollectionViewFlowLayout`.

## What works

- Scrolling
- Zooming
- Align Center
- Rotation Support
