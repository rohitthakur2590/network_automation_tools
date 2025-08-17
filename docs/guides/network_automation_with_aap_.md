# AAP — Content Demo (via the **GUI**)

This walkthrough shows how to demo **Red Hat Ansible Content** using only the **AAP web UI** (Automation Controller + optional Automation Hub).  
You will:
1) add credentials (registry + galaxy/automation hub),  
2) register a  **Execution Environment** (EE),  
3) create a **Project** that includes job templates,  
4) make an **Inventory** + **Credentials**,  
5) run a **Job Template** that pulls Validated Content and executes a playbook.

---

## 0) Prereqs
- AAP up and reachable (Controller; Hub optional).
- Execution environment created and available via registry.
- Your credentials for `registry.redhat.io/any`.
- An **Github Personal Access token** .
- At least one target network host you can reach via SSH.

> **Safe demo:** use a r playbook (or run with **Check Mode**).

---

## 1) Add required **Credentials** (GUI)

### 1.1 Registry (for pulling the EE image)
- **Controller UI** → **Resources** → **Credentials** → **Add**
  - **Name:** `validated_nat_registry_cred`
  - **Organization:** `(your org)/default`
  - **Credential Type:** `Container Registry`
  - **Registry URL:** `quay.io`
  - **Username:** `<your username>`
  - **Password:** `<your password>`
  - **Save**

### 1.2 Credential Types (for usign gh_token variable in scm tasks)
- **Controller UI**→ **Administration** → **Credential Types** → **Add**
  - **Name:** `validated_nat_gh_token_cred_types`
  - **Description:** ``
  - **Input configuration:**
  ```yaml
  fields:
    - id: token_ghp
      type: string
      label: Token
      secret: true
      help_text: >-
        This token needs to come from your profile settings in GitHub. Starts with
        "ghp_"
  required:
    - token_ghp
  ```

    - **Injector configuration:**
  ```yaml
    env:
      gh_token: '{{ token_ghp }}'
  ```
  - **Save**

  ### 1.3 Credential (to inject value to gh_token var)
- **Controller UI** → **Resources** → **Credentials** → **Add**
  - **Name:** `validated_nat_gh_token_cred`
  - **Description:** ``
  - **Organization:** ``
  - **Credential Type:** `validated_nat_gh_token_cred_types`
  - **Type Details→Token :** `<your gh pat>`
  - **Save**

  ### 1.4 Credential (Network appliance access creds)
- **Controller UI** → **Resources** → **Credentials** → **Add**
  - **Name:** `validated_nat_lab_cred`
  - **Description:** ``
  - **Organization:** ``
  - **Credential Type:** `Machine`
  - **Type Details→username :** `cisco`
  - **Type Details→password :** `cisco`
  - **Type Details→Privilege Escalation Method :** `enable`
  - **Type Details→Privilege Escalation Password :** `cisco`
  - **Save**
---

## 2) Register a **EE** (GUI)

- **Controller UI** → **Administration** → **Execution Environments** → **Add**
  - **Name:** `validated_nat_ee`
  - **Image:** `quay.io/rothakur18/network-ee-demo-rr`
  - **Pull:** `Always`
  - **Description:** `EE for Out-of-box network automation solutions`
  - **Organization:** `default`
  - **Registry Credential:** `Registry (quay.io)`
  - **Save**

---

## 3) Create a **Project** (GUI)
In sidebar Go to Resources->Projects and click on add

**Add**
  - **Name:** `Validated Network Automation Tools`
  - **Description:** `Out-of-box network automation solutions`
  - **Execution Enviornment:** `validated_nat_ee`
  - **Organization:** `default`
  - **Source Control Type** `git`
  - **Source Control URL:** `<your playbooks git url>`
  - **Source Control Credential:** `git`
  - **Save**

You need a Git repo with:

## 4) Create a **Inventory** (GUI)
- **Controller UI** → **Resources** → **Inventories** → **Add** → **Add Inventory**
  - **Name:** `validated_nat_inventory`
  - **Description:** `Inventory for network automation labs`
  - **Organization:** `default`
  - **Save**

Once you save the inventory , you can create group and hosts.
**Inventories** → **validated_nat_inventory** → **Groups** → **Add**
  - **Name:** `network`
  - **Description:** `grouping network hosts under group "network"`
  - **Variables:**
  ```yaml

  ansible_connection: ansible.netcommon.network_cli
  ```
  - **Save**
  
  Now to add hosts click on "Hosts" under Group details

  **Inventories** → **validated_nat_inventory** → **Groups** → **network** → **Hosts** → **Add**
  - **Name:** `network`
  - **Description:** `grouping network hosts under group "network"`
  - **Variables:**
  ```yaml
  ansible_ssh_port: 2119
  ansible_host: 54.190.208.146
  ansible_become: true
  ansible_network_os: cisco.nxos.nxos
  ```
  - **Save**


## 6) Create a **Job Template** (GUI)
- **Controller UI** → **Resources** → **Templates** → **Add** → **Add Job Template**
  - **Name:** `Generate Network Reports`
  - **Description:** `Generate network reports`
  - **Job Type:** `Run`
  - **Inventory:** `validated_nat_inventory`
  - **Project:** `Validated Network Automation Tools`
  - **Execution Environment:** `validated_nat_ee`
  - **Credentials:** `validated_nat_lab_cred`, `validated_nat_gh_token_cred`
  - **Playbook:** `playbooks/reports/generate_reports.yaml`
  - **Save**

Once you save the job template, you can click on launch button or press rocket icon to run this.

Blogs:
 - [Create Executoin Environment](./ansible_builder_guide.md)
 - [Ansible Navigator Setup](./ansible_navigator_setup.md)
 - [Ansible Dev Env Setup Guide](./ansible_env_setup_guide.md)

