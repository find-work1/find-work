class Ticker < ActiveRecord::Base
  validates :name, presence: true
  @queue = :file_serve
  def kill
    pid = `ps aux | grep #{"asd"} | awk 'NR==1{print $2}' | cut -d' ' -f1`.chomp
    `kill -9 #{pid}`
    # Process.kill 9, pid
    # Process.wait pid
    # `kill -9 #{pid}`
  end
  def begin
    file_text = <<-RUBY
      while true
        #{self.content}
        sleep #{self.interval.to_f / 1000}
      end
    RUBY
    tempfile_name = SecureRandom.urlsafe_base64
    file = Tempfile.new(tempfile_name)
    tempfile_path = file.path
    file.write(file_text)
    file.close # saves the write
    cmd = <<-SH
      echo "load '#{tempfile_path}'" | rails console
    SH
    cmd_pid = spawn(cmd, pgroup: true) # cant get this pid to actually work
    self.update(process_name: tempfile_name)
    Process.detach(cmd_pid)
  end
end
