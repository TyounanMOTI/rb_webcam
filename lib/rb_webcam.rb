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
  def initialize(camera_id=0)
    open(camera_id)
  end

  def open(camera_id=0)
    @capture_handler = Highgui::cvCreateCameraCapture(camera_id)
  end

  def self.open(camera_id=0)
    webcam = Webcam.new(camera_id)
    yield webcam
    webcam.close
  end

  def grab
    raise "Camera has'nt be initialized" if @capture_handler.nil?
    Highgui.cvQueryFrame(@capture_handler)
  end

  def close
    Highgui::cvReleaseCapture(FFI::MemoryPointer.new(:pointer).write_pointer(@capture_handler))
    @capture_handler = nil
  end

  attr_reader :capture_handler
end

