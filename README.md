# cmk

## requirements

1. Ruby must be installed and the ruby gem ansible_module Version >= 0.9.4 (Tsutomu Kuroda).

```
$ sudo gem install ansible_module
```

2. clone this repository

```
cd /<pathToGitClone>
git clone https://github.com/ogaida/cmk
```

3. link to the modules

`/etc/ansible/ansible.cfg`

```
[defaults]
library = /<pathToGitClone>/cmk/modules
```
