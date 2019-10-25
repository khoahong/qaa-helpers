require 'spec_helper'

describe Qaa::LoggerHelper do
  before (:all) do
    LoggerHelper.logger_file_path = "#{PROJECT_DIRECTORY}/test.log"
    @report_directory             = PROJECT_DIRECTORY
    @report_folder                = Time.now.strftime('%Y-%m-%d_%H-%M-%S')
    @log_severity                 = LoggerHelper::LOG_SEVERITY
    @date_time_format             = "%Y-%m-%d %H:%M:%S"
    @scenario                     = nil
    @logger                       = LoggerHelper.logger
  end

  it 'returns a ruby logger with right format and level' do
    expect(@logger.class).to eql Logger
    expect(@logger.level).to eql Logger::Severity::INFO
    expect(@logger.datetime_format).to eql @date_time_format
  end

  describe 'LoggerHelper.update_logger_progname' do
    before :all do
      @logger = LoggerHelper.new.logger
    end
    it 'update_logger_progname' do
      test_step = 'test_step'
      allow(ReportHelper).to receive(:generate_report_directory).and_return LoggerHelper.logger_file_path
      LoggerHelper.update_step_for_logger(@report_directory, @report_folder, @scenario, test_step)
      expect(LoggerHelper.logger.progname).to eql test_step
    end
  end

  describe 'LoggerHelper.set_parameter' do
    before :all do
      @logger = LoggerHelper.logger
    end
    it 'log a warn if the parameter name is nil or empty' do
      expect(@logger).to receive(:warn).with("The teamcity parameter name is required and can't be nil or empty. Parameter ignored").twice
      LoggerHelper.set_parameter(nil, 0)
      LoggerHelper.set_parameter('', 0)
    end

    it 'log a warn if the value of the parameter is nil or empty' do
      expect(@logger).to receive(:warn).with("The teamcity parameter named:name have empty or nil value and will be ignored.").twice
      LoggerHelper.set_parameter('name', nil)
      LoggerHelper.set_parameter('name', '')
    end

    it 'should log the teamcity parameter' do
      expect(@logger).to receive(:info).with("##teamcity[setParameter name='name' value='value']")
      LoggerHelper.set_parameter('name', 'value')
    end
  end

  describe 'LoggerHelper.add_stat' do
    before :all do
      @logger = LoggerHelper.logger
    end
    it 'log a warn if the parameter stat key is nil or empty' do
      expect(@logger).to receive(:warn).with("The teamcity parameter key is required and can't be nil or empty. Statistic ignored").twice
      LoggerHelper.add_stat(nil, 0)
      LoggerHelper.add_stat('', 0)
    end

    it 'log a warn if the value of the parameter is nil or empty' do
      expect(@logger).to receive(:warn).with("The teamcity parameter key:key have empty or nil value and will be ignored.").twice
      LoggerHelper.add_stat('key', nil)
      LoggerHelper.add_stat('key', '')
    end

    it 'should log the teamcity parameter' do
      expect(@logger).to receive(:info).with("##teamcity[buildStatisticValue key='key' value='10']")
      LoggerHelper.add_stat('key', '10')
    end
  end
end
