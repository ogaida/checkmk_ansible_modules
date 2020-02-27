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
