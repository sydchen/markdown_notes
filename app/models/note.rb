require 'convert'

class Note < ActiveRecord::Base
  attr_accessible :title, :content, :updated_at

  searchable do
    text :title, :content
  end

  def self.from_file(file)
    markdown = MarkdownConverter.new(file)
    html_source = markdown.to_s

    title = File.basename(file, '.*')
    note = Note.find_by_title(title)
    if note
      file_mtime = File.new(file).mtime
      if note.updated_at < file_mtime
        puts "update: " + title
        note.update_attributes(:title => title, :content => html_source, :updated_at => file_mtime)
      end  
    else    
      puts "create: " + title
      Note.create(:title => title, :content => html_source, :updated_at => File.new(file).mtime)
    end  
  end

#  def self.search(search)
#    if search
#      where('title LIKE ?', "%#{search}%")
#    else
#      scoped
#    end
#  end
end
