---
name: Proyectos de REBUSS
description: Cuatro sistemas internos — admin, counter, scanner, assets — y un repo de gestión (dev). Stack y estado resumido.
type: project
created: 2026-04-21
updated: 2026-04-21
---

# Sistemas de REBUSS

REBUSS es una empresa chilena de servicio de toma de inventarios de activos en retail (Chile, Brasil, Argentina, Costa Rica, Guatemala, Honduras, Nicaragua). Flujo de un inventario: gestión comercial → planificación → ejecución → entrega → post-inventario.

Los sistemas intervienen así: **counter** y **scanner** en captura, **admin** en planificación/monitoreo/evaluación.

## admin (rebusscorp/admin)

- Sistema central cloud de administración, planificación y evaluación.
- Stack: Rails 5.2.8, Ruby 2.7.8, PostgreSQL 12, Redis, Sidekiq.
- Infra: AWS (EC2 + RDS + Route 53), Caddy + Certbot, New Relic + Google Chat.
- Deploy: Capistrano (SSH) → `admin.rebuss.com`, path `/mnt/app`. Alias `deploy` = `git push && cap production deploy`.
- Devcontainer services: app, cache (Redis), db (Postgres), mailer (Mailcatcher), scrapper (Selenium).
- Sentry: sentry-ruby + sentry-rails + sentry-sidekiq.
- Responsable principal: mestrada (data, reportes, High Dollar/Marbetes), arubilar (admin, auditoría, issues operativos).

## counter (rebusscorp/counter)

- App local en notebooks (~100+, Ubuntu 20.04) para inventarios en terreno. Operativo desde 2015.
- Stack: Rails 4.2.11.3, Ruby 2.7.8, PostgreSQL 12 embebido, Redis.
- Staging: Vagrant + libvirt/KVM. Deploy: bash + Ansible.
- Sentry: solo sentry-ruby (rails 4.2 no soporta sentry-rails); `rescue_from StandardError` en ApplicationController; tag por hostname.
- Modelo clave: `productos`, `codigos_de_barra`, `capturas`, `existencias`, `zonas`, `tags`.
- Archivos críticos con deuda: `captura.rb` (+870 líneas), `capturas_controller.rb` (+758 líneas).
- Sistema de extensiones en `/lib/extensions` para customización por país/cliente.
- Integración con admin vía 3 endpoints REST: descarga de inventario, monitoreo, cierre.
- Estado: maduro, foco en estabilización, 0% cobertura. RSpec elegido como framework.
- Responsables: atenente (Brasil, DPSP), mgil (soporte, alertas operativas).

## scanner (rebusscorp/scanner)

- Apps móviles para handhelds lectoras. Dos subproyectos:
  - **Scandroid** (activo): Android (Unitech), Kotlin, Gradle, Fuel 2.3.1, SQLite, OpenCSV 4.6. Min SDK 24, Target 29. Versión 5.5.0. Sin AndroidX; arquitectura Activity-based directa.
  - **Scannet** (legacy): Windows CE (Unitech), VB.NET Compact Framework. Casi sin cambios.
- Operación en terreno: WiFi local `REBUSSINVENTARIO`, rango `10.200.*.*`. HTTP directo al counter local. Transferencia alternativa vía USB.
- ~57 archivos de customización para ~20 clientes bajo `customer/{país}/{cliente}/` — patrón copy & paste (deuda).
- BDs locales SQLite: `products`, `configurations`, `records`, `users`, `locations`, `network_devices`, `mapping`, `user_mapping`, `log_errors`.
- Deudas reconocidas: duplicación por cliente, migración a AndroidX, adoptar MVVM + Repository.

## assets

- Sistema para gestión de activos fijos. En beta; varias funciones pendientes.
- Stack: Linux + Rails + PostgreSQL.
- Prioridad de desarrollo pendiente: integración con counter para provisionamiento y consolidación de datos capturados.

## dev (rebusscorp/dev)

- Repo de gestión: issues centralizados, documentación técnica, templates. Admin y counter tienen issues deshabilitados en GitHub; todo se tramita aquí.
- Fuente canónica de referencia para arquitectura, procedimientos y roadmap — ver memoria `reference_dev_repo`.

## Infraestructura compartida

- **VPN WireGuard**: `gw.rebuss.com` (EC2, Ubuntu 24.04), subnet `10.100.0.0/24`, `.1`=gateway, `.2`=admin, `.3–.254`=counters/devs. Split-tunnel. Reverse proxy nginx mapea `<server_name>.counter.rebuss.com` → IP VPN del counter.
- **Netskope VPN**: cliente Lojas Renner.
- Admin expone endpoints `vpn_register`, `vpn_status`, `ssh_config`. Servicio `WireguardManager` gestiona peers vía SSH.

## Cómo actualizar esta memoria

Verificar contra el repo dev en `~/repos/dev` cuando haya dudas; ese repo es la fuente canónica. Actualizar aquí solo cuando cambie el estado estratégico o estructural. Detalles operativos detallados viven en el dev repo.
