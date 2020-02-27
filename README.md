# checkmk_ansible_modules

## requirements

1. clone this repository

```
git clone https://github.com/ogaida/checkmk_ansible_modules
```

2. Ruby must be installed and the ruby gem ansible_module Version >= 0.9.4 (Tsutomu Kuroda).

```
$ sudo gem install ansible_module httparty
```

if not released yet, you could use the `ansible_module-0.9.4.gem` from this repository:

```
$ sudo gem install ./checkmk_ansible_modules/ansible_module-0.9.4.gem httparty
```

3. link to the modules

`/etc/ansible/ansible.cfg`

```
[defaults]
library = /<pathToGitClone_of_checkmk_ansible_modules>/modules
```

## Playbook

```yaml
---
# ansible-playbook cmk_change_cmkadmin.yml -e "user=$cmk_user password=$cmk_pass url=$cmk_url"
- hosts: localhost
  gather_facts: no
  tasks:
  - name: User anlegen
    cmk_user:
      user: "{{ user }}"
      password: "{{ password }}"
      url: "{{ url }}"
      state: present
      set_password_if_exist: yes
      data:
        users:
          cmkadmin:
            alias: "Check_MK Automation - used for calling web services"
            password: "Vati mag ansible"
    register: out
  - name: debug
    debug:
      var: out
  - name: Changes aktivieren
    cmk_changes:
      user: "{{ user }}"
      password: "{{ password }}"
      url: "{{ url }}"
      allow_foreign_changes: yes
    register: out
  - name: debug
    debug:
      var: out
```

Output:

```
ansible-playbook cmk_change_cmkadmin.yml -e "user=$cmk_user password=$cmk_pass url=$cmk_url"

PLAY [localhost] *******************************************************************************************************
TASK [User bearbeiten] *************************************************************************************************
changed: [localhost]

TASK [debug] ***********************************************************************************************************
ok: [localhost] => {
    "out": {
        "changed": true,
        "failed": false
    }
}

TASK [Changes aktivieren] **********************************************************************************************
ok: [localhost]

TASK [debug] ***********************************************************************************************************
ok: [localhost] => {
    "out": {
        "changed": false,
        "failed": false,
        "msg": {
            "result": {
                "sites": {
                    "cmk": {
                        "_expected_duration": 5.345510831237794,
                        "_phase": "done",
                        "_pid": 18359,
                        "_site_id": "cmk",
                        "_state": "success",
                        "_status_details": "Started at: 21:57:05. Finished at: 21:57:11.",
                        "_status_text": "Success",
                        "_time_ended": 1582837031.205873,
                        "_time_started": 1582837025.875972,
                        "_time_updated": 1582837031.205873,
                        "_warnings": []
                    }
                }
            },
            "result_code": 0
        }
    }
}

PLAY RECAP *************************************************************************************************************
localhost                  : ok=4    changed=1    unreachable=0    failed=0
```
