# Ansible Automation

This repository automates EC2 instance management, Jenkins deployment, and Trivy scans using Ansible.

---

## 1. Download the Repository

```bash
git clone <your-repo-url>
cd nti-graduation-project/ansible
```

---

## 2. Setup Python Virtual Environment

```bash
python3 -m venv ~/ansible-venv
source ~/ansible-venv/bin/activate
pip install --upgrade pip
pip install ansible boto3 botocore
```

---

## 3. Setup AWS Credentials

Copy your AWS credentials to `~/.aws/credentials`:

```
[default]
aws_access_key_id = YOUR_KEY
aws_secret_access_key = YOUR_SECRET
region = us-east-1
```

Or set environment variables:

```bash
export AWS_ACCESS_KEY_ID=YOUR_KEY
export AWS_SECRET_ACCESS_KEY=YOUR_SECRET
export AWS_DEFAULT_REGION=us-east-1
```

---

## 4. Setup SSH Key

Ensure your SSH private key exists and has correct permissions:

```bash
cp /path/to/jenkins-key.pem ~/.ssh/jenkins-key.pem
chmod 400 ~/.ssh/jenkins-key.pem
```

---

## 5. Ansible Configuration (`ansible.cfg`)

```ini
[defaults]
inventory = ./aws_ec2.yaml
remote_user = ec2-user
private_key_file = /home/ali/.ssh/jenkins-key.pem
host_key_checking = False
interpreter_python = /usr/bin/python3
```

---

## 6. Test Inventory

```bash
ansible-inventory -i aws_ec2.yaml --list -vvvv
ansible all -i aws_ec2.yaml -m ping
```

---

## 7. Run Playbook

```bash
ansible-playbook playbook.yaml -i aws_ec2.yaml
```

---

## Notes

* Ensure `boto3` and `botocore` are installed in the Python environment used by Ansible.
* Manual SSH test to EC2 hosts can help debug connectivity issues:

```bash
ssh -i ~/.ssh/jenkins-key.pem ec2-user@<EC2-IP>
```


