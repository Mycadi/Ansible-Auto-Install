#!/bin/sh

#需要先安装支持包
yum install -y kernel-devel zlib-devel openssl-devel readline-devel

#libxslt-devel libffi-devel python-devel mysql-devel readline-devel
#pycparser-2.18.tar.gz
#cffi-1.11.3.tar.gz
#six-1.11.0.tar.gz
#asn1crypto-0.22.0.tar.gz
#idna-2.6.tar.gz
#cryptography-2.1.4.tar.gz
#paramiko-2.4.0.tar.gz
#PyYAML-3.12.tar.gz
#MarkupSafe-1.0.tar.gz
#Jinja2-2.10.tar.gz
#pyasn1-0.4.2.tar.gz
#PyNaCl-1.2.1.tar.gz
#bcrypt-3.1.4.tar.gz

#判断OPT是否有安装文件夹
if [ ! -d "/opt/ansible" ]; then
    echo "No folder was found."
    exit;
fi

#RPM安装
cd /opt/ansible
rpm -ivh libffi-devel-3.0.13-18.el7.x86_64.rpm

#安装sshpass用于通信
cd /opt/ansible
tar xvzf sshpass-1.06.tar.gz
cd sshpass-1.06
./configure && make && make install
cp /usr/local/bin/sshpass /usr/bin/sshpass

#因离线安装，故将安装所需压缩包放在服务器/opt/ansible文件夹下（请先创建ansible文件夹）
#（1）python3.6.4安装
cd /opt/ansible
tar Jxvf Python-3.6.4.tar.xz
cd Python-3.6.4
./configure --prefix=/usr/local/python3.6.4
make
make install
# 将python头文件拷贝到标准目录，以避免编译ansible时，找不到所需的头文件
cd /usr/local/python3.6.4/include/python3.6m
\cp * /usr/local/include/
# 备份旧版本的python，并符号链接新版本的python
cd /usr/bin
rm -rf python.old
mv python python.old
rm -rf  /usr/local/bin/python.old
mv /usr/local/bin/python /usr/local/bin/python.old
ln -s /usr/local/python3.6.4/bin/python3.6 /usr/local/bin/python
\cp /usr/local/python3.6.4/bin/python3.6 /usr/bin/python
# 修改yum脚本，使其指向旧版本的python，已避免其无法运行 redhat老版本需要改对应python版本
sed -i 's/\/usr\/bin\/python/\/usr\/bin\/python2.7/g' /usr/bin/yum
sed -i 's/\/usr\/bin\/python/\/usr\/bin\/python2.7/g' /usr/libexec/urlgrabber-ext-down

#(2)模块安装
cd /opt/ansible
tar xvzf pycparser-2.18.tar.gz
cd pycparser-2.18
python setup.py install
#
cd /opt/ansible
tar xvzf cffi-1.11.3.tar.gz
cd cffi-1.11.3
python setup.py install
#
cd /opt/ansible
tar xvzf six-1.11.0.tar.gz
cd six-1.11.0
python setup.py install
#
cd /opt/ansible
tar xvzf asn1crypto-0.22.0.tar.gz
cd asn1crypto-0.22.0
python setup.py install
#
cd /opt/ansible
tar xvzf idna-2.6.tar.gz
cd idna-2.6
python setup.py install
#
cd /opt/ansible
tar xvzf cryptography-2.1.4.tar.gz
cd cryptography-2.1.4
python setup.py install
#
cd /opt/ansible
tar xvzf paramiko-2.4.0.tar.gz
cd paramiko-2.4.0
python setup.py install
#
cd /opt/ansible
tar xvzf PyYAML-3.12.tar.gz
cd PyYAML-3.12
python setup.py install
#
cd /opt/ansible
tar xvzf MarkupSafe-1.0.tar.gz
cd MarkupSafe-1.0
python setup.py install
#
cd /opt/ansible
tar xvzf Jinja2-2.10.tar.gz
cd Jinja2-2.10
python setup.py install
#
cd /opt/ansible
tar xvzf pyasn1-0.4.2.tar.gz
cd pyasn1-0.4.2
python setup.py install
#
cd /opt/ansible
tar xvzf PyNaCl-1.2.1.tar.gz
cd PyNaCl-1.2.1
python setup.py install
#
cd /opt/ansible
tar xvzf bcrypt-3.1.4.tar.gz
cd bcrypt-3.1.4
python setup.py install
#安装ansible
cd /opt/ansible
tar xvzf ansible-2.4.2.0.tar.gz
cd ansible-2.4.2.0
python setup.py install



#(3)ansible命令加入bin，配置文件
rm -rf /usr/bin/ansible*
ln -s /usr/local/python3.6.4/bin/ansible* /usr/bin
rm -rf /etc/ansible
mkdir -p /etc/ansible
cp /opt/ansible/ansible.cfg /etc/ansible/
cp /opt/ansible/hosts /etc/ansible/
