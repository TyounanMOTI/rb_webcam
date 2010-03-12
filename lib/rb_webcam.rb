require 'nice-ffi'

module Highgui
  extend NiceFFI::Library

  load_library("highgui")

  class CvCapture < NiceFFI::OpaqueStruct
  end

  attach_function :cvCreateCameraCapture, [:int], CvCapture.typed_pointer
  attach_function :cvGrabFrame, [:pointer], :int
end

class Webcam
  def initialize(camera_id=0)
    open(camera_id)
  end

  def open(camera_id=0)
    @capture_handler = Highgui::cvCreateCameraCapture(camera_id)
  end

  def grab
    Highgui.cvGrabFrame(@capture_handler)
  end

  def close
    @capture_handler = nil
  end
end

