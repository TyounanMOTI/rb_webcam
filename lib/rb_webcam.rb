require 'nice-ffi'

module Highgui
  extend NiceFFI::Library

  load_library("highgui")

  class CvCapture < NiceFFI::OpaqueStruct
  end

  class IplImage < NiceFFI::OpaqueStruct
  end

  attach_function :cvCreateCameraCapture, [:int], :pointer
  attach_function :cvGrabFrame, [:pointer], :int
  attach_function :cvReleaseCapture, [:pointer], :void
  attach_function :cvQueryFrame, [:pointer], :pointer
end

class Webcam
  # Call 'open(camera_id)'.
  def initialize(camera_id=0)
    open(camera_id)
  end

  # Open camera with 'camera_id'. (default = 0)
  # If specified '0', camera will be auto-detected.
  def open(camera_id=0)
    @capture_handler = Highgui::cvCreateCameraCapture(camera_id)
  end

  # Open camera with 'method with block' sentence.
  # This will open then close at start and end of block.
  # ex.
  # Webcam.open { |camera| @image = camera.grab }
  def self.open(camera_id=0)
    webcam = Webcam.new(camera_id)
    yield webcam
    webcam.close
  end

  # Grab a frame from camera and returns a pointer to IplImage.
  # This needs camera still opened.
  def grab
    raise "Camera has'nt be initialized" if @capture_handler.nil?
    Highgui.cvQueryFrame(@capture_handler)
  end

  # Close camera. You need close opened camera for cleaner behavior.
  def close
    Highgui::cvReleaseCapture(FFI::MemoryPointer.new(:pointer).write_pointer(@capture_handler))
    @capture_handler = nil
  end

  attr_reader :capture_handler
end

