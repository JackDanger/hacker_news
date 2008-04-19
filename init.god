
God.watch do |w|
  dir = File.expand_path(File.dirname(__FILE__))
  w.name = "hackernews"
  w.interval = 30.seconds
  w.start = "ruby #{dir}/hackernews 2>&1 > #{dir}/log/god.log"
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 5.seconds
      c.running = false
    end
  end


  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 5
      c.within = 5.minute
      c.transition = :unmonitored
      c.retry_in = 10.minutes
      c.retry_times = 5
      c.retry_within = 2.hours
    end
  end
end
