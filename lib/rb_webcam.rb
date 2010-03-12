require 'nice-ffi'

module Highgui
  extend NiceFFI::Library

  load_library("highgui")

  class CvCapture < NiceFFI::OpaqueStruct
  end

  attach_function :cvCreateCameraCapture, [:int], :pointer
  attach_function :cvGrabFrame, [:pointer], :int
  attach_function :cvReleaseCapture, [:pointer], :void
end

class Webcam
  def initialize(camera_id=0)
    open(camera_id)
  end

  def open(camera_id=0)
    @capture_handler = Highgui::cvCreateCameraCapture(camera_id)
  end

  def grab
    raise "Camera has'nt be initialized" if @capture_handler.nil?
    Highgui.cvGrabFrame(@capture_handler)
  end

  def close
    Highgui::cvReleaseCapture(FFI::MemoryPointer.new(:pointer).write_pointer(@capture_handler))
    @capture_handler = nil
  end

  attr_reader :capture_handler
end

