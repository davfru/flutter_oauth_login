# OAuth Login Flow with Flutter + AWS Cognito + Google

This project contains the source code for both backend and mobile (flutter). It allows to run a fully functional app to log in via Google using AWS Cognito IDP (OAuth 2.0).

![preview](./preview.gif)

design credits: https://dribbble.com/shots/25519212-App-UI

## Setup and deploy the infrastructure and run the app

Prerequisites:

 - Google Cloud and Firebase account
 - AWS account
 - VSCode with "Remote Development" extension
 - Docker

### 1. Setup Firebase project

1. Create a new project in Firebase using your Google account

2. Open the project in dev container and
  
    1. login into your firebase account
    
        ```sh
        firebase login --no-localhost
        ```

    2. init firebase project

        ```sh
        firebase init
        ```

        and follow the wizard, particularly:

        - select at least one service from those seggested, for example *Functions* we'll delete it later since we don't need it.
        - choose *Crate new project* option and give it the name *test-federation-login*

        after Firebase has been created, delete the following resources:
        - firebase.json (will be created again in the next step)
        - functions folder

    3. configure flutterfire

        ```sh
        flutterfire configure --project=test-federation-login --platforms=android --android-package-name=com.example.login.dev
        ```

    4. configure Google as Sign-in provider in Firebase
        - in Firebase console, on the left side menu, choose *Project categories > Build > Authentication > Sign-in method* and under *Sign-in provider* select *Additional providers > Google*
        
    5. in firebase under Project settings > Your apps provide SHA certificate by clicking on *Add fingerprint* and as value provide:
        - for testing purpose only (our case)

            ```sh 
            cd android
            ./gradlew signingReport -Pflavor=dev
            ``` 

            use SHA1 value printed in the console

        - for release only (**you can skip this step in our case**)
            - to create a key store (inside android/app folder)

                ```sh
                keytool -genkey -v -keystore my-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-key-alias
                ```

                for testing (ONLY) purposes we can use 'password' as password

            - to obtain SHA-1 key store

                ```sh
                keytool -list -v -keystore my-release-key.jks -alias my-key-alias
                ```

            - use SHA1 value printed in the console

            - modify *android/gradle.properties* adding

                ```
                storeFile=my-release-key.jks
                storePassword=password
                keyAlias=my-key-alias
                keyPassword=password
                ```

            - modify *android/app/build.gradle* adding

                ```
                signingConfigs {
                    release {
                        storeFile file(project.property("storeFile"))
                        storePassword project.property("storePassword")
                        keyAlias project.property("keyAlias")
                        keyPassword project.property("keyPassword")
                    }
                }
                buildTypes {
                    release {
                        signingConfig signingConfigs.release
                    }
                }
                ```

    6. download google-services.json and replace it in android/app/google-services.json

### 2. Deploy the infrastructure on AWS

1. open the project in dev container

2. configure aws cli by running ```aws configure```

3. update *aws/samconfig.yaml* modifying:
    - *GoogleClientId* giving as value the *client_id* located within the "client" section of the google-sevices.json file (use the web client one)
    
4. create a secret on AWS Secret manager for *GoogleClientSecret* giving as value the *secret* that you can download directly from Google Cloud > Google Auth Platform

    ```sh
        aws secretsmanager create-secret \
        --name GoogleClientSecret \
        --description "Google OAuth client secret (test project)" \
        --secret-string 'your-google-client-secret'
    ```

5. deploy aws

    ```sh
    cd aws
    sam build
    sam deploy --config-env "test"
    ```

6. now configure Cognito IDP on Google following the instruction [here](https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-social-idp.html) following *Step 1: Register with a social IdP (To register an app with Google)* and *Step 2: Add a social IdP to your user pool* steps


### 3. Run the app

#### Run the app on an Android device

- modify assets/config/.env.dev values:
    - COGNITO_DOMAIN (in AWS Cognito > Branding > Domain)
    - COGNITO_CLIENT_ID (in AWS Cognito > Applications > App clients)
- connect your device via Debug WiFi
- run the configuration (in my case) *moto g 5g plus (debug)*

Now you're ready to go! You should be able to login in the app with your Google account.

##### How to run via adb debugging (wifi)

- make sure both the Android device and your computer are connected to the same WiFi
- on your Android device go under *"System" > "Developer options" > "Debug wireless"* and click on *"Pair device with pairing code"*
- run the project inside the container and run

```sh
adb pair [ip]:[port]
```

*ip* and *port* are given by the device when clicking on *"Pair device with pairing code"*

- enter the pairing code
- on your android device close the pairing screen and look at the *"IP address and port"*

```sh
adb connect [ip]:[port]
adb devices
flutter run -d 192.168.0.102:40945
```

to run in debug mode add the following config inside .vscode/launch.json

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter on Device",
      "type": "dart",
      "request": "launch",
      "flutterMode": "debug",
      "deviceId": "192.168.0.102:40945"
    }
  ]
}
```