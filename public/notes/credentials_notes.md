# =========== Working with Rails Credentials (credentials.yml.enc) =======================================================

Rails provides a secure way to store sensitive information using the credentials file. This guide explains how to manage and access these credentials.

## =========== Editing the Credentials File =============================================================================

1. Open the credentials file for editing using your preferred code editor. The following command opens the file using Visual Studio Code, assuming you have it installed:

## bash
`EDITOR="code --wait" bin/rails credentials:edit`

Replace `"code --wait"` with the appropriate command for your code editor if it's different.

## =========== Storing and Retrieving Data =============================================================================

Assuming you have a `database_password` key stored under the `development` environment in your credentials:

```yaml
development:
  database_password: your_super_secret_password
```

You can retrieve this value using the following code:

## erb
`<%= Rails.application.credentials.dig(Rails.env.to_sym, :database_password) %>`

Replace `:database_password` with the specific key you're trying to access.

Remember that the credentials file is encrypted, ensuring that your sensitive data remains secure. Do not commit this file to version control to maintain security.

---

Feel free to integrate these improvements into your `credential_file_notes.md` document. This version provides clearer instructions and explanations for working with Rails credentials.