require 'nice-ffi'

# wrapper module of OpenCV::Highgui
module Highgui
  extend NiceFFI::Library

  load_library("opencv_highgui")

  class CvCapture < NiceFFI::OpaqueStruct
  end

  SIGNED_FLAG = 0x80000000
  enum :color_depth, [ :unsinged_1bit,  1,
                       :unsigned_8bit,  8,
                       :unsigned_16bit, 16,
                       :unsinged_32bit, 32,
                       :signed_8bit,    SIGNED_FLAG | 8,
                       :signed_16bit,   SIGNED_FLAG | 16,
                       :signed_32bit,   SIGNED_FLAG | 32 ]
  
  # Grabbed webcam image will be stored in this structure.
  # http://opencv.willowgarage.com/documentation/basic_structures.html#iplimage
  class IplImage < NiceFFI::Struct
    layout :n_size,         :int,
           :id,             :int,
           :n_channels,     :int,
           :alpha_channel,  :int,
           :depth,          :color_depth,
           :color_mode,     [:char, 4],  # pointer to char[4]
           :channel_seq,    [:char, 4],  # pointer to char[4]
           :data_order,     :int,
           :origin,         :int,
           :align,          :int,
           :width,          :int,
           :height,         :int,
           :roi,            :pointer,    # pointer to struct _IplROI
           :mask_roi,       :pointer,    # pointer to struct _IplImage
           :image_id,       :pointer,    # pointer to void
           :tile_info,      :pointer,    # pointer to struct _IplTileInfo
           :image_size,     :int,
           :image_data,     :pointer,    # pointer to char array
           :width_step,     :int,
           :border_mode,    [:int, 4],   # pointer to int[4]
           :border_const,   [:int, 4],   # pointer to int[4]
           :image_data_origin, :pointer  # pointer to char array
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
  attach_function :query, :cvQueryFrame, [:pointer], IplImage.typed_pointer
  attach_function :get_property, :cvGetCaptureProperty, [:pointer, :property], :double
  attach_function :set_property, :cvSetCaptureProperty, [:pointer, :property, :double], :int
  attach_function :save_image, :cvSaveImage, [:string, IplImage], :int
end

# Class to controll your webcam.
# Initialize camera, grab image, then close.
class Webcam
  # Open camera with 'method with block' sentence.
  # This will open then close at start and end of block.
  # ex.
  # Webcam.open { |camera| @image = camera.grab }
  def self.open(camera_id=0)
    webcam = Webcam.new(camera_id)
    yield webcam
    webcam.close
  end
  
  # Open camera with camera_id, and size.
  # camera_id: '0' to autodetect.
  def initialize(camera_id=0)
    @capture_handler = Highgui.create_camera_capture(camera_id)
  end

  # Grab a frame from camera and returns IplImage struct.
  # This needs camera still opened.
  def grab
    raise "Camera has'nt be initialized" if @capture_handler.nil?
    image = Highgui.query(@capture_handler)
    return Image.new(image)
  end

  # Close camera. You need close opened camera for cleaner behavior.
  def close
    Highgui.release_capture(FFI::MemoryPointer.new(:pointer).write_pointer(@capture_handler))
    @capture_handler = nil
  end

  # Set resolution of camera output.
  # [usage] @webcam.resolution_mode = {:width => 160, :height => 120}
  # Available resolution_mode is depends on your camera.
  def resolution_mode=(resolution)
    Highgui.set_property(@capture_handler, :width, resolution[:width])
    Highgui.set_property(@capture_handler, :height, resolution[:height])
  end

  # Get resolution mode of camera.
  # return format is written in resolution_mode=(resolution)
  def resolution_mode
    {
      :width => Highgui.get_property(@capture_handler, :width),
      :height => Highgui.get_property(@capture_handler, :height)
    }
  end

  # Getter for debug use.
  # Internally used to call OpenCV C functions for specified camera.
  attr_reader :capture_handler
  
  # Property Container of image from webcam.
  # Get size, color_depth, mode, etc.. of image.
  # Each instance have IplImage struct data.
  # TODO: Having pointer to IplImage struct will be good for performance?
  #       (Does whole structure copying occur at Image.new(iplimage) ?)
  class Image
    def initialize(iplimage_struct)
      @iplimage_struct = iplimage_struct
    end

    # get size of image. Hash with :width, :height elements.
    def size
      {
        :width => @iplimage_struct.width,
        :height => @iplimage_struct.height
      }
    end

    # get color depth of image.
    def color_depth
      @iplimage_struct.depth
    end
    
    # String of image data
    def data
      self.data_pointer.read_string(self.data_size)
    end
    
    # FFI::Pointer to image data
    def data_pointer
      @iplimage_struct.image_data
    end
    
    # data size of image
    def data_size
      @iplimage_struct.image_size
    end

    # save the image to "name" incl. extension
    def save(name)
      Highgui.save_image name, @iplimage_struct
    end
    
    # IplImage structure stored grabbed image from camera.
    attr_reader :iplimage_struct
  end
end

