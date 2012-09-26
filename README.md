# AudioMeterView.rb

Written in RubyMotion. Based on the level meters in Apple's (http://developer.apple.com/library/ios/#samplecode/SpeakHere/Introduction/Intro.html)[Speak Here] example app.

## Synopsis

```ruby
@meter = AudioMeterView.alloc.initWithFrame frame
view.addSubview(@meter)
@meter.input = @audioRecorder
```

<code>AudioMeterView</code> takes an <code>AVAudioRecorder</code> or any other object that responds to

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

When you set the <code>AudioMeterView</code>'s <code>input</code> property, the meter begins displaying the average power and peak power. When you set <code>input</code> to <code>nil</code>, the meter lights gradually fall to zero.
