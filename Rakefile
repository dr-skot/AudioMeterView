# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

if RUBYMOTION_ENV == 'test'
   require 'rubygems'
   require 'motion-stump'
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'AudioMeterView'

  app.frameworks << "CoreAudio"
  app.frameworks << "AVFoundation"
end
