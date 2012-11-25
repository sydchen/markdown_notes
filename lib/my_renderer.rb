# encoding: utf-8
require 'redcarpet'

class MyHTMLRenderer < Redcarpet::Render::HTML
  attr_reader :stack

  def initialize(flags = {})
    super
    @stack = []
  end  

  def header(title, header_level)
    stack.push({ :level => header_level, :title => title })

    case header_level
    when 1
      "<h1>#{title}</h1>"

    when 2
      "<h2>#{title}</h2>"

    when 3
      "<h3>#{title}</h3>"
    end
  end
end

