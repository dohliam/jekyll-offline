#!/usr/bin/env ruby

require 'erb'
require 'fileutils'
require 'uri'
require 'yaml'

require_relative 'lib_rellinks.rb'

def copy_src_dir(src, trg)
  dir_contents = Dir.glob(src + "*")
  dir_contents.each do |d|
    basename = File.basename(d)
    if basename == ".git"
      next
    end
    FileUtils.cp_r(d, trg)
  end
end

def preprocess_html(html)
  html = prune_base(html)
end

def postprocess_html(html)
  html.gsub(/https:\/\/@/, "https://")
end

def boilerplate(out_dir)
  $site_title = @config[:site_title]
  $site_url = @config[:site_url]
  $site_logo = @config[:site_logo]
  content = ERB.new(File.read("template.rhtml")).result
  File.open(out_dir + "START_HERE.html", "w") {|f| f << content }
end

def prune_base(html)
  if @config[:relative_base]
    html.gsub(/(href|src|data|value)(=["'])#{@config[:relative_base]}/, "\\1\\2")
  else
    html
  end
end

def clone_local_site(absolute_base, source_dir, out_dir)
  FileUtils.rm_rf(out_dir)
  FileUtils.mkdir_p(out_dir)
  boilerplate(out_dir)
  out_dir = out_dir + "site/"
  FileUtils.mkdir_p(out_dir)
  copy_src_dir(source_dir, out_dir)

  pages = Dir.glob(out_dir + "**/*.html")

  pages.each do |p|
    page_content = File.read(p)
    basename = File.basename(p)
    html = preprocess_html(page_content)
    page_output = convert_html(html, p, out_dir, absolute_base)
    page_output = postprocess_html(page_output)
    File.open(p, "w") {|f| f << page_output }
  end
end

@config = YAML::load(File.read("config.yml"))
custom_config = ARGV[0]
if custom_config
  @config = YAML::load(File.read(custom_config))
end

absolute_base = @config[:absolute_base]
source_dir = @config[:source_dir].gsub(/^~/, Dir.home)
out_dir = @config[:out_dir].gsub(/^~/, Dir.home)

clone_local_site(absolute_base, source_dir, out_dir)
