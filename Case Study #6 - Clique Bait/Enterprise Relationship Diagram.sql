/*
Using the provided DDL schema details to create an ERD for all the Clique Bait datasets.
*/

TABLE campaign_identifier 
{
  campaign_id integer [primary key]
  products VARCHAR(3)
  campaign_name VARCHAR(33)
  start_date TIMESTAMP
  end_date TIMESTAMP 
}

TABLE page_hierarchy
{
  page_id INTEGER [primary key]
  page_name VARCHAR(14)
  product_category VARCHAR(9)
  product_id INTEGER
}

Table users 
{
  user_id INTEGER
  cookie_id VARCHAR(6)
  start_date TIMESTAMP
}

Table events 
{
  visit_id VARCHAR(6)
  cookie_id VARCHAR(6)
  page_id INTEGER
  event_type INTEGER
  sequence_number INTEGER
  event_time TIMESTAMP
}

table event_identifier 
{
  event_type INTEGER [primary key]
  event_name VARCHAR(13)
}

Ref: "page_hierarchy"."page_id" < "events"."page_id"

Ref: "event_identifier"."event_type" < "events"."event_type"

Ref: "users"."cookie_id" < "events"."cookie_id"

Ref: "page_hierarchy"."product_id" < "campaign_identifier"."products"

image.png