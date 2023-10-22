# Deepracer Terraform

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

