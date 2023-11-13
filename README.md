# Technology Note App
This app allows you to easily log your interests when consuming technical information through various mediums such as technical articles, technical books, podcasts, and YouTube.  
Previously, I used the bookmark feature of web browsers and note-taking apps for logging, but I wanted a more straightforward way to search and revisit the information, which led to the creation of this app.  
Additionally, this app was experimentally designed in collaboration with ChatGPT (GPT-4).

# Technology Stack
- Frontend
  - Flutter for Web
- Backend
  - Firestore
  - Firebase Hosting
  - Firebase Authentication
  - Firebase Storage  

# Design Considerations
Based on the design proposals suggested by GPT-4, the following points have been identified as key areas requiring focused consideration for this app.
## Data Model Design
We will design a data model that allows for efficient saving and searching of notes, article links, technical book annotations, and the like.  
This involves identifying entities and attributes, defining relationships, and concurrently considering the design of Firestore collections and documents.  
The primary entities of the technology notes app and their attributes will be clearly identified, and the relationships between entities will be clearly defined to understand their interconnections.  
Subsequently, based on these entities and relationships, we will design the structure of Firestore collections and documents. Finally, we will define Firestore rules that comply with the structural design.
## Caching Strategy and Search Functionality
Based on GPT-4's suggestion:  
"To provide a high-performance search function, consider using a full-text search engine. In Flutter, it is possible to utilize Full-Text Search (FTS) features in combination with SQLite."  
However, implementing full-text search in Firestore could lead to a high number of read and write operations, and using a full-text search service like ElasticSearch or Algolia would be an overcomplication for the amount of text we handle.  
Therefore, we decided not to use a full-text search service.  
Nevertheless, to reduce frequent network usage and the number of Firestore reads, we will adopt the use of local storage.  
Pros and Cons of using Firestore + Local Storage (from GPT-4):  

1. Pros: Utilizing local cache enables fast data access and improves data access when offline.
2. Cons: Data synchronization logic can become complex, potentially making code maintenance more challenging.
## Security
In the case of a web application, since it is accessible by anyone, we will use Firebase's Authentication feature to restrict user access.

# Data Model Design
## Entry Data
This is the data for recording technical information.  
We adopt a structure where each entry's document is placed directly under the Entries Collection, without creating a hierarchical structure.  
This design minimizes read and write operations to Firestore while maintaining a simple and intuitive data model.  
Additionally, by providing a categories array field in each entry document, we can efficiently maintain information that belongs to multiple technical categories.
## Tag Data
This is the tag data used for augmenting technical information.
We've given this considerable thought as it's crucial for easily and clearly searching the recorded data.
Registering tags haphazardly can lead to confusion, but creating a hierarchical structure would make it too complex and cumbersome to manage.
Initially, we proceeded with a two-tier structure of categories and tags, but this was abandoned due to many overlapping cases.
Ultimately, we settled on using a broader classification called 'areas', which will be defined within the app as they do not require editing.
The categorization of areas is based on the classifications used by Thoughtworks.
1. Language & Framework
2. Technique
3. Platform&Tool
4. Media
Additionally, confusion is prevented by limiting the maximum number of tags to 5.
## Read Timing
Since Firestore bills based on the number of reads and because we want to be able to browse content outside where network communication should be minimized, we will limit it as much as possible.
We maintain a document in Firestore to keep track of data update times. Once the app fetches all the data for the first time, it records that timestamp.
The next time the app is opened, it compares the local timestamp with the one held in Firestore, and if there have been updates, the data is fetched again.
At this time, tag information is unconditionally fetched in full, whereas entry information is fetched only if the updateAt indicates that there have been updates.
## Data Structure
Decide on the Firestore data structure.
```
TechNote(col)
  - updateInfo(doc)
    [Field]
    - entryVersion: Timestamp of the last entry update
    - tagVersion: Timestamp of the last tag update
  - TechEntry(doc)
    - Entries(col)
      - [Random ID]
        [Field]
        - title: The title of the entry
        - url: The URL link for the entry; if there is no URL, this is left empty
        - contents: Notes or comments about the entry
        - mainTag: The ID of the main tag associated with the entry
        - tags: An array of tag IDs related to the entry
        - createdAt: The creation date of the entry
        - updatedAt: The date the entry was last updated
  - TechTag(doc)
    - Tags(col)
      - [Random ID]
        [Field]
        - name: The name of the tag
        - thumbnailUrl: The URL for the thumbnail image (located in Storage)
        - color: The color of the tag (in hex)
        - isTextColorBlack: Is name text color black
        - area: The ID of the area associated with the tag
```