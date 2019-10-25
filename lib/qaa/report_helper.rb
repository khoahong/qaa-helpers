require_relative 'browser_formatter_helper'
module Qaa
  class ReportHelper
    attr_accessor :report_info


    def self.generate_report_directory(project_dir, report_folder, scenario, step_name)
      if scenario.is_a? RSpec::Core::Example
        feature_name  = underscore_all(File.basename(scenario.file_path, '.rb'))
        scenario_name = underscore_all(scenario.example_group.description)
      else
        feature_name  = underscore_all(scenario.feature.name)
        scenario_name = underscore_all(scenario.name)
      end
      generate_file_path_and_name(project_dir, report_folder, feature_name, scenario_name, underscore_all(step_name))
    end

    def self.generate_file_path_and_name(directory, folder_name, feature_name, scenario_name, step_name)
      time             = Time.now.strftime('%Y-%m-%d_%H-%M-%S')
      report_folder    = File.join("#{directory}", folder_name, feature_name, scenario_name)
      file_name        = step_name||scenario_name
      report_file_name = "#{file_name}_#{time}_#{Fixtures.instance['env']}_#{Fixtures.instance['venture']}"
      FileUtils.mkdir_p(report_folder)
      "#{report_folder}/#{report_file_name}"
    end

    def self.generate_report_for_step(scenario, report_directory, report_file)
      file = File.open("#{report_directory}#{report_file.file_name}#{report_file.file_extension}", "a")
      file.write(report_file.file_content) unless report_file.file_content.nil? || report_file.file_content.empty?
      file.close
      attach_file_to_allure(scenario, report_file)
    end

    def self.take_step_screenshot(browser, scenario, screenshot_file_path)
      screenshot_file_name = "#{screenshot_file_path}_screenshot.png"
      browser.screenshot.save(screenshot_file_name)
      attach_file_to_allure(scenario, ReportFile.new(file_name: 'screenshot', file_path: screenshot_file_path, file_extension: '.png'))
      screenshot_file_name
    end

    def self.attach_file_to_allure(scenario, report_file)
      file = "#{report_file.file_path}#{report_file.file_name}#{report_file.file_extension}"
      attachment = attach_file(report_file.file_name, File.new(file)) if File.exist?(file)
      attachment
    end

    def self.report_info
      @report_info
    end

    def self.add_info_report(info)
      if @report_info.nil?
        @report_info = info
      else
        @report_info += info
      end
    end

    def self.underscore_all(temp_string)
      temp_string.gsub(/[^a-zA-Z0-9]/, '_').gsub(/^_*|_*$/, '')
    end
  end

  class ReportFile
    attr_accessor :file_path, :file_name, :file_extension, :file_content
    def initialize(data={})
      @file_name      = data[:file_name]
      @file_extension = data[:file_extension]
      @file_content   = data[:file_content]
      @file_path      = data[:file_path]
    end
  end
end
