require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Webcam do
  context "when given camera_id is 0" do
    subject { Webcam.new(0) }
    it { should_not be_nil }
  end

  context "when grabs a frame" do
    subject { Webcam.new.grab }
    it "should succeed" do
      should == 1
    end
  end
end
