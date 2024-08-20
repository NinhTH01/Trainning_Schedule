To run the project, please perform the following steps:

- Step 1: Verify installations

```sh
$ flutter doctor
```

- Step 2: Pull project dependencies

```sh
$ flutter pub get
```

- Step 3: Generate the generated files

```sh
$ flutter pub run build_runner build --delete-conflicting-outputs
``` 

- Step 4: Build and test app

- Step 5: Build debug app android : Run script build_app_for_debug.sh


File hierachy
```
📁 flutter-base-code-template
    |- 📁 assets
        |- 📁 colors
            |- colors.xml
        |- 📁 fonts
            |- ....ttf
        |- 📁 images
            |- ....png
    |- 📁 android
            |- 📁 app
                |- 📁 src
                    |- 📁 main
                        |- 📁 res
                            |- 📁 values
                                |- api_key.xml (ignored by the .gitignore file)
    |- 📁 build
    |- 📁 ios
        |- 📁 Runner
            |- Keys.plist (ignored by the .gitignore file)
    |- 📁 lib
        |- 📁 components
        |- 📁 data
            |- 📁 models
            |- 📁 providers
            |- 📁 repositories
            |- 📁 services
        |- 📁 models
            |- 📁 api
            |- 📁 storage
        |- 📁 router
            |- app_router.dart
            |- app_router.g.dart
        |- 📁 screens
            |- 📁 calendar
            |- 📁 calendar_date_edit_event
            |- 📁 main
            |- 📁 map
            |- 📁 onboarding
            |- 📁 splash
            |- 📁 weather
        |- 📁 resources
            |- 📁 gen
                |- assets.gen.dart
                |- colors.gen.dart
                |- fonts.gen.dart
        |- 📁 utilities
            |- 📁 constants
            |- 📁 extensions
        app.dart      
    |- 📁 test
    |- api-keys.json (ignored by the .gitignore file)
```