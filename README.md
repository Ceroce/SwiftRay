# SwiftRay
A simplistic Path tracer written in Swift.

![Sample image produced by SwiftRay](doc/Image.png)

## What is SwiftRay
SwiftRay is a Path Tracer (a kind of Raytracer) written in Swift and loosely based on the e-book [Ray Tracing in One Weekend](https://www.amazon.com/Ray-Tracing-Weekend-Minibooks-Book-ebook/dp/B01B5AODD8) by [Peter Shirley](http://in1weekend.blogspot.fr).

There are three books in the series, but SwiftRay is only based on the first two. The [original source code](https://github.com/petershirley/raytracinginoneweekend) is written in C++. Should you wish to know how the path tracer works, buy the book, since it's cheap, and provides nice explanations.

## Features
- Antialiasing (by multisampling every pixel)
- Several materials: Lambertian (matte colour), Metal (reflective) and Dielectric (refractive)
- Depth-of-field blur
- Motion blur
- Multi-threaded, to exploit multiple cores
- A Bounding Volume Hierarchy algorithm speeds-up calculations

## Limitations
- There are only two type of object: Spheres and rectangles oriented on the axes.
- The algorithm is interesting but very slow: Path tracing is slow by principle.

## Supported plateforms
It currently only runs on a Mac.

It should be possible to run it on a iOS device, but a little adaptation is needed because it runs on the command line.

Running it on Linux would be more work, since it relies on Core Graphics to save the image to a PNG file. (It also imports Darwin for mathematical functions, but that can be replaced with libc on Linux).

## What programmers might find interesting
Begin with main.swift. It contains enough comments to understand the structure of the app.

Take a look at Bitmap.swift which does low-level memory access to the bitmap. 

Vector.swift also contains overloaded operators. Thanks to Swift, the implementation is simple and elegant.
