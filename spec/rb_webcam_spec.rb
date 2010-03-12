require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Webcam, "when given camera_id is 0" do
  before do
    @c_webcam = Webcam.new(0)
  end

  it "should not be nil" do
    @c_webcam.should_not be_nil
  end
end

describe Webcam, "when grabs a frame" do
  before do
    @c_webcam = Webcam.new(0)
  end

  it "should succeed" do
    @c_webcam.grab.should == 1
  end
end
