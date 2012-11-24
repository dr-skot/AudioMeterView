describe "AudioMeterView" do

  before do
    @amv = AudioMeterView.alloc.init
    @lmv = @amv.instance_variable_get("@meter")
    @recorder = stub(:averagePower, :return => -10)
    @recorder.stub!(:peakPower, :return => -5)
    @recorder.stub!(:updateMeters)
    @recorder.stub!(:respond_to?) do |fn|
      fn == :averagePower || fn == :peakPower
    end    
    # @recorder.stub!(:averagePowerForChannel, :return => -10) {|chan|}
    # @recorder.stub!(:peakPowerForChannel, :return => -5) {|chan|}
  end

  after do
    @amv.input = nil
    @amv = nil
  end

  describe "mockRecorder" do
    it "should return a value for average power" do
      @recorder.averagePower.should == -10
    end

    it "should return a value for peak power" do
      @recorder.peakPower.should == -5
    end

    it "responds to averagePower" do
      @reorder.respond_to?(:averagePower).should == true
    end

    it "responds to peakPower" do
      @reorder.respond_to?(:peakPower).should == true
    end

  end
  
  it "should start its timer when you give it a recorder" do
    @amv.input = @recorder
    timer = @amv.instance_variable_get("@timer")
    timer.should.not == nil
    timer.isValid.should == true
  end

  it "should invalidate its timer when you remove the recorder" do
    @amv.input = @recorder
    @amv.input = nil
    timer = @amv.instance_variable_get("@timer")
    (timer.nil? && timer.isValid).should == false
  end

  it "should call its refresh method with its timer" do
    @amv.input = @recorder
    wait 1.5 do
      @amv.instance_variable_get("@refreshed").should == true
    end
  end

  it "should set the level meter to the recorder's levels" do
    @amv.input = @recorder
    @lmv.level.should.be.close 0.32, 0.01
    @lmv.peakLevel.should.be.close 0.56, 0.01
  end

  it "should be lit by the recorder" do
    @amv.input = @recorder
    @lmv.colorForLight(1).should == @lmv.thresholdColors[0].CGColor
  end

  it "should fall off after recorder is set to nil" do
    @amv.input = @recorder
    @amv.input = nil
    @lmv.colorForLight(1).should == @lmv.thresholdColors[0].CGColor
    wait (3) do
      @lmv.colorForLight(1).should == nil
    end
  end
end

