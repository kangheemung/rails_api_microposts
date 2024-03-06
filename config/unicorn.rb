# config/unicorn.rb
worker_processes 2

working_directory "/path/to/your/app" # Railsアプリのパスを設定してください

listen "/path/to/your/app/tmp/sockets/unicorn.sock", :backlog => 64
listen 8080, :tcp_nopush => true

timeout 30

pid "/path/to/your/app/tmp/pids/unicorn.pid"

stderr_path "/path/to/your/app/log/unicorn.stderr.log"
stdout_path "/path/to/your/app/log/unicorn.stdout.log"

preload_app true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
end
