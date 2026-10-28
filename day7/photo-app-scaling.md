Photo App Scaling Plan

1. Assumptions

SnapShare is a photo-sharing application with 10 million registered users.

Registered users: 10,000,000

Daily active users (DAU): 10% of registered users

Each active user uploads 1 photo per day.

Each active user views 50 photos per day.

Each original photo is 2 MB.

Each thumbnail is 50 KB.

Peak traffic is 5 times the average traffic.

There are 365 days in a year.

Calculations exclude storage overhead, backups, and replication.

2. Traffic Calculations

Daily active users

10,000,000 × 10% = 1,000,000 daily active users.

Photo uploads per second

Assuming each daily active user uploads one photo per day:

Daily uploads: 1,000,000 photos

Average uploads per second: 1,000,000 ÷ 86,400 = 11.57, or approximately 12 uploads per second.

Feed views per second

Assuming each daily active user views 50 photos per day:

Daily feed views: 1,000,000 × 50 = 50,000,000 views

Average feed views per second: 50,000,000 ÷ 86,400 = approximately 579 views per second.

Peak feed views per second: 579 × 5 = approximately 2,895 views per second.

3. Storage Calculations

Original photos

Daily storage: 1,000,000 × 2 MB = 2,000,000 MB, or approximately 2 TB per day.

Annual storage: 2 TB × 365 = approximately 730 TB per year.

Thumbnails

Daily storage: 1,000,000 × 50 KB = 50,000,000 KB, or approximately 50 GB per day.

Annual storage: 50 GB × 365 = approximately 18.25 TB per year.

Total annual photo storage

730 TB + 18.25 TB = approximately 748.25 TB per year.

This estimate excludes backups, replication, and storage overhead.

4. Read-Heavy or Write-Heavy?
SnapShare is a read-heavy application because users view many more photos than they upload. Each active user views 50 photos per day but uploads only one photo per day.
The system should therefore be designed to serve feed requests and photos efficiently while still handling photo 
uploads reliably.

5. Why Photos Should Not Be Stored Inside the Database
Photos should not be stored directly inside the database because image files are large and can increase database storage requirements, backup times, and query overhead. Instead, original photos and thumbnails should be stored in object storage, while the database stores their URLs or storage keys and related metadata. This makes photo storage easier to scale and allows a CDN to deliver photos efficiently to users.

6. Architecture Diagram

                         USERS
                           |
                           v
                    LOAD BALANCER
                           |
                           v
                    APPLICATION SERVERS
                      /     |      \
                     /      |       \
                    v       v        v
                  CACHE   PRIMARY   OBJECT STORAGE
                 (Feed)  DATABASE   (Original Photos)
                            |
                            v
                       READ REPLICA

                         PHOTO UPLOAD
                              |
                              v
                       APPLICATION SERVER
                              |
                 +------------+------------+
                 |                         |
                 v                         v
           OBJECT STORAGE            MESSAGE QUEUE
          (Original Photo)                 |
                                           v
                                    THUMBNAIL WORKER
                                           |
                                           v
                                    OBJECT STORAGE
                                       (Thumbnail)

                CDN delivers photos and thumbnails
                close to users.

7. Component Responsibilities

CDN: Delivers cached photos and thumbnails from locations closer to users, reducing latency and load on the application.

Load balancer: Distributes incoming requests across application servers to prevent one server from becoming overloaded.

Application servers: Handle user requests, validate uploads, manage feed requests, and communicate with other services.

Cache: Stores frequently requested feed data and other reusable information to reduce database queries.

Primary database: Stores structured information such as user accounts, photo metadata, captions, and relationships.

Read replica: Handles read queries separately from the primary database to reduce pressure on the main database.

Object storage: Stores original photos and generated thumbnails without placing large image files directly in the database.

Message queue: Holds thumbnail-generation jobs so photo uploads do not have to wait for thumbnail processing to finish.

Thumbnail worker: Processes queued jobs, creates smaller versions of uploaded photos, and saves them to object storage.

8. Photo Upload Flow

A user uploads a photo through the application.

The load balancer routes the request to an available application server.

The application server validates the upload and stores the original photo in object storage.

The application server saves the photo metadata in the primary database.

A thumbnail-generation job is placed in the message queue.

A thumbnail worker retrieves the job and generates a smaller version of the photo.

The worker stores the thumbnail in object storage.

The CDN delivers the original photo or thumbnail to users when requested.

This asynchronous process allows the original upload to complete without waiting for thumbnail generation.

9. Trade-offs

Trade-off 1: Caching versus data freshness
Caching feed data improves response times and reduces database load. However, cached information may become outdated when a user uploads a new photo or updates their profile. The application must invalidate or update relevant cached data when changes occur.

Trade-off 2: Asynchronous thumbnail generation versus immediate availability
Using a message queue allows uploads to finish faster and lets thumbnail workers process jobs independently. However, a thumbnail may not be available immediately after upload. The application should handle this delay gracefully.

