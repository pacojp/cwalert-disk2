class Checker
  attr_accessor :verbose, :hostname, :mount_points, :warning_hours,
    :room_id, :token, :users_to

  def initialize(config)
    self.verbose = config["verbose"] || false
    self.hostname = config["hostname"] || `hostname`.strip
    self.mount_points = config["mount_points"]
    self.warning_hours = config["warning-hours"] || []
    self.room_id  = config["cw"]["room-id"]
    self.token    = config["cw"]["token"]
    self.users_to = config["cw"]["users-to"] || []
  end

  def logging(st)
    return if verbose == false
    puts st if verbose == true || verbose.to_i == 1
  end

  def check
    logging "start checking!"
    # only centos, amazonlinux checked!
    state = :normal
    mount_points.each do |mp|
      mount_point = mp["mount_point"]
      warning = mp["warning"].to_i
      critical = mp["critical"].to_i

      logging "checking mount_point #{mount_point}"
      unless mount_point =~ /\A\//
        puts "mount_point error #{mount_point}"
        next
      end

      result = `df | grep " #{mount_point}$"`.split(" ")[-2]
      if result.nil?
        puts "!mount_point error"
      elsif result =~ /(\d+)%/
        usage = $1.to_i
        logging "=> usaeg: #{usage} warning: #{warning} critical: #{critical}"
        usage > warning  && state = :warning
        usage > critical && state = :critical
        proceed_with_state mount_point, state, usage
      else
        puts "disk size chekck format error(not your fault)"
      end
    end
    logging "finish checking!"
  end

  def proceed_with_state(mount_point, state, usage)
    return if state == :normal
    return if state == :warning && !warning_hours.include?(Time.now.hour)
    report ";( disk usage #{state}", "#{state}! #{mount_point} disk usage is #{usage}%"
  end

  def report(title, message)
    logging "===> reporting #{title} #{message}"
    tos = users_to.map{ |u| "[To:#{u}]" }.join("\n")
    tos += "\n" if tos.size > 0
    message = %|[info][title][#{hostname}] #{title}[/title]#{message}[/info]|
    `curl -s -S -X POST -H "X-ChatWorkToken: #{token}" -k -d "body=#{tos}#{message}" "https://api.chatwork.com/v2/rooms/#{room_id}/messages"`
  end
end

def usage
  puts "Usage: cwalert-disk2 CONFIG_FILE"
end

def __main__(argv)
  if argv.size != 2
    usage
    return
  end

  case argv[1]
  when "version"
    puts "v#{CwalertDisk::VERSION}"
  else
    config_file = argv[1]
    unless File.exist?(config_file)
      usage
      return
    end
    j = File.read(config_file)
    Checker.new(JSON.parse(j)).check
  end
end
