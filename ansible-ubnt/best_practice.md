## Create the base.yml with the roles defined --> base.yml

---

- hosts: all
  become: true
  roles:
    - base 

- hosts: workstations
  become: true
  roles:
    - workstations

- hosts: web_servers
  become: true
  roles:
    - web_servers


## Create the roles dir structure matching the roles

./roles/base/tasks/main.yml
./roles/workstations/tasks/main.yml
./roles/web_servers/tasks/main.yml


## Define the tasks specific to the hosts -->> main.yml

# ./roles/base/tasks/main.yml

- name: index update
  tags: index
  apt:
    update_cache: true
  when: ansible_distribution == "Ubuntu"


# ./roles/workstations/tasks/main.yml

- name: Install Unzip
  ansible.builtin.package:
    name: unzip
    state: latest

- name: Install terraform
  ansible.builtin.unarchive:
    src: https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_386.zip
    dest: /usr/local/bin
    remote_src: yes
    mode: 0755
    owner: root
    group: root

# ./roles/web_servers/tasks/main.yml

- name: install nginx (Web servers)
  tags: nginx
  apt:
    name: nginx
    state: latest
    update_cache: true
  when: ansible_distribution == "Ubuntu"


## Run the main base.yml playbook to effect all changes

# $ ansible-playbook -K base.yml [Enter]
