require 'nice-ffi'

module Highgui
  extend NiceFFI::Library

  load_library("highgui")

  class CvCapture < NiceFFI::OpaqueStruct
  end

  attach_function :cvCreateCameraCapture, [:int], CvCapture.typed_pointer
end

class Webcam
  def initialize(camera_id=0)
    @capture_handler = Highgui::cvCreateCameraCapture(camera_id)
  end
end

