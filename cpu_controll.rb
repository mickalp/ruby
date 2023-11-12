# Gemfile
# Add the following line to your Gemfile and run `bundle install`
# gem 'sys-proctable'

require 'sys/proctable'

class SystemMonitor
  def initialize
    @cpu_threshold = 80.0
    @memory_threshold = 90.0
  end

  def check_system_status
    puts "Checking system status..."

    # Check CPU usage
    cpu_usage = calculate_cpu_usage
    puts "CPU Usage: #{cpu_usage}%"
    notify_if_threshold_exceeded('CPU', cpu_usage, @cpu_threshold)

    # Check available memory
    available_memory = calculate_available_memory
    puts "Available Memory: #{available_memory} MB"
    notify_if_threshold_exceeded('Memory', available_memory, @memory_threshold)
  end

  private

  def calculate_cpu_usage
    processes = Sys::ProcTable.ps.group_by(&:pid)
    total_cpu_usage = processes.values.sum { |group| group.first.pctcpu }

    total_cpu_cores = Sys::CPU::info.size
    average_cpu_usage = total_cpu_usage / total_cpu_cores

    average_cpu_usage.round(2)
  end

  def calculate_available_memory
    Sys::ProcTable.psinfo.memsize / (1024 * 1024)
  end

  def notify_if_threshold_exceeded(component, current_value, threshold)
    if current_value > threshold
      puts "*** ALERT: #{component} usage is above the threshold (#{threshold}%). Take action! ***"
    else
      puts "#{component} usage is within acceptable limits."
    end
  end
end

# Usage
monitor = SystemMonitor.new
monitor.check_system_status

