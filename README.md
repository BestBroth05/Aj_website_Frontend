# guadalajarav2
    For better reading, open with a Markdown visualizer (e.g. Visual Studio Code with Markdown Preview Enhanced Extension)
---

AJ's Website project. Here you can find the inventory, projects and administrative site.

---

In the [***pubsec.yaml***](pubspec.yaml) you can find all necessary **dependencies** and **assets (images, fonts and icons)**

### Views 

- Most of the views of the site you can find in the **lib/views** folder. 
- The add/edit components popup you can find in the **lib/inventory** folder.

### Classes

- The components classes are in **lib/inventory/classes**.
- users, bom parts, and team members classes are all in the **lib/classes path**.

### Enums
- working areas, routes, digikey filters, subCategories can be found on **lib/enums**.
- project permissions and status can be found on **lib/enums/projects**.
- enums for the categories and values for the components can be found in **lib/inventory/enums/**.

## Connection with backend

#### Database
All connections with the database can be found in [***database.dart***](lib/database.dart). With some exceptions:
- To get all the projects from the user, the function is in [***projects_handler.dart***](lib/utils/projects/projects_handler.dart).
- To all the projects from the admin side, the functions can be found in [***projects_database_handler.dart***](lib/utils/admin/projects/projects_database_handler.dart).
- The handler for the likes in the *about us* section of the website, can be found in [***about_us_handler.dart***](lib/utils/about_us/about_us_handler.dart)

#### APIs

- [**Digikey**](lib/utils/inventory/digikey_api_handler.dart)
- [**Mouser**](lib/utils/inventory/mouser_api_handler.dart)

### Upload new Images

To upload **new images** to either the **projects** section or **clients** from an area there are two simple steps:

1. You need to locate the corresponding folder for the section you want to upload and put the image in the folder.
2. You need to update the ***assets/AssetManifest.json*** and add the directory of the new image.

For example, to add a new client image to Software, we would need to go to the following directory: 

***assets\assets\images\software\clientes***

There put the new image. Then add the new line to the **AssetManifest.json**: 

```
    "assets/images/software/clientes/NEW_IMAGE.png": [
        "assets/images/software/clientes/NEW_IMAGE.png"
    ],
```