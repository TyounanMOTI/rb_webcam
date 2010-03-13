require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Webcam do
  context "when given camera_id is 0" do
    before(:all) do
     $c_webcam = Webcam.new(0)
    end

    it { $c_webcam.should_not be_nil }
    it { $c_webcam.capture_handler.should be_instance_of(FFI::Pointer) }
    it { $c_webcam.grab.should == 1 }
    it { $c_webcam.close.should be_nil }
    it { lambda{ $c_webcam.grab }.should raise_error(RuntimeError, "Camera has'nt be initialized") }
  end
end
