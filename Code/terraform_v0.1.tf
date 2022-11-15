---
- hosts: localhost
  tasks:
# 1. Execute terraform files to create infrastructure
    - name: Execute ex.tf file, to create "Infrastructure"
      shell: "cd Terraform/; terraform apply -auto-approve"
# 2. Get Public IP address of WebServer

    - name: Get Public IP address
      shell: "cd Terraform/; terraform output publicIp"
      register: ansiblePublicIp

# 2.1 Format ansiblePublicIp as IP address output and save it in a new  variable

    - name: Format ansiblePublicIp variable
      set_fact:
        varPublicIp: "{{ansiblePublicIp.stdout | regex_search('\\d{1,3}.\\d{1,3}.\\d{1,3}.\\d{1,3}')}}"

- hosts: ec2
  become: yes
  tasks:
    - name: Infrastructure and Web Server created
      command: 'whoami'
      register: userName
