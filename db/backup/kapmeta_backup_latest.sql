--
-- PostgreSQL database dump
--

\restrict dYaaekmSQylk4Y7bfWDcnwfXx0mzhJduemVAtV9dL7s7yHXHgk2e9gacpS6ZCdW

-- Dumped from database version 16.15
-- Dumped by pg_dump version 16.15

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: audit_action; Type: TYPE; Schema: public; Owner: pos
--

CREATE TYPE public.audit_action AS ENUM (
    'CREATE',
    'UPDATE',
    'DELETE',
    'APPROVE',
    'OVERRIDE',
    'EXPORT'
);


ALTER TYPE public.audit_action OWNER TO pos;

--
-- Name: availability_state; Type: TYPE; Schema: public; Owner: pos
--

CREATE TYPE public.availability_state AS ENUM (
    'ON',
    'OFF',
    'PARTIAL',
    'UNSCHEDULED'
);


ALTER TYPE public.availability_state OWNER TO pos;

--
-- Name: channel_type; Type: TYPE; Schema: public; Owner: pos
--

CREATE TYPE public.channel_type AS ENUM (
    'POS',
    'SWIGGY',
    'ZOMATO',
    'OTHER'
);


ALTER TYPE public.channel_type OWNER TO pos;

--
-- Name: dining_table_status; Type: TYPE; Schema: public; Owner: pos
--

CREATE TYPE public.dining_table_status AS ENUM (
    'VACANT',
    'SEATED',
    'OCCUPIED',
    'RESERVED',
    'MERGED_MEMBER',
    'DIRTY',
    'BLOCKED'
);


ALTER TYPE public.dining_table_status OWNER TO pos;

--
-- Name: order_channel; Type: TYPE; Schema: public; Owner: pos
--

CREATE TYPE public.order_channel AS ENUM (
    'dine_in',
    'online',
    'takeaway',
    'delivery'
);


ALTER TYPE public.order_channel OWNER TO pos;

--
-- Name: order_status; Type: TYPE; Schema: public; Owner: pos
--

CREATE TYPE public.order_status AS ENUM (
    'open',
    'running',
    'printed',
    'paid',
    'cancelled',
    'DRAFT',
    'PLACED',
    'CONFIRMED',
    'KOT_CREATED',
    'IN_PREPARATION',
    'READY',
    'ASSIGNED',
    'OUT_FOR_DELIVERY',
    'SERVED',
    'HANDED_OVER',
    'COMPLETED',
    'FAILED'
);


ALTER TYPE public.order_status OWNER TO pos;

--
-- Name: order_type; Type: TYPE; Schema: public; Owner: pos
--

CREATE TYPE public.order_type AS ENUM (
    'DINE_IN',
    'PICKUP',
    'DELIVERY'
);


ALTER TYPE public.order_type OWNER TO pos;

--
-- Name: seat_status; Type: TYPE; Schema: public; Owner: pos
--

CREATE TYPE public.seat_status AS ENUM (
    'EMPTY',
    'SEATED',
    'ORDERED',
    'BILLED',
    'SETTLED'
);


ALTER TYPE public.seat_status OWNER TO pos;

--
-- Name: sync_status; Type: TYPE; Schema: public; Owner: pos
--

CREATE TYPE public.sync_status AS ENUM (
    'PENDING',
    'SYNCHRONIZED',
    'FAILED'
);


ALTER TYPE public.sync_status OWNER TO pos;

--
-- Name: table_merge_status; Type: TYPE; Schema: public; Owner: pos
--

CREATE TYPE public.table_merge_status AS ENUM (
    'ACTIVE',
    'CLOSED'
);


ALTER TYPE public.table_merge_status OWNER TO pos;

--
-- Name: tax_mode; Type: TYPE; Schema: public; Owner: pos
--

CREATE TYPE public.tax_mode AS ENUM (
    'backward',
    'forward'
);


ALTER TYPE public.tax_mode OWNER TO pos;

--
-- Name: veg_flag; Type: TYPE; Schema: public; Owner: pos
--

CREATE TYPE public.veg_flag AS ENUM (
    'veg',
    'non_veg',
    'egg'
);


ALTER TYPE public.veg_flag OWNER TO pos;

--
-- Name: CAST (public.order_status AS text); Type: CAST; Schema: -; Owner: -
--

CREATE CAST (public.order_status AS text) WITH INOUT AS IMPLICIT;


--
-- Name: CAST (text AS public.order_status); Type: CAST; Schema: -; Owner: -
--

CREATE CAST (text AS public.order_status) WITH INOUT AS IMPLICIT;


--
-- Name: fn_assert_status_transition(); Type: FUNCTION; Schema: public; Owner: pos
--

CREATE FUNCTION public.fn_assert_status_transition() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.status = OLD.status THEN
        RETURN NEW;
    END IF;

    IF OLD.status = 'COMPLETED' THEN
        RAISE EXCEPTION 'illegal order status transition: % -> % (order % is COMPLETED, terminal)',
            OLD.status, NEW.status, OLD.id;
    END IF;

    IF NEW.status = 'CANCELLED' THEN
        RETURN NEW; -- any pre-COMPLETED state may cancel
    END IF;

    IF OLD.status = 'CANCELLED' AND NEW.status = 'FAILED' THEN
        RETURN NEW;
    END IF;

    IF (OLD.status, NEW.status) IN (
        ('DRAFT', 'PLACED'),
        ('PLACED', 'CONFIRMED'),
        ('CONFIRMED', 'KOT_CREATED'),
        ('KOT_CREATED', 'IN_PREPARATION'),
        ('IN_PREPARATION', 'READY'),
        ('READY', 'ASSIGNED'),
        ('READY', 'SERVED'),
        ('READY', 'HANDED_OVER'),
        ('ASSIGNED', 'OUT_FOR_DELIVERY'),
        ('OUT_FOR_DELIVERY', 'SERVED'),
        ('OUT_FOR_DELIVERY', 'HANDED_OVER'),
        ('SERVED', 'COMPLETED'),
        ('HANDED_OVER', 'COMPLETED')
    ) THEN
        RETURN NEW;
    END IF;

    RAISE EXCEPTION 'illegal order status transition: % -> % (order %)', OLD.status, NEW.status, OLD.id;
END;
$$;


ALTER FUNCTION public.fn_assert_status_transition() OWNER TO pos;

--
-- Name: fn_business_date(timestamp with time zone, uuid); Type: FUNCTION; Schema: public; Owner: pos
--

CREATE FUNCTION public.fn_business_date(p_at timestamp with time zone, p_outlet_id uuid) RETURNS date
    LANGUAGE sql STABLE
    AS $$
    SELECT (p_at AT TIME ZONE o.timezone - o.day_start_time)::DATE
    FROM outlets o
    WHERE o.id = p_outlet_id;
$$;


ALTER FUNCTION public.fn_business_date(p_at timestamp with time zone, p_outlet_id uuid) OWNER TO pos;

--
-- Name: sync_audit_logs_columns(); Type: FUNCTION; Schema: public; Owner: pos
--

CREATE FUNCTION public.sync_audit_logs_columns() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN IF NEW.user_id IS NULL THEN NEW.user_id := NEW.actor_id; END IF; IF NEW.actor_id IS NULL THEN NEW.actor_id := NEW.user_id; END IF; RETURN NEW; END; $$;


ALTER FUNCTION public.sync_audit_logs_columns() OWNER TO pos;

--
-- Name: sync_invoice_columns(); Type: FUNCTION; Schema: public; Owner: pos
--

CREATE FUNCTION public.sync_invoice_columns() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN IF NEW.invoice_no IS NULL AND NEW.invoice_number IS NOT NULL THEN NEW.invoice_no := NEW.invoice_number; ELSIF NEW.invoice_number IS NULL AND NEW.invoice_no IS NOT NULL THEN NEW.invoice_number := NEW.invoice_no; END IF; RETURN NEW; END; $$;


ALTER FUNCTION public.sync_invoice_columns() OWNER TO pos;

--
-- Name: sync_invoice_fields(); Type: FUNCTION; Schema: public; Owner: pos
--

CREATE FUNCTION public.sync_invoice_fields() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.invoice_number IS NULL AND NEW.invoice_no IS NOT NULL THEN
    NEW.invoice_number := NEW.invoice_no;
  ELSIF NEW.invoice_no IS NULL AND NEW.invoice_number IS NOT NULL THEN
    NEW.invoice_no := NEW.invoice_number;
  END IF;

  IF (NEW.amount IS NOT NULL AND NEW.amount > 0) AND (NEW.amount_minor IS NULL OR NEW.amount_minor = 0) THEN
    NEW.amount_minor := NEW.amount;
  ELSIF (NEW.amount_minor IS NOT NULL AND NEW.amount_minor > 0) AND (NEW.amount IS NULL OR NEW.amount = 0) THEN
    NEW.amount := NEW.amount_minor;
  END IF;

  IF (NEW.tax_amount IS NOT NULL AND NEW.tax_amount > 0) AND (NEW.tax_amount_minor IS NULL OR NEW.tax_amount_minor = 0) THEN
    NEW.tax_amount_minor := NEW.tax_amount;
  ELSIF (NEW.tax_amount_minor IS NOT NULL AND NEW.tax_amount_minor > 0) AND (NEW.tax_amount IS NULL OR NEW.tax_amount = 0) THEN
    NEW.tax_amount := NEW.tax_amount_minor;
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sync_invoice_fields() OWNER TO pos;

--
-- Name: sync_order_items_columns(); Type: FUNCTION; Schema: public; Owner: pos
--

CREATE FUNCTION public.sync_order_items_columns() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
      BEGIN
        IF NEW.item_id IS NULL THEN
          NEW.item_id := NEW.menu_item_id;
        END IF;
        IF NEW.menu_item_id IS NULL THEN
          NEW.menu_item_id := NEW.item_id;
        END IF;
        IF NEW.qty IS NULL THEN
          NEW.qty := COALESCE(NEW.quantity, 1);
        END IF;
        IF NEW.quantity IS NULL THEN
          NEW.quantity := COALESCE(NEW.qty, 1);
        END IF;
        IF NEW.unit_price_minor IS NULL THEN
          NEW.unit_price_minor := COALESCE(NEW.unit_price, 0);
        END IF;
        IF NEW.unit_price IS NULL THEN
          NEW.unit_price := COALESCE(NEW.unit_price_minor, 0);
        END IF;
        IF NEW.total_price_minor IS NULL THEN
          NEW.total_price_minor := COALESCE(NEW.subtotal, 0);
        END IF;
        IF NEW.subtotal IS NULL THEN
          NEW.subtotal := COALESCE(NEW.total_price_minor, 0);
        END IF;
        IF NEW.item_name IS NULL THEN
          NEW.item_name := 'Item';
        END IF;
        RETURN NEW;
      END;
      $$;


ALTER FUNCTION public.sync_order_items_columns() OWNER TO pos;

--
-- Name: sync_order_status_history(); Type: FUNCTION; Schema: public; Owner: pos
--

CREATE FUNCTION public.sync_order_status_history() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
      BEGIN
        IF NEW.to_status IS NULL THEN
          NEW.to_status := COALESCE(NEW.status, 'PLACED');
        END IF;
        IF NEW.status IS NULL THEN
          NEW.status := COALESCE(NEW.to_status, 'PLACED');
        END IF;
        RETURN NEW;
      END;
      $$;


ALTER FUNCTION public.sync_order_status_history() OWNER TO pos;

--
-- Name: sync_orders_columns(); Type: FUNCTION; Schema: public; Owner: pos
--

CREATE FUNCTION public.sync_orders_columns() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
      BEGIN
        IF NEW.type IS NULL THEN
          NEW.type := COALESCE(NEW.order_type, 'DINE_IN');
        END IF;
        IF NEW.order_type IS NULL THEN
          NEW.order_type := COALESCE(NEW.type, 'DINE_IN');
        END IF;
        IF NEW.business_date IS NULL THEN
          NEW.business_date := CURRENT_DATE;
        END IF;
        IF NEW.total_minor IS NULL OR NEW.total_minor = 0 THEN
          NEW.total_minor := COALESCE(NEW.grand_total, 0);
        END IF;
        IF NEW.subtotal_minor IS NULL OR NEW.subtotal_minor = 0 THEN
          NEW.subtotal_minor := COALESCE(NEW.subtotal, 0);
        END IF;
        RETURN NEW;
      END;
      $$;


ALTER FUNCTION public.sync_orders_columns() OWNER TO pos;

SET default_tablespace = '';

--
-- Name: access_logs; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.access_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    user_id uuid,
    endpoint text NOT NULL,
    ip_address inet,
    status_code integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid
)
PARTITION BY RANGE (created_at);


ALTER TABLE public.access_logs OWNER TO pos;

SET default_table_access_method = heap;

--
-- Name: access_logs_default; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.access_logs_default (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    user_id uuid,
    endpoint text NOT NULL,
    ip_address inet,
    status_code integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.access_logs_default OWNER TO pos;

--
-- Name: access_logs_y2026m08; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.access_logs_y2026m08 (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    user_id uuid,
    endpoint text NOT NULL,
    ip_address inet,
    status_code integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.access_logs_y2026m08 OWNER TO pos;

--
-- Name: addon_commissions; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.addon_commissions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    addon_item_id uuid NOT NULL,
    commission_type text NOT NULL,
    commission_value numeric(10,2),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT addon_commissions_commission_type_check CHECK ((commission_type = ANY (ARRAY['PERCENTAGE'::text, 'FLAT'::text])))
);


ALTER TABLE public.addon_commissions OWNER TO pos;

--
-- Name: agent_telemetry; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.agent_telemetry (
    id character varying(64) NOT NULL,
    name character varying(128) NOT NULL,
    role character varying(64) NOT NULL,
    status character varying(32) DEFAULT 'ONLINE'::character varying NOT NULL,
    domain text NOT NULL,
    port integer,
    latency_ms integer DEFAULT 0 NOT NULL,
    health character varying(32) DEFAULT 'Passing'::character varying NOT NULL,
    current_task text NOT NULL,
    metrics jsonb,
    assigned_files jsonb,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.agent_telemetry OWNER TO pos;

--
-- Name: areas; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.areas (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    name text NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.areas OWNER TO pos;

--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.audit_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    entity_type text NOT NULL,
    entity_id uuid NOT NULL,
    action text NOT NULL,
    actor_id uuid,
    before_state jsonb,
    after_state jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    user_id uuid,
    reason_code text,
    approver_user_id uuid,
    ip_address text
)
PARTITION BY RANGE (created_at);


ALTER TABLE public.audit_logs OWNER TO pos;

--
-- Name: audit_logs_default; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.audit_logs_default (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    entity_type text NOT NULL,
    entity_id uuid NOT NULL,
    action text NOT NULL,
    actor_id uuid,
    before_state jsonb,
    after_state jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    user_id uuid,
    reason_code text,
    approver_user_id uuid,
    ip_address text
);


ALTER TABLE public.audit_logs_default OWNER TO pos;

--
-- Name: audit_logs_y2026m08; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.audit_logs_y2026m08 (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    entity_type text NOT NULL,
    entity_id uuid NOT NULL,
    action text NOT NULL,
    actor_id uuid,
    before_state jsonb,
    after_state jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    user_id uuid,
    reason_code text,
    approver_user_id uuid,
    ip_address text
);


ALTER TABLE public.audit_logs_y2026m08 OWNER TO pos;

--
-- Name: availability_schedules; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.availability_schedules (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    item_id uuid NOT NULL,
    day_of_week smallint NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    is_active boolean DEFAULT true NOT NULL,
    category_id uuid,
    CONSTRAINT ck_availability_schedules_dow CHECK (((day_of_week >= 0) AND (day_of_week <= 6)))
);


ALTER TABLE public.availability_schedules OWNER TO pos;

--
-- Name: backup_jobs; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.backup_jobs (
    id bigint NOT NULL,
    outlet_id uuid NOT NULL,
    job_type text DEFAULT 'full'::text NOT NULL,
    destination text DEFAULT 'local'::text NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    started_at timestamp with time zone,
    finished_at timestamp with time zone,
    error_message text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.backup_jobs OWNER TO pos;

--
-- Name: backup_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.backup_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.backup_jobs_id_seq OWNER TO pos;

--
-- Name: backup_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.backup_jobs_id_seq OWNED BY public.backup_jobs.id;


--
-- Name: campaign_recipients; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.campaign_recipients (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    campaign_id uuid NOT NULL,
    customer_id uuid,
    status text DEFAULT 'PENDING'::text NOT NULL,
    sent_at timestamp with time zone,
    error_message text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.campaign_recipients OWNER TO pos;

--
-- Name: cash_drawer_sessions; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.cash_drawer_sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    opened_by uuid NOT NULL,
    closed_by uuid,
    opened_at timestamp with time zone DEFAULT now() NOT NULL,
    closed_at timestamp with time zone,
    opening_balance_minor bigint DEFAULT 0 NOT NULL,
    expected_close_balance_minor bigint DEFAULT 0 NOT NULL,
    actual_close_balance_minor bigint,
    discrepancy_minor bigint,
    status character varying(50) DEFAULT 'OPEN'::character varying NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.cash_drawer_sessions OWNER TO pos;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    parent_id uuid,
    name text NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.categories OWNER TO pos;

--
-- Name: channel_accounts; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.channel_accounts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    integration_id uuid NOT NULL,
    external_outlet_id text,
    credentials_ref text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.channel_accounts OWNER TO pos;

--
-- Name: channel_item_mapping; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.channel_item_mapping (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    channel_account_id uuid NOT NULL,
    item_id uuid NOT NULL,
    external_item_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    channel_code character varying(50),
    version integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.channel_item_mapping OWNER TO pos;

--
-- Name: channel_sync_log; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.channel_sync_log (
    id bigint NOT NULL,
    outlet_id uuid NOT NULL,
    order_id uuid,
    channel public.order_channel NOT NULL,
    target text NOT NULL,
    direction text DEFAULT 'outbound'::text NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    payload jsonb,
    response jsonb,
    attempted_at timestamp with time zone DEFAULT now() NOT NULL,
    error_message text
);


ALTER TABLE public.channel_sync_log OWNER TO pos;

--
-- Name: TABLE channel_sync_log; Type: COMMENT; Schema: public; Owner: pos
--

COMMENT ON TABLE public.channel_sync_log IS 'Append-only audit log of fan-out to/from online-ordering aggregators and other external channels.';


--
-- Name: channel_sync_log_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.channel_sync_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.channel_sync_log_id_seq OWNER TO pos;

--
-- Name: channel_sync_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.channel_sync_log_id_seq OWNED BY public.channel_sync_log.id;


--
-- Name: configuration_changes; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.configuration_changes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    config_key text NOT NULL,
    old_value jsonb,
    new_value jsonb,
    actor_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid
)
PARTITION BY RANGE (created_at);


ALTER TABLE public.configuration_changes OWNER TO pos;

--
-- Name: configuration_changes_default; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.configuration_changes_default (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    config_key text NOT NULL,
    old_value jsonb,
    new_value jsonb,
    actor_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.configuration_changes_default OWNER TO pos;

--
-- Name: configuration_changes_y2026m08; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.configuration_changes_y2026m08 (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    config_key text NOT NULL,
    old_value jsonb,
    new_value jsonb,
    actor_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.configuration_changes_y2026m08 OWNER TO pos;

--
-- Name: customer_addresses; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.customer_addresses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    customer_id uuid NOT NULL,
    label text,
    line1 text NOT NULL,
    line2 text,
    city text,
    postal_code text,
    latitude numeric,
    longitude numeric,
    is_default boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.customer_addresses OWNER TO pos;

--
-- Name: customer_tags; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.customer_tags (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    customer_id uuid NOT NULL,
    tag text NOT NULL,
    source text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.customer_tags OWNER TO pos;

--
-- Name: customers; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.customers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid,
    phone text NOT NULL,
    name text,
    email public.citext,
    consent_marketing boolean DEFAULT false NOT NULL,
    consent_data_sharing boolean DEFAULT false NOT NULL,
    consent_recorded_at timestamp with time zone,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    outlet_id uuid,
    first_name text,
    last_name text,
    loyalty_points integer DEFAULT 0,
    birth_date date
);


ALTER TABLE public.customers OWNER TO pos;

--
-- Name: daily_sales_summary; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.daily_sales_summary (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    business_date date NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.daily_sales_summary OWNER TO pos;

--
-- Name: dining_tables; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.dining_tables (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    table_number text NOT NULL,
    capacity integer DEFAULT 4,
    section text DEFAULT 'General'::text,
    status text DEFAULT 'VACANT'::text,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    merge_group_id uuid,
    merge_primary_table_id uuid,
    version integer DEFAULT 1 NOT NULL,
    covers integer,
    is_air_conditioned boolean,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.dining_tables OWNER TO pos;

--
-- Name: hourly_sales_summary; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.hourly_sales_summary (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    business_date date NOT NULL,
    hour smallint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    CONSTRAINT ck_hourly_sales_summary_hour CHECK (((hour >= 0) AND (hour <= 23)))
);


ALTER TABLE public.hourly_sales_summary OWNER TO pos;

--
-- Name: inbound_events; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.inbound_events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    channel_account_id uuid NOT NULL,
    external_event_id text NOT NULL,
    raw_payload jsonb NOT NULL,
    processed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.inbound_events OWNER TO pos;

--
-- Name: ingredients; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.ingredients (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    unit_of_measure character varying(50) NOT NULL,
    unit_cost_minor bigint DEFAULT 0 NOT NULL,
    reorder_level numeric DEFAULT 500 NOT NULL,
    current_stock_qty numeric(12,3) DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    current_stock numeric DEFAULT 0,
    unit_cost bigint DEFAULT 0
);


ALTER TABLE public.ingredients OWNER TO pos;

--
-- Name: integration_errors; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.integration_errors (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    source_event_id uuid,
    error_code text NOT NULL,
    detail text,
    resolved_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.integration_errors OWNER TO pos;

--
-- Name: integrations; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.integrations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code text NOT NULL,
    type public.channel_type NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.integrations OWNER TO pos;

--
-- Name: inventory_consumption_log; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.inventory_consumption_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    order_id uuid NOT NULL,
    order_item_id uuid NOT NULL,
    ingredient_id uuid NOT NULL,
    recipe_id uuid NOT NULL,
    quantity_deducted numeric(12,3) NOT NULL,
    remaining_stock numeric(12,3),
    shortage numeric(12,3) DEFAULT 0 NOT NULL,
    reason_code character varying(50) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.inventory_consumption_log OWNER TO pos;

--
-- Name: invoices; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.invoices (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    order_id uuid NOT NULL,
    invoice_number character varying(64),
    amount_minor bigint DEFAULT 0 NOT NULL,
    tax_amount_minor bigint DEFAULT 0 NOT NULL,
    waived_off_minor bigint DEFAULT 0 NOT NULL,
    waived_off_reason text,
    reprint_count integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    seat_number integer DEFAULT 0 NOT NULL,
    invoice_no text,
    amount bigint DEFAULT 0,
    tax_amount bigint DEFAULT 0
);


ALTER TABLE public.invoices OWNER TO pos;

--
-- Name: item_availabilities; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.item_availabilities (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    menu_item_id uuid NOT NULL,
    is_stocked boolean DEFAULT true NOT NULL,
    stock_qty integer DEFAULT 100 NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.item_availabilities OWNER TO pos;

--
-- Name: item_availability; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.item_availability (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    item_id uuid NOT NULL,
    channel_id uuid NOT NULL,
    state public.availability_state DEFAULT 'UNSCHEDULED'::public.availability_state NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    stock_qty integer DEFAULT 100
);


ALTER TABLE public.item_availability OWNER TO pos;

--
-- Name: item_commissions; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.item_commissions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    menu_item_id uuid NOT NULL,
    commission_type text NOT NULL,
    commission_value numeric(10,2),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT item_commissions_commission_type_check CHECK ((commission_type = ANY (ARRAY['PERCENTAGE'::text, 'FLAT'::text])))
);


ALTER TABLE public.item_commissions OWNER TO pos;

--
-- Name: item_modifier_groups; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.item_modifier_groups (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    item_id uuid NOT NULL,
    group_id uuid NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.item_modifier_groups OWNER TO pos;

--
-- Name: item_prices; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.item_prices (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    price_list_id uuid NOT NULL,
    item_id uuid NOT NULL,
    variant_id uuid,
    price_minor bigint NOT NULL,
    currency character(3) DEFAULT 'INR'::bpchar NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    CONSTRAINT item_prices_price_minor_check CHECK ((price_minor >= 0))
);


ALTER TABLE public.item_prices OWNER TO pos;

--
-- Name: item_sales_summary; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.item_sales_summary (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    business_date date NOT NULL,
    item_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.item_sales_summary OWNER TO pos;

--
-- Name: item_variants; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.item_variants (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    item_id uuid NOT NULL,
    name text NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.item_variants OWNER TO pos;

--
-- Name: kot_items; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.kot_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    kot_ticket_id uuid NOT NULL,
    menu_item_id uuid NOT NULL,
    quantity integer DEFAULT 1,
    notes text,
    course text,
    served_at timestamp with time zone,
    order_item_id uuid,
    outlet_id uuid,
    seat_number integer,
    seat_id uuid
);


ALTER TABLE public.kot_items OWNER TO pos;

--
-- Name: kot_performance; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.kot_performance (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    business_date date NOT NULL,
    station_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.kot_performance OWNER TO pos;

--
-- Name: kot_status_history; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.kot_status_history (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    kot_ticket_id uuid NOT NULL,
    status text NOT NULL,
    reason_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.kot_status_history OWNER TO pos;

--
-- Name: kot_tickets; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.kot_tickets (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    order_id uuid NOT NULL,
    station_id uuid,
    ticket_number text NOT NULL,
    status text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    served_at timestamp with time zone,
    bill_printed_at timestamp with time zone
);


ALTER TABLE public.kot_tickets OWNER TO pos;

--
-- Name: ledger_entries; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.ledger_entries (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    source_type text NOT NULL,
    source_id text NOT NULL,
    account text NOT NULL,
    debit_minor bigint DEFAULT 0 NOT NULL,
    credit_minor bigint DEFAULT 0 NOT NULL,
    external_ref text,
    status text DEFAULT 'POSTED'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    posted_at timestamp with time zone
);


ALTER TABLE public.ledger_entries OWNER TO pos;

--
-- Name: loyalty_accounts; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.loyalty_accounts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    customer_id uuid NOT NULL,
    balance numeric DEFAULT 0 NOT NULL,
    tier text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.loyalty_accounts OWNER TO pos;

--
-- Name: marketing_campaigns; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.marketing_campaigns (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    name text NOT NULL,
    trigger_type text DEFAULT 'MANUAL'::text NOT NULL,
    segment_filter jsonb,
    discount_id uuid,
    message_template text NOT NULL,
    status text DEFAULT 'DRAFT'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid
);


ALTER TABLE public.marketing_campaigns OWNER TO pos;

--
-- Name: menu_categories; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.menu_categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    name text NOT NULL,
    online_display_name text,
    sort_order integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    description text
);


ALTER TABLE public.menu_categories OWNER TO pos;

--
-- Name: menu_item_availability; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.menu_item_availability (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    menu_item_id uuid NOT NULL,
    is_out_of_stock boolean DEFAULT false NOT NULL,
    oos_reason text,
    oos_since timestamp with time zone,
    auto_resume_at timestamp with time zone,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by uuid
);


ALTER TABLE public.menu_item_availability OWNER TO pos;

--
-- Name: menu_item_channel_status; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.menu_item_channel_status (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    menu_item_id uuid NOT NULL,
    channel public.order_channel NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by uuid
);


ALTER TABLE public.menu_item_channel_status OWNER TO pos;

--
-- Name: menu_items; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.menu_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    category_id uuid NOT NULL,
    name text NOT NULL,
    description text,
    is_veg boolean DEFAULT true NOT NULL,
    hsn_code text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    online_display_name text,
    tax_rate numeric(5,2) DEFAULT 5.00,
    price bigint DEFAULT 0,
    stock_qty integer DEFAULT 100,
    station_id uuid
);


ALTER TABLE public.menu_items OWNER TO pos;

--
-- Name: modifier_groups; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.modifier_groups (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    name text NOT NULL,
    min_select integer DEFAULT 0 NOT NULL,
    max_select integer DEFAULT 1 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    CONSTRAINT ck_modifier_groups_min_le_max CHECK ((min_select <= max_select))
);


ALTER TABLE public.modifier_groups OWNER TO pos;

--
-- Name: modifier_options; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.modifier_options (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    modifier_group_id uuid NOT NULL,
    name text NOT NULL,
    price bigint DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.modifier_options OWNER TO pos;

--
-- Name: modifiers; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.modifiers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    group_id uuid NOT NULL,
    name text NOT NULL,
    price_delta_minor bigint DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.modifiers OWNER TO pos;

--
-- Name: notifications; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.notifications (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    user_id uuid,
    type text NOT NULL,
    title text NOT NULL,
    message text NOT NULL,
    entity_type text,
    entity_id uuid,
    is_read boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.notifications OWNER TO pos;

--
-- Name: order_audit_log; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.order_audit_log (
    id bigint NOT NULL,
    outlet_id uuid NOT NULL,
    order_id uuid NOT NULL,
    actor_id uuid,
    approved_by uuid,
    action text NOT NULL,
    before_val jsonb,
    after_val jsonb,
    at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.order_audit_log OWNER TO pos;

--
-- Name: TABLE order_audit_log; Type: COMMENT; Schema: public; Owner: pos
--

COMMENT ON TABLE public.order_audit_log IS 'Append-only intent: TODO (future migration) add a trigger to block UPDATE/DELETE on this table at the DB level. Not implemented yet -- comment only.';


--
-- Name: order_audit_log_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.order_audit_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_audit_log_id_seq OWNER TO pos;

--
-- Name: order_audit_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.order_audit_log_id_seq OWNED BY public.order_audit_log.id;


--
-- Name: order_item_modifiers; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.order_item_modifiers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    order_item_id uuid NOT NULL,
    modifier_id uuid NOT NULL,
    modifier_name text NOT NULL,
    price_delta_minor bigint DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.order_item_modifiers OWNER TO pos;

--
-- Name: order_item_seat_shares; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.order_item_seat_shares (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    order_item_id uuid NOT NULL,
    seat_number integer NOT NULL,
    share_numerator integer NOT NULL,
    share_denominator integer NOT NULL,
    allocated_subtotal bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.order_item_seat_shares OWNER TO pos;

--
-- Name: order_items; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.order_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    order_id uuid NOT NULL,
    item_id uuid,
    variant_id uuid,
    item_name text,
    qty numeric DEFAULT 1,
    unit_price_minor bigint,
    total_price_minor bigint,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    seat_id uuid,
    split_group_id uuid,
    is_shared boolean DEFAULT false NOT NULL,
    origin_table_id text,
    is_voided boolean DEFAULT false,
    seat_number integer,
    course text,
    menu_item_id uuid,
    quantity integer DEFAULT 1,
    unit_price bigint DEFAULT 0,
    subtotal bigint DEFAULT 0,
    void_reason text,
    voided_by uuid,
    CONSTRAINT ck_order_items_qty_positive CHECK ((qty > (0)::numeric)),
    CONSTRAINT ck_order_items_unit_price_minor_nonneg CHECK ((unit_price_minor >= 0))
);


ALTER TABLE public.order_items OWNER TO pos;

--
-- Name: order_payments; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.order_payments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    order_id uuid NOT NULL,
    payment_id uuid NOT NULL,
    amount_minor bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    payment_group_id uuid,
    rounding_adjustment_minor bigint DEFAULT 0,
    method text DEFAULT 'CASH'::text,
    status text DEFAULT 'CAPTURED'::text,
    transaction_id text,
    seat_number integer,
    CONSTRAINT ck_order_payments_amount_minor_nonneg CHECK ((amount_minor >= 0))
);


ALTER TABLE public.order_payments OWNER TO pos;

--
-- Name: order_refunds; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.order_refunds (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    order_id uuid NOT NULL,
    refund_id uuid NOT NULL,
    amount_minor bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    CONSTRAINT ck_order_refunds_amount_minor_nonneg CHECK ((amount_minor >= 0))
);


ALTER TABLE public.order_refunds OWNER TO pos;

--
-- Name: order_seat_bills; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.order_seat_bills (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    order_id uuid NOT NULL,
    seat_number integer NOT NULL,
    split_group_id uuid,
    subtotal bigint DEFAULT 0 NOT NULL,
    discount_total bigint DEFAULT 0 NOT NULL,
    tax_total bigint DEFAULT 0 NOT NULL,
    service_charge_total bigint DEFAULT 0 NOT NULL,
    tip_total bigint DEFAULT 0 NOT NULL,
    grand_total bigint DEFAULT 0 NOT NULL,
    paid_total bigint DEFAULT 0 NOT NULL,
    status text DEFAULT 'OPEN'::text NOT NULL,
    settled_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.order_seat_bills OWNER TO pos;

--
-- Name: order_status_history; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.order_status_history (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    order_id uuid NOT NULL,
    from_status public.order_status,
    to_status public.order_status,
    reason_code text,
    actor_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    status text,
    notes text,
    created_by text
);


ALTER TABLE public.order_status_history OWNER TO pos;

--
-- Name: orders; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    order_number text NOT NULL,
    type text DEFAULT 'DINE_IN'::text,
    status text DEFAULT 'DRAFT'::public.order_status NOT NULL,
    business_date date DEFAULT CURRENT_DATE,
    subtotal_minor bigint DEFAULT 0 NOT NULL,
    total_minor bigint DEFAULT 0 NOT NULL,
    currency character(3) DEFAULT 'INR'::bpchar NOT NULL,
    customer_id uuid,
    table_number text,
    delivery_address_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    settled_at timestamp with time zone,
    scheduled_fire_at timestamp with time zone,
    promised_at timestamp with time zone,
    deposit_minor bigint DEFAULT 0,
    advance_status character varying(30),
    tip_total_minor bigint DEFAULT 0 NOT NULL,
    service_charge_total_minor bigint DEFAULT 0 NOT NULL,
    merge_group_id uuid,
    covers integer,
    split_mode text,
    merged_into_order_id uuid,
    round_off_minor bigint DEFAULT 0 NOT NULL,
    channel text,
    external_order_id text,
    rider_name text,
    rider_phone text,
    received_at timestamp with time zone,
    accepted_at timestamp with time zone,
    customer_otp text,
    grand_total bigint DEFAULT 0,
    subtotal bigint DEFAULT 0,
    terminal_number text DEFAULT 'T-01'::text,
    order_type text DEFAULT 'DINE_IN'::text,
    dining_table_id uuid,
    discount_total bigint DEFAULT 0,
    tax_total bigint DEFAULT 0,
    service_charge_total bigint DEFAULT 0,
    tip_total bigint DEFAULT 0,
    idempotency_key text,
    waiter_id uuid,
    CONSTRAINT ck_orders_service_charge_total_minor_nonneg CHECK ((service_charge_total_minor >= 0)),
    CONSTRAINT ck_orders_subtotal_minor_nonneg CHECK ((subtotal_minor >= 0)),
    CONSTRAINT ck_orders_tip_total_minor_nonneg CHECK ((tip_total_minor >= 0)),
    CONSTRAINT ck_orders_total_minor_nonneg CHECK ((total_minor >= 0))
);


ALTER TABLE public.orders OWNER TO pos;

--
-- Name: organizations; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.organizations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    legal_name text,
    tax_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    tax_number text
);


ALTER TABLE public.organizations OWNER TO pos;

--
-- Name: outbound_events; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.outbound_events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    channel_account_id uuid NOT NULL,
    payload jsonb NOT NULL,
    attempt integer DEFAULT 0 NOT NULL,
    status public.sync_status DEFAULT 'PENDING'::public.sync_status NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.outbound_events OWNER TO pos;

--
-- Name: outbox_events; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.outbox_events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    event_type character varying(100) NOT NULL,
    payload jsonb NOT NULL,
    status character varying(20) DEFAULT 'PENDING'::character varying NOT NULL,
    attempts integer DEFAULT 0 NOT NULL,
    max_attempts integer DEFAULT 5 NOT NULL,
    last_error text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    processed_at timestamp with time zone
);


ALTER TABLE public.outbox_events OWNER TO pos;

--
-- Name: outlet_billing_settings; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.outlet_billing_settings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    bill_prefix text,
    kot_prefix text,
    round_off_enabled boolean DEFAULT true NOT NULL,
    round_off_nearest numeric(4,2) DEFAULT 1.00 NOT NULL,
    service_charge_enabled boolean DEFAULT false NOT NULL,
    service_charge_percent numeric(6,3) DEFAULT 0 NOT NULL,
    allow_discount_without_approval boolean DEFAULT false NOT NULL,
    max_discount_percent numeric(6,3) DEFAULT 100 NOT NULL,
    require_customer_phone boolean DEFAULT false NOT NULL,
    require_otp_for_online boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    extended_settings jsonb DEFAULT '{}'::jsonb NOT NULL
);


ALTER TABLE public.outlet_billing_settings OWNER TO pos;

--
-- Name: outlet_print_settings; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.outlet_print_settings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    printer_name text,
    paper_width_mm integer DEFAULT 80 NOT NULL,
    print_logo boolean DEFAULT true NOT NULL,
    print_gstin boolean DEFAULT true NOT NULL,
    print_fssai_number boolean DEFAULT true NOT NULL,
    print_customer_details boolean DEFAULT true NOT NULL,
    auto_print_kot_on_place boolean DEFAULT true NOT NULL,
    auto_print_bill_on_settle boolean DEFAULT true NOT NULL,
    kot_copies integer DEFAULT 1 NOT NULL,
    bill_copies integer DEFAULT 1 NOT NULL,
    footer_message text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    extended_settings jsonb DEFAULT '{}'::jsonb NOT NULL,
    CONSTRAINT chk_outlet_print_settings_copies_positive CHECK (((kot_copies > 0) AND (bill_copies > 0)))
);


ALTER TABLE public.outlet_print_settings OWNER TO pos;

--
-- Name: outlet_status; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.outlet_status (
    outlet_id uuid NOT NULL,
    is_online boolean DEFAULT true NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by uuid,
    dine_in_active boolean DEFAULT true NOT NULL,
    delivery_active boolean DEFAULT true NOT NULL,
    takeaway_active boolean DEFAULT true NOT NULL
);


ALTER TABLE public.outlet_status OWNER TO pos;

--
-- Name: outlets; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.outlets (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    code text NOT NULL,
    name text NOT NULL,
    timezone text DEFAULT 'Asia/Kolkata'::text NOT NULL,
    currency character(3) DEFAULT 'INR'::bpchar NOT NULL,
    day_start_time text DEFAULT '05:00:00'::time without time zone NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    loyalty_paise_per_point bigint,
    phone text,
    email text,
    logo_url text,
    last_menu_sync_at timestamp with time zone,
    address text,
    fssai_number text,
    upi_vpa text,
    status text
);


ALTER TABLE public.outlets OWNER TO pos;

--
-- Name: payment_summary; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.payment_summary (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    business_date date NOT NULL,
    method text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.payment_summary OWNER TO pos;

--
-- Name: payment_type_master; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.payment_type_master (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    label text NOT NULL,
    is_online boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.payment_type_master OWNER TO pos;

--
-- Name: payments; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.payments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid,
    order_id uuid,
    amount bigint DEFAULT 0 NOT NULL,
    method text DEFAULT 'CASH'::text NOT NULL,
    status text DEFAULT 'CAPTURED'::text NOT NULL,
    transaction_id text,
    idempotency_key text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    seat_id uuid,
    order_seat_bill_id uuid,
    seat_number integer
);


ALTER TABLE public.payments OWNER TO pos;

--
-- Name: permissions; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.permissions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code text NOT NULL,
    module text NOT NULL,
    description text,
    created_by uuid,
    updated_by uuid,
    action text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.permissions OWNER TO pos;

--
-- Name: petty_cash_ledger; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.petty_cash_ledger (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    amount_minor bigint NOT NULL,
    category character varying(100) NOT NULL,
    description text NOT NULL,
    recorded_by uuid NOT NULL,
    cash_drawer_session_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    paid_to character varying(255)
);


ALTER TABLE public.petty_cash_ledger OWNER TO pos;

--
-- Name: physical_menu_files; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.physical_menu_files (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    file_name text NOT NULL,
    file_url text NOT NULL,
    uploaded_by_user_id uuid,
    uploaded_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.physical_menu_files OWNER TO pos;

--
-- Name: price_lists; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.price_lists (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    channel_id uuid,
    name text NOT NULL,
    effective_from timestamp with time zone NOT NULL,
    effective_to timestamp with time zone,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.price_lists OWNER TO pos;

--
-- Name: purchase_order_items; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.purchase_order_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    po_id uuid NOT NULL,
    ingredient_id uuid NOT NULL,
    quantity numeric(12,3) NOT NULL,
    unit_price_minor bigint NOT NULL,
    total_minor bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    received_qty numeric(12,3) DEFAULT 0 NOT NULL
);


ALTER TABLE public.purchase_order_items OWNER TO pos;

--
-- Name: purchase_orders; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.purchase_orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    vendor_id uuid NOT NULL,
    po_number character varying(50) NOT NULL,
    total_amount_minor bigint DEFAULT 0 NOT NULL,
    status character varying(50) DEFAULT 'DRAFT'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.purchase_orders OWNER TO pos;

--
-- Name: recipe_ingredients; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.recipe_ingredients (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    recipe_id uuid NOT NULL,
    ingredient_id uuid NOT NULL,
    quantity numeric(12,3) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    yield_percent numeric DEFAULT 100,
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.recipe_ingredients OWNER TO pos;

--
-- Name: recipes; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.recipes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    menu_item_id uuid,
    name character varying(255) DEFAULT ''::character varying,
    yield_portions numeric(8,2) DEFAULT 1 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    version integer DEFAULT 1 NOT NULL,
    effective_from timestamp with time zone
);


ALTER TABLE public.recipes OWNER TO pos;

--
-- Name: restaurant_tables; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.restaurant_tables (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    zone text,
    table_no text NOT NULL,
    capacity integer,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.restaurant_tables OWNER TO pos;

--
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.role_permissions (
    role_id uuid NOT NULL,
    permission_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.role_permissions OWNER TO pos;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.roles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code text NOT NULL,
    name text NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.roles OWNER TO pos;

--
-- Name: sales_returns; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.sales_returns (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    order_id uuid NOT NULL,
    order_item_id uuid,
    qty numeric(10,2) NOT NULL,
    amount numeric(12,2) NOT NULL,
    reason text,
    refund_method text,
    approved_by uuid,
    returned_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_sales_returns_qty_amount_nonneg CHECK (((qty > (0)::numeric) AND (amount >= (0)::numeric)))
);


ALTER TABLE public.sales_returns OWNER TO pos;

--
-- Name: TABLE sales_returns; Type: COMMENT; Schema: public; Owner: pos
--

COMMENT ON TABLE public.sales_returns IS 'PROVISIONAL SCHEMA -- pending DEC-014 screenshot re-capture. Columns inferred, not confirmed. Do not treat as final.';


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.schema_migrations (
    version text NOT NULL,
    applied_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO pos;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    refresh_token_hash text,
    ip_address inet,
    user_agent text,
    expires_at timestamp with time zone NOT NULL,
    revoked_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    outlet_id uuid,
    token_hash text,
    updated_at timestamp with time zone DEFAULT now(),
    last_seen_at timestamp with time zone
);


ALTER TABLE public.sessions OWNER TO pos;

--
-- Name: special_notes; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.special_notes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    text text NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.special_notes OWNER TO pos;

--
-- Name: stations; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.stations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    name text NOT NULL,
    printer_ip text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    sla_warning_seconds integer DEFAULT 300,
    sla_breach_seconds integer DEFAULT 600
);


ALTER TABLE public.stations OWNER TO pos;

--
-- Name: sync_jobs; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.sync_jobs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    channel_account_id uuid NOT NULL,
    entity text NOT NULL,
    entity_id uuid,
    version integer DEFAULT 1 NOT NULL,
    status public.sync_status DEFAULT 'PENDING'::public.sync_status NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.sync_jobs OWNER TO pos;

--
-- Name: sync_state; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.sync_state (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    device_id text NOT NULL,
    device_role text DEFAULT 'client'::text NOT NULL,
    last_synced_at timestamp with time zone,
    last_sync_cursor text,
    is_online boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.sync_state OWNER TO pos;

--
-- Name: table_merge_groups; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.table_merge_groups (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    primary_table_id uuid NOT NULL,
    status public.table_merge_status DEFAULT 'ACTIVE'::public.table_merge_status NOT NULL,
    total_capacity integer,
    covers integer,
    opened_at timestamp with time zone DEFAULT now() NOT NULL,
    closed_at timestamp with time zone,
    created_by uuid,
    reason text
);


ALTER TABLE public.table_merge_groups OWNER TO pos;

--
-- Name: table_merge_members; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.table_merge_members (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    merge_group_id uuid NOT NULL,
    dining_table_id uuid NOT NULL,
    is_primary boolean DEFAULT false NOT NULL,
    joined_at timestamp with time zone DEFAULT now() NOT NULL,
    left_at timestamp with time zone
);


ALTER TABLE public.table_merge_members OWNER TO pos;

--
-- Name: table_operation_idempotency; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.table_operation_idempotency (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    idempotency_key text NOT NULL,
    endpoint text NOT NULL,
    response_json jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.table_operation_idempotency OWNER TO pos;

--
-- Name: table_seats; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.table_seats (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    dining_table_id uuid NOT NULL,
    seat_number integer NOT NULL,
    label text,
    status public.seat_status DEFAULT 'EMPTY'::public.seat_status NOT NULL,
    guest_name text
);


ALTER TABLE public.table_seats OWNER TO pos;

--
-- Name: table_sessions; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.table_sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    table_id uuid NOT NULL,
    order_id uuid,
    status public.order_status DEFAULT 'open'::public.order_status NOT NULL,
    kot_sent boolean DEFAULT false NOT NULL,
    covers integer,
    opened_at timestamp with time zone DEFAULT now() NOT NULL,
    closed_at timestamp with time zone,
    opened_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.table_sessions OWNER TO pos;

--
-- Name: TABLE table_sessions; Type: COMMENT; Schema: public; Owner: pos
--

COMMENT ON TABLE public.table_sessions IS 'table_id -> restaurant_tables uses ON DELETE CASCADE: deleting a physical table is considered safe to cascade to its historical sessions in this schema; reconsider if session history must survive table deletion.';


--
-- Name: COLUMN table_sessions.order_id; Type: COMMENT; Schema: public; Owner: pos
--

COMMENT ON COLUMN public.table_sessions.order_id IS 'Nullable FK to orders.id, added via ALTER in 0009 once orders exists (avoids forward reference).';


--
-- Name: tax_channel_rules; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.tax_channel_rules (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    tax_id uuid NOT NULL,
    channel public.order_channel NOT NULL,
    mode public.tax_mode NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.tax_channel_rules OWNER TO pos;

--
-- Name: TABLE tax_channel_rules; Type: COMMENT; Schema: public; Owner: pos
--

COMMENT ON TABLE public.tax_channel_rules IS 'Scopes a tax row to a specific sales channel and computation mode. Multiple rules per outlet/channel are allowed (e.g. CGST + SGST both apply to dine_in).';


--
-- Name: taxes; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.taxes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    name text NOT NULL,
    rate_percent numeric(6,3) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_taxes_rate_nonneg CHECK ((rate_percent >= (0)::numeric))
);


ALTER TABLE public.taxes OWNER TO pos;

--
-- Name: terminals; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.terminals (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    terminal_number text NOT NULL,
    name text NOT NULL,
    is_active boolean DEFAULT true,
    created_by uuid,
    updated_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.terminals OWNER TO pos;

--
-- Name: user_quick_links; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.user_quick_links (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    label text NOT NULL,
    href text NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.user_quick_links OWNER TO pos;

--
-- Name: user_report_preferences; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.user_report_preferences (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    report_key text NOT NULL,
    column_config jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.user_report_preferences OWNER TO pos;

--
-- Name: TABLE user_report_preferences; Type: COMMENT; Schema: public; Owner: pos
--

COMMENT ON TABLE public.user_report_preferences IS 'ON DELETE CASCADE on user_id: a purely per-user UI preference, safe to discard when the user is deleted.';


--
-- Name: COLUMN user_report_preferences.column_config; Type: COMMENT; Schema: public; Owner: pos
--

COMMENT ON COLUMN public.user_report_preferences.column_config IS 'UI-only preference data (column order/visibility/widths). jsonb is acceptable here since it is not business/financial data and is never queried by its internal fields.';


--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.user_roles (
    user_id uuid NOT NULL,
    role_id uuid NOT NULL,
    outlet_id uuid,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    granted_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    created_by uuid
);


ALTER TABLE public.user_roles OWNER TO pos;

--
-- Name: users; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email public.citext,
    phone text,
    full_name text DEFAULT ''::text,
    password_hash text NOT NULL,
    mfa_enabled boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    first_name text,
    last_name text,
    pin_hash text
);


ALTER TABLE public.users OWNER TO pos;

--
-- Name: vendors; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.vendors (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    contact_name character varying(255),
    contact_phone character varying(50),
    contact_email character varying(255),
    payment_terms character varying(255),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    phone text,
    email text,
    tax_number text,
    contact_person text,
    address text
);


ALTER TABLE public.vendors OWNER TO pos;

--
-- Name: waiter_shift_handovers; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.waiter_shift_handovers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outlet_id uuid NOT NULL,
    waiter_id uuid NOT NULL,
    waiter_name text NOT NULL,
    business_date date NOT NULL,
    actual_cash_counted_minor bigint DEFAULT 0 NOT NULL,
    opening_float_minor bigint DEFAULT 0 NOT NULL,
    net_tip_payout_minor bigint DEFAULT 0 NOT NULL,
    digital_tips_minor bigint DEFAULT 0 NOT NULL,
    service_charge_minor bigint DEFAULT 0 NOT NULL,
    cash_sales_minor bigint DEFAULT 0 NOT NULL,
    manager_notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT ck_handover_cash_nonneg CHECK ((actual_cash_counted_minor >= 0)),
    CONSTRAINT ck_handover_float_nonneg CHECK ((opening_float_minor >= 0)),
    CONSTRAINT ck_handover_tips_nonneg CHECK ((net_tip_payout_minor >= 0))
);


ALTER TABLE public.waiter_shift_handovers OWNER TO pos;

--
-- Name: access_logs_default; Type: TABLE ATTACH; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.access_logs ATTACH PARTITION public.access_logs_default DEFAULT;


--
-- Name: access_logs_y2026m08; Type: TABLE ATTACH; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.access_logs ATTACH PARTITION public.access_logs_y2026m08 FOR VALUES FROM ('2026-08-01 00:00:00+05:30') TO ('2026-09-01 00:00:00+05:30');


--
-- Name: audit_logs_default; Type: TABLE ATTACH; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.audit_logs ATTACH PARTITION public.audit_logs_default DEFAULT;


--
-- Name: audit_logs_y2026m08; Type: TABLE ATTACH; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.audit_logs ATTACH PARTITION public.audit_logs_y2026m08 FOR VALUES FROM ('2026-08-01 00:00:00+05:30') TO ('2026-09-01 00:00:00+05:30');


--
-- Name: configuration_changes_default; Type: TABLE ATTACH; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.configuration_changes ATTACH PARTITION public.configuration_changes_default DEFAULT;


--
-- Name: configuration_changes_y2026m08; Type: TABLE ATTACH; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.configuration_changes ATTACH PARTITION public.configuration_changes_y2026m08 FOR VALUES FROM ('2026-08-01 00:00:00+05:30') TO ('2026-09-01 00:00:00+05:30');


--
-- Name: backup_jobs id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.backup_jobs ALTER COLUMN id SET DEFAULT nextval('public.backup_jobs_id_seq'::regclass);


--
-- Name: channel_sync_log id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.channel_sync_log ALTER COLUMN id SET DEFAULT nextval('public.channel_sync_log_id_seq'::regclass);


--
-- Name: order_audit_log id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_audit_log ALTER COLUMN id SET DEFAULT nextval('public.order_audit_log_id_seq'::regclass);


--
-- Data for Name: access_logs_default; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.access_logs_default (id, outlet_id, user_id, endpoint, ip_address, status_code, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: access_logs_y2026m08; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.access_logs_y2026m08 (id, outlet_id, user_id, endpoint, ip_address, status_code, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: addon_commissions; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.addon_commissions (id, outlet_id, addon_item_id, commission_type, commission_value, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: agent_telemetry; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.agent_telemetry (id, name, role, status, domain, port, latency_ms, health, current_task, metrics, assigned_files, updated_at) FROM stdin;
agent-orchestrator	Orchestrator Agent	SYSTEM_COORDINATOR	ONLINE	Cross-System Workflow Coordination & Port Management (4001, 4444, 5432)	4001	1	Passing	Supervising backend, frontend and persistence processes	{"dbPort": 5432, "apiPort": 4001, "posPort": 4444, "supervisor": "active"}	["scripts/startup.ps1", "scripts/shutdown.ps1", "scripts/status.ts", "Start_PetPooja.bat"]	2026-09-05 13:04:21.407615+05:30
agent-a2a	A2A Coordination Agent	A2A_COORDINATOR	ONLINE	Inter-Agent Protocol, State Sync & Admin Hub Telemetry	4001	2	Passing	Routing inter-agent WebSocket topics and aggregating live telemetry	{"activeAgents": 8, "syncChannels": ["HTTP", "WS", "REGISTRY"], "protocolVersion": "2.0"}	["agents/a2a-agent.md", "agents/AGENT_REGISTRY.json", "agents/task-board.json", "apps/api/src/routes/admin.ts", "apps/pos-web/pages/admin.tsx"]	2026-09-05 13:04:21.407615+05:30
agent-frontend	Frontend UI Agent	UI_ENGINEER	ONLINE	POS Web UI (Port 4444) & Admin Management Consoles	4444	3	Passing	Serving KapMeta POS shell, touch billing, KDS board & executive admin	{"posPort": 4444, "touchSupport": true, "bundleOptimized": true}	["apps/pos-web/pages/*", "apps/pos-web/components/*", "apps/pos-web/lib/auth.ts"]	2026-09-05 13:04:21.407615+05:30
agent-backend	Backend API Agent	BACKEND_ENGINEER	ONLINE	API Gateway (Port 4001), Services & Event Bus	4001	2	Passing	Routing HTTP endpoints, JWT claim verification, and event subscriptions	{"apiPort": 4001, "jwtScoping": "outlet_id", "activeRoutes": 18}	["apps/api/src/index.ts", "apps/api/src/routes/*", "services/*"]	2026-09-05 13:04:21.407615+05:30
agent-database	Database Persistence Agent	DBA_ENGINEER	ONLINE	PostgreSQL (Port 5432) & Prisma Multi-Tenant Schema	5432	1	Passing	Maintaining multi-tenant schema, seed tools, and backup parity	{"dbPort": 5432, "poolConnections": 10, "minorUnitStandard": "BIGINT paise"}	["kapmeta/schema.prisma", "scripts/db-migrate.js", "scripts/seed-dynamic-data.ts"]	2026-09-05 13:04:21.407615+05:30
agent-integration	Integration Hub Agent	INTEGRATION_ENGINEER	ONLINE	Online Aggregators (Swiggy/Zomato), Payments & Thermal Printers	4001	4	Passing	Handling HMAC webhooks, idempotent ingestion, and DLQ retries	{"webhookActive": true, "supportedChannels": ["SWIGGY", "ZOMATO"]}	["services/integration-hub/*", "services/integration/*"]	2026-09-05 13:04:21.407615+05:30
agent-qa	QA & Verification Agent	TEST_ENGINEER	ONLINE	Unit Tests, Contract Validation & E2E Simulation	4001	5	Passing	Running vitest suites, type validation, and pilot simulation drills	{"pilotDrills": "ENABLED", "testsPassing": 55, "e2eValidation": true}	["tests/*", "scripts/pilot-e2e-simulation.ts", "vitest.config.ts"]	2026-09-05 13:04:21.407615+05:30
agent-sre	SRE & Diagnostics Agent	SRE_ENGINEER	ONLINE	Log Management, Process Monitoring & Diagnostics	4001	2	Passing	Monitoring logs/ directory, service heartbeats, and error traces	{"logScanner": "active", "healthChecksPassing": true}	["logs/*", "scripts/status.ts"]	2026-09-05 13:04:21.407615+05:30
\.


--
-- Data for Name: areas; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.areas (id, outlet_id, name, sort_order, is_active, created_at, updated_at) FROM stdin;
d25e7785-37ed-4e88-8fa8-90aeb7b51dcc	67315042-c687-4cbb-b45a-f4ea4efc199f	AC	1	t	2026-09-03 12:29:17.285432+05:30	2026-09-03 12:29:17.285432+05:30
489fb172-f3ca-423e-a849-ddebcc989f72	67315042-c687-4cbb-b45a-f4ea4efc199f	Non AC	2	t	2026-09-03 12:29:17.29417+05:30	2026-09-03 12:29:17.29417+05:30
7b3f6ac3-16c9-4e5c-8bb3-b021df77c442	67315042-c687-4cbb-b45a-f4ea4efc199f	Outdoor Garden	3	t	2026-09-03 12:29:17.295308+05:30	2026-09-03 12:29:17.295308+05:30
1bf7ea56-a656-4b1b-866e-19590a889aa4	67315042-c687-4cbb-b45a-f4ea4efc199f	Terrace Lounge	4	t	2026-09-03 12:29:17.296396+05:30	2026-09-03 12:29:17.296396+05:30
3080fcd5-dbc0-4ef7-aeb5-dae4b7e76b31	67315042-c687-4cbb-b45a-f4ea4efc199f	Family Section	5	t	2026-09-03 12:29:17.297226+05:30	2026-09-03 12:29:17.297226+05:30
2520dd1d-9535-4a03-ae3a-ec8b9cd1573c	67315042-c687-4cbb-b45a-f4ea4efc199f	Other	6	t	2026-09-03 12:29:17.298014+05:30	2026-09-03 12:29:17.298014+05:30
\.


--
-- Data for Name: audit_logs_default; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.audit_logs_default (id, outlet_id, entity_type, entity_id, action, actor_id, before_state, after_state, created_at, updated_at, created_by, updated_by, user_id, reason_code, approver_user_id, ip_address) FROM stdin;
3616c098-2c83-431e-8542-c22781955a5e	11111111-1111-1111-1111-111111111111	ORDER	e7eccfdc-02d5-470f-869b-da665f7dcb2e	CREATE	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	{"items": [{"id": "025735c2-f199-4819-a694-73b1b678ed09", "quantity": 1, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}], "originalAction": "ORDER_ITEMS_ADDED"}	2026-09-04 00:02:44.822+05:30	2026-09-04 00:02:44.743219+05:30	\N	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N
d3a356d8-3ffb-47e6-a49b-6bab6668b49c	11111111-1111-1111-1111-111111111111	PAYMENT	589efb55-2a0d-4c79-8ba3-d5677f01c155	CREATE	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	{"method": "CASH", "orderId": "e7eccfdc-02d5-470f-869b-da665f7dcb2e", "amountMinor": "37250", "originalAction": "PAYMENT_RECORDED"}	2026-09-04 00:03:15.375+05:30	2026-09-04 00:03:15.358964+05:30	\N	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N
987b9612-a371-4c34-b9a6-3a05ee239f57	11111111-1111-1111-1111-111111111111	ORDER	0f621958-d193-4d99-b6ef-037fcea9cd0a	CREATE	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	{"items": [{"id": "ffe3d2a6-2bcf-4f51-96b0-958fc529e51e", "quantity": 1, "menuItemId": "9e27f8db-5ca3-4d7f-97d4-aa3d87642452"}], "originalAction": "ORDER_ITEMS_ADDED"}	2026-09-04 00:05:57.373+05:30	2026-09-04 00:05:57.362581+05:30	\N	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N
595978c5-ff38-400a-a264-7f6f39d64740	11111111-1111-1111-1111-111111111111	PAYMENT	1a3d604c-edec-4c9a-87ab-648a8bbf133c	CREATE	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	{"method": "CASH", "orderId": "0f621958-d193-4d99-b6ef-037fcea9cd0a", "amountMinor": "16800", "originalAction": "PAYMENT_RECORDED"}	2026-09-04 00:06:34.697+05:30	2026-09-04 00:06:34.668944+05:30	\N	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N
31e61c13-c0e6-499a-9eaf-ecb742d7aa86	11111111-1111-1111-1111-111111111111	PAYMENT	9c5e5749-9c4f-4e49-9355-80afe225f04e	CREATE	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	{"method": "CASH", "orderId": "ece12171-62db-4f53-ba97-d5e93e06f733", "amountMinor": "15750", "originalAction": "PAYMENT_RECORDED"}	2026-09-04 01:14:43.215+05:30	2026-09-04 01:14:43.203511+05:30	\N	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N
34483ac2-598c-4df3-8e51-e583eb13abdf	11111111-1111-1111-1111-111111111111	PAYMENT	923c400d-2aa6-40e9-bff1-a6777d7c075e	CREATE	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	{"method": "CASH", "orderId": "b5177d27-2e27-4abd-8296-83a748730b2c", "amountMinor": "16800", "originalAction": "PAYMENT_RECORDED"}	2026-09-04 01:19:56.908+05:30	2026-09-04 01:19:56.897288+05:30	\N	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N
2de464cf-3284-4019-8611-7564b42e4b2f	11111111-1111-1111-1111-111111111111	ORDER	a00d57c3-c01d-49d0-9166-45e9f7e22497	CREATE	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	{"items": [{"id": "a09767f3-e815-483d-aff9-8d334baff511", "quantity": 1, "menuItemId": "094b3d75-f087-476a-863b-a70da76e2365"}], "originalAction": "ORDER_ITEMS_ADDED"}	2026-09-05 13:19:55.644+05:30	2026-09-05 13:19:55.615319+05:30	\N	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N
cb2c785c-ae36-4005-bb22-e7e9985f2b01	11111111-1111-1111-1111-111111111111	PAYMENT	a23c5ed2-25df-4ffd-a6a0-e8d8d6729f43	CREATE	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	{"method": "CASH", "orderId": "a00d57c3-c01d-49d0-9166-45e9f7e22497", "amountMinor": "47250", "originalAction": "PAYMENT_RECORDED"}	2026-09-05 13:22:05.601+05:30	2026-09-05 13:22:05.5958+05:30	\N	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N
09aa00e6-23a1-452e-aaff-1f9430e6324a	11111111-1111-1111-1111-111111111111	PAYMENT	2feeaab6-7543-447d-a565-a8104b9eb3eb	CREATE	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	{"method": "CASH", "orderId": "0f3580d0-cceb-4289-99f8-5ffdf1669b18", "amountMinor": "5250", "originalAction": "PAYMENT_RECORDED"}	2026-09-05 15:10:12.795+05:30	2026-09-05 15:10:12.785772+05:30	\N	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N
ff7d3f40-3eb1-495d-8fea-70e8e81d64b4	67315042-c687-4cbb-b45a-f4ea4efc199f	PAYMENT	ffcfae6a-f1e2-418d-94fa-cb1c38179fd3	CREATE	918df673-2606-403a-9fad-1c54870d1fce	\N	{"method": "CASH", "orderId": "5b433b06-af43-4f62-8a6b-e2ca1e0bfa88", "amountMinor": "35700", "originalAction": "PAYMENT_RECORDED"}	2026-09-05 16:45:42.142+05:30	2026-09-05 16:45:42.136429+05:30	\N	\N	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N
29f315b3-8e09-43a4-ae86-db347ad27f71	11111111-1111-1111-1111-111111111111	PAYMENT	2e8207de-394f-40ad-bd95-84b3b2998a9b	CREATE	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	{"method": "CASH", "orderId": "7a369854-faf1-4af3-8378-8b939249c434", "amountMinor": "6825", "originalAction": "PAYMENT_RECORDED"}	2026-09-05 16:51:32.869+05:30	2026-09-05 16:51:32.86469+05:30	\N	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N
1eaea50f-33f7-48d5-92cc-34ba254243a7	11111111-1111-1111-1111-111111111111	DINING_TABLE	bb01f08e-7a9d-43b3-acce-be35218b3f27	CREATE	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	{"reason": null, "memberIds": ["1bb0a59d-079d-4406-8bd9-0fd2f4a7668e", "bb01f08e-7a9d-43b3-acce-be35218b3f27"], "mergeGroupId": "afe6e795-9bf1-4d7b-93ba-24db0c8ad017", "targetOrderId": null, "targetTableId": "bb01f08e-7a9d-43b3-acce-be35218b3f27", "originalAction": "TABLE_MERGE", "sourceTableIds": ["1bb0a59d-079d-4406-8bd9-0fd2f4a7668e"], "mergedOrdersCount": 0}	2026-09-05 16:53:25.393+05:30	2026-09-05 16:53:25.395516+05:30	\N	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N
eb7e5a4c-81b6-430d-8c99-161e07d0a386	11111111-1111-1111-1111-111111111111	DINING_TABLE	1bb0a59d-079d-4406-8bd9-0fd2f4a7668e	CREATE	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	{"reason": null, "memberIds": ["bb01f08e-7a9d-43b3-acce-be35218b3f27", "1bb0a59d-079d-4406-8bd9-0fd2f4a7668e"], "mergeGroupId": "afe6e795-9bf1-4d7b-93ba-24db0c8ad017", "targetOrderId": null, "targetTableId": "1bb0a59d-079d-4406-8bd9-0fd2f4a7668e", "originalAction": "TABLE_MERGE", "sourceTableIds": ["bb01f08e-7a9d-43b3-acce-be35218b3f27"], "mergedOrdersCount": 0}	2026-09-05 16:54:07.579+05:30	2026-09-05 16:54:07.579697+05:30	\N	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N
2a170479-89ed-4756-acf6-7824c05add43	11111111-1111-1111-1111-111111111111	DINING_TABLE	1bb0a59d-079d-4406-8bd9-0fd2f4a7668e	CREATE	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	{"reason": null, "memberIds": ["bb01f08e-7a9d-43b3-acce-be35218b3f27", "1bb0a59d-079d-4406-8bd9-0fd2f4a7668e"], "mergeGroupId": "afe6e795-9bf1-4d7b-93ba-24db0c8ad017", "targetOrderId": null, "targetTableId": "1bb0a59d-079d-4406-8bd9-0fd2f4a7668e", "originalAction": "TABLE_MERGE", "sourceTableIds": ["bb01f08e-7a9d-43b3-acce-be35218b3f27"], "mergedOrdersCount": 0}	2026-09-05 16:54:15.11+05:30	2026-09-05 16:54:15.110427+05:30	\N	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N
a08992da-4a64-4d2a-86e8-9edb940391d5	11111111-1111-1111-1111-111111111111	DINING_TABLE	1bb0a59d-079d-4406-8bd9-0fd2f4a7668e	CREATE	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	{"reason": null, "memberIds": ["bb01f08e-7a9d-43b3-acce-be35218b3f27", "1bb0a59d-079d-4406-8bd9-0fd2f4a7668e"], "mergeGroupId": "afe6e795-9bf1-4d7b-93ba-24db0c8ad017", "targetOrderId": null, "targetTableId": "1bb0a59d-079d-4406-8bd9-0fd2f4a7668e", "originalAction": "TABLE_MERGE", "sourceTableIds": ["bb01f08e-7a9d-43b3-acce-be35218b3f27"], "mergedOrdersCount": 0}	2026-09-05 17:03:37.183+05:30	2026-09-05 17:03:37.184023+05:30	\N	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N
2b35d54a-fc84-45a8-b5b8-a52566b7dcb2	11111111-1111-1111-1111-111111111111	PAYMENT	cd2961e5-434c-4fd7-a178-659c524137f0	CREATE	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	{"method": "CASH", "orderId": "82e2a068-a74a-4e18-89fe-7a423f5b243f", "amountMinor": "7350", "originalAction": "PAYMENT_RECORDED"}	2026-09-05 17:14:44.757+05:30	2026-09-05 17:14:44.749884+05:30	\N	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N
5ab89b77-ff6a-4f31-8ffd-55860f7c0a82	11111111-1111-1111-1111-111111111111	PAYMENT	1761086d-1e14-4acd-8f1c-a5cbcf3e80d8	CREATE	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	{"method": "CASH", "orderId": "71ef893c-0ccc-439d-bc3e-0a248037303b", "amountMinor": "10904", "originalAction": "PAYMENT_RECORDED"}	2026-09-08 11:01:05.79+05:30	2026-09-08 11:01:05.772197+05:30	\N	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N
78a7699c-ee10-426c-9e00-22f3068e4d65	11111111-1111-1111-1111-111111111111	ORDER	1085cebe-ebf0-4804-83f3-aae6d0d4a7c9	CREATE	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	{"items": [{"id": "9c5395eb-db1c-48f8-803a-f011a251c77a", "quantity": 2, "menuItemId": "094b3d75-f087-476a-863b-a70da76e2365"}], "originalAction": "ORDER_ITEMS_ADDED"}	2026-09-08 11:09:01.376+05:30	2026-09-08 11:09:01.355061+05:30	\N	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N
e302eceb-da2c-45dd-a861-77c0deb55a04	11111111-1111-1111-1111-111111111111	PAYMENT	e4630b40-86f0-4b79-8e21-9053a0db4ab3	CREATE	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	{"method": "CASH", "orderId": "1085cebe-ebf0-4804-83f3-aae6d0d4a7c9", "amountMinor": "77075", "originalAction": "PAYMENT_RECORDED"}	2026-09-08 11:10:47.824+05:30	2026-09-08 11:10:47.797329+05:30	\N	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N
25344907-6edd-424d-8eec-47a837321373	11111111-1111-1111-1111-111111111111	ORDER	e7d4d6cf-4838-43bd-8334-688d11302496	CREATE	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	{"items": [{"id": "18ec13cb-0674-4f07-b06a-166a80d9c6b7", "quantity": 3, "menuItemId": "094b3d75-f087-476a-863b-a70da76e2365"}], "originalAction": "ORDER_ITEMS_ADDED"}	2026-09-08 11:12:06.974+05:30	2026-09-08 11:12:06.961926+05:30	\N	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N
aa7faca0-1215-47f4-80d7-57e13966990c	11111111-1111-1111-1111-111111111111	PAYMENT	83cadcc5-c2f6-4381-a36a-052d8b48b380	CREATE	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	{"method": "CASH", "orderId": "e7d4d6cf-4838-43bd-8334-688d11302496", "amountMinor": "116025", "originalAction": "PAYMENT_RECORDED"}	2026-09-08 11:17:50.382+05:30	2026-09-08 11:17:50.353559+05:30	\N	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N
a29a85e4-0c7f-4feb-aaf0-243b6d1d86f2	11111111-1111-1111-1111-111111111111	ORDER	f5d3449d-ce21-48cb-ab01-b41c41a7301c	CREATE	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	{"items": [{"id": "b80c6285-d018-47a1-9dfa-2e686b8effc3", "quantity": 1, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}], "originalAction": "ORDER_ITEMS_ADDED"}	2026-09-08 14:14:29.218+05:30	2026-09-08 14:14:29.187607+05:30	\N	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N
469963b2-ccbc-4b7e-90bc-2256d3d00a36	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 30, "stockQty": 73, "isStocked": true}	2026-09-09 12:48:03.962+05:30	2026-09-09 12:48:03.962761+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
d9a0be1f-2984-4731-941e-975253640129	11111111-1111-1111-1111-111111111111	ORDER	f5d3449d-ce21-48cb-ab01-b41c41a7301c	CREATE	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	{"items": [{"id": "7ef66626-f4e7-4ebe-a4fe-4e09367d8ab0", "quantity": 1, "menuItemId": "5d13a97e-027a-445b-94eb-2f00546b1614"}, {"id": "f89483cf-0d93-4bc0-816a-285a7a13d065", "quantity": 1, "menuItemId": "e286dcdc-8100-430d-967e-6edba83f1609"}], "originalAction": "ORDER_ITEMS_ADDED"}	2026-09-08 16:19:27.29+05:30	2026-09-08 16:19:27.270906+05:30	\N	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N
6ef2fd7f-2571-4661-969e-9a870407d29d	11111111-1111-1111-1111-111111111111	PAYMENT	f055326e-c3d8-4686-83ec-f739c167e7b9	CREATE	918df673-2606-403a-9fad-1c54870d1fce	\N	{"method": "CASH", "orderId": "b101f725-9679-4cf3-9f0f-16adb200ecff", "amountMinor": "3150", "originalAction": "PAYMENT_RECORDED"}	2026-09-09 12:45:00.362+05:30	2026-09-09 12:45:00.340408+05:30	\N	\N	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N
1b847e4d-4853-41c1-816c-82cf28f2027a	11111111-1111-1111-1111-111111111111	PAYMENT	77c1b0ca-ce68-49e9-a5ad-b8918a3df29f	CREATE	918df673-2606-403a-9fad-1c54870d1fce	\N	{"method": "CASH", "orderId": "76692730-cd05-45cd-b8ad-9cc20ac9fc5a", "amountMinor": "7350", "originalAction": "PAYMENT_RECORDED"}	2026-09-09 12:47:11.473+05:30	2026-09-09 12:47:11.454508+05:30	\N	\N	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N
94ed9b32-cc18-446d-bbc9-8e467ea7c473	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	e6d644af-1584-467a-863f-bac26eb84d38	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 100, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}	{"stockQty": 99, "isStocked": true, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d", "quantityDeducted": 1}	2026-09-09 12:47:30.834+05:30	2026-09-09 12:47:30.833052+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
861536ad-a51c-44ab-b348-69ed0b12eb0c	11111111-1111-1111-1111-111111111111	ORDER	0602cb47-3398-4ba0-b5da-87e23909efa3	CREATE	918df673-2606-403a-9fad-1c54870d1fce	\N	{"items": [{"id": "4c625b81-fece-407d-9b63-dced164b38b1", "quantity": 1, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}], "originalAction": "ORDER_ITEMS_ADDED"}	2026-09-09 12:47:50.715+05:30	2026-09-09 12:47:50.69576+05:30	\N	\N	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N
bdbb2d6d-b36f-4b47-bb01-2495600267b6	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	4c625b81-fece-407d-9b63-dced164b38b1	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 99, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}	{"stockQty": 98, "isStocked": true, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d", "quantityDeducted": 1}	2026-09-09 12:47:50.772+05:30	2026-09-09 12:47:50.774554+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
4d64adf5-0f95-4a71-a8ca-602fdc12604c	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 6, "stockQty": 97, "isStocked": true}	2026-09-09 12:47:59.701+05:30	2026-09-09 12:47:59.701343+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
0be96a6d-ad99-4dc5-a7a3-9c7905cb46b5	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 7, "stockQty": 96, "isStocked": true}	2026-09-09 12:47:59.885+05:30	2026-09-09 12:47:59.885038+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
9b849139-8f32-4b0a-95f5-bfa3e4c94387	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 8, "stockQty": 95, "isStocked": true}	2026-09-09 12:48:00.045+05:30	2026-09-09 12:48:00.045529+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
d553b8a3-3bdb-4fd4-a1d1-49e869c00607	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 9, "stockQty": 94, "isStocked": true}	2026-09-09 12:48:00.199+05:30	2026-09-09 12:48:00.199601+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
44f9dae0-b4f5-40c4-b9de-7a00900b487e	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 10, "stockQty": 93, "isStocked": true}	2026-09-09 12:48:00.362+05:30	2026-09-09 12:48:00.362999+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
63a1413a-e7ce-41b4-bdc2-a7b93b2d9c33	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 11, "stockQty": 92, "isStocked": true}	2026-09-09 12:48:00.524+05:30	2026-09-09 12:48:00.52479+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
38af33c6-3ab1-4577-98ca-3e610c876123	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 12, "stockQty": 91, "isStocked": true}	2026-09-09 12:48:00.717+05:30	2026-09-09 12:48:00.717757+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
64239b9d-b41a-42bc-83db-b75dc8985e43	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 13, "stockQty": 90, "isStocked": true}	2026-09-09 12:48:00.845+05:30	2026-09-09 12:48:00.845002+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
b97253f7-97cb-4ca6-ae19-30f3b4a70714	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 14, "stockQty": 89, "isStocked": true}	2026-09-09 12:48:01.02+05:30	2026-09-09 12:48:01.020489+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
60be30ee-1fdf-4ece-aa79-538ec710f4ce	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 15, "stockQty": 88, "isStocked": true}	2026-09-09 12:48:01.182+05:30	2026-09-09 12:48:01.182186+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
c79aa386-9c49-4909-8e14-b8d5612d0aa0	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 16, "stockQty": 87, "isStocked": true}	2026-09-09 12:48:01.348+05:30	2026-09-09 12:48:01.3481+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
d69ec9c1-4f26-4b97-beae-4e1f92bc01fd	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 17, "stockQty": 86, "isStocked": true}	2026-09-09 12:48:01.502+05:30	2026-09-09 12:48:01.502773+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
4a18e9b3-bb06-443e-8ddd-2a8b8b3dbf2b	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 18, "stockQty": 85, "isStocked": true}	2026-09-09 12:48:01.675+05:30	2026-09-09 12:48:01.675266+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
7605a57d-d6f6-4d32-b650-f4dc49473b7a	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 19, "stockQty": 84, "isStocked": true}	2026-09-09 12:48:01.863+05:30	2026-09-09 12:48:01.863385+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
3fb8b5e3-fcf2-428b-9ff0-cc50e83fb78e	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 20, "stockQty": 83, "isStocked": true}	2026-09-09 12:48:02.099+05:30	2026-09-09 12:48:02.09958+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
5b6c26ae-f666-4aad-838d-9b2010946ee0	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 21, "stockQty": 82, "isStocked": true}	2026-09-09 12:48:02.292+05:30	2026-09-09 12:48:02.292155+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
0077f2c6-9206-4bd6-9d7b-dcd0bba11a0e	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 22, "stockQty": 81, "isStocked": true}	2026-09-09 12:48:02.485+05:30	2026-09-09 12:48:02.485181+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
efb8f302-11aa-4eb5-a6e2-620188126a26	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 23, "stockQty": 80, "isStocked": true}	2026-09-09 12:48:02.685+05:30	2026-09-09 12:48:02.685662+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
2d766037-a242-4229-92e7-73e0555b3c27	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 24, "stockQty": 79, "isStocked": true}	2026-09-09 12:48:02.853+05:30	2026-09-09 12:48:02.853758+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
54270e4a-bb5e-4388-9dbe-9c63c0b9b82a	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 25, "stockQty": 78, "isStocked": true}	2026-09-09 12:48:03.062+05:30	2026-09-09 12:48:03.062759+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
e00fc53a-2835-4190-82df-924355d2ce8b	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 26, "stockQty": 77, "isStocked": true}	2026-09-09 12:48:03.244+05:30	2026-09-09 12:48:03.244414+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
9287a818-7e65-426b-aa2c-3d6d6c2d36fc	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 27, "stockQty": 76, "isStocked": true}	2026-09-09 12:48:03.418+05:30	2026-09-09 12:48:03.41809+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
76888db1-3318-4714-b3c2-ce37b540657f	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 28, "stockQty": 75, "isStocked": true}	2026-09-09 12:48:03.603+05:30	2026-09-09 12:48:03.602969+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
a27be355-3465-4667-b6b8-1ef9fd9594fd	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 29, "stockQty": 74, "isStocked": true}	2026-09-09 12:48:03.793+05:30	2026-09-09 12:48:03.793387+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
657fad85-d24f-41d4-817c-58a1142ab106	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 31, "stockQty": 72, "isStocked": true}	2026-09-09 12:48:04.137+05:30	2026-09-09 12:48:04.13775+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
2308b819-e2bc-4040-9fe5-6f24076840cb	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 34, "stockQty": 69, "isStocked": true}	2026-09-09 12:48:04.642+05:30	2026-09-09 12:48:04.642061+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
7d63d5d9-d3d3-45c2-911a-ab037674c51a	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 32, "stockQty": 71, "isStocked": true}	2026-09-09 12:48:04.315+05:30	2026-09-09 12:48:04.314924+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
ebe73e47-ef7d-4090-9bc2-087c1e170dc9	11111111-1111-1111-1111-111111111111	ORDER	0602cb47-3398-4ba0-b5da-87e23909efa3	CREATE	918df673-2606-403a-9fad-1c54870d1fce	\N	{"items": [{"id": "31447489-e6af-4bc5-a132-783f2da200c0", "quantity": 90, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}], "originalAction": "ORDER_ITEMS_ADDED"}	2026-09-09 12:48:24.598+05:30	2026-09-09 12:48:24.578971+05:30	\N	\N	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N
283aeaa7-9273-4330-88fd-bc21811ec465	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	31447489-e6af-4bc5-a132-783f2da200c0	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 100, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}	{"stockQty": 10, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 90}	2026-09-09 12:48:24.644+05:30	2026-09-09 12:48:24.644156+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
ba5afdfe-0c02-4877-bd99-b848aa980fdb	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 33, "stockQty": 70, "isStocked": true}	2026-09-09 12:48:04.466+05:30	2026-09-09 12:48:04.466228+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
a94b8952-d6bc-4d7b-9ee4-09383e5f01f5	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	c6fbd83e-75ed-472a-b1bf-2e7889b797f0	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 59, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}	{"stockQty": 58, "isStocked": true, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d", "quantityDeducted": 1}	2026-09-09 12:51:14.284+05:30	2026-09-09 12:51:14.285316+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
4a25db64-6d7f-4100-a1ef-454c0ff050a4	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 35, "stockQty": 68, "isStocked": true}	2026-09-09 12:48:04.828+05:30	2026-09-09 12:48:04.828375+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
77d01f42-9067-470c-bad1-82a7919205c2	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 39, "stockQty": 64, "isStocked": true}	2026-09-09 12:49:16.4+05:30	2026-09-09 12:49:16.400552+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
7eed1b30-138d-4f34-9e67-456077d9d46d	11111111-1111-1111-1111-111111111111	ORDER	0602cb47-3398-4ba0-b5da-87e23909efa3	CREATE	918df673-2606-403a-9fad-1c54870d1fce	\N	{"items": [{"id": "b755bfc3-dea9-4d8f-b6d1-a7decce5f8be", "quantity": 5, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}], "originalAction": "ORDER_ITEMS_ADDED"}	2026-09-09 12:49:23.874+05:30	2026-09-09 12:49:23.847265+05:30	\N	\N	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N
b9e8322d-a71c-4e44-a609-97ab5cee3a78	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	b755bfc3-dea9-4d8f-b6d1-a7decce5f8be	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 64, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}	{"stockQty": 59, "isStocked": true, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d", "quantityDeducted": 5}	2026-09-09 12:49:23.918+05:30	2026-09-09 12:49:23.917597+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
f75ea35b-3402-451f-8460-86472bb3b282	11111111-1111-1111-1111-111111111111	PAYMENT	e605aa7d-04d2-4273-9088-89bcf90688b1	CREATE	918df673-2606-403a-9fad-1c54870d1fce	\N	{"method": "CASH", "orderId": "0602cb47-3398-4ba0-b5da-87e23909efa3", "amountMinor": "534975", "originalAction": "PAYMENT_RECORDED"}	2026-09-09 12:51:03.204+05:30	2026-09-09 12:51:03.177818+05:30	\N	\N	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N
515309aa-6db9-4a81-a0cc-f67bed72f7f1	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 36, "stockQty": 67, "isStocked": true}	2026-09-09 12:48:05.013+05:30	2026-09-09 12:48:05.013612+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
56d7f9a7-6df6-406a-a1c4-a4128a3688bf	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 37, "stockQty": 66, "isStocked": true}	2026-09-09 12:48:05.186+05:30	2026-09-09 12:48:05.186266+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
5140808b-69f8-4f9f-96f1-e921f86d8461	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 38, "stockQty": 65, "isStocked": true}	2026-09-09 12:48:05.362+05:30	2026-09-09 12:48:05.362638+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
19b5435c-3087-4dfa-8777-cade40f0334d	11111111-1111-1111-1111-111111111111	ORDER	2d4b655e-a5bf-4900-ba0c-11e1b3c2685c	CREATE	918df673-2606-403a-9fad-1c54870d1fce	\N	{"items": [{"id": "04e04ddf-bbb4-4e74-ae9e-864aca2029d4", "quantity": 16, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}], "originalAction": "ORDER_ITEMS_ADDED"}	2026-09-09 12:51:28.094+05:30	2026-09-09 12:51:28.083736+05:30	\N	\N	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N
f8e2e3d6-cca6-4970-90d8-439409a011a6	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	04e04ddf-bbb4-4e74-ae9e-864aca2029d4	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 58, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}	{"stockQty": 42, "isStocked": true, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d", "quantityDeducted": 16}	2026-09-09 12:51:28.133+05:30	2026-09-09 12:51:28.132997+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
79590f61-0f2b-40f6-bcfc-5830f050cee6	11111111-1111-1111-1111-111111111111	ORDER	2d4b655e-a5bf-4900-ba0c-11e1b3c2685c	CREATE	918df673-2606-403a-9fad-1c54870d1fce	\N	{"items": [{"id": "4923d9da-bcb2-46da-833a-8b4a037f0436", "quantity": 32, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}], "originalAction": "ORDER_ITEMS_ADDED"}	2026-09-09 12:51:46.681+05:30	2026-09-09 12:51:46.669142+05:30	\N	\N	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N
9a808933-a365-4af3-b7df-4520384b11b5	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	4923d9da-bcb2-46da-833a-8b4a037f0436	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 42, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}	{"stockQty": 10, "isStocked": true, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d", "quantityDeducted": 32}	2026-09-09 12:51:46.728+05:30	2026-09-09 12:51:46.727639+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
711a1901-8eb9-4423-b8bb-3a198e5f3ee0	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 44, "stockQty": 15, "isStocked": true}	2026-09-09 12:52:31.552+05:30	2026-09-09 12:52:31.553436+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
38104b28-d3ab-4995-aa4a-f5190671e121	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	e2ac9075-4d00-464e-88a2-afe715362121	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 15, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}	{"stockQty": 12, "isStocked": true, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d", "quantityDeducted": 3}	2026-09-09 12:52:31.722+05:30	2026-09-09 12:52:31.723381+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
0980370b-7faf-4cba-8e93-8ee2447351c5	11111111-1111-1111-1111-111111111111	ORDER	2d4b655e-a5bf-4900-ba0c-11e1b3c2685c	CREATE	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	{"items": [{"id": "f79c39a2-f114-496c-bf0e-09ac73ddf914", "quantity": 4, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}], "originalAction": "ORDER_ITEMS_ADDED"}	2026-09-09 12:55:56.37+05:30	2026-09-09 12:55:56.357916+05:30	\N	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N
c419ca77-34b4-47f3-9da8-2d1d2aab0f78	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	f79c39a2-f114-496c-bf0e-09ac73ddf914	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 12, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}	{"stockQty": 8, "isStocked": true, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d", "quantityDeducted": 4}	2026-09-09 12:55:57.328+05:30	2026-09-09 12:55:57.328877+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
418059ca-b49b-4fc5-aab5-c85e0f335b6c	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 47, "stockQty": 15, "isStocked": true}	2026-09-09 13:01:25.088+05:30	2026-09-09 13:01:25.089287+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
0032b892-ed10-4cfc-a540-7bc0357be8f1	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	03ec0df1-5176-44d6-befb-8477fd240cb0	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 15, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}	{"stockQty": 12, "isStocked": true, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d", "quantityDeducted": 3}	2026-09-09 13:01:25.25+05:30	2026-09-09 13:01:25.24992+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
c0dfaa93-83b3-4415-9612-fb16e93a9ec9	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 49, "stockQty": 15, "isStocked": true}	2026-09-09 13:02:02.065+05:30	2026-09-09 13:02:02.066187+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
ab71bd93-9cfd-44d7-831b-56710be561f5	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	970e6000-56da-419a-9d6c-33afca6265fd	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 15, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}	{"stockQty": 12, "isStocked": true, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d", "quantityDeducted": 3}	2026-09-09 13:02:02.293+05:30	2026-09-09 13:02:02.295177+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
1172ded6-a0a2-4812-bc83-8793fbd9c7d3	11111111-1111-1111-1111-111111111111	ORDER	4e192b03-6942-454a-a9dd-9084d99362b1	OVERRIDE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"subtotal": "25500", "orderItemId": "970e6000-56da-419a-9d6c-33afca6265fd"}	{"reasonCode": "TEST_VOID", "originalAction": "ORDER_ITEM_VOIDED"}	2026-09-09 13:02:03.033+05:30	2026-09-09 13:02:03.01853+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	TEST_VOID	\N	\N
8462c096-f21f-4085-96f5-f9f10a583cc5	11111111-1111-1111-1111-111111111111	PORTION_RESTORED	970e6000-56da-419a-9d6c-33afca6265fd	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"stockQty": 12, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}	{"stockQty": 15, "isStocked": true, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d", "quantityRestored": 3}	2026-09-09 13:02:03.049+05:30	2026-09-09 13:02:03.050383+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	ITEM_VOIDED	\N	\N
153c2b07-b674-4049-954a-7eb9baef6227	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	aa746b8b-9705-4520-a5a8-54ab4190f58c	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 15, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}	{"stockQty": 0, "isStocked": false, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d", "quantityDeducted": 15}	2026-09-09 13:02:03.793+05:30	2026-09-09 13:02:03.795078+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
61621015-2f24-4732-98c3-a9cf3fa77e71	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 2, "stockQty": 15, "isStocked": true}	2026-09-09 13:03:37.695+05:30	2026-09-09 13:03:37.696615+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
fb60e54b-41d2-42cf-817b-95aaa7b711b9	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	2bf7206e-c6f3-44aa-981c-a457abf6e62a	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 15, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b"}	{"stockQty": 12, "isStocked": true, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b", "quantityDeducted": 3}	2026-09-09 13:03:37.924+05:30	2026-09-09 13:03:37.92335+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
486c2222-6665-490c-9b73-4170044eafc0	11111111-1111-1111-1111-111111111111	ORDER	39f6e5e8-3eb1-4100-a8cc-4dfcb49ba060	OVERRIDE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"subtotal": "21000", "orderItemId": "2bf7206e-c6f3-44aa-981c-a457abf6e62a"}	{"reasonCode": "TEST_VOID", "originalAction": "ORDER_ITEM_VOIDED"}	2026-09-09 13:03:38.682+05:30	2026-09-09 13:03:38.668133+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	TEST_VOID	\N	\N
980277a0-5e0d-42ad-8b48-4df1ac6f68ae	11111111-1111-1111-1111-111111111111	PORTION_RESTORED	2bf7206e-c6f3-44aa-981c-a457abf6e62a	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"stockQty": 12, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b"}	{"stockQty": 15, "isStocked": true, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b", "quantityRestored": 3}	2026-09-09 13:03:38.708+05:30	2026-09-09 13:03:38.707582+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	ITEM_VOIDED	\N	\N
7d598139-8497-4d8c-874f-5b846f7c66f4	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	d07b13ab-7416-45f5-aa50-d4c92edb3536	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 15, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b"}	{"stockQty": 0, "isStocked": false, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b", "quantityDeducted": 15}	2026-09-09 13:03:39.421+05:30	2026-09-09 13:03:39.420207+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
1d9f9cbe-d659-47d9-8779-714cf3bebe8d	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 6, "stockQty": 50, "isStocked": true}	2026-09-09 13:03:40.078+05:30	2026-09-09 13:03:40.078823+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
8331eeb2-2d9f-4a67-9ad3-73e120293c3f	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	49768e80-5cf1-47a9-be73-5f24de6fb26e	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 2, "stockQty": 4, "isStocked": true}	2026-09-09 13:04:48.048+05:30	2026-09-09 13:04:48.048397+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
663f338f-b08f-4729-adee-6c5c97ccf179	11111111-1111-1111-1111-111111111111	PAYMENT	5274906f-8668-478b-82e7-03b15eeb777e	CREATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	{"method": "CASH", "orderId": "2d4b655e-a5bf-4900-ba0c-11e1b3c2685c", "amountMinor": "473025", "originalAction": "PAYMENT_RECORDED"}	2026-09-09 14:06:01.09+05:30	2026-09-09 14:06:01.080901+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
dd52c04f-ddb5-4d8e-b93c-bdbca0043bfd	11111111-1111-1111-1111-111111111111	PAYMENT	2d505e0f-6dd7-411b-8bce-9a1ca5c7ef05	CREATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	{"method": "CASH", "orderId": "eb13fd97-c972-4447-8a42-898eb545191e", "amountMinor": "21000", "originalAction": "PAYMENT_RECORDED"}	2026-09-09 14:07:07.593+05:30	2026-09-09 14:07:07.58697+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
8fdf2c28-c7d3-4dff-ae4c-05b9b645194a	11111111-1111-1111-1111-111111111111	PAYMENT	35ad0d01-e3e1-4272-bcab-b8009bf61358	CREATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	{"method": "CASH", "orderId": "f5d3449d-ce21-48cb-ab01-b41c41a7301c", "amountMinor": "45675", "originalAction": "PAYMENT_RECORDED"}	2026-09-09 14:07:29.933+05:30	2026-09-09 14:07:29.927643+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
6121ef32-22e7-4060-ad1e-3a97f70f7e23	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	1aa6fbfe-8643-49a5-8246-69a71196a167	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 0, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}	{"stockQty": 0, "isStocked": false, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d", "quantityDeducted": 1}	2026-09-09 14:27:26.258+05:30	2026-09-09 14:27:26.26281+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
c35de77e-69c7-443d-9731-e64de6510da6	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	49768e80-5cf1-47a9-be73-5f24de6fb26e	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 3, "stockQty": 30, "isStocked": true}	2026-09-09 14:27:33.462+05:30	2026-09-09 14:27:33.4629+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
0e1fc5a5-20d0-4b0d-8b81-062b438abf54	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	94a171f1-9bff-45e7-b655-9b864a43ec78	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 30, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}	{"stockQty": 25, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 5}	2026-09-09 14:27:33.907+05:30	2026-09-09 14:27:33.91144+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
df50c101-c42c-420c-b49d-0b2f3326b81b	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	49768e80-5cf1-47a9-be73-5f24de6fb26e	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 5, "stockQty": 50, "isStocked": true}	2026-09-09 14:27:34.584+05:30	2026-09-09 14:27:34.584905+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
eac4f98f-7619-4be8-8854-ee7ee69a7d68	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	49768e80-5cf1-47a9-be73-5f24de6fb26e	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 6, "stockQty": 30, "isStocked": true}	2026-09-09 14:28:57.732+05:30	2026-09-09 14:28:57.733014+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
6225a2d9-788b-4b78-9b2d-870cdcbecb4c	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	342243f5-67c3-4f51-a5f7-c6441c0f8058	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 30, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}	{"stockQty": 25, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 5}	2026-09-09 14:28:58.391+05:30	2026-09-09 14:28:58.407532+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
cdef0de8-307e-4034-85cb-e6e244fbb3dd	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	49768e80-5cf1-47a9-be73-5f24de6fb26e	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 8, "stockQty": 50, "isStocked": true}	2026-09-09 14:28:59.125+05:30	2026-09-09 14:28:59.125358+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
4a0a0613-f330-4470-84f8-85b0730771e3	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	49768e80-5cf1-47a9-be73-5f24de6fb26e	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 9, "stockQty": 30, "isStocked": true}	2026-09-09 14:29:43.137+05:30	2026-09-09 14:29:43.138433+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
7cf7a097-954e-4dbc-9f6c-4f43a1267f8b	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	28791b77-9a0b-4827-8fc3-156591208ce4	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 30, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}	{"stockQty": 25, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 5}	2026-09-09 14:29:43.588+05:30	2026-09-09 14:29:43.590063+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
19bfaaeb-4b21-4bb5-9402-932ae670a5e0	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	49768e80-5cf1-47a9-be73-5f24de6fb26e	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 11, "stockQty": 50, "isStocked": true}	2026-09-09 14:29:44.271+05:30	2026-09-09 14:29:44.271513+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
274f447b-36c6-47cf-a6fb-b2fa54bdb721	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	49768e80-5cf1-47a9-be73-5f24de6fb26e	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 12, "stockQty": 30, "isStocked": true}	2026-09-09 14:30:40.978+05:30	2026-09-09 14:30:40.979271+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
af3b32b5-75f6-4c29-b32b-48cf57e04d40	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	49768e80-5cf1-47a9-be73-5f24de6fb26e	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 13, "stockQty": 30, "isStocked": true}	2026-09-09 14:31:14.249+05:30	2026-09-09 14:31:14.249745+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
41605f32-01dc-46bc-8c86-955793f8fd4b	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	8fa479df-4828-4bbd-8781-0445ec6a7a4e	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 30, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}	{"stockQty": 25, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 5}	2026-09-09 14:31:14.705+05:30	2026-09-09 14:31:14.707582+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
bf27af78-b827-4f67-a540-866105d725f5	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	49768e80-5cf1-47a9-be73-5f24de6fb26e	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 15, "stockQty": 50, "isStocked": true}	2026-09-09 14:31:15.416+05:30	2026-09-09 14:31:15.416638+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
315fed00-c4ee-442e-b4aa-1fad8f7c7629	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	49768e80-5cf1-47a9-be73-5f24de6fb26e	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 16, "stockQty": 30, "isStocked": true}	2026-09-09 14:31:59.15+05:30	2026-09-09 14:31:59.151107+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
41b2cbcb-bea3-4aee-a801-fc50928bef73	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	1d24f99b-b19c-40f1-b8f4-3c9e1222fd40	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 30, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}	{"stockQty": 25, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 5}	2026-09-09 14:31:59.424+05:30	2026-09-09 14:31:59.427384+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
9e58eeee-4d81-406a-8b24-94a1c2d29412	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	49768e80-5cf1-47a9-be73-5f24de6fb26e	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 18, "stockQty": 50, "isStocked": true}	2026-09-09 14:32:00.142+05:30	2026-09-09 14:32:00.14255+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
3a96dd17-587b-4837-9a9f-3fa485f85b4e	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	49768e80-5cf1-47a9-be73-5f24de6fb26e	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 19, "stockQty": 30, "isStocked": true}	2026-09-09 14:32:48.123+05:30	2026-09-09 14:32:48.124595+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
2611938d-2a1b-4df1-a6ed-8e580b04adcf	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	f1df626b-fc7b-4399-bf69-c2502c895927	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 30, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}	{"stockQty": 25, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 5}	2026-09-09 14:32:48.989+05:30	2026-09-09 14:32:48.991014+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
d63c47ad-a30a-4e4f-9eb1-41c544dd8d41	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	49768e80-5cf1-47a9-be73-5f24de6fb26e	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 21, "stockQty": 50, "isStocked": true}	2026-09-09 14:32:49.707+05:30	2026-09-09 14:32:49.708483+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
d08134a9-1896-4071-b4a9-c78049548466	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	49768e80-5cf1-47a9-be73-5f24de6fb26e	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 22, "stockQty": 30, "isStocked": true}	2026-09-09 14:34:00.772+05:30	2026-09-09 14:34:00.773008+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
b006a574-7ec9-4469-b73e-3028a0e852b7	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	c00be2b8-881c-4bde-9a46-577c19ea7bc3	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 30, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}	{"stockQty": 25, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 5}	2026-09-09 14:34:01.617+05:30	2026-09-09 14:34:01.620225+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
9abe9772-464d-439a-b7ba-f6fffd6107c7	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	49768e80-5cf1-47a9-be73-5f24de6fb26e	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 24, "stockQty": 50, "isStocked": true}	2026-09-09 14:34:02.309+05:30	2026-09-09 14:34:02.30985+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
a84e1735-3c60-4e48-82db-2cefdf335d35	11111111-1111-1111-1111-111111111111	ORDER	0a746ebb-ff2b-40d1-8d00-5e7652f56006	CREATE	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	{"items": [{"id": "4803f052-a4cd-4a89-ab6f-74fac3d67772", "quantity": 1, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404"}], "originalAction": "ORDER_ITEMS_ADDED"}	2026-09-09 14:35:45.612+05:30	2026-09-09 14:35:45.599475+05:30	\N	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N
33429c42-5906-4cbf-a63c-812ca7edfd37	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	4803f052-a4cd-4a89-ab6f-74fac3d67772	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 100, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404"}	{"stockQty": 99, "isStocked": true, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404", "quantityDeducted": 1}	2026-09-09 14:35:45.661+05:30	2026-09-09 14:35:45.662538+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
4eb31f4a-8c60-4184-bcd4-b2279c5a9c48	11111111-1111-1111-1111-111111111111	PAYMENT	2a7ca9cc-5903-4193-bdfc-bf5bbe9e2e64	CREATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	{"method": "CASH", "orderId": "0a746ebb-ff2b-40d1-8d00-5e7652f56006", "amountMinor": "15225", "originalAction": "PAYMENT_RECORDED"}	2026-09-09 15:08:54.374+05:30	2026-09-09 15:08:54.363994+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
639957c5-2d27-437c-8fde-466b4a81fd0d	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	2f46c4fc-4fd6-4c9b-a3f8-acdbd42c0594	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 50, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}	{"stockQty": 49, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 1}	2026-09-09 15:09:20.438+05:30	2026-09-09 15:09:20.440031+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
d1f2c402-7178-4dd4-8640-2a0b138c32a5	11111111-1111-1111-1111-111111111111	ORDER	3e1ba9c8-0311-4534-a8d3-fa97b3a4f933	CREATE	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	{"items": [{"id": "582a60f4-534d-4024-88c8-1f56e570f4de", "quantity": 1, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}], "originalAction": "ORDER_ITEMS_ADDED"}	2026-09-10 16:50:53.034+05:30	2026-09-10 16:50:52.998474+05:30	\N	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N
c3121cc7-cba3-4be6-8171-e639650e0a39	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	582a60f4-534d-4024-88c8-1f56e570f4de	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 49, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}	{"stockQty": 48, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 1}	2026-09-10 16:50:53.186+05:30	2026-09-10 16:50:53.188001+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
9e1e33fd-ecd0-4ccd-bb3e-1a01d0f04620	11111111-1111-1111-1111-111111111111	PAYMENT	1d81be04-8b53-4beb-b11c-b4cfbaef9c97	CREATE	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	{"method": "CASH", "orderId": "3e1ba9c8-0311-4534-a8d3-fa97b3a4f933", "amountMinor": "15500", "originalAction": "PAYMENT_RECORDED"}	2026-09-10 17:17:49.661+05:30	2026-09-10 17:17:49.644383+05:30	\N	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N
3fe51781-b92b-4600-a936-a367157aaed6	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	feaf21a6-4ea0-4b99-b0f0-bf197fa7b705	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 48, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}	{"stockQty": 47, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 1}	2026-09-11 12:09:46.431+05:30	2026-09-11 12:09:46.435642+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
293a29f4-5fc4-4bb3-92b0-b386ca84257d	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	5325d83c-f786-4964-bdd3-08acdefa96be	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 99, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404"}	{"stockQty": 97, "isStocked": true, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404", "quantityDeducted": 2}	2026-09-11 12:33:27.28+05:30	2026-09-11 12:33:27.281643+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
41093082-da8d-4ff0-8d12-4cc873196ac1	11111111-1111-1111-1111-111111111111	PAYMENT	dab22667-14a1-457f-99ee-7116b8b01c13	CREATE	5c660c1f-f5f8-4007-87a6-b4b39913998b	\N	{"method": "CASH", "orderId": "c8387bcf-ab67-44bb-87fb-d67f6d7601ca", "amountMinor": "17600", "originalAction": "PAYMENT_RECORDED"}	2026-09-11 12:34:34.857+05:30	2026-09-11 12:34:34.831027+05:30	\N	\N	5c660c1f-f5f8-4007-87a6-b4b39913998b	\N	\N	\N
8681a881-591a-46c3-ad4b-e91b8ffe3fec	11111111-1111-1111-1111-111111111111	PAYMENT	287e9dac-3cdc-455d-89db-015a7b0a2b43	CREATE	5c660c1f-f5f8-4007-87a6-b4b39913998b	\N	{"method": "CASH", "orderId": "27f9f630-3e8b-4ba9-b4d7-e631e45182f7", "amountMinor": "10250", "originalAction": "PAYMENT_RECORDED"}	2026-09-11 12:35:19.639+05:30	2026-09-11 12:35:19.617447+05:30	\N	\N	5c660c1f-f5f8-4007-87a6-b4b39913998b	\N	\N	\N
fa338919-9a76-4d0d-b4be-bfa0a3d8e986	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	6d2bb836-3203-4c6c-a2ea-d81d3729a02d	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 47, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}	{"stockQty": 46, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 1}	2026-09-11 12:59:30.787+05:30	2026-09-11 12:59:30.789207+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
30337dc8-087c-4338-91f3-98f58ffde6b1	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	afde9793-1550-477e-b114-bdd6d6c5491e	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 50, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b"}	{"stockQty": 49, "isStocked": true, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b", "quantityDeducted": 1}	2026-09-11 12:59:30.795+05:30	2026-09-11 12:59:30.797008+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
04d88da4-07b9-4690-91b3-facb05bce715	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	1bc49c16-8bb7-4650-a1c1-0f3afb56fdd8	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 97, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404"}	{"stockQty": 96, "isStocked": true, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404", "quantityDeducted": 1}	2026-09-11 12:59:52.873+05:30	2026-09-11 12:59:52.875462+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
ce583c70-2e3a-47ce-ac54-0b09b1fa0918	67315042-c687-4cbb-b45a-f4ea4efc199f	PORTION_DEPLETED	69d4ccbf-020e-45f7-bff8-efdee2f95fb2	UPDATE	67315042-c687-4cbb-b45a-f4ea4efc199f	{"stockQty": 100, "menuItemId": "1048c560-86bd-45c5-b872-eb5e802c6e46"}	{"stockQty": 99, "isStocked": false, "menuItemId": "1048c560-86bd-45c5-b872-eb5e802c6e46", "quantityDeducted": 1}	2026-09-11 14:12:08.791+05:30	2026-09-11 14:12:08.792631+05:30	\N	\N	67315042-c687-4cbb-b45a-f4ea4efc199f	ORDER_PLACED	\N	\N
04340702-6ca0-4e67-b369-e56a46c3cc72	67315042-c687-4cbb-b45a-f4ea4efc199f	PORTION_DEPLETED	a5ad1b27-1d4d-4a40-a7f8-1e08026ac3ba	UPDATE	67315042-c687-4cbb-b45a-f4ea4efc199f	{"stockQty": 99, "menuItemId": "1048c560-86bd-45c5-b872-eb5e802c6e46"}	{"stockQty": 98, "isStocked": false, "menuItemId": "1048c560-86bd-45c5-b872-eb5e802c6e46", "quantityDeducted": 1}	2026-09-11 14:16:07.385+05:30	2026-09-11 14:16:07.395039+05:30	\N	\N	67315042-c687-4cbb-b45a-f4ea4efc199f	ORDER_PLACED	\N	\N
088526d4-4cfe-4a61-9866-0d06a21b7af5	67315042-c687-4cbb-b45a-f4ea4efc199f	PORTION_DEPLETED	32733e86-926a-421a-86cd-ee6fb9ffb7a0	UPDATE	67315042-c687-4cbb-b45a-f4ea4efc199f	{"stockQty": 98, "menuItemId": "1048c560-86bd-45c5-b872-eb5e802c6e46"}	{"stockQty": 97, "isStocked": false, "menuItemId": "1048c560-86bd-45c5-b872-eb5e802c6e46", "quantityDeducted": 1}	2026-09-11 14:19:07.517+05:30	2026-09-11 14:19:07.519759+05:30	\N	\N	67315042-c687-4cbb-b45a-f4ea4efc199f	ORDER_PLACED	\N	\N
02d6959a-d3a3-4343-ace0-7e20855bac40	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	45c18b8d-29a0-4435-98e2-db478e9242f9	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 46, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}	{"stockQty": 45, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 1}	2026-09-11 14:24:19.934+05:30	2026-09-11 14:24:19.936452+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
95189dc6-8640-449a-8ab1-e41aef9154bf	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	9fa4ac4f-fd3d-4490-9ad1-87bed53a26d7	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 96, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404"}	{"stockQty": 95, "isStocked": true, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404", "quantityDeducted": 1}	2026-09-11 14:25:28.567+05:30	2026-09-11 14:25:28.571974+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
7117ba5e-2de9-4fb6-b9ae-1a8e2d0bb824	11111111-1111-1111-1111-111111111111	ORDER	4a4e9d6c-a797-4b03-9835-a44526c890e2	CREATE	918df673-2606-403a-9fad-1c54870d1fce	\N	{"items": [{"id": "4b8a17f6-cc5b-43d8-9bb1-23572af374e7", "quantity": 1, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404"}], "originalAction": "ORDER_ITEMS_ADDED"}	2026-09-11 16:39:37.832+05:30	2026-09-11 16:39:37.814336+05:30	\N	\N	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N
1b77e614-9ab6-4d50-9cfc-f473e4ca11ae	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	4b8a17f6-cc5b-43d8-9bb1-23572af374e7	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 95, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404"}	{"stockQty": 94, "isStocked": true, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404", "quantityDeducted": 1}	2026-09-11 16:39:37.883+05:30	2026-09-11 16:39:37.885151+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
cb6982bc-6f3e-4991-a228-b916201d188f	11111111-1111-1111-1111-111111111111	PAYMENT	33787728-0141-444e-80ba-cb3d953fd707	CREATE	72bad3bb-6097-47d2-bfc2-35b1244a7b9f	\N	{"method": "CASH", "orderId": "4a4e9d6c-a797-4b03-9835-a44526c890e2", "amountMinor": "17600", "originalAction": "PAYMENT_RECORDED"}	2026-09-12 15:32:01.582+05:30	2026-09-12 15:32:01.554774+05:30	\N	\N	72bad3bb-6097-47d2-bfc2-35b1244a7b9f	\N	\N	\N
3e4fa4e3-d545-4465-a61e-de27792ec53a	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	610ce49b-6860-4c2a-a978-58eee53abe0b	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 49, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b"}	{"stockQty": 48, "isStocked": true, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b", "quantityDeducted": 1}	2026-09-12 16:04:39.721+05:30	2026-09-12 16:04:39.724083+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
a6e462b3-4bcc-4f01-b409-cb6c3c02dedf	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	e58cd3f4-fcb9-466f-882e-79f58c50f01d	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 100, "menuItemId": "71451535-8d85-417f-b0ec-3f2b87016045"}	{"stockQty": 99, "isStocked": true, "menuItemId": "71451535-8d85-417f-b0ec-3f2b87016045", "quantityDeducted": 1}	2026-09-12 16:04:39.732+05:30	2026-09-12 16:04:39.734046+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
5b064f58-e2cc-43d8-a2ec-f0e2eba8d31e	11111111-1111-1111-1111-111111111111	PAYMENT	b71a774b-e736-4284-a1ab-2d7b108f9bad	CREATE	72bad3bb-6097-47d2-bfc2-35b1244a7b9f	\N	{"method": "CASH", "orderId": "abaed738-9e4f-4470-ae04-031b3baa4721", "amountMinor": "19050", "originalAction": "PAYMENT_RECORDED"}	2026-09-12 16:05:47.921+05:30	2026-09-12 16:05:47.902452+05:30	\N	\N	72bad3bb-6097-47d2-bfc2-35b1244a7b9f	\N	\N	\N
f5e6453f-4454-4389-8e84-5af0982057af	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	de49919b-7467-40d6-a444-ce0e0b927f1e	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 100, "menuItemId": "5d13a97e-027a-445b-94eb-2f00546b1614"}	{"stockQty": 99, "isStocked": true, "menuItemId": "5d13a97e-027a-445b-94eb-2f00546b1614", "quantityDeducted": 1}	2026-09-12 16:20:51.922+05:30	2026-09-12 16:20:51.923866+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
85057a99-c7b6-4632-89c5-0228628ee6d8	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	0a897341-6ac0-4d8d-9eaf-ceade7d93d17	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 100, "menuItemId": "640584ad-7f9e-4a1b-8740-290fd382ea81"}	{"stockQty": 99, "isStocked": true, "menuItemId": "640584ad-7f9e-4a1b-8740-290fd382ea81", "quantityDeducted": 1}	2026-09-12 16:20:51.937+05:30	2026-09-12 16:20:51.938645+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
6309d4c7-ddcf-4ce6-b1ec-3fa23009222d	11111111-1111-1111-1111-111111111111	PAYMENT	b91471cb-4f98-4b75-9192-c05fc726d96a	CREATE	918df673-2606-403a-9fad-1c54870d1fce	\N	{"method": "CASH", "orderId": "8139a10d-c414-4402-818c-ea00cfd5e786", "amountMinor": "18900", "originalAction": "PAYMENT_RECORDED"}	2026-09-12 16:21:52.06+05:30	2026-09-12 16:21:52.043855+05:30	\N	\N	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N
93202951-49d5-4404-8a66-812d5e988263	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	507db4ef-89ab-45ce-b827-28b40e002b45	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 99, "menuItemId": "640584ad-7f9e-4a1b-8740-290fd382ea81"}	{"stockQty": 98, "isStocked": true, "menuItemId": "640584ad-7f9e-4a1b-8740-290fd382ea81", "quantityDeducted": 1}	2026-09-12 16:22:09.545+05:30	2026-09-12 16:22:09.547114+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
277355b0-d8c3-4a57-a594-be0e04d18064	11111111-1111-1111-1111-111111111111	PAYMENT	c24deced-ba82-4622-9292-ddd4b4903f30	CREATE	918df673-2606-403a-9fad-1c54870d1fce	\N	{"method": "CASH", "orderId": "547361f1-ab65-4eeb-b5ae-790378f1eebc", "amountMinor": "8925", "originalAction": "PAYMENT_RECORDED"}	2026-09-12 16:22:52.454+05:30	2026-09-12 16:22:52.437215+05:30	\N	\N	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N
0a0a4fa8-d5b0-48fa-a709-05104afeabd3	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	1756bfe8-0ef6-4d28-aaab-39b4e69b086e	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 99, "menuItemId": "71451535-8d85-417f-b0ec-3f2b87016045"}	{"stockQty": 98, "isStocked": true, "menuItemId": "71451535-8d85-417f-b0ec-3f2b87016045", "quantityDeducted": 1}	2026-09-12 16:23:25.085+05:30	2026-09-12 16:23:25.087133+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
1900fc4c-c822-43a6-bf08-8253d38be4ad	11111111-1111-1111-1111-111111111111	ORDER	7bf0131c-f022-46a1-9a7b-8569cd3682f8	CREATE	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	{"items": [{"id": "384df9e2-296b-4b7e-b7b3-fc56b19ee31b", "quantity": 1, "menuItemId": "d4d5c11d-7ca8-4f1f-9784-45b39bd6ef7c"}, {"id": "2ea6b595-c3ff-4250-b013-4b9221c0fd73", "quantity": 1, "menuItemId": "2ddb7944-4e83-4dda-99de-94dd5e83bb77"}], "originalAction": "ORDER_ITEMS_ADDED"}	2026-09-12 16:37:34.112+05:30	2026-09-12 16:37:34.088358+05:30	\N	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N
df2d6d50-18d3-4806-8e57-a44726d6e651	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	384df9e2-296b-4b7e-b7b3-fc56b19ee31b	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 100, "menuItemId": "d4d5c11d-7ca8-4f1f-9784-45b39bd6ef7c"}	{"stockQty": 99, "isStocked": true, "menuItemId": "d4d5c11d-7ca8-4f1f-9784-45b39bd6ef7c", "quantityDeducted": 1}	2026-09-12 16:37:34.15+05:30	2026-09-12 16:37:34.158451+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
5597fd8e-110c-4608-895e-5009134c4308	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	2ea6b595-c3ff-4250-b013-4b9221c0fd73	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 100, "menuItemId": "2ddb7944-4e83-4dda-99de-94dd5e83bb77"}	{"stockQty": 99, "isStocked": true, "menuItemId": "2ddb7944-4e83-4dda-99de-94dd5e83bb77", "quantityDeducted": 1}	2026-09-12 16:37:34.156+05:30	2026-09-12 16:37:34.163696+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
f679abf7-914e-44b3-8f70-701a0140a5b3	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	e37fb3cb-1472-4f02-9822-a08237870bd7	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 98, "menuItemId": "71451535-8d85-417f-b0ec-3f2b87016045"}	{"stockQty": 96, "isStocked": true, "menuItemId": "71451535-8d85-417f-b0ec-3f2b87016045", "quantityDeducted": 2}	2026-09-12 16:40:24.21+05:30	2026-09-12 16:40:24.211906+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
d7fffd2c-b38f-480c-bc8d-f11ce2387e67	67315042-c687-4cbb-b45a-f4ea4efc199f	PORTION_DEPLETED	31353c57-0051-4b53-b99e-d1c5b72ff0dd	UPDATE	67315042-c687-4cbb-b45a-f4ea4efc199f	{"stockQty": 97, "menuItemId": "1048c560-86bd-45c5-b872-eb5e802c6e46"}	{"stockQty": 95, "isStocked": false, "menuItemId": "1048c560-86bd-45c5-b872-eb5e802c6e46", "quantityDeducted": 2}	2026-09-15 15:20:21.908+05:30	2026-09-15 15:20:21.923596+05:30	\N	\N	67315042-c687-4cbb-b45a-f4ea4efc199f	ORDER_PLACED	\N	\N
4510ab52-f7b5-4177-ad03-91a01076f8d5	67315042-c687-4cbb-b45a-f4ea4efc199f	PORTION_DEPLETED	89bf37b2-7bfb-4e59-ac8d-7d86609c4bc3	UPDATE	67315042-c687-4cbb-b45a-f4ea4efc199f	{"stockQty": 95, "menuItemId": "1048c560-86bd-45c5-b872-eb5e802c6e46"}	{"stockQty": 93, "isStocked": false, "menuItemId": "1048c560-86bd-45c5-b872-eb5e802c6e46", "quantityDeducted": 2}	2026-09-15 15:22:15.41+05:30	2026-09-15 15:22:15.421162+05:30	\N	\N	67315042-c687-4cbb-b45a-f4ea4efc199f	ORDER_PLACED	\N	\N
6f5ee0a9-c219-4954-b45d-db280e731d94	67315042-c687-4cbb-b45a-f4ea4efc199f	AGGREGATOR_WEBHOOK	fd16417e-3c3d-418a-a088-d360729aac73	CREATE	67315042-c687-4cbb-b45a-f4ea4efc199f	\N	{"channel": "SWIGGY", "orderId": "fd16417e-3c3d-418a-a088-d360729aac73", "customer": {"name": "Aarav Sharma", "phone": "+919876543201"}, "orderNumber": "SWIGGY-SWIG-76280", "externalEventId": null, "externalOrderId": "SWIG-76280"}	2026-09-15 15:22:15.414+05:30	2026-09-15 15:22:15.424588+05:30	\N	\N	67315042-c687-4cbb-b45a-f4ea4efc199f	\N	\N	\N
cf57b204-5492-446a-b473-eec9afe325a2	67315042-c687-4cbb-b45a-f4ea4efc199f	PORTION_DEPLETED	9f984ea0-7092-495b-aaab-e0339c3dc92a	UPDATE	67315042-c687-4cbb-b45a-f4ea4efc199f	{"stockQty": 93, "menuItemId": "1048c560-86bd-45c5-b872-eb5e802c6e46"}	{"stockQty": 92, "isStocked": false, "menuItemId": "1048c560-86bd-45c5-b872-eb5e802c6e46", "quantityDeducted": 1}	2026-09-15 15:26:49.386+05:30	2026-09-15 15:26:49.397286+05:30	\N	\N	67315042-c687-4cbb-b45a-f4ea4efc199f	ORDER_PLACED	\N	\N
8e04fb01-e430-4ff7-acf3-d159ebd1d993	67315042-c687-4cbb-b45a-f4ea4efc199f	PORTION_DEPLETED	4b38180e-52e9-46df-9636-03f3ab5fe080	UPDATE	67315042-c687-4cbb-b45a-f4ea4efc199f	{"stockQty": 92, "menuItemId": "1048c560-86bd-45c5-b872-eb5e802c6e46"}	{"stockQty": 89, "isStocked": false, "menuItemId": "1048c560-86bd-45c5-b872-eb5e802c6e46", "quantityDeducted": 3}	2026-09-15 15:26:49.393+05:30	2026-09-15 15:26:49.404647+05:30	\N	\N	67315042-c687-4cbb-b45a-f4ea4efc199f	ORDER_PLACED	\N	\N
8576f0a7-d276-46ae-a24a-037c7a76cbb7	67315042-c687-4cbb-b45a-f4ea4efc199f	AGGREGATOR_WEBHOOK	dce6709a-59c7-4b0f-b6b7-a84556fd4da8	CREATE	67315042-c687-4cbb-b45a-f4ea4efc199f	\N	{"channel": "ZOMATO", "orderId": "dce6709a-59c7-4b0f-b6b7-a84556fd4da8", "customer": {"name": "Deepika Padukone", "phone": "+919876543202"}, "orderNumber": "ZOMATO-ZOM-29923", "externalEventId": null, "externalOrderId": "ZOM-29923"}	2026-09-15 15:26:49.396+05:30	2026-09-15 15:26:49.407398+05:30	\N	\N	67315042-c687-4cbb-b45a-f4ea4efc199f	\N	\N	\N
34470964-b3c7-4356-be5c-247233adaa53	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	bd669fbe-a77b-4740-a72b-436bd193d398	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 94, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404"}	{"stockQty": 92, "isStocked": true, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404", "quantityDeducted": 2}	2026-09-15 16:15:47.872+05:30	2026-09-15 16:15:47.876748+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
5c2a8ab9-56ec-46ca-9563-2b1d51ae3555	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	a88827e9-020a-4394-9ce6-4be1f5eee84f	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 100, "menuItemId": "0020780f-7112-4804-a81b-2e06a91cdaa4"}	{"stockQty": 98, "isStocked": true, "menuItemId": "0020780f-7112-4804-a81b-2e06a91cdaa4", "quantityDeducted": 2}	2026-09-15 16:15:47.88+05:30	2026-09-15 16:15:47.886132+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
b563cbc8-0fe6-4c3e-832d-cc97d9ef4829	11111111-1111-1111-1111-111111111111	AGGREGATOR_WEBHOOK	cbb10a15-6c98-4ad1-a42b-ae7e1f56f9b7	CREATE	11111111-1111-1111-1111-111111111111	\N	{"channel": "ZOMATO", "orderId": "cbb10a15-6c98-4ad1-a42b-ae7e1f56f9b7", "customer": {"name": "Deepika Padukone", "phone": "+919876543202"}, "orderNumber": "ZOMATO-ZOM-50848", "externalEventId": null, "externalOrderId": "ZOM-50848"}	2026-09-15 16:15:47.885+05:30	2026-09-15 16:15:47.890193+05:30	\N	\N	11111111-1111-1111-1111-111111111111	\N	\N	\N
77c7b8df-9855-4361-8884-80fa9655eaa3	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	50cc1925-243e-4e13-9c8d-30e6809f5228	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 96, "menuItemId": "71451535-8d85-417f-b0ec-3f2b87016045"}	{"stockQty": 94, "isStocked": true, "menuItemId": "71451535-8d85-417f-b0ec-3f2b87016045", "quantityDeducted": 2}	2026-09-15 16:15:48.024+05:30	2026-09-15 16:15:48.027556+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
ff664c1f-85ed-4f04-a8f0-2a67e6eff50e	11111111-1111-1111-1111-111111111111	AGGREGATOR_WEBHOOK	244aecef-ffc4-48ba-a00c-0e041ee50389	CREATE	11111111-1111-1111-1111-111111111111	\N	{"channel": "SWIGGY", "orderId": "244aecef-ffc4-48ba-a00c-0e041ee50389", "customer": {"name": "Aarav Sharma", "phone": "+919876543201"}, "orderNumber": "SWIGGY-SWIG-24093", "externalEventId": null, "externalOrderId": "SWIG-24093"}	2026-09-15 16:15:48.026+05:30	2026-09-15 16:15:48.029962+05:30	\N	\N	11111111-1111-1111-1111-111111111111	\N	\N	\N
81a41431-888f-408a-984f-824792cf90a3	11111111-1111-1111-1111-111111111111	DINING_TABLE	fc8127fc-a614-4ba2-ae4e-bc2fb91b2d3d	CREATE	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	{"reason": null, "memberIds": ["7f7e342f-0f6c-456c-9ec5-055de3ab87fe", "fc8127fc-a614-4ba2-ae4e-bc2fb91b2d3d"], "mergeGroupId": "3cd09765-0c46-48de-b774-f426b5f9da3d", "targetOrderId": null, "targetTableId": "fc8127fc-a614-4ba2-ae4e-bc2fb91b2d3d", "originalAction": "TABLE_MERGE", "sourceTableIds": ["7f7e342f-0f6c-456c-9ec5-055de3ab87fe"], "mergedOrdersCount": 0}	2026-09-23 13:20:56.702+05:30	2026-09-23 13:20:56.70609+05:30	\N	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N
61e3b7dc-6b20-4f9a-999f-bd63bd5f394c	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	99d5a47e-068f-4cc0-98c7-bf0ab01eb07f	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 48, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b"}	{"stockQty": 47, "isStocked": true, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b", "quantityDeducted": 1}	2026-09-23 13:22:19.429+05:30	2026-09-23 13:22:19.431121+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
6f0630e8-5634-42ec-a4d6-23cabc4426e8	11111111-1111-1111-1111-111111111111	PAYMENT	f367414d-0407-4dd6-8da4-8e1b19d7d27b	CREATE	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	{"method": "CASH", "orderId": "db187890-3de7-4a5d-87b2-9398153c343a", "amountMinor": "7350", "originalAction": "PAYMENT_RECORDED"}	2026-09-23 13:23:29.746+05:30	2026-09-23 13:23:29.740382+05:30	\N	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N
d80fe26d-cd6e-4143-aaae-c12323ac78e4	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	bd610f8f-27d5-4d8e-9119-5fb6a5592408	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 47, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b"}	{"stockQty": 46, "isStocked": true, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b", "quantityDeducted": 1}	2026-09-24 09:03:25.681+05:30	2026-09-24 09:03:25.68554+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
92eb816d-7ab1-4fc5-9428-33dee4e4185b	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	a20f3ecf-d99d-4919-9bb1-b70fc265be56	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 94, "menuItemId": "71451535-8d85-417f-b0ec-3f2b87016045"}	{"stockQty": 93, "isStocked": true, "menuItemId": "71451535-8d85-417f-b0ec-3f2b87016045", "quantityDeducted": 1}	2026-09-24 09:03:25.702+05:30	2026-09-24 09:03:25.70603+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
d65bcf04-9aa4-44ff-8f2b-b89643392128	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	2d631ad3-a4fd-4ed2-a74c-58dade6b70da	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 45, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}	{"stockQty": 43, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 2}	2026-09-24 23:32:05.941+05:30	2026-09-24 23:32:05.944369+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
f29d084b-a595-48e8-afa1-e64ecfca95b2	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	1aa0dc86-fbc7-40f7-86e3-b40d18c85905	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 46, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b"}	{"stockQty": 45, "isStocked": true, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b", "quantityDeducted": 1}	2026-09-24 23:32:06.04+05:30	2026-09-24 23:32:06.042798+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
38e0fb46-1096-46f9-9eaa-6d338e20ae1b	11111111-1111-1111-1111-111111111111	PAYMENT	ca0ebda9-187c-4b47-9ff7-5ab6eca4dde9	CREATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	{"method": "UPI", "orderId": "900efa09-cbd9-4da9-8897-1b837e07b788", "amountMinor": "22850", "originalAction": "PAYMENT_RECORDED"}	2026-09-24 23:32:07.714+05:30	2026-09-24 23:32:07.605225+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
8996df38-8198-4028-847c-1beca8db62bc	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	49768e80-5cf1-47a9-be73-5f24de6fb26e	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 31, "stockQty": 30, "isStocked": true}	2026-09-24 23:33:03.017+05:30	2026-09-24 23:33:03.018233+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
31b266b9-5556-4996-ae08-09415686e86e	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	55a4f07d-dfd9-4ffe-987a-090f9fef31ce	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 30, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}	{"stockQty": 25, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 5}	2026-09-24 23:33:03.611+05:30	2026-09-24 23:33:03.614148+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
52ca3afc-bffc-4de7-b87a-850b5e1715f0	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	49768e80-5cf1-47a9-be73-5f24de6fb26e	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 33, "stockQty": 50, "isStocked": true}	2026-09-24 23:33:04.309+05:30	2026-09-24 23:33:04.309458+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
a895482e-5419-493f-a2de-cfc48206ba2d	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 12, "stockQty": 15, "isStocked": true}	2026-09-24 23:33:40.962+05:30	2026-09-24 23:33:40.963296+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
e0caa12b-5093-4463-b92f-bc1d2948fa9d	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	2a19d477-00a7-497b-a165-d5c5fc90d646	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 15, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b"}	{"stockQty": 12, "isStocked": true, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b", "quantityDeducted": 3}	2026-09-24 23:33:41.201+05:30	2026-09-24 23:33:41.203796+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
7b735a89-5b1d-4a38-866d-17ad259e1048	11111111-1111-1111-1111-111111111111	ORDER	300e3125-c13a-4c6f-9548-9d7ec596529f	OVERRIDE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"subtotal": "21000", "orderItemId": "2a19d477-00a7-497b-a165-d5c5fc90d646"}	{"reasonCode": "TEST_VOID", "originalAction": "ORDER_ITEM_VOIDED"}	2026-09-24 23:33:41.923+05:30	2026-09-24 23:33:41.908864+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	TEST_VOID	\N	\N
6823e1af-00d4-481b-a4ad-65e92a83e915	11111111-1111-1111-1111-111111111111	PORTION_RESTORED	2a19d477-00a7-497b-a165-d5c5fc90d646	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"stockQty": 12, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b"}	{"stockQty": 15, "isStocked": true, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b", "quantityRestored": 3}	2026-09-24 23:33:41.938+05:30	2026-09-24 23:33:41.940594+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	ITEM_VOIDED	\N	\N
7f2abf1e-0edf-4c05-abf5-a3545c32770a	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	510ebe7e-4bcf-48c7-83c2-aec32a9ca028	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 15, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b"}	{"stockQty": 0, "isStocked": false, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b", "quantityDeducted": 15}	2026-09-24 23:33:42.683+05:30	2026-09-24 23:33:42.685582+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
e4c0f831-f610-4b56-b6a0-892e5bedf96b	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 16, "stockQty": 50, "isStocked": true}	2026-09-24 23:33:43.425+05:30	2026-09-24 23:33:43.425688+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
1156c24a-1c23-459a-bd38-55016707522e	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	5b263a5a-26f4-472f-845a-5fd69f73c080	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 50, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}	{"stockQty": 48, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 2}	2026-09-24 23:48:18.607+05:30	2026-09-24 23:48:18.616282+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
7eb58375-2c97-4efd-9b59-cf397266b2b1	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	cbbe2f5a-f6a4-49f5-baad-6debdf4ff1bc	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 50, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b"}	{"stockQty": 49, "isStocked": true, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b", "quantityDeducted": 1}	2026-09-24 23:48:18.621+05:30	2026-09-24 23:48:18.631426+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
43aa6231-c0a1-4386-8d40-290280096d5e	11111111-1111-1111-1111-111111111111	PAYMENT	a222ff5e-23b7-4e6e-a8f3-12c00f0e6422	CREATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	{"method": "UPI", "orderId": "f4fbbe17-c9da-40cc-a954-1b9d7d1d6752", "amountMinor": "22850", "originalAction": "PAYMENT_RECORDED"}	2026-09-24 23:48:19.68+05:30	2026-09-24 23:48:19.636066+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
0fb803a2-3984-49e0-b9de-f1b071e35be6	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	1fb8d937-a0fc-44fd-81ca-6e2207dadb9c	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 48, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}	{"stockQty": 46, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 2}	2026-09-24 23:54:19.087+05:30	2026-09-24 23:54:19.096061+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
51e7232f-7cf9-4233-8284-b3098fb3dcf4	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	b3e785d1-2164-4e94-8dc8-c4adbe1c20a9	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 49, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b"}	{"stockQty": 48, "isStocked": true, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b", "quantityDeducted": 1}	2026-09-24 23:54:19.108+05:30	2026-09-24 23:54:19.116435+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
6e0327fe-0b8d-4cea-b6bd-d0ae8b441fb7	11111111-1111-1111-1111-111111111111	PAYMENT	84891eed-5586-45d1-9a1a-7480ec1fbdac	CREATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	{"method": "UPI", "orderId": "51ee39c7-53f2-40c4-adae-b49600c041f7", "amountMinor": "22850", "originalAction": "PAYMENT_RECORDED"}	2026-09-24 23:54:20.064+05:30	2026-09-24 23:54:20.030931+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
91139ed9-2faa-46f2-9245-255d6ddf3642	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	a4875a2e-6750-4304-9576-ab7968409a53	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 46, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}	{"stockQty": 44, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 2}	2026-09-25 00:07:00.771+05:30	2026-09-25 00:07:00.776564+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
8fb9150d-0367-467e-8511-2d36f56afdd4	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	bff83a34-d2e8-476c-b1bb-3b57ebed89bc	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 48, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b"}	{"stockQty": 47, "isStocked": true, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b", "quantityDeducted": 1}	2026-09-25 00:07:00.781+05:30	2026-09-25 00:07:00.785837+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
915f3d60-9379-4023-a064-ff7af97bbac6	11111111-1111-1111-1111-111111111111	PAYMENT	c1c63ef2-616d-4969-83c7-a06e66d1dfe0	CREATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	{"method": "UPI", "orderId": "3d9c934c-97d3-4da2-8f4b-4772896ee29b", "amountMinor": "22850", "originalAction": "PAYMENT_RECORDED"}	2026-09-25 00:07:01.771+05:30	2026-09-25 00:07:01.740051+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
27f92e96-e096-4343-81ba-0a483c11ee8a	11111111-1111-1111-1111-111111111111	DINING_TABLE	fc8127fc-a614-4ba2-ae4e-bc2fb91b2d3d	CREATE	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	{"reason": null, "memberIds": ["7f7e342f-0f6c-456c-9ec5-055de3ab87fe", "fc8127fc-a614-4ba2-ae4e-bc2fb91b2d3d"], "mergeGroupId": "915445b3-2d94-4f50-bbca-f80defd92721", "targetOrderId": null, "targetTableId": "fc8127fc-a614-4ba2-ae4e-bc2fb91b2d3d", "originalAction": "TABLE_MERGE", "sourceTableIds": ["7f7e342f-0f6c-456c-9ec5-055de3ab87fe"], "mergedOrdersCount": 0}	2026-10-02 16:33:05.137+05:30	2026-10-02 16:33:05.142181+05:30	\N	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N
7ae4a360-215e-40f7-a34f-0be0afd8aa0f	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	d72965dd-f095-4d00-bd19-5a0c011cdba5	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 44, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}	{"stockQty": 43, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 1}	2026-10-02 16:33:19.976+05:30	2026-10-02 16:33:19.978767+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
4939c8d8-12ec-4b4a-9df6-2bab5a18acee	11111111-1111-1111-1111-111111111111	PAYMENT	fb71c56e-dc81-441e-8966-044a67b49873	CREATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	{"method": "CASH", "orderId": "1469b1ab-dc07-49fd-979d-6393518fd684", "amountMinor": "17850", "originalAction": "PAYMENT_RECORDED"}	2026-10-02 16:57:54.807+05:30	2026-10-02 16:57:54.800306+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
b23d33e2-df27-4608-b216-cbcff07c238d	11111111-1111-1111-1111-111111111111	PAYMENT	e72b9222-2538-4405-8212-8b7f6a86de25	CREATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	{"method": "CASH", "orderId": "53494c1e-ee68-4197-b271-2a8c5f2bdb26", "amountMinor": "17850", "originalAction": "PAYMENT_RECORDED"}	2026-10-02 16:59:07.776+05:30	2026-10-02 16:59:07.7689+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
aea0131b-18a6-4181-b98b-73fea6e6779d	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	49768e80-5cf1-47a9-be73-5f24de6fb26e	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": true}	{"version": 38, "stockQty": 100, "isStocked": false}	2026-10-02 16:59:07.852+05:30	2026-10-02 16:59:07.852648+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
9957be72-0019-410d-8748-0e4d77c7032e	11111111-1111-1111-1111-111111111111	MENU_ITEM_86	49768e80-5cf1-47a9-be73-5f24de6fb26e	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"isStocked": false}	{"version": 39, "stockQty": 100, "isStocked": true}	2026-10-02 16:59:07.878+05:30	2026-10-02 16:59:07.878322+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
3adc7572-836c-417f-a60a-844cb0db28ba	11111111-1111-1111-1111-111111111111	ORDER	89dba099-01ad-417a-a438-66ca8af5e712	CREATE	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	{"items": [{"id": "3eafce2f-d57c-4570-a245-5ef7d50f502e", "quantity": 1, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404"}], "originalAction": "ORDER_ITEMS_ADDED"}	2026-10-03 01:21:15.995+05:30	2026-10-03 01:21:15.896974+05:30	\N	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N
d4b2f63b-2fa4-4b9f-9a5a-add0d79d862b	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	3eafce2f-d57c-4570-a245-5ef7d50f502e	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 92, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404"}	{"stockQty": 91, "isStocked": true, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404", "quantityDeducted": 1}	2026-10-03 01:21:16.173+05:30	2026-10-03 01:21:16.175058+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
fcecae8e-ab23-4587-a9ea-487fbe6252ab	11111111-1111-1111-1111-111111111111	PAYMENT	42dac6f1-9a73-40b8-893f-3f288857bc9d	CREATE	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	{"method": "CASH", "orderId": "89dba099-01ad-417a-a438-66ca8af5e712", "amountMinor": "11550", "originalAction": "PAYMENT_RECORDED"}	2026-10-03 01:21:43.091+05:30	2026-10-03 01:21:43.084656+05:30	\N	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N
bc41c66c-0a20-4f00-a2ad-24ffeacaf8b2	11111111-1111-1111-1111-111111111111	ORDER	7bf0131c-f022-46a1-9a7b-8569cd3682f8	CREATE	918df673-2606-403a-9fad-1c54870d1fce	\N	{"items": [{"id": "b83c41d5-9e92-403a-b6c0-87a0a665b16b", "quantity": 1, "menuItemId": "e0ffcd03-52ae-497b-9e57-1411888fde4f"}], "originalAction": "ORDER_ITEMS_ADDED"}	2026-10-03 01:22:43.875+05:30	2026-10-03 01:22:43.862119+05:30	\N	\N	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N
50d2219e-5a76-4b77-a1c3-d8890d90009a	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	b83c41d5-9e92-403a-b6c0-87a0a665b16b	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 100, "menuItemId": "e0ffcd03-52ae-497b-9e57-1411888fde4f"}	{"stockQty": 99, "isStocked": true, "menuItemId": "e0ffcd03-52ae-497b-9e57-1411888fde4f", "quantityDeducted": 1}	2026-10-03 01:22:43.926+05:30	2026-10-03 01:22:43.928097+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
cf9a6566-0e8e-4814-ab8c-061aca44e0ff	11111111-1111-1111-1111-111111111111	PAYMENT	0b8dbea6-ba1d-4949-89e8-c1a214c17ba0	CREATE	918df673-2606-403a-9fad-1c54870d1fce	\N	{"method": "CASH", "orderId": "7bf0131c-f022-46a1-9a7b-8569cd3682f8", "amountMinor": "76650", "originalAction": "PAYMENT_RECORDED"}	2026-10-03 01:23:42.479+05:30	2026-10-03 01:23:42.474021+05:30	\N	\N	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N
b009e987-d3dc-4c99-a61c-323f0d83f3fa	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	6c6a69ea-8662-406f-876e-4f380cf146ca	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 91, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404"}	{"stockQty": 90, "isStocked": true, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404", "quantityDeducted": 1}	2026-10-03 01:24:04.857+05:30	2026-10-03 01:24:04.862114+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
2f5f5de5-95f4-4313-a860-9e8b5d0b7860	11111111-1111-1111-1111-111111111111	PAYMENT	873136f3-1c61-40ec-b181-fa4226ac0bf3	CREATE	918df673-2606-403a-9fad-1c54870d1fce	\N	{"method": "CASH", "orderId": "af21c0cc-a9e8-459c-b797-ddb34bb7f724", "amountMinor": "6300", "originalAction": "PAYMENT_RECORDED"}	2026-10-03 01:24:19.992+05:30	2026-10-03 01:24:19.98786+05:30	\N	\N	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N
04a25213-cc05-4dfc-8049-dc243979e892	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	915f99a5-926b-4adb-8682-577cc4f59ecd	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 93, "menuItemId": "71451535-8d85-417f-b0ec-3f2b87016045"}	{"stockQty": 92, "isStocked": true, "menuItemId": "71451535-8d85-417f-b0ec-3f2b87016045", "quantityDeducted": 1}	2026-10-03 01:24:33.613+05:30	2026-10-03 01:24:33.617189+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
d262e962-1b71-4888-9b84-09b756ed9ede	11111111-1111-1111-1111-111111111111	PAYMENT	5f4ff1c4-7ea9-45e1-9fef-0f2b52fb5f34	CREATE	918df673-2606-403a-9fad-1c54870d1fce	\N	{"method": "CASH", "orderId": "b7899f9e-fd1e-4f77-89fc-0d935c2e2d85", "amountMinor": "8400", "originalAction": "PAYMENT_RECORDED"}	2026-10-03 01:24:33.824+05:30	2026-10-03 01:24:33.816442+05:30	\N	\N	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N
e0384522-5e78-4662-89a7-89298e9cd41a	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	b65a31aa-57c9-4fb4-9e07-e8c65470e9a2	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 90, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404"}	{"stockQty": 89, "isStocked": true, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404", "quantityDeducted": 1}	2026-10-03 01:25:42.634+05:30	2026-10-03 01:25:42.635622+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
6e53953a-309c-43d0-9aac-b1148f351814	11111111-1111-1111-1111-111111111111	PAYMENT	611a2b58-36c1-4b5e-ac48-8056d2494c34	CREATE	918df673-2606-403a-9fad-1c54870d1fce	\N	{"method": "CASH", "orderId": "c81161e9-bd67-474a-bf80-3b1756fe5393", "amountMinor": "6300", "originalAction": "PAYMENT_RECORDED"}	2026-10-03 01:26:31.102+05:30	2026-10-03 01:26:31.096611+05:30	\N	\N	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N
d8fce590-9352-4f5d-952c-826fe7970778	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	27374d9e-4b6a-4d6c-876b-ae552ee440ce	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 89, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404"}	{"stockQty": 88, "isStocked": true, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404", "quantityDeducted": 1}	2026-10-03 01:27:32.459+05:30	2026-10-03 01:27:32.461062+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
86a9f790-2109-4a71-acb5-4cbe45cbc11f	11111111-1111-1111-1111-111111111111	PAYMENT	9478e3c3-5069-427d-ab77-61ef848c4428	CREATE	918df673-2606-403a-9fad-1c54870d1fce	\N	{"method": "CASH", "orderId": "de5f32b6-72f6-441d-a98f-3f273e2a3bba", "amountMinor": "6300", "originalAction": "PAYMENT_RECORDED"}	2026-10-03 01:27:32.874+05:30	2026-10-03 01:27:32.868983+05:30	\N	\N	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N
8dd195e7-9890-4e10-b8c2-6aaa976e9847	11111111-1111-1111-1111-111111111111	ORDER	6dcda227-21c2-4291-918f-a3813a9062eb	CREATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	{"items": [{"id": "307df4ba-78be-4ad6-aaf4-c7242681a2b6", "quantity": 1, "menuItemId": "9e27f8db-5ca3-4d7f-97d4-aa3d87642452"}], "originalAction": "ORDER_ITEMS_ADDED"}	2026-10-03 04:36:17.776+05:30	2026-10-03 04:36:17.698378+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
1f318a5f-6ad4-4410-be98-1fdf70bb293d	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	307df4ba-78be-4ad6-aaf4-c7242681a2b6	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 100, "menuItemId": "9e27f8db-5ca3-4d7f-97d4-aa3d87642452"}	{"stockQty": 99, "isStocked": true, "menuItemId": "9e27f8db-5ca3-4d7f-97d4-aa3d87642452", "quantityDeducted": 1}	2026-10-03 04:36:17.883+05:30	2026-10-03 04:36:17.885474+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
8d47e6ac-49be-408a-9a10-41a7c5a6f791	11111111-1111-1111-1111-111111111111	PAYMENT	af4ad8f3-c209-497b-9376-f4ab3d7b489b	CREATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	{"method": "CASH", "orderId": "6dcda227-21c2-4291-918f-a3813a9062eb", "amountMinor": "16800", "originalAction": "PAYMENT_RECORDED"}	2026-10-03 04:38:00.162+05:30	2026-10-03 04:38:00.156527+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
74287e9a-3854-4b87-b13a-3b35e45391d1	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	88e411bf-b78b-4256-affa-96f95d4966b9	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 88, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404"}	{"stockQty": 87, "isStocked": true, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404", "quantityDeducted": 1}	2026-10-03 13:58:22.07+05:30	2026-10-03 13:58:22.074011+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
2943926e-17a6-48eb-a388-73e3aa49b1bb	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	703d14d7-845f-43ad-b1e7-2fc8b0b49558	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 87, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404"}	{"stockQty": 86, "isStocked": true, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404", "quantityDeducted": 1}	2026-10-03 14:00:38.445+05:30	2026-10-03 14:00:38.449135+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
8f5ed1c6-31f5-4c1b-871c-088d93817ba2	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	871c0130-7e2d-4e15-b263-b92acd7853b3	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 86, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404"}	{"stockQty": 85, "isStocked": true, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404", "quantityDeducted": 1}	2026-10-03 14:04:11.64+05:30	2026-10-03 14:04:11.645016+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
6f16a18f-2083-4af8-b60f-7894a4f90a9b	11111111-1111-1111-1111-111111111111	ORDER	6bb8a0c7-38c6-4f87-95a7-8edd80cbcfb6	CREATE	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	{"items": [{"id": "62a74f9e-22f5-4150-b319-bf95c6b64225", "quantity": 1, "menuItemId": "b45529e4-72e8-4c01-aed9-3106f2da6aeb"}], "originalAction": "ORDER_ITEMS_ADDED"}	2026-10-03 14:32:23.707+05:30	2026-10-03 14:32:23.242295+05:30	\N	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N
e6575d9f-c551-49fe-a050-c76672816f78	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	62a74f9e-22f5-4150-b319-bf95c6b64225	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 100, "menuItemId": "b45529e4-72e8-4c01-aed9-3106f2da6aeb"}	{"stockQty": 99, "isStocked": true, "menuItemId": "b45529e4-72e8-4c01-aed9-3106f2da6aeb", "quantityDeducted": 1}	2026-10-03 14:32:24.053+05:30	2026-10-03 14:32:24.055058+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
e0f837c5-68ef-4be3-bafd-450e7e72bbbb	11111111-1111-1111-1111-111111111111	ORDER	6040a630-394f-416c-9b97-8deef80f81f8	OVERRIDE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"subtotal": "6000", "orderItemId": "871c0130-7e2d-4e15-b263-b92acd7853b3"}	{"reasonCode": "hh", "originalAction": "ORDER_ITEM_VOIDED"}	2026-10-03 14:43:49.584+05:30	2026-10-03 14:43:49.566814+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	hh	\N	\N
63db88f7-4298-43cd-97d7-78d292818bde	11111111-1111-1111-1111-111111111111	PORTION_RESTORED	871c0130-7e2d-4e15-b263-b92acd7853b3	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"stockQty": 85, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404"}	{"stockQty": 86, "isStocked": true, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404", "quantityRestored": 1}	2026-10-03 14:43:49.625+05:30	2026-10-03 14:43:49.627382+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	ITEM_VOIDED	\N	\N
3beaa7cc-a232-4756-831d-cb1d48bbc30e	11111111-1111-1111-1111-111111111111	ORDER	6040a630-394f-416c-9b97-8deef80f81f8	CREATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	{"items": [{"id": "8d2c89b6-3bb0-4248-87e9-7b363ef8c95d", "quantity": 1, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404"}], "originalAction": "ORDER_ITEMS_ADDED"}	2026-10-03 14:44:05.713+05:30	2026-10-03 14:44:05.695494+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
68ead872-0460-4050-9d38-c04759b0a589	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	8d2c89b6-3bb0-4248-87e9-7b363ef8c95d	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 86, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404"}	{"stockQty": 85, "isStocked": true, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404", "quantityDeducted": 1}	2026-10-03 14:44:05.773+05:30	2026-10-03 14:44:05.776495+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
bd7370ef-fa6b-452e-b8c8-27422e76ea04	11111111-1111-1111-1111-111111111111	ORDER	6040a630-394f-416c-9b97-8deef80f81f8	OVERRIDE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"subtotal": "6000", "orderItemId": "8d2c89b6-3bb0-4248-87e9-7b363ef8c95d"}	{"reasonCode": "kk", "originalAction": "ORDER_ITEM_VOIDED"}	2026-10-03 14:44:22.147+05:30	2026-10-03 14:44:22.129063+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	kk	\N	\N
f890584f-e1a5-47d2-91af-1a6c9b32cf03	11111111-1111-1111-1111-111111111111	PORTION_RESTORED	8d2c89b6-3bb0-4248-87e9-7b363ef8c95d	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"stockQty": 85, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404"}	{"stockQty": 86, "isStocked": true, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404", "quantityRestored": 1}	2026-10-03 14:44:22.17+05:30	2026-10-03 14:44:22.172375+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	ITEM_VOIDED	\N	\N
ea527b7d-afc9-4a61-a8b3-774ed1f3159b	11111111-1111-1111-1111-111111111111	ORDER	5736ba49-2b3d-47e0-b162-575f81bbd62c	CREATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	{"items": [{"id": "b5f819e0-de5b-40eb-b9c2-79ad5d991c93", "quantity": 1, "menuItemId": "88ec151b-ebde-4993-809f-79f7e29a4385"}], "originalAction": "ORDER_ITEMS_ADDED"}	2026-10-03 14:44:58.628+05:30	2026-10-03 14:44:58.616004+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N
fbf9c820-f85d-4e52-8344-db301ce2b610	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	b5f819e0-de5b-40eb-b9c2-79ad5d991c93	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 100, "menuItemId": "88ec151b-ebde-4993-809f-79f7e29a4385"}	{"stockQty": 99, "isStocked": true, "menuItemId": "88ec151b-ebde-4993-809f-79f7e29a4385", "quantityDeducted": 1}	2026-10-03 14:44:58.669+05:30	2026-10-03 14:44:58.670757+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
4b71bca6-0d06-46d4-b1a9-5dca18110e11	11111111-1111-1111-1111-111111111111	ORDER	5736ba49-2b3d-47e0-b162-575f81bbd62c	OVERRIDE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"subtotal": "3500", "orderItemId": "b5f819e0-de5b-40eb-b9c2-79ad5d991c93"}	{"reasonCode": "noo", "originalAction": "ORDER_ITEM_VOIDED"}	2026-10-03 14:46:00.293+05:30	2026-10-03 14:46:00.263035+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	noo	\N	\N
3cf9262b-1ad6-4f2d-9926-84b1a3789fa1	11111111-1111-1111-1111-111111111111	PORTION_RESTORED	b5f819e0-de5b-40eb-b9c2-79ad5d991c93	UPDATE	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	{"stockQty": 99, "menuItemId": "88ec151b-ebde-4993-809f-79f7e29a4385"}	{"stockQty": 100, "isStocked": true, "menuItemId": "88ec151b-ebde-4993-809f-79f7e29a4385", "quantityRestored": 1}	2026-10-03 14:46:00.311+05:30	2026-10-03 14:46:00.312399+05:30	\N	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	ITEM_VOIDED	\N	\N
09678985-4d6e-4ef8-a874-a436c9f47da7	11111111-1111-1111-1111-111111111111	PORTION_DEPLETED	ecccb59e-9f4e-45ec-9e36-afa847b2671c	UPDATE	11111111-1111-1111-1111-111111111111	{"stockQty": 99, "menuItemId": "e0ffcd03-52ae-497b-9e57-1411888fde4f"}	{"stockQty": 97, "isStocked": true, "menuItemId": "e0ffcd03-52ae-497b-9e57-1411888fde4f", "quantityDeducted": 2}	2026-10-03 15:10:55.296+05:30	2026-10-03 15:10:55.303447+05:30	\N	\N	11111111-1111-1111-1111-111111111111	ORDER_PLACED	\N	\N
fcc04cf5-a57e-4792-bd56-3c031713ac23	11111111-1111-1111-1111-111111111111	USER	9b35fd7a-2717-4837-ad91-9328aee9ec5f	CREATE	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	{"handoverId": "52c305c8-f7dc-45b0-9f2f-5b8502512825", "reasonCode": "SHIFT_HANDOVER", "waiterName": "Rahul Kumar", "managerNotes": "Captain Shift Handover: Rahul Kumar. Net tip payout: ₹0.00, Denominations: 500x0, 200x0, 100x0, 50x0, 20x0, 10x0, 5x0, Coins: ₹0", "cashSalesMinor": 0, "originalAction": "waiter.shift_handover", "digitalTipsMinor": 0, "netTipPayoutMinor": 0, "openingFloatMinor": 50000, "serviceChargeMinor": 0, "actualCashCountedMinor": 0}	2026-10-06 01:23:39.192+05:30	2026-10-06 01:23:39.193274+05:30	\N	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f	SHIFT_HANDOVER	\N	\N
\.


--
-- Data for Name: audit_logs_y2026m08; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.audit_logs_y2026m08 (id, outlet_id, entity_type, entity_id, action, actor_id, before_state, after_state, created_at, updated_at, created_by, updated_by, user_id, reason_code, approver_user_id, ip_address) FROM stdin;
\.


--
-- Data for Name: availability_schedules; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.availability_schedules (id, outlet_id, item_id, day_of_week, start_time, end_time, created_at, updated_at, created_by, updated_by, is_active, category_id) FROM stdin;
\.


--
-- Data for Name: backup_jobs; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.backup_jobs (id, outlet_id, job_type, destination, status, started_at, finished_at, error_message, created_at) FROM stdin;
\.


--
-- Data for Name: campaign_recipients; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.campaign_recipients (id, campaign_id, customer_id, status, sent_at, error_message, created_at) FROM stdin;
53d71ffb-4713-44a2-ac93-d5c696981dc0	1c31b540-9540-4b01-aadb-f98054d07106	1fd9473f-93e8-4a70-bea9-9a7d72cde1d1	PENDING	\N	\N	2026-09-03 12:29:17.460273+05:30
752af4bd-2e50-46bf-b556-df59b8b3bbd2	1c31b540-9540-4b01-aadb-f98054d07106	fb30d042-2284-4197-b74f-a0a418db5f68	PENDING	\N	\N	2026-09-03 12:29:17.463425+05:30
d8b2a656-7c13-4569-a396-700f45391419	1c31b540-9540-4b01-aadb-f98054d07106	088b94c5-d3ea-4cbd-b229-b47ac1c33b21	PENDING	\N	\N	2026-09-03 12:29:17.465327+05:30
\.


--
-- Data for Name: cash_drawer_sessions; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.cash_drawer_sessions (id, outlet_id, opened_by, closed_by, opened_at, closed_at, opening_balance_minor, expected_close_balance_minor, actual_close_balance_minor, discrepancy_minor, status, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.categories (id, outlet_id, parent_id, name, sort_order, is_active, created_at, updated_at, created_by, updated_by) FROM stdin;
60d4a197-f11c-4267-a7de-92220a27dc4b	67315042-c687-4cbb-b45a-f4ea4efc199f	\N	Biryani (Veg)	1	t	2026-09-02 16:19:54.57163+05:30	2026-09-02 16:19:54.57163+05:30	\N	\N
8fcde4bd-6deb-4827-b69b-f748741f5aea	67315042-c687-4cbb-b45a-f4ea4efc199f	\N	Biryani (Non-Veg)	2	t	2026-09-02 16:19:54.57163+05:30	2026-09-02 16:19:54.57163+05:30	\N	\N
12251ad8-147d-463e-a33a-30daa7aaabf7	67315042-c687-4cbb-b45a-f4ea4efc199f	\N	Tandoori Starters (Non-Veg)	3	t	2026-09-02 16:19:54.57163+05:30	2026-09-02 16:19:54.57163+05:30	\N	\N
f718f498-932d-49f6-8b6b-59a29a37e49e	67315042-c687-4cbb-b45a-f4ea4efc199f	\N	Chinese Starters (Veg)	4	t	2026-09-02 16:19:54.57163+05:30	2026-09-02 16:19:54.57163+05:30	\N	\N
afca0de8-7edc-4f29-93a4-17fcdce5e27e	67315042-c687-4cbb-b45a-f4ea4efc199f	\N	Curries (Non-Veg)	5	t	2026-09-02 16:19:54.57163+05:30	2026-09-02 16:19:54.57163+05:30	\N	\N
a49cfb2b-5641-43b5-ae43-96d0d1b55be1	67315042-c687-4cbb-b45a-f4ea4efc199f	\N	Roti & Breads	6	t	2026-09-02 16:19:54.57163+05:30	2026-09-02 16:19:54.57163+05:30	\N	\N
2a4082ac-2df2-422b-b7f9-cf96755949f3	67315042-c687-4cbb-b45a-f4ea4efc199f	\N	Cold Beverage	7	t	2026-09-02 16:19:54.57163+05:30	2026-09-02 16:19:54.57163+05:30	\N	\N
735379c7-6bd9-4ed0-be64-40d8bf1e7de8	67315042-c687-4cbb-b45a-f4ea4efc199f	\N	MOCKTAILS	8	t	2026-09-02 16:19:54.57163+05:30	2026-09-02 16:19:54.57163+05:30	\N	\N
68413038-40bc-4f99-988e-7a72c60094e0	2a543c3c-066f-4097-833a-df7c25700580	\N	Breakfast	1	t	2026-09-02 17:55:52.062806+05:30	2026-09-02 17:55:52.062806+05:30	\N	\N
bd5fd925-8442-4a2c-b952-de8a4e0181ee	2a543c3c-066f-4097-833a-df7c25700580	\N	Meal Box (Online)	2	t	2026-09-02 17:55:52.062806+05:30	2026-09-02 17:55:52.062806+05:30	\N	\N
814499c3-e704-42df-89ab-5bc9806e2089	2a543c3c-066f-4097-833a-df7c25700580	\N	Cold Beverage	3	t	2026-09-02 17:55:52.062806+05:30	2026-09-02 17:55:52.062806+05:30	\N	\N
da1e0528-b69e-4eaf-b3cc-62429b61e75e	2a543c3c-066f-4097-833a-df7c25700580	\N	Hot Beverages	4	t	2026-09-02 17:55:52.062806+05:30	2026-09-02 17:55:52.062806+05:30	\N	\N
b8c64dd2-0140-44b4-a64b-aae3c6c2c9d5	2a543c3c-066f-4097-833a-df7c25700580	\N	Soup(Veg)	5	t	2026-09-02 17:55:52.062806+05:30	2026-09-02 17:55:52.062806+05:30	\N	\N
6ad7a5cf-0734-45b4-a171-aaeba1c44c95	2a543c3c-066f-4097-833a-df7c25700580	\N	Meals	6	t	2026-09-02 17:55:52.062806+05:30	2026-09-02 17:55:52.062806+05:30	\N	\N
0a99d107-4268-42ed-9f87-a57b16d450e7	2a543c3c-066f-4097-833a-df7c25700580	\N	Chinese Starters (Veg)	7	t	2026-09-02 17:55:52.062806+05:30	2026-09-02 17:55:52.062806+05:30	\N	\N
0b64120a-6ded-4c63-9a87-8dbafd81a1bc	2a543c3c-066f-4097-833a-df7c25700580	\N	Curries (Veg)	8	t	2026-09-02 17:55:52.062806+05:30	2026-09-02 17:55:52.062806+05:30	\N	\N
ccdac5f4-9e06-4d17-9212-df78bbb3ef2e	67315042-c687-4cbb-b45a-f4ea4efc199f	\N	Curries (Veg)	0	t	2026-09-05 13:03:58.83811+05:30	2026-09-05 13:03:58.83811+05:30	\N	\N
ff151b4d-9fe3-4ab1-a0f6-d803109ee432	67315042-c687-4cbb-b45a-f4ea4efc199f	\N	Meals	0	t	2026-09-05 13:03:58.83811+05:30	2026-09-05 13:03:58.83811+05:30	\N	\N
6b47802d-d31d-4d52-9c5e-001f4674f85e	67315042-c687-4cbb-b45a-f4ea4efc199f	\N	Breakfast	0	t	2026-09-05 13:03:58.83811+05:30	2026-09-05 13:03:58.83811+05:30	\N	\N
de6e8b83-db5a-4c10-b432-6b5a66959cc4	67315042-c687-4cbb-b45a-f4ea4efc199f	\N	Hot Beverages	0	t	2026-09-05 13:03:58.83811+05:30	2026-09-05 13:03:58.83811+05:30	\N	\N
2553c114-60e6-4ffd-a050-c41a6c3bf846	67315042-c687-4cbb-b45a-f4ea4efc199f	\N	Soup(Veg)	0	t	2026-09-05 13:03:58.83811+05:30	2026-09-05 13:03:58.83811+05:30	\N	\N
1541649d-c982-46a7-a228-ad78aba10f6c	67315042-c687-4cbb-b45a-f4ea4efc199f	\N	Meal Box (Online)	0	t	2026-09-05 13:03:58.83811+05:30	2026-09-05 13:03:58.83811+05:30	\N	\N
9f32e838-0597-41ad-97d7-6412c26afe7b	2a543c3c-066f-4097-833a-df7c25700580	\N	Curries (Non-Veg)	0	t	2026-09-05 13:03:58.83811+05:30	2026-09-05 13:03:58.83811+05:30	\N	\N
e10d567d-babb-4e94-a79a-eb3a48de4812	2a543c3c-066f-4097-833a-df7c25700580	\N	Biryani (Veg)	0	t	2026-09-05 13:03:58.83811+05:30	2026-09-05 13:03:58.83811+05:30	\N	\N
a976ef06-5bbd-4e1a-ba06-59ac9b0a6b84	2a543c3c-066f-4097-833a-df7c25700580	\N	MOCKTAILS	0	t	2026-09-05 13:03:58.83811+05:30	2026-09-05 13:03:58.83811+05:30	\N	\N
630f03b9-480d-4107-84e1-57e43df0a45e	2a543c3c-066f-4097-833a-df7c25700580	\N	Roti & Breads	0	t	2026-09-05 13:03:58.83811+05:30	2026-09-05 13:03:58.83811+05:30	\N	\N
e4b000a5-48de-44ba-bf02-3929b1f75c89	2a543c3c-066f-4097-833a-df7c25700580	\N	Tandoori Starters (Non-Veg)	0	t	2026-09-05 13:03:58.83811+05:30	2026-09-05 13:03:58.83811+05:30	\N	\N
7e99f115-5a4e-404a-880d-118faff89110	2a543c3c-066f-4097-833a-df7c25700580	\N	Biryani (Non-Veg)	0	t	2026-09-05 13:03:58.83811+05:30	2026-09-05 13:03:58.83811+05:30	\N	\N
c332c03a-b4ff-4db0-b13f-b241c651abc8	11111111-1111-1111-1111-111111111111	\N	Chinese Starters (Veg)	0	t	2026-09-05 13:03:58.83811+05:30	2026-09-05 13:03:58.83811+05:30	\N	\N
9923f0e7-8519-4e37-af76-137a8781e285	11111111-1111-1111-1111-111111111111	\N	Curries (Non-Veg)	0	t	2026-09-05 13:03:58.83811+05:30	2026-09-05 13:03:58.83811+05:30	\N	\N
e18291bb-1c6d-426d-a753-c58922a38598	11111111-1111-1111-1111-111111111111	\N	Biryani (Veg)	0	t	2026-09-05 13:03:58.83811+05:30	2026-09-05 13:03:58.83811+05:30	\N	\N
226608d8-4b01-406d-a0bc-3da3381efd44	11111111-1111-1111-1111-111111111111	\N	MOCKTAILS	0	t	2026-09-05 13:03:58.83811+05:30	2026-09-05 13:03:58.83811+05:30	\N	\N
ef059e72-0460-4ec5-8faf-ca1bd16ce17e	11111111-1111-1111-1111-111111111111	\N	Roti & Breads	0	t	2026-09-05 13:03:58.83811+05:30	2026-09-05 13:03:58.83811+05:30	\N	\N
1a8e9f1a-9874-41b3-b04e-dcff9cbd9c52	11111111-1111-1111-1111-111111111111	\N	Curries (Veg)	0	t	2026-09-05 13:03:58.83811+05:30	2026-09-05 13:03:58.83811+05:30	\N	\N
ecde6efc-8c90-4e6c-bac7-c30e1a98089c	11111111-1111-1111-1111-111111111111	\N	Meals	0	t	2026-09-05 13:03:58.83811+05:30	2026-09-05 13:03:58.83811+05:30	\N	\N
bc2819ef-3f7e-4c79-a692-bb059757eeae	11111111-1111-1111-1111-111111111111	\N	Cold Beverage	0	t	2026-09-05 13:03:58.83811+05:30	2026-09-05 13:03:58.83811+05:30	\N	\N
a65ebbc1-bfb6-42ce-95cf-112d5a76e825	11111111-1111-1111-1111-111111111111	\N	Breakfast	0	t	2026-09-05 13:03:58.83811+05:30	2026-09-05 13:03:58.83811+05:30	\N	\N
00e25236-2c50-4e2b-818d-88c104db92bb	11111111-1111-1111-1111-111111111111	\N	Tandoori Starters (Non-Veg)	0	t	2026-09-05 13:03:58.83811+05:30	2026-09-05 13:03:58.83811+05:30	\N	\N
764ab8d6-7220-4bfb-bb9f-23f7d804bc71	11111111-1111-1111-1111-111111111111	\N	Hot Beverages	0	t	2026-09-05 13:03:58.83811+05:30	2026-09-05 13:03:58.83811+05:30	\N	\N
c6d92d2d-adeb-4d91-b143-097e7b3ef69a	11111111-1111-1111-1111-111111111111	\N	Soup(Veg)	0	t	2026-09-05 13:03:58.83811+05:30	2026-09-05 13:03:58.83811+05:30	\N	\N
26fd5701-0ca8-4a3d-8a30-706cca828e47	11111111-1111-1111-1111-111111111111	\N	Biryani (Non-Veg)	0	t	2026-09-05 13:03:58.83811+05:30	2026-09-05 13:03:58.83811+05:30	\N	\N
638dcd56-a022-462a-aacc-125069c4a2ad	11111111-1111-1111-1111-111111111111	\N	Meal Box (Online)	0	t	2026-09-05 13:03:58.83811+05:30	2026-09-05 13:03:58.83811+05:30	\N	\N
\.


--
-- Data for Name: channel_accounts; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.channel_accounts (id, outlet_id, integration_id, external_outlet_id, credentials_ref, is_active, created_at, updated_at, created_by, updated_by) FROM stdin;
fd002d2b-3ba9-456e-bd66-5479c535612f	67315042-c687-4cbb-b45a-f4ea4efc199f	a0b27e38-ffc0-4967-b3e5-7bedd6210fab	SW-KAPILA-01	swiggy_production_v2	t	2026-09-03 12:29:17.406338+05:30	2026-09-03 12:29:17.406338+05:30	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N
ec610d2c-357c-4945-a383-5f734846d834	67315042-c687-4cbb-b45a-f4ea4efc199f	c185eb00-4dcd-4f32-b700-39c5d5f9429c	ZM-KAPILA-01	zomato_merchant_v1	t	2026-09-03 12:29:17.410303+05:30	2026-09-03 12:29:17.410303+05:30	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N
\.


--
-- Data for Name: channel_item_mapping; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.channel_item_mapping (id, outlet_id, channel_account_id, item_id, external_item_id, created_at, updated_at, created_by, updated_by, channel_code, version) FROM stdin;
422ec885-18a2-4b5b-87c0-e3f067455394	67315042-c687-4cbb-b45a-f4ea4efc199f	fd002d2b-3ba9-456e-bd66-5479c535612f	1048c560-86bd-45c5-b872-eb5e802c6e46	EXT-HOTE-1048	2026-09-03 12:29:17.422378+05:30	2026-09-03 12:29:17.422378+05:30	\N	\N	MENU_V1	1
63de6c4e-65e1-425a-ab39-29bea04ced57	67315042-c687-4cbb-b45a-f4ea4efc199f	fd002d2b-3ba9-456e-bd66-5479c535612f	c4945f10-ab36-4a6a-8388-0a0c4904d9da	EXT-HYDE-c494	2026-09-03 12:29:17.427344+05:30	2026-09-03 12:29:17.427344+05:30	\N	\N	MENU_V1	1
04a480c3-a24c-441c-a7c1-42442b4d41fa	67315042-c687-4cbb-b45a-f4ea4efc199f	fd002d2b-3ba9-456e-bd66-5479c535612f	7455214f-4d3e-495e-a9eb-9a13cda64003	EXT-MURG-7455	2026-09-03 12:29:17.429184+05:30	2026-09-03 12:29:17.429184+05:30	\N	\N	MENU_V1	1
dd83ca61-0e2d-4298-bdaf-f75834604bbf	67315042-c687-4cbb-b45a-f4ea4efc199f	fd002d2b-3ba9-456e-bd66-5479c535612f	c1f09997-5bb1-4ee9-abb6-9b622c2c8e91	EXT-KAPI-c1f0	2026-09-03 12:29:17.430812+05:30	2026-09-03 12:29:17.430812+05:30	\N	\N	MENU_V1	1
eed9caf6-5318-4008-a5cd-b8431ef39386	67315042-c687-4cbb-b45a-f4ea4efc199f	fd002d2b-3ba9-456e-bd66-5479c535612f	cdc12a71-3f32-4630-ab8b-059ae196af2c	EXT-BUTT-cdc1	2026-09-03 12:29:17.432491+05:30	2026-09-03 12:29:17.432491+05:30	\N	\N	MENU_V1	1
d1692882-f9ce-4326-be85-83fada177810	67315042-c687-4cbb-b45a-f4ea4efc199f	ec610d2c-357c-4945-a383-5f734846d834	1048c560-86bd-45c5-b872-eb5e802c6e46	EXT-HOTE-1048	2026-09-03 12:29:17.434107+05:30	2026-09-03 12:29:17.434107+05:30	\N	\N	MENU_V1	1
590a5571-a53b-4e75-b369-cadb0b08befb	67315042-c687-4cbb-b45a-f4ea4efc199f	ec610d2c-357c-4945-a383-5f734846d834	c4945f10-ab36-4a6a-8388-0a0c4904d9da	EXT-HYDE-c494	2026-09-03 12:29:17.435943+05:30	2026-09-03 12:29:17.435943+05:30	\N	\N	MENU_V1	1
0f192c51-445b-4e1f-bb17-0d5314ccc84b	67315042-c687-4cbb-b45a-f4ea4efc199f	ec610d2c-357c-4945-a383-5f734846d834	7455214f-4d3e-495e-a9eb-9a13cda64003	EXT-MURG-7455	2026-09-03 12:29:17.437848+05:30	2026-09-03 12:29:17.437848+05:30	\N	\N	MENU_V1	1
63f29961-082e-47d3-918e-87260ff5972d	67315042-c687-4cbb-b45a-f4ea4efc199f	ec610d2c-357c-4945-a383-5f734846d834	c1f09997-5bb1-4ee9-abb6-9b622c2c8e91	EXT-KAPI-c1f0	2026-09-03 12:29:17.439411+05:30	2026-09-03 12:29:17.439411+05:30	\N	\N	MENU_V1	1
2ff1e6a7-7460-4bf3-b34b-b7c69cca5e2b	67315042-c687-4cbb-b45a-f4ea4efc199f	ec610d2c-357c-4945-a383-5f734846d834	cdc12a71-3f32-4630-ab8b-059ae196af2c	EXT-BUTT-cdc1	2026-09-03 12:29:17.440883+05:30	2026-09-03 12:29:17.440883+05:30	\N	\N	MENU_V1	1
a5a18871-4bb4-4929-b338-f5288056e2ea	67315042-c687-4cbb-b45a-f4ea4efc199f	fd002d2b-3ba9-456e-bd66-5479c535612f	8772f56e-a632-4998-ae87-45084349bf9f	EXT-(2) -8772	2026-09-05 13:04:10.699634+05:30	2026-09-05 13:04:10.699634+05:30	\N	\N	MENU_V1	1
7d937772-6e8b-4d86-8c03-f3453a38ebcf	67315042-c687-4cbb-b45a-f4ea4efc199f	fd002d2b-3ba9-456e-bd66-5479c535612f	47dce856-d45e-41a3-a7de-84a823aa6d5a	EXT-(S) -47dc	2026-09-05 13:04:10.702992+05:30	2026-09-05 13:04:10.702992+05:30	\N	\N	MENU_V1	1
c632fe97-4b7a-40b5-9358-5fe6ee136c88	67315042-c687-4cbb-b45a-f4ea4efc199f	fd002d2b-3ba9-456e-bd66-5479c535612f	81f170e9-ad77-44a9-b8dc-7a7d4a2b84cc	EXT-(S) -81f1	2026-09-05 13:04:10.705028+05:30	2026-09-05 13:04:10.705028+05:30	\N	\N	MENU_V1	1
15402192-7ce6-4680-8acd-dcb1937a301d	67315042-c687-4cbb-b45a-f4ea4efc199f	fd002d2b-3ba9-456e-bd66-5479c535612f	c97c9587-1c8d-4421-abc4-65e15db4bc81	EXT-(S) -c97c	2026-09-05 13:04:10.706693+05:30	2026-09-05 13:04:10.706693+05:30	\N	\N	MENU_V1	1
1b0fed67-1ddf-4261-b2cc-a85c8d32f227	67315042-c687-4cbb-b45a-f4ea4efc199f	fd002d2b-3ba9-456e-bd66-5479c535612f	9e6b5249-048d-4aeb-a0b6-acfd8f6a8501	EXT-(S) -9e6b	2026-09-05 13:04:10.708324+05:30	2026-09-05 13:04:10.708324+05:30	\N	\N	MENU_V1	1
0e02820a-266c-4b52-ba23-710cf110f56d	67315042-c687-4cbb-b45a-f4ea4efc199f	ec610d2c-357c-4945-a383-5f734846d834	8772f56e-a632-4998-ae87-45084349bf9f	EXT-(2) -8772	2026-09-05 13:04:10.713073+05:30	2026-09-05 13:04:10.713073+05:30	\N	\N	MENU_V1	1
9a064db7-c04f-4099-80ae-b89593b2fcbb	67315042-c687-4cbb-b45a-f4ea4efc199f	ec610d2c-357c-4945-a383-5f734846d834	47dce856-d45e-41a3-a7de-84a823aa6d5a	EXT-(S) -47dc	2026-09-05 13:04:10.714892+05:30	2026-09-05 13:04:10.714892+05:30	\N	\N	MENU_V1	1
c6426f61-2758-43ba-ac28-ef704f037b5a	67315042-c687-4cbb-b45a-f4ea4efc199f	ec610d2c-357c-4945-a383-5f734846d834	81f170e9-ad77-44a9-b8dc-7a7d4a2b84cc	EXT-(S) -81f1	2026-09-05 13:04:10.71633+05:30	2026-09-05 13:04:10.71633+05:30	\N	\N	MENU_V1	1
ee2eb1b2-2dae-4ba3-b74c-6047c7f0323d	67315042-c687-4cbb-b45a-f4ea4efc199f	ec610d2c-357c-4945-a383-5f734846d834	c97c9587-1c8d-4421-abc4-65e15db4bc81	EXT-(S) -c97c	2026-09-05 13:04:10.717789+05:30	2026-09-05 13:04:10.717789+05:30	\N	\N	MENU_V1	1
3c5195ff-81e9-466f-9ece-8c2d8085fdf3	67315042-c687-4cbb-b45a-f4ea4efc199f	ec610d2c-357c-4945-a383-5f734846d834	9e6b5249-048d-4aeb-a0b6-acfd8f6a8501	EXT-(S) -9e6b	2026-09-05 13:04:10.719263+05:30	2026-09-05 13:04:10.719263+05:30	\N	\N	MENU_V1	1
\.


--
-- Data for Name: channel_sync_log; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.channel_sync_log (id, outlet_id, order_id, channel, target, direction, status, payload, response, attempted_at, error_message) FROM stdin;
\.


--
-- Data for Name: configuration_changes_default; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.configuration_changes_default (id, outlet_id, config_key, old_value, new_value, actor_id, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: configuration_changes_y2026m08; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.configuration_changes_y2026m08 (id, outlet_id, config_key, old_value, new_value, actor_id, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: customer_addresses; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.customer_addresses (id, customer_id, label, line1, line2, city, postal_code, latitude, longitude, is_default, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: customer_tags; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.customer_tags (id, customer_id, tag, source, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.customers (id, organization_id, phone, name, email, consent_marketing, consent_data_sharing, consent_recorded_at, is_active, created_at, updated_at, created_by, updated_by, outlet_id, first_name, last_name, loyalty_points, birth_date) FROM stdin;
724eba8c-0924-4006-9ddb-ca86aa4e96eb	00000000-0000-0000-0000-000000000000	9898998988	amjad	\N	f	f	\N	t	2026-09-12 11:38:00.631+05:30	2026-09-12 11:38:00.631+05:30	\N	\N	11111111-1111-1111-1111-111111111111	amjad	\N	0	\N
1fd9473f-93e8-4a70-bea9-9a7d72cde1d1	00000000-0000-0000-0000-000000000000	9988776655	\N	arjun.reddy@example.com	f	f	\N	t	2026-09-02 16:26:46.886+05:30	2026-09-12 11:57:16.522+05:30	\N	\N	67315042-c687-4cbb-b45a-f4ea4efc199f	Arjun	Reddy	500	\N
fb30d042-2284-4197-b74f-a0a418db5f68	00000000-0000-0000-0000-000000000000	9876543212	\N	priya.sharma@example.com	f	f	\N	t	2026-09-02 16:26:46.893+05:30	2026-09-12 11:57:16.543+05:30	\N	\N	67315042-c687-4cbb-b45a-f4ea4efc199f	Priya	Sharma	1200	\N
088b94c5-d3ea-4cbd-b229-b47ac1c33b21	00000000-0000-0000-0000-000000000000	9123456789	\N	rahul.k@example.com	f	f	\N	t	2026-09-02 16:26:46.897+05:30	2026-09-12 11:57:16.55+05:30	\N	\N	67315042-c687-4cbb-b45a-f4ea4efc199f	Rahul	Kumar	0	\N
c158b890-ee02-405e-bfb2-57b349e6eeb3	00000000-0000-0000-0000-000000000000	9777027509	Zara Khan	zara@test.com	f	f	\N	t	2026-09-12 12:03:15.675+05:30	2026-09-12 12:03:15.675+05:30	\N	\N	11111111-1111-1111-1111-111111111111	Zara	Khan	100	\N
509bcc9b-7529-497d-b987-29ee463cf67e	00000000-0000-0000-0000-000000000000	1231231233	annuj	\N	f	f	\N	t	2026-09-12 12:16:21.114+05:30	2026-09-12 12:16:21.114+05:30	\N	\N	11111111-1111-1111-1111-111111111111	annuj	\N	50	\N
79101d18-2063-4b11-99d8-ed5d17667003	\N	+919876543299	Kavita Rao	\N	f	f	\N	t	2026-09-15 15:20:21.6+05:30	2026-09-15 15:20:21.6+05:30	\N	\N	67315042-c687-4cbb-b45a-f4ea4efc199f	Kavita	Rao	0	\N
7a9b6880-e4d0-4ef7-9708-e81e8e76c7b8	\N	+919876543201	Aarav Sharma	\N	f	f	\N	t	2026-09-15 15:22:15.308+05:30	2026-09-15 15:22:15.308+05:30	\N	\N	67315042-c687-4cbb-b45a-f4ea4efc199f	Aarav	Sharma	0	\N
e43347e2-c5bc-4195-af72-f615b5bd81c4	\N	+919876543202	Deepika Padukone	\N	f	f	\N	t	2026-09-15 15:26:49.315+05:30	2026-09-15 15:26:49.315+05:30	\N	\N	67315042-c687-4cbb-b45a-f4ea4efc199f	Deepika	Padukone	0	\N
d5d508df-1b81-4d7e-a491-b70f0a42ad6e	00000000-0000-0000-0000-000000000000	9876543210	Sanjay Singhania	\N	f	f	\N	t	2026-09-24 23:33:03.049+05:30	2026-09-24 23:33:03.049+05:30	\N	\N	11111111-1111-1111-1111-111111111111	\N	\N	0	\N
f161c4a6-d9ec-4087-a82b-23c35fb2ee53	00000000-0000-0000-0000-000000000000	9595455844	asad	\N	f	f	\N	t	2026-10-03 14:00:38.23+05:30	2026-10-03 14:00:38.23+05:30	\N	\N	11111111-1111-1111-1111-111111111111	\N	\N	0	\N
470aeef0-83a1-4ea2-a1fb-8f33a821ce32	00000000-0000-0000-0000-000000000000	2323232323	asad	\N	f	f	\N	t	2026-10-03 14:04:11.543+05:30	2026-10-03 14:04:11.543+05:30	\N	\N	11111111-1111-1111-1111-111111111111	\N	\N	0	\N
\.


--
-- Data for Name: daily_sales_summary; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.daily_sales_summary (id, outlet_id, business_date, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: dining_tables; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.dining_tables (id, outlet_id, table_number, capacity, section, status, is_active, created_at, updated_at, merge_group_id, merge_primary_table_id, version, covers, is_air_conditioned, created_by, updated_by) FROM stdin;
f9f11b94-f612-4690-969b-4fa4f8fa626c	11111111-1111-1111-1111-111111111111	TEST_VERIFY	4	Non AC	VACANT	f	2026-09-11 17:26:24.929+05:30	2026-09-11 17:26:24.985+05:30	\N	\N	1	\N	\N	\N	\N
799771fc-55e6-42a7-8a24-c8946f547286	11111111-1111-1111-1111-111111111111	Kap2	4	Non AC	OCCUPIED	t	2026-09-08 13:12:23.549+05:30	2026-10-03 14:32:24.108+05:30	\N	\N	1	\N	\N	\N	\N
bc9b4960-2a8a-4ee0-a903-699565b135ee	2a543c3c-066f-4097-833a-df7c25700580	A1	4	AC	VACANT	t	2026-09-02 16:33:25.669+05:30	2026-09-02 16:33:25.669+05:30	\N	\N	1	\N	\N	\N	\N
0dd047e5-f8e3-4d7c-9796-65c158cc3a0e	2a543c3c-066f-4097-833a-df7c25700580	A2	4	AC	VACANT	t	2026-09-02 16:33:25.675+05:30	2026-09-02 16:33:25.675+05:30	\N	\N	1	\N	\N	\N	\N
b8eeae1e-627b-4952-95af-0bc0eb8031b3	2a543c3c-066f-4097-833a-df7c25700580	A3	4	AC	VACANT	t	2026-09-02 16:33:25.678+05:30	2026-09-02 16:33:25.678+05:30	\N	\N	1	\N	\N	\N	\N
21e6342a-11da-471e-9a05-9c59f0682071	2a543c3c-066f-4097-833a-df7c25700580	A4	4	AC	VACANT	t	2026-09-02 16:33:25.681+05:30	2026-09-02 16:33:25.681+05:30	\N	\N	1	\N	\N	\N	\N
66bbd011-47dc-411f-9e63-9f52d9becdf3	2a543c3c-066f-4097-833a-df7c25700580	A5	4	AC	VACANT	t	2026-09-02 16:33:25.684+05:30	2026-09-02 16:33:25.684+05:30	\N	\N	1	\N	\N	\N	\N
92fc1fda-0e53-44c2-953e-4301d3090f99	2a543c3c-066f-4097-833a-df7c25700580	A6	6	AC	VACANT	t	2026-09-02 16:33:25.687+05:30	2026-09-02 16:33:25.687+05:30	\N	\N	1	\N	\N	\N	\N
1ba00f45-b203-4494-84f2-76ca45fe2d7f	2a543c3c-066f-4097-833a-df7c25700580	A7	4	AC	VACANT	t	2026-09-02 16:33:25.691+05:30	2026-09-02 16:33:25.691+05:30	\N	\N	1	\N	\N	\N	\N
25ff8a10-c49b-40d0-9d5e-aba254065bb4	2a543c3c-066f-4097-833a-df7c25700580	A8	4	AC	VACANT	t	2026-09-02 16:33:25.695+05:30	2026-09-02 16:33:25.695+05:30	\N	\N	1	\N	\N	\N	\N
3e2cc430-0411-4b2a-8061-4f7f8c65903f	2a543c3c-066f-4097-833a-df7c25700580	A9	6	AC	VACANT	t	2026-09-02 16:33:25.697+05:30	2026-09-02 16:33:25.697+05:30	\N	\N	1	\N	\N	\N	\N
8c30be00-12ff-4661-99cf-140b081e50da	2a543c3c-066f-4097-833a-df7c25700580	A10	4	AC	VACANT	t	2026-09-02 16:33:25.7+05:30	2026-09-02 16:33:25.7+05:30	\N	\N	1	\N	\N	\N	\N
1cbcd8f1-0650-4862-8135-4f7b739bd53a	2a543c3c-066f-4097-833a-df7c25700580	A11	2	AC	VACANT	t	2026-09-02 16:33:25.703+05:30	2026-09-02 16:33:25.703+05:30	\N	\N	1	\N	\N	\N	\N
83b943da-f25b-4305-afbe-b9b5edf3346e	2a543c3c-066f-4097-833a-df7c25700580	A12	4	AC	VACANT	t	2026-09-02 16:33:25.706+05:30	2026-09-02 16:33:25.706+05:30	\N	\N	1	\N	\N	\N	\N
ec0544f9-96a0-4e2b-964c-c2c681a7e0eb	2a543c3c-066f-4097-833a-df7c25700580	A13	4	AC	VACANT	t	2026-09-02 16:33:25.708+05:30	2026-09-02 16:33:25.708+05:30	\N	\N	1	\N	\N	\N	\N
09696420-813f-4123-a841-919e7b1b29a0	2a543c3c-066f-4097-833a-df7c25700580	A14	4	AC	VACANT	t	2026-09-02 16:33:25.71+05:30	2026-09-02 16:33:25.71+05:30	\N	\N	1	\N	\N	\N	\N
991d6f67-06ee-451d-8f9c-580791737b6d	2a543c3c-066f-4097-833a-df7c25700580	A15	4	AC	VACANT	t	2026-09-02 16:33:25.713+05:30	2026-09-02 16:33:25.713+05:30	\N	\N	1	\N	\N	\N	\N
90588dd8-d07d-4f72-baf8-fffd89f5617e	2a543c3c-066f-4097-833a-df7c25700580	B1	4	Non AC	VACANT	t	2026-09-02 16:33:25.715+05:30	2026-09-02 16:33:25.715+05:30	\N	\N	1	\N	\N	\N	\N
d57be9ba-84b5-4225-8f98-74aa83384b4a	2a543c3c-066f-4097-833a-df7c25700580	B2	4	Non AC	VACANT	t	2026-09-02 16:33:25.717+05:30	2026-09-02 16:33:25.717+05:30	\N	\N	1	\N	\N	\N	\N
98e19752-500d-46cb-8577-fbcbebf927f0	2a543c3c-066f-4097-833a-df7c25700580	B3	4	Non AC	VACANT	t	2026-09-02 16:33:25.719+05:30	2026-09-02 16:33:25.719+05:30	\N	\N	1	\N	\N	\N	\N
5fee1338-f4c2-495f-bac5-705a5d3da3a4	2a543c3c-066f-4097-833a-df7c25700580	B4	4	Non AC	VACANT	t	2026-09-02 16:33:25.72+05:30	2026-09-02 16:33:25.72+05:30	\N	\N	1	\N	\N	\N	\N
6145c07b-defd-4e9d-966a-5b7e96c9e31b	2a543c3c-066f-4097-833a-df7c25700580	B5	4	Non AC	VACANT	t	2026-09-02 16:33:25.722+05:30	2026-09-02 16:33:25.722+05:30	\N	\N	1	\N	\N	\N	\N
33973605-707e-498f-8c86-4756f2823a6e	2a543c3c-066f-4097-833a-df7c25700580	B6	4	Non AC	VACANT	t	2026-09-02 16:33:25.724+05:30	2026-09-02 16:33:25.724+05:30	\N	\N	1	\N	\N	\N	\N
75261ef1-f63c-4ec1-baec-9f7a43c6e917	2a543c3c-066f-4097-833a-df7c25700580	B7	4	Non AC	VACANT	t	2026-09-02 16:33:25.725+05:30	2026-09-02 16:33:25.725+05:30	\N	\N	1	\N	\N	\N	\N
99a59379-4f9c-4cb3-9fac-543d35254b9a	2a543c3c-066f-4097-833a-df7c25700580	B8	4	Non AC	VACANT	t	2026-09-02 16:33:25.727+05:30	2026-09-02 16:33:25.727+05:30	\N	\N	1	\N	\N	\N	\N
d98df111-57f4-494c-a33f-2ca348211f8d	2a543c3c-066f-4097-833a-df7c25700580	B9	4	Non AC	VACANT	t	2026-09-02 16:33:25.729+05:30	2026-09-02 16:33:25.729+05:30	\N	\N	1	\N	\N	\N	\N
7b422323-dc95-4695-8b49-888aa89f72f3	2a543c3c-066f-4097-833a-df7c25700580	B10	4	Non AC	VACANT	t	2026-09-02 16:33:25.73+05:30	2026-09-02 16:33:25.73+05:30	\N	\N	1	\N	\N	\N	\N
4b963032-9e35-4fd1-9229-471e2bd8abd1	2a543c3c-066f-4097-833a-df7c25700580	B11	4	Non AC	VACANT	t	2026-09-02 16:33:25.733+05:30	2026-09-02 16:33:25.733+05:30	\N	\N	1	\N	\N	\N	\N
d96f392b-f645-46ff-863c-fc097896cdbc	2a543c3c-066f-4097-833a-df7c25700580	B12	6	Non AC	VACANT	t	2026-09-02 16:33:25.735+05:30	2026-09-02 16:33:25.735+05:30	\N	\N	1	\N	\N	\N	\N
cb05ab0d-5ff7-4103-9217-e91581596879	2a543c3c-066f-4097-833a-df7c25700580	B13	4	Non AC	VACANT	t	2026-09-02 16:33:25.737+05:30	2026-09-02 16:33:25.737+05:30	\N	\N	1	\N	\N	\N	\N
7a72784b-1dab-42f9-b7dc-7b98ccb77007	2a543c3c-066f-4097-833a-df7c25700580	B14	4	Non AC	VACANT	t	2026-09-02 16:33:25.739+05:30	2026-09-02 16:33:25.739+05:30	\N	\N	1	\N	\N	\N	\N
f74dcea1-b081-4d96-a13e-7b3209ad7aac	2a543c3c-066f-4097-833a-df7c25700580	B15	4	Non AC	VACANT	t	2026-09-02 16:33:25.74+05:30	2026-09-02 16:33:25.74+05:30	\N	\N	1	\N	\N	\N	\N
d51291b6-5c25-46c0-a96a-4e113da12739	2a543c3c-066f-4097-833a-df7c25700580	B16	4	Non AC	VACANT	t	2026-09-02 16:33:25.742+05:30	2026-09-02 16:33:25.742+05:30	\N	\N	1	\N	\N	\N	\N
011233b3-81d8-4083-9e2f-d02b4134d6c5	2a543c3c-066f-4097-833a-df7c25700580	B17	4	Non AC	VACANT	t	2026-09-02 16:33:25.744+05:30	2026-09-02 16:33:25.744+05:30	\N	\N	1	\N	\N	\N	\N
bce84145-6ee7-4f43-a822-755ef84523a7	2a543c3c-066f-4097-833a-df7c25700580	B18	4	Non AC	VACANT	t	2026-09-02 16:33:25.746+05:30	2026-09-02 16:33:25.746+05:30	\N	\N	1	\N	\N	\N	\N
b0283350-364f-43b3-b524-3ace4978a9a6	2a543c3c-066f-4097-833a-df7c25700580	B19	4	Non AC	VACANT	t	2026-09-02 16:33:25.747+05:30	2026-09-02 16:33:25.747+05:30	\N	\N	1	\N	\N	\N	\N
75485259-84fa-4857-ad44-be376e3dfb9e	2a543c3c-066f-4097-833a-df7c25700580	B20	4	Non AC	VACANT	t	2026-09-02 16:33:25.749+05:30	2026-09-02 16:33:25.749+05:30	\N	\N	1	\N	\N	\N	\N
6a18549d-a91a-44b0-8461-3487c1c6a9e1	2a543c3c-066f-4097-833a-df7c25700580	B21	4	Non AC	VACANT	t	2026-09-02 16:33:25.751+05:30	2026-09-02 16:33:25.751+05:30	\N	\N	1	\N	\N	\N	\N
577b0b64-ca14-4629-a827-d1b85e66da08	2a543c3c-066f-4097-833a-df7c25700580	B22	4	Non AC	VACANT	t	2026-09-02 16:33:25.753+05:30	2026-09-02 16:33:25.753+05:30	\N	\N	1	\N	\N	\N	\N
7c79cf80-e43f-43ce-a2be-9d9fe0a0f0a2	2a543c3c-066f-4097-833a-df7c25700580	B23	4	Non AC	VACANT	t	2026-09-02 16:33:25.756+05:30	2026-09-02 16:33:25.756+05:30	\N	\N	1	\N	\N	\N	\N
86f9b52c-06d6-47f0-a7cd-e77dc7027c76	2a543c3c-066f-4097-833a-df7c25700580	B24	4	Non AC	VACANT	t	2026-09-02 16:33:25.757+05:30	2026-09-02 16:33:25.757+05:30	\N	\N	1	\N	\N	\N	\N
38b9d262-8fb4-4e98-8e48-d2c06f671cbc	2a543c3c-066f-4097-833a-df7c25700580	B25	4	Non AC	VACANT	t	2026-09-02 16:33:25.759+05:30	2026-09-02 16:33:25.759+05:30	\N	\N	1	\N	\N	\N	\N
61becee5-ad3a-48ca-8d44-91579aa607e6	2a543c3c-066f-4097-833a-df7c25700580	B26	4	Non AC	VACANT	t	2026-09-02 16:33:25.761+05:30	2026-09-02 16:33:25.761+05:30	\N	\N	1	\N	\N	\N	\N
c28370ca-16c9-4a9d-9d77-c8172a5b5d60	2a543c3c-066f-4097-833a-df7c25700580	B27	4	Non AC	VACANT	t	2026-09-02 16:33:25.763+05:30	2026-09-02 16:33:25.763+05:30	\N	\N	1	\N	\N	\N	\N
6257da7e-d19f-4402-92f3-d9c589f99cc8	2a543c3c-066f-4097-833a-df7c25700580	B28	4	Non AC	VACANT	t	2026-09-02 16:33:25.769+05:30	2026-09-02 16:33:25.769+05:30	\N	\N	1	\N	\N	\N	\N
d6dc3dc8-e53f-4f68-8a53-b0a6c326318b	2a543c3c-066f-4097-833a-df7c25700580	B29	4	Non AC	VACANT	t	2026-09-02 16:33:25.771+05:30	2026-09-02 16:33:25.771+05:30	\N	\N	1	\N	\N	\N	\N
961db5ed-1266-4358-94ce-b2d34ff69797	2a543c3c-066f-4097-833a-df7c25700580	B30	4	Non AC	VACANT	t	2026-09-02 16:33:25.773+05:30	2026-09-02 16:33:25.773+05:30	\N	\N	1	\N	\N	\N	\N
b4442beb-f234-4f13-a069-740bb794abfe	2a543c3c-066f-4097-833a-df7c25700580	LADIES C	10	Other	VACANT	t	2026-09-02 16:33:25.775+05:30	2026-09-02 16:33:25.775+05:30	\N	\N	1	\N	\N	\N	\N
6f041cce-cbf6-4cde-8215-9e23263224cf	2a543c3c-066f-4097-833a-df7c25700580	b18a	2	Other	VACANT	t	2026-09-02 16:33:25.777+05:30	2026-09-02 16:33:25.777+05:30	\N	\N	1	\N	\N	\N	\N
a37af3fa-06cd-4f9d-8994-11a7d204ce5d	2a543c3c-066f-4097-833a-df7c25700580	b19a	2	Other	VACANT	t	2026-09-02 16:33:25.779+05:30	2026-09-02 16:33:25.779+05:30	\N	\N	1	\N	\N	\N	\N
57ee2f6b-ac03-4d32-b562-44b210b422cc	11111111-1111-1111-1111-111111111111	NewKap	4	Non AC	OCCUPIED	t	2026-09-23 13:24:54.999+05:30	2026-10-03 15:10:55.375+05:30	\N	\N	1	\N	\N	\N	\N
2e681514-bcbe-4ef9-bc4d-b2209a3d5f85	11111111-1111-1111-1111-111111111111	cv	4	Non AC	OCCUPIED	t	2026-09-04 01:16:54.711+05:30	2026-09-24 09:03:25.777+05:30	\N	\N	1	\N	\N	\N	\N
bb01f08e-7a9d-43b3-acce-be35218b3f27	11111111-1111-1111-1111-111111111111	Kap1	4	Non AC	OCCUPIED	t	2026-09-03 14:51:16.585+05:30	2026-09-12 16:40:24.242+05:30	\N	\N	5	\N	\N	\N	\N
7f7e342f-0f6c-456c-9ec5-055de3ab87fe	11111111-1111-1111-1111-111111111111	Kap3	4	Non AC	OCCUPIED	t	2026-09-08 13:12:32.064+05:30	2026-10-03 14:44:58.719+05:30	\N	\N	3	\N	\N	\N	\N
f2f701b9-6bc9-4869-8f88-4904a35070d8	11111111-1111-1111-1111-111111111111	aw	6	Non AC	VACANT	t	2026-09-03 14:06:16.807+05:30	2026-10-03 01:21:43.133+05:30	\N	\N	1	\N	\N	\N	\N
1bb0a59d-079d-4406-8bd9-0fd2f4a7668e	11111111-1111-1111-1111-111111111111	ll	4	Non AC	VACANT	t	2026-09-04 01:04:14.781+05:30	2026-10-02 16:59:07.796+05:30	\N	\N	5	\N	\N	\N	\N
fc8127fc-a614-4ba2-ae4e-bc2fb91b2d3d	11111111-1111-1111-1111-111111111111	kp10	4	Non AC	VACANT	t	2026-09-11 17:28:26.08+05:30	2026-10-03 14:44:05.84+05:30	\N	\N	3	\N	\N	\N	\N
\.


--
-- Data for Name: hourly_sales_summary; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.hourly_sales_summary (id, outlet_id, business_date, hour, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: inbound_events; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.inbound_events (id, outlet_id, channel_account_id, external_event_id, raw_payload, processed_at, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: ingredients; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.ingredients (id, outlet_id, name, unit_of_measure, unit_cost_minor, reorder_level, current_stock_qty, is_active, created_at, updated_at, created_by, updated_by, current_stock, unit_cost) FROM stdin;
52cc0d01-2f6a-469e-a864-17052550c521	67315042-c687-4cbb-b45a-f4ea4efc199f	Aged Basmati Rice	kg	0	30	0.000	t	2026-09-02 16:21:33.957+05:30	2026-09-02 16:21:33.957+05:30	\N	\N	150	11000
ad69f282-5239-4a91-a0c0-173e691a1ccb	67315042-c687-4cbb-b45a-f4ea4efc199f	Fresh Chicken (Boneless)	kg	0	15	0.000	t	2026-09-02 16:21:33.963+05:30	2026-09-02 16:21:33.963+05:30	\N	\N	45	24000
0589f156-27da-45c1-9498-19f2b893211d	67315042-c687-4cbb-b45a-f4ea4efc199f	Fresh Paneer	kg	0	5	0.000	t	2026-09-02 16:21:33.967+05:30	2026-09-02 16:21:33.967+05:30	\N	\N	20	32000
b69ecf56-0acd-4634-95ed-375614d85281	67315042-c687-4cbb-b45a-f4ea4efc199f	Pure Desi Ghee	l	0	5	0.000	t	2026-09-02 16:21:33.971+05:30	2026-09-02 16:21:33.971+05:30	\N	\N	25	65000
66ae2eba-88d4-47ce-bdfd-8e11320952ab	67315042-c687-4cbb-b45a-f4ea4efc199f	Tomato Puree	l	0	20	0.000	t	2026-09-02 16:30:20.942+05:30	2026-09-02 16:30:20.942+05:30	\N	\N	100	5000
d78382d7-01dd-4e51-a6d9-374e54182a54	67315042-c687-4cbb-b45a-f4ea4efc199f	Basmati Rice	kg	0	10	-0.250	t	2026-09-02 16:30:20.933+05:30	2026-09-05 16:45:42.195+05:30	\N	918df673-2606-403a-9fad-1c54870d1fce	100	8000
f811d9a2-42c3-45dd-b45a-15ee97731274	67315042-c687-4cbb-b45a-f4ea4efc199f	Chicken Breast	kg	0	5	-0.200	t	2026-09-02 16:30:20.939+05:30	2026-09-05 16:45:42.237+05:30	\N	918df673-2606-403a-9fad-1c54870d1fce	100	22000
\.


--
-- Data for Name: integration_errors; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.integration_errors (id, outlet_id, source_event_id, error_code, detail, resolved_at, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: integrations; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.integrations (id, code, type, is_active, created_at, updated_at, created_by, updated_by) FROM stdin;
a0b27e38-ffc0-4967-b3e5-7bedd6210fab	SWIGGY	SWIGGY	t	2026-09-03 12:29:17.396292+05:30	2026-09-05 13:04:10.660284+05:30	\N	\N
c185eb00-4dcd-4f32-b700-39c5d5f9429c	ZOMATO	ZOMATO	t	2026-09-03 12:29:17.408497+05:30	2026-09-05 13:04:10.676941+05:30	\N	\N
\.


--
-- Data for Name: inventory_consumption_log; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.inventory_consumption_log (id, outlet_id, order_id, order_item_id, ingredient_id, recipe_id, quantity_deducted, remaining_stock, shortage, reason_code, created_at) FROM stdin;
a319327e-c345-4785-ad4c-358453b81d64	67315042-c687-4cbb-b45a-f4ea4efc199f	5b433b06-af43-4f62-8a6b-e2ca1e0bfa88	e33ec171-252d-4f6b-acac-694e76f4bf53	d78382d7-01dd-4e51-a6d9-374e54182a54	12eabedd-f2c0-4dab-98cf-7f080acee451	0.250	-0.250	0.250	ORDER_SETTLED	2026-09-05 16:45:42.203+05:30
806c37b8-d409-4344-ad10-687f23584530	67315042-c687-4cbb-b45a-f4ea4efc199f	5b433b06-af43-4f62-8a6b-e2ca1e0bfa88	e33ec171-252d-4f6b-acac-694e76f4bf53	f811d9a2-42c3-45dd-b45a-15ee97731274	12eabedd-f2c0-4dab-98cf-7f080acee451	0.200	-0.200	0.200	ORDER_SETTLED	2026-09-05 16:45:42.239+05:30
\.


--
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.invoices (id, outlet_id, order_id, invoice_number, amount_minor, tax_amount_minor, waived_off_minor, waived_off_reason, reprint_count, created_at, seat_number, invoice_no, amount, tax_amount) FROM stdin;
b6be566b-b890-4577-b9e8-745bacddd500	11111111-1111-1111-1111-111111111111	a00d57c3-c01d-49d0-9166-45e9f7e22497	INV-2026-00001	47250	2250	0	\N	0	2026-09-05 13:22:05.621+05:30	0	INV-2026-00001	47250	2250
6c0f3e9e-6b52-4b93-a776-67a187f32cdc	11111111-1111-1111-1111-111111111111	0f3580d0-cceb-4289-99f8-5ffdf1669b18	INV-2026-00002	5250	250	0	\N	0	2026-09-05 15:10:12.823+05:30	0	INV-2026-00002	5250	250
b150a504-fabd-4996-b503-5bd0ef6bfe81	67315042-c687-4cbb-b45a-f4ea4efc199f	5b433b06-af43-4f62-8a6b-e2ca1e0bfa88	INV-2026-00001	35700	1700	0	\N	0	2026-09-05 16:45:42.155+05:30	0	INV-2026-00001	35700	1700
9d5d6583-8727-4356-9d6e-5b42ddd88f8d	11111111-1111-1111-1111-111111111111	7a369854-faf1-4af3-8378-8b939249c434	INV-2026-00003	6825	325	0	\N	0	2026-09-05 16:51:32.889+05:30	0	INV-2026-00003	6825	325
a31aeede-b045-4bf3-a6fb-2ec745384074	11111111-1111-1111-1111-111111111111	82e2a068-a74a-4e18-89fe-7a423f5b243f	INV-2026-00004	7350	350	0	\N	0	2026-09-05 17:14:44.768+05:30	0	INV-2026-00004	7350	350
5584cd8e-db50-4ef5-a86f-57ee9110ebf7	11111111-1111-1111-1111-111111111111	71ef893c-0ccc-439d-bc3e-0a248037303b	INV-2026-00005	10904	404	0	\N	0	2026-09-08 11:01:05.852+05:30	0	INV-2026-00005	10904	404
9e873cb4-d529-4bc5-bb77-8b434111c292	11111111-1111-1111-1111-111111111111	1085cebe-ebf0-4804-83f3-aae6d0d4a7c9	INV-2026-00006	77075	3575	0	\N	0	2026-09-08 11:10:47.886+05:30	0	INV-2026-00006	77075	3575
08833b1a-757e-4ef3-b732-584422c3a2cf	11111111-1111-1111-1111-111111111111	e7d4d6cf-4838-43bd-8334-688d11302496	INV-2026-00007	116025	5525	0	\N	0	2026-09-08 11:17:50.431+05:30	0	INV-2026-00007	116025	5525
074fa7fb-80a3-4a98-b2f2-291abd0a520f	11111111-1111-1111-1111-111111111111	b101f725-9679-4cf3-9f0f-16adb200ecff	INV-2026-00008	3150	150	0	\N	0	2026-09-09 12:45:00.454+05:30	0	INV-2026-00008	3150	150
b9fae84e-6a5d-4acc-99bf-de7856276f85	11111111-1111-1111-1111-111111111111	76692730-cd05-45cd-b8ad-9cc20ac9fc5a	INV-2026-00009	7350	350	0	\N	0	2026-09-09 12:47:11.539+05:30	0	INV-2026-00009	7350	350
3fd7fc93-20ab-45db-a445-930859ef7220	11111111-1111-1111-1111-111111111111	0602cb47-3398-4ba0-b5da-87e23909efa3	INV-2026-00010	534975	25475	0	\N	0	2026-09-09 12:51:03.258+05:30	0	INV-2026-00010	534975	25475
82666aab-ab3e-46dc-8202-c46dbe172bbd	11111111-1111-1111-1111-111111111111	2d4b655e-a5bf-4900-ba0c-11e1b3c2685c	INV-2026-00011	473025	22525	0	\N	0	2026-09-09 14:06:01.119+05:30	0	INV-2026-00011	473025	22525
efcc2d05-90a1-4342-bb09-6445682a11c7	11111111-1111-1111-1111-111111111111	eb13fd97-c972-4447-8a42-898eb545191e	INV-2026-00012	21000	1000	0	\N	0	2026-09-09 14:07:07.607+05:30	0	INV-2026-00012	21000	1000
45505a40-e615-4365-864d-6bfb7b43687a	11111111-1111-1111-1111-111111111111	f5d3449d-ce21-48cb-ab01-b41c41a7301c	INV-2026-00013	45675	2175	0	\N	0	2026-09-09 14:07:29.939+05:30	0	INV-2026-00013	45675	2175
098aee51-a6b8-48a3-bbf3-d716228e63cf	11111111-1111-1111-1111-111111111111	0a746ebb-ff2b-40d1-8d00-5e7652f56006	INV-2026-00014	15225	725	0	\N	0	2026-09-09 15:08:54.401+05:30	0	INV-2026-00014	15225	725
446bb6f7-0a03-493d-b5c2-ad4b4a23e330	11111111-1111-1111-1111-111111111111	3e1ba9c8-0311-4534-a8d3-fa97b3a4f933	INV-2026-00015	15500	500	0	\N	0	2026-09-10 17:17:49.748+05:30	0	INV-2026-00015	15500	500
d90eedba-9d16-489d-ae3e-f97da5d43671	11111111-1111-1111-1111-111111111111	c8387bcf-ab67-44bb-87fb-d67f6d7601ca	INV-2026-00016	17600	600	0	\N	0	2026-09-11 12:34:34.919+05:30	0	INV-2026-00016	17600	600
01066545-9c6a-4300-a668-1deef41e785f	11111111-1111-1111-1111-111111111111	27f9f630-3e8b-4ba9-b4d7-e631e45182f7	INV-2026-00017	10250	250	0	\N	0	2026-09-11 12:35:19.697+05:30	0	INV-2026-00017	10250	250
2b528276-aacf-45e9-9ff5-5d42d5a2ae90	11111111-1111-1111-1111-111111111111	4a4e9d6c-a797-4b03-9835-a44526c890e2	INV-2026-00018	17600	600	0	\N	0	2026-09-12 15:32:01.714+05:30	0	INV-2026-00018	17600	600
979cfd33-f35f-4d08-8275-d9f3bb183494	11111111-1111-1111-1111-111111111111	abaed738-9e4f-4470-ae04-031b3baa4721	INV-2026-00019	19050	750	0	\N	0	2026-09-12 16:05:47.983+05:30	0	INV-2026-00019	19050	750
4a6650c9-347f-495e-9852-96645e27ad5b	11111111-1111-1111-1111-111111111111	8139a10d-c414-4402-818c-ea00cfd5e786	INV-2026-00020	18900	900	0	\N	0	2026-09-12 16:21:52.115+05:30	0	INV-2026-00020	18900	900
515bd541-753d-47d2-9b4f-57716c895c1c	11111111-1111-1111-1111-111111111111	547361f1-ab65-4eeb-b5ae-790378f1eebc	INV-2026-00021	8925	425	0	\N	0	2026-09-12 16:22:52.523+05:30	0	INV-2026-00021	8925	425
1e260b3d-3b47-45f4-9b48-bfc15eaeba35	11111111-1111-1111-1111-111111111111	db187890-3de7-4a5d-87b2-9398153c343a	INV-2026-00022	7350	350	0	\N	0	2026-09-23 13:23:29.763+05:30	0	INV-2026-00022	7350	350
df41a17a-60c2-430e-91bd-5d1134a7283c	11111111-1111-1111-1111-111111111111	1469b1ab-dc07-49fd-979d-6393518fd684	INV-2026-00023	17850	850	0	\N	0	2026-10-02 16:57:54.833+05:30	0	INV-2026-00023	17850	850
9fcc8cab-d8c2-4aed-a918-35b626dbea8e	11111111-1111-1111-1111-111111111111	53494c1e-ee68-4197-b271-2a8c5f2bdb26	INV-2026-00024	17850	850	0	\N	0	2026-10-02 16:59:07.783+05:30	0	INV-2026-00024	17850	850
0b706109-c266-4529-8988-a6ce8310a8ea	11111111-1111-1111-1111-111111111111	89dba099-01ad-417a-a438-66ca8af5e712	INV-2026-00025	11550	550	0	\N	0	2026-10-03 01:21:43.117+05:30	0	INV-2026-00025	11550	550
4c894c24-928f-4b24-8352-0bc7ac771d03	11111111-1111-1111-1111-111111111111	7bf0131c-f022-46a1-9a7b-8569cd3682f8	INV-2026-00026	76650	3650	0	\N	0	2026-10-03 01:23:42.493+05:30	0	INV-2026-00026	76650	3650
dcc104a4-3c3b-4d58-a79f-a59473428e3a	11111111-1111-1111-1111-111111111111	af21c0cc-a9e8-459c-b797-ddb34bb7f724	INV-2026-00027	6300	300	0	\N	0	2026-10-03 01:24:19.998+05:30	0	INV-2026-00027	6300	300
cd87b8a8-1ab9-413f-8a9c-543a63521151	11111111-1111-1111-1111-111111111111	b7899f9e-fd1e-4f77-89fc-0d935c2e2d85	INV-2026-00028	8400	400	0	\N	0	2026-10-03 01:24:33.852+05:30	0	INV-2026-00028	8400	400
0f33204f-a354-4b82-b216-3bb69142c0c3	11111111-1111-1111-1111-111111111111	c81161e9-bd67-474a-bf80-3b1756fe5393	INV-2026-00029	6300	300	0	\N	0	2026-10-03 01:26:31.111+05:30	0	INV-2026-00029	6300	300
dfce01c8-3d09-4a06-9d8c-fe9588ad47a3	11111111-1111-1111-1111-111111111111	de5f32b6-72f6-441d-a98f-3f273e2a3bba	INV-2026-00030	6300	300	0	\N	0	2026-10-03 01:27:32.884+05:30	0	INV-2026-00030	6300	300
e85d2a4f-3979-4d66-9561-de2c79b12f89	11111111-1111-1111-1111-111111111111	6dcda227-21c2-4291-918f-a3813a9062eb	INV-2026-00031	16800	800	0	\N	0	2026-10-03 04:38:00.177+05:30	0	INV-2026-00031	16800	800
\.


--
-- Data for Name: item_availabilities; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.item_availabilities (id, outlet_id, menu_item_id, is_stocked, stock_qty, version, updated_at) FROM stdin;
6eee899c-9828-4524-a847-2c1b0b887077	67315042-c687-4cbb-b45a-f4ea4efc199f	1048c560-86bd-45c5-b872-eb5e802c6e46	t	50	1	2026-09-02 16:21:33.923+05:30
581303da-96dd-44d5-ba84-ac141956931f	67315042-c687-4cbb-b45a-f4ea4efc199f	c4945f10-ab36-4a6a-8388-0a0c4904d9da	t	35	1	2026-09-02 16:21:33.932+05:30
c0f83988-5285-4f76-93e0-a3213d9ebc74	67315042-c687-4cbb-b45a-f4ea4efc199f	7455214f-4d3e-495e-a9eb-9a13cda64003	t	40	1	2026-09-02 16:21:33.94+05:30
b70afaab-0684-4497-b8aa-d63dc8c0a7a2	67315042-c687-4cbb-b45a-f4ea4efc199f	c1f09997-5bb1-4ee9-abb6-9b622c2c8e91	t	100	1	2026-09-02 16:21:33.947+05:30
eb44adad-8cfb-4eb8-ac26-272bd9708605	2a543c3c-066f-4097-833a-df7c25700580	99e5ec8f-c83a-4fa8-94d7-912ea45e2b74	t	50	1	2026-09-02 16:33:25.849+05:30
6a0ea54c-8e47-4454-b175-aaa02e844a6e	2a543c3c-066f-4097-833a-df7c25700580	beef07d4-c730-41b8-bf0b-651379e91f92	t	60	1	2026-09-02 16:33:25.862+05:30
6a624326-6a8f-4396-a939-efff563c091d	2a543c3c-066f-4097-833a-df7c25700580	f9e508d5-3525-46d0-bff7-371f448c108c	t	40	1	2026-09-02 16:33:25.869+05:30
19073fd4-897d-4b79-a90f-491ff8bc833a	2a543c3c-066f-4097-833a-df7c25700580	7699dcd7-bf39-4f90-9dfc-c9751ab561ba	t	45	1	2026-09-02 16:33:25.878+05:30
b00e1ceb-7a17-4f85-847b-8cbaad5beee3	2a543c3c-066f-4097-833a-df7c25700580	8613e431-dc51-4c61-9bab-bdf518502c06	t	50	1	2026-09-02 16:33:25.885+05:30
3ec12d7f-d446-45d2-87bc-d428d07c0c5e	2a543c3c-066f-4097-833a-df7c25700580	124c76f8-7ab2-48ab-9a2a-884ec6134578	t	50	1	2026-09-02 16:33:25.894+05:30
93ce9a5f-e694-4f2b-8e55-5a826be3ad4b	2a543c3c-066f-4097-833a-df7c25700580	3d186c5c-8df7-4f8a-9233-3efa0c713df2	t	50	1	2026-09-02 16:33:25.902+05:30
d6e061da-fb9a-4e52-aade-20dd0fe28c58	2a543c3c-066f-4097-833a-df7c25700580	dea644c5-2503-44fd-8da7-661d929ec929	t	35	1	2026-09-02 16:33:25.911+05:30
bdc38dd0-cb71-44c9-a071-098e18047782	2a543c3c-066f-4097-833a-df7c25700580	499397a7-8028-49ab-9884-4cf4784a9094	t	20	1	2026-09-02 16:33:25.92+05:30
734380ea-72e6-443b-a9ce-dfb017fa8991	2a543c3c-066f-4097-833a-df7c25700580	6d626d6f-915f-43a7-887e-8c3d3c637355	t	30	1	2026-09-02 16:33:25.927+05:30
621d8081-0161-46c6-856c-f7dee5c9d888	2a543c3c-066f-4097-833a-df7c25700580	b345f6a0-75ab-48d4-a918-3f4b3652b27c	t	40	1	2026-09-02 16:33:25.934+05:30
581cd2de-57ed-4e77-b305-10dacfbf3cb5	2a543c3c-066f-4097-833a-df7c25700580	d79e8ac8-4c76-4b15-bb79-fc71e716af9f	t	30	1	2026-09-02 16:33:25.942+05:30
ef0d7cca-14b4-4d00-9eaa-a2d914a9565d	2a543c3c-066f-4097-833a-df7c25700580	ffa8145b-957b-4f83-9c66-ec0b84674310	t	100	1	2026-09-02 16:33:25.949+05:30
6f7545b1-48e9-4fab-8b57-183d470fbbe3	2a543c3c-066f-4097-833a-df7c25700580	608501cf-0f05-41a6-86a1-0df6d54f146e	t	100	1	2026-09-02 16:33:25.957+05:30
f6444440-b152-48cb-a0bc-c8567e61baac	2a543c3c-066f-4097-833a-df7c25700580	88c549e3-63bb-4a66-88fa-743997855717	t	40	1	2026-09-02 16:33:25.964+05:30
6a569df9-e219-4a09-8a12-bd94dcc0d5c5	2a543c3c-066f-4097-833a-df7c25700580	48f122f5-022a-4b4e-a4ae-c9ff954f41c8	t	35	1	2026-09-02 16:33:25.971+05:30
209d15e7-6f51-447f-bccd-46bdd5fc2d85	2a543c3c-066f-4097-833a-df7c25700580	298d92b7-7b6d-43f5-9532-3d0da9c83604	t	35	1	2026-09-02 16:33:25.979+05:30
d58106fa-4d32-4681-98be-57b1c1b16565	2a543c3c-066f-4097-833a-df7c25700580	057eb69f-2f78-41db-8d57-7ea11dce3fc9	t	30	1	2026-09-02 16:33:25.987+05:30
922c1614-2787-455c-a1e9-346f18d7ae1f	2a543c3c-066f-4097-833a-df7c25700580	4ad7b7d4-9d9a-4d41-b60d-a473aa6fb2e2	t	60	1	2026-09-02 16:33:25.995+05:30
31a2634d-0a02-420e-b049-f41a86529b3a	2a543c3c-066f-4097-833a-df7c25700580	5f37b0e5-9c5f-4359-bae7-728cb6b9cd34	t	60	1	2026-09-02 16:33:26.002+05:30
5eb10b19-184a-4c95-a827-a56fcab4467b	2a543c3c-066f-4097-833a-df7c25700580	6716a235-8942-48aa-bb11-b43092d4d2f5	t	25	1	2026-09-02 16:33:26.012+05:30
527917f1-948e-459b-9d09-8465b138b508	2a543c3c-066f-4097-833a-df7c25700580	84948cf5-ebb2-447b-9b5f-2a6bf5c563aa	t	30	1	2026-09-02 16:33:26.021+05:30
cc0d34ac-081a-4588-a146-4817aae4d5b4	2a543c3c-066f-4097-833a-df7c25700580	b38345b1-ee47-4809-988b-f660f8885eae	t	25	1	2026-09-02 16:33:26.029+05:30
00fde357-1c16-4d0a-a1aa-d744a4b5518f	2a543c3c-066f-4097-833a-df7c25700580	b9e284ff-8969-494d-a659-fbb5a9354664	t	100	1	2026-09-02 16:33:26.037+05:30
bd5f6ac2-93e4-4259-8a77-e0c9ae77bfd1	2a543c3c-066f-4097-833a-df7c25700580	d8b50247-153e-4208-9839-6bd10bbca253	t	100	1	2026-09-02 16:33:26.045+05:30
551b12cf-e76b-4e0e-ab7f-21dbfc10c98d	67315042-c687-4cbb-b45a-f4ea4efc199f	cdc12a71-3f32-4630-ab8b-059ae196af2c	t	100	1	2026-09-02 17:59:34.85307+05:30
8d481c37-e828-4959-ae0d-5a4a381e5c56	11111111-1111-1111-1111-111111111111	094b3d75-f087-476a-863b-a70da76e2365	t	100	1	2026-09-05 13:03:58.83811+05:30
9c202ccd-6443-49d2-b78e-1f2aaae24438	67315042-c687-4cbb-b45a-f4ea4efc199f	32867c6e-e19a-4228-a96d-af1b439beb9b	t	100	1	2026-09-05 13:03:58.83811+05:30
fb5d0410-72ef-45ba-a299-56126a0fe84c	11111111-1111-1111-1111-111111111111	f2961923-6d3d-453d-b80e-6820041126a5	t	100	1	2026-09-05 13:03:58.83811+05:30
7535edca-e90d-4ba6-85f4-f26abaf54962	11111111-1111-1111-1111-111111111111	df736215-5b84-49ce-bbfc-3d644d9a5401	t	100	1	2026-09-05 13:03:58.83811+05:30
225acb2a-261d-4b0c-abfd-5bb826b57e73	67315042-c687-4cbb-b45a-f4ea4efc199f	cb01246c-8e64-409b-bbb8-d63139e6ac6b	t	100	1	2026-09-05 13:03:58.83811+05:30
32269353-bb0c-46a1-b6ff-3e7bbe755979	67315042-c687-4cbb-b45a-f4ea4efc199f	c8fcdcb4-5630-46dd-aecf-f1d910a52ff8	t	100	1	2026-09-05 13:03:58.83811+05:30
b836faa8-0632-4946-a409-2a15d05b3763	67315042-c687-4cbb-b45a-f4ea4efc199f	3e079d26-b636-48bc-ad6f-68e117c7826d	t	100	1	2026-09-05 13:03:58.83811+05:30
5ac39823-75f6-45a8-8c33-d26fe243ef92	11111111-1111-1111-1111-111111111111	0020780f-7112-4804-a81b-2e06a91cdaa4	t	100	1	2026-09-05 13:03:58.83811+05:30
d55a27a2-b790-4626-9fe8-13437938b89c	11111111-1111-1111-1111-111111111111	2c28152b-2d3a-4796-ac1f-aa04d783f921	t	100	1	2026-09-05 13:03:58.83811+05:30
ba337f94-fdb4-4746-a9a4-ec487cf94529	11111111-1111-1111-1111-111111111111	2ddb7944-4e83-4dda-99de-94dd5e83bb77	t	100	1	2026-09-05 13:03:58.83811+05:30
7688cb95-aa99-48de-9b2b-1d4eba7c344c	11111111-1111-1111-1111-111111111111	4c59714c-7d6c-4d24-87c9-b4bb91f3c923	t	100	1	2026-09-05 13:03:58.83811+05:30
cd814738-93f1-41f7-be94-40e4880c5415	11111111-1111-1111-1111-111111111111	4dd53b01-9b00-47a6-9537-6ccab7fc12e8	t	100	1	2026-09-05 13:03:58.83811+05:30
89b14f34-6ea1-457d-9779-2b5028d2ebea	67315042-c687-4cbb-b45a-f4ea4efc199f	5d8449d6-24c6-43dd-b73e-4a1fb8860644	t	100	1	2026-09-05 13:03:58.83811+05:30
12deca89-e58e-4748-a0a5-9a53d06e7ceb	11111111-1111-1111-1111-111111111111	640584ad-7f9e-4a1b-8740-290fd382ea81	t	100	1	2026-09-05 13:03:58.83811+05:30
a41d2441-924e-4edd-8a7c-03110a86a3b6	11111111-1111-1111-1111-111111111111	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	t	100	1	2026-09-05 13:03:58.83811+05:30
9d9bbac4-508e-46b5-96ad-2bb91e89e224	67315042-c687-4cbb-b45a-f4ea4efc199f	6e275671-eb4e-43e2-8562-65053ed3b8e6	t	100	1	2026-09-05 13:03:58.83811+05:30
46815daf-77c0-42c2-9eac-76eb6e4f9c7b	11111111-1111-1111-1111-111111111111	7e1e6434-2ee4-428b-aafc-05be27e770d9	t	100	1	2026-09-05 13:03:58.83811+05:30
87c6f929-d926-41cb-8a6e-dc183e9db1c4	2a543c3c-066f-4097-833a-df7c25700580	09b87cbe-453a-418f-88dc-841b6c78b4a8	t	100	1	2026-09-05 13:03:58.83811+05:30
476c228e-9841-422f-a9b8-516c6e123a7c	67315042-c687-4cbb-b45a-f4ea4efc199f	95d022d5-47ec-4b38-9565-daabe33866a1	t	100	1	2026-09-05 13:03:58.83811+05:30
f350735a-793a-438c-926f-8092e89e41a5	11111111-1111-1111-1111-111111111111	88edfc29-cdb9-469b-afda-bbb322f0a168	t	100	1	2026-09-05 13:03:58.83811+05:30
40c404ac-3fd1-4039-87de-43b78cf1bef6	11111111-1111-1111-1111-111111111111	88ec151b-ebde-4993-809f-79f7e29a4385	t	100	1	2026-09-05 13:03:58.83811+05:30
20c79ba8-483f-40ca-ae64-5d74421180b7	67315042-c687-4cbb-b45a-f4ea4efc199f	ce830a66-2777-49d8-b62e-6fb860b9ac05	t	100	1	2026-09-05 13:03:58.83811+05:30
50970394-3422-4ede-9f93-c3818dfba647	67315042-c687-4cbb-b45a-f4ea4efc199f	14abe1aa-b258-4201-a995-8eed18df3bcc	t	100	1	2026-09-05 13:03:58.83811+05:30
47600ece-7601-4228-b75d-4b7f184a60e7	67315042-c687-4cbb-b45a-f4ea4efc199f	c97c9587-1c8d-4421-abc4-65e15db4bc81	t	100	1	2026-09-05 13:03:58.83811+05:30
6f223923-20e3-4d5f-9107-f468b0efc449	67315042-c687-4cbb-b45a-f4ea4efc199f	8772f56e-a632-4998-ae87-45084349bf9f	t	100	1	2026-09-05 13:03:58.83811+05:30
d0696ce4-c81b-481d-a4b1-5bc217cb08bf	11111111-1111-1111-1111-111111111111	e0ffcd03-52ae-497b-9e57-1411888fde4f	t	100	1	2026-09-05 13:03:58.83811+05:30
dc1bcf11-8a25-4eab-a48f-0d43ca966e2d	2a543c3c-066f-4097-833a-df7c25700580	1408068a-d60c-421b-8da4-76bf4c399c84	t	100	1	2026-09-05 13:03:58.83811+05:30
e9b68356-32ba-4fe5-a0f6-779affc8fec0	67315042-c687-4cbb-b45a-f4ea4efc199f	7f133d9e-7d22-4f2e-ad79-1fd89f07a1f5	t	100	1	2026-09-05 13:03:58.83811+05:30
b6148dbb-5239-4bb9-94ca-cc41f408cb78	67315042-c687-4cbb-b45a-f4ea4efc199f	25dc14b6-0f77-44e7-9db7-2c6e5fd00ebb	t	100	1	2026-09-05 13:03:58.83811+05:30
f154c7a4-42b9-4e50-b9aa-5dcebee6c5be	11111111-1111-1111-1111-111111111111	b9be06d0-6f21-4d05-8914-74e41818650e	t	100	1	2026-09-05 13:03:58.83811+05:30
eedb8c78-9533-4753-a06f-5ef6715b341e	67315042-c687-4cbb-b45a-f4ea4efc199f	9e6b5249-048d-4aeb-a0b6-acfd8f6a8501	t	100	1	2026-09-05 13:03:58.83811+05:30
ba04b96e-bc9d-4d6a-b7d9-19e070d3ba7a	67315042-c687-4cbb-b45a-f4ea4efc199f	eba83b97-1716-4073-bd57-2eef05c144c5	t	100	1	2026-09-05 13:03:58.83811+05:30
8a127503-5bfa-4de2-accf-fc8f5d3290f1	67315042-c687-4cbb-b45a-f4ea4efc199f	9b35f954-5201-48ea-9e2a-174dbb083352	t	100	1	2026-09-05 13:03:58.83811+05:30
a3c6193b-cdb5-4b29-a31b-854740e24758	2a543c3c-066f-4097-833a-df7c25700580	b61b7134-ec44-409a-924b-b01ecd973144	t	100	1	2026-09-05 13:03:58.83811+05:30
58db4b20-2a84-4a74-a39b-0692e5423cd0	11111111-1111-1111-1111-111111111111	431e1ef5-1ef0-4ee9-acb8-4f406246c92a	t	100	1	2026-09-05 13:03:58.83811+05:30
ee1c79db-ceff-4768-803b-0e53d118f030	11111111-1111-1111-1111-111111111111	a7cf73dc-f5df-497b-a326-5fe2e49af224	t	100	1	2026-09-05 13:03:58.83811+05:30
265dffad-9d44-427b-83fb-86fb607f2dd1	67315042-c687-4cbb-b45a-f4ea4efc199f	81f170e9-ad77-44a9-b8dc-7a7d4a2b84cc	t	100	1	2026-09-05 13:03:58.83811+05:30
39af9d17-6715-48c6-b0a4-fe356502d2cf	11111111-1111-1111-1111-111111111111	5101522a-081e-4866-9f74-261854fe4404	t	100	1	2026-09-05 13:03:58.83811+05:30
01b7cbb8-85df-4c09-a1eb-98d29b977f8a	11111111-1111-1111-1111-111111111111	305951b9-bbbd-4bcd-a93a-01aa60742934	t	100	1	2026-09-05 13:03:58.83811+05:30
a6e252f1-748a-48a7-9b96-2c210929ab16	11111111-1111-1111-1111-111111111111	e286dcdc-8100-430d-967e-6edba83f1609	t	100	1	2026-09-05 13:03:58.83811+05:30
e827ff02-46bb-47b2-88cd-325250b1922c	67315042-c687-4cbb-b45a-f4ea4efc199f	4d74432b-7997-4b05-96c7-cb331127b3ca	t	100	1	2026-09-05 13:03:58.83811+05:30
8885c59d-bab4-4f8b-b224-909a5dceb61e	11111111-1111-1111-1111-111111111111	fd632cf0-e4df-4fb7-b0ec-f6e64f852405	t	100	1	2026-09-05 13:03:58.83811+05:30
a821d195-80ac-49b5-bc95-542bbd1ea8e1	11111111-1111-1111-1111-111111111111	5d13a97e-027a-445b-94eb-2f00546b1614	t	100	1	2026-09-05 13:03:58.83811+05:30
efd568b1-9bf0-4a35-aef5-e3b52431f72c	67315042-c687-4cbb-b45a-f4ea4efc199f	972a52a2-10f6-42ec-bd50-45cee9cd3c14	t	100	1	2026-09-05 13:03:58.83811+05:30
8da95b91-7ae7-47e3-a178-15abfe753857	11111111-1111-1111-1111-111111111111	0f4bef83-2c0d-4c19-9d07-ce7f564fc589	t	100	1	2026-09-05 13:03:58.83811+05:30
98893eaf-e059-4f6f-adb5-1f2cb4d3aae4	67315042-c687-4cbb-b45a-f4ea4efc199f	6147b9f5-53bb-4989-9f55-c0cce14398c0	t	100	1	2026-09-05 13:03:58.83811+05:30
df577e5f-ea74-4609-ba99-ae5b731dcefc	67315042-c687-4cbb-b45a-f4ea4efc199f	d4062c49-deb2-4a8b-a14f-7f594e1d61b0	t	100	1	2026-09-05 13:03:58.83811+05:30
d602bbbe-5fe0-4cb7-91f5-45e686c20ea7	11111111-1111-1111-1111-111111111111	b45529e4-72e8-4c01-aed9-3106f2da6aeb	t	100	1	2026-09-05 13:03:58.83811+05:30
d98b22c5-5243-4ecc-9f71-2d3d832414b8	11111111-1111-1111-1111-111111111111	d96136d0-d5ba-4152-814c-3aea49b3079e	t	100	1	2026-09-05 13:03:58.83811+05:30
3216e816-61c3-4945-b688-f98b2d8a51a3	2a543c3c-066f-4097-833a-df7c25700580	072c26c3-7552-494a-9eb4-bcc5dd7d2a22	t	100	1	2026-09-05 13:03:58.83811+05:30
47863229-272d-4427-98ba-f68596aa0d53	2a543c3c-066f-4097-833a-df7c25700580	00d0d8e1-c2a5-4deb-a0a5-da1a1ca24683	t	100	1	2026-09-05 13:03:58.83811+05:30
8657f916-0a5b-4122-9e1c-a7b3d4a06bc5	11111111-1111-1111-1111-111111111111	9e27f8db-5ca3-4d7f-97d4-aa3d87642452	t	100	1	2026-09-05 13:03:58.83811+05:30
f7cf7479-a041-4d5b-b79a-ae1658fbe4ac	67315042-c687-4cbb-b45a-f4ea4efc199f	47dce856-d45e-41a3-a7de-84a823aa6d5a	t	100	1	2026-09-05 13:03:58.83811+05:30
36d94106-9c6c-4d8c-8535-242799e7b6ea	67315042-c687-4cbb-b45a-f4ea4efc199f	b66072c9-672f-4a07-ae41-bd506f60d505	t	100	1	2026-09-05 13:03:58.83811+05:30
44f7dabb-4783-4203-a502-b73591d4a788	67315042-c687-4cbb-b45a-f4ea4efc199f	7cdd0470-02f3-4aef-a744-d1742a7a8825	t	100	1	2026-09-05 13:03:58.83811+05:30
b38aa0f0-1d7d-4c28-b70c-ac78b428f155	67315042-c687-4cbb-b45a-f4ea4efc199f	b16d099e-1e0c-4bbf-8c9b-8e6a8414f4ae	t	100	1	2026-09-05 13:03:58.83811+05:30
c6ec0727-15b9-4d6c-97e8-bbf1e5af0d07	11111111-1111-1111-1111-111111111111	49768e80-5cf1-47a9-be73-5f24de6fb26e	t	100	1	2026-09-05 13:03:58.83811+05:30
3946a3ab-4353-49af-ba86-eb8262ec32e5	11111111-1111-1111-1111-111111111111	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	t	100	1	2026-09-05 13:03:58.83811+05:30
b3c805e4-ea71-4b38-9f1b-5cdb399fcb61	11111111-1111-1111-1111-111111111111	71451535-8d85-417f-b0ec-3f2b87016045	t	100	1	2026-09-05 13:03:58.83811+05:30
eed41255-3d08-4037-91eb-7516406b7074	11111111-1111-1111-1111-111111111111	29b7f4be-ba96-4de7-a268-6248985e12b1	t	100	1	2026-09-05 13:03:58.83811+05:30
\.


--
-- Data for Name: item_availability; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.item_availability (id, outlet_id, item_id, channel_id, state, version, created_at, updated_at, created_by, updated_by, stock_qty) FROM stdin;
4bf72aed-574e-4267-ab0d-4336b2bc145e	11111111-1111-1111-1111-111111111111	8fe74946-54cc-4f68-ae82-5f775ef44b20	11111111-1111-1111-1111-111111111111	ON	3	2026-09-08 11:27:28.198+05:30	2026-09-08 11:27:30.98+05:30	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	100
95875871-d444-4cac-8bef-20f47cf577be	11111111-1111-1111-1111-111111111111	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	11111111-1111-1111-1111-111111111111	ON	19	2026-09-09 13:03:37.688722+05:30	2026-09-25 00:07:00.783567+05:30	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	47
f7d26cf2-8893-40d1-b829-7b60ccdd2bc6	11111111-1111-1111-1111-111111111111	49768e80-5cf1-47a9-be73-5f24de6fb26e	11111111-1111-1111-1111-111111111111	ON	39	2026-09-09 12:48:24.641345+05:30	2026-10-02 16:59:07.871+05:30	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	43
8f01c088-2741-42a5-9de0-117355878c30	11111111-1111-1111-1111-111111111111	71451535-8d85-417f-b0ec-3f2b87016045	11111111-1111-1111-1111-111111111111	ON	6	2026-09-12 16:04:39.73076+05:30	2026-10-03 01:24:33.611292+05:30	\N	\N	92
4c96fcec-35d3-4367-ad59-0d9491e5da01	11111111-1111-1111-1111-111111111111	5d13a97e-027a-445b-94eb-2f00546b1614	11111111-1111-1111-1111-111111111111	ON	1	2026-09-12 16:20:51.921372+05:30	2026-09-12 16:20:51.921372+05:30	\N	\N	99
f77bfd05-ecdc-4eb3-b3b6-64220b2586b1	11111111-1111-1111-1111-111111111111	640584ad-7f9e-4a1b-8740-290fd382ea81	11111111-1111-1111-1111-111111111111	ON	2	2026-09-12 16:20:51.936795+05:30	2026-09-12 16:22:09.545081+05:30	\N	\N	98
5fc60094-c7b4-4464-a969-bb64067345ea	11111111-1111-1111-1111-111111111111	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	11111111-1111-1111-1111-111111111111	OFF	53	2026-09-09 12:44:25.655994+05:30	2026-09-09 14:27:26.260382+05:30	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	0
cf58c7ba-79fb-4b80-a2c5-a1644310baa6	11111111-1111-1111-1111-111111111111	9e27f8db-5ca3-4d7f-97d4-aa3d87642452	11111111-1111-1111-1111-111111111111	ON	1	2026-10-03 04:36:17.882089+05:30	2026-10-03 04:36:17.882089+05:30	\N	\N	99
ecde4661-f2c0-4ca3-91fa-455a70442ac8	11111111-1111-1111-1111-111111111111	d4d5c11d-7ca8-4f1f-9784-45b39bd6ef7c	11111111-1111-1111-1111-111111111111	ON	1	2026-09-12 16:37:34.155968+05:30	2026-09-12 16:37:34.155968+05:30	\N	\N	99
86c3a1a9-3e53-4f65-8ddf-dc58609db487	11111111-1111-1111-1111-111111111111	2ddb7944-4e83-4dda-99de-94dd5e83bb77	11111111-1111-1111-1111-111111111111	ON	1	2026-09-12 16:37:34.162056+05:30	2026-09-12 16:37:34.162056+05:30	\N	\N	99
3229d9ef-cf63-44e9-bef0-276d1850bb98	11111111-1111-1111-1111-111111111111	b45529e4-72e8-4c01-aed9-3106f2da6aeb	11111111-1111-1111-1111-111111111111	ON	1	2026-10-03 14:32:23.999636+05:30	2026-10-03 14:32:23.999636+05:30	\N	\N	99
6e25ae05-c8f3-4ae7-9a95-cdcab22b33d9	11111111-1111-1111-1111-111111111111	5101522a-081e-4866-9f74-261854fe4404	11111111-1111-1111-1111-111111111111	ON	16	2026-09-09 14:35:45.660191+05:30	2026-10-03 14:44:22.166726+05:30	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	86
39e85f55-d19d-48ce-a756-2faecb9d4914	67315042-c687-4cbb-b45a-f4ea4efc199f	1048c560-86bd-45c5-b872-eb5e802c6e46	fd002d2b-3ba9-456e-bd66-5479c535612f	OFF	9	2026-09-05 16:45:42.225+05:30	2026-09-15 15:26:49.402275+05:30	918df673-2606-403a-9fad-1c54870d1fce	\N	89
9d2a5fab-5783-456b-a69b-a7f24d399276	67315042-c687-4cbb-b45a-f4ea4efc199f	1048c560-86bd-45c5-b872-eb5e802c6e46	ec610d2c-357c-4945-a383-5f734846d834	OFF	9	2026-09-05 16:45:42.233+05:30	2026-09-15 15:26:49.402275+05:30	918df673-2606-403a-9fad-1c54870d1fce	\N	89
0ef4ee5d-2f03-434f-813b-f884c38cf443	11111111-1111-1111-1111-111111111111	0020780f-7112-4804-a81b-2e06a91cdaa4	11111111-1111-1111-1111-111111111111	ON	1	2026-09-15 16:15:47.881871+05:30	2026-09-15 16:15:47.881871+05:30	\N	\N	98
03a873cd-1665-4533-b30a-6d89e84fe02e	11111111-1111-1111-1111-111111111111	88ec151b-ebde-4993-809f-79f7e29a4385	11111111-1111-1111-1111-111111111111	ON	2	2026-10-03 14:44:58.668554+05:30	2026-10-03 14:46:00.302973+05:30	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	100
06aec8ae-27b1-42bb-be51-1ce85b377ee2	11111111-1111-1111-1111-111111111111	e0ffcd03-52ae-497b-9e57-1411888fde4f	11111111-1111-1111-1111-111111111111	ON	2	2026-10-03 01:22:43.925401+05:30	2026-10-03 15:10:55.30095+05:30	\N	\N	97
\.


--
-- Data for Name: item_commissions; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.item_commissions (id, outlet_id, menu_item_id, commission_type, commission_value, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: item_modifier_groups; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.item_modifier_groups (id, outlet_id, item_id, group_id, sort_order, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: item_prices; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.item_prices (id, price_list_id, item_id, variant_id, price_minor, currency, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: item_sales_summary; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.item_sales_summary (id, outlet_id, business_date, item_id, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: item_variants; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.item_variants (id, outlet_id, item_id, name, is_default, is_active, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: kot_items; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.kot_items (id, kot_ticket_id, menu_item_id, quantity, notes, course, served_at, order_item_id, outlet_id, seat_number, seat_id) FROM stdin;
e6e509e7-2af5-42c6-beb7-3d5e93e93ec1	2464b135-bbe4-4f70-b8e9-e8ec09e036bb	1048c560-86bd-45c5-b872-eb5e802c6e46	2	\N	\N	\N	1e52c5d3-8676-4aff-8aa4-2832b1212976	67315042-c687-4cbb-b45a-f4ea4efc199f	\N	\N
22572a00-7130-40f3-ad7b-35f1c5088d4e	1a483a59-4b70-4a21-a78c-e4566f492aa7	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	1	\N	STARTER	\N	7a7080c6-7647-4996-a6cd-586f5613338b	11111111-1111-1111-1111-111111111111	\N	\N
7585377e-ba9b-4352-bbf6-e94170efb080	80f4fd60-0398-4b9a-b31c-ee251b10bebc	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	2	\N	STARTER	2026-09-03 14:45:23.359+05:30	13f81108-0d71-497a-8c59-fb2c9cff2f79	11111111-1111-1111-1111-111111111111	\N	\N
4d6fdfed-ebba-4bf3-a557-ed3d1acf6af7	7ac440d2-529b-4a22-80da-07c102b52bcd	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	1	\N	STARTER	2026-09-04 00:40:27.996+05:30	39232e63-b520-40d1-8382-802fb32cd741	11111111-1111-1111-1111-111111111111	\N	\N
f80fbb22-c3b1-43c0-a2a2-ea78487163ad	d0e620ed-a0fc-4793-a60e-0eee6f19dd09	2ddb7944-4e83-4dda-99de-94dd5e83bb77	1	\N	STARTER	2026-09-04 00:40:29.297+05:30	a9c5759c-98c5-4e33-a8dc-e558deae6d28	11111111-1111-1111-1111-111111111111	\N	\N
7221654f-5060-4b75-b4cd-654ea1dc512e	476f5980-0930-496c-8c4a-9eaf395a75cf	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	1	\N	STARTER	2026-09-04 00:43:39.248+05:30	83af21bb-0221-4d95-b9c3-7c3261a4dfac	11111111-1111-1111-1111-111111111111	\N	\N
80353e30-fab0-447c-ac67-d3d498fa7cb5	aaeb22ca-77d9-4125-93fb-ffaddabfd1ab	49768e80-5cf1-47a9-be73-5f24de6fb26e	1	\N	STARTER	2026-09-04 00:43:39.847+05:30	025735c2-f199-4819-a694-73b1b678ed09	11111111-1111-1111-1111-111111111111	\N	\N
73c2cc87-61c1-4523-93f1-a68297402475	780db29f-b971-4fb9-a7c4-e45ad3fe81f4	49768e80-5cf1-47a9-be73-5f24de6fb26e	1	\N	STARTER	2026-09-04 00:43:40.456+05:30	9c79b32c-196b-4a2d-bd1f-0c7aa4a96a5b	11111111-1111-1111-1111-111111111111	\N	\N
9818587f-8369-44f5-8da0-1dfe437a2523	314f59d3-358c-4d0d-82ce-e2348b2f5869	9e27f8db-5ca3-4d7f-97d4-aa3d87642452	1	\N	STARTER	2026-09-04 00:43:46.594+05:30	2ac5255a-707d-4147-904d-96a126ba13b3	11111111-1111-1111-1111-111111111111	\N	\N
534280bb-ef87-459c-85d4-26b250759bd2	f72e5dc0-f56e-451b-a014-cd4419cacbdf	9e27f8db-5ca3-4d7f-97d4-aa3d87642452	1	\N	STARTER	2026-09-04 00:44:05.583+05:30	ffe3d2a6-2bcf-4f51-96b0-958fc529e51e	11111111-1111-1111-1111-111111111111	\N	\N
3efb9ab9-5995-4262-80da-90e4c804df3e	9a5c4cc8-4b11-4022-b5c1-6d4bedb3b01b	71451535-8d85-417f-b0ec-3f2b87016045	1	\N	STARTER	2026-09-04 01:06:00.055+05:30	8b8157f3-0319-41be-a36d-87ed1df95c5f	11111111-1111-1111-1111-111111111111	\N	\N
9fcae176-24ee-423f-a14d-fc84a7e27882	9a5c4cc8-4b11-4022-b5c1-6d4bedb3b01b	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	1	\N	STARTER	2026-09-04 01:06:00.055+05:30	d01fed96-5b0c-4732-b314-b81a54946dce	11111111-1111-1111-1111-111111111111	\N	\N
2ca6e57f-eba9-4473-b22d-73a5f567c9e0	e0c7eff8-6e10-43b7-bc2a-9be10a9a091b	094b3d75-f087-476a-863b-a70da76e2365	1	\N	STARTER	2026-09-05 13:20:37.737+05:30	a09767f3-e815-483d-aff9-8d334baff511	11111111-1111-1111-1111-111111111111	\N	\N
c5079952-c2fc-4e12-b559-20722abdeb36	38d4de12-7ca2-48b6-8856-15027f1d154b	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	1	\N	STARTER	\N	03d3bde6-a0d7-48d9-abef-c298fbbb36fb	11111111-1111-1111-1111-111111111111	\N	\N
21f6d661-af3a-4424-8e1a-d71628d08a51	022f9506-96ce-4851-b531-11b374d9f3eb	49768e80-5cf1-47a9-be73-5f24de6fb26e	1	\N	\N	\N	60295abb-8a59-4a0f-97e8-b32182500594	11111111-1111-1111-1111-111111111111	\N	\N
64a37ac6-9961-4003-9786-e5f2e2401cff	1a8d8383-c9bc-481e-8700-176bf3b7c38b	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	1	\N	\N	2026-09-05 16:23:36.487+05:30	e757b52b-9567-44bd-a492-3bb3519b4cb5	11111111-1111-1111-1111-111111111111	\N	\N
50e6fe5b-6e22-4404-bbe2-8af2cce8ab32	187ed388-52c9-4d73-bfa6-e4f96d3f8f51	1048c560-86bd-45c5-b872-eb5e802c6e46	1	\N	\N	\N	e33ec171-252d-4f6b-acac-694e76f4bf53	67315042-c687-4cbb-b45a-f4ea4efc199f	\N	\N
d2cd6754-42c2-4633-915d-b1f2f0815891	5d32816c-fd4d-4bb9-8a24-2180b08fa1b8	7e1e6434-2ee4-428b-aafc-05be27e770d9	1	\N	\N	\N	f497179e-87b0-4f64-8408-05071bc7a8ff	11111111-1111-1111-1111-111111111111	\N	\N
b3ce6171-b946-42d5-bde0-94418d8ab34a	4a1fae02-9a34-4e15-a9b9-bcd4df784612	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	1	\N	STARTER	\N	f0971839-9aef-47e4-9c3d-2cf44ce82eaf	11111111-1111-1111-1111-111111111111	\N	\N
b20936cc-e9d9-4d1c-9fe4-b7a9ba1a121e	91c40700-9ebf-4753-b454-24ddf11da7f9	88ec151b-ebde-4993-809f-79f7e29a4385	1	\N	STARTER	2026-09-08 11:05:57.593+05:30	de62921f-d4dc-4fea-a8f4-56fe8b04f116	11111111-1111-1111-1111-111111111111	\N	\N
cc3c6b24-f611-411b-816c-793908c7b8b0	a05cc85f-571d-457d-8fb9-2736dd584304	094b3d75-f087-476a-863b-a70da76e2365	2	\N	STARTER	2026-09-08 11:09:26.513+05:30	9c5395eb-db1c-48f8-803a-f011a251c77a	11111111-1111-1111-1111-111111111111	\N	\N
67b40c6b-60eb-43df-84e4-84e68345fa27	6263318d-e12b-43cf-9c36-9ee3f17e597e	094b3d75-f087-476a-863b-a70da76e2365	3	\N	STARTER	2026-09-08 11:12:15.009+05:30	18ec13cb-0674-4f07-b06a-166a80d9c6b7	11111111-1111-1111-1111-111111111111	\N	\N
66313cd8-c9be-4459-993a-a26ec952d272	00089db3-43f2-4348-bbff-da57724bc4eb	49768e80-5cf1-47a9-be73-5f24de6fb26e	1	\N	\N	2026-09-08 13:11:42.266+05:30	9bc19328-1e90-4001-8205-a2f448775c76	11111111-1111-1111-1111-111111111111	\N	\N
34be4c9b-f39f-48df-bacc-8ca87996731c	00089db3-43f2-4348-bbff-da57724bc4eb	9e27f8db-5ca3-4d7f-97d4-aa3d87642452	1	\N	\N	2026-09-08 13:11:42.266+05:30	f4a218ac-99e4-48cf-b6e1-60afc00828c5	11111111-1111-1111-1111-111111111111	\N	\N
a93334bd-bdf4-4d1e-8bad-b7e59cc12261	2b9b7a79-3fc2-4a24-ab97-ff472596e66b	d4d5c11d-7ca8-4f1f-9784-45b39bd6ef7c	1	\N	STARTER	\N	ae1afbe0-fd20-4f80-973b-bf1ca6b3c498	11111111-1111-1111-1111-111111111111	\N	\N
6d85f00f-02c0-4c89-92ab-7867405637dd	2b9b7a79-3fc2-4a24-ab97-ff472596e66b	8fe74946-54cc-4f68-ae82-5f775ef44b20	1	\N	STARTER	\N	e692ea73-ba2b-457b-a326-3baee8941065	11111111-1111-1111-1111-111111111111	\N	\N
2819bbd5-1ff9-4ad1-8d5e-4a8fb4e986f8	4728ca77-caa1-49de-a309-254613a1cad3	88edfc29-cdb9-469b-afda-bbb322f0a168	1	\N	STARTER	2026-09-08 13:15:08.733+05:30	4994ad24-bebe-49a0-977b-faa12ee5ed46	11111111-1111-1111-1111-111111111111	\N	\N
5e36b888-517b-4362-8e8f-7b28986d9ebc	4728ca77-caa1-49de-a309-254613a1cad3	8fe74946-54cc-4f68-ae82-5f775ef44b20	1	\N	STARTER	2026-09-08 13:15:08.733+05:30	7189e68a-4aef-4e32-876e-56a9f20a4a9c	11111111-1111-1111-1111-111111111111	\N	\N
ecb9c6c5-95a7-432d-983b-26d24b1db7ba	d2d5e040-193a-4e9a-ab00-8ba1614f5266	49768e80-5cf1-47a9-be73-5f24de6fb26e	1	\N	STARTER	2026-09-08 14:15:27.39+05:30	b80c6285-d018-47a1-9dfa-2e686b8effc3	11111111-1111-1111-1111-111111111111	\N	\N
399cfa21-4080-4018-aaf6-4d576d5e22ab	c3b2a555-0bb8-4140-aa3b-16a067935d7f	2c28152b-2d3a-4796-ac1f-aa04d783f921	1	\N	\N	2026-09-08 14:39:22.764+05:30	78627a3c-b92a-42d4-adba-b530878b560f	11111111-1111-1111-1111-111111111111	\N	\N
0387be19-1616-4c57-89e2-6e592cf8b9ce	753c5eb7-0772-4082-b9ea-3cbff53d0f1d	9e27f8db-5ca3-4d7f-97d4-aa3d87642452	1	\N	\N	2026-09-08 14:44:38.639+05:30	74a7e192-fc57-4923-8f2f-61dbb363b66f	11111111-1111-1111-1111-111111111111	\N	\N
cc560ddc-0b45-4199-9a94-69476f08df6a	97823311-3165-4981-bb4a-f701b6c54e81	5d13a97e-027a-445b-94eb-2f00546b1614	1	\N	STARTER	2026-09-08 16:19:42.451+05:30	7ef66626-f4e7-4ebe-a4fe-4e09367d8ab0	11111111-1111-1111-1111-111111111111	\N	\N
5a96e410-ea41-495c-b96b-e8113bf69e1d	97823311-3165-4981-bb4a-f701b6c54e81	e286dcdc-8100-430d-967e-6edba83f1609	1	\N	STARTER	2026-09-08 16:19:42.451+05:30	f89483cf-0d93-4bc0-816a-285a7a13d065	11111111-1111-1111-1111-111111111111	\N	\N
412e6b67-94f9-451f-856f-41406da95853	387bfcae-81d2-4138-b9af-783ed452a554	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	1	\N	\N	2026-09-09 12:45:15.879+05:30	a8871109-ffa1-481a-88da-e56804420b05	11111111-1111-1111-1111-111111111111	\N	\N
6c30d67d-419c-47b3-a60f-194cb96bd092	cde85ae8-efc8-4329-9983-c65db7879821	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	1	\N	STARTER	2026-09-09 12:50:26.931+05:30	e6d644af-1584-467a-863f-bac26eb84d38	11111111-1111-1111-1111-111111111111	\N	\N
3f544d82-c035-4dbd-b6f7-962a699ed19d	4a26f71a-500e-456d-a69b-5dc7529906e8	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	1	\N	STARTER	2026-09-09 12:50:27.44+05:30	4c625b81-fece-407d-9b63-dced164b38b1	11111111-1111-1111-1111-111111111111	\N	\N
8b2d49c7-c36d-4977-af62-a622897cc5ca	0d5f81a3-df18-49f4-92ac-ca9b95a7273f	49768e80-5cf1-47a9-be73-5f24de6fb26e	90	\N	STARTER	2026-09-09 12:50:27.705+05:30	31447489-e6af-4bc5-a132-783f2da200c0	11111111-1111-1111-1111-111111111111	\N	\N
04aee199-139b-45d3-baf3-83e9de7d5491	da54b04f-218d-441e-91d5-44e74856c1c6	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	5	\N	STARTER	2026-09-09 12:50:28.165+05:30	b755bfc3-dea9-4d8f-b6d1-a7decce5f8be	11111111-1111-1111-1111-111111111111	\N	\N
6a6b66ed-0f5b-4351-b7e6-aff8cbeb30ab	66f4fcaf-d7cd-47ee-b09a-d369f60b44fb	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	1	\N	STARTER	\N	c6fbd83e-75ed-472a-b1bf-2e7889b797f0	11111111-1111-1111-1111-111111111111	\N	\N
fc4f4309-0373-41d5-818e-f393e91f6cc9	b7760cd0-9b35-44ed-b588-ac6b42eef3d4	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	16	\N	STARTER	\N	04e04ddf-bbb4-4e74-ae9e-864aca2029d4	11111111-1111-1111-1111-111111111111	\N	\N
d77a5448-2fd9-470b-8e42-78bb7f2ef37a	4d46fa43-e341-4fe6-9c52-8134a1afafbc	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	32	\N	STARTER	\N	4923d9da-bcb2-46da-833a-8b4a037f0436	11111111-1111-1111-1111-111111111111	\N	\N
c8fba74b-6b8f-4edd-a93e-3853ed11224d	35412261-a6db-4503-abb2-74ee5bd5db84	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	3	\N	\N	2026-09-09 13:49:00.591+05:30	e2ac9075-4d00-464e-88a2-afe715362121	11111111-1111-1111-1111-111111111111	\N	\N
ff26c414-1f79-41ee-83ba-4030622cdfb6	d8cf458f-c314-4de9-8fd0-534915e77a5a	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	4	\N	STARTER	2026-09-09 13:49:01.064+05:30	f79c39a2-f114-496c-bf0e-09ac73ddf914	11111111-1111-1111-1111-111111111111	\N	\N
7c26ef84-4d6c-4353-9d4b-a5764a983bef	2ae3bb5c-9171-4f02-8aec-88611bd9216a	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	3	\N	\N	2026-09-09 13:49:01.483+05:30	03ec0df1-5176-44d6-befb-8477fd240cb0	11111111-1111-1111-1111-111111111111	\N	\N
00ad3140-e106-415d-93d3-0b2e6a738d35	0a8cc3a0-92d2-4f37-b85f-1818a5d433c7	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	3	\N	\N	2026-09-09 13:49:02.055+05:30	970e6000-56da-419a-9d6c-33afca6265fd	11111111-1111-1111-1111-111111111111	\N	\N
921f53cb-270b-43cb-af8f-dba70bd71402	e41f4c53-4fb8-467b-b40e-4a53b8479164	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	15	\N	\N	2026-09-09 13:49:02.534+05:30	aa746b8b-9705-4520-a5a8-54ab4190f58c	11111111-1111-1111-1111-111111111111	\N	\N
a237d746-f068-4781-8b1e-4f99ac5c070c	fce3d545-2638-41d6-b6f3-f8a0683e9150	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	3	\N	\N	2026-09-09 13:49:03.038+05:30	2bf7206e-c6f3-44aa-981c-a457abf6e62a	11111111-1111-1111-1111-111111111111	\N	\N
5d812a34-23cb-414a-9aa1-692108697054	da6358fd-b56e-4bad-bcc0-0af0ec94b26b	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	15	\N	\N	2026-09-09 13:49:03.609+05:30	d07b13ab-7416-45f5-aa50-d4c92edb3536	11111111-1111-1111-1111-111111111111	\N	\N
c3b2e9bb-ceaa-48d8-b970-dfdbc3beae50	39863209-183e-4007-a67f-cf22d00609b9	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	1	\N	STARTER	\N	1aa6fbfe-8643-49a5-8246-69a71196a167	11111111-1111-1111-1111-111111111111	\N	\N
d7f3d98c-f5fc-48b5-906d-b2c0b663ecf1	3a8544bd-e646-4dca-a8aa-4451fcfcc675	5101522a-081e-4866-9f74-261854fe4404	1	\N	STARTER	\N	4803f052-a4cd-4a89-ab6f-74fac3d67772	11111111-1111-1111-1111-111111111111	\N	\N
de29917b-9c21-45c6-b1f3-6547f9715dea	5b4062b9-77fe-4305-b776-65b479de232f	49768e80-5cf1-47a9-be73-5f24de6fb26e	1	\N	STARTER	\N	2f46c4fc-4fd6-4c9b-a3f8-acdbd42c0594	11111111-1111-1111-1111-111111111111	\N	\N
a07954b5-05f9-495c-a351-86303fb1be03	e566733f-ccfd-4fa4-b750-c96cde787323	49768e80-5cf1-47a9-be73-5f24de6fb26e	1	\N	STARTER	\N	582a60f4-534d-4024-88c8-1f56e570f4de	11111111-1111-1111-1111-111111111111	\N	\N
08156661-937d-4e01-af49-135b9036b456	0b2b03d2-b645-49b9-8644-1a36bc48a18a	49768e80-5cf1-47a9-be73-5f24de6fb26e	5	\N	\N	2026-09-11 11:09:55.368+05:30	342243f5-67c3-4f51-a5f7-c6441c0f8058	11111111-1111-1111-1111-111111111111	\N	\N
ad9bb36a-9bde-40a8-9742-2337e8095847	15cb65ba-80c2-48ed-883e-dbeb46d9dcda	49768e80-5cf1-47a9-be73-5f24de6fb26e	5	\N	\N	2026-09-11 11:10:05.974+05:30	8fa479df-4828-4bbd-8781-0445ec6a7a4e	11111111-1111-1111-1111-111111111111	\N	\N
cc1ac22f-3284-451f-96e2-fc72755f959e	2508d470-13d4-4db2-a796-75774ccb80c2	49768e80-5cf1-47a9-be73-5f24de6fb26e	5	\N	\N	2026-09-11 11:10:15.591+05:30	94a171f1-9bff-45e7-b655-9b864a43ec78	11111111-1111-1111-1111-111111111111	\N	\N
51b69fec-cc22-4ebb-8ab9-2475a900c975	ecb0bac6-06b0-4a59-b4d7-8c2c1686dc67	49768e80-5cf1-47a9-be73-5f24de6fb26e	5	\N	\N	2026-09-11 11:10:55.567+05:30	1d24f99b-b19c-40f1-b8f4-3c9e1222fd40	11111111-1111-1111-1111-111111111111	\N	\N
2d4c7351-a7d9-464f-bead-efcd477dd489	fc89f774-0dc4-4795-9f68-edd8df66905c	49768e80-5cf1-47a9-be73-5f24de6fb26e	5	\N	\N	2026-09-11 11:10:56.509+05:30	f1df626b-fc7b-4399-bf69-c2502c895927	11111111-1111-1111-1111-111111111111	\N	\N
cd652c55-c14c-4070-8c50-24423d237048	933f4133-630c-48df-b056-4502946eb0ae	49768e80-5cf1-47a9-be73-5f24de6fb26e	5	\N	\N	2026-09-11 11:10:57.332+05:30	c00be2b8-881c-4bde-9a46-577c19ea7bc3	11111111-1111-1111-1111-111111111111	\N	\N
4c34f9f3-23db-4de5-b479-e4013653542f	4ff03eac-fde7-4266-96fe-a868df825efd	49768e80-5cf1-47a9-be73-5f24de6fb26e	5	\N	\N	2026-09-11 11:10:04.488+05:30	28791b77-9a0b-4827-8fc3-156591208ce4	11111111-1111-1111-1111-111111111111	\N	\N
52578ea1-ae64-4ad0-83d1-544399a1df36	7c360f83-927b-4dea-9514-b7815a12a4f5	49768e80-5cf1-47a9-be73-5f24de6fb26e	1	\N	STARTER	\N	feaf21a6-4ea0-4b99-b0f0-bf197fa7b705	11111111-1111-1111-1111-111111111111	\N	\N
01cf6b0f-885f-4a41-bf16-61a99febbc2e	a8088c10-855e-46d2-bc70-3b2bda97e583	5101522a-081e-4866-9f74-261854fe4404	2	\N	STARTER	2026-09-11 12:33:47.938+05:30	5325d83c-f786-4964-bdd3-08acdefa96be	11111111-1111-1111-1111-111111111111	\N	\N
846f5e99-b2c9-4572-b1c2-2daefa1159b3	d3d5de47-7715-4e5a-9036-ec18153e7a81	1048c560-86bd-45c5-b872-eb5e802c6e46	1	\N	MAIN	\N	69d4ccbf-020e-45f7-bff8-efdee2f95fb2	67315042-c687-4cbb-b45a-f4ea4efc199f	\N	\N
6055603a-f170-419d-aa1d-c2869b15459c	a41ba409-8e7a-451d-b1d0-413fb105d4de	1048c560-86bd-45c5-b872-eb5e802c6e46	1	\N	MAIN	\N	a5ad1b27-1d4d-4a40-a7f8-1e08026ac3ba	67315042-c687-4cbb-b45a-f4ea4efc199f	\N	\N
8e12527b-b38f-4727-b94c-9a70875dc7ec	63992e13-1fb0-4e62-8a36-596aa86d78ee	1048c560-86bd-45c5-b872-eb5e802c6e46	1	\N	MAIN	\N	32733e86-926a-421a-86cd-ee6fb9ffb7a0	67315042-c687-4cbb-b45a-f4ea4efc199f	\N	\N
0adc51e0-c3f5-441f-a18e-7db6cc59a156	3d8f581a-fd89-4cf7-9704-3f02a696684e	49768e80-5cf1-47a9-be73-5f24de6fb26e	1	\N	STARTER	\N	45c18b8d-29a0-4435-98e2-db478e9242f9	11111111-1111-1111-1111-111111111111	\N	\N
bdbefb58-43fa-43da-8401-bb1203915056	81985f31-1b69-4a6a-abf8-6c0a638dcf02	5101522a-081e-4866-9f74-261854fe4404	1	\N	STARTER	\N	9fa4ac4f-fd3d-4490-9ad1-87bed53a26d7	11111111-1111-1111-1111-111111111111	\N	\N
80cbd59e-b8d3-48f4-a84a-e1af81d50463	ce6781a5-807c-4628-922f-b4783e87adf0	49768e80-5cf1-47a9-be73-5f24de6fb26e	1	\N	STARTER	2026-09-11 16:21:08.568+05:30	6d2bb836-3203-4c6c-a2ea-d81d3729a02d	11111111-1111-1111-1111-111111111111	\N	\N
dba4af82-0291-4c88-8f79-865c80b861bf	ce6781a5-807c-4628-922f-b4783e87adf0	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	1	\N	STARTER	2026-09-11 16:21:08.568+05:30	afde9793-1550-477e-b114-bdd6d6c5491e	11111111-1111-1111-1111-111111111111	\N	\N
81f6b76f-c0ef-47b0-b7ab-f14ed0d65b74	cf12e201-ceb6-40ba-a0f4-fe1b0e5aac61	5101522a-081e-4866-9f74-261854fe4404	1	\N	STARTER	2026-09-12 12:11:28.257+05:30	4b8a17f6-cc5b-43d8-9bb1-23572af374e7	11111111-1111-1111-1111-111111111111	\N	\N
c262a5ac-141d-4b6d-a91a-30e16880127b	7b921377-29d0-4537-a67a-bddf6caeb385	5101522a-081e-4866-9f74-261854fe4404	1	\N	STARTER	2026-09-12 15:31:15.344+05:30	1bc49c16-8bb7-4650-a1c1-0f3afb56fdd8	11111111-1111-1111-1111-111111111111	\N	\N
6db55bee-97a7-42ce-9746-e88fd9093400	419da55d-d450-436d-9e7a-6f8cc0cb751a	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	1	\N	STARTER	2026-09-12 16:05:29.956+05:30	610ce49b-6860-4c2a-a978-58eee53abe0b	11111111-1111-1111-1111-111111111111	\N	\N
ee29a5a1-ef99-46f2-8616-ed212e87a72c	419da55d-d450-436d-9e7a-6f8cc0cb751a	71451535-8d85-417f-b0ec-3f2b87016045	1	\N	STARTER	2026-09-12 16:05:29.956+05:30	e58cd3f4-fcb9-466f-882e-79f58c50f01d	11111111-1111-1111-1111-111111111111	\N	\N
c24762d8-4317-4dc1-8eb2-a73358ca19bb	1a8e73d0-d3a5-4d51-974f-2f255be03cb9	5d13a97e-027a-445b-94eb-2f00546b1614	1	\N	STARTER	2026-09-12 16:21:26.872+05:30	de49919b-7467-40d6-a444-ce0e0b927f1e	11111111-1111-1111-1111-111111111111	\N	\N
85b7c516-74ca-443e-8bef-2e7d67fbb030	1a8e73d0-d3a5-4d51-974f-2f255be03cb9	640584ad-7f9e-4a1b-8740-290fd382ea81	1	\N	STARTER	2026-09-12 16:21:26.872+05:30	0a897341-6ac0-4d8d-9eaf-ceade7d93d17	11111111-1111-1111-1111-111111111111	\N	\N
17b9f458-1cb3-4700-a6da-216b168ae4d7	a834cfdd-33c9-4650-bc7f-23a9b7168809	640584ad-7f9e-4a1b-8740-290fd382ea81	1	\N	STARTER	2026-09-12 16:22:24.148+05:30	507db4ef-89ab-45ce-b827-28b40e002b45	11111111-1111-1111-1111-111111111111	\N	\N
411fa0e8-d524-47ff-b0d9-e9b66fbd7a6b	c0b2c455-e902-4758-b2aa-dda79c0fd74e	71451535-8d85-417f-b0ec-3f2b87016045	1	\N	STARTER	2026-09-12 16:37:03.943+05:30	1756bfe8-0ef6-4d28-aaab-39b4e69b086e	11111111-1111-1111-1111-111111111111	\N	\N
be9784a5-6649-40f4-9edf-824a8a5a0307	c77f90c7-f328-45ef-90fa-724c0fb7e829	d4d5c11d-7ca8-4f1f-9784-45b39bd6ef7c	1	\N	STARTER	2026-09-12 16:38:07.864+05:30	384df9e2-296b-4b7e-b7b3-fc56b19ee31b	11111111-1111-1111-1111-111111111111	\N	\N
09273c23-2723-4775-8883-52c53dc3e3ff	c77f90c7-f328-45ef-90fa-724c0fb7e829	2ddb7944-4e83-4dda-99de-94dd5e83bb77	1	\N	STARTER	2026-09-12 16:38:07.864+05:30	2ea6b595-c3ff-4250-b013-4b9221c0fd73	11111111-1111-1111-1111-111111111111	\N	\N
2a2031a1-03f6-4e9c-acfe-bf394dbdfe54	2faaf683-ff9a-4644-9025-2381e4c579b7	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	1	\N	STARTER	\N	99d5a47e-068f-4cc0-98c7-bf0ab01eb07f	11111111-1111-1111-1111-111111111111	\N	\N
7e7b7c7a-98fe-4019-9b9b-073b7ab754c9	2ff59c9f-4c88-49f9-923a-67919ab78b59	71451535-8d85-417f-b0ec-3f2b87016045	2	\N	STARTER	2026-09-23 13:22:47.026+05:30	e37fb3cb-1472-4f02-9822-a08237870bd7	11111111-1111-1111-1111-111111111111	\N	\N
57f0f6a1-677f-458a-a47e-64e75f04d3fd	0edaa267-7e8c-429a-8f9e-461a88331dc3	1048c560-86bd-45c5-b872-eb5e802c6e46	1	\N	\N	2026-09-23 15:07:00.618+05:30	9f984ea0-7092-495b-aaab-e0339c3dc92a	67315042-c687-4cbb-b45a-f4ea4efc199f	\N	\N
083afcaa-73a5-4436-803d-2953aff37224	0edaa267-7e8c-429a-8f9e-461a88331dc3	1048c560-86bd-45c5-b872-eb5e802c6e46	3	\N	\N	2026-09-23 15:07:00.618+05:30	4b38180e-52e9-46df-9636-03f3ab5fe080	67315042-c687-4cbb-b45a-f4ea4efc199f	\N	\N
5b8c7fc7-ac53-4661-a8c4-5c7f01b3efc5	2308bdd5-7c44-497e-ab2e-fdcd27b85d2f	1048c560-86bd-45c5-b872-eb5e802c6e46	2	\N	\N	2026-09-23 15:07:04.922+05:30	89bf37b2-7bfb-4e59-ac8d-7d86609c4bc3	67315042-c687-4cbb-b45a-f4ea4efc199f	\N	\N
0b0f086f-2519-4bc8-a50a-b1a000a3ac93	86bcdf2f-a56c-4f32-bdf9-54016f420fab	1048c560-86bd-45c5-b872-eb5e802c6e46	2	\N	\N	2026-09-23 15:07:07.718+05:30	31353c57-0051-4b53-b99e-d1c5b72ff0dd	67315042-c687-4cbb-b45a-f4ea4efc199f	\N	\N
e683f170-8ae7-4e19-8fb7-17000c201f59	2856b23d-c54c-40f5-8182-6f14262eeabe	5101522a-081e-4866-9f74-261854fe4404	2	\N	\N	2026-09-23 15:07:18.326+05:30	bd669fbe-a77b-4740-a72b-436bd193d398	11111111-1111-1111-1111-111111111111	\N	\N
6b147611-56b1-4b82-a78f-bf8cd8ea4f4a	2856b23d-c54c-40f5-8182-6f14262eeabe	0020780f-7112-4804-a81b-2e06a91cdaa4	2	\N	\N	2026-09-23 15:07:18.326+05:30	a88827e9-020a-4394-9ce6-4be1f5eee84f	11111111-1111-1111-1111-111111111111	\N	\N
0d58d73f-a31c-4ff1-9058-551023a29cf9	d1297e69-174f-4bfe-a0b9-2355d35d656c	71451535-8d85-417f-b0ec-3f2b87016045	2	\N	\N	2026-09-24 09:03:36.111+05:30	50cc1925-243e-4e13-9c8d-30e6809f5228	11111111-1111-1111-1111-111111111111	\N	\N
ed41d036-719f-4593-9a31-ae013c799c11	e253a419-f527-4300-8d90-1f2886dc2cf9	49768e80-5cf1-47a9-be73-5f24de6fb26e	2	\N	STARTER	2026-09-24 23:32:07.159+05:30	2d631ad3-a4fd-4ed2-a74c-58dade6b70da	11111111-1111-1111-1111-111111111111	\N	\N
9e6be3ce-ac21-4bce-afbc-e0e4d197a312	e253a419-f527-4300-8d90-1f2886dc2cf9	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	1	\N	MAIN	2026-09-24 23:32:07.159+05:30	1aa0dc86-fbc7-40f7-86e3-b40d18c85905	11111111-1111-1111-1111-111111111111	\N	\N
fa27a88e-23c6-4369-946d-32c033b1b034	4f48a1e4-a0ca-4f87-b99a-cf5e99b683d9	49768e80-5cf1-47a9-be73-5f24de6fb26e	2	\N	STARTER	2026-09-24 23:48:19.456+05:30	5b263a5a-26f4-472f-845a-5fd69f73c080	11111111-1111-1111-1111-111111111111	\N	\N
892b8379-64e6-48f0-b1c7-ab7b417abdbb	4f48a1e4-a0ca-4f87-b99a-cf5e99b683d9	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	1	\N	MAIN	2026-09-24 23:48:19.456+05:30	cbbe2f5a-f6a4-49f5-baad-6debdf4ff1bc	11111111-1111-1111-1111-111111111111	\N	\N
8c70833c-59b9-4593-a9c9-5b2694344a2f	6ceb728c-e4da-427e-adab-7033b1fc5cee	49768e80-5cf1-47a9-be73-5f24de6fb26e	2	\N	STARTER	2026-09-24 23:54:19.913+05:30	1fb8d937-a0fc-44fd-81ca-6e2207dadb9c	11111111-1111-1111-1111-111111111111	\N	\N
3f04089c-d6b1-4b35-a172-f5554de9b529	6ceb728c-e4da-427e-adab-7033b1fc5cee	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	1	\N	MAIN	2026-09-24 23:54:19.913+05:30	b3e785d1-2164-4e94-8dc8-c4adbe1c20a9	11111111-1111-1111-1111-111111111111	\N	\N
9a527917-7094-4737-8f12-0b692328ddd7	d333c254-e18f-4e85-973d-cc2e0a8e007d	49768e80-5cf1-47a9-be73-5f24de6fb26e	2	\N	STARTER	2026-09-25 00:07:01.607+05:30	a4875a2e-6750-4304-9576-ab7968409a53	11111111-1111-1111-1111-111111111111	\N	\N
221e7c1c-68d6-452e-bf66-1fed9a1aaf38	d333c254-e18f-4e85-973d-cc2e0a8e007d	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	1	\N	MAIN	2026-09-25 00:07:01.607+05:30	bff83a34-d2e8-476c-b1bb-3b57ebed89bc	11111111-1111-1111-1111-111111111111	\N	\N
6981b2b3-a4b5-4fbd-8c6c-be1c0ef0218b	17f0b63a-b4a5-442c-860f-2742519688de	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	1	\N	STARTER	2026-10-02 16:57:54.615+05:30	bd610f8f-27d5-4d8e-9119-5fb6a5592408	11111111-1111-1111-1111-111111111111	\N	\N
4e726165-f2f0-498b-9cd4-d351bf7eb7c8	17f0b63a-b4a5-442c-860f-2742519688de	71451535-8d85-417f-b0ec-3f2b87016045	1	\N	STARTER	2026-10-02 16:57:54.615+05:30	a20f3ecf-d99d-4919-9bb1-b70fc265be56	11111111-1111-1111-1111-111111111111	\N	\N
fa73d86e-f60c-4462-be7d-d3c016315c0d	15acc1d7-199b-4d07-9163-33377b661da9	49768e80-5cf1-47a9-be73-5f24de6fb26e	5	\N	\N	2026-10-02 16:59:07.642+05:30	55a4f07d-dfd9-4ffe-987a-090f9fef31ce	11111111-1111-1111-1111-111111111111	\N	\N
a5ab44df-18a6-4d73-b0df-3d3394c9dea0	c164a453-831d-49a9-83f6-0ddecdbb7c38	5101522a-081e-4866-9f74-261854fe4404	1	\N	STARTER	\N	3eafce2f-d57c-4570-a245-5ef7d50f502e	11111111-1111-1111-1111-111111111111	\N	\N
b3afd9ce-bed6-40d2-86b8-cfcdde78b226	48fa95b0-63c4-4a0f-b6bd-e90ecf6c1acf	e0ffcd03-52ae-497b-9e57-1411888fde4f	1	\N	STARTER	\N	b83c41d5-9e92-403a-b6c0-87a0a665b16b	11111111-1111-1111-1111-111111111111	\N	\N
6872d980-f20f-4a72-98b9-c6a8dda8ab28	1297bf76-8760-4e9a-8d2e-a569614f4ae5	5101522a-081e-4866-9f74-261854fe4404	1	\N	STARTER	\N	6c6a69ea-8662-406f-876e-4f380cf146ca	11111111-1111-1111-1111-111111111111	\N	\N
d8bbbd86-0ca9-492a-bbad-77c12f463e04	edcf8af9-6faa-4a2a-b31b-04135333d90c	71451535-8d85-417f-b0ec-3f2b87016045	1	\N	\N	\N	915f99a5-926b-4adb-8682-577cc4f59ecd	11111111-1111-1111-1111-111111111111	\N	\N
22d677f7-1823-4bd8-b079-b7c6ed809e14	659c0dff-9c8f-4696-b665-4b8fd48a2703	5101522a-081e-4866-9f74-261854fe4404	1	\N	STARTER	\N	b65a31aa-57c9-4fb4-9e07-e8c65470e9a2	11111111-1111-1111-1111-111111111111	\N	\N
84a30d7a-2352-446b-ba1e-fd6e9a23923f	358a6d1d-a1c6-4b81-86dc-c3df3e8815f8	5101522a-081e-4866-9f74-261854fe4404	1	\N	\N	\N	27374d9e-4b6a-4d6c-876b-ae552ee440ce	11111111-1111-1111-1111-111111111111	\N	\N
0104a3d2-54d6-4c1e-9611-bb2e74bc9617	f3eb11eb-ebe0-471b-9fe6-dc36367e6e97	9e27f8db-5ca3-4d7f-97d4-aa3d87642452	1	\N	\N	2026-10-03 04:37:26.485+05:30	307df4ba-78be-4ad6-aaf4-c7242681a2b6	11111111-1111-1111-1111-111111111111	\N	\N
02aad437-7941-4b7b-b54d-d8b342a6ccf7	37efc7b2-84f0-4fd1-8917-044af55d4050	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	15	\N	\N	2026-10-03 04:37:35.634+05:30	510ebe7e-4bcf-48c7-83c2-aec32a9ca028	11111111-1111-1111-1111-111111111111	\N	\N
3418b895-b3e6-40bf-b03e-8a3d052f4be5	576b67bd-ad9e-4739-b680-69a3d8f6758f	49768e80-5cf1-47a9-be73-5f24de6fb26e	1	\N	STARTER	2026-10-03 04:37:37.573+05:30	d72965dd-f095-4d00-bd19-5a0c011cdba5	11111111-1111-1111-1111-111111111111	\N	\N
6258eac1-1701-4ae3-9478-daa47ad22d06	4891fe55-6466-4341-bef8-1d58f13d5372	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	3	\N	\N	2026-10-03 04:37:40.917+05:30	2a19d477-00a7-497b-a165-d5c5fc90d646	11111111-1111-1111-1111-111111111111	\N	\N
5763872c-3454-42ca-9a87-1a087f5053bb	ee63a88d-fd0d-4d79-a59b-3e3932d48a51	5101522a-081e-4866-9f74-261854fe4404	1	\N	\N	2026-10-03 14:01:54.415+05:30	703d14d7-845f-43ad-b1e7-2fc8b0b49558	11111111-1111-1111-1111-111111111111	\N	\N
79cc31f9-6404-4882-baf1-1cae70ee2397	c159bb7b-ed9b-41c1-be4c-7c11324dcbef	5101522a-081e-4866-9f74-261854fe4404	1	\N	STARTER	2026-10-03 14:01:55.474+05:30	88e411bf-b78b-4256-affa-96f95d4966b9	11111111-1111-1111-1111-111111111111	\N	\N
3fd4a7b3-e796-476b-a1b9-3367d9e5305e	6c8d44fc-8a01-4f5f-ac7b-c3acc20daf38	5101522a-081e-4866-9f74-261854fe4404	1	\N	\N	2026-10-03 14:04:20.478+05:30	871c0130-7e2d-4e15-b263-b92acd7853b3	11111111-1111-1111-1111-111111111111	\N	\N
466cb70a-e46d-4e28-91e1-f4f131785d03	d145fb1d-3e84-455d-b116-ba8ebf882529	88ec151b-ebde-4993-809f-79f7e29a4385	1	\N	STARTER	2026-10-03 14:46:35.848+05:30	b5f819e0-de5b-40eb-b9c2-79ad5d991c93	11111111-1111-1111-1111-111111111111	\N	\N
9bf05317-125b-4272-8e59-fba035a9707d	29f444b6-de36-4104-afc9-65bb27b34974	e0ffcd03-52ae-497b-9e57-1411888fde4f	2	\N	STARTER	2026-10-03 15:11:36.309+05:30	ecccb59e-9f4e-45ec-9e36-afa847b2671c	11111111-1111-1111-1111-111111111111	\N	\N
0b4d0184-41c7-4097-82b1-11d0bcb65e19	2b95f90e-dac0-40c1-a843-e0fbf5cd8881	b45529e4-72e8-4c01-aed9-3106f2da6aeb	1	\N	STARTER	2026-10-03 15:19:32.481+05:30	62a74f9e-22f5-4150-b319-bf95c6b64225	11111111-1111-1111-1111-111111111111	\N	\N
ffa678f7-6425-45b8-beff-a4e1b8b45556	f72f5c9d-2a8a-4015-9eca-2ec3deaf25e3	5101522a-081e-4866-9f74-261854fe4404	1	\N	STARTER	2026-10-06 01:21:11.388+05:30	8d2c89b6-3bb0-4248-87e9-7b363ef8c95d	11111111-1111-1111-1111-111111111111	\N	\N
\.


--
-- Data for Name: kot_performance; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.kot_performance (id, outlet_id, business_date, station_id, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: kot_status_history; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.kot_status_history (id, kot_ticket_id, status, reason_code, created_at) FROM stdin;
93cbe4ed-0be4-4880-94a0-3491ee3421ec	80f4fd60-0398-4b9a-b31c-ee251b10bebc	QUEUED	\N	2026-09-03 14:19:54.662+05:30
b2cf2bff-342c-4a48-bd08-9c39e57bc195	7ac440d2-529b-4a22-80da-07c102b52bcd	QUEUED	\N	2026-09-03 14:21:16.217+05:30
2272bbc8-18fd-4276-a171-90c6a960231d	1a483a59-4b70-4a21-a78c-e4566f492aa7	QUEUED	\N	2026-09-03 14:25:51.934+05:30
4dcf845b-117e-45bd-a432-6486d0080545	1a483a59-4b70-4a21-a78c-e4566f492aa7	PREPARING	\N	2026-09-03 14:43:30.808+05:30
b16a1c35-c47e-4587-b614-4929ccb03941	1a483a59-4b70-4a21-a78c-e4566f492aa7	READY	\N	2026-09-03 14:43:30.873+05:30
dfc1a11c-f652-408e-b383-a0f3ba06f6d5	80f4fd60-0398-4b9a-b31c-ee251b10bebc	READY	\N	2026-09-03 14:43:47.826+05:30
4a358c6e-1676-4a9c-8d7b-360b9f176193	80f4fd60-0398-4b9a-b31c-ee251b10bebc	SERVED	\N	2026-09-03 14:45:23.37+05:30
c25e227f-bb26-411c-a524-0d9c0e190e72	7ac440d2-529b-4a22-80da-07c102b52bcd	PREPARING	\N	2026-09-03 14:46:09.182+05:30
1afca2c7-8745-431e-92cc-d34af01f9e4b	7ac440d2-529b-4a22-80da-07c102b52bcd	READY	\N	2026-09-03 14:46:36.413+05:30
0bee32cc-01e2-4171-b3b2-aa0b7a6ec98a	d0e620ed-a0fc-4793-a60e-0eee6f19dd09	QUEUED	\N	2026-09-03 14:53:11.914+05:30
f7198b0a-ba8e-4a6b-8fcc-1e3a6c3dade4	d0e620ed-a0fc-4793-a60e-0eee6f19dd09	PREPARING	\N	2026-09-03 14:54:45.493+05:30
59f9fcee-8b6d-4f81-82c5-20bfbad7005f	d0e620ed-a0fc-4793-a60e-0eee6f19dd09	READY	\N	2026-09-03 14:54:57.983+05:30
dd1bdae6-1c3d-4ec1-953a-ae428341e446	476f5980-0930-496c-8c4a-9eaf395a75cf	QUEUED	\N	2026-09-03 15:17:20.285+05:30
dc6281c6-c072-43fb-b3e4-d72a72c33084	aaeb22ca-77d9-4125-93fb-ffaddabfd1ab	QUEUED	\N	2026-09-04 00:02:44.876+05:30
d43f8454-a954-478a-9dbd-84f47a5e90db	780db29f-b971-4fb9-a7c4-e45ad3fe81f4	QUEUED	\N	2026-09-04 00:05:22.369+05:30
41983fa2-0225-4cf4-b6f8-16f879262976	f72e5dc0-f56e-451b-a014-cd4419cacbdf	QUEUED	\N	2026-09-04 00:05:57.398+05:30
e76f7c48-00ea-49ac-8fef-234086c0bb18	7ac440d2-529b-4a22-80da-07c102b52bcd	SERVED	\N	2026-09-04 00:40:28.008+05:30
ae2305d5-1c8f-4fed-9d2e-1038f94ca724	d0e620ed-a0fc-4793-a60e-0eee6f19dd09	SERVED	\N	2026-09-04 00:40:29.304+05:30
4c4e6564-f290-481a-b386-5a466c8f2bc7	314f59d3-358c-4d0d-82ce-e2348b2f5869	QUEUED	\N	2026-09-04 00:40:55.762+05:30
ccf61806-1c52-4915-8d21-d320946971e5	476f5980-0930-496c-8c4a-9eaf395a75cf	PREPARING	\N	2026-09-04 00:42:51.595+05:30
27330f6a-c208-4f07-9bd6-23f7bc47a6f4	aaeb22ca-77d9-4125-93fb-ffaddabfd1ab	PREPARING	\N	2026-09-04 00:42:52.785+05:30
9d812f65-3ce8-4d74-a8e6-11094d810a5e	780db29f-b971-4fb9-a7c4-e45ad3fe81f4	PREPARING	\N	2026-09-04 00:42:53.741+05:30
15c5c66f-1b5d-413d-8dce-8aee043b6a99	f72e5dc0-f56e-451b-a014-cd4419cacbdf	PREPARING	\N	2026-09-04 00:42:55.051+05:30
e57fafb1-c8d8-4c6b-b036-cceb71c92269	f72e5dc0-f56e-451b-a014-cd4419cacbdf	READY	\N	2026-09-04 00:42:55.494+05:30
6f1d99d3-25e5-4240-95c3-95edab56744a	314f59d3-358c-4d0d-82ce-e2348b2f5869	PREPARING	\N	2026-09-04 00:42:59.01+05:30
226b1093-3fca-4db4-acda-f86a68c6999e	314f59d3-358c-4d0d-82ce-e2348b2f5869	READY	\N	2026-09-04 00:43:02.223+05:30
40e0cdcf-f201-48c1-a7d7-35749cdac64c	476f5980-0930-496c-8c4a-9eaf395a75cf	READY	\N	2026-09-04 00:43:04.009+05:30
ad6aeffd-a453-4d28-87ed-0e9868ee02d0	aaeb22ca-77d9-4125-93fb-ffaddabfd1ab	READY	\N	2026-09-04 00:43:05.724+05:30
50df4001-87f6-4e43-a3b0-099cd751949a	780db29f-b971-4fb9-a7c4-e45ad3fe81f4	READY	\N	2026-09-04 00:43:06.966+05:30
317c9748-750b-432c-a2b0-933c5feda294	476f5980-0930-496c-8c4a-9eaf395a75cf	SERVED	\N	2026-09-04 00:43:39.256+05:30
269d7c72-8ee2-4270-a28b-e7bafcbb9174	aaeb22ca-77d9-4125-93fb-ffaddabfd1ab	SERVED	\N	2026-09-04 00:43:39.854+05:30
36664452-b594-4088-a745-ed9e7e275437	780db29f-b971-4fb9-a7c4-e45ad3fe81f4	SERVED	\N	2026-09-04 00:43:40.462+05:30
0a706957-fbf1-4faf-b3d9-61642201dc7f	314f59d3-358c-4d0d-82ce-e2348b2f5869	SERVED	\N	2026-09-04 00:43:46.6+05:30
0125ea40-d607-41e4-858c-77e8627c20fd	f72e5dc0-f56e-451b-a014-cd4419cacbdf	SERVED	\N	2026-09-04 00:44:05.589+05:30
81646e39-3f32-4549-807d-671db3e066e7	9a5c4cc8-4b11-4022-b5c1-6d4bedb3b01b	QUEUED	\N	2026-09-04 01:04:33.383+05:30
5355ba12-eee8-4f35-abf9-1e4935ac4206	9a5c4cc8-4b11-4022-b5c1-6d4bedb3b01b	PREPARING	\N	2026-09-04 01:05:38.222+05:30
1a434804-4fe4-46ef-aede-a45f9ccfcfd6	9a5c4cc8-4b11-4022-b5c1-6d4bedb3b01b	READY	\N	2026-09-04 01:05:39.066+05:30
90c03f2a-95be-4ee2-aaef-68e8dbecedfd	9a5c4cc8-4b11-4022-b5c1-6d4bedb3b01b	SERVED	\N	2026-09-04 01:06:00.067+05:30
3521858f-7c89-4896-a502-31723a2cad72	00089db3-43f2-4348-bbff-da57724bc4eb	QUEUED	\N	2026-09-04 01:19:56.554+05:30
259e44b9-de06-4ff1-8888-e18cf6134c09	e0c7eff8-6e10-43b7-bc2a-9be10a9a091b	QUEUED	\N	2026-09-05 13:19:55.691+05:30
88acc558-48ae-4d7b-93c6-4b77554074cd	e0c7eff8-6e10-43b7-bc2a-9be10a9a091b	READY	\N	2026-09-05 13:20:34.59+05:30
b3a225b1-92e6-497e-b4fa-4c3af72b58a9	e0c7eff8-6e10-43b7-bc2a-9be10a9a091b	SERVED	\N	2026-09-05 13:20:37.758+05:30
b0cdd861-86b5-47fb-ba96-83306d1e8616	38d4de12-7ca2-48b6-8856-15027f1d154b	QUEUED	\N	2026-09-05 14:26:19.165+05:30
c86fb126-8d4b-4708-a5fa-8cb729459919	022f9506-96ce-4851-b531-11b374d9f3eb	QUEUED	\N	2026-09-05 15:10:12.647+05:30
fc5c7b39-4970-476c-9e14-c07e658745d9	1a8d8383-c9bc-481e-8700-176bf3b7c38b	QUEUED	\N	2026-09-05 16:22:38.232+05:30
cb026a5a-09cc-46dd-8d0d-3d9c557dc727	1a8d8383-c9bc-481e-8700-176bf3b7c38b	READY	\N	2026-09-05 16:23:35.479+05:30
fb334c01-dc8b-4f24-91f9-dd230643877b	1a8d8383-c9bc-481e-8700-176bf3b7c38b	SERVED	\N	2026-09-05 16:23:36.494+05:30
76619ac6-e1f6-4b06-8048-1b1d66e62481	187ed388-52c9-4d73-bfa6-e4f96d3f8f51	QUEUED	\N	2026-09-05 16:45:42.065+05:30
fadae3b1-94cc-459e-86ab-3aa6b27eb7a5	5d32816c-fd4d-4bb9-8a24-2180b08fa1b8	QUEUED	\N	2026-09-05 16:51:32.759+05:30
a4dd8871-d622-42a0-a9be-e4bbb1ddcfa2	4a1fae02-9a34-4e15-a9b9-bcd4df784612	QUEUED	\N	2026-09-05 17:05:55.01+05:30
0fa9886c-3d34-4207-aa59-522f88eadc75	91c40700-9ebf-4753-b454-24ddf11da7f9	QUEUED	\N	2026-09-08 11:05:04.429+05:30
f4c421e3-d557-4180-a43f-634c8013d5e5	91c40700-9ebf-4753-b454-24ddf11da7f9	READY	\N	2026-09-08 11:05:44.708+05:30
1744c487-9bb7-4a61-ae5f-9ec02abff463	91c40700-9ebf-4753-b454-24ddf11da7f9	SERVED	\N	2026-09-08 11:05:57.614+05:30
7af8fcd9-ee52-459a-ac3d-bc8df08f5b81	a05cc85f-571d-457d-8fb9-2736dd584304	QUEUED	\N	2026-09-08 11:09:01.406+05:30
e76a5d6b-8e07-4149-ab71-461982ec5d6f	a05cc85f-571d-457d-8fb9-2736dd584304	READY	\N	2026-09-08 11:09:17.774+05:30
d8d73b62-3a09-48a0-8d13-bb2b9a14261a	a05cc85f-571d-457d-8fb9-2736dd584304	SERVED	\N	2026-09-08 11:09:26.519+05:30
fb0584e1-de71-4977-bd81-767a70c642d3	6263318d-e12b-43cf-9c36-9ee3f17e597e	QUEUED	\N	2026-09-08 11:12:06.992+05:30
027eaecf-3898-4780-9c04-0c4687b6b782	6263318d-e12b-43cf-9c36-9ee3f17e597e	READY	\N	2026-09-08 11:12:14.018+05:30
aba6d773-aa04-40d4-9d92-85a2843034cd	6263318d-e12b-43cf-9c36-9ee3f17e597e	SERVED	\N	2026-09-08 11:12:15.017+05:30
d4d72452-4983-4922-a20f-ca282fc10ada	38d4de12-7ca2-48b6-8856-15027f1d154b	READY	\N	2026-09-08 11:13:13.385+05:30
6b1dab20-7387-4ca0-b204-73a833533338	00089db3-43f2-4348-bbff-da57724bc4eb	READY	\N	2026-09-08 11:13:14.592+05:30
f30a41cf-217b-4209-a448-9672f976819d	00089db3-43f2-4348-bbff-da57724bc4eb	SERVED	\N	2026-09-08 13:11:42.275+05:30
e68708e2-a636-4828-98b5-87eeab289079	2b9b7a79-3fc2-4a24-ab97-ff472596e66b	QUEUED	\N	2026-09-08 13:13:14.944+05:30
b24e04b5-26db-4b05-a906-e0e7df74dc39	2b9b7a79-3fc2-4a24-ab97-ff472596e66b	READY	\N	2026-09-08 13:13:29.109+05:30
a0df8155-d324-4805-844e-6325a8669fdb	4728ca77-caa1-49de-a309-254613a1cad3	QUEUED	\N	2026-09-08 13:14:15.321+05:30
6599b866-5127-4fb2-a7ed-84ce89ee8275	4728ca77-caa1-49de-a309-254613a1cad3	READY	\N	2026-09-08 13:14:25.929+05:30
b3678f2b-f90d-4c53-a3b5-f23c5a7d86a0	4728ca77-caa1-49de-a309-254613a1cad3	SERVED	\N	2026-09-08 13:15:08.739+05:30
b128baee-51b7-4bb9-938f-fc05dfee2010	d2d5e040-193a-4e9a-ab00-8ba1614f5266	QUEUED	\N	2026-09-08 14:14:29.265+05:30
243b8ab7-2bdf-41d5-84cc-a451a65198ad	d2d5e040-193a-4e9a-ab00-8ba1614f5266	READY	\N	2026-09-08 14:15:25.984+05:30
220fed0b-2928-4be8-9172-e3236e1960bf	d2d5e040-193a-4e9a-ab00-8ba1614f5266	SERVED	\N	2026-09-08 14:15:27.395+05:30
b5d45a89-d311-4254-9079-3b2bbfc9e137	c3b2a555-0bb8-4140-aa3b-16a067935d7f	QUEUED	\N	2026-09-08 14:27:24.486+05:30
584cfa97-48a9-4827-a8a5-fbdd79890260	c3b2a555-0bb8-4140-aa3b-16a067935d7f	PREPARING	\N	2026-09-08 14:28:38.816+05:30
a55c3f5c-d6c6-41f9-8f7a-10c3cf4bb774	c3b2a555-0bb8-4140-aa3b-16a067935d7f	READY	\N	2026-09-08 14:39:21.418+05:30
b0a38937-6e86-4c1d-a8f9-b7f1d31a9abb	c3b2a555-0bb8-4140-aa3b-16a067935d7f	SERVED	\N	2026-09-08 14:39:22.77+05:30
bc8ca124-da3c-453a-86eb-9bd2455a9b84	753c5eb7-0772-4082-b9ea-3cbff53d0f1d	QUEUED	\N	2026-09-08 14:41:53.613+05:30
f881bc8f-7e94-4244-86fe-687575494d72	753c5eb7-0772-4082-b9ea-3cbff53d0f1d	PREPARING	\N	2026-09-08 14:42:51.394+05:30
299205c1-3f79-419d-8f6f-8e458342127e	753c5eb7-0772-4082-b9ea-3cbff53d0f1d	READY	\N	2026-09-08 14:43:25.77+05:30
df63975b-63b4-4d1a-8105-6a674b84f3b1	753c5eb7-0772-4082-b9ea-3cbff53d0f1d	SERVED	\N	2026-09-08 14:44:38.645+05:30
25035fbb-17f6-41b7-861c-584df5a91cf9	387bfcae-81d2-4138-b9af-783ed452a554	QUEUED	\N	2026-09-08 15:13:45.133+05:30
0dcc8fd1-156d-4fa2-9e82-fc8d311ee4f5	387bfcae-81d2-4138-b9af-783ed452a554	PREPARING	\N	2026-09-08 15:14:17.116+05:30
92507737-0c6c-438b-84aa-ac384f06814f	97823311-3165-4981-bb4a-f701b6c54e81	QUEUED	\N	2026-09-08 16:19:27.322+05:30
4fc19a58-00ac-45a8-ab62-f5f55af1b706	97823311-3165-4981-bb4a-f701b6c54e81	PREPARING	\N	2026-09-08 16:19:40.876+05:30
7553c64c-eb78-4998-9851-e17678f90a6b	97823311-3165-4981-bb4a-f701b6c54e81	READY	\N	2026-09-08 16:19:41.752+05:30
172adfad-593d-4b64-aa2d-6b1fd6e82fe9	97823311-3165-4981-bb4a-f701b6c54e81	SERVED	\N	2026-09-08 16:19:42.461+05:30
23e5e6a7-8fc3-4832-b9a6-8b0d409d94f3	387bfcae-81d2-4138-b9af-783ed452a554	READY	\N	2026-09-09 12:45:15.057+05:30
b48ed865-6873-4b81-b656-f1a27d3999a4	387bfcae-81d2-4138-b9af-783ed452a554	SERVED	\N	2026-09-09 12:45:15.89+05:30
e3696035-83e2-430a-9129-68fad5824375	cde85ae8-efc8-4329-9983-c65db7879821	QUEUED	\N	2026-09-09 12:47:30.802+05:30
51954f10-dcf6-4f56-b0d8-5b22c96ac302	4a26f71a-500e-456d-a69b-5dc7529906e8	QUEUED	\N	2026-09-09 12:47:50.745+05:30
71b5bc6e-4e7a-433b-be8a-73eb8eeb992c	0d5f81a3-df18-49f4-92ac-ca9b95a7273f	QUEUED	\N	2026-09-09 12:48:24.623+05:30
5a0d0122-fc4a-456c-af0a-a2e7998f7fed	da54b04f-218d-441e-91d5-44e74856c1c6	QUEUED	\N	2026-09-09 12:49:23.897+05:30
121f694e-0ff9-4ee1-b36a-2e94ee52e790	0d5f81a3-df18-49f4-92ac-ca9b95a7273f	READY	\N	2026-09-09 12:49:35.299+05:30
cfc7f47c-88d4-4a56-b8c4-aa7e3a5904ad	4a26f71a-500e-456d-a69b-5dc7529906e8	READY	\N	2026-09-09 12:49:37.24+05:30
5638898d-c6c1-4662-828c-a8ed9df58105	cde85ae8-efc8-4329-9983-c65db7879821	READY	\N	2026-09-09 12:49:40.419+05:30
ee5f8512-4ea3-43d0-85c7-4113b1265b52	da54b04f-218d-441e-91d5-44e74856c1c6	READY	\N	2026-09-09 12:49:42.006+05:30
f83279cb-2537-4e05-806c-a0ba3994a5d6	cde85ae8-efc8-4329-9983-c65db7879821	SERVED	\N	2026-09-09 12:50:26.938+05:30
a7fa274b-8752-4bf6-a705-bc28ac7d2157	4a26f71a-500e-456d-a69b-5dc7529906e8	SERVED	\N	2026-09-09 12:50:27.444+05:30
c51bfe0a-152f-4864-a76d-4f8ce2b02005	0d5f81a3-df18-49f4-92ac-ca9b95a7273f	SERVED	\N	2026-09-09 12:50:27.707+05:30
a714980d-2267-4bcb-81d4-eeb3e3e6eb4a	da54b04f-218d-441e-91d5-44e74856c1c6	SERVED	\N	2026-09-09 12:50:28.169+05:30
2646070a-c5fe-490a-a4d5-8dea62e3017b	66f4fcaf-d7cd-47ee-b09a-d369f60b44fb	QUEUED	\N	2026-09-09 12:51:14.275+05:30
c971d7ba-706d-49e4-ab7f-5b7558136c6f	b7760cd0-9b35-44ed-b588-ac6b42eef3d4	QUEUED	\N	2026-09-09 12:51:28.119+05:30
fae177c7-4cc3-484e-b4b9-fa4ced085638	4d46fa43-e341-4fe6-9c52-8134a1afafbc	QUEUED	\N	2026-09-09 12:51:46.707+05:30
9f896760-c5fe-4cd4-b24d-18139d9cb7c6	35412261-a6db-4503-abb2-74ee5bd5db84	QUEUED	\N	2026-09-09 12:52:31.707+05:30
4ad5e1bb-60d4-42f5-b046-cd82f52e2c31	b7760cd0-9b35-44ed-b588-ac6b42eef3d4	READY	\N	2026-09-09 12:53:12.974+05:30
529ec243-396c-4d8d-9be4-90387d2f9541	66f4fcaf-d7cd-47ee-b09a-d369f60b44fb	READY	\N	2026-09-09 12:53:14.512+05:30
a5fdfc1e-9e6f-4143-ac59-e6a0a8af7561	4d46fa43-e341-4fe6-9c52-8134a1afafbc	READY	\N	2026-09-09 12:53:16.577+05:30
9b8676f2-90a8-44ca-a35e-fd75dd21de1e	35412261-a6db-4503-abb2-74ee5bd5db84	READY	\N	2026-09-09 12:53:19.002+05:30
fe53e90a-2559-4b54-bea7-46f770cb25ca	d8cf458f-c314-4de9-8fd0-534915e77a5a	QUEUED	\N	2026-09-09 12:55:56.587+05:30
c0262534-1c3f-423d-9d47-c9c687a30727	d8cf458f-c314-4de9-8fd0-534915e77a5a	READY	\N	2026-09-09 12:59:41.573+05:30
7a6ca26c-0c6c-4a45-af03-25f42bdeaedf	2ae3bb5c-9171-4f02-8aec-88611bd9216a	QUEUED	\N	2026-09-09 13:01:25.234+05:30
0d93ee55-76d4-4d87-83ff-1c98398a031a	0a8cc3a0-92d2-4f37-b85f-1818a5d433c7	QUEUED	\N	2026-09-09 13:02:02.268+05:30
6ba9d719-3dca-4824-911c-617e91a726fc	e41f4c53-4fb8-467b-b40e-4a53b8479164	QUEUED	\N	2026-09-09 13:02:03.777+05:30
42ae48f6-612b-48e3-be86-76e97a14a572	fce3d545-2638-41d6-b6f3-f8a0683e9150	QUEUED	\N	2026-09-09 13:03:37.905+05:30
f2278892-d443-4312-883d-f1a374af2a6d	da6358fd-b56e-4bad-bcc0-0af0ec94b26b	QUEUED	\N	2026-09-09 13:03:39.406+05:30
e91141d9-17be-42ca-a23f-87e1e58a1758	2ae3bb5c-9171-4f02-8aec-88611bd9216a	READY	\N	2026-09-09 13:44:04.1+05:30
d92cd3ed-3ea6-456b-9136-170070638fbe	0a8cc3a0-92d2-4f37-b85f-1818a5d433c7	READY	\N	2026-09-09 13:44:05.937+05:30
6768007b-b629-403f-a74c-41afeb2794f1	da6358fd-b56e-4bad-bcc0-0af0ec94b26b	READY	\N	2026-09-09 13:44:09.366+05:30
f8151015-8949-4f72-93c7-a4d982cb1d62	fce3d545-2638-41d6-b6f3-f8a0683e9150	READY	\N	2026-09-09 13:44:10.58+05:30
2d031f9f-31a7-4829-aeca-1f36704063e1	e41f4c53-4fb8-467b-b40e-4a53b8479164	READY	\N	2026-09-09 13:44:11.493+05:30
a108fc50-a841-4955-8a1e-5b60a23392ea	35412261-a6db-4503-abb2-74ee5bd5db84	SERVED	\N	2026-09-09 13:49:00.602+05:30
8dfee0f2-6210-4b09-9a0c-3c62baa31041	d8cf458f-c314-4de9-8fd0-534915e77a5a	SERVED	\N	2026-09-09 13:49:01.069+05:30
4c18c5e9-62ce-443a-916e-3ed1f6be28d7	2ae3bb5c-9171-4f02-8aec-88611bd9216a	SERVED	\N	2026-09-09 13:49:01.487+05:30
2dbe9b46-5469-44b9-8588-3524a39efd02	0a8cc3a0-92d2-4f37-b85f-1818a5d433c7	SERVED	\N	2026-09-09 13:49:02.059+05:30
a3b59988-c3e9-4fb2-91df-2bbc27e70bbc	e41f4c53-4fb8-467b-b40e-4a53b8479164	SERVED	\N	2026-09-09 13:49:02.538+05:30
9a96eeea-5bf6-42a1-b40e-30c45183fdb3	fce3d545-2638-41d6-b6f3-f8a0683e9150	SERVED	\N	2026-09-09 13:49:03.041+05:30
bb53bf04-0200-488c-b2dc-26cb98095f58	da6358fd-b56e-4bad-bcc0-0af0ec94b26b	SERVED	\N	2026-09-09 13:49:03.613+05:30
6d17b2c4-fe0b-4c2b-8b64-496bf73f3481	39863209-183e-4007-a67f-cf22d00609b9	QUEUED	\N	2026-09-09 14:27:26.236+05:30
3d6aa227-2f3f-4683-a6d5-c722c5385c15	2508d470-13d4-4db2-a796-75774ccb80c2	QUEUED	\N	2026-09-09 14:27:33.904+05:30
524bf383-8ea6-4b6b-be2c-0546a4dc42bd	0b2b03d2-b645-49b9-8644-1a36bc48a18a	QUEUED	\N	2026-09-09 14:28:58.384+05:30
d9be44ad-0b49-4903-b673-aab7cbee631d	4ff03eac-fde7-4266-96fe-a868df825efd	QUEUED	\N	2026-09-09 14:29:43.568+05:30
d013b398-9ca0-493d-a2cc-5f675b65da3d	15cb65ba-80c2-48ed-883e-dbeb46d9dcda	QUEUED	\N	2026-09-09 14:31:14.691+05:30
ed74acff-e12b-4c02-bc92-8ba15d865d7e	ecb0bac6-06b0-4a59-b4d7-8c2c1686dc67	QUEUED	\N	2026-09-09 14:31:59.401+05:30
b2f62c6e-ff41-4f26-be52-6df8b969db2f	fc89f774-0dc4-4795-9f68-edd8df66905c	QUEUED	\N	2026-09-09 14:32:48.934+05:30
e9d9d74d-decf-463e-833f-2b7cd0a1d377	933f4133-630c-48df-b056-4502946eb0ae	QUEUED	\N	2026-09-09 14:34:01.569+05:30
26c673ed-96c5-4071-9d96-849453bad51f	3a8544bd-e646-4dca-a8aa-4451fcfcc675	QUEUED	\N	2026-09-09 14:35:45.639+05:30
16b2d134-6dbd-43c8-a0be-19c548298510	5b4062b9-77fe-4305-b776-65b479de232f	QUEUED	\N	2026-09-09 15:09:20.412+05:30
a19825cb-3e2f-4e55-9e50-ea67c0198427	5b4062b9-77fe-4305-b776-65b479de232f	READY	\N	2026-09-10 10:52:32.478+05:30
6bbebb0c-a714-4d40-b2dd-95d585a54041	e566733f-ccfd-4fa4-b750-c96cde787323	QUEUED	\N	2026-09-10 16:50:53.13+05:30
2cda5fe3-5801-41e6-93ab-cb3fced5507e	e566733f-ccfd-4fa4-b750-c96cde787323	PREPARING	\N	2026-09-10 16:51:30.498+05:30
cc283d94-a278-4f22-9d75-fb9ca18ff061	e566733f-ccfd-4fa4-b750-c96cde787323	READY	\N	2026-09-10 16:52:24.507+05:30
8afa6f34-07e0-49b0-b982-00916c914629	4ff03eac-fde7-4266-96fe-a868df825efd	READY	\N	2026-09-11 11:09:52.44+05:30
f3a9ba81-b9f7-460e-9dc4-c7eeaa6cbb99	0b2b03d2-b645-49b9-8644-1a36bc48a18a	READY	\N	2026-09-11 11:09:54.321+05:30
55d3bdfb-458c-433b-aac3-cd3dd2f6873d	0b2b03d2-b645-49b9-8644-1a36bc48a18a	SERVED	\N	2026-09-11 11:09:55.382+05:30
911a4dee-d716-4cb6-b200-bc1e841cb440	15cb65ba-80c2-48ed-883e-dbeb46d9dcda	PREPARING	\N	2026-09-11 11:10:01.492+05:30
5a31b23b-1500-4ebd-b612-141fea5b8829	15cb65ba-80c2-48ed-883e-dbeb46d9dcda	READY	\N	2026-09-11 11:10:03.233+05:30
c570b0db-d955-463b-a58c-6aebfa299a46	4ff03eac-fde7-4266-96fe-a868df825efd	SERVED	\N	2026-09-11 11:10:04.495+05:30
4e8c6b35-07b9-48a7-84fa-7d1ade7d2908	15cb65ba-80c2-48ed-883e-dbeb46d9dcda	SERVED	\N	2026-09-11 11:10:05.98+05:30
5aec9632-0734-45c9-9749-d8ce43bdc126	2508d470-13d4-4db2-a796-75774ccb80c2	PREPARING	\N	2026-09-11 11:10:07.873+05:30
4e96be4a-0f62-4224-bcd0-a28de99e9b03	2508d470-13d4-4db2-a796-75774ccb80c2	READY	\N	2026-09-11 11:10:10.797+05:30
cd0bbc31-2961-4a44-926b-4ba57ab7be44	2508d470-13d4-4db2-a796-75774ccb80c2	SERVED	\N	2026-09-11 11:10:15.596+05:30
7b020efe-2d8f-4b56-8c67-3361f53eabc7	933f4133-630c-48df-b056-4502946eb0ae	READY	\N	2026-09-11 11:10:31.513+05:30
c566b84f-5a38-4442-948c-78c74ed31d44	fc89f774-0dc4-4795-9f68-edd8df66905c	READY	\N	2026-09-11 11:10:34.509+05:30
0986d9bd-04cb-49bd-8efb-40718518ec14	ecb0bac6-06b0-4a59-b4d7-8c2c1686dc67	PREPARING	\N	2026-09-11 11:10:41.322+05:30
b23a9eda-534f-45e3-93fa-9c262b764ef7	ecb0bac6-06b0-4a59-b4d7-8c2c1686dc67	READY	\N	2026-09-11 11:10:42.054+05:30
3aeb847f-e329-4c61-8add-c2b0916c282d	ecb0bac6-06b0-4a59-b4d7-8c2c1686dc67	SERVED	\N	2026-09-11 11:10:55.575+05:30
1082db41-c0bc-4f52-b5bc-d416397dbd01	fc89f774-0dc4-4795-9f68-edd8df66905c	SERVED	\N	2026-09-11 11:10:56.516+05:30
52aef094-1e9f-47ed-ac58-2bee4b924b50	933f4133-630c-48df-b056-4502946eb0ae	SERVED	\N	2026-09-11 11:10:57.339+05:30
bb2aae7d-e303-4974-a218-e57b79036e6f	7c360f83-927b-4dea-9514-b7815a12a4f5	QUEUED	\N	2026-09-11 12:09:46.402+05:30
81088354-7980-4e8b-aba1-6dcd3758c49f	a8088c10-855e-46d2-bc70-3b2bda97e583	QUEUED	\N	2026-09-11 12:33:27.26+05:30
20243bf0-f602-43d8-ba42-b6fe840b92a9	a8088c10-855e-46d2-bc70-3b2bda97e583	READY	\N	2026-09-11 12:33:46.124+05:30
1eb473c0-310b-48da-b084-6a3385bd25c2	a8088c10-855e-46d2-bc70-3b2bda97e583	SERVED	\N	2026-09-11 12:33:47.945+05:30
b232eae4-0766-4926-9023-d8eb7aa4d408	7c360f83-927b-4dea-9514-b7815a12a4f5	READY	\N	2026-09-11 12:33:50.643+05:30
1ef0e356-43e2-42a6-8b33-1906ec2cf7b8	ce6781a5-807c-4628-922f-b4783e87adf0	QUEUED	\N	2026-09-11 12:59:30.723+05:30
4fcea0e8-d893-4e4b-9160-517cc9e3509a	7b921377-29d0-4537-a67a-bddf6caeb385	QUEUED	\N	2026-09-11 12:59:52.845+05:30
a793c46e-c2a9-45ac-a8dc-adc9e2183d19	d3d5de47-7715-4e5a-9036-ec18153e7a81	QUEUED	\N	2026-09-11 14:12:08.763+05:30
9f995cd3-abcd-4494-9eb4-803e92ab5471	a41ba409-8e7a-451d-b1d0-413fb105d4de	QUEUED	\N	2026-09-11 14:16:07.369+05:30
42b20443-e7ae-41b4-9203-80a22da90ae1	63992e13-1fb0-4e62-8a36-596aa86d78ee	QUEUED	\N	2026-09-11 14:19:07.49+05:30
c0733011-9dc2-4092-b4a3-f0389e5d9f79	3d8f581a-fd89-4cf7-9704-3f02a696684e	QUEUED	\N	2026-09-11 14:24:19.909+05:30
6e4da1af-7ef9-446b-991d-e000a72ef1b4	81985f31-1b69-4a6a-abf8-6c0a638dcf02	QUEUED	\N	2026-09-11 14:25:28.551+05:30
a76487b1-e3bd-4767-aa40-c13c5e6ec56f	81985f31-1b69-4a6a-abf8-6c0a638dcf02	PREPARING	\N	2026-09-11 14:42:42.206+05:30
008e6459-6b6c-4298-8eab-04f1783103e2	3d8f581a-fd89-4cf7-9704-3f02a696684e	PREPARING	\N	2026-09-11 14:42:44.136+05:30
b8b1fc0b-ce16-4cb4-a326-00ba85c27191	3d8f581a-fd89-4cf7-9704-3f02a696684e	READY	\N	2026-09-11 14:43:18.67+05:30
de6452cd-1452-4d84-baec-267fb6c35928	81985f31-1b69-4a6a-abf8-6c0a638dcf02	READY	\N	2026-09-11 14:44:25.853+05:30
3b32a8b1-5498-4d5f-8069-d6ea420929cd	ce6781a5-807c-4628-922f-b4783e87adf0	PREPARING	\N	2026-09-11 16:21:03.301+05:30
dcab1a5a-3e21-4e20-a272-d5c362258468	ce6781a5-807c-4628-922f-b4783e87adf0	READY	\N	2026-09-11 16:21:07.383+05:30
7a197fb5-bb97-452f-aed4-53192615bfd5	ce6781a5-807c-4628-922f-b4783e87adf0	SERVED	\N	2026-09-11 16:21:08.581+05:30
31fc2be9-240a-4463-9fe7-f694c6341caa	7b921377-29d0-4537-a67a-bddf6caeb385	PREPARING	\N	2026-09-11 16:21:23.177+05:30
47d038c4-43e5-42c0-bcbd-7b5138cc7482	cf12e201-ceb6-40ba-a0f4-fe1b0e5aac61	QUEUED	\N	2026-09-11 16:39:37.859+05:30
04610a13-2f59-4a4d-9573-c8fd0c0667da	cf12e201-ceb6-40ba-a0f4-fe1b0e5aac61	PREPARING	\N	2026-09-11 16:40:00.765+05:30
7d161d88-dac8-4073-b9ae-c71f502043dd	cf12e201-ceb6-40ba-a0f4-fe1b0e5aac61	READY	\N	2026-09-11 16:40:04.015+05:30
6ddb4bed-cc44-46e5-a046-40dac780181a	7b921377-29d0-4537-a67a-bddf6caeb385	READY	\N	2026-09-11 16:40:05.229+05:30
48043e47-67df-493e-a7d1-649c596d31df	cf12e201-ceb6-40ba-a0f4-fe1b0e5aac61	SERVED	\N	2026-09-12 12:11:28.271+05:30
5de19662-ea3b-487b-89d5-b3fb7b16afc1	7b921377-29d0-4537-a67a-bddf6caeb385	SERVED	\N	2026-09-12 15:31:15.358+05:30
5170df3d-64ad-43be-963f-5da05b69c44e	419da55d-d450-436d-9e7a-6f8cc0cb751a	QUEUED	\N	2026-09-12 16:04:39.682+05:30
243e24cd-bf90-4de2-ae10-5e0fc34fb8e6	419da55d-d450-436d-9e7a-6f8cc0cb751a	PREPARING	\N	2026-09-12 16:05:26.033+05:30
94d9a047-861e-4094-9fd8-8ebd6df1f425	419da55d-d450-436d-9e7a-6f8cc0cb751a	READY	\N	2026-09-12 16:05:27.996+05:30
840c123d-ff93-4f06-a968-f40a1ce6028f	419da55d-d450-436d-9e7a-6f8cc0cb751a	SERVED	\N	2026-09-12 16:05:29.964+05:30
fa8382fd-eb39-410a-b27e-33bcf912d8fe	1a8e73d0-d3a5-4d51-974f-2f255be03cb9	QUEUED	\N	2026-09-12 16:20:51.9+05:30
a93728a3-242a-4a4b-a1bb-3fa1c66df15a	1a8e73d0-d3a5-4d51-974f-2f255be03cb9	PREPARING	\N	2026-09-12 16:21:25.258+05:30
ae421f87-749d-477f-a504-6e9de35af192	1a8e73d0-d3a5-4d51-974f-2f255be03cb9	READY	\N	2026-09-12 16:21:26.207+05:30
a5451306-b0f1-4515-b3c8-85d104f4501a	1a8e73d0-d3a5-4d51-974f-2f255be03cb9	SERVED	\N	2026-09-12 16:21:26.88+05:30
909cfd3e-2507-453b-b6cc-5d92399a02c7	a834cfdd-33c9-4650-bc7f-23a9b7168809	QUEUED	\N	2026-09-12 16:22:09.533+05:30
022bc0a2-73dd-4c40-af3c-a0a6ee54c4cf	a834cfdd-33c9-4650-bc7f-23a9b7168809	PREPARING	\N	2026-09-12 16:22:21.721+05:30
a794b270-e2c9-478d-8785-1419d533a1f8	a834cfdd-33c9-4650-bc7f-23a9b7168809	READY	\N	2026-09-12 16:22:22.826+05:30
256ce904-867c-4fe5-b385-2b7f4beec9e4	a834cfdd-33c9-4650-bc7f-23a9b7168809	SERVED	\N	2026-09-12 16:22:24.155+05:30
e1810abb-8c95-47dc-8fb8-cd8e6f644521	c0b2c455-e902-4758-b2aa-dda79c0fd74e	QUEUED	\N	2026-09-12 16:23:25.036+05:30
f15f6312-79ea-4d48-820b-38db5754de2a	c0b2c455-e902-4758-b2aa-dda79c0fd74e	PREPARING	\N	2026-09-12 16:35:33.68+05:30
f7140e69-40db-412b-9af5-2db054665546	c0b2c455-e902-4758-b2aa-dda79c0fd74e	READY	\N	2026-09-12 16:35:34.66+05:30
4ef7df3c-f681-4342-ae71-9dfd4fd3de90	c0b2c455-e902-4758-b2aa-dda79c0fd74e	SERVED	\N	2026-09-12 16:37:03.951+05:30
2c34a8d6-af76-454f-bd3c-c63384d6c5d7	c77f90c7-f328-45ef-90fa-724c0fb7e829	QUEUED	\N	2026-09-12 16:37:34.137+05:30
c4d025fe-c521-4ecc-af51-1d61c535905e	c77f90c7-f328-45ef-90fa-724c0fb7e829	PREPARING	\N	2026-09-12 16:37:56.576+05:30
d5499cf0-c574-4041-8b1d-54cfdfe41cf1	c77f90c7-f328-45ef-90fa-724c0fb7e829	READY	\N	2026-09-12 16:38:02.755+05:30
fbbefca1-bbe2-4dd7-b418-e668dc892d84	c77f90c7-f328-45ef-90fa-724c0fb7e829	SERVED	\N	2026-09-12 16:38:07.877+05:30
1e6b0c30-b009-435e-9944-1060fd8bcbdd	2ff59c9f-4c88-49f9-923a-67919ab78b59	QUEUED	\N	2026-09-12 16:40:24.187+05:30
74e5c922-e8f8-4cd3-af0d-fef60b470e87	2ff59c9f-4c88-49f9-923a-67919ab78b59	PREPARING	\N	2026-09-12 17:22:29.971+05:30
b4cbe13f-3f09-4669-ad56-57922eeebd19	86bcdf2f-a56c-4f32-bdf9-54016f420fab	QUEUED	\N	2026-09-15 15:20:21.843+05:30
836ef95b-c64c-4815-bff9-8e33810226e9	2308bdd5-7c44-497e-ab2e-fdcd27b85d2f	QUEUED	\N	2026-09-15 15:22:15.393+05:30
74c24f13-e9ad-4958-9f0d-63f8f2840524	0edaa267-7e8c-429a-8f9e-461a88331dc3	QUEUED	\N	2026-09-15 15:26:49.372+05:30
84d00920-5303-49e4-b296-1bf2460df5ed	2856b23d-c54c-40f5-8182-6f14262eeabe	QUEUED	\N	2026-09-15 16:15:47.846+05:30
5efb45b8-9aaa-4131-89cf-959cdb3c8ab5	d1297e69-174f-4bfe-a0b9-2355d35d656c	QUEUED	\N	2026-09-15 16:15:48.015+05:30
de8e25a4-b418-413b-963b-ab877d498235	2faaf683-ff9a-4644-9025-2381e4c579b7	QUEUED	\N	2026-09-23 13:22:19.392+05:30
0ff3f809-64ce-4794-a99d-a86db09bcd87	2ff59c9f-4c88-49f9-923a-67919ab78b59	READY	\N	2026-09-23 13:22:45.967+05:30
2dd27f47-ed43-44d9-a085-dfd06e2f1a96	2ff59c9f-4c88-49f9-923a-67919ab78b59	SERVED	\N	2026-09-23 13:22:47.035+05:30
e422f816-a6cc-4667-88e9-c342e8dc9224	0edaa267-7e8c-429a-8f9e-461a88331dc3	PREPARING	\N	2026-09-23 15:06:59.068+05:30
291db570-c725-4271-81a9-c57f74d2e74b	0edaa267-7e8c-429a-8f9e-461a88331dc3	READY	\N	2026-09-23 15:06:59.748+05:30
05c3f4dd-867c-4f99-bbd2-9789f3926e76	0edaa267-7e8c-429a-8f9e-461a88331dc3	SERVED	\N	2026-09-23 15:07:00.631+05:30
b9b3e48f-3973-425d-920d-4963fb4a303b	2308bdd5-7c44-497e-ab2e-fdcd27b85d2f	PREPARING	\N	2026-09-23 15:07:03.987+05:30
38d0d379-8490-4215-b523-4d8d2f80aaca	2308bdd5-7c44-497e-ab2e-fdcd27b85d2f	READY	\N	2026-09-23 15:07:04.448+05:30
a0b9b702-bbd1-4517-8824-24630b5e2d69	2308bdd5-7c44-497e-ab2e-fdcd27b85d2f	SERVED	\N	2026-09-23 15:07:04.933+05:30
f6bb2d26-e76a-4c2d-b7c1-9b13729ca05d	86bcdf2f-a56c-4f32-bdf9-54016f420fab	PREPARING	\N	2026-09-23 15:07:07.116+05:30
aeaf6890-f366-4b23-963b-b5352dede3f8	86bcdf2f-a56c-4f32-bdf9-54016f420fab	READY	\N	2026-09-23 15:07:07.52+05:30
7bb87c69-9cb8-47ca-839f-06336d658acf	86bcdf2f-a56c-4f32-bdf9-54016f420fab	SERVED	\N	2026-09-23 15:07:07.732+05:30
036a181b-366c-45cd-b694-7e9f90f2b2d3	2856b23d-c54c-40f5-8182-6f14262eeabe	READY	\N	2026-09-23 15:07:14.68+05:30
3ef7103a-1d72-4852-926a-c60518cf8521	2856b23d-c54c-40f5-8182-6f14262eeabe	SERVED	\N	2026-09-23 15:07:18.337+05:30
6f942011-dbb9-455c-9fb3-c720cb46735c	17f0b63a-b4a5-442c-860f-2742519688de	QUEUED	\N	2026-09-24 09:03:25.645+05:30
8bbbfa10-6919-4574-a909-adbb4b53257e	d1297e69-174f-4bfe-a0b9-2355d35d656c	PREPARING	\N	2026-09-24 09:03:32.4+05:30
6a7a1903-6efb-4f22-84cc-1d17a5ed2226	d1297e69-174f-4bfe-a0b9-2355d35d656c	READY	\N	2026-09-24 09:03:34.598+05:30
88af6e65-c842-47f2-8259-a816c5f310a2	d1297e69-174f-4bfe-a0b9-2355d35d656c	SERVED	\N	2026-09-24 09:03:36.12+05:30
2758bcf7-8db9-421b-9d95-7967e8805fa1	17f0b63a-b4a5-442c-860f-2742519688de	READY	\N	2026-09-24 23:28:03.94+05:30
ba3efba1-f344-4553-81a4-93da94de633a	e253a419-f527-4300-8d90-1f2886dc2cf9	QUEUED	\N	2026-09-24 23:32:05.924+05:30
cf95071b-8db0-4edc-9b06-f67f8f17e51e	e253a419-f527-4300-8d90-1f2886dc2cf9	PREPARING	\N	2026-09-24 23:32:06.817+05:30
cfa6c798-e0fc-403d-961d-80a591fa5559	e253a419-f527-4300-8d90-1f2886dc2cf9	READY	\N	2026-09-24 23:32:06.964+05:30
25fb0231-4d86-4155-9fca-6aa83a817faa	e253a419-f527-4300-8d90-1f2886dc2cf9	SERVED	\N	2026-09-24 23:32:07.197+05:30
3853225c-b914-4f6e-89ba-2f59f99a8191	15acc1d7-199b-4d07-9163-33377b661da9	QUEUED	\N	2026-09-24 23:33:03.583+05:30
59d38c38-ee59-4187-ac17-0b1498f49e78	4891fe55-6466-4341-bef8-1d58f13d5372	QUEUED	\N	2026-09-24 23:33:41.186+05:30
cd755f23-d473-48c2-8991-0df817e26846	37efc7b2-84f0-4fd1-8917-044af55d4050	QUEUED	\N	2026-09-24 23:33:42.672+05:30
a1a1a304-d732-443e-bd4e-f37725a1fd64	4f48a1e4-a0ca-4f87-b99a-cf5e99b683d9	QUEUED	\N	2026-09-24 23:48:18.58+05:30
3324730d-783c-4b84-82ba-e4ba62c280f6	4f48a1e4-a0ca-4f87-b99a-cf5e99b683d9	PREPARING	\N	2026-09-24 23:48:19.336+05:30
5e2e199d-ebcd-4b6c-9d41-af7faf4bdfb5	4f48a1e4-a0ca-4f87-b99a-cf5e99b683d9	READY	\N	2026-09-24 23:48:19.4+05:30
bf031c90-bf67-49b6-bb77-3df7cc395198	4f48a1e4-a0ca-4f87-b99a-cf5e99b683d9	SERVED	\N	2026-09-24 23:48:19.476+05:30
c1037d18-edf4-4351-8b76-fc359556da10	6ceb728c-e4da-427e-adab-7033b1fc5cee	QUEUED	\N	2026-09-24 23:54:19.057+05:30
e0b23543-0038-481b-a826-b6bfe4f56a72	6ceb728c-e4da-427e-adab-7033b1fc5cee	PREPARING	\N	2026-09-24 23:54:19.844+05:30
b964cf86-81e6-455f-94a8-8fa2cd391743	6ceb728c-e4da-427e-adab-7033b1fc5cee	READY	\N	2026-09-24 23:54:19.883+05:30
ccd45361-f8ea-41c0-a921-3f1ae0bbea92	6ceb728c-e4da-427e-adab-7033b1fc5cee	SERVED	\N	2026-09-24 23:54:19.929+05:30
3c1106be-bc0e-44f8-b2c6-dee61c3bdcd2	d333c254-e18f-4e85-973d-cc2e0a8e007d	QUEUED	\N	2026-09-25 00:07:00.744+05:30
f12920c1-4d11-466b-a9c3-261c8fdcb80e	d333c254-e18f-4e85-973d-cc2e0a8e007d	PREPARING	\N	2026-09-25 00:07:01.495+05:30
dfe3db7b-75e9-49d9-9936-85a5de60110c	d333c254-e18f-4e85-973d-cc2e0a8e007d	READY	\N	2026-09-25 00:07:01.54+05:30
7d0eb405-5806-4471-8a7e-8a17630f9902	d333c254-e18f-4e85-973d-cc2e0a8e007d	SERVED	\N	2026-09-25 00:07:01.622+05:30
29677e16-b60e-44aa-a812-2b4c88be848c	576b67bd-ad9e-4739-b680-69a3d8f6758f	QUEUED	\N	2026-10-02 16:33:19.935+05:30
9c2e66e8-cf6a-4b41-b330-42747258040c	17f0b63a-b4a5-442c-860f-2742519688de	SERVED	\N	2026-10-02 16:57:54.625+05:30
abc3f401-f205-4a16-a5a2-ca6580ac8253	15acc1d7-199b-4d07-9163-33377b661da9	PREPARING	\N	2026-10-02 16:59:07.571+05:30
e2eb7d55-f95c-4270-948a-47f7f223ed49	15acc1d7-199b-4d07-9163-33377b661da9	READY	\N	2026-10-02 16:59:07.608+05:30
5713ed3f-cba6-44e3-a86d-d4b54f75ca74	15acc1d7-199b-4d07-9163-33377b661da9	SERVED	\N	2026-10-02 16:59:07.649+05:30
ec7b6472-10bc-4713-8188-14a971d37642	c164a453-831d-49a9-83f6-0ddecdbb7c38	QUEUED	\N	2026-10-03 01:21:16.096+05:30
61a117fb-a1d3-4461-8aa5-7d031b1b8822	48fa95b0-63c4-4a0f-b6bd-e90ecf6c1acf	QUEUED	\N	2026-10-03 01:22:43.905+05:30
c20c2761-a22f-404c-a752-bd581fed7fe8	1297bf76-8760-4e9a-8d2e-a569614f4ae5	QUEUED	\N	2026-10-03 01:24:04.835+05:30
f3613e43-5295-48b1-8c41-962e0349b813	edcf8af9-6faa-4a2a-b31b-04135333d90c	QUEUED	\N	2026-10-03 01:24:33.578+05:30
6f855138-149b-4530-8176-8480fe115a6a	659c0dff-9c8f-4696-b665-4b8fd48a2703	QUEUED	\N	2026-10-03 01:25:42.627+05:30
db4d7863-1874-4953-8931-4cbd2cef858f	358a6d1d-a1c6-4b81-86dc-c3df3e8815f8	QUEUED	\N	2026-10-03 01:27:32.45+05:30
e667c98a-47cd-4e8c-b66e-93bb475a7f49	f3eb11eb-ebe0-471b-9fe6-dc36367e6e97	QUEUED	\N	2026-10-03 04:36:17.84+05:30
a6a0dc0c-e55f-48e5-9fca-53e9757eaddc	37efc7b2-84f0-4fd1-8917-044af55d4050	READY	\N	2026-10-03 04:37:19.979+05:30
a9249b37-039f-466d-bf29-8276212b7010	576b67bd-ad9e-4739-b680-69a3d8f6758f	READY	\N	2026-10-03 04:37:22.671+05:30
47d550ec-fa62-470f-b22a-db6fa51e8856	f3eb11eb-ebe0-471b-9fe6-dc36367e6e97	READY	\N	2026-10-03 04:37:26.277+05:30
f2c103e3-4830-4040-8206-c540338a42d2	f3eb11eb-ebe0-471b-9fe6-dc36367e6e97	SERVED	\N	2026-10-03 04:37:26.497+05:30
8f1b2c61-0098-4195-89ff-c6ec5299901b	4891fe55-6466-4341-bef8-1d58f13d5372	READY	\N	2026-10-03 04:37:32.377+05:30
b655ec79-9917-462f-a698-a3801b8fcc0d	37efc7b2-84f0-4fd1-8917-044af55d4050	SERVED	\N	2026-10-03 04:37:35.639+05:30
657120a8-6a70-49da-9aa6-539d09e188e9	576b67bd-ad9e-4739-b680-69a3d8f6758f	SERVED	\N	2026-10-03 04:37:37.578+05:30
9f58d973-cb71-4d20-846a-f8d30df5a36b	4891fe55-6466-4341-bef8-1d58f13d5372	SERVED	\N	2026-10-03 04:37:40.924+05:30
53cb1b21-8f23-49a4-81e0-2829fa46376d	c159bb7b-ed9b-41c1-be4c-7c11324dcbef	QUEUED	\N	2026-10-03 13:58:21.985+05:30
d5b3ceba-1b4f-4a64-8d71-b436b1ced579	ee63a88d-fd0d-4d79-a59b-3e3932d48a51	QUEUED	\N	2026-10-03 14:00:38.417+05:30
9e0ea0f8-0a6b-487a-9ec9-46cf3258ae77	ee63a88d-fd0d-4d79-a59b-3e3932d48a51	READY	\N	2026-10-03 14:01:07.933+05:30
5fa4aa9d-741f-4b76-a68b-32ebbf6b949d	c159bb7b-ed9b-41c1-be4c-7c11324dcbef	READY	\N	2026-10-03 14:01:09.918+05:30
379ce4d7-6131-48de-b874-2afc298e241b	ee63a88d-fd0d-4d79-a59b-3e3932d48a51	SERVED	\N	2026-10-03 14:01:54.425+05:30
27fd4238-18c3-459b-a143-9d2fdc428092	c159bb7b-ed9b-41c1-be4c-7c11324dcbef	SERVED	\N	2026-10-03 14:01:55.479+05:30
1a9bf2d9-2aed-4bfb-933c-86ed7feab096	6c8d44fc-8a01-4f5f-ac7b-c3acc20daf38	QUEUED	\N	2026-10-03 14:04:11.621+05:30
07f77725-f6cd-40a1-8ab2-d7582892b23a	6c8d44fc-8a01-4f5f-ac7b-c3acc20daf38	READY	\N	2026-10-03 14:04:19.285+05:30
7067bf55-c5c0-4d1a-998f-208f5711bded	6c8d44fc-8a01-4f5f-ac7b-c3acc20daf38	SERVED	\N	2026-10-03 14:04:20.488+05:30
05ae04cf-1255-402f-bc48-44684a136ced	2b95f90e-dac0-40c1-a843-e0fbf5cd8881	QUEUED	\N	2026-10-03 14:32:23.886+05:30
966f6025-3b52-4837-8180-80979f6eb117	f72f5c9d-2a8a-4015-9eca-2ec3deaf25e3	QUEUED	\N	2026-10-03 14:44:05.753+05:30
933a0ded-5f81-4d69-9ad2-a2a04400ec45	d145fb1d-3e84-455d-b116-ba8ebf882529	QUEUED	\N	2026-10-03 14:44:58.653+05:30
93ab61c4-b518-4994-81ed-a044b8272da0	d145fb1d-3e84-455d-b116-ba8ebf882529	PREPARING	\N	2026-10-03 14:45:35.349+05:30
f6354a77-fc29-486e-bae9-9422ffacd59a	d145fb1d-3e84-455d-b116-ba8ebf882529	READY	\N	2026-10-03 14:45:38.268+05:30
968a391f-42de-4589-afc1-fdcc7a815bc2	d145fb1d-3e84-455d-b116-ba8ebf882529	SERVED	\N	2026-10-03 14:46:35.857+05:30
0efcfd0c-e20c-4efd-b209-6aa2188f9056	29f444b6-de36-4104-afc9-65bb27b34974	QUEUED	\N	2026-10-03 15:10:55.274+05:30
5b998a30-5bd7-45dd-8221-d6d54c82a97f	29f444b6-de36-4104-afc9-65bb27b34974	READY	\N	2026-10-03 15:11:33.093+05:30
00c1f3cc-8e09-4407-91c2-15ea221e3f8a	29f444b6-de36-4104-afc9-65bb27b34974	SERVED	\N	2026-10-03 15:11:36.32+05:30
b106c90c-aa78-4cbe-bce3-94be6644a29b	2b95f90e-dac0-40c1-a843-e0fbf5cd8881	READY	\N	2026-10-03 15:19:31.587+05:30
bdee0904-2e02-4bc1-85b6-31a88be7d505	2b95f90e-dac0-40c1-a843-e0fbf5cd8881	SERVED	\N	2026-10-03 15:19:32.492+05:30
502084a6-aa89-4495-97c0-a9ea8d0fab46	f72f5c9d-2a8a-4015-9eca-2ec3deaf25e3	PREPARING	\N	2026-10-06 01:00:49.136+05:30
7e1474d7-6d1d-4d14-9563-059b25f629b4	f72f5c9d-2a8a-4015-9eca-2ec3deaf25e3	READY	\N	2026-10-06 01:00:50.527+05:30
81c54343-f810-4861-9d87-f978752157e7	f72f5c9d-2a8a-4015-9eca-2ec3deaf25e3	SERVED	\N	2026-10-06 01:21:11.396+05:30
\.


--
-- Data for Name: kot_tickets; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.kot_tickets (id, outlet_id, order_id, station_id, ticket_number, status, created_at, updated_at, served_at, bill_printed_at) FROM stdin;
2464b135-bbe4-4f70-b8e9-e8ec09e036bb	67315042-c687-4cbb-b45a-f4ea4efc199f	c69c7c36-7b05-4ca7-9012-710df44ed6fd	eebe76a3-8305-409d-877b-bb5a0e2b7328	KOT-101	QUEUED	2026-09-03 12:29:17.516623+05:30	2026-09-03 12:29:17.516623+05:30	\N	\N
2faaf683-ff9a-4644-9025-2381e4c579b7	11111111-1111-1111-1111-111111111111	db187890-3de7-4a5d-87b2-9398153c343a	\N	KOT-1790149939382-860	SERVED	2026-09-23 13:22:19.384+05:30	2026-09-23 13:23:29.772+05:30	2026-09-23 13:23:29.771+05:30	\N
e253a419-f527-4300-8d90-1f2886dc2cf9	11111111-1111-1111-1111-111111111111	900efa09-cbd9-4da9-8897-1b837e07b788	\N	KOT-1790272925892-120	SERVED	2026-09-24 23:32:05.896+05:30	2026-09-24 23:32:07.162+05:30	2026-09-24 23:32:07.159+05:30	\N
4f48a1e4-a0ca-4f87-b99a-cf5e99b683d9	11111111-1111-1111-1111-111111111111	f4fbbe17-c9da-40cc-a954-1b9d7d1d6752	\N	KOT-1790273898553-825	SERVED	2026-09-24 23:48:18.562+05:30	2026-09-24 23:48:19.465+05:30	2026-09-24 23:48:19.456+05:30	\N
17f0b63a-b4a5-442c-860f-2742519688de	11111111-1111-1111-1111-111111111111	320ff853-a5fe-483c-83e1-ba5e70f75d36	\N	KOT-1790220805607-328	SERVED	2026-09-24 09:03:25.614+05:30	2026-10-02 16:57:54.618+05:30	2026-10-02 16:57:54.615+05:30	\N
c164a453-831d-49a9-83f6-0ddecdbb7c38	11111111-1111-1111-1111-111111111111	89dba099-01ad-417a-a438-66ca8af5e712	\N	KOT-1790970676067-908	SERVED	2026-10-03 01:21:16.07+05:30	2026-10-03 01:21:43.126+05:30	2026-10-03 01:21:43.124+05:30	\N
edcf8af9-6faa-4a2a-b31b-04135333d90c	11111111-1111-1111-1111-111111111111	b7899f9e-fd1e-4f77-89fc-0d935c2e2d85	\N	KOT-1790970873568-910	SERVED	2026-10-03 01:24:33.571+05:30	2026-10-03 01:24:33.864+05:30	2026-10-03 01:24:33.862+05:30	\N
659c0dff-9c8f-4696-b665-4b8fd48a2703	11111111-1111-1111-1111-111111111111	c81161e9-bd67-474a-bf80-3b1756fe5393	\N	KOT-1790970942619-236	SERVED	2026-10-03 01:25:42.624+05:30	2026-10-03 01:26:31.119+05:30	2026-10-03 01:26:31.117+05:30	\N
358a6d1d-a1c6-4b81-86dc-c3df3e8815f8	11111111-1111-1111-1111-111111111111	de5f32b6-72f6-441d-a98f-3f273e2a3bba	\N	KOT-1790971052445-953	SERVED	2026-10-03 01:27:32.447+05:30	2026-10-03 01:27:32.898+05:30	2026-10-03 01:27:32.894+05:30	\N
576b67bd-ad9e-4739-b680-69a3d8f6758f	11111111-1111-1111-1111-111111111111	6dcda227-21c2-4291-918f-a3813a9062eb	\N	KOT-1790938999907-905	SERVED	2026-10-02 16:33:19.91+05:30	2026-10-03 04:37:37.575+05:30	2026-10-03 04:37:37.573+05:30	\N
c159bb7b-ed9b-41c1-be4c-7c11324dcbef	11111111-1111-1111-1111-111111111111	6bb8a0c7-38c6-4f87-95a7-8edd80cbcfb6	\N	KOT-1791016101937-979	SERVED	2026-10-03 13:58:21.942+05:30	2026-10-03 14:01:55.475+05:30	2026-10-03 14:01:55.474+05:30	\N
29f444b6-de36-4104-afc9-65bb27b34974	11111111-1111-1111-1111-111111111111	a48e021b-e5d6-4f57-af79-3995db8f417b	\N	KOT-1791020455262-540	SERVED	2026-10-03 15:10:55.269+05:30	2026-10-03 15:11:36.315+05:30	2026-10-03 15:11:36.309+05:30	\N
2b95f90e-dac0-40c1-a843-e0fbf5cd8881	11111111-1111-1111-1111-111111111111	6bb8a0c7-38c6-4f87-95a7-8edd80cbcfb6	\N	KOT-1791018143878-218	SERVED	2026-10-03 14:32:23.881+05:30	2026-10-03 15:19:32.487+05:30	2026-10-03 15:19:32.481+05:30	\N
187ed388-52c9-4d73-bfa6-e4f96d3f8f51	67315042-c687-4cbb-b45a-f4ea4efc199f	5b433b06-af43-4f62-8a6b-e2ca1e0bfa88	eebe76a3-8305-409d-877b-bb5a0e2b7328	KOT-1788606942054-867	SERVED	2026-09-05 16:45:42.059+05:30	2026-09-05 16:45:42.161+05:30	2026-09-05 16:45:42.16+05:30	\N
4d46fa43-e341-4fe6-9c52-8134a1afafbc	11111111-1111-1111-1111-111111111111	2d4b655e-a5bf-4900-ba0c-11e1b3c2685c	\N	KOT-1788938506702-145	SERVED	2026-09-09 12:51:46.702+05:30	2026-09-15 16:15:08.359+05:30	2026-09-09 12:55:08.898+05:30	\N
2ff59c9f-4c88-49f9-923a-67919ab78b59	11111111-1111-1111-1111-111111111111	815fbab6-72c9-41f6-b104-3f8df856c545	\N	KOT-1789211424179-539	SERVED	2026-09-12 16:40:24.181+05:30	2026-09-23 13:22:47.028+05:30	2026-09-23 13:22:47.026+05:30	\N
d3d5de47-7715-4e5a-9036-ec18153e7a81	67315042-c687-4cbb-b45a-f4ea4efc199f	0c7bc59e-d90f-4a42-873f-88c0e9a02386	eebe76a3-8305-409d-877b-bb5a0e2b7328	KOT-1789116128752-721	QUEUED	2026-09-11 14:12:08.758+05:30	2026-09-11 14:12:08.758+05:30	\N	\N
a41ba409-8e7a-451d-b1d0-413fb105d4de	67315042-c687-4cbb-b45a-f4ea4efc199f	f9b4ac11-21c8-4617-9a1d-f1d7e8147a37	eebe76a3-8305-409d-877b-bb5a0e2b7328	KOT-1789116367351-377	QUEUED	2026-09-11 14:16:07.363+05:30	2026-09-11 14:16:07.363+05:30	\N	\N
63992e13-1fb0-4e62-8a36-596aa86d78ee	67315042-c687-4cbb-b45a-f4ea4efc199f	829e83e6-ea56-4173-bfe2-463b24e497a4	eebe76a3-8305-409d-877b-bb5a0e2b7328	KOT-1789116547479-481	QUEUED	2026-09-11 14:19:07.484+05:30	2026-09-11 14:19:07.484+05:30	\N	\N
0edaa267-7e8c-429a-8f9e-461a88331dc3	11111111-1111-1111-1111-111111111111	dce6709a-59c7-4b0f-b6b7-a84556fd4da8	eebe76a3-8305-409d-877b-bb5a0e2b7328	KOT-1789466209354-883	SERVED	2026-09-15 15:26:49.366+05:30	2026-09-23 15:07:00.626+05:30	2026-09-23 15:07:00.618+05:30	\N
2308bdd5-7c44-497e-ab2e-fdcd27b85d2f	11111111-1111-1111-1111-111111111111	fd16417e-3c3d-418a-a088-d360729aac73	eebe76a3-8305-409d-877b-bb5a0e2b7328	KOT-1789465935373-177	SERVED	2026-09-15 15:22:15.387+05:30	2026-09-23 15:07:04.929+05:30	2026-09-23 15:07:04.922+05:30	\N
86bcdf2f-a56c-4f32-bdf9-54016f420fab	11111111-1111-1111-1111-111111111111	00d7a187-3ebe-45bb-a596-f39d6680e588	eebe76a3-8305-409d-877b-bb5a0e2b7328	KOT-1789465821787-351	SERVED	2026-09-15 15:20:21.808+05:30	2026-09-23 15:07:07.726+05:30	2026-09-23 15:07:07.718+05:30	\N
6ceb728c-e4da-427e-adab-7033b1fc5cee	11111111-1111-1111-1111-111111111111	51ee39c7-53f2-40c4-adae-b49600c041f7	\N	KOT-1790274259040-406	SERVED	2026-09-24 23:54:19.049+05:30	2026-09-24 23:54:19.921+05:30	2026-09-24 23:54:19.913+05:30	\N
15acc1d7-199b-4d07-9163-33377b661da9	11111111-1111-1111-1111-111111111111	fd749f2c-9fde-404e-892b-0b60a6f95860	\N	KOT-1790272983573-381	SERVED	2026-09-24 23:33:03.576+05:30	2026-10-02 16:59:07.644+05:30	2026-10-02 16:59:07.642+05:30	\N
48fa95b0-63c4-4a0f-b6bd-e90ecf6c1acf	11111111-1111-1111-1111-111111111111	7bf0131c-f022-46a1-9a7b-8569cd3682f8	\N	KOT-1790970763897-572	SERVED	2026-10-03 01:22:43.9+05:30	2026-10-03 01:23:42.499+05:30	2026-10-03 01:23:42.495+05:30	\N
f3eb11eb-ebe0-471b-9fe6-dc36367e6e97	11111111-1111-1111-1111-111111111111	6dcda227-21c2-4291-918f-a3813a9062eb	\N	KOT-1790982377811-519	SERVED	2026-10-03 04:36:17.814+05:30	2026-10-03 04:37:26.487+05:30	2026-10-03 04:37:26.485+05:30	\N
ee63a88d-fd0d-4d79-a59b-3e3932d48a51	11111111-1111-1111-1111-111111111111	5736ba49-2b3d-47e0-b162-575f81bbd62c	\N	KOT-1791016238391-600	SERVED	2026-10-03 14:00:38.395+05:30	2026-10-03 14:01:54.418+05:30	2026-10-03 14:01:54.415+05:30	\N
f72f5c9d-2a8a-4015-9eca-2ec3deaf25e3	11111111-1111-1111-1111-111111111111	6040a630-394f-416c-9b97-8deef80f81f8	\N	KOT-1791018845743-473	SERVED	2026-10-03 14:44:05.746+05:30	2026-10-06 01:21:11.39+05:30	2026-10-06 01:21:11.388+05:30	\N
b7760cd0-9b35-44ed-b588-ac6b42eef3d4	11111111-1111-1111-1111-111111111111	2d4b655e-a5bf-4900-ba0c-11e1b3c2685c	\N	KOT-1788938488116-476	SERVED	2026-09-09 12:51:28.116+05:30	2026-09-15 16:15:08.359+05:30	2026-09-09 12:55:08.9+05:30	\N
66f4fcaf-d7cd-47ee-b09a-d369f60b44fb	11111111-1111-1111-1111-111111111111	2d4b655e-a5bf-4900-ba0c-11e1b3c2685c	\N	KOT-1788938474271-433	SERVED	2026-09-09 12:51:14.272+05:30	2026-09-15 16:15:08.359+05:30	2026-09-09 12:55:08.902+05:30	\N
1a483a59-4b70-4a21-a78c-e4566f492aa7	11111111-1111-1111-1111-111111111111	71ef893c-0ccc-439d-bc3e-0a248037303b	\N	KOT-1788425751927-486	SERVED	2026-09-03 14:25:51.929+05:30	2026-09-15 16:15:08.359+05:30	2026-09-03 14:45:03.142+05:30	\N
80f4fd60-0398-4b9a-b31c-ee251b10bebc	11111111-1111-1111-1111-111111111111	4a3e148b-1df0-46f8-a71a-c834486429e5	\N	KOT-1788425394652-496	SERVED	2026-09-03 14:19:54.656+05:30	2026-09-15 16:15:08.359+05:30	2026-09-03 14:45:23.359+05:30	\N
7ac440d2-529b-4a22-80da-07c102b52bcd	11111111-1111-1111-1111-111111111111	e93358df-ec3b-4e3b-a241-8e93bd953411	\N	KOT-1788425476212-820	SERVED	2026-09-03 14:21:16.214+05:30	2026-09-15 16:15:08.359+05:30	2026-09-04 00:40:27.996+05:30	\N
d0e620ed-a0fc-4793-a60e-0eee6f19dd09	11111111-1111-1111-1111-111111111111	e7eccfdc-02d5-470f-869b-da665f7dcb2e	\N	KOT-1788427391905-950	SERVED	2026-09-03 14:53:11.907+05:30	2026-09-15 16:15:08.359+05:30	2026-09-04 00:40:29.297+05:30	\N
35412261-a6db-4503-abb2-74ee5bd5db84	11111111-1111-1111-1111-111111111111	f973888e-e429-473a-8566-ddea7ac708a0	\N	KOT-1788938551701-831	SERVED	2026-09-09 12:52:31.703+05:30	2026-09-15 16:15:08.359+05:30	2026-09-09 13:49:00.591+05:30	\N
d8cf458f-c314-4de9-8fd0-534915e77a5a	11111111-1111-1111-1111-111111111111	2d4b655e-a5bf-4900-ba0c-11e1b3c2685c	\N	KOT-1788938756572-585	SERVED	2026-09-09 12:55:56.573+05:30	2026-09-15 16:15:08.359+05:30	2026-09-09 13:49:01.064+05:30	\N
2ae3bb5c-9171-4f02-8aec-88611bd9216a	11111111-1111-1111-1111-111111111111	190ec2cb-fb90-44c2-ad76-b32672063fdb	\N	KOT-1788939085214-126	SERVED	2026-09-09 13:01:25.213+05:30	2026-09-15 16:15:08.359+05:30	2026-09-09 13:49:01.483+05:30	\N
a8088c10-855e-46d2-bc70-3b2bda97e583	11111111-1111-1111-1111-111111111111	c8387bcf-ab67-44bb-87fb-d67f6d7601ca	\N	KOT-1789110207254-720	SERVED	2026-09-11 12:33:27.256+05:30	2026-09-15 16:15:08.359+05:30	2026-09-11 12:33:47.938+05:30	\N
81985f31-1b69-4a6a-abf8-6c0a638dcf02	11111111-1111-1111-1111-111111111111	4a4e9d6c-a797-4b03-9835-a44526c890e2	\N	KOT-1789116928541-810	SERVED	2026-09-11 14:25:28.546+05:30	2026-09-15 16:15:08.359+05:30	2026-09-11 14:44:32.314+05:30	\N
3d8f581a-fd89-4cf7-9704-3f02a696684e	11111111-1111-1111-1111-111111111111	89dba099-01ad-417a-a438-66ca8af5e712	\N	KOT-1789116859902-926	SERVED	2026-09-11 14:24:19.904+05:30	2026-09-15 16:15:08.359+05:30	2026-09-11 14:44:37.605+05:30	\N
ce6781a5-807c-4628-922f-b4783e87adf0	11111111-1111-1111-1111-111111111111	d8d53271-b231-47e9-93aa-7a47185f8940	\N	KOT-1789111770656-832	SERVED	2026-09-11 12:59:30.66+05:30	2026-09-15 16:15:08.359+05:30	2026-09-11 16:21:08.568+05:30	\N
cf12e201-ceb6-40ba-a0f4-fe1b0e5aac61	11111111-1111-1111-1111-111111111111	4a4e9d6c-a797-4b03-9835-a44526c890e2	\N	KOT-1789124977852-940	SERVED	2026-09-11 16:39:37.855+05:30	2026-09-15 16:15:08.359+05:30	2026-09-12 12:11:28.257+05:30	\N
7b921377-29d0-4537-a67a-bddf6caeb385	11111111-1111-1111-1111-111111111111	ccffe940-9f6b-41af-aaeb-72b3e1cdb3da	\N	KOT-1789111792837-509	SERVED	2026-09-11 12:59:52.84+05:30	2026-09-15 16:15:08.359+05:30	2026-09-12 15:31:15.344+05:30	\N
419da55d-d450-436d-9e7a-6f8cc0cb751a	11111111-1111-1111-1111-111111111111	abaed738-9e4f-4470-ae04-031b3baa4721	\N	KOT-1789209279636-845	SERVED	2026-09-12 16:04:39.64+05:30	2026-09-15 16:15:08.359+05:30	2026-09-12 16:05:29.956+05:30	\N
1a8e73d0-d3a5-4d51-974f-2f255be03cb9	11111111-1111-1111-1111-111111111111	8139a10d-c414-4402-818c-ea00cfd5e786	\N	KOT-1789210251891-531	SERVED	2026-09-12 16:20:51.894+05:30	2026-09-15 16:15:08.359+05:30	2026-09-12 16:21:26.872+05:30	\N
a834cfdd-33c9-4650-bc7f-23a9b7168809	11111111-1111-1111-1111-111111111111	547361f1-ab65-4eeb-b5ae-790378f1eebc	\N	KOT-1789210329524-699	SERVED	2026-09-12 16:22:09.527+05:30	2026-09-15 16:15:08.359+05:30	2026-09-12 16:22:24.148+05:30	\N
c0b2c455-e902-4758-b2aa-dda79c0fd74e	11111111-1111-1111-1111-111111111111	7bf0131c-f022-46a1-9a7b-8569cd3682f8	\N	KOT-1789210405030-600	SERVED	2026-09-12 16:23:25.032+05:30	2026-09-15 16:15:08.359+05:30	2026-09-12 16:37:03.943+05:30	\N
c77f90c7-f328-45ef-90fa-724c0fb7e829	11111111-1111-1111-1111-111111111111	7bf0131c-f022-46a1-9a7b-8569cd3682f8	\N	KOT-1789211254122-386	SERVED	2026-09-12 16:37:34.13+05:30	2026-09-15 16:15:08.359+05:30	2026-09-12 16:38:07.864+05:30	\N
0a8cc3a0-92d2-4f37-b85f-1818a5d433c7	11111111-1111-1111-1111-111111111111	4e192b03-6942-454a-a9dd-9084d99362b1	\N	KOT-1788939122261-731	SERVED	2026-09-09 13:02:02.263+05:30	2026-09-15 16:15:08.359+05:30	2026-09-09 13:49:02.055+05:30	\N
e41f4c53-4fb8-467b-b40e-4a53b8479164	11111111-1111-1111-1111-111111111111	9528cbcc-5873-41a3-b142-53165932bc70	\N	KOT-1788939123769-457	SERVED	2026-09-09 13:02:03.771+05:30	2026-09-15 16:15:08.359+05:30	2026-09-09 13:49:02.534+05:30	\N
fce3d545-2638-41d6-b6f3-f8a0683e9150	11111111-1111-1111-1111-111111111111	39f6e5e8-3eb1-4100-a8cc-4dfcb49ba060	\N	KOT-1788939217898-804	SERVED	2026-09-09 13:03:37.9+05:30	2026-09-15 16:15:08.359+05:30	2026-09-09 13:49:03.038+05:30	\N
da6358fd-b56e-4bad-bcc0-0af0ec94b26b	11111111-1111-1111-1111-111111111111	118a762d-2cc4-4b94-b0c6-1b7360cd6652	\N	KOT-1788939219401-686	SERVED	2026-09-09 13:03:39.401+05:30	2026-09-15 16:15:08.359+05:30	2026-09-09 13:49:03.609+05:30	\N
476f5980-0930-496c-8c4a-9eaf395a75cf	11111111-1111-1111-1111-111111111111	5583e31e-48a5-435a-936e-aba2f8bb9c9c	\N	KOT-1788428840273-961	SERVED	2026-09-03 15:17:20.278+05:30	2026-09-15 16:15:08.359+05:30	2026-09-04 00:43:39.248+05:30	\N
aaeb22ca-77d9-4125-93fb-ffaddabfd1ab	11111111-1111-1111-1111-111111111111	e7eccfdc-02d5-470f-869b-da665f7dcb2e	\N	KOT-1788460364867-616	SERVED	2026-09-04 00:02:44.87+05:30	2026-09-15 16:15:08.359+05:30	2026-09-04 00:43:39.847+05:30	\N
780db29f-b971-4fb9-a7c4-e45ad3fe81f4	11111111-1111-1111-1111-111111111111	0f621958-d193-4d99-b6ef-037fcea9cd0a	\N	KOT-1788460522360-838	SERVED	2026-09-04 00:05:22.366+05:30	2026-09-15 16:15:08.359+05:30	2026-09-04 00:43:40.456+05:30	\N
314f59d3-358c-4d0d-82ce-e2348b2f5869	11111111-1111-1111-1111-111111111111	a00d57c3-c01d-49d0-9166-45e9f7e22497	\N	KOT-1788462655753-584	SERVED	2026-09-04 00:40:55.756+05:30	2026-09-15 16:15:08.359+05:30	2026-09-04 00:43:46.594+05:30	\N
f72e5dc0-f56e-451b-a014-cd4419cacbdf	11111111-1111-1111-1111-111111111111	0f621958-d193-4d99-b6ef-037fcea9cd0a	\N	KOT-1788460557388-73	SERVED	2026-09-04 00:05:57.393+05:30	2026-09-15 16:15:08.359+05:30	2026-09-04 00:44:05.583+05:30	\N
9a5c4cc8-4b11-4022-b5c1-6d4bedb3b01b	11111111-1111-1111-1111-111111111111	ece12171-62db-4f53-ba97-d5e93e06f733	\N	KOT-1788464073375-875	SERVED	2026-09-04 01:04:33.377+05:30	2026-09-15 16:15:08.359+05:30	2026-09-04 01:06:00.055+05:30	\N
e0c7eff8-6e10-43b7-bc2a-9be10a9a091b	11111111-1111-1111-1111-111111111111	a00d57c3-c01d-49d0-9166-45e9f7e22497	\N	KOT-1788594595679-758	SERVED	2026-09-05 13:19:55.685+05:30	2026-09-15 16:15:08.359+05:30	2026-09-05 13:20:37.737+05:30	\N
39863209-183e-4007-a67f-cf22d00609b9	11111111-1111-1111-1111-111111111111	0a746ebb-ff2b-40d1-8d00-5e7652f56006	\N	KOT-1788944246222-39	SERVED	2026-09-09 14:27:26.23+05:30	2026-09-15 16:15:08.359+05:30	2026-09-09 15:08:54.407+05:30	\N
022f9506-96ce-4851-b531-11b374d9f3eb	11111111-1111-1111-1111-111111111111	0f3580d0-cceb-4289-99f8-5ffdf1669b18	\N	KOT-1788601212640-908	SERVED	2026-09-05 15:10:12.642+05:30	2026-09-15 16:15:08.359+05:30	2026-09-05 15:10:12.83+05:30	\N
3a8544bd-e646-4dca-a8aa-4451fcfcc675	11111111-1111-1111-1111-111111111111	0a746ebb-ff2b-40d1-8d00-5e7652f56006	\N	KOT-1788944745631-571	SERVED	2026-09-09 14:35:45.633+05:30	2026-09-15 16:15:08.359+05:30	2026-09-09 15:08:54.407+05:30	\N
1a8d8383-c9bc-481e-8700-176bf3b7c38b	11111111-1111-1111-1111-111111111111	c3a366cb-039e-4e26-9cbd-8e22cd2d52b9	\N	KOT-1788605558225-814	SERVED	2026-09-05 16:22:38.227+05:30	2026-09-15 16:15:08.359+05:30	2026-09-05 16:23:36.487+05:30	\N
5b4062b9-77fe-4305-b776-65b479de232f	11111111-1111-1111-1111-111111111111	3e1ba9c8-0311-4534-a8d3-fa97b3a4f933	\N	KOT-1788946760406-281	SERVED	2026-09-09 15:09:20.407+05:30	2026-09-15 16:15:08.359+05:30	2026-09-10 16:49:54.852+05:30	\N
5d32816c-fd4d-4bb9-8a24-2180b08fa1b8	11111111-1111-1111-1111-111111111111	7a369854-faf1-4af3-8378-8b939249c434	\N	KOT-1788607292753-642	SERVED	2026-09-05 16:51:32.755+05:30	2026-09-15 16:15:08.359+05:30	2026-09-05 16:51:32.894+05:30	\N
4a1fae02-9a34-4e15-a9b9-bcd4df784612	11111111-1111-1111-1111-111111111111	82e2a068-a74a-4e18-89fe-7a423f5b243f	\N	KOT-1788608155002-507	SERVED	2026-09-05 17:05:55.005+05:30	2026-09-15 16:15:08.359+05:30	2026-09-05 17:14:44.769+05:30	\N
91c40700-9ebf-4753-b454-24ddf11da7f9	11111111-1111-1111-1111-111111111111	1085cebe-ebf0-4804-83f3-aae6d0d4a7c9	\N	KOT-1788845704410-425	SERVED	2026-09-08 11:05:04.422+05:30	2026-09-15 16:15:08.359+05:30	2026-09-08 11:05:57.593+05:30	\N
e566733f-ccfd-4fa4-b750-c96cde787323	11111111-1111-1111-1111-111111111111	3e1ba9c8-0311-4534-a8d3-fa97b3a4f933	\N	KOT-1789039253111-173	SERVED	2026-09-10 16:50:53.114+05:30	2026-09-15 16:15:08.359+05:30	2026-09-10 16:52:36.08+05:30	\N
a05cc85f-571d-457d-8fb9-2736dd584304	11111111-1111-1111-1111-111111111111	1085cebe-ebf0-4804-83f3-aae6d0d4a7c9	\N	KOT-1788845941399-145	SERVED	2026-09-08 11:09:01.401+05:30	2026-09-15 16:15:08.359+05:30	2026-09-08 11:09:26.513+05:30	\N
0b2b03d2-b645-49b9-8644-1a36bc48a18a	11111111-1111-1111-1111-111111111111	482d35cd-b7b6-4c65-a7f3-943897646bad	\N	KOT-1788944338361-266	SERVED	2026-09-09 14:28:58.379+05:30	2026-09-15 16:15:08.359+05:30	2026-09-11 11:09:55.368+05:30	\N
6263318d-e12b-43cf-9c36-9ee3f17e597e	11111111-1111-1111-1111-111111111111	e7d4d6cf-4838-43bd-8334-688d11302496	\N	KOT-1788846126986-164	SERVED	2026-09-08 11:12:06.988+05:30	2026-09-15 16:15:08.359+05:30	2026-09-08 11:12:15.009+05:30	\N
38d4de12-7ca2-48b6-8856-15027f1d154b	11111111-1111-1111-1111-111111111111	e7d4d6cf-4838-43bd-8334-688d11302496	\N	KOT-1788598579158-620	SERVED	2026-09-05 14:26:19.16+05:30	2026-09-15 16:15:08.359+05:30	2026-09-08 11:14:49.107+05:30	\N
00089db3-43f2-4348-bbff-da57724bc4eb	11111111-1111-1111-1111-111111111111	b5177d27-2e27-4abd-8296-83a748730b2c	\N	KOT-1788464996543-783	SERVED	2026-09-04 01:19:56.545+05:30	2026-09-15 16:15:08.359+05:30	2026-09-08 13:11:42.266+05:30	\N
4ff03eac-fde7-4266-96fe-a868df825efd	11111111-1111-1111-1111-111111111111	25ab98b4-6057-4986-a634-4dd7dc5f51bc	\N	KOT-1788944383560-965	SERVED	2026-09-09 14:29:43.563+05:30	2026-09-15 16:15:08.359+05:30	2026-09-11 11:10:04.488+05:30	\N
15cb65ba-80c2-48ed-883e-dbeb46d9dcda	11111111-1111-1111-1111-111111111111	65505588-f509-44ef-a6c6-c488503dcbe3	\N	KOT-1788944474683-706	SERVED	2026-09-09 14:31:14.686+05:30	2026-09-15 16:15:08.359+05:30	2026-09-11 11:10:05.974+05:30	\N
2b9b7a79-3fc2-4a24-ab97-ff472596e66b	11111111-1111-1111-1111-111111111111	eb13fd97-c972-4447-8a42-898eb545191e	\N	KOT-1788853394931-883	SERVED	2026-09-08 13:13:14.936+05:30	2026-09-15 16:15:08.359+05:30	2026-09-08 13:13:48.581+05:30	\N
4728ca77-caa1-49de-a309-254613a1cad3	11111111-1111-1111-1111-111111111111	f5d3449d-ce21-48cb-ab01-b41c41a7301c	\N	KOT-1788853455306-197	SERVED	2026-09-08 13:14:15.312+05:30	2026-09-15 16:15:08.359+05:30	2026-09-08 13:15:08.733+05:30	\N
2508d470-13d4-4db2-a796-75774ccb80c2	11111111-1111-1111-1111-111111111111	c182470d-5000-40bc-86f8-b9093c4333e8	\N	KOT-1788944253896-633	SERVED	2026-09-09 14:27:33.901+05:30	2026-09-15 16:15:08.359+05:30	2026-09-11 11:10:15.591+05:30	\N
d2d5e040-193a-4e9a-ab00-8ba1614f5266	11111111-1111-1111-1111-111111111111	f5d3449d-ce21-48cb-ab01-b41c41a7301c	\N	KOT-1788857069254-796	SERVED	2026-09-08 14:14:29.258+05:30	2026-09-15 16:15:08.359+05:30	2026-09-08 14:15:27.39+05:30	\N
c3b2a555-0bb8-4140-aa3b-16a067935d7f	11111111-1111-1111-1111-111111111111	b101f725-9679-4cf3-9f0f-16adb200ecff	\N	KOT-1788857844467-286	SERVED	2026-09-08 14:27:24.476+05:30	2026-09-15 16:15:08.359+05:30	2026-09-08 14:39:22.764+05:30	\N
ecb0bac6-06b0-4a59-b4d7-8c2c1686dc67	11111111-1111-1111-1111-111111111111	b6abe3e6-d0e7-4dc7-a631-097181effc3a	\N	KOT-1788944519392-132	SERVED	2026-09-09 14:31:59.395+05:30	2026-09-15 16:15:08.359+05:30	2026-09-11 11:10:55.567+05:30	\N
fc89f774-0dc4-4795-9f68-edd8df66905c	11111111-1111-1111-1111-111111111111	d71091c4-71f0-4c75-bd38-c6b08ba4dd4a	\N	KOT-1788944568922-805	SERVED	2026-09-09 14:32:48.928+05:30	2026-09-15 16:15:08.359+05:30	2026-09-11 11:10:56.509+05:30	\N
933f4133-630c-48df-b056-4502946eb0ae	11111111-1111-1111-1111-111111111111	d1467f47-4869-4592-996e-0d3f373ec018	\N	KOT-1788944641538-490	SERVED	2026-09-09 14:34:01.542+05:30	2026-09-15 16:15:08.359+05:30	2026-09-11 11:10:57.332+05:30	\N
753c5eb7-0772-4082-b9ea-3cbff53d0f1d	11111111-1111-1111-1111-111111111111	685aa7a6-e1d4-4a39-a7fe-c54252180927	\N	KOT-1788858713606-875	SERVED	2026-09-08 14:41:53.608+05:30	2026-09-15 16:15:08.359+05:30	2026-09-08 14:44:38.639+05:30	\N
7c360f83-927b-4dea-9514-b7815a12a4f5	11111111-1111-1111-1111-111111111111	27f9f630-3e8b-4ba9-b4d7-e631e45182f7	\N	KOT-1789108786371-254	SERVED	2026-09-11 12:09:46.376+05:30	2026-09-15 16:15:08.359+05:30	2026-09-11 12:34:03.683+05:30	\N
97823311-3165-4981-bb4a-f701b6c54e81	11111111-1111-1111-1111-111111111111	f5d3449d-ce21-48cb-ab01-b41c41a7301c	\N	KOT-1788864567309-211	SERVED	2026-09-08 16:19:27.314+05:30	2026-09-15 16:15:08.359+05:30	2026-09-08 16:19:42.451+05:30	\N
387bfcae-81d2-4138-b9af-783ed452a554	11111111-1111-1111-1111-111111111111	76692730-cd05-45cd-b8ad-9cc20ac9fc5a	\N	KOT-1788860625124-162	SERVED	2026-09-08 15:13:45.127+05:30	2026-09-15 16:15:08.359+05:30	2026-09-09 12:45:15.879+05:30	\N
cde85ae8-efc8-4329-9983-c65db7879821	11111111-1111-1111-1111-111111111111	0602cb47-3398-4ba0-b5da-87e23909efa3	\N	KOT-1788938250797-418	SERVED	2026-09-09 12:47:30.797+05:30	2026-09-15 16:15:08.359+05:30	2026-09-09 12:50:26.931+05:30	\N
4a26f71a-500e-456d-a69b-5dc7529906e8	11111111-1111-1111-1111-111111111111	0602cb47-3398-4ba0-b5da-87e23909efa3	\N	KOT-1788938270736-697	SERVED	2026-09-09 12:47:50.738+05:30	2026-09-15 16:15:08.359+05:30	2026-09-09 12:50:27.44+05:30	\N
0d5f81a3-df18-49f4-92ac-ca9b95a7273f	11111111-1111-1111-1111-111111111111	0602cb47-3398-4ba0-b5da-87e23909efa3	\N	KOT-1788938304617-426	SERVED	2026-09-09 12:48:24.617+05:30	2026-09-15 16:15:08.359+05:30	2026-09-09 12:50:27.705+05:30	\N
da54b04f-218d-441e-91d5-44e74856c1c6	11111111-1111-1111-1111-111111111111	0602cb47-3398-4ba0-b5da-87e23909efa3	\N	KOT-1788938363892-994	SERVED	2026-09-09 12:49:23.892+05:30	2026-09-15 16:15:08.359+05:30	2026-09-09 12:50:28.165+05:30	\N
2856b23d-c54c-40f5-8182-6f14262eeabe	11111111-1111-1111-1111-111111111111	cbb10a15-6c98-4ad1-a42b-ae7e1f56f9b7	\N	KOT-1789469147832-619	SERVED	2026-09-15 16:15:47.838+05:30	2026-09-23 15:07:18.334+05:30	2026-09-23 15:07:18.326+05:30	\N
d1297e69-174f-4bfe-a0b9-2355d35d656c	11111111-1111-1111-1111-111111111111	244aecef-ffc4-48ba-a00c-0e041ee50389	\N	KOT-1789469148005-673	SERVED	2026-09-15 16:15:48.01+05:30	2026-09-24 09:03:36.115+05:30	2026-09-24 09:03:36.111+05:30	\N
d333c254-e18f-4e85-973d-cc2e0a8e007d	11111111-1111-1111-1111-111111111111	3d9c934c-97d3-4da2-8f4b-4772896ee29b	\N	KOT-1790275020731-478	SERVED	2026-09-25 00:07:00.736+05:30	2026-09-25 00:07:01.614+05:30	2026-09-25 00:07:01.607+05:30	\N
1297bf76-8760-4e9a-8d2e-a569614f4ae5	11111111-1111-1111-1111-111111111111	af21c0cc-a9e8-459c-b797-ddb34bb7f724	\N	KOT-1790970844822-152	SERVED	2026-10-03 01:24:04.827+05:30	2026-10-03 01:24:20.002+05:30	2026-10-03 01:24:19.998+05:30	\N
37efc7b2-84f0-4fd1-8917-044af55d4050	11111111-1111-1111-1111-111111111111	96b6a769-53e4-47b5-b329-af8e6a597f73	\N	KOT-1790273022664-499	SERVED	2026-09-24 23:33:42.667+05:30	2026-10-03 04:37:35.635+05:30	2026-10-03 04:37:35.634+05:30	\N
4891fe55-6466-4341-bef8-1d58f13d5372	11111111-1111-1111-1111-111111111111	300e3125-c13a-4c6f-9548-9d7ec596529f	\N	KOT-1790273021176-154	SERVED	2026-09-24 23:33:41.179+05:30	2026-10-03 04:37:40.919+05:30	2026-10-03 04:37:40.917+05:30	\N
6c8d44fc-8a01-4f5f-ac7b-c3acc20daf38	11111111-1111-1111-1111-111111111111	6040a630-394f-416c-9b97-8deef80f81f8	\N	KOT-1791016451612-928	SERVED	2026-10-03 14:04:11.617+05:30	2026-10-03 14:04:20.483+05:30	2026-10-03 14:04:20.478+05:30	\N
d145fb1d-3e84-455d-b116-ba8ebf882529	11111111-1111-1111-1111-111111111111	5736ba49-2b3d-47e0-b162-575f81bbd62c	\N	KOT-1791018898646-370	SERVED	2026-10-03 14:44:58.648+05:30	2026-10-03 14:46:35.85+05:30	2026-10-03 14:46:35.848+05:30	\N
\.


--
-- Data for Name: ledger_entries; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.ledger_entries (id, outlet_id, source_type, source_id, account, debit_minor, credit_minor, external_ref, status, created_at, posted_at) FROM stdin;
5ff3fac8-cdbd-4ad9-abf4-99b93a9e444d	67315042-c687-4cbb-b45a-f4ea4efc199f	SETTLEMENT	OPENING-BAL-1010-CASH	1010-CASH	500000	0	OPENING-VOUCHER-1010-CASH	POSTED	2026-09-02 16:32:45.63+05:30	2026-09-02 16:32:45.611+05:30
dfb55280-15c6-440f-b40f-b0f1f4e17223	67315042-c687-4cbb-b45a-f4ea4efc199f	SETTLEMENT	OPENING-BAL-1020-BANK-HDFC	1020-BANK-HDFC	2500000	0	OPENING-VOUCHER-1020-BANK-HDFC	POSTED	2026-09-02 16:32:45.637+05:30	2026-09-02 16:32:45.621+05:30
8e262bcb-1177-4c1d-8445-bec4b8eb63f3	67315042-c687-4cbb-b45a-f4ea4efc199f	SETTLEMENT	OPENING-BAL-EQUITY	3010-OWNERS-CAPITAL	0	3000000	OPENING-VOUCHER-EQUITY	POSTED	2026-09-02 16:32:45.64+05:30	2026-09-02 16:32:45.624+05:30
\.


--
-- Data for Name: loyalty_accounts; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.loyalty_accounts (id, customer_id, balance, tier, created_at, updated_at, created_by, updated_by) FROM stdin;
b63b31ed-c666-42e5-979a-b0cf40ab74fa	724eba8c-0924-4006-9ddb-ca86aa4e96eb	0	SILVER	2026-09-12 11:38:00.647+05:30	2026-09-12 11:38:00.647+05:30	\N	\N
ef8c8f0d-67d5-42eb-9dfb-fe2081afec22	c158b890-ee02-405e-bfb2-57b349e6eeb3	100	SILVER	2026-09-12 12:03:15.682+05:30	2026-09-12 12:03:15.682+05:30	\N	\N
4bfbb255-1aaf-4d10-8a3f-27a7920fca14	509bcc9b-7529-497d-b987-29ee463cf67e	50	SILVER	2026-09-12 12:16:21.117+05:30	2026-09-12 12:16:21.117+05:30	\N	\N
\.


--
-- Data for Name: marketing_campaigns; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.marketing_campaigns (id, outlet_id, name, trigger_type, segment_filter, discount_id, message_template, status, created_at, updated_at, created_by) FROM stdin;
1c31b540-9540-4b01-aadb-f98054d07106	67315042-c687-4cbb-b45a-f4ea4efc199f	Weekend Biryani Fest	MANUAL	\N	\N	Enjoy 20% off on all signature biryanis this weekend at Hotel Kapila! Show code BIRYANI20 at billing.	ACTIVE	2026-09-03 12:29:17.44664+05:30	2026-09-03 12:29:17.44664+05:30	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
\.


--
-- Data for Name: menu_categories; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.menu_categories (id, outlet_id, name, online_display_name, sort_order, is_active, created_at, updated_at, description) FROM stdin;
60d4a197-f11c-4267-a7de-92220a27dc4b	67315042-c687-4cbb-b45a-f4ea4efc199f	Biryani (Veg)	\N	1	t	2026-09-02 15:25:57.433+05:30	2026-09-02 16:21:33.872+05:30	\N
8fcde4bd-6deb-4827-b69b-f748741f5aea	67315042-c687-4cbb-b45a-f4ea4efc199f	Biryani (Non-Veg)	\N	2	t	2026-09-02 15:25:57.445+05:30	2026-09-02 16:21:33.877+05:30	\N
12251ad8-147d-463e-a33a-30daa7aaabf7	67315042-c687-4cbb-b45a-f4ea4efc199f	Tandoori Starters (Non-Veg)	\N	3	t	2026-09-02 15:25:57.449+05:30	2026-09-02 16:21:33.88+05:30	\N
f718f498-932d-49f6-8b6b-59a29a37e49e	67315042-c687-4cbb-b45a-f4ea4efc199f	Chinese Starters (Veg)	\N	4	t	2026-09-02 15:25:57.452+05:30	2026-09-02 16:21:33.884+05:30	\N
afca0de8-7edc-4f29-93a4-17fcdce5e27e	67315042-c687-4cbb-b45a-f4ea4efc199f	Curries (Non-Veg)	\N	5	t	2026-09-02 15:25:57.456+05:30	2026-09-02 16:21:33.888+05:30	\N
a49cfb2b-5641-43b5-ae43-96d0d1b55be1	67315042-c687-4cbb-b45a-f4ea4efc199f	Roti & Breads	\N	6	t	2026-09-02 15:25:57.459+05:30	2026-09-02 16:21:33.892+05:30	\N
2a4082ac-2df2-422b-b7f9-cf96755949f3	67315042-c687-4cbb-b45a-f4ea4efc199f	Cold Beverage	\N	7	t	2026-09-02 15:25:57.462+05:30	2026-09-02 16:21:33.896+05:30	\N
735379c7-6bd9-4ed0-be64-40d8bf1e7de8	67315042-c687-4cbb-b45a-f4ea4efc199f	MOCKTAILS	\N	8	t	2026-09-02 15:25:57.465+05:30	2026-09-02 16:21:33.9+05:30	\N
68413038-40bc-4f99-988e-7a72c60094e0	2a543c3c-066f-4097-833a-df7c25700580	Breakfast	\N	1	t	2026-09-02 16:33:25.805+05:30	2026-09-02 16:33:25.805+05:30	Traditional South Indian Breakfast
bd5fd925-8442-4a2c-b952-de8a4e0181ee	2a543c3c-066f-4097-833a-df7c25700580	Meal Box (Online)	\N	2	t	2026-09-02 16:33:25.809+05:30	2026-09-02 16:33:25.809+05:30	Combo meal boxes for delivery
814499c3-e704-42df-89ab-5bc9806e2089	2a543c3c-066f-4097-833a-df7c25700580	Cold Beverage	\N	3	t	2026-09-02 16:33:25.814+05:30	2026-09-02 16:33:25.814+05:30	Chilled juices, lassi and soft drinks
da1e0528-b69e-4eaf-b3cc-62429b61e75e	2a543c3c-066f-4097-833a-df7c25700580	Hot Beverages	\N	4	t	2026-09-02 16:33:25.819+05:30	2026-09-02 16:33:25.819+05:30	Filter coffee, tea and soups
b8c64dd2-0140-44b4-a64b-aae3c6c2c9d5	2a543c3c-066f-4097-833a-df7c25700580	Soup(Veg)	\N	5	t	2026-09-02 16:33:25.823+05:30	2026-09-02 16:33:25.823+05:30	Vegetarian hot soups
6ad7a5cf-0734-45b4-a171-aaeba1c44c95	2a543c3c-066f-4097-833a-df7c25700580	Meals	\N	6	t	2026-09-02 16:33:25.826+05:30	2026-09-02 16:33:25.826+05:30	South & North Indian Full Meals
0a99d107-4268-42ed-9f87-a57b16d450e7	2a543c3c-066f-4097-833a-df7c25700580	Chinese Starters (Veg)	\N	7	t	2026-09-02 16:33:25.83+05:30	2026-09-02 16:33:25.83+05:30	Crispy veg appetizers
0b64120a-6ded-4c63-9a87-8dbafd81a1bc	2a543c3c-066f-4097-833a-df7c25700580	Curries (Veg)	\N	8	t	2026-09-02 16:33:25.835+05:30	2026-09-02 16:33:25.835+05:30	Paneer and mixed vegetable curries
ccdac5f4-9e06-4d17-9212-df78bbb3ef2e	67315042-c687-4cbb-b45a-f4ea4efc199f	Curries (Veg)	\N	0	t	2026-09-03 13:45:53.250482+05:30	2026-09-03 13:45:53.250482+05:30	Paneer and mixed vegetable curries
ff151b4d-9fe3-4ab1-a0f6-d803109ee432	67315042-c687-4cbb-b45a-f4ea4efc199f	Meals	\N	0	t	2026-09-03 13:45:53.2538+05:30	2026-09-03 13:45:53.2538+05:30	South & North Indian Full Meals
6b47802d-d31d-4d52-9c5e-001f4674f85e	67315042-c687-4cbb-b45a-f4ea4efc199f	Breakfast	\N	0	t	2026-09-03 13:45:53.255705+05:30	2026-09-03 13:45:53.255705+05:30	Traditional South Indian Breakfast
de6e8b83-db5a-4c10-b432-6b5a66959cc4	67315042-c687-4cbb-b45a-f4ea4efc199f	Hot Beverages	\N	0	t	2026-09-03 13:45:53.258576+05:30	2026-09-03 13:45:53.258576+05:30	Filter coffee, tea and soups
2553c114-60e6-4ffd-a050-c41a6c3bf846	67315042-c687-4cbb-b45a-f4ea4efc199f	Soup(Veg)	\N	0	t	2026-09-03 13:45:53.261181+05:30	2026-09-03 13:45:53.261181+05:30	Vegetarian hot soups
1541649d-c982-46a7-a228-ad78aba10f6c	67315042-c687-4cbb-b45a-f4ea4efc199f	Meal Box (Online)	\N	0	t	2026-09-03 13:45:53.264327+05:30	2026-09-03 13:45:53.264327+05:30	Combo meal boxes for delivery
9f32e838-0597-41ad-97d7-6412c26afe7b	2a543c3c-066f-4097-833a-df7c25700580	Curries (Non-Veg)	\N	0	t	2026-09-03 13:45:53.266154+05:30	2026-09-03 13:45:53.266154+05:30	\N
e10d567d-babb-4e94-a79a-eb3a48de4812	2a543c3c-066f-4097-833a-df7c25700580	Biryani (Veg)	\N	0	t	2026-09-03 13:45:53.26789+05:30	2026-09-03 13:45:53.26789+05:30	\N
a976ef06-5bbd-4e1a-ba06-59ac9b0a6b84	2a543c3c-066f-4097-833a-df7c25700580	MOCKTAILS	\N	0	t	2026-09-03 13:45:53.269234+05:30	2026-09-03 13:45:53.269234+05:30	\N
630f03b9-480d-4107-84e1-57e43df0a45e	2a543c3c-066f-4097-833a-df7c25700580	Roti & Breads	\N	0	t	2026-09-03 13:45:53.270445+05:30	2026-09-03 13:45:53.270445+05:30	\N
e4b000a5-48de-44ba-bf02-3929b1f75c89	2a543c3c-066f-4097-833a-df7c25700580	Tandoori Starters (Non-Veg)	\N	0	t	2026-09-03 13:45:53.27349+05:30	2026-09-03 13:45:53.27349+05:30	\N
7e99f115-5a4e-404a-880d-118faff89110	2a543c3c-066f-4097-833a-df7c25700580	Biryani (Non-Veg)	\N	0	t	2026-09-03 13:45:53.276495+05:30	2026-09-03 13:45:53.276495+05:30	\N
c332c03a-b4ff-4db0-b13f-b241c651abc8	11111111-1111-1111-1111-111111111111	Chinese Starters (Veg)	\N	0	t	2026-09-03 13:45:53.280553+05:30	2026-09-03 13:45:53.280553+05:30	\N
9923f0e7-8519-4e37-af76-137a8781e285	11111111-1111-1111-1111-111111111111	Curries (Non-Veg)	\N	0	t	2026-09-03 13:45:53.282132+05:30	2026-09-03 13:45:53.282132+05:30	\N
e18291bb-1c6d-426d-a753-c58922a38598	11111111-1111-1111-1111-111111111111	Biryani (Veg)	\N	0	t	2026-09-03 13:45:53.284254+05:30	2026-09-03 13:45:53.284254+05:30	\N
226608d8-4b01-406d-a0bc-3da3381efd44	11111111-1111-1111-1111-111111111111	MOCKTAILS	\N	0	t	2026-09-03 13:45:53.286221+05:30	2026-09-03 13:45:53.286221+05:30	\N
ef059e72-0460-4ec5-8faf-ca1bd16ce17e	11111111-1111-1111-1111-111111111111	Roti & Breads	\N	0	t	2026-09-03 13:45:53.288073+05:30	2026-09-03 13:45:53.288073+05:30	\N
1a8e9f1a-9874-41b3-b04e-dcff9cbd9c52	11111111-1111-1111-1111-111111111111	Curries (Veg)	\N	0	t	2026-09-03 13:45:53.289721+05:30	2026-09-03 13:45:53.289721+05:30	Paneer and mixed vegetable curries
ecde6efc-8c90-4e6c-bac7-c30e1a98089c	11111111-1111-1111-1111-111111111111	Meals	\N	0	t	2026-09-03 13:45:53.290974+05:30	2026-09-03 13:45:53.290974+05:30	South & North Indian Full Meals
bc2819ef-3f7e-4c79-a692-bb059757eeae	11111111-1111-1111-1111-111111111111	Cold Beverage	\N	0	t	2026-09-03 13:45:53.29238+05:30	2026-09-03 13:45:53.29238+05:30	\N
a65ebbc1-bfb6-42ce-95cf-112d5a76e825	11111111-1111-1111-1111-111111111111	Breakfast	\N	0	t	2026-09-03 13:45:53.294005+05:30	2026-09-03 13:45:53.294005+05:30	Traditional South Indian Breakfast
00e25236-2c50-4e2b-818d-88c104db92bb	11111111-1111-1111-1111-111111111111	Tandoori Starters (Non-Veg)	\N	0	t	2026-09-03 13:45:53.295872+05:30	2026-09-03 13:45:53.295872+05:30	\N
764ab8d6-7220-4bfb-bb9f-23f7d804bc71	11111111-1111-1111-1111-111111111111	Hot Beverages	\N	0	t	2026-09-03 13:45:53.297993+05:30	2026-09-03 13:45:53.297993+05:30	Filter coffee, tea and soups
c6d92d2d-adeb-4d91-b143-097e7b3ef69a	11111111-1111-1111-1111-111111111111	Soup(Veg)	\N	0	t	2026-09-03 13:45:53.300002+05:30	2026-09-03 13:45:53.300002+05:30	Vegetarian hot soups
26fd5701-0ca8-4a3d-8a30-706cca828e47	11111111-1111-1111-1111-111111111111	Biryani (Non-Veg)	\N	0	t	2026-09-03 13:45:53.302347+05:30	2026-09-03 13:45:53.302347+05:30	\N
638dcd56-a022-462a-aacc-125069c4a2ad	11111111-1111-1111-1111-111111111111	Meal Box (Online)	\N	0	t	2026-09-03 13:45:53.304648+05:30	2026-09-03 13:45:53.304648+05:30	Combo meal boxes for delivery
989d20e0-a373-49e5-8bba-2863a1c22d60	11111111-1111-1111-1111-111111111111	panipuri	\N	0	t	2026-09-08 11:24:45.221+05:30	2026-09-08 11:24:45.221+05:30	\N
\.


--
-- Data for Name: menu_item_availability; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.menu_item_availability (id, outlet_id, menu_item_id, is_out_of_stock, oos_reason, oos_since, auto_resume_at, updated_at, updated_by) FROM stdin;
\.


--
-- Data for Name: menu_item_channel_status; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.menu_item_channel_status (id, outlet_id, menu_item_id, channel, is_enabled, updated_at, updated_by) FROM stdin;
\.


--
-- Data for Name: menu_items; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.menu_items (id, outlet_id, category_id, name, description, is_veg, hsn_code, is_active, created_at, updated_at, created_by, updated_by, online_display_name, tax_rate, price, stock_qty, station_id) FROM stdin;
1048c560-86bd-45c5-b872-eb5e802c6e46	67315042-c687-4cbb-b45a-f4ea4efc199f	8fcde4bd-6deb-4827-b69b-f748741f5aea	Hotel Kapila Special Chicken Biryani (Boneless)	Nizamabad signature boneless fried chicken masala over dum basmati rice.	f	\N	t	2026-09-02 16:21:33.908+05:30	2026-09-02 16:21:33.908+05:30	\N	\N	\N	5.00	34000	100	\N
c4945f10-ab36-4a6a-8388-0a0c4904d9da	67315042-c687-4cbb-b45a-f4ea4efc199f	60d4a197-f11c-4267-a7de-92220a27dc4b	Hyderabadi Paneer Dum Biryani	Fragrant saffron basmati rice layered with spiced paneer cubes and herbs.	t	\N	t	2026-09-02 16:21:33.93+05:30	2026-09-02 16:21:33.93+05:30	\N	\N	\N	5.00	28000	100	\N
7455214f-4d3e-495e-a9eb-9a13cda64003	67315042-c687-4cbb-b45a-f4ea4efc199f	12251ad8-147d-463e-a33a-30daa7aaabf7	Murgh Malai Tikka	Creamy cashew and cardamom marinated chicken morsels grilled in tandoor.	f	\N	t	2026-09-02 16:21:33.938+05:30	2026-09-02 16:21:33.938+05:30	\N	\N	\N	5.00	32000	100	\N
c1f09997-5bb1-4ee9-abb6-9b622c2c8e91	67315042-c687-4cbb-b45a-f4ea4efc199f	735379c7-6bd9-4ed0-be64-40d8bf1e7de8	Kapila Electric Blue Lagoon	Blue curacao, fresh lime, sprite and crushed ice.	t	\N	t	2026-09-02 16:21:33.944+05:30	2026-09-02 16:21:33.944+05:30	\N	\N	\N	5.00	16000	100	\N
99e5ec8f-c83a-4fa8-94d7-912ea45e2b74	2a543c3c-066f-4097-833a-df7c25700580	68413038-40bc-4f99-988e-7a72c60094e0	(2) Idly (1) Vada	\N	t	\N	t	2026-09-02 16:33:25.845+05:30	2026-09-02 16:33:25.845+05:30	\N	\N	\N	5.00	8500	100	\N
beef07d4-c730-41b8-bf0b-651379e91f92	2a543c3c-066f-4097-833a-df7c25700580	68413038-40bc-4f99-988e-7a72c60094e0	(S) Idly	\N	t	\N	t	2026-09-02 16:33:25.859+05:30	2026-09-02 16:33:25.859+05:30	\N	\N	\N	5.00	5000	100	\N
f9e508d5-3525-46d0-bff7-371f448c108c	2a543c3c-066f-4097-833a-df7c25700580	68413038-40bc-4f99-988e-7a72c60094e0	(S) Idly (S) Vada	\N	t	\N	t	2026-09-02 16:33:25.866+05:30	2026-09-02 16:33:25.866+05:30	\N	\N	\N	5.00	7000	100	\N
7699dcd7-bf39-4f90-9dfc-c9751ab561ba	2a543c3c-066f-4097-833a-df7c25700580	68413038-40bc-4f99-988e-7a72c60094e0	(S) Idly (S) Vada Sambar	\N	t	\N	t	2026-09-02 16:33:25.875+05:30	2026-09-02 16:33:25.875+05:30	\N	\N	\N	5.00	8000	100	\N
8613e431-dc51-4c61-9bab-bdf518502c06	2a543c3c-066f-4097-833a-df7c25700580	68413038-40bc-4f99-988e-7a72c60094e0	(S) Idly Sambar	\N	t	\N	t	2026-09-02 16:33:25.883+05:30	2026-09-02 16:33:25.883+05:30	\N	\N	\N	5.00	6000	100	\N
124c76f8-7ab2-48ab-9a2a-884ec6134578	2a543c3c-066f-4097-833a-df7c25700580	68413038-40bc-4f99-988e-7a72c60094e0	(S) Vada	\N	t	\N	t	2026-09-02 16:33:25.89+05:30	2026-09-02 16:33:25.89+05:30	\N	\N	\N	5.00	5500	100	\N
3d186c5c-8df7-4f8a-9233-3efa0c713df2	2a543c3c-066f-4097-833a-df7c25700580	68413038-40bc-4f99-988e-7a72c60094e0	(S) Vada Sambar	\N	t	\N	t	2026-09-02 16:33:25.9+05:30	2026-09-02 16:33:25.9+05:30	\N	\N	\N	5.00	6500	100	\N
dea644c5-2503-44fd-8da7-661d929ec929	2a543c3c-066f-4097-833a-df7c25700580	68413038-40bc-4f99-988e-7a72c60094e0	70 Mm Dosa	\N	t	\N	t	2026-09-02 16:33:25.908+05:30	2026-09-02 16:33:25.908+05:30	\N	\N	\N	5.00	11000	100	\N
499397a7-8028-49ab-9884-4cf4784a9094	2a543c3c-066f-4097-833a-df7c25700580	68413038-40bc-4f99-988e-7a72c60094e0	Breakfast Buffet	\N	t	\N	t	2026-09-02 16:33:25.916+05:30	2026-09-02 16:33:25.916+05:30	\N	\N	\N	5.00	25000	100	\N
6d626d6f-915f-43a7-887e-8c3d3c637355	2a543c3c-066f-4097-833a-df7c25700580	68413038-40bc-4f99-988e-7a72c60094e0	Breakfast Combo	\N	t	\N	t	2026-09-02 16:33:25.924+05:30	2026-09-02 16:33:25.924+05:30	\N	\N	\N	5.00	14000	100	\N
b345f6a0-75ab-48d4-a918-3f4b3652b27c	2a543c3c-066f-4097-833a-df7c25700580	68413038-40bc-4f99-988e-7a72c60094e0	Butter Masala Dosa	\N	t	\N	t	2026-09-02 16:33:25.931+05:30	2026-09-02 16:33:25.931+05:30	\N	\N	\N	5.00	9500	100	\N
d79e8ac8-4c76-4b15-bb79-fc71e716af9f	2a543c3c-066f-4097-833a-df7c25700580	68413038-40bc-4f99-988e-7a72c60094e0	Chitti Pesarattu	\N	t	\N	t	2026-09-02 16:33:25.939+05:30	2026-09-02 16:33:25.939+05:30	\N	\N	\N	5.00	8500	100	\N
ffa8145b-957b-4f83-9c66-ec0b84674310	2a543c3c-066f-4097-833a-df7c25700580	68413038-40bc-4f99-988e-7a72c60094e0	Extra Aloo	\N	t	\N	t	2026-09-02 16:33:25.946+05:30	2026-09-02 16:33:25.946+05:30	\N	\N	\N	5.00	2500	100	\N
608501cf-0f05-41a6-86a1-0df6d54f146e	2a543c3c-066f-4097-833a-df7c25700580	68413038-40bc-4f99-988e-7a72c60094e0	Extra Poori	\N	t	\N	t	2026-09-02 16:33:25.955+05:30	2026-09-02 16:33:25.955+05:30	\N	\N	\N	5.00	3000	100	\N
88c549e3-63bb-4a66-88fa-743997855717	2a543c3c-066f-4097-833a-df7c25700580	68413038-40bc-4f99-988e-7a72c60094e0	Ghee Karam Idly	\N	t	\N	t	2026-09-02 16:33:25.962+05:30	2026-09-02 16:33:25.962+05:30	\N	\N	\N	5.00	9000	100	\N
48f122f5-022a-4b4e-a4ae-c9ff954f41c8	2a543c3c-066f-4097-833a-df7c25700580	68413038-40bc-4f99-988e-7a72c60094e0	Ghee Karvepaaku Podi Dosa	\N	t	\N	t	2026-09-02 16:33:25.969+05:30	2026-09-02 16:33:25.969+05:30	\N	\N	\N	5.00	10500	100	\N
298d92b7-7b6d-43f5-9532-3d0da9c83604	2a543c3c-066f-4097-833a-df7c25700580	68413038-40bc-4f99-988e-7a72c60094e0	Ghee Podi Dosa	\N	t	\N	t	2026-09-02 16:33:25.977+05:30	2026-09-02 16:33:25.977+05:30	\N	\N	\N	5.00	10000	100	\N
057eb69f-2f78-41db-8d57-7ea11dce3fc9	2a543c3c-066f-4097-833a-df7c25700580	68413038-40bc-4f99-988e-7a72c60094e0	Ghee Podi Rava Dosa	\N	t	\N	t	2026-09-02 16:33:25.985+05:30	2026-09-02 16:33:25.985+05:30	\N	\N	\N	5.00	11500	100	\N
4ad7b7d4-9d9a-4d41-b60d-a473aa6fb2e2	2a543c3c-066f-4097-833a-df7c25700580	68413038-40bc-4f99-988e-7a72c60094e0	Idly (2)	\N	t	\N	t	2026-09-02 16:33:25.992+05:30	2026-09-02 16:33:25.992+05:30	\N	\N	\N	5.00	5500	100	\N
5f37b0e5-9c5f-4359-bae7-728cb6b9cd34	2a543c3c-066f-4097-833a-df7c25700580	68413038-40bc-4f99-988e-7a72c60094e0	Idly Sambar	\N	t	\N	t	2026-09-02 16:33:26+05:30	2026-09-02 16:33:26+05:30	\N	\N	\N	5.00	6500	100	\N
6716a235-8942-48aa-bb11-b43092d4d2f5	2a543c3c-066f-4097-833a-df7c25700580	68413038-40bc-4f99-988e-7a72c60094e0	Kids Buffet	\N	t	\N	t	2026-09-02 16:33:26.008+05:30	2026-09-02 16:33:26.008+05:30	\N	\N	\N	5.00	15000	100	\N
84948cf5-ebb2-447b-9b5f-2a6bf5c563aa	2a543c3c-066f-4097-833a-df7c25700580	bd5fd925-8442-4a2c-b952-de8a4e0181ee	Executive South Thali Box	\N	t	\N	t	2026-09-02 16:33:26.019+05:30	2026-09-02 16:33:26.019+05:30	\N	\N	\N	5.00	22000	100	\N
b38345b1-ee47-4809-988b-f660f8885eae	2a543c3c-066f-4097-833a-df7c25700580	bd5fd925-8442-4a2c-b952-de8a4e0181ee	Special Dosa Combo Box	\N	t	\N	t	2026-09-02 16:33:26.027+05:30	2026-09-02 16:33:26.027+05:30	\N	\N	\N	5.00	18000	100	\N
b9e284ff-8969-494d-a659-fbb5a9354664	2a543c3c-066f-4097-833a-df7c25700580	da1e0528-b69e-4eaf-b3cc-62429b61e75e	Filter Coffee	\N	t	\N	t	2026-09-02 16:33:26.035+05:30	2026-09-02 16:33:26.035+05:30	\N	\N	\N	5.00	3500	100	\N
d8b50247-153e-4208-9839-6bd10bbca253	2a543c3c-066f-4097-833a-df7c25700580	da1e0528-b69e-4eaf-b3cc-62429b61e75e	Special Masala Tea	\N	t	\N	t	2026-09-02 16:33:26.042+05:30	2026-09-02 16:33:26.042+05:30	\N	\N	\N	5.00	3000	100	\N
cdc12a71-3f32-4630-ab8b-059ae196af2c	67315042-c687-4cbb-b45a-f4ea4efc199f	8fcde4bd-6deb-4827-b69b-f748741f5aea	Butter Chicken	\N	f	\N	t	2026-09-02 17:56:41.935+05:30	2026-09-02 17:56:41.935+05:30	\N	\N	\N	5.00	32000	100	\N
8772f56e-a632-4998-ae87-45084349bf9f	67315042-c687-4cbb-b45a-f4ea4efc199f	6b47802d-d31d-4d52-9c5e-001f4674f85e	(2) Idly (1) Vada	\N	t	\N	t	2026-09-03 13:45:53.312837+05:30	2026-09-03 13:45:53.312837+05:30	\N	\N	\N	5.00	8500	100	\N
47dce856-d45e-41a3-a7de-84a823aa6d5a	67315042-c687-4cbb-b45a-f4ea4efc199f	6b47802d-d31d-4d52-9c5e-001f4674f85e	(S) Idly	\N	t	\N	t	2026-09-03 13:45:53.315365+05:30	2026-09-03 13:45:53.315365+05:30	\N	\N	\N	5.00	5000	100	\N
81f170e9-ad77-44a9-b8dc-7a7d4a2b84cc	67315042-c687-4cbb-b45a-f4ea4efc199f	6b47802d-d31d-4d52-9c5e-001f4674f85e	(S) Idly (S) Vada	\N	t	\N	t	2026-09-03 13:45:53.31721+05:30	2026-09-03 13:45:53.31721+05:30	\N	\N	\N	5.00	7000	100	\N
c97c9587-1c8d-4421-abc4-65e15db4bc81	67315042-c687-4cbb-b45a-f4ea4efc199f	6b47802d-d31d-4d52-9c5e-001f4674f85e	(S) Idly (S) Vada Sambar	\N	t	\N	t	2026-09-03 13:45:53.319734+05:30	2026-09-03 13:45:53.319734+05:30	\N	\N	\N	5.00	8000	100	\N
9e6b5249-048d-4aeb-a0b6-acfd8f6a8501	67315042-c687-4cbb-b45a-f4ea4efc199f	6b47802d-d31d-4d52-9c5e-001f4674f85e	(S) Idly Sambar	\N	t	\N	t	2026-09-03 13:45:53.321876+05:30	2026-09-03 13:45:53.321876+05:30	\N	\N	\N	5.00	6000	100	\N
6e275671-eb4e-43e2-8562-65053ed3b8e6	67315042-c687-4cbb-b45a-f4ea4efc199f	6b47802d-d31d-4d52-9c5e-001f4674f85e	(S) Vada	\N	t	\N	t	2026-09-03 13:45:53.323781+05:30	2026-09-03 13:45:53.323781+05:30	\N	\N	\N	5.00	5500	100	\N
c8fcdcb4-5630-46dd-aecf-f1d910a52ff8	67315042-c687-4cbb-b45a-f4ea4efc199f	6b47802d-d31d-4d52-9c5e-001f4674f85e	(S) Vada Sambar	\N	t	\N	t	2026-09-03 13:45:53.325233+05:30	2026-09-03 13:45:53.325233+05:30	\N	\N	\N	5.00	6500	100	\N
7f133d9e-7d22-4f2e-ad79-1fd89f07a1f5	67315042-c687-4cbb-b45a-f4ea4efc199f	6b47802d-d31d-4d52-9c5e-001f4674f85e	70 Mm Dosa	\N	t	\N	t	2026-09-03 13:45:53.326691+05:30	2026-09-03 13:45:53.326691+05:30	\N	\N	\N	5.00	11000	100	\N
32867c6e-e19a-4228-a96d-af1b439beb9b	67315042-c687-4cbb-b45a-f4ea4efc199f	6b47802d-d31d-4d52-9c5e-001f4674f85e	Breakfast Buffet	\N	t	\N	t	2026-09-03 13:45:53.328109+05:30	2026-09-03 13:45:53.328109+05:30	\N	\N	\N	5.00	25000	100	\N
ce830a66-2777-49d8-b62e-6fb860b9ac05	67315042-c687-4cbb-b45a-f4ea4efc199f	6b47802d-d31d-4d52-9c5e-001f4674f85e	Breakfast Combo	\N	t	\N	t	2026-09-03 13:45:53.32954+05:30	2026-09-03 13:45:53.32954+05:30	\N	\N	\N	5.00	14000	100	\N
4d74432b-7997-4b05-96c7-cb331127b3ca	67315042-c687-4cbb-b45a-f4ea4efc199f	6b47802d-d31d-4d52-9c5e-001f4674f85e	Butter Masala Dosa	\N	t	\N	t	2026-09-03 13:45:53.332819+05:30	2026-09-03 13:45:53.332819+05:30	\N	\N	\N	5.00	9500	100	\N
b16d099e-1e0c-4bbf-8c9b-8e6a8414f4ae	67315042-c687-4cbb-b45a-f4ea4efc199f	6b47802d-d31d-4d52-9c5e-001f4674f85e	Chitti Pesarattu	\N	t	\N	t	2026-09-03 13:45:53.3343+05:30	2026-09-03 13:45:53.3343+05:30	\N	\N	\N	5.00	8500	100	\N
9b35f954-5201-48ea-9e2a-174dbb083352	67315042-c687-4cbb-b45a-f4ea4efc199f	1541649d-c982-46a7-a228-ad78aba10f6c	Executive South Thali Box	\N	t	\N	t	2026-09-03 13:45:53.336148+05:30	2026-09-03 13:45:53.336148+05:30	\N	\N	\N	5.00	22000	100	\N
7cdd0470-02f3-4aef-a744-d1742a7a8825	67315042-c687-4cbb-b45a-f4ea4efc199f	6b47802d-d31d-4d52-9c5e-001f4674f85e	Extra Aloo	\N	t	\N	t	2026-09-03 13:45:53.338508+05:30	2026-09-03 13:45:53.338508+05:30	\N	\N	\N	5.00	2500	100	\N
3e079d26-b636-48bc-ad6f-68e117c7826d	67315042-c687-4cbb-b45a-f4ea4efc199f	6b47802d-d31d-4d52-9c5e-001f4674f85e	Extra Poori	\N	t	\N	t	2026-09-03 13:45:53.340275+05:30	2026-09-03 13:45:53.340275+05:30	\N	\N	\N	5.00	3000	100	\N
b66072c9-672f-4a07-ae41-bd506f60d505	67315042-c687-4cbb-b45a-f4ea4efc199f	de6e8b83-db5a-4c10-b432-6b5a66959cc4	Filter Coffee	\N	t	\N	t	2026-09-03 13:45:53.341888+05:30	2026-09-03 13:45:53.341888+05:30	\N	\N	\N	5.00	3500	100	\N
25dc14b6-0f77-44e7-9db7-2c6e5fd00ebb	67315042-c687-4cbb-b45a-f4ea4efc199f	6b47802d-d31d-4d52-9c5e-001f4674f85e	Ghee Karam Idly	\N	t	\N	t	2026-09-03 13:45:53.343462+05:30	2026-09-03 13:45:53.343462+05:30	\N	\N	\N	5.00	9000	100	\N
d4062c49-deb2-4a8b-a14f-7f594e1d61b0	67315042-c687-4cbb-b45a-f4ea4efc199f	6b47802d-d31d-4d52-9c5e-001f4674f85e	Ghee Karvepaaku Podi Dosa	\N	t	\N	t	2026-09-03 13:45:53.345401+05:30	2026-09-03 13:45:53.345401+05:30	\N	\N	\N	5.00	10500	100	\N
972a52a2-10f6-42ec-bd50-45cee9cd3c14	67315042-c687-4cbb-b45a-f4ea4efc199f	6b47802d-d31d-4d52-9c5e-001f4674f85e	Ghee Podi Dosa	\N	t	\N	t	2026-09-03 13:45:53.347625+05:30	2026-09-03 13:45:53.347625+05:30	\N	\N	\N	5.00	10000	100	\N
6147b9f5-53bb-4989-9f55-c0cce14398c0	67315042-c687-4cbb-b45a-f4ea4efc199f	6b47802d-d31d-4d52-9c5e-001f4674f85e	Ghee Podi Rava Dosa	\N	t	\N	t	2026-09-03 13:45:53.349243+05:30	2026-09-03 13:45:53.349243+05:30	\N	\N	\N	5.00	11500	100	\N
95d022d5-47ec-4b38-9565-daabe33866a1	67315042-c687-4cbb-b45a-f4ea4efc199f	6b47802d-d31d-4d52-9c5e-001f4674f85e	Idly (2)	\N	t	\N	t	2026-09-03 13:45:53.351877+05:30	2026-09-03 13:45:53.351877+05:30	\N	\N	\N	5.00	5500	100	\N
14abe1aa-b258-4201-a995-8eed18df3bcc	67315042-c687-4cbb-b45a-f4ea4efc199f	6b47802d-d31d-4d52-9c5e-001f4674f85e	Idly Sambar	\N	t	\N	t	2026-09-03 13:45:53.353295+05:30	2026-09-03 13:45:53.353295+05:30	\N	\N	\N	5.00	6500	100	\N
5d8449d6-24c6-43dd-b73e-4a1fb8860644	67315042-c687-4cbb-b45a-f4ea4efc199f	6b47802d-d31d-4d52-9c5e-001f4674f85e	Kids Buffet	\N	t	\N	t	2026-09-03 13:45:53.355329+05:30	2026-09-03 13:45:53.355329+05:30	\N	\N	\N	5.00	15000	100	\N
cb01246c-8e64-409b-bbb8-d63139e6ac6b	67315042-c687-4cbb-b45a-f4ea4efc199f	1541649d-c982-46a7-a228-ad78aba10f6c	Special Dosa Combo Box	\N	t	\N	t	2026-09-03 13:45:53.357373+05:30	2026-09-03 13:45:53.357373+05:30	\N	\N	\N	5.00	18000	100	\N
eba83b97-1716-4073-bd57-2eef05c144c5	67315042-c687-4cbb-b45a-f4ea4efc199f	de6e8b83-db5a-4c10-b432-6b5a66959cc4	Special Masala Tea	\N	t	\N	t	2026-09-03 13:45:53.361665+05:30	2026-09-03 13:45:53.361665+05:30	\N	\N	\N	5.00	3000	100	\N
09b87cbe-453a-418f-88dc-841b6c78b4a8	2a543c3c-066f-4097-833a-df7c25700580	7e99f115-5a4e-404a-880d-118faff89110	Butter Chicken	\N	f	\N	t	2026-09-03 13:45:53.371421+05:30	2026-09-03 13:45:53.371421+05:30	\N	\N	\N	5.00	32000	100	\N
072c26c3-7552-494a-9eb4-bcc5dd7d2a22	2a543c3c-066f-4097-833a-df7c25700580	7e99f115-5a4e-404a-880d-118faff89110	Hotel Kapila Special Chicken Biryani (Boneless)	Nizamabad signature boneless fried chicken masala over dum basmati rice.	f	\N	t	2026-09-03 13:45:53.381065+05:30	2026-09-03 13:45:53.381065+05:30	\N	\N	\N	5.00	34000	100	\N
b61b7134-ec44-409a-924b-b01ecd973144	2a543c3c-066f-4097-833a-df7c25700580	e10d567d-babb-4e94-a79a-eb3a48de4812	Hyderabadi Paneer Dum Biryani	Fragrant saffron basmati rice layered with spiced paneer cubes and herbs.	t	\N	t	2026-09-03 13:45:53.382677+05:30	2026-09-03 13:45:53.382677+05:30	\N	\N	\N	5.00	28000	100	\N
00d0d8e1-c2a5-4deb-a0a5-da1a1ca24683	2a543c3c-066f-4097-833a-df7c25700580	a976ef06-5bbd-4e1a-ba06-59ac9b0a6b84	Kapila Electric Blue Lagoon	Blue curacao, fresh lime, sprite and crushed ice.	t	\N	t	2026-09-03 13:45:53.385119+05:30	2026-09-03 13:45:53.385119+05:30	\N	\N	\N	5.00	16000	100	\N
1408068a-d60c-421b-8da4-76bf4c399c84	2a543c3c-066f-4097-833a-df7c25700580	e4b000a5-48de-44ba-bf02-3929b1f75c89	Murgh Malai Tikka	Creamy cashew and cardamom marinated chicken morsels grilled in tandoor.	f	\N	t	2026-09-03 13:45:53.386898+05:30	2026-09-03 13:45:53.386898+05:30	\N	\N	\N	5.00	32000	100	\N
71451535-8d85-417f-b0ec-3f2b87016045	11111111-1111-1111-1111-111111111111	a65ebbc1-bfb6-42ce-95cf-112d5a76e825	(S) Idly (S) Vada Sambar	\N	t	\N	t	2026-09-03 13:45:53.394798+05:30	2026-09-03 13:45:53.394798+05:30	\N	\N	\N	5.00	8000	100	\N
0020780f-7112-4804-a81b-2e06a91cdaa4	11111111-1111-1111-1111-111111111111	a65ebbc1-bfb6-42ce-95cf-112d5a76e825	(S) Vada	\N	t	\N	t	2026-09-03 13:45:53.397451+05:30	2026-09-03 13:45:53.397451+05:30	\N	\N	\N	5.00	5500	100	\N
7e1e6434-2ee4-428b-aafc-05be27e770d9	11111111-1111-1111-1111-111111111111	a65ebbc1-bfb6-42ce-95cf-112d5a76e825	(S) Vada Sambar	\N	t	\N	t	2026-09-03 13:45:53.399679+05:30	2026-09-03 13:45:53.399679+05:30	\N	\N	\N	5.00	6500	100	\N
9e27f8db-5ca3-4d7f-97d4-aa3d87642452	11111111-1111-1111-1111-111111111111	a65ebbc1-bfb6-42ce-95cf-112d5a76e825	70 Mm Dosa	\N	t	\N	t	2026-09-03 13:45:53.401337+05:30	2026-09-03 13:45:53.401337+05:30	\N	\N	\N	5.00	11000	100	\N
e0ffcd03-52ae-497b-9e57-1411888fde4f	11111111-1111-1111-1111-111111111111	a65ebbc1-bfb6-42ce-95cf-112d5a76e825	Breakfast Buffet	\N	t	\N	t	2026-09-03 13:45:53.402827+05:30	2026-09-03 13:45:53.402827+05:30	\N	\N	\N	5.00	25000	100	\N
e286dcdc-8100-430d-967e-6edba83f1609	11111111-1111-1111-1111-111111111111	a65ebbc1-bfb6-42ce-95cf-112d5a76e825	Breakfast Combo	\N	t	\N	t	2026-09-03 13:45:53.40406+05:30	2026-09-03 13:45:53.40406+05:30	\N	\N	\N	5.00	14000	100	\N
b45529e4-72e8-4c01-aed9-3106f2da6aeb	11111111-1111-1111-1111-111111111111	26fd5701-0ca8-4a3d-8a30-706cca828e47	Butter Chicken	\N	f	\N	t	2026-09-03 13:45:53.405375+05:30	2026-09-03 13:45:53.405375+05:30	\N	\N	\N	5.00	32000	100	\N
5d13a97e-027a-445b-94eb-2f00546b1614	11111111-1111-1111-1111-111111111111	a65ebbc1-bfb6-42ce-95cf-112d5a76e825	Butter Masala Dosa	\N	t	\N	t	2026-09-03 13:45:53.406605+05:30	2026-09-03 13:45:53.406605+05:30	\N	\N	\N	5.00	9500	100	\N
640584ad-7f9e-4a1b-8740-290fd382ea81	11111111-1111-1111-1111-111111111111	a65ebbc1-bfb6-42ce-95cf-112d5a76e825	Chitti Pesarattu	\N	t	\N	t	2026-09-03 13:45:53.407769+05:30	2026-09-03 13:45:53.407769+05:30	\N	\N	\N	5.00	8500	100	\N
df736215-5b84-49ce-bbfc-3d644d9a5401	11111111-1111-1111-1111-111111111111	638dcd56-a022-462a-aacc-125069c4a2ad	Executive South Thali Box	\N	t	\N	t	2026-09-03 13:45:53.409003+05:30	2026-09-03 13:45:53.409003+05:30	\N	\N	\N	5.00	22000	100	\N
fd632cf0-e4df-4fb7-b0ec-f6e64f852405	11111111-1111-1111-1111-111111111111	a65ebbc1-bfb6-42ce-95cf-112d5a76e825	Extra Aloo	\N	t	\N	t	2026-09-03 13:45:53.410656+05:30	2026-09-03 13:45:53.410656+05:30	\N	\N	\N	5.00	2500	100	\N
2c28152b-2d3a-4796-ac1f-aa04d783f921	11111111-1111-1111-1111-111111111111	a65ebbc1-bfb6-42ce-95cf-112d5a76e825	Extra Poori	\N	t	\N	t	2026-09-03 13:45:53.411957+05:30	2026-09-03 13:45:53.411957+05:30	\N	\N	\N	5.00	3000	100	\N
0f4bef83-2c0d-4c19-9d07-ce7f564fc589	11111111-1111-1111-1111-111111111111	a65ebbc1-bfb6-42ce-95cf-112d5a76e825	Ghee Karam Idly	\N	t	\N	t	2026-09-03 13:45:53.414362+05:30	2026-09-03 13:45:53.414362+05:30	\N	\N	\N	5.00	9000	100	\N
431e1ef5-1ef0-4ee9-acb8-4f406246c92a	11111111-1111-1111-1111-111111111111	a65ebbc1-bfb6-42ce-95cf-112d5a76e825	Ghee Karvepaaku Podi Dosa	\N	t	\N	t	2026-09-03 13:45:53.415566+05:30	2026-09-03 13:45:53.415566+05:30	\N	\N	\N	5.00	10500	100	\N
b9be06d0-6f21-4d05-8914-74e41818650e	11111111-1111-1111-1111-111111111111	a65ebbc1-bfb6-42ce-95cf-112d5a76e825	Ghee Podi Dosa	\N	t	\N	t	2026-09-03 13:45:53.41675+05:30	2026-09-03 13:45:53.41675+05:30	\N	\N	\N	5.00	10000	100	\N
d96136d0-d5ba-4152-814c-3aea49b3079e	11111111-1111-1111-1111-111111111111	a65ebbc1-bfb6-42ce-95cf-112d5a76e825	Ghee Podi Rava Dosa	\N	t	\N	t	2026-09-03 13:45:53.418931+05:30	2026-09-03 13:45:53.418931+05:30	\N	\N	\N	5.00	11500	100	\N
094b3d75-f087-476a-863b-a70da76e2365	11111111-1111-1111-1111-111111111111	26fd5701-0ca8-4a3d-8a30-706cca828e47	Hotel Kapila Special Chicken Biryani (Boneless)	Nizamabad signature boneless fried chicken masala over dum basmati rice.	f	\N	t	2026-09-03 13:45:53.420983+05:30	2026-09-03 13:45:53.420983+05:30	\N	\N	\N	5.00	34000	100	\N
f2961923-6d3d-453d-b80e-6820041126a5	11111111-1111-1111-1111-111111111111	e18291bb-1c6d-426d-a753-c58922a38598	Hyderabadi Paneer Dum Biryani	Fragrant saffron basmati rice layered with spiced paneer cubes and herbs.	t	\N	t	2026-09-03 13:45:53.422823+05:30	2026-09-03 13:45:53.422823+05:30	\N	\N	\N	5.00	28000	100	\N
4c59714c-7d6c-4d24-87c9-b4bb91f3c923	11111111-1111-1111-1111-111111111111	a65ebbc1-bfb6-42ce-95cf-112d5a76e825	Idly (2)	\N	t	\N	t	2026-09-03 13:45:53.424377+05:30	2026-09-03 13:45:53.424377+05:30	\N	\N	\N	5.00	5500	100	\N
29b7f4be-ba96-4de7-a268-6248985e12b1	11111111-1111-1111-1111-111111111111	a65ebbc1-bfb6-42ce-95cf-112d5a76e825	Idly Sambar	\N	t	\N	t	2026-09-03 13:45:53.426157+05:30	2026-09-03 13:45:53.426157+05:30	\N	\N	\N	5.00	6500	100	\N
305951b9-bbbd-4bcd-a93a-01aa60742934	11111111-1111-1111-1111-111111111111	226608d8-4b01-406d-a0bc-3da3381efd44	Kapila Electric Blue Lagoon	Blue curacao, fresh lime, sprite and crushed ice.	t	\N	t	2026-09-03 13:45:53.428699+05:30	2026-09-03 13:45:53.428699+05:30	\N	\N	\N	5.00	16000	100	\N
a7cf73dc-f5df-497b-a326-5fe2e49af224	11111111-1111-1111-1111-111111111111	a65ebbc1-bfb6-42ce-95cf-112d5a76e825	Kids Buffet	\N	t	\N	t	2026-09-03 13:45:53.430773+05:30	2026-09-03 13:45:53.430773+05:30	\N	\N	\N	5.00	15000	100	\N
2ddb7944-4e83-4dda-99de-94dd5e83bb77	11111111-1111-1111-1111-111111111111	00e25236-2c50-4e2b-818d-88c104db92bb	Murgh Malai Tikka	Creamy cashew and cardamom marinated chicken morsels grilled in tandoor.	f	\N	t	2026-09-03 13:45:53.432611+05:30	2026-09-03 13:45:53.432611+05:30	\N	\N	\N	5.00	32000	100	\N
4dd53b01-9b00-47a6-9537-6ccab7fc12e8	11111111-1111-1111-1111-111111111111	638dcd56-a022-462a-aacc-125069c4a2ad	Special Dosa Combo Box	\N	t	\N	t	2026-09-03 13:45:53.434215+05:30	2026-09-03 13:45:53.434215+05:30	\N	\N	\N	5.00	18000	100	\N
88edfc29-cdb9-469b-afda-bbb322f0a168	11111111-1111-1111-1111-111111111111	764ab8d6-7220-4bfb-bb9f-23f7d804bc71	Special Masala Tea	\N	t	\N	t	2026-09-03 13:45:53.435762+05:30	2026-09-03 13:45:53.435762+05:30	\N	\N	\N	5.00	3000	100	\N
d4d5c11d-7ca8-4f1f-9784-45b39bd6ef7c	11111111-1111-1111-1111-111111111111	c332c03a-b4ff-4db0-b13f-b241c651abc8	panipuri	\N	t	\N	t	2026-09-08 11:25:20.57+05:30	2026-09-08 11:25:20.57+05:30	\N	\N	\N	5.00	8000	100	\N
8fe74946-54cc-4f68-ae82-5f775ef44b20	11111111-1111-1111-1111-111111111111	c332c03a-b4ff-4db0-b13f-b241c651abc8	veg-manchuria	\N	t	\N	t	2026-09-08 11:26:36.857+05:30	2026-09-08 11:27:30.985+05:30	\N	\N	\N	5.00	12000	100	\N
4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	11111111-1111-1111-1111-111111111111	a65ebbc1-bfb6-42ce-95cf-112d5a76e825	(S) Idly (S) Vada	\N	t	\N	t	2026-09-03 13:45:53.393528+05:30	2026-09-24 23:33:43.42+05:30	\N	\N	\N	5.00	7000	100	\N
49768e80-5cf1-47a9-be73-5f24de6fb26e	11111111-1111-1111-1111-111111111111	a65ebbc1-bfb6-42ce-95cf-112d5a76e825	(S) Idly	\N	t	\N	t	2026-09-03 13:45:53.391786+05:30	2026-10-02 16:59:07.875+05:30	\N	\N	\N	5.00	5000	100	\N
e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	11111111-1111-1111-1111-111111111111	a65ebbc1-bfb6-42ce-95cf-112d5a76e825	(2) Idly (1) Vada	\N	t	\N	f	2026-09-03 13:45:53.390049+05:30	2026-09-09 13:02:03.792+05:30	\N	\N	\N	5.00	8500	100	\N
5101522a-081e-4866-9f74-261854fe4404	11111111-1111-1111-1111-111111111111	a65ebbc1-bfb6-42ce-95cf-112d5a76e825	(S) Idly Sambar	\N	t	\N	t	2026-09-03 13:45:53.396041+05:30	2026-10-03 14:44:22.168+05:30	\N	\N	\N	5.00	6000	100	\N
88ec151b-ebde-4993-809f-79f7e29a4385	11111111-1111-1111-1111-111111111111	764ab8d6-7220-4bfb-bb9f-23f7d804bc71	Filter Coffee	\N	t	\N	t	2026-09-03 13:45:53.413165+05:30	2026-10-03 14:46:00.305+05:30	\N	\N	\N	5.00	3500	100	\N
\.


--
-- Data for Name: modifier_groups; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.modifier_groups (id, outlet_id, name, min_select, max_select, is_active, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: modifier_options; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.modifier_options (id, outlet_id, modifier_group_id, name, price, is_active, sort_order, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: modifiers; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.modifiers (id, outlet_id, group_id, name, price_delta_minor, is_active, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.notifications (id, outlet_id, user_id, type, title, message, entity_type, entity_id, is_read, created_at, updated_at) FROM stdin;
b3d1aef5-579a-4fb6-97bd-531737e3adb2	67315042-c687-4cbb-b45a-f4ea4efc199f	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	INVENTORY_ALERT	Low Stock Alert	Basmati Rice is below reorder level (10 kg remaining).	\N	\N	f	2026-09-03 12:29:17.471553+05:30	2026-09-03 12:29:17.471553+05:30
600eb731-32c7-46f3-af6a-d151383aba5a	67315042-c687-4cbb-b45a-f4ea4efc199f	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	ORDER_ALERT	Table A3 Billing Request	Table A3 has requested final physical invoice.	\N	\N	f	2026-09-03 12:29:17.474223+05:30	2026-09-03 12:29:17.474223+05:30
e6466008-1cff-4c68-b18a-ad9da045353a	67315042-c687-4cbb-b45a-f4ea4efc199f	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	AGGREGATOR_ALERT	New Swiggy Order	Order #SW-8821 received and confirmed.	\N	\N	f	2026-09-03 12:29:17.47587+05:30	2026-09-03 12:29:17.47587+05:30
54a6fb8c-6008-4cd4-a684-c8f24f2cc2f8	67315042-c687-4cbb-b45a-f4ea4efc199f	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	SYSTEM_ALERT	Shift Register Opened	Cashier shift opened on Terminal T-01.	\N	\N	f	2026-09-03 12:29:17.477473+05:30	2026-09-03 12:29:17.477473+05:30
86274bf0-8003-41b4-b468-ef5c4e4a6182	11111111-1111-1111-1111-111111111111	\N	ORDER	📅 Advance Order Booked	Order #c18247 (DELIVERY) scheduled for 03:12 PM.	ADVANCE_ORDER	c182470d-5000-40bc-86f8-b9093c4333e8	t	2026-09-09 14:27:33.605+05:30	2026-09-11 11:40:46.369+05:30
a057c311-39e4-4fc8-bbe7-8d8f3091a61a	11111111-1111-1111-1111-111111111111	\N	ORDER	📅 Advance Order Booked	Order #482d35 (DELIVERY) scheduled for 03:13 PM.	ADVANCE_ORDER	482d35cd-b7b6-4c65-a7f3-943897646bad	t	2026-09-09 14:28:57.938+05:30	2026-09-11 11:40:46.369+05:30
12019710-7efe-47a9-964c-2da57e0b6363	11111111-1111-1111-1111-111111111111	\N	ORDER	📅 Advance Order Booked	Order #25ab98 (DELIVERY) scheduled for 03:14 PM.	ADVANCE_ORDER	25ab98b4-6057-4986-a634-4dd7dc5f51bc	t	2026-09-09 14:29:43.291+05:30	2026-09-11 11:40:46.369+05:30
90d31835-599a-40d6-94f4-5471b29e260b	11111111-1111-1111-1111-111111111111	\N	ORDER	📅 Advance Order Booked	Order #655055 (DELIVERY) scheduled for 03:16 PM.	ADVANCE_ORDER	65505588-f509-44ef-a6c6-c488503dcbe3	t	2026-09-09 14:31:14.507+05:30	2026-09-11 11:40:46.369+05:30
5483f0ec-26dc-4d59-95f2-7c7efaf8a9ba	11111111-1111-1111-1111-111111111111	\N	ORDER	📅 Advance Order Booked	Order #b6abe3 (DELIVERY) scheduled for 03:16 PM.	ADVANCE_ORDER	b6abe3e6-d0e7-4dc7-a631-097181effc3a	t	2026-09-09 14:31:59.219+05:30	2026-09-11 11:40:46.369+05:30
73f7d795-d04d-4f1b-b1fa-550fda75d767	11111111-1111-1111-1111-111111111111	\N	ORDER	📅 Advance Order Booked	Order #d71091 (DELIVERY) scheduled for 03:17 PM.	ADVANCE_ORDER	d71091c4-71f0-4c75-bd38-c6b08ba4dd4a	t	2026-09-09 14:32:48.537+05:30	2026-09-11 11:40:46.369+05:30
7f4b5375-8fa5-45da-9e94-71b2f4e7f105	11111111-1111-1111-1111-111111111111	\N	ORDER	Birthday party	Birthday party	\N	\N	t	2026-09-09 14:33:06.435+05:30	2026-09-11 11:40:46.369+05:30
b95282bb-0eae-4a99-b1db-cec15b3428ee	11111111-1111-1111-1111-111111111111	\N	ORDER	📅 Advance Order Booked	Order #d1467f (DELIVERY) scheduled for 03:19 PM.	ADVANCE_ORDER	d1467f47-4869-4592-996e-0d3f373ec018	t	2026-09-09 14:34:00.999+05:30	2026-09-11 11:40:46.369+05:30
bca8ac0f-e06f-4690-a9fa-00c3b3d3c323	11111111-1111-1111-1111-111111111111	\N	ORDER	📅 Advance Order Booked	Order #fd749f (DELIVERY) scheduled for 12:18 AM.	ADVANCE_ORDER	fd749f2c-9fde-404e-892b-0b60a6f95860	f	2026-09-24 23:33:03.232+05:30	2026-09-24 23:33:03.232+05:30
\.


--
-- Data for Name: order_audit_log; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.order_audit_log (id, outlet_id, order_id, actor_id, approved_by, action, before_val, after_val, at) FROM stdin;
\.


--
-- Data for Name: order_item_modifiers; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.order_item_modifiers (id, outlet_id, order_item_id, modifier_id, modifier_name, price_delta_minor, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: order_item_seat_shares; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.order_item_seat_shares (id, outlet_id, order_item_id, seat_number, share_numerator, share_denominator, allocated_subtotal) FROM stdin;
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.order_items (id, outlet_id, order_id, item_id, variant_id, item_name, qty, unit_price_minor, total_price_minor, notes, created_at, updated_at, created_by, updated_by, seat_id, split_group_id, is_shared, origin_table_id, is_voided, seat_number, course, menu_item_id, quantity, unit_price, subtotal, void_reason, voided_by) FROM stdin;
99d5a47e-068f-4cc0-98c7-bf0ab01eb07f	11111111-1111-1111-1111-111111111111	db187890-3de7-4a5d-87b2-9398153c343a	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	\N	Item	1	7000	7000	\N	2026-09-23 13:22:19.29003+05:30	2026-09-23 13:22:19.29003+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	1	7000	7000	\N	\N
bd610f8f-27d5-4d8e-9119-5fb6a5592408	11111111-1111-1111-1111-111111111111	320ff853-a5fe-483c-83e1-ba5e70f75d36	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	\N	Item	1	7000	7000	\N	2026-09-24 09:03:25.422898+05:30	2026-09-24 09:03:25.422898+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	1	7000	7000	\N	\N
a20f3ecf-d99d-4919-9bb1-b70fc265be56	11111111-1111-1111-1111-111111111111	320ff853-a5fe-483c-83e1-ba5e70f75d36	71451535-8d85-417f-b0ec-3f2b87016045	\N	Item	1	8000	8000	\N	2026-09-24 09:03:25.422898+05:30	2026-09-24 09:03:25.422898+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	71451535-8d85-417f-b0ec-3f2b87016045	1	8000	8000	\N	\N
2d631ad3-a4fd-4ed2-a74c-58dade6b70da	11111111-1111-1111-1111-111111111111	900efa09-cbd9-4da9-8897-1b837e07b788	49768e80-5cf1-47a9-be73-5f24de6fb26e	\N	Item	1	5000	10000	\N	2026-09-24 23:32:05.480221+05:30	2026-09-24 23:32:05.480221+05:30	\N	\N	\N	\N	f	\N	f	1	STARTER	49768e80-5cf1-47a9-be73-5f24de6fb26e	2	5000	10000	\N	\N
1aa0dc86-fbc7-40f7-86e3-b40d18c85905	11111111-1111-1111-1111-111111111111	900efa09-cbd9-4da9-8897-1b837e07b788	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	\N	Item	1	7000	7000	\N	2026-09-24 23:32:05.480221+05:30	2026-09-24 23:32:05.480221+05:30	\N	\N	\N	\N	f	\N	f	2	MAIN	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	1	7000	7000	\N	\N
d72965dd-f095-4d00-bd19-5a0c011cdba5	11111111-1111-1111-1111-111111111111	6dcda227-21c2-4291-918f-a3813a9062eb	49768e80-5cf1-47a9-be73-5f24de6fb26e	\N	Item	1	5000	5000	\N	2026-10-02 16:33:19.787146+05:30	2026-10-02 16:33:19.787146+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	49768e80-5cf1-47a9-be73-5f24de6fb26e	1	5000	5000	\N	\N
3eafce2f-d57c-4570-a245-5ef7d50f502e	11111111-1111-1111-1111-111111111111	89dba099-01ad-417a-a438-66ca8af5e712	5101522a-081e-4866-9f74-261854fe4404	\N	Item	1	6000	6000	\N	2026-10-03 01:21:15.896974+05:30	2026-10-03 01:21:15.896974+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	5101522a-081e-4866-9f74-261854fe4404	1	6000	6000	\N	\N
88e411bf-b78b-4256-affa-96f95d4966b9	11111111-1111-1111-1111-111111111111	6bb8a0c7-38c6-4f87-95a7-8edd80cbcfb6	5101522a-081e-4866-9f74-261854fe4404	\N	Item	1	6000	6000	\N	2026-10-03 13:58:21.654179+05:30	2026-10-03 13:58:21.654179+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	5101522a-081e-4866-9f74-261854fe4404	1	6000	6000	\N	\N
b5f819e0-de5b-40eb-b9c2-79ad5d991c93	11111111-1111-1111-1111-111111111111	5736ba49-2b3d-47e0-b162-575f81bbd62c	88ec151b-ebde-4993-809f-79f7e29a4385	\N	Item	1	3500	3500	\N	2026-10-03 14:44:58.616004+05:30	2026-10-03 14:44:58.616004+05:30	\N	\N	\N	\N	f	\N	t	\N	STARTER	88ec151b-ebde-4993-809f-79f7e29a4385	1	3500	3500	noo	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
e33ec171-252d-4f6b-acac-694e76f4bf53	67315042-c687-4cbb-b45a-f4ea4efc199f	5b433b06-af43-4f62-8a6b-e2ca1e0bfa88	1048c560-86bd-45c5-b872-eb5e802c6e46	\N	Item	1	34000	34000	\N	2026-09-05 16:45:41.983161+05:30	2026-09-05 16:45:41.983161+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	1048c560-86bd-45c5-b872-eb5e802c6e46	1	34000	34000	\N	\N
92084d9f-089e-4c18-8537-8a75358fb278	67315042-c687-4cbb-b45a-f4ea4efc199f	c69c7c36-7b05-4ca7-9012-710df44ed6fd	c4945f10-ab36-4a6a-8388-0a0c4904d9da	\N	Hyderabadi Paneer Dum Biryani	1	2800000	2800000	\N	2026-09-03 12:29:17.515281+05:30	2026-09-03 12:29:17.515281+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	c4945f10-ab36-4a6a-8388-0a0c4904d9da	1	0	0	\N	\N
3ec3d585-9c38-4fc4-a329-931e0e9e0b66	11111111-1111-1111-1111-111111111111	b0845453-ec80-411d-8370-e62958475492	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	\N	Item	1	850000	850000	\N	2026-09-03 14:07:10.175393+05:30	2026-09-03 14:07:10.175393+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	1	8500	8500	\N	\N
31447489-e6af-4bc5-a132-783f2da200c0	11111111-1111-1111-1111-111111111111	0602cb47-3398-4ba0-b5da-87e23909efa3	49768e80-5cf1-47a9-be73-5f24de6fb26e	\N	Item	1	5000	450000	\N	2026-09-09 12:48:24.578971+05:30	2026-09-09 12:48:24.578971+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	49768e80-5cf1-47a9-be73-5f24de6fb26e	90	5000	450000	\N	\N
b755bfc3-dea9-4d8f-b6d1-a7decce5f8be	11111111-1111-1111-1111-111111111111	0602cb47-3398-4ba0-b5da-87e23909efa3	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	\N	Item	1	8500	42500	\N	2026-09-09 12:49:23.847265+05:30	2026-09-09 12:49:23.847265+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	5	8500	42500	\N	\N
55a4f07d-dfd9-4ffe-987a-090f9fef31ce	11111111-1111-1111-1111-111111111111	fd749f2c-9fde-404e-892b-0b60a6f95860	49768e80-5cf1-47a9-be73-5f24de6fb26e	\N	Item	1	5000	25000	\N	2026-09-24 23:33:03.081554+05:30	2026-09-24 23:33:03.081554+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	49768e80-5cf1-47a9-be73-5f24de6fb26e	5	5000	25000	\N	\N
2a19d477-00a7-497b-a165-d5c5fc90d646	11111111-1111-1111-1111-111111111111	300e3125-c13a-4c6f-9548-9d7ec596529f	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	\N	Item	1	7000	21000	\N	2026-09-24 23:33:41.052085+05:30	2026-09-24 23:33:41.052085+05:30	\N	\N	\N	\N	f	\N	t	\N	\N	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	3	7000	21000	TEST_VOID	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
510ebe7e-4bcf-48c7-83c2-aec32a9ca028	11111111-1111-1111-1111-111111111111	96b6a769-53e4-47b5-b329-af8e6a597f73	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	\N	Item	1	7000	105000	\N	2026-09-24 23:33:42.609841+05:30	2026-09-24 23:33:42.609841+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	15	7000	105000	\N	\N
37ec7b87-03f5-4518-8238-56991062e0be	11111111-1111-1111-1111-111111111111	1469b1ab-dc07-49fd-979d-6393518fd684	49768e80-5cf1-47a9-be73-5f24de6fb26e	\N	Item	1	5000	10000	\N	2026-10-02 16:57:54.313551+05:30	2026-10-02 16:57:54.313551+05:30	\N	\N	\N	\N	f	\N	f	\N	MAIN	49768e80-5cf1-47a9-be73-5f24de6fb26e	2	5000	10000	\N	\N
831ff6b1-f01c-4410-8bd2-8c4767b9a055	11111111-1111-1111-1111-111111111111	1469b1ab-dc07-49fd-979d-6393518fd684	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	\N	Item	1	7000	7000	\N	2026-10-02 16:57:54.313551+05:30	2026-10-02 16:57:54.313551+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	1	7000	7000	\N	\N
0ef5a61f-58a2-4197-ac6e-8b3ebfeb98c5	11111111-1111-1111-1111-111111111111	53494c1e-ee68-4197-b271-2a8c5f2bdb26	49768e80-5cf1-47a9-be73-5f24de6fb26e	\N	Item	1	5000	10000	\N	2026-10-02 16:59:07.467567+05:30	2026-10-02 16:59:07.467567+05:30	\N	\N	\N	\N	f	\N	f	\N	MAIN	49768e80-5cf1-47a9-be73-5f24de6fb26e	2	5000	10000	\N	\N
6502e008-a4f8-4fa6-bae9-c24766f5c36d	11111111-1111-1111-1111-111111111111	53494c1e-ee68-4197-b271-2a8c5f2bdb26	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	\N	Item	1	7000	7000	\N	2026-10-02 16:59:07.467567+05:30	2026-10-02 16:59:07.467567+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	1	7000	7000	\N	\N
b83c41d5-9e92-403a-b6c0-87a0a665b16b	11111111-1111-1111-1111-111111111111	7bf0131c-f022-46a1-9a7b-8569cd3682f8	e0ffcd03-52ae-497b-9e57-1411888fde4f	\N	Item	1	25000	25000	\N	2026-10-03 01:22:43.862119+05:30	2026-10-03 01:22:43.862119+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	e0ffcd03-52ae-497b-9e57-1411888fde4f	1	25000	25000	\N	\N
703d14d7-845f-43ad-b1e7-2fc8b0b49558	11111111-1111-1111-1111-111111111111	5736ba49-2b3d-47e0-b162-575f81bbd62c	5101522a-081e-4866-9f74-261854fe4404	\N	Item	1	6000	6000	\N	2026-10-03 14:00:38.249754+05:30	2026-10-03 14:00:38.249754+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	5101522a-081e-4866-9f74-261854fe4404	1	6000	6000	\N	\N
ecccb59e-9f4e-45ec-9e36-afa847b2671c	11111111-1111-1111-1111-111111111111	a48e021b-e5d6-4f57-af79-3995db8f417b	e0ffcd03-52ae-497b-9e57-1411888fde4f	\N	Item	1	25000	50000	\N	2026-10-03 15:10:55.200409+05:30	2026-10-03 15:10:55.200409+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	e0ffcd03-52ae-497b-9e57-1411888fde4f	2	25000	50000	\N	\N
5b263a5a-26f4-472f-845a-5fd69f73c080	11111111-1111-1111-1111-111111111111	f4fbbe17-c9da-40cc-a954-1b9d7d1d6752	49768e80-5cf1-47a9-be73-5f24de6fb26e	\N	Item	1	5000	10000	\N	2026-09-24 23:48:18.373631+05:30	2026-09-24 23:48:18.373631+05:30	\N	\N	\N	\N	f	\N	f	1	STARTER	49768e80-5cf1-47a9-be73-5f24de6fb26e	2	5000	10000	\N	\N
cbbe2f5a-f6a4-49f5-baad-6debdf4ff1bc	11111111-1111-1111-1111-111111111111	f4fbbe17-c9da-40cc-a954-1b9d7d1d6752	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	\N	Item	1	7000	7000	\N	2026-09-24 23:48:18.373631+05:30	2026-09-24 23:48:18.373631+05:30	\N	\N	\N	\N	f	\N	f	2	MAIN	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	1	7000	7000	\N	\N
6c6a69ea-8662-406f-876e-4f380cf146ca	11111111-1111-1111-1111-111111111111	af21c0cc-a9e8-459c-b797-ddb34bb7f724	5101522a-081e-4866-9f74-261854fe4404	\N	Item	1	6000	6000	\N	2026-10-03 01:24:04.746636+05:30	2026-10-03 01:24:04.746636+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	5101522a-081e-4866-9f74-261854fe4404	1	6000	6000	\N	\N
871c0130-7e2d-4e15-b263-b92acd7853b3	11111111-1111-1111-1111-111111111111	6040a630-394f-416c-9b97-8deef80f81f8	5101522a-081e-4866-9f74-261854fe4404	\N	Item	1	6000	6000	\N	2026-10-03 14:04:11.552536+05:30	2026-10-03 14:04:11.552536+05:30	\N	\N	\N	\N	f	\N	t	\N	\N	5101522a-081e-4866-9f74-261854fe4404	1	6000	6000	hh	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
1e52c5d3-8676-4aff-8aa4-2832b1212976	67315042-c687-4cbb-b45a-f4ea4efc199f	c69c7c36-7b05-4ca7-9012-710df44ed6fd	1048c560-86bd-45c5-b872-eb5e802c6e46	\N	Hotel Kapila Special Chicken Biryani (Boneless)	2	3400000	6800000	\N	2026-09-03 12:29:17.503763+05:30	2026-09-03 12:29:17.503763+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	1048c560-86bd-45c5-b872-eb5e802c6e46	1	0	0	\N	\N
4309f3ed-e176-42be-a96f-2a3a80c518eb	67315042-c687-4cbb-b45a-f4ea4efc199f	cff7a875-fec8-4189-bc71-ae49b0e19488	1048c560-86bd-45c5-b872-eb5e802c6e46	\N	Item	1	34000	34000	\N	2026-09-11 14:11:01.851309+05:30	2026-09-11 14:11:01.851309+05:30	\N	\N	\N	\N	f	\N	f	\N	MAIN	1048c560-86bd-45c5-b872-eb5e802c6e46	1	34000	34000	\N	\N
69d4ccbf-020e-45f7-bff8-efdee2f95fb2	67315042-c687-4cbb-b45a-f4ea4efc199f	0c7bc59e-d90f-4a42-873f-88c0e9a02386	1048c560-86bd-45c5-b872-eb5e802c6e46	\N	Item	1	34000	34000	\N	2026-09-11 14:12:08.652094+05:30	2026-09-11 14:12:08.652094+05:30	\N	\N	\N	\N	f	\N	f	\N	MAIN	1048c560-86bd-45c5-b872-eb5e802c6e46	1	34000	34000	\N	\N
a5ad1b27-1d4d-4a40-a7f8-1e08026ac3ba	67315042-c687-4cbb-b45a-f4ea4efc199f	f9b4ac11-21c8-4617-9a1d-f1d7e8147a37	1048c560-86bd-45c5-b872-eb5e802c6e46	\N	Item	1	34000	34000	\N	2026-09-11 14:16:07.294659+05:30	2026-09-11 14:16:07.294659+05:30	\N	\N	\N	\N	f	\N	f	\N	MAIN	1048c560-86bd-45c5-b872-eb5e802c6e46	1	34000	34000	\N	\N
32733e86-926a-421a-86cd-ee6fb9ffb7a0	67315042-c687-4cbb-b45a-f4ea4efc199f	829e83e6-ea56-4173-bfe2-463b24e497a4	1048c560-86bd-45c5-b872-eb5e802c6e46	\N	Item	1	34000	34000	\N	2026-09-11 14:19:07.406766+05:30	2026-09-11 14:19:07.406766+05:30	\N	\N	\N	\N	f	\N	f	\N	MAIN	1048c560-86bd-45c5-b872-eb5e802c6e46	1	34000	34000	\N	\N
1fb8d937-a0fc-44fd-81ca-6e2207dadb9c	11111111-1111-1111-1111-111111111111	51ee39c7-53f2-40c4-adae-b49600c041f7	49768e80-5cf1-47a9-be73-5f24de6fb26e	\N	Item	1	5000	10000	\N	2026-09-24 23:54:18.769609+05:30	2026-09-24 23:54:18.769609+05:30	\N	\N	\N	\N	f	\N	f	1	STARTER	49768e80-5cf1-47a9-be73-5f24de6fb26e	2	5000	10000	\N	\N
b3e785d1-2164-4e94-8dc8-c4adbe1c20a9	11111111-1111-1111-1111-111111111111	51ee39c7-53f2-40c4-adae-b49600c041f7	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	\N	Item	1	7000	7000	\N	2026-09-24 23:54:18.769609+05:30	2026-09-24 23:54:18.769609+05:30	\N	\N	\N	\N	f	\N	f	2	MAIN	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	1	7000	7000	\N	\N
915f99a5-926b-4adb-8682-577cc4f59ecd	11111111-1111-1111-1111-111111111111	b7899f9e-fd1e-4f77-89fc-0d935c2e2d85	71451535-8d85-417f-b0ec-3f2b87016045	\N	Item	1	8000	8000	\N	2026-10-03 01:24:33.488755+05:30	2026-10-03 01:24:33.488755+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	71451535-8d85-417f-b0ec-3f2b87016045	1	8000	8000	\N	\N
b65a31aa-57c9-4fb4-9e07-e8c65470e9a2	11111111-1111-1111-1111-111111111111	c81161e9-bd67-474a-bf80-3b1756fe5393	5101522a-081e-4866-9f74-261854fe4404	\N	Item	1	6000	6000	\N	2026-10-03 01:25:42.57747+05:30	2026-10-03 01:25:42.57747+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	5101522a-081e-4866-9f74-261854fe4404	1	6000	6000	\N	\N
27374d9e-4b6a-4d6c-876b-ae552ee440ce	11111111-1111-1111-1111-111111111111	de5f32b6-72f6-441d-a98f-3f273e2a3bba	5101522a-081e-4866-9f74-261854fe4404	\N	Item	1	6000	6000	\N	2026-10-03 01:27:32.402532+05:30	2026-10-03 01:27:32.402532+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	5101522a-081e-4866-9f74-261854fe4404	1	6000	6000	\N	\N
62a74f9e-22f5-4150-b319-bf95c6b64225	11111111-1111-1111-1111-111111111111	6bb8a0c7-38c6-4f87-95a7-8edd80cbcfb6	b45529e4-72e8-4c01-aed9-3106f2da6aeb	\N	Item	1	32000	32000	\N	2026-10-03 14:32:23.242295+05:30	2026-10-03 14:32:23.242295+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	b45529e4-72e8-4c01-aed9-3106f2da6aeb	1	32000	32000	\N	\N
a9808642-6b79-4671-8a6c-8cd23c09b26e	11111111-1111-1111-1111-111111111111	5338928a-7fb6-429f-a646-8f12166322fa	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	\N	Item	1	850000	850000	\N	2026-09-03 14:07:13.288985+05:30	2026-09-03 14:07:13.288985+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	1	8500	8500	\N	\N
e8af1bf5-d308-4abf-a808-26137ab677cd	11111111-1111-1111-1111-111111111111	17cb34b5-878f-4d13-b0ec-02af3307cbf2	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	\N	Item	1	850000	1700000	\N	2026-09-03 14:10:08.91939+05:30	2026-09-03 14:10:08.91939+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	2	8500	17000	\N	\N
721e66e5-a6c1-479a-8c61-4eb3ef4cb8b7	11111111-1111-1111-1111-111111111111	17cb34b5-878f-4d13-b0ec-02af3307cbf2	49768e80-5cf1-47a9-be73-5f24de6fb26e	\N	Item	1	500000	500000	\N	2026-09-03 14:10:08.91939+05:30	2026-09-03 14:10:08.91939+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	49768e80-5cf1-47a9-be73-5f24de6fb26e	1	5000	5000	\N	\N
13f81108-0d71-497a-8c59-fb2c9cff2f79	11111111-1111-1111-1111-111111111111	4a3e148b-1df0-46f8-a71a-c834486429e5	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	\N	Item	1	850000	1700000	\N	2026-09-03 14:19:54.415923+05:30	2026-09-03 14:19:54.415923+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	2	8500	17000	\N	\N
39232e63-b520-40d1-8382-802fb32cd741	11111111-1111-1111-1111-111111111111	e93358df-ec3b-4e3b-a241-8e93bd953411	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	\N	Item	1	850000	850000	\N	2026-09-03 14:21:16.165139+05:30	2026-09-03 14:21:16.165139+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	1	8500	8500	\N	\N
7a7080c6-7647-4996-a6cd-586f5613338b	11111111-1111-1111-1111-111111111111	71ef893c-0ccc-439d-bc3e-0a248037303b	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	\N	Item	1	850000	850000	\N	2026-09-03 14:25:51.848776+05:30	2026-09-03 14:25:51.848776+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	1	8500	8500	\N	\N
a9c5759c-98c5-4e33-a8dc-e558deae6d28	11111111-1111-1111-1111-111111111111	e7eccfdc-02d5-470f-869b-da665f7dcb2e	2ddb7944-4e83-4dda-99de-94dd5e83bb77	\N	Item	1	3200000	3200000	\N	2026-09-03 14:53:11.842258+05:30	2026-09-03 14:53:11.842258+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	2ddb7944-4e83-4dda-99de-94dd5e83bb77	1	32000	32000	\N	\N
83af21bb-0221-4d95-b9c3-7c3261a4dfac	11111111-1111-1111-1111-111111111111	5583e31e-48a5-435a-936e-aba2f8bb9c9c	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	\N	Item	1	8500	8500	\N	2026-09-03 15:17:20.184009+05:30	2026-09-03 15:17:20.184009+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	1	8500	8500	\N	\N
025735c2-f199-4819-a694-73b1b678ed09	11111111-1111-1111-1111-111111111111	e7eccfdc-02d5-470f-869b-da665f7dcb2e	49768e80-5cf1-47a9-be73-5f24de6fb26e	\N	Item	1	5000	5000	\N	2026-09-04 00:02:44.743219+05:30	2026-09-04 00:02:44.743219+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	49768e80-5cf1-47a9-be73-5f24de6fb26e	1	5000	5000	\N	\N
9c79b32c-196b-4a2d-bd1f-0c7aa4a96a5b	11111111-1111-1111-1111-111111111111	0f621958-d193-4d99-b6ef-037fcea9cd0a	49768e80-5cf1-47a9-be73-5f24de6fb26e	\N	Item	1	5000	5000	\N	2026-09-04 00:05:22.293052+05:30	2026-09-04 00:05:22.293052+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	49768e80-5cf1-47a9-be73-5f24de6fb26e	1	5000	5000	\N	\N
ffe3d2a6-2bcf-4f51-96b0-958fc529e51e	11111111-1111-1111-1111-111111111111	0f621958-d193-4d99-b6ef-037fcea9cd0a	9e27f8db-5ca3-4d7f-97d4-aa3d87642452	\N	Item	1	11000	11000	\N	2026-09-04 00:05:57.362581+05:30	2026-09-04 00:05:57.362581+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	9e27f8db-5ca3-4d7f-97d4-aa3d87642452	1	11000	11000	\N	\N
2ac5255a-707d-4147-904d-96a126ba13b3	11111111-1111-1111-1111-111111111111	a00d57c3-c01d-49d0-9166-45e9f7e22497	9e27f8db-5ca3-4d7f-97d4-aa3d87642452	\N	Item	1	11000	11000	\N	2026-09-04 00:40:55.685953+05:30	2026-09-04 00:40:55.685953+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	9e27f8db-5ca3-4d7f-97d4-aa3d87642452	1	11000	11000	\N	\N
8b8157f3-0319-41be-a36d-87ed1df95c5f	11111111-1111-1111-1111-111111111111	ece12171-62db-4f53-ba97-d5e93e06f733	71451535-8d85-417f-b0ec-3f2b87016045	\N	Item	1	8000	8000	\N	2026-09-04 01:04:33.31612+05:30	2026-09-04 01:04:33.31612+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	71451535-8d85-417f-b0ec-3f2b87016045	1	8000	8000	\N	\N
d01fed96-5b0c-4732-b314-b81a54946dce	11111111-1111-1111-1111-111111111111	ece12171-62db-4f53-ba97-d5e93e06f733	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	\N	Item	1	7000	7000	\N	2026-09-04 01:04:33.31612+05:30	2026-09-04 01:04:33.31612+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	1	7000	7000	\N	\N
9bc19328-1e90-4001-8205-a2f448775c76	11111111-1111-1111-1111-111111111111	b5177d27-2e27-4abd-8296-83a748730b2c	49768e80-5cf1-47a9-be73-5f24de6fb26e	\N	Item	1	5000	5000	\N	2026-09-04 01:19:56.479604+05:30	2026-09-04 01:19:56.479604+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	49768e80-5cf1-47a9-be73-5f24de6fb26e	1	5000	5000	\N	\N
f4a218ac-99e4-48cf-b6e1-60afc00828c5	11111111-1111-1111-1111-111111111111	b5177d27-2e27-4abd-8296-83a748730b2c	9e27f8db-5ca3-4d7f-97d4-aa3d87642452	\N	Item	1	11000	11000	\N	2026-09-04 01:19:56.479604+05:30	2026-09-04 01:19:56.479604+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	9e27f8db-5ca3-4d7f-97d4-aa3d87642452	1	11000	11000	\N	\N
a09767f3-e815-483d-aff9-8d334baff511	11111111-1111-1111-1111-111111111111	a00d57c3-c01d-49d0-9166-45e9f7e22497	094b3d75-f087-476a-863b-a70da76e2365	\N	Item	1	34000	34000	\N	2026-09-05 13:19:55.615319+05:30	2026-09-05 13:19:55.615319+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	094b3d75-f087-476a-863b-a70da76e2365	1	34000	34000	\N	\N
03d3bde6-a0d7-48d9-abef-c298fbbb36fb	11111111-1111-1111-1111-111111111111	e7d4d6cf-4838-43bd-8334-688d11302496	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	\N	Item	1	8500	8500	\N	2026-09-05 14:26:19.023081+05:30	2026-09-05 14:26:19.023081+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	1	8500	8500	\N	\N
60295abb-8a59-4a0f-97e8-b32182500594	11111111-1111-1111-1111-111111111111	0f3580d0-cceb-4289-99f8-5ffdf1669b18	49768e80-5cf1-47a9-be73-5f24de6fb26e	\N	Item	1	5000	5000	\N	2026-09-05 15:10:12.583023+05:30	2026-09-05 15:10:12.583023+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	49768e80-5cf1-47a9-be73-5f24de6fb26e	1	5000	5000	\N	\N
e757b52b-9567-44bd-a492-3bb3519b4cb5	11111111-1111-1111-1111-111111111111	c3a366cb-039e-4e26-9cbd-8e22cd2d52b9	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	\N	Item	1	8500	8500	\N	2026-09-05 16:22:38.176715+05:30	2026-09-05 16:22:38.176715+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	1	8500	8500	\N	\N
f497179e-87b0-4f64-8408-05071bc7a8ff	11111111-1111-1111-1111-111111111111	7a369854-faf1-4af3-8378-8b939249c434	7e1e6434-2ee4-428b-aafc-05be27e770d9	\N	Item	1	6500	6500	\N	2026-09-05 16:51:32.697449+05:30	2026-09-05 16:51:32.697449+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	7e1e6434-2ee4-428b-aafc-05be27e770d9	1	6500	6500	\N	\N
f0971839-9aef-47e4-9c3d-2cf44ce82eaf	11111111-1111-1111-1111-111111111111	82e2a068-a74a-4e18-89fe-7a423f5b243f	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	\N	Item	1	7000	7000	\N	2026-09-05 17:05:54.944586+05:30	2026-09-05 17:05:54.944586+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	1	7000	7000	\N	\N
de62921f-d4dc-4fea-a8f4-56fe8b04f116	11111111-1111-1111-1111-111111111111	1085cebe-ebf0-4804-83f3-aae6d0d4a7c9	88ec151b-ebde-4993-809f-79f7e29a4385	\N	Item	1	3500	3500	\N	2026-09-08 11:05:04.301438+05:30	2026-09-08 11:05:04.301438+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	88ec151b-ebde-4993-809f-79f7e29a4385	1	3500	3500	\N	\N
9c5395eb-db1c-48f8-803a-f011a251c77a	11111111-1111-1111-1111-111111111111	1085cebe-ebf0-4804-83f3-aae6d0d4a7c9	094b3d75-f087-476a-863b-a70da76e2365	\N	Item	1	34000	68000	\N	2026-09-08 11:09:01.355061+05:30	2026-09-08 11:09:01.355061+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	094b3d75-f087-476a-863b-a70da76e2365	2	34000	68000	\N	\N
18ec13cb-0674-4f07-b06a-166a80d9c6b7	11111111-1111-1111-1111-111111111111	e7d4d6cf-4838-43bd-8334-688d11302496	094b3d75-f087-476a-863b-a70da76e2365	\N	Item	1	34000	102000	\N	2026-09-08 11:12:06.961926+05:30	2026-09-08 11:12:06.961926+05:30	\N	\N	\N	\N	f	\N	f	10	STARTER	094b3d75-f087-476a-863b-a70da76e2365	3	34000	102000	\N	\N
ae1afbe0-fd20-4f80-973b-bf1ca6b3c498	11111111-1111-1111-1111-111111111111	eb13fd97-c972-4447-8a42-898eb545191e	d4d5c11d-7ca8-4f1f-9784-45b39bd6ef7c	\N	Item	1	8000	8000	\N	2026-09-08 13:13:14.858193+05:30	2026-09-08 13:13:14.858193+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	d4d5c11d-7ca8-4f1f-9784-45b39bd6ef7c	1	8000	8000	\N	\N
e692ea73-ba2b-457b-a326-3baee8941065	11111111-1111-1111-1111-111111111111	eb13fd97-c972-4447-8a42-898eb545191e	8fe74946-54cc-4f68-ae82-5f775ef44b20	\N	Item	1	12000	12000	\N	2026-09-08 13:13:14.858193+05:30	2026-09-08 13:13:14.858193+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	8fe74946-54cc-4f68-ae82-5f775ef44b20	1	12000	12000	\N	\N
4994ad24-bebe-49a0-977b-faa12ee5ed46	11111111-1111-1111-1111-111111111111	f5d3449d-ce21-48cb-ab01-b41c41a7301c	88edfc29-cdb9-469b-afda-bbb322f0a168	\N	Item	1	3000	3000	\N	2026-09-08 13:14:15.227885+05:30	2026-09-08 13:14:15.227885+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	88edfc29-cdb9-469b-afda-bbb322f0a168	1	3000	3000	\N	\N
7189e68a-4aef-4e32-876e-56a9f20a4a9c	11111111-1111-1111-1111-111111111111	f5d3449d-ce21-48cb-ab01-b41c41a7301c	8fe74946-54cc-4f68-ae82-5f775ef44b20	\N	Item	1	12000	12000	\N	2026-09-08 13:14:15.227885+05:30	2026-09-08 13:14:15.227885+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	8fe74946-54cc-4f68-ae82-5f775ef44b20	1	12000	12000	\N	\N
b80c6285-d018-47a1-9dfa-2e686b8effc3	11111111-1111-1111-1111-111111111111	f5d3449d-ce21-48cb-ab01-b41c41a7301c	49768e80-5cf1-47a9-be73-5f24de6fb26e	\N	Item	1	5000	5000	\N	2026-09-08 14:14:29.187607+05:30	2026-09-08 14:14:29.187607+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	49768e80-5cf1-47a9-be73-5f24de6fb26e	1	5000	5000	\N	\N
78627a3c-b92a-42d4-adba-b530878b560f	11111111-1111-1111-1111-111111111111	b101f725-9679-4cf3-9f0f-16adb200ecff	2c28152b-2d3a-4796-ac1f-aa04d783f921	\N	Item	1	3000	3000	\N	2026-09-08 14:27:24.395569+05:30	2026-09-08 14:27:24.395569+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	2c28152b-2d3a-4796-ac1f-aa04d783f921	1	3000	3000	\N	\N
74a7e192-fc57-4923-8f2f-61dbb363b66f	11111111-1111-1111-1111-111111111111	685aa7a6-e1d4-4a39-a7fe-c54252180927	9e27f8db-5ca3-4d7f-97d4-aa3d87642452	\N	Item	1	11000	11000	\N	2026-09-08 14:41:53.550636+05:30	2026-09-08 14:41:53.550636+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	9e27f8db-5ca3-4d7f-97d4-aa3d87642452	1	11000	11000	\N	\N
a8871109-ffa1-481a-88da-e56804420b05	11111111-1111-1111-1111-111111111111	76692730-cd05-45cd-b8ad-9cc20ac9fc5a	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	\N	Item	1	7000	7000	\N	2026-09-08 15:13:45.019446+05:30	2026-09-08 15:13:45.019446+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	1	7000	7000	\N	\N
7ef66626-f4e7-4ebe-a4fe-4e09367d8ab0	11111111-1111-1111-1111-111111111111	f5d3449d-ce21-48cb-ab01-b41c41a7301c	5d13a97e-027a-445b-94eb-2f00546b1614	\N	Item	1	9500	9500	\N	2026-09-08 16:19:27.270906+05:30	2026-09-08 16:19:27.270906+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	5d13a97e-027a-445b-94eb-2f00546b1614	1	9500	9500	\N	\N
f89483cf-0d93-4bc0-816a-285a7a13d065	11111111-1111-1111-1111-111111111111	f5d3449d-ce21-48cb-ab01-b41c41a7301c	e286dcdc-8100-430d-967e-6edba83f1609	\N	Item	1	14000	14000	\N	2026-09-08 16:19:27.270906+05:30	2026-09-08 16:19:27.270906+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	e286dcdc-8100-430d-967e-6edba83f1609	1	14000	14000	\N	\N
e6d644af-1584-467a-863f-bac26eb84d38	11111111-1111-1111-1111-111111111111	0602cb47-3398-4ba0-b5da-87e23909efa3	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	\N	Item	1	8500	8500	\N	2026-09-09 12:47:30.71336+05:30	2026-09-09 12:47:30.71336+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	1	8500	8500	\N	\N
4c625b81-fece-407d-9b63-dced164b38b1	11111111-1111-1111-1111-111111111111	0602cb47-3398-4ba0-b5da-87e23909efa3	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	\N	Item	1	8500	8500	\N	2026-09-09 12:47:50.69576+05:30	2026-09-09 12:47:50.69576+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	1	8500	8500	\N	\N
c6fbd83e-75ed-472a-b1bf-2e7889b797f0	11111111-1111-1111-1111-111111111111	2d4b655e-a5bf-4900-ba0c-11e1b3c2685c	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	\N	Item	1	8500	8500	\N	2026-09-09 12:51:14.215584+05:30	2026-09-09 12:51:14.215584+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	1	8500	8500	\N	\N
04e04ddf-bbb4-4e74-ae9e-864aca2029d4	11111111-1111-1111-1111-111111111111	2d4b655e-a5bf-4900-ba0c-11e1b3c2685c	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	\N	Item	1	8500	136000	\N	2026-09-09 12:51:28.083736+05:30	2026-09-09 12:51:28.083736+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	16	8500	136000	\N	\N
4923d9da-bcb2-46da-833a-8b4a037f0436	11111111-1111-1111-1111-111111111111	2d4b655e-a5bf-4900-ba0c-11e1b3c2685c	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	\N	Item	1	8500	272000	\N	2026-09-09 12:51:46.669142+05:30	2026-09-09 12:51:46.669142+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	32	8500	272000	\N	\N
e2ac9075-4d00-464e-88a2-afe715362121	11111111-1111-1111-1111-111111111111	f973888e-e429-473a-8566-ddea7ac708a0	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	\N	Item	1	8500	25500	\N	2026-09-09 12:52:31.629819+05:30	2026-09-09 12:52:31.629819+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	3	8500	25500	\N	\N
f79c39a2-f114-496c-bf0e-09ac73ddf914	11111111-1111-1111-1111-111111111111	2d4b655e-a5bf-4900-ba0c-11e1b3c2685c	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	\N	Item	1	8500	34000	\N	2026-09-09 12:55:56.357916+05:30	2026-09-09 12:55:56.357916+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	4	8500	34000	\N	\N
03ec0df1-5176-44d6-befb-8477fd240cb0	11111111-1111-1111-1111-111111111111	190ec2cb-fb90-44c2-ad76-b32672063fdb	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	\N	Item	1	8500	25500	\N	2026-09-09 13:01:25.151456+05:30	2026-09-09 13:01:25.151456+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	3	8500	25500	\N	\N
970e6000-56da-419a-9d6c-33afca6265fd	11111111-1111-1111-1111-111111111111	4e192b03-6942-454a-a9dd-9084d99362b1	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	\N	Item	1	8500	25500	\N	2026-09-09 13:02:02.16991+05:30	2026-09-09 13:02:02.16991+05:30	\N	\N	\N	\N	f	\N	t	\N	\N	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	3	8500	25500	TEST_VOID	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
aa746b8b-9705-4520-a5a8-54ab4190f58c	11111111-1111-1111-1111-111111111111	9528cbcc-5873-41a3-b142-53165932bc70	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	\N	Item	1	8500	127500	\N	2026-09-09 13:02:03.709268+05:30	2026-09-09 13:02:03.709268+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	15	8500	127500	\N	\N
2bf7206e-c6f3-44aa-981c-a457abf6e62a	11111111-1111-1111-1111-111111111111	39f6e5e8-3eb1-4100-a8cc-4dfcb49ba060	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	\N	Item	1	7000	21000	\N	2026-09-09 13:03:37.790437+05:30	2026-09-09 13:03:37.790437+05:30	\N	\N	\N	\N	f	\N	t	\N	\N	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	3	7000	21000	TEST_VOID	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
d07b13ab-7416-45f5-aa50-d4c92edb3536	11111111-1111-1111-1111-111111111111	118a762d-2cc4-4b94-b0c6-1b7360cd6652	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	\N	Item	1	7000	105000	\N	2026-09-09 13:03:39.348843+05:30	2026-09-09 13:03:39.348843+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	15	7000	105000	\N	\N
1aa6fbfe-8643-49a5-8246-69a71196a167	11111111-1111-1111-1111-111111111111	0a746ebb-ff2b-40d1-8d00-5e7652f56006	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	\N	Item	1	8500	8500	\N	2026-09-09 14:27:26.129288+05:30	2026-09-09 14:27:26.129288+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	e7d95cfe-261f-4545-b37b-2a4d3e69ca8d	1	8500	8500	\N	\N
94a171f1-9bff-45e7-b655-9b864a43ec78	11111111-1111-1111-1111-111111111111	c182470d-5000-40bc-86f8-b9093c4333e8	49768e80-5cf1-47a9-be73-5f24de6fb26e	\N	Item	1	5000	25000	\N	2026-09-09 14:27:33.522587+05:30	2026-09-09 14:27:33.522587+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	49768e80-5cf1-47a9-be73-5f24de6fb26e	5	5000	25000	\N	\N
342243f5-67c3-4f51-a5f7-c6441c0f8058	11111111-1111-1111-1111-111111111111	482d35cd-b7b6-4c65-a7f3-943897646bad	49768e80-5cf1-47a9-be73-5f24de6fb26e	\N	Item	1	5000	25000	\N	2026-09-09 14:28:57.778133+05:30	2026-09-09 14:28:57.778133+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	49768e80-5cf1-47a9-be73-5f24de6fb26e	5	5000	25000	\N	\N
28791b77-9a0b-4827-8fc3-156591208ce4	11111111-1111-1111-1111-111111111111	25ab98b4-6057-4986-a634-4dd7dc5f51bc	49768e80-5cf1-47a9-be73-5f24de6fb26e	\N	Item	1	5000	25000	\N	2026-09-09 14:29:43.187526+05:30	2026-09-09 14:29:43.187526+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	49768e80-5cf1-47a9-be73-5f24de6fb26e	5	5000	25000	\N	\N
8fa479df-4828-4bbd-8781-0445ec6a7a4e	11111111-1111-1111-1111-111111111111	65505588-f509-44ef-a6c6-c488503dcbe3	49768e80-5cf1-47a9-be73-5f24de6fb26e	\N	Item	1	5000	25000	\N	2026-09-09 14:31:14.437955+05:30	2026-09-09 14:31:14.437955+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	49768e80-5cf1-47a9-be73-5f24de6fb26e	5	5000	25000	\N	\N
1d24f99b-b19c-40f1-b8f4-3c9e1222fd40	11111111-1111-1111-1111-111111111111	b6abe3e6-d0e7-4dc7-a631-097181effc3a	49768e80-5cf1-47a9-be73-5f24de6fb26e	\N	Item	1	5000	25000	\N	2026-09-09 14:31:59.195071+05:30	2026-09-09 14:31:59.195071+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	49768e80-5cf1-47a9-be73-5f24de6fb26e	5	5000	25000	\N	\N
f1df626b-fc7b-4399-bf69-c2502c895927	11111111-1111-1111-1111-111111111111	d71091c4-71f0-4c75-bd38-c6b08ba4dd4a	49768e80-5cf1-47a9-be73-5f24de6fb26e	\N	Item	1	5000	25000	\N	2026-09-09 14:32:48.219814+05:30	2026-09-09 14:32:48.219814+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	49768e80-5cf1-47a9-be73-5f24de6fb26e	5	5000	25000	\N	\N
c00be2b8-881c-4bde-9a46-577c19ea7bc3	11111111-1111-1111-1111-111111111111	d1467f47-4869-4592-996e-0d3f373ec018	49768e80-5cf1-47a9-be73-5f24de6fb26e	\N	Item	1	5000	25000	\N	2026-09-09 14:34:00.887085+05:30	2026-09-09 14:34:00.887085+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	49768e80-5cf1-47a9-be73-5f24de6fb26e	5	5000	25000	\N	\N
4803f052-a4cd-4a89-ab6f-74fac3d67772	11111111-1111-1111-1111-111111111111	0a746ebb-ff2b-40d1-8d00-5e7652f56006	5101522a-081e-4866-9f74-261854fe4404	\N	Item	1	6000	6000	\N	2026-09-09 14:35:45.599475+05:30	2026-09-09 14:35:45.599475+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	5101522a-081e-4866-9f74-261854fe4404	1	6000	6000	\N	\N
2f46c4fc-4fd6-4c9b-a3f8-acdbd42c0594	11111111-1111-1111-1111-111111111111	3e1ba9c8-0311-4534-a8d3-fa97b3a4f933	49768e80-5cf1-47a9-be73-5f24de6fb26e	\N	Item	1	5000	5000	\N	2026-09-09 15:09:20.325753+05:30	2026-09-09 15:09:20.325753+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	49768e80-5cf1-47a9-be73-5f24de6fb26e	1	5000	5000	\N	\N
582a60f4-534d-4024-88c8-1f56e570f4de	11111111-1111-1111-1111-111111111111	3e1ba9c8-0311-4534-a8d3-fa97b3a4f933	49768e80-5cf1-47a9-be73-5f24de6fb26e	\N	Item	1	5000	5000	\N	2026-09-10 16:50:52.998474+05:30	2026-09-10 16:50:52.998474+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	49768e80-5cf1-47a9-be73-5f24de6fb26e	1	5000	5000	\N	\N
feaf21a6-4ea0-4b99-b0f0-bf197fa7b705	11111111-1111-1111-1111-111111111111	27f9f630-3e8b-4ba9-b4d7-e631e45182f7	49768e80-5cf1-47a9-be73-5f24de6fb26e	\N	Item	1	5000	5000	\N	2026-09-11 12:09:46.272587+05:30	2026-09-11 12:09:46.272587+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	49768e80-5cf1-47a9-be73-5f24de6fb26e	1	5000	5000	\N	\N
5325d83c-f786-4964-bdd3-08acdefa96be	11111111-1111-1111-1111-111111111111	c8387bcf-ab67-44bb-87fb-d67f6d7601ca	5101522a-081e-4866-9f74-261854fe4404	\N	Item	1	6000	12000	\N	2026-09-11 12:33:27.192618+05:30	2026-09-11 12:33:27.192618+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	5101522a-081e-4866-9f74-261854fe4404	2	6000	12000	\N	\N
6d2bb836-3203-4c6c-a2ea-d81d3729a02d	11111111-1111-1111-1111-111111111111	d8d53271-b231-47e9-93aa-7a47185f8940	49768e80-5cf1-47a9-be73-5f24de6fb26e	\N	Item	1	5000	5000	\N	2026-09-11 12:59:30.534997+05:30	2026-09-11 12:59:30.534997+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	49768e80-5cf1-47a9-be73-5f24de6fb26e	1	5000	5000	\N	\N
afde9793-1550-477e-b114-bdd6d6c5491e	11111111-1111-1111-1111-111111111111	d8d53271-b231-47e9-93aa-7a47185f8940	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	\N	Item	1	7000	7000	\N	2026-09-11 12:59:30.534997+05:30	2026-09-11 12:59:30.534997+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	1	7000	7000	\N	\N
1bc49c16-8bb7-4650-a1c1-0f3afb56fdd8	11111111-1111-1111-1111-111111111111	ccffe940-9f6b-41af-aaeb-72b3e1cdb3da	5101522a-081e-4866-9f74-261854fe4404	\N	Item	1	6000	6000	\N	2026-09-11 12:59:52.770314+05:30	2026-09-11 12:59:52.770314+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	5101522a-081e-4866-9f74-261854fe4404	1	6000	6000	\N	\N
45c18b8d-29a0-4435-98e2-db478e9242f9	11111111-1111-1111-1111-111111111111	89dba099-01ad-417a-a438-66ca8af5e712	49768e80-5cf1-47a9-be73-5f24de6fb26e	\N	Item	1	5000	5000	\N	2026-09-11 14:24:19.816033+05:30	2026-09-11 14:24:19.816033+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	49768e80-5cf1-47a9-be73-5f24de6fb26e	1	5000	5000	\N	\N
9fa4ac4f-fd3d-4490-9ad1-87bed53a26d7	11111111-1111-1111-1111-111111111111	4a4e9d6c-a797-4b03-9835-a44526c890e2	5101522a-081e-4866-9f74-261854fe4404	\N	Item	1	6000	6000	\N	2026-09-11 14:25:28.490288+05:30	2026-09-11 14:25:28.490288+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	5101522a-081e-4866-9f74-261854fe4404	1	6000	6000	\N	\N
4b8a17f6-cc5b-43d8-9bb1-23572af374e7	11111111-1111-1111-1111-111111111111	4a4e9d6c-a797-4b03-9835-a44526c890e2	5101522a-081e-4866-9f74-261854fe4404	\N	Item	1	6000	6000	\N	2026-09-11 16:39:37.814336+05:30	2026-09-11 16:39:37.814336+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	5101522a-081e-4866-9f74-261854fe4404	1	6000	6000	\N	\N
610ce49b-6860-4c2a-a978-58eee53abe0b	11111111-1111-1111-1111-111111111111	abaed738-9e4f-4470-ae04-031b3baa4721	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	\N	Item	1	7000	7000	\N	2026-09-12 16:04:39.509754+05:30	2026-09-12 16:04:39.509754+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	1	7000	7000	\N	\N
e58cd3f4-fcb9-466f-882e-79f58c50f01d	11111111-1111-1111-1111-111111111111	abaed738-9e4f-4470-ae04-031b3baa4721	71451535-8d85-417f-b0ec-3f2b87016045	\N	Item	1	8000	8000	\N	2026-09-12 16:04:39.509754+05:30	2026-09-12 16:04:39.509754+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	71451535-8d85-417f-b0ec-3f2b87016045	1	8000	8000	\N	\N
de49919b-7467-40d6-a444-ce0e0b927f1e	11111111-1111-1111-1111-111111111111	8139a10d-c414-4402-818c-ea00cfd5e786	5d13a97e-027a-445b-94eb-2f00546b1614	\N	Item	1	9500	9500	\N	2026-09-12 16:20:51.813347+05:30	2026-09-12 16:20:51.813347+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	5d13a97e-027a-445b-94eb-2f00546b1614	1	9500	9500	\N	\N
0a897341-6ac0-4d8d-9eaf-ceade7d93d17	11111111-1111-1111-1111-111111111111	8139a10d-c414-4402-818c-ea00cfd5e786	640584ad-7f9e-4a1b-8740-290fd382ea81	\N	Item	1	8500	8500	\N	2026-09-12 16:20:51.813347+05:30	2026-09-12 16:20:51.813347+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	640584ad-7f9e-4a1b-8740-290fd382ea81	1	8500	8500	\N	\N
507db4ef-89ab-45ce-b827-28b40e002b45	11111111-1111-1111-1111-111111111111	547361f1-ab65-4eeb-b5ae-790378f1eebc	640584ad-7f9e-4a1b-8740-290fd382ea81	\N	Item	1	8500	8500	\N	2026-09-12 16:22:09.469639+05:30	2026-09-12 16:22:09.469639+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	640584ad-7f9e-4a1b-8740-290fd382ea81	1	8500	8500	\N	\N
1756bfe8-0ef6-4d28-aaab-39b4e69b086e	11111111-1111-1111-1111-111111111111	7bf0131c-f022-46a1-9a7b-8569cd3682f8	71451535-8d85-417f-b0ec-3f2b87016045	\N	Item	1	8000	8000	\N	2026-09-12 16:23:24.861331+05:30	2026-09-12 16:23:24.861331+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	71451535-8d85-417f-b0ec-3f2b87016045	1	8000	8000	\N	\N
384df9e2-296b-4b7e-b7b3-fc56b19ee31b	11111111-1111-1111-1111-111111111111	7bf0131c-f022-46a1-9a7b-8569cd3682f8	d4d5c11d-7ca8-4f1f-9784-45b39bd6ef7c	\N	Item	1	8000	8000	\N	2026-09-12 16:37:34.088358+05:30	2026-09-12 16:37:34.088358+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	d4d5c11d-7ca8-4f1f-9784-45b39bd6ef7c	1	8000	8000	\N	\N
2ea6b595-c3ff-4250-b013-4b9221c0fd73	11111111-1111-1111-1111-111111111111	7bf0131c-f022-46a1-9a7b-8569cd3682f8	2ddb7944-4e83-4dda-99de-94dd5e83bb77	\N	Item	1	32000	32000	\N	2026-09-12 16:37:34.088358+05:30	2026-09-12 16:37:34.088358+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	2ddb7944-4e83-4dda-99de-94dd5e83bb77	1	32000	32000	\N	\N
e37fb3cb-1472-4f02-9822-a08237870bd7	11111111-1111-1111-1111-111111111111	815fbab6-72c9-41f6-b104-3f8df856c545	71451535-8d85-417f-b0ec-3f2b87016045	\N	Item	1	8000	16000	\N	2026-09-12 16:40:24.104678+05:30	2026-09-12 16:40:24.104678+05:30	\N	\N	\N	\N	f	\N	f	\N	STARTER	71451535-8d85-417f-b0ec-3f2b87016045	2	8000	16000	\N	\N
31353c57-0051-4b53-b99e-d1c5b72ff0dd	11111111-1111-1111-1111-111111111111	00d7a187-3ebe-45bb-a596-f39d6680e588	1048c560-86bd-45c5-b872-eb5e802c6e46	\N	Item	1	32000	64000	\N	2026-09-15 15:20:21.624843+05:30	2026-09-15 15:20:21.624843+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	1048c560-86bd-45c5-b872-eb5e802c6e46	2	32000	64000	\N	\N
89bf37b2-7bfb-4e59-ac8d-7d86609c4bc3	11111111-1111-1111-1111-111111111111	fd16417e-3c3d-418a-a088-d360729aac73	1048c560-86bd-45c5-b872-eb5e802c6e46	\N	Item	1	32000	64000	\N	2026-09-15 15:22:15.313833+05:30	2026-09-15 15:22:15.313833+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	1048c560-86bd-45c5-b872-eb5e802c6e46	2	32000	64000	\N	\N
9f984ea0-7092-495b-aaab-e0339c3dc92a	11111111-1111-1111-1111-111111111111	dce6709a-59c7-4b0f-b6b7-a84556fd4da8	1048c560-86bd-45c5-b872-eb5e802c6e46	\N	Item	1	26000	26000	\N	2026-09-15 15:26:49.319171+05:30	2026-09-15 15:26:49.319171+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	1048c560-86bd-45c5-b872-eb5e802c6e46	1	26000	26000	\N	\N
4b38180e-52e9-46df-9636-03f3ab5fe080	11111111-1111-1111-1111-111111111111	dce6709a-59c7-4b0f-b6b7-a84556fd4da8	1048c560-86bd-45c5-b872-eb5e802c6e46	\N	Item	1	5500	16500	\N	2026-09-15 15:26:49.319171+05:30	2026-09-15 15:26:49.319171+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	1048c560-86bd-45c5-b872-eb5e802c6e46	3	5500	16500	\N	\N
bd669fbe-a77b-4740-a72b-436bd193d398	11111111-1111-1111-1111-111111111111	cbb10a15-6c98-4ad1-a42b-ae7e1f56f9b7	5101522a-081e-4866-9f74-261854fe4404	\N	Item	1	12000	24000	\N	2026-09-15 16:15:47.754987+05:30	2026-09-15 16:15:47.754987+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	5101522a-081e-4866-9f74-261854fe4404	2	12000	24000	\N	\N
a88827e9-020a-4394-9ce6-4be1f5eee84f	11111111-1111-1111-1111-111111111111	cbb10a15-6c98-4ad1-a42b-ae7e1f56f9b7	0020780f-7112-4804-a81b-2e06a91cdaa4	\N	Item	1	11000	22000	\N	2026-09-15 16:15:47.754987+05:30	2026-09-15 16:15:47.754987+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	0020780f-7112-4804-a81b-2e06a91cdaa4	2	11000	22000	\N	\N
50cc1925-243e-4e13-9c8d-30e6809f5228	11111111-1111-1111-1111-111111111111	244aecef-ffc4-48ba-a00c-0e041ee50389	71451535-8d85-417f-b0ec-3f2b87016045	\N	Item	1	16000	32000	\N	2026-09-15 16:15:47.978679+05:30	2026-09-15 16:15:47.978679+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	71451535-8d85-417f-b0ec-3f2b87016045	2	16000	32000	\N	\N
a4875a2e-6750-4304-9576-ab7968409a53	11111111-1111-1111-1111-111111111111	3d9c934c-97d3-4da2-8f4b-4772896ee29b	49768e80-5cf1-47a9-be73-5f24de6fb26e	\N	Item	1	5000	10000	\N	2026-09-25 00:07:00.614818+05:30	2026-09-25 00:07:00.614818+05:30	\N	\N	\N	\N	f	\N	f	1	STARTER	49768e80-5cf1-47a9-be73-5f24de6fb26e	2	5000	10000	\N	\N
bff83a34-d2e8-476c-b1bb-3b57ebed89bc	11111111-1111-1111-1111-111111111111	3d9c934c-97d3-4da2-8f4b-4772896ee29b	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	\N	Item	1	7000	7000	\N	2026-09-25 00:07:00.614818+05:30	2026-09-25 00:07:00.614818+05:30	\N	\N	\N	\N	f	\N	f	2	MAIN	4a8d3fad-d0e2-4c19-8840-9ef706f90b7b	1	7000	7000	\N	\N
307df4ba-78be-4ad6-aaf4-c7242681a2b6	11111111-1111-1111-1111-111111111111	6dcda227-21c2-4291-918f-a3813a9062eb	9e27f8db-5ca3-4d7f-97d4-aa3d87642452	\N	Item	1	11000	11000	\N	2026-10-03 04:36:17.698378+05:30	2026-10-03 04:36:17.698378+05:30	\N	\N	\N	\N	f	\N	f	\N	\N	9e27f8db-5ca3-4d7f-97d4-aa3d87642452	1	11000	11000	\N	\N
8d2c89b6-3bb0-4248-87e9-7b363ef8c95d	11111111-1111-1111-1111-111111111111	6040a630-394f-416c-9b97-8deef80f81f8	5101522a-081e-4866-9f74-261854fe4404	\N	Item	1	6000	6000	\N	2026-10-03 14:44:05.695494+05:30	2026-10-03 14:44:05.695494+05:30	\N	\N	\N	\N	f	\N	t	\N	STARTER	5101522a-081e-4866-9f74-261854fe4404	1	6000	6000	kk	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
\.


--
-- Data for Name: order_payments; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.order_payments (id, outlet_id, order_id, payment_id, amount_minor, created_at, updated_at, created_by, updated_by, payment_group_id, rounding_adjustment_minor, method, status, transaction_id, seat_number) FROM stdin;
\.


--
-- Data for Name: order_refunds; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.order_refunds (id, outlet_id, order_id, refund_id, amount_minor, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: order_seat_bills; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.order_seat_bills (id, outlet_id, order_id, seat_number, split_group_id, subtotal, discount_total, tax_total, service_charge_total, tip_total, grand_total, paid_total, status, settled_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: order_status_history; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.order_status_history (id, outlet_id, order_id, from_status, to_status, reason_code, actor_id, created_at, status, notes, created_by) FROM stdin;
badb3003-fd45-4add-bafd-968e04059674	11111111-1111-1111-1111-111111111111	b0845453-ec80-411d-8370-e62958475492	\N	PLACED	\N	\N	2026-09-03 14:07:10.202+05:30	PLACED	\N	\N
bfb4ef97-522c-45a5-b3e0-adfadc34813a	11111111-1111-1111-1111-111111111111	b0845453-ec80-411d-8370-e62958475492	\N	CONFIRMED	\N	\N	2026-09-03 14:07:10.23+05:30	CONFIRMED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
26210006-709c-4c1a-99de-feb5d1c4d2a0	11111111-1111-1111-1111-111111111111	b0845453-ec80-411d-8370-e62958475492	\N	KOT_CREATED	\N	\N	2026-09-03 14:07:10.242+05:30	KOT_CREATED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
f52f6069-9775-4e91-a3bb-f15dc653678b	11111111-1111-1111-1111-111111111111	5338928a-7fb6-429f-a646-8f12166322fa	\N	PLACED	\N	\N	2026-09-03 14:07:13.305+05:30	PLACED	\N	\N
4e2dc5cc-4ca4-4884-9f43-d3556dfed911	11111111-1111-1111-1111-111111111111	5338928a-7fb6-429f-a646-8f12166322fa	\N	CONFIRMED	\N	\N	2026-09-03 14:07:13.317+05:30	CONFIRMED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
e2232276-0886-4ed2-af92-a8a0d934203b	11111111-1111-1111-1111-111111111111	5338928a-7fb6-429f-a646-8f12166322fa	\N	KOT_CREATED	\N	\N	2026-09-03 14:07:13.33+05:30	KOT_CREATED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
555e86fc-8bda-44ee-bde2-dbd414dc7a69	11111111-1111-1111-1111-111111111111	17cb34b5-878f-4d13-b0ec-02af3307cbf2	\N	PLACED	\N	\N	2026-09-03 14:10:08.945+05:30	PLACED	\N	\N
00e6d220-0555-495f-813b-34ff368c7957	11111111-1111-1111-1111-111111111111	17cb34b5-878f-4d13-b0ec-02af3307cbf2	\N	CONFIRMED	\N	\N	2026-09-03 14:10:08.961+05:30	CONFIRMED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
1eb691fe-1e3d-4a85-b89b-b4adbeab6e81	11111111-1111-1111-1111-111111111111	17cb34b5-878f-4d13-b0ec-02af3307cbf2	\N	KOT_CREATED	\N	\N	2026-09-03 14:10:08.968+05:30	KOT_CREATED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
8153192d-ab46-449a-b63e-a77d8eeb2db6	11111111-1111-1111-1111-111111111111	4a3e148b-1df0-46f8-a71a-c834486429e5	\N	PLACED	\N	\N	2026-09-03 14:19:54.439+05:30	PLACED	\N	\N
07df72c6-be95-42f2-8092-175e6d2b85b1	11111111-1111-1111-1111-111111111111	4a3e148b-1df0-46f8-a71a-c834486429e5	\N	CONFIRMED	\N	\N	2026-09-03 14:19:54.608+05:30	CONFIRMED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
5ce92fa6-e740-446e-8116-c00ad21d7cad	11111111-1111-1111-1111-111111111111	e93358df-ec3b-4e3b-a241-8e93bd953411	\N	PLACED	\N	\N	2026-09-03 14:21:16.18+05:30	PLACED	\N	\N
9bfb8b31-4885-439b-abd8-df10d069a623	11111111-1111-1111-1111-111111111111	e93358df-ec3b-4e3b-a241-8e93bd953411	\N	CONFIRMED	\N	\N	2026-09-03 14:21:16.191+05:30	CONFIRMED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
8fef026f-a18e-44d6-b3da-136c7b0125fa	11111111-1111-1111-1111-111111111111	e93358df-ec3b-4e3b-a241-8e93bd953411	\N	KOT_CREATED	\N	\N	2026-09-03 14:21:16.2+05:30	KOT_CREATED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
905b5b93-253f-4014-92d8-f3e9a80b9996	11111111-1111-1111-1111-111111111111	71ef893c-0ccc-439d-bc3e-0a248037303b	\N	PLACED	\N	\N	2026-09-03 14:25:51.875+05:30	PLACED	\N	\N
6518444e-c27a-470d-a2be-d4ef92f2f7bd	11111111-1111-1111-1111-111111111111	71ef893c-0ccc-439d-bc3e-0a248037303b	\N	CONFIRMED	\N	\N	2026-09-03 14:25:51.893+05:30	CONFIRMED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
3284639a-30ca-4bd7-b8d3-176303f3df01	11111111-1111-1111-1111-111111111111	71ef893c-0ccc-439d-bc3e-0a248037303b	\N	KOT_CREATED	\N	\N	2026-09-03 14:25:51.904+05:30	KOT_CREATED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
f8d6200b-0b59-4aa0-a639-e85fc90cc377	11111111-1111-1111-1111-111111111111	71ef893c-0ccc-439d-bc3e-0a248037303b	\N	IN_PREPARATION	\N	\N	2026-09-03 14:43:30.832+05:30	IN_PREPARATION	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
579cc574-4ed8-429e-ba20-e17e18ac41fd	11111111-1111-1111-1111-111111111111	71ef893c-0ccc-439d-bc3e-0a248037303b	\N	READY	\N	\N	2026-09-03 14:43:30.89+05:30	READY	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
5264cacf-f7bf-467a-80b0-ea5cf5b380a9	11111111-1111-1111-1111-111111111111	71ef893c-0ccc-439d-bc3e-0a248037303b	\N	SERVED	\N	\N	2026-09-03 14:45:03.157+05:30	SERVED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
880c8b23-6d2d-4c10-824c-ef4617efb7a8	11111111-1111-1111-1111-111111111111	e93358df-ec3b-4e3b-a241-8e93bd953411	\N	IN_PREPARATION	\N	\N	2026-09-03 14:46:09.2+05:30	IN_PREPARATION	\N	918df673-2606-403a-9fad-1c54870d1fce
643474ca-3780-4d89-b496-8c3c018f4582	11111111-1111-1111-1111-111111111111	e93358df-ec3b-4e3b-a241-8e93bd953411	\N	READY	\N	\N	2026-09-03 14:46:36.427+05:30	READY	\N	918df673-2606-403a-9fad-1c54870d1fce
5cfee20d-a2d5-47a0-8dd8-685a7801c549	11111111-1111-1111-1111-111111111111	e7eccfdc-02d5-470f-869b-da665f7dcb2e	\N	PLACED	\N	\N	2026-09-03 14:53:11.861+05:30	PLACED	\N	\N
34007854-06eb-498e-90ca-9b1a297c135e	11111111-1111-1111-1111-111111111111	e7eccfdc-02d5-470f-869b-da665f7dcb2e	\N	CONFIRMED	\N	\N	2026-09-03 14:53:11.877+05:30	CONFIRMED	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06
043c970f-6d9d-4945-be36-f3d5e068a320	11111111-1111-1111-1111-111111111111	e7eccfdc-02d5-470f-869b-da665f7dcb2e	\N	KOT_CREATED	\N	\N	2026-09-03 14:53:11.885+05:30	KOT_CREATED	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06
0eaebd12-ba42-4d82-8058-7332f0c8aa49	11111111-1111-1111-1111-111111111111	e7eccfdc-02d5-470f-869b-da665f7dcb2e	\N	IN_PREPARATION	\N	\N	2026-09-03 14:54:45.51+05:30	IN_PREPARATION	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06
7a5b7e81-185b-4f3e-a805-61326815db4a	11111111-1111-1111-1111-111111111111	e7eccfdc-02d5-470f-869b-da665f7dcb2e	\N	READY	\N	\N	2026-09-03 14:54:58.003+05:30	READY	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06
637eed85-3d26-4a17-a7b0-ddf8ebb4538c	11111111-1111-1111-1111-111111111111	5583e31e-48a5-435a-936e-aba2f8bb9c9c	\N	PLACED	\N	\N	2026-09-03 15:17:20.223+05:30	PLACED	\N	\N
f75b8046-76af-4c32-8741-0d9651be6bd9	11111111-1111-1111-1111-111111111111	5583e31e-48a5-435a-936e-aba2f8bb9c9c	\N	CONFIRMED	\N	\N	2026-09-03 15:17:20.24+05:30	CONFIRMED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
229e092f-ca2e-4dfd-ab7f-2e9a90f1587c	11111111-1111-1111-1111-111111111111	5583e31e-48a5-435a-936e-aba2f8bb9c9c	\N	KOT_CREATED	\N	\N	2026-09-03 15:17:20.25+05:30	KOT_CREATED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
6a5bf421-53c9-4986-bdf8-a50cf28da2d1	11111111-1111-1111-1111-111111111111	0f621958-d193-4d99-b6ef-037fcea9cd0a	\N	PLACED	\N	\N	2026-09-04 00:05:22.316+05:30	PLACED	\N	\N
fb9079fd-4e4e-4cbc-b289-36a1b9b89894	11111111-1111-1111-1111-111111111111	0f621958-d193-4d99-b6ef-037fcea9cd0a	\N	CONFIRMED	\N	\N	2026-09-04 00:05:22.342+05:30	CONFIRMED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
77061d53-2103-404e-9b15-4f0d6dfe3abd	11111111-1111-1111-1111-111111111111	0f621958-d193-4d99-b6ef-037fcea9cd0a	\N	KOT_CREATED	\N	\N	2026-09-04 00:05:22.35+05:30	KOT_CREATED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
12dc2d53-f1b7-4f27-877b-f276d1a553e7	11111111-1111-1111-1111-111111111111	e93358df-ec3b-4e3b-a241-8e93bd953411	\N	HANDED_OVER	\N	\N	2026-09-04 00:40:28.061+05:30	HANDED_OVER	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
0f3abd30-e7b1-4f74-ab36-3acdbf3ad5f4	11111111-1111-1111-1111-111111111111	a00d57c3-c01d-49d0-9166-45e9f7e22497	\N	PLACED	\N	\N	2026-09-04 00:40:55.711+05:30	PLACED	\N	\N
53f43ddf-17d6-4a0b-bedb-e6ea9812ebdb	11111111-1111-1111-1111-111111111111	a00d57c3-c01d-49d0-9166-45e9f7e22497	\N	CONFIRMED	\N	\N	2026-09-04 00:40:55.727+05:30	CONFIRMED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
ee137de4-6f84-4fba-b9c7-01204ccfeea4	11111111-1111-1111-1111-111111111111	a00d57c3-c01d-49d0-9166-45e9f7e22497	\N	KOT_CREATED	\N	\N	2026-09-04 00:40:55.735+05:30	KOT_CREATED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
3a251390-5750-4401-aabe-bfd0e5c6ff19	11111111-1111-1111-1111-111111111111	5583e31e-48a5-435a-936e-aba2f8bb9c9c	\N	IN_PREPARATION	\N	\N	2026-09-04 00:42:51.612+05:30	IN_PREPARATION	\N	918df673-2606-403a-9fad-1c54870d1fce
89d2e4bf-5537-4054-937e-1828a1bcecea	11111111-1111-1111-1111-111111111111	a00d57c3-c01d-49d0-9166-45e9f7e22497	\N	IN_PREPARATION	\N	\N	2026-09-04 00:42:59.028+05:30	IN_PREPARATION	\N	918df673-2606-403a-9fad-1c54870d1fce
2ba879a9-45ba-407b-bea0-7d2f9fe10918	11111111-1111-1111-1111-111111111111	a00d57c3-c01d-49d0-9166-45e9f7e22497	\N	READY	\N	\N	2026-09-04 00:43:02.237+05:30	READY	\N	918df673-2606-403a-9fad-1c54870d1fce
b7820c80-837f-4afa-8c71-5425f8832214	11111111-1111-1111-1111-111111111111	5583e31e-48a5-435a-936e-aba2f8bb9c9c	\N	READY	\N	\N	2026-09-04 00:43:04.024+05:30	READY	\N	918df673-2606-403a-9fad-1c54870d1fce
1784c613-febc-4c2c-8252-8746de1c8b92	11111111-1111-1111-1111-111111111111	5583e31e-48a5-435a-936e-aba2f8bb9c9c	\N	HANDED_OVER	\N	\N	2026-09-04 00:43:39.268+05:30	HANDED_OVER	\N	918df673-2606-403a-9fad-1c54870d1fce
0d4c7f28-8380-4abf-a786-553951cd19e9	11111111-1111-1111-1111-111111111111	a00d57c3-c01d-49d0-9166-45e9f7e22497	\N	HANDED_OVER	\N	\N	2026-09-04 00:43:46.612+05:30	HANDED_OVER	\N	918df673-2606-403a-9fad-1c54870d1fce
7c34afa3-f670-4913-ab6c-8618237a593a	11111111-1111-1111-1111-111111111111	ece12171-62db-4f53-ba97-d5e93e06f733	\N	PLACED	\N	\N	2026-09-04 01:04:33.336+05:30	PLACED	\N	\N
3d54b326-96ca-47ae-a2a2-20c8015c3eb1	11111111-1111-1111-1111-111111111111	ece12171-62db-4f53-ba97-d5e93e06f733	\N	CONFIRMED	\N	\N	2026-09-04 01:04:33.35+05:30	CONFIRMED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
f103762e-291a-49de-8bfb-efd9569e1585	11111111-1111-1111-1111-111111111111	ece12171-62db-4f53-ba97-d5e93e06f733	\N	KOT_CREATED	\N	\N	2026-09-04 01:04:33.359+05:30	KOT_CREATED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
f1d87800-8b41-48bc-a19c-b89ff2d5d1b2	11111111-1111-1111-1111-111111111111	ece12171-62db-4f53-ba97-d5e93e06f733	\N	IN_PREPARATION	\N	\N	2026-09-04 01:05:38.247+05:30	IN_PREPARATION	\N	918df673-2606-403a-9fad-1c54870d1fce
4dc47d53-4782-4c41-890a-ea1e4feb6a7a	11111111-1111-1111-1111-111111111111	ece12171-62db-4f53-ba97-d5e93e06f733	\N	READY	\N	\N	2026-09-04 01:05:39.083+05:30	READY	\N	918df673-2606-403a-9fad-1c54870d1fce
cca508b9-c7f9-4d09-bd41-3cfcd93a7521	11111111-1111-1111-1111-111111111111	ece12171-62db-4f53-ba97-d5e93e06f733	\N	HANDED_OVER	\N	\N	2026-09-04 01:06:00.084+05:30	HANDED_OVER	\N	918df673-2606-403a-9fad-1c54870d1fce
8bde16a6-a3f8-45a0-992c-dac17c27212b	11111111-1111-1111-1111-111111111111	b5177d27-2e27-4abd-8296-83a748730b2c	\N	PLACED	\N	\N	2026-09-04 01:19:56.503+05:30	PLACED	\N	\N
fdc6aad6-cab9-4f68-a940-0c171b71e630	11111111-1111-1111-1111-111111111111	b5177d27-2e27-4abd-8296-83a748730b2c	\N	CONFIRMED	\N	\N	2026-09-04 01:19:56.522+05:30	CONFIRMED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
dab2bf25-f30f-4c2b-bd0d-b4c8274a88de	11111111-1111-1111-1111-111111111111	b5177d27-2e27-4abd-8296-83a748730b2c	\N	KOT_CREATED	\N	\N	2026-09-04 01:19:56.758+05:30	KOT_CREATED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
2170bac2-8478-47b5-9447-62b08036c3ea	11111111-1111-1111-1111-111111111111	b5177d27-2e27-4abd-8296-83a748730b2c	\N	IN_PREPARATION	\N	\N	2026-09-04 01:19:56.784+05:30	IN_PREPARATION	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
9f531867-6b28-4e4d-96b6-ddc65694497d	11111111-1111-1111-1111-111111111111	b5177d27-2e27-4abd-8296-83a748730b2c	\N	READY	\N	\N	2026-09-04 01:19:56.8+05:30	READY	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
5c129e9b-b9bc-4d95-848e-e8a99beec75a	11111111-1111-1111-1111-111111111111	b5177d27-2e27-4abd-8296-83a748730b2c	\N	SERVED	\N	\N	2026-09-04 01:19:56.817+05:30	SERVED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
3a466fdf-1a79-4cf7-bfe1-04e5f65ebf67	11111111-1111-1111-1111-111111111111	b5177d27-2e27-4abd-8296-83a748730b2c	\N	COMPLETED	\N	\N	2026-09-04 01:19:56.858+05:30	COMPLETED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
f8b74ae0-32ab-4591-900b-343e114fb37f	11111111-1111-1111-1111-111111111111	a00d57c3-c01d-49d0-9166-45e9f7e22497	\N	COMPLETED	\N	\N	2026-09-05 13:22:05.572+05:30	COMPLETED	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06
5c37974a-c368-44b0-8cb4-3147c615e8ef	11111111-1111-1111-1111-111111111111	e7d4d6cf-4838-43bd-8334-688d11302496	\N	PLACED	\N	\N	2026-09-05 14:26:19.06+05:30	PLACED	\N	\N
24cc53ff-3785-42df-9fb8-ee1fa48df4c9	11111111-1111-1111-1111-111111111111	e7d4d6cf-4838-43bd-8334-688d11302496	\N	CONFIRMED	\N	\N	2026-09-05 14:26:19.114+05:30	CONFIRMED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
f9ddd752-f155-4a8b-bd36-848857db736d	11111111-1111-1111-1111-111111111111	e7d4d6cf-4838-43bd-8334-688d11302496	\N	KOT_CREATED	\N	\N	2026-09-05 14:26:19.123+05:30	KOT_CREATED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
6b4fbe84-0582-4655-9f20-d64d4e7f3e08	11111111-1111-1111-1111-111111111111	0f3580d0-cceb-4289-99f8-5ffdf1669b18	\N	PLACED	\N	\N	2026-09-05 15:10:12.599+05:30	PLACED	\N	\N
dcc11e33-7b33-4322-8005-595cefe6356d	11111111-1111-1111-1111-111111111111	0f3580d0-cceb-4289-99f8-5ffdf1669b18	\N	CONFIRMED	\N	\N	2026-09-05 15:10:12.621+05:30	CONFIRMED	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06
8c1668a9-d54e-4c5f-b6bb-5ec5dbb80a84	11111111-1111-1111-1111-111111111111	0f3580d0-cceb-4289-99f8-5ffdf1669b18	\N	KOT_CREATED	\N	\N	2026-09-05 15:10:12.693+05:30	KOT_CREATED	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06
30bbd8b4-7261-4aa9-836b-03b22d23ca07	11111111-1111-1111-1111-111111111111	0f3580d0-cceb-4289-99f8-5ffdf1669b18	\N	IN_PREPARATION	\N	\N	2026-09-05 15:10:12.722+05:30	IN_PREPARATION	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06
cde96f6e-b2f8-446f-bc24-7444ad117df6	11111111-1111-1111-1111-111111111111	0f3580d0-cceb-4289-99f8-5ffdf1669b18	\N	READY	\N	\N	2026-09-05 15:10:12.737+05:30	READY	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06
4444133f-1b84-4235-92c2-a1dc8492e124	11111111-1111-1111-1111-111111111111	0f3580d0-cceb-4289-99f8-5ffdf1669b18	\N	SERVED	\N	\N	2026-09-05 15:10:12.756+05:30	SERVED	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06
8fdaf328-007e-45f5-8867-c1d748526c5f	11111111-1111-1111-1111-111111111111	0f3580d0-cceb-4289-99f8-5ffdf1669b18	\N	COMPLETED	\N	\N	2026-09-05 15:10:12.772+05:30	COMPLETED	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06
e47558ee-0655-4bc9-a442-41dbc4e541a7	11111111-1111-1111-1111-111111111111	c3a366cb-039e-4e26-9cbd-8e22cd2d52b9	\N	PLACED	\N	\N	2026-09-05 16:22:38.191+05:30	PLACED	\N	\N
ea82b643-45eb-4e74-9cae-73e7268b456a	11111111-1111-1111-1111-111111111111	c3a366cb-039e-4e26-9cbd-8e22cd2d52b9	\N	CONFIRMED	\N	\N	2026-09-05 16:22:38.204+05:30	CONFIRMED	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06
1b6cb47f-5280-4550-8764-2f68d6cefe09	11111111-1111-1111-1111-111111111111	c3a366cb-039e-4e26-9cbd-8e22cd2d52b9	\N	KOT_CREATED	\N	\N	2026-09-05 16:22:38.212+05:30	KOT_CREATED	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06
c202546d-bee4-45fc-b0ce-0416b8b8e67d	67315042-c687-4cbb-b45a-f4ea4efc199f	5b433b06-af43-4f62-8a6b-e2ca1e0bfa88	\N	PLACED	\N	\N	2026-09-05 16:45:42.004+05:30	PLACED	\N	\N
afb02990-f265-4019-ae13-65d1dd8608bd	67315042-c687-4cbb-b45a-f4ea4efc199f	5b433b06-af43-4f62-8a6b-e2ca1e0bfa88	\N	CONFIRMED	\N	\N	2026-09-05 16:45:42.018+05:30	CONFIRMED	\N	918df673-2606-403a-9fad-1c54870d1fce
7f6859d5-d7e5-45cd-83e4-604a48870f9b	67315042-c687-4cbb-b45a-f4ea4efc199f	5b433b06-af43-4f62-8a6b-e2ca1e0bfa88	\N	KOT_CREATED	\N	\N	2026-09-05 16:45:42.092+05:30	KOT_CREATED	\N	918df673-2606-403a-9fad-1c54870d1fce
8b78a952-eee3-4f60-9b17-f02ff35844b7	67315042-c687-4cbb-b45a-f4ea4efc199f	5b433b06-af43-4f62-8a6b-e2ca1e0bfa88	\N	IN_PREPARATION	\N	\N	2026-09-05 16:45:42.101+05:30	IN_PREPARATION	\N	918df673-2606-403a-9fad-1c54870d1fce
698bed1b-60c8-40e5-a8e8-b49418efa32d	67315042-c687-4cbb-b45a-f4ea4efc199f	5b433b06-af43-4f62-8a6b-e2ca1e0bfa88	\N	READY	\N	\N	2026-09-05 16:45:42.111+05:30	READY	\N	918df673-2606-403a-9fad-1c54870d1fce
fff32867-9f9a-48d5-9419-a0fe5e23183d	67315042-c687-4cbb-b45a-f4ea4efc199f	5b433b06-af43-4f62-8a6b-e2ca1e0bfa88	\N	SERVED	\N	\N	2026-09-05 16:45:42.12+05:30	SERVED	\N	918df673-2606-403a-9fad-1c54870d1fce
98f3930f-ae89-4d39-b693-548ee42bdb1d	67315042-c687-4cbb-b45a-f4ea4efc199f	5b433b06-af43-4f62-8a6b-e2ca1e0bfa88	\N	COMPLETED	\N	\N	2026-09-05 16:45:42.128+05:30	COMPLETED	\N	918df673-2606-403a-9fad-1c54870d1fce
0d3439e2-f4a3-4e8e-bc0c-a0a0759af5da	11111111-1111-1111-1111-111111111111	7a369854-faf1-4af3-8378-8b939249c434	\N	PLACED	\N	\N	2026-09-05 16:51:32.718+05:30	PLACED	\N	\N
64a89e28-7d1e-4914-a2f1-3c84eace86e0	11111111-1111-1111-1111-111111111111	7a369854-faf1-4af3-8378-8b939249c434	\N	CONFIRMED	\N	\N	2026-09-05 16:51:32.733+05:30	CONFIRMED	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06
2ccf6d5b-72d5-465a-9db1-30197fba70f7	11111111-1111-1111-1111-111111111111	7a369854-faf1-4af3-8378-8b939249c434	\N	KOT_CREATED	\N	\N	2026-09-05 16:51:32.807+05:30	KOT_CREATED	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06
4df22435-9957-466a-911a-f76dc04e5576	11111111-1111-1111-1111-111111111111	7a369854-faf1-4af3-8378-8b939249c434	\N	IN_PREPARATION	\N	\N	2026-09-05 16:51:32.827+05:30	IN_PREPARATION	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06
e41dbb16-7a97-4e73-9020-87f4ab3c71c0	11111111-1111-1111-1111-111111111111	7a369854-faf1-4af3-8378-8b939249c434	\N	READY	\N	\N	2026-09-05 16:51:32.839+05:30	READY	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06
3b01358f-7582-4400-a2b3-20bc5c7e9172	11111111-1111-1111-1111-111111111111	7a369854-faf1-4af3-8378-8b939249c434	\N	SERVED	\N	\N	2026-09-05 16:51:32.848+05:30	SERVED	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06
15e402d9-abba-4da1-a26e-17c2538e7fcc	11111111-1111-1111-1111-111111111111	7a369854-faf1-4af3-8378-8b939249c434	\N	COMPLETED	\N	\N	2026-09-05 16:51:32.858+05:30	COMPLETED	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06
2204d43e-b645-4243-983c-762e8b852ba6	11111111-1111-1111-1111-111111111111	82e2a068-a74a-4e18-89fe-7a423f5b243f	\N	PLACED	\N	\N	2026-09-05 17:05:54.962+05:30	PLACED	\N	\N
e48d0f2e-e342-4a02-901b-9f86eb4cb46f	11111111-1111-1111-1111-111111111111	82e2a068-a74a-4e18-89fe-7a423f5b243f	\N	CONFIRMED	\N	\N	2026-09-05 17:05:54.979+05:30	CONFIRMED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
75c39838-ed90-47c1-bca8-da3f0f519715	11111111-1111-1111-1111-111111111111	82e2a068-a74a-4e18-89fe-7a423f5b243f	\N	KOT_CREATED	\N	\N	2026-09-05 17:05:54.987+05:30	KOT_CREATED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
dc210a1a-c428-46be-a7cb-6fd23291ab22	11111111-1111-1111-1111-111111111111	82e2a068-a74a-4e18-89fe-7a423f5b243f	\N	IN_PREPARATION	\N	\N	2026-09-05 17:14:44.706+05:30	IN_PREPARATION	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06
bd8c265a-105d-464b-9d94-3d5857ac8d9e	11111111-1111-1111-1111-111111111111	82e2a068-a74a-4e18-89fe-7a423f5b243f	\N	READY	\N	\N	2026-09-05 17:14:44.721+05:30	READY	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06
68fa4ec4-3b0c-42c0-960c-62252d78aaec	11111111-1111-1111-1111-111111111111	82e2a068-a74a-4e18-89fe-7a423f5b243f	\N	SERVED	\N	\N	2026-09-05 17:14:44.73+05:30	SERVED	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06
04628a00-dbb3-4fd6-99f9-b7e0c7808e9f	11111111-1111-1111-1111-111111111111	82e2a068-a74a-4e18-89fe-7a423f5b243f	\N	COMPLETED	\N	\N	2026-09-05 17:14:44.747+05:30	COMPLETED	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06
b21d1676-bbba-4082-b9c2-c2057fb650ca	11111111-1111-1111-1111-111111111111	1085cebe-ebf0-4804-83f3-aae6d0d4a7c9	\N	PLACED	\N	\N	2026-09-08 11:05:04.346+05:30	PLACED	\N	\N
656fda76-b591-4330-8287-e60b4034d4ca	11111111-1111-1111-1111-111111111111	1085cebe-ebf0-4804-83f3-aae6d0d4a7c9	\N	CONFIRMED	\N	\N	2026-09-08 11:05:04.389+05:30	CONFIRMED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
dcc39d7d-a31c-4187-9315-18c596b29cac	11111111-1111-1111-1111-111111111111	1085cebe-ebf0-4804-83f3-aae6d0d4a7c9	\N	KOT_CREATED	\N	\N	2026-09-08 11:05:04.398+05:30	KOT_CREATED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
a36e089a-2624-49d5-a3a7-376b31272153	11111111-1111-1111-1111-111111111111	eb13fd97-c972-4447-8a42-898eb545191e	\N	PLACED	\N	\N	2026-09-08 13:13:14.884+05:30	PLACED	\N	\N
53af35cd-66c0-4300-bc2f-7ba7a98f6a2d	11111111-1111-1111-1111-111111111111	eb13fd97-c972-4447-8a42-898eb545191e	\N	CONFIRMED	\N	\N	2026-09-08 13:13:14.899+05:30	CONFIRMED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
147bf640-3650-4306-a1dd-9510b24710da	11111111-1111-1111-1111-111111111111	eb13fd97-c972-4447-8a42-898eb545191e	\N	KOT_CREATED	\N	\N	2026-09-08 13:13:14.909+05:30	KOT_CREATED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
6e9c1493-d717-48f5-8405-052a6c512283	11111111-1111-1111-1111-111111111111	f5d3449d-ce21-48cb-ab01-b41c41a7301c	\N	PLACED	\N	\N	2026-09-08 13:14:15.253+05:30	PLACED	\N	\N
5bf615c1-bb9a-44f3-893a-8d71326e9e4f	11111111-1111-1111-1111-111111111111	f5d3449d-ce21-48cb-ab01-b41c41a7301c	\N	CONFIRMED	\N	\N	2026-09-08 13:14:15.275+05:30	CONFIRMED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
2509ea42-2a16-4e99-b364-37dae9c27af6	11111111-1111-1111-1111-111111111111	f5d3449d-ce21-48cb-ab01-b41c41a7301c	\N	KOT_CREATED	\N	\N	2026-09-08 13:14:15.286+05:30	KOT_CREATED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
492af723-6808-403c-a2a7-6c93601866dc	11111111-1111-1111-1111-111111111111	b101f725-9679-4cf3-9f0f-16adb200ecff	\N	PLACED	\N	\N	2026-09-08 14:27:24.418+05:30	PLACED	\N	\N
3b48f9a1-f2d6-4772-90a6-909348fcf7e6	11111111-1111-1111-1111-111111111111	b101f725-9679-4cf3-9f0f-16adb200ecff	\N	CONFIRMED	\N	\N	2026-09-08 14:27:24.437+05:30	CONFIRMED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
c91c0acc-005d-40d1-886b-97777b415549	11111111-1111-1111-1111-111111111111	b101f725-9679-4cf3-9f0f-16adb200ecff	\N	KOT_CREATED	\N	\N	2026-09-08 14:27:24.447+05:30	KOT_CREATED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
40556479-2c32-45fa-bb5c-f2b40f497c4b	11111111-1111-1111-1111-111111111111	b101f725-9679-4cf3-9f0f-16adb200ecff	\N	IN_PREPARATION	\N	\N	2026-09-08 14:28:38.835+05:30	IN_PREPARATION	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
023f89c7-235e-4093-9ae5-d776acd35270	11111111-1111-1111-1111-111111111111	b101f725-9679-4cf3-9f0f-16adb200ecff	\N	READY	\N	\N	2026-09-08 14:39:21.438+05:30	READY	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
0243cb4a-904f-4b22-baec-feae6bfafcdc	11111111-1111-1111-1111-111111111111	b101f725-9679-4cf3-9f0f-16adb200ecff	\N	HANDED_OVER	\N	\N	2026-09-08 14:39:22.785+05:30	HANDED_OVER	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
142ad389-6a38-4410-8e5f-560f7e1e4961	11111111-1111-1111-1111-111111111111	685aa7a6-e1d4-4a39-a7fe-c54252180927	\N	PLACED	\N	\N	2026-09-08 14:41:53.567+05:30	PLACED	\N	\N
f4dcc9c0-fd59-49c0-8fd6-90a85e1c1870	11111111-1111-1111-1111-111111111111	685aa7a6-e1d4-4a39-a7fe-c54252180927	\N	CONFIRMED	\N	\N	2026-09-08 14:41:53.581+05:30	CONFIRMED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
7a308bd6-e62a-4a36-8bdf-866d095f24ff	11111111-1111-1111-1111-111111111111	685aa7a6-e1d4-4a39-a7fe-c54252180927	\N	KOT_CREATED	\N	\N	2026-09-08 14:41:53.591+05:30	KOT_CREATED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
bf017024-48e1-48b3-8543-69ccb3758cd2	11111111-1111-1111-1111-111111111111	685aa7a6-e1d4-4a39-a7fe-c54252180927	\N	IN_PREPARATION	\N	\N	2026-09-08 14:42:51.409+05:30	IN_PREPARATION	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
7fb04791-31c0-4441-b860-032a531b960c	11111111-1111-1111-1111-111111111111	685aa7a6-e1d4-4a39-a7fe-c54252180927	\N	READY	\N	\N	2026-09-08 14:43:25.789+05:30	READY	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
985db58c-1d3a-4cd6-b397-ab4a68d7c209	11111111-1111-1111-1111-111111111111	685aa7a6-e1d4-4a39-a7fe-c54252180927	\N	HANDED_OVER	\N	\N	2026-09-08 14:44:38.666+05:30	HANDED_OVER	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
def42a77-baed-4d12-85a6-e32b79dd95f3	11111111-1111-1111-1111-111111111111	76692730-cd05-45cd-b8ad-9cc20ac9fc5a	\N	PLACED	\N	\N	2026-09-08 15:13:45.044+05:30	PLACED	\N	\N
6deaa323-e43e-4934-b273-0d2e54f6c3b9	11111111-1111-1111-1111-111111111111	76692730-cd05-45cd-b8ad-9cc20ac9fc5a	\N	CONFIRMED	\N	\N	2026-09-08 15:13:45.065+05:30	CONFIRMED	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06
79d6e926-1a7f-4f61-ac67-35f5ccd73152	11111111-1111-1111-1111-111111111111	76692730-cd05-45cd-b8ad-9cc20ac9fc5a	\N	KOT_CREATED	\N	\N	2026-09-08 15:13:45.08+05:30	KOT_CREATED	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06
e1614fc8-674e-4fd0-929d-bb18dbca6597	11111111-1111-1111-1111-111111111111	76692730-cd05-45cd-b8ad-9cc20ac9fc5a	\N	IN_PREPARATION	\N	\N	2026-09-08 15:14:17.136+05:30	IN_PREPARATION	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06
4e0b1bf8-2dbb-4789-945b-562b86e7bd09	11111111-1111-1111-1111-111111111111	f5d3449d-ce21-48cb-ab01-b41c41a7301c	\N	IN_PREPARATION	\N	\N	2026-09-08 16:19:40.892+05:30	IN_PREPARATION	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
a6ce0caa-b067-43a8-9063-0bca5ccf7653	11111111-1111-1111-1111-111111111111	f5d3449d-ce21-48cb-ab01-b41c41a7301c	\N	READY	\N	\N	2026-09-08 16:19:41.77+05:30	READY	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
5d751d63-cd6d-4c3f-b34f-051e8e7fe2e6	11111111-1111-1111-1111-111111111111	f5d3449d-ce21-48cb-ab01-b41c41a7301c	\N	HANDED_OVER	\N	\N	2026-09-08 16:19:42.475+05:30	HANDED_OVER	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
1647b4f6-a405-41ac-bacf-fb3bc2d3e54b	11111111-1111-1111-1111-111111111111	76692730-cd05-45cd-b8ad-9cc20ac9fc5a	\N	READY	\N	\N	2026-09-09 12:45:15.083+05:30	READY	\N	918df673-2606-403a-9fad-1c54870d1fce
a0d6f4af-6b12-4c36-bb07-dd3eab607fdc	11111111-1111-1111-1111-111111111111	76692730-cd05-45cd-b8ad-9cc20ac9fc5a	\N	HANDED_OVER	\N	\N	2026-09-09 12:45:15.907+05:30	HANDED_OVER	\N	918df673-2606-403a-9fad-1c54870d1fce
4c77123b-c52a-4857-8e8b-04700babf2b3	11111111-1111-1111-1111-111111111111	0602cb47-3398-4ba0-b5da-87e23909efa3	\N	PLACED	\N	\N	2026-09-09 12:47:30.745+05:30	PLACED	\N	\N
34e4c8d6-6136-4cf8-b98f-4aec524fb7a6	11111111-1111-1111-1111-111111111111	0602cb47-3398-4ba0-b5da-87e23909efa3	\N	CONFIRMED	\N	\N	2026-09-09 12:47:30.762+05:30	CONFIRMED	\N	918df673-2606-403a-9fad-1c54870d1fce
17373a86-102b-4468-9b28-a317e455a6b3	11111111-1111-1111-1111-111111111111	0602cb47-3398-4ba0-b5da-87e23909efa3	\N	KOT_CREATED	\N	\N	2026-09-09 12:47:30.773+05:30	KOT_CREATED	\N	918df673-2606-403a-9fad-1c54870d1fce
739f94b3-97c1-44d9-a128-bbaa0eac51c3	11111111-1111-1111-1111-111111111111	2d4b655e-a5bf-4900-ba0c-11e1b3c2685c	\N	PLACED	\N	\N	2026-09-09 12:51:14.242+05:30	PLACED	\N	\N
8b24e10f-c96f-44a9-b829-5b89b76200a3	11111111-1111-1111-1111-111111111111	2d4b655e-a5bf-4900-ba0c-11e1b3c2685c	\N	CONFIRMED	\N	\N	2026-09-09 12:51:14.252+05:30	CONFIRMED	\N	918df673-2606-403a-9fad-1c54870d1fce
ac34594f-f7ad-4f88-8853-49b03ff700c2	11111111-1111-1111-1111-111111111111	2d4b655e-a5bf-4900-ba0c-11e1b3c2685c	\N	KOT_CREATED	\N	\N	2026-09-09 12:51:14.262+05:30	KOT_CREATED	\N	918df673-2606-403a-9fad-1c54870d1fce
b7e14753-5bf1-4bbc-b0a8-55d098d8cef0	11111111-1111-1111-1111-111111111111	f973888e-e429-473a-8566-ddea7ac708a0	\N	PLACED	\N	\N	2026-09-09 12:52:31.649+05:30	PLACED	\N	\N
a8aa12fe-b207-4cfd-bfc3-1cffef71947e	11111111-1111-1111-1111-111111111111	f973888e-e429-473a-8566-ddea7ac708a0	\N	CONFIRMED	\N	\N	2026-09-09 12:52:31.662+05:30	CONFIRMED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
736e86ec-5a07-4b35-9e2d-766b5a459583	11111111-1111-1111-1111-111111111111	f973888e-e429-473a-8566-ddea7ac708a0	\N	KOT_CREATED	\N	\N	2026-09-09 12:52:31.67+05:30	KOT_CREATED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
7148ff70-506d-4c38-aa17-e64899f18cd4	11111111-1111-1111-1111-111111111111	190ec2cb-fb90-44c2-ad76-b32672063fdb	\N	PLACED	\N	\N	2026-09-09 13:01:25.169+05:30	PLACED	\N	\N
98b6ad9b-513a-405e-a42c-457fc6621106	11111111-1111-1111-1111-111111111111	190ec2cb-fb90-44c2-ad76-b32672063fdb	\N	CONFIRMED	\N	\N	2026-09-09 13:01:25.183+05:30	CONFIRMED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
61a06a52-798c-4e4a-8da2-e842bba54a1f	11111111-1111-1111-1111-111111111111	190ec2cb-fb90-44c2-ad76-b32672063fdb	\N	KOT_CREATED	\N	\N	2026-09-09 13:01:25.194+05:30	KOT_CREATED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
64ff8d99-39d8-47ae-8276-51ee9353c018	11111111-1111-1111-1111-111111111111	4e192b03-6942-454a-a9dd-9084d99362b1	\N	PLACED	\N	\N	2026-09-09 13:02:02.204+05:30	PLACED	\N	\N
dff576d1-4f0c-433d-876e-5e56b8c7c585	11111111-1111-1111-1111-111111111111	4e192b03-6942-454a-a9dd-9084d99362b1	\N	CONFIRMED	\N	\N	2026-09-09 13:02:02.221+05:30	CONFIRMED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
967fa5a4-61f3-4875-890f-f4439c57e697	11111111-1111-1111-1111-111111111111	4e192b03-6942-454a-a9dd-9084d99362b1	\N	KOT_CREATED	\N	\N	2026-09-09 13:02:02.23+05:30	KOT_CREATED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
e32d53b3-55ee-496e-a8ac-88afb6f213b8	11111111-1111-1111-1111-111111111111	9528cbcc-5873-41a3-b142-53165932bc70	\N	PLACED	\N	\N	2026-09-09 13:02:03.724+05:30	PLACED	\N	\N
df5b2076-9c41-47c0-b060-5578b6a18d5b	11111111-1111-1111-1111-111111111111	9528cbcc-5873-41a3-b142-53165932bc70	\N	CONFIRMED	\N	\N	2026-09-09 13:02:03.738+05:30	CONFIRMED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
a7b37a67-3e89-4936-b1c7-f2a29b9612d6	11111111-1111-1111-1111-111111111111	9528cbcc-5873-41a3-b142-53165932bc70	\N	KOT_CREATED	\N	\N	2026-09-09 13:02:03.749+05:30	KOT_CREATED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
7c9f56c3-6b90-4a23-886a-e244fed93203	11111111-1111-1111-1111-111111111111	39f6e5e8-3eb1-4100-a8cc-4dfcb49ba060	\N	PLACED	\N	\N	2026-09-09 13:03:37.825+05:30	PLACED	\N	\N
7d766da7-d014-4896-813c-7c8e719ac89a	11111111-1111-1111-1111-111111111111	39f6e5e8-3eb1-4100-a8cc-4dfcb49ba060	\N	CONFIRMED	\N	\N	2026-09-09 13:03:37.841+05:30	CONFIRMED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
d6b3a398-a561-4d56-be42-7e6a0c09e1ee	11111111-1111-1111-1111-111111111111	39f6e5e8-3eb1-4100-a8cc-4dfcb49ba060	\N	KOT_CREATED	\N	\N	2026-09-09 13:03:37.852+05:30	KOT_CREATED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
a34b25c3-508b-40f8-8dbe-12465e67bf3a	11111111-1111-1111-1111-111111111111	118a762d-2cc4-4b94-b0c6-1b7360cd6652	\N	PLACED	\N	\N	2026-09-09 13:03:39.362+05:30	PLACED	\N	\N
b355a5d4-4129-4fa1-a028-a9ef52170868	11111111-1111-1111-1111-111111111111	118a762d-2cc4-4b94-b0c6-1b7360cd6652	\N	CONFIRMED	\N	\N	2026-09-09 13:03:39.373+05:30	CONFIRMED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
7568e33a-b330-44c8-b204-402af3b268f9	11111111-1111-1111-1111-111111111111	118a762d-2cc4-4b94-b0c6-1b7360cd6652	\N	KOT_CREATED	\N	\N	2026-09-09 13:03:39.384+05:30	KOT_CREATED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
c48d921c-c88f-4869-838f-6b2120e9d854	11111111-1111-1111-1111-111111111111	2d4b655e-a5bf-4900-ba0c-11e1b3c2685c	\N	IN_PREPARATION	\N	\N	2026-09-09 14:06:01.034+05:30	IN_PREPARATION	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
6669e726-de31-48f0-9024-72ef536e3930	11111111-1111-1111-1111-111111111111	2d4b655e-a5bf-4900-ba0c-11e1b3c2685c	\N	READY	\N	\N	2026-09-09 14:06:01.052+05:30	READY	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
a9ab81c7-abb6-4a7d-a3a7-2554080e8389	11111111-1111-1111-1111-111111111111	2d4b655e-a5bf-4900-ba0c-11e1b3c2685c	\N	SERVED	\N	\N	2026-09-09 14:06:01.062+05:30	SERVED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
1063b8c2-bb71-4e8e-9764-517c82752317	11111111-1111-1111-1111-111111111111	2d4b655e-a5bf-4900-ba0c-11e1b3c2685c	\N	COMPLETED	\N	\N	2026-09-09 14:06:01.077+05:30	COMPLETED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
392c1f6c-65ba-4673-93ab-4b6534b60657	11111111-1111-1111-1111-111111111111	eb13fd97-c972-4447-8a42-898eb545191e	\N	IN_PREPARATION	\N	\N	2026-09-09 14:07:07.533+05:30	IN_PREPARATION	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
489995c6-b6d3-4420-a29e-d0451b29e440	11111111-1111-1111-1111-111111111111	eb13fd97-c972-4447-8a42-898eb545191e	\N	READY	\N	\N	2026-09-09 14:07:07.551+05:30	READY	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
0a08b934-88ca-4874-a456-86fe79ae890b	11111111-1111-1111-1111-111111111111	eb13fd97-c972-4447-8a42-898eb545191e	\N	SERVED	\N	\N	2026-09-09 14:07:07.561+05:30	SERVED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
8a3a2372-8b9f-4396-9810-25ba5dd5c703	11111111-1111-1111-1111-111111111111	eb13fd97-c972-4447-8a42-898eb545191e	\N	COMPLETED	\N	\N	2026-09-09 14:07:07.58+05:30	COMPLETED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
6cf3bb94-6b35-4887-b208-a2bc7045a0f7	11111111-1111-1111-1111-111111111111	f5d3449d-ce21-48cb-ab01-b41c41a7301c	\N	COMPLETED	\N	\N	2026-09-09 14:07:29.921+05:30	COMPLETED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
d1e1076c-b1f1-48d5-b2d3-1aca53981b2f	11111111-1111-1111-1111-111111111111	0a746ebb-ff2b-40d1-8d00-5e7652f56006	\N	PLACED	\N	\N	2026-09-09 14:27:26.164+05:30	PLACED	\N	\N
81f7b72f-8c03-4141-bf95-5eae62b2eaa9	11111111-1111-1111-1111-111111111111	0a746ebb-ff2b-40d1-8d00-5e7652f56006	\N	CONFIRMED	\N	\N	2026-09-09 14:27:26.182+05:30	CONFIRMED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
3164b294-e01e-4023-b82e-7ee58692e712	11111111-1111-1111-1111-111111111111	0a746ebb-ff2b-40d1-8d00-5e7652f56006	\N	KOT_CREATED	\N	\N	2026-09-09 14:27:26.193+05:30	KOT_CREATED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
ec7f3032-8e04-4a93-8570-ab67cf0511a1	11111111-1111-1111-1111-111111111111	c182470d-5000-40bc-86f8-b9093c4333e8	\N	PLACED	\N	\N	2026-09-09 14:27:33.553+05:30	PLACED	\N	\N
35594157-870f-420c-a188-f5b6faf09068	11111111-1111-1111-1111-111111111111	c182470d-5000-40bc-86f8-b9093c4333e8	\N	CONFIRMED	\N	\N	2026-09-09 14:27:33.871+05:30	CONFIRMED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
7c96203e-3b67-4b4f-a1a8-f57ee8eef2e4	11111111-1111-1111-1111-111111111111	c182470d-5000-40bc-86f8-b9093c4333e8	\N	KOT_CREATED	\N	\N	2026-09-09 14:27:33.887+05:30	KOT_CREATED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
42a173af-aaa8-4ac8-96c9-f491520eec7f	11111111-1111-1111-1111-111111111111	482d35cd-b7b6-4c65-a7f3-943897646bad	\N	PLACED	\N	\N	2026-09-09 14:28:57.8+05:30	PLACED	\N	\N
7f3ebb99-2c82-442f-888d-4891d1654d22	11111111-1111-1111-1111-111111111111	482d35cd-b7b6-4c65-a7f3-943897646bad	\N	CONFIRMED	\N	\N	2026-09-09 14:28:58.336+05:30	CONFIRMED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
5d3a53d3-e01f-4e4c-bfe9-d694a448b10c	11111111-1111-1111-1111-111111111111	482d35cd-b7b6-4c65-a7f3-943897646bad	\N	KOT_CREATED	\N	\N	2026-09-09 14:28:58.355+05:30	KOT_CREATED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
7b41b6b8-562a-4121-9df2-eb268c0f9213	11111111-1111-1111-1111-111111111111	25ab98b4-6057-4986-a634-4dd7dc5f51bc	\N	PLACED	\N	\N	2026-09-09 14:29:43.209+05:30	PLACED	\N	\N
2615b2c0-74bb-439b-8e95-cf17f4c55087	11111111-1111-1111-1111-111111111111	25ab98b4-6057-4986-a634-4dd7dc5f51bc	\N	CONFIRMED	\N	\N	2026-09-09 14:29:43.517+05:30	CONFIRMED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
094cad7c-a9c0-4f70-8f85-d93f86b53a70	11111111-1111-1111-1111-111111111111	25ab98b4-6057-4986-a634-4dd7dc5f51bc	\N	KOT_CREATED	\N	\N	2026-09-09 14:29:43.538+05:30	KOT_CREATED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
ee43ec06-d02d-466f-b3b1-76e1a2186cdb	11111111-1111-1111-1111-111111111111	65505588-f509-44ef-a6c6-c488503dcbe3	\N	PLACED	\N	\N	2026-09-09 14:31:14.465+05:30	PLACED	\N	\N
6dc21da3-5fd9-4218-9b1f-d1c717d2eca0	11111111-1111-1111-1111-111111111111	65505588-f509-44ef-a6c6-c488503dcbe3	\N	CONFIRMED	\N	\N	2026-09-09 14:31:14.651+05:30	CONFIRMED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
84859367-d4ad-4c7a-b61f-51f2b33246ee	11111111-1111-1111-1111-111111111111	65505588-f509-44ef-a6c6-c488503dcbe3	\N	KOT_CREATED	\N	\N	2026-09-09 14:31:14.664+05:30	KOT_CREATED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
516e3a50-5203-4c9d-8b5f-c98458190dc0	11111111-1111-1111-1111-111111111111	b6abe3e6-d0e7-4dc7-a631-097181effc3a	\N	PLACED	\N	\N	2026-09-09 14:31:59.211+05:30	PLACED	\N	\N
257e72a7-5cbd-4704-bb7e-d554361b6402	11111111-1111-1111-1111-111111111111	b6abe3e6-d0e7-4dc7-a631-097181effc3a	\N	CONFIRMED	\N	\N	2026-09-09 14:31:59.353+05:30	CONFIRMED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
d9873095-9f41-4a33-a211-1a4938a4e2b4	11111111-1111-1111-1111-111111111111	b6abe3e6-d0e7-4dc7-a631-097181effc3a	\N	KOT_CREATED	\N	\N	2026-09-09 14:31:59.367+05:30	KOT_CREATED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
aeb61eef-1139-4e20-85de-309ae7c04f68	11111111-1111-1111-1111-111111111111	d71091c4-71f0-4c75-bd38-c6b08ba4dd4a	\N	PLACED	\N	\N	2026-09-09 14:32:48.248+05:30	PLACED	\N	\N
cc4ae1a1-5a48-4f39-98f6-8da57028816e	11111111-1111-1111-1111-111111111111	d71091c4-71f0-4c75-bd38-c6b08ba4dd4a	\N	CONFIRMED	\N	\N	2026-09-09 14:32:48.87+05:30	CONFIRMED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
f2db5338-6121-4435-a377-5c09de93c616	11111111-1111-1111-1111-111111111111	d71091c4-71f0-4c75-bd38-c6b08ba4dd4a	\N	KOT_CREATED	\N	\N	2026-09-09 14:32:48.895+05:30	KOT_CREATED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
8bcfc684-27fc-448f-bb1c-6c28c11dcec2	11111111-1111-1111-1111-111111111111	d1467f47-4869-4592-996e-0d3f373ec018	\N	PLACED	\N	\N	2026-09-09 14:34:00.909+05:30	PLACED	\N	\N
1127686d-db7c-485f-b861-4375d441aa47	11111111-1111-1111-1111-111111111111	d1467f47-4869-4592-996e-0d3f373ec018	\N	CONFIRMED	\N	\N	2026-09-09 14:34:01.467+05:30	CONFIRMED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
85e50914-13b8-4256-a9d4-a4053bc5a0af	11111111-1111-1111-1111-111111111111	d1467f47-4869-4592-996e-0d3f373ec018	\N	KOT_CREATED	\N	\N	2026-09-09 14:34:01.498+05:30	KOT_CREATED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
f6722f47-ac98-44cb-9095-847161557acf	11111111-1111-1111-1111-111111111111	0a746ebb-ff2b-40d1-8d00-5e7652f56006	\N	IN_PREPARATION	\N	\N	2026-09-09 15:08:54.296+05:30	IN_PREPARATION	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
16f4646a-48a3-4f97-a3d4-1f861712b4a9	11111111-1111-1111-1111-111111111111	0a746ebb-ff2b-40d1-8d00-5e7652f56006	\N	READY	\N	\N	2026-09-09 15:08:54.328+05:30	READY	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
348d19fb-cc9e-4b55-a86d-52e532e71c35	11111111-1111-1111-1111-111111111111	0a746ebb-ff2b-40d1-8d00-5e7652f56006	\N	SERVED	\N	\N	2026-09-09 15:08:54.343+05:30	SERVED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
61621e83-d5c9-424a-ac71-7e1c249ed0ed	11111111-1111-1111-1111-111111111111	0a746ebb-ff2b-40d1-8d00-5e7652f56006	\N	COMPLETED	\N	\N	2026-09-09 15:08:54.359+05:30	COMPLETED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
1adc1bca-4563-4dd6-9c9c-f18737a7e865	11111111-1111-1111-1111-111111111111	3e1ba9c8-0311-4534-a8d3-fa97b3a4f933	\N	PLACED	\N	\N	2026-09-09 15:09:20.348+05:30	PLACED	\N	\N
58e92025-fc7b-4273-8c38-47edeb1b44fd	11111111-1111-1111-1111-111111111111	3e1ba9c8-0311-4534-a8d3-fa97b3a4f933	\N	CONFIRMED	\N	\N	2026-09-09 15:09:20.365+05:30	CONFIRMED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
3c5d640f-67c9-4cc9-9501-efa76d67ee9c	11111111-1111-1111-1111-111111111111	3e1ba9c8-0311-4534-a8d3-fa97b3a4f933	\N	KOT_CREATED	\N	\N	2026-09-09 15:09:20.373+05:30	KOT_CREATED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
59b13c1f-4c75-4d72-a952-0655c0077855	11111111-1111-1111-1111-111111111111	3e1ba9c8-0311-4534-a8d3-fa97b3a4f933	\N	IN_PREPARATION	\N	\N	2026-09-10 16:51:30.53+05:30	IN_PREPARATION	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
6f0dc7ae-b85b-46f1-a12f-02850bdbd46f	11111111-1111-1111-1111-111111111111	3e1ba9c8-0311-4534-a8d3-fa97b3a4f933	\N	READY	\N	\N	2026-09-10 16:52:24.523+05:30	READY	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
9f53d203-d504-42a7-85a0-8b0d1b63d1cb	11111111-1111-1111-1111-111111111111	3e1ba9c8-0311-4534-a8d3-fa97b3a4f933	\N	SERVED	\N	\N	2026-09-10 16:52:36.095+05:30	SERVED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
7e246bc7-384c-4984-ac2c-8205b6115a89	11111111-1111-1111-1111-111111111111	65505588-f509-44ef-a6c6-c488503dcbe3	\N	IN_PREPARATION	\N	\N	2026-09-11 11:10:01.571+05:30	IN_PREPARATION	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
6a225768-03ce-4b94-9d2f-85eb1900127c	11111111-1111-1111-1111-111111111111	65505588-f509-44ef-a6c6-c488503dcbe3	\N	READY	\N	\N	2026-09-11 11:10:03.245+05:30	READY	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
abbcc8c2-f67f-4d57-bdc4-2eb5c757f708	11111111-1111-1111-1111-111111111111	65505588-f509-44ef-a6c6-c488503dcbe3	\N	HANDED_OVER	\N	\N	2026-09-11 11:10:05.993+05:30	HANDED_OVER	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
7e6bc4cf-4572-4eea-960e-6060b877d1ca	11111111-1111-1111-1111-111111111111	c182470d-5000-40bc-86f8-b9093c4333e8	\N	IN_PREPARATION	\N	\N	2026-09-11 11:10:07.885+05:30	IN_PREPARATION	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
e9c5a7e5-bc07-4e20-a223-36014cf2017e	11111111-1111-1111-1111-111111111111	c182470d-5000-40bc-86f8-b9093c4333e8	\N	READY	\N	\N	2026-09-11 11:10:10.807+05:30	READY	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
e9ebc523-eb3a-40c7-8670-74260cb57b9f	11111111-1111-1111-1111-111111111111	c182470d-5000-40bc-86f8-b9093c4333e8	\N	HANDED_OVER	\N	\N	2026-09-11 11:10:15.609+05:30	HANDED_OVER	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
5e1b2320-90ab-4f9d-9cc6-1a5d8ddce9f7	11111111-1111-1111-1111-111111111111	b6abe3e6-d0e7-4dc7-a631-097181effc3a	\N	IN_PREPARATION	\N	\N	2026-09-11 11:10:41.331+05:30	IN_PREPARATION	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
f4337777-dcef-4cbb-bde8-3fe47c52495d	11111111-1111-1111-1111-111111111111	b6abe3e6-d0e7-4dc7-a631-097181effc3a	\N	READY	\N	\N	2026-09-11 11:10:42.068+05:30	READY	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
a541fbab-b833-4233-bee5-65139b3de9d4	11111111-1111-1111-1111-111111111111	b6abe3e6-d0e7-4dc7-a631-097181effc3a	\N	HANDED_OVER	\N	\N	2026-09-11 11:10:55.596+05:30	HANDED_OVER	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
873e3a93-c74e-4f54-ba7f-dc6d0619b6cc	11111111-1111-1111-1111-111111111111	27f9f630-3e8b-4ba9-b4d7-e631e45182f7	\N	PLACED	\N	\N	2026-09-11 12:09:46.326+05:30	PLACED	\N	\N
44e895ca-678d-46cf-8c6f-32e0618fdd3f	11111111-1111-1111-1111-111111111111	27f9f630-3e8b-4ba9-b4d7-e631e45182f7	\N	CONFIRMED	\N	\N	2026-09-11 12:09:46.342+05:30	CONFIRMED	\N	5c660c1f-f5f8-4007-87a6-b4b39913998b
a732533c-d5ec-4dac-ae62-f1f42de58994	11111111-1111-1111-1111-111111111111	27f9f630-3e8b-4ba9-b4d7-e631e45182f7	\N	KOT_CREATED	\N	\N	2026-09-11 12:09:46.349+05:30	KOT_CREATED	\N	5c660c1f-f5f8-4007-87a6-b4b39913998b
d24734e3-749c-4d0e-bb85-44ac2a559796	11111111-1111-1111-1111-111111111111	c8387bcf-ab67-44bb-87fb-d67f6d7601ca	\N	PLACED	\N	\N	2026-09-11 12:33:27.213+05:30	PLACED	\N	\N
f78abac1-ae45-49e7-8452-6c5ff88a14b2	11111111-1111-1111-1111-111111111111	c8387bcf-ab67-44bb-87fb-d67f6d7601ca	\N	CONFIRMED	\N	\N	2026-09-11 12:33:27.23+05:30	CONFIRMED	\N	5c660c1f-f5f8-4007-87a6-b4b39913998b
4c0017a8-6930-40b6-a63d-e1b926b2ca9a	11111111-1111-1111-1111-111111111111	c8387bcf-ab67-44bb-87fb-d67f6d7601ca	\N	KOT_CREATED	\N	\N	2026-09-11 12:33:27.238+05:30	KOT_CREATED	\N	5c660c1f-f5f8-4007-87a6-b4b39913998b
3b1c478e-90d2-4aca-8dcc-460fd475cf73	11111111-1111-1111-1111-111111111111	d8d53271-b231-47e9-93aa-7a47185f8940	\N	PLACED	\N	\N	2026-09-11 12:59:30.568+05:30	PLACED	\N	\N
67830371-2ec1-499a-b8ae-e8041be5f2f0	11111111-1111-1111-1111-111111111111	d8d53271-b231-47e9-93aa-7a47185f8940	\N	CONFIRMED	\N	\N	2026-09-11 12:59:30.586+05:30	CONFIRMED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
9355f2bd-f9de-43eb-ab83-e1d0e32c614b	11111111-1111-1111-1111-111111111111	d8d53271-b231-47e9-93aa-7a47185f8940	\N	KOT_CREATED	\N	\N	2026-09-11 12:59:30.607+05:30	KOT_CREATED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
b605d6dd-de45-4150-8ae7-99bc3acddebd	11111111-1111-1111-1111-111111111111	ccffe940-9f6b-41af-aaeb-72b3e1cdb3da	\N	PLACED	\N	\N	2026-09-11 12:59:52.787+05:30	PLACED	\N	\N
89d0c947-4741-48b3-988f-907cc6cd4916	11111111-1111-1111-1111-111111111111	ccffe940-9f6b-41af-aaeb-72b3e1cdb3da	\N	CONFIRMED	\N	\N	2026-09-11 12:59:52.802+05:30	CONFIRMED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
feb90153-17e3-4c82-84ed-fee5caae673c	11111111-1111-1111-1111-111111111111	ccffe940-9f6b-41af-aaeb-72b3e1cdb3da	\N	KOT_CREATED	\N	\N	2026-09-11 12:59:52.811+05:30	KOT_CREATED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
fabb7329-f944-4f62-a48f-ea2274bf5594	67315042-c687-4cbb-b45a-f4ea4efc199f	cff7a875-fec8-4189-bc71-ae49b0e19488	\N	PLACED	\N	\N	2026-09-11 14:11:01.872+05:30	PLACED	\N	\N
f9911338-8980-4c9f-bc55-019c506cfaa0	67315042-c687-4cbb-b45a-f4ea4efc199f	0c7bc59e-d90f-4a42-873f-88c0e9a02386	\N	PLACED	\N	\N	2026-09-11 14:12:08.677+05:30	PLACED	\N	\N
effe113d-2d38-4023-9071-490eaf5db6a8	67315042-c687-4cbb-b45a-f4ea4efc199f	0c7bc59e-d90f-4a42-873f-88c0e9a02386	\N	CONFIRMED	\N	\N	2026-09-11 14:12:08.702+05:30	CONFIRMED	\N	5e635b7d-856a-40b8-8a8c-1398f74eca30
6efe1803-c121-4579-a75f-42ab2e0b718e	67315042-c687-4cbb-b45a-f4ea4efc199f	0c7bc59e-d90f-4a42-873f-88c0e9a02386	\N	KOT_CREATED	\N	\N	2026-09-11 14:12:08.716+05:30	KOT_CREATED	\N	5e635b7d-856a-40b8-8a8c-1398f74eca30
5daac2fa-c5c3-4083-ae58-1aa42a425639	67315042-c687-4cbb-b45a-f4ea4efc199f	f9b4ac11-21c8-4617-9a1d-f1d7e8147a37	\N	PLACED	\N	\N	2026-09-11 14:16:07.314+05:30	PLACED	\N	\N
84fe327f-faab-4802-88c0-9e04fdc55499	67315042-c687-4cbb-b45a-f4ea4efc199f	f9b4ac11-21c8-4617-9a1d-f1d7e8147a37	\N	CONFIRMED	\N	\N	2026-09-11 14:16:07.331+05:30	CONFIRMED	\N	5e635b7d-856a-40b8-8a8c-1398f74eca30
3cab8269-1cb5-4d9c-84aa-94da7fc8be3d	67315042-c687-4cbb-b45a-f4ea4efc199f	f9b4ac11-21c8-4617-9a1d-f1d7e8147a37	\N	KOT_CREATED	\N	\N	2026-09-11 14:16:07.339+05:30	KOT_CREATED	\N	5e635b7d-856a-40b8-8a8c-1398f74eca30
2f3d9a8c-4569-40e2-b1e2-0e0fee287ed9	67315042-c687-4cbb-b45a-f4ea4efc199f	829e83e6-ea56-4173-bfe2-463b24e497a4	\N	PLACED	\N	\N	2026-09-11 14:19:07.426+05:30	PLACED	\N	\N
2087af51-b79f-4089-affe-70b3129801e7	67315042-c687-4cbb-b45a-f4ea4efc199f	829e83e6-ea56-4173-bfe2-463b24e497a4	\N	CONFIRMED	\N	\N	2026-09-11 14:19:07.446+05:30	CONFIRMED	\N	5e635b7d-856a-40b8-8a8c-1398f74eca30
e2517631-2914-4d92-a918-b90e4f173dfd	67315042-c687-4cbb-b45a-f4ea4efc199f	829e83e6-ea56-4173-bfe2-463b24e497a4	\N	KOT_CREATED	\N	\N	2026-09-11 14:19:07.456+05:30	KOT_CREATED	\N	5e635b7d-856a-40b8-8a8c-1398f74eca30
e198cb45-495c-4b6a-b293-57baf089cc87	11111111-1111-1111-1111-111111111111	89dba099-01ad-417a-a438-66ca8af5e712	\N	PLACED	\N	\N	2026-09-11 14:24:19.854+05:30	PLACED	\N	\N
1c8ccb0b-2291-4ac4-8dba-f0c034900b3d	11111111-1111-1111-1111-111111111111	89dba099-01ad-417a-a438-66ca8af5e712	\N	CONFIRMED	\N	\N	2026-09-11 14:24:19.87+05:30	CONFIRMED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
b8bc2d7f-05e3-4ae8-ac6f-73a9152ad44a	11111111-1111-1111-1111-111111111111	89dba099-01ad-417a-a438-66ca8af5e712	\N	KOT_CREATED	\N	\N	2026-09-11 14:24:19.878+05:30	KOT_CREATED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
0338e9ab-d4d6-4591-91e4-73a6a5a16593	11111111-1111-1111-1111-111111111111	4a4e9d6c-a797-4b03-9835-a44526c890e2	\N	PLACED	\N	\N	2026-09-11 14:25:28.507+05:30	PLACED	\N	\N
bb1c3095-db5f-4005-8ecc-56c954d60c2e	11111111-1111-1111-1111-111111111111	4a4e9d6c-a797-4b03-9835-a44526c890e2	\N	CONFIRMED	\N	\N	2026-09-11 14:25:28.522+05:30	CONFIRMED	\N	72bad3bb-6097-47d2-bfc2-35b1244a7b9f
a7efa81d-96ca-4360-be7d-db705f5442fc	11111111-1111-1111-1111-111111111111	4a4e9d6c-a797-4b03-9835-a44526c890e2	\N	KOT_CREATED	\N	\N	2026-09-11 14:25:28.532+05:30	KOT_CREATED	\N	72bad3bb-6097-47d2-bfc2-35b1244a7b9f
d763a440-5ff6-4434-a8fc-e95dfc2362c7	11111111-1111-1111-1111-111111111111	4a4e9d6c-a797-4b03-9835-a44526c890e2	\N	IN_PREPARATION	\N	\N	2026-09-11 14:42:42.233+05:30	IN_PREPARATION	\N	918df673-2606-403a-9fad-1c54870d1fce
08384937-e8b3-4c97-8155-746b58026fb6	11111111-1111-1111-1111-111111111111	89dba099-01ad-417a-a438-66ca8af5e712	\N	IN_PREPARATION	\N	\N	2026-09-11 14:42:44.146+05:30	IN_PREPARATION	\N	918df673-2606-403a-9fad-1c54870d1fce
2b187ff1-7764-4785-894b-55d51a3c9907	11111111-1111-1111-1111-111111111111	89dba099-01ad-417a-a438-66ca8af5e712	\N	READY	\N	\N	2026-09-11 14:43:18.691+05:30	READY	\N	918df673-2606-403a-9fad-1c54870d1fce
d4767c08-966a-4893-915b-fe50e6542072	11111111-1111-1111-1111-111111111111	4a4e9d6c-a797-4b03-9835-a44526c890e2	\N	READY	\N	\N	2026-09-11 14:44:25.869+05:30	READY	\N	72bad3bb-6097-47d2-bfc2-35b1244a7b9f
f92f62a6-718d-4d31-8709-86857a2c5ba1	11111111-1111-1111-1111-111111111111	4a4e9d6c-a797-4b03-9835-a44526c890e2	\N	SERVED	\N	\N	2026-09-11 14:44:32.33+05:30	SERVED	\N	72bad3bb-6097-47d2-bfc2-35b1244a7b9f
b6390d1b-1b6f-4a6e-ade8-fe46e5d6ddb7	11111111-1111-1111-1111-111111111111	89dba099-01ad-417a-a438-66ca8af5e712	\N	SERVED	\N	\N	2026-09-11 14:44:37.615+05:30	SERVED	\N	72bad3bb-6097-47d2-bfc2-35b1244a7b9f
94ceaae6-4d4f-4043-9750-2f17374068ef	11111111-1111-1111-1111-111111111111	d8d53271-b231-47e9-93aa-7a47185f8940	\N	IN_PREPARATION	\N	\N	2026-09-11 16:21:03.329+05:30	IN_PREPARATION	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
3a1b09a6-9db8-4fa9-be61-d5acc69eae59	11111111-1111-1111-1111-111111111111	d8d53271-b231-47e9-93aa-7a47185f8940	\N	READY	\N	\N	2026-09-11 16:21:07.396+05:30	READY	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
0861e477-2651-4a4b-8505-95859a2f0a76	11111111-1111-1111-1111-111111111111	d8d53271-b231-47e9-93aa-7a47185f8940	\N	HANDED_OVER	\N	\N	2026-09-11 16:21:08.595+05:30	HANDED_OVER	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
b264b607-93bd-449c-9160-663e31cd9ae9	11111111-1111-1111-1111-111111111111	ccffe940-9f6b-41af-aaeb-72b3e1cdb3da	\N	IN_PREPARATION	\N	\N	2026-09-11 16:21:23.188+05:30	IN_PREPARATION	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
8c107145-b791-42bf-ac37-7991d04acd8f	11111111-1111-1111-1111-111111111111	ccffe940-9f6b-41af-aaeb-72b3e1cdb3da	\N	READY	\N	\N	2026-09-11 16:40:05.246+05:30	READY	\N	918df673-2606-403a-9fad-1c54870d1fce
8c3adfa8-df1e-4e1b-ba42-7fefc19202ec	11111111-1111-1111-1111-111111111111	ccffe940-9f6b-41af-aaeb-72b3e1cdb3da	\N	HANDED_OVER	\N	\N	2026-09-12 15:31:15.433+05:30	HANDED_OVER	\N	918df673-2606-403a-9fad-1c54870d1fce
7160c56d-5f68-44bc-a405-661c9abdfa42	11111111-1111-1111-1111-111111111111	abaed738-9e4f-4470-ae04-031b3baa4721	\N	PLACED	\N	\N	2026-09-12 16:04:39.564+05:30	PLACED	\N	\N
4cd5e07f-52a0-4141-ade7-809c054a27f6	11111111-1111-1111-1111-111111111111	abaed738-9e4f-4470-ae04-031b3baa4721	\N	CONFIRMED	\N	\N	2026-09-12 16:04:39.586+05:30	CONFIRMED	\N	72bad3bb-6097-47d2-bfc2-35b1244a7b9f
fc147c3f-0fc3-402f-8d68-721f221498b5	11111111-1111-1111-1111-111111111111	abaed738-9e4f-4470-ae04-031b3baa4721	\N	KOT_CREATED	\N	\N	2026-09-12 16:04:39.598+05:30	KOT_CREATED	\N	72bad3bb-6097-47d2-bfc2-35b1244a7b9f
0a1e3e48-035e-4f26-98d7-16c3807d7161	11111111-1111-1111-1111-111111111111	abaed738-9e4f-4470-ae04-031b3baa4721	\N	IN_PREPARATION	\N	\N	2026-09-12 16:05:26.051+05:30	IN_PREPARATION	\N	72bad3bb-6097-47d2-bfc2-35b1244a7b9f
2cf8c678-8c53-486d-92ee-e16d07bc475a	11111111-1111-1111-1111-111111111111	abaed738-9e4f-4470-ae04-031b3baa4721	\N	READY	\N	\N	2026-09-12 16:05:28.016+05:30	READY	\N	72bad3bb-6097-47d2-bfc2-35b1244a7b9f
9f76e43e-ad4c-4cc3-bb35-2a830165c0a4	11111111-1111-1111-1111-111111111111	abaed738-9e4f-4470-ae04-031b3baa4721	\N	HANDED_OVER	\N	\N	2026-09-12 16:05:29.98+05:30	HANDED_OVER	\N	72bad3bb-6097-47d2-bfc2-35b1244a7b9f
840d55bd-2e35-4a81-93c1-63321f365c39	11111111-1111-1111-1111-111111111111	8139a10d-c414-4402-818c-ea00cfd5e786	\N	PLACED	\N	\N	2026-09-12 16:20:51.844+05:30	PLACED	\N	\N
5b307a87-8cce-46fb-b373-ae02c3b9b2cc	11111111-1111-1111-1111-111111111111	8139a10d-c414-4402-818c-ea00cfd5e786	\N	CONFIRMED	\N	\N	2026-09-12 16:20:51.866+05:30	CONFIRMED	\N	918df673-2606-403a-9fad-1c54870d1fce
2c10c763-56d8-492d-90c0-950f37fc58e0	11111111-1111-1111-1111-111111111111	8139a10d-c414-4402-818c-ea00cfd5e786	\N	KOT_CREATED	\N	\N	2026-09-12 16:20:51.875+05:30	KOT_CREATED	\N	918df673-2606-403a-9fad-1c54870d1fce
0e468d28-3006-42ee-b949-84886ce5de5d	11111111-1111-1111-1111-111111111111	8139a10d-c414-4402-818c-ea00cfd5e786	\N	IN_PREPARATION	\N	\N	2026-09-12 16:21:25.273+05:30	IN_PREPARATION	\N	918df673-2606-403a-9fad-1c54870d1fce
2a15a97d-a2fd-4677-992d-02ba5705face	11111111-1111-1111-1111-111111111111	8139a10d-c414-4402-818c-ea00cfd5e786	\N	READY	\N	\N	2026-09-12 16:21:26.225+05:30	READY	\N	918df673-2606-403a-9fad-1c54870d1fce
271f29f8-6967-42dc-9a2c-0d08fc2ee39f	11111111-1111-1111-1111-111111111111	8139a10d-c414-4402-818c-ea00cfd5e786	\N	HANDED_OVER	\N	\N	2026-09-12 16:21:26.893+05:30	HANDED_OVER	\N	918df673-2606-403a-9fad-1c54870d1fce
8abf8473-9baa-4fa8-a34f-3226e1517989	11111111-1111-1111-1111-111111111111	547361f1-ab65-4eeb-b5ae-790378f1eebc	\N	PLACED	\N	\N	2026-09-12 16:22:09.485+05:30	PLACED	\N	\N
bac62020-91b6-4a78-9837-8c6e66f1a3fe	11111111-1111-1111-1111-111111111111	547361f1-ab65-4eeb-b5ae-790378f1eebc	\N	CONFIRMED	\N	\N	2026-09-12 16:22:09.501+05:30	CONFIRMED	\N	918df673-2606-403a-9fad-1c54870d1fce
33c7971b-8a06-4b28-8dad-cece5ce1112d	11111111-1111-1111-1111-111111111111	547361f1-ab65-4eeb-b5ae-790378f1eebc	\N	KOT_CREATED	\N	\N	2026-09-12 16:22:09.51+05:30	KOT_CREATED	\N	918df673-2606-403a-9fad-1c54870d1fce
e16a910f-8b48-442d-a7a0-76013b148f15	11111111-1111-1111-1111-111111111111	547361f1-ab65-4eeb-b5ae-790378f1eebc	\N	IN_PREPARATION	\N	\N	2026-09-12 16:22:21.732+05:30	IN_PREPARATION	\N	918df673-2606-403a-9fad-1c54870d1fce
554873b3-8640-4a88-b453-a1686f088527	11111111-1111-1111-1111-111111111111	547361f1-ab65-4eeb-b5ae-790378f1eebc	\N	READY	\N	\N	2026-09-12 16:22:22.843+05:30	READY	\N	918df673-2606-403a-9fad-1c54870d1fce
d2a4a060-fcfa-40d1-abdb-e2dd2756bce3	11111111-1111-1111-1111-111111111111	547361f1-ab65-4eeb-b5ae-790378f1eebc	\N	HANDED_OVER	\N	\N	2026-09-12 16:22:24.169+05:30	HANDED_OVER	\N	918df673-2606-403a-9fad-1c54870d1fce
e4160148-3ecb-4b3d-b298-98fe701c385b	11111111-1111-1111-1111-111111111111	7bf0131c-f022-46a1-9a7b-8569cd3682f8	\N	PLACED	\N	\N	2026-09-12 16:23:24.876+05:30	PLACED	\N	\N
ff615cf4-9189-4736-92fc-a28a775dad78	11111111-1111-1111-1111-111111111111	7bf0131c-f022-46a1-9a7b-8569cd3682f8	\N	CONFIRMED	\N	\N	2026-09-12 16:23:24.941+05:30	CONFIRMED	\N	918df673-2606-403a-9fad-1c54870d1fce
0029d603-396a-4890-83df-954b3499bd9a	11111111-1111-1111-1111-111111111111	7bf0131c-f022-46a1-9a7b-8569cd3682f8	\N	KOT_CREATED	\N	\N	2026-09-12 16:23:24.976+05:30	KOT_CREATED	\N	918df673-2606-403a-9fad-1c54870d1fce
dd32afee-37f2-4b94-a708-eac454b96984	11111111-1111-1111-1111-111111111111	7bf0131c-f022-46a1-9a7b-8569cd3682f8	\N	IN_PREPARATION	\N	\N	2026-09-12 16:35:33.697+05:30	IN_PREPARATION	\N	918df673-2606-403a-9fad-1c54870d1fce
7d43a1b5-6e8a-4e36-ad23-2adc631cbbf5	11111111-1111-1111-1111-111111111111	7bf0131c-f022-46a1-9a7b-8569cd3682f8	\N	READY	\N	\N	2026-09-12 16:35:34.673+05:30	READY	\N	918df673-2606-403a-9fad-1c54870d1fce
39ebefc9-e0eb-4136-8aa9-5811afd837ba	11111111-1111-1111-1111-111111111111	7bf0131c-f022-46a1-9a7b-8569cd3682f8	\N	HANDED_OVER	\N	\N	2026-09-12 16:37:03.97+05:30	HANDED_OVER	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06
905f8ea9-3eb5-4100-ae63-621004b06410	11111111-1111-1111-1111-111111111111	815fbab6-72c9-41f6-b104-3f8df856c545	\N	PLACED	\N	\N	2026-09-12 16:40:24.134+05:30	PLACED	\N	\N
b25a0528-fcef-497f-a38b-7c44faa85365	11111111-1111-1111-1111-111111111111	815fbab6-72c9-41f6-b104-3f8df856c545	\N	CONFIRMED	\N	\N	2026-09-12 16:40:24.151+05:30	CONFIRMED	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06
bb112b3e-8152-42e5-92d4-8e664decb62e	11111111-1111-1111-1111-111111111111	815fbab6-72c9-41f6-b104-3f8df856c545	\N	KOT_CREATED	\N	\N	2026-09-12 16:40:24.159+05:30	KOT_CREATED	\N	ed8a2f35-4fcf-444b-b6d0-e6808c435e06
dddd62e9-ed9d-4baa-a7fc-51708f5d54f9	11111111-1111-1111-1111-111111111111	815fbab6-72c9-41f6-b104-3f8df856c545	\N	IN_PREPARATION	\N	\N	2026-09-12 17:22:29.992+05:30	IN_PREPARATION	\N	918df673-2606-403a-9fad-1c54870d1fce
d5866276-a52d-49e9-b558-03d983efab30	11111111-1111-1111-1111-111111111111	db187890-3de7-4a5d-87b2-9398153c343a	\N	PLACED	\N	\N	2026-09-23 13:22:19.322+05:30	PLACED	\N	\N
2cc74fb1-be4c-4c8b-be6c-23a9b5ffcbe9	11111111-1111-1111-1111-111111111111	db187890-3de7-4a5d-87b2-9398153c343a	\N	CONFIRMED	\N	\N	2026-09-23 13:22:19.352+05:30	CONFIRMED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
6bb998df-a527-47b0-88fd-abd8630ef32d	11111111-1111-1111-1111-111111111111	db187890-3de7-4a5d-87b2-9398153c343a	\N	KOT_CREATED	\N	\N	2026-09-23 13:22:19.364+05:30	KOT_CREATED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
9afb26bc-a0de-427a-a8e7-9cd18ae32d71	11111111-1111-1111-1111-111111111111	815fbab6-72c9-41f6-b104-3f8df856c545	\N	READY	\N	\N	2026-09-23 13:22:45.982+05:30	READY	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
6442284f-f291-4033-b1ac-e84dfc2390bd	11111111-1111-1111-1111-111111111111	815fbab6-72c9-41f6-b104-3f8df856c545	\N	HANDED_OVER	\N	\N	2026-09-23 13:22:47.048+05:30	HANDED_OVER	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
c327a6b0-f482-4a4b-8113-4159ac6a6f50	11111111-1111-1111-1111-111111111111	db187890-3de7-4a5d-87b2-9398153c343a	\N	IN_PREPARATION	\N	\N	2026-09-23 13:23:29.697+05:30	IN_PREPARATION	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
b74f3ffb-d4fb-408d-afd4-070246a15099	11111111-1111-1111-1111-111111111111	db187890-3de7-4a5d-87b2-9398153c343a	\N	READY	\N	\N	2026-09-23 13:23:29.712+05:30	READY	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
0db9fd1e-b9f3-4197-b725-2232029a486a	11111111-1111-1111-1111-111111111111	db187890-3de7-4a5d-87b2-9398153c343a	\N	SERVED	\N	\N	2026-09-23 13:23:29.723+05:30	SERVED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
ee16bee9-fefc-47b5-a347-b968925509b1	11111111-1111-1111-1111-111111111111	db187890-3de7-4a5d-87b2-9398153c343a	\N	COMPLETED	\N	\N	2026-09-23 13:23:29.736+05:30	COMPLETED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
819f3105-d76c-4105-874e-d048de0ea6a6	11111111-1111-1111-1111-111111111111	320ff853-a5fe-483c-83e1-ba5e70f75d36	\N	PLACED	\N	\N	2026-09-24 09:03:25.544+05:30	PLACED	\N	\N
40296492-f899-47b8-bf2c-51734cc156b5	11111111-1111-1111-1111-111111111111	320ff853-a5fe-483c-83e1-ba5e70f75d36	\N	CONFIRMED	\N	\N	2026-09-24 09:03:25.584+05:30	CONFIRMED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
5807c399-aff9-4205-95a5-69f3897e4114	11111111-1111-1111-1111-111111111111	320ff853-a5fe-483c-83e1-ba5e70f75d36	\N	KOT_CREATED	\N	\N	2026-09-24 09:03:25.592+05:30	KOT_CREATED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
065a82e4-81b5-47da-b35d-62b241993c21	11111111-1111-1111-1111-111111111111	900efa09-cbd9-4da9-8897-1b837e07b788	\N	PLACED	\N	\N	2026-09-24 23:32:05.575+05:30	PLACED	\N	\N
d3e16fb0-a265-4030-b00b-b1ac9338ce02	11111111-1111-1111-1111-111111111111	900efa09-cbd9-4da9-8897-1b837e07b788	\N	CONFIRMED	\N	\N	2026-09-24 23:32:05.865+05:30	CONFIRMED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
8013085b-3d0e-45b9-a9c1-076699076729	11111111-1111-1111-1111-111111111111	fd749f2c-9fde-404e-892b-0b60a6f95860	\N	PLACED	\N	\N	2026-09-24 23:33:03.109+05:30	PLACED	\N	\N
8458e280-d4e9-4085-8296-c06b34a6b4ee	11111111-1111-1111-1111-111111111111	fd749f2c-9fde-404e-892b-0b60a6f95860	\N	CONFIRMED	\N	\N	2026-09-24 23:33:03.528+05:30	CONFIRMED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
2baebde0-0cbe-4fec-8849-c6a13abbee02	11111111-1111-1111-1111-111111111111	fd749f2c-9fde-404e-892b-0b60a6f95860	\N	KOT_CREATED	\N	\N	2026-09-24 23:33:03.547+05:30	KOT_CREATED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
ef103ba6-f2bc-45d7-8bea-b20822334679	11111111-1111-1111-1111-111111111111	300e3125-c13a-4c6f-9548-9d7ec596529f	\N	PLACED	\N	\N	2026-09-24 23:33:41.07+05:30	PLACED	\N	\N
3aab5692-5914-4295-8436-2728fb775dce	11111111-1111-1111-1111-111111111111	300e3125-c13a-4c6f-9548-9d7ec596529f	\N	CONFIRMED	\N	\N	2026-09-24 23:33:41.127+05:30	CONFIRMED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
6ad32b05-d255-4041-a29f-6f0d8bf82fd7	11111111-1111-1111-1111-111111111111	300e3125-c13a-4c6f-9548-9d7ec596529f	\N	KOT_CREATED	\N	\N	2026-09-24 23:33:41.142+05:30	KOT_CREATED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
c250e1c7-c2b5-45cb-96c0-bf28d342e892	11111111-1111-1111-1111-111111111111	96b6a769-53e4-47b5-b329-af8e6a597f73	\N	PLACED	\N	\N	2026-09-24 23:33:42.625+05:30	PLACED	\N	\N
4c247b69-4f89-4dce-aef7-c30e24b1925a	11111111-1111-1111-1111-111111111111	96b6a769-53e4-47b5-b329-af8e6a597f73	\N	CONFIRMED	\N	\N	2026-09-24 23:33:42.638+05:30	CONFIRMED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
dabce278-2943-459e-bd6f-b43e4b92f7d1	11111111-1111-1111-1111-111111111111	96b6a769-53e4-47b5-b329-af8e6a597f73	\N	KOT_CREATED	\N	\N	2026-09-24 23:33:42.649+05:30	KOT_CREATED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
5ba4a8f0-a8a5-4f70-a39d-18992ca18490	11111111-1111-1111-1111-111111111111	f4fbbe17-c9da-40cc-a954-1b9d7d1d6752	\N	PLACED	\N	\N	2026-09-24 23:48:18.401+05:30	PLACED	\N	\N
afcf1d6d-3f47-427b-8540-6041c0aac113	11111111-1111-1111-1111-111111111111	f4fbbe17-c9da-40cc-a954-1b9d7d1d6752	\N	CONFIRMED	\N	\N	2026-09-24 23:48:18.495+05:30	CONFIRMED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
c2ac4283-c651-4124-a327-f1ceb7b70951	11111111-1111-1111-1111-111111111111	51ee39c7-53f2-40c4-adae-b49600c041f7	\N	PLACED	\N	\N	2026-09-24 23:54:18.815+05:30	PLACED	\N	\N
f8f13ec5-791b-4bee-abc0-a7ebb04b05a8	11111111-1111-1111-1111-111111111111	51ee39c7-53f2-40c4-adae-b49600c041f7	\N	CONFIRMED	\N	\N	2026-09-24 23:54:18.994+05:30	CONFIRMED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
e732c9f5-7de7-49d2-87ca-fbe8cdec8145	11111111-1111-1111-1111-111111111111	3d9c934c-97d3-4da2-8f4b-4772896ee29b	\N	PLACED	\N	\N	2026-09-25 00:07:00.646+05:30	PLACED	\N	\N
ccc863e0-283a-47db-a386-345b95958c6d	11111111-1111-1111-1111-111111111111	3d9c934c-97d3-4da2-8f4b-4772896ee29b	\N	CONFIRMED	\N	\N	2026-09-25 00:07:00.712+05:30	CONFIRMED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
62ce2fa2-0dcf-4f2b-9a69-4558f41dabf0	11111111-1111-1111-1111-111111111111	6dcda227-21c2-4291-918f-a3813a9062eb	\N	PLACED	\N	\N	2026-10-02 16:33:19.835+05:30	PLACED	\N	\N
e1e74216-d336-4a98-af17-90fb4ecd3caa	11111111-1111-1111-1111-111111111111	6dcda227-21c2-4291-918f-a3813a9062eb	\N	CONFIRMED	\N	\N	2026-10-02 16:33:19.87+05:30	CONFIRMED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
5e37dcd2-5820-4a55-8a09-437e5c3849e6	11111111-1111-1111-1111-111111111111	6dcda227-21c2-4291-918f-a3813a9062eb	\N	KOT_CREATED	\N	\N	2026-10-02 16:33:19.88+05:30	KOT_CREATED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
e6b606ce-6dca-447c-9cf4-555de7e7881d	11111111-1111-1111-1111-111111111111	1469b1ab-dc07-49fd-979d-6393518fd684	\N	PLACED	\N	\N	2026-10-02 16:57:54.337+05:30	PLACED	\N	\N
f5013118-5303-4bdd-a0df-d8ecf29dda88	11111111-1111-1111-1111-111111111111	1469b1ab-dc07-49fd-979d-6393518fd684	\N	CONFIRMED	\N	\N	2026-10-02 16:57:54.704+05:30	CONFIRMED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
5995277b-05e7-4ed5-a67c-73a35342f876	11111111-1111-1111-1111-111111111111	1469b1ab-dc07-49fd-979d-6393518fd684	\N	KOT_CREATED	\N	\N	2026-10-02 16:57:54.728+05:30	KOT_CREATED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
c146f140-967a-4b61-b290-4ade4b0cd3c6	11111111-1111-1111-1111-111111111111	1469b1ab-dc07-49fd-979d-6393518fd684	\N	IN_PREPARATION	\N	\N	2026-10-02 16:57:54.742+05:30	IN_PREPARATION	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
77a5f182-89df-4222-86a6-e157444f694d	11111111-1111-1111-1111-111111111111	1469b1ab-dc07-49fd-979d-6393518fd684	\N	READY	\N	\N	2026-10-02 16:57:54.756+05:30	READY	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
1e219c88-a6ca-41a8-8e98-f4ff2ebba32f	11111111-1111-1111-1111-111111111111	1469b1ab-dc07-49fd-979d-6393518fd684	\N	SERVED	\N	\N	2026-10-02 16:57:54.77+05:30	SERVED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
4c6f40fe-29c6-4c99-806e-668d1cb6949a	11111111-1111-1111-1111-111111111111	1469b1ab-dc07-49fd-979d-6393518fd684	\N	COMPLETED	\N	\N	2026-10-02 16:57:54.788+05:30	COMPLETED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
e75dad08-d18e-4aee-b171-8becfbd7f2a7	11111111-1111-1111-1111-111111111111	53494c1e-ee68-4197-b271-2a8c5f2bdb26	\N	PLACED	\N	\N	2026-10-02 16:59:07.489+05:30	PLACED	\N	\N
1a965c76-d861-494a-940f-4ad85e30648a	11111111-1111-1111-1111-111111111111	fd749f2c-9fde-404e-892b-0b60a6f95860	\N	IN_PREPARATION	\N	\N	2026-10-02 16:59:07.585+05:30	IN_PREPARATION	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
e0a986e8-ab78-4077-8f22-2b42dede75a7	11111111-1111-1111-1111-111111111111	fd749f2c-9fde-404e-892b-0b60a6f95860	\N	READY	\N	\N	2026-10-02 16:59:07.622+05:30	READY	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
fa4cab05-4160-4cb8-9e1c-e1e9d8450309	11111111-1111-1111-1111-111111111111	fd749f2c-9fde-404e-892b-0b60a6f95860	\N	HANDED_OVER	\N	\N	2026-10-02 16:59:07.664+05:30	HANDED_OVER	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
593190a0-9771-4dce-b7b3-2647ac53ffe8	11111111-1111-1111-1111-111111111111	53494c1e-ee68-4197-b271-2a8c5f2bdb26	\N	CONFIRMED	\N	\N	2026-10-02 16:59:07.708+05:30	CONFIRMED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
3feb40f2-1b44-4a2c-8e3b-c765ab9daa55	11111111-1111-1111-1111-111111111111	53494c1e-ee68-4197-b271-2a8c5f2bdb26	\N	KOT_CREATED	\N	\N	2026-10-02 16:59:07.719+05:30	KOT_CREATED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
92c884e0-8056-41b8-b433-55513aaf6baf	11111111-1111-1111-1111-111111111111	53494c1e-ee68-4197-b271-2a8c5f2bdb26	\N	IN_PREPARATION	\N	\N	2026-10-02 16:59:07.729+05:30	IN_PREPARATION	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
2b700dc9-0096-4800-874f-a95f74459e68	11111111-1111-1111-1111-111111111111	53494c1e-ee68-4197-b271-2a8c5f2bdb26	\N	READY	\N	\N	2026-10-02 16:59:07.741+05:30	READY	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
1f058e77-145d-4c75-ac16-c5e186d97a9f	11111111-1111-1111-1111-111111111111	53494c1e-ee68-4197-b271-2a8c5f2bdb26	\N	SERVED	\N	\N	2026-10-02 16:59:07.751+05:30	SERVED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
badc7415-b93c-47d2-a42a-9f28aa76230b	11111111-1111-1111-1111-111111111111	53494c1e-ee68-4197-b271-2a8c5f2bdb26	\N	COMPLETED	\N	\N	2026-10-02 16:59:07.765+05:30	COMPLETED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
ae61cd2c-b7f2-4ca1-9b1e-6014753b4761	11111111-1111-1111-1111-111111111111	89dba099-01ad-417a-a438-66ca8af5e712	\N	COMPLETED	\N	\N	2026-10-03 01:21:43.058+05:30	COMPLETED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
654e55e1-d64c-4958-9dd2-6507ec3d835e	11111111-1111-1111-1111-111111111111	7bf0131c-f022-46a1-9a7b-8569cd3682f8	\N	COMPLETED	\N	\N	2026-10-03 01:23:42.466+05:30	COMPLETED	\N	918df673-2606-403a-9fad-1c54870d1fce
71e222be-9667-4c67-b80d-fe4b2758f099	11111111-1111-1111-1111-111111111111	af21c0cc-a9e8-459c-b797-ddb34bb7f724	\N	PLACED	\N	\N	2026-10-03 01:24:04.779+05:30	PLACED	\N	\N
a0f4b6d6-2579-4697-a1d6-2be52189a5df	11111111-1111-1111-1111-111111111111	af21c0cc-a9e8-459c-b797-ddb34bb7f724	\N	CONFIRMED	\N	\N	2026-10-03 01:24:04.795+05:30	CONFIRMED	\N	918df673-2606-403a-9fad-1c54870d1fce
68941062-1335-4ded-9d0a-c0162acc3731	11111111-1111-1111-1111-111111111111	af21c0cc-a9e8-459c-b797-ddb34bb7f724	\N	KOT_CREATED	\N	\N	2026-10-03 01:24:04.805+05:30	KOT_CREATED	\N	918df673-2606-403a-9fad-1c54870d1fce
a3f0871b-e388-4830-a78d-477bce67f837	11111111-1111-1111-1111-111111111111	af21c0cc-a9e8-459c-b797-ddb34bb7f724	\N	IN_PREPARATION	\N	\N	2026-10-03 01:24:19.949+05:30	IN_PREPARATION	\N	918df673-2606-403a-9fad-1c54870d1fce
16ad1b20-835d-4bd7-8ca2-8aef0b1f86fc	11111111-1111-1111-1111-111111111111	af21c0cc-a9e8-459c-b797-ddb34bb7f724	\N	READY	\N	\N	2026-10-03 01:24:19.959+05:30	READY	\N	918df673-2606-403a-9fad-1c54870d1fce
28811a52-1906-4880-9748-f2da75e343fd	11111111-1111-1111-1111-111111111111	af21c0cc-a9e8-459c-b797-ddb34bb7f724	\N	SERVED	\N	\N	2026-10-03 01:24:19.971+05:30	SERVED	\N	918df673-2606-403a-9fad-1c54870d1fce
c19b61b0-20ea-4297-8c98-5b3e7f465e44	11111111-1111-1111-1111-111111111111	af21c0cc-a9e8-459c-b797-ddb34bb7f724	\N	COMPLETED	\N	\N	2026-10-03 01:24:19.982+05:30	COMPLETED	\N	918df673-2606-403a-9fad-1c54870d1fce
155ef47f-f0b2-4401-9cf3-e67be98cb68e	11111111-1111-1111-1111-111111111111	b7899f9e-fd1e-4f77-89fc-0d935c2e2d85	\N	PLACED	\N	\N	2026-10-03 01:24:33.52+05:30	PLACED	\N	\N
61569bc7-9cbc-47a0-87bd-3606bfe2bb2e	11111111-1111-1111-1111-111111111111	b7899f9e-fd1e-4f77-89fc-0d935c2e2d85	\N	CONFIRMED	\N	\N	2026-10-03 01:24:33.544+05:30	CONFIRMED	\N	918df673-2606-403a-9fad-1c54870d1fce
eec03dcf-faa1-4230-9111-89cf21e824dd	11111111-1111-1111-1111-111111111111	b7899f9e-fd1e-4f77-89fc-0d935c2e2d85	\N	KOT_CREATED	\N	\N	2026-10-03 01:24:33.699+05:30	KOT_CREATED	\N	918df673-2606-403a-9fad-1c54870d1fce
b964840e-267e-4d48-ab1b-358bd0f7f7b3	11111111-1111-1111-1111-111111111111	b7899f9e-fd1e-4f77-89fc-0d935c2e2d85	\N	IN_PREPARATION	\N	\N	2026-10-03 01:24:33.728+05:30	IN_PREPARATION	\N	918df673-2606-403a-9fad-1c54870d1fce
79fe4d83-d945-4c3c-93dd-b81ef2eb8d9d	11111111-1111-1111-1111-111111111111	b7899f9e-fd1e-4f77-89fc-0d935c2e2d85	\N	READY	\N	\N	2026-10-03 01:24:33.749+05:30	READY	\N	918df673-2606-403a-9fad-1c54870d1fce
9908ed20-728b-4df0-91fb-76fbf5fe3340	11111111-1111-1111-1111-111111111111	b7899f9e-fd1e-4f77-89fc-0d935c2e2d85	\N	SERVED	\N	\N	2026-10-03 01:24:33.78+05:30	SERVED	\N	918df673-2606-403a-9fad-1c54870d1fce
72e2d8e7-ab5f-45b8-90bb-32203c2cc9b3	11111111-1111-1111-1111-111111111111	b7899f9e-fd1e-4f77-89fc-0d935c2e2d85	\N	COMPLETED	\N	\N	2026-10-03 01:24:33.8+05:30	COMPLETED	\N	918df673-2606-403a-9fad-1c54870d1fce
944358d8-d70d-49e2-b787-d27c1eb445b9	11111111-1111-1111-1111-111111111111	c81161e9-bd67-474a-bf80-3b1756fe5393	\N	PLACED	\N	\N	2026-10-03 01:25:42.591+05:30	PLACED	\N	\N
9a439e62-fa67-4c6c-b9d7-459f3ad0656f	11111111-1111-1111-1111-111111111111	c81161e9-bd67-474a-bf80-3b1756fe5393	\N	CONFIRMED	\N	\N	2026-10-03 01:25:42.604+05:30	CONFIRMED	\N	918df673-2606-403a-9fad-1c54870d1fce
5a8f8f82-c9c8-4cc3-9391-995ff57aefee	11111111-1111-1111-1111-111111111111	c81161e9-bd67-474a-bf80-3b1756fe5393	\N	KOT_CREATED	\N	\N	2026-10-03 01:25:42.611+05:30	KOT_CREATED	\N	918df673-2606-403a-9fad-1c54870d1fce
6eeec006-ad1c-4e9e-92b5-be5806542162	11111111-1111-1111-1111-111111111111	c81161e9-bd67-474a-bf80-3b1756fe5393	\N	IN_PREPARATION	\N	\N	2026-10-03 01:26:31.063+05:30	IN_PREPARATION	\N	918df673-2606-403a-9fad-1c54870d1fce
d9e93acc-2664-406f-80a5-92c711eceae3	11111111-1111-1111-1111-111111111111	c81161e9-bd67-474a-bf80-3b1756fe5393	\N	READY	\N	\N	2026-10-03 01:26:31.072+05:30	READY	\N	918df673-2606-403a-9fad-1c54870d1fce
5187d52e-0e9f-4001-803a-ffad6d736141	11111111-1111-1111-1111-111111111111	c81161e9-bd67-474a-bf80-3b1756fe5393	\N	SERVED	\N	\N	2026-10-03 01:26:31.082+05:30	SERVED	\N	918df673-2606-403a-9fad-1c54870d1fce
ddc352c0-3d5f-4265-a8af-63475e71a2b8	11111111-1111-1111-1111-111111111111	c81161e9-bd67-474a-bf80-3b1756fe5393	\N	COMPLETED	\N	\N	2026-10-03 01:26:31.092+05:30	COMPLETED	\N	918df673-2606-403a-9fad-1c54870d1fce
c6e94657-1fd8-4360-954e-62d88377fa48	11111111-1111-1111-1111-111111111111	de5f32b6-72f6-441d-a98f-3f273e2a3bba	\N	PLACED	\N	\N	2026-10-03 01:27:32.42+05:30	PLACED	\N	\N
ce5d92d8-6abd-4a9a-bffa-ef28eaa6c139	11111111-1111-1111-1111-111111111111	de5f32b6-72f6-441d-a98f-3f273e2a3bba	\N	CONFIRMED	\N	\N	2026-10-03 01:27:32.433+05:30	CONFIRMED	\N	918df673-2606-403a-9fad-1c54870d1fce
8db9eb0a-95ec-4c32-a968-256433cd3619	11111111-1111-1111-1111-111111111111	de5f32b6-72f6-441d-a98f-3f273e2a3bba	\N	KOT_CREATED	\N	\N	2026-10-03 01:27:32.518+05:30	KOT_CREATED	\N	918df673-2606-403a-9fad-1c54870d1fce
d27ed2d2-0e23-40c2-9f30-cc8edee6e09b	11111111-1111-1111-1111-111111111111	de5f32b6-72f6-441d-a98f-3f273e2a3bba	\N	IN_PREPARATION	\N	\N	2026-10-03 01:27:32.694+05:30	IN_PREPARATION	\N	918df673-2606-403a-9fad-1c54870d1fce
2196d058-82a3-44ec-8e4b-ca31a476e82e	11111111-1111-1111-1111-111111111111	de5f32b6-72f6-441d-a98f-3f273e2a3bba	\N	READY	\N	\N	2026-10-03 01:27:32.751+05:30	READY	\N	918df673-2606-403a-9fad-1c54870d1fce
98066ca0-5342-464c-a38f-ee4dba994f61	11111111-1111-1111-1111-111111111111	de5f32b6-72f6-441d-a98f-3f273e2a3bba	\N	SERVED	\N	\N	2026-10-03 01:27:32.835+05:30	SERVED	\N	918df673-2606-403a-9fad-1c54870d1fce
75515412-665b-49a8-8b17-e0704a4f9743	11111111-1111-1111-1111-111111111111	de5f32b6-72f6-441d-a98f-3f273e2a3bba	\N	COMPLETED	\N	\N	2026-10-03 01:27:32.865+05:30	COMPLETED	\N	918df673-2606-403a-9fad-1c54870d1fce
0066d28d-3d8f-493c-9c5f-a1f0e31f3d37	11111111-1111-1111-1111-111111111111	6dcda227-21c2-4291-918f-a3813a9062eb	\N	IN_PREPARATION	\N	\N	2026-10-03 04:38:00.102+05:30	IN_PREPARATION	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
bec93075-6bac-469e-aa71-797239ab5e5f	11111111-1111-1111-1111-111111111111	6dcda227-21c2-4291-918f-a3813a9062eb	\N	READY	\N	\N	2026-10-03 04:38:00.127+05:30	READY	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
1ce9d6e8-35fc-4eb5-885f-c78e849c12e4	11111111-1111-1111-1111-111111111111	6dcda227-21c2-4291-918f-a3813a9062eb	\N	SERVED	\N	\N	2026-10-03 04:38:00.138+05:30	SERVED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
93885529-7e72-4f94-a445-04079bf7ee9f	11111111-1111-1111-1111-111111111111	6dcda227-21c2-4291-918f-a3813a9062eb	\N	COMPLETED	\N	\N	2026-10-03 04:38:00.152+05:30	COMPLETED	\N	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
5ef77449-0721-46ed-9c5e-dda8a5c57dbb	11111111-1111-1111-1111-111111111111	6bb8a0c7-38c6-4f87-95a7-8edd80cbcfb6	\N	PLACED	\N	\N	2026-10-03 13:58:21.823+05:30	PLACED	\N	\N
15c8e330-b336-4920-a3ef-9e7d3b9ee226	11111111-1111-1111-1111-111111111111	6bb8a0c7-38c6-4f87-95a7-8edd80cbcfb6	\N	CONFIRMED	\N	\N	2026-10-03 13:58:21.88+05:30	CONFIRMED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
24127130-78b8-4c5d-8a8d-64555b04f80b	11111111-1111-1111-1111-111111111111	6bb8a0c7-38c6-4f87-95a7-8edd80cbcfb6	\N	KOT_CREATED	\N	\N	2026-10-03 13:58:21.895+05:30	KOT_CREATED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
e3b786a4-9549-4f29-a17a-6ed9c81d2722	11111111-1111-1111-1111-111111111111	5736ba49-2b3d-47e0-b162-575f81bbd62c	\N	PLACED	\N	\N	2026-10-03 14:00:38.329+05:30	PLACED	\N	\N
75c962d5-c173-47cd-9008-d674459e7f32	11111111-1111-1111-1111-111111111111	5736ba49-2b3d-47e0-b162-575f81bbd62c	\N	CONFIRMED	\N	\N	2026-10-03 14:00:38.36+05:30	CONFIRMED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
cd1d0df5-a4b3-421e-b155-c25ce1fdb81e	11111111-1111-1111-1111-111111111111	6040a630-394f-416c-9b97-8deef80f81f8	\N	PLACED	\N	\N	2026-10-03 14:04:11.569+05:30	PLACED	\N	\N
7e5dd57d-cc44-4bfb-85c0-c685388d7635	11111111-1111-1111-1111-111111111111	6040a630-394f-416c-9b97-8deef80f81f8	\N	CONFIRMED	\N	\N	2026-10-03 14:04:11.586+05:30	CONFIRMED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
2e5abce5-952f-4625-a728-eaa3ce3df3b3	11111111-1111-1111-1111-111111111111	6040a630-394f-416c-9b97-8deef80f81f8	\N	KOT_CREATED	\N	\N	2026-10-03 14:04:11.596+05:30	KOT_CREATED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
9b91e0e2-98cc-406d-8a73-465de2ef0de8	11111111-1111-1111-1111-111111111111	a48e021b-e5d6-4f57-af79-3995db8f417b	\N	PLACED	\N	\N	2026-10-03 15:10:55.223+05:30	PLACED	\N	\N
98118667-291f-4d7c-a46d-969f0142b347	11111111-1111-1111-1111-111111111111	a48e021b-e5d6-4f57-af79-3995db8f417b	\N	CONFIRMED	\N	\N	2026-10-03 15:10:55.238+05:30	CONFIRMED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
df36a430-88a7-4887-a04e-c84d37b0ed78	11111111-1111-1111-1111-111111111111	a48e021b-e5d6-4f57-af79-3995db8f417b	\N	KOT_CREATED	\N	\N	2026-10-03 15:10:55.248+05:30	KOT_CREATED	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.orders (id, outlet_id, order_number, type, status, business_date, subtotal_minor, total_minor, currency, customer_id, table_number, delivery_address_id, created_at, updated_at, created_by, updated_by, settled_at, scheduled_fire_at, promised_at, deposit_minor, advance_status, tip_total_minor, service_charge_total_minor, merge_group_id, covers, split_mode, merged_into_order_id, round_off_minor, channel, external_order_id, rider_name, rider_phone, received_at, accepted_at, customer_otp, grand_total, subtotal, terminal_number, order_type, dining_table_id, discount_total, tax_total, service_charge_total, tip_total, idempotency_key, waiter_id) FROM stdin;
ccffe940-9f6b-41af-aaeb-72b3e1cdb3da	11111111-1111-1111-1111-111111111111	20260911-0004	DINE_IN	HANDED_OVER	2026-09-11	6000	6300	INR	\N	\N	\N	2026-09-11 12:59:52.773+05:30	2026-09-12 15:31:15.382+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	6300	6000	T-01	DINE_IN	\N	0	300	0	0	waiter-1789111792740-op9oud74m5r	\N
39f6e5e8-3eb1-4100-a8cc-4dfcb49ba060	11111111-1111-1111-1111-111111111111	20260909-0007	DINE_IN	KOT_CREATED	2026-09-09	21000	22050	INR	\N	\N	\N	2026-09-09 13:03:37.797+05:30	2026-09-09 13:03:38.677+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	1050	0	TEST-01	DINE_IN	\N	0	1050	0	0	test-stock-1788939217739	\N
011e557d-7bda-415e-ac6c-7ee4490ec2aa	11111111-1111-1111-1111-111111111111	ORD-SW-8821	DELIVERY	CONFIRMED	2026-09-03	10200000	10200000	INR	\N	\N	\N	2026-09-03 12:29:36.848942+05:30	2026-09-15 16:15:08.305+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	swiggy	SW-8821	Suresh Kumar	9848022338	\N	\N	\N	102000	102000	T-01	DINE_IN	\N	0	0	0	0	IDEMP-011e557d-7bda-415e-ac6c-7ee4490ec2aa	\N
f5d3449d-ce21-48cb-ab01-b41c41a7301c	11111111-1111-1111-1111-111111111111	20260908-0003	DINE_IN	COMPLETED	2026-09-08	15000	15750	INR	\N	\N	\N	2026-09-08 13:14:15.231+05:30	2026-09-09 14:07:29.94+05:30	\N	\N	2026-09-09 14:07:29.939+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	45675	43500	T-01	DINE_IN	799771fc-55e6-42a7-8a24-c8946f547286	0	2175	0	0	waiter-1788853455194-s4tefy9z8z	\N
685aa7a6-e1d4-4a39-a7fe-c54252180927	11111111-1111-1111-1111-111111111111	20260908-0005	DINE_IN	HANDED_OVER	2026-09-08	11000	11550	INR	\N	\N	\N	2026-09-08 14:41:53.554+05:30	2026-09-08 14:44:38.661+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	11550	11000	POS-01	PICKUP	\N	0	550	0	0	ord_1788858713544_hsiqd97	\N
482d35cd-b7b6-4c65-a7f3-943897646bad	11111111-1111-1111-1111-111111111111	20260909-0011	DINE_IN	KOT_CREATED	2026-09-09	25000	26250	INR	\N	\N	\N	2026-09-09 14:28:57.784+05:30	2026-09-09 14:28:58.352+05:30	\N	\N	\N	2026-09-09 14:43:57.74+05:30	2026-09-09 15:13:57.74+05:30	25000	FIRED	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	26250	25000	POS-01	DELIVERY	\N	0	1250	0	0	adv-test-1788944337742	\N
c69c7c36-7b05-4ca7-9012-710df44ed6fd	67315042-c687-4cbb-b45a-f4ea4efc199f	ORD-101	DINE_IN	IN_PREPARATION	2026-09-03	9600000	9600000	INR	\N	A1	\N	2026-09-03 12:29:17.500816+05:30	2026-09-03 12:29:17.500816+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	96000	96000	T-01	DINE_IN	\N	0	0	0	0	IDEMP-c69c7c36-7b05-4ca7-9012-710df44ed6fd	\N
42d364fa-b9c0-4f09-b125-534a14fa6cda	67315042-c687-4cbb-b45a-f4ea4efc199f	ORD-100	DINE_IN	COMPLETED	2026-09-03	8400000	8400000	INR	\N	A2	\N	2026-09-03 10:29:36.845587+05:30	2026-09-03 12:29:36.845587+05:30	\N	\N	2026-09-03 12:29:36.845587+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	84000	84000	T-01	DINE_IN	\N	0	0	0	0	IDEMP-42d364fa-b9c0-4f09-b125-534a14fa6cda	\N
b0845453-ec80-411d-8370-e62958475492	11111111-1111-1111-1111-111111111111	20260903-0001	DINE_IN	KOT_CREATED	2026-09-03	850000	850000	INR	\N	\N	\N	2026-09-03 14:07:10.182+05:30	2026-09-03 14:07:10.239+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	8904	8500	T-01	DINE_IN	\N	0	404	0	0	waiter-1788424630110-2slzvx8iyvr	\N
5338928a-7fb6-429f-a646-8f12166322fa	11111111-1111-1111-1111-111111111111	20260903-0002	DINE_IN	KOT_CREATED	2026-09-03	850000	850000	INR	\N	\N	\N	2026-09-03 14:07:13.294+05:30	2026-09-03 14:07:13.327+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	8904	8500	T-01	DINE_IN	\N	0	404	0	0	waiter-1788424633262-ubqk7lg59gh	\N
17cb34b5-878f-4d13-b0ec-02af3307cbf2	11111111-1111-1111-1111-111111111111	20260903-0003	DINE_IN	KOT_CREATED	2026-09-03	2200000	2200000	INR	\N	\N	\N	2026-09-03 14:10:08.923+05:30	2026-09-03 14:10:08.966+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	23047	22000	POS-01	DINE_IN	\N	0	1047	0	0	ord_1788424808900_fi4t6th	\N
4a3e148b-1df0-46f8-a71a-c834486429e5	11111111-1111-1111-1111-111111111111	20260903-0004	DINE_IN	CONFIRMED	2026-09-03	1700000	1700000	INR	\N	\N	\N	2026-09-03 14:19:54.422+05:30	2026-09-03 14:19:54.599+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	17809	17000	POS-01	DINE_IN	\N	0	809	0	0	ord_1788425394391_8jvq9t9	\N
d1467f47-4869-4592-996e-0d3f373ec018	11111111-1111-1111-1111-111111111111	20260909-0016	DINE_IN	KOT_CREATED	2026-09-09	25000	26250	INR	\N	\N	\N	2026-09-09 14:34:00.893+05:30	2026-09-09 14:34:01.493+05:30	\N	\N	\N	2026-09-09 14:49:00.779+05:30	2026-09-09 15:19:00.779+05:30	25000	FIRED	0	0	\N	\N	\N	\N	0	\N	\N	Sanjay Singhania	9876543210	\N	\N	\N	26250	25000	POS-01	DELIVERY	\N	0	1250	0	0	adv-test-1788944640781	\N
190ec2cb-fb90-44c2-ad76-b32672063fdb	11111111-1111-1111-1111-111111111111	20260909-0004	DINE_IN	KOT_CREATED	2026-09-09	25500	26775	INR	\N	\N	\N	2026-09-09 13:01:25.156+05:30	2026-09-09 13:01:25.192+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	26775	25500	TEST-01	DINE_IN	\N	0	1275	0	0	test-stock-1788939085123	\N
9528cbcc-5873-41a3-b142-53165932bc70	11111111-1111-1111-1111-111111111111	20260909-0006	DINE_IN	KOT_CREATED	2026-09-09	127500	133875	INR	\N	\N	\N	2026-09-09 13:02:03.713+05:30	2026-09-09 13:02:03.746+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	133875	127500	TEST-01	DINE_IN	\N	0	6375	0	0	test-zero-1788939123683	\N
71ef893c-0ccc-439d-bc3e-0a248037303b	11111111-1111-1111-1111-111111111111	20260903-0006	DINE_IN	COMPLETED	2026-09-03	850000	850000	INR	\N	\N	\N	2026-09-03 14:25:51.852+05:30	2026-09-09 15:08:58.35+05:30	\N	\N	2026-09-08 11:01:05.855+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	10904	8500	T-01	DINE_IN	\N	0	404	1000	1000	waiter-1788425751809-w8tffsvs6r	\N
2d4b655e-a5bf-4900-ba0c-11e1b3c2685c	11111111-1111-1111-1111-111111111111	20260909-0002	DINE_IN	COMPLETED	2026-09-09	8500	8925	INR	\N	\N	\N	2026-09-09 12:51:14.221+05:30	2026-09-09 15:08:58.35+05:30	\N	\N	2026-09-09 14:06:01.12+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	473025	450500	T-01	DINE_IN	\N	0	22525	0	0	waiter-1788938474192-69hxmpu2vz9	\N
1085cebe-ebf0-4804-83f3-aae6d0d4a7c9	11111111-1111-1111-1111-111111111111	20260908-0001	DINE_IN	COMPLETED	2026-09-08	3500	3675	INR	\N	\N	\N	2026-09-08 11:05:04.308+05:30	2026-09-09 15:08:58.35+05:30	\N	\N	2026-09-08 11:10:47.888+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	77075	71500	T-01	DINE_IN	\N	0	3575	1000	1000	waiter-1788845704266-rv8phamg79q	\N
0602cb47-3398-4ba0-b5da-87e23909efa3	11111111-1111-1111-1111-111111111111	20260909-0001	DINE_IN	COMPLETED	2026-09-09	8500	8925	INR	\N	\N	\N	2026-09-09 12:47:30.717+05:30	2026-09-09 15:08:58.35+05:30	\N	\N	2026-09-09 12:51:03.262+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	534975	509500	T-01	DINE_IN	\N	0	25475	0	0	waiter-1788938250682-63ox706v2y4	\N
65505588-f509-44ef-a6c6-c488503dcbe3	11111111-1111-1111-1111-111111111111	20260909-0013	DINE_IN	HANDED_OVER	2026-09-09	25000	26250	INR	\N	\N	\N	2026-09-09 14:31:14.448+05:30	2026-09-11 11:10:05.989+05:30	\N	\N	\N	2026-09-09 14:46:14.256+05:30	2026-09-09 15:16:14.256+05:30	25000	FIRED	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	26250	25000	POS-01	DELIVERY	\N	0	1250	0	0	adv-test-1788944474258	\N
3e1ba9c8-0311-4534-a8d3-fa97b3a4f933	11111111-1111-1111-1111-111111111111	20260909-0017	DINE_IN	COMPLETED	2026-09-09	5000	5250	INR	\N	\N	\N	2026-09-09 15:09:20.329+05:30	2026-09-10 17:31:57.032+05:30	\N	\N	2026-09-10 17:17:49.752+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	15500	10000	T-01	DINE_IN	f2f701b9-6bc9-4869-8f88-4904a35070d8	0	500	0	5000	waiter-1788946760271-03nb4awdw1w7	9b35fd7a-2717-4837-ad91-9328aee9ec5f
b6abe3e6-d0e7-4dc7-a631-097181effc3a	11111111-1111-1111-1111-111111111111	20260909-0014	DINE_IN	HANDED_OVER	2026-09-09	25000	26250	INR	\N	\N	\N	2026-09-09 14:31:59.199+05:30	2026-09-11 11:10:55.589+05:30	\N	\N	\N	2026-09-09 14:46:59.157+05:30	2026-09-09 15:16:59.157+05:30	25000	FIRED	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	26250	25000	POS-01	DELIVERY	\N	0	1250	0	0	adv-test-1788944519158	\N
c8387bcf-ab67-44bb-87fb-d67f6d7601ca	11111111-1111-1111-1111-111111111111	20260911-0002	DINE_IN	COMPLETED	2026-09-11	12000	12600	INR	\N	\N	\N	2026-09-11 12:33:27.195+05:30	2026-09-11 12:34:34.925+05:30	\N	\N	2026-09-11 12:34:34.918+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	17600	12000	T-01	DINE_IN	2e681514-bcbe-4ef9-bc4d-b2209a3d5f85	0	600	0	5000	waiter-1789110207150-a6aj8qynpks	\N
27f9f630-3e8b-4ba9-b4d7-e631e45182f7	11111111-1111-1111-1111-111111111111	20260911-0001	DINE_IN	COMPLETED	2026-09-11	5000	5250	INR	\N	\N	\N	2026-09-11 12:09:46.276+05:30	2026-09-11 12:35:19.7+05:30	\N	\N	2026-09-11 12:35:19.699+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	10250	5000	T-01	DINE_IN	f2f701b9-6bc9-4869-8f88-4904a35070d8	0	250	0	5000	waiter-1789108786239-h18kst0x8c4	\N
0c7bc59e-d90f-4a42-873f-88c0e9a02386	67315042-c687-4cbb-b45a-f4ea4efc199f	20260911-0002	DINE_IN	KOT_CREATED	2026-09-11	34000	35700	INR	\N	\N	\N	2026-09-11 14:12:08.658+05:30	2026-09-11 14:12:08.711+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	35700	34000	POS-01	DINE_IN	689515c9-28fd-4324-9b84-3f99d1075bd6	0	1700	0	0	ord_1789116128645_8clzul7	5e635b7d-856a-40b8-8a8c-1398f74eca30
118a762d-2cc4-4b94-b0c6-1b7360cd6652	11111111-1111-1111-1111-111111111111	20260909-0008	DINE_IN	KOT_CREATED	2026-09-09	105000	110250	INR	\N	\N	\N	2026-09-09 13:03:39.352+05:30	2026-09-09 13:03:39.381+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	110250	105000	TEST-01	DINE_IN	\N	0	5250	0	0	test-zero-1788939219330	\N
82e2a068-a74a-4e18-89fe-7a423f5b243f	11111111-1111-1111-1111-111111111111	20260905-0005	DINE_IN	COMPLETED	2026-09-05	7000	7350	INR	\N	\N	\N	2026-09-05 17:05:54.948+05:30	2026-09-05 17:14:44.771+05:30	\N	\N	2026-09-05 17:14:44.766+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	7350	7000	T-01	DINE_IN	1bb0a59d-079d-4406-8bd9-0fd2f4a7668e	0	350	0	0	waiter-1788608154918-4amhfzjeev3	\N
d8d53271-b231-47e9-93aa-7a47185f8940	11111111-1111-1111-1111-111111111111	20260911-0003	DINE_IN	HANDED_OVER	2026-09-11	12000	12600	INR	\N	\N	\N	2026-09-11 12:59:30.541+05:30	2026-09-11 16:21:08.593+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	12600	12000	T-01	DINE_IN	\N	0	600	0	0	waiter-1789111770444-ey2pwahr4uf	\N
e7d4d6cf-4838-43bd-8334-688d11302496	11111111-1111-1111-1111-111111111111	20260905-0001	DINE_IN	COMPLETED	2026-09-05	8500	8925	INR	\N	\N	\N	2026-09-05 14:26:19.028+05:30	2026-09-08 11:17:50.433+05:30	\N	\N	2026-09-08 11:17:50.432+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	116025	110500	T-01	DINE_IN	2e681514-bcbe-4ef9-bc4d-b2209a3d5f85	0	5525	0	0	waiter-1788598578951-3x5u1bfz12a	\N
eb13fd97-c972-4447-8a42-898eb545191e	11111111-1111-1111-1111-111111111111	20260908-0002	DINE_IN	COMPLETED	2026-09-08	20000	21000	INR	\N	\N	\N	2026-09-08 13:13:14.864+05:30	2026-09-09 14:07:10.548+05:30	\N	\N	2026-09-09 14:07:07.609+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	21000	20000	T-01	DINE_IN	\N	0	1000	0	0	waiter-1788853394827-hlq6jlpw4zm	\N
0f621958-d193-4d99-b6ef-037fcea9cd0a	11111111-1111-1111-1111-111111111111	20260903-0009	DINE_IN	COMPLETED	2026-09-04	5000	5250	INR	\N	\N	\N	2026-09-04 00:05:22.297+05:30	2026-09-09 14:07:10.548+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	16800	16000	T-01	DINE_IN	\N	0	800	0	0	waiter-1788460522260-n4yubv97com	\N
a00d57c3-c01d-49d0-9166-45e9f7e22497	11111111-1111-1111-1111-111111111111	20260903-0010	DINE_IN	COMPLETED	2026-09-04	11000	11550	INR	\N	\N	\N	2026-09-04 00:40:55.689+05:30	2026-09-09 14:07:10.548+05:30	\N	\N	2026-09-05 13:22:05.624+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	47250	45000	T-01	DINE_IN	\N	0	2250	0	0	waiter-1788462655658-0g8ogjyypgdt	\N
e7eccfdc-02d5-470f-869b-da665f7dcb2e	11111111-1111-1111-1111-111111111111	20260903-0007	DINE_IN	COMPLETED	2026-09-03	3200000	3200000	INR	\N	\N	\N	2026-09-03 14:53:11.846+05:30	2026-09-09 14:07:10.548+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	38773	37000	T-01	DINE_IN	\N	0	1773	0	0	waiter-1788427391814-tmsnij0grzn	\N
ece12171-62db-4f53-ba97-d5e93e06f733	11111111-1111-1111-1111-111111111111	20260903-0011	DINE_IN	COMPLETED	2026-09-04	15000	15750	INR	\N	\N	\N	2026-09-04 01:04:33.319+05:30	2026-09-04 01:14:43.211+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	15750	15000	T-01	DINE_IN	1bb0a59d-079d-4406-8bd9-0fd2f4a7668e	0	750	0	0	waiter-1788464073288-gn75s1cf276	\N
25ab98b4-6057-4986-a634-4dd7dc5f51bc	11111111-1111-1111-1111-111111111111	20260909-0012	DINE_IN	KOT_CREATED	2026-09-09	25000	26250	INR	\N	\N	\N	2026-09-09 14:29:43.193+05:30	2026-09-09 14:29:43.536+05:30	\N	\N	\N	2026-09-09 14:44:43.146+05:30	2026-09-09 15:14:43.146+05:30	25000	FIRED	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	26250	25000	POS-01	DELIVERY	\N	0	1250	0	0	adv-test-1788944383148	\N
b5177d27-2e27-4abd-8296-83a748730b2c	11111111-1111-1111-1111-111111111111	20260903-0012	DINE_IN	COMPLETED	2026-09-04	16000	16800	INR	\N	\N	\N	2026-09-04 01:19:56.483+05:30	2026-09-04 01:19:56.837+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	16800	16000	POS-01	DINE_IN	1bb0a59d-079d-4406-8bd9-0fd2f4a7668e	0	800	0	0	ord_1788464996469_3mcstu8	\N
76692730-cd05-45cd-b8ad-9cc20ac9fc5a	11111111-1111-1111-1111-111111111111	20260908-0006	DINE_IN	COMPLETED	2026-09-08	7000	7350	INR	\N	\N	\N	2026-09-08 15:13:45.024+05:30	2026-09-09 12:47:11.545+05:30	\N	\N	2026-09-09 12:47:11.546+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	7350	7000	POS-01	DELIVERY	2e681514-bcbe-4ef9-bc4d-b2209a3d5f85	0	350	0	0	ord_1788860625004_0vfwvn1	\N
b101f725-9679-4cf3-9f0f-16adb200ecff	11111111-1111-1111-1111-111111111111	20260908-0004	DINE_IN	COMPLETED	2026-09-08	3000	3150	INR	\N	\N	\N	2026-09-08 14:27:24.401+05:30	2026-09-09 15:08:58.35+05:30	\N	\N	2026-09-09 12:45:00.458+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	3150	3000	POS-01	DINE_IN	\N	0	150	0	0	ord_1788857844387_pnho1th	\N
f973888e-e429-473a-8566-ddea7ac708a0	11111111-1111-1111-1111-111111111111	20260909-0003	DINE_IN	KOT_CREATED	2026-09-09	25500	26775	INR	\N	\N	\N	2026-09-09 12:52:31.635+05:30	2026-09-09 12:52:31.668+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	26775	25500	TEST-01	DINE_IN	\N	0	1275	0	0	test-stock-1788938551577	\N
d71091c4-71f0-4c75-bd38-c6b08ba4dd4a	11111111-1111-1111-1111-111111111111	20260909-0015	DINE_IN	KOT_CREATED	2026-09-09	25000	26250	INR	\N	\N	\N	2026-09-09 14:32:48.228+05:30	2026-09-09 14:32:48.893+05:30	\N	\N	\N	2026-09-09 14:47:48.133+05:30	2026-09-09 15:17:48.133+05:30	25000	FIRED	0	0	\N	\N	\N	\N	0	\N	\N	Sanjay Singhania	9876543210	\N	\N	\N	26250	25000	POS-01	DELIVERY	\N	0	1250	0	0	adv-test-1788944568135	\N
0a746ebb-ff2b-40d1-8d00-5e7652f56006	11111111-1111-1111-1111-111111111111	20260909-0009	DINE_IN	COMPLETED	2026-09-09	8500	8925	INR	\N	\N	\N	2026-09-09 14:27:26.133+05:30	2026-09-09 15:08:58.35+05:30	\N	\N	2026-09-09 15:08:54.403+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	15225	14500	T-01	DINE_IN	\N	0	725	0	0	waiter-1788944246063-ncm62ehlzdq	\N
4e192b03-6942-454a-a9dd-9084d99362b1	11111111-1111-1111-1111-111111111111	20260909-0005	DINE_IN	KOT_CREATED	2026-09-09	25500	26775	INR	\N	\N	\N	2026-09-09 13:02:02.18+05:30	2026-09-09 13:02:03.027+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	1275	0	TEST-01	DINE_IN	\N	0	1275	0	0	test-stock-1788939122107	\N
c182470d-5000-40bc-86f8-b9093c4333e8	11111111-1111-1111-1111-111111111111	20260909-0010	DINE_IN	HANDED_OVER	2026-09-09	25000	26250	INR	\N	\N	\N	2026-09-09 14:27:33.537+05:30	2026-09-11 11:10:15.606+05:30	\N	\N	\N	2026-09-09 14:42:33.465+05:30	2026-09-09 15:12:33.465+05:30	25000	FIRED	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	26250	25000	POS-01	DELIVERY	\N	0	1250	0	0	adv-test-1788944253467	\N
5583e31e-48a5-435a-936e-aba2f8bb9c9c	11111111-1111-1111-1111-111111111111	20260903-0008	DINE_IN	HANDED_OVER	2026-09-03	8500	8500	INR	\N	\N	\N	2026-09-03 15:17:20.19+05:30	2026-09-04 00:43:39.266+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	8905	8500	POS-01	DINE_IN	\N	0	405	0	0	ord_1788428840172_i5luagi	\N
e93358df-ec3b-4e3b-a241-8e93bd953411	11111111-1111-1111-1111-111111111111	20260903-0005	DINE_IN	HANDED_OVER	2026-09-03	850000	850000	INR	\N	\N	\N	2026-09-03 14:21:16.17+05:30	2026-09-04 00:40:28.025+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	8904	8500	T-01	DINE_IN	\N	0	404	0	0	ord_1788425476160_z6c5dx6	\N
0f3580d0-cceb-4289-99f8-5ffdf1669b18	11111111-1111-1111-1111-111111111111	20260905-0002	DINE_IN	COMPLETED	2026-09-05	5000	5250	INR	\N	\N	\N	2026-09-05 15:10:12.587+05:30	2026-09-05 15:10:12.827+05:30	\N	\N	2026-09-05 15:10:12.826+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	5250	5000	POS-01	DELIVERY	\N	0	250	0	0	ord_1788601212574_wa4ogo8	\N
c3a366cb-039e-4e26-9cbd-8e22cd2d52b9	11111111-1111-1111-1111-111111111111	20260905-0003	DINE_IN	KOT_CREATED	2026-09-05	8500	8925	INR	\N	\N	\N	2026-09-05 16:22:38.18+05:30	2026-09-05 16:22:38.21+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	8925	8500	POS-01	DELIVERY	\N	0	425	0	0	ord_1788605558170_1gmdq2r	\N
cff7a875-fec8-4189-bc71-ae49b0e19488	67315042-c687-4cbb-b45a-f4ea4efc199f	20260911-0001	DINE_IN	CANCELLED	2026-09-11	34000	35700	INR	\N	\N	\N	2026-09-11 14:11:01.856+05:30	2026-09-11 14:11:01.878+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	35700	34000	POS-01	DINE_IN	689515c9-28fd-4324-9b84-3f99d1075bd6	0	1700	0	0	ord_1789116061838_98wmqeq	5e635b7d-856a-40b8-8a8c-1398f74eca30
5b433b06-af43-4f62-8a6b-e2ca1e0bfa88	67315042-c687-4cbb-b45a-f4ea4efc199f	20260905-0001	DINE_IN	COMPLETED	2026-09-05	34000	35700	INR	\N	\N	\N	2026-09-05 16:45:41.988+05:30	2026-09-05 16:45:42.158+05:30	\N	\N	2026-09-05 16:45:42.157+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	35700	34000	POS-01	DINE_IN	\N	0	1700	0	0	ord_1788606941959_wnespmw	\N
f9b4ac11-21c8-4617-9a1d-f1d7e8147a37	67315042-c687-4cbb-b45a-f4ea4efc199f	20260911-0003	DINE_IN	KOT_CREATED	2026-09-11	34000	35700	INR	\N	\N	\N	2026-09-11 14:16:07.299+05:30	2026-09-11 14:16:07.337+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	35700	34000	POS-01	DINE_IN	6a306a91-9632-4294-a4e9-b21f41fd2206	0	1700	0	0	ord_1789116367278_fdmvqib	5e635b7d-856a-40b8-8a8c-1398f74eca30
7a369854-faf1-4af3-8378-8b939249c434	11111111-1111-1111-1111-111111111111	20260905-0004	DINE_IN	COMPLETED	2026-09-05	6500	6825	INR	\N	\N	\N	2026-09-05 16:51:32.7+05:30	2026-09-05 16:51:32.893+05:30	\N	\N	2026-09-05 16:51:32.892+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	6825	6500	POS-01	DELIVERY	\N	0	325	0	0	ord_1788607292692_9ytidv5	\N
829e83e6-ea56-4173-bfe2-463b24e497a4	67315042-c687-4cbb-b45a-f4ea4efc199f	20260911-0004	DINE_IN	CANCELLED	2026-09-11	34000	35700	INR	\N	\N	\N	2026-09-11 14:19:07.411+05:30	2026-09-11 14:19:07.453+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	35700	34000	POS-01	DINE_IN	60d8deb7-f101-4ab6-b384-bc6118a32a7b	0	1700	0	0	ord_1789116547396_dbsxsuu	5e635b7d-856a-40b8-8a8c-1398f74eca30
abaed738-9e4f-4470-ae04-031b3baa4721	11111111-1111-1111-1111-111111111111	20260912-0001	DINE_IN	COMPLETED	2026-09-12	15000	15750	INR	\N	\N	\N	2026-09-12 16:04:39.515+05:30	2026-09-12 16:05:47.987+05:30	\N	\N	2026-09-12 16:05:47.985+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	19050	15000	T-01	DINE_IN	2e681514-bcbe-4ef9-bc4d-b2209a3d5f85	0	750	0	3300	waiter-1789209279470-9wkrb1wr5wn	72bad3bb-6097-47d2-bfc2-35b1244a7b9f
fd16417e-3c3d-418a-a088-d360729aac73	11111111-1111-1111-1111-111111111111	SWIGGY-SWIG-76280	DINE_IN	CONFIRMED	2026-09-15	64000	67200	INR	7a9b6880-e4d0-4ef7-9708-e81e8e76c7b8	\N	\N	2026-09-15 15:22:15.313+05:30	2026-09-15 16:15:08.305+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	SWIGGY	SWIG-76280	Ramesh Kumar (Swiggy Rider)	+919876500111	2026-09-15 15:22:15.302+05:30	2026-09-15 15:22:15.302+05:30	4421	67200	64000	T-01	DELIVERY	\N	0	3200	0	0	\N	\N
cbb10a15-6c98-4ad1-a42b-ae7e1f56f9b7	11111111-1111-1111-1111-111111111111	ZOMATO-ZOM-50848	DINE_IN	CONFIRMED	2026-09-15	46000	48300	INR	e43347e2-c5bc-4195-af72-f615b5bd81c4	\N	\N	2026-09-15 16:15:47.754+05:30	2026-09-15 16:15:47.754+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	ZOMATO	ZOM-50848	Amit Verma (Zomato Valet)	+919876500222	2026-09-15 16:15:47.749+05:30	2026-09-15 16:15:47.749+05:30	8914	48300	46000	T-01	DELIVERY	\N	0	2300	0	0	\N	\N
547361f1-ab65-4eeb-b5ae-790378f1eebc	11111111-1111-1111-1111-111111111111	20260912-0003	DINE_IN	COMPLETED	2026-09-12	8500	8925	INR	\N	\N	\N	2026-09-12 16:22:09.473+05:30	2026-09-12 16:22:52.528+05:30	\N	\N	2026-09-12 16:22:52.526+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	8925	8500	T-01	DINE_IN	bb01f08e-7a9d-43b3-acce-be35218b3f27	0	425	0	0	waiter-1789210329444-8s7p4zq7qke	918df673-2606-403a-9fad-1c54870d1fce
244aecef-ffc4-48ba-a00c-0e041ee50389	11111111-1111-1111-1111-111111111111	SWIGGY-SWIG-24093	DINE_IN	CONFIRMED	2026-09-15	32000	33600	INR	7a9b6880-e4d0-4ef7-9708-e81e8e76c7b8	\N	\N	2026-09-15 16:15:47.978+05:30	2026-09-15 16:15:47.978+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	SWIGGY	SWIG-24093	Ramesh Kumar (Swiggy Delivery)	+919876500111	2026-09-15 16:15:47.972+05:30	2026-09-15 16:15:47.972+05:30	4421	33600	32000	T-01	DELIVERY	\N	0	1600	0	0	\N	\N
815fbab6-72c9-41f6-b104-3f8df856c545	11111111-1111-1111-1111-111111111111	20260912-0005	DINE_IN	HANDED_OVER	2026-09-12	16000	16800	INR	\N	\N	\N	2026-09-12 16:40:24.108+05:30	2026-09-23 13:22:47.046+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	16800	16000	T-01	DINE_IN	bb01f08e-7a9d-43b3-acce-be35218b3f27	0	800	0	0	waiter-1789211424081-09pp1sd8ignb	ed8a2f35-4fcf-444b-b6d0-e6808c435e06
300e3125-c13a-4c6f-9548-9d7ec596529f	11111111-1111-1111-1111-111111111111	20260924-0004	DINE_IN	KOT_CREATED	2026-09-24	21000	22050	INR	\N	\N	\N	2026-09-24 23:33:41.061+05:30	2026-09-24 23:33:41.918+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	1050	0	TEST-01	DINE_IN	\N	0	1050	0	0	test-stock-1790273021024	\N
96b6a769-53e4-47b5-b329-af8e6a597f73	11111111-1111-1111-1111-111111111111	20260924-0005	DINE_IN	KOT_CREATED	2026-09-24	105000	110250	INR	\N	\N	\N	2026-09-24 23:33:42.614+05:30	2026-09-24 23:33:42.646+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	110250	105000	TEST-01	DINE_IN	\N	0	5250	0	0	test-zero-1790273022579	\N
51ee39c7-53f2-40c4-adae-b49600c041f7	11111111-1111-1111-1111-111111111111	20260924-0007	DINE_IN	COMPLETED	2026-09-24	17000	17850	INR	\N	\N	\N	2026-09-24 23:54:18.774+05:30	2026-09-24 23:54:20.059+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	22850	17000	T-01	DINE_IN	7f7e342f-0f6c-456c-9ec5-055de3ab87fe	0	850	0	5000	e2e-waiter-1790274258728-rdemqqsbk3f	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
1469b1ab-dc07-49fd-979d-6393518fd684	11111111-1111-1111-1111-111111111111	20261002-0002	DINE_IN	COMPLETED	2026-10-02	17000	17850	INR	\N	\N	\N	2026-10-02 16:57:54.318+05:30	2026-10-02 16:57:54.838+05:30	\N	\N	2026-10-02 16:57:54.835+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	17850	17000	POS-01	DINE_IN	1bb0a59d-079d-4406-8bd9-0fd2f4a7668e	0	850	0	0	ord_1790940474303_i4gb8m1	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
fd749f2c-9fde-404e-892b-0b60a6f95860	11111111-1111-1111-1111-111111111111	20260924-0003	DINE_IN	HANDED_OVER	2026-09-24	25000	26250	INR	d5d508df-1b81-4d7e-a491-b70f0a42ad6e	\N	\N	2026-09-24 23:33:03.086+05:30	2026-10-02 16:59:07.662+05:30	\N	\N	\N	2026-09-24 23:48:03.023+05:30	2026-09-25 00:18:03.023+05:30	25000	FIRED	0	0	\N	\N	\N	\N	0	\N	\N	Sanjay Singhania	9876543210	\N	\N	\N	26250	25000	POS-01	DELIVERY	\N	0	1250	0	0	adv-test-1790272983024	\N
53494c1e-ee68-4197-b271-2a8c5f2bdb26	11111111-1111-1111-1111-111111111111	20261002-0003	DINE_IN	COMPLETED	2026-10-02	17000	17850	INR	\N	\N	\N	2026-10-02 16:59:07.471+05:30	2026-10-02 16:59:07.785+05:30	\N	\N	2026-10-02 16:59:07.784+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	17850	17000	POS-01	DINE_IN	1bb0a59d-079d-4406-8bd9-0fd2f4a7668e	0	850	0	0	ord_1790940547459_yq7adbr	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
b7899f9e-fd1e-4f77-89fc-0d935c2e2d85	11111111-1111-1111-1111-111111111111	20261002-0005	DINE_IN	COMPLETED	2026-10-03	8000	8400	INR	\N	\N	\N	2026-10-03 01:24:33.493+05:30	2026-10-03 01:24:33.859+05:30	\N	\N	2026-10-03 01:24:33.857+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	8400	8000	POS-01	DINE_IN	799771fc-55e6-42a7-8a24-c8946f547286	0	400	0	0	ord_1790970873481_2dln95o	918df673-2606-403a-9fad-1c54870d1fce
c81161e9-bd67-474a-bf80-3b1756fe5393	11111111-1111-1111-1111-111111111111	20261002-0006	DINE_IN	COMPLETED	2026-10-03	6000	6300	INR	\N	\N	\N	2026-10-03 01:25:42.583+05:30	2026-10-03 01:26:31.114+05:30	\N	\N	2026-10-03 01:26:31.112+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	6300	6000	T-01	DINE_IN	799771fc-55e6-42a7-8a24-c8946f547286	0	300	0	0	waiter-1790970942553-119c1c36g0c	918df673-2606-403a-9fad-1c54870d1fce
de5f32b6-72f6-441d-a98f-3f273e2a3bba	11111111-1111-1111-1111-111111111111	20261002-0007	DINE_IN	COMPLETED	2026-10-03	6000	6300	INR	\N	\N	\N	2026-10-03 01:27:32.406+05:30	2026-10-03 01:27:32.889+05:30	\N	\N	2026-10-03 01:27:32.887+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	6300	6000	POS-01	DINE_IN	799771fc-55e6-42a7-8a24-c8946f547286	0	300	0	0	ord_1790971052396_km6txoe	918df673-2606-403a-9fad-1c54870d1fce
a48e021b-e5d6-4f57-af79-3995db8f417b	11111111-1111-1111-1111-111111111111	20261003-0004	DINE_IN	KOT_CREATED	2026-10-03	50000	52500	INR	\N	\N	\N	2026-10-03 15:10:55.205+05:30	2026-10-03 15:10:55.246+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	52500	50000	T-01	DINE_IN	57ee2f6b-ac03-4d32-b562-44b210b422cc	0	2500	0	0	waiter-1791020455142-2462izha66o	9b35fd7a-2717-4837-ad91-9328aee9ec5f
5736ba49-2b3d-47e0-b162-575f81bbd62c	11111111-1111-1111-1111-111111111111	20261003-0002	DINE_IN	CONFIRMED	2026-10-03	6000	6300	INR	f161c4a6-d9ec-4087-a82b-23c35fb2ee53	\N	\N	2026-10-03 14:00:38.253+05:30	2026-10-03 14:46:00.281+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	6475	6000	POS-01	PICKUP	7f7e342f-0f6c-456c-9ec5-055de3ab87fe	0	475	0	0	ord_1791016238242_lkpdicf	9b35fd7a-2717-4837-ad91-9328aee9ec5f
db187890-3de7-4a5d-87b2-9398153c343a	11111111-1111-1111-1111-111111111111	20260923-0001	DINE_IN	COMPLETED	2026-09-23	7000	7350	INR	\N	\N	\N	2026-09-23 13:22:19.3+05:30	2026-09-23 13:23:36.159+05:30	\N	\N	2026-09-23 13:23:29.767+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	7350	7000	T-01	DINE_IN	\N	0	350	0	0	waiter-1790149939236-yfx5hznewq	9b35fd7a-2717-4837-ad91-9328aee9ec5f
4a4e9d6c-a797-4b03-9835-a44526c890e2	11111111-1111-1111-1111-111111111111	20260911-0006	DINE_IN	COMPLETED	2026-09-11	6000	6300	INR	\N	\N	\N	2026-09-11 14:25:28.493+05:30	2026-09-12 15:32:01.72+05:30	\N	\N	2026-09-12 15:32:01.713+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	17600	12000	T-01	DINE_IN	2e681514-bcbe-4ef9-bc4d-b2209a3d5f85	0	600	0	5000	waiter-1789116928464-0td9r51w84vp	72bad3bb-6097-47d2-bfc2-35b1244a7b9f
8139a10d-c414-4402-818c-ea00cfd5e786	11111111-1111-1111-1111-111111111111	20260912-0002	DINE_IN	COMPLETED	2026-09-12	18000	18900	INR	\N	\N	\N	2026-09-12 16:20:51.817+05:30	2026-09-12 16:21:52.118+05:30	\N	\N	2026-09-12 16:21:52.116+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	18900	18000	T-01	DINE_IN	2e681514-bcbe-4ef9-bc4d-b2209a3d5f85	0	900	0	0	waiter-1789210251781-6sb1fu5wmcx	918df673-2606-403a-9fad-1c54870d1fce
af21c0cc-a9e8-459c-b797-ddb34bb7f724	11111111-1111-1111-1111-111111111111	20261002-0004	DINE_IN	COMPLETED	2026-10-03	6000	6300	INR	\N	\N	\N	2026-10-03 01:24:04.753+05:30	2026-10-03 01:24:20+05:30	\N	\N	2026-10-03 01:24:19.996+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	6300	6000	T-01	DINE_IN	799771fc-55e6-42a7-8a24-c8946f547286	0	300	0	0	waiter-1790970844707-8tjei4inqrr	918df673-2606-403a-9fad-1c54870d1fce
00d7a187-3ebe-45bb-a596-f39d6680e588	11111111-1111-1111-1111-111111111111	SWIGGY-SWIGGY-31464	DINE_IN	CONFIRMED	2026-09-15	64000	67200	INR	79101d18-2063-4b11-99d8-ed5d17667003	\N	\N	2026-09-15 15:20:21.622+05:30	2026-09-15 16:15:08.305+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	SWIGGY	SWIGGY-31464	Ramesh Kumar	+919876500111	2026-09-15 15:20:21.606+05:30	2026-09-15 15:20:21.606+05:30	3591	67200	64000	T-01	DELIVERY	\N	0	3200	0	0	\N	\N
dce6709a-59c7-4b0f-b6b7-a84556fd4da8	11111111-1111-1111-1111-111111111111	ZOMATO-ZOM-29923	DINE_IN	CONFIRMED	2026-09-15	42500	44625	INR	e43347e2-c5bc-4195-af72-f615b5bd81c4	\N	\N	2026-09-15 15:26:49.318+05:30	2026-09-15 16:15:08.305+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	ZOMATO	ZOM-29923	Amit Verma (Zomato Valet)	+919876500222	2026-09-15 15:26:49.307+05:30	2026-09-15 15:26:49.307+05:30	8914	44625	42500	T-01	DELIVERY	\N	0	2125	0	0	\N	\N
320ff853-a5fe-483c-83e1-ba5e70f75d36	11111111-1111-1111-1111-111111111111	20260924-0001	DINE_IN	KOT_CREATED	2026-09-24	15000	15750	INR	\N	\N	\N	2026-09-24 09:03:25.428+05:30	2026-09-24 09:03:25.59+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	15750	15000	T-01	DINE_IN	2e681514-bcbe-4ef9-bc4d-b2209a3d5f85	0	750	0	0	waiter-1790220805385-yjo1p72xs0b	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
900efa09-cbd9-4da9-8897-1b837e07b788	11111111-1111-1111-1111-111111111111	20260924-0002	DINE_IN	COMPLETED	2026-09-24	17000	17850	INR	\N	\N	\N	2026-09-24 23:32:05.485+05:30	2026-09-24 23:32:07.701+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	22850	17000	T-01	DINE_IN	7f7e342f-0f6c-456c-9ec5-055de3ab87fe	0	850	0	5000	e2e-waiter-1790272925445-2stngw0wkvy	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
f4fbbe17-c9da-40cc-a954-1b9d7d1d6752	11111111-1111-1111-1111-111111111111	20260924-0006	DINE_IN	COMPLETED	2026-09-24	17000	17850	INR	\N	\N	\N	2026-09-24 23:48:18.378+05:30	2026-09-24 23:48:19.672+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	22850	17000	T-01	DINE_IN	7f7e342f-0f6c-456c-9ec5-055de3ab87fe	0	850	0	5000	e2e-waiter-1790273898344-9qyvsnczpfv	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
3d9c934c-97d3-4da2-8f4b-4772896ee29b	11111111-1111-1111-1111-111111111111	20260924-0008	DINE_IN	COMPLETED	2026-09-25	17000	17850	INR	\N	\N	\N	2026-09-25 00:07:00.619+05:30	2026-09-25 00:07:01.767+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	22850	17000	T-01	DINE_IN	7f7e342f-0f6c-456c-9ec5-055de3ab87fe	0	850	0	5000	e2e-waiter-1790275020576-7ta61hnfqsj	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc
7bf0131c-f022-46a1-9a7b-8569cd3682f8	11111111-1111-1111-1111-111111111111	20260912-0004	DINE_IN	COMPLETED	2026-09-12	8000	8400	INR	\N	\N	\N	2026-09-12 16:23:24.864+05:30	2026-10-03 01:23:42.496+05:30	\N	\N	2026-10-03 01:23:42.492+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	76650	73000	T-01	DINE_IN	799771fc-55e6-42a7-8a24-c8946f547286	0	3650	0	0	waiter-1789210404835-fx1qlorgmw	918df673-2606-403a-9fad-1c54870d1fce
89dba099-01ad-417a-a438-66ca8af5e712	11111111-1111-1111-1111-111111111111	20260911-0005	DINE_IN	COMPLETED	2026-09-11	5000	5250	INR	\N	\N	\N	2026-09-11 14:24:19.82+05:30	2026-10-03 01:21:43.123+05:30	\N	\N	2026-10-03 01:21:43.121+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	11550	11000	T-01	DINE_IN	f2f701b9-6bc9-4869-8f88-4904a35070d8	0	550	0	0	waiter-1789116859770-jjo9rt2sm6	9b35fd7a-2717-4837-ad91-9328aee9ec5f
6dcda227-21c2-4291-918f-a3813a9062eb	11111111-1111-1111-1111-111111111111	20261002-0001	DINE_IN	COMPLETED	2026-10-02	5000	5250	INR	\N	\N	\N	2026-10-02 16:33:19.793+05:30	2026-10-03 04:38:00.18+05:30	\N	\N	2026-10-03 04:38:00.179+05:30	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	16800	16000	T-01	DINE_IN	fc8127fc-a614-4ba2-ae4e-bc2fb91b2d3d	0	800	0	0	waiter-1790938999730-0vrwj23udxw	9b35fd7a-2717-4837-ad91-9328aee9ec5f
6040a630-394f-416c-9b97-8deef80f81f8	11111111-1111-1111-1111-111111111111	20261003-0003	DINE_IN	CANCELLED	2026-10-03	6000	6300	INR	470aeef0-83a1-4ea2-a1fb-8f33a821ce32	\N	\N	2026-10-03 14:04:11.556+05:30	2026-10-03 14:44:22.142+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	0	0	POS-01	PICKUP	fc8127fc-a614-4ba2-ae4e-bc2fb91b2d3d	0	0	0	0	ord_1791016451542_51jel67	9b35fd7a-2717-4837-ad91-9328aee9ec5f
6bb8a0c7-38c6-4f87-95a7-8edd80cbcfb6	11111111-1111-1111-1111-111111111111	20261003-0001	DINE_IN	KOT_CREATED	2026-10-03	6000	6300	INR	\N	\N	\N	2026-10-03 13:58:21.663+05:30	2026-10-03 14:32:23.255+05:30	\N	\N	\N	\N	\N	0	\N	0	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	\N	39900	38000	T-01	DINE_IN	799771fc-55e6-42a7-8a24-c8946f547286	0	1900	0	0	waiter-1791016101545-qv6mdsr4re	9b35fd7a-2717-4837-ad91-9328aee9ec5f
\.


--
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.organizations (id, name, legal_name, tax_id, created_at, updated_at, created_by, updated_by, tax_number) FROM stdin;
00000000-0000-0000-0000-000000000000	Hotel Kapila Hospitality Group	\N	\N	2026-09-02 14:05:00.622+05:30	2026-09-02 16:33:25.638+05:30	\N	\N	36AAACH7412K1Z9
\.


--
-- Data for Name: outbound_events; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.outbound_events (id, outlet_id, channel_account_id, payload, attempt, status, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: outbox_events; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.outbox_events (id, outlet_id, event_type, payload, status, attempts, max_attempts, last_error, created_at, processed_at) FROM stdin;
79f0ef48-84c2-4f82-82c4-42110c104f00	11111111-1111-1111-1111-111111111111	order.settled	{"orderId": "a00d57c3-c01d-49d0-9166-45e9f7e22497", "amountMinor": "47250", "invoiceNumber": "INV-2026-00001", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-09-05 13:22:05.652+05:30	2026-09-05 13:22:07.545+05:30
3e7fca4a-a950-488f-87d2-cb4d69b49857	11111111-1111-1111-1111-111111111111	order.settled	{"orderId": "0f3580d0-cceb-4289-99f8-5ffdf1669b18", "amountMinor": "5250", "invoiceNumber": "INV-2026-00002", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-09-05 15:10:12.847+05:30	2026-09-05 15:10:13.296+05:30
6790ae2b-583d-485a-8bc7-717c9d5b9f62	67315042-c687-4cbb-b45a-f4ea4efc199f	order.settled	{"orderId": "5b433b06-af43-4f62-8a6b-e2ca1e0bfa88", "amountMinor": "35700", "invoiceNumber": "INV-2026-00001", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-09-05 16:45:42.254+05:30	2026-09-05 16:45:42.988+05:30
43273480-a03e-42d5-ab9e-274df36d44f7	11111111-1111-1111-1111-111111111111	order.settled	{"orderId": "7a369854-faf1-4af3-8378-8b939249c434", "amountMinor": "6825", "invoiceNumber": "INV-2026-00003", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-09-05 16:51:32.915+05:30	2026-09-05 16:51:34.336+05:30
7ed1dd89-4018-4af1-b197-831f81a1d69d	11111111-1111-1111-1111-111111111111	order.settled	{"orderId": "82e2a068-a74a-4e18-89fe-7a423f5b243f", "amountMinor": "7350", "invoiceNumber": "INV-2026-00004", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-09-05 17:14:44.791+05:30	2026-09-05 17:14:45.559+05:30
d4f1761c-73ce-43b3-bbde-e8468cf84ca3	11111111-1111-1111-1111-111111111111	order.settled	{"orderId": "71ef893c-0ccc-439d-bc3e-0a248037303b", "amountMinor": "10904", "invoiceNumber": "INV-2026-00005", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-09-08 11:01:05.883+05:30	2026-09-08 11:01:06.149+05:30
c0db696f-ea71-48de-800f-608ef3ace8b4	11111111-1111-1111-1111-111111111111	order.settled	{"orderId": "1085cebe-ebf0-4804-83f3-aae6d0d4a7c9", "amountMinor": "77075", "invoiceNumber": "INV-2026-00006", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-09-08 11:10:47.915+05:30	2026-09-08 11:10:48.379+05:30
dd8ea28b-54fc-401c-bc6e-b8edc3c22882	11111111-1111-1111-1111-111111111111	order.settled	{"orderId": "e7d4d6cf-4838-43bd-8334-688d11302496", "amountMinor": "116025", "invoiceNumber": "INV-2026-00007", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-09-08 11:17:50.453+05:30	2026-09-08 11:17:51.985+05:30
be13dfbe-e902-4e3c-829e-c10e7f574a14	11111111-1111-1111-1111-111111111111	order.settled	{"orderId": "b101f725-9679-4cf3-9f0f-16adb200ecff", "amountMinor": "3150", "invoiceNumber": "INV-2026-00008", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-09-09 12:45:00.49+05:30	2026-09-09 12:45:01.451+05:30
d29ea696-2662-4471-a324-306c3ae4fdca	11111111-1111-1111-1111-111111111111	order.settled	{"orderId": "76692730-cd05-45cd-b8ad-9cc20ac9fc5a", "amountMinor": "7350", "invoiceNumber": "INV-2026-00009", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-09-09 12:47:11.565+05:30	2026-09-09 12:47:13.477+05:30
8708d67f-7a81-4fd5-b952-c378d897497a	11111111-1111-1111-1111-111111111111	order.settled	{"orderId": "0602cb47-3398-4ba0-b5da-87e23909efa3", "amountMinor": "534975", "invoiceNumber": "INV-2026-00010", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-09-09 12:51:03.289+05:30	2026-09-09 12:51:04.359+05:30
1449a584-3a27-4ddd-acbc-c3d15bc0b0c4	11111111-1111-1111-1111-111111111111	order.settled	{"orderId": "2d4b655e-a5bf-4900-ba0c-11e1b3c2685c", "amountMinor": "473025", "invoiceNumber": "INV-2026-00011", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-09-09 14:06:01.151+05:30	2026-09-09 14:06:02.968+05:30
3a63e8a5-9e20-4a94-9dde-fd32628fd809	11111111-1111-1111-1111-111111111111	order.settled	{"orderId": "eb13fd97-c972-4447-8a42-898eb545191e", "amountMinor": "21000", "invoiceNumber": "INV-2026-00012", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-09-09 14:07:07.633+05:30	2026-09-09 14:07:09.239+05:30
3c4cc1df-f270-4259-a4f1-6fcb097aaf02	11111111-1111-1111-1111-111111111111	order.settled	{"orderId": "f5d3449d-ce21-48cb-ab01-b41c41a7301c", "amountMinor": "45675", "invoiceNumber": "INV-2026-00013", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-09-09 14:07:29.961+05:30	2026-09-09 14:07:31.324+05:30
9e72b467-5274-4cfa-8496-8fcebadf1604	11111111-1111-1111-1111-111111111111	order.settled	{"orderId": "0a746ebb-ff2b-40d1-8d00-5e7652f56006", "amountMinor": "15225", "invoiceNumber": "INV-2026-00014", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-09-09 15:08:54.432+05:30	2026-09-09 15:08:56.105+05:30
f624578e-a034-4620-a9f0-3ad7293c50af	11111111-1111-1111-1111-111111111111	order.settled	{"orderId": "3e1ba9c8-0311-4534-a8d3-fa97b3a4f933", "amountMinor": "15500", "invoiceNumber": "INV-2026-00015", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-09-10 17:17:49.787+05:30	2026-09-10 17:17:51.578+05:30
f457348e-04a5-413e-a4cd-90a6d947e698	11111111-1111-1111-1111-111111111111	order.settled	{"orderId": "c8387bcf-ab67-44bb-87fb-d67f6d7601ca", "amountMinor": "17600", "invoiceNumber": "INV-2026-00016", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-09-11 12:34:34.943+05:30	2026-09-11 12:34:36.773+05:30
5e112515-9d99-4c76-940c-4af75203a6e5	11111111-1111-1111-1111-111111111111	order.settled	{"orderId": "27f9f630-3e8b-4ba9-b4d7-e631e45182f7", "amountMinor": "10250", "invoiceNumber": "INV-2026-00017", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-09-11 12:35:19.717+05:30	2026-09-11 12:35:20.92+05:30
4b126d0d-1653-4fb9-88d7-4aef2d03b3b5	11111111-1111-1111-1111-111111111111	order.settled	{"orderId": "4a4e9d6c-a797-4b03-9835-a44526c890e2", "amountMinor": "17600", "invoiceNumber": "INV-2026-00018", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-09-12 15:32:01.742+05:30	2026-09-12 15:32:02.121+05:30
dc417fb7-e294-4343-9f22-8e60fce42ed7	11111111-1111-1111-1111-111111111111	order.settled	{"orderId": "abaed738-9e4f-4470-ae04-031b3baa4721", "amountMinor": "19050", "invoiceNumber": "INV-2026-00019", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-09-12 16:05:48.012+05:30	2026-09-12 16:05:49.906+05:30
25da04d1-e255-4de8-b8ff-b70eb38091f8	11111111-1111-1111-1111-111111111111	order.settled	{"orderId": "8139a10d-c414-4402-818c-ea00cfd5e786", "amountMinor": "18900", "invoiceNumber": "INV-2026-00020", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-09-12 16:21:52.137+05:30	2026-09-12 16:21:53.14+05:30
271c36e3-2e5c-4db6-979f-1e4500fceccf	11111111-1111-1111-1111-111111111111	order.settled	{"orderId": "547361f1-ab65-4eeb-b5ae-790378f1eebc", "amountMinor": "8925", "invoiceNumber": "INV-2026-00021", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-09-12 16:22:52.554+05:30	2026-09-12 16:22:53.353+05:30
ee90f7e6-989d-4dbc-b5f9-25478bf12254	11111111-1111-1111-1111-111111111111	order.settled	{"orderId": "db187890-3de7-4a5d-87b2-9398153c343a", "amountMinor": "7350", "invoiceNumber": "INV-2026-00022", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-09-23 13:23:29.793+05:30	2026-09-23 13:23:30.732+05:30
3729f4aa-48c4-4aae-93f7-e1a8b53e4d6d	11111111-1111-1111-1111-111111111111	order.settled	{"orderId": "1469b1ab-dc07-49fd-979d-6393518fd684", "amountMinor": "17850", "invoiceNumber": "INV-2026-00023", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-10-02 16:57:54.869+05:30	2026-10-02 16:57:56.493+05:30
2712bcde-4b6a-4ddb-8bb5-9901bb471cc0	11111111-1111-1111-1111-111111111111	order.settled	{"orderId": "53494c1e-ee68-4197-b271-2a8c5f2bdb26", "amountMinor": "17850", "invoiceNumber": "INV-2026-00024", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-10-02 16:59:07.804+05:30	2026-10-02 16:59:08.912+05:30
40624519-fc20-4f09-8da5-d8f344e2ab81	11111111-1111-1111-1111-111111111111	order.settled	{"orderId": "89dba099-01ad-417a-a438-66ca8af5e712", "amountMinor": "11550", "invoiceNumber": "INV-2026-00025", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-10-03 01:21:43.148+05:30	2026-10-03 01:21:43.163+05:30
c22a2649-4dd7-419a-9adc-85c5e238c299	11111111-1111-1111-1111-111111111111	order.settled	{"orderId": "7bf0131c-f022-46a1-9a7b-8569cd3682f8", "amountMinor": "76650", "invoiceNumber": "INV-2026-00026", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-10-03 01:23:42.521+05:30	2026-10-03 01:23:43.614+05:30
9ac26b1c-c5cc-4878-b8dc-9c3599055f5f	11111111-1111-1111-1111-111111111111	order.settled	{"orderId": "af21c0cc-a9e8-459c-b797-ddb34bb7f724", "amountMinor": "6300", "invoiceNumber": "INV-2026-00027", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-10-03 01:24:20.014+05:30	2026-10-03 01:24:21.791+05:30
97c18c66-7a01-4bb1-8492-d5d3b3b6c857	11111111-1111-1111-1111-111111111111	order.settled	{"orderId": "b7899f9e-fd1e-4f77-89fc-0d935c2e2d85", "amountMinor": "8400", "invoiceNumber": "INV-2026-00028", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-10-03 01:24:33.899+05:30	2026-10-03 01:24:35.844+05:30
9f048535-a51b-4bf7-a071-b41bba5a42b9	11111111-1111-1111-1111-111111111111	order.settled	{"orderId": "c81161e9-bd67-474a-bf80-3b1756fe5393", "amountMinor": "6300", "invoiceNumber": "INV-2026-00029", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-10-03 01:26:31.13+05:30	2026-10-03 01:26:32.302+05:30
e9c39e70-6a0c-4ef7-ae51-b625fc7dfbbe	11111111-1111-1111-1111-111111111111	order.settled	{"orderId": "de5f32b6-72f6-441d-a98f-3f273e2a3bba", "amountMinor": "6300", "invoiceNumber": "INV-2026-00030", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-10-03 01:27:32.922+05:30	2026-10-03 01:27:34.476+05:30
ac6b7106-afca-40ce-8e2d-8e37e01b54e7	11111111-1111-1111-1111-111111111111	order.settled	{"orderId": "6dcda227-21c2-4291-918f-a3813a9062eb", "amountMinor": "16800", "invoiceNumber": "INV-2026-00031", "paymentMethod": "CASH"}	PROCESSED	0	5	\N	2026-10-03 04:38:00.205+05:30	2026-10-03 04:38:00.466+05:30
\.


--
-- Data for Name: outlet_billing_settings; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.outlet_billing_settings (id, outlet_id, bill_prefix, kot_prefix, round_off_enabled, round_off_nearest, service_charge_enabled, service_charge_percent, allow_discount_without_approval, max_discount_percent, require_customer_phone, require_otp_for_online, created_at, updated_at, extended_settings) FROM stdin;
41af6efb-5c2c-42ee-9449-715f00d431d7	67315042-c687-4cbb-b45a-f4ea4efc199f	INV-	KOT-	t	1.00	f	0.000	f	50.000	f	f	2026-09-03 12:29:17.383865+05:30	2026-09-03 12:29:17.383865+05:30	{}
\.


--
-- Data for Name: outlet_print_settings; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.outlet_print_settings (id, outlet_id, printer_name, paper_width_mm, print_logo, print_gstin, print_fssai_number, print_customer_details, auto_print_kot_on_place, auto_print_bill_on_settle, kot_copies, bill_copies, footer_message, created_at, updated_at, extended_settings) FROM stdin;
f7cbeecc-2cb7-4926-86d2-901c4e4ecc67	67315042-c687-4cbb-b45a-f4ea4efc199f	Kitchen Thermal 80mm	80	f	t	t	t	t	t	1	1	Thank you for dining at Hotel Kapila! Please visit again.	2026-09-03 12:29:17.390448+05:30	2026-09-03 12:29:17.390448+05:30	{}
\.


--
-- Data for Name: outlet_status; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.outlet_status (outlet_id, is_online, updated_at, updated_by, dine_in_active, delivery_active, takeaway_active) FROM stdin;
67315042-c687-4cbb-b45a-f4ea4efc199f	t	2026-09-05 13:04:10.655714+05:30	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	t	t	t
11111111-1111-1111-1111-111111111111	t	2026-10-03 15:43:36.177533+05:30	9b35fd7a-2717-4837-ad91-9328aee9ec5f	t	t	t
\.


--
-- Data for Name: outlets; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.outlets (id, organization_id, code, name, timezone, currency, day_start_time, is_active, created_at, updated_at, created_by, updated_by, loyalty_paise_per_point, phone, email, logo_url, last_menu_sync_at, address, fssai_number, upi_vpa, status) FROM stdin;
67315042-c687-4cbb-b45a-f4ea4efc199f	00000000-0000-0000-0000-000000000000	NZB-01	Hotel Kapila	Asia/Kolkata	INR	06:00	t	2026-09-02 14:45:15.177+05:30	2026-09-02 16:21:33.117+05:30	\N	\N	\N	\N	\N	\N	\N	Pragathi Nagar, Central Nizamabad, Telangana 503001	\N	\N	\N
2a543c3c-066f-4097-833a-df7c25700580	00000000-0000-0000-0000-000000000000	R327038	Hotel kapila	Asia/Kolkata	INR	06:00	t	2026-09-02 16:33:25.646+05:30	2026-09-02 16:33:25.646+05:30	\N	\N	\N	\N	\N	\N	\N	Pragathi Nagar, Central Nizamabad, Telangana 503001	\N	\N	\N
11111111-1111-1111-1111-111111111111	00000000-0000-0000-0000-000000000000	MAIN-01	Hotel Kapila (Main Outlet)	Asia/Kolkata	INR	05:00:00	t	2026-09-03 12:49:54.098928+05:30	2026-09-03 12:49:54.098928+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: payment_summary; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.payment_summary (id, outlet_id, business_date, method, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: payment_type_master; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.payment_type_master (id, outlet_id, label, is_online, is_active, sort_order, created_at, updated_at) FROM stdin;
3677d05b-c463-40f5-95fa-c5fa8de4db34	67315042-c687-4cbb-b45a-f4ea4efc199f	Cash	f	t	1	2026-09-03 12:29:17.35798+05:30	2026-09-03 12:29:17.35798+05:30
965dc54c-6c57-49e5-a7a3-45d6dfd6ca8a	67315042-c687-4cbb-b45a-f4ea4efc199f	Card (EDC Terminal)	f	t	2	2026-09-03 12:29:17.371913+05:30	2026-09-03 12:29:17.371913+05:30
b6eae7c6-fb39-4458-96f8-3dcd06a05662	67315042-c687-4cbb-b45a-f4ea4efc199f	UPI / QR Code	f	t	3	2026-09-03 12:29:17.37303+05:30	2026-09-03 12:29:17.37303+05:30
e796da65-0988-4fc4-9426-1bb8a231e2b7	67315042-c687-4cbb-b45a-f4ea4efc199f	Swiggy Settlement	t	t	4	2026-09-03 12:29:17.374352+05:30	2026-09-03 12:29:17.374352+05:30
192bb89f-a715-4dca-8361-827ca4f8afdf	67315042-c687-4cbb-b45a-f4ea4efc199f	Zomato Settlement	t	t	5	2026-09-03 12:29:17.375526+05:30	2026-09-03 12:29:17.375526+05:30
d4e82ea0-7e59-48f3-88e6-6a978dc75c4d	67315042-c687-4cbb-b45a-f4ea4efc199f	Room Service / Due	f	t	6	2026-09-03 12:29:17.376607+05:30	2026-09-03 12:29:17.376607+05:30
23608557-96f5-4666-8fc8-895961345d64	67315042-c687-4cbb-b45a-f4ea4efc199f	Complimentary / House	f	t	7	2026-09-03 12:29:17.377803+05:30	2026-09-03 12:29:17.377803+05:30
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.payments (id, outlet_id, order_id, amount, method, status, transaction_id, idempotency_key, created_at, seat_id, order_seat_bill_id, seat_number) FROM stdin;
589efb55-2a0d-4c79-8ba3-d5677f01c155	11111111-1111-1111-1111-111111111111	e7eccfdc-02d5-470f-869b-da665f7dcb2e	37250	CASH	CAPTURED	\N	7771eb3f-df7f-45f2-b1ab-2ee6dc19c978	2026-09-04 00:03:15.362+05:30	\N	\N	\N
1a3d604c-edec-4c9a-87ab-648a8bbf133c	11111111-1111-1111-1111-111111111111	0f621958-d193-4d99-b6ef-037fcea9cd0a	16800	CASH	CAPTURED	\N	9bbfa8fd-01de-4011-9620-fab6d2fc5140	2026-09-04 00:06:34.67+05:30	\N	\N	\N
9c5e5749-9c4f-4e49-9355-80afe225f04e	11111111-1111-1111-1111-111111111111	ece12171-62db-4f53-ba97-d5e93e06f733	15750	CASH	CAPTURED	\N	da41cd2a-b4a4-47c4-abc7-71defaaea79e	2026-09-04 01:14:43.206+05:30	\N	\N	\N
923c400d-2aa6-40e9-bff1-a6777d7c075e	11111111-1111-1111-1111-111111111111	b5177d27-2e27-4abd-8296-83a748730b2c	16800	CASH	CAPTURED	\N	8011ea2d-8a8a-4750-9f25-6751677ff02f	2026-09-04 01:19:56.899+05:30	\N	\N	\N
a23c5ed2-25df-4ffd-a6a0-e8d8d6729f43	11111111-1111-1111-1111-111111111111	a00d57c3-c01d-49d0-9166-45e9f7e22497	47250	CASH	CAPTURED	\N	b9694bae-815c-4bb1-a1ef-90ab640ba16d	2026-09-05 13:22:05.597+05:30	\N	\N	\N
2feeaab6-7543-447d-a565-a8104b9eb3eb	11111111-1111-1111-1111-111111111111	0f3580d0-cceb-4289-99f8-5ffdf1669b18	5250	CASH	CAPTURED	\N	a8e61bb6-6f19-45aa-8d64-fb9fef6f911b	2026-09-05 15:10:12.788+05:30	\N	\N	\N
ffcfae6a-f1e2-418d-94fa-cb1c38179fd3	67315042-c687-4cbb-b45a-f4ea4efc199f	5b433b06-af43-4f62-8a6b-e2ca1e0bfa88	35700	CASH	CAPTURED	\N	ee563f61-47b1-488c-84f1-51333c21790e	2026-09-05 16:45:42.138+05:30	\N	\N	\N
2e8207de-394f-40ad-bd95-84b3b2998a9b	11111111-1111-1111-1111-111111111111	7a369854-faf1-4af3-8378-8b939249c434	6825	CASH	CAPTURED	\N	db031719-7d90-4828-baf9-165aaf6f70cb	2026-09-05 16:51:32.866+05:30	\N	\N	\N
cd2961e5-434c-4fd7-a178-659c524137f0	11111111-1111-1111-1111-111111111111	82e2a068-a74a-4e18-89fe-7a423f5b243f	7350	CASH	CAPTURED	\N	ad25de24-a6f2-4e38-a4ac-02d3e6cd20e0	2026-09-05 17:14:44.751+05:30	\N	\N	\N
1761086d-1e14-4acd-8f1c-a5cbcf3e80d8	11111111-1111-1111-1111-111111111111	71ef893c-0ccc-439d-bc3e-0a248037303b	10904	CASH	CAPTURED	\N	58fadf16-22f1-4477-b1e2-0c1ec66f3390	2026-09-08 11:01:05.774+05:30	\N	\N	\N
e4630b40-86f0-4b79-8e21-9053a0db4ab3	11111111-1111-1111-1111-111111111111	1085cebe-ebf0-4804-83f3-aae6d0d4a7c9	77075	CASH	CAPTURED	\N	48aea828-6500-43aa-9ca8-8140b778a22d	2026-09-08 11:10:47.798+05:30	\N	\N	\N
83cadcc5-c2f6-4381-a36a-052d8b48b380	11111111-1111-1111-1111-111111111111	e7d4d6cf-4838-43bd-8334-688d11302496	116025	CASH	CAPTURED	\N	cecfa6b9-0b8a-4582-a52f-3ec156c6b13c	2026-09-08 11:17:50.355+05:30	\N	\N	\N
f055326e-c3d8-4686-83ec-f739c167e7b9	11111111-1111-1111-1111-111111111111	b101f725-9679-4cf3-9f0f-16adb200ecff	3150	CASH	CAPTURED	\N	3aacc70e-41f1-44c5-b18f-eef721290735	2026-09-09 12:45:00.343+05:30	\N	\N	\N
77c1b0ca-ce68-49e9-a5ad-b8918a3df29f	11111111-1111-1111-1111-111111111111	76692730-cd05-45cd-b8ad-9cc20ac9fc5a	7350	CASH	CAPTURED	\N	e8434293-59db-46b2-a41b-c487f7722882	2026-09-09 12:47:11.456+05:30	\N	\N	\N
e605aa7d-04d2-4273-9088-89bcf90688b1	11111111-1111-1111-1111-111111111111	0602cb47-3398-4ba0-b5da-87e23909efa3	534975	CASH	CAPTURED	\N	d53159df-e69e-4495-b603-f8521951b5e7	2026-09-09 12:51:03.181+05:30	\N	\N	\N
5274906f-8668-478b-82e7-03b15eeb777e	11111111-1111-1111-1111-111111111111	2d4b655e-a5bf-4900-ba0c-11e1b3c2685c	473025	CASH	CAPTURED	\N	2f7eba42-e459-4c8b-a3ad-0bd237643f74	2026-09-09 14:06:01.082+05:30	\N	\N	\N
2d505e0f-6dd7-411b-8bce-9a1ca5c7ef05	11111111-1111-1111-1111-111111111111	eb13fd97-c972-4447-8a42-898eb545191e	21000	CASH	CAPTURED	\N	fccc09ce-4f79-4746-84f5-002d454d4cc5	2026-09-09 14:07:07.588+05:30	\N	\N	\N
35ad0d01-e3e1-4272-bcab-b8009bf61358	11111111-1111-1111-1111-111111111111	f5d3449d-ce21-48cb-ab01-b41c41a7301c	45675	CASH	CAPTURED	\N	7c57da93-2c0c-444b-ac16-2e1e547d738d	2026-09-09 14:07:29.929+05:30	\N	\N	\N
2a7ca9cc-5903-4193-bdfc-bf5bbe9e2e64	11111111-1111-1111-1111-111111111111	0a746ebb-ff2b-40d1-8d00-5e7652f56006	15225	CASH	CAPTURED	\N	6372fd14-0374-4686-a38e-30db9872580e	2026-09-09 15:08:54.365+05:30	\N	\N	\N
1d81be04-8b53-4beb-b11c-b4cfbaef9c97	11111111-1111-1111-1111-111111111111	3e1ba9c8-0311-4534-a8d3-fa97b3a4f933	15500	CASH	CAPTURED	\N	04049be6-12d8-49b2-8a0e-39be69087dd6	2026-09-10 17:17:49.646+05:30	\N	\N	\N
dab22667-14a1-457f-99ee-7116b8b01c13	11111111-1111-1111-1111-111111111111	c8387bcf-ab67-44bb-87fb-d67f6d7601ca	17600	CASH	CAPTURED	\N	0909b4c1-fb47-4214-bb4e-e3f4f8638d2d	2026-09-11 12:34:34.833+05:30	\N	\N	\N
287e9dac-3cdc-455d-89db-015a7b0a2b43	11111111-1111-1111-1111-111111111111	27f9f630-3e8b-4ba9-b4d7-e631e45182f7	10250	CASH	CAPTURED	\N	de02b7c9-6a63-4f66-8b4c-f2ecdad964ac	2026-09-11 12:35:19.618+05:30	\N	\N	\N
33787728-0141-444e-80ba-cb3d953fd707	11111111-1111-1111-1111-111111111111	4a4e9d6c-a797-4b03-9835-a44526c890e2	17600	CASH	CAPTURED	\N	a4a3c28c-e93f-4e2c-883c-0dd92aee7cd9	2026-09-12 15:32:01.559+05:30	\N	\N	\N
b71a774b-e736-4284-a1ab-2d7b108f9bad	11111111-1111-1111-1111-111111111111	abaed738-9e4f-4470-ae04-031b3baa4721	19050	CASH	CAPTURED	\N	be324c34-d449-4232-a1ef-c22cadb3f8e6	2026-09-12 16:05:47.906+05:30	\N	\N	\N
b91471cb-4f98-4b75-9192-c05fc726d96a	11111111-1111-1111-1111-111111111111	8139a10d-c414-4402-818c-ea00cfd5e786	18900	CASH	CAPTURED	\N	9c24e4b7-3d0c-4322-98b3-08c413381774	2026-09-12 16:21:52.046+05:30	\N	\N	\N
c24deced-ba82-4622-9292-ddd4b4903f30	11111111-1111-1111-1111-111111111111	547361f1-ab65-4eeb-b5ae-790378f1eebc	8925	CASH	CAPTURED	\N	5039031c-863e-4a2b-b588-0b347abfa52c	2026-09-12 16:22:52.438+05:30	\N	\N	\N
f367414d-0407-4dd6-8da4-8e1b19d7d27b	11111111-1111-1111-1111-111111111111	db187890-3de7-4a5d-87b2-9398153c343a	7350	CASH	CAPTURED	\N	0ceb913c-19cd-4f41-a9c1-179595843ee6	2026-09-23 13:23:29.742+05:30	\N	\N	\N
ca0ebda9-187c-4b47-9ff7-5ab6eca4dde9	11111111-1111-1111-1111-111111111111	900efa09-cbd9-4da9-8897-1b837e07b788	22850	UPI	CAPTURED	\N	5b9a1860-01d9-4d1c-bab7-d4386aa2601d	2026-09-24 23:32:07.608+05:30	\N	\N	\N
a222ff5e-23b7-4e6e-a8f3-12c00f0e6422	11111111-1111-1111-1111-111111111111	f4fbbe17-c9da-40cc-a954-1b9d7d1d6752	22850	UPI	CAPTURED	\N	de872999-3788-4a7d-a3fd-742f303deb05	2026-09-24 23:48:19.638+05:30	\N	\N	\N
84891eed-5586-45d1-9a1a-7480ec1fbdac	11111111-1111-1111-1111-111111111111	51ee39c7-53f2-40c4-adae-b49600c041f7	22850	UPI	CAPTURED	\N	14b14031-cee0-4bda-b340-21750ccb9d1d	2026-09-24 23:54:20.032+05:30	\N	\N	\N
c1c63ef2-616d-4969-83c7-a06e66d1dfe0	11111111-1111-1111-1111-111111111111	3d9c934c-97d3-4da2-8f4b-4772896ee29b	22850	UPI	CAPTURED	\N	67806ba8-88e5-4a5b-8a57-66a88377fb27	2026-09-25 00:07:01.742+05:30	\N	\N	\N
fb71c56e-dc81-441e-8966-044a67b49873	11111111-1111-1111-1111-111111111111	1469b1ab-dc07-49fd-979d-6393518fd684	17850	CASH	CAPTURED	\N	a4f0800d-9f3d-4d34-8b36-46380cad1522	2026-10-02 16:57:54.802+05:30	\N	\N	\N
e72b9222-2538-4405-8212-8b7f6a86de25	11111111-1111-1111-1111-111111111111	53494c1e-ee68-4197-b271-2a8c5f2bdb26	17850	CASH	CAPTURED	\N	2febfbfc-dc2f-4b97-b1ab-f95dcb12374a	2026-10-02 16:59:07.77+05:30	\N	\N	\N
42dac6f1-9a73-40b8-893f-3f288857bc9d	11111111-1111-1111-1111-111111111111	89dba099-01ad-417a-a438-66ca8af5e712	11550	CASH	CAPTURED	\N	5fbb7332-a63e-4d32-95af-6eac3de75e2a	2026-10-03 01:21:43.086+05:30	\N	\N	\N
0b8dbea6-ba1d-4949-89e8-c1a214c17ba0	11111111-1111-1111-1111-111111111111	7bf0131c-f022-46a1-9a7b-8569cd3682f8	76650	CASH	CAPTURED	\N	6bc72b03-54ee-4287-8f3b-653268aecd23	2026-10-03 01:23:42.475+05:30	\N	\N	\N
873136f3-1c61-40ec-b181-fa4226ac0bf3	11111111-1111-1111-1111-111111111111	af21c0cc-a9e8-459c-b797-ddb34bb7f724	6300	CASH	CAPTURED	\N	89a0d98e-2f18-4439-9056-056e9223b4c5	2026-10-03 01:24:19.989+05:30	\N	\N	\N
5f4ff1c4-7ea9-45e1-9fef-0f2b52fb5f34	11111111-1111-1111-1111-111111111111	b7899f9e-fd1e-4f77-89fc-0d935c2e2d85	8400	CASH	CAPTURED	\N	a8e967e0-c60d-45d4-bf64-90eaa6982909	2026-10-03 01:24:33.818+05:30	\N	\N	\N
611a2b58-36c1-4b5e-ac48-8056d2494c34	11111111-1111-1111-1111-111111111111	c81161e9-bd67-474a-bf80-3b1756fe5393	6300	CASH	CAPTURED	\N	f9e38fd5-d3f9-42ac-a6e7-0dd167c01e9a	2026-10-03 01:26:31.098+05:30	\N	\N	\N
9478e3c3-5069-427d-ab77-61ef848c4428	11111111-1111-1111-1111-111111111111	de5f32b6-72f6-441d-a98f-3f273e2a3bba	6300	CASH	CAPTURED	\N	673cafd7-7503-4ee4-b2c4-4f5016a17093	2026-10-03 01:27:32.87+05:30	\N	\N	\N
af4ad8f3-c209-497b-9376-f4ab3d7b489b	11111111-1111-1111-1111-111111111111	6dcda227-21c2-4291-918f-a3813a9062eb	16800	CASH	CAPTURED	\N	e00f5b3b-8b23-4d29-81ae-39f3052a045d	2026-10-03 04:38:00.158+05:30	\N	\N	\N
\.


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.permissions (id, code, module, description, created_by, updated_by, action, created_at, updated_at) FROM stdin;
a25fd2be-6972-4e06-bfe7-32e1877b53c3	order.create	order	Permission for order.create	\N	\N	order.create	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
fd6326f7-7866-46ab-b23d-159edbf94a27	order.read	order	Permission for order.read	\N	\N	order.read	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
8b5689a3-0c2b-4cad-a66f-49e0ae75daf9	order.update	order	Permission for order.update	\N	\N	order.update	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
08a791ca-1ef7-4b29-98a6-f02820b2a2b3	order.cancel	order	Permission for order.cancel	\N	\N	order.cancel	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
efec4365-ca52-4d5a-bd0f-02eef073296e	order.discount	order	Permission for order.discount	\N	\N	order.discount	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
3715b443-1ed9-4163-89bd-cf4fb359ceb3	kot.create	kot	Permission for kot.create	\N	\N	kot.create	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
618f709f-c32a-4e90-b129-3968ecf195b1	kot.read	kot	Permission for kot.read	\N	\N	kot.read	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
72282ca2-b8cc-4afb-b717-b5cef31b69eb	kot.update	kot	Permission for kot.update	\N	\N	kot.update	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
c892c4d5-644b-4853-83ee-f8dea5b6b952	kot.recall	kot	Permission for kot.recall	\N	\N	kot.recall	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
61f8d56b-7d29-4b08-b728-55e1364ec396	kot.manage	kot	Permission for kot.manage	\N	\N	kot.manage	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
50aecead-81be-4f41-b193-f4e8cc5f288d	table.read	table	Permission for table.read	\N	\N	table.read	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
7f18dc65-6e0a-467d-abe4-4f524b6e824e	table.transfer	table	Permission for table.transfer	\N	\N	table.transfer	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
5132d049-a00b-4489-9fad-2a55f51288ae	table.merge	table	Permission for table.merge	\N	\N	table.merge	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
1be9c022-ee67-46c2-ad71-cb9b23573f78	table.split	table	Permission for table.split	\N	\N	table.split	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
a8cc5bc1-bd12-42f3-9a5d-48ae4eb968e0	table.manage	table	Permission for table.manage	\N	\N	table.manage	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
bd09155b-91a2-4cd1-aa71-85a71bebb6be	bill.generate	bill	Permission for bill.generate	\N	\N	bill.generate	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
5d67b45d-285b-4de3-9466-7cf7467066ff	bill.settle	bill	Permission for bill.settle	\N	\N	bill.settle	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
00f5e8cd-1577-4986-8c2a-3ffafec22c25	bill.reprint	bill	Permission for bill.reprint	\N	\N	bill.reprint	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
2ab7f1c2-5fee-4861-bd89-0a1485df0ff4	bill.split	bill	Permission for bill.split	\N	\N	bill.split	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
d656bceb-ad28-4bdb-a4ce-361c02ebb2fe	payment.collect	payment	Permission for payment.collect	\N	\N	payment.collect	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
aceee97c-05c1-481f-b853-e79678ec5fad	payment.refund	payment	Permission for payment.refund	\N	\N	payment.refund	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
3bccf399-64ea-4574-904b-7db52741e624	payment.split	payment	Permission for payment.split	\N	\N	payment.split	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
99bf49fb-b3be-483b-b9dc-371f82b61227	menu.read	menu	Permission for menu.read	\N	\N	menu.read	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
3330a0b6-69a1-41eb-b880-0aabbc119e6d	menu.category.manage	menu	Permission for menu.category.manage	\N	\N	menu.category.manage	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
38e7d69b-0ad9-4f4f-9802-634c46adf192	menu.item.manage	menu	Permission for menu.item.manage	\N	\N	menu.item.manage	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
a6f18fbf-32ac-4ada-9e03-e7c86d19c110	menu.86.toggle	menu	Permission for menu.86.toggle	\N	\N	menu.86.toggle	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
694f4856-6a52-4c7e-a1d0-cd51f73d03bf	inventory.read	inventory	Permission for inventory.read	\N	\N	inventory.read	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
2c91df97-2384-4b82-b13f-43e6ca0c7a80	inventory.stock.adjust	inventory	Permission for inventory.stock.adjust	\N	\N	inventory.stock.adjust	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
aeadb674-5e88-4c38-a97b-ee14bf4ff355	inventory.po.create	inventory	Permission for inventory.po.create	\N	\N	inventory.po.create	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
08ed13ed-85b5-4211-a02c-aab1539a566d	inventory.po.approve	inventory	Permission for inventory.po.approve	\N	\N	inventory.po.approve	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
8871d288-9daa-4eb5-a117-b3df41e7f90f	inventory.grn.create	inventory	Permission for inventory.grn.create	\N	\N	inventory.grn.create	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
0a410ae9-158a-4fd2-9a8a-767adad7438a	inventory.write	inventory	Permission for inventory.write	\N	\N	inventory.write	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
bd732c4a-9f28-4a9f-8351-67ea192e41e0	inventory.stock.deduct	inventory	Permission for inventory.stock.deduct	\N	\N	inventory.stock.deduct	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
ce5bb0f0-2d74-4992-9112-c3731245eece	report.read	report	Permission for report.read	\N	\N	report.read	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
ef301064-b9ad-4a59-8734-738902495e39	report.financial.read	report	Permission for report.financial.read	\N	\N	report.financial.read	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
6d0c2f3f-4963-4667-81bc-85f323c9dfd1	report.audit.read	report	Permission for report.audit.read	\N	\N	report.audit.read	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
8fb93c32-2d85-4523-88e1-e9ab0a6ff005	report.export	report	Permission for report.export	\N	\N	report.export	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
a93fa551-c915-463e-9908-fb0019bd6f53	report.zreport	report	Permission for report.zreport	\N	\N	report.zreport	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
e3ee6f6b-7a52-4a46-960f-16a9e4566384	finance.report	finance	Permission for finance.report	\N	\N	finance.report	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
92830514-8a1a-4fb6-b402-7c9fb0e50f3d	finance.cash_drawer.manage	finance	Permission for finance.cash_drawer.manage	\N	\N	finance.cash_drawer.manage	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
6f91a8c7-45ec-4365-bb3a-e2b133543ebd	finance.petty_cash.record	finance	Permission for finance.petty_cash.record	\N	\N	finance.petty_cash.record	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
843937ff-2c69-4a15-9f3b-efb797479e75	crm.read	crm	Permission for crm.read	\N	\N	crm.read	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
35ba8ece-6851-43b4-bf0c-0a94c6da6a3b	crm.write	crm	Permission for crm.write	\N	\N	crm.write	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
8823c15e-ac5d-454a-bbe0-fe36d13b9fee	crm.loyalty.redeem	crm	Permission for crm.loyalty.redeem	\N	\N	crm.loyalty.redeem	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
3848292e-d6da-42ed-8e23-bcacf351427c	crm.loyalty.issue	crm	Permission for crm.loyalty.issue	\N	\N	crm.loyalty.issue	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
57387649-ae7f-4746-8953-2d991f6c84ea	settings.read	settings	Permission for settings.read	\N	\N	settings.read	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
59a02a0a-a40e-47c8-a42a-b55e32e7a4b1	settings.manage	settings	Permission for settings.manage	\N	\N	settings.manage	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
89b44b18-354b-4168-ba5d-76e949383a29	users.manage	users	Permission for users.manage	\N	\N	users.manage	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
0ab3bfed-93a7-4ef2-8771-09ce18e9e806	users.read	users	Permission for users.read	\N	\N	users.read	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
c74767a0-3fcc-498c-b74f-372b455069bb	outlets.manage	outlets	Permission for outlets.manage	\N	\N	outlets.manage	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
cef337ed-68b7-48c3-85be-937880107882	roles.manage	roles	Permission for roles.manage	\N	\N	roles.manage	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
6719b819-92e9-410c-a975-a26f5fcf744d	integration.manage	integration	Permission for integration.manage	\N	\N	integration.manage	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
a975d9ea-ecfa-480b-89d2-908db5cc336a	integration.sync	integration	Permission for integration.sync	\N	\N	integration.sync	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
c39074a4-72b7-4203-a00d-308c7cb97e9a	audit.read	audit	Permission for audit.read	\N	\N	audit.read	2026-09-03 13:02:50.015095+05:30	2026-09-03 13:02:50.017419+05:30
\.


--
-- Data for Name: petty_cash_ledger; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.petty_cash_ledger (id, outlet_id, amount_minor, category, description, recorded_by, cash_drawer_session_id, created_at, paid_to) FROM stdin;
\.


--
-- Data for Name: physical_menu_files; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.physical_menu_files (id, outlet_id, file_name, file_url, uploaded_by_user_id, uploaded_at, created_at) FROM stdin;
\.


--
-- Data for Name: price_lists; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.price_lists (id, outlet_id, channel_id, name, effective_from, effective_to, is_active, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: purchase_order_items; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.purchase_order_items (id, po_id, ingredient_id, quantity, unit_price_minor, total_minor, created_at, received_qty) FROM stdin;
\.


--
-- Data for Name: purchase_orders; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.purchase_orders (id, outlet_id, vendor_id, po_number, total_amount_minor, status, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: recipe_ingredients; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.recipe_ingredients (id, recipe_id, ingredient_id, quantity, created_at, yield_percent, updated_at) FROM stdin;
ff7c3ab1-f7aa-4833-9c42-b4c7fb49240c	12eabedd-f2c0-4dab-98cf-7f080acee451	d78382d7-01dd-4e51-a6d9-374e54182a54	0.250	2026-09-02 17:56:41.916832+05:30	100	2026-09-02 17:56:41.916832+05:30
b838c170-0d06-4683-99b5-098cc0e55429	12eabedd-f2c0-4dab-98cf-7f080acee451	f811d9a2-42c3-45dd-b45a-15ee97731274	0.200	2026-09-02 17:56:41.924392+05:30	85	2026-09-02 17:56:41.924392+05:30
57fb0988-4cd2-4c8b-8497-4e21f9b5c199	97517262-cc02-492b-a9ac-bc42bb784c9a	f811d9a2-42c3-45dd-b45a-15ee97731274	0.200	2026-09-02 17:56:41.945971+05:30	85	2026-09-02 17:56:41.945971+05:30
078aa035-9794-4ba5-8d47-b9ef5f66157a	97517262-cc02-492b-a9ac-bc42bb784c9a	66ae2eba-88d4-47ce-bdfd-8e11320952ab	0.150	2026-09-02 17:56:41.950259+05:30	100	2026-09-02 17:56:41.950259+05:30
\.


--
-- Data for Name: recipes; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.recipes (id, outlet_id, menu_item_id, name, yield_portions, is_active, created_at, updated_at, created_by, updated_by, version, effective_from) FROM stdin;
12eabedd-f2c0-4dab-98cf-7f080acee451	67315042-c687-4cbb-b45a-f4ea4efc199f	1048c560-86bd-45c5-b872-eb5e802c6e46		1.00	t	2026-09-02 17:56:41.901+05:30	2026-09-02 17:56:41.901+05:30	\N	\N	1	\N
97517262-cc02-492b-a9ac-bc42bb784c9a	67315042-c687-4cbb-b45a-f4ea4efc199f	cdc12a71-3f32-4630-ab8b-059ae196af2c		1.00	t	2026-09-02 17:56:41.941+05:30	2026-09-02 17:56:41.941+05:30	\N	\N	1	\N
\.


--
-- Data for Name: restaurant_tables; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.restaurant_tables (id, outlet_id, zone, table_no, capacity, is_active, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.role_permissions (role_id, permission_id, created_at) FROM stdin;
11111111-1111-1111-1111-111111111102	a25fd2be-6972-4e06-bfe7-32e1877b53c3	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	fd6326f7-7866-46ab-b23d-159edbf94a27	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	8b5689a3-0c2b-4cad-a66f-49e0ae75daf9	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	08a791ca-1ef7-4b29-98a6-f02820b2a2b3	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	efec4365-ca52-4d5a-bd0f-02eef073296e	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	3715b443-1ed9-4163-89bd-cf4fb359ceb3	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	618f709f-c32a-4e90-b129-3968ecf195b1	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	72282ca2-b8cc-4afb-b717-b5cef31b69eb	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	c892c4d5-644b-4853-83ee-f8dea5b6b952	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	61f8d56b-7d29-4b08-b728-55e1364ec396	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	50aecead-81be-4f41-b193-f4e8cc5f288d	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	7f18dc65-6e0a-467d-abe4-4f524b6e824e	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	5132d049-a00b-4489-9fad-2a55f51288ae	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	1be9c022-ee67-46c2-ad71-cb9b23573f78	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	a8cc5bc1-bd12-42f3-9a5d-48ae4eb968e0	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	bd09155b-91a2-4cd1-aa71-85a71bebb6be	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	5d67b45d-285b-4de3-9466-7cf7467066ff	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	00f5e8cd-1577-4986-8c2a-3ffafec22c25	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	2ab7f1c2-5fee-4861-bd89-0a1485df0ff4	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	d656bceb-ad28-4bdb-a4ce-361c02ebb2fe	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	aceee97c-05c1-481f-b853-e79678ec5fad	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	3bccf399-64ea-4574-904b-7db52741e624	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	99bf49fb-b3be-483b-b9dc-371f82b61227	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	3330a0b6-69a1-41eb-b880-0aabbc119e6d	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	38e7d69b-0ad9-4f4f-9802-634c46adf192	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	a6f18fbf-32ac-4ada-9e03-e7c86d19c110	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	694f4856-6a52-4c7e-a1d0-cd51f73d03bf	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	2c91df97-2384-4b82-b13f-43e6ca0c7a80	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	aeadb674-5e88-4c38-a97b-ee14bf4ff355	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	08ed13ed-85b5-4211-a02c-aab1539a566d	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	8871d288-9daa-4eb5-a117-b3df41e7f90f	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	0a410ae9-158a-4fd2-9a8a-767adad7438a	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	bd732c4a-9f28-4a9f-8351-67ea192e41e0	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	ce5bb0f0-2d74-4992-9112-c3731245eece	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	ef301064-b9ad-4a59-8734-738902495e39	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	6d0c2f3f-4963-4667-81bc-85f323c9dfd1	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	8fb93c32-2d85-4523-88e1-e9ab0a6ff005	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	a93fa551-c915-463e-9908-fb0019bd6f53	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	e3ee6f6b-7a52-4a46-960f-16a9e4566384	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	92830514-8a1a-4fb6-b402-7c9fb0e50f3d	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	6f91a8c7-45ec-4365-bb3a-e2b133543ebd	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	843937ff-2c69-4a15-9f3b-efb797479e75	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	35ba8ece-6851-43b4-bf0c-0a94c6da6a3b	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	8823c15e-ac5d-454a-bbe0-fe36d13b9fee	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	3848292e-d6da-42ed-8e23-bcacf351427c	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	57387649-ae7f-4746-8953-2d991f6c84ea	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	59a02a0a-a40e-47c8-a42a-b55e32e7a4b1	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	89b44b18-354b-4168-ba5d-76e949383a29	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	0ab3bfed-93a7-4ef2-8771-09ce18e9e806	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	c74767a0-3fcc-498c-b74f-372b455069bb	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	cef337ed-68b7-48c3-85be-937880107882	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	6719b819-92e9-410c-a975-a26f5fcf744d	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	a975d9ea-ecfa-480b-89d2-908db5cc336a	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111102	c39074a4-72b7-4203-a00d-308c7cb97e9a	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	a25fd2be-6972-4e06-bfe7-32e1877b53c3	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	fd6326f7-7866-46ab-b23d-159edbf94a27	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	8b5689a3-0c2b-4cad-a66f-49e0ae75daf9	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	08a791ca-1ef7-4b29-98a6-f02820b2a2b3	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	efec4365-ca52-4d5a-bd0f-02eef073296e	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	3715b443-1ed9-4163-89bd-cf4fb359ceb3	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	618f709f-c32a-4e90-b129-3968ecf195b1	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	72282ca2-b8cc-4afb-b717-b5cef31b69eb	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	c892c4d5-644b-4853-83ee-f8dea5b6b952	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	61f8d56b-7d29-4b08-b728-55e1364ec396	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	50aecead-81be-4f41-b193-f4e8cc5f288d	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	7f18dc65-6e0a-467d-abe4-4f524b6e824e	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	5132d049-a00b-4489-9fad-2a55f51288ae	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	1be9c022-ee67-46c2-ad71-cb9b23573f78	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	a8cc5bc1-bd12-42f3-9a5d-48ae4eb968e0	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	bd09155b-91a2-4cd1-aa71-85a71bebb6be	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	5d67b45d-285b-4de3-9466-7cf7467066ff	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	00f5e8cd-1577-4986-8c2a-3ffafec22c25	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	2ab7f1c2-5fee-4861-bd89-0a1485df0ff4	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	d656bceb-ad28-4bdb-a4ce-361c02ebb2fe	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	aceee97c-05c1-481f-b853-e79678ec5fad	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	3bccf399-64ea-4574-904b-7db52741e624	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	99bf49fb-b3be-483b-b9dc-371f82b61227	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	3330a0b6-69a1-41eb-b880-0aabbc119e6d	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	38e7d69b-0ad9-4f4f-9802-634c46adf192	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	a6f18fbf-32ac-4ada-9e03-e7c86d19c110	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	694f4856-6a52-4c7e-a1d0-cd51f73d03bf	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	2c91df97-2384-4b82-b13f-43e6ca0c7a80	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	aeadb674-5e88-4c38-a97b-ee14bf4ff355	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	08ed13ed-85b5-4211-a02c-aab1539a566d	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	8871d288-9daa-4eb5-a117-b3df41e7f90f	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	0a410ae9-158a-4fd2-9a8a-767adad7438a	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	bd732c4a-9f28-4a9f-8351-67ea192e41e0	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	ce5bb0f0-2d74-4992-9112-c3731245eece	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	ef301064-b9ad-4a59-8734-738902495e39	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	6d0c2f3f-4963-4667-81bc-85f323c9dfd1	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	8fb93c32-2d85-4523-88e1-e9ab0a6ff005	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	a93fa551-c915-463e-9908-fb0019bd6f53	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	e3ee6f6b-7a52-4a46-960f-16a9e4566384	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	92830514-8a1a-4fb6-b402-7c9fb0e50f3d	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	6f91a8c7-45ec-4365-bb3a-e2b133543ebd	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	843937ff-2c69-4a15-9f3b-efb797479e75	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	35ba8ece-6851-43b4-bf0c-0a94c6da6a3b	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	8823c15e-ac5d-454a-bbe0-fe36d13b9fee	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	3848292e-d6da-42ed-8e23-bcacf351427c	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	57387649-ae7f-4746-8953-2d991f6c84ea	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	59a02a0a-a40e-47c8-a42a-b55e32e7a4b1	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	89b44b18-354b-4168-ba5d-76e949383a29	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	0ab3bfed-93a7-4ef2-8771-09ce18e9e806	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	c74767a0-3fcc-498c-b74f-372b455069bb	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	cef337ed-68b7-48c3-85be-937880107882	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	6719b819-92e9-410c-a975-a26f5fcf744d	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	a975d9ea-ecfa-480b-89d2-908db5cc336a	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111101	c39074a4-72b7-4203-a00d-308c7cb97e9a	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	a25fd2be-6972-4e06-bfe7-32e1877b53c3	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	fd6326f7-7866-46ab-b23d-159edbf94a27	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	8b5689a3-0c2b-4cad-a66f-49e0ae75daf9	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	08a791ca-1ef7-4b29-98a6-f02820b2a2b3	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	efec4365-ca52-4d5a-bd0f-02eef073296e	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	3715b443-1ed9-4163-89bd-cf4fb359ceb3	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	618f709f-c32a-4e90-b129-3968ecf195b1	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	72282ca2-b8cc-4afb-b717-b5cef31b69eb	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	c892c4d5-644b-4853-83ee-f8dea5b6b952	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	61f8d56b-7d29-4b08-b728-55e1364ec396	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	50aecead-81be-4f41-b193-f4e8cc5f288d	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	7f18dc65-6e0a-467d-abe4-4f524b6e824e	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	5132d049-a00b-4489-9fad-2a55f51288ae	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	1be9c022-ee67-46c2-ad71-cb9b23573f78	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	a8cc5bc1-bd12-42f3-9a5d-48ae4eb968e0	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	bd09155b-91a2-4cd1-aa71-85a71bebb6be	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	5d67b45d-285b-4de3-9466-7cf7467066ff	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	00f5e8cd-1577-4986-8c2a-3ffafec22c25	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	2ab7f1c2-5fee-4861-bd89-0a1485df0ff4	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	d656bceb-ad28-4bdb-a4ce-361c02ebb2fe	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	aceee97c-05c1-481f-b853-e79678ec5fad	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	3bccf399-64ea-4574-904b-7db52741e624	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	99bf49fb-b3be-483b-b9dc-371f82b61227	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	3330a0b6-69a1-41eb-b880-0aabbc119e6d	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	38e7d69b-0ad9-4f4f-9802-634c46adf192	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	a6f18fbf-32ac-4ada-9e03-e7c86d19c110	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	694f4856-6a52-4c7e-a1d0-cd51f73d03bf	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	2c91df97-2384-4b82-b13f-43e6ca0c7a80	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	aeadb674-5e88-4c38-a97b-ee14bf4ff355	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	08ed13ed-85b5-4211-a02c-aab1539a566d	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	8871d288-9daa-4eb5-a117-b3df41e7f90f	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	0a410ae9-158a-4fd2-9a8a-767adad7438a	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	bd732c4a-9f28-4a9f-8351-67ea192e41e0	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	ce5bb0f0-2d74-4992-9112-c3731245eece	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	ef301064-b9ad-4a59-8734-738902495e39	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	6d0c2f3f-4963-4667-81bc-85f323c9dfd1	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	8fb93c32-2d85-4523-88e1-e9ab0a6ff005	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	a93fa551-c915-463e-9908-fb0019bd6f53	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	e3ee6f6b-7a52-4a46-960f-16a9e4566384	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	92830514-8a1a-4fb6-b402-7c9fb0e50f3d	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	6f91a8c7-45ec-4365-bb3a-e2b133543ebd	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	843937ff-2c69-4a15-9f3b-efb797479e75	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	35ba8ece-6851-43b4-bf0c-0a94c6da6a3b	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	8823c15e-ac5d-454a-bbe0-fe36d13b9fee	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	3848292e-d6da-42ed-8e23-bcacf351427c	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	57387649-ae7f-4746-8953-2d991f6c84ea	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	59a02a0a-a40e-47c8-a42a-b55e32e7a4b1	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	89b44b18-354b-4168-ba5d-76e949383a29	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	0ab3bfed-93a7-4ef2-8771-09ce18e9e806	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	c74767a0-3fcc-498c-b74f-372b455069bb	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	cef337ed-68b7-48c3-85be-937880107882	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	6719b819-92e9-410c-a975-a26f5fcf744d	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	a975d9ea-ecfa-480b-89d2-908db5cc336a	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111103	c39074a4-72b7-4203-a00d-308c7cb97e9a	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111104	a25fd2be-6972-4e06-bfe7-32e1877b53c3	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111104	fd6326f7-7866-46ab-b23d-159edbf94a27	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111104	8b5689a3-0c2b-4cad-a66f-49e0ae75daf9	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111104	08a791ca-1ef7-4b29-98a6-f02820b2a2b3	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111104	efec4365-ca52-4d5a-bd0f-02eef073296e	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111104	3715b443-1ed9-4163-89bd-cf4fb359ceb3	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111104	618f709f-c32a-4e90-b129-3968ecf195b1	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111104	50aecead-81be-4f41-b193-f4e8cc5f288d	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111104	7f18dc65-6e0a-467d-abe4-4f524b6e824e	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111104	bd09155b-91a2-4cd1-aa71-85a71bebb6be	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111104	5d67b45d-285b-4de3-9466-7cf7467066ff	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111104	00f5e8cd-1577-4986-8c2a-3ffafec22c25	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111104	2ab7f1c2-5fee-4861-bd89-0a1485df0ff4	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111104	d656bceb-ad28-4bdb-a4ce-361c02ebb2fe	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111104	aceee97c-05c1-481f-b853-e79678ec5fad	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111104	3bccf399-64ea-4574-904b-7db52741e624	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111104	99bf49fb-b3be-483b-b9dc-371f82b61227	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111104	a6f18fbf-32ac-4ada-9e03-e7c86d19c110	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111104	ce5bb0f0-2d74-4992-9112-c3731245eece	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111104	a93fa551-c915-463e-9908-fb0019bd6f53	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111104	e3ee6f6b-7a52-4a46-960f-16a9e4566384	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111104	92830514-8a1a-4fb6-b402-7c9fb0e50f3d	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111104	6f91a8c7-45ec-4365-bb3a-e2b133543ebd	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111104	843937ff-2c69-4a15-9f3b-efb797479e75	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111104	35ba8ece-6851-43b4-bf0c-0a94c6da6a3b	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111106	a25fd2be-6972-4e06-bfe7-32e1877b53c3	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111106	fd6326f7-7866-46ab-b23d-159edbf94a27	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111106	8b5689a3-0c2b-4cad-a66f-49e0ae75daf9	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111106	3715b443-1ed9-4163-89bd-cf4fb359ceb3	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111106	618f709f-c32a-4e90-b129-3968ecf195b1	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111106	50aecead-81be-4f41-b193-f4e8cc5f288d	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111106	7f18dc65-6e0a-467d-abe4-4f524b6e824e	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111106	5132d049-a00b-4489-9fad-2a55f51288ae	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111106	99bf49fb-b3be-483b-b9dc-371f82b61227	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111105	618f709f-c32a-4e90-b129-3968ecf195b1	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111105	72282ca2-b8cc-4afb-b717-b5cef31b69eb	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111105	c892c4d5-644b-4853-83ee-f8dea5b6b952	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111105	61f8d56b-7d29-4b08-b728-55e1364ec396	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111105	fd6326f7-7866-46ab-b23d-159edbf94a27	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111105	99bf49fb-b3be-483b-b9dc-371f82b61227	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111107	fd6326f7-7866-46ab-b23d-159edbf94a27	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111107	8b5689a3-0c2b-4cad-a66f-49e0ae75daf9	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111107	618f709f-c32a-4e90-b129-3968ecf195b1	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111107	a975d9ea-ecfa-480b-89d2-908db5cc336a	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111107	6719b819-92e9-410c-a975-a26f5fcf744d	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111107	99bf49fb-b3be-483b-b9dc-371f82b61227	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111107	a6f18fbf-32ac-4ada-9e03-e7c86d19c110	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111108	694f4856-6a52-4c7e-a1d0-cd51f73d03bf	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111108	2c91df97-2384-4b82-b13f-43e6ca0c7a80	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111108	aeadb674-5e88-4c38-a97b-ee14bf4ff355	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111108	08ed13ed-85b5-4211-a02c-aab1539a566d	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111108	8871d288-9daa-4eb5-a117-b3df41e7f90f	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111108	0a410ae9-158a-4fd2-9a8a-767adad7438a	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111108	bd732c4a-9f28-4a9f-8351-67ea192e41e0	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111108	99bf49fb-b3be-483b-b9dc-371f82b61227	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111108	a6f18fbf-32ac-4ada-9e03-e7c86d19c110	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111108	ce5bb0f0-2d74-4992-9112-c3731245eece	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111109	ce5bb0f0-2d74-4992-9112-c3731245eece	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111109	ef301064-b9ad-4a59-8734-738902495e39	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111109	6d0c2f3f-4963-4667-81bc-85f323c9dfd1	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111109	8fb93c32-2d85-4523-88e1-e9ab0a6ff005	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111109	a93fa551-c915-463e-9908-fb0019bd6f53	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111109	e3ee6f6b-7a52-4a46-960f-16a9e4566384	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111109	92830514-8a1a-4fb6-b402-7c9fb0e50f3d	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111109	6f91a8c7-45ec-4365-bb3a-e2b133543ebd	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111109	c39074a4-72b7-4203-a00d-308c7cb97e9a	2026-09-03 13:02:49.993506+05:30
11111111-1111-1111-1111-111111111104	a8cc5bc1-bd12-42f3-9a5d-48ae4eb968e0	2026-09-03 13:35:45.039627+05:30
11111111-1111-1111-1111-111111111106	a8cc5bc1-bd12-42f3-9a5d-48ae4eb968e0	2026-09-03 13:35:45.044389+05:30
11111111-1111-1111-1111-111111111105	a25fd2be-6972-4e06-bfe7-32e1877b53c3	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111105	8b5689a3-0c2b-4cad-a66f-49e0ae75daf9	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111105	08a791ca-1ef7-4b29-98a6-f02820b2a2b3	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111105	3715b443-1ed9-4163-89bd-cf4fb359ceb3	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111105	bd09155b-91a2-4cd1-aa71-85a71bebb6be	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111105	5d67b45d-285b-4de3-9466-7cf7467066ff	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111105	d656bceb-ad28-4bdb-a4ce-361c02ebb2fe	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111106	08a791ca-1ef7-4b29-98a6-f02820b2a2b3	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111106	bd09155b-91a2-4cd1-aa71-85a71bebb6be	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111106	5d67b45d-285b-4de3-9466-7cf7467066ff	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111106	d656bceb-ad28-4bdb-a4ce-361c02ebb2fe	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111107	a25fd2be-6972-4e06-bfe7-32e1877b53c3	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111107	08a791ca-1ef7-4b29-98a6-f02820b2a2b3	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111107	3715b443-1ed9-4163-89bd-cf4fb359ceb3	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111107	bd09155b-91a2-4cd1-aa71-85a71bebb6be	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111107	5d67b45d-285b-4de3-9466-7cf7467066ff	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111107	d656bceb-ad28-4bdb-a4ce-361c02ebb2fe	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111108	a25fd2be-6972-4e06-bfe7-32e1877b53c3	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111108	fd6326f7-7866-46ab-b23d-159edbf94a27	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111108	8b5689a3-0c2b-4cad-a66f-49e0ae75daf9	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111108	08a791ca-1ef7-4b29-98a6-f02820b2a2b3	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111108	3715b443-1ed9-4163-89bd-cf4fb359ceb3	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111108	618f709f-c32a-4e90-b129-3968ecf195b1	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111108	bd09155b-91a2-4cd1-aa71-85a71bebb6be	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111108	5d67b45d-285b-4de3-9466-7cf7467066ff	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111108	d656bceb-ad28-4bdb-a4ce-361c02ebb2fe	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111109	a25fd2be-6972-4e06-bfe7-32e1877b53c3	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111109	fd6326f7-7866-46ab-b23d-159edbf94a27	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111109	8b5689a3-0c2b-4cad-a66f-49e0ae75daf9	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111109	08a791ca-1ef7-4b29-98a6-f02820b2a2b3	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111109	3715b443-1ed9-4163-89bd-cf4fb359ceb3	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111109	618f709f-c32a-4e90-b129-3968ecf195b1	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111109	bd09155b-91a2-4cd1-aa71-85a71bebb6be	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111109	5d67b45d-285b-4de3-9466-7cf7467066ff	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111109	d656bceb-ad28-4bdb-a4ce-361c02ebb2fe	2026-09-05 16:41:12.987102+05:30
11111111-1111-1111-1111-111111111105	a8cc5bc1-bd12-42f3-9a5d-48ae4eb968e0	2026-09-11 17:21:31.943+05:30
11111111-1111-1111-1111-111111111105	50aecead-81be-4f41-b193-f4e8cc5f288d	2026-09-11 17:21:31.96+05:30
11111111-1111-1111-1111-111111111107	a8cc5bc1-bd12-42f3-9a5d-48ae4eb968e0	2026-09-11 17:21:31.967+05:30
11111111-1111-1111-1111-111111111107	50aecead-81be-4f41-b193-f4e8cc5f288d	2026-09-11 17:21:31.971+05:30
11111111-1111-1111-1111-111111111108	a8cc5bc1-bd12-42f3-9a5d-48ae4eb968e0	2026-09-11 17:21:31.975+05:30
11111111-1111-1111-1111-111111111108	50aecead-81be-4f41-b193-f4e8cc5f288d	2026-09-11 17:21:31.979+05:30
11111111-1111-1111-1111-111111111109	a8cc5bc1-bd12-42f3-9a5d-48ae4eb968e0	2026-09-11 17:21:31.982+05:30
11111111-1111-1111-1111-111111111109	50aecead-81be-4f41-b193-f4e8cc5f288d	2026-09-11 17:21:31.986+05:30
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.roles (id, code, name, description, created_at, updated_at, created_by, updated_by) FROM stdin;
11111111-1111-1111-1111-111111111101	SUPER_ADMIN	SUPER_ADMIN	Super Administrator / System IT Admin	2026-09-02 14:04:52.864637+05:30	2026-09-02 14:04:52.864637+05:30	\N	\N
11111111-1111-1111-1111-111111111102	ADMIN	ADMIN	Administrator	2026-09-02 14:04:52.864637+05:30	2026-09-02 14:04:52.864637+05:30	\N	\N
11111111-1111-1111-1111-111111111103	OUTLET_MANAGER	OUTLET_MANAGER	Restaurant Manager / Outlet General Admin	2026-09-02 14:04:52.864637+05:30	2026-09-02 14:04:52.864637+05:30	\N	\N
11111111-1111-1111-1111-111111111104	CASHIER	CASHIER	Cashier / Front-Desk Biller / POS Operator	2026-09-02 14:04:52.864637+05:30	2026-09-02 14:04:52.864637+05:30	\N	\N
11111111-1111-1111-1111-111111111105	KITCHEN_USER	KITCHEN_USER	Kitchen Staff / Head Chef / KDS Display	2026-09-02 14:04:52.864637+05:30	2026-09-02 14:04:52.864637+05:30	\N	\N
11111111-1111-1111-1111-111111111106	WAITER	WAITER	Captain / Waiter / Table Steward	2026-09-02 14:04:52.864637+05:30	2026-09-02 14:04:52.864637+05:30	\N	\N
11111111-1111-1111-1111-111111111107	DELIVERY_MANAGER	DELIVERY_MANAGER	Online Aggregator & Dispatch Manager (Swiggy / Zomato)	2026-09-03 12:05:42.962721+05:30	2026-09-03 12:05:42.962721+05:30	\N	\N
11111111-1111-1111-1111-111111111108	INVENTORY_MANAGER	INVENTORY_MANAGER	Store & Inventory Manager	2026-09-03 12:05:42.966966+05:30	2026-09-03 12:05:42.966966+05:30	\N	\N
11111111-1111-1111-1111-111111111109	ACCOUNTANT	ACCOUNTANT	Accountant / Auditor / Financial Controller	2026-09-03 12:05:42.967692+05:30	2026-09-03 12:05:42.967692+05:30	\N	\N
\.


--
-- Data for Name: sales_returns; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.sales_returns (id, outlet_id, order_id, order_item_id, qty, amount, reason, refund_method, approved_by, returned_at, created_at) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.schema_migrations (version, applied_at) FROM stdin;
0001_extensions_and_enums.sql	2026-09-02 14:04:49.256787+05:30
0001_init_identity_and_org.sql	2026-09-02 14:04:49.717267+05:30
0002_catalog.sql	2026-09-02 14:04:50.022369+05:30
0002_create_users.sql	2026-09-02 14:04:50.027569+05:30
0003_create_outlets.sql	2026-09-02 14:04:50.03157+05:30
0003_pricing_and_tax.sql	2026-09-02 14:04:50.094296+05:30
0004_create_tables_and_sessions.sql	2026-09-02 14:04:50.204108+05:30
0004_orders.sql	2026-09-02 14:04:50.418975+05:30
0005_create_menu_categories_and_items.sql	2026-09-02 14:04:50.455639+05:30
0005_kitchen.sql	2026-09-02 14:04:50.566613+05:30
0006_create_menu_item_channel_and_availability.sql	2026-09-02 14:04:50.630694+05:30
0006_customers.sql	2026-09-02 14:04:50.744986+05:30
0007_create_taxes.sql	2026-09-02 14:04:50.821837+05:30
0007_integration.sql	2026-09-02 14:04:50.9825+05:30
0008_audit.sql	2026-09-02 14:04:51.069623+05:30
0008_create_payment_type_master.sql	2026-09-02 14:04:51.110619+05:30
0009_create_orders_and_order_items.sql	2026-09-02 14:04:51.11454+05:30
0009_reporting.sql	2026-09-02 14:04:51.269838+05:30
0010_create_order_payments.sql	2026-09-02 14:04:51.273047+05:30
0011_create_order_audit_log.sql	2026-09-02 14:04:51.320664+05:30
0012_create_sales_returns.sql	2026-09-02 14:04:51.373699+05:30
0013_create_outlet_billing_and_print_settings.sql	2026-09-02 14:04:51.419331+05:30
0014_create_sync_backup_channel_log.sql	2026-09-02 14:04:51.528414+05:30
0015_create_user_report_preferences.sql	2026-09-02 14:04:51.568245+05:30
0016_extend_outlet_settings_jsonb.sql	2026-09-02 14:04:51.572093+05:30
0017_add_stock_to_item_availability	2026-09-02 14:04:51.573664+05:30
0017_add_stock_to_item_availability.sql	2026-09-02 14:04:51.579503+05:30
0017_payment_idempotency.sql	2026-09-02 14:04:51.608764+05:30
0018_create_inventory_tables	2026-09-02 14:04:51.610256+05:30
0018_create_inventory_tables.sql	2026-09-02 14:04:51.729873+05:30
0019_add_channel_item_mapping_version	2026-09-02 14:04:51.73122+05:30
0019_add_channel_item_mapping_version.sql	2026-09-02 14:04:51.736471+05:30
0020_create_finance_ledger_tables	2026-09-02 14:04:51.737836+05:30
0020_create_finance_ledger_tables.sql	2026-09-02 14:04:51.796506+05:30
0021_add_outlet_status	2026-09-02 14:04:51.79806+05:30
0021_add_outlet_status.sql	2026-09-02 14:04:51.806178+05:30
0022_admin_pipeline_tables	2026-09-02 14:04:51.8082+05:30
0022_admin_pipeline_tables.sql	2026-09-02 14:04:51.898313+05:30
0023_order_charges_and_waiter_handovers.sql	2026-09-02 14:04:51.929412+05:30
0024_table_merge_groups.sql	2026-09-02 14:04:51.946353+05:30
0025_modifier_options_and_menu_crud.sql	2026-09-02 14:04:51.973476+05:30
0026_special_notes.sql	2026-09-02 14:04:52.000076+05:30
0027_areas.sql	2026-09-02 14:04:52.03891+05:30
0028_seat_and_merge_enums.sql	2026-09-02 14:04:52.042757+05:30
0029_table_merge_groups_and_members.sql	2026-09-02 14:04:52.11481+05:30
0030_table_seats.sql	2026-09-02 14:04:52.149911+05:30
0031_order_and_order_item_seat_columns.sql	2026-09-02 14:04:52.17838+05:30
0032_order_seat_bills.sql	2026-09-02 14:04:52.21967+05:30
0033_order_item_seat_shares.sql	2026-09-02 14:04:52.250021+05:30
0034_kot_items_outlet_and_seat.sql	2026-09-02 14:04:52.272663+05:30
0035_payments_seat_columns.sql	2026-09-02 14:04:52.28497+05:30
0036_invoices_per_seat_unique.sql	2026-09-02 14:04:52.304434+05:30
0037_table_merge_idempotency.sql	2026-09-02 14:04:52.326488+05:30
0038_outlet_contact_and_logo.sql	2026-09-02 14:04:52.329768+05:30
0039_online_orders_round_off_and_kot_bill_print.sql	2026-09-02 14:04:52.35758+05:30
0040_menu_commission_physical_scheduling.sql	2026-09-02 14:04:52.448227+05:30
0041_agent_telemetry.sql	2026-09-03 14:05:27.54061+05:30
0042_invoices_amount_and_sync.sql	2026-09-05 13:08:36.669153+05:30
0043_add_channel_statuses_to_outlet_status	2026-10-03 14:15:44.291747+05:30
0043_add_channel_statuses_to_outlet_status.sql	2026-10-03 14:15:44.354775+05:30
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.sessions (id, user_id, refresh_token_hash, ip_address, user_agent, expires_at, revoked_at, created_at, outlet_id, token_hash, updated_at, last_seen_at) FROM stdin;
5fa45a07-0230-4110-bbb5-7128adf8f3c4	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-03 14:05:52.182+05:30	\N	2026-09-03 14:05:52.195+05:30	11111111-1111-1111-1111-111111111111	76d05a53af4143be258b074d1b56d1c3e6f0176af6d799f13f49bd7c8387863d	2026-09-03 14:05:54.048+05:30	\N
2dad0944-5779-45d1-bb26-9367cf0f9188	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-03 16:46:49.643+05:30	\N	2026-09-03 16:46:49.645+05:30	11111111-1111-1111-1111-111111111111	ac32275734741e536080d33bd457fda3de14c96bdb629f68e73a385ad89b2d51	2026-09-03 16:46:49.645+05:30	\N
99b18d24-d5c3-462b-b6ae-6a1c12a6c413	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-03 14:07:00.25+05:30	\N	2026-09-03 14:07:00.261+05:30	11111111-1111-1111-1111-111111111111	7b41fba424b8b0092f549d850e5ebbeb1df964a0e3685abc20bd82b6946f7b84	2026-09-03 14:07:16.404+05:30	\N
7147efb7-f760-4be0-b058-ab2fa48044fc	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-03 14:19:54.244+05:30	\N	2026-09-03 14:19:54.247+05:30	11111111-1111-1111-1111-111111111111	5a8769ddeac167ecb80b9e92bfda41de05bc1ec6813192add1de26c50ab589ba	2026-09-03 14:19:54.247+05:30	\N
3527aeef-14e9-41f5-88ae-15333619ed0a	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-03 14:21:16.08+05:30	\N	2026-09-03 14:21:16.082+05:30	11111111-1111-1111-1111-111111111111	c0ad4eb8f8d5978d6bc19efe8e2900af2fedcd7897ffd25eb9ae2b3930c8c330	2026-09-03 14:21:16.082+05:30	\N
f0d184a4-63df-4564-a1ce-654e880748d0	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-03 14:23:45.962+05:30	\N	2026-09-03 14:23:45.964+05:30	11111111-1111-1111-1111-111111111111	72b622b220e6c2e870bbcf19b304be4245ebab361d8456ae9b8df243e0ad9869	2026-09-03 14:23:45.964+05:30	\N
4016f0bf-9fbb-44f8-8436-dd163fcc377f	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-03 14:25:13.081+05:30	\N	2026-09-03 14:25:13.082+05:30	11111111-1111-1111-1111-111111111111	1458df18789d2301ef74f74c8e9fe2a7d5ac605c07092bd07fa05c61866b090f	2026-09-03 14:25:15.371+05:30	\N
1c846d6a-3a0d-4d49-b6e0-4b4bedc47fc9	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-03 17:22:49.317+05:30	\N	2026-09-03 17:22:49.318+05:30	11111111-1111-1111-1111-111111111111	084932e9dac133d92dfd242dc61e81db832cc317286167031907492a34c64e1b	2026-09-03 17:22:49.318+05:30	\N
937a9194-2d45-492f-80a0-32575f9422f7	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-10-03 14:50:54.698+05:30	\N	2026-09-03 14:50:54.7+05:30	11111111-1111-1111-1111-111111111111	26b530ec224b2587234fd2cc1536e39222f1d1bedba8ae284be4278f69de5fd2	2026-09-03 15:02:01.157+05:30	\N
823539b6-ce64-420c-9a93-fc96dcee0a2a	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-03 14:25:29.827+05:30	\N	2026-09-03 14:25:29.828+05:30	11111111-1111-1111-1111-111111111111	84b0aed4fb256e1d0d938a406eaaa638e83c9bc0bdf709fb89674141dec815cf	2026-09-03 14:26:16.172+05:30	\N
4ec07cb9-2eb9-459a-b71d-53871f24788e	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-03 15:07:36.387+05:30	\N	2026-09-03 15:07:36.389+05:30	11111111-1111-1111-1111-111111111111	5e00b5de5352f592b2e5ee355a5319f4157ae690444080fe9b635c437e53d33c	2026-09-03 15:07:36.389+05:30	\N
2b533db7-4b4b-4d52-bcf6-687638d4280c	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-03 14:26:19.185+05:30	\N	2026-09-03 14:26:19.191+05:30	11111111-1111-1111-1111-111111111111	23952099cc8969d4a41858269a6d1fd104239e9accb173723b8f6d86222b1256	2026-09-03 14:26:45.701+05:30	\N
aad0e740-31b1-4f1b-ae2a-a0ed6f54ad8e	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-03 17:23:07.314+05:30	\N	2026-09-03 17:23:07.315+05:30	11111111-1111-1111-1111-111111111111	943c5c9a2a2b1206598ec3bafb1cc8cc6b5669f3ca301b6b3df828dcdc531d73	2026-09-03 17:23:07.315+05:30	\N
f77a41c2-8df1-4070-b2ee-5fc7a889b0cb	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-03 17:25:31.069+05:30	\N	2026-09-03 17:25:31.07+05:30	11111111-1111-1111-1111-111111111111	1e47ff064db02f5239fdf2296b222e62349a7e1e775687c67b6ec760e43aff2e	2026-09-03 17:25:31.07+05:30	\N
cc8432c4-aa17-4df1-8c2e-9fd0d8f46727	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-10-03 15:02:08.757+05:30	\N	2026-09-03 15:02:08.758+05:30	11111111-1111-1111-1111-111111111111	025b2bcf118ebe1d0db2cd35cd9455597a09d490f04bce0401cf8e4d696f601b	2026-09-03 15:03:00.783+05:30	\N
9d953229-667e-43d7-892d-17126299e6c0	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-03 17:25:55.077+05:30	\N	2026-09-03 17:25:55.078+05:30	11111111-1111-1111-1111-111111111111	42b011ea5ef85fc2bcf4b1f99fa755c42ef827e4d4ef70a74e88cbab2fb81920	2026-09-03 17:25:55.078+05:30	\N
ea1f1318-7354-4338-b27e-946472055406	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-10-03 15:03:11.149+05:30	\N	2026-09-03 15:03:11.15+05:30	11111111-1111-1111-1111-111111111111	b1f56e592762f1e3e0979c5bd15250f8aefeec19ab2120f622f6b9a8b5657992	2026-09-03 15:03:31.16+05:30	\N
c6a1989e-5adf-4343-a2f7-c8c3dd047241	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-03 17:33:16.392+05:30	\N	2026-09-03 17:33:16.396+05:30	11111111-1111-1111-1111-111111111111	ce6cc7e2592b5846c6e551a0de35c70d7ddf4057bad10414a41934d91452e171	2026-09-03 17:33:16.396+05:30	\N
1a73a0ca-091f-42f1-baa9-146ddcd14b70	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-03 17:33:31.981+05:30	\N	2026-09-03 17:33:31.983+05:30	11111111-1111-1111-1111-111111111111	a3518a1d89537baccac384b7e069f919c91148068106f3f5a95be3c42dc21ecf	2026-09-03 17:33:31.983+05:30	\N
057604c0-7fee-44e4-b8f0-77ad26767436	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-03 15:12:53.954+05:30	\N	2026-09-03 15:12:53.957+05:30	11111111-1111-1111-1111-111111111111	986f95fbf5a2b3ba806e26b99525471241812c7435dc2fb0c3ecb0ed873002e6	2026-09-03 15:12:53.957+05:30	\N
7e7f7c37-8ea6-416b-8442-606df455a429	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-10-03 14:46:46.785+05:30	\N	2026-09-03 14:46:46.791+05:30	11111111-1111-1111-1111-111111111111	494f20e820021d44d399c3d622a2e344b41904d1febb6e0c5a0cda488da30a7c	2026-09-03 14:50:46.156+05:30	\N
6bdd0b0c-7ef4-400f-a916-2e9cc633f9a9	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-10-03 14:26:50.393+05:30	\N	2026-09-03 14:26:50.399+05:30	11111111-1111-1111-1111-111111111111	4f4549a6b0bf6db9d6236ac899889cb3a646b43e19a7b251050573c4e7c04c57	2026-09-03 14:41:42.037+05:30	\N
49b46afa-91af-4895-9fd5-f113c52fc38d	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-03 14:43:14.68+05:30	\N	2026-09-03 14:43:14.688+05:30	11111111-1111-1111-1111-111111111111	8bac744a0d6daeaa1f89d06563d9227ac118288946958a7f5ba4b7a4aa1f255d	2026-09-03 14:43:14.688+05:30	\N
b37fbcdb-bb70-489d-995b-0650edb03ac8	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-03 14:43:30.733+05:30	\N	2026-09-03 14:43:30.742+05:30	11111111-1111-1111-1111-111111111111	ba15c9fd39c79920af02e37972ed71026b84be8a9989ed66744868ca38fc2fbe	2026-09-03 14:43:30.742+05:30	\N
d045cd61-5c3c-4b90-a357-cb5034a5a10f	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-03 14:43:47.774+05:30	\N	2026-09-03 14:43:47.783+05:30	11111111-1111-1111-1111-111111111111	bb10b9bd3554c3310e06e694bfb28ca3acb7afdaac4d7d3b11fd62af91f323a1	2026-09-03 14:43:47.783+05:30	\N
dc0e00d4-8399-4fde-8eba-948fefb45bf9	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-04 00:40:09.428+05:30	\N	2026-09-04 00:40:09.43+05:30	11111111-1111-1111-1111-111111111111	57d34f3f3a63cbd5b1662b80f254688299c5bf202b90b33af3486275b042e465	2026-09-04 00:42:26.47+05:30	\N
98598270-ef22-4af4-8bfe-33dd83e3a3f6	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-04 01:14:36.356+05:30	\N	2026-09-04 01:14:36.357+05:30	11111111-1111-1111-1111-111111111111	708c5255962e7c700388096738db3e3cc599c5ebc964c018042e685f3367bb31	2026-09-04 01:16:37.379+05:30	\N
49691edf-45cd-4d0d-85e5-38415d431cd8	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-03 15:16:22.544+05:30	\N	2026-09-03 15:16:22.547+05:30	11111111-1111-1111-1111-111111111111	e5c40dcdf0393423e3825f8a3e7d9e68d0b36237987153e503bb505d20f4afe8	2026-09-03 15:16:22.547+05:30	\N
1a84039c-2446-4ccc-b32c-3ee592832e1a	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-10-04 01:05:03.431+05:30	\N	2026-09-04 01:05:03.433+05:30	11111111-1111-1111-1111-111111111111	ab25c1d44813d48608281aadb9ab6c1e42f1ce7d762bc6ff7aa4482eedb7c041	2026-09-04 01:05:24.477+05:30	\N
b5a9f9d2-1d9f-44f3-82c1-9a58377fba30	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-03 14:44:45.873+05:30	\N	2026-09-03 14:44:45.875+05:30	11111111-1111-1111-1111-111111111111	fedb22e79f4a0817987a86b23f2b81c734d8ddcbea7d7c3225f516b024f20444	2026-09-03 14:45:46.873+05:30	\N
8b339c84-947e-4c0d-9955-a0ce52d13c99	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-03 15:17:01.218+05:30	\N	2026-09-03 15:17:01.219+05:30	11111111-1111-1111-1111-111111111111	9757cfbc5b4b02d14c01cfb1c83b23bcf325b9418c9a608d82ac7437ce3efd42	2026-09-03 15:17:01.219+05:30	\N
92fbd67d-1950-4a3e-a108-65c6e238d596	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-03 15:17:20.097+05:30	\N	2026-09-03 15:17:20.099+05:30	11111111-1111-1111-1111-111111111111	b99a2c517c01bd4ace3f819cb932fda9a8c2ae81e84663562ad69c198d0cbfff	2026-09-03 15:17:20.099+05:30	\N
eec02159-77f3-414d-890a-932b326a23d8	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-03 14:45:56.331+05:30	\N	2026-09-03 14:45:56.337+05:30	11111111-1111-1111-1111-111111111111	a4a118fc57cbfd802255119e6cb35a9a5d271b1f5117bc88d8277063b80498eb	2026-09-03 14:46:32.162+05:30	\N
942cfb78-5fa1-47d5-bf80-a96ad9e219c0	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-04 00:02:07.499+05:30	\N	2026-09-04 00:02:07.501+05:30	11111111-1111-1111-1111-111111111111	643dbc025c536306c2a069aab6b50033d406b26893b9ab4f3489cd1ffc19edaf	2026-09-04 00:16:11.474+05:30	\N
2e4b6f14-a7cd-4176-b122-cba5eb7c4efd	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-04 00:42:40.637+05:30	\N	2026-09-04 00:42:40.64+05:30	11111111-1111-1111-1111-111111111111	209806089dd07e9c672c08fabc9cc1a9cf50784a454cbb86b35f8401996cb424	2026-09-04 00:47:13.341+05:30	\N
7f7813d7-2426-40f3-8715-84120101fb5d	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-10-03 15:03:38.892+05:30	\N	2026-09-03 15:03:38.894+05:30	11111111-1111-1111-1111-111111111111	8bb1b6ced2f81f8e769f2479f16820f45c7fac6c920944fa5f98bca440ac7b83	2026-09-03 15:18:30.784+05:30	\N
c9ce761a-5c2f-4293-a0d7-3b0132cba78d	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-03 16:46:24.179+05:30	\N	2026-09-03 16:46:24.181+05:30	11111111-1111-1111-1111-111111111111	d9565eeffd962c3530d1fb94bcdf61496d0f5405192d22d08bf1e30ea268d620	2026-09-03 16:46:24.181+05:30	\N
bce3c8c2-48a2-4fee-8530-1f09d7c99dd7	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-04 01:04:23.346+05:30	\N	2026-09-04 01:04:23.347+05:30	11111111-1111-1111-1111-111111111111	bf562d0deadba6bc19b809716f520b6ca6ac2a6f579afa76d4049805f609d637	2026-09-04 01:04:54.919+05:30	\N
4883bb4b-b6e0-4ebc-b4e0-7ac02883194d	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-04 01:03:40.091+05:30	\N	2026-09-04 01:03:40.092+05:30	11111111-1111-1111-1111-111111111111	c889f9c915bb2490e4d196d1f44ac2a96b7feaebd59b631bef7837c371bda72e	2026-09-04 01:03:56.02+05:30	\N
4aed7257-79b5-40ba-8130-8a1e63b4e753	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-04 01:05:34.062+05:30	\N	2026-09-04 01:05:34.064+05:30	11111111-1111-1111-1111-111111111111	29dea08a8f1ce9537a3d720d7685b869df97d0eb7adffead1d9eeae4175880ff	2026-09-04 01:13:09.321+05:30	\N
f2d300e8-04e8-4d9f-ac7e-3a9274034823	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-05 13:18:46.479+05:30	\N	2026-09-05 13:18:46.482+05:30	11111111-1111-1111-1111-111111111111	ff7b0cd2c5a90d72da8d5c29d6e2ec6ff1fe722d9f79d6653f1b322d9e62987e	2026-09-05 13:33:34.015+05:30	\N
71069b32-9db5-40e7-a374-5691f9f41508	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-05 13:20:23.147+05:30	\N	2026-09-05 13:20:23.152+05:30	11111111-1111-1111-1111-111111111111	6f05d5f47140f33cdd3aac9cdf943a4134a82c27d886765c594c877a372526ea	2026-09-05 13:20:23.152+05:30	\N
2b3e783e-9afb-4fe4-856c-ad20f817b3c8	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-10-05 13:21:32.579+05:30	\N	2026-09-05 13:21:32.583+05:30	11111111-1111-1111-1111-111111111111	a32638ca6278d08deff8c4da5a0c10ffc57ddd0e307e42f58006fe95610b0036	2026-09-05 13:21:32.583+05:30	\N
55dfceca-3fc8-4a29-a778-b2f26cdf77ef	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-08 13:11:22.467+05:30	\N	2026-09-08 13:11:22.471+05:30	11111111-1111-1111-1111-111111111111	d63994fb4daf1eb2470fb16d6a6f7764856c051c62fae92597bbd0e3e89e6a5a	2026-09-08 13:14:29.242+05:30	\N
ac85c225-9aff-4d61-8a43-5d38743ac8ad	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-05 16:52:29.078+05:30	\N	2026-09-05 16:52:29.08+05:30	11111111-1111-1111-1111-111111111111	a9ac4c58c9cb885ed92ce6c71e715cfbd87411e16ed0d8796180cbb9eaf35cb4	2026-09-05 17:07:20.711+05:30	\N
105e29dd-ea1b-4d67-ac63-3d2325ee045c	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-05 14:43:23.405+05:30	\N	2026-09-05 14:43:23.407+05:30	67315042-c687-4cbb-b45a-f4ea4efc199f	152c1c0ba9234f364694c06b2b14c1dd2ef18cc2931e21826a8d440886746052	2026-09-05 14:43:23.407+05:30	\N
7e21a9a9-6b7d-4929-a352-8c6b0db14340	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-10-05 17:12:04.479+05:30	\N	2026-09-05 17:12:04.481+05:30	11111111-1111-1111-1111-111111111111	2025f89e0f4d5a54f6cb65cbe635a757ed3ab0b9a9661666bd0c76e7262cf830	2026-09-05 17:12:04.481+05:30	\N
701ed539-00bc-4996-aaef-7122bba238bd	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-05 14:43:37.38+05:30	\N	2026-09-05 14:43:37.389+05:30	11111111-1111-1111-1111-111111111111	c06b044889a51c21e1340e81de52051702ed2621e751d10fc46bab83d6095d99	2026-09-05 14:43:37.389+05:30	\N
d00184d9-0267-45ce-bab8-5ee96c92f249	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-05 14:43:50.799+05:30	\N	2026-09-05 14:43:50.808+05:30	11111111-1111-1111-1111-111111111111	e12495823f22618a759ed13cdaaba1d50ad1e121548649fe2ef18b32f2fceffb	2026-09-05 14:43:50.808+05:30	\N
0bb430a3-225b-4cd9-8807-d1bec1c2e1e0	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-05 14:44:15.251+05:30	\N	2026-09-05 14:44:15.26+05:30	11111111-1111-1111-1111-111111111111	d08864add7ca99108c18d49b51efdc491f68d56fdb2c3b4ee78354d4e1b89ff7	2026-09-05 14:44:15.26+05:30	\N
c74408e8-f554-4c81-819b-7e5fc6ca99c0	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-05 17:15:17.121+05:30	\N	2026-09-05 17:15:17.123+05:30	11111111-1111-1111-1111-111111111111	871f618b140348388ca95e2ce856457da40cb28bc9389ad599f8db07aaeddec6	2026-09-05 17:15:17.123+05:30	\N
d50b57a2-e88c-4ee1-8875-403a44c7cb81	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-05 14:49:26.84+05:30	\N	2026-09-05 14:49:26.846+05:30	11111111-1111-1111-1111-111111111111	e318f2c798bf4dd98f4184a8a20cf88b58775fd63d4ba079ac7da04adb6facd3	2026-09-05 15:04:25.174+05:30	\N
8c953cd7-68a5-4261-861b-12586be0108e	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-10-05 15:04:43.211+05:30	\N	2026-09-05 15:04:43.213+05:30	11111111-1111-1111-1111-111111111111	83da13b5094c07fb8efc10e5105660effa26eafe4a5c0c1605274944a1697861	2026-09-05 15:04:43.213+05:30	\N
103134fc-5ccc-4a4b-ae75-422d26be4291	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-10-05 15:07:43.056+05:30	\N	2026-09-05 15:07:43.057+05:30	11111111-1111-1111-1111-111111111111	c02ed867e9a1754a8a321db907987eeb2741a3b702fd47755404df9980fdf2e1	2026-09-05 15:09:31.66+05:30	\N
ae8f2bfb-2cf9-4b2d-bf8c-6325f29f1e06	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-10-05 16:19:30.974+05:30	\N	2026-09-05 16:19:30.975+05:30	11111111-1111-1111-1111-111111111111	88b5448dc5b85aea27997f7db05508489f27cd2eca5cfa87a8387fc1fb4dacf0	2026-09-05 16:19:30.975+05:30	\N
5f4763a2-84b2-4730-a959-f335c4c17308	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-10-05 16:20:49.499+05:30	\N	2026-09-05 16:20:49.501+05:30	11111111-1111-1111-1111-111111111111	7d3fc452009d89ebc659e0780b9bdef2ab9ab78a9c2073f4fb865f59444df09a	2026-09-05 16:20:49.501+05:30	\N
0545bddc-389c-4b97-ac7f-24e32f72460c	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-05 16:23:02.469+05:30	\N	2026-09-05 16:23:02.471+05:30	11111111-1111-1111-1111-111111111111	2b940bb6968ecfede68b46339279e209f410d945c7a8e1f8c82e99cd223b3a95	2026-09-05 16:23:02.471+05:30	\N
b519f8c7-51bd-474b-afae-3401dc813a57	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-10-05 16:49:25.858+05:30	\N	2026-09-05 16:49:25.86+05:30	11111111-1111-1111-1111-111111111111	ab67dc88d27d613e051087d8f4a2637e978d9dd9253d2b9ca1ac6766c802c400	2026-09-05 16:49:25.86+05:30	\N
b1944422-0496-4fcd-8907-9851062e5ad4	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-10-05 16:52:03.79+05:30	\N	2026-09-05 16:52:03.791+05:30	11111111-1111-1111-1111-111111111111	a7e0c3e3b756a038fbdbb0bd8de203d628b2b870974bf49320bcb0aa1478383e	2026-09-05 16:52:03.791+05:30	\N
1dc910a7-86d6-49c2-9137-8269d5235433	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-08 11:14:44.941+05:30	\N	2026-09-08 11:14:44.943+05:30	11111111-1111-1111-1111-111111111111	470a63f59778f99676f2096ab980f690498b73fb0edcd5b98e40b69bd46074ae	2026-09-08 11:29:30.943+05:30	\N
9dd8c453-3c74-47d3-97d0-23d689395447	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-08 10:58:54.067+05:30	\N	2026-09-08 10:58:53.928+05:30	11111111-1111-1111-1111-111111111111	aa06fbc50ca2c6872da35122712435d9780457e0d8255a12d5c9b2a04545f221	2026-09-08 11:13:52.102+05:30	\N
54219d10-0437-4088-9822-f0c341da7784	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-08 11:14:28.326+05:30	\N	2026-09-08 11:14:28.328+05:30	11111111-1111-1111-1111-111111111111	8e5fb2fa7c203bdcbcfd6f2fac4e4bb04283173f48605c509b0cab8cca148e08	2026-09-08 11:14:28.328+05:30	\N
f5f190b5-dc76-4ac7-bc4f-87c33db8af35	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-10-05 17:26:56.204+05:30	\N	2026-09-05 17:26:56.206+05:30	11111111-1111-1111-1111-111111111111	4aac6752fe5c9ed2438468e6341535e4db801be784692513cbfa8a61bfd8dbd7	2026-09-05 17:26:56.206+05:30	\N
885b1ac5-67a4-464d-9508-57339d271473	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-05 14:26:10.166+05:30	\N	2026-09-05 14:26:10.167+05:30	11111111-1111-1111-1111-111111111111	8132b2126f2dc10a05017efc3d07e40ea18e08a4f1fa2c3f0744841c1f1a882a	2026-09-05 14:32:59.22+05:30	\N
3520a91a-0276-4726-9f68-9fe47430fd01	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-05 14:33:07.324+05:30	\N	2026-09-05 14:33:07.326+05:30	11111111-1111-1111-1111-111111111111	ec6cf4675448739b50c795f63124594d95972f93b11dd1c3effe40ad89975516	2026-09-05 14:33:08.346+05:30	\N
d6d41517-4b75-414c-9b45-667a4293dc20	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-10-05 14:33:52.047+05:30	\N	2026-09-05 14:33:52.048+05:30	11111111-1111-1111-1111-111111111111	90e733e3ed4e6f94a5b2d275abc26c0a9e03a440b4875c6e42b53e666b9db20b	2026-09-05 14:33:52.048+05:30	\N
8603ddc3-a924-4388-a8f7-25438041602d	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-08 11:55:45.471+05:30	\N	2026-09-08 11:55:45.474+05:30	11111111-1111-1111-1111-111111111111	4d2cd057da5649a13e970dfdcc7e19558cb522562f7169360b6463f9bc2ba2d7	2026-09-08 11:55:45.474+05:30	\N
5f4591df-8fdf-4738-a148-1fd62c85de10	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-05 14:34:24.533+05:30	\N	2026-09-05 14:34:24.535+05:30	11111111-1111-1111-1111-111111111111	5834728b3d697555906cf65b47172f67beebf683f4cc080104485753ef74fb35	2026-09-05 14:49:10.815+05:30	\N
f9be237b-da94-484b-b674-051262b0cbdc	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-10-05 14:49:15.441+05:30	\N	2026-09-05 14:49:15.447+05:30	11111111-1111-1111-1111-111111111111	f0ca2cd0911cb0fb476121bedeaa0f2793ca0cca9b7f16811d652d00d1a1e147	2026-09-05 14:49:15.447+05:30	\N
5df769a2-eebc-40c2-92d8-c6626a6fae2c	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-10-05 17:29:31.81+05:30	\N	2026-09-05 17:29:31.821+05:30	11111111-1111-1111-1111-111111111111	5cf9c15ac20554d47cc24eb5eb4fd6208cb1fe32dda49196e52d9b7f05ca694a	2026-09-05 17:29:31.821+05:30	\N
f19833f9-58f8-4809-9ff0-b0b2883d35f4	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-10-05 17:29:46.122+05:30	\N	2026-09-05 17:29:46.131+05:30	11111111-1111-1111-1111-111111111111	90f5f6bd081c7722d509e0c80021aa75fa5ea35c1aa01fd2688389e8b06b1aee	2026-09-05 17:29:46.131+05:30	\N
e22fdb77-279c-4500-9c9d-9422149ad326	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-10-05 17:30:22.44+05:30	\N	2026-09-05 17:30:22.449+05:30	11111111-1111-1111-1111-111111111111	de0b504482e534d24ecce620600a151973f600e17f520d574b78368d257b9167	2026-09-05 17:30:22.449+05:30	\N
22df741f-9695-4f97-aa96-3c547d9cc2bb	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-05 17:16:18.568+05:30	\N	2026-09-05 17:16:18.569+05:30	11111111-1111-1111-1111-111111111111	4a8a080550b87f4f12bac5ec3a9154d31282cb9e9e3366fe60555d31b3d2297e	2026-09-05 17:30:24.826+05:30	\N
dc2f1748-819e-4f90-9bbb-044b9e751012	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-05 17:33:56.506+05:30	\N	2026-09-05 17:33:56.508+05:30	11111111-1111-1111-1111-111111111111	1abaa759c0fac499d94de3b11f72ab05407c4baa1689e6aedafd05a8c1cd87e2	2026-09-05 17:33:56.508+05:30	\N
4ac65e08-1dcd-43bb-9e7e-f0824b69ef17	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-10-05 17:34:08.434+05:30	\N	2026-09-05 17:34:08.435+05:30	11111111-1111-1111-1111-111111111111	668965fb9813659435fb766b78695694ffb864503c52c9ed0200acd27d3439d7	2026-09-05 17:34:08.435+05:30	\N
57c159e4-e8a7-4e45-850c-ab037129d24d	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-08 12:57:26.247+05:30	\N	2026-09-08 12:57:26.249+05:30	11111111-1111-1111-1111-111111111111	3cf181211152278ef0210fd5b9e6bcb08349140222c87a14643ebe75ed8543a0	2026-09-08 12:57:26.249+05:30	\N
5c37e85b-288b-49d3-8cb2-294cd6173d57	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-08 10:58:40.772+05:30	\N	2026-09-08 10:58:40.633+05:30	11111111-1111-1111-1111-111111111111	f6639802ae83533e0a1b8bcca91d312240bf8b94c7f36162237efd5f1c8d0b83	2026-09-08 10:59:20.473+05:30	\N
c18ef680-f5df-4395-b162-93d29d0eec80	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-05 15:03:03.317+05:30	\N	2026-09-05 15:03:03.323+05:30	67315042-c687-4cbb-b45a-f4ea4efc199f	1775bfd9d767b6e7e5f5293e9fbd825542c90390fca06f1c8b90aab015949a66	2026-09-05 15:03:03.323+05:30	\N
97dc2bfb-6b8f-4192-9688-21ab5508cbf4	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-08 13:15:05.365+05:30	\N	2026-09-08 13:15:05.367+05:30	11111111-1111-1111-1111-111111111111	3d7d6d80402cf3290c842af0f9be5ba4a0e37c8d5feb480121a5b927d7877f5b	2026-09-08 13:15:50.325+05:30	\N
6e508d13-0b59-46f0-ba0d-672321a42f08	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-08 11:15:56.249+05:30	\N	2026-09-08 11:15:56.255+05:30	11111111-1111-1111-1111-111111111111	e7a93a64e5df09dab0be42eaa97a4e8dd9fbe46b074aa4e3dbd4e292a544cbe4	2026-09-08 11:15:56.255+05:30	\N
a7d7bc55-3708-4857-87d8-2d4a79432854	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-08 14:14:14.692+05:30	\N	2026-09-08 14:14:14.707+05:30	11111111-1111-1111-1111-111111111111	4d4984e93ca7fcf8a8928a0610d5336206e0443554c252a8ebe60177aa285ed1	2026-09-08 14:26:58.33+05:30	\N
4171211f-3dbf-4d58-bffb-d4100d1ae2f6	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-08 13:57:43.697+05:30	\N	2026-09-08 13:57:43.708+05:30	11111111-1111-1111-1111-111111111111	643fda9a58469cdf5b8357d0b3dcb1ecf25b051aac6accb81880fa4f40ae075e	2026-09-08 13:57:56.741+05:30	\N
142093bc-da7e-464c-b087-1ace11b25dc2	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-10-08 15:12:51.432+05:30	\N	2026-09-08 15:12:51.434+05:30	11111111-1111-1111-1111-111111111111	eacc322ab8f38c8cd81ada140a79f964ffb723c34cb3dfbbd4f50f2df37a6c50	2026-09-08 15:12:51.434+05:30	\N
2bcf9d74-cf4e-4ca5-846f-64b0ac233022	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-08 14:36:05.13+05:30	\N	2026-09-08 14:36:05.131+05:30	11111111-1111-1111-1111-111111111111	b2f00e2a1371c70874378d5152d32fa6614791f2858a6e123cd9c9a76f1b4213	2026-09-08 14:40:49.706+05:30	\N
7e4ef554-6d20-45c8-ad5b-7af054f4f471	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-08 14:57:23.415+05:30	\N	2026-09-08 14:57:23.416+05:30	11111111-1111-1111-1111-111111111111	b6241a34928831d4a87fd8536cf61ec0ebc282e64e8cff1950eadcd450bc6dfe	2026-09-08 14:57:23.416+05:30	\N
7b133074-b6c2-45c6-b197-85a08c3218a5	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-08 16:16:00.808+05:30	\N	2026-09-08 16:16:00.809+05:30	11111111-1111-1111-1111-111111111111	962ddc0408e70286cb525e8af0fc8ab0344177837857542a25cb2ae7f8fd9579	2026-09-08 16:28:19.686+05:30	\N
f21c4d1f-b28d-48a6-9d65-d6f6a6252fd1	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-09 14:26:04.819+05:30	\N	2026-09-09 14:26:04.821+05:30	11111111-1111-1111-1111-111111111111	1504d82759d4b70826c418b3f28514a3e5194c63a37e68bd4f16323db4afde05	2026-09-09 14:35:39.287+05:30	\N
81074981-3253-4b20-854b-574bfb6b4f7f	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-09 12:03:44.751+05:30	\N	2026-09-09 12:03:44.756+05:30	11111111-1111-1111-1111-111111111111	654220dd75214a0a303e94a92bec86f16512a43c2d67a8f775e87f90b5c0278f	2026-09-09 12:05:31.771+05:30	\N
b49f2795-c6d9-4db6-9c48-5ea266167aaf	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-09 15:22:19.227+05:30	\N	2026-09-09 15:22:19.229+05:30	11111111-1111-1111-1111-111111111111	29fd1694b0b8bcebee400663f03bc412e5f8b26623fce217a6917aafd1d0db8b	2026-09-09 15:24:41.126+05:30	\N
af990718-1c7e-4d01-80e9-80cc97d984b7	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-09 13:43:59.001+05:30	\N	2026-09-09 13:43:59.002+05:30	11111111-1111-1111-1111-111111111111	bd6e660ea3da38aedb4ecd1003c6edffbb2a076d59d45568810af65e4c4efcca	2026-09-09 13:49:56.249+05:30	\N
2fdaa586-6ee8-4fc6-9204-4f1e8a011d90	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-09 14:04:35.856+05:30	\N	2026-09-09 14:04:35.857+05:30	11111111-1111-1111-1111-111111111111	82d994b71b6975e92722cf1de8eb83a752f6a747069ff7508e44e07f60271a8c	2026-09-09 14:17:02.362+05:30	\N
3998c86c-1da2-40a2-a638-8b409a6777c7	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-09 14:19:19.79+05:30	\N	2026-09-09 14:19:19.791+05:30	11111111-1111-1111-1111-111111111111	31140c235b488141ada66e90c7cc65b7916043243b589b58f7e6ba8cce579e65	2026-09-09 14:19:19.791+05:30	\N
a0fc65ed-3a69-484f-9bf4-8ebf7e908719	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-10-09 17:18:35.799+05:30	\N	2026-09-09 17:18:35.806+05:30	11111111-1111-1111-1111-111111111111	0c11b55bab829b4725d3c4f4fd8b2e457463378f02ae11ca75eb0cec8b6bf170	2026-09-09 17:18:35.806+05:30	\N
5cf43adc-8bec-4ef7-9927-df0923f2e6ad	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-09 15:06:55.355+05:30	\N	2026-09-09 15:06:55.357+05:30	11111111-1111-1111-1111-111111111111	8b89b0925e44df5cdf5b5f727e97ef6314bb9e64b42979554ead4dc3994659e3	2026-09-09 15:09:33.921+05:30	\N
750830e8-107d-4fee-99ac-550bd619ce3a	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-10-09 17:18:58.217+05:30	\N	2026-09-09 17:18:58.224+05:30	11111111-1111-1111-1111-111111111111	f7d9dc729457971a5ba19c7d8d55aeab5f9b57bf1da35f6b71d434067ac072d6	2026-09-09 17:18:58.224+05:30	\N
52bfac5b-f742-40b9-8ea7-7ca14ada9ab6	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-10 10:47:43.03+05:30	\N	2026-09-10 10:47:43.033+05:30	11111111-1111-1111-1111-111111111111	d8ad3593006437beb250178f12400bb0294366ca47d09d61b90ec79fac080747	2026-09-10 10:47:43.033+05:30	\N
1e15073e-b9ac-4efa-922b-99d052f96e07	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-09 14:27:03.533+05:30	\N	2026-09-09 14:27:03.534+05:30	11111111-1111-1111-1111-111111111111	c244d318ee5013f7d11b539aa23aab4452d44e3f8caed28a75c129b248425bd0	2026-09-09 14:27:03.534+05:30	\N
adcae6ad-4be0-42fe-bbcd-a398c75a59a8	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-09 12:37:01.596+05:30	\N	2026-09-09 12:37:01.604+05:30	11111111-1111-1111-1111-111111111111	a447f2f592b8136b690d94dcd09f9992c03cc1e465c9cab1e2aecf03486e83fd	2026-09-09 12:51:54.901+05:30	\N
e9536604-d78a-4783-ab2e-3f35368439e7	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-09 12:52:31.44+05:30	\N	2026-09-09 12:52:31.441+05:30	11111111-1111-1111-1111-111111111111	fd0bf4b3bcb9a9ae8660da9ea6607299b92ba5d886cd1a7da243924b68408c2f	2026-09-09 12:52:31.441+05:30	\N
9acb17e5-5640-405b-a0ed-f7be553424a5	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-10 11:13:19.379+05:30	\N	2026-09-10 11:13:19.381+05:30	11111111-1111-1111-1111-111111111111	9e9ccf4941ee446d9791a0315529aed8c60d94b87c51822de1fffe17074f5df9	2026-09-10 11:13:19.381+05:30	\N
89350506-79c2-4d71-92eb-b530578da2c9	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-09 14:27:33.386+05:30	\N	2026-09-09 14:27:33.39+05:30	11111111-1111-1111-1111-111111111111	24d04b467388545a805d8a73543edba9d5f304ea3a2cedf39bfcd34343ec11b7	2026-09-09 14:27:33.39+05:30	\N
ea9996a5-44f6-45d8-a7cf-6ff66a1b1b63	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-10 17:17:41.143+05:30	\N	2026-09-10 17:17:41.145+05:30	11111111-1111-1111-1111-111111111111	f5c05f3343c93f86e6997ccab7c5521db6580b8abb03dd9f59d6cf0a58694e71	2026-09-10 17:25:24.306+05:30	\N
7b0ef1bb-37e6-4070-8de3-16906d391a72	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-09 14:28:57.598+05:30	\N	2026-09-09 14:28:57.614+05:30	11111111-1111-1111-1111-111111111111	a0788409701122f39f66ea6d45dbb282ec0fa4283031ee2270b63b7a797b44f0	2026-09-09 14:28:57.614+05:30	\N
113f1071-bfc9-4c9e-bf5d-66984f8bbc03	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-09 12:14:20.49+05:30	\N	2026-09-09 12:14:20.492+05:30	11111111-1111-1111-1111-111111111111	23d649a6b2f41c0d9cb05e779bdc13b1bc970a42f4c555519a90d5c4756675b9	2026-09-09 12:28:43.524+05:30	\N
a25b9d90-2092-428f-b760-1f0d529b6e11	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-09 14:29:43.011+05:30	\N	2026-09-09 14:29:43.013+05:30	11111111-1111-1111-1111-111111111111	20fae48aa1e1c07ae116d76b80c54f33544125036224d5d8fd0aa0f7b0a553d8	2026-09-09 14:29:43.013+05:30	\N
dc4ce1cf-703e-46d2-b87f-03b216d02c9b	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-09 12:44:06.197+05:30	\N	2026-09-09 12:44:06.202+05:30	11111111-1111-1111-1111-111111111111	e3e7c830dbc4c7904e175754ffe72b4a1ab058ee1245ddcc19ce95089c26d3d6	2026-09-09 12:44:06.202+05:30	\N
f6c59d9b-427d-4e4d-8828-816fbdf48963	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-09 14:30:40.85+05:30	\N	2026-09-09 14:30:40.852+05:30	11111111-1111-1111-1111-111111111111	8df48a36edbba4664c7d7932f67ee76f414b2977b40dd18aa90b88ea9fb59200	2026-09-09 14:30:40.852+05:30	\N
84f25aab-9d25-42f5-a2d5-4cd21e68c4f3	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-09 14:31:14.116+05:30	\N	2026-09-09 14:31:14.119+05:30	11111111-1111-1111-1111-111111111111	8e9f8f254410868661d4fb7d06ae1c7e140cd31861a48be5447100da6917a132	2026-09-09 14:31:14.119+05:30	\N
fe67143d-163a-489b-9674-4fdff73a5106	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-09 14:31:59.057+05:30	\N	2026-09-09 14:31:59.058+05:30	11111111-1111-1111-1111-111111111111	e6d0381090b461e9fddbe7bfa85514b962aec4223b7b382d90250d17001ca084	2026-09-09 14:31:59.058+05:30	\N
994c6a9b-5ec4-4484-b130-8ba3745bd1a3	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-09 14:32:47.999+05:30	\N	2026-09-09 14:32:48.002+05:30	11111111-1111-1111-1111-111111111111	6eafb5dc8433e7d7a4cc5fbe856ce9cdd9e4b6dfeadbde583f988619e67903f6	2026-09-09 14:32:48.002+05:30	\N
151c69fa-76cd-4d51-95cd-da9b6aeb78fe	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-09 14:34:00.64+05:30	\N	2026-09-09 14:34:00.642+05:30	11111111-1111-1111-1111-111111111111	8b51890c7c138b47ebca03317dd99b14c18c1829281bd2183b07200d1220f38e	2026-09-09 14:34:00.642+05:30	\N
976c3bd1-5bbe-4ca7-80be-0a563b8f11ce	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-10 17:42:03.056+05:30	\N	2026-09-10 17:42:03.058+05:30	11111111-1111-1111-1111-111111111111	14c8aa6174fcea244c8824c25082712f165920604b937758096b9b7949654e0e	2026-09-10 17:56:49.048+05:30	\N
8c2a9186-ec1d-4ba1-a2f5-04a7d469c66f	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-09 12:52:37.578+05:30	\N	2026-09-09 12:52:37.578+05:30	11111111-1111-1111-1111-111111111111	f4a52edc9e5295832f71963933b07b9407c469bb978ecd0068ab8d6c30a73b84	2026-09-09 12:56:10.812+05:30	\N
855b2e59-cbc0-4188-9809-c3b568a9cd3e	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-09 13:00:42.465+05:30	\N	2026-09-09 13:00:42.466+05:30	11111111-1111-1111-1111-111111111111	429c10773027ab300f3685735eb9d583e0eab3f7f5c92efd64d47153f518d99e	2026-09-09 13:00:42.466+05:30	\N
9bdd41b1-50c3-4637-8380-760a9326b376	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-09 13:01:24.997+05:30	\N	2026-09-09 13:01:24.996+05:30	11111111-1111-1111-1111-111111111111	7cde12e416ff57dc6326bbbaa95dfdfe7aa66cbaa540d0f513cbf7e42a0fc4e6	2026-09-09 13:01:24.996+05:30	\N
09547a3f-8da3-4851-a43d-b89ca217b275	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-10 11:51:06.873+05:30	\N	2026-09-10 11:51:06.877+05:30	11111111-1111-1111-1111-111111111111	d7078b6217792933ce207c06ee1428decafd931d09cf8495806e527858820ba4	2026-09-10 12:05:55.154+05:30	\N
52a090a2-71ac-43cd-a28b-374f7ca707f0	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-09 13:02:01.932+05:30	\N	2026-09-09 13:02:01.936+05:30	11111111-1111-1111-1111-111111111111	e8145ea2691958d1d80f86166715af05bda6e04c8f66317f2600cc839424161e	2026-09-09 13:02:01.936+05:30	\N
0dc3b502-9495-4dbf-9dd6-4fef500c3e6b	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-09 13:03:37.562+05:30	\N	2026-09-09 13:03:37.563+05:30	11111111-1111-1111-1111-111111111111	7ffe850de6634ed338151211dea0a9e3e14a13f44fdb47c94349a2bd0a091573	2026-09-09 13:03:37.563+05:30	\N
5687e881-f765-4582-9327-c44476ed9436	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-09 13:04:47.981+05:30	\N	2026-09-09 13:04:47.98+05:30	11111111-1111-1111-1111-111111111111	12ae61e8df353e46ccf5dca10cdef33e8d2bc9f8387b45286ac34f6b48d7b673	2026-09-09 13:04:47.98+05:30	\N
bb9eeec7-1e61-49cf-861a-c3c01a3d2067	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-09 13:06:32.098+05:30	\N	2026-09-09 13:06:32.098+05:30	11111111-1111-1111-1111-111111111111	25f2777408fa78a044d6986c9d7aa4f4b77b73626f2e15dfe4cfb6001ac581d7	2026-09-09 13:06:32.098+05:30	\N
c5d61241-72d7-4d8a-9dc0-094a938f55d2	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-10 17:25:28.947+05:30	\N	2026-09-10 17:25:28.949+05:30	11111111-1111-1111-1111-111111111111	a9c0a79345cc88298d52e3ac3ca2d190b1385f937c15e99d6426c74155eabcfd	2026-09-10 17:40:14.864+05:30	\N
f2ecc723-2683-4485-9164-a72f61209460	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-09 15:06:49.175+05:30	\N	2026-09-09 15:06:49.177+05:30	11111111-1111-1111-1111-111111111111	a98bdd4742c81e645f66dd798e3fbc54a0f9f7cbb14dbffbb2df9c3d1dc44cc5	2026-09-09 15:21:43.279+05:30	\N
52d47f7e-1d21-4b72-8aed-51b726644659	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-10 16:49:22.078+05:30	\N	2026-09-10 16:49:22.082+05:30	11111111-1111-1111-1111-111111111111	83b5f7c9d0f32877103d7f8f63a2b8a938d9d07d5f73db4ff2d0eaa6e1e1e05a	2026-09-10 17:04:08.535+05:30	\N
67a74320-c693-44db-ba74-fe381dcd46d3	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-10 17:58:21.118+05:30	\N	2026-09-10 17:58:21.12+05:30	11111111-1111-1111-1111-111111111111	ad46a8089d624ba3a3cdfca8c227d187d70d70bbbd4837f66a822d51a306d315	2026-09-10 17:58:22.189+05:30	\N
52a30d42-feff-4037-bade-600c2fab6397	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-11 10:23:08.003+05:30	\N	2026-09-11 10:23:08.006+05:30	11111111-1111-1111-1111-111111111111	b2592d101ca4c86936c3929972082d82659111d06f7ad05ec5ec502bad33c9e3	2026-09-11 10:24:03.163+05:30	\N
b3f325fc-b6db-4ec7-a3c8-5ab649df5a32	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-11 11:28:19.072+05:30	\N	2026-09-11 11:28:19.073+05:30	11111111-1111-1111-1111-111111111111	779ef870e01ef4b917a525b24e8194df9c98cfe9f1dbf5673de648d9bb24edf6	2026-09-11 11:29:54.899+05:30	\N
ff83b706-5366-47fc-aa3c-18eed77dd422	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-11 11:09:46.311+05:30	\N	2026-09-11 11:09:46.313+05:30	11111111-1111-1111-1111-111111111111	bd2fa2345a722938f16dec5a9aef39e3ee918fc296b3c44ba16a166b3a0c11da	2026-09-11 11:17:07.616+05:30	\N
78158cc0-0acc-42db-a5bc-fd1b848d5b1c	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-11 11:30:04.359+05:30	\N	2026-09-11 11:30:04.363+05:30	11111111-1111-1111-1111-111111111111	6938accf4a114ea643ed7e82f7603dd5a9a2c0ce4ee9767f8dd5d276aaf26318	2026-09-11 11:30:34.915+05:30	\N
3f57d809-fffb-4f64-955e-78b3c906c1ca	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-11 11:30:47.806+05:30	\N	2026-09-11 11:30:47.811+05:30	11111111-1111-1111-1111-111111111111	e3df115455cc2df3a979440d50eb97dc07ef02aff3e39c9f4e042bec5dd014ef	2026-09-11 11:39:45.989+05:30	\N
3fa67bc1-ed4d-4c0b-8872-2282713c28c7	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-11 11:53:11.696+05:30	\N	2026-09-11 11:53:11.698+05:30	11111111-1111-1111-1111-111111111111	d23dbdce50aada31e37ae622e934f6371e9e0dddad7603b85901bbdb64962706	2026-09-11 11:53:11.698+05:30	\N
9507e882-4159-4970-b8fb-814271944d71	5e635b7d-856a-40b8-8a8c-1398f74eca30	\N	\N	\N	2026-10-11 12:00:49.071+05:30	\N	2026-09-11 12:00:49.083+05:30	11111111-1111-1111-1111-111111111111	b1e0f735a539c9bd1f0103738d65bd530168718928942e83da3799dac05dc379	2026-09-11 12:00:49.083+05:30	\N
7ebaa51e-e6ee-4b28-b0b7-453c304b308d	72bad3bb-6097-47d2-bfc2-35b1244a7b9f	\N	\N	\N	2026-10-11 12:00:49.253+05:30	\N	2026-09-11 12:00:49.266+05:30	11111111-1111-1111-1111-111111111111	e13376ff75e79da4c71da7d709cf2b434e016d9deb0a70e96d03c7d00455a838	2026-09-11 12:00:49.266+05:30	\N
48cfd559-022e-4e0f-a19a-c6bb2fb53d80	5c660c1f-f5f8-4007-87a6-b4b39913998b	\N	\N	\N	2026-10-11 12:00:49.381+05:30	\N	2026-09-11 12:00:49.394+05:30	11111111-1111-1111-1111-111111111111	4b3bdf7361f06f17828a0ecf422f936309787985d029e97ea4987c659a554e54	2026-09-11 12:00:49.394+05:30	\N
3de4138c-4d12-437b-a64a-4ea514cf58b2	5e635b7d-856a-40b8-8a8c-1398f74eca30	\N	\N	\N	2026-10-11 12:08:28.084+05:30	\N	2026-09-11 12:08:28.09+05:30	11111111-1111-1111-1111-111111111111	fe993b5a5bb9e645290adedf29e43b0c2c958eef9824c59cf6df6b06bed60194	2026-09-11 12:08:28.09+05:30	\N
f9993338-c197-4cab-8a50-31bea13bd878	72bad3bb-6097-47d2-bfc2-35b1244a7b9f	\N	\N	\N	2026-10-11 12:08:28.322+05:30	\N	2026-09-11 12:08:28.328+05:30	11111111-1111-1111-1111-111111111111	79aab26c81071db90bc5340996822d5770adb6313ff7ec46d2b62b96fc8e5051	2026-09-11 12:08:28.328+05:30	\N
6ddf3d78-ccd1-4e33-a564-84c995e60552	5c660c1f-f5f8-4007-87a6-b4b39913998b	\N	\N	\N	2026-10-11 12:08:28.504+05:30	\N	2026-09-11 12:08:28.511+05:30	11111111-1111-1111-1111-111111111111	4cd6d3709eb9f610cb0f1f51c7295cf9d6357d3cf6fb168a19a31f98685d48dd	2026-09-11 12:08:28.511+05:30	\N
24860b61-4f37-44d0-8781-930ba11e4982	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-11 12:08:56.262+05:30	\N	2026-09-11 12:08:56.269+05:30	11111111-1111-1111-1111-111111111111	2784aa933748d1b24d32653a8cf6b80d5d1bd4604a81c7560ec6b63854b840a7	2026-09-11 12:08:56.269+05:30	\N
f83c2870-6c43-4942-9bbb-669ce8e1c28a	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-11 14:24:08.836+05:30	\N	2026-09-11 14:24:08.837+05:30	11111111-1111-1111-1111-111111111111	17444a1476b76292fccc89480c83ad76bfca8677725243c7372aaae2dd02b88e	2026-09-11 14:24:55.069+05:30	\N
283c8718-c72a-4389-81b3-a3dd9c2130c6	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-11 12:09:12.301+05:30	\N	2026-09-11 12:09:12.308+05:30	11111111-1111-1111-1111-111111111111	d7a2beaf9ad58ec9ebac6a9cd89c162c74eb5465e259c02c87263861591a7c82	2026-09-11 12:09:31.226+05:30	\N
d181b7d4-01cd-474c-8e9a-889025e6e2b3	5c660c1f-f5f8-4007-87a6-b4b39913998b	\N	\N	\N	2026-10-11 12:09:33.054+05:30	\N	2026-09-11 12:09:33.058+05:30	11111111-1111-1111-1111-111111111111	710d370d8e3606e65fa7ba38430dacfa55e815cb87e67a2fe6072f6159c26487	2026-09-11 12:09:48.638+05:30	\N
73d82988-0594-4f58-a1b2-e2c2c97b27be	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-23 14:11:55.743+05:30	\N	2026-09-23 14:11:55.756+05:30	11111111-1111-1111-1111-111111111111	0c9268ece48c0cadb7fdb81b2064dd2ea00503603e0a9c1bca74bd46ae2f117c	2026-09-23 14:11:55.756+05:30	\N
0da19c67-28f2-4a1a-9283-adfd6e205941	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-11 15:19:05.715+05:30	\N	2026-09-11 15:19:05.716+05:30	11111111-1111-1111-1111-111111111111	d7130d6e49ad709dfd8c9f89232f665815c4fcce91c83b5102bae345629e9510	2026-09-11 15:19:21.978+05:30	\N
c3f079e2-25df-4e53-ae93-daa8477e50c1	72bad3bb-6097-47d2-bfc2-35b1244a7b9f	\N	\N	\N	2026-10-11 14:25:03.814+05:30	\N	2026-09-11 14:25:03.815+05:30	11111111-1111-1111-1111-111111111111	d2fc2093edc6eb70cb1f6b4b7a22b42b225764bab0df66bc5d611eca91fd2459	2026-09-11 14:25:34.344+05:30	\N
ae6b4532-92d4-41b4-9acb-7fb3b337de7c	5c660c1f-f5f8-4007-87a6-b4b39913998b	\N	\N	\N	2026-10-11 12:33:18.269+05:30	\N	2026-09-11 12:33:18.27+05:30	11111111-1111-1111-1111-111111111111	ea195e1f19141b68b76cb90a06b1f1ac94928a16f3d426ae68a0290c5359d8f2	2026-09-11 12:35:44.668+05:30	\N
dc7b26bc-f7fd-4bf7-9310-3031b95155c0	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-23 14:13:49.336+05:30	\N	2026-09-23 14:13:49.341+05:30	11111111-1111-1111-1111-111111111111	e62fe6d7ff84b6a461ff24344d39a847d82957cbce76200d79ed851fbdff045e	2026-09-23 14:13:49.341+05:30	\N
9ada0575-9d90-4daa-af5b-e91c634ff4e9	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-11 16:12:06.213+05:30	\N	2026-09-11 16:12:06.215+05:30	11111111-1111-1111-1111-111111111111	f9875e879cd4c1ca2349ac1457dd6cf90addd3eb49176b82c94863947de277bd	2026-09-11 16:20:41.701+05:30	\N
d006c031-e2e2-4641-88ab-4f5a8b37da27	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-11 16:39:17.469+05:30	\N	2026-09-11 16:39:17.471+05:30	11111111-1111-1111-1111-111111111111	c70270f179ed6313c5b0f03baa924c858b0c226f2010c59652e42f05afbd6435	2026-09-11 16:39:29.413+05:30	\N
3bcb49da-d424-4241-a185-bd7875d81344	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-11 12:59:09.449+05:30	\N	2026-09-11 12:59:09.451+05:30	11111111-1111-1111-1111-111111111111	bf5be3107e6759524c5eb6fa83ecc7c7b4d2dc21275ad77498a717d5fdc04dc1	2026-09-11 13:13:25.031+05:30	\N
1f32c5f0-6cff-4370-a828-269903536268	5e635b7d-856a-40b8-8a8c-1398f74eca30	\N	\N	\N	2026-10-11 14:10:25.07+05:30	\N	2026-09-11 14:10:25.072+05:30	67315042-c687-4cbb-b45a-f4ea4efc199f	892eff72ada2dba5509ca90a322cf0c30dda35fd0045e4f8438c70f2aea669e7	2026-09-11 14:10:25.072+05:30	\N
5d7b41ff-755e-4ad2-8ad5-6238d201d92d	72bad3bb-6097-47d2-bfc2-35b1244a7b9f	\N	\N	\N	2026-10-11 14:10:25.214+05:30	\N	2026-09-11 14:10:25.216+05:30	67315042-c687-4cbb-b45a-f4ea4efc199f	1cae85aa2c2cc0a7adf1bce0bfc4ba7a6e9e51706ba8eaeaaaeac41e59f2630b	2026-09-11 14:10:25.216+05:30	\N
2c267af2-9a98-4d64-8cbe-4e20c0f550da	5e635b7d-856a-40b8-8a8c-1398f74eca30	\N	\N	\N	2026-10-11 14:11:01.642+05:30	\N	2026-09-11 14:11:01.644+05:30	67315042-c687-4cbb-b45a-f4ea4efc199f	9c8b849c285d3092f22453a10a9b37419a65cd261cdf903d472c911a01698fc3	2026-09-11 14:11:01.644+05:30	\N
be599705-f403-4e56-be8a-3a2a756e386c	72bad3bb-6097-47d2-bfc2-35b1244a7b9f	\N	\N	\N	2026-10-11 14:11:01.787+05:30	\N	2026-09-11 14:11:01.789+05:30	67315042-c687-4cbb-b45a-f4ea4efc199f	c3e8763221fa386a2c6cc377834777b9c7797401f658cc5ed1ae1cbcd0e33e69	2026-09-11 14:11:01.789+05:30	\N
d54223ed-def8-4d09-b3b7-25796a746fa5	5e635b7d-856a-40b8-8a8c-1398f74eca30	\N	\N	\N	2026-10-11 12:35:52.386+05:30	\N	2026-09-11 12:35:52.387+05:30	11111111-1111-1111-1111-111111111111	77d7790a1529b1b23b9d151fcf998e6cab2f2c1a3b850a7e9c76e3040d9b864d	2026-09-11 12:50:37.029+05:30	\N
a0df329f-6594-4b9f-bffd-15db3a05837b	5e635b7d-856a-40b8-8a8c-1398f74eca30	\N	\N	\N	2026-10-11 14:12:08.356+05:30	\N	2026-09-11 14:12:08.357+05:30	67315042-c687-4cbb-b45a-f4ea4efc199f	08dca02b85d773d86f74a31e6f05ec2de93f553f283fc5bb47e094238c50fcc0	2026-09-11 14:12:08.357+05:30	\N
a734526b-cd06-4f63-bcd7-e01b509daec1	72bad3bb-6097-47d2-bfc2-35b1244a7b9f	\N	\N	\N	2026-10-11 12:09:59.466+05:30	\N	2026-09-11 12:09:59.47+05:30	11111111-1111-1111-1111-111111111111	6b68c0a598c17ba2858bcf1a19bcc6ad8f836ef9c9da62bfc637da2e67d2c7a4	2026-09-11 12:24:25.052+05:30	\N
4ac32d00-46c1-45a5-a0eb-cf5e82e5f13c	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-11 12:33:02.118+05:30	\N	2026-09-11 12:33:02.119+05:30	11111111-1111-1111-1111-111111111111	cbef961628279e0b57c9bc01117fb014db194ab4f1017d9a97447559d192ddd9	2026-09-11 12:33:03.319+05:30	\N
51f00ed1-071b-4375-a15a-4a6c40cf929d	72bad3bb-6097-47d2-bfc2-35b1244a7b9f	\N	\N	\N	2026-10-11 14:12:08.551+05:30	\N	2026-09-11 14:12:08.552+05:30	67315042-c687-4cbb-b45a-f4ea4efc199f	9c02a75c782616d201ee98fbbe8c61baeea950df5e604e5db5445a68165db41a	2026-09-11 14:12:08.552+05:30	\N
44a0a2d5-0658-45c6-8704-62b33cc7a090	5e635b7d-856a-40b8-8a8c-1398f74eca30	\N	\N	\N	2026-10-11 14:16:06.985+05:30	\N	2026-09-11 14:16:06.996+05:30	67315042-c687-4cbb-b45a-f4ea4efc199f	f570d53d8983b8ef42a868cb0103ec43be59516574fe630b4a09b7bbdf4fcb18	2026-09-11 14:16:06.996+05:30	\N
b0d1147a-185f-42e2-b9dd-7678c9fbe4e3	72bad3bb-6097-47d2-bfc2-35b1244a7b9f	\N	\N	\N	2026-10-11 14:16:07.154+05:30	\N	2026-09-11 14:16:07.164+05:30	67315042-c687-4cbb-b45a-f4ea4efc199f	82268efcf7f8c60d2192446044bd9256ffe5e0bb559de8262aa85c3659cf9e81	2026-09-11 14:16:07.164+05:30	\N
bebe0ba6-4ebe-4405-bf5b-5b47dc101fc5	5e635b7d-856a-40b8-8a8c-1398f74eca30	\N	\N	\N	2026-10-11 14:19:07.089+05:30	\N	2026-09-11 14:19:07.092+05:30	67315042-c687-4cbb-b45a-f4ea4efc199f	86b19527696a40c26f95efe6ed4e6610c57d30a53680047fcd70fb3bce062cad	2026-09-11 14:19:07.092+05:30	\N
a1817cc8-4872-4a07-b003-446c6434cce0	72bad3bb-6097-47d2-bfc2-35b1244a7b9f	\N	\N	\N	2026-10-11 14:19:07.242+05:30	\N	2026-09-11 14:19:07.245+05:30	67315042-c687-4cbb-b45a-f4ea4efc199f	c1fdcb34efd0b56dd7969ffb0b04db7f044c83becc9dedbb68a1b7aad57c50af	2026-09-11 14:19:07.245+05:30	\N
0ceb04d2-3860-4357-a174-345aae7220db	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-11 14:41:44.057+05:30	\N	2026-09-11 14:41:44.059+05:30	11111111-1111-1111-1111-111111111111	804d9d4f70ae4b193c61d1a75cbf3822c34203a5b3c82a5fcf3cb7a9d71a499a	2026-09-11 14:43:56.522+05:30	\N
d0572568-93ce-45f2-a889-fbe418d3a6c1	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-11 17:01:27.146+05:30	\N	2026-09-11 17:01:27.147+05:30	11111111-1111-1111-1111-111111111111	ea422ed0bb38de70c1a7791bcb557a05a5735832c0c20c2d1b8b8bcc26ab996e	2026-09-11 17:01:27.147+05:30	\N
f6e94814-e7d2-466b-9910-394dfe170675	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-11 17:18:40.591+05:30	\N	2026-09-11 17:18:40.601+05:30	11111111-1111-1111-1111-111111111111	4e4198df457a61736dd6c70eafa5284abdaf7366b59d5bb6eee43d96ee8991a4	2026-09-11 17:18:40.601+05:30	\N
4bc863e5-66c2-4c6e-90a6-4f608dd7d736	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-10-11 17:18:40.81+05:30	\N	2026-09-11 17:18:40.82+05:30	11111111-1111-1111-1111-111111111111	bcb2e2fb9b26dd54b97cc4d1a0de30d9ee480f44af4541a4d774f2aa0c09d25b	2026-09-11 17:18:40.82+05:30	\N
0c98f20d-ce61-48ae-a606-3c9d9d6f7223	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-11 17:18:41.07+05:30	\N	2026-09-11 17:18:41.08+05:30	11111111-1111-1111-1111-111111111111	b950332a1855c46c9c7e7ae4eac5724089f8b3af1fe11a6a887dd66562ddbe29	2026-09-11 17:18:41.08+05:30	\N
67662fb3-129f-42dd-bbd2-9b14fec3621f	72bad3bb-6097-47d2-bfc2-35b1244a7b9f	\N	\N	\N	2026-10-11 14:44:00.8+05:30	\N	2026-09-11 14:44:00.801+05:30	11111111-1111-1111-1111-111111111111	90f8088520a4d7529c894e6283cf4438eaf88326c49f4ff1f853b3e6baa19807	2026-09-11 14:58:15.028+05:30	\N
d09614c3-c5c7-4bdc-907c-e73025cf5e5e	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-11 17:18:41.229+05:30	\N	2026-09-11 17:18:41.238+05:30	11111111-1111-1111-1111-111111111111	5d726cbefa897e268aa7ee554c7c55873116a1e19e53ab13fb4cb23a756666b0	2026-09-11 17:18:41.238+05:30	\N
d2e7f5cc-9f4e-40ea-980b-bc430a2ccb97	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-11 17:21:39.64+05:30	\N	2026-09-11 17:21:39.654+05:30	11111111-1111-1111-1111-111111111111	623244957af8b3539762c551af69e03ea8190092159d803f8007b65e9155a7d5	2026-09-11 17:21:39.654+05:30	\N
df5c5e52-63bf-4518-ad2b-5d28a4107108	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-10-11 17:21:40.087+05:30	\N	2026-09-11 17:21:40.102+05:30	11111111-1111-1111-1111-111111111111	5a29c64607a7f5cb2af0d92c2f399233f38d01b21cf80962271fb49121e9a550	2026-09-11 17:21:40.102+05:30	\N
24ceb359-dfd5-470f-b310-2c5415ca33e0	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-11 17:21:40.443+05:30	\N	2026-09-11 17:21:40.457+05:30	11111111-1111-1111-1111-111111111111	2c1f0468e51799864ad801270e432564ee11f47ed4ac98b2930ae9bcdf44d051	2026-09-11 17:21:40.457+05:30	\N
9550abba-e8a4-4365-9afc-8c238410f3d0	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-23 15:01:20.905+05:30	\N	2026-09-23 15:01:20.907+05:30	11111111-1111-1111-1111-111111111111	e2a188baad3eeffe8a58a63c50a42afdc09d66e17d7843093eb802b4980d7c97	2026-09-23 15:01:20.907+05:30	\N
b8ab9476-1060-4575-9ff9-2e7e4c443d1f	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-24 05:52:30.457+05:30	\N	2026-09-24 05:52:30.459+05:30	11111111-1111-1111-1111-111111111111	8a3572dbdb413b2c7caef1ab375328c1f3534a91ead865508f1a97520e487402	2026-09-24 05:52:30.459+05:30	\N
6ecf6a5b-5089-493f-b83a-e3a7e38e9db6	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-24 06:07:47.818+05:30	\N	2026-09-24 06:07:47.82+05:30	11111111-1111-1111-1111-111111111111	fe4300454e8ed88800f274493139823d9030498bd10ca82c4fcf9bd5bd9ee8db	2026-09-24 06:07:47.82+05:30	\N
81f5ced5-ac9f-46cf-a39d-beac5e520cea	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-11 17:21:40.591+05:30	\N	2026-09-11 17:21:40.605+05:30	11111111-1111-1111-1111-111111111111	ce459dca94777f49fe5cd3d599b278ce09bd5e632f2808fbbd4e38b378d3158f	2026-09-11 17:21:40.605+05:30	\N
49353758-818b-497a-b8cd-601f84e64c34	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-11 17:23:57.256+05:30	\N	2026-09-11 17:23:57.258+05:30	11111111-1111-1111-1111-111111111111	6f259167dad507bdc5be309e7c0cb989cd32a93e0dcf4d14d9c1bf5c7d90f3ca	2026-09-11 17:23:57.258+05:30	\N
d4d61101-8839-415c-a1c4-c1413c6c63ba	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-11 17:26:24.833+05:30	\N	2026-09-11 17:26:24.836+05:30	11111111-1111-1111-1111-111111111111	dcc0bad5dff2ec57ff3645f00455c07cdd11b94aa2941143dc14ff88cfcf6f35	2026-09-11 17:26:24.836+05:30	\N
996a8355-945e-4dca-bce7-1286aab90fe9	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-12 15:12:06.571+05:30	\N	2026-09-12 15:12:06.574+05:30	11111111-1111-1111-1111-111111111111	825fd80159e60fd886802db97955b33a1c959b96694cbd06ee8ec0dc2abaafb7	2026-09-12 15:27:05.97+05:30	\N
84162277-e122-4d17-97c0-5cb2b7d16253	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-12 15:28:27.131+05:30	\N	2026-09-12 15:28:27.132+05:30	11111111-1111-1111-1111-111111111111	6ed387a7ccb52fa30e430f8c459306239688b886df2cda8a2edc85c38d79a78b	2026-09-12 15:28:27.132+05:30	\N
c82e3153-de96-4d4a-b363-c22d699b7d12	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-11 17:27:33.792+05:30	\N	2026-09-11 17:27:33.794+05:30	11111111-1111-1111-1111-111111111111	a686489dcf8a7bb69ea2f957e252681c6e9ef392c1f3cb92c6c18027e9e1756d	2026-09-11 17:28:12.25+05:30	\N
5969acf6-ae2a-4871-a716-4ad3f354344f	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-12 11:37:06.825+05:30	\N	2026-09-12 11:37:06.828+05:30	11111111-1111-1111-1111-111111111111	a218bc615e8561e7378c8625848ccdfab61141cd19d0d781ac90b50debc8e7ca	2026-09-12 11:37:06.828+05:30	\N
012b108d-f5dc-4e24-9fa2-2b50518bef79	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-12 12:03:02.69+05:30	\N	2026-09-12 12:03:02.703+05:30	11111111-1111-1111-1111-111111111111	8430af2649335ae472117e3c827fad50cb20396a7494c0e90d44d98d58cc3d3e	2026-09-12 12:03:02.703+05:30	\N
9638bbca-55d3-4dc3-8b75-3dfe65bfdf77	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-12 12:03:15.611+05:30	\N	2026-09-12 12:03:15.624+05:30	11111111-1111-1111-1111-111111111111	1cb3713b31861c258944f01c2d5a293743970edeacef58ee430cd7ddbc3eb017	2026-09-12 12:03:15.624+05:30	\N
aa1e47ca-73e9-4e1d-a9dc-27acc1336e6b	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-12 12:07:26.043+05:30	\N	2026-09-12 12:07:26.045+05:30	11111111-1111-1111-1111-111111111111	ad18174a8d772d457f7edbf232387143f1dc9ab0b027d83e368dbd69227754bb	2026-09-12 12:07:26.045+05:30	\N
5a0e38f1-e775-4139-9ef7-b7cb53157add	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-23 15:13:46.363+05:30	\N	2026-09-23 15:13:46.365+05:30	11111111-1111-1111-1111-111111111111	e77948e0624f7ed26a8bd1bd80f38717e72dfbdf50ef6c94c0a570a55e461d46	2026-09-23 15:13:46.365+05:30	\N
97b6cd39-c620-4392-a29f-a292ec13a1e7	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-10-12 16:35:39.248+05:30	\N	2026-09-12 16:35:39.264+05:30	11111111-1111-1111-1111-111111111111	85573ec91ea8885458b875a9923c7fd3a29f57087991ec1260c5ef5fdb39af41	2026-09-12 16:50:28.158+05:30	\N
86e7e9f2-6f3d-4b60-9237-6ff981843418	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-12 12:12:11.055+05:30	\N	2026-09-12 12:12:11.057+05:30	11111111-1111-1111-1111-111111111111	6da55972e0134205bf0501919d1fb2cfbe867a60166dad960660de954963cd22	2026-09-12 12:13:00.429+05:30	\N
28d54eaa-256c-43b9-8f23-558c4b569236	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-12 17:22:26.457+05:30	\N	2026-09-12 17:22:26.46+05:30	11111111-1111-1111-1111-111111111111	c2859243c61c485b9dd30cb702daf2523b4e51888964d7bbdfef0fa8ffd479e7	2026-09-12 17:22:26.46+05:30	\N
8f889ce2-3400-4af0-8176-176a7c81f5c9	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-14 15:46:00.136+05:30	\N	2026-09-14 15:46:00.139+05:30	11111111-1111-1111-1111-111111111111	04b41aff2d1719ebff304b53a38db9ee73599b1e6958c0bd9aee143b87c243b8	2026-09-14 15:46:00.139+05:30	\N
f0cd4856-9dbd-4ca0-9a75-06599a815f14	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-15 15:29:14.843+05:30	\N	2026-09-15 15:29:14.848+05:30	67315042-c687-4cbb-b45a-f4ea4efc199f	5d6bdebbbf1aac91eb97da3ad61b265c1dcd3c2deb386d3753619d4ec17fe09a	2026-09-15 15:29:14.848+05:30	\N
78eb9f1e-b619-4319-88b0-806f96605f5f	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-12 15:29:10.873+05:30	2026-09-12 15:30:19.916+05:30	2026-09-12 15:29:10.874+05:30	11111111-1111-1111-1111-111111111111	50b11acd174261425e38ecaaab67e53600914b3c8946486e59b1f20f6e2dc319	2026-09-12 15:30:19.923+05:30	\N
e2804d9e-d23d-4c77-bac0-ef5a49d68245	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-15 15:31:46.768+05:30	\N	2026-09-15 15:31:46.783+05:30	67315042-c687-4cbb-b45a-f4ea4efc199f	55afb7377b44e9c132adb010c27903236aca7729c4637359125b514496eb7385	2026-09-15 15:31:46.783+05:30	\N
67ce1c37-1d25-4f3b-aba2-e118064e3a7c	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-12 15:30:58.231+05:30	\N	2026-09-12 15:30:58.238+05:30	11111111-1111-1111-1111-111111111111	c530ddbc21aceb88ef8021a74dfcd1fe904ec964988e50ff44aa6589c1681a47	2026-09-12 15:31:34.852+05:30	\N
16b514fc-439b-4b8e-8942-b72008810ff1	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-10-15 15:34:33.64+05:30	\N	2026-09-15 15:34:33.642+05:30	11111111-1111-1111-1111-111111111111	41570a12cba8691bb764866a0c56ab8be895862e0031c0a02acb866d9614b39c	2026-09-15 15:34:33.642+05:30	\N
701e2422-b119-469a-9de9-6c3e7a5b0b0d	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-15 15:38:06.355+05:30	\N	2026-09-15 15:38:06.357+05:30	67315042-c687-4cbb-b45a-f4ea4efc199f	f6fad6b9b558abcdb6e012b1077450215d39a414ec02f1bc0df76d3c1213bc98	2026-09-15 15:38:06.357+05:30	\N
c3f51e58-abe5-4cb5-8b37-bea9a5ebdc1c	72bad3bb-6097-47d2-bfc2-35b1244a7b9f	\N	\N	\N	2026-10-12 16:04:28.167+05:30	\N	2026-09-12 16:04:28.168+05:30	11111111-1111-1111-1111-111111111111	e728fe12ea8c3c152bdb7459c6923fe6df7055ba1fb3c4679021465efc064678	2026-09-12 16:19:23.154+05:30	\N
ae0f25fc-1b7f-43e2-9e40-7fae6569a4f4	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-12 16:20:28.167+05:30	\N	2026-09-12 16:20:28.17+05:30	11111111-1111-1111-1111-111111111111	1357b9b43893b97ea4cb62d1d5b9fc65e5fa3d029228521d958c72d3cdd18004	2026-09-12 16:20:28.17+05:30	\N
aafe6944-e990-41f7-8902-e0ecb001c421	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-15 16:16:23.628+05:30	\N	2026-09-15 16:16:23.632+05:30	11111111-1111-1111-1111-111111111111	271f239b3fe78f5daf95618d657df2054181badc5aa89ef6ce101900764de783	2026-09-15 16:16:23.632+05:30	\N
b34f17f7-6377-41bf-93fb-0f448f1e122c	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-15 16:17:20.606+05:30	\N	2026-09-15 16:17:20.607+05:30	11111111-1111-1111-1111-111111111111	b585360f7006d434a01e5f6678f91c2ca5dd49ef6ec2adaba64eb63c6ca0e447	2026-09-15 16:17:20.607+05:30	\N
9bac0cf7-adf9-45c8-bf0e-a4a012e69b54	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-23 15:22:33.246+05:30	\N	2026-09-23 15:22:33.261+05:30	11111111-1111-1111-1111-111111111111	c87b3cbf12a2de56560c481e875ac8d1761093e7d99e2845eba0594f533477a6	2026-09-23 15:22:33.261+05:30	\N
9968f598-e761-4e4a-9f29-25ca54222525	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-24 00:00:12.986+05:30	\N	2026-09-24 00:00:12.857+05:30	11111111-1111-1111-1111-111111111111	237b6e1ab396992f5453004b35f6dff4572431262cb5d16ba71044ef84b1b711	2026-09-24 00:00:12.857+05:30	\N
acca3455-493b-48c2-bc93-3c7d75884f03	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-16 10:40:41.837+05:30	\N	2026-09-16 10:40:41.838+05:30	11111111-1111-1111-1111-111111111111	13037819bc4eae5aedc518c612b757762b6cf25ebebe6f3e9b59d9aea24e1636	2026-09-16 10:41:32.988+05:30	\N
7dcef83c-c850-4fc6-b75a-3109264cf3c7	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-23 13:01:30.928+05:30	\N	2026-09-23 13:01:30.936+05:30	11111111-1111-1111-1111-111111111111	62c92ef6175865477b64537b52a842f95f9bffa055fde14bb33bb5db3c609b89	2026-09-23 13:01:30.936+05:30	\N
cae91305-bbeb-43e5-b716-45ff64da8e8c	72bad3bb-6097-47d2-bfc2-35b1244a7b9f	\N	\N	\N	2026-10-12 15:31:38.308+05:30	\N	2026-09-12 15:31:38.316+05:30	11111111-1111-1111-1111-111111111111	67e6ed938db16f9260344437c01152d5074f0d8f1117801f5663687b0cfd2752	2026-09-12 15:46:23.949+05:30	\N
31d30806-a6ce-4830-8c47-526f4c71b2f7	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-12 16:03:51.926+05:30	\N	2026-09-12 16:03:51.928+05:30	11111111-1111-1111-1111-111111111111	d6299d6a2484346403a9b8ba7c68c650d92e1b7a34d5377e745b8103afeb9c13	2026-09-12 16:04:14.379+05:30	\N
9a928fb0-09d9-4a5a-aacb-72676d398726	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-12 16:20:35.417+05:30	\N	2026-09-12 16:20:35.419+05:30	11111111-1111-1111-1111-111111111111	09d2719ff0b8ae1c139684dec51e5ab70125736786ca6e35c25a19575391cf68	2026-09-12 16:35:18.283+05:30	\N
34a7e0a1-5db8-46ba-9a7d-5ce45fe56058	72bad3bb-6097-47d2-bfc2-35b1244a7b9f	\N	\N	\N	2026-10-12 12:13:14.943+05:30	\N	2026-09-12 12:13:14.948+05:30	11111111-1111-1111-1111-111111111111	123485974d027e38d76b7cf29ac9a4d4056190c626739dada670519ed6092330	2026-09-12 12:28:00.557+05:30	\N
353b1d63-b301-41f9-9fc1-5f2f8cdad845	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-12 12:30:14.639+05:30	\N	2026-09-12 12:30:14.641+05:30	11111111-1111-1111-1111-111111111111	f92166b97d2c0fe42e084e0aea2a24f271d57cf12234dacb05798945ed861b31	2026-09-12 12:30:14.641+05:30	\N
449ca986-b806-4b12-8e6d-e6ca72cb9e7c	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-12 16:04:44.751+05:30	\N	2026-09-12 16:04:44.755+05:30	11111111-1111-1111-1111-111111111111	c0c7e3adf7b264f97165b30d5e029736e952f443ffba416059782d2c44abfff8	2026-09-12 16:04:44.755+05:30	\N
4d9b3776-6d44-40a2-a224-cb3acc470e46	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-12 16:36:44.688+05:30	\N	2026-09-12 16:36:44.692+05:30	11111111-1111-1111-1111-111111111111	190913cc3cbee0de8474d99d01338d467dcc2d1d64c87108b8c558f02c9b6a3b	2026-09-12 16:36:44.692+05:30	\N
b8439a85-a711-4814-aa53-f0aa1b0abe69	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-23 13:02:10.902+05:30	\N	2026-09-23 13:02:10.91+05:30	11111111-1111-1111-1111-111111111111	d5e2ba350dead0253a66fe10c4113b84b3f0a92416db048f22a9173f128f8f7f	2026-09-23 13:02:10.91+05:30	\N
d4576e50-84f3-4234-bd6a-e26f854b6a2c	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-23 13:02:31.533+05:30	\N	2026-09-23 13:02:31.54+05:30	11111111-1111-1111-1111-111111111111	caff817e747920ee5ef4093e4aa3ee60abf093552537c0d8785e6ff868bf19be	2026-09-23 13:02:31.54+05:30	\N
aee71db6-31a5-45ce-88d3-4954b17b4408	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-23 13:13:30.662+05:30	\N	2026-09-23 13:13:30.673+05:30	11111111-1111-1111-1111-111111111111	5ffbcf355f15827488ca2a60894c9b697b86795c8f3f5eecce483f49f86cabcb	2026-09-23 13:13:30.673+05:30	\N
b2284802-1658-41c4-bcdb-db2be9a77414	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-10-23 13:18:37.293+05:30	\N	2026-09-23 13:18:37.295+05:30	11111111-1111-1111-1111-111111111111	0a7e6a7191d08469b343e081415a7cec501f6a1cd944a09e3208983b92863e19	2026-09-23 13:23:08.501+05:30	\N
043a75f7-a5b4-4fea-8646-7ee41f0faa47	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-24 00:22:04.503+05:30	\N	2026-09-24 00:22:04.516+05:30	11111111-1111-1111-1111-111111111111	9fcce66ce221846ba80ae739091fb4e48dbe72763e17402d9452d3f73673f858	2026-09-24 00:22:04.516+05:30	\N
54e7ad1e-796c-43bf-8fe0-09183d065a87	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-23 13:58:35.425+05:30	\N	2026-09-23 13:58:35.427+05:30	11111111-1111-1111-1111-111111111111	7c899a630604e26673b3a5cf52702f1e15a208dbb2c5256e8374ad2a69018650	2026-09-23 13:58:35.427+05:30	\N
3c713f50-16c9-4758-af66-fff82e341a0b	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-23 13:58:59.362+05:30	\N	2026-09-23 13:58:59.364+05:30	11111111-1111-1111-1111-111111111111	37510650992afdeab0e7eb1753d9adc3867a4092df43c58ce95ee7d20c0a00e5	2026-09-23 13:58:59.364+05:30	\N
6a4e3ee2-06a5-4a10-aee0-c0652d945881	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-10-23 14:03:40.573+05:30	\N	2026-09-23 14:03:40.58+05:30	11111111-1111-1111-1111-111111111111	f7aa1114b78679a2f44b9826b453c1dcbf1851ae58e78560ba746891a3c35152	2026-09-23 14:03:40.58+05:30	\N
9e1d3f60-973b-4e28-84f2-583b3eacacd8	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-23 14:03:56.466+05:30	\N	2026-09-23 14:03:56.472+05:30	11111111-1111-1111-1111-111111111111	e6dbe52d633a8e9f59ee65a98fb62cfa54133587526d6824966c2309ad7cffd0	2026-09-23 14:03:56.472+05:30	\N
785d5476-9ce4-4454-8405-7805c74bad46	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-24 06:33:12.522+05:30	\N	2026-09-24 06:33:12.527+05:30	11111111-1111-1111-1111-111111111111	ae2cc29ebf737f996b843ebc42a5a2f8b29bb23a22fb2c3a1ef0cdd8cb5fc1d0	2026-09-24 06:33:12.527+05:30	\N
96713fb1-f68b-4faa-a65a-cf0afe2e3850	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-24 06:50:35.258+05:30	\N	2026-09-24 06:50:35.259+05:30	11111111-1111-1111-1111-111111111111	b145625cfc01fe871189cc2f317a40627a82b314365b3da18bd892b52f4d841d	2026-09-24 06:50:35.259+05:30	\N
7ee57e43-4fc6-4b21-9dee-9e3d4310868c	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-24 08:41:30.293+05:30	\N	2026-09-24 08:41:30.295+05:30	11111111-1111-1111-1111-111111111111	0fdf0aeeabaad7b7a4a25a5a009cfe57f6eed2e34d2f5d1fcbd41d630035e67b	2026-09-24 08:41:30.295+05:30	\N
640c04da-fa0e-48fb-9e65-4118ec97bf3c	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-24 08:52:22.621+05:30	\N	2026-09-24 08:52:22.626+05:30	2a543c3c-066f-4097-833a-df7c25700580	9f430bc267d9f0abe32201553e736b8e4ec8b1eda9a3e3ff8c8e89b242166a3f	2026-09-24 08:52:22.626+05:30	\N
a0b91175-bd75-42c7-b1e0-4ee09554cee8	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-25 00:32:28.928+05:30	\N	2026-09-25 00:32:28.93+05:30	11111111-1111-1111-1111-111111111111	97da79981b8f911323417c7e78c7223a06f52a5ff6c462c245e1677b5f6e8da7	2026-09-25 00:46:27.172+05:30	\N
f3b05d33-084f-4c59-a0c0-c3a2fc63e220	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-31 14:30:08.785+05:30	\N	2026-10-01 14:30:08.794+05:30	11111111-1111-1111-1111-111111111111	be97e1cf86c0cc92f6d91342dbb400ad22ce83024f71cc0f7ff46bf2d0980121	2026-10-01 14:30:08.794+05:30	\N
87ae5b40-afc2-4aa2-81e8-252271a80450	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-24 08:52:30.683+05:30	\N	2026-09-24 08:52:30.687+05:30	67315042-c687-4cbb-b45a-f4ea4efc199f	95a98f8b7a3cf1f8621397a571fd7a46bf28c3c0614302105a99ef49ffefcc4b	2026-09-24 08:53:14.62+05:30	\N
793a69da-62eb-431a-ba98-7ef96b8d5084	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-11-01 16:13:37.037+05:30	\N	2026-10-02 16:13:37.041+05:30	11111111-1111-1111-1111-111111111111	0b51db95e443d9bd9d98a2f3fa946c16ec93fe42f241c17ad4b046ddf1f51e9b	2026-10-02 16:13:37.041+05:30	\N
2f545279-0b07-4a0f-b4f2-4c40c5411f1c	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-24 08:53:26.49+05:30	\N	2026-09-24 08:53:26.491+05:30	11111111-1111-1111-1111-111111111111	05336a247d14f323e69010a548d1e6487c8278768a231d4a92f6af5dfe2e9129	2026-09-24 08:53:56.388+05:30	\N
cf33083d-5fbc-4b1c-9bd4-dfff5cb9a1c5	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-25 00:16:19.297+05:30	\N	2026-09-25 00:16:19.299+05:30	11111111-1111-1111-1111-111111111111	3e29df6fef91a1744ef5297cc83c625c88727090a798fe3396c52d610b90c9c8	2026-09-25 00:30:28.181+05:30	\N
e1523456-0e7c-4bea-8d00-e1211f9696d8	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-24 09:03:00.744+05:30	\N	2026-09-24 09:03:00.751+05:30	11111111-1111-1111-1111-111111111111	7a47ccfc03eea800f2c6c916ab3ec32a3664d01161d43fcdb3a81dbf0481174e	2026-09-24 09:16:40.622+05:30	\N
6be701ee-5c1f-4014-a860-5444ce7e3013	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-24 08:54:58.435+05:30	\N	2026-09-24 08:54:58.437+05:30	67315042-c687-4cbb-b45a-f4ea4efc199f	72d91f8f90127707dca8c5d7540fa45d6fb699186f5a0726b1938d6275a54cf2	2026-09-24 08:56:15.935+05:30	\N
93298041-b673-41ec-992d-498281cb3be1	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-24 08:58:36.672+05:30	\N	2026-09-24 08:58:36.674+05:30	11111111-1111-1111-1111-111111111111	667e1a3e5f348526911a79f9cea07f0849b03f0b29570fa9638c5744051d1674	2026-09-24 08:58:36.674+05:30	\N
df5fa7f8-ea9d-4abb-b785-06a126d4e759	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-24 08:58:41.479+05:30	\N	2026-09-24 08:58:41.481+05:30	67315042-c687-4cbb-b45a-f4ea4efc199f	673a29bfb662b37fa0b0400ff0b9026c028c805336b9f626cf95d76516e95cf9	2026-09-24 08:58:41.481+05:30	\N
6bba1ade-f422-49d2-8539-fa7df42a26c3	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-24 08:58:46.327+05:30	\N	2026-09-24 08:58:46.328+05:30	11111111-1111-1111-1111-111111111111	de2665680c25e297e9bea5a3ca30f15e4a9650e90f0ef769f9a2613c338d8b68	2026-09-24 08:58:46.328+05:30	\N
ebebfabf-4753-43a8-b63d-1755e61636d5	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-24 08:59:08.519+05:30	\N	2026-09-24 08:59:08.52+05:30	67315042-c687-4cbb-b45a-f4ea4efc199f	99cc31ae8047da67fb62f8887486d06f052ed372691dc176e29a060cbe52b4ed	2026-09-24 09:02:53.837+05:30	\N
7c163185-650d-4252-ba69-2e5c7ef7b012	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-24 23:26:54.519+05:30	\N	2026-09-24 23:26:54.522+05:30	11111111-1111-1111-1111-111111111111	6c599525cd992ef3a054a533091c7c92248fa25218c579637b9827491a786d7a	2026-09-24 23:26:54.522+05:30	\N
a9675226-3b7f-422c-81e7-97dd38dc3238	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-24 23:32:05.276+05:30	\N	2026-09-24 23:32:05.279+05:30	11111111-1111-1111-1111-111111111111	85a63f8319f11aa8b1be6a6e6075a29c03f7e867bea05486c91c8099bee9e52c	2026-09-24 23:32:05.316+05:30	\N
626f41b5-4163-4164-89b5-416fe4b68e0c	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-24 23:33:02.923+05:30	\N	2026-09-24 23:33:02.925+05:30	11111111-1111-1111-1111-111111111111	984ae3532750d0b31b59466fdf1624d90b0b23e6ff921eedadbe5ba4f688da62	2026-09-24 23:33:02.925+05:30	\N
0e5dc761-16e1-4edd-a4bd-966d615c8d48	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-24 23:33:40.863+05:30	\N	2026-09-24 23:33:40.865+05:30	11111111-1111-1111-1111-111111111111	b9f4ba245e89a2e55e846bf9f3c5c321abd65986bfee0bc0cb992d89a7f5c2e1	2026-09-24 23:33:40.865+05:30	\N
76dbeb04-2b15-43b1-aad4-63b124916abf	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-24 23:35:45.405+05:30	\N	2026-09-24 23:35:45.411+05:30	2a543c3c-066f-4097-833a-df7c25700580	eb1c4f44b19a136fdbb342facaa3b7153b2413eb275d236be1253e0dc85045b5	2026-09-24 23:35:59.289+05:30	\N
23906680-8244-4aea-91bf-8f904a3006a2	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-24 23:48:18.112+05:30	\N	2026-09-24 23:48:18.12+05:30	11111111-1111-1111-1111-111111111111	bc3c749aa865128000a4ca1e64490dd57310a18ed64bb4fe3ed4724ddf9d0094	2026-09-24 23:51:36.154+05:30	\N
fdb442eb-6667-48bb-ad5a-2b9e6b2421c0	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-24 23:54:18.441+05:30	\N	2026-09-24 23:54:18.449+05:30	11111111-1111-1111-1111-111111111111	d863724f3ab6e386518eab84feda570b9b2d344437bc9675574be06e6fe19308	2026-09-24 23:54:18.487+05:30	\N
a4e7e480-a5a4-455d-bd21-33dda2469fe6	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-24 23:59:21.989+05:30	\N	2026-09-24 23:59:21.99+05:30	11111111-1111-1111-1111-111111111111	b7d282ed4d7be95e316b53f0844c08a06fbc8e997d3c9cd2ee6c80e12f831754	2026-09-25 00:06:54.182+05:30	\N
bb7f3fa6-b169-43a3-935e-bef04836ff69	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-25 00:07:00.402+05:30	\N	2026-09-25 00:07:00.409+05:30	11111111-1111-1111-1111-111111111111	b00c99e03fbb6d4433fd128c2e2eb1617419de93528aeed7047beb94a2a62e0d	2026-09-25 00:13:39.191+05:30	\N
1010e099-0aa1-4bfa-a632-2d1bf9689559	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-10-24 23:36:50.011+05:30	\N	2026-09-24 23:36:50.014+05:30	11111111-1111-1111-1111-111111111111	de88a9f564f40326c77432ccfdda9d584d15b605ed90c3500d01bd9ba1ae5f1b	2026-09-24 23:48:06.156+05:30	\N
5e775d5b-cca3-4a06-b3eb-3d674480af13	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-11-01 16:32:17.383+05:30	\N	2026-10-02 16:32:17.384+05:30	11111111-1111-1111-1111-111111111111	93315580291f53c0cefd7d8b886eb6fb62d95ddd2f0c4353b5f588fdbb34fd15	2026-10-02 16:46:18.147+05:30	\N
8d77812a-fc94-482c-adcd-0ba15fb5fa33	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-11-01 16:57:53.451+05:30	\N	2026-10-02 16:57:53.453+05:30	11111111-1111-1111-1111-111111111111	68b37cae227b6eff30ad6ee596f72056ae371ecb68df6662b4eb56a1bd2484b1	2026-10-02 16:57:53.453+05:30	\N
079c955a-d843-4ff4-b31a-59155854ebc2	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-11-01 16:57:53.728+05:30	\N	2026-10-02 16:57:53.731+05:30	11111111-1111-1111-1111-111111111111	e69cc7fd3eaedf1d82711d3938e5fec5841dae1ae1d425d4c211a3b36863099d	2026-10-02 16:57:53.731+05:30	\N
4aecd0fb-c233-4488-aa79-6a826353becc	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-11-01 16:57:54.122+05:30	\N	2026-10-02 16:57:54.124+05:30	11111111-1111-1111-1111-111111111111	64af8901c59452ce15ccd92678aac0a85dc2769a792009b175ed97a54db73a6c	2026-10-02 16:57:54.124+05:30	\N
1c4677b7-634a-4dfe-9594-41361459efd8	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-11-01 16:59:06.901+05:30	\N	2026-10-02 16:59:06.903+05:30	11111111-1111-1111-1111-111111111111	763f328b4fd24b56e1e8402cf8939acf981148bcd3b3861a7190da8048e7256a	2026-10-02 16:59:06.903+05:30	\N
92c21edc-60fd-4e1e-bb37-765664136ae5	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-11-01 16:59:07.057+05:30	\N	2026-10-02 16:59:07.059+05:30	11111111-1111-1111-1111-111111111111	c9d61e78629b8ece75bef0fa5a47a456a2d57e3c8fbb1ed4beb5de36acb45450	2026-10-02 16:59:07.059+05:30	\N
d0c8f432-133e-4019-a24f-e148b0a5ea70	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-11-01 16:59:07.367+05:30	\N	2026-10-02 16:59:07.369+05:30	11111111-1111-1111-1111-111111111111	6f5ebaa01147a9aea911731126c7af2eb7f5a9b91be545172e8ca49ad75a8437	2026-10-02 16:59:07.369+05:30	\N
1c381a49-7075-4edb-b4f6-1b55695b1c60	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-11-01 17:12:15.328+05:30	\N	2026-10-02 17:12:15.329+05:30	11111111-1111-1111-1111-111111111111	bbb3b7aec220ad459e21c69f948b4a9ca2ca1ac4c3f8b52e8db66a16d1c7f0dd	2026-10-02 17:12:15.329+05:30	\N
ee95f251-626b-4a9a-abe1-1efbfd3b62bb	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-11-05 14:34:11.653+05:30	2026-10-06 14:34:27.733+05:30	2026-10-06 14:34:11.655+05:30	11111111-1111-1111-1111-111111111111	a69a6f8f7073acb1e0b3298ae543bf4a62c2a0d402504fd85c4d3025be2f5f58	2026-10-06 14:34:27.734+05:30	\N
da23b628-1627-4b8d-9eeb-9cd112fb4043	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-11-02 01:22:11.81+05:30	\N	2026-10-03 01:22:11.812+05:30	11111111-1111-1111-1111-111111111111	7d08fa28839a875935a55fe4c556a753f66028f6c0777c5fb01f0adf5764baf1	2026-10-03 01:25:48.675+05:30	\N
84c091ca-d1bc-4d8f-a7f0-b3e1a4705b64	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-11-02 04:35:19.31+05:30	\N	2026-10-03 04:35:19.312+05:30	11111111-1111-1111-1111-111111111111	30a3fa5a2cc0f185c89802e64ff82db02bb55dd6808392b43c413aca2853d8b1	2026-10-03 04:35:19.312+05:30	\N
12c49e05-23d3-43ff-9e4c-6f838ff2ca6f	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-11-02 13:56:47.63+05:30	\N	2026-10-03 13:56:47.633+05:30	11111111-1111-1111-1111-111111111111	82420222197cedc280eb41a1c7e933b8ff87f6130a116d55f1d723462a9719c2	2026-10-03 13:56:47.633+05:30	\N
922c6d4b-2040-44c5-841f-061dfa11e138	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-11-05 01:00:06.459+05:30	\N	2026-10-06 01:00:06.461+05:30	11111111-1111-1111-1111-111111111111	2ec6271e3f0f72f9b4d7e4ddb3dd21e47b9a2b648f40f38e2ddd5b2b49eb804f	2026-10-06 01:12:59.862+05:30	\N
e36128bb-84e2-40a4-8bc4-d339dc6ca44f	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-11-05 01:14:41.086+05:30	\N	2026-10-06 01:14:41.088+05:30	67315042-c687-4cbb-b45a-f4ea4efc199f	e77d7be40fb361db96bf974889c10cbf7cb187d5b897f33d28d6f9be4aa9a2ff	2026-10-06 01:14:41.088+05:30	\N
39926cb7-2120-49d3-b1d5-e5ac2aa09f8d	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-11-05 01:16:58.693+05:30	\N	2026-10-06 01:16:58.702+05:30	67315042-c687-4cbb-b45a-f4ea4efc199f	a50cc1e0001138123175d1d96a1b026046993de8787fc366d70dec72b8cdb23f	2026-10-06 01:16:58.702+05:30	\N
08451150-02ec-437e-a1b4-fdfb03cd87f7	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-11-02 15:03:04.317+05:30	\N	2026-10-03 15:03:04.318+05:30	11111111-1111-1111-1111-111111111111	a62bd0520a22536fd0033802f8c870c0590e505e1ab6737baae6e688f2ba97bb	2026-10-03 15:06:19.523+05:30	\N
ad5839bb-6fda-4c85-b6a9-8830ac721c87	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-11-02 13:57:16.208+05:30	\N	2026-10-03 13:57:16.571+05:30	11111111-1111-1111-1111-111111111111	99fefa81b25847ff94514eab66d1438fefcc6e346a1a0b91e5f56139496f2ec2	2026-10-03 13:58:19.149+05:30	\N
3629c7ec-ad97-4381-b95c-d507c289cb9a	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-11-02 14:27:10.781+05:30	\N	2026-10-03 14:27:10.794+05:30	11111111-1111-1111-1111-111111111111	e385b9519275c381a68771f8acb70ae8f179efc46f29ba481196ce2d2ba70d63	2026-10-03 14:27:10.794+05:30	\N
cafdb614-5141-4614-b7c2-a20046f42ada	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-11-02 14:27:53.258+05:30	\N	2026-10-03 14:27:53.27+05:30	11111111-1111-1111-1111-111111111111	2dc26d6eddbe0814dddef4048d636f5327fa5f97cef440443543749283214d55	2026-10-03 14:27:53.27+05:30	\N
e4e4a49b-682e-47d7-9b47-125d160542a7	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-11-02 14:28:27.007+05:30	\N	2026-10-03 14:28:27.017+05:30	11111111-1111-1111-1111-111111111111	3cd75610e65981f97863af246d1309ca0d0a086e238bd7b5206536782a4fe03a	2026-10-03 14:28:27.017+05:30	\N
3b3256e7-bd9c-423c-a900-dbd4da9b03a9	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-11-02 14:29:55.892+05:30	2026-10-03 14:31:52.524+05:30	2026-10-03 14:29:55.894+05:30	11111111-1111-1111-1111-111111111111	7e4c51f1aba4a6c0da10a0bed544b7256e45342d89835c27c39514f8d4e192c1	2026-10-03 14:31:52.526+05:30	\N
64eadaa4-21e8-4c44-800a-4aee61792aed	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-11-05 01:17:08.948+05:30	\N	2026-10-06 01:17:08.957+05:30	11111111-1111-1111-1111-111111111111	40be11ff1e5c60853a88e7ac5f65045e833e818d9a707671199eadaf348f9a11	2026-10-06 01:17:08.957+05:30	\N
03cbb46a-122f-4841-8053-8e6e38825081	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-11-02 14:51:33.186+05:30	\N	2026-10-03 14:51:33.188+05:30	11111111-1111-1111-1111-111111111111	24eedb0a53f783dbe66a44047a666c8d7f0eff21aa1d2e43c7c6878c9958f780	2026-10-03 15:02:52.512+05:30	\N
d72ef4b0-a698-402e-8dc3-6842c6317fba	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-11-02 14:31:59.856+05:30	\N	2026-10-03 14:31:59.857+05:30	11111111-1111-1111-1111-111111111111	dd68d723bf3891b2f878ce935d9019fca576d198e1c27a5245655fbbea179961	2026-10-03 14:32:31.37+05:30	\N
229d4aa0-6ff3-4b0b-a91c-676d988f6166	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-11-02 14:32:45.155+05:30	\N	2026-10-03 14:32:45.157+05:30	11111111-1111-1111-1111-111111111111	f298aee6d4754138e89211d6ec1ceee886db0d651ea5259dc1ab92faa0b7f18d	2026-10-03 14:32:46.143+05:30	\N
3ed19ebd-b4a8-4a6c-bf46-083908b7ad92	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-11-02 14:35:21.413+05:30	\N	2026-10-03 14:35:21.415+05:30	11111111-1111-1111-1111-111111111111	91a57f9748d73d5b76d2cfafd322a1660dc8224093cfe72e2b9341082232400f	2026-10-03 14:35:21.415+05:30	\N
e6bb1320-0288-47b7-8ad1-4a874ed02a6a	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-11-02 14:36:40.31+05:30	\N	2026-10-03 14:36:40.32+05:30	11111111-1111-1111-1111-111111111111	a22612255eef0917889f6f78c1295f8aac18daa90b4d2388b9f6a97c043e017f	2026-10-03 14:36:40.32+05:30	\N
974cb276-6e03-4708-8712-c847fcae32f6	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-11-02 14:37:21.794+05:30	\N	2026-10-03 14:37:21.799+05:30	11111111-1111-1111-1111-111111111111	92f1fa6d0e4083db825e496f82437098ec928d36d4c3a0591c47d87b02183a64	2026-10-03 14:37:21.799+05:30	\N
2c91d914-e33b-4a90-8a3c-42a8b57fd06f	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-11-02 14:38:14.055+05:30	\N	2026-10-03 14:38:14.06+05:30	11111111-1111-1111-1111-111111111111	591a7ca24ce4a8947c98cf359bc1b9ceaa78d61af936e152f8549b7269cd1dfe	2026-10-03 14:38:14.06+05:30	\N
eb99c469-ffb6-4771-9be4-fb2b09d59641	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-11-02 01:14:10.439+05:30	\N	2026-10-03 01:14:10.441+05:30	11111111-1111-1111-1111-111111111111	0957cbe53f0fc7f891f082a9b4744a1c2798c27ba3d7a8860f42c66637dd778f	2026-10-03 01:21:12.958+05:30	\N
d1a77793-65de-47bd-bada-9d20709dcbe1	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-11-05 14:33:46.039+05:30	2026-10-06 14:34:08.609+05:30	2026-10-06 14:33:46.041+05:30	11111111-1111-1111-1111-111111111111	ed0406c46890692e467894e9e52a9fef264787edd42687e294026b46b396f3b6	2026-10-06 14:34:08.61+05:30	\N
e0e9a589-9790-44be-8d3e-a91a04889d75	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-11-02 14:39:09.55+05:30	\N	2026-10-03 14:39:09.561+05:30	11111111-1111-1111-1111-111111111111	5c4f37f38dac9fc1916d383fadf7233083c5869b033b1ec7946df5a84243fa33	2026-10-03 14:50:52.518+05:30	\N
6de9be5a-cd9c-4bfd-92f2-853b3b3462b8	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-11-05 01:17:11.979+05:30	2026-10-06 01:19:03.883+05:30	2026-10-06 01:17:11.987+05:30	11111111-1111-1111-1111-111111111111	1f96a2e9cd3f9d8519766cfea2827f4ef504a3f30567b4a8a48fac9c0bda2e14	2026-10-06 01:19:03.885+05:30	\N
01a031c0-298e-400b-b466-6490cb51cc12	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-11-05 01:19:06.834+05:30	2026-10-06 01:20:10.919+05:30	2026-10-06 01:19:06.836+05:30	11111111-1111-1111-1111-111111111111	426c448f5d4011c3ecc8000a9cf537451f6fcaf944498b48010a4a239ce8634f	2026-10-06 01:20:10.921+05:30	\N
908c61e2-8199-4d1f-96d7-b5e9a0fcee7b	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-11-02 15:10:25.524+05:30	\N	2026-10-03 15:10:25.537+05:30	11111111-1111-1111-1111-111111111111	7b39f48b931e92410958c944df9d55358fb68d5842090e3766bb04616a364623	2026-10-03 15:12:44.123+05:30	\N
12b987d2-beed-460c-a2fb-666e12411058	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-11-02 15:20:04.643+05:30	\N	2026-10-03 15:20:04.645+05:30	11111111-1111-1111-1111-111111111111	0acc9e3a5bba60cbce32d969710241196e1f30751dcba1dda50d64e2bfe66d91	2026-10-03 15:30:00.555+05:30	\N
221be1a1-136e-4196-aaa1-66ce6dbbc8dc	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-11-02 15:43:05.31+05:30	\N	2026-10-03 15:43:05.312+05:30	11111111-1111-1111-1111-111111111111	359c711d833e152fcf335c109052928ed9052b9f9463f54b6077ce13967b21eb	2026-10-03 15:43:06.913+05:30	\N
04fe97a9-d304-4d49-b3c3-3682eefe401a	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-11-05 11:54:39.611+05:30	\N	2026-10-06 11:54:39.612+05:30	11111111-1111-1111-1111-111111111111	500f29b648dead10a64326adc6e0177820c4872f7491efee422a664c52a28cab	2026-10-06 12:09:25.499+05:30	\N
62a967e3-93f4-46f8-91c8-49a7866f9178	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-11-05 13:05:25.78+05:30	\N	2026-10-06 13:05:25.781+05:30	11111111-1111-1111-1111-111111111111	27df0046cdccae433e417f2ff3aed66ec1ee097ae920ef861b21234bf7657e98	2026-10-06 13:05:25.781+05:30	\N
4793fcc3-10ba-4ec1-b44a-15658676b4c0	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-11-05 10:53:00.014+05:30	\N	2026-10-06 10:53:00.017+05:30	11111111-1111-1111-1111-111111111111	0851dbd388bcec1343105f4d40f43713d4cf2d3b8c72170dc0d0f771edc9e6df	2026-10-06 11:07:47.295+05:30	\N
8eb65b73-5efd-45bd-9c53-3d7b25a6302f	918df673-2606-403a-9fad-1c54870d1fce	\N	\N	\N	2026-11-05 11:17:14.962+05:30	\N	2026-10-06 11:17:14.963+05:30	11111111-1111-1111-1111-111111111111	01452222b632761f7509410b5f06ff20c39d6cdf08d1069e8291af9f2be92bac	2026-10-06 11:17:14.963+05:30	\N
099d736b-6577-4803-9167-1a5819ba794e	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-11-05 13:23:16.691+05:30	\N	2026-10-06 13:23:16.693+05:30	11111111-1111-1111-1111-111111111111	343dc7518120ef18e726425a3d182a649e44c14b24d93402cbe794a8a36acf82	2026-10-06 13:23:16.693+05:30	\N
0f8ddcc4-7596-402d-a18c-ba302b396e4e	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N	\N	\N	2026-11-05 01:20:15.566+05:30	\N	2026-10-06 01:20:15.567+05:30	11111111-1111-1111-1111-111111111111	6d4382265f34b62985cb7677637566975590f3ac77fdb69fd0cbe2406dcad120	2026-10-06 01:23:41.329+05:30	\N
44190275-2878-4c16-85ec-66c2fb3ae7cc	ed8a2f35-4fcf-444b-b6d0-e6808c435e06	\N	\N	\N	2026-11-05 14:34:31.288+05:30	2026-10-06 14:34:56.736+05:30	2026-10-06 14:34:31.289+05:30	11111111-1111-1111-1111-111111111111	60c3fa9af2393cf9ee83fdf6750741ae2e00bd1a26f72d76f9b2f9176e090808	2026-10-06 14:34:56.741+05:30	\N
8bc1f655-1c97-443c-b7e0-a565b09c8ca6	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	\N	\N	2026-11-05 14:34:59.782+05:30	\N	2026-10-06 14:34:59.786+05:30	11111111-1111-1111-1111-111111111111	c10c9708f616695ca21adb833468cb2d28a788b667a413de4bbafdb4ef23b626	2026-10-06 14:34:59.786+05:30	\N
\.


--
-- Data for Name: special_notes; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.special_notes (id, outlet_id, text, sort_order, is_active, created_at, updated_at) FROM stdin;
e187612c-dbc1-4e6c-acd0-76b1d9c5ba05	67315042-c687-4cbb-b45a-f4ea4efc199f	Less Masala	1	t	2026-09-03 12:29:17.304401+05:30	2026-09-03 12:29:17.304401+05:30
0117eea4-5f74-46a8-aee0-5616a64cb28a	67315042-c687-4cbb-b45a-f4ea4efc199f	Extra Spicy	2	t	2026-09-03 12:29:17.306933+05:30	2026-09-03 12:29:17.306933+05:30
d88e06d7-1419-4a47-a512-3ca62bf1ce13	67315042-c687-4cbb-b45a-f4ea4efc199f	Jain Style (No Onion/Garlic)	3	t	2026-09-03 12:29:17.308276+05:30	2026-09-03 12:29:17.308276+05:30
fbdb7cf0-4895-4549-ab4f-abcd6ac7a3b3	67315042-c687-4cbb-b45a-f4ea4efc199f	Less Oil / Diet	4	t	2026-09-03 12:29:17.309581+05:30	2026-09-03 12:29:17.309581+05:30
8a347a1b-5078-43de-8dba-9b96ca5d5963	67315042-c687-4cbb-b45a-f4ea4efc199f	Crispy / Well Done	5	t	2026-09-03 12:29:17.310958+05:30	2026-09-03 12:29:17.310958+05:30
b9db6f93-646f-482e-b837-38a53b02de24	67315042-c687-4cbb-b45a-f4ea4efc199f	No Sugar	6	t	2026-09-03 12:29:17.312257+05:30	2026-09-03 12:29:17.312257+05:30
644356a6-ace0-40ed-b7e1-a67a65f0c3c3	67315042-c687-4cbb-b45a-f4ea4efc199f	Quick / VIP Priority	7	t	2026-09-03 12:29:17.313508+05:30	2026-09-03 12:29:17.313508+05:30
\.


--
-- Data for Name: stations; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.stations (id, outlet_id, name, printer_ip, created_at, updated_at, created_by, updated_by, sla_warning_seconds, sla_breach_seconds) FROM stdin;
eebe76a3-8305-409d-877b-bb5a0e2b7328	67315042-c687-4cbb-b45a-f4ea4efc199f	GRILL	192.168.1.101	2026-09-02 14:45:15.256+05:30	2026-09-02 16:21:33.157+05:30	\N	\N	600	900
42dcfe23-879e-4b2a-be32-34ac8217c08a	67315042-c687-4cbb-b45a-f4ea4efc199f	FRYER	192.168.1.102	2026-09-02 14:45:15.265+05:30	2026-09-02 16:21:33.162+05:30	\N	\N	600	900
c0e956a7-c8ed-448a-95b1-a7bfaf01ff64	67315042-c687-4cbb-b45a-f4ea4efc199f	PANTRY	192.168.1.103	2026-09-02 14:45:15.271+05:30	2026-09-02 16:21:33.167+05:30	\N	\N	600	900
764d2958-6b03-43c0-b066-586fb8efb9f5	67315042-c687-4cbb-b45a-f4ea4efc199f	BAR	192.168.1.104	2026-09-02 14:45:15.276+05:30	2026-09-02 16:21:33.172+05:30	\N	\N	600	900
b683fe60-8afe-43d8-8dca-9e47bcd8f771	2a543c3c-066f-4097-833a-df7c25700580	KITCHEN	192.168.1.101	2026-09-02 16:33:25.787+05:30	2026-09-02 16:33:25.787+05:30	\N	\N	600	900
ace502a5-a767-442e-856d-9eefe5cdc905	2a543c3c-066f-4097-833a-df7c25700580	BAR	192.168.1.102	2026-09-02 16:33:25.793+05:30	2026-09-02 16:33:25.793+05:30	\N	\N	600	900
abdc7979-a559-4c93-baa9-3306ab6cae04	2a543c3c-066f-4097-833a-df7c25700580	DOSA_SECTION	192.168.1.103	2026-09-02 16:33:25.797+05:30	2026-09-02 16:33:25.797+05:30	\N	\N	600	900
\.


--
-- Data for Name: sync_jobs; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.sync_jobs (id, outlet_id, channel_account_id, entity, entity_id, version, status, created_at, updated_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: sync_state; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.sync_state (id, outlet_id, device_id, device_role, last_synced_at, last_sync_cursor, is_online, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: table_merge_groups; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.table_merge_groups (id, outlet_id, primary_table_id, status, total_capacity, covers, opened_at, closed_at, created_by, reason) FROM stdin;
afe6e795-9bf1-4d7b-93ba-24db0c8ad017	11111111-1111-1111-1111-111111111111	1bb0a59d-079d-4406-8bd9-0fd2f4a7668e	ACTIVE	8	\N	2026-09-05 16:53:25.402+05:30	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N
3cd09765-0c46-48de-b774-f426b5f9da3d	11111111-1111-1111-1111-111111111111	fc8127fc-a614-4ba2-ae4e-bc2fb91b2d3d	ACTIVE	8	\N	2026-09-23 13:20:56.795+05:30	\N	9b35fd7a-2717-4837-ad91-9328aee9ec5f	\N
\.


--
-- Data for Name: table_merge_members; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.table_merge_members (id, outlet_id, merge_group_id, dining_table_id, is_primary, joined_at, left_at) FROM stdin;
6c0711c8-c5a9-4e8e-b7e6-02cbeec9ac92	11111111-1111-1111-1111-111111111111	afe6e795-9bf1-4d7b-93ba-24db0c8ad017	bb01f08e-7a9d-43b3-acce-be35218b3f27	f	2026-09-05 16:53:25.462+05:30	\N
92f144e9-b608-4d7d-832e-6cd21d76ba43	11111111-1111-1111-1111-111111111111	afe6e795-9bf1-4d7b-93ba-24db0c8ad017	1bb0a59d-079d-4406-8bd9-0fd2f4a7668e	t	2026-09-05 16:53:25.511+05:30	\N
c9897864-b7f4-48ff-a707-7978d8aff0f3	11111111-1111-1111-1111-111111111111	3cd09765-0c46-48de-b774-f426b5f9da3d	fc8127fc-a614-4ba2-ae4e-bc2fb91b2d3d	t	2026-09-23 13:20:56.839+05:30	\N
0ae04ecb-8dd8-494a-8536-a4d380e68093	11111111-1111-1111-1111-111111111111	3cd09765-0c46-48de-b774-f426b5f9da3d	7f7e342f-0f6c-456c-9ec5-055de3ab87fe	f	2026-09-23 13:20:56.847+05:30	\N
\.


--
-- Data for Name: table_operation_idempotency; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.table_operation_idempotency (id, outlet_id, idempotency_key, endpoint, response_json, created_at) FROM stdin;
\.


--
-- Data for Name: table_seats; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.table_seats (id, outlet_id, dining_table_id, seat_number, label, status, guest_name) FROM stdin;
\.


--
-- Data for Name: table_sessions; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.table_sessions (id, outlet_id, table_id, order_id, status, kot_sent, covers, opened_at, closed_at, opened_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: tax_channel_rules; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.tax_channel_rules (id, outlet_id, tax_id, channel, mode, is_active, created_at, updated_at) FROM stdin;
949bd3e0-6bb2-458a-b815-4784726e9264	67315042-c687-4cbb-b45a-f4ea4efc199f	a7580b0e-4ecd-49da-a1c2-9681c9e54ab0	dine_in	backward	t	2026-09-03 12:29:17.349423+05:30	2026-09-03 12:29:17.349423+05:30
1b50671c-db6f-4c01-a060-3c5524ed676f	67315042-c687-4cbb-b45a-f4ea4efc199f	90067bbf-bfc8-4acb-beeb-c77a6bd641dd	dine_in	backward	t	2026-09-03 12:29:17.352824+05:30	2026-09-03 12:29:17.352824+05:30
d4af1b9e-c1f7-4136-a210-990d7e89c880	67315042-c687-4cbb-b45a-f4ea4efc199f	0df998c6-f54a-4765-b358-3242e31058eb	online	forward	t	2026-09-03 12:29:17.354605+05:30	2026-09-03 12:29:17.354605+05:30
624febe1-d253-416b-a2e2-3a79371297ea	67315042-c687-4cbb-b45a-f4ea4efc199f	fdd8e337-00f4-408f-8cc7-e5eac5b8ac37	online	forward	t	2026-09-03 12:29:17.356514+05:30	2026-09-03 12:29:17.356514+05:30
\.


--
-- Data for Name: taxes; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.taxes (id, outlet_id, name, rate_percent, is_active, created_at, updated_at) FROM stdin;
a7580b0e-4ecd-49da-a1c2-9681c9e54ab0	67315042-c687-4cbb-b45a-f4ea4efc199f	CGST	2.500	t	2026-09-03 12:29:17.315224+05:30	2026-09-03 12:29:17.315224+05:30
90067bbf-bfc8-4acb-beeb-c77a6bd641dd	67315042-c687-4cbb-b45a-f4ea4efc199f	SGST	2.500	t	2026-09-03 12:29:17.326605+05:30	2026-09-03 12:29:17.326605+05:30
0df998c6-f54a-4765-b358-3242e31058eb	67315042-c687-4cbb-b45a-f4ea4efc199f	CGST [Online]	2.500	t	2026-09-03 12:29:17.327756+05:30	2026-09-03 12:29:17.327756+05:30
fdd8e337-00f4-408f-8cc7-e5eac5b8ac37	67315042-c687-4cbb-b45a-f4ea4efc199f	SGST [Online]	2.500	t	2026-09-03 12:29:17.32927+05:30	2026-09-03 12:29:17.32927+05:30
\.


--
-- Data for Name: terminals; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.terminals (id, outlet_id, terminal_number, name, is_active, created_by, updated_by, created_at, updated_at) FROM stdin;
6c4c8546-d1f3-461a-ad4b-3928d6be8ba9	67315042-c687-4cbb-b45a-f4ea4efc199f	T-01	Main Cashier Counter T-01	t	\N	\N	2026-09-02 14:45:15.197+05:30	2026-09-02 16:21:33.122+05:30
fd2ff197-9813-4af4-9b66-9642316df599	67315042-c687-4cbb-b45a-f4ea4efc199f	T-02	Express Bar Terminal T-02	t	\N	\N	2026-09-02 14:45:15.206+05:30	2026-09-02 16:21:33.125+05:30
388498f3-d8e6-4d16-9b4a-fa0a79e9692f	2a543c3c-066f-4097-833a-df7c25700580	T-01	Master POS Terminal T-01	t	\N	\N	2026-09-02 16:33:25.655+05:30	2026-09-02 16:33:25.655+05:30
5ec4f6d9-7fa6-42a9-a2a3-ec6c42fe0de4	2a543c3c-066f-4097-833a-df7c25700580	cp4	Captain Mobile Station cp4	t	\N	\N	2026-09-02 16:33:25.664+05:30	2026-09-02 16:33:25.664+05:30
\.


--
-- Data for Name: user_quick_links; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.user_quick_links (id, user_id, label, href, sort_order, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: user_report_preferences; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.user_report_preferences (id, user_id, report_key, column_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.user_roles (user_id, role_id, outlet_id, granted_at, granted_by, created_at, created_by) FROM stdin;
02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	11111111-1111-1111-1111-111111111101	\N	2026-09-02 14:45:15.60678+05:30	\N	2026-09-02 14:45:15.606+05:30	\N
ed8a2f35-4fcf-444b-b6d0-e6808c435e06	11111111-1111-1111-1111-111111111104	\N	2026-09-02 14:45:15.835884+05:30	\N	2026-09-02 14:45:15.835+05:30	\N
918df673-2606-403a-9fad-1c54870d1fce	11111111-1111-1111-1111-111111111105	\N	2026-09-02 14:45:16.06048+05:30	\N	2026-09-02 14:45:16.06+05:30	\N
00a94815-6158-4c07-9bcd-4b540aa79b1b	11111111-1111-1111-1111-111111111103	\N	2026-09-03 12:05:43.146453+05:30	\N	2026-09-03 12:05:43.146453+05:30	\N
9b35fd7a-2717-4837-ad91-9328aee9ec5f	11111111-1111-1111-1111-111111111106	\N	2026-09-03 12:05:43.154773+05:30	\N	2026-09-03 12:05:43.154773+05:30	\N
8b31cbda-6588-420f-8283-6f137a1b6e49	11111111-1111-1111-1111-111111111107	\N	2026-09-03 12:05:43.157903+05:30	\N	2026-09-03 12:05:43.157903+05:30	\N
2d214592-ed35-4e7a-ad34-fca203227853	11111111-1111-1111-1111-111111111108	\N	2026-09-03 12:05:43.162537+05:30	\N	2026-09-03 12:05:43.162537+05:30	\N
aa61bb1d-e70f-4e28-9830-42b7a3511212	11111111-1111-1111-1111-111111111109	\N	2026-09-03 12:05:43.165845+05:30	\N	2026-09-03 12:05:43.165845+05:30	\N
cf8faac6-732e-4a32-a5bd-03919f06ed5f	11111111-1111-1111-1111-111111111106	2a543c3c-066f-4097-833a-df7c25700580	2026-09-08 14:08:12.871986+05:30	\N	2026-09-08 14:08:12.871986+05:30	\N
5e635b7d-856a-40b8-8a8c-1398f74eca30	11111111-1111-1111-1111-111111111106	\N	2026-09-11 12:00:20.652583+05:30	\N	2026-09-11 12:00:20.652583+05:30	\N
72bad3bb-6097-47d2-bfc2-35b1244a7b9f	11111111-1111-1111-1111-111111111106	\N	2026-09-11 12:00:20.661925+05:30	\N	2026-09-11 12:00:20.661925+05:30	\N
5c660c1f-f5f8-4007-87a6-b4b39913998b	11111111-1111-1111-1111-111111111106	\N	2026-09-11 12:00:20.668673+05:30	\N	2026-09-11 12:00:20.668673+05:30	\N
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.users (id, email, phone, full_name, password_hash, mfa_enabled, is_active, created_at, updated_at, created_by, updated_by, first_name, last_name, pin_hash) FROM stdin;
aa61bb1d-e70f-4e28-9830-42b7a3511212	accountant@hotelkapila.com	\N		$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.	f	t	2026-09-03 12:05:43.164336+05:30	2026-09-03 12:05:43.164336+05:30	\N	\N	Suresh	Iyer	$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.
cf8faac6-732e-4a32-a5bd-03919f06ed5f	test@hotelkapila.com	\N		$2a$10$bLmkjzBUaxPcCyvby29z0uhpM502QOEifyY8RSe15vQHsmRWeqnAu	f	t	2026-09-08 14:08:12.874+05:30	2026-09-08 14:08:12.874+05:30	02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	\N	test	d	\N
5e635b7d-856a-40b8-8a8c-1398f74eca30	ramesh@hotelkapila.com	+91 9876543201		$2a$10$ZDLxmN70Y9iGFQzws6.7Keih1MrVQnVFafIVtAUw4B/fpoAplqnTO	f	t	2026-09-11 12:00:20.63+05:30	2026-09-11 12:00:20.63+05:30	\N	\N	Ramesh	Kumar	$2a$10$ZDLxmN70Y9iGFQzws6.7Kei/bmfLk0Hrq0Ue5UuyEZPhE47kdUGzS
72bad3bb-6097-47d2-bfc2-35b1244a7b9f	suresh@hotelkapila.com	+91 9876543202		$2a$10$ZDLxmN70Y9iGFQzws6.7Keih1MrVQnVFafIVtAUw4B/fpoAplqnTO	f	t	2026-09-11 12:00:20.658+05:30	2026-09-11 12:00:20.658+05:30	\N	\N	Suresh	Patel	$2a$10$ZDLxmN70Y9iGFQzws6.7Kei/bmfLk0Hrq0Ue5UuyEZPhE47kdUGzS
5c660c1f-f5f8-4007-87a6-b4b39913998b	mahesh@hotelkapila.com	+91 9876543203		$2a$10$ZDLxmN70Y9iGFQzws6.7Keih1MrVQnVFafIVtAUw4B/fpoAplqnTO	f	t	2026-09-11 12:00:20.664+05:30	2026-09-11 12:00:20.664+05:30	\N	\N	Mahesh	Verma	$2a$10$ZDLxmN70Y9iGFQzws6.7Kei/bmfLk0Hrq0Ue5UuyEZPhE47kdUGzS
02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc	admin@hotelkapila.com	\N		$2a$10$PLdpSKvm2v9Os/H1QCW.OuvFOz8DsVVeAz7Ep62oj2ZKXL6KjWM9C	f	t	2026-09-02 14:45:15.536+05:30	2026-09-02 16:21:33.411+05:30	\N	\N	Abdul	Mannan	$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.
00a94815-6158-4c07-9bcd-4b540aa79b1b	manager@hotelkapila.com	\N		$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.	f	t	2026-09-03 12:05:43.144931+05:30	2026-09-03 12:05:43.144931+05:30	\N	\N	Rajesh	Sharma	$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.
ed8a2f35-4fcf-444b-b6d0-e6808c435e06	cashier@hotelkapila.com	\N		$2a$10$PLdpSKvm2v9Os/H1QCW.OuvFOz8DsVVeAz7Ep62oj2ZKXL6KjWM9C	f	t	2026-09-02 14:45:15.832+05:30	2026-09-02 16:21:33.641+05:30	\N	\N	Kapila	Cashier	$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.
918df673-2606-403a-9fad-1c54870d1fce	chef@hotelkapila.com	\N		$2a$10$PLdpSKvm2v9Os/H1QCW.OuvFOz8DsVVeAz7Ep62oj2ZKXL6KjWM9C	f	t	2026-09-02 14:45:16.057+05:30	2026-09-02 16:21:33.861+05:30	\N	\N	Head	Chef	$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.
9b35fd7a-2717-4837-ad91-9328aee9ec5f	waiter@hotelkapila.com	\N		$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.	f	t	2026-09-03 12:05:43.153518+05:30	2026-09-03 12:05:43.153518+05:30	\N	\N	Rahul	Kumar	$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.
8b31cbda-6588-420f-8283-6f137a1b6e49	delivery@hotelkapila.com	\N		$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.	f	t	2026-09-03 12:05:43.15632+05:30	2026-09-03 12:05:43.15632+05:30	\N	\N	Amit	Verma	$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.
2d214592-ed35-4e7a-ad34-fca203227853	inventory@hotelkapila.com	\N		$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.	f	t	2026-09-03 12:05:43.16032+05:30	2026-09-03 12:05:43.16032+05:30	\N	\N	Vikram	Patel	$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.
\.


--
-- Data for Name: vendors; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.vendors (id, outlet_id, name, contact_name, contact_phone, contact_email, payment_terms, is_active, created_at, updated_at, created_by, updated_by, phone, email, tax_number, contact_person, address) FROM stdin;
c65516bd-e4e1-42ad-9c31-165b0510d1f8	67315042-c687-4cbb-b45a-f4ea4efc199f	Metro Cash & Carry	\N	\N	\N	\N	t	2026-09-02 16:30:20.959+05:30	2026-09-02 16:30:20.959+05:30	\N	\N	9876543210	sales@metro.co.in	29AAECM1234N1Z5	\N	\N
\.


--
-- Data for Name: waiter_shift_handovers; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.waiter_shift_handovers (id, outlet_id, waiter_id, waiter_name, business_date, actual_cash_counted_minor, opening_float_minor, net_tip_payout_minor, digital_tips_minor, service_charge_minor, cash_sales_minor, manager_notes, created_at) FROM stdin;
52c305c8-f7dc-45b0-9f2f-5b8502512825	11111111-1111-1111-1111-111111111111	9b35fd7a-2717-4837-ad91-9328aee9ec5f	Rahul Kumar	2026-10-04	0	50000	0	0	0	0	Captain Shift Handover: Rahul Kumar. Net tip payout: ₹0.00, Denominations: 500x0, 200x0, 100x0, 50x0, 20x0, 10x0, 5x0, Coins: ₹0	2026-10-06 01:23:39.184+05:30
\.


--
-- Name: backup_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.backup_jobs_id_seq', 1, false);


--
-- Name: channel_sync_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.channel_sync_log_id_seq', 1, false);


--
-- Name: order_audit_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.order_audit_log_id_seq', 1, false);


--
-- Name: access_logs access_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.access_logs
    ADD CONSTRAINT access_logs_pkey PRIMARY KEY (id, created_at);


--
-- Name: access_logs_default access_logs_default_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.access_logs_default
    ADD CONSTRAINT access_logs_default_pkey PRIMARY KEY (id, created_at);


--
-- Name: access_logs_y2026m08 access_logs_y2026m08_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.access_logs_y2026m08
    ADD CONSTRAINT access_logs_y2026m08_pkey PRIMARY KEY (id, created_at);


--
-- Name: addon_commissions addon_commissions_outlet_id_addon_item_id_key; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.addon_commissions
    ADD CONSTRAINT addon_commissions_outlet_id_addon_item_id_key UNIQUE (outlet_id, addon_item_id);


--
-- Name: addon_commissions addon_commissions_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.addon_commissions
    ADD CONSTRAINT addon_commissions_pkey PRIMARY KEY (id);


--
-- Name: agent_telemetry agent_telemetry_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.agent_telemetry
    ADD CONSTRAINT agent_telemetry_pkey PRIMARY KEY (id);


--
-- Name: areas areas_outlet_id_name_key; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.areas
    ADD CONSTRAINT areas_outlet_id_name_key UNIQUE (outlet_id, name);


--
-- Name: areas areas_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.areas
    ADD CONSTRAINT areas_pkey PRIMARY KEY (id);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id, created_at);


--
-- Name: audit_logs_default audit_logs_default_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.audit_logs_default
    ADD CONSTRAINT audit_logs_default_pkey PRIMARY KEY (id, created_at);


--
-- Name: audit_logs_y2026m08 audit_logs_y2026m08_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.audit_logs_y2026m08
    ADD CONSTRAINT audit_logs_y2026m08_pkey PRIMARY KEY (id, created_at);


--
-- Name: availability_schedules availability_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.availability_schedules
    ADD CONSTRAINT availability_schedules_pkey PRIMARY KEY (id);


--
-- Name: backup_jobs backup_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.backup_jobs
    ADD CONSTRAINT backup_jobs_pkey PRIMARY KEY (id);


--
-- Name: campaign_recipients campaign_recipients_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.campaign_recipients
    ADD CONSTRAINT campaign_recipients_pkey PRIMARY KEY (id);


--
-- Name: cash_drawer_sessions cash_drawer_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.cash_drawer_sessions
    ADD CONSTRAINT cash_drawer_sessions_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: channel_accounts channel_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.channel_accounts
    ADD CONSTRAINT channel_accounts_pkey PRIMARY KEY (id);


--
-- Name: channel_item_mapping channel_item_mapping_channel_account_id_external_item_id_key; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.channel_item_mapping
    ADD CONSTRAINT channel_item_mapping_channel_account_id_external_item_id_key UNIQUE (channel_account_id, external_item_id);


--
-- Name: channel_item_mapping channel_item_mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.channel_item_mapping
    ADD CONSTRAINT channel_item_mapping_pkey PRIMARY KEY (id);


--
-- Name: channel_sync_log channel_sync_log_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.channel_sync_log
    ADD CONSTRAINT channel_sync_log_pkey PRIMARY KEY (id);


--
-- Name: configuration_changes configuration_changes_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.configuration_changes
    ADD CONSTRAINT configuration_changes_pkey PRIMARY KEY (id, created_at);


--
-- Name: configuration_changes_default configuration_changes_default_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.configuration_changes_default
    ADD CONSTRAINT configuration_changes_default_pkey PRIMARY KEY (id, created_at);


--
-- Name: configuration_changes_y2026m08 configuration_changes_y2026m08_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.configuration_changes_y2026m08
    ADD CONSTRAINT configuration_changes_y2026m08_pkey PRIMARY KEY (id, created_at);


--
-- Name: customer_addresses customer_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.customer_addresses
    ADD CONSTRAINT customer_addresses_pkey PRIMARY KEY (id);


--
-- Name: customer_tags customer_tags_customer_id_tag_key; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.customer_tags
    ADD CONSTRAINT customer_tags_customer_id_tag_key UNIQUE (customer_id, tag);


--
-- Name: customer_tags customer_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.customer_tags
    ADD CONSTRAINT customer_tags_pkey PRIMARY KEY (id);


--
-- Name: customers customers_organization_id_phone_key; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_organization_id_phone_key UNIQUE (organization_id, phone);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: daily_sales_summary daily_sales_summary_outlet_id_business_date_key; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.daily_sales_summary
    ADD CONSTRAINT daily_sales_summary_outlet_id_business_date_key UNIQUE (outlet_id, business_date);


--
-- Name: daily_sales_summary daily_sales_summary_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.daily_sales_summary
    ADD CONSTRAINT daily_sales_summary_pkey PRIMARY KEY (id);


--
-- Name: dining_tables dining_tables_outlet_id_table_number_key; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.dining_tables
    ADD CONSTRAINT dining_tables_outlet_id_table_number_key UNIQUE (outlet_id, table_number);


--
-- Name: dining_tables dining_tables_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.dining_tables
    ADD CONSTRAINT dining_tables_pkey PRIMARY KEY (id);


--
-- Name: hourly_sales_summary hourly_sales_summary_outlet_id_business_date_hour_key; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.hourly_sales_summary
    ADD CONSTRAINT hourly_sales_summary_outlet_id_business_date_hour_key UNIQUE (outlet_id, business_date, hour);


--
-- Name: hourly_sales_summary hourly_sales_summary_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.hourly_sales_summary
    ADD CONSTRAINT hourly_sales_summary_pkey PRIMARY KEY (id);


--
-- Name: inbound_events inbound_events_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.inbound_events
    ADD CONSTRAINT inbound_events_pkey PRIMARY KEY (id);


--
-- Name: ingredients ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.ingredients
    ADD CONSTRAINT ingredients_pkey PRIMARY KEY (id);


--
-- Name: integration_errors integration_errors_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.integration_errors
    ADD CONSTRAINT integration_errors_pkey PRIMARY KEY (id);


--
-- Name: integrations integrations_code_key; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.integrations
    ADD CONSTRAINT integrations_code_key UNIQUE (code);


--
-- Name: integrations integrations_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.integrations
    ADD CONSTRAINT integrations_pkey PRIMARY KEY (id);


--
-- Name: inventory_consumption_log inventory_consumption_log_order_item_id_ingredient_id_recip_key; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.inventory_consumption_log
    ADD CONSTRAINT inventory_consumption_log_order_item_id_ingredient_id_recip_key UNIQUE (order_item_id, ingredient_id, recipe_id);


--
-- Name: inventory_consumption_log inventory_consumption_log_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.inventory_consumption_log
    ADD CONSTRAINT inventory_consumption_log_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_outlet_id_invoice_number_key; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_outlet_id_invoice_number_key UNIQUE (outlet_id, invoice_number);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: item_availabilities item_availabilities_outlet_id_menu_item_id_key; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.item_availabilities
    ADD CONSTRAINT item_availabilities_outlet_id_menu_item_id_key UNIQUE (outlet_id, menu_item_id);


--
-- Name: item_availabilities item_availabilities_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.item_availabilities
    ADD CONSTRAINT item_availabilities_pkey PRIMARY KEY (id);


--
-- Name: item_availability item_availability_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.item_availability
    ADD CONSTRAINT item_availability_pkey PRIMARY KEY (id);


--
-- Name: item_commissions item_commissions_outlet_id_menu_item_id_key; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.item_commissions
    ADD CONSTRAINT item_commissions_outlet_id_menu_item_id_key UNIQUE (outlet_id, menu_item_id);


--
-- Name: item_commissions item_commissions_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.item_commissions
    ADD CONSTRAINT item_commissions_pkey PRIMARY KEY (id);


--
-- Name: item_modifier_groups item_modifier_groups_item_id_group_id_key; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.item_modifier_groups
    ADD CONSTRAINT item_modifier_groups_item_id_group_id_key UNIQUE (item_id, group_id);


--
-- Name: item_modifier_groups item_modifier_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.item_modifier_groups
    ADD CONSTRAINT item_modifier_groups_pkey PRIMARY KEY (id);


--
-- Name: item_prices item_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.item_prices
    ADD CONSTRAINT item_prices_pkey PRIMARY KEY (id);


--
-- Name: item_sales_summary item_sales_summary_outlet_id_business_date_item_id_key; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.item_sales_summary
    ADD CONSTRAINT item_sales_summary_outlet_id_business_date_item_id_key UNIQUE (outlet_id, business_date, item_id);


--
-- Name: item_sales_summary item_sales_summary_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.item_sales_summary
    ADD CONSTRAINT item_sales_summary_pkey PRIMARY KEY (id);


--
-- Name: item_variants item_variants_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.item_variants
    ADD CONSTRAINT item_variants_pkey PRIMARY KEY (id);


--
-- Name: kot_items kot_items_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.kot_items
    ADD CONSTRAINT kot_items_pkey PRIMARY KEY (id);


--
-- Name: kot_performance kot_performance_outlet_id_business_date_station_id_key; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.kot_performance
    ADD CONSTRAINT kot_performance_outlet_id_business_date_station_id_key UNIQUE (outlet_id, business_date, station_id);


--
-- Name: kot_performance kot_performance_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.kot_performance
    ADD CONSTRAINT kot_performance_pkey PRIMARY KEY (id);


--
-- Name: kot_status_history kot_status_history_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.kot_status_history
    ADD CONSTRAINT kot_status_history_pkey PRIMARY KEY (id);


--
-- Name: kot_tickets kot_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.kot_tickets
    ADD CONSTRAINT kot_tickets_pkey PRIMARY KEY (id);


--
-- Name: ledger_entries ledger_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.ledger_entries
    ADD CONSTRAINT ledger_entries_pkey PRIMARY KEY (id);


--
-- Name: loyalty_accounts loyalty_accounts_customer_id_key; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.loyalty_accounts
    ADD CONSTRAINT loyalty_accounts_customer_id_key UNIQUE (customer_id);


--
-- Name: loyalty_accounts loyalty_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.loyalty_accounts
    ADD CONSTRAINT loyalty_accounts_pkey PRIMARY KEY (id);


--
-- Name: marketing_campaigns marketing_campaigns_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.marketing_campaigns
    ADD CONSTRAINT marketing_campaigns_pkey PRIMARY KEY (id);


--
-- Name: menu_categories menu_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.menu_categories
    ADD CONSTRAINT menu_categories_pkey PRIMARY KEY (id);


--
-- Name: menu_item_availability menu_item_availability_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.menu_item_availability
    ADD CONSTRAINT menu_item_availability_pkey PRIMARY KEY (id);


--
-- Name: menu_item_channel_status menu_item_channel_status_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.menu_item_channel_status
    ADD CONSTRAINT menu_item_channel_status_pkey PRIMARY KEY (id);


--
-- Name: menu_items menu_items_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT menu_items_pkey PRIMARY KEY (id);


--
-- Name: modifier_groups modifier_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.modifier_groups
    ADD CONSTRAINT modifier_groups_pkey PRIMARY KEY (id);


--
-- Name: modifier_options modifier_options_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.modifier_options
    ADD CONSTRAINT modifier_options_pkey PRIMARY KEY (id);


--
-- Name: modifiers modifiers_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.modifiers
    ADD CONSTRAINT modifiers_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: order_audit_log order_audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_audit_log
    ADD CONSTRAINT order_audit_log_pkey PRIMARY KEY (id);


--
-- Name: order_item_modifiers order_item_modifiers_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_item_modifiers
    ADD CONSTRAINT order_item_modifiers_pkey PRIMARY KEY (id);


--
-- Name: order_item_seat_shares order_item_seat_shares_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_item_seat_shares
    ADD CONSTRAINT order_item_seat_shares_pkey PRIMARY KEY (id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: order_payments order_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_payments
    ADD CONSTRAINT order_payments_pkey PRIMARY KEY (id);


--
-- Name: order_refunds order_refunds_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_refunds
    ADD CONSTRAINT order_refunds_pkey PRIMARY KEY (id);


--
-- Name: order_seat_bills order_seat_bills_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_seat_bills
    ADD CONSTRAINT order_seat_bills_pkey PRIMARY KEY (id);


--
-- Name: order_status_history order_status_history_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_status_history
    ADD CONSTRAINT order_status_history_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: outbound_events outbound_events_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.outbound_events
    ADD CONSTRAINT outbound_events_pkey PRIMARY KEY (id);


--
-- Name: outbox_events outbox_events_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.outbox_events
    ADD CONSTRAINT outbox_events_pkey PRIMARY KEY (id);


--
-- Name: outlet_billing_settings outlet_billing_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.outlet_billing_settings
    ADD CONSTRAINT outlet_billing_settings_pkey PRIMARY KEY (id);


--
-- Name: outlet_print_settings outlet_print_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.outlet_print_settings
    ADD CONSTRAINT outlet_print_settings_pkey PRIMARY KEY (id);


--
-- Name: outlet_status outlet_status_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.outlet_status
    ADD CONSTRAINT outlet_status_pkey PRIMARY KEY (outlet_id);


--
-- Name: outlets outlets_organization_id_code_key; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.outlets
    ADD CONSTRAINT outlets_organization_id_code_key UNIQUE (organization_id, code);


--
-- Name: outlets outlets_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.outlets
    ADD CONSTRAINT outlets_pkey PRIMARY KEY (id);


--
-- Name: payment_summary payment_summary_outlet_id_business_date_method_key; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.payment_summary
    ADD CONSTRAINT payment_summary_outlet_id_business_date_method_key UNIQUE (outlet_id, business_date, method);


--
-- Name: payment_summary payment_summary_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.payment_summary
    ADD CONSTRAINT payment_summary_pkey PRIMARY KEY (id);


--
-- Name: payment_type_master payment_type_master_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.payment_type_master
    ADD CONSTRAINT payment_type_master_pkey PRIMARY KEY (id);


--
-- Name: payments payments_idempotency_key_unique; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_idempotency_key_unique UNIQUE (idempotency_key);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_code_key; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_code_key UNIQUE (code);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: petty_cash_ledger petty_cash_ledger_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.petty_cash_ledger
    ADD CONSTRAINT petty_cash_ledger_pkey PRIMARY KEY (id);


--
-- Name: physical_menu_files physical_menu_files_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.physical_menu_files
    ADD CONSTRAINT physical_menu_files_pkey PRIMARY KEY (id);


--
-- Name: user_roles pk_user_roles; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT pk_user_roles PRIMARY KEY (user_id, role_id);


--
-- Name: price_lists price_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.price_lists
    ADD CONSTRAINT price_lists_pkey PRIMARY KEY (id);


--
-- Name: purchase_order_items purchase_order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT purchase_order_items_pkey PRIMARY KEY (id);


--
-- Name: purchase_orders purchase_orders_outlet_id_po_number_key; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_outlet_id_po_number_key UNIQUE (outlet_id, po_number);


--
-- Name: purchase_orders purchase_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_pkey PRIMARY KEY (id);


--
-- Name: recipe_ingredients recipe_ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.recipe_ingredients
    ADD CONSTRAINT recipe_ingredients_pkey PRIMARY KEY (id);


--
-- Name: recipes recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_pkey PRIMARY KEY (id);


--
-- Name: restaurant_tables restaurant_tables_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.restaurant_tables
    ADD CONSTRAINT restaurant_tables_pkey PRIMARY KEY (id);


--
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (role_id, permission_id);


--
-- Name: roles roles_code_key; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_code_key UNIQUE (code);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: sales_returns sales_returns_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.sales_returns
    ADD CONSTRAINT sales_returns_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: special_notes special_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.special_notes
    ADD CONSTRAINT special_notes_pkey PRIMARY KEY (id);


--
-- Name: stations stations_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_pkey PRIMARY KEY (id);


--
-- Name: sync_jobs sync_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.sync_jobs
    ADD CONSTRAINT sync_jobs_pkey PRIMARY KEY (id);


--
-- Name: sync_state sync_state_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.sync_state
    ADD CONSTRAINT sync_state_pkey PRIMARY KEY (id);


--
-- Name: table_merge_groups table_merge_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.table_merge_groups
    ADD CONSTRAINT table_merge_groups_pkey PRIMARY KEY (id);


--
-- Name: table_merge_members table_merge_members_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.table_merge_members
    ADD CONSTRAINT table_merge_members_pkey PRIMARY KEY (id);


--
-- Name: table_operation_idempotency table_operation_idempotency_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.table_operation_idempotency
    ADD CONSTRAINT table_operation_idempotency_pkey PRIMARY KEY (id);


--
-- Name: table_seats table_seats_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.table_seats
    ADD CONSTRAINT table_seats_pkey PRIMARY KEY (id);


--
-- Name: table_sessions table_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.table_sessions
    ADD CONSTRAINT table_sessions_pkey PRIMARY KEY (id);


--
-- Name: tax_channel_rules tax_channel_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.tax_channel_rules
    ADD CONSTRAINT tax_channel_rules_pkey PRIMARY KEY (id);


--
-- Name: taxes taxes_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.taxes
    ADD CONSTRAINT taxes_pkey PRIMARY KEY (id);


--
-- Name: terminals terminals_outlet_id_terminal_number_key; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.terminals
    ADD CONSTRAINT terminals_outlet_id_terminal_number_key UNIQUE (outlet_id, terminal_number);


--
-- Name: terminals terminals_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.terminals
    ADD CONSTRAINT terminals_pkey PRIMARY KEY (id);


--
-- Name: user_quick_links user_quick_links_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.user_quick_links
    ADD CONSTRAINT user_quick_links_pkey PRIMARY KEY (id);


--
-- Name: user_report_preferences user_report_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.user_report_preferences
    ADD CONSTRAINT user_report_preferences_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vendors vendors_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT vendors_pkey PRIMARY KEY (id);


--
-- Name: waiter_shift_handovers waiter_shift_handovers_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.waiter_shift_handovers
    ADD CONSTRAINT waiter_shift_handovers_pkey PRIMARY KEY (id);


--
-- Name: idx_access_logs_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_access_logs_outlet ON ONLY public.access_logs USING btree (outlet_id, created_at DESC);


--
-- Name: access_logs_default_outlet_id_created_at_idx; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX access_logs_default_outlet_id_created_at_idx ON public.access_logs_default USING btree (outlet_id, created_at DESC);


--
-- Name: access_logs_y2026m08_outlet_id_created_at_idx; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX access_logs_y2026m08_outlet_id_created_at_idx ON public.access_logs_y2026m08 USING btree (outlet_id, created_at DESC);


--
-- Name: idx_audit_logs_outlet_entity; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_audit_logs_outlet_entity ON ONLY public.audit_logs USING btree (outlet_id, entity_type, entity_id, created_at DESC);


--
-- Name: audit_logs_default_outlet_id_entity_type_entity_id_created__idx; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX audit_logs_default_outlet_id_entity_type_entity_id_created__idx ON public.audit_logs_default USING btree (outlet_id, entity_type, entity_id, created_at DESC);


--
-- Name: audit_logs_y2026m08_outlet_id_entity_type_entity_id_created_idx; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX audit_logs_y2026m08_outlet_id_entity_type_entity_id_created_idx ON public.audit_logs_y2026m08 USING btree (outlet_id, entity_type, entity_id, created_at DESC);


--
-- Name: idx_configuration_changes_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_configuration_changes_outlet ON ONLY public.configuration_changes USING btree (outlet_id, created_at DESC);


--
-- Name: configuration_changes_default_outlet_id_created_at_idx; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX configuration_changes_default_outlet_id_created_at_idx ON public.configuration_changes_default USING btree (outlet_id, created_at DESC);


--
-- Name: configuration_changes_y2026m08_outlet_id_created_at_idx; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX configuration_changes_y2026m08_outlet_id_created_at_idx ON public.configuration_changes_y2026m08 USING btree (outlet_id, created_at DESC);


--
-- Name: idx_addon_commissions_addon_item; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_addon_commissions_addon_item ON public.addon_commissions USING btree (addon_item_id);


--
-- Name: idx_addon_commissions_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_addon_commissions_outlet ON public.addon_commissions USING btree (outlet_id);


--
-- Name: idx_areas_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_areas_outlet ON public.areas USING btree (outlet_id);


--
-- Name: idx_availability_schedules_category; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_availability_schedules_category ON public.availability_schedules USING btree (category_id) WHERE (category_id IS NOT NULL);


--
-- Name: idx_availability_schedules_item; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_availability_schedules_item ON public.availability_schedules USING btree (item_id);


--
-- Name: idx_availability_schedules_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_availability_schedules_outlet ON public.availability_schedules USING btree (outlet_id);


--
-- Name: idx_campaign_recipients_campaign; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_campaign_recipients_campaign ON public.campaign_recipients USING btree (campaign_id);


--
-- Name: idx_cash_drawer_sessions_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_cash_drawer_sessions_outlet ON public.cash_drawer_sessions USING btree (outlet_id);


--
-- Name: idx_cash_drawer_sessions_status; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_cash_drawer_sessions_status ON public.cash_drawer_sessions USING btree (status);


--
-- Name: idx_categories_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_categories_outlet ON public.categories USING btree (outlet_id);


--
-- Name: idx_categories_parent; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_categories_parent ON public.categories USING btree (parent_id);


--
-- Name: idx_channel_accounts_integration; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_channel_accounts_integration ON public.channel_accounts USING btree (integration_id);


--
-- Name: idx_channel_accounts_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_channel_accounts_outlet ON public.channel_accounts USING btree (outlet_id);


--
-- Name: idx_channel_item_mapping_account; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_channel_item_mapping_account ON public.channel_item_mapping USING btree (channel_account_id);


--
-- Name: idx_channel_item_mapping_item; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_channel_item_mapping_item ON public.channel_item_mapping USING btree (item_id);


--
-- Name: idx_channel_item_mapping_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_channel_item_mapping_outlet ON public.channel_item_mapping USING btree (outlet_id);


--
-- Name: idx_channel_item_mapping_outlet_channel; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_channel_item_mapping_outlet_channel ON public.channel_item_mapping USING btree (outlet_id, channel_code);


--
-- Name: idx_consumption_log_order; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_consumption_log_order ON public.inventory_consumption_log USING btree (order_id);


--
-- Name: idx_consumption_log_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_consumption_log_outlet ON public.inventory_consumption_log USING btree (outlet_id);


--
-- Name: idx_customer_addresses_customer; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_customer_addresses_customer ON public.customer_addresses USING btree (customer_id);


--
-- Name: idx_customer_tags_customer; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_customer_tags_customer ON public.customer_tags USING btree (customer_id);


--
-- Name: idx_customers_organization; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_customers_organization ON public.customers USING btree (organization_id);


--
-- Name: idx_daily_sales_summary_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_daily_sales_summary_outlet ON public.daily_sales_summary USING btree (outlet_id, business_date);


--
-- Name: idx_dining_tables_merge_group; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_dining_tables_merge_group ON public.dining_tables USING btree (merge_group_id) WHERE (merge_group_id IS NOT NULL);


--
-- Name: idx_dining_tables_merge_primary; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_dining_tables_merge_primary ON public.dining_tables USING btree (merge_primary_table_id) WHERE (merge_primary_table_id IS NOT NULL);


--
-- Name: idx_hourly_sales_summary_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_hourly_sales_summary_outlet ON public.hourly_sales_summary USING btree (outlet_id, business_date);


--
-- Name: idx_inbound_events_channel_account; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_inbound_events_channel_account ON public.inbound_events USING btree (channel_account_id);


--
-- Name: idx_inbound_events_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_inbound_events_outlet ON public.inbound_events USING btree (outlet_id);


--
-- Name: idx_ingredients_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_ingredients_outlet ON public.ingredients USING btree (outlet_id);


--
-- Name: idx_integration_errors_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_integration_errors_outlet ON public.integration_errors USING btree (outlet_id);


--
-- Name: idx_integration_errors_source_event; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_integration_errors_source_event ON public.integration_errors USING btree (source_event_id);


--
-- Name: idx_invoices_created; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_invoices_created ON public.invoices USING btree (outlet_id, created_at);


--
-- Name: idx_invoices_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_invoices_outlet ON public.invoices USING btree (outlet_id);


--
-- Name: idx_item_availability_item; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_item_availability_item ON public.item_availability USING btree (item_id);


--
-- Name: idx_item_availability_item_channel; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_item_availability_item_channel ON public.item_availability USING btree (item_id, channel_id);


--
-- Name: idx_item_availability_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_item_availability_outlet ON public.item_availability USING btree (outlet_id);


--
-- Name: idx_item_commissions_menu_item; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_item_commissions_menu_item ON public.item_commissions USING btree (menu_item_id);


--
-- Name: idx_item_commissions_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_item_commissions_outlet ON public.item_commissions USING btree (outlet_id);


--
-- Name: idx_item_modifier_groups_group; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_item_modifier_groups_group ON public.item_modifier_groups USING btree (group_id);


--
-- Name: idx_item_modifier_groups_item; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_item_modifier_groups_item ON public.item_modifier_groups USING btree (item_id);


--
-- Name: idx_item_modifier_groups_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_item_modifier_groups_outlet ON public.item_modifier_groups USING btree (outlet_id);


--
-- Name: idx_item_prices_item; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_item_prices_item ON public.item_prices USING btree (item_id);


--
-- Name: idx_item_prices_price_list; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_item_prices_price_list ON public.item_prices USING btree (price_list_id);


--
-- Name: idx_item_sales_summary_item; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_item_sales_summary_item ON public.item_sales_summary USING btree (item_id);


--
-- Name: idx_item_sales_summary_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_item_sales_summary_outlet ON public.item_sales_summary USING btree (outlet_id, business_date);


--
-- Name: idx_item_variants_item; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_item_variants_item ON public.item_variants USING btree (item_id);


--
-- Name: idx_item_variants_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_item_variants_outlet ON public.item_variants USING btree (outlet_id);


--
-- Name: idx_kot_items_menu_item; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_kot_items_menu_item ON public.kot_items USING btree (menu_item_id);


--
-- Name: idx_kot_items_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_kot_items_outlet ON public.kot_items USING btree (outlet_id);


--
-- Name: idx_kot_items_seat; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_kot_items_seat ON public.kot_items USING btree (seat_id) WHERE (seat_id IS NOT NULL);


--
-- Name: idx_kot_items_ticket; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_kot_items_ticket ON public.kot_items USING btree (kot_ticket_id);


--
-- Name: idx_kot_performance_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_kot_performance_outlet ON public.kot_performance USING btree (outlet_id, business_date);


--
-- Name: idx_kot_performance_station; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_kot_performance_station ON public.kot_performance USING btree (station_id);


--
-- Name: idx_kot_status_history_ticket; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_kot_status_history_ticket ON public.kot_status_history USING btree (kot_ticket_id);


--
-- Name: idx_kot_tickets_order; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_kot_tickets_order ON public.kot_tickets USING btree (order_id);


--
-- Name: idx_kot_tickets_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_kot_tickets_outlet ON public.kot_tickets USING btree (outlet_id);


--
-- Name: idx_kot_tickets_station; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_kot_tickets_station ON public.kot_tickets USING btree (station_id);


--
-- Name: idx_kot_tickets_station_open; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_kot_tickets_station_open ON public.kot_tickets USING btree (station_id, status) WHERE (status <> 'SERVED'::text);


--
-- Name: idx_ledger_entries_account; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_ledger_entries_account ON public.ledger_entries USING btree (account);


--
-- Name: idx_ledger_entries_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_ledger_entries_outlet ON public.ledger_entries USING btree (outlet_id);


--
-- Name: idx_loyalty_accounts_customer; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_loyalty_accounts_customer ON public.loyalty_accounts USING btree (customer_id);


--
-- Name: idx_marketing_campaigns_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_marketing_campaigns_outlet ON public.marketing_campaigns USING btree (outlet_id);


--
-- Name: idx_menu_items_category; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_menu_items_category ON public.menu_items USING btree (category_id);


--
-- Name: idx_menu_items_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_menu_items_outlet ON public.menu_items USING btree (outlet_id);


--
-- Name: idx_modifier_groups_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_modifier_groups_outlet ON public.modifier_groups USING btree (outlet_id);


--
-- Name: idx_modifier_options_group; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_modifier_options_group ON public.modifier_options USING btree (modifier_group_id);


--
-- Name: idx_modifier_options_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_modifier_options_outlet ON public.modifier_options USING btree (outlet_id);


--
-- Name: idx_modifiers_group; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_modifiers_group ON public.modifiers USING btree (group_id);


--
-- Name: idx_modifiers_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_modifiers_outlet ON public.modifiers USING btree (outlet_id);


--
-- Name: idx_notifications_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_notifications_outlet ON public.notifications USING btree (outlet_id);


--
-- Name: idx_notifications_user; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_notifications_user ON public.notifications USING btree (user_id);


--
-- Name: idx_order_item_modifiers_modifier; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_order_item_modifiers_modifier ON public.order_item_modifiers USING btree (modifier_id);


--
-- Name: idx_order_item_modifiers_order_item; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_order_item_modifiers_order_item ON public.order_item_modifiers USING btree (order_item_id);


--
-- Name: idx_order_item_modifiers_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_order_item_modifiers_outlet ON public.order_item_modifiers USING btree (outlet_id);


--
-- Name: idx_order_item_seat_shares_order_item; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_order_item_seat_shares_order_item ON public.order_item_seat_shares USING btree (order_item_id);


--
-- Name: idx_order_item_seat_shares_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_order_item_seat_shares_outlet ON public.order_item_seat_shares USING btree (outlet_id);


--
-- Name: idx_order_items_item; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_order_items_item ON public.order_items USING btree (item_id);


--
-- Name: idx_order_items_order; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_order_items_order ON public.order_items USING btree (order_id);


--
-- Name: idx_order_items_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_order_items_outlet ON public.order_items USING btree (outlet_id);


--
-- Name: idx_order_items_seat; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_order_items_seat ON public.order_items USING btree (seat_id) WHERE (seat_id IS NOT NULL);


--
-- Name: idx_order_items_split_group; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_order_items_split_group ON public.order_items USING btree (split_group_id) WHERE (split_group_id IS NOT NULL);


--
-- Name: idx_order_items_variant; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_order_items_variant ON public.order_items USING btree (variant_id);


--
-- Name: idx_order_payments_order; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_order_payments_order ON public.order_payments USING btree (order_id);


--
-- Name: idx_order_payments_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_order_payments_outlet ON public.order_payments USING btree (outlet_id);


--
-- Name: idx_order_refunds_order; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_order_refunds_order ON public.order_refunds USING btree (order_id);


--
-- Name: idx_order_refunds_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_order_refunds_outlet ON public.order_refunds USING btree (outlet_id);


--
-- Name: idx_order_seat_bills_order; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_order_seat_bills_order ON public.order_seat_bills USING btree (order_id);


--
-- Name: idx_order_seat_bills_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_order_seat_bills_outlet ON public.order_seat_bills USING btree (outlet_id);


--
-- Name: idx_order_status_history_order; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_order_status_history_order ON public.order_status_history USING btree (order_id);


--
-- Name: idx_order_status_history_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_order_status_history_outlet ON public.order_status_history USING btree (outlet_id);


--
-- Name: idx_orders_channel; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_orders_channel ON public.orders USING btree (channel) WHERE (channel IS NOT NULL);


--
-- Name: idx_orders_customer; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_orders_customer ON public.orders USING btree (customer_id);


--
-- Name: idx_orders_external_order_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_orders_external_order_id ON public.orders USING btree (external_order_id) WHERE (external_order_id IS NOT NULL);


--
-- Name: idx_orders_merge_group; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_orders_merge_group ON public.orders USING btree (merge_group_id) WHERE (merge_group_id IS NOT NULL);


--
-- Name: idx_orders_merged_into; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_orders_merged_into ON public.orders USING btree (merged_into_order_id) WHERE (merged_into_order_id IS NOT NULL);


--
-- Name: idx_orders_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_orders_outlet ON public.orders USING btree (outlet_id);


--
-- Name: idx_orders_outlet_status_date; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_orders_outlet_status_date ON public.orders USING btree (outlet_id, status, business_date);


--
-- Name: idx_orders_scheduled_fire_at; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_orders_scheduled_fire_at ON public.orders USING btree (scheduled_fire_at) WHERE (scheduled_fire_at IS NOT NULL);


--
-- Name: idx_outbound_events_channel_account; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_outbound_events_channel_account ON public.outbound_events USING btree (channel_account_id);


--
-- Name: idx_outbound_events_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_outbound_events_outlet ON public.outbound_events USING btree (outlet_id);


--
-- Name: idx_outbox_pending; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_outbox_pending ON public.outbox_events USING btree (status, created_at) WHERE ((status)::text = 'PENDING'::text);


--
-- Name: idx_outlets_org; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_outlets_org ON public.outlets USING btree (organization_id);


--
-- Name: idx_payment_summary_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_payment_summary_outlet ON public.payment_summary USING btree (outlet_id, business_date);


--
-- Name: idx_payments_order_seat_bill; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_payments_order_seat_bill ON public.payments USING btree (order_seat_bill_id) WHERE (order_seat_bill_id IS NOT NULL);


--
-- Name: idx_payments_seat; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_payments_seat ON public.payments USING btree (seat_id) WHERE (seat_id IS NOT NULL);


--
-- Name: idx_petty_cash_ledger_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_petty_cash_ledger_outlet ON public.petty_cash_ledger USING btree (outlet_id);


--
-- Name: idx_petty_cash_ledger_session; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_petty_cash_ledger_session ON public.petty_cash_ledger USING btree (cash_drawer_session_id);


--
-- Name: idx_physical_menu_files_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_physical_menu_files_outlet ON public.physical_menu_files USING btree (outlet_id);


--
-- Name: idx_price_lists_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_price_lists_outlet ON public.price_lists USING btree (outlet_id) WHERE is_active;


--
-- Name: idx_purchase_order_items_po; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_purchase_order_items_po ON public.purchase_order_items USING btree (po_id);


--
-- Name: idx_purchase_orders_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_purchase_orders_outlet ON public.purchase_orders USING btree (outlet_id);


--
-- Name: idx_purchase_orders_vendor; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_purchase_orders_vendor ON public.purchase_orders USING btree (vendor_id);


--
-- Name: idx_recipe_ingredients_ingredient; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_recipe_ingredients_ingredient ON public.recipe_ingredients USING btree (ingredient_id);


--
-- Name: idx_recipe_ingredients_recipe; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_recipe_ingredients_recipe ON public.recipe_ingredients USING btree (recipe_id);


--
-- Name: idx_recipes_menu_item; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_recipes_menu_item ON public.recipes USING btree (menu_item_id);


--
-- Name: idx_recipes_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_recipes_outlet ON public.recipes USING btree (outlet_id);


--
-- Name: idx_sessions_user; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_sessions_user ON public.sessions USING btree (user_id) WHERE (revoked_at IS NULL);


--
-- Name: idx_special_notes_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_special_notes_outlet ON public.special_notes USING btree (outlet_id);


--
-- Name: idx_stations_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_stations_outlet ON public.stations USING btree (outlet_id);


--
-- Name: idx_sync_jobs_channel_account; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_sync_jobs_channel_account ON public.sync_jobs USING btree (channel_account_id);


--
-- Name: idx_sync_jobs_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_sync_jobs_outlet ON public.sync_jobs USING btree (outlet_id);


--
-- Name: idx_table_merge_groups_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_table_merge_groups_outlet ON public.table_merge_groups USING btree (outlet_id);


--
-- Name: idx_table_merge_groups_primary_table; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_table_merge_groups_primary_table ON public.table_merge_groups USING btree (primary_table_id);


--
-- Name: idx_table_merge_members_group; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_table_merge_members_group ON public.table_merge_members USING btree (merge_group_id);


--
-- Name: idx_table_merge_members_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_table_merge_members_outlet ON public.table_merge_members USING btree (outlet_id);


--
-- Name: idx_table_merge_members_table; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_table_merge_members_table ON public.table_merge_members USING btree (dining_table_id);


--
-- Name: idx_table_seats_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_table_seats_outlet ON public.table_seats USING btree (outlet_id);


--
-- Name: idx_table_seats_table; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_table_seats_table ON public.table_seats USING btree (dining_table_id);


--
-- Name: idx_user_quick_links_user; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_user_quick_links_user ON public.user_quick_links USING btree (user_id);


--
-- Name: idx_user_roles_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_user_roles_outlet ON public.user_roles USING btree (outlet_id);


--
-- Name: idx_vendors_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_vendors_outlet ON public.vendors USING btree (outlet_id);


--
-- Name: idx_waiter_shift_handovers_outlet_date; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_waiter_shift_handovers_outlet_date ON public.waiter_shift_handovers USING btree (outlet_id, business_date);


--
-- Name: idx_waiter_shift_handovers_waiter; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX idx_waiter_shift_handovers_waiter ON public.waiter_shift_handovers USING btree (waiter_id);


--
-- Name: ix_backup_jobs_created_at; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_backup_jobs_created_at ON public.backup_jobs USING btree (created_at);


--
-- Name: ix_backup_jobs_outlet_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_backup_jobs_outlet_id ON public.backup_jobs USING btree (outlet_id);


--
-- Name: ix_backup_jobs_status; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_backup_jobs_status ON public.backup_jobs USING btree (status);


--
-- Name: ix_channel_sync_log_attempted_at; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_channel_sync_log_attempted_at ON public.channel_sync_log USING btree (attempted_at);


--
-- Name: ix_channel_sync_log_order_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_channel_sync_log_order_id ON public.channel_sync_log USING btree (order_id);


--
-- Name: ix_channel_sync_log_outlet_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_channel_sync_log_outlet_id ON public.channel_sync_log USING btree (outlet_id);


--
-- Name: ix_channel_sync_log_status; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_channel_sync_log_status ON public.channel_sync_log USING btree (status);


--
-- Name: ix_menu_item_availability_is_oos; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_menu_item_availability_is_oos ON public.menu_item_availability USING btree (is_out_of_stock);


--
-- Name: ix_menu_item_availability_outlet_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_menu_item_availability_outlet_id ON public.menu_item_availability USING btree (outlet_id);


--
-- Name: ix_menu_item_channel_status_menu_item_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_menu_item_channel_status_menu_item_id ON public.menu_item_channel_status USING btree (menu_item_id);


--
-- Name: ix_menu_item_channel_status_outlet_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_menu_item_channel_status_outlet_id ON public.menu_item_channel_status USING btree (outlet_id);


--
-- Name: ix_order_audit_log_actor_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_order_audit_log_actor_id ON public.order_audit_log USING btree (actor_id);


--
-- Name: ix_order_audit_log_at; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_order_audit_log_at ON public.order_audit_log USING btree (at);


--
-- Name: ix_order_audit_log_order_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_order_audit_log_order_id ON public.order_audit_log USING btree (order_id);


--
-- Name: ix_order_audit_log_outlet_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_order_audit_log_outlet_id ON public.order_audit_log USING btree (outlet_id);


--
-- Name: ix_payment_type_master_is_active; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_payment_type_master_is_active ON public.payment_type_master USING btree (is_active);


--
-- Name: ix_payment_type_master_outlet_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_payment_type_master_outlet_id ON public.payment_type_master USING btree (outlet_id);


--
-- Name: ix_restaurant_tables_outlet_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_restaurant_tables_outlet_id ON public.restaurant_tables USING btree (outlet_id);


--
-- Name: ix_restaurant_tables_zone; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_restaurant_tables_zone ON public.restaurant_tables USING btree (zone);


--
-- Name: ix_sales_returns_order_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_sales_returns_order_id ON public.sales_returns USING btree (order_id);


--
-- Name: ix_sales_returns_order_item_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_sales_returns_order_item_id ON public.sales_returns USING btree (order_item_id);


--
-- Name: ix_sales_returns_outlet_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_sales_returns_outlet_id ON public.sales_returns USING btree (outlet_id);


--
-- Name: ix_sales_returns_returned_at; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_sales_returns_returned_at ON public.sales_returns USING btree (returned_at);


--
-- Name: ix_sync_state_is_online; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_sync_state_is_online ON public.sync_state USING btree (is_online);


--
-- Name: ix_sync_state_outlet_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_sync_state_outlet_id ON public.sync_state USING btree (outlet_id);


--
-- Name: ix_table_sessions_opened_at; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_table_sessions_opened_at ON public.table_sessions USING btree (opened_at);


--
-- Name: ix_table_sessions_outlet_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_table_sessions_outlet_id ON public.table_sessions USING btree (outlet_id);


--
-- Name: ix_table_sessions_status; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_table_sessions_status ON public.table_sessions USING btree (status);


--
-- Name: ix_table_sessions_table_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_table_sessions_table_id ON public.table_sessions USING btree (table_id);


--
-- Name: ix_tax_channel_rules_channel; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_tax_channel_rules_channel ON public.tax_channel_rules USING btree (outlet_id, channel);


--
-- Name: ix_tax_channel_rules_outlet_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_tax_channel_rules_outlet_id ON public.tax_channel_rules USING btree (outlet_id);


--
-- Name: ix_taxes_is_active; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_taxes_is_active ON public.taxes USING btree (is_active);


--
-- Name: ix_taxes_outlet_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_taxes_outlet_id ON public.taxes USING btree (outlet_id);


--
-- Name: ix_user_report_preferences_user_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_user_report_preferences_user_id ON public.user_report_preferences USING btree (user_id);


--
-- Name: uq_customers_phone; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX uq_customers_phone ON public.customers USING btree (phone);


--
-- Name: uq_inbound_events_channel_external; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX uq_inbound_events_channel_external ON public.inbound_events USING btree (channel_account_id, external_event_id);


--
-- Name: uq_invoices_order_seat; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX uq_invoices_order_seat ON public.invoices USING btree (order_id, seat_number);


--
-- Name: uq_item_availability_item_channel; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX uq_item_availability_item_channel ON public.item_availability USING btree (item_id, channel_id);


--
-- Name: uq_item_prices_list_item_variant; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX uq_item_prices_list_item_variant ON public.item_prices USING btree (price_list_id, item_id, COALESCE(variant_id, '00000000-0000-0000-0000-000000000000'::uuid));


--
-- Name: uq_order_item_seat_shares_item_seat; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX uq_order_item_seat_shares_item_seat ON public.order_item_seat_shares USING btree (order_item_id, seat_number);


--
-- Name: uq_order_seat_bills_outlet_order_seat; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX uq_order_seat_bills_outlet_order_seat ON public.order_seat_bills USING btree (outlet_id, order_id, seat_number);


--
-- Name: uq_orders_outlet_number; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX uq_orders_outlet_number ON public.orders USING btree (outlet_id, order_number);


--
-- Name: uq_outlets_code; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX uq_outlets_code ON public.outlets USING btree (code);


--
-- Name: uq_permissions_code; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX uq_permissions_code ON public.permissions USING btree (code);


--
-- Name: uq_roles_code; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX uq_roles_code ON public.roles USING btree (code);


--
-- Name: uq_roles_name; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX uq_roles_name ON public.roles USING btree (name);


--
-- Name: uq_table_merge_groups_active_primary; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX uq_table_merge_groups_active_primary ON public.table_merge_groups USING btree (outlet_id, primary_table_id) WHERE (status = 'ACTIVE'::public.table_merge_status);


--
-- Name: uq_table_merge_members_active_table; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX uq_table_merge_members_active_table ON public.table_merge_members USING btree (dining_table_id) WHERE (left_at IS NULL);


--
-- Name: uq_table_operation_idempotency_key; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX uq_table_operation_idempotency_key ON public.table_operation_idempotency USING btree (outlet_id, endpoint, idempotency_key);


--
-- Name: uq_table_seats_outlet_table_seat; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX uq_table_seats_outlet_table_seat ON public.table_seats USING btree (outlet_id, dining_table_id, seat_number);


--
-- Name: uq_user_roles; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX uq_user_roles ON public.user_roles USING btree (user_id, role_id, COALESCE(outlet_id, '00000000-0000-0000-0000-000000000000'::uuid));


--
-- Name: uq_users_email; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX uq_users_email ON public.users USING btree (email);


--
-- Name: ux_menu_categories_outlet_name; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX ux_menu_categories_outlet_name ON public.menu_categories USING btree (outlet_id, name);


--
-- Name: ux_menu_item_availability_item; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX ux_menu_item_availability_item ON public.menu_item_availability USING btree (menu_item_id);


--
-- Name: ux_menu_item_channel_status_item_channel; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX ux_menu_item_channel_status_item_channel ON public.menu_item_channel_status USING btree (menu_item_id, channel);


--
-- Name: ux_outlet_billing_settings_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX ux_outlet_billing_settings_outlet ON public.outlet_billing_settings USING btree (outlet_id);


--
-- Name: ux_outlet_print_settings_outlet; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX ux_outlet_print_settings_outlet ON public.outlet_print_settings USING btree (outlet_id);


--
-- Name: ux_payment_type_master_outlet_label; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX ux_payment_type_master_outlet_label ON public.payment_type_master USING btree (outlet_id, label);


--
-- Name: ux_restaurant_tables_outlet_tableno; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX ux_restaurant_tables_outlet_tableno ON public.restaurant_tables USING btree (outlet_id, table_no);


--
-- Name: ux_sync_state_outlet_device; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX ux_sync_state_outlet_device ON public.sync_state USING btree (outlet_id, device_id);


--
-- Name: ux_tax_channel_rules_tax_channel; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX ux_tax_channel_rules_tax_channel ON public.tax_channel_rules USING btree (tax_id, channel);


--
-- Name: ux_taxes_outlet_name; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX ux_taxes_outlet_name ON public.taxes USING btree (outlet_id, name);


--
-- Name: ux_user_report_preferences_user_report; Type: INDEX; Schema: public; Owner: pos
--

CREATE UNIQUE INDEX ux_user_report_preferences_user_report ON public.user_report_preferences USING btree (user_id, report_key);


--
-- Name: access_logs_default_outlet_id_created_at_idx; Type: INDEX ATTACH; Schema: public; Owner: pos
--

ALTER INDEX public.idx_access_logs_outlet ATTACH PARTITION public.access_logs_default_outlet_id_created_at_idx;


--
-- Name: access_logs_default_pkey; Type: INDEX ATTACH; Schema: public; Owner: pos
--

ALTER INDEX public.access_logs_pkey ATTACH PARTITION public.access_logs_default_pkey;


--
-- Name: access_logs_y2026m08_outlet_id_created_at_idx; Type: INDEX ATTACH; Schema: public; Owner: pos
--

ALTER INDEX public.idx_access_logs_outlet ATTACH PARTITION public.access_logs_y2026m08_outlet_id_created_at_idx;


--
-- Name: access_logs_y2026m08_pkey; Type: INDEX ATTACH; Schema: public; Owner: pos
--

ALTER INDEX public.access_logs_pkey ATTACH PARTITION public.access_logs_y2026m08_pkey;


--
-- Name: audit_logs_default_outlet_id_entity_type_entity_id_created__idx; Type: INDEX ATTACH; Schema: public; Owner: pos
--

ALTER INDEX public.idx_audit_logs_outlet_entity ATTACH PARTITION public.audit_logs_default_outlet_id_entity_type_entity_id_created__idx;


--
-- Name: audit_logs_default_pkey; Type: INDEX ATTACH; Schema: public; Owner: pos
--

ALTER INDEX public.audit_logs_pkey ATTACH PARTITION public.audit_logs_default_pkey;


--
-- Name: audit_logs_y2026m08_outlet_id_entity_type_entity_id_created_idx; Type: INDEX ATTACH; Schema: public; Owner: pos
--

ALTER INDEX public.idx_audit_logs_outlet_entity ATTACH PARTITION public.audit_logs_y2026m08_outlet_id_entity_type_entity_id_created_idx;


--
-- Name: audit_logs_y2026m08_pkey; Type: INDEX ATTACH; Schema: public; Owner: pos
--

ALTER INDEX public.audit_logs_pkey ATTACH PARTITION public.audit_logs_y2026m08_pkey;


--
-- Name: configuration_changes_default_outlet_id_created_at_idx; Type: INDEX ATTACH; Schema: public; Owner: pos
--

ALTER INDEX public.idx_configuration_changes_outlet ATTACH PARTITION public.configuration_changes_default_outlet_id_created_at_idx;


--
-- Name: configuration_changes_default_pkey; Type: INDEX ATTACH; Schema: public; Owner: pos
--

ALTER INDEX public.configuration_changes_pkey ATTACH PARTITION public.configuration_changes_default_pkey;


--
-- Name: configuration_changes_y2026m08_outlet_id_created_at_idx; Type: INDEX ATTACH; Schema: public; Owner: pos
--

ALTER INDEX public.idx_configuration_changes_outlet ATTACH PARTITION public.configuration_changes_y2026m08_outlet_id_created_at_idx;


--
-- Name: configuration_changes_y2026m08_pkey; Type: INDEX ATTACH; Schema: public; Owner: pos
--

ALTER INDEX public.configuration_changes_pkey ATTACH PARTITION public.configuration_changes_y2026m08_pkey;


--
-- Name: orders trg_order_status_guard; Type: TRIGGER; Schema: public; Owner: pos
--

CREATE TRIGGER trg_order_status_guard BEFORE UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION public.fn_assert_status_transition();


--
-- Name: audit_logs trg_sync_audit_logs_columns; Type: TRIGGER; Schema: public; Owner: pos
--

CREATE TRIGGER trg_sync_audit_logs_columns BEFORE INSERT OR UPDATE ON public.audit_logs FOR EACH ROW EXECUTE FUNCTION public.sync_audit_logs_columns();


--
-- Name: invoices trg_sync_invoice_columns; Type: TRIGGER; Schema: public; Owner: pos
--

CREATE TRIGGER trg_sync_invoice_columns BEFORE INSERT OR UPDATE ON public.invoices FOR EACH ROW EXECUTE FUNCTION public.sync_invoice_columns();


--
-- Name: invoices trg_sync_invoice_fields; Type: TRIGGER; Schema: public; Owner: pos
--

CREATE TRIGGER trg_sync_invoice_fields BEFORE INSERT OR UPDATE ON public.invoices FOR EACH ROW EXECUTE FUNCTION public.sync_invoice_fields();


--
-- Name: order_items trg_sync_order_items_columns; Type: TRIGGER; Schema: public; Owner: pos
--

CREATE TRIGGER trg_sync_order_items_columns BEFORE INSERT OR UPDATE ON public.order_items FOR EACH ROW EXECUTE FUNCTION public.sync_order_items_columns();


--
-- Name: order_status_history trg_sync_order_status_history; Type: TRIGGER; Schema: public; Owner: pos
--

CREATE TRIGGER trg_sync_order_status_history BEFORE INSERT OR UPDATE ON public.order_status_history FOR EACH ROW EXECUTE FUNCTION public.sync_order_status_history();


--
-- Name: orders trg_sync_orders_columns; Type: TRIGGER; Schema: public; Owner: pos
--

CREATE TRIGGER trg_sync_orders_columns BEFORE INSERT OR UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION public.sync_orders_columns();


--
-- Name: access_logs access_logs_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE public.access_logs
    ADD CONSTRAINT access_logs_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: addon_commissions addon_commissions_addon_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.addon_commissions
    ADD CONSTRAINT addon_commissions_addon_item_id_fkey FOREIGN KEY (addon_item_id) REFERENCES public.modifier_options(id);


--
-- Name: addon_commissions addon_commissions_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.addon_commissions
    ADD CONSTRAINT addon_commissions_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: audit_logs audit_logs_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE public.audit_logs
    ADD CONSTRAINT audit_logs_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: availability_schedules availability_schedules_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.availability_schedules
    ADD CONSTRAINT availability_schedules_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.menu_categories(id);


--
-- Name: availability_schedules availability_schedules_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.availability_schedules
    ADD CONSTRAINT availability_schedules_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.menu_items(id);


--
-- Name: availability_schedules availability_schedules_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.availability_schedules
    ADD CONSTRAINT availability_schedules_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: backup_jobs backup_jobs_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.backup_jobs
    ADD CONSTRAINT backup_jobs_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id) ON DELETE RESTRICT;


--
-- Name: campaign_recipients campaign_recipients_campaign_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.campaign_recipients
    ADD CONSTRAINT campaign_recipients_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES public.marketing_campaigns(id) ON DELETE CASCADE;


--
-- Name: campaign_recipients campaign_recipients_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.campaign_recipients
    ADD CONSTRAINT campaign_recipients_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE SET NULL;


--
-- Name: categories categories_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: categories categories_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.categories(id);


--
-- Name: channel_accounts channel_accounts_integration_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.channel_accounts
    ADD CONSTRAINT channel_accounts_integration_id_fkey FOREIGN KEY (integration_id) REFERENCES public.integrations(id);


--
-- Name: channel_accounts channel_accounts_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.channel_accounts
    ADD CONSTRAINT channel_accounts_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: channel_item_mapping channel_item_mapping_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.channel_item_mapping
    ADD CONSTRAINT channel_item_mapping_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.menu_items(id);


--
-- Name: channel_item_mapping channel_item_mapping_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.channel_item_mapping
    ADD CONSTRAINT channel_item_mapping_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: channel_sync_log channel_sync_log_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.channel_sync_log
    ADD CONSTRAINT channel_sync_log_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE RESTRICT;


--
-- Name: channel_sync_log channel_sync_log_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.channel_sync_log
    ADD CONSTRAINT channel_sync_log_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id) ON DELETE RESTRICT;


--
-- Name: configuration_changes configuration_changes_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE public.configuration_changes
    ADD CONSTRAINT configuration_changes_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: customer_addresses customer_addresses_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.customer_addresses
    ADD CONSTRAINT customer_addresses_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: customer_tags customer_tags_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.customer_tags
    ADD CONSTRAINT customer_tags_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: customers customers_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: daily_sales_summary daily_sales_summary_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.daily_sales_summary
    ADD CONSTRAINT daily_sales_summary_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: dining_tables dining_tables_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.dining_tables
    ADD CONSTRAINT dining_tables_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: hourly_sales_summary hourly_sales_summary_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.hourly_sales_summary
    ADD CONSTRAINT hourly_sales_summary_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: inbound_events inbound_events_channel_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.inbound_events
    ADD CONSTRAINT inbound_events_channel_account_id_fkey FOREIGN KEY (channel_account_id) REFERENCES public.channel_accounts(id);


--
-- Name: inbound_events inbound_events_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.inbound_events
    ADD CONSTRAINT inbound_events_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: integration_errors integration_errors_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.integration_errors
    ADD CONSTRAINT integration_errors_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: integration_errors integration_errors_source_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.integration_errors
    ADD CONSTRAINT integration_errors_source_event_id_fkey FOREIGN KEY (source_event_id) REFERENCES public.inbound_events(id);


--
-- Name: item_availabilities item_availabilities_menu_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.item_availabilities
    ADD CONSTRAINT item_availabilities_menu_item_id_fkey FOREIGN KEY (menu_item_id) REFERENCES public.menu_items(id);


--
-- Name: item_availabilities item_availabilities_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.item_availabilities
    ADD CONSTRAINT item_availabilities_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: item_availability item_availability_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.item_availability
    ADD CONSTRAINT item_availability_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.menu_items(id);


--
-- Name: item_availability item_availability_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.item_availability
    ADD CONSTRAINT item_availability_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: item_commissions item_commissions_menu_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.item_commissions
    ADD CONSTRAINT item_commissions_menu_item_id_fkey FOREIGN KEY (menu_item_id) REFERENCES public.menu_items(id);


--
-- Name: item_commissions item_commissions_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.item_commissions
    ADD CONSTRAINT item_commissions_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: item_modifier_groups item_modifier_groups_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.item_modifier_groups
    ADD CONSTRAINT item_modifier_groups_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.modifier_groups(id);


--
-- Name: item_modifier_groups item_modifier_groups_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.item_modifier_groups
    ADD CONSTRAINT item_modifier_groups_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.menu_items(id);


--
-- Name: item_modifier_groups item_modifier_groups_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.item_modifier_groups
    ADD CONSTRAINT item_modifier_groups_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: item_prices item_prices_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.item_prices
    ADD CONSTRAINT item_prices_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.menu_items(id);


--
-- Name: item_prices item_prices_price_list_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.item_prices
    ADD CONSTRAINT item_prices_price_list_id_fkey FOREIGN KEY (price_list_id) REFERENCES public.price_lists(id) ON DELETE CASCADE;


--
-- Name: item_prices item_prices_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.item_prices
    ADD CONSTRAINT item_prices_variant_id_fkey FOREIGN KEY (variant_id) REFERENCES public.item_variants(id);


--
-- Name: item_sales_summary item_sales_summary_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.item_sales_summary
    ADD CONSTRAINT item_sales_summary_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.menu_items(id);


--
-- Name: item_sales_summary item_sales_summary_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.item_sales_summary
    ADD CONSTRAINT item_sales_summary_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: item_variants item_variants_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.item_variants
    ADD CONSTRAINT item_variants_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.menu_items(id);


--
-- Name: item_variants item_variants_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.item_variants
    ADD CONSTRAINT item_variants_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: kot_items kot_items_kot_ticket_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.kot_items
    ADD CONSTRAINT kot_items_kot_ticket_id_fkey FOREIGN KEY (kot_ticket_id) REFERENCES public.kot_tickets(id) ON DELETE CASCADE;


--
-- Name: kot_items kot_items_menu_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.kot_items
    ADD CONSTRAINT kot_items_menu_item_id_fkey FOREIGN KEY (menu_item_id) REFERENCES public.menu_items(id);


--
-- Name: kot_items kot_items_seat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.kot_items
    ADD CONSTRAINT kot_items_seat_id_fkey FOREIGN KEY (seat_id) REFERENCES public.table_seats(id);


--
-- Name: kot_performance kot_performance_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.kot_performance
    ADD CONSTRAINT kot_performance_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: kot_performance kot_performance_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.kot_performance
    ADD CONSTRAINT kot_performance_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.stations(id);


--
-- Name: kot_status_history kot_status_history_kot_ticket_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.kot_status_history
    ADD CONSTRAINT kot_status_history_kot_ticket_id_fkey FOREIGN KEY (kot_ticket_id) REFERENCES public.kot_tickets(id) ON DELETE CASCADE;


--
-- Name: kot_tickets kot_tickets_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.kot_tickets
    ADD CONSTRAINT kot_tickets_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: kot_tickets kot_tickets_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.kot_tickets
    ADD CONSTRAINT kot_tickets_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id) ON DELETE CASCADE;


--
-- Name: kot_tickets kot_tickets_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.kot_tickets
    ADD CONSTRAINT kot_tickets_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.stations(id);


--
-- Name: ledger_entries ledger_entries_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.ledger_entries
    ADD CONSTRAINT ledger_entries_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: loyalty_accounts loyalty_accounts_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.loyalty_accounts
    ADD CONSTRAINT loyalty_accounts_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: marketing_campaigns marketing_campaigns_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.marketing_campaigns
    ADD CONSTRAINT marketing_campaigns_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id) ON DELETE CASCADE;


--
-- Name: menu_categories menu_categories_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.menu_categories
    ADD CONSTRAINT menu_categories_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id) ON DELETE RESTRICT;


--
-- Name: menu_item_availability menu_item_availability_menu_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.menu_item_availability
    ADD CONSTRAINT menu_item_availability_menu_item_id_fkey FOREIGN KEY (menu_item_id) REFERENCES public.menu_items(id) ON DELETE CASCADE;


--
-- Name: menu_item_availability menu_item_availability_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.menu_item_availability
    ADD CONSTRAINT menu_item_availability_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id) ON DELETE RESTRICT;


--
-- Name: menu_item_availability menu_item_availability_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.menu_item_availability
    ADD CONSTRAINT menu_item_availability_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: menu_item_channel_status menu_item_channel_status_menu_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.menu_item_channel_status
    ADD CONSTRAINT menu_item_channel_status_menu_item_id_fkey FOREIGN KEY (menu_item_id) REFERENCES public.menu_items(id) ON DELETE CASCADE;


--
-- Name: menu_item_channel_status menu_item_channel_status_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.menu_item_channel_status
    ADD CONSTRAINT menu_item_channel_status_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id) ON DELETE RESTRICT;


--
-- Name: menu_item_channel_status menu_item_channel_status_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.menu_item_channel_status
    ADD CONSTRAINT menu_item_channel_status_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: menu_items menu_items_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT menu_items_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.menu_categories(id) ON DELETE CASCADE;


--
-- Name: menu_items menu_items_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT menu_items_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: menu_items menu_items_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT menu_items_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.stations(id);


--
-- Name: modifier_groups modifier_groups_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.modifier_groups
    ADD CONSTRAINT modifier_groups_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: modifier_options modifier_options_modifier_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.modifier_options
    ADD CONSTRAINT modifier_options_modifier_group_id_fkey FOREIGN KEY (modifier_group_id) REFERENCES public.modifier_groups(id);


--
-- Name: modifiers modifiers_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.modifiers
    ADD CONSTRAINT modifiers_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.modifier_groups(id);


--
-- Name: modifiers modifiers_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.modifiers
    ADD CONSTRAINT modifiers_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: notifications notifications_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id) ON DELETE CASCADE;


--
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: order_audit_log order_audit_log_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_audit_log
    ADD CONSTRAINT order_audit_log_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: order_audit_log order_audit_log_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_audit_log
    ADD CONSTRAINT order_audit_log_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: order_audit_log order_audit_log_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_audit_log
    ADD CONSTRAINT order_audit_log_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE RESTRICT;


--
-- Name: order_audit_log order_audit_log_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_audit_log
    ADD CONSTRAINT order_audit_log_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id) ON DELETE RESTRICT;


--
-- Name: order_item_modifiers order_item_modifiers_modifier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_item_modifiers
    ADD CONSTRAINT order_item_modifiers_modifier_id_fkey FOREIGN KEY (modifier_id) REFERENCES public.modifiers(id);


--
-- Name: order_item_modifiers order_item_modifiers_order_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_item_modifiers
    ADD CONSTRAINT order_item_modifiers_order_item_id_fkey FOREIGN KEY (order_item_id) REFERENCES public.order_items(id);


--
-- Name: order_item_modifiers order_item_modifiers_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_item_modifiers
    ADD CONSTRAINT order_item_modifiers_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: order_item_seat_shares order_item_seat_shares_order_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_item_seat_shares
    ADD CONSTRAINT order_item_seat_shares_order_item_id_fkey FOREIGN KEY (order_item_id) REFERENCES public.order_items(id);


--
-- Name: order_items order_items_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.menu_items(id);


--
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- Name: order_items order_items_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: order_items order_items_seat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_seat_id_fkey FOREIGN KEY (seat_id) REFERENCES public.table_seats(id);


--
-- Name: order_items order_items_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_variant_id_fkey FOREIGN KEY (variant_id) REFERENCES public.item_variants(id);


--
-- Name: order_payments order_payments_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_payments
    ADD CONSTRAINT order_payments_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- Name: order_payments order_payments_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_payments
    ADD CONSTRAINT order_payments_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: order_refunds order_refunds_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_refunds
    ADD CONSTRAINT order_refunds_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- Name: order_refunds order_refunds_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_refunds
    ADD CONSTRAINT order_refunds_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: order_seat_bills order_seat_bills_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_seat_bills
    ADD CONSTRAINT order_seat_bills_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- Name: order_status_history order_status_history_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_status_history
    ADD CONSTRAINT order_status_history_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- Name: order_status_history order_status_history_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_status_history
    ADD CONSTRAINT order_status_history_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: orders orders_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: outbound_events outbound_events_channel_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.outbound_events
    ADD CONSTRAINT outbound_events_channel_account_id_fkey FOREIGN KEY (channel_account_id) REFERENCES public.channel_accounts(id);


--
-- Name: outbound_events outbound_events_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.outbound_events
    ADD CONSTRAINT outbound_events_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: outlet_billing_settings outlet_billing_settings_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.outlet_billing_settings
    ADD CONSTRAINT outlet_billing_settings_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id) ON DELETE RESTRICT;


--
-- Name: outlet_print_settings outlet_print_settings_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.outlet_print_settings
    ADD CONSTRAINT outlet_print_settings_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id) ON DELETE RESTRICT;


--
-- Name: outlets outlets_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.outlets
    ADD CONSTRAINT outlets_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: payment_summary payment_summary_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.payment_summary
    ADD CONSTRAINT payment_summary_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: payment_type_master payment_type_master_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.payment_type_master
    ADD CONSTRAINT payment_type_master_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id) ON DELETE RESTRICT;


--
-- Name: payments payments_order_seat_bill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_order_seat_bill_id_fkey FOREIGN KEY (order_seat_bill_id) REFERENCES public.order_seat_bills(id);


--
-- Name: payments payments_seat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_seat_id_fkey FOREIGN KEY (seat_id) REFERENCES public.table_seats(id);


--
-- Name: petty_cash_ledger petty_cash_ledger_cash_drawer_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.petty_cash_ledger
    ADD CONSTRAINT petty_cash_ledger_cash_drawer_session_id_fkey FOREIGN KEY (cash_drawer_session_id) REFERENCES public.cash_drawer_sessions(id);


--
-- Name: physical_menu_files physical_menu_files_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.physical_menu_files
    ADD CONSTRAINT physical_menu_files_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: physical_menu_files physical_menu_files_uploaded_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.physical_menu_files
    ADD CONSTRAINT physical_menu_files_uploaded_by_user_id_fkey FOREIGN KEY (uploaded_by_user_id) REFERENCES public.users(id);


--
-- Name: price_lists price_lists_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.price_lists
    ADD CONSTRAINT price_lists_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: purchase_order_items purchase_order_items_ingredient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT purchase_order_items_ingredient_id_fkey FOREIGN KEY (ingredient_id) REFERENCES public.ingredients(id);


--
-- Name: purchase_order_items purchase_order_items_po_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT purchase_order_items_po_id_fkey FOREIGN KEY (po_id) REFERENCES public.purchase_orders(id) ON DELETE CASCADE;


--
-- Name: purchase_orders purchase_orders_vendor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.vendors(id);


--
-- Name: recipe_ingredients recipe_ingredients_ingredient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.recipe_ingredients
    ADD CONSTRAINT recipe_ingredients_ingredient_id_fkey FOREIGN KEY (ingredient_id) REFERENCES public.ingredients(id);


--
-- Name: recipe_ingredients recipe_ingredients_recipe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.recipe_ingredients
    ADD CONSTRAINT recipe_ingredients_recipe_id_fkey FOREIGN KEY (recipe_id) REFERENCES public.recipes(id) ON DELETE CASCADE;


--
-- Name: recipes recipes_menu_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_menu_item_id_fkey FOREIGN KEY (menu_item_id) REFERENCES public.menu_items(id);


--
-- Name: restaurant_tables restaurant_tables_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.restaurant_tables
    ADD CONSTRAINT restaurant_tables_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id) ON DELETE RESTRICT;


--
-- Name: role_permissions role_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- Name: role_permissions role_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: sales_returns sales_returns_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.sales_returns
    ADD CONSTRAINT sales_returns_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: sales_returns sales_returns_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.sales_returns
    ADD CONSTRAINT sales_returns_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE RESTRICT;


--
-- Name: sales_returns sales_returns_order_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.sales_returns
    ADD CONSTRAINT sales_returns_order_item_id_fkey FOREIGN KEY (order_item_id) REFERENCES public.order_items(id) ON DELETE RESTRICT;


--
-- Name: sales_returns sales_returns_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.sales_returns
    ADD CONSTRAINT sales_returns_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id) ON DELETE RESTRICT;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: stations stations_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id) ON DELETE CASCADE;


--
-- Name: sync_jobs sync_jobs_channel_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.sync_jobs
    ADD CONSTRAINT sync_jobs_channel_account_id_fkey FOREIGN KEY (channel_account_id) REFERENCES public.channel_accounts(id);


--
-- Name: sync_jobs sync_jobs_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.sync_jobs
    ADD CONSTRAINT sync_jobs_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: sync_state sync_state_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.sync_state
    ADD CONSTRAINT sync_state_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id) ON DELETE RESTRICT;


--
-- Name: table_merge_groups table_merge_groups_primary_table_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.table_merge_groups
    ADD CONSTRAINT table_merge_groups_primary_table_id_fkey FOREIGN KEY (primary_table_id) REFERENCES public.dining_tables(id);


--
-- Name: table_merge_members table_merge_members_dining_table_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.table_merge_members
    ADD CONSTRAINT table_merge_members_dining_table_id_fkey FOREIGN KEY (dining_table_id) REFERENCES public.dining_tables(id);


--
-- Name: table_merge_members table_merge_members_merge_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.table_merge_members
    ADD CONSTRAINT table_merge_members_merge_group_id_fkey FOREIGN KEY (merge_group_id) REFERENCES public.table_merge_groups(id) ON DELETE CASCADE;


--
-- Name: table_seats table_seats_dining_table_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.table_seats
    ADD CONSTRAINT table_seats_dining_table_id_fkey FOREIGN KEY (dining_table_id) REFERENCES public.dining_tables(id);


--
-- Name: table_sessions table_sessions_opened_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.table_sessions
    ADD CONSTRAINT table_sessions_opened_by_fkey FOREIGN KEY (opened_by) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: table_sessions table_sessions_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.table_sessions
    ADD CONSTRAINT table_sessions_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id) ON DELETE RESTRICT;


--
-- Name: table_sessions table_sessions_table_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.table_sessions
    ADD CONSTRAINT table_sessions_table_id_fkey FOREIGN KEY (table_id) REFERENCES public.restaurant_tables(id) ON DELETE CASCADE;


--
-- Name: tax_channel_rules tax_channel_rules_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.tax_channel_rules
    ADD CONSTRAINT tax_channel_rules_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id) ON DELETE RESTRICT;


--
-- Name: tax_channel_rules tax_channel_rules_tax_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.tax_channel_rules
    ADD CONSTRAINT tax_channel_rules_tax_id_fkey FOREIGN KEY (tax_id) REFERENCES public.taxes(id) ON DELETE RESTRICT;


--
-- Name: taxes taxes_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.taxes
    ADD CONSTRAINT taxes_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id) ON DELETE RESTRICT;


--
-- Name: terminals terminals_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.terminals
    ADD CONSTRAINT terminals_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: user_quick_links user_quick_links_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.user_quick_links
    ADD CONSTRAINT user_quick_links_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_report_preferences user_report_preferences_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.user_report_preferences
    ADD CONSTRAINT user_report_preferences_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_roles user_roles_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id) ON DELETE CASCADE;


--
-- Name: user_roles user_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: user_roles user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: waiter_shift_handovers waiter_shift_handovers_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.waiter_shift_handovers
    ADD CONSTRAINT waiter_shift_handovers_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- PostgreSQL database dump complete
--

\unrestrict dYaaekmSQylk4Y7bfWDcnwfXx0mzhJduemVAtV9dL7s7yHXHgk2e9gacpS6ZCdW

