# По умолчанию для дистрибуции проектов используется Bundler.
# Эта строка включает автоматическое обновление и установку
# недостающих gems, указанных в вашем Gemfile.
#
## !!! Не забудьте добавить
# gem 'capistrano'
# gem 'unicorn'
#
# в ваш Gemfile.
#
# Если вы используете другую систему управления зависимостями,
# закомментируйте эту строку.
require 'bundler/capistrano'

## Чтобы не хранить database.yml в системе контроля версий, поместите
## dayabase.yml в shared-каталог проекта на сервере и раскомментируйте
## следующие строки.

after "deploy:update_code", :copy_database_config_restart_worker
task :copy_database_config_restart_worker, roles => :app do
  db_config = "#{shared_path}/database.yml"
  protected_path = "#{shared_path}/protected.yml"
  run "cp #{db_config} #{release_path}/config/database.yml"
  run "cp #{protected_path} #{release_path}/config/protected.yml"
  ## run "kill -9 `cat #{shared_path}/pids/delayed_job.pid` && cd #{release_path} && /usr/local/rvm/bin/rvm use #{rvm_ruby_string} do bundle exec rake maintainance:worker RAILS_ENV=production"
  #run "echo '#{rvm_ruby_string}' > #{release_path}/.ruby-version"

end

# В rails 3 по умолчанию включена функция assets pipelining,
# которая позволяет значительно уменьшить размер статических
# файлов css и js.
# Эта строка автоматически запускает процесс подготовки
# сжатых файлов статики при деплое.
# Если вы не используете assets pipelining в своем проекте,
# или у вас старая версия rails, закомментируйте эту строку.
load 'deploy/assets'

# Для удобства работы мы рекомендуем вам настроить авторизацию
# SSH по ключу. При работе capistrano будет использоваться
# ssh-agent, который предоставляет возможность пробрасывать
# авторизацию на другие хосты.
# Если вы не используете авторизацию SSH по ключам И ssh-agent,
# закомментируйте эту опцию.
ssh_options[:forward_agent] = true

# Имя вашего проекта в панели управления.
# Не меняйте это значение без необходимости, оно используется дальше.
set :application,     "musicobserver"

# Сервер размещения проекта.
set :deploy_server,   "78.47.216.218"

# Не включать в поставку разработческие инструменты и пакеты тестирования.
set :bundle_without,  [:development, :test]
set :bundle_env_variables, { cc: 'gcc46', cxx: 'g++46', cpp: 'cpp46' } 

set :user,            "hostingservice"
set :login,           "w00lf"
set :use_sudo,        false
set :deploy_to,       "/usr/local/www/projects/#{application}"
set :unicorn_conf,    File.join(fetch(:shared_path), 'unicorn.rb')
set :unicorn_pid,     File.join(fetch(:shared_path), 'unicorn.pid')
set :bundle_dir,      File.join("/usr/local/www/projects/shared", 'gems')
set :rails_env,       "production"
role :web,            deploy_server
role :app,            deploy_server
role :db,             deploy_server, :primary => true

# Следующие строки необходимы, т.к. ваш проект использует rvm.
# set :rvm_ruby_string, "2.1.0"
set :rake,            "bundle exec rake" 
# set :bundle_cmd,      "bundle"

# Настройка системы контроля версий и репозитария,
# по умолчанию - git, если используется иная система версий,
# нужно изменить значение scm.
set :scm,             :git

# Предполагается, что вы размещаете репозиторий Git в вашем
# домашнем каталоге в подкаталоге git/<имя проекта>.git.
# Подробнее о создании репозитория читайте в нашем блоге
# http://locum.ru/blog/hosting/git-on-locum
set :repository,      "https://github.com/w00lf/music_observer.git"

## Если ваш репозиторий в GitHub, используйте такую конфигурацию
# set :repository,    "git@github.com:username/project.git"

before 'deploy:finalize_update', 'set_current_release'
task :set_current_release, :roles => :app do
    set :current_release, latest_release
end

set :unicorn_start_cmd, "(cd #{deploy_to}/current; bundle exec unicorn_rails -Dc #{unicorn_conf})"


# - for unicorn - #
namespace :deploy do
  desc "Start application"
  task :start, :roles => :app do
    run unicorn_start_cmd
  end

  desc "Stop application"
  task :stop, :roles => :app do
    run "[ -f #{unicorn_pid} ] && kill -QUIT `cat #{unicorn_pid}`"
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "[ -f #{unicorn_pid} ] && kill -USR2 `cat #{unicorn_pid}` || #{unicorn_start_cmd}"
  end
end


