describe "LevelMeterView" do
  before do
    @lmv = LevelMeterView.alloc.initWithFrame(CGRectMake(0,0,300,20))
  end

  describe "LevelMeterView db" do
    it "should be near 0 for -160 db" do
      @lmv.db = -160
      @lmv.level.should.be.close 0, 0.01
    end
    it "should be near 1 for 0 db" do
      @lmv.db = 0
      @lmv.level.should.be.close 1, 0.01
    end
  end

  describe "LevelMeterView colorForLight" do

    it "should return nil for unlit lights" do
      @lmv.colorForLight(5).should == nil
    end
    it "should use low color at low levels" do
      @lmv.level = 1
      @lmv.colorForLight(0).should == @lmv.thresholdColors[0].CGColor
    end
    it "should use high color at high levels" do
      @lmv.level = 1
      @lmv.colorForLight(29).should == @lmv.thresholdColors[2].CGColor
    end
    it "should use middle color at middle levels" do
      @lmv.level = 1
      @lmv.colorForLight(19).should == @lmv.thresholdColors[1].CGColor
    end

    it "should use low color for low peak light" do
      @lmv.peakLevel = 0.1
      @lmv.instance_variable_get("@peakLight").should == 2
      @lmv.colorForLight(2).should == @lmv.thresholdColors[0].CGColor
    end

    it "should use high color for high peak light" do
      @lmv.peakLevel = 1
      @lmv.instance_variable_get("@peakLight").should == 29
      @lmv.colorForLight(29).should == @lmv.thresholdColors[2].CGColor
    end

  end
  
  describe "LevelMeterView intensityForLight" do
    
    it "should give intensity 1 for light 0 when level = 2/30" do
      @lmv.level = 2.0 / 30
      @lmv.intensityForLight(0).should == 1
    end

    it "should give intensity 0 for light 3 when level = 2/30" do
      @lmv.level = 2.0 / 30
      @lmv.intensityForLight(3).should == 0
    end

    it "should give intensity 0.5 for light 0 when level = 0.5/30" do
      @lmv.level = 0.5 / 30
      @lmv.intensityForLight(0).should.be.close 0.5, 0.01
    end

    it "should give intensity 1 for peak light" do
      @lmv.level = 0.5
      @lmv.intensityForLight(29).should == 0
      @lmv.peakLevel = 1
      @lmv.intensityForLight(29).should == 1
    end

  end
end
