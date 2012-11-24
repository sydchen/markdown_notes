require 'markdown_converter'

class Note < ActiveRecord::Base
  attr_accessible :title, :content, :updated_at

  def self.from_file(file_path, title)
    markdown = MarkdownConverter.new(file_path)
    html_source = markdown.to_s

    note = Note.find_by_title(title)
    if note != nil
      file_mtime = File.new(file_path).mtime
      if note.updated_at < file_mtime
        puts "update: " + title
        note.update_attributes(:title => title, :content => html_source, :updated_at => file_mtime)
      end  
    else    
      puts "create: " + title
      Note.create(:title => title, :content => html_source, :updated_at => File.new(file_path).mtime)
    end  
  end

  def self.search(search)
    if search
      where('title LIKE ?', "%#{search}%")
    else
      scoped
    end
  end


end
