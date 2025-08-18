# 🛠️ Network Automation Tools

A curated set of playbooks, docs, and utilities for **network automation** using **Ansible** and **Ansible Automation Platform (AAP)**.  
This repository provides examples, guides, and pre-built utilities to help you get started with automating network tasks such as **backup, restore, network reports, healthchecks and controller-as-code**.

---

## 📂 Repository Structure

### 🔹 `build-ee`
Contains resources to **build custom Execution Environments (EEs)** for Ansible.  
- `requirements.yml` → Collection dependencies  
- `requirements.txt` → Python package dependencies  
- `vc-execution-environment.yml` → Sample EE definition  
- Scripts for cleaning up and building images with **Podman**

Usage:
```bash
ansible-builder build -f vc-execution-environment.yml -t network-ee:latest
```

---

### 🔹 `controller-as-code`
Contains examples and configs for **AAP Controller-as-Code** workflows.  
Useful for managing organizations, projects, inventories, and job templates via playbooks instead of manual UI clicks.

---

### 🔹 `docs`
Documentation and **step-by-step guides**.  
Includes:
- Ansible environment setup (`ansible_env_setup_guide.png`)  
- Navigator setup (`ansible_navigator_setup.png`)  
- EE usage examples   

---

### 🔹 `playbooks`
Example playbooks categorized by use cases:

#### ✅ Collections
`requirements.yml` for installing required collections.

#### ✅ Examples
- **Backup** → `create_backup.yml`, `restore_config.yml`  
- **Inventories** → Example inventory structures  

Example: Backup network device configs
```yaml
- name: Backup IOS devices
  hosts: nxos
  gather_facts: no
  tasks:
    - include_tasks: playbooks/examples/backup/create_backup.yml
```

---

### 🔹 `videos`
Demo recordings and walk-throughs showcasing:
- How to run playbooks  
- Using Controller-as-Code  
- Execution Environment builds  
- End-to-end network automation flows  

---

## 🚀 Getting Started

1. Clone the repo:
   ```bash
   git clone https://github.com/rohithakur2590/network_automation_tools.git
   cd network_automation_tools
   ```

2. Install required Ansible collections:
   ```bash
   ansible-galaxy collection install -r playbooks/collections/requirements.yml
   ```

3. Run an example playbook:
   ```bash
   ansible-playbook playbooks/examples/backup/create_backup.yml -i playbooks/inventories/ansible.cfg
   ```

---

## 📌 Features
- Ready-to-use **backup & restore** playbooks  
- Pre-configured **Execution Environment (EE)** build files  
- **Controller-as-Code** examples for AAP  
- Guides & visuals for easy onboarding  
- Demo videos for hands-on learning  

---

## 🤝 Contributing
Contributions are welcome!  
- Fork the repo  
- Create a feature branch  
- Submit a PR  

Please follow the linting rules defined in:
- `.ansible-lint.yml`
- `.yamllint.yml`
- `.pre-commit-config.yaml`

---

## 📜 License
This project is licensed under the [MIT License](LICENSE).

---

## 🌐 Useful Links
- [Ansible Documentation](https://docs.ansible.com/)  
- [Ansible Automation Platform](https://www.redhat.com/en/technologies/management/ansible)  
- [Ansible Builder](https://ansible.readthedocs.io/projects/builder/en/latest/)  

---
