#!/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby

require "osx/cocoa"
include OSX

interval = 3.0

class UpdateStatusItem
  def initialize
    tick
  end
  def tick(timer = nil)
    $statusitem.setTitle(title)
  end
  def title
    CPUTemperature()
  end

  def CPUTemperature
    IO.popen("/Applications/TemperatureMonitor.app/Contents/MacOS/tempmonitor -c -a -l -ds", "r") {|io|
      io.each {|line|
        if (/CPU\s+.+:\s*([0-9]+)/.match(line))
          return $1 + "℃"
        end
      }
    }
  end

end

app = NSApplication.sharedApplication
$statusitem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)

NSTimer.scheduledTimerWithTimeInterval_target_selector_userInfo_repeats(interval, UpdateStatusItem.new, :tick, nil, true)

app.run

