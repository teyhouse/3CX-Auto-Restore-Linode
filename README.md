# 💡  Auto-Restore 3CX-Backup using Terraform/Ansible in Linode
This is an example of how to restore a fully auto-deployed 3CX Instance on Linode using Terraform and Ansible. The method used in this example is not officially supported by 3CX, which would require the use of the official ISO combined with setupconfig.xml.  
  
Due to 3CX's decision to no longer provide standalone Linux packages and prohibit customized instances, restoring 3CX Instances has become unnecessarily difficult. This issue is solved by this solution.
  
# 📃 Requirements
- Terraform
- Ansible
- Linode API Token
- (RSync-)Backup from /var/lib/postgresql/11/ and /var/lib/3cxpbx/ on your NFS-Mount (check Ansible-Playbook restore.yaml to see which services must be stopped first)
  
# 🚫 Limitations
This example is meant as a showcase, so certain aspects have been purposely simplified.
  
# 🛠 How to run 
Init Terraform:  
```terraform init```
  
Run:  
```terraform apply```
