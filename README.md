# Deepracer Terraform


## Create the secrets key

1. Create a copy of the template secrets file

2. Generate a PGP key pair using a tool like GPG:
'''bash
gpg --gen-key
'''
Follow the prompts to create the key pair.

3. Export and Base64 Encode the Public Key:
'''bash
gpg --export --armor your-email@example.com | base64
'''

Replace your-email@example.com with the email address you used when generating the key pair. This command will print a base64-encoded string to the console.

## Deploy

1. Run ```terraform plan```
2. Give in the exported base 64 public key
3. Check the result of the plan
4. Run ```terraform apply```
5. Give in the exported base 64 public key
6. Approve with yes