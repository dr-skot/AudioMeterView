class Controller < UIViewController
  
  def viewDidLoad
    super
    
    w = view.bounds.size.width
    h = view.bounds.size.height
    
    @button = UIButton.buttonWithType UIButtonTypeRoundedRect
    @button.setTitle "start", forState:UIControlStateNormal
    @button.sizeToFit
    @button.addTarget self, action:"startStopButton",
                      forControlEvents:UIControlEventTouchUpInside
    view.addSubview(@button)
    
    @button.center = [w/2, h-100]

    frame = [[w/2-10, 10], [20, h/2]]
    @audioMeter = AudioMeterView.alloc.initWithFrame frame
    view.addSubview(@audioMeter)

  end

  def startStopButton
    if @audioRecorder && @audioRecorder.recording?
      stopRecording
      @button.setTitle "start", forState:UIControlStateNormal
    else
      startRecording
      @button.setTitle "stop", forState:UIControlStateNormal
    end
  end

  def startRecording
    session = AVAudioSession.sharedInstance
    err_ptr = Pointer.new :object
    session.setCategory AVAudioSessionCategoryRecord, error:err_ptr

    return handleAudioError(err_ptr[0]) if err_ptr[0]

    # create the recorder
    @audioRecorder = 
      AVAudioRecorder.alloc.initWithURL url, settings:settings, error:err_ptr
    @audioRecorder.setMeteringEnabled true

    # start recording
    if @audioRecorder.prepareToRecord
      @audioRecorder.record
    else
      raise "should get an error if prepareToRecord returns false" unless err_ptr[0]
      return handleAudioError(err_ptr[0])
    end
    
    @audioMeter.input = @audioRecorder
  end

  def stopRecording
    @audioRecorder.stop if @audioRecorder
    @audioMeter.input = nil
  end

  def url
    return @url if @url
    path = NSTemporaryDirectory().stringByAppendingPathComponent("AudioMeterView.caf")
    @url = NSURL.fileURLWithPath(path)
  end

  def settings
    @settings ||= {
      :AVFormatIDKey => KAudioFormatAppleIMA4,
      :AVSampleRateKey => 16000,
      :AVNumberOfChannelsKey => 1,
      :AVLinearPCMBitDepthKey => 16,
      :AVLinearPCMIsBigEndianKey => false,
      :AVLinearPCMIsFloatKey => false
    }
  end
    
end
