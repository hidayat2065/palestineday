pipeline {
    agent any

    environment {
        APP_DIR = '/var/www/sekolah-staging2'
    }

    stages {

        stage('Verify Source') {
            steps {
                echo '=== VERIFY SOURCE ==='
                sh '''
                    set -e

                    test -f composer.json
                    test -f artisan
                    test -d public

                    echo "Laravel source OK"
                '''
            }
        }

        stage('Verify Environment') {
            steps {
                echo '=== VERIFY SERVER ==='
                sh '''
                    set -e

                    php8.3 -v
                    /usr/bin/composer --version

                    test -d ${APP_DIR}
                    test -f ${APP_DIR}/.env

                    echo "Server environment OK"
                '''
            }
        }

        stage('Deploy Files') {
            steps {
                echo '=== DEPLOY FILES ==='

                sh '''
                    set -e

                    rsync -rv --delete \
                        --no-perms \
                        --no-owner \
                        --no-group \
                        --omit-dir-times \
                        --exclude='.git/' \
                        --exclude='.env' \
                        --exclude='storage/' \
                        --exclude='vendor/' \
                        --exclude='Jenkinsfile' \
                        ./ ${APP_DIR}/
                '''
            }
        }

        stage('Composer Install') {
            steps {
                echo '=== COMPOSER INSTALL ==='

                sh '''
                    set -e

                    cd ${APP_DIR}

                    php8.3 /usr/bin/composer install \
                        --no-dev \
                        --optimize-autoloader \
                        --no-interaction \
                        --prefer-dist
                '''
            }
        }

        stage('Laravel Cache') {
            steps {
                echo '=== LARAVEL CACHE ==='

                sh '''
                    set -e

                    cd ${APP_DIR}

                    php8.3 artisan config:clear
                    php8.3 artisan cache:clear
                    php8.3 artisan view:clear
                '''
            }
        }

        stage('Health Check') {
            steps {
                echo '=== HEALTH CHECK ==='

                sh '''
                    set -e

                    HTTP_CODE=$(curl \
                        --silent \
                        --output /dev/null \
                        --write-out "%{http_code}" \
                        -H "Host: staging2.sekolah.local" \
                        http://127.0.0.1/)

                    echo "HTTP Status: ${HTTP_CODE}"

                    if [ "${HTTP_CODE}" -lt 200 ] || [ "${HTTP_CODE}" -ge 400 ]; then
                        echo "Health check FAILED"
                        exit 1
                    fi

                    echo "Health check SUCCESS"
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Palestine Day staging2 deployment SUCCESS'
        }

        failure {
            echo '❌ Palestine Day staging2 deployment FAILED'
        }
    }
}