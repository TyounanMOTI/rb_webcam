# rb_webcam
Crossplatform video capture library for Ruby. Powered by OpenCV.

## Platform
Windows, Mac OS X, Linux, etc...(OpenCV capable systems)

## Dependency
* nice-ffi >= 0.3
* OpenCV Library >= 2.0.0

## Install
gem install rb_webcam

## Usage
```ruby
camera_id = 0
Webcam.open(camera_id) {|capture| image = capture.grab}
```

or

```ruby
capture = Webcam.new
image = capture.grab
capture.close
```

to save image

```ruby
capture = Webcam.new
image = capture.grab
image.save "new_image.jpg"
capture.close
```

## TODO
* specity size at initialize, or anytime.

## LICENSE
The MIT License
Copyright (c) 2010 Hirotoshi YOSHITAKA. See LICENSE for details.
