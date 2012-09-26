class MeterDemoController < UIViewController
  def viewDidLoad
    super

    meter = LevelMeterView.alloc.initWithFrame(CGRectMake(0, 100, 270, 20))
    meter.level = 0.25
    meter.peakLevel = 0.5
    view.addSubview(meter)

    meter = LevelMeterView.alloc.initWithFrame(CGRectMake(0, 130, 270, 20))
    meter.level = 0.5
    meter.peakLevel = 0.75
    view.addSubview(meter)

    meter = LevelMeterView.alloc.initWithFrame(CGRectMake(0, 160, 270, 20))
    meter.level = 0.75
    meter.peakLevel = 1
    view.addSubview(meter)

  end
  
end
