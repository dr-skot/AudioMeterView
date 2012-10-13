class LevelMeterView < UIView
  attr_accessor :level
  attr_accessor :peakLevel
  attr_accessor :numLights
  attr_accessor :vertical
  attr_accessor :thresholdColors
  attr_accessor :thresholds
  attr_accessor :variableIntensity

  def peakLight
    @peakLight
  end

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
    @backgroundColor = UIColor.alloc.initWithRed(0, green:0, blue:0, alpha:0.6)
    @borderColor = UIColor.alloc.initWithRed(0, green:0, blue:0, alpha:1)
    @level = 0
    @peakLevel = 0
    @numLights = 30
    @vertical = bounds.size.width < bounds.size.height
    @thresholdColors = [UIColor.greenColor, UIColor.yellowColor, UIColor.redColor]
    @thresholds = [0.25, 0.8, 1]
    @variableIntensity = true
  end

  def peakDb=(db)
    self.peakLevel = 10 ** (0.05 * db)
  end

  def db=(db)
    self.level = 10 ** (0.05 * db)
  end

  def peakLevel=(level)
    @peakLevel = level
    @peakLight = -1
    if (@peakLevel > 0)
      @peakLight = (@peakLevel * @numLights).to_i
      @peakLight = @numLights - 1 if @peakLight >= @numLights
    end
  end

  def clear
    @needsClearing = true
    setNeedsDisplay
  end

  def drawRect(rect)

    cxt = UIGraphicsGetCurrentContext()
    cs = CGColorSpaceCreateDeviceRGB()

    CGContextClearRect(cxt, bounds) if @needsClearing
    
    CGContextSetFillColorSpace(cxt, cs)
    CGContextSetStrokeColorSpace(cxt, cs)

    if (@vertical)
      CGContextTranslateCTM(cxt, 0, bounds.size.height)
      CGContextScaleCTM(cxt, 1, -1)
      bds = bounds
    else
      CGContextTranslateCTM(cxt, 0, bounds.size.height)
      CGContextRotateCTM(cxt, -Math::PI / 2)
      bds = CGRectMake(0, 0, bounds.size.height, bounds.size.width)
    end

    # @backgroundColor.set
    # CGContextFillRect(cxt, bds)
    
    lightMinVal = 0
    lightVSpace = bds.size.height / @numLights
    if (lightVSpace < 4) 
      insetAmount = 0
    elsif (lightVSpace < 8) 
      insetAmount = 0.5
    else 
      insetAmount = 1
    end
    
    0.upto(@numLights - 1) do |lightNum|

      lightMaxVal = (lightNum + 1).to_f / @numLights

      lightRect = CGRectMake(0, lightMinVal * bds.size.height, bds.size.width, lightVSpace)
      lightRect = CGRectInset(lightRect, insetAmount, insetAmount)
      
      if (@backgroundColor)
        @backgroundColor.set
        CGContextFillRect(cxt, lightRect)
      end

      lightColor = colorForLight(lightNum)
      lightColor = adjustColorForIntensity(lightColor, lightNum) if lightColor && @variableIntensity

      if (lightColor)
        CGContextSetFillColorWithColor(cxt, lightColor);
        CGContextFillRect(cxt, lightRect)
      end

      if (@borderColor)
        @borderColor.set
        CGContextStrokeRect(cxt, CGRectInset(lightRect, 0.5, 0.5))
      end
      
      lightMinVal = lightMaxVal
    end

  end

  def colorForLight(lightNum)
    lightLevel = lightNum.to_f / @numLights
    return nil if @level < lightLevel && lightNum != @peakLight
    thresholds.each_with_index do |threshold, i|
      return thresholdColors[i].CGColor if (lightLevel <= threshold)
    end
    return nil
  end

  def intensityForLight(lightNum)
    return 1 if lightNum == @peakLight
    intensity = @level * @numLights - lightNum
    [[intensity, 0.0].max, 1.0].min
  end

  def adjustColorForIntensity(color, lightNum)
    intensity = intensityForLight(lightNum)
    return color if (intensity >= 1)
    return nil if (intensity <= 0)
    color = CGColorCreateCopyWithAlpha(color, intensity)
  end

end


