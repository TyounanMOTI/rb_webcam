# rb_webcam
Crossplatform video capture library for Ruby. Powered by OpenCV.

## Platform
Windows, Mac OS X, Linux, etc...(OpenCV capable systems)

## Dependency
* nice-ffi >= 0.3
* OpenCV Library >= 2.0.0 (e.g.: `brew install homebrew/science/opencv --HEAD` on macOS)

## Install

`gem install rb_webcam`

## Usage

To save image:

```ruby
capture = Webcam.new
image = capture.grab
image.save("image.jpg")
capture.close

# Or

camera_id = 0
Webcam.open(camera_id) { |capture| capture.grab.save("image.jpg") }

# Or

capture = Webcam.new
image = capture.grab
capture.close
```

## Using the `ruby-opencv` gem

```
require "opencv"

capture = OpenCV::CvCapture.open
sleep 1 # Warming up the webcam
capture.query.save("image.jpg")
capture.close
```

## TODO
* specity size at initialize, or anytime.

## LICENSE
The MIT License
Copyright (c) 2010 Hirotoshi YOSHITAKA. See LICENSE for details.
