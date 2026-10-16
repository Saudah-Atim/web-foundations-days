Library Books REST API

Overview

This API manages books in a library. It supports listing, retrieving, creating, updating, deleting, and searching for books by author.

Base URL: /api/books

Endpoints

1. List all books

Method: GET

Path: /api/books

Description: Returns a list of all books in the library.

Success status: 200 OK

2. Get one book

Method: GET

Path: /api/books/{id}

Description: Returns the details of a book with the specified ID.

Success status: 200 OK

3. Create a book

Method: POST

Path: /api/books

Description: Adds a new book to the library.

Example request body:

{
  "title": "Fifty Shades of Grey",
  "author": "E. L. James",
  "year": 2011
}

Success status: 201 Created

4. Update a book

Method: PUT

Path: /api/books/{id}

Description: Replaces the details of an existing book.

Example request body:

{
  "title": "Fifty Shades of Grey",
  "author": "E. L. James",
  "year": 2011
}

Success status: 200 OK

5. Delete a book

Method: DELETE

Path: /api/books/{id}

Description: Deletes a book with the specified ID.

Success status: 204 No Content

6. List books by author

Method: GET

Path: /api/books?author=E.%20L.%20James

Description: Returns books written by the specified author using a query parameter.

Success status: 200 OK

Error Responses

400 Bad Request

Returned when the request contains invalid data, such as creating a book without a title.

404 Not Found

Returned when a requested book ID does not exist in the library.