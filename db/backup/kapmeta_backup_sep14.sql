--
-- PostgreSQL database dump
--

\restrict Vhjfr4WZgVnPxUo24qIF1HkZlcTEnZe77lgaXbfG1MW3mIR1ccicBhrI1mrdBfP

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
ALTER TABLE IF EXISTS ONLY public.menu_items DROP CONSTRAINT IF EXISTS menu_items_station_id_fkey;
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



--
-- Data for Name: access_logs_y2026m08; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: addon_commissions; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: agent_telemetry; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.agent_telemetry VALUES ('agent-orchestrator', 'Orchestrator Agent', 'SYSTEM_COORDINATOR', 'ONLINE', 'Cross-System Workflow Coordination & Port Management (4001, 4444, 5432)', 4001, 1, 'Passing', 'Supervising backend, frontend and persistence processes', '{"dbPort": 5432, "apiPort": 4001, "posPort": 4444, "supervisor": "active"}', '["scripts/startup.ps1", "scripts/shutdown.ps1", "scripts/status.ts", "Start_PetPooja.bat"]', '2026-09-05 13:04:21.407615+05:30');
INSERT INTO public.agent_telemetry VALUES ('agent-a2a', 'A2A Coordination Agent', 'A2A_COORDINATOR', 'ONLINE', 'Inter-Agent Protocol, State Sync & Admin Hub Telemetry', 4001, 2, 'Passing', 'Routing inter-agent WebSocket topics and aggregating live telemetry', '{"activeAgents": 8, "syncChannels": ["HTTP", "WS", "REGISTRY"], "protocolVersion": "2.0"}', '["agents/a2a-agent.md", "agents/AGENT_REGISTRY.json", "agents/task-board.json", "apps/api/src/routes/admin.ts", "apps/pos-web/pages/admin.tsx"]', '2026-09-05 13:04:21.407615+05:30');
INSERT INTO public.agent_telemetry VALUES ('agent-frontend', 'Frontend UI Agent', 'UI_ENGINEER', 'ONLINE', 'POS Web UI (Port 4444) & Admin Management Consoles', 4444, 3, 'Passing', 'Serving KapMeta POS shell, touch billing, KDS board & executive admin', '{"posPort": 4444, "touchSupport": true, "bundleOptimized": true}', '["apps/pos-web/pages/*", "apps/pos-web/components/*", "apps/pos-web/lib/auth.ts"]', '2026-09-05 13:04:21.407615+05:30');
INSERT INTO public.agent_telemetry VALUES ('agent-backend', 'Backend API Agent', 'BACKEND_ENGINEER', 'ONLINE', 'API Gateway (Port 4001), Services & Event Bus', 4001, 2, 'Passing', 'Routing HTTP endpoints, JWT claim verification, and event subscriptions', '{"apiPort": 4001, "jwtScoping": "outlet_id", "activeRoutes": 18}', '["apps/api/src/index.ts", "apps/api/src/routes/*", "services/*"]', '2026-09-05 13:04:21.407615+05:30');
INSERT INTO public.agent_telemetry VALUES ('agent-database', 'Database Persistence Agent', 'DBA_ENGINEER', 'ONLINE', 'PostgreSQL (Port 5432) & Prisma Multi-Tenant Schema', 5432, 1, 'Passing', 'Maintaining multi-tenant schema, seed tools, and backup parity', '{"dbPort": 5432, "poolConnections": 10, "minorUnitStandard": "BIGINT paise"}', '["kapmeta/schema.prisma", "scripts/db-migrate.js", "scripts/seed-dynamic-data.ts"]', '2026-09-05 13:04:21.407615+05:30');
INSERT INTO public.agent_telemetry VALUES ('agent-integration', 'Integration Hub Agent', 'INTEGRATION_ENGINEER', 'ONLINE', 'Online Aggregators (Swiggy/Zomato), Payments & Thermal Printers', 4001, 4, 'Passing', 'Handling HMAC webhooks, idempotent ingestion, and DLQ retries', '{"webhookActive": true, "supportedChannels": ["SWIGGY", "ZOMATO"]}', '["services/integration-hub/*", "services/integration/*"]', '2026-09-05 13:04:21.407615+05:30');
INSERT INTO public.agent_telemetry VALUES ('agent-qa', 'QA & Verification Agent', 'TEST_ENGINEER', 'ONLINE', 'Unit Tests, Contract Validation & E2E Simulation', 4001, 5, 'Passing', 'Running vitest suites, type validation, and pilot simulation drills', '{"pilotDrills": "ENABLED", "testsPassing": 55, "e2eValidation": true}', '["tests/*", "scripts/pilot-e2e-simulation.ts", "vitest.config.ts"]', '2026-09-05 13:04:21.407615+05:30');
INSERT INTO public.agent_telemetry VALUES ('agent-sre', 'SRE & Diagnostics Agent', 'SRE_ENGINEER', 'ONLINE', 'Log Management, Process Monitoring & Diagnostics', 4001, 2, 'Passing', 'Monitoring logs/ directory, service heartbeats, and error traces', '{"logScanner": "active", "healthChecksPassing": true}', '["logs/*", "scripts/status.ts"]', '2026-09-05 13:04:21.407615+05:30');


--
-- Data for Name: areas; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.areas VALUES ('d25e7785-37ed-4e88-8fa8-90aeb7b51dcc', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'AC', 1, true, '2026-09-03 12:29:17.285432+05:30', '2026-09-03 12:29:17.285432+05:30');
INSERT INTO public.areas VALUES ('489fb172-f3ca-423e-a849-ddebcc989f72', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Non AC', 2, true, '2026-09-03 12:29:17.29417+05:30', '2026-09-03 12:29:17.29417+05:30');
INSERT INTO public.areas VALUES ('7b3f6ac3-16c9-4e5c-8bb3-b021df77c442', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Outdoor Garden', 3, true, '2026-09-03 12:29:17.295308+05:30', '2026-09-03 12:29:17.295308+05:30');
INSERT INTO public.areas VALUES ('1bf7ea56-a656-4b1b-866e-19590a889aa4', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Terrace Lounge', 4, true, '2026-09-03 12:29:17.296396+05:30', '2026-09-03 12:29:17.296396+05:30');
INSERT INTO public.areas VALUES ('3080fcd5-dbc0-4ef7-aeb5-dae4b7e76b31', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Family Section', 5, true, '2026-09-03 12:29:17.297226+05:30', '2026-09-03 12:29:17.297226+05:30');
INSERT INTO public.areas VALUES ('2520dd1d-9535-4a03-ae3a-ec8b9cd1573c', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Other', 6, true, '2026-09-03 12:29:17.298014+05:30', '2026-09-03 12:29:17.298014+05:30');


--
-- Data for Name: audit_logs_default; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.audit_logs_default VALUES ('3616c098-2c83-431e-8542-c22781955a5e', '11111111-1111-1111-1111-111111111111', 'ORDER', 'e7eccfdc-02d5-470f-869b-da665f7dcb2e', 'CREATE', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, '{"items": [{"id": "025735c2-f199-4819-a694-73b1b678ed09", "quantity": 1, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}], "originalAction": "ORDER_ITEMS_ADDED"}', '2026-09-04 00:02:44.822+05:30', '2026-09-04 00:02:44.743219+05:30', NULL, NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('d3a356d8-3ffb-47e6-a49b-6bab6668b49c', '11111111-1111-1111-1111-111111111111', 'PAYMENT', '589efb55-2a0d-4c79-8ba3-d5677f01c155', 'CREATE', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, '{"method": "CASH", "orderId": "e7eccfdc-02d5-470f-869b-da665f7dcb2e", "amountMinor": "37250", "originalAction": "PAYMENT_RECORDED"}', '2026-09-04 00:03:15.375+05:30', '2026-09-04 00:03:15.358964+05:30', NULL, NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('987b9612-a371-4c34-b9a6-3a05ee239f57', '11111111-1111-1111-1111-111111111111', 'ORDER', '0f621958-d193-4d99-b6ef-037fcea9cd0a', 'CREATE', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, '{"items": [{"id": "ffe3d2a6-2bcf-4f51-96b0-958fc529e51e", "quantity": 1, "menuItemId": "9e27f8db-5ca3-4d7f-97d4-aa3d87642452"}], "originalAction": "ORDER_ITEMS_ADDED"}', '2026-09-04 00:05:57.373+05:30', '2026-09-04 00:05:57.362581+05:30', NULL, NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('595978c5-ff38-400a-a264-7f6f39d64740', '11111111-1111-1111-1111-111111111111', 'PAYMENT', '1a3d604c-edec-4c9a-87ab-648a8bbf133c', 'CREATE', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, '{"method": "CASH", "orderId": "0f621958-d193-4d99-b6ef-037fcea9cd0a", "amountMinor": "16800", "originalAction": "PAYMENT_RECORDED"}', '2026-09-04 00:06:34.697+05:30', '2026-09-04 00:06:34.668944+05:30', NULL, NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('31e61c13-c0e6-499a-9eaf-ecb742d7aa86', '11111111-1111-1111-1111-111111111111', 'PAYMENT', '9c5e5749-9c4f-4e49-9355-80afe225f04e', 'CREATE', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, '{"method": "CASH", "orderId": "ece12171-62db-4f53-ba97-d5e93e06f733", "amountMinor": "15750", "originalAction": "PAYMENT_RECORDED"}', '2026-09-04 01:14:43.215+05:30', '2026-09-04 01:14:43.203511+05:30', NULL, NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('34483ac2-598c-4df3-8e51-e583eb13abdf', '11111111-1111-1111-1111-111111111111', 'PAYMENT', '923c400d-2aa6-40e9-bff1-a6777d7c075e', 'CREATE', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, '{"method": "CASH", "orderId": "b5177d27-2e27-4abd-8296-83a748730b2c", "amountMinor": "16800", "originalAction": "PAYMENT_RECORDED"}', '2026-09-04 01:19:56.908+05:30', '2026-09-04 01:19:56.897288+05:30', NULL, NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('2de464cf-3284-4019-8611-7564b42e4b2f', '11111111-1111-1111-1111-111111111111', 'ORDER', 'a00d57c3-c01d-49d0-9166-45e9f7e22497', 'CREATE', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, '{"items": [{"id": "a09767f3-e815-483d-aff9-8d334baff511", "quantity": 1, "menuItemId": "094b3d75-f087-476a-863b-a70da76e2365"}], "originalAction": "ORDER_ITEMS_ADDED"}', '2026-09-05 13:19:55.644+05:30', '2026-09-05 13:19:55.615319+05:30', NULL, NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('cb2c785c-ae36-4005-bb22-e7e9985f2b01', '11111111-1111-1111-1111-111111111111', 'PAYMENT', 'a23c5ed2-25df-4ffd-a6a0-e8d8d6729f43', 'CREATE', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, '{"method": "CASH", "orderId": "a00d57c3-c01d-49d0-9166-45e9f7e22497", "amountMinor": "47250", "originalAction": "PAYMENT_RECORDED"}', '2026-09-05 13:22:05.601+05:30', '2026-09-05 13:22:05.5958+05:30', NULL, NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('09aa00e6-23a1-452e-aaff-1f9430e6324a', '11111111-1111-1111-1111-111111111111', 'PAYMENT', '2feeaab6-7543-447d-a565-a8104b9eb3eb', 'CREATE', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, '{"method": "CASH", "orderId": "0f3580d0-cceb-4289-99f8-5ffdf1669b18", "amountMinor": "5250", "originalAction": "PAYMENT_RECORDED"}', '2026-09-05 15:10:12.795+05:30', '2026-09-05 15:10:12.785772+05:30', NULL, NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('ff7d3f40-3eb1-495d-8fea-70e8e81d64b4', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'PAYMENT', 'ffcfae6a-f1e2-418d-94fa-cb1c38179fd3', 'CREATE', '918df673-2606-403a-9fad-1c54870d1fce', NULL, '{"method": "CASH", "orderId": "5b433b06-af43-4f62-8a6b-e2ca1e0bfa88", "amountMinor": "35700", "originalAction": "PAYMENT_RECORDED"}', '2026-09-05 16:45:42.142+05:30', '2026-09-05 16:45:42.136429+05:30', NULL, NULL, '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('29f315b3-8e09-43a4-ae86-db347ad27f71', '11111111-1111-1111-1111-111111111111', 'PAYMENT', '2e8207de-394f-40ad-bd95-84b3b2998a9b', 'CREATE', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, '{"method": "CASH", "orderId": "7a369854-faf1-4af3-8378-8b939249c434", "amountMinor": "6825", "originalAction": "PAYMENT_RECORDED"}', '2026-09-05 16:51:32.869+05:30', '2026-09-05 16:51:32.86469+05:30', NULL, NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('1eaea50f-33f7-48d5-92cc-34ba254243a7', '11111111-1111-1111-1111-111111111111', 'DINING_TABLE', 'bb01f08e-7a9d-43b3-acce-be35218b3f27', 'CREATE', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, '{"reason": null, "memberIds": ["1bb0a59d-079d-4406-8bd9-0fd2f4a7668e", "bb01f08e-7a9d-43b3-acce-be35218b3f27"], "mergeGroupId": "afe6e795-9bf1-4d7b-93ba-24db0c8ad017", "targetOrderId": null, "targetTableId": "bb01f08e-7a9d-43b3-acce-be35218b3f27", "originalAction": "TABLE_MERGE", "sourceTableIds": ["1bb0a59d-079d-4406-8bd9-0fd2f4a7668e"], "mergedOrdersCount": 0}', '2026-09-05 16:53:25.393+05:30', '2026-09-05 16:53:25.395516+05:30', NULL, NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('eb7e5a4c-81b6-430d-8c99-161e07d0a386', '11111111-1111-1111-1111-111111111111', 'DINING_TABLE', '1bb0a59d-079d-4406-8bd9-0fd2f4a7668e', 'CREATE', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, '{"reason": null, "memberIds": ["bb01f08e-7a9d-43b3-acce-be35218b3f27", "1bb0a59d-079d-4406-8bd9-0fd2f4a7668e"], "mergeGroupId": "afe6e795-9bf1-4d7b-93ba-24db0c8ad017", "targetOrderId": null, "targetTableId": "1bb0a59d-079d-4406-8bd9-0fd2f4a7668e", "originalAction": "TABLE_MERGE", "sourceTableIds": ["bb01f08e-7a9d-43b3-acce-be35218b3f27"], "mergedOrdersCount": 0}', '2026-09-05 16:54:07.579+05:30', '2026-09-05 16:54:07.579697+05:30', NULL, NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('2a170479-89ed-4756-acf6-7824c05add43', '11111111-1111-1111-1111-111111111111', 'DINING_TABLE', '1bb0a59d-079d-4406-8bd9-0fd2f4a7668e', 'CREATE', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, '{"reason": null, "memberIds": ["bb01f08e-7a9d-43b3-acce-be35218b3f27", "1bb0a59d-079d-4406-8bd9-0fd2f4a7668e"], "mergeGroupId": "afe6e795-9bf1-4d7b-93ba-24db0c8ad017", "targetOrderId": null, "targetTableId": "1bb0a59d-079d-4406-8bd9-0fd2f4a7668e", "originalAction": "TABLE_MERGE", "sourceTableIds": ["bb01f08e-7a9d-43b3-acce-be35218b3f27"], "mergedOrdersCount": 0}', '2026-09-05 16:54:15.11+05:30', '2026-09-05 16:54:15.110427+05:30', NULL, NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('a08992da-4a64-4d2a-86e8-9edb940391d5', '11111111-1111-1111-1111-111111111111', 'DINING_TABLE', '1bb0a59d-079d-4406-8bd9-0fd2f4a7668e', 'CREATE', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, '{"reason": null, "memberIds": ["bb01f08e-7a9d-43b3-acce-be35218b3f27", "1bb0a59d-079d-4406-8bd9-0fd2f4a7668e"], "mergeGroupId": "afe6e795-9bf1-4d7b-93ba-24db0c8ad017", "targetOrderId": null, "targetTableId": "1bb0a59d-079d-4406-8bd9-0fd2f4a7668e", "originalAction": "TABLE_MERGE", "sourceTableIds": ["bb01f08e-7a9d-43b3-acce-be35218b3f27"], "mergedOrdersCount": 0}', '2026-09-05 17:03:37.183+05:30', '2026-09-05 17:03:37.184023+05:30', NULL, NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('2b35d54a-fc84-45a8-b5b8-a52566b7dcb2', '11111111-1111-1111-1111-111111111111', 'PAYMENT', 'cd2961e5-434c-4fd7-a178-659c524137f0', 'CREATE', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, '{"method": "CASH", "orderId": "82e2a068-a74a-4e18-89fe-7a423f5b243f", "amountMinor": "7350", "originalAction": "PAYMENT_RECORDED"}', '2026-09-05 17:14:44.757+05:30', '2026-09-05 17:14:44.749884+05:30', NULL, NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('5ab89b77-ff6a-4f31-8ffd-55860f7c0a82', '11111111-1111-1111-1111-111111111111', 'PAYMENT', '1761086d-1e14-4acd-8f1c-a5cbcf3e80d8', 'CREATE', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, '{"method": "CASH", "orderId": "71ef893c-0ccc-439d-bc3e-0a248037303b", "amountMinor": "10904", "originalAction": "PAYMENT_RECORDED"}', '2026-09-08 11:01:05.79+05:30', '2026-09-08 11:01:05.772197+05:30', NULL, NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('78a7699c-ee10-426c-9e00-22f3068e4d65', '11111111-1111-1111-1111-111111111111', 'ORDER', '1085cebe-ebf0-4804-83f3-aae6d0d4a7c9', 'CREATE', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, '{"items": [{"id": "9c5395eb-db1c-48f8-803a-f011a251c77a", "quantity": 2, "menuItemId": "094b3d75-f087-476a-863b-a70da76e2365"}], "originalAction": "ORDER_ITEMS_ADDED"}', '2026-09-08 11:09:01.376+05:30', '2026-09-08 11:09:01.355061+05:30', NULL, NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('e302eceb-da2c-45dd-a861-77c0deb55a04', '11111111-1111-1111-1111-111111111111', 'PAYMENT', 'e4630b40-86f0-4b79-8e21-9053a0db4ab3', 'CREATE', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, '{"method": "CASH", "orderId": "1085cebe-ebf0-4804-83f3-aae6d0d4a7c9", "amountMinor": "77075", "originalAction": "PAYMENT_RECORDED"}', '2026-09-08 11:10:47.824+05:30', '2026-09-08 11:10:47.797329+05:30', NULL, NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('25344907-6edd-424d-8eec-47a837321373', '11111111-1111-1111-1111-111111111111', 'ORDER', 'e7d4d6cf-4838-43bd-8334-688d11302496', 'CREATE', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, '{"items": [{"id": "18ec13cb-0674-4f07-b06a-166a80d9c6b7", "quantity": 3, "menuItemId": "094b3d75-f087-476a-863b-a70da76e2365"}], "originalAction": "ORDER_ITEMS_ADDED"}', '2026-09-08 11:12:06.974+05:30', '2026-09-08 11:12:06.961926+05:30', NULL, NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('aa7faca0-1215-47f4-80d7-57e13966990c', '11111111-1111-1111-1111-111111111111', 'PAYMENT', '83cadcc5-c2f6-4381-a36a-052d8b48b380', 'CREATE', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, '{"method": "CASH", "orderId": "e7d4d6cf-4838-43bd-8334-688d11302496", "amountMinor": "116025", "originalAction": "PAYMENT_RECORDED"}', '2026-09-08 11:17:50.382+05:30', '2026-09-08 11:17:50.353559+05:30', NULL, NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('a29a85e4-0c7f-4feb-aaf0-243b6d1d86f2', '11111111-1111-1111-1111-111111111111', 'ORDER', 'f5d3449d-ce21-48cb-ab01-b41c41a7301c', 'CREATE', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, '{"items": [{"id": "b80c6285-d018-47a1-9dfa-2e686b8effc3", "quantity": 1, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}], "originalAction": "ORDER_ITEMS_ADDED"}', '2026-09-08 14:14:29.218+05:30', '2026-09-08 14:14:29.187607+05:30', NULL, NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('469963b2-ccbc-4b7e-90bc-2256d3d00a36', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 30, "stockQty": 73, "isStocked": true}', '2026-09-09 12:48:03.962+05:30', '2026-09-09 12:48:03.962761+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('d9a0be1f-2984-4731-941e-975253640129', '11111111-1111-1111-1111-111111111111', 'ORDER', 'f5d3449d-ce21-48cb-ab01-b41c41a7301c', 'CREATE', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, '{"items": [{"id": "7ef66626-f4e7-4ebe-a4fe-4e09367d8ab0", "quantity": 1, "menuItemId": "5d13a97e-027a-445b-94eb-2f00546b1614"}, {"id": "f89483cf-0d93-4bc0-816a-285a7a13d065", "quantity": 1, "menuItemId": "e286dcdc-8100-430d-967e-6edba83f1609"}], "originalAction": "ORDER_ITEMS_ADDED"}', '2026-09-08 16:19:27.29+05:30', '2026-09-08 16:19:27.270906+05:30', NULL, NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('6ef2fd7f-2571-4661-969e-9a870407d29d', '11111111-1111-1111-1111-111111111111', 'PAYMENT', 'f055326e-c3d8-4686-83ec-f739c167e7b9', 'CREATE', '918df673-2606-403a-9fad-1c54870d1fce', NULL, '{"method": "CASH", "orderId": "b101f725-9679-4cf3-9f0f-16adb200ecff", "amountMinor": "3150", "originalAction": "PAYMENT_RECORDED"}', '2026-09-09 12:45:00.362+05:30', '2026-09-09 12:45:00.340408+05:30', NULL, NULL, '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('1b847e4d-4853-41c1-816c-82cf28f2027a', '11111111-1111-1111-1111-111111111111', 'PAYMENT', '77c1b0ca-ce68-49e9-a5ad-b8918a3df29f', 'CREATE', '918df673-2606-403a-9fad-1c54870d1fce', NULL, '{"method": "CASH", "orderId": "76692730-cd05-45cd-b8ad-9cc20ac9fc5a", "amountMinor": "7350", "originalAction": "PAYMENT_RECORDED"}', '2026-09-09 12:47:11.473+05:30', '2026-09-09 12:47:11.454508+05:30', NULL, NULL, '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('94ed9b32-cc18-446d-bbc9-8e467ea7c473', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', 'e6d644af-1584-467a-863f-bac26eb84d38', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 100, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}', '{"stockQty": 99, "isStocked": true, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d", "quantityDeducted": 1}', '2026-09-09 12:47:30.834+05:30', '2026-09-09 12:47:30.833052+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('861536ad-a51c-44ab-b348-69ed0b12eb0c', '11111111-1111-1111-1111-111111111111', 'ORDER', '0602cb47-3398-4ba0-b5da-87e23909efa3', 'CREATE', '918df673-2606-403a-9fad-1c54870d1fce', NULL, '{"items": [{"id": "4c625b81-fece-407d-9b63-dced164b38b1", "quantity": 1, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}], "originalAction": "ORDER_ITEMS_ADDED"}', '2026-09-09 12:47:50.715+05:30', '2026-09-09 12:47:50.69576+05:30', NULL, NULL, '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('bdbb2d6d-b36f-4b47-bb01-2495600267b6', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', '4c625b81-fece-407d-9b63-dced164b38b1', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 99, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}', '{"stockQty": 98, "isStocked": true, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d", "quantityDeducted": 1}', '2026-09-09 12:47:50.772+05:30', '2026-09-09 12:47:50.774554+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('4d64adf5-0f95-4a71-a8ca-602fdc12604c', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 6, "stockQty": 97, "isStocked": true}', '2026-09-09 12:47:59.701+05:30', '2026-09-09 12:47:59.701343+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('0be96a6d-ad99-4dc5-a7a3-9c7905cb46b5', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 7, "stockQty": 96, "isStocked": true}', '2026-09-09 12:47:59.885+05:30', '2026-09-09 12:47:59.885038+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('9b849139-8f32-4b0a-95f5-bfa3e4c94387', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 8, "stockQty": 95, "isStocked": true}', '2026-09-09 12:48:00.045+05:30', '2026-09-09 12:48:00.045529+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('d553b8a3-3bdb-4fd4-a1d1-49e869c00607', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 9, "stockQty": 94, "isStocked": true}', '2026-09-09 12:48:00.199+05:30', '2026-09-09 12:48:00.199601+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('44f9dae0-b4f5-40c4-b9de-7a00900b487e', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 10, "stockQty": 93, "isStocked": true}', '2026-09-09 12:48:00.362+05:30', '2026-09-09 12:48:00.362999+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('63a1413a-e7ce-41b4-bdc2-a7b93b2d9c33', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 11, "stockQty": 92, "isStocked": true}', '2026-09-09 12:48:00.524+05:30', '2026-09-09 12:48:00.52479+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('38af33c6-3ab1-4577-98ca-3e610c876123', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 12, "stockQty": 91, "isStocked": true}', '2026-09-09 12:48:00.717+05:30', '2026-09-09 12:48:00.717757+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('64239b9d-b41a-42bc-83db-b75dc8985e43', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 13, "stockQty": 90, "isStocked": true}', '2026-09-09 12:48:00.845+05:30', '2026-09-09 12:48:00.845002+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('b97253f7-97cb-4ca6-ae19-30f3b4a70714', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 14, "stockQty": 89, "isStocked": true}', '2026-09-09 12:48:01.02+05:30', '2026-09-09 12:48:01.020489+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('60be30ee-1fdf-4ece-aa79-538ec710f4ce', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 15, "stockQty": 88, "isStocked": true}', '2026-09-09 12:48:01.182+05:30', '2026-09-09 12:48:01.182186+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('c79aa386-9c49-4909-8e14-b8d5612d0aa0', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 16, "stockQty": 87, "isStocked": true}', '2026-09-09 12:48:01.348+05:30', '2026-09-09 12:48:01.3481+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('d69ec9c1-4f26-4b97-beae-4e1f92bc01fd', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 17, "stockQty": 86, "isStocked": true}', '2026-09-09 12:48:01.502+05:30', '2026-09-09 12:48:01.502773+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('4a18e9b3-bb06-443e-8ddd-2a8b8b3dbf2b', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 18, "stockQty": 85, "isStocked": true}', '2026-09-09 12:48:01.675+05:30', '2026-09-09 12:48:01.675266+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('7605a57d-d6f6-4d32-b650-f4dc49473b7a', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 19, "stockQty": 84, "isStocked": true}', '2026-09-09 12:48:01.863+05:30', '2026-09-09 12:48:01.863385+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('3fb8b5e3-fcf2-428b-9ff0-cc50e83fb78e', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 20, "stockQty": 83, "isStocked": true}', '2026-09-09 12:48:02.099+05:30', '2026-09-09 12:48:02.09958+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('5b6c26ae-f666-4aad-838d-9b2010946ee0', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 21, "stockQty": 82, "isStocked": true}', '2026-09-09 12:48:02.292+05:30', '2026-09-09 12:48:02.292155+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('0077f2c6-9206-4bd6-9d7b-dcd0bba11a0e', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 22, "stockQty": 81, "isStocked": true}', '2026-09-09 12:48:02.485+05:30', '2026-09-09 12:48:02.485181+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('efb8f302-11aa-4eb5-a6e2-620188126a26', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 23, "stockQty": 80, "isStocked": true}', '2026-09-09 12:48:02.685+05:30', '2026-09-09 12:48:02.685662+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('2d766037-a242-4229-92e7-73e0555b3c27', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 24, "stockQty": 79, "isStocked": true}', '2026-09-09 12:48:02.853+05:30', '2026-09-09 12:48:02.853758+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('54270e4a-bb5e-4388-9dbe-9c63c0b9b82a', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 25, "stockQty": 78, "isStocked": true}', '2026-09-09 12:48:03.062+05:30', '2026-09-09 12:48:03.062759+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('e00fc53a-2835-4190-82df-924355d2ce8b', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 26, "stockQty": 77, "isStocked": true}', '2026-09-09 12:48:03.244+05:30', '2026-09-09 12:48:03.244414+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('9287a818-7e65-426b-aa2c-3d6d6c2d36fc', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 27, "stockQty": 76, "isStocked": true}', '2026-09-09 12:48:03.418+05:30', '2026-09-09 12:48:03.41809+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('76888db1-3318-4714-b3c2-ce37b540657f', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 28, "stockQty": 75, "isStocked": true}', '2026-09-09 12:48:03.603+05:30', '2026-09-09 12:48:03.602969+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('a27be355-3465-4667-b6b8-1ef9fd9594fd', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 29, "stockQty": 74, "isStocked": true}', '2026-09-09 12:48:03.793+05:30', '2026-09-09 12:48:03.793387+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('657fad85-d24f-41d4-817c-58a1142ab106', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 31, "stockQty": 72, "isStocked": true}', '2026-09-09 12:48:04.137+05:30', '2026-09-09 12:48:04.13775+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('2308b819-e2bc-4040-9fe5-6f24076840cb', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 34, "stockQty": 69, "isStocked": true}', '2026-09-09 12:48:04.642+05:30', '2026-09-09 12:48:04.642061+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('7d63d5d9-d3d3-45c2-911a-ab037674c51a', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 32, "stockQty": 71, "isStocked": true}', '2026-09-09 12:48:04.315+05:30', '2026-09-09 12:48:04.314924+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('ebe73e47-ef7d-4090-9bc2-087c1e170dc9', '11111111-1111-1111-1111-111111111111', 'ORDER', '0602cb47-3398-4ba0-b5da-87e23909efa3', 'CREATE', '918df673-2606-403a-9fad-1c54870d1fce', NULL, '{"items": [{"id": "31447489-e6af-4bc5-a132-783f2da200c0", "quantity": 90, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}], "originalAction": "ORDER_ITEMS_ADDED"}', '2026-09-09 12:48:24.598+05:30', '2026-09-09 12:48:24.578971+05:30', NULL, NULL, '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('283aeaa7-9273-4330-88fd-bc21811ec465', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', '31447489-e6af-4bc5-a132-783f2da200c0', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 100, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}', '{"stockQty": 10, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 90}', '2026-09-09 12:48:24.644+05:30', '2026-09-09 12:48:24.644156+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('ba5afdfe-0c02-4877-bd99-b848aa980fdb', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 33, "stockQty": 70, "isStocked": true}', '2026-09-09 12:48:04.466+05:30', '2026-09-09 12:48:04.466228+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('a94b8952-d6bc-4d7b-9ee4-09383e5f01f5', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', 'c6fbd83e-75ed-472a-b1bf-2e7889b797f0', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 59, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}', '{"stockQty": 58, "isStocked": true, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d", "quantityDeducted": 1}', '2026-09-09 12:51:14.284+05:30', '2026-09-09 12:51:14.285316+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('4a25db64-6d7f-4100-a1ef-454c0ff050a4', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 35, "stockQty": 68, "isStocked": true}', '2026-09-09 12:48:04.828+05:30', '2026-09-09 12:48:04.828375+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('77d01f42-9067-470c-bad1-82a7919205c2', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 39, "stockQty": 64, "isStocked": true}', '2026-09-09 12:49:16.4+05:30', '2026-09-09 12:49:16.400552+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('7eed1b30-138d-4f34-9e67-456077d9d46d', '11111111-1111-1111-1111-111111111111', 'ORDER', '0602cb47-3398-4ba0-b5da-87e23909efa3', 'CREATE', '918df673-2606-403a-9fad-1c54870d1fce', NULL, '{"items": [{"id": "b755bfc3-dea9-4d8f-b6d1-a7decce5f8be", "quantity": 5, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}], "originalAction": "ORDER_ITEMS_ADDED"}', '2026-09-09 12:49:23.874+05:30', '2026-09-09 12:49:23.847265+05:30', NULL, NULL, '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('b9e8322d-a71c-4e44-a609-97ab5cee3a78', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', 'b755bfc3-dea9-4d8f-b6d1-a7decce5f8be', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 64, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}', '{"stockQty": 59, "isStocked": true, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d", "quantityDeducted": 5}', '2026-09-09 12:49:23.918+05:30', '2026-09-09 12:49:23.917597+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('f75ea35b-3402-451f-8460-86472bb3b282', '11111111-1111-1111-1111-111111111111', 'PAYMENT', 'e605aa7d-04d2-4273-9088-89bcf90688b1', 'CREATE', '918df673-2606-403a-9fad-1c54870d1fce', NULL, '{"method": "CASH", "orderId": "0602cb47-3398-4ba0-b5da-87e23909efa3", "amountMinor": "534975", "originalAction": "PAYMENT_RECORDED"}', '2026-09-09 12:51:03.204+05:30', '2026-09-09 12:51:03.177818+05:30', NULL, NULL, '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('515309aa-6db9-4a81-a0cc-f67bed72f7f1', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 36, "stockQty": 67, "isStocked": true}', '2026-09-09 12:48:05.013+05:30', '2026-09-09 12:48:05.013612+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('56d7f9a7-6df6-406a-a1c4-a4128a3688bf', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 37, "stockQty": 66, "isStocked": true}', '2026-09-09 12:48:05.186+05:30', '2026-09-09 12:48:05.186266+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('5140808b-69f8-4f9f-96f1-e921f86d8461', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 38, "stockQty": 65, "isStocked": true}', '2026-09-09 12:48:05.362+05:30', '2026-09-09 12:48:05.362638+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('19b5435c-3087-4dfa-8777-cade40f0334d', '11111111-1111-1111-1111-111111111111', 'ORDER', '2d4b655e-a5bf-4900-ba0c-11e1b3c2685c', 'CREATE', '918df673-2606-403a-9fad-1c54870d1fce', NULL, '{"items": [{"id": "04e04ddf-bbb4-4e74-ae9e-864aca2029d4", "quantity": 16, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}], "originalAction": "ORDER_ITEMS_ADDED"}', '2026-09-09 12:51:28.094+05:30', '2026-09-09 12:51:28.083736+05:30', NULL, NULL, '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('f8e2e3d6-cca6-4970-90d8-439409a011a6', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', '04e04ddf-bbb4-4e74-ae9e-864aca2029d4', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 58, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}', '{"stockQty": 42, "isStocked": true, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d", "quantityDeducted": 16}', '2026-09-09 12:51:28.133+05:30', '2026-09-09 12:51:28.132997+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('79590f61-0f2b-40f6-bcfc-5830f050cee6', '11111111-1111-1111-1111-111111111111', 'ORDER', '2d4b655e-a5bf-4900-ba0c-11e1b3c2685c', 'CREATE', '918df673-2606-403a-9fad-1c54870d1fce', NULL, '{"items": [{"id": "4923d9da-bcb2-46da-833a-8b4a037f0436", "quantity": 32, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}], "originalAction": "ORDER_ITEMS_ADDED"}', '2026-09-09 12:51:46.681+05:30', '2026-09-09 12:51:46.669142+05:30', NULL, NULL, '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('9a808933-a365-4af3-b7df-4520384b11b5', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', '4923d9da-bcb2-46da-833a-8b4a037f0436', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 42, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}', '{"stockQty": 10, "isStocked": true, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d", "quantityDeducted": 32}', '2026-09-09 12:51:46.728+05:30', '2026-09-09 12:51:46.727639+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('711a1901-8eb9-4423-b8bb-3a198e5f3ee0', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 44, "stockQty": 15, "isStocked": true}', '2026-09-09 12:52:31.552+05:30', '2026-09-09 12:52:31.553436+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('38104b28-d3ab-4995-aa4a-f5190671e121', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', 'e2ac9075-4d00-464e-88a2-afe715362121', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 15, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}', '{"stockQty": 12, "isStocked": true, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d", "quantityDeducted": 3}', '2026-09-09 12:52:31.722+05:30', '2026-09-09 12:52:31.723381+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('0980370b-7faf-4cba-8e93-8ee2447351c5', '11111111-1111-1111-1111-111111111111', 'ORDER', '2d4b655e-a5bf-4900-ba0c-11e1b3c2685c', 'CREATE', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, '{"items": [{"id": "f79c39a2-f114-496c-bf0e-09ac73ddf914", "quantity": 4, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}], "originalAction": "ORDER_ITEMS_ADDED"}', '2026-09-09 12:55:56.37+05:30', '2026-09-09 12:55:56.357916+05:30', NULL, NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('c419ca77-34b4-47f3-9da8-2d1d2aab0f78', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', 'f79c39a2-f114-496c-bf0e-09ac73ddf914', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 12, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}', '{"stockQty": 8, "isStocked": true, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d", "quantityDeducted": 4}', '2026-09-09 12:55:57.328+05:30', '2026-09-09 12:55:57.328877+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('418059ca-b49b-4fc5-aab5-c85e0f335b6c', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 47, "stockQty": 15, "isStocked": true}', '2026-09-09 13:01:25.088+05:30', '2026-09-09 13:01:25.089287+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('0032b892-ed10-4cfc-a540-7bc0357be8f1', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', '03ec0df1-5176-44d6-befb-8477fd240cb0', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 15, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}', '{"stockQty": 12, "isStocked": true, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d", "quantityDeducted": 3}', '2026-09-09 13:01:25.25+05:30', '2026-09-09 13:01:25.24992+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('c0dfaa93-83b3-4415-9612-fb16e93a9ec9', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 49, "stockQty": 15, "isStocked": true}', '2026-09-09 13:02:02.065+05:30', '2026-09-09 13:02:02.066187+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('ab71bd93-9cfd-44d7-831b-56710be561f5', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', '970e6000-56da-419a-9d6c-33afca6265fd', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 15, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}', '{"stockQty": 12, "isStocked": true, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d", "quantityDeducted": 3}', '2026-09-09 13:02:02.293+05:30', '2026-09-09 13:02:02.295177+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('1172ded6-a0a2-4812-bc83-8793fbd9c7d3', '11111111-1111-1111-1111-111111111111', 'ORDER', '4e192b03-6942-454a-a9dd-9084d99362b1', 'OVERRIDE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"subtotal": "25500", "orderItemId": "970e6000-56da-419a-9d6c-33afca6265fd"}', '{"reasonCode": "TEST_VOID", "originalAction": "ORDER_ITEM_VOIDED"}', '2026-09-09 13:02:03.033+05:30', '2026-09-09 13:02:03.01853+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', 'TEST_VOID', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('8462c096-f21f-4085-96f5-f9f10a583cc5', '11111111-1111-1111-1111-111111111111', 'PORTION_RESTORED', '970e6000-56da-419a-9d6c-33afca6265fd', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"stockQty": 12, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}', '{"stockQty": 15, "isStocked": true, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d", "quantityRestored": 3}', '2026-09-09 13:02:03.049+05:30', '2026-09-09 13:02:03.050383+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', 'ITEM_VOIDED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('153c2b07-b674-4049-954a-7eb9baef6227', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', 'aa746b8b-9705-4520-a5a8-54ab4190f58c', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 15, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}', '{"stockQty": 0, "isStocked": false, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d", "quantityDeducted": 15}', '2026-09-09 13:02:03.793+05:30', '2026-09-09 13:02:03.795078+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('61621015-2f24-4732-98c3-a9cf3fa77e71', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', '4a8d3fad-d0e2-4c19-8840-9ef706f90b7b', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 2, "stockQty": 15, "isStocked": true}', '2026-09-09 13:03:37.695+05:30', '2026-09-09 13:03:37.696615+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('fb60e54b-41d2-42cf-817b-95aaa7b711b9', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', '2bf7206e-c6f3-44aa-981c-a457abf6e62a', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 15, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b"}', '{"stockQty": 12, "isStocked": true, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b", "quantityDeducted": 3}', '2026-09-09 13:03:37.924+05:30', '2026-09-09 13:03:37.92335+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('486c2222-6665-490c-9b73-4170044eafc0', '11111111-1111-1111-1111-111111111111', 'ORDER', '39f6e5e8-3eb1-4100-a8cc-4dfcb49ba060', 'OVERRIDE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"subtotal": "21000", "orderItemId": "2bf7206e-c6f3-44aa-981c-a457abf6e62a"}', '{"reasonCode": "TEST_VOID", "originalAction": "ORDER_ITEM_VOIDED"}', '2026-09-09 13:03:38.682+05:30', '2026-09-09 13:03:38.668133+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', 'TEST_VOID', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('980277a0-5e0d-42ad-8b48-4df1ac6f68ae', '11111111-1111-1111-1111-111111111111', 'PORTION_RESTORED', '2bf7206e-c6f3-44aa-981c-a457abf6e62a', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"stockQty": 12, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b"}', '{"stockQty": 15, "isStocked": true, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b", "quantityRestored": 3}', '2026-09-09 13:03:38.708+05:30', '2026-09-09 13:03:38.707582+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', 'ITEM_VOIDED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('7d598139-8497-4d8c-874f-5b846f7c66f4', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', 'd07b13ab-7416-45f5-aa50-d4c92edb3536', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 15, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b"}', '{"stockQty": 0, "isStocked": false, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b", "quantityDeducted": 15}', '2026-09-09 13:03:39.421+05:30', '2026-09-09 13:03:39.420207+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('1d9f9cbe-d659-47d9-8779-714cf3bebe8d', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', '4a8d3fad-d0e2-4c19-8840-9ef706f90b7b', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 6, "stockQty": 50, "isStocked": true}', '2026-09-09 13:03:40.078+05:30', '2026-09-09 13:03:40.078823+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('8331eeb2-2d9f-4a67-9ad3-73e120293c3f', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 2, "stockQty": 4, "isStocked": true}', '2026-09-09 13:04:48.048+05:30', '2026-09-09 13:04:48.048397+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('663f338f-b08f-4729-adee-6c5c97ccf179', '11111111-1111-1111-1111-111111111111', 'PAYMENT', '5274906f-8668-478b-82e7-03b15eeb777e', 'CREATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, '{"method": "CASH", "orderId": "2d4b655e-a5bf-4900-ba0c-11e1b3c2685c", "amountMinor": "473025", "originalAction": "PAYMENT_RECORDED"}', '2026-09-09 14:06:01.09+05:30', '2026-09-09 14:06:01.080901+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('dd52c04f-ddb5-4d8e-b93c-bdbca0043bfd', '11111111-1111-1111-1111-111111111111', 'PAYMENT', '2d505e0f-6dd7-411b-8bce-9a1ca5c7ef05', 'CREATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, '{"method": "CASH", "orderId": "eb13fd97-c972-4447-8a42-898eb545191e", "amountMinor": "21000", "originalAction": "PAYMENT_RECORDED"}', '2026-09-09 14:07:07.593+05:30', '2026-09-09 14:07:07.58697+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('8fdf2c28-c7d3-4dff-ae4c-05b9b645194a', '11111111-1111-1111-1111-111111111111', 'PAYMENT', '35ad0d01-e3e1-4272-bcab-b8009bf61358', 'CREATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, '{"method": "CASH", "orderId": "f5d3449d-ce21-48cb-ab01-b41c41a7301c", "amountMinor": "45675", "originalAction": "PAYMENT_RECORDED"}', '2026-09-09 14:07:29.933+05:30', '2026-09-09 14:07:29.927643+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('6121ef32-22e7-4060-ad1e-3a97f70f7e23', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', '1aa6fbfe-8643-49a5-8246-69a71196a167', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 0, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d"}', '{"stockQty": 0, "isStocked": false, "menuItemId": "e7d95cfe-261f-4545-b37b-2a4d3e69ca8d", "quantityDeducted": 1}', '2026-09-09 14:27:26.258+05:30', '2026-09-09 14:27:26.26281+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('c35de77e-69c7-443d-9731-e64de6510da6', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 3, "stockQty": 30, "isStocked": true}', '2026-09-09 14:27:33.462+05:30', '2026-09-09 14:27:33.4629+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('0e1fc5a5-20d0-4b0d-8b81-062b438abf54', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', '94a171f1-9bff-45e7-b655-9b864a43ec78', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 30, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}', '{"stockQty": 25, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 5}', '2026-09-09 14:27:33.907+05:30', '2026-09-09 14:27:33.91144+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('df50c101-c42c-420c-b49d-0b2f3326b81b', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 5, "stockQty": 50, "isStocked": true}', '2026-09-09 14:27:34.584+05:30', '2026-09-09 14:27:34.584905+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('eac4f98f-7619-4be8-8854-ee7ee69a7d68', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 6, "stockQty": 30, "isStocked": true}', '2026-09-09 14:28:57.732+05:30', '2026-09-09 14:28:57.733014+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('6225a2d9-788b-4b78-9b2d-870cdcbecb4c', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', '342243f5-67c3-4f51-a5f7-c6441c0f8058', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 30, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}', '{"stockQty": 25, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 5}', '2026-09-09 14:28:58.391+05:30', '2026-09-09 14:28:58.407532+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('cdef0de8-307e-4034-85cb-e6e244fbb3dd', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 8, "stockQty": 50, "isStocked": true}', '2026-09-09 14:28:59.125+05:30', '2026-09-09 14:28:59.125358+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('4a0a0613-f330-4470-84f8-85b0730771e3', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 9, "stockQty": 30, "isStocked": true}', '2026-09-09 14:29:43.137+05:30', '2026-09-09 14:29:43.138433+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('7cf7a097-954e-4dbc-9f6c-4f43a1267f8b', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', '28791b77-9a0b-4827-8fc3-156591208ce4', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 30, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}', '{"stockQty": 25, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 5}', '2026-09-09 14:29:43.588+05:30', '2026-09-09 14:29:43.590063+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('19bfaaeb-4b21-4bb5-9402-932ae670a5e0', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 11, "stockQty": 50, "isStocked": true}', '2026-09-09 14:29:44.271+05:30', '2026-09-09 14:29:44.271513+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('274f447b-36c6-47cf-a6fb-b2fa54bdb721', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 12, "stockQty": 30, "isStocked": true}', '2026-09-09 14:30:40.978+05:30', '2026-09-09 14:30:40.979271+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('af3b32b5-75f6-4c29-b32b-48cf57e04d40', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 13, "stockQty": 30, "isStocked": true}', '2026-09-09 14:31:14.249+05:30', '2026-09-09 14:31:14.249745+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('41605f32-01dc-46bc-8c86-955793f8fd4b', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', '8fa479df-4828-4bbd-8781-0445ec6a7a4e', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 30, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}', '{"stockQty": 25, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 5}', '2026-09-09 14:31:14.705+05:30', '2026-09-09 14:31:14.707582+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('bf27af78-b827-4f67-a540-866105d725f5', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 15, "stockQty": 50, "isStocked": true}', '2026-09-09 14:31:15.416+05:30', '2026-09-09 14:31:15.416638+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('315fed00-c4ee-442e-b4aa-1fad8f7c7629', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 16, "stockQty": 30, "isStocked": true}', '2026-09-09 14:31:59.15+05:30', '2026-09-09 14:31:59.151107+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('41b2cbcb-bea3-4aee-a801-fc50928bef73', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', '1d24f99b-b19c-40f1-b8f4-3c9e1222fd40', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 30, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}', '{"stockQty": 25, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 5}', '2026-09-09 14:31:59.424+05:30', '2026-09-09 14:31:59.427384+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('9e58eeee-4d81-406a-8b24-94a1c2d29412', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 18, "stockQty": 50, "isStocked": true}', '2026-09-09 14:32:00.142+05:30', '2026-09-09 14:32:00.14255+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('3a96dd17-587b-4837-9a9f-3fa485f85b4e', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 19, "stockQty": 30, "isStocked": true}', '2026-09-09 14:32:48.123+05:30', '2026-09-09 14:32:48.124595+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('2611938d-2a1b-4df1-a6ed-8e580b04adcf', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', 'f1df626b-fc7b-4399-bf69-c2502c895927', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 30, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}', '{"stockQty": 25, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 5}', '2026-09-09 14:32:48.989+05:30', '2026-09-09 14:32:48.991014+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('d63c47ad-a30a-4e4f-9eb1-41c544dd8d41', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 21, "stockQty": 50, "isStocked": true}', '2026-09-09 14:32:49.707+05:30', '2026-09-09 14:32:49.708483+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('d08134a9-1896-4071-b4a9-c78049548466', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 22, "stockQty": 30, "isStocked": true}', '2026-09-09 14:34:00.772+05:30', '2026-09-09 14:34:00.773008+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('b006a574-7ec9-4469-b73e-3028a0e852b7', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', 'c00be2b8-881c-4bde-9a46-577c19ea7bc3', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 30, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}', '{"stockQty": 25, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 5}', '2026-09-09 14:34:01.617+05:30', '2026-09-09 14:34:01.620225+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('9abe9772-464d-439a-b7ba-f6fffd6107c7', '11111111-1111-1111-1111-111111111111', 'MENU_ITEM_86', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 'UPDATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '{"isStocked": true}', '{"version": 24, "stockQty": 50, "isStocked": true}', '2026-09-09 14:34:02.309+05:30', '2026-09-09 14:34:02.30985+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('a84e1735-3c60-4e48-82db-2cefdf335d35', '11111111-1111-1111-1111-111111111111', 'ORDER', '0a746ebb-ff2b-40d1-8d00-5e7652f56006', 'CREATE', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, '{"items": [{"id": "4803f052-a4cd-4a89-ab6f-74fac3d67772", "quantity": 1, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404"}], "originalAction": "ORDER_ITEMS_ADDED"}', '2026-09-09 14:35:45.612+05:30', '2026-09-09 14:35:45.599475+05:30', NULL, NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('33429c42-5906-4cbf-a63c-812ca7edfd37', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', '4803f052-a4cd-4a89-ab6f-74fac3d67772', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 100, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404"}', '{"stockQty": 99, "isStocked": true, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404", "quantityDeducted": 1}', '2026-09-09 14:35:45.661+05:30', '2026-09-09 14:35:45.662538+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('4eb31f4a-8c60-4184-bcd4-b2279c5a9c48', '11111111-1111-1111-1111-111111111111', 'PAYMENT', '2a7ca9cc-5903-4193-bdfc-bf5bbe9e2e64', 'CREATE', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, '{"method": "CASH", "orderId": "0a746ebb-ff2b-40d1-8d00-5e7652f56006", "amountMinor": "15225", "originalAction": "PAYMENT_RECORDED"}', '2026-09-09 15:08:54.374+05:30', '2026-09-09 15:08:54.363994+05:30', NULL, NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('639957c5-2d27-437c-8fde-466b4a81fd0d', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', '2f46c4fc-4fd6-4c9b-a3f8-acdbd42c0594', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 50, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}', '{"stockQty": 49, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 1}', '2026-09-09 15:09:20.438+05:30', '2026-09-09 15:09:20.440031+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('d1f2c402-7178-4dd4-8640-2a0b138c32a5', '11111111-1111-1111-1111-111111111111', 'ORDER', '3e1ba9c8-0311-4534-a8d3-fa97b3a4f933', 'CREATE', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, '{"items": [{"id": "582a60f4-534d-4024-88c8-1f56e570f4de", "quantity": 1, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}], "originalAction": "ORDER_ITEMS_ADDED"}', '2026-09-10 16:50:53.034+05:30', '2026-09-10 16:50:52.998474+05:30', NULL, NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('c3121cc7-cba3-4be6-8171-e639650e0a39', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', '582a60f4-534d-4024-88c8-1f56e570f4de', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 49, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}', '{"stockQty": 48, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 1}', '2026-09-10 16:50:53.186+05:30', '2026-09-10 16:50:53.188001+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('9e1e33fd-ecd0-4ccd-bb3e-1a01d0f04620', '11111111-1111-1111-1111-111111111111', 'PAYMENT', '1d81be04-8b53-4beb-b11c-b4cfbaef9c97', 'CREATE', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, '{"method": "CASH", "orderId": "3e1ba9c8-0311-4534-a8d3-fa97b3a4f933", "amountMinor": "15500", "originalAction": "PAYMENT_RECORDED"}', '2026-09-10 17:17:49.661+05:30', '2026-09-10 17:17:49.644383+05:30', NULL, NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('3fe51781-b92b-4600-a936-a367157aaed6', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', 'feaf21a6-4ea0-4b99-b0f0-bf197fa7b705', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 48, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}', '{"stockQty": 47, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 1}', '2026-09-11 12:09:46.431+05:30', '2026-09-11 12:09:46.435642+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('293a29f4-5fc4-4bb3-92b0-b386ca84257d', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', '5325d83c-f786-4964-bdd3-08acdefa96be', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 99, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404"}', '{"stockQty": 97, "isStocked": true, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404", "quantityDeducted": 2}', '2026-09-11 12:33:27.28+05:30', '2026-09-11 12:33:27.281643+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('41093082-da8d-4ff0-8d12-4cc873196ac1', '11111111-1111-1111-1111-111111111111', 'PAYMENT', 'dab22667-14a1-457f-99ee-7116b8b01c13', 'CREATE', '5c660c1f-f5f8-4007-87a6-b4b39913998b', NULL, '{"method": "CASH", "orderId": "c8387bcf-ab67-44bb-87fb-d67f6d7601ca", "amountMinor": "17600", "originalAction": "PAYMENT_RECORDED"}', '2026-09-11 12:34:34.857+05:30', '2026-09-11 12:34:34.831027+05:30', NULL, NULL, '5c660c1f-f5f8-4007-87a6-b4b39913998b', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('8681a881-591a-46c3-ad4b-e91b8ffe3fec', '11111111-1111-1111-1111-111111111111', 'PAYMENT', '287e9dac-3cdc-455d-89db-015a7b0a2b43', 'CREATE', '5c660c1f-f5f8-4007-87a6-b4b39913998b', NULL, '{"method": "CASH", "orderId": "27f9f630-3e8b-4ba9-b4d7-e631e45182f7", "amountMinor": "10250", "originalAction": "PAYMENT_RECORDED"}', '2026-09-11 12:35:19.639+05:30', '2026-09-11 12:35:19.617447+05:30', NULL, NULL, '5c660c1f-f5f8-4007-87a6-b4b39913998b', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('fa338919-9a76-4d0d-b4be-bfa0a3d8e986', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', '6d2bb836-3203-4c6c-a2ea-d81d3729a02d', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 47, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}', '{"stockQty": 46, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 1}', '2026-09-11 12:59:30.787+05:30', '2026-09-11 12:59:30.789207+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('30337dc8-087c-4338-91f3-98f58ffde6b1', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', 'afde9793-1550-477e-b114-bdd6d6c5491e', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 50, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b"}', '{"stockQty": 49, "isStocked": true, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b", "quantityDeducted": 1}', '2026-09-11 12:59:30.795+05:30', '2026-09-11 12:59:30.797008+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('04d88da4-07b9-4690-91b3-facb05bce715', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', '1bc49c16-8bb7-4650-a1c1-0f3afb56fdd8', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 97, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404"}', '{"stockQty": 96, "isStocked": true, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404", "quantityDeducted": 1}', '2026-09-11 12:59:52.873+05:30', '2026-09-11 12:59:52.875462+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('ce583c70-2e3a-47ce-ac54-0b09b1fa0918', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'PORTION_DEPLETED', '69d4ccbf-020e-45f7-bff8-efdee2f95fb2', 'UPDATE', '67315042-c687-4cbb-b45a-f4ea4efc199f', '{"stockQty": 100, "menuItemId": "1048c560-86bd-45c5-b872-eb5e802c6e46"}', '{"stockQty": 99, "isStocked": false, "menuItemId": "1048c560-86bd-45c5-b872-eb5e802c6e46", "quantityDeducted": 1}', '2026-09-11 14:12:08.791+05:30', '2026-09-11 14:12:08.792631+05:30', NULL, NULL, '67315042-c687-4cbb-b45a-f4ea4efc199f', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('04340702-6ca0-4e67-b369-e56a46c3cc72', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'PORTION_DEPLETED', 'a5ad1b27-1d4d-4a40-a7f8-1e08026ac3ba', 'UPDATE', '67315042-c687-4cbb-b45a-f4ea4efc199f', '{"stockQty": 99, "menuItemId": "1048c560-86bd-45c5-b872-eb5e802c6e46"}', '{"stockQty": 98, "isStocked": false, "menuItemId": "1048c560-86bd-45c5-b872-eb5e802c6e46", "quantityDeducted": 1}', '2026-09-11 14:16:07.385+05:30', '2026-09-11 14:16:07.395039+05:30', NULL, NULL, '67315042-c687-4cbb-b45a-f4ea4efc199f', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('088526d4-4cfe-4a61-9866-0d06a21b7af5', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'PORTION_DEPLETED', '32733e86-926a-421a-86cd-ee6fb9ffb7a0', 'UPDATE', '67315042-c687-4cbb-b45a-f4ea4efc199f', '{"stockQty": 98, "menuItemId": "1048c560-86bd-45c5-b872-eb5e802c6e46"}', '{"stockQty": 97, "isStocked": false, "menuItemId": "1048c560-86bd-45c5-b872-eb5e802c6e46", "quantityDeducted": 1}', '2026-09-11 14:19:07.517+05:30', '2026-09-11 14:19:07.519759+05:30', NULL, NULL, '67315042-c687-4cbb-b45a-f4ea4efc199f', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('02d6959a-d3a3-4343-ace0-7e20855bac40', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', '45c18b8d-29a0-4435-98e2-db478e9242f9', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 46, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e"}', '{"stockQty": 45, "isStocked": true, "menuItemId": "49768e80-5cf1-47a9-be73-5f24de6fb26e", "quantityDeducted": 1}', '2026-09-11 14:24:19.934+05:30', '2026-09-11 14:24:19.936452+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('95189dc6-8640-449a-8ab1-e41aef9154bf', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', '9fa4ac4f-fd3d-4490-9ad1-87bed53a26d7', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 96, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404"}', '{"stockQty": 95, "isStocked": true, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404", "quantityDeducted": 1}', '2026-09-11 14:25:28.567+05:30', '2026-09-11 14:25:28.571974+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('7117ba5e-2de9-4fb6-b9ae-1a8e2d0bb824', '11111111-1111-1111-1111-111111111111', 'ORDER', '4a4e9d6c-a797-4b03-9835-a44526c890e2', 'CREATE', '918df673-2606-403a-9fad-1c54870d1fce', NULL, '{"items": [{"id": "4b8a17f6-cc5b-43d8-9bb1-23572af374e7", "quantity": 1, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404"}], "originalAction": "ORDER_ITEMS_ADDED"}', '2026-09-11 16:39:37.832+05:30', '2026-09-11 16:39:37.814336+05:30', NULL, NULL, '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('1b77e614-9ab6-4d50-9cfc-f473e4ca11ae', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', '4b8a17f6-cc5b-43d8-9bb1-23572af374e7', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 95, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404"}', '{"stockQty": 94, "isStocked": true, "menuItemId": "5101522a-081e-4866-9f74-261854fe4404", "quantityDeducted": 1}', '2026-09-11 16:39:37.883+05:30', '2026-09-11 16:39:37.885151+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('cb6982bc-6f3e-4991-a228-b916201d188f', '11111111-1111-1111-1111-111111111111', 'PAYMENT', '33787728-0141-444e-80ba-cb3d953fd707', 'CREATE', '72bad3bb-6097-47d2-bfc2-35b1244a7b9f', NULL, '{"method": "CASH", "orderId": "4a4e9d6c-a797-4b03-9835-a44526c890e2", "amountMinor": "17600", "originalAction": "PAYMENT_RECORDED"}', '2026-09-12 15:32:01.582+05:30', '2026-09-12 15:32:01.554774+05:30', NULL, NULL, '72bad3bb-6097-47d2-bfc2-35b1244a7b9f', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('3e4fa4e3-d545-4465-a61e-de27792ec53a', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', '610ce49b-6860-4c2a-a978-58eee53abe0b', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 49, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b"}', '{"stockQty": 48, "isStocked": true, "menuItemId": "4a8d3fad-d0e2-4c19-8840-9ef706f90b7b", "quantityDeducted": 1}', '2026-09-12 16:04:39.721+05:30', '2026-09-12 16:04:39.724083+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('a6e462b3-4bcc-4f01-b409-cb6c3c02dedf', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', 'e58cd3f4-fcb9-466f-882e-79f58c50f01d', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 100, "menuItemId": "71451535-8d85-417f-b0ec-3f2b87016045"}', '{"stockQty": 99, "isStocked": true, "menuItemId": "71451535-8d85-417f-b0ec-3f2b87016045", "quantityDeducted": 1}', '2026-09-12 16:04:39.732+05:30', '2026-09-12 16:04:39.734046+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('5b064f58-e2cc-43d8-a2ec-f0e2eba8d31e', '11111111-1111-1111-1111-111111111111', 'PAYMENT', 'b71a774b-e736-4284-a1ab-2d7b108f9bad', 'CREATE', '72bad3bb-6097-47d2-bfc2-35b1244a7b9f', NULL, '{"method": "CASH", "orderId": "abaed738-9e4f-4470-ae04-031b3baa4721", "amountMinor": "19050", "originalAction": "PAYMENT_RECORDED"}', '2026-09-12 16:05:47.921+05:30', '2026-09-12 16:05:47.902452+05:30', NULL, NULL, '72bad3bb-6097-47d2-bfc2-35b1244a7b9f', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('f5e6453f-4454-4389-8e84-5af0982057af', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', 'de49919b-7467-40d6-a444-ce0e0b927f1e', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 100, "menuItemId": "5d13a97e-027a-445b-94eb-2f00546b1614"}', '{"stockQty": 99, "isStocked": true, "menuItemId": "5d13a97e-027a-445b-94eb-2f00546b1614", "quantityDeducted": 1}', '2026-09-12 16:20:51.922+05:30', '2026-09-12 16:20:51.923866+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('85057a99-c7b6-4632-89c5-0228628ee6d8', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', '0a897341-6ac0-4d8d-9eaf-ceade7d93d17', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 100, "menuItemId": "640584ad-7f9e-4a1b-8740-290fd382ea81"}', '{"stockQty": 99, "isStocked": true, "menuItemId": "640584ad-7f9e-4a1b-8740-290fd382ea81", "quantityDeducted": 1}', '2026-09-12 16:20:51.937+05:30', '2026-09-12 16:20:51.938645+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('6309d4c7-ddcf-4ce6-b1ec-3fa23009222d', '11111111-1111-1111-1111-111111111111', 'PAYMENT', 'b91471cb-4f98-4b75-9192-c05fc726d96a', 'CREATE', '918df673-2606-403a-9fad-1c54870d1fce', NULL, '{"method": "CASH", "orderId": "8139a10d-c414-4402-818c-ea00cfd5e786", "amountMinor": "18900", "originalAction": "PAYMENT_RECORDED"}', '2026-09-12 16:21:52.06+05:30', '2026-09-12 16:21:52.043855+05:30', NULL, NULL, '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('93202951-49d5-4404-8a66-812d5e988263', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', '507db4ef-89ab-45ce-b827-28b40e002b45', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 99, "menuItemId": "640584ad-7f9e-4a1b-8740-290fd382ea81"}', '{"stockQty": 98, "isStocked": true, "menuItemId": "640584ad-7f9e-4a1b-8740-290fd382ea81", "quantityDeducted": 1}', '2026-09-12 16:22:09.545+05:30', '2026-09-12 16:22:09.547114+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('277355b0-d8c3-4a57-a594-be0e04d18064', '11111111-1111-1111-1111-111111111111', 'PAYMENT', 'c24deced-ba82-4622-9292-ddd4b4903f30', 'CREATE', '918df673-2606-403a-9fad-1c54870d1fce', NULL, '{"method": "CASH", "orderId": "547361f1-ab65-4eeb-b5ae-790378f1eebc", "amountMinor": "8925", "originalAction": "PAYMENT_RECORDED"}', '2026-09-12 16:22:52.454+05:30', '2026-09-12 16:22:52.437215+05:30', NULL, NULL, '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('0a0a4fa8-d5b0-48fa-a709-05104afeabd3', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', '1756bfe8-0ef6-4d28-aaab-39b4e69b086e', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 99, "menuItemId": "71451535-8d85-417f-b0ec-3f2b87016045"}', '{"stockQty": 98, "isStocked": true, "menuItemId": "71451535-8d85-417f-b0ec-3f2b87016045", "quantityDeducted": 1}', '2026-09-12 16:23:25.085+05:30', '2026-09-12 16:23:25.087133+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('1900fc4c-c822-43a6-bf08-8253d38be4ad', '11111111-1111-1111-1111-111111111111', 'ORDER', '7bf0131c-f022-46a1-9a7b-8569cd3682f8', 'CREATE', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, '{"items": [{"id": "384df9e2-296b-4b7e-b7b3-fc56b19ee31b", "quantity": 1, "menuItemId": "d4d5c11d-7ca8-4f1f-9784-45b39bd6ef7c"}, {"id": "2ea6b595-c3ff-4250-b013-4b9221c0fd73", "quantity": 1, "menuItemId": "2ddb7944-4e83-4dda-99de-94dd5e83bb77"}], "originalAction": "ORDER_ITEMS_ADDED"}', '2026-09-12 16:37:34.112+05:30', '2026-09-12 16:37:34.088358+05:30', NULL, NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('df2d6d50-18d3-4806-8e57-a44726d6e651', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', '384df9e2-296b-4b7e-b7b3-fc56b19ee31b', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 100, "menuItemId": "d4d5c11d-7ca8-4f1f-9784-45b39bd6ef7c"}', '{"stockQty": 99, "isStocked": true, "menuItemId": "d4d5c11d-7ca8-4f1f-9784-45b39bd6ef7c", "quantityDeducted": 1}', '2026-09-12 16:37:34.15+05:30', '2026-09-12 16:37:34.158451+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('5597fd8e-110c-4608-895e-5009134c4308', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', '2ea6b595-c3ff-4250-b013-4b9221c0fd73', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 100, "menuItemId": "2ddb7944-4e83-4dda-99de-94dd5e83bb77"}', '{"stockQty": 99, "isStocked": true, "menuItemId": "2ddb7944-4e83-4dda-99de-94dd5e83bb77", "quantityDeducted": 1}', '2026-09-12 16:37:34.156+05:30', '2026-09-12 16:37:34.163696+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);
INSERT INTO public.audit_logs_default VALUES ('f679abf7-914e-44b3-8f70-701a0140a5b3', '11111111-1111-1111-1111-111111111111', 'PORTION_DEPLETED', 'e37fb3cb-1472-4f02-9822-a08237870bd7', 'UPDATE', '11111111-1111-1111-1111-111111111111', '{"stockQty": 98, "menuItemId": "71451535-8d85-417f-b0ec-3f2b87016045"}', '{"stockQty": 96, "isStocked": true, "menuItemId": "71451535-8d85-417f-b0ec-3f2b87016045", "quantityDeducted": 2}', '2026-09-12 16:40:24.21+05:30', '2026-09-12 16:40:24.211906+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'ORDER_PLACED', NULL, NULL);


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

INSERT INTO public.campaign_recipients VALUES ('53d71ffb-4713-44a2-ac93-d5c696981dc0', '1c31b540-9540-4b01-aadb-f98054d07106', '1fd9473f-93e8-4a70-bea9-9a7d72cde1d1', 'PENDING', NULL, NULL, '2026-09-03 12:29:17.460273+05:30');
INSERT INTO public.campaign_recipients VALUES ('752af4bd-2e50-46bf-b556-df59b8b3bbd2', '1c31b540-9540-4b01-aadb-f98054d07106', 'fb30d042-2284-4197-b74f-a0a418db5f68', 'PENDING', NULL, NULL, '2026-09-03 12:29:17.463425+05:30');
INSERT INTO public.campaign_recipients VALUES ('d8b2a656-7c13-4569-a396-700f45391419', '1c31b540-9540-4b01-aadb-f98054d07106', '088b94c5-d3ea-4cbd-b229-b47ac1c33b21', 'PENDING', NULL, NULL, '2026-09-03 12:29:17.465327+05:30');


--
-- Data for Name: cash_drawer_sessions; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.categories VALUES ('60d4a197-f11c-4267-a7de-92220a27dc4b', '67315042-c687-4cbb-b45a-f4ea4efc199f', NULL, 'Biryani (Veg)', 1, true, '2026-09-02 16:19:54.57163+05:30', '2026-09-02 16:19:54.57163+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('8fcde4bd-6deb-4827-b69b-f748741f5aea', '67315042-c687-4cbb-b45a-f4ea4efc199f', NULL, 'Biryani (Non-Veg)', 2, true, '2026-09-02 16:19:54.57163+05:30', '2026-09-02 16:19:54.57163+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('12251ad8-147d-463e-a33a-30daa7aaabf7', '67315042-c687-4cbb-b45a-f4ea4efc199f', NULL, 'Tandoori Starters (Non-Veg)', 3, true, '2026-09-02 16:19:54.57163+05:30', '2026-09-02 16:19:54.57163+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('f718f498-932d-49f6-8b6b-59a29a37e49e', '67315042-c687-4cbb-b45a-f4ea4efc199f', NULL, 'Chinese Starters (Veg)', 4, true, '2026-09-02 16:19:54.57163+05:30', '2026-09-02 16:19:54.57163+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('afca0de8-7edc-4f29-93a4-17fcdce5e27e', '67315042-c687-4cbb-b45a-f4ea4efc199f', NULL, 'Curries (Non-Veg)', 5, true, '2026-09-02 16:19:54.57163+05:30', '2026-09-02 16:19:54.57163+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('a49cfb2b-5641-43b5-ae43-96d0d1b55be1', '67315042-c687-4cbb-b45a-f4ea4efc199f', NULL, 'Roti & Breads', 6, true, '2026-09-02 16:19:54.57163+05:30', '2026-09-02 16:19:54.57163+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('2a4082ac-2df2-422b-b7f9-cf96755949f3', '67315042-c687-4cbb-b45a-f4ea4efc199f', NULL, 'Cold Beverage', 7, true, '2026-09-02 16:19:54.57163+05:30', '2026-09-02 16:19:54.57163+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('735379c7-6bd9-4ed0-be64-40d8bf1e7de8', '67315042-c687-4cbb-b45a-f4ea4efc199f', NULL, 'MOCKTAILS', 8, true, '2026-09-02 16:19:54.57163+05:30', '2026-09-02 16:19:54.57163+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('68413038-40bc-4f99-988e-7a72c60094e0', '2a543c3c-066f-4097-833a-df7c25700580', NULL, 'Breakfast', 1, true, '2026-09-02 17:55:52.062806+05:30', '2026-09-02 17:55:52.062806+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('bd5fd925-8442-4a2c-b952-de8a4e0181ee', '2a543c3c-066f-4097-833a-df7c25700580', NULL, 'Meal Box (Online)', 2, true, '2026-09-02 17:55:52.062806+05:30', '2026-09-02 17:55:52.062806+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('814499c3-e704-42df-89ab-5bc9806e2089', '2a543c3c-066f-4097-833a-df7c25700580', NULL, 'Cold Beverage', 3, true, '2026-09-02 17:55:52.062806+05:30', '2026-09-02 17:55:52.062806+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('da1e0528-b69e-4eaf-b3cc-62429b61e75e', '2a543c3c-066f-4097-833a-df7c25700580', NULL, 'Hot Beverages', 4, true, '2026-09-02 17:55:52.062806+05:30', '2026-09-02 17:55:52.062806+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('b8c64dd2-0140-44b4-a64b-aae3c6c2c9d5', '2a543c3c-066f-4097-833a-df7c25700580', NULL, 'Soup(Veg)', 5, true, '2026-09-02 17:55:52.062806+05:30', '2026-09-02 17:55:52.062806+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('6ad7a5cf-0734-45b4-a171-aaeba1c44c95', '2a543c3c-066f-4097-833a-df7c25700580', NULL, 'Meals', 6, true, '2026-09-02 17:55:52.062806+05:30', '2026-09-02 17:55:52.062806+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('0a99d107-4268-42ed-9f87-a57b16d450e7', '2a543c3c-066f-4097-833a-df7c25700580', NULL, 'Chinese Starters (Veg)', 7, true, '2026-09-02 17:55:52.062806+05:30', '2026-09-02 17:55:52.062806+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('0b64120a-6ded-4c63-9a87-8dbafd81a1bc', '2a543c3c-066f-4097-833a-df7c25700580', NULL, 'Curries (Veg)', 8, true, '2026-09-02 17:55:52.062806+05:30', '2026-09-02 17:55:52.062806+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('ccdac5f4-9e06-4d17-9212-df78bbb3ef2e', '67315042-c687-4cbb-b45a-f4ea4efc199f', NULL, 'Curries (Veg)', 0, true, '2026-09-05 13:03:58.83811+05:30', '2026-09-05 13:03:58.83811+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('ff151b4d-9fe3-4ab1-a0f6-d803109ee432', '67315042-c687-4cbb-b45a-f4ea4efc199f', NULL, 'Meals', 0, true, '2026-09-05 13:03:58.83811+05:30', '2026-09-05 13:03:58.83811+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('6b47802d-d31d-4d52-9c5e-001f4674f85e', '67315042-c687-4cbb-b45a-f4ea4efc199f', NULL, 'Breakfast', 0, true, '2026-09-05 13:03:58.83811+05:30', '2026-09-05 13:03:58.83811+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('de6e8b83-db5a-4c10-b432-6b5a66959cc4', '67315042-c687-4cbb-b45a-f4ea4efc199f', NULL, 'Hot Beverages', 0, true, '2026-09-05 13:03:58.83811+05:30', '2026-09-05 13:03:58.83811+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('2553c114-60e6-4ffd-a050-c41a6c3bf846', '67315042-c687-4cbb-b45a-f4ea4efc199f', NULL, 'Soup(Veg)', 0, true, '2026-09-05 13:03:58.83811+05:30', '2026-09-05 13:03:58.83811+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('1541649d-c982-46a7-a228-ad78aba10f6c', '67315042-c687-4cbb-b45a-f4ea4efc199f', NULL, 'Meal Box (Online)', 0, true, '2026-09-05 13:03:58.83811+05:30', '2026-09-05 13:03:58.83811+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('9f32e838-0597-41ad-97d7-6412c26afe7b', '2a543c3c-066f-4097-833a-df7c25700580', NULL, 'Curries (Non-Veg)', 0, true, '2026-09-05 13:03:58.83811+05:30', '2026-09-05 13:03:58.83811+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('e10d567d-babb-4e94-a79a-eb3a48de4812', '2a543c3c-066f-4097-833a-df7c25700580', NULL, 'Biryani (Veg)', 0, true, '2026-09-05 13:03:58.83811+05:30', '2026-09-05 13:03:58.83811+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('a976ef06-5bbd-4e1a-ba06-59ac9b0a6b84', '2a543c3c-066f-4097-833a-df7c25700580', NULL, 'MOCKTAILS', 0, true, '2026-09-05 13:03:58.83811+05:30', '2026-09-05 13:03:58.83811+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('630f03b9-480d-4107-84e1-57e43df0a45e', '2a543c3c-066f-4097-833a-df7c25700580', NULL, 'Roti & Breads', 0, true, '2026-09-05 13:03:58.83811+05:30', '2026-09-05 13:03:58.83811+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('e4b000a5-48de-44ba-bf02-3929b1f75c89', '2a543c3c-066f-4097-833a-df7c25700580', NULL, 'Tandoori Starters (Non-Veg)', 0, true, '2026-09-05 13:03:58.83811+05:30', '2026-09-05 13:03:58.83811+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('7e99f115-5a4e-404a-880d-118faff89110', '2a543c3c-066f-4097-833a-df7c25700580', NULL, 'Biryani (Non-Veg)', 0, true, '2026-09-05 13:03:58.83811+05:30', '2026-09-05 13:03:58.83811+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('c332c03a-b4ff-4db0-b13f-b241c651abc8', '11111111-1111-1111-1111-111111111111', NULL, 'Chinese Starters (Veg)', 0, true, '2026-09-05 13:03:58.83811+05:30', '2026-09-05 13:03:58.83811+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('9923f0e7-8519-4e37-af76-137a8781e285', '11111111-1111-1111-1111-111111111111', NULL, 'Curries (Non-Veg)', 0, true, '2026-09-05 13:03:58.83811+05:30', '2026-09-05 13:03:58.83811+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('e18291bb-1c6d-426d-a753-c58922a38598', '11111111-1111-1111-1111-111111111111', NULL, 'Biryani (Veg)', 0, true, '2026-09-05 13:03:58.83811+05:30', '2026-09-05 13:03:58.83811+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('226608d8-4b01-406d-a0bc-3da3381efd44', '11111111-1111-1111-1111-111111111111', NULL, 'MOCKTAILS', 0, true, '2026-09-05 13:03:58.83811+05:30', '2026-09-05 13:03:58.83811+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('ef059e72-0460-4ec5-8faf-ca1bd16ce17e', '11111111-1111-1111-1111-111111111111', NULL, 'Roti & Breads', 0, true, '2026-09-05 13:03:58.83811+05:30', '2026-09-05 13:03:58.83811+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('1a8e9f1a-9874-41b3-b04e-dcff9cbd9c52', '11111111-1111-1111-1111-111111111111', NULL, 'Curries (Veg)', 0, true, '2026-09-05 13:03:58.83811+05:30', '2026-09-05 13:03:58.83811+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('ecde6efc-8c90-4e6c-bac7-c30e1a98089c', '11111111-1111-1111-1111-111111111111', NULL, 'Meals', 0, true, '2026-09-05 13:03:58.83811+05:30', '2026-09-05 13:03:58.83811+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('bc2819ef-3f7e-4c79-a692-bb059757eeae', '11111111-1111-1111-1111-111111111111', NULL, 'Cold Beverage', 0, true, '2026-09-05 13:03:58.83811+05:30', '2026-09-05 13:03:58.83811+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('a65ebbc1-bfb6-42ce-95cf-112d5a76e825', '11111111-1111-1111-1111-111111111111', NULL, 'Breakfast', 0, true, '2026-09-05 13:03:58.83811+05:30', '2026-09-05 13:03:58.83811+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('00e25236-2c50-4e2b-818d-88c104db92bb', '11111111-1111-1111-1111-111111111111', NULL, 'Tandoori Starters (Non-Veg)', 0, true, '2026-09-05 13:03:58.83811+05:30', '2026-09-05 13:03:58.83811+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('764ab8d6-7220-4bfb-bb9f-23f7d804bc71', '11111111-1111-1111-1111-111111111111', NULL, 'Hot Beverages', 0, true, '2026-09-05 13:03:58.83811+05:30', '2026-09-05 13:03:58.83811+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('c6d92d2d-adeb-4d91-b143-097e7b3ef69a', '11111111-1111-1111-1111-111111111111', NULL, 'Soup(Veg)', 0, true, '2026-09-05 13:03:58.83811+05:30', '2026-09-05 13:03:58.83811+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('26fd5701-0ca8-4a3d-8a30-706cca828e47', '11111111-1111-1111-1111-111111111111', NULL, 'Biryani (Non-Veg)', 0, true, '2026-09-05 13:03:58.83811+05:30', '2026-09-05 13:03:58.83811+05:30', NULL, NULL);
INSERT INTO public.categories VALUES ('638dcd56-a022-462a-aacc-125069c4a2ad', '11111111-1111-1111-1111-111111111111', NULL, 'Meal Box (Online)', 0, true, '2026-09-05 13:03:58.83811+05:30', '2026-09-05 13:03:58.83811+05:30', NULL, NULL);


--
-- Data for Name: channel_accounts; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.channel_accounts VALUES ('fd002d2b-3ba9-456e-bd66-5479c535612f', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'a0b27e38-ffc0-4967-b3e5-7bedd6210fab', 'SW-KAPILA-01', 'swiggy_production_v2', true, '2026-09-03 12:29:17.406338+05:30', '2026-09-03 12:29:17.406338+05:30', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL);
INSERT INTO public.channel_accounts VALUES ('ec610d2c-357c-4945-a383-5f734846d834', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'c185eb00-4dcd-4f32-b700-39c5d5f9429c', 'ZM-KAPILA-01', 'zomato_merchant_v1', true, '2026-09-03 12:29:17.410303+05:30', '2026-09-03 12:29:17.410303+05:30', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL);


--
-- Data for Name: channel_item_mapping; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.channel_item_mapping VALUES ('422ec885-18a2-4b5b-87c0-e3f067455394', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'fd002d2b-3ba9-456e-bd66-5479c535612f', '1048c560-86bd-45c5-b872-eb5e802c6e46', 'EXT-HOTE-1048', '2026-09-03 12:29:17.422378+05:30', '2026-09-03 12:29:17.422378+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('63de6c4e-65e1-425a-ab39-29bea04ced57', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'fd002d2b-3ba9-456e-bd66-5479c535612f', 'c4945f10-ab36-4a6a-8388-0a0c4904d9da', 'EXT-HYDE-c494', '2026-09-03 12:29:17.427344+05:30', '2026-09-03 12:29:17.427344+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('04a480c3-a24c-441c-a7c1-42442b4d41fa', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'fd002d2b-3ba9-456e-bd66-5479c535612f', '7455214f-4d3e-495e-a9eb-9a13cda64003', 'EXT-MURG-7455', '2026-09-03 12:29:17.429184+05:30', '2026-09-03 12:29:17.429184+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('dd83ca61-0e2d-4298-bdaf-f75834604bbf', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'fd002d2b-3ba9-456e-bd66-5479c535612f', 'c1f09997-5bb1-4ee9-abb6-9b622c2c8e91', 'EXT-KAPI-c1f0', '2026-09-03 12:29:17.430812+05:30', '2026-09-03 12:29:17.430812+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('eed9caf6-5318-4008-a5cd-b8431ef39386', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'fd002d2b-3ba9-456e-bd66-5479c535612f', 'cdc12a71-3f32-4630-ab8b-059ae196af2c', 'EXT-BUTT-cdc1', '2026-09-03 12:29:17.432491+05:30', '2026-09-03 12:29:17.432491+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('d1692882-f9ce-4326-be85-83fada177810', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'ec610d2c-357c-4945-a383-5f734846d834', '1048c560-86bd-45c5-b872-eb5e802c6e46', 'EXT-HOTE-1048', '2026-09-03 12:29:17.434107+05:30', '2026-09-03 12:29:17.434107+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('590a5571-a53b-4e75-b369-cadb0b08befb', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'ec610d2c-357c-4945-a383-5f734846d834', 'c4945f10-ab36-4a6a-8388-0a0c4904d9da', 'EXT-HYDE-c494', '2026-09-03 12:29:17.435943+05:30', '2026-09-03 12:29:17.435943+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('0f192c51-445b-4e1f-bb17-0d5314ccc84b', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'ec610d2c-357c-4945-a383-5f734846d834', '7455214f-4d3e-495e-a9eb-9a13cda64003', 'EXT-MURG-7455', '2026-09-03 12:29:17.437848+05:30', '2026-09-03 12:29:17.437848+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('63f29961-082e-47d3-918e-87260ff5972d', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'ec610d2c-357c-4945-a383-5f734846d834', 'c1f09997-5bb1-4ee9-abb6-9b622c2c8e91', 'EXT-KAPI-c1f0', '2026-09-03 12:29:17.439411+05:30', '2026-09-03 12:29:17.439411+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('2ff1e6a7-7460-4bf3-b34b-b7c69cca5e2b', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'ec610d2c-357c-4945-a383-5f734846d834', 'cdc12a71-3f32-4630-ab8b-059ae196af2c', 'EXT-BUTT-cdc1', '2026-09-03 12:29:17.440883+05:30', '2026-09-03 12:29:17.440883+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('a5a18871-4bb4-4929-b338-f5288056e2ea', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'fd002d2b-3ba9-456e-bd66-5479c535612f', '8772f56e-a632-4998-ae87-45084349bf9f', 'EXT-(2) -8772', '2026-09-05 13:04:10.699634+05:30', '2026-09-05 13:04:10.699634+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('7d937772-6e8b-4d86-8c03-f3453a38ebcf', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'fd002d2b-3ba9-456e-bd66-5479c535612f', '47dce856-d45e-41a3-a7de-84a823aa6d5a', 'EXT-(S) -47dc', '2026-09-05 13:04:10.702992+05:30', '2026-09-05 13:04:10.702992+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('c632fe97-4b7a-40b5-9358-5fe6ee136c88', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'fd002d2b-3ba9-456e-bd66-5479c535612f', '81f170e9-ad77-44a9-b8dc-7a7d4a2b84cc', 'EXT-(S) -81f1', '2026-09-05 13:04:10.705028+05:30', '2026-09-05 13:04:10.705028+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('15402192-7ce6-4680-8acd-dcb1937a301d', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'fd002d2b-3ba9-456e-bd66-5479c535612f', 'c97c9587-1c8d-4421-abc4-65e15db4bc81', 'EXT-(S) -c97c', '2026-09-05 13:04:10.706693+05:30', '2026-09-05 13:04:10.706693+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('1b0fed67-1ddf-4261-b2cc-a85c8d32f227', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'fd002d2b-3ba9-456e-bd66-5479c535612f', '9e6b5249-048d-4aeb-a0b6-acfd8f6a8501', 'EXT-(S) -9e6b', '2026-09-05 13:04:10.708324+05:30', '2026-09-05 13:04:10.708324+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('0e02820a-266c-4b52-ba23-710cf110f56d', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'ec610d2c-357c-4945-a383-5f734846d834', '8772f56e-a632-4998-ae87-45084349bf9f', 'EXT-(2) -8772', '2026-09-05 13:04:10.713073+05:30', '2026-09-05 13:04:10.713073+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('9a064db7-c04f-4099-80ae-b89593b2fcbb', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'ec610d2c-357c-4945-a383-5f734846d834', '47dce856-d45e-41a3-a7de-84a823aa6d5a', 'EXT-(S) -47dc', '2026-09-05 13:04:10.714892+05:30', '2026-09-05 13:04:10.714892+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('c6426f61-2758-43ba-ac28-ef704f037b5a', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'ec610d2c-357c-4945-a383-5f734846d834', '81f170e9-ad77-44a9-b8dc-7a7d4a2b84cc', 'EXT-(S) -81f1', '2026-09-05 13:04:10.71633+05:30', '2026-09-05 13:04:10.71633+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('ee2eb1b2-2dae-4ba3-b74c-6047c7f0323d', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'ec610d2c-357c-4945-a383-5f734846d834', 'c97c9587-1c8d-4421-abc4-65e15db4bc81', 'EXT-(S) -c97c', '2026-09-05 13:04:10.717789+05:30', '2026-09-05 13:04:10.717789+05:30', NULL, NULL, 'MENU_V1', 1);
INSERT INTO public.channel_item_mapping VALUES ('3c5195ff-81e9-466f-9ece-8c2d8085fdf3', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'ec610d2c-357c-4945-a383-5f734846d834', '9e6b5249-048d-4aeb-a0b6-acfd8f6a8501', 'EXT-(S) -9e6b', '2026-09-05 13:04:10.719263+05:30', '2026-09-05 13:04:10.719263+05:30', NULL, NULL, 'MENU_V1', 1);


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

INSERT INTO public.customers VALUES ('724eba8c-0924-4006-9ddb-ca86aa4e96eb', '00000000-0000-0000-0000-000000000000', '9898998988', 'amjad', NULL, false, false, NULL, true, '2026-09-12 11:38:00.631+05:30', '2026-09-12 11:38:00.631+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'amjad', NULL, 0, NULL);
INSERT INTO public.customers VALUES ('1fd9473f-93e8-4a70-bea9-9a7d72cde1d1', '00000000-0000-0000-0000-000000000000', '9988776655', NULL, 'arjun.reddy@example.com', false, false, NULL, true, '2026-09-02 16:26:46.886+05:30', '2026-09-12 11:57:16.522+05:30', NULL, NULL, '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Arjun', 'Reddy', 500, NULL);
INSERT INTO public.customers VALUES ('fb30d042-2284-4197-b74f-a0a418db5f68', '00000000-0000-0000-0000-000000000000', '9876543212', NULL, 'priya.sharma@example.com', false, false, NULL, true, '2026-09-02 16:26:46.893+05:30', '2026-09-12 11:57:16.543+05:30', NULL, NULL, '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Priya', 'Sharma', 1200, NULL);
INSERT INTO public.customers VALUES ('088b94c5-d3ea-4cbd-b229-b47ac1c33b21', '00000000-0000-0000-0000-000000000000', '9123456789', NULL, 'rahul.k@example.com', false, false, NULL, true, '2026-09-02 16:26:46.897+05:30', '2026-09-12 11:57:16.55+05:30', NULL, NULL, '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Rahul', 'Kumar', 0, NULL);
INSERT INTO public.customers VALUES ('c158b890-ee02-405e-bfb2-57b349e6eeb3', '00000000-0000-0000-0000-000000000000', '9777027509', 'Zara Khan', 'zara@test.com', false, false, NULL, true, '2026-09-12 12:03:15.675+05:30', '2026-09-12 12:03:15.675+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'Zara', 'Khan', 100, NULL);
INSERT INTO public.customers VALUES ('509bcc9b-7529-497d-b987-29ee463cf67e', '00000000-0000-0000-0000-000000000000', '1231231233', 'annuj', NULL, false, false, NULL, true, '2026-09-12 12:16:21.114+05:30', '2026-09-12 12:16:21.114+05:30', NULL, NULL, '11111111-1111-1111-1111-111111111111', 'annuj', NULL, 50, NULL);


--
-- Data for Name: daily_sales_summary; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: dining_tables; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.dining_tables VALUES ('f9f11b94-f612-4690-969b-4fa4f8fa626c', '11111111-1111-1111-1111-111111111111', 'TEST_VERIFY', 4, 'Non AC', 'VACANT', false, '2026-09-11 17:26:24.929+05:30', '2026-09-11 17:26:24.985+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('fc8127fc-a614-4ba2-ae4e-bc2fb91b2d3d', '11111111-1111-1111-1111-111111111111', 'kp10', 4, 'Non AC', 'VACANT', true, '2026-09-11 17:28:26.08+05:30', '2026-09-11 17:28:26.08+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('2e681514-bcbe-4ef9-bc4d-b2209a3d5f85', '11111111-1111-1111-1111-111111111111', 'cv', 4, 'Non AC', 'DIRTY', true, '2026-09-04 01:16:54.711+05:30', '2026-09-12 16:21:52.206+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('bc9b4960-2a8a-4ee0-a903-699565b135ee', '2a543c3c-066f-4097-833a-df7c25700580', 'A1', 4, 'AC', 'VACANT', true, '2026-09-02 16:33:25.669+05:30', '2026-09-02 16:33:25.669+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('0dd047e5-f8e3-4d7c-9796-65c158cc3a0e', '2a543c3c-066f-4097-833a-df7c25700580', 'A2', 4, 'AC', 'VACANT', true, '2026-09-02 16:33:25.675+05:30', '2026-09-02 16:33:25.675+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('b8eeae1e-627b-4952-95af-0bc0eb8031b3', '2a543c3c-066f-4097-833a-df7c25700580', 'A3', 4, 'AC', 'VACANT', true, '2026-09-02 16:33:25.678+05:30', '2026-09-02 16:33:25.678+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('21e6342a-11da-471e-9a05-9c59f0682071', '2a543c3c-066f-4097-833a-df7c25700580', 'A4', 4, 'AC', 'VACANT', true, '2026-09-02 16:33:25.681+05:30', '2026-09-02 16:33:25.681+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('66bbd011-47dc-411f-9e63-9f52d9becdf3', '2a543c3c-066f-4097-833a-df7c25700580', 'A5', 4, 'AC', 'VACANT', true, '2026-09-02 16:33:25.684+05:30', '2026-09-02 16:33:25.684+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('92fc1fda-0e53-44c2-953e-4301d3090f99', '2a543c3c-066f-4097-833a-df7c25700580', 'A6', 6, 'AC', 'VACANT', true, '2026-09-02 16:33:25.687+05:30', '2026-09-02 16:33:25.687+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('1ba00f45-b203-4494-84f2-76ca45fe2d7f', '2a543c3c-066f-4097-833a-df7c25700580', 'A7', 4, 'AC', 'VACANT', true, '2026-09-02 16:33:25.691+05:30', '2026-09-02 16:33:25.691+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('25ff8a10-c49b-40d0-9d5e-aba254065bb4', '2a543c3c-066f-4097-833a-df7c25700580', 'A8', 4, 'AC', 'VACANT', true, '2026-09-02 16:33:25.695+05:30', '2026-09-02 16:33:25.695+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('3e2cc430-0411-4b2a-8061-4f7f8c65903f', '2a543c3c-066f-4097-833a-df7c25700580', 'A9', 6, 'AC', 'VACANT', true, '2026-09-02 16:33:25.697+05:30', '2026-09-02 16:33:25.697+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('8c30be00-12ff-4661-99cf-140b081e50da', '2a543c3c-066f-4097-833a-df7c25700580', 'A10', 4, 'AC', 'VACANT', true, '2026-09-02 16:33:25.7+05:30', '2026-09-02 16:33:25.7+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('1cbcd8f1-0650-4862-8135-4f7b739bd53a', '2a543c3c-066f-4097-833a-df7c25700580', 'A11', 2, 'AC', 'VACANT', true, '2026-09-02 16:33:25.703+05:30', '2026-09-02 16:33:25.703+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('83b943da-f25b-4305-afbe-b9b5edf3346e', '2a543c3c-066f-4097-833a-df7c25700580', 'A12', 4, 'AC', 'VACANT', true, '2026-09-02 16:33:25.706+05:30', '2026-09-02 16:33:25.706+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('ec0544f9-96a0-4e2b-964c-c2c681a7e0eb', '2a543c3c-066f-4097-833a-df7c25700580', 'A13', 4, 'AC', 'VACANT', true, '2026-09-02 16:33:25.708+05:30', '2026-09-02 16:33:25.708+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('09696420-813f-4123-a841-919e7b1b29a0', '2a543c3c-066f-4097-833a-df7c25700580', 'A14', 4, 'AC', 'VACANT', true, '2026-09-02 16:33:25.71+05:30', '2026-09-02 16:33:25.71+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('991d6f67-06ee-451d-8f9c-580791737b6d', '2a543c3c-066f-4097-833a-df7c25700580', 'A15', 4, 'AC', 'VACANT', true, '2026-09-02 16:33:25.713+05:30', '2026-09-02 16:33:25.713+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('90588dd8-d07d-4f72-baf8-fffd89f5617e', '2a543c3c-066f-4097-833a-df7c25700580', 'B1', 4, 'Non AC', 'VACANT', true, '2026-09-02 16:33:25.715+05:30', '2026-09-02 16:33:25.715+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('d57be9ba-84b5-4225-8f98-74aa83384b4a', '2a543c3c-066f-4097-833a-df7c25700580', 'B2', 4, 'Non AC', 'VACANT', true, '2026-09-02 16:33:25.717+05:30', '2026-09-02 16:33:25.717+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('98e19752-500d-46cb-8577-fbcbebf927f0', '2a543c3c-066f-4097-833a-df7c25700580', 'B3', 4, 'Non AC', 'VACANT', true, '2026-09-02 16:33:25.719+05:30', '2026-09-02 16:33:25.719+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('5fee1338-f4c2-495f-bac5-705a5d3da3a4', '2a543c3c-066f-4097-833a-df7c25700580', 'B4', 4, 'Non AC', 'VACANT', true, '2026-09-02 16:33:25.72+05:30', '2026-09-02 16:33:25.72+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('6145c07b-defd-4e9d-966a-5b7e96c9e31b', '2a543c3c-066f-4097-833a-df7c25700580', 'B5', 4, 'Non AC', 'VACANT', true, '2026-09-02 16:33:25.722+05:30', '2026-09-02 16:33:25.722+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('33973605-707e-498f-8c86-4756f2823a6e', '2a543c3c-066f-4097-833a-df7c25700580', 'B6', 4, 'Non AC', 'VACANT', true, '2026-09-02 16:33:25.724+05:30', '2026-09-02 16:33:25.724+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('75261ef1-f63c-4ec1-baec-9f7a43c6e917', '2a543c3c-066f-4097-833a-df7c25700580', 'B7', 4, 'Non AC', 'VACANT', true, '2026-09-02 16:33:25.725+05:30', '2026-09-02 16:33:25.725+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('99a59379-4f9c-4cb3-9fac-543d35254b9a', '2a543c3c-066f-4097-833a-df7c25700580', 'B8', 4, 'Non AC', 'VACANT', true, '2026-09-02 16:33:25.727+05:30', '2026-09-02 16:33:25.727+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('d98df111-57f4-494c-a33f-2ca348211f8d', '2a543c3c-066f-4097-833a-df7c25700580', 'B9', 4, 'Non AC', 'VACANT', true, '2026-09-02 16:33:25.729+05:30', '2026-09-02 16:33:25.729+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('7b422323-dc95-4695-8b49-888aa89f72f3', '2a543c3c-066f-4097-833a-df7c25700580', 'B10', 4, 'Non AC', 'VACANT', true, '2026-09-02 16:33:25.73+05:30', '2026-09-02 16:33:25.73+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('4b963032-9e35-4fd1-9229-471e2bd8abd1', '2a543c3c-066f-4097-833a-df7c25700580', 'B11', 4, 'Non AC', 'VACANT', true, '2026-09-02 16:33:25.733+05:30', '2026-09-02 16:33:25.733+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('d96f392b-f645-46ff-863c-fc097896cdbc', '2a543c3c-066f-4097-833a-df7c25700580', 'B12', 6, 'Non AC', 'VACANT', true, '2026-09-02 16:33:25.735+05:30', '2026-09-02 16:33:25.735+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('cb05ab0d-5ff7-4103-9217-e91581596879', '2a543c3c-066f-4097-833a-df7c25700580', 'B13', 4, 'Non AC', 'VACANT', true, '2026-09-02 16:33:25.737+05:30', '2026-09-02 16:33:25.737+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('7a72784b-1dab-42f9-b7dc-7b98ccb77007', '2a543c3c-066f-4097-833a-df7c25700580', 'B14', 4, 'Non AC', 'VACANT', true, '2026-09-02 16:33:25.739+05:30', '2026-09-02 16:33:25.739+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('f74dcea1-b081-4d96-a13e-7b3209ad7aac', '2a543c3c-066f-4097-833a-df7c25700580', 'B15', 4, 'Non AC', 'VACANT', true, '2026-09-02 16:33:25.74+05:30', '2026-09-02 16:33:25.74+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('d51291b6-5c25-46c0-a96a-4e113da12739', '2a543c3c-066f-4097-833a-df7c25700580', 'B16', 4, 'Non AC', 'VACANT', true, '2026-09-02 16:33:25.742+05:30', '2026-09-02 16:33:25.742+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('011233b3-81d8-4083-9e2f-d02b4134d6c5', '2a543c3c-066f-4097-833a-df7c25700580', 'B17', 4, 'Non AC', 'VACANT', true, '2026-09-02 16:33:25.744+05:30', '2026-09-02 16:33:25.744+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('bce84145-6ee7-4f43-a822-755ef84523a7', '2a543c3c-066f-4097-833a-df7c25700580', 'B18', 4, 'Non AC', 'VACANT', true, '2026-09-02 16:33:25.746+05:30', '2026-09-02 16:33:25.746+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('b0283350-364f-43b3-b524-3ace4978a9a6', '2a543c3c-066f-4097-833a-df7c25700580', 'B19', 4, 'Non AC', 'VACANT', true, '2026-09-02 16:33:25.747+05:30', '2026-09-02 16:33:25.747+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('75485259-84fa-4857-ad44-be376e3dfb9e', '2a543c3c-066f-4097-833a-df7c25700580', 'B20', 4, 'Non AC', 'VACANT', true, '2026-09-02 16:33:25.749+05:30', '2026-09-02 16:33:25.749+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('6a18549d-a91a-44b0-8461-3487c1c6a9e1', '2a543c3c-066f-4097-833a-df7c25700580', 'B21', 4, 'Non AC', 'VACANT', true, '2026-09-02 16:33:25.751+05:30', '2026-09-02 16:33:25.751+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('577b0b64-ca14-4629-a827-d1b85e66da08', '2a543c3c-066f-4097-833a-df7c25700580', 'B22', 4, 'Non AC', 'VACANT', true, '2026-09-02 16:33:25.753+05:30', '2026-09-02 16:33:25.753+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('7c79cf80-e43f-43ce-a2be-9d9fe0a0f0a2', '2a543c3c-066f-4097-833a-df7c25700580', 'B23', 4, 'Non AC', 'VACANT', true, '2026-09-02 16:33:25.756+05:30', '2026-09-02 16:33:25.756+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('86f9b52c-06d6-47f0-a7cd-e77dc7027c76', '2a543c3c-066f-4097-833a-df7c25700580', 'B24', 4, 'Non AC', 'VACANT', true, '2026-09-02 16:33:25.757+05:30', '2026-09-02 16:33:25.757+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('38b9d262-8fb4-4e98-8e48-d2c06f671cbc', '2a543c3c-066f-4097-833a-df7c25700580', 'B25', 4, 'Non AC', 'VACANT', true, '2026-09-02 16:33:25.759+05:30', '2026-09-02 16:33:25.759+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('61becee5-ad3a-48ca-8d44-91579aa607e6', '2a543c3c-066f-4097-833a-df7c25700580', 'B26', 4, 'Non AC', 'VACANT', true, '2026-09-02 16:33:25.761+05:30', '2026-09-02 16:33:25.761+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('c28370ca-16c9-4a9d-9d77-c8172a5b5d60', '2a543c3c-066f-4097-833a-df7c25700580', 'B27', 4, 'Non AC', 'VACANT', true, '2026-09-02 16:33:25.763+05:30', '2026-09-02 16:33:25.763+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('6257da7e-d19f-4402-92f3-d9c589f99cc8', '2a543c3c-066f-4097-833a-df7c25700580', 'B28', 4, 'Non AC', 'VACANT', true, '2026-09-02 16:33:25.769+05:30', '2026-09-02 16:33:25.769+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('d6dc3dc8-e53f-4f68-8a53-b0a6c326318b', '2a543c3c-066f-4097-833a-df7c25700580', 'B29', 4, 'Non AC', 'VACANT', true, '2026-09-02 16:33:25.771+05:30', '2026-09-02 16:33:25.771+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('961db5ed-1266-4358-94ce-b2d34ff69797', '2a543c3c-066f-4097-833a-df7c25700580', 'B30', 4, 'Non AC', 'VACANT', true, '2026-09-02 16:33:25.773+05:30', '2026-09-02 16:33:25.773+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('b4442beb-f234-4f13-a069-740bb794abfe', '2a543c3c-066f-4097-833a-df7c25700580', 'LADIES C', 10, 'Other', 'VACANT', true, '2026-09-02 16:33:25.775+05:30', '2026-09-02 16:33:25.775+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('6f041cce-cbf6-4cde-8215-9e23263224cf', '2a543c3c-066f-4097-833a-df7c25700580', 'b18a', 2, 'Other', 'VACANT', true, '2026-09-02 16:33:25.777+05:30', '2026-09-02 16:33:25.777+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('a37af3fa-06cd-4f9d-8994-11a7d204ce5d', '2a543c3c-066f-4097-833a-df7c25700580', 'b19a', 2, 'Other', 'VACANT', true, '2026-09-02 16:33:25.779+05:30', '2026-09-02 16:33:25.779+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('7f7e342f-0f6c-456c-9ec5-055de3ab87fe', '11111111-1111-1111-1111-111111111111', 'Kap3', 4, 'Non AC', 'VACANT', true, '2026-09-08 13:12:32.064+05:30', '2026-09-08 13:12:32.064+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('1bb0a59d-079d-4406-8bd9-0fd2f4a7668e', '11111111-1111-1111-1111-111111111111', 'll', 4, 'Non AC', 'VACANT', true, '2026-09-04 01:04:14.781+05:30', '2026-09-05 17:14:44.782+05:30', NULL, NULL, 5, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('f2f701b9-6bc9-4869-8f88-4904a35070d8', '11111111-1111-1111-1111-111111111111', 'aw', 4, 'Non AC', 'OCCUPIED', true, '2026-09-03 14:06:16.807+05:30', '2026-09-11 14:24:19.967+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('799771fc-55e6-42a7-8a24-c8946f547286', '11111111-1111-1111-1111-111111111111', 'Kap2', 4, 'Non AC', 'OCCUPIED', true, '2026-09-08 13:12:23.549+05:30', '2026-09-12 16:37:34.212+05:30', NULL, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.dining_tables VALUES ('bb01f08e-7a9d-43b3-acce-be35218b3f27', '11111111-1111-1111-1111-111111111111', 'Kap1', 4, 'Non AC', 'OCCUPIED', true, '2026-09-03 14:51:16.585+05:30', '2026-09-12 16:40:24.242+05:30', NULL, NULL, 5, NULL, NULL, NULL, NULL);


--
-- Data for Name: hourly_sales_summary; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: inbound_events; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: ingredients; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.ingredients VALUES ('52cc0d01-2f6a-469e-a864-17052550c521', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Aged Basmati Rice', 'kg', 0, 30, 0.000, true, '2026-09-02 16:21:33.957+05:30', '2026-09-02 16:21:33.957+05:30', NULL, NULL, 150, 11000);
INSERT INTO public.ingredients VALUES ('ad69f282-5239-4a91-a0c0-173e691a1ccb', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Fresh Chicken (Boneless)', 'kg', 0, 15, 0.000, true, '2026-09-02 16:21:33.963+05:30', '2026-09-02 16:21:33.963+05:30', NULL, NULL, 45, 24000);
INSERT INTO public.ingredients VALUES ('0589f156-27da-45c1-9498-19f2b893211d', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Fresh Paneer', 'kg', 0, 5, 0.000, true, '2026-09-02 16:21:33.967+05:30', '2026-09-02 16:21:33.967+05:30', NULL, NULL, 20, 32000);
INSERT INTO public.ingredients VALUES ('b69ecf56-0acd-4634-95ed-375614d85281', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Pure Desi Ghee', 'l', 0, 5, 0.000, true, '2026-09-02 16:21:33.971+05:30', '2026-09-02 16:21:33.971+05:30', NULL, NULL, 25, 65000);
INSERT INTO public.ingredients VALUES ('66ae2eba-88d4-47ce-bdfd-8e11320952ab', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Tomato Puree', 'l', 0, 20, 0.000, true, '2026-09-02 16:30:20.942+05:30', '2026-09-02 16:30:20.942+05:30', NULL, NULL, 100, 5000);
INSERT INTO public.ingredients VALUES ('d78382d7-01dd-4e51-a6d9-374e54182a54', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Basmati Rice', 'kg', 0, 10, -0.250, true, '2026-09-02 16:30:20.933+05:30', '2026-09-05 16:45:42.195+05:30', NULL, '918df673-2606-403a-9fad-1c54870d1fce', 100, 8000);
INSERT INTO public.ingredients VALUES ('f811d9a2-42c3-45dd-b45a-15ee97731274', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Chicken Breast', 'kg', 0, 5, -0.200, true, '2026-09-02 16:30:20.939+05:30', '2026-09-05 16:45:42.237+05:30', NULL, '918df673-2606-403a-9fad-1c54870d1fce', 100, 22000);


--
-- Data for Name: integration_errors; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: integrations; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.integrations VALUES ('a0b27e38-ffc0-4967-b3e5-7bedd6210fab', 'SWIGGY', 'SWIGGY', true, '2026-09-03 12:29:17.396292+05:30', '2026-09-05 13:04:10.660284+05:30', NULL, NULL);
INSERT INTO public.integrations VALUES ('c185eb00-4dcd-4f32-b700-39c5d5f9429c', 'ZOMATO', 'ZOMATO', true, '2026-09-03 12:29:17.408497+05:30', '2026-09-05 13:04:10.676941+05:30', NULL, NULL);


--
-- Data for Name: inventory_consumption_log; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.inventory_consumption_log VALUES ('a319327e-c345-4785-ad4c-358453b81d64', '67315042-c687-4cbb-b45a-f4ea4efc199f', '5b433b06-af43-4f62-8a6b-e2ca1e0bfa88', 'e33ec171-252d-4f6b-acac-694e76f4bf53', 'd78382d7-01dd-4e51-a6d9-374e54182a54', '12eabedd-f2c0-4dab-98cf-7f080acee451', 0.250, -0.250, 0.250, 'ORDER_SETTLED', '2026-09-05 16:45:42.203+05:30');
INSERT INTO public.inventory_consumption_log VALUES ('806c37b8-d409-4344-ad10-687f23584530', '67315042-c687-4cbb-b45a-f4ea4efc199f', '5b433b06-af43-4f62-8a6b-e2ca1e0bfa88', 'e33ec171-252d-4f6b-acac-694e76f4bf53', 'f811d9a2-42c3-45dd-b45a-15ee97731274', '12eabedd-f2c0-4dab-98cf-7f080acee451', 0.200, -0.200, 0.200, 'ORDER_SETTLED', '2026-09-05 16:45:42.239+05:30');


--
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.invoices VALUES ('b6be566b-b890-4577-b9e8-745bacddd500', '11111111-1111-1111-1111-111111111111', 'a00d57c3-c01d-49d0-9166-45e9f7e22497', 'INV-2026-00001', 47250, 2250, 0, NULL, 0, '2026-09-05 13:22:05.621+05:30', 0, 'INV-2026-00001', 47250, 2250);
INSERT INTO public.invoices VALUES ('6c0f3e9e-6b52-4b93-a776-67a187f32cdc', '11111111-1111-1111-1111-111111111111', '0f3580d0-cceb-4289-99f8-5ffdf1669b18', 'INV-2026-00002', 5250, 250, 0, NULL, 0, '2026-09-05 15:10:12.823+05:30', 0, 'INV-2026-00002', 5250, 250);
INSERT INTO public.invoices VALUES ('b150a504-fabd-4996-b503-5bd0ef6bfe81', '67315042-c687-4cbb-b45a-f4ea4efc199f', '5b433b06-af43-4f62-8a6b-e2ca1e0bfa88', 'INV-2026-00001', 35700, 1700, 0, NULL, 0, '2026-09-05 16:45:42.155+05:30', 0, 'INV-2026-00001', 35700, 1700);
INSERT INTO public.invoices VALUES ('9d5d6583-8727-4356-9d6e-5b42ddd88f8d', '11111111-1111-1111-1111-111111111111', '7a369854-faf1-4af3-8378-8b939249c434', 'INV-2026-00003', 6825, 325, 0, NULL, 0, '2026-09-05 16:51:32.889+05:30', 0, 'INV-2026-00003', 6825, 325);
INSERT INTO public.invoices VALUES ('a31aeede-b045-4bf3-a6fb-2ec745384074', '11111111-1111-1111-1111-111111111111', '82e2a068-a74a-4e18-89fe-7a423f5b243f', 'INV-2026-00004', 7350, 350, 0, NULL, 0, '2026-09-05 17:14:44.768+05:30', 0, 'INV-2026-00004', 7350, 350);
INSERT INTO public.invoices VALUES ('5584cd8e-db50-4ef5-a86f-57ee9110ebf7', '11111111-1111-1111-1111-111111111111', '71ef893c-0ccc-439d-bc3e-0a248037303b', 'INV-2026-00005', 10904, 404, 0, NULL, 0, '2026-09-08 11:01:05.852+05:30', 0, 'INV-2026-00005', 10904, 404);
INSERT INTO public.invoices VALUES ('9e873cb4-d529-4bc5-bb77-8b434111c292', '11111111-1111-1111-1111-111111111111', '1085cebe-ebf0-4804-83f3-aae6d0d4a7c9', 'INV-2026-00006', 77075, 3575, 0, NULL, 0, '2026-09-08 11:10:47.886+05:30', 0, 'INV-2026-00006', 77075, 3575);
INSERT INTO public.invoices VALUES ('08833b1a-757e-4ef3-b732-584422c3a2cf', '11111111-1111-1111-1111-111111111111', 'e7d4d6cf-4838-43bd-8334-688d11302496', 'INV-2026-00007', 116025, 5525, 0, NULL, 0, '2026-09-08 11:17:50.431+05:30', 0, 'INV-2026-00007', 116025, 5525);
INSERT INTO public.invoices VALUES ('074fa7fb-80a3-4a98-b2f2-291abd0a520f', '11111111-1111-1111-1111-111111111111', 'b101f725-9679-4cf3-9f0f-16adb200ecff', 'INV-2026-00008', 3150, 150, 0, NULL, 0, '2026-09-09 12:45:00.454+05:30', 0, 'INV-2026-00008', 3150, 150);
INSERT INTO public.invoices VALUES ('b9fae84e-6a5d-4acc-99bf-de7856276f85', '11111111-1111-1111-1111-111111111111', '76692730-cd05-45cd-b8ad-9cc20ac9fc5a', 'INV-2026-00009', 7350, 350, 0, NULL, 0, '2026-09-09 12:47:11.539+05:30', 0, 'INV-2026-00009', 7350, 350);
INSERT INTO public.invoices VALUES ('3fd7fc93-20ab-45db-a445-930859ef7220', '11111111-1111-1111-1111-111111111111', '0602cb47-3398-4ba0-b5da-87e23909efa3', 'INV-2026-00010', 534975, 25475, 0, NULL, 0, '2026-09-09 12:51:03.258+05:30', 0, 'INV-2026-00010', 534975, 25475);
INSERT INTO public.invoices VALUES ('82666aab-ab3e-46dc-8202-c46dbe172bbd', '11111111-1111-1111-1111-111111111111', '2d4b655e-a5bf-4900-ba0c-11e1b3c2685c', 'INV-2026-00011', 473025, 22525, 0, NULL, 0, '2026-09-09 14:06:01.119+05:30', 0, 'INV-2026-00011', 473025, 22525);
INSERT INTO public.invoices VALUES ('efcc2d05-90a1-4342-bb09-6445682a11c7', '11111111-1111-1111-1111-111111111111', 'eb13fd97-c972-4447-8a42-898eb545191e', 'INV-2026-00012', 21000, 1000, 0, NULL, 0, '2026-09-09 14:07:07.607+05:30', 0, 'INV-2026-00012', 21000, 1000);
INSERT INTO public.invoices VALUES ('45505a40-e615-4365-864d-6bfb7b43687a', '11111111-1111-1111-1111-111111111111', 'f5d3449d-ce21-48cb-ab01-b41c41a7301c', 'INV-2026-00013', 45675, 2175, 0, NULL, 0, '2026-09-09 14:07:29.939+05:30', 0, 'INV-2026-00013', 45675, 2175);
INSERT INTO public.invoices VALUES ('098aee51-a6b8-48a3-bbf3-d716228e63cf', '11111111-1111-1111-1111-111111111111', '0a746ebb-ff2b-40d1-8d00-5e7652f56006', 'INV-2026-00014', 15225, 725, 0, NULL, 0, '2026-09-09 15:08:54.401+05:30', 0, 'INV-2026-00014', 15225, 725);
INSERT INTO public.invoices VALUES ('446bb6f7-0a03-493d-b5c2-ad4b4a23e330', '11111111-1111-1111-1111-111111111111', '3e1ba9c8-0311-4534-a8d3-fa97b3a4f933', 'INV-2026-00015', 15500, 500, 0, NULL, 0, '2026-09-10 17:17:49.748+05:30', 0, 'INV-2026-00015', 15500, 500);
INSERT INTO public.invoices VALUES ('d90eedba-9d16-489d-ae3e-f97da5d43671', '11111111-1111-1111-1111-111111111111', 'c8387bcf-ab67-44bb-87fb-d67f6d7601ca', 'INV-2026-00016', 17600, 600, 0, NULL, 0, '2026-09-11 12:34:34.919+05:30', 0, 'INV-2026-00016', 17600, 600);
INSERT INTO public.invoices VALUES ('01066545-9c6a-4300-a668-1deef41e785f', '11111111-1111-1111-1111-111111111111', '27f9f630-3e8b-4ba9-b4d7-e631e45182f7', 'INV-2026-00017', 10250, 250, 0, NULL, 0, '2026-09-11 12:35:19.697+05:30', 0, 'INV-2026-00017', 10250, 250);
INSERT INTO public.invoices VALUES ('2b528276-aacf-45e9-9ff5-5d42d5a2ae90', '11111111-1111-1111-1111-111111111111', '4a4e9d6c-a797-4b03-9835-a44526c890e2', 'INV-2026-00018', 17600, 600, 0, NULL, 0, '2026-09-12 15:32:01.714+05:30', 0, 'INV-2026-00018', 17600, 600);
INSERT INTO public.invoices VALUES ('979cfd33-f35f-4d08-8275-d9f3bb183494', '11111111-1111-1111-1111-111111111111', 'abaed738-9e4f-4470-ae04-031b3baa4721', 'INV-2026-00019', 19050, 750, 0, NULL, 0, '2026-09-12 16:05:47.983+05:30', 0, 'INV-2026-00019', 19050, 750);
INSERT INTO public.invoices VALUES ('4a6650c9-347f-495e-9852-96645e27ad5b', '11111111-1111-1111-1111-111111111111', '8139a10d-c414-4402-818c-ea00cfd5e786', 'INV-2026-00020', 18900, 900, 0, NULL, 0, '2026-09-12 16:21:52.115+05:30', 0, 'INV-2026-00020', 18900, 900);
INSERT INTO public.invoices VALUES ('515bd541-753d-47d2-9b4f-57716c895c1c', '11111111-1111-1111-1111-111111111111', '547361f1-ab65-4eeb-b5ae-790378f1eebc', 'INV-2026-00021', 8925, 425, 0, NULL, 0, '2026-09-12 16:22:52.523+05:30', 0, 'INV-2026-00021', 8925, 425);


--
-- Data for Name: item_availabilities; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.item_availabilities VALUES ('6eee899c-9828-4524-a847-2c1b0b887077', '67315042-c687-4cbb-b45a-f4ea4efc199f', '1048c560-86bd-45c5-b872-eb5e802c6e46', true, 50, 1, '2026-09-02 16:21:33.923+05:30');
INSERT INTO public.item_availabilities VALUES ('581303da-96dd-44d5-ba84-ac141956931f', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'c4945f10-ab36-4a6a-8388-0a0c4904d9da', true, 35, 1, '2026-09-02 16:21:33.932+05:30');
INSERT INTO public.item_availabilities VALUES ('c0f83988-5285-4f76-93e0-a3213d9ebc74', '67315042-c687-4cbb-b45a-f4ea4efc199f', '7455214f-4d3e-495e-a9eb-9a13cda64003', true, 40, 1, '2026-09-02 16:21:33.94+05:30');
INSERT INTO public.item_availabilities VALUES ('b70afaab-0684-4497-b8aa-d63dc8c0a7a2', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'c1f09997-5bb1-4ee9-abb6-9b622c2c8e91', true, 100, 1, '2026-09-02 16:21:33.947+05:30');
INSERT INTO public.item_availabilities VALUES ('eb44adad-8cfb-4eb8-ac26-272bd9708605', '2a543c3c-066f-4097-833a-df7c25700580', '99e5ec8f-c83a-4fa8-94d7-912ea45e2b74', true, 50, 1, '2026-09-02 16:33:25.849+05:30');
INSERT INTO public.item_availabilities VALUES ('6a0ea54c-8e47-4454-b175-aaa02e844a6e', '2a543c3c-066f-4097-833a-df7c25700580', 'beef07d4-c730-41b8-bf0b-651379e91f92', true, 60, 1, '2026-09-02 16:33:25.862+05:30');
INSERT INTO public.item_availabilities VALUES ('6a624326-6a8f-4396-a939-efff563c091d', '2a543c3c-066f-4097-833a-df7c25700580', 'f9e508d5-3525-46d0-bff7-371f448c108c', true, 40, 1, '2026-09-02 16:33:25.869+05:30');
INSERT INTO public.item_availabilities VALUES ('19073fd4-897d-4b79-a90f-491ff8bc833a', '2a543c3c-066f-4097-833a-df7c25700580', '7699dcd7-bf39-4f90-9dfc-c9751ab561ba', true, 45, 1, '2026-09-02 16:33:25.878+05:30');
INSERT INTO public.item_availabilities VALUES ('b00e1ceb-7a17-4f85-847b-8cbaad5beee3', '2a543c3c-066f-4097-833a-df7c25700580', '8613e431-dc51-4c61-9bab-bdf518502c06', true, 50, 1, '2026-09-02 16:33:25.885+05:30');
INSERT INTO public.item_availabilities VALUES ('3ec12d7f-d446-45d2-87bc-d428d07c0c5e', '2a543c3c-066f-4097-833a-df7c25700580', '124c76f8-7ab2-48ab-9a2a-884ec6134578', true, 50, 1, '2026-09-02 16:33:25.894+05:30');
INSERT INTO public.item_availabilities VALUES ('93ce9a5f-e694-4f2b-8e55-5a826be3ad4b', '2a543c3c-066f-4097-833a-df7c25700580', '3d186c5c-8df7-4f8a-9233-3efa0c713df2', true, 50, 1, '2026-09-02 16:33:25.902+05:30');
INSERT INTO public.item_availabilities VALUES ('d6e061da-fb9a-4e52-aade-20dd0fe28c58', '2a543c3c-066f-4097-833a-df7c25700580', 'dea644c5-2503-44fd-8da7-661d929ec929', true, 35, 1, '2026-09-02 16:33:25.911+05:30');
INSERT INTO public.item_availabilities VALUES ('bdc38dd0-cb71-44c9-a071-098e18047782', '2a543c3c-066f-4097-833a-df7c25700580', '499397a7-8028-49ab-9884-4cf4784a9094', true, 20, 1, '2026-09-02 16:33:25.92+05:30');
INSERT INTO public.item_availabilities VALUES ('734380ea-72e6-443b-a9ce-dfb017fa8991', '2a543c3c-066f-4097-833a-df7c25700580', '6d626d6f-915f-43a7-887e-8c3d3c637355', true, 30, 1, '2026-09-02 16:33:25.927+05:30');
INSERT INTO public.item_availabilities VALUES ('621d8081-0161-46c6-856c-f7dee5c9d888', '2a543c3c-066f-4097-833a-df7c25700580', 'b345f6a0-75ab-48d4-a918-3f4b3652b27c', true, 40, 1, '2026-09-02 16:33:25.934+05:30');
INSERT INTO public.item_availabilities VALUES ('581cd2de-57ed-4e77-b305-10dacfbf3cb5', '2a543c3c-066f-4097-833a-df7c25700580', 'd79e8ac8-4c76-4b15-bb79-fc71e716af9f', true, 30, 1, '2026-09-02 16:33:25.942+05:30');
INSERT INTO public.item_availabilities VALUES ('ef0d7cca-14b4-4d00-9eaa-a2d914a9565d', '2a543c3c-066f-4097-833a-df7c25700580', 'ffa8145b-957b-4f83-9c66-ec0b84674310', true, 100, 1, '2026-09-02 16:33:25.949+05:30');
INSERT INTO public.item_availabilities VALUES ('6f7545b1-48e9-4fab-8b57-183d470fbbe3', '2a543c3c-066f-4097-833a-df7c25700580', '608501cf-0f05-41a6-86a1-0df6d54f146e', true, 100, 1, '2026-09-02 16:33:25.957+05:30');
INSERT INTO public.item_availabilities VALUES ('f6444440-b152-48cb-a0bc-c8567e61baac', '2a543c3c-066f-4097-833a-df7c25700580', '88c549e3-63bb-4a66-88fa-743997855717', true, 40, 1, '2026-09-02 16:33:25.964+05:30');
INSERT INTO public.item_availabilities VALUES ('6a569df9-e219-4a09-8a12-bd94dcc0d5c5', '2a543c3c-066f-4097-833a-df7c25700580', '48f122f5-022a-4b4e-a4ae-c9ff954f41c8', true, 35, 1, '2026-09-02 16:33:25.971+05:30');
INSERT INTO public.item_availabilities VALUES ('209d15e7-6f51-447f-bccd-46bdd5fc2d85', '2a543c3c-066f-4097-833a-df7c25700580', '298d92b7-7b6d-43f5-9532-3d0da9c83604', true, 35, 1, '2026-09-02 16:33:25.979+05:30');
INSERT INTO public.item_availabilities VALUES ('d58106fa-4d32-4681-98be-57b1c1b16565', '2a543c3c-066f-4097-833a-df7c25700580', '057eb69f-2f78-41db-8d57-7ea11dce3fc9', true, 30, 1, '2026-09-02 16:33:25.987+05:30');
INSERT INTO public.item_availabilities VALUES ('922c1614-2787-455c-a1e9-346f18d7ae1f', '2a543c3c-066f-4097-833a-df7c25700580', '4ad7b7d4-9d9a-4d41-b60d-a473aa6fb2e2', true, 60, 1, '2026-09-02 16:33:25.995+05:30');
INSERT INTO public.item_availabilities VALUES ('31a2634d-0a02-420e-b049-f41a86529b3a', '2a543c3c-066f-4097-833a-df7c25700580', '5f37b0e5-9c5f-4359-bae7-728cb6b9cd34', true, 60, 1, '2026-09-02 16:33:26.002+05:30');
INSERT INTO public.item_availabilities VALUES ('5eb10b19-184a-4c95-a827-a56fcab4467b', '2a543c3c-066f-4097-833a-df7c25700580', '6716a235-8942-48aa-bb11-b43092d4d2f5', true, 25, 1, '2026-09-02 16:33:26.012+05:30');
INSERT INTO public.item_availabilities VALUES ('527917f1-948e-459b-9d09-8465b138b508', '2a543c3c-066f-4097-833a-df7c25700580', '84948cf5-ebb2-447b-9b5f-2a6bf5c563aa', true, 30, 1, '2026-09-02 16:33:26.021+05:30');
INSERT INTO public.item_availabilities VALUES ('cc0d34ac-081a-4588-a146-4817aae4d5b4', '2a543c3c-066f-4097-833a-df7c25700580', 'b38345b1-ee47-4809-988b-f660f8885eae', true, 25, 1, '2026-09-02 16:33:26.029+05:30');
INSERT INTO public.item_availabilities VALUES ('00fde357-1c16-4d0a-a1aa-d744a4b5518f', '2a543c3c-066f-4097-833a-df7c25700580', 'b9e284ff-8969-494d-a659-fbb5a9354664', true, 100, 1, '2026-09-02 16:33:26.037+05:30');
INSERT INTO public.item_availabilities VALUES ('bd5f6ac2-93e4-4259-8a77-e0c9ae77bfd1', '2a543c3c-066f-4097-833a-df7c25700580', 'd8b50247-153e-4208-9839-6bd10bbca253', true, 100, 1, '2026-09-02 16:33:26.045+05:30');
INSERT INTO public.item_availabilities VALUES ('551b12cf-e76b-4e0e-ab7f-21dbfc10c98d', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'cdc12a71-3f32-4630-ab8b-059ae196af2c', true, 100, 1, '2026-09-02 17:59:34.85307+05:30');
INSERT INTO public.item_availabilities VALUES ('8d481c37-e828-4959-ae0d-5a4a381e5c56', '11111111-1111-1111-1111-111111111111', '094b3d75-f087-476a-863b-a70da76e2365', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('9c202ccd-6443-49d2-b78e-1f2aaae24438', '67315042-c687-4cbb-b45a-f4ea4efc199f', '32867c6e-e19a-4228-a96d-af1b439beb9b', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('fb5d0410-72ef-45ba-a299-56126a0fe84c', '11111111-1111-1111-1111-111111111111', 'f2961923-6d3d-453d-b80e-6820041126a5', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('7535edca-e90d-4ba6-85f4-f26abaf54962', '11111111-1111-1111-1111-111111111111', 'df736215-5b84-49ce-bbfc-3d644d9a5401', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('225acb2a-261d-4b0c-abfd-5bb826b57e73', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'cb01246c-8e64-409b-bbb8-d63139e6ac6b', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('32269353-bb0c-46a1-b6ff-3e7bbe755979', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'c8fcdcb4-5630-46dd-aecf-f1d910a52ff8', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('b836faa8-0632-4946-a409-2a15d05b3763', '67315042-c687-4cbb-b45a-f4ea4efc199f', '3e079d26-b636-48bc-ad6f-68e117c7826d', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('5ac39823-75f6-45a8-8c33-d26fe243ef92', '11111111-1111-1111-1111-111111111111', '0020780f-7112-4804-a81b-2e06a91cdaa4', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('d55a27a2-b790-4626-9fe8-13437938b89c', '11111111-1111-1111-1111-111111111111', '2c28152b-2d3a-4796-ac1f-aa04d783f921', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('ba337f94-fdb4-4746-a9a4-ec487cf94529', '11111111-1111-1111-1111-111111111111', '2ddb7944-4e83-4dda-99de-94dd5e83bb77', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('7688cb95-aa99-48de-9b2b-1d4eba7c344c', '11111111-1111-1111-1111-111111111111', '4c59714c-7d6c-4d24-87c9-b4bb91f3c923', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('cd814738-93f1-41f7-be94-40e4880c5415', '11111111-1111-1111-1111-111111111111', '4dd53b01-9b00-47a6-9537-6ccab7fc12e8', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('89b14f34-6ea1-457d-9779-2b5028d2ebea', '67315042-c687-4cbb-b45a-f4ea4efc199f', '5d8449d6-24c6-43dd-b73e-4a1fb8860644', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('12deca89-e58e-4748-a0a5-9a53d06e7ceb', '11111111-1111-1111-1111-111111111111', '640584ad-7f9e-4a1b-8740-290fd382ea81', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('a41d2441-924e-4edd-8a7c-03110a86a3b6', '11111111-1111-1111-1111-111111111111', '4a8d3fad-d0e2-4c19-8840-9ef706f90b7b', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('9d9bbac4-508e-46b5-96ad-2bb91e89e224', '67315042-c687-4cbb-b45a-f4ea4efc199f', '6e275671-eb4e-43e2-8562-65053ed3b8e6', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('46815daf-77c0-42c2-9eac-76eb6e4f9c7b', '11111111-1111-1111-1111-111111111111', '7e1e6434-2ee4-428b-aafc-05be27e770d9', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('87c6f929-d926-41cb-8a6e-dc183e9db1c4', '2a543c3c-066f-4097-833a-df7c25700580', '09b87cbe-453a-418f-88dc-841b6c78b4a8', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('476c228e-9841-422f-a9b8-516c6e123a7c', '67315042-c687-4cbb-b45a-f4ea4efc199f', '95d022d5-47ec-4b38-9565-daabe33866a1', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('f350735a-793a-438c-926f-8092e89e41a5', '11111111-1111-1111-1111-111111111111', '88edfc29-cdb9-469b-afda-bbb322f0a168', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('40c404ac-3fd1-4039-87de-43b78cf1bef6', '11111111-1111-1111-1111-111111111111', '88ec151b-ebde-4993-809f-79f7e29a4385', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('20c79ba8-483f-40ca-ae64-5d74421180b7', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'ce830a66-2777-49d8-b62e-6fb860b9ac05', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('50970394-3422-4ede-9f93-c3818dfba647', '67315042-c687-4cbb-b45a-f4ea4efc199f', '14abe1aa-b258-4201-a995-8eed18df3bcc', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('47600ece-7601-4228-b75d-4b7f184a60e7', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'c97c9587-1c8d-4421-abc4-65e15db4bc81', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('6f223923-20e3-4d5f-9107-f468b0efc449', '67315042-c687-4cbb-b45a-f4ea4efc199f', '8772f56e-a632-4998-ae87-45084349bf9f', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('d0696ce4-c81b-481d-a4b1-5bc217cb08bf', '11111111-1111-1111-1111-111111111111', 'e0ffcd03-52ae-497b-9e57-1411888fde4f', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('dc1bcf11-8a25-4eab-a48f-0d43ca966e2d', '2a543c3c-066f-4097-833a-df7c25700580', '1408068a-d60c-421b-8da4-76bf4c399c84', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('e9b68356-32ba-4fe5-a0f6-779affc8fec0', '67315042-c687-4cbb-b45a-f4ea4efc199f', '7f133d9e-7d22-4f2e-ad79-1fd89f07a1f5', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('b6148dbb-5239-4bb9-94ca-cc41f408cb78', '67315042-c687-4cbb-b45a-f4ea4efc199f', '25dc14b6-0f77-44e7-9db7-2c6e5fd00ebb', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('f154c7a4-42b9-4e50-b9aa-5dcebee6c5be', '11111111-1111-1111-1111-111111111111', 'b9be06d0-6f21-4d05-8914-74e41818650e', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('eedb8c78-9533-4753-a06f-5ef6715b341e', '67315042-c687-4cbb-b45a-f4ea4efc199f', '9e6b5249-048d-4aeb-a0b6-acfd8f6a8501', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('ba04b96e-bc9d-4d6a-b7d9-19e070d3ba7a', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'eba83b97-1716-4073-bd57-2eef05c144c5', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('8a127503-5bfa-4de2-accf-fc8f5d3290f1', '67315042-c687-4cbb-b45a-f4ea4efc199f', '9b35f954-5201-48ea-9e2a-174dbb083352', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('a3c6193b-cdb5-4b29-a31b-854740e24758', '2a543c3c-066f-4097-833a-df7c25700580', 'b61b7134-ec44-409a-924b-b01ecd973144', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('58db4b20-2a84-4a74-a39b-0692e5423cd0', '11111111-1111-1111-1111-111111111111', '431e1ef5-1ef0-4ee9-acb8-4f406246c92a', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('ee1c79db-ceff-4768-803b-0e53d118f030', '11111111-1111-1111-1111-111111111111', 'a7cf73dc-f5df-497b-a326-5fe2e49af224', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('265dffad-9d44-427b-83fb-86fb607f2dd1', '67315042-c687-4cbb-b45a-f4ea4efc199f', '81f170e9-ad77-44a9-b8dc-7a7d4a2b84cc', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('39af9d17-6715-48c6-b0a4-fe356502d2cf', '11111111-1111-1111-1111-111111111111', '5101522a-081e-4866-9f74-261854fe4404', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('01b7cbb8-85df-4c09-a1eb-98d29b977f8a', '11111111-1111-1111-1111-111111111111', '305951b9-bbbd-4bcd-a93a-01aa60742934', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('a6e252f1-748a-48a7-9b96-2c210929ab16', '11111111-1111-1111-1111-111111111111', 'e286dcdc-8100-430d-967e-6edba83f1609', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('e827ff02-46bb-47b2-88cd-325250b1922c', '67315042-c687-4cbb-b45a-f4ea4efc199f', '4d74432b-7997-4b05-96c7-cb331127b3ca', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('8885c59d-bab4-4f8b-b224-909a5dceb61e', '11111111-1111-1111-1111-111111111111', 'fd632cf0-e4df-4fb7-b0ec-f6e64f852405', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('a821d195-80ac-49b5-bc95-542bbd1ea8e1', '11111111-1111-1111-1111-111111111111', '5d13a97e-027a-445b-94eb-2f00546b1614', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('efd568b1-9bf0-4a35-aef5-e3b52431f72c', '67315042-c687-4cbb-b45a-f4ea4efc199f', '972a52a2-10f6-42ec-bd50-45cee9cd3c14', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('8da95b91-7ae7-47e3-a178-15abfe753857', '11111111-1111-1111-1111-111111111111', '0f4bef83-2c0d-4c19-9d07-ce7f564fc589', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('98893eaf-e059-4f6f-adb5-1f2cb4d3aae4', '67315042-c687-4cbb-b45a-f4ea4efc199f', '6147b9f5-53bb-4989-9f55-c0cce14398c0', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('df577e5f-ea74-4609-ba99-ae5b731dcefc', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'd4062c49-deb2-4a8b-a14f-7f594e1d61b0', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('d602bbbe-5fe0-4cb7-91f5-45e686c20ea7', '11111111-1111-1111-1111-111111111111', 'b45529e4-72e8-4c01-aed9-3106f2da6aeb', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('d98b22c5-5243-4ecc-9f71-2d3d832414b8', '11111111-1111-1111-1111-111111111111', 'd96136d0-d5ba-4152-814c-3aea49b3079e', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('3216e816-61c3-4945-b688-f98b2d8a51a3', '2a543c3c-066f-4097-833a-df7c25700580', '072c26c3-7552-494a-9eb4-bcc5dd7d2a22', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('47863229-272d-4427-98ba-f68596aa0d53', '2a543c3c-066f-4097-833a-df7c25700580', '00d0d8e1-c2a5-4deb-a0a5-da1a1ca24683', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('8657f916-0a5b-4122-9e1c-a7b3d4a06bc5', '11111111-1111-1111-1111-111111111111', '9e27f8db-5ca3-4d7f-97d4-aa3d87642452', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('f7cf7479-a041-4d5b-b79a-ae1658fbe4ac', '67315042-c687-4cbb-b45a-f4ea4efc199f', '47dce856-d45e-41a3-a7de-84a823aa6d5a', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('36d94106-9c6c-4d8c-8535-242799e7b6ea', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'b66072c9-672f-4a07-ae41-bd506f60d505', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('44f7dabb-4783-4203-a502-b73591d4a788', '67315042-c687-4cbb-b45a-f4ea4efc199f', '7cdd0470-02f3-4aef-a744-d1742a7a8825', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('b38aa0f0-1d7d-4c28-b70c-ac78b428f155', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'b16d099e-1e0c-4bbf-8c9b-8e6a8414f4ae', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('c6ec0727-15b9-4d6c-97e8-bbf1e5af0d07', '11111111-1111-1111-1111-111111111111', '49768e80-5cf1-47a9-be73-5f24de6fb26e', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('3946a3ab-4353-49af-ba86-eb8262ec32e5', '11111111-1111-1111-1111-111111111111', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('b3c805e4-ea71-4b38-9f1b-5cdb399fcb61', '11111111-1111-1111-1111-111111111111', '71451535-8d85-417f-b0ec-3f2b87016045', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');
INSERT INTO public.item_availabilities VALUES ('eed41255-3d08-4037-91eb-7516406b7074', '11111111-1111-1111-1111-111111111111', '29b7f4be-ba96-4de7-a268-6248985e12b1', true, 100, 1, '2026-09-05 13:03:58.83811+05:30');


--
-- Data for Name: item_availability; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.item_availability VALUES ('4bf72aed-574e-4267-ab0d-4336b2bc145e', '11111111-1111-1111-1111-111111111111', '8fe74946-54cc-4f68-ae82-5f775ef44b20', '11111111-1111-1111-1111-111111111111', 'ON', 3, '2026-09-08 11:27:28.198+05:30', '2026-09-08 11:27:30.98+05:30', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', 100);
INSERT INTO public.item_availability VALUES ('39e85f55-d19d-48ce-a756-2faecb9d4914', '67315042-c687-4cbb-b45a-f4ea4efc199f', '1048c560-86bd-45c5-b872-eb5e802c6e46', 'fd002d2b-3ba9-456e-bd66-5479c535612f', 'OFF', 5, '2026-09-05 16:45:42.225+05:30', '2026-09-11 14:19:07.517187+05:30', '918df673-2606-403a-9fad-1c54870d1fce', NULL, 97);
INSERT INTO public.item_availability VALUES ('9d2a5fab-5783-456b-a69b-a7f24d399276', '67315042-c687-4cbb-b45a-f4ea4efc199f', '1048c560-86bd-45c5-b872-eb5e802c6e46', 'ec610d2c-357c-4945-a383-5f734846d834', 'OFF', 5, '2026-09-05 16:45:42.233+05:30', '2026-09-11 14:19:07.517187+05:30', '918df673-2606-403a-9fad-1c54870d1fce', NULL, 97);
INSERT INTO public.item_availability VALUES ('f7d26cf2-8893-40d1-b829-7b60ccdd2bc6', '11111111-1111-1111-1111-111111111111', '49768e80-5cf1-47a9-be73-5f24de6fb26e', '11111111-1111-1111-1111-111111111111', 'ON', 29, '2026-09-09 12:48:24.641345+05:30', '2026-09-11 14:24:19.934373+05:30', NULL, NULL, 45);
INSERT INTO public.item_availability VALUES ('6e25ae05-c8f3-4ae7-9a95-cdcab22b33d9', '11111111-1111-1111-1111-111111111111', '5101522a-081e-4866-9f74-261854fe4404', '11111111-1111-1111-1111-111111111111', 'ON', 5, '2026-09-09 14:35:45.660191+05:30', '2026-09-11 16:39:37.883095+05:30', NULL, NULL, 94);
INSERT INTO public.item_availability VALUES ('95875871-d444-4cac-8bef-20f47cf577be', '11111111-1111-1111-1111-111111111111', '4a8d3fad-d0e2-4c19-8840-9ef706f90b7b', '11111111-1111-1111-1111-111111111111', 'ON', 8, '2026-09-09 13:03:37.688722+05:30', '2026-09-12 16:04:39.718918+05:30', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, 48);
INSERT INTO public.item_availability VALUES ('4c96fcec-35d3-4367-ad59-0d9491e5da01', '11111111-1111-1111-1111-111111111111', '5d13a97e-027a-445b-94eb-2f00546b1614', '11111111-1111-1111-1111-111111111111', 'ON', 1, '2026-09-12 16:20:51.921372+05:30', '2026-09-12 16:20:51.921372+05:30', NULL, NULL, 99);
INSERT INTO public.item_availability VALUES ('f77bfd05-ecdc-4eb3-b3b6-64220b2586b1', '11111111-1111-1111-1111-111111111111', '640584ad-7f9e-4a1b-8740-290fd382ea81', '11111111-1111-1111-1111-111111111111', 'ON', 2, '2026-09-12 16:20:51.936795+05:30', '2026-09-12 16:22:09.545081+05:30', NULL, NULL, 98);
INSERT INTO public.item_availability VALUES ('5fc60094-c7b4-4464-a969-bb64067345ea', '11111111-1111-1111-1111-111111111111', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', '11111111-1111-1111-1111-111111111111', 'OFF', 53, '2026-09-09 12:44:25.655994+05:30', '2026-09-09 14:27:26.260382+05:30', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, 0);
INSERT INTO public.item_availability VALUES ('ecde4661-f2c0-4ca3-91fa-455a70442ac8', '11111111-1111-1111-1111-111111111111', 'd4d5c11d-7ca8-4f1f-9784-45b39bd6ef7c', '11111111-1111-1111-1111-111111111111', 'ON', 1, '2026-09-12 16:37:34.155968+05:30', '2026-09-12 16:37:34.155968+05:30', NULL, NULL, 99);
INSERT INTO public.item_availability VALUES ('86c3a1a9-3e53-4f65-8ddf-dc58609db487', '11111111-1111-1111-1111-111111111111', '2ddb7944-4e83-4dda-99de-94dd5e83bb77', '11111111-1111-1111-1111-111111111111', 'ON', 1, '2026-09-12 16:37:34.162056+05:30', '2026-09-12 16:37:34.162056+05:30', NULL, NULL, 99);
INSERT INTO public.item_availability VALUES ('8f01c088-2741-42a5-9de0-117355878c30', '11111111-1111-1111-1111-111111111111', '71451535-8d85-417f-b0ec-3f2b87016045', '11111111-1111-1111-1111-111111111111', 'ON', 3, '2026-09-12 16:04:39.73076+05:30', '2026-09-12 16:40:24.209666+05:30', NULL, NULL, 96);


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

INSERT INTO public.kot_items VALUES ('e6e509e7-2af5-42c6-beb7-3d5e93e93ec1', '2464b135-bbe4-4f70-b8e9-e8ec09e036bb', '1048c560-86bd-45c5-b872-eb5e802c6e46', 2, NULL, NULL, NULL, '1e52c5d3-8676-4aff-8aa4-2832b1212976', '67315042-c687-4cbb-b45a-f4ea4efc199f', NULL, NULL);
INSERT INTO public.kot_items VALUES ('22572a00-7130-40f3-ad7b-35f1c5088d4e', '1a483a59-4b70-4a21-a78c-e4566f492aa7', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 1, NULL, 'STARTER', NULL, '7a7080c6-7647-4996-a6cd-586f5613338b', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('7585377e-ba9b-4352-bbf6-e94170efb080', '80f4fd60-0398-4b9a-b31c-ee251b10bebc', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 2, NULL, 'STARTER', '2026-09-03 14:45:23.359+05:30', '13f81108-0d71-497a-8c59-fb2c9cff2f79', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('4d6fdfed-ebba-4bf3-a557-ed3d1acf6af7', '7ac440d2-529b-4a22-80da-07c102b52bcd', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 1, NULL, 'STARTER', '2026-09-04 00:40:27.996+05:30', '39232e63-b520-40d1-8382-802fb32cd741', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('f80fbb22-c3b1-43c0-a2a2-ea78487163ad', 'd0e620ed-a0fc-4793-a60e-0eee6f19dd09', '2ddb7944-4e83-4dda-99de-94dd5e83bb77', 1, NULL, 'STARTER', '2026-09-04 00:40:29.297+05:30', 'a9c5759c-98c5-4e33-a8dc-e558deae6d28', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('7221654f-5060-4b75-b4cd-654ea1dc512e', '476f5980-0930-496c-8c4a-9eaf395a75cf', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 1, NULL, 'STARTER', '2026-09-04 00:43:39.248+05:30', '83af21bb-0221-4d95-b9c3-7c3261a4dfac', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('80353e30-fab0-447c-ac67-d3d498fa7cb5', 'aaeb22ca-77d9-4125-93fb-ffaddabfd1ab', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 1, NULL, 'STARTER', '2026-09-04 00:43:39.847+05:30', '025735c2-f199-4819-a694-73b1b678ed09', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('73c2cc87-61c1-4523-93f1-a68297402475', '780db29f-b971-4fb9-a7c4-e45ad3fe81f4', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 1, NULL, 'STARTER', '2026-09-04 00:43:40.456+05:30', '9c79b32c-196b-4a2d-bd1f-0c7aa4a96a5b', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('9818587f-8369-44f5-8da0-1dfe437a2523', '314f59d3-358c-4d0d-82ce-e2348b2f5869', '9e27f8db-5ca3-4d7f-97d4-aa3d87642452', 1, NULL, 'STARTER', '2026-09-04 00:43:46.594+05:30', '2ac5255a-707d-4147-904d-96a126ba13b3', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('534280bb-ef87-459c-85d4-26b250759bd2', 'f72e5dc0-f56e-451b-a014-cd4419cacbdf', '9e27f8db-5ca3-4d7f-97d4-aa3d87642452', 1, NULL, 'STARTER', '2026-09-04 00:44:05.583+05:30', 'ffe3d2a6-2bcf-4f51-96b0-958fc529e51e', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('3efb9ab9-5995-4262-80da-90e4c804df3e', '9a5c4cc8-4b11-4022-b5c1-6d4bedb3b01b', '71451535-8d85-417f-b0ec-3f2b87016045', 1, NULL, 'STARTER', '2026-09-04 01:06:00.055+05:30', '8b8157f3-0319-41be-a36d-87ed1df95c5f', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('9fcae176-24ee-423f-a14d-fc84a7e27882', '9a5c4cc8-4b11-4022-b5c1-6d4bedb3b01b', '4a8d3fad-d0e2-4c19-8840-9ef706f90b7b', 1, NULL, 'STARTER', '2026-09-04 01:06:00.055+05:30', 'd01fed96-5b0c-4732-b314-b81a54946dce', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('2ca6e57f-eba9-4473-b22d-73a5f567c9e0', 'e0c7eff8-6e10-43b7-bc2a-9be10a9a091b', '094b3d75-f087-476a-863b-a70da76e2365', 1, NULL, 'STARTER', '2026-09-05 13:20:37.737+05:30', 'a09767f3-e815-483d-aff9-8d334baff511', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('c5079952-c2fc-4e12-b559-20722abdeb36', '38d4de12-7ca2-48b6-8856-15027f1d154b', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 1, NULL, 'STARTER', NULL, '03d3bde6-a0d7-48d9-abef-c298fbbb36fb', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('21f6d661-af3a-4424-8e1a-d71628d08a51', '022f9506-96ce-4851-b531-11b374d9f3eb', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 1, NULL, NULL, NULL, '60295abb-8a59-4a0f-97e8-b32182500594', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('64a37ac6-9961-4003-9786-e5f2e2401cff', '1a8d8383-c9bc-481e-8700-176bf3b7c38b', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 1, NULL, NULL, '2026-09-05 16:23:36.487+05:30', 'e757b52b-9567-44bd-a492-3bb3519b4cb5', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('50e6fe5b-6e22-4404-bbe2-8af2cce8ab32', '187ed388-52c9-4d73-bfa6-e4f96d3f8f51', '1048c560-86bd-45c5-b872-eb5e802c6e46', 1, NULL, NULL, NULL, 'e33ec171-252d-4f6b-acac-694e76f4bf53', '67315042-c687-4cbb-b45a-f4ea4efc199f', NULL, NULL);
INSERT INTO public.kot_items VALUES ('d2cd6754-42c2-4633-915d-b1f2f0815891', '5d32816c-fd4d-4bb9-8a24-2180b08fa1b8', '7e1e6434-2ee4-428b-aafc-05be27e770d9', 1, NULL, NULL, NULL, 'f497179e-87b0-4f64-8408-05071bc7a8ff', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('b3ce6171-b946-42d5-bde0-94418d8ab34a', '4a1fae02-9a34-4e15-a9b9-bcd4df784612', '4a8d3fad-d0e2-4c19-8840-9ef706f90b7b', 1, NULL, 'STARTER', NULL, 'f0971839-9aef-47e4-9c3d-2cf44ce82eaf', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('b20936cc-e9d9-4d1c-9fe4-b7a9ba1a121e', '91c40700-9ebf-4753-b454-24ddf11da7f9', '88ec151b-ebde-4993-809f-79f7e29a4385', 1, NULL, 'STARTER', '2026-09-08 11:05:57.593+05:30', 'de62921f-d4dc-4fea-a8f4-56fe8b04f116', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('cc3c6b24-f611-411b-816c-793908c7b8b0', 'a05cc85f-571d-457d-8fb9-2736dd584304', '094b3d75-f087-476a-863b-a70da76e2365', 2, NULL, 'STARTER', '2026-09-08 11:09:26.513+05:30', '9c5395eb-db1c-48f8-803a-f011a251c77a', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('67b40c6b-60eb-43df-84e4-84e68345fa27', '6263318d-e12b-43cf-9c36-9ee3f17e597e', '094b3d75-f087-476a-863b-a70da76e2365', 3, NULL, 'STARTER', '2026-09-08 11:12:15.009+05:30', '18ec13cb-0674-4f07-b06a-166a80d9c6b7', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('66313cd8-c9be-4459-993a-a26ec952d272', '00089db3-43f2-4348-bbff-da57724bc4eb', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 1, NULL, NULL, '2026-09-08 13:11:42.266+05:30', '9bc19328-1e90-4001-8205-a2f448775c76', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('34be4c9b-f39f-48df-bacc-8ca87996731c', '00089db3-43f2-4348-bbff-da57724bc4eb', '9e27f8db-5ca3-4d7f-97d4-aa3d87642452', 1, NULL, NULL, '2026-09-08 13:11:42.266+05:30', 'f4a218ac-99e4-48cf-b6e1-60afc00828c5', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('a93334bd-bdf4-4d1e-8bad-b7e59cc12261', '2b9b7a79-3fc2-4a24-ab97-ff472596e66b', 'd4d5c11d-7ca8-4f1f-9784-45b39bd6ef7c', 1, NULL, 'STARTER', NULL, 'ae1afbe0-fd20-4f80-973b-bf1ca6b3c498', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('6d85f00f-02c0-4c89-92ab-7867405637dd', '2b9b7a79-3fc2-4a24-ab97-ff472596e66b', '8fe74946-54cc-4f68-ae82-5f775ef44b20', 1, NULL, 'STARTER', NULL, 'e692ea73-ba2b-457b-a326-3baee8941065', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('2819bbd5-1ff9-4ad1-8d5e-4a8fb4e986f8', '4728ca77-caa1-49de-a309-254613a1cad3', '88edfc29-cdb9-469b-afda-bbb322f0a168', 1, NULL, 'STARTER', '2026-09-08 13:15:08.733+05:30', '4994ad24-bebe-49a0-977b-faa12ee5ed46', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('5e36b888-517b-4362-8e8f-7b28986d9ebc', '4728ca77-caa1-49de-a309-254613a1cad3', '8fe74946-54cc-4f68-ae82-5f775ef44b20', 1, NULL, 'STARTER', '2026-09-08 13:15:08.733+05:30', '7189e68a-4aef-4e32-876e-56a9f20a4a9c', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('ecb9c6c5-95a7-432d-983b-26d24b1db7ba', 'd2d5e040-193a-4e9a-ab00-8ba1614f5266', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 1, NULL, 'STARTER', '2026-09-08 14:15:27.39+05:30', 'b80c6285-d018-47a1-9dfa-2e686b8effc3', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('399cfa21-4080-4018-aaf6-4d576d5e22ab', 'c3b2a555-0bb8-4140-aa3b-16a067935d7f', '2c28152b-2d3a-4796-ac1f-aa04d783f921', 1, NULL, NULL, '2026-09-08 14:39:22.764+05:30', '78627a3c-b92a-42d4-adba-b530878b560f', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('0387be19-1616-4c57-89e2-6e592cf8b9ce', '753c5eb7-0772-4082-b9ea-3cbff53d0f1d', '9e27f8db-5ca3-4d7f-97d4-aa3d87642452', 1, NULL, NULL, '2026-09-08 14:44:38.639+05:30', '74a7e192-fc57-4923-8f2f-61dbb363b66f', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('cc560ddc-0b45-4199-9a94-69476f08df6a', '97823311-3165-4981-bb4a-f701b6c54e81', '5d13a97e-027a-445b-94eb-2f00546b1614', 1, NULL, 'STARTER', '2026-09-08 16:19:42.451+05:30', '7ef66626-f4e7-4ebe-a4fe-4e09367d8ab0', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('5a96e410-ea41-495c-b96b-e8113bf69e1d', '97823311-3165-4981-bb4a-f701b6c54e81', 'e286dcdc-8100-430d-967e-6edba83f1609', 1, NULL, 'STARTER', '2026-09-08 16:19:42.451+05:30', 'f89483cf-0d93-4bc0-816a-285a7a13d065', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('412e6b67-94f9-451f-856f-41406da95853', '387bfcae-81d2-4138-b9af-783ed452a554', '4a8d3fad-d0e2-4c19-8840-9ef706f90b7b', 1, NULL, NULL, '2026-09-09 12:45:15.879+05:30', 'a8871109-ffa1-481a-88da-e56804420b05', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('6c30d67d-419c-47b3-a60f-194cb96bd092', 'cde85ae8-efc8-4329-9983-c65db7879821', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 1, NULL, 'STARTER', '2026-09-09 12:50:26.931+05:30', 'e6d644af-1584-467a-863f-bac26eb84d38', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('3f544d82-c035-4dbd-b6f7-962a699ed19d', '4a26f71a-500e-456d-a69b-5dc7529906e8', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 1, NULL, 'STARTER', '2026-09-09 12:50:27.44+05:30', '4c625b81-fece-407d-9b63-dced164b38b1', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('8b2d49c7-c36d-4977-af62-a622897cc5ca', '0d5f81a3-df18-49f4-92ac-ca9b95a7273f', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 90, NULL, 'STARTER', '2026-09-09 12:50:27.705+05:30', '31447489-e6af-4bc5-a132-783f2da200c0', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('04aee199-139b-45d3-baf3-83e9de7d5491', 'da54b04f-218d-441e-91d5-44e74856c1c6', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 5, NULL, 'STARTER', '2026-09-09 12:50:28.165+05:30', 'b755bfc3-dea9-4d8f-b6d1-a7decce5f8be', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('6a6b66ed-0f5b-4351-b7e6-aff8cbeb30ab', '66f4fcaf-d7cd-47ee-b09a-d369f60b44fb', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 1, NULL, 'STARTER', NULL, 'c6fbd83e-75ed-472a-b1bf-2e7889b797f0', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('fc4f4309-0373-41d5-818e-f393e91f6cc9', 'b7760cd0-9b35-44ed-b588-ac6b42eef3d4', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 16, NULL, 'STARTER', NULL, '04e04ddf-bbb4-4e74-ae9e-864aca2029d4', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('d77a5448-2fd9-470b-8e42-78bb7f2ef37a', '4d46fa43-e341-4fe6-9c52-8134a1afafbc', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 32, NULL, 'STARTER', NULL, '4923d9da-bcb2-46da-833a-8b4a037f0436', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('c8fba74b-6b8f-4edd-a93e-3853ed11224d', '35412261-a6db-4503-abb2-74ee5bd5db84', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 3, NULL, NULL, '2026-09-09 13:49:00.591+05:30', 'e2ac9075-4d00-464e-88a2-afe715362121', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('ff26c414-1f79-41ee-83ba-4030622cdfb6', 'd8cf458f-c314-4de9-8fd0-534915e77a5a', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 4, NULL, 'STARTER', '2026-09-09 13:49:01.064+05:30', 'f79c39a2-f114-496c-bf0e-09ac73ddf914', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('7c26ef84-4d6c-4353-9d4b-a5764a983bef', '2ae3bb5c-9171-4f02-8aec-88611bd9216a', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 3, NULL, NULL, '2026-09-09 13:49:01.483+05:30', '03ec0df1-5176-44d6-befb-8477fd240cb0', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('00ad3140-e106-415d-93d3-0b2e6a738d35', '0a8cc3a0-92d2-4f37-b85f-1818a5d433c7', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 3, NULL, NULL, '2026-09-09 13:49:02.055+05:30', '970e6000-56da-419a-9d6c-33afca6265fd', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('921f53cb-270b-43cb-af8f-dba70bd71402', 'e41f4c53-4fb8-467b-b40e-4a53b8479164', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 15, NULL, NULL, '2026-09-09 13:49:02.534+05:30', 'aa746b8b-9705-4520-a5a8-54ab4190f58c', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('a237d746-f068-4781-8b1e-4f99ac5c070c', 'fce3d545-2638-41d6-b6f3-f8a0683e9150', '4a8d3fad-d0e2-4c19-8840-9ef706f90b7b', 3, NULL, NULL, '2026-09-09 13:49:03.038+05:30', '2bf7206e-c6f3-44aa-981c-a457abf6e62a', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('5d812a34-23cb-414a-9aa1-692108697054', 'da6358fd-b56e-4bad-bcc0-0af0ec94b26b', '4a8d3fad-d0e2-4c19-8840-9ef706f90b7b', 15, NULL, NULL, '2026-09-09 13:49:03.609+05:30', 'd07b13ab-7416-45f5-aa50-d4c92edb3536', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('c3b2e9bb-ceaa-48d8-b970-dfdbc3beae50', '39863209-183e-4007-a67f-cf22d00609b9', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 1, NULL, 'STARTER', NULL, '1aa6fbfe-8643-49a5-8246-69a71196a167', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('d7f3d98c-f5fc-48b5-906d-b2c0b663ecf1', '3a8544bd-e646-4dca-a8aa-4451fcfcc675', '5101522a-081e-4866-9f74-261854fe4404', 1, NULL, 'STARTER', NULL, '4803f052-a4cd-4a89-ab6f-74fac3d67772', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('de29917b-9c21-45c6-b1f3-6547f9715dea', '5b4062b9-77fe-4305-b776-65b479de232f', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 1, NULL, 'STARTER', NULL, '2f46c4fc-4fd6-4c9b-a3f8-acdbd42c0594', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('a07954b5-05f9-495c-a351-86303fb1be03', 'e566733f-ccfd-4fa4-b750-c96cde787323', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 1, NULL, 'STARTER', NULL, '582a60f4-534d-4024-88c8-1f56e570f4de', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('08156661-937d-4e01-af49-135b9036b456', '0b2b03d2-b645-49b9-8644-1a36bc48a18a', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 5, NULL, NULL, '2026-09-11 11:09:55.368+05:30', '342243f5-67c3-4f51-a5f7-c6441c0f8058', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('ad9bb36a-9bde-40a8-9742-2337e8095847', '15cb65ba-80c2-48ed-883e-dbeb46d9dcda', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 5, NULL, NULL, '2026-09-11 11:10:05.974+05:30', '8fa479df-4828-4bbd-8781-0445ec6a7a4e', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('cc1ac22f-3284-451f-96e2-fc72755f959e', '2508d470-13d4-4db2-a796-75774ccb80c2', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 5, NULL, NULL, '2026-09-11 11:10:15.591+05:30', '94a171f1-9bff-45e7-b655-9b864a43ec78', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('51b69fec-cc22-4ebb-8ab9-2475a900c975', 'ecb0bac6-06b0-4a59-b4d7-8c2c1686dc67', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 5, NULL, NULL, '2026-09-11 11:10:55.567+05:30', '1d24f99b-b19c-40f1-b8f4-3c9e1222fd40', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('2d4c7351-a7d9-464f-bead-efcd477dd489', 'fc89f774-0dc4-4795-9f68-edd8df66905c', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 5, NULL, NULL, '2026-09-11 11:10:56.509+05:30', 'f1df626b-fc7b-4399-bf69-c2502c895927', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('cd652c55-c14c-4070-8c50-24423d237048', '933f4133-630c-48df-b056-4502946eb0ae', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 5, NULL, NULL, '2026-09-11 11:10:57.332+05:30', 'c00be2b8-881c-4bde-9a46-577c19ea7bc3', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('4c34f9f3-23db-4de5-b479-e4013653542f', '4ff03eac-fde7-4266-96fe-a868df825efd', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 5, NULL, NULL, '2026-09-11 11:10:04.488+05:30', '28791b77-9a0b-4827-8fc3-156591208ce4', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('52578ea1-ae64-4ad0-83d1-544399a1df36', '7c360f83-927b-4dea-9514-b7815a12a4f5', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 1, NULL, 'STARTER', NULL, 'feaf21a6-4ea0-4b99-b0f0-bf197fa7b705', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('01cf6b0f-885f-4a41-bf16-61a99febbc2e', 'a8088c10-855e-46d2-bc70-3b2bda97e583', '5101522a-081e-4866-9f74-261854fe4404', 2, NULL, 'STARTER', '2026-09-11 12:33:47.938+05:30', '5325d83c-f786-4964-bdd3-08acdefa96be', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('846f5e99-b2c9-4572-b1c2-2daefa1159b3', 'd3d5de47-7715-4e5a-9036-ec18153e7a81', '1048c560-86bd-45c5-b872-eb5e802c6e46', 1, NULL, 'MAIN', NULL, '69d4ccbf-020e-45f7-bff8-efdee2f95fb2', '67315042-c687-4cbb-b45a-f4ea4efc199f', NULL, NULL);
INSERT INTO public.kot_items VALUES ('6055603a-f170-419d-aa1d-c2869b15459c', 'a41ba409-8e7a-451d-b1d0-413fb105d4de', '1048c560-86bd-45c5-b872-eb5e802c6e46', 1, NULL, 'MAIN', NULL, 'a5ad1b27-1d4d-4a40-a7f8-1e08026ac3ba', '67315042-c687-4cbb-b45a-f4ea4efc199f', NULL, NULL);
INSERT INTO public.kot_items VALUES ('8e12527b-b38f-4727-b94c-9a70875dc7ec', '63992e13-1fb0-4e62-8a36-596aa86d78ee', '1048c560-86bd-45c5-b872-eb5e802c6e46', 1, NULL, 'MAIN', NULL, '32733e86-926a-421a-86cd-ee6fb9ffb7a0', '67315042-c687-4cbb-b45a-f4ea4efc199f', NULL, NULL);
INSERT INTO public.kot_items VALUES ('0adc51e0-c3f5-441f-a18e-7db6cc59a156', '3d8f581a-fd89-4cf7-9704-3f02a696684e', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 1, NULL, 'STARTER', NULL, '45c18b8d-29a0-4435-98e2-db478e9242f9', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('bdbefb58-43fa-43da-8401-bb1203915056', '81985f31-1b69-4a6a-abf8-6c0a638dcf02', '5101522a-081e-4866-9f74-261854fe4404', 1, NULL, 'STARTER', NULL, '9fa4ac4f-fd3d-4490-9ad1-87bed53a26d7', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('80cbd59e-b8d3-48f4-a84a-e1af81d50463', 'ce6781a5-807c-4628-922f-b4783e87adf0', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 1, NULL, 'STARTER', '2026-09-11 16:21:08.568+05:30', '6d2bb836-3203-4c6c-a2ea-d81d3729a02d', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('dba4af82-0291-4c88-8f79-865c80b861bf', 'ce6781a5-807c-4628-922f-b4783e87adf0', '4a8d3fad-d0e2-4c19-8840-9ef706f90b7b', 1, NULL, 'STARTER', '2026-09-11 16:21:08.568+05:30', 'afde9793-1550-477e-b114-bdd6d6c5491e', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('81f6b76f-c0ef-47b0-b7ab-f14ed0d65b74', 'cf12e201-ceb6-40ba-a0f4-fe1b0e5aac61', '5101522a-081e-4866-9f74-261854fe4404', 1, NULL, 'STARTER', '2026-09-12 12:11:28.257+05:30', '4b8a17f6-cc5b-43d8-9bb1-23572af374e7', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('c262a5ac-141d-4b6d-a91a-30e16880127b', '7b921377-29d0-4537-a67a-bddf6caeb385', '5101522a-081e-4866-9f74-261854fe4404', 1, NULL, 'STARTER', '2026-09-12 15:31:15.344+05:30', '1bc49c16-8bb7-4650-a1c1-0f3afb56fdd8', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('6db55bee-97a7-42ce-9746-e88fd9093400', '419da55d-d450-436d-9e7a-6f8cc0cb751a', '4a8d3fad-d0e2-4c19-8840-9ef706f90b7b', 1, NULL, 'STARTER', '2026-09-12 16:05:29.956+05:30', '610ce49b-6860-4c2a-a978-58eee53abe0b', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('ee29a5a1-ef99-46f2-8616-ed212e87a72c', '419da55d-d450-436d-9e7a-6f8cc0cb751a', '71451535-8d85-417f-b0ec-3f2b87016045', 1, NULL, 'STARTER', '2026-09-12 16:05:29.956+05:30', 'e58cd3f4-fcb9-466f-882e-79f58c50f01d', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('c24762d8-4317-4dc1-8eb2-a73358ca19bb', '1a8e73d0-d3a5-4d51-974f-2f255be03cb9', '5d13a97e-027a-445b-94eb-2f00546b1614', 1, NULL, 'STARTER', '2026-09-12 16:21:26.872+05:30', 'de49919b-7467-40d6-a444-ce0e0b927f1e', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('85b7c516-74ca-443e-8bef-2e7d67fbb030', '1a8e73d0-d3a5-4d51-974f-2f255be03cb9', '640584ad-7f9e-4a1b-8740-290fd382ea81', 1, NULL, 'STARTER', '2026-09-12 16:21:26.872+05:30', '0a897341-6ac0-4d8d-9eaf-ceade7d93d17', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('17b9f458-1cb3-4700-a6da-216b168ae4d7', 'a834cfdd-33c9-4650-bc7f-23a9b7168809', '640584ad-7f9e-4a1b-8740-290fd382ea81', 1, NULL, 'STARTER', '2026-09-12 16:22:24.148+05:30', '507db4ef-89ab-45ce-b827-28b40e002b45', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('411fa0e8-d524-47ff-b0d9-e9b66fbd7a6b', 'c0b2c455-e902-4758-b2aa-dda79c0fd74e', '71451535-8d85-417f-b0ec-3f2b87016045', 1, NULL, 'STARTER', '2026-09-12 16:37:03.943+05:30', '1756bfe8-0ef6-4d28-aaab-39b4e69b086e', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('be9784a5-6649-40f4-9edf-824a8a5a0307', 'c77f90c7-f328-45ef-90fa-724c0fb7e829', 'd4d5c11d-7ca8-4f1f-9784-45b39bd6ef7c', 1, NULL, 'STARTER', '2026-09-12 16:38:07.864+05:30', '384df9e2-296b-4b7e-b7b3-fc56b19ee31b', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('09273c23-2723-4775-8883-52c53dc3e3ff', 'c77f90c7-f328-45ef-90fa-724c0fb7e829', '2ddb7944-4e83-4dda-99de-94dd5e83bb77', 1, NULL, 'STARTER', '2026-09-12 16:38:07.864+05:30', '2ea6b595-c3ff-4250-b013-4b9221c0fd73', '11111111-1111-1111-1111-111111111111', NULL, NULL);
INSERT INTO public.kot_items VALUES ('7e7b7c7a-98fe-4019-9b9b-073b7ab754c9', '2ff59c9f-4c88-49f9-923a-67919ab78b59', '71451535-8d85-417f-b0ec-3f2b87016045', 2, NULL, 'STARTER', NULL, 'e37fb3cb-1472-4f02-9822-a08237870bd7', '11111111-1111-1111-1111-111111111111', NULL, NULL);


--
-- Data for Name: kot_performance; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: kot_status_history; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.kot_status_history VALUES ('93cbe4ed-0be4-4880-94a0-3491ee3421ec', '80f4fd60-0398-4b9a-b31c-ee251b10bebc', 'QUEUED', NULL, '2026-09-03 14:19:54.662+05:30');
INSERT INTO public.kot_status_history VALUES ('b2cf2bff-342c-4a48-bd08-9c39e57bc195', '7ac440d2-529b-4a22-80da-07c102b52bcd', 'QUEUED', NULL, '2026-09-03 14:21:16.217+05:30');
INSERT INTO public.kot_status_history VALUES ('2272bbc8-18fd-4276-a171-90c6a960231d', '1a483a59-4b70-4a21-a78c-e4566f492aa7', 'QUEUED', NULL, '2026-09-03 14:25:51.934+05:30');
INSERT INTO public.kot_status_history VALUES ('4dcf845b-117e-45bd-a432-6486d0080545', '1a483a59-4b70-4a21-a78c-e4566f492aa7', 'PREPARING', NULL, '2026-09-03 14:43:30.808+05:30');
INSERT INTO public.kot_status_history VALUES ('b16a1c35-c47e-4587-b614-4929ccb03941', '1a483a59-4b70-4a21-a78c-e4566f492aa7', 'READY', NULL, '2026-09-03 14:43:30.873+05:30');
INSERT INTO public.kot_status_history VALUES ('dfc1a11c-f652-408e-b383-a0f3ba06f6d5', '80f4fd60-0398-4b9a-b31c-ee251b10bebc', 'READY', NULL, '2026-09-03 14:43:47.826+05:30');
INSERT INTO public.kot_status_history VALUES ('4a358c6e-1676-4a9c-8d7b-360b9f176193', '80f4fd60-0398-4b9a-b31c-ee251b10bebc', 'SERVED', NULL, '2026-09-03 14:45:23.37+05:30');
INSERT INTO public.kot_status_history VALUES ('c25e227f-bb26-411c-a524-0d9c0e190e72', '7ac440d2-529b-4a22-80da-07c102b52bcd', 'PREPARING', NULL, '2026-09-03 14:46:09.182+05:30');
INSERT INTO public.kot_status_history VALUES ('1afca2c7-8745-431e-92cc-d34af01f9e4b', '7ac440d2-529b-4a22-80da-07c102b52bcd', 'READY', NULL, '2026-09-03 14:46:36.413+05:30');
INSERT INTO public.kot_status_history VALUES ('0bee32cc-01e2-4171-b3b2-aa0b7a6ec98a', 'd0e620ed-a0fc-4793-a60e-0eee6f19dd09', 'QUEUED', NULL, '2026-09-03 14:53:11.914+05:30');
INSERT INTO public.kot_status_history VALUES ('f7198b0a-ba8e-4a6b-8fcc-1e3a6c3dade4', 'd0e620ed-a0fc-4793-a60e-0eee6f19dd09', 'PREPARING', NULL, '2026-09-03 14:54:45.493+05:30');
INSERT INTO public.kot_status_history VALUES ('59f9fcee-8b6d-4f81-82c5-20bfbad7005f', 'd0e620ed-a0fc-4793-a60e-0eee6f19dd09', 'READY', NULL, '2026-09-03 14:54:57.983+05:30');
INSERT INTO public.kot_status_history VALUES ('dd1bdae6-1c3d-4ec1-953a-ae428341e446', '476f5980-0930-496c-8c4a-9eaf395a75cf', 'QUEUED', NULL, '2026-09-03 15:17:20.285+05:30');
INSERT INTO public.kot_status_history VALUES ('dc6281c6-c072-43fb-b3e4-d72a72c33084', 'aaeb22ca-77d9-4125-93fb-ffaddabfd1ab', 'QUEUED', NULL, '2026-09-04 00:02:44.876+05:30');
INSERT INTO public.kot_status_history VALUES ('d43f8454-a954-478a-9dbd-84f47a5e90db', '780db29f-b971-4fb9-a7c4-e45ad3fe81f4', 'QUEUED', NULL, '2026-09-04 00:05:22.369+05:30');
INSERT INTO public.kot_status_history VALUES ('41983fa2-0225-4cf4-b6f8-16f879262976', 'f72e5dc0-f56e-451b-a014-cd4419cacbdf', 'QUEUED', NULL, '2026-09-04 00:05:57.398+05:30');
INSERT INTO public.kot_status_history VALUES ('e76f7c48-00ea-49ac-8fef-234086c0bb18', '7ac440d2-529b-4a22-80da-07c102b52bcd', 'SERVED', NULL, '2026-09-04 00:40:28.008+05:30');
INSERT INTO public.kot_status_history VALUES ('ae2305d5-1c8f-4fed-9d2e-1038f94ca724', 'd0e620ed-a0fc-4793-a60e-0eee6f19dd09', 'SERVED', NULL, '2026-09-04 00:40:29.304+05:30');
INSERT INTO public.kot_status_history VALUES ('4c4e6564-f290-481a-b386-5a466c8f2bc7', '314f59d3-358c-4d0d-82ce-e2348b2f5869', 'QUEUED', NULL, '2026-09-04 00:40:55.762+05:30');
INSERT INTO public.kot_status_history VALUES ('ccf61806-1c52-4915-8d21-d320946971e5', '476f5980-0930-496c-8c4a-9eaf395a75cf', 'PREPARING', NULL, '2026-09-04 00:42:51.595+05:30');
INSERT INTO public.kot_status_history VALUES ('27330f6a-c208-4f07-9bd6-23f7bc47a6f4', 'aaeb22ca-77d9-4125-93fb-ffaddabfd1ab', 'PREPARING', NULL, '2026-09-04 00:42:52.785+05:30');
INSERT INTO public.kot_status_history VALUES ('9d812f65-3ce8-4d74-a8e6-11094d810a5e', '780db29f-b971-4fb9-a7c4-e45ad3fe81f4', 'PREPARING', NULL, '2026-09-04 00:42:53.741+05:30');
INSERT INTO public.kot_status_history VALUES ('15c5c66f-1b5d-413d-8dce-8aee043b6a99', 'f72e5dc0-f56e-451b-a014-cd4419cacbdf', 'PREPARING', NULL, '2026-09-04 00:42:55.051+05:30');
INSERT INTO public.kot_status_history VALUES ('e57fafb1-c8d8-4c6b-b036-cceb71c92269', 'f72e5dc0-f56e-451b-a014-cd4419cacbdf', 'READY', NULL, '2026-09-04 00:42:55.494+05:30');
INSERT INTO public.kot_status_history VALUES ('6f1d99d3-25e5-4240-95c3-95edab56744a', '314f59d3-358c-4d0d-82ce-e2348b2f5869', 'PREPARING', NULL, '2026-09-04 00:42:59.01+05:30');
INSERT INTO public.kot_status_history VALUES ('226b1093-3fca-4db4-acda-f86a68c6999e', '314f59d3-358c-4d0d-82ce-e2348b2f5869', 'READY', NULL, '2026-09-04 00:43:02.223+05:30');
INSERT INTO public.kot_status_history VALUES ('40e0cdcf-f201-48c1-a7d7-35749cdac64c', '476f5980-0930-496c-8c4a-9eaf395a75cf', 'READY', NULL, '2026-09-04 00:43:04.009+05:30');
INSERT INTO public.kot_status_history VALUES ('ad6aeffd-a453-4d28-87ed-0e9868ee02d0', 'aaeb22ca-77d9-4125-93fb-ffaddabfd1ab', 'READY', NULL, '2026-09-04 00:43:05.724+05:30');
INSERT INTO public.kot_status_history VALUES ('50df4001-87f6-4e43-a3b0-099cd751949a', '780db29f-b971-4fb9-a7c4-e45ad3fe81f4', 'READY', NULL, '2026-09-04 00:43:06.966+05:30');
INSERT INTO public.kot_status_history VALUES ('317c9748-750b-432c-a2b0-933c5feda294', '476f5980-0930-496c-8c4a-9eaf395a75cf', 'SERVED', NULL, '2026-09-04 00:43:39.256+05:30');
INSERT INTO public.kot_status_history VALUES ('269d7c72-8ee2-4270-a28b-e7bafcbb9174', 'aaeb22ca-77d9-4125-93fb-ffaddabfd1ab', 'SERVED', NULL, '2026-09-04 00:43:39.854+05:30');
INSERT INTO public.kot_status_history VALUES ('36664452-b594-4088-a745-ed9e7e275437', '780db29f-b971-4fb9-a7c4-e45ad3fe81f4', 'SERVED', NULL, '2026-09-04 00:43:40.462+05:30');
INSERT INTO public.kot_status_history VALUES ('0a706957-fbf1-4faf-b3d9-61642201dc7f', '314f59d3-358c-4d0d-82ce-e2348b2f5869', 'SERVED', NULL, '2026-09-04 00:43:46.6+05:30');
INSERT INTO public.kot_status_history VALUES ('0125ea40-d607-41e4-858c-77e8627c20fd', 'f72e5dc0-f56e-451b-a014-cd4419cacbdf', 'SERVED', NULL, '2026-09-04 00:44:05.589+05:30');
INSERT INTO public.kot_status_history VALUES ('81646e39-3f32-4549-807d-671db3e066e7', '9a5c4cc8-4b11-4022-b5c1-6d4bedb3b01b', 'QUEUED', NULL, '2026-09-04 01:04:33.383+05:30');
INSERT INTO public.kot_status_history VALUES ('5355ba12-eee8-4f35-abf9-1e4935ac4206', '9a5c4cc8-4b11-4022-b5c1-6d4bedb3b01b', 'PREPARING', NULL, '2026-09-04 01:05:38.222+05:30');
INSERT INTO public.kot_status_history VALUES ('1a434804-4fe4-46ef-aede-a45f9ccfcfd6', '9a5c4cc8-4b11-4022-b5c1-6d4bedb3b01b', 'READY', NULL, '2026-09-04 01:05:39.066+05:30');
INSERT INTO public.kot_status_history VALUES ('90c03f2a-95be-4ee2-aaef-68e8dbecedfd', '9a5c4cc8-4b11-4022-b5c1-6d4bedb3b01b', 'SERVED', NULL, '2026-09-04 01:06:00.067+05:30');
INSERT INTO public.kot_status_history VALUES ('3521858f-7c89-4896-a502-31723a2cad72', '00089db3-43f2-4348-bbff-da57724bc4eb', 'QUEUED', NULL, '2026-09-04 01:19:56.554+05:30');
INSERT INTO public.kot_status_history VALUES ('259e44b9-de06-4ff1-8888-e18cf6134c09', 'e0c7eff8-6e10-43b7-bc2a-9be10a9a091b', 'QUEUED', NULL, '2026-09-05 13:19:55.691+05:30');
INSERT INTO public.kot_status_history VALUES ('88acc558-48ae-4d7b-93c6-4b77554074cd', 'e0c7eff8-6e10-43b7-bc2a-9be10a9a091b', 'READY', NULL, '2026-09-05 13:20:34.59+05:30');
INSERT INTO public.kot_status_history VALUES ('b3a225b1-92e6-497e-b4fa-4c3af72b58a9', 'e0c7eff8-6e10-43b7-bc2a-9be10a9a091b', 'SERVED', NULL, '2026-09-05 13:20:37.758+05:30');
INSERT INTO public.kot_status_history VALUES ('b0cdd861-86b5-47fb-ba96-83306d1e8616', '38d4de12-7ca2-48b6-8856-15027f1d154b', 'QUEUED', NULL, '2026-09-05 14:26:19.165+05:30');
INSERT INTO public.kot_status_history VALUES ('c86fb126-8d4b-4708-a5fa-8cb729459919', '022f9506-96ce-4851-b531-11b374d9f3eb', 'QUEUED', NULL, '2026-09-05 15:10:12.647+05:30');
INSERT INTO public.kot_status_history VALUES ('fc5c7b39-4970-476c-9e14-c07e658745d9', '1a8d8383-c9bc-481e-8700-176bf3b7c38b', 'QUEUED', NULL, '2026-09-05 16:22:38.232+05:30');
INSERT INTO public.kot_status_history VALUES ('cb026a5a-09cc-46dd-8d0d-3d9c557dc727', '1a8d8383-c9bc-481e-8700-176bf3b7c38b', 'READY', NULL, '2026-09-05 16:23:35.479+05:30');
INSERT INTO public.kot_status_history VALUES ('fb334c01-dc8b-4f24-91f9-dd230643877b', '1a8d8383-c9bc-481e-8700-176bf3b7c38b', 'SERVED', NULL, '2026-09-05 16:23:36.494+05:30');
INSERT INTO public.kot_status_history VALUES ('76619ac6-e1f6-4b06-8048-1b1d66e62481', '187ed388-52c9-4d73-bfa6-e4f96d3f8f51', 'QUEUED', NULL, '2026-09-05 16:45:42.065+05:30');
INSERT INTO public.kot_status_history VALUES ('fadae3b1-94cc-459e-86ab-3aa6b27eb7a5', '5d32816c-fd4d-4bb9-8a24-2180b08fa1b8', 'QUEUED', NULL, '2026-09-05 16:51:32.759+05:30');
INSERT INTO public.kot_status_history VALUES ('a4dd8871-d622-42a0-a9be-e4bbb1ddcfa2', '4a1fae02-9a34-4e15-a9b9-bcd4df784612', 'QUEUED', NULL, '2026-09-05 17:05:55.01+05:30');
INSERT INTO public.kot_status_history VALUES ('0fa9886c-3d34-4207-aa59-522f88eadc75', '91c40700-9ebf-4753-b454-24ddf11da7f9', 'QUEUED', NULL, '2026-09-08 11:05:04.429+05:30');
INSERT INTO public.kot_status_history VALUES ('f4c421e3-d557-4180-a43f-634c8013d5e5', '91c40700-9ebf-4753-b454-24ddf11da7f9', 'READY', NULL, '2026-09-08 11:05:44.708+05:30');
INSERT INTO public.kot_status_history VALUES ('1744c487-9bb7-4a61-ae5f-9ec02abff463', '91c40700-9ebf-4753-b454-24ddf11da7f9', 'SERVED', NULL, '2026-09-08 11:05:57.614+05:30');
INSERT INTO public.kot_status_history VALUES ('7af8fcd9-ee52-459a-ac3d-bc8df08f5b81', 'a05cc85f-571d-457d-8fb9-2736dd584304', 'QUEUED', NULL, '2026-09-08 11:09:01.406+05:30');
INSERT INTO public.kot_status_history VALUES ('e76a5d6b-8e07-4149-ab71-461982ec5d6f', 'a05cc85f-571d-457d-8fb9-2736dd584304', 'READY', NULL, '2026-09-08 11:09:17.774+05:30');
INSERT INTO public.kot_status_history VALUES ('d8d73b62-3a09-48a0-8d13-bb2b9a14261a', 'a05cc85f-571d-457d-8fb9-2736dd584304', 'SERVED', NULL, '2026-09-08 11:09:26.519+05:30');
INSERT INTO public.kot_status_history VALUES ('fb0584e1-de71-4977-bd81-767a70c642d3', '6263318d-e12b-43cf-9c36-9ee3f17e597e', 'QUEUED', NULL, '2026-09-08 11:12:06.992+05:30');
INSERT INTO public.kot_status_history VALUES ('027eaecf-3898-4780-9c04-0c4687b6b782', '6263318d-e12b-43cf-9c36-9ee3f17e597e', 'READY', NULL, '2026-09-08 11:12:14.018+05:30');
INSERT INTO public.kot_status_history VALUES ('aba6d773-aa04-40d4-9d92-85a2843034cd', '6263318d-e12b-43cf-9c36-9ee3f17e597e', 'SERVED', NULL, '2026-09-08 11:12:15.017+05:30');
INSERT INTO public.kot_status_history VALUES ('d4d72452-4983-4922-a20f-ca282fc10ada', '38d4de12-7ca2-48b6-8856-15027f1d154b', 'READY', NULL, '2026-09-08 11:13:13.385+05:30');
INSERT INTO public.kot_status_history VALUES ('6b1dab20-7387-4ca0-b204-73a833533338', '00089db3-43f2-4348-bbff-da57724bc4eb', 'READY', NULL, '2026-09-08 11:13:14.592+05:30');
INSERT INTO public.kot_status_history VALUES ('f30a41cf-217b-4209-a448-9672f976819d', '00089db3-43f2-4348-bbff-da57724bc4eb', 'SERVED', NULL, '2026-09-08 13:11:42.275+05:30');
INSERT INTO public.kot_status_history VALUES ('e68708e2-a636-4828-98b5-87eeab289079', '2b9b7a79-3fc2-4a24-ab97-ff472596e66b', 'QUEUED', NULL, '2026-09-08 13:13:14.944+05:30');
INSERT INTO public.kot_status_history VALUES ('b24e04b5-26db-4b05-a906-e0e7df74dc39', '2b9b7a79-3fc2-4a24-ab97-ff472596e66b', 'READY', NULL, '2026-09-08 13:13:29.109+05:30');
INSERT INTO public.kot_status_history VALUES ('a0df8155-d324-4805-844e-6325a8669fdb', '4728ca77-caa1-49de-a309-254613a1cad3', 'QUEUED', NULL, '2026-09-08 13:14:15.321+05:30');
INSERT INTO public.kot_status_history VALUES ('6599b866-5127-4fb2-a7ed-84ce89ee8275', '4728ca77-caa1-49de-a309-254613a1cad3', 'READY', NULL, '2026-09-08 13:14:25.929+05:30');
INSERT INTO public.kot_status_history VALUES ('b3678f2b-f90d-4c53-a3b5-f23c5a7d86a0', '4728ca77-caa1-49de-a309-254613a1cad3', 'SERVED', NULL, '2026-09-08 13:15:08.739+05:30');
INSERT INTO public.kot_status_history VALUES ('b128baee-51b7-4bb9-938f-fc05dfee2010', 'd2d5e040-193a-4e9a-ab00-8ba1614f5266', 'QUEUED', NULL, '2026-09-08 14:14:29.265+05:30');
INSERT INTO public.kot_status_history VALUES ('243b8ab7-2bdf-41d5-84cc-a451a65198ad', 'd2d5e040-193a-4e9a-ab00-8ba1614f5266', 'READY', NULL, '2026-09-08 14:15:25.984+05:30');
INSERT INTO public.kot_status_history VALUES ('220fed0b-2928-4be8-9172-e3236e1960bf', 'd2d5e040-193a-4e9a-ab00-8ba1614f5266', 'SERVED', NULL, '2026-09-08 14:15:27.395+05:30');
INSERT INTO public.kot_status_history VALUES ('b5d45a89-d311-4254-9079-3b2bbfc9e137', 'c3b2a555-0bb8-4140-aa3b-16a067935d7f', 'QUEUED', NULL, '2026-09-08 14:27:24.486+05:30');
INSERT INTO public.kot_status_history VALUES ('584cfa97-48a9-4827-a8a5-fbdd79890260', 'c3b2a555-0bb8-4140-aa3b-16a067935d7f', 'PREPARING', NULL, '2026-09-08 14:28:38.816+05:30');
INSERT INTO public.kot_status_history VALUES ('a55c3f5c-d6c6-41f9-8f7a-10c3cf4bb774', 'c3b2a555-0bb8-4140-aa3b-16a067935d7f', 'READY', NULL, '2026-09-08 14:39:21.418+05:30');
INSERT INTO public.kot_status_history VALUES ('b0a38937-6e86-4c1d-a8f9-b7f1d31a9abb', 'c3b2a555-0bb8-4140-aa3b-16a067935d7f', 'SERVED', NULL, '2026-09-08 14:39:22.77+05:30');
INSERT INTO public.kot_status_history VALUES ('bc8ca124-da3c-453a-86eb-9bd2455a9b84', '753c5eb7-0772-4082-b9ea-3cbff53d0f1d', 'QUEUED', NULL, '2026-09-08 14:41:53.613+05:30');
INSERT INTO public.kot_status_history VALUES ('f881bc8f-7e94-4244-86fe-687575494d72', '753c5eb7-0772-4082-b9ea-3cbff53d0f1d', 'PREPARING', NULL, '2026-09-08 14:42:51.394+05:30');
INSERT INTO public.kot_status_history VALUES ('299205c1-3f79-419d-8f6f-8e458342127e', '753c5eb7-0772-4082-b9ea-3cbff53d0f1d', 'READY', NULL, '2026-09-08 14:43:25.77+05:30');
INSERT INTO public.kot_status_history VALUES ('df63975b-63b4-4d1a-8105-6a674b84f3b1', '753c5eb7-0772-4082-b9ea-3cbff53d0f1d', 'SERVED', NULL, '2026-09-08 14:44:38.645+05:30');
INSERT INTO public.kot_status_history VALUES ('25035fbb-17f6-41b7-861c-584df5a91cf9', '387bfcae-81d2-4138-b9af-783ed452a554', 'QUEUED', NULL, '2026-09-08 15:13:45.133+05:30');
INSERT INTO public.kot_status_history VALUES ('0dcc8fd1-156d-4fa2-9e82-fc8d311ee4f5', '387bfcae-81d2-4138-b9af-783ed452a554', 'PREPARING', NULL, '2026-09-08 15:14:17.116+05:30');
INSERT INTO public.kot_status_history VALUES ('92507737-0c6c-438b-84aa-ac384f06814f', '97823311-3165-4981-bb4a-f701b6c54e81', 'QUEUED', NULL, '2026-09-08 16:19:27.322+05:30');
INSERT INTO public.kot_status_history VALUES ('4fc19a58-00ac-45a8-ab62-f5f55af1b706', '97823311-3165-4981-bb4a-f701b6c54e81', 'PREPARING', NULL, '2026-09-08 16:19:40.876+05:30');
INSERT INTO public.kot_status_history VALUES ('7553c64c-eb78-4998-9851-e17678f90a6b', '97823311-3165-4981-bb4a-f701b6c54e81', 'READY', NULL, '2026-09-08 16:19:41.752+05:30');
INSERT INTO public.kot_status_history VALUES ('172adfad-593d-4b64-aa2d-6b1fd6e82fe9', '97823311-3165-4981-bb4a-f701b6c54e81', 'SERVED', NULL, '2026-09-08 16:19:42.461+05:30');
INSERT INTO public.kot_status_history VALUES ('23e5e6a7-8fc3-4832-b9a6-8b0d409d94f3', '387bfcae-81d2-4138-b9af-783ed452a554', 'READY', NULL, '2026-09-09 12:45:15.057+05:30');
INSERT INTO public.kot_status_history VALUES ('b48ed865-6873-4b81-b656-f1a27d3999a4', '387bfcae-81d2-4138-b9af-783ed452a554', 'SERVED', NULL, '2026-09-09 12:45:15.89+05:30');
INSERT INTO public.kot_status_history VALUES ('e3696035-83e2-430a-9129-68fad5824375', 'cde85ae8-efc8-4329-9983-c65db7879821', 'QUEUED', NULL, '2026-09-09 12:47:30.802+05:30');
INSERT INTO public.kot_status_history VALUES ('51954f10-dcf6-4f56-b0d8-5b22c96ac302', '4a26f71a-500e-456d-a69b-5dc7529906e8', 'QUEUED', NULL, '2026-09-09 12:47:50.745+05:30');
INSERT INTO public.kot_status_history VALUES ('71b5bc6e-4e7a-433b-be8a-73eb8eeb992c', '0d5f81a3-df18-49f4-92ac-ca9b95a7273f', 'QUEUED', NULL, '2026-09-09 12:48:24.623+05:30');
INSERT INTO public.kot_status_history VALUES ('5a0d0122-fc4a-456c-af0a-a2e7998f7fed', 'da54b04f-218d-441e-91d5-44e74856c1c6', 'QUEUED', NULL, '2026-09-09 12:49:23.897+05:30');
INSERT INTO public.kot_status_history VALUES ('121f694e-0ff9-4ee1-b36a-2e94ee52e790', '0d5f81a3-df18-49f4-92ac-ca9b95a7273f', 'READY', NULL, '2026-09-09 12:49:35.299+05:30');
INSERT INTO public.kot_status_history VALUES ('cfc7f47c-88d4-4a56-b8c4-aa7e3a5904ad', '4a26f71a-500e-456d-a69b-5dc7529906e8', 'READY', NULL, '2026-09-09 12:49:37.24+05:30');
INSERT INTO public.kot_status_history VALUES ('5638898d-c6c1-4662-828c-a8ed9df58105', 'cde85ae8-efc8-4329-9983-c65db7879821', 'READY', NULL, '2026-09-09 12:49:40.419+05:30');
INSERT INTO public.kot_status_history VALUES ('ee5f8512-4ea3-43d0-85c7-4113b1265b52', 'da54b04f-218d-441e-91d5-44e74856c1c6', 'READY', NULL, '2026-09-09 12:49:42.006+05:30');
INSERT INTO public.kot_status_history VALUES ('f83279cb-2537-4e05-806c-a0ba3994a5d6', 'cde85ae8-efc8-4329-9983-c65db7879821', 'SERVED', NULL, '2026-09-09 12:50:26.938+05:30');
INSERT INTO public.kot_status_history VALUES ('a7fa274b-8752-4bf6-a705-bc28ac7d2157', '4a26f71a-500e-456d-a69b-5dc7529906e8', 'SERVED', NULL, '2026-09-09 12:50:27.444+05:30');
INSERT INTO public.kot_status_history VALUES ('c51bfe0a-152f-4864-a76d-4f8ce2b02005', '0d5f81a3-df18-49f4-92ac-ca9b95a7273f', 'SERVED', NULL, '2026-09-09 12:50:27.707+05:30');
INSERT INTO public.kot_status_history VALUES ('a714980d-2267-4bcb-81d4-eeb3e3e6eb4a', 'da54b04f-218d-441e-91d5-44e74856c1c6', 'SERVED', NULL, '2026-09-09 12:50:28.169+05:30');
INSERT INTO public.kot_status_history VALUES ('2646070a-c5fe-490a-a4d5-8dea62e3017b', '66f4fcaf-d7cd-47ee-b09a-d369f60b44fb', 'QUEUED', NULL, '2026-09-09 12:51:14.275+05:30');
INSERT INTO public.kot_status_history VALUES ('c971d7ba-706d-49e4-ab7f-5b7558136c6f', 'b7760cd0-9b35-44ed-b588-ac6b42eef3d4', 'QUEUED', NULL, '2026-09-09 12:51:28.119+05:30');
INSERT INTO public.kot_status_history VALUES ('fae177c7-4cc3-484e-b4b9-fa4ced085638', '4d46fa43-e341-4fe6-9c52-8134a1afafbc', 'QUEUED', NULL, '2026-09-09 12:51:46.707+05:30');
INSERT INTO public.kot_status_history VALUES ('9f896760-c5fe-4cd4-b24d-18139d9cb7c6', '35412261-a6db-4503-abb2-74ee5bd5db84', 'QUEUED', NULL, '2026-09-09 12:52:31.707+05:30');
INSERT INTO public.kot_status_history VALUES ('4ad5e1bb-60d4-42f5-b046-cd82f52e2c31', 'b7760cd0-9b35-44ed-b588-ac6b42eef3d4', 'READY', NULL, '2026-09-09 12:53:12.974+05:30');
INSERT INTO public.kot_status_history VALUES ('529ec243-396c-4d8d-9be4-90387d2f9541', '66f4fcaf-d7cd-47ee-b09a-d369f60b44fb', 'READY', NULL, '2026-09-09 12:53:14.512+05:30');
INSERT INTO public.kot_status_history VALUES ('a5fdfc1e-9e6f-4143-ac59-e6a0a8af7561', '4d46fa43-e341-4fe6-9c52-8134a1afafbc', 'READY', NULL, '2026-09-09 12:53:16.577+05:30');
INSERT INTO public.kot_status_history VALUES ('9b8676f2-90a8-44ca-a35e-fd75dd21de1e', '35412261-a6db-4503-abb2-74ee5bd5db84', 'READY', NULL, '2026-09-09 12:53:19.002+05:30');
INSERT INTO public.kot_status_history VALUES ('fe53e90a-2559-4b54-bea7-46f770cb25ca', 'd8cf458f-c314-4de9-8fd0-534915e77a5a', 'QUEUED', NULL, '2026-09-09 12:55:56.587+05:30');
INSERT INTO public.kot_status_history VALUES ('c0262534-1c3f-423d-9d47-c9c687a30727', 'd8cf458f-c314-4de9-8fd0-534915e77a5a', 'READY', NULL, '2026-09-09 12:59:41.573+05:30');
INSERT INTO public.kot_status_history VALUES ('7a6ca26c-0c6c-4a45-af03-25f42bdeaedf', '2ae3bb5c-9171-4f02-8aec-88611bd9216a', 'QUEUED', NULL, '2026-09-09 13:01:25.234+05:30');
INSERT INTO public.kot_status_history VALUES ('0d93ee55-76d4-4d87-83ff-1c98398a031a', '0a8cc3a0-92d2-4f37-b85f-1818a5d433c7', 'QUEUED', NULL, '2026-09-09 13:02:02.268+05:30');
INSERT INTO public.kot_status_history VALUES ('6ba9d719-3dca-4824-911c-617e91a726fc', 'e41f4c53-4fb8-467b-b40e-4a53b8479164', 'QUEUED', NULL, '2026-09-09 13:02:03.777+05:30');
INSERT INTO public.kot_status_history VALUES ('42ae48f6-612b-48e3-be86-76e97a14a572', 'fce3d545-2638-41d6-b6f3-f8a0683e9150', 'QUEUED', NULL, '2026-09-09 13:03:37.905+05:30');
INSERT INTO public.kot_status_history VALUES ('f2278892-d443-4312-883d-f1a374af2a6d', 'da6358fd-b56e-4bad-bcc0-0af0ec94b26b', 'QUEUED', NULL, '2026-09-09 13:03:39.406+05:30');
INSERT INTO public.kot_status_history VALUES ('e91141d9-17be-42ca-a23f-87e1e58a1758', '2ae3bb5c-9171-4f02-8aec-88611bd9216a', 'READY', NULL, '2026-09-09 13:44:04.1+05:30');
INSERT INTO public.kot_status_history VALUES ('d92cd3ed-3ea6-456b-9136-170070638fbe', '0a8cc3a0-92d2-4f37-b85f-1818a5d433c7', 'READY', NULL, '2026-09-09 13:44:05.937+05:30');
INSERT INTO public.kot_status_history VALUES ('6768007b-b629-403f-a74c-41afeb2794f1', 'da6358fd-b56e-4bad-bcc0-0af0ec94b26b', 'READY', NULL, '2026-09-09 13:44:09.366+05:30');
INSERT INTO public.kot_status_history VALUES ('f8151015-8949-4f72-93c7-a4d982cb1d62', 'fce3d545-2638-41d6-b6f3-f8a0683e9150', 'READY', NULL, '2026-09-09 13:44:10.58+05:30');
INSERT INTO public.kot_status_history VALUES ('2d031f9f-31a7-4829-aeca-1f36704063e1', 'e41f4c53-4fb8-467b-b40e-4a53b8479164', 'READY', NULL, '2026-09-09 13:44:11.493+05:30');
INSERT INTO public.kot_status_history VALUES ('a108fc50-a841-4955-8a1e-5b60a23392ea', '35412261-a6db-4503-abb2-74ee5bd5db84', 'SERVED', NULL, '2026-09-09 13:49:00.602+05:30');
INSERT INTO public.kot_status_history VALUES ('8dfee0f2-6210-4b09-9a0c-3c62baa31041', 'd8cf458f-c314-4de9-8fd0-534915e77a5a', 'SERVED', NULL, '2026-09-09 13:49:01.069+05:30');
INSERT INTO public.kot_status_history VALUES ('4c18c5e9-62ce-443a-916e-3ed1f6be28d7', '2ae3bb5c-9171-4f02-8aec-88611bd9216a', 'SERVED', NULL, '2026-09-09 13:49:01.487+05:30');
INSERT INTO public.kot_status_history VALUES ('2dbe9b46-5469-44b9-8588-3524a39efd02', '0a8cc3a0-92d2-4f37-b85f-1818a5d433c7', 'SERVED', NULL, '2026-09-09 13:49:02.059+05:30');
INSERT INTO public.kot_status_history VALUES ('a3b59988-c3e9-4fb2-91df-2bbc27e70bbc', 'e41f4c53-4fb8-467b-b40e-4a53b8479164', 'SERVED', NULL, '2026-09-09 13:49:02.538+05:30');
INSERT INTO public.kot_status_history VALUES ('9a96eeea-5bf6-42a1-b40e-30c45183fdb3', 'fce3d545-2638-41d6-b6f3-f8a0683e9150', 'SERVED', NULL, '2026-09-09 13:49:03.041+05:30');
INSERT INTO public.kot_status_history VALUES ('bb53bf04-0200-488c-b2dc-26cb98095f58', 'da6358fd-b56e-4bad-bcc0-0af0ec94b26b', 'SERVED', NULL, '2026-09-09 13:49:03.613+05:30');
INSERT INTO public.kot_status_history VALUES ('6d17b2c4-fe0b-4c2b-8b64-496bf73f3481', '39863209-183e-4007-a67f-cf22d00609b9', 'QUEUED', NULL, '2026-09-09 14:27:26.236+05:30');
INSERT INTO public.kot_status_history VALUES ('3d6aa227-2f3f-4683-a6d5-c722c5385c15', '2508d470-13d4-4db2-a796-75774ccb80c2', 'QUEUED', NULL, '2026-09-09 14:27:33.904+05:30');
INSERT INTO public.kot_status_history VALUES ('524bf383-8ea6-4b6b-be2c-0546a4dc42bd', '0b2b03d2-b645-49b9-8644-1a36bc48a18a', 'QUEUED', NULL, '2026-09-09 14:28:58.384+05:30');
INSERT INTO public.kot_status_history VALUES ('d9be44ad-0b49-4903-b673-aab7cbee631d', '4ff03eac-fde7-4266-96fe-a868df825efd', 'QUEUED', NULL, '2026-09-09 14:29:43.568+05:30');
INSERT INTO public.kot_status_history VALUES ('d013b398-9ca0-493d-a2cc-5f675b65da3d', '15cb65ba-80c2-48ed-883e-dbeb46d9dcda', 'QUEUED', NULL, '2026-09-09 14:31:14.691+05:30');
INSERT INTO public.kot_status_history VALUES ('ed74acff-e12b-4c02-bc92-8ba15d865d7e', 'ecb0bac6-06b0-4a59-b4d7-8c2c1686dc67', 'QUEUED', NULL, '2026-09-09 14:31:59.401+05:30');
INSERT INTO public.kot_status_history VALUES ('b2f62c6e-ff41-4f26-be52-6df8b969db2f', 'fc89f774-0dc4-4795-9f68-edd8df66905c', 'QUEUED', NULL, '2026-09-09 14:32:48.934+05:30');
INSERT INTO public.kot_status_history VALUES ('e9d9d74d-decf-463e-833f-2b7cd0a1d377', '933f4133-630c-48df-b056-4502946eb0ae', 'QUEUED', NULL, '2026-09-09 14:34:01.569+05:30');
INSERT INTO public.kot_status_history VALUES ('26c673ed-96c5-4071-9d96-849453bad51f', '3a8544bd-e646-4dca-a8aa-4451fcfcc675', 'QUEUED', NULL, '2026-09-09 14:35:45.639+05:30');
INSERT INTO public.kot_status_history VALUES ('16b2d134-6dbd-43c8-a0be-19c548298510', '5b4062b9-77fe-4305-b776-65b479de232f', 'QUEUED', NULL, '2026-09-09 15:09:20.412+05:30');
INSERT INTO public.kot_status_history VALUES ('a19825cb-3e2f-4e55-9e50-ea67c0198427', '5b4062b9-77fe-4305-b776-65b479de232f', 'READY', NULL, '2026-09-10 10:52:32.478+05:30');
INSERT INTO public.kot_status_history VALUES ('6bbebb0c-a714-4d40-b2dd-95d585a54041', 'e566733f-ccfd-4fa4-b750-c96cde787323', 'QUEUED', NULL, '2026-09-10 16:50:53.13+05:30');
INSERT INTO public.kot_status_history VALUES ('2cda5fe3-5801-41e6-93ab-cb3fced5507e', 'e566733f-ccfd-4fa4-b750-c96cde787323', 'PREPARING', NULL, '2026-09-10 16:51:30.498+05:30');
INSERT INTO public.kot_status_history VALUES ('cc283d94-a278-4f22-9d75-fb9ca18ff061', 'e566733f-ccfd-4fa4-b750-c96cde787323', 'READY', NULL, '2026-09-10 16:52:24.507+05:30');
INSERT INTO public.kot_status_history VALUES ('8afa6f34-07e0-49b0-b982-00916c914629', '4ff03eac-fde7-4266-96fe-a868df825efd', 'READY', NULL, '2026-09-11 11:09:52.44+05:30');
INSERT INTO public.kot_status_history VALUES ('f3a9ba81-b9f7-460e-9dc4-c7eeaa6cbb99', '0b2b03d2-b645-49b9-8644-1a36bc48a18a', 'READY', NULL, '2026-09-11 11:09:54.321+05:30');
INSERT INTO public.kot_status_history VALUES ('55d3bdfb-458c-433b-aac3-cd3dd2f6873d', '0b2b03d2-b645-49b9-8644-1a36bc48a18a', 'SERVED', NULL, '2026-09-11 11:09:55.382+05:30');
INSERT INTO public.kot_status_history VALUES ('911a4dee-d716-4cb6-b200-bc1e841cb440', '15cb65ba-80c2-48ed-883e-dbeb46d9dcda', 'PREPARING', NULL, '2026-09-11 11:10:01.492+05:30');
INSERT INTO public.kot_status_history VALUES ('5a31b23b-1500-4ebd-b612-141fea5b8829', '15cb65ba-80c2-48ed-883e-dbeb46d9dcda', 'READY', NULL, '2026-09-11 11:10:03.233+05:30');
INSERT INTO public.kot_status_history VALUES ('c570b0db-d955-463b-a58c-6aebfa299a46', '4ff03eac-fde7-4266-96fe-a868df825efd', 'SERVED', NULL, '2026-09-11 11:10:04.495+05:30');
INSERT INTO public.kot_status_history VALUES ('4e8c6b35-07b9-48a7-84fa-7d1ade7d2908', '15cb65ba-80c2-48ed-883e-dbeb46d9dcda', 'SERVED', NULL, '2026-09-11 11:10:05.98+05:30');
INSERT INTO public.kot_status_history VALUES ('5aec9632-0734-45c9-9749-d8ce43bdc126', '2508d470-13d4-4db2-a796-75774ccb80c2', 'PREPARING', NULL, '2026-09-11 11:10:07.873+05:30');
INSERT INTO public.kot_status_history VALUES ('4e96be4a-0f62-4224-bcd0-a28de99e9b03', '2508d470-13d4-4db2-a796-75774ccb80c2', 'READY', NULL, '2026-09-11 11:10:10.797+05:30');
INSERT INTO public.kot_status_history VALUES ('cd0bbc31-2961-4a44-926b-4ba57ab7be44', '2508d470-13d4-4db2-a796-75774ccb80c2', 'SERVED', NULL, '2026-09-11 11:10:15.596+05:30');
INSERT INTO public.kot_status_history VALUES ('7b020efe-2d8f-4b56-8c67-3361f53eabc7', '933f4133-630c-48df-b056-4502946eb0ae', 'READY', NULL, '2026-09-11 11:10:31.513+05:30');
INSERT INTO public.kot_status_history VALUES ('c566b84f-5a38-4442-948c-78c74ed31d44', 'fc89f774-0dc4-4795-9f68-edd8df66905c', 'READY', NULL, '2026-09-11 11:10:34.509+05:30');
INSERT INTO public.kot_status_history VALUES ('0986d9bd-04cb-49bd-8efb-40718518ec14', 'ecb0bac6-06b0-4a59-b4d7-8c2c1686dc67', 'PREPARING', NULL, '2026-09-11 11:10:41.322+05:30');
INSERT INTO public.kot_status_history VALUES ('b23a9eda-534f-45e3-93fa-9c262b764ef7', 'ecb0bac6-06b0-4a59-b4d7-8c2c1686dc67', 'READY', NULL, '2026-09-11 11:10:42.054+05:30');
INSERT INTO public.kot_status_history VALUES ('3aeb847f-e329-4c61-8add-c2b0916c282d', 'ecb0bac6-06b0-4a59-b4d7-8c2c1686dc67', 'SERVED', NULL, '2026-09-11 11:10:55.575+05:30');
INSERT INTO public.kot_status_history VALUES ('1082db41-c0bc-4f52-b5bc-d416397dbd01', 'fc89f774-0dc4-4795-9f68-edd8df66905c', 'SERVED', NULL, '2026-09-11 11:10:56.516+05:30');
INSERT INTO public.kot_status_history VALUES ('52aef094-1e9f-47ed-ac58-2bee4b924b50', '933f4133-630c-48df-b056-4502946eb0ae', 'SERVED', NULL, '2026-09-11 11:10:57.339+05:30');
INSERT INTO public.kot_status_history VALUES ('bb2aae7d-e303-4974-a218-e57b79036e6f', '7c360f83-927b-4dea-9514-b7815a12a4f5', 'QUEUED', NULL, '2026-09-11 12:09:46.402+05:30');
INSERT INTO public.kot_status_history VALUES ('81088354-7980-4e8b-aba1-6dcd3758c49f', 'a8088c10-855e-46d2-bc70-3b2bda97e583', 'QUEUED', NULL, '2026-09-11 12:33:27.26+05:30');
INSERT INTO public.kot_status_history VALUES ('20243bf0-f602-43d8-ba42-b6fe840b92a9', 'a8088c10-855e-46d2-bc70-3b2bda97e583', 'READY', NULL, '2026-09-11 12:33:46.124+05:30');
INSERT INTO public.kot_status_history VALUES ('1eb473c0-310b-48da-b084-6a3385bd25c2', 'a8088c10-855e-46d2-bc70-3b2bda97e583', 'SERVED', NULL, '2026-09-11 12:33:47.945+05:30');
INSERT INTO public.kot_status_history VALUES ('b232eae4-0766-4926-9023-d8eb7aa4d408', '7c360f83-927b-4dea-9514-b7815a12a4f5', 'READY', NULL, '2026-09-11 12:33:50.643+05:30');
INSERT INTO public.kot_status_history VALUES ('1ef0e356-43e2-42a6-8b33-1906ec2cf7b8', 'ce6781a5-807c-4628-922f-b4783e87adf0', 'QUEUED', NULL, '2026-09-11 12:59:30.723+05:30');
INSERT INTO public.kot_status_history VALUES ('4fcea0e8-d893-4e4b-9160-517cc9e3509a', '7b921377-29d0-4537-a67a-bddf6caeb385', 'QUEUED', NULL, '2026-09-11 12:59:52.845+05:30');
INSERT INTO public.kot_status_history VALUES ('a793c46e-c2a9-45ac-a8dc-adc9e2183d19', 'd3d5de47-7715-4e5a-9036-ec18153e7a81', 'QUEUED', NULL, '2026-09-11 14:12:08.763+05:30');
INSERT INTO public.kot_status_history VALUES ('9f995cd3-abcd-4494-9eb4-803e92ab5471', 'a41ba409-8e7a-451d-b1d0-413fb105d4de', 'QUEUED', NULL, '2026-09-11 14:16:07.369+05:30');
INSERT INTO public.kot_status_history VALUES ('42b20443-e7ae-41b4-9203-80a22da90ae1', '63992e13-1fb0-4e62-8a36-596aa86d78ee', 'QUEUED', NULL, '2026-09-11 14:19:07.49+05:30');
INSERT INTO public.kot_status_history VALUES ('c0733011-9dc2-4092-b4a3-f0389e5d9f79', '3d8f581a-fd89-4cf7-9704-3f02a696684e', 'QUEUED', NULL, '2026-09-11 14:24:19.909+05:30');
INSERT INTO public.kot_status_history VALUES ('6e4da1af-7ef9-446b-991d-e000a72ef1b4', '81985f31-1b69-4a6a-abf8-6c0a638dcf02', 'QUEUED', NULL, '2026-09-11 14:25:28.551+05:30');
INSERT INTO public.kot_status_history VALUES ('a76487b1-e3bd-4767-aa40-c13c5e6ec56f', '81985f31-1b69-4a6a-abf8-6c0a638dcf02', 'PREPARING', NULL, '2026-09-11 14:42:42.206+05:30');
INSERT INTO public.kot_status_history VALUES ('008e6459-6b6c-4298-8eab-04f1783103e2', '3d8f581a-fd89-4cf7-9704-3f02a696684e', 'PREPARING', NULL, '2026-09-11 14:42:44.136+05:30');
INSERT INTO public.kot_status_history VALUES ('b8b1fc0b-ce16-4cb4-a326-00ba85c27191', '3d8f581a-fd89-4cf7-9704-3f02a696684e', 'READY', NULL, '2026-09-11 14:43:18.67+05:30');
INSERT INTO public.kot_status_history VALUES ('de6452cd-1452-4d84-baec-267fb6c35928', '81985f31-1b69-4a6a-abf8-6c0a638dcf02', 'READY', NULL, '2026-09-11 14:44:25.853+05:30');
INSERT INTO public.kot_status_history VALUES ('3b32a8b1-5498-4d5f-8069-d6ea420929cd', 'ce6781a5-807c-4628-922f-b4783e87adf0', 'PREPARING', NULL, '2026-09-11 16:21:03.301+05:30');
INSERT INTO public.kot_status_history VALUES ('dcab1a5a-3e21-4e20-a272-d5c362258468', 'ce6781a5-807c-4628-922f-b4783e87adf0', 'READY', NULL, '2026-09-11 16:21:07.383+05:30');
INSERT INTO public.kot_status_history VALUES ('7a197fb5-bb97-452f-aed4-53192615bfd5', 'ce6781a5-807c-4628-922f-b4783e87adf0', 'SERVED', NULL, '2026-09-11 16:21:08.581+05:30');
INSERT INTO public.kot_status_history VALUES ('31fc2be9-240a-4463-9fe7-f694c6341caa', '7b921377-29d0-4537-a67a-bddf6caeb385', 'PREPARING', NULL, '2026-09-11 16:21:23.177+05:30');
INSERT INTO public.kot_status_history VALUES ('47d038c4-43e5-42c0-bcbd-7b5138cc7482', 'cf12e201-ceb6-40ba-a0f4-fe1b0e5aac61', 'QUEUED', NULL, '2026-09-11 16:39:37.859+05:30');
INSERT INTO public.kot_status_history VALUES ('04610a13-2f59-4a4d-9573-c8fd0c0667da', 'cf12e201-ceb6-40ba-a0f4-fe1b0e5aac61', 'PREPARING', NULL, '2026-09-11 16:40:00.765+05:30');
INSERT INTO public.kot_status_history VALUES ('7d161d88-dac8-4073-b9ae-c71f502043dd', 'cf12e201-ceb6-40ba-a0f4-fe1b0e5aac61', 'READY', NULL, '2026-09-11 16:40:04.015+05:30');
INSERT INTO public.kot_status_history VALUES ('6ddb4bed-cc44-46e5-a046-40dac780181a', '7b921377-29d0-4537-a67a-bddf6caeb385', 'READY', NULL, '2026-09-11 16:40:05.229+05:30');
INSERT INTO public.kot_status_history VALUES ('48043e47-67df-493e-a7d1-649c596d31df', 'cf12e201-ceb6-40ba-a0f4-fe1b0e5aac61', 'SERVED', NULL, '2026-09-12 12:11:28.271+05:30');
INSERT INTO public.kot_status_history VALUES ('5de19662-ea3b-487b-89d5-b3fb7b16afc1', '7b921377-29d0-4537-a67a-bddf6caeb385', 'SERVED', NULL, '2026-09-12 15:31:15.358+05:30');
INSERT INTO public.kot_status_history VALUES ('5170df3d-64ad-43be-963f-5da05b69c44e', '419da55d-d450-436d-9e7a-6f8cc0cb751a', 'QUEUED', NULL, '2026-09-12 16:04:39.682+05:30');
INSERT INTO public.kot_status_history VALUES ('243e24cd-bf90-4de2-ae10-5e0fc34fb8e6', '419da55d-d450-436d-9e7a-6f8cc0cb751a', 'PREPARING', NULL, '2026-09-12 16:05:26.033+05:30');
INSERT INTO public.kot_status_history VALUES ('94d9a047-861e-4094-9fd8-8ebd6df1f425', '419da55d-d450-436d-9e7a-6f8cc0cb751a', 'READY', NULL, '2026-09-12 16:05:27.996+05:30');
INSERT INTO public.kot_status_history VALUES ('840c123d-ff93-4f06-a968-f40a1ce6028f', '419da55d-d450-436d-9e7a-6f8cc0cb751a', 'SERVED', NULL, '2026-09-12 16:05:29.964+05:30');
INSERT INTO public.kot_status_history VALUES ('fa8382fd-eb39-410a-b27e-33bcf912d8fe', '1a8e73d0-d3a5-4d51-974f-2f255be03cb9', 'QUEUED', NULL, '2026-09-12 16:20:51.9+05:30');
INSERT INTO public.kot_status_history VALUES ('a93728a3-242a-4a4b-a1bb-3fa1c66df15a', '1a8e73d0-d3a5-4d51-974f-2f255be03cb9', 'PREPARING', NULL, '2026-09-12 16:21:25.258+05:30');
INSERT INTO public.kot_status_history VALUES ('ae421f87-749d-477f-a504-6e9de35af192', '1a8e73d0-d3a5-4d51-974f-2f255be03cb9', 'READY', NULL, '2026-09-12 16:21:26.207+05:30');
INSERT INTO public.kot_status_history VALUES ('a5451306-b0f1-4515-b3c8-85d104f4501a', '1a8e73d0-d3a5-4d51-974f-2f255be03cb9', 'SERVED', NULL, '2026-09-12 16:21:26.88+05:30');
INSERT INTO public.kot_status_history VALUES ('909cfd3e-2507-453b-b6cc-5d92399a02c7', 'a834cfdd-33c9-4650-bc7f-23a9b7168809', 'QUEUED', NULL, '2026-09-12 16:22:09.533+05:30');
INSERT INTO public.kot_status_history VALUES ('022bc0a2-73dd-4c40-af3c-a0a6ee54c4cf', 'a834cfdd-33c9-4650-bc7f-23a9b7168809', 'PREPARING', NULL, '2026-09-12 16:22:21.721+05:30');
INSERT INTO public.kot_status_history VALUES ('a794b270-e2c9-478d-8785-1419d533a1f8', 'a834cfdd-33c9-4650-bc7f-23a9b7168809', 'READY', NULL, '2026-09-12 16:22:22.826+05:30');
INSERT INTO public.kot_status_history VALUES ('256ce904-867c-4fe5-b385-2b7f4beec9e4', 'a834cfdd-33c9-4650-bc7f-23a9b7168809', 'SERVED', NULL, '2026-09-12 16:22:24.155+05:30');
INSERT INTO public.kot_status_history VALUES ('e1810abb-8c95-47dc-8fb8-cd8e6f644521', 'c0b2c455-e902-4758-b2aa-dda79c0fd74e', 'QUEUED', NULL, '2026-09-12 16:23:25.036+05:30');
INSERT INTO public.kot_status_history VALUES ('f15f6312-79ea-4d48-820b-38db5754de2a', 'c0b2c455-e902-4758-b2aa-dda79c0fd74e', 'PREPARING', NULL, '2026-09-12 16:35:33.68+05:30');
INSERT INTO public.kot_status_history VALUES ('f7140e69-40db-412b-9af5-2db054665546', 'c0b2c455-e902-4758-b2aa-dda79c0fd74e', 'READY', NULL, '2026-09-12 16:35:34.66+05:30');
INSERT INTO public.kot_status_history VALUES ('4ef7df3c-f681-4342-ae71-9dfd4fd3de90', 'c0b2c455-e902-4758-b2aa-dda79c0fd74e', 'SERVED', NULL, '2026-09-12 16:37:03.951+05:30');
INSERT INTO public.kot_status_history VALUES ('2c34a8d6-af76-454f-bd3c-c63384d6c5d7', 'c77f90c7-f328-45ef-90fa-724c0fb7e829', 'QUEUED', NULL, '2026-09-12 16:37:34.137+05:30');
INSERT INTO public.kot_status_history VALUES ('c4d025fe-c521-4ecc-af51-1d61c535905e', 'c77f90c7-f328-45ef-90fa-724c0fb7e829', 'PREPARING', NULL, '2026-09-12 16:37:56.576+05:30');
INSERT INTO public.kot_status_history VALUES ('d5499cf0-c574-4041-8b1d-54cfdfe41cf1', 'c77f90c7-f328-45ef-90fa-724c0fb7e829', 'READY', NULL, '2026-09-12 16:38:02.755+05:30');
INSERT INTO public.kot_status_history VALUES ('fbbefca1-bbe2-4dd7-b418-e668dc892d84', 'c77f90c7-f328-45ef-90fa-724c0fb7e829', 'SERVED', NULL, '2026-09-12 16:38:07.877+05:30');
INSERT INTO public.kot_status_history VALUES ('1e6b0c30-b009-435e-9944-1060fd8bcbdd', '2ff59c9f-4c88-49f9-923a-67919ab78b59', 'QUEUED', NULL, '2026-09-12 16:40:24.187+05:30');
INSERT INTO public.kot_status_history VALUES ('74e5c922-e8f8-4cd3-af0d-fef60b470e87', '2ff59c9f-4c88-49f9-923a-67919ab78b59', 'PREPARING', NULL, '2026-09-12 17:22:29.971+05:30');


--
-- Data for Name: kot_tickets; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.kot_tickets VALUES ('2464b135-bbe4-4f70-b8e9-e8ec09e036bb', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'c69c7c36-7b05-4ca7-9012-710df44ed6fd', 'eebe76a3-8305-409d-877b-bb5a0e2b7328', 'KOT-101', 'QUEUED', '2026-09-03 12:29:17.516623+05:30', '2026-09-03 12:29:17.516623+05:30', NULL, NULL);
INSERT INTO public.kot_tickets VALUES ('4d46fa43-e341-4fe6-9c52-8134a1afafbc', '11111111-1111-1111-1111-111111111111', '2d4b655e-a5bf-4900-ba0c-11e1b3c2685c', NULL, 'KOT-1788938506702-145', 'SERVED', '2026-09-09 12:51:46.702+05:30', '2026-09-09 12:55:08.897+05:30', '2026-09-09 12:55:08.898+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('b7760cd0-9b35-44ed-b588-ac6b42eef3d4', '11111111-1111-1111-1111-111111111111', '2d4b655e-a5bf-4900-ba0c-11e1b3c2685c', NULL, 'KOT-1788938488116-476', 'SERVED', '2026-09-09 12:51:28.116+05:30', '2026-09-09 12:55:08.9+05:30', '2026-09-09 12:55:08.9+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('66f4fcaf-d7cd-47ee-b09a-d369f60b44fb', '11111111-1111-1111-1111-111111111111', '2d4b655e-a5bf-4900-ba0c-11e1b3c2685c', NULL, 'KOT-1788938474271-433', 'SERVED', '2026-09-09 12:51:14.272+05:30', '2026-09-09 12:55:08.902+05:30', '2026-09-09 12:55:08.902+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('1a483a59-4b70-4a21-a78c-e4566f492aa7', '11111111-1111-1111-1111-111111111111', '71ef893c-0ccc-439d-bc3e-0a248037303b', NULL, 'KOT-1788425751927-486', 'SERVED', '2026-09-03 14:25:51.929+05:30', '2026-09-03 14:45:03.144+05:30', '2026-09-03 14:45:03.142+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('80f4fd60-0398-4b9a-b31c-ee251b10bebc', '11111111-1111-1111-1111-111111111111', '4a3e148b-1df0-46f8-a71a-c834486429e5', NULL, 'KOT-1788425394652-496', 'SERVED', '2026-09-03 14:19:54.656+05:30', '2026-09-03 14:45:23.361+05:30', '2026-09-03 14:45:23.359+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('7ac440d2-529b-4a22-80da-07c102b52bcd', '11111111-1111-1111-1111-111111111111', 'e93358df-ec3b-4e3b-a241-8e93bd953411', NULL, 'KOT-1788425476212-820', 'SERVED', '2026-09-03 14:21:16.214+05:30', '2026-09-04 00:40:27.999+05:30', '2026-09-04 00:40:27.996+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('d0e620ed-a0fc-4793-a60e-0eee6f19dd09', '11111111-1111-1111-1111-111111111111', 'e7eccfdc-02d5-470f-869b-da665f7dcb2e', NULL, 'KOT-1788427391905-950', 'SERVED', '2026-09-03 14:53:11.907+05:30', '2026-09-04 00:40:29.299+05:30', '2026-09-04 00:40:29.297+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('35412261-a6db-4503-abb2-74ee5bd5db84', '11111111-1111-1111-1111-111111111111', 'f973888e-e429-473a-8566-ddea7ac708a0', NULL, 'KOT-1788938551701-831', 'SERVED', '2026-09-09 12:52:31.703+05:30', '2026-09-09 13:49:00.592+05:30', '2026-09-09 13:49:00.591+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('d8cf458f-c314-4de9-8fd0-534915e77a5a', '11111111-1111-1111-1111-111111111111', '2d4b655e-a5bf-4900-ba0c-11e1b3c2685c', NULL, 'KOT-1788938756572-585', 'SERVED', '2026-09-09 12:55:56.573+05:30', '2026-09-09 13:49:01.064+05:30', '2026-09-09 13:49:01.064+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('2ae3bb5c-9171-4f02-8aec-88611bd9216a', '11111111-1111-1111-1111-111111111111', '190ec2cb-fb90-44c2-ad76-b32672063fdb', NULL, 'KOT-1788939085214-126', 'SERVED', '2026-09-09 13:01:25.213+05:30', '2026-09-09 13:49:01.483+05:30', '2026-09-09 13:49:01.483+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('0a8cc3a0-92d2-4f37-b85f-1818a5d433c7', '11111111-1111-1111-1111-111111111111', '4e192b03-6942-454a-a9dd-9084d99362b1', NULL, 'KOT-1788939122261-731', 'SERVED', '2026-09-09 13:02:02.263+05:30', '2026-09-09 13:49:02.056+05:30', '2026-09-09 13:49:02.055+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('e41f4c53-4fb8-467b-b40e-4a53b8479164', '11111111-1111-1111-1111-111111111111', '9528cbcc-5873-41a3-b142-53165932bc70', NULL, 'KOT-1788939123769-457', 'SERVED', '2026-09-09 13:02:03.771+05:30', '2026-09-09 13:49:02.535+05:30', '2026-09-09 13:49:02.534+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('fce3d545-2638-41d6-b6f3-f8a0683e9150', '11111111-1111-1111-1111-111111111111', '39f6e5e8-3eb1-4100-a8cc-4dfcb49ba060', NULL, 'KOT-1788939217898-804', 'SERVED', '2026-09-09 13:03:37.9+05:30', '2026-09-09 13:49:03.038+05:30', '2026-09-09 13:49:03.038+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('da6358fd-b56e-4bad-bcc0-0af0ec94b26b', '11111111-1111-1111-1111-111111111111', '118a762d-2cc4-4b94-b0c6-1b7360cd6652', NULL, 'KOT-1788939219401-686', 'SERVED', '2026-09-09 13:03:39.401+05:30', '2026-09-09 13:49:03.609+05:30', '2026-09-09 13:49:03.609+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('476f5980-0930-496c-8c4a-9eaf395a75cf', '11111111-1111-1111-1111-111111111111', '5583e31e-48a5-435a-936e-aba2f8bb9c9c', NULL, 'KOT-1788428840273-961', 'SERVED', '2026-09-03 15:17:20.278+05:30', '2026-09-04 00:43:39.252+05:30', '2026-09-04 00:43:39.248+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('aaeb22ca-77d9-4125-93fb-ffaddabfd1ab', '11111111-1111-1111-1111-111111111111', 'e7eccfdc-02d5-470f-869b-da665f7dcb2e', NULL, 'KOT-1788460364867-616', 'SERVED', '2026-09-04 00:02:44.87+05:30', '2026-09-04 00:43:39.85+05:30', '2026-09-04 00:43:39.847+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('780db29f-b971-4fb9-a7c4-e45ad3fe81f4', '11111111-1111-1111-1111-111111111111', '0f621958-d193-4d99-b6ef-037fcea9cd0a', NULL, 'KOT-1788460522360-838', 'SERVED', '2026-09-04 00:05:22.366+05:30', '2026-09-04 00:43:40.459+05:30', '2026-09-04 00:43:40.456+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('314f59d3-358c-4d0d-82ce-e2348b2f5869', '11111111-1111-1111-1111-111111111111', 'a00d57c3-c01d-49d0-9166-45e9f7e22497', NULL, 'KOT-1788462655753-584', 'SERVED', '2026-09-04 00:40:55.756+05:30', '2026-09-04 00:43:46.597+05:30', '2026-09-04 00:43:46.594+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('f72e5dc0-f56e-451b-a014-cd4419cacbdf', '11111111-1111-1111-1111-111111111111', '0f621958-d193-4d99-b6ef-037fcea9cd0a', NULL, 'KOT-1788460557388-73', 'SERVED', '2026-09-04 00:05:57.393+05:30', '2026-09-04 00:44:05.586+05:30', '2026-09-04 00:44:05.583+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('9a5c4cc8-4b11-4022-b5c1-6d4bedb3b01b', '11111111-1111-1111-1111-111111111111', 'ece12171-62db-4f53-ba97-d5e93e06f733', NULL, 'KOT-1788464073375-875', 'SERVED', '2026-09-04 01:04:33.377+05:30', '2026-09-04 01:06:00.06+05:30', '2026-09-04 01:06:00.055+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('e0c7eff8-6e10-43b7-bc2a-9be10a9a091b', '11111111-1111-1111-1111-111111111111', 'a00d57c3-c01d-49d0-9166-45e9f7e22497', NULL, 'KOT-1788594595679-758', 'SERVED', '2026-09-05 13:19:55.685+05:30', '2026-09-05 13:20:37.742+05:30', '2026-09-05 13:20:37.737+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('39863209-183e-4007-a67f-cf22d00609b9', '11111111-1111-1111-1111-111111111111', '0a746ebb-ff2b-40d1-8d00-5e7652f56006', NULL, 'KOT-1788944246222-39', 'SERVED', '2026-09-09 14:27:26.23+05:30', '2026-09-09 15:08:54.408+05:30', '2026-09-09 15:08:54.407+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('022f9506-96ce-4851-b531-11b374d9f3eb', '11111111-1111-1111-1111-111111111111', '0f3580d0-cceb-4289-99f8-5ffdf1669b18', NULL, 'KOT-1788601212640-908', 'SERVED', '2026-09-05 15:10:12.642+05:30', '2026-09-05 15:10:12.831+05:30', '2026-09-05 15:10:12.83+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('3a8544bd-e646-4dca-a8aa-4451fcfcc675', '11111111-1111-1111-1111-111111111111', '0a746ebb-ff2b-40d1-8d00-5e7652f56006', NULL, 'KOT-1788944745631-571', 'SERVED', '2026-09-09 14:35:45.633+05:30', '2026-09-09 15:08:54.408+05:30', '2026-09-09 15:08:54.407+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('1a8d8383-c9bc-481e-8700-176bf3b7c38b', '11111111-1111-1111-1111-111111111111', 'c3a366cb-039e-4e26-9cbd-8e22cd2d52b9', NULL, 'KOT-1788605558225-814', 'SERVED', '2026-09-05 16:22:38.227+05:30', '2026-09-05 16:23:36.489+05:30', '2026-09-05 16:23:36.487+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('187ed388-52c9-4d73-bfa6-e4f96d3f8f51', '67315042-c687-4cbb-b45a-f4ea4efc199f', '5b433b06-af43-4f62-8a6b-e2ca1e0bfa88', 'eebe76a3-8305-409d-877b-bb5a0e2b7328', 'KOT-1788606942054-867', 'SERVED', '2026-09-05 16:45:42.059+05:30', '2026-09-05 16:45:42.161+05:30', '2026-09-05 16:45:42.16+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('5b4062b9-77fe-4305-b776-65b479de232f', '11111111-1111-1111-1111-111111111111', '3e1ba9c8-0311-4534-a8d3-fa97b3a4f933', NULL, 'KOT-1788946760406-281', 'SERVED', '2026-09-09 15:09:20.407+05:30', '2026-09-10 16:49:54.854+05:30', '2026-09-10 16:49:54.852+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('5d32816c-fd4d-4bb9-8a24-2180b08fa1b8', '11111111-1111-1111-1111-111111111111', '7a369854-faf1-4af3-8378-8b939249c434', NULL, 'KOT-1788607292753-642', 'SERVED', '2026-09-05 16:51:32.755+05:30', '2026-09-05 16:51:32.895+05:30', '2026-09-05 16:51:32.894+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('4a1fae02-9a34-4e15-a9b9-bcd4df784612', '11111111-1111-1111-1111-111111111111', '82e2a068-a74a-4e18-89fe-7a423f5b243f', NULL, 'KOT-1788608155002-507', 'SERVED', '2026-09-05 17:05:55.005+05:30', '2026-09-05 17:14:44.776+05:30', '2026-09-05 17:14:44.769+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('91c40700-9ebf-4753-b454-24ddf11da7f9', '11111111-1111-1111-1111-111111111111', '1085cebe-ebf0-4804-83f3-aae6d0d4a7c9', NULL, 'KOT-1788845704410-425', 'SERVED', '2026-09-08 11:05:04.422+05:30', '2026-09-08 11:05:57.608+05:30', '2026-09-08 11:05:57.593+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('e566733f-ccfd-4fa4-b750-c96cde787323', '11111111-1111-1111-1111-111111111111', '3e1ba9c8-0311-4534-a8d3-fa97b3a4f933', NULL, 'KOT-1789039253111-173', 'SERVED', '2026-09-10 16:50:53.114+05:30', '2026-09-10 16:52:36.085+05:30', '2026-09-10 16:52:36.08+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('a05cc85f-571d-457d-8fb9-2736dd584304', '11111111-1111-1111-1111-111111111111', '1085cebe-ebf0-4804-83f3-aae6d0d4a7c9', NULL, 'KOT-1788845941399-145', 'SERVED', '2026-09-08 11:09:01.401+05:30', '2026-09-08 11:09:26.515+05:30', '2026-09-08 11:09:26.513+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('0b2b03d2-b645-49b9-8644-1a36bc48a18a', '11111111-1111-1111-1111-111111111111', '482d35cd-b7b6-4c65-a7f3-943897646bad', NULL, 'KOT-1788944338361-266', 'SERVED', '2026-09-09 14:28:58.379+05:30', '2026-09-11 11:09:55.37+05:30', '2026-09-11 11:09:55.368+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('6263318d-e12b-43cf-9c36-9ee3f17e597e', '11111111-1111-1111-1111-111111111111', 'e7d4d6cf-4838-43bd-8334-688d11302496', NULL, 'KOT-1788846126986-164', 'SERVED', '2026-09-08 11:12:06.988+05:30', '2026-09-08 11:12:15.011+05:30', '2026-09-08 11:12:15.009+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('38d4de12-7ca2-48b6-8856-15027f1d154b', '11111111-1111-1111-1111-111111111111', 'e7d4d6cf-4838-43bd-8334-688d11302496', NULL, 'KOT-1788598579158-620', 'SERVED', '2026-09-05 14:26:19.16+05:30', '2026-09-08 11:14:49.108+05:30', '2026-09-08 11:14:49.107+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('00089db3-43f2-4348-bbff-da57724bc4eb', '11111111-1111-1111-1111-111111111111', 'b5177d27-2e27-4abd-8296-83a748730b2c', NULL, 'KOT-1788464996543-783', 'SERVED', '2026-09-04 01:19:56.545+05:30', '2026-09-08 13:11:42.27+05:30', '2026-09-08 13:11:42.266+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('4ff03eac-fde7-4266-96fe-a868df825efd', '11111111-1111-1111-1111-111111111111', '25ab98b4-6057-4986-a634-4dd7dc5f51bc', NULL, 'KOT-1788944383560-965', 'SERVED', '2026-09-09 14:29:43.563+05:30', '2026-09-11 11:10:04.49+05:30', '2026-09-11 11:10:04.488+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('15cb65ba-80c2-48ed-883e-dbeb46d9dcda', '11111111-1111-1111-1111-111111111111', '65505588-f509-44ef-a6c6-c488503dcbe3', NULL, 'KOT-1788944474683-706', 'SERVED', '2026-09-09 14:31:14.686+05:30', '2026-09-11 11:10:05.976+05:30', '2026-09-11 11:10:05.974+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('2b9b7a79-3fc2-4a24-ab97-ff472596e66b', '11111111-1111-1111-1111-111111111111', 'eb13fd97-c972-4447-8a42-898eb545191e', NULL, 'KOT-1788853394931-883', 'SERVED', '2026-09-08 13:13:14.936+05:30', '2026-09-08 13:13:48.585+05:30', '2026-09-08 13:13:48.581+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('4728ca77-caa1-49de-a309-254613a1cad3', '11111111-1111-1111-1111-111111111111', 'f5d3449d-ce21-48cb-ab01-b41c41a7301c', NULL, 'KOT-1788853455306-197', 'SERVED', '2026-09-08 13:14:15.312+05:30', '2026-09-08 13:15:08.735+05:30', '2026-09-08 13:15:08.733+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('2508d470-13d4-4db2-a796-75774ccb80c2', '11111111-1111-1111-1111-111111111111', 'c182470d-5000-40bc-86f8-b9093c4333e8', NULL, 'KOT-1788944253896-633', 'SERVED', '2026-09-09 14:27:33.901+05:30', '2026-09-11 11:10:15.592+05:30', '2026-09-11 11:10:15.591+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('d2d5e040-193a-4e9a-ab00-8ba1614f5266', '11111111-1111-1111-1111-111111111111', 'f5d3449d-ce21-48cb-ab01-b41c41a7301c', NULL, 'KOT-1788857069254-796', 'SERVED', '2026-09-08 14:14:29.258+05:30', '2026-09-08 14:15:27.391+05:30', '2026-09-08 14:15:27.39+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('c3b2a555-0bb8-4140-aa3b-16a067935d7f', '11111111-1111-1111-1111-111111111111', 'b101f725-9679-4cf3-9f0f-16adb200ecff', NULL, 'KOT-1788857844467-286', 'SERVED', '2026-09-08 14:27:24.476+05:30', '2026-09-08 14:39:22.765+05:30', '2026-09-08 14:39:22.764+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('ecb0bac6-06b0-4a59-b4d7-8c2c1686dc67', '11111111-1111-1111-1111-111111111111', 'b6abe3e6-d0e7-4dc7-a631-097181effc3a', NULL, 'KOT-1788944519392-132', 'SERVED', '2026-09-09 14:31:59.395+05:30', '2026-09-11 11:10:55.568+05:30', '2026-09-11 11:10:55.567+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('fc89f774-0dc4-4795-9f68-edd8df66905c', '11111111-1111-1111-1111-111111111111', 'd71091c4-71f0-4c75-bd38-c6b08ba4dd4a', NULL, 'KOT-1788944568922-805', 'SERVED', '2026-09-09 14:32:48.928+05:30', '2026-09-11 11:10:56.51+05:30', '2026-09-11 11:10:56.509+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('933f4133-630c-48df-b056-4502946eb0ae', '11111111-1111-1111-1111-111111111111', 'd1467f47-4869-4592-996e-0d3f373ec018', NULL, 'KOT-1788944641538-490', 'SERVED', '2026-09-09 14:34:01.542+05:30', '2026-09-11 11:10:57.334+05:30', '2026-09-11 11:10:57.332+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('753c5eb7-0772-4082-b9ea-3cbff53d0f1d', '11111111-1111-1111-1111-111111111111', '685aa7a6-e1d4-4a39-a7fe-c54252180927', NULL, 'KOT-1788858713606-875', 'SERVED', '2026-09-08 14:41:53.608+05:30', '2026-09-08 14:44:38.641+05:30', '2026-09-08 14:44:38.639+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('7c360f83-927b-4dea-9514-b7815a12a4f5', '11111111-1111-1111-1111-111111111111', '27f9f630-3e8b-4ba9-b4d7-e631e45182f7', NULL, 'KOT-1789108786371-254', 'SERVED', '2026-09-11 12:09:46.376+05:30', '2026-09-11 12:34:03.69+05:30', '2026-09-11 12:34:03.683+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('97823311-3165-4981-bb4a-f701b6c54e81', '11111111-1111-1111-1111-111111111111', 'f5d3449d-ce21-48cb-ab01-b41c41a7301c', NULL, 'KOT-1788864567309-211', 'SERVED', '2026-09-08 16:19:27.314+05:30', '2026-09-08 16:19:42.456+05:30', '2026-09-08 16:19:42.451+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('387bfcae-81d2-4138-b9af-783ed452a554', '11111111-1111-1111-1111-111111111111', '76692730-cd05-45cd-b8ad-9cc20ac9fc5a', NULL, 'KOT-1788860625124-162', 'SERVED', '2026-09-08 15:13:45.127+05:30', '2026-09-09 12:45:15.881+05:30', '2026-09-09 12:45:15.879+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('cde85ae8-efc8-4329-9983-c65db7879821', '11111111-1111-1111-1111-111111111111', '0602cb47-3398-4ba0-b5da-87e23909efa3', NULL, 'KOT-1788938250797-418', 'SERVED', '2026-09-09 12:47:30.797+05:30', '2026-09-09 12:50:26.93+05:30', '2026-09-09 12:50:26.931+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('4a26f71a-500e-456d-a69b-5dc7529906e8', '11111111-1111-1111-1111-111111111111', '0602cb47-3398-4ba0-b5da-87e23909efa3', NULL, 'KOT-1788938270736-697', 'SERVED', '2026-09-09 12:47:50.738+05:30', '2026-09-09 12:50:27.439+05:30', '2026-09-09 12:50:27.44+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('0d5f81a3-df18-49f4-92ac-ca9b95a7273f', '11111111-1111-1111-1111-111111111111', '0602cb47-3398-4ba0-b5da-87e23909efa3', NULL, 'KOT-1788938304617-426', 'SERVED', '2026-09-09 12:48:24.617+05:30', '2026-09-09 12:50:27.704+05:30', '2026-09-09 12:50:27.705+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('da54b04f-218d-441e-91d5-44e74856c1c6', '11111111-1111-1111-1111-111111111111', '0602cb47-3398-4ba0-b5da-87e23909efa3', NULL, 'KOT-1788938363892-994', 'SERVED', '2026-09-09 12:49:23.892+05:30', '2026-09-09 12:50:28.164+05:30', '2026-09-09 12:50:28.165+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('a8088c10-855e-46d2-bc70-3b2bda97e583', '11111111-1111-1111-1111-111111111111', 'c8387bcf-ab67-44bb-87fb-d67f6d7601ca', NULL, 'KOT-1789110207254-720', 'SERVED', '2026-09-11 12:33:27.256+05:30', '2026-09-11 12:33:47.94+05:30', '2026-09-11 12:33:47.938+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('d3d5de47-7715-4e5a-9036-ec18153e7a81', '67315042-c687-4cbb-b45a-f4ea4efc199f', '0c7bc59e-d90f-4a42-873f-88c0e9a02386', 'eebe76a3-8305-409d-877b-bb5a0e2b7328', 'KOT-1789116128752-721', 'QUEUED', '2026-09-11 14:12:08.758+05:30', '2026-09-11 14:12:08.758+05:30', NULL, NULL);
INSERT INTO public.kot_tickets VALUES ('a41ba409-8e7a-451d-b1d0-413fb105d4de', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'f9b4ac11-21c8-4617-9a1d-f1d7e8147a37', 'eebe76a3-8305-409d-877b-bb5a0e2b7328', 'KOT-1789116367351-377', 'QUEUED', '2026-09-11 14:16:07.363+05:30', '2026-09-11 14:16:07.363+05:30', NULL, NULL);
INSERT INTO public.kot_tickets VALUES ('63992e13-1fb0-4e62-8a36-596aa86d78ee', '67315042-c687-4cbb-b45a-f4ea4efc199f', '829e83e6-ea56-4173-bfe2-463b24e497a4', 'eebe76a3-8305-409d-877b-bb5a0e2b7328', 'KOT-1789116547479-481', 'QUEUED', '2026-09-11 14:19:07.484+05:30', '2026-09-11 14:19:07.484+05:30', NULL, NULL);
INSERT INTO public.kot_tickets VALUES ('81985f31-1b69-4a6a-abf8-6c0a638dcf02', '11111111-1111-1111-1111-111111111111', '4a4e9d6c-a797-4b03-9835-a44526c890e2', NULL, 'KOT-1789116928541-810', 'SERVED', '2026-09-11 14:25:28.546+05:30', '2026-09-11 14:44:32.316+05:30', '2026-09-11 14:44:32.314+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('3d8f581a-fd89-4cf7-9704-3f02a696684e', '11111111-1111-1111-1111-111111111111', '89dba099-01ad-417a-a438-66ca8af5e712', NULL, 'KOT-1789116859902-926', 'SERVED', '2026-09-11 14:24:19.904+05:30', '2026-09-11 14:44:37.606+05:30', '2026-09-11 14:44:37.605+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('ce6781a5-807c-4628-922f-b4783e87adf0', '11111111-1111-1111-1111-111111111111', 'd8d53271-b231-47e9-93aa-7a47185f8940', NULL, 'KOT-1789111770656-832', 'SERVED', '2026-09-11 12:59:30.66+05:30', '2026-09-11 16:21:08.576+05:30', '2026-09-11 16:21:08.568+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('cf12e201-ceb6-40ba-a0f4-fe1b0e5aac61', '11111111-1111-1111-1111-111111111111', '4a4e9d6c-a797-4b03-9835-a44526c890e2', NULL, 'KOT-1789124977852-940', 'SERVED', '2026-09-11 16:39:37.855+05:30', '2026-09-12 12:11:28.259+05:30', '2026-09-12 12:11:28.257+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('7b921377-29d0-4537-a67a-bddf6caeb385', '11111111-1111-1111-1111-111111111111', 'ccffe940-9f6b-41af-aaeb-72b3e1cdb3da', NULL, 'KOT-1789111792837-509', 'SERVED', '2026-09-11 12:59:52.84+05:30', '2026-09-12 15:31:15.352+05:30', '2026-09-12 15:31:15.344+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('419da55d-d450-436d-9e7a-6f8cc0cb751a', '11111111-1111-1111-1111-111111111111', 'abaed738-9e4f-4470-ae04-031b3baa4721', NULL, 'KOT-1789209279636-845', 'SERVED', '2026-09-12 16:04:39.64+05:30', '2026-09-12 16:05:29.959+05:30', '2026-09-12 16:05:29.956+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('1a8e73d0-d3a5-4d51-974f-2f255be03cb9', '11111111-1111-1111-1111-111111111111', '8139a10d-c414-4402-818c-ea00cfd5e786', NULL, 'KOT-1789210251891-531', 'SERVED', '2026-09-12 16:20:51.894+05:30', '2026-09-12 16:21:26.874+05:30', '2026-09-12 16:21:26.872+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('a834cfdd-33c9-4650-bc7f-23a9b7168809', '11111111-1111-1111-1111-111111111111', '547361f1-ab65-4eeb-b5ae-790378f1eebc', NULL, 'KOT-1789210329524-699', 'SERVED', '2026-09-12 16:22:09.527+05:30', '2026-09-12 16:22:24.15+05:30', '2026-09-12 16:22:24.148+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('c0b2c455-e902-4758-b2aa-dda79c0fd74e', '11111111-1111-1111-1111-111111111111', '7bf0131c-f022-46a1-9a7b-8569cd3682f8', NULL, 'KOT-1789210405030-600', 'SERVED', '2026-09-12 16:23:25.032+05:30', '2026-09-12 16:37:03.947+05:30', '2026-09-12 16:37:03.943+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('c77f90c7-f328-45ef-90fa-724c0fb7e829', '11111111-1111-1111-1111-111111111111', '7bf0131c-f022-46a1-9a7b-8569cd3682f8', NULL, 'KOT-1789211254122-386', 'SERVED', '2026-09-12 16:37:34.13+05:30', '2026-09-12 16:38:07.872+05:30', '2026-09-12 16:38:07.864+05:30', NULL);
INSERT INTO public.kot_tickets VALUES ('2ff59c9f-4c88-49f9-923a-67919ab78b59', '11111111-1111-1111-1111-111111111111', '815fbab6-72c9-41f6-b104-3f8df856c545', NULL, 'KOT-1789211424179-539', 'PREPARING', '2026-09-12 16:40:24.181+05:30', '2026-09-12 17:22:29.969+05:30', NULL, NULL);


--
-- Data for Name: ledger_entries; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.ledger_entries VALUES ('5ff3fac8-cdbd-4ad9-abf4-99b93a9e444d', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'SETTLEMENT', 'OPENING-BAL-1010-CASH', '1010-CASH', 500000, 0, 'OPENING-VOUCHER-1010-CASH', 'POSTED', '2026-09-02 16:32:45.63+05:30', '2026-09-02 16:32:45.611+05:30');
INSERT INTO public.ledger_entries VALUES ('dfb55280-15c6-440f-b40f-b0f1f4e17223', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'SETTLEMENT', 'OPENING-BAL-1020-BANK-HDFC', '1020-BANK-HDFC', 2500000, 0, 'OPENING-VOUCHER-1020-BANK-HDFC', 'POSTED', '2026-09-02 16:32:45.637+05:30', '2026-09-02 16:32:45.621+05:30');
INSERT INTO public.ledger_entries VALUES ('8e262bcb-1177-4c1d-8445-bec4b8eb63f3', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'SETTLEMENT', 'OPENING-BAL-EQUITY', '3010-OWNERS-CAPITAL', 0, 3000000, 'OPENING-VOUCHER-EQUITY', 'POSTED', '2026-09-02 16:32:45.64+05:30', '2026-09-02 16:32:45.624+05:30');


--
-- Data for Name: loyalty_accounts; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.loyalty_accounts VALUES ('b63b31ed-c666-42e5-979a-b0cf40ab74fa', '724eba8c-0924-4006-9ddb-ca86aa4e96eb', 0, 'SILVER', '2026-09-12 11:38:00.647+05:30', '2026-09-12 11:38:00.647+05:30', NULL, NULL);
INSERT INTO public.loyalty_accounts VALUES ('ef8c8f0d-67d5-42eb-9dfb-fe2081afec22', 'c158b890-ee02-405e-bfb2-57b349e6eeb3', 100, 'SILVER', '2026-09-12 12:03:15.682+05:30', '2026-09-12 12:03:15.682+05:30', NULL, NULL);
INSERT INTO public.loyalty_accounts VALUES ('4bfbb255-1aaf-4d10-8a3f-27a7920fca14', '509bcc9b-7529-497d-b987-29ee463cf67e', 50, 'SILVER', '2026-09-12 12:16:21.117+05:30', '2026-09-12 12:16:21.117+05:30', NULL, NULL);


--
-- Data for Name: marketing_campaigns; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.marketing_campaigns VALUES ('1c31b540-9540-4b01-aadb-f98054d07106', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Weekend Biryani Fest', 'MANUAL', NULL, NULL, 'Enjoy 20% off on all signature biryanis this weekend at Hotel Kapila! Show code BIRYANI20 at billing.', 'ACTIVE', '2026-09-03 12:29:17.44664+05:30', '2026-09-03 12:29:17.44664+05:30', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');


--
-- Data for Name: menu_categories; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.menu_categories VALUES ('60d4a197-f11c-4267-a7de-92220a27dc4b', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Biryani (Veg)', NULL, 1, true, '2026-09-02 15:25:57.433+05:30', '2026-09-02 16:21:33.872+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('8fcde4bd-6deb-4827-b69b-f748741f5aea', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Biryani (Non-Veg)', NULL, 2, true, '2026-09-02 15:25:57.445+05:30', '2026-09-02 16:21:33.877+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('12251ad8-147d-463e-a33a-30daa7aaabf7', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Tandoori Starters (Non-Veg)', NULL, 3, true, '2026-09-02 15:25:57.449+05:30', '2026-09-02 16:21:33.88+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('f718f498-932d-49f6-8b6b-59a29a37e49e', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Chinese Starters (Veg)', NULL, 4, true, '2026-09-02 15:25:57.452+05:30', '2026-09-02 16:21:33.884+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('afca0de8-7edc-4f29-93a4-17fcdce5e27e', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Curries (Non-Veg)', NULL, 5, true, '2026-09-02 15:25:57.456+05:30', '2026-09-02 16:21:33.888+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('a49cfb2b-5641-43b5-ae43-96d0d1b55be1', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Roti & Breads', NULL, 6, true, '2026-09-02 15:25:57.459+05:30', '2026-09-02 16:21:33.892+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('2a4082ac-2df2-422b-b7f9-cf96755949f3', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Cold Beverage', NULL, 7, true, '2026-09-02 15:25:57.462+05:30', '2026-09-02 16:21:33.896+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('735379c7-6bd9-4ed0-be64-40d8bf1e7de8', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'MOCKTAILS', NULL, 8, true, '2026-09-02 15:25:57.465+05:30', '2026-09-02 16:21:33.9+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('68413038-40bc-4f99-988e-7a72c60094e0', '2a543c3c-066f-4097-833a-df7c25700580', 'Breakfast', NULL, 1, true, '2026-09-02 16:33:25.805+05:30', '2026-09-02 16:33:25.805+05:30', 'Traditional South Indian Breakfast');
INSERT INTO public.menu_categories VALUES ('bd5fd925-8442-4a2c-b952-de8a4e0181ee', '2a543c3c-066f-4097-833a-df7c25700580', 'Meal Box (Online)', NULL, 2, true, '2026-09-02 16:33:25.809+05:30', '2026-09-02 16:33:25.809+05:30', 'Combo meal boxes for delivery');
INSERT INTO public.menu_categories VALUES ('814499c3-e704-42df-89ab-5bc9806e2089', '2a543c3c-066f-4097-833a-df7c25700580', 'Cold Beverage', NULL, 3, true, '2026-09-02 16:33:25.814+05:30', '2026-09-02 16:33:25.814+05:30', 'Chilled juices, lassi and soft drinks');
INSERT INTO public.menu_categories VALUES ('da1e0528-b69e-4eaf-b3cc-62429b61e75e', '2a543c3c-066f-4097-833a-df7c25700580', 'Hot Beverages', NULL, 4, true, '2026-09-02 16:33:25.819+05:30', '2026-09-02 16:33:25.819+05:30', 'Filter coffee, tea and soups');
INSERT INTO public.menu_categories VALUES ('b8c64dd2-0140-44b4-a64b-aae3c6c2c9d5', '2a543c3c-066f-4097-833a-df7c25700580', 'Soup(Veg)', NULL, 5, true, '2026-09-02 16:33:25.823+05:30', '2026-09-02 16:33:25.823+05:30', 'Vegetarian hot soups');
INSERT INTO public.menu_categories VALUES ('6ad7a5cf-0734-45b4-a171-aaeba1c44c95', '2a543c3c-066f-4097-833a-df7c25700580', 'Meals', NULL, 6, true, '2026-09-02 16:33:25.826+05:30', '2026-09-02 16:33:25.826+05:30', 'South & North Indian Full Meals');
INSERT INTO public.menu_categories VALUES ('0a99d107-4268-42ed-9f87-a57b16d450e7', '2a543c3c-066f-4097-833a-df7c25700580', 'Chinese Starters (Veg)', NULL, 7, true, '2026-09-02 16:33:25.83+05:30', '2026-09-02 16:33:25.83+05:30', 'Crispy veg appetizers');
INSERT INTO public.menu_categories VALUES ('0b64120a-6ded-4c63-9a87-8dbafd81a1bc', '2a543c3c-066f-4097-833a-df7c25700580', 'Curries (Veg)', NULL, 8, true, '2026-09-02 16:33:25.835+05:30', '2026-09-02 16:33:25.835+05:30', 'Paneer and mixed vegetable curries');
INSERT INTO public.menu_categories VALUES ('ccdac5f4-9e06-4d17-9212-df78bbb3ef2e', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Curries (Veg)', NULL, 0, true, '2026-09-03 13:45:53.250482+05:30', '2026-09-03 13:45:53.250482+05:30', 'Paneer and mixed vegetable curries');
INSERT INTO public.menu_categories VALUES ('ff151b4d-9fe3-4ab1-a0f6-d803109ee432', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Meals', NULL, 0, true, '2026-09-03 13:45:53.2538+05:30', '2026-09-03 13:45:53.2538+05:30', 'South & North Indian Full Meals');
INSERT INTO public.menu_categories VALUES ('6b47802d-d31d-4d52-9c5e-001f4674f85e', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Breakfast', NULL, 0, true, '2026-09-03 13:45:53.255705+05:30', '2026-09-03 13:45:53.255705+05:30', 'Traditional South Indian Breakfast');
INSERT INTO public.menu_categories VALUES ('de6e8b83-db5a-4c10-b432-6b5a66959cc4', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Hot Beverages', NULL, 0, true, '2026-09-03 13:45:53.258576+05:30', '2026-09-03 13:45:53.258576+05:30', 'Filter coffee, tea and soups');
INSERT INTO public.menu_categories VALUES ('2553c114-60e6-4ffd-a050-c41a6c3bf846', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Soup(Veg)', NULL, 0, true, '2026-09-03 13:45:53.261181+05:30', '2026-09-03 13:45:53.261181+05:30', 'Vegetarian hot soups');
INSERT INTO public.menu_categories VALUES ('1541649d-c982-46a7-a228-ad78aba10f6c', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Meal Box (Online)', NULL, 0, true, '2026-09-03 13:45:53.264327+05:30', '2026-09-03 13:45:53.264327+05:30', 'Combo meal boxes for delivery');
INSERT INTO public.menu_categories VALUES ('9f32e838-0597-41ad-97d7-6412c26afe7b', '2a543c3c-066f-4097-833a-df7c25700580', 'Curries (Non-Veg)', NULL, 0, true, '2026-09-03 13:45:53.266154+05:30', '2026-09-03 13:45:53.266154+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('e10d567d-babb-4e94-a79a-eb3a48de4812', '2a543c3c-066f-4097-833a-df7c25700580', 'Biryani (Veg)', NULL, 0, true, '2026-09-03 13:45:53.26789+05:30', '2026-09-03 13:45:53.26789+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('a976ef06-5bbd-4e1a-ba06-59ac9b0a6b84', '2a543c3c-066f-4097-833a-df7c25700580', 'MOCKTAILS', NULL, 0, true, '2026-09-03 13:45:53.269234+05:30', '2026-09-03 13:45:53.269234+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('630f03b9-480d-4107-84e1-57e43df0a45e', '2a543c3c-066f-4097-833a-df7c25700580', 'Roti & Breads', NULL, 0, true, '2026-09-03 13:45:53.270445+05:30', '2026-09-03 13:45:53.270445+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('e4b000a5-48de-44ba-bf02-3929b1f75c89', '2a543c3c-066f-4097-833a-df7c25700580', 'Tandoori Starters (Non-Veg)', NULL, 0, true, '2026-09-03 13:45:53.27349+05:30', '2026-09-03 13:45:53.27349+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('7e99f115-5a4e-404a-880d-118faff89110', '2a543c3c-066f-4097-833a-df7c25700580', 'Biryani (Non-Veg)', NULL, 0, true, '2026-09-03 13:45:53.276495+05:30', '2026-09-03 13:45:53.276495+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('c332c03a-b4ff-4db0-b13f-b241c651abc8', '11111111-1111-1111-1111-111111111111', 'Chinese Starters (Veg)', NULL, 0, true, '2026-09-03 13:45:53.280553+05:30', '2026-09-03 13:45:53.280553+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('9923f0e7-8519-4e37-af76-137a8781e285', '11111111-1111-1111-1111-111111111111', 'Curries (Non-Veg)', NULL, 0, true, '2026-09-03 13:45:53.282132+05:30', '2026-09-03 13:45:53.282132+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('e18291bb-1c6d-426d-a753-c58922a38598', '11111111-1111-1111-1111-111111111111', 'Biryani (Veg)', NULL, 0, true, '2026-09-03 13:45:53.284254+05:30', '2026-09-03 13:45:53.284254+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('226608d8-4b01-406d-a0bc-3da3381efd44', '11111111-1111-1111-1111-111111111111', 'MOCKTAILS', NULL, 0, true, '2026-09-03 13:45:53.286221+05:30', '2026-09-03 13:45:53.286221+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('ef059e72-0460-4ec5-8faf-ca1bd16ce17e', '11111111-1111-1111-1111-111111111111', 'Roti & Breads', NULL, 0, true, '2026-09-03 13:45:53.288073+05:30', '2026-09-03 13:45:53.288073+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('1a8e9f1a-9874-41b3-b04e-dcff9cbd9c52', '11111111-1111-1111-1111-111111111111', 'Curries (Veg)', NULL, 0, true, '2026-09-03 13:45:53.289721+05:30', '2026-09-03 13:45:53.289721+05:30', 'Paneer and mixed vegetable curries');
INSERT INTO public.menu_categories VALUES ('ecde6efc-8c90-4e6c-bac7-c30e1a98089c', '11111111-1111-1111-1111-111111111111', 'Meals', NULL, 0, true, '2026-09-03 13:45:53.290974+05:30', '2026-09-03 13:45:53.290974+05:30', 'South & North Indian Full Meals');
INSERT INTO public.menu_categories VALUES ('bc2819ef-3f7e-4c79-a692-bb059757eeae', '11111111-1111-1111-1111-111111111111', 'Cold Beverage', NULL, 0, true, '2026-09-03 13:45:53.29238+05:30', '2026-09-03 13:45:53.29238+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('a65ebbc1-bfb6-42ce-95cf-112d5a76e825', '11111111-1111-1111-1111-111111111111', 'Breakfast', NULL, 0, true, '2026-09-03 13:45:53.294005+05:30', '2026-09-03 13:45:53.294005+05:30', 'Traditional South Indian Breakfast');
INSERT INTO public.menu_categories VALUES ('00e25236-2c50-4e2b-818d-88c104db92bb', '11111111-1111-1111-1111-111111111111', 'Tandoori Starters (Non-Veg)', NULL, 0, true, '2026-09-03 13:45:53.295872+05:30', '2026-09-03 13:45:53.295872+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('764ab8d6-7220-4bfb-bb9f-23f7d804bc71', '11111111-1111-1111-1111-111111111111', 'Hot Beverages', NULL, 0, true, '2026-09-03 13:45:53.297993+05:30', '2026-09-03 13:45:53.297993+05:30', 'Filter coffee, tea and soups');
INSERT INTO public.menu_categories VALUES ('c6d92d2d-adeb-4d91-b143-097e7b3ef69a', '11111111-1111-1111-1111-111111111111', 'Soup(Veg)', NULL, 0, true, '2026-09-03 13:45:53.300002+05:30', '2026-09-03 13:45:53.300002+05:30', 'Vegetarian hot soups');
INSERT INTO public.menu_categories VALUES ('26fd5701-0ca8-4a3d-8a30-706cca828e47', '11111111-1111-1111-1111-111111111111', 'Biryani (Non-Veg)', NULL, 0, true, '2026-09-03 13:45:53.302347+05:30', '2026-09-03 13:45:53.302347+05:30', NULL);
INSERT INTO public.menu_categories VALUES ('638dcd56-a022-462a-aacc-125069c4a2ad', '11111111-1111-1111-1111-111111111111', 'Meal Box (Online)', NULL, 0, true, '2026-09-03 13:45:53.304648+05:30', '2026-09-03 13:45:53.304648+05:30', 'Combo meal boxes for delivery');
INSERT INTO public.menu_categories VALUES ('989d20e0-a373-49e5-8bba-2863a1c22d60', '11111111-1111-1111-1111-111111111111', 'panipuri', NULL, 0, true, '2026-09-08 11:24:45.221+05:30', '2026-09-08 11:24:45.221+05:30', NULL);


--
-- Data for Name: menu_item_availability; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: menu_item_channel_status; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: menu_items; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.menu_items VALUES ('1048c560-86bd-45c5-b872-eb5e802c6e46', '67315042-c687-4cbb-b45a-f4ea4efc199f', '8fcde4bd-6deb-4827-b69b-f748741f5aea', 'Hotel Kapila Special Chicken Biryani (Boneless)', 'Nizamabad signature boneless fried chicken masala over dum basmati rice.', false, NULL, true, '2026-09-02 16:21:33.908+05:30', '2026-09-02 16:21:33.908+05:30', NULL, NULL, NULL, 5.00, 34000, 100, NULL);
INSERT INTO public.menu_items VALUES ('c4945f10-ab36-4a6a-8388-0a0c4904d9da', '67315042-c687-4cbb-b45a-f4ea4efc199f', '60d4a197-f11c-4267-a7de-92220a27dc4b', 'Hyderabadi Paneer Dum Biryani', 'Fragrant saffron basmati rice layered with spiced paneer cubes and herbs.', true, NULL, true, '2026-09-02 16:21:33.93+05:30', '2026-09-02 16:21:33.93+05:30', NULL, NULL, NULL, 5.00, 28000, 100, NULL);
INSERT INTO public.menu_items VALUES ('7455214f-4d3e-495e-a9eb-9a13cda64003', '67315042-c687-4cbb-b45a-f4ea4efc199f', '12251ad8-147d-463e-a33a-30daa7aaabf7', 'Murgh Malai Tikka', 'Creamy cashew and cardamom marinated chicken morsels grilled in tandoor.', false, NULL, true, '2026-09-02 16:21:33.938+05:30', '2026-09-02 16:21:33.938+05:30', NULL, NULL, NULL, 5.00, 32000, 100, NULL);
INSERT INTO public.menu_items VALUES ('c1f09997-5bb1-4ee9-abb6-9b622c2c8e91', '67315042-c687-4cbb-b45a-f4ea4efc199f', '735379c7-6bd9-4ed0-be64-40d8bf1e7de8', 'Kapila Electric Blue Lagoon', 'Blue curacao, fresh lime, sprite and crushed ice.', true, NULL, true, '2026-09-02 16:21:33.944+05:30', '2026-09-02 16:21:33.944+05:30', NULL, NULL, NULL, 5.00, 16000, 100, NULL);
INSERT INTO public.menu_items VALUES ('99e5ec8f-c83a-4fa8-94d7-912ea45e2b74', '2a543c3c-066f-4097-833a-df7c25700580', '68413038-40bc-4f99-988e-7a72c60094e0', '(2) Idly (1) Vada', NULL, true, NULL, true, '2026-09-02 16:33:25.845+05:30', '2026-09-02 16:33:25.845+05:30', NULL, NULL, NULL, 5.00, 8500, 100, NULL);
INSERT INTO public.menu_items VALUES ('beef07d4-c730-41b8-bf0b-651379e91f92', '2a543c3c-066f-4097-833a-df7c25700580', '68413038-40bc-4f99-988e-7a72c60094e0', '(S) Idly', NULL, true, NULL, true, '2026-09-02 16:33:25.859+05:30', '2026-09-02 16:33:25.859+05:30', NULL, NULL, NULL, 5.00, 5000, 100, NULL);
INSERT INTO public.menu_items VALUES ('f9e508d5-3525-46d0-bff7-371f448c108c', '2a543c3c-066f-4097-833a-df7c25700580', '68413038-40bc-4f99-988e-7a72c60094e0', '(S) Idly (S) Vada', NULL, true, NULL, true, '2026-09-02 16:33:25.866+05:30', '2026-09-02 16:33:25.866+05:30', NULL, NULL, NULL, 5.00, 7000, 100, NULL);
INSERT INTO public.menu_items VALUES ('7699dcd7-bf39-4f90-9dfc-c9751ab561ba', '2a543c3c-066f-4097-833a-df7c25700580', '68413038-40bc-4f99-988e-7a72c60094e0', '(S) Idly (S) Vada Sambar', NULL, true, NULL, true, '2026-09-02 16:33:25.875+05:30', '2026-09-02 16:33:25.875+05:30', NULL, NULL, NULL, 5.00, 8000, 100, NULL);
INSERT INTO public.menu_items VALUES ('8613e431-dc51-4c61-9bab-bdf518502c06', '2a543c3c-066f-4097-833a-df7c25700580', '68413038-40bc-4f99-988e-7a72c60094e0', '(S) Idly Sambar', NULL, true, NULL, true, '2026-09-02 16:33:25.883+05:30', '2026-09-02 16:33:25.883+05:30', NULL, NULL, NULL, 5.00, 6000, 100, NULL);
INSERT INTO public.menu_items VALUES ('124c76f8-7ab2-48ab-9a2a-884ec6134578', '2a543c3c-066f-4097-833a-df7c25700580', '68413038-40bc-4f99-988e-7a72c60094e0', '(S) Vada', NULL, true, NULL, true, '2026-09-02 16:33:25.89+05:30', '2026-09-02 16:33:25.89+05:30', NULL, NULL, NULL, 5.00, 5500, 100, NULL);
INSERT INTO public.menu_items VALUES ('3d186c5c-8df7-4f8a-9233-3efa0c713df2', '2a543c3c-066f-4097-833a-df7c25700580', '68413038-40bc-4f99-988e-7a72c60094e0', '(S) Vada Sambar', NULL, true, NULL, true, '2026-09-02 16:33:25.9+05:30', '2026-09-02 16:33:25.9+05:30', NULL, NULL, NULL, 5.00, 6500, 100, NULL);
INSERT INTO public.menu_items VALUES ('dea644c5-2503-44fd-8da7-661d929ec929', '2a543c3c-066f-4097-833a-df7c25700580', '68413038-40bc-4f99-988e-7a72c60094e0', '70 Mm Dosa', NULL, true, NULL, true, '2026-09-02 16:33:25.908+05:30', '2026-09-02 16:33:25.908+05:30', NULL, NULL, NULL, 5.00, 11000, 100, NULL);
INSERT INTO public.menu_items VALUES ('499397a7-8028-49ab-9884-4cf4784a9094', '2a543c3c-066f-4097-833a-df7c25700580', '68413038-40bc-4f99-988e-7a72c60094e0', 'Breakfast Buffet', NULL, true, NULL, true, '2026-09-02 16:33:25.916+05:30', '2026-09-02 16:33:25.916+05:30', NULL, NULL, NULL, 5.00, 25000, 100, NULL);
INSERT INTO public.menu_items VALUES ('6d626d6f-915f-43a7-887e-8c3d3c637355', '2a543c3c-066f-4097-833a-df7c25700580', '68413038-40bc-4f99-988e-7a72c60094e0', 'Breakfast Combo', NULL, true, NULL, true, '2026-09-02 16:33:25.924+05:30', '2026-09-02 16:33:25.924+05:30', NULL, NULL, NULL, 5.00, 14000, 100, NULL);
INSERT INTO public.menu_items VALUES ('b345f6a0-75ab-48d4-a918-3f4b3652b27c', '2a543c3c-066f-4097-833a-df7c25700580', '68413038-40bc-4f99-988e-7a72c60094e0', 'Butter Masala Dosa', NULL, true, NULL, true, '2026-09-02 16:33:25.931+05:30', '2026-09-02 16:33:25.931+05:30', NULL, NULL, NULL, 5.00, 9500, 100, NULL);
INSERT INTO public.menu_items VALUES ('d79e8ac8-4c76-4b15-bb79-fc71e716af9f', '2a543c3c-066f-4097-833a-df7c25700580', '68413038-40bc-4f99-988e-7a72c60094e0', 'Chitti Pesarattu', NULL, true, NULL, true, '2026-09-02 16:33:25.939+05:30', '2026-09-02 16:33:25.939+05:30', NULL, NULL, NULL, 5.00, 8500, 100, NULL);
INSERT INTO public.menu_items VALUES ('ffa8145b-957b-4f83-9c66-ec0b84674310', '2a543c3c-066f-4097-833a-df7c25700580', '68413038-40bc-4f99-988e-7a72c60094e0', 'Extra Aloo', NULL, true, NULL, true, '2026-09-02 16:33:25.946+05:30', '2026-09-02 16:33:25.946+05:30', NULL, NULL, NULL, 5.00, 2500, 100, NULL);
INSERT INTO public.menu_items VALUES ('608501cf-0f05-41a6-86a1-0df6d54f146e', '2a543c3c-066f-4097-833a-df7c25700580', '68413038-40bc-4f99-988e-7a72c60094e0', 'Extra Poori', NULL, true, NULL, true, '2026-09-02 16:33:25.955+05:30', '2026-09-02 16:33:25.955+05:30', NULL, NULL, NULL, 5.00, 3000, 100, NULL);
INSERT INTO public.menu_items VALUES ('88c549e3-63bb-4a66-88fa-743997855717', '2a543c3c-066f-4097-833a-df7c25700580', '68413038-40bc-4f99-988e-7a72c60094e0', 'Ghee Karam Idly', NULL, true, NULL, true, '2026-09-02 16:33:25.962+05:30', '2026-09-02 16:33:25.962+05:30', NULL, NULL, NULL, 5.00, 9000, 100, NULL);
INSERT INTO public.menu_items VALUES ('48f122f5-022a-4b4e-a4ae-c9ff954f41c8', '2a543c3c-066f-4097-833a-df7c25700580', '68413038-40bc-4f99-988e-7a72c60094e0', 'Ghee Karvepaaku Podi Dosa', NULL, true, NULL, true, '2026-09-02 16:33:25.969+05:30', '2026-09-02 16:33:25.969+05:30', NULL, NULL, NULL, 5.00, 10500, 100, NULL);
INSERT INTO public.menu_items VALUES ('298d92b7-7b6d-43f5-9532-3d0da9c83604', '2a543c3c-066f-4097-833a-df7c25700580', '68413038-40bc-4f99-988e-7a72c60094e0', 'Ghee Podi Dosa', NULL, true, NULL, true, '2026-09-02 16:33:25.977+05:30', '2026-09-02 16:33:25.977+05:30', NULL, NULL, NULL, 5.00, 10000, 100, NULL);
INSERT INTO public.menu_items VALUES ('057eb69f-2f78-41db-8d57-7ea11dce3fc9', '2a543c3c-066f-4097-833a-df7c25700580', '68413038-40bc-4f99-988e-7a72c60094e0', 'Ghee Podi Rava Dosa', NULL, true, NULL, true, '2026-09-02 16:33:25.985+05:30', '2026-09-02 16:33:25.985+05:30', NULL, NULL, NULL, 5.00, 11500, 100, NULL);
INSERT INTO public.menu_items VALUES ('4ad7b7d4-9d9a-4d41-b60d-a473aa6fb2e2', '2a543c3c-066f-4097-833a-df7c25700580', '68413038-40bc-4f99-988e-7a72c60094e0', 'Idly (2)', NULL, true, NULL, true, '2026-09-02 16:33:25.992+05:30', '2026-09-02 16:33:25.992+05:30', NULL, NULL, NULL, 5.00, 5500, 100, NULL);
INSERT INTO public.menu_items VALUES ('5f37b0e5-9c5f-4359-bae7-728cb6b9cd34', '2a543c3c-066f-4097-833a-df7c25700580', '68413038-40bc-4f99-988e-7a72c60094e0', 'Idly Sambar', NULL, true, NULL, true, '2026-09-02 16:33:26+05:30', '2026-09-02 16:33:26+05:30', NULL, NULL, NULL, 5.00, 6500, 100, NULL);
INSERT INTO public.menu_items VALUES ('6716a235-8942-48aa-bb11-b43092d4d2f5', '2a543c3c-066f-4097-833a-df7c25700580', '68413038-40bc-4f99-988e-7a72c60094e0', 'Kids Buffet', NULL, true, NULL, true, '2026-09-02 16:33:26.008+05:30', '2026-09-02 16:33:26.008+05:30', NULL, NULL, NULL, 5.00, 15000, 100, NULL);
INSERT INTO public.menu_items VALUES ('84948cf5-ebb2-447b-9b5f-2a6bf5c563aa', '2a543c3c-066f-4097-833a-df7c25700580', 'bd5fd925-8442-4a2c-b952-de8a4e0181ee', 'Executive South Thali Box', NULL, true, NULL, true, '2026-09-02 16:33:26.019+05:30', '2026-09-02 16:33:26.019+05:30', NULL, NULL, NULL, 5.00, 22000, 100, NULL);
INSERT INTO public.menu_items VALUES ('b38345b1-ee47-4809-988b-f660f8885eae', '2a543c3c-066f-4097-833a-df7c25700580', 'bd5fd925-8442-4a2c-b952-de8a4e0181ee', 'Special Dosa Combo Box', NULL, true, NULL, true, '2026-09-02 16:33:26.027+05:30', '2026-09-02 16:33:26.027+05:30', NULL, NULL, NULL, 5.00, 18000, 100, NULL);
INSERT INTO public.menu_items VALUES ('b9e284ff-8969-494d-a659-fbb5a9354664', '2a543c3c-066f-4097-833a-df7c25700580', 'da1e0528-b69e-4eaf-b3cc-62429b61e75e', 'Filter Coffee', NULL, true, NULL, true, '2026-09-02 16:33:26.035+05:30', '2026-09-02 16:33:26.035+05:30', NULL, NULL, NULL, 5.00, 3500, 100, NULL);
INSERT INTO public.menu_items VALUES ('d8b50247-153e-4208-9839-6bd10bbca253', '2a543c3c-066f-4097-833a-df7c25700580', 'da1e0528-b69e-4eaf-b3cc-62429b61e75e', 'Special Masala Tea', NULL, true, NULL, true, '2026-09-02 16:33:26.042+05:30', '2026-09-02 16:33:26.042+05:30', NULL, NULL, NULL, 5.00, 3000, 100, NULL);
INSERT INTO public.menu_items VALUES ('cdc12a71-3f32-4630-ab8b-059ae196af2c', '67315042-c687-4cbb-b45a-f4ea4efc199f', '8fcde4bd-6deb-4827-b69b-f748741f5aea', 'Butter Chicken', NULL, false, NULL, true, '2026-09-02 17:56:41.935+05:30', '2026-09-02 17:56:41.935+05:30', NULL, NULL, NULL, 5.00, 32000, 100, NULL);
INSERT INTO public.menu_items VALUES ('8772f56e-a632-4998-ae87-45084349bf9f', '67315042-c687-4cbb-b45a-f4ea4efc199f', '6b47802d-d31d-4d52-9c5e-001f4674f85e', '(2) Idly (1) Vada', NULL, true, NULL, true, '2026-09-03 13:45:53.312837+05:30', '2026-09-03 13:45:53.312837+05:30', NULL, NULL, NULL, 5.00, 8500, 100, NULL);
INSERT INTO public.menu_items VALUES ('47dce856-d45e-41a3-a7de-84a823aa6d5a', '67315042-c687-4cbb-b45a-f4ea4efc199f', '6b47802d-d31d-4d52-9c5e-001f4674f85e', '(S) Idly', NULL, true, NULL, true, '2026-09-03 13:45:53.315365+05:30', '2026-09-03 13:45:53.315365+05:30', NULL, NULL, NULL, 5.00, 5000, 100, NULL);
INSERT INTO public.menu_items VALUES ('81f170e9-ad77-44a9-b8dc-7a7d4a2b84cc', '67315042-c687-4cbb-b45a-f4ea4efc199f', '6b47802d-d31d-4d52-9c5e-001f4674f85e', '(S) Idly (S) Vada', NULL, true, NULL, true, '2026-09-03 13:45:53.31721+05:30', '2026-09-03 13:45:53.31721+05:30', NULL, NULL, NULL, 5.00, 7000, 100, NULL);
INSERT INTO public.menu_items VALUES ('c97c9587-1c8d-4421-abc4-65e15db4bc81', '67315042-c687-4cbb-b45a-f4ea4efc199f', '6b47802d-d31d-4d52-9c5e-001f4674f85e', '(S) Idly (S) Vada Sambar', NULL, true, NULL, true, '2026-09-03 13:45:53.319734+05:30', '2026-09-03 13:45:53.319734+05:30', NULL, NULL, NULL, 5.00, 8000, 100, NULL);
INSERT INTO public.menu_items VALUES ('9e6b5249-048d-4aeb-a0b6-acfd8f6a8501', '67315042-c687-4cbb-b45a-f4ea4efc199f', '6b47802d-d31d-4d52-9c5e-001f4674f85e', '(S) Idly Sambar', NULL, true, NULL, true, '2026-09-03 13:45:53.321876+05:30', '2026-09-03 13:45:53.321876+05:30', NULL, NULL, NULL, 5.00, 6000, 100, NULL);
INSERT INTO public.menu_items VALUES ('6e275671-eb4e-43e2-8562-65053ed3b8e6', '67315042-c687-4cbb-b45a-f4ea4efc199f', '6b47802d-d31d-4d52-9c5e-001f4674f85e', '(S) Vada', NULL, true, NULL, true, '2026-09-03 13:45:53.323781+05:30', '2026-09-03 13:45:53.323781+05:30', NULL, NULL, NULL, 5.00, 5500, 100, NULL);
INSERT INTO public.menu_items VALUES ('c8fcdcb4-5630-46dd-aecf-f1d910a52ff8', '67315042-c687-4cbb-b45a-f4ea4efc199f', '6b47802d-d31d-4d52-9c5e-001f4674f85e', '(S) Vada Sambar', NULL, true, NULL, true, '2026-09-03 13:45:53.325233+05:30', '2026-09-03 13:45:53.325233+05:30', NULL, NULL, NULL, 5.00, 6500, 100, NULL);
INSERT INTO public.menu_items VALUES ('7f133d9e-7d22-4f2e-ad79-1fd89f07a1f5', '67315042-c687-4cbb-b45a-f4ea4efc199f', '6b47802d-d31d-4d52-9c5e-001f4674f85e', '70 Mm Dosa', NULL, true, NULL, true, '2026-09-03 13:45:53.326691+05:30', '2026-09-03 13:45:53.326691+05:30', NULL, NULL, NULL, 5.00, 11000, 100, NULL);
INSERT INTO public.menu_items VALUES ('32867c6e-e19a-4228-a96d-af1b439beb9b', '67315042-c687-4cbb-b45a-f4ea4efc199f', '6b47802d-d31d-4d52-9c5e-001f4674f85e', 'Breakfast Buffet', NULL, true, NULL, true, '2026-09-03 13:45:53.328109+05:30', '2026-09-03 13:45:53.328109+05:30', NULL, NULL, NULL, 5.00, 25000, 100, NULL);
INSERT INTO public.menu_items VALUES ('ce830a66-2777-49d8-b62e-6fb860b9ac05', '67315042-c687-4cbb-b45a-f4ea4efc199f', '6b47802d-d31d-4d52-9c5e-001f4674f85e', 'Breakfast Combo', NULL, true, NULL, true, '2026-09-03 13:45:53.32954+05:30', '2026-09-03 13:45:53.32954+05:30', NULL, NULL, NULL, 5.00, 14000, 100, NULL);
INSERT INTO public.menu_items VALUES ('4d74432b-7997-4b05-96c7-cb331127b3ca', '67315042-c687-4cbb-b45a-f4ea4efc199f', '6b47802d-d31d-4d52-9c5e-001f4674f85e', 'Butter Masala Dosa', NULL, true, NULL, true, '2026-09-03 13:45:53.332819+05:30', '2026-09-03 13:45:53.332819+05:30', NULL, NULL, NULL, 5.00, 9500, 100, NULL);
INSERT INTO public.menu_items VALUES ('b16d099e-1e0c-4bbf-8c9b-8e6a8414f4ae', '67315042-c687-4cbb-b45a-f4ea4efc199f', '6b47802d-d31d-4d52-9c5e-001f4674f85e', 'Chitti Pesarattu', NULL, true, NULL, true, '2026-09-03 13:45:53.3343+05:30', '2026-09-03 13:45:53.3343+05:30', NULL, NULL, NULL, 5.00, 8500, 100, NULL);
INSERT INTO public.menu_items VALUES ('9b35f954-5201-48ea-9e2a-174dbb083352', '67315042-c687-4cbb-b45a-f4ea4efc199f', '1541649d-c982-46a7-a228-ad78aba10f6c', 'Executive South Thali Box', NULL, true, NULL, true, '2026-09-03 13:45:53.336148+05:30', '2026-09-03 13:45:53.336148+05:30', NULL, NULL, NULL, 5.00, 22000, 100, NULL);
INSERT INTO public.menu_items VALUES ('7cdd0470-02f3-4aef-a744-d1742a7a8825', '67315042-c687-4cbb-b45a-f4ea4efc199f', '6b47802d-d31d-4d52-9c5e-001f4674f85e', 'Extra Aloo', NULL, true, NULL, true, '2026-09-03 13:45:53.338508+05:30', '2026-09-03 13:45:53.338508+05:30', NULL, NULL, NULL, 5.00, 2500, 100, NULL);
INSERT INTO public.menu_items VALUES ('3e079d26-b636-48bc-ad6f-68e117c7826d', '67315042-c687-4cbb-b45a-f4ea4efc199f', '6b47802d-d31d-4d52-9c5e-001f4674f85e', 'Extra Poori', NULL, true, NULL, true, '2026-09-03 13:45:53.340275+05:30', '2026-09-03 13:45:53.340275+05:30', NULL, NULL, NULL, 5.00, 3000, 100, NULL);
INSERT INTO public.menu_items VALUES ('b66072c9-672f-4a07-ae41-bd506f60d505', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'de6e8b83-db5a-4c10-b432-6b5a66959cc4', 'Filter Coffee', NULL, true, NULL, true, '2026-09-03 13:45:53.341888+05:30', '2026-09-03 13:45:53.341888+05:30', NULL, NULL, NULL, 5.00, 3500, 100, NULL);
INSERT INTO public.menu_items VALUES ('25dc14b6-0f77-44e7-9db7-2c6e5fd00ebb', '67315042-c687-4cbb-b45a-f4ea4efc199f', '6b47802d-d31d-4d52-9c5e-001f4674f85e', 'Ghee Karam Idly', NULL, true, NULL, true, '2026-09-03 13:45:53.343462+05:30', '2026-09-03 13:45:53.343462+05:30', NULL, NULL, NULL, 5.00, 9000, 100, NULL);
INSERT INTO public.menu_items VALUES ('d4062c49-deb2-4a8b-a14f-7f594e1d61b0', '67315042-c687-4cbb-b45a-f4ea4efc199f', '6b47802d-d31d-4d52-9c5e-001f4674f85e', 'Ghee Karvepaaku Podi Dosa', NULL, true, NULL, true, '2026-09-03 13:45:53.345401+05:30', '2026-09-03 13:45:53.345401+05:30', NULL, NULL, NULL, 5.00, 10500, 100, NULL);
INSERT INTO public.menu_items VALUES ('972a52a2-10f6-42ec-bd50-45cee9cd3c14', '67315042-c687-4cbb-b45a-f4ea4efc199f', '6b47802d-d31d-4d52-9c5e-001f4674f85e', 'Ghee Podi Dosa', NULL, true, NULL, true, '2026-09-03 13:45:53.347625+05:30', '2026-09-03 13:45:53.347625+05:30', NULL, NULL, NULL, 5.00, 10000, 100, NULL);
INSERT INTO public.menu_items VALUES ('6147b9f5-53bb-4989-9f55-c0cce14398c0', '67315042-c687-4cbb-b45a-f4ea4efc199f', '6b47802d-d31d-4d52-9c5e-001f4674f85e', 'Ghee Podi Rava Dosa', NULL, true, NULL, true, '2026-09-03 13:45:53.349243+05:30', '2026-09-03 13:45:53.349243+05:30', NULL, NULL, NULL, 5.00, 11500, 100, NULL);
INSERT INTO public.menu_items VALUES ('95d022d5-47ec-4b38-9565-daabe33866a1', '67315042-c687-4cbb-b45a-f4ea4efc199f', '6b47802d-d31d-4d52-9c5e-001f4674f85e', 'Idly (2)', NULL, true, NULL, true, '2026-09-03 13:45:53.351877+05:30', '2026-09-03 13:45:53.351877+05:30', NULL, NULL, NULL, 5.00, 5500, 100, NULL);
INSERT INTO public.menu_items VALUES ('14abe1aa-b258-4201-a995-8eed18df3bcc', '67315042-c687-4cbb-b45a-f4ea4efc199f', '6b47802d-d31d-4d52-9c5e-001f4674f85e', 'Idly Sambar', NULL, true, NULL, true, '2026-09-03 13:45:53.353295+05:30', '2026-09-03 13:45:53.353295+05:30', NULL, NULL, NULL, 5.00, 6500, 100, NULL);
INSERT INTO public.menu_items VALUES ('5d8449d6-24c6-43dd-b73e-4a1fb8860644', '67315042-c687-4cbb-b45a-f4ea4efc199f', '6b47802d-d31d-4d52-9c5e-001f4674f85e', 'Kids Buffet', NULL, true, NULL, true, '2026-09-03 13:45:53.355329+05:30', '2026-09-03 13:45:53.355329+05:30', NULL, NULL, NULL, 5.00, 15000, 100, NULL);
INSERT INTO public.menu_items VALUES ('cb01246c-8e64-409b-bbb8-d63139e6ac6b', '67315042-c687-4cbb-b45a-f4ea4efc199f', '1541649d-c982-46a7-a228-ad78aba10f6c', 'Special Dosa Combo Box', NULL, true, NULL, true, '2026-09-03 13:45:53.357373+05:30', '2026-09-03 13:45:53.357373+05:30', NULL, NULL, NULL, 5.00, 18000, 100, NULL);
INSERT INTO public.menu_items VALUES ('eba83b97-1716-4073-bd57-2eef05c144c5', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'de6e8b83-db5a-4c10-b432-6b5a66959cc4', 'Special Masala Tea', NULL, true, NULL, true, '2026-09-03 13:45:53.361665+05:30', '2026-09-03 13:45:53.361665+05:30', NULL, NULL, NULL, 5.00, 3000, 100, NULL);
INSERT INTO public.menu_items VALUES ('09b87cbe-453a-418f-88dc-841b6c78b4a8', '2a543c3c-066f-4097-833a-df7c25700580', '7e99f115-5a4e-404a-880d-118faff89110', 'Butter Chicken', NULL, false, NULL, true, '2026-09-03 13:45:53.371421+05:30', '2026-09-03 13:45:53.371421+05:30', NULL, NULL, NULL, 5.00, 32000, 100, NULL);
INSERT INTO public.menu_items VALUES ('072c26c3-7552-494a-9eb4-bcc5dd7d2a22', '2a543c3c-066f-4097-833a-df7c25700580', '7e99f115-5a4e-404a-880d-118faff89110', 'Hotel Kapila Special Chicken Biryani (Boneless)', 'Nizamabad signature boneless fried chicken masala over dum basmati rice.', false, NULL, true, '2026-09-03 13:45:53.381065+05:30', '2026-09-03 13:45:53.381065+05:30', NULL, NULL, NULL, 5.00, 34000, 100, NULL);
INSERT INTO public.menu_items VALUES ('b61b7134-ec44-409a-924b-b01ecd973144', '2a543c3c-066f-4097-833a-df7c25700580', 'e10d567d-babb-4e94-a79a-eb3a48de4812', 'Hyderabadi Paneer Dum Biryani', 'Fragrant saffron basmati rice layered with spiced paneer cubes and herbs.', true, NULL, true, '2026-09-03 13:45:53.382677+05:30', '2026-09-03 13:45:53.382677+05:30', NULL, NULL, NULL, 5.00, 28000, 100, NULL);
INSERT INTO public.menu_items VALUES ('00d0d8e1-c2a5-4deb-a0a5-da1a1ca24683', '2a543c3c-066f-4097-833a-df7c25700580', 'a976ef06-5bbd-4e1a-ba06-59ac9b0a6b84', 'Kapila Electric Blue Lagoon', 'Blue curacao, fresh lime, sprite and crushed ice.', true, NULL, true, '2026-09-03 13:45:53.385119+05:30', '2026-09-03 13:45:53.385119+05:30', NULL, NULL, NULL, 5.00, 16000, 100, NULL);
INSERT INTO public.menu_items VALUES ('1408068a-d60c-421b-8da4-76bf4c399c84', '2a543c3c-066f-4097-833a-df7c25700580', 'e4b000a5-48de-44ba-bf02-3929b1f75c89', 'Murgh Malai Tikka', 'Creamy cashew and cardamom marinated chicken morsels grilled in tandoor.', false, NULL, true, '2026-09-03 13:45:53.386898+05:30', '2026-09-03 13:45:53.386898+05:30', NULL, NULL, NULL, 5.00, 32000, 100, NULL);
INSERT INTO public.menu_items VALUES ('71451535-8d85-417f-b0ec-3f2b87016045', '11111111-1111-1111-1111-111111111111', 'a65ebbc1-bfb6-42ce-95cf-112d5a76e825', '(S) Idly (S) Vada Sambar', NULL, true, NULL, true, '2026-09-03 13:45:53.394798+05:30', '2026-09-03 13:45:53.394798+05:30', NULL, NULL, NULL, 5.00, 8000, 100, NULL);
INSERT INTO public.menu_items VALUES ('5101522a-081e-4866-9f74-261854fe4404', '11111111-1111-1111-1111-111111111111', 'a65ebbc1-bfb6-42ce-95cf-112d5a76e825', '(S) Idly Sambar', NULL, true, NULL, true, '2026-09-03 13:45:53.396041+05:30', '2026-09-03 13:45:53.396041+05:30', NULL, NULL, NULL, 5.00, 6000, 100, NULL);
INSERT INTO public.menu_items VALUES ('0020780f-7112-4804-a81b-2e06a91cdaa4', '11111111-1111-1111-1111-111111111111', 'a65ebbc1-bfb6-42ce-95cf-112d5a76e825', '(S) Vada', NULL, true, NULL, true, '2026-09-03 13:45:53.397451+05:30', '2026-09-03 13:45:53.397451+05:30', NULL, NULL, NULL, 5.00, 5500, 100, NULL);
INSERT INTO public.menu_items VALUES ('7e1e6434-2ee4-428b-aafc-05be27e770d9', '11111111-1111-1111-1111-111111111111', 'a65ebbc1-bfb6-42ce-95cf-112d5a76e825', '(S) Vada Sambar', NULL, true, NULL, true, '2026-09-03 13:45:53.399679+05:30', '2026-09-03 13:45:53.399679+05:30', NULL, NULL, NULL, 5.00, 6500, 100, NULL);
INSERT INTO public.menu_items VALUES ('9e27f8db-5ca3-4d7f-97d4-aa3d87642452', '11111111-1111-1111-1111-111111111111', 'a65ebbc1-bfb6-42ce-95cf-112d5a76e825', '70 Mm Dosa', NULL, true, NULL, true, '2026-09-03 13:45:53.401337+05:30', '2026-09-03 13:45:53.401337+05:30', NULL, NULL, NULL, 5.00, 11000, 100, NULL);
INSERT INTO public.menu_items VALUES ('e0ffcd03-52ae-497b-9e57-1411888fde4f', '11111111-1111-1111-1111-111111111111', 'a65ebbc1-bfb6-42ce-95cf-112d5a76e825', 'Breakfast Buffet', NULL, true, NULL, true, '2026-09-03 13:45:53.402827+05:30', '2026-09-03 13:45:53.402827+05:30', NULL, NULL, NULL, 5.00, 25000, 100, NULL);
INSERT INTO public.menu_items VALUES ('e286dcdc-8100-430d-967e-6edba83f1609', '11111111-1111-1111-1111-111111111111', 'a65ebbc1-bfb6-42ce-95cf-112d5a76e825', 'Breakfast Combo', NULL, true, NULL, true, '2026-09-03 13:45:53.40406+05:30', '2026-09-03 13:45:53.40406+05:30', NULL, NULL, NULL, 5.00, 14000, 100, NULL);
INSERT INTO public.menu_items VALUES ('b45529e4-72e8-4c01-aed9-3106f2da6aeb', '11111111-1111-1111-1111-111111111111', '26fd5701-0ca8-4a3d-8a30-706cca828e47', 'Butter Chicken', NULL, false, NULL, true, '2026-09-03 13:45:53.405375+05:30', '2026-09-03 13:45:53.405375+05:30', NULL, NULL, NULL, 5.00, 32000, 100, NULL);
INSERT INTO public.menu_items VALUES ('5d13a97e-027a-445b-94eb-2f00546b1614', '11111111-1111-1111-1111-111111111111', 'a65ebbc1-bfb6-42ce-95cf-112d5a76e825', 'Butter Masala Dosa', NULL, true, NULL, true, '2026-09-03 13:45:53.406605+05:30', '2026-09-03 13:45:53.406605+05:30', NULL, NULL, NULL, 5.00, 9500, 100, NULL);
INSERT INTO public.menu_items VALUES ('640584ad-7f9e-4a1b-8740-290fd382ea81', '11111111-1111-1111-1111-111111111111', 'a65ebbc1-bfb6-42ce-95cf-112d5a76e825', 'Chitti Pesarattu', NULL, true, NULL, true, '2026-09-03 13:45:53.407769+05:30', '2026-09-03 13:45:53.407769+05:30', NULL, NULL, NULL, 5.00, 8500, 100, NULL);
INSERT INTO public.menu_items VALUES ('df736215-5b84-49ce-bbfc-3d644d9a5401', '11111111-1111-1111-1111-111111111111', '638dcd56-a022-462a-aacc-125069c4a2ad', 'Executive South Thali Box', NULL, true, NULL, true, '2026-09-03 13:45:53.409003+05:30', '2026-09-03 13:45:53.409003+05:30', NULL, NULL, NULL, 5.00, 22000, 100, NULL);
INSERT INTO public.menu_items VALUES ('fd632cf0-e4df-4fb7-b0ec-f6e64f852405', '11111111-1111-1111-1111-111111111111', 'a65ebbc1-bfb6-42ce-95cf-112d5a76e825', 'Extra Aloo', NULL, true, NULL, true, '2026-09-03 13:45:53.410656+05:30', '2026-09-03 13:45:53.410656+05:30', NULL, NULL, NULL, 5.00, 2500, 100, NULL);
INSERT INTO public.menu_items VALUES ('2c28152b-2d3a-4796-ac1f-aa04d783f921', '11111111-1111-1111-1111-111111111111', 'a65ebbc1-bfb6-42ce-95cf-112d5a76e825', 'Extra Poori', NULL, true, NULL, true, '2026-09-03 13:45:53.411957+05:30', '2026-09-03 13:45:53.411957+05:30', NULL, NULL, NULL, 5.00, 3000, 100, NULL);
INSERT INTO public.menu_items VALUES ('88ec151b-ebde-4993-809f-79f7e29a4385', '11111111-1111-1111-1111-111111111111', '764ab8d6-7220-4bfb-bb9f-23f7d804bc71', 'Filter Coffee', NULL, true, NULL, true, '2026-09-03 13:45:53.413165+05:30', '2026-09-03 13:45:53.413165+05:30', NULL, NULL, NULL, 5.00, 3500, 100, NULL);
INSERT INTO public.menu_items VALUES ('0f4bef83-2c0d-4c19-9d07-ce7f564fc589', '11111111-1111-1111-1111-111111111111', 'a65ebbc1-bfb6-42ce-95cf-112d5a76e825', 'Ghee Karam Idly', NULL, true, NULL, true, '2026-09-03 13:45:53.414362+05:30', '2026-09-03 13:45:53.414362+05:30', NULL, NULL, NULL, 5.00, 9000, 100, NULL);
INSERT INTO public.menu_items VALUES ('431e1ef5-1ef0-4ee9-acb8-4f406246c92a', '11111111-1111-1111-1111-111111111111', 'a65ebbc1-bfb6-42ce-95cf-112d5a76e825', 'Ghee Karvepaaku Podi Dosa', NULL, true, NULL, true, '2026-09-03 13:45:53.415566+05:30', '2026-09-03 13:45:53.415566+05:30', NULL, NULL, NULL, 5.00, 10500, 100, NULL);
INSERT INTO public.menu_items VALUES ('b9be06d0-6f21-4d05-8914-74e41818650e', '11111111-1111-1111-1111-111111111111', 'a65ebbc1-bfb6-42ce-95cf-112d5a76e825', 'Ghee Podi Dosa', NULL, true, NULL, true, '2026-09-03 13:45:53.41675+05:30', '2026-09-03 13:45:53.41675+05:30', NULL, NULL, NULL, 5.00, 10000, 100, NULL);
INSERT INTO public.menu_items VALUES ('d96136d0-d5ba-4152-814c-3aea49b3079e', '11111111-1111-1111-1111-111111111111', 'a65ebbc1-bfb6-42ce-95cf-112d5a76e825', 'Ghee Podi Rava Dosa', NULL, true, NULL, true, '2026-09-03 13:45:53.418931+05:30', '2026-09-03 13:45:53.418931+05:30', NULL, NULL, NULL, 5.00, 11500, 100, NULL);
INSERT INTO public.menu_items VALUES ('094b3d75-f087-476a-863b-a70da76e2365', '11111111-1111-1111-1111-111111111111', '26fd5701-0ca8-4a3d-8a30-706cca828e47', 'Hotel Kapila Special Chicken Biryani (Boneless)', 'Nizamabad signature boneless fried chicken masala over dum basmati rice.', false, NULL, true, '2026-09-03 13:45:53.420983+05:30', '2026-09-03 13:45:53.420983+05:30', NULL, NULL, NULL, 5.00, 34000, 100, NULL);
INSERT INTO public.menu_items VALUES ('f2961923-6d3d-453d-b80e-6820041126a5', '11111111-1111-1111-1111-111111111111', 'e18291bb-1c6d-426d-a753-c58922a38598', 'Hyderabadi Paneer Dum Biryani', 'Fragrant saffron basmati rice layered with spiced paneer cubes and herbs.', true, NULL, true, '2026-09-03 13:45:53.422823+05:30', '2026-09-03 13:45:53.422823+05:30', NULL, NULL, NULL, 5.00, 28000, 100, NULL);
INSERT INTO public.menu_items VALUES ('4c59714c-7d6c-4d24-87c9-b4bb91f3c923', '11111111-1111-1111-1111-111111111111', 'a65ebbc1-bfb6-42ce-95cf-112d5a76e825', 'Idly (2)', NULL, true, NULL, true, '2026-09-03 13:45:53.424377+05:30', '2026-09-03 13:45:53.424377+05:30', NULL, NULL, NULL, 5.00, 5500, 100, NULL);
INSERT INTO public.menu_items VALUES ('29b7f4be-ba96-4de7-a268-6248985e12b1', '11111111-1111-1111-1111-111111111111', 'a65ebbc1-bfb6-42ce-95cf-112d5a76e825', 'Idly Sambar', NULL, true, NULL, true, '2026-09-03 13:45:53.426157+05:30', '2026-09-03 13:45:53.426157+05:30', NULL, NULL, NULL, 5.00, 6500, 100, NULL);
INSERT INTO public.menu_items VALUES ('305951b9-bbbd-4bcd-a93a-01aa60742934', '11111111-1111-1111-1111-111111111111', '226608d8-4b01-406d-a0bc-3da3381efd44', 'Kapila Electric Blue Lagoon', 'Blue curacao, fresh lime, sprite and crushed ice.', true, NULL, true, '2026-09-03 13:45:53.428699+05:30', '2026-09-03 13:45:53.428699+05:30', NULL, NULL, NULL, 5.00, 16000, 100, NULL);
INSERT INTO public.menu_items VALUES ('a7cf73dc-f5df-497b-a326-5fe2e49af224', '11111111-1111-1111-1111-111111111111', 'a65ebbc1-bfb6-42ce-95cf-112d5a76e825', 'Kids Buffet', NULL, true, NULL, true, '2026-09-03 13:45:53.430773+05:30', '2026-09-03 13:45:53.430773+05:30', NULL, NULL, NULL, 5.00, 15000, 100, NULL);
INSERT INTO public.menu_items VALUES ('2ddb7944-4e83-4dda-99de-94dd5e83bb77', '11111111-1111-1111-1111-111111111111', '00e25236-2c50-4e2b-818d-88c104db92bb', 'Murgh Malai Tikka', 'Creamy cashew and cardamom marinated chicken morsels grilled in tandoor.', false, NULL, true, '2026-09-03 13:45:53.432611+05:30', '2026-09-03 13:45:53.432611+05:30', NULL, NULL, NULL, 5.00, 32000, 100, NULL);
INSERT INTO public.menu_items VALUES ('4dd53b01-9b00-47a6-9537-6ccab7fc12e8', '11111111-1111-1111-1111-111111111111', '638dcd56-a022-462a-aacc-125069c4a2ad', 'Special Dosa Combo Box', NULL, true, NULL, true, '2026-09-03 13:45:53.434215+05:30', '2026-09-03 13:45:53.434215+05:30', NULL, NULL, NULL, 5.00, 18000, 100, NULL);
INSERT INTO public.menu_items VALUES ('88edfc29-cdb9-469b-afda-bbb322f0a168', '11111111-1111-1111-1111-111111111111', '764ab8d6-7220-4bfb-bb9f-23f7d804bc71', 'Special Masala Tea', NULL, true, NULL, true, '2026-09-03 13:45:53.435762+05:30', '2026-09-03 13:45:53.435762+05:30', NULL, NULL, NULL, 5.00, 3000, 100, NULL);
INSERT INTO public.menu_items VALUES ('d4d5c11d-7ca8-4f1f-9784-45b39bd6ef7c', '11111111-1111-1111-1111-111111111111', 'c332c03a-b4ff-4db0-b13f-b241c651abc8', 'panipuri', NULL, true, NULL, true, '2026-09-08 11:25:20.57+05:30', '2026-09-08 11:25:20.57+05:30', NULL, NULL, NULL, 5.00, 8000, 100, NULL);
INSERT INTO public.menu_items VALUES ('8fe74946-54cc-4f68-ae82-5f775ef44b20', '11111111-1111-1111-1111-111111111111', 'c332c03a-b4ff-4db0-b13f-b241c651abc8', 'veg-manchuria', NULL, true, NULL, true, '2026-09-08 11:26:36.857+05:30', '2026-09-08 11:27:30.985+05:30', NULL, NULL, NULL, 5.00, 12000, 100, NULL);
INSERT INTO public.menu_items VALUES ('4a8d3fad-d0e2-4c19-8840-9ef706f90b7b', '11111111-1111-1111-1111-111111111111', 'a65ebbc1-bfb6-42ce-95cf-112d5a76e825', '(S) Idly (S) Vada', NULL, true, NULL, true, '2026-09-03 13:45:53.393528+05:30', '2026-09-09 13:03:40.076+05:30', NULL, NULL, NULL, 5.00, 7000, 100, NULL);
INSERT INTO public.menu_items VALUES ('49768e80-5cf1-47a9-be73-5f24de6fb26e', '11111111-1111-1111-1111-111111111111', 'a65ebbc1-bfb6-42ce-95cf-112d5a76e825', '(S) Idly', NULL, true, NULL, true, '2026-09-03 13:45:53.391786+05:30', '2026-09-09 14:34:02.306+05:30', NULL, NULL, NULL, 5.00, 5000, 100, NULL);
INSERT INTO public.menu_items VALUES ('e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', '11111111-1111-1111-1111-111111111111', 'a65ebbc1-bfb6-42ce-95cf-112d5a76e825', '(2) Idly (1) Vada', NULL, true, NULL, false, '2026-09-03 13:45:53.390049+05:30', '2026-09-09 13:02:03.792+05:30', NULL, NULL, NULL, 5.00, 8500, 100, NULL);


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

INSERT INTO public.notifications VALUES ('b3d1aef5-579a-4fb6-97bd-531737e3adb2', '67315042-c687-4cbb-b45a-f4ea4efc199f', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', 'INVENTORY_ALERT', 'Low Stock Alert', 'Basmati Rice is below reorder level (10 kg remaining).', NULL, NULL, false, '2026-09-03 12:29:17.471553+05:30', '2026-09-03 12:29:17.471553+05:30');
INSERT INTO public.notifications VALUES ('600eb731-32c7-46f3-af6a-d151383aba5a', '67315042-c687-4cbb-b45a-f4ea4efc199f', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', 'ORDER_ALERT', 'Table A3 Billing Request', 'Table A3 has requested final physical invoice.', NULL, NULL, false, '2026-09-03 12:29:17.474223+05:30', '2026-09-03 12:29:17.474223+05:30');
INSERT INTO public.notifications VALUES ('e6466008-1cff-4c68-b18a-ad9da045353a', '67315042-c687-4cbb-b45a-f4ea4efc199f', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', 'AGGREGATOR_ALERT', 'New Swiggy Order', 'Order #SW-8821 received and confirmed.', NULL, NULL, false, '2026-09-03 12:29:17.47587+05:30', '2026-09-03 12:29:17.47587+05:30');
INSERT INTO public.notifications VALUES ('54a6fb8c-6008-4cd4-a684-c8f24f2cc2f8', '67315042-c687-4cbb-b45a-f4ea4efc199f', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', 'SYSTEM_ALERT', 'Shift Register Opened', 'Cashier shift opened on Terminal T-01.', NULL, NULL, false, '2026-09-03 12:29:17.477473+05:30', '2026-09-03 12:29:17.477473+05:30');
INSERT INTO public.notifications VALUES ('86274bf0-8003-41b4-b468-ef5c4e4a6182', '11111111-1111-1111-1111-111111111111', NULL, 'ORDER', '📅 Advance Order Booked', 'Order #c18247 (DELIVERY) scheduled for 03:12 PM.', 'ADVANCE_ORDER', 'c182470d-5000-40bc-86f8-b9093c4333e8', true, '2026-09-09 14:27:33.605+05:30', '2026-09-11 11:40:46.369+05:30');
INSERT INTO public.notifications VALUES ('a057c311-39e4-4fc8-bbe7-8d8f3091a61a', '11111111-1111-1111-1111-111111111111', NULL, 'ORDER', '📅 Advance Order Booked', 'Order #482d35 (DELIVERY) scheduled for 03:13 PM.', 'ADVANCE_ORDER', '482d35cd-b7b6-4c65-a7f3-943897646bad', true, '2026-09-09 14:28:57.938+05:30', '2026-09-11 11:40:46.369+05:30');
INSERT INTO public.notifications VALUES ('12019710-7efe-47a9-964c-2da57e0b6363', '11111111-1111-1111-1111-111111111111', NULL, 'ORDER', '📅 Advance Order Booked', 'Order #25ab98 (DELIVERY) scheduled for 03:14 PM.', 'ADVANCE_ORDER', '25ab98b4-6057-4986-a634-4dd7dc5f51bc', true, '2026-09-09 14:29:43.291+05:30', '2026-09-11 11:40:46.369+05:30');
INSERT INTO public.notifications VALUES ('90d31835-599a-40d6-94f4-5471b29e260b', '11111111-1111-1111-1111-111111111111', NULL, 'ORDER', '📅 Advance Order Booked', 'Order #655055 (DELIVERY) scheduled for 03:16 PM.', 'ADVANCE_ORDER', '65505588-f509-44ef-a6c6-c488503dcbe3', true, '2026-09-09 14:31:14.507+05:30', '2026-09-11 11:40:46.369+05:30');
INSERT INTO public.notifications VALUES ('5483f0ec-26dc-4d59-95f2-7c7efaf8a9ba', '11111111-1111-1111-1111-111111111111', NULL, 'ORDER', '📅 Advance Order Booked', 'Order #b6abe3 (DELIVERY) scheduled for 03:16 PM.', 'ADVANCE_ORDER', 'b6abe3e6-d0e7-4dc7-a631-097181effc3a', true, '2026-09-09 14:31:59.219+05:30', '2026-09-11 11:40:46.369+05:30');
INSERT INTO public.notifications VALUES ('73f7d795-d04d-4f1b-b1fa-550fda75d767', '11111111-1111-1111-1111-111111111111', NULL, 'ORDER', '📅 Advance Order Booked', 'Order #d71091 (DELIVERY) scheduled for 03:17 PM.', 'ADVANCE_ORDER', 'd71091c4-71f0-4c75-bd38-c6b08ba4dd4a', true, '2026-09-09 14:32:48.537+05:30', '2026-09-11 11:40:46.369+05:30');
INSERT INTO public.notifications VALUES ('7f4b5375-8fa5-45da-9e94-71b2f4e7f105', '11111111-1111-1111-1111-111111111111', NULL, 'ORDER', 'Birthday party', 'Birthday party', NULL, NULL, true, '2026-09-09 14:33:06.435+05:30', '2026-09-11 11:40:46.369+05:30');
INSERT INTO public.notifications VALUES ('b95282bb-0eae-4a99-b1db-cec15b3428ee', '11111111-1111-1111-1111-111111111111', NULL, 'ORDER', '📅 Advance Order Booked', 'Order #d1467f (DELIVERY) scheduled for 03:19 PM.', 'ADVANCE_ORDER', 'd1467f47-4869-4592-996e-0d3f373ec018', true, '2026-09-09 14:34:00.999+05:30', '2026-09-11 11:40:46.369+05:30');


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

INSERT INTO public.order_items VALUES ('3ec3d585-9c38-4fc4-a329-931e0e9e0b66', '11111111-1111-1111-1111-111111111111', 'b0845453-ec80-411d-8370-e62958475492', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', NULL, 'Item', 1, 850000, 850000, NULL, '2026-09-03 14:07:10.175393+05:30', '2026-09-03 14:07:10.175393+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 1, 8500, 8500, NULL, NULL);
INSERT INTO public.order_items VALUES ('a9808642-6b79-4671-8a6c-8cd23c09b26e', '11111111-1111-1111-1111-111111111111', '5338928a-7fb6-429f-a646-8f12166322fa', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', NULL, 'Item', 1, 850000, 850000, NULL, '2026-09-03 14:07:13.288985+05:30', '2026-09-03 14:07:13.288985+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 1, 8500, 8500, NULL, NULL);
INSERT INTO public.order_items VALUES ('e8af1bf5-d308-4abf-a808-26137ab677cd', '11111111-1111-1111-1111-111111111111', '17cb34b5-878f-4d13-b0ec-02af3307cbf2', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', NULL, 'Item', 1, 850000, 1700000, NULL, '2026-09-03 14:10:08.91939+05:30', '2026-09-03 14:10:08.91939+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 2, 8500, 17000, NULL, NULL);
INSERT INTO public.order_items VALUES ('721e66e5-a6c1-479a-8c61-4eb3ef4cb8b7', '11111111-1111-1111-1111-111111111111', '17cb34b5-878f-4d13-b0ec-02af3307cbf2', '49768e80-5cf1-47a9-be73-5f24de6fb26e', NULL, 'Item', 1, 500000, 500000, NULL, '2026-09-03 14:10:08.91939+05:30', '2026-09-03 14:10:08.91939+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, '49768e80-5cf1-47a9-be73-5f24de6fb26e', 1, 5000, 5000, NULL, NULL);
INSERT INTO public.order_items VALUES ('13f81108-0d71-497a-8c59-fb2c9cff2f79', '11111111-1111-1111-1111-111111111111', '4a3e148b-1df0-46f8-a71a-c834486429e5', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', NULL, 'Item', 1, 850000, 1700000, NULL, '2026-09-03 14:19:54.415923+05:30', '2026-09-03 14:19:54.415923+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 2, 8500, 17000, NULL, NULL);
INSERT INTO public.order_items VALUES ('39232e63-b520-40d1-8382-802fb32cd741', '11111111-1111-1111-1111-111111111111', 'e93358df-ec3b-4e3b-a241-8e93bd953411', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', NULL, 'Item', 1, 850000, 850000, NULL, '2026-09-03 14:21:16.165139+05:30', '2026-09-03 14:21:16.165139+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 1, 8500, 8500, NULL, NULL);
INSERT INTO public.order_items VALUES ('7a7080c6-7647-4996-a6cd-586f5613338b', '11111111-1111-1111-1111-111111111111', '71ef893c-0ccc-439d-bc3e-0a248037303b', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', NULL, 'Item', 1, 850000, 850000, NULL, '2026-09-03 14:25:51.848776+05:30', '2026-09-03 14:25:51.848776+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 1, 8500, 8500, NULL, NULL);
INSERT INTO public.order_items VALUES ('a9c5759c-98c5-4e33-a8dc-e558deae6d28', '11111111-1111-1111-1111-111111111111', 'e7eccfdc-02d5-470f-869b-da665f7dcb2e', '2ddb7944-4e83-4dda-99de-94dd5e83bb77', NULL, 'Item', 1, 3200000, 3200000, NULL, '2026-09-03 14:53:11.842258+05:30', '2026-09-03 14:53:11.842258+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '2ddb7944-4e83-4dda-99de-94dd5e83bb77', 1, 32000, 32000, NULL, NULL);
INSERT INTO public.order_items VALUES ('83af21bb-0221-4d95-b9c3-7c3261a4dfac', '11111111-1111-1111-1111-111111111111', '5583e31e-48a5-435a-936e-aba2f8bb9c9c', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', NULL, 'Item', 1, 8500, 8500, NULL, '2026-09-03 15:17:20.184009+05:30', '2026-09-03 15:17:20.184009+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 1, 8500, 8500, NULL, NULL);
INSERT INTO public.order_items VALUES ('025735c2-f199-4819-a694-73b1b678ed09', '11111111-1111-1111-1111-111111111111', 'e7eccfdc-02d5-470f-869b-da665f7dcb2e', '49768e80-5cf1-47a9-be73-5f24de6fb26e', NULL, 'Item', 1, 5000, 5000, NULL, '2026-09-04 00:02:44.743219+05:30', '2026-09-04 00:02:44.743219+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 1, 5000, 5000, NULL, NULL);
INSERT INTO public.order_items VALUES ('9c79b32c-196b-4a2d-bd1f-0c7aa4a96a5b', '11111111-1111-1111-1111-111111111111', '0f621958-d193-4d99-b6ef-037fcea9cd0a', '49768e80-5cf1-47a9-be73-5f24de6fb26e', NULL, 'Item', 1, 5000, 5000, NULL, '2026-09-04 00:05:22.293052+05:30', '2026-09-04 00:05:22.293052+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 1, 5000, 5000, NULL, NULL);
INSERT INTO public.order_items VALUES ('ffe3d2a6-2bcf-4f51-96b0-958fc529e51e', '11111111-1111-1111-1111-111111111111', '0f621958-d193-4d99-b6ef-037fcea9cd0a', '9e27f8db-5ca3-4d7f-97d4-aa3d87642452', NULL, 'Item', 1, 11000, 11000, NULL, '2026-09-04 00:05:57.362581+05:30', '2026-09-04 00:05:57.362581+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '9e27f8db-5ca3-4d7f-97d4-aa3d87642452', 1, 11000, 11000, NULL, NULL);
INSERT INTO public.order_items VALUES ('2ac5255a-707d-4147-904d-96a126ba13b3', '11111111-1111-1111-1111-111111111111', 'a00d57c3-c01d-49d0-9166-45e9f7e22497', '9e27f8db-5ca3-4d7f-97d4-aa3d87642452', NULL, 'Item', 1, 11000, 11000, NULL, '2026-09-04 00:40:55.685953+05:30', '2026-09-04 00:40:55.685953+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '9e27f8db-5ca3-4d7f-97d4-aa3d87642452', 1, 11000, 11000, NULL, NULL);
INSERT INTO public.order_items VALUES ('8b8157f3-0319-41be-a36d-87ed1df95c5f', '11111111-1111-1111-1111-111111111111', 'ece12171-62db-4f53-ba97-d5e93e06f733', '71451535-8d85-417f-b0ec-3f2b87016045', NULL, 'Item', 1, 8000, 8000, NULL, '2026-09-04 01:04:33.31612+05:30', '2026-09-04 01:04:33.31612+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '71451535-8d85-417f-b0ec-3f2b87016045', 1, 8000, 8000, NULL, NULL);
INSERT INTO public.order_items VALUES ('d01fed96-5b0c-4732-b314-b81a54946dce', '11111111-1111-1111-1111-111111111111', 'ece12171-62db-4f53-ba97-d5e93e06f733', '4a8d3fad-d0e2-4c19-8840-9ef706f90b7b', NULL, 'Item', 1, 7000, 7000, NULL, '2026-09-04 01:04:33.31612+05:30', '2026-09-04 01:04:33.31612+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '4a8d3fad-d0e2-4c19-8840-9ef706f90b7b', 1, 7000, 7000, NULL, NULL);
INSERT INTO public.order_items VALUES ('9bc19328-1e90-4001-8205-a2f448775c76', '11111111-1111-1111-1111-111111111111', 'b5177d27-2e27-4abd-8296-83a748730b2c', '49768e80-5cf1-47a9-be73-5f24de6fb26e', NULL, 'Item', 1, 5000, 5000, NULL, '2026-09-04 01:19:56.479604+05:30', '2026-09-04 01:19:56.479604+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, '49768e80-5cf1-47a9-be73-5f24de6fb26e', 1, 5000, 5000, NULL, NULL);
INSERT INTO public.order_items VALUES ('f4a218ac-99e4-48cf-b6e1-60afc00828c5', '11111111-1111-1111-1111-111111111111', 'b5177d27-2e27-4abd-8296-83a748730b2c', '9e27f8db-5ca3-4d7f-97d4-aa3d87642452', NULL, 'Item', 1, 11000, 11000, NULL, '2026-09-04 01:19:56.479604+05:30', '2026-09-04 01:19:56.479604+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, '9e27f8db-5ca3-4d7f-97d4-aa3d87642452', 1, 11000, 11000, NULL, NULL);
INSERT INTO public.order_items VALUES ('a09767f3-e815-483d-aff9-8d334baff511', '11111111-1111-1111-1111-111111111111', 'a00d57c3-c01d-49d0-9166-45e9f7e22497', '094b3d75-f087-476a-863b-a70da76e2365', NULL, 'Item', 1, 34000, 34000, NULL, '2026-09-05 13:19:55.615319+05:30', '2026-09-05 13:19:55.615319+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '094b3d75-f087-476a-863b-a70da76e2365', 1, 34000, 34000, NULL, NULL);
INSERT INTO public.order_items VALUES ('03d3bde6-a0d7-48d9-abef-c298fbbb36fb', '11111111-1111-1111-1111-111111111111', 'e7d4d6cf-4838-43bd-8334-688d11302496', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', NULL, 'Item', 1, 8500, 8500, NULL, '2026-09-05 14:26:19.023081+05:30', '2026-09-05 14:26:19.023081+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 1, 8500, 8500, NULL, NULL);
INSERT INTO public.order_items VALUES ('60295abb-8a59-4a0f-97e8-b32182500594', '11111111-1111-1111-1111-111111111111', '0f3580d0-cceb-4289-99f8-5ffdf1669b18', '49768e80-5cf1-47a9-be73-5f24de6fb26e', NULL, 'Item', 1, 5000, 5000, NULL, '2026-09-05 15:10:12.583023+05:30', '2026-09-05 15:10:12.583023+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, '49768e80-5cf1-47a9-be73-5f24de6fb26e', 1, 5000, 5000, NULL, NULL);
INSERT INTO public.order_items VALUES ('e757b52b-9567-44bd-a492-3bb3519b4cb5', '11111111-1111-1111-1111-111111111111', 'c3a366cb-039e-4e26-9cbd-8e22cd2d52b9', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', NULL, 'Item', 1, 8500, 8500, NULL, '2026-09-05 16:22:38.176715+05:30', '2026-09-05 16:22:38.176715+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 1, 8500, 8500, NULL, NULL);
INSERT INTO public.order_items VALUES ('e33ec171-252d-4f6b-acac-694e76f4bf53', '67315042-c687-4cbb-b45a-f4ea4efc199f', '5b433b06-af43-4f62-8a6b-e2ca1e0bfa88', '1048c560-86bd-45c5-b872-eb5e802c6e46', NULL, 'Item', 1, 34000, 34000, NULL, '2026-09-05 16:45:41.983161+05:30', '2026-09-05 16:45:41.983161+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, '1048c560-86bd-45c5-b872-eb5e802c6e46', 1, 34000, 34000, NULL, NULL);
INSERT INTO public.order_items VALUES ('f497179e-87b0-4f64-8408-05071bc7a8ff', '11111111-1111-1111-1111-111111111111', '7a369854-faf1-4af3-8378-8b939249c434', '7e1e6434-2ee4-428b-aafc-05be27e770d9', NULL, 'Item', 1, 6500, 6500, NULL, '2026-09-05 16:51:32.697449+05:30', '2026-09-05 16:51:32.697449+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, '7e1e6434-2ee4-428b-aafc-05be27e770d9', 1, 6500, 6500, NULL, NULL);
INSERT INTO public.order_items VALUES ('f0971839-9aef-47e4-9c3d-2cf44ce82eaf', '11111111-1111-1111-1111-111111111111', '82e2a068-a74a-4e18-89fe-7a423f5b243f', '4a8d3fad-d0e2-4c19-8840-9ef706f90b7b', NULL, 'Item', 1, 7000, 7000, NULL, '2026-09-05 17:05:54.944586+05:30', '2026-09-05 17:05:54.944586+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '4a8d3fad-d0e2-4c19-8840-9ef706f90b7b', 1, 7000, 7000, NULL, NULL);
INSERT INTO public.order_items VALUES ('de62921f-d4dc-4fea-a8f4-56fe8b04f116', '11111111-1111-1111-1111-111111111111', '1085cebe-ebf0-4804-83f3-aae6d0d4a7c9', '88ec151b-ebde-4993-809f-79f7e29a4385', NULL, 'Item', 1, 3500, 3500, NULL, '2026-09-08 11:05:04.301438+05:30', '2026-09-08 11:05:04.301438+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '88ec151b-ebde-4993-809f-79f7e29a4385', 1, 3500, 3500, NULL, NULL);
INSERT INTO public.order_items VALUES ('9c5395eb-db1c-48f8-803a-f011a251c77a', '11111111-1111-1111-1111-111111111111', '1085cebe-ebf0-4804-83f3-aae6d0d4a7c9', '094b3d75-f087-476a-863b-a70da76e2365', NULL, 'Item', 1, 34000, 68000, NULL, '2026-09-08 11:09:01.355061+05:30', '2026-09-08 11:09:01.355061+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '094b3d75-f087-476a-863b-a70da76e2365', 2, 34000, 68000, NULL, NULL);
INSERT INTO public.order_items VALUES ('18ec13cb-0674-4f07-b06a-166a80d9c6b7', '11111111-1111-1111-1111-111111111111', 'e7d4d6cf-4838-43bd-8334-688d11302496', '094b3d75-f087-476a-863b-a70da76e2365', NULL, 'Item', 1, 34000, 102000, NULL, '2026-09-08 11:12:06.961926+05:30', '2026-09-08 11:12:06.961926+05:30', NULL, NULL, NULL, NULL, false, NULL, false, 10, 'STARTER', '094b3d75-f087-476a-863b-a70da76e2365', 3, 34000, 102000, NULL, NULL);
INSERT INTO public.order_items VALUES ('ae1afbe0-fd20-4f80-973b-bf1ca6b3c498', '11111111-1111-1111-1111-111111111111', 'eb13fd97-c972-4447-8a42-898eb545191e', 'd4d5c11d-7ca8-4f1f-9784-45b39bd6ef7c', NULL, 'Item', 1, 8000, 8000, NULL, '2026-09-08 13:13:14.858193+05:30', '2026-09-08 13:13:14.858193+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', 'd4d5c11d-7ca8-4f1f-9784-45b39bd6ef7c', 1, 8000, 8000, NULL, NULL);
INSERT INTO public.order_items VALUES ('e692ea73-ba2b-457b-a326-3baee8941065', '11111111-1111-1111-1111-111111111111', 'eb13fd97-c972-4447-8a42-898eb545191e', '8fe74946-54cc-4f68-ae82-5f775ef44b20', NULL, 'Item', 1, 12000, 12000, NULL, '2026-09-08 13:13:14.858193+05:30', '2026-09-08 13:13:14.858193+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '8fe74946-54cc-4f68-ae82-5f775ef44b20', 1, 12000, 12000, NULL, NULL);
INSERT INTO public.order_items VALUES ('4994ad24-bebe-49a0-977b-faa12ee5ed46', '11111111-1111-1111-1111-111111111111', 'f5d3449d-ce21-48cb-ab01-b41c41a7301c', '88edfc29-cdb9-469b-afda-bbb322f0a168', NULL, 'Item', 1, 3000, 3000, NULL, '2026-09-08 13:14:15.227885+05:30', '2026-09-08 13:14:15.227885+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '88edfc29-cdb9-469b-afda-bbb322f0a168', 1, 3000, 3000, NULL, NULL);
INSERT INTO public.order_items VALUES ('7189e68a-4aef-4e32-876e-56a9f20a4a9c', '11111111-1111-1111-1111-111111111111', 'f5d3449d-ce21-48cb-ab01-b41c41a7301c', '8fe74946-54cc-4f68-ae82-5f775ef44b20', NULL, 'Item', 1, 12000, 12000, NULL, '2026-09-08 13:14:15.227885+05:30', '2026-09-08 13:14:15.227885+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '8fe74946-54cc-4f68-ae82-5f775ef44b20', 1, 12000, 12000, NULL, NULL);
INSERT INTO public.order_items VALUES ('b80c6285-d018-47a1-9dfa-2e686b8effc3', '11111111-1111-1111-1111-111111111111', 'f5d3449d-ce21-48cb-ab01-b41c41a7301c', '49768e80-5cf1-47a9-be73-5f24de6fb26e', NULL, 'Item', 1, 5000, 5000, NULL, '2026-09-08 14:14:29.187607+05:30', '2026-09-08 14:14:29.187607+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 1, 5000, 5000, NULL, NULL);
INSERT INTO public.order_items VALUES ('78627a3c-b92a-42d4-adba-b530878b560f', '11111111-1111-1111-1111-111111111111', 'b101f725-9679-4cf3-9f0f-16adb200ecff', '2c28152b-2d3a-4796-ac1f-aa04d783f921', NULL, 'Item', 1, 3000, 3000, NULL, '2026-09-08 14:27:24.395569+05:30', '2026-09-08 14:27:24.395569+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, '2c28152b-2d3a-4796-ac1f-aa04d783f921', 1, 3000, 3000, NULL, NULL);
INSERT INTO public.order_items VALUES ('74a7e192-fc57-4923-8f2f-61dbb363b66f', '11111111-1111-1111-1111-111111111111', '685aa7a6-e1d4-4a39-a7fe-c54252180927', '9e27f8db-5ca3-4d7f-97d4-aa3d87642452', NULL, 'Item', 1, 11000, 11000, NULL, '2026-09-08 14:41:53.550636+05:30', '2026-09-08 14:41:53.550636+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, '9e27f8db-5ca3-4d7f-97d4-aa3d87642452', 1, 11000, 11000, NULL, NULL);
INSERT INTO public.order_items VALUES ('a8871109-ffa1-481a-88da-e56804420b05', '11111111-1111-1111-1111-111111111111', '76692730-cd05-45cd-b8ad-9cc20ac9fc5a', '4a8d3fad-d0e2-4c19-8840-9ef706f90b7b', NULL, 'Item', 1, 7000, 7000, NULL, '2026-09-08 15:13:45.019446+05:30', '2026-09-08 15:13:45.019446+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, '4a8d3fad-d0e2-4c19-8840-9ef706f90b7b', 1, 7000, 7000, NULL, NULL);
INSERT INTO public.order_items VALUES ('7ef66626-f4e7-4ebe-a4fe-4e09367d8ab0', '11111111-1111-1111-1111-111111111111', 'f5d3449d-ce21-48cb-ab01-b41c41a7301c', '5d13a97e-027a-445b-94eb-2f00546b1614', NULL, 'Item', 1, 9500, 9500, NULL, '2026-09-08 16:19:27.270906+05:30', '2026-09-08 16:19:27.270906+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '5d13a97e-027a-445b-94eb-2f00546b1614', 1, 9500, 9500, NULL, NULL);
INSERT INTO public.order_items VALUES ('f89483cf-0d93-4bc0-816a-285a7a13d065', '11111111-1111-1111-1111-111111111111', 'f5d3449d-ce21-48cb-ab01-b41c41a7301c', 'e286dcdc-8100-430d-967e-6edba83f1609', NULL, 'Item', 1, 14000, 14000, NULL, '2026-09-08 16:19:27.270906+05:30', '2026-09-08 16:19:27.270906+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', 'e286dcdc-8100-430d-967e-6edba83f1609', 1, 14000, 14000, NULL, NULL);
INSERT INTO public.order_items VALUES ('e6d644af-1584-467a-863f-bac26eb84d38', '11111111-1111-1111-1111-111111111111', '0602cb47-3398-4ba0-b5da-87e23909efa3', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', NULL, 'Item', 1, 8500, 8500, NULL, '2026-09-09 12:47:30.71336+05:30', '2026-09-09 12:47:30.71336+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 1, 8500, 8500, NULL, NULL);
INSERT INTO public.order_items VALUES ('4c625b81-fece-407d-9b63-dced164b38b1', '11111111-1111-1111-1111-111111111111', '0602cb47-3398-4ba0-b5da-87e23909efa3', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', NULL, 'Item', 1, 8500, 8500, NULL, '2026-09-09 12:47:50.69576+05:30', '2026-09-09 12:47:50.69576+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 1, 8500, 8500, NULL, NULL);
INSERT INTO public.order_items VALUES ('92084d9f-089e-4c18-8537-8a75358fb278', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'c69c7c36-7b05-4ca7-9012-710df44ed6fd', 'c4945f10-ab36-4a6a-8388-0a0c4904d9da', NULL, 'Hyderabadi Paneer Dum Biryani', 1, 2800000, 2800000, NULL, '2026-09-03 12:29:17.515281+05:30', '2026-09-03 12:29:17.515281+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, 'c4945f10-ab36-4a6a-8388-0a0c4904d9da', 1, 0, 0, NULL, NULL);
INSERT INTO public.order_items VALUES ('31447489-e6af-4bc5-a132-783f2da200c0', '11111111-1111-1111-1111-111111111111', '0602cb47-3398-4ba0-b5da-87e23909efa3', '49768e80-5cf1-47a9-be73-5f24de6fb26e', NULL, 'Item', 1, 5000, 450000, NULL, '2026-09-09 12:48:24.578971+05:30', '2026-09-09 12:48:24.578971+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 90, 5000, 450000, NULL, NULL);
INSERT INTO public.order_items VALUES ('b755bfc3-dea9-4d8f-b6d1-a7decce5f8be', '11111111-1111-1111-1111-111111111111', '0602cb47-3398-4ba0-b5da-87e23909efa3', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', NULL, 'Item', 1, 8500, 42500, NULL, '2026-09-09 12:49:23.847265+05:30', '2026-09-09 12:49:23.847265+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 5, 8500, 42500, NULL, NULL);
INSERT INTO public.order_items VALUES ('c6fbd83e-75ed-472a-b1bf-2e7889b797f0', '11111111-1111-1111-1111-111111111111', '2d4b655e-a5bf-4900-ba0c-11e1b3c2685c', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', NULL, 'Item', 1, 8500, 8500, NULL, '2026-09-09 12:51:14.215584+05:30', '2026-09-09 12:51:14.215584+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 1, 8500, 8500, NULL, NULL);
INSERT INTO public.order_items VALUES ('04e04ddf-bbb4-4e74-ae9e-864aca2029d4', '11111111-1111-1111-1111-111111111111', '2d4b655e-a5bf-4900-ba0c-11e1b3c2685c', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', NULL, 'Item', 1, 8500, 136000, NULL, '2026-09-09 12:51:28.083736+05:30', '2026-09-09 12:51:28.083736+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 16, 8500, 136000, NULL, NULL);
INSERT INTO public.order_items VALUES ('4923d9da-bcb2-46da-833a-8b4a037f0436', '11111111-1111-1111-1111-111111111111', '2d4b655e-a5bf-4900-ba0c-11e1b3c2685c', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', NULL, 'Item', 1, 8500, 272000, NULL, '2026-09-09 12:51:46.669142+05:30', '2026-09-09 12:51:46.669142+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 32, 8500, 272000, NULL, NULL);
INSERT INTO public.order_items VALUES ('e2ac9075-4d00-464e-88a2-afe715362121', '11111111-1111-1111-1111-111111111111', 'f973888e-e429-473a-8566-ddea7ac708a0', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', NULL, 'Item', 1, 8500, 25500, NULL, '2026-09-09 12:52:31.629819+05:30', '2026-09-09 12:52:31.629819+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 3, 8500, 25500, NULL, NULL);
INSERT INTO public.order_items VALUES ('f79c39a2-f114-496c-bf0e-09ac73ddf914', '11111111-1111-1111-1111-111111111111', '2d4b655e-a5bf-4900-ba0c-11e1b3c2685c', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', NULL, 'Item', 1, 8500, 34000, NULL, '2026-09-09 12:55:56.357916+05:30', '2026-09-09 12:55:56.357916+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 4, 8500, 34000, NULL, NULL);
INSERT INTO public.order_items VALUES ('03ec0df1-5176-44d6-befb-8477fd240cb0', '11111111-1111-1111-1111-111111111111', '190ec2cb-fb90-44c2-ad76-b32672063fdb', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', NULL, 'Item', 1, 8500, 25500, NULL, '2026-09-09 13:01:25.151456+05:30', '2026-09-09 13:01:25.151456+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 3, 8500, 25500, NULL, NULL);
INSERT INTO public.order_items VALUES ('970e6000-56da-419a-9d6c-33afca6265fd', '11111111-1111-1111-1111-111111111111', '4e192b03-6942-454a-a9dd-9084d99362b1', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', NULL, 'Item', 1, 8500, 25500, NULL, '2026-09-09 13:02:02.16991+05:30', '2026-09-09 13:02:02.16991+05:30', NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 3, 8500, 25500, 'TEST_VOID', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_items VALUES ('aa746b8b-9705-4520-a5a8-54ab4190f58c', '11111111-1111-1111-1111-111111111111', '9528cbcc-5873-41a3-b142-53165932bc70', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', NULL, 'Item', 1, 8500, 127500, NULL, '2026-09-09 13:02:03.709268+05:30', '2026-09-09 13:02:03.709268+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 15, 8500, 127500, NULL, NULL);
INSERT INTO public.order_items VALUES ('2bf7206e-c6f3-44aa-981c-a457abf6e62a', '11111111-1111-1111-1111-111111111111', '39f6e5e8-3eb1-4100-a8cc-4dfcb49ba060', '4a8d3fad-d0e2-4c19-8840-9ef706f90b7b', NULL, 'Item', 1, 7000, 21000, NULL, '2026-09-09 13:03:37.790437+05:30', '2026-09-09 13:03:37.790437+05:30', NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, '4a8d3fad-d0e2-4c19-8840-9ef706f90b7b', 3, 7000, 21000, 'TEST_VOID', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_items VALUES ('d07b13ab-7416-45f5-aa50-d4c92edb3536', '11111111-1111-1111-1111-111111111111', '118a762d-2cc4-4b94-b0c6-1b7360cd6652', '4a8d3fad-d0e2-4c19-8840-9ef706f90b7b', NULL, 'Item', 1, 7000, 105000, NULL, '2026-09-09 13:03:39.348843+05:30', '2026-09-09 13:03:39.348843+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, '4a8d3fad-d0e2-4c19-8840-9ef706f90b7b', 15, 7000, 105000, NULL, NULL);
INSERT INTO public.order_items VALUES ('1aa6fbfe-8643-49a5-8246-69a71196a167', '11111111-1111-1111-1111-111111111111', '0a746ebb-ff2b-40d1-8d00-5e7652f56006', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', NULL, 'Item', 1, 8500, 8500, NULL, '2026-09-09 14:27:26.129288+05:30', '2026-09-09 14:27:26.129288+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', 'e7d95cfe-261f-4545-b37b-2a4d3e69ca8d', 1, 8500, 8500, NULL, NULL);
INSERT INTO public.order_items VALUES ('94a171f1-9bff-45e7-b655-9b864a43ec78', '11111111-1111-1111-1111-111111111111', 'c182470d-5000-40bc-86f8-b9093c4333e8', '49768e80-5cf1-47a9-be73-5f24de6fb26e', NULL, 'Item', 1, 5000, 25000, NULL, '2026-09-09 14:27:33.522587+05:30', '2026-09-09 14:27:33.522587+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, '49768e80-5cf1-47a9-be73-5f24de6fb26e', 5, 5000, 25000, NULL, NULL);
INSERT INTO public.order_items VALUES ('342243f5-67c3-4f51-a5f7-c6441c0f8058', '11111111-1111-1111-1111-111111111111', '482d35cd-b7b6-4c65-a7f3-943897646bad', '49768e80-5cf1-47a9-be73-5f24de6fb26e', NULL, 'Item', 1, 5000, 25000, NULL, '2026-09-09 14:28:57.778133+05:30', '2026-09-09 14:28:57.778133+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, '49768e80-5cf1-47a9-be73-5f24de6fb26e', 5, 5000, 25000, NULL, NULL);
INSERT INTO public.order_items VALUES ('28791b77-9a0b-4827-8fc3-156591208ce4', '11111111-1111-1111-1111-111111111111', '25ab98b4-6057-4986-a634-4dd7dc5f51bc', '49768e80-5cf1-47a9-be73-5f24de6fb26e', NULL, 'Item', 1, 5000, 25000, NULL, '2026-09-09 14:29:43.187526+05:30', '2026-09-09 14:29:43.187526+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, '49768e80-5cf1-47a9-be73-5f24de6fb26e', 5, 5000, 25000, NULL, NULL);
INSERT INTO public.order_items VALUES ('8fa479df-4828-4bbd-8781-0445ec6a7a4e', '11111111-1111-1111-1111-111111111111', '65505588-f509-44ef-a6c6-c488503dcbe3', '49768e80-5cf1-47a9-be73-5f24de6fb26e', NULL, 'Item', 1, 5000, 25000, NULL, '2026-09-09 14:31:14.437955+05:30', '2026-09-09 14:31:14.437955+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, '49768e80-5cf1-47a9-be73-5f24de6fb26e', 5, 5000, 25000, NULL, NULL);
INSERT INTO public.order_items VALUES ('1d24f99b-b19c-40f1-b8f4-3c9e1222fd40', '11111111-1111-1111-1111-111111111111', 'b6abe3e6-d0e7-4dc7-a631-097181effc3a', '49768e80-5cf1-47a9-be73-5f24de6fb26e', NULL, 'Item', 1, 5000, 25000, NULL, '2026-09-09 14:31:59.195071+05:30', '2026-09-09 14:31:59.195071+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, '49768e80-5cf1-47a9-be73-5f24de6fb26e', 5, 5000, 25000, NULL, NULL);
INSERT INTO public.order_items VALUES ('f1df626b-fc7b-4399-bf69-c2502c895927', '11111111-1111-1111-1111-111111111111', 'd71091c4-71f0-4c75-bd38-c6b08ba4dd4a', '49768e80-5cf1-47a9-be73-5f24de6fb26e', NULL, 'Item', 1, 5000, 25000, NULL, '2026-09-09 14:32:48.219814+05:30', '2026-09-09 14:32:48.219814+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, '49768e80-5cf1-47a9-be73-5f24de6fb26e', 5, 5000, 25000, NULL, NULL);
INSERT INTO public.order_items VALUES ('c00be2b8-881c-4bde-9a46-577c19ea7bc3', '11111111-1111-1111-1111-111111111111', 'd1467f47-4869-4592-996e-0d3f373ec018', '49768e80-5cf1-47a9-be73-5f24de6fb26e', NULL, 'Item', 1, 5000, 25000, NULL, '2026-09-09 14:34:00.887085+05:30', '2026-09-09 14:34:00.887085+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, '49768e80-5cf1-47a9-be73-5f24de6fb26e', 5, 5000, 25000, NULL, NULL);
INSERT INTO public.order_items VALUES ('4803f052-a4cd-4a89-ab6f-74fac3d67772', '11111111-1111-1111-1111-111111111111', '0a746ebb-ff2b-40d1-8d00-5e7652f56006', '5101522a-081e-4866-9f74-261854fe4404', NULL, 'Item', 1, 6000, 6000, NULL, '2026-09-09 14:35:45.599475+05:30', '2026-09-09 14:35:45.599475+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '5101522a-081e-4866-9f74-261854fe4404', 1, 6000, 6000, NULL, NULL);
INSERT INTO public.order_items VALUES ('2f46c4fc-4fd6-4c9b-a3f8-acdbd42c0594', '11111111-1111-1111-1111-111111111111', '3e1ba9c8-0311-4534-a8d3-fa97b3a4f933', '49768e80-5cf1-47a9-be73-5f24de6fb26e', NULL, 'Item', 1, 5000, 5000, NULL, '2026-09-09 15:09:20.325753+05:30', '2026-09-09 15:09:20.325753+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 1, 5000, 5000, NULL, NULL);
INSERT INTO public.order_items VALUES ('1e52c5d3-8676-4aff-8aa4-2832b1212976', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'c69c7c36-7b05-4ca7-9012-710df44ed6fd', '1048c560-86bd-45c5-b872-eb5e802c6e46', NULL, 'Hotel Kapila Special Chicken Biryani (Boneless)', 2, 3400000, 6800000, NULL, '2026-09-03 12:29:17.503763+05:30', '2026-09-03 12:29:17.503763+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, '1048c560-86bd-45c5-b872-eb5e802c6e46', 1, 0, 0, NULL, NULL);
INSERT INTO public.order_items VALUES ('582a60f4-534d-4024-88c8-1f56e570f4de', '11111111-1111-1111-1111-111111111111', '3e1ba9c8-0311-4534-a8d3-fa97b3a4f933', '49768e80-5cf1-47a9-be73-5f24de6fb26e', NULL, 'Item', 1, 5000, 5000, NULL, '2026-09-10 16:50:52.998474+05:30', '2026-09-10 16:50:52.998474+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 1, 5000, 5000, NULL, NULL);
INSERT INTO public.order_items VALUES ('feaf21a6-4ea0-4b99-b0f0-bf197fa7b705', '11111111-1111-1111-1111-111111111111', '27f9f630-3e8b-4ba9-b4d7-e631e45182f7', '49768e80-5cf1-47a9-be73-5f24de6fb26e', NULL, 'Item', 1, 5000, 5000, NULL, '2026-09-11 12:09:46.272587+05:30', '2026-09-11 12:09:46.272587+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 1, 5000, 5000, NULL, NULL);
INSERT INTO public.order_items VALUES ('5325d83c-f786-4964-bdd3-08acdefa96be', '11111111-1111-1111-1111-111111111111', 'c8387bcf-ab67-44bb-87fb-d67f6d7601ca', '5101522a-081e-4866-9f74-261854fe4404', NULL, 'Item', 1, 6000, 12000, NULL, '2026-09-11 12:33:27.192618+05:30', '2026-09-11 12:33:27.192618+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '5101522a-081e-4866-9f74-261854fe4404', 2, 6000, 12000, NULL, NULL);
INSERT INTO public.order_items VALUES ('6d2bb836-3203-4c6c-a2ea-d81d3729a02d', '11111111-1111-1111-1111-111111111111', 'd8d53271-b231-47e9-93aa-7a47185f8940', '49768e80-5cf1-47a9-be73-5f24de6fb26e', NULL, 'Item', 1, 5000, 5000, NULL, '2026-09-11 12:59:30.534997+05:30', '2026-09-11 12:59:30.534997+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 1, 5000, 5000, NULL, NULL);
INSERT INTO public.order_items VALUES ('afde9793-1550-477e-b114-bdd6d6c5491e', '11111111-1111-1111-1111-111111111111', 'd8d53271-b231-47e9-93aa-7a47185f8940', '4a8d3fad-d0e2-4c19-8840-9ef706f90b7b', NULL, 'Item', 1, 7000, 7000, NULL, '2026-09-11 12:59:30.534997+05:30', '2026-09-11 12:59:30.534997+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '4a8d3fad-d0e2-4c19-8840-9ef706f90b7b', 1, 7000, 7000, NULL, NULL);
INSERT INTO public.order_items VALUES ('1bc49c16-8bb7-4650-a1c1-0f3afb56fdd8', '11111111-1111-1111-1111-111111111111', 'ccffe940-9f6b-41af-aaeb-72b3e1cdb3da', '5101522a-081e-4866-9f74-261854fe4404', NULL, 'Item', 1, 6000, 6000, NULL, '2026-09-11 12:59:52.770314+05:30', '2026-09-11 12:59:52.770314+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '5101522a-081e-4866-9f74-261854fe4404', 1, 6000, 6000, NULL, NULL);
INSERT INTO public.order_items VALUES ('4309f3ed-e176-42be-a96f-2a3a80c518eb', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'cff7a875-fec8-4189-bc71-ae49b0e19488', '1048c560-86bd-45c5-b872-eb5e802c6e46', NULL, 'Item', 1, 34000, 34000, NULL, '2026-09-11 14:11:01.851309+05:30', '2026-09-11 14:11:01.851309+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'MAIN', '1048c560-86bd-45c5-b872-eb5e802c6e46', 1, 34000, 34000, NULL, NULL);
INSERT INTO public.order_items VALUES ('69d4ccbf-020e-45f7-bff8-efdee2f95fb2', '67315042-c687-4cbb-b45a-f4ea4efc199f', '0c7bc59e-d90f-4a42-873f-88c0e9a02386', '1048c560-86bd-45c5-b872-eb5e802c6e46', NULL, 'Item', 1, 34000, 34000, NULL, '2026-09-11 14:12:08.652094+05:30', '2026-09-11 14:12:08.652094+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'MAIN', '1048c560-86bd-45c5-b872-eb5e802c6e46', 1, 34000, 34000, NULL, NULL);
INSERT INTO public.order_items VALUES ('a5ad1b27-1d4d-4a40-a7f8-1e08026ac3ba', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'f9b4ac11-21c8-4617-9a1d-f1d7e8147a37', '1048c560-86bd-45c5-b872-eb5e802c6e46', NULL, 'Item', 1, 34000, 34000, NULL, '2026-09-11 14:16:07.294659+05:30', '2026-09-11 14:16:07.294659+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'MAIN', '1048c560-86bd-45c5-b872-eb5e802c6e46', 1, 34000, 34000, NULL, NULL);
INSERT INTO public.order_items VALUES ('32733e86-926a-421a-86cd-ee6fb9ffb7a0', '67315042-c687-4cbb-b45a-f4ea4efc199f', '829e83e6-ea56-4173-bfe2-463b24e497a4', '1048c560-86bd-45c5-b872-eb5e802c6e46', NULL, 'Item', 1, 34000, 34000, NULL, '2026-09-11 14:19:07.406766+05:30', '2026-09-11 14:19:07.406766+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'MAIN', '1048c560-86bd-45c5-b872-eb5e802c6e46', 1, 34000, 34000, NULL, NULL);
INSERT INTO public.order_items VALUES ('45c18b8d-29a0-4435-98e2-db478e9242f9', '11111111-1111-1111-1111-111111111111', '89dba099-01ad-417a-a438-66ca8af5e712', '49768e80-5cf1-47a9-be73-5f24de6fb26e', NULL, 'Item', 1, 5000, 5000, NULL, '2026-09-11 14:24:19.816033+05:30', '2026-09-11 14:24:19.816033+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '49768e80-5cf1-47a9-be73-5f24de6fb26e', 1, 5000, 5000, NULL, NULL);
INSERT INTO public.order_items VALUES ('9fa4ac4f-fd3d-4490-9ad1-87bed53a26d7', '11111111-1111-1111-1111-111111111111', '4a4e9d6c-a797-4b03-9835-a44526c890e2', '5101522a-081e-4866-9f74-261854fe4404', NULL, 'Item', 1, 6000, 6000, NULL, '2026-09-11 14:25:28.490288+05:30', '2026-09-11 14:25:28.490288+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '5101522a-081e-4866-9f74-261854fe4404', 1, 6000, 6000, NULL, NULL);
INSERT INTO public.order_items VALUES ('4b8a17f6-cc5b-43d8-9bb1-23572af374e7', '11111111-1111-1111-1111-111111111111', '4a4e9d6c-a797-4b03-9835-a44526c890e2', '5101522a-081e-4866-9f74-261854fe4404', NULL, 'Item', 1, 6000, 6000, NULL, '2026-09-11 16:39:37.814336+05:30', '2026-09-11 16:39:37.814336+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '5101522a-081e-4866-9f74-261854fe4404', 1, 6000, 6000, NULL, NULL);
INSERT INTO public.order_items VALUES ('610ce49b-6860-4c2a-a978-58eee53abe0b', '11111111-1111-1111-1111-111111111111', 'abaed738-9e4f-4470-ae04-031b3baa4721', '4a8d3fad-d0e2-4c19-8840-9ef706f90b7b', NULL, 'Item', 1, 7000, 7000, NULL, '2026-09-12 16:04:39.509754+05:30', '2026-09-12 16:04:39.509754+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '4a8d3fad-d0e2-4c19-8840-9ef706f90b7b', 1, 7000, 7000, NULL, NULL);
INSERT INTO public.order_items VALUES ('e58cd3f4-fcb9-466f-882e-79f58c50f01d', '11111111-1111-1111-1111-111111111111', 'abaed738-9e4f-4470-ae04-031b3baa4721', '71451535-8d85-417f-b0ec-3f2b87016045', NULL, 'Item', 1, 8000, 8000, NULL, '2026-09-12 16:04:39.509754+05:30', '2026-09-12 16:04:39.509754+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '71451535-8d85-417f-b0ec-3f2b87016045', 1, 8000, 8000, NULL, NULL);
INSERT INTO public.order_items VALUES ('de49919b-7467-40d6-a444-ce0e0b927f1e', '11111111-1111-1111-1111-111111111111', '8139a10d-c414-4402-818c-ea00cfd5e786', '5d13a97e-027a-445b-94eb-2f00546b1614', NULL, 'Item', 1, 9500, 9500, NULL, '2026-09-12 16:20:51.813347+05:30', '2026-09-12 16:20:51.813347+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '5d13a97e-027a-445b-94eb-2f00546b1614', 1, 9500, 9500, NULL, NULL);
INSERT INTO public.order_items VALUES ('0a897341-6ac0-4d8d-9eaf-ceade7d93d17', '11111111-1111-1111-1111-111111111111', '8139a10d-c414-4402-818c-ea00cfd5e786', '640584ad-7f9e-4a1b-8740-290fd382ea81', NULL, 'Item', 1, 8500, 8500, NULL, '2026-09-12 16:20:51.813347+05:30', '2026-09-12 16:20:51.813347+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '640584ad-7f9e-4a1b-8740-290fd382ea81', 1, 8500, 8500, NULL, NULL);
INSERT INTO public.order_items VALUES ('507db4ef-89ab-45ce-b827-28b40e002b45', '11111111-1111-1111-1111-111111111111', '547361f1-ab65-4eeb-b5ae-790378f1eebc', '640584ad-7f9e-4a1b-8740-290fd382ea81', NULL, 'Item', 1, 8500, 8500, NULL, '2026-09-12 16:22:09.469639+05:30', '2026-09-12 16:22:09.469639+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '640584ad-7f9e-4a1b-8740-290fd382ea81', 1, 8500, 8500, NULL, NULL);
INSERT INTO public.order_items VALUES ('1756bfe8-0ef6-4d28-aaab-39b4e69b086e', '11111111-1111-1111-1111-111111111111', '7bf0131c-f022-46a1-9a7b-8569cd3682f8', '71451535-8d85-417f-b0ec-3f2b87016045', NULL, 'Item', 1, 8000, 8000, NULL, '2026-09-12 16:23:24.861331+05:30', '2026-09-12 16:23:24.861331+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '71451535-8d85-417f-b0ec-3f2b87016045', 1, 8000, 8000, NULL, NULL);
INSERT INTO public.order_items VALUES ('384df9e2-296b-4b7e-b7b3-fc56b19ee31b', '11111111-1111-1111-1111-111111111111', '7bf0131c-f022-46a1-9a7b-8569cd3682f8', 'd4d5c11d-7ca8-4f1f-9784-45b39bd6ef7c', NULL, 'Item', 1, 8000, 8000, NULL, '2026-09-12 16:37:34.088358+05:30', '2026-09-12 16:37:34.088358+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', 'd4d5c11d-7ca8-4f1f-9784-45b39bd6ef7c', 1, 8000, 8000, NULL, NULL);
INSERT INTO public.order_items VALUES ('2ea6b595-c3ff-4250-b013-4b9221c0fd73', '11111111-1111-1111-1111-111111111111', '7bf0131c-f022-46a1-9a7b-8569cd3682f8', '2ddb7944-4e83-4dda-99de-94dd5e83bb77', NULL, 'Item', 1, 32000, 32000, NULL, '2026-09-12 16:37:34.088358+05:30', '2026-09-12 16:37:34.088358+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '2ddb7944-4e83-4dda-99de-94dd5e83bb77', 1, 32000, 32000, NULL, NULL);
INSERT INTO public.order_items VALUES ('e37fb3cb-1472-4f02-9822-a08237870bd7', '11111111-1111-1111-1111-111111111111', '815fbab6-72c9-41f6-b104-3f8df856c545', '71451535-8d85-417f-b0ec-3f2b87016045', NULL, 'Item', 1, 8000, 16000, NULL, '2026-09-12 16:40:24.104678+05:30', '2026-09-12 16:40:24.104678+05:30', NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'STARTER', '71451535-8d85-417f-b0ec-3f2b87016045', 2, 8000, 16000, NULL, NULL);


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

INSERT INTO public.order_status_history VALUES ('badb3003-fd45-4add-bafd-968e04059674', '11111111-1111-1111-1111-111111111111', 'b0845453-ec80-411d-8370-e62958475492', NULL, 'PLACED', NULL, NULL, '2026-09-03 14:07:10.202+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('bfb4ef97-522c-45a5-b3e0-adfadc34813a', '11111111-1111-1111-1111-111111111111', 'b0845453-ec80-411d-8370-e62958475492', NULL, 'CONFIRMED', NULL, NULL, '2026-09-03 14:07:10.23+05:30', 'CONFIRMED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('26210006-709c-4c1a-99de-feb5d1c4d2a0', '11111111-1111-1111-1111-111111111111', 'b0845453-ec80-411d-8370-e62958475492', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-03 14:07:10.242+05:30', 'KOT_CREATED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('f52f6069-9775-4e91-a3bb-f15dc653678b', '11111111-1111-1111-1111-111111111111', '5338928a-7fb6-429f-a646-8f12166322fa', NULL, 'PLACED', NULL, NULL, '2026-09-03 14:07:13.305+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('4e2dc5cc-4ca4-4884-9f43-d3556dfed911', '11111111-1111-1111-1111-111111111111', '5338928a-7fb6-429f-a646-8f12166322fa', NULL, 'CONFIRMED', NULL, NULL, '2026-09-03 14:07:13.317+05:30', 'CONFIRMED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('e2232276-0886-4ed2-af92-a8a0d934203b', '11111111-1111-1111-1111-111111111111', '5338928a-7fb6-429f-a646-8f12166322fa', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-03 14:07:13.33+05:30', 'KOT_CREATED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('555e86fc-8bda-44ee-bde2-dbd414dc7a69', '11111111-1111-1111-1111-111111111111', '17cb34b5-878f-4d13-b0ec-02af3307cbf2', NULL, 'PLACED', NULL, NULL, '2026-09-03 14:10:08.945+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('00e6d220-0555-495f-813b-34ff368c7957', '11111111-1111-1111-1111-111111111111', '17cb34b5-878f-4d13-b0ec-02af3307cbf2', NULL, 'CONFIRMED', NULL, NULL, '2026-09-03 14:10:08.961+05:30', 'CONFIRMED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('1eb691fe-1e3d-4a85-b89b-b4adbeab6e81', '11111111-1111-1111-1111-111111111111', '17cb34b5-878f-4d13-b0ec-02af3307cbf2', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-03 14:10:08.968+05:30', 'KOT_CREATED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('8153192d-ab46-449a-b63e-a77d8eeb2db6', '11111111-1111-1111-1111-111111111111', '4a3e148b-1df0-46f8-a71a-c834486429e5', NULL, 'PLACED', NULL, NULL, '2026-09-03 14:19:54.439+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('07df72c6-be95-42f2-8092-175e6d2b85b1', '11111111-1111-1111-1111-111111111111', '4a3e148b-1df0-46f8-a71a-c834486429e5', NULL, 'CONFIRMED', NULL, NULL, '2026-09-03 14:19:54.608+05:30', 'CONFIRMED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('5ce92fa6-e740-446e-8116-c00ad21d7cad', '11111111-1111-1111-1111-111111111111', 'e93358df-ec3b-4e3b-a241-8e93bd953411', NULL, 'PLACED', NULL, NULL, '2026-09-03 14:21:16.18+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('9bfb8b31-4885-439b-abd8-df10d069a623', '11111111-1111-1111-1111-111111111111', 'e93358df-ec3b-4e3b-a241-8e93bd953411', NULL, 'CONFIRMED', NULL, NULL, '2026-09-03 14:21:16.191+05:30', 'CONFIRMED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('8fef026f-a18e-44d6-b3da-136c7b0125fa', '11111111-1111-1111-1111-111111111111', 'e93358df-ec3b-4e3b-a241-8e93bd953411', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-03 14:21:16.2+05:30', 'KOT_CREATED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('905b5b93-253f-4014-92d8-f3e9a80b9996', '11111111-1111-1111-1111-111111111111', '71ef893c-0ccc-439d-bc3e-0a248037303b', NULL, 'PLACED', NULL, NULL, '2026-09-03 14:25:51.875+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('6518444e-c27a-470d-a2be-d4ef92f2f7bd', '11111111-1111-1111-1111-111111111111', '71ef893c-0ccc-439d-bc3e-0a248037303b', NULL, 'CONFIRMED', NULL, NULL, '2026-09-03 14:25:51.893+05:30', 'CONFIRMED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('3284639a-30ca-4bd7-b8d3-176303f3df01', '11111111-1111-1111-1111-111111111111', '71ef893c-0ccc-439d-bc3e-0a248037303b', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-03 14:25:51.904+05:30', 'KOT_CREATED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('f8d6200b-0b59-4aa0-a639-e85fc90cc377', '11111111-1111-1111-1111-111111111111', '71ef893c-0ccc-439d-bc3e-0a248037303b', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-03 14:43:30.832+05:30', 'IN_PREPARATION', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('579cc574-4ed8-429e-ba20-e17e18ac41fd', '11111111-1111-1111-1111-111111111111', '71ef893c-0ccc-439d-bc3e-0a248037303b', NULL, 'READY', NULL, NULL, '2026-09-03 14:43:30.89+05:30', 'READY', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('5264cacf-f7bf-467a-80b0-ea5cf5b380a9', '11111111-1111-1111-1111-111111111111', '71ef893c-0ccc-439d-bc3e-0a248037303b', NULL, 'SERVED', NULL, NULL, '2026-09-03 14:45:03.157+05:30', 'SERVED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('880c8b23-6d2d-4c10-824c-ef4617efb7a8', '11111111-1111-1111-1111-111111111111', 'e93358df-ec3b-4e3b-a241-8e93bd953411', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-03 14:46:09.2+05:30', 'IN_PREPARATION', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('643474ca-3780-4d89-b496-8c3c018f4582', '11111111-1111-1111-1111-111111111111', 'e93358df-ec3b-4e3b-a241-8e93bd953411', NULL, 'READY', NULL, NULL, '2026-09-03 14:46:36.427+05:30', 'READY', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('5cfee20d-a2d5-47a0-8dd8-685a7801c549', '11111111-1111-1111-1111-111111111111', 'e7eccfdc-02d5-470f-869b-da665f7dcb2e', NULL, 'PLACED', NULL, NULL, '2026-09-03 14:53:11.861+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('34007854-06eb-498e-90ca-9b1a297c135e', '11111111-1111-1111-1111-111111111111', 'e7eccfdc-02d5-470f-869b-da665f7dcb2e', NULL, 'CONFIRMED', NULL, NULL, '2026-09-03 14:53:11.877+05:30', 'CONFIRMED', NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06');
INSERT INTO public.order_status_history VALUES ('043c970f-6d9d-4945-be36-f3d5e068a320', '11111111-1111-1111-1111-111111111111', 'e7eccfdc-02d5-470f-869b-da665f7dcb2e', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-03 14:53:11.885+05:30', 'KOT_CREATED', NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06');
INSERT INTO public.order_status_history VALUES ('0eaebd12-ba42-4d82-8058-7332f0c8aa49', '11111111-1111-1111-1111-111111111111', 'e7eccfdc-02d5-470f-869b-da665f7dcb2e', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-03 14:54:45.51+05:30', 'IN_PREPARATION', NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06');
INSERT INTO public.order_status_history VALUES ('7a5b7e81-185b-4f3e-a805-61326815db4a', '11111111-1111-1111-1111-111111111111', 'e7eccfdc-02d5-470f-869b-da665f7dcb2e', NULL, 'READY', NULL, NULL, '2026-09-03 14:54:58.003+05:30', 'READY', NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06');
INSERT INTO public.order_status_history VALUES ('637eed85-3d26-4a17-a7b0-ddf8ebb4538c', '11111111-1111-1111-1111-111111111111', '5583e31e-48a5-435a-936e-aba2f8bb9c9c', NULL, 'PLACED', NULL, NULL, '2026-09-03 15:17:20.223+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('f75b8046-76af-4c32-8741-0d9651be6bd9', '11111111-1111-1111-1111-111111111111', '5583e31e-48a5-435a-936e-aba2f8bb9c9c', NULL, 'CONFIRMED', NULL, NULL, '2026-09-03 15:17:20.24+05:30', 'CONFIRMED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('229e092f-ca2e-4dfd-ab7f-2e9a90f1587c', '11111111-1111-1111-1111-111111111111', '5583e31e-48a5-435a-936e-aba2f8bb9c9c', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-03 15:17:20.25+05:30', 'KOT_CREATED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('6a5bf421-53c9-4986-bdf8-a50cf28da2d1', '11111111-1111-1111-1111-111111111111', '0f621958-d193-4d99-b6ef-037fcea9cd0a', NULL, 'PLACED', NULL, NULL, '2026-09-04 00:05:22.316+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('fb9079fd-4e4e-4cbc-b289-36a1b9b89894', '11111111-1111-1111-1111-111111111111', '0f621958-d193-4d99-b6ef-037fcea9cd0a', NULL, 'CONFIRMED', NULL, NULL, '2026-09-04 00:05:22.342+05:30', 'CONFIRMED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('77061d53-2103-404e-9b15-4f0d6dfe3abd', '11111111-1111-1111-1111-111111111111', '0f621958-d193-4d99-b6ef-037fcea9cd0a', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-04 00:05:22.35+05:30', 'KOT_CREATED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('12dc2d53-f1b7-4f27-877b-f276d1a553e7', '11111111-1111-1111-1111-111111111111', 'e93358df-ec3b-4e3b-a241-8e93bd953411', NULL, 'HANDED_OVER', NULL, NULL, '2026-09-04 00:40:28.061+05:30', 'HANDED_OVER', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('0f3abd30-e7b1-4f74-ab36-3acdbf3ad5f4', '11111111-1111-1111-1111-111111111111', 'a00d57c3-c01d-49d0-9166-45e9f7e22497', NULL, 'PLACED', NULL, NULL, '2026-09-04 00:40:55.711+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('53f43ddf-17d6-4a0b-bedb-e6ea9812ebdb', '11111111-1111-1111-1111-111111111111', 'a00d57c3-c01d-49d0-9166-45e9f7e22497', NULL, 'CONFIRMED', NULL, NULL, '2026-09-04 00:40:55.727+05:30', 'CONFIRMED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('ee137de4-6f84-4fba-b9c7-01204ccfeea4', '11111111-1111-1111-1111-111111111111', 'a00d57c3-c01d-49d0-9166-45e9f7e22497', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-04 00:40:55.735+05:30', 'KOT_CREATED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('3a251390-5750-4401-aabe-bfd0e5c6ff19', '11111111-1111-1111-1111-111111111111', '5583e31e-48a5-435a-936e-aba2f8bb9c9c', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-04 00:42:51.612+05:30', 'IN_PREPARATION', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('89d2e4bf-5537-4054-937e-1828a1bcecea', '11111111-1111-1111-1111-111111111111', 'a00d57c3-c01d-49d0-9166-45e9f7e22497', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-04 00:42:59.028+05:30', 'IN_PREPARATION', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('2ba879a9-45ba-407b-bea0-7d2f9fe10918', '11111111-1111-1111-1111-111111111111', 'a00d57c3-c01d-49d0-9166-45e9f7e22497', NULL, 'READY', NULL, NULL, '2026-09-04 00:43:02.237+05:30', 'READY', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('b7820c80-837f-4afa-8c71-5425f8832214', '11111111-1111-1111-1111-111111111111', '5583e31e-48a5-435a-936e-aba2f8bb9c9c', NULL, 'READY', NULL, NULL, '2026-09-04 00:43:04.024+05:30', 'READY', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('1784c613-febc-4c2c-8252-8746de1c8b92', '11111111-1111-1111-1111-111111111111', '5583e31e-48a5-435a-936e-aba2f8bb9c9c', NULL, 'HANDED_OVER', NULL, NULL, '2026-09-04 00:43:39.268+05:30', 'HANDED_OVER', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('0d4c7f28-8380-4abf-a786-553951cd19e9', '11111111-1111-1111-1111-111111111111', 'a00d57c3-c01d-49d0-9166-45e9f7e22497', NULL, 'HANDED_OVER', NULL, NULL, '2026-09-04 00:43:46.612+05:30', 'HANDED_OVER', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('7c34afa3-f670-4913-ab6c-8618237a593a', '11111111-1111-1111-1111-111111111111', 'ece12171-62db-4f53-ba97-d5e93e06f733', NULL, 'PLACED', NULL, NULL, '2026-09-04 01:04:33.336+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('3d54b326-96ca-47ae-a2a2-20c8015c3eb1', '11111111-1111-1111-1111-111111111111', 'ece12171-62db-4f53-ba97-d5e93e06f733', NULL, 'CONFIRMED', NULL, NULL, '2026-09-04 01:04:33.35+05:30', 'CONFIRMED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('f103762e-291a-49de-8bfb-efd9569e1585', '11111111-1111-1111-1111-111111111111', 'ece12171-62db-4f53-ba97-d5e93e06f733', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-04 01:04:33.359+05:30', 'KOT_CREATED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('f1d87800-8b41-48bc-a19c-b89ff2d5d1b2', '11111111-1111-1111-1111-111111111111', 'ece12171-62db-4f53-ba97-d5e93e06f733', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-04 01:05:38.247+05:30', 'IN_PREPARATION', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('4dc47d53-4782-4c41-890a-ea1e4feb6a7a', '11111111-1111-1111-1111-111111111111', 'ece12171-62db-4f53-ba97-d5e93e06f733', NULL, 'READY', NULL, NULL, '2026-09-04 01:05:39.083+05:30', 'READY', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('cca508b9-c7f9-4d09-bd41-3cfcd93a7521', '11111111-1111-1111-1111-111111111111', 'ece12171-62db-4f53-ba97-d5e93e06f733', NULL, 'HANDED_OVER', NULL, NULL, '2026-09-04 01:06:00.084+05:30', 'HANDED_OVER', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('8bde16a6-a3f8-45a0-992c-dac17c27212b', '11111111-1111-1111-1111-111111111111', 'b5177d27-2e27-4abd-8296-83a748730b2c', NULL, 'PLACED', NULL, NULL, '2026-09-04 01:19:56.503+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('fdc6aad6-cab9-4f68-a940-0c171b71e630', '11111111-1111-1111-1111-111111111111', 'b5177d27-2e27-4abd-8296-83a748730b2c', NULL, 'CONFIRMED', NULL, NULL, '2026-09-04 01:19:56.522+05:30', 'CONFIRMED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('dab2bf25-f30f-4c2b-bd0d-b4c8274a88de', '11111111-1111-1111-1111-111111111111', 'b5177d27-2e27-4abd-8296-83a748730b2c', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-04 01:19:56.758+05:30', 'KOT_CREATED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('2170bac2-8478-47b5-9447-62b08036c3ea', '11111111-1111-1111-1111-111111111111', 'b5177d27-2e27-4abd-8296-83a748730b2c', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-04 01:19:56.784+05:30', 'IN_PREPARATION', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('9f531867-6b28-4e4d-96b6-ddc65694497d', '11111111-1111-1111-1111-111111111111', 'b5177d27-2e27-4abd-8296-83a748730b2c', NULL, 'READY', NULL, NULL, '2026-09-04 01:19:56.8+05:30', 'READY', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('5c129e9b-b9bc-4d95-848e-e8a99beec75a', '11111111-1111-1111-1111-111111111111', 'b5177d27-2e27-4abd-8296-83a748730b2c', NULL, 'SERVED', NULL, NULL, '2026-09-04 01:19:56.817+05:30', 'SERVED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('3a466fdf-1a79-4cf7-bfe1-04e5f65ebf67', '11111111-1111-1111-1111-111111111111', 'b5177d27-2e27-4abd-8296-83a748730b2c', NULL, 'COMPLETED', NULL, NULL, '2026-09-04 01:19:56.858+05:30', 'COMPLETED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('f8b74ae0-32ab-4591-900b-343e114fb37f', '11111111-1111-1111-1111-111111111111', 'a00d57c3-c01d-49d0-9166-45e9f7e22497', NULL, 'COMPLETED', NULL, NULL, '2026-09-05 13:22:05.572+05:30', 'COMPLETED', NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06');
INSERT INTO public.order_status_history VALUES ('5c37974a-c368-44b0-8cb4-3147c615e8ef', '11111111-1111-1111-1111-111111111111', 'e7d4d6cf-4838-43bd-8334-688d11302496', NULL, 'PLACED', NULL, NULL, '2026-09-05 14:26:19.06+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('24cc53ff-3785-42df-9fb8-ee1fa48df4c9', '11111111-1111-1111-1111-111111111111', 'e7d4d6cf-4838-43bd-8334-688d11302496', NULL, 'CONFIRMED', NULL, NULL, '2026-09-05 14:26:19.114+05:30', 'CONFIRMED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('f9ddd752-f155-4a8b-bd36-848857db736d', '11111111-1111-1111-1111-111111111111', 'e7d4d6cf-4838-43bd-8334-688d11302496', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-05 14:26:19.123+05:30', 'KOT_CREATED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('6b4fbe84-0582-4655-9f20-d64d4e7f3e08', '11111111-1111-1111-1111-111111111111', '0f3580d0-cceb-4289-99f8-5ffdf1669b18', NULL, 'PLACED', NULL, NULL, '2026-09-05 15:10:12.599+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('dcc11e33-7b33-4322-8005-595cefe6356d', '11111111-1111-1111-1111-111111111111', '0f3580d0-cceb-4289-99f8-5ffdf1669b18', NULL, 'CONFIRMED', NULL, NULL, '2026-09-05 15:10:12.621+05:30', 'CONFIRMED', NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06');
INSERT INTO public.order_status_history VALUES ('8c1668a9-d54e-4c5f-b6bb-5ec5dbb80a84', '11111111-1111-1111-1111-111111111111', '0f3580d0-cceb-4289-99f8-5ffdf1669b18', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-05 15:10:12.693+05:30', 'KOT_CREATED', NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06');
INSERT INTO public.order_status_history VALUES ('30bbd8b4-7261-4aa9-836b-03b22d23ca07', '11111111-1111-1111-1111-111111111111', '0f3580d0-cceb-4289-99f8-5ffdf1669b18', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-05 15:10:12.722+05:30', 'IN_PREPARATION', NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06');
INSERT INTO public.order_status_history VALUES ('cde96f6e-b2f8-446f-bc24-7444ad117df6', '11111111-1111-1111-1111-111111111111', '0f3580d0-cceb-4289-99f8-5ffdf1669b18', NULL, 'READY', NULL, NULL, '2026-09-05 15:10:12.737+05:30', 'READY', NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06');
INSERT INTO public.order_status_history VALUES ('4444133f-1b84-4235-92c2-a1dc8492e124', '11111111-1111-1111-1111-111111111111', '0f3580d0-cceb-4289-99f8-5ffdf1669b18', NULL, 'SERVED', NULL, NULL, '2026-09-05 15:10:12.756+05:30', 'SERVED', NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06');
INSERT INTO public.order_status_history VALUES ('8fdaf328-007e-45f5-8867-c1d748526c5f', '11111111-1111-1111-1111-111111111111', '0f3580d0-cceb-4289-99f8-5ffdf1669b18', NULL, 'COMPLETED', NULL, NULL, '2026-09-05 15:10:12.772+05:30', 'COMPLETED', NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06');
INSERT INTO public.order_status_history VALUES ('e47558ee-0655-4bc9-a442-41dbc4e541a7', '11111111-1111-1111-1111-111111111111', 'c3a366cb-039e-4e26-9cbd-8e22cd2d52b9', NULL, 'PLACED', NULL, NULL, '2026-09-05 16:22:38.191+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('ea82b643-45eb-4e74-9cae-73e7268b456a', '11111111-1111-1111-1111-111111111111', 'c3a366cb-039e-4e26-9cbd-8e22cd2d52b9', NULL, 'CONFIRMED', NULL, NULL, '2026-09-05 16:22:38.204+05:30', 'CONFIRMED', NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06');
INSERT INTO public.order_status_history VALUES ('1b6cb47f-5280-4550-8764-2f68d6cefe09', '11111111-1111-1111-1111-111111111111', 'c3a366cb-039e-4e26-9cbd-8e22cd2d52b9', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-05 16:22:38.212+05:30', 'KOT_CREATED', NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06');
INSERT INTO public.order_status_history VALUES ('c202546d-bee4-45fc-b0ce-0416b8b8e67d', '67315042-c687-4cbb-b45a-f4ea4efc199f', '5b433b06-af43-4f62-8a6b-e2ca1e0bfa88', NULL, 'PLACED', NULL, NULL, '2026-09-05 16:45:42.004+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('afb02990-f265-4019-ae13-65d1dd8608bd', '67315042-c687-4cbb-b45a-f4ea4efc199f', '5b433b06-af43-4f62-8a6b-e2ca1e0bfa88', NULL, 'CONFIRMED', NULL, NULL, '2026-09-05 16:45:42.018+05:30', 'CONFIRMED', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('7f6859d5-d7e5-45cd-83e4-604a48870f9b', '67315042-c687-4cbb-b45a-f4ea4efc199f', '5b433b06-af43-4f62-8a6b-e2ca1e0bfa88', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-05 16:45:42.092+05:30', 'KOT_CREATED', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('8b78a952-eee3-4f60-9b17-f02ff35844b7', '67315042-c687-4cbb-b45a-f4ea4efc199f', '5b433b06-af43-4f62-8a6b-e2ca1e0bfa88', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-05 16:45:42.101+05:30', 'IN_PREPARATION', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('698bed1b-60c8-40e5-a8e8-b49418efa32d', '67315042-c687-4cbb-b45a-f4ea4efc199f', '5b433b06-af43-4f62-8a6b-e2ca1e0bfa88', NULL, 'READY', NULL, NULL, '2026-09-05 16:45:42.111+05:30', 'READY', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('fff32867-9f9a-48d5-9419-a0fe5e23183d', '67315042-c687-4cbb-b45a-f4ea4efc199f', '5b433b06-af43-4f62-8a6b-e2ca1e0bfa88', NULL, 'SERVED', NULL, NULL, '2026-09-05 16:45:42.12+05:30', 'SERVED', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('98f3930f-ae89-4d39-b693-548ee42bdb1d', '67315042-c687-4cbb-b45a-f4ea4efc199f', '5b433b06-af43-4f62-8a6b-e2ca1e0bfa88', NULL, 'COMPLETED', NULL, NULL, '2026-09-05 16:45:42.128+05:30', 'COMPLETED', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('0d3439e2-f4a3-4e8e-bc0c-a0a0759af5da', '11111111-1111-1111-1111-111111111111', '7a369854-faf1-4af3-8378-8b939249c434', NULL, 'PLACED', NULL, NULL, '2026-09-05 16:51:32.718+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('64a89e28-7d1e-4914-a2f1-3c84eace86e0', '11111111-1111-1111-1111-111111111111', '7a369854-faf1-4af3-8378-8b939249c434', NULL, 'CONFIRMED', NULL, NULL, '2026-09-05 16:51:32.733+05:30', 'CONFIRMED', NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06');
INSERT INTO public.order_status_history VALUES ('2ccf6d5b-72d5-465a-9db1-30197fba70f7', '11111111-1111-1111-1111-111111111111', '7a369854-faf1-4af3-8378-8b939249c434', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-05 16:51:32.807+05:30', 'KOT_CREATED', NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06');
INSERT INTO public.order_status_history VALUES ('4df22435-9957-466a-911a-f76dc04e5576', '11111111-1111-1111-1111-111111111111', '7a369854-faf1-4af3-8378-8b939249c434', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-05 16:51:32.827+05:30', 'IN_PREPARATION', NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06');
INSERT INTO public.order_status_history VALUES ('e41dbb16-7a97-4e73-9020-87f4ab3c71c0', '11111111-1111-1111-1111-111111111111', '7a369854-faf1-4af3-8378-8b939249c434', NULL, 'READY', NULL, NULL, '2026-09-05 16:51:32.839+05:30', 'READY', NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06');
INSERT INTO public.order_status_history VALUES ('3b01358f-7582-4400-a2b3-20bc5c7e9172', '11111111-1111-1111-1111-111111111111', '7a369854-faf1-4af3-8378-8b939249c434', NULL, 'SERVED', NULL, NULL, '2026-09-05 16:51:32.848+05:30', 'SERVED', NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06');
INSERT INTO public.order_status_history VALUES ('15e402d9-abba-4da1-a26e-17c2538e7fcc', '11111111-1111-1111-1111-111111111111', '7a369854-faf1-4af3-8378-8b939249c434', NULL, 'COMPLETED', NULL, NULL, '2026-09-05 16:51:32.858+05:30', 'COMPLETED', NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06');
INSERT INTO public.order_status_history VALUES ('2204d43e-b645-4243-983c-762e8b852ba6', '11111111-1111-1111-1111-111111111111', '82e2a068-a74a-4e18-89fe-7a423f5b243f', NULL, 'PLACED', NULL, NULL, '2026-09-05 17:05:54.962+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('e48d0f2e-e342-4a02-901b-9f86eb4cb46f', '11111111-1111-1111-1111-111111111111', '82e2a068-a74a-4e18-89fe-7a423f5b243f', NULL, 'CONFIRMED', NULL, NULL, '2026-09-05 17:05:54.979+05:30', 'CONFIRMED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('75c39838-ed90-47c1-bca8-da3f0f519715', '11111111-1111-1111-1111-111111111111', '82e2a068-a74a-4e18-89fe-7a423f5b243f', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-05 17:05:54.987+05:30', 'KOT_CREATED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('dc210a1a-c428-46be-a7cb-6fd23291ab22', '11111111-1111-1111-1111-111111111111', '82e2a068-a74a-4e18-89fe-7a423f5b243f', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-05 17:14:44.706+05:30', 'IN_PREPARATION', NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06');
INSERT INTO public.order_status_history VALUES ('bd8c265a-105d-464b-9d94-3d5857ac8d9e', '11111111-1111-1111-1111-111111111111', '82e2a068-a74a-4e18-89fe-7a423f5b243f', NULL, 'READY', NULL, NULL, '2026-09-05 17:14:44.721+05:30', 'READY', NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06');
INSERT INTO public.order_status_history VALUES ('68fa4ec4-3b0c-42c0-960c-62252d78aaec', '11111111-1111-1111-1111-111111111111', '82e2a068-a74a-4e18-89fe-7a423f5b243f', NULL, 'SERVED', NULL, NULL, '2026-09-05 17:14:44.73+05:30', 'SERVED', NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06');
INSERT INTO public.order_status_history VALUES ('04628a00-dbb3-4fd6-99f9-b7e0c7808e9f', '11111111-1111-1111-1111-111111111111', '82e2a068-a74a-4e18-89fe-7a423f5b243f', NULL, 'COMPLETED', NULL, NULL, '2026-09-05 17:14:44.747+05:30', 'COMPLETED', NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06');
INSERT INTO public.order_status_history VALUES ('b21d1676-bbba-4082-b9c2-c2057fb650ca', '11111111-1111-1111-1111-111111111111', '1085cebe-ebf0-4804-83f3-aae6d0d4a7c9', NULL, 'PLACED', NULL, NULL, '2026-09-08 11:05:04.346+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('656fda76-b591-4330-8287-e60b4034d4ca', '11111111-1111-1111-1111-111111111111', '1085cebe-ebf0-4804-83f3-aae6d0d4a7c9', NULL, 'CONFIRMED', NULL, NULL, '2026-09-08 11:05:04.389+05:30', 'CONFIRMED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('dcc39d7d-a31c-4187-9315-18c596b29cac', '11111111-1111-1111-1111-111111111111', '1085cebe-ebf0-4804-83f3-aae6d0d4a7c9', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-08 11:05:04.398+05:30', 'KOT_CREATED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('a36e089a-2624-49d5-a3a7-376b31272153', '11111111-1111-1111-1111-111111111111', 'eb13fd97-c972-4447-8a42-898eb545191e', NULL, 'PLACED', NULL, NULL, '2026-09-08 13:13:14.884+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('53af35cd-66c0-4300-bc2f-7ba7a98f6a2d', '11111111-1111-1111-1111-111111111111', 'eb13fd97-c972-4447-8a42-898eb545191e', NULL, 'CONFIRMED', NULL, NULL, '2026-09-08 13:13:14.899+05:30', 'CONFIRMED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('147bf640-3650-4306-a1dd-9510b24710da', '11111111-1111-1111-1111-111111111111', 'eb13fd97-c972-4447-8a42-898eb545191e', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-08 13:13:14.909+05:30', 'KOT_CREATED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('6e9c1493-d717-48f5-8405-052a6c512283', '11111111-1111-1111-1111-111111111111', 'f5d3449d-ce21-48cb-ab01-b41c41a7301c', NULL, 'PLACED', NULL, NULL, '2026-09-08 13:14:15.253+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('5bf615c1-bb9a-44f3-893a-8d71326e9e4f', '11111111-1111-1111-1111-111111111111', 'f5d3449d-ce21-48cb-ab01-b41c41a7301c', NULL, 'CONFIRMED', NULL, NULL, '2026-09-08 13:14:15.275+05:30', 'CONFIRMED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('2509ea42-2a16-4e99-b364-37dae9c27af6', '11111111-1111-1111-1111-111111111111', 'f5d3449d-ce21-48cb-ab01-b41c41a7301c', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-08 13:14:15.286+05:30', 'KOT_CREATED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('492af723-6808-403c-a2a7-6c93601866dc', '11111111-1111-1111-1111-111111111111', 'b101f725-9679-4cf3-9f0f-16adb200ecff', NULL, 'PLACED', NULL, NULL, '2026-09-08 14:27:24.418+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('3b48f9a1-f2d6-4772-90a6-909348fcf7e6', '11111111-1111-1111-1111-111111111111', 'b101f725-9679-4cf3-9f0f-16adb200ecff', NULL, 'CONFIRMED', NULL, NULL, '2026-09-08 14:27:24.437+05:30', 'CONFIRMED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('c91c0acc-005d-40d1-886b-97777b415549', '11111111-1111-1111-1111-111111111111', 'b101f725-9679-4cf3-9f0f-16adb200ecff', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-08 14:27:24.447+05:30', 'KOT_CREATED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('40556479-2c32-45fa-bb5c-f2b40f497c4b', '11111111-1111-1111-1111-111111111111', 'b101f725-9679-4cf3-9f0f-16adb200ecff', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-08 14:28:38.835+05:30', 'IN_PREPARATION', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('023f89c7-235e-4093-9ae5-d776acd35270', '11111111-1111-1111-1111-111111111111', 'b101f725-9679-4cf3-9f0f-16adb200ecff', NULL, 'READY', NULL, NULL, '2026-09-08 14:39:21.438+05:30', 'READY', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('0243cb4a-904f-4b22-baec-feae6bfafcdc', '11111111-1111-1111-1111-111111111111', 'b101f725-9679-4cf3-9f0f-16adb200ecff', NULL, 'HANDED_OVER', NULL, NULL, '2026-09-08 14:39:22.785+05:30', 'HANDED_OVER', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('142ad389-6a38-4410-8e5f-560f7e1e4961', '11111111-1111-1111-1111-111111111111', '685aa7a6-e1d4-4a39-a7fe-c54252180927', NULL, 'PLACED', NULL, NULL, '2026-09-08 14:41:53.567+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('f4dcc9c0-fd59-49c0-8fd6-90a85e1c1870', '11111111-1111-1111-1111-111111111111', '685aa7a6-e1d4-4a39-a7fe-c54252180927', NULL, 'CONFIRMED', NULL, NULL, '2026-09-08 14:41:53.581+05:30', 'CONFIRMED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('7a308bd6-e62a-4a36-8bdf-866d095f24ff', '11111111-1111-1111-1111-111111111111', '685aa7a6-e1d4-4a39-a7fe-c54252180927', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-08 14:41:53.591+05:30', 'KOT_CREATED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('bf017024-48e1-48b3-8543-69ccb3758cd2', '11111111-1111-1111-1111-111111111111', '685aa7a6-e1d4-4a39-a7fe-c54252180927', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-08 14:42:51.409+05:30', 'IN_PREPARATION', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('7fb04791-31c0-4441-b860-032a531b960c', '11111111-1111-1111-1111-111111111111', '685aa7a6-e1d4-4a39-a7fe-c54252180927', NULL, 'READY', NULL, NULL, '2026-09-08 14:43:25.789+05:30', 'READY', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('985db58c-1d3a-4cd6-b397-ab4a68d7c209', '11111111-1111-1111-1111-111111111111', '685aa7a6-e1d4-4a39-a7fe-c54252180927', NULL, 'HANDED_OVER', NULL, NULL, '2026-09-08 14:44:38.666+05:30', 'HANDED_OVER', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('def42a77-baed-4d12-85a6-e32b79dd95f3', '11111111-1111-1111-1111-111111111111', '76692730-cd05-45cd-b8ad-9cc20ac9fc5a', NULL, 'PLACED', NULL, NULL, '2026-09-08 15:13:45.044+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('6deaa323-e43e-4934-b273-0d2e54f6c3b9', '11111111-1111-1111-1111-111111111111', '76692730-cd05-45cd-b8ad-9cc20ac9fc5a', NULL, 'CONFIRMED', NULL, NULL, '2026-09-08 15:13:45.065+05:30', 'CONFIRMED', NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06');
INSERT INTO public.order_status_history VALUES ('79d6e926-1a7f-4f61-ac67-35f5ccd73152', '11111111-1111-1111-1111-111111111111', '76692730-cd05-45cd-b8ad-9cc20ac9fc5a', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-08 15:13:45.08+05:30', 'KOT_CREATED', NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06');
INSERT INTO public.order_status_history VALUES ('e1614fc8-674e-4fd0-929d-bb18dbca6597', '11111111-1111-1111-1111-111111111111', '76692730-cd05-45cd-b8ad-9cc20ac9fc5a', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-08 15:14:17.136+05:30', 'IN_PREPARATION', NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06');
INSERT INTO public.order_status_history VALUES ('4e0b1bf8-2dbb-4789-945b-562b86e7bd09', '11111111-1111-1111-1111-111111111111', 'f5d3449d-ce21-48cb-ab01-b41c41a7301c', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-08 16:19:40.892+05:30', 'IN_PREPARATION', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('a6ce0caa-b067-43a8-9063-0bca5ccf7653', '11111111-1111-1111-1111-111111111111', 'f5d3449d-ce21-48cb-ab01-b41c41a7301c', NULL, 'READY', NULL, NULL, '2026-09-08 16:19:41.77+05:30', 'READY', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('5d751d63-cd6d-4c3f-b34f-051e8e7fe2e6', '11111111-1111-1111-1111-111111111111', 'f5d3449d-ce21-48cb-ab01-b41c41a7301c', NULL, 'HANDED_OVER', NULL, NULL, '2026-09-08 16:19:42.475+05:30', 'HANDED_OVER', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('1647b4f6-a405-41ac-bacf-fb3bc2d3e54b', '11111111-1111-1111-1111-111111111111', '76692730-cd05-45cd-b8ad-9cc20ac9fc5a', NULL, 'READY', NULL, NULL, '2026-09-09 12:45:15.083+05:30', 'READY', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('a0d6f4af-6b12-4c36-bb07-dd3eab607fdc', '11111111-1111-1111-1111-111111111111', '76692730-cd05-45cd-b8ad-9cc20ac9fc5a', NULL, 'HANDED_OVER', NULL, NULL, '2026-09-09 12:45:15.907+05:30', 'HANDED_OVER', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('4c77123b-c52a-4857-8e8b-04700babf2b3', '11111111-1111-1111-1111-111111111111', '0602cb47-3398-4ba0-b5da-87e23909efa3', NULL, 'PLACED', NULL, NULL, '2026-09-09 12:47:30.745+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('34e4c8d6-6136-4cf8-b98f-4aec524fb7a6', '11111111-1111-1111-1111-111111111111', '0602cb47-3398-4ba0-b5da-87e23909efa3', NULL, 'CONFIRMED', NULL, NULL, '2026-09-09 12:47:30.762+05:30', 'CONFIRMED', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('17373a86-102b-4468-9b28-a317e455a6b3', '11111111-1111-1111-1111-111111111111', '0602cb47-3398-4ba0-b5da-87e23909efa3', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-09 12:47:30.773+05:30', 'KOT_CREATED', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('739f94b3-97c1-44d9-a128-bbaa0eac51c3', '11111111-1111-1111-1111-111111111111', '2d4b655e-a5bf-4900-ba0c-11e1b3c2685c', NULL, 'PLACED', NULL, NULL, '2026-09-09 12:51:14.242+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('8b24e10f-c96f-44a9-b829-5b89b76200a3', '11111111-1111-1111-1111-111111111111', '2d4b655e-a5bf-4900-ba0c-11e1b3c2685c', NULL, 'CONFIRMED', NULL, NULL, '2026-09-09 12:51:14.252+05:30', 'CONFIRMED', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('ac34594f-f7ad-4f88-8853-49b03ff700c2', '11111111-1111-1111-1111-111111111111', '2d4b655e-a5bf-4900-ba0c-11e1b3c2685c', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-09 12:51:14.262+05:30', 'KOT_CREATED', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('b7e14753-5bf1-4bbc-b0a8-55d098d8cef0', '11111111-1111-1111-1111-111111111111', 'f973888e-e429-473a-8566-ddea7ac708a0', NULL, 'PLACED', NULL, NULL, '2026-09-09 12:52:31.649+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('a8aa12fe-b207-4cfd-bfc3-1cffef71947e', '11111111-1111-1111-1111-111111111111', 'f973888e-e429-473a-8566-ddea7ac708a0', NULL, 'CONFIRMED', NULL, NULL, '2026-09-09 12:52:31.662+05:30', 'CONFIRMED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('736e86ec-5a07-4b35-9e2d-766b5a459583', '11111111-1111-1111-1111-111111111111', 'f973888e-e429-473a-8566-ddea7ac708a0', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-09 12:52:31.67+05:30', 'KOT_CREATED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('7148ff70-506d-4c38-aa17-e64899f18cd4', '11111111-1111-1111-1111-111111111111', '190ec2cb-fb90-44c2-ad76-b32672063fdb', NULL, 'PLACED', NULL, NULL, '2026-09-09 13:01:25.169+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('98b6ad9b-513a-405e-a42c-457fc6621106', '11111111-1111-1111-1111-111111111111', '190ec2cb-fb90-44c2-ad76-b32672063fdb', NULL, 'CONFIRMED', NULL, NULL, '2026-09-09 13:01:25.183+05:30', 'CONFIRMED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('61a06a52-798c-4e4a-8da2-e842bba54a1f', '11111111-1111-1111-1111-111111111111', '190ec2cb-fb90-44c2-ad76-b32672063fdb', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-09 13:01:25.194+05:30', 'KOT_CREATED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('64ff8d99-39d8-47ae-8276-51ee9353c018', '11111111-1111-1111-1111-111111111111', '4e192b03-6942-454a-a9dd-9084d99362b1', NULL, 'PLACED', NULL, NULL, '2026-09-09 13:02:02.204+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('dff576d1-4f0c-433d-876e-5e56b8c7c585', '11111111-1111-1111-1111-111111111111', '4e192b03-6942-454a-a9dd-9084d99362b1', NULL, 'CONFIRMED', NULL, NULL, '2026-09-09 13:02:02.221+05:30', 'CONFIRMED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('967fa5a4-61f3-4875-890f-f4439c57e697', '11111111-1111-1111-1111-111111111111', '4e192b03-6942-454a-a9dd-9084d99362b1', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-09 13:02:02.23+05:30', 'KOT_CREATED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('e32d53b3-55ee-496e-a8ac-88afb6f213b8', '11111111-1111-1111-1111-111111111111', '9528cbcc-5873-41a3-b142-53165932bc70', NULL, 'PLACED', NULL, NULL, '2026-09-09 13:02:03.724+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('df5b2076-9c41-47c0-b060-5578b6a18d5b', '11111111-1111-1111-1111-111111111111', '9528cbcc-5873-41a3-b142-53165932bc70', NULL, 'CONFIRMED', NULL, NULL, '2026-09-09 13:02:03.738+05:30', 'CONFIRMED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('a7b37a67-3e89-4936-b1c7-f2a29b9612d6', '11111111-1111-1111-1111-111111111111', '9528cbcc-5873-41a3-b142-53165932bc70', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-09 13:02:03.749+05:30', 'KOT_CREATED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('7c9f56c3-6b90-4a23-886a-e244fed93203', '11111111-1111-1111-1111-111111111111', '39f6e5e8-3eb1-4100-a8cc-4dfcb49ba060', NULL, 'PLACED', NULL, NULL, '2026-09-09 13:03:37.825+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('7d766da7-d014-4896-813c-7c8e719ac89a', '11111111-1111-1111-1111-111111111111', '39f6e5e8-3eb1-4100-a8cc-4dfcb49ba060', NULL, 'CONFIRMED', NULL, NULL, '2026-09-09 13:03:37.841+05:30', 'CONFIRMED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('d6b3a398-a561-4d56-be42-7e6a0c09e1ee', '11111111-1111-1111-1111-111111111111', '39f6e5e8-3eb1-4100-a8cc-4dfcb49ba060', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-09 13:03:37.852+05:30', 'KOT_CREATED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('a34b25c3-508b-40f8-8dbe-12465e67bf3a', '11111111-1111-1111-1111-111111111111', '118a762d-2cc4-4b94-b0c6-1b7360cd6652', NULL, 'PLACED', NULL, NULL, '2026-09-09 13:03:39.362+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('b355a5d4-4129-4fa1-a028-a9ef52170868', '11111111-1111-1111-1111-111111111111', '118a762d-2cc4-4b94-b0c6-1b7360cd6652', NULL, 'CONFIRMED', NULL, NULL, '2026-09-09 13:03:39.373+05:30', 'CONFIRMED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('7568e33a-b330-44c8-b204-402af3b268f9', '11111111-1111-1111-1111-111111111111', '118a762d-2cc4-4b94-b0c6-1b7360cd6652', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-09 13:03:39.384+05:30', 'KOT_CREATED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('c48d921c-c88f-4869-838f-6b2120e9d854', '11111111-1111-1111-1111-111111111111', '2d4b655e-a5bf-4900-ba0c-11e1b3c2685c', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-09 14:06:01.034+05:30', 'IN_PREPARATION', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('6669e726-de31-48f0-9024-72ef536e3930', '11111111-1111-1111-1111-111111111111', '2d4b655e-a5bf-4900-ba0c-11e1b3c2685c', NULL, 'READY', NULL, NULL, '2026-09-09 14:06:01.052+05:30', 'READY', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('a9ab81c7-abb6-4a7d-a3a7-2554080e8389', '11111111-1111-1111-1111-111111111111', '2d4b655e-a5bf-4900-ba0c-11e1b3c2685c', NULL, 'SERVED', NULL, NULL, '2026-09-09 14:06:01.062+05:30', 'SERVED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('1063b8c2-bb71-4e8e-9764-517c82752317', '11111111-1111-1111-1111-111111111111', '2d4b655e-a5bf-4900-ba0c-11e1b3c2685c', NULL, 'COMPLETED', NULL, NULL, '2026-09-09 14:06:01.077+05:30', 'COMPLETED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('392c1f6c-65ba-4673-93ab-4b6534b60657', '11111111-1111-1111-1111-111111111111', 'eb13fd97-c972-4447-8a42-898eb545191e', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-09 14:07:07.533+05:30', 'IN_PREPARATION', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('489995c6-b6d3-4420-a29e-d0451b29e440', '11111111-1111-1111-1111-111111111111', 'eb13fd97-c972-4447-8a42-898eb545191e', NULL, 'READY', NULL, NULL, '2026-09-09 14:07:07.551+05:30', 'READY', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('0a08b934-88ca-4874-a456-86fe79ae890b', '11111111-1111-1111-1111-111111111111', 'eb13fd97-c972-4447-8a42-898eb545191e', NULL, 'SERVED', NULL, NULL, '2026-09-09 14:07:07.561+05:30', 'SERVED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('8a3a2372-8b9f-4396-9810-25ba5dd5c703', '11111111-1111-1111-1111-111111111111', 'eb13fd97-c972-4447-8a42-898eb545191e', NULL, 'COMPLETED', NULL, NULL, '2026-09-09 14:07:07.58+05:30', 'COMPLETED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('6cf3bb94-6b35-4887-b208-a2bc7045a0f7', '11111111-1111-1111-1111-111111111111', 'f5d3449d-ce21-48cb-ab01-b41c41a7301c', NULL, 'COMPLETED', NULL, NULL, '2026-09-09 14:07:29.921+05:30', 'COMPLETED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('d1e1076c-b1f1-48d5-b2d3-1aca53981b2f', '11111111-1111-1111-1111-111111111111', '0a746ebb-ff2b-40d1-8d00-5e7652f56006', NULL, 'PLACED', NULL, NULL, '2026-09-09 14:27:26.164+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('81f7b72f-8c03-4141-bf95-5eae62b2eaa9', '11111111-1111-1111-1111-111111111111', '0a746ebb-ff2b-40d1-8d00-5e7652f56006', NULL, 'CONFIRMED', NULL, NULL, '2026-09-09 14:27:26.182+05:30', 'CONFIRMED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('3164b294-e01e-4023-b82e-7ee58692e712', '11111111-1111-1111-1111-111111111111', '0a746ebb-ff2b-40d1-8d00-5e7652f56006', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-09 14:27:26.193+05:30', 'KOT_CREATED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('ec7f3032-8e04-4a93-8570-ab67cf0511a1', '11111111-1111-1111-1111-111111111111', 'c182470d-5000-40bc-86f8-b9093c4333e8', NULL, 'PLACED', NULL, NULL, '2026-09-09 14:27:33.553+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('35594157-870f-420c-a188-f5b6faf09068', '11111111-1111-1111-1111-111111111111', 'c182470d-5000-40bc-86f8-b9093c4333e8', NULL, 'CONFIRMED', NULL, NULL, '2026-09-09 14:27:33.871+05:30', 'CONFIRMED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('7c96203e-3b67-4b4f-a1a8-f57ee8eef2e4', '11111111-1111-1111-1111-111111111111', 'c182470d-5000-40bc-86f8-b9093c4333e8', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-09 14:27:33.887+05:30', 'KOT_CREATED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('42a173af-aaa8-4ac8-96c9-f491520eec7f', '11111111-1111-1111-1111-111111111111', '482d35cd-b7b6-4c65-a7f3-943897646bad', NULL, 'PLACED', NULL, NULL, '2026-09-09 14:28:57.8+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('7f3ebb99-2c82-442f-888d-4891d1654d22', '11111111-1111-1111-1111-111111111111', '482d35cd-b7b6-4c65-a7f3-943897646bad', NULL, 'CONFIRMED', NULL, NULL, '2026-09-09 14:28:58.336+05:30', 'CONFIRMED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('5d3a53d3-e01f-4e4c-bfe9-d694a448b10c', '11111111-1111-1111-1111-111111111111', '482d35cd-b7b6-4c65-a7f3-943897646bad', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-09 14:28:58.355+05:30', 'KOT_CREATED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('7b41b6b8-562a-4121-9df2-eb268c0f9213', '11111111-1111-1111-1111-111111111111', '25ab98b4-6057-4986-a634-4dd7dc5f51bc', NULL, 'PLACED', NULL, NULL, '2026-09-09 14:29:43.209+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('2615b2c0-74bb-439b-8e95-cf17f4c55087', '11111111-1111-1111-1111-111111111111', '25ab98b4-6057-4986-a634-4dd7dc5f51bc', NULL, 'CONFIRMED', NULL, NULL, '2026-09-09 14:29:43.517+05:30', 'CONFIRMED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('094cad7c-a9c0-4f70-8f85-d93f86b53a70', '11111111-1111-1111-1111-111111111111', '25ab98b4-6057-4986-a634-4dd7dc5f51bc', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-09 14:29:43.538+05:30', 'KOT_CREATED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('ee43ec06-d02d-466f-b3b1-76e1a2186cdb', '11111111-1111-1111-1111-111111111111', '65505588-f509-44ef-a6c6-c488503dcbe3', NULL, 'PLACED', NULL, NULL, '2026-09-09 14:31:14.465+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('6dc21da3-5fd9-4218-9b1f-d1c717d2eca0', '11111111-1111-1111-1111-111111111111', '65505588-f509-44ef-a6c6-c488503dcbe3', NULL, 'CONFIRMED', NULL, NULL, '2026-09-09 14:31:14.651+05:30', 'CONFIRMED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('84859367-d4ad-4c7a-b61f-51f2b33246ee', '11111111-1111-1111-1111-111111111111', '65505588-f509-44ef-a6c6-c488503dcbe3', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-09 14:31:14.664+05:30', 'KOT_CREATED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('516e3a50-5203-4c9d-8b5f-c98458190dc0', '11111111-1111-1111-1111-111111111111', 'b6abe3e6-d0e7-4dc7-a631-097181effc3a', NULL, 'PLACED', NULL, NULL, '2026-09-09 14:31:59.211+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('257e72a7-5cbd-4704-bb7e-d554361b6402', '11111111-1111-1111-1111-111111111111', 'b6abe3e6-d0e7-4dc7-a631-097181effc3a', NULL, 'CONFIRMED', NULL, NULL, '2026-09-09 14:31:59.353+05:30', 'CONFIRMED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('d9873095-9f41-4a33-a211-1a4938a4e2b4', '11111111-1111-1111-1111-111111111111', 'b6abe3e6-d0e7-4dc7-a631-097181effc3a', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-09 14:31:59.367+05:30', 'KOT_CREATED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('aeb61eef-1139-4e20-85de-309ae7c04f68', '11111111-1111-1111-1111-111111111111', 'd71091c4-71f0-4c75-bd38-c6b08ba4dd4a', NULL, 'PLACED', NULL, NULL, '2026-09-09 14:32:48.248+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('cc4ae1a1-5a48-4f39-98f6-8da57028816e', '11111111-1111-1111-1111-111111111111', 'd71091c4-71f0-4c75-bd38-c6b08ba4dd4a', NULL, 'CONFIRMED', NULL, NULL, '2026-09-09 14:32:48.87+05:30', 'CONFIRMED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('f2db5338-6121-4435-a377-5c09de93c616', '11111111-1111-1111-1111-111111111111', 'd71091c4-71f0-4c75-bd38-c6b08ba4dd4a', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-09 14:32:48.895+05:30', 'KOT_CREATED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('8bcfc684-27fc-448f-bb1c-6c28c11dcec2', '11111111-1111-1111-1111-111111111111', 'd1467f47-4869-4592-996e-0d3f373ec018', NULL, 'PLACED', NULL, NULL, '2026-09-09 14:34:00.909+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('1127686d-db7c-485f-b861-4375d441aa47', '11111111-1111-1111-1111-111111111111', 'd1467f47-4869-4592-996e-0d3f373ec018', NULL, 'CONFIRMED', NULL, NULL, '2026-09-09 14:34:01.467+05:30', 'CONFIRMED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('85e50914-13b8-4256-a9d4-a4053bc5a0af', '11111111-1111-1111-1111-111111111111', 'd1467f47-4869-4592-996e-0d3f373ec018', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-09 14:34:01.498+05:30', 'KOT_CREATED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('f6722f47-ac98-44cb-9095-847161557acf', '11111111-1111-1111-1111-111111111111', '0a746ebb-ff2b-40d1-8d00-5e7652f56006', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-09 15:08:54.296+05:30', 'IN_PREPARATION', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('16f4646a-48a3-4f97-a3d4-1f861712b4a9', '11111111-1111-1111-1111-111111111111', '0a746ebb-ff2b-40d1-8d00-5e7652f56006', NULL, 'READY', NULL, NULL, '2026-09-09 15:08:54.328+05:30', 'READY', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('348d19fb-cc9e-4b55-a86d-52e532e71c35', '11111111-1111-1111-1111-111111111111', '0a746ebb-ff2b-40d1-8d00-5e7652f56006', NULL, 'SERVED', NULL, NULL, '2026-09-09 15:08:54.343+05:30', 'SERVED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('61621e83-d5c9-424a-ac71-7e1c249ed0ed', '11111111-1111-1111-1111-111111111111', '0a746ebb-ff2b-40d1-8d00-5e7652f56006', NULL, 'COMPLETED', NULL, NULL, '2026-09-09 15:08:54.359+05:30', 'COMPLETED', NULL, '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');
INSERT INTO public.order_status_history VALUES ('1adc1bca-4563-4dd6-9c9c-f18737a7e865', '11111111-1111-1111-1111-111111111111', '3e1ba9c8-0311-4534-a8d3-fa97b3a4f933', NULL, 'PLACED', NULL, NULL, '2026-09-09 15:09:20.348+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('58e92025-fc7b-4273-8c38-47edeb1b44fd', '11111111-1111-1111-1111-111111111111', '3e1ba9c8-0311-4534-a8d3-fa97b3a4f933', NULL, 'CONFIRMED', NULL, NULL, '2026-09-09 15:09:20.365+05:30', 'CONFIRMED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('3c5d640f-67c9-4cc9-9501-efa76d67ee9c', '11111111-1111-1111-1111-111111111111', '3e1ba9c8-0311-4534-a8d3-fa97b3a4f933', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-09 15:09:20.373+05:30', 'KOT_CREATED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('59b13c1f-4c75-4d72-a952-0655c0077855', '11111111-1111-1111-1111-111111111111', '3e1ba9c8-0311-4534-a8d3-fa97b3a4f933', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-10 16:51:30.53+05:30', 'IN_PREPARATION', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('6f0dc7ae-b85b-46f1-a12f-02850bdbd46f', '11111111-1111-1111-1111-111111111111', '3e1ba9c8-0311-4534-a8d3-fa97b3a4f933', NULL, 'READY', NULL, NULL, '2026-09-10 16:52:24.523+05:30', 'READY', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('9f53d203-d504-42a7-85a0-8b0d1b63d1cb', '11111111-1111-1111-1111-111111111111', '3e1ba9c8-0311-4534-a8d3-fa97b3a4f933', NULL, 'SERVED', NULL, NULL, '2026-09-10 16:52:36.095+05:30', 'SERVED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('7e246bc7-384c-4984-ac2c-8205b6115a89', '11111111-1111-1111-1111-111111111111', '65505588-f509-44ef-a6c6-c488503dcbe3', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-11 11:10:01.571+05:30', 'IN_PREPARATION', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('6a225768-03ce-4b94-9d2f-85eb1900127c', '11111111-1111-1111-1111-111111111111', '65505588-f509-44ef-a6c6-c488503dcbe3', NULL, 'READY', NULL, NULL, '2026-09-11 11:10:03.245+05:30', 'READY', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('abbcc8c2-f67f-4d57-bdc4-2eb5c757f708', '11111111-1111-1111-1111-111111111111', '65505588-f509-44ef-a6c6-c488503dcbe3', NULL, 'HANDED_OVER', NULL, NULL, '2026-09-11 11:10:05.993+05:30', 'HANDED_OVER', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('7e6bc4cf-4572-4eea-960e-6060b877d1ca', '11111111-1111-1111-1111-111111111111', 'c182470d-5000-40bc-86f8-b9093c4333e8', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-11 11:10:07.885+05:30', 'IN_PREPARATION', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('e9c5a7e5-bc07-4e20-a223-36014cf2017e', '11111111-1111-1111-1111-111111111111', 'c182470d-5000-40bc-86f8-b9093c4333e8', NULL, 'READY', NULL, NULL, '2026-09-11 11:10:10.807+05:30', 'READY', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('e9ebc523-eb3a-40c7-8670-74260cb57b9f', '11111111-1111-1111-1111-111111111111', 'c182470d-5000-40bc-86f8-b9093c4333e8', NULL, 'HANDED_OVER', NULL, NULL, '2026-09-11 11:10:15.609+05:30', 'HANDED_OVER', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('5e1b2320-90ab-4f9d-9cc6-1a5d8ddce9f7', '11111111-1111-1111-1111-111111111111', 'b6abe3e6-d0e7-4dc7-a631-097181effc3a', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-11 11:10:41.331+05:30', 'IN_PREPARATION', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('f4337777-dcef-4cbb-bde8-3fe47c52495d', '11111111-1111-1111-1111-111111111111', 'b6abe3e6-d0e7-4dc7-a631-097181effc3a', NULL, 'READY', NULL, NULL, '2026-09-11 11:10:42.068+05:30', 'READY', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('a541fbab-b833-4233-bee5-65139b3de9d4', '11111111-1111-1111-1111-111111111111', 'b6abe3e6-d0e7-4dc7-a631-097181effc3a', NULL, 'HANDED_OVER', NULL, NULL, '2026-09-11 11:10:55.596+05:30', 'HANDED_OVER', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('873e3a93-c74e-4f54-ba7f-dc6d0619b6cc', '11111111-1111-1111-1111-111111111111', '27f9f630-3e8b-4ba9-b4d7-e631e45182f7', NULL, 'PLACED', NULL, NULL, '2026-09-11 12:09:46.326+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('44e895ca-678d-46cf-8c6f-32e0618fdd3f', '11111111-1111-1111-1111-111111111111', '27f9f630-3e8b-4ba9-b4d7-e631e45182f7', NULL, 'CONFIRMED', NULL, NULL, '2026-09-11 12:09:46.342+05:30', 'CONFIRMED', NULL, '5c660c1f-f5f8-4007-87a6-b4b39913998b');
INSERT INTO public.order_status_history VALUES ('a732533c-d5ec-4dac-ae62-f1f42de58994', '11111111-1111-1111-1111-111111111111', '27f9f630-3e8b-4ba9-b4d7-e631e45182f7', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-11 12:09:46.349+05:30', 'KOT_CREATED', NULL, '5c660c1f-f5f8-4007-87a6-b4b39913998b');
INSERT INTO public.order_status_history VALUES ('d24734e3-749c-4d0e-bb85-44ac2a559796', '11111111-1111-1111-1111-111111111111', 'c8387bcf-ab67-44bb-87fb-d67f6d7601ca', NULL, 'PLACED', NULL, NULL, '2026-09-11 12:33:27.213+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('f78abac1-ae45-49e7-8452-6c5ff88a14b2', '11111111-1111-1111-1111-111111111111', 'c8387bcf-ab67-44bb-87fb-d67f6d7601ca', NULL, 'CONFIRMED', NULL, NULL, '2026-09-11 12:33:27.23+05:30', 'CONFIRMED', NULL, '5c660c1f-f5f8-4007-87a6-b4b39913998b');
INSERT INTO public.order_status_history VALUES ('4c0017a8-6930-40b6-a63d-e1b926b2ca9a', '11111111-1111-1111-1111-111111111111', 'c8387bcf-ab67-44bb-87fb-d67f6d7601ca', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-11 12:33:27.238+05:30', 'KOT_CREATED', NULL, '5c660c1f-f5f8-4007-87a6-b4b39913998b');
INSERT INTO public.order_status_history VALUES ('3b1c478e-90d2-4aca-8dcc-460fd475cf73', '11111111-1111-1111-1111-111111111111', 'd8d53271-b231-47e9-93aa-7a47185f8940', NULL, 'PLACED', NULL, NULL, '2026-09-11 12:59:30.568+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('67830371-2ec1-499a-b8ae-e8041be5f2f0', '11111111-1111-1111-1111-111111111111', 'd8d53271-b231-47e9-93aa-7a47185f8940', NULL, 'CONFIRMED', NULL, NULL, '2026-09-11 12:59:30.586+05:30', 'CONFIRMED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('9355f2bd-f9de-43eb-ab83-e1d0e32c614b', '11111111-1111-1111-1111-111111111111', 'd8d53271-b231-47e9-93aa-7a47185f8940', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-11 12:59:30.607+05:30', 'KOT_CREATED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('b605d6dd-de45-4150-8ae7-99bc3acddebd', '11111111-1111-1111-1111-111111111111', 'ccffe940-9f6b-41af-aaeb-72b3e1cdb3da', NULL, 'PLACED', NULL, NULL, '2026-09-11 12:59:52.787+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('89d0c947-4741-48b3-988f-907cc6cd4916', '11111111-1111-1111-1111-111111111111', 'ccffe940-9f6b-41af-aaeb-72b3e1cdb3da', NULL, 'CONFIRMED', NULL, NULL, '2026-09-11 12:59:52.802+05:30', 'CONFIRMED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('feb90153-17e3-4c82-84ed-fee5caae673c', '11111111-1111-1111-1111-111111111111', 'ccffe940-9f6b-41af-aaeb-72b3e1cdb3da', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-11 12:59:52.811+05:30', 'KOT_CREATED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('fabb7329-f944-4f62-a48f-ea2274bf5594', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'cff7a875-fec8-4189-bc71-ae49b0e19488', NULL, 'PLACED', NULL, NULL, '2026-09-11 14:11:01.872+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('f9911338-8980-4c9f-bc55-019c506cfaa0', '67315042-c687-4cbb-b45a-f4ea4efc199f', '0c7bc59e-d90f-4a42-873f-88c0e9a02386', NULL, 'PLACED', NULL, NULL, '2026-09-11 14:12:08.677+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('effe113d-2d38-4023-9071-490eaf5db6a8', '67315042-c687-4cbb-b45a-f4ea4efc199f', '0c7bc59e-d90f-4a42-873f-88c0e9a02386', NULL, 'CONFIRMED', NULL, NULL, '2026-09-11 14:12:08.702+05:30', 'CONFIRMED', NULL, '5e635b7d-856a-40b8-8a8c-1398f74eca30');
INSERT INTO public.order_status_history VALUES ('6efe1803-c121-4579-a75f-42ab2e0b718e', '67315042-c687-4cbb-b45a-f4ea4efc199f', '0c7bc59e-d90f-4a42-873f-88c0e9a02386', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-11 14:12:08.716+05:30', 'KOT_CREATED', NULL, '5e635b7d-856a-40b8-8a8c-1398f74eca30');
INSERT INTO public.order_status_history VALUES ('5daac2fa-c5c3-4083-ae58-1aa42a425639', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'f9b4ac11-21c8-4617-9a1d-f1d7e8147a37', NULL, 'PLACED', NULL, NULL, '2026-09-11 14:16:07.314+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('84fe327f-faab-4802-88c0-9e04fdc55499', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'f9b4ac11-21c8-4617-9a1d-f1d7e8147a37', NULL, 'CONFIRMED', NULL, NULL, '2026-09-11 14:16:07.331+05:30', 'CONFIRMED', NULL, '5e635b7d-856a-40b8-8a8c-1398f74eca30');
INSERT INTO public.order_status_history VALUES ('3cab8269-1cb5-4d9c-84aa-94da7fc8be3d', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'f9b4ac11-21c8-4617-9a1d-f1d7e8147a37', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-11 14:16:07.339+05:30', 'KOT_CREATED', NULL, '5e635b7d-856a-40b8-8a8c-1398f74eca30');
INSERT INTO public.order_status_history VALUES ('2f3d9a8c-4569-40e2-b1e2-0e0fee287ed9', '67315042-c687-4cbb-b45a-f4ea4efc199f', '829e83e6-ea56-4173-bfe2-463b24e497a4', NULL, 'PLACED', NULL, NULL, '2026-09-11 14:19:07.426+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('2087af51-b79f-4089-affe-70b3129801e7', '67315042-c687-4cbb-b45a-f4ea4efc199f', '829e83e6-ea56-4173-bfe2-463b24e497a4', NULL, 'CONFIRMED', NULL, NULL, '2026-09-11 14:19:07.446+05:30', 'CONFIRMED', NULL, '5e635b7d-856a-40b8-8a8c-1398f74eca30');
INSERT INTO public.order_status_history VALUES ('e2517631-2914-4d92-a918-b90e4f173dfd', '67315042-c687-4cbb-b45a-f4ea4efc199f', '829e83e6-ea56-4173-bfe2-463b24e497a4', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-11 14:19:07.456+05:30', 'KOT_CREATED', NULL, '5e635b7d-856a-40b8-8a8c-1398f74eca30');
INSERT INTO public.order_status_history VALUES ('e198cb45-495c-4b6a-b293-57baf089cc87', '11111111-1111-1111-1111-111111111111', '89dba099-01ad-417a-a438-66ca8af5e712', NULL, 'PLACED', NULL, NULL, '2026-09-11 14:24:19.854+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('1c8ccb0b-2291-4ac4-8dba-f0c034900b3d', '11111111-1111-1111-1111-111111111111', '89dba099-01ad-417a-a438-66ca8af5e712', NULL, 'CONFIRMED', NULL, NULL, '2026-09-11 14:24:19.87+05:30', 'CONFIRMED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('b8bc2d7f-05e3-4ae8-ac6f-73a9152ad44a', '11111111-1111-1111-1111-111111111111', '89dba099-01ad-417a-a438-66ca8af5e712', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-11 14:24:19.878+05:30', 'KOT_CREATED', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('0338e9ab-d4d6-4591-91e4-73a6a5a16593', '11111111-1111-1111-1111-111111111111', '4a4e9d6c-a797-4b03-9835-a44526c890e2', NULL, 'PLACED', NULL, NULL, '2026-09-11 14:25:28.507+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('bb1c3095-db5f-4005-8ecc-56c954d60c2e', '11111111-1111-1111-1111-111111111111', '4a4e9d6c-a797-4b03-9835-a44526c890e2', NULL, 'CONFIRMED', NULL, NULL, '2026-09-11 14:25:28.522+05:30', 'CONFIRMED', NULL, '72bad3bb-6097-47d2-bfc2-35b1244a7b9f');
INSERT INTO public.order_status_history VALUES ('a7efa81d-96ca-4360-be7d-db705f5442fc', '11111111-1111-1111-1111-111111111111', '4a4e9d6c-a797-4b03-9835-a44526c890e2', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-11 14:25:28.532+05:30', 'KOT_CREATED', NULL, '72bad3bb-6097-47d2-bfc2-35b1244a7b9f');
INSERT INTO public.order_status_history VALUES ('d763a440-5ff6-4434-a8fc-e95dfc2362c7', '11111111-1111-1111-1111-111111111111', '4a4e9d6c-a797-4b03-9835-a44526c890e2', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-11 14:42:42.233+05:30', 'IN_PREPARATION', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('08384937-e8b3-4c97-8155-746b58026fb6', '11111111-1111-1111-1111-111111111111', '89dba099-01ad-417a-a438-66ca8af5e712', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-11 14:42:44.146+05:30', 'IN_PREPARATION', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('2b187ff1-7764-4785-894b-55d51a3c9907', '11111111-1111-1111-1111-111111111111', '89dba099-01ad-417a-a438-66ca8af5e712', NULL, 'READY', NULL, NULL, '2026-09-11 14:43:18.691+05:30', 'READY', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('d4767c08-966a-4893-915b-fe50e6542072', '11111111-1111-1111-1111-111111111111', '4a4e9d6c-a797-4b03-9835-a44526c890e2', NULL, 'READY', NULL, NULL, '2026-09-11 14:44:25.869+05:30', 'READY', NULL, '72bad3bb-6097-47d2-bfc2-35b1244a7b9f');
INSERT INTO public.order_status_history VALUES ('f92f62a6-718d-4d31-8709-86857a2c5ba1', '11111111-1111-1111-1111-111111111111', '4a4e9d6c-a797-4b03-9835-a44526c890e2', NULL, 'SERVED', NULL, NULL, '2026-09-11 14:44:32.33+05:30', 'SERVED', NULL, '72bad3bb-6097-47d2-bfc2-35b1244a7b9f');
INSERT INTO public.order_status_history VALUES ('b6390d1b-1b6f-4a6e-ade8-fe46e5d6ddb7', '11111111-1111-1111-1111-111111111111', '89dba099-01ad-417a-a438-66ca8af5e712', NULL, 'SERVED', NULL, NULL, '2026-09-11 14:44:37.615+05:30', 'SERVED', NULL, '72bad3bb-6097-47d2-bfc2-35b1244a7b9f');
INSERT INTO public.order_status_history VALUES ('94ceaae6-4d4f-4043-9750-2f17374068ef', '11111111-1111-1111-1111-111111111111', 'd8d53271-b231-47e9-93aa-7a47185f8940', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-11 16:21:03.329+05:30', 'IN_PREPARATION', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('3a1b09a6-9db8-4fa9-be61-d5acc69eae59', '11111111-1111-1111-1111-111111111111', 'd8d53271-b231-47e9-93aa-7a47185f8940', NULL, 'READY', NULL, NULL, '2026-09-11 16:21:07.396+05:30', 'READY', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('0861e477-2651-4a4b-8505-95859a2f0a76', '11111111-1111-1111-1111-111111111111', 'd8d53271-b231-47e9-93aa-7a47185f8940', NULL, 'HANDED_OVER', NULL, NULL, '2026-09-11 16:21:08.595+05:30', 'HANDED_OVER', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('b264b607-93bd-449c-9160-663e31cd9ae9', '11111111-1111-1111-1111-111111111111', 'ccffe940-9f6b-41af-aaeb-72b3e1cdb3da', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-11 16:21:23.188+05:30', 'IN_PREPARATION', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.order_status_history VALUES ('8c107145-b791-42bf-ac37-7991d04acd8f', '11111111-1111-1111-1111-111111111111', 'ccffe940-9f6b-41af-aaeb-72b3e1cdb3da', NULL, 'READY', NULL, NULL, '2026-09-11 16:40:05.246+05:30', 'READY', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('8c3adfa8-df1e-4e1b-ba42-7fefc19202ec', '11111111-1111-1111-1111-111111111111', 'ccffe940-9f6b-41af-aaeb-72b3e1cdb3da', NULL, 'HANDED_OVER', NULL, NULL, '2026-09-12 15:31:15.433+05:30', 'HANDED_OVER', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('7160c56d-5f68-44bc-a405-661c9abdfa42', '11111111-1111-1111-1111-111111111111', 'abaed738-9e4f-4470-ae04-031b3baa4721', NULL, 'PLACED', NULL, NULL, '2026-09-12 16:04:39.564+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('4cd5e07f-52a0-4141-ade7-809c054a27f6', '11111111-1111-1111-1111-111111111111', 'abaed738-9e4f-4470-ae04-031b3baa4721', NULL, 'CONFIRMED', NULL, NULL, '2026-09-12 16:04:39.586+05:30', 'CONFIRMED', NULL, '72bad3bb-6097-47d2-bfc2-35b1244a7b9f');
INSERT INTO public.order_status_history VALUES ('fc147c3f-0fc3-402f-8d68-721f221498b5', '11111111-1111-1111-1111-111111111111', 'abaed738-9e4f-4470-ae04-031b3baa4721', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-12 16:04:39.598+05:30', 'KOT_CREATED', NULL, '72bad3bb-6097-47d2-bfc2-35b1244a7b9f');
INSERT INTO public.order_status_history VALUES ('0a1e3e48-035e-4f26-98d7-16c3807d7161', '11111111-1111-1111-1111-111111111111', 'abaed738-9e4f-4470-ae04-031b3baa4721', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-12 16:05:26.051+05:30', 'IN_PREPARATION', NULL, '72bad3bb-6097-47d2-bfc2-35b1244a7b9f');
INSERT INTO public.order_status_history VALUES ('2cf8c678-8c53-486d-92ee-e16d07bc475a', '11111111-1111-1111-1111-111111111111', 'abaed738-9e4f-4470-ae04-031b3baa4721', NULL, 'READY', NULL, NULL, '2026-09-12 16:05:28.016+05:30', 'READY', NULL, '72bad3bb-6097-47d2-bfc2-35b1244a7b9f');
INSERT INTO public.order_status_history VALUES ('9f76e43e-ad4c-4cc3-bb35-2a830165c0a4', '11111111-1111-1111-1111-111111111111', 'abaed738-9e4f-4470-ae04-031b3baa4721', NULL, 'HANDED_OVER', NULL, NULL, '2026-09-12 16:05:29.98+05:30', 'HANDED_OVER', NULL, '72bad3bb-6097-47d2-bfc2-35b1244a7b9f');
INSERT INTO public.order_status_history VALUES ('840d55bd-2e35-4a81-93c1-63321f365c39', '11111111-1111-1111-1111-111111111111', '8139a10d-c414-4402-818c-ea00cfd5e786', NULL, 'PLACED', NULL, NULL, '2026-09-12 16:20:51.844+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('5b307a87-8cce-46fb-b373-ae02c3b9b2cc', '11111111-1111-1111-1111-111111111111', '8139a10d-c414-4402-818c-ea00cfd5e786', NULL, 'CONFIRMED', NULL, NULL, '2026-09-12 16:20:51.866+05:30', 'CONFIRMED', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('2c10c763-56d8-492d-90c0-950f37fc58e0', '11111111-1111-1111-1111-111111111111', '8139a10d-c414-4402-818c-ea00cfd5e786', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-12 16:20:51.875+05:30', 'KOT_CREATED', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('0e468d28-3006-42ee-b949-84886ce5de5d', '11111111-1111-1111-1111-111111111111', '8139a10d-c414-4402-818c-ea00cfd5e786', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-12 16:21:25.273+05:30', 'IN_PREPARATION', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('2a15a97d-a2fd-4677-992d-02ba5705face', '11111111-1111-1111-1111-111111111111', '8139a10d-c414-4402-818c-ea00cfd5e786', NULL, 'READY', NULL, NULL, '2026-09-12 16:21:26.225+05:30', 'READY', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('271f29f8-6967-42dc-9a2c-0d08fc2ee39f', '11111111-1111-1111-1111-111111111111', '8139a10d-c414-4402-818c-ea00cfd5e786', NULL, 'HANDED_OVER', NULL, NULL, '2026-09-12 16:21:26.893+05:30', 'HANDED_OVER', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('8abf8473-9baa-4fa8-a34f-3226e1517989', '11111111-1111-1111-1111-111111111111', '547361f1-ab65-4eeb-b5ae-790378f1eebc', NULL, 'PLACED', NULL, NULL, '2026-09-12 16:22:09.485+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('bac62020-91b6-4a78-9837-8c6e66f1a3fe', '11111111-1111-1111-1111-111111111111', '547361f1-ab65-4eeb-b5ae-790378f1eebc', NULL, 'CONFIRMED', NULL, NULL, '2026-09-12 16:22:09.501+05:30', 'CONFIRMED', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('33c7971b-8a06-4b28-8dad-cece5ce1112d', '11111111-1111-1111-1111-111111111111', '547361f1-ab65-4eeb-b5ae-790378f1eebc', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-12 16:22:09.51+05:30', 'KOT_CREATED', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('e16a910f-8b48-442d-a7a0-76013b148f15', '11111111-1111-1111-1111-111111111111', '547361f1-ab65-4eeb-b5ae-790378f1eebc', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-12 16:22:21.732+05:30', 'IN_PREPARATION', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('554873b3-8640-4a88-b453-a1686f088527', '11111111-1111-1111-1111-111111111111', '547361f1-ab65-4eeb-b5ae-790378f1eebc', NULL, 'READY', NULL, NULL, '2026-09-12 16:22:22.843+05:30', 'READY', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('d2a4a060-fcfa-40d1-abdb-e2dd2756bce3', '11111111-1111-1111-1111-111111111111', '547361f1-ab65-4eeb-b5ae-790378f1eebc', NULL, 'HANDED_OVER', NULL, NULL, '2026-09-12 16:22:24.169+05:30', 'HANDED_OVER', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('e4160148-3ecb-4b3d-b298-98fe701c385b', '11111111-1111-1111-1111-111111111111', '7bf0131c-f022-46a1-9a7b-8569cd3682f8', NULL, 'PLACED', NULL, NULL, '2026-09-12 16:23:24.876+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('ff615cf4-9189-4736-92fc-a28a775dad78', '11111111-1111-1111-1111-111111111111', '7bf0131c-f022-46a1-9a7b-8569cd3682f8', NULL, 'CONFIRMED', NULL, NULL, '2026-09-12 16:23:24.941+05:30', 'CONFIRMED', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('0029d603-396a-4890-83df-954b3499bd9a', '11111111-1111-1111-1111-111111111111', '7bf0131c-f022-46a1-9a7b-8569cd3682f8', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-12 16:23:24.976+05:30', 'KOT_CREATED', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('dd32afee-37f2-4b94-a708-eac454b96984', '11111111-1111-1111-1111-111111111111', '7bf0131c-f022-46a1-9a7b-8569cd3682f8', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-12 16:35:33.697+05:30', 'IN_PREPARATION', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('7d43a1b5-6e8a-4e36-ad23-2adc631cbbf5', '11111111-1111-1111-1111-111111111111', '7bf0131c-f022-46a1-9a7b-8569cd3682f8', NULL, 'READY', NULL, NULL, '2026-09-12 16:35:34.673+05:30', 'READY', NULL, '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.order_status_history VALUES ('39ebefc9-e0eb-4136-8aa9-5811afd837ba', '11111111-1111-1111-1111-111111111111', '7bf0131c-f022-46a1-9a7b-8569cd3682f8', NULL, 'HANDED_OVER', NULL, NULL, '2026-09-12 16:37:03.97+05:30', 'HANDED_OVER', NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06');
INSERT INTO public.order_status_history VALUES ('905f8ea9-3eb5-4100-ae63-621004b06410', '11111111-1111-1111-1111-111111111111', '815fbab6-72c9-41f6-b104-3f8df856c545', NULL, 'PLACED', NULL, NULL, '2026-09-12 16:40:24.134+05:30', 'PLACED', NULL, NULL);
INSERT INTO public.order_status_history VALUES ('b25a0528-fcef-497f-a38b-7c44faa85365', '11111111-1111-1111-1111-111111111111', '815fbab6-72c9-41f6-b104-3f8df856c545', NULL, 'CONFIRMED', NULL, NULL, '2026-09-12 16:40:24.151+05:30', 'CONFIRMED', NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06');
INSERT INTO public.order_status_history VALUES ('bb112b3e-8152-42e5-92d4-8e664decb62e', '11111111-1111-1111-1111-111111111111', '815fbab6-72c9-41f6-b104-3f8df856c545', NULL, 'KOT_CREATED', NULL, NULL, '2026-09-12 16:40:24.159+05:30', 'KOT_CREATED', NULL, 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06');
INSERT INTO public.order_status_history VALUES ('dddd62e9-ed9d-4baa-a7fc-51708f5d54f9', '11111111-1111-1111-1111-111111111111', '815fbab6-72c9-41f6-b104-3f8df856c545', NULL, 'IN_PREPARATION', NULL, NULL, '2026-09-12 17:22:29.992+05:30', 'IN_PREPARATION', NULL, '918df673-2606-403a-9fad-1c54870d1fce');


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.orders VALUES ('ccffe940-9f6b-41af-aaeb-72b3e1cdb3da', '11111111-1111-1111-1111-111111111111', '20260911-0004', 'DINE_IN', 'HANDED_OVER', '2026-09-11', 6000, 6300, 'INR', NULL, NULL, NULL, '2026-09-11 12:59:52.773+05:30', '2026-09-12 15:31:15.382+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6300, 6000, 'T-01', 'DINE_IN', NULL, 0, 300, 0, 0, 'waiter-1789111792740-op9oud74m5r', NULL);
INSERT INTO public.orders VALUES ('39f6e5e8-3eb1-4100-a8cc-4dfcb49ba060', '11111111-1111-1111-1111-111111111111', '20260909-0007', 'DINE_IN', 'KOT_CREATED', '2026-09-09', 21000, 22050, 'INR', NULL, NULL, NULL, '2026-09-09 13:03:37.797+05:30', '2026-09-09 13:03:38.677+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1050, 0, 'TEST-01', 'DINE_IN', NULL, 0, 1050, 0, 0, 'test-stock-1788939217739', NULL);
INSERT INTO public.orders VALUES ('f5d3449d-ce21-48cb-ab01-b41c41a7301c', '11111111-1111-1111-1111-111111111111', '20260908-0003', 'DINE_IN', 'COMPLETED', '2026-09-08', 15000, 15750, 'INR', NULL, NULL, NULL, '2026-09-08 13:14:15.231+05:30', '2026-09-09 14:07:29.94+05:30', NULL, NULL, '2026-09-09 14:07:29.939+05:30', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 45675, 43500, 'T-01', 'DINE_IN', '799771fc-55e6-42a7-8a24-c8946f547286', 0, 2175, 0, 0, 'waiter-1788853455194-s4tefy9z8z', NULL);
INSERT INTO public.orders VALUES ('685aa7a6-e1d4-4a39-a7fe-c54252180927', '11111111-1111-1111-1111-111111111111', '20260908-0005', 'DINE_IN', 'HANDED_OVER', '2026-09-08', 11000, 11550, 'INR', NULL, NULL, NULL, '2026-09-08 14:41:53.554+05:30', '2026-09-08 14:44:38.661+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11550, 11000, 'POS-01', 'PICKUP', NULL, 0, 550, 0, 0, 'ord_1788858713544_hsiqd97', NULL);
INSERT INTO public.orders VALUES ('482d35cd-b7b6-4c65-a7f3-943897646bad', '11111111-1111-1111-1111-111111111111', '20260909-0011', 'DINE_IN', 'KOT_CREATED', '2026-09-09', 25000, 26250, 'INR', NULL, NULL, NULL, '2026-09-09 14:28:57.784+05:30', '2026-09-09 14:28:58.352+05:30', NULL, NULL, NULL, '2026-09-09 14:43:57.74+05:30', '2026-09-09 15:13:57.74+05:30', 25000, 'FIRED', 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 26250, 25000, 'POS-01', 'DELIVERY', NULL, 0, 1250, 0, 0, 'adv-test-1788944337742', NULL);
INSERT INTO public.orders VALUES ('c69c7c36-7b05-4ca7-9012-710df44ed6fd', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'ORD-101', 'DINE_IN', 'IN_PREPARATION', '2026-09-03', 9600000, 9600000, 'INR', NULL, 'A1', NULL, '2026-09-03 12:29:17.500816+05:30', '2026-09-03 12:29:17.500816+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 96000, 96000, 'T-01', 'DINE_IN', NULL, 0, 0, 0, 0, 'IDEMP-c69c7c36-7b05-4ca7-9012-710df44ed6fd', NULL);
INSERT INTO public.orders VALUES ('42d364fa-b9c0-4f09-b125-534a14fa6cda', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'ORD-100', 'DINE_IN', 'COMPLETED', '2026-09-03', 8400000, 8400000, 'INR', NULL, 'A2', NULL, '2026-09-03 10:29:36.845587+05:30', '2026-09-03 12:29:36.845587+05:30', NULL, NULL, '2026-09-03 12:29:36.845587+05:30', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 84000, 84000, 'T-01', 'DINE_IN', NULL, 0, 0, 0, 0, 'IDEMP-42d364fa-b9c0-4f09-b125-534a14fa6cda', NULL);
INSERT INTO public.orders VALUES ('011e557d-7bda-415e-ac6c-7ee4490ec2aa', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'ORD-SW-8821', 'DELIVERY', 'CONFIRMED', '2026-09-03', 10200000, 10200000, 'INR', NULL, NULL, NULL, '2026-09-03 12:29:36.848942+05:30', '2026-09-03 12:29:36.848942+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 'swiggy', 'SW-8821', 'Suresh Kumar', '9848022338', NULL, NULL, NULL, 102000, 102000, 'T-01', 'DINE_IN', NULL, 0, 0, 0, 0, 'IDEMP-011e557d-7bda-415e-ac6c-7ee4490ec2aa', NULL);
INSERT INTO public.orders VALUES ('b0845453-ec80-411d-8370-e62958475492', '11111111-1111-1111-1111-111111111111', '20260903-0001', 'DINE_IN', 'KOT_CREATED', '2026-09-03', 850000, 850000, 'INR', NULL, NULL, NULL, '2026-09-03 14:07:10.182+05:30', '2026-09-03 14:07:10.239+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8904, 8500, 'T-01', 'DINE_IN', NULL, 0, 404, 0, 0, 'waiter-1788424630110-2slzvx8iyvr', NULL);
INSERT INTO public.orders VALUES ('5338928a-7fb6-429f-a646-8f12166322fa', '11111111-1111-1111-1111-111111111111', '20260903-0002', 'DINE_IN', 'KOT_CREATED', '2026-09-03', 850000, 850000, 'INR', NULL, NULL, NULL, '2026-09-03 14:07:13.294+05:30', '2026-09-03 14:07:13.327+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8904, 8500, 'T-01', 'DINE_IN', NULL, 0, 404, 0, 0, 'waiter-1788424633262-ubqk7lg59gh', NULL);
INSERT INTO public.orders VALUES ('17cb34b5-878f-4d13-b0ec-02af3307cbf2', '11111111-1111-1111-1111-111111111111', '20260903-0003', 'DINE_IN', 'KOT_CREATED', '2026-09-03', 2200000, 2200000, 'INR', NULL, NULL, NULL, '2026-09-03 14:10:08.923+05:30', '2026-09-03 14:10:08.966+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 23047, 22000, 'POS-01', 'DINE_IN', NULL, 0, 1047, 0, 0, 'ord_1788424808900_fi4t6th', NULL);
INSERT INTO public.orders VALUES ('4a3e148b-1df0-46f8-a71a-c834486429e5', '11111111-1111-1111-1111-111111111111', '20260903-0004', 'DINE_IN', 'CONFIRMED', '2026-09-03', 1700000, 1700000, 'INR', NULL, NULL, NULL, '2026-09-03 14:19:54.422+05:30', '2026-09-03 14:19:54.599+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17809, 17000, 'POS-01', 'DINE_IN', NULL, 0, 809, 0, 0, 'ord_1788425394391_8jvq9t9', NULL);
INSERT INTO public.orders VALUES ('d1467f47-4869-4592-996e-0d3f373ec018', '11111111-1111-1111-1111-111111111111', '20260909-0016', 'DINE_IN', 'KOT_CREATED', '2026-09-09', 25000, 26250, 'INR', NULL, NULL, NULL, '2026-09-09 14:34:00.893+05:30', '2026-09-09 14:34:01.493+05:30', NULL, NULL, NULL, '2026-09-09 14:49:00.779+05:30', '2026-09-09 15:19:00.779+05:30', 25000, 'FIRED', 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, 'Sanjay Singhania', '9876543210', NULL, NULL, NULL, 26250, 25000, 'POS-01', 'DELIVERY', NULL, 0, 1250, 0, 0, 'adv-test-1788944640781', NULL);
INSERT INTO public.orders VALUES ('190ec2cb-fb90-44c2-ad76-b32672063fdb', '11111111-1111-1111-1111-111111111111', '20260909-0004', 'DINE_IN', 'KOT_CREATED', '2026-09-09', 25500, 26775, 'INR', NULL, NULL, NULL, '2026-09-09 13:01:25.156+05:30', '2026-09-09 13:01:25.192+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 26775, 25500, 'TEST-01', 'DINE_IN', NULL, 0, 1275, 0, 0, 'test-stock-1788939085123', NULL);
INSERT INTO public.orders VALUES ('9528cbcc-5873-41a3-b142-53165932bc70', '11111111-1111-1111-1111-111111111111', '20260909-0006', 'DINE_IN', 'KOT_CREATED', '2026-09-09', 127500, 133875, 'INR', NULL, NULL, NULL, '2026-09-09 13:02:03.713+05:30', '2026-09-09 13:02:03.746+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 133875, 127500, 'TEST-01', 'DINE_IN', NULL, 0, 6375, 0, 0, 'test-zero-1788939123683', NULL);
INSERT INTO public.orders VALUES ('71ef893c-0ccc-439d-bc3e-0a248037303b', '11111111-1111-1111-1111-111111111111', '20260903-0006', 'DINE_IN', 'COMPLETED', '2026-09-03', 850000, 850000, 'INR', NULL, NULL, NULL, '2026-09-03 14:25:51.852+05:30', '2026-09-09 15:08:58.35+05:30', NULL, NULL, '2026-09-08 11:01:05.855+05:30', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10904, 8500, 'T-01', 'DINE_IN', NULL, 0, 404, 1000, 1000, 'waiter-1788425751809-w8tffsvs6r', NULL);
INSERT INTO public.orders VALUES ('2d4b655e-a5bf-4900-ba0c-11e1b3c2685c', '11111111-1111-1111-1111-111111111111', '20260909-0002', 'DINE_IN', 'COMPLETED', '2026-09-09', 8500, 8925, 'INR', NULL, NULL, NULL, '2026-09-09 12:51:14.221+05:30', '2026-09-09 15:08:58.35+05:30', NULL, NULL, '2026-09-09 14:06:01.12+05:30', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 473025, 450500, 'T-01', 'DINE_IN', NULL, 0, 22525, 0, 0, 'waiter-1788938474192-69hxmpu2vz9', NULL);
INSERT INTO public.orders VALUES ('1085cebe-ebf0-4804-83f3-aae6d0d4a7c9', '11111111-1111-1111-1111-111111111111', '20260908-0001', 'DINE_IN', 'COMPLETED', '2026-09-08', 3500, 3675, 'INR', NULL, NULL, NULL, '2026-09-08 11:05:04.308+05:30', '2026-09-09 15:08:58.35+05:30', NULL, NULL, '2026-09-08 11:10:47.888+05:30', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 77075, 71500, 'T-01', 'DINE_IN', NULL, 0, 3575, 1000, 1000, 'waiter-1788845704266-rv8phamg79q', NULL);
INSERT INTO public.orders VALUES ('0602cb47-3398-4ba0-b5da-87e23909efa3', '11111111-1111-1111-1111-111111111111', '20260909-0001', 'DINE_IN', 'COMPLETED', '2026-09-09', 8500, 8925, 'INR', NULL, NULL, NULL, '2026-09-09 12:47:30.717+05:30', '2026-09-09 15:08:58.35+05:30', NULL, NULL, '2026-09-09 12:51:03.262+05:30', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 534975, 509500, 'T-01', 'DINE_IN', NULL, 0, 25475, 0, 0, 'waiter-1788938250682-63ox706v2y4', NULL);
INSERT INTO public.orders VALUES ('65505588-f509-44ef-a6c6-c488503dcbe3', '11111111-1111-1111-1111-111111111111', '20260909-0013', 'DINE_IN', 'HANDED_OVER', '2026-09-09', 25000, 26250, 'INR', NULL, NULL, NULL, '2026-09-09 14:31:14.448+05:30', '2026-09-11 11:10:05.989+05:30', NULL, NULL, NULL, '2026-09-09 14:46:14.256+05:30', '2026-09-09 15:16:14.256+05:30', 25000, 'FIRED', 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 26250, 25000, 'POS-01', 'DELIVERY', NULL, 0, 1250, 0, 0, 'adv-test-1788944474258', NULL);
INSERT INTO public.orders VALUES ('3e1ba9c8-0311-4534-a8d3-fa97b3a4f933', '11111111-1111-1111-1111-111111111111', '20260909-0017', 'DINE_IN', 'COMPLETED', '2026-09-09', 5000, 5250, 'INR', NULL, NULL, NULL, '2026-09-09 15:09:20.329+05:30', '2026-09-10 17:31:57.032+05:30', NULL, NULL, '2026-09-10 17:17:49.752+05:30', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15500, 10000, 'T-01', 'DINE_IN', 'f2f701b9-6bc9-4869-8f88-4904a35070d8', 0, 500, 0, 5000, 'waiter-1788946760271-03nb4awdw1w7', '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.orders VALUES ('b6abe3e6-d0e7-4dc7-a631-097181effc3a', '11111111-1111-1111-1111-111111111111', '20260909-0014', 'DINE_IN', 'HANDED_OVER', '2026-09-09', 25000, 26250, 'INR', NULL, NULL, NULL, '2026-09-09 14:31:59.199+05:30', '2026-09-11 11:10:55.589+05:30', NULL, NULL, NULL, '2026-09-09 14:46:59.157+05:30', '2026-09-09 15:16:59.157+05:30', 25000, 'FIRED', 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 26250, 25000, 'POS-01', 'DELIVERY', NULL, 0, 1250, 0, 0, 'adv-test-1788944519158', NULL);
INSERT INTO public.orders VALUES ('c8387bcf-ab67-44bb-87fb-d67f6d7601ca', '11111111-1111-1111-1111-111111111111', '20260911-0002', 'DINE_IN', 'COMPLETED', '2026-09-11', 12000, 12600, 'INR', NULL, NULL, NULL, '2026-09-11 12:33:27.195+05:30', '2026-09-11 12:34:34.925+05:30', NULL, NULL, '2026-09-11 12:34:34.918+05:30', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17600, 12000, 'T-01', 'DINE_IN', '2e681514-bcbe-4ef9-bc4d-b2209a3d5f85', 0, 600, 0, 5000, 'waiter-1789110207150-a6aj8qynpks', NULL);
INSERT INTO public.orders VALUES ('27f9f630-3e8b-4ba9-b4d7-e631e45182f7', '11111111-1111-1111-1111-111111111111', '20260911-0001', 'DINE_IN', 'COMPLETED', '2026-09-11', 5000, 5250, 'INR', NULL, NULL, NULL, '2026-09-11 12:09:46.276+05:30', '2026-09-11 12:35:19.7+05:30', NULL, NULL, '2026-09-11 12:35:19.699+05:30', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10250, 5000, 'T-01', 'DINE_IN', 'f2f701b9-6bc9-4869-8f88-4904a35070d8', 0, 250, 0, 5000, 'waiter-1789108786239-h18kst0x8c4', NULL);
INSERT INTO public.orders VALUES ('0c7bc59e-d90f-4a42-873f-88c0e9a02386', '67315042-c687-4cbb-b45a-f4ea4efc199f', '20260911-0002', 'DINE_IN', 'KOT_CREATED', '2026-09-11', 34000, 35700, 'INR', NULL, NULL, NULL, '2026-09-11 14:12:08.658+05:30', '2026-09-11 14:12:08.711+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 35700, 34000, 'POS-01', 'DINE_IN', '689515c9-28fd-4324-9b84-3f99d1075bd6', 0, 1700, 0, 0, 'ord_1789116128645_8clzul7', '5e635b7d-856a-40b8-8a8c-1398f74eca30');
INSERT INTO public.orders VALUES ('118a762d-2cc4-4b94-b0c6-1b7360cd6652', '11111111-1111-1111-1111-111111111111', '20260909-0008', 'DINE_IN', 'KOT_CREATED', '2026-09-09', 105000, 110250, 'INR', NULL, NULL, NULL, '2026-09-09 13:03:39.352+05:30', '2026-09-09 13:03:39.381+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 110250, 105000, 'TEST-01', 'DINE_IN', NULL, 0, 5250, 0, 0, 'test-zero-1788939219330', NULL);
INSERT INTO public.orders VALUES ('82e2a068-a74a-4e18-89fe-7a423f5b243f', '11111111-1111-1111-1111-111111111111', '20260905-0005', 'DINE_IN', 'COMPLETED', '2026-09-05', 7000, 7350, 'INR', NULL, NULL, NULL, '2026-09-05 17:05:54.948+05:30', '2026-09-05 17:14:44.771+05:30', NULL, NULL, '2026-09-05 17:14:44.766+05:30', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7350, 7000, 'T-01', 'DINE_IN', '1bb0a59d-079d-4406-8bd9-0fd2f4a7668e', 0, 350, 0, 0, 'waiter-1788608154918-4amhfzjeev3', NULL);
INSERT INTO public.orders VALUES ('d8d53271-b231-47e9-93aa-7a47185f8940', '11111111-1111-1111-1111-111111111111', '20260911-0003', 'DINE_IN', 'HANDED_OVER', '2026-09-11', 12000, 12600, 'INR', NULL, NULL, NULL, '2026-09-11 12:59:30.541+05:30', '2026-09-11 16:21:08.593+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12600, 12000, 'T-01', 'DINE_IN', NULL, 0, 600, 0, 0, 'waiter-1789111770444-ey2pwahr4uf', NULL);
INSERT INTO public.orders VALUES ('e7d4d6cf-4838-43bd-8334-688d11302496', '11111111-1111-1111-1111-111111111111', '20260905-0001', 'DINE_IN', 'COMPLETED', '2026-09-05', 8500, 8925, 'INR', NULL, NULL, NULL, '2026-09-05 14:26:19.028+05:30', '2026-09-08 11:17:50.433+05:30', NULL, NULL, '2026-09-08 11:17:50.432+05:30', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 116025, 110500, 'T-01', 'DINE_IN', '2e681514-bcbe-4ef9-bc4d-b2209a3d5f85', 0, 5525, 0, 0, 'waiter-1788598578951-3x5u1bfz12a', NULL);
INSERT INTO public.orders VALUES ('eb13fd97-c972-4447-8a42-898eb545191e', '11111111-1111-1111-1111-111111111111', '20260908-0002', 'DINE_IN', 'COMPLETED', '2026-09-08', 20000, 21000, 'INR', NULL, NULL, NULL, '2026-09-08 13:13:14.864+05:30', '2026-09-09 14:07:10.548+05:30', NULL, NULL, '2026-09-09 14:07:07.609+05:30', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 21000, 20000, 'T-01', 'DINE_IN', NULL, 0, 1000, 0, 0, 'waiter-1788853394827-hlq6jlpw4zm', NULL);
INSERT INTO public.orders VALUES ('0f621958-d193-4d99-b6ef-037fcea9cd0a', '11111111-1111-1111-1111-111111111111', '20260903-0009', 'DINE_IN', 'COMPLETED', '2026-09-04', 5000, 5250, 'INR', NULL, NULL, NULL, '2026-09-04 00:05:22.297+05:30', '2026-09-09 14:07:10.548+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16800, 16000, 'T-01', 'DINE_IN', NULL, 0, 800, 0, 0, 'waiter-1788460522260-n4yubv97com', NULL);
INSERT INTO public.orders VALUES ('a00d57c3-c01d-49d0-9166-45e9f7e22497', '11111111-1111-1111-1111-111111111111', '20260903-0010', 'DINE_IN', 'COMPLETED', '2026-09-04', 11000, 11550, 'INR', NULL, NULL, NULL, '2026-09-04 00:40:55.689+05:30', '2026-09-09 14:07:10.548+05:30', NULL, NULL, '2026-09-05 13:22:05.624+05:30', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 47250, 45000, 'T-01', 'DINE_IN', NULL, 0, 2250, 0, 0, 'waiter-1788462655658-0g8ogjyypgdt', NULL);
INSERT INTO public.orders VALUES ('e7eccfdc-02d5-470f-869b-da665f7dcb2e', '11111111-1111-1111-1111-111111111111', '20260903-0007', 'DINE_IN', 'COMPLETED', '2026-09-03', 3200000, 3200000, 'INR', NULL, NULL, NULL, '2026-09-03 14:53:11.846+05:30', '2026-09-09 14:07:10.548+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 38773, 37000, 'T-01', 'DINE_IN', NULL, 0, 1773, 0, 0, 'waiter-1788427391814-tmsnij0grzn', NULL);
INSERT INTO public.orders VALUES ('ece12171-62db-4f53-ba97-d5e93e06f733', '11111111-1111-1111-1111-111111111111', '20260903-0011', 'DINE_IN', 'COMPLETED', '2026-09-04', 15000, 15750, 'INR', NULL, NULL, NULL, '2026-09-04 01:04:33.319+05:30', '2026-09-04 01:14:43.211+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15750, 15000, 'T-01', 'DINE_IN', '1bb0a59d-079d-4406-8bd9-0fd2f4a7668e', 0, 750, 0, 0, 'waiter-1788464073288-gn75s1cf276', NULL);
INSERT INTO public.orders VALUES ('25ab98b4-6057-4986-a634-4dd7dc5f51bc', '11111111-1111-1111-1111-111111111111', '20260909-0012', 'DINE_IN', 'KOT_CREATED', '2026-09-09', 25000, 26250, 'INR', NULL, NULL, NULL, '2026-09-09 14:29:43.193+05:30', '2026-09-09 14:29:43.536+05:30', NULL, NULL, NULL, '2026-09-09 14:44:43.146+05:30', '2026-09-09 15:14:43.146+05:30', 25000, 'FIRED', 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 26250, 25000, 'POS-01', 'DELIVERY', NULL, 0, 1250, 0, 0, 'adv-test-1788944383148', NULL);
INSERT INTO public.orders VALUES ('b5177d27-2e27-4abd-8296-83a748730b2c', '11111111-1111-1111-1111-111111111111', '20260903-0012', 'DINE_IN', 'COMPLETED', '2026-09-04', 16000, 16800, 'INR', NULL, NULL, NULL, '2026-09-04 01:19:56.483+05:30', '2026-09-04 01:19:56.837+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16800, 16000, 'POS-01', 'DINE_IN', '1bb0a59d-079d-4406-8bd9-0fd2f4a7668e', 0, 800, 0, 0, 'ord_1788464996469_3mcstu8', NULL);
INSERT INTO public.orders VALUES ('76692730-cd05-45cd-b8ad-9cc20ac9fc5a', '11111111-1111-1111-1111-111111111111', '20260908-0006', 'DINE_IN', 'COMPLETED', '2026-09-08', 7000, 7350, 'INR', NULL, NULL, NULL, '2026-09-08 15:13:45.024+05:30', '2026-09-09 12:47:11.545+05:30', NULL, NULL, '2026-09-09 12:47:11.546+05:30', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7350, 7000, 'POS-01', 'DELIVERY', '2e681514-bcbe-4ef9-bc4d-b2209a3d5f85', 0, 350, 0, 0, 'ord_1788860625004_0vfwvn1', NULL);
INSERT INTO public.orders VALUES ('b101f725-9679-4cf3-9f0f-16adb200ecff', '11111111-1111-1111-1111-111111111111', '20260908-0004', 'DINE_IN', 'COMPLETED', '2026-09-08', 3000, 3150, 'INR', NULL, NULL, NULL, '2026-09-08 14:27:24.401+05:30', '2026-09-09 15:08:58.35+05:30', NULL, NULL, '2026-09-09 12:45:00.458+05:30', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3150, 3000, 'POS-01', 'DINE_IN', NULL, 0, 150, 0, 0, 'ord_1788857844387_pnho1th', NULL);
INSERT INTO public.orders VALUES ('f973888e-e429-473a-8566-ddea7ac708a0', '11111111-1111-1111-1111-111111111111', '20260909-0003', 'DINE_IN', 'KOT_CREATED', '2026-09-09', 25500, 26775, 'INR', NULL, NULL, NULL, '2026-09-09 12:52:31.635+05:30', '2026-09-09 12:52:31.668+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 26775, 25500, 'TEST-01', 'DINE_IN', NULL, 0, 1275, 0, 0, 'test-stock-1788938551577', NULL);
INSERT INTO public.orders VALUES ('d71091c4-71f0-4c75-bd38-c6b08ba4dd4a', '11111111-1111-1111-1111-111111111111', '20260909-0015', 'DINE_IN', 'KOT_CREATED', '2026-09-09', 25000, 26250, 'INR', NULL, NULL, NULL, '2026-09-09 14:32:48.228+05:30', '2026-09-09 14:32:48.893+05:30', NULL, NULL, NULL, '2026-09-09 14:47:48.133+05:30', '2026-09-09 15:17:48.133+05:30', 25000, 'FIRED', 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, 'Sanjay Singhania', '9876543210', NULL, NULL, NULL, 26250, 25000, 'POS-01', 'DELIVERY', NULL, 0, 1250, 0, 0, 'adv-test-1788944568135', NULL);
INSERT INTO public.orders VALUES ('0a746ebb-ff2b-40d1-8d00-5e7652f56006', '11111111-1111-1111-1111-111111111111', '20260909-0009', 'DINE_IN', 'COMPLETED', '2026-09-09', 8500, 8925, 'INR', NULL, NULL, NULL, '2026-09-09 14:27:26.133+05:30', '2026-09-09 15:08:58.35+05:30', NULL, NULL, '2026-09-09 15:08:54.403+05:30', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15225, 14500, 'T-01', 'DINE_IN', NULL, 0, 725, 0, 0, 'waiter-1788944246063-ncm62ehlzdq', NULL);
INSERT INTO public.orders VALUES ('4e192b03-6942-454a-a9dd-9084d99362b1', '11111111-1111-1111-1111-111111111111', '20260909-0005', 'DINE_IN', 'KOT_CREATED', '2026-09-09', 25500, 26775, 'INR', NULL, NULL, NULL, '2026-09-09 13:02:02.18+05:30', '2026-09-09 13:02:03.027+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1275, 0, 'TEST-01', 'DINE_IN', NULL, 0, 1275, 0, 0, 'test-stock-1788939122107', NULL);
INSERT INTO public.orders VALUES ('c182470d-5000-40bc-86f8-b9093c4333e8', '11111111-1111-1111-1111-111111111111', '20260909-0010', 'DINE_IN', 'HANDED_OVER', '2026-09-09', 25000, 26250, 'INR', NULL, NULL, NULL, '2026-09-09 14:27:33.537+05:30', '2026-09-11 11:10:15.606+05:30', NULL, NULL, NULL, '2026-09-09 14:42:33.465+05:30', '2026-09-09 15:12:33.465+05:30', 25000, 'FIRED', 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 26250, 25000, 'POS-01', 'DELIVERY', NULL, 0, 1250, 0, 0, 'adv-test-1788944253467', NULL);
INSERT INTO public.orders VALUES ('5583e31e-48a5-435a-936e-aba2f8bb9c9c', '11111111-1111-1111-1111-111111111111', '20260903-0008', 'DINE_IN', 'HANDED_OVER', '2026-09-03', 8500, 8500, 'INR', NULL, NULL, NULL, '2026-09-03 15:17:20.19+05:30', '2026-09-04 00:43:39.266+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8905, 8500, 'POS-01', 'DINE_IN', NULL, 0, 405, 0, 0, 'ord_1788428840172_i5luagi', NULL);
INSERT INTO public.orders VALUES ('e93358df-ec3b-4e3b-a241-8e93bd953411', '11111111-1111-1111-1111-111111111111', '20260903-0005', 'DINE_IN', 'HANDED_OVER', '2026-09-03', 850000, 850000, 'INR', NULL, NULL, NULL, '2026-09-03 14:21:16.17+05:30', '2026-09-04 00:40:28.025+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8904, 8500, 'T-01', 'DINE_IN', NULL, 0, 404, 0, 0, 'ord_1788425476160_z6c5dx6', NULL);
INSERT INTO public.orders VALUES ('0f3580d0-cceb-4289-99f8-5ffdf1669b18', '11111111-1111-1111-1111-111111111111', '20260905-0002', 'DINE_IN', 'COMPLETED', '2026-09-05', 5000, 5250, 'INR', NULL, NULL, NULL, '2026-09-05 15:10:12.587+05:30', '2026-09-05 15:10:12.827+05:30', NULL, NULL, '2026-09-05 15:10:12.826+05:30', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5250, 5000, 'POS-01', 'DELIVERY', NULL, 0, 250, 0, 0, 'ord_1788601212574_wa4ogo8', NULL);
INSERT INTO public.orders VALUES ('c3a366cb-039e-4e26-9cbd-8e22cd2d52b9', '11111111-1111-1111-1111-111111111111', '20260905-0003', 'DINE_IN', 'KOT_CREATED', '2026-09-05', 8500, 8925, 'INR', NULL, NULL, NULL, '2026-09-05 16:22:38.18+05:30', '2026-09-05 16:22:38.21+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8925, 8500, 'POS-01', 'DELIVERY', NULL, 0, 425, 0, 0, 'ord_1788605558170_1gmdq2r', NULL);
INSERT INTO public.orders VALUES ('cff7a875-fec8-4189-bc71-ae49b0e19488', '67315042-c687-4cbb-b45a-f4ea4efc199f', '20260911-0001', 'DINE_IN', 'CANCELLED', '2026-09-11', 34000, 35700, 'INR', NULL, NULL, NULL, '2026-09-11 14:11:01.856+05:30', '2026-09-11 14:11:01.878+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 35700, 34000, 'POS-01', 'DINE_IN', '689515c9-28fd-4324-9b84-3f99d1075bd6', 0, 1700, 0, 0, 'ord_1789116061838_98wmqeq', '5e635b7d-856a-40b8-8a8c-1398f74eca30');
INSERT INTO public.orders VALUES ('5b433b06-af43-4f62-8a6b-e2ca1e0bfa88', '67315042-c687-4cbb-b45a-f4ea4efc199f', '20260905-0001', 'DINE_IN', 'COMPLETED', '2026-09-05', 34000, 35700, 'INR', NULL, NULL, NULL, '2026-09-05 16:45:41.988+05:30', '2026-09-05 16:45:42.158+05:30', NULL, NULL, '2026-09-05 16:45:42.157+05:30', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 35700, 34000, 'POS-01', 'DINE_IN', NULL, 0, 1700, 0, 0, 'ord_1788606941959_wnespmw', NULL);
INSERT INTO public.orders VALUES ('f9b4ac11-21c8-4617-9a1d-f1d7e8147a37', '67315042-c687-4cbb-b45a-f4ea4efc199f', '20260911-0003', 'DINE_IN', 'KOT_CREATED', '2026-09-11', 34000, 35700, 'INR', NULL, NULL, NULL, '2026-09-11 14:16:07.299+05:30', '2026-09-11 14:16:07.337+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 35700, 34000, 'POS-01', 'DINE_IN', '6a306a91-9632-4294-a4e9-b21f41fd2206', 0, 1700, 0, 0, 'ord_1789116367278_fdmvqib', '5e635b7d-856a-40b8-8a8c-1398f74eca30');
INSERT INTO public.orders VALUES ('7a369854-faf1-4af3-8378-8b939249c434', '11111111-1111-1111-1111-111111111111', '20260905-0004', 'DINE_IN', 'COMPLETED', '2026-09-05', 6500, 6825, 'INR', NULL, NULL, NULL, '2026-09-05 16:51:32.7+05:30', '2026-09-05 16:51:32.893+05:30', NULL, NULL, '2026-09-05 16:51:32.892+05:30', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6825, 6500, 'POS-01', 'DELIVERY', NULL, 0, 325, 0, 0, 'ord_1788607292692_9ytidv5', NULL);
INSERT INTO public.orders VALUES ('829e83e6-ea56-4173-bfe2-463b24e497a4', '67315042-c687-4cbb-b45a-f4ea4efc199f', '20260911-0004', 'DINE_IN', 'CANCELLED', '2026-09-11', 34000, 35700, 'INR', NULL, NULL, NULL, '2026-09-11 14:19:07.411+05:30', '2026-09-11 14:19:07.453+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 35700, 34000, 'POS-01', 'DINE_IN', '60d8deb7-f101-4ab6-b384-bc6118a32a7b', 0, 1700, 0, 0, 'ord_1789116547396_dbsxsuu', '5e635b7d-856a-40b8-8a8c-1398f74eca30');
INSERT INTO public.orders VALUES ('abaed738-9e4f-4470-ae04-031b3baa4721', '11111111-1111-1111-1111-111111111111', '20260912-0001', 'DINE_IN', 'COMPLETED', '2026-09-12', 15000, 15750, 'INR', NULL, NULL, NULL, '2026-09-12 16:04:39.515+05:30', '2026-09-12 16:05:47.987+05:30', NULL, NULL, '2026-09-12 16:05:47.985+05:30', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19050, 15000, 'T-01', 'DINE_IN', '2e681514-bcbe-4ef9-bc4d-b2209a3d5f85', 0, 750, 0, 3300, 'waiter-1789209279470-9wkrb1wr5wn', '72bad3bb-6097-47d2-bfc2-35b1244a7b9f');
INSERT INTO public.orders VALUES ('547361f1-ab65-4eeb-b5ae-790378f1eebc', '11111111-1111-1111-1111-111111111111', '20260912-0003', 'DINE_IN', 'COMPLETED', '2026-09-12', 8500, 8925, 'INR', NULL, NULL, NULL, '2026-09-12 16:22:09.473+05:30', '2026-09-12 16:22:52.528+05:30', NULL, NULL, '2026-09-12 16:22:52.526+05:30', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8925, 8500, 'T-01', 'DINE_IN', 'bb01f08e-7a9d-43b3-acce-be35218b3f27', 0, 425, 0, 0, 'waiter-1789210329444-8s7p4zq7qke', '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.orders VALUES ('815fbab6-72c9-41f6-b104-3f8df856c545', '11111111-1111-1111-1111-111111111111', '20260912-0005', 'DINE_IN', 'IN_PREPARATION', '2026-09-12', 16000, 16800, 'INR', NULL, NULL, NULL, '2026-09-12 16:40:24.108+05:30', '2026-09-12 17:22:29.987+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16800, 16000, 'T-01', 'DINE_IN', 'bb01f08e-7a9d-43b3-acce-be35218b3f27', 0, 800, 0, 0, 'waiter-1789211424081-09pp1sd8ignb', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06');
INSERT INTO public.orders VALUES ('89dba099-01ad-417a-a438-66ca8af5e712', '11111111-1111-1111-1111-111111111111', '20260911-0005', 'DINE_IN', 'SERVED', '2026-09-11', 5000, 5250, 'INR', NULL, NULL, NULL, '2026-09-11 14:24:19.82+05:30', '2026-09-11 14:44:37.612+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5250, 5000, 'T-01', 'DINE_IN', 'f2f701b9-6bc9-4869-8f88-4904a35070d8', 0, 250, 0, 0, 'waiter-1789116859770-jjo9rt2sm6', '9b35fd7a-2717-4837-ad91-9328aee9ec5f');
INSERT INTO public.orders VALUES ('4a4e9d6c-a797-4b03-9835-a44526c890e2', '11111111-1111-1111-1111-111111111111', '20260911-0006', 'DINE_IN', 'COMPLETED', '2026-09-11', 6000, 6300, 'INR', NULL, NULL, NULL, '2026-09-11 14:25:28.493+05:30', '2026-09-12 15:32:01.72+05:30', NULL, NULL, '2026-09-12 15:32:01.713+05:30', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17600, 12000, 'T-01', 'DINE_IN', '2e681514-bcbe-4ef9-bc4d-b2209a3d5f85', 0, 600, 0, 5000, 'waiter-1789116928464-0td9r51w84vp', '72bad3bb-6097-47d2-bfc2-35b1244a7b9f');
INSERT INTO public.orders VALUES ('8139a10d-c414-4402-818c-ea00cfd5e786', '11111111-1111-1111-1111-111111111111', '20260912-0002', 'DINE_IN', 'COMPLETED', '2026-09-12', 18000, 18900, 'INR', NULL, NULL, NULL, '2026-09-12 16:20:51.817+05:30', '2026-09-12 16:21:52.118+05:30', NULL, NULL, '2026-09-12 16:21:52.116+05:30', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18900, 18000, 'T-01', 'DINE_IN', '2e681514-bcbe-4ef9-bc4d-b2209a3d5f85', 0, 900, 0, 0, 'waiter-1789210251781-6sb1fu5wmcx', '918df673-2606-403a-9fad-1c54870d1fce');
INSERT INTO public.orders VALUES ('7bf0131c-f022-46a1-9a7b-8569cd3682f8', '11111111-1111-1111-1111-111111111111', '20260912-0004', 'DINE_IN', 'HANDED_OVER', '2026-09-12', 8000, 8400, 'INR', NULL, NULL, NULL, '2026-09-12 16:23:24.864+05:30', '2026-09-12 16:37:34.108+05:30', NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 50400, 48000, 'T-01', 'DINE_IN', '799771fc-55e6-42a7-8a24-c8946f547286', 0, 2400, 0, 0, 'waiter-1789210404835-fx1qlorgmw', '918df673-2606-403a-9fad-1c54870d1fce');


--
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.organizations VALUES ('00000000-0000-0000-0000-000000000000', 'Hotel Kapila Hospitality Group', NULL, NULL, '2026-09-02 14:05:00.622+05:30', '2026-09-02 16:33:25.638+05:30', NULL, NULL, '36AAACH7412K1Z9');


--
-- Data for Name: outbound_events; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: outbox_events; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.outbox_events VALUES ('79f0ef48-84c2-4f82-82c4-42110c104f00', '11111111-1111-1111-1111-111111111111', 'order.settled', '{"orderId": "a00d57c3-c01d-49d0-9166-45e9f7e22497", "amountMinor": "47250", "invoiceNumber": "INV-2026-00001", "paymentMethod": "CASH"}', 'PROCESSED', 0, 5, NULL, '2026-09-05 13:22:05.652+05:30', '2026-09-05 13:22:07.545+05:30');
INSERT INTO public.outbox_events VALUES ('3e7fca4a-a950-488f-87d2-cb4d69b49857', '11111111-1111-1111-1111-111111111111', 'order.settled', '{"orderId": "0f3580d0-cceb-4289-99f8-5ffdf1669b18", "amountMinor": "5250", "invoiceNumber": "INV-2026-00002", "paymentMethod": "CASH"}', 'PROCESSED', 0, 5, NULL, '2026-09-05 15:10:12.847+05:30', '2026-09-05 15:10:13.296+05:30');
INSERT INTO public.outbox_events VALUES ('6790ae2b-583d-485a-8bc7-717c9d5b9f62', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'order.settled', '{"orderId": "5b433b06-af43-4f62-8a6b-e2ca1e0bfa88", "amountMinor": "35700", "invoiceNumber": "INV-2026-00001", "paymentMethod": "CASH"}', 'PROCESSED', 0, 5, NULL, '2026-09-05 16:45:42.254+05:30', '2026-09-05 16:45:42.988+05:30');
INSERT INTO public.outbox_events VALUES ('43273480-a03e-42d5-ab9e-274df36d44f7', '11111111-1111-1111-1111-111111111111', 'order.settled', '{"orderId": "7a369854-faf1-4af3-8378-8b939249c434", "amountMinor": "6825", "invoiceNumber": "INV-2026-00003", "paymentMethod": "CASH"}', 'PROCESSED', 0, 5, NULL, '2026-09-05 16:51:32.915+05:30', '2026-09-05 16:51:34.336+05:30');
INSERT INTO public.outbox_events VALUES ('7ed1dd89-4018-4af1-b197-831f81a1d69d', '11111111-1111-1111-1111-111111111111', 'order.settled', '{"orderId": "82e2a068-a74a-4e18-89fe-7a423f5b243f", "amountMinor": "7350", "invoiceNumber": "INV-2026-00004", "paymentMethod": "CASH"}', 'PROCESSED', 0, 5, NULL, '2026-09-05 17:14:44.791+05:30', '2026-09-05 17:14:45.559+05:30');
INSERT INTO public.outbox_events VALUES ('d4f1761c-73ce-43b3-bbde-e8468cf84ca3', '11111111-1111-1111-1111-111111111111', 'order.settled', '{"orderId": "71ef893c-0ccc-439d-bc3e-0a248037303b", "amountMinor": "10904", "invoiceNumber": "INV-2026-00005", "paymentMethod": "CASH"}', 'PROCESSED', 0, 5, NULL, '2026-09-08 11:01:05.883+05:30', '2026-09-08 11:01:06.149+05:30');
INSERT INTO public.outbox_events VALUES ('c0db696f-ea71-48de-800f-608ef3ace8b4', '11111111-1111-1111-1111-111111111111', 'order.settled', '{"orderId": "1085cebe-ebf0-4804-83f3-aae6d0d4a7c9", "amountMinor": "77075", "invoiceNumber": "INV-2026-00006", "paymentMethod": "CASH"}', 'PROCESSED', 0, 5, NULL, '2026-09-08 11:10:47.915+05:30', '2026-09-08 11:10:48.379+05:30');
INSERT INTO public.outbox_events VALUES ('dd8ea28b-54fc-401c-bc6e-b8edc3c22882', '11111111-1111-1111-1111-111111111111', 'order.settled', '{"orderId": "e7d4d6cf-4838-43bd-8334-688d11302496", "amountMinor": "116025", "invoiceNumber": "INV-2026-00007", "paymentMethod": "CASH"}', 'PROCESSED', 0, 5, NULL, '2026-09-08 11:17:50.453+05:30', '2026-09-08 11:17:51.985+05:30');
INSERT INTO public.outbox_events VALUES ('be13dfbe-e902-4e3c-829e-c10e7f574a14', '11111111-1111-1111-1111-111111111111', 'order.settled', '{"orderId": "b101f725-9679-4cf3-9f0f-16adb200ecff", "amountMinor": "3150", "invoiceNumber": "INV-2026-00008", "paymentMethod": "CASH"}', 'PROCESSED', 0, 5, NULL, '2026-09-09 12:45:00.49+05:30', '2026-09-09 12:45:01.451+05:30');
INSERT INTO public.outbox_events VALUES ('d29ea696-2662-4471-a324-306c3ae4fdca', '11111111-1111-1111-1111-111111111111', 'order.settled', '{"orderId": "76692730-cd05-45cd-b8ad-9cc20ac9fc5a", "amountMinor": "7350", "invoiceNumber": "INV-2026-00009", "paymentMethod": "CASH"}', 'PROCESSED', 0, 5, NULL, '2026-09-09 12:47:11.565+05:30', '2026-09-09 12:47:13.477+05:30');
INSERT INTO public.outbox_events VALUES ('8708d67f-7a81-4fd5-b952-c378d897497a', '11111111-1111-1111-1111-111111111111', 'order.settled', '{"orderId": "0602cb47-3398-4ba0-b5da-87e23909efa3", "amountMinor": "534975", "invoiceNumber": "INV-2026-00010", "paymentMethod": "CASH"}', 'PROCESSED', 0, 5, NULL, '2026-09-09 12:51:03.289+05:30', '2026-09-09 12:51:04.359+05:30');
INSERT INTO public.outbox_events VALUES ('1449a584-3a27-4ddd-acbc-c3d15bc0b0c4', '11111111-1111-1111-1111-111111111111', 'order.settled', '{"orderId": "2d4b655e-a5bf-4900-ba0c-11e1b3c2685c", "amountMinor": "473025", "invoiceNumber": "INV-2026-00011", "paymentMethod": "CASH"}', 'PROCESSED', 0, 5, NULL, '2026-09-09 14:06:01.151+05:30', '2026-09-09 14:06:02.968+05:30');
INSERT INTO public.outbox_events VALUES ('3a63e8a5-9e20-4a94-9dde-fd32628fd809', '11111111-1111-1111-1111-111111111111', 'order.settled', '{"orderId": "eb13fd97-c972-4447-8a42-898eb545191e", "amountMinor": "21000", "invoiceNumber": "INV-2026-00012", "paymentMethod": "CASH"}', 'PROCESSED', 0, 5, NULL, '2026-09-09 14:07:07.633+05:30', '2026-09-09 14:07:09.239+05:30');
INSERT INTO public.outbox_events VALUES ('3c4cc1df-f270-4259-a4f1-6fcb097aaf02', '11111111-1111-1111-1111-111111111111', 'order.settled', '{"orderId": "f5d3449d-ce21-48cb-ab01-b41c41a7301c", "amountMinor": "45675", "invoiceNumber": "INV-2026-00013", "paymentMethod": "CASH"}', 'PROCESSED', 0, 5, NULL, '2026-09-09 14:07:29.961+05:30', '2026-09-09 14:07:31.324+05:30');
INSERT INTO public.outbox_events VALUES ('9e72b467-5274-4cfa-8496-8fcebadf1604', '11111111-1111-1111-1111-111111111111', 'order.settled', '{"orderId": "0a746ebb-ff2b-40d1-8d00-5e7652f56006", "amountMinor": "15225", "invoiceNumber": "INV-2026-00014", "paymentMethod": "CASH"}', 'PROCESSED', 0, 5, NULL, '2026-09-09 15:08:54.432+05:30', '2026-09-09 15:08:56.105+05:30');
INSERT INTO public.outbox_events VALUES ('f624578e-a034-4620-a9f0-3ad7293c50af', '11111111-1111-1111-1111-111111111111', 'order.settled', '{"orderId": "3e1ba9c8-0311-4534-a8d3-fa97b3a4f933", "amountMinor": "15500", "invoiceNumber": "INV-2026-00015", "paymentMethod": "CASH"}', 'PROCESSED', 0, 5, NULL, '2026-09-10 17:17:49.787+05:30', '2026-09-10 17:17:51.578+05:30');
INSERT INTO public.outbox_events VALUES ('f457348e-04a5-413e-a4cd-90a6d947e698', '11111111-1111-1111-1111-111111111111', 'order.settled', '{"orderId": "c8387bcf-ab67-44bb-87fb-d67f6d7601ca", "amountMinor": "17600", "invoiceNumber": "INV-2026-00016", "paymentMethod": "CASH"}', 'PROCESSED', 0, 5, NULL, '2026-09-11 12:34:34.943+05:30', '2026-09-11 12:34:36.773+05:30');
INSERT INTO public.outbox_events VALUES ('5e112515-9d99-4c76-940c-4af75203a6e5', '11111111-1111-1111-1111-111111111111', 'order.settled', '{"orderId": "27f9f630-3e8b-4ba9-b4d7-e631e45182f7", "amountMinor": "10250", "invoiceNumber": "INV-2026-00017", "paymentMethod": "CASH"}', 'PROCESSED', 0, 5, NULL, '2026-09-11 12:35:19.717+05:30', '2026-09-11 12:35:20.92+05:30');
INSERT INTO public.outbox_events VALUES ('4b126d0d-1653-4fb9-88d7-4aef2d03b3b5', '11111111-1111-1111-1111-111111111111', 'order.settled', '{"orderId": "4a4e9d6c-a797-4b03-9835-a44526c890e2", "amountMinor": "17600", "invoiceNumber": "INV-2026-00018", "paymentMethod": "CASH"}', 'PROCESSED', 0, 5, NULL, '2026-09-12 15:32:01.742+05:30', '2026-09-12 15:32:02.121+05:30');
INSERT INTO public.outbox_events VALUES ('dc417fb7-e294-4343-9f22-8e60fce42ed7', '11111111-1111-1111-1111-111111111111', 'order.settled', '{"orderId": "abaed738-9e4f-4470-ae04-031b3baa4721", "amountMinor": "19050", "invoiceNumber": "INV-2026-00019", "paymentMethod": "CASH"}', 'PROCESSED', 0, 5, NULL, '2026-09-12 16:05:48.012+05:30', '2026-09-12 16:05:49.906+05:30');
INSERT INTO public.outbox_events VALUES ('25da04d1-e255-4de8-b8ff-b70eb38091f8', '11111111-1111-1111-1111-111111111111', 'order.settled', '{"orderId": "8139a10d-c414-4402-818c-ea00cfd5e786", "amountMinor": "18900", "invoiceNumber": "INV-2026-00020", "paymentMethod": "CASH"}', 'PROCESSED', 0, 5, NULL, '2026-09-12 16:21:52.137+05:30', '2026-09-12 16:21:53.14+05:30');
INSERT INTO public.outbox_events VALUES ('271c36e3-2e5c-4db6-979f-1e4500fceccf', '11111111-1111-1111-1111-111111111111', 'order.settled', '{"orderId": "547361f1-ab65-4eeb-b5ae-790378f1eebc", "amountMinor": "8925", "invoiceNumber": "INV-2026-00021", "paymentMethod": "CASH"}', 'PROCESSED', 0, 5, NULL, '2026-09-12 16:22:52.554+05:30', '2026-09-12 16:22:53.353+05:30');


--
-- Data for Name: outlet_billing_settings; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.outlet_billing_settings VALUES ('41af6efb-5c2c-42ee-9449-715f00d431d7', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'INV-', 'KOT-', true, 1.00, false, 0.000, false, 50.000, false, false, '2026-09-03 12:29:17.383865+05:30', '2026-09-03 12:29:17.383865+05:30', '{}');


--
-- Data for Name: outlet_print_settings; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.outlet_print_settings VALUES ('f7cbeecc-2cb7-4926-86d2-901c4e4ecc67', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Kitchen Thermal 80mm', 80, false, true, true, true, true, true, 1, 1, 'Thank you for dining at Hotel Kapila! Please visit again.', '2026-09-03 12:29:17.390448+05:30', '2026-09-03 12:29:17.390448+05:30', '{}');


--
-- Data for Name: outlet_status; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.outlet_status VALUES ('67315042-c687-4cbb-b45a-f4ea4efc199f', true, '2026-09-05 13:04:10.655714+05:30', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc');


--
-- Data for Name: outlets; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.outlets VALUES ('67315042-c687-4cbb-b45a-f4ea4efc199f', '00000000-0000-0000-0000-000000000000', 'NZB-01', 'Hotel Kapila', 'Asia/Kolkata', 'INR', '06:00', true, '2026-09-02 14:45:15.177+05:30', '2026-09-02 16:21:33.117+05:30', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Pragathi Nagar, Central Nizamabad, Telangana 503001', NULL, NULL, NULL);
INSERT INTO public.outlets VALUES ('2a543c3c-066f-4097-833a-df7c25700580', '00000000-0000-0000-0000-000000000000', 'R327038', 'Hotel kapila', 'Asia/Kolkata', 'INR', '06:00', true, '2026-09-02 16:33:25.646+05:30', '2026-09-02 16:33:25.646+05:30', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Pragathi Nagar, Central Nizamabad, Telangana 503001', NULL, NULL, NULL);
INSERT INTO public.outlets VALUES ('11111111-1111-1111-1111-111111111111', '00000000-0000-0000-0000-000000000000', 'MAIN-01', 'Hotel Kapila (Main Outlet)', 'Asia/Kolkata', 'INR', '05:00:00', true, '2026-09-03 12:49:54.098928+05:30', '2026-09-03 12:49:54.098928+05:30', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


--
-- Data for Name: payment_summary; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: payment_type_master; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.payment_type_master VALUES ('3677d05b-c463-40f5-95fa-c5fa8de4db34', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Cash', false, true, 1, '2026-09-03 12:29:17.35798+05:30', '2026-09-03 12:29:17.35798+05:30');
INSERT INTO public.payment_type_master VALUES ('965dc54c-6c57-49e5-a7a3-45d6dfd6ca8a', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Card (EDC Terminal)', false, true, 2, '2026-09-03 12:29:17.371913+05:30', '2026-09-03 12:29:17.371913+05:30');
INSERT INTO public.payment_type_master VALUES ('b6eae7c6-fb39-4458-96f8-3dcd06a05662', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'UPI / QR Code', false, true, 3, '2026-09-03 12:29:17.37303+05:30', '2026-09-03 12:29:17.37303+05:30');
INSERT INTO public.payment_type_master VALUES ('e796da65-0988-4fc4-9426-1bb8a231e2b7', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Swiggy Settlement', true, true, 4, '2026-09-03 12:29:17.374352+05:30', '2026-09-03 12:29:17.374352+05:30');
INSERT INTO public.payment_type_master VALUES ('192bb89f-a715-4dca-8361-827ca4f8afdf', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Zomato Settlement', true, true, 5, '2026-09-03 12:29:17.375526+05:30', '2026-09-03 12:29:17.375526+05:30');
INSERT INTO public.payment_type_master VALUES ('d4e82ea0-7e59-48f3-88e6-6a978dc75c4d', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Room Service / Due', false, true, 6, '2026-09-03 12:29:17.376607+05:30', '2026-09-03 12:29:17.376607+05:30');
INSERT INTO public.payment_type_master VALUES ('23608557-96f5-4666-8fc8-895961345d64', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Complimentary / House', false, true, 7, '2026-09-03 12:29:17.377803+05:30', '2026-09-03 12:29:17.377803+05:30');


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.payments VALUES ('589efb55-2a0d-4c79-8ba3-d5677f01c155', '11111111-1111-1111-1111-111111111111', 'e7eccfdc-02d5-470f-869b-da665f7dcb2e', 37250, 'CASH', 'CAPTURED', NULL, '7771eb3f-df7f-45f2-b1ab-2ee6dc19c978', '2026-09-04 00:03:15.362+05:30', NULL, NULL, NULL);
INSERT INTO public.payments VALUES ('1a3d604c-edec-4c9a-87ab-648a8bbf133c', '11111111-1111-1111-1111-111111111111', '0f621958-d193-4d99-b6ef-037fcea9cd0a', 16800, 'CASH', 'CAPTURED', NULL, '9bbfa8fd-01de-4011-9620-fab6d2fc5140', '2026-09-04 00:06:34.67+05:30', NULL, NULL, NULL);
INSERT INTO public.payments VALUES ('9c5e5749-9c4f-4e49-9355-80afe225f04e', '11111111-1111-1111-1111-111111111111', 'ece12171-62db-4f53-ba97-d5e93e06f733', 15750, 'CASH', 'CAPTURED', NULL, 'da41cd2a-b4a4-47c4-abc7-71defaaea79e', '2026-09-04 01:14:43.206+05:30', NULL, NULL, NULL);
INSERT INTO public.payments VALUES ('923c400d-2aa6-40e9-bff1-a6777d7c075e', '11111111-1111-1111-1111-111111111111', 'b5177d27-2e27-4abd-8296-83a748730b2c', 16800, 'CASH', 'CAPTURED', NULL, '8011ea2d-8a8a-4750-9f25-6751677ff02f', '2026-09-04 01:19:56.899+05:30', NULL, NULL, NULL);
INSERT INTO public.payments VALUES ('a23c5ed2-25df-4ffd-a6a0-e8d8d6729f43', '11111111-1111-1111-1111-111111111111', 'a00d57c3-c01d-49d0-9166-45e9f7e22497', 47250, 'CASH', 'CAPTURED', NULL, 'b9694bae-815c-4bb1-a1ef-90ab640ba16d', '2026-09-05 13:22:05.597+05:30', NULL, NULL, NULL);
INSERT INTO public.payments VALUES ('2feeaab6-7543-447d-a565-a8104b9eb3eb', '11111111-1111-1111-1111-111111111111', '0f3580d0-cceb-4289-99f8-5ffdf1669b18', 5250, 'CASH', 'CAPTURED', NULL, 'a8e61bb6-6f19-45aa-8d64-fb9fef6f911b', '2026-09-05 15:10:12.788+05:30', NULL, NULL, NULL);
INSERT INTO public.payments VALUES ('ffcfae6a-f1e2-418d-94fa-cb1c38179fd3', '67315042-c687-4cbb-b45a-f4ea4efc199f', '5b433b06-af43-4f62-8a6b-e2ca1e0bfa88', 35700, 'CASH', 'CAPTURED', NULL, 'ee563f61-47b1-488c-84f1-51333c21790e', '2026-09-05 16:45:42.138+05:30', NULL, NULL, NULL);
INSERT INTO public.payments VALUES ('2e8207de-394f-40ad-bd95-84b3b2998a9b', '11111111-1111-1111-1111-111111111111', '7a369854-faf1-4af3-8378-8b939249c434', 6825, 'CASH', 'CAPTURED', NULL, 'db031719-7d90-4828-baf9-165aaf6f70cb', '2026-09-05 16:51:32.866+05:30', NULL, NULL, NULL);
INSERT INTO public.payments VALUES ('cd2961e5-434c-4fd7-a178-659c524137f0', '11111111-1111-1111-1111-111111111111', '82e2a068-a74a-4e18-89fe-7a423f5b243f', 7350, 'CASH', 'CAPTURED', NULL, 'ad25de24-a6f2-4e38-a4ac-02d3e6cd20e0', '2026-09-05 17:14:44.751+05:30', NULL, NULL, NULL);
INSERT INTO public.payments VALUES ('1761086d-1e14-4acd-8f1c-a5cbcf3e80d8', '11111111-1111-1111-1111-111111111111', '71ef893c-0ccc-439d-bc3e-0a248037303b', 10904, 'CASH', 'CAPTURED', NULL, '58fadf16-22f1-4477-b1e2-0c1ec66f3390', '2026-09-08 11:01:05.774+05:30', NULL, NULL, NULL);
INSERT INTO public.payments VALUES ('e4630b40-86f0-4b79-8e21-9053a0db4ab3', '11111111-1111-1111-1111-111111111111', '1085cebe-ebf0-4804-83f3-aae6d0d4a7c9', 77075, 'CASH', 'CAPTURED', NULL, '48aea828-6500-43aa-9ca8-8140b778a22d', '2026-09-08 11:10:47.798+05:30', NULL, NULL, NULL);
INSERT INTO public.payments VALUES ('83cadcc5-c2f6-4381-a36a-052d8b48b380', '11111111-1111-1111-1111-111111111111', 'e7d4d6cf-4838-43bd-8334-688d11302496', 116025, 'CASH', 'CAPTURED', NULL, 'cecfa6b9-0b8a-4582-a52f-3ec156c6b13c', '2026-09-08 11:17:50.355+05:30', NULL, NULL, NULL);
INSERT INTO public.payments VALUES ('f055326e-c3d8-4686-83ec-f739c167e7b9', '11111111-1111-1111-1111-111111111111', 'b101f725-9679-4cf3-9f0f-16adb200ecff', 3150, 'CASH', 'CAPTURED', NULL, '3aacc70e-41f1-44c5-b18f-eef721290735', '2026-09-09 12:45:00.343+05:30', NULL, NULL, NULL);
INSERT INTO public.payments VALUES ('77c1b0ca-ce68-49e9-a5ad-b8918a3df29f', '11111111-1111-1111-1111-111111111111', '76692730-cd05-45cd-b8ad-9cc20ac9fc5a', 7350, 'CASH', 'CAPTURED', NULL, 'e8434293-59db-46b2-a41b-c487f7722882', '2026-09-09 12:47:11.456+05:30', NULL, NULL, NULL);
INSERT INTO public.payments VALUES ('e605aa7d-04d2-4273-9088-89bcf90688b1', '11111111-1111-1111-1111-111111111111', '0602cb47-3398-4ba0-b5da-87e23909efa3', 534975, 'CASH', 'CAPTURED', NULL, 'd53159df-e69e-4495-b603-f8521951b5e7', '2026-09-09 12:51:03.181+05:30', NULL, NULL, NULL);
INSERT INTO public.payments VALUES ('5274906f-8668-478b-82e7-03b15eeb777e', '11111111-1111-1111-1111-111111111111', '2d4b655e-a5bf-4900-ba0c-11e1b3c2685c', 473025, 'CASH', 'CAPTURED', NULL, '2f7eba42-e459-4c8b-a3ad-0bd237643f74', '2026-09-09 14:06:01.082+05:30', NULL, NULL, NULL);
INSERT INTO public.payments VALUES ('2d505e0f-6dd7-411b-8bce-9a1ca5c7ef05', '11111111-1111-1111-1111-111111111111', 'eb13fd97-c972-4447-8a42-898eb545191e', 21000, 'CASH', 'CAPTURED', NULL, 'fccc09ce-4f79-4746-84f5-002d454d4cc5', '2026-09-09 14:07:07.588+05:30', NULL, NULL, NULL);
INSERT INTO public.payments VALUES ('35ad0d01-e3e1-4272-bcab-b8009bf61358', '11111111-1111-1111-1111-111111111111', 'f5d3449d-ce21-48cb-ab01-b41c41a7301c', 45675, 'CASH', 'CAPTURED', NULL, '7c57da93-2c0c-444b-ac16-2e1e547d738d', '2026-09-09 14:07:29.929+05:30', NULL, NULL, NULL);
INSERT INTO public.payments VALUES ('2a7ca9cc-5903-4193-bdfc-bf5bbe9e2e64', '11111111-1111-1111-1111-111111111111', '0a746ebb-ff2b-40d1-8d00-5e7652f56006', 15225, 'CASH', 'CAPTURED', NULL, '6372fd14-0374-4686-a38e-30db9872580e', '2026-09-09 15:08:54.365+05:30', NULL, NULL, NULL);
INSERT INTO public.payments VALUES ('1d81be04-8b53-4beb-b11c-b4cfbaef9c97', '11111111-1111-1111-1111-111111111111', '3e1ba9c8-0311-4534-a8d3-fa97b3a4f933', 15500, 'CASH', 'CAPTURED', NULL, '04049be6-12d8-49b2-8a0e-39be69087dd6', '2026-09-10 17:17:49.646+05:30', NULL, NULL, NULL);
INSERT INTO public.payments VALUES ('dab22667-14a1-457f-99ee-7116b8b01c13', '11111111-1111-1111-1111-111111111111', 'c8387bcf-ab67-44bb-87fb-d67f6d7601ca', 17600, 'CASH', 'CAPTURED', NULL, '0909b4c1-fb47-4214-bb4e-e3f4f8638d2d', '2026-09-11 12:34:34.833+05:30', NULL, NULL, NULL);
INSERT INTO public.payments VALUES ('287e9dac-3cdc-455d-89db-015a7b0a2b43', '11111111-1111-1111-1111-111111111111', '27f9f630-3e8b-4ba9-b4d7-e631e45182f7', 10250, 'CASH', 'CAPTURED', NULL, 'de02b7c9-6a63-4f66-8b4c-f2ecdad964ac', '2026-09-11 12:35:19.618+05:30', NULL, NULL, NULL);
INSERT INTO public.payments VALUES ('33787728-0141-444e-80ba-cb3d953fd707', '11111111-1111-1111-1111-111111111111', '4a4e9d6c-a797-4b03-9835-a44526c890e2', 17600, 'CASH', 'CAPTURED', NULL, 'a4a3c28c-e93f-4e2c-883c-0dd92aee7cd9', '2026-09-12 15:32:01.559+05:30', NULL, NULL, NULL);
INSERT INTO public.payments VALUES ('b71a774b-e736-4284-a1ab-2d7b108f9bad', '11111111-1111-1111-1111-111111111111', 'abaed738-9e4f-4470-ae04-031b3baa4721', 19050, 'CASH', 'CAPTURED', NULL, 'be324c34-d449-4232-a1ef-c22cadb3f8e6', '2026-09-12 16:05:47.906+05:30', NULL, NULL, NULL);
INSERT INTO public.payments VALUES ('b91471cb-4f98-4b75-9192-c05fc726d96a', '11111111-1111-1111-1111-111111111111', '8139a10d-c414-4402-818c-ea00cfd5e786', 18900, 'CASH', 'CAPTURED', NULL, '9c24e4b7-3d0c-4322-98b3-08c413381774', '2026-09-12 16:21:52.046+05:30', NULL, NULL, NULL);
INSERT INTO public.payments VALUES ('c24deced-ba82-4622-9292-ddd4b4903f30', '11111111-1111-1111-1111-111111111111', '547361f1-ab65-4eeb-b5ae-790378f1eebc', 8925, 'CASH', 'CAPTURED', NULL, '5039031c-863e-4a2b-b588-0b347abfa52c', '2026-09-12 16:22:52.438+05:30', NULL, NULL, NULL);


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.permissions VALUES ('a25fd2be-6972-4e06-bfe7-32e1877b53c3', 'order.create', 'order', 'Permission for order.create', NULL, NULL, 'order.create', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('fd6326f7-7866-46ab-b23d-159edbf94a27', 'order.read', 'order', 'Permission for order.read', NULL, NULL, 'order.read', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('8b5689a3-0c2b-4cad-a66f-49e0ae75daf9', 'order.update', 'order', 'Permission for order.update', NULL, NULL, 'order.update', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('08a791ca-1ef7-4b29-98a6-f02820b2a2b3', 'order.cancel', 'order', 'Permission for order.cancel', NULL, NULL, 'order.cancel', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('efec4365-ca52-4d5a-bd0f-02eef073296e', 'order.discount', 'order', 'Permission for order.discount', NULL, NULL, 'order.discount', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('3715b443-1ed9-4163-89bd-cf4fb359ceb3', 'kot.create', 'kot', 'Permission for kot.create', NULL, NULL, 'kot.create', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('618f709f-c32a-4e90-b129-3968ecf195b1', 'kot.read', 'kot', 'Permission for kot.read', NULL, NULL, 'kot.read', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('72282ca2-b8cc-4afb-b717-b5cef31b69eb', 'kot.update', 'kot', 'Permission for kot.update', NULL, NULL, 'kot.update', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('c892c4d5-644b-4853-83ee-f8dea5b6b952', 'kot.recall', 'kot', 'Permission for kot.recall', NULL, NULL, 'kot.recall', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('61f8d56b-7d29-4b08-b728-55e1364ec396', 'kot.manage', 'kot', 'Permission for kot.manage', NULL, NULL, 'kot.manage', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('50aecead-81be-4f41-b193-f4e8cc5f288d', 'table.read', 'table', 'Permission for table.read', NULL, NULL, 'table.read', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('7f18dc65-6e0a-467d-abe4-4f524b6e824e', 'table.transfer', 'table', 'Permission for table.transfer', NULL, NULL, 'table.transfer', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('5132d049-a00b-4489-9fad-2a55f51288ae', 'table.merge', 'table', 'Permission for table.merge', NULL, NULL, 'table.merge', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('1be9c022-ee67-46c2-ad71-cb9b23573f78', 'table.split', 'table', 'Permission for table.split', NULL, NULL, 'table.split', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('a8cc5bc1-bd12-42f3-9a5d-48ae4eb968e0', 'table.manage', 'table', 'Permission for table.manage', NULL, NULL, 'table.manage', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('bd09155b-91a2-4cd1-aa71-85a71bebb6be', 'bill.generate', 'bill', 'Permission for bill.generate', NULL, NULL, 'bill.generate', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('5d67b45d-285b-4de3-9466-7cf7467066ff', 'bill.settle', 'bill', 'Permission for bill.settle', NULL, NULL, 'bill.settle', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('00f5e8cd-1577-4986-8c2a-3ffafec22c25', 'bill.reprint', 'bill', 'Permission for bill.reprint', NULL, NULL, 'bill.reprint', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('2ab7f1c2-5fee-4861-bd89-0a1485df0ff4', 'bill.split', 'bill', 'Permission for bill.split', NULL, NULL, 'bill.split', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('d656bceb-ad28-4bdb-a4ce-361c02ebb2fe', 'payment.collect', 'payment', 'Permission for payment.collect', NULL, NULL, 'payment.collect', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('aceee97c-05c1-481f-b853-e79678ec5fad', 'payment.refund', 'payment', 'Permission for payment.refund', NULL, NULL, 'payment.refund', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('3bccf399-64ea-4574-904b-7db52741e624', 'payment.split', 'payment', 'Permission for payment.split', NULL, NULL, 'payment.split', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('99bf49fb-b3be-483b-b9dc-371f82b61227', 'menu.read', 'menu', 'Permission for menu.read', NULL, NULL, 'menu.read', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('3330a0b6-69a1-41eb-b880-0aabbc119e6d', 'menu.category.manage', 'menu', 'Permission for menu.category.manage', NULL, NULL, 'menu.category.manage', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('38e7d69b-0ad9-4f4f-9802-634c46adf192', 'menu.item.manage', 'menu', 'Permission for menu.item.manage', NULL, NULL, 'menu.item.manage', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('a6f18fbf-32ac-4ada-9e03-e7c86d19c110', 'menu.86.toggle', 'menu', 'Permission for menu.86.toggle', NULL, NULL, 'menu.86.toggle', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('694f4856-6a52-4c7e-a1d0-cd51f73d03bf', 'inventory.read', 'inventory', 'Permission for inventory.read', NULL, NULL, 'inventory.read', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('2c91df97-2384-4b82-b13f-43e6ca0c7a80', 'inventory.stock.adjust', 'inventory', 'Permission for inventory.stock.adjust', NULL, NULL, 'inventory.stock.adjust', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('aeadb674-5e88-4c38-a97b-ee14bf4ff355', 'inventory.po.create', 'inventory', 'Permission for inventory.po.create', NULL, NULL, 'inventory.po.create', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('08ed13ed-85b5-4211-a02c-aab1539a566d', 'inventory.po.approve', 'inventory', 'Permission for inventory.po.approve', NULL, NULL, 'inventory.po.approve', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('8871d288-9daa-4eb5-a117-b3df41e7f90f', 'inventory.grn.create', 'inventory', 'Permission for inventory.grn.create', NULL, NULL, 'inventory.grn.create', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('0a410ae9-158a-4fd2-9a8a-767adad7438a', 'inventory.write', 'inventory', 'Permission for inventory.write', NULL, NULL, 'inventory.write', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('bd732c4a-9f28-4a9f-8351-67ea192e41e0', 'inventory.stock.deduct', 'inventory', 'Permission for inventory.stock.deduct', NULL, NULL, 'inventory.stock.deduct', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('ce5bb0f0-2d74-4992-9112-c3731245eece', 'report.read', 'report', 'Permission for report.read', NULL, NULL, 'report.read', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('ef301064-b9ad-4a59-8734-738902495e39', 'report.financial.read', 'report', 'Permission for report.financial.read', NULL, NULL, 'report.financial.read', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('6d0c2f3f-4963-4667-81bc-85f323c9dfd1', 'report.audit.read', 'report', 'Permission for report.audit.read', NULL, NULL, 'report.audit.read', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('8fb93c32-2d85-4523-88e1-e9ab0a6ff005', 'report.export', 'report', 'Permission for report.export', NULL, NULL, 'report.export', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('a93fa551-c915-463e-9908-fb0019bd6f53', 'report.zreport', 'report', 'Permission for report.zreport', NULL, NULL, 'report.zreport', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('e3ee6f6b-7a52-4a46-960f-16a9e4566384', 'finance.report', 'finance', 'Permission for finance.report', NULL, NULL, 'finance.report', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('92830514-8a1a-4fb6-b402-7c9fb0e50f3d', 'finance.cash_drawer.manage', 'finance', 'Permission for finance.cash_drawer.manage', NULL, NULL, 'finance.cash_drawer.manage', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('6f91a8c7-45ec-4365-bb3a-e2b133543ebd', 'finance.petty_cash.record', 'finance', 'Permission for finance.petty_cash.record', NULL, NULL, 'finance.petty_cash.record', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('843937ff-2c69-4a15-9f3b-efb797479e75', 'crm.read', 'crm', 'Permission for crm.read', NULL, NULL, 'crm.read', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('35ba8ece-6851-43b4-bf0c-0a94c6da6a3b', 'crm.write', 'crm', 'Permission for crm.write', NULL, NULL, 'crm.write', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('8823c15e-ac5d-454a-bbe0-fe36d13b9fee', 'crm.loyalty.redeem', 'crm', 'Permission for crm.loyalty.redeem', NULL, NULL, 'crm.loyalty.redeem', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('3848292e-d6da-42ed-8e23-bcacf351427c', 'crm.loyalty.issue', 'crm', 'Permission for crm.loyalty.issue', NULL, NULL, 'crm.loyalty.issue', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('57387649-ae7f-4746-8953-2d991f6c84ea', 'settings.read', 'settings', 'Permission for settings.read', NULL, NULL, 'settings.read', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('59a02a0a-a40e-47c8-a42a-b55e32e7a4b1', 'settings.manage', 'settings', 'Permission for settings.manage', NULL, NULL, 'settings.manage', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('89b44b18-354b-4168-ba5d-76e949383a29', 'users.manage', 'users', 'Permission for users.manage', NULL, NULL, 'users.manage', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('0ab3bfed-93a7-4ef2-8771-09ce18e9e806', 'users.read', 'users', 'Permission for users.read', NULL, NULL, 'users.read', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('c74767a0-3fcc-498c-b74f-372b455069bb', 'outlets.manage', 'outlets', 'Permission for outlets.manage', NULL, NULL, 'outlets.manage', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('cef337ed-68b7-48c3-85be-937880107882', 'roles.manage', 'roles', 'Permission for roles.manage', NULL, NULL, 'roles.manage', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('6719b819-92e9-410c-a975-a26f5fcf744d', 'integration.manage', 'integration', 'Permission for integration.manage', NULL, NULL, 'integration.manage', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('a975d9ea-ecfa-480b-89d2-908db5cc336a', 'integration.sync', 'integration', 'Permission for integration.sync', NULL, NULL, 'integration.sync', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');
INSERT INTO public.permissions VALUES ('c39074a4-72b7-4203-a00d-308c7cb97e9a', 'audit.read', 'audit', 'Permission for audit.read', NULL, NULL, 'audit.read', '2026-09-03 13:02:50.015095+05:30', '2026-09-03 13:02:50.017419+05:30');


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

INSERT INTO public.recipe_ingredients VALUES ('ff7c3ab1-f7aa-4833-9c42-b4c7fb49240c', '12eabedd-f2c0-4dab-98cf-7f080acee451', 'd78382d7-01dd-4e51-a6d9-374e54182a54', 0.250, '2026-09-02 17:56:41.916832+05:30', 100, '2026-09-02 17:56:41.916832+05:30');
INSERT INTO public.recipe_ingredients VALUES ('b838c170-0d06-4683-99b5-098cc0e55429', '12eabedd-f2c0-4dab-98cf-7f080acee451', 'f811d9a2-42c3-45dd-b45a-15ee97731274', 0.200, '2026-09-02 17:56:41.924392+05:30', 85, '2026-09-02 17:56:41.924392+05:30');
INSERT INTO public.recipe_ingredients VALUES ('57fb0988-4cd2-4c8b-8497-4e21f9b5c199', '97517262-cc02-492b-a9ac-bc42bb784c9a', 'f811d9a2-42c3-45dd-b45a-15ee97731274', 0.200, '2026-09-02 17:56:41.945971+05:30', 85, '2026-09-02 17:56:41.945971+05:30');
INSERT INTO public.recipe_ingredients VALUES ('078aa035-9794-4ba5-8d47-b9ef5f66157a', '97517262-cc02-492b-a9ac-bc42bb784c9a', '66ae2eba-88d4-47ce-bdfd-8e11320952ab', 0.150, '2026-09-02 17:56:41.950259+05:30', 100, '2026-09-02 17:56:41.950259+05:30');


--
-- Data for Name: recipes; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.recipes VALUES ('12eabedd-f2c0-4dab-98cf-7f080acee451', '67315042-c687-4cbb-b45a-f4ea4efc199f', '1048c560-86bd-45c5-b872-eb5e802c6e46', '', 1.00, true, '2026-09-02 17:56:41.901+05:30', '2026-09-02 17:56:41.901+05:30', NULL, NULL, 1, NULL);
INSERT INTO public.recipes VALUES ('97517262-cc02-492b-a9ac-bc42bb784c9a', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'cdc12a71-3f32-4630-ab8b-059ae196af2c', '', 1.00, true, '2026-09-02 17:56:41.941+05:30', '2026-09-02 17:56:41.941+05:30', NULL, NULL, 1, NULL);


--
-- Data for Name: restaurant_tables; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'a25fd2be-6972-4e06-bfe7-32e1877b53c3', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'fd6326f7-7866-46ab-b23d-159edbf94a27', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '8b5689a3-0c2b-4cad-a66f-49e0ae75daf9', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '08a791ca-1ef7-4b29-98a6-f02820b2a2b3', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'efec4365-ca52-4d5a-bd0f-02eef073296e', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '3715b443-1ed9-4163-89bd-cf4fb359ceb3', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '618f709f-c32a-4e90-b129-3968ecf195b1', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '72282ca2-b8cc-4afb-b717-b5cef31b69eb', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'c892c4d5-644b-4853-83ee-f8dea5b6b952', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '61f8d56b-7d29-4b08-b728-55e1364ec396', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '50aecead-81be-4f41-b193-f4e8cc5f288d', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '7f18dc65-6e0a-467d-abe4-4f524b6e824e', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '5132d049-a00b-4489-9fad-2a55f51288ae', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '1be9c022-ee67-46c2-ad71-cb9b23573f78', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'a8cc5bc1-bd12-42f3-9a5d-48ae4eb968e0', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'bd09155b-91a2-4cd1-aa71-85a71bebb6be', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '5d67b45d-285b-4de3-9466-7cf7467066ff', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '00f5e8cd-1577-4986-8c2a-3ffafec22c25', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '2ab7f1c2-5fee-4861-bd89-0a1485df0ff4', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'd656bceb-ad28-4bdb-a4ce-361c02ebb2fe', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'aceee97c-05c1-481f-b853-e79678ec5fad', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '3bccf399-64ea-4574-904b-7db52741e624', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '99bf49fb-b3be-483b-b9dc-371f82b61227', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '3330a0b6-69a1-41eb-b880-0aabbc119e6d', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '38e7d69b-0ad9-4f4f-9802-634c46adf192', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'a6f18fbf-32ac-4ada-9e03-e7c86d19c110', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '694f4856-6a52-4c7e-a1d0-cd51f73d03bf', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '2c91df97-2384-4b82-b13f-43e6ca0c7a80', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'aeadb674-5e88-4c38-a97b-ee14bf4ff355', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '08ed13ed-85b5-4211-a02c-aab1539a566d', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '8871d288-9daa-4eb5-a117-b3df41e7f90f', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '0a410ae9-158a-4fd2-9a8a-767adad7438a', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'bd732c4a-9f28-4a9f-8351-67ea192e41e0', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'ce5bb0f0-2d74-4992-9112-c3731245eece', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'ef301064-b9ad-4a59-8734-738902495e39', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '6d0c2f3f-4963-4667-81bc-85f323c9dfd1', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '8fb93c32-2d85-4523-88e1-e9ab0a6ff005', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'a93fa551-c915-463e-9908-fb0019bd6f53', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'e3ee6f6b-7a52-4a46-960f-16a9e4566384', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '92830514-8a1a-4fb6-b402-7c9fb0e50f3d', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '6f91a8c7-45ec-4365-bb3a-e2b133543ebd', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '843937ff-2c69-4a15-9f3b-efb797479e75', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '35ba8ece-6851-43b4-bf0c-0a94c6da6a3b', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '8823c15e-ac5d-454a-bbe0-fe36d13b9fee', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '3848292e-d6da-42ed-8e23-bcacf351427c', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '57387649-ae7f-4746-8953-2d991f6c84ea', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '59a02a0a-a40e-47c8-a42a-b55e32e7a4b1', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '89b44b18-354b-4168-ba5d-76e949383a29', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '0ab3bfed-93a7-4ef2-8771-09ce18e9e806', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'c74767a0-3fcc-498c-b74f-372b455069bb', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'cef337ed-68b7-48c3-85be-937880107882', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', '6719b819-92e9-410c-a975-a26f5fcf744d', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'a975d9ea-ecfa-480b-89d2-908db5cc336a', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111102', 'c39074a4-72b7-4203-a00d-308c7cb97e9a', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'a25fd2be-6972-4e06-bfe7-32e1877b53c3', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'fd6326f7-7866-46ab-b23d-159edbf94a27', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '8b5689a3-0c2b-4cad-a66f-49e0ae75daf9', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '08a791ca-1ef7-4b29-98a6-f02820b2a2b3', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'efec4365-ca52-4d5a-bd0f-02eef073296e', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '3715b443-1ed9-4163-89bd-cf4fb359ceb3', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '618f709f-c32a-4e90-b129-3968ecf195b1', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '72282ca2-b8cc-4afb-b717-b5cef31b69eb', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'c892c4d5-644b-4853-83ee-f8dea5b6b952', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '61f8d56b-7d29-4b08-b728-55e1364ec396', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '50aecead-81be-4f41-b193-f4e8cc5f288d', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '7f18dc65-6e0a-467d-abe4-4f524b6e824e', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '5132d049-a00b-4489-9fad-2a55f51288ae', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '1be9c022-ee67-46c2-ad71-cb9b23573f78', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'a8cc5bc1-bd12-42f3-9a5d-48ae4eb968e0', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'bd09155b-91a2-4cd1-aa71-85a71bebb6be', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '5d67b45d-285b-4de3-9466-7cf7467066ff', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '00f5e8cd-1577-4986-8c2a-3ffafec22c25', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '2ab7f1c2-5fee-4861-bd89-0a1485df0ff4', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'd656bceb-ad28-4bdb-a4ce-361c02ebb2fe', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'aceee97c-05c1-481f-b853-e79678ec5fad', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '3bccf399-64ea-4574-904b-7db52741e624', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '99bf49fb-b3be-483b-b9dc-371f82b61227', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '3330a0b6-69a1-41eb-b880-0aabbc119e6d', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '38e7d69b-0ad9-4f4f-9802-634c46adf192', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'a6f18fbf-32ac-4ada-9e03-e7c86d19c110', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '694f4856-6a52-4c7e-a1d0-cd51f73d03bf', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '2c91df97-2384-4b82-b13f-43e6ca0c7a80', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'aeadb674-5e88-4c38-a97b-ee14bf4ff355', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '08ed13ed-85b5-4211-a02c-aab1539a566d', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '8871d288-9daa-4eb5-a117-b3df41e7f90f', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '0a410ae9-158a-4fd2-9a8a-767adad7438a', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'bd732c4a-9f28-4a9f-8351-67ea192e41e0', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'ce5bb0f0-2d74-4992-9112-c3731245eece', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'ef301064-b9ad-4a59-8734-738902495e39', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '6d0c2f3f-4963-4667-81bc-85f323c9dfd1', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '8fb93c32-2d85-4523-88e1-e9ab0a6ff005', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'a93fa551-c915-463e-9908-fb0019bd6f53', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'e3ee6f6b-7a52-4a46-960f-16a9e4566384', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '92830514-8a1a-4fb6-b402-7c9fb0e50f3d', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '6f91a8c7-45ec-4365-bb3a-e2b133543ebd', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '843937ff-2c69-4a15-9f3b-efb797479e75', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '35ba8ece-6851-43b4-bf0c-0a94c6da6a3b', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '8823c15e-ac5d-454a-bbe0-fe36d13b9fee', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '3848292e-d6da-42ed-8e23-bcacf351427c', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '57387649-ae7f-4746-8953-2d991f6c84ea', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '59a02a0a-a40e-47c8-a42a-b55e32e7a4b1', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '89b44b18-354b-4168-ba5d-76e949383a29', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '0ab3bfed-93a7-4ef2-8771-09ce18e9e806', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'c74767a0-3fcc-498c-b74f-372b455069bb', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'cef337ed-68b7-48c3-85be-937880107882', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', '6719b819-92e9-410c-a975-a26f5fcf744d', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'a975d9ea-ecfa-480b-89d2-908db5cc336a', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111101', 'c39074a4-72b7-4203-a00d-308c7cb97e9a', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'a25fd2be-6972-4e06-bfe7-32e1877b53c3', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'fd6326f7-7866-46ab-b23d-159edbf94a27', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '8b5689a3-0c2b-4cad-a66f-49e0ae75daf9', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '08a791ca-1ef7-4b29-98a6-f02820b2a2b3', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'efec4365-ca52-4d5a-bd0f-02eef073296e', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '3715b443-1ed9-4163-89bd-cf4fb359ceb3', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '618f709f-c32a-4e90-b129-3968ecf195b1', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '72282ca2-b8cc-4afb-b717-b5cef31b69eb', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'c892c4d5-644b-4853-83ee-f8dea5b6b952', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '61f8d56b-7d29-4b08-b728-55e1364ec396', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '50aecead-81be-4f41-b193-f4e8cc5f288d', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '7f18dc65-6e0a-467d-abe4-4f524b6e824e', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '5132d049-a00b-4489-9fad-2a55f51288ae', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '1be9c022-ee67-46c2-ad71-cb9b23573f78', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'a8cc5bc1-bd12-42f3-9a5d-48ae4eb968e0', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'bd09155b-91a2-4cd1-aa71-85a71bebb6be', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '5d67b45d-285b-4de3-9466-7cf7467066ff', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '00f5e8cd-1577-4986-8c2a-3ffafec22c25', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '2ab7f1c2-5fee-4861-bd89-0a1485df0ff4', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'd656bceb-ad28-4bdb-a4ce-361c02ebb2fe', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'aceee97c-05c1-481f-b853-e79678ec5fad', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '3bccf399-64ea-4574-904b-7db52741e624', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '99bf49fb-b3be-483b-b9dc-371f82b61227', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '3330a0b6-69a1-41eb-b880-0aabbc119e6d', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '38e7d69b-0ad9-4f4f-9802-634c46adf192', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'a6f18fbf-32ac-4ada-9e03-e7c86d19c110', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '694f4856-6a52-4c7e-a1d0-cd51f73d03bf', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '2c91df97-2384-4b82-b13f-43e6ca0c7a80', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'aeadb674-5e88-4c38-a97b-ee14bf4ff355', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '08ed13ed-85b5-4211-a02c-aab1539a566d', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '8871d288-9daa-4eb5-a117-b3df41e7f90f', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '0a410ae9-158a-4fd2-9a8a-767adad7438a', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'bd732c4a-9f28-4a9f-8351-67ea192e41e0', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'ce5bb0f0-2d74-4992-9112-c3731245eece', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'ef301064-b9ad-4a59-8734-738902495e39', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '6d0c2f3f-4963-4667-81bc-85f323c9dfd1', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '8fb93c32-2d85-4523-88e1-e9ab0a6ff005', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'a93fa551-c915-463e-9908-fb0019bd6f53', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'e3ee6f6b-7a52-4a46-960f-16a9e4566384', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '92830514-8a1a-4fb6-b402-7c9fb0e50f3d', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '6f91a8c7-45ec-4365-bb3a-e2b133543ebd', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '843937ff-2c69-4a15-9f3b-efb797479e75', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '35ba8ece-6851-43b4-bf0c-0a94c6da6a3b', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '8823c15e-ac5d-454a-bbe0-fe36d13b9fee', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '3848292e-d6da-42ed-8e23-bcacf351427c', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '57387649-ae7f-4746-8953-2d991f6c84ea', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '59a02a0a-a40e-47c8-a42a-b55e32e7a4b1', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '89b44b18-354b-4168-ba5d-76e949383a29', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '0ab3bfed-93a7-4ef2-8771-09ce18e9e806', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'c74767a0-3fcc-498c-b74f-372b455069bb', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'cef337ed-68b7-48c3-85be-937880107882', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', '6719b819-92e9-410c-a975-a26f5fcf744d', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'a975d9ea-ecfa-480b-89d2-908db5cc336a', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111103', 'c39074a4-72b7-4203-a00d-308c7cb97e9a', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', 'a25fd2be-6972-4e06-bfe7-32e1877b53c3', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', 'fd6326f7-7866-46ab-b23d-159edbf94a27', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '8b5689a3-0c2b-4cad-a66f-49e0ae75daf9', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '08a791ca-1ef7-4b29-98a6-f02820b2a2b3', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', 'efec4365-ca52-4d5a-bd0f-02eef073296e', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '3715b443-1ed9-4163-89bd-cf4fb359ceb3', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '618f709f-c32a-4e90-b129-3968ecf195b1', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '50aecead-81be-4f41-b193-f4e8cc5f288d', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '7f18dc65-6e0a-467d-abe4-4f524b6e824e', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', 'bd09155b-91a2-4cd1-aa71-85a71bebb6be', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '5d67b45d-285b-4de3-9466-7cf7467066ff', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '00f5e8cd-1577-4986-8c2a-3ffafec22c25', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '2ab7f1c2-5fee-4861-bd89-0a1485df0ff4', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', 'd656bceb-ad28-4bdb-a4ce-361c02ebb2fe', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', 'aceee97c-05c1-481f-b853-e79678ec5fad', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '3bccf399-64ea-4574-904b-7db52741e624', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '99bf49fb-b3be-483b-b9dc-371f82b61227', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', 'a6f18fbf-32ac-4ada-9e03-e7c86d19c110', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', 'ce5bb0f0-2d74-4992-9112-c3731245eece', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', 'a93fa551-c915-463e-9908-fb0019bd6f53', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', 'e3ee6f6b-7a52-4a46-960f-16a9e4566384', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '92830514-8a1a-4fb6-b402-7c9fb0e50f3d', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '6f91a8c7-45ec-4365-bb3a-e2b133543ebd', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '843937ff-2c69-4a15-9f3b-efb797479e75', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', '35ba8ece-6851-43b4-bf0c-0a94c6da6a3b', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111106', 'a25fd2be-6972-4e06-bfe7-32e1877b53c3', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111106', 'fd6326f7-7866-46ab-b23d-159edbf94a27', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111106', '8b5689a3-0c2b-4cad-a66f-49e0ae75daf9', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111106', '3715b443-1ed9-4163-89bd-cf4fb359ceb3', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111106', '618f709f-c32a-4e90-b129-3968ecf195b1', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111106', '50aecead-81be-4f41-b193-f4e8cc5f288d', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111106', '7f18dc65-6e0a-467d-abe4-4f524b6e824e', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111106', '5132d049-a00b-4489-9fad-2a55f51288ae', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111106', '99bf49fb-b3be-483b-b9dc-371f82b61227', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111105', '618f709f-c32a-4e90-b129-3968ecf195b1', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111105', '72282ca2-b8cc-4afb-b717-b5cef31b69eb', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111105', 'c892c4d5-644b-4853-83ee-f8dea5b6b952', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111105', '61f8d56b-7d29-4b08-b728-55e1364ec396', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111105', 'fd6326f7-7866-46ab-b23d-159edbf94a27', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111105', '99bf49fb-b3be-483b-b9dc-371f82b61227', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111107', 'fd6326f7-7866-46ab-b23d-159edbf94a27', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111107', '8b5689a3-0c2b-4cad-a66f-49e0ae75daf9', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111107', '618f709f-c32a-4e90-b129-3968ecf195b1', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111107', 'a975d9ea-ecfa-480b-89d2-908db5cc336a', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111107', '6719b819-92e9-410c-a975-a26f5fcf744d', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111107', '99bf49fb-b3be-483b-b9dc-371f82b61227', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111107', 'a6f18fbf-32ac-4ada-9e03-e7c86d19c110', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', '694f4856-6a52-4c7e-a1d0-cd51f73d03bf', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', '2c91df97-2384-4b82-b13f-43e6ca0c7a80', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', 'aeadb674-5e88-4c38-a97b-ee14bf4ff355', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', '08ed13ed-85b5-4211-a02c-aab1539a566d', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', '8871d288-9daa-4eb5-a117-b3df41e7f90f', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', '0a410ae9-158a-4fd2-9a8a-767adad7438a', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', 'bd732c4a-9f28-4a9f-8351-67ea192e41e0', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', '99bf49fb-b3be-483b-b9dc-371f82b61227', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', 'a6f18fbf-32ac-4ada-9e03-e7c86d19c110', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', 'ce5bb0f0-2d74-4992-9112-c3731245eece', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', 'ce5bb0f0-2d74-4992-9112-c3731245eece', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', 'ef301064-b9ad-4a59-8734-738902495e39', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', '6d0c2f3f-4963-4667-81bc-85f323c9dfd1', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', '8fb93c32-2d85-4523-88e1-e9ab0a6ff005', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', 'a93fa551-c915-463e-9908-fb0019bd6f53', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', 'e3ee6f6b-7a52-4a46-960f-16a9e4566384', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', '92830514-8a1a-4fb6-b402-7c9fb0e50f3d', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', '6f91a8c7-45ec-4365-bb3a-e2b133543ebd', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', 'c39074a4-72b7-4203-a00d-308c7cb97e9a', '2026-09-03 13:02:49.993506+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111104', 'a8cc5bc1-bd12-42f3-9a5d-48ae4eb968e0', '2026-09-03 13:35:45.039627+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111106', 'a8cc5bc1-bd12-42f3-9a5d-48ae4eb968e0', '2026-09-03 13:35:45.044389+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111105', 'a25fd2be-6972-4e06-bfe7-32e1877b53c3', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111105', '8b5689a3-0c2b-4cad-a66f-49e0ae75daf9', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111105', '08a791ca-1ef7-4b29-98a6-f02820b2a2b3', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111105', '3715b443-1ed9-4163-89bd-cf4fb359ceb3', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111105', 'bd09155b-91a2-4cd1-aa71-85a71bebb6be', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111105', '5d67b45d-285b-4de3-9466-7cf7467066ff', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111105', 'd656bceb-ad28-4bdb-a4ce-361c02ebb2fe', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111106', '08a791ca-1ef7-4b29-98a6-f02820b2a2b3', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111106', 'bd09155b-91a2-4cd1-aa71-85a71bebb6be', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111106', '5d67b45d-285b-4de3-9466-7cf7467066ff', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111106', 'd656bceb-ad28-4bdb-a4ce-361c02ebb2fe', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111107', 'a25fd2be-6972-4e06-bfe7-32e1877b53c3', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111107', '08a791ca-1ef7-4b29-98a6-f02820b2a2b3', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111107', '3715b443-1ed9-4163-89bd-cf4fb359ceb3', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111107', 'bd09155b-91a2-4cd1-aa71-85a71bebb6be', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111107', '5d67b45d-285b-4de3-9466-7cf7467066ff', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111107', 'd656bceb-ad28-4bdb-a4ce-361c02ebb2fe', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', 'a25fd2be-6972-4e06-bfe7-32e1877b53c3', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', 'fd6326f7-7866-46ab-b23d-159edbf94a27', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', '8b5689a3-0c2b-4cad-a66f-49e0ae75daf9', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', '08a791ca-1ef7-4b29-98a6-f02820b2a2b3', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', '3715b443-1ed9-4163-89bd-cf4fb359ceb3', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', '618f709f-c32a-4e90-b129-3968ecf195b1', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', 'bd09155b-91a2-4cd1-aa71-85a71bebb6be', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', '5d67b45d-285b-4de3-9466-7cf7467066ff', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', 'd656bceb-ad28-4bdb-a4ce-361c02ebb2fe', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', 'a25fd2be-6972-4e06-bfe7-32e1877b53c3', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', 'fd6326f7-7866-46ab-b23d-159edbf94a27', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', '8b5689a3-0c2b-4cad-a66f-49e0ae75daf9', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', '08a791ca-1ef7-4b29-98a6-f02820b2a2b3', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', '3715b443-1ed9-4163-89bd-cf4fb359ceb3', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', '618f709f-c32a-4e90-b129-3968ecf195b1', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', 'bd09155b-91a2-4cd1-aa71-85a71bebb6be', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', '5d67b45d-285b-4de3-9466-7cf7467066ff', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', 'd656bceb-ad28-4bdb-a4ce-361c02ebb2fe', '2026-09-05 16:41:12.987102+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111105', 'a8cc5bc1-bd12-42f3-9a5d-48ae4eb968e0', '2026-09-11 17:21:31.943+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111105', '50aecead-81be-4f41-b193-f4e8cc5f288d', '2026-09-11 17:21:31.96+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111107', 'a8cc5bc1-bd12-42f3-9a5d-48ae4eb968e0', '2026-09-11 17:21:31.967+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111107', '50aecead-81be-4f41-b193-f4e8cc5f288d', '2026-09-11 17:21:31.971+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', 'a8cc5bc1-bd12-42f3-9a5d-48ae4eb968e0', '2026-09-11 17:21:31.975+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111108', '50aecead-81be-4f41-b193-f4e8cc5f288d', '2026-09-11 17:21:31.979+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', 'a8cc5bc1-bd12-42f3-9a5d-48ae4eb968e0', '2026-09-11 17:21:31.982+05:30');
INSERT INTO public.role_permissions VALUES ('11111111-1111-1111-1111-111111111109', '50aecead-81be-4f41-b193-f4e8cc5f288d', '2026-09-11 17:21:31.986+05:30');


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.roles VALUES ('11111111-1111-1111-1111-111111111101', 'SUPER_ADMIN', 'SUPER_ADMIN', 'Super Administrator / System IT Admin', '2026-09-02 14:04:52.864637+05:30', '2026-09-02 14:04:52.864637+05:30', NULL, NULL);
INSERT INTO public.roles VALUES ('11111111-1111-1111-1111-111111111102', 'ADMIN', 'ADMIN', 'Administrator', '2026-09-02 14:04:52.864637+05:30', '2026-09-02 14:04:52.864637+05:30', NULL, NULL);
INSERT INTO public.roles VALUES ('11111111-1111-1111-1111-111111111103', 'OUTLET_MANAGER', 'OUTLET_MANAGER', 'Restaurant Manager / Outlet General Admin', '2026-09-02 14:04:52.864637+05:30', '2026-09-02 14:04:52.864637+05:30', NULL, NULL);
INSERT INTO public.roles VALUES ('11111111-1111-1111-1111-111111111104', 'CASHIER', 'CASHIER', 'Cashier / Front-Desk Biller / POS Operator', '2026-09-02 14:04:52.864637+05:30', '2026-09-02 14:04:52.864637+05:30', NULL, NULL);
INSERT INTO public.roles VALUES ('11111111-1111-1111-1111-111111111105', 'KITCHEN_USER', 'KITCHEN_USER', 'Kitchen Staff / Head Chef / KDS Display', '2026-09-02 14:04:52.864637+05:30', '2026-09-02 14:04:52.864637+05:30', NULL, NULL);
INSERT INTO public.roles VALUES ('11111111-1111-1111-1111-111111111106', 'WAITER', 'WAITER', 'Captain / Waiter / Table Steward', '2026-09-02 14:04:52.864637+05:30', '2026-09-02 14:04:52.864637+05:30', NULL, NULL);
INSERT INTO public.roles VALUES ('11111111-1111-1111-1111-111111111107', 'DELIVERY_MANAGER', 'DELIVERY_MANAGER', 'Online Aggregator & Dispatch Manager (Swiggy / Zomato)', '2026-09-03 12:05:42.962721+05:30', '2026-09-03 12:05:42.962721+05:30', NULL, NULL);
INSERT INTO public.roles VALUES ('11111111-1111-1111-1111-111111111108', 'INVENTORY_MANAGER', 'INVENTORY_MANAGER', 'Store & Inventory Manager', '2026-09-03 12:05:42.966966+05:30', '2026-09-03 12:05:42.966966+05:30', NULL, NULL);
INSERT INTO public.roles VALUES ('11111111-1111-1111-1111-111111111109', 'ACCOUNTANT', 'ACCOUNTANT', 'Accountant / Auditor / Financial Controller', '2026-09-03 12:05:42.967692+05:30', '2026-09-03 12:05:42.967692+05:30', NULL, NULL);


--
-- Data for Name: sales_returns; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.schema_migrations VALUES ('0001_extensions_and_enums.sql', '2026-09-02 14:04:49.256787+05:30');
INSERT INTO public.schema_migrations VALUES ('0001_init_identity_and_org.sql', '2026-09-02 14:04:49.717267+05:30');
INSERT INTO public.schema_migrations VALUES ('0002_catalog.sql', '2026-09-02 14:04:50.022369+05:30');
INSERT INTO public.schema_migrations VALUES ('0002_create_users.sql', '2026-09-02 14:04:50.027569+05:30');
INSERT INTO public.schema_migrations VALUES ('0003_create_outlets.sql', '2026-09-02 14:04:50.03157+05:30');
INSERT INTO public.schema_migrations VALUES ('0003_pricing_and_tax.sql', '2026-09-02 14:04:50.094296+05:30');
INSERT INTO public.schema_migrations VALUES ('0004_create_tables_and_sessions.sql', '2026-09-02 14:04:50.204108+05:30');
INSERT INTO public.schema_migrations VALUES ('0004_orders.sql', '2026-09-02 14:04:50.418975+05:30');
INSERT INTO public.schema_migrations VALUES ('0005_create_menu_categories_and_items.sql', '2026-09-02 14:04:50.455639+05:30');
INSERT INTO public.schema_migrations VALUES ('0005_kitchen.sql', '2026-09-02 14:04:50.566613+05:30');
INSERT INTO public.schema_migrations VALUES ('0006_create_menu_item_channel_and_availability.sql', '2026-09-02 14:04:50.630694+05:30');
INSERT INTO public.schema_migrations VALUES ('0006_customers.sql', '2026-09-02 14:04:50.744986+05:30');
INSERT INTO public.schema_migrations VALUES ('0007_create_taxes.sql', '2026-09-02 14:04:50.821837+05:30');
INSERT INTO public.schema_migrations VALUES ('0007_integration.sql', '2026-09-02 14:04:50.9825+05:30');
INSERT INTO public.schema_migrations VALUES ('0008_audit.sql', '2026-09-02 14:04:51.069623+05:30');
INSERT INTO public.schema_migrations VALUES ('0008_create_payment_type_master.sql', '2026-09-02 14:04:51.110619+05:30');
INSERT INTO public.schema_migrations VALUES ('0009_create_orders_and_order_items.sql', '2026-09-02 14:04:51.11454+05:30');
INSERT INTO public.schema_migrations VALUES ('0009_reporting.sql', '2026-09-02 14:04:51.269838+05:30');
INSERT INTO public.schema_migrations VALUES ('0010_create_order_payments.sql', '2026-09-02 14:04:51.273047+05:30');
INSERT INTO public.schema_migrations VALUES ('0011_create_order_audit_log.sql', '2026-09-02 14:04:51.320664+05:30');
INSERT INTO public.schema_migrations VALUES ('0012_create_sales_returns.sql', '2026-09-02 14:04:51.373699+05:30');
INSERT INTO public.schema_migrations VALUES ('0013_create_outlet_billing_and_print_settings.sql', '2026-09-02 14:04:51.419331+05:30');
INSERT INTO public.schema_migrations VALUES ('0014_create_sync_backup_channel_log.sql', '2026-09-02 14:04:51.528414+05:30');
INSERT INTO public.schema_migrations VALUES ('0015_create_user_report_preferences.sql', '2026-09-02 14:04:51.568245+05:30');
INSERT INTO public.schema_migrations VALUES ('0016_extend_outlet_settings_jsonb.sql', '2026-09-02 14:04:51.572093+05:30');
INSERT INTO public.schema_migrations VALUES ('0017_add_stock_to_item_availability', '2026-09-02 14:04:51.573664+05:30');
INSERT INTO public.schema_migrations VALUES ('0017_add_stock_to_item_availability.sql', '2026-09-02 14:04:51.579503+05:30');
INSERT INTO public.schema_migrations VALUES ('0017_payment_idempotency.sql', '2026-09-02 14:04:51.608764+05:30');
INSERT INTO public.schema_migrations VALUES ('0018_create_inventory_tables', '2026-09-02 14:04:51.610256+05:30');
INSERT INTO public.schema_migrations VALUES ('0018_create_inventory_tables.sql', '2026-09-02 14:04:51.729873+05:30');
INSERT INTO public.schema_migrations VALUES ('0019_add_channel_item_mapping_version', '2026-09-02 14:04:51.73122+05:30');
INSERT INTO public.schema_migrations VALUES ('0019_add_channel_item_mapping_version.sql', '2026-09-02 14:04:51.736471+05:30');
INSERT INTO public.schema_migrations VALUES ('0020_create_finance_ledger_tables', '2026-09-02 14:04:51.737836+05:30');
INSERT INTO public.schema_migrations VALUES ('0020_create_finance_ledger_tables.sql', '2026-09-02 14:04:51.796506+05:30');
INSERT INTO public.schema_migrations VALUES ('0021_add_outlet_status', '2026-09-02 14:04:51.79806+05:30');
INSERT INTO public.schema_migrations VALUES ('0021_add_outlet_status.sql', '2026-09-02 14:04:51.806178+05:30');
INSERT INTO public.schema_migrations VALUES ('0022_admin_pipeline_tables', '2026-09-02 14:04:51.8082+05:30');
INSERT INTO public.schema_migrations VALUES ('0022_admin_pipeline_tables.sql', '2026-09-02 14:04:51.898313+05:30');
INSERT INTO public.schema_migrations VALUES ('0023_order_charges_and_waiter_handovers.sql', '2026-09-02 14:04:51.929412+05:30');
INSERT INTO public.schema_migrations VALUES ('0024_table_merge_groups.sql', '2026-09-02 14:04:51.946353+05:30');
INSERT INTO public.schema_migrations VALUES ('0025_modifier_options_and_menu_crud.sql', '2026-09-02 14:04:51.973476+05:30');
INSERT INTO public.schema_migrations VALUES ('0026_special_notes.sql', '2026-09-02 14:04:52.000076+05:30');
INSERT INTO public.schema_migrations VALUES ('0027_areas.sql', '2026-09-02 14:04:52.03891+05:30');
INSERT INTO public.schema_migrations VALUES ('0028_seat_and_merge_enums.sql', '2026-09-02 14:04:52.042757+05:30');
INSERT INTO public.schema_migrations VALUES ('0029_table_merge_groups_and_members.sql', '2026-09-02 14:04:52.11481+05:30');
INSERT INTO public.schema_migrations VALUES ('0030_table_seats.sql', '2026-09-02 14:04:52.149911+05:30');
INSERT INTO public.schema_migrations VALUES ('0031_order_and_order_item_seat_columns.sql', '2026-09-02 14:04:52.17838+05:30');
INSERT INTO public.schema_migrations VALUES ('0032_order_seat_bills.sql', '2026-09-02 14:04:52.21967+05:30');
INSERT INTO public.schema_migrations VALUES ('0033_order_item_seat_shares.sql', '2026-09-02 14:04:52.250021+05:30');
INSERT INTO public.schema_migrations VALUES ('0034_kot_items_outlet_and_seat.sql', '2026-09-02 14:04:52.272663+05:30');
INSERT INTO public.schema_migrations VALUES ('0035_payments_seat_columns.sql', '2026-09-02 14:04:52.28497+05:30');
INSERT INTO public.schema_migrations VALUES ('0036_invoices_per_seat_unique.sql', '2026-09-02 14:04:52.304434+05:30');
INSERT INTO public.schema_migrations VALUES ('0037_table_merge_idempotency.sql', '2026-09-02 14:04:52.326488+05:30');
INSERT INTO public.schema_migrations VALUES ('0038_outlet_contact_and_logo.sql', '2026-09-02 14:04:52.329768+05:30');
INSERT INTO public.schema_migrations VALUES ('0039_online_orders_round_off_and_kot_bill_print.sql', '2026-09-02 14:04:52.35758+05:30');
INSERT INTO public.schema_migrations VALUES ('0040_menu_commission_physical_scheduling.sql', '2026-09-02 14:04:52.448227+05:30');
INSERT INTO public.schema_migrations VALUES ('0041_agent_telemetry.sql', '2026-09-03 14:05:27.54061+05:30');
INSERT INTO public.schema_migrations VALUES ('0042_invoices_amount_and_sync.sql', '2026-09-05 13:08:36.669153+05:30');


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.sessions VALUES ('5fa45a07-0230-4110-bbb5-7128adf8f3c4', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-03 14:05:52.182+05:30', NULL, '2026-09-03 14:05:52.195+05:30', '11111111-1111-1111-1111-111111111111', '76d05a53af4143be258b074d1b56d1c3e6f0176af6d799f13f49bd7c8387863d', '2026-09-03 14:05:54.048+05:30', NULL);
INSERT INTO public.sessions VALUES ('2dad0944-5779-45d1-bb26-9367cf0f9188', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-03 16:46:49.643+05:30', NULL, '2026-09-03 16:46:49.645+05:30', '11111111-1111-1111-1111-111111111111', 'ac32275734741e536080d33bd457fda3de14c96bdb629f68e73a385ad89b2d51', '2026-09-03 16:46:49.645+05:30', NULL);
INSERT INTO public.sessions VALUES ('99b18d24-d5c3-462b-b6ae-6a1c12a6c413', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-03 14:07:00.25+05:30', NULL, '2026-09-03 14:07:00.261+05:30', '11111111-1111-1111-1111-111111111111', '7b41fba424b8b0092f549d850e5ebbeb1df964a0e3685abc20bd82b6946f7b84', '2026-09-03 14:07:16.404+05:30', NULL);
INSERT INTO public.sessions VALUES ('7147efb7-f760-4be0-b058-ab2fa48044fc', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-03 14:19:54.244+05:30', NULL, '2026-09-03 14:19:54.247+05:30', '11111111-1111-1111-1111-111111111111', '5a8769ddeac167ecb80b9e92bfda41de05bc1ec6813192add1de26c50ab589ba', '2026-09-03 14:19:54.247+05:30', NULL);
INSERT INTO public.sessions VALUES ('3527aeef-14e9-41f5-88ae-15333619ed0a', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-03 14:21:16.08+05:30', NULL, '2026-09-03 14:21:16.082+05:30', '11111111-1111-1111-1111-111111111111', 'c0ad4eb8f8d5978d6bc19efe8e2900af2fedcd7897ffd25eb9ae2b3930c8c330', '2026-09-03 14:21:16.082+05:30', NULL);
INSERT INTO public.sessions VALUES ('f0d184a4-63df-4564-a1ce-654e880748d0', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-03 14:23:45.962+05:30', NULL, '2026-09-03 14:23:45.964+05:30', '11111111-1111-1111-1111-111111111111', '72b622b220e6c2e870bbcf19b304be4245ebab361d8456ae9b8df243e0ad9869', '2026-09-03 14:23:45.964+05:30', NULL);
INSERT INTO public.sessions VALUES ('4016f0bf-9fbb-44f8-8436-dd163fcc377f', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-03 14:25:13.081+05:30', NULL, '2026-09-03 14:25:13.082+05:30', '11111111-1111-1111-1111-111111111111', '1458df18789d2301ef74f74c8e9fe2a7d5ac605c07092bd07fa05c61866b090f', '2026-09-03 14:25:15.371+05:30', NULL);
INSERT INTO public.sessions VALUES ('1c846d6a-3a0d-4d49-b6e0-4b4bedc47fc9', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-03 17:22:49.317+05:30', NULL, '2026-09-03 17:22:49.318+05:30', '11111111-1111-1111-1111-111111111111', '084932e9dac133d92dfd242dc61e81db832cc317286167031907492a34c64e1b', '2026-09-03 17:22:49.318+05:30', NULL);
INSERT INTO public.sessions VALUES ('937a9194-2d45-492f-80a0-32575f9422f7', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL, '2026-10-03 14:50:54.698+05:30', NULL, '2026-09-03 14:50:54.7+05:30', '11111111-1111-1111-1111-111111111111', '26b530ec224b2587234fd2cc1536e39222f1d1bedba8ae284be4278f69de5fd2', '2026-09-03 15:02:01.157+05:30', NULL);
INSERT INTO public.sessions VALUES ('823539b6-ce64-420c-9a93-fc96dcee0a2a', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-03 14:25:29.827+05:30', NULL, '2026-09-03 14:25:29.828+05:30', '11111111-1111-1111-1111-111111111111', '84b0aed4fb256e1d0d938a406eaaa638e83c9bc0bdf709fb89674141dec815cf', '2026-09-03 14:26:16.172+05:30', NULL);
INSERT INTO public.sessions VALUES ('4ec07cb9-2eb9-459a-b71d-53871f24788e', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-03 15:07:36.387+05:30', NULL, '2026-09-03 15:07:36.389+05:30', '11111111-1111-1111-1111-111111111111', '5e00b5de5352f592b2e5ee355a5319f4157ae690444080fe9b635c437e53d33c', '2026-09-03 15:07:36.389+05:30', NULL);
INSERT INTO public.sessions VALUES ('2b533db7-4b4b-4d52-bcf6-687638d4280c', '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL, '2026-10-03 14:26:19.185+05:30', NULL, '2026-09-03 14:26:19.191+05:30', '11111111-1111-1111-1111-111111111111', '23952099cc8969d4a41858269a6d1fd104239e9accb173723b8f6d86222b1256', '2026-09-03 14:26:45.701+05:30', NULL);
INSERT INTO public.sessions VALUES ('aad0e740-31b1-4f1b-ae2a-a0ed6f54ad8e', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-03 17:23:07.314+05:30', NULL, '2026-09-03 17:23:07.315+05:30', '11111111-1111-1111-1111-111111111111', '943c5c9a2a2b1206598ec3bafb1cc8cc6b5669f3ca301b6b3df828dcdc531d73', '2026-09-03 17:23:07.315+05:30', NULL);
INSERT INTO public.sessions VALUES ('f77a41c2-8df1-4070-b2ee-5fc7a889b0cb', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-03 17:25:31.069+05:30', NULL, '2026-09-03 17:25:31.07+05:30', '11111111-1111-1111-1111-111111111111', '1e47ff064db02f5239fdf2296b222e62349a7e1e775687c67b6ec760e43aff2e', '2026-09-03 17:25:31.07+05:30', NULL);
INSERT INTO public.sessions VALUES ('cc8432c4-aa17-4df1-8c2e-9fd0d8f46727', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL, '2026-10-03 15:02:08.757+05:30', NULL, '2026-09-03 15:02:08.758+05:30', '11111111-1111-1111-1111-111111111111', '025b2bcf118ebe1d0db2cd35cd9455597a09d490f04bce0401cf8e4d696f601b', '2026-09-03 15:03:00.783+05:30', NULL);
INSERT INTO public.sessions VALUES ('9d953229-667e-43d7-892d-17126299e6c0', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-03 17:25:55.077+05:30', NULL, '2026-09-03 17:25:55.078+05:30', '11111111-1111-1111-1111-111111111111', '42b011ea5ef85fc2bcf4b1f99fa755c42ef827e4d4ef70a74e88cbab2fb81920', '2026-09-03 17:25:55.078+05:30', NULL);
INSERT INTO public.sessions VALUES ('ea1f1318-7354-4338-b27e-946472055406', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL, '2026-10-03 15:03:11.149+05:30', NULL, '2026-09-03 15:03:11.15+05:30', '11111111-1111-1111-1111-111111111111', 'b1f56e592762f1e3e0979c5bd15250f8aefeec19ab2120f622f6b9a8b5657992', '2026-09-03 15:03:31.16+05:30', NULL);
INSERT INTO public.sessions VALUES ('c6a1989e-5adf-4343-a2f7-c8c3dd047241', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-03 17:33:16.392+05:30', NULL, '2026-09-03 17:33:16.396+05:30', '11111111-1111-1111-1111-111111111111', 'ce6cc7e2592b5846c6e551a0de35c70d7ddf4057bad10414a41934d91452e171', '2026-09-03 17:33:16.396+05:30', NULL);
INSERT INTO public.sessions VALUES ('1a73a0ca-091f-42f1-baa9-146ddcd14b70', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-03 17:33:31.981+05:30', NULL, '2026-09-03 17:33:31.983+05:30', '11111111-1111-1111-1111-111111111111', 'a3518a1d89537baccac384b7e069f919c91148068106f3f5a95be3c42dc21ecf', '2026-09-03 17:33:31.983+05:30', NULL);
INSERT INTO public.sessions VALUES ('057604c0-7fee-44e4-b8f0-77ad26767436', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-03 15:12:53.954+05:30', NULL, '2026-09-03 15:12:53.957+05:30', '11111111-1111-1111-1111-111111111111', '986f95fbf5a2b3ba806e26b99525471241812c7435dc2fb0c3ecb0ed873002e6', '2026-09-03 15:12:53.957+05:30', NULL);
INSERT INTO public.sessions VALUES ('7e7f7c37-8ea6-416b-8442-606df455a429', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL, '2026-10-03 14:46:46.785+05:30', NULL, '2026-09-03 14:46:46.791+05:30', '11111111-1111-1111-1111-111111111111', '494f20e820021d44d399c3d622a2e344b41904d1febb6e0c5a0cda488da30a7c', '2026-09-03 14:50:46.156+05:30', NULL);
INSERT INTO public.sessions VALUES ('6bdd0b0c-7ef4-400f-a916-2e9cc633f9a9', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL, '2026-10-03 14:26:50.393+05:30', NULL, '2026-09-03 14:26:50.399+05:30', '11111111-1111-1111-1111-111111111111', '4f4549a6b0bf6db9d6236ac899889cb3a646b43e19a7b251050573c4e7c04c57', '2026-09-03 14:41:42.037+05:30', NULL);
INSERT INTO public.sessions VALUES ('49b46afa-91af-4895-9fd5-f113c52fc38d', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-03 14:43:14.68+05:30', NULL, '2026-09-03 14:43:14.688+05:30', '11111111-1111-1111-1111-111111111111', '8bac744a0d6daeaa1f89d06563d9227ac118288946958a7f5ba4b7a4aa1f255d', '2026-09-03 14:43:14.688+05:30', NULL);
INSERT INTO public.sessions VALUES ('b37fbcdb-bb70-489d-995b-0650edb03ac8', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-03 14:43:30.733+05:30', NULL, '2026-09-03 14:43:30.742+05:30', '11111111-1111-1111-1111-111111111111', 'ba15c9fd39c79920af02e37972ed71026b84be8a9989ed66744868ca38fc2fbe', '2026-09-03 14:43:30.742+05:30', NULL);
INSERT INTO public.sessions VALUES ('d045cd61-5c3c-4b90-a357-cb5034a5a10f', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-03 14:43:47.774+05:30', NULL, '2026-09-03 14:43:47.783+05:30', '11111111-1111-1111-1111-111111111111', 'bb10b9bd3554c3310e06e694bfb28ca3acb7afdaac4d7d3b11fd62af91f323a1', '2026-09-03 14:43:47.783+05:30', NULL);
INSERT INTO public.sessions VALUES ('dc0e00d4-8399-4fde-8eba-948fefb45bf9', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-04 00:40:09.428+05:30', NULL, '2026-09-04 00:40:09.43+05:30', '11111111-1111-1111-1111-111111111111', '57d34f3f3a63cbd5b1662b80f254688299c5bf202b90b33af3486275b042e465', '2026-09-04 00:42:26.47+05:30', NULL);
INSERT INTO public.sessions VALUES ('98598270-ef22-4af4-8bfe-33dd83e3a3f6', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-04 01:14:36.356+05:30', NULL, '2026-09-04 01:14:36.357+05:30', '11111111-1111-1111-1111-111111111111', '708c5255962e7c700388096738db3e3cc599c5ebc964c018042e685f3367bb31', '2026-09-04 01:16:37.379+05:30', NULL);
INSERT INTO public.sessions VALUES ('49691edf-45cd-4d0d-85e5-38415d431cd8', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-03 15:16:22.544+05:30', NULL, '2026-09-03 15:16:22.547+05:30', '11111111-1111-1111-1111-111111111111', 'e5c40dcdf0393423e3825f8a3e7d9e68d0b36237987153e503bb505d20f4afe8', '2026-09-03 15:16:22.547+05:30', NULL);
INSERT INTO public.sessions VALUES ('1a84039c-2446-4ccc-b32c-3ee592832e1a', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL, '2026-10-04 01:05:03.431+05:30', NULL, '2026-09-04 01:05:03.433+05:30', '11111111-1111-1111-1111-111111111111', 'ab25c1d44813d48608281aadb9ab6c1e42f1ce7d762bc6ff7aa4482eedb7c041', '2026-09-04 01:05:24.477+05:30', NULL);
INSERT INTO public.sessions VALUES ('b5a9f9d2-1d9f-44f3-82c1-9a58377fba30', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-03 14:44:45.873+05:30', NULL, '2026-09-03 14:44:45.875+05:30', '11111111-1111-1111-1111-111111111111', 'fedb22e79f4a0817987a86b23f2b81c734d8ddcbea7d7c3225f516b024f20444', '2026-09-03 14:45:46.873+05:30', NULL);
INSERT INTO public.sessions VALUES ('8b339c84-947e-4c0d-9955-a0ce52d13c99', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-03 15:17:01.218+05:30', NULL, '2026-09-03 15:17:01.219+05:30', '11111111-1111-1111-1111-111111111111', '9757cfbc5b4b02d14c01cfb1c83b23bcf325b9418c9a608d82ac7437ce3efd42', '2026-09-03 15:17:01.219+05:30', NULL);
INSERT INTO public.sessions VALUES ('92fbd67d-1950-4a3e-a108-65c6e238d596', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-03 15:17:20.097+05:30', NULL, '2026-09-03 15:17:20.099+05:30', '11111111-1111-1111-1111-111111111111', 'b99a2c517c01bd4ace3f819cb932fda9a8c2ae81e84663562ad69c198d0cbfff', '2026-09-03 15:17:20.099+05:30', NULL);
INSERT INTO public.sessions VALUES ('eec02159-77f3-414d-890a-932b326a23d8', '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL, '2026-10-03 14:45:56.331+05:30', NULL, '2026-09-03 14:45:56.337+05:30', '11111111-1111-1111-1111-111111111111', 'a4a118fc57cbfd802255119e6cb35a9a5d271b1f5117bc88d8277063b80498eb', '2026-09-03 14:46:32.162+05:30', NULL);
INSERT INTO public.sessions VALUES ('942cfb78-5fa1-47d5-bf80-a96ad9e219c0', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-04 00:02:07.499+05:30', NULL, '2026-09-04 00:02:07.501+05:30', '11111111-1111-1111-1111-111111111111', '643dbc025c536306c2a069aab6b50033d406b26893b9ab4f3489cd1ffc19edaf', '2026-09-04 00:16:11.474+05:30', NULL);
INSERT INTO public.sessions VALUES ('2e4b6f14-a7cd-4176-b122-cba5eb7c4efd', '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL, '2026-10-04 00:42:40.637+05:30', NULL, '2026-09-04 00:42:40.64+05:30', '11111111-1111-1111-1111-111111111111', '209806089dd07e9c672c08fabc9cc1a9cf50784a454cbb86b35f8401996cb424', '2026-09-04 00:47:13.341+05:30', NULL);
INSERT INTO public.sessions VALUES ('7f7813d7-2426-40f3-8715-84120101fb5d', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL, '2026-10-03 15:03:38.892+05:30', NULL, '2026-09-03 15:03:38.894+05:30', '11111111-1111-1111-1111-111111111111', '8bb1b6ced2f81f8e769f2479f16820f45c7fac6c920944fa5f98bca440ac7b83', '2026-09-03 15:18:30.784+05:30', NULL);
INSERT INTO public.sessions VALUES ('c9ce761a-5c2f-4293-a0d7-3b0132cba78d', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-03 16:46:24.179+05:30', NULL, '2026-09-03 16:46:24.181+05:30', '11111111-1111-1111-1111-111111111111', 'd9565eeffd962c3530d1fb94bcdf61496d0f5405192d22d08bf1e30ea268d620', '2026-09-03 16:46:24.181+05:30', NULL);
INSERT INTO public.sessions VALUES ('bce3c8c2-48a2-4fee-8530-1f09d7c99dd7', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-04 01:04:23.346+05:30', NULL, '2026-09-04 01:04:23.347+05:30', '11111111-1111-1111-1111-111111111111', 'bf562d0deadba6bc19b809716f520b6ca6ac2a6f579afa76d4049805f609d637', '2026-09-04 01:04:54.919+05:30', NULL);
INSERT INTO public.sessions VALUES ('4883bb4b-b6e0-4ebc-b4e0-7ac02883194d', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-04 01:03:40.091+05:30', NULL, '2026-09-04 01:03:40.092+05:30', '11111111-1111-1111-1111-111111111111', 'c889f9c915bb2490e4d196d1f44ac2a96b7feaebd59b631bef7837c371bda72e', '2026-09-04 01:03:56.02+05:30', NULL);
INSERT INTO public.sessions VALUES ('4aed7257-79b5-40ba-8130-8a1e63b4e753', '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL, '2026-10-04 01:05:34.062+05:30', NULL, '2026-09-04 01:05:34.064+05:30', '11111111-1111-1111-1111-111111111111', '29dea08a8f1ce9537a3d720d7685b869df97d0eb7adffead1d9eeae4175880ff', '2026-09-04 01:13:09.321+05:30', NULL);
INSERT INTO public.sessions VALUES ('f2d300e8-04e8-4d9f-ac7e-3a9274034823', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-05 13:18:46.479+05:30', NULL, '2026-09-05 13:18:46.482+05:30', '11111111-1111-1111-1111-111111111111', 'ff7b0cd2c5a90d72da8d5c29d6e2ec6ff1fe722d9f79d6653f1b322d9e62987e', '2026-09-05 13:33:34.015+05:30', NULL);
INSERT INTO public.sessions VALUES ('71069b32-9db5-40e7-a374-5691f9f41508', '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL, '2026-10-05 13:20:23.147+05:30', NULL, '2026-09-05 13:20:23.152+05:30', '11111111-1111-1111-1111-111111111111', '6f05d5f47140f33cdd3aac9cdf943a4134a82c27d886765c594c877a372526ea', '2026-09-05 13:20:23.152+05:30', NULL);
INSERT INTO public.sessions VALUES ('2b3e783e-9afb-4fe4-856c-ad20f817b3c8', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL, '2026-10-05 13:21:32.579+05:30', NULL, '2026-09-05 13:21:32.583+05:30', '11111111-1111-1111-1111-111111111111', 'a32638ca6278d08deff8c4da5a0c10ffc57ddd0e307e42f58006fe95610b0036', '2026-09-05 13:21:32.583+05:30', NULL);
INSERT INTO public.sessions VALUES ('55dfceca-3fc8-4a29-a778-b2f26cdf77ef', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-08 13:11:22.467+05:30', NULL, '2026-09-08 13:11:22.471+05:30', '11111111-1111-1111-1111-111111111111', 'd63994fb4daf1eb2470fb16d6a6f7764856c051c62fae92597bbd0e3e89e6a5a', '2026-09-08 13:14:29.242+05:30', NULL);
INSERT INTO public.sessions VALUES ('ac85c225-9aff-4d61-8a43-5d38743ac8ad', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-05 16:52:29.078+05:30', NULL, '2026-09-05 16:52:29.08+05:30', '11111111-1111-1111-1111-111111111111', 'a9ac4c58c9cb885ed92ce6c71e715cfbd87411e16ed0d8796180cbb9eaf35cb4', '2026-09-05 17:07:20.711+05:30', NULL);
INSERT INTO public.sessions VALUES ('105e29dd-ea1b-4d67-ac63-3d2325ee045c', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-05 14:43:23.405+05:30', NULL, '2026-09-05 14:43:23.407+05:30', '67315042-c687-4cbb-b45a-f4ea4efc199f', '152c1c0ba9234f364694c06b2b14c1dd2ef18cc2931e21826a8d440886746052', '2026-09-05 14:43:23.407+05:30', NULL);
INSERT INTO public.sessions VALUES ('7e21a9a9-6b7d-4929-a352-8c6b0db14340', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL, '2026-10-05 17:12:04.479+05:30', NULL, '2026-09-05 17:12:04.481+05:30', '11111111-1111-1111-1111-111111111111', '2025f89e0f4d5a54f6cb65cbe635a757ed3ab0b9a9661666bd0c76e7262cf830', '2026-09-05 17:12:04.481+05:30', NULL);
INSERT INTO public.sessions VALUES ('701ed539-00bc-4996-aaef-7122bba238bd', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-05 14:43:37.38+05:30', NULL, '2026-09-05 14:43:37.389+05:30', '11111111-1111-1111-1111-111111111111', 'c06b044889a51c21e1340e81de52051702ed2621e751d10fc46bab83d6095d99', '2026-09-05 14:43:37.389+05:30', NULL);
INSERT INTO public.sessions VALUES ('d00184d9-0267-45ce-bab8-5ee96c92f249', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-05 14:43:50.799+05:30', NULL, '2026-09-05 14:43:50.808+05:30', '11111111-1111-1111-1111-111111111111', 'e12495823f22618a759ed13cdaaba1d50ad1e121548649fe2ef18b32f2fceffb', '2026-09-05 14:43:50.808+05:30', NULL);
INSERT INTO public.sessions VALUES ('0bb430a3-225b-4cd9-8807-d1bec1c2e1e0', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-05 14:44:15.251+05:30', NULL, '2026-09-05 14:44:15.26+05:30', '11111111-1111-1111-1111-111111111111', 'd08864add7ca99108c18d49b51efdc491f68d56fdb2c3b4ee78354d4e1b89ff7', '2026-09-05 14:44:15.26+05:30', NULL);
INSERT INTO public.sessions VALUES ('c74408e8-f554-4c81-819b-7e5fc6ca99c0', '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL, '2026-10-05 17:15:17.121+05:30', NULL, '2026-09-05 17:15:17.123+05:30', '11111111-1111-1111-1111-111111111111', '871f618b140348388ca95e2ce856457da40cb28bc9389ad599f8db07aaeddec6', '2026-09-05 17:15:17.123+05:30', NULL);
INSERT INTO public.sessions VALUES ('d50b57a2-e88c-4ee1-8875-403a44c7cb81', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-05 14:49:26.84+05:30', NULL, '2026-09-05 14:49:26.846+05:30', '11111111-1111-1111-1111-111111111111', 'e318f2c798bf4dd98f4184a8a20cf88b58775fd63d4ba079ac7da04adb6facd3', '2026-09-05 15:04:25.174+05:30', NULL);
INSERT INTO public.sessions VALUES ('8c953cd7-68a5-4261-861b-12586be0108e', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL, '2026-10-05 15:04:43.211+05:30', NULL, '2026-09-05 15:04:43.213+05:30', '11111111-1111-1111-1111-111111111111', '83da13b5094c07fb8efc10e5105660effa26eafe4a5c0c1605274944a1697861', '2026-09-05 15:04:43.213+05:30', NULL);
INSERT INTO public.sessions VALUES ('103134fc-5ccc-4a4b-ae75-422d26be4291', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL, '2026-10-05 15:07:43.056+05:30', NULL, '2026-09-05 15:07:43.057+05:30', '11111111-1111-1111-1111-111111111111', 'c02ed867e9a1754a8a321db907987eeb2741a3b702fd47755404df9980fdf2e1', '2026-09-05 15:09:31.66+05:30', NULL);
INSERT INTO public.sessions VALUES ('ae8f2bfb-2cf9-4b2d-bf8c-6325f29f1e06', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL, '2026-10-05 16:19:30.974+05:30', NULL, '2026-09-05 16:19:30.975+05:30', '11111111-1111-1111-1111-111111111111', '88b5448dc5b85aea27997f7db05508489f27cd2eca5cfa87a8387fc1fb4dacf0', '2026-09-05 16:19:30.975+05:30', NULL);
INSERT INTO public.sessions VALUES ('5f4763a2-84b2-4730-a959-f335c4c17308', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL, '2026-10-05 16:20:49.499+05:30', NULL, '2026-09-05 16:20:49.501+05:30', '11111111-1111-1111-1111-111111111111', '7d3fc452009d89ebc659e0780b9bdef2ab9ab78a9c2073f4fb865f59444df09a', '2026-09-05 16:20:49.501+05:30', NULL);
INSERT INTO public.sessions VALUES ('0545bddc-389c-4b97-ac7f-24e32f72460c', '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL, '2026-10-05 16:23:02.469+05:30', NULL, '2026-09-05 16:23:02.471+05:30', '11111111-1111-1111-1111-111111111111', '2b940bb6968ecfede68b46339279e209f410d945c7a8e1f8c82e99cd223b3a95', '2026-09-05 16:23:02.471+05:30', NULL);
INSERT INTO public.sessions VALUES ('b519f8c7-51bd-474b-afae-3401dc813a57', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL, '2026-10-05 16:49:25.858+05:30', NULL, '2026-09-05 16:49:25.86+05:30', '11111111-1111-1111-1111-111111111111', 'ab67dc88d27d613e051087d8f4a2637e978d9dd9253d2b9ca1ac6766c802c400', '2026-09-05 16:49:25.86+05:30', NULL);
INSERT INTO public.sessions VALUES ('b1944422-0496-4fcd-8907-9851062e5ad4', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL, '2026-10-05 16:52:03.79+05:30', NULL, '2026-09-05 16:52:03.791+05:30', '11111111-1111-1111-1111-111111111111', 'a7e0c3e3b756a038fbdbb0bd8de203d628b2b870974bf49320bcb0aa1478383e', '2026-09-05 16:52:03.791+05:30', NULL);
INSERT INTO public.sessions VALUES ('1dc910a7-86d6-49c2-9137-8269d5235433', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-08 11:14:44.941+05:30', NULL, '2026-09-08 11:14:44.943+05:30', '11111111-1111-1111-1111-111111111111', '470a63f59778f99676f2096ab980f690498b73fb0edcd5b98e40b69bd46074ae', '2026-09-08 11:29:30.943+05:30', NULL);
INSERT INTO public.sessions VALUES ('9dd8c453-3c74-47d3-97d0-23d689395447', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-08 10:58:54.067+05:30', NULL, '2026-09-08 10:58:53.928+05:30', '11111111-1111-1111-1111-111111111111', 'aa06fbc50ca2c6872da35122712435d9780457e0d8255a12d5c9b2a04545f221', '2026-09-08 11:13:52.102+05:30', NULL);
INSERT INTO public.sessions VALUES ('54219d10-0437-4088-9822-f0c341da7784', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-08 11:14:28.326+05:30', NULL, '2026-09-08 11:14:28.328+05:30', '11111111-1111-1111-1111-111111111111', '8e5fb2fa7c203bdcbcfd6f2fac4e4bb04283173f48605c509b0cab8cca148e08', '2026-09-08 11:14:28.328+05:30', NULL);
INSERT INTO public.sessions VALUES ('f5f190b5-dc76-4ac7-bc4f-87c33db8af35', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL, '2026-10-05 17:26:56.204+05:30', NULL, '2026-09-05 17:26:56.206+05:30', '11111111-1111-1111-1111-111111111111', '4aac6752fe5c9ed2438468e6341535e4db801be784692513cbfa8a61bfd8dbd7', '2026-09-05 17:26:56.206+05:30', NULL);
INSERT INTO public.sessions VALUES ('885b1ac5-67a4-464d-9508-57339d271473', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-05 14:26:10.166+05:30', NULL, '2026-09-05 14:26:10.167+05:30', '11111111-1111-1111-1111-111111111111', '8132b2126f2dc10a05017efc3d07e40ea18e08a4f1fa2c3f0744841c1f1a882a', '2026-09-05 14:32:59.22+05:30', NULL);
INSERT INTO public.sessions VALUES ('3520a91a-0276-4726-9f68-9fe47430fd01', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-05 14:33:07.324+05:30', NULL, '2026-09-05 14:33:07.326+05:30', '11111111-1111-1111-1111-111111111111', 'ec6cf4675448739b50c795f63124594d95972f93b11dd1c3effe40ad89975516', '2026-09-05 14:33:08.346+05:30', NULL);
INSERT INTO public.sessions VALUES ('d6d41517-4b75-414c-9b45-667a4293dc20', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL, '2026-10-05 14:33:52.047+05:30', NULL, '2026-09-05 14:33:52.048+05:30', '11111111-1111-1111-1111-111111111111', '90e733e3ed4e6f94a5b2d275abc26c0a9e03a440b4875c6e42b53e666b9db20b', '2026-09-05 14:33:52.048+05:30', NULL);
INSERT INTO public.sessions VALUES ('8603ddc3-a924-4388-a8f7-25438041602d', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-08 11:55:45.471+05:30', NULL, '2026-09-08 11:55:45.474+05:30', '11111111-1111-1111-1111-111111111111', '4d2cd057da5649a13e970dfdcc7e19558cb522562f7169360b6463f9bc2ba2d7', '2026-09-08 11:55:45.474+05:30', NULL);
INSERT INTO public.sessions VALUES ('5f4591df-8fdf-4738-a148-1fd62c85de10', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-05 14:34:24.533+05:30', NULL, '2026-09-05 14:34:24.535+05:30', '11111111-1111-1111-1111-111111111111', '5834728b3d697555906cf65b47172f67beebf683f4cc080104485753ef74fb35', '2026-09-05 14:49:10.815+05:30', NULL);
INSERT INTO public.sessions VALUES ('f9be237b-da94-484b-b674-051262b0cbdc', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL, '2026-10-05 14:49:15.441+05:30', NULL, '2026-09-05 14:49:15.447+05:30', '11111111-1111-1111-1111-111111111111', 'f0ca2cd0911cb0fb476121bedeaa0f2793ca0cca9b7f16811d652d00d1a1e147', '2026-09-05 14:49:15.447+05:30', NULL);
INSERT INTO public.sessions VALUES ('5df769a2-eebc-40c2-92d8-c6626a6fae2c', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL, '2026-10-05 17:29:31.81+05:30', NULL, '2026-09-05 17:29:31.821+05:30', '11111111-1111-1111-1111-111111111111', '5cf9c15ac20554d47cc24eb5eb4fd6208cb1fe32dda49196e52d9b7f05ca694a', '2026-09-05 17:29:31.821+05:30', NULL);
INSERT INTO public.sessions VALUES ('f19833f9-58f8-4809-9ff0-b0b2883d35f4', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL, '2026-10-05 17:29:46.122+05:30', NULL, '2026-09-05 17:29:46.131+05:30', '11111111-1111-1111-1111-111111111111', '90f5f6bd081c7722d509e0c80021aa75fa5ea35c1aa01fd2688389e8b06b1aee', '2026-09-05 17:29:46.131+05:30', NULL);
INSERT INTO public.sessions VALUES ('e22fdb77-279c-4500-9c9d-9422149ad326', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL, '2026-10-05 17:30:22.44+05:30', NULL, '2026-09-05 17:30:22.449+05:30', '11111111-1111-1111-1111-111111111111', 'de0b504482e534d24ecce620600a151973f600e17f520d574b78368d257b9167', '2026-09-05 17:30:22.449+05:30', NULL);
INSERT INTO public.sessions VALUES ('22df741f-9695-4f97-aa96-3c547d9cc2bb', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-05 17:16:18.568+05:30', NULL, '2026-09-05 17:16:18.569+05:30', '11111111-1111-1111-1111-111111111111', '4a8a080550b87f4f12bac5ec3a9154d31282cb9e9e3366fe60555d31b3d2297e', '2026-09-05 17:30:24.826+05:30', NULL);
INSERT INTO public.sessions VALUES ('dc2f1748-819e-4f90-9bbb-044b9e751012', '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL, '2026-10-05 17:33:56.506+05:30', NULL, '2026-09-05 17:33:56.508+05:30', '11111111-1111-1111-1111-111111111111', '1abaa759c0fac499d94de3b11f72ab05407c4baa1689e6aedafd05a8c1cd87e2', '2026-09-05 17:33:56.508+05:30', NULL);
INSERT INTO public.sessions VALUES ('4ac65e08-1dcd-43bb-9e7e-f0824b69ef17', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL, '2026-10-05 17:34:08.434+05:30', NULL, '2026-09-05 17:34:08.435+05:30', '11111111-1111-1111-1111-111111111111', '668965fb9813659435fb766b78695694ffb864503c52c9ed0200acd27d3439d7', '2026-09-05 17:34:08.435+05:30', NULL);
INSERT INTO public.sessions VALUES ('57c159e4-e8a7-4e45-850c-ab037129d24d', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-08 12:57:26.247+05:30', NULL, '2026-09-08 12:57:26.249+05:30', '11111111-1111-1111-1111-111111111111', '3cf181211152278ef0210fd5b9e6bcb08349140222c87a14643ebe75ed8543a0', '2026-09-08 12:57:26.249+05:30', NULL);
INSERT INTO public.sessions VALUES ('5c37e85b-288b-49d3-8cb2-294cd6173d57', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-08 10:58:40.772+05:30', NULL, '2026-09-08 10:58:40.633+05:30', '11111111-1111-1111-1111-111111111111', 'f6639802ae83533e0a1b8bcca91d312240bf8b94c7f36162237efd5f1c8d0b83', '2026-09-08 10:59:20.473+05:30', NULL);
INSERT INTO public.sessions VALUES ('c18ef680-f5df-4395-b162-93d29d0eec80', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-05 15:03:03.317+05:30', NULL, '2026-09-05 15:03:03.323+05:30', '67315042-c687-4cbb-b45a-f4ea4efc199f', '1775bfd9d767b6e7e5f5293e9fbd825542c90390fca06f1c8b90aab015949a66', '2026-09-05 15:03:03.323+05:30', NULL);
INSERT INTO public.sessions VALUES ('97dc2bfb-6b8f-4192-9688-21ab5508cbf4', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-08 13:15:05.365+05:30', NULL, '2026-09-08 13:15:05.367+05:30', '11111111-1111-1111-1111-111111111111', '3d7d6d80402cf3290c842af0f9be5ba4a0e37c8d5feb480121a5b927d7877f5b', '2026-09-08 13:15:50.325+05:30', NULL);
INSERT INTO public.sessions VALUES ('6e508d13-0b59-46f0-ba0d-672321a42f08', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-08 11:15:56.249+05:30', NULL, '2026-09-08 11:15:56.255+05:30', '11111111-1111-1111-1111-111111111111', 'e7a93a64e5df09dab0be42eaa97a4e8dd9fbe46b074aa4e3dbd4e292a544cbe4', '2026-09-08 11:15:56.255+05:30', NULL);
INSERT INTO public.sessions VALUES ('a7d7bc55-3708-4857-87d8-2d4a79432854', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-08 14:14:14.692+05:30', NULL, '2026-09-08 14:14:14.707+05:30', '11111111-1111-1111-1111-111111111111', '4d4984e93ca7fcf8a8928a0610d5336206e0443554c252a8ebe60177aa285ed1', '2026-09-08 14:26:58.33+05:30', NULL);
INSERT INTO public.sessions VALUES ('4171211f-3dbf-4d58-bffb-d4100d1ae2f6', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-08 13:57:43.697+05:30', NULL, '2026-09-08 13:57:43.708+05:30', '11111111-1111-1111-1111-111111111111', '643fda9a58469cdf5b8357d0b3dcb1ecf25b051aac6accb81880fa4f40ae075e', '2026-09-08 13:57:56.741+05:30', NULL);
INSERT INTO public.sessions VALUES ('142093bc-da7e-464c-b087-1ace11b25dc2', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL, '2026-10-08 15:12:51.432+05:30', NULL, '2026-09-08 15:12:51.434+05:30', '11111111-1111-1111-1111-111111111111', 'eacc322ab8f38c8cd81ada140a79f964ffb723c34cb3dfbbd4f50f2df37a6c50', '2026-09-08 15:12:51.434+05:30', NULL);
INSERT INTO public.sessions VALUES ('2bcf9d74-cf4e-4ca5-846f-64b0ac233022', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-08 14:36:05.13+05:30', NULL, '2026-09-08 14:36:05.131+05:30', '11111111-1111-1111-1111-111111111111', 'b2f00e2a1371c70874378d5152d32fa6614791f2858a6e123cd9c9a76f1b4213', '2026-09-08 14:40:49.706+05:30', NULL);
INSERT INTO public.sessions VALUES ('7e4ef554-6d20-45c8-ad5b-7af054f4f471', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-08 14:57:23.415+05:30', NULL, '2026-09-08 14:57:23.416+05:30', '11111111-1111-1111-1111-111111111111', 'b6241a34928831d4a87fd8536cf61ec0ebc282e64e8cff1950eadcd450bc6dfe', '2026-09-08 14:57:23.416+05:30', NULL);
INSERT INTO public.sessions VALUES ('7b133074-b6c2-45c6-b197-85a08c3218a5', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-08 16:16:00.808+05:30', NULL, '2026-09-08 16:16:00.809+05:30', '11111111-1111-1111-1111-111111111111', '962ddc0408e70286cb525e8af0fc8ab0344177837857542a25cb2ae7f8fd9579', '2026-09-08 16:28:19.686+05:30', NULL);
INSERT INTO public.sessions VALUES ('f21c4d1f-b28d-48a6-9d65-d6f6a6252fd1', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-09 14:26:04.819+05:30', NULL, '2026-09-09 14:26:04.821+05:30', '11111111-1111-1111-1111-111111111111', '1504d82759d4b70826c418b3f28514a3e5194c63a37e68bd4f16323db4afde05', '2026-09-09 14:35:39.287+05:30', NULL);
INSERT INTO public.sessions VALUES ('81074981-3253-4b20-854b-574bfb6b4f7f', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-09 12:03:44.751+05:30', NULL, '2026-09-09 12:03:44.756+05:30', '11111111-1111-1111-1111-111111111111', '654220dd75214a0a303e94a92bec86f16512a43c2d67a8f775e87f90b5c0278f', '2026-09-09 12:05:31.771+05:30', NULL);
INSERT INTO public.sessions VALUES ('b49f2795-c6d9-4db6-9c48-5ea266167aaf', '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL, '2026-10-09 15:22:19.227+05:30', NULL, '2026-09-09 15:22:19.229+05:30', '11111111-1111-1111-1111-111111111111', '29fd1694b0b8bcebee400663f03bc412e5f8b26623fce217a6917aafd1d0db8b', '2026-09-09 15:24:41.126+05:30', NULL);
INSERT INTO public.sessions VALUES ('af990718-1c7e-4d01-80e9-80cc97d984b7', '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL, '2026-10-09 13:43:59.001+05:30', NULL, '2026-09-09 13:43:59.002+05:30', '11111111-1111-1111-1111-111111111111', 'bd6e660ea3da38aedb4ecd1003c6edffbb2a076d59d45568810af65e4c4efcca', '2026-09-09 13:49:56.249+05:30', NULL);
INSERT INTO public.sessions VALUES ('2fdaa586-6ee8-4fc6-9204-4f1e8a011d90', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-09 14:04:35.856+05:30', NULL, '2026-09-09 14:04:35.857+05:30', '11111111-1111-1111-1111-111111111111', '82d994b71b6975e92722cf1de8eb83a752f6a747069ff7508e44e07f60271a8c', '2026-09-09 14:17:02.362+05:30', NULL);
INSERT INTO public.sessions VALUES ('3998c86c-1da2-40a2-a638-8b409a6777c7', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-09 14:19:19.79+05:30', NULL, '2026-09-09 14:19:19.791+05:30', '11111111-1111-1111-1111-111111111111', '31140c235b488141ada66e90c7cc65b7916043243b589b58f7e6ba8cce579e65', '2026-09-09 14:19:19.791+05:30', NULL);
INSERT INTO public.sessions VALUES ('a0fc65ed-3a69-484f-9bf4-8ebf7e908719', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL, '2026-10-09 17:18:35.799+05:30', NULL, '2026-09-09 17:18:35.806+05:30', '11111111-1111-1111-1111-111111111111', '0c11b55bab829b4725d3c4f4fd8b2e457463378f02ae11ca75eb0cec8b6bf170', '2026-09-09 17:18:35.806+05:30', NULL);
INSERT INTO public.sessions VALUES ('5cf43adc-8bec-4ef7-9927-df0923f2e6ad', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-09 15:06:55.355+05:30', NULL, '2026-09-09 15:06:55.357+05:30', '11111111-1111-1111-1111-111111111111', '8b89b0925e44df5cdf5b5f727e97ef6314bb9e64b42979554ead4dc3994659e3', '2026-09-09 15:09:33.921+05:30', NULL);
INSERT INTO public.sessions VALUES ('750830e8-107d-4fee-99ac-550bd619ce3a', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL, '2026-10-09 17:18:58.217+05:30', NULL, '2026-09-09 17:18:58.224+05:30', '11111111-1111-1111-1111-111111111111', 'f7d9dc729457971a5ba19c7d8d55aeab5f9b57bf1da35f6b71d434067ac072d6', '2026-09-09 17:18:58.224+05:30', NULL);
INSERT INTO public.sessions VALUES ('52bfac5b-f742-40b9-8ea7-7ca14ada9ab6', '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL, '2026-10-10 10:47:43.03+05:30', NULL, '2026-09-10 10:47:43.033+05:30', '11111111-1111-1111-1111-111111111111', 'd8ad3593006437beb250178f12400bb0294366ca47d09d61b90ec79fac080747', '2026-09-10 10:47:43.033+05:30', NULL);
INSERT INTO public.sessions VALUES ('1e15073e-b9ac-4efa-922b-99d052f96e07', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-09 14:27:03.533+05:30', NULL, '2026-09-09 14:27:03.534+05:30', '11111111-1111-1111-1111-111111111111', 'c244d318ee5013f7d11b539aa23aab4452d44e3f8caed28a75c129b248425bd0', '2026-09-09 14:27:03.534+05:30', NULL);
INSERT INTO public.sessions VALUES ('adcae6ad-4be0-42fe-bbcd-a398c75a59a8', '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL, '2026-10-09 12:37:01.596+05:30', NULL, '2026-09-09 12:37:01.604+05:30', '11111111-1111-1111-1111-111111111111', 'a447f2f592b8136b690d94dcd09f9992c03cc1e465c9cab1e2aecf03486e83fd', '2026-09-09 12:51:54.901+05:30', NULL);
INSERT INTO public.sessions VALUES ('e9536604-d78a-4783-ab2e-3f35368439e7', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-09 12:52:31.44+05:30', NULL, '2026-09-09 12:52:31.441+05:30', '11111111-1111-1111-1111-111111111111', 'fd0bf4b3bcb9a9ae8660da9ea6607299b92ba5d886cd1a7da243924b68408c2f', '2026-09-09 12:52:31.441+05:30', NULL);
INSERT INTO public.sessions VALUES ('9acb17e5-5640-405b-a0ed-f7be553424a5', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-10 11:13:19.379+05:30', NULL, '2026-09-10 11:13:19.381+05:30', '11111111-1111-1111-1111-111111111111', '9e9ccf4941ee446d9791a0315529aed8c60d94b87c51822de1fffe17074f5df9', '2026-09-10 11:13:19.381+05:30', NULL);
INSERT INTO public.sessions VALUES ('89350506-79c2-4d71-92eb-b530578da2c9', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-09 14:27:33.386+05:30', NULL, '2026-09-09 14:27:33.39+05:30', '11111111-1111-1111-1111-111111111111', '24d04b467388545a805d8a73543edba9d5f304ea3a2cedf39bfcd34343ec11b7', '2026-09-09 14:27:33.39+05:30', NULL);
INSERT INTO public.sessions VALUES ('ea9996a5-44f6-45d8-a7cf-6ff66a1b1b63', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-10 17:17:41.143+05:30', NULL, '2026-09-10 17:17:41.145+05:30', '11111111-1111-1111-1111-111111111111', 'f5c05f3343c93f86e6997ccab7c5521db6580b8abb03dd9f59d6cf0a58694e71', '2026-09-10 17:25:24.306+05:30', NULL);
INSERT INTO public.sessions VALUES ('7b0ef1bb-37e6-4070-8de3-16906d391a72', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-09 14:28:57.598+05:30', NULL, '2026-09-09 14:28:57.614+05:30', '11111111-1111-1111-1111-111111111111', 'a0788409701122f39f66ea6d45dbb282ec0fa4283031ee2270b63b7a797b44f0', '2026-09-09 14:28:57.614+05:30', NULL);
INSERT INTO public.sessions VALUES ('113f1071-bfc9-4c9e-bf5d-66984f8bbc03', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-09 12:14:20.49+05:30', NULL, '2026-09-09 12:14:20.492+05:30', '11111111-1111-1111-1111-111111111111', '23d649a6b2f41c0d9cb05e779bdc13b1bc970a42f4c555519a90d5c4756675b9', '2026-09-09 12:28:43.524+05:30', NULL);
INSERT INTO public.sessions VALUES ('a25b9d90-2092-428f-b760-1f0d529b6e11', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-09 14:29:43.011+05:30', NULL, '2026-09-09 14:29:43.013+05:30', '11111111-1111-1111-1111-111111111111', '20fae48aa1e1c07ae116d76b80c54f33544125036224d5d8fd0aa0f7b0a553d8', '2026-09-09 14:29:43.013+05:30', NULL);
INSERT INTO public.sessions VALUES ('dc4ce1cf-703e-46d2-b87f-03b216d02c9b', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-09 12:44:06.197+05:30', NULL, '2026-09-09 12:44:06.202+05:30', '11111111-1111-1111-1111-111111111111', 'e3e7c830dbc4c7904e175754ffe72b4a1ab058ee1245ddcc19ce95089c26d3d6', '2026-09-09 12:44:06.202+05:30', NULL);
INSERT INTO public.sessions VALUES ('f6c59d9b-427d-4e4d-8828-816fbdf48963', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-09 14:30:40.85+05:30', NULL, '2026-09-09 14:30:40.852+05:30', '11111111-1111-1111-1111-111111111111', '8df48a36edbba4664c7d7932f67ee76f414b2977b40dd18aa90b88ea9fb59200', '2026-09-09 14:30:40.852+05:30', NULL);
INSERT INTO public.sessions VALUES ('84f25aab-9d25-42f5-a2d5-4cd21e68c4f3', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-09 14:31:14.116+05:30', NULL, '2026-09-09 14:31:14.119+05:30', '11111111-1111-1111-1111-111111111111', '8e9f8f254410868661d4fb7d06ae1c7e140cd31861a48be5447100da6917a132', '2026-09-09 14:31:14.119+05:30', NULL);
INSERT INTO public.sessions VALUES ('fe67143d-163a-489b-9674-4fdff73a5106', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-09 14:31:59.057+05:30', NULL, '2026-09-09 14:31:59.058+05:30', '11111111-1111-1111-1111-111111111111', 'e6d0381090b461e9fddbe7bfa85514b962aec4223b7b382d90250d17001ca084', '2026-09-09 14:31:59.058+05:30', NULL);
INSERT INTO public.sessions VALUES ('994c6a9b-5ec4-4484-b130-8ba3745bd1a3', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-09 14:32:47.999+05:30', NULL, '2026-09-09 14:32:48.002+05:30', '11111111-1111-1111-1111-111111111111', '6eafb5dc8433e7d7a4cc5fbe856ce9cdd9e4b6dfeadbde583f988619e67903f6', '2026-09-09 14:32:48.002+05:30', NULL);
INSERT INTO public.sessions VALUES ('151c69fa-76cd-4d51-95cd-da9b6aeb78fe', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-09 14:34:00.64+05:30', NULL, '2026-09-09 14:34:00.642+05:30', '11111111-1111-1111-1111-111111111111', '8b51890c7c138b47ebca03317dd99b14c18c1829281bd2183b07200d1220f38e', '2026-09-09 14:34:00.642+05:30', NULL);
INSERT INTO public.sessions VALUES ('976c3bd1-5bbe-4ca7-80be-0a563b8f11ce', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-10 17:42:03.056+05:30', NULL, '2026-09-10 17:42:03.058+05:30', '11111111-1111-1111-1111-111111111111', '14c8aa6174fcea244c8824c25082712f165920604b937758096b9b7949654e0e', '2026-09-10 17:56:49.048+05:30', NULL);
INSERT INTO public.sessions VALUES ('8c2a9186-ec1d-4ba1-a2f5-04a7d469c66f', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-09 12:52:37.578+05:30', NULL, '2026-09-09 12:52:37.578+05:30', '11111111-1111-1111-1111-111111111111', 'f4a52edc9e5295832f71963933b07b9407c469bb978ecd0068ab8d6c30a73b84', '2026-09-09 12:56:10.812+05:30', NULL);
INSERT INTO public.sessions VALUES ('855b2e59-cbc0-4188-9809-c3b568a9cd3e', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-09 13:00:42.465+05:30', NULL, '2026-09-09 13:00:42.466+05:30', '11111111-1111-1111-1111-111111111111', '429c10773027ab300f3685735eb9d583e0eab3f7f5c92efd64d47153f518d99e', '2026-09-09 13:00:42.466+05:30', NULL);
INSERT INTO public.sessions VALUES ('9bdd41b1-50c3-4637-8380-760a9326b376', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-09 13:01:24.997+05:30', NULL, '2026-09-09 13:01:24.996+05:30', '11111111-1111-1111-1111-111111111111', '7cde12e416ff57dc6326bbbaa95dfdfe7aa66cbaa540d0f513cbf7e42a0fc4e6', '2026-09-09 13:01:24.996+05:30', NULL);
INSERT INTO public.sessions VALUES ('09547a3f-8da3-4851-a43d-b89ca217b275', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-10 11:51:06.873+05:30', NULL, '2026-09-10 11:51:06.877+05:30', '11111111-1111-1111-1111-111111111111', 'd7078b6217792933ce207c06ee1428decafd931d09cf8495806e527858820ba4', '2026-09-10 12:05:55.154+05:30', NULL);
INSERT INTO public.sessions VALUES ('52a090a2-71ac-43cd-a28b-374f7ca707f0', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-09 13:02:01.932+05:30', NULL, '2026-09-09 13:02:01.936+05:30', '11111111-1111-1111-1111-111111111111', 'e8145ea2691958d1d80f86166715af05bda6e04c8f66317f2600cc839424161e', '2026-09-09 13:02:01.936+05:30', NULL);
INSERT INTO public.sessions VALUES ('0dc3b502-9495-4dbf-9dd6-4fef500c3e6b', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-09 13:03:37.562+05:30', NULL, '2026-09-09 13:03:37.563+05:30', '11111111-1111-1111-1111-111111111111', '7ffe850de6634ed338151211dea0a9e3e14a13f44fdb47c94349a2bd0a091573', '2026-09-09 13:03:37.563+05:30', NULL);
INSERT INTO public.sessions VALUES ('5687e881-f765-4582-9327-c44476ed9436', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-09 13:04:47.981+05:30', NULL, '2026-09-09 13:04:47.98+05:30', '11111111-1111-1111-1111-111111111111', '12ae61e8df353e46ccf5dca10cdef33e8d2bc9f8387b45286ac34f6b48d7b673', '2026-09-09 13:04:47.98+05:30', NULL);
INSERT INTO public.sessions VALUES ('bb9eeec7-1e61-49cf-861a-c3c01a3d2067', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-09 13:06:32.098+05:30', NULL, '2026-09-09 13:06:32.098+05:30', '11111111-1111-1111-1111-111111111111', '25f2777408fa78a044d6986c9d7aa4f4b77b73626f2e15dfe4cfb6001ac581d7', '2026-09-09 13:06:32.098+05:30', NULL);
INSERT INTO public.sessions VALUES ('c5d61241-72d7-4d8a-9dc0-094a938f55d2', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-10 17:25:28.947+05:30', NULL, '2026-09-10 17:25:28.949+05:30', '11111111-1111-1111-1111-111111111111', 'a9c0a79345cc88298d52e3ac3ca2d190b1385f937c15e99d6426c74155eabcfd', '2026-09-10 17:40:14.864+05:30', NULL);
INSERT INTO public.sessions VALUES ('f2ecc723-2683-4485-9164-a72f61209460', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-09 15:06:49.175+05:30', NULL, '2026-09-09 15:06:49.177+05:30', '11111111-1111-1111-1111-111111111111', 'a98bdd4742c81e645f66dd798e3fbc54a0f9f7cbb14dbffbb2df9c3d1dc44cc5', '2026-09-09 15:21:43.279+05:30', NULL);
INSERT INTO public.sessions VALUES ('52d47f7e-1d21-4b72-8aed-51b726644659', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-10 16:49:22.078+05:30', NULL, '2026-09-10 16:49:22.082+05:30', '11111111-1111-1111-1111-111111111111', '83b5f7c9d0f32877103d7f8f63a2b8a938d9d07d5f73db4ff2d0eaa6e1e1e05a', '2026-09-10 17:04:08.535+05:30', NULL);
INSERT INTO public.sessions VALUES ('67a74320-c693-44db-ba74-fe381dcd46d3', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-10 17:58:21.118+05:30', NULL, '2026-09-10 17:58:21.12+05:30', '11111111-1111-1111-1111-111111111111', 'ad46a8089d624ba3a3cdfca8c227d187d70d70bbbd4837f66a822d51a306d315', '2026-09-10 17:58:22.189+05:30', NULL);
INSERT INTO public.sessions VALUES ('52a30d42-feff-4037-bade-600c2fab6397', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-11 10:23:08.003+05:30', NULL, '2026-09-11 10:23:08.006+05:30', '11111111-1111-1111-1111-111111111111', 'b2592d101ca4c86936c3929972082d82659111d06f7ad05ec5ec502bad33c9e3', '2026-09-11 10:24:03.163+05:30', NULL);
INSERT INTO public.sessions VALUES ('b3f325fc-b6db-4ec7-a3c8-5ab649df5a32', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-11 11:28:19.072+05:30', NULL, '2026-09-11 11:28:19.073+05:30', '11111111-1111-1111-1111-111111111111', '779ef870e01ef4b917a525b24e8194df9c98cfe9f1dbf5673de648d9bb24edf6', '2026-09-11 11:29:54.899+05:30', NULL);
INSERT INTO public.sessions VALUES ('ff83b706-5366-47fc-aa3c-18eed77dd422', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-11 11:09:46.311+05:30', NULL, '2026-09-11 11:09:46.313+05:30', '11111111-1111-1111-1111-111111111111', 'bd2fa2345a722938f16dec5a9aef39e3ee918fc296b3c44ba16a166b3a0c11da', '2026-09-11 11:17:07.616+05:30', NULL);
INSERT INTO public.sessions VALUES ('78158cc0-0acc-42db-a5bc-fd1b848d5b1c', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-11 11:30:04.359+05:30', NULL, '2026-09-11 11:30:04.363+05:30', '11111111-1111-1111-1111-111111111111', '6938accf4a114ea643ed7e82f7603dd5a9a2c0ce4ee9767f8dd5d276aaf26318', '2026-09-11 11:30:34.915+05:30', NULL);
INSERT INTO public.sessions VALUES ('3f57d809-fffb-4f64-955e-78b3c906c1ca', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-11 11:30:47.806+05:30', NULL, '2026-09-11 11:30:47.811+05:30', '11111111-1111-1111-1111-111111111111', 'e3df115455cc2df3a979440d50eb97dc07ef02aff3e39c9f4e042bec5dd014ef', '2026-09-11 11:39:45.989+05:30', NULL);
INSERT INTO public.sessions VALUES ('3fa67bc1-ed4d-4c0b-8872-2282713c28c7', '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL, '2026-10-11 11:53:11.696+05:30', NULL, '2026-09-11 11:53:11.698+05:30', '11111111-1111-1111-1111-111111111111', 'd23dbdce50aada31e37ae622e934f6371e9e0dddad7603b85901bbdb64962706', '2026-09-11 11:53:11.698+05:30', NULL);
INSERT INTO public.sessions VALUES ('9507e882-4159-4970-b8fb-814271944d71', '5e635b7d-856a-40b8-8a8c-1398f74eca30', NULL, NULL, NULL, '2026-10-11 12:00:49.071+05:30', NULL, '2026-09-11 12:00:49.083+05:30', '11111111-1111-1111-1111-111111111111', 'b1e0f735a539c9bd1f0103738d65bd530168718928942e83da3799dac05dc379', '2026-09-11 12:00:49.083+05:30', NULL);
INSERT INTO public.sessions VALUES ('7ebaa51e-e6ee-4b28-b0b7-453c304b308d', '72bad3bb-6097-47d2-bfc2-35b1244a7b9f', NULL, NULL, NULL, '2026-10-11 12:00:49.253+05:30', NULL, '2026-09-11 12:00:49.266+05:30', '11111111-1111-1111-1111-111111111111', 'e13376ff75e79da4c71da7d709cf2b434e016d9deb0a70e96d03c7d00455a838', '2026-09-11 12:00:49.266+05:30', NULL);
INSERT INTO public.sessions VALUES ('48cfd559-022e-4e0f-a19a-c6bb2fb53d80', '5c660c1f-f5f8-4007-87a6-b4b39913998b', NULL, NULL, NULL, '2026-10-11 12:00:49.381+05:30', NULL, '2026-09-11 12:00:49.394+05:30', '11111111-1111-1111-1111-111111111111', '4b3bdf7361f06f17828a0ecf422f936309787985d029e97ea4987c659a554e54', '2026-09-11 12:00:49.394+05:30', NULL);
INSERT INTO public.sessions VALUES ('3de4138c-4d12-437b-a64a-4ea514cf58b2', '5e635b7d-856a-40b8-8a8c-1398f74eca30', NULL, NULL, NULL, '2026-10-11 12:08:28.084+05:30', NULL, '2026-09-11 12:08:28.09+05:30', '11111111-1111-1111-1111-111111111111', 'fe993b5a5bb9e645290adedf29e43b0c2c958eef9824c59cf6df6b06bed60194', '2026-09-11 12:08:28.09+05:30', NULL);
INSERT INTO public.sessions VALUES ('f9993338-c197-4cab-8a50-31bea13bd878', '72bad3bb-6097-47d2-bfc2-35b1244a7b9f', NULL, NULL, NULL, '2026-10-11 12:08:28.322+05:30', NULL, '2026-09-11 12:08:28.328+05:30', '11111111-1111-1111-1111-111111111111', '79aab26c81071db90bc5340996822d5770adb6313ff7ec46d2b62b96fc8e5051', '2026-09-11 12:08:28.328+05:30', NULL);
INSERT INTO public.sessions VALUES ('6ddf3d78-ccd1-4e33-a564-84c995e60552', '5c660c1f-f5f8-4007-87a6-b4b39913998b', NULL, NULL, NULL, '2026-10-11 12:08:28.504+05:30', NULL, '2026-09-11 12:08:28.511+05:30', '11111111-1111-1111-1111-111111111111', '4cd6d3709eb9f610cb0f1f51c7295cf9d6357d3cf6fb168a19a31f98685d48dd', '2026-09-11 12:08:28.511+05:30', NULL);
INSERT INTO public.sessions VALUES ('24860b61-4f37-44d0-8781-930ba11e4982', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-11 12:08:56.262+05:30', NULL, '2026-09-11 12:08:56.269+05:30', '11111111-1111-1111-1111-111111111111', '2784aa933748d1b24d32653a8cf6b80d5d1bd4604a81c7560ec6b63854b840a7', '2026-09-11 12:08:56.269+05:30', NULL);
INSERT INTO public.sessions VALUES ('f83c2870-6c43-4942-9bbb-669ce8e1c28a', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-11 14:24:08.836+05:30', NULL, '2026-09-11 14:24:08.837+05:30', '11111111-1111-1111-1111-111111111111', '17444a1476b76292fccc89480c83ad76bfca8677725243c7372aaae2dd02b88e', '2026-09-11 14:24:55.069+05:30', NULL);
INSERT INTO public.sessions VALUES ('283c8718-c72a-4389-81b3-a3dd9c2130c6', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-11 12:09:12.301+05:30', NULL, '2026-09-11 12:09:12.308+05:30', '11111111-1111-1111-1111-111111111111', 'd7a2beaf9ad58ec9ebac6a9cd89c162c74eb5465e259c02c87263861591a7c82', '2026-09-11 12:09:31.226+05:30', NULL);
INSERT INTO public.sessions VALUES ('d181b7d4-01cd-474c-8e9a-889025e6e2b3', '5c660c1f-f5f8-4007-87a6-b4b39913998b', NULL, NULL, NULL, '2026-10-11 12:09:33.054+05:30', NULL, '2026-09-11 12:09:33.058+05:30', '11111111-1111-1111-1111-111111111111', '710d370d8e3606e65fa7ba38430dacfa55e815cb87e67a2fe6072f6159c26487', '2026-09-11 12:09:48.638+05:30', NULL);
INSERT INTO public.sessions VALUES ('0da19c67-28f2-4a1a-9283-adfd6e205941', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-11 15:19:05.715+05:30', NULL, '2026-09-11 15:19:05.716+05:30', '11111111-1111-1111-1111-111111111111', 'd7130d6e49ad709dfd8c9f89232f665815c4fcce91c83b5102bae345629e9510', '2026-09-11 15:19:21.978+05:30', NULL);
INSERT INTO public.sessions VALUES ('c3f079e2-25df-4e53-ae93-daa8477e50c1', '72bad3bb-6097-47d2-bfc2-35b1244a7b9f', NULL, NULL, NULL, '2026-10-11 14:25:03.814+05:30', NULL, '2026-09-11 14:25:03.815+05:30', '11111111-1111-1111-1111-111111111111', 'd2fc2093edc6eb70cb1f6b4b7a22b42b225764bab0df66bc5d611eca91fd2459', '2026-09-11 14:25:34.344+05:30', NULL);
INSERT INTO public.sessions VALUES ('ae6b4532-92d4-41b4-9acb-7fb3b337de7c', '5c660c1f-f5f8-4007-87a6-b4b39913998b', NULL, NULL, NULL, '2026-10-11 12:33:18.269+05:30', NULL, '2026-09-11 12:33:18.27+05:30', '11111111-1111-1111-1111-111111111111', 'ea195e1f19141b68b76cb90a06b1f1ac94928a16f3d426ae68a0290c5359d8f2', '2026-09-11 12:35:44.668+05:30', NULL);
INSERT INTO public.sessions VALUES ('9ada0575-9d90-4daa-af5b-e91c634ff4e9', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-11 16:12:06.213+05:30', NULL, '2026-09-11 16:12:06.215+05:30', '11111111-1111-1111-1111-111111111111', 'f9875e879cd4c1ca2349ac1457dd6cf90addd3eb49176b82c94863947de277bd', '2026-09-11 16:20:41.701+05:30', NULL);
INSERT INTO public.sessions VALUES ('d006c031-e2e2-4641-88ab-4f5a8b37da27', '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL, '2026-10-11 16:39:17.469+05:30', NULL, '2026-09-11 16:39:17.471+05:30', '11111111-1111-1111-1111-111111111111', 'c70270f179ed6313c5b0f03baa924c858b0c226f2010c59652e42f05afbd6435', '2026-09-11 16:39:29.413+05:30', NULL);
INSERT INTO public.sessions VALUES ('3bcb49da-d424-4241-a185-bd7875d81344', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-11 12:59:09.449+05:30', NULL, '2026-09-11 12:59:09.451+05:30', '11111111-1111-1111-1111-111111111111', 'bf5be3107e6759524c5eb6fa83ecc7c7b4d2dc21275ad77498a717d5fdc04dc1', '2026-09-11 13:13:25.031+05:30', NULL);
INSERT INTO public.sessions VALUES ('1f32c5f0-6cff-4370-a828-269903536268', '5e635b7d-856a-40b8-8a8c-1398f74eca30', NULL, NULL, NULL, '2026-10-11 14:10:25.07+05:30', NULL, '2026-09-11 14:10:25.072+05:30', '67315042-c687-4cbb-b45a-f4ea4efc199f', '892eff72ada2dba5509ca90a322cf0c30dda35fd0045e4f8438c70f2aea669e7', '2026-09-11 14:10:25.072+05:30', NULL);
INSERT INTO public.sessions VALUES ('5d7b41ff-755e-4ad2-8ad5-6238d201d92d', '72bad3bb-6097-47d2-bfc2-35b1244a7b9f', NULL, NULL, NULL, '2026-10-11 14:10:25.214+05:30', NULL, '2026-09-11 14:10:25.216+05:30', '67315042-c687-4cbb-b45a-f4ea4efc199f', '1cae85aa2c2cc0a7adf1bce0bfc4ba7a6e9e51706ba8eaeaaaeac41e59f2630b', '2026-09-11 14:10:25.216+05:30', NULL);
INSERT INTO public.sessions VALUES ('2c267af2-9a98-4d64-8cbe-4e20c0f550da', '5e635b7d-856a-40b8-8a8c-1398f74eca30', NULL, NULL, NULL, '2026-10-11 14:11:01.642+05:30', NULL, '2026-09-11 14:11:01.644+05:30', '67315042-c687-4cbb-b45a-f4ea4efc199f', '9c8b849c285d3092f22453a10a9b37419a65cd261cdf903d472c911a01698fc3', '2026-09-11 14:11:01.644+05:30', NULL);
INSERT INTO public.sessions VALUES ('be599705-f403-4e56-be8a-3a2a756e386c', '72bad3bb-6097-47d2-bfc2-35b1244a7b9f', NULL, NULL, NULL, '2026-10-11 14:11:01.787+05:30', NULL, '2026-09-11 14:11:01.789+05:30', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'c3e8763221fa386a2c6cc377834777b9c7797401f658cc5ed1ae1cbcd0e33e69', '2026-09-11 14:11:01.789+05:30', NULL);
INSERT INTO public.sessions VALUES ('d54223ed-def8-4d09-b3b7-25796a746fa5', '5e635b7d-856a-40b8-8a8c-1398f74eca30', NULL, NULL, NULL, '2026-10-11 12:35:52.386+05:30', NULL, '2026-09-11 12:35:52.387+05:30', '11111111-1111-1111-1111-111111111111', '77d7790a1529b1b23b9d151fcf998e6cab2f2c1a3b850a7e9c76e3040d9b864d', '2026-09-11 12:50:37.029+05:30', NULL);
INSERT INTO public.sessions VALUES ('a0df329f-6594-4b9f-bffd-15db3a05837b', '5e635b7d-856a-40b8-8a8c-1398f74eca30', NULL, NULL, NULL, '2026-10-11 14:12:08.356+05:30', NULL, '2026-09-11 14:12:08.357+05:30', '67315042-c687-4cbb-b45a-f4ea4efc199f', '08dca02b85d773d86f74a31e6f05ec2de93f553f283fc5bb47e094238c50fcc0', '2026-09-11 14:12:08.357+05:30', NULL);
INSERT INTO public.sessions VALUES ('a734526b-cd06-4f63-bcd7-e01b509daec1', '72bad3bb-6097-47d2-bfc2-35b1244a7b9f', NULL, NULL, NULL, '2026-10-11 12:09:59.466+05:30', NULL, '2026-09-11 12:09:59.47+05:30', '11111111-1111-1111-1111-111111111111', '6b68c0a598c17ba2858bcf1a19bcc6ad8f836ef9c9da62bfc637da2e67d2c7a4', '2026-09-11 12:24:25.052+05:30', NULL);
INSERT INTO public.sessions VALUES ('4ac32d00-46c1-45a5-a0eb-cf5e82e5f13c', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-11 12:33:02.118+05:30', NULL, '2026-09-11 12:33:02.119+05:30', '11111111-1111-1111-1111-111111111111', 'cbef961628279e0b57c9bc01117fb014db194ab4f1017d9a97447559d192ddd9', '2026-09-11 12:33:03.319+05:30', NULL);
INSERT INTO public.sessions VALUES ('51f00ed1-071b-4375-a15a-4a6c40cf929d', '72bad3bb-6097-47d2-bfc2-35b1244a7b9f', NULL, NULL, NULL, '2026-10-11 14:12:08.551+05:30', NULL, '2026-09-11 14:12:08.552+05:30', '67315042-c687-4cbb-b45a-f4ea4efc199f', '9c02a75c782616d201ee98fbbe8c61baeea950df5e604e5db5445a68165db41a', '2026-09-11 14:12:08.552+05:30', NULL);
INSERT INTO public.sessions VALUES ('44a0a2d5-0658-45c6-8704-62b33cc7a090', '5e635b7d-856a-40b8-8a8c-1398f74eca30', NULL, NULL, NULL, '2026-10-11 14:16:06.985+05:30', NULL, '2026-09-11 14:16:06.996+05:30', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'f570d53d8983b8ef42a868cb0103ec43be59516574fe630b4a09b7bbdf4fcb18', '2026-09-11 14:16:06.996+05:30', NULL);
INSERT INTO public.sessions VALUES ('b0d1147a-185f-42e2-b9dd-7678c9fbe4e3', '72bad3bb-6097-47d2-bfc2-35b1244a7b9f', NULL, NULL, NULL, '2026-10-11 14:16:07.154+05:30', NULL, '2026-09-11 14:16:07.164+05:30', '67315042-c687-4cbb-b45a-f4ea4efc199f', '82268efcf7f8c60d2192446044bd9256ffe5e0bb559de8262aa85c3659cf9e81', '2026-09-11 14:16:07.164+05:30', NULL);
INSERT INTO public.sessions VALUES ('bebe0ba6-4ebe-4405-bf5b-5b47dc101fc5', '5e635b7d-856a-40b8-8a8c-1398f74eca30', NULL, NULL, NULL, '2026-10-11 14:19:07.089+05:30', NULL, '2026-09-11 14:19:07.092+05:30', '67315042-c687-4cbb-b45a-f4ea4efc199f', '86b19527696a40c26f95efe6ed4e6610c57d30a53680047fcd70fb3bce062cad', '2026-09-11 14:19:07.092+05:30', NULL);
INSERT INTO public.sessions VALUES ('a1817cc8-4872-4a07-b003-446c6434cce0', '72bad3bb-6097-47d2-bfc2-35b1244a7b9f', NULL, NULL, NULL, '2026-10-11 14:19:07.242+05:30', NULL, '2026-09-11 14:19:07.245+05:30', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'c1fdcb34efd0b56dd7969ffb0b04db7f044c83becc9dedbb68a1b7aad57c50af', '2026-09-11 14:19:07.245+05:30', NULL);
INSERT INTO public.sessions VALUES ('0ceb04d2-3860-4357-a174-345aae7220db', '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL, '2026-10-11 14:41:44.057+05:30', NULL, '2026-09-11 14:41:44.059+05:30', '11111111-1111-1111-1111-111111111111', '804d9d4f70ae4b193c61d1a75cbf3822c34203a5b3c82a5fcf3cb7a9d71a499a', '2026-09-11 14:43:56.522+05:30', NULL);
INSERT INTO public.sessions VALUES ('d0572568-93ce-45f2-a889-fbe418d3a6c1', '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL, '2026-10-11 17:01:27.146+05:30', NULL, '2026-09-11 17:01:27.147+05:30', '11111111-1111-1111-1111-111111111111', 'ea422ed0bb38de70c1a7791bcb557a05a5735832c0c20c2d1b8b8bcc26ab996e', '2026-09-11 17:01:27.147+05:30', NULL);
INSERT INTO public.sessions VALUES ('f6e94814-e7d2-466b-9910-394dfe170675', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-11 17:18:40.591+05:30', NULL, '2026-09-11 17:18:40.601+05:30', '11111111-1111-1111-1111-111111111111', '4e4198df457a61736dd6c70eafa5284abdaf7366b59d5bb6eee43d96ee8991a4', '2026-09-11 17:18:40.601+05:30', NULL);
INSERT INTO public.sessions VALUES ('4bc863e5-66c2-4c6e-90a6-4f608dd7d736', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL, '2026-10-11 17:18:40.81+05:30', NULL, '2026-09-11 17:18:40.82+05:30', '11111111-1111-1111-1111-111111111111', 'bcb2e2fb9b26dd54b97cc4d1a0de30d9ee480f44af4541a4d774f2aa0c09d25b', '2026-09-11 17:18:40.82+05:30', NULL);
INSERT INTO public.sessions VALUES ('0c98f20d-ce61-48ae-a606-3c9d9d6f7223', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-11 17:18:41.07+05:30', NULL, '2026-09-11 17:18:41.08+05:30', '11111111-1111-1111-1111-111111111111', 'b950332a1855c46c9c7e7ae4eac5724089f8b3af1fe11a6a887dd66562ddbe29', '2026-09-11 17:18:41.08+05:30', NULL);
INSERT INTO public.sessions VALUES ('67662fb3-129f-42dd-bbd2-9b14fec3621f', '72bad3bb-6097-47d2-bfc2-35b1244a7b9f', NULL, NULL, NULL, '2026-10-11 14:44:00.8+05:30', NULL, '2026-09-11 14:44:00.801+05:30', '11111111-1111-1111-1111-111111111111', '90f8088520a4d7529c894e6283cf4438eaf88326c49f4ff1f853b3e6baa19807', '2026-09-11 14:58:15.028+05:30', NULL);
INSERT INTO public.sessions VALUES ('d09614c3-c5c7-4bdc-907c-e73025cf5e5e', '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL, '2026-10-11 17:18:41.229+05:30', NULL, '2026-09-11 17:18:41.238+05:30', '11111111-1111-1111-1111-111111111111', '5d726cbefa897e268aa7ee554c7c55873116a1e19e53ab13fb4cb23a756666b0', '2026-09-11 17:18:41.238+05:30', NULL);
INSERT INTO public.sessions VALUES ('d2e7f5cc-9f4e-40ea-980b-bc430a2ccb97', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-11 17:21:39.64+05:30', NULL, '2026-09-11 17:21:39.654+05:30', '11111111-1111-1111-1111-111111111111', '623244957af8b3539762c551af69e03ea8190092159d803f8007b65e9155a7d5', '2026-09-11 17:21:39.654+05:30', NULL);
INSERT INTO public.sessions VALUES ('df5c5e52-63bf-4518-ad2b-5d28a4107108', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL, '2026-10-11 17:21:40.087+05:30', NULL, '2026-09-11 17:21:40.102+05:30', '11111111-1111-1111-1111-111111111111', '5a29c64607a7f5cb2af0d92c2f399233f38d01b21cf80962271fb49121e9a550', '2026-09-11 17:21:40.102+05:30', NULL);
INSERT INTO public.sessions VALUES ('24ceb359-dfd5-470f-b310-2c5415ca33e0', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-11 17:21:40.443+05:30', NULL, '2026-09-11 17:21:40.457+05:30', '11111111-1111-1111-1111-111111111111', '2c1f0468e51799864ad801270e432564ee11f47ed4ac98b2930ae9bcdf44d051', '2026-09-11 17:21:40.457+05:30', NULL);
INSERT INTO public.sessions VALUES ('81f5ced5-ac9f-46cf-a39d-beac5e520cea', '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL, '2026-10-11 17:21:40.591+05:30', NULL, '2026-09-11 17:21:40.605+05:30', '11111111-1111-1111-1111-111111111111', 'ce459dca94777f49fe5cd3d599b278ce09bd5e632f2808fbbd4e38b378d3158f', '2026-09-11 17:21:40.605+05:30', NULL);
INSERT INTO public.sessions VALUES ('49353758-818b-497a-b8cd-601f84e64c34', '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL, '2026-10-11 17:23:57.256+05:30', NULL, '2026-09-11 17:23:57.258+05:30', '11111111-1111-1111-1111-111111111111', '6f259167dad507bdc5be309e7c0cb989cd32a93e0dcf4d14d9c1bf5c7d90f3ca', '2026-09-11 17:23:57.258+05:30', NULL);
INSERT INTO public.sessions VALUES ('d4d61101-8839-415c-a1c4-c1413c6c63ba', '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL, '2026-10-11 17:26:24.833+05:30', NULL, '2026-09-11 17:26:24.836+05:30', '11111111-1111-1111-1111-111111111111', 'dcc0bad5dff2ec57ff3645f00455c07cdd11b94aa2941143dc14ff88cfcf6f35', '2026-09-11 17:26:24.836+05:30', NULL);
INSERT INTO public.sessions VALUES ('996a8355-945e-4dca-bce7-1286aab90fe9', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-12 15:12:06.571+05:30', NULL, '2026-09-12 15:12:06.574+05:30', '11111111-1111-1111-1111-111111111111', '825fd80159e60fd886802db97955b33a1c959b96694cbd06ee8ec0dc2abaafb7', '2026-09-12 15:27:05.97+05:30', NULL);
INSERT INTO public.sessions VALUES ('84162277-e122-4d17-97c0-5cb2b7d16253', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-12 15:28:27.131+05:30', NULL, '2026-09-12 15:28:27.132+05:30', '11111111-1111-1111-1111-111111111111', '6ed387a7ccb52fa30e430f8c459306239688b886df2cda8a2edc85c38d79a78b', '2026-09-12 15:28:27.132+05:30', NULL);
INSERT INTO public.sessions VALUES ('c82e3153-de96-4d4a-b363-c22d699b7d12', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-11 17:27:33.792+05:30', NULL, '2026-09-11 17:27:33.794+05:30', '11111111-1111-1111-1111-111111111111', 'a686489dcf8a7bb69ea2f957e252681c6e9ef392c1f3cb92c6c18027e9e1756d', '2026-09-11 17:28:12.25+05:30', NULL);
INSERT INTO public.sessions VALUES ('5969acf6-ae2a-4871-a716-4ad3f354344f', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-12 11:37:06.825+05:30', NULL, '2026-09-12 11:37:06.828+05:30', '11111111-1111-1111-1111-111111111111', 'a218bc615e8561e7378c8625848ccdfab61141cd19d0d781ac90b50debc8e7ca', '2026-09-12 11:37:06.828+05:30', NULL);
INSERT INTO public.sessions VALUES ('012b108d-f5dc-4e24-9fa2-2b50518bef79', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-12 12:03:02.69+05:30', NULL, '2026-09-12 12:03:02.703+05:30', '11111111-1111-1111-1111-111111111111', '8430af2649335ae472117e3c827fad50cb20396a7494c0e90d44d98d58cc3d3e', '2026-09-12 12:03:02.703+05:30', NULL);
INSERT INTO public.sessions VALUES ('9638bbca-55d3-4dc3-8b75-3dfe65bfdf77', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-12 12:03:15.611+05:30', NULL, '2026-09-12 12:03:15.624+05:30', '11111111-1111-1111-1111-111111111111', '1cb3713b31861c258944f01c2d5a293743970edeacef58ee430cd7ddbc3eb017', '2026-09-12 12:03:15.624+05:30', NULL);
INSERT INTO public.sessions VALUES ('aa1e47ca-73e9-4e1d-a9dc-27acc1336e6b', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-12 12:07:26.043+05:30', NULL, '2026-09-12 12:07:26.045+05:30', '11111111-1111-1111-1111-111111111111', 'ad18174a8d772d457f7edbf232387143f1dc9ab0b027d83e368dbd69227754bb', '2026-09-12 12:07:26.045+05:30', NULL);
INSERT INTO public.sessions VALUES ('97b6cd39-c620-4392-a29f-a292ec13a1e7', 'ed8a2f35-4fcf-444b-b6d0-e6808c435e06', NULL, NULL, NULL, '2026-10-12 16:35:39.248+05:30', NULL, '2026-09-12 16:35:39.264+05:30', '11111111-1111-1111-1111-111111111111', '85573ec91ea8885458b875a9923c7fd3a29f57087991ec1260c5ef5fdb39af41', '2026-09-12 16:50:28.158+05:30', NULL);
INSERT INTO public.sessions VALUES ('86e7e9f2-6f3d-4b60-9237-6ff981843418', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-12 12:12:11.055+05:30', NULL, '2026-09-12 12:12:11.057+05:30', '11111111-1111-1111-1111-111111111111', '6da55972e0134205bf0501919d1fb2cfbe867a60166dad960660de954963cd22', '2026-09-12 12:13:00.429+05:30', NULL);
INSERT INTO public.sessions VALUES ('28d54eaa-256c-43b9-8f23-558c4b569236', '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL, '2026-10-12 17:22:26.457+05:30', NULL, '2026-09-12 17:22:26.46+05:30', '11111111-1111-1111-1111-111111111111', 'c2859243c61c485b9dd30cb702daf2523b4e51888964d7bbdfef0fa8ffd479e7', '2026-09-12 17:22:26.46+05:30', NULL);
INSERT INTO public.sessions VALUES ('78eb9f1e-b619-4319-88b0-806f96605f5f', '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL, NULL, NULL, '2026-10-12 15:29:10.873+05:30', '2026-09-12 15:30:19.916+05:30', '2026-09-12 15:29:10.874+05:30', '11111111-1111-1111-1111-111111111111', '50b11acd174261425e38ecaaab67e53600914b3c8946486e59b1f20f6e2dc319', '2026-09-12 15:30:19.923+05:30', NULL);
INSERT INTO public.sessions VALUES ('67ce1c37-1d25-4f3b-aba2-e118064e3a7c', '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL, '2026-10-12 15:30:58.231+05:30', NULL, '2026-09-12 15:30:58.238+05:30', '11111111-1111-1111-1111-111111111111', 'c530ddbc21aceb88ef8021a74dfcd1fe904ec964988e50ff44aa6589c1681a47', '2026-09-12 15:31:34.852+05:30', NULL);
INSERT INTO public.sessions VALUES ('c3f51e58-abe5-4cb5-8b37-bea9a5ebdc1c', '72bad3bb-6097-47d2-bfc2-35b1244a7b9f', NULL, NULL, NULL, '2026-10-12 16:04:28.167+05:30', NULL, '2026-09-12 16:04:28.168+05:30', '11111111-1111-1111-1111-111111111111', 'e728fe12ea8c3c152bdb7459c6923fe6df7055ba1fb3c4679021465efc064678', '2026-09-12 16:19:23.154+05:30', NULL);
INSERT INTO public.sessions VALUES ('ae0f25fc-1b7f-43e2-9e40-7fae6569a4f4', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-12 16:20:28.167+05:30', NULL, '2026-09-12 16:20:28.17+05:30', '11111111-1111-1111-1111-111111111111', '1357b9b43893b97ea4cb62d1d5b9fc65e5fa3d029228521d958c72d3cdd18004', '2026-09-12 16:20:28.17+05:30', NULL);
INSERT INTO public.sessions VALUES ('cae91305-bbeb-43e5-b716-45ff64da8e8c', '72bad3bb-6097-47d2-bfc2-35b1244a7b9f', NULL, NULL, NULL, '2026-10-12 15:31:38.308+05:30', NULL, '2026-09-12 15:31:38.316+05:30', '11111111-1111-1111-1111-111111111111', '67e6ed938db16f9260344437c01152d5074f0d8f1117801f5663687b0cfd2752', '2026-09-12 15:46:23.949+05:30', NULL);
INSERT INTO public.sessions VALUES ('31d30806-a6ce-4830-8c47-526f4c71b2f7', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-12 16:03:51.926+05:30', NULL, '2026-09-12 16:03:51.928+05:30', '11111111-1111-1111-1111-111111111111', 'd6299d6a2484346403a9b8ba7c68c650d92e1b7a34d5377e745b8103afeb9c13', '2026-09-12 16:04:14.379+05:30', NULL);
INSERT INTO public.sessions VALUES ('9a928fb0-09d9-4a5a-aacb-72676d398726', '918df673-2606-403a-9fad-1c54870d1fce', NULL, NULL, NULL, '2026-10-12 16:20:35.417+05:30', NULL, '2026-09-12 16:20:35.419+05:30', '11111111-1111-1111-1111-111111111111', '09d2719ff0b8ae1c139684dec51e5ab70125736786ca6e35c25a19575391cf68', '2026-09-12 16:35:18.283+05:30', NULL);
INSERT INTO public.sessions VALUES ('34a7e0a1-5db8-46ba-9a7d-5ce45fe56058', '72bad3bb-6097-47d2-bfc2-35b1244a7b9f', NULL, NULL, NULL, '2026-10-12 12:13:14.943+05:30', NULL, '2026-09-12 12:13:14.948+05:30', '11111111-1111-1111-1111-111111111111', '123485974d027e38d76b7cf29ac9a4d4056190c626739dada670519ed6092330', '2026-09-12 12:28:00.557+05:30', NULL);
INSERT INTO public.sessions VALUES ('353b1d63-b301-41f9-9fc1-5f2f8cdad845', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-12 12:30:14.639+05:30', NULL, '2026-09-12 12:30:14.641+05:30', '11111111-1111-1111-1111-111111111111', 'f92166b97d2c0fe42e084e0aea2a24f271d57cf12234dacb05798945ed861b31', '2026-09-12 12:30:14.641+05:30', NULL);
INSERT INTO public.sessions VALUES ('449ca986-b806-4b12-8e6d-e6ca72cb9e7c', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-12 16:04:44.751+05:30', NULL, '2026-09-12 16:04:44.755+05:30', '11111111-1111-1111-1111-111111111111', 'c0c7e3adf7b264f97165b30d5e029736e952f443ffba416059782d2c44abfff8', '2026-09-12 16:04:44.755+05:30', NULL);
INSERT INTO public.sessions VALUES ('4d9b3776-6d44-40a2-a224-cb3acc470e46', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, NULL, NULL, '2026-10-12 16:36:44.688+05:30', NULL, '2026-09-12 16:36:44.692+05:30', '11111111-1111-1111-1111-111111111111', '190913cc3cbee0de8474d99d01338d467dcc2d1d64c87108b8c558f02c9b6a3b', '2026-09-12 16:36:44.692+05:30', NULL);


--
-- Data for Name: special_notes; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.special_notes VALUES ('e187612c-dbc1-4e6c-acd0-76b1d9c5ba05', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Less Masala', 1, true, '2026-09-03 12:29:17.304401+05:30', '2026-09-03 12:29:17.304401+05:30');
INSERT INTO public.special_notes VALUES ('0117eea4-5f74-46a8-aee0-5616a64cb28a', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Extra Spicy', 2, true, '2026-09-03 12:29:17.306933+05:30', '2026-09-03 12:29:17.306933+05:30');
INSERT INTO public.special_notes VALUES ('d88e06d7-1419-4a47-a512-3ca62bf1ce13', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Jain Style (No Onion/Garlic)', 3, true, '2026-09-03 12:29:17.308276+05:30', '2026-09-03 12:29:17.308276+05:30');
INSERT INTO public.special_notes VALUES ('fbdb7cf0-4895-4549-ab4f-abcd6ac7a3b3', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Less Oil / Diet', 4, true, '2026-09-03 12:29:17.309581+05:30', '2026-09-03 12:29:17.309581+05:30');
INSERT INTO public.special_notes VALUES ('8a347a1b-5078-43de-8dba-9b96ca5d5963', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Crispy / Well Done', 5, true, '2026-09-03 12:29:17.310958+05:30', '2026-09-03 12:29:17.310958+05:30');
INSERT INTO public.special_notes VALUES ('b9db6f93-646f-482e-b837-38a53b02de24', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'No Sugar', 6, true, '2026-09-03 12:29:17.312257+05:30', '2026-09-03 12:29:17.312257+05:30');
INSERT INTO public.special_notes VALUES ('644356a6-ace0-40ed-b7e1-a67a65f0c3c3', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Quick / VIP Priority', 7, true, '2026-09-03 12:29:17.313508+05:30', '2026-09-03 12:29:17.313508+05:30');


--
-- Data for Name: stations; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.stations VALUES ('eebe76a3-8305-409d-877b-bb5a0e2b7328', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'GRILL', '192.168.1.101', '2026-09-02 14:45:15.256+05:30', '2026-09-02 16:21:33.157+05:30', NULL, NULL, 600, 900);
INSERT INTO public.stations VALUES ('42dcfe23-879e-4b2a-be32-34ac8217c08a', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'FRYER', '192.168.1.102', '2026-09-02 14:45:15.265+05:30', '2026-09-02 16:21:33.162+05:30', NULL, NULL, 600, 900);
INSERT INTO public.stations VALUES ('c0e956a7-c8ed-448a-95b1-a7bfaf01ff64', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'PANTRY', '192.168.1.103', '2026-09-02 14:45:15.271+05:30', '2026-09-02 16:21:33.167+05:30', NULL, NULL, 600, 900);
INSERT INTO public.stations VALUES ('764d2958-6b03-43c0-b066-586fb8efb9f5', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'BAR', '192.168.1.104', '2026-09-02 14:45:15.276+05:30', '2026-09-02 16:21:33.172+05:30', NULL, NULL, 600, 900);
INSERT INTO public.stations VALUES ('b683fe60-8afe-43d8-8dca-9e47bcd8f771', '2a543c3c-066f-4097-833a-df7c25700580', 'KITCHEN', '192.168.1.101', '2026-09-02 16:33:25.787+05:30', '2026-09-02 16:33:25.787+05:30', NULL, NULL, 600, 900);
INSERT INTO public.stations VALUES ('ace502a5-a767-442e-856d-9eefe5cdc905', '2a543c3c-066f-4097-833a-df7c25700580', 'BAR', '192.168.1.102', '2026-09-02 16:33:25.793+05:30', '2026-09-02 16:33:25.793+05:30', NULL, NULL, 600, 900);
INSERT INTO public.stations VALUES ('abdc7979-a559-4c93-baa9-3306ab6cae04', '2a543c3c-066f-4097-833a-df7c25700580', 'DOSA_SECTION', '192.168.1.103', '2026-09-02 16:33:25.797+05:30', '2026-09-02 16:33:25.797+05:30', NULL, NULL, 600, 900);


--
-- Data for Name: sync_jobs; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: sync_state; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: table_merge_groups; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.table_merge_groups VALUES ('afe6e795-9bf1-4d7b-93ba-24db0c8ad017', '11111111-1111-1111-1111-111111111111', '1bb0a59d-079d-4406-8bd9-0fd2f4a7668e', 'ACTIVE', 8, NULL, '2026-09-05 16:53:25.402+05:30', NULL, '9b35fd7a-2717-4837-ad91-9328aee9ec5f', NULL);


--
-- Data for Name: table_merge_members; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.table_merge_members VALUES ('6c0711c8-c5a9-4e8e-b7e6-02cbeec9ac92', '11111111-1111-1111-1111-111111111111', 'afe6e795-9bf1-4d7b-93ba-24db0c8ad017', 'bb01f08e-7a9d-43b3-acce-be35218b3f27', false, '2026-09-05 16:53:25.462+05:30', NULL);
INSERT INTO public.table_merge_members VALUES ('92f144e9-b608-4d7d-832e-6cd21d76ba43', '11111111-1111-1111-1111-111111111111', 'afe6e795-9bf1-4d7b-93ba-24db0c8ad017', '1bb0a59d-079d-4406-8bd9-0fd2f4a7668e', true, '2026-09-05 16:53:25.511+05:30', NULL);


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

INSERT INTO public.tax_channel_rules VALUES ('949bd3e0-6bb2-458a-b815-4784726e9264', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'a7580b0e-4ecd-49da-a1c2-9681c9e54ab0', 'dine_in', 'backward', true, '2026-09-03 12:29:17.349423+05:30', '2026-09-03 12:29:17.349423+05:30');
INSERT INTO public.tax_channel_rules VALUES ('1b50671c-db6f-4c01-a060-3c5524ed676f', '67315042-c687-4cbb-b45a-f4ea4efc199f', '90067bbf-bfc8-4acb-beeb-c77a6bd641dd', 'dine_in', 'backward', true, '2026-09-03 12:29:17.352824+05:30', '2026-09-03 12:29:17.352824+05:30');
INSERT INTO public.tax_channel_rules VALUES ('d4af1b9e-c1f7-4136-a210-990d7e89c880', '67315042-c687-4cbb-b45a-f4ea4efc199f', '0df998c6-f54a-4765-b358-3242e31058eb', 'online', 'forward', true, '2026-09-03 12:29:17.354605+05:30', '2026-09-03 12:29:17.354605+05:30');
INSERT INTO public.tax_channel_rules VALUES ('624febe1-d253-416b-a2e2-3a79371297ea', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'fdd8e337-00f4-408f-8cc7-e5eac5b8ac37', 'online', 'forward', true, '2026-09-03 12:29:17.356514+05:30', '2026-09-03 12:29:17.356514+05:30');


--
-- Data for Name: taxes; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.taxes VALUES ('a7580b0e-4ecd-49da-a1c2-9681c9e54ab0', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'CGST', 2.500, true, '2026-09-03 12:29:17.315224+05:30', '2026-09-03 12:29:17.315224+05:30');
INSERT INTO public.taxes VALUES ('90067bbf-bfc8-4acb-beeb-c77a6bd641dd', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'SGST', 2.500, true, '2026-09-03 12:29:17.326605+05:30', '2026-09-03 12:29:17.326605+05:30');
INSERT INTO public.taxes VALUES ('0df998c6-f54a-4765-b358-3242e31058eb', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'CGST [Online]', 2.500, true, '2026-09-03 12:29:17.327756+05:30', '2026-09-03 12:29:17.327756+05:30');
INSERT INTO public.taxes VALUES ('fdd8e337-00f4-408f-8cc7-e5eac5b8ac37', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'SGST [Online]', 2.500, true, '2026-09-03 12:29:17.32927+05:30', '2026-09-03 12:29:17.32927+05:30');


--
-- Data for Name: terminals; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.terminals VALUES ('6c4c8546-d1f3-461a-ad4b-3928d6be8ba9', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'T-01', 'Main Cashier Counter T-01', true, NULL, NULL, '2026-09-02 14:45:15.197+05:30', '2026-09-02 16:21:33.122+05:30');
INSERT INTO public.terminals VALUES ('fd2ff197-9813-4af4-9b66-9642316df599', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'T-02', 'Express Bar Terminal T-02', true, NULL, NULL, '2026-09-02 14:45:15.206+05:30', '2026-09-02 16:21:33.125+05:30');
INSERT INTO public.terminals VALUES ('388498f3-d8e6-4d16-9b4a-fa0a79e9692f', '2a543c3c-066f-4097-833a-df7c25700580', 'T-01', 'Master POS Terminal T-01', true, NULL, NULL, '2026-09-02 16:33:25.655+05:30', '2026-09-02 16:33:25.655+05:30');
INSERT INTO public.terminals VALUES ('5ec4f6d9-7fa6-42a9-a2a3-ec6c42fe0de4', '2a543c3c-066f-4097-833a-df7c25700580', 'cp4', 'Captain Mobile Station cp4', true, NULL, NULL, '2026-09-02 16:33:25.664+05:30', '2026-09-02 16:33:25.664+05:30');


--
-- Data for Name: user_quick_links; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: user_report_preferences; Type: TABLE DATA; Schema: public; Owner: pos
--



--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.user_roles VALUES ('02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', '11111111-1111-1111-1111-111111111101', NULL, '2026-09-02 14:45:15.60678+05:30', NULL, '2026-09-02 14:45:15.606+05:30', NULL);
INSERT INTO public.user_roles VALUES ('ed8a2f35-4fcf-444b-b6d0-e6808c435e06', '11111111-1111-1111-1111-111111111104', NULL, '2026-09-02 14:45:15.835884+05:30', NULL, '2026-09-02 14:45:15.835+05:30', NULL);
INSERT INTO public.user_roles VALUES ('918df673-2606-403a-9fad-1c54870d1fce', '11111111-1111-1111-1111-111111111105', NULL, '2026-09-02 14:45:16.06048+05:30', NULL, '2026-09-02 14:45:16.06+05:30', NULL);
INSERT INTO public.user_roles VALUES ('00a94815-6158-4c07-9bcd-4b540aa79b1b', '11111111-1111-1111-1111-111111111103', NULL, '2026-09-03 12:05:43.146453+05:30', NULL, '2026-09-03 12:05:43.146453+05:30', NULL);
INSERT INTO public.user_roles VALUES ('9b35fd7a-2717-4837-ad91-9328aee9ec5f', '11111111-1111-1111-1111-111111111106', NULL, '2026-09-03 12:05:43.154773+05:30', NULL, '2026-09-03 12:05:43.154773+05:30', NULL);
INSERT INTO public.user_roles VALUES ('8b31cbda-6588-420f-8283-6f137a1b6e49', '11111111-1111-1111-1111-111111111107', NULL, '2026-09-03 12:05:43.157903+05:30', NULL, '2026-09-03 12:05:43.157903+05:30', NULL);
INSERT INTO public.user_roles VALUES ('2d214592-ed35-4e7a-ad34-fca203227853', '11111111-1111-1111-1111-111111111108', NULL, '2026-09-03 12:05:43.162537+05:30', NULL, '2026-09-03 12:05:43.162537+05:30', NULL);
INSERT INTO public.user_roles VALUES ('aa61bb1d-e70f-4e28-9830-42b7a3511212', '11111111-1111-1111-1111-111111111109', NULL, '2026-09-03 12:05:43.165845+05:30', NULL, '2026-09-03 12:05:43.165845+05:30', NULL);
INSERT INTO public.user_roles VALUES ('cf8faac6-732e-4a32-a5bd-03919f06ed5f', '11111111-1111-1111-1111-111111111106', '2a543c3c-066f-4097-833a-df7c25700580', '2026-09-08 14:08:12.871986+05:30', NULL, '2026-09-08 14:08:12.871986+05:30', NULL);
INSERT INTO public.user_roles VALUES ('5e635b7d-856a-40b8-8a8c-1398f74eca30', '11111111-1111-1111-1111-111111111106', NULL, '2026-09-11 12:00:20.652583+05:30', NULL, '2026-09-11 12:00:20.652583+05:30', NULL);
INSERT INTO public.user_roles VALUES ('72bad3bb-6097-47d2-bfc2-35b1244a7b9f', '11111111-1111-1111-1111-111111111106', NULL, '2026-09-11 12:00:20.661925+05:30', NULL, '2026-09-11 12:00:20.661925+05:30', NULL);
INSERT INTO public.user_roles VALUES ('5c660c1f-f5f8-4007-87a6-b4b39913998b', '11111111-1111-1111-1111-111111111106', NULL, '2026-09-11 12:00:20.668673+05:30', NULL, '2026-09-11 12:00:20.668673+05:30', NULL);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.users VALUES ('aa61bb1d-e70f-4e28-9830-42b7a3511212', 'accountant@hotelkapila.com', NULL, '', '$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.', false, true, '2026-09-03 12:05:43.164336+05:30', '2026-09-03 12:05:43.164336+05:30', NULL, NULL, 'Suresh', 'Iyer', '$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.');
INSERT INTO public.users VALUES ('cf8faac6-732e-4a32-a5bd-03919f06ed5f', 'test@hotelkapila.com', NULL, '', '$2a$10$bLmkjzBUaxPcCyvby29z0uhpM502QOEifyY8RSe15vQHsmRWeqnAu', false, true, '2026-09-08 14:08:12.874+05:30', '2026-09-08 14:08:12.874+05:30', '02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', NULL, 'test', 'd', NULL);
INSERT INTO public.users VALUES ('5e635b7d-856a-40b8-8a8c-1398f74eca30', 'ramesh@hotelkapila.com', '+91 9876543201', '', '$2a$10$ZDLxmN70Y9iGFQzws6.7Keih1MrVQnVFafIVtAUw4B/fpoAplqnTO', false, true, '2026-09-11 12:00:20.63+05:30', '2026-09-11 12:00:20.63+05:30', NULL, NULL, 'Ramesh', 'Kumar', '$2a$10$ZDLxmN70Y9iGFQzws6.7Kei/bmfLk0Hrq0Ue5UuyEZPhE47kdUGzS');
INSERT INTO public.users VALUES ('72bad3bb-6097-47d2-bfc2-35b1244a7b9f', 'suresh@hotelkapila.com', '+91 9876543202', '', '$2a$10$ZDLxmN70Y9iGFQzws6.7Keih1MrVQnVFafIVtAUw4B/fpoAplqnTO', false, true, '2026-09-11 12:00:20.658+05:30', '2026-09-11 12:00:20.658+05:30', NULL, NULL, 'Suresh', 'Patel', '$2a$10$ZDLxmN70Y9iGFQzws6.7Kei/bmfLk0Hrq0Ue5UuyEZPhE47kdUGzS');
INSERT INTO public.users VALUES ('5c660c1f-f5f8-4007-87a6-b4b39913998b', 'mahesh@hotelkapila.com', '+91 9876543203', '', '$2a$10$ZDLxmN70Y9iGFQzws6.7Keih1MrVQnVFafIVtAUw4B/fpoAplqnTO', false, true, '2026-09-11 12:00:20.664+05:30', '2026-09-11 12:00:20.664+05:30', NULL, NULL, 'Mahesh', 'Verma', '$2a$10$ZDLxmN70Y9iGFQzws6.7Kei/bmfLk0Hrq0Ue5UuyEZPhE47kdUGzS');
INSERT INTO public.users VALUES ('02be4e03-a6fc-4ec7-acd3-f6a7f37f2edc', 'admin@hotelkapila.com', NULL, '', '$2a$10$PLdpSKvm2v9Os/H1QCW.OuvFOz8DsVVeAz7Ep62oj2ZKXL6KjWM9C', false, true, '2026-09-02 14:45:15.536+05:30', '2026-09-02 16:21:33.411+05:30', NULL, NULL, 'Abdul', 'Mannan', '$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.');
INSERT INTO public.users VALUES ('00a94815-6158-4c07-9bcd-4b540aa79b1b', 'manager@hotelkapila.com', NULL, '', '$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.', false, true, '2026-09-03 12:05:43.144931+05:30', '2026-09-03 12:05:43.144931+05:30', NULL, NULL, 'Rajesh', 'Sharma', '$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.');
INSERT INTO public.users VALUES ('ed8a2f35-4fcf-444b-b6d0-e6808c435e06', 'cashier@hotelkapila.com', NULL, '', '$2a$10$PLdpSKvm2v9Os/H1QCW.OuvFOz8DsVVeAz7Ep62oj2ZKXL6KjWM9C', false, true, '2026-09-02 14:45:15.832+05:30', '2026-09-02 16:21:33.641+05:30', NULL, NULL, 'Kapila', 'Cashier', '$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.');
INSERT INTO public.users VALUES ('918df673-2606-403a-9fad-1c54870d1fce', 'chef@hotelkapila.com', NULL, '', '$2a$10$PLdpSKvm2v9Os/H1QCW.OuvFOz8DsVVeAz7Ep62oj2ZKXL6KjWM9C', false, true, '2026-09-02 14:45:16.057+05:30', '2026-09-02 16:21:33.861+05:30', NULL, NULL, 'Head', 'Chef', '$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.');
INSERT INTO public.users VALUES ('9b35fd7a-2717-4837-ad91-9328aee9ec5f', 'waiter@hotelkapila.com', NULL, '', '$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.', false, true, '2026-09-03 12:05:43.153518+05:30', '2026-09-03 12:05:43.153518+05:30', NULL, NULL, 'Rahul', 'Kumar', '$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.');
INSERT INTO public.users VALUES ('8b31cbda-6588-420f-8283-6f137a1b6e49', 'delivery@hotelkapila.com', NULL, '', '$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.', false, true, '2026-09-03 12:05:43.15632+05:30', '2026-09-03 12:05:43.15632+05:30', NULL, NULL, 'Amit', 'Verma', '$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.');
INSERT INTO public.users VALUES ('2d214592-ed35-4e7a-ad34-fca203227853', 'inventory@hotelkapila.com', NULL, '', '$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.', false, true, '2026-09-03 12:05:43.16032+05:30', '2026-09-03 12:05:43.16032+05:30', NULL, NULL, 'Vikram', 'Patel', '$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.');


--
-- Data for Name: vendors; Type: TABLE DATA; Schema: public; Owner: pos
--

INSERT INTO public.vendors VALUES ('c65516bd-e4e1-42ad-9c31-165b0510d1f8', '67315042-c687-4cbb-b45a-f4ea4efc199f', 'Metro Cash & Carry', NULL, NULL, NULL, NULL, true, '2026-09-02 16:30:20.959+05:30', '2026-09-02 16:30:20.959+05:30', NULL, NULL, '9876543210', 'sales@metro.co.in', '29AAECM1234N1Z5', NULL, NULL);


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

\unrestrict Vhjfr4WZgVnPxUo24qIF1HkZlcTEnZe77lgaXbfG1MW3mIR1ccicBhrI1mrdBfP

