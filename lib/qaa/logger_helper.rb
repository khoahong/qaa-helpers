require 'logger'
require 'qaa/fixtures'

module Qaa
  class LoggerHelper
    attr_accessor :logger_file_path
    attr_accessor :progname
    attr_accessor :logger

    DEFAULT_SEVERITY = 'info'

    if (ENV['log_severity'] || Fixtures.instance['log_severity']).empty?
      LOG_SEVERITY= DEFAULT_SEVERITY
    else
      LOG_SEVERITY = ENV['log_severity'] || Fixtures.instance['log_severity']
    end

    LOGGER_LEVEL = { 'DEBUG':   :debug,
                     'INFO':    :info,
                     'WARNING': :warn,
                     'ERROR':   :error,
                     'SEVERE':  :fatal,
                     'UNKNOWN': :unknown }

    def self.log_step_info(info)
      @logger.info(info)
      file = File.open(@logger_file_path, "a")
      file.write("#{info}\n")
      file.close
    end

    def self.print_step_info(info)
      @logger.info(info)
    end

    def self.logger
      if RUBY_VERSION < '2.3.0'
        severity = Logger::Severity.const_get(LOG_SEVERITY.upcase)
      else
        severity = LOG_SEVERITY
      end
      @log                 = Logger.new(STDOUT)
      @log.level           = severity
      @log.datetime_format = '%Y-%m-%d %H:%M:%S'
      @log.progname        = @progname if @log.progname != @progname
      @log.formatter       = proc do |severity, datetime, progname, msg|
        "[#{datetime}]: #{severity[0, 3]} -- #{progname} - #{msg}\n"
      end
      @logger              = @log
      @log
    end

    def self.logger_file_path
      @logger_file_path
    end

    def self.logger_file_path=(file_path)
      @logger_file_path = file_path
    end

    def self.print_log_for_step(scenario, browser_log, *args)
      args.each { |arg|
        @logger.info(arg)
        file = File.open(@logger_file_path, "a")
        file.write("#{arg}\n")
        file.close
      }
      print_browser_log(browser_log)
      scenario.attach_file('info', File.new(@logger_file_path))
    end

    def self.print_browser_log(browser_log)
      unless browser_log.empty?
        browser_log.each do |log|
          level = LOGGER_LEVEL[log.level.to_sym]
          @logger.send(level, "Browser logs: #{log.message}")
          file = File.open(@logger_file_path, "a")
          file.write("Browser logs: #{log.message}\n")
          file.close

        end
      end
    end

    def self.update_step_for_logger(report_directory, report_folder, scenario = nil, step_name = nil)
      unless scenario.nil?
        file_path         = ReportHelper.generate_report_directory(report_directory, report_folder, scenario, step_name)
      else
        file_path         =  "#{report_directory}/#{report_folder}/Universal_Initialize"
      end

      @logger_file_path = "#{file_path}_running_log.log"
      unless step_name.nil?
        @progname         = step_name
      else
        @progname         = "Universal_Initialize"
      end

      @logger           = logger
    end

    def self.set_parameter(name, value)
      if name.nil? || name.to_s.empty?
        @logger.warn("The teamcity parameter name is required and can't be nil or empty. Parameter ignored")
      else
        if value.nil? || value.to_s.empty?
          @logger.warn("The teamcity parameter named:#{name} have empty or nil value and will be ignored.")
        else
          @logger.info "##teamcity[setParameter name='#{name}' value='#{value}']"
        end
      end
    end

    def self.add_stat(key, value)
      if key.nil? || key.to_s.empty?
        @logger.warn("The teamcity parameter key is required and can't be nil or empty. Statistic ignored")
      else
        if value.nil? || value.to_s.empty?
          @logger.warn("The teamcity parameter key:#{key} have empty or nil value and will be ignored.")
        else
          @logger.info("##teamcity[buildStatisticValue key='#{key}' value='#{value}']")
        end
      end
    end
  end
end

