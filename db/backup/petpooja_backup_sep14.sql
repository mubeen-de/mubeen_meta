--
-- PostgreSQL database dump
--

\restrict jLCaynpyTTZTei24jnhPfv09PWqtoS0mYiFMx4f993v6hQfpXJLwzRX4OqeaO8N

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

ALTER TABLE IF EXISTS ONLY public.waiter_shift_handovers DROP CONSTRAINT IF EXISTS waiter_shift_handovers_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.user_roles DROP CONSTRAINT IF EXISTS user_roles_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.user_roles DROP CONSTRAINT IF EXISTS user_roles_role_id_fkey;
ALTER TABLE IF EXISTS ONLY public.user_roles DROP CONSTRAINT IF EXISTS user_roles_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.user_report_preferences DROP CONSTRAINT IF EXISTS user_report_preferences_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.user_quick_links DROP CONSTRAINT IF EXISTS user_quick_links_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.terminals DROP CONSTRAINT IF EXISTS terminals_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.taxes DROP CONSTRAINT IF EXISTS taxes_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.tax_channel_rules DROP CONSTRAINT IF EXISTS tax_channel_rules_tax_id_fkey;
ALTER TABLE IF EXISTS ONLY public.tax_channel_rules DROP CONSTRAINT IF EXISTS tax_channel_rules_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.table_sessions DROP CONSTRAINT IF EXISTS table_sessions_table_id_fkey;
ALTER TABLE IF EXISTS ONLY public.table_sessions DROP CONSTRAINT IF EXISTS table_sessions_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.table_sessions DROP CONSTRAINT IF EXISTS table_sessions_opened_by_fkey;
ALTER TABLE IF EXISTS ONLY public.table_seats DROP CONSTRAINT IF EXISTS table_seats_dining_table_id_fkey;
ALTER TABLE IF EXISTS ONLY public.table_merge_members DROP CONSTRAINT IF EXISTS table_merge_members_merge_group_id_fkey;
ALTER TABLE IF EXISTS ONLY public.table_merge_members DROP CONSTRAINT IF EXISTS table_merge_members_dining_table_id_fkey;
ALTER TABLE IF EXISTS ONLY public.table_merge_groups DROP CONSTRAINT IF EXISTS table_merge_groups_primary_table_id_fkey;
ALTER TABLE IF EXISTS ONLY public.sync_state DROP CONSTRAINT IF EXISTS sync_state_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.sync_jobs DROP CONSTRAINT IF EXISTS sync_jobs_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.sync_jobs DROP CONSTRAINT IF EXISTS sync_jobs_channel_account_id_fkey;
ALTER TABLE IF EXISTS ONLY public.stations DROP CONSTRAINT IF EXISTS stations_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.sessions DROP CONSTRAINT IF EXISTS sessions_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.sales_returns DROP CONSTRAINT IF EXISTS sales_returns_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.sales_returns DROP CONSTRAINT IF EXISTS sales_returns_order_item_id_fkey;
ALTER TABLE IF EXISTS ONLY public.sales_returns DROP CONSTRAINT IF EXISTS sales_returns_order_id_fkey;
ALTER TABLE IF EXISTS ONLY public.sales_returns DROP CONSTRAINT IF EXISTS sales_returns_approved_by_fkey;
ALTER TABLE IF EXISTS ONLY public.role_permissions DROP CONSTRAINT IF EXISTS role_permissions_role_id_fkey;
ALTER TABLE IF EXISTS ONLY public.role_permissions DROP CONSTRAINT IF EXISTS role_permissions_permission_id_fkey;
ALTER TABLE IF EXISTS ONLY public.restaurant_tables DROP CONSTRAINT IF EXISTS restaurant_tables_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.recipes DROP CONSTRAINT IF EXISTS recipes_menu_item_id_fkey;
ALTER TABLE IF EXISTS ONLY public.recipe_ingredients DROP CONSTRAINT IF EXISTS recipe_ingredients_recipe_id_fkey;
ALTER TABLE IF EXISTS ONLY public.recipe_ingredients DROP CONSTRAINT IF EXISTS recipe_ingredients_ingredient_id_fkey;
ALTER TABLE IF EXISTS ONLY public.purchase_orders DROP CONSTRAINT IF EXISTS purchase_orders_vendor_id_fkey;
ALTER TABLE IF EXISTS ONLY public.purchase_order_items DROP CONSTRAINT IF EXISTS purchase_order_items_po_id_fkey;
ALTER TABLE IF EXISTS ONLY public.purchase_order_items DROP CONSTRAINT IF EXISTS purchase_order_items_ingredient_id_fkey;
ALTER TABLE IF EXISTS ONLY public.price_lists DROP CONSTRAINT IF EXISTS price_lists_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.physical_menu_files DROP CONSTRAINT IF EXISTS physical_menu_files_uploaded_by_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.physical_menu_files DROP CONSTRAINT IF EXISTS physical_menu_files_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.petty_cash_ledger DROP CONSTRAINT IF EXISTS petty_cash_ledger_cash_drawer_session_id_fkey;
ALTER TABLE IF EXISTS ONLY public.payments DROP CONSTRAINT IF EXISTS payments_seat_id_fkey;
ALTER TABLE IF EXISTS ONLY public.payments DROP CONSTRAINT IF EXISTS payments_order_seat_bill_id_fkey;
ALTER TABLE IF EXISTS ONLY public.payment_type_master DROP CONSTRAINT IF EXISTS payment_type_master_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.payment_summary DROP CONSTRAINT IF EXISTS payment_summary_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.outlets DROP CONSTRAINT IF EXISTS outlets_organization_id_fkey;
ALTER TABLE IF EXISTS ONLY public.outlet_print_settings DROP CONSTRAINT IF EXISTS outlet_print_settings_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.outlet_billing_settings DROP CONSTRAINT IF EXISTS outlet_billing_settings_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.outbound_events DROP CONSTRAINT IF EXISTS outbound_events_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.outbound_events DROP CONSTRAINT IF EXISTS outbound_events_channel_account_id_fkey;
ALTER TABLE IF EXISTS ONLY public.orders DROP CONSTRAINT IF EXISTS orders_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.order_status_history DROP CONSTRAINT IF EXISTS order_status_history_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.order_status_history DROP CONSTRAINT IF EXISTS order_status_history_order_id_fkey;
ALTER TABLE IF EXISTS ONLY public.order_seat_bills DROP CONSTRAINT IF EXISTS order_seat_bills_order_id_fkey;
ALTER TABLE IF EXISTS ONLY public.order_refunds DROP CONSTRAINT IF EXISTS order_refunds_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.order_refunds DROP CONSTRAINT IF EXISTS order_refunds_order_id_fkey;
ALTER TABLE IF EXISTS ONLY public.order_payments DROP CONSTRAINT IF EXISTS order_payments_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.order_payments DROP CONSTRAINT IF EXISTS order_payments_order_id_fkey;
ALTER TABLE IF EXISTS ONLY public.order_items DROP CONSTRAINT IF EXISTS order_items_variant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.order_items DROP CONSTRAINT IF EXISTS order_items_seat_id_fkey;
ALTER TABLE IF EXISTS ONLY public.order_items DROP CONSTRAINT IF EXISTS order_items_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.order_items DROP CONSTRAINT IF EXISTS order_items_order_id_fkey;
ALTER TABLE IF EXISTS ONLY public.order_items DROP CONSTRAINT IF EXISTS order_items_item_id_fkey;
ALTER TABLE IF EXISTS ONLY public.order_item_seat_shares DROP CONSTRAINT IF EXISTS order_item_seat_shares_order_item_id_fkey;
ALTER TABLE IF EXISTS ONLY public.order_item_modifiers DROP CONSTRAINT IF EXISTS order_item_modifiers_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.order_item_modifiers DROP CONSTRAINT IF EXISTS order_item_modifiers_order_item_id_fkey;
ALTER TABLE IF EXISTS ONLY public.order_item_modifiers DROP CONSTRAINT IF EXISTS order_item_modifiers_modifier_id_fkey;
ALTER TABLE IF EXISTS ONLY public.order_audit_log DROP CONSTRAINT IF EXISTS order_audit_log_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.order_audit_log DROP CONSTRAINT IF EXISTS order_audit_log_order_id_fkey;
ALTER TABLE IF EXISTS ONLY public.order_audit_log DROP CONSTRAINT IF EXISTS order_audit_log_approved_by_fkey;
ALTER TABLE IF EXISTS ONLY public.order_audit_log DROP CONSTRAINT IF EXISTS order_audit_log_actor_id_fkey;
ALTER TABLE IF EXISTS ONLY public.notifications DROP CONSTRAINT IF EXISTS notifications_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.notifications DROP CONSTRAINT IF EXISTS notifications_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.modifiers DROP CONSTRAINT IF EXISTS modifiers_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.modifiers DROP CONSTRAINT IF EXISTS modifiers_group_id_fkey;
ALTER TABLE IF EXISTS ONLY public.modifier_options DROP CONSTRAINT IF EXISTS modifier_options_modifier_group_id_fkey;
ALTER TABLE IF EXISTS ONLY public.modifier_groups DROP CONSTRAINT IF EXISTS modifier_groups_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.menu_items DROP CONSTRAINT IF EXISTS menu_items_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.menu_items DROP CONSTRAINT IF EXISTS menu_items_category_id_fkey;
ALTER TABLE IF EXISTS ONLY public.menu_item_channel_status DROP CONSTRAINT IF EXISTS menu_item_channel_status_updated_by_fkey;
ALTER TABLE IF EXISTS ONLY public.menu_item_channel_status DROP CONSTRAINT IF EXISTS menu_item_channel_status_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.menu_item_channel_status DROP CONSTRAINT IF EXISTS menu_item_channel_status_menu_item_id_fkey;
ALTER TABLE IF EXISTS ONLY public.menu_item_availability DROP CONSTRAINT IF EXISTS menu_item_availability_updated_by_fkey;
ALTER TABLE IF EXISTS ONLY public.menu_item_availability DROP CONSTRAINT IF EXISTS menu_item_availability_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.menu_item_availability DROP CONSTRAINT IF EXISTS menu_item_availability_menu_item_id_fkey;
ALTER TABLE IF EXISTS ONLY public.menu_categories DROP CONSTRAINT IF EXISTS menu_categories_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.marketing_campaigns DROP CONSTRAINT IF EXISTS marketing_campaigns_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.loyalty_accounts DROP CONSTRAINT IF EXISTS loyalty_accounts_customer_id_fkey;
ALTER TABLE IF EXISTS ONLY public.ledger_entries DROP CONSTRAINT IF EXISTS ledger_entries_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.kot_tickets DROP CONSTRAINT IF EXISTS kot_tickets_station_id_fkey;
ALTER TABLE IF EXISTS ONLY public.kot_tickets DROP CONSTRAINT IF EXISTS kot_tickets_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.kot_tickets DROP CONSTRAINT IF EXISTS kot_tickets_order_id_fkey;
ALTER TABLE IF EXISTS ONLY public.kot_status_history DROP CONSTRAINT IF EXISTS kot_status_history_kot_ticket_id_fkey;
ALTER TABLE IF EXISTS ONLY public.kot_performance DROP CONSTRAINT IF EXISTS kot_performance_station_id_fkey;
ALTER TABLE IF EXISTS ONLY public.kot_performance DROP CONSTRAINT IF EXISTS kot_performance_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.kot_items DROP CONSTRAINT IF EXISTS kot_items_seat_id_fkey;
ALTER TABLE IF EXISTS ONLY public.kot_items DROP CONSTRAINT IF EXISTS kot_items_menu_item_id_fkey;
ALTER TABLE IF EXISTS ONLY public.kot_items DROP CONSTRAINT IF EXISTS kot_items_kot_ticket_id_fkey;
ALTER TABLE IF EXISTS ONLY public.item_variants DROP CONSTRAINT IF EXISTS item_variants_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.item_variants DROP CONSTRAINT IF EXISTS item_variants_item_id_fkey;
ALTER TABLE IF EXISTS ONLY public.item_sales_summary DROP CONSTRAINT IF EXISTS item_sales_summary_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.item_sales_summary DROP CONSTRAINT IF EXISTS item_sales_summary_item_id_fkey;
ALTER TABLE IF EXISTS ONLY public.item_prices DROP CONSTRAINT IF EXISTS item_prices_variant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.item_prices DROP CONSTRAINT IF EXISTS item_prices_price_list_id_fkey;
ALTER TABLE IF EXISTS ONLY public.item_prices DROP CONSTRAINT IF EXISTS item_prices_item_id_fkey;
ALTER TABLE IF EXISTS ONLY public.item_modifier_groups DROP CONSTRAINT IF EXISTS item_modifier_groups_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.item_modifier_groups DROP CONSTRAINT IF EXISTS item_modifier_groups_item_id_fkey;
ALTER TABLE IF EXISTS ONLY public.item_modifier_groups DROP CONSTRAINT IF EXISTS item_modifier_groups_group_id_fkey;
ALTER TABLE IF EXISTS ONLY public.item_commissions DROP CONSTRAINT IF EXISTS item_commissions_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.item_commissions DROP CONSTRAINT IF EXISTS item_commissions_menu_item_id_fkey;
ALTER TABLE IF EXISTS ONLY public.item_availability DROP CONSTRAINT IF EXISTS item_availability_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.item_availability DROP CONSTRAINT IF EXISTS item_availability_item_id_fkey;
ALTER TABLE IF EXISTS ONLY public.item_availabilities DROP CONSTRAINT IF EXISTS item_availabilities_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.item_availabilities DROP CONSTRAINT IF EXISTS item_availabilities_menu_item_id_fkey;
ALTER TABLE IF EXISTS ONLY public.integration_errors DROP CONSTRAINT IF EXISTS integration_errors_source_event_id_fkey;
ALTER TABLE IF EXISTS ONLY public.integration_errors DROP CONSTRAINT IF EXISTS integration_errors_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.inbound_events DROP CONSTRAINT IF EXISTS inbound_events_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.inbound_events DROP CONSTRAINT IF EXISTS inbound_events_channel_account_id_fkey;
ALTER TABLE IF EXISTS ONLY public.hourly_sales_summary DROP CONSTRAINT IF EXISTS hourly_sales_summary_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.dining_tables DROP CONSTRAINT IF EXISTS dining_tables_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.daily_sales_summary DROP CONSTRAINT IF EXISTS daily_sales_summary_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.customers DROP CONSTRAINT IF EXISTS customers_organization_id_fkey;
ALTER TABLE IF EXISTS ONLY public.customer_tags DROP CONSTRAINT IF EXISTS customer_tags_customer_id_fkey;
ALTER TABLE IF EXISTS ONLY public.customer_addresses DROP CONSTRAINT IF EXISTS customer_addresses_customer_id_fkey;
ALTER TABLE IF EXISTS public.configuration_changes DROP CONSTRAINT IF EXISTS configuration_changes_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.channel_sync_log DROP CONSTRAINT IF EXISTS channel_sync_log_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.channel_sync_log DROP CONSTRAINT IF EXISTS channel_sync_log_order_id_fkey;
ALTER TABLE IF EXISTS ONLY public.channel_item_mapping DROP CONSTRAINT IF EXISTS channel_item_mapping_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.channel_item_mapping DROP CONSTRAINT IF EXISTS channel_item_mapping_item_id_fkey;
ALTER TABLE IF EXISTS ONLY public.channel_accounts DROP CONSTRAINT IF EXISTS channel_accounts_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.channel_accounts DROP CONSTRAINT IF EXISTS channel_accounts_integration_id_fkey;
ALTER TABLE IF EXISTS ONLY public.categories DROP CONSTRAINT IF EXISTS categories_parent_id_fkey;
ALTER TABLE IF EXISTS ONLY public.categories DROP CONSTRAINT IF EXISTS categories_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.campaign_recipients DROP CONSTRAINT IF EXISTS campaign_recipients_customer_id_fkey;
ALTER TABLE IF EXISTS ONLY public.campaign_recipients DROP CONSTRAINT IF EXISTS campaign_recipients_campaign_id_fkey;
ALTER TABLE IF EXISTS ONLY public.backup_jobs DROP CONSTRAINT IF EXISTS backup_jobs_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.availability_schedules DROP CONSTRAINT IF EXISTS availability_schedules_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.availability_schedules DROP CONSTRAINT IF EXISTS availability_schedules_item_id_fkey;
ALTER TABLE IF EXISTS ONLY public.availability_schedules DROP CONSTRAINT IF EXISTS availability_schedules_category_id_fkey;
ALTER TABLE IF EXISTS public.audit_logs DROP CONSTRAINT IF EXISTS audit_logs_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.addon_commissions DROP CONSTRAINT IF EXISTS addon_commissions_outlet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.addon_commissions DROP CONSTRAINT IF EXISTS addon_commissions_addon_item_id_fkey;
ALTER TABLE IF EXISTS public.access_logs DROP CONSTRAINT IF EXISTS access_logs_outlet_id_fkey;
DROP TRIGGER IF EXISTS trg_sync_orders_columns ON public.orders;
DROP TRIGGER IF EXISTS trg_sync_order_status_history ON public.order_status_history;
DROP TRIGGER IF EXISTS trg_sync_order_items_columns ON public.order_items;
DROP TRIGGER IF EXISTS trg_sync_invoice_fields ON public.invoices;
DROP TRIGGER IF EXISTS trg_sync_invoice_columns ON public.invoices;
DROP TRIGGER IF EXISTS trg_sync_audit_logs_columns ON public.audit_logs;
DROP TRIGGER IF EXISTS trg_order_status_guard ON public.orders;
DROP INDEX IF EXISTS public.ux_user_report_preferences_user_report;
DROP INDEX IF EXISTS public.ux_taxes_outlet_name;
DROP INDEX IF EXISTS public.ux_tax_channel_rules_tax_channel;
DROP INDEX IF EXISTS public.ux_sync_state_outlet_device;
DROP INDEX IF EXISTS public.ux_restaurant_tables_outlet_tableno;
DROP INDEX IF EXISTS public.ux_payment_type_master_outlet_label;
DROP INDEX IF EXISTS public.ux_outlet_print_settings_outlet;
DROP INDEX IF EXISTS public.ux_outlet_billing_settings_outlet;
DROP INDEX IF EXISTS public.ux_menu_item_channel_status_item_channel;
DROP INDEX IF EXISTS public.ux_menu_item_availability_item;
DROP INDEX IF EXISTS public.ux_menu_categories_outlet_name;
DROP INDEX IF EXISTS public.uq_users_email;
DROP INDEX IF EXISTS public.uq_user_roles;
DROP INDEX IF EXISTS public.uq_table_seats_outlet_table_seat;
DROP INDEX IF EXISTS public.uq_table_operation_idempotency_key;
DROP INDEX IF EXISTS public.uq_table_merge_members_active_table;
DROP INDEX IF EXISTS public.uq_table_merge_groups_active_primary;
DROP INDEX IF EXISTS public.uq_roles_name;
DROP INDEX IF EXISTS public.uq_roles_code;
DROP INDEX IF EXISTS public.uq_permissions_code;
DROP INDEX IF EXISTS public.uq_outlets_code;
DROP INDEX IF EXISTS public.uq_orders_outlet_number;
DROP INDEX IF EXISTS public.uq_order_seat_bills_outlet_order_seat;
DROP INDEX IF EXISTS public.uq_order_item_seat_shares_item_seat;
DROP INDEX IF EXISTS public.uq_item_prices_list_item_variant;
DROP INDEX IF EXISTS public.uq_item_availability_item_channel;
DROP INDEX IF EXISTS public.uq_invoices_order_seat;
DROP INDEX IF EXISTS public.uq_inbound_events_channel_external;
DROP INDEX IF EXISTS public.uq_customers_phone;
DROP INDEX IF EXISTS public.ix_user_report_preferences_user_id;
DROP INDEX IF EXISTS public.ix_taxes_outlet_id;
DROP INDEX IF EXISTS public.ix_taxes_is_active;
DROP INDEX IF EXISTS public.ix_tax_channel_rules_outlet_id;
DROP INDEX IF EXISTS public.ix_tax_channel_rules_channel;
DROP INDEX IF EXISTS public.ix_table_sessions_table_id;
DROP INDEX IF EXISTS public.ix_table_sessions_status;
DROP INDEX IF EXISTS public.ix_table_sessions_outlet_id;
DROP INDEX IF EXISTS public.ix_table_sessions_opened_at;
DROP INDEX IF EXISTS public.ix_sync_state_outlet_id;
DROP INDEX IF EXISTS public.ix_sync_state_is_online;
DROP INDEX IF EXISTS public.ix_sales_returns_returned_at;
DROP INDEX IF EXISTS public.ix_sales_returns_outlet_id;
DROP INDEX IF EXISTS public.ix_sales_returns_order_item_id;
DROP INDEX IF EXISTS public.ix_sales_returns_order_id;
DROP INDEX IF EXISTS public.ix_restaurant_tables_zone;
DROP INDEX IF EXISTS public.ix_restaurant_tables_outlet_id;
DROP INDEX IF EXISTS public.ix_payment_type_master_outlet_id;
DROP INDEX IF EXISTS public.ix_payment_type_master_is_active;
DROP INDEX IF EXISTS public.ix_order_audit_log_outlet_id;
DROP INDEX IF EXISTS public.ix_order_audit_log_order_id;
DROP INDEX IF EXISTS public.ix_order_audit_log_at;
DROP INDEX IF EXISTS public.ix_order_audit_log_actor_id;
DROP INDEX IF EXISTS public.ix_menu_item_channel_status_outlet_id;
DROP INDEX IF EXISTS public.ix_menu_item_channel_status_menu_item_id;
DROP INDEX IF EXISTS public.ix_menu_item_availability_outlet_id;
DROP INDEX IF EXISTS public.ix_menu_item_availability_is_oos;
DROP INDEX IF EXISTS public.ix_channel_sync_log_status;
DROP INDEX IF EXISTS public.ix_channel_sync_log_outlet_id;
DROP INDEX IF EXISTS public.ix_channel_sync_log_order_id;
DROP INDEX IF EXISTS public.ix_channel_sync_log_attempted_at;
DROP INDEX IF EXISTS public.ix_backup_jobs_status;
DROP INDEX IF EXISTS public.ix_backup_jobs_outlet_id;
DROP INDEX IF EXISTS public.ix_backup_jobs_created_at;
DROP INDEX IF EXISTS public.idx_waiter_shift_handovers_waiter;
DROP INDEX IF EXISTS public.idx_waiter_shift_handovers_outlet_date;
DROP INDEX IF EXISTS public.idx_vendors_outlet;
DROP INDEX IF EXISTS public.idx_user_roles_outlet;
DROP INDEX IF EXISTS public.idx_user_quick_links_user;
DROP INDEX IF EXISTS public.idx_table_seats_table;
DROP INDEX IF EXISTS public.idx_table_seats_outlet;
DROP INDEX IF EXISTS public.idx_table_merge_members_table;
DROP INDEX IF EXISTS public.idx_table_merge_members_outlet;
DROP INDEX IF EXISTS public.idx_table_merge_members_group;
DROP INDEX IF EXISTS public.idx_table_merge_groups_primary_table;
DROP INDEX IF EXISTS public.idx_table_merge_groups_outlet;
DROP INDEX IF EXISTS public.idx_sync_jobs_outlet;
DROP INDEX IF EXISTS public.idx_sync_jobs_channel_account;
DROP INDEX IF EXISTS public.idx_stations_outlet;
DROP INDEX IF EXISTS public.idx_special_notes_outlet;
DROP INDEX IF EXISTS public.idx_sessions_user;
DROP INDEX IF EXISTS public.idx_recipes_outlet;
DROP INDEX IF EXISTS public.idx_recipes_menu_item;
DROP INDEX IF EXISTS public.idx_recipe_ingredients_recipe;
DROP INDEX IF EXISTS public.idx_recipe_ingredients_ingredient;
DROP INDEX IF EXISTS public.idx_purchase_orders_vendor;
DROP INDEX IF EXISTS public.idx_purchase_orders_outlet;
DROP INDEX IF EXISTS public.idx_purchase_order_items_po;
DROP INDEX IF EXISTS public.idx_price_lists_outlet;
DROP INDEX IF EXISTS public.idx_physical_menu_files_outlet;
DROP INDEX IF EXISTS public.idx_petty_cash_ledger_session;
DROP INDEX IF EXISTS public.idx_petty_cash_ledger_outlet;
DROP INDEX IF EXISTS public.idx_payments_seat;
DROP INDEX IF EXISTS public.idx_payments_order_seat_bill;
DROP INDEX IF EXISTS public.idx_payment_summary_outlet;
DROP INDEX IF EXISTS public.idx_outlets_org;
DROP INDEX IF EXISTS public.idx_outbox_pending;
DROP INDEX IF EXISTS public.idx_outbound_events_outlet;
DROP INDEX IF EXISTS public.idx_outbound_events_channel_account;
DROP INDEX IF EXISTS public.idx_orders_scheduled_fire_at;
DROP INDEX IF EXISTS public.idx_orders_outlet_status_date;
DROP INDEX IF EXISTS public.idx_orders_outlet;
DROP INDEX IF EXISTS public.idx_orders_merged_into;
DROP INDEX IF EXISTS public.idx_orders_merge_group;
DROP INDEX IF EXISTS public.idx_orders_external_order_id;
DROP INDEX IF EXISTS public.idx_orders_customer;
DROP INDEX IF EXISTS public.idx_orders_channel;
DROP INDEX IF EXISTS public.idx_order_status_history_outlet;
DROP INDEX IF EXISTS public.idx_order_status_history_order;
DROP INDEX IF EXISTS public.idx_order_seat_bills_outlet;
DROP INDEX IF EXISTS public.idx_order_seat_bills_order;
DROP INDEX IF EXISTS public.idx_order_refunds_outlet;
DROP INDEX IF EXISTS public.idx_order_refunds_order;
DROP INDEX IF EXISTS public.idx_order_payments_outlet;
DROP INDEX IF EXISTS public.idx_order_payments_order;
DROP INDEX IF EXISTS public.idx_order_items_variant;
DROP INDEX IF EXISTS public.idx_order_items_split_group;
DROP INDEX IF EXISTS public.idx_order_items_seat;
DROP INDEX IF EXISTS public.idx_order_items_outlet;
DROP INDEX IF EXISTS public.idx_order_items_order;
DROP INDEX IF EXISTS public.idx_order_items_item;
DROP INDEX IF EXISTS public.idx_order_item_seat_shares_outlet;
DROP INDEX IF EXISTS public.idx_order_item_seat_shares_order_item;
DROP INDEX IF EXISTS public.idx_order_item_modifiers_outlet;
DROP INDEX IF EXISTS public.idx_order_item_modifiers_order_item;
DROP INDEX IF EXISTS public.idx_order_item_modifiers_modifier;
DROP INDEX IF EXISTS public.idx_notifications_user;
DROP INDEX IF EXISTS public.idx_notifications_outlet;
DROP INDEX IF EXISTS public.idx_modifiers_outlet;
DROP INDEX IF EXISTS public.idx_modifiers_group;
DROP INDEX IF EXISTS public.idx_modifier_options_outlet;
DROP INDEX IF EXISTS public.idx_modifier_options_group;
DROP INDEX IF EXISTS public.idx_modifier_groups_outlet;
DROP INDEX IF EXISTS public.idx_menu_items_outlet;
DROP INDEX IF EXISTS public.idx_menu_items_category;
DROP INDEX IF EXISTS public.idx_marketing_campaigns_outlet;
DROP INDEX IF EXISTS public.idx_loyalty_accounts_customer;
DROP INDEX IF EXISTS public.idx_ledger_entries_outlet;
DROP INDEX IF EXISTS public.idx_ledger_entries_account;
DROP INDEX IF EXISTS public.idx_kot_tickets_station_open;
DROP INDEX IF EXISTS public.idx_kot_tickets_station;
DROP INDEX IF EXISTS public.idx_kot_tickets_outlet;
DROP INDEX IF EXISTS public.idx_kot_tickets_order;
DROP INDEX IF EXISTS public.idx_kot_status_history_ticket;
DROP INDEX IF EXISTS public.idx_kot_performance_station;
DROP INDEX IF EXISTS public.idx_kot_performance_outlet;
DROP INDEX IF EXISTS public.idx_kot_items_ticket;
DROP INDEX IF EXISTS public.idx_kot_items_seat;
DROP INDEX IF EXISTS public.idx_kot_items_outlet;
DROP INDEX IF EXISTS public.idx_kot_items_menu_item;
DROP INDEX IF EXISTS public.idx_item_variants_outlet;
DROP INDEX IF EXISTS public.idx_item_variants_item;
DROP INDEX IF EXISTS public.idx_item_sales_summary_outlet;
DROP INDEX IF EXISTS public.idx_item_sales_summary_item;
DROP INDEX IF EXISTS public.idx_item_prices_price_list;
DROP INDEX IF EXISTS public.idx_item_prices_item;
DROP INDEX IF EXISTS public.idx_item_modifier_groups_outlet;
DROP INDEX IF EXISTS public.idx_item_modifier_groups_item;
DROP INDEX IF EXISTS public.idx_item_modifier_groups_group;
DROP INDEX IF EXISTS public.idx_item_commissions_outlet;
DROP INDEX IF EXISTS public.idx_item_commissions_menu_item;
DROP INDEX IF EXISTS public.idx_item_availability_outlet;
DROP INDEX IF EXISTS public.idx_item_availability_item_channel;
DROP INDEX IF EXISTS public.idx_item_availability_item;
DROP INDEX IF EXISTS public.idx_invoices_outlet;
DROP INDEX IF EXISTS public.idx_invoices_created;
DROP INDEX IF EXISTS public.idx_integration_errors_source_event;
DROP INDEX IF EXISTS public.idx_integration_errors_outlet;
DROP INDEX IF EXISTS public.idx_ingredients_outlet;
DROP INDEX IF EXISTS public.idx_inbound_events_outlet;
DROP INDEX IF EXISTS public.idx_inbound_events_channel_account;
DROP INDEX IF EXISTS public.idx_hourly_sales_summary_outlet;
DROP INDEX IF EXISTS public.idx_dining_tables_merge_primary;
DROP INDEX IF EXISTS public.idx_dining_tables_merge_group;
DROP INDEX IF EXISTS public.idx_daily_sales_summary_outlet;
DROP INDEX IF EXISTS public.idx_customers_organization;
DROP INDEX IF EXISTS public.idx_customer_tags_customer;
DROP INDEX IF EXISTS public.idx_customer_addresses_customer;
DROP INDEX IF EXISTS public.idx_consumption_log_outlet;
DROP INDEX IF EXISTS public.idx_consumption_log_order;
DROP INDEX IF EXISTS public.idx_channel_item_mapping_outlet_channel;
DROP INDEX IF EXISTS public.idx_channel_item_mapping_outlet;
DROP INDEX IF EXISTS public.idx_channel_item_mapping_item;
DROP INDEX IF EXISTS public.idx_channel_item_mapping_account;
DROP INDEX IF EXISTS public.idx_channel_accounts_outlet;
DROP INDEX IF EXISTS public.idx_channel_accounts_integration;
DROP INDEX IF EXISTS public.idx_categories_parent;
DROP INDEX IF EXISTS public.idx_categories_outlet;
DROP INDEX IF EXISTS public.idx_cash_drawer_sessions_status;
DROP INDEX IF EXISTS public.idx_cash_drawer_sessions_outlet;
DROP INDEX IF EXISTS public.idx_campaign_recipients_campaign;
DROP INDEX IF EXISTS public.idx_availability_schedules_outlet;
DROP INDEX IF EXISTS public.idx_availability_schedules_item;
DROP INDEX IF EXISTS public.idx_availability_schedules_category;
DROP INDEX IF EXISTS public.idx_areas_outlet;
DROP INDEX IF EXISTS public.idx_addon_commissions_outlet;
DROP INDEX IF EXISTS public.idx_addon_commissions_addon_item;
DROP INDEX IF EXISTS public.idx_configuration_changes_outlet;
DROP INDEX IF EXISTS public.idx_audit_logs_outlet_entity;
DROP INDEX IF EXISTS public.idx_access_logs_outlet;
ALTER TABLE IF EXISTS ONLY public.waiter_shift_handovers DROP CONSTRAINT IF EXISTS waiter_shift_handovers_pkey;
ALTER TABLE IF EXISTS ONLY public.vendors DROP CONSTRAINT IF EXISTS vendors_pkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.user_report_preferences DROP CONSTRAINT IF EXISTS user_report_preferences_pkey;
ALTER TABLE IF EXISTS ONLY public.user_quick_links DROP CONSTRAINT IF EXISTS user_quick_links_pkey;
ALTER TABLE IF EXISTS ONLY public.terminals DROP CONSTRAINT IF EXISTS terminals_pkey;
ALTER TABLE IF EXISTS ONLY public.terminals DROP CONSTRAINT IF EXISTS terminals_outlet_id_terminal_number_key;
ALTER TABLE IF EXISTS ONLY public.taxes DROP CONSTRAINT IF EXISTS taxes_pkey;
ALTER TABLE IF EXISTS ONLY public.tax_channel_rules DROP CONSTRAINT IF EXISTS tax_channel_rules_pkey;
ALTER TABLE IF EXISTS ONLY public.table_sessions DROP CONSTRAINT IF EXISTS table_sessions_pkey;
ALTER TABLE IF EXISTS ONLY public.table_seats DROP CONSTRAINT IF EXISTS table_seats_pkey;
ALTER TABLE IF EXISTS ONLY public.table_operation_idempotency DROP CONSTRAINT IF EXISTS table_operation_idempotency_pkey;
ALTER TABLE IF EXISTS ONLY public.table_merge_members DROP CONSTRAINT IF EXISTS table_merge_members_pkey;
ALTER TABLE IF EXISTS ONLY public.table_merge_groups DROP CONSTRAINT IF EXISTS table_merge_groups_pkey;
ALTER TABLE IF EXISTS ONLY public.sync_state DROP CONSTRAINT IF EXISTS sync_state_pkey;
ALTER TABLE IF EXISTS ONLY public.sync_jobs DROP CONSTRAINT IF EXISTS sync_jobs_pkey;
ALTER TABLE IF EXISTS ONLY public.stations DROP CONSTRAINT IF EXISTS stations_pkey;
ALTER TABLE IF EXISTS ONLY public.special_notes DROP CONSTRAINT IF EXISTS special_notes_pkey;
ALTER TABLE IF EXISTS ONLY public.sessions DROP CONSTRAINT IF EXISTS sessions_pkey;
ALTER TABLE IF EXISTS ONLY public.schema_migrations DROP CONSTRAINT IF EXISTS schema_migrations_pkey;
ALTER TABLE IF EXISTS ONLY public.sales_returns DROP CONSTRAINT IF EXISTS sales_returns_pkey;
ALTER TABLE IF EXISTS ONLY public.roles DROP CONSTRAINT IF EXISTS roles_pkey;
ALTER TABLE IF EXISTS ONLY public.roles DROP CONSTRAINT IF EXISTS roles_code_key;
ALTER TABLE IF EXISTS ONLY public.role_permissions DROP CONSTRAINT IF EXISTS role_permissions_pkey;
ALTER TABLE IF EXISTS ONLY public.restaurant_tables DROP CONSTRAINT IF EXISTS restaurant_tables_pkey;
ALTER TABLE IF EXISTS ONLY public.recipes DROP CONSTRAINT IF EXISTS recipes_pkey;
ALTER TABLE IF EXISTS ONLY public.recipe_ingredients DROP CONSTRAINT IF EXISTS recipe_ingredients_pkey;
ALTER TABLE IF EXISTS ONLY public.purchase_orders DROP CONSTRAINT IF EXISTS purchase_orders_pkey;
ALTER TABLE IF EXISTS ONLY public.purchase_orders DROP CONSTRAINT IF EXISTS purchase_orders_outlet_id_po_number_key;
ALTER TABLE IF EXISTS ONLY public.purchase_order_items DROP CONSTRAINT IF EXISTS purchase_order_items_pkey;
ALTER TABLE IF EXISTS ONLY public.price_lists DROP CONSTRAINT IF EXISTS price_lists_pkey;
ALTER TABLE IF EXISTS ONLY public.user_roles DROP CONSTRAINT IF EXISTS pk_user_roles;
ALTER TABLE IF EXISTS ONLY public.physical_menu_files DROP CONSTRAINT IF EXISTS physical_menu_files_pkey;
ALTER TABLE IF EXISTS ONLY public.petty_cash_ledger DROP CONSTRAINT IF EXISTS petty_cash_ledger_pkey;
ALTER TABLE IF EXISTS ONLY public.permissions DROP CONSTRAINT IF EXISTS permissions_pkey;
ALTER TABLE IF EXISTS ONLY public.permissions DROP CONSTRAINT IF EXISTS permissions_code_key;
ALTER TABLE IF EXISTS ONLY public.payments DROP CONSTRAINT IF EXISTS payments_pkey;
ALTER TABLE IF EXISTS ONLY public.payments DROP CONSTRAINT IF EXISTS payments_idempotency_key_unique;
ALTER TABLE IF EXISTS ONLY public.payment_type_master DROP CONSTRAINT IF EXISTS payment_type_master_pkey;
ALTER TABLE IF EXISTS ONLY public.payment_summary DROP CONSTRAINT IF EXISTS payment_summary_pkey;
ALTER TABLE IF EXISTS ONLY public.payment_summary DROP CONSTRAINT IF EXISTS payment_summary_outlet_id_business_date_method_key;
ALTER TABLE IF EXISTS ONLY public.outlets DROP CONSTRAINT IF EXISTS outlets_pkey;
ALTER TABLE IF EXISTS ONLY public.outlets DROP CONSTRAINT IF EXISTS outlets_organization_id_code_key;
ALTER TABLE IF EXISTS ONLY public.outlet_status DROP CONSTRAINT IF EXISTS outlet_status_pkey;
ALTER TABLE IF EXISTS ONLY public.outlet_print_settings DROP CONSTRAINT IF EXISTS outlet_print_settings_pkey;
ALTER TABLE IF EXISTS ONLY public.outlet_billing_settings DROP CONSTRAINT IF EXISTS outlet_billing_settings_pkey;
ALTER TABLE IF EXISTS ONLY public.outbox_events DROP CONSTRAINT IF EXISTS outbox_events_pkey;
ALTER TABLE IF EXISTS ONLY public.outbound_events DROP CONSTRAINT IF EXISTS outbound_events_pkey;
ALTER TABLE IF EXISTS ONLY public.organizations DROP CONSTRAINT IF EXISTS organizations_pkey;
ALTER TABLE IF EXISTS ONLY public.orders DROP CONSTRAINT IF EXISTS orders_pkey;
ALTER TABLE IF EXISTS ONLY public.order_status_history DROP CONSTRAINT IF EXISTS order_status_history_pkey;
ALTER TABLE IF EXISTS ONLY public.order_seat_bills DROP CONSTRAINT IF EXISTS order_seat_bills_pkey;
ALTER TABLE IF EXISTS ONLY public.order_refunds DROP CONSTRAINT IF EXISTS order_refunds_pkey;
ALTER TABLE IF EXISTS ONLY public.order_payments DROP CONSTRAINT IF EXISTS order_payments_pkey;
ALTER TABLE IF EXISTS ONLY public.order_items DROP CONSTRAINT IF EXISTS order_items_pkey;
ALTER TABLE IF EXISTS ONLY public.order_item_seat_shares DROP CONSTRAINT IF EXISTS order_item_seat_shares_pkey;
ALTER TABLE IF EXISTS ONLY public.order_item_modifiers DROP CONSTRAINT IF EXISTS order_item_modifiers_pkey;
ALTER TABLE IF EXISTS ONLY public.order_audit_log DROP CONSTRAINT IF EXISTS order_audit_log_pkey;
ALTER TABLE IF EXISTS ONLY public.notifications DROP CONSTRAINT IF EXISTS notifications_pkey;
ALTER TABLE IF EXISTS ONLY public.modifiers DROP CONSTRAINT IF EXISTS modifiers_pkey;
ALTER TABLE IF EXISTS ONLY public.modifier_options DROP CONSTRAINT IF EXISTS modifier_options_pkey;
ALTER TABLE IF EXISTS ONLY public.modifier_groups DROP CONSTRAINT IF EXISTS modifier_groups_pkey;
ALTER TABLE IF EXISTS ONLY public.menu_items DROP CONSTRAINT IF EXISTS menu_items_pkey;
ALTER TABLE IF EXISTS ONLY public.menu_item_channel_status DROP CONSTRAINT IF EXISTS menu_item_channel_status_pkey;
ALTER TABLE IF EXISTS ONLY public.menu_item_availability DROP CONSTRAINT IF EXISTS menu_item_availability_pkey;
ALTER TABLE IF EXISTS ONLY public.menu_categories DROP CONSTRAINT IF EXISTS menu_categories_pkey;
ALTER TABLE IF EXISTS ONLY public.marketing_campaigns DROP CONSTRAINT IF EXISTS marketing_campaigns_pkey;
ALTER TABLE IF EXISTS ONLY public.loyalty_accounts DROP CONSTRAINT IF EXISTS loyalty_accounts_pkey;
ALTER TABLE IF EXISTS ONLY public.loyalty_accounts DROP CONSTRAINT IF EXISTS loyalty_accounts_customer_id_key;
ALTER TABLE IF EXISTS ONLY public.ledger_entries DROP CONSTRAINT IF EXISTS ledger_entries_pkey;
ALTER TABLE IF EXISTS ONLY public.kot_tickets DROP CONSTRAINT IF EXISTS kot_tickets_pkey;
ALTER TABLE IF EXISTS ONLY public.kot_status_history DROP CONSTRAINT IF EXISTS kot_status_history_pkey;
ALTER TABLE IF EXISTS ONLY public.kot_performance DROP CONSTRAINT IF EXISTS kot_performance_pkey;
ALTER TABLE IF EXISTS ONLY public.kot_performance DROP CONSTRAINT IF EXISTS kot_performance_outlet_id_business_date_station_id_key;
ALTER TABLE IF EXISTS ONLY public.kot_items DROP CONSTRAINT IF EXISTS kot_items_pkey;
ALTER TABLE IF EXISTS ONLY public.item_variants DROP CONSTRAINT IF EXISTS item_variants_pkey;
ALTER TABLE IF EXISTS ONLY public.item_sales_summary DROP CONSTRAINT IF EXISTS item_sales_summary_pkey;
ALTER TABLE IF EXISTS ONLY public.item_sales_summary DROP CONSTRAINT IF EXISTS item_sales_summary_outlet_id_business_date_item_id_key;
ALTER TABLE IF EXISTS ONLY public.item_prices DROP CONSTRAINT IF EXISTS item_prices_pkey;
ALTER TABLE IF EXISTS ONLY public.item_modifier_groups DROP CONSTRAINT IF EXISTS item_modifier_groups_pkey;
ALTER TABLE IF EXISTS ONLY public.item_modifier_groups DROP CONSTRAINT IF EXISTS item_modifier_groups_item_id_group_id_key;
ALTER TABLE IF EXISTS ONLY public.item_commissions DROP CONSTRAINT IF EXISTS item_commissions_pkey;
ALTER TABLE IF EXISTS ONLY public.item_commissions DROP CONSTRAINT IF EXISTS item_commissions_outlet_id_menu_item_id_key;
ALTER TABLE IF EXISTS ONLY public.item_availability DROP CONSTRAINT IF EXISTS item_availability_pkey;
ALTER TABLE IF EXISTS ONLY public.item_availabilities DROP CONSTRAINT IF EXISTS item_availabilities_pkey;
ALTER TABLE IF EXISTS ONLY public.item_availabilities DROP CONSTRAINT IF EXISTS item_availabilities_outlet_id_menu_item_id_key;
ALTER TABLE IF EXISTS ONLY public.invoices DROP CONSTRAINT IF EXISTS invoices_pkey;
ALTER TABLE IF EXISTS ONLY public.invoices DROP CONSTRAINT IF EXISTS invoices_outlet_id_invoice_number_key;
ALTER TABLE IF EXISTS ONLY public.inventory_consumption_log DROP CONSTRAINT IF EXISTS inventory_consumption_log_pkey;
ALTER TABLE IF EXISTS ONLY public.inventory_consumption_log DROP CONSTRAINT IF EXISTS inventory_consumption_log_order_item_id_ingredient_id_recip_key;
ALTER TABLE IF EXISTS ONLY public.integrations DROP CONSTRAINT IF EXISTS integrations_pkey;
ALTER TABLE IF EXISTS ONLY public.integrations DROP CONSTRAINT IF EXISTS integrations_code_key;
ALTER TABLE IF EXISTS ONLY public.integration_errors DROP CONSTRAINT IF EXISTS integration_errors_pkey;
ALTER TABLE IF EXISTS ONLY public.ingredients DROP CONSTRAINT IF EXISTS ingredients_pkey;
ALTER TABLE IF EXISTS ONLY public.inbound_events DROP CONSTRAINT IF EXISTS inbound_events_pkey;
ALTER TABLE IF EXISTS ONLY public.hourly_sales_summary DROP CONSTRAINT IF EXISTS hourly_sales_summary_pkey;
ALTER TABLE IF EXISTS ONLY public.hourly_sales_summary DROP CONSTRAINT IF EXISTS hourly_sales_summary_outlet_id_business_date_hour_key;
ALTER TABLE IF EXISTS ONLY public.dining_tables DROP CONSTRAINT IF EXISTS dining_tables_pkey;
ALTER TABLE IF EXISTS ONLY public.dining_tables DROP CONSTRAINT IF EXISTS dining_tables_outlet_id_table_number_key;
ALTER TABLE IF EXISTS ONLY public.daily_sales_summary DROP CONSTRAINT IF EXISTS daily_sales_summary_pkey;
ALTER TABLE IF EXISTS ONLY public.daily_sales_summary DROP CONSTRAINT IF EXISTS daily_sales_summary_outlet_id_business_date_key;
ALTER TABLE IF EXISTS ONLY public.customers DROP CONSTRAINT IF EXISTS customers_pkey;
ALTER TABLE IF EXISTS ONLY public.customers DROP CONSTRAINT IF EXISTS customers_organization_id_phone_key;
ALTER TABLE IF EXISTS ONLY public.customer_tags DROP CONSTRAINT IF EXISTS customer_tags_pkey;
ALTER TABLE IF EXISTS ONLY public.customer_tags DROP CONSTRAINT IF EXISTS customer_tags_customer_id_tag_key;
ALTER TABLE IF EXISTS ONLY public.customer_addresses DROP CONSTRAINT IF EXISTS customer_addresses_pkey;
ALTER TABLE IF EXISTS ONLY public.configuration_changes_y2026m08 DROP CONSTRAINT IF EXISTS configuration_changes_y2026m08_pkey;
ALTER TABLE IF EXISTS ONLY public.configuration_changes_default DROP CONSTRAINT IF EXISTS configuration_changes_default_pkey;
ALTER TABLE IF EXISTS ONLY public.configuration_changes DROP CONSTRAINT IF EXISTS configuration_changes_pkey;
ALTER TABLE IF EXISTS ONLY public.channel_sync_log DROP CONSTRAINT IF EXISTS channel_sync_log_pkey;
ALTER TABLE IF EXISTS ONLY public.channel_item_mapping DROP CONSTRAINT IF EXISTS channel_item_mapping_pkey;
ALTER TABLE IF EXISTS ONLY public.channel_item_mapping DROP CONSTRAINT IF EXISTS channel_item_mapping_channel_account_id_external_item_id_key;
ALTER TABLE IF EXISTS ONLY public.channel_accounts DROP CONSTRAINT IF EXISTS channel_accounts_pkey;
ALTER TABLE IF EXISTS ONLY public.categories DROP CONSTRAINT IF EXISTS categories_pkey;
ALTER TABLE IF EXISTS ONLY public.cash_drawer_sessions DROP CONSTRAINT IF EXISTS cash_drawer_sessions_pkey;
ALTER TABLE IF EXISTS ONLY public.campaign_recipients DROP CONSTRAINT IF EXISTS campaign_recipients_pkey;
ALTER TABLE IF EXISTS ONLY public.backup_jobs DROP CONSTRAINT IF EXISTS backup_jobs_pkey;
ALTER TABLE IF EXISTS ONLY public.availability_schedules DROP CONSTRAINT IF EXISTS availability_schedules_pkey;
ALTER TABLE IF EXISTS ONLY public.audit_logs_y2026m08 DROP CONSTRAINT IF EXISTS audit_logs_y2026m08_pkey;
ALTER TABLE IF EXISTS ONLY public.audit_logs_default DROP CONSTRAINT IF EXISTS audit_logs_default_pkey;
ALTER TABLE IF EXISTS ONLY public.audit_logs DROP CONSTRAINT IF EXISTS audit_logs_pkey;
ALTER TABLE IF EXISTS ONLY public.areas DROP CONSTRAINT IF EXISTS areas_pkey;
ALTER TABLE IF EXISTS ONLY public.areas DROP CONSTRAINT IF EXISTS areas_outlet_id_name_key;
ALTER TABLE IF EXISTS ONLY public.agent_telemetry DROP CONSTRAINT IF EXISTS agent_telemetry_pkey;
ALTER TABLE IF EXISTS ONLY public.addon_commissions DROP CONSTRAINT IF EXISTS addon_commissions_pkey;
ALTER TABLE IF EXISTS ONLY public.addon_commissions DROP CONSTRAINT IF EXISTS addon_commissions_outlet_id_addon_item_id_key;
ALTER TABLE IF EXISTS ONLY public.access_logs_y2026m08 DROP CONSTRAINT IF EXISTS access_logs_y2026m08_pkey;
ALTER TABLE IF EXISTS ONLY public.access_logs_default DROP CONSTRAINT IF EXISTS access_logs_default_pkey;
ALTER TABLE IF EXISTS ONLY public.access_logs DROP CONSTRAINT IF EXISTS access_logs_pkey;
ALTER TABLE IF EXISTS public.order_audit_log ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.channel_sync_log ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.backup_jobs ALTER COLUMN id DROP DEFAULT;
DROP TABLE IF EXISTS public.waiter_shift_handovers;
DROP TABLE IF EXISTS public.vendors;
DROP TABLE IF EXISTS public.users;
DROP TABLE IF EXISTS public.user_roles;
DROP TABLE IF EXISTS public.user_report_preferences;
DROP TABLE IF EXISTS public.user_quick_links;
DROP TABLE IF EXISTS public.terminals;
DROP TABLE IF EXISTS public.taxes;
DROP TABLE IF EXISTS public.tax_channel_rules;
DROP TABLE IF EXISTS public.table_sessions;
DROP TABLE IF EXISTS public.table_seats;
DROP TABLE IF EXISTS public.table_operation_idempotency;
DROP TABLE IF EXISTS public.table_merge_members;
DROP TABLE IF EXISTS public.table_merge_groups;
DROP TABLE IF EXISTS public.sync_state;
DROP TABLE IF EXISTS public.sync_jobs;
DROP TABLE IF EXISTS public.stations;
DROP TABLE IF EXISTS public.special_notes;
DROP TABLE IF EXISTS public.sessions;
DROP TABLE IF EXISTS public.schema_migrations;
DROP TABLE IF EXISTS public.sales_returns;
DROP TABLE IF EXISTS public.roles;
DROP TABLE IF EXISTS public.role_permissions;
DROP TABLE IF EXISTS public.restaurant_tables;
DROP TABLE IF EXISTS public.recipes;
DROP TABLE IF EXISTS public.recipe_ingredients;
DROP TABLE IF EXISTS public.purchase_orders;
DROP TABLE IF EXISTS public.purchase_order_items;
DROP TABLE IF EXISTS public.price_lists;
DROP TABLE IF EXISTS public.physical_menu_files;
DROP TABLE IF EXISTS public.petty_cash_ledger;
DROP TABLE IF EXISTS public.permissions;
DROP TABLE IF EXISTS public.payments;
DROP TABLE IF EXISTS public.payment_type_master;
DROP TABLE IF EXISTS public.payment_summary;
DROP TABLE IF EXISTS public.outlets;
DROP TABLE IF EXISTS public.outlet_status;
DROP TABLE IF EXISTS public.outlet_print_settings;
DROP TABLE IF EXISTS public.outlet_billing_settings;
DROP TABLE IF EXISTS public.outbox_events;
DROP TABLE IF EXISTS public.outbound_events;
DROP TABLE IF EXISTS public.organizations;
DROP TABLE IF EXISTS public.orders;
DROP TABLE IF EXISTS public.order_status_history;
DROP TABLE IF EXISTS public.order_seat_bills;
DROP TABLE IF EXISTS public.order_refunds;
DROP TABLE IF EXISTS public.order_payments;
DROP TABLE IF EXISTS public.order_items;
DROP TABLE IF EXISTS public.order_item_seat_shares;
DROP TABLE IF EXISTS public.order_item_modifiers;
DROP SEQUENCE IF EXISTS public.order_audit_log_id_seq;
DROP TABLE IF EXISTS public.order_audit_log;
DROP TABLE IF EXISTS public.notifications;
DROP TABLE IF EXISTS public.modifiers;
DROP TABLE IF EXISTS public.modifier_options;
DROP TABLE IF EXISTS public.modifier_groups;
DROP TABLE IF EXISTS public.menu_items;
DROP TABLE IF EXISTS public.menu_item_channel_status;
DROP TABLE IF EXISTS public.menu_item_availability;
DROP TABLE IF EXISTS public.menu_categories;
DROP TABLE IF EXISTS public.marketing_campaigns;
DROP TABLE IF EXISTS public.loyalty_accounts;
DROP TABLE IF EXISTS public.ledger_entries;
DROP TABLE IF EXISTS public.kot_tickets;
DROP TABLE IF EXISTS public.kot_status_history;
DROP TABLE IF EXISTS public.kot_performance;
DROP TABLE IF EXISTS public.kot_items;
DROP TABLE IF EXISTS public.item_variants;
DROP TABLE IF EXISTS public.item_sales_summary;
DROP TABLE IF EXISTS public.item_prices;
DROP TABLE IF EXISTS public.item_modifier_groups;
DROP TABLE IF EXISTS public.item_commissions;
DROP TABLE IF EXISTS public.item_availability;
DROP TABLE IF EXISTS public.item_availabilities;
DROP TABLE IF EXISTS public.invoices;
DROP TABLE IF EXISTS public.inventory_consumption_log;
DROP TABLE IF EXISTS public.integrations;
DROP TABLE IF EXISTS public.integration_errors;
DROP TABLE IF EXISTS public.ingredients;
DROP TABLE IF EXISTS public.inbound_events;
DROP TABLE IF EXISTS public.hourly_sales_summary;
DROP TABLE IF EXISTS public.dining_tables;
DROP TABLE IF EXISTS public.daily_sales_summary;
DROP TABLE IF EXISTS public.customers;
DROP TABLE IF EXISTS public.customer_tags;
DROP TABLE IF EXISTS public.customer_addresses;
DROP TABLE IF EXISTS public.configuration_changes_y2026m08;
DROP TABLE IF EXISTS public.configuration_changes_default;
DROP TABLE IF EXISTS public.configuration_changes;
DROP SEQUENCE IF EXISTS public.channel_sync_log_id_seq;
DROP TABLE IF EXISTS public.channel_sync_log;
DROP TABLE IF EXISTS public.channel_item_mapping;
DROP TABLE IF EXISTS public.channel_accounts;
DROP TABLE IF EXISTS public.categories;
DROP TABLE IF EXISTS public.cash_drawer_sessions;
DROP TABLE IF EXISTS public.campaign_recipients;
DROP SEQUENCE IF EXISTS public.backup_jobs_id_seq;
DROP TABLE IF EXISTS public.backup_jobs;
DROP TABLE IF EXISTS public.availability_schedules;
DROP TABLE IF EXISTS public.audit_logs_y2026m08;
DROP TABLE IF EXISTS public.audit_logs_default;
DROP TABLE IF EXISTS public.audit_logs;
DROP TABLE IF EXISTS public.areas;
DROP TABLE IF EXISTS public.agent_telemetry;
DROP TABLE IF EXISTS public.addon_commissions;
DROP TABLE IF EXISTS public.access_logs_y2026m08;
DROP TABLE IF EXISTS public.access_logs_default;
DROP TABLE IF EXISTS public.access_logs;
DROP FUNCTION IF EXISTS public.sync_orders_columns();
DROP FUNCTION IF EXISTS public.sync_order_status_history();
DROP FUNCTION IF EXISTS public.sync_order_items_columns();
DROP FUNCTION IF EXISTS public.sync_invoice_fields();
DROP FUNCTION IF EXISTS public.sync_invoice_columns();
DROP FUNCTION IF EXISTS public.sync_audit_logs_columns();
DROP FUNCTION IF EXISTS public.fn_business_date(p_at timestamp with time zone, p_outlet_id uuid);
DROP FUNCTION IF EXISTS public.fn_assert_status_transition();
DROP CAST IF EXISTS (text AS public.order_status);
DROP CAST IF EXISTS (public.order_status AS text);
DROP TYPE IF EXISTS public.veg_flag;
DROP TYPE IF EXISTS public.tax_mode;
DROP TYPE IF EXISTS public.table_merge_status;
DROP TYPE IF EXISTS public.sync_status;
DROP TYPE IF EXISTS public.seat_status;
DROP TYPE IF EXISTS public.order_type;
DROP TYPE IF EXISTS public.order_status;
DROP TYPE IF EXISTS public.order_channel;
DROP TYPE IF EXISTS public.dining_table_status;
DROP TYPE IF EXISTS public.channel_type;
DROP TYPE IF EXISTS public.availability_state;
DROP TYPE IF EXISTS public.audit_action;
DROP EXTENSION IF EXISTS pgcrypto;
DROP EXTENSION IF EXISTS citext;
-- *not* dropping schema, since initdb creates it
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: pos
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO pos;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pos
--

COMMENT ON SCHEMA public IS '';


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
    loyalty_points integer DEFAULT 0
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
    tax_rate numeric(5,2) DEFAULT 5.00,
    stock_qty integer DEFAULT 100,
    station_id uuid,
    online_display_name text,
    price bigint DEFAULT 0
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
    updated_by uuid
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
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.terminals OWNER TO pos;

--
-- Name: user_quick_links; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.user_quick_links (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    label character varying(255) NOT NULL,
    href character varying(255) NOT NULL,
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



--
-- Data for Name: access_logs_y2026m08; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: addon_commissions; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: agent_telemetry; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.agent_telemetry VALUES ('agent-frontend', 'Frontend UI Agent', 'UI_ENGINEER', 'ONLINE', 'POS Web UI (Port 4444) & Admin Management Consoles', 4444, 3, 'Passing', 'Serving KapMeta POS shell, touch billing, KDS board & executive admin', '{"posPort": 4444, "touchSupport": true, "bundleOptimized": true}', '["apps/pos-web/pages/*", "apps/pos-web/components/*", "apps/pos-web/lib/auth.ts"]', '2026-09-05 13:04:21.084633+05:30');
INSERT INTO public.agent_telemetry VALUES ('agent-orchestrator', 'Orchestrator Agent', 'SYSTEM_COORDINATOR', 'ONLINE', 'Cross-System Workflow Coordination & Port Management (4001, 4444, 5432)', 4001, 1, 'Passing', 'Supervising backend, frontend and persistence processes', '{"dbPort": 5432, "apiPort": 4001, "posPort": 4444, "supervisor": "active"}', '["scripts/startup.ps1", "scripts/shutdown.ps1", "scripts/status.ts", "Start_PetPooja.bat"]', '2026-09-05 13:04:21.084633+05:30');
INSERT INTO public.agent_telemetry VALUES ('agent-a2a', 'A2A Coordination Agent', 'A2A_COORDINATOR', 'ONLINE', 'Inter-Agent Protocol, State Sync & Admin Hub Telemetry', 4001, 2, 'Passing', 'Routing inter-agent WebSocket topics and aggregating live telemetry', '{"activeAgents": 8, "syncChannels": ["HTTP", "WS", "REGISTRY"], "protocolVersion": "2.0"}', '["agents/a2a-agent.md", "agents/AGENT_REGISTRY.json", "agents/task-board.json", "apps/api/src/routes/admin.ts", "apps/pos-web/pages/admin.tsx"]', '2026-09-05 13:04:21.084633+05:30');
INSERT INTO public.agent_telemetry VALUES ('agent-backend', 'Backend API Agent', 'BACKEND_ENGINEER', 'ONLINE', 'API Gateway (Port 4001), Services & Event Bus', 4001, 2, 'Passing', 'Routing HTTP endpoints, JWT claim verification, and event subscriptions', '{"apiPort": 4001, "jwtScoping": "outlet_id", "activeRoutes": 18}', '["apps/api/src/index.ts", "apps/api/src/routes/*", "services/*"]', '2026-09-05 13:04:21.084633+05:30');
INSERT INTO public.agent_telemetry VALUES ('agent-database', 'Database Persistence Agent', 'DBA_ENGINEER', 'ONLINE', 'PostgreSQL (Port 5432) & Prisma Multi-Tenant Schema', 5432, 1, 'Passing', 'Maintaining multi-tenant schema, seed tools, and backup parity', '{"dbPort": 5432, "poolConnections": 10, "minorUnitStandard": "BIGINT paise"}', '["kapmeta/schema.prisma", "scripts/db-migrate.js", "scripts/seed-dynamic-data.ts"]', '2026-09-05 13:04:21.084633+05:30');
INSERT INTO public.agent_telemetry VALUES ('agent-integration', 'Integration Hub Agent', 'INTEGRATION_ENGINEER', 'ONLINE', 'Online Aggregators (Swiggy/Zomato), Payments & Thermal Printers', 4001, 4, 'Passing', 'Handling HMAC webhooks, idempotent ingestion, and DLQ retries', '{"webhookActive": true, "supportedChannels": ["SWIGGY", "ZOMATO"]}', '["services/integration-hub/*", "services/integration/*"]', '2026-09-05 13:04:21.084633+05:30');
INSERT INTO public.agent_telemetry VALUES ('agent-qa', 'QA & Verification Agent', 'TEST_ENGINEER', 'ONLINE', 'Unit Tests, Contract Validation & E2E Simulation', 4001, 5, 'Passing', 'Running vitest suites, type validation, and pilot simulation drills', '{"pilotDrills": "ENABLED", "testsPassing": 55, "e2eValidation": true}', '["tests/*", "scripts/pilot-e2e-simulation.ts", "vitest.config.ts"]', '2026-09-05 13:04:21.084633+05:30');
INSERT INTO public.agent_telemetry VALUES ('agent-sre', 'SRE & Diagnostics Agent', 'SRE_ENGINEER', 'ONLINE', 'Log Management, Process Monitoring & Diagnostics', 4001, 2, 'Passing', 'Monitoring logs/ directory, service heartbeats, and error traces', '{"logScanner": "active", "healthChecksPassing": true}', '["logs/*", "scripts/status.ts"]', '2026-09-05 13:04:21.084633+05:30');


--
-- Data for Name: areas; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.areas VALUES ('367cb5da-9939-4f5e-92bc-db71fafe74f8', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'AC', 1, true, '2026-09-03 12:25:45.821055+05:30', '2026-09-03 12:25:45.821055+05:30');
INSERT INTO public.areas VALUES ('ffa24a54-4dc8-4a4f-b172-4dee726fd64c', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Non AC', 2, true, '2026-09-03 12:25:45.828813+05:30', '2026-09-03 12:25:45.828813+05:30');
INSERT INTO public.areas VALUES ('1a0624ab-eb9f-4560-bdf0-afc059038595', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Outdoor Garden', 3, true, '2026-09-03 12:25:45.830217+05:30', '2026-09-03 12:25:45.830217+05:30');
INSERT INTO public.areas VALUES ('1be9b857-a084-4773-b3ec-6b2d905b9447', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Terrace Lounge', 4, true, '2026-09-03 12:25:45.831206+05:30', '2026-09-03 12:25:45.831206+05:30');
INSERT INTO public.areas VALUES ('5bb98507-7bc4-4b2e-a572-eab3322cb67c', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Family Section', 5, true, '2026-09-03 12:25:45.832548+05:30', '2026-09-03 12:25:45.832548+05:30');
INSERT INTO public.areas VALUES ('b99373c6-9483-41c3-8a1b-96fb2b9341c8', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Other', 6, true, '2026-09-03 12:25:45.833744+05:30', '2026-09-03 12:25:45.833744+05:30');


--
-- Data for Name: audit_logs_default; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.audit_logs_default VALUES ('35e02671-9ae3-41f3-b8fa-5b5028b33908', '11111111-1111-1111-1111-111111111111', 'ORDER', '9b477c95-d76b-4976-b745-a7a2ef4d4b14', 'CREATE', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, '{"items": [{"id": "5b9ed80e-9f3d-4874-b56f-696dba9fd28f", "quantity": 1, "menuItemId": "f7813575-802f-47bd-816d-936ebed9799c"}], "originalAction": "ORDER_ITEMS_ADDED"}', '2026-09-03 16:21:04.096+05:30', '2026-09-03 16:21:04.063294+05:30', NULL, NULL, '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('10899ef4-2d04-4976-ab7b-5ca988e72423', '11111111-1111-1111-1111-111111111111', 'ORDER', 'fefda5cf-8409-441a-8e3a-a803c36fb2ce', 'CREATE', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, '{"items": [{"id": "69f551b6-2be8-4c7f-83ca-8f41da74e231", "quantity": 1, "menuItemId": "519bf5b7-40ff-4d77-89f2-ebec06547bae"}], "originalAction": "ORDER_ITEMS_ADDED"}', '2026-09-03 16:23:21.492+05:30', '2026-09-03 16:23:21.476181+05:30', NULL, NULL, '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('0f0439b6-b668-4337-b7d1-693274b3dfef', '11111111-1111-1111-1111-111111111111', 'ORDER', 'fefda5cf-8409-441a-8e3a-a803c36fb2ce', 'CREATE', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, '{"items": [{"id": "b36724da-1b39-4e0b-8eb8-d1a6e1dfc404", "quantity": 1, "menuItemId": "a8652e18-bfd0-42c8-b06e-c8d0621c8ef1"}], "originalAction": "ORDER_ITEMS_ADDED"}', '2026-09-03 16:23:58.559+05:30', '2026-09-03 16:23:58.542064+05:30', NULL, NULL, '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('5eb2e600-979a-42b2-9d58-985585d1eca5', '11111111-1111-1111-1111-111111111111', 'PAYMENT', '68985f59-88fb-4d39-bb29-60ab22644833', 'CREATE', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, '{"method": "CASH", "orderId": "fefda5cf-8409-441a-8e3a-a803c36fb2ce", "amountMinor": "70000", "originalAction": "PAYMENT_RECORDED"}', '2026-09-03 17:31:20.471+05:30', '2026-09-03 17:31:20.447334+05:30', NULL, NULL, '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('f2225499-80ab-4020-be06-a49e80ce3da5', '11111111-1111-1111-1111-111111111111', 'PAYMENT', 'c564f487-8ff3-4239-a282-e0052f941842', 'CREATE', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, '{"method": "CASH", "orderId": "c14e4df0-40c4-430e-b162-d015a4964c84", "amountMinor": "5250", "originalAction": "PAYMENT_RECORDED"}', '2026-09-03 17:42:01.161+05:30', '2026-09-03 17:42:01.137925+05:30', NULL, NULL, '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('930bb8cb-4f90-4045-80d5-be4720f0c532', '11111111-1111-1111-1111-111111111111', 'PAYMENT', '4b78cb86-cccb-4dd8-8e29-9bd0976e6832', 'CREATE', '4bc4d34d-f0d4-4402-ae14-2ab128803657', NULL, '{"method": "CASH", "orderId": "08b726d5-cac2-48d9-b036-a668d5bf7066", "amountMinor": "7350", "originalAction": "PAYMENT_RECORDED"}', '2026-09-04 16:24:12.973+05:30', '2026-09-04 16:24:12.958443+05:30', NULL, NULL, '4bc4d34d-f0d4-4402-ae14-2ab128803657', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('7c4fde74-8eb4-413a-903c-2ffda2fa11a2', '11111111-1111-1111-1111-111111111111', 'PAYMENT', '5333b942-cd28-4a18-8c57-e78a86253285', 'CREATE', '4bc4d34d-f0d4-4402-ae14-2ab128803657', NULL, '{"method": "CASH", "orderId": "9b477c95-d76b-4976-b745-a7a2ef4d4b14", "amountMinor": "18000", "originalAction": "PAYMENT_RECORDED"}', '2026-09-04 16:31:01.815+05:30', '2026-09-04 16:31:01.806623+05:30', NULL, NULL, '4bc4d34d-f0d4-4402-ae14-2ab128803657', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('7efa3990-cd83-43d8-97a0-9ce4b4539a46', '11111111-1111-1111-1111-111111111111', 'PAYMENT', '966662c9-db46-439c-9dc7-fb492b7d8dac', 'CREATE', '4bc4d34d-f0d4-4402-ae14-2ab128803657', NULL, '{"method": "CASH", "orderId": "2a670867-a3af-4698-aa9a-84afa3fb7e04", "amountMinor": "7350", "originalAction": "PAYMENT_RECORDED"}', '2026-09-04 16:41:05.197+05:30', '2026-09-04 16:41:05.192695+05:30', NULL, NULL, '4bc4d34d-f0d4-4402-ae14-2ab128803657', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('858d7025-a46c-4f41-b15c-79fe452a2a65', '11111111-1111-1111-1111-111111111111', 'ORDER', 'be05502d-64d3-4721-9b8d-270fb383a20f', 'CREATE', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, '{"items": [{"id": "865dc3f6-0a77-4145-a8d5-d55c0fc11518", "quantity": 1, "menuItemId": "0e966d3c-b0a7-49c5-975e-c9040121ad18"}, {"id": "baf9cf9f-4804-4fdc-9b62-5a88b6697706", "quantity": 1, "menuItemId": "519bf5b7-40ff-4d77-89f2-ebec06547bae"}, {"id": "c8955bf6-d02d-4826-ac2a-f45994824ce5", "quantity": 1, "menuItemId": "e31e6867-c8f7-4c36-b3a2-1fea50e798da"}], "originalAction": "ORDER_ITEMS_ADDED"}', '2026-09-07 14:59:25.379+05:30', '2026-09-07 14:59:25.355535+05:30', NULL, NULL, '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL);


--
-- Data for Name: audit_logs_y2026m08; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: availability_schedules; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: backup_jobs; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: campaign_recipients; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.campaign_recipients VALUES ('81d7a861-5462-434f-9fd2-b7ce6d876e7b', 'b579c8c2-8383-4ace-bdfc-fe8597965326', '45327980-ea70-4792-b2f2-bbc9542d95c1', 'PENDING', NULL, NULL, '2026-09-03 12:29:04.408463+05:30');
INSERT INTO public.campaign_recipients VALUES ('019aba40-c696-4fe1-875b-33a2110e1a92', 'b579c8c2-8383-4ace-bdfc-fe8597965326', '0cb904d6-bde3-454e-a551-4ad1eeacb9f4', 'PENDING', NULL, NULL, '2026-09-03 12:29:04.411303+05:30');
INSERT INTO public.campaign_recipients VALUES ('ea4fcb40-5150-486f-8a7e-bd3ab7671d27', 'b579c8c2-8383-4ace-bdfc-fe8597965326', 'd5e8d1cf-5134-4d83-a47f-f1b0931652bf', 'PENDING', NULL, NULL, '2026-09-03 12:29:04.412819+05:30');


--
-- Data for Name: cash_drawer_sessions; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.categories VALUES ('2c8a1a6d-8257-4dc5-a1ce-22a1975717aa', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', NULL, 'Biryani (Veg)', 1, true, '2026-09-02 13:57:54.599801+05:30', '2026-09-02 13:57:54.599801+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('895fae56-fa21-4a24-8e10-25f56a5ec629', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', NULL, 'Biryani (Non-Veg)', 2, true, '2026-09-02 13:57:54.599801+05:30', '2026-09-02 13:57:54.599801+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('c0c8dc4f-e74a-45f9-a2f6-892260dc9c65', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', NULL, 'Tandoori Starters (Non-Veg)', 3, true, '2026-09-02 13:57:54.599801+05:30', '2026-09-02 13:57:54.599801+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('3ad7d066-bb51-4718-89e2-5264d84bd53d', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', NULL, 'Chinese Starters (Veg)', 4, true, '2026-09-02 13:57:54.599801+05:30', '2026-09-02 13:57:54.599801+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('97ec719b-634c-4b55-bdad-62c2d6d368a1', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', NULL, 'Curries (Non-Veg)', 5, true, '2026-09-02 13:57:54.599801+05:30', '2026-09-02 13:57:54.599801+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('067d3f46-fb3c-4441-b7fd-5ef1d99f3909', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', NULL, 'Roti & Breads', 6, true, '2026-09-02 13:57:54.599801+05:30', '2026-09-02 13:57:54.599801+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('09bc0c5c-5de3-4fcd-9105-36662e07c094', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', NULL, 'Cold Beverage', 7, true, '2026-09-02 13:57:54.599801+05:30', '2026-09-02 13:57:54.599801+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('b0c93372-0583-4d68-a2bf-670bfd6188b4', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', NULL, 'MOCKTAILS', 8, true, '2026-09-02 13:57:54.599801+05:30', '2026-09-02 13:57:54.599801+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('f11e02ac-e172-4c7c-bdb5-c60f06a11401', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', NULL, 'Breakfast', 1, true, '2026-09-02 17:55:52.590675+05:30', '2026-09-02 17:55:52.590675+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('2b27795c-af81-402a-96fd-b8558e24f023', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', NULL, 'Meal Box (Online)', 2, true, '2026-09-02 17:55:52.590675+05:30', '2026-09-02 17:55:52.590675+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('fd9b3cf0-049c-450e-bf0e-d9268601b489', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', NULL, 'Cold Beverage', 3, true, '2026-09-02 17:55:52.590675+05:30', '2026-09-02 17:55:52.590675+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('313fa379-9d5f-489c-b340-cdfc26b9e2f0', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', NULL, 'Hot Beverages', 4, true, '2026-09-02 17:55:52.590675+05:30', '2026-09-02 17:55:52.590675+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('d2ae476b-6ec7-4f2c-99f9-ac33348edef3', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', NULL, 'Soup(Veg)', 5, true, '2026-09-02 17:55:52.590675+05:30', '2026-09-02 17:55:52.590675+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('ab6acda0-8623-4a02-b314-33f3334ec096', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', NULL, 'Meals', 6, true, '2026-09-02 17:55:52.590675+05:30', '2026-09-02 17:55:52.590675+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('cf8cf1dc-f1bd-433f-86bc-b928725d0a01', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', NULL, 'Chinese Starters (Veg)', 7, true, '2026-09-02 17:55:52.590675+05:30', '2026-09-02 17:55:52.590675+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('961b4ae7-5599-4a34-a010-c26d2482f8fc', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', NULL, 'Curries (Veg)', 8, true, '2026-09-02 17:55:52.590675+05:30', '2026-09-02 17:55:52.590675+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('5be6ea43-5233-4f9d-bd96-b7bda6062add', '11111111-1111-1111-1111-111111111111', NULL, 'Chinese Starters (Veg)', 0, true, '2026-09-05 13:03:59.203157+05:30', '2026-09-05 13:03:59.203157+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('5851bf60-bfe0-4e8f-965d-16bcb418dc5c', '11111111-1111-1111-1111-111111111111', NULL, 'Curries (Non-Veg)', 0, true, '2026-09-05 13:03:59.203157+05:30', '2026-09-05 13:03:59.203157+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('096f0a82-e581-45f1-9d92-522ebe5c2f7a', '11111111-1111-1111-1111-111111111111', NULL, 'Biryani (Veg)', 0, true, '2026-09-05 13:03:59.203157+05:30', '2026-09-05 13:03:59.203157+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('25b36641-61fa-4884-a3d8-e5ced013533a', '11111111-1111-1111-1111-111111111111', NULL, 'MOCKTAILS', 0, true, '2026-09-05 13:03:59.203157+05:30', '2026-09-05 13:03:59.203157+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('aacd159c-c694-4a0a-9420-3d4fc651f26e', '11111111-1111-1111-1111-111111111111', NULL, 'Roti & Breads', 0, true, '2026-09-05 13:03:59.203157+05:30', '2026-09-05 13:03:59.203157+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('f5fd13c7-2ff4-42eb-8ba5-e4e7d8321ecd', '11111111-1111-1111-1111-111111111111', NULL, 'Curries (Veg)', 0, true, '2026-09-05 13:03:59.203157+05:30', '2026-09-05 13:03:59.203157+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('229bdc16-1471-4b21-b75f-d58b6aeb3aad', '11111111-1111-1111-1111-111111111111', NULL, 'Meals', 0, true, '2026-09-05 13:03:59.203157+05:30', '2026-09-05 13:03:59.203157+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('fe5d30c0-8990-4e3d-bc02-c3eab0399b0b', '11111111-1111-1111-1111-111111111111', NULL, 'Cold Beverage', 0, true, '2026-09-05 13:03:59.203157+05:30', '2026-09-05 13:03:59.203157+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('157b592c-2b8a-4c9d-80b0-3ca17272ca5e', '11111111-1111-1111-1111-111111111111', NULL, 'Breakfast', 0, true, '2026-09-05 13:03:59.203157+05:30', '2026-09-05 13:03:59.203157+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('6f5f9db9-2d68-4acf-8773-2a224b80fb33', '11111111-1111-1111-1111-111111111111', NULL, 'Tandoori Starters (Non-Veg)', 0, true, '2026-09-05 13:03:59.203157+05:30', '2026-09-05 13:03:59.203157+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('f001972a-1b1f-4e9c-bb87-9a5520149635', '11111111-1111-1111-1111-111111111111', NULL, 'Hot Beverages', 0, true, '2026-09-05 13:03:59.203157+05:30', '2026-09-05 13:03:59.203157+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('7553eb9c-4449-44f1-a196-a9c3c2f7c4ad', '11111111-1111-1111-1111-111111111111', NULL, 'Soup(Veg)', 0, true, '2026-09-05 13:03:59.203157+05:30', '2026-09-05 13:03:59.203157+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('5ffb7578-d7c4-491d-b516-98c10edacb0c', '11111111-1111-1111-1111-111111111111', NULL, 'Biryani (Non-Veg)', 0, true, '2026-09-05 13:03:59.203157+05:30', '2026-09-05 13:03:59.203157+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('e581a9b0-daa4-4d6f-9f14-7623638c1dc7', '11111111-1111-1111-1111-111111111111', NULL, 'Meal Box (Online)', 0, true, '2026-09-05 13:03:59.203157+05:30', '2026-09-05 13:03:59.203157+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('dc03cb6d-15d5-4869-bd2a-f9fe15bef950', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', NULL, 'Curries (Veg)', 0, true, '2026-09-05 13:03:59.203157+05:30', '2026-09-05 13:03:59.203157+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('1573fc0d-ce0f-4627-9b8d-318c72987a52', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', NULL, 'Meals', 0, true, '2026-09-05 13:03:59.203157+05:30', '2026-09-05 13:03:59.203157+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('67d6f5b9-6c57-4c20-8f38-76eb55d6d2fc', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', NULL, 'Breakfast', 0, true, '2026-09-05 13:03:59.203157+05:30', '2026-09-05 13:03:59.203157+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('98294cc3-ab04-48a7-84ee-344177cd6489', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', NULL, 'Hot Beverages', 0, true, '2026-09-05 13:03:59.203157+05:30', '2026-09-05 13:03:59.203157+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('adc01cba-1827-49c2-8914-8dfa555df43e', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', NULL, 'Soup(Veg)', 0, true, '2026-09-05 13:03:59.203157+05:30', '2026-09-05 13:03:59.203157+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('eb24c456-5e50-4bd0-a2e2-a85651fb1bd7', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', NULL, 'Meal Box (Online)', 0, true, '2026-09-05 13:03:59.203157+05:30', '2026-09-05 13:03:59.203157+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('ef7ea92b-6632-4edf-95ad-d06d6eb167cc', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', NULL, 'Curries (Non-Veg)', 0, true, '2026-09-05 13:03:59.203157+05:30', '2026-09-05 13:03:59.203157+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('ec70f772-6e76-4d98-8750-789cc04b44ed', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', NULL, 'Biryani (Veg)', 0, true, '2026-09-05 13:03:59.203157+05:30', '2026-09-05 13:03:59.203157+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('0558a237-7c53-4205-9173-ce6cae42d26f', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', NULL, 'MOCKTAILS', 0, true, '2026-09-05 13:03:59.203157+05:30', '2026-09-05 13:03:59.203157+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('56e83094-aa78-4bac-9315-3bd2aabd389e', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', NULL, 'Roti & Breads', 0, true, '2026-09-05 13:03:59.203157+05:30', '2026-09-05 13:03:59.203157+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('56b892ad-0dc8-4efa-8314-af446b132226', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', NULL, 'Tandoori Starters (Non-Veg)', 0, true, '2026-09-05 13:03:59.203157+05:30', '2026-09-05 13:03:59.203157+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('a393d67d-aeb3-45ff-8e85-9fc7614ea1ce', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', NULL, 'Biryani (Non-Veg)', 0, true, '2026-09-05 13:03:59.203157+05:30', '2026-09-05 13:03:59.203157+05:30', NULL, NULL);


--
-- Data for Name: channel_accounts; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.channel_accounts VALUES ('6c9db3a2-e942-41af-ab3b-bc5734ee817c', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'dc32ee52-ee0f-43a3-adb9-7c2a5c9ddc84', 'SW-KAPILA-01', 'swiggy_production_v2', true, '2026-09-03 12:29:04.35326+05:30', '2026-09-03 12:29:04.35326+05:30', 'd119207c-8cf7-4a03-8125-6737c85c210d', NULL);
INSERT INTO public.channel_accounts VALUES ('1513ad56-0fcc-4e97-8b4b-3b9293df97ec', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '84a5f323-de98-48be-94ad-0fca48556a1c', 'ZM-KAPILA-01', 'zomato_merchant_v1', true, '2026-09-03 12:29:04.358541+05:30', '2026-09-03 12:29:04.358541+05:30', 'd119207c-8cf7-4a03-8125-6737c85c210d', NULL);


--
-- Data for Name: channel_item_mapping; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.channel_item_mapping VALUES ('25a96acd-7b99-441f-b379-cbb9266d7b1c', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '6c9db3a2-e942-41af-ab3b-bc5734ee817c', 'a0e7da8d-2be8-42d7-9448-794ec1578ce0', 'EXT-HOTE-a0e7', '2026-09-03 12:29:04.372152+05:30', '2026-09-03 12:29:04.372152+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('93063403-ec6c-4035-ab78-1c1645aa7a94', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '6c9db3a2-e942-41af-ab3b-bc5734ee817c', '277abe6a-2246-42c2-a9b2-3ec678008344', 'EXT-HYDE-277a', '2026-09-03 12:29:04.376986+05:30', '2026-09-03 12:29:04.376986+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('f5c90d8f-cb48-47aa-b0f0-aaccb424827c', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '6c9db3a2-e942-41af-ab3b-bc5734ee817c', '7e80fe93-1931-43c5-bc95-cf0e9230a197', 'EXT-MURG-7e80', '2026-09-03 12:29:04.37927+05:30', '2026-09-03 12:29:04.37927+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('b67b99f0-3b46-4360-9188-9098ac289800', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '6c9db3a2-e942-41af-ab3b-bc5734ee817c', 'b11d7200-131b-4674-bb4e-1d60e5fda134', 'EXT-KAPI-b11d', '2026-09-03 12:29:04.381168+05:30', '2026-09-03 12:29:04.381168+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('7ddf2bff-9051-4a5c-8986-69ac2169cf03', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '6c9db3a2-e942-41af-ab3b-bc5734ee817c', '88009dc2-f5a2-4739-9437-ab8203222d4d', 'EXT-BUTT-8800', '2026-09-03 12:29:04.382981+05:30', '2026-09-03 12:29:04.382981+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('fe32e33c-3a0f-48b5-b386-8e533a0bee62', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '1513ad56-0fcc-4e97-8b4b-3b9293df97ec', 'a0e7da8d-2be8-42d7-9448-794ec1578ce0', 'EXT-HOTE-a0e7', '2026-09-03 12:29:04.384891+05:30', '2026-09-03 12:29:04.384891+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('a1045302-d1c3-4c7f-9438-c20436f404a7', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '1513ad56-0fcc-4e97-8b4b-3b9293df97ec', '277abe6a-2246-42c2-a9b2-3ec678008344', 'EXT-HYDE-277a', '2026-09-03 12:29:04.386963+05:30', '2026-09-03 12:29:04.386963+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('f2ea849d-4006-4200-b85a-72115a269259', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '1513ad56-0fcc-4e97-8b4b-3b9293df97ec', '7e80fe93-1931-43c5-bc95-cf0e9230a197', 'EXT-MURG-7e80', '2026-09-03 12:29:04.388427+05:30', '2026-09-03 12:29:04.388427+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('439f7954-e23a-4249-aee8-f862b9266097', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '1513ad56-0fcc-4e97-8b4b-3b9293df97ec', 'b11d7200-131b-4674-bb4e-1d60e5fda134', 'EXT-KAPI-b11d', '2026-09-03 12:29:04.390108+05:30', '2026-09-03 12:29:04.390108+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('38661f9a-2666-4230-bf8b-bd65b2be8b46', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '1513ad56-0fcc-4e97-8b4b-3b9293df97ec', '88009dc2-f5a2-4739-9437-ab8203222d4d', 'EXT-BUTT-8800', '2026-09-03 12:29:04.391669+05:30', '2026-09-03 12:29:04.391669+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('8907e856-9bbb-406d-9126-bccae177b728', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '6c9db3a2-e942-41af-ab3b-bc5734ee817c', 'd9519b46-7ca5-4a2a-bfa1-2374153b60a5', 'EXT-(2) -d951', '2026-09-05 13:04:10.358676+05:30', '2026-09-05 13:04:10.358676+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('76483cc0-0a5c-456e-809a-abb771c198c9', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '6c9db3a2-e942-41af-ab3b-bc5734ee817c', 'ec478730-9b61-4be3-bc0b-ea7243c1bdfd', 'EXT-(S) -ec47', '2026-09-05 13:04:10.362066+05:30', '2026-09-05 13:04:10.362066+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('865559b8-53b4-49a7-9fb9-987f41ae4c54', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '6c9db3a2-e942-41af-ab3b-bc5734ee817c', 'edc6665e-f238-411c-aaad-edcbf556c22d', 'EXT-(S) -edc6', '2026-09-05 13:04:10.364309+05:30', '2026-09-05 13:04:10.364309+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('c6e8e351-69b6-45a8-9ee4-3ff1dea9f64c', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '6c9db3a2-e942-41af-ab3b-bc5734ee817c', '4109efd3-e894-4bff-ba91-ba8be0c5daf2', 'EXT-(S) -4109', '2026-09-05 13:04:10.366078+05:30', '2026-09-05 13:04:10.366078+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('3df9ee49-7aca-476a-be17-d34c4d5f3f42', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '6c9db3a2-e942-41af-ab3b-bc5734ee817c', '59846ee3-f19f-4d30-beac-11c4701a2ef9', 'EXT-(S) -5984', '2026-09-05 13:04:10.368392+05:30', '2026-09-05 13:04:10.368392+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('7e5bb3d9-1b28-45d3-8423-22b696caf32e', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '1513ad56-0fcc-4e97-8b4b-3b9293df97ec', 'd9519b46-7ca5-4a2a-bfa1-2374153b60a5', 'EXT-(2) -d951', '2026-09-05 13:04:10.374954+05:30', '2026-09-05 13:04:10.374954+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('8bb0d729-c9fd-42ca-914a-481296727349', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '1513ad56-0fcc-4e97-8b4b-3b9293df97ec', 'ec478730-9b61-4be3-bc0b-ea7243c1bdfd', 'EXT-(S) -ec47', '2026-09-05 13:04:10.377081+05:30', '2026-09-05 13:04:10.377081+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('44313697-0315-4cc8-8d2b-d11f13508372', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '1513ad56-0fcc-4e97-8b4b-3b9293df97ec', 'edc6665e-f238-411c-aaad-edcbf556c22d', 'EXT-(S) -edc6', '2026-09-05 13:04:10.37856+05:30', '2026-09-05 13:04:10.37856+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('a59f8030-e780-4eb7-9d4e-2cef5627d243', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '1513ad56-0fcc-4e97-8b4b-3b9293df97ec', '4109efd3-e894-4bff-ba91-ba8be0c5daf2', 'EXT-(S) -4109', '2026-09-05 13:04:10.379854+05:30', '2026-09-05 13:04:10.379854+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('53397872-a380-4e9c-bf7a-0f970bee54e0', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '1513ad56-0fcc-4e97-8b4b-3b9293df97ec', '59846ee3-f19f-4d30-beac-11c4701a2ef9', 'EXT-(S) -5984', '2026-09-05 13:04:10.382195+05:30', '2026-09-05 13:04:10.382195+05:30', NULL, NULL, 'MENU_V1', 1);


--
-- Data for Name: channel_sync_log; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: configuration_changes_default; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: configuration_changes_y2026m08; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: customer_addresses; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: customer_tags; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.customers VALUES ('45327980-ea70-4792-b2f2-bbc9542d95c1', NULL, '9988776655', NULL, 'arjun.reddy@example.com', false, false, NULL, true, '2026-09-02 14:01:46.809+05:30', '2026-09-02 14:01:46.809+05:30', NULL, NULL, 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Arjun', 'Reddy', 500);
INSERT INTO public.customers VALUES ('0cb904d6-bde3-454e-a551-4ad1eeacb9f4', NULL, '9876543212', NULL, 'priya.sharma@example.com', false, false, NULL, true, '2026-09-02 14:01:46.825+05:30', '2026-09-02 14:01:46.825+05:30', NULL, NULL, 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Priya', 'Sharma', 1200);
INSERT INTO public.customers VALUES ('d5e8d1cf-5134-4d83-a47f-f1b0931652bf', NULL, '9123456789', NULL, 'rahul.k@example.com', false, false, NULL, true, '2026-09-02 14:01:46.834+05:30', '2026-09-02 14:01:46.834+05:30', NULL, NULL, 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Rahul', 'Kumar', 0);


--
-- Data for Name: daily_sales_summary; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: dining_tables; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.dining_tables VALUES ('23d9ed8f-a004-4023-b7af-ec4362af43a4', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'A1', 4, 'AC', 'VACANT', true, '2026-09-02 14:04:30.91+05:30', '2026-09-03 10:32:23.044+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('9b8f872b-02ce-459d-b2d6-d804c2647d3f', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'A2', 4, 'AC', 'VACANT', true, '2026-09-02 14:04:30.916+05:30', '2026-09-03 10:32:23.049+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('eca0bafa-6864-4dea-ad34-ce48279aecb5', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'A3', 4, 'AC', 'VACANT', true, '2026-09-02 14:04:30.919+05:30', '2026-09-03 10:32:23.052+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('0ba7162a-4f66-4690-8894-4b46cb937fed', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'A4', 4, 'AC', 'VACANT', true, '2026-09-02 14:04:30.922+05:30', '2026-09-03 10:32:23.055+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('d7e3a3e1-753a-4086-ba89-b70897aeb6be', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'A5', 4, 'AC', 'VACANT', true, '2026-09-02 14:04:30.926+05:30', '2026-09-03 10:32:23.059+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('fa94cc19-3571-476b-ad32-120d4afdccfe', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'A6', 6, 'AC', 'VACANT', true, '2026-09-02 14:04:30.929+05:30', '2026-09-03 10:32:23.062+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('97e40d05-949c-4cfc-9889-0201dac442ac', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'A7', 4, 'AC', 'VACANT', true, '2026-09-02 14:04:30.934+05:30', '2026-09-03 10:32:23.065+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('027c7431-e590-4764-beea-400c9feecea6', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'A8', 4, 'AC', 'VACANT', true, '2026-09-02 14:04:30.936+05:30', '2026-09-03 10:32:23.067+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('54f530ba-5fbb-4902-b5d7-5fe30f9f398b', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'A9', 6, 'AC', 'VACANT', true, '2026-09-02 14:04:30.939+05:30', '2026-09-03 10:32:23.069+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('3fa32de0-0187-4703-ba12-d667117ca148', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'A10', 4, 'AC', 'VACANT', true, '2026-09-02 14:04:30.941+05:30', '2026-09-03 10:32:23.071+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('7ea79c5a-76a5-493b-99e3-4a41b6d086a6', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'A11', 2, 'AC', 'VACANT', true, '2026-09-02 14:04:30.944+05:30', '2026-09-03 10:32:23.074+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('ad954268-ec96-4255-b542-56fb95737952', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'T-01', 4, 'Indoor AC', 'VACANT', true, '2026-09-02 13:51:17.818+05:30', '2026-09-02 14:00:06.404+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('34c638a6-b59d-45d1-a6b2-bb5479ef6817', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'T-02', 4, 'Indoor AC', 'VACANT', true, '2026-09-02 13:51:17.824+05:30', '2026-09-02 14:00:06.407+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('5aa05645-9fad-478c-88c1-0273d06bc196', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'T-03', 6, 'Indoor AC', 'VACANT', true, '2026-09-02 13:51:17.827+05:30', '2026-09-02 14:00:06.409+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('7601576d-d6c6-43b3-a76e-4a1819723b33', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'T-04', 2, 'Indoor AC', 'VACANT', true, '2026-09-02 13:51:17.83+05:30', '2026-09-02 14:00:06.411+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('6866198d-c1eb-4c9c-afef-477924f41273', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'T-05', 4, 'Terrace Lounge', 'VACANT', true, '2026-09-02 13:51:17.834+05:30', '2026-09-02 14:00:06.413+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('bff6e557-79fc-470c-a385-5226001d336c', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'T-06', 8, 'Family Section', 'VACANT', true, '2026-09-02 13:51:17.836+05:30', '2026-09-02 14:00:06.415+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('349c7afc-39f1-4531-8f71-802b5a0793f4', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'A12', 4, 'AC', 'VACANT', true, '2026-09-02 14:04:30.947+05:30', '2026-09-03 10:32:23.077+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('00b56065-9a3e-464c-b8f4-666f996c0cb9', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'A13', 4, 'AC', 'VACANT', true, '2026-09-02 14:04:30.951+05:30', '2026-09-03 10:32:23.08+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('7cd4c659-78b4-4504-8b8b-5cc7d0f81220', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'A14', 4, 'AC', 'VACANT', true, '2026-09-02 14:04:30.955+05:30', '2026-09-03 10:32:23.082+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('2bca0533-4ac7-438f-9833-f161a870276f', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'A15', 4, 'AC', 'VACANT', true, '2026-09-02 14:04:30.958+05:30', '2026-09-03 10:32:23.084+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('a49533f7-8610-4b5e-8d0d-7bae7acb131a', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'B1', 4, 'Non AC', 'VACANT', true, '2026-09-02 14:04:30.961+05:30', '2026-09-03 10:32:23.086+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('6628a18e-17fe-45aa-91e7-a276e7584927', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'B2', 4, 'Non AC', 'VACANT', true, '2026-09-02 14:04:30.963+05:30', '2026-09-03 10:32:23.088+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('6837a18b-6783-4283-b49d-9f524bbcccb3', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'B3', 4, 'Non AC', 'VACANT', true, '2026-09-02 14:04:30.966+05:30', '2026-09-03 10:32:23.09+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('fdc9afdf-5b2f-4c89-ad88-4b0439868e89', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'B4', 4, 'Non AC', 'VACANT', true, '2026-09-02 14:04:30.968+05:30', '2026-09-03 10:32:23.093+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('d02f4ae7-6f53-4dbf-94ec-8aa1d8736129', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'B5', 4, 'Non AC', 'VACANT', true, '2026-09-02 14:04:30.97+05:30', '2026-09-03 10:32:23.095+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('7786ce10-4890-4681-ba2b-c4b2e1d79c7d', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'B6', 4, 'Non AC', 'VACANT', true, '2026-09-02 14:04:30.972+05:30', '2026-09-03 10:32:23.097+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('77fa811d-dab1-4713-a8e3-58210bd57163', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'B7', 4, 'Non AC', 'VACANT', true, '2026-09-02 14:04:30.975+05:30', '2026-09-03 10:32:23.1+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('81eff61d-8882-4ec2-b60e-667522021aee', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'B8', 4, 'Non AC', 'VACANT', true, '2026-09-02 14:04:30.977+05:30', '2026-09-03 10:32:23.101+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('078c0761-8881-45ac-992c-38e5e1bcad67', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'B9', 4, 'Non AC', 'VACANT', true, '2026-09-02 14:04:30.979+05:30', '2026-09-03 10:32:23.103+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('d6a39aae-f122-4f88-834a-1e42b2b01dd8', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'B10', 4, 'Non AC', 'VACANT', true, '2026-09-02 14:04:30.981+05:30', '2026-09-03 10:32:23.105+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('3df956b3-8170-482a-809c-f2aa3d937185', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'B11', 4, 'Non AC', 'VACANT', true, '2026-09-02 14:04:30.984+05:30', '2026-09-03 10:32:23.107+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('57a6ddb9-6c63-4f06-b862-e679f5c19684', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'B12', 6, 'Non AC', 'VACANT', true, '2026-09-02 14:04:30.986+05:30', '2026-09-03 10:32:23.108+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('693df208-ac49-4357-a797-2f7d9ba4e38f', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'B13', 4, 'Non AC', 'VACANT', true, '2026-09-02 14:04:30.988+05:30', '2026-09-03 10:32:23.11+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('b7031645-7905-49a2-9a9d-d6b83934b096', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'B14', 4, 'Non AC', 'VACANT', true, '2026-09-02 14:04:30.99+05:30', '2026-09-03 10:32:23.112+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('dfa31ae9-4959-400e-a114-fa030de8205b', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'B15', 4, 'Non AC', 'VACANT', true, '2026-09-02 14:04:30.992+05:30', '2026-09-03 10:32:23.113+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('8d20dda9-a683-4c9b-949f-ffb498047524', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'B16', 4, 'Non AC', 'VACANT', true, '2026-09-02 14:04:30.994+05:30', '2026-09-03 10:32:23.115+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('0830db8a-23ad-4865-8e97-449d294900ec', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'B17', 4, 'Non AC', 'VACANT', true, '2026-09-02 14:04:30.996+05:30', '2026-09-03 10:32:23.118+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('0a9548bc-a18e-4a03-9165-bfdb2fa9db08', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'B18', 4, 'Non AC', 'VACANT', true, '2026-09-02 14:04:30.999+05:30', '2026-09-03 10:32:23.12+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('681102b2-e058-4852-a5a7-945f6072c63b', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'B19', 4, 'Non AC', 'VACANT', true, '2026-09-02 14:04:31.001+05:30', '2026-09-03 10:32:23.122+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('45fd2d5b-d4a1-4d08-8bb0-bb77f39ccace', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'B20', 4, 'Non AC', 'VACANT', true, '2026-09-02 14:04:31.003+05:30', '2026-09-03 10:32:23.124+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('1068ed11-2485-443f-bbf2-b7324f4a564a', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'B21', 4, 'Non AC', 'VACANT', true, '2026-09-02 14:04:31.005+05:30', '2026-09-03 10:32:23.126+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('cbcc12f8-12f4-4443-a112-c62cf0c9f58e', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'B22', 4, 'Non AC', 'VACANT', true, '2026-09-02 14:04:31.006+05:30', '2026-09-03 10:32:23.128+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('2eb2414b-26ca-41c0-98ca-f64edf5bfdf1', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'B23', 4, 'Non AC', 'VACANT', true, '2026-09-02 14:04:31.008+05:30', '2026-09-03 10:32:23.129+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('5c9c8762-54ad-4eb3-ba0d-29da4cdf70a7', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'B24', 4, 'Non AC', 'VACANT', true, '2026-09-02 14:04:31.01+05:30', '2026-09-03 10:32:23.131+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('d3e48b55-3a44-4b9e-8b1c-0cbb200593b7', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'B25', 4, 'Non AC', 'VACANT', true, '2026-09-02 14:04:31.011+05:30', '2026-09-03 10:32:23.133+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('c02f7921-f2ea-4bf3-8d7d-a93297bce05e', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'B26', 4, 'Non AC', 'VACANT', true, '2026-09-02 14:04:31.014+05:30', '2026-09-03 10:32:23.134+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('44894bf0-64d9-49d1-9d87-6486721ae438', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'B27', 4, 'Non AC', 'VACANT', true, '2026-09-02 14:04:31.016+05:30', '2026-09-03 10:32:23.136+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('7856ea3f-3e02-4cf6-a50d-b2af1b59ac02', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'B28', 4, 'Non AC', 'VACANT', true, '2026-09-02 14:04:31.017+05:30', '2026-09-03 10:32:23.139+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('25bbcf5c-74d1-41a4-80a4-693c73e9988b', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'B29', 4, 'Non AC', 'VACANT', true, '2026-09-02 14:04:31.019+05:30', '2026-09-03 10:32:23.141+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('76b2960c-1ce9-4d24-a8d4-59aaa182ddd4', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'B30', 4, 'Non AC', 'VACANT', true, '2026-09-02 14:04:31.021+05:30', '2026-09-03 10:32:23.142+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('242b1b7e-11cb-4297-9c9e-35fe016d5bd1', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'LADIES C', 10, 'Other', 'VACANT', true, '2026-09-02 14:04:31.023+05:30', '2026-09-03 10:32:23.144+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('86bb98c6-d7df-4364-a6fe-01b5d8480a51', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'b18a', 2, 'Other', 'VACANT', true, '2026-09-02 14:04:31.024+05:30', '2026-09-03 10:32:23.145+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('7a4cc22d-222e-4d74-a71b-3f23d2eb6cb1', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'b19a', 2, 'Other', 'VACANT', true, '2026-09-02 14:04:31.026+05:30', '2026-09-03 10:32:23.147+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('5de0a430-c342-4a13-99d0-e2da969a1e08', '11111111-1111-1111-1111-111111111111', 'KAp1', 4, 'Non AC', 'VACANT', true, '2026-09-03 13:37:18.685+05:30', '2026-09-03 13:37:18.685+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('1b479b53-d206-4903-9da4-45d0ce70b57f', '11111111-1111-1111-1111-111111111111', 'kap02', 4, 'First Floor', 'VACANT', true, '2026-09-03 13:37:38.435+05:30', '2026-09-03 13:37:38.435+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('147a6a0e-dc27-402a-9fb4-47112078a176', '11111111-1111-1111-1111-111111111111', 'Kap03', 2, 'Other', 'VACANT', true, '2026-09-03 13:38:27.175+05:30', '2026-09-03 13:38:27.175+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('2ab31806-b577-4204-ac64-6153ffda1c8a', '11111111-1111-1111-1111-111111111111', 'DA-01', 4, 'Non AC', 'OCCUPIED', true, '2026-09-03 13:36:11.245+05:30', '2026-09-07 14:59:25.434+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('40853812-70c7-4a35-bd09-1da206a038cf', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'test_verify_3811', 4, 'Non AC', 'VACANT', true, '2026-09-07 18:24:13.858+05:30', '2026-09-07 18:24:13.858+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('9fd13767-93e7-41fc-802d-bdc506551701', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'test_verify_4044', 4, 'Non AC', 'VACANT', true, '2026-09-07 18:24:14.068+05:30', '2026-09-07 18:24:14.068+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('0819c312-8bab-4b76-9f84-4f914b8ff176', '11111111-1111-1111-1111-111111111111', 'test_verify_7652', 4, 'Non AC', 'VACANT', true, '2026-09-07 18:24:27.784+05:30', '2026-09-07 18:24:27.784+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('b4815ec9-0f25-433d-bb1c-61e525a0e5c5', '11111111-1111-1111-1111-111111111111', 'test_verify_8005', 4, 'Non AC', 'VACANT', true, '2026-09-07 18:24:28.038+05:30', '2026-09-07 18:24:28.038+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('6af1eb27-21d6-4385-8161-ee8d00317a10', '11111111-1111-1111-1111-111111111111', 'da', 5, 'Non AC', 'OCCUPIED', true, '2026-09-03 13:36:39.072+05:30', '2026-09-04 16:57:45.147+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);


--
-- Data for Name: hourly_sales_summary; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: inbound_events; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: ingredients; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.ingredients VALUES ('9b57d190-a3ee-4b29-9b7f-26027b083ddc', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Aged Basmati Rice', 'kg', 0, 30, 0.000, true, '2026-09-02 14:00:07.321+05:30', '2026-09-02 14:00:07.321+05:30', NULL, NULL, 150, 11000);
INSERT INTO public.ingredients VALUES ('8311761a-0d54-4296-bdb1-21e2cd16e55a', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Fresh Chicken (Boneless)', 'kg', 0, 15, 0.000, true, '2026-09-02 14:00:07.326+05:30', '2026-09-02 14:00:07.326+05:30', NULL, NULL, 45, 24000);
INSERT INTO public.ingredients VALUES ('f82e517e-0dc0-4994-8f8a-9dcf8fee215c', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Fresh Paneer', 'kg', 0, 5, 0.000, true, '2026-09-02 14:00:07.33+05:30', '2026-09-02 14:00:07.33+05:30', NULL, NULL, 20, 32000);
INSERT INTO public.ingredients VALUES ('88bfa675-5ce9-41bc-8798-37696f83bfb0', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Pure Desi Ghee', 'l', 0, 5, 0.000, true, '2026-09-02 14:00:07.335+05:30', '2026-09-02 14:00:07.335+05:30', NULL, NULL, 25, 65000);
INSERT INTO public.ingredients VALUES ('89dc542f-6ce0-400f-9232-ba860aa726c7', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Basmati Rice', 'kg', 0, 10, 0.000, true, '2026-09-02 14:02:08.961+05:30', '2026-09-02 14:02:08.961+05:30', NULL, NULL, 100, 8000);
INSERT INTO public.ingredients VALUES ('294ce22a-e3db-4246-b4ba-bc5e41dc2b58', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Chicken Breast', 'kg', 0, 5, 0.000, true, '2026-09-02 14:02:08.967+05:30', '2026-09-02 14:02:08.967+05:30', NULL, NULL, 100, 22000);
INSERT INTO public.ingredients VALUES ('50839189-67bc-43cb-8498-01c6e26d296f', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Tomato Puree', 'l', 0, 20, 0.000, true, '2026-09-02 14:02:08.97+05:30', '2026-09-02 14:02:08.97+05:30', NULL, NULL, 100, 5000);


--
-- Data for Name: integration_errors; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: integrations; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.integrations VALUES ('dc32ee52-ee0f-43a3-adb9-7c2a5c9ddc84', 'SWIGGY', 'SWIGGY', true, '2026-09-03 12:29:04.343427+05:30', '2026-09-05 13:04:10.323545+05:30', NULL, NULL);
INSERT INTO public.integrations VALUES ('84a5f323-de98-48be-94ad-0fca48556a1c', 'ZOMATO', 'ZOMATO', true, '2026-09-03 12:29:04.356512+05:30', '2026-09-05 13:04:10.337292+05:30', NULL, NULL);


--
-- Data for Name: inventory_consumption_log; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.invoices VALUES ('9ce78875-d9b3-4d60-a385-224eae146480', '11111111-1111-1111-1111-111111111111', '9b477c95-d76b-4976-b745-a7a2ef4d4b14', 'INV-2026-00001', 18000, 858, 0, NULL, 0, '2026-09-04 16:38:27.241+05:30', 0, 'INV-2026-00001', 18000, 858);
INSERT INTO public.invoices VALUES ('07f6d698-579d-40af-afdc-1f9453bc6fce', '11111111-1111-1111-1111-111111111111', '2a670867-a3af-4698-aa9a-84afa3fb7e04', 'INV-2026-00002', 7350, 350, 0, NULL, 0, '2026-09-04 16:41:05.211+05:30', 0, 'INV-2026-00002', 7350, 350);


--
-- Data for Name: item_availabilities; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.item_availabilities VALUES ('d69a71c3-beb8-45a3-90f2-b98f9c18e143', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'a0e7da8d-2be8-42d7-9448-794ec1578ce0', true, 50, 1, '2026-09-02 14:00:07.293+05:30');
INSERT INTO public.item_availabilities VALUES ('2423275b-40fd-4535-9067-b5d6a0e034eb', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '277abe6a-2246-42c2-a9b2-3ec678008344', true, 35, 1, '2026-09-02 14:00:07.3+05:30');
INSERT INTO public.item_availabilities VALUES ('9dcb2518-b4cc-4718-9a65-84ee2c00a9b3', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '7e80fe93-1931-43c5-bc95-cf0e9230a197', true, 40, 1, '2026-09-02 14:00:07.307+05:30');
INSERT INTO public.item_availabilities VALUES ('4a8ab9ab-480d-46db-bd05-7e59a7181216', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'b11d7200-131b-4674-bb4e-1d60e5fda134', true, 100, 1, '2026-09-02 14:00:07.313+05:30');
INSERT INTO public.item_availabilities VALUES ('69cf9206-adb2-456b-94cb-bcf659988820', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '88009dc2-f5a2-4739-9437-ab8203222d4d', true, 100, 1, '2026-09-02 17:59:35.408348+05:30');
INSERT INTO public.item_availabilities VALUES ('59321fd4-853d-40c0-ba66-303c17db1289', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', '46f3f4d1-f84b-4888-a21d-c6f4a015e247', true, 50, 1, '2026-09-03 10:32:23.232+05:30');
INSERT INTO public.item_availabilities VALUES ('374e5e1a-65cc-4289-b027-529eff1f9581', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', '245caeba-ef58-468f-b37f-cbf1e991addf', true, 60, 1, '2026-09-03 10:32:23.243+05:30');
INSERT INTO public.item_availabilities VALUES ('4e162750-b333-48d7-9f42-6c5e1e1931d8', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', '3d414f04-d66e-4e4c-a6d1-4acc7163ce12', true, 40, 1, '2026-09-03 10:32:23.251+05:30');
INSERT INTO public.item_availabilities VALUES ('f94d0089-b3eb-4324-bc2c-5e4977a3f7bb', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'b080025e-c0db-4904-9b7a-9d8bb7181281', true, 45, 1, '2026-09-03 10:32:23.26+05:30');
INSERT INTO public.item_availabilities VALUES ('cfb28045-12e0-420c-a142-b238f8f4332f', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'e3592f51-3aad-46e7-8860-e71f1e6cb91b', true, 50, 1, '2026-09-03 10:32:23.268+05:30');
INSERT INTO public.item_availabilities VALUES ('ad509e40-a8a5-468f-9682-53803e921304', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', '686908c4-7cd1-44f0-bfce-e99abd6ff727', true, 50, 1, '2026-09-03 10:32:23.275+05:30');
INSERT INTO public.item_availabilities VALUES ('0f3b936f-b663-4e4f-ae7e-0a70eb6737bf', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', '1b4c5540-a235-44d4-ad0e-9f81eb1b465c', true, 50, 1, '2026-09-03 10:32:23.285+05:30');
INSERT INTO public.item_availabilities VALUES ('767a85b4-9a21-4640-a033-44442921286f', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'bbff2302-aa8b-4977-9229-71cc2c2baf5f', true, 35, 1, '2026-09-03 10:32:23.292+05:30');
INSERT INTO public.item_availabilities VALUES ('3ed271da-aef3-40d4-bdc9-e32990bb6a4a', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', '678efff3-d592-485e-a518-298fa1b851db', true, 20, 1, '2026-09-03 10:32:23.301+05:30');
INSERT INTO public.item_availabilities VALUES ('86d8331a-2f0d-4a82-ad4c-2cfd098f813d', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'a27a7e4f-8b57-40ca-a90a-c8bd8747b0db', true, 30, 1, '2026-09-03 10:32:23.309+05:30');
INSERT INTO public.item_availabilities VALUES ('03e303ff-705d-4dc7-b74f-23541ee4b25f', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'cc842d6a-44f0-43bb-bb69-ef908b73fe20', true, 40, 1, '2026-09-03 10:32:23.318+05:30');
INSERT INTO public.item_availabilities VALUES ('4744c157-6300-475f-a877-34411325eadd', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', '3f7099b1-da18-4312-a11e-12f48633dc4e', true, 30, 1, '2026-09-03 10:32:23.326+05:30');
INSERT INTO public.item_availabilities VALUES ('235c23fc-4f0d-43d4-8bd3-58aa06b214ad', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', '2bd4e963-be58-42c5-91eb-3f63d74cb0c5', true, 100, 1, '2026-09-03 10:32:23.333+05:30');
INSERT INTO public.item_availabilities VALUES ('ec44c8c0-a838-4756-adc6-68be88033ccf', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', '4cbd98c3-315b-4ff1-ba2a-f4f70518974e', true, 100, 1, '2026-09-03 10:32:23.344+05:30');
INSERT INTO public.item_availabilities VALUES ('6a838517-2e6e-433a-96b0-fe93d7542cfe', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', '644b3bc8-d1b7-47bd-b53f-e18e968d0fbe', true, 40, 1, '2026-09-03 10:32:23.351+05:30');
INSERT INTO public.item_availabilities VALUES ('c28f340f-a8b2-45ea-9858-5d735eac5f3a', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', '7cbdb54d-5548-4015-8a1c-f552b44d7969', true, 35, 1, '2026-09-03 10:32:23.359+05:30');
INSERT INTO public.item_availabilities VALUES ('53396923-7ff1-415e-8576-cb16f2ff1d73', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', '6b8896c0-4bd9-48a0-98d6-19713f5d07d9', true, 35, 1, '2026-09-03 10:32:23.367+05:30');
INSERT INTO public.item_availabilities VALUES ('5895bd64-4b19-4176-b6bf-fcbef536f17f', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', '0e2be491-c42b-48a7-824a-db0771eaeb82', true, 30, 1, '2026-09-03 10:32:23.374+05:30');
INSERT INTO public.item_availabilities VALUES ('b40f446a-7436-4d08-9758-6aac941abfc6', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', '5cb91742-b4df-4d70-8692-c91eefde6866', true, 60, 1, '2026-09-03 10:32:23.383+05:30');
INSERT INTO public.item_availabilities VALUES ('80415256-4995-4035-904f-c7218711ae40', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', '30693bb3-881b-44f6-ac6c-22f7332f30e0', true, 60, 1, '2026-09-03 10:32:23.39+05:30');
INSERT INTO public.item_availabilities VALUES ('b2b524e7-111c-4357-860e-0391a39bfda5', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', '09243752-2184-4a1a-8c9e-e4d48b28daf3', true, 25, 1, '2026-09-03 10:32:23.399+05:30');
INSERT INTO public.item_availabilities VALUES ('729a9b59-66b5-46da-8f1b-f02db086bfc9', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', '91cc2ac5-560b-4ed8-b47c-b054a5e4a894', true, 30, 1, '2026-09-03 10:32:23.407+05:30');
INSERT INTO public.item_availabilities VALUES ('94e72390-8763-48fc-b0f7-3a34e7a4f263', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', '1c5f1c2c-33e0-4860-8160-e33667cb8fe9', true, 25, 1, '2026-09-03 10:32:23.415+05:30');
INSERT INTO public.item_availabilities VALUES ('5bcc3f9f-a4fc-4974-8abb-00fa8debe21f', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', '4d2be6bc-5508-4078-b978-adecd81938ef', true, 100, 1, '2026-09-03 10:32:23.424+05:30');
INSERT INTO public.item_availabilities VALUES ('4ab346ad-3c00-49b1-bbc6-e67f99dd968b', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', '73d6a534-563b-431f-b94f-2dd7c2ba8ed6', true, 100, 1, '2026-09-03 10:32:23.431+05:30');
INSERT INTO public.item_availabilities VALUES ('3a49815d-3ba9-4f67-9e4a-0085346d5f9a', '11111111-1111-1111-1111-111111111111', '59c5362c-66a6-4153-aef9-b8091d077995', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('0c7f312e-7ce9-41de-8370-f1cbdabb9a65', '11111111-1111-1111-1111-111111111111', '3ceb6db2-13a7-499a-ab4e-718843209e69', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('a4f768cd-aa98-4b39-8f1b-f919303394e5', '11111111-1111-1111-1111-111111111111', '7b7677d2-0c1a-4b8e-a937-88a8d764d21f', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('1ffa1e0d-3d95-4947-be04-b2f669882aa4', '11111111-1111-1111-1111-111111111111', '0df5690d-69e3-4bb0-ac07-fc91449e3a0f', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('5b6bdbb8-3982-476a-a6c4-7a637ec75804', '11111111-1111-1111-1111-111111111111', '02364da4-0994-4cd1-b37d-ff520665da94', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('4129670d-1e8f-4cee-8a7f-c608524b1ed5', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '51e725ae-ded2-49e5-bf40-21d2c161fb99', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('9275a09c-f7d9-42ef-b54a-ae15878f647a', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '90d5afa5-0f32-40a0-9b02-fafa2941487e', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('741e8e73-42ea-47be-9b48-3186bb26d852', '11111111-1111-1111-1111-111111111111', 'f7813575-802f-47bd-816d-936ebed9799c', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('06322472-3487-4012-bcd7-abef21e82f6e', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '2363163a-d94e-48b5-bbbd-26792a255cfb', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('32e89a6c-2eb5-4c2c-a143-770c903b9030', '11111111-1111-1111-1111-111111111111', 'dc37d5ad-bc4f-4b0a-82db-67d8e5852c12', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('c11cb40c-b676-477d-bcd9-58abdf4b2508', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '26281f6e-0d12-4867-a222-81c7f190ddef', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('724ba67c-bdde-404f-a4f7-91f445c07855', '11111111-1111-1111-1111-111111111111', 'e31e6867-c8f7-4c36-b3a2-1fea50e798da', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('f749db40-9a41-47be-b210-d5ca78354186', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '569fccc7-9acf-491a-8465-b8279f3008af', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('0748936c-5d3b-4c5b-8ce5-1d00af262edd', '11111111-1111-1111-1111-111111111111', '6cdbd658-ada4-4825-9904-5e3e79d4e35a', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('84c81042-426a-4e32-8577-043cb683afa6', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '0088e8ff-b85b-4fbe-9366-0bbeec1d88ef', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('7ecd829a-0313-4807-9cf8-485d4608d5ac', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '61e5132a-4de2-4d78-a7f1-51c44c16fb49', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('b377d815-7774-4c45-b090-e0aadf2620c5', '11111111-1111-1111-1111-111111111111', '96741261-a8bb-4341-b901-99d7d34847ad', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('a077cd9e-f781-4d8e-ae5a-6caddc2b2fc2', '11111111-1111-1111-1111-111111111111', '4472be98-66e1-4d19-870c-bff01714f9e6', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('8d41e22a-3b11-423e-87cd-6a39b005cb3d', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '0d5e3abc-3ecb-47e0-b419-a6b1e3de3f01', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('9730b463-87a7-4924-bff9-9547183385a1', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'd9519b46-7ca5-4a2a-bfa1-2374153b60a5', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('0f25ef66-22d7-42fa-9048-c4b0469311c1', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'd6a5afe2-31be-4c45-9470-f016e5309ddd', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('e96881dc-719a-490e-99e1-a082866b901a', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '79029b8b-4a81-4383-a6d7-9ca840782d62', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('3b7a97c8-1478-483e-8f68-63da470de286', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'd77fe08a-046b-4c0f-8830-48b593a8fbbe', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('9ba773bf-0bef-4fb3-be91-c1a03be41935', '11111111-1111-1111-1111-111111111111', '519bf5b7-40ff-4d77-89f2-ebec06547bae', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('63155694-88c6-4ef1-b729-839f0812a2f8', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', '7e8fac56-b8d3-4ca0-9872-fd795eda092d', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('e993f8f2-9451-4f44-9df1-b0fc0b31d7eb', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'aebc111c-1f92-47e9-881b-7c3820e5ff2f', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('7d0dc080-1d4d-4003-b734-d5e35d38a29d', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '811cd2fc-40da-469c-bf50-c292c811f6b6', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('afd9e4db-6314-4980-97a4-888a24f193b4', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '7a13bf5c-8ba3-4abb-b5f1-56426fdf025e', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('76d8af53-42e9-469e-aeb3-350096f6ad80', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', '9cf42fe2-6bbd-46c7-86f9-c8695530f757', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('6149b4a8-629b-4fb6-b998-df5c37ad7a5d', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '4109efd3-e894-4bff-ba91-ba8be0c5daf2', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('793dbb6f-0e65-41a2-be5f-6ad212b3cf3c', '11111111-1111-1111-1111-111111111111', '75272f16-e542-4bd9-9de6-49352d62929b', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('c7a36cb5-3521-4613-a5ce-da5fc017b873', '11111111-1111-1111-1111-111111111111', 'b1d7d0ac-e478-43d9-8494-0d4f6a9580eb', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('3c3c7493-aeac-4987-854a-842fcbe14bff', '11111111-1111-1111-1111-111111111111', 'b4da7948-a826-4870-bfc9-bbdd92db1975', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('d460a311-7ef6-429d-a14d-727ce1b2f03b', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'edc6665e-f238-411c-aaad-edcbf556c22d', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('2cc3ecb7-55b9-41e1-a9ed-5f0d5b078d7f', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'ec478730-9b61-4be3-bc0b-ea7243c1bdfd', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('1af2063f-f765-4216-a2dc-afd609bff3b8', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '59846ee3-f19f-4d30-beac-11c4701a2ef9', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('15f3ac79-cc28-4e7a-8617-bfdf05e065c2', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'e5c773ed-467f-4411-8207-09782ae6df6d', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('1e5d6b49-d068-410a-9fda-3d35281c2b87', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'cd411cd1-7671-489b-a7f8-937eafb20e72', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('46ef42a2-77a6-4924-98a5-97759ee0a073', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', '2b716fe4-6deb-41cb-8639-2523d9e6b74e', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('b980bc67-54e7-488b-96e4-d3bd616469e8', '11111111-1111-1111-1111-111111111111', '5ce8b459-2fb3-41fd-abaa-446137a7aa6e', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('cb18bab8-8673-4189-b209-a2c2fdddfd2e', '11111111-1111-1111-1111-111111111111', '67825178-175f-4708-a692-084dcec3e328', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('529367fd-61eb-429c-8d32-d692e55414c8', '11111111-1111-1111-1111-111111111111', '4c748f68-bca2-4f38-b9b3-23d71a314ae8', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('ac00ffac-c048-4d4f-9d30-f77a6c01e378', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '2ff5764f-2bda-49fc-bb3d-c8bf2cc91adc', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('098a9264-dbfc-4f4c-979d-48f207a050b2', '11111111-1111-1111-1111-111111111111', '9a77c8e6-8ae4-4f2c-88ad-88ee1fc58211', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('566b1345-36c2-4423-a557-0803e46fd495', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'e7b67d41-a6a1-478c-a6ba-5a29b9f8f71f', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('423331ce-a28c-470a-baa2-805492afbdda', '11111111-1111-1111-1111-111111111111', 'fc64c535-fa89-42c7-9857-81ef2ef9ce35', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('dba21789-e615-490d-9740-9cd7961ce9e0', '11111111-1111-1111-1111-111111111111', '0e966d3c-b0a7-49c5-975e-c9040121ad18', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('542fa446-bea0-4392-9e15-f1ad09e355f1', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '1a95da75-6d6b-4041-9142-36b2353b33b2', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('3ccee41c-6285-45b9-9d31-7bab4f81a263', '11111111-1111-1111-1111-111111111111', 'a8652e18-bfd0-42c8-b06e-c8d0621c8ef1', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('7d0470e9-6ac0-4ae6-899a-56b2453decec', '11111111-1111-1111-1111-111111111111', 'd43a31ce-8564-4f1b-96fa-f42efe50791b', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('cef0fa0a-f3e6-4e40-a6e9-18730851e57d', '11111111-1111-1111-1111-111111111111', '5426f52c-ff30-4b56-aa31-d737a5a1502c', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('283d4b0d-5d28-429c-aa69-b9e2e184a58a', '11111111-1111-1111-1111-111111111111', 'b5bce0e8-0dfd-43a9-b272-608c930daf86', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('1b221462-4fbb-490d-aecd-26278a1c41a8', '11111111-1111-1111-1111-111111111111', '29052e1b-de49-421b-9711-c5c17820b257', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('d76229a8-48b5-4739-8b20-670ec213be80', '11111111-1111-1111-1111-111111111111', '40e0a11f-f68a-4ed3-b229-4b35da1a8f5d', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('3abc33c1-cc2e-4319-bbca-bfb1cfdcd7c8', '11111111-1111-1111-1111-111111111111', 'af6e91e6-6cd5-4c9e-961e-246f98689e31', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('b6b7937c-51a3-4096-8e40-910048135d60', '11111111-1111-1111-1111-111111111111', 'ba9264dc-e5b8-4c0c-9422-d78852aa8c72', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('bbaa5a80-e286-4ce2-8964-597192c4b054', '11111111-1111-1111-1111-111111111111', 'eda1dd36-db44-4dc9-b2d1-21cc41a1ff0f', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('df1c12d6-ad3a-4690-9709-4d6c7a426a63', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '1a13319b-1192-4018-9399-6bd0c762ec2c', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('f32c5a78-6fd5-48b1-bad8-bb6081e21510', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'f1c59198-e405-4271-9360-0dcaec24dee2', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');
INSERT INTO public.item_availabilities VALUES ('efdf1ef1-8376-4d81-a4d3-4f7a82dea7df', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', '316f8471-27fe-438b-9961-002b66f96f45', true, 100, 1, '2026-09-05 13:03:59.203157+05:30');


--
-- Data for Name: item_availability; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.item_availability VALUES ('28d5fb27-7215-446e-8f56-54cad7f22ae3', '11111111-1111-1111-1111-111111111111', '5426f52c-ff30-4b56-aa31-d737a5a1502c', '11111111-1111-1111-1111-111111111111', 'OFF', 2, '2026-09-04 16:38:54.333+05:30', '2026-09-04 16:38:54.333+05:30', '4bc4d34d-f0d4-4402-ae14-2ab128803657', '4bc4d34d-f0d4-4402-ae14-2ab128803657', 100);
INSERT INTO public.item_availability VALUES ('cf586e42-d6ad-4ceb-a72f-bace0707064e', '11111111-1111-1111-1111-111111111111', 'b4da7948-a826-4870-bfc9-bbdd92db1975', '11111111-1111-1111-1111-111111111111', 'OFF', 2, '2026-09-04 16:38:59.402+05:30', '2026-09-04 16:38:59.402+05:30', '4bc4d34d-f0d4-4402-ae14-2ab128803657', '4bc4d34d-f0d4-4402-ae14-2ab128803657', 100);


--
-- Data for Name: item_commissions; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: item_modifier_groups; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: item_prices; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: item_sales_summary; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: item_variants; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: kot_items; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.kot_items VALUES ('c18d625a-dd7c-4346-977b-216d32a4e01b', 'd3faf64c-a468-4a3c-9f63-cf675d11d56e', 'a0e7da8d-2be8-42d7-9448-794ec1578ce0', 2, NULL, NULL, NULL, '3cc60bc4-3338-4dcb-a44f-3a4dc5639085', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', NULL, NULL);
INSERT INTO public.kot_items VALUES ('7df167de-b6dc-4593-805f-6de1fee850c8', '11839c6b-1193-48e0-9c16-4e242e44106d', '5426f52c-ff30-4b56-aa31-d737a5a1502c', 1, NULL, 'STARTER', NULL, '1d6763f3-124b-4ae3-91db-c1a6f2f74e07', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('782bf9aa-5f35-4525-9cc8-f26059833a2a', '7a94e653-85d5-4825-9cc8-4b766249b73d', 'f7813575-802f-47bd-816d-936ebed9799c', 1, NULL, 'STARTER', NULL, '5b9ed80e-9f3d-4874-b56f-696dba9fd28f', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('348c3832-26a5-4cdf-b7d9-7c355f0a9851', '6647e48a-7b34-4e69-8f44-80aab388f23a', '96741261-a8bb-4341-b901-99d7d34847ad', 1, NULL, 'STARTER', '2026-09-03 16:23:02.252+05:30', '4e589a3e-d777-4cd1-b3df-28e57ca46944', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('0a7196eb-35d2-4302-9591-c33bee356a38', 'ce1e42fa-a953-4668-b291-9b88328a0079', '519bf5b7-40ff-4d77-89f2-ebec06547bae', 1, NULL, 'STARTER', '2026-09-03 16:23:43.795+05:30', '69f551b6-2be8-4c7f-83ca-8f41da74e231', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('98cc98e4-cda4-4f41-a8bd-a0162c3c84ad', 'a0a2fc18-0dbc-4209-b9b9-c8fcda1db8e2', 'a8652e18-bfd0-42c8-b06e-c8d0621c8ef1', 1, NULL, 'STARTER', '2026-09-03 16:26:18.017+05:30', 'b36724da-1b39-4e0b-8eb8-d1a6e1dfc404', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('8cc22251-9c4b-4106-92b8-4ac34017ceb2', '6b9356fd-ad0c-4dfe-b8b1-a030468a7ebd', '02364da4-0994-4cd1-b37d-ff520665da94', 1, NULL, NULL, NULL, '25ae1596-531c-4081-92b7-c448fbe4a7d0', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('c2725a6e-6661-4050-98bc-0b17d56e83e3', '1144604b-a415-4210-859b-b488d761c6b3', '02364da4-0994-4cd1-b37d-ff520665da94', 1, NULL, 'STARTER', '2026-09-04 16:41:31.562+05:30', 'cde05d25-2935-4595-9fff-eab9ea049e09', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('4a6c5f79-501c-46f5-bc2e-d215b5bf1be5', '707fb05e-a235-4107-9643-7e313d1e6219', 'b4da7948-a826-4870-bfc9-bbdd92db1975', 1, NULL, 'STARTER', '2026-09-04 16:41:33.444+05:30', 'fd613879-65ea-4848-b328-6b8d9f9ed70c', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('41412110-df9f-429b-89b9-d1022e59e10c', 'd09756c6-0cf8-4fd1-b43a-f439fcecd251', '3ceb6db2-13a7-499a-ab4e-718843209e69', 1, NULL, 'STARTER', NULL, '45832125-c5d7-4941-a8d2-11f2464d2e4d', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('1725d6ba-1110-482f-8984-0c24e143c10c', '376e86a7-f796-460e-a4f1-2234fe7857f9', '4c748f68-bca2-4f38-b9b3-23d71a314ae8', 1, NULL, 'STARTER', NULL, '269411c2-20e3-40cf-9b44-fa9239a8e14b', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('4a5346db-6cb5-4300-a829-b67024a6211c', 'cc1bc8c7-db05-4403-a034-de00d0a98e49', '0e966d3c-b0a7-49c5-975e-c9040121ad18', 1, NULL, 'STARTER', NULL, '865dc3f6-0a77-4145-a8d5-d55c0fc11518', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('9f9f02b7-ac63-440b-9c4e-6af8915fe27e', 'cc1bc8c7-db05-4403-a034-de00d0a98e49', '519bf5b7-40ff-4d77-89f2-ebec06547bae', 1, NULL, 'STARTER', NULL, 'baf9cf9f-4804-4fdc-9b62-5a88b6697706', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('bce8fad4-df9b-4ef5-aa0f-032b11f1420c', 'cc1bc8c7-db05-4403-a034-de00d0a98e49', 'e31e6867-c8f7-4c36-b3a2-1fea50e798da', 1, NULL, 'STARTER', NULL, 'c8955bf6-d02d-4826-ac2a-f45994824ce5', '11111111-1111-1111-1111-111111111111', NULL, NULL);


--
-- Data for Name: kot_performance; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: kot_status_history; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.kot_status_history VALUES ('4ccd30c7-2fc4-49eb-b230-5597cfbfa3eb', '11839c6b-1193-48e0-9c16-4e242e44106d', 'QUEUED', NULL, '2026-09-03 16:15:54.426+05:30');
INSERT INTO public.kot_status_history VALUES ('11d7f2c6-ad1c-4896-a79f-1223748ed959', '7a94e653-85d5-4825-9cc8-4b766249b73d', 'QUEUED', NULL, '2026-09-03 16:21:04.17+05:30');
INSERT INTO public.kot_status_history VALUES ('814681db-2082-435a-9373-025b7819574a', '6647e48a-7b34-4e69-8f44-80aab388f23a', 'QUEUED', NULL, '2026-09-03 16:22:16.597+05:30');
INSERT INTO public.kot_status_history VALUES ('b007fcde-aff1-4375-83b1-eb21ba0d5176', '6647e48a-7b34-4e69-8f44-80aab388f23a', 'PREPARING', NULL, '2026-09-03 16:22:42.672+05:30');
INSERT INTO public.kot_status_history VALUES ('40a8b7aa-daa9-461d-a8b0-2921eea9e533', '6647e48a-7b34-4e69-8f44-80aab388f23a', 'READY', NULL, '2026-09-03 16:22:54.658+05:30');
INSERT INTO public.kot_status_history VALUES ('2a581a73-6ca7-4953-9599-c30773b58986', '6647e48a-7b34-4e69-8f44-80aab388f23a', 'SERVED', NULL, '2026-09-03 16:23:02.261+05:30');
INSERT INTO public.kot_status_history VALUES ('6c29d49f-5d4c-4139-b745-eb90bf1b39d8', 'ce1e42fa-a953-4668-b291-9b88328a0079', 'QUEUED', NULL, '2026-09-03 16:23:21.534+05:30');
INSERT INTO public.kot_status_history VALUES ('c69fc6dc-aa26-40c7-80a2-6f9cd9c1a566', 'ce1e42fa-a953-4668-b291-9b88328a0079', 'PREPARING', NULL, '2026-09-03 16:23:35.662+05:30');
INSERT INTO public.kot_status_history VALUES ('24579b73-fdb5-4899-81aa-7133da0ef96d', 'ce1e42fa-a953-4668-b291-9b88328a0079', 'READY', NULL, '2026-09-03 16:23:36.964+05:30');
INSERT INTO public.kot_status_history VALUES ('fcdbba20-0ba6-4058-9e6b-245b395374ce', 'ce1e42fa-a953-4668-b291-9b88328a0079', 'SERVED', NULL, '2026-09-03 16:23:43.802+05:30');
INSERT INTO public.kot_status_history VALUES ('f705ed59-cb64-41ae-96c7-a7397dd1c241', 'a0a2fc18-0dbc-4209-b9b9-c8fcda1db8e2', 'QUEUED', NULL, '2026-09-03 16:23:58.586+05:30');
INSERT INTO public.kot_status_history VALUES ('7828ac30-20e8-479c-be63-6f0227b71232', 'a0a2fc18-0dbc-4209-b9b9-c8fcda1db8e2', 'PREPARING', NULL, '2026-09-03 16:24:10.815+05:30');
INSERT INTO public.kot_status_history VALUES ('a2f16dd1-9d16-4a8d-bd3a-1ab3babf2c66', 'a0a2fc18-0dbc-4209-b9b9-c8fcda1db8e2', 'READY', NULL, '2026-09-03 16:24:14.124+05:30');
INSERT INTO public.kot_status_history VALUES ('5334d330-5227-4a98-a0b4-d15510c07325', 'a0a2fc18-0dbc-4209-b9b9-c8fcda1db8e2', 'SERVED', NULL, '2026-09-03 16:26:18.024+05:30');
INSERT INTO public.kot_status_history VALUES ('69ed1a4c-706b-49d9-816e-b266341edf6f', '707fb05e-a235-4107-9643-7e313d1e6219', 'QUEUED', NULL, '2026-09-03 17:41:44.336+05:30');
INSERT INTO public.kot_status_history VALUES ('a9097aa2-58ea-4d10-8625-0caf100b7058', '1144604b-a415-4210-859b-b488d761c6b3', 'QUEUED', NULL, '2026-09-04 16:22:34.519+05:30');
INSERT INTO public.kot_status_history VALUES ('f50f0222-8242-4620-988f-578aa3896bbb', '7a94e653-85d5-4825-9cc8-4b766249b73d', 'PREPARING', NULL, '2026-09-04 16:23:17.443+05:30');
INSERT INTO public.kot_status_history VALUES ('5ee3c508-5530-4cd8-a60a-282c86dc556b', '7a94e653-85d5-4825-9cc8-4b766249b73d', 'READY', NULL, '2026-09-04 16:23:19.095+05:30');
INSERT INTO public.kot_status_history VALUES ('bd89b0af-7d19-4f20-bf6a-f1b7896068fe', '707fb05e-a235-4107-9643-7e313d1e6219', 'READY', NULL, '2026-09-04 16:23:22.338+05:30');
INSERT INTO public.kot_status_history VALUES ('bb3a9239-b02d-46b8-9da0-5a8f947ad13a', '1144604b-a415-4210-859b-b488d761c6b3', 'READY', NULL, '2026-09-04 16:23:23.71+05:30');
INSERT INTO public.kot_status_history VALUES ('fb666389-4627-4b23-8e38-0876cf9e2001', '11839c6b-1193-48e0-9c16-4e242e44106d', 'READY', NULL, '2026-09-04 16:23:26.274+05:30');
INSERT INTO public.kot_status_history VALUES ('ca2cd86c-8716-4f98-9fed-049cb9d7247d', '6b9356fd-ad0c-4dfe-b8b1-a030468a7ebd', 'QUEUED', NULL, '2026-09-04 16:40:24.943+05:30');
INSERT INTO public.kot_status_history VALUES ('f1cec7c4-f9c8-472a-b098-a1ff15592e7c', '6b9356fd-ad0c-4dfe-b8b1-a030468a7ebd', 'READY', NULL, '2026-09-04 16:40:57.807+05:30');
INSERT INTO public.kot_status_history VALUES ('c7d35a52-cec9-45c9-aa6a-450544d777b0', '1144604b-a415-4210-859b-b488d761c6b3', 'SERVED', NULL, '2026-09-04 16:41:31.571+05:30');
INSERT INTO public.kot_status_history VALUES ('5bf2a7c6-33c6-4194-b094-c0874b4e0706', '707fb05e-a235-4107-9643-7e313d1e6219', 'SERVED', NULL, '2026-09-04 16:41:33.449+05:30');
INSERT INTO public.kot_status_history VALUES ('98dcfc10-ca6c-4433-bbd3-105a9973cff5', 'd09756c6-0cf8-4fd1-b43a-f439fcecd251', 'QUEUED', NULL, '2026-09-04 16:57:45.131+05:30');
INSERT INTO public.kot_status_history VALUES ('9f204d18-28c4-470d-81bf-748bfaef7566', 'd09756c6-0cf8-4fd1-b43a-f439fcecd251', 'READY', NULL, '2026-09-04 16:57:58.927+05:30');
INSERT INTO public.kot_status_history VALUES ('fb27ede2-a5f8-40e5-aa14-a90f2ed2c29b', '376e86a7-f796-460e-a4f1-2234fe7857f9', 'QUEUED', NULL, '2026-09-07 14:35:48.386+05:30');
INSERT INTO public.kot_status_history VALUES ('b37d3659-5f54-41b0-a648-5d0c3d0b3273', 'cc1bc8c7-db05-4403-a034-de00d0a98e49', 'QUEUED', NULL, '2026-09-07 14:59:25.419+05:30');
INSERT INTO public.kot_status_history VALUES ('cad45127-2d26-4a74-8a37-2313a4409380', 'cc1bc8c7-db05-4403-a034-de00d0a98e49', 'READY', NULL, '2026-09-07 14:59:36.264+05:30');
INSERT INTO public.kot_status_history VALUES ('3c8a27c6-aa54-400b-8940-fc68a3733a4c', '376e86a7-f796-460e-a4f1-2234fe7857f9', 'READY', NULL, '2026-09-07 14:59:38.75+05:30');


--
-- Data for Name: kot_tickets; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.kot_tickets VALUES ('d3faf64c-a468-4a3c-9f63-cf675d11d56e', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '2f066396-49ed-4838-89f4-ec49b387a188', '12beb15e-bf9c-4faf-a425-3cec84973301', 'KOT-101', 'QUEUED', '2026-09-03 12:30:36.179926+05:30', '2026-09-03 12:30:36.179926+05:30', NULL, NULL);
INSERT INTO public.kot_tickets VALUES ('6647e48a-7b34-4e69-8f44-80aab388f23a', '11111111-1111-1111-1111-111111111111', 'fefda5cf-8409-441a-8e3a-a803c36fb2ce', NULL, 'KOT-1788432736586-833', 'SERVED', '2026-09-03 16:22:16.592+05:30', '2026-09-03 16:23:02.257+05:30', '2026-09-03 16:23:02.252+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('ce1e42fa-a953-4668-b291-9b88328a0079', '11111111-1111-1111-1111-111111111111', 'fefda5cf-8409-441a-8e3a-a803c36fb2ce', NULL, 'KOT-1788432801526-897', 'SERVED', '2026-09-03 16:23:21.529+05:30', '2026-09-03 16:23:43.797+05:30', '2026-09-03 16:23:43.795+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('a0a2fc18-0dbc-4209-b9b9-c8fcda1db8e2', '11111111-1111-1111-1111-111111111111', 'fefda5cf-8409-441a-8e3a-a803c36fb2ce', NULL, 'KOT-1788432838579-657', 'SERVED', '2026-09-03 16:23:58.583+05:30', '2026-09-03 16:26:18.019+05:30', '2026-09-03 16:26:18.017+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('7a94e653-85d5-4825-9cc8-4b766249b73d', '11111111-1111-1111-1111-111111111111', '9b477c95-d76b-4976-b745-a7a2ef4d4b14', NULL, 'KOT-1788432664160-334', 'SERVED', '2026-09-03 16:21:04.163+05:30', '2026-09-04 16:38:27.25+05:30', '2026-09-04 16:38:27.248+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('11839c6b-1193-48e0-9c16-4e242e44106d', '11111111-1111-1111-1111-111111111111', '9b477c95-d76b-4976-b745-a7a2ef4d4b14', NULL, 'KOT-1788432354414-410', 'SERVED', '2026-09-03 16:15:54.421+05:30', '2026-09-04 16:38:27.25+05:30', '2026-09-04 16:38:27.248+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('6b9356fd-ad0c-4dfe-b8b1-a030468a7ebd', '11111111-1111-1111-1111-111111111111', '2a670867-a3af-4698-aa9a-84afa3fb7e04', NULL, 'KOT-1788520224932-904', 'SERVED', '2026-09-04 16:40:24.938+05:30', '2026-09-04 16:41:05.216+05:30', '2026-09-04 16:41:05.215+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('1144604b-a415-4210-859b-b488d761c6b3', '11111111-1111-1111-1111-111111111111', '08b726d5-cac2-48d9-b036-a668d5bf7066', NULL, 'KOT-1788519154492-519', 'SERVED', '2026-09-04 16:22:34.509+05:30', '2026-09-04 16:41:31.564+05:30', '2026-09-04 16:41:31.562+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('707fb05e-a235-4107-9643-7e313d1e6219', '11111111-1111-1111-1111-111111111111', 'c14e4df0-40c4-430e-b162-d015a4964c84', NULL, 'KOT-1788437504328-618', 'SERVED', '2026-09-03 17:41:44.331+05:30', '2026-09-04 16:41:33.445+05:30', '2026-09-04 16:41:33.444+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('d09756c6-0cf8-4fd1-b43a-f439fcecd251', '11111111-1111-1111-1111-111111111111', 'e50cff2e-3302-416f-8cb8-82d28229ef6f', NULL, 'KOT-1788521265124-697', 'READY', '2026-09-04 16:57:45.126+05:30', '2026-09-04 16:57:58.922+05:30', NULL, NULL);
INSERT INTO public.kot_tickets VALUES ('cc1bc8c7-db05-4403-a034-de00d0a98e49', '11111111-1111-1111-1111-111111111111', 'be05502d-64d3-4721-9b8d-270fb383a20f', NULL, 'KOT-1788773365405-320', 'SERVED', '2026-09-07 14:59:25.41+05:30', '2026-09-07 14:59:52.528+05:30', '2026-09-07 14:59:52.523+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('376e86a7-f796-460e-a4f1-2234fe7857f9', '11111111-1111-1111-1111-111111111111', 'be05502d-64d3-4721-9b8d-270fb383a20f', NULL, 'KOT-1788771948359-366', 'SERVED', '2026-09-07 14:35:48.376+05:30', '2026-09-07 14:59:52.531+05:30', '2026-09-07 14:59:52.526+05:30', NULL);


--
-- Data for Name: ledger_entries; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.ledger_entries VALUES ('13aac6e1-a6fc-4252-88f8-698e14a93687', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'SETTLEMENT', 'OPENING-BAL-1010-CASH', '1010-CASH', 500000, 0, 'OPENING-VOUCHER-1010-CASH', 'POSTED', '2026-09-02 14:04:04.182+05:30', '2026-09-02 14:04:04.179+05:30');
INSERT INTO public.ledger_entries VALUES ('6a23fd4d-52f1-4fae-b24d-83b6043f477c', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'SETTLEMENT', 'OPENING-BAL-1020-BANK-HDFC', '1020-BANK-HDFC', 2500000, 0, 'OPENING-VOUCHER-1020-BANK-HDFC', 'POSTED', '2026-09-02 14:04:04.192+05:30', '2026-09-02 14:04:04.191+05:30');
INSERT INTO public.ledger_entries VALUES ('3403d222-3bf9-44e5-8454-ac294fb323ed', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'SETTLEMENT', 'OPENING-BAL-EQUITY', '3010-OWNERS-CAPITAL', 0, 3000000, 'OPENING-VOUCHER-EQUITY', 'POSTED', '2026-09-02 14:04:04.195+05:30', '2026-09-02 14:04:04.194+05:30');
INSERT INTO public.ledger_entries VALUES ('3123b49d-1816-4bac-aa24-ed73ae2d9d62', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'SETTLEMENT', 'OPENING-BAL-1010-CASH', '1010-CASH', 500000, 0, 'OPENING-VOUCHER-1010-CASH', 'POSTED', '2026-09-03 11:13:54.464+05:30', '2026-09-03 11:13:54.445+05:30');
INSERT INTO public.ledger_entries VALUES ('ec908944-1749-44a4-910c-bd3c8c833470', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'SETTLEMENT', 'OPENING-BAL-1020-BANK-HDFC', '1020-BANK-HDFC', 2500000, 0, 'OPENING-VOUCHER-1020-BANK-HDFC', 'POSTED', '2026-09-03 11:13:54.481+05:30', '2026-09-03 11:13:54.464+05:30');
INSERT INTO public.ledger_entries VALUES ('5278ccd6-9563-4136-a00d-5171e6fe88d6', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'SETTLEMENT', 'OPENING-BAL-EQUITY', '3010-OWNERS-CAPITAL', 0, 3000000, 'OPENING-VOUCHER-EQUITY', 'POSTED', '2026-09-03 11:13:54.484+05:30', '2026-09-03 11:13:54.467+05:30');
INSERT INTO public.ledger_entries VALUES ('3475e7db-c46a-4434-a9f2-ab3128a18bfa', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'SETTLEMENT', 'OPENING-BAL-1010-CASH', '1010-CASH', 500000, 0, 'OPENING-VOUCHER-1010-CASH', 'POSTED', '2026-09-03 11:17:37.592+05:30', '2026-09-03 11:17:37.57+05:30');
INSERT INTO public.ledger_entries VALUES ('5eed436b-e9e9-4f85-b70e-580a0bb20f38', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'SETTLEMENT', 'OPENING-BAL-1020-BANK-HDFC', '1020-BANK-HDFC', 2500000, 0, 'OPENING-VOUCHER-1020-BANK-HDFC', 'POSTED', '2026-09-03 11:17:37.6+05:30', '2026-09-03 11:17:37.583+05:30');
INSERT INTO public.ledger_entries VALUES ('4b4ba2ee-a0e9-41c8-a714-3e3a3f3e67e0', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'SETTLEMENT', 'OPENING-BAL-EQUITY', '3010-OWNERS-CAPITAL', 0, 3000000, 'OPENING-VOUCHER-EQUITY', 'POSTED', '2026-09-03 11:17:37.603+05:30', '2026-09-03 11:17:37.586+05:30');


--
-- Data for Name: loyalty_accounts; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: marketing_campaigns; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.marketing_campaigns VALUES ('b579c8c2-8383-4ace-bdfc-fe8597965326', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Weekend Biryani Fest', 'MANUAL', NULL, NULL, 'Enjoy 20% off on all signature biryanis this weekend at Hotel Kapila! Show code BIRYANI20 at billing.', 'ACTIVE', '2026-09-03 12:29:04.396935+05:30', '2026-09-03 12:29:04.396935+05:30', 'd119207c-8cf7-4a03-8125-6737c85c210d');


--
-- Data for Name: menu_categories; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.menu_categories VALUES ('5be6ea43-5233-4f9d-bd96-b7bda6062add', '11111111-1111-1111-1111-111111111111', 'Chinese Starters (Veg)', NULL, 0, true, '2026-09-03 13:45:52.992979+05:30', '2026-09-03 13:45:52.992979+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('5851bf60-bfe0-4e8f-965d-16bcb418dc5c', '11111111-1111-1111-1111-111111111111', 'Curries (Non-Veg)', NULL, 0, true, '2026-09-03 13:45:52.994468+05:30', '2026-09-03 13:45:52.994468+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('096f0a82-e581-45f1-9d92-522ebe5c2f7a', '11111111-1111-1111-1111-111111111111', 'Biryani (Veg)', NULL, 0, true, '2026-09-03 13:45:52.998118+05:30', '2026-09-03 13:45:52.998118+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('25b36641-61fa-4884-a3d8-e5ced013533a', '11111111-1111-1111-1111-111111111111', 'MOCKTAILS', NULL, 0, true, '2026-09-03 13:45:52.999887+05:30', '2026-09-03 13:45:52.999887+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('aacd159c-c694-4a0a-9420-3d4fc651f26e', '11111111-1111-1111-1111-111111111111', 'Roti & Breads', NULL, 0, true, '2026-09-03 13:45:53.00153+05:30', '2026-09-03 13:45:53.00153+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('f5fd13c7-2ff4-42eb-8ba5-e4e7d8321ecd', '11111111-1111-1111-1111-111111111111', 'Curries (Veg)', NULL, 0, true, '2026-09-03 13:45:53.002864+05:30', '2026-09-03 13:45:53.002864+05:30', 'Paneer and mixed vegetable curries');
INSERT INTO public.menu_categories VALUES ('229bdc16-1471-4b21-b75f-d58b6aeb3aad', '11111111-1111-1111-1111-111111111111', 'Meals', NULL, 0, true, '2026-09-03 13:45:53.004505+05:30', '2026-09-03 13:45:53.004505+05:30', 'South & North Indian Full Meals');
INSERT INTO public.menu_categories VALUES ('fe5d30c0-8990-4e3d-bc02-c3eab0399b0b', '11111111-1111-1111-1111-111111111111', 'Cold Beverage', NULL, 0, true, '2026-09-03 13:45:53.006646+05:30', '2026-09-03 13:45:53.006646+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('157b592c-2b8a-4c9d-80b0-3ca17272ca5e', '11111111-1111-1111-1111-111111111111', 'Breakfast', NULL, 0, true, '2026-09-03 13:45:53.008684+05:30', '2026-09-03 13:45:53.008684+05:30', 'Traditional South Indian Breakfast');
INSERT INTO public.menu_categories VALUES ('6f5f9db9-2d68-4acf-8773-2a224b80fb33', '11111111-1111-1111-1111-111111111111', 'Tandoori Starters (Non-Veg)', NULL, 0, true, '2026-09-03 13:45:53.010831+05:30', '2026-09-03 13:45:53.010831+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('f001972a-1b1f-4e9c-bb87-9a5520149635', '11111111-1111-1111-1111-111111111111', 'Hot Beverages', NULL, 0, true, '2026-09-03 13:45:53.012915+05:30', '2026-09-03 13:45:53.012915+05:30', 'Filter coffee, tea and soups');
INSERT INTO public.menu_categories VALUES ('7553eb9c-4449-44f1-a196-a9c3c2f7c4ad', '11111111-1111-1111-1111-111111111111', 'Soup(Veg)', NULL, 0, true, '2026-09-03 13:45:53.014562+05:30', '2026-09-03 13:45:53.014562+05:30', 'Vegetarian hot soups');
INSERT INTO public.menu_categories VALUES ('5ffb7578-d7c4-491d-b516-98c10edacb0c', '11111111-1111-1111-1111-111111111111', 'Biryani (Non-Veg)', NULL, 0, true, '2026-09-03 13:45:53.017097+05:30', '2026-09-03 13:45:53.017097+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('e581a9b0-daa4-4d6f-9f14-7623638c1dc7', '11111111-1111-1111-1111-111111111111', 'Meal Box (Online)', NULL, 0, true, '2026-09-03 13:45:53.020547+05:30', '2026-09-03 13:45:53.020547+05:30', 'Combo meal boxes for delivery');
INSERT INTO public.menu_categories VALUES ('2c8a1a6d-8257-4dc5-a1ce-22a1975717aa', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Biryani (Veg)', NULL, 1, true, '2026-09-02 13:55:19.762+05:30', '2026-09-02 14:00:07.259+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('895fae56-fa21-4a24-8e10-25f56a5ec629', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Biryani (Non-Veg)', NULL, 2, true, '2026-09-02 13:55:19.767+05:30', '2026-09-02 14:00:07.263+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('c0c8dc4f-e74a-45f9-a2f6-892260dc9c65', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Tandoori Starters (Non-Veg)', NULL, 3, true, '2026-09-02 13:55:19.772+05:30', '2026-09-02 14:00:07.266+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('3ad7d066-bb51-4718-89e2-5264d84bd53d', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Chinese Starters (Veg)', NULL, 4, true, '2026-09-02 13:55:19.776+05:30', '2026-09-02 14:00:07.269+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('97ec719b-634c-4b55-bdad-62c2d6d368a1', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Curries (Non-Veg)', NULL, 5, true, '2026-09-02 13:55:19.779+05:30', '2026-09-02 14:00:07.272+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('067d3f46-fb3c-4441-b7fd-5ef1d99f3909', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Roti & Breads', NULL, 6, true, '2026-09-02 13:55:19.783+05:30', '2026-09-02 14:00:07.275+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('09bc0c5c-5de3-4fcd-9105-36662e07c094', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Cold Beverage', NULL, 7, true, '2026-09-02 13:55:19.786+05:30', '2026-09-02 14:00:07.277+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('b0c93372-0583-4d68-a2bf-670bfd6188b4', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'MOCKTAILS', NULL, 8, true, '2026-09-02 13:55:19.789+05:30', '2026-09-02 14:00:07.28+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('f11e02ac-e172-4c7c-bdb5-c60f06a11401', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'Breakfast', NULL, 1, true, '2026-09-02 14:04:31.055+05:30', '2026-09-03 10:32:23.184+05:30', 'Traditional South Indian Breakfast');
INSERT INTO public.menu_categories VALUES ('2b27795c-af81-402a-96fd-b8558e24f023', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'Meal Box (Online)', NULL, 2, true, '2026-09-02 14:04:31.059+05:30', '2026-09-03 10:32:23.188+05:30', 'Combo meal boxes for delivery');
INSERT INTO public.menu_categories VALUES ('fd9b3cf0-049c-450e-bf0e-d9268601b489', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'Cold Beverage', NULL, 3, true, '2026-09-02 14:04:31.063+05:30', '2026-09-03 10:32:23.192+05:30', 'Chilled juices, lassi and soft drinks');
INSERT INTO public.menu_categories VALUES ('313fa379-9d5f-489c-b340-cdfc26b9e2f0', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'Hot Beverages', NULL, 4, true, '2026-09-02 14:04:31.067+05:30', '2026-09-03 10:32:23.198+05:30', 'Filter coffee, tea and soups');
INSERT INTO public.menu_categories VALUES ('d2ae476b-6ec7-4f2c-99f9-ac33348edef3', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'Soup(Veg)', NULL, 5, true, '2026-09-02 14:04:31.072+05:30', '2026-09-03 10:32:23.203+05:30', 'Vegetarian hot soups');
INSERT INTO public.menu_categories VALUES ('ab6acda0-8623-4a02-b314-33f3334ec096', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'Meals', NULL, 6, true, '2026-09-02 14:04:31.076+05:30', '2026-09-03 10:32:23.207+05:30', 'South & North Indian Full Meals');
INSERT INTO public.menu_categories VALUES ('cf8cf1dc-f1bd-433f-86bc-b928725d0a01', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'Chinese Starters (Veg)', NULL, 7, true, '2026-09-02 14:04:31.08+05:30', '2026-09-03 10:32:23.211+05:30', 'Crispy veg appetizers');
INSERT INTO public.menu_categories VALUES ('961b4ae7-5599-4a34-a010-c26d2482f8fc', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'Curries (Veg)', NULL, 8, true, '2026-09-02 14:04:31.083+05:30', '2026-09-03 10:32:23.214+05:30', 'Paneer and mixed vegetable curries');
INSERT INTO public.menu_categories VALUES ('dc03cb6d-15d5-4869-bd2a-f9fe15bef950', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Curries (Veg)', NULL, 0, true, '2026-09-03 13:45:52.957924+05:30', '2026-09-03 13:45:52.957924+05:30', 'Paneer and mixed vegetable curries');
INSERT INTO public.menu_categories VALUES ('1573fc0d-ce0f-4627-9b8d-318c72987a52', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Meals', NULL, 0, true, '2026-09-03 13:45:52.96299+05:30', '2026-09-03 13:45:52.96299+05:30', 'South & North Indian Full Meals');
INSERT INTO public.menu_categories VALUES ('67d6f5b9-6c57-4c20-8f38-76eb55d6d2fc', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Breakfast', NULL, 0, true, '2026-09-03 13:45:52.966166+05:30', '2026-09-03 13:45:52.966166+05:30', 'Traditional South Indian Breakfast');
INSERT INTO public.menu_categories VALUES ('98294cc3-ab04-48a7-84ee-344177cd6489', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Hot Beverages', NULL, 0, true, '2026-09-03 13:45:52.968945+05:30', '2026-09-03 13:45:52.968945+05:30', 'Filter coffee, tea and soups');
INSERT INTO public.menu_categories VALUES ('adc01cba-1827-49c2-8914-8dfa555df43e', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Soup(Veg)', NULL, 0, true, '2026-09-03 13:45:52.970572+05:30', '2026-09-03 13:45:52.970572+05:30', 'Vegetarian hot soups');
INSERT INTO public.menu_categories VALUES ('eb24c456-5e50-4bd0-a2e2-a85651fb1bd7', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Meal Box (Online)', NULL, 0, true, '2026-09-03 13:45:52.974021+05:30', '2026-09-03 13:45:52.974021+05:30', 'Combo meal boxes for delivery');
INSERT INTO public.menu_categories VALUES ('ef7ea92b-6632-4edf-95ad-d06d6eb167cc', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'Curries (Non-Veg)', NULL, 0, true, '2026-09-03 13:45:52.977064+05:30', '2026-09-03 13:45:52.977064+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('ec70f772-6e76-4d98-8750-789cc04b44ed', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'Biryani (Veg)', NULL, 0, true, '2026-09-03 13:45:52.980552+05:30', '2026-09-03 13:45:52.980552+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('0558a237-7c53-4205-9173-ce6cae42d26f', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'MOCKTAILS', NULL, 0, true, '2026-09-03 13:45:52.982531+05:30', '2026-09-03 13:45:52.982531+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('56e83094-aa78-4bac-9315-3bd2aabd389e', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'Roti & Breads', NULL, 0, true, '2026-09-03 13:45:52.983895+05:30', '2026-09-03 13:45:52.983895+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('56b892ad-0dc8-4efa-8314-af446b132226', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'Tandoori Starters (Non-Veg)', NULL, 0, true, '2026-09-03 13:45:52.987443+05:30', '2026-09-03 13:45:52.987443+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('a393d67d-aeb3-45ff-8e85-9fc7614ea1ce', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'Biryani (Non-Veg)', NULL, 0, true, '2026-09-03 13:45:52.990491+05:30', '2026-09-03 13:45:52.990491+05:30', NULL);


--
-- Data for Name: menu_item_availability; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: menu_item_channel_status; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: menu_items; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.menu_items VALUES ('a0e7da8d-2be8-42d7-9448-794ec1578ce0', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '895fae56-fa21-4a24-8e10-25f56a5ec629', 'Hotel Kapila Special Chicken Biryani (Boneless)', 'Nizamabad signature boneless fried chicken masala over dum basmati rice.', false, NULL, true, '2026-09-02 13:58:11.287+05:30', '2026-09-02 14:00:07.29+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 34000);
INSERT INTO public.menu_items VALUES ('277abe6a-2246-42c2-a9b2-3ec678008344', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '2c8a1a6d-8257-4dc5-a1ce-22a1975717aa', 'Hyderabadi Paneer Dum Biryani', 'Fragrant saffron basmati rice layered with spiced paneer cubes and herbs.', true, NULL, true, '2026-09-02 13:58:11.307+05:30', '2026-09-02 14:00:07.298+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 28000);
INSERT INTO public.menu_items VALUES ('7e80fe93-1931-43c5-bc95-cf0e9230a197', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'c0c8dc4f-e74a-45f9-a2f6-892260dc9c65', 'Murgh Malai Tikka', 'Creamy cashew and cardamom marinated chicken morsels grilled in tandoor.', false, NULL, true, '2026-09-02 13:58:11.315+05:30', '2026-09-02 14:00:07.304+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 32000);
INSERT INTO public.menu_items VALUES ('b11d7200-131b-4674-bb4e-1d60e5fda134', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'b0c93372-0583-4d68-a2bf-670bfd6188b4', 'Kapila Electric Blue Lagoon', 'Blue curacao, fresh lime, sprite and crushed ice.', true, NULL, true, '2026-09-02 13:58:11.323+05:30', '2026-09-02 14:00:07.311+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 16000);
INSERT INTO public.menu_items VALUES ('88009dc2-f5a2-4739-9437-ab8203222d4d', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '895fae56-fa21-4a24-8e10-25f56a5ec629', 'Butter Chicken', NULL, false, NULL, true, '2026-09-02 17:56:48.733+05:30', '2026-09-02 17:56:48.733+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 32000);
INSERT INTO public.menu_items VALUES ('245caeba-ef58-468f-b37f-cbf1e991addf', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'f11e02ac-e172-4c7c-bdb5-c60f06a11401', '(S) Idly', NULL, true, NULL, true, '2026-09-02 14:04:31.107+05:30', '2026-09-03 10:32:23.24+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 5000);
INSERT INTO public.menu_items VALUES ('e3592f51-3aad-46e7-8860-e71f1e6cb91b', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'f11e02ac-e172-4c7c-bdb5-c60f06a11401', '(S) Idly Sambar', NULL, true, NULL, true, '2026-09-02 14:04:31.133+05:30', '2026-09-03 10:32:23.265+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 6000);
INSERT INTO public.menu_items VALUES ('686908c4-7cd1-44f0-bfce-e99abd6ff727', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'f11e02ac-e172-4c7c-bdb5-c60f06a11401', '(S) Vada', NULL, true, NULL, true, '2026-09-02 14:04:31.141+05:30', '2026-09-03 10:32:23.273+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 5500);
INSERT INTO public.menu_items VALUES ('1b4c5540-a235-44d4-ad0e-9f81eb1b465c', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'f11e02ac-e172-4c7c-bdb5-c60f06a11401', '(S) Vada Sambar', NULL, true, NULL, true, '2026-09-02 14:04:31.149+05:30', '2026-09-03 10:32:23.282+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 6500);
INSERT INTO public.menu_items VALUES ('bbff2302-aa8b-4977-9229-71cc2c2baf5f', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'f11e02ac-e172-4c7c-bdb5-c60f06a11401', '70 Mm Dosa', NULL, true, NULL, true, '2026-09-02 14:04:31.158+05:30', '2026-09-03 10:32:23.289+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 11000);
INSERT INTO public.menu_items VALUES ('678efff3-d592-485e-a518-298fa1b851db', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'f11e02ac-e172-4c7c-bdb5-c60f06a11401', 'Breakfast Buffet', NULL, true, NULL, true, '2026-09-02 14:04:31.165+05:30', '2026-09-03 10:32:23.298+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 25000);
INSERT INTO public.menu_items VALUES ('a27a7e4f-8b57-40ca-a90a-c8bd8747b0db', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'f11e02ac-e172-4c7c-bdb5-c60f06a11401', 'Breakfast Combo', NULL, true, NULL, true, '2026-09-02 14:04:31.172+05:30', '2026-09-03 10:32:23.306+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 14000);
INSERT INTO public.menu_items VALUES ('cc842d6a-44f0-43bb-bb69-ef908b73fe20', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'f11e02ac-e172-4c7c-bdb5-c60f06a11401', 'Butter Masala Dosa', NULL, true, NULL, true, '2026-09-02 14:04:31.18+05:30', '2026-09-03 10:32:23.314+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 9500);
INSERT INTO public.menu_items VALUES ('3f7099b1-da18-4312-a11e-12f48633dc4e', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'f11e02ac-e172-4c7c-bdb5-c60f06a11401', 'Chitti Pesarattu', NULL, true, NULL, true, '2026-09-02 14:04:31.188+05:30', '2026-09-03 10:32:23.324+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 8500);
INSERT INTO public.menu_items VALUES ('2bd4e963-be58-42c5-91eb-3f63d74cb0c5', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'f11e02ac-e172-4c7c-bdb5-c60f06a11401', 'Extra Aloo', NULL, true, NULL, true, '2026-09-02 14:04:31.195+05:30', '2026-09-03 10:32:23.331+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 2500);
INSERT INTO public.menu_items VALUES ('4cbd98c3-315b-4ff1-ba2a-f4f70518974e', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'f11e02ac-e172-4c7c-bdb5-c60f06a11401', 'Extra Poori', NULL, true, NULL, true, '2026-09-02 14:04:31.203+05:30', '2026-09-03 10:32:23.341+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 3000);
INSERT INTO public.menu_items VALUES ('644b3bc8-d1b7-47bd-b53f-e18e968d0fbe', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'f11e02ac-e172-4c7c-bdb5-c60f06a11401', 'Ghee Karam Idly', NULL, true, NULL, true, '2026-09-02 14:04:31.21+05:30', '2026-09-03 10:32:23.348+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 9000);
INSERT INTO public.menu_items VALUES ('7cbdb54d-5548-4015-8a1c-f552b44d7969', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'f11e02ac-e172-4c7c-bdb5-c60f06a11401', 'Ghee Karvepaaku Podi Dosa', NULL, true, NULL, true, '2026-09-02 14:04:31.217+05:30', '2026-09-03 10:32:23.356+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 10500);
INSERT INTO public.menu_items VALUES ('6b8896c0-4bd9-48a0-98d6-19713f5d07d9', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'f11e02ac-e172-4c7c-bdb5-c60f06a11401', 'Ghee Podi Dosa', NULL, true, NULL, true, '2026-09-02 14:04:31.225+05:30', '2026-09-03 10:32:23.364+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 10000);
INSERT INTO public.menu_items VALUES ('0e2be491-c42b-48a7-824a-db0771eaeb82', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'f11e02ac-e172-4c7c-bdb5-c60f06a11401', 'Ghee Podi Rava Dosa', NULL, true, NULL, true, '2026-09-02 14:04:31.232+05:30', '2026-09-03 10:32:23.371+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 11500);
INSERT INTO public.menu_items VALUES ('5cb91742-b4df-4d70-8692-c91eefde6866', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'f11e02ac-e172-4c7c-bdb5-c60f06a11401', 'Idly (2)', NULL, true, NULL, true, '2026-09-02 14:04:31.24+05:30', '2026-09-03 10:32:23.38+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 5500);
INSERT INTO public.menu_items VALUES ('30693bb3-881b-44f6-ac6c-22f7332f30e0', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'f11e02ac-e172-4c7c-bdb5-c60f06a11401', 'Idly Sambar', NULL, true, NULL, true, '2026-09-02 14:04:31.248+05:30', '2026-09-03 10:32:23.387+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 6500);
INSERT INTO public.menu_items VALUES ('09243752-2184-4a1a-8c9e-e4d48b28daf3', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'f11e02ac-e172-4c7c-bdb5-c60f06a11401', 'Kids Buffet', NULL, true, NULL, true, '2026-09-02 14:04:31.256+05:30', '2026-09-03 10:32:23.395+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 15000);
INSERT INTO public.menu_items VALUES ('91cc2ac5-560b-4ed8-b47c-b054a5e4a894', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', '2b27795c-af81-402a-96fd-b8558e24f023', 'Executive South Thali Box', NULL, true, NULL, true, '2026-09-02 14:04:31.264+05:30', '2026-09-03 10:32:23.405+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 22000);
INSERT INTO public.menu_items VALUES ('1c5f1c2c-33e0-4860-8160-e33667cb8fe9', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', '2b27795c-af81-402a-96fd-b8558e24f023', 'Special Dosa Combo Box', NULL, true, NULL, true, '2026-09-02 14:04:31.271+05:30', '2026-09-03 10:32:23.412+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 18000);
INSERT INTO public.menu_items VALUES ('4d2be6bc-5508-4078-b978-adecd81938ef', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', '313fa379-9d5f-489c-b340-cdfc26b9e2f0', 'Filter Coffee', NULL, true, NULL, true, '2026-09-02 14:04:31.28+05:30', '2026-09-03 10:32:23.422+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 3500);
INSERT INTO public.menu_items VALUES ('73d6a534-563b-431f-b94f-2dd7c2ba8ed6', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', '313fa379-9d5f-489c-b340-cdfc26b9e2f0', 'Special Masala Tea', NULL, true, NULL, true, '2026-09-02 14:04:31.29+05:30', '2026-09-03 10:32:23.429+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 3000);
INSERT INTO public.menu_items VALUES ('ec478730-9b61-4be3-bc0b-ea7243c1bdfd', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '67d6f5b9-6c57-4c20-8f38-76eb55d6d2fc', '(S) Idly', NULL, true, NULL, true, '2026-09-03 13:45:53.030875+05:30', '2026-09-03 13:45:53.030875+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 5000);
INSERT INTO public.menu_items VALUES ('59846ee3-f19f-4d30-beac-11c4701a2ef9', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '67d6f5b9-6c57-4c20-8f38-76eb55d6d2fc', '(S) Idly Sambar', NULL, true, NULL, true, '2026-09-03 13:45:53.035167+05:30', '2026-09-03 13:45:53.035167+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 6000);
INSERT INTO public.menu_items VALUES ('51e725ae-ded2-49e5-bf40-21d2c161fb99', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '67d6f5b9-6c57-4c20-8f38-76eb55d6d2fc', '(S) Vada', NULL, true, NULL, true, '2026-09-03 13:45:53.038047+05:30', '2026-09-03 13:45:53.038047+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 5500);
INSERT INTO public.menu_items VALUES ('e7b67d41-a6a1-478c-a6ba-5a29b9f8f71f', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '67d6f5b9-6c57-4c20-8f38-76eb55d6d2fc', '(S) Vada Sambar', NULL, true, NULL, true, '2026-09-03 13:45:53.040318+05:30', '2026-09-03 13:45:53.040318+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 6500);
INSERT INTO public.menu_items VALUES ('61e5132a-4de2-4d78-a7f1-51c44c16fb49', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '67d6f5b9-6c57-4c20-8f38-76eb55d6d2fc', '70 Mm Dosa', NULL, true, NULL, true, '2026-09-03 13:45:53.041864+05:30', '2026-09-03 13:45:53.041864+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 11000);
INSERT INTO public.menu_items VALUES ('1a95da75-6d6b-4041-9142-36b2353b33b2', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '67d6f5b9-6c57-4c20-8f38-76eb55d6d2fc', 'Breakfast Buffet', NULL, true, NULL, true, '2026-09-03 13:45:53.043169+05:30', '2026-09-03 13:45:53.043169+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 25000);
INSERT INTO public.menu_items VALUES ('2363163a-d94e-48b5-bbbd-26792a255cfb', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '67d6f5b9-6c57-4c20-8f38-76eb55d6d2fc', 'Breakfast Combo', NULL, true, NULL, true, '2026-09-03 13:45:53.044874+05:30', '2026-09-03 13:45:53.044874+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 14000);
INSERT INTO public.menu_items VALUES ('7a13bf5c-8ba3-4abb-b5f1-56426fdf025e', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '67d6f5b9-6c57-4c20-8f38-76eb55d6d2fc', 'Butter Masala Dosa', NULL, true, NULL, true, '2026-09-03 13:45:53.046746+05:30', '2026-09-03 13:45:53.046746+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 9500);
INSERT INTO public.menu_items VALUES ('2ff5764f-2bda-49fc-bb3d-c8bf2cc91adc', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '67d6f5b9-6c57-4c20-8f38-76eb55d6d2fc', 'Chitti Pesarattu', NULL, true, NULL, true, '2026-09-03 13:45:53.049007+05:30', '2026-09-03 13:45:53.049007+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 8500);
INSERT INTO public.menu_items VALUES ('1a13319b-1192-4018-9399-6bd0c762ec2c', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'eb24c456-5e50-4bd0-a2e2-a85651fb1bd7', 'Executive South Thali Box', NULL, true, NULL, true, '2026-09-03 13:45:53.050445+05:30', '2026-09-03 13:45:53.050445+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 22000);
INSERT INTO public.menu_items VALUES ('aebc111c-1f92-47e9-881b-7c3820e5ff2f', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '67d6f5b9-6c57-4c20-8f38-76eb55d6d2fc', 'Extra Aloo', NULL, true, NULL, true, '2026-09-03 13:45:53.051778+05:30', '2026-09-03 13:45:53.051778+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 2500);
INSERT INTO public.menu_items VALUES ('79029b8b-4a81-4383-a6d7-9ca840782d62', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '67d6f5b9-6c57-4c20-8f38-76eb55d6d2fc', 'Extra Poori', NULL, true, NULL, true, '2026-09-03 13:45:53.053423+05:30', '2026-09-03 13:45:53.053423+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 3000);
INSERT INTO public.menu_items VALUES ('e5c773ed-467f-4411-8207-09782ae6df6d', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '98294cc3-ab04-48a7-84ee-344177cd6489', 'Filter Coffee', NULL, true, NULL, true, '2026-09-03 13:45:53.054671+05:30', '2026-09-03 13:45:53.054671+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 3500);
INSERT INTO public.menu_items VALUES ('811cd2fc-40da-469c-bf50-c292c811f6b6', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '67d6f5b9-6c57-4c20-8f38-76eb55d6d2fc', 'Ghee Karam Idly', NULL, true, NULL, true, '2026-09-03 13:45:53.055911+05:30', '2026-09-03 13:45:53.055911+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 9000);
INSERT INTO public.menu_items VALUES ('0088e8ff-b85b-4fbe-9366-0bbeec1d88ef', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '67d6f5b9-6c57-4c20-8f38-76eb55d6d2fc', 'Ghee Karvepaaku Podi Dosa', NULL, true, NULL, true, '2026-09-03 13:45:53.058332+05:30', '2026-09-03 13:45:53.058332+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 10500);
INSERT INTO public.menu_items VALUES ('90d5afa5-0f32-40a0-9b02-fafa2941487e', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '67d6f5b9-6c57-4c20-8f38-76eb55d6d2fc', 'Ghee Podi Dosa', NULL, true, NULL, true, '2026-09-03 13:45:53.060754+05:30', '2026-09-03 13:45:53.060754+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 10000);
INSERT INTO public.menu_items VALUES ('d77fe08a-046b-4c0f-8830-48b593a8fbbe', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '67d6f5b9-6c57-4c20-8f38-76eb55d6d2fc', 'Ghee Podi Rava Dosa', NULL, true, NULL, true, '2026-09-03 13:45:53.062666+05:30', '2026-09-03 13:45:53.062666+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 11500);
INSERT INTO public.menu_items VALUES ('569fccc7-9acf-491a-8465-b8279f3008af', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '67d6f5b9-6c57-4c20-8f38-76eb55d6d2fc', 'Idly (2)', NULL, true, NULL, true, '2026-09-03 13:45:53.064952+05:30', '2026-09-03 13:45:53.064952+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 5500);
INSERT INTO public.menu_items VALUES ('26281f6e-0d12-4867-a222-81c7f190ddef', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '67d6f5b9-6c57-4c20-8f38-76eb55d6d2fc', 'Idly Sambar', NULL, true, NULL, true, '2026-09-03 13:45:53.066204+05:30', '2026-09-03 13:45:53.066204+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 6500);
INSERT INTO public.menu_items VALUES ('f1c59198-e405-4271-9360-0dcaec24dee2', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '67d6f5b9-6c57-4c20-8f38-76eb55d6d2fc', 'Kids Buffet', NULL, true, NULL, true, '2026-09-03 13:45:53.068383+05:30', '2026-09-03 13:45:53.068383+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 15000);
INSERT INTO public.menu_items VALUES ('0d5e3abc-3ecb-47e0-b419-a6b1e3de3f01', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'eb24c456-5e50-4bd0-a2e2-a85651fb1bd7', 'Special Dosa Combo Box', NULL, true, NULL, true, '2026-09-03 13:45:53.072099+05:30', '2026-09-03 13:45:53.072099+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 18000);
INSERT INTO public.menu_items VALUES ('cd411cd1-7671-489b-a7f8-937eafb20e72', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '98294cc3-ab04-48a7-84ee-344177cd6489', 'Special Masala Tea', NULL, true, NULL, true, '2026-09-03 13:45:53.073399+05:30', '2026-09-03 13:45:53.073399+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 3000);
INSERT INTO public.menu_items VALUES ('7e8fac56-b8d3-4ca0-9872-fd795eda092d', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'a393d67d-aeb3-45ff-8e85-9fc7614ea1ce', 'Butter Chicken', NULL, false, NULL, true, '2026-09-03 13:45:53.086624+05:30', '2026-09-03 13:45:53.086624+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 32000);
INSERT INTO public.menu_items VALUES ('d6a5afe2-31be-4c45-9470-f016e5309ddd', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'a393d67d-aeb3-45ff-8e85-9fc7614ea1ce', 'Hotel Kapila Special Chicken Biryani (Boneless)', 'Nizamabad signature boneless fried chicken masala over dum basmati rice.', false, NULL, true, '2026-09-03 13:45:53.096511+05:30', '2026-09-03 13:45:53.096511+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 34000);
INSERT INTO public.menu_items VALUES ('2b716fe4-6deb-41cb-8639-2523d9e6b74e', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'ec70f772-6e76-4d98-8750-789cc04b44ed', 'Hyderabadi Paneer Dum Biryani', 'Fragrant saffron basmati rice layered with spiced paneer cubes and herbs.', true, NULL, true, '2026-09-03 13:45:53.09974+05:30', '2026-09-03 13:45:53.09974+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 28000);
INSERT INTO public.menu_items VALUES ('9cf42fe2-6bbd-46c7-86f9-c8695530f757', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', '0558a237-7c53-4205-9173-ce6cae42d26f', 'Kapila Electric Blue Lagoon', 'Blue curacao, fresh lime, sprite and crushed ice.', true, NULL, true, '2026-09-03 13:45:53.103994+05:30', '2026-09-03 13:45:53.103994+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 16000);
INSERT INTO public.menu_items VALUES ('316f8471-27fe-438b-9961-002b66f96f45', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', '56b892ad-0dc8-4efa-8314-af446b132226', 'Murgh Malai Tikka', 'Creamy cashew and cardamom marinated chicken morsels grilled in tandoor.', false, NULL, true, '2026-09-03 13:45:53.106191+05:30', '2026-09-03 13:45:53.106191+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 32000);
INSERT INTO public.menu_items VALUES ('dc37d5ad-bc4f-4b0a-82db-67d8e5852c12', '11111111-1111-1111-1111-111111111111', '157b592c-2b8a-4c9d-80b0-3ca17272ca5e', '(S) Idly Sambar', NULL, true, NULL, true, '2026-09-03 13:45:53.115798+05:30', '2026-09-03 13:45:53.115798+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 6000);
INSERT INTO public.menu_items VALUES ('4c748f68-bca2-4f38-b9b3-23d71a314ae8', '11111111-1111-1111-1111-111111111111', '157b592c-2b8a-4c9d-80b0-3ca17272ca5e', '(S) Vada', NULL, true, NULL, true, '2026-09-03 13:45:53.118803+05:30', '2026-09-03 13:45:53.118803+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 5500);
INSERT INTO public.menu_items VALUES ('40e0a11f-f68a-4ed3-b229-4b35da1a8f5d', '11111111-1111-1111-1111-111111111111', '157b592c-2b8a-4c9d-80b0-3ca17272ca5e', '(S) Vada Sambar', NULL, true, NULL, true, '2026-09-03 13:45:53.120646+05:30', '2026-09-03 13:45:53.120646+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 6500);
INSERT INTO public.menu_items VALUES ('eda1dd36-db44-4dc9-b2d1-21cc41a1ff0f', '11111111-1111-1111-1111-111111111111', '157b592c-2b8a-4c9d-80b0-3ca17272ca5e', '70 Mm Dosa', NULL, true, NULL, true, '2026-09-03 13:45:53.122512+05:30', '2026-09-03 13:45:53.122512+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 11000);
INSERT INTO public.menu_items VALUES ('96741261-a8bb-4341-b901-99d7d34847ad', '11111111-1111-1111-1111-111111111111', '157b592c-2b8a-4c9d-80b0-3ca17272ca5e', 'Breakfast Buffet', NULL, true, NULL, true, '2026-09-03 13:45:53.123838+05:30', '2026-09-03 13:45:53.123838+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 25000);
INSERT INTO public.menu_items VALUES ('b1d7d0ac-e478-43d9-8494-0d4f6a9580eb', '11111111-1111-1111-1111-111111111111', '157b592c-2b8a-4c9d-80b0-3ca17272ca5e', 'Breakfast Combo', NULL, true, NULL, true, '2026-09-03 13:45:53.125638+05:30', '2026-09-03 13:45:53.125638+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 14000);
INSERT INTO public.menu_items VALUES ('4472be98-66e1-4d19-870c-bff01714f9e6', '11111111-1111-1111-1111-111111111111', '5ffb7578-d7c4-491d-b516-98c10edacb0c', 'Butter Chicken', NULL, false, NULL, true, '2026-09-03 13:45:53.127768+05:30', '2026-09-03 13:45:53.127768+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 32000);
INSERT INTO public.menu_items VALUES ('f7813575-802f-47bd-816d-936ebed9799c', '11111111-1111-1111-1111-111111111111', '157b592c-2b8a-4c9d-80b0-3ca17272ca5e', 'Butter Masala Dosa', NULL, true, NULL, true, '2026-09-03 13:45:53.129283+05:30', '2026-09-03 13:45:53.129283+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 9500);
INSERT INTO public.menu_items VALUES ('b5bce0e8-0dfd-43a9-b272-608c930daf86', '11111111-1111-1111-1111-111111111111', '157b592c-2b8a-4c9d-80b0-3ca17272ca5e', 'Chitti Pesarattu', NULL, true, NULL, true, '2026-09-03 13:45:53.130579+05:30', '2026-09-03 13:45:53.130579+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 8500);
INSERT INTO public.menu_items VALUES ('ba9264dc-e5b8-4c0c-9422-d78852aa8c72', '11111111-1111-1111-1111-111111111111', 'e581a9b0-daa4-4d6f-9f14-7623638c1dc7', 'Executive South Thali Box', NULL, true, NULL, true, '2026-09-03 13:45:53.132069+05:30', '2026-09-03 13:45:53.132069+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 22000);
INSERT INTO public.menu_items VALUES ('5ce8b459-2fb3-41fd-abaa-446137a7aa6e', '11111111-1111-1111-1111-111111111111', '157b592c-2b8a-4c9d-80b0-3ca17272ca5e', 'Extra Aloo', NULL, true, NULL, true, '2026-09-03 13:45:53.133775+05:30', '2026-09-03 13:45:53.133775+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 2500);
INSERT INTO public.menu_items VALUES ('519bf5b7-40ff-4d77-89f2-ebec06547bae', '11111111-1111-1111-1111-111111111111', '157b592c-2b8a-4c9d-80b0-3ca17272ca5e', 'Extra Poori', NULL, true, NULL, true, '2026-09-03 13:45:53.135222+05:30', '2026-09-03 13:45:53.135222+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 3000);
INSERT INTO public.menu_items VALUES ('0e966d3c-b0a7-49c5-975e-c9040121ad18', '11111111-1111-1111-1111-111111111111', 'f001972a-1b1f-4e9c-bb87-9a5520149635', 'Filter Coffee', NULL, true, NULL, true, '2026-09-03 13:45:53.136702+05:30', '2026-09-03 13:45:53.136702+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 3500);
INSERT INTO public.menu_items VALUES ('67825178-175f-4708-a692-084dcec3e328', '11111111-1111-1111-1111-111111111111', '157b592c-2b8a-4c9d-80b0-3ca17272ca5e', 'Ghee Karam Idly', NULL, true, NULL, true, '2026-09-03 13:45:53.139148+05:30', '2026-09-03 13:45:53.139148+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 9000);
INSERT INTO public.menu_items VALUES ('d43a31ce-8564-4f1b-96fa-f42efe50791b', '11111111-1111-1111-1111-111111111111', '157b592c-2b8a-4c9d-80b0-3ca17272ca5e', 'Ghee Karvepaaku Podi Dosa', NULL, true, NULL, true, '2026-09-03 13:45:53.141982+05:30', '2026-09-03 13:45:53.141982+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 10500);
INSERT INTO public.menu_items VALUES ('6cdbd658-ada4-4825-9904-5e3e79d4e35a', '11111111-1111-1111-1111-111111111111', '157b592c-2b8a-4c9d-80b0-3ca17272ca5e', 'Ghee Podi Dosa', NULL, true, NULL, true, '2026-09-03 13:45:53.143732+05:30', '2026-09-03 13:45:53.143732+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 10000);
INSERT INTO public.menu_items VALUES ('fc64c535-fa89-42c7-9857-81ef2ef9ce35', '11111111-1111-1111-1111-111111111111', '157b592c-2b8a-4c9d-80b0-3ca17272ca5e', 'Ghee Podi Rava Dosa', NULL, true, NULL, true, '2026-09-03 13:45:53.144991+05:30', '2026-09-03 13:45:53.144991+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 11500);
INSERT INTO public.menu_items VALUES ('af6e91e6-6cd5-4c9e-961e-246f98689e31', '11111111-1111-1111-1111-111111111111', '5ffb7578-d7c4-491d-b516-98c10edacb0c', 'Hotel Kapila Special Chicken Biryani (Boneless)', 'Nizamabad signature boneless fried chicken masala over dum basmati rice.', false, NULL, true, '2026-09-03 13:45:53.146617+05:30', '2026-09-03 13:45:53.146617+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 34000);
INSERT INTO public.menu_items VALUES ('e31e6867-c8f7-4c36-b3a2-1fea50e798da', '11111111-1111-1111-1111-111111111111', '096f0a82-e581-45f1-9d92-522ebe5c2f7a', 'Hyderabadi Paneer Dum Biryani', 'Fragrant saffron basmati rice layered with spiced paneer cubes and herbs.', true, NULL, true, '2026-09-03 13:45:53.148814+05:30', '2026-09-03 13:45:53.148814+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 28000);
INSERT INTO public.menu_items VALUES ('0df5690d-69e3-4bb0-ac07-fc91449e3a0f', '11111111-1111-1111-1111-111111111111', '157b592c-2b8a-4c9d-80b0-3ca17272ca5e', 'Idly (2)', NULL, true, NULL, true, '2026-09-03 13:45:53.150223+05:30', '2026-09-03 13:45:53.150223+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 5500);
INSERT INTO public.menu_items VALUES ('59c5362c-66a6-4153-aef9-b8091d077995', '11111111-1111-1111-1111-111111111111', '157b592c-2b8a-4c9d-80b0-3ca17272ca5e', 'Idly Sambar', NULL, true, NULL, true, '2026-09-03 13:45:53.15149+05:30', '2026-09-03 13:45:53.15149+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 6500);
INSERT INTO public.menu_items VALUES ('7b7677d2-0c1a-4b8e-a937-88a8d764d21f', '11111111-1111-1111-1111-111111111111', '25b36641-61fa-4884-a3d8-e5ced013533a', 'Kapila Electric Blue Lagoon', 'Blue curacao, fresh lime, sprite and crushed ice.', true, NULL, true, '2026-09-03 13:45:53.152729+05:30', '2026-09-03 13:45:53.152729+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 16000);
INSERT INTO public.menu_items VALUES ('9a77c8e6-8ae4-4f2c-88ad-88ee1fc58211', '11111111-1111-1111-1111-111111111111', '157b592c-2b8a-4c9d-80b0-3ca17272ca5e', 'Kids Buffet', NULL, true, NULL, true, '2026-09-03 13:45:53.154008+05:30', '2026-09-03 13:45:53.154008+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 15000);
INSERT INTO public.menu_items VALUES ('a8652e18-bfd0-42c8-b06e-c8d0621c8ef1', '11111111-1111-1111-1111-111111111111', '6f5f9db9-2d68-4acf-8773-2a224b80fb33', 'Murgh Malai Tikka', 'Creamy cashew and cardamom marinated chicken morsels grilled in tandoor.', false, NULL, true, '2026-09-03 13:45:53.155248+05:30', '2026-09-03 13:45:53.155248+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 32000);
INSERT INTO public.menu_items VALUES ('29052e1b-de49-421b-9711-c5c17820b257', '11111111-1111-1111-1111-111111111111', 'e581a9b0-daa4-4d6f-9f14-7623638c1dc7', 'Special Dosa Combo Box', NULL, true, NULL, true, '2026-09-03 13:45:53.15743+05:30', '2026-09-03 13:45:53.15743+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 18000);
INSERT INTO public.menu_items VALUES ('75272f16-e542-4bd9-9de6-49352d62929b', '11111111-1111-1111-1111-111111111111', 'f001972a-1b1f-4e9c-bb87-9a5520149635', 'Special Masala Tea', NULL, true, NULL, true, '2026-09-03 13:45:53.159535+05:30', '2026-09-03 13:45:53.159535+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 3000);
INSERT INTO public.menu_items VALUES ('b4da7948-a826-4870-bfc9-bbdd92db1975', '11111111-1111-1111-1111-111111111111', '157b592c-2b8a-4c9d-80b0-3ca17272ca5e', '(S) Idly', NULL, true, NULL, false, '2026-09-03 13:45:53.11177+05:30', '2026-09-04 16:38:59.405+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 5000);
INSERT INTO public.menu_items VALUES ('46f3f4d1-f84b-4888-a21d-c6f4a015e247', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'f11e02ac-e172-4c7c-bdb5-c60f06a11401', '(2) Idly (1) Vada', NULL, true, NULL, true, '2026-09-02 14:04:31.095+05:30', '2026-09-03 10:32:23.226+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 8500);
INSERT INTO public.menu_items VALUES ('3d414f04-d66e-4e4c-a6d1-4acc7163ce12', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'f11e02ac-e172-4c7c-bdb5-c60f06a11401', '(S) Idly (S) Vada', NULL, true, NULL, true, '2026-09-02 14:04:31.116+05:30', '2026-09-03 10:32:23.248+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 7000);
INSERT INTO public.menu_items VALUES ('b080025e-c0db-4904-9b7a-9d8bb7181281', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'f11e02ac-e172-4c7c-bdb5-c60f06a11401', '(S) Idly (S) Vada Sambar', NULL, true, NULL, true, '2026-09-02 14:04:31.124+05:30', '2026-09-03 10:32:23.255+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 8000);
INSERT INTO public.menu_items VALUES ('d9519b46-7ca5-4a2a-bfa1-2374153b60a5', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '67d6f5b9-6c57-4c20-8f38-76eb55d6d2fc', '(2) Idly (1) Vada', NULL, true, NULL, true, '2026-09-03 13:45:53.02886+05:30', '2026-09-03 13:45:53.02886+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 8500);
INSERT INTO public.menu_items VALUES ('edc6665e-f238-411c-aaad-edcbf556c22d', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '67d6f5b9-6c57-4c20-8f38-76eb55d6d2fc', '(S) Idly (S) Vada', NULL, true, NULL, true, '2026-09-03 13:45:53.032347+05:30', '2026-09-03 13:45:53.032347+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 7000);
INSERT INTO public.menu_items VALUES ('4109efd3-e894-4bff-ba91-ba8be0c5daf2', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '67d6f5b9-6c57-4c20-8f38-76eb55d6d2fc', '(S) Idly (S) Vada Sambar', NULL, true, NULL, true, '2026-09-03 13:45:53.033768+05:30', '2026-09-03 13:45:53.033768+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 8000);
INSERT INTO public.menu_items VALUES ('02364da4-0994-4cd1-b37d-ff520665da94', '11111111-1111-1111-1111-111111111111', '157b592c-2b8a-4c9d-80b0-3ca17272ca5e', '(S) Idly (S) Vada', NULL, true, NULL, true, '2026-09-03 13:45:53.113001+05:30', '2026-09-03 13:45:53.113001+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 7000);
INSERT INTO public.menu_items VALUES ('3ceb6db2-13a7-499a-ab4e-718843209e69', '11111111-1111-1111-1111-111111111111', '157b592c-2b8a-4c9d-80b0-3ca17272ca5e', '(S) Idly (S) Vada Sambar', NULL, true, NULL, true, '2026-09-03 13:45:53.114231+05:30', '2026-09-03 13:45:53.114231+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 8000);
INSERT INTO public.menu_items VALUES ('5426f52c-ff30-4b56-aa31-d737a5a1502c', '11111111-1111-1111-1111-111111111111', '157b592c-2b8a-4c9d-80b0-3ca17272ca5e', '(2) Idly (1) Vada', NULL, true, NULL, true, '2026-09-03 13:45:53.110336+05:30', '2026-09-04 16:38:54.347+05:30', NULL, NULL, 5.00, 100, NULL, NULL, 8500);


--
-- Data for Name: modifier_groups; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: modifier_options; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: modifiers; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.notifications VALUES ('b49ac1cd-e5c1-4a03-bc3f-888da003eb44', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'd119207c-8cf7-4a03-8125-6737c85c210d', 'INVENTORY_ALERT', 'Low Stock Alert', 'Basmati Rice is below reorder level (10 kg remaining).', NULL, NULL, false, '2026-09-03 12:29:04.418378+05:30', '2026-09-03 12:29:04.418378+05:30');
INSERT INTO public.notifications VALUES ('4ac5439a-38eb-49bd-8340-c0e101a3182c', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'd119207c-8cf7-4a03-8125-6737c85c210d', 'ORDER_ALERT', 'Table A3 Billing Request', 'Table A3 has requested final physical invoice.', NULL, NULL, false, '2026-09-03 12:29:04.421205+05:30', '2026-09-03 12:29:04.421205+05:30');
INSERT INTO public.notifications VALUES ('ba77bf77-6897-4605-8a98-885439d44996', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'd119207c-8cf7-4a03-8125-6737c85c210d', 'AGGREGATOR_ALERT', 'New Swiggy Order', 'Order #SW-8821 received and confirmed.', NULL, NULL, false, '2026-09-03 12:29:04.422885+05:30', '2026-09-03 12:29:04.422885+05:30');
INSERT INTO public.notifications VALUES ('6b3e56d5-159d-443d-9127-c602db431c6a', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'd119207c-8cf7-4a03-8125-6737c85c210d', 'SYSTEM_ALERT', 'Shift Register Opened', 'Cashier shift opened on Terminal T-01.', NULL, NULL, false, '2026-09-03 12:29:04.424466+05:30', '2026-09-03 12:29:04.424466+05:30');


--
-- Data for Name: order_audit_log; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: order_item_modifiers; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: order_item_seat_shares; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.order_items VALUES ('3cc60bc4-3338-4dcb-a44f-3a4dc5639085', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '2f066396-49ed-4838-89f4-ec49b387a188', 'a0e7da8d-2be8-42d7-9448-794ec1578ce0', NULL, 'Hotel Kapila Special Chicken Biryani (Boneless)', 2, 3400000, 6800000, NULL, '2026-09-03 12:30:36.173739+05:30', '2026-09-03 12:30:36.173739+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, 1, 0, 0, NULL, NULL);
INSERT INTO public.order_items VALUES ('f83bd7af-adaa-42c9-b826-f759b0f46f73', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '2f066396-49ed-4838-89f4-ec49b387a188', '277abe6a-2246-42c2-a9b2-3ec678008344', NULL, 'Hyderabadi Paneer Dum Biryani', 1, 2800000, 2800000, NULL, '2026-09-03 12:30:36.178078+05:30', '2026-09-03 12:30:36.178078+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, 1, 0, 0, NULL, NULL);
INSERT INTO public.order_items VALUES ('93907c79-5956-4d69-89ef-05810b77ad5c', '11111111-1111-1111-1111-111111111111', '36b5af51-afbb-4d30-a349-79864c3791d9', '5426f52c-ff30-4b56-aa31-d737a5a1502c', NULL, 'Item', 1, 850000, 850000, NULL, '2026-09-03 13:59:56.784765+05:30', '2026-09-03 13:59:56.784765+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '5426f52c-ff30-4b56-aa31-d737a5a1502c', 1, 8500, 8500, NULL, NULL);
INSERT INTO public.order_items VALUES ('9abfbfee-265e-4475-bd9b-ab7e6649dc27', '11111111-1111-1111-1111-111111111111', 'c925c343-fc96-4899-b5a4-07536894443a', '5426f52c-ff30-4b56-aa31-d737a5a1502c', NULL, 'Item', 1, 850000, 850000, NULL, '2026-09-03 14:04:17.892867+05:30', '2026-09-03 14:04:17.892867+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '5426f52c-ff30-4b56-aa31-d737a5a1502c', 1, 8500, 8500, NULL, NULL);
INSERT INTO public.order_items VALUES ('d3940bb6-8577-4e0f-9e8b-a4f537345783', '11111111-1111-1111-1111-111111111111', '71c1721d-8f5b-4de0-8e55-31796856656b', 'af6e91e6-6cd5-4c9e-961e-246f98689e31', NULL, 'Item', 1, 3400000, 3400000, NULL, '2026-09-03 14:04:33.823459+05:30', '2026-09-03 14:04:33.823459+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', 'af6e91e6-6cd5-4c9e-961e-246f98689e31', 1, 34000, 34000, NULL, NULL);
INSERT INTO public.order_items VALUES ('1d6763f3-124b-4ae3-91db-c1a6f2f74e07', '11111111-1111-1111-1111-111111111111', '9b477c95-d76b-4976-b745-a7a2ef4d4b14', '5426f52c-ff30-4b56-aa31-d737a5a1502c', NULL, 'Item', 1, 8500, 8500, NULL, '2026-09-03 16:15:54.317551+05:30', '2026-09-03 16:15:54.317551+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '5426f52c-ff30-4b56-aa31-d737a5a1502c', 1, 8500, 8500, NULL, NULL);
INSERT INTO public.order_items VALUES ('5b9ed80e-9f3d-4874-b56f-696dba9fd28f', '11111111-1111-1111-1111-111111111111', '9b477c95-d76b-4976-b745-a7a2ef4d4b14', 'f7813575-802f-47bd-816d-936ebed9799c', NULL, 'Item', 1, 9500, 9500, NULL, '2026-09-03 16:21:04.063294+05:30', '2026-09-03 16:21:04.063294+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', 'f7813575-802f-47bd-816d-936ebed9799c', 1, 9500, 9500, NULL, NULL);
INSERT INTO public.order_items VALUES ('4e589a3e-d777-4cd1-b3df-28e57ca46944', '11111111-1111-1111-1111-111111111111', 'fefda5cf-8409-441a-8e3a-a803c36fb2ce', '96741261-a8bb-4341-b901-99d7d34847ad', NULL, 'Item', 1, 25000, 25000, NULL, '2026-09-03 16:22:16.533014+05:30', '2026-09-03 16:22:16.533014+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '96741261-a8bb-4341-b901-99d7d34847ad', 1, 25000, 25000, NULL, NULL);
INSERT INTO public.order_items VALUES ('69f551b6-2be8-4c7f-83ca-8f41da74e231', '11111111-1111-1111-1111-111111111111', 'fefda5cf-8409-441a-8e3a-a803c36fb2ce', '519bf5b7-40ff-4d77-89f2-ebec06547bae', NULL, 'Item', 1, 3000, 3000, NULL, '2026-09-03 16:23:21.476181+05:30', '2026-09-03 16:23:21.476181+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '519bf5b7-40ff-4d77-89f2-ebec06547bae', 1, 3000, 3000, NULL, NULL);
INSERT INTO public.order_items VALUES ('b36724da-1b39-4e0b-8eb8-d1a6e1dfc404', '11111111-1111-1111-1111-111111111111', 'fefda5cf-8409-441a-8e3a-a803c36fb2ce', 'a8652e18-bfd0-42c8-b06e-c8d0621c8ef1', NULL, 'Item', 1, 32000, 32000, NULL, '2026-09-03 16:23:58.542064+05:30', '2026-09-03 16:23:58.542064+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', 'a8652e18-bfd0-42c8-b06e-c8d0621c8ef1', 1, 32000, 32000, NULL, NULL);
INSERT INTO public.order_items VALUES ('fd613879-65ea-4848-b328-6b8d9f9ed70c', '11111111-1111-1111-1111-111111111111', 'c14e4df0-40c4-430e-b162-d015a4964c84', 'b4da7948-a826-4870-bfc9-bbdd92db1975', NULL, 'Item', 1, 5000, 5000, NULL, '2026-09-03 17:41:44.256926+05:30', '2026-09-03 17:41:44.256926+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', 'b4da7948-a826-4870-bfc9-bbdd92db1975', 1, 5000, 5000, NULL, NULL);
INSERT INTO public.order_items VALUES ('cde05d25-2935-4595-9fff-eab9ea049e09', '11111111-1111-1111-1111-111111111111', '08b726d5-cac2-48d9-b036-a668d5bf7066', '02364da4-0994-4cd1-b37d-ff520665da94', NULL, 'Item', 1, 7000, 7000, NULL, '2026-09-04 16:22:34.33452+05:30', '2026-09-04 16:22:34.33452+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '02364da4-0994-4cd1-b37d-ff520665da94', 1, 7000, 7000, NULL, NULL);
INSERT INTO public.order_items VALUES ('25ae1596-531c-4081-92b7-c448fbe4a7d0', '11111111-1111-1111-1111-111111111111', '2a670867-a3af-4698-aa9a-84afa3fb7e04', '02364da4-0994-4cd1-b37d-ff520665da94', NULL, 'Item', 1, 7000, 7000, NULL, '2026-09-04 16:40:24.843213+05:30', '2026-09-04 16:40:24.843213+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, '02364da4-0994-4cd1-b37d-ff520665da94', 1, 7000, 7000, NULL, NULL);
INSERT INTO public.order_items VALUES ('45832125-c5d7-4941-a8d2-11f2464d2e4d', '11111111-1111-1111-1111-111111111111', 'e50cff2e-3302-416f-8cb8-82d28229ef6f', '3ceb6db2-13a7-499a-ab4e-718843209e69', NULL, 'Item', 1, 8000, 8000, NULL, '2026-09-04 16:57:45.04633+05:30', '2026-09-04 16:57:45.04633+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '3ceb6db2-13a7-499a-ab4e-718843209e69', 1, 8000, 8000, NULL, NULL);
INSERT INTO public.order_items VALUES ('269411c2-20e3-40cf-9b44-fa9239a8e14b', '11111111-1111-1111-1111-111111111111', 'be05502d-64d3-4721-9b8d-270fb383a20f', '4c748f68-bca2-4f38-b9b3-23d71a314ae8', NULL, 'Item', 1, 5500, 5500, NULL, '2026-09-07 14:35:48.200112+05:30', '2026-09-07 14:35:48.200112+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '4c748f68-bca2-4f38-b9b3-23d71a314ae8', 1, 5500, 5500, NULL, NULL);
INSERT INTO public.order_items VALUES ('865dc3f6-0a77-4145-a8d5-d55c0fc11518', '11111111-1111-1111-1111-111111111111', 'be05502d-64d3-4721-9b8d-270fb383a20f', '0e966d3c-b0a7-49c5-975e-c9040121ad18', NULL, 'Item', 1, 3500, 3500, NULL, '2026-09-07 14:59:25.355535+05:30', '2026-09-07 14:59:25.355535+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '0e966d3c-b0a7-49c5-975e-c9040121ad18', 1, 3500, 3500, NULL, NULL);
INSERT INTO public.order_items VALUES ('baf9cf9f-4804-4fdc-9b62-5a88b6697706', '11111111-1111-1111-1111-111111111111', 'be05502d-64d3-4721-9b8d-270fb383a20f', '519bf5b7-40ff-4d77-89f2-ebec06547bae', NULL, 'Item', 1, 3000, 3000, NULL, '2026-09-07 14:59:25.355535+05:30', '2026-09-07 14:59:25.355535+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '519bf5b7-40ff-4d77-89f2-ebec06547bae', 1, 3000, 3000, NULL, NULL);
INSERT INTO public.order_items VALUES ('c8955bf6-d02d-4826-ac2a-f45994824ce5', '11111111-1111-1111-1111-111111111111', 'be05502d-64d3-4721-9b8d-270fb383a20f', 'e31e6867-c8f7-4c36-b3a2-1fea50e798da', NULL, 'Item', 1, 28000, 28000, NULL, '2026-09-07 14:59:25.355535+05:30', '2026-09-07 14:59:25.355535+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', 'e31e6867-c8f7-4c36-b3a2-1fea50e798da', 1, 28000, 28000, NULL, NULL);


--
-- Data for Name: order_payments; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: order_refunds; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: order_seat_bills; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: order_status_history; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.order_status_history VALUES ('3c51ab1c-33ce-4a39-b223-901cc1b3b988', '11111111-1111-1111-1111-111111111111', '36b5af51-afbb-4d30-a349-79864c3791d9', NULL, 'PLACED', NULL, NULL, '2026-09-03 13:59:56.805+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('4bcefb00-dcb5-4907-b9f4-8e2d427726e2', '11111111-1111-1111-1111-111111111111', '36b5af51-afbb-4d30-a349-79864c3791d9', NULL, 'CONFIRMED', NULL, NULL, '2026-09-03 14:02:43.294+05:30', 'CONFIRMED', NULL, '689cec0b-ebbc-41c3-b968-1810c5add707');
INSERT INTO public.order_status_history VALUES ('322bb6fb-2691-49d1-8727-bef141d4c7d0', '11111111-1111-1111-1111-111111111111', 'c925c343-fc96-4899-b5a4-07536894443a', NULL, 'PLACED', NULL, NULL, '2026-09-03 14:04:17.913+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('37d470ed-d3f4-47bb-9e8d-618da9859fe5', '11111111-1111-1111-1111-111111111111', 'c925c343-fc96-4899-b5a4-07536894443a', NULL, 'CONFIRMED', NULL, NULL, '2026-09-03 14:04:17.924+05:30', 'CONFIRMED', NULL, '689cec0b-ebbc-41c3-b968-1810c5add707');
INSERT INTO public.order_status_history VALUES ('392135f9-691a-46aa-9be3-c3b6f60f0737', '11111111-1111-1111-1111-111111111111', 'c925c343-fc96-4899-b5a4-07536894443a', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-03 14:04:17.934+05:30', 'KOT_CREATED', NULL, '689cec0b-ebbc-41c3-b968-1810c5add707');
INSERT INTO public.order_status_history VALUES ('208a9ec7-d38e-44f9-a811-4b98ca76a68f', '11111111-1111-1111-1111-111111111111', '71c1721d-8f5b-4de0-8e55-31796856656b', NULL, 'PLACED', NULL, NULL, '2026-09-03 14:04:33.844+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('b89befab-ca09-49c9-8535-a05f2261a3ce', '11111111-1111-1111-1111-111111111111', '71c1721d-8f5b-4de0-8e55-31796856656b', NULL, 'CONFIRMED', NULL, NULL, '2026-09-03 14:04:33.856+05:30', 'CONFIRMED', NULL, '689cec0b-ebbc-41c3-b968-1810c5add707');
INSERT INTO public.order_status_history VALUES ('45ed5a00-b2ab-4268-8bcc-fd55e9f1f804', '11111111-1111-1111-1111-111111111111', '71c1721d-8f5b-4de0-8e55-31796856656b', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-03 14:04:33.863+05:30', 'KOT_CREATED', NULL, '689cec0b-ebbc-41c3-b968-1810c5add707');
INSERT INTO public.order_status_history VALUES ('0a87795e-f7c7-47f2-beee-03d5384d9da9', '11111111-1111-1111-1111-111111111111', '9b477c95-d76b-4976-b745-a7a2ef4d4b14', NULL, 'PLACED', NULL, NULL, '2026-09-03 16:15:54.343+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('cb504b7c-e694-4765-bbab-865af4f0ada9', '11111111-1111-1111-1111-111111111111', '9b477c95-d76b-4976-b745-a7a2ef4d4b14', NULL, 'CONFIRMED', NULL, NULL, '2026-09-03 16:15:54.363+05:30', 'CONFIRMED', NULL, '689cec0b-ebbc-41c3-b968-1810c5add707');
INSERT INTO public.order_status_history VALUES ('9ff55ef6-6675-4933-a5d7-1cbbe58c5bb9', '11111111-1111-1111-1111-111111111111', '9b477c95-d76b-4976-b745-a7a2ef4d4b14', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-03 16:15:54.376+05:30', 'KOT_CREATED', NULL, '689cec0b-ebbc-41c3-b968-1810c5add707');
INSERT INTO public.order_status_history VALUES ('005d857e-61d3-426b-87d0-6be8f7f0c7a0', '11111111-1111-1111-1111-111111111111', 'fefda5cf-8409-441a-8e3a-a803c36fb2ce', NULL, 'PLACED', NULL, NULL, '2026-09-03 16:22:16.55+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('18b86930-1c47-43ef-bb39-cebd57fcc7cf', '11111111-1111-1111-1111-111111111111', 'fefda5cf-8409-441a-8e3a-a803c36fb2ce', NULL, 'CONFIRMED', NULL, NULL, '2026-09-03 16:22:16.565+05:30', 'CONFIRMED', NULL, '689cec0b-ebbc-41c3-b968-1810c5add707');
INSERT INTO public.order_status_history VALUES ('a01562b3-412e-4ecb-8972-7eda8007f6ca', '11111111-1111-1111-1111-111111111111', 'fefda5cf-8409-441a-8e3a-a803c36fb2ce', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-03 16:22:16.576+05:30', 'KOT_CREATED', NULL, '689cec0b-ebbc-41c3-b968-1810c5add707');
INSERT INTO public.order_status_history VALUES ('2f09622e-ae0a-4b9a-a535-230c4e2f6337', '11111111-1111-1111-1111-111111111111', 'fefda5cf-8409-441a-8e3a-a803c36fb2ce', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-03 16:22:42.69+05:30', 'IN_PREPARATION', NULL, '1f9b39a0-6147-4978-be02-ce1d6b335ee2');
INSERT INTO public.order_status_history VALUES ('51a56d12-5c6d-4d91-958a-c54d027e06ad', '11111111-1111-1111-1111-111111111111', 'fefda5cf-8409-441a-8e3a-a803c36fb2ce', NULL, 'READY', NULL, NULL, '2026-09-03 16:22:54.673+05:30', 'READY', NULL, '1f9b39a0-6147-4978-be02-ce1d6b335ee2');
INSERT INTO public.order_status_history VALUES ('ee043c2c-b214-4e57-84fc-3de146488033', '11111111-1111-1111-1111-111111111111', 'fefda5cf-8409-441a-8e3a-a803c36fb2ce', NULL, 'HANDED_OVER', NULL, NULL, '2026-09-03 16:23:02.279+05:30', 'HANDED_OVER', NULL, '689cec0b-ebbc-41c3-b968-1810c5add707');
INSERT INTO public.order_status_history VALUES ('2d09b86e-b037-45b5-ba0f-af12d79846ae', '11111111-1111-1111-1111-111111111111', 'fefda5cf-8409-441a-8e3a-a803c36fb2ce', NULL, 'COMPLETED', NULL, NULL, '2026-09-03 17:27:42.988+05:30', 'COMPLETED', NULL, '689cec0b-ebbc-41c3-b968-1810c5add707');
INSERT INTO public.order_status_history VALUES ('1f4e0aed-fb75-48ee-8e3e-5b31241a1199', '11111111-1111-1111-1111-111111111111', 'c14e4df0-40c4-430e-b162-d015a4964c84', NULL, 'PLACED', NULL, NULL, '2026-09-03 17:41:44.281+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('35fe70a7-42d3-40cd-b356-894648125b0c', '11111111-1111-1111-1111-111111111111', 'c14e4df0-40c4-430e-b162-d015a4964c84', NULL, 'CONFIRMED', NULL, NULL, '2026-09-03 17:41:44.298+05:30', 'CONFIRMED', NULL, '689cec0b-ebbc-41c3-b968-1810c5add707');
INSERT INTO public.order_status_history VALUES ('936fb473-65b5-4259-82ae-c6828c024892', '11111111-1111-1111-1111-111111111111', 'c14e4df0-40c4-430e-b162-d015a4964c84', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-03 17:41:44.309+05:30', 'KOT_CREATED', NULL, '689cec0b-ebbc-41c3-b968-1810c5add707');
INSERT INTO public.order_status_history VALUES ('f5a9ebf8-dcad-436b-9b56-75fad52f271b', '11111111-1111-1111-1111-111111111111', '08b726d5-cac2-48d9-b036-a668d5bf7066', NULL, 'PLACED', NULL, NULL, '2026-09-04 16:22:34.421+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('a0a8569d-1426-4b3c-a4fb-76ccc55e78cf', '11111111-1111-1111-1111-111111111111', '08b726d5-cac2-48d9-b036-a668d5bf7066', NULL, 'CONFIRMED', NULL, NULL, '2026-09-04 16:22:34.458+05:30', 'CONFIRMED', NULL, '689cec0b-ebbc-41c3-b968-1810c5add707');
INSERT INTO public.order_status_history VALUES ('72c39b29-c8d3-48ed-a656-83fdc6d3de37', '11111111-1111-1111-1111-111111111111', '08b726d5-cac2-48d9-b036-a668d5bf7066', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-04 16:22:34.468+05:30', 'KOT_CREATED', NULL, '689cec0b-ebbc-41c3-b968-1810c5add707');
INSERT INTO public.order_status_history VALUES ('0efd348e-269b-4cae-8eeb-3859530b6803', '11111111-1111-1111-1111-111111111111', '9b477c95-d76b-4976-b745-a7a2ef4d4b14', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-04 16:23:17.473+05:30', 'IN_PREPARATION', NULL, '1f9b39a0-6147-4978-be02-ce1d6b335ee2');
INSERT INTO public.order_status_history VALUES ('59906551-1a29-4b86-a587-2901227095d9', '11111111-1111-1111-1111-111111111111', '9b477c95-d76b-4976-b745-a7a2ef4d4b14', NULL, 'READY', NULL, NULL, '2026-09-04 16:23:19.114+05:30', 'READY', NULL, '1f9b39a0-6147-4978-be02-ce1d6b335ee2');
INSERT INTO public.order_status_history VALUES ('22bda25c-a8de-4a7a-ab60-1d8dbe43a2ee', '11111111-1111-1111-1111-111111111111', '08b726d5-cac2-48d9-b036-a668d5bf7066', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-04 16:24:12.887+05:30', 'IN_PREPARATION', NULL, '4bc4d34d-f0d4-4402-ae14-2ab128803657');
INSERT INTO public.order_status_history VALUES ('ef9337c5-8a2b-4197-9358-a979b5cfd35d', '11111111-1111-1111-1111-111111111111', '08b726d5-cac2-48d9-b036-a668d5bf7066', NULL, 'READY', NULL, NULL, '2026-09-04 16:24:12.909+05:30', 'READY', NULL, '4bc4d34d-f0d4-4402-ae14-2ab128803657');
INSERT INTO public.order_status_history VALUES ('3cb27f8f-9c46-4a21-89fd-86603d3305ae', '11111111-1111-1111-1111-111111111111', '08b726d5-cac2-48d9-b036-a668d5bf7066', NULL, 'SERVED', NULL, NULL, '2026-09-04 16:24:12.928+05:30', 'SERVED', NULL, '4bc4d34d-f0d4-4402-ae14-2ab128803657');
INSERT INTO public.order_status_history VALUES ('badc43a7-ae76-45f2-8443-c8bc3f960793', '11111111-1111-1111-1111-111111111111', '08b726d5-cac2-48d9-b036-a668d5bf7066', NULL, 'COMPLETED', NULL, NULL, '2026-09-04 16:24:12.95+05:30', 'COMPLETED', NULL, '4bc4d34d-f0d4-4402-ae14-2ab128803657');
INSERT INTO public.order_status_history VALUES ('449358b4-73e4-4456-9097-44d6d445bbb1', '11111111-1111-1111-1111-111111111111', '9b477c95-d76b-4976-b745-a7a2ef4d4b14', NULL, 'SERVED', NULL, NULL, '2026-09-04 16:31:01.78+05:30', 'SERVED', NULL, '4bc4d34d-f0d4-4402-ae14-2ab128803657');
INSERT INTO public.order_status_history VALUES ('8c965c5b-ba32-481d-864c-ce56701fcb71', '11111111-1111-1111-1111-111111111111', '9b477c95-d76b-4976-b745-a7a2ef4d4b14', NULL, 'COMPLETED', NULL, NULL, '2026-09-04 16:31:01.802+05:30', 'COMPLETED', NULL, '4bc4d34d-f0d4-4402-ae14-2ab128803657');
INSERT INTO public.order_status_history VALUES ('c89299b0-3dfa-4257-b264-d7b2fc0d7446', '11111111-1111-1111-1111-111111111111', '2a670867-a3af-4698-aa9a-84afa3fb7e04', NULL, 'PLACED', NULL, NULL, '2026-09-04 16:40:24.868+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('b4bcdc37-f6cd-48b2-875d-65766ff50772', '11111111-1111-1111-1111-111111111111', '2a670867-a3af-4698-aa9a-84afa3fb7e04', NULL, 'CONFIRMED', NULL, NULL, '2026-09-04 16:40:24.887+05:30', 'CONFIRMED', NULL, '4bc4d34d-f0d4-4402-ae14-2ab128803657');
INSERT INTO public.order_status_history VALUES ('31bfd985-9bc5-4457-8969-2ec39ddb0d2c', '11111111-1111-1111-1111-111111111111', '2a670867-a3af-4698-aa9a-84afa3fb7e04', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-04 16:40:24.898+05:30', 'KOT_CREATED', NULL, '4bc4d34d-f0d4-4402-ae14-2ab128803657');
INSERT INTO public.order_status_history VALUES ('3c82839e-5fb8-4eb4-93a4-74ed184d943a', '11111111-1111-1111-1111-111111111111', '2a670867-a3af-4698-aa9a-84afa3fb7e04', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-04 16:41:05.15+05:30', 'IN_PREPARATION', NULL, '4bc4d34d-f0d4-4402-ae14-2ab128803657');
INSERT INTO public.order_status_history VALUES ('6c27a049-0838-449c-a8c6-e18333371006', '11111111-1111-1111-1111-111111111111', '2a670867-a3af-4698-aa9a-84afa3fb7e04', NULL, 'READY', NULL, NULL, '2026-09-04 16:41:05.165+05:30', 'READY', NULL, '4bc4d34d-f0d4-4402-ae14-2ab128803657');
INSERT INTO public.order_status_history VALUES ('b24c6cf9-b2b4-41cf-bb68-d1328e037fe2', '11111111-1111-1111-1111-111111111111', '2a670867-a3af-4698-aa9a-84afa3fb7e04', NULL, 'SERVED', NULL, NULL, '2026-09-04 16:41:05.175+05:30', 'SERVED', NULL, '4bc4d34d-f0d4-4402-ae14-2ab128803657');
INSERT INTO public.order_status_history VALUES ('6971e0bc-494c-4a0d-a1b7-c1d651266cd3', '11111111-1111-1111-1111-111111111111', '2a670867-a3af-4698-aa9a-84afa3fb7e04', NULL, 'COMPLETED', NULL, NULL, '2026-09-04 16:41:05.189+05:30', 'COMPLETED', NULL, '4bc4d34d-f0d4-4402-ae14-2ab128803657');
INSERT INTO public.order_status_history VALUES ('362f0455-a8ff-4fe7-8365-9200bc50a939', '11111111-1111-1111-1111-111111111111', 'e50cff2e-3302-416f-8cb8-82d28229ef6f', NULL, 'PLACED', NULL, NULL, '2026-09-04 16:57:45.07+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('7021500e-d762-4592-95bb-ff6fd9ad1e35', '11111111-1111-1111-1111-111111111111', 'e50cff2e-3302-416f-8cb8-82d28229ef6f', NULL, 'CONFIRMED', NULL, NULL, '2026-09-04 16:57:45.086+05:30', 'CONFIRMED', NULL, '689cec0b-ebbc-41c3-b968-1810c5add707');
INSERT INTO public.order_status_history VALUES ('06f0cd44-109d-47e2-8f5d-1e0604130cdf', '11111111-1111-1111-1111-111111111111', 'e50cff2e-3302-416f-8cb8-82d28229ef6f', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-04 16:57:45.096+05:30', 'KOT_CREATED', NULL, '689cec0b-ebbc-41c3-b968-1810c5add707');
INSERT INTO public.order_status_history VALUES ('0f31379e-e451-468e-b5bd-a1b4ebe1a001', '11111111-1111-1111-1111-111111111111', 'be05502d-64d3-4721-9b8d-270fb383a20f', NULL, 'PLACED', NULL, NULL, '2026-09-07 14:35:48.293+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('339cc415-bfa6-42a2-8f9f-1b6e257d81f7', '11111111-1111-1111-1111-111111111111', 'be05502d-64d3-4721-9b8d-270fb383a20f', NULL, 'CONFIRMED', NULL, NULL, '2026-09-07 14:35:48.333+05:30', 'CONFIRMED', NULL, '689cec0b-ebbc-41c3-b968-1810c5add707');
INSERT INTO public.order_status_history VALUES ('48bf312d-42fa-4402-bb29-03053a69b842', '11111111-1111-1111-1111-111111111111', 'be05502d-64d3-4721-9b8d-270fb383a20f', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-07 14:35:48.342+05:30', 'KOT_CREATED', NULL, '689cec0b-ebbc-41c3-b968-1810c5add707');


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.orders VALUES ('2f066396-49ed-4838-89f4-ec49b387a188', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'ORD-101', 'DINE_IN', 'IN_PREPARATION', '2026-09-03', 9600000, 9600000, 'INR', NULL, 'A1', NULL, '2026-09-03 12:29:04.444453+05:30', '2026-09-03 12:29:04.444453+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 96000, 96000, 'T-01', 'DINE_IN', NULL, 0, 0, 0, 0, 'IDEMP-2f066396-49ed-4838-89f4-ec49b387a188', NULL);
INSERT INTO public.orders VALUES ('993d2eab-0594-4458-a794-18e8d7613ade', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'ORD-100', 'DINE_IN', 'COMPLETED', '2026-09-03', 8400000, 8400000, 'INR', NULL, 'A2', NULL, '2026-09-03 10:29:17.185814+05:30', '2026-09-03 12:29:17.185814+05:30', NULL, NULL, '2026-09-03 12:29:17.185814+05:30', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 84000, 84000, 'T-01', 'DINE_IN', NULL, 0, 0, 0, 0, 'IDEMP-993d2eab-0594-4458-a794-18e8d7613ade', NULL);
INSERT INTO public.orders VALUES ('0b6b41da-4be0-4010-82d8-e397b2a407dc', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'ORD-SW-8821', 'DELIVERY', 'CONFIRMED', '2026-09-03', 10200000, 10200000, 'INR', NULL, NULL, NULL, '2026-09-03 12:29:17.191303+05:30', '2026-09-03 12:29:17.191303+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 'swiggy', 'SW-8821', 'Suresh Kumar', '9848022338', NULL, NULL, NULL, 102000, 102000, 'T-01', 'DINE_IN', NULL, 0, 0, 0, 0, 'IDEMP-0b6b41da-4be0-4010-82d8-e397b2a407dc', NULL);
INSERT INTO public.orders VALUES ('08b726d5-cac2-48d9-b036-a668d5bf7066', '11111111-1111-1111-1111-111111111111', '20260904-0001', 'DINE_IN', 'COMPLETED', '2026-09-04', 7000, 7350, 'INR', NULL, NULL, NULL, '2026-09-04 16:22:34.342+05:30', '2026-09-04 16:24:12.944+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7350, 7000, 'T-01', 'DINE_IN', '2ab31806-b577-4204-ac64-6153ffda1c8a', 0, 350, 0, 0, 'waiter-1788519154263-enc732i73ug', NULL);
INSERT INTO public.orders VALUES ('c14e4df0-40c4-430e-b162-d015a4964c84', '11111111-1111-1111-1111-111111111111', '20260903-0006', 'DINE_IN', 'COMPLETED', '2026-09-03', 5000, 5250, 'INR', NULL, NULL, NULL, '2026-09-03 17:41:44.264+05:30', '2026-09-03 17:42:01.158+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5250, 5000, 'T-01', 'DINE_IN', '2ab31806-b577-4204-ac64-6153ffda1c8a', 0, 250, 0, 0, 'waiter-1788437504219-v5xwpl77i0p', NULL);
INSERT INTO public.orders VALUES ('fefda5cf-8409-441a-8e3a-a803c36fb2ce', '11111111-1111-1111-1111-111111111111', '20260903-0005', 'DINE_IN', 'COMPLETED', '2026-09-03', 25000, 25000, 'INR', NULL, NULL, NULL, '2026-09-03 16:22:16.536+05:30', '2026-09-03 17:38:39.08+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 70000, 60000, 'T-01', 'DINE_IN', NULL, 0, 3000, 2000, 5000, 'waiter-1788432736505-xrn0sb1jhz', NULL);
INSERT INTO public.orders VALUES ('2a670867-a3af-4698-aa9a-84afa3fb7e04', '11111111-1111-1111-1111-111111111111', '20260904-0002', 'DINE_IN', 'COMPLETED', '2026-09-04', 7000, 7350, 'INR', NULL, NULL, NULL, '2026-09-04 16:40:24.847+05:30', '2026-09-04 16:41:13.659+05:30', NULL, NULL, '2026-09-04 16:41:05.212+05:30', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7350, 7000, 'POS-01', 'DELIVERY', NULL, 0, 350, 0, 0, 'ord_1788520224829_kgp8fxj', NULL);
INSERT INTO public.orders VALUES ('e50cff2e-3302-416f-8cb8-82d28229ef6f', '11111111-1111-1111-1111-111111111111', '20260904-0003', 'DINE_IN', 'KOT_CREATED', '2026-09-04', 8000, 8400, 'INR', NULL, NULL, NULL, '2026-09-04 16:57:45.049+05:30', '2026-09-04 16:57:45.092+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8400, 8000, 'T-01', 'DINE_IN', '6af1eb27-21d6-4385-8161-ee8d00317a10', 0, 400, 0, 0, 'waiter-1788521265000-uj1steoc7n', NULL);
INSERT INTO public.orders VALUES ('36b5af51-afbb-4d30-a349-79864c3791d9', '11111111-1111-1111-1111-111111111111', '20260903-0001', 'DINE_IN', 'CONFIRMED', '2026-09-03', 850000, 850000, 'INR', NULL, NULL, NULL, '2026-09-03 13:59:56.789+05:30', '2026-09-03 14:02:43.288+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8904, 8500, 'POS-01', 'DINE_IN', NULL, 0, 404, 0, 0, 'ord_1788424196773_un9ry10', NULL);
INSERT INTO public.orders VALUES ('c925c343-fc96-4899-b5a4-07536894443a', '11111111-1111-1111-1111-111111111111', '20260903-0002', 'DINE_IN', 'KOT_CREATED', '2026-09-03', 850000, 850000, 'INR', NULL, NULL, NULL, '2026-09-03 14:04:17.896+05:30', '2026-09-03 14:04:17.932+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8904, 8500, 'T-01', 'DINE_IN', NULL, 0, 404, 0, 0, 'waiter-1788424457833-ze0nni3e1v', NULL);
INSERT INTO public.orders VALUES ('71c1721d-8f5b-4de0-8e55-31796856656b', '11111111-1111-1111-1111-111111111111', '20260903-0003', 'DINE_IN', 'KOT_CREATED', '2026-09-03', 3400000, 3400000, 'INR', NULL, NULL, NULL, '2026-09-03 14:04:33.829+05:30', '2026-09-03 14:04:33.861+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 35619, 34000, 'T-01', 'DINE_IN', NULL, 0, 1619, 0, 0, 'waiter-1788424473792-4x4yc3zerxj', NULL);
INSERT INTO public.orders VALUES ('9b477c95-d76b-4976-b745-a7a2ef4d4b14', '11111111-1111-1111-1111-111111111111', '20260903-0004', 'DINE_IN', 'COMPLETED', '2026-09-03', 8500, 8500, 'INR', NULL, NULL, NULL, '2026-09-03 16:15:54.324+05:30', '2026-09-04 16:38:44.267+05:30', NULL, NULL, '2026-09-04 16:38:27.244+05:30', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18858, 18000, 'POS-01', 'DINE_IN', NULL, 0, 858, 0, 0, 'ord_1788432354302_pafbv2h', NULL);
INSERT INTO public.orders VALUES ('be05502d-64d3-4721-9b8d-270fb383a20f', '11111111-1111-1111-1111-111111111111', '20260907-0001', 'DINE_IN', 'KOT_CREATED', '2026-09-07', 5500, 5775, 'INR', NULL, NULL, NULL, '2026-09-07 14:35:48.21+05:30', '2026-09-07 14:59:25.371+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 42000, 40000, 'T-01', 'DINE_IN', '2ab31806-b577-4204-ac64-6153ffda1c8a', 0, 2000, 0, 0, 'waiter-1788771948149-exzcit8vqqt', NULL);


--
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.organizations VALUES ('00000000-0000-0000-0000-000000000000', 'Hotel Kapila Hospitality Group', NULL, NULL, '2026-09-02 13:48:18.699+05:30', '2026-09-03 10:32:22.968+05:30', NULL, NULL, '36AAACH7412K1Z9');


--
-- Data for Name: outbound_events; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: outbox_events; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.outbox_events VALUES ('3e13f0b4-a1aa-4191-b5d8-82056a74515a', '11111111-1111-1111-1111-111111111111', 'order.settled', '{"orderId": "9b477c95-d76b-4976-b745-a7a2ef4d4b14", "amountMinor": "18000", "invoiceNumber": "INV-2026-00001", "paymentMethod": "CASH"}', 'PROCESSED', 0, 5, NULL, '2026-09-04 16:38:27.288+05:30', '2026-09-04 16:38:27.567+05:30');
INSERT INTO public.outbox_events VALUES ('3f01635e-7670-42e0-b95a-47675bc412cb', '11111111-1111-1111-1111-111111111111', 'order.settled', '{"orderId": "2a670867-a3af-4698-aa9a-84afa3fb7e04", "amountMinor": "7350", "invoiceNumber": "INV-2026-00002", "paymentMethod": "CASH"}', 'PROCESSED', 0, 5, NULL, '2026-09-04 16:41:05.232+05:30', '2026-09-04 16:41:06.191+05:30');


--
-- Data for Name: outlet_billing_settings; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.outlet_billing_settings VALUES ('9b654cb7-6950-4dc3-bc4c-f95c156f5013', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'INV-', 'KOT-', true, 1.00, false, 0.000, false, 50.000, false, false, '2026-09-03 12:26:21.137922+05:30', '2026-09-03 12:26:21.137922+05:30', '{}');


--
-- Data for Name: outlet_print_settings; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.outlet_print_settings VALUES ('14ecc4c2-1dc8-4db7-a1cc-6158f46125b3', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Kitchen Thermal 80mm', 80, false, true, true, true, true, true, 1, 1, 'Thank you for dining at Hotel Kapila! Please visit again.', '2026-09-03 12:26:21.143648+05:30', '2026-09-03 12:26:21.143648+05:30', '{}');


--
-- Data for Name: outlet_status; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.outlet_status VALUES ('d77ef074-ccb3-431e-954a-19d53ccd6eea', true, '2026-09-05 13:04:10.318134+05:30', 'd119207c-8cf7-4a03-8125-6737c85c210d');


--
-- Data for Name: outlets; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.outlets VALUES ('d77ef074-ccb3-431e-954a-19d53ccd6eea', '00000000-0000-0000-0000-000000000000', 'NZB-01', 'Hotel Kapila', 'Asia/Kolkata', 'INR', '06:00', true, '2026-09-02 13:49:43.777+05:30', '2026-09-02 14:00:06.392+05:30', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Pragathi Nagar, Central Nizamabad, Telangana 503001', NULL, NULL, NULL);
INSERT INTO public.outlets VALUES ('acd46ae6-fbf3-4545-a3b8-c509c8d58857', '00000000-0000-0000-0000-000000000000', 'R327038', 'Hotel kapila', 'Asia/Kolkata', 'INR', '06:00', true, '2026-09-02 14:04:30.887+05:30', '2026-09-03 10:32:23.021+05:30', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Pragathi Nagar, Central Nizamabad, Telangana 503001', NULL, NULL, NULL);
INSERT INTO public.outlets VALUES ('11111111-1111-1111-1111-111111111111', '00000000-0000-0000-0000-000000000000', 'MAIN-01', 'Hotel Kapila (Main Outlet)', 'Asia/Kolkata', 'INR', '05:00:00', true, '2026-09-03 12:49:53.698323+05:30', '2026-09-03 12:49:53.698323+05:30', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


--
-- Data for Name: payment_summary; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: payment_type_master; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.payment_type_master VALUES ('8732d0d6-ddc0-41cc-97be-50aa49029424', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Cash', false, true, 1, '2026-09-03 12:25:45.886976+05:30', '2026-09-03 12:25:45.886976+05:30');
INSERT INTO public.payment_type_master VALUES ('2d3fc23d-8425-4c15-a2b3-d2c41d42a741', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Card (EDC Terminal)', false, true, 2, '2026-09-03 12:25:45.893329+05:30', '2026-09-03 12:25:45.893329+05:30');
INSERT INTO public.payment_type_master VALUES ('f9356c8c-6357-4caf-9315-43d1aa851ff1', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'UPI / QR Code', false, true, 3, '2026-09-03 12:25:45.894471+05:30', '2026-09-03 12:25:45.894471+05:30');
INSERT INTO public.payment_type_master VALUES ('4a6e5ad0-3c0a-4ca9-a319-03520047d9d1', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Swiggy Settlement', true, true, 4, '2026-09-03 12:25:45.895757+05:30', '2026-09-03 12:25:45.895757+05:30');
INSERT INTO public.payment_type_master VALUES ('0a345831-0ccd-4f53-bf07-fff6d7f99d17', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Zomato Settlement', true, true, 5, '2026-09-03 12:25:45.897197+05:30', '2026-09-03 12:25:45.897197+05:30');
INSERT INTO public.payment_type_master VALUES ('da2cf158-036a-4b65-b924-a6b5337f11e7', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Room Service / Due', false, true, 6, '2026-09-03 12:25:45.898551+05:30', '2026-09-03 12:25:45.898551+05:30');
INSERT INTO public.payment_type_master VALUES ('5f3ef7d1-3616-4c92-9345-b7905acb6e8d', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Complimentary / House', false, true, 7, '2026-09-03 12:25:45.899893+05:30', '2026-09-03 12:25:45.899893+05:30');


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.payments VALUES ('68985f59-88fb-4d39-bb29-60ab22644833', '11111111-1111-1111-1111-111111111111', 'fefda5cf-8409-441a-8e3a-a803c36fb2ce', 70000, 'CASH', 'CAPTURED', NULL, 'ef3dc07a-96d2-44c1-a571-1bfbd790cea9', '2026-09-03 17:31:20.45+05:30', NULL, NULL, NULL);
INSERT INTO public.payments VALUES ('c564f487-8ff3-4239-a282-e0052f941842', '11111111-1111-1111-1111-111111111111', 'c14e4df0-40c4-430e-b162-d015a4964c84', 5250, 'CASH', 'CAPTURED', NULL, '8272be06-e410-4329-8048-966153d2268e', '2026-09-03 17:42:01.139+05:30', NULL, NULL, NULL);
INSERT INTO public.payments VALUES ('4b78cb86-cccb-4dd8-8e29-9bd0976e6832', '11111111-1111-1111-1111-111111111111', '08b726d5-cac2-48d9-b036-a668d5bf7066', 7350, 'CASH', 'CAPTURED', NULL, 'da590e2b-be3c-422f-885b-46cdf351d96f', '2026-09-04 16:24:12.963+05:30', NULL, NULL, NULL);
INSERT INTO public.payments VALUES ('5333b942-cd28-4a18-8c57-e78a86253285', '11111111-1111-1111-1111-111111111111', '9b477c95-d76b-4976-b745-a7a2ef4d4b14', 18000, 'CASH', 'CAPTURED', NULL, '98a83867-4fbe-4504-92dd-64016e8034f4', '2026-09-04 16:31:01.808+05:30', NULL, NULL, NULL);
INSERT INTO public.payments VALUES ('966662c9-db46-439c-9dc7-fb492b7d8dac', '11111111-1111-1111-1111-111111111111', '2a670867-a3af-4698-aa9a-84afa3fb7e04', 7350, 'CASH', 'CAPTURED', NULL, '73a0e80b-8dfa-44a7-831d-494ced98fe2d', '2026-09-04 16:41:05.194+05:30', NULL, NULL, NULL);


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.permissions VALUES ('7f1c6209-b313-44ff-8777-015ecec437f1', 'order.create', 'order', 'Permission for order.create', NULL, NULL, 'order.create', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('651ca635-a836-417f-b0a6-44da4e121c2d', 'order.read', 'order', 'Permission for order.read', NULL, NULL, 'order.read', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('f94ce37f-90f9-4c45-98ff-f14da3eade8b', 'order.update', 'order', 'Permission for order.update', NULL, NULL, 'order.update', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('58ea33cf-b752-48df-9f46-a95ea8c1a851', 'order.cancel', 'order', 'Permission for order.cancel', NULL, NULL, 'order.cancel', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('56289ac7-e5e5-4734-bbb8-4a63f989bdc6', 'order.discount', 'order', 'Permission for order.discount', NULL, NULL, 'order.discount', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('d57a15e0-8f01-4a61-9909-43acaefbaf51', 'kot.create', 'kot', 'Permission for kot.create', NULL, NULL, 'kot.create', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('d7f61491-28e9-459c-ba64-74c9c9443aea', 'kot.read', 'kot', 'Permission for kot.read', NULL, NULL, 'kot.read', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('338f3340-1dc2-464b-a7fd-270b7e27fb89', 'kot.update', 'kot', 'Permission for kot.update', NULL, NULL, 'kot.update', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('47af56b5-ed6f-43d7-a994-7a2992f47f4f', 'kot.recall', 'kot', 'Permission for kot.recall', NULL, NULL, 'kot.recall', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('2cfa6d13-2398-4e8d-912f-96474500a4b1', 'kot.manage', 'kot', 'Permission for kot.manage', NULL, NULL, 'kot.manage', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('19699bc6-9a62-4725-a893-cf98722e42d1', 'table.read', 'table', 'Permission for table.read', NULL, NULL, 'table.read', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('4b870f1c-bcce-4574-8c38-fb68015f9708', 'table.transfer', 'table', 'Permission for table.transfer', NULL, NULL, 'table.transfer', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('9d2dee0e-8568-4616-b817-e0b4d916dd36', 'table.merge', 'table', 'Permission for table.merge', NULL, NULL, 'table.merge', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('27164a77-d21c-48cf-adb9-eace596748bd', 'table.split', 'table', 'Permission for table.split', NULL, NULL, 'table.split', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('db8b82c8-adb2-4278-b465-6e418d0fb8ab', 'table.manage', 'table', 'Permission for table.manage', NULL, NULL, 'table.manage', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('5236114c-226f-477d-885a-d0ad2717f646', 'bill.generate', 'bill', 'Permission for bill.generate', NULL, NULL, 'bill.generate', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('14896788-4857-4634-b781-930c6e55e10d', 'bill.settle', 'bill', 'Permission for bill.settle', NULL, NULL, 'bill.settle', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('5e9dbebd-6c51-4fb7-84b9-f2fd991ea2d7', 'bill.reprint', 'bill', 'Permission for bill.reprint', NULL, NULL, 'bill.reprint', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('7fbdcef6-c47d-45b0-8bfa-2a283c7283b3', 'bill.split', 'bill', 'Permission for bill.split', NULL, NULL, 'bill.split', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('98ea91f2-00f4-4e37-8364-ef0819a223a5', 'payment.collect', 'payment', 'Permission for payment.collect', NULL, NULL, 'payment.collect', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('fbd7c908-dff5-4a4b-9840-e57a45b53806', 'payment.refund', 'payment', 'Permission for payment.refund', NULL, NULL, 'payment.refund', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('cdd6275d-273d-4786-a15e-156d77b12437', 'payment.split', 'payment', 'Permission for payment.split', NULL, NULL, 'payment.split', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('f92e9e82-5037-4430-8a6d-cfe8ddb85973', 'menu.read', 'menu', 'Permission for menu.read', NULL, NULL, 'menu.read', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('a506e61b-2ad9-4204-95bb-b9109a8d1e1f', 'menu.category.manage', 'menu', 'Permission for menu.category.manage', NULL, NULL, 'menu.category.manage', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('5770a1fd-4350-4956-a516-21abcd905094', 'menu.item.manage', 'menu', 'Permission for menu.item.manage', NULL, NULL, 'menu.item.manage', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('64a77ffd-1dcb-40c6-b99f-7bc88bf836a2', 'menu.86.toggle', 'menu', 'Permission for menu.86.toggle', NULL, NULL, 'menu.86.toggle', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('d65c6e49-1d1d-4a98-9dc6-ac286c8c6369', 'inventory.read', 'inventory', 'Permission for inventory.read', NULL, NULL, 'inventory.read', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('b018b297-ed9e-4628-86ab-863cbc774440', 'inventory.stock.adjust', 'inventory', 'Permission for inventory.stock.adjust', NULL, NULL, 'inventory.stock.adjust', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('455bd3c6-ef04-429d-94db-86d8c38dbd1c', 'inventory.po.create', 'inventory', 'Permission for inventory.po.create', NULL, NULL, 'inventory.po.create', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('65a26612-bea1-4e96-a542-5a8a6bf3999d', 'inventory.po.approve', 'inventory', 'Permission for inventory.po.approve', NULL, NULL, 'inventory.po.approve', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('4990ce87-5672-42b6-a486-bc6808b913bb', 'inventory.grn.create', 'inventory', 'Permission for inventory.grn.create', NULL, NULL, 'inventory.grn.create', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('5cc584c3-d184-438b-b69e-10943ddeb254', 'inventory.write', 'inventory', 'Permission for inventory.write', NULL, NULL, 'inventory.write', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('b04bd84d-a9f9-455a-acc3-997853e2d1db', 'inventory.stock.deduct', 'inventory', 'Permission for inventory.stock.deduct', NULL, NULL, 'inventory.stock.deduct', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('6ff1f372-74cf-455d-ae62-b4c0de91b978', 'report.read', 'report', 'Permission for report.read', NULL, NULL, 'report.read', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('a74a22e8-8eb3-4c5f-8827-782aee70fa94', 'report.financial.read', 'report', 'Permission for report.financial.read', NULL, NULL, 'report.financial.read', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('aafdb69c-b153-4627-8cb9-c3ddee2429fa', 'report.audit.read', 'report', 'Permission for report.audit.read', NULL, NULL, 'report.audit.read', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('a56ed5d8-10ba-4820-8bc9-2eede58d0841', 'report.export', 'report', 'Permission for report.export', NULL, NULL, 'report.export', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('25c0b132-27dc-4859-a018-1098ab0a24d5', 'report.zreport', 'report', 'Permission for report.zreport', NULL, NULL, 'report.zreport', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('15ee6133-077f-48e4-a757-5db15154758d', 'finance.report', 'finance', 'Permission for finance.report', NULL, NULL, 'finance.report', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('26b8ca42-e043-4e91-b563-46a9b371bfe6', 'finance.cash_drawer.manage', 'finance', 'Permission for finance.cash_drawer.manage', NULL, NULL, 'finance.cash_drawer.manage', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('3c4a7b93-2381-4b47-9418-9ed4f066d978', 'finance.petty_cash.record', 'finance', 'Permission for finance.petty_cash.record', NULL, NULL, 'finance.petty_cash.record', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('63e3c69f-0b84-4d70-9d69-d87466c8b91e', 'crm.read', 'crm', 'Permission for crm.read', NULL, NULL, 'crm.read', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('32e639a7-e313-4190-bdef-11ca04949f65', 'crm.write', 'crm', 'Permission for crm.write', NULL, NULL, 'crm.write', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('878881aa-2960-43e0-aab9-f67bdb8790ef', 'crm.loyalty.redeem', 'crm', 'Permission for crm.loyalty.redeem', NULL, NULL, 'crm.loyalty.redeem', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('f24fe2a1-cc0f-4f09-8fc2-537495890fbf', 'crm.loyalty.issue', 'crm', 'Permission for crm.loyalty.issue', NULL, NULL, 'crm.loyalty.issue', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('346883a8-a02e-4b94-8419-9ce20ba84ef2', 'settings.read', 'settings', 'Permission for settings.read', NULL, NULL, 'settings.read', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('89d67dc3-6313-4af1-a4fd-5ac8d9496df1', 'settings.manage', 'settings', 'Permission for settings.manage', NULL, NULL, 'settings.manage', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('f1ce6fa2-02ba-425f-8079-d8d34ce68fc3', 'users.manage', 'users', 'Permission for users.manage', NULL, NULL, 'users.manage', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('03d2a7fd-ad4c-4bcf-8763-34cffe66d89e', 'users.read', 'users', 'Permission for users.read', NULL, NULL, 'users.read', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('6380d3aa-2b21-4493-a7c6-85b7a5b68d2f', 'outlets.manage', 'outlets', 'Permission for outlets.manage', NULL, NULL, 'outlets.manage', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('0dffc84e-c7c5-4605-8285-4ed4b1515841', 'roles.manage', 'roles', 'Permission for roles.manage', NULL, NULL, 'roles.manage', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('1454f8cf-854b-433f-ac97-fb579248dd4c', 'integration.manage', 'integration', 'Permission for integration.manage', NULL, NULL, 'integration.manage', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('7de5e329-3b2c-409f-9e91-8fee96e9e012', 'integration.sync', 'integration', 'Permission for integration.sync', NULL, NULL, 'integration.sync', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');
INSERT INTO public.permissions VALUES ('a5c9c91e-dabf-4951-b60f-e7296aa69368', 'audit.read', 'audit', 'Permission for audit.read', NULL, NULL, 'audit.read', '2026-09-03 13:02:49.90351+05:30', '2026-09-03 13:02:49.904511+05:30');


--
-- Data for Name: petty_cash_ledger; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: physical_menu_files; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: price_lists; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: purchase_order_items; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: purchase_orders; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: recipe_ingredients; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.recipe_ingredients VALUES ('6fb623d5-f7ab-4883-bd2c-528d952b97a4', '53c7d0a2-abda-41e6-b49e-0f153b0743a1', '89dc542f-6ce0-400f-9232-ba860aa726c7', 0.250, '2026-09-02 17:56:48.701836+05:30', 100, '2026-09-02 17:56:48.701836+05:30');
INSERT INTO public.recipe_ingredients VALUES ('5760c9cf-bcc1-4285-b8e0-762902370826', '53c7d0a2-abda-41e6-b49e-0f153b0743a1', '294ce22a-e3db-4246-b4ba-bc5e41dc2b58', 0.200, '2026-09-02 17:56:48.709388+05:30', 85, '2026-09-02 17:56:48.709388+05:30');
INSERT INTO public.recipe_ingredients VALUES ('8e064b09-196f-4464-873a-8401df8eaf9a', '112e8307-0747-459a-8d45-4bb13f2d0f02', '294ce22a-e3db-4246-b4ba-bc5e41dc2b58', 0.200, '2026-09-02 17:56:48.746212+05:30', 85, '2026-09-02 17:56:48.746212+05:30');
INSERT INTO public.recipe_ingredients VALUES ('5c41a292-d179-442f-aac0-6420917db6aa', '112e8307-0747-459a-8d45-4bb13f2d0f02', '50839189-67bc-43cb-8498-01c6e26d296f', 0.150, '2026-09-02 17:56:48.755243+05:30', 100, '2026-09-02 17:56:48.755243+05:30');


--
-- Data for Name: recipes; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.recipes VALUES ('53c7d0a2-abda-41e6-b49e-0f153b0743a1', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'a0e7da8d-2be8-42d7-9448-794ec1578ce0', '', 1.00, true, '2026-09-02 17:56:48.688+05:30', '2026-09-02 17:56:48.688+05:30', NULL, NULL, 1, NULL);
INSERT INTO public.recipes VALUES ('112e8307-0747-459a-8d45-4bb13f2d0f02', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '88009dc2-f5a2-4739-9437-ab8203222d4d', '', 1.00, true, '2026-09-02 17:56:48.74+05:30', '2026-09-02 17:56:48.74+05:30', NULL, NULL, 1, NULL);


--
-- Data for Name: restaurant_tables; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '7f1c6209-b313-44ff-8777-015ecec437f1', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '651ca635-a836-417f-b0a6-44da4e121c2d', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'f94ce37f-90f9-4c45-98ff-f14da3eade8b', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '58ea33cf-b752-48df-9f46-a95ea8c1a851', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '56289ac7-e5e5-4734-bbb8-4a63f989bdc6', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'd57a15e0-8f01-4a61-9909-43acaefbaf51', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'd7f61491-28e9-459c-ba64-74c9c9443aea', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '338f3340-1dc2-464b-a7fd-270b7e27fb89', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '47af56b5-ed6f-43d7-a994-7a2992f47f4f', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '2cfa6d13-2398-4e8d-912f-96474500a4b1', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '19699bc6-9a62-4725-a893-cf98722e42d1', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '4b870f1c-bcce-4574-8c38-fb68015f9708', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '9d2dee0e-8568-4616-b817-e0b4d916dd36', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '27164a77-d21c-48cf-adb9-eace596748bd', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'db8b82c8-adb2-4278-b465-6e418d0fb8ab', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '5236114c-226f-477d-885a-d0ad2717f646', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '14896788-4857-4634-b781-930c6e55e10d', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '5e9dbebd-6c51-4fb7-84b9-f2fd991ea2d7', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '7fbdcef6-c47d-45b0-8bfa-2a283c7283b3', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '98ea91f2-00f4-4e37-8364-ef0819a223a5', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'fbd7c908-dff5-4a4b-9840-e57a45b53806', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'cdd6275d-273d-4786-a15e-156d77b12437', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'f92e9e82-5037-4430-8a6d-cfe8ddb85973', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'a506e61b-2ad9-4204-95bb-b9109a8d1e1f', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '5770a1fd-4350-4956-a516-21abcd905094', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '64a77ffd-1dcb-40c6-b99f-7bc88bf836a2', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'd65c6e49-1d1d-4a98-9dc6-ac286c8c6369', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'b018b297-ed9e-4628-86ab-863cbc774440', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '455bd3c6-ef04-429d-94db-86d8c38dbd1c', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '65a26612-bea1-4e96-a542-5a8a6bf3999d', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '4990ce87-5672-42b6-a486-bc6808b913bb', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '5cc584c3-d184-438b-b69e-10943ddeb254', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'b04bd84d-a9f9-455a-acc3-997853e2d1db', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '6ff1f372-74cf-455d-ae62-b4c0de91b978', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'a74a22e8-8eb3-4c5f-8827-782aee70fa94', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'aafdb69c-b153-4627-8cb9-c3ddee2429fa', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'a56ed5d8-10ba-4820-8bc9-2eede58d0841', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '25c0b132-27dc-4859-a018-1098ab0a24d5', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '15ee6133-077f-48e4-a757-5db15154758d', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '26b8ca42-e043-4e91-b563-46a9b371bfe6', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '3c4a7b93-2381-4b47-9418-9ed4f066d978', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '63e3c69f-0b84-4d70-9d69-d87466c8b91e', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '32e639a7-e313-4190-bdef-11ca04949f65', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '878881aa-2960-43e0-aab9-f67bdb8790ef', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'f24fe2a1-cc0f-4f09-8fc2-537495890fbf', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '346883a8-a02e-4b94-8419-9ce20ba84ef2', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '89d67dc3-6313-4af1-a4fd-5ac8d9496df1', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'f1ce6fa2-02ba-425f-8079-d8d34ce68fc3', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '03d2a7fd-ad4c-4bcf-8763-34cffe66d89e', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '6380d3aa-2b21-4493-a7c6-85b7a5b68d2f', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '0dffc84e-c7c5-4605-8285-4ed4b1515841', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '1454f8cf-854b-433f-ac97-fb579248dd4c', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '7de5e329-3b2c-409f-9e91-8fee96e9e012', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'a5c9c91e-dabf-4951-b60f-e7296aa69368', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '7f1c6209-b313-44ff-8777-015ecec437f1', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '651ca635-a836-417f-b0a6-44da4e121c2d', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'f94ce37f-90f9-4c45-98ff-f14da3eade8b', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '58ea33cf-b752-48df-9f46-a95ea8c1a851', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '56289ac7-e5e5-4734-bbb8-4a63f989bdc6', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'd57a15e0-8f01-4a61-9909-43acaefbaf51', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'd7f61491-28e9-459c-ba64-74c9c9443aea', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '338f3340-1dc2-464b-a7fd-270b7e27fb89', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '47af56b5-ed6f-43d7-a994-7a2992f47f4f', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '2cfa6d13-2398-4e8d-912f-96474500a4b1', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '19699bc6-9a62-4725-a893-cf98722e42d1', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '4b870f1c-bcce-4574-8c38-fb68015f9708', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '9d2dee0e-8568-4616-b817-e0b4d916dd36', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '27164a77-d21c-48cf-adb9-eace596748bd', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'db8b82c8-adb2-4278-b465-6e418d0fb8ab', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '5236114c-226f-477d-885a-d0ad2717f646', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '14896788-4857-4634-b781-930c6e55e10d', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '5e9dbebd-6c51-4fb7-84b9-f2fd991ea2d7', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '7fbdcef6-c47d-45b0-8bfa-2a283c7283b3', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '98ea91f2-00f4-4e37-8364-ef0819a223a5', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'fbd7c908-dff5-4a4b-9840-e57a45b53806', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'cdd6275d-273d-4786-a15e-156d77b12437', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'f92e9e82-5037-4430-8a6d-cfe8ddb85973', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'a506e61b-2ad9-4204-95bb-b9109a8d1e1f', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '5770a1fd-4350-4956-a516-21abcd905094', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '64a77ffd-1dcb-40c6-b99f-7bc88bf836a2', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'd65c6e49-1d1d-4a98-9dc6-ac286c8c6369', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'b018b297-ed9e-4628-86ab-863cbc774440', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '455bd3c6-ef04-429d-94db-86d8c38dbd1c', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '65a26612-bea1-4e96-a542-5a8a6bf3999d', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '4990ce87-5672-42b6-a486-bc6808b913bb', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '5cc584c3-d184-438b-b69e-10943ddeb254', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'b04bd84d-a9f9-455a-acc3-997853e2d1db', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '6ff1f372-74cf-455d-ae62-b4c0de91b978', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'a74a22e8-8eb3-4c5f-8827-782aee70fa94', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'aafdb69c-b153-4627-8cb9-c3ddee2429fa', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'a56ed5d8-10ba-4820-8bc9-2eede58d0841', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '25c0b132-27dc-4859-a018-1098ab0a24d5', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '15ee6133-077f-48e4-a757-5db15154758d', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '26b8ca42-e043-4e91-b563-46a9b371bfe6', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '3c4a7b93-2381-4b47-9418-9ed4f066d978', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '63e3c69f-0b84-4d70-9d69-d87466c8b91e', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '32e639a7-e313-4190-bdef-11ca04949f65', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '878881aa-2960-43e0-aab9-f67bdb8790ef', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'f24fe2a1-cc0f-4f09-8fc2-537495890fbf', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '346883a8-a02e-4b94-8419-9ce20ba84ef2', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '89d67dc3-6313-4af1-a4fd-5ac8d9496df1', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'f1ce6fa2-02ba-425f-8079-d8d34ce68fc3', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '03d2a7fd-ad4c-4bcf-8763-34cffe66d89e', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '6380d3aa-2b21-4493-a7c6-85b7a5b68d2f', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '0dffc84e-c7c5-4605-8285-4ed4b1515841', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '1454f8cf-854b-433f-ac97-fb579248dd4c', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '7de5e329-3b2c-409f-9e91-8fee96e9e012', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'a5c9c91e-dabf-4951-b60f-e7296aa69368', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '7f1c6209-b313-44ff-8777-015ecec437f1', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '651ca635-a836-417f-b0a6-44da4e121c2d', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'f94ce37f-90f9-4c45-98ff-f14da3eade8b', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '58ea33cf-b752-48df-9f46-a95ea8c1a851', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '56289ac7-e5e5-4734-bbb8-4a63f989bdc6', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'd57a15e0-8f01-4a61-9909-43acaefbaf51', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'd7f61491-28e9-459c-ba64-74c9c9443aea', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '338f3340-1dc2-464b-a7fd-270b7e27fb89', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '47af56b5-ed6f-43d7-a994-7a2992f47f4f', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '2cfa6d13-2398-4e8d-912f-96474500a4b1', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '19699bc6-9a62-4725-a893-cf98722e42d1', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '4b870f1c-bcce-4574-8c38-fb68015f9708', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '9d2dee0e-8568-4616-b817-e0b4d916dd36', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '27164a77-d21c-48cf-adb9-eace596748bd', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'db8b82c8-adb2-4278-b465-6e418d0fb8ab', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '5236114c-226f-477d-885a-d0ad2717f646', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '14896788-4857-4634-b781-930c6e55e10d', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '5e9dbebd-6c51-4fb7-84b9-f2fd991ea2d7', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '7fbdcef6-c47d-45b0-8bfa-2a283c7283b3', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '98ea91f2-00f4-4e37-8364-ef0819a223a5', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'fbd7c908-dff5-4a4b-9840-e57a45b53806', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'cdd6275d-273d-4786-a15e-156d77b12437', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'f92e9e82-5037-4430-8a6d-cfe8ddb85973', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'a506e61b-2ad9-4204-95bb-b9109a8d1e1f', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '5770a1fd-4350-4956-a516-21abcd905094', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '64a77ffd-1dcb-40c6-b99f-7bc88bf836a2', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'd65c6e49-1d1d-4a98-9dc6-ac286c8c6369', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'b018b297-ed9e-4628-86ab-863cbc774440', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '455bd3c6-ef04-429d-94db-86d8c38dbd1c', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '65a26612-bea1-4e96-a542-5a8a6bf3999d', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '4990ce87-5672-42b6-a486-bc6808b913bb', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '5cc584c3-d184-438b-b69e-10943ddeb254', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'b04bd84d-a9f9-455a-acc3-997853e2d1db', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '6ff1f372-74cf-455d-ae62-b4c0de91b978', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'a74a22e8-8eb3-4c5f-8827-782aee70fa94', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'aafdb69c-b153-4627-8cb9-c3ddee2429fa', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'a56ed5d8-10ba-4820-8bc9-2eede58d0841', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '25c0b132-27dc-4859-a018-1098ab0a24d5', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '15ee6133-077f-48e4-a757-5db15154758d', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '26b8ca42-e043-4e91-b563-46a9b371bfe6', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '3c4a7b93-2381-4b47-9418-9ed4f066d978', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '63e3c69f-0b84-4d70-9d69-d87466c8b91e', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '32e639a7-e313-4190-bdef-11ca04949f65', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '878881aa-2960-43e0-aab9-f67bdb8790ef', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'f24fe2a1-cc0f-4f09-8fc2-537495890fbf', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '346883a8-a02e-4b94-8419-9ce20ba84ef2', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '89d67dc3-6313-4af1-a4fd-5ac8d9496df1', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'f1ce6fa2-02ba-425f-8079-d8d34ce68fc3', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '03d2a7fd-ad4c-4bcf-8763-34cffe66d89e', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '6380d3aa-2b21-4493-a7c6-85b7a5b68d2f', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '0dffc84e-c7c5-4605-8285-4ed4b1515841', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '1454f8cf-854b-433f-ac97-fb579248dd4c', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '7de5e329-3b2c-409f-9e91-8fee96e9e012', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'a5c9c91e-dabf-4951-b60f-e7296aa69368', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '7f1c6209-b313-44ff-8777-015ecec437f1', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '651ca635-a836-417f-b0a6-44da4e121c2d', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', 'f94ce37f-90f9-4c45-98ff-f14da3eade8b', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '58ea33cf-b752-48df-9f46-a95ea8c1a851', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '56289ac7-e5e5-4734-bbb8-4a63f989bdc6', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', 'd57a15e0-8f01-4a61-9909-43acaefbaf51', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', 'd7f61491-28e9-459c-ba64-74c9c9443aea', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '19699bc6-9a62-4725-a893-cf98722e42d1', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '4b870f1c-bcce-4574-8c38-fb68015f9708', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '5236114c-226f-477d-885a-d0ad2717f646', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '14896788-4857-4634-b781-930c6e55e10d', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '5e9dbebd-6c51-4fb7-84b9-f2fd991ea2d7', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '7fbdcef6-c47d-45b0-8bfa-2a283c7283b3', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '98ea91f2-00f4-4e37-8364-ef0819a223a5', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', 'fbd7c908-dff5-4a4b-9840-e57a45b53806', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', 'cdd6275d-273d-4786-a15e-156d77b12437', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', 'f92e9e82-5037-4430-8a6d-cfe8ddb85973', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '64a77ffd-1dcb-40c6-b99f-7bc88bf836a2', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '6ff1f372-74cf-455d-ae62-b4c0de91b978', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '25c0b132-27dc-4859-a018-1098ab0a24d5', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '15ee6133-077f-48e4-a757-5db15154758d', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '26b8ca42-e043-4e91-b563-46a9b371bfe6', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '3c4a7b93-2381-4b47-9418-9ed4f066d978', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '63e3c69f-0b84-4d70-9d69-d87466c8b91e', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '32e639a7-e313-4190-bdef-11ca04949f65', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111106', '7f1c6209-b313-44ff-8777-015ecec437f1', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111106', '651ca635-a836-417f-b0a6-44da4e121c2d', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111106', 'f94ce37f-90f9-4c45-98ff-f14da3eade8b', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111106', 'd57a15e0-8f01-4a61-9909-43acaefbaf51', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111106', 'd7f61491-28e9-459c-ba64-74c9c9443aea', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111106', '19699bc6-9a62-4725-a893-cf98722e42d1', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111106', '4b870f1c-bcce-4574-8c38-fb68015f9708', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111106', '9d2dee0e-8568-4616-b817-e0b4d916dd36', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111106', 'f92e9e82-5037-4430-8a6d-cfe8ddb85973', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111105', 'd7f61491-28e9-459c-ba64-74c9c9443aea', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111105', '338f3340-1dc2-464b-a7fd-270b7e27fb89', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111105', '47af56b5-ed6f-43d7-a994-7a2992f47f4f', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111105', '2cfa6d13-2398-4e8d-912f-96474500a4b1', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111105', '651ca635-a836-417f-b0a6-44da4e121c2d', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111105', 'f92e9e82-5037-4430-8a6d-cfe8ddb85973', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111107', '651ca635-a836-417f-b0a6-44da4e121c2d', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111107', 'f94ce37f-90f9-4c45-98ff-f14da3eade8b', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111107', 'd7f61491-28e9-459c-ba64-74c9c9443aea', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111107', '7de5e329-3b2c-409f-9e91-8fee96e9e012', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111107', '1454f8cf-854b-433f-ac97-fb579248dd4c', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111107', 'f92e9e82-5037-4430-8a6d-cfe8ddb85973', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111107', '64a77ffd-1dcb-40c6-b99f-7bc88bf836a2', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', 'd65c6e49-1d1d-4a98-9dc6-ac286c8c6369', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', 'b018b297-ed9e-4628-86ab-863cbc774440', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', '455bd3c6-ef04-429d-94db-86d8c38dbd1c', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', '65a26612-bea1-4e96-a542-5a8a6bf3999d', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', '4990ce87-5672-42b6-a486-bc6808b913bb', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', '5cc584c3-d184-438b-b69e-10943ddeb254', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', 'b04bd84d-a9f9-455a-acc3-997853e2d1db', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', 'f92e9e82-5037-4430-8a6d-cfe8ddb85973', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', '64a77ffd-1dcb-40c6-b99f-7bc88bf836a2', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', '6ff1f372-74cf-455d-ae62-b4c0de91b978', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', '6ff1f372-74cf-455d-ae62-b4c0de91b978', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', 'a74a22e8-8eb3-4c5f-8827-782aee70fa94', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', 'aafdb69c-b153-4627-8cb9-c3ddee2429fa', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', 'a56ed5d8-10ba-4820-8bc9-2eede58d0841', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', '25c0b132-27dc-4859-a018-1098ab0a24d5', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', '15ee6133-077f-48e4-a757-5db15154758d', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', '26b8ca42-e043-4e91-b563-46a9b371bfe6', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', '3c4a7b93-2381-4b47-9418-9ed4f066d978', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', 'a5c9c91e-dabf-4951-b60f-e7296aa69368', '2026-09-03 13:02:49.884297+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', 'db8b82c8-adb2-4278-b465-6e418d0fb8ab', '2026-09-03 13:35:44.95489+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111106', 'db8b82c8-adb2-4278-b465-6e418d0fb8ab', '2026-09-03 13:35:44.960032+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111105', '7f1c6209-b313-44ff-8777-015ecec437f1', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111105', 'f94ce37f-90f9-4c45-98ff-f14da3eade8b', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111105', '58ea33cf-b752-48df-9f46-a95ea8c1a851', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111105', 'd57a15e0-8f01-4a61-9909-43acaefbaf51', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111105', '5236114c-226f-477d-885a-d0ad2717f646', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111105', '14896788-4857-4634-b781-930c6e55e10d', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111105', '98ea91f2-00f4-4e37-8364-ef0819a223a5', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111106', '58ea33cf-b752-48df-9f46-a95ea8c1a851', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111106', '5236114c-226f-477d-885a-d0ad2717f646', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111106', '14896788-4857-4634-b781-930c6e55e10d', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111106', '98ea91f2-00f4-4e37-8364-ef0819a223a5', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111107', '7f1c6209-b313-44ff-8777-015ecec437f1', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111107', '58ea33cf-b752-48df-9f46-a95ea8c1a851', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111107', 'd57a15e0-8f01-4a61-9909-43acaefbaf51', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111107', '5236114c-226f-477d-885a-d0ad2717f646', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111107', '14896788-4857-4634-b781-930c6e55e10d', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111107', '98ea91f2-00f4-4e37-8364-ef0819a223a5', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', '7f1c6209-b313-44ff-8777-015ecec437f1', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', '651ca635-a836-417f-b0a6-44da4e121c2d', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', 'f94ce37f-90f9-4c45-98ff-f14da3eade8b', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', '58ea33cf-b752-48df-9f46-a95ea8c1a851', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', 'd57a15e0-8f01-4a61-9909-43acaefbaf51', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', 'd7f61491-28e9-459c-ba64-74c9c9443aea', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', '5236114c-226f-477d-885a-d0ad2717f646', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', '14896788-4857-4634-b781-930c6e55e10d', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', '98ea91f2-00f4-4e37-8364-ef0819a223a5', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', '7f1c6209-b313-44ff-8777-015ecec437f1', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', '651ca635-a836-417f-b0a6-44da4e121c2d', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', 'f94ce37f-90f9-4c45-98ff-f14da3eade8b', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', '58ea33cf-b752-48df-9f46-a95ea8c1a851', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', 'd57a15e0-8f01-4a61-9909-43acaefbaf51', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', 'd7f61491-28e9-459c-ba64-74c9c9443aea', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', '5236114c-226f-477d-885a-d0ad2717f646', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', '14896788-4857-4634-b781-930c6e55e10d', '2026-09-05 16:41:13.086996+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', '98ea91f2-00f4-4e37-8364-ef0819a223a5', '2026-09-05 16:41:13.086996+05:30');


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.roles VALUES ('11111111-1111-1111-1111-111111111101', 'SUPER_ADMIN', 'SUPER_ADMIN', 'Super Administrator / System IT Admin', '2026-09-02 13:53:43.690532+05:30', '2026-09-02 13:53:43.690532+05:30', NULL, NULL);
INSERT INTO public.roles VALUES ('11111111-1111-1111-1111-111111111102', 'ADMIN', 'ADMIN', 'Administrator', '2026-09-02 13:53:43.690532+05:30', '2026-09-02 13:53:43.690532+05:30', NULL, NULL);
INSERT INTO public.roles VALUES ('11111111-1111-1111-1111-111111111103', 'OUTLET_MANAGER', 'OUTLET_MANAGER', 'Restaurant Manager / Outlet General Admin', '2026-09-02 13:53:43.690532+05:30', '2026-09-02 13:53:43.690532+05:30', NULL, NULL);
INSERT INTO public.roles VALUES ('11111111-1111-1111-1111-111111111104', 'CASHIER', 'CASHIER', 'Cashier / Front-Desk Biller / POS Operator', '2026-09-02 13:53:43.690532+05:30', '2026-09-02 13:53:43.690532+05:30', NULL, NULL);
INSERT INTO public.roles VALUES ('11111111-1111-1111-1111-111111111105', 'KITCHEN_USER', 'KITCHEN_USER', 'Kitchen Staff / Head Chef / KDS Display', '2026-09-02 13:53:43.690532+05:30', '2026-09-02 13:53:43.690532+05:30', NULL, NULL);
INSERT INTO public.roles VALUES ('11111111-1111-1111-1111-111111111106', 'WAITER', 'WAITER', 'Captain / Waiter / Table Steward', '2026-09-02 13:53:43.690532+05:30', '2026-09-02 13:53:43.690532+05:30', NULL, NULL);
INSERT INTO public.roles VALUES ('11111111-1111-1111-1111-111111111107', 'DELIVERY_MANAGER', 'DELIVERY_MANAGER', 'Online Aggregator & Dispatch Manager (Swiggy / Zomato)', '2026-09-03 12:05:42.424743+05:30', '2026-09-03 12:05:42.424743+05:30', NULL, NULL);
INSERT INTO public.roles VALUES ('11111111-1111-1111-1111-111111111108', 'INVENTORY_MANAGER', 'INVENTORY_MANAGER', 'Store & Inventory Manager', '2026-09-03 12:05:42.429255+05:30', '2026-09-03 12:05:42.429255+05:30', NULL, NULL);
INSERT INTO public.roles VALUES ('11111111-1111-1111-1111-111111111109', 'ACCOUNTANT', 'ACCOUNTANT', 'Accountant / Auditor / Financial Controller', '2026-09-03 12:05:42.430332+05:30', '2026-09-03 12:05:42.430332+05:30', NULL, NULL);


--
-- Data for Name: sales_returns; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.schema_migrations VALUES ('0001_extensions_and_enums.sql', '2026-09-02 13:46:06.974479+05:30');
INSERT INTO public.schema_migrations VALUES ('0001_init_identity_and_org.sql', '2026-09-02 13:46:07.239067+05:30');
INSERT INTO public.schema_migrations VALUES ('0002_catalog.sql', '2026-09-02 13:46:07.602951+05:30');
INSERT INTO public.schema_migrations VALUES ('0002_create_users.sql', '2026-09-02 13:46:07.607942+05:30');
INSERT INTO public.schema_migrations VALUES ('0003_create_outlets.sql', '2026-09-02 13:46:07.611378+05:30');
INSERT INTO public.schema_migrations VALUES ('0003_pricing_and_tax.sql', '2026-09-02 13:46:07.677905+05:30');
INSERT INTO public.schema_migrations VALUES ('0004_create_tables_and_sessions.sql', '2026-09-02 13:46:07.78996+05:30');
INSERT INTO public.schema_migrations VALUES ('0004_orders.sql', '2026-09-02 13:46:08.026346+05:30');
INSERT INTO public.schema_migrations VALUES ('0005_create_menu_categories_and_items.sql', '2026-09-02 13:46:08.066558+05:30');
INSERT INTO public.schema_migrations VALUES ('0005_kitchen.sql', '2026-09-02 13:46:08.201142+05:30');
INSERT INTO public.schema_migrations VALUES ('0006_create_menu_item_channel_and_availability.sql', '2026-09-02 13:46:08.280147+05:30');
INSERT INTO public.schema_migrations VALUES ('0006_customers.sql', '2026-09-02 13:46:08.421369+05:30');
INSERT INTO public.schema_migrations VALUES ('0007_create_taxes.sql', '2026-09-02 13:46:08.509041+05:30');
INSERT INTO public.schema_migrations VALUES ('0007_integration.sql', '2026-09-02 13:46:08.765075+05:30');
INSERT INTO public.schema_migrations VALUES ('0008_audit.sql', '2026-09-02 13:46:08.866109+05:30');
INSERT INTO public.schema_migrations VALUES ('0008_create_payment_type_master.sql', '2026-09-02 13:46:08.910878+05:30');
INSERT INTO public.schema_migrations VALUES ('0009_create_orders_and_order_items.sql', '2026-09-02 13:46:08.914264+05:30');
INSERT INTO public.schema_migrations VALUES ('0009_reporting.sql', '2026-09-02 13:46:09.072533+05:30');
INSERT INTO public.schema_migrations VALUES ('0010_create_order_payments.sql', '2026-09-02 13:46:09.075221+05:30');
INSERT INTO public.schema_migrations VALUES ('0011_create_order_audit_log.sql', '2026-09-02 13:46:09.125884+05:30');
INSERT INTO public.schema_migrations VALUES ('0012_create_sales_returns.sql', '2026-09-02 13:46:09.186039+05:30');
INSERT INTO public.schema_migrations VALUES ('0013_create_outlet_billing_and_print_settings.sql', '2026-09-02 13:46:09.250022+05:30');
INSERT INTO public.schema_migrations VALUES ('0014_create_sync_backup_channel_log.sql', '2026-09-02 13:46:09.394741+05:30');
INSERT INTO public.schema_migrations VALUES ('0015_create_user_report_preferences.sql', '2026-09-02 13:46:09.441733+05:30');
INSERT INTO public.schema_migrations VALUES ('0016_extend_outlet_settings_jsonb.sql', '2026-09-02 13:46:09.445149+05:30');
INSERT INTO public.schema_migrations VALUES ('0017_add_stock_to_item_availability', '2026-09-02 13:46:09.446451+05:30');
INSERT INTO public.schema_migrations VALUES ('0017_add_stock_to_item_availability.sql', '2026-09-02 13:46:09.465597+05:30');
INSERT INTO public.schema_migrations VALUES ('0017_payment_idempotency.sql', '2026-09-02 13:46:09.486252+05:30');
INSERT INTO public.schema_migrations VALUES ('0018_create_inventory_tables', '2026-09-02 13:46:09.488604+05:30');
INSERT INTO public.schema_migrations VALUES ('0018_create_inventory_tables.sql', '2026-09-02 13:46:09.639695+05:30');
INSERT INTO public.schema_migrations VALUES ('0019_add_channel_item_mapping_version', '2026-09-02 13:46:09.641155+05:30');
INSERT INTO public.schema_migrations VALUES ('0019_add_channel_item_mapping_version.sql', '2026-09-02 13:46:09.655954+05:30');
INSERT INTO public.schema_migrations VALUES ('0020_create_finance_ledger_tables', '2026-09-02 13:46:09.657346+05:30');
INSERT INTO public.schema_migrations VALUES ('0020_create_finance_ledger_tables.sql', '2026-09-02 13:46:09.726007+05:30');
INSERT INTO public.schema_migrations VALUES ('0021_add_outlet_status', '2026-09-02 13:46:09.727209+05:30');
INSERT INTO public.schema_migrations VALUES ('0021_add_outlet_status.sql', '2026-09-02 13:46:09.747514+05:30');
INSERT INTO public.schema_migrations VALUES ('0022_admin_pipeline_tables', '2026-09-02 13:46:09.748852+05:30');
INSERT INTO public.schema_migrations VALUES ('0022_admin_pipeline_tables.sql', '2026-09-02 13:46:09.883404+05:30');
INSERT INTO public.schema_migrations VALUES ('0023_order_charges_and_waiter_handovers.sql', '2026-09-02 13:46:09.938087+05:30');
INSERT INTO public.schema_migrations VALUES ('0024_table_merge_groups.sql', '2026-09-02 13:46:09.957604+05:30');
INSERT INTO public.schema_migrations VALUES ('0025_modifier_options_and_menu_crud.sql', '2026-09-02 13:46:10.019407+05:30');
INSERT INTO public.schema_migrations VALUES ('0026_special_notes.sql', '2026-09-02 13:46:10.056495+05:30');
INSERT INTO public.schema_migrations VALUES ('0027_areas.sql', '2026-09-02 13:46:10.094428+05:30');
INSERT INTO public.schema_migrations VALUES ('0028_seat_and_merge_enums.sql', '2026-09-02 13:46:10.098317+05:30');
INSERT INTO public.schema_migrations VALUES ('0029_table_merge_groups_and_members.sql', '2026-09-02 13:46:10.187769+05:30');
INSERT INTO public.schema_migrations VALUES ('0030_table_seats.sql', '2026-09-02 13:46:10.224769+05:30');
INSERT INTO public.schema_migrations VALUES ('0031_order_and_order_item_seat_columns.sql', '2026-09-02 13:46:10.261386+05:30');
INSERT INTO public.schema_migrations VALUES ('0032_order_seat_bills.sql', '2026-09-02 13:46:10.29608+05:30');
INSERT INTO public.schema_migrations VALUES ('0033_order_item_seat_shares.sql', '2026-09-02 13:46:10.343365+05:30');
INSERT INTO public.schema_migrations VALUES ('0034_kot_items_outlet_and_seat.sql', '2026-09-02 13:46:10.362132+05:30');
INSERT INTO public.schema_migrations VALUES ('0035_payments_seat_columns.sql', '2026-09-02 13:46:10.388939+05:30');
INSERT INTO public.schema_migrations VALUES ('0036_invoices_per_seat_unique.sql', '2026-09-02 13:46:10.398608+05:30');
INSERT INTO public.schema_migrations VALUES ('0037_table_merge_idempotency.sql', '2026-09-02 13:46:10.428129+05:30');
INSERT INTO public.schema_migrations VALUES ('0038_outlet_contact_and_logo.sql', '2026-09-02 13:46:10.430715+05:30');
INSERT INTO public.schema_migrations VALUES ('0039_online_orders_round_off_and_kot_bill_print.sql', '2026-09-02 13:46:10.461732+05:30');
INSERT INTO public.schema_migrations VALUES ('0040_menu_commission_physical_scheduling.sql', '2026-09-02 13:46:10.600941+05:30');
INSERT INTO public.schema_migrations VALUES ('0041_agent_telemetry.sql', '2026-09-04 14:55:01.694928+05:30');
INSERT INTO public.schema_migrations VALUES ('0042_invoices_amount_and_sync.sql', '2026-09-04 16:36:32.878746+05:30');


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.sessions VALUES ('f969af7f-8500-459d-9400-224e4e93155d', 'd119207c-8cf7-4a03-8125-6737c85c210d', NULL, NULL, NULL, '2026-10-03 12:35:43.203+05:30', NULL, '2026-09-03 12:35:43.214+05:30', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '11df68308dbad7925aaf46ff4bd7d86a5c3021b946970521419b846bcc5770d3', '2026-09-03 12:35:43.214+05:30', NULL);
INSERT INTO public.sessions VALUES ('909ce8e2-ac8a-4aa0-9c74-39e9dca4e42b', 'd119207c-8cf7-4a03-8125-6737c85c210d', NULL, NULL, NULL, '2026-10-03 12:35:57.28+05:30', NULL, '2026-09-03 12:35:57.291+05:30', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '5d4be0453ed12f151957e514297da7c2b30d4d69e23bda43de65f3aae9cda1db', '2026-09-03 12:35:57.291+05:30', NULL);
INSERT INTO public.sessions VALUES ('f59439e7-4ecb-454b-bddd-dd889a10b6c7', 'd119207c-8cf7-4a03-8125-6737c85c210d', NULL, NULL, NULL, '2026-10-03 12:36:07.753+05:30', NULL, '2026-09-03 12:36:07.764+05:30', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '48b07a192a9b00026ea736b5cad97f50d3dea77e3a1cca27e388020987071ca7', '2026-09-03 12:36:07.764+05:30', NULL);
INSERT INTO public.sessions VALUES ('968e3adb-60e3-4c0e-971c-412b6874ff6e', 'd119207c-8cf7-4a03-8125-6737c85c210d', NULL, NULL, NULL, '2026-10-03 12:36:22.85+05:30', NULL, '2026-09-03 12:36:22.861+05:30', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'e03c3fbf39f4175c665ccb34e8f01fb37dc788e2018dccf93d926bfa9a382934', '2026-09-03 12:36:22.861+05:30', NULL);
INSERT INTO public.sessions VALUES ('0cbbaceb-5cd6-48a0-8efb-fddeae71c4cd', 'd119207c-8cf7-4a03-8125-6737c85c210d', NULL, NULL, NULL, '2026-10-03 12:37:26.472+05:30', NULL, '2026-09-03 12:37:26.482+05:30', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '00d33888cd6e6657534604e2fa3d4d95f05fd5476ff40fd9ba47d3ac42177a27', '2026-09-03 12:37:26.482+05:30', NULL);
INSERT INTO public.sessions VALUES ('8c7bfbbe-e366-4f49-b509-e7549cabb960', 'd119207c-8cf7-4a03-8125-6737c85c210d', NULL, NULL, NULL, '2026-10-03 12:38:05.067+05:30', NULL, '2026-09-03 12:38:05.076+05:30', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'e59303cda4b578454d7f7855473ceab79ba37f1d15fbd62f25e114bc22aa62d5', '2026-09-03 12:38:05.076+05:30', NULL);
INSERT INTO public.sessions VALUES ('76cd3008-3003-41f7-a893-3d6c4a8c7694', 'd119207c-8cf7-4a03-8125-6737c85c210d', NULL, NULL, NULL, '2026-10-03 12:38:50.559+05:30', NULL, '2026-09-03 12:38:50.572+05:30', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '6b6915db9d3776a6544f4035277ffe6426f4969b971d48c80b078297e0f7da23', '2026-09-03 12:38:50.572+05:30', NULL);
INSERT INTO public.sessions VALUES ('6fbe295b-9d94-43e4-8fbf-7721c9833db9', 'd119207c-8cf7-4a03-8125-6737c85c210d', NULL, NULL, NULL, '2026-10-03 12:39:31.866+05:30', NULL, '2026-09-03 12:39:31.872+05:30', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '104589bd82e1b846c3bc3abd45e7c744ceb11745822e820ec85bd834afb444b8', '2026-09-03 12:39:31.872+05:30', NULL);
INSERT INTO public.sessions VALUES ('b3842688-d58d-4c03-9884-7463ab601a40', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 12:52:44.194+05:30', NULL, '2026-09-03 12:52:44.206+05:30', '11111111-1111-1111-1111-111111111111', '0e31f81f573f8152a5e4ef263806b183e0b474b525ffb86bf3feec927dd3b471', '2026-09-03 12:52:44.206+05:30', NULL);
INSERT INTO public.sessions VALUES ('ef03cf0b-8cc3-4e3b-abc5-5c8d3389bfb4', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 12:53:00.766+05:30', NULL, '2026-09-03 12:53:00.776+05:30', '11111111-1111-1111-1111-111111111111', '331c145ee3749a3345de1034eee917c932ff24ad7a7dfe5f9f57016fd6df3be2', '2026-09-03 12:53:00.776+05:30', NULL);
INSERT INTO public.sessions VALUES ('ee7e991e-3360-4020-9624-268f505f00a3', 'd119207c-8cf7-4a03-8125-6737c85c210d', NULL, NULL, NULL, '2026-10-03 12:53:12.962+05:30', NULL, '2026-09-03 12:53:12.972+05:30', '11111111-1111-1111-1111-111111111111', '998812b57548f8e3725813e3a9d838db72fa3722b9cdad9c92443beaf84c47fe', '2026-09-03 12:53:12.972+05:30', NULL);
INSERT INTO public.sessions VALUES ('a7183d2b-2a1b-498e-a5b0-63a648cf9b60', '69a2d6ba-06d9-45b3-b03d-096cf16eecda', NULL, NULL, NULL, '2026-10-03 12:53:13.18+05:30', NULL, '2026-09-03 12:53:13.19+05:30', '11111111-1111-1111-1111-111111111111', '0f43293cf58c263fbccfa092a43b843be6b9e6aa4e82a4c77908b46d8da28293', '2026-09-03 12:53:13.19+05:30', NULL);
INSERT INTO public.sessions VALUES ('da91334b-0a75-4f35-8eb8-70a070743de0', '4bc4d34d-f0d4-4402-ae14-2ab128803657', NULL, NULL, NULL, '2026-10-03 12:53:13.466+05:30', NULL, '2026-09-03 12:53:13.476+05:30', '11111111-1111-1111-1111-111111111111', '9668858e3f551c65b794dc6eecc4643511f0864de942f55dd7b081c48d802450', '2026-09-03 12:53:13.476+05:30', NULL);
INSERT INTO public.sessions VALUES ('5a83ed5d-d817-4f60-ad96-da06564f457f', '1f9b39a0-6147-4978-be02-ce1d6b335ee2', NULL, NULL, NULL, '2026-10-03 12:53:13.727+05:30', NULL, '2026-09-03 12:53:13.737+05:30', '11111111-1111-1111-1111-111111111111', 'f2474fd0e5b3178ed0ff43c6c37008b7a431693a02c077ee71425731b456fb5c', '2026-09-03 12:53:13.737+05:30', NULL);
INSERT INTO public.sessions VALUES ('ae6621cf-71e3-42fe-bd36-e3cf48fa296c', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 12:53:13.857+05:30', NULL, '2026-09-03 12:53:13.867+05:30', '11111111-1111-1111-1111-111111111111', 'f8b70a75d672094bcad8f8c9e6ed7e61fb2deee4754c0ed11e71a33ceaa63da8', '2026-09-03 12:53:13.867+05:30', NULL);
INSERT INTO public.sessions VALUES ('c499bbfb-6beb-4c1a-aa4d-427612beb3d7', 'b08cdc54-5636-473f-b74f-8e85aacf186e', NULL, NULL, NULL, '2026-10-03 12:53:13.986+05:30', NULL, '2026-09-03 12:53:13.996+05:30', '11111111-1111-1111-1111-111111111111', 'e67b40fc31454acbe70c8915014c141f1ec75bdf51c90fc54a9e4b1762e9a3c9', '2026-09-03 12:53:13.996+05:30', NULL);
INSERT INTO public.sessions VALUES ('84d5ba42-b03b-45fe-8ce7-bcc45667a4f3', 'e9b596be-3373-46ba-908b-4fb621904d6e', NULL, NULL, NULL, '2026-10-03 12:53:14.111+05:30', NULL, '2026-09-03 12:53:14.121+05:30', '11111111-1111-1111-1111-111111111111', '849ce93bd4357c8ad05c68c1ff7ee12ad05826a3ebad9cf37c2240607c0d0c24', '2026-09-03 12:53:14.121+05:30', NULL);
INSERT INTO public.sessions VALUES ('b9bb2d00-bffd-4536-b3e2-99882302d0e1', '761bcba1-5a1d-4871-bb88-d2d9cc187823', NULL, NULL, NULL, '2026-10-03 12:53:14.236+05:30', NULL, '2026-09-03 12:53:14.247+05:30', '11111111-1111-1111-1111-111111111111', '1e1e2eb17262b62c018e1ece4dbd4e2120b4f7605260adbca2f4c6aca9e68a69', '2026-09-03 12:53:14.247+05:30', NULL);
INSERT INTO public.sessions VALUES ('377c6579-e441-4841-aa99-a05ec969aa3d', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 12:53:42.528+05:30', NULL, '2026-09-03 12:53:42.542+05:30', '11111111-1111-1111-1111-111111111111', 'c76c9ff2ff713aa252bf0926f3aa86c863e03db2b43074dfdfa77d06ff3eaa4d', '2026-09-03 12:53:42.542+05:30', NULL);
INSERT INTO public.sessions VALUES ('d40cc83a-25a9-49b7-a61c-d147aa55545b', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 12:54:14.031+05:30', NULL, '2026-09-03 12:54:14.044+05:30', '11111111-1111-1111-1111-111111111111', '4761f83036e2c64f0b8a2515e45addc5ad81758ce905678f2eacd22555468f5f', '2026-09-03 12:54:14.044+05:30', NULL);
INSERT INTO public.sessions VALUES ('f3441ac3-5ead-48d4-9f7c-132e97b7c075', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 12:54:46.799+05:30', NULL, '2026-09-03 12:54:46.801+05:30', '11111111-1111-1111-1111-111111111111', '6e4aa3b23fbfa223f8e065fe1e1cf08985783bcf306dd8bbbab801ed0757a065', '2026-09-03 12:54:46.801+05:30', NULL);
INSERT INTO public.sessions VALUES ('ac9d5327-1d3a-4533-8481-4f3973ca7929', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 12:54:59.502+05:30', NULL, '2026-09-03 12:54:59.503+05:30', '11111111-1111-1111-1111-111111111111', 'ff24ca7ee000d909a12d348224dcc943f2b033b7e71a8f1e8926e60a82795a05', '2026-09-03 12:54:59.503+05:30', NULL);
INSERT INTO public.sessions VALUES ('5238387c-847a-492b-ac54-b1afe3121dd0', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 12:55:04.643+05:30', NULL, '2026-09-03 12:55:04.645+05:30', '11111111-1111-1111-1111-111111111111', '5162993446f547d9c58214cbf4af916891965622db9fea88948c1000ce30f2fd', '2026-09-03 12:55:04.645+05:30', NULL);
INSERT INTO public.sessions VALUES ('f8c596c4-4fc4-46ef-b862-625670224794', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 12:55:21.701+05:30', NULL, '2026-09-03 12:55:21.702+05:30', '11111111-1111-1111-1111-111111111111', 'a8192fee6f42c1899eab33ca5d9eb2b5762df9d879271b98bc1f92535209b911', '2026-09-03 12:55:21.702+05:30', NULL);
INSERT INTO public.sessions VALUES ('6ba7b88c-24b7-4003-b3bb-9aec0c3fb7f7', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 12:55:42.715+05:30', NULL, '2026-09-03 12:55:42.717+05:30', '11111111-1111-1111-1111-111111111111', 'a7b931e6c1507bdb408ffb5de43d85886b8b48aa2eef48ca3a65d31d0beb2f7a', '2026-09-03 12:55:42.717+05:30', NULL);
INSERT INTO public.sessions VALUES ('756b5601-1f92-435e-95d7-073e44f552ff', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 12:57:29.559+05:30', NULL, '2026-09-03 12:57:29.561+05:30', '11111111-1111-1111-1111-111111111111', '51c82546bbdf5ed15da07d0b33f699a167d6223e1b1a3adb2d34385c214ec457', '2026-09-03 12:57:29.561+05:30', NULL);
INSERT INTO public.sessions VALUES ('658e9cf8-03a8-445a-8869-ec9314cfe0ee', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 12:58:51.82+05:30', NULL, '2026-09-03 12:58:51.824+05:30', '11111111-1111-1111-1111-111111111111', 'b764f2e0165928afd725103f8da807c8fc14c01f6a39a9559d01927f869f1c52', '2026-09-03 12:58:51.824+05:30', NULL);
INSERT INTO public.sessions VALUES ('ac3e134c-af5c-49f5-84f7-6775d1dbdc38', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 13:02:59.926+05:30', NULL, '2026-09-03 13:02:59.939+05:30', '11111111-1111-1111-1111-111111111111', 'bd0bac22cdf067297d516adf5355845403ec7abe96082404346499b0f986e0ad', '2026-09-03 13:02:59.939+05:30', NULL);
INSERT INTO public.sessions VALUES ('9c4b12f1-882d-459c-99b6-4a75583631f7', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 13:08:46.039+05:30', NULL, '2026-09-03 13:08:46.041+05:30', '11111111-1111-1111-1111-111111111111', 'df9e0498ba5f840577619010c0668c95f11aeeb33dc61dc893631e3501109524', '2026-09-03 13:08:46.041+05:30', NULL);
INSERT INTO public.sessions VALUES ('811e29d8-679d-4758-a1c3-c070eed233db', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 13:09:37.651+05:30', NULL, '2026-09-03 13:09:37.654+05:30', '11111111-1111-1111-1111-111111111111', 'da5dfb973808c4f23de18a65faf923ff2d14d7047f33c3f36bcc8f412e8ea466', '2026-09-03 13:09:37.892+05:30', NULL);
INSERT INTO public.sessions VALUES ('6afed6ed-d3a8-49f7-870a-59d7cc289b27', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 13:12:28.278+05:30', NULL, '2026-09-03 13:12:28.281+05:30', '11111111-1111-1111-1111-111111111111', '71eea3a7ebd2dab7c62000d6eee32a6f4cfeb88c4cc68403d2ebb6187c5eb004', '2026-09-03 13:12:28.556+05:30', NULL);
INSERT INTO public.sessions VALUES ('111f8ff4-88db-4fce-b8ba-9cf140caae28', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 13:13:07.228+05:30', NULL, '2026-09-03 13:13:07.231+05:30', '11111111-1111-1111-1111-111111111111', '196d77d52d21deacf045b5e60553ad8d2679c4884eb8fd148e84d3cff390097e', '2026-09-03 13:13:07.426+05:30', NULL);
INSERT INTO public.sessions VALUES ('37978d44-36a7-4f4f-9db0-329d212ae8e3', 'd119207c-8cf7-4a03-8125-6737c85c210d', NULL, NULL, NULL, '2026-10-03 13:13:27.281+05:30', NULL, '2026-09-03 13:13:27.282+05:30', '11111111-1111-1111-1111-111111111111', '0a6e1b8bf7a1e68a05967f426e463bfc98c5539cd3a40f5cc5cb39752a661bfb', '2026-09-03 13:13:27.282+05:30', NULL);
INSERT INTO public.sessions VALUES ('de221165-a767-4609-a1c4-52c5f51be036', '4bc4d34d-f0d4-4402-ae14-2ab128803657', NULL, NULL, NULL, '2026-10-03 13:13:27.603+05:30', NULL, '2026-09-03 13:13:27.604+05:30', '11111111-1111-1111-1111-111111111111', '9d189c33f382a4c56cf1928a4bf2418a479490cbc58b6d2e4e3dca803ef78cd7', '2026-09-03 13:13:27.604+05:30', NULL);
INSERT INTO public.sessions VALUES ('7b15ecbc-b266-4180-ae30-5615e0f0fac8', '1f9b39a0-6147-4978-be02-ce1d6b335ee2', NULL, NULL, NULL, '2026-10-03 13:13:27.864+05:30', NULL, '2026-09-03 13:13:27.865+05:30', '11111111-1111-1111-1111-111111111111', 'fb344fbb9606dc0db3cafe95887054cd820fd3bb7f9192b79a9c6c91d6752173', '2026-09-03 13:13:27.865+05:30', NULL);
INSERT INTO public.sessions VALUES ('32bddb7c-8f88-456d-b800-0d4621206316', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 13:13:28.016+05:30', NULL, '2026-09-03 13:13:28.017+05:30', '11111111-1111-1111-1111-111111111111', '8d6909738300c12bc24cf5493a5c6b39dc6bc666721c1bcf4796e018e1def317', '2026-09-03 13:13:28.017+05:30', NULL);
INSERT INTO public.sessions VALUES ('77e910c1-dfaa-477e-b609-250fec73725e', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 13:36:11.179+05:30', NULL, '2026-09-03 13:36:11.185+05:30', '11111111-1111-1111-1111-111111111111', '9321c730f8bbedd6a536097a42b31a827ebc912b0f3b5fcded40ff23ce3a27f7', '2026-09-03 13:46:34.16+05:30', NULL);
INSERT INTO public.sessions VALUES ('c2fabf19-8c0a-4348-bab0-3c00061c5d90', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 13:16:01.329+05:30', '2026-09-03 13:19:05.95+05:30', '2026-09-03 13:16:01.331+05:30', '11111111-1111-1111-1111-111111111111', '3efd02e62bbfa3227cc36845d1371343b72b892e90c2e8f6ad5bef7e2104fbf2', '2026-09-03 13:19:05.952+05:30', NULL);
INSERT INTO public.sessions VALUES ('e990b240-0232-4191-9821-47db05d73de5', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 13:20:06.858+05:30', '2026-09-03 13:20:18.918+05:30', '2026-09-03 13:20:06.863+05:30', '11111111-1111-1111-1111-111111111111', 'ed64f51e06184817e0d83c52628a171f3713419b0aca5084d8b5f6aba9e8b6ff', '2026-09-03 13:20:18.919+05:30', NULL);
INSERT INTO public.sessions VALUES ('d4468ab7-65cf-4130-b181-cf65b516075a', 'd119207c-8cf7-4a03-8125-6737c85c210d', NULL, NULL, NULL, '2026-10-03 13:20:21.377+05:30', '2026-09-03 13:31:44.059+05:30', '2026-09-03 13:20:21.379+05:30', '11111111-1111-1111-1111-111111111111', '51a7cdf1b62371f1a34e1277ff1982617fbcb084317257e5a03334db0e791731', '2026-09-03 13:31:44.075+05:30', NULL);
INSERT INTO public.sessions VALUES ('303b065e-cfc1-4a8f-9a10-3862c736b6d6', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 13:31:47.336+05:30', NULL, '2026-09-03 13:31:47.352+05:30', '11111111-1111-1111-1111-111111111111', '1551f016140131442ffecf10fc6a1112f281c223fe3d8c1041afd65ff640eb39', '2026-09-03 13:36:04.158+05:30', NULL);
INSERT INTO public.sessions VALUES ('9af40f88-8a60-47ae-af73-487a95c29f99', 'd119207c-8cf7-4a03-8125-6737c85c210d', NULL, NULL, NULL, '2026-10-03 13:19:09.166+05:30', NULL, '2026-09-03 13:19:09.168+05:30', '11111111-1111-1111-1111-111111111111', '6cef8d796479e1046e566ddb7d9e6772128e58de6c1462841ce967c6ed4b1819', '2026-09-03 13:33:58.152+05:30', NULL);
INSERT INTO public.sessions VALUES ('351040b0-0c12-4ece-abc8-cde55cb24064', 'd119207c-8cf7-4a03-8125-6737c85c210d', NULL, NULL, NULL, '2026-10-03 13:41:07.964+05:30', NULL, '2026-09-03 13:41:07.965+05:30', '11111111-1111-1111-1111-111111111111', '56cde2046ba00858c564646460e807cec28d57ee1e1fc608cc39bd545df39c8b', '2026-09-03 13:41:07.965+05:30', NULL);
INSERT INTO public.sessions VALUES ('3b2f96f4-2d1f-4ab0-939c-891c058243f0', 'd119207c-8cf7-4a03-8125-6737c85c210d', NULL, NULL, NULL, '2026-10-03 13:47:00.408+05:30', NULL, '2026-09-03 13:47:00.41+05:30', '11111111-1111-1111-1111-111111111111', '7d1a6a6c64f0a5a1bc656df9205d4cd7695ed83f83223fe0b5e952f5980c1485', '2026-09-03 13:47:00.41+05:30', NULL);
INSERT INTO public.sessions VALUES ('72c50b9f-28a4-4fcf-acdb-078e59d0d26c', 'd119207c-8cf7-4a03-8125-6737c85c210d', NULL, NULL, NULL, '2026-10-03 13:47:18.219+05:30', NULL, '2026-09-03 13:47:18.22+05:30', '11111111-1111-1111-1111-111111111111', '327a9366aec710e90caf5dc0465899051d507a663f7c13bcaa3d0b8371811dff', '2026-09-03 13:47:18.22+05:30', NULL);
INSERT INTO public.sessions VALUES ('ae58ffbc-45fe-49e7-bafe-542fce81928e', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 17:10:47.762+05:30', NULL, '2026-09-03 17:10:47.763+05:30', '11111111-1111-1111-1111-111111111111', 'bac173dc0a7c3a6bed1bb8232ade6db1223bea602cfa6bb9bae535f8cb47947c', '2026-09-03 17:11:00.236+05:30', NULL);
INSERT INTO public.sessions VALUES ('fbc3c537-aefa-45ec-9f1c-e63d8f8249fe', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 13:48:09.967+05:30', NULL, '2026-09-03 13:48:09.97+05:30', '11111111-1111-1111-1111-111111111111', '54aede380c21512d31e14937e02988215c72c3a9ad8a77c3b3fd092cc021750c', '2026-09-03 13:48:25.892+05:30', NULL);
INSERT INTO public.sessions VALUES ('73e3e781-b92a-4636-bfa1-1676df8e8da4', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 14:02:43.21+05:30', NULL, '2026-09-03 14:02:43.217+05:30', '11111111-1111-1111-1111-111111111111', 'fe024a34ba1c0f64ff5609cd9bc3d57775ab74d936850fddf6b140a6e6212c05', '2026-09-03 14:02:43.217+05:30', NULL);
INSERT INTO public.sessions VALUES ('5a370c14-32f2-493c-b6bf-603f786f3eeb', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 17:27:28.351+05:30', NULL, '2026-09-03 17:27:28.354+05:30', '11111111-1111-1111-1111-111111111111', '83b2e885900bbed00ad2d7c0ffb8f3180e0deec2c299e51215b106f3a3c7164d', '2026-09-03 17:27:28.354+05:30', NULL);
INSERT INTO public.sessions VALUES ('c3b9fafa-83a2-4b73-bed3-14cea2a68879', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 17:27:42.797+05:30', NULL, '2026-09-03 17:27:42.799+05:30', '11111111-1111-1111-1111-111111111111', '8aa0fb699b51b5e3e8f33fbc2aba2ed04a65010d9cdde987c37c745d881bb34e', '2026-09-03 17:27:42.799+05:30', NULL);
INSERT INTO public.sessions VALUES ('265d9cff-9550-4bff-845c-37f43b9859c8', '4bc4d34d-f0d4-4402-ae14-2ab128803657', NULL, NULL, NULL, '2026-10-03 13:49:08.228+05:30', NULL, '2026-09-03 13:49:08.23+05:30', '11111111-1111-1111-1111-111111111111', '4870f7d982963ccb8ef7f9d304133eafe60d8b23f9a4486a93ed5d80ba7cf05a', '2026-09-03 14:03:53.05+05:30', NULL);
INSERT INTO public.sessions VALUES ('7f739c58-0404-4714-a8e0-8e7fdeae28ea', 'd119207c-8cf7-4a03-8125-6737c85c210d', NULL, NULL, NULL, '2026-10-03 17:28:08.013+05:30', NULL, '2026-09-03 17:28:08.014+05:30', '11111111-1111-1111-1111-111111111111', 'e30493034878dfaf7458e4287cc540dfc9abd7409395eb41fbb69f92374f6c19', '2026-09-03 17:28:08.014+05:30', NULL);
INSERT INTO public.sessions VALUES ('4992c2d6-b7d7-4413-89d0-f3ea2a9c017e', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 17:30:50.814+05:30', NULL, '2026-09-03 17:30:50.817+05:30', '11111111-1111-1111-1111-111111111111', '1ec44b02448066baaa74c9c51325d41350e2d4cfea0fd225f19aa09e875f16aa', '2026-09-03 17:30:50.817+05:30', NULL);
INSERT INTO public.sessions VALUES ('b3b9d18e-1a6d-4b08-9af7-5b11263b415f', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 17:31:20.366+05:30', NULL, '2026-09-03 17:31:20.369+05:30', '11111111-1111-1111-1111-111111111111', '0ce8e844935be6c32c9d9ba057a223975d15e1fadac9860ac15bc926c8f7a51c', '2026-09-03 17:31:20.369+05:30', NULL);
INSERT INTO public.sessions VALUES ('c1151b08-5921-41c1-acdf-c73945c597c0', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 14:04:12.149+05:30', NULL, '2026-09-03 14:04:12.157+05:30', '11111111-1111-1111-1111-111111111111', '3f746638ff391b0a01881b78c6fd7b954ebdeaf4b4c619022869b56b88349581', '2026-09-03 14:04:53.624+05:30', NULL);
INSERT INTO public.sessions VALUES ('f09d3ecb-5703-4757-8f49-2ae5a1ac410d', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 16:15:54.129+05:30', NULL, '2026-09-03 16:15:54.138+05:30', '11111111-1111-1111-1111-111111111111', '0c6542bd2ae6cdbf3fdb68340ed41242a61549832abc28d928629b169c6b2e6d', '2026-09-03 16:15:54.138+05:30', NULL);
INSERT INTO public.sessions VALUES ('67869c3c-14d4-49b5-8540-cf2e830282a1', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 16:21:03.629+05:30', NULL, '2026-09-03 16:21:03.631+05:30', '11111111-1111-1111-1111-111111111111', 'e478697126894bd4429ec0865ce8790bf2e69c3d46ab68041907d63713d9e3d6', '2026-09-03 16:21:03.631+05:30', NULL);
INSERT INTO public.sessions VALUES ('49cea184-7b11-402f-9f6d-21b32cf7265d', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 17:32:24.927+05:30', NULL, '2026-09-03 17:32:24.929+05:30', '11111111-1111-1111-1111-111111111111', '95e361d0358607fc68e67d477a5afe1e4b62cfcac9839dcce11084ad57bc58a2', '2026-09-03 17:32:24.929+05:30', NULL);
INSERT INTO public.sessions VALUES ('6d5503dc-63e0-494a-8da0-3ee5509a243a', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 17:32:44.295+05:30', NULL, '2026-09-03 17:32:44.297+05:30', '11111111-1111-1111-1111-111111111111', '2a87a34926986c9f161eb6e8e058dd1cd842c70ae76bfda876cd5fb23f9c9bb1', '2026-09-03 17:32:44.297+05:30', NULL);
INSERT INTO public.sessions VALUES ('0b39811a-4bc1-4a47-a250-e23a97227ca1', '1f9b39a0-6147-4978-be02-ce1d6b335ee2', NULL, NULL, NULL, '2026-10-03 16:22:25.987+05:30', NULL, '2026-09-03 16:22:25.992+05:30', '11111111-1111-1111-1111-111111111111', 'b93cd3346fb7bce7b17e0ac6b4239a1eaf1b09316a1c57ded66f15d89d8b6844', '2026-09-03 16:22:25.992+05:30', NULL);
INSERT INTO public.sessions VALUES ('bde84094-5976-4cd4-8fcd-689c1e4cf73d', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 17:38:20.258+05:30', NULL, '2026-09-03 17:38:20.26+05:30', '11111111-1111-1111-1111-111111111111', 'a2b55ab1c52a9d0257e4415484fd350b4d706f6afbbd8c4b29b103b3a39b5fdc', '2026-09-03 17:38:20.26+05:30', NULL);
INSERT INTO public.sessions VALUES ('8c3a6a32-46d9-4334-90b6-908cc7752c6e', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 16:33:12.161+05:30', NULL, '2026-09-03 16:33:12.163+05:30', '11111111-1111-1111-1111-111111111111', '307dda897c3b4dbb88122a1da477581794c3622fe7e99fc4478a3c47f91f2b21', '2026-09-03 16:36:19.157+05:30', NULL);
INSERT INTO public.sessions VALUES ('5d5240d2-da00-42f7-a15a-1c64f7650493', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 17:38:38.986+05:30', NULL, '2026-09-03 17:38:38.987+05:30', '11111111-1111-1111-1111-111111111111', '2dcedf3ebc75e0631ae520f6a4139279b5742a3c2d027567edd9bd91b9c73b27', '2026-09-03 17:38:38.987+05:30', NULL);
INSERT INTO public.sessions VALUES ('0ee8aa1f-2b9b-4410-9790-a80a2fd04eaf', 'd119207c-8cf7-4a03-8125-6737c85c210d', NULL, NULL, NULL, '2026-10-03 17:41:18.433+05:30', NULL, '2026-09-03 17:41:18.434+05:30', '11111111-1111-1111-1111-111111111111', '5d160fecc36dba850049279dfcaaa8030b56cad3ef0211a8ee37fe1abebc1a91', '2026-09-03 17:41:18.434+05:30', NULL);
INSERT INTO public.sessions VALUES ('75116098-7243-41b4-96e1-639cd4d89373', '1f9b39a0-6147-4978-be02-ce1d6b335ee2', NULL, NULL, NULL, '2026-10-04 16:23:10.851+05:30', '2026-09-04 16:23:52.022+05:30', '2026-09-04 16:23:10.852+05:30', '11111111-1111-1111-1111-111111111111', 'ba95196e11b2dfb38ae90d3d9dba2680e05667c81e2ca4cbfa85b8bf0e74fba9', '2026-09-04 16:23:52.024+05:30', NULL);
INSERT INTO public.sessions VALUES ('fd1a14b2-28f9-4793-ac81-0a2802382cca', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 16:50:27.654+05:30', NULL, '2026-09-03 16:50:27.656+05:30', '11111111-1111-1111-1111-111111111111', 'ab8ae86f173a26725d5a8bbbf6e74c4f1b0d6aeb211defa4adcb24b7432b474c', '2026-09-03 16:54:58.169+05:30', NULL);
INSERT INTO public.sessions VALUES ('59a9f0e0-ec0a-47ec-b3eb-d1e6672adf7c', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 16:55:43.166+05:30', NULL, '2026-09-03 16:55:43.167+05:30', '11111111-1111-1111-1111-111111111111', 'fd9bf3b1eb72d5cfee4da4a715fea5f49d0c718ce67259a30cb8a92dc9256fce', '2026-09-03 16:55:58.165+05:30', NULL);
INSERT INTO public.sessions VALUES ('baaef3d9-c391-4433-a378-2935545da861', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 16:21:56.906+05:30', NULL, '2026-09-03 16:21:56.908+05:30', '11111111-1111-1111-1111-111111111111', '4149e7be15530d4a1cfa5e8038d3572e13e236788f2590ee2b94fd5f8e5d1512', '2026-09-03 16:31:57.826+05:30', NULL);
INSERT INTO public.sessions VALUES ('801153b9-5f68-49b1-b1e3-b25b975ff68f', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 16:56:10.249+05:30', NULL, '2026-09-03 16:56:10.252+05:30', '11111111-1111-1111-1111-111111111111', '4b015a71ce85b752fc71c3d2c8f90ef4e2f99a2707941f3eaae42fcf6721e4e0', '2026-09-03 16:56:10.252+05:30', NULL);
INSERT INTO public.sessions VALUES ('0f799963-d97b-4fca-bdb7-41d88f1987ab', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 16:32:07.862+05:30', NULL, '2026-09-03 16:32:07.863+05:30', '11111111-1111-1111-1111-111111111111', '7ae6236d27764aec4dc9f321f9e9db21b96e4647fea3b90627f473c97060817a', '2026-09-03 16:32:27.834+05:30', NULL);
INSERT INTO public.sessions VALUES ('821a6555-3588-46c3-b0b5-bfa123db0627', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 16:56:26.986+05:30', NULL, '2026-09-03 16:56:26.987+05:30', '11111111-1111-1111-1111-111111111111', '98ffc7ef063ed8cac23a4d0f100d414243d90a59752ff87eee53ca83467a2ed3', '2026-09-03 16:56:26.987+05:30', NULL);
INSERT INTO public.sessions VALUES ('93875736-9666-4688-87a8-a48503385af9', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 13:58:33.208+05:30', NULL, '2026-09-03 13:58:33.221+05:30', '11111111-1111-1111-1111-111111111111', 'c48974d0fe0ee14bb7ce8668fb2dfa7a6d724cfccfe15bd143f8b752dd130a6a', '2026-09-03 13:58:33.221+05:30', NULL);
INSERT INTO public.sessions VALUES ('bf4c81f8-02d7-4e75-bb0c-b56c8369f6df', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 16:32:33.491+05:30', NULL, '2026-09-03 16:32:33.493+05:30', '11111111-1111-1111-1111-111111111111', 'a89042123387ff8e7f2d7b1494f261a7f5d1ce388323853e517deeddbcb3c2f3', '2026-09-03 16:32:57.859+05:30', NULL);
INSERT INTO public.sessions VALUES ('994b734b-57c3-4117-9a31-a616065648d4', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 13:59:56.666+05:30', NULL, '2026-09-03 13:59:56.673+05:30', '11111111-1111-1111-1111-111111111111', '416f05fdb36d03728ba1292801d0bc89d979bba0f3d39e35ebf2aa2b06417dd1', '2026-09-03 13:59:56.673+05:30', NULL);
INSERT INTO public.sessions VALUES ('503317b5-280d-4d0b-b1cf-2dd79df818fe', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-04 15:25:05.253+05:30', NULL, '2026-09-04 15:25:05.255+05:30', '11111111-1111-1111-1111-111111111111', 'e26b4fb00a3fdc17490a84ae391d3e3f31a929bba6b0b671d8bbdd3f6ea4ba93', '2026-09-04 15:39:17.907+05:30', NULL);
INSERT INTO public.sessions VALUES ('4f3ae41b-5739-455d-8796-c95005acddc0', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-04 16:19:25.565+05:30', NULL, '2026-09-04 16:19:25.569+05:30', '11111111-1111-1111-1111-111111111111', '9d913cf1e30a9be5df11ee6cf2d943afb4bdb2602686aa0eff373bb8d7e4af57', '2026-09-04 16:19:25.569+05:30', NULL);
INSERT INTO public.sessions VALUES ('f3378a5a-ee0e-4858-aec1-41239acfef2c', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 16:41:09.873+05:30', NULL, '2026-09-03 16:41:09.875+05:30', '11111111-1111-1111-1111-111111111111', 'ee68ba49bc2b14abf020d8e7387c97ceac08cd4ab7872f768ad9e3b1f556fffa', '2026-09-03 16:50:26.176+05:30', NULL);
INSERT INTO public.sessions VALUES ('370e76d9-b9d1-4d91-ba61-a07ad2a023c6', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-04 15:20:33.567+05:30', NULL, '2026-09-04 15:20:33.57+05:30', '11111111-1111-1111-1111-111111111111', 'aa87ebdd4390da4dbfbcf9cdcf595d32b5bc297b33519e3de561b95157a0710d', '2026-09-04 15:24:50.929+05:30', NULL);
INSERT INTO public.sessions VALUES ('37300885-207a-4ac3-bc72-6792beccf493', 'd119207c-8cf7-4a03-8125-6737c85c210d', NULL, NULL, NULL, '2026-10-03 16:50:45.174+05:30', NULL, '2026-09-03 16:50:45.175+05:30', '11111111-1111-1111-1111-111111111111', 'f2cd2424cea7c26ff3f9fdc5d848019a4ea4491ae316c918a8bb1053c172c539', '2026-09-03 16:50:45.175+05:30', NULL);
INSERT INTO public.sessions VALUES ('a3f5d763-85d1-4e32-8616-796e50c2f165', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 17:41:31.855+05:30', NULL, '2026-09-03 17:41:31.857+05:30', '11111111-1111-1111-1111-111111111111', '8049afb87e435ea9440403de2b8782856ce4fd78854a76b0469331fbd23a1faf', '2026-09-03 17:42:50+05:30', NULL);
INSERT INTO public.sessions VALUES ('43da6f71-dd7b-463d-8c2f-f89a31bf3111', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-03 16:59:43.075+05:30', NULL, '2026-09-03 16:59:43.077+05:30', '11111111-1111-1111-1111-111111111111', '1895507c900e87b77bbe36141b2507bf5d95a3531daae51bca40102196a7fab1', '2026-09-03 17:10:45.236+05:30', NULL);
INSERT INTO public.sessions VALUES ('bc5991b9-510c-4d05-9578-0138ff15ca6b', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-04 16:21:45.937+05:30', NULL, '2026-09-04 16:21:45.951+05:30', '11111111-1111-1111-1111-111111111111', '6ee2da024dec96c9a3f43673dd3855f07011fd127201e5519d7d5ca7bdb9215d', '2026-09-04 16:21:45.951+05:30', NULL);
INSERT INTO public.sessions VALUES ('c793e4f2-d686-4fb5-a6b1-3b99a0e3d5ab', '4bc4d34d-f0d4-4402-ae14-2ab128803657', NULL, NULL, NULL, '2026-10-04 16:23:54.571+05:30', NULL, '2026-09-04 16:23:54.573+05:30', '11111111-1111-1111-1111-111111111111', '1c9d03ab85129a61f8073853b8ac1d105b15ad51fddb12c2b4a5b57d506a3d2b', '2026-09-04 16:23:54.573+05:30', NULL);
INSERT INTO public.sessions VALUES ('78094db9-1154-4a79-a184-02eb816f1e5e', '4bc4d34d-f0d4-4402-ae14-2ab128803657', NULL, NULL, NULL, '2026-10-04 16:30:43.128+05:30', NULL, '2026-09-04 16:30:43.138+05:30', '11111111-1111-1111-1111-111111111111', '32ef00a86ba8b3c1edcecae8003fd3a3c2742dae210e0e9fc34dac1ec572849d', '2026-09-04 16:30:43.138+05:30', NULL);
INSERT INTO public.sessions VALUES ('17cea5de-9f43-4c12-a46e-45814b98f159', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-04 16:22:07.148+05:30', NULL, '2026-09-04 16:22:07.162+05:30', '11111111-1111-1111-1111-111111111111', '2f4d2e86fee754c82a4c9bb86dd50eaaf7ec85c6cc531a5b7ad5b246acde2819', '2026-09-04 16:22:54.471+05:30', NULL);
INSERT INTO public.sessions VALUES ('865397e2-f904-4247-a7e1-5f4b8857a8a1', '1f9b39a0-6147-4978-be02-ce1d6b335ee2', NULL, NULL, NULL, '2026-10-04 16:41:28.981+05:30', NULL, '2026-09-04 16:41:28.983+05:30', '11111111-1111-1111-1111-111111111111', '0f44b322343a3eff783aef7c8853b955828663095d99d55fbf479799ac236f3d', '2026-09-04 16:41:28.983+05:30', NULL);
INSERT INTO public.sessions VALUES ('5b2b3fde-5759-47cc-acae-a6d61237b45b', '1f9b39a0-6147-4978-be02-ce1d6b335ee2', NULL, NULL, NULL, '2026-10-04 16:40:50.108+05:30', '2026-09-04 16:42:18.067+05:30', '2026-09-04 16:40:50.11+05:30', '11111111-1111-1111-1111-111111111111', 'c632d990eb9f8a7a8bf67ec0c9de1141c0127981298ef4c9351142bffd71ddef', '2026-09-04 16:42:18.068+05:30', NULL);
INSERT INTO public.sessions VALUES ('255c15ac-f1d5-45e9-bc34-1b177607ef05', 'd119207c-8cf7-4a03-8125-6737c85c210d', NULL, NULL, NULL, '2026-10-07 16:26:54.589+05:30', NULL, '2026-09-07 16:26:54.59+05:30', '11111111-1111-1111-1111-111111111111', '27af59c17e0a81cfd55a16afb2a85842ef7f3c61de23e6dd2ad8a819da427bc9', '2026-09-07 16:26:54.59+05:30', NULL);
INSERT INTO public.sessions VALUES ('34fb3417-3784-4e2b-9f96-edb08f01f36e', 'd119207c-8cf7-4a03-8125-6737c85c210d', NULL, NULL, NULL, '2026-10-07 16:27:11.452+05:30', NULL, '2026-09-07 16:27:11.454+05:30', '11111111-1111-1111-1111-111111111111', 'b3aee4338c76231bc411c56fe8ce806ebbbb3a7aa4b5ac70fd02788037675596', '2026-09-07 16:27:11.454+05:30', NULL);
INSERT INTO public.sessions VALUES ('8725e4ea-bfbc-442f-b683-522b7d4a40e8', '1f9b39a0-6147-4978-be02-ce1d6b335ee2', NULL, NULL, NULL, '2026-10-07 17:32:01.72+05:30', NULL, '2026-09-07 17:32:01.722+05:30', '11111111-1111-1111-1111-111111111111', '163bdd5a970a6c3a5f3887427474a38133051cd87c50cda6c16cd459d3af4113', '2026-09-07 17:32:01.722+05:30', NULL);
INSERT INTO public.sessions VALUES ('715a2170-9128-4e14-a92d-5f380fc52d17', 'd119207c-8cf7-4a03-8125-6737c85c210d', NULL, NULL, NULL, '2026-10-07 17:32:44.298+05:30', NULL, '2026-09-07 17:32:44.3+05:30', '11111111-1111-1111-1111-111111111111', 'cff66464b4725754a982616ef5a6cc79932371d9f0b7c257c6c2144d7cad4552', '2026-09-07 17:32:44.3+05:30', NULL);
INSERT INTO public.sessions VALUES ('90d3eb71-e86d-4890-872b-ccd031845ff7', 'd119207c-8cf7-4a03-8125-6737c85c210d', NULL, NULL, NULL, '2026-10-07 17:38:21.964+05:30', NULL, '2026-09-07 17:38:21.969+05:30', '11111111-1111-1111-1111-111111111111', '22bdc8fe6e2a61ae3840fe15ea56b11fcce6b0d1982e51a9ad196ed0d49719bb', '2026-09-07 17:38:21.969+05:30', NULL);
INSERT INTO public.sessions VALUES ('e5ae6c09-21e5-429b-a90e-35bedada4d66', 'd119207c-8cf7-4a03-8125-6737c85c210d', NULL, NULL, NULL, '2026-10-07 18:24:13.771+05:30', NULL, '2026-09-07 18:24:13.787+05:30', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '32f540049ae3dfcee7b2c3e1f782b832016ad89175a2b67927e39997b98b0a3b', '2026-09-07 18:24:13.787+05:30', NULL);
INSERT INTO public.sessions VALUES ('663f31f7-4093-4a82-ac31-55b54c7a467b', '4bc4d34d-f0d4-4402-ae14-2ab128803657', NULL, NULL, NULL, '2026-10-07 18:24:14.024+05:30', NULL, '2026-09-07 18:24:14.04+05:30', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '6294671e9aa01798adb3a630ea14a309b7eda36ea063f06518058adce6a8f511', '2026-09-07 18:24:14.04+05:30', NULL);
INSERT INTO public.sessions VALUES ('484d3353-2a46-4b0c-9aef-504af5131c90', 'd119207c-8cf7-4a03-8125-6737c85c210d', NULL, NULL, NULL, '2026-10-07 18:24:27.615+05:30', NULL, '2026-09-07 18:24:27.63+05:30', '11111111-1111-1111-1111-111111111111', 'a56137e422a7a5e1a566bd53ddf1937befbeaa770ce70e2f6c43aea59cf88966', '2026-09-07 18:24:27.63+05:30', NULL);
INSERT INTO public.sessions VALUES ('40e928de-939d-4a1e-9a39-b71708866200', '4bc4d34d-f0d4-4402-ae14-2ab128803657', NULL, NULL, NULL, '2026-10-07 18:24:27.982+05:30', NULL, '2026-09-07 18:24:27.997+05:30', '11111111-1111-1111-1111-111111111111', '8db11ca2b71e1311b05535ceb50c80b1355efd418ceb9caa59cc49edf1ce092f', '2026-09-07 18:24:27.997+05:30', NULL);
INSERT INTO public.sessions VALUES ('d0e26003-fc2e-4aef-9d38-ffc84607348c', 'd119207c-8cf7-4a03-8125-6737c85c210d', NULL, NULL, NULL, '2026-10-10 11:10:02.373+05:30', NULL, '2026-09-10 11:10:02.381+05:30', '11111111-1111-1111-1111-111111111111', 'a868a4ba16b2e1caa14aaeb1ec4da6f90f92ee8c33e8c0f12dee695925f1ec48', '2026-09-10 11:10:02.381+05:30', NULL);
INSERT INTO public.sessions VALUES ('ac6939e1-6ef9-436f-b395-7617005cf37e', 'd119207c-8cf7-4a03-8125-6737c85c210d', NULL, NULL, NULL, '2026-10-10 11:12:06.516+05:30', NULL, '2026-09-10 11:12:06.518+05:30', '11111111-1111-1111-1111-111111111111', '55a612432e3178f03e21f0f29811769dce34a02272df6e76ad206ed568318ea7', '2026-09-10 11:12:06.518+05:30', NULL);
INSERT INTO public.sessions VALUES ('b2c0d12a-74d8-49c1-83a9-5789bdd27401', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-04 16:42:21.085+05:30', NULL, '2026-09-04 16:42:21.086+05:30', '11111111-1111-1111-1111-111111111111', 'fc84fd37f7a07969c33c75bb9fb96a4d83e2b33d3a876e65f1d01437020f3087', '2026-09-04 16:48:17.933+05:30', NULL);
INSERT INTO public.sessions VALUES ('b25075df-e158-432d-9360-259d07c6ff23', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-04 16:48:49.099+05:30', NULL, '2026-09-04 16:48:49.101+05:30', '11111111-1111-1111-1111-111111111111', '81957338afe029ee3107ea855d1f4c82cf1cc61d462f86b9a75085e2836c66a5', '2026-09-04 16:48:49.101+05:30', NULL);
INSERT INTO public.sessions VALUES ('79946324-b8f6-4ea4-be11-4d4c27f20ae7', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-04 16:49:13.893+05:30', NULL, '2026-09-04 16:49:13.895+05:30', '11111111-1111-1111-1111-111111111111', '017f3bd10a497744738c8c7d65e24ff9734eded1546d10c744224663cd3a6e67', '2026-09-04 16:55:17.918+05:30', NULL);
INSERT INTO public.sessions VALUES ('9882e126-2093-4c65-942c-70c650abd061', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-04 16:55:43.763+05:30', NULL, '2026-09-04 16:55:43.771+05:30', '11111111-1111-1111-1111-111111111111', '7eee18d2873f413eb432c9cc3560c92d8e4d9d1baef298a0c730ca66e07b5f81', '2026-09-04 16:57:06.528+05:30', NULL);
INSERT INTO public.sessions VALUES ('a4420084-d6ef-499d-88db-be307c48d56b', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-07 14:35:02.791+05:30', NULL, '2026-09-07 14:35:02.797+05:30', '11111111-1111-1111-1111-111111111111', 'fa3cb8971b7bf90e3b93c8aca355cbababeb9b78c0e4229986a0b47cc7d8be13', '2026-09-07 14:49:50.772+05:30', NULL);
INSERT INTO public.sessions VALUES ('cf9f9bf5-814c-43c9-a271-df1ab40df4b6', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-04 16:57:26.394+05:30', NULL, '2026-09-04 16:57:26.396+05:30', '11111111-1111-1111-1111-111111111111', 'a34cf3567da7d65ac8e05365df4af2e86174f32a27569de99bb564cc81e98a80', '2026-09-04 16:57:42.448+05:30', NULL);
INSERT INTO public.sessions VALUES ('d3679cc5-cd8f-4546-85dd-481b04fb4e1d', '1f9b39a0-6147-4978-be02-ce1d6b335ee2', NULL, NULL, NULL, '2026-10-04 16:57:52.47+05:30', NULL, '2026-09-04 16:57:52.473+05:30', '11111111-1111-1111-1111-111111111111', 'e69a08cd74d85c40f373076daaea6fcaf9ff2fb04584bb7f1fca2ec2eaf7f550', '2026-09-04 16:58:12.452+05:30', NULL);
INSERT INTO public.sessions VALUES ('6cf67712-e21c-46f5-9e80-a3bddbe42536', 'd119207c-8cf7-4a03-8125-6737c85c210d', NULL, NULL, NULL, '2026-10-07 14:26:15.14+05:30', NULL, '2026-09-07 14:26:15.144+05:30', '11111111-1111-1111-1111-111111111111', '540aa9f927166d6cf99a60a19ddc0b0f19a547dbdcd52f3d5d1a39d18eae4b5b', '2026-09-07 14:26:15.144+05:30', NULL);
INSERT INTO public.sessions VALUES ('b8c6a85b-3afc-4ced-bc77-809b66ff37fd', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-07 14:58:11.876+05:30', NULL, '2026-09-07 14:58:11.877+05:30', '11111111-1111-1111-1111-111111111111', '367305a7b748d5d19a108cef061bfe4c50af9d12563c41617dda0d3b84a9aff7', '2026-09-07 14:58:13.053+05:30', NULL);
INSERT INTO public.sessions VALUES ('0356390a-7c64-4087-9d43-60adb25388ea', '1f9b39a0-6147-4978-be02-ce1d6b335ee2', NULL, NULL, NULL, '2026-10-07 14:58:23.98+05:30', NULL, '2026-09-07 14:58:23.982+05:30', '11111111-1111-1111-1111-111111111111', '4c2db739333a95bcdb48d8ee74121b552c722fdd4789cbfe26bf25af8b6be240', '2026-09-07 14:58:23.982+05:30', NULL);
INSERT INTO public.sessions VALUES ('5e3c52e1-efdf-46ac-b86c-a71fdc99d511', 'd119207c-8cf7-4a03-8125-6737c85c210d', NULL, NULL, NULL, '2026-10-07 14:58:33.741+05:30', NULL, '2026-09-07 14:58:33.742+05:30', '11111111-1111-1111-1111-111111111111', '6a28b244571f9f45c4e5ac9be7b61be247cda52fd0da277a2e9f4365723fd780', '2026-09-07 14:58:33.742+05:30', NULL);
INSERT INTO public.sessions VALUES ('566f063a-21c5-4b20-b222-e7f27589c2aa', '689cec0b-ebbc-41c3-b968-1810c5add707', NULL, NULL, NULL, '2026-10-07 14:59:04.007+05:30', NULL, '2026-09-07 14:59:04.008+05:30', '11111111-1111-1111-1111-111111111111', 'dc86bde6e7df3abbe7440d18c2f782a43c2aa0632c29d07964c7baac0446bb1d', '2026-09-07 15:13:49.993+05:30', NULL);
INSERT INTO public.sessions VALUES ('40fbf0f2-2a42-465c-b1d1-d5fc1a4c7337', '1f9b39a0-6147-4978-be02-ce1d6b335ee2', NULL, NULL, NULL, '2026-10-07 15:15:46.595+05:30', NULL, '2026-09-07 15:15:46.597+05:30', '11111111-1111-1111-1111-111111111111', '1d3b027aed92c3f46aa0971318dadaa3487390911c89aaa57ec9ab878ccaf32f', '2026-09-07 15:15:46.597+05:30', NULL);
INSERT INTO public.sessions VALUES ('d4d5cc60-2458-494b-b233-f5ade56ebd98', 'd119207c-8cf7-4a03-8125-6737c85c210d', NULL, NULL, NULL, '2026-10-07 15:16:55.716+05:30', NULL, '2026-09-07 15:16:55.72+05:30', '11111111-1111-1111-1111-111111111111', '56893c3147892561d32fc325c55cbd493f776180520e9c39d390d45f6750c232', '2026-09-07 15:16:55.72+05:30', NULL);


--
-- Data for Name: special_notes; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.special_notes VALUES ('2d4a3cb2-1581-465e-a65d-b18cac189859', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Less Masala', 1, true, '2026-09-03 12:25:45.839025+05:30', '2026-09-03 12:25:45.839025+05:30');
INSERT INTO public.special_notes VALUES ('ad11e690-020d-4456-bddf-599009be11fb', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Extra Spicy', 2, true, '2026-09-03 12:25:45.842739+05:30', '2026-09-03 12:25:45.842739+05:30');
INSERT INTO public.special_notes VALUES ('beb57d56-362f-46af-a275-3dafa8305b50', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Jain Style (No Onion/Garlic)', 3, true, '2026-09-03 12:25:45.845104+05:30', '2026-09-03 12:25:45.845104+05:30');
INSERT INTO public.special_notes VALUES ('a3e2f59d-ffc5-4c58-94bf-711443089dd8', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Less Oil / Diet', 4, true, '2026-09-03 12:25:45.847503+05:30', '2026-09-03 12:25:45.847503+05:30');
INSERT INTO public.special_notes VALUES ('a7412cd7-4f92-4b60-bd1e-b14bc237d4fa', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Crispy / Well Done', 5, true, '2026-09-03 12:25:45.849483+05:30', '2026-09-03 12:25:45.849483+05:30');
INSERT INTO public.special_notes VALUES ('bc0640ea-0073-4d87-829a-964d4621a158', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'No Sugar', 6, true, '2026-09-03 12:25:45.851417+05:30', '2026-09-03 12:25:45.851417+05:30');
INSERT INTO public.special_notes VALUES ('d6fc7ea8-78ce-4569-878b-154e9d765b6d', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Quick / VIP Priority', 7, true, '2026-09-03 12:25:45.853504+05:30', '2026-09-03 12:25:45.853504+05:30');


--
-- Data for Name: stations; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.stations VALUES ('12beb15e-bf9c-4faf-a425-3cec84973301', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'GRILL', '192.168.1.101', '2026-09-02 13:52:21.229+05:30', '2026-09-02 14:00:06.424+05:30', NULL, NULL, 600, 900);
INSERT INTO public.stations VALUES ('6f65d1a9-faeb-4fcc-8a49-a42319507cef', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'FRYER', '192.168.1.102', '2026-09-02 13:52:21.241+05:30', '2026-09-02 14:00:06.429+05:30', NULL, NULL, 600, 900);
INSERT INTO public.stations VALUES ('12bc7f3d-81ec-4bfe-9167-be8f3f275dd2', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'PANTRY', '192.168.1.103', '2026-09-02 13:52:21.245+05:30', '2026-09-02 14:00:06.434+05:30', NULL, NULL, 600, 900);
INSERT INTO public.stations VALUES ('4ff6363c-a80d-472e-9499-a9c7d511c024', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'BAR', '192.168.1.104', '2026-09-02 13:52:21.249+05:30', '2026-09-02 14:00:06.438+05:30', NULL, NULL, 600, 900);
INSERT INTO public.stations VALUES ('8c7ccffc-c37a-4ac2-ad9d-17473db3a154', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'KITCHEN', '192.168.1.101', '2026-09-02 14:04:31.034+05:30', '2026-09-03 10:32:23.161+05:30', NULL, NULL, 600, 900);
INSERT INTO public.stations VALUES ('e63df314-fcc1-45a5-bdff-55e9b98c2bf7', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'BAR', '192.168.1.102', '2026-09-02 14:04:31.04+05:30', '2026-09-03 10:32:23.169+05:30', NULL, NULL, 600, 900);
INSERT INTO public.stations VALUES ('d5b3f918-25a8-44a1-837d-d9c9a38575ca', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'DOSA_SECTION', '192.168.1.103', '2026-09-02 14:04:31.044+05:30', '2026-09-03 10:32:23.173+05:30', NULL, NULL, 600, 900);


--
-- Data for Name: sync_jobs; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: sync_state; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: table_merge_groups; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: table_merge_members; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: table_operation_idempotency; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: table_seats; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: table_sessions; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: tax_channel_rules; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.tax_channel_rules VALUES ('22a037b3-27aa-496b-b862-b70a3a923b11', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'b2e1a474-6618-410f-95d1-9fea0d5d7f68', 'dine_in', 'backward', true, '2026-09-03 12:25:45.87871+05:30', '2026-09-03 12:25:45.87871+05:30');
INSERT INTO public.tax_channel_rules VALUES ('da14f41a-74cd-4f09-95a8-485c08364dd4', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'c29dac28-63bf-4c41-82c8-f900739cfcad', 'dine_in', 'backward', true, '2026-09-03 12:25:45.881507+05:30', '2026-09-03 12:25:45.881507+05:30');
INSERT INTO public.tax_channel_rules VALUES ('621f1254-5474-43d2-8985-5301573fec1b', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '44c8b64c-157c-476a-81cb-61000c155adc', 'online', 'forward', true, '2026-09-03 12:25:45.884087+05:30', '2026-09-03 12:25:45.884087+05:30');
INSERT INTO public.tax_channel_rules VALUES ('a368e050-b980-4062-9119-7405fd9c15b4', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', '69338a4c-d682-4727-bbdf-b6a278ccfd1d', 'online', 'forward', true, '2026-09-03 12:25:45.885738+05:30', '2026-09-03 12:25:45.885738+05:30');


--
-- Data for Name: taxes; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.taxes VALUES ('b2e1a474-6618-410f-95d1-9fea0d5d7f68', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'CGST', 2.500, true, '2026-09-03 12:25:45.855151+05:30', '2026-09-03 12:25:45.855151+05:30');
INSERT INTO public.taxes VALUES ('c29dac28-63bf-4c41-82c8-f900739cfcad', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'SGST', 2.500, true, '2026-09-03 12:25:45.865834+05:30', '2026-09-03 12:25:45.865834+05:30');
INSERT INTO public.taxes VALUES ('44c8b64c-157c-476a-81cb-61000c155adc', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'CGST [Online]', 2.500, true, '2026-09-03 12:25:45.867452+05:30', '2026-09-03 12:25:45.867452+05:30');
INSERT INTO public.taxes VALUES ('69338a4c-d682-4727-bbdf-b6a278ccfd1d', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'SGST [Online]', 2.500, true, '2026-09-03 12:25:45.868719+05:30', '2026-09-03 12:25:45.868719+05:30');


--
-- Data for Name: terminals; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.terminals VALUES ('4276a589-636e-4130-8d9e-5b800168cf88', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'T-01', 'Main Cashier Counter T-01', true, '2026-09-02 13:51:17.799+05:30', '2026-09-02 14:00:06.397+05:30', NULL, NULL);
INSERT INTO public.terminals VALUES ('7e868fb0-34ea-49c4-8ddc-4b694f781e6d', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'T-02', 'Express Bar Terminal T-02', true, '2026-09-02 13:51:17.813+05:30', '2026-09-02 14:00:06.399+05:30', NULL, NULL);
INSERT INTO public.terminals VALUES ('8b7045c5-590a-4372-b11e-de0a054a98d5', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'T-01', 'Master POS Terminal T-01', true, '2026-09-02 14:04:30.896+05:30', '2026-09-03 10:32:23.031+05:30', NULL, NULL);
INSERT INTO public.terminals VALUES ('99a2a442-dc6e-4b80-9ba6-27a406722d4f', 'acd46ae6-fbf3-4545-a3b8-c509c8d58857', 'cp4', 'Captain Mobile Station cp4', true, '2026-09-02 14:04:30.906+05:30', '2026-09-03 10:32:23.04+05:30', NULL, NULL);


--
-- Data for Name: user_quick_links; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: user_report_preferences; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.user_roles VALUES ('d119207c-8cf7-4a03-8125-6737c85c210d', '11111111-1111-1111-1111-111111111101', NULL, '2026-09-02 13:55:19.310654+05:30', NULL, '2026-09-02 13:55:19.309+05:30', NULL);
INSERT INTO public.user_roles VALUES ('4bc4d34d-f0d4-4402-ae14-2ab128803657', '11111111-1111-1111-1111-111111111104', NULL, '2026-09-02 13:55:19.532539+05:30', NULL, '2026-09-02 13:55:19.532+05:30', NULL);
INSERT INTO public.user_roles VALUES ('1f9b39a0-6147-4978-be02-ce1d6b335ee2', '11111111-1111-1111-1111-111111111105', NULL, '2026-09-02 13:55:19.754222+05:30', NULL, '2026-09-02 13:55:19.754+05:30', NULL);
INSERT INTO public.user_roles VALUES ('69a2d6ba-06d9-45b3-b03d-096cf16eecda', '11111111-1111-1111-1111-111111111103', NULL, '2026-09-03 12:05:42.62706+05:30', NULL, '2026-09-03 12:05:42.62706+05:30', NULL);
INSERT INTO public.user_roles VALUES ('689cec0b-ebbc-41c3-b968-1810c5add707', '11111111-1111-1111-1111-111111111106', NULL, '2026-09-03 12:05:42.637215+05:30', NULL, '2026-09-03 12:05:42.637215+05:30', NULL);
INSERT INTO public.user_roles VALUES ('b08cdc54-5636-473f-b74f-8e85aacf186e', '11111111-1111-1111-1111-111111111107', NULL, '2026-09-03 12:05:42.642513+05:30', NULL, '2026-09-03 12:05:42.642513+05:30', NULL);
INSERT INTO public.user_roles VALUES ('e9b596be-3373-46ba-908b-4fb621904d6e', '11111111-1111-1111-1111-111111111108', NULL, '2026-09-03 12:05:42.645841+05:30', NULL, '2026-09-03 12:05:42.645841+05:30', NULL);
INSERT INTO public.user_roles VALUES ('761bcba1-5a1d-4871-bb88-d2d9cc187823', '11111111-1111-1111-1111-111111111109', NULL, '2026-09-03 12:05:42.64913+05:30', NULL, '2026-09-03 12:05:42.64913+05:30', NULL);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.users VALUES ('4bc4d34d-f0d4-4402-ae14-2ab128803657', 'cashier@hotelkapila.com', NULL, '', '$2a$10$Ab1.yfL403Umy95GUdPlwulDl1PyVTB.5wu.1fsb6Fs50c3AIBXja', false, true, '2026-09-02 13:55:19.527+05:30', '2026-09-02 14:00:06.929+05:30', NULL, NULL, 'Kapila', 'Cashier', '$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.');
INSERT INTO public.users VALUES ('1f9b39a0-6147-4978-be02-ce1d6b335ee2', 'chef@hotelkapila.com', NULL, '', '$2a$10$Ab1.yfL403Umy95GUdPlwulDl1PyVTB.5wu.1fsb6Fs50c3AIBXja', false, true, '2026-09-02 13:55:19.75+05:30', '2026-09-02 14:00:07.25+05:30', NULL, NULL, 'Head', 'Chef', '$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.');
INSERT INTO public.users VALUES ('689cec0b-ebbc-41c3-b968-1810c5add707', 'waiter@hotelkapila.com', NULL, '', '$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.', false, true, '2026-09-03 12:05:42.635274+05:30', '2026-09-03 12:05:42.635274+05:30', NULL, NULL, 'Rahul', 'Kumar', '$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.');
INSERT INTO public.users VALUES ('b08cdc54-5636-473f-b74f-8e85aacf186e', 'delivery@hotelkapila.com', NULL, '', '$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.', false, true, '2026-09-03 12:05:42.640362+05:30', '2026-09-03 12:05:42.640362+05:30', NULL, NULL, 'Amit', 'Verma', '$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.');
INSERT INTO public.users VALUES ('e9b596be-3373-46ba-908b-4fb621904d6e', 'inventory@hotelkapila.com', NULL, '', '$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.', false, true, '2026-09-03 12:05:42.644207+05:30', '2026-09-03 12:05:42.644207+05:30', NULL, NULL, 'Vikram', 'Patel', '$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.');
INSERT INTO public.users VALUES ('761bcba1-5a1d-4871-bb88-d2d9cc187823', 'accountant@hotelkapila.com', NULL, '', '$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.', false, true, '2026-09-03 12:05:42.647422+05:30', '2026-09-03 12:05:42.647422+05:30', NULL, NULL, 'Suresh', 'Iyer', '$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.');
INSERT INTO public.users VALUES ('d119207c-8cf7-4a03-8125-6737c85c210d', 'admin@hotelkapila.com', NULL, '', '$2a$10$Ab1.yfL403Umy95GUdPlwulDl1PyVTB.5wu.1fsb6Fs50c3AIBXja', false, true, '2026-09-02 13:54:19.215+05:30', '2026-09-02 14:00:06.685+05:30', NULL, NULL, 'Abdul', 'Mannan', '$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.');
INSERT INTO public.users VALUES ('69a2d6ba-06d9-45b3-b03d-096cf16eecda', 'manager@hotelkapila.com', NULL, '', '$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.', false, true, '2026-09-03 12:05:42.62393+05:30', '2026-09-03 12:05:42.62393+05:30', NULL, NULL, 'Rajesh', 'Sharma', '$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.');


--
-- Data for Name: vendors; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.vendors VALUES ('e74e8223-0249-4e4f-a7c3-e1622d6e894e', 'd77ef074-ccb3-431e-954a-19d53ccd6eea', 'Metro Cash & Carry', NULL, NULL, NULL, NULL, true, '2026-09-02 14:02:54.669+05:30', '2026-09-02 14:02:54.669+05:30', NULL, NULL, '9876543210', 'sales@metro.co.in', '29AAECM1234N1Z5', NULL, NULL);


--
-- Data for Name: waiter_shift_handovers; Type: TABLE DATA; Schema: public; Owner: pos
--



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
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pos
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

\unrestrict jLCaynpyTTZTei24jnhPfv09PWqtoS0mYiFMx4f993v6hQfpXJLwzRX4OqeaO8N

