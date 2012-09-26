class AudioMeterView < UIView
  attr_accessor :input
  attr_accessor :channel

  KPeakFalloffPerSec = 0.7
  KLevelFalloffPerSec = 0.8
  KFalloffExtraTicks = 5

  def initWithFrame(frame)
    super(frame)
    initCommon
    self
  end

  def initWithCoder(decoder)
    super(decoder)
    initCommon
    self
  end

  def initCommon
    @meter = LevelMeterView.alloc.initWithFrame(bounds)
    addSubview(@meter)
    @channel = 0
  end

  def input=(input)
    @input = input
    if nil == input
      @falloffLastTick = Time.now
      @falloffExtraTicks = KFalloffExtraTicks
    else
      @timer.invalidate if @timer
      @timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector:'refresh',
                                                      userInfo:nil, repeats:true)
      refresh
    end
  end
  
  def falloff
    thisTick = Time.now
    
    # calculate how much time passed since the last draw
    timePassed = thisTick - @falloffLastTick
    
    # level
    newLevel = @meter.level - timePassed * KLevelFalloffPerSec
    newLevel = 0 if newLevel < 0
    @meter.level = newLevel
    
    # peak
    newPeak = @meter.peakLevel - timePassed * KPeakFalloffPerSec
    newPeak = 0 if newPeak < 0
    @meter.peakLevel = newPeak

    # stop the timer a few ticks after the peak level hits 0
    # (extra ticks are needed to finish fading out all the lights)
    if newPeak <= 0
      @falloffExtraTicks -= 1
      if @falloffExtraTicks <= 0
        @timer.invalidate if @timer
        @timer = nil
      end
    end
    
    @falloffLastTick = thisTick;
  end

  def refresh
    if (input)
      input.updateMeters
      if input.respond_to? :averagePower
        @meter.db = input.averagePower
        @meter.peakDb = input.peakPower
      else
        @meter.db = input.averagePowerForChannel @channel
        @meter.peakDb = input.peakPowerForChannel @channel
      end
    else
      falloff
    end
    @meter.setNeedsDisplay
    @refreshed = true
  end

end
