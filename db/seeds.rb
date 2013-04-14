 # This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(username: "mvleming", password: "password")
Article.create(title: "Home", text: "Blah Blah Blah Blah Tommy is so tired")
Article.create(title: "Crowdfunder", text: "
	#Week 6: Rails III (Advanced Topics)

* TDD using Guard and focus on Integration tests
* Bootstrap + SASS (from the beginning) 
* Pagination (Kaminari / Kaminari - Bootstrap)
* Mailing (ActionMailer/Letter Opener)
* Search (WebSolr LIKE-based)
* Authentication (Sorcery) 
* File Upload (CarrierWave)
* Accepts Nesteded Atttributes + Nested Form + Nested Validation
* CounterCache

#App: CrowdFunder (a Kickstarter clone)

The app will allow users to pledge against existing projects or create their own project. Visitors will be able to search for projects. Project owners will be able to upload images to their project.

Students will be able to use a variety of gems, create applications that can send and receive email, as well as have an understanding of a search function. 

##Models
* `Project` (title, teaser, description, user)
* `Reward` (project, amount, description)
* `User` (first, last, email, password, etc)
* `Pledge` (user, project, amount, reward)
* `Image` (project)

##Prerequisites

* `pg` requires:
  * [Postgres.app](http://postgresapp.com/) on mac
  * [Postgres Ubuntu](https://help.ubuntu.com/community/PostgreSQL) on Ubuntu
* `capybara-webkit` requires:
  * Qt 4.8.4 installed (download mpkg installer from their site directly, no need for brew)
  * Check to make sure you can run qmake from command line

##Workflow / Commits

0. Setup app with test/unit, factory girl, capybara, guard and pg

    Commits
    * [`4b9c24be3d` - Initial Commit](https://github.com/bitmakerlabs/crowdfunder/commit/4b9c24be3d88bbe3b8a73205eda6d693608fc4ee)
    * [`d64a32c02d` - Initial dev & test environment setup](https://github.com/bitmakerlabs/crowdfunder/commit/d64a32c02dd1054273ad9b2e1a140430f6a1daa0)
    * [`5bd701aa91` - Disable fixtures for Test::Unit](https://github.com/bitmakerlabs/crowdfunder/commit/5bd701aa9185414ff5e46f23797950806cdad8c3)

    **`Gemfile`**

        gem 'pg'
        
        group :tools do
        	gem 'rb-fsevent', :require => false # mac
            gem 'rb-inotify', :require => false # linux
            gem 'rb-fchange', :require => false # windows
        	gem 'guard-test'
        	gem 'guard-livereload'
        end
        
        group :test do 
        	gem 'factory_girl_rails'
        	gem 'database_cleaner'
        	gem 'capybara'
        	gem 'capybara-webkit'
        end
        
    Run `bundle install` to get all the gems above

    Setup `database.yml` with correct database info:
    
    **`database.yml`**
    
        development:
          adapter: postgresql
          database: crowdfunder_dev
          host: localhost

        # Warning: The database defined as 'test' will be erased and
        # re-generated from your development database when you run 'rake'.
        # Do not set this db to the same as development or production.
        test:
          adapter: postgresql
          database: crowdfunder_test
          host: localhost

    Run `bundle exec guard init` then `bundle exec guard` in main terminal tab

    Run `rake db:create` to create the dev and test databases

    Change app to use `FactoryGirl` instead of fixtures

    **`config/application.rb`**

        config.generators do |g|
            g.test_framework  :test_unit, :fixture => false
        end
    Remove `fixtures :all` from `test/test_helper.rb`

1. Install sorcery: [`6226b0a762` - Add user model](https://github.com/bitmakerlabs/crowdfunder/commit/6226b0a76279e2577f8e5eee9f503245373e8854)

        gem 'sorcery'

    Run:

    `rails generate sorcery:install`
    
    Modify migration to remove username and set email to null false
    Also add `first_name` and `last_name`
    
        t.string :first_name
        t.string :last_name
        t.string :email, :default => nil, :null => false

    Don't forget to migrate `rake db:migrate`
    
    **[ COMMIT ]**

2. Generate project model: [`7e5d1be755` - Generate project model, Seed some data](https://github.com/bitmakerlabs/crowdfunder/commit/7e5d1be7558b3fa1f2ab40583cb7f57c241b01a1)

        rails generate model project title teaser user:references description:text goal:integer

    open migration to show the references statement and `t.references user` == `t.integer user_id`  (how they both create integer column)
    
    Make sure to update `user.rb` with `has_many :projects`
    
    Don't forget to migrate `rake db:migrate`

    **[ COMMIT ]**

3. Seed a user and some projects:

    **`seeds.rb`**
    
        User.destroy_all
        Project.destroy_all

        user = User.create!(first_name: 'John', last_name: 'Doe', email: 'john@doe.com', password: 'jdoe111')

        50.times do |i|
        	project1 = user.projects.create!(title: 'Project \#{i}', teaser: 'Teaser text \#{i}',
        		description: 'description \#{i}', goal: 13000)
        end

    show `db:seed` and `db:reset` in list of rake tasks using `rake -T`

        rake -T | grep db
    
    why destroy first? B/C seeds does not clear
    
    **[ COMMIT ]**

4. Project list page (with link_to project show page) (TDD: integration test) [`c6ad4655a7` - Listing projects - our first controller and action](https://github.com/bitmakerlabs/crowdfunder/commit/c6ad4655a79a09b8f89764ec37336cdc6228a943)
    `rails generate` (list of generators in app)
    
    generate factory

        rails g factory_girl:model User
        rails g factory_girl:model Project
        
    
    **`test/factories/users.rb`**
    
        FactoryGirl.define do
          factory :user do
          	first_name 'Karl'
          	last_name 'Denninger'
          	sequence(:email) {|n| 'karl\#{n}@example.com' }
          	password 'karl.is.king'
          end
        end
        
    **`test/factories/projects.rb`**
    
        FactoryGirl.define do
          factory :project do
          	user
          	title 'Wifi-enabled lamps!'
          	teaser 'How have we been able to survive without these?'
          	description 'Lorem ipsum... '
          	goal 12000
          end
        end
        
    Make sure you delete the old fixtures in `test/fixtures`
    
    Generate first integration test: 
    
        rails generate integration_test project_flows


    Add this to `/test/test_helper.rb`, this allows us to use `capybara` with `Test::Unit`

        class ActionDispatch::IntegrationTest
            # Make the Capybara DSL available in all integration tests
            include Capybara::DSL
        end

    Add code to visit `/projects` and assert content

        visit '/projects'
        assert page.has_content?('Listing projects')
    
    Witness error from guard

        ActionController::RoutingError: No route matches [GET] '/projects'

    After defining `resources :projects` in routes, witness next error:
    
        ActionController::RoutingError: uninitialized constant ProjectsController

    Generate projects controller, index action and:
    * Controller: 
        
        `@projects = Project.all`
    * Templates: 
        
        `index.html.erb`: template listing all projects in UL; and expected h1 title

    **[ COMMIT ]**

5. Our first browser experience (`rails s`, `open`) [`d7b7f996ac` - Pretty up the layout](https://github.com/bitmakerlabs/crowdfunder/commit/d7b7f996ace17630bccc93b0ebca5dffff6e0278)
    * [Project Page](http://d.pr/i/pDyk/2WnNtfyQ)
    * Pretty it up by adding bootstrap sass gem to the project

    **`Gemfile`**
        
            group :assets do
                gem 'sass-rails',   '~> 3.2.3'
                gem 'bootstrap-sass', '~> 2.2.2.0'
                gem 'uglifier', '>= 1.0.3'
            end
    * Add _nav partial with Home and Projects links

    **`/app/views/layouts/shared/_nav.html.erb`**

            <div class='navbar navbar-fixed-top'>
              <div class='navbar-inner'>
                <div class='container'>
                  <a class='brand' href='#'>CrowdFunder</a>
                  <div class='nav-collapse collapse'>
                    <ul class='nav'>
                      <li class='<%= 'active' if current_page? root_path %>'>
                        <%= link_to 'Home', :root %>
                      </li>
                      <li class='<%= 'active' if current_page? projects_path %>'>
                        <%= link_to 'Projects', :projects %>
                      </li>
                    </ul>
                  </div><!--/.nav-collapse -->
                </div>
              </div>
            </div>
    * Write 'navigation' test case in ProjectFlowsTest file

    **`/test/integration/project_flows_test.rb`**

            test 'navigation' do
                visit '/'
                assert_equal root_path, current_path
                # The home nav element should be active
                assert_equal 'Home', find('.navbar ul li.active a').text
            
                find('.navbar ul').click_link('Projects') # more specific: 
                assert_equal projects_path, current_path
            
                # The projects nav element should be active
                assert_equal 'Projects', find('.navbar ul li.active a').text
            end
    * By the end, you get: [Project Page -- Bootstraped](http://d.pr/i/skWY/3XmztOwf)

    **[ COMMIT ]**
    
6. Project show page: [`f167b8c644` - Project details page - setup](https://github.com/bitmakerlabs/crowdfunder/commit/f167b8c6446f8863526e7640b73bdd1d08f4b760)
    * Student driven
    * Show page must at min have project title and user name for now
    
    **[ COMMIT ]**

7. Fix bug on navigation (the project header does not highlight when you're on the `show` page for project) [`b5b77f53a7` - Fix Bug #1](https://github.com/bitmakerlabs/crowdfunder/commit/b5b77f53a707aacc874ee4c751e3be877ea594d7)
    * Student driven
    * Emphasis on writing the test case first
    
    **[ COMMIT ]**

8. Sorcery - user registration [`6e0bcc979f` - User signup](https://github.com/bitmakerlabs/crowdfunder/commit/6e0bcc979fe6c23812fc14dd28f6290e205bd0a3)
    * Define Test for user registration and failed registration
    * Update nav with Sign Up and Logout buttons based on state
    * DONT handle form errors (intentional bug)
    * Presence validations on User password/name fields
    
    **[ COMMIT ]**

9. Fix bug with registration error upon failed registration [`6cc4f088ae` - Fix Bug #2](https://github.com/bitmakerlabs/crowdfunder/commit/6cc4f088ae4149b14abfc069fd0f7b8e1a9f5563)
    * Look for text upon failure
    * Add `form.objects.errors.full_messages` as alert to `new.html`
    
    **[ COMMIT ]**

10. Login and logout [`742fa33e34` - Login and Logout functionality](https://github.com/bitmakerlabs/crowdfunder/commit/742fa33e34f558e95f36a6233a992468fc82c411)
    * Implement Login first
    * Eventually get error in GUARD (test case) that username column doesn't exist
    * Update sorcery to use email for auth instead of username
    * Write logout test
    * Update logout button in _nav from # to destroy sessions action
    * Notice error:
    
            No route matches [GET] '/session'
    * Explain that the default capybara driver does not use JS. Use `capybara_webkit` for `:webkit javascript_driver`
    * Explain headless browser
    * Couple of changes to `Gemfile` and `test_helper.rb` (including addition of `database_cleaner.rb`)
    * Use the `javascript_driver` for just that one (logout) test not all of them
    * Explain that we could just make it the default but it would be slower to run
    * Expect alert on failed login attempt but don't get any
    * Update `application.html.erb` to include `flash[:alert]`

    **[ COMMIT ]**

11. Ability to pledge for a project [`2e8e71f48c` - Create pledge model](https://github.com/bitmakerlabs/crowdfunder/commit/2e8e71f48c6652afa7415507ad5aa12b1f1b89bd)
    * Generate pledge model:
    
        rails g model pledge user:references project:references amount:integer
    
    **[ COMMIT ]**
  
12. Pledge creation flow [`2aac32c453` - Pledge creation workflow](https://github.com/bitmakerlabs/crowdfunder/commit/2aac32c45307483197ab34bd487d0ef83d846b02)
    * Generate integration test expecting 'Back This Project' button that:
        * When clicked will be redirect to `new_user_path` for unauthenticated user 
    * Add button to projects#show labeled 'Back This Project'
      
      Encounter issue:  

            <'/users/new'> expected but was <'/projects/1/pledges/new'>.

    Define sorcery `before_filter` in pledges_controller:

    **[ COMMIT ]**
    
13. My/Projects [`5f0459e096` - My projects (CRUD)](https://github.com/bitmakerlabs/crowdfunder/commit/5f0459e096b9ee46352c1a4fefe6dc07ee508e50)
    * TDD built CRUD for my projects (no scaffolding)
    
            rails g controller my/projects index new edit
    * generate my/project_flows for TDD
    * update routes to remove auto-gen entries and add `:projects` under namespace `:my`
    * clean out functional(controller) test stubs
      
    Note: for testing 404 page (when testing access restrictions), 
    * Will see guard raise ActiveRecord::NotFoundException instead of display 404.html
    * change following settings in test.rb
    
            consider_all_tests_local
            show_exceptions

    **[ COMMIT ]**

14. Fix Nav issue (see comment for notes) [`887f3aa075` - Bug Fix - Nav states](https://github.com/bitmakerlabs/crowdfunder/commit/887f3aa075e5e249d75835b0b4e90423504fdbaf)

    Both my/projects and projects controllers have controller_name == 'projects'

    Instead of using `controller_name`, we now use a `before_filter` to set an instance variable `@nav`. This is more flexible but not the only way to solve this problem.

    **[ COMMIT ]**

15. Email project owner when their project is backed [`57e628c51a` - Email project owner when pledge made](https://github.com/bitmakerlabs/crowdfunder/commit/57e628c51a7b062303f5699e597ae8062a64b504)
    * Generate mailer
    
            rails g mailer user_mailer
    * Explain `ActionMailer::Base.deliveries` for testing
    * Define `last_mail` and `reset_mail` in `test_helper`, for integration tests
    * Update pledge flows test case to expect `last_email`

    **[ COMMIT ]**

16. Pagination [`4f1b23573c` - Pagination on projects index page](https://github.com/bitmakerlabs/crowdfunder/commit/4f1b23573ce56801ac3c4c95eca70fa2c0357fdc)
    * Install and generate config (8 per page) for kaminari 
    * Update seeds file to create 50 projects (50.times)
    * Update integration test to expect only X items
    * Lastly, add the `kaminari-bootstrap` gem so it looks better

    **[ COMMIT ]**

17. Image uploads through Carrierwave [`81a59bf119` - Implement image upload for my projects](https://github.com/bitmakerlabs/crowdfunder/commit/81a59bf11980d041ff38770ef934a33b50b8b3ad)
    * Install `carrierwave` into `Gemfile`
    
            rails g model image project:references file
    * add model validations and associations
    
            rails g uploader Image
            rails g controller my/images
    * nested resource in routes
    * Generate `my/image_flows` test case with 2 tests (success / fail)
    * Before committing, update `.gitignore` to include `/public/uploads/*`

    **[ COMMIT ]**

18. Ability to delete projects [`3e45bd33f2` - Ability to delete my project](https://github.com/bitmakerlabs/crowdfunder/commit/3e45bd33f2ed10f660f6f1429472a710153ae390)
    * Delete `link_to` will have a `:confirm`
    * Talk about Rails UJS (unless covered before)
    * How will `capybara` be able to handle confirm?
    * See `capybara-webkit` README on github search for confirm and find driver-specific API

    **[ COMMIT ]**

19. Ability to search for projects
    * Using LIKE base search

20. Some sort of AJAX functionality
    * Discussion / Commenting on projects (new model)
    * Deletion of images from index page
    * Pledge creation (which can fail - ajax submission and feedback)

21. Visual polish
  * Add images to `/projects`
  * Cleanup `projects#index` and `projects#show`
  * Bootstrap slideshow or lightbox/colorbox for images? jquery plugin

##Stuff not covered (To discuss):
  * S3 storage w/ Fog
  * Deployment
  * Multiple asset manifest files (better understanding of the asset pipeline)
  * SimpleForm or Formtastic for better output
  * Quiet assets (minor)
  * Feature / hotfix branches (good git workflows)
Blah Blah Blah Blah Tommy is so tired
	")