#!/bin/bash
APP_DB_USER=vagrant
APP_DB_PASS=vagrant
APP_DB_NAME=$APP_DB_USER

whoami
sudo apt update
sudo apt-get install -y make nodejs postgresql curl git
if [ ! -d "/home/vagrant/.asdf" ]; then
 whoami
 git_clone_asdf="git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1"
 sudo su vagrant --command "$git_clone_asdf"
fi
if ! grep -qF ". $HOME/.asdf/asdf.sh" /home/vagrant/.bashrc; then
 echo '. $HOME/.asdf/asdf.sh' >> /home/vagrant/.bashrc
fi
home_path=~/
echo $home_path
source ~/.bashrc
#echo $(cat ~/.bashrc)
echo $PATH
echo "----/home/vagrant/.asdf/bin/asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git ----"
/home/vagrant/.asdf/bin/asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
echo "----/home/vagrant/.asdf/bin/asdf install nodejs 14.18.1----"
/home/vagrant/.asdf/bin/asdf install nodejs 14.18.1
echo "----/home/vagrant/.asdf/bin/asdf global nodejs 14.18.1----"
/home/vagrant/.asdf/bin/asdf global nodejs 14.18.1
echo $PATH
sudo su - vagrant
echo $PATH
echo $(env)
sudo apt install postgresql
echo_command="psql --db postgres --command \"SELECT '$APP_DB_USER';\""
if ! sudo su vagrant --command "$echo_command" &> /dev/null; then
  # Set up `vagrant` user in PostgreSQL
  create_user_command="psql --command \"CREATE ROLE $APP_DB_USER WITH SUPERUSER CREATEDB LOGIN;\""
  sudo su postgres --command "$create_user_command"
  set_user_password="psql --command \"ALTER ROLE $APP_DB_USER WITH PASSWORD '$APP_DB_PASS';\""
  sudo su postgres --command "$set_user_password"
  create_user_db="psql --command \"CREATE DATABASE $APP_DB_NAME WITH OWNER=$APP_DB_USER;\""
  sudo su postgres --command "$create_user_db"
fi
cd /vagrant/js-fastify-blog/
make setup
