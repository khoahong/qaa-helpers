require 'spec_helper'

describe ReportHelper do

  before(:all) do
    @time_fixed    = Time.now.strftime('%Y-%m-%d_%H-%M-%S')
    @project_dir   = PROJECT_DIRECTORY
    @feature_name  = 'feature_name'
    @scenario_name = 'scenario_name'
    @step_name     = 'step_name'
  end

  it 'generate_file_path_and_name' do
    ReportHelper.generate_file_path_and_name(@project_dir, @time_fixed, @feature_name, @scenario_name, @step_name)
    expect(File.exist? "#{@project_dir}/#{@time_fixed}").to be true
    expect(File.exist? "#{@project_dir}/#{@time_fixed}/#{@feature_name}").to be true
    expect(File.exist? "#{@project_dir}/#{@time_fixed}/#{@feature_name}/#{@scenario_name}").to be true
  end

  it 'generate report folder' do
    scenario = 'scenario'
    allow(@feature_name).to receive(:underscore_all).and_return @feature_name
    allow(@scenario_name).to receive(:underscore_all).and_return @scenario_name
    allow(@step_name).to receive(:underscore_all).and_return @step_name
    allow(scenario).to receive(:feature).and_return @feature_name
    allow(scenario.feature).to receive(:name).and_return @feature_name
    allow(scenario).to receive(:name).and_return @scenario_name
    ReportHelper.generate_report_directory(@project_dir, @time_fixed, scenario, @step_name)
    expect(File.exist? "#{@project_dir}/#{@time_fixed}").to be true
    expect(File.exist? "#{@project_dir}/#{@time_fixed}/#{@feature_name}").to be true
    expect(File.exist? "#{@project_dir}/#{@time_fixed}/#{@feature_name}/#{@scenario_name}").to be true
  end
end
