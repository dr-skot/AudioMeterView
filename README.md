# AudioMeterView

Written in RubyMotion. Based on the level meters in Apple's [Speak Here](http://developer.apple.com/library/ios/#samplecode/SpeakHere/Introduction/Intro.html) example app.

## Synopsis

```ruby
@meter = AudioMeterView.alloc.initWithFrame frame
view.addSubview(@meter)
@meter.input = @audioRecorder
```

<code>AudioMeterView</code> takes as <code>input</code> an <code>AVAudioRecorder</code> or any other object that responds to

```ruby
updateMeters
```

and <em>either</em>

```ruby
averagePowerForChannel(channel)
peakPowerForChannel(channel)
```

or

```ruby
averagePower
peakPower
```

The latter methods are used if they exist. Otherwise the former methods are called, with a channel of 0 unless you explicitly set the <code>AudioMeterView</code>'s <code>channel</code> attribute.

The meter begins displaying when you set the <code>AudioMeterView</code>'s <code>input</code>. When you set <code>input</code> to <code>nil</code>, the meter lights gradually fall to zero.
