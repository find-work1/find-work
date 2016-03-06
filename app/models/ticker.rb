class Ticker < ActiveRecord::Base
  def create_and_execute_file
    return "" unless self.content.is_a?(String) && !(self.content.empty?)
    prefix = 'ticker'
    suffix = '.rb'
    t = Tempfile.new [prefix, suffix], "#{Rails.root}/tmp"
    t.write(self.content)
    path = t.path
    t.close
    return `ruby #{t.path}`
  end
end
