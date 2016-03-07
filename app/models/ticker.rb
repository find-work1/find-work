class Ticker < ActiveRecord::Base
  validates :name, presence: true
  @queue = :file_serve
  def interval=(val)
    val ||= 1000
    super(val)
  end
  def kill
    pid = `ps aux | grep #{process_name.first(5)} | awk 'NR==1{print $2}'`.chomp
    `kill -9 #{pid}`
  end
  def begin
    tempfile_name = SecureRandom.urlsafe_base64
    file = Tempfile.new(tempfile_name)
    file_text = <<-RUBY
      $0 = "#{tempfile_name}"
      while true
        #{self.content}
        sleep #{self.interval.to_f / 1000}
      end
    RUBY
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
