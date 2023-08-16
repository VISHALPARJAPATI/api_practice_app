# ==================================== bundle install ============================================================================

`bundle install` is a command in Ruby applications, including Ruby on Rails projects, that is used to install the required gems (Ruby libraries) specified in the `Gemfile` of your project. The `Gemfile` is a configuration file that lists all the gems your application depends on, along with their versions.

Here's how `bundle install` works and what it does:

1. **Gemfile Specification**: In your project's root directory, you'll have a file named `Gemfile`. This file contains a list of gem dependencies and their versions required by your project. For example:

    ```ruby
    source 'https://rubygems.org'

    gem 'rails', '6.1.4'
    gem 'sqlite3', '~> 1.4'
    gem 'bcrypt', '~> 3.1.7'


2. **Running `bundle install`**: When you run the `bundle install` command in your terminal, Bundler (a dependency management tool for Ruby) reads the `Gemfile` and analyzes the gem dependencies listed in it.

3. **Dependency Resolution**: Bundler looks at the dependencies declared in the `Gemfile`, along with their version constraints, and attempts to find a compatible set of gem versions that satisfy all the requirements. This process is called "dependency resolution."

4. **Gem Installation**: Once Bundler determines the correct set of gem versions, it installs those gems along with their dependencies. It fetches the gem files from the specified sources (usually RubyGems.org) and installs them locally in your project's `vendor` or `bundle` directory.

5. **Gemfile.lock**: After successfully installing the gems, Bundler generates a `Gemfile.lock` file in your project's root directory. This file specifies the exact versions of all gems that were installed, including the versions of their dependencies. This is important because it ensures that every developer working on the project uses the same versions of the gems.

6. **Subsequent Runs**: When you run `bundle install` again later, Bundler checks the `Gemfile.lock` first to determine the exact gem versions to install. This avoids unnecessary dependency resolution and ensures consistent gem versions across different environments.

In summary, `bundle install` reads your `Gemfile`, resolves gem dependencies, installs the required gems and their dependencies, and generates a `Gemfile.lock` to track the exact versions. This helps in maintaining consistent and reproducible environments across different machines and deployment stages.

# ================== where these GEMs stored after bundle install ======================================================

When you run `bundle install` in a Ruby project, the gems are installed locally on your machine within the context of that specific project. This means that the installed gems are scoped to the project and don't affect other Ruby projects or the system-wide Ruby installation on your machine. Here's how the installation scope works:

1. **Project Scope**: The gems are installed in a directory within your project's directory structure. By default, Bundler installs gems in a directory named `vendor/bundle` within your project. This ensures that the gems are isolated to the specific project and don't interfere with other projects or the system Ruby installation.

2. **Isolation**: Each project can have its own set of gems and gem versions. This isolation is crucial because different projects might have different gem dependencies and version requirements. Installing gems locally to the project avoids conflicts between projects that need different versions of the same gem.

3. **Gemfile.lock**: The `Gemfile.lock` file, generated and updated by Bundler, specifies the exact versions of gems and their dependencies that were installed for the project. This ensures that all developers working on the project and any deployment environments use the same gem versions, providing consistency.

4. **Development and Deployment**: When you develop or run your application, the Ruby interpreter loads the gems from the local project's gem directory (e.g., `vendor/bundle`). When you deploy your application, you typically include the `Gemfile.lock` file to ensure the correct gem versions are installed in the production environment.

5. **No System-Wide Impact**: Installing gems through Bundler doesn't affect the system-wide Ruby installation or other projects on your machine. Each project maintains its own gem environment, and the gems you install for one project won't interfere with others.

In summary, gems installed using `bundle install` are scoped to the specific project you're working on. They are installed within the project's directory structure, ensuring isolation and consistency across different development and deployment environments without impacting other projects or the system Ruby installation.

# ========== bundle update  ============================================================

If you ever need to update your gems to newer versions, you can run bundle update. This command re-resolves the gem dependencies based on the Gemfile's version constraints and updates the Gemfile.lock with the newly resolved versions.