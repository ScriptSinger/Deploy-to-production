#!/bin/bash

# Define the server and repository information
SERVER="user@example.com"
PROJECT_DIRECTORY="example.com"
REPOSITORY="https://github.com/user/project.git"
TOKEN=1234567890:ABCDEFGHIJKLMNOPQRSTUVWXYZ
API_KEY=sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# Connect to the server via SSH
ssh $SERVER << EOF
    # Navigate to the web PROJECT_DIR directory
    cd $PROJECT_DIR

    # Check if the repository is already cloned
    if [ ! -d .git ]; then
        # Clone the repository if it doesn't exist
        git clone $REPOSITORY .

        # Create .env.local and append token
        echo "export TELEGRAM_BOT_TOKEN=$TOKEN" >> .env.local
        echo "export API_KEY=$API_KEY" >> .env.local
       
        # Create symbolic link
        ln -s public public_html

    else
        # merge (the default strategy)
        git config pull.rebase false  # merge (the default strategy)
        
        # Update the local git repository
        git pull origin main
    fi

    # Install dependencies
    php8.2 ~/.composer.local/bin/composer install --no-dev --optimize-autoloader

    # Clear the cache
    php8.2 bin/console cache:clear --env=prod
    # Exit the server
    exit
EOF