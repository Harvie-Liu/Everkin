-- Revenue OS R2.0 bootstrap schema (PostgreSQL)

create schema if not exists catalog;
create schema if not exists cpq;
create schema if not exists contract;
create schema if not exists subscription;
create schema if not exists billing;
create schema if not exists cash;
create schema if not exists credit;
create schema if not exists invoice;
create schema if not exists audit;

create table if not exists cpq.quote (
  id varchar(64) primary key,
  customer_id varchar(64) not null,
  currency varchar(8) not null default 'CNY',
  status varchar(32) not null default 'draft',
  created_at timestamptz not null default now()
);

create table if not exists cpq.quote_line (
  id varchar(64) primary key,
  quote_id varchar(64) not null references cpq.quote(id),
  sku_code varchar(64) not null,
  quantity numeric(18,4) not null,
  unit_price numeric(18,2) not null,
  amount numeric(18,2) not null
);

create table if not exists contract.contract (
  id varchar(64) primary key,
  quote_id varchar(64),
  customer_id varchar(64) not null,
  status varchar(32) not null default 'draft',
  start_date date,
  end_date date,
  created_at timestamptz not null default now()
);

create table if not exists subscription.subscription (
  id varchar(64) primary key,
  contract_id varchar(64) not null,
  status varchar(32) not null,
  created_at timestamptz not null default now()
);

create table if not exists audit.audit_log (
  id bigserial primary key,
  actor varchar(128) not null,
  action varchar(128) not null,
  object_type varchar(64) not null,
  object_id varchar(64) not null,
  payload jsonb,
  created_at timestamptz not null default now()
);
