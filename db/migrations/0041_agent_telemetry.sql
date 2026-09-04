-- 0041: Agent Telemetry table for multi-agent A2A orchestration
--
-- Backs the Multi-Agent Operational Board and A2A telemetry endpoints:
-- GET /admin/agents/status and POST /admin/agents/heartbeat
--
-- Idempotent and safe to apply on top of any existing database schema.

BEGIN;

CREATE TABLE IF NOT EXISTS agent_telemetry (
    id             VARCHAR(64) PRIMARY KEY,
    name           VARCHAR(128) NOT NULL,
    role           VARCHAR(64) NOT NULL,
    status         VARCHAR(32) NOT NULL DEFAULT 'ONLINE',
    domain         TEXT NOT NULL,
    port           INTEGER,
    latency_ms     INTEGER NOT NULL DEFAULT 0,
    health         VARCHAR(32) NOT NULL DEFAULT 'Passing',
    current_task   TEXT NOT NULL,
    metrics        JSONB,
    assigned_files JSONB,
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Seed initial 8 autonomous system agents
INSERT INTO agent_telemetry (
    id, name, role, status, domain, port, latency_ms, health, current_task, metrics, assigned_files, updated_at
) VALUES
(
    'agent-orchestrator',
    'Orchestrator Agent',
    'SYSTEM_COORDINATOR',
    'ONLINE',
    'Cross-System Workflow Coordination & Port Management (4001, 4444, 5432)',
    4001,
    1,
    'Passing',
    'Supervising backend, frontend and persistence processes',
    '{"apiPort": 4001, "posPort": 4444, "dbPort": 5432, "supervisor": "active"}'::jsonb,
    '["scripts/startup.ps1", "scripts/shutdown.ps1", "scripts/status.ts", "Start_PetPooja.bat"]'::jsonb,
    NOW()
),
(
    'agent-a2a',
    'A2A Coordination Agent',
    'A2A_COORDINATOR',
    'ONLINE',
    'Inter-Agent Protocol, State Sync & Admin Hub Telemetry',
    4001,
    2,
    'Passing',
    'Routing inter-agent WebSocket topics and aggregating live telemetry',
    '{"activeAgents": 8, "protocolVersion": "2.0", "syncChannels": ["HTTP", "WS", "REGISTRY"]}'::jsonb,
    '["agents/a2a-agent.md", "agents/AGENT_REGISTRY.json", "agents/task-board.json", "apps/api/src/routes/admin.ts", "apps/pos-web/pages/admin.tsx"]'::jsonb,
    NOW()
),
(
    'agent-frontend',
    'Frontend UI Agent',
    'UI_ENGINEER',
    'ONLINE',
    'POS Web UI (Port 4444) & Admin Management Consoles',
    4444,
    3,
    'Passing',
    'Serving KapMeta POS shell, touch billing, KDS board & executive admin',
    '{"posPort": 4444, "bundleOptimized": true, "touchSupport": true}'::jsonb,
    '["apps/pos-web/pages/*", "apps/pos-web/components/*", "apps/pos-web/lib/auth.ts"]'::jsonb,
    NOW()
),
(
    'agent-backend',
    'Backend API Agent',
    'BACKEND_ENGINEER',
    'ONLINE',
    'API Gateway (Port 4001), Services & Event Bus',
    4001,
    2,
    'Passing',
    'Routing HTTP endpoints, JWT claim verification, and event subscriptions',
    '{"apiPort": 4001, "activeRoutes": 18, "jwtScoping": "outlet_id"}'::jsonb,
    '["apps/api/src/index.ts", "apps/api/src/routes/*", "services/*"]'::jsonb,
    NOW()
),
(
    'agent-database',
    'Database Persistence Agent',
    'DBA_ENGINEER',
    'ONLINE',
    'PostgreSQL (Port 5432) & Prisma Multi-Tenant Schema',
    5432,
    1,
    'Passing',
    'Maintaining multi-tenant schema, seed tools, and backup parity',
    '{"dbPort": 5432, "poolConnections": 10, "minorUnitStandard": "BIGINT paise"}'::jsonb,
    '["kapmeta/schema.prisma", "scripts/db-migrate.js", "scripts/seed-dynamic-data.ts"]'::jsonb,
    NOW()
),
(
    'agent-integration',
    'Integration Hub Agent',
    'INTEGRATION_ENGINEER',
    'ONLINE',
    'Online Aggregators (Swiggy/Zomato), Payments & Thermal Printers',
    4001,
    4,
    'Passing',
    'Handling HMAC webhooks, idempotent ingestion, and DLQ retries',
    '{"supportedChannels": ["SWIGGY", "ZOMATO"], "webhookActive": true}'::jsonb,
    '["services/integration-hub/*", "services/integration/*"]'::jsonb,
    NOW()
),
(
    'agent-qa',
    'QA & Verification Agent',
    'TEST_ENGINEER',
    'ONLINE',
    'Unit Tests, Contract Validation & E2E Simulation',
    4001,
    5,
    'Passing',
    'Running vitest suites, type validation, and pilot simulation drills',
    '{"testsPassing": 55, "pilotDrills": "ENABLED", "e2eValidation": true}'::jsonb,
    '["tests/*", "scripts/pilot-e2e-simulation.ts", "vitest.config.ts"]'::jsonb,
    NOW()
),
(
    'agent-sre',
    'SRE & Diagnostics Agent',
    'SRE_ENGINEER',
    'ONLINE',
    'Log Management, Process Monitoring & Diagnostics',
    4001,
    2,
    'Passing',
    'Monitoring logs/ directory, service heartbeats, and error traces',
    '{"logScanner": "active", "healthChecksPassing": true}'::jsonb,
    '["logs/*", "scripts/status.ts"]'::jsonb,
    NOW()
)
ON CONFLICT (id) DO UPDATE SET
    name = EXCLUDED.name,
    role = EXCLUDED.role,
    status = EXCLUDED.status,
    domain = EXCLUDED.domain,
    port = EXCLUDED.port,
    latency_ms = EXCLUDED.latency_ms,
    health = EXCLUDED.health,
    current_task = EXCLUDED.current_task,
    metrics = EXCLUDED.metrics,
    assigned_files = EXCLUDED.assigned_files,
    updated_at = NOW();

COMMIT;
