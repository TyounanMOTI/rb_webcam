require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Webcam do
  share_examples_for "Webcam which closed" do
    it { lambda{ @c_webcam.grab }.should raise_error(RuntimeError, "Camera has'nt be initialized") }
  end

  share_examples_for "Webcam which lives a full life" do
    it { @c_webcam.should_not be_nil }
    it { @c_webcam.capture_handler.should be_instance_of(FFI::Pointer) }
    
    describe "grabbed image" do
      before do
        @image = @c_webcam.grab
      end
      
      it { @image.should be_instance_of Webcam::Image }

      it "should have @iplimage_struct instance of Highgui::IplImage" do
        @image.iplimage_struct.should be_instance_of Highgui::IplImage
      end

      it "color_depth should equal to camera resolution mode" do
        @image.size.should == @c_webcam.resolution_mode
      end
      
      it "color_depth should be Symbol" do
        @image.color_depth.should be_instance_of Symbol
      end
      
      it "data should be instance of FFI::Pointer" do
        @image.data.should be_instance_of FFI::Pointer
      end
      
      it "data size should > 0" do
        @image.data_size.should > 0
      end
    end
    
    it { @c_webcam.resolution_mode[:width].should > 0.0 }
    it { @c_webcam.close.should be_nil }
    it_should_behave_like "Webcam which closed"
  end

  context "when given camera_id: 0" do
    before(:all) do
      @c_webcam = Webcam.new(0)
    end

    it_should_behave_like "Webcam which lives a full life"
  end

  context "when grab a frame using method with block" do
    before do
      @c_webcam
      Webcam.open(0) do |camera|
        @c_webcam = camera
      end
    end

    it_should_behave_like "Webcam which closed"
  end
end
