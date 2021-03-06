require 'tempfile'
require 'socket'
require 'securerandom'
require 'os'

module Dklet::Util
  module_function

  def human_timestamp(t = Time.now)
    t.strftime("%Y%m%d%H%M%S")
  end

  def tmpfile_for(str, prefix: 'dklet-tmp')
    file = Tempfile.new(prefix)
    file.write str
    file.close # save to disk
    # unlink清理问题：引用进程结束时自动删除？👍 
    file.path
  end

  def host_ip
    Socket.ip_address_list.find { |ai| ai.ipv4? && !ai.ipv4_loopback? }.ip_address
  end

  def host_os
    ::OS
  end

  def on_mac?
    host_os.mac?
  end

  def single_line?(cmds)
    return false if cmds.is_a? Array
    cmds = cmds.chomp
    return false if cmds =~ /\n/
    return true if cmds =~ /^\s*(bash|sh)/ 
    return false if cmds =~ /.+;/
    true
  end

  ## secure
  def gen_password(len = 10)
    SecureRandom.alphanumeric(len)
  end
end
