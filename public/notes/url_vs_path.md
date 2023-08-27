In Ruby on Rails, both `reset_password_users_url` and `reset_password_users_path` are used to generate URLs for a specific route, but they differ in the type of URL they generate.

1. **`reset_password_users_url`:**
   This helper generates an absolute URL (including the protocol, domain, and port) for the specified route. It's useful when generating URLs that need to include the full address, such as links in emails. For example:

   ```ruby
   reset_password_users_url(token: @token, email: @user.email)
   # Output: http://your-domain.com/reset_password?token=abc123&email=user@example.com
   ```

   The `reset_password_users_url` helper generates an absolute URL, including the host (domain) based on the `default_url_options` or the environment configuration.

2. **`reset_password_users_path`:**
   This helper generates a relative URL for the specified route. It only includes the path without the protocol, domain, or port. It's useful when generating URLs within your application, such as links between different views. For example:

   ```ruby
   reset_password_users_path(token: @token, email: @user.email)
   # Output: /reset_password?token=abc123&email=user@example.com
   ```

   The `reset_password_users_path` helper generates a URL relative to the application root.

The choice between `*_url` and `*_path` depends on the context in which you're using the URLs:

- If you're generating URLs for use outside of your application (e.g., in emails), you should use `*_url` to ensure that the URLs are complete and valid.

- If you're generating URLs within your application (e.g., for links between views), you can use `*_path` to keep the generated URLs relative and concise.

In the case of a "Forgot Password" feature, when sending password reset emails, you would typically use `*_url` to generate absolute URLs that users can click on to reset their passwords. When generating links within your application's views or controllers, you might use `*_path` to keep the URLs relative.