require 'nice-ffi'

module Highgui
  extend NiceFFI::Library

  load_library("highgui")

  class CvCapture < NiceFFI::OpaqueStruct
  end

  class IplImage < NiceFFI::OpaqueStruct
  end

  enum :property, [ :position_msec, 0,
                    :position_frames,
                    :position_avi_ratio,
                    :width,
                    :height,
                    :fps,
                    :fourcc,
                    :frame_count,
                    :format,
                    :mode,
                    :brightness,
                    :contrast,
                    :saturation,
                    :hue,
                    :gain,
                    :exposure,
                    :convert_rgb,
                    :white_balance,
                    :rectification ]

  attach_function :create_camera_capture, :cvCreateCameraCapture, [:int], :pointer
  attach_function :release_capture, :cvReleaseCapture, [:pointer], :void
  attach_function :query, :cvQueryFrame, [:pointer], :pointer
  attach_function :get_property, :cvGetCaptureProperty, [:pointer, :property], :double
  attach_function :set_property, :cvSetCaptureProperty, [:pointer, :property, :double], :int
end

class Webcam
  # Open camera with camera_id, and size.
  # camera_id: '0' to autodetect.
  # size: Hash with ':width' and ':height'
  #            ex. {width: 800.0, height: 600.0}
  def initialize(camera_id=0, size = {width: -1, height: -1})
    @capture_handler = Highgui.create_camera_capture(camera_id)
    @size = size
  end

  # Open camera with 'method with block' sentence.
  # This will open then close at start and end of block.
  # ex.
  # Webcam.open { |camera| @image = camera.grab }
  def self.open(camera_id=0, size = {width: -1, height: -1})
    webcam = Webcam.new(camera_id, size)
    yield webcam
    webcam.close
  end

  # Grab a frame from camera and returns a pointer to IplImage.
  # This needs camera still opened.
  def grab
    raise "Camera has'nt be initialized" if @capture_handler.nil?
    Highgui.query(@capture_handler)
  end

  # Close camera. You need close opened camera for cleaner behavior.
  def close
    Highgui.release_capture(FFI::MemoryPointer.new(:pointer).write_pointer(@capture_handler))
    @capture_handler = nil
  end

  # Set resolution of camera output.
  # [usage] @webcam.resolution_mode = {width: 160, height: 120}
  # Available resolution_mode is depends on your camera.
  def resolution_mode=(resolution)
    Highgui.set_property(@capture_handler, :width, resolution[:width])
    Highgui.set_property(@capture_handler, :height, resolution[:height])
  end

  def resolution_mode
    {width: Highgui.get_property(@capture_handler, :width),
    height: Highgui.get_property(@capture_handler, :height)}
  end

  attr_reader :capture_handler, :size
end

