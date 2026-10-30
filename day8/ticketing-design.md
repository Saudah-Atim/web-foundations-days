TicketHub – System Design

## 1.  Requirements

TicketHub is a website where people can buy tickets for concerts and events.

### Functional Requirements
The website should allow users to:
Create an account and log in.
View upcoming concerts and events.
Search for events by name, date or location.
View available seats and ticket prices.
Select and temporarily reserve seats.
Pay for their tickets.
Receive their tickets after payment.
View their purchased tickets.

### Non-Functional Requirements
Speed: The website should load quickly.
Correctness: One seat should never be sold to two people.
Fairness: Customers should have a fair chance to buy tickets.
Security: Customer information should be protected.
Availability: The website should work when customers need it.
Scalability: The website should handle more users when traffic increases.
Reliability: Payments and orders should be saved correctly.

## 2. Traffic Estimates
TicketHub has 2 million registered users.
Normal Daily Traffic
We are given these numbers:
50,000 people visit the website every day.
Each person views 10 pages.
5,000 tickets are sold every day.
Daily page views:
50,000 × 10 = 500,000 page views.
Average requests per second:
There are 86,400 seconds in one day.
500,000 ÷ 86,400 = approximately 5.8 requests per second.
Average ticket sales per second:
5,000 ÷ 86,400 = approximately 0.058 tickets per second.

### Popular Concert Sale
A popular concert goes on sale, and:
200,000 people want to buy tickets.
Only 20,000 seats are available.
The sale takes place within the first 10 minutes.
Purchase attempts per second:
10 minutes = 600 seconds.
200,000 ÷ 600 = approximately 333 attempts per second.
Available tickets per second:
20,000 ÷ 600 = approximately 33 tickets per second.
People competing for each seat:
200,000 ÷ 20,000 = 10 people per seat.
This means many people will try to buy tickets at the same time.

### Comparing Normal Traffic and Popular Sales
Measurement
Normal Day
Popular Sale
Visitors or attempts
50,000
200,000
Page views
500,000
Much higher
Average requests per second
5.8
333 purchase attempts
Tickets
5,000
20,000

The popular sale creates more pressure on the website.
The website needs to handle many requests without crashing or selling the same seat twice.
The 333 attempts per second is an average. The actual number may be higher when the sale first opens.

## 3. API Design

An API allows the website and the server to communicate.

| Method | Endpoint | Description |
|---|---|---|
| GET | /api/events | Shows all available events. |
| GET | /api/events/{eventId} | Shows details about one event. |
| GET | /api/events/{eventId}/seats | Shows available seats for an event. |
| POST | /api/holds | Temporarily reserves a seat for 5 minutes. |
| POST | /api/orders | Creates an order for selected seats. |
| POST | /api/payments | Processes customer payments. |
| GET | /api/tickets | Shows tickets purchased by a customer. |

### How the API works

1. GET allows customers to view events, seats and purchased tickets.
2. POST allows customers to reserve seats, create orders and make payments.
3. After successful payment, customers can view their tickets.

Customers must log in before making purchases or viewing their personal tickets.


## 4. Data Model

The database will have four main tables.

| Table | Fields | Purpose |
|---|---|---|
| Users | user_id, name, email, password | Stores customer information. |
| Events | event_id, event_name, date, venue | Stores event details. |
| Seats | seat_id, event_id, seat_number, status, order_id | Stores seats and their availability. |
| Orders | order_id, user_id, order_date, total_amount, payment_status | Stores customer orders and payment details. |

### Relationships

| Relationship | Explanation |
|---|---|
| Users → Orders | One user can make many orders. |
| Events → Seats | One event can have many seats. |
| Orders → Seats | One order can contain many seats. |

### Preventing Double Booking

When a customer selects a seat, the system checks whether it is available. The database locks that seat while the booking is being processed. This prevents another customer from booking the same seat at the same time.

The seat is marked as HELD for five minutes while the customer completes payment. After successful payment, it is marked as SOLD. If payment is not completed, the hold expires and the seat becomes available again.The database will also use a unique constraint on event_id and seat_number. This prevents the same seat from being added twice for the same event.

## 5. System Architecture

System architecture shows how the different parts of a website work together.

Architecture Diagram

             CUSTOMERS
                 |
                 v
          WEBSITE / FRONTEND
                 |
                 v
           LOAD BALANCER
                 |
                 v
             API GATEWAY
                 |
          +------+------+
          |             |
          v             v
      EVENT SERVICE   ORDER SERVICE
          |             |
          v             v
        CACHE         SEAT SERVICE
                        |
                        v
                    DATABASE
                        |
                        v
                  PAYMENT SERVICE
                        |
                        v
                  PAYMENT PROVIDER

                    ORDER SERVICE
                        |
                        v
                 NOTIFICATION SERVICE
                        |
                        v
                 EMAIL / TICKETS

Explanation of Each Component

### 1. Website / Frontend

This is what customers see and use when buying tickets.

### 2. Load Balancer

It shares incoming requests between different servers.
This prevents one server from doing all the work.

### 3. API Gateway

It receives requests and sends them to the correct service.
It also helps check user access and control too many requests.

### 4. Event Service

It provides information about concerts and events.

### 5. Cache

It stores information that customers request often.
Redis can be used for this.
It helps the website load faster.

### 6. Order Service

It creates and manages customer orders.

### 7. Seat Service

It checks available seats and manages temporary seat reservations.
It also helps prevent double booking.

### 8. Database

It stores customer details, events, seats and orders.
PostgreSQL can be used for this.

### 9. Payment Service

It connects the website to the payment provider.
It checks whether a payment is successful.

### 10. Notification Service

It sends customers an email with their ticket after successful payment.

## How the System Handles Many Customers
During a popular concert sale, many people may visit the website at once.

The system can handle this by:
1. Adding more servers to share the work.
2. Using a load balancer to distribute requests.
3. Using a waiting room to control the number of customers entering.
4. Using rate limiting to control too many requests.
5. Using a cache to reduce repeated database requests.
6. Using database transactions to protect seat bookings.
7. Using a queue to send ticket confirmation emails in the background.
These steps help the website work better when many people want tickets at the same time.

## 6. Design Trade-offs

### Trade-off 1: Speed versus Correctness
Using database locks can slow down some requests.
However, they help prevent two people from buying the same seat.
I would choose correctness because customers should not receive the same seat.

### Trade-off 2: Caching versus Fresh Information
Caching makes the website faster.
However, cached seat information may not always be up to date.
I would use caching for event information but check the database before holding or selling a seat.

## Conclusion
TicketHub is designed to help people buy concert and event tickets online.
The system should work during normal days and busy ticket sales.
It uses a load balancer, cache, database transactions and a waiting room to handle many customers.
The most important part is making sure that one seat is only sold to one customer