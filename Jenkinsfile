pipeline {
    agent any

    parameters {
        booleanParam(
            name: 'RUN_DB_BOOTSTRAP_TEST',
            defaultValue: false,
            description: 'Test automatic bootstrap on palestineday_bootstrap_test'
        )
    }

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
                    test -f database/staging/staging.sql

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

        stage('Database Bootstrap') {
            steps {
                echo '=== DATABASE BOOTSTRAP ==='

                sh '''
                    set -e
                    set +x

                    ENV_FILE="${APP_DIR}/.env"
                    SQL_FILE="${WORKSPACE}/database/staging/staging.sql"

                    get_env() {
                        grep -E "^$1=" "$ENV_FILE" \
                            | tail -1 \
                            | cut -d= -f2- \
                            | sed 's/^"//;s/"$//'
                    }

                    DB_HOST=$(get_env DB_HOST)
                    DB_PORT=$(get_env DB_PORT)
                    DB_NAME=$(get_env DB_DATABASE)
                    DB_USER=$(get_env DB_USERNAME)
                    DB_PASS=$(get_env DB_PASSWORD)

                    MYSQL_CNF=$(mktemp)
                    chmod 600 "$MYSQL_CNF"

                    trap 'rm -f "$MYSQL_CNF"' EXIT

                    cat > "$MYSQL_CNF" <<EOF
[client]
host=$DB_HOST
port=$DB_PORT
user=$DB_USER
password=$DB_PASS
EOF

                    TABLE_COUNT=$(mysql \
                        --defaults-extra-file="$MYSQL_CNF" \
                        -Nse "
                        SELECT COUNT(*)
                        FROM information_schema.tables
                        WHERE table_schema='$DB_NAME'
                        AND table_name IN (
                            'm_lokasi',
                            'm_siswa_aktif',
                            'm_nominal_donasi',
                            't_donasi_palestineday'
                        );
                        "
                    )

                    echo "Detected application tables: $TABLE_COUNT / 4"

                    if [ "$TABLE_COUNT" -eq 0 ]; then

                        echo "Database kosong. Import staging.sql..."

                        mysql \
                            --defaults-extra-file="$MYSQL_CNF" \
                            "$DB_NAME" \
                            < "$SQL_FILE"

                        echo "Database bootstrap SUCCESS"

                    elif [ "$TABLE_COUNT" -eq 4 ]; then

                        echo "Database sudah tersedia. Bootstrap dilewati."

                    else

                        echo "ERROR: hanya ditemukan $TABLE_COUNT dari 4 tabel."
                        exit 1

                    fi
                '''
            }
        }

        stage('Database Bootstrap Test') {

            when {
                expression {
                    return params.RUN_DB_BOOTSTRAP_TEST
                }
            }

            steps {
                echo '=== DATABASE BOOTSTRAP RECOVERY TEST ==='

                sh '''
                    set -e
                    set +x

                    TEST_DB="palestineday_bootstrap_test"
                    ENV_FILE="${APP_DIR}/.env"
                    SQL_FILE="${WORKSPACE}/database/staging/staging.sql"

                    get_env() {
                        grep -E "^$1=" "$ENV_FILE" \
                            | tail -1 \
                            | cut -d= -f2- \
                            | sed 's/^"//;s/"$//'
                    }

                    DB_HOST=$(get_env DB_HOST)
                    DB_PORT=$(get_env DB_PORT)
                    DB_USER=$(get_env DB_USERNAME)
                    DB_PASS=$(get_env DB_PASSWORD)

                    MYSQL_CNF=$(mktemp)
                    chmod 600 "$MYSQL_CNF"

                    trap 'rm -f "$MYSQL_CNF"' EXIT

                    cat > "$MYSQL_CNF" <<EOF
[client]
host=$DB_HOST
port=$DB_PORT
user=$DB_USER
password=$DB_PASS
EOF

                    TABLE_COUNT=$(mysql \
                        --defaults-extra-file="$MYSQL_CNF" \
                        -Nse "
                        SELECT COUNT(*)
                        FROM information_schema.tables
                        WHERE table_schema='$TEST_DB'
                        AND table_name IN (
                            'm_lokasi',
                            'm_siswa_aktif',
                            'm_nominal_donasi',
                            't_donasi_palestineday'
                        );
                        "
                    )

                    echo "Before bootstrap: $TABLE_COUNT / 4 tables"

                    if [ "$TABLE_COUNT" -eq 0 ]; then

                        echo "Empty test database detected."
                        echo "Importing staging.sql..."

                        mysql \
                            --defaults-extra-file="$MYSQL_CNF" \
                            "$TEST_DB" \
                            < "$SQL_FILE"

                    elif [ "$TABLE_COUNT" -eq 4 ]; then

                        echo "Test database already bootstrapped."

                    else

                        echo "ERROR: Test DB has partial schema: $TABLE_COUNT / 4"
                        exit 1

                    fi

                    VERIFY_COUNT=$(mysql \
                        --defaults-extra-file="$MYSQL_CNF" \
                        -Nse "
                        SELECT COUNT(*)
                        FROM information_schema.tables
                        WHERE table_schema='$TEST_DB'
                        AND table_name IN (
                            'm_lokasi',
                            'm_siswa_aktif',
                            'm_nominal_donasi',
                            't_donasi_palestineday'
                        );
                        "
                    )

                    echo "After bootstrap: $VERIFY_COUNT / 4 tables"

                    if [ "$VERIFY_COUNT" -ne 4 ]; then
                        echo "DATABASE RECOVERY TEST FAILED"
                        exit 1
                    fi

                    echo "DATABASE RECOVERY TEST SUCCESS"
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

                    if [ "${HTTP_CODE}" -lt 200 ] || \
                       [ "${HTTP_CODE}" -ge 400 ]; then

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