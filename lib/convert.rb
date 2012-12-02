# encoding: utf-8
gem 'redcarpet', '=2.1.1'
require 'redcarpet'
require 'nokogiri'
require 'pygments.rb'
require 'fileutils'

class MarkdownConverter
  MARKDOWN_RE = /\.(md|markdown|txt)$/

  def initialize(file_name)
    @file_name = file_name
    @outout_file_name = file_name.sub(MARKDOWN_RE, '.html')
  end

  def to_html(text)
    flags = {
      :autolink => true,
      :fenced_code_blocks => true, 
      :tables => true,
      :strikethrough => true,
      :lax_htmlblock => true,
      :no_intraemphasis => true
    }

    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, flags)
    data = markdown.render(text)
  end

  def to_s
    markdown = File::read(@file_name)
    @html = to_html(markdown)
    syntax_highlighter(@html)
  end

  def to_file
    output_dir = File.join(File.dirname(__FILE__), 'output')
    FileUtils.mkdir_p(output_dir)
    output_file_path = File.join(output_dir, @outout_file_name)
    File.open(output_file_path, 'w') do |f|
      f.write(to_s)
    end
  end

  def syntax_highlighter(html)
    head = <<-HTML
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <link href="/GitHub2.css" rel="stylesheet" type="text/css">
  <link href="/pygments.css" rel="stylesheet" type="text/css">
  <link href="/bootstrap.css" rel="stylesheet" type="text/css">
  HTML
    #html.insert(0, head)
    doc = Nokogiri::HTML(html)

    doc.search("//pre//code[@class]/..").each do |pre|
      options = {:encoding => 'utf-8'}
      code = pre.children.first
      #code[:class]
      pre.replace Pygments.highlight(pre.text.rstrip, :lexer => 'ruby', :options => options)
      #pre.replace Albino.colorize(pre.text.rstrip, pre[:lang])
    end
    doc.to_s # doc.at_css("body").inner_html.to_s
  end

  def create_new_node(doc, name, attributes)
    node = Nokogiri::XML::Node.new name, doc
    attributes.each do |key, value|
      node[key] = value
    end    
    node  
  end
end

if __FILE__ == $0
  file_name = ARGV[0] || 'README.markdown'
  markdown = Markdown.new(file_name)
  #markdown.to_file
  puts markdown.to_s
end

