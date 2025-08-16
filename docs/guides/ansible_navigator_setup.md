# 📦 Installing and Setting up Ansible Navigator

`ansible-navigator` is an **interactive text-based user interface (TUI)** and CLI for:

- Running Ansible playbooks  
- Exploring collections  
- Managing Execution Environments (EEs)

In this guide, we’ll install and configure `ansible-navigator` inside a **Python 3.12 virtual environment** (`dev_py312`) to keep it isolated from your system Python.

---

## 1️⃣ Activate Your Python Virtual Environment

Before installing, make sure you’re inside the correct environment:

```bash
workon dev_py312
```

If `workon` is **not available**, use:

```bash
source ~/venvs/dev_py312/bin/activate
```

---

## 2️⃣ Install ansible-navigator

Install the latest version from PyPI **inside** your virtual environment:

```bash
pip install ansible-navigator
```

**To install a specific version** (e.g., for AAP compatibility):

```bash
pip install ansible-navigator==25.5.0
```

---

## 3️⃣ Verify the Installation

Run:

```bash
ansible-navigator --version
```

You should see something like:

```
ansible-navigator 25.5.0
```

---

## 4️⃣ Configure ansible-navigator

`ansible-navigator` uses a YAML configuration file:

- **Project-specific:** `./ansible-navigator.yml`  
- **Global config:** `~/.ansible-navigator.yml`

### Example starting configuration:

```yaml
---
ansible-navigator:
  mode: interactive  # or "stdout" for non-interactive mode

  ansible:
    config:
      path: ./ansible.cfg

  execution-environment:
    enabled: false    # disabled for local collection development

  logging:
    append: false
    file: ./ansible-navigator.log
    level: info

  playbook-artifact:
    enable: true
    save-as: ./.artifacts/{playbook_name}-{time_stamp}.json
```

> **Why `enabled: false` for EE?**  
> If you’re actively developing local collections (`dev-workspace`), running inside a container would hide your local changes unless mounted. Disabling EE simplifies development.

---

## 5️⃣ Example Ansible Configuration

### `ansible.cfg`
```ini
[defaults]
inventory = ./inventory
collections_path = /home/rothakur/dev-workspace/
stdout_callback = yaml
deprecation_warnings = True
retry_files_enabled = False
forks = 20
```

### `inventory`
```ini
[ios]
<ipaddress>

[ios:vars]
ansible_network_os = cisco.ios.ios
ansible_ssh_user = cisco
ansible_ssh_pass = cisco
ansible_connection = ansible.netcommon.network_cli
ansible_become = true
ansible_ssh_port = 2120
ansible_become_password = cisco
```

---

## 6️⃣ Running ansible-navigator

**Interactive Mode (TUI):**
```bash
ansible-navigator run playbook.yml -m interactive
```

**Non-interactive Mode (stdout):**
```bash
ansible-navigator run playbook.yml -m stdout
```

**Replay from saved artifacts:**
```bash
ansible-navigator replay ./.artifacts/hostname-2025-08-12T10\:31\:38.488253+00\:00.json
```

---

## 7️⃣ Using Execution Environments (EE)

If you want to run inside an EE:

### Pull the EE from Quay.io
```bash
podman login quay.io
podman pull quay.io/rothakur18/nvc_tools_v4
```

✅ **Verify**
```bash
podman images | grep nvc_tools_v4
```

---

### Example `ansible-navigator.yml` with EE Enabled
```yaml
---
ansible-navigator:
  mode: interactive

  ansible:
    config:
      path: ./ansible.cfg

  execution-environment:
    enabled: true
    image: quay.io/rothakur18/nvc_tools_v4
    container-engine: podman
    pull:
      policy: never   # use local image, don’t pull

  logging:
    append: false
    file: ./ansible-navigator.log
    level: info

  playbook-artifact:
    enable: true
    save-as: ./.artifacts/{playbook_name}-{time_stamp}.json
```

---

### Run with EE
```bash
ansible-navigator run playbooks/site.yml   --execution-environment-image quay.io/rothakur18/nvc_tools_v4
```

**Interactive EE Check:**
```bash
ansible-navigator run playbooks/hostname.yaml   --execution-environment-image quay.io/rothakur18/nvc_tools_v4   -m interactive
```

---

## 8️⃣ Useful ansible-navigator Commands

| Command | Purpose |
|---------|---------|
| `ansible-navigator collections` | List available collections |
| `ansible-navigator doc ansible.builtin.copy` | View module documentation |
| `ansible-navigator inventory -i inventory --list` | View parsed inventory |

---

✅ **At this point, you have `ansible-navigator` installed, configured, and ready to run with your local or container-based Ansible collections in `dev_py312`.**
