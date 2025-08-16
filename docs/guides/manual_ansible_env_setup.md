# Manual Setup Guide for Ansible Development Environment

This guide provides **manual steps** to create a Python 3.12-based development environment for working with Ansible and various networking collections.

---

## 1. Install `virtualenv`

`virtualenv` allows you to create isolated Python environments so that dependencies from different projects do not conflict.

```bash
sudo pip install virtualenv
```

---

## 2. Install Python 3.12

Install Python 3.12 and its development headers (required for compiling certain Python packages).

```bash
sudo dnf install -y python3.12 python3.12-devel
python3.12 -V
```

---

## 3. Install `virtualenvwrapper`

`virtualenvwrapper` is a set of extensions for `virtualenv` that make it easier to manage multiple environments.

```bash
sudo pip install virtualenvwrapper
```

**What it does:**  
- Simplifies environment creation, activation, and deletion.  
- Keeps all environments in a single location (`$WORKON_HOME`).  
- Adds helper commands like `mkvirtualenv`, `workon`, and `rmvirtualenv`.

---

## 4. Edit `~/.bash_profile`

Your `~/.bash_profile` configures environment variables and settings for your shell.

```bash
vi ~/.bash_profile
```

Add the following:

```bash
export WORKON_HOME="$HOME/venvs"
VIRTUALENVWRAPPER_PYTHON='/usr/local/bin/python'
source /usr/local/bin/virtualenvwrapper.sh
```

---

## 5. Load the Updated Profile

Use the `source` command to reload your updated shell configuration:

```bash
source ~/.bash_profile
```

---

## 6. Create a Virtual Environment

Create a new environment for Ansible development using Python 3.12:

```bash
mkvirtualenv -p python3.12 dev_py312
```

---

## 7. Create Workspace & Clone Ansible Fork

```bash
cd ~
mkdir -p dev-workspace/ansible_collections/ansible
cd dev-workspace/ansible_collections/ansible
git clone git@github.com:rohitthakur2590/ansible.git
```

---

## 8. Configure `postactivate` Script

Edit the `postactivate` hook for your virtualenv:

```bash
vi ~/venvs/dev_py312/bin/postactivate
```

Add:

```bash
#!/bin/bash
cur_dir=`pwd`
cd ~/dev-workspace/ansible_collections/ansible/ansible
pip install -r requirements.txt
source hacking/env-setup
cd $cur_dir
clear
out="$(ansible --version)"
echo $out
```

---

## 9. Configure Upstream Branches

```bash
cd ~/dev-workspace/ansible_collections/ansible/ansible
git remote add upstream https://github.com/ansible/ansible
git remote -v
git fetch upstream
git rebase upstream/devel
git checkout -b stable-2.18 upstream/stable-2.18
git fetch upstream
git rebase upstream/stable-2.18
git push -f origin stable-2.18
```

---

## 10. Install Networking Collections

### **Netcommon**
```bash
cd ~/dev-workspace/ansible_collections/ansible/
git clone git@github.com:rohitthakur2590/ansible.netcommon.git
mv ansible.netcommon netcommon
cd netcommon
git remote add upstream https://github.com/ansible-collections/ansible.netcommon
git fetch upstream
git rebase upstream/main
git push -f origin main
```

### **Utils**
```bash
cd ~/dev-workspace/ansible_collections/ansible/
git clone git@github.com:rohitthakur2590/ansible.utils.git
mv ansible.utils utils
cd utils
git remote add upstream https://github.com/ansible-collections/ansible.utils
git fetch upstream
git rebase upstream/main
git push -f origin main
```

### **Cisco IOS**
```bash
cd ~/dev-workspace/ansible_collections/
mkdir -p cisco
cd cisco
git clone git@github.com:rohitthakur2590/cisco.ios.git
mv cisco.ios ios
cd ios
git remote add upstream https://github.com/ansible-collections/cisco.ios
git fetch upstream
git rebase upstream/main
git push -f origin main
```

### **Cisco IOSXR**
```bash
cd ~/dev-workspace/ansible_collections/
mkdir -p cisco
cd cisco
git clone git@github.com:rohitthakur2590/cisco.iosxr.git
mv cisco.iosxr iosxr
cd iosxr
git remote add upstream https://github.com/ansible-collections/cisco.iosxr
git fetch upstream
git rebase upstream/main
git push -f origin main
```

---

## Alternate Approach

Instead of running all these steps manually, you can automate the setup using the scripts:

- **`pre_ansible_collections_setup.sh`** → Prepares Python, virtualenvwrapper, and your environment.  
- **`bootstrap_collections.sh`** → Clones and configures all collections automatically.

These scripts can save significant time and avoid manual typing errors.

---
